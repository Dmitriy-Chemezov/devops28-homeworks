# Домашнее задание к занятию «Файловые системы»

### Цель задания

В результате выполнения задания вы: 

* научитесь работать с инструментами разметки жёстких дисков, виртуальных разделов — RAID-массивами и логическими томами, конфигурациями файловых систем. Основная задача — понять, какие слои абстракций могут нас отделять от файловой системы до железа. Обычно инженер инфраструктуры не сталкивается напрямую с настройкой LVM или RAID, но иметь понимание, как это работает, необходимо;
* создадите нештатную ситуацию работы жёстких дисков и поймёте, как система RAID обеспечивает отказоустойчивую работу.


### Чеклист готовности к домашнему заданию

1. Убедитесь, что у вас на новой виртуальной машине  установлены утилиты: `mdadm`, `fdisk`, `sfdisk`, `mkfs`, `lsblk`, `wget` (шаг 3 в задании).  
2. Воспользуйтесь пакетным менеджером apt для установки необходимых инструментов.


### Дополнительные материалы для выполнения задания

1. Разряженные файлы — [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB).
2. [Подробный анализ производительности RAID](https://www.baarf.dk/BAARF/0.Millsap1996.08.21-VLDB.pdf), страницы 3–19.
3. [RAID5 write hole](https://www.intel.com/content/www/us/en/support/articles/000057368/memory-and-storage.html).


------

## Задание

1. Узнайте о [sparse-файлах](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных).

    > Разрежённый файл (англ. sparse file) — файл, в котором последовательности нулевых байтов[1] заменены на информацию об этих последовательностях (список дыр).
    > Дыра (англ. hole) — последовательность нулевых байт внутри файла, не записанная на диск. Информация о дырах (смещение от начала файла в байтах и количество байт) хранится в метаданных ФС.
    
    > Преимущества:
    
    > экономия дискового пространства. 
    
    > Использование разрежённых файлов считается одним из способов сжатия данных на уровне файловой системы;
    
    > отсутствие временных затрат на запись нулевых байт;
    
    > увеличение срока службы запоминающих устройств.
    
    >Недостатки:

    > накладные расходы на работу со списком дыр;
    
    > фрагментация файла при частой записи данных в дыры;
    
    > невозможность записи данных в дыры при отсутствии свободного места на диске;
    
    > невозможность использования других индикаторов дыр, кроме нулевых байт.


1. Могут ли файлы, являющиеся жёсткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

    > Жесткая ссылка и файл, для которого она создавалась имеют одинаковые inode. Поэтому жесткая ссылка имеет те же права доступа, владельца и время последней модификации, что и целевой файл.

1. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```ruby
    path_to_disk_folder = './disks'

    host_params = {
        'disk_size' => 2560,
        'disks'=>[1, 2],
        'cpus'=>2,
        'memory'=>2048,
        'hostname'=>'sysadm-fs',
        'vm_name'=>'sysadm-fs'
    }
    Vagrant.configure("2") do |config|
        config.vm.box = "bento/ubuntu-20.04"
        config.vm.hostname=host_params['hostname']
        config.vm.provider :virtualbox do |v|

            v.name=host_params['vm_name']
            v.cpus=host_params['cpus']
            v.memory=host_params['memory']

            host_params['disks'].each do |disk|
                file_to_disk=path_to_disk_folder+'/disk'+disk.to_s+'.vdi'
                unless File.exist?(file_to_disk)
                    v.customize ['createmedium', '--filename', file_to_disk, '--size', host_params['disk_size']]
                end
                v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', disk.to_s, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
            end
        end
        config.vm.network "private_network", type: "dhcp"
    end
    ```

    Эта конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2,5 Гб.

    > Получаем такую систему.
    
    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/1.png)
    

1. Используя `fdisk`, разбейте первый диск на два раздела: 2 Гб и оставшееся пространство.

    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/2.png)

1. Используя `sfdisk`, перенесите эту таблицу разделов на второй диск.

    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/3.png)

1. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/4.png)

1. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/5.png)

1. Создайте два независимых PV на получившихся md-устройствах.

    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/6.png)

1. Создайте общую volume-group на этих двух PV.

    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/7.png)

1. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/8.png)

1. Создайте `mkfs.ext4` ФС на получившемся LV.

    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/9.png)

1. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/10.png)

1. Поместите туда тестовый файл, например, `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/11.png)

1. Прикрепите вывод `lsblk`.

    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/12.png)

1. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```

    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/13.png)

1. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/14.png)

1. Сделайте `--fail` на устройство в вашем RAID1 md.

    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/15.png)

1. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/16.png)

1. Протестируйте целостность файла — он должен быть доступен несмотря на «сбойный» диск:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/17.png)

1. Погасите тестовый хост — `vagrant destroy`.
 
    ![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/03-sysadmin-05-fs/18.png)

*В качестве решения пришлите ответы на вопросы и опишите, как они были получены.*

----

### Правила приёма домашнего задания

В личном кабинете отправлена ссылка на .md-файл в вашем репозитории.


### Критерии оценки

Зачёт:

* выполнены все задания;
* ответы даны в развёрнутой форме;
* приложены соответствующие скриншоты и файлы проекта;
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку:

* задание выполнено частично или не выполнено вообще;
* в логике выполнения заданий есть противоречия и существенные недостатки. 

# Домашнее задание к занятию 2. «Применение принципов IaaC в работе с виртуальными машинами»

## Как сдавать задания

Обязательны к выполнению задачи без звёздочки. Их нужно выполнить, чтобы получить зачёт и диплом о профессиональной переподготовке.

Задачи со звёздочкой (*) — дополнительные задачи и/или задачи повышенной сложности. Их выполнять не обязательно, но они помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в GitHub-репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---


## Важно

Перед отправкой работы на проверку удаляйте неиспользуемые ресурсы.
Это нужно, чтобы не расходовать средства, полученные в результате использования промокода.

Подробные рекомендации [здесь](https://github.com/netology-code/virt-homeworks/blob/virt-11/r/README.md).

---

## Задача 1

- Опишите основные преимущества применения на практике IaaC-паттернов.

Паттерны — это способ построения (структуризации) программного кода специальным образом. На практике они используются программистами для того, чтобы решить какую-нибудь проблему, устранить определенную «боль» разработчика. В этом случае предполагается, что существует некоторый перечень общих формализованных проблем (а это так и есть), причем данные проблемы встречаются относительно часто. И вот здесь-то на сцену и выходят паттерны, которые как раз таки и предоставляют способы решения этих проблем.

Преимущество применения паттернов IaaС на практике это возможность единожды описав инфраструктуру многократно её воспроизводить, производить развёртывние идентичных сервера/сред для тестирования/разработки, масштабирование при необходимости. Следующим преимуществом является автоматизация рутинных действий что приводит к снижению трудозатрат на их выполнение - как следствие повышается скорость разработки, выявления и устранения дефектов за счёт более раннего их обнаружения и тестирования на этапе сборки. Автоматизация поставки - позволяет сократить время от этапа разработки до внедрения. Паттерны IaaC позволяют стандартизировать развёртывание инфраструктуры, что снижает вероятность появления ошибок или отклонений связанных с человеческим фактором.

Применение на практике IaaC паттернов позволяет ускорить процесс разработки, снизить трудозатраты на поиск и устранение дефектов, организовать непрерывную поставку продукта
  
- Какой из принципов IaaC является основополагающим?

Идемпотентность операций - свойство сценария/операции позволяющее многократно получать/воспроизводить одно и то же состояние объекта (среды) что и при первом применении, т.е. не зависимо от того сколько раз будет проигран сценарий, результат всегда будет идентичен результату полученному в первый раз.

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?

Его основные преимущества это использование SSH инфраструктуры без установки дополнительного окружения, а также наличие большого количества модулей.
  
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный — push или pull?

Система конфигурации pull требует установки агентов на управляемых серверах и более подходит для небольшого количества управляемых сервреров, когда есть возможность установки данных агентов на все окружение.

Система конфигурации push не требует установки агентов и может работать с окружением без установки дополнительного софта. Больше подходит для работы с большим количеством управляемых серверов.

## Задача 3

Установите на личный компьютер:

- [VirtualBox](https://www.virtualbox.org/),
```
odin@ASUS-TUF-Gaming:~$ vboxmanage --version
6.1.40r154048
```

- [Vagrant](https://github.com/netology-code/devops-materials),  
```
odin@ASUS-TUF-Gaming:~$ vagrant -v
Vagrant 2.2.19
```

- [Terraform](https://github.com/netology-code/devops-materials/blob/master/README.md),
```
odin@ASUS-TUF-Gaming:~$ terraform --version
Terraform v1.5.0
on linux_amd64
```

- Ansible.
```
odin@ASUS-TUF-Gaming:~$ ansible --version
ansible 2.10.8
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/odin/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.10.6 (main, May 29 2023, 11:10:38) [GCC 11.3.0]
```

*Приложите вывод команд установленных версий каждой из программ, оформленный в Markdown.*

## Задача 4 

Воспроизведите практическую часть лекции самостоятельно.

- Создайте виртуальную машину.
- Зайдите внутрь ВМ, убедитесь, что Docker установлен с помощью команды
```
docker ps,
```
Vagrantfile из лекции и код ansible находятся в [папке](https://github.com/netology-code/virt-homeworks/tree/virt-11/05-virt-02-iaac/src).

![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/05-virt-02-iaac/1.png)

![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/05-virt-02-iaac/2.png)


Примечание. Если Vagrant выдаёт ошибку:
```
URL: ["https://vagrantcloud.com/bento/ubuntu-20.04"]     
Error: The requested URL returned error: 404:
```

выполните следующие действия:

1. Скачайте с [сайта](https://app.vagrantup.com/bento/boxes/ubuntu-20.04) файл-образ "bento/ubuntu-20.04".
2. Добавьте его в список образов Vagrant: "vagrant box add bento/ubuntu-20.04 <путь к файлу>".

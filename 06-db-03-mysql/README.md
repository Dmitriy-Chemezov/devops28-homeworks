# Домашнее задание к занятию 3. «MySQL»

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/blob/virt-11/additional/README.md).

## Задача 1

Используя Docker, поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

```                                                                                             
┌──(odin㉿sys-kali)-[~/docker-mysql]
└─$ docker pull mysql:8.0  
8.0: Pulling from library/mysql
b193354265ba: Pull complete 
14a15c0bb358: Pull complete 
02da291ad1e4: Pull complete 
9a89a1d664ee: Pull complete 
a24ae6513051: Pull complete 
5110d0b8df84: Pull complete 
71def905d921: Pull complete 
c29c4f8eb3c1: Pull complete 
769af171cdaa: Pull complete 
c1a0ba6abbff: Pull complete 
5e7e1ae11403: Pull complete 
Digest: sha256:f0e71f077bb27fe17b1b9551f75d1b35ad4dfe3a33c82412acf19684790f3a30
Status: Downloaded newer image for mysql:8.0
docker.io/library/mysql:8.0
                                                                                             
┌──(odin㉿sys-kali)-[~/docker-mysql]
└─$ docker images        
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
postgres     12        f0e41fa7eb3e   3 days ago    406MB
mysql        8.0       5761fe35fa53   4 weeks ago   577MB

┌──(odin㉿sys-kali)-[~/docker-mysql]
└─$ docker volume ls                                                                 
DRIVER    VOLUME NAME
                                                                                             
┌──(odin㉿sys-kali)-[~/docker-mysql]
└─$ docker run --name mysql-test --network host -e MYSQL_ROOT_PASSWORD=netology -ti -d -v volume1:/media/mysql/mysql-data/ -v volume2:/media/mysql/backup-data mysql:8.0
215fbe3e42857b54b2fc481c3825ac87ec09920ddd1df313ba6e54c78b506efc
                                                                                             
┌──(odin㉿sys-kali)-[~/docker-mysql]
└─$ docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED         STATUS         PORTS     NAMES
215fbe3e4285   mysql:8.0   "docker-entrypoint.s…"   8 seconds ago   Up 8 seconds             mysql-test

┌──(odin㉿sys-kali)-[~/docker-mysql]
└─$ docker cp /home/odin/virt-homeworks/06-db-03-mysql/test_data/test_dump.sql 215fbe3e4285:/media/mysql/backup-data
                                                                                             
┌──(odin㉿sys-kali)-[~/docker-mysql]
└─$ docker volume ls
DRIVER    VOLUME NAME
local     25c31c51e67e8971336d5d32630fa1a039f1f4d2be7e7e57d58cc492ed123d2b
local     volume1
local     volume2
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h`, получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из её вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с этим контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:

- плагин авторизации mysql_native_password
- срок истечения пароля — 180 дней 
- количество попыток авторизации — 3 
- максимальное количество запросов в час — 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James".

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES, получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`,
- на `InnoDB`.

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):

- скорость IO важнее сохранности данных;
- нужна компрессия таблиц для экономии места на диске;
- размер буффера с незакомиченными транзакциями 1 Мб;
- буффер кеширования 30% от ОЗУ;
- размер файла логов операций 100 Мб.

Приведите в ответе изменённый файл `my.cnf`.

---

### Как оформить ДЗ

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

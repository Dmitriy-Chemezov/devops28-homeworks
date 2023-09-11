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
22c00b02bfb41b2cf2e53324f716da01368c1423b594dce3de06a5bbf2af61ff
                                                                                             
┌──(odin㉿sys-kali)-[~/docker-mysql]
└─$ docker ps                                                                        
CONTAINER ID   IMAGE       COMMAND                  CREATED         STATUS         PORTS     NAMES
22c00b02bfb4   mysql:8.0   "docker-entrypoint.s…"   7 seconds ago   Up 7 seconds             mysql-test

┌──(odin㉿sys-kali)-[~/docker-mysql]
└─$ docker cp /home/odin/virt-homeworks/06-db-03-mysql/test_data/test_dump.sql 22c00b02bfb4:/media/mysql/backup-data 
                                                                                             
┌──(odin㉿sys-kali)-[~/docker-mysql]
└─$ docker volume ls
DRIVER    VOLUME NAME
local     c5acee0c529ca6762cf30fba560e05998ad0b5f2e632fbdb5ca67321d9d69d72
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

```
┌──(odin㉿sys-kali)-[~/docker-mysql]┌──(odin㉿sys-kali)-[~/docker-mysql]
└─$ docker run --name mysql-test --network host -e MYSQL_ROOT_PASSWORD=netology -ti -d -v volume1:/media/mysql/mysql-data/ -v volume2:/media/mysql/backup-data mysql:8.0
22c00b02bfb41b2cf2e53324f716da01368c1423b594dce3de06a5bbf2af61ff
                                                                                             
┌──(odin㉿sys-kali)-[~/docker-mysql]
└─$ docker ps                                                                        
CONTAINER ID   IMAGE       COMMAND                  CREATED         STATUS         PORTS     NAMES
22c00b02bfb4   mysql:8.0   "docker-entrypoint.s…"   7 seconds ago   Up 7 seconds             mysql-test
└─$ docker exec -it mysql-test bash
bash-4.4# mysql -u root -p test_db < /media/mysql/backup-data/test_dump.sql
Enter password:
bash-4.4# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 14
Server version: 8.0.34 MySQL Community Server - GPL

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.
ssl_session_data_print Serializes the current SSL session data to stdout or file

For server side help, type 'help contents'

mysql> \s
--------------
mysql  Ver 8.0.34 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          14
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.34 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 13 min 32 sec

Threads: 2  Questions: 9  Slow queries: 0  Opens: 121  Flush tables: 3  Open tables: 40  Queries per second avg: 0.011
--------------



```

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

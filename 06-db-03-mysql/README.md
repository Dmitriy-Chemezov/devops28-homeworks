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
└─$ docker run --name mysql-test --network host -e MYSQL_ROOT_PASSWORD=mysql -ti -d -v volume1:/media/mysql/mysql-data/ -v volume2:/media/mysql/backup-data mysql:8.0
3618d8cfe4e8ab37c0c1b2f39e72ac5d7819e1741c283dbb160d2441ddd46905
                                                                                             
┌──(odin㉿sys-kali)-[~/docker-mysql]
└─$ docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED         STATUS         PORTS     NAMES
3618d8cfe4e8   mysql:8.0   "docker-entrypoint.s…"   6 seconds ago   Up 6 seconds             mysql-test

┌──(odin㉿sys-kali)-[~/docker-mysql]
└─$ docker cp /home/odin/virt-homeworks/06-db-03-mysql/test_data/test_dump.sql 3618d8cfe4e8:/media/mysql/backup-data

┌──(odin㉿sys-kali)-[~/docker-mysql]
└─$ docker volume ls
DRIVER    VOLUME NAME
local     d75740ee96100f863dffef866265a0b7232410a02afcaf3bec847f5658132afc
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

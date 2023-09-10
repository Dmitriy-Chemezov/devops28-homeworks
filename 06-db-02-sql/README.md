# Домашнее задание к занятию 2. «SQL»

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/blob/virt-11/additional/README.md).

## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose-манифест.
```
┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ nano docker-compose.yaml

version: '3'
services:
 db:
   container_name: pg12
   image: postgres:12
   environment:
     POSTGRES_USER: user
     POSTGRES_PASSWORD: 111111
     POSTGRES_DB: test_db
   ports:
     - "5432:5432"
   volumes:      
     - pg12_database_volume:/home/database/
     - pg12_backup_volume:/home/backup/

volumes:
 pg12_database_volume:
 pg12_backup_volume:

                                                                                                      
┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker pull postgres:12 
12: Pulling from library/postgres
Digest: sha256:8383b88cf9a14826ee853a99b49ed2615998780afc3aac4c2069191878744c87
Status: Image is up to date for postgres:12
docker.io/library/postgres:12
                                                                                                      
┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker-compose up -d                                                             
Creating volume "docker_dz_pg12_database_volume" with default driver
Creating volume "docker_dz_pg12_backup_volume" with default driver
Creating pg12 ... done
                                                                                                                                           
┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker volume ls    
DRIVER    VOLUME NAME
local     a6ac7330219da1e220c5537791193e6627f7c470d7e928b26b48053dcd42271f
local     docker_dz_pg12_backup_volume
local     docker_dz_pg12_database_volume

  ┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker ps       
CONTAINER ID   IMAGE         COMMAND                  CREATED              STATUS              PORTS                                       NAMES
b61194effa1d   postgres:12   "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   pg12
                                                                                                                                           
┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED              STATUS              PORTS                                       NAMES
b61194effa1d   postgres:12   "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   pg12                                                                                                    
┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker exec -it pg12 bash
root@b61194effa1d:/# 

```


## Задача 2

В БД из задачи 1: 

- создайте пользователя test-admin-user и БД test_db;
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже);
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db;
- создайте пользователя test-simple-user;
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE этих таблиц БД test_db.

Таблица orders:

- id (serial primary key);
- наименование (string);
- цена (integer).

Таблица clients:

- id (serial primary key);
- фамилия (string);
- страна проживания (string, index);
- заказ (foreign key orders).

Приведите:

- итоговый список БД после выполнения пунктов выше;
- описание таблиц (describe);
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db;
- список пользователей с правами над таблицами test_db.

```
root@b61194effa1d:/# psql -d test_db -U user
psql (12.16 (Debian 12.16-1.pgdg120+1))
Type "help" for help.

test_db=# CREATE USER test_admin_user;
CREATE ROLE

test_db=# CREATE TABLE orders
(
   id SERIAL PRIMARY KEY,
   наименование TEXT,
   цена INTEGER
);
CREATE TABLE

test_db=# CREATE TABLE clients
(
    id SERIAL PRIMARY KEY,
    фамилия TEXT,
    "страна проживания" TEXT,
    заказ INTEGER,
    FOREIGN KEY (заказ) REFERENCES orders(id)
);
CREATE TABLE

test_db=# CREATE INDEX country_index ON clients ("страна проживания");
CREATE INDEX

test_db=# GRANT ALL ON TABLE orders TO test_admin_user;
GRANT
test_db=# GRANT ALL ON TABLE clients TO test_admin_user;
GRANT

test_db=# CREATE USER test_simple_user;
CREATE ROLE
test_db=# GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE orders TO test_simple_user;
GRANT
test_db=# GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE clients TO test_simple_user;
GRANT

test_db=# \l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges 
-----------+-------+----------+------------+------------+-------------------
 postgres  | user  | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | user  | UTF8     | en_US.utf8 | en_US.utf8 | =c/user          +
           |       |          |            |            | user=CTc/user
 template1 | user  | UTF8     | en_US.utf8 | en_US.utf8 | =c/user          +
           |       |          |            |            | user=CTc/user
 test_db   | user  | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)

test_db=# \d orders
                               Table "public.orders"
    Column    |  Type   | Collation | Nullable |              Default               
--------------+---------+-----------+----------+------------------------------------
 id           | integer |           | not null | nextval('orders_id_seq'::regclass)
 наименование | text    |           |          | 
 цена         | integer |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# \d clients
                                  Table "public.clients"
      Column       |  Type   | Collation | Nullable |               Default               
-------------------+---------+-----------+----------+-------------------------------------
 id                | integer |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | text    |           |          | 
 страна проживания | text    |           |          | 
 заказ             | integer |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "country_index" btree ("страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# SELECT grantee, table_catalog, table_name, privilege_type FROM information_schema.table_privileges WHERE table_name IN ('orders','clients');
     grantee      | table_catalog | table_name | privilege_type 
------------------+---------------+------------+----------------
 user             | test_db       | orders     | INSERT
 user             | test_db       | orders     | SELECT
 user             | test_db       | orders     | UPDATE
 user             | test_db       | orders     | DELETE
 user             | test_db       | orders     | TRUNCATE
 user             | test_db       | orders     | REFERENCES
 user             | test_db       | orders     | TRIGGER
 test_admin_user  | test_db       | orders     | INSERT
 test_admin_user  | test_db       | orders     | SELECT
 test_admin_user  | test_db       | orders     | UPDATE
 test_admin_user  | test_db       | orders     | DELETE
 test_admin_user  | test_db       | orders     | TRUNCATE
 test_admin_user  | test_db       | orders     | REFERENCES
 test_admin_user  | test_db       | orders     | TRIGGER
 test_simple_user | test_db       | orders     | INSERT
 test_simple_user | test_db       | orders     | SELECT
 test_simple_user | test_db       | orders     | UPDATE
 test_simple_user | test_db       | orders     | DELETE
 user             | test_db       | clients    | INSERT
 user             | test_db       | clients    | SELECT
 user             | test_db       | clients    | UPDATE
 user             | test_db       | clients    | DELETE
 user             | test_db       | clients    | TRUNCATE
 user             | test_db       | clients    | REFERENCES
 user             | test_db       | clients    | TRIGGER
 test_admin_user  | test_db       | clients    | INSERT
 test_admin_user  | test_db       | clients    | SELECT
 test_admin_user  | test_db       | clients    | UPDATE
 test_admin_user  | test_db       | clients    | DELETE
 test_admin_user  | test_db       | clients    | TRUNCATE
 test_admin_user  | test_db       | clients    | REFERENCES
 test_admin_user  | test_db       | clients    | TRIGGER
 test_simple_user | test_db       | clients    | INSERT
 test_simple_user | test_db       | clients    | SELECT
 test_simple_user | test_db       | clients    | UPDATE                                                                                                                 
 test_simple_user | test_db       | clients    | DELETE                                                                                                                 
(36 rows) 
```

## Задача 3

Используя SQL-синтаксис, наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL-синтаксис:
- вычислите количество записей для каждой таблицы.
Приведите в ответе:

    - запросы,
    - результаты их выполнения.

```
test_db=# INSERT INTO orders VALUES (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);
INSERT 0 5
test_db=# INSERT INTO clients VALUES (1, 'Иванов Иван Иванович', 'USA'), (2, 'Петров Петр Петрович', 'Canada'), (3, 'Иоганн Себастьян Бах', 'Japan'), (4, 'Ронни Джеймс Дио', 'Russia'), (5, 'Ritchie Blackmore', 'Russia');
INSERT 0 5

test_db=# SELECT COUNT (*) FROM orders;
 count 
-------
     5
(1 row)

test_db=# SELECT COUNT (*) FROM clients;
 count 
-------
     5
(1 row)
```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys, свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения этих операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод этого запроса.
 
Подсказка: используйте директиву `UPDATE`.

```
test_db=# UPDATE clients SET заказ=(select id from orders where наименование='Книга') WHERE фамилия='Иванов Иван Иванович';
UPDATE 1
test_db=# UPDATE clients SET заказ=(select id from orders where наименование='Монитор') WHERE фамилия='Петров Петр Петрович';
UPDATE 1
test_db=# UPDATE clients SET заказ=(select id from orders where наименование='Гитара') WHERE фамилия='Иоганн Себастьян Бах';
UPDATE 1
test_db=# SELECT* FROM clients WHERE заказ IS NOT NULL;
 id |       фамилия        | страна проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(3 rows)
 

```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните, что значат полученные значения.

```
test_db=# EXPLAIN SELECT* FROM clients WHERE заказ IS NOT NULL;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: ("заказ" IS NOT NULL)
(2 rows)
```

Чтение данных из таблицы clients происходит с использованием метода Seq Scan — последовательного чтения данных. Значение 0.00 — ожидаемые затраты на получение первой строки. Второе — 18.10 — ожидаемые затраты на получение всех строк. rows - ожидаемое число строк, которое должен вывести этот узел плана. При этом так же предполагается, что узел выполняется до конца. width - ожидаемый средний размер строк, выводимых этим узлом плана (в байтах). Каждая запись сравнивается с условием "заказ" IS NOT NULL. Если условие выполняется, запись вводится в результат. Иначе — запись отбрасывается.

```
test_db=# EXPLAIN (ANALYZE) SELECT* FROM clients WHERE заказ IS NOT NULL;
                                             QUERY PLAN                                              
-----------------------------------------------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72) (actual time=0.013..0.015 rows=3 loops=1)
   Filter: ("заказ" IS NOT NULL)
   Rows Removed by Filter: 2
 Planning Time: 0.063 ms
 Execution Time: 0.032 ms
(5 rows)
```
Здесь уже видны реальные затраты на обработку первой и всех строк, количество выведенных строк (3), удовлетворяющих фильру "заказ" IS NOT NULL, количество проходов (1), количество строк, которые были удалены из запроса по фильтру (2), планируемое и затраченное время, а также общее количество строк, по которым производилась выборка.


## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. задачу 1).

Остановите контейнер с PostgreSQL, но не удаляйте volumes.

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

```
root@b61194effa1d:/# pg_dump -U user test_db > /home/backup/test_db.dump
root@b61194effa1d:/# cd /home/backup/
root@b61194effa1d:/home/backup# ls
test_db.dump
root@b61194effa1d:/home/backup# exit
exit

┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker stop pg12          
pg12
                                                                                                                                           
┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker ps       
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                     PORTS     NAMES
b61194effa1d   postgres:12   "docker-entrypoint.s…"   34 minutes ago   Exited (0) 2 minutes ago             pg12

┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker volume ls    
DRIVER    VOLUME NAME
local     a6ac7330219da1e220c5537791193e6627f7c470d7e928b26b48053dcd42271f
local     docker_dz_pg12_backup_volume
local     docker_dz_pg12_database_volume

┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker volume rm a6ac7330219da1e220c5537791193e6627f7c470d7e928b26b48053dcd42271f

┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker volume rm docker_dz_pg12_database_volume                                  
docker_dz_pg12_database_volume

┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker volume ls                               
DRIVER    VOLUME NAME
local     docker_dz_pg12_backup_volume
                                                                                                                                           
┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ nano docker-compose.yaml

 version: '3'
services:
 db:
   container_name: pg12_1
   image: postgres:12
   environment:
     POSTGRES_USER: user
     POSTGRES_PASSWORD: 111111
     POSTGRES_DB: test_db
   ports:
     - "5432:5432"
   volumes:      
     - pg12_database_volume:/home/database/
     - pg12_backup_volume:/home/backup/

volumes:
 pg12_database_volume:
 pg12_backup_volume:

┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker-compose up -d                                                             
Creating volume "docker_dz_pg12_database_volume" with default driver
Creating pg12_1 ... done
                                                                                                                                           
┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker ps           
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                                       NAMES
4543c060add2   postgres:12   "docker-entrypoint.s…"   4 minutes ago   Up 4 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   pg12_1

┌──(odin㉿sys-kali)-[~/docker_dz]
└─$ docker exec -it pg12_1 bash                                                      
root@4543c060add2:/# psql -U user -d test_db -f /home/backup/test_db.dump
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval 
--------
      1
(1 row)

 setval 
--------
      1
(1 row)

ALTER TABLE
ALTER TABLE
CREATE INDEX
ALTER TABLE
psql:/home/backup/test_db.dump:183: ERROR:  role "test_admin_user" does not exist
psql:/home/backup/test_db.dump:184: ERROR:  role "test_simple_user" does not exist
psql:/home/backup/test_db.dump:191: ERROR:  role "test_admin_user" does not exist
psql:/home/backup/test_db.dump:192: ERROR:  role "test_simple_user" does not exist
root@4543c060add2:/#
```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

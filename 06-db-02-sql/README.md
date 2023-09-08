# Домашнее задание к занятию 2. «SQL»

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/blob/virt-11/additional/README.md).

## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose-манифест.
```
docker run -d -e POSTGRES_PASSWORD=user-test -v pg-data:/var/lib/postgresql/data -v pg-backup:/var/lib/postgresql/backup --name postgres postgres:12
```

![](https://github.com/Dmitriy-Chemezov/devops28-homeworks/blob/main/06-db-02-sql/1)


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
┌──(odin㉿sys-kali)-[~]
└─$ docker exec -it postgres /bin/bash
root@2b5ea3af6794:/# psql -U postgres
psql (12.16 (Debian 12.16-1.pgdg120+1))
Type "help" for help.

postgres=# create database test_db;
CREATE DATABASE
postgres=# create user "test-admin-user";
CREATE ROLE
postgres=# create user "test-simple-user";
CREATE ROLE

postgres=# \c test_db
You are now connected to database "test_db" as user "postgres".
test_db=# create table orders (
test_db(# id int primary key generated always as identity,
test_db(# name text not null,
test_db(# price int );
CREATE TABLE
test_db=# create table clients (
test_db(# id int primary key generated always as identity,
test_db(# name text not null,
test_db(# country text not null,
test_db(# order_id int references orders(id) );
CREATE TABLE
test_db=# create index clients_country on clients (country);
CREATE INDEX
test_db=# grant all privileges on orders,clients to "test-admin-user"; 
GRANT
test_db=# grant select,insert,update,delete on orders,clients to "test-simple-user";
GRANT
test_db=# \l+
                                                                   List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   |  Size   | Tablespace |                Description                 
-----------+----------+----------+------------+------------+-----------------------+---------+------------+--------------------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 7977 kB | pg_default | default administrative connection database
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7833 kB | pg_default | unmodifiable empty database
           |          |          |            |            | postgres=CTc/postgres |         |            | 
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7833 kB | pg_default | default template for new databases
           |          |          |            |            | postgres=CTc/postgres |         |            | 
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 8105 kB | pg_default | 
(4 rows)

test_db=# \d+ orders
                                             Table "public.orders"
 Column |  Type   | Collation | Nullable |           Default            | Storage  | Stats target | Description 
--------+---------+-----------+----------+------------------------------+----------+--------------+-------------
 id     | integer |           | not null | generated always as identity | plain    |              | 
 name   | text    |           | not null |                              | extended |              | 
 price  | integer |           |          |                              | plain    |              | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)
Access method: heap

test_db=# \d+ clients
                                              Table "public.clients"
  Column  |  Type   | Collation | Nullable |           Default            | Storage  | Stats target | Description 
----------+---------+-----------+----------+------------------------------+----------+--------------+-------------
 id       | integer |           | not null | generated always as identity | plain    |              | 
 name     | text    |           | not null |                              | extended |              | 
 country  | text    |           | not null |                              | extended |              | 
 order_id | integer |           |          |                              | plain    |              | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_country" btree (country)
Foreign-key constraints:
    "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)
Access method: heap

test_db=# \z
                                           Access privileges
 Schema |      Name      |   Type   |         Access privileges          | Column privileges | Policies 
--------+----------------+----------+------------------------------------+-------------------+----------
 public | clients        | table    | postgres=arwdDxt/postgres         +|                   | 
        |                |          | "test-admin-user"=arwdDxt/postgres+|                   | 
        |                |          | "test-simple-user"=arwd/postgres   |                   | 
 public | clients_id_seq | sequence |                                    |                   | 
 public | orders         | table    | postgres=arwdDxt/postgres         +|                   | 
        |                |          | "test-admin-user"=arwdDxt/postgres+|                   | 
        |                |          | "test-simple-user"=arwd/postgres   |                   | 
 public | orders_id_seq  | sequence |                                    |                   | 
(4 rows)

test_db=# SELECT grantor, grantee, table_schema, table_name, privilege_type FROM information_schema.table_privileges WHERE grantee = 'test-admin-user';
 grantor  |     grantee     | table_schema | table_name | privilege_type 
----------+-----------------+--------------+------------+----------------
 postgres | test-admin-user | public       | orders     | INSERT
 postgres | test-admin-user | public       | orders     | SELECT
 postgres | test-admin-user | public       | orders     | UPDATE
 postgres | test-admin-user | public       | orders     | DELETE
 postgres | test-admin-user | public       | orders     | TRUNCATE
 postgres | test-admin-user | public       | orders     | REFERENCES
 postgres | test-admin-user | public       | orders     | TRIGGER
 postgres | test-admin-user | public       | clients    | INSERT
 postgres | test-admin-user | public       | clients    | SELECT
 postgres | test-admin-user | public       | clients    | UPDATE
 postgres | test-admin-user | public       | clients    | DELETE
 postgres | test-admin-user | public       | clients    | TRUNCATE
 postgres | test-admin-user | public       | clients    | REFERENCES
 postgres | test-admin-user | public       | clients    | TRIGGER
(14 rows)

test_db=# SELECT grantor, grantee, table_schema, table_name, privilege_type FROM information_schema.table_privileges WHERE grantee = 'test-simple-user';
 grantor  |     grantee      | table_schema | table_name | privilege_type 
----------+------------------+--------------+------------+----------------
 postgres | test-simple-user | public       | orders     | INSERT
 postgres | test-simple-user | public       | orders     | SELECT
 postgres | test-simple-user | public       | orders     | UPDATE
 postgres | test-simple-user | public       | orders     | DELETE
 postgres | test-simple-user | public       | clients    | INSERT
 postgres | test-simple-user | public       | clients    | SELECT
 postgres | test-simple-user | public       | clients    | UPDATE
 postgres | test-simple-user | public       | clients    | DELETE
(8 rows)

test_db=# 
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
test_db=# insert into orders (name,price) values ('Шоколад',10),('Принтер',3000),('Книга',500),('Монитор',7000),('Гитара',4000);
INSERT 0 5
test_db=# insert into clients (name,country) values ('Иванов Иван Иванович','USA'),('Петров Петр Петрович','Canada'),('Иоганн Себастьян Бах','Japan'),('Ронни Джеймс Дио','Russia'),('Ritchie Blackmore','Russia');
INSERT 0 5
test_db=# select count(*) from orders;
 count 
-------
     5
(1 row)

test_db=# select count(*) from clients;
 count 
-------
     5
(1 row)

test_db=# 
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
test_db=# UPDATE clients SET order_id = 3 WHERE id = 1;
UPDATE 1
test_db=# UPDATE clients SET order_id = 4 WHERE id = 2;
UPDATE 1
test_db=# UPDATE clients SET order_id = 5 WHERE id = 3;
UPDATE 1

test_db=# select * from clients where order_id is not null;
 id |         name         | country | order_id 
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |        3
  2 | Петров Петр Петрович | Canada  |        4
  3 | Иоганн Себастьян Бах | Japan   |        5
(3 rows)

test_db=# 

```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните, что значат полученные значения.

```
test_db=# EXPLAIN select * from clients where order_id is not null;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: (order_id IS NOT NULL)
(2 rows)

test_db=# 
```

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. задачу 1).

Остановите контейнер с PostgreSQL, но не удаляйте volumes.

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

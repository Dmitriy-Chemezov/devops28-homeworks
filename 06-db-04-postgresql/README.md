# Домашнее задание к занятию 4. «PostgreSQL»

## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL, используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД,
- подключения к БД,
- вывода списка таблиц,
- вывода описания содержимого таблиц,
- выхода из psql.

```
┌──(odin㉿sys-kali)-[~/postgres]
└─$ docker pull postgres:13
13: Pulling from library/postgres
360eba32fa65: Pull complete 
6987678f9780: Pull complete 
42299245e905: Pull complete 
afcda32ad76a: Pull complete 
23d81c750666: Pull complete 
c7813914a8b7: Pull complete 
876fecb4c432: Pull complete 
0a8727713246: Pull complete 
6b4456afcfab: Pull complete 
8155ec9b2a10: Pull complete 
e808f9e04e03: Pull complete 
58f75dd8842c: Pull complete 
77fc77a750f6: Pull complete 
Digest: sha256:75e38f69b26f8f78e7f6e56e55b70b7986acca57156a713a6f0472a68b431075
Status: Downloaded newer image for postgres:13
docker.io/library/postgres:13
                                                                                             
┌──(odin㉿sys-kali)-[~/postgres]
└─$ docker images          
REPOSITORY   TAG       IMAGE ID       CREATED      SIZE
postgres     13        0e59c61e2c92   4 days ago   407MB
                                                                                             
┌──(odin㉿sys-kali)-[~/postgres]
└─$ docker volume ls
DRIVER    VOLUME NAME

──(odin㉿sys-kali)-[~/postgres]
└─$ nano docker-compose.yaml

version: '3.7'
services:
  db:
    container_name: pg13
    image: postgres:13
    restart: always
    environment:
      POSTGRES_PASSWORD: netology
    ports:
      - "5432:5432"
    volumes:
      - volume_data:/home/database/
      - volume_backup:/home/backup/

volumes:
  volume_data:
  volume_backup:

┌──(odin㉿sys-kali)-[~/postgres]
└─$ docker-compose up -d
Creating network "postgres_default" with the default driver
Creating volume "postgres_volume_data" with default driver
Creating volume "postgres_volume_backup" with default driver
Creating pg13 ... done

┌──(odin㉿sys-kali)-[~/postgres]
└─$ docker ps              
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
142c3994b0c6   postgres:13   "docker-entrypoint.s…"   27 seconds ago   Up 26 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   pg13

┌──(odin㉿sys-kali)-[~/postgres]
└─$ docker volume ls
DRIVER    VOLUME NAME
local     6c4a3ddbc740dc31d18f07f700ccecfd193c56bd0bf711da39f089dbd4c1a630
local     postgres_volume_backup
local     postgres_volume_data

┌──(odin㉿sys-kali)-[~/postgres]
└─$ docker cp /home/odin/postgres/test_data/test_dump.sql 142c3994b0c6:/home/backup/

┌──(odin㉿sys-kali)-[~/postgres]
└─$ docker cp /home/odin/postgres/test_data/test_dump.sql 142c3994b0c6:/home/backup/
                                                                                             
┌──(odin㉿sys-kali)-[~/postgres]
└─$ docker exec -it pg13 bash                                                       
root@142c3994b0c6:/# psql -U postgres
psql (13.12 (Debian 13.12-1.pgdg120+1))
Type "help" for help.

postgres=# \?
General
  \copyright             show PostgreSQL usage and distribution terms
  \crosstabview [COLUMNS] execute query and display results in crosstab
  \errverbose            show most recent error message at maximum verbosity
  \g [(OPTIONS)] [FILE]  execute query (and send results to file or |pipe);
                         \g with no arguments is equivalent to a semicolon
  \gdesc                 describe result of query, without executing it
  \gexec                 execute query, then execute each value in its result
  \gset [PREFIX]         execute query and store results in psql variables
  \gx [(OPTIONS)] [FILE] as \g, but forces expanded output mode
  \q                     quit psql
  \watch [SEC]           execute query every SEC seconds

Help
  \? [commands]          show help on backslash commands
  \? options             show help on psql command-line options
  \? variables           show help on special variables
  \h [NAME]              help on syntax of SQL commands, * for all commands

Query Buffer
  \e [FILE] [LINE]       edit the query buffer (or file) with external editor
  \ef [FUNCNAME [LINE]]  edit function definition with external editor
  \ev [VIEWNAME [LINE]]  edit view definition with external editor
  \p                     show the contents of the query buffer
  \r                     reset (clear) the query buffer
  \s [FILE]              display history or save it to file
  \w FILE                write query buffer to file

Input/Output
  \copy ...              perform SQL COPY with data stream to the client host
  \echo [-n] [STRING]    write string to standard output (-n for no newline)
  \i FILE                execute commands from file
  \ir FILE               as \i, but relative to location of current script
  \o [FILE]              send all query results to file or |pipe
  \qecho [-n] [STRING]   write string to \o output stream (-n for no newline)
  \warn [-n] [STRING]    write string to standard error (-n for no newline)

Conditional
  \if EXPR               begin conditional block
  \elif EXPR             alternative within current conditional block
  \else                  final alternative within current conditional block
  \endif                 end conditional block

Informational
  (options: S = show system objects, + = additional detail)
  \d[S+]                 list tables, views, and sequences
  \d[S+]  NAME           describe table, view, sequence, or index
  \da[S]  [PATTERN]      list aggregates
  \dA[+]  [PATTERN]      list access methods
  \dAc[+] [AMPTRN [TYPEPTRN]]  list operator classes
  \dAf[+] [AMPTRN [TYPEPTRN]]  list operator families
  \dAo[+] [AMPTRN [OPFPTRN]]   list operators of operator families
  \dAp[+] [AMPTRN [OPFPTRN]]   list support functions of operator families
  \db[+]  [PATTERN]      list tablespaces
  \dc[S+] [PATTERN]      list conversions
  \dC[+]  [PATTERN]      list casts
  \dd[S]  [PATTERN]      show object descriptions not displayed elsewhere
  \dD[S+] [PATTERN]      list domains
  \ddp    [PATTERN]      list default privileges
  \dE[S+] [PATTERN]      list foreign tables
  \det[+] [PATTERN]      list foreign tables
  \des[+] [PATTERN]      list foreign servers
  \deu[+] [PATTERN]      list user mappings
  \dew[+] [PATTERN]      list foreign-data wrappers
  \df[anptw][S+] [PATRN] list [only agg/normal/procedures/trigger/window] functions
  \dF[+]  [PATTERN]      list text search configurations
  \dFd[+] [PATTERN]      list text search dictionaries
  \dFp[+] [PATTERN]      list text search parsers
  \dFt[+] [PATTERN]      list text search templates
  \dg[S+] [PATTERN]      list roles
  \di[S+] [PATTERN]      list indexes
  \dl                    list large objects, same as \lo_list
  \dL[S+] [PATTERN]      list procedural languages
  \dm[S+] [PATTERN]      list materialized views
  \dn[S+] [PATTERN]      list schemas
  \do[S+] [PATTERN]      list operators
  \dO[S+] [PATTERN]      list collations
  \dp     [PATTERN]      list table, view, and sequence access privileges
  \dP[itn+] [PATTERN]    list [only index/table] partitioned relations [n=nested]
  \drds [PATRN1 [PATRN2]] list per-database role settings
  \dRp[+] [PATTERN]      list replication publications
  \dRs[+] [PATTERN]      list replication subscriptions
  \ds[S+] [PATTERN]      list sequences
  \dt[S+] [PATTERN]      list tables
  \dT[S+] [PATTERN]      list data types
  \du[S+] [PATTERN]      list roles
  \dv[S+] [PATTERN]      list views
  \dx[+]  [PATTERN]      list extensions
  \dy[+]  [PATTERN]      list event triggers
  \l[+]   [PATTERN]      list databases
  \sf[+]  FUNCNAME       show a function's definition
  \sv[+]  VIEWNAME       show a view's definition
  \z      [PATTERN]      same as \dp

Formatting
  \a                     toggle between unaligned and aligned output mode
  \C [STRING]            set table title, or unset if none
  \f [STRING]            show or set field separator for unaligned query output
  \H                     toggle HTML output mode (currently off)
  \pset [NAME [VALUE]]   set table output option
                         (border|columns|csv_fieldsep|expanded|fieldsep|
                         fieldsep_zero|footer|format|linestyle|null|
                         numericlocale|pager|pager_min_lines|recordsep|
                         recordsep_zero|tableattr|title|tuples_only|
                         unicode_border_linestyle|unicode_column_linestyle|
                         unicode_header_linestyle)
  \t [on|off]            show only rows (currently off)
  \T [STRING]            set HTML <table> tag attributes, or unset if none
  \x [on|off|auto]       toggle expanded output (currently off)

Connection
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
  \conninfo              display information about current connection
  \encoding [ENCODING]   show or set client encoding
  \password [USERNAME]   securely change the password for a user

Operating System
  \cd [DIR]              change the current working directory
  \setenv NAME [VALUE]   set or unset environment variable
  \timing [on|off]       toggle timing of commands (currently off)
  \! [COMMAND]           execute command in shell or start interactive shell

Variables
  \prompt [TEXT] NAME    prompt user to set internal variable
  \set [NAME [VALUE]]    set internal variable, or list all if no parameters
  \unset NAME            unset (delete) internal variable

Large Objects
  \lo_export LOBOID FILE
  \lo_import FILE [COMMENT]
  \lo_list
  \lo_unlink LOBOID      large object operations

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)

postgres=# \c postgres;
You are now connected to database "postgres" as user "postgres".
postgres=# \conninfo
You are connected to database "postgres" as user "postgres" via socket in "/var/run/postgresql" at port "5432".
postgres=# \dt *.*
                        List of relations
       Schema       |          Name           | Type  |  Owner   
--------------------+-------------------------+-------+----------
 information_schema | sql_features            | table | postgres
 information_schema | sql_implementation_info | table | postgres
 information_schema | sql_parts               | table | postgres
 information_schema | sql_sizing              | table | postgres
 pg_catalog         | pg_aggregate            | table | postgres
 pg_catalog         | pg_am                   | table | postgres
 pg_catalog         | pg_amop                 | table | postgres
 pg_catalog         | pg_amproc               | table | postgres
 pg_catalog         | pg_attrdef              | table | postgres
 pg_catalog         | pg_attribute            | table | postgres
 pg_catalog         | pg_auth_members         | table | postgres
 pg_catalog         | pg_authid               | table | postgres
 ...
 ...
 ...

postgres=# \d pg_namespace;
            Table "pg_catalog.pg_namespace"
  Column  |   Type    | Collation | Nullable | Default 
----------+-----------+-----------+----------+---------
 oid      | oid       |           | not null | 
 nspname  | name      |           | not null | 
 nspowner | oid       |           | not null | 
 nspacl   | aclitem[] |           |          | 
Indexes:
    "pg_namespace_nspname_index" UNIQUE, btree (nspname)
    "pg_namespace_oid_index" UNIQUE, btree (oid)

postgres=# \q
root@142c3994b0c6:/#

```

## Задача 2

Используя `psql`, создайте БД `test_database`.

```
root@142c3994b0c6:/# psql -U postgres -c "CREATE DATABASE "test_database" OWNER=postgres"
CREATE DATABASE
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

```
root@142c3994b0c6:/# psql -U postgres test_database < /home/backup/test_dump.sql 
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
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
```

Перейдите в управляющую консоль `psql` внутри контейнера.

```
root@142c3994b0c6:/# psql -U postgres 
psql (13.12 (Debian 13.12-1.pgdg120+1))
Type "help" for help.

postgres=# 

```

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```
test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE

```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

```
test_database=# select attname, avg_width from pg_stats where tablename='orders' order by avg_width desc limit 1;
 attname | avg_width 
---------+-----------
 title   |        16
(1 row)

```

**Приведите в ответе** команду, которую вы использовали для вычисления, и полученный результат.

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили
провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.

Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?

## Задача 4

Используя утилиту `pg_dump`, создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

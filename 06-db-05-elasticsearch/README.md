# Домашнее задание к занятию 5. «Elasticsearch»

## Задача 1

В этом задании вы потренируетесь в:

- установке Elasticsearch,
- первоначальном конфигурировании Elasticsearch,
- запуске Elasticsearch в Docker.

Используя Docker-образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для Elasticsearch,
- соберите Docker-образ и сделайте `push` в ваш docker.io-репозиторий,
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины.

Требования к `elasticsearch.yml`:

- данные `path` должны сохраняться в `/var/lib`,
- имя ноды должно быть `netology_test`.

В ответе приведите:

- текст Dockerfile-манифеста,

```
Dockerfile
____________________________________________________________
FROM centos:7

RUN yum install -y wget  && \
    yum install -y perl-Digest-SHA 

ENV ES_DIR="/opt/elasticsearch"
ENV ES_HOME="${ES_DIR}/elasticsearch-7.16.0"

WORKDIR ${ES_DIR}

RUN wget --quiet https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.0-linux-x86_64.tar.gz && \
    wget --quiet https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.0-linux-x86_64.tar.gz.sha512 && \
    sha512sum --check --quiet elasticsearch-7.16.0-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-7.16.0-linux-x86_64.tar.gz

COPY elasticsearch.yml ${ES_HOME}/config

ENV ES_USER="elastic"

RUN useradd ${ES_USER}

RUN mkdir -p "/var/lib/elasticsearch" && \
    mkdir -p "/var/log/elasticsearch"

RUN chown -R ${ES_USER}: "${ES_DIR}" && \
    chown -R ${ES_USER}: "/var/lib/elasticsearch" && \
    chown -R ${ES_USER}: "/var/log/elasticsearch"

USER ${ES_USER}

WORKDIR "${ES_HOME}"

EXPOSE 9200
EXPOSE 9300

ENTRYPOINT ["./bin/elasticsearch"]
______________________________________________________________________

elasticsearch.yml
______________________________________________________________________
discovery:
  type: single-node

cluster:
  name: netology

node:
  name: netology_test

network:
  host: 0.0.0.0

path:
  data: /var/lib/elasticsearch
  logs: /var/log/elasticsearch
_______________________________________________________________________
```

- ссылку на образ в репозитории dockerhub,

https://hub.docker.com/layers/chemezovd/elasticsearch/v1/images/sha256-2fe463bbaf04d4ef06fdb95c76ce99fdb149563fa93c56534a97df4b5d862afa?context=repo

- ответ `Elasticsearch` на запрос пути `/` в json-виде.

```
┌──(odin㉿sys-kali)-[~/elasticsearch]
└─$ docker run --rm -d --name elastic -p 9200:9200 -p 9300:9300 chemezovd/elasticsearch:v1
1eb99ab196e11a71abb860cf4bda66f49580b33a57417e5c902d863f6b4b9384
                                                                                                                                        
┌──(odin㉿sys-kali)-[~/elasticsearch]
└─$ docker ps -a                                                                          
CONTAINER ID   IMAGE                        COMMAND                 CREATED          STATUS          PORTS                                                                                  NAMES
1eb99ab196e1   chemezovd/elasticsearch:v1   "./bin/elasticsearch"   19 seconds ago   Up 18 seconds   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 0.0.0.0:9300->9300/tcp, :::9300->9300/tcp   elastic
                                                                                                                                        
┌──(odin㉿sys-kali)-[~/elasticsearch]
└─$ docker exec -it elastic bash
[elastic@1eb99ab196e1 elasticsearch-7.16.0]$ curl localhost:9200
{
  "name" : "netology_test",
  "cluster_name" : "netology",
  "cluster_uuid" : "l3797TsXQ-2Z0KlGwPeIJA",
  "version" : {
    "number" : "7.16.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "6fc81662312141fe7691d7c1c91b8658ac17aa0d",
    "build_date" : "2021-12-02T15:46:35.697268109Z",
    "build_snapshot" : false,
    "lucene_version" : "8.10.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
[elastic@1eb99ab196e1 elasticsearch-7.16.0]$
```


Подсказки:

- возможно, вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum,
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml,
- при некоторых проблемах вам поможет Docker-директива ulimit,
- Elasticsearch в логах обычно описывает проблему и пути её решения.

Далее мы будем работать с этим экземпляром Elasticsearch.

## Задача 2

В этом задании вы научитесь:

- создавать и удалять индексы,
- изучать состояние кластера,
- обосновывать причину деградации доступности данных.

Ознакомьтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `Elasticsearch` 3 индекса в соответствии с таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```
[elastic@1eb99ab196e1 elasticsearch-7.16.0]$ curl -X PUT "localhost:9200/ind-1" -H 'Content-Type: application/json' -d' { "settings": { "number_of_shards": 1, "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}[elastic@1eb99ab196e1 elasticsearch-7.16.0]$ 
[elastic@1eb99ab196e1 elasticsearch-7.16.0]$ curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}[elastic@1eb99ab196e1 elasticsearch-7.16.0]$ 
[elastic@1eb99ab196e1 elasticsearch-7.16.0]$ curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}[elastic@1eb99ab196e1 elasticsearch-7.16.0]$ 
[elastic@1eb99ab196e1 elasticsearch-7.16.0]$ 
```

Получите список индексов и их статусов, используя API, и **приведите в ответе** на задание.

```
[elastic@1eb99ab196e1 elasticsearch-7.16.0]$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases nI9a3I74Qu2g2cOhaDeP5Q   1   0         43            0     40.8mb         40.8mb
green  open   ind-1            PMsCayzoTRSr14LJES6pNA   1   0          0            0       226b           226b
yellow open   ind-3            srNyW9FsR2q7USpwtAQnOQ   4   2          0            0       904b           904b
yellow open   ind-2            XiIF0hKcQQWZB0uUgHbt1w   2   1          0            0       452b           452b

```

Получите состояние кластера `Elasticsearch`, используя API.

```
elasticsearch-7.16.0]$ curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "netology",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0

```

Как вы думаете, почему часть индексов и кластер находятся в состоянии yellow?

У них должны быть реплики, но в кластере всего одна нода, поэтому размещать их негде. В таком случае кластер помечает их желтыми (согласно документации по elasticsearch).

Удалите все индексы.

```
[elastic@1eb99ab196e1 elasticsearch-7.16.0]$ curl -X DELETE 'http://localhost:9200/_all'{"acknowledged":true}
[elastic@1eb99ab196e1 elasticsearch-7.16.0]$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases nI9a3I74Qu2g2cOhaDeP5Q   1   0         43            0     40.8mb         40.8mb
[elastic@1eb99ab196e1 elasticsearch-7.16.0]$ 

```

**Важно**

При проектировании кластера Elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В этом задании вы научитесь:

- создавать бэкапы данных,
- восстанавливать индексы из бэкапов.

Создайте директорию `{путь до корневой директории с Elasticsearch в образе}/snapshots`.

```
┌──(odin㉿sys-kali)-[~/elasticsearch]
└─$ docker exec -u root -it elastic bash
[root@1eb99ab196e1 elasticsearch-7.16.0]# mkdir /opt/snapshots
[root@1eb99ab196e1 elasticsearch-7.16.0]# echo path.repo: [ "/opt/snapshots" ] >> "$ES_HOME/config/elasticsearch.yml"
[root@1eb99ab196e1 elasticsearch-7.16.0]# chown elastic:elastic /opt/snapshots
[root@1eb99ab196e1 elasticsearch-7.16.0]# cat $ES_HOME/config/elasticsearch.yml
discovery:
  type: single-node

cluster:
  name: netology

node:
  name: netology_test

network:
  host: 0.0.0.0

path:
  data: /var/lib/elasticsearch
  logs: /var/log/elasticsearch
path.repo: [ /opt/snapshots ]
[root@1eb99ab196e1 elasticsearch-7.16.0]# 
```

Используя API, [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
эту директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

```
[root@1eb99ab196e1 elasticsearch-7.16.0]# exit
exit
                                                                                                                                        
┌──(odin㉿sys-kali)-[~/elasticsearch]
└─$ docker restart elastic
elastic
                                                                                                                                        
┌──(odin㉿sys-kali)-[~/elasticsearch]
└─$ docker exec -u root -it elastic bash
[root@1eb99ab196e1 elasticsearch-7.16.0]# curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
> {
>  "type": "fs",
>  "settings": {
>    "location": "/opt/snapshots",
>     "compress": true
>   }
>  }'
{
  "acknowledged" : true
```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```
[root@1eb99ab196e1 elasticsearch-7.16.0]# 
> {
>   "settings": {
>     "number_of_shards": 1,
>     "number_of_replicas": 0
>   }
>  }'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"

[root@1eb99ab196e1 elasticsearch-7.16.0]# curl 'localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases nI9a3I74Qu2g2cOhaDeP5Q   1   0         43            0     40.8mb         40.8mb
green  open   test             d4o5hpeETN6UonkBgrhL9w   1   0          0            0       226b           226b

```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `Elasticsearch`.

```
[root@1eb99ab196e1 elasticsearch-7.16.0]# curl -X PUT -H "Content-Type:application/json" http://localhost:9200/_snapshot/netology_backup/snapshot_1?wait_for_completion=true
{"snapshot":{"snapshot":"snapshot_1","uuid":"TOSVshC9T66MsuOf6m8jSw","repository":"netology_backup","version_id":7160099,"version":"7.16.0","indices":[".ds-.logs-deprecation.elasticsearch-default-2023.09.16-000001",".geoip_databases",".ds-ilm-history-5-2023.09.16-000001","test"],"data_streams":["ilm-history-5",".logs-deprecation.elasticsearch-default"],"include_global_state":true,"state":"SUCCESS","start_time":"2023-09-16T18:12:03.876Z","start_time_in_millis":1694887923876,"end_time":"2023-09-16T18:12:05.078Z","end_time_in_millis":1694887925078,"duration_in_millis":1202,"failures":[],"shards":{"total":4,"failed":0,"successful":4},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]}]}}
```

**Приведите в ответе** список файлов в директории со `snapshot`.

```
[root@1eb99ab196e1 elasticsearch-7.16.0]# ls -l /opt/snapshots/
total 28
-rw-r--r-- 1 elastic elastic 1422 Sep 16 18:12 index-0
-rw-r--r-- 1 elastic elastic    8 Sep 16 18:12 index.latest
drwxr-xr-x 6 elastic elastic 4096 Sep 16 18:12 indices
-rw-r--r-- 1 elastic elastic 9721 Sep 16 18:12 meta-TOSVshC9T66MsuOf6m8jSw.dat
-rw-r--r-- 1 elastic elastic  455 Sep 16 18:12 snap-TOSVshC9T66MsuOf6m8jSw.dat
```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```
[root@1eb99ab196e1 elasticsearch-7.16.0]# curl -X DELETE http://localhost:9200/test
{"acknowledged":true}[root@1eb99ab196e1 elasticsearch-7.16.0]# 
[root@1eb99ab196e1 elasticsearch-7.16.0]# curl -X PUT -H "Content-Type:application/json" -d '{"settings": {"index": {"number_of_shards": 1, "number_of_replicas": 0}}}' http://localhost:9200/test-2
{"acknowledged":true,"shards_acknowledged":true,"index":"test-2"}[root@1eb99ab196e1 elasticsearch-7.16.0]# 
[root@1eb99ab196e1 elasticsearch-7.16.0]# curl http://localhost:9200/_cat/indices
green open .geoip_databases nI9a3I74Qu2g2cOhaDeP5Q 1 0 43 0 40.8mb 40.8mb
green open test-2           YnYJAeRKTDCIF9ehooCDkQ 1 0  0 0   226b   226b

```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `Elasticsearch` из `snapshot`, созданного ранее. 

```
curl -X POST http://localhost:9200/_snapshot/netology_backup/snapshot_1/_restore
{"accepted":true}
```

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```
[root@1eb99ab196e1 elasticsearch-7.16.0]# curl 'localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases nI9a3I74Qu2g2cOhaDeP5Q   1   0         43            0     40.8mb         40.8mb
green  open   test             d4o5hpeETN6UonkBgrhL9w   1   0          0            0       226b           226b
```

Подсказки:

- возможно, вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `Elasticsearch`.

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

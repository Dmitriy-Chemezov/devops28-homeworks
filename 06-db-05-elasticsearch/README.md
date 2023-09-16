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
- ссылку на образ в репозитории dockerhub,
- ответ `Elasticsearch` на запрос пути `/` в json-виде.

Подсказки:

- возможно, вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum,
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml,
- при некоторых проблемах вам поможет Docker-директива ulimit,
- Elasticsearch в логах обычно описывает проблему и пути её решения.

Далее мы будем работать с этим экземпляром Elasticsearch.

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

┌──(odin㉿sys-kali)-[~/elasticsearch]
└─$ docker images                         
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
                                                                                                                                        
┌──(odin㉿sys-kali)-[~/elasticsearch]
└─$ docker ps -a                          
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
                                                                                                                                        
┌──(odin㉿sys-kali)-[~/elasticsearch]
└─$ docker build -t chemezovd/elasticsearch:v1 .
Sending build context to Docker daemon  3.584kB
Step 1/16 : FROM centos:7
7: Pulling from library/centos
2d473b07cdd5: Pull complete 
Digest: sha256:be65f488b7764ad3638f236b7b515b3678369a5124c47b8d32916d6487418ea4
Status: Downloaded newer image for centos:7
 ---> eeb6ee3f44bd
Step 2/16 : RUN yum install -y wget  &&     yum install -y perl-Digest-SHA
 ---> Running in fac5586fe9fa
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: mirror.plusserver.com
 * extras: mirror.plusserver.com
 * updates: mirror.plusserver.com
http://mirror.plusserver.com/centos/7.9.2009/os/x86_64/repodata/repomd.xml: [Errno 12] Timeout on http://mirror.plusserver.com/centos/7.9.2009/os/x86_64/repodata/repomd.xml: (28, 'Operation too slow. Less than 1000 bytes/sec transferred the last 30 seconds')              
Trying other mirror.                                                                                                                    
http://distrib-coffee.ipsl.jussieu.fr/pub/linux/centos/7.9.2009/os/x86_64/repodata/6d0c3a488c282fe537794b5946b01e28c7f44db79097bb06826e1c0c88bad5ef-primary.sqlite.bz2: [Errno 12] Timeout on http://distrib-coffee.ipsl.jussieu.fr/pub/linux/centos/7.9.2009/os/x86_64/repodata/6d0c3a488c282fe537794b5946b01e28c7f44db79097bb06826e1c0c88bad5ef-primary.sqlite.bz2: (28, 'Operation too slow. Less than 1000 bytes/sec transferred the last 30 seconds')                                                                                                      
Trying other mirror.                                                                                                                    
Resolving Dependencies                                                                                                                  
--> Running transaction check
---> Package wget.x86_64 0:1.14-18.el7_6.1 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package        Arch             Version                   Repository      Size
================================================================================
Installing:
 wget           x86_64           1.14-18.el7_6.1           base           547 k

Transaction Summary
================================================================================
Install  1 Package

Total download size: 547 k
Installed size: 2.0 M
Downloading packages:
warning: /var/cache/yum/x86_64/7/base/packages/wget-1.14-18.el7_6.1.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for wget-1.14-18.el7_6.1.x86_64.rpm is not installed                                                                         
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"                                                      
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5                                                                         
 Package    : centos-release-7-9.2009.0.el7.centos.x86_64 (@CentOS)                                                                     
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7                                                                                     
Running transaction check                                                                                                               
Running transaction test
Transaction test succeeded
Running transaction
  Installing : wget-1.14-18.el7_6.1.x86_64                                  1/1 
install-info: No such file or directory for /usr/share/info/wget.info.gz
  Verifying  : wget-1.14-18.el7_6.1.x86_64                                  1/1 

Installed:
  wget.x86_64 0:1.14-18.el7_6.1                                                 

Complete!
Loaded plugins: fastestmirror, ovl
Loading mirror speeds from cached hostfile
 * base: mirror.plusserver.com
 * extras: mirror.plusserver.com
 * updates: mirror.plusserver.com
Resolving Dependencies
--> Running transaction check
---> Package perl-Digest-SHA.x86_64 1:5.85-4.el7 will be installed
--> Processing Dependency: perl >= 5.003000 for package: 1:perl-Digest-SHA-5.85-4.el7.x86_64
--> Processing Dependency: perl(vars) for package: 1:perl-Digest-SHA-5.85-4.el7.x86_64
--> Processing Dependency: perl(strict) for package: 1:perl-Digest-SHA-5.85-4.el7.x86_64
--> Processing Dependency: perl(integer) for package: 1:perl-Digest-SHA-5.85-4.el7.x86_64
--> Processing Dependency: perl(Getopt::Long) for package: 1:perl-Digest-SHA-5.85-4.el7.x86_64
--> Processing Dependency: perl(Fcntl) for package: 1:perl-Digest-SHA-5.85-4.el7.x86_64
--> Processing Dependency: perl(Exporter) for package: 1:perl-Digest-SHA-5.85-4.el7.x86_64
--> Processing Dependency: perl(DynaLoader) for package: 1:perl-Digest-SHA-5.85-4.el7.x86_64
--> Processing Dependency: perl(Digest::base) for package: 1:perl-Digest-SHA-5.85-4.el7.x86_64
--> Processing Dependency: perl(Carp) for package: 1:perl-Digest-SHA-5.85-4.el7.x86_64
--> Processing Dependency: perl(:MODULE_COMPAT_5.16.3) for package: 1:perl-Digest-SHA-5.85-4.el7.x86_64
--> Processing Dependency: /usr/bin/perl for package: 1:perl-Digest-SHA-5.85-4.el7.x86_64
--> Running transaction check
---> Package perl.x86_64 4:5.16.3-299.el7_9 will be installed
--> Processing Dependency: perl-libs = 4:5.16.3-299.el7_9 for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Socket) >= 1.3 for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Scalar::Util) >= 1.10 for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl-macros for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl-libs for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(threads::shared) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(threads) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(constant) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Time::Local) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Time::HiRes) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Storable) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Socket) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Scalar::Util) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Pod::Simple::XHTML) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Pod::Simple::Search) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Filter::Util::Call) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(File::Temp) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(File::Spec::Unix) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(File::Spec::Functions) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(File::Spec) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(File::Path) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: perl(Cwd) for package: 4:perl-5.16.3-299.el7_9.x86_64
--> Processing Dependency: libperl.so()(64bit) for package: 4:perl-5.16.3-299.el7_9.x86_64
---> Package perl-Carp.noarch 0:1.26-244.el7 will be installed
---> Package perl-Digest.noarch 0:1.17-245.el7 will be installed
---> Package perl-Exporter.noarch 0:5.68-3.el7 will be installed
---> Package perl-Getopt-Long.noarch 0:2.40-3.el7 will be installed
--> Processing Dependency: perl(Pod::Usage) >= 1.14 for package: perl-Getopt-Long-2.40-3.el7.noarch
--> Processing Dependency: perl(Text::ParseWords) for package: perl-Getopt-Long-2.40-3.el7.noarch
--> Running transaction check
---> Package perl-File-Path.noarch 0:2.09-2.el7 will be installed
---> Package perl-File-Temp.noarch 0:0.23.01-3.el7 will be installed
---> Package perl-Filter.x86_64 0:1.49-3.el7 will be installed
---> Package perl-PathTools.x86_64 0:3.40-5.el7 will be installed
---> Package perl-Pod-Simple.noarch 1:3.28-4.el7 will be installed
--> Processing Dependency: perl(Pod::Escapes) >= 1.04 for package: 1:perl-Pod-Simple-3.28-4.el7.noarch
--> Processing Dependency: perl(Encode) for package: 1:perl-Pod-Simple-3.28-4.el7.noarch
---> Package perl-Pod-Usage.noarch 0:1.63-3.el7 will be installed
--> Processing Dependency: perl(Pod::Text) >= 3.15 for package: perl-Pod-Usage-1.63-3.el7.noarch
--> Processing Dependency: perl-Pod-Perldoc for package: perl-Pod-Usage-1.63-3.el7.noarch
---> Package perl-Scalar-List-Utils.x86_64 0:1.27-248.el7 will be installed
---> Package perl-Socket.x86_64 0:2.010-5.el7 will be installed
---> Package perl-Storable.x86_64 0:2.45-3.el7 will be installed
---> Package perl-Text-ParseWords.noarch 0:3.29-4.el7 will be installed
---> Package perl-Time-HiRes.x86_64 4:1.9725-3.el7 will be installed
---> Package perl-Time-Local.noarch 0:1.2300-2.el7 will be installed
---> Package perl-constant.noarch 0:1.27-2.el7 will be installed
---> Package perl-libs.x86_64 4:5.16.3-299.el7_9 will be installed
---> Package perl-macros.x86_64 4:5.16.3-299.el7_9 will be installed
---> Package perl-threads.x86_64 0:1.87-4.el7 will be installed
---> Package perl-threads-shared.x86_64 0:1.43-6.el7 will be installed
--> Running transaction check
---> Package perl-Encode.x86_64 0:2.51-7.el7 will be installed
---> Package perl-Pod-Escapes.noarch 1:1.04-299.el7_9 will be installed
---> Package perl-Pod-Perldoc.noarch 0:3.20-4.el7 will be installed
--> Processing Dependency: perl(parent) for package: perl-Pod-Perldoc-3.20-4.el7.noarch
--> Processing Dependency: perl(HTTP::Tiny) for package: perl-Pod-Perldoc-3.20-4.el7.noarch
--> Processing Dependency: groff-base for package: perl-Pod-Perldoc-3.20-4.el7.noarch
---> Package perl-podlators.noarch 0:2.5.1-3.el7 will be installed
--> Running transaction check
---> Package groff-base.x86_64 0:1.22.2-8.el7 will be installed
---> Package perl-HTTP-Tiny.noarch 0:0.033-3.el7 will be installed
---> Package perl-parent.noarch 1:0.225-244.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                    Arch       Version                Repository   Size
================================================================================
Installing:
 perl-Digest-SHA            x86_64     1:5.85-4.el7           base         58 k
Installing for dependencies:
 groff-base                 x86_64     1.22.2-8.el7           base        942 k
 perl                       x86_64     4:5.16.3-299.el7_9     updates     8.0 M
 perl-Carp                  noarch     1.26-244.el7           base         19 k
 perl-Digest                noarch     1.17-245.el7           base         23 k
 perl-Encode                x86_64     2.51-7.el7             base        1.5 M
 perl-Exporter              noarch     5.68-3.el7             base         28 k
 perl-File-Path             noarch     2.09-2.el7             base         26 k
 perl-File-Temp             noarch     0.23.01-3.el7          base         56 k
 perl-Filter                x86_64     1.49-3.el7             base         76 k
 perl-Getopt-Long           noarch     2.40-3.el7             base         56 k
 perl-HTTP-Tiny             noarch     0.033-3.el7            base         38 k
 perl-PathTools             x86_64     3.40-5.el7             base         82 k
 perl-Pod-Escapes           noarch     1:1.04-299.el7_9       updates      52 k
 perl-Pod-Perldoc           noarch     3.20-4.el7             base         87 k
 perl-Pod-Simple            noarch     1:3.28-4.el7           base        216 k
 perl-Pod-Usage             noarch     1.63-3.el7             base         27 k
 perl-Scalar-List-Utils     x86_64     1.27-248.el7           base         36 k
 perl-Socket                x86_64     2.010-5.el7            base         49 k
 perl-Storable              x86_64     2.45-3.el7             base         77 k
 perl-Text-ParseWords       noarch     3.29-4.el7             base         14 k
 perl-Time-HiRes            x86_64     4:1.9725-3.el7         base         45 k
 perl-Time-Local            noarch     1.2300-2.el7           base         24 k
 perl-constant              noarch     1.27-2.el7             base         19 k
 perl-libs                  x86_64     4:5.16.3-299.el7_9     updates     690 k
 perl-macros                x86_64     4:5.16.3-299.el7_9     updates      44 k
 perl-parent                noarch     1:0.225-244.el7        base         12 k
 perl-podlators             noarch     2.5.1-3.el7            base        112 k
 perl-threads               x86_64     1.87-4.el7             base         49 k
 perl-threads-shared        x86_64     1.43-6.el7             base         39 k

Transaction Summary
================================================================================
Install  1 Package (+29 Dependent packages)

Total download size: 12 M
Installed size: 40 M
Downloading packages:
--------------------------------------------------------------------------------
Total                                              4.5 MB/s |  12 MB  00:02     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : groff-base-1.22.2-8.el7.x86_64                              1/30 
  Installing : 1:perl-parent-0.225-244.el7.noarch                          2/30 
  Installing : perl-HTTP-Tiny-0.033-3.el7.noarch                           3/30 
  Installing : perl-podlators-2.5.1-3.el7.noarch                           4/30 
  Installing : perl-Pod-Perldoc-3.20-4.el7.noarch                          5/30 
  Installing : 1:perl-Pod-Escapes-1.04-299.el7_9.noarch                    6/30 
  Installing : perl-Encode-2.51-7.el7.x86_64                               7/30 
  Installing : perl-Text-ParseWords-3.29-4.el7.noarch                      8/30 
  Installing : perl-Pod-Usage-1.63-3.el7.noarch                            9/30 
  Installing : 4:perl-macros-5.16.3-299.el7_9.x86_64                      10/30 
  Installing : 4:perl-Time-HiRes-1.9725-3.el7.x86_64                      11/30 
  Installing : perl-Exporter-5.68-3.el7.noarch                            12/30 
  Installing : perl-constant-1.27-2.el7.noarch                            13/30 
  Installing : perl-Socket-2.010-5.el7.x86_64                             14/30 
  Installing : perl-Time-Local-1.2300-2.el7.noarch                        15/30 
  Installing : perl-Carp-1.26-244.el7.noarch                              16/30 
  Installing : perl-Storable-2.45-3.el7.x86_64                            17/30 
  Installing : perl-PathTools-3.40-5.el7.x86_64                           18/30 
  Installing : perl-Scalar-List-Utils-1.27-248.el7.x86_64                 19/30 
  Installing : 1:perl-Pod-Simple-3.28-4.el7.noarch                        20/30 
  Installing : perl-File-Temp-0.23.01-3.el7.noarch                        21/30 
  Installing : perl-File-Path-2.09-2.el7.noarch                           22/30 
  Installing : perl-threads-shared-1.43-6.el7.x86_64                      23/30 
  Installing : perl-threads-1.87-4.el7.x86_64                             24/30 
  Installing : perl-Filter-1.49-3.el7.x86_64                              25/30 
  Installing : 4:perl-libs-5.16.3-299.el7_9.x86_64                        26/30 
  Installing : perl-Getopt-Long-2.40-3.el7.noarch                         27/30 
  Installing : 4:perl-5.16.3-299.el7_9.x86_64                             28/30 
  Installing : perl-Digest-1.17-245.el7.noarch                            29/30 
  Installing : 1:perl-Digest-SHA-5.85-4.el7.x86_64                        30/30 
  Verifying  : perl-HTTP-Tiny-0.033-3.el7.noarch                           1/30 
  Verifying  : perl-threads-shared-1.43-6.el7.x86_64                       2/30 
  Verifying  : 4:perl-Time-HiRes-1.9725-3.el7.x86_64                       3/30 
  Verifying  : perl-Exporter-5.68-3.el7.noarch                             4/30 
  Verifying  : perl-constant-1.27-2.el7.noarch                             5/30 
  Verifying  : perl-PathTools-3.40-5.el7.x86_64                            6/30 
  Verifying  : 4:perl-macros-5.16.3-299.el7_9.x86_64                       7/30 
  Verifying  : 1:perl-parent-0.225-244.el7.noarch                          8/30 
  Verifying  : perl-Socket-2.010-5.el7.x86_64                              9/30 
  Verifying  : groff-base-1.22.2-8.el7.x86_64                             10/30 
  Verifying  : perl-File-Temp-0.23.01-3.el7.noarch                        11/30 
  Verifying  : 1:perl-Pod-Simple-3.28-4.el7.noarch                        12/30 
  Verifying  : perl-Time-Local-1.2300-2.el7.noarch                        13/30 
  Verifying  : 1:perl-Pod-Escapes-1.04-299.el7_9.noarch                   14/30 
  Verifying  : perl-Carp-1.26-244.el7.noarch                              15/30 
  Verifying  : perl-Storable-2.45-3.el7.x86_64                            16/30 
  Verifying  : perl-Scalar-List-Utils-1.27-248.el7.x86_64                 17/30 
  Verifying  : perl-Pod-Usage-1.63-3.el7.noarch                           18/30 
  Verifying  : perl-Encode-2.51-7.el7.x86_64                              19/30 
  Verifying  : perl-Pod-Perldoc-3.20-4.el7.noarch                         20/30 
  Verifying  : perl-podlators-2.5.1-3.el7.noarch                          21/30 
  Verifying  : 4:perl-5.16.3-299.el7_9.x86_64                             22/30 
  Verifying  : perl-File-Path-2.09-2.el7.noarch                           23/30 
  Verifying  : 1:perl-Digest-SHA-5.85-4.el7.x86_64                        24/30 
  Verifying  : perl-threads-1.87-4.el7.x86_64                             25/30 
  Verifying  : perl-Filter-1.49-3.el7.x86_64                              26/30 
  Verifying  : perl-Getopt-Long-2.40-3.el7.noarch                         27/30 
  Verifying  : perl-Text-ParseWords-3.29-4.el7.noarch                     28/30 
  Verifying  : perl-Digest-1.17-245.el7.noarch                            29/30 
  Verifying  : 4:perl-libs-5.16.3-299.el7_9.x86_64                        30/30 

Installed:
  perl-Digest-SHA.x86_64 1:5.85-4.el7                                           

Dependency Installed:
  groff-base.x86_64 0:1.22.2-8.el7                                              
  perl.x86_64 4:5.16.3-299.el7_9                                                
  perl-Carp.noarch 0:1.26-244.el7                                               
  perl-Digest.noarch 0:1.17-245.el7                                             
  perl-Encode.x86_64 0:2.51-7.el7                                               
  perl-Exporter.noarch 0:5.68-3.el7                                             
  perl-File-Path.noarch 0:2.09-2.el7                                            
  perl-File-Temp.noarch 0:0.23.01-3.el7                                         
  perl-Filter.x86_64 0:1.49-3.el7                                               
  perl-Getopt-Long.noarch 0:2.40-3.el7                                          
  perl-HTTP-Tiny.noarch 0:0.033-3.el7                                           
  perl-PathTools.x86_64 0:3.40-5.el7                                            
  perl-Pod-Escapes.noarch 1:1.04-299.el7_9                                      
  perl-Pod-Perldoc.noarch 0:3.20-4.el7                                          
  perl-Pod-Simple.noarch 1:3.28-4.el7                                           
  perl-Pod-Usage.noarch 0:1.63-3.el7                                            
  perl-Scalar-List-Utils.x86_64 0:1.27-248.el7                                  
  perl-Socket.x86_64 0:2.010-5.el7                                              
  perl-Storable.x86_64 0:2.45-3.el7                                             
  perl-Text-ParseWords.noarch 0:3.29-4.el7                                      
  perl-Time-HiRes.x86_64 4:1.9725-3.el7                                         
  perl-Time-Local.noarch 0:1.2300-2.el7                                         
  perl-constant.noarch 0:1.27-2.el7                                             
  perl-libs.x86_64 4:5.16.3-299.el7_9                                           
  perl-macros.x86_64 4:5.16.3-299.el7_9                                         
  perl-parent.noarch 1:0.225-244.el7                                            
  perl-podlators.noarch 0:2.5.1-3.el7                                           
  perl-threads.x86_64 0:1.87-4.el7                                              
  perl-threads-shared.x86_64 0:1.43-6.el7                                       

Complete!
Removing intermediate container fac5586fe9fa
 ---> 31372e158c87
Step 3/16 : ENV ES_DIR="/opt/elasticsearch"
 ---> Running in 324c884b4901
Removing intermediate container 324c884b4901
 ---> c0a29a7562a0
Step 4/16 : ENV ES_HOME="${ES_DIR}/elasticsearch-7.16.0"
 ---> Running in 3c73441b146b
Removing intermediate container 3c73441b146b
 ---> a6152ef2ced3
Step 5/16 : WORKDIR ${ES_DIR}
 ---> Running in 913b3a3cafd1
Removing intermediate container 913b3a3cafd1
 ---> 1a2d2daee977
Step 6/16 : RUN wget --quiet https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.0-linux-x86_64.tar.gz &&     wget --quiet https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.0-linux-x86_64.tar.gz.sha512 &&     sha512sum --check --quiet elasticsearch-7.16.0-linux-x86_64.tar.gz.sha512 &&     tar -xzf elasticsearch-7.16.0-linux-x86_64.tar.gz
 ---> Running in 4cf3002d8dda
Removing intermediate container 4cf3002d8dda
 ---> 6b4e32b1b7da
Step 7/16 : COPY elasticsearch.yml ${ES_HOME}/config
 ---> b676c05792aa
Step 8/16 : ENV ES_USER="elastic"
 ---> Running in 22c43b3dac38
Removing intermediate container 22c43b3dac38
 ---> 107fa484b9c3
Step 9/16 : RUN useradd ${ES_USER}
 ---> Running in f32210c70a5d
Removing intermediate container f32210c70a5d
 ---> 554764495286
Step 10/16 : RUN mkdir -p "/var/lib/elasticsearch" &&     mkdir -p "/var/log/elasticsearch"
 ---> Running in 669a9eb8cb4a
Removing intermediate container 669a9eb8cb4a
 ---> 8238ae65f658
Step 11/16 : RUN chown -R ${ES_USER}: "${ES_DIR}" &&     chown -R ${ES_USER}: "/var/lib/elasticsearch" &&     chown -R ${ES_USER}: "/var/log/elasticsearch"
 ---> Running in 4edf1f7153c3
Removing intermediate container 4edf1f7153c3
 ---> 7bdc31af9cdb
Step 12/16 : USER ${ES_USER}
 ---> Running in d1b1118e4750
Removing intermediate container d1b1118e4750
 ---> 4243649b4238
Step 13/16 : WORKDIR "${ES_HOME}"
 ---> Running in 23504df68d27
Removing intermediate container 23504df68d27
 ---> bbf1531791e8
Step 14/16 : EXPOSE 9200
 ---> Running in a8681eff08b4
Removing intermediate container a8681eff08b4
 ---> c15c238b65fc
Step 15/16 : EXPOSE 9300
 ---> Running in 42d74e9a90dc
Removing intermediate container 42d74e9a90dc
 ---> 46f60d863d9b
Step 16/16 : ENTRYPOINT ["./bin/elasticsearch"]
 ---> Running in 10ff6f62277d
Removing intermediate container 10ff6f62277d
 ---> a40a217348bd
Successfully built a40a217348bd
Successfully tagged chemezovd/elasticsearch:v1

┌──(odin㉿sys-kali)-[~/elasticsearch]
└─$ docker images                               
REPOSITORY                TAG       IMAGE ID       CREATED         SIZE
chemezovd/elasticsearch   v1        a40a217348bd   2 minutes ago   2.25GB
centos                    7         eeb6ee3f44bd   2 years ago     204MB

                                                                                                                                        
┌──(odin㉿sys-kali)-[~/elasticsearch]
└─$ docker push chemezovd/elasticsearch:v1      
The push refers to repository [docker.io/chemezovd/elasticsearch]
ace8131cb1b5: Pushed 
951e3c2fc6a5: Pushed 
458315f87c39: Pushed 
bfaf541599f0: Pushed 
44df4eb35970: Pushed 
b6357983d78f: Pushed 
6394b6d1185e: Pushed 
174f56854903: Layer already exists
v1: digest: sha256:2fe463bbaf04d4ef06fdb95c76ce99fdb149563fa93c56534a97df4b5d862afa size: 1996
______________________________________________________________________________________________

                                                                                                                                        
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

Получите список индексов и их статусов, используя API, и **приведите в ответе** на задание.

Получите состояние кластера `Elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находятся в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера Elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В этом задании вы научитесь:

- создавать бэкапы данных,
- восстанавливать индексы из бэкапов.

Создайте директорию `{путь до корневой директории с Elasticsearch в образе}/snapshots`.

Используя API, [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
эту директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `Elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `Elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:

- возможно, вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `Elasticsearch`.

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

# Домашнее задание к занятию 1.  «Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения»


## Как сдавать задания

Обязательны к выполнению задачи без звёздочки. Их нужно выполнить, чтобы получить зачёт и диплом о профессиональной переподготовке.

Задачи со звёздочкой (*) — это дополнительные задачи и/или задачи повышенной сложности. Их выполнять не обязательно, но они помогут вам глубже понять тему.

Домашнее задание выполняйте в файле readme.md в GitHub-репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---

## Важно

Перед отправкой работы на проверку удаляйте неиспользуемые ресурсы.
Это нужно, чтобы не расходовать средства, полученные в результате использования промокода.

Подробные рекомендации [здесь](https://github.com/netology-code/virt-homeworks/blob/virt-11/r/README.md).

---

## Задача 1

Опишите кратко, в чём основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.

- Полная или аппаратная виртуализация сразу может использовать аппаратные ресурсы сервера и не нуждаетя в операционной системе для управления виртуальными машинами.
- Паравиртуализация - программное обеспечение, использующее операционную систему для разделения ресурсов между виртуальными машинами.
- Виртуализация на основе ОС позволяет запускать изолированные "контейнеры" на хосте, которые по сути являются небольшими отдельными копиями хостовой ОС. (Наверное неправильно выразился, но в целом - на linux запускаем только такие же linux гостевые ОС). Удобно для тестирования и прочего создания множества подобных систем.


## Задача 2

Выберите один из вариантов использования организации физических серверов в зависимости от условий использования.

Организация серверов:

- физические сервера,
- паравиртуализация,
- виртуализация уровня ОС.

Условия использования:

- высоконагруженная база данных, чувствительная к отказу;
- различные web-приложения;
- Windows-системы для использования бухгалтерским отделом;
- системы, выполняющие высокопроизводительные расчёты на GPU.

Опишите, почему вы выбрали к каждому целевому использованию такую организацию.

- Для высоконагруженных баз лучшим решением будет аппаратная виртуализация типа ESXI или XEN поскольку при этом максимум ресурсов можно выделить для ВМ и при этом обеспечить отказоустойчивость и резевное копирование.
- Для различных web-приложений лучше всего подойдет контейнеризация типа Docker или LXC, поскольку их гораздо легче масштабировать в заисимости от нагрузки сервисов.
- Windows системы для использования бухгалтерским отделом я бы разместил на паравиртуальном Hyper-V к примеру ввиду быстроты и простоты развертывания и обслуживания.
- Системы, выполняющие высокопроизводительные расчеты на GPU лучше размещать на аппаратной виртуализации для того чтобы задействовать максимум ресурсов.

## Задача 3

Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based-инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.
2. Требуется наиболее производительное бесплатное open source-решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.
3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows-инфраструктуры.
4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.

- 1 сценарий - VMWare VSphere - позволяет создавать кластера серверов для большей отказоустойчивости, имеет множество сторонних решения для бэкапа. Позволяет автоматизировать создания и обслуживание виртуальных машин.
- 2 сценарий - KVM - бесплатное решение, производительное. Есть множество систем виртуализации на базе KVM, например Proxmox. Так же есть множество инструментов для резервного копирования, либо можно написать самому и бэкапить машины через скрипты.
- 3 сценарий - MS HyperV - бесплатное решение, так же при его использовании с windows инфраструктурой можно немного съэкономить на лицензиях.
- 4 сценарий - Docker - можно запустить на подавляющем большинстве дистрибутивов Linux. Сборку и развёртывание контейнеров можно автоматизировать например через docker-compose.

## Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.

Возможные проблемы и недостатки гетерогенной среды виртуализации:
- сложность администрирования;
- необходимое наличие высококвалифицированных специалистов;
- повышенный риск отказа и недоступности;
- авышенная стоимость обслуживания;

Действия для минимизации рисков и проблем:
- если гетерогенность не оправдана, то рассмотреть возможность отказа от нее;
- если она оправдана, то часть инфраструктуры можно перенести на IaaS (AWS), а саму инфраструктуру вывести в IaC (Terraform)
- максимальное автоматизировать развертывание и тестирование инфраструктуры, чтобы она была единая.

Я бы предпочел работать в единой среде. Небольшие выгоды в цене и производительности при использовании разных сред ведут
к большим издержкам и не всегда оправданы. И если нет возможности избежать гетерогенной среды виртуализации необходима максимальная автоматизация процессов.

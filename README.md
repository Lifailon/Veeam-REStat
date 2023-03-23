# Veeam-REStat (Veeam REST Statistic)

![Image alt](https://github.com/Lifailon/Veeam-Job-Stat/blob/rsa/Screen/Logo.jpg)

Модуль, использующий **REST API (Invoke-WebRequest)** для сбора статистических данных. Используется для быстрого сбора информации с целью анализа и настройки мониторинга. **Протестировано и работает для PowerShell версии 5.1 и 7.3**, по умолчанию подключение происходит через **HTTPS**, игнорируя проверку сертификата.

## 🔑 Параметры (ключи).

`-Server` имя сервера VBR, по умолчанию **localhost** \
`-port` порт, по умолчанию **9419** \
`-Reset` сброс учетных данных для подключения к серверу VBR. \
`-Statistic` статистика всех заданий с сортировкой по дате. Выводит время начала, завершения и статус работы, процент прогресса, результат выполнений (**Result**) и сообщение с причиной в случае ошибки (**Warning/Failed**). \
`-Jobs` подробная статистика по всем настроенным заданиям резеврного копирования: статус работы (**In Active/disabled**), результат последнего задания (**LastResult**), тип аутентификации (**Standard/Linux**), имя и размер виртуальной машины, тип резервного копирования (например, **Incremental**), дату и время последнего и следущего выполнения. \
`-ConfigBackup` отображает статус состояния работы резервного копирования конфигурации сервера VBR, кол-во точек восстановления, дату и время последней копии \
`-Repositories` статистика по инвентарным данным репозиториев: тип хранилища, путь на сервере до директории хранения, общий (**capacityGB**), свободный (**freeGB**) и используемый (**usedSpaceGB**) размер диска под данные. \
`-Backup` список заданий резервного копирования, тип копирования (**VM/Directory**), кол-во точек восстановления и полный путь до конечной директории с резервными копиями (точками восстановления). \
`-Points` история статистики всех точек восстановления с датой создания. \
`-Hosts` список физически (в ручную) добавленных хостов в инфраструктуру VBR. \
`-Proxy` список серверов с ролью Proxy \
`-Users` список УЗ, добавленных для подключения к серверам \
`-Service` выводит информацию о связанных внутренних службах, подключение к этим службам может потребоваться только для интеграции с VBR.

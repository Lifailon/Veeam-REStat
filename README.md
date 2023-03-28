# Veeam-REStat (Veeam REST Statistic)

![Image alt](https://github.com/Lifailon/Veeam-Job-Stat/blob/rsa/Screen/Logo.jpg)

Модуль, использующий **REST API (Invoke-WebRequest)** для сбора статистических данных. Можно использовать для быстрого анализа состава и состояния инфраструктуры Veeam Backup & Replication (VBR), настроки отправки Excel отчетов на почту о состоянии заданий и репозиториев, создание метрик для мониторинга.

## 🔔 Другие модули

 **[Veeam-Job-Stat](https://github.com/Lifailon/Veeam-Job-Stat)** - создания Excel отчетов о состоянии заданий резервного копирования, с отправкой на почту \
 **[Veeam-Rep-Stat](https://github.com/Lifailon/Veeam-Rep-Stat)** - мониторинг репозиториев

## 🚀 Установка

Для установки/обновления модуля, скачайте и запустите скрипт **[Deploy-Veeam-REStat.ps1](https://github.com/Lifailon/Veeam-REStat/blob/rsa/Deploy-Veeam-REStat.ps1)**

**Работает для PowerShell версии 5.1 и 7.3**, по умолчанию подключение происходит через **HTTPS**, игнорируя проверку сертификата.

Протестированы все доступные **методы GET с Veeam Backup & Replication 11**, используя **Swagger api-version 1.0-rev2**.

При первом запуске необходимо заполнить **Credential** для подключения к экземпляру сервера VBR, которые сохраняются в файл с именем сервера в формате **xml** с применением шифрования **System.Management.Automation.PSCredential** для последующего подключения.

## 🔑 Ключи

✅ `-Server` имя сервера VBR, по умолчанию **localhost** \
✅ `-Port` порт, по умолчанию **9419** \
✅ `-Reset` сброс учетных данных для подключения к серверу VBR. \
✅ `-Statistic` статистика всех заданий с сортировкой по дате. Выводит время начала, завершения и статус работы, процент прогресса, результат выполнений (**Result**) и сообщение с причиной в случае ошибки (**Warning/Failed**). \
✅ `-Jobs` подробная статистика по всем настроенным заданиям резеврного копирования: статус работы (**In Active/disabled**), результат последнего задания (**LastResult**), тип аутентификации (**Standard/Linux**), имя и размер виртуальной машины, тип резервного копирования (например, **Incremental**), дату и время последнего и следущего выполнения. \
✅ `-ConfigBackup` отображает статус состояния работы резервного копирования конфигурации сервера VBR, кол-во точек восстановления, дату и время последней копии \
✅ `-Repositories` статистика по инвентарным данным репозиториев: тип хранилища, путь на сервере до директории хранения, общий (**capacityGB**), свободный (**freeGB**) и используемый (**usedSpaceGB**) размер диска под данные. \
✅ `-Backup` список заданий резервного копирования, тип копирования (**VM/Directory**) и кол-во точек восстановления. \
✅ `-Points` история статистики всех точек восстановления с датой создания. \
✅ `-Hosts` список физически (в ручную) добавленных хостов в инфраструктуру VBR. \
✅ `-Proxy` список серверов с ролью Proxy \
✅ `-Users` список УЗ, добавленных для подключения к серверам \
✅ `-Service` выводит информацию о связанных внутренних службах, подключение к этим службам может потребоваться только для интеграции с VBR.

## 🎉 Примеры

![Image alt](https://github.com/Lifailon/Veeam-REStat/blob/rsa/Screen/Example-1.jpg)

![Image alt](https://github.com/Lifailon/Veeam-REStat/blob/rsa/Screen/Example-2.jpg)

![Image alt](https://github.com/Lifailon/Veeam-REStat/blob/rsa/Screen/Example-3.jpg)

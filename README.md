# Veeam-REStat (Veeam REST Statistic)

![Image alt](https://github.com/Lifailon/Veeam-Job-Stat/blob/rsa/Screen/Logo.jpg)

Модуль, использующий **REST API (Invoke-WebRequest)** для сбора статистических данных. Используется для быстрого сбора информации с целью анализа и настройки мониторинга. По умолчанию подключение происходит через **HTTPS**, игнорируя проверку сертификата.

> **Протестировано и работает для PowerShell версии 5.1 и 7.3.**

## Параметры (ключи).

`-Server` имя сервера VBR, по умолчанию **localhost** \
`-port` порт, по умолчанию **9419** \
`-Reset` сброс учетных данных для подключения \
`-Statistic` отображает статус состояния работы резервного копирования конфигурации сервера VBR, кол-во точек восстановления и время последней копии \
`-Jobs` подробная статистика по всех настроенным заданиям резеврного окпирования \
Veeam-REStat srv-veeam-11 -ConfigBackup   # configuration backup
Veeam-REStat srv-veeam-11 -Repositories   # repositories statistic
Veeam-REStat srv-veeam-11 -Service        # services list
Veeam-REStat srv-veeam-11 -Hosts          # physical added hosts to backup infrastructure 
Veeam-REStat srv-veeam-11 -Proxy          # proxy server list
Veeam-REStat srv-veeam-11 -Users          # users list
Veeam-REStat srv-veeam-11 -Backup         # backup type, count points restore and path
Veeam-REStat srv-veeam-11 -Points         # all restore points

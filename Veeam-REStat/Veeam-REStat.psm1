function Veeam-REStat {
<#
.SYNOPSIS
Module for get Veeam BR statistic by using REST API (Invoke-WebRequest)
Tested on PowerShell verison 5.1 and 7.3 for Veeam Backup & Replication 11 using Swagger api-version 1.0-rev2
.DESCRIPTION
Example:
Veeam-REStat -Server localhost -Port 9419 # param default
Veeam-REStat srv-veeam-11 -Reset          # reset credential
Veeam-REStat srv-veeam-11 -Statistic      # backup jobs statistic
Veeam-REStat srv-veeam-11 -Jobs           # jobs statistic
Veeam-REStat srv-veeam-11 -ConfigBackup   # configuration backup
Veeam-REStat srv-veeam-11 -Repositories   # repositories statistic
Veeam-REStat srv-veeam-11 -Backup         # backup type, count points restore and path
Veeam-REStat srv-veeam-11 -Points         # all restore points
Veeam-REStat srv-veeam-11 -Hosts          # physical added hosts to backup infrastructure 
Veeam-REStat srv-veeam-11 -Proxy          # proxy server list
Veeam-REStat srv-veeam-11 -Users          # users list
Veeam-REStat srv-veeam-11 -Service        # services list
.LINK
https://github.com/Lifailon/Veeam-REStat
#>
Param (
$Server = "localhost",
$Port   = "9419",
[switch]$Reset,
[switch]$Statistic,
[switch]$Jobs,
[switch]$ConfigBackup,
[switch]$Repositories,
[switch]$Backup,
[switch]$Points,
[switch]$Hosts,
[switch]$Proxy,
[switch]$Users,
[switch]$Service
)
$srv = "https://$server"+":$port"
if (!($Reset -or $Statistic -or $Jobs -or $ConfigBackup -or $Repositories -or $Service -or $Hosts -or `
$Proxy -or $Users -or $Backup -or $Points)) {
Write-Host (Get-Help Veeam-REStat).DESCRIPTION.Text
return
}
### SkipCertificateCheck
$PSv5 = $PSVersionTable.PSVersion.Major -eq 5
if ($PSv5) {
add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
public bool CheckValidationResult(
ServicePoint srvPoint, X509Certificate certificate,
WebRequest request, int certificateProblem) {
return true;
}
}
"@
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
}
### Cred
$path = ($env:PSModulePath.Split(";")[0])+"\Veeam-REStat\Creds"
if (!(Test-Path $path)) {
New-Item $path -ItemType Directory -Force | Out-Null
}
$CredFile = "$path\$server.xml"
if ($Reset) {
rm $CredFile -ErrorAction Ignore
}
if (Test-Path $CredFile) {
$Cred = Import-Clixml -path $CredFile
} elseif (!(Test-Path $CredFile)) {
$Cred = Get-Credential -Message "Enter credential"
if ($Cred -ne $null) {
$Cred | Export-CliXml -Path $CredFile
} else{
return
}
}
$user = $Cred.UserName
$pass = $Cred.GetNetworkCredential().Password
### Auth
$Header = @{
"x-api-version" = "1.0-rev2"
}
$Body = @{
"grant_type" = "password"
"username" = "$user"
"password" = "$pass"
}
if ($PSv5) {
$vpost = iwr "$srv/api/oauth2/token" -Method POST -Headers $Header -Body $Body
} else {
$vpost = iwr "$srv/api/oauth2/token" -Method POST -Headers $Header -Body $Body -SkipCertificateCheck
}
$vtoken = (($vpost.Content) -split '"')[3]

$Header = @{
"x-api-version" = "1.0-rev2"
"Authorization" = "Bearer $vtoken"
}
### Statistic
if ($Statistic) {
if ($PSv5) {
$vjob = iwr "$srv/api/v1/sessions" -Method GET -Headers $Header
} else {
$vjob = iwr "$srv/api/v1/sessions" -Method GET -Headers $Header -SkipCertificateCheck
}
($vjob.Content | ConvertFrom-Json).data | select name,sessionType,state,progressPercent,creationTime,endTime,
@{Name="Result"; Expression={$_.result.result}},
@{Name="Message"; Expression={$_.result.message}}
}
### Jobs
if ($Jobs) {
if ($PSv5) {
$vjob = iwr "$srv/api/v1/jobs" -Method GET -Headers $Header
$vjobStat = iwr "$srv/api/v1/jobs/states" -Method GET -Headers $Header
} else {
$vjob = iwr "$srv/api/v1/jobs" -Method GET -Headers $Header -SkipCertificateCheck
$vjobStat = iwr "$srv/api/v1/jobs/states" -Method GET -Headers $Header -SkipCertificateCheck
}
$vjob_out = ($vjob.Content | ConvertFrom-Json).data
$vjobStat_out = ($vjobStat.Content | ConvertFrom-Json).data

$vjob_out | select name,type,
@{Name="Status"; Expression={$vjobStat_out | ? id -like $_.id | select -ExpandProperty status}},
@{Name="LastResult"; Expression={$vjobStat_out | ? id -like $_.id | select -ExpandProperty lastResult}},
@{Name="Cred"; Expression={$_.guestProcessing.guestCredentials.credsType}},
@{Name="VMName"; Expression={$_.virtualMachines.includes.inventoryObject.name}},
@{Name="VMSize"; Expression={$_.virtualMachines.includes.size}},
@{Name="ModeType"; Expression={$_.storage.advancedSettings.backupModeType}},
@{Name="Repository"; Expression={$vjobStat_out | ? id -like $_.id | select -ExpandProperty repositoryName}},
@{Name="LastRun"; Expression={$vjobStat_out | ? id -like $_.id | select -ExpandProperty lastRun}},
@{Name="NextRun"; Expression={$vjobStat_out | ? id -like $_.id | select -ExpandProperty nextRun}},
@{Name="ScheduleDaily"; Expression={$_.schedule.daily.localTime}},
@{Name="Points"; Expression={[string]$_.storage.retentionPolicy.quantity+" "+$_.storage.retentionPolicy.type}},
description
}
### ConfigBackup
if ($ConfigBackup) {
if ($PSv5) {
$vjob = iwr "$srv/api/v1/configBackup" -Method GET -Headers $Header
} else {
$vjob = iwr "$srv/api/v1/configBackup" -Method GET -Headers $Header -SkipCertificateCheck
}
($vjob.Content | ConvertFrom-Json) | select isEnabled,restorePointsToKeep,
@{Name="Daily"; Expression={$_.schedule.daily.dailyKind}},
@{Name="Time"; Expression={$_.schedule.daily.localTime}},
@{Name="LastSuccessful"; Expression={$_.lastSuccessfulBackup.lastSuccessfulTime}}
}
### Repositories
if ($Repositories) {
if ($PSv5) {
$vjob = iwr "$srv/api/v1/backupInfrastructure/repositories/states" -Method GET -Headers $Header
} else {
$vjob = iwr "$srv/api/v1/backupInfrastructure/repositories/states" -Method GET -Headers $Header -SkipCertificateCheck
}
($vjob.Content | ConvertFrom-Json).data | select name,hostName,type,path,capacityGB,freeGB,usedSpaceGB,description
}
### Backup
if ($Backup) {
if ($PSv5) {
$vjob = iwr "$srv/api/v1/backupObjects" -Method GET -Headers $Header
} else {
$vjob = iwr "$srv/api/v1/backupObjects" -Method GET -Headers $Header -SkipCertificateCheck
}
($vjob.Content | ConvertFrom-Json).data | select name,type,viType,platformName,restorePointsCount,path
}
### Points
if ($Points) {
if ($PSv5) {
$vjob = iwr "$srv/api/v1/objectRestorePoints" -Method GET -Headers $Header
} else {
$vjob = iwr "$srv/api/v1/objectRestorePoints" -Method GET -Headers $Header -SkipCertificateCheck
}
($vjob.Content | ConvertFrom-Json).data | select name,creationTime | sort name
}
### Hosts
if ($Hosts) {
if ($PSv5) {
$vjob = iwr "$srv/api/v1/backupInfrastructure/managedServers" -Method GET -Headers $Header
} else {
$vjob = iwr "$srv/api/v1/backupInfrastructure/managedServers" -Method GET -Headers $Header -SkipCertificateCheck
}
($vjob.Content | ConvertFrom-Json).data | select name,type,viHostType,port,description
}
### Proxy
if ($Proxy) {
if ($PSv5) {
$vjob = iwr "$srv/api/v1/backupInfrastructure/proxies" -Method GET -Headers $Header
} else {
$vjob = iwr "$srv/api/v1/backupInfrastructure/proxies" -Method GET -Headers $Header -SkipCertificateCheck
}
($vjob.Content | ConvertFrom-Json).data | select name,type,
@{Name="MaxTaskCount"; Expression={$_.server.maxTaskCount}},
@{Name="TransportMode"; Expression={$_.server.transportMode}},
@{Name="FailoverToNetwork"; Expression={$_.server.failoverToNetwork}},
@{Name="HostToProxyEncryption"; Expression={$_.server.hostToProxyEncryption}},
description
}
### Users
if ($users) {
if ($PSv5) {
$vjob = iwr "$srv/api/v1/credentials" -Method GET -Headers $Header
} else {
$vjob = iwr "$srv/api/v1/credentials" -Method GET -Headers $Header -SkipCertificateCheck
}
($vjob.Content | ConvertFrom-Json).data | select type,username,description,creationTime
}
### Service
if ($Service) {
if ($PSv5) {
$vjob = iwr "$srv/api/v1/services" -Method GET -Headers $Header
} else {
$vjob = iwr "$srv/api/v1/services" -Method GET -Headers $Header -SkipCertificateCheck
}
($vjob.Content | ConvertFrom-Json).data
}
}
$path = ($env:PSModulePath.Split(";")[0])+"\Veeam-REStat\Veeam-REStat.psm1"
if (!(Test-Path $path)) {
New-Item $path -ItemType "File" -Force
}
(iwr https://raw.githubusercontent.com/Lifailon/Veeam-REStat/rsa/Veeam-REStat/Veeam-REStat.psm1).Content | Out-File $path -Force
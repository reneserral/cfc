# Script de Configuración de Windows 8.1 IE11

# Configuración de la zona horaria
tzutil /s "Romance Standard Time" 
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name sShortTime -Value H:mm
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name sTimeFormat -Value H:mm:ss
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name sShortDate -Value d/M/yyyy
Set-ItemProperty -Path 'HKCU:\Control Panel\International' -Name iFirstDayOfWeek -Value 0

# Actualización de la ayuda de PowerShell
Write-Host "Actualizando ayuda de PowerShell" -ForegroundColor Green
Update-Help -ErrorAction SilentlyContinue

# Cmdlets para internacionalización
# https://technet.microsoft.com/en-us/library/hh852115.aspx
# Get-Command -Module International
# [System.Globalization.CultureInfo]::GetCultures('InstalledWin32Cultures')

# Cambio del teclado en-US a es-ES ;-)
Write-Host "Cambiando teclado a es-ES" -ForegroundColor Green
Set-WinUserLanguageList -LanguageList es-ES -Force

# Deshabilitar instalación automática de actualizaciones
Write-Host "Deshabilitando Auto Update (Microsoft Update)" -ForegroundColor Green
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name 'AUOptions' -Value 2
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name 'CachedAUOptions' -Value 2
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update' -Name 'IncludeRecommendedUpdates' -Value 1

# Deshabilitar Windows Update
Write-Host "Deshabilitando Windows Update" -ForegroundColor Green
sc.exe config wuauserv start= disabled > $null

# Deshabilitar Windows Search
# https://lookeen.com/blog/how-to-disable-windows-search-in-windows-8-and-10
Write-Host "Deshabilitando Windows Search" -ForegroundColor Green
sc.exe config wsearch start= disabled > $null

# Deshabilitar Windows Defender
# https://www.windowscentral.com/how-permanently-disable-windows-defender-windows-10
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f > $null

# Deshabilitar SMBv1 (WannaCry)
Write-Host "Deshabilitando SMBv1" -ForegroundColor Green
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force > $null
sc.exe config lanmanworkstation depend= bowser/mrxsmb20/nsi > $null
sc.exe config mrxsmb10 start= disabled > $null

# Deshabilitar IPv6 y Teredo
reg.exe add hklm\system\currentcontrolset\services\tcpip6\parameters /v DisabledComponents /t REG_DWORD /d 0xffffffff /f > $null
netsh.exe interface teredo set state disabled > $null

# Obtención de la ubicación de carpetas especiales
# http://windowsitpro.com/powershell/easily-finding-special-paths-powershell-scripts
# [Environment+SpecialFolder]::GetNames([Environment+SpecialFolder])

# Creación de la carpeta MASTER en el escritorio
Write-Host "Creando carpeta MASTER" -ForegroundColor Green
$DesktopFolder = "$([Environment]::GetFolderPath("Desktop"))\MASTER"
if (!(Test-Path -Path "$DesktopFolder")) { mkdir "$DesktopFolder" | Out-Null }
if (!(Test-Path -Path "$DesktopFolder\Downloads")) { mkdir "$DesktopFolder\Downloads" | Out-Null }

# Tres métodos distintos para descargar ficheros en PowerShell
# https://blog.jourdant.me/post/3-ways-to-download-files-with-powershell

# Descarga 7-Zip
$progDownload = "7z2107-x64.msi"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando 7-Zip ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest http://www.7-zip.org/a/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "7-Zip ya estaba descargado" -ForegroundColor Yellow
}

# Instalación de 7-Zip
Write-Host "Instalando 7-Zip ... " -ForegroundColor Green -NoNewline
msiexec.exe /i "$DesktopFolder\Downloads\$progDownload" /passive
Write-Host "OK" -ForegroundColor Yellow

# Descarga Git-Portable
$progDownload = "Git-2.36.1-64-bit.exe"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Git-Portable ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.36.1.windows.1/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "Git-Portable ya esta descargado" -ForegroundColor Yellow
}

# Instalación de Git-Portable
Write-Host "Descomprimiendo Git Portable ... " -ForegroundColor Green -NoNewline
if (Test-Path -Path "$DesktopFolder\Git") { Remove-Item -Path "$DesktopFolder\Git" -Recurse -Force }
& "$DesktopFolder\Downloads\$progDownload" /SILENT
Write-Host "OK" -ForegroundColor Yellow

# Descarga Sysinternals Suite
$progDownload = "SysinternalsSuite.zip"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Sysinternals Suite ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest https://download.sysinternals.com/files/$progDownload -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "SysinternalsSuite ya esta descargado" -ForegroundColor Yellow
}

# Instalación de Sysinternals Suite
Write-Host "Descomprimiendo Sysinternals Suite ... " -ForegroundColor Green -NoNewline
if (Test-Path -Path "$DesktopFolder\Sysinternals") { Remove-Item -Path "$DesktopFolder\Sysinternals" -Recurse -Force }
& "$env:ProgramFiles\7-Zip\7z.exe" x -o"$DesktopFolder\Sysinternals" -y "$DesktopFolder\Downloads\$progDownload" | Out-Null
Write-Host "OK" -ForegroundColor Yellow

# Descarga scripts del Máster
if (Test-Path -Path "$DesktopFolder\Scripts") {
    Remove-Item "$DesktopFolder\Scripts" -Recurse -Force | Out-Null
}
mkdir "$DesktopFolder\Scripts" -Force | Out-Null
& "git" clone https://github.com/rene-serral/cfc.git "$DesktopFolder\Scripts"

# Creación carpeta C:\TEST
if (!(Test-Path -Path "C:\TEST")) { mkdir "C:\TEST" | Out-Null }

# Creación de usuarios 'testX'
Write-Host "Creando usuario 'test1' ... " -ForegroundColor Green -NoNewline
net.exe user test1 /add Passw0rd! >$null
Write-Host "Creando usuario 'test2' ... " -ForegroundColor Green -NoNewline
net.exe user test2 /add Passw0rd! >$null
Write-Host "Creando usuario 'test3' ... " -ForegroundColor Green -NoNewline
net.exe user test3 /add Passw0rd! >$null

# Descarga Wazuh Agent
$progDownload = "wazuh-agent-4.3.0-1.msi"
if (!(Test-Path -Path "$DesktopFolder\Downloads\$progDownload")) {
    Write-Host "Descargando Wazuh Agent ... " -ForegroundColor Green -NoNewline
    $start_time = Get-Date
    Invoke-WebRequest "https://packages.wazuh.com/4.x/windows/$progDownload" -OutFile "$DesktopFolder\Downloads\$progDownload"
    Write-Host "$((Get-Date).Subtract($start_time).Seconds) segundo(s)" -ForegroundColor Yellow
} else {
    Write-Host "Wazuh Agent ya estaba descargado" -ForegroundColor Yellow
}

# Instalación de Wazuh Agent
Write-Host "Instalando Wazuh Agent ... " -ForegroundColor Green -NoNewline
& "$DesktopFolder\Downloads\$progDownload" /q WAZUH_MANAGER="192.168.56.10" WAZUH_REGISTRATION_SERVER="192.168.56.10"
Write-Host "OK" -ForegroundColor Yellow

Write-Host "OK, para acabar la configuración vamos a reiniciar la máquina ..."
Start-Sleep 15
Stop-Computer -Force


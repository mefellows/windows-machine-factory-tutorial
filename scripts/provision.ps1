(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1  
choco install 7zip
choco install seek-dsc

# Disable Windows Updates
cmd /c reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 1 /f 

tzutil /s \"AUS Eastern Standard Time\"

# ELK
$env:JAVA_HOME="${env:ProgramFiles(x86)}\Java\jre7"
[Environment]::SetEnvironmentVariable("JAVA_HOME", $env:JAVA_HOME, "User")
[Environment]::SetEnvironmentVariable("JAVA_HOME", $env:JAVA_HOME, "Machine")

choco install nssm
choco install logstash

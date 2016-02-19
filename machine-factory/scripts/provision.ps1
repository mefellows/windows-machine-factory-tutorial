(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1
choco install 7zip -y
choco install seek-dsc -y

# Disable Windows Updates
cmd /c reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 1 /f

tzutil /s "AUS Eastern Standard Time"

Install-WindowsFeature Web-Server
Install-WindowsFeature Web-Mgmt-Tools
Install-WindowsFeature Web-App-Dev -IncludeAllSubFeature

# Install Mongo. Issues with `choco install mongo`
# https://gist.github.com/tekmaven/041a205276bf4d26e8f9

# Make sure 7za is installed
choco install -y 7zip.commandline

# Create mongodb and data directory
md $env:temp\mongo\data

# Go to mongodb dir
Push-Location $env:temp\mongo

# Download zipped mongodb binaries to mongodbdir
Invoke-WebRequest https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-2.6.5.zip -OutFile mongodb.zip

# Extract mongodb zip
cmd /c 7za e -y mongodb.zip

# Install mongodb as a windows service
cmd /c $env:temp\mongo\mongod.exe --logpath=$env:temp\mongo\log --dbpath=$env:temp\mongo\data\ --smallfiles --install

# Sleep as a hack to fix an issue where the service sometimes does not finish installing quickly enough
Start-Sleep -Seconds 5

# Start mongodb service
net start mongodb

# Return to last location, to run the build
Pop-Location

Write-Host
Write-Host "monogdb installation complete"

# Allows us to build without VS
# Note: you will need to copy \ package the reference assemblies (we have created an internal Nuget chocolatey package to distribute)
# see http://nickberardi.com/a-net-build-server-without-visual-studio/ for details
choco install microsoft-build-tools  -y
choco install vs2013agents -y
choco install netfx-4.5.1-devpack  -y
choco install ruby -y
choco install terraform -y
choco install packer-windows-plugins -pre -y
install-windowsfeature NET-Framework-Core

# F# Bundle
cd $env:TEMP
$webclient = New-Object Net.WebClient
$url = 'http://download.microsoft.com/download/E/A/3/EA38D9B8-E00F-433F-AAB5-9CDA28BA5E7D/FSharp_Bundle.exe'
$webclient.DownloadFile($url,   "$pwd\FSharp_Bundle.exe")
.\FSharp_Bundle.exe /install /quiet

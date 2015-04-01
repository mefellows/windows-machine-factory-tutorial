# NOTE: Pause for a few minutes before running this script as the system seems to take itself down after rebooting.

# Disk Cleanup - doesn't get rid of anything at this early stage
# Write-Host "cleaning disk..."
# C:\Windows\System32\cleanmgr.exe /d c: /verylowdisk

 # Remove unnecessary features
@('Desktop-Experience',
'InkAndHandwritingServices',
'Server-Media-Foundation') | Remove-WindowsFeature

# Remove ALL features not installed (but 'Available')
# TODO: What impact will this have on the DSC stuff?
 Get-WindowsFeature | 
? { $_.InstallState -eq 'Available' } | 
Uninstall-WindowsFeature -Remove

# Defrag C
Optimize-Volume -DriveLetter C

wget http://download.sysinternals.com/files/SDelete.zip -OutFile sdelete.zip
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem")
[System.IO.Compression.ZipFile]::ExtractToDirectory("sdelete.zip", ".") 

reg.exe ADD "HKCU\Software\Sysinternals\SDelete" /v EulaAccepted /t REG_DWORD /d 1 /f
./sdelete.exe -z c:
# There needs to be Oracle CA (Certificate Authority) certificates installed in order
# to prevent user intervention popups which will undermine a silent installation.
cmd /c certutil -addstore -f "TrustedPublisher" A:\oracle-cert.cer

# Remove if dodgey previous version already exists
rm "C:\Windows\Temp\VBoxGuestAdditions.iso" -ErrorAction SilentlyContinue
(New-Object System.Net.WebClient).DownloadFile('http://download.virtualbox.org/virtualbox/5.0.14/VBoxGuestAdditions_5.0.14.iso', 'C:\Windows\Temp\VBoxGuestAdditions.iso')

7z x -tiso -y C:\Windows\Temp\VBoxGuestAdditions.iso -oC:\Windows\Temp\virtualbox
cmd /c C:\Windows\Temp\virtualbox\VBoxWindowsAdditions.exe /S
rm "C:\Windows\Temp\VBoxGuestAdditions.iso" -ErrorAction SilentlyContinue

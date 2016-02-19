# There needs to be Oracle CA (Certificate Authority) certificates installed in order
# to prevent user intervention popups which will undermine a silent installation.
cmd /c certutil -addstore -f "TrustedPublisher" A:\oracle-cert.cer

cmd /c move /Y C:\Users\vagrant\VBoxGuestAdditions.iso C:\Windows\Temp
cmd /c 7za x C:\Windows\Temp\VBoxGuestAdditions.iso -oC:\Windows\Temp\virtualbox
cmd /c C:\Windows\Temp\virtualbox\VBoxWindowsAdditions.exe /S
rm C:\Windows\Temp\VBoxGuestAdditions.iso

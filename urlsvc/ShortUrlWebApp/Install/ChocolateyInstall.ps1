# This is a workaround to deal with the fact that
# 1) New Chocolatey now sets the UI Culture to invariant
# 2) DSC Tries to Import-LocalizedData (line 57 of C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSDesiredStateConfiguration\PSDesiredStateConfiguration.psm1)
#    which uses implicit UI Culture, but of course is not available in this mode.
If ( -not ( Test-Path "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSDesiredStateConfiguration\PSDesiredStateConfiguration.Resource.psd1" ) ) {
  cmd /c mklink C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSDesiredStateConfiguration\PSDesiredStateConfiguration.Resource.psd1 C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSDesiredStateConfiguration\en-US\PSDesiredStateConfiguration.Resource.psd1
}

$outputPath = $env:TEMP
$webAppPath = $(Join-Path $env:chocolateyPackageFolder "/lib/_PublishedWebsites/ShortUrlWebApp")
Write-Verbose "Pointing application at ${webAppPath}!"
Write-Host "Pointing application at ${webAppPath}!"
$modules = $(Join-Path $env:chocolateyPackageFolder "/dsc/")
$env:PSModulePath+=";${modules}"

# Dot source the configuration file
. $(Join-Path $env:chocolateyPackageFolder "/dsc/MyWebsite.ps1")

MyWebsite -Force -OutputPath $outputPath -MachineName "localhost" -WebAppPath $webAppPath | Out-Null
Start-DscConfiguration -Wait -Verbose -Path $outputPath -ErrorAction Stop
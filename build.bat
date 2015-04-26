@echo off
cls
"Build\.chocolatey\chocolatey\tools\chocolateyInstall\NuGet.exe" "Install" "FAKE" "-OutputDirectory" "Build\packages" "-ExcludeVersion"
"Build\.chocolatey\chocolatey\tools\chocolateyInstall\NuGet.exe" "Install" "seek-dsc-networking" "-Version" "1.0.1" "-OutputDirectory" "Build\packages"
"Build\.chocolatey\chocolatey\tools\chocolateyInstall\NuGet.exe" "Install" "seek-dsc-webadministration" "-Version" "1.0.1" "-OutputDirectory" "Build\packages"
"Build\.chocolatey\chocolatey\tools\chocolateyInstall\NuGet.exe" "Install" "FSharp.Data" "-OutputDirectory" "Build\packages" "-ExcludeVersion"
"Build\packages\FAKE\tools\Fake.exe" build.fsx "%1"
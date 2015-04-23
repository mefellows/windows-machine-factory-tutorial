#!/bin/sh
export EnableNuGetPackageRestore=true
nuget "Install" "FAKE" "-OutputDirectory" "Build/packages" "-ExcludeVersion"
nuget "Install" "seek-dsc-networking" "-Version" "1.0.1" "-OutputDirectory" "Build/packages"
nuget "Install" "seek-dsc-webadministration" "-Version" "1.0.1" "-OutputDirectory" "Build/packages"
nuget "Install" "FSharp.Data" "-OutputDirectory" "Build/packages" "-ExcludeVersion"
mono "Build/packages/FAKE/tools/Fake.exe" build.fsx "$1"

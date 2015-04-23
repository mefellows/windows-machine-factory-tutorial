#r "System.Net.Http.dll"
#r "Build/packages/FAKE/tools/FakeLib.dll"
#r "Build/packages/FSharp.Data/lib/net40/FSharp.Data.dll"
open System
open System.IO
open System.Net
open System.Net.Http
open System.Text.RegularExpressions
open Fake
open Fake.AssemblyInfoFile
open FSharp.Data
open FSharp.Data.JsonExtensions

let projectName = "MachineFactoryTutorial"
let projectDescription = "Windows Machine Factory Tutorial"
let authors = ["mfellows"]
let applicationName = "Machine-Factory-Tutorial"
let packageName = applicationName.ToLowerInvariant()
let streamKey = "se"

// Paths
let testDir  = "./test/"
let buildDir = "./buildTemp/"
let packagingRoot = "./packaging/"
let root = "./"
let deployDir = "./publish/"

let version = defaultArg TeamCityBuildNumber "0.0"

tracefn "Version: %s" version

//RestorePackages()

// Targets
Target "Clean" (fun _ ->
    CleanDirs [ testDir; buildDir; packagingRoot; deployDir ]
)

Target "RestorePackages" (fun _ -> 
    !! "**/ShortUrl*/packages.config"
    |> Seq.iter (RestorePackage (fun p -> {p with OutputPath = "./packages"}))
 )

Target "AssemblyInfo" (fun _ ->
    CreateCSharpAssemblyInfo "./urlsvc/ShortUrlWebApp/Properties/AssemblyInfo.cs"
        [Attribute.Title projectName
         Attribute.Description projectDescription
         Attribute.Guid "1acd961c-b169-44ce-84f9-ed8e3f95aeb1"
         Attribute.Product projectName
         Attribute.Version version
         Attribute.FileVersion version]
)


Target "BuildWebApp" (fun _ ->
  !! @"**/ShortUrlWebApp.csproj"
  ++ @"**/ShortUrl.csproj"
    |> MSBuildRelease buildDir "Build"
    |> Log "AppBuild-Output: "
)

let dependencies =
        [ "seek-dsc-networking"
          "seek-dsc-webadministration" ]

Target "CreatePackage" (fun _ ->
    let packageDir = "./Build/packages/"
    let autoDep x = x, GetPackageVersion packageDir x
    let dependenciesWithVersion = dependencies |> List.map autoDep
    
    projectName
    |> sprintf "%s.nuspec"
    |> NuGet (fun p -> 
        {p with
            Authors = authors
            Project = packageName
            Description = projectDescription
            OutputPath = deployDir
            WorkingDir = root
            Version = version
            Dependencies = dependenciesWithVersion
            Files = [(@"buildTemp/**", Some "lib", None)
                     (@"urlsvc/ShortUrlWebApp/modules/**/*", Some "dsc", None)
                     (@"urlsvc/ShortUrlWebApp/manifests/*", Some "dsc", None)
                     (@"urlsvc/ShortUrlWebApp/Install/*", Some "Install", None)]

            // This is the choco install part...
            //(@"../urlsvc" @@ projectName @@ "Install/**", Some "tools", None)]
            Publish = false }) 
)

Target "CreateSourceZip" (fun _ ->
    let copyPackage name =
        let pkg = sprintf "**/%s*.nupkg" name
        !! pkg
        |> Copy deployDir

    dependencies
    |> List.iter copyPackage

    !! (deployDir @@ "*.nupkg")
    |> Zip deployDir (deployDir @@ "source.zip")
)

Target "All" DoNothing
//Target "RestorePackages" DoNothing

// Dependencies
"Clean"
    ==> "BuildWebApp"
    ==> "CreatePackage"
    ==> "CreateSourceZip"
    ==> "All"


// start build
RunTargetOrDefault "All"

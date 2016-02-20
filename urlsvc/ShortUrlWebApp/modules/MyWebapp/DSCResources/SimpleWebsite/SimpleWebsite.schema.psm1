Configuration SimpleWebsite
{
    param
    (
        [String]$WebAppPath             = "c:\myWebApp",
        [String]$WebSiteName            = "UrlSvc",
        [String]$HostNameSuffix         = "dev",
        [String]$HostName               = "urlsvc.${HostNameSuffix}",
        [String]$ApiAppPoolName         = "UrlSvc-API",
        [HashTable]$AuthenticationInfo = @{Anonymous = "true"; Basic = "false"; Digest = "false"; Windows = "false"}
    )

    Import-DscResource -Module cWebAdministration
    Import-DscResource -Module cNetworking

    # Stop the default website
    cWebsite DefaultSite
    {
        Ensure          = "Absent"
        Name            = "Default Web Site"
        State           = "Stopped"
        PhysicalPath    = "C:\inetpub\wwwroot"
    }

    cWebAppPool APIAppPool
    {
        Name = $ApiAppPoolName
        ApplicationName = "Default"
        Ensure = "Present"
        State = "Started"
        IdentityType = "SpecificUser"
        UserName =  "vagrant"
        Password = "FooBar@123"
    }

    cWebsite UrlSvcWebsite
    {
        Ensure = "Present"
        Name   = $WebSiteName
        ApplicationPool = $ApiAppPoolName
        BindingInfo = @(
                        SEEK_cWebBindingInformation
                        {
                            Protocol = "http"
                            Port = 80
                            HostName = $HostName
                            IPAddress = "*"
                        };SEEK_cWebBindingInformation
                        {
                            Protocol = "http"
                            Port = 80
                            IPAddress = "*"
                        })
        AuthenticationInfo = SEEK_cWebAuthenticationInformation
        {
            Anonymous = "true"
            Basic = "false"
            Digest = "false"
            Windows = "false"
        }
        HostFileInfo = @(SEEK_cHostEntryFileInformation
                        {
                            RequireHostFileEntry = $True
                            HostEntryName = $HostName
                            HostIpAddress = "127.0.0.1"
                        })
        PhysicalPath = $WebAppPath
        State = "Started"
        DependsOn = @("[cWebsite]DefaultSite")
    }

    Environment DatabaseURL
    {
        Name = "DATABASE_URL"
        Ensure = "Present"
        Value = "mongodb://localhost:27017/short_url" 
    }
}

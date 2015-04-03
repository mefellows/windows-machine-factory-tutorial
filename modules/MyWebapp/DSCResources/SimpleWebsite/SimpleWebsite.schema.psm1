﻿Configuration SimpleWebsite
{
    param
    (
        [String]$WebAppPath             = "c:\myWebApp",
        [String]$WebSiteName            = "UrlSvc",
        [String]$WebAppName             = "UrlSvc-API",
        [String]$HostNameSuffix         = "dev",
        [String]$HostName               = "api.urlsvc.${HostNameSuffix}",
        [String]$SslCertStoreName       = "My",
        [String]$SslCertPath            = "Cert:\LocalMachine\My",
        [String]$ApiAppPoolName         = "UrlSvc-API",
        [String]$AppPoolIdentityType    = "ApplicationPoolIdentity",
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
        # IdentityType = $AppPoolIdentityType
        IdentityType = "SpecificUser"
        UserName =  "vagrant"
        Password = "vagrant"
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
<#

    cWebApplication UrlSvcApiWebApplication
    {
        Name = "UrlSvc/App"
        WebSite = $WebSiteName
        WebAppPool = $ApiAppPoolName
        PhysicalPath = $WebAppPath
        AuthenticationInfo = SEEK_cWebAuthenticationInformation {
            Anonymous = "true"
            Basic = "false"
            Digest = "false"
            Windows = "false"
        }
        DependsOn = @("[cWebVirtualDirectory]UrlSvcVirtualDirectory")
    }
#>
}

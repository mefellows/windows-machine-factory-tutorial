Configuration MyWebsite
{
  param (
    [string] $MachineName,
    [string] $WebAppPath = "c:\vagrant\urlsvc\ShortUrlWebApp"
  )

  Import-DscResource -Module MyWebapp
  Import-DscResource -Module cNetworking

  Node $MachineName
  {
    WindowsFeature IIS
    {
        Ensure = "Present"
        Name = "Web-Server"
    }

    WindowsFeature IISManagerFeature
    {
        Ensure = "Present"
        Name = "Web-Mgmt-Tools"
    }    

    WindowsFeature WebApp
    {
        Ensure = "Present"
        Name = "Web-App-Dev"
		IncludeAllSubFeature = $True
    }    

    cFirewallRule webFirewall
    {
        Name = "WebFirewallOpen"
        Direction = "Inbound"
        LocalPort = "80"
        Protocol = "TCP"
        Action = "Allow"
        Ensure = "Present"   
    }
    SimpleWebsite sWebsite
    {
        WebAppPath = $WebAppPath
        DependsOn  = '[cWebsite]DefaultWebsite'
    }    
  }
}

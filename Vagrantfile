# -*- mode: ruby -*-
# vi: set ft=ruby :

$shell_script = <<SCRIPT
  choco install mongodb -y

  # Ensure we have a local IIS readable directory
  $share = "\\vboxsvr\vagrant"
  $guest_path = "c:\code
  cmd /c  mklink /d $guest_path  $share
  cmd /c "NET SHARE code=$guest_path /GRANT:Everyone,FULL"

SCRIPT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "machinefactory-api-1.0.1"
  hostname = "urlsvc.dev"
  ip_address = "10.0.0.30"

  host_port = 5895
  config.winrm.host = "localhost"
  config.winrm.password = "FooBar@123"
  config.winrm.port = host_port
  config.winrm.guest_port = host_port
  config.vm.guest = :windows
  config.vm.communicator = "winrm"
  config.vm.network :forwarded_port,   guest: 3389, host: 3399,       id: "rdp",   auto_correct: false
  config.vm.network :forwarded_port,   guest: 5985, host: host_port,  id: "winrm", auto_correct: false
  config.vm.network :forwarded_port,   guest: 80,   host: 8000,       id: "web" # Port forward for IIS
  config.vm.network :forwarded_port,   guest: 443,  host: 8443,       id: "ssl" # Port forward for SSL IIS
  config.vm.network :forwarded_port,   guest: 4018, host: 4018,       id: "remotevsdebug"
  config.vm.network "private_network", ip: ip_address

  config.vm.provider "virtualbox" do |v|
    v.gui = true
  end

  if Vagrant.has_plugin?("vagrant-multi-hostsupdater")
    config.multihostsupdater.aliases = {ip_address => [hostname]}
  end

  config.vm.synced_folder '.', "/cygdrive/c/vagrant",
    type: "rsync",
    rsync__auto: "true",
    rsync__exclude: [".git/","*.box", "output-*"],
    id: "vagrant"

  # Install Chocolatey and some basic DSC Resources
  config.vm.provision "shell", inline: $shell_script

  # Run DSC
  config.vm.provision "dsc", run: "always" do |dsc|

    # Set of module paths relative to the Vagrantfile dir.
    #
    # These paths are added to the DSC Configuration running
    # environment to enable local modules to be addressed.
    #
    # @return [Array] Set of relative module paths.
    dsc.module_path = ["urlsvc/ShortUrlWebApp/modules"]

    # The path relative to `dsc.manifests_path` pointing to the Configuration file
    dsc.configuration_file  = "MyWebsite.ps1"

    # The path relative to Vagrantfile pointing to the Configuration Data file
    dsc.configuration_data_file  = "urlsvc/ShortUrlWebApp/manifests/MyConfig.psd1"

    # The Configuration Command to run. Assumed to be the same as the `dsc.configuration_file`
    # (sans extension) if not provided.
    dsc.configuration_name = "MyWebsite"

    # Relative path to a pre-generated MOF file.
    #
    # Path is relative to the folder containing the Vagrantfile.
    # dsc.mof_path = "mof"

    # Relative path to the folder containing the root Configuration manifest file.
    # Defaults to 'manifests'.
    #
    # Path is relative to the folder containing the Vagrantfile.
    dsc.manifests_path = "urlsvc/ShortUrlWebApp/manifests"

    # Commandline arguments to the Configuration run
    #
    # Set of Parameters to pass to the DSC Configuration.
    dsc.configuration_params = {"-MachineName" => "localhost", "-WebAppPath" => "c:\\vagrant\\urlsvc", "-HostName" => hostname}

    # The type of synced folders to use when sharing the data
    # required for the provisioner to work properly.
    #
    # By default this will use the default synced folder type.
    # For example, you can set this to "nfs" to use NFS synced folders.
    # dsc.synced_folder_type = ""

    # Temporary working directory on the guest machine.
    # dsc.temp_dir = "c:/tmp/vagrant-dsc"
  end
end

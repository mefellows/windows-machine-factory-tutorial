choco install vs2013remotetools -Pre # Update 3: -Version 12.0.30723.5 -Pre

# For local dev iterations
choco uninstall seek-dsc-webadministration
choco install seek-dsc-webadministration -Version 1.0.0.79
choco install mongodb
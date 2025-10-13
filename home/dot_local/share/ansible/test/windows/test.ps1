# @file tests/windows/test.ps1
# @brief Runs an Ansible play on a GitHub Actions CI shared Windows runner
#
# @description
# This PowerShell script prepares a GitHub Actions CI shared Windows runner to test an
# Ansible play for Windows compatibility. Since Ansible cannot run on Windows,
# it uses WSL to run the play on the Windows host. The script performs the following tasks
# in order:
#
# 1. Changes the administrator password to AnsibleTest999 since it is unknown
# 2. Sets up WinRM CredSSP which Ansible connects with since SSH is currently not a viable option for
#    connecting to the Windows host from a WSL environment. The script this step uses is an
#    official example of how to set up WinRM on Windows for Ansible.
# 3. Runs the Ansible play via WSL

# @description Update admin password to AnsibleTest999
Write-Host "Changing $env:UserName password to 'AnsibleTest999'"
$NewPassword = ConvertTo-SecureString "AnsibleTest999" -AsPlainText -Force
Set-LocalUser -Name $env:UserName -Password $NewPassword

Write-Host "Setting up WinRM CredSSP"
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
PowerShell.exe -ExecutionPolicy ByPass -File $file -Verbose -EnableCredSSP -DisableBasicAuth -ForceNewSSLCert

# Alternate method which works if using winrm_connection_scheme http
# winrm quickconfig -q force
# winrm set winrm/config/service '@{AllowUnencrypted="true"}'
# winrm get winrm/config
# winrm enumerate winrm/config/listener

# POC for using Docker instead of WSL to do the provisioning:
# Write-Host "Running the Ansible play on the local machine via a Docker container with Ansible"
# $CurrentLocation = Get-Location
# $WorkDirectory = Split-Path -leaf -path (Get-Location)
# $HostIP = (Get-NetIPConfiguration | Where-Object -Property IPv4DefaultGateway).IPv4Address.IPAddress
# docker run -v $("$($CurrentLocation)"+':/'+$WorkDirectory) -w $('/'+$WorkDirectory) --add-host='windows-docker:'$HostIP --entrypoint /bin/sh megabytelabs/ansible:slim ./tests/windows/test.sh

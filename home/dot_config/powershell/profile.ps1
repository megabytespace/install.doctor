# [PSFzf](https://github.com/kelleyma49/PSFzf)
# [DockerCompletion](https://github.com/matt9ucci/DockerCompletion)

### Env
$env:EDITOR = 'code --wait'
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

### Set PowerShell to UTF-8
[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

### PSReadLine
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History

### Import PowerShell modules
$modules = @("Carbon", "ImportExcel", "Microsoft.PowerShell.ConsoleGuiTools", "Microsoft.PowerShell.PSResourceGet", "PSFzf", "PSWindowsUpdate", "PackageManagement", "PendingReboot", "posh-git", "Terminal-Icons")

foreach ($module in $modules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Install-Module -Name $module -Scope CurrentUser -Force -Repository PSGallery -AllowPrerelease
    }
    Import-Module $module -Force
}

### Carapace
Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
carapace _carapace | Out-String | Invoke-Expression

### Homebrew
# TODO - Add for case where value is /opt/homebrew/bin/brew shellenv
Add-Content -Path $PROFILE.CurrentUserAllHosts -Value '$(/usr/local/bin/brew shellenv) | Invoke-Expression'

### posh-git settings
oh-my-posh init pwsh --config "$env:HOME/.config/oh-my-posh/Betelgeuse.omp.json" | Invoke-Expression

### PSFzf settings
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PsFzfOption -TabExpansion
$env:_PSFZF_FZF_DEFAULT_OPTS = "--ansi --preview 'bat --color=always {}'"
Set-PSFzfOption -EnableAliasFuzzySetEverything

### zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

### Aliases
Set-Alias grep Select-String

### Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Source -ErrorAction SilentlyContinue
}

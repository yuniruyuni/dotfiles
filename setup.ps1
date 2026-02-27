#Requires -Version 5.1

# Windows bootstrap script (PowerShell equivalent of setup.sh)
# Run: cd ~\dotfiles && .\setup.ps1

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SETTINGS_ROOT = $PSScriptRoot

# ------------------------- collect variables
$Name = Read-Host "input your name (default: yuniruyuni)"
if ([string]::IsNullOrWhiteSpace($Name)) { $Name = "yuniruyuni" }

$Email = Read-Host "input your email (default: yuniruyuni@gmail.com)"
if ([string]::IsNullOrWhiteSpace($Email)) { $Email = "yuniruyuni@gmail.com" }

# ------------------------- install chocolatey
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    # Refresh environment to pick up choco command
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
} else {
    Write-Host "Chocolatey is already installed."
}

# ------------------------- install packages from chocolatey.config
Write-Host "Installing Chocolatey packages..."
choco install "$SETTINGS_ROOT\chocolatey.config" -y

# ------------------------- setup functions

function Create-IfMissing {
    param(
        [string]$Path,
        [string]$Content
    )
    if (-not (Test-Path $Path)) {
        $parentDir = Split-Path $Path -Parent
        if (-not (Test-Path $parentDir)) {
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        }
        Set-Content -Path $Path -Value $Content -Encoding UTF8
        Write-Host "Created: $Path"
    } else {
        Write-Host "Already exists (skipped): $Path"
    }
}

# ------------------------- install tools (winget, skip if already installed)

function Install-WingetPackage {
    param(
        [string]$PackageId,
        [string]$DisplayName
    )
    $installed = winget list --id $PackageId 2>$null | Select-String $PackageId
    if ($installed) {
        Write-Host "$DisplayName is already installed."
    } else {
        Write-Host "Installing $DisplayName..."
        winget install --id $PackageId --accept-source-agreements --accept-package-agreements
    }
}

# Note: WezTerm, MSYS2 are installed via Chocolatey
Install-WingetPackage "JanDeDobbeleer.OhMyPosh" "oh-my-posh"
Install-WingetPackage "jdx.mise" "mise"

# ------------------------- install rust
if (Get-Command rustup -ErrorAction SilentlyContinue) {
    Write-Host "Updating Rust toolchain..."
    rustup update
    rustup component add rustfmt
    rustup component add clippy
    rustup component add rust-analyzer
    rustup component add rust-src
} else {
    Write-Host "rustup not found. Please install Rust from https://rustup.rs/ first."
}

# ------------------------- prepare directories
$NvimConfigDir = "$env:LOCALAPPDATA\nvim"

New-Item -ItemType Directory -Path $NvimConfigDir -Force | Out-Null

# Normalize the dotfiles path with forward slashes for cross-shell compatibility
$DotfilesPath = $SETTINGS_ROOT -replace '\\', '/'

# ------------------------- output templates

# ------------ .gitconfig
Create-IfMissing "$HOME\.gitconfig" @"
[user]
  email = $Email
  name = $Name

[include]
  path = $DotfilesPath/.gitconfig
"@

# ------------ nvim/init.lua
Create-IfMissing "$NvimConfigDir\init.lua" @"
dofile("$DotfilesPath/nvim/init.lua")
"@

# ------------ .wezterm.lua
Create-IfMissing "$HOME\.wezterm.lua" @"
dofile("$DotfilesPath/wezterm.lua")
"@

# ------------------------- setup MSYS2
# Refresh environment variables to pick up MSYS2_ROOT set by Chocolatey
$env:MSYS2_ROOT = [System.Environment]::GetEnvironmentVariable("MSYS2_ROOT", "Machine")

# Detect MSYS2 installation path: MSYS2_ROOT env var → C:\tools\msys64 → C:\msys64
$MSYS2Root = if ($env:MSYS2_ROOT -and (Test-Path $env:MSYS2_ROOT)) { $env:MSYS2_ROOT }
             elseif (Test-Path "C:\tools\msys64") { "C:\tools\msys64" }
             elseif (Test-Path "C:\msys64") { "C:\msys64" }
             else { $null }

$MSYS2Home = $env:USERPROFILE

if ($MSYS2Root) {
    # Configure MSYS2 to use Windows USERPROFILE as HOME
    Write-Host "Configuring MSYS2 HOME to use Windows USERPROFILE..."
    $NsswitchPath = "$MSYS2Root\etc\nsswitch.conf"
    if (Test-Path $NsswitchPath) {
        $content = Get-Content $NsswitchPath -Raw
        if ($content -match "(?m)^db_home:") {
            $content = $content -replace "(?m)^db_home:.*", "db_home: windows"
        } else {
            $content = $content.TrimEnd() + "`ndb_home: windows`n"
        }
        Set-Content -Path $NsswitchPath -Value $content -NoNewline
    } else {
        Set-Content -Path $NsswitchPath -Value "db_home: windows`n" -NoNewline
    }

    Write-Host "Setting up MSYS2 zsh configuration..."
    New-Item -ItemType Directory -Path $MSYS2Home -Force | Out-Null

    $DotfilesUnixPath = "/c/Users/$env:USERNAME/dotfiles"

    # ------------ MSYS2 .zshrc
    Create-IfMissing "$MSYS2Home\.zshrc" @"
source $DotfilesUnixPath/.zshrc
"@

    # ------------ MSYS2 .zshenv
    Create-IfMissing "$MSYS2Home\.zshenv" @"
source $DotfilesUnixPath/.zshenv
"@

    # Run setup_msys2.sh to install zsh and tools
    Write-Host ""
    Write-Host "Installing MSYS2 packages (zsh, git, etc.)..."
    & "$MSYS2Root\usr\bin\bash.exe" -lc "cd $DotfilesUnixPath && ./setup_msys2.sh"
} else {
    Write-Host "MSYS2 not found at $MSYS2Root. Chocolatey installation may have failed."
    exit 1
}

Write-Host ""
Write-Host "Setup complete!"
Write-Host "Restart WezTerm to start using zsh."

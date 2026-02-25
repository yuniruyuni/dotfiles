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

Install-WingetPackage "Nushell.Nushell" "Nushell"
Install-WingetPackage "JanDeDobbeleer.OhMyPosh" "oh-my-posh"
Install-WingetPackage "jdx.mise" "mise"

# ------------------------- install rust
if (Get-Command rustup -ErrorAction SilentlyContinue) {
    Write-Host "Updating Rust toolchain..."
    rustup update
    rustup component add rustfmt
    rustup component add clippy
} else {
    Write-Host "rustup not found. Please install Rust from https://rustup.rs/ first."
}

# ------------------------- prepare directories
$NushellConfigDir = "$env:APPDATA\nushell"
$NvimConfigDir = "$env:LOCALAPPDATA\nvim"

New-Item -ItemType Directory -Path $NushellConfigDir -Force | Out-Null
New-Item -ItemType Directory -Path $NvimConfigDir -Force | Out-Null

# Normalize the dotfiles path with forward slashes for cross-shell compatibility
$DotfilesPath = $SETTINGS_ROOT -replace '\\', '/'

# ------------------------- output templates

# ------------ nushell/config.nu
Create-IfMissing "$NushellConfigDir\config.nu" @"
# dotfiles directory
const DOTFILES = '$DotfilesPath'

source `$"(`$DOTFILES)/nushell/config.nu"
"@

# ------------ nushell/env.nu
Create-IfMissing "$NushellConfigDir\env.nu" @"
# dotfiles directory
const DOTFILES = '$DotfilesPath'

source `$"(`$DOTFILES)/nushell/env.nu"
"@

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

Write-Host ""
Write-Host "Setup complete! Restart your terminal (WezTerm) to start using Nushell."

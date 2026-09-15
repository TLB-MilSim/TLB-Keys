<#
.SYNOPSIS
    Builds @TLB Keys from source.

.DESCRIPTION
    Packs every folder under addons\ into a PBO and lays out a ready-to-load mod
    folder in .\release.

    The PBO writer is built in, so no third-party packer and no P: drive are
    needed. If Arma 3 Tools is installed the configs are binarised to config.bin
    on the way through; if it is not, config.cpp ships as-is, which the engine
    reads perfectly well for a script-only mod.

.EXAMPLE
    .\tools\build.ps1
.EXAMPLE
    .\tools\build.ps1 -Deploy "E:\SteamLibrary\steamapps\common\Arma 3\!Workshop"
.EXAMPLE
    .\tools\build.ps1 -Sign -KeyName TLBKeys01
#>
[CmdletBinding()]
param(
    [string] $Deploy,
    [switch] $Sign,
    [string] $KeyName = "TLBKeys01",
    [switch] $NoBinarize
)

$ErrorActionPreference = "Stop"

$Root       = Split-Path -Parent $PSScriptRoot
$AddonsSrc  = Join-Path $Root "addons"
$ReleaseDir = Join-Path $Root "release\@TLB Keys"
$AddonsOut  = Join-Path $ReleaseDir "addons"
$KeysOut    = Join-Path $ReleaseDir "keys"
$Staging    = Join-Path $Root "release\.staging"

$PrefixFileName = [char]36 + "PBOPREFIX" + [char]36

# Development leftovers that have no business in a shipped PBO.
$Excluded = @("*.md", "*.bak", "*.psd", "*.tmp", "thumbs.db", "*.biprivatekey", "*.pbo")

function Write-PboString {
    param([System.IO.BinaryWriter] $Writer, [string] $Value)

    if ($Value.Length -gt 0) {
        $Writer.Write([System.Text.Encoding]::ASCII.GetBytes($Value))
    }
    $Writer.Write([byte] 0)
}

function New-Pbo {
    <#
        Writes a PBO the way the engine expects it:
          - a header entry whose packing method is "Vers", carrying the prefix
          - one entry per file, then an all-zero terminator entry
          - the file data back to back, in entry order
          - a 0x00 byte and the SHA1 of everything before it
    #>
    param(
        [string] $SourceDir,
        [string] $OutFile,
        [string] $Prefix
    )

    $files = Get-ChildItem -Path $SourceDir -Recurse -File | Where-Object {
        $name = $_.Name
        if ($name -eq $PrefixFileName) { return $false }
        foreach ($pattern in $Excluded) {
            if ($name -like $pattern) { return $false }
        }
        return $true
    } | Sort-Object FullName

    if ($files.Count -eq 0) { throw "No files to pack in $SourceDir" }

    $trimLength = $SourceDir.TrimEnd([char]92).Length + 1

    $stream = [System.IO.File]::Create($OutFile)
    $writer = New-Object System.IO.BinaryWriter($stream)

    try {
        # Header entry.
        Write-PboString $writer ""
        $writer.Write([uint32] 0x56657273)   # "Vers"
        $writer.Write([uint32] 0)
        $writer.Write([uint32] 0)
        $writer.Write([uint32] 0)
        $writer.Write([uint32] 0)

        Write-PboString $writer "prefix"
        Write-PboString $writer $Prefix
        Write-PboString $writer ""           # end of properties

        # File entries.
        foreach ($f in $files) {
            $relative = $f.FullName.Substring($trimLength).Replace([char]47, [char]92)
            Write-PboString $writer $relative
            $writer.Write([uint32] 0)            # packing method: uncompressed
            $writer.Write([uint32] 0)            # original size
            $writer.Write([uint32] 0)            # reserved
            $writer.Write([uint32] 0)            # timestamp
            $writer.Write([uint32] $f.Length)    # data size
        }

        # Terminator entry.
        Write-PboString $writer ""
        for ($i = 0; $i -lt 5; $i++) { $writer.Write([uint32] 0) }

        foreach ($f in $files) {
            $writer.Write([System.IO.File]::ReadAllBytes($f.FullName))
        }

        $writer.Flush()
    } finally {
        $writer.Dispose()
        $stream.Dispose()
    }

    # Trailing checksum covers every byte written so far, but not the 0x00
    # separator or the digest itself.
    $body = [System.IO.File]::ReadAllBytes($OutFile)
    $sha  = [System.Security.Cryptography.SHA1]::Create()
    $hash = $sha.ComputeHash($body)

    $append = [System.IO.File]::Open($OutFile, [System.IO.FileMode]::Append)
    try {
        $append.WriteByte(0)
        $append.Write($hash, 0, $hash.Length)
    } finally {
        $append.Dispose()
    }

    return $files.Count
}

function Get-CfgConvert {
    $cmd = Get-Command CfgConvert -ErrorAction SilentlyContinue
    if ($null -ne $cmd) { return $cmd.Source }

    $roots = @(
        "E:\SteamLibrary\steamapps\common\Arma 3 Tools",
        "C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools",
        "D:\SteamLibrary\steamapps\common\Arma 3 Tools",
        "F:\SteamLibrary\steamapps\common\Arma 3 Tools",
        "G:\SteamLibrary\steamapps\common\Arma 3 Tools"
    )
    foreach ($r in $roots) {
        $p = Join-Path $r "CfgConvert\CfgConvert.exe"
        if (Test-Path $p) { return $p }
    }
    return $null
}

Write-Host "Source : $AddonsSrc"
Write-Host "Output : $ReleaseDir"

$CfgConvert = $null
if (-not $NoBinarize) {
    $CfgConvert = Get-CfgConvert
    if ($null -eq $CfgConvert) {
        Write-Host "CfgConvert not found - shipping configs unbinarised (this is fine)." -ForegroundColor Yellow
    } else {
        Write-Host "Config   : $CfgConvert"
    }
}
Write-Host ""

# Empty the release folder rather than deleting it: the Arma 3 Launcher holds
# its folders open for as long as the mod is listed there as a local mod.
if (Test-Path $ReleaseDir) {
    Get-ChildItem -Path $ReleaseDir -Recurse -File -Force | Remove-Item -Force
}
if (Test-Path $Staging) { Remove-Item -Recurse -Force $Staging }
New-Item -ItemType Directory -Force -Path $AddonsOut | Out-Null

# Stage every addon before compiling any of them: components include headers
# from each other (every component takes its version from main), so the whole
# tree has to be in place before the preprocessor runs.
$components = @()

foreach ($dir in Get-ChildItem -Path $AddonsSrc -Directory) {
    $prefixFile = Join-Path $dir.FullName $PrefixFileName
    if (-not (Test-Path $prefixFile)) {
        Write-Host "  skipping $($dir.Name): no prefix file" -ForegroundColor Yellow
        continue
    }

    $stage = Join-Path $Staging $dir.Name
    Copy-Item -Recurse $dir.FullName $stage

    $components += [PSCustomObject]@{
        Name   = $dir.Name
        Stage  = $stage
        Prefix = (Get-Content -Raw -Path $prefixFile).Trim()
    }
}

foreach ($component in $components) {
    $dir = $component
    $stage = $component.Stage
    $prefix = $component.Prefix

    $configCpp = Join-Path $stage "config.cpp"

    # A config that asks __has_include whether another mod is present has to be
    # answered on the player's machine at game start, not frozen at build time,
    # so it ships as plain config.cpp.
    $dynamic = (Test-Path $configCpp) -and (Select-String -Path $configCpp -Pattern "__has_include" -SimpleMatch -Quiet)

    if ($null -ne $CfgConvert -and (Test-Path $configCpp) -and -not $dynamic) {
        $configBin = Join-Path $stage "config.bin"
        & $CfgConvert -bin -dst $configBin $configCpp | Out-Null

        if ($LASTEXITCODE -ne 0 -or -not (Test-Path $configBin)) {
            throw "Config failed to compile: $($dir.Name)\config.cpp"
        }

        # Pack one or the other - shipping both means the engine reads the .bin
        # while the .cpp quietly rots.
        Remove-Item -Force $configCpp
    }

    $pboName = "tlb_keys_$($dir.Name).pbo"
    $target  = Join-Path $AddonsOut $pboName

    $count = New-Pbo -SourceDir $stage -OutFile $target -Prefix $prefix
    $size  = [math]::Round((Get-Item $target).Length / 1KB, 1)

    Write-Host ("  {0,-26} {1,3} files  {2,7} KB" -f $pboName, $count, $size) -ForegroundColor Green
}

Remove-Item -Recurse -Force $Staging

Copy-Item (Join-Path $Root "mod.cpp") $ReleaseDir -Force
foreach ($extra in @("LICENSE", "README.md")) {
    $p = Join-Path $Root $extra
    if (Test-Path $p) { Copy-Item $p $ReleaseDir -Force }
}

if ($Sign) {
    $toolsRoot = @(
        "E:\SteamLibrary\steamapps\common\Arma 3 Tools",
        "C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools"
    ) | Where-Object { Test-Path $_ } | Select-Object -First 1

    if ($null -eq $toolsRoot) { throw "Arma 3 Tools not found; re-run without -Sign." }

    $createKey = Join-Path $toolsRoot "DSSignFile\DSCreateKey.exe"
    $signFile  = Join-Path $toolsRoot "DSSignFile\DSSignFile.exe"

    New-Item -ItemType Directory -Force -Path $KeysOut | Out-Null

    Push-Location $Root
    try {
        if (-not (Test-Path "$KeyName.biprivatekey")) { & $createKey $KeyName | Out-Null }
        Copy-Item "$KeyName.bikey" $KeysOut -Force

        foreach ($pbo in Get-ChildItem -Path $AddonsOut -Filter *.pbo) {
            & $signFile "$KeyName.biprivatekey" $pbo.FullName | Out-Null
        }
    } finally {
        Pop-Location
    }

    Write-Host "Signed with $KeyName" -ForegroundColor Green
}

if ($Deploy) {
    if (-not (Test-Path $Deploy)) { throw "Deploy target does not exist: $Deploy" }

    $dest = Join-Path $Deploy "@TLB Keys"
    Write-Host ""
    Write-Host "Deploying to $dest"

    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    Copy-Item -Recurse $ReleaseDir $dest
}

Write-Host ""
Write-Host "Build complete: $ReleaseDir" -ForegroundColor Green

<# PolicyRules es una carpeta donde contiene todas las reglas tanto creadas como importadas
    Se puede modificar el path para cambiar la ubicación, pero PolicyAnalizer no puede detectar
    dos ubicaciones a la vez, por lo que no detectará todos los .PolicyRules de distintas carpetas.
    Y es preferible tenerlo en una carpeta en común.

    LGPO.exe es el ejecutable que debe estar en la misma carpeta que el script, y es el encargado de
    importar y exportar las políticas locales.
#>
<#
.SYNOPSIS
    Script para gestión completa de políticas locales mediante LGPO.

.DESCRIPTION
    Este script permite gestionar políticas locales en un entorno Windows, ofreciendo:
    - Exportación de políticas locales mediante LGPO.
    - División (Split) de archivos .PolicyRules.
    - Verificación y actualización automática de PowerShell y sus módulos.
    - Funciones adicionales limpieza.
    - Backup y restauración podrían ser interesantes, pero no están implementadas

.PARAMETER Ninguno
    El script no requiere parámetros externos.

.EXAMPLE
    PS C:\> .\GestionPoliticas.ps1

    Ejecuta el script mostrando un menú interactivo para gestionar políticas locales.

.NOTES
    Autor: Zokkotyron & V1lTh
    Versión: 2.0
    Idioma: Español
#>
[CmdletBinding()]
param()

# --- Rutas globales
$currentPath   = Get-Location
$lgpoExe       = "$currentPath\PA40\LGPO.exe"
$policyRules   = "$currentPath\PolicyRules"
$exportDir     = "$currentPath\Exports"
$splitScript   = "$currentPath\PA40\Split-PolicyRules.ps1"
$backupDir     = "$currentPath\Backups"


Write-Host "===================================================" -ForegroundColor Gray
Write-Host "$currentPath" -ForegroundColor Gray
Write-Host "$lgpoExe" -ForegroundColor Gray
Write-Host "$policyRules" -ForegroundColor Gray
Write-Host "$exportDir" -ForegroundColor Gray
Write-Host "$splitScript" -ForegroundColor Gray
Write-Host "$backupDir" -ForegroundColor Gray
Write-Host "===================================================" -ForegroundColor Gray
function Update-PowerShellModules {
    <#
    .SYNOPSIS
        Updates PowerShell and all installed modules to their latest versions.
    .DESCRIPTION
        This function checks for updates to PowerShell itself, installs the latest version if necessary,
        and then proceeds to update all installed PowerShell modules to their latest available versions from the PowerShell Gallery.
    .EXAMPLE
        Update-PowerShellModules
    .NOTES
        Run this script with administrator privileges to ensure proper updating of PowerShell.
        All messages and feedback are provided in UK English.
    #>

    Write-Host "[INFO] Checking for PowerShell updates..." -ForegroundColor Cyan

    # Check current PowerShell version
    $currentVersion = $PSVersionTable.PSVersion
    Write-Host "[INFO] Current PowerShell version: $($currentVersion)" -ForegroundColor Green

    # Get latest stable PowerShell release version from GitHub
    $latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
    $latestVersion = $latestRelease.tag_name.TrimStart('v')

    Write-Host "[INFO] Latest PowerShell version available: $latestVersion" -ForegroundColor Green

    if ([version]$latestVersion -gt $currentVersion) {
        Write-Host "[INFO] A newer version of PowerShell is available. Starting update..." -ForegroundColor Yellow

        # Download the latest MSI installer for Windows
        $installerAsset = $latestRelease.assets | Where-Object { $_.name -match "win-x64.msi" }
        $installerUrl = $installerAsset.browser_download_url
        $installerPath = "$env:TEMP\PowerShell-$latestVersion-win-x64.msi"

        Write-Host "[INFO] Downloading PowerShell $latestVersion installer..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

        Write-Host "[INFO] Installing PowerShell $latestVersion..." -ForegroundColor Cyan
        Start-Process msiexec.exe -Wait -ArgumentList "/i `"$installerPath`" /qn"

        Write-Host "[SUCCESS] PowerShell updated to version $latestVersion successfully." -ForegroundColor Green
    } else {
        Write-Host "[INFO] You already have the latest PowerShell version installed." -ForegroundColor Green
    }

    Write-Host "[INFO] Updating installed PowerShell modules..." -ForegroundColor Cyan

    # Get list of all installed modules
    $modules = Get-InstalledModule

    foreach ($module in $modules) {
        Write-Host "[INFO] Updating module: $($module.Name)" -ForegroundColor Cyan
        try {
            Update-Module -Name $module.Name -Force -ErrorAction Stop
            Write-Host "[UPDATED] Module '$($module.Name)' updated successfully." -ForegroundColor Green
        } catch {
            Write-Warning "[WARNING] Failed to update module '$($module.Name)': $_"
        }

    <# SALIR DEL SCRIPT #>
        "$exit" {
            Write-Host "Saliendo..."
            $continue = $false
    }

    Write-Host "[SUCCESS] All modules updated successfully." -ForegroundColor Green
}

# Call the function to update PowerShell and modules
Update-PowerShellModules

# --- Función para exportar políticas
function Export-LocalPolicies {
    Write-Host "Exportando políticas locales..." -ForegroundColor Cyan
    $exportPath = "$exportDir\Export-$(Get-Date -Format yyyyMMdd-HHmmss)"
    New-Item -Path $exportPath -ItemType Directory | Out-Null
    & $lgpoExe /b $exportPath | Out-Null
    Write-Host "Políticas exportadas a: $exportPath" -ForegroundColor Green
}

# --- Función para dividir PolicyRules
function Split-PolicyRules {
    Write-Host "Selecciona el archivo .PolicyRules para dividir:" -ForegroundColor Cyan
    $files = Get-ChildItem "$policyRules\*.PolicyRules"
    if (!$files) {
        Write-Warning "No hay archivos .PolicyRules disponibles para dividir."
        return
    }
    for ($i=0; $i -lt $files.Count; $i++) {
        Write-Host "$($i): $($files[$i].Name)"
    }
    $selected = Read-Host "Selecciona archivo por número"
    if ([int]::TryParse($selected, [ref]$null) -and $selected -ge 0 -and $selected -lt $files.Count) {
        & $splitScript $files[$selected].FullName "$policyRules\Split-$($files[$selected].BaseName)" | Out-Null
        Write-Host "División completada exitosamente." -ForegroundColor Green
    } else {
        Write-Warning "Selección no válida."
    }
}

# --- Función de backup
function Backup-LocalPolicies {
    Write-Host "Realizando backup de políticas locales..." -ForegroundColor Cyan
    $backupPath = "$backupDir\Backup-$(Get-Date -Format yyyyMMdd-HHmmss)"
    New-Item -Path $backupPath -ItemType Directory | Out-Null
    & $lgpoExe /b $backupPath | Out-Null
    Write-Host "Backup completado en: $backupPath" -ForegroundColor Green
}

# --- Función de restauración
function Restore-LocalPolicies {
    Write-Host "Selecciona backup para restaurar:" -ForegroundColor Cyan
    $backups = Get-ChildItem -Directory $backupDir
    if (!$backups) {
        Write-Warning "No existen backups disponibles."
        return
    }
    for ($i=0; $i -lt $backups.Count; $i++) {
        Write-Host "$($i): $($backups[$i].Name)"
    }
    $selected = Read-Host "Selecciona backup por número"
    if ([int]::TryParse($selected, [ref]$null) -and $selected -ge 0 -and $selected -lt $backups.Count) {
        & $lgpoExe /g $backups[$selected].FullName | Out-Null
        Write-Host "Restauración completada exitosamente." -ForegroundColor Green
    } else {
        Write-Warning "Selección no válida."
    }
}

# --- Función de limpieza
function Remove-OldBackups {
    Write-Host "Limpiando backups y exportaciones antiguos..." -ForegroundColor Cyan
    Get-ChildItem -Path $backupDir,$exportDir -Directory | Remove-Item -Recurse -Force -Verbose
    Write-Host "Limpieza finalizada." -ForegroundColor Green
}

# --- Menú interactivo
function Show-Menu {
    do {
        Clear-Host
        Write-Host "================== Gestor de Políticas Locales ==================" -ForegroundColor Cyan
        Write-Host "1. Exportar políticas locales"
        Write-Host "2. Dividir archivos .PolicyRules"
        Write-Host "3. Realizar backup de políticas locales"
        Write-Host "4. Restaurar desde backup"
        Write-Host "5. Eliminar backups y exportaciones antiguas"
        Write-Host "0. Salir"
        $option = Read-Host "Selecciona una opción"

        switch ($option) {
            "1" { Export-LocalPolicies }
            "2" { Split-PolicyRules }
            "3" { Backup-LocalPolicies }
            "4" { Restore-LocalPolicies }
            "5" { Remove-OldBackups }
            "0" { Write-Host "Saliendo del script..." -ForegroundColor Yellow }
            default { Write-Warning "Opción no válida. Intenta de nuevo." }
        }
        if ($option -ne "0") {
            Write-Host "Presiona cualquier tecla para continuar..."
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        }
    } while ($option -ne "0")
}
}
# --- Ejecución inicial
# Esta función que te he puesto aquí, funciona muy bien y es para actualizar el sistema, 
# la dejo comentada, pero si quieres cuando la quieras usar la descomentas
# Update-PowerShellModules
Show-Menu
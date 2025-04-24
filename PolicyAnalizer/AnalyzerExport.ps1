<#
    PolicyRules es una carpeta donde contiene todas las reglas tanto creadas como importadas
    Se puede modificar el path para cambiar la ubicacion, pero PolicyAnalizer no puede detectar
    dos ubicaciones a la vez, por lo que no detectará todos los .PolicyRules de distintas carpetas.
    Y es preferible tenerlo en una carpeta en común.

    LGPO.exe es el ejecutable que debe estar en la misma carpeta que el script, y es el encargado de
    importar y exportar las politicas locales.
#>
<#
.SYNOPSIS
    Script para gestion completa de politicas locales mediante LGPO.

.DESCRIPTION
    Este script permite gestionar politicas locales en un entorno Windows, ofreciendo:
    - Exportacion de politicas locales mediante LGPO.
    - Division (Split) de archivos .PolicyRules.
    - Verificacion y actualizacion automática de PowerShell y sus modulos.
    - Funciones adicionales limpieza.
    - Backup y restauracion podrian ser interesantes, pero no están implementadas

.PARAMETER Ninguno
    El script no requiere parámetros externos.

.EXAMPLE
    PS C:\> .\GestionPoliticas.ps1

    Ejecuta el script mostrando un menú interactivo para gestionar politicas locales.

.NOTES
    Autor: Zokkotyron & V1lTh
    Version: 2.0
    Idioma: Español
#>
[CmdletBinding()]
param()

$currentPath   = Get-Location
$lgpoExe       = "$currentPath\PA40\LGPO.exe"
$policyRules   = "$currentPath\PolicyRules"
$exportDir     = "$currentPath\Exports"
$splitScript   = "$currentPath\PA40\Split-PolicyRules.ps1"

# Update-PowerShellModules

function Update-PowerShellModules {
    try {
        <#
        .DESCRIPTION
            Esta funcion verifica la version de PowerShell y actualiza los modulos instalados.
            Si hay una version mas reciente de PowerShell, la descarga e instala.
        #>
        Write-Host "[INFO] Checking for PowerShell updates..." -ForegroundColor Cyan
        $currentVersion = $PSVersionTable.PSVersion # Obtiene la version actual de PowerShell
        Write-Host "[INFO] Current PowerShell version: $($currentVersion)" -ForegroundColor Green

        $latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
        $latestVersion = $latestRelease.tag_name.TrimStart('v')
        # Obtiene la ultima version de PowerShell desde GitHub

        Write-Host "[INFO] Latest PowerShell version available: $latestVersion" -ForegroundColor Green

        if ([version]$latestVersion -gt $currentVersion) {
            Write-Host "[INFO] A newer version of PowerShell is available. Starting update..." -ForegroundColor Yellow

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
        $modules = Get-InstalledModule
        foreach ($module in $modules) {
            Write-Host "[INFO] Updating module: $($module.Name)" -ForegroundColor Cyan
            try {
                Update-Module -Name $module.Name -Force -ErrorAction Stop
                Write-Host "[UPDATED] Module '$($module.Name)' updated successfully." -ForegroundColor Green
            } catch {
                Write-Warning "[WARNING] Failed to update module '$($module.Name)': $_"
            }
        }
    }
    catch {
        Write-Warning "[ERROR] An error occurred while checking for updates: $_"
    }
    finally {
        Write-Host "[INFO] Update process completed." -ForegroundColor Green
    }
}
catch {
    Write-Host $_ -ForegroundColor Red
}


# --- Funcion para exportar politicas
function Export-LocalPolicies {
    <#
    .DESCRIPTION
        Esta funcion exporta las politicas locales a un directorio especificado.
        Se crea un nuevo directorio con la fecha y hora actual para almacenar las exportaciones.
        Si el directorio de exportacion no existe, se crea.
        Si el directorio de exportacion ya existe, se sobrescriben los archivos existentes.
    #>

    try {
        Write-Host "Exportando politicas locales..." -ForegroundColor Cyan
        $exportPath = "$exportDir\$(Get-Date -Format yyyyMMdd-HHmmss)"
        New-Item -Path $exportPath -ItemType Directory | Out-Null
        & $lgpoExe /b $exportPath | Out-Null
    }
    catch {
        Write-Host $_ -ForegroundColor Red
    }
    finally {
        Write-Host
        Write-Host "Exportacion finalizada." -ForegroundColor Green
    }
}

# --- Funcion para dividir PolicyRules
function Split-PolicyRules {
    <#
    .DESCRIPTION
        Esta funcion estrae el archivo .PolicyRules a varios archivos mas pequeños.
        Se utiliza el script Split-PolicyRules.ps1 para realizar la division.
        Se selecciona el archivo a dividir y se crea un nuevo archivo con el prefijo "Split-".
    #>
    try {
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
        } else {
            Write-Warning "Seleccion no válida."
        }
    }
    catch {
        Write-Host $_ -ForegroundColor Red
    }
    finally {
        Write-Host "Division finalizada." -ForegroundColor Green
    }
}

# --- Funcion de limpieza
function Remove-OldBackups {
    <#
    .DESCRIPTION
        Esta funcion elimina los backups y exportaciones antiguos.
        Se eliminan todos los directorios dentro de $backupDir y $exportDir.
        Si no hay directorios disponibles, se muestra un mensaje de advertencia.
        Se utiliza el parametro -Recurse para eliminar todos los archivos y subdirectorios.
    #>
    try {
        Write-Host "Limpiando backups y exportaciones antiguos..." -ForegroundColor Cyan
        Get-ChildItem -Path $backupDir,$exportDir -Directory | Remove-Item -Recurse -Force -Verbose
    }
    catch {
        Write-Host $_ -ForegroundColor Red
    }
    finally {
        Write-Host "Limpieza completada." -ForegroundColor Green
    }
}

# --- Menú interactivo
function Show-Menu {
    do {
        Clear-Host
        Write-Host "===============================================================" -ForegroundColor Gray
        Write-Host "Directorio actual:  $currentPath" -ForegroundColor Gray
        Write-Host "LGPO.exe:           $lgpoExe" -ForegroundColor Gray
        Write-Host "Lista de Politicas: $policyRules" -ForegroundColor Gray
        Write-Host "Exports Files:      $exportDir" -ForegroundColor Gray
        Write-Host "===============================================================" -ForegroundColor Gray
    $export = "1"
    $Split = "2"
    $rm = "3"
    $exit = "0"
        Write-Host "================== Gestor de Politicas Locales ==================" -ForegroundColor Cyan
        Write-Host "$export. Exportar politicas locales"
        Write-Host "$Split. Dividir archivos .PolicyRules"
        Write-Host "$rm. Eliminar backups y exportaciones antiguas"
        Write-Host "$exit. Salir"
        $option = Read-Host "Selecciona una opcion"

        switch ($option) {
            "$export" { Export-LocalPolicies }
            "$Split" { Split-PolicyRules }
            "$rm" { Remove-OldBackups }
            "$exit" { Write-Host "Saliendo del script..." -ForegroundColor Yellow }
            default { Write-Warning "Opcion no válida. Intenta de nuevo." }
        }
        if ($option -ne "0") {
            Write-Host "Salir..."
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        }
    } while ($option -ne "0")
}

Show-Menu

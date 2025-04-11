<<<<<<< HEAD
<#
    PolicyRules es una carpeta donde contiene todas las reglas tanto creadas como importadas
    Se puede modificar el path para cambiar la ubicacion, pero PolicyAnalizer no puede detectar
=======
<# PolicyRules es una carpeta donde contiene todas las reglas tanto creadas como importadas
    Se puede modificar el path para cambiar la ubicación, pero PolicyAnalizer no puede detectar
>>>>>>> origin/main
    dos ubicaciones a la vez, por lo que no detectará todos los .PolicyRules de distintas carpetas.
    Y es preferible tenerlo en una carpeta en común.

    LGPO.exe es el ejecutable que debe estar en la misma carpeta que el script, y es el encargado de
    importar y exportar las politicas locales.
#>
<#
.SYNOPSIS
<<<<<<< HEAD
    Script para gestion completa de politicas locales mediante LGPO.

.DESCRIPTION
    Este script permite gestionar politicas locales en un entorno Windows, ofreciendo:
    - Exportacion de politicas locales mediante LGPO.
    - Division (Split) de archivos .PolicyRules.
    - Verificacion y actualizacion automática de PowerShell y sus modulos.
    - Funciones adicionales limpieza.
    - Backup y restauracion podrian ser interesantes, pero no están implementadas
=======
    Script para gestión completa de políticas locales mediante LGPO.

.DESCRIPTION
    Este script permite gestionar políticas locales en un entorno Windows, ofreciendo:
    - Exportación de políticas locales mediante LGPO.
    - División (Split) de archivos .PolicyRules.
    - Verificación y actualización automática de PowerShell y sus módulos.
    - Funciones adicionales limpieza.
    - Backup y restauración podrían ser interesantes, pero no están implementadas
>>>>>>> origin/main

.PARAMETER Ninguno
    El script no requiere parámetros externos.

.EXAMPLE
    PS C:\> .\GestionPoliticas.ps1

<<<<<<< HEAD
    Ejecuta el script mostrando un menú interactivo para gestionar politicas locales.

.NOTES
    Autor: Zokkotyron & V1lTh
    Version: 2.0
=======
    Ejecuta el script mostrando un menú interactivo para gestionar políticas locales.

.NOTES
    Autor: Zokkotyron
    Versión: 2.0
>>>>>>> origin/main
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
<<<<<<< HEAD
function Update-PowerShellModules {
    try {
        <#
        .DESCRIPTION
            Esta funcion verifica la version de PowerShell y actualiza los modulos instalados.
            Si hay una version mas reciente de PowerShell, la descarga e instala.
        #>

        Write-Host "[INFO] Checking for PowerShell updates..." -ForegroundColor Cyan
        $currentVersion = $PSVersionTable.PSVersion
        Write-Host "[INFO] Current PowerShell version: $($currentVersion)" -ForegroundColor Green

        $latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
        $latestVersion = $latestRelease.tag_name.TrimStart('v')

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
=======
$backupDir     = "$currentPath\Backups"

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
>>>>>>> origin/main
    }
    catch {
        Write-Warning "[ERROR] An error occurred while checking for updates: $_"
    }
    finally {
        Write-Host "[INFO] Update process completed." -ForegroundColor Green
    }
}
<<<<<<< HEAD
catch {
    Write-Host $_ -ForegroundColor Red
}
# Update-PowerShellModules

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
        Esta funcion divide un archivo .PolicyRules en varios archivos mas pequeños.
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

# --- Funcion de backup
#      function Backup-LocalPolicies {
#          try {
#              Write-Host "Realizando backup de politicas locales..." -ForegroundColor Cyan
#              $backupPath = "$backupDir\Backup-$(Get-Date -Format yyyyMMdd-HHmmss)"
#              New-Item -Path $backupPath -ItemType Directory | Out-Null
#              & $lgpoExe /b $backupPath | Out-Null
#              Write-Host "Backup completado en: $backupPath" -ForegroundColor Green
#              }
#          catch {
#              Write-Host $_ -ForegroundColor Red
#          }
#          finally {
#              Write-Host "Backup finalizado." -ForegroundColor Green
#          }
#      }

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
=======

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
>>>>>>> origin/main
}

# --- Menú interactivo
function Show-Menu {
    do {
        Clear-Host
<<<<<<< HEAD
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
            "2" { Split-PolicyRules }
            "5" { Remove-OldBackups }
            "0" { Write-Host "Saliendo del script..." -ForegroundColor Yellow }
            default { Write-Warning "Opcion no válida. Intenta de nuevo." }
=======
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
>>>>>>> origin/main
        }
        if ($option -ne "0") {
            Write-Host "Presiona cualquier tecla para continuar..."
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        }
    } while ($option -ne "0")
}

<<<<<<< HEAD
Show-Menu
=======
# --- Ejecución inicial
# Esta función que te he puesto aquí, funciona muy bien y es para actualizar el sistema, 
# la dejo comentada, pero si quieres cuando la quieras usar la descomentas
# Update-PowerShellModules
Show-Menu
>>>>>>> origin/main

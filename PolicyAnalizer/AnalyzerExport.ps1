<# PolicyRules es una carpeta donde contiene todas las reglas tanto creadas como importadas
    Se puede modificar el path para cambiar la ubicación, pero PolicyAnalizer no puede detectar
    dos ubicaciones a la vez, por lo que no detectará todos los .PolicyRules de distintas carpetas.
    Y es preferible tenerlo en una carpeta en común.

    LGPO.exe es el ejecutable que debe estar en la misma carpeta que el script, y es el encargado de
    importar y exportar las políticas locales.
#>
# ======================================================================
# Script para gestionar y exportar políticas locales utilizando LGPO.exe
# Mejorado con menú interactivo, validaciones y manejo de errores.
# Todo comentado en detalle y claro en Español.
# ======================================================================

# Limpiar pantalla
Clear-Host

# Definición de rutas globales
$currentPath       = Get-Location
$policyRulesPath   = "$currentPath\PolicyRules"
$lgpoExecutable    = "$currentPath\PA40\LGPO.exe"
$exportFolder      = "$currentPath\Exports"
$splitScript       = "$currentPath\PA40\Split-PolicyRules.ps1"
$logFile           = "$currentPath\script.log"

# Función para registrar logs
Function Write-Log($message, $type="INFO") {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp [$type]: $message" | Out-File -FilePath $logFile -Append
}

# Función para verificar módulos y versiones
Function Verify-Prerequisites {
    Write-Host "Verificando prerrequisitos..." -ForegroundColor Cyan
    if (-Not (Test-Path $lgpoExecutable)) {
        Write-Host "[ERROR] LGPO.exe no encontrado en $lgpoExecutable." -ForegroundColor Red
        Write-Log "LGPO.exe no encontrado." "ERROR"
        Exit 1
    }

    if (-Not (Test-Path $exportFolder)) {
        Write-Host "Creando carpeta de exportación en $exportFolder..." -ForegroundColor Yellow
        New-Item -Path $exportFolder -ItemType Directory | Out-Null
        Write-Log "Carpeta de exportación creada."
    }
}

# Función para exportar directivas locales
Function Export-LocalPolicies {
    try {
        Write-Host "Exportando las directivas locales..." -ForegroundColor Cyan
        & $lgpoExecutable /b $exportFolder | Out-Null
        Write-Host "Directivas locales exportadas correctamente en $exportFolder." -ForegroundColor Green
        Write-Log "Directivas locales exportadas exitosamente."
    }
    catch {
        Write-Host "Error al exportar directivas locales: $_.Exception.Message" -ForegroundColor Red
        Write-Log "Error exportando directivas locales: $_" "ERROR"
    }
}

# Función para dividir archivos .PolicyRules
Function Split-PolicyRules {
    if (-Not (Test-Path $splitScript)) {
        Write-Host "El script para dividir PolicyRules no está disponible en $splitScript." -ForegroundColor Red
        Write-Log "Split-PolicyRules.ps1 no encontrado." "ERROR"
        return
    }

    $policyFiles = Get-ChildItem "$policyRulesPath\*.PolicyRules"

    if ($policyFiles.Count -eq 0) {
        Write-Host "No se encontraron archivos .PolicyRules para dividir." -ForegroundColor Yellow
        Write-Log "No hay archivos .PolicyRules disponibles."
        return
    }

    foreach ($file in $policyFiles) {
        try {
            $destinationFolder = "$policyRulesPath\$($file.BaseName)"
            if (-Not (Test-Path $destinationFolder)) {
                New-Item -Path $destinationFolder -ItemType Directory | Out-Null
            }

            Write-Host "Dividiendo archivo $($file.Name)..." -ForegroundColor Cyan
            & $splitScript $file.FullName $destinationFolder | Out-Null
            Write-Host "Archivo dividido en: $destinationFolder" -ForegroundColor Green
            Write-Log "Archivo $($file.Name) dividido exitosamente."
        }
        catch {
            Write-Host "Error al dividir $($file.Name): $_.Exception.Message" -ForegroundColor Red
            Write-Log "Error dividiendo $($file.Name): $_" "ERROR"
        }
    }
}

# Menú interactivo principal
Function Show-MainMenu {
    do {
        Write-Host "`n=============================================================" -ForegroundColor Yellow
        Write-Host "               Menú Gestión de Políticas Locales            " -ForegroundColor Yellow
        Write-Host "=============================================================" -ForegroundColor Yellow

        Write-Host "1. Exportar las políticas locales"
        Write-Host "2. Dividir archivos .PolicyRules"
        Write-Host "3. Mostrar archivo de log"
        Write-Host "4. Verificar prerrequisitos nuevamente"
        Write-Host "0. Salir del script"

        $userInput = Read-Host "Seleccione una opción"

        switch ($userInput) {
            "1" { Export-LocalPolicies }
            "2" { Split-PolicyRules }
            "3" {
                if (Test-Path $logFile) {
                    Write-Host "Mostrando archivo de log:" -ForegroundColor Cyan
                    Get-Content $logFile | more
                } else {
                    Write-Host "No existe aún ningún archivo de log." -ForegroundColor Yellow
                }
            }
            "4" { Verify-Prerequisites }
            "0" { Write-Host "Saliendo del script..." -ForegroundColor Yellow }
            default { Write-Host "Opción no válida. Inténtelo de nuevo." -ForegroundColor Red }
        }

    } while ($userInput -ne "0")
}

# Ejecución principal
Write-Log "Inicio del script."
Verify-Prerequisites
Show-MainMenu
Write-Log "Finalización del script."

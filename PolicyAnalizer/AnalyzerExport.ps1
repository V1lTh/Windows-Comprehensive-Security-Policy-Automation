clear-host
$currentPath = Get-Location
$PR =           "$currentPath\PolicyRules"
$lgpo =         "$currentPath\PA40\LGPO.exe"
$folderexport = "$currentPath\Exports"
$split =        "$currentPath\PA40\Split-PolicyRules.ps1"

<# PolicyRules es una carpeta donde contiene todas las reglas tanto creadas como importadas
    Se puede modificar el path para cambiar la ubicación, pero PolicyAnalizer no puede detectar
    dos ubicaciones a la vez, por lo que no detectará todos los .PolicyRules de distintas carpetas.
    Y es preferible tenerlo en una carpeta en común.

    LGPO.exe es el ejecutable que debe estar en la misma carpeta que el script, y es el encargado de
    importar y exportar las políticas locales.
#>
$continue = $true

while ($continue) {
    Write-Host "-----------------------------------------------------------"
    Write-Host "Directorio raiz:            $currentPath"
    Write-Host "Ejecutable de LGPO:         $lgpo"
    Write-Host "Directorio de reglas:       $PR"
    Write-Host "Directorio de exportacion:  $folderexport"
    Write-Host "-----------------------------------------------------------"
        $export = "1"
        $split  = "2"
        $exit   = "0"
    Write-Host "${export}: Exportar las politicas locales"
    Write-Host "${split}: "
    Write-Host "${exit}: Salir"

    $userInput = Read-Host "Selecciona una opcion: "

    switch ($userInput) {
    <# EXPORTAR DIRECTIVAS LOCALES A UNA CARPETA #>
        "$export" {
            try {
                Write-Host "Exportando las directivas locales..."
                    & $lgpo /b $folderexport | Out-Null
                    <#
                    /b : Es la opción para importar un archivo .PolicyRules
                    \file : Ruta donde se guardará la carpeta con las políticas exportadas.
                    #>
                Write-Host ""
                Write-Host ""
            }
            catch {
                Write-Host "Error: $_.Exception.Message"
            }
        }
    <# SPLIT POLICYRULES #>
            <# ---------------- REVISAR, NO FUNCIONA -------------  #>
            <# "$split" {
                clear-host
                Write-Host ""
                try {
                    $listdir = Get-ChildItem -Path $folderexport -Directory
                    if ($listdir.Count -ge 1) {
                        for ($i = 0; $i -lt $listdir.Count; $i++) {
                            Write-Host "$i. $($listdir[$i].Name)"
                        }
                    } else {
                        Write-Host "No se encontraron carpetas en el directorio de exportacion."
                        break
                    }
                    Write-Host ""
                    $userInput = Read-Host "Selecciona una carpeta por numero: "
                    if ($userInput -ge 0 -and $userInput -lt $listdir.Count) {
                        $folder = $listdir[$userInput]
                        Write-Host "Carpeta seleccionada: $folder"
                        Write-Host ""
                            # $split .\Contoso-combined.PolicyRules .\Contoso
                            # Aquí puedes añadir el código para procesar las reglas o dividirlas
                            # Ejemplo: & $split .\$folder.PolicyRules $folderexport
                    } else {
                        Write-Host "Selección no valida."
                    }
                    # & $split .\Contoso-combined.PolicyRules .\Contoso
                }
                catch {
                    Write-Host "Error: $_.Exception.Message"
                }
            } #>







    <# SALIR DEL SCRIPT #>
        "$exit" {
            Write-Host "Saliendo..."
            $continue = $false
        }
    <# Opcion no valida - vuelve a elegir#>
        default {
            Write-Host "Opcion no valida. Intente nuevamente."
            start-sleep -Seconds 0
            clear-host
        }
    }
}
clear-host

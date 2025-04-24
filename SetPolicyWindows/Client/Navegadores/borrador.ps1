try {
    # Rutas de registro donde se almacenan las políticas de Chrome
    $registryPaths = @(
        "HKLM:\SOFTWARE\Policies\Google\Chrome",
        "HKCU:\SOFTWARE\Policies\Google\Chrome"
    )

    foreach ($path in $registryPaths) {
        if (Test-Path $path) {
            Remove-Item -Path $path -Recurse -Force
            Write-Host "Políticas eliminadas en: $path" -ForegroundColor Green
        } else {
            Write-Host "Ruta no encontrada: $path" -ForegroundColor Yellow
        }
    }
    Write-Output "Todas las políticas de Chrome han sido eliminadas."



















    foreach ($group in $registry) {
        $path = $group.Path
        if (-Not (Test-Path $path)) {
            New-Item -Path $path -Force
        }
        foreach ($policy in $group.Policies) {
            $name = $policy.Name
            $value = $policy.Value
            $type = $policy.Type

            if ($type -eq "DWORD") {
                Set-ItemProperty -Path $path -Name $name -Value ([Convert]::ToInt32($value)) -Force
            } elseif ($type -eq "String") {
                Set-ItemProperty -Path $path -Name $name -Value $value -Force
            } elseif ($type -eq "MULTISTRING") {
                Set-ItemProperty -Path $path -Name $name -Value $value -Force
            } else {
                Write-Host "Tipo de valor no soportado: $type" -ForegroundColor Yellow
            }
        }
        Write-Host "Políticas aplicadas en: $path" -ForegroundColor Green
    }
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}











<# agreagr
 
$registryPath = "HKLM:\Software\Policies\Google\Chrome"
if (-Not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force
}
#Permitir  borrar el historial
Set-ItemProperty -Path $registryPath -Name "AllowDeletingBrowserHistory" -Value "1" -Type DWord
 
$Browsingdataon= @(
    "browsing_history",
    "download_history",
    "cookies_and_other_site_data",
    "cached_images_and_files",
    "password_signin",
    "autofill",
    "site_settings",
    "hosted_app_data"
)
 
$i=1
 
# Define las cadenas como una matriz.
$registryPath = "HKLM:\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList"
if (-Not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force
}
#Borrar datos de navegación al salir Los tipos de datos disponibles son los siguientes: historial de navegación (browsing_history), historial de descargas (download_history), cookies (cookies_and_other_site_data), caché (cached_images_and_files), Autocompletar (autofill), contraseñas (password_signin), configuración de sitios (site_settings) y datos de aplicaciones alojadas (hosted_app_data). Esta política no prevalece sobre AllowDeletingBrowserHistory.
foreach($dato in $Browsingdataon) {
    Set-ItemProperty -Path $registryPath -Name $i -Value $dato -Type String
$i++ } #>
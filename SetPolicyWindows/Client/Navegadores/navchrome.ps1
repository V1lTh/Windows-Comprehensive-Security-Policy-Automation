<# Chrome:\\policy #>
try {
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
    $registry = @(
        @{
            Path = "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallAllowlist"
            Policies = @(
                # Crea una lista blanca que bloquea toda la instalación de Extensiones y solo permite el que se indique
                @{ Name = "1"; Value = "didegimhafipceonhjepacocaffmoppf"; Type = "String" }
                # @{ Name = "X"; Value = ""; Type = "String" }
            )
        },
        @{
            Path = "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallBlocklist"
            Policies = @(
                @{ Name = "1"; Value = "*"; Type = "String" }
            )
        },
        <# CONTRASEÑAS #>
        @{
            Path = "HKLM:\SOFTWARE\Policies\Google\Chrome"
            Policies = @(
                @{ Name = "PasswordManagerEnabled"; Value = "0"; Type = "DWord" }, # La capacidad del navegador para recordar contraseñas
                @{ Name = "BlockExternalExtensions"; Value = "1"; Type = "DWord" }, # Bloquea la instalación de extensiones externas
        <# COOKIES #>
                # @{ Name = "EssentialSearchEnabled"; Value = "1"; Type = "DWord" }, # Habilita solo las cookies y los datos esenciales en la búsqueda
                @{ Name = "DefaultCookiesSetting"; Value = "2"; Type = "DWord" }, # Configuración de cookies predeterminada
                @{ Name = "BlockThirdPartyCookies"; Value = "1"; Type = "DWord" }, # Bloquear cookies de terceros
        <# OTRO #>
                @{ Name = "DefaultThirdPartyStoragePartitioningSetting"; Value = "2"; Type = "DWord" } # Ajuste predeterminado de la partición del almacenamiento de terceros
            )
        },
        <# Acciones que se ejecutarán cuando el navegador esté inactivo #>
        @{
            Path = "HKLM:\SOFTWARE\Policies\Google\Chrome"
            Policies = @(
                @{ Name = "IdleTimeout"; Value = "1"; Type = "DWORD" }, # Retraso antes de ejecutar acciones por inactividad
                @{ Name = "IdleTimeoutActions"; Value = "1"; Type = "DWORD" } # Acciones a realizar cuando el navegador esté inactivo
            )
        },
        @{
            Path = "HKLM:\Software\Policies\Google\Chrome\IdleTimeoutActions"
            <# i = "0" #>
            <# Configura una lista de los tipos de datos de navegación que se deben eliminar cuando el usuario cierra todas las ventanas del navegador #>
            Policies = @(
                @{ Name = "1"; Value = "browsing_history"; Type = "String" },    # Historial de navegación
                @{ Name = "2"; Value = "download_history"; Type = "String" },    # Historial de descargas
                @{ Name = "3"; Value = "cookies_and_other_site_data"; Type = "String" },   # Cookies y otros datos del sitio
                @{ Name = "4"; Value = "cached_images_and_files"; Type = "String" },  # Imágenes y archivos en caché
                @{ Name = "5"; Value = "password_signin"; Type = "String" },   # Inicio de sesión con contraseña
                @{ Name = "6"; Value = "autofill"; Type = "String" },           # Autocompletar
                @{ Name = "7"; Value = "site_settings"; Type = "String" },     # Configuración del sitio
                @{ Name = "8"; Value = "hosted_app_data"; Type = "String" }    # Datos de aplicaciones alojadas
            )
        }
        <# @{
            # Permitir notificaciones en estos sitios
            Path = "HKLM:\Software\Policies\Google\Chrome\NotificationsAllowedForUrls"
            Policies = @(
                @{ Name = "1"; Value = ""; Type = "String" },
                @{ Name = "2"; Value = "[*.]example.edu"; Type = "String" }
            )
        } #>
    )


    foreach ($group in $registry) {
        $path = $group.Path
        if (-Not (Test-Path $path)) {
            New-Item -Path $path -Force
        }
        foreach ($policy in $group.Policies) {
            $name = $policy.Name
            $value = $policy.Value
            $type = $policy.Type

            if ($type -eq "DWord") {
                Set-ItemProperty -Path $path -Name $name -Value ([Convert]::ToInt32($value)) -Force
            } elseif ($type -eq "String") {
                Set-ItemProperty -Path $path -Name $name -Value $value -Force}
            elseif ($type -eq "MultiString") {
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

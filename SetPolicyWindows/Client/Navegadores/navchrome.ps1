<# Donde encontrar las politicas: Chrome:\policy
    .DESCRIPTION
        Este script establece políticas de Chrome en Windows mediante la modificación del registro.
        Se eliminan las políticas existentes y se aplican nuevas configuraciones.
    .EXAMPLE
        Si se quiere crear nuevas políticas, utilizar como plantilla el siguiente bloque de código.
                Asegurando que el nuevo codigo este dentro de la variable $registry.
                O si se quiere agregar nuevas políticas pero en un path existente cumplir con la sintaxis.

                Ejemplo:

                    @{
                    Path = "HKLM:\example\example"
                    Policies = @(
                        # Descripción de la política
                            @{ Name = "a"; Value = "example1"; Type = "String" }
                        # Descripción de la política
                            @{ Name = "b"; Value = "example2"; Type = "Multistring" }
                        )
                    },

                        - El path es donde la politicas se guardan en el registro de Windows.
                        - Policies es un array de hash tables donde se definen las políticas.
                            - Name es el nombre de la política.
                            - Value es el valor de la política.
                            - Type es el tipo de valor (DWord, String, MultiString).
#>

# Elimina las políticas existentes
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
            # Si la ruta no existe, la crea
            if (-Not (Test-Path "$path")) {
                New-Item -Path "$path" -Force
            }
        }
    }
    # Crea nuevas políticas
    $registry = @(
        @{
            Path = "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallAllowlist"
            Policies = @(
                # Crea una lista blanca que bloquea toda la instalación de Extensiones y solo permite el que se indique
                @{ Name = "1"; Value = "didegimhafipceonhjepacocaffmoppf"; Type = "String" }
            )
        },
        @{
            Path = "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallBlocklist"
            Policies = @(
                @{ Name = "1"; Value = "*"; Type = "String" }
            )
        },
        # CONTRASEÑAS
        @{
            Path = "HKLM:\SOFTWARE\Policies\Google\Chrome"
            Policies = @(
                @{ Name = "PasswordManagerEnabled"; Value = "0"; Type = "DWord" }, # La capacidad del navegador para recordar contraseñas
                @{ Name = "BlockExternalExtensions"; Value = "1"; Type = "DWord" }, # Bloquea la instalación de extensiones externas
                # COOKIES
                @{ Name = "DefaultCookiesSetting"; Value = "2"; Type = "DWord" }, # Configuración de cookies predeterminada
                @{ Name = "BlockThirdPartyCookies"; Value = "1"; Type = "DWord" }, # Bloquear cookies de terceros
                # OTRO
                @{ Name = "DefaultThirdPartyStoragePartitioningSetting"; Value = "2"; Type = "DWord" }, # Ajuste predeterminado de la partición del almacenamiento de terceros
                @{ Name = "AllowDeletingBrowserHistory"; Value = "1"; Type = "DWord" } # Permitir borrar el historial
            )
        },
        # Acciones que se ejecutarán cuando el navegador esté inactivo
        @{
            Path = "HKLM:\Software\Policies\Google\Chrome\IdleTimeoutActions"
            Policies = @(
                @{ Name = "1"; Value = "browsing_history"; Type = "String" },               # Historial de navegación
                @{ Name = "2"; Value = "download_history"; Type = "String" },               # Historial de descargas
                @{ Name = "3"; Value = "cookies_and_other_site_data"; Type = "String" },    # Cookies y otros datos del sitio
                @{ Name = "4"; Value = "cached_images_and_files"; Type = "String" },        # Imágenes y archivos en caché
                @{ Name = "5"; Value = "password_signin"; Type = "String" },                # Inicio de sesión con contraseña
                @{ Name = "6"; Value = "autofill"; Type = "String" },                       # Autocompletar
                @{ Name = "7"; Value = "site_settings"; Type = "String" },                  # Configuración del sitio
                @{ Name = "8"; Value = "hosted_app_data"; Type = "String" }                 # Datos de aplicaciones alojadas
            )
        }
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
            }
            elseif ($type -eq "String") {
                Set-ItemProperty -Path $path -Name $name -Value $value -Force
            }
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

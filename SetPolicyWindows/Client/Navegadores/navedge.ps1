<# Donde encontrar las politicas: edge://policy/ & https://www.microsoft.com/en-us/download/details.aspx?id=55319
    .DESCRIPTION
        Este script establece políticas de Edge en Windows mediante la modificación del registro.
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
        "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
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
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
        Policies = @(
            # Activa el cifrado ligado a la aplicación, mejora la seguridad de los datos.
                @{ Name = "ApplicationBoundEncryptionEnabled"; Value = "1"; Type = "DWord" }
            # Define los esquemas de autenticación permitidos (NTLM y Negotiate).
                @{ Name = "AuthSchemes"; Value = "ntlm,negotiate"; Type = "String" }
            # Desactiva la autenticación básica sobre HTTP (sin cifrar), mejora la seguridad.
                @{ Name = "BasicAuthOverHttpEnabled"; Value = "0"; Type = "DWord" }
            # Bloquea puntos de extensión heredados del navegador para evitar vulnerabilidades.
                @{ Name = "BrowserLegacyExtensionPointsBlockingEnabled"; Value = "1"; Type = "DWord" }
            # Controla la ejecución de código dinámico, puede ayudar a mitigar ataques.
                @{ Name = "DynamicCodeSettings"; Value = "1"; Type = "DWord" }
            # Impide solicitudes desde sitios públicos a redes privadas inseguras.
                @{ Name = "InsecurePrivateNetworkRequestsAllowed"; Value = "0"; Type = "DWord" }
            # Evita que las páginas se recarguen en modo IE.
                @{ Name = "InternetExplorerIntegrationReloadInIEModeAllowed"; Value = "0"; Type = "DWord" }
            # Bloquea archivos .mht con identificador de zona para evitar ejecución de contenido peligroso.
                @{ Name = "InternetExplorerIntegrationZoneIdentifierMhtFileAllowed"; Value = "0"; Type = "DWord" }
            # Oculta el botón del modo Internet Explorer en la barra de herramientas.
                @{ Name = "InternetExplorerModeToolbarButtonEnabled"; Value = "0"; Type = "DWord" }
            # Desactiva el soporte para hosts de mensajería nativos a nivel de usuario.
                @{ Name = "NativeMessagingUserLevelHosts"; Value = "0"; Type = "DWord" }
            # Bloquea el acceso irrestricto a SharedArrayBuffer por seguridad.
                @{ Name = "SharedArrayBufferUnrestrictedAccessAllowed"; Value = "0"; Type = "DWord" }
            # Activa el aislamiento de sitios, cada sitio se ejecuta en su propio proceso.
                @{ Name = "SitePerProcess"; Value = "1"; Type = "DWord" }
            # Activa Microsoft Defender SmartScreen para proteger contra sitios maliciosos.
        #        @{ Name = "SmartScreenEnabled"; Value = "1"; Type = "DWord" }
            # Habilita la protección contra aplicaciones potencialmente no deseadas (PUA).
        #        @{ Name = "SmartScreenPuaEnabled"; Value = "1"; Type = "DWord" }
            # Impide que los usuarios omitan las advertencias de SmartScreen.
        #        @{ Name = "PreventSmartScreenPromptOverride"; Value = "1"; Type = "DWord" }
            # Lo mismo que el anterior, pero para archivos descargados.
        #        @{ Name = "PreventSmartScreenPromptOverrideForFiles"; Value = "1"; Type = "DWord" }
            # Impide que los usuarios ignoren errores de certificados SSL.
                @{ Name = "SSLErrorOverrideAllowed"; Value = "0"; Type = "DWord" }
            # Activa la detección de typosquatting (errores de escritura en URLs que pueden llevar a sitios maliciosos).
                @{ Name = "TyposquattingCheckerEnabled"; Value = "1"; Type = "DWord" }
        )
    }
)

    # Aplicar las nuevas políticas
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

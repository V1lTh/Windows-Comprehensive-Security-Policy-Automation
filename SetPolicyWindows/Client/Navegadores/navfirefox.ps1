<# Donde encontrar las politicas: about:policies 
                                https://mozilla.github.io/policy-templates/
    .DESCRIPTION
        Este script establece políticas de Firefox en Windows mediante la modificación del registro.
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
        "HKLM:\SOFTWARE\Policies\Mozilla\Firefox"
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
        Path = "HKLM:SOFTWARE\Policies\Mozilla\Firefox"
        Policies = @(
            # Desactiva el gestor de contraseñas.
                @{ Name = "PasswordManagerEnabled"; Value = "0"; Type = "DWord" }
        )
    },
    @{
        Path = "HKLM:Software\Policies\Mozilla\Firefox\Cookies"
        Policies = @(
                # @{ Name = "Behavior"; Value = "reject-foreign"; Type = "string" }
                @{ Name = "Behavior"; Value = "reject-tracker-and-partition-foreign"; Type = "string" },
                @{ Name = "AllowSession"; Value = "[]"; Type = "multistring" }
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
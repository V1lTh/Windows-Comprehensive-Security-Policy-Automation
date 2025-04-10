try{
    <# Crea una lista blanca que bloquea toda la instalación de Extensiones y solo permite el que se indique #>
        $registryPath = "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallAllowlist"
            if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        Set-ItemProperty -Path "$registryPath" -Name "1" -Value "didegimhafipceonhjepacocaffmoppf" -Type String -Force
            <# https://chromewebstore.google.com/detail/passbolt-gestor-de-contra/didegimhafipceonhjepacocaffmoppf #>

    <# Configurar lista de bloqueados de instalación de extensiones #>
        $registryPath = "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallBlocklist"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        Set-ItemProperty -Path "$registryPath" -Name "1" -Value "*" -Type String -Force

    # Desactiva la capacidad del navegador para recordar contraseñas
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        Set-ItemProperty -Path $registryPath -Name "PasswordManagerEnabled" -Value "0" -Type DWord -Force
    # Bloquea la instalación de extensiones externas
        Set-ItemProperty -Path $registryPath -Name "BlockExternalExtensions" -Value "1" -Type DWord -Force
}
    catch {
    }

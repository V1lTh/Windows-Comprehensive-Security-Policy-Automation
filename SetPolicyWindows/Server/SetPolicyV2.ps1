try{
    $registryPath = "HKLM:\Software\Policies\Microsoft\EventViewer"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        #Configuración del equipo/Sistema/Administración de comunicaciones de Internet/Configuración de comunicaciones de Internet/Desactivar los vínculos 'Events.asp' del Visor de eventos
        Set-ItemProperty -Path $registryPath -Name "MicrosoftEventVwrDisableLinks" -Value "1" -Type DWord

    $registryPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        #Configuración del equipo/Componentes de Windows/Directivas de Reproducción automática/Comportamiento predeterminado para la ejecución automática
        Set-ItemProperty -Path $registryPath -Name "NoAutorun" -Value "1" -Type DWord
        #Configuración del equipo/Sistema/Administración de comunicaciones de Internet/Configuración de comunicaciones de Internet/Desactivar la tarea de imágenes 'Pedir copias fotográficas'
        Set-ItemProperty -Path $registryPath -Name "NoOnlinePrintsWizard" -Value "1" -Type DWord
        #Configuración del equipo/Componentes de Windows/Directivas de Reproducción automática/Desactivar Reproducción automática
        Set-ItemProperty -Path $registryPath -Name "NoDriveTypeAutoRun" -Value "255" -Type DWord
        Set-ItemProperty -Path $registryPath -Name "NoAutorun" -Value "1" -Type DWord

    $registryPath = "HKLM:\Software\Policies\Microsoft\Windows"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        #Configuración del equipo/Sistema/Administración de comunicaciones de Internet/Configuración de comunicaciones de Internet/Desactivar el informe de errores de Windows
        Set-ItemProperty -Path $registryPath -Name "Windows Error Reporting" -Value "1" -Type DWord

    $registryPath = "HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        #Configuración del equipo/Sistema/Administración de comunicaciones de Internet/Configuración de comunicaciones de Internet/Desactivar el informe de errores de Windows
        #Configuración del equipo/Componentes de Windows/Informe de errores de Windows/Deshabilitar el informe de errores de Window
        Set-ItemProperty -Path $registryPath -Name "DoReport" -Value "0" -Type DWord

        $registryPath = "HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        #Configuración del equipo/Sistema/Administración de comunicaciones de Internet/Configuración de comunicaciones de Internet/Desactivar el contenido '¿Sabía que…?' del Centro de ayuda y soporte técnico
        Set-ItemProperty -Path $registryPath -Name "Headlines" -Value "0" -Type DWord
        #Configuración del equipo/Sistema/Administración de comunicaciones de Internet/Configuración de comunicaciones de Internet/Desactivar la búsqueda en Microsoft Knowledge Base del Centro de ayuda y soporte técnico
        Set-ItemProperty -Path $registryPath -Name "MicrosoftKBSearch" -Value "0" -Type DWord

    $registryPath = "HKLM:\Software\Policies\Microsoft\SearchCompanion"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        #Configuración del equipo/Sistema/Administración de comunicaciones de Internet/Configuración de comunicaciones de Internet/Desactivar la actualización de archivos de contenido del Asistente para búsqueda.
        Set-ItemProperty -Path $registryPath -Name "DisableContentFileUpdates" -Value "1" -Type DWord

    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Digital Locker"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        #Configuración del equipo/Componentes de Windows/Almacén Digital/No permitir que se ejecute el Almacén digital.
        Set-ItemProperty -Path $registryPath -Name "DoNotRunDigitalLocker" -Value "1" -Type DWord

    $registryPath = "HKLM:\Software\Policies\Microsoft\Windows\Explorer"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        #Configuración del equipo/Sistema/Administración de comunicaciones de Internet/Configuración de comunicaciones de Internet/Desactivar el acceso a la tienda
        Set-ItemProperty -Path $registryPath -Name "NoUseStoreOpenWith" -Value "1" -Type DWord

    $registryPath = "HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        #Configuración del equipo/Sistema/Administración de comunicaciones de Internet/Configuración de comunicaciones de Internet/Desactivar informe de errores de reconocimiento de escritura a mano
        Set-ItemProperty -Path $registryPath -Name "PreventHandwritingErrorReports" -Value "1" -Type DWord

    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        #Configuración del equipo/Componentes de Windows/Informe de errores de Windows/No enviar datos adicionales
        Set-ItemProperty -Path $registryPath -Name "DontSendAdditionalData" -Value "1" -Type DWord
        #Configuración del equipo/Componentes de Windows/Informe de errores de Windows/Deshabilitar el informe de errores de Window
        Set-ItemProperty -Path $registryPath -Name "Disabled" -Value "0" -Type DWord
    $registryPath = "HKLM:\Software\Policies\Microsoft\WMDRM"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        #Configuración del equipo/Componentes de Windows/Administración de derechos digitales de Windows Media/Impedir el acceso a Internet de Windows Media DRM
        Set-ItemProperty -Path $registryPath -Name "DisableOnline" -Value "1" -Type DWord

    $registryPath = "HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service\WinRS"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        #Configuración del equipo/Componentes de Windows/Shell remoto de Windows/Permitir acceso a shell remoto
        Set-ItemProperty -Path $registryPath -Name "AllowRemoteShellAccess" -Value "0" -Type DWord

    $registryPath = "HKLM:\Software\Policies\Microsoft\SQMClient\Windows"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        #Configuración del equipo/Sistema/Administración de comunicaciones de Internet/Configuración de comunicaciones de Internet/Desactivar el Programa para la mejora de la experiencia del usuario de Windows
        Set-ItemProperty -Path $registryPath -Name "CEIPEnable" -Value "1" -Type DWord
    $registryPath = "HKLM:\Software\Policies\Microsoft\Messenger\Client"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
    #Configuración del equipo/Sistema/Administración de comunicaciones de Internet/Configuración de comunicaciones de Internet/Desactivar el Programa para la mejora de la experiencia del usuario de Windows Messenger
    Set-ItemProperty -Path $registryPath -Name "CEIP" -Value "2" -Type DWord
    #Configuración de usuario/Panel de control/Personalización/Proteger el protector de pantalla mediante contraseña
    # Crear la clave de registro si no existe
    $registryPath = "HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop"
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        #Configuración de usuario/Panel de control/Personalización/Habilitar protector de pantalla
        Set-ItemProperty -Path $registryPath -Name "ScreenSaveActive" -Value "1" -Type String
        # Establecer la protección del protector de pantalla mediante contraseña
        Set-ItemProperty -Path $registryPath -Name "ScreenSaverIsSecure" -Value "1" -Type String

        #Habilitar el firewall en todos los perfiles:
        Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
        #Actualizar el sistema:
            #Buscar actualizaciones:
            usoclient StartScan
            #Descargar actualizaciones:
            usoclient StartDownload
            #Instalar actualizaciones:
            usoclient StartInstall
            #Reiniciar el equipo para aplicar las actualizaciones:
            usoclient RestartDevice
        #Habilitar la protección en tiempo real de Microsoft Defender:
        Set-MpPreference -DisableRealtimeMonitoring $false
        #Comprobar el estado de la protección en tiempo real:
        Get-MpPreference | Select-Object -Property DisableRealtimeMonitoring
        #Iniciar el servicio de Microsoft Defender si está detenido:
        Start-Service -Name WinDefend

    $registryPath = "HKLM:\Software\Policies\Microsoft\Netlogon\Parameters"
        #/Comprobar si la clave de registro existe, si no, crearla
        if (-not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force }
        #Establecer el valor de la clave:Configuración del equipo/Sistema/Net Logon/Permitir algoritmos de criptografía compatibles con Windows NT 4.0
        Set-ItemProperty -Path $registryPath -Name 'AllowNT4Crypto' -Value 0 -Type DWord

    $registryPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
        #/Comprobar si la clave de registro existe, si no, crearla
        if (-not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force }
        #Establecer el valor de la clave: Configuración del equipo/Componentes de Windows/Opciones de inicio de sesión de Windows/Mostrar información acerca de inicios de sesión anteriores durante inicio de sesión de usuario
        Set-ItemProperty -Path $registryPath -Name 'DisplayLastLogonInfo' -Value 1 -Type DWord
    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Biometrics\Credential Provider"
        if (-not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        # Configurar la política para permitir que los usuarios de dominio inicien sesión mediante biometría
        Set-ItemProperty -Path $registryPath -Name "Domain Accounts" -Value 1
        # Configurar la política para permitir que los usuarios de inicien sesión mediante biometría
        Set-ItemProperty -Path $registryPath -Name "Enabled" -Value 1
        # Configurar la política para permitir biometría
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Biometrics" -Name "Enabled" -Value 1
        Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ReportControllerMissing" -Value 1
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}
finally {
    Write-Host "OK" -ForegroundColor Green
    exit 0
}

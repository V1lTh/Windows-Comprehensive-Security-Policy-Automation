try {
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
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}
finally {
    Write-Host "OK" -ForegroundColor Green
    exit 0
}

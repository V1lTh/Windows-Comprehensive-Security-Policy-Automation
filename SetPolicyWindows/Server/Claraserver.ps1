try {
    #Aplicación: Tamaño máximo del registro
    wevtutil sl Application /ms:33554432
    #Seguridad: Tamaño máximo del registro
    wevtutil sl Security /ms:16777216
    #Sistema: Tamaño máximo del registro
    wevtutil sl System /ms:33554432
    #Aplicación: Evitar que el grupo de invitados locales tenga acceso al registro
    wevtutil sl Application /rt:false
    #Seguridad: Evitar que el grupo de invitados locales tenga acceso al registro
    wevtutil sl Security /rt:false
    #Sistema: Evitar que el grupo de invitados locales tenga acceso al registro
    wevtutil sl System /rt:false

    #Habilitar la protección en tiempo real de Microsoft Defender:
    Set-MpPreference -DisableRealtimeMonitoring $false
    #Comprobar el estado de la protección en tiempo real:
    Get-MpPreference | Select-Object -Property DisableRealtimeMonitoring
    #Iniciar el servicio de Microsoft Defender si está detenido:
    Start-Service -Name WinDefend

        # Bloqueo indefinido 
        $lockoutDuration = 'NO' 
        # Ventana de bloqueo de 15 minutos
        $lockoutWindow = 15   
        # Número de intentos fallidos antes de bloquear la cuenta
        $maxFailedAttempts = 5 
        
    # Establecer la duración del bloqueo de cuenta a 0 (indefinido)
    net accounts /LockoutDuration:$lockoutDuration
    # Establecer la ventana de bloqueo a 15 minutos
    net accounts /LockoutWindow:$lockoutWindow
    # Establecer el número de intentos fallidos antes de bloquear la cuenta
    net accounts /LockoutThreshold:$maxFailedAttempts
    net accounts /minpwage:2 /maxpwage:60 /minpwlen:10 /uniquepw:24 
} 
catch {
    Write-Host "Error: $_"
}
finally {
    Write-Host "OK"
}
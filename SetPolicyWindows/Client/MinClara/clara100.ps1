<# VERSION 2 - SIN COMPROBACIONES PREVIAS Y DE VOLEA #>
    <# referencias en https://www.ccn-cert.cni.es/es/guias.html #>
$currentPath = Get-Location
$getversion = (Get-WmiObject -Class Win32_OperatingSystem).Caption
<# Obtiene la localización actual del script y lo guarda, cambiara de directorio #>
<# EMPIEZA SCRIPT #>
    Write-Host "Version de Windows: " $getversion
    <# =================================================================== #>
    <# =================== CONFIGURACIONES DE SEGURIDAD =================== #>
    <# =================================================================== #>
        <# PASO 1: Importar la plantilla de seguridad de Windows - 47% #>
            function Function_Import-SecurityTemplate {
                try {
                    Write-Host " ================ PASO 1: Importar la plantilla de seguridad de Windows ================"
                    Write-Host "Este script modifica la configuracion de inicio de los servicios requeridos para la seguridad del sistema."
                    $Plantilla = ".\CCN-STIC-599B23 Incremental Servicios (Uso Oficial).inf"
                    secedit /configure /quiet /db ".\servicios_windows.sdb" /cfg $Plantilla
                        <# secedit /configure: Aplica configuraciones de seguridad desde una base de datos.
                                /quiet: Suprime los mensajes de salida.
                                /db ".\x.sdb": Especifica la base de datos de seguridad a utilizar.
                                    SDB, tipo de archivo que almacena la base de datos de compatibilidad de aplicaciones personalizadas en sistemas operativos Windows.
                                    Contienen información de parches de registro que permiten que el registro de Windows sea compatible con versiones más recientes de aplicaciones instaladas.
                                /cfg $x: Indica el archivo de configuración que se debe aplicar.
                                /overwrite: Sobrescribe las configuraciones existentes.
                                /log ".\": Especifica el archivo de registro donde se guardarán los resultados de la operación.
                            #>
                    Write-Host "Listo"
                }
                catch {
                    Write-Host "Error al configurar la seguridad: " + $_.Exception.Message
                }
            }

        <# PASO 2: Copia todos los archivos de seguridad de Windows - 49,62% #>
            function Function_Import-SecurityFiles {
                try {
                    write-host "================ PASO 2: Aplicar los valores de las plantillas administrativas ================"
                    write-host "Este script aplica los valores de las plantillas administrativas a la configuracion de equipo."
                    Set-Location $currentPath
                        <# Es necesario que la carpeta 'GroupPolicy' exista y este en el mismo nivel que el script #>
                    Start-Process -FilePath "xcopy" -ArgumentList "/E /H /R /I /Y `".\GroupPolicy\*.*`" `"C:\Windows\system32\GroupPolicy`"" -NoNewWindow -Wait
                            <#  /E: Copia todos los subdirectorios, incluidos los vacíos.
                                /H: Copia archivos ocultos y de sistema.
                                /R: Sobrescribe archivos de solo lectura.
                                /I: Si el destino no existe, asume que el destino es un directorio.
                                /Y: Suprime las preguntas de confirmación para sobrescribir archivos.
                                ".\GroupPolicy\*.*": Especifica el origen de los archivos a copiar.
                                "C:\Windows\system32\GroupPolicy": Especifica el destino de los archivos.
                                -NoNewWindow: Ejecuta el proceso en la ventana actual.
                                -Wait: Espera a que el proceso termine antes de continuar con el script. #>
                    gpupdate /force
                            <# Fuerza en actualizar la configuración de directivas de grupo. #>
                }
                catch {
                    Write-Host "Error al configurar la seguridad: " + $_.Exception.Message
                }
            }
        <# PASO 3: CCN-STIC-599B23 - 49,62% #>
            function Function_Set-ImportFirewall {
                write-host "================ PASO 3: Modificar Valores del Firewall de Windows ================"
                write-host "Este script aplica una directiva de firewall."
                try {
                    $file_firewall = "./CCN-STIC-599B23 Incremental Clientes Independientes (Uso Oficial).wfw"
                    netsh advfirewall import "./$file_firewall"
                        <# Este comando importa una configuración de firewall avanzada #>
                }
                catch {
                    Write-Host "Error al configurar la seguridad: " + $_.Exception.Message
                }
            }
        <# PASO 4: CCN-STIC-599B23 - ~85% #>
            function Function_Set-SecurityTemplate {
                write-host "================ PASO 4: Aplicar los valores de las plantillas administrativas ================"
                        write-host "Este script aplica una directiva de firewall."
                        $inf = "./CCN-STIC-599B23 Incremental Clientes Independientes (Uso Oficial).inf"
                        try {
                            $plant="$currentPath\$inf"
                            secedit /configure /quiet /db "$currentPath\CCN-STIC-599B23 Cliente Independiente.sdb" /cfg $plant
                            Write-Host "Configuración de seguridad completada."
                        }
                        catch {
                            Write-Host "Error al configurar la seguridad: " + $_.Exception.Message
                        }
            }
            <# Directivas faltantes de las plantillas #>
            function Function_Set-OtherDirectives {
                try {
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

                    if ((Get-WmiObject -Class Win32_OperatingSystem).Caption -match "Windows 11") {
                            <# EJECUTA SI RECIBE QUE ES WINDOWS 11 #>
                            try {
                                #Configuración de servicios de windows en Deshabilitar
                                    $services = @(
                                "XblAuthManager",
                                "MapsBroker",
                                "SEMgrSvc",
                                "CscService",
                                "wlidsvc",
                                "SNMPTrap",
                                "workfolderssvc",
                                "SharedAccess",
                                "WwanSvc",
                                "SessionEnv",
                                "ShellHWDetection",
                                "diagsvc",
                                "QWAVE",
                                "autotimesvc",
                                "WdiSystemHost",
                                "WdiServiceHost",
                                "seclogon",
                                "vmicguestinterface",
                                "MicrosoftEdgeElevationService",
                                "edgeupdate",
                                "IKEEXT",
                                "Netlogon",
                                "XblGameSave",
                                "UmRdpService",
                                "wcncsvc",
                                "RmSvc",
                                "FontCache",
                                "vmicshutdown",
                                "DPS",
                                "dmwappushservice",
                                "fhsvc",
                                "HvHost",
                                "cloudidsvc",
                                "vmickvpexchange",
                                "vmicheartbeat",
                                "RetailDemo",
                                "XboxNetApiSvc",
                                "perceptionsimulation",
                                "vmictimesync",
                                "TroubleshootingSvc",
                                "WMPNetworkSvc",
                                "vmicrdv",
                                "icssvc",
                                "SmsRouter",
                                "WerSvc",
                                "vmicvmsession",
                                "PhoneSvc",
                                "TermService",
                                "vmicvss",
                                "wercplsupport",
                                "TapiSrv",
                                "Themes",
                                "WSearch",
                                "XboxGipSvc"
                                )
                            }
                            catch {
                                Write-Host "Error " + $_.Exception.Message
                            }
                            # Recorrer el array para desactivar con un bucle foreach
                                foreach ($service in $services) {
                                #Comprobar que el servicio esta operativo
                                    if (Get-Service -Name "$service" -ErrorAction SilentlyContinue) {
                                #Establecer los servicios del array como deshabilitados
                                    Set-Service -Name "$service" -StartupType Disabled
                                    Write-Host "Servicio $service desactivado."
                                    } else {
                                    Write-Host "Servicio $service no encontrado."
                                    }
                                }
                            # Definir el array con los nombres de los servicios
                                $services = @(
                                "FrameServer",
                                "SCardSvr",
                                "bthserv",
                                "ScDeviceEnum",
                                "BTAGService",
                                "WinRM",
                                "RasMan",
                                "TokenBroker",
                                "KeyIso",
                                "SSDPSRV",
                                "SCPolicySvc",
                                "upnphost",
                                "W32Time",
                                "fdPHost",
                                "PlugPlay",
                                "CertPropSvc",
                                "FDResPub",
                                "NlaSvc",
                                "BthAvctpSvc"
                                )
                            # Recorrer el array para automatic con un bucle foreach
                                foreach ($service in $services) {
                            #Comprobar que el servicio esta operativo
                                    if (Get-Service -Name "$service" -ErrorAction SilentlyContinue) {
                                #Establecer los servicios del array como Automaticos
                                        Set-Service -Name "$service" -StartupType Automatic
                                        Write-Host "Servicio $service automatico."
                                    } else {
                                        Write-Host "Servicio $service no encontrado."
                                    }
                                }
                                $services = @("edgeupdatem", "InventorySvc", "BITS", "TrustedInstaller")
                            # Recorrer el array para manual con un bucle foreach
                            foreach ($service in $services) {
                                if (Get-Service -Name "$service" -ErrorAction SilentlyContinue) {
                                    #Establecer los servicios del array como Manual
                                    Set-Service -Name "$service" -StartupType Manual
                                    Write-Host "Servicio $service manual."
                                } else {
                                    Write-Host "Servicio $service no encontrado."
                                }
                            }
                        }
                    elseif ((Get-WmiObject -Class Win32_OperatingSystem).Caption -match "Windows 10") {
                            <# SI NO ES WINDOWS 11, EJECUTA ESTE QUE ES PARA WINDOWS 10 #>
                            try {
                                    $services = @(
                                        "XblAuthManager",
                                        "edgeupdatem",
                                        "MapsBroker",
                                        "SEMgrSvc",
                                        "CscService",
                                        "wlidsvc",
                                        "SNMPTrap",
                                        "workfolderssvc",
                                        "SharedAccess",
                                        "WwanSvc",
                                        "SessionEnv",
                                        "ShellHWDetection",
                                        "diagsvc",
                                        "QWAVE",
                                        "autotimesvc",
                                        "WdiSystemHost",
                                        "WdiServiceHost",
                                        "seclogon",
                                        "vmicguestinterface",
                                        "MicrosoftEdgeElevationService",
                                        "edgeupdate",
                                        "IKEEXT",
                                        "Netlogon",
                                        "XblGameSave",
                                        "UmRdpService",
                                        "wcncsvc",
                                        "RmSvc",
                                        "FontCache",
                                        "vmicshutdown",
                                        "DPS",
                                        "dmwappushservice",
                                        "fhsvc",
                                        "HvHost",
                                        "cloudidsvc",
                                        "vmickvpexchange",
                                        "vmicheartbeat",
                                        "RetailDemo",
                                        "XboxNetApiSvc",
                                        "perceptionsimulation",
                                        "vmictimesync",
                                        "TroubleshootingSvc",
                                        "WMPNetworkSvc",
                                        "vmicrdv",
                                        "icssvc",
                                        "SmsRouter",
                                        "WerSvc",
                                        "vmicvmsession",
                                        "PhoneSvc",
                                        "TermService",
                                        "vmicvss",
                                        "wercplsupport",
                                        "TapiSrv",
                                        "Themes",
                                        "WSearch",
                                        "XboxGipSvc"
                                    )
                                    # Recorrer el array para desactivar con un bucle foreach
                                    foreach ($service in $services) {
                                        #Comprobar que el servicio esta operativo
                                        if (Get-Service -Name "$service" -ErrorAction SilentlyContinue) {
                                            #Establecer los servicios del array como deshabilitados
                                            Set-Service -Name "$service" -StartupType Disabled
                                            Write-Host "Servicio $service desactivado."
                                        } else {
                                            Write-Host "Servicio $service no encontrado."
                                        }
                                    }
                                    # Definir el array con los nombres de los servicios
                                    $services = @(
                                        "FrameServer",
                                        "SCardSvr",
                                        "bthserv",
                                        "ScDeviceEnum",
                                        "BTAGService",
                                        "WinRM",
                                        "RasMan",
                                        "TokenBroker",
                                        "KeyIso",
                                        "SSDPSRV",
                                        "SCPolicySvc",
                                        "upnphost",
                                        "W32Time",
                                        "fdPHost",
                                        "PlugPlay",
                                        "CertPropSvc",
                                        "FDResPub",
                                        "NlaSvc",
                                        "StateRepository",
                                        "BthAvctpSvc"
                                    )
                                    # Recorrer el array para automatic con un bucle foreach
                                    foreach ($service in $services) {
                                            #Comprobar que el servicio esta operativo
                                        if (Get-Service -Name "$service" -ErrorAction SilentlyContinue) {
                                            #Establecer los servicios del array como Automaticos
                                            Set-Service -Name "$service" -StartupType Automatic
                                            Write-Host "Servicio $service Automatico."
                                        } else {
                                            Write-Host "Servicio $service no encontrado."
                                        }
                                    }
                                    $services = @( "InventorySvc", "BITS", "TrustedInstaller")
                                    # Recorrer el array para manual con un bucle foreach
                                    foreach ($service in $services) {
                                        if (Get-Service -Name "$service" -ErrorAction SilentlyContinue) {
                                            #Establecer los servicios del array como Manual
                                            Set-Service -Name "$service" -StartupType Manual
                                            Write-Host "Servicio $service Manual."
                                        } else {
                                            Write-Host "Servicio $service no encontrado."
                                        }
                                    }
                            }
                            catch {
                                Write-Host "Error " + $_.Exception.Message
                            }
                        }
                    else {
                            Write-Host "No se ha podido determinar la version de Windows."
                        }
                }
                catch {
                    Write-Host "Error al configurar la seguridad: " + $_.Exception.Message
                }
                # MENSAJE DE AVISO INICIO DE SESION - LOW
                    <#
                try {
                    $path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
                    if (-Not (Test-Path "$path")) {
                        New-Item -Path "$path" -Force
                    }
                    Set-ItemProperty -Path "$path" -Name "legalnoticecaption" -Value " --TEXTO-- " -Type String -Force # TITULO
                    Set-ItemProperty -Path "$path" -Name "legalnoticetext" -Value " --TEXTO--  " -Type String  # RESTO DEL TEXTO
                }
                catch {
                    Write-Host "Error al configurar la seguridad: " + $_.Exception.Message
                } 
                    #>
        
            }

            <# INICIO DE LAS FUNCIONES #>
            
    try {
        Function_Import-SecurityTemplate
        Function_Import-SecurityFiles
        Function_Set-ImportFirewall
        Function_Set-SecurityTemplate
        Function_Set-OtherDirectives
        Write-Host "Terminado"
        Start-Sleep 2
        shutdown /r /t 0
    }
    catch {
    }
            <# FIN DE LAS FUNCIONES #>

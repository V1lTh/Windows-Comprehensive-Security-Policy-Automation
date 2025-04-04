Clear-Host
Start-Sleep 1
Write-Host "------------------------------------------------------------------"
Write-Host "          SCRIPT WINDOWS 10/11                "
Write-Host "------------------------------------------------------------------"
$currentPath = Get-Location
$getversion = (Get-WmiObject -Class Win32_OperatingSystem).Caption
<# Obtiene la localización actual del script y lo guarda, porque eventualmente tiene que cambiar de directorio #>
<# Write-Host "Aqui en $currentPath" #>
Start-Sleep 2
<# EMPIEZA SCRIPT #>
    Write-Host "Version de Windows: " $getversion
    Write-Host "1 = Todo el script: Comprobacion, Actualizacion, quitar caracteristicas y aplicaciones innecesarias. (Recomendado según CLARA)"
    Write-Host "2 = Aplicación de las directivas"
$opcion = Read-Host "Opcion: 1, 2"

switch ($opcion) {
    "1" {
    <# =================================================================== #>
    <# =================== COMPROBACIÓN DE ARCHIVOS =================== #>
    <# =================================================================== #>
        # Verificar actualizaciones de Windows - LOW
            Write-Host "Verificando actualizaciones de Windows..."
            $updateSession = New-Object -ComObject Microsoft.Update.Session
            $updateSearcher = $updateSession.CreateUpdateSearcher()
            $searchResult = $updateSearcher.Search("IsInstalled=0")

            if ($searchResult.Updates.Count -gt 0) {
                Write-Host "Se encontraron actualizaciones. Iniciando la instalación..."
                $updatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl

                foreach ($update in $searchResult.Updates) {
                    $updatesToInstall.Add($update) | Out-Null
                }

                $downloader = $updateSession.CreateUpdateDownloader()
                $downloader.Updates = $updatesToInstall
                $downloader.Download()

                $installer = $updateSession.CreateUpdateInstaller()
                $installer.Updates = $updatesToInstall
                $installationResult = $installer.Install()

                if ($installationResult.ResultCode -eq 2) {
                    Write-Host "Actualizaciones instaladas correctamente."
                } else {
                    Write-Host "Error al instalar las actualizaciones."
                }
            } else {
                Write-Host "No se encontraron actualizaciones."
            }
        # Comprobación de archivos del sistema - LOW
        Write-Host "Comprobando archivos del sistema" -InformationVariable info
            try {
                $sfc = 'C:\Windows\System32\sfc.exe'
                $scanFiles = @(
                    'C:\Windows\System32\sethc.exe'
                    'C:\Windows\System32\utilman.exe'
                    )
                    foreach ($file in $scanFiles) {
                        Write-Host "Comprobando archivo: $file"
                        & $sfc /verifyfile=$file
                    }
                }
                catch {
                    Write-Host $_.Exception.Message
                    try {
                        & $sfc /scannow
                    }
                    catch {
                        try {
                            & dism /online /cleanup-image /restorehealth
                        }
                        catch {
                            Write-Host "Error al reparar el sistema con DISM: " + $_.Exception.Message
                            Write-Host "No se pudo reparar el sistema."
                            exit 1
                        }
                    }
                }
        Write-Host
        Write-Host
    <# =================================================================== #>
    <# =================== DESINSTALAR CARACTERISTICAS =================== #>
    <# =================================================================== #>
        start-sleep 2
        Clear-Host
        try {
        $verbose = $false
        # Conjunto de caracteristicas necesarias que van a mantenerse tras la ejecucion del script - HIGTH
            <# Obtiene la lista de caracteristicas del sistema (tanto habilitadas como no habilitadas)#>
                # Recorre la lista extrayendo las caracteristicas habilitadas
                # Si la caracteristica esta habilitada, la anlade a la lista
                # Si la caracteristica esta en la lista de excluidos, la elimina de la lista
                # Deshabilita todas las caracteristicas habilitadas innecesarias
                # Lista las caracteristicas
        $mantener_caracteristica = @(
            "Client-DeviceLockdown",                #no instalado por defecto
            "Client-KeyboardFilter",                #no instalado por defecto
            "Client-UnifiedWriteFilter",            #no instalado por defecto
            "Windows-Defender-ApplicationGuard",    #no instalado por defecto
            "WorkFolders-Client",                   #por defecto
            "SmbDirect",                            #por defecto
            "MSRDC-Infraestructure",                #por defecto
            "SearchEngine-Client-Package",          #por defecto
            "Windows-Defender-Default-Definitions", #por defecto
            "Printing-PrintToPDFServices-Features", #por defecto
            "MicrosoftWindowsPowerShellV2Root",     #por defecto
            "MicrosoftWindowsPowerShellV2",         #por defecto
            "NetFx4-AdvSrvs",                       #por defecto
            "Internet-Explorer-Optional-amd64"      #por defecto
            )
            $c_todas = dism /online /format:list /get-features
            $c_hab = @()
            for ($i = 0; $i -lt $c_todas.length; $i++) {
                if ($c_todas[$i] | select-string "^Nombre de carac") {
                    if ($c_todas[$i+1] | select-string "^Estado : Habilitado") {
                        $tmp = $c_todas[$i] -split "Nombre de caracteristica : "
                        if ($verbose) { Write-Host "Caracteristica habilitada:" $tmp[1] }
                        $c_hab = $c_hab + $tmp[1]
                        $i++
                    }
                }
            }
            $c_fin = @()
            foreach ($i in $c_hab) {
            if ($mantener_caracteristica -notcontains $i) {
                $c_fin = $c_fin + $i
            }
        }
            Write-Host "Lista de caracteristicas a deshabilitar:"
            Write-Host "========================================================="
            $c_fin
            Write-Host "========================================================="
            foreach ($i in $c_fin) {
                if ($i) {
                    Write-Host "Deshabilitando caracteristica: $i"
                    dism /online /disable-feature /FeatureName:$($i.Trim()) /norestart /quiet
                } else {
                    Write-Host "Caracteristica no valida encontrada en la lista."
                }
            }
        }
        catch {
            Write-Host "Error al deshabilitar caracteristicas: " + $_.Exception.Message
        }
    <# =================================================================== #>
    <# =================== DESINSTALAR APLICACIONES =================== #>
    <# =================================================================== #>
        <# Todas son aplicaciones inncesarias recomendado para quitar, si alguna acaso no lo es, ponerlo como comentario o eliminarlo directamente.#>
        start-sleep 2
        Clear-Host
        Start-Sleep 1
        Write-Host "Quitando aplicaciones preinstaladas"
        try {
            $appname = @(
                "*3DViewer*"
                "*Advertising*"
                "*Alarms*"
                "*Bing*"
                "*Camera*"
                "*CandyCrush*"
                "*Clipchamp*"
                "*Comm*"
                "*DolbyAccess*"
                "*FeedbackHub*"
                "*Game*"
                "*Gaming*"
                "*GetHelp*"
                "*Getstarted*"
                "*Holographic*"
                "*Maps*"
                "*Mess*"
                "*MixedReality*"
                "*Office*"
                "*OneConnect*"
                "*OneNote*"
                "*People*"
                "*Phone*"
                "*PowerAutomateDesktop*"
                "*PPIProjection*"
                "*Print3D*"
                "*QuickAssist*"
                "*screensk*"
                "*Skype*"
                "*SolitaireCollection*"
                "*SoundRec*"
                "*Sticky*"
                "*Store*"
                "*Wallet*"
                "*Xbox*"
                "*Zune*"
                )
                " ================ Eliminando Appx ================"
                ForEach($app in $appname){
                    write-host "Eliminando $app"
                    Get-AppxPackage -AllUsers $app | Remove-AppxPackage -ErrorAction SilentlyContinue
                }
                Start-Sleep 2
                Clear-Host
                " ================ Eliminando Appx Provisioned ================"
                ForEach($app in $appname){
                    write-host "Eliminando $app"
                    Get-AppxProvisionedPackage -online | Where-Object {$_.packagename -like $app} | Remove-AppxProvisionedPackage -Online
                }
                Start-Sleep 2
                Clear-Host
                " ================ Eliminando Appx Bundle ================"
                try {
                    $winpack = @(
                        "*Hello-Face*"
                        "*MediaPlayer*"
                        "*QuickAssist*"
                        )
                        ForEach($pack in $winpack){
                            write-host "Eliminando $pack"
                            $package = Get-WindowsPackage -Online | Where-Object PackageName -like $pack
                        }
                        if ($package) {
                            $package | Remove-WindowsPackage -Online -NoRestart -ErrorAction SilentlyContinue
                        } else {
                            write-host "Paquete no encontrado: $pack"
                        }
                    }
                    catch {
                        Write-Host "Error al desinstalar paquetes de Windows: " + $_.Exception.Message
                    }
                    start-sleep 2
                    Clear-Host
                }
                catch {
                    Write-Host "Error al desinstalar aplicaciones: " + $_.Exception.Message
                }
    <# =================================================================== #>
    <# =================== CONFIGURACIONES DE SEGURIDAD =================== #>
    <# =================================================================== #>
            }
                "2" {
                    Write-Output "Se ha seleccionado la opción en la que se aplican directamente las directivas y se saltan las comprobaciones."
                }
            }
            <# PASO 1: Importar la plantilla de seguridad de Windows - 47% #>
            try {
                Write-Host " ================ PASO 1: Importar la plantilla de seguridad de Windows ================"
                Start-Sleep 1
                Write-Host "Este script modifica la configuracion de inicio de los servicios requeridos para la seguridad del sistema."
                $currentPath = Get-Location
                Write-Output $currentPath
                Start-Sleep 1
                $Plantilla = ".\CCN-STIC-599B23 Incremental Servicios (Uso Oficial).inf"
                secedit /configure /quiet /db ".\servicios_windows.sdb" /cfg $Plantilla /overwrite /log ".\servicios_windows.log"
            }
            catch {
                Write-Host "Error al configurar la seguridad: " + $_.Exception.Message
            }
            clear-host
            Start-Sleep 1
        <# PASO 2: Copia todos los archivos de seguridad de Windows - 49,62% #>
        try {
                write-host "================ Aplicar los valores de las plantillas administrativas ================"
                Start-Sleep 1
                write-host "Este script aplica los valores de las plantillas administrativas a la configuracion de equipo."
                $currentPath = Get-Location
                Set-Location $currentPath
                    <# Es necesario que la carpeta 'GroupPolicy' este en el mismo nivel que el script #>
                Start-Process -FilePath "xcopy" -ArgumentList "/E /H /R /I /Y `".\GroupPolicy\*.*`" `"C:\Windows\system32\GroupPolicy`"" -NoNewWindow -Wait
                gpupdate /force
            }
            catch {
                Write-Host "Error al configurar la seguridad: " + $_.Exception.Message
            }
            clear-host
            Start-Sleep 1
            <# PASO 3: CCN-STIC-599B23 - 49,62% #>
                write-host "================ Modificar Valores del Firewall de Windows ================"
                Start-Sleep 1
                write-host "Este script aplica una directiva de firewall."
                try {
                    $currentPath = Get-Location
                    $file_firewall = "./CCN-STIC-599B23 Incremental Clientes Independientes (Uso Oficial).wfw"
                    netsh advfirewall import "./$file_firewall"
                }
                catch {
                    Write-Host "Error al configurar la seguridad: " + $_.Exception.Message
                }
                clear-host
                Start-Sleep 1
            <# PASO 4: CCN-STIC-599B23 - ~85% #>
                write-host "================ Aplicar los valores de las plantillas administrativas ================"
                Start-Sleep 1
                Write-Host "SI SE SELECCIONA LA OPCION 1, SE APLICARAN LAS DIRECTIVAS DE SEGURIDAD, TENIENDO UN GRAN IMPACTO EN EL SISTEMA."
                Write-Host "La opcion 2, no aplicara ninguna directiva de seguridad."
                $x = Read-Host "Opcion: 1, 2"
                switch ($x) {
                    1 {
                        write-host "Este script aplica una directiva de firewall."
                        $inf = "./CCN-STIC-599B23 Incremental Clientes Independientes (Uso Oficial).inf"
                        try {
                            $plant="$currentPath\$inf"
                            secedit /configure /quiet /db "$currentPath\CCN-STIC-599B23 Cliente Independiente.sdb" /cfg $plant /overwrite /log "$currentPath\CCN-STIC-599B23 Cliente Independiente.log"
                            Write-Host "Configuración de seguridad completada."
                        }
                        catch {
                            Write-Host "Error al configurar la seguridad: " + $_.Exception.Message
                        }

                    }
                    Default {
                        Write-Host "INFO: No se aplicaron las directivas de seguridad."
                    }
                }
            <# Directivas que no se aplican con las plantillas #>
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
                                #Configuración de de servicios de windows en Deshabilitar
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
                        else {
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
                }
                catch {
                    Write-Host "Error al configurar la seguridad: " + $_.Exception.Message
                }
                # MENSAJE AL INICIO DE SESION - LOW
                    <#  if (-Not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
                            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force
                        }

                        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "legalnoticecaption" -Value "Acceso a los sistemas de SOFTECA." -Type String
                        if (-Not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
                            New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force
                        }
                        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "legalnoticetext" -Value " --TEXTO--  " -Type String #>
                # Reinicia el equipo para completar la desactivacion de las caracteristicas
            Write-Host "Terminado"
            Start-Sleep 1
            $shutdown = Read-Host "Reiniciar? (S/N)"
            switch ($shutdown) {
                "S" { shutdown /r /t 0 }
                "s" { shutdown /r /t 0 }
                Default {
                    Write-Host "Saliendo.."
                    Start-Sleep 2
                    Exit-PSSession
                }
            }


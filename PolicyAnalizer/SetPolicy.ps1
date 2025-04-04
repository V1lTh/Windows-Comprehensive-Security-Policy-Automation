try {
    <# CLAVES DE REGISTRO QUE PIDE BASELINE SERVER 2022 #>
    <# -------------------------------------------------- #>
        <# OBJECT ACCESS #>
        Write-Host "------------------------- OBJECT ACCESS ------------------------- "

            # SAM
                auditpol /set /subcategory:"SAM" /success:enable /failure:enable
            # File System
                auditpol /set /subcategory:"File System" /success:enable /failure:enable
            # Application Generated
                auditpol /set /subcategory:"Application Generated" /success:enable /failure:enable
            # Central Access Policy Staging
                auditpol /set /subcategory:"Central Policy Staging" /success:enable /failure:enable
            # Certification Services
                auditpol /set /subcategory:"Certification Services" /success:enable /failure:enable
            # Detailed File Share
                auditpol /set /subcategory:"Detailed File Share" /success:enable /failure:enable
            # File Share
                auditpol /set /subcategory:"File Share" /success:enable /failure:enable
            # Filtering Platform Connection
                auditpol /set /subcategory:"Filtering Platform Connection" /success:enable /failure:enable
            # Handle Manipulation
                auditpol /set /subcategory:"Handle Manipulation" /success:enable /failure:enable
            # Filtering Platform Packet Drop
                auditpol /set /subcategory:"Filtering Platform Packet Drop" /success:enable /failure:enable
            # Removable Storage
                auditpol /set /subcategory:"Removable Storage" /success:enable /failure:enable
            # Registry
                auditpol /set /subcategory:"Registry" /success:enable /failure:enable
            # Other Object Access Events
                auditpol /set /subcategory:"Other Object Access Events" /success:enable /failure:enable
            # Kernel Object
                auditpol /set /subcategory:"Kernel Object" /success:enable /failure:enable

        <# CLAVES DE REGISTRO OPCIONALES #>

            <# Auditar almacenamiento provisional de directiva de acceso central #>
<#             auditpol /set /subcategory:"Central Policy Staging" /success:enable /failure:enable
 #>            <# Auditar aplicación generada: #>
            auditpol /set /subcategory:"Application Generated" /success:enable /failure:enable
            <# Auditar colocación de paquetes de Plataforma de filtrado: #>
            auditpol /set /subcategory:"Filtering Platform Packet Drop" /success:enable /failure:enable
            <# Auditar manipulación de identificadores:#>
            auditpol /set /subcategory:"Handle Manipulation" /success:enable /failure:enable
            <# Auditar objeto de kernel: #>
            auditpol /set /subcategory:"Kernel Object" /success:enable /failure:enable
            <# Auditar recurso compartido de archivos detallado: #>
            auditpol /set /subcategory:"Detailed File Share" /success:enable /failure:enable
            <# Auditar Registro: #>
            auditpol /set /subcategory:"Registry" /success:enable /failure:enable
            <# Auditar SAM: #>
            auditpol /set /subcategory:"SAM" /success:enable /failure:enable
            <# Auditar servicios de certificación: #>
            auditpol /set /subcategory:"Certification Services" /success:enable /failure:enable
            <# Auditar sistema de archivos: #>
            auditpol /set /subcategory:"File System" /success:enable /failure:enable

    <# -------------------------------------------------- #>
        <# ACCESO DS #>
        Write-Host "------------------------- DS ACCESS ------------------------- "

            <# Auditar acceso del servicio de directorio: - Errores #>
            auditpol /set /subcategory:"Directory Service Access" /success:disable /failure:enable
            <# Auditar cambios de servicio de directorio: - Aciertos #>
            auditpol /set /subcategory:"Directory Service Changes" /success:enable /failure:disable
            <# OPCIONALES #>
            <# Auditar replicación de servicio de directorio: #>
            auditpol /set /subcategory:"Directory Service Replication" /success:disable /failure:disable
            <# Auditar replicación de servicio de directorio detallada: #>
            auditpol /set /subcategory:"Detailed Directory Service Replication" /success:disable /failure:disable

    <# -------------------------------------------------- #>
        <# ADMINISTRACION DE CUENTAS #>
        Write-Host "------------------------- ADMINISTRACION DE CUENTAS ------------------------- "

            <#  Auditar administración de cuentas de equipo         - Aciertos #>
                auditpol /set /subcategory:"Computer Account Management" /success:enable
            <#  Auditar administración de cuentas de usuario        - Aciertos Y Errores #>
                auditpol /set /subcategory:"User Account Management" /success:enable /failure:enable
            <# Auditar administración de grupos de aplicaciones #>
                auditpol /set /subcategory:"Application Group Management" /success:disable /failure:disable
            <# Auditar administración de grupos de distribución #>
                auditpol /set /subcategory:"Distribution Group Management" /success:disable /failure:disable
            <# Auditar administración de grupos de seguridad       - Aciertos #>
                auditpol /set /subcategory:"Security Group Management" /success:enable
            <# Auditar otros eventos de administración de cuentas  - Aciertos #>
                auditpol /set /subcategory:"Other Account Management Events" /success:enable

    <# -------------------------------------------------- #>
        Write-Host "------------------------- POLICY CHANGE ------------------------- "
        <# CAMBIO EN DIRECTIVAS  #>

            <# Auditar cambio de directiva de auditoría	                    - Aciertos #>
                auditpol /set /subcategory:"Audit Policy Change" /success:enable /failure:disable
            <# Auditar cambio de directiva de autenticación	                - Aciertos #>
                auditpol /set /subcategory:"Authentication Policy Change" /success:enable /failure:disable
            <# 2 - Auditar cambio de directiva de autorización #>
                auditpol /set /subcategory:"Authorization Policy Change" /success:disable /failure:disable
            <# Auditar cambio de directiva de Plataforma de filtrado #>
                auditpol /set /subcategory:"Filtering Platform Policy Change" /success:disable /failure:disable
            <# Auditar cambio de directiva del nivel de reglas de MPSSVC	- Aciertos y errores #>
                auditpol /set /subcategory:"MPSSVC Rule-Level Policy Change" /success:enable /failure:enable
            <# Auditar otros eventos de cambio de directiva	                - Errores #>
                auditpol /set /subcategory:"Other Policy Change Events" /success:disable /failure:enable

    <# -------------------------------------------------- #>
    Write-Host "------------------------- EVENT AUDIT ------------------------- "
        <# EVENT AUDIT #>
                <# https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-gpsb/01f8e057-f6a8-4d6e-8a00-99bcd241b403 #>

            <# AuditAccountLogon #>
                <# auditpol /set /subcategory:"Account Logon" /success:disable /failure:disable #>
            <# AuditDSAccess #>
                <# auditpol /set /subcategory:"AuditDSAccess" /success:disable /failure:disable #>
            <# AuditSystemEvents #>
                <# auditpol /set /subcategory:"System Events" /success:disable /failure:disable #>
            <# AuditAccountManagement #>
                <# auditpol /set /subcategory:"Account Management" /success:disable /failure:disable #>
            <# AuditProcessTracking #>
                <# auditpol /set /subcategory:"Process Tracking" /success:disable /failure:disable #>
            <# AuditLogonEvents #>
                <# auditpol /set /subcategory:"Logon/Logoff" /success:disable /failure:disable #>
            <# AuditPolicyChange #>
                <# auditpol /set /subcategory:"Audit Policy Change" /success:disable /failure:disable #>
            <# AuditObjectAccess #>
                <# auditpol /set /subcategory:"Object Access" /success:disable /failure:disable #>
            <# AuditPrivilegeUse #>
                <# auditpol /set /subcategory:"Privilege Use" /success:disable /failure:disable #>


    <# -------------------------------------------------- #>
        <# ACCOUNT LOGON #>
        Write-Host "------------------------- ACCOUNT LOGON ------------------------- "

            <# Credential Validation #>
                auditpol /set /subcategory:"{0CCE923F-69AE-11D9-BED3-505054503030}" /success:disable /failure:disable
            <# Kerberos Service Ticket Operations	- Failure #>
                auditpol /set /subcategory:"Kerberos Service Ticket Operations" /success:disable /failure:enable
            <# Other Account Logon Events		    - No Auditing #>
                auditpol /set /subcategory:"Other Account Logon Events" /success:disable /failure:disable
            <# Kerberos Authentication Service	    - Success and Failure #>
                auditpol /set /subcategory:"Kerberos Authentication Service" /success:enable /failure:enable

    <# -------------------------------------------------- #>
        <# INICIO Y CIERRE DE SESION #>
        Write-Host "------------------------- INICIO Y CIERRE DE SESION ------------------------- "

        # Auditoría de pertenencia a grupos (Aciertos)
            auditpol /set /subcategory:"Group Membership" /success:enable /failure:disable
        # Auditar inicio de sesión especial (Aciertos)
            auditpol /set /subcategory:"Special Logon" /success:enable /failure:disable
        # Auditar bloqueo de cuentas (Errores)
            auditpol /set /subcategory:"Account Lockout" /success:disable /failure:enable
        # Notificaciones de usuario o dispositivo de auditoría
            auditpol /set /subcategory:"User / Device Claims" /success:disable /failure:disable
        # Auditar cierre de sesión
            auditpol /set /subcategory:"Logoff" /success:disable /failure:disable
        # Auditar inicio de sesión (Aciertos y errores)
            auditpol /set /subcategory:"Logon" /success:enable /failure:enable
        # Auditar otros eventos de inicio y cierre de sesión (Aciertos y errores)
            auditpol /set /subcategory:"Other Logon/Logoff Events" /success:enable /failure:enable
        # Auditar Servidor de directivas de redes
            auditpol /set /subcategory:"Network Policy Server" /success:disable /failure:disable
        # Auditar modo principal de IPsec
            auditpol /set /subcategory:"IPsec Main Mode" /success:disable /failure:disable
        # Auditar modo rápido de IPsec
            auditpol /set /subcategory:"IPsec Quick Mode" /success:disable /failure:disable
        # Auditar modo extendido de IPsec
            auditpol /set /subcategory:"IPsec Extended Mode" /success:disable /failure:disable

    <# -------------------------------------------------- #>
        <# INICIO Y CIERRE DE SESION #>
        <# -- REVISAR -- #>
        Write-Host "------------------------- INICIO Y CIERRE DE SESION ------------------------- "

        <#  Option - AuditBaseDirectories - deshabilitado #>
                <# auditpol /set /option:"AuditBaseDirectories" /value:disabled #>
            <#  Option - AuditBaseObjects - deshabilitado #>
                <# auditpol /set /option:"AuditBaseObjects" /value:disabled #>
            <#  Option - CrashOnAuditFail - deshabilitado #>
                <# auditpol /set /option:"CrashOnAuditFail" /value:disabled #>
            <#  Option - FullPrivilegeAuditing - deshabilitado #>
                <# auditpol /set /option:"FullPrivilegeAuditing" /value:disabled #>

    <# -------------------------------------------------- #>
        <# Privilege Rights #>
        Write-Host "------------------------- PRIVILEGE RIGHTS ------------------------- "
        <# -- REVISAR -- #>
            # auditpol /set /subcategory:"SeTimeZonePrivilege"                /value:
            # auditpol /set /subcategory:"SeDenyInteractiveLogonRight"        /value:
            # auditpol /set /subcategory:"SeDenyServiceLogonRight"            /value:
            # auditpol /set /subcategory:"SeUndockPrivilege"                  /value:
            # auditpol /set /subcategory:"SeTrustedCredManAccessPrivilege"    /value:
            # auditpol /set /subcategory:"SeDenyBatchLogonRight"              /value:
            # auditpol /set /subcategory:"SeDelegateSessionUserImpersonatePrivilege" /value:
            # auditpol /set /subcategory:"SeDebugPrivilege"                   /value:
            # auditpol /set /subcategory:"SeCreateTokenPrivilege"             /value:
            # auditpol /set /subcategory:"SeCreateSymbolicLinkPrivilege"      /value:
            # auditpol /set /subcategory:"SeCreatePermanentPrivilege"         /value:
                # auditpol /set /subcategory:"SeCreatePagefilePrivilege"          /value:'*S-1-5-32-544'
                # auditpol /set /subcategory:"SeCreateGlobalPrivilege"            /value:'*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-6'
            # auditpol /set /subcategory:"SeChangeNotifyPrivilege"            /value:
            # auditpol /set /subcategory:"SeBatchLogonRight" /value:
                # auditpol /set /subcategory:"SeBackupPrivilege" /value:'*S-1-5-32-544'
            # auditpol /set /subcategory:"SeAuditPrivilege" /value:
            # auditpol /set /subcategory:"SeAssignPrimaryTokenPrivilege" /value:
            # auditpol /set /subcategory:"SeEnableDelegationPrivilege" /value:***CONFLICT***
            # auditpol /set /subcategory:"SeMachineAccountPrivilege" /value:
            # auditpol /set /subcategory:"SeTcbPrivilege" /value:
                # auditpol /set /subcategory:"SeManageVolumePrivilege" /value:'*S-1-5-32-544'
            # auditpol /set /subcategory:"SeLockMemoryPrivilege" /value:
            # auditpol /set /subcategory:"SeSystemProfilePrivilege" /value:
                # auditpol /set /subcategory:"SeDenyNetworkLogonRight" /value:'*S-1-5-114'
                # auditpol /set /subcategory:"SeDenyRemoteInteractiveLogonRight" /value:'*S-1-5-113'
                # auditpol /set /subcategory:"SeTakeOwnershipPrivilege" /value:*S-1-5-32-544
            # auditpol /set /subcategory:"SeSyncAgentPrivilege" /value:
                # auditpol /set /subcategory:"SeImpersonatePrivilege" /value:*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-6
            # auditpol /set /subcategory:"SeIncreaseBasePriorityPrivilege" /value:
            # auditpol /set /subcategory:"SeIncreaseQuotaPrivilege" /value:
            # auditpol /set /subcategory:"SeIncreaseWorkingSetPrivilege" /value:
                # auditpol /set /subcategory:"SeInteractiveLogonRight" /value:*S-1-5-32-544
                # auditpol /set /subcategory:"SeLoadDriverPrivilege" /value:*S-1-5-32-544
            # auditpol /set /subcategory:"SeNetworkLogonRight" /value:***CONFLICT***
                # auditpol /set /subcategory:"SeSystemEnvironmentPrivilege" /value:*S-1-5-32-544
            # auditpol /set /subcategory:"SeSystemtimePrivilege" /value:
            # auditpol /set /subcategory:"SeShutdownPrivilege" /value:
                # auditpol /set /subcategory:"SeRemoteInteractiveLogonRight" /value:*S-1-5-32-544
                # auditpol /set /subcategory:"SeProfileSingleProcessPrivilege" /value:*S-1-5-32-544
            # auditpol /set /subcategory:"SeRelabelPrivilege" /value:
                # auditpol /set /subcategory:"SeRestorePrivilege" /value:*S-1-5-32-544
                # auditpol /set /subcategory:"SeRemoteShutdownPrivilege" /value:*S-1-5-32-544
                # auditpol /set /subcategory:"SeSecurityPrivilege" /value:*S-1-5-32-544
            # auditpol /set /subcategory:"SeServiceLogonRight" /value:

    <# -------------------------------------------------- #>
        <# Seguimiento detallado #>
        Write-Host "------------------------- Seguimiento detallado ------------------------- "
            auditpol /set /subcategory:"DPAPI Activity" /success:disable /failure:disable
            auditpol /set /subcategory:"Token Right Adjusted Events" /success:disable /failure:disable
            auditpol /set /subcategory:"RPC Events" /success:disable /failure:disable
            auditpol /set /subcategory:"Plug and Play Events" /success:enable /failure:disable
            auditpol /set /subcategory:"Process Termination" /success:disable /failure:disable
            auditpol /set /subcategory:"Process Creation" /success:enable /failure:disable


    <# -------------------------------------------------- #>
        <# Service General Setting #>
        Write-Host "------------------------- Service General Setting ------------------------- "
        <# -- REVISAR -- #>
                <# https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-gpsb/40024ae3-c3b8-45db-9081-c4dc3684f9f7 #>
            # Service General Setting - AppIDSvc
                # Define el nombre del servicio y el tipo de inicio

                    <# $serviceName = "AppIDSvc"
                    $startupType = "Automatic"
                    Set-Service -Name $serviceName -StartupType $startupType
                    $aclString = "D:(A;;RPWPCCDCLCSWRCWDWOGA;;;S-1-0-0)"
                    $service = Get-WmiObject -Class Win32_Service -Filter "Name='$serviceName'"
                    $service.Change($null, $null, $null, $null, $null, $null, $null, $null, $aclString) #>

    <# -------------------------------------------------- #>
        <# Sistema #>
        Write-Host "------------------------- Sistema ------------------------- "

        # Auditar integridad del sistema
            # auditpol /set /subcategory:"Auditar integridad del sistema" /success:enable /failure:enable
        # Auditar otros eventos del sistema
            # auditpol /set /subcategory:"Auditar otros eventos del sistema" /success:enable /failure:enable
        # Auditar controlador IPsec
            # auditpol /set /subcategory:"Auditar controlador IPsec" /success:disable /failure:disable
        # Auditar extensión del sistema de seguridad
            # auditpol /set /subcategory:"Auditar extensión del sistema de seguridad" /success:enable /failure:disable
        # Auditar cambio de estado de seguridad
            # auditpol /set /subcategory:"Auditar cambio de estado de seguridad" /success:enable /failure:disable


    <# -------------------------------------------------- #>
        <# Sistema #>
        Write-Host "------------------------- HKLM - WINDOWS NT  ------------------------- "

        # Software\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole
        # SetCommand
        reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole" /v SetCommand /t REG_DWORD /d 0 /f

        # Software\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole
        # SecurityLevel
        reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole" /v SecurityLevel /t REG_DWORD /d 0 /f

        # Software\Microsoft\Windows NT\CurrentVersion\Winlogon
        # PasswordExpiryWarning
        reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v PasswordExpiryWarning /t REG_DWORD /d 5 /f

        # Software\Microsoft\Windows NT\CurrentVersion\Winlogon
        # ScRemoveOption
        reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v ScRemoveOption /t REG_DWORD /d 1 /f

        # Software\Microsoft\Windows NT\CurrentVersion\Winlogon
        # CachedLogonsCount
        reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v CachedLogonsCount /t REG_DWORD /d 10 /f

        # Software\Microsoft\Windows NT\CurrentVersion\Winlogon
        # ForceUnlockLogon
        reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v ForceUnlockLogon /t REG_DWORD /d 0 /f

        }
        catch {
            Write-Host $_ -ForegroundColor Red
            exit 2
        }
    start-sleep -s 50



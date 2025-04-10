try {
        <# ACCOUNT LOGON #>
        Write-Host "------------------------- ACCOUNT LOGON ------------------------- "

            <# Credential Validation | Recommended default on Server Editions - Success #>
                auditpol /set /subcategory:"{0CCE923F-69AE-11D9-BED3-505054503030}" /success:enable /failure:disable
            <# Kerberos Authentication Service	    - Success and Failure #>
                auditpol /set /subcategory:"Kerberos Authentication Service" /success:enable /failure:enable
            <# Kerberos Service Ticket Operations	- Failure #>
                auditpol /set /subcategory:"Kerberos Service Ticket Operations" /success:disable /failure:enable
            <# Other Account Logon Events		    - No Auditing #>
                auditpol /set /subcategory:"Other Account Logon Events" /success:disable /failure:disable

    <# -------------------------------------------------- #>
        <# ADMINISTRACION DE CUENTAS #>
        Write-Host "------------------------- Account Management ------------------------- "

            <# Auditar administración de grupos de aplicaciones     - No Auditing #>
                auditpol /set /subcategory:"Application Group Management" /success:disable /failure:disable
            <#  Auditar administración de cuentas de equipo         - Aciertos #>
                auditpol /set /subcategory:"Computer Account Management" /success:enable
            <# Auditar administración de grupos de distribución     - No Auditing #>
                auditpol /set /subcategory:"Distribution Group Management" /success:disable /failure:disable
            <# Auditar otros eventos de administración de cuentas  - Aciertos #>
                auditpol /set /subcategory:"Other Account Management Events" /success:enable
            <# Auditar administración de grupos de seguridad       - Aciertos #>
                auditpol /set /subcategory:"Security Group Management" /success:enable
            <#  Auditar administración de cuentas de usuario        - Aciertos Y Errores #>
                auditpol /set /subcategory:"User Account Management" /success:enable /failure:enable

    <# -------------------------------------------------- #>
        <# Seguimiento detallado #>
        Write-Host "------------------------- DETAILED TRACKING ------------------------- "

            <#  DPAPI Activity: Audita las actividades relacionadas con la Protección de Datos de la API (DPAPI),
                que se utiliza para proteger datos como contraseñas y claves criptográficas - No Auditing #>
                auditpol /set /subcategory:"DPAPI Activity" /success:disable /failure:disable
            <# Plug and Play Events: Audita los eventos relacionados con la conexión y desconexión de dispositivos
                PnP, como impresoras y unidades USB - Success #>
                auditpol /set /subcategory:"Plug and Play Events" /success:enable /failure:disable
            <# Process Creation: Audita los eventos cuando se crea un nuevo proceso en el sistema - Success #>
                auditpol /set /subcategory:"Process Creation" /success:enable /failure:disable
            <# Process Termination: Audita los eventos cuando se termina un proceso en el sistema - No auditing #>
                auditpol /set /subcategory:"Process Termination" /success:disable /failure:disable
            <# RPC Events: Audita los eventos relacionados con las llamadas a procedimientos remotos (RPC),
                que son utilizadas para la comunicación entre procesos en diferentes sistemas - No auditing #>
                auditpol /set /subcategory:"RPC Events" /success:disable /failure:disable
            <# Token Right Adjusted Events: Audita los eventos cuando se ajustan los derechos de un token,
                lo que puede incluir cambios en los privilegios de usuario - No Auditing #>
                auditpol /set /subcategory:"Token Right Adjusted Events" /success:disable /failure:disable

    <# -------------------------------------------------- #>
        <# DS ACCESS #>
        Write-Host "------------------------- DS ACCESS ------------------------- "

            <# Auditar replicación de servicio de directorio detallada: - No auditing #>
                auditpol /set /subcategory:"Detailed Directory Service Replication" /success:disable /failure:disable
            <# Auditar acceso del servicio de directorio: - Errores #>
                auditpol /set /subcategory:"Directory Service Access" /success:disable /failure:enable
            <# Auditar cambios de servicio de directorio: - Aciertos #>
                auditpol /set /subcategory:"Directory Service Changes" /success:enable /failure:disable
            <# Auditar replicación de servicio de directorio: - No auditing #>
                auditpol /set /subcategory:"Directory Service Replication" /success:disable /failure:disable

    <# -------------------------------------------------- #>
        <# EVENT AUDIT #>
        Write-Host "------------------------- EVENT AUDIT ------------------------- "
                <# https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-gpsb/01f8e057-f6a8-4d6e-8a00-99bcd241b403 #>

            # <# AuditAccountLogon #>
            #     auditpol /set /subcategory:"Account Logon" /success:disable /failure:disable
            # <# AuditDSAccess #>
            #     auditpol /set /subcategory:"AuditDSAccess" /success:disable /failure:disable
            # <# AuditSystemEvents #>
            #     auditpol /set /subcategory:"System Events" /success:disable /failure:disable
            # <# AuditAccountManagement #>
            #     auditpol /set /subcategory:"Account Management" /success:disable /failure:disable
            # <# AuditProcessTracking #>
            #     auditpol /set /subcategory:"Process Tracking" /success:disable /failure:disable
            # <# AuditLogonEvents #>
            #     auditpol /set /subcategory:"Logon/Logoff" /success:disable /failure:disable
            # <# AuditPolicyChange #>
            #     auditpol /set /subcategory:"Audit Policy Change" /success:disable /failure:disable
            # <# AuditObjectAccess #>
            #     auditpol /set /subcategory:"Object Access" /success:disable /failure:disable
            # <# AuditPrivilegeUse #>
            #     auditpol /set /subcategory:"Privilege Use" /success:disable /failure:disable

    <# -------------------------------------------------- #>
        <# INICIO Y CIERRE DE SESION #>
        Write-Host "------------------------- LOGON / LOGOFF ------------------------- "

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
            <# Auditar almacenamiento provisional de directiva de acceso central #>
                auditpol /set /subcategory:"Central Policy Staging" /success:enable /failure:enable
            <# Auditar aplicación generada: #>
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
        Write-Host "------------------------- OPTIONS ------------------------- "
        <# CAMBIO EN DIRECTIVAS  #>
                <# -- REVISAR -- #>

        <#
            Option - AuditBaseDirectories	Option:AuditBaseDirectories		Disabled
            Option - AuditBaseObjects	    Option:AuditBaseObjects		    Disabled
            Option - CrashOnAuditFail	    Option:CrashOnAuditFail		    Disabled
            Option - FullPrivilegeAuditing	Option:FullPrivilegeAuditing	Disabled
        #>

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
try {
        Write-Host "------------------------- PRIVILEGE RIGHTS ------------------------- "
    <#
        SIDs: SID se usa para identificar de forma única una entidad de seguridad o un grupo de seguridad.
                Las entidades de seguridad pueden representar cualquier entidad que el sistema operativo pueda autenticar.

            *S-1-1-0: Everyone
                Grupo "Everyone" o "World", se utiliza para otorgar permisos y derechos a todos los usuarios sin excepción.
            *S-1-5-6: Service
                Grupo Service, incluye todas las cuentas de servicio que se utilizan para ejecutar servicios en el sistema.
            *S-1-5-19: LocalService
                Cuenta LocalService. Utilizado por servicios que requieren acceso limitado al sistema local y presentan credenciales anónimas en la red.
            *S-1-5-20: NetworkService
                Cuenta NetworkService. Utilizado por servicios que necesitan acceso autenticado a la red pero tienen privilegios limitados en el sistema local.
            *S-1-5-32-544: Administrators
                Grupo Administrators en el dominio local. Utilizado para otorgar permisos y derechos administrativos a los usuarios que son miembros de este grupo1.
            *S-1-5-32-545: Users
                Grupo Users en el dominio local. Utilizado para otorgar permisos y derechos básicos a los usuarios que son miembros de este grupo1.
            *S-1-5-32-551: Backup Operators
                Grupo Backup Operators en el dominio local. Utilizado para otorgar permisos y derechos relacionados con la realización de copias de seguridad y restauración de datos1.
            *S-1-5-113: Local account
                Cuentas locales. Se utiliza para identificar cuentas locales en el sistema. Este SID es útil para restringir el inicio de sesión en la red a cuentas locales3.
            *S-1-5-114: Local account and member of Administrators group
                Cuentas locales que son miembros del grupo de administradores. Se utiliza para identificar cuentas locales que tienen privilegios administrativos.
                Este SID es útil para restringir el inicio de sesión en la red a cuentas locales en lugar de cuentas de administrador o equivalentes2.
    #>

# Definir las políticas y sus valores en un array
$policies = @(
    # @{ Name = "SeTcbPrivilege"; Value = "" },
    # @{ Name = "SeTimeZonePrivilege"; Value = "" },
    # @{ Name = "SeUndockPrivilege"; Value = "" },
    # @{ Name = "SeTrustedCredManAccessPrivilege"; Value = "" },
    @{ Name = "SeTakeOwnershipPrivilege"; Value = "*S-1-5-32-544" },
    @{ Name = "SeSecurityPrivilege"; Value = "*S-1-5-32-544" },
    # @{ Name = "SeCreateSymbolicLinkPrivilege"; Value = "" },
    @{ Name = "SeRestorePrivilege"; Value = "*S-1-5-32-544" },
    # @{ Name = "SeCreatePermanentPrivilege"; Value = "" },
    @{ Name = "SeCreatePagefilePrivilege"; Value = "*S-1-5-32-544" },
    @{ Name = "SeCreateGlobalPrivilege"; Value = "*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-6" },
    # @{ Name = "SeChangeNotifyPrivilege"; Value = "" },
    # @{ Name = "SeBatchLogonRight"; Value = "" },
    @{ Name = "SeBackupPrivilege"; Value = "*S-1-5-32-544" },
    # @{ Name = "SeAuditPrivilege"; Value = "" },
    # @{ Name = "SeAssignPrimaryTokenPrivilege"; Value = "" },
    # @{ Name = "SeDenyServiceLogonRight"; Value = "" },
    # @{ Name = "SeIncreaseWorkingSetPrivilege"; Value = "" }
    # @{ Name = "SeNetworkLogonRight"; Value = "" }, # Revisar
    @{ Name = "SeInteractiveLogonRight"; Value = "*S-1-5-32-544" },
    @{ Name = "SeProfileSingleProcessPrivilege"; Value = "*S-1-5-32-544" },
    # @{ Name = "SeRelabelPrivilege"; Value = "" },
    # @{ Name = "SeCreateTokenPrivilege"; Value = "" },
    @{ Name = "SeDebugPrivilege"; Value = "*S-1-5-32-544" },
    # @{ Name = "SeDelegateSessionUserImpersonatePrivilege"; Value = "" },
    # @{ Name = "SeDenyBatchLogonRight"; Value = "" },
    # @{ Name = "SeDenyInteractiveLogonRight"; Value = "" }
    @{ Name = "SeDenyNetworkLogonRight"; Value = "*S-1-5-114" },
    @{ Name = "SeDenyRemoteInteractiveLogonRight"; Value = "*S-1-5-113" },
    # @{ Name = "SeIncreaseBasePriorityPrivilege"; Value = "" },
    # @{ Name = "SeEnableDelegationPrivilege"; Value = "" }, # Revisar
    @{ Name = "SeImpersonatePrivilege"; Value = "*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-6" },
    @{ Name = "SeRemoteShutdownPrivilege"; Value = "*S-1-5-32-544" },
    # @{ Name = "SeIncreaseQuotaPrivilege"; Value = "" },
    # @{ Name = "SeMachineAccountPrivilege"; Value = "" },
    @{ Name = "SeRemoteInteractiveLogonRight"; Value = "*S-1-5-32-544" },
    @{ Name = "SeLoadDriverPrivilege"; Value = "*S-1-5-32-544" },
    # @{ Name = "SeLockMemoryPrivilege"; Value = "" },
    # @{ Name = "SeSystemtimePrivilege"; Value = "" },
    @{ Name = "SeSystemEnvironmentPrivilege"; Value = "*S-1-5-32-544" },
    @{ Name = "SeManageVolumePrivilege"; Value = "*S-1-5-32-544" }
    # @{ Name = "SeSystemProfilePrivilege"; Value = "" },
    # @{ Name = "SeSyncAgentPrivilege"; Value = "" },
    # @{ Name = "SeShutdownPrivilege"; Value = "" },
    # @{ Name = "SeServiceLogonRight"; Value = "" },



# Crear el contenido del archivo .inf
        $infContent = @"
        [Unicode]
        Unicode=yes
        [System Access]
        [Event Audit]
        [Registry Values]
        [Privilege Rights]
"@

        foreach ($policy in $policies) {
            $infContent += "$($policy.Name) = $($policy.Value)`r`n"
        }
        $infFilePath = "C:\temp\policies.inf"
        $infContent | Out-File -FilePath $infFilePath -Encoding ASCII -Force
        secedit.exe /configure /db secedit.sdb /cfg $infFilePath /areas USER_RIGHTS

)

}
catch {
    Write-Host $_ -ForegroundColor Red
}
    <# -------------------------------------------------- #>
        <# PRIVILEGE USE - VERY HIGH #>
        Write-Host "------------------------- Privilege Use ------------------------- "

        # Desactivar auditoría de uso de privilegios no sensibles
    #        auditpol /set /subcategory:"Non Sensitive Privilege Use" /success:disable /failure:disable

        # Desactivar auditoría de uso de privilegios sensibles
    #        auditpol /set /subcategory:"Sensitive Privilege Use" /success:enable /failure:enable

        # Desactivar auditoría de otros eventos de uso de privilegios
    #        auditpol /set /subcategory:"Other Privilege Use Events" /success:disable /failure:disable

    <# -------------------------------------------------- #>

        <# Service General Setting #>
        Write-Host "------------------------- Service General Setting ------------------------- "
                <# https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-gpsb/40024ae3-c3b8-45db-9081-c4dc3684f9f7 #>
            # Service General Setting - AppIDSvc

                    sc.exe config appidsvc start=auto

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

            $registryPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Setup"
                    Write-Host " ------------------------- $registryPath ------------------------- "

        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        # Set-ItemProperty -Path $registryPath -Name "SetCommand" -Value "0" -Type DWord
        # Set-ItemProperty -Path $registryPath -Name "SecurityLevel" -Value "0" -Type DWord


            $registryPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
                    Write-Host " ------------------------- $registryPath ------------------------- "
        if (-Not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force
        }
        # Set-ItemProperty -Path $registryPath -Name "ForceUnlockLogon" -Value "0" -Type DWord
        Set-ItemProperty -Path $registryPath -Name "ScRemoveOption" -Value "1" -Type DWord
        # Set-ItemProperty -Path $registryPath -Name "PasswordExpiryWarning" -Value "5" -Type DWord


            $registryPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
                    Write-Host " ------------------------- $registryPath ------------------------- "
        if (-Not (Test-Path $registryPath)) {
                    New-Item -Path $registryPath -Force
        }
        Set-ItemProperty -Path $registryPath -Name "NoAutorun" -Value "1" -Type DWord
        Set-ItemProperty -Path $registryPath -Name "NoDriveTypeAutoRun" -Value "255" -Type DWord


            $registryPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Ext"
                    Write-Host " ------------------------- $registryPath ------------------------- "
        if (-Not (Test-Path $registryPath)) {
                    New-Item -Path $registryPath -Force
        }
        Set-ItemProperty -Path $registryPath -Name "RunThisTimeEnabled" -Value "0" -Type DWord
        Set-ItemProperty -Path $registryPath -Name "VersionCheckEnabled" -Value "1" -Type DWord


$policies = @(

    $Path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
        @{ registryPath = "$Path"; Name = "FilterAdministratorToken"; Value = "1" },
        @{ registryPath = "$Path"; Name = "InactivityTimeoutSecs"; Value = "900" },
        @{ registryPath = "$Path"; Name = "ConsentPromptBehaviorAdmin"; Value = "2" },
        # @{ registryPath = "$Path"; Name = "DisableCAD"; Value = "" },
        # @{ registryPath = "$Path"; Name = "ValidateAdminCodeSignatures"; Value = "" },
        # @{ registryPath = "$Path"; Name = "UndockWithoutLogon"; Value = "" },
        # @{ registryPath = "$Path"; Name = "ShutdownWithoutLogon"; Value = "" },
        # @{ registryPath = "$Path"; Name = "ScForceOption"; Value = "" },
        # @{ registryPath = "$Path"; Name = "PromptOnSecureDesktop"; Value = "" },
        @{ registryPath = "$Path"; Name = "LocalAccountTokenFilterPolicy"; Value = "0" },
        # @{ registryPath = "$Path"; Name = "LegalNoticeText"; Value = "" },
        # @{ registryPath = "$Path"; Name = "LegalNoticeCaption"; Value = "" },
        @{ registryPath = "$Path"; Name = "EnableLUA"; Value = "1" },
        # @{ registryPath = "$Path"; Name = "DontDisplayLastUserName"; Value = "" },
        @{ registryPath = "$Path"; Name = "EnableVirtualization"; Value = "1" },
        @{ registryPath = "$Path"; Name = "ConsentPromptBehaviorUser"; Value = "0" },
        @{ registryPath = "$Path"; Name = "DisableAutomaticRestartSignOn"; Value = "1" },
        @{ registryPath = "$Path"; Name = "EnableInstallerDetection"; Value = "1" }
        # @{ registryPath = "$Path"; Name = "EnableUIADesktopToggle"; Value = "0" }
        @{ registryPath = "$Path"; Name = "EnableUIADesktopToggle"; Value = "1" }

    $Path = "HKLM:Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters"
        @{ registryPath = "$Path"; Name = "AllowEncryptionOracle"; Value = "0" }

    $Path = "HKLM:Software\Policies\Microsoft Services\AdmPwd"
        @{ registryPath = "$Path"; Name = "AdmPwdEnabled"; Value = "1" }

    $Path = "HKLM:Software\Policies\Microsoft\Biometrics\FacialFeatures"
        @{ registryPath = "$Path"; Name = "EnhancedAntiSpoofing"; Value = "1" }

    $Path = "HKLM:Software\Policies\Microsoft\Internet Explorer\Control Panel"
        @{ registryPath = "$Path"; Name = "FormSuggest Passwords"; Value = "1" }

    $Path = "HKLM:Software\Policies\Microsoft\Internet Explorer\Download"
        @{ registryPath = "$Path"; Name = "RunInvalidSignatures"; Value = "0" }
        @{ registryPath = "$Path"; Name = "CheckExeSignatures"; Value = "yes" }

    $Path = "HKLM:Software\Policies\Microsoft\Internet Explorer\Feeds"
        @{ registryPath = "$Path"; Name = "DisableEnclosureDownload"; Value = "1" }

    $Path = "HKLM:Software\Policies\Microsoft\Internet Explorer\Main"
        @{ registryPath = "$Path"; Name = "Isolation64Bit"; Value = "1" }
        @{ registryPath = "$Path"; Name = "FormSuggest PW Ask"; Value = "no" }
        @{ registryPath = "$Path"; Name = "FormSuggest Passwords"; Value = "no" }
        @{ registryPath = "$Path"; Name = "DisableEPMCompat"; Value = "1" }
        @{ registryPath = "$Path"; Name = "Isolation"; Value = "PMEM" }
    #    $Path = "HKLM:"


    $Path = "HKLM:Software\Policies\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_DISABLE_MK_PROTOCOL"
        # @{ registryPath = "$Path"; Name = "(RESERVED)"; Value = "1" }
        @{ registryPath = "$Path"; Name = "explorer.exe"; Value = "1" }
        @{ registryPath = "$Path"; Name = "iexplore.exe"; Value = "1" }

    $Path = "HKLM:Software\Policies\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MIME_HANDLING"
        @{ registryPath = "$Path"; Name = "explorer.exe"; Value = "1" }
        @{ registryPath = "$Path"; Name = "iexplore.exe"; Value = "1" }
        # @{ registryPath = "$Path"; Name = "(RESERVED)"; Value = "1" }

    $Path = "HKLM:Software\Policies\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MIME_SNIFFING"
        @{ registryPath = "$Path"; Name = "iexplore.exe"; Value = "1" }
        @{ registryPath = "$Path"; Name = "explorer.exe"; Value = "1" }
        # @{ registryPath = "$Path"; Name = "(RESERVED)"; Value = "1" }

    $Path = "HKLM:Software\Policies\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_RESTRICT_ACTIVEXINSTALL"
        @{ registryPath = "$Path"; Name = "explorer.exe"; Value = "1" }
        @{ registryPath = "$Path"; Name = "iexplore.exe"; Value = "1" }
        # @{ registryPath = "$Path"; Name = "(RESERVED)"; Value = "1"

    $Path = "HKLM:Software\Policies\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_RESTRICT_FILEDOWNLOAD"
        # @{ registryPath = "$Path"; Name = "(RESERVED)"; Value = "1" }
        @{ registryPath = "$Path"; Name = "explorer.exe"; Value = "1" }
        @{ registryPath = "$Path"; Name = "iexplore.exe"; Value = "1" }

    $Path = "HKLM:Software\Policies\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_SECURITYBAND"
        @{ registryPath = "$Path"; Name = "explorer.exe"; Value = "1" }
        @{ registryPath = "$Path"; Name = "iexplore.exe"; Value = "1" }
        # @{ registryPath = "$Path"; Name = "(RESERVED)"; Value = "1" }

    $Path = "HKLM:Software\Policies\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_WINDOW_RESTRICTIONS"
        # @{ registryPath = "$Path"; Name = "(RESERVED)"; Value = "1" }
        @{ registryPath = "$Path"; Name = "iexplore.exe"; Value = "1" }
        @{ registryPath = "$Path"; Name = "explorer.exe"; Value = "1" }

    $Path = "HKLM:Software\Policies\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_ZONE_ELEVATION"
        @{ registryPath = "$Path"; Name = "iexplore.exe"; Value = "1" }
        # @{ registryPath = "$Path"; Name = "(RESERVED)"; Value = "1" }
        @{ registryPath = "$Path"; Name = "explorer.exe"; Value = "1" }

    $Path = "Software\Policies\Microsoft\Internet Explorer\PhishingFilter"
        @{ registryPath = "$Path"; Name = "EnabledV9"; Value = "1" }
        @{ registryPath = "$Path"; Name = "PreventOverride"; Value = "1" }
        @{ registryPath = "$Path"; Name = "PreventOverrideAppRepUnknown"; Value = "1" }

    $Path = "Software\Policies\Microsoft\Internet Explorer\PhishingFilter"
        @{ registryPath = "$Path"; Name = "NoCrashDetection"; Value = "1" }

    $Path = "Software\Policies\Microsoft\Internet Explorer\Security"
        @{ registryPath = "$Path"; Name = "DisableSecuritySettingsCheck"; Value = "0" }

    $Path = "Software\Policies\Microsoft\Internet Explorer\Security\ActiveX"
        @{ registryPath = "$Path"; Name = "BlockNonAdminActiveXInstall"; Value = "1" }

    $Path = "Software\Policies\Microsoft\Windows Defender"
        @{ registryPath = "$Path"; Name = "PUAProtection"; Value = "1" }

    $Path = "Software\Policies\Microsoft\Windows Defender\MpEnginer"
        @{ registryPath = "$Path"; Name = "MpCloudBlockLevel"; Value = "2" }

    $Path = "Software\Policies\Microsoft\Windows Defender\Real-Time Protection"
        @{ registryPath = "$Path"; Name = "DisableIOAVProtection"; Value = "0" }
        @{ registryPath = "$Path"; Name = "DisableRealtimeMonitoring"; Value = "0" }
        @{ registryPath = "$Path"; Name = "DisableScriptScanning"; Value = "0" }

    $Path = "Software\Policies\Microsoft\Windows Defender\Scan"
        @{ registryPath = "$Path"; Name = "DisableRemovableDriveScanning"; Value = "0" }

    $Path = "Software\Policies\Microsoft\Windows Defender\Spynet"
        @{ registryPath = "$Path"; Name = "DisableBlockAtFirstSeen"; Value = "0" }
        @{ registryPath = "$Path"; Name = "SpynetReporting"; Value = "2" }
        @{ registryPath = "$Path"; Name = "SubmitSamplesConsent"; Value = "1" }

    $Path = "Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASRt"
        @{ registryPath = "$Path"; Name = "ExploitGuard_ASR_Rules"; Value = "1" }

    $Path = "Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules"
        @{ registryPath = "$Path"; Name = "26190899-1602-49e8-8b27-eb1d0a1ce869"; Value = "1" }
        @{ registryPath = "$Path"; Name = "5beb7efe-fd9a-4556-801d-275e5ffc04cc"; Value = "1" }
        @{ registryPath = "$Path"; Name = "3b576869-a4ec-4529-8536-b80a7769e899"; Value = "1" }
        @{ registryPath = "$Path"; Name = "75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84"; Value = "1" }
        @{ registryPath = "$Path"; Name = "7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c"; Value = "1" }
        @{ registryPath = "$Path"; Name = "92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B"; Value = "1" }
        @{ registryPath = "$Path"; Name = "9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2"; Value = "1" }
        @{ registryPath = "$Path"; Name = "b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4"; Value = "1" }
        @{ registryPath = "$Path"; Name = "be9ba2d9-53ea-4cdc-84e5-9b1eeee46550"; Value = "1" }
        @{ registryPath = "$Path"; Name = "c1db55ab-c21a-4637-bb3f-a12568109d35"; Value = "1" }
        @{ registryPath = "$Path"; Name = "d3e037e1-3eb8-44c8-a917-57927947596d"; Value = "1" }
        @{ registryPath = "$Path"; Name = "d4f940ab-401b-4efc-aadc-ad5f3c50688a"; Value = "1" }
        @{ registryPath = "$Path"; Name = "e6db77e5-3df2-4cf1-b95a-636979351e5b"; Value = "1" }



)
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



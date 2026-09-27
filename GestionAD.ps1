Import-Module ActiveDirectory

do {
    Clear-Host
    Write-Host "--- MENU GESTION AD ---"
    Write-Host "1. Informacion del dominio"
    Write-Host "2. Crear OU"
    Write-Host "3. Crear grupo"
    Write-Host "4. Crear usuario"
    Write-Host "5. Salir"
    
    $opcion = Read-Host "Elige una opcion (1-5)"

    switch ($opcion) {
        "1" {
            Write-Host "Nombre de equipo: $env:COMPUTERNAME"
            Write-Host "Nombre del dominio: $((Get-ADDomain).DNSRoot)"
            Write-Host "Numero de OUs: $((Get-ADOrganizationalUnit -Filter *).Count)"
            Write-Host "Numero de grupos: $((Get-ADGroup -Filter *).Count)"
            Write-Host "Numero de usuarios: $((Get-ADUser -Filter *).Count)"
            Pause
        }
        "2" {
            $nombreOU = Read-Host "Introduce el nombre de la unidad organizativa"
            $pathDominio = (Get-ADDomain).DistinguishedName
            New-ADOrganizationalUnit $nombreOU -Path $pathDominio
            Write-Host "La unidad organizativa '$nombreOU' se ha creado correctamente"
            Pause
        }
        "3" {
            $nombreGRUPO = Read-Host "Introduce el nombre de grupo"
            $ouDestino = Read-Host "Introduce la OU donde se creara el grupo"
            $dominioPath = (Get-ADDomain).DistinguishedName
            $pathGrupo = "OU=$ouDestino,$dominioPath"

            New-ADGroup $nombreGRUPO -GroupScope Global -GroupCategory Security -Path $pathGrupo
            Write-Host "El grupo '$nombreGRUPO' se ha creado correctamente en la OU '$ouDestino'."
            Pause
        }
        "4" {
            $nombre = Read-Host "Nombre de pila"
            $apellido = Read-Host "Apellido"
            $user = Read-Host "Nombre de inicio de sesion (sAMAccountName)"
            $ouDestino = Read-Host "OU donde se ubicara el usuario"
            $grupoDestino = Read-Host "Grupo al que pertenecera"
            $pass = Read-Host "Contrasena inicial" -AsSecureString

            $dominioPath = (Get-ADDomain).DistinguishedName
            $pathUser = "OU=$ouDestino,$dominioPath"

            New-ADUser -Name "$nombre $apellido" -GivenName $nombre -Surname $apellido -SamAccountName $user -UserPrincipalName "$user@$((Get-ADDomain).DNSRoot)" -Path $pathUser -AccountPassword $pass -Enabled $true -ChangePasswordAtLogon $true

            Add-ADGroupMember $grupoDestino -Members $user

            Write-Host "Usuario '$user' creado en '$ouDestino', asignado al grupo '$grupoDestino' y obligado a cambiar clave en primer inicio."
            Pause
        }
        "5" {
            Write-Host "Saliendo de la aplicacion..."
        }
    }
} while ($opcion -ne "5")

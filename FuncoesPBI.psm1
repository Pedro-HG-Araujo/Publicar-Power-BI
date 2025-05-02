if (-not (Get-Module -ListAvailable -Name MicrosoftPowerBIMgmt)) {
    Write-Host "Modulo MicrosoftPowerBIMgmt nao encontrado. Instalando..."
    try {
        Install-Module -Name MicrosoftPowerBIMgmt -Scope AllUsers -Force -AllowClobber
        Write-Host "Modulo instalado com sucesso."
    }
    catch {
        Write-Error "Erro ao instalar o modulo MicrosoftPowerBIMgmt: $_"
        exit
    }
}

Import-Module MicrosoftPowerBIMgmt -ErrorAction Stop

. "$PSScriptRoot\FuncoesPBI\Publicador PowerBI.ps1"
. "$PSScriptRoot\FuncoesPBI\Extrator PowerBI.ps1"
Export-ModuleMember -Function Publicacao, Exportacao
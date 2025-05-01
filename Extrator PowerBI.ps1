# Verifica se o módulo MicrosoftPowerBIMgmt está instalado
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

# Autenticação no serviço Power BI
Connect-PowerBIServiceAccount
$jsonFilePath = "ArquivosPBIX.json"
$Json = Get-Content -Path $jsonFilePath -Encoding UTF8 | ConvertFrom-Json
foreach($dados in $Json) {
    $workspaceName = $dados.WorkpaceOrigem
    $reportName = $dados.ReportOrigem
    $reportDestino = if(![String]::IsNullOrWhiteSpace($dados.reportDestino)){$dados.reportDestino}else{$reportName}
    $path = $dados.PastaDestino
    $outFilePath = "$path$reportDestino.pbix"

    # Buscar o workspace pelo nome
    $workspace = Get-PowerBIWorkspace -Name $workspaceName
    if (-not $workspace) {
        Write-Error "Workspace '$workspaceName' nao encontrado."
        exit
    }
    # Buscar o relatório dentro do workspace
    $report = Get-PowerBIReport -WorkspaceId $workspace.Id | Where-Object { $_.Name -eq $reportName }
    if (-not $report) {
        Write-Error "Relatorio '$reportName' nao encontrado no workspace '$workspaceName'."
        exit
    }
    # Exportar o relatório para .pbix
    try {
        if (-Not (Test-Path -Path $path)) {
            New-Item -ItemType Directory -Path $path | Out-Null
        }
        if (Test-Path $outFilePath) {
            Remove-Item -Path $outFilePath -Force
        }
        Export-PowerBIReport -Id $report.Id -OutFile $outFilePath -WorkspaceId $workspace.Id
        Write-Host "Relatorio exportado com sucesso para: $outFilePath"
    }
    catch {
        Write-Error "Erro ao exportar o relatorio: $_"
    }
}
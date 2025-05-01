Import-Module MicrosoftPowerBIMgmt -ErrorAction Stop
Connect-PowerBIServiceAccount
$jsonFilePath = "Teste.json"
$Json = Get-Content -Path $jsonFilePath -Encoding UTF8 | ConvertFrom-Json
foreach($dados in $Json) {
    $workspaceName = $dados.WorkpaceDestino
    $reportName = $dados.ReportOrigem
    $reportDestino = if(![String]::IsNullOrWhiteSpace($dados.reportDestino)){$dados.reportDestino}else{$reportName}
    $path = $dados.PastaDestino
    $FilePath = "$path$reportDestino.pbix"

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
    # Publicar o arquivo .pbix
    New-PowerBIReport -Path $FilePath -Name $reportDestino -WorkspaceId $workspace.Id -ConflictAction CreateOrOverwrite

}

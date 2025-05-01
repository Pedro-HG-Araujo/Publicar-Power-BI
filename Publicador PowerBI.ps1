Import-Module MicrosoftPowerBIMgmt -ErrorAction Stop

Connect-PowerBIServiceAccount

$jsonFilePath = "ArquivosPBIX.json"
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
    # Publicar o arquivo .pbix
    try {
    New-PowerBIReport -Path $FilePath -Name $reportDestino -WorkspaceId $workspace.Id -ConflictAction CreateOrOverwrite
    Write-Host "Relatorio $reportDestino foi publicado com sucesso para $workspaceName"
    }
    catch {
        Write-Error "Erro ao publicar o relatorio $reportDestino : $_"
    }

}

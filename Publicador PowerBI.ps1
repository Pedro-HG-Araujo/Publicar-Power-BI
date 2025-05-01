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

    
}

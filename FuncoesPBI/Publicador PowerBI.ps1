. "$PSScriptRoot\Funcoes.ps1"

function Publicacao {
    Param (
        [String]$Manual,
        [String]$jsonFilePath
    )
    

    if ($Manual -ne "Sim" -and $Confirmacao -ne "Nao") {
        Write-Error "Defina o 'Manual' como 'Sim' ou 'Nao'."
        exit
    }
    if ([string]::IsNullOrWhiteSpace($jsonFilePath)) {
    Write-Error "O parâmetro 'jsonFilePath' não foi definido."
    exit 
    }

    if ($Manual = "Sim") {
        Write-Host "`n --- Faca Login no Servico de DESTION no Pop-Up --- `n"
        Connect-PowerBIServiceAccount

        $Json = Get-Content -Path $jsonFilePath -Encoding UTF8 | ConvertFrom-Json
        foreach($dados in $Json) {
            $workspaceName = $dados.WorkpaceDestino
            $reportName = $dados.ReportOrigem
            $reportDestino = if(![String]::IsNullOrWhiteSpace($dados.reportDestino)){$dados.reportDestino}else{$reportName}
            $path = $dados.PastaDestino
            $FilePath = "$path$reportDestino.pbix"

            # Clear-Host
            # Write-Host "Publicando o Relatório $reportDestino no Workspace $workspaceName"
            Publicar-Pbix-Interacao -workspaceName $workspaceName -FilePath $FilePath -reportDestino $reportDestino
            Start-Sleep -Seconds 2
        }
    } else {
        Write-Host "aaaaa"
    }
}
. "$PSScriptRoot\Funcoes.ps1"

function Exportacao {
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

    if ($Manual = "Sim") { ## Extrai com Interação em tela para Login
        Write-Host "`n --- Faca Login no Servico de ORIGEM no Pop-Up --- `n"
        Connect-PowerBIServiceAccount

        $Json = Get-Content -Path $jsonFilePath -Encoding UTF8 | ConvertFrom-Json
        foreach($dados in $Json) {
            $workspaceName = $dados.WorkpaceOrigem
            $reportName = $dados.ReportOrigem
            $reportDestino = if(![String]::IsNullOrWhiteSpace($dados.reportDestino)){$dados.reportDestino}else{$reportName}
            $path = $dados.PastaDestino
            $outFilePath = "$path$reportDestino.pbix"

            Exportar-Pbix-Interacao -workspaceName $workspaceName -reportName $reportName -path $path -outFilePath $outFilePath

        }
    } else { ## To Do: Extrair usando Tenant
        Write-Host "aaaaa"
    }

}




   # if (![String]::IsNullOrWhiteSpace($dados.TenantOrigem)){
    #     $cliente = $dados.TenantOrigem
    #     $tenantId = $clientes.$cliente.TenantId
    #     $clientId = $clientes.$cliente.clientId
    #     $secret = $clientes.$cliente.clientSecret
    #     $scope = "https://analysis.windows.net/powerbi/api/.default"
    #     $authority = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

    #     $body = @{
    #         grant_type = "client_credentials"
    #         client_id  = $clientId
    #         client_secret = $secret
    #         scope = $scope
    #     }

    #     $response = Invoke-RestMethod -Method Post -Uri $authority -Body $body
    #     $token = $response.access_token

    # }
. "$PSScriptRoot\Funcoes.ps1"

function Publicacao {
    Param (
        [String]$Manual,
        [String]$TipoAcesso,
        [String]$Usuario,
        [String]$Senha,
        [String]$jsonFilePath,
        [String]$jsonFilePathTenant
    )

    if ($Manual -ne "Sim" -and $Manual -ne "Nao") {
        Write-Error "Defina o 'Manual' como 'Sim' ou 'Nao'."
        exit
    }
    if ($Manual -eq "Nao" -and $TipoAcesso -ne "T" -and $TipoAcesso -ne "U") {
        Write-Error "Defina o parametro 'TipoAcesso' como 'T' - Tenant ou 'U' - User"
    }
    if ([string]::IsNullOrWhiteSpace($jsonFilePath)) {
    Write-Error "O parâmetro 'jsonFilePath' não foi definido."
    exit 
    }

    if ($Manual -eq "Sim") {
        Write-Host "`n --- Faca Login no Servico de DESTINO no Pop-Up --- `n"
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
    }  else {
        if ($TipoAcesso -eq "U") {
            if ([string]::IsNullOrWhiteSpace($Usuario) -and [string]::IsNullOrWhiteSpace($Senha)) {
                Write-Error "Defina os parametros de usuario e senha"
            }
            $SenhaSegura = ConvertTo-SecureString $Senha -AsPlainText -Force
            $Credencial = New-Object System.Management.Automation.PSCredential($Usuario,$SenhaSegura)
            Connect-PowerBIServiceAccount -Credential $Credencial

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
            if ([string]::IsNullOrWhiteSpace($jsonFilePathTenant)) {
                Write-Error "O parâmetro 'jsonFilePathTenant' não foi definido."
                exit 
            }
            Write-Host "Iniciando processo de publicacao com Tenant em Json"
            $Json = Get-Content -Path $jsonFilePath -Encoding UTF8 | ConvertFrom-Json
            $jsonTenant = Get-Content -Path $jsonFilePathTenant -Encoding UTF8 -Raw | ConvertFrom-Json
            foreach($dados in $Json) {
                $workspaceName = $dados.WorkpaceDestino
                $reportName = $dados.ReportOrigem
                $reportDestino = if(![String]::IsNullOrWhiteSpace($dados.reportDestino)){$dados.reportDestino}else{$reportName}
                $path = $dados.PastaDestino
                $FilePath = "$path$reportDestino.pbix"

                if(![String]::IsNullOrWhiteSpace($dados.TenantDestino)){
                    $cliente_u = $dados.TenantDestino
                    $clienteDestino = $jsonTenant | Where-Object { $_.Cliente -eq $cliente_u}
                    if (-not $clienteDestino) {
                        Write-Error "Credenciais nao definidas em Json de Paramatros do Tenant para o Cliente $cliente_u"
                        exit 
                    }
                    Write-Host "Cliente Destino: $cliente_u"

                    $clientId = $clienteDestino.Credencial.clientId
                    $tenantId = $clienteDestino.Credencial.TenantId
                    $secret = $clienteDestino.Credencial.clientSecret
                    $scope = "https://analysis.windows.net/powerbi/api/.default"
                    $authority = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

                    $body = @{
                        grant_type = "client_credentials"
                        client_id  = $clientId
                        client_secret = $secret
                        scope = $scope
                    }
                    $response = Invoke-RestMethod -Method Post -Uri $authority -Body $body
                    $token = $response.access_token

                    Publicar-Pbix-Tenat -FilePath $FilePath -reportDestino $reportDestino -workspaceName $workspaceName -token $token

                } else {Write-Error "Tenant Nao Definido"}
                Start-Sleep -Seconds 3
            }
        }
    }
}
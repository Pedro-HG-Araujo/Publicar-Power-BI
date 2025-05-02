. "$PSScriptRoot\Funcoes.ps1"

function Exportacao {
    Param (
        [String]$Manual,
        [String]$TipoAcesso,
        [String]$Usuario,
        [String]$Senha,
        [String]$jsonFilePath
    )

    if ($Manual -ne "Sim" -and $Manual -ne "Nao") {
        Write-Error "Defina o parametro 'Manual' como 'Sim' ou 'Nao'."
        exit
    }
    if ($Manual -eq "Nao" -and $TipoAcesso -ne "T" -and $TipoAcesso -ne "U") {
        Write-Error "Defina o parametro 'TipoAcesso' como 'T' - Tenant ou 'U' - User"
    }
    if ([string]::IsNullOrWhiteSpace($jsonFilePath)) {
        Write-Error "O parâmetro 'jsonFilePath' não foi definido."
        exit 
    }

    if ($Manual -eq "Sim") { ## Extrai com Interação em tela para Login
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
            Start-Sleep -Seconds 2
        }
    } else {
        if ($TipoAcesso -eq "U") {
            if ([string]::IsNullOrWhiteSpace($Usuario) -and [string]::IsNullOrWhiteSpace($Senha)) {
                Write-Error "Defina os parametros de usuario e senha"
            }
            $SenhaSegura = ConvertTo-SecureString $Senha -AsPlainText -Force
            $Credencial = New-Object System.Management.Automation.PSCredential($Usuario,$SenhaSegura)
            Connect-PowerBIServiceAccount -Credential $Credencial

            $Json = Get-Content -Path $jsonFilePath -Encoding UTF8 | ConvertFrom-Json
                foreach($dados in $Json) {
                    $workspaceName = $dados.WorkpaceOrigem
                    $reportName = $dados.ReportOrigem
                    $reportDestino = if(![String]::IsNullOrWhiteSpace($dados.reportDestino)){$dados.reportDestino}else{$reportName}
                    $path = $dados.PastaDestino
                    $outFilePath = "$path$reportDestino.pbix"

                    Exportar-Pbix-Interacao -workspaceName $workspaceName -reportName $reportName -path $path -outFilePath $outFilePath
                    Start-Sleep -Seconds 2
                }
        } else {
            Write-Host "aaaaaaa AINDA NAO FUI PREPARADO PARA ISSO AAAAAAAA tenta sem tenant ai, nmrl. `n Obrigado pela compreensao"
        }
        
    }

}
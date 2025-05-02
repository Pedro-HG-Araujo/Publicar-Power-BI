function Publicar-Pbix-Tenat {
    param (
        [string]$FilePath,
        [string]$reportDestino,
        [string]$workspaceName,
        [string]$token
    )
    $headers = @{ Authorization = "Bearer $token" }
    $groups = Invoke-RestMethod -Method Get -Uri "https://api.powerbi.com/v1.0/myorg/groups" -Headers $headers
    $workspace = $groups.value | Where-Object { $_.name -eq $workspaceName }
    if (-not $workspace){
        Write-Error "O Workspace $workpaceName nao foi encontrado."
        Exit
    }
    
    $groupId = $workspace.id
    $uploadUri = "https://api.powerbi.com/v1.0/myorg/groups/$groupId/imports?datasetDisplayName=$reportDestino&nameConflict=CreateOrOverwrite"

    # Ler o PBIX
    $pbixBytes = [System.IO.File]::ReadAllBytes($FilePath)

    # Criar o conteúdo HTTP
    $byteArrayContent = [System.Net.Http.ByteArrayContent]::new($pbixBytes)
    $byteArrayContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse("application/octet-stream")

    $multipartContent = [System.Net.Http.MultipartFormDataContent]::new()
    $multipartContent.Add($byteArrayContent, "file", [System.IO.Path]::GetFileName($FilePath))

    #Requisicao HTTP
    $request = [System.Net.Http.HttpRequestMessage]::new("Post", $uploadUri)
    $request.Headers.Add("Authorization", "Bearer $token")
    $request.Content = $multipartContent

    $client = [System.Net.Http.HttpClient]::new()
    $response = $client.SendAsync($request).Result

    if ($response.IsSuccessStatusCode) {
        Write-Host "Publicacao de '$reportDestino' concluida com sucesso!"
    } else {
        Write-Error "Falha ao publicar '$reportDestino': $($response.StatusCode)"
        Write-Host $response.Content.ReadAsStringAsync().Result
    }
}

function Publicar-Pbix-Interacao {
    param (
        [String]$workspaceName,
        [String]$FilePath,
        [String]$reportDestino
    )

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

# function Exportar-Pbix-Tenant {
#     param (

#     )

# }

function Exportar-Pbix-Interacao {
    param (
        [String]$workspaceName,
        [String]$reportName,
        [String]$path,
        [String]$outFilePath
    )

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
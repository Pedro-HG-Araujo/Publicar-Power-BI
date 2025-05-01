# Exportar Relatórios
Write-Host "`n--- Iniciando processo de exportacao ---`n"
Write-Host "`n--- Realize Login no Cliente ---`n"
Start-Sleep 5
try {
    & ".\Extrator PowerBI.ps1"
}
catch {
    Write-Error "Erro ao exportar relatórios: $_"
}

#Publicar Relatórios Exportados
Write-Host "`n--- Iniciando processo de Publicacao ---`n"
Write-Host "`n--- Realize Login na sua hospedagem ---`n"
Start-Sleep 5
try {
    & ".\Publicador PowerBI.ps1"
}
catch {
    Write-Error "Erro ao publicar relatórios: $_"
}

Write-Host "`n--- Processo concluido com sucesso! ---`n"
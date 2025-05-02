$moduleName = "FuncoesPBI"
$modulePath = "C:\Program Files\WindowsPowerShell\Modules\$moduleName"
$sourcePath = [System.IO.Path]::GetDirectoryName([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)  # pasta onde estão seu .psm1 e .ps1

# Verifica permissão de administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
     [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Execute como administrador."
    Start-Sleep -Seconds 5
    exit
}

# Cria pasta do módulo se não existir
if (-not (Test-Path $modulePath)) {
    New-Item -ItemType Directory -Path $modulePath -Force | Out-Null
}

# Copia os arquivos .psm1 e .ps1
Write-Host "Copiando arquivos .psm1 e .ps1 para $modulePath..."
Write-Host "$sourcePath"
Copy-Item "$sourcePath\$moduleName" -Destination $modulePath -Recurse -Force
Copy-Item "$sourcePath\*.psm1" -Destination $modulePath -Force

# Cria o manifesto
New-ModuleManifest -Path "$modulePath\$moduleName.psd1" `
    -RootModule "$moduleName.psm1" `
    -Author "Pedro Araujo" `
    -Description "Módulo para publicação/exportação de relatórios Power BI" `
    -FunctionsToExport @('Publicacao', 'Exportacao') `
    -PowerShellVersion '5.1'

Write-Host "`n Módulo '$moduleName' instalado com sucesso!"
Start-Sleep -Seconds 5

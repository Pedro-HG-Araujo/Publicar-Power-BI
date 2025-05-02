# Módulo FuncoesPBI

Este pacote instala e configura o módulo `FuncoesPBI` para automatização de publicações e exportações de relatórios Power BI via PowerShell.

## 📦 Conteúdo do Pacote

- `Instalador.exe` – Executável responsável por instalar o módulo no PowerShell.  
- Pasta `FuncoesPBI` com os arquivos:
  - `FuncoesPBI.psm1`
  - `Funcoes.ps1`
  - `Publicador PowerBI.ps1`
  - `Extrator PowerBI.ps1`

---

## ✅ Como Instalar

1. **Extraia o `.zip`** em uma pasta local, como por exemplo: `C:\PowerBIInstaller\`
2. **Execute como Administrador**:
  - Clique com o botão direito em `Instalador.exe`
  - Selecione **Executar como administrador**
3. O módulo será instalado em: `C:\Program Files\WindowsPowerShell\Modules\FuncoesPBI\`

## 🧪 Testando a Instalação

Abra o PowerShell e execute:

```powershell
Import-Module FuncoesPBI
Get-Command -Module FuncoesPBI
```
Isso deve listar as funções `Publicacao` e `Exportacao`.

## 🚀 Exemplos de Uso

1. Exportacao e Publicação Manuais
```powershell
Exportacao -Manual "Sim" -jsonFilePath "C:\caminho\ArquivosPBIX.json"
Publicacao -Manual "Sim" -jsonFilePath "C:\caminho\ArquivosPBIX.json"
```
  Isso fará aparecer um pop-up para preencher as credenciais de acesso da origem/destino

2. Exportacao e Publicação Não Manual
```powershell
Exportacao -Manual "Nao" -jsonFilePath "C:\caminho\ArquivosPBIX.json" -TipoAcesso "U" -Usuario "Usuario" -Senha "Senha"
Publicacao -Manual "Nao" -jsonFilePath "C:\caminho\ArquivosPBIX.json" -TipoAcesso "T" -jsonFilePathTenant "C:\caminho\ClientesPBIX.json"
```

## ℹ️ Requisitos

  - `Windows PowerShell 5.1`
  - `Permissão de administrador para instalação`
  - `Power BI Service (com permissões de publicação/exportação)`





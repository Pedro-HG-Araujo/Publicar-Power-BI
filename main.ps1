Import-Module .\FuncoesPBI.psm1

# Exemplos de uso
# powershell -ExecutionPolicy Bypass -File

# Exportacao -Manual "Sim" -jsonFilePath "ArquivosPBIX.json"
# Exportacao -Manual "Nao" -jsonFilePath "ArquivosPBIX.json" -TipoAcesso "U" -Usuario "" -Senha ""

# Publicacao -Manual "Sim" -jsonFilePath "ArquivosPBIX.json"
# Publicacao -Manual "Nao" -jsonFilePath "ArquivosPBIX.json" -TipoAcesso "U" -Usuario "" -Senha ""
# Publicacao -Manual "Nao" -jsonFilePath "ArquivosPBIX.json" -TipoAcesso "T" -jsonFilePathTenant "ClientesPBIX.json"


Publicacao -Manual "Nao" -TipoAcesso "T" -jsonFilePath "Teste.json" -jsonFilePathTenant "clientes.json"
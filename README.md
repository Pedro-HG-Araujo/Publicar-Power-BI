# 🚀📊Exportar e Publicar Relatórios do Power BI (.pbix)
## Essa solução visa facilitar o processo de exportação de arquivos pbix e também a publicação.
Neste repositório é possível encontrar os seguintes arquivos:  
\ArquivosPBIX.json  
\Extrator PowerBI.ps1  
\Publicador PowerBI.ps1  
\main.ps1  

## "ArquivosPBIX.json" 
Mapeia os relatórios que deve ser baixados/publicados  

Os parâmetros essenciais:  
WorkpaceOrigem - Definido com o nome do Workspace em que o relatório que será baixado se encontra  
WorkpaceDestino - Definido com o nome do Workspace em que o relatório será publicado  
ReportOrigem - Definido com o nome do Report que está no Workspace e/ou será publicado  
PastaDestino - Caminho em que o arquivo deve ser baixado e/ou lido para a publicação  
ReportDestino - (Opcional) - Caso queira que o arquivo seja baixado com um nome diferente do de origem, o arquivo será gravado com o nome definido neste campo    

## Extração
Na etapa de extração, serão verificados a existência do Workspace e Relatório definidos.
Se o campo ReportDestino estiver preenchido, o arquivo será exportado com o nome definido neste parâmetro no caminho também definido no json.

## Publicação
Na etapa de publicação, será verificada a existência do Workspace de destino e o relatório será publicado conforme o nome 
definido no json

# Execução
Ao executar o main.ps1, será solicitado o login para a origem e a extração será inicializada. 
Após isso, será solicitado o login para o destino e então será realizada a publicação dos relatórios.

Tanto o Extrator quanto o Publicador podem ser utilizados de forma independentes. 
O arquivo "main.ps1" foi criado apenas para facilitar a execução das duas etapas de forma ordenada

#include 'totvs.ch'
#include 'parmtype.ch'
//#include 'totvs.framework.treports.integratedprovider.th'
//#include 'topconn.ch'


user function GerarRelatorio()

local cQuery 
local oQuery
local oRegistro

// Define a consulta SQL
cQuery := "SELECT F1_FILIAL, F1_DOC, F1_SERIE, F1_EMISSAO, E2_VENCREA, E2_DTBORDE, E2_BAIXA, F1_FORNECE, F1_LOJA, A2_CGC, A2_NOME, D1_COD, D1_DESCRI, D1_VALBRUT, D1_VALIRF, D1_VALPIS, D1_VALCOFI, D1_VALCSLL FROM SF1010 INNER JOIN SA2010 ON ... " 

// Executa a consulta SQL
oQuery := TQuery():New()
oQuery:ExecuteSql(cQuery)

// Inicia o relatório
REPORT FORM Relatorio FROM MEMVAR FIELDS FILIAL, DOC, SERIE, EMISSAO, VENCREA, DTBORDE, BAIXA, FORNECEDOR, LOJA, CNPJ, NOME_FORNEC, COD_ITEM, DESCRICAO, VALOR_BRUTO, VALOR_IRF, VALOR_PIS, VALOR_COFINS, VALOR_CSLL WHILE !oQuery:EOF()

   // Preenche os dados do relatório
   oRegistro := oQuery:RecNo()
   FILIAL := oQuery:FieldGet("F1_FILIAL")
   DOC := oQuery:FieldGet("F1_DOC")
   SERIE := oQuery:FieldGet("F1_SERIE")
   EMISSAO := oQuery:FieldGet("F1_EMISSAO")
   VENCREA := oQuery:FieldGet("E2_VENCREA")
   DTBORDE := oQuery:FieldGet("E2_DTBORDE")
   BAIXA := oQuery:FieldGet("E2_BAIXA")
   FORNECEDOR := oQuery:FieldGet("F1_FORNECE")
   LOJA := oQuery:FieldGet("F1_LOJA")
   CNPJ := oQuery:FieldGet("A2_CGC")
   NOME_FORNEC := oQuery:FieldGet("A2_NOME")
   COD_ITEM := oQuery:FieldGet("D1_COD")
   DESCRICAO := oQuery:FieldGet("D1_DESCRI")
   VALOR_BRUTO := oQuery:FieldGet("D1_VALBRUT")
   VALOR_IRF := oQuery:FieldGet("D1_VALIRF")
   VALOR_PIS := oQuery:FieldGet("D1_VALPIS")
   VALOR_COFINS := oQuery:FieldGet("D1_VALCOFI")
   VALOR_CSLL := oQuery:FieldGet("D1_VALCSLL")

   // Adiciona o registro ao relatório
   oQuery:Next()

END

// Fecha a consulta
oQuery:Close()

// Mostra o relatório
oRelatorio:Preview()

return

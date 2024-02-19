#include 'totvs.ch'
#INCLUDE 'topconn.ch'

/*/
{Protheus.doc} ESTAG010
@type user function
@author David
@since 01/02/2024
@version 1.0
@param
@notes: Relatorio com tela simples usando construtor de query
/*/

User Function ESTAG010
	
    Public cAlias := "ZA1"
 
    Private cCadastro := "Cadastro de Pessoas estag"

    Private aRotina     := { }

    AADD(aRotina, { "Pesquisar", "AxPesqui", 0, 1 })
    AADD(aRotina, { "Visualizar", "AxVisual"  , 0, 2 })
    AADD(aRotina, { "Incluir"      , "AxInclui"   , 0, 3 })
    AADD(aRotina, { "Alterar"     , "AxAltera"  , 0, 4 })
    AADD(aRotina, { "Excluir"     , "AxDeleta" , 0, 5 })
    AADD(aRotina, {  "Relatorio",      "U_TrptZA()",   0,6})
    AADD(aRotina, {  "NFornec",      "U_NOVO_FORNECEDOR",   0,3})

    dbSelectArea(cAlias)
    dbSetOrder(1)

    mBrowse(6, 1, 22, 75, cAlias)

return



User Function TrptZA()

    Local oReport
    //Local cAlias := getNextAlias()

    oReport:= Rptstrct(cAlias)

    oReport:PrintDialog()

Return



Static Function RPrint(oReport, cAlias)

    Local oSecao1 := oReport:Section(1)

    oSecao1:BeginQuery()

        BeginSQL Alias cAlias

            Select ZA1_COD, ZA1_DESC, ZA1_NOME, ZA1_DOB, ZA1_PESO
            FROM %Table:ZA1% ZA1
            WHERE D_E_L_E_T_ =''

        EndSQL
    oSecao1:EndQuery()
    oReport:SetMeter((cAlias)->(RecCount()))

    oSecao1:Print()

Return


Static Function Rptstrct(cAlias)

    Local cTitulo := "Estagiarios Ativos"
    Local cHelp := "Permite imprimir relatório de Estagiarios"
    Local oReport 
    Local oSection1

    // Instanciando a classe TReport
    oReport := TReport():New("RelTrep",cTitulo,/*pergunta*/,{|oReport|RPrint(oReport, cAlias)},cHelp)

    
    oSection1 := TRSection():New(oReport,"Estagiarios",{cAlias})

    
    TRCell():New(oSection1,"ZA1_COD",cAlias,"CODIGO")
    TRCell():New(oSection1,"ZA1_DESC",cAlias,"NOME COMPLETO")
    TRCell():New(oSection1,"ZA1_NOME",cAlias,"PRIMEIRO NOME")
    TRCell():New(oSection1,"ZA1_DOB",cAlias,"DATA DE NASCIMENTO")
    TRCell():New(oSection1,"ZA1_PESO",cAlias,"PESO")
    

Return(oReport)

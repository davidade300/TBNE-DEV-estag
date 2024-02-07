#include 'Totvs.ch'
#include 'TopConn.ch'

User Function TrptZA2()

    Local oReport
    Local cAlias := getNextAlias()

    oReport:=Rptstrct(cAlias)

    oReport:PrintDialog()

Return



Static Function RPrint1(oReport, cAlias)

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



Static Function Rptstrct1(cAlias)

    Local cTitulo := "Estagiarios Ativos"
    Local cHelp := "Permite imprimir relatório de Estagiarios"
    Local oReport 
    Local oSection1

    // Instanciando a classe TReport
    oReport := TReport():New("RelTrep",cTitulo,/*pergunta*/,{|oReport|RPrint(oReport, cAlias)},cHelp)

    //secao1
    oSection1 := TRSection():New(oReport,"Estagiarios",{cAlias})

    TRCell():New(oSection1,"ZA1_COD",cAlias,"CODIGO")
    TRCell():New(oSection1,"ZA1_DESC",cAlias,"NOME COMPLETO")
    TRCell():New(oSection1,"ZA1_NOME",cAlias,"PRIMEIRO NOME")
    TRCell():New(oSection1,"ZA1_DOB",cAlias,"DATA DE NASCIMENTO")
    TRCell():New(oSection1,"ZA1_PESO",cAlias,"PESO")


Return(oReport)

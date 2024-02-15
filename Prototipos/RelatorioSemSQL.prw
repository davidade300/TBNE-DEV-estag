#include 'totvs.ch'

/*/{Protheus.doc} RelatorioSemSQL
    (long_description)
    @type  Function
    @author David
    @since 13/02/2024
    @version 1.0
    /*/
User Function wSQLRel() 
    
    Local oReport := ReportDef()

    oReport:PrintDialog()

Return 

Static Function ReportDef()

    Local oReport 
    Local oSection1

    oReport := TReport():New('RelatorioSemSQL','Tabela de Estagiarios','',{|oReport| PrintReport()},'Tabela de Estagiarios')

    oSection1 := TRSection():New(oReport, 'Dados Gerais', {'ZA1'})

    //Celulas baseadas no dicionario não precisam de mais argumentos
    TRCell():New(oSection1,'ZA1_NOME','ZA1','PRIMEIRO NOME')
    TRCell():New(oSection1,'ZA1_IDADE','ZA1','IDADE')
    TRCell():New(oSection1,'ZA1_PESO','ZA1','PESO')
    TRCell():New(oSection1,'ZA1_DESC','ZA1','NOME COMPLETO')
    TRCell():New(oSection1,'ZA1_DOB','ZA1','DATA DE NASCIMENTO')

Return

User Function RPrint(oReport)

    Local oSecao1 := oReport:Section(1)

    oSecao1:init()
    oSecao1:PrintLine()

    ZA1->(DBGoTop())

    While !ZA1->(eof())
        oSecao1:PrintLine()
        Za1->(DBSkip())
    Enddo

    oSecao1:Finish()

    oReport:EndPage()

Return

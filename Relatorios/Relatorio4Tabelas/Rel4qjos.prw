#include 'totvs.ch'

/*/{Protheus.doc} Rel4qjos
Relatório utilizando as tabelas SF1, SD1, SA2, SB1
@type user function
@author DAVID
@since 21/02/2024
@version 1.0
                                    D1_DOC = F1_DOC
/*/
User Function Rel4qjos

    Private oReport

    ReportDef()

    Oreport:PrintDialog()

Return 

Static Function ReportDef()

    oReport := TReport():new('Rel4qjos','listagem de items por NF, Fornecedor e Data','',{|oReport| PrintReport(oReport)},'listagem de items por NF, Fornecedor e Data')
    
    oSection1 := TRsection():new(oReport, 'Cabeçalho',{'SF1','SA2'})

    TRCell():new(oSection1,'SF1_DOC','SF1')
    TRCell():new(oSection1,'SF1_SERIE','SF1')
    TRCell():new(oSection1,'SA2_NOME','SA2')    
    TRCell():new(oSection1,'SF1_EMISSAO','SF1')

    oSection2 := TRsection():new(oReport, 'Itens da nota',{'SD1','SB1'})

    TRCell():new(oSection2,'SD1_DOC','SD1')
    TRCell():new(oSection2,'SD1_COD','SD1')
    TRCell():new(oSection2,'SB1_DESC','SB1')    
    TRCell():new(oSection2,'SD1_QUANT','SD1')
    TRCell():new(oSection2,'SD1_VUNIT','SD1')
    TRCell():new(oSection2,'SD1_TOTAL','SD1')

Return
 
Static Function PrintReport(oReport)

    Local oSection1 := oReport:Section(1)
    Local oSection2 := oReport:Section(2)

    oSection1:init()
    oSection1:PrintLine()

    oSection2:Init()

    SF1->(DBSetOrder(1))
    SF1->(DBSeek(cSeek := xFilial('SF1')+SA2->A2_NOME))

    // ajeitar a logica, refaz essa mizera

    //loop externo (cabeçalho + fornecedor)
    While !SF1->(!eof() .AND. cSeek == SA2->(SF1_DOC+SF1_FORNECE))
        
        oSection1:PrintLine()
        SF1->(DBSeek(cSeek := xFilial('SF1')+SD1->D1_DOC))

        while !SF1->(!eof() .AND. cSeek == SF1->(F1_DOC+F1_FORNECE))

        oSection2:PrintLine()
        SD1->(DBSkip())
        Enddo
        SF1->(DBSkip())
    Enddo

    oSection1:Finish()
    oSection2:Finish()

    oReport:EndPage()

Return

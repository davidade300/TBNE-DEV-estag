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
    
    oSection1 := TRsection():new(oReport, 'Cabeçalho',{'SF1'})

    TRCell():new(oSection1,'F1_DOC','SF1')
    //TRCell():new(oSection1,'F1_SERIE','SF1')
    TRCell():new(oSection1,'A2_NOME','SA2')
    TRCell():new(oSection1,'F1_FORNECE','SF1')    
    TRCell():new(oSection1,'F1_EMISSAO','SF1')
    //TRFunction():new(oSection1:cell('D1_TOTAL'),,"SUM",,,,,,.F.,.T.)

    oSection2 := TRsection():new(oReport, 'Itens da nota',{'SD1'})

    TRCell():new(oSection2,'D1_ITEM','SD1')
    TRCell():new(oSection2,'D1_COD','SD1')
    TRCell():new(oSection2,'B1_DESC','SB1')    
    TRCell():new(oSection2,'D1_QUANT','SD1')
    TRCell():new(oSection2,'D1_VUNIT','SD1')
    TRCell():new(oSection2,'D1_TOTAL','SD1')
    TRFunction():new(oSection2:cell('D1_TOTAL'),,"SUM",,,,,.T.) 

Return
 
Static Function PrintReport(oReport)

    

    Local oSection1 := oReport:Section(1)
    Local oSection2 := oReport:Section(2)
    
    SF1->(DBSetOrder(1)) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO                                                                                                            
  

    SD1->(DBGoTop())
    SF1->(DBGoTop())
    
     while SF1->(!eof())

        Posicione("SA2",1,Xfilial("SA2")+SF1->F1_FORNECE,"A2_Nome")//A2_FILIAL+A2_COD+A2_LOJA                                                                                                                                        

        oSection1:init()    
        oSection1:PrintLine()
        oSection1:Finish()

        oSection2:init()

        

        Posicione("SD1",1,Xfilial("SD1")+SF1->F1_DOC,"D1_DOC") //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM                                                                                                           

        while SD1->(!eof()) .And. (SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)) 

            Posicione("SB1",1,Xfilial("SB1")+SD1->D1_COD,"B1_DESC")
            
            oSection2:PrintLine()                

            SD1->(DbSkip())
                
        enddo


        oSection2:Finish()

        SF1->(DbSkip())

            
    enddo

    oReport:EndPage()

Return

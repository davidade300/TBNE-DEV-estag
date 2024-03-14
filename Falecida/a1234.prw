#include 'totvs.ch'

/*/{Protheus.doc} NICE02
(long_description)
@type user function
@author user
@since 13/03/2024
@version 1.0
/*/
User Function a1234()
    rpcsetenv("99", "01")
    Local oReport 
    Local cAlias := 'ZB1'

    oReport := RptStruc(cAlias)

    oReport:printDialog()
    rpcclearenv()
Return

/*/{Protheus.doc} RptStruc
    (long_description)
    @type  Static Function
    @author user
    @since 13/03/2024
    @version 1.0
/*/
Static Function RptStruc(cAlias)

    Local cTitulo := 'Prestação de contas'
    Local cHelp   := 'Permite imprimir um relatorio de todos os registros de viajens'
    Local oReport
    Local oSection1

    oReport   := TReport():New('TRPT001', cTitulo,/*Pergunta*/,{|oReport|rPrint(oReport, cAlias)},cHelp)

    oSection1 := TRSection():New(oReport, 'Viajens', {cAlias})
 
    TRCell():New(oSection1, 'ZB1_NOMSOL', cAlias, "Nome.Solicitante")  
    TRCell():New(oSection1, 'ZB1_ESTORI', cAlias, "Estado de origem")   
    TRCell():New(oSection1, 'ZB1_ESTDES', cAlias, "Estado destino")   
    TRCell():New(oSection1, 'ZB1_CIDDES', cAlias, "Cidade destino")   
    TRCell():New(oSection1, 'ZB1_DTIDA' , cAlias, "Data ida") 
    TRCell():New(oSection1, 'ZB1_DTRETO', cAlias, "Data retorno")
    TRCell():New(oSection1, 'ZB1_DIASVG', cAlias, "Dias de viagem")  
    TRCell():New(oSection1, 'ZB1_VLRPRE', cAlias, "Valor prestação")       
Return (oReport)

/*/{Protheus.doc} rPrint
    (long_description)
    @type  Static Function
    @author user
    @since 13/03/2024
    @version 1.0
/*/
Static Function rPrint(oReport, cAlias)

    local oSecao1 := oReport:Section(1)
    //Local cUserCod := posicione("ZB1",1,xFilial("ZB1")+ZB1->(ZB1_NOMSOL),"ZB1_CODSOL")
    ZB1->(DBSetOrder(1)) 
    ZB1->(DBGoTop())

   posicione("ZB1",1,xFilial("ZB1")+SYS_USR->(RETCODUSR()),"ZB1_CODSOL")
   IF RETCODUSR() != GETMV('MZ_APRPC')
    
        While ZB1->(!Eof()) //.AND. RETCODUSR() == posicione("ZB1",1,xFilial("ZB1")+ZB1->(ZB1_NOMSOL),"ZB1_CODSOL")
            oSecao1:Init()
            oSecao1:printLine()
            oSecao1:Print()
            ZB1->(DBSkip(1))
        Enddo

        oSecao1:Finish()
    Else
        oSecao1:Init()
        oSecao1:Print()
        oSecao1:Finish()
   EndIF

    oSecao1:SetMeter((cAlias)->(RecCount()))

Return

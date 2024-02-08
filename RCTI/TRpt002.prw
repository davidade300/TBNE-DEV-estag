#include 'Totvs.ch'
#include 'TopConn.ch'

User Function Trpt002()

    Local oReport := Nil
    Local cPerg := Padr("TRPT002",10)

    pergunte(cPerg,.F.) //busca no sx1 uma pergunta com o nome da cPerg
    // o .F. indica que a pergunta aparecerá em ações relacionadas 
    //  e não direto na tela do relatorio

    oReport := Rstrct0(cPerg)
    oReport:PrintDialog()
Return

Static Function RPrint(oReport)

    Local oSection1 := oReport:Section(1)
    Local oSection2 := oReport:Section(2)
    local cNumEst := ""
    local cQuery := ""

    cQuery += "SELECT ZA1_COD, ZA1_DESC, ZA1_NOME, ZA1_DOB, ZA1_IDADE, ZA1_PESO "
    cQuery += "FROM ZA1990 "
    cQuery += "WHERE D_E_L_E_T_ = '' AND ZA1_IDADE = '"+MV_PAR01+"' ;"

    //VERIFICA SE A TABELA JÁ ESTÁ ABERTA.

    If select("TEMP") <> 0
        DbSelectArea("TEMP")
        DbCloseArea()
    Endif

    // envia dados para o banco criando a tabela temporaria TEMP
    TCQUERY cQuery NEW ALIAS "TEMP"

    DbSelectArea("TEMP")
    TEMP->(dbGoTop())

    oReport:SetMeter(TEMP->(LastRec()))

    while !eof()
        If oReport:Cancel()
            Exit
        Endif

        //Iniciando a primeira seção(oSection1)
        oSection1:Init()
        oReport:incMeter()

        cNumEst := TEMP->ZA1_COD
        IncProc("Imprimindo estagiario" + Alltrim(TEMP->ZA1_COD))

        // Imprimindo a primeira secao
        oSection1:Cell("ZA1_COD"):SetValue(TEMP->ZA1_COD)
        oSection1:Cell("ZA1_NOME"):SetValue(TEMP->ZA1_NOME)
        oSection1:PrintLine()

        // iniciando a impressão da seção2(oSection2)
        oSection2:Init()

        //verifica se o codigo do estagiario é o mesmo
        while TEMP->ZA1_COD == cNumEst

            oReport:incMeter()
            IncProc("Imprimindo estagiarios..." + Alltrim(TEMP->ZA1_COD))

            oSection2:Cell("ZA1_DESC"):SetValue(TEMP->ZA1_DESC)
            oSection2:Cell("ZA1_IDADE"):SetValue(TEMP->ZA1_IDADE)
            oSection2:PrintLine()

            TEMP->(dbSkip())

        Enddo

        oSection2:Finish()
        oReport:ThinLine()

        oSection1:Finish()

    Enddo

Return

Static Function Rstrct0(cNome)
    Local oReport := Nil
    Local oSection1 := Nil
    Local oSection2 := Nil

    oReport := TReport():New(cNome,"Relatorio de estagiarios",cNome,{|oReport|RPrint(oReport)},"Descrição do Help")

    //Definindo a orientação como retrato
    oReport:SetPortrait() 

    oSection1 := TRsection():New(oReport,"Estagiarios",{"ZA1"},NIL,.F.,.T.)
    TRCell():New(oSection1,"ZA1_COD","TEMP","Codigo","@!",40) 
    TRCell():New(oSection1,"ZA1_Nome","TEMP","Nome","@!",40)

    oSection2 := TRSection():New(oReport,"Dados dos Estagiarios",{"ZA1"},NIL,.F.,.T.)
    TRCell():New(oSection2,"ZA1_DESC","TEMP","Nome Completo","@!", 100)
    TRCell():New(oSection2,"ZA1_IDADE","TEMP","Idade","99",25)

    oSection1:SetPageBreak(.F.) //Quebra de seção


Return(oReport)

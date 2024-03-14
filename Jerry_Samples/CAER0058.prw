#INCLUDE 'Rwmake.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'TbIconn.ch'
#INCLUDE 'Topconn.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} CAER0058
Relatorio de INSS Compras
@author  Jose Vitor
@since   17/10/2018
@version 1.0
@type function
/*/
//-------------------------------------------------------------------
User Function CAER0058()
    Private oReport
    Private cPerg := PadR('U_CAER0058', 10)

    ValidPerg()

    If ! Pergunte(cPerg, .T.)
        Return
    EndIf

    //Prepara relatorio
    ReportDef()

    //Monta tela de impressao
    oReport:PrintDialog()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ReportDef
Configuracoes para a impressao do relatorio
@author  Jose Vitor
@since   17/10/2018
@version 1.0
@type function
/*/
//-------------------------------------------------------------------
Static Function ReportDef()
    Local oSection1

    //Cria o relatorio
    oReport := TReport():New('CAER0058','Relatório INSS Compras',cPerg,{|oReport| PrintReport(oReport)},'Relatório INSS Compras')

    //Seta o relatorio em modo retrato
    oReport:SetLandscape(.T.)

    //Seta o totalizador em colunas
    oReport:SetTotalInLine(.F.)

    //Cria a secao do relatorio
    oSection1 := TRSection():New(oReport, 'INSS Compras', {'QRY'})

    //Celulas que irao conter na primeira secao do relatorio
    TRCell():New( oSection1, "FILIAL"           , "QRY",/*X3Titulo*/,/*Picture*/, 15)
    TRCell():New( oSection1, "DOCUMENTO"        , "QRY",/*X3Titulo*/,/*Picture*/, 15)
    TRCell():New( oSection1, "SERIE"            , "QRY",/*X3Titulo*/,/*Picture*/, 3)
    TRCell():New( oSection1, "CONTA_CONTABIL"   , "QRY", "Conta Contábil", /*Picture*/, Len(C10->C10_CODIGO))
    TRCell():New( oSection1, "EMISSAO"          , "QRY",/*X3Titulo*/,/*Picture*/, 14)
    TRCell():New( oSection1, "COD_PARTIC"       , "QRY", "Cod. Partic.", /*Picture*/, 10)
    TRCell():New( oSection1, "CNPJ_CEI"         , "QRY", "CNPJ/CEI", /*Picture*/, 15)
    TRCell():New( oSection1, "COD_ITEM"         , "QRY", "Cod. Item", /*Picture*/, 10)
    TRCell():New( oSection1, "DESCRICAO"        , "QRY",/*X3Titulo*/,/*Picture*/, 80)
    TRCell():New( oSection1, "QTD_ITEM"         , "QRY", "Qtd. Item", /*Picture*/, 10)
    TRCell():New( oSection1, "VLR_ITEM"         , "QRY", "Vlr. Item", /*Picture*/, 10)
    TRCell():New( oSection1, "VALOR_TOTAL"      , "QRY", "Vlr. Total", /*Picture*/, 10)
    TRCell():New( oSection1, "BASE_INSS"        , "QRY", "Base INSS", /*Picture*/, 20)
    TRCell():New( oSection1, "ALIQ_INSS"        , "QRY", "Aliq. INSS", /*Picture*/, 10)
    TRCell():New( oSection1, "VLR_INSS"         , "QRY", "Vlr. INSS", /*Picture*/, 20)
    TRCell():New( oSection1, "VLR_ABAT"         , "QRY", "Vlr. Abat. Mat.", /*Picture*/, 20)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} PrintReport
Montagem da query para impressao do relatorio
@author  Jose Vitor
@since   17/10/2018
@version 1.0
@type function
/*/
//-------------------------------------------------------------------
Static Function PrintReport(oReport)
    Local cQuery    := ''
    Local oSection1 := oReport:Section(1)

    //Query da Secao 1
    cQuery := " SELECT RTRIM(D1_FILIAL) 'FILIAL',RTRIM(D1_DOC) 'DOCUMENTO',RTRIM(D1_SERIE) 'SERIE',RTRIM(D1_CONTA) 'CONTA_CONTABIL', "
    cQuery += " REPLACE(CONVERT(VARCHAR(12),CAST(D1_EMISSAO AS DATE),105),'-','/') 'EMISSAO', CONCAT('F',RTRIM(D1_FORNECE),RTRIM(D1_LOJA)) 'COD_PARTIC', "
    cQuery += " IIF(LTRIM(RTRIM(CN9_YCEI)) = '',RTRIM(A2_CGC),CN9_YCEI) 'CNPJ_CEI', RTRIM(D1_COD) 'COD_ITEM',RTRIM(D1_DESCRI) 'DESCRICAO', "
    cQuery += " REPLACE(CAST(ROUND(SUM(D1_QUANT),5) AS NUMERIC(20,5)),'.',',') 'QTD_ITEM',REPLACE(CAST(ROUND(SUM(D1_VUNIT),2) AS NUMERIC(20,2)),'.',',') 'VLR_ITEM', "
    cQuery += " REPLACE(CAST(ROUND(SUM(D1_TOTAL),2) AS NUMERIC(20,2)),'.',',') 'VALOR_TOTAL', REPLACE(CAST(ROUND(SUM(D1_BASEINS),2) AS NUMERIC(20,2)),'.',',') 'BASE_INSS', "
    cQuery += " REPLACE(CAST(ROUND(AVG(D1_ALIQINS),2) AS NUMERIC(20,2)),'.',',') 'ALIQ_INSS', REPLACE(CAST(ROUND(SUM(D1_VALINS),2) AS NUMERIC(20,2)),'.',',') 'VLR_INSS', "
    cQuery += " REPLACE(CAST(ROUND(SUM(D1_TOTAL - D1_BASEINS),2) AS NUMERIC(20,2)),'.',',') 'VLR_ABAT' "
    cQuery += " FROM " + RetSqlTab('SD1')
    cQuery += " INNER JOIN "+RetSqlTab('SA2')+" ON A2_COD = D1_FORNECE "
    cQuery += " INNER JOIN "+RetSqlTab('SE2')+" ON E2_TIPO = 'INS' AND E2_NUM = D1_DOC AND E2_PREFIXO = D1_SERIE AND SUBSTRING(E2_TITPAI,19,6) = D1_FORNECE AND SUBSTRING(E2_TITPAI,25,2) = D1_LOJA AND E2_FILIAL = D1_FILIAL "
    cQuery += " AND E2_PARCELA = (SELECT MIN(E2_PARCELA) "
    cQuery += "     FROM " + RetSqlName('SE2') + " SE2AUX WHERE SE2AUX.E2_NUM=SE2.E2_NUM and SE2AUX.E2_PREFIXO=SE2.E2_PREFIXO AND SE2AUX.E2_TIPO = 'INS' AND SUBSTRING(SE2AUX.E2_TITPAI,19,6) = D1_FORNECE "
    cQuery += "     AND SUBSTRING(SE2AUX.E2_TITPAI,25,2) = D1_LOJA AND SE2AUX.E2_FILIAL = D1_FILIAL and SE2AUX.D_E_L_E_T_='')"
    cQuery += " INNER JOIN "+RetSqlTab('CN9')+" ON LTRIM(RTRIM(E2_MDCONTR)) = LTRIM(RTRIM(CN9_NUMERO)) AND LTRIM(RTRIM(E2_MDREVIS)) = LTRIM(RTRIM(CN9_REVISA)) "
    cQuery += " WHERE " + RetSqlDel('SD1,SA2,SE2,CN9')
    cQuery += " AND D1_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
    cQuery += " AND D1_VALINS > 0 "
    cQuery += " GROUP BY D1_FILIAL, D1_DOC, D1_SERIE, D1_CONTA, D1_EMISSAO, D1_FORNECE, D1_LOJA, CN9_YCEI, D1_COD, D1_DESCRI, A2_CGC "
    cQuery += " ORDER BY D1_EMISSAO, D1_DOC "

    If Select("QRY") > 0
        QRY->(DbCloseArea())
    EndIf

    TcQuery cQuery New Alias "QRY"

    oSection1:init()
    // Percorre a Secao 1
    While QRY->(!Eof())
        oSection1:PrintLine()
        QRY->(DbSkip())
    EndDo
    oSection1:Finish()

    oReport:EndPage()
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ValidPerg
Criacao das perguntas do relatorio
@author  Jose Vitor
@since   17/10/2018
@version 1.0
@type function
/*/
//-------------------------------------------------------------------
Static Function ValidPerg()
    Local aRegs    := {}
    Local aAreaSX1 := SX1->(GetArea())
    Local i, j

    SX1->(DbSetOrder(1))

    // Numeracao dos campos:
    // 01 -> X1_GRUPO   02 -> X1_ORDEM    03 -> X1_PERGUNT  04 -> X1_PERSPA  05 -> X1_PERENG
    // 06 -> X1_VARIAVL 07 -> X1_TIPO     08 -> X1_TAMANHO  09 -> X1_DECIMAL 10 -> X1_PRESEL
    // 11 -> X1_GSC     12 -> X1_VALID    13 -> X1_VAR01    14 -> X1_DEF01   15 -> X1_DEFSPA1
    // 16 -> X1_DEFENG1 17 -> X1_CNT01    18 -> X1_VAR02    19 -> X1_DEF02   20 -> X1_DEFSPA2
    // 21 -> X1_DEFENG2 22 -> X1_CNT02    23 -> X1_VAR03    24 -> X1_DEF03   25 -> X1_DEFSPA3
    // 26 -> X1_DEFENG3 27 -> X1_CNT03    28 -> X1_VAR04    29 -> X1_DEF04   30 -> X1_DEFSPA4
    // 31 -> X1_DEFENG4 32 -> X1_CNT04    33 -> X1_VAR05    34 -> X1_DEF05   35 -> X1_DEFSPA5
    // 36 -> X1_DEFENG5 37 -> X1_CNT05    38 -> X1_F3       39 -> X1_GRPSXG

    aAdd(aRegs, {cPerg, "01", "Data de?"  , "", "", "mv_ch1", 'D', 8, 0, 0, 'G', "", "MV_PAR01", "",  "", "", "", "", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
    aAdd(aRegs, {cPerg, "02", "Data até?" , "", "", "mv_ch2", 'D', 8, 0, 0, 'G', "", "MV_PAR02", "",  "", "", "", "", "",    "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

    For i := 1 To Len(aRegs)
        If ! SX1->(DbSeek(cPerg+aRegs[i,2]))
            RecLock("SX1", .T.)

                For j :=1 to SX1->(FCount())
                    If j <= Len(aRegs[i])
                        SX1->(FieldPut(j,aRegs[i,j]))
                    EndIf
                Next

            SX1->(MsUnlock())
        EndIf
    Next

    SX1->(RestArea(aAreaSX1))
Return

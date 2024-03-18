#include 'totvs.ch'

/*/{Protheus.doc} NICE02
(long_description)
@type user function
@author user
@since 13/03/2024
@version 1.0
/*/
User Function NICE02()
    Local oReport 
    Local cAlias := 'ZB1'

    oReport := RptStruc(cAlias)

    oReport:printDialog()
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
    Local cHelp   := 'Permite imprimir um relatorio de todos os registros de viagens'
    Local oReport
    Local oSection1

    oReport   := TReport():New('TRPT001', cTitulo,/*Pergunta*/,{|oReport|rPrint(oReport)},cHelp)

    oSection1 := TRSection():New(oReport, 'Viagens', {cAlias})
 
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
// Static Function rPrint(oReport, cAlias)
//     local oSecao1 := oReport:Section(1)
//     ZB1->(DBSetOrder(1)) 
//     ZB1->(DBGoTop())

//     IF RETCODUSR() != GETMV("MZ_APRPC")
//         While ZB1->(!Eof())
//             IF ZB1->(ZB1_CODSOL) != RETCODUSR()
//                 ZB1->(DBSkip(1))
//             Else
//                 oSecao1:Init()
//                 oSecao1:printLine()
//                 //FWAlertInfo("Teste IF" + (ZB1->(ZB1_CODSOL)))
//                 ZB1->(DBSkip(1))
//             EndIF
//         Enddo
//         oSecao1:Finish()
//     Else
//         oSecao1:Print()
//     EndIF
    
//     oSecao1:SetMeter((cAlias)->(RecCount()))

// Return

Static Function rPrint(oReport)
    local oSecao1 := oReport:Section(1)
    Local cAlias := 'ZB1'
    ZB1->(DBGoTop())
    SE2->(DbGoTop())

    oSecao1:BeginQuery()
    
    BeginSQL alias cAlias
        SELECT ZB1_CODSOL, ZB1_NOMSOL, ZB1_ESTORI, ZB1_ESTDES, ZB1_CODPRE, ZB1_DTIDA, ZB1_DTRETO
            FROM %table:ZB1% ZB1, %table:SE2% SE2
            WHERE ZB1.D_E_L_E_T_ = ' '
            AND ZB1_CODPRE BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
            AND ZB1_ESTORI = %exp:MV_PAR01%
            AND ZB1_ESTDES = %exp:MV_PAR02%
            AND ZB1_DTIDA = %exp:MV_PAR05%
            AND ZB1_DTRETO = %exp:MV_PAR06%
            AND ZB1_STATUS IN (
                CASE
                    WHEN %exp:MV_PAR07% = 'Cadastro de Pre' THEN (
                        SELECT DISTINCT ZB1_STATUS
					       FROM %table:ZB1% ZB1
						WHERE ZB1_STATUS != 'APR'
                    )
                    ELSE (
                        SELECT DISTINCT ZB1_STATUS
					       FROM %table:ZB1% ZB1 
						WHERE ZB1_STATUS = 'APR'    
                    )
                END
            )
            AND E2_BAIXA IN (
                CASE
                    WHEN %exp:MV_PAR08% = 'Não' THEN ''
                    ELSE E2_BAIXA
                END
            )
            AND ZB1_STATUS IN (
            CASE
                WHEN %exp:MV_PAR09% IS NULL THEN ZB1_CODSOL
                ELSE %exp:MV_PAR10% 
            END
            )
        ORDER BY ZB1_CODPRE
    EndSQL

    oSecao1:EndQuery()
    oSecao1:SetMeter((cAlias)->(RecCount()))
    oSecao1:Print()
Return

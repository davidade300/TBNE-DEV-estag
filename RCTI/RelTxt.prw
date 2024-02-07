#Include 'Protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} reltxt
Exemplo de escrita em arquivo texto utilizando advpl
@type function
@author Curso Desenvolvendo relatórios com ADVPL - RCTI Treinamentos
@since 2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see www.rctitreinamentos.com.br
/*/
User Function RelTxt()

If MsgYesNo("Esta função tem como objetivo gerar arquivo TXT")
	
	Processa({||MntQry() },,"Processando...")
	MsAguarde({ || GeraArq()},,"O arquivo TXT está sendo gerado...")
	
Else
Alert("Cancelada pelo Operador")
EndIf

Return Nil

/** Montar a query **/
Static Function MntQry()

	Local cQuery := ""
	
	cQuery := " SELECT B1_FILIAL AS FILIAL, B1_COD AS CODIGO,  "
	cQuery += " B1_DESC AS DESCRICAO "
	cQuery += " FROM SB1990 WHERE D_E_L_E_T_ = ''"
	
	cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery), 'TMP',.F.,.T.)

Return Nil

/** Função que gera o arquivo TXT **/
Static Function GeraArq()

Local cDir := "C:\TOTVS 12\Microsiga\protheus_data\treport\"
Local cArq := "arquivo2.csv"
Local nHandle := FCreate(cDir+cArq)

	If nHandle < 0 
		MsgAlert("Erro ao criar o arquivo", "ERRO")
		
	Else
		While TMP->(!EOF())
		
		FWrite(nHandle, TMP->(FILIAL)+ " ; " + TMP->(CODIGO) + " ; " + TMP->(DESCRICAO) + CRLF)
		TMP->(dbSkip())
		
		EndDo
	
	/*
		For nLinha := 1 to 200
			FWrite(nHandle,"Gravando a linha " + StrZero(nLinha,3)+ CRLF)
		Next nLinha
		//
		**/
		FClose(nHandle)
	
	EndIf

	If FILE("C:\TOTVS 12\Microsiga\protheus_data\treport\arquivo2.csv")
		MsgInfo("Arquivo criado com sucesso!")
	Else
		MsgAlert("Não foi possivel criar o arquivo", "ALERTA")
	EndIf
	
Return

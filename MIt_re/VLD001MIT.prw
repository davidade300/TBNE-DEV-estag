#include 'totvs.ch'

/*/{Protheus.doc} VLDDATAIDA
VERIFICA SE O NOME DO ARQUIVO POSSUI A EXTENS�O CORRETA
@type user function
@author Reno Neto
@since 01/03/2024
@version 1.0
@see (links_or_references)
@history 01/03/2024 Reno Neto | Cria��o do Programa
/*/
USER FUNCTION VLD001MIT()

    dbSelectArea("ZB1")
    dbSetOrder(1)

    IF fContemStr(M->(ZB1_COMPRO),".JPEG"); 
    .OR. fContemStr(M->(ZB1_COMPRO),".PNG"); 
    .OR. fContemStr(M->(ZB1_COMPRO),".PDF")
        RETURN .T.
    ELSE
        fwAlertError("A extens�o do arquivo deve ser: JPEG, PNG ou PDF. Verifique novamente", "Extens�o de arquivo inv�lida!")
        RETURN .F.
    ENDIF    

    dbCloseArea()

RETURN

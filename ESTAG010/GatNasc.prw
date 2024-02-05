#include 'totvs.ch'

/*/{Protheus.doc} GATNASC
Funcao gatilho para o campo idade da rotina ESTAG010
Funcao está em desuso e o gatilho correspondente foi configurado no SIGACFG, ZA1_DOB
--> INT(DateDiffDay(DATE(), M->ZA1_DOB)/365)
@type user function
@author David
@since 02/02/2024
@version 1.0
@example 
ZA1_DOb = 22/04/1998 retorna o valor 25 no campo idade para datas  < 22/04/2024 e => 22/04/2023
/*/
User Function GATNASC()
    
    dbSelectArea("ZA1")
    
    reclock("ZA1", .F.)
        nData := DateDiffDay(DATE(),M->ZA1_DOB)
        ZA1->ZA1_IDADE := INT(nData)
    msunlock()

return ZA1_IDADE

#include 'totvs.ch'

/*/{Protheus.doc} GATNASC
Funcao gatilho para o campo idade da rotina ESTAG010
@type user function
@author David
@since 02/02/2024
@version 1.0
@example 
Data.nasc = 01/01/1999 retorna o valor 24 no campo idade
/*/
User Function GATNASC()
        USE ZA1990 ALIAS ZA1 SHARED NEW VIA "TOPCONN"
        dbUseArea
    
    dbSelectArea("ZA1")
    
    
    nData := DateDiffDay(DATE(),STOD('19980422'))

    fwAlertinfo(str(int(nData/365)))
    
return ZA1_IDADE

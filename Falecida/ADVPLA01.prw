#include 'totvs.ch'

User Function ADVPLA01()

    Local cAlias := 'ZZ1'
    Local cTitulo := 'Grupo de Despesa'
    Local cVldDel := 'U_ADVPL01A()'
    Local cVldAlt := '.T.'

    AxCadastro(cAlias, cTitulo, cVldDel, cVldAlt)

Return

User Function ADVPL01A

    local lRet := .T.

    if MsgNoYes('Tem certeza que deseja excluir?','Atenção')
        lRet := .T.
    else
        lRet := .F.
    Endif

Return lRet

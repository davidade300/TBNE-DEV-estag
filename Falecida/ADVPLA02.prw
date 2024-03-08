#include 'totvs.ch'

/*/{Protheus.doc} nomeFunction
(long_description)
@type user function
@author David Aderaldo
@since 07/03/2024
@version 1.0
/*/
User Function ADVPLA02

    private cDelFunc := ".T."
    private cCadastro := "TIPOS DE DESPESAS"

    private aRotina := {;
        { "Pesquisar", "AxPesqui", 0, 1 },;
        { "Visualizar", "AxVisual"  , 0, 2 },;
        { "Incluir"      , "AxInclui"   , 0, 3 },;
        { "Alterar"     , "AxAltera"  , 0, 4 },;
        { "Ola aRotina", "U_ADVPL02a()", 0, 4},;
        { "Excluir"     , "AxDeleta" , 0, 5 };
    }

    chkFile("ZZ2")
    dbSelectArea("ZZ2")
    ZZ2->(dbSetOrder(1))

    mBrowse(6, 1, 22, 75,"ZZ2")

Return
 
User function ADVPL02a
    apMsgInfo('Olá aRotina !!!!')
Return

#include 'totvs.ch
#include 'topconn.ch'

/*/{Protheus.doc} TOTPC001
Cadastro de Prestação de contas personalizado
@type user function
@author David
@since 29/02/2024
@version 1.0
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
/*/
User Function TOTPC002

    Public cAlias := "ZB1"
 
    Private cCadastro := "Cadastro de Prestação de Contas"

    Private aRotina     := {}

    AADD(aRotina, { "Pesquisar", "AxPesqui", 0, 1 })
    AADD(aRotina, { "Visualizar", "AxVisual"  , 0, 2 })
    AADD(aRotina, { "Incluir"      , "AxInclui"   , 0, 3 })
    AADD(aRotina, { "Alterar"     , "AxAltera"  , 0, 4 })
    AADD(aRotina, { "Excluir"     , "AxDeleta" , 0, 5 })
        
    dbSelectArea(cAlias)
    dbSetOrder(1)

    mBrowse(6, 1, 22, 75, cAlias)

Return

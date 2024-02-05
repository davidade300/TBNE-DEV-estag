#include 'totvs.ch'
#INCLUDE 'topconn.ch'

/*/{Protheus.doc} nomeFunction
(long_description)
@type user function
@author user
@since 01/02/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function ESTAG010
	
    Local cAlias := "ZA1"

    Private cCadastro := "Cadastro de Pessoas estag"

    Private aRotina     := { }

    AADD(aRotina, { "Pesquisar", "AxPesqui", 0, 1 })
    AADD(aRotina, { "Visualizar", "AxVisual"  , 0, 2 })
    AADD(aRotina, { "Incluir"      , "AxInclui"   , 0, 3 })
    AADD(aRotina, { "Alterar"     , "AxAltera"  , 0, 4 })
    AADD(aRotina, { "Excluir"     , "AxDeleta" , 0, 5 })
    //AADD(aRotina, {  "Relatorio",      " funcaodorelatorio",   0,6})

    dbSelectArea(cAlias)
    dbSetOrder(1)

    mBrowse(6, 1, 22, 75, cAlias)

return


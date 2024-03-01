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


/*/{Protheus.doc} SetPrest
                          ESTA FUNÇÃO NÃO ESTÁ EM USO
define o valor da prestação de acordo com o campo ZB1_ESTDES
e os parâmetros MZ_PDEST e MZ_PFEST quando o campo ZB1_DT
@type user function
@author David
@since 29/02/2024
@version 1.0

User Function SetPrest()

    IF M->ZB1_ESTDES == getMV('MV_ESTADO')
      valor := getMV("MZ_PDEST") * M->ZB1_DIAS
    ELSE
      valor := getMV("MZ_PFEST") * M->ZB1_DIAS
    ENDIF

return valor

/*/
/*/{Protheus.doc} DtError()
Função que retorna mensagem de erro caso a data de retorno seja incompatível
com a data de saída.
@type user function
@author David
@since 01/03/2024
@version 1.0

User Function DtError()

cMensagem := 'A DATA DE RETORNO DEVE SER SUPERIOR OU IGUAL A DATA DE SAÍDA'
cTitulo := 'ERRO !'

IIF(M->ZB1_DTRET < M->ZB1_DTSAI, FWAlertError(cMensagem,cTitulo),.T.)

Return
/*/

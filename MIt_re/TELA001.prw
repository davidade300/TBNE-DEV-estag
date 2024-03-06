#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} TELA001
(long_description)
@type user function
@author David Aderaldo
@since 05/03/2024
@version 1.0
@see (links_or_references)
/*/
USER FUNCTION TELA001()

    Private aRotina := MENUDEF()
    Private oBrowse := fwMBrowse():new()

    oBrowse:setAlias('ZB1')                                    //TABELA ATIVA, SERIA O MESMO DE UTILIZAR AS FUNÇÕES dbSelectArea() e dbSetOrder()
    oBrowse:setDescription('Cadastro de Prestação de Contas')  //TÍTULO DA TELA
    oBrowse:setExecuteDef(2)                                   //DETERMINA A ROTINA PADRÃO AO REALIZAR UM DUPLO CLIQUE EM UM REGISTRO
    //oBrowse:AddLegend("ZB1_STATUS == 'EMA'",'WHITE', "Em Aberto" )
    //oBrowse:AddLegend("ZB1_STATUS == 'EFT'",'GREEN', "Efetivado" )
    //oBrowse:AddLegend("ZB1_STATUS == 'REV'",'YELLOW',"Revisão"   )
    //oBrowse:AddLegend("ZB1_STATUS == 'CAN'",'GRAY',  "Cancelado" )
    //oBrowse:AddLegend("ZB1_STATUS == 'APR'",'RED',   "Aprovado"  )

     //FILTRO: MOSTRA PRESTAÇÃO / USUÁRIO
    oBrowse:setFilterDefault("RETCODUSR() == GETMV('MZ_APRPC') .OR. ZB1->(ZB1_USRCOD) = RETCODUSR()")

    oBrowse:activate()                                        //REALIZA A ABERTURA DA TELA

   
   
RETURN

/*/{Protheus.doc} MENUDEF
FUNÇÃO RESPONSÁVEL PELA ESTRUTURA DO MENU
@type static function
/*/
STATIC FUNCTION MENUDEF()

    Local aRotina := {}

    //ADD OPTION (variável) TITLE (título) ACTION (função) OPERATION (processo) ACCESS (0 fixo)
    IF (RETCODUSR() != getMV("MZ_APRPC"))
        ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.TELA001'  OPERATION 2  ACCESS 0
        ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.TELA001'  OPERATION 3  ACCESS 0
        ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.TELA001'  OPERATION 4  ACCESS 0
        ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.TELA001'  OPERATION 5  ACCESS 0
        ADD OPTION aRotina TITLE 'Efetivar'   ACTION 'VIEWDEF.TELA001'  OPERATION 6  ACCESS 0
    ELSE
        ADD OPTION aRotina TITLE 'Aprovar'    ACTION 'VIEWDEF.TELA001'  OPERATION 7  ACCESS 0
        ADD OPTION aRotina TITLE 'Revisão'    ACTION 'VIEWDEF.TELA001'  OPERATION 8  ACCESS 0
        ADD OPTION aRotina TITLE 'Cancelar'   ACTION 'VIEWDEF.TELA001'  OPERATION 9  ACCESS 0
        ADD OPTION aRotina TITLE 'Relatório'  ACTION 'VIEWDEF.TELA001'  OPERATION 10 ACCESS 0
    ENDIF  

RETURN aRotina

/*/{Protheus.doc} VIEWDEF
FUNÇÃO RESPONSÁVEL PELA INTERFACE GRÁFICA
@type static function
/*/
STATIC FUNCTION VIEWDEF()

    Local oView //REPRESENTA TODA A INTERFACE GRÁFICA
    Local oModel 
    Local oStruct //REFERENCIA A TABELA UTILIZADA NA ESTRUTURA

    oStruct := fwFormStruct(2,'ZB1')
    oModel  := fwLoadModel('TELA001')
    oView   := fwFormView():new()

    oView:setModel(oModel)
    oView:addField('ZB1MASTER',oStruct,'ZB1MASTER')
    oView:createHorizontalBox('BOXZB1',100)
    oView:setOwnerView('ZB1MASTER','BOXZB1')

RETURN oView

/*/{Protheus.doc} MODELDEF
FUNÇÃO RESPONSÁVEL PELA REGRA DE NEGÓCIO
@type static function
/*/
STATIC FUNCTION MODELDEF()

    Local oModel
    Local oStruct
    Local bModelPos := {|oModel| FNMODPOS(oModel)}

    oStruct := fwFormStruct(1,'ZB1')
    //mpForModel():new(<cNomeDoArquivo>, <bModelPre> (ACIONADO SEMPRE QUE HOUVER TENTATIVA DE ALTERAR CAMPO), <bModelPos> (ÚLTIMA VALIDAÇÃO DOS DADOS, PARA CONFIRMAR SE OS DADOS TENTARÃO SER GRAVADOS OU NÃO), <bCommit> (FAZ A GRAVAÇÃO NO BANCO DE DADOS), <bCancel> (EXECUTA NO MOMENTO QUE O USUÁRIO CANCELAR A TELA))
    oModel  := mpFormModel():new('MODEL_TELA001',,bModelPos)

    oModel:addFields('ZB1MASTER',,oStruct)
    oModel:setDescription('Cadastro de Prestação de Contas')
    oModel:setPrimaryKey({'ZB1_FILIAL','ZB1_COD'})
    
RETURN oModel

/*/{Protheus.doc} FNMODPOS
VALIDAÇÃO REALIZADA NO MOMENTO QUE O USUÁRIO CONFIRMAR O REGISTRO.
@type Static Function
@author David
@since 01/03/2024
/*/
STATIC FUNCTION FNMODPOS(oModel)

    //VALIDAÇÃO AO TENTAR INCLUIR UM NOVO REGISTRO
    //NÃO PODE EXISTIR REGISTROS DE UM MESMO USUÁRIO COM A MESMA DATA DE IDA E VOLTA, DESTINO E NEM DIAS DE VIAGEM. 
    
    Local lValid    := .T.
    Local lExist    := .F.
    Local cAliasSQL := ''
    Local nOpr      := oModel:getOperation()
    
    IF nOpr == 3

        cAliasSQL := getNextAlias()

        BeginSQL alias cAliasSQL
            SELECT * FROM %table:ZB1% ZB1
            WHERE ZB1.%notdel%
            AND ZB1_FILIAL = %exp:xFilial('ZB1')%
            AND ZB1_COD = %exp:M->ZB1_USRCOD%
            AND ZB1_DTSAI = %exp:M->ZB1_DTSAI%
            AND ZB1_DTRET = %exp:M->ZB1_DTRET%
        EndSQL

        (cAliasSQL)->(dbEval({|| lExist:= .T.}),dbCloseArea())

        IF lExist 
            oModel:setErrorMessage(,,,,"Não é possível realizar a inclusão","Cadastro já existente, inclusão não permitida.")
            RETURN .F.
        ENDIF

    ENDIF

RETURN lValid

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

    oBrowse:setAlias('ZB1')                                    //TABELA ATIVA, SERIA O MESMO DE UTILIZAR AS FUN��ES dbSelectArea() e dbSetOrder()
    oBrowse:setDescription('Cadastro de Presta��o de Contas')  //T�TULO DA TELA
    oBrowse:setExecuteDef(2)                                   //DETERMINA A ROTINA PADR�O AO REALIZAR UM DUPLO CLIQUE EM UM REGISTRO
    //oBrowse:AddLegend("ZB1_STATUS == 'EMA'",'WHITE', "Em Aberto" )
    //oBrowse:AddLegend("ZB1_STATUS == 'EFT'",'GREEN', "Efetivado" )
    //oBrowse:AddLegend("ZB1_STATUS == 'REV'",'YELLOW',"Revis�o"   )
    //oBrowse:AddLegend("ZB1_STATUS == 'CAN'",'GRAY',  "Cancelado" )
    //oBrowse:AddLegend("ZB1_STATUS == 'APR'",'RED',   "Aprovado"  )

     //FILTRO: MOSTRA PRESTA��O / USU�RIO
    oBrowse:setFilterDefault("RETCODUSR() == GETMV('MZ_APRPC') .OR. ZB1->(ZB1_USRCOD) = RETCODUSR()")

    oBrowse:activate()                                        //REALIZA A ABERTURA DA TELA

   
   
RETURN

/*/{Protheus.doc} MENUDEF
FUN��O RESPONS�VEL PELA ESTRUTURA DO MENU
@type static function
/*/
STATIC FUNCTION MENUDEF()

    Local aRotina := {}

    //ADD OPTION (vari�vel) TITLE (t�tulo) ACTION (fun��o) OPERATION (processo) ACCESS (0 fixo)
    IF (RETCODUSR() != getMV("MZ_APRPC"))
        ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.TELA001'  OPERATION 2  ACCESS 0
        ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.TELA001'  OPERATION 3  ACCESS 0
        ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.TELA001'  OPERATION 4  ACCESS 0
        ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.TELA001'  OPERATION 5  ACCESS 0
        ADD OPTION aRotina TITLE 'Efetivar'   ACTION 'VIEWDEF.TELA001'  OPERATION 6  ACCESS 0
    ELSE
        ADD OPTION aRotina TITLE 'Aprovar'    ACTION 'VIEWDEF.TELA001'  OPERATION 7  ACCESS 0
        ADD OPTION aRotina TITLE 'Revis�o'    ACTION 'VIEWDEF.TELA001'  OPERATION 8  ACCESS 0
        ADD OPTION aRotina TITLE 'Cancelar'   ACTION 'VIEWDEF.TELA001'  OPERATION 9  ACCESS 0
        ADD OPTION aRotina TITLE 'Relat�rio'  ACTION 'VIEWDEF.TELA001'  OPERATION 10 ACCESS 0
    ENDIF  

RETURN aRotina

/*/{Protheus.doc} VIEWDEF
FUN��O RESPONS�VEL PELA INTERFACE GR�FICA
@type static function
/*/
STATIC FUNCTION VIEWDEF()

    Local oView //REPRESENTA TODA A INTERFACE GR�FICA
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
FUN��O RESPONS�VEL PELA REGRA DE NEG�CIO
@type static function
/*/
STATIC FUNCTION MODELDEF()

    Local oModel
    Local oStruct
    Local bModelPos := {|oModel| FNMODPOS(oModel)}

    oStruct := fwFormStruct(1,'ZB1')
    //mpForModel():new(<cNomeDoArquivo>, <bModelPre> (ACIONADO SEMPRE QUE HOUVER TENTATIVA DE ALTERAR CAMPO), <bModelPos> (�LTIMA VALIDA��O DOS DADOS, PARA CONFIRMAR SE OS DADOS TENTAR�O SER GRAVADOS OU N�O), <bCommit> (FAZ A GRAVA��O NO BANCO DE DADOS), <bCancel> (EXECUTA NO MOMENTO QUE O USU�RIO CANCELAR A TELA))
    oModel  := mpFormModel():new('MODEL_TELA001',,bModelPos)

    oModel:addFields('ZB1MASTER',,oStruct)
    oModel:setDescription('Cadastro de Presta��o de Contas')
    oModel:setPrimaryKey({'ZB1_FILIAL','ZB1_COD'})
    
RETURN oModel

/*/{Protheus.doc} FNMODPOS
VALIDA��O REALIZADA NO MOMENTO QUE O USU�RIO CONFIRMAR O REGISTRO.
@type Static Function
@author David
@since 01/03/2024
/*/
STATIC FUNCTION FNMODPOS(oModel)

    //VALIDA��O AO TENTAR INCLUIR UM NOVO REGISTRO
    //N�O PODE EXISTIR REGISTROS DE UM MESMO USU�RIO COM A MESMA DATA DE IDA E VOLTA, DESTINO E NEM DIAS DE VIAGEM. 
    
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
            oModel:setErrorMessage(,,,,"N�o � poss�vel realizar a inclus�o","Cadastro j� existente, inclus�o n�o permitida.")
            RETURN .F.
        ENDIF

    ENDIF

RETURN lValid

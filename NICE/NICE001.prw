#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} NICE001
(long_description)
@type user function
@author Aencio
@since 01/03/2024
@version 1.0
/*/
User Function NICE001()

    Private aRotina   := menudef()
    Private oBrowse   := fwMBrowse():New()

    oBrowse:setAlias('ZB1')
    oBrowse:setDescription('Cadastro')
    oBrowse:setExecuteDef(4)
    oBrowse:setFilterDefault("RETCODUSR() == GETMV('MZ_APRPC') .OR. ZB1->(ZB1_CODSOL) = RETCODUSR()")    
    oBrowse:AddLegend("ZB1_STATUS == '3' ", "BR_BRANCO"    ,"Em Aberto")
    oBrowse:AddLegend("ZB1_STATUS == '6' ", "BR_VERDE"     ,"Efetivado")
    oBrowse:AddLegend("ZB1_STATUS == '7' ", "BR_AMARELO"   ,"Revisão")
    oBrowse:AddLegend("ZB1_STATUS == '8' ", "BR_CINZA"     ,"Cancelado")
    oBrowse:AddLegend("ZB1_STATUS == '9' ", "BR_VERMELHO"  ,"Aprovado")
    oBrowse:activate()

Return

/*/{Protheus.doc} menudef
(long_description)
@type user function
@author Aencio 
@since 01/03/2024
@version 1.0
/*/
Static Function menudef()

    Local aRotina := {}
    //adicionando itens ao menu
    IF RetCodUsr() == GetMv("MZ_APRPC")
        ADD OPTION ARotina TITLE 'Pesquisar'  ACTION 'AxPesqui'        OPERATION 1 ACCESS 0
        ADD OPTION ARotina TITLE 'Visualizar' ACTION 'VIEWDEF.NICE001' OPERATION 2 ACCESS 0
        ADD OPTION ARotina TITLE 'Alterar'    ACTION 'VIEWDEF.NICE001' OPERATION 4 ACCESS 0
        ADD OPTION aRotina TITLE 'Relatório'  ACTION 'U_NICE02'        OPERATION 6 ACCESS 0
        ADD OPTION aRotina TITLE 'Efetivar'   ACTION 'U_EFETIVA()'     OPERATION 7 ACCESS 0
    Else
        ADD OPTION ARotina TITLE 'Pesquisar'  ACTION 'AxPesqui'        OPERATION 1 ACCESS 0
        ADD OPTION ARotina TITLE 'Visualizar' ACTION 'VIEWDEF.NICE001' OPERATION 2 ACCESS 0
        ADD OPTION ARotina TITLE 'Incluir'    ACTION 'VIEWDEF.NICE001' OPERATION 3 ACCESS 0
        ADD OPTION ARotina TITLE 'Alterar'    ACTION 'VIEWDEF.NICE001' OPERATION 4 ACCESS 0
        ADD OPTION aRotina TITLE 'Relatório'  ACTION 'U_NICE02'        OPERATION 6 ACCESS 0
        ADD OPTION aRotina TITLE 'Efetivar'   ACTION 'U_EFETIVA()'     OPERATION 7 ACCESS 0
    EndIF

Return aRotina

/*/{Protheus.doc} viewdef
(loAEng_description)
@type Static function
@author Aencio
@since 01/03/2024
@version 1.0
/*/

// aparencia da tela, o viewdef precisa de 3 componentes

Static Function viewdef()
    Local oView
    Local oModel
    Local oStruct

    oStruct := FWFormStruct(2, 'ZB1')
    oModel  := FwLoadModel('NICE001')
    oView   := FWFormView():new()

    oView:setModel(oModel)
    oView:addField('ZB1MASTER',oStruct,'ZB1MASTER')
    oView:createHorizontalBox('BOXZB1',100)
    oView:setOwnerView('ZB1MASTER','BOXZB1')

    IF RetCodUsr() == GetMv("MZ_APRPC")
        oView:AddUserButton( 'Aprovação', 'CLIPS',{|oView| U_APROVA()},,,(4),.T.)
        oView:AddUserButton( 'Revisão',  'CLIPS', {|oView| U_REVISAO()},,,(4),.T.)
        oView:AddUserButton( 'Cancelar', 'CLIPS', {|oView| U_CANCELAR()},,,(4),.T.)
    EndIF
    
Return oView

/*/{Protheus.doc} modeldef
(Construção da regra de negocio)
@type Static function
@author Aencio
@since  01/03/2024
@version 1.0
/*/
Static Function modeldef()

    Local oModel
    Local oStruct
    Local bFieldPos := {|oModel| ADDSTATUS(oModel)}
    //Local bAProvaPos := {|oModel| APROVA(oModel)}

    oStruct := FWFormStruct(1,'ZB1') 

    oModel := mpFormModel():new('MODEL_NICE001') 
    oModel:addFields('ZB1MASTER',,oStruct,bFieldPos)
    oModel:setDescription('Tipos de contratos')
    oModel:setPrimaryKey({'ZB1_FILIAL', 'ZB1_CODPRE'})

Return oModel

/*/{Protheus.doc} ADDSTATUS
(Construção da regra de negocio)
@type User function
@author Aencio
@since  01/03/2024
@version 1.0
/*/

Static Function ADDSTATUS(oModel)
    local nOpr := oModel:getOperation()
    Local cStatus
    //FWAlertError("Teste Model" + str(nOpr),'tESTE')
     IF nOpr == 3
        cStatus := "3"
        oModel:LoadValue('ZB1_STATUS',cStatus)
    EndIF
Return 

/*/{Protheus.doc} U_APROVA
(Construção da regra de negocio)
@type User function
@author Aencio
@since  01/03/2024
@version 1.0
/*/

Function U_APROVA()

    aVetSE2 := array(0)

    Local cStatus := "9"
    Local cPrefix := SuperGetMV('MS_PREFIXO', .F., 'ADV')
    Local cTipo := SuperGetMV('MS_TIPO', .F., 'NF')
    //Local cNatu := SuperGetMV('MS_NATUREZ', .F., 'Diversos')
    Local cFornece := SuperGetMV('MS_FORNECE', .F., 'UNIAO')
    Local cLoja := SuperGetMV('MS_LOJA', .F., '01')

    Private lMsErroAuto := .F.

    If ZB1->ZB1_STATUS == '6'
        if MsgYesNo('Confirma a efetivação?')
            
            aAdd(aVetSE2, {"E2_NUM",     000000001,         Nil})
            aAdd(aVetSE2, {"E2_PREFIXO", cPrefix,           Nil})
            aAdd(aVetSE2, {"E2_TIPO",    cTipo,             Nil})
            aAdd(aVetSE2, {"E2_NATUREZ", '001',             Nil})
            aAdd(aVetSE2, {"E2_FORNECE", cFornece,          Nil})
            aAdd(aVetSE2, {"E2_Loja",    cLoja,             Nil})
            aAdd(aVetSE2, {"E2_EMISSAO", dDataBase,         Nil})
            aAdd(aVetSE2, {"E2_VENCTO",  dDataBase + 7,     Nil})
            aAdd(aVetSE2, {"E2_VALOR",   ZB1->ZB1_VLRPRE,   Nil})

            msExecAuto({|x, y, z| FINA050(x, y, z)},aVetSE2,, 3)

            iF lMsErroAuto
                MostraErro()
            Else
                Reclock('ZB1', .F.)
                    ZB1->(ZB1_STATUS) := ''
                    ZB1->(ZB1_STATUS) := cStatus
                ZB1->(msUnlock())
                ApMsgInfo("Título incluído com sucesso!")
            EndIF

        endif

    else
        MsgAlert('Só é possível efetivar um movimento aberto.')
    EndIF  

Return 

/*/{Protheus.doc} U_EFETIVA
(Construção da regra de negocio)
@type User function
@author Aencio
@since  01/03/2024
@version 1.0
/*/

Function U_EFETIVA()
    Local cStatus := "6"
    Local cStatusAtual :=  ZB1->(ZB1_STATUS)

    IF cStatusAtual == "6"
        FWAlertError("Não é possível efetivar uma solicitação já efetivada!")
        return
    EndIF

    IF cStatusAtual == "9"
        FWAlertError("Não é possível efetivar uma solicitação aprovada!")
        return
    EndIF

    reclock('ZB1')
    ZB1->(ZB1_STATUS) := ''
    ZB1->(ZB1_STATUS) := cStatus
    msunlock()
    FWAlertInfo('Efetivação feita com sucesso') 
Return

/*/{Protheus.doc} U_REVISAO
(Construção da regra de negocio)
@type User function
@author Aencio
@since  01/03/2024
@version 1.0
/*/

Function U_REVISAO()
    Local cStatus
    cStatus := "7"
    reclock('ZB1')
    ZB1->(ZB1_STATUS) := ''
    ZB1->(ZB1_STATUS) := cStatus
    msunlock()
    FWAlertInfo('Revisão realizada com sucesso!') 
Return

/*/{Protheus.doc} U_CANCELAR
(Construção da regra de negocio)
@type User function
@author Aencio
@since  01/03/2024
@version 1.0
/*/
Function U_CANCELAR()
    aVetSE2 := array(0)

    Local cPrefix := SuperGetMV('MS_PREFIXO', .F., 'ADV')
    Local cTipo := SuperGetMV('MS_TIPO', .F., 'NF')
    Local cFornece := SuperGetMV('MS_FORNECE', .F., 'UNIAO')
    Local cLoja := SuperGetMV('MS_LOJA', .F., '01')
    Local cStatus := "8"
    
    Private lMsErroAuto := .F.

    If ZB1->ZB1_STATUS == '9'
        if MsgYesNo('Confirma a cancelação?')
            
            aAdd(aVetSE2, {"E2_NUM",     000000001,         Nil})
            aAdd(aVetSE2, {"E2_PREFIXO", cPrefix,           Nil})
            aAdd(aVetSE2, {"E2_TIPO",    cTipo,             Nil})
            aAdd(aVetSE2, {"E2_NATUREZ", '001',             Nil})
            aAdd(aVetSE2, {"E2_FORNECE", cFornece,          Nil})
            aAdd(aVetSE2, {"E2_Loja",    cLoja,             Nil})
            aAdd(aVetSE2, {"E2_EMISSAO", dDataBase,         Nil})
            aAdd(aVetSE2, {"E2_VENCTO",  dDataBase + 7,     Nil})
            aAdd(aVetSE2, {"E2_VALOR",   ZB1->ZB1_VLRPRE,   Nil})

            msExecAuto({|x, y, z| FINA050(x, y, z)},aVetSE2,, 5)

            iF lMsErroAuto
                MostraErro()
            Else
                reclock('ZB1')
                ZB1->(ZB1_STATUS) := ''
                ZB1->(ZB1_STATUS) := cStatus
                msunlock()
                FWAlertInfo('Título excluido com sucesso!') 
            EndIF

        endif

    else
        MsgAlert('Só é possível efetivar um movimento aberto.')
    EndIF  
Return 

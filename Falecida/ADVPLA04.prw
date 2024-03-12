#include 'totvs.ch'
#include 'Parmtype.ch'
#INCLUDE 'FWMVCDEF.CH'

User Function ADVPLA04()

    Local oBrowse
    oBrowse := FWMBrowse():New()

    oBrowse:AddLegend("ZZ4->ZZ4_STATUS=='A'", "GREEN", 'Aberto')
    oBrowse:AddLegend("ZZ4->ZZ4_STATUS=='E'", "RED", 'Efetivado')
    oBrowse:AddLegend("ZZ4->ZZ4_STATUS=='P'", "YELLOW", 'Pago')    
    oBrowse:AddLegend("ZZ4->ZZ4_STATUS=='C'", "CANCEL", 'Cancelado')

    oBrowse:SetAlias('ZZ4')
    oBrowse:SetDescription('Cadastro de Movimentos')
    oBrowse:SetMenuDef('ADVPLA04')
    oBrowse:Activate()

Return

Static Function MenuDef()

    Local aRotina := {}

    ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.ADVPLA04' OPERATION 2 ACCESS 0
    ADD OPTION aRotina Title 'Incluir'    Action 'VIEWDEF.ADVPLA04' OPERATION 3 ACCESS 0
    ADD OPTION aRotina Title 'Alterar'    Action 'VIEWDEF.ADVPLA04' OPERATION 4 ACCESS 0
    ADD OPTION aRotina Title 'Excluir'    Action 'VIEWDEF.ADVPLA04' OPERATION 5 ACCESS 0
    ADD OPTION aRotina Title 'Imprimir'   Action 'VIEWDEF.ADVPLA04' OPERATION 8 ACCESS 0
    ADD OPTION aRotina Title 'Copiar'     Action 'VIEWDEF.ADVPLA04' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()

    Local oModel
    Local oStruZZ4 := FWFormStruct(1,"ZZ4")
    Local oStruZZ5 := FWFormStruct(1,"ZZ5")

    oModel := mpFormModel():new("MD_ZZ4")
    oModel:addFields('MASTERZZ4',,oStruZZ4)
    oModel:AddGrid('DETAILSZZ5','MASTERZZ4',oStruZZ5,{|oModel| U_ADVPL04A(oModel) })

    oModel:SetRelation('DETAILSZZ5', {{'ZZ5_FILIAL','xFILIAL("ZZ5")'}, {'ZZ5_CODZZ4', 'ZZ4_CODIGO'}}, ZZ5->(IndexKey(1)))

    oModel:setPrimaryKey({'ZZ4_FILIAL', 'ZZ4_CODIGO'})

    oModel:GetModel('DETAILSZZ5'):SetUniqueLine({'ZZ5_CODZZ2'})

    oModel:addCalc('QUANT', 'MASTERZZ4', 'DETAILSZZ5', 'ZZ5_TOTAL', 'QUANTIDADE', 'COUNT')

Return oModel

Static Function ViewDef()

    Local oModel := ModelDef()
    Local oView
    Local oStrZZ4 := FWFormStruct(2, 'ZZ4')
    Local oStruZZ5 := FWFormStruct(2, 'ZZ5')

    oView := fwFormView():new()
    oView:setModel(oModel)

    oView:addField('FORM_ZZ4', oStrZZ4, 'MASTERZZ4')
    oView:createHorizontalBox('BOX_FORM_ZZ4', 30)
    oView:setOwnerView('FORM_ZZ4','BOX_FORM_ZZ4')

    oView:createHorizontalBox('BOX_FORM_ZZ5', 60)
    oView:AddGrid('VIEW_ZZ5', oStruZZ5, 'DETAILSZZ5')
    oView:setOwnerView('VIEW_ZZ5', 'BOX_FORM_ZZ5')

    oView:EnableTitleView('VIEW_ZZ5', 'Itens do Movimento')
    
    oQuant := FWCalcStruct(oModel:GetModel('QUANT'))

    oView:createHorizontalBox('BOX_FORM_QUANT', 10)
    oView:addField('VIEW_QUANT', oQuant, 'QUANT')
    oView:setOwnerView('VIEW_QUANT', 'BOX_FORM_QUANT')

Return oView

User Function ADVPL04A(oModelZZ5)
    Local oModel := FWModelActive()
    Local oModelZZ4 := oModel:GetModel('MASTERZZ4')
    Local nTotal := 0
    Local i

    For i := 1 to oModelZZ5:Length()
        oModelZZ5:GoLine(i) 

        If oModelZZ5:IsDeleted()
            loop
        ENDIF

        nTotal += oModelZZ5:GetValue('ZZ5_TOTAL')

    Next
    
    //LoadValue preenche um campo
    oModelZZ4:LoadValue('ZZ4_TOTAL',nTotal)

Return .T.

User Function ADPLA04B()
    aVetSE2 := array(0)

    Local cPrefix := SuperGetMV('MS_PREFIXO', .F., 'ADV')
    Local cTipo := SuperGetMV('MS_TIPO', .F., 'NF')
    Local cNatureza := SuperGetMV('MS_NATUREZ', .F., 'DIVERSOS')
    Local cFornece := SuperGetMV('MS_FORNECE', .F., '000001')
    Local cLoja := SuperGetMV('MS_LOJA', .F., '01')

    Private lMsErroAuto := .F.

    aAdd(aVetSE2, {"E2_PREFIXO", cPrefix,           Nil})
    aAdd(aVetSE2, {"E2_TIPO",    cTipo,             Nil})
    aAdd(aVetSE2, {"E2_NATUREZ", cNatureza,         Nil})
    aAdd(aVetSE2, {"E2_FORNECE", cFornece,          Nil})
    aAdd(aVetSE2, {"E2_Loja",    cLoja,             Nil})
    aAdd(aVetSE2, {"E2_EMISSAO", dDataBase,         Nil})
    aAdd(aVetSE2, {"E2_VENCTO",  dDataBase + 30,    Nil})
    aAdd(aVetSE2, {"E2_VALOR",   ZZ4->ZZ4_TOTAL,    Nil})

    iF lMsErroAuto
        MostraErro()
    Else
        ApMsgInfo("T�tulo inclu�do com sucesso!")
    EndIF

    msExecAuto({|x, y, z| FINA050(x, y, z)},aVetSE2,, 3)

Return

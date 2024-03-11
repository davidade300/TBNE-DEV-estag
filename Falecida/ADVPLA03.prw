#include 'totvs.ch'
#include 'Parmtype.ch'
#INCLUDE 'FWMVCDEF.CH'

User Function ADVPLA03()

    Local oBrowse
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias('ZZ3')
    oBrowse:SetDescription('Cadastro de Contas')
    oBrowse:SetMenuDef('ADVPLA03')
    oBrowse:Activate()

Return

Static Function MenuDef()

    Local aRotina := {}

    ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.ADVPLA03' OPERATION 2 ACCESS 0
    ADD OPTION aRotina Title 'Incluir'    Action 'VIEWDEF.ADVPLA03' OPERATION 3 ACCESS 0
    ADD OPTION aRotina Title 'Alterar'    Action 'VIEWDEF.ADVPLA03' OPERATION 4 ACCESS 0
    ADD OPTION aRotina Title 'Excluir'    Action 'VIEWDEF.ADVPLA03' OPERATION 5 ACCESS 0
    ADD OPTION aRotina Title 'Imprimir'   Action 'VIEWDEF.ADVPLA03' OPERATION 8 ACCESS 0
    ADD OPTION aRotina Title 'Copiar'     Action 'VIEWDEF.ADVPLA03' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()

    Local oModel
    Local oStruZZ3 := FWFormStruct(1,"ZZ3",)

    oModel := mpFormModel():new("MD_ZZ3")
    oModel:addFields('MASTERZZ3',,oStruZZ3)
    oModel:setPrimaryKey({'ZZ3_FILIAL', 'ZZ3_CODIGO'})

Return oModel

Static Function ViewDef()

    Local oModel := ModelDef()
    Local oView
    Local oStrZZ3 := FWFormStruct(2, 'ZZ3')

    oView := fwFormView():new()
    oView:setModel(oModel)

    oView:addField('FORM_ZZ3', oStrZZ3, 'MASTERZZ3')
    oView:createHorizontalBox('BOX_FORM_ZZ3', 100)
    oView:setOwnerView('FORM_ZZ3','BOX_FORM_ZZ3')

Return oView

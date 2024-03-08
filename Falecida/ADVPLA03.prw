#include 'totvs.ch'
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


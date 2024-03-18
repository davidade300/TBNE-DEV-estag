#include 'totvs.ch'
#include 'fwmvcdef.ch'

User Function MVCSmpl

    Private aRotina := MenuDef()
    Private oBrowse := FWMBrowse():new()

    oBrowse:SetAlias('Z50')
    oBrowse:SetDescription('Tipos de contratos')
    oBrowse:setExecuteDef(4)
    oBrowse:AddLegend("Z50_TIPO == 'V' ", "BR_AMARELO", "VENDAS")
    oBrowse:AddLegend("Z50_TIPO == 'V' ", "BR_AMARELO", "VENDAS")
    oBrowse:AddLegend("Z50_TIPO == 'V' ", "BR_AMARELO", "VENDAS")


Return

Static Function MenuDef()

    Local aRotina := {}

    ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.MVCSmpl' OPERATION 2 ACCESS 0
    ADD OPTION aRotina Title 'Incluir'    Action 'VIEWDEF.MVCSmpl' OPERATION 3 ACCESS 0
    ADD OPTION aRotina Title 'Alterar'    Action 'VIEWDEF.MVCSmpl' OPERATION 4 ACCESS 0
    ADD OPTION aRotina Title 'Excluir'    Action 'VIEWDEF.MVCSmpl' OPERATION 5 ACCESS 0
    ADD OPTION aRotina Title 'Imprimir'   Action 'VIEWDEF.MVCSmpl' OPERATION 8 ACCESS 0
    ADD OPTION aRotina Title 'Copiar'     Action 'VIEWDEF.MVCSmpl' OPERATION 9 ACCESS 0
   
Return aRotina

Static Function ViewDef

    Local oView
    Local oModel
    Local oStruct

    //https://tdn.totvs.com/display/public/framework/FWFormStruct
    oStruct := FWFormStruct(2,'Z50')
    oModel := FWLoadModel('MVCSMPL')
    oView := fwFormView():new()
    //tudo que pode ser feito com uma interface gráfica \/
    //https://tdn.totvs.com/display/public/framework/FWFormView

    oView:SetModel(oModel)
    oView:addField('Z50MASTER', oStruct, 'Z50MASTER')
    oView:createHorizontalBox('BOXZ50', 100)
    oView:SetOwnerView('Z50MASTER','BOXZ50')

Return oView


Static Function modeldef
// responsável pela regra de négocio (validações/ gatilho/ ações de botões)

    Local oModel
    Local oStruct
    Local aTrigger
    Local bModelPre := {|x| fnModPre(x)}
    Local bModelPos := {|x| fnModPos(x)}
    Local bCommit :=   {|x| fnCommit(x)}
    Local bCancel :=   {|x| fnCancel(x)}

    oStruct := FWFormStruct(1,'Z50')
    // https://tdn.totvs.com/display/public/framework/MPFormModel
    //                          'identificadorDoModelo'      
    oModel  := mpFormModel():new('MODEL_MVCsmpl', bModelPre,bModelPos,bCommit,bCancel)

    aTrigger := FwStruTrigger('Z50_TIPO','Z50_CODIGO','U_GCTT001()',.F.,Nil,Nil,Nil,Nil)
    oModel:addTriggger(aTrigger[1],aTrigger[2],aTrigger[3],aTrigger[4])
    oStruct:setProperty('Z50_Tipo',MODEL_FIELD_WHEN,{|| INCLUI})

    oModel:addFields('Z50MASTER',,oStruct)
    oModel:SetDescription('Tipos de contratos')
    // não é obrigatório se estiver definida no sx2
    oModel:SetPrimaryKey({'Z50_FILIAL','Z50_CODIGO'})

Return oModel

// função de pre validacao de dados
Static Function fnModPre(oModel)

    Local lValid := .T.

Return lValid

//funcao de validacao final do modelo de dados, equivalente a tudook
Static Function fnModPos(oModel)

    Local lValid := .T.

Return lValid

//funcao para gravacao dos dados
Static Function fnCommit(oModel)

    Local lCommit := FWFormCommit(oModel)

Return lCommit

//funcao para validacao do cancelamento dos dados
Static Function fnCancel

Local lCancel := FWFormCancel(oModel)

Return lCancel

//Funcão para execucao do gatilho de codigo
Function U_GCTT001

    Local cNovoCod := ''
    Local cAliasSQL := ''
            //  gera um alias aleatorio para ser associado a query sql 
    Local oModel := FWModelActive()
    Local nOperation := 0

    nOperation := oModel:getOperation()

    IF (nOperation == 3 .or. nOperation == 9)
        cNovoCod := oModel:getModel('Z50MASTER'):getValue('Z50_CODIGO')
    //   cNovoCod := M->Z50_CODIGO
        Return cNovoCod
    ENDIF

    cAliasSQL := getNextAlias()

        BeginSql Alias cAliasSQL
            SELECT
                COALESCE(MAX(Z50_CODIGO), '00') Z50_CODIGO
            FROM %table:Z50% Z50
            WHERE Z50.%notdel%
            AND Z50_FILIAL = %exp:xFILIAL('Z50')%
            AND Z50_TIPO = %exp:M->Z50_TIPO%
        EndSql

    (cAliasSQL)->(DBEval({||cNovoCod := AllTrim(Z50_CODIGO)}), DBCloseArea())

    IF cNovoCod == '00'
        cNovoCod := M->Z50_TIPO + '01'
    ELSE
        cNovoCod := soma1(cNovoCod)
    ENDIF

Return cNovoCod

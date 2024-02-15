#INCLUDE 'Protheus.ch'
#INCLUDE 'Parmtype.ch'
#INCLUDE 'FWMVCDEF.ch'
#INCLUDE 'topconn.ch'
#INCLUDE 'TbIconn.ch'
#INCLUDE 'Rwmake.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} CAEA0069
Cadastro de Locais
@author  Jerry Junior
@since   05/03/2020
@version 1.0
@type function
/*/
//-------------------------------------------------------------------
User Function CAEA0069()
    Local oBrowse
    Private cString := 'Z80'

    u_GeraLogPrw(, 'CAEA0069', 'CAEA0069')
    //Montagem do Browse principal
    oBrowse := FWMBrowse():New()

    //Define alias principal
    oBrowse:SetAlias('Z80')
    oBrowse:SetDescription('Cadastro de Local Custom')
    oBrowse:SetMenuDef('CAEA0069')

    //Ativa a tela
    oBrowse:Activate()
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Retorna o menu principal
@author  Jerry Junior
@since   05/03/2020
@version 1.0
@type function
@return array, Array com os dados para os botoes do browse
/*/
//-------------------------------------------------------------------
Static Function MenuDef
    Local aRotina := {}

    //Opcoes do Menu
    aAdd( aRotina, { 'Visualizar' , 'VIEWDEF.CAEA0069' , 0, 2, 0, NIL } )
    aAdd( aRotina, { 'Incluir'    , 'VIEWDEF.CAEA0069' , 0, 3, 0, NIL } )
    aAdd( aRotina, { 'Alterar'    , 'VIEWDEF.CAEA0069' , 0, 4, 0, NIL } )
    aAdd( aRotina, { 'Excluir'    , 'VIEWDEF.CAEA0069' , 0, 5, 0, NIL } )

    //Exemplo de filtro para exibir a tela
    //DbSelectArea('Z80')
    //SET FILTER TO Z80->Z80_COD == 999

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Construcao do modelo de dados
@author  Jerry Junior
@since   05/03/2020
@version 1.0
@type function
@return object, Retorna o objeto do modelo de dados
/*/
//-------------------------------------------------------------------
Static Function ModelDef()
    Local oModel
    Local oStruZ80 := FWFormStruct(1,'Z80')

    //Cria o formulario do modelo  - GravaDados: { |oModel| fGrvDados( oModel ) }
    oModel := MPFormModel():New('CAEA069', /*bPreValidacao*/, { |oModel| fTudoOk(oModel) }, /* GravaDados */, /*bCancel*/ )

    //Cria a estrutura principal(Z80)
    oModel:addFields('MASTERZ80',,oStruZ80)

    //Adiciona a chave
    oModel:SetPrimaryKey({'Z80_FILIAL', 'Z80_LOCAL'})

    //AntesDeTudo
    oModel:SetVldActivate( {|oModel| fAntesTd(oModel) } )
Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Monta o view do modelo
@author  Jerry Junior
@since   05/03/2020
@version 1.0
@type function
/*/
//-------------------------------------------------------------------
Static Function ViewDef
    Local oView
    Local oModel := ModelDef()
    Local oStrZ80 := FWFormStruct(2, 'Z80')

    oView := FWFormView():New()
    oView:SetModel(oModel)

    //Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
    oView:AddField('FORM_Z80' , oStrZ80,'MASTERZ80' )

    // 30% cabec e 70% para as abas
    oView:CreateHorizontalBox('SUPERIOR', 100)

    // Relaciona o ID da View com o 'box' para exibicao
    oView:SetOwnerView('FORM_Z80', 'SUPERIOR')
Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} fAntesTd
(PE AntesDeTudo) Funï¿½ï¿½o para a abertura da tela.
@author  Jerry Junior
@since   05/03/2020
@version 1.0
@type function
/*/
//-------------------------------------------------------------------
Static Function fAntesTd(oModel)

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} fTudoOk
(PE TudoOk) Validacao da tela.
@author  Jerry Junior
@since   05/03/2020
@version 1.0
@type function
/*/
//-------------------------------------------------------------------
Static Function fTudoOk(oModel)
    Local lRet       := .T.
    Local aSaveLines := FWSaveRows()

    FWRestRows(aSaveLines)
Return lRet



User Function CAEA069A()
    Local aLinha    := {}
    Local cLog := ''
	If Empty(FunName())
		PREPARE ENVIRONMENT EMPRESA '01' FILIAL 'CAEADC0001'
	EndIf
    oFile := FWFileReader():New('c:\temp\local_sem_coord.CSV')
    If (oFile:Open())
		SNL->(DbSetOrder(1))		
        While (oFile:hasLine())            
            //Le linha atual
            cBuffer := oFile:GetLine()
			// Preencho cada linha do aCampos com o conjunto de campos de 1 registro das notas
            aLinha := StrTokArr2(cBuffer, ';',.T.)
            if SNL->(dbseek(aLinha[1]+aLinha[2]))
                If (SNL->NL_YLAT<>0 .Or. SNL->NL_YLNG<>0)
                    cLog += 'Local já com coordenada > ' + SNL->NL_FILIAL + ' - ' + SNL->NL_CODIGO + CRLF
                    cLog += '    coordenada atual > ' + cvaltochar(SNL->NL_YLAT) + ', ' + cvaltochar(SNL->NL_YLNG) + CRLF
                    cLog += '    coordenada no arquivo > ' + aLinha[3] + ', ' + aLinha[4] + CRLF
                    loop
                endif
            else
                cLog += 'Não encontrado > ' + aLinha[1] + ' - ' + aLinha[2] + CRLF
                loop
            endIf
            RecLock('SNL', .F.)				
				SNL->NL_YLAT	:= val(aLinha[3])
				SNL->NL_YLNG	:= val(aLinha[4])
			SNL->(MsUnLock())        

        EndDo
        oFile:Close()
        memowrite('c:\temp\log_local.txt', cLog)
    EndIf
    
    
Return

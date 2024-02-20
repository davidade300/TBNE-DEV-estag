#include 'totvs.ch'

/*/{Protheus.doc} NFornec
(long_description)
@type user function
@author David Aderaldo
@since 19/02/2024
@version 1.0
/*/
User Function NFornec

    Local oFrncdr
    aDados := {}

    IF !pergunte('ZNOVOCGC')
        Return
    ENDIF


    oFrncdr := pessoa():new()
    oFrncdr:cpf_cnpj := MV_PAR01
    oFrncdr:get_dados_cadastrais()

    
    cCodigo := getSxeNuM('SA2','A2_COD')

    
    While .T.

        SA2->(dbSetOrder(1),dbSeek(xFilial(alias())+cCodigo))

        IF Found()

            confirmSX8()
            cCodigo := getSxeNuM('SA2','A2_COD')
            Loop
        EndIf

        Exit

    End


    cNome := LEFT(oFrncdr:nome,tamSX3('A2_NOME')[1])
    cNomeRed := LEFT(oFrncdr:nome_reduzido,tamSX3('A2_NREDUZ')[1])
    cEndereco := LEFT(oFrncdr:Endereco,tamSX3('A2_END')[1])
    cBairro := LEFT(oFrncdr:bairro,tamSX3('A2_BAIRRO')[1])
    cEstado := LEFT(oFrncdr:uf,tamSX3('A2_EST')[1])
    cCodMun := LEFT(oFrncdr:cod_ibge,tamSX3('A2_COD_MUN')[1])
    cCidade := LEFT(oFrncdr:cidade,tamSX3('A2_MUN')[1])
    cEmail := LEFT(oFrncdr:email, tamSX3('A2_EMAIL')[1])
    dDataNasc := oFrncdr:data_nascimento
     

    //32.561.380/0001-20

    AAdd(aDados,{'A2_COD',cCodigo,NIL})
    AAdd(aDados,{'A2_LOJA',"01",NIL})
    AAdd(aDados,{'A2_TIPO',"J",NIL})
    AAdd(aDados,{'A2_CGC', MV_PAR01, NIL})
    AAdd(aDados,{'A2_NOME',cNome,NIL})
    AAdd(aDados,{'A2_NREDUZ',cNomeRed,NIL})
    AAdd(aDados,{'A2_END',NIL})
    AAdd(aDados,{'A2_EST',cEstado,NIL})
    AAdd(aDados,{'A2_BAIRRO',cBairro,NIL})
    AAdd(aDados,{'A2_COD_MUN',cCodMun,NIL})
    AAdd(aDados,{'A2_MUN',cCidade,NIL})
    AAdd(aDados,{'A2_EMAIL',cEmail,NIL})
    AAdd(aDados,{'A2_DTNASC',dDataNasc,NIL})

    lMsErroAuto := .F.

    msExecAuto({|x| mata020(x,3)},aDados)
    

    IF lMsErroAuto
        mostraErro()
        return
    ENDIF

    confirmSX8()

Return 

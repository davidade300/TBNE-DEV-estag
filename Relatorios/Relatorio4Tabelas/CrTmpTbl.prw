#include 'Totvs.ch'

/*/{Protheus.doc} CriaArea
(long_description)
@type user function
@author David
@since 09/02/2024
@version version
@see (links_or_references)
/*/
User Function CriaArea

    rpcSetEnv('99','01')

        aCampos := {{"ENTIDADE","C",3,0},{"CODIGO","C",6,0},{"LOJA","C",2,0},{"NOME","C",30,0}}
        // tanto o arquivo quanto o alias terao o mesmo nome
                  //Cria o arquivo temporario
        cArqTrab := criatrab(aCampos,.T.)
        DBUseArea(.T.,,cArqTrab,cArqTrab,.T.,.F.)
        DBCreateIndex(cArqTrab+'1',"CODIGO+LOJA+ENTIDADE",{|| CODIGO+LOJA+ENTIDADE})
        DBSetIndex(cArqTrab+'1')


        SD1->(DBSetOrder(1))

        while .Not. SA1->(Eof())

            reclock(cArqTrab,.T.)
                CODIGO := SA1->A1_COD
                LOJA := SA1->A1_LOJA
                NOME := SA1->A1_NOME
                ENTIDADE := 'SA1'
            msunlock()
                
            SA1->(DBSkip())

        Enddo

    DBSelectArea('SA2')
    DBSetOrder(1)

    // como agora o arquivo � o SA2, n�o � necessario inidicar que o eof � para a SA2
    while .Not. eof()

        (cArqTrab)->(reclock(cArqTrab,.T.))

            (cArqTrab)->CODIGO := A2_COD
            (cArqTrab)->LOJA := A2_LOJA
            (cArqTrab)->NOME := A2_NOME
                                    // retorna o alias da area de trabalho que esta definida como principal
            (cArqTrab)->ENTIDADE := alias()

        (cArqTrab)->(msunlock())

        DBSkip()

    Enddo

    (cArqTrab)->(DBCloseArea())

    if File('\system\' + cArqTrab + '.dtc')
        FErase('\system\' + cArqTrab + '.dtc')
    Endif

     if File('\system\' + cArqTrab + '1.cdx')
        FErase('\system\' + cArqTrab + '1.cdx')
    Endif

    rpcClearEnv()

Return

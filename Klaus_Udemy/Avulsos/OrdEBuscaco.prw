#include 'totvs.ch'

User Function 2OrdEBusca

    rpcSetEnv('99','01')

    dbSelectArea("SA2")
    dbSetOrder(retOrder("SA2","A2_FILIAL+A2_COD"))
    cChaveIndice := indexKey(retOrder("SA2", "A2_FILIAL+A2_COD"))
    cChaveBusca:= '  000001' // 2 espacos vazios para a filial que pode ser qualquer e 000001 para o fornecedor 5
    //recebe uma chave de busca e busca por esse registro
    //a chave de busca esta diretamente ligada ao indice que está ativo
    dbSeek(cChaveBusca)
    dbSeek(cChaveBusca,.T.) // posiciona no registro que mais se aproxima da chave de busca
    //cNome := SA2->A2_NOME

    // avança para o proximo registro
    dbSkip()
    dbSkip(2)
    dbSkip(-3)

    //Posiciona a tabela corrente em um determinado registro de acordo com o recno
    dbGoTo(9)
    dbGoTo(4)
    dbGoTo(10)
    dbGoTo(2)

    //posiciona no primeiro registro de uma area de trabalho para o índice que está definido no momento
    dbGoTop()
    
    //posiciona no ultimo registro de uma area de trabalho para o índice que está definido no momento
    dbGoBottom()

    SA1->(dbSetOrder(2),dbSeek(SA2->(A2_FILIAL+A2_NOME)))

    rpcClearEnv()

Return

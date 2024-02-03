#include 'Totvs.ch'

User Function OrdEBusca

    RpcSetEnv('99','01')

    dbSelectArea("SA2")

    // vai para a area de trabalho que está ativa e altera seu índice
    //dbSetOrder(11)
    dbSetOrder(retOrder("SA2", "A2_FILIAL+A2_NOME"))
    //EM CASO DE TABELAS PADRÃO, A FUNÇÃO ACIMA É MELHOR POIS EM CASOS DE PATCH, INDICES
    //CUSTOMIZADOS PODEM SER REALOCADOS PARA O FINAL DA FILA DE INDICES, ALTERANDO SUA POSIÇÃO

    // na area de trabalho SA1 // é possível abrir a area de trabalho assim
    //SA1->

    // na area de trabalho SA1 agrupe
    //SA1->()

    //retorna a ordem de um índice em uma area de trabalho
    //args("areadetrabalho","indice")
    retOrder("SA2", "A2_FILIAL+A2_CONTA")

    //na area de trabalho SA1 agrupe pela ordenação do indice 1
    SA1->(dbSetOrder(1), dbSeek(' 000004'),A1_NOME)
    // /\ dessa forma é possível abrir uma área de trabalho sem alterar a aréa de trabalho ativa
    // tudo o que está dentro dos parenteses será execultado para aquela area de trabalho sem alterar a ativa


    cNome := SA1->(dbSetOrder(retOrder("SA1", "A1_FILIAL+A1_COD")), dbSeek(' 000007'),A1_NOME)

    

    rpcClearEnv()

return

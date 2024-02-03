#include 'Totvs.ch'

User Function OrdEBusca

    RpcSetEnv('99','01')

    dbSelectArea("SA2")

    // vai para a area de trabalho que est� ativa e altera seu �ndice
    //dbSetOrder(11)
    dbSetOrder(retOrder("SA2", "A2_FILIAL+A2_NOME"))
    //EM CASO DE TABELAS PADR�O, A FUN��O ACIMA � MELHOR POIS EM CASOS DE PATCH, INDICES
    //CUSTOMIZADOS PODEM SER REALOCADOS PARA O FINAL DA FILA DE INDICES, ALTERANDO SUA POSI��O

    // na area de trabalho SA1 // � poss�vel abrir a area de trabalho assim
    //SA1->

    // na area de trabalho SA1 agrupe
    //SA1->()

    //retorna a ordem de um �ndice em uma area de trabalho
    //args("areadetrabalho","indice")
    retOrder("SA2", "A2_FILIAL+A2_CONTA")

    //na area de trabalho SA1 agrupe pela ordena��o do indice 1
    SA1->(dbSetOrder(1), dbSeek(' 000004'),A1_NOME)
    // /\ dessa forma � poss�vel abrir uma �rea de trabalho sem alterar a ar�a de trabalho ativa
    // tudo o que est� dentro dos parenteses ser� execultado para aquela area de trabalho sem alterar a ativa


    cNome := SA1->(dbSetOrder(retOrder("SA1", "A1_FILIAL+A1_COD")), dbSeek(' 000007'),A1_NOME)

    

    rpcClearEnv()

return

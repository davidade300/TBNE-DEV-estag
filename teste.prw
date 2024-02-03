#include 'totvs.ch'

User Function Teste

    RpcSetEnv( "99","01")

    Local nQuantidadeDeRegistros := 0

    // bof() --> Indica que o ponteiro da area de trabalho está posicionado no inicio do arquivo
    // eof() --> inidica que o ponteiro da area de trabalho está posicionado no final do arquivo

    SA2 -> (dbSetOrder(1),dbGoTop())

    RPcClearEnv()

Return 

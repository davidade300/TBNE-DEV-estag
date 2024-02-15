#include 'totvs.ch'

User Function SelectArea

    // prepara o ambiente sem entrar no protheus
    RpcSetEnv('99','01','admin',' ','FAT','SelectArea')

    // seleciona uma area para ser padrao a ser utilizada  
    dbSelectArea("SA1")
    dbSelectArea("SB1")

    // Retorna o identificador de controle da area de trabalho
    nAreaSA1 := select("SA1")

    dbSelectArea(nAreaSA1)

    // Encerra o ambiente
    rpcClearEnv()

return

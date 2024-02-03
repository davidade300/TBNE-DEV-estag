#include 'Totvs.ch'

user Function UseArea

    RpcSetEnv('99','01','admin',' ','FAT','UseArea')

    lNewArea := .T.
    cDriver := 'TOPCONN'

    // retorna o nome fisico da tabela para o grupo de empresas que esta em uso
    cArquivo := retSqlName("SA1")

    cAlias := 'SA1'
    lShared := .T.
    lReadOnly := .F.

    // funciona de forma semelhante ao selectArea, porém de forma mais completa.
    //dbUseArea(lNewArea,cDriver,cArquivo,(cAlias),lShared,lReadOnly)
    // os parenteses do cAlias servem para anular as aspas, pois aqui,
    // o alias deve ser inserido sem aspas

    // comando para usar uma tabela
    dbSelectArea("SA1") //USE SA1990 ALIAS SA1 SHARED NEW VIA "TOPCONN"

    dbSelectArea("SB1")

    cIndex1 := cArquivo +'1'
    cIndex2 := cArquivo +'2'

    dbSetIndex(cIndex1)
    dbSetIndex(cIndex2)

    rpcClearEnv()

return

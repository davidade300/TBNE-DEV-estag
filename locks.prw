#include 'Totvs.ch'

User Function locks

    rpcSetEnv('99','01')

    //reclock() --> Utilizado para reservar um registro para altera��o ou para indicarque sera executada uma inclusao
    //msunlock() --> Utilizado para destravar e confirmar a inclus�o/altera��o do registro

    ZA1->(dbSetOrder(1),dbGoTop())

    while .not. ZA1->(eof())

        ZA1->(reclock("ZA1",.F.))
        // .T. indica inclus�o
        // .F. indica altera��o
            ZA1->ZA1_NOME := LEFT(ZA1->ZA1_NOME,AT(" ",ZA1->A2_NOME))
        ZA1->(msunlock())
        //destrava o registro ap�s altera��o

        ZA1->(dbSkip())
    enddo

    // dbCloseArea --> Indica que a area de trabalho deve ser encerrada
    ZA1->(dbCloseArea())
    


    rpcClearEnv()

Return

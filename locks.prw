#include 'Totvs.ch'

User Function locks

    rpcSetEnv('99','01')

    //reclock() --> Utilizado para reservar um registro para altera��o ou para indicarque sera executada uma inclusao
    //msunlock() --> Utilizado para destravar e confirmar a inclus�o/altera��o do registro

    SA2 ->(dbSetOrder(1),dbGoTop())

    while .not. SA2->(eof())

        SA2->(reclock("SA2",.F.))
        // .T. indica inclus�o
        // .F. indica altera��o
            SA2->A2_NREDUZ := LEFT(SA2->A2_NOME,AT(" ",SA2->A2_NOME))
        SA2->(msunlock())
        //destrava o registro ap�s altera��o

        SA2->(dbSkip())
    enddo

    // dbCloseArea --> Indica que a area de trabalho deve ser encerrada
    SA2->(dbCloseArea())
    


    rpcClearEnv()

Return

#include 'Totvs.ch'

User Function locks

    rpcSetEnv('99','01')

    //reclock() --> Utilizado para reservar um registro para alteração ou para indicarque sera executada uma inclusao
    //msunlock() --> Utilizado para destravar e confirmar a inclusão/alteração do registro

    SA2 ->(dbSetOrder(1),dbGoTop())

    while .not. SA2->(eof())

        SA2->(reclock("SA2",.F.))
        // .T. indica inclusão
        // .F. indica alteração
            SA2->A2_NREDUZ := LEFT(SA2->A2_NOME,AT(" ",SA2->A2_NOME))
        SA2->(msunlock())
        //destrava o registro após alteração

        SA2->(dbSkip())
    enddo

    // dbCloseArea --> Indica que a area de trabalho deve ser encerrada
    SA2->(dbCloseArea())
    


    rpcClearEnv()

Return

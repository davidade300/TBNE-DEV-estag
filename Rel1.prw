#include 'Totvs.ch'

User Function Rel1()
        //gera uma tela com opcao sim(.T.) ou nao (.F.)
    If MsgYesNo("Deseja gerar um relatorio em txt?")
        geraArq()
    Else
        Alert("Cancelada pelo usuario")
    EndIf

Return Nil


// Funcao que gera arquivos ".txt"
Static Function geraArq()

    // diretorio onde o relatorio sera salvo
    Local cDir := "D:\"
    // nome e extensao do arquivo do relatorio
    Local cArq := "Relatorio_teste.txt"
    // FCreate --> Cria um arquivo vazio no disco, para escrita em modo exclusivo
    Local nHandle := FCreate(cDir+cArq)

    // verifica logicamente se nHandle criou o arquivo
    // se < 0 o arquivo não foi criado
    If nHandle < 0

        MsgAlert("Erro ao criar arquivo","Erro")

    Else
        
        For nlinha := 1 to 100
            //StrZero adiciona zeros a esquerda
            FWrite(nHandle,"Gravando a linha "+ StrZero(nlinha,3)+CRLF)
        Next nlinha
        // fecha  arquivo aberto
        FClose(nHandle)

    EndIf

    if File("D:\Relatorio_teste.txt")
        MsgInfo("Arquivo criado com sucesso")
    Else
        MsgAlert("Não foi possivcel criar o arquivo","Alerta")
    Endif

return

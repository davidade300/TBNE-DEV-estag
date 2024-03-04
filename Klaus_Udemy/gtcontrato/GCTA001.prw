#include 'totvs.ch'

Function U_GCTA001
    
    Local nOpcPad := 4
    Local aLegenda := {}

    // titulo da tela
    Private cCadastro := 'Cadastro de tipos de contratos'
    //monta a estrutura de rotina
    Private aRotina := {}

    AAdd(aLegenda,{"Z50_TIPO == 'V'", "BR_AMARELO"})
    AADD(aLegenda,{"Z50_TIPO == 'C'","BR_LARANJA" })
    AADD(aLegenda,{"Z50_TIPO == 'S'", "BR_CINZA"  })
   

    AADD(aRotina, { "Pesquisar", "AxPesqui", 0, 1        })
    AADD(aRotina, { "Visualizar", "AxVisual"  , 0, 2     })
    AADD(aRotina, { "Incluir"      , "AxInclui"   , 0, 3 })
    AADD(aRotina, { "Alterar"     , "AxAltera"  , 0, 4   })
    AADD(aRotina, { "Excluir"     , "AxDeleta" , 0, 5    })
    AADD(aRotina,{"Legendas", "U_GCTA001L",0,6           })

    DBSelectArea("Z50")
    DBSetOrder(1)

    mBrowse(,,,,Alias(),,,,,nOpcPad,aLegenda)

Return

Function U_GCTA001L

    Local aLegenda := array(0)

    AAdd(aLegenda,{"BR_AMARELO", "Contrato de Vendas" })
    AAdd(aLegenda,{"BR_LARANJA", "Contrato de Compras"})
    AAdd(aLegenda,{"BR_CINZA", "Sem integração"       })

Return brwLegenda("Tipos de Contratos", "Legenda", aLegenda)

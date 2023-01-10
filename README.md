## Estudos em ADVPL

I - Semana_1

    I - Aprendenmos as estruturas basicas do ADVPL, como tipos de variaveis e funções numericas.

II - Semana_2

    I - Tive um desafio de usar tudo que foi aprendido na semana_1 para testar meu conhecimento e aprendizado.

III - Semana_3_4_5_6

        -- No Prazo --
        Semana_3 : Criamos uma tabela na base de dados com chaves unicas e indices obrigatorios.

        -- No Prazo --
        Semana_4 : Criamos uma user function com o nome IMPOR01F que usamos para pegar dados de
            uma planilha em EXCEL para enserir na tabela que criamos na semana_3.

        -- No Prazo --
        Semana_5 : Criamos um MVC simples com o nome CRMA01FF para nos podemos usar a user function
            que ciramos na semana_4 e como a opção de visualizar os dados de cada cliente.

        -- No Prazo --
        Semana_6 -> Relatorio simples para imprimir todos os clientes de forma como foi salva no 
            bando de dados senão imprimir o total de clientes por país

IV - Semana_7

        I - Aprender oque é: -> Somente Estudar
            1 - QueryParam -> São os paramentros que passaresmos case sejam necessarios para o objetivo
            
            2 - HeaderParam -> Usamos para especificar qual o tipo de retorno ou consulta que será efetuada

            3 - Oauth
                I : Maneira de acesso regular a API que -> Concede uma autorização, após isso quando foi permitido o acesso
                    o usuario/cliente nao precisa está permitindo o acesso que o aplicativo realize chamadas à API

                II : Atualização automática de tokens expirados ->  Com isso quando o token expirado ele vai ser substituido
                    por um novo mas quando você fizer a chamada da API novamente e entao será substituido pelo novo
                
                III : Autorização com a senha do usuário -> Quando o usuario nao conseguir acessar a conta ou esquecer a senha
                    ele vai descripitografar sua token relacionada e gerar uma nova quando for inserido um novo usuario

            4 - Basic Autentication
            
            5 - metodos assíncrono async/await (StartJob)
                I - Executa uma rotina em uma segunda thread sem interface.

V - Semana_8

        I - REST API GET de arquivos( *.PDF e *.IMG )

        II - Pegar no minimo 10 arquivos e jogar dentro de uma pasta criada na protheus_data

        III - Primeira API litar um json todos os arquivos dentro da pasta

        IV - Segunda API retorna um arquivo no response passando na URL o nome do arquivo

VI - Semana_9

        I - Aprendendo como a desenvolver um API REST GET

        II - Retornando campos especificos da tabela de precos da DA1

VII - Semana_10

    I - Fazendo uma manutenção de uma API usando os tipos UPDATE(PUT)

    II - Verificando se a query que foi passada for diferente a true se nao segui a rotina padrao

VIII - Semana_11

    I - Aprendendo a fazer o envio de email usando o ambiente de configuração usando o Email/Proxy

    II - Tambem ja aprendendo a como usar Class e Methods no ADVPL

IX - Semana_12

    I - Aprendendo a usar Class, Method e DATA no protheus para usar futuramente em projetos
        Obs: O objetivo foi criar uma calculadora usando todos methodos passados a cima

X - Semana_13

    I - Primeiro criei um MVC para parte de contratos com produtos relacionados a esse contrato
        Obs: Gestão de contratos que será usada nas movimentações que utilizara os produtos
        consumindo o saldo disponivel
    
    II - Após isso criei mais um MVC para criação das movimentações e com isso atualizando 
        os status que podem a ser passados como: Aberto, Em andamento e Fechado
        Obs: Os status de gestão de contratos serão atualizados em tempo de executação
        de movimentação

    III - Como etapa final criei um relatorio que retorna todos os contrato e em baixo dos
    contratos estarão todas as movimentações relacionadas a esses contratos

XI - Semana_14

    I - Criado uma manipulação de erro e validação de dois campos customizados quando o produtos
    estiver usando o lote e quando não estiver, ira prosegui ao criar como o Pedido de venda

## Estudos em TLPP

Aprendendo a criar uma API em TLPP para trazer todos os clientes sem nenhum  filtro de campos
mas quando tiver podera trazer os campos de ordem aleatoria desde que os campo de "codigo" e
"loja" nao deixa de estar no filtro
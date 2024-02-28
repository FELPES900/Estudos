## ISSUES ##

<h1> API de Solicitação de Compras + Aprovação da Solicitação</h1>

I - Está API sera desenvolvida em TLPP usando arquitetura [SOA](https://www.treinaweb.com.br/blog/voce-sabe-o-que-e-arquitetura-orientada-a-servicos-soa) e a Class [FWAdapterBaseV2](https://tdn.totvs.com/display/public/framework/09.+FWAdapterBaseV2)

    1. CONTROLLER
        |
        |__Custom.Controller.MATA110.tlpp
    
    2. Data
        |
        |__Custom.Data.PedSolictacao.tlpp
        |__Custom.Data.Solicitacoes.tlpp

    3. Service
        |
        |__Custom.Service.MATA110.tlpp

    4. Static
        |
        |__Custom.Static.MATA110.tlpp

II - Routes: Aqui ira ser mostrado como as rotas estarão funcionando, junto disso está sendo utilizado o [tenantid](https://devforum.totvs.com.br/2331-tenantid-somente-com-empresa-filial-aleatoria) dentro do Header (Ex: header->tenantid - value->99,01) para falar a filial e empresa que será logado no sistema

1. Visualização de todas as solicitações
    ```JSON
    {
        "result" : true,
        "code" : 200,
        "response" : {
            "items" : [
                {
                    "c1_filial": "00",
                    "c1_num": "000001",
                    "c1_cc": "11101",
                    "c1_conta": "0000001",
                    "c1_itemcta": "TESTE0001",
                    "c1_clvl": "",
                    "c1_obs": "TESTE0001",
                    "c1_datprf": "01012024",
                    "c1_fornece": "000001",
                    "c1_loja": "01",
                    "c1_emissao": "01012024",
                    "c1_quant": 1,
                    "c1_preco": 0,
                    "c1_total": 0,
                    "cr_num": "",
                    "cr_user": "",
                    "cr_status": "",
                    "cr_datalib": ""
                }
            ]
        }
    }
    ```
2. Pedidos da Solicitação
    ```JSON
    {
        "result" : true,
        "code" : 200,
        "response" : {
            "items" : [
                {
                    "c1_item": "0001",
                    "c1_produto": "000001",
                    "c1_descri": "PRODUTOTESTE0001",
                    "c1_quant": 2,
                    "c1_preco": 0,
                    "c1_total": 0,
                    "c1_itemcta": "TESTE0001",
                    "c1_conta": "0000001",
                    "c1_fornece": "000001",
                    "c1_cc": "11101"
                }
            ]
        }
    }
    ```
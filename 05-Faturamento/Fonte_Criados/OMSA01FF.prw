#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} OMSA01FF
Executando função para usar a função MsExecAuto
Metodos de Inclusão, Alteração e Exclusão

EXTRA: Colocar dados chumbados caso quiser

@type function
@version 12.1.2210
@author Felipe Fraga
@since 07/06/2023
@return variant, return_lRet
/*/
User Function OMSA01FF()

	// Pedido de venda --> Table SC5
	// Criando um pedido de venda passando dados chumbados
	Local cSC5CEnt := "" //Cli.Entrega
	Local cSC5Cli  := "" //Cliente
	Local cSC5CPag := "" //Cond. Pagto
	Local cSC5Fili := "" //Filial
	Local cSC5LEnt := "" //Loja Entrega
	Local cSC5Loja := "" //Loja
	Local cSC5Num  := "" //Numero
	Local cSC5TCli := "" //Tipo Cliente
	Local cSC5Tipo := "" //Tipo Pedido

	// Itens do pedido de venda --> SC6
	/*
	[1]  -- Cod. Fiscal
	[2]  -- Cliente
	[3]  -- Filial
	[4]  -- Entrega
	[5]  -- Descricao
	[6]  -- Int. Rot.
	[7]  -- Item
	[8]  -- Produto
	[9]  -- Quantidade
	[10] -- Prc Unitario
	[11] -- Armazem
	[12] -- Loja
	[13] -- Num. Pedido
	[14] -- Rateio
	[15] -- Unidade
	[16] -- Vlr.Total
	[17] -- Tipo Saida
	[18] -- Tipo Op
	[19] -- Ent.Sugerida
	[20] -- Tp. Prod.
	*/
	Local aItemPed := ;
		{;
		{;
		"6107",;
		"000001",;
		"01",;
		Date(),;
		"MONITOR ",;
		"1",;
		"01",;
		"000000000000001",;
		100.00,;
		1000.00,;
		"01",;
		"01",;
		"000001",;
		"2",;
		"UN",;
		100000.00,;
		"501",;
		"F",;
		DATE(),;
		"1";
		};
		}

	Local lRet  := .T.
	Local nX    := 0

	if SELECT("SX2") == 0 //Para ser executado pelo usuario
		PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
	endif

	DbSelectArea("SC5") // Pedido de Venda
	DbSelectArea("SC6")	// Itens do pedido de vneda

	if (!SC5->(MsSeek(xFilial("SC5")) + aPdv[1]))
		for nX := 1 to Len(aItemPed)
			if ((!SC6)->() .And. nX == Len(aItemPed))

			endif
		next
	endif

	if SELECT("SX2") > 0
		RESET ENVIRONMENT
	endif

Return lRet

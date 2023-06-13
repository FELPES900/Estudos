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
User Function OMSA02FF()

	Local aPdv := {;
		{"C5_FILIAL" ,"01"},;	// [1] -- Filial
	{"C5_NUM"    ,"000001"},;	// [2] -- Cliente
	{"C5_TIPO"   ,"N"},;	 	// [3] -- Tipo Pedido
	{"C5_CLIENTE","000001"},; 	// [4] -- Cliente
	{"C5_LOJACLI","01"},;	 	// [5] -- Loja
	{"C5_CLIENT" ,"000001"},;	// [6] -- Cli.Entrega
	{"C5_LOJAENT","01"},; 		// [7] -- Loja Entrega
	{"C5_TIPOCLI","F"},; 		// [8] -- Tipo Cliente
	{"C5_CONDPAG","001"};	 	// [9] -- Cond. Pagto
	}
	Local cC6Filial := ""
	Local aItemPed := {;
		{;
		{"C6_CF"	 ,"6107"}	     ,; // 	[1]  -- Cod. Fiscal
	{"C6_CLI"	 ,"000001"}		 	,; // 	[2]  -- Cliente
	{"C6_FILIAL" ,cC6Filial}		,; // 	[3]  -- Filial
	{"C6_ENTREG" ,Date()}			,; // 	[4]  -- Entrega
	{"C6_DESCRI" ,"MONITOR"}		,; // 	[5]  -- Descricao
	{"C6_INTROT" ,"1"}				,; // 	[6]  -- Int. Rot.
	{"C6_ITEM"	 ,"01"}			 	,; // 	[7]  -- Item
	{"C6_PRODUTO","000000000000001"},; // 	[8]  -- Produto
	{"C6_QTDVEN" ,100.00}			,; // 	[9]  -- Quantidade
	{"C6_PRCVEN" ,1000.00} 		 	,; // 	[10] -- Prc Unitario
	{"C6_LOCAL"  ,"01"}			 	,; // 	[11] -- Armazem
	{"C6_LOJA"	 ,"01"}			 	,; // 	[12] -- Loja
	{"C6_NUM"	 ,"000001"}		 	,; // 	[13] -- Num. Pedido
	{"C6_RATEIO" ,"2"}				,; // 	[14] -- Rateio
	{"C6_UM"	 ,"UN"}			 	,; // 	[15] -- Unidade
	{"C6_VALOR"	 ,100000.00}		,; // 	[16] -- Vlr.Total
	{"C6_TES"	 ,"501"}			,; // 	[17] -- Tipo Saida
	{"C6_TPOP"   ,"F"}				,; // 	[18] -- Tipo Op
	{"C6_SUGENTR",DATE()}			,; // 	[19] -- Ent.Sugerida
	{"C6_TPPROD" ,"1"}				 ; // 	[20] -- Tp. Prod.
	}}
	Local aErroAuto := {}
	Local cLogErro  := ""
	Local lOk       := .T.
	Local lRet      := .T.
	Local nCount    := 0
	local nOpc      := MODEL_OPERATION_DELETE
	Local nX        := 0

	if SELECT("SX2") == 0 //Para ser executado pelo usuario
		PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
	endif

	// Fazendo select nas tabelas
	DbSelectArea("SC5") // Pedido de Venda
	DbSelectArea("SC6")	// Itens do pedido de vneda

	// Qual Indice está usando
	SC5->(dbSetOrder(1))
	SC6->(dbSetOrder(1))

	// Atribuindo a Filial da SC6
	cC6Filial := xFilial("SC6")

	// Organiza os campos comforme a SX3
	FWVetByDic(aPdv,"SC5",.F.,/*nCpoPos*/)
	FWVetByDic(aItemPed,"SC6",.T.,/*nCpoPos*/)

	for nX := 1 to Len(aItemPed)
		if ((!SC5->(MsSeek(xFilial("SC5")) + aPdv[1])))
			lOk := .F.
		endif
	next

	if(lOK)
		MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aPdv, aItemPed, nOpc, .F.)
		If !lMsErroAuto
			ConOut("Excluido com sucesso! ")
		Else
			ConOut("Erro na Incluido!")
			aErroAuto := GetAutoGRLog()
			For nCount := 1 To Len(aErroAuto)
				cLogErro += StrTran(StrTran(aErroAuto[nCount], "<", ""), "-", "") + " "
				ConOut(cLogErro)
			Next nCount
		EndIf
	endif

	if SELECT("SX2") > 0
		RESET ENVIRONMENT
	endif

Return lRet

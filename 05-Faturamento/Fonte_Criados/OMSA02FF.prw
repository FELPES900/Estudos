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
		{"C5_FILIAL" ,"01",Nil},;	// [1] -- Filial
	{"C5_NUM"    ,"000001",Nil},;	// [2] -- Cliente
	{"C5_TIPO"   ,"N"	  ,Nil},;	// [3] -- Tipo Pedido
	{"C5_CLIENTE","000001",Nil},; 	// [4] -- Cliente
	{"C5_LOJACLI","01"	  ,Nil},;	// [5] -- Loja
	{"C5_CLIENT" ,"000001",Nil},;	// [6] -- Cli.Entrega
	{"C5_LOJAENT","01"	  ,Nil},; 	// [7] -- Loja Entrega
	{"C5_TIPOCLI","F"	  ,Nil},; 	// [8] -- Tipo Cliente
	{"C5_CONDPAG","001"   ,Nil};	// [9] -- Cond. Pagto
	}
	Local cC6Filial := ""
	Local aItemPed := {;
		{;
		{"C6_CF"     , "6107"       , Nil}  	,; // 	[1]  -- Cod. Fiscal
	{"C6_CLI"    , "000001"         , Nil} 		,; // 	[2]  -- Cliente
	{"C6_FILIAL" , cC6Filial        , Nil} 		,; // 	[3]  -- Filial
	{"C6_ENTREG" , Date()           , Nil} 		,; // 	[4]  -- Entrega
	{"C6_DESCRI" , "MONITOR"        , Nil} 		,; // 	[5]  -- Descricao
	{"C6_INTROT" , "1"              , Nil} 		,; // 	[6]  -- Int. Rot.
	{"C6_ITEM"   , "01"             , Nil} 		,; // 	[7]  -- Item
	{"C6_PRODUTO", "000000000000001", Nil}		,; // 	[8]  -- Produto
	{"C6_QTDVEN" , 1000.00          , Nil} 		,; // 	[9]  -- Quantidade
	{"C6_PRCVEN" , 1000.00          , Nil} 		,; // 	[10] -- Prc Unitario
	{"C6_LOCAL"  , "01"             , Nil} 		,; // 	[11] -- Armazem
	{"C6_LOJA"   , "01"             , Nil} 		,; // 	[12] -- Loja
	{"C6_NUM"    , "000001"         , Nil} 		,; // 	[13] -- Num. Pedido
	{"C6_RATEIO" , "2"              , Nil} 		,; // 	[14] -- Rateio
	{"C6_UM"     , "UN"             , Nil} 		,; // 	[15] -- Unidade
	{"C6_VALOR"  , 1000000.00       , Nil}	 	,; // 	[16] -- Vlr.Total
	{"C6_TES"    , "501"            , Nil} 		,; // 	[17] -- Tipo Saida
	{"C6_TPOP"   , "F"              , Nil} 		,; // 	[18] -- Tipo Op
	{"C6_SUGENTR", DATE()           , Nil} 		,; // 	[19] -- Ent.Sugerida
	{"C6_TPPROD" , "1"              , Nil} 		;  // 	[20] -- Tp. Prod.
	}}
	Local aErroAuto := {}
	Local cLogErro  := ""
	Local lOk       := .F.
	Local lRet      := .T.
	Local nCount    := 0
	local nOpc      := 4
	Local nX        := 0
	Private lMsErroAuto   := .F.

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
		if ((SC5->(MsSeek(PadR(aPdv[1][2],TamSx3("C5_FILIAL")[1]) + PadR(aPdv[2][2],TamSx3("C5_NUM")[1])))))
			lOk := .T.
		endif
	next

	if(lOK)
		MSExecAuto({|a, b, c| MATA410(a, b, c)}, aPdv, aItemPed, nOpc)
		If !lMsErroAuto
			ConOut("Alterado com sucesso! ")
		Else
			ConOut("Erro na Alteracao!")
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

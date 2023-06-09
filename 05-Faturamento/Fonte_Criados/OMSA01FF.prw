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

	Local aIpdv := {} // Itens do pedido de venda
	Local aPdv  :={'000001' } // Pedido de venda
	Local lRet  := .T.
	Local nX    := 0

	if SELECT("SX2") == 0 //Para ser executado pelo usuario
		PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
	endif

	DbSelectArea("SC5") // Pedido de Venda
	DbSelectArea("SC6")	// Itens do pedido de vneda

	if (!SC5->(MsSeek(xFilial("SC5")) + aPdv[1]))
		for nX := 1 to Len(aIpdv)
			if (!SC6)
			endif
		next
	endif

	if SELECT("SX2") > 0
		RESET ENVIRONMENT
	endif

Return lRet

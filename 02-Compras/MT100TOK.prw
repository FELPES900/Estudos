#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MT100TOK
Validação do campo D1_CC, quando se iniciar com 02
fazer os campos D1_ITEMCTA e D1_CLVL como obrigatorios
@type function
@version 12.1.2210
@author Felipe Fraga
@since 02/06/2023
@return variant, return_lRet
/*/
User Function MT100TOK()

	Local lRet := .T.
	Local nX := 0

	for nX := 1 to Len(aCols)

		if((SubStr(aCols[nX][GdFieldPos("D1_CC",aHeader)],1,2) == "02").And. (Empty(aCols[nX][GdFieldPos("D1_ITEMCTA",aHeader)]) .Or. Empty(aCols[nX][GdFieldPos("D1_CLVL",aHeader)])))
			FWAlertInfo("Os campos " + GetSx3Cache("D1_ITEMCTA","X3_TITULO") + " e " +;
				GetSx3Cache("D1_CLVL","X3_TITULO") + "precisam estar preenchido, caso o campo " + ;
				GetSx3Cache("D1_CC","X3_TITULO") + "esteja preenchido","Atenção")
			lRet := .F.
		endif

	next

Return lRet

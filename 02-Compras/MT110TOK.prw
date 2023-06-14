#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MT110LOK
Validar campo C1_CC que caso começar com 02
deixar os cmapos C1_ITEMCTA e C1_CLVL como obrigatorios
Ponto de entrada que valida todos os itens
@type function
@version 12.1.33
@author Felipe Fraga
@since 14/06/2023
@return variant, return_lRet
/*/
User Function MT110TOK()

	Local lRet := .T.
	Local nX := 0

	For nX := 1 to Len(aCols)
		if((SubStr(aCols[nX][GdFieldPos("C1_CC",aHeader)],1,2) == "02") .And. (Empty(aCols[nX][GdFieldPos("C1_ITEMCTA",aHeader)]) .Or. Empty(aCols[nX][GdFieldPos("C1_CLVL",aHeader)])))
			FWAlertInfo("Os campos " + GetSx3Cache("C1_ITEMCTA","X3_TITULO") + " e " +;
				GetSx3Cache("C1_CLVL","X3_TITULO") + " precisam estar preenchido, caso o campo " + ;
				GetSx3Cache("C1_CC","X3_TITULO") + " esteja preenchido","Atenção")
			lRet :=  .F.
		endif
	Next

Return lRet

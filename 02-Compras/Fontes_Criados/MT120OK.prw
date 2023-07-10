#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MT120OK
Validar campo C7_CC que caso começar com 02
deixar os cmapos C7_ITEMCTA e C7_CLVL como obrigatorios
Ponto de entrada que valida todos os itens
@type function
@version 12.1.2210
@author Felipe Fraga
@since 06/06/2023
@return variant, return_lRet
/*/
User Function MT120OK()

	Local lRet := .T.
	Local nX := 0

	For nX := 1 to Len(aCols)
		if((SubStr(aCols[nX][GdFieldPos("C7_CC",aHeader)],1,2) == "02") .And. (Empty(aCols[nX][GdFieldPos("C7_ITEMCTA",aHeader)]) .Or. Empty(aCols[nX][GdFieldPos("C7_CLVL",aHeader)])))
			FWAlertInfo("Os campos " + GetSx3Cache("C7_ITEMCTA","X3_TITULO") + " e " +;
				GetSx3Cache("C7_CLVL","X3_TITULO") + " precisam estar preenchido, caso o campo " + ;
				GetSx3Cache("C7_CC","X3_TITULO") + " esteja preenchido","Atenção")
			lRet :=  .F.
		endif
	Next

Return lRet

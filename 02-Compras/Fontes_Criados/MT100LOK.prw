#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MT100LOK
Valida cada item para ver se foi comprido a regra de caso o campo D1_CC
inicie com 02, os campos  D1_ITEMCTA e D1_CLVL se tornam campos obrigatorios
@type function
@version 12.1.2210
@author Felipe Fraga
@since 02/06/2023
@return variant, return_lRet
/*/
User Function MT100LOK()

	Local lRet := .T.

	if((SubStr(aCols[n][GdFieldPos("D1_CC",aHeader)],1,2) == "02") .And. (Empty(aCols[n][GdFieldPos("D1_ITEMCTA",aHeader)]) .Or. Empty(aCols[n][GdFieldPos("D1_CLVL",aHeader)])))
		FWAlertInfo("Os campos " + GetSx3Cache("D1_ITEMCTA","X3_TITULO") + " e " +;
			GetSx3Cache("D1_CLVL","X3_TITULO") + "precisam estar preenchido, caso o campo " + ;
			GetSx3Cache("D1_CC","X3_TITULO") + "esteja preenchido","Atenção")
		lRet :=  .F.
	endif

Return lRet

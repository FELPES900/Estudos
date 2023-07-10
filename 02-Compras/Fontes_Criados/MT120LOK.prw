#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MT120LOK
Validar campo C7_CC que caso começar com 02
deixar os cmapos C7_ITEMCTA e C7_CLVL como obrigatorios
junto disso o ponto de entrada valida cada item que caso
esteja comprindo o que será validado
@type function
@version 12.1.2210
@author Felipe Fraga
@since 06/06/2023
@return variant, return_lRet
/*/
User function MT120LOK()

	Local lRet := .T.

	if((SubStr(aCols[n][GdFieldPos("C7_CC",aHeader)],1,2) == "02") .And. (Empty(aCols[n][GdFieldPos("C7_ITEMCTA",aHeader)]) .Or. Empty(aCols[n][GdFieldPos("C7_CLVL",aHeader)])))
		FWAlertInfo("Os campos " + GetSx3Cache("C7_ITEMCTA","X3_TITULO") + " e " +;
			GetSx3Cache("C7_CLVL","X3_TITULO") + " precisam estar preenchido, caso o campo " + ;
			GetSx3Cache("C7_CC","X3_TITULO") + " esteja preenchido","Atenção")
		lRet :=  .F.
	endif


Return lRet

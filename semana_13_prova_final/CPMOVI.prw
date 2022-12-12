#INCLUDE"TOTVS.CH"
Function u_CPMOVI(numctr)
	Local aArea := FwGetArea()
	Local cFiltro := ""
	cFiltro := "SZ2->Z2_CODCON == " + "'" + numctr + "' .AND. (SZ2->Z2_CLIFISI = SA1->A1_COD .OR. SZ2->Z2_CFISCAL = SA1->A1_COD)"
	cFiltro := "@#" + cFiltro + "@#"
	FwRestArea(aArea)
RETURN cFiltro

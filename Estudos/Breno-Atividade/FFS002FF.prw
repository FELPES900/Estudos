#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMBROWSE.CH'

Function U_FFS001FF()

	Local nSalario         := ""
	Local nValorDeVendas   := ""

	nSalario 	   := FWInputBox("Salario","")
	nValorDeVendas := FWInputBox("Valor de Venda","")
	nSalario         := Val(nSalario)
	nValorDeVendas   := Val(nValorDeVendas)

	if (nValorDeVendas > 1500)
		nSalario := nSalario + ((nValorDeVendas * (3 / 100)) + ((nValorDeVendas - 1500) * (5 / 100)))
		FWAlertInfo("O Valor do novo salario: "+ cValToChar(nSalario) ,"Titulo")
	else
		nSalario := nSalario + (nValorDeVendas * (3 / 100))
		FWAlertInfo("O Valor do novo salario: "+ cValToChar(nSalario) ,"Titulo")
	endif

Return

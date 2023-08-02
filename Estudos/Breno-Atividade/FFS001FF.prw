#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMBROWSE.CH'

Function U_FFS0001FF()

	Local nValorA := ""
	Local nValorB := ""
	Local nValorGuardado

	nValorA := FWInputBox("Primeiro Valor","")
	nValorB := FWInputBox("Segundo Valor","")

	nValorA := Val(nValorA)
	nValorB := Val(nValorB)

	if nValorA > nValorB

		nValorGuardado := nValorA
		FWAlertInfo("Valor de A "+cValToChar(nValorA) +", Valor de B "+ cValToChar(nValorB) ,"Atividade")
		nValorA := nValorB
		nValorB := nValorGuardado
		FWAlertInfo("Valor de A "+ cValToChar(nValorA) +", Valor de B "+ cValToChar(nValorB) ,"Atividade")
		nValorB := nValorA
		nValorA:= nValorGuardado
		FWAlertInfo("Valor de A "+ cValToChar(nValorA) +", Valor de B "+ cValToChar(nValorB) ,"Atividade")

	elseif nValorB > nValorA

		nValorGuardado := nValorB
		FWAlertInfo("Valor de A "+cValToChar(nValorB) +", Valor de B "+ cValToChar(nValorA) ,"Atividade")
		nValorB := nValorA
		nValorA := nValorGuardado
		FWAlertInfo("Valor de A "+ cValToChar(nValorB) +", Valor de B "+ cValToChar(nValorA) ,"Atividade")
		nValorA := nValorB
		nValorB:= nValorGuardado
		FWAlertInfo("Valor de A "+ cValToChar(nValorB) +", Valor de B "+ cValToChar(nValorA) ,"Atividade")

	endif

return({nValorA,nValorB})

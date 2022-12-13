/*/{Protheus.doc} u_GCTR01FF
Relatorio dos contratos
@type function
@version 33
@author felip
@since 12/12/2022
/*/

Function u_GCTR01FF()

	Local oRelato
	Private cPerg := PadR('GCTR01FF',10)
	// Retorna um alias para ser atualizado no record set definido no PadR()
	Private cAlias := GetNextAlias()
	Private oSection1
	Private oBreak

	// Interface de impressão
	oRelato := ReportDef()

	// Tela de impressão do relatorio
	oRelato:PrintDialog()

Return

Static Function ReportDef()

	Local oReport

	// Browse de perguntas no relatorio
	Pergunte(cPerg, .T.)

	oReport := TReport():New(cPerg,'Relação de clientes',cPerg,{||ReportPrint()},,.T.)

	// Define a orientação de página como paisagem
	oReport:SetLandSpace(.T.)

	// Degine que será permitida a alteração nos parâmetros do relatorio
	oReport:HideParamPage()

	// Criando um cabaeçalho de como o relatorio será gerado
	oSection1 := TRSection():New(oReport,"Relatorio de contratos", {cAlias})

	// Dados dos contratos
	TRCell():New(oSection1, "")


Return

Static Function ReportPrint()



Return

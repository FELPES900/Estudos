#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} u_CALCULA
CALCULADORA
@type function
@version 33
@author felip
@since 18/11/2022
/*/
Function u_CALCULA()

	Local oRules_Calcula := Nil as Object
	Private cTGet1       := ""  as Character

	oRules_Calcula := oCalcula():new() // Metodo Construtor

	DEFINE DIALOG oDlg TITLE "Exemplo TButton" FROM 180,180 TO 700,550 PIXEL // Funcção para crição de tela
	// Usando o New
	oText := TGet():New( 01,01,{|u| if( Pcount( )>0, cTGet1 := u, cTGet1)},oDlg,150,020,"@E 99.99",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTGet1,,,,,,,,,/*oFont*/)
	// Coluna 1
	oTButton1     := TButton():New(72 , 002, "&1", oDlg, {|| (oRules_Calcula:numero1("1"))}   , 40, 40, , , .F., .T., .F., , .F., , , .F.)
	oTButton2     := TButton():New(112, 002, "&2", oDlg, {|| (oRules_Calcula:numero2("2"))}   , 40, 40, , , .F., .T., .F., , .F., , , .F.)
	oTButton3     := TButton():New(152, 002, "&3", oDlg, {|| (oRules_Calcula:numero3("3"))}   , 40, 40, , , .F., .T., .F., , .F., , , .F.)
	oTButtonIgual := TButton():New(192, 002, "&=", oDlg, {|| (oRules_Calcula:igual("="))}     , 40, 40, , , .F., .T., .F., , .F., , , .F.)
	// Coluna 2
	oTButton4     := TButton():New(72 , 042, "&4", oDlg, {|| (oRules_Calcula:numero4("4"))}   , 40, 40, , , .F., .T., .F., , .F., , , .F.)
	oTButton5     := TButton():New(112, 042, "&5", oDlg, {|| (oRules_Calcula:numero5("5"))}   , 40, 40, , , .F., .T., .F., , .F., , , .F.)
	oTButton6     := TButton():New(152, 042, "&6", oDlg, {|| (oRules_Calcula:numero6("6"))}   , 40, 40, , , .F., .T., .F., , .F., , , .F.)
	oTButton0     := TButton():New(192, 042, "&0", oDlg, {|| (oRules_Calcula:numero0("0"))}   , 40, 40, , , .F., .T., .F., , .F., , , .F.)
	// Colune 3
	oTButton7     := TButton():New(72 , 082, "&7", oDlg, {|| (oRules_Calcula:numero7("7"))}   , 40, 40, , , .F., .T., .F., , .F., , , .F.)
	oTButton8     := TButton():New(112, 082, "&8", oDlg, {|| (oRules_Calcula:numero8("8"))}   , 40, 40, , , .F., .T., .F., , .F., , , .F.)
	oTButton9     := TButton():New(152, 082, "&9", oDlg, {|| (oRules_Calcula:numero9("9"))}   , 40, 40, , , .F., .T., .F., , .F., , , .F.)
	oTButtonMais  := TButton():New(192, 082, "&+", oDlg, {|| (oRules_Calcula:operadores("+"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
	// Coluna 4
	oTButtonMenos := TButton():New(72 , 122, "&-", oDlg, {|| (oRules_Calcula:operadores("-"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
	oTButtonMuti  := TButton():New(112, 122, "&*", oDlg, {|| (oRules_Calcula:operadores("*"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
	oTButtonDivi  := TButton():New(152, 122, "&/", oDlg, {|| (oRules_Calcula:operadores("/"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
	oTButtonCE    := TButton():New(192, 122, "&ç", oDlg, {|| (oRules_Calcula:limpaTela("CE"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)

	ACTIVATE DIALOG oDlg CENTERED // Posição da tela nesse caso esta no centro da tela

Return

/*/{Protheus.doc} oCalcula
Class da calculadora
@type class
@version 33
@author felip
@since 23/11/2022
/*/
	CLASS oCalcula FROM LongClassName

		DATA cValor1 as Character
		DATA cValor2 as Character
		DATA cTipo   as Character

		// Methodo contrutor
		METHOD new() CONSTRUCTOR

		// Numeros da calculadora
		METHOD numero1()
		METHOD numero2()
		METHOD numero3()
		METHOD numero4()
		METHOD numero5()
		METHOD numero6()
		METHOD numero7()
		METHOD numero8()
		METHOD numero9()
		METHOD numero0()


		// Operadores matematicos
		METHOD operadores()
		METHOD igual()

		// Methodo para limpar as variaveis do tipo DATE
		METHOD limpaTela()

	ENDCLASS

Method new() CLASS oCalcula
	self:cValor1 := ""
	self:cValor2 := ""
	self:cTipo   := ""
Return

Method numero1(cAct) CLASS oCalcula
	cTGet1 += cAct
	oText:refresh()
Return
Method numero2(cAct) CLASS oCalcula
	cTGet1 += cAct
	oText:refresh()
Return
Method numero3(cAct) CLASS oCalcula
	cTGet1 += cAct
	oText:refresh()
Return
Method numero4(cAct) CLASS oCalcula
	cTGet1 += cAct
	oText:refresh()
Return
Method numero5(cAct) CLASS oCalcula
	cTGet1 += cAct
	oText:refresh()
Return
Method numero6(cAct) CLASS oCalcula
	cTGet1 += cAct
	oText:refresh()
Return
Method numero7(cAct) CLASS oCalcula
	cTGet1 += cAct
	oText:refresh()
Return
Method numero8(cAct) CLASS oCalcula
	cTGet1 += cAct
	oText:refresh()
Return
Method numero9(cAct) CLASS oCalcula
	cTGet1 += cAct
	oText:refresh()
Return
Method numero0(cAct) CLASS oCalcula
	cTGet1 += cAct
	oText:refresh()
Return

// Tipos de operadores e valo1
Method operadores(cAct) CLASS oCalcula
	self:cValor1 := cTGet1
	self:cTipo := cAct
	cTGet1 := ""
	oText:refresh()
Return

// valor2 e resultado da equação matematica
Method igual(cAct) CLASS oCalcula
	self:cValor2 := cTGet1
	cTGet1 := CValToChar(VAL(MathC(self:cValor1,self:cTipo,self:cValor2)))
	oText:refresh()
Return

// Para limpar a tela
Method limpaTela() CLASS oCalcula
	self:cValor1 := ""
	self:cValor2 := ""
	self:cTipo   := ""
	cTGet1    := ""
	oText:refresh()
Return

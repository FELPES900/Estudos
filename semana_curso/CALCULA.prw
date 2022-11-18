#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} u_CALCULA
CALCULADORA
@type function
@version 33
@author felip
@since 18/11/2022
/*/
Function u_CALCULA()
	Private cTGet1 := ""
    // oTFont := TFont():New('Courier new',,-16,.T.)
	DEFINE DIALOG oDlg TITLE "Exemplo TButton" FROM 180,180 TO 700,550 PIXEL
	// Usando o New
	oText := TGet():New( 01,01,{|u| if( Pcount( )>0, cTGet1 := u, cTGet1)},oDlg,150,020,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTGet1,,,,,,,,,/*oFont*/)
    // Coluna 1
	oTButton1     := TButton():New(72 , 002, "&1", oDlg, {|| (Doaction1("1"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
	oTButton2     := TButton():New(112, 002, "&2", oDlg, {|| (Doaction1("2"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
	oTButton3     := TButton():New(152, 002, "&3", oDlg, {|| (Doaction1("3"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
	oTButtonIgual := TButton():New(192, 002, "&=", oDlg, {|| (Doaction2("="))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
    // Coluna 2
    oTButton4     := TButton():New(72 , 042, "&4", oDlg, {|| (Doaction1("4"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
    oTButton5     := TButton():New(112, 042, "&5", oDlg, {|| (Doaction1("5"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
    oTButton6     := TButton():New(152, 042, "&6", oDlg, {|| (Doaction1("6"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
    oTButton0     := TButton():New(192, 042, "&0", oDlg, {|| (Doaction1("0"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
    // Colune 3 
    oTButton0     := TButton():New(72 , 082, "&7", oDlg, {|| (Doaction1("7"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
    oTButton0     := TButton():New(112, 082, "&8", oDlg, {|| (Doaction1("8"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
    oTButton0     := TButton():New(152, 082, "&9", oDlg, {|| (Doaction1("9"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
    oTButton0     := TButton():New(192, 082, "&+", oDlg, {|| (Doaction2("+"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
    // Coluna 4
    oTButton0     := TButton():New(72 , 122, "&-", oDlg, {|| (Doaction2("-"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
    oTButton0     := TButton():New(112, 122, "&*", oDlg, {|| (Doaction2("*"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)
    oTButton0     := TButton():New(152, 122, "&/", oDlg, {|| (Doaction2("/"))}, 40, 40, , , .F., .T., .F., , .F., , , .F.)


	ACTIVATE DIALOG oDlg CENTERED

Return
/*/{Protheus.doc} Doaction1
numero1
@type function
@version 33
@author felip
@since 18/11/2022
/*/
Static function Doaction1(cAct)

	if cAct == "1"
		cTGet1 += cAct
		oText:refresh()
    elseif cAct == "2"
        cTGet1 += cAct
        oText:refresh()
    elseif cAct == "3"
        cTGet1 += cAct
        oText:refresh()
    elseif cAct == "4"
        cTGet1 += cAct
        oText:refresh()
    elseif cAct == "5"
        cTGet1 += cAct
        oText:refresh()
    elseif cAct == "6"
        cTGet1 += cAct
        oText:refresh()
    elseif cAct == "7"
        cTGet1 += cAct
        oText:refresh()
    elseif cAct == "8"
        cTGet1 += cAct
        oText:refresh()
    elseif cAct == "9"
        cTGet1 += cAct
        oText:refresh()
    elseif cAct == "0"
        cTGet1 += cAct
        oText:refresh()
	EndIf

Return

Static function Doaction2(cAct)



Return

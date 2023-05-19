#INCLUDE "TOTVS.CH"

#XTRANSLATE bWait() => Sleep(3000000)
STATIC cMeuApelido := Space(06)

/*/{Protheus.doc} COMG03AU
description
@type function
@version
@author vitor.gabriel
@since 08/11/2021
@return variant, return_description
/*/
User Function COMG03AU()
	Private lRet    := .F.
	Private cCodigo := Space(08)
	Private aApelidosValidos := {}

	lRet := Apelidos()

Return lRet

Static Function Apelidos()

	Local cCSSGet    := "QLineEdit{ border: 1px solid gray;border-radius: 3px;background-color: #ffffff;selection-background-color: #3366cc;selection-color: #ffffff;padding-left:1px;}"
	Local cCSSButton := "QPushButton{background-repeat: none; margin: 2px;background-color: #ffffff;border-style: outset;border-width: 2px;border: 1px solid #C0C0C0;border-radius: 5px;border-color: #C0C0C0;font: bold 12px Arial;padding: 6px;QPushButton:pressed {background-color: #ffffff;border-style: inset;}"
	Local cMascara   := ""
	Local cTitCampo  := ""
	Local aCols      := {}
	Local aApelidos  := {}
	Local nI         := 0
	Local cCadastro  := "Cadastro de Apelidos"
	Local lChkFil    := .F.
	Private oFC08    := TFont():New('Courier New', , -12, .F.)
	Private oNo      := LoadBitmap(GetResources(),"LBNO")
	Private oOk      := LoadBitmap(GetResources(),"LBOK")
	Private oDlg     := Nil
	Private oChkFil  := Nil
	Private oCodigo  := Nil
	Private oBrwPrc  := Nil

	aApelidos := u_FwLoadApelidos()
	For nI := 1 To Len(aApelidos)
		AAdd(aApelidosValidos,{aApelidos[nI][1],Alltrim(aApelidos[nI][2]),AllTrim(aApelidos[nI][3])})
	Next

	oDlg := MsDialog():New( 0, 0, 280, 500, cCadastro,,,.F.,,,,, oMainWnd,.T.,, ,.F. )

	aHead   := {"Ok","Código","Descrição"}

	oBrwPrc := TCBrowse():New(023,005,245,095,,aHead,aCols,oDlg,,,,,{||},,oFC08,,,,,.F.,,.T.,{||},.F.,,,)

	oCodigo := TGet():New( 003, 005,{|u| if(PCount()>0,cCodigo:=u,cCodigo)},oDlg,205, 010,cMascara,{|| },0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"",cCodigo,,,,,,,cTitCampo + ": ",1 )
	oCodigo:SetCss(cCSSGet)

	oChkFil := TCheckBox():New(122, 080, "Inverte Seleção", {| u | If( PCount() == 0, lChkFil, lChkFil := u ) }, oDlg, 50, 10, , {|| AEval(aApelidosValidos, {|x| x[1] := If(x[1]==.T.,.F.,.T.)}),oBrwPrc:Refresh(.F.)}, , , , , .F., .T., , .F.,)

	//Seta o array da listbox
	oBrwPrc:SetArray(aApelidosValidos)

	oBrwPrc:bLDblClick := {|| fMarca( nI )}

	//atualiza a grade de dados
	oBrwPrc:bLine :={|| {If( aApelidosValidos[oBrwPrc:nAT,1],oOk,oNo),;
		aApelidosValidos[oBrwPrc:nAt,2],;
		aApelidosValidos[oBrwPrc:nAt,2]}}

	oButton1 := TButton():New(008, 212," &Pesquisar ",oDlg,{|| Processa({|| FiltroFIL(oBrwPrc:nAT,@aApelidosValidos,cCodigo) },"Hellow Friend...") },037,013,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton1:SetCss(cCSSButton)

	SButton():New(122, 005 , 001, {|| ConfApelidos(oBrwPrc:nAt,@aApelidosValidos,@lRet)}, oDlg, .T., ,)
	SButton():New(122, 040 , 002, {|| oDlg:End()}                         , oDlg, .T., ,)

	oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,.T.,,,, oDlg:bRClicked, )

Return lRet

Static Function ConfApelidos(_nPos, aApelidosValidos, lRet)

	Local nF      := 0
	Local cApelidos := ""

	For nF := 1 To Len(aApelidosValidos)
		If aApelidosValidos[nF][1]
			cApelidos += AllTrim(aApelidosValidos[nF][2]) + ";"
		EndIf
	Next nF

	cMeuApelido := cApelidos

	lRet := .T.

	oDlg:End()

Return

/*/{Protheus.doc} COMG03AI
//TODO Descrição auto-gerada.
@author User
@since 10/09/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/

User Function COMG03AV()

	Local cRet := ""

	cRet := cMeuApelido

Return (cRet)

/*/{Protheus.doc} FiltroF3P
//TODO Descrição auto-gerada.
@author User
@since 10/09/2018
@version undefined
@example
(examples)
@see (links_or_references)
/*/

Static Function FiltroFIL(nLinha,aApelidosValidos,cRetCpo)

	Local nI

	For nI := 1 To Len(aApelidosValidos)

		If AllTrim(cCodigo) $ aApelidosValidos[nI][2]
			oBrwPrc:nAt := nI
			oBrwPrc:Refresh()
			bWait()
			Exit
		EndIf

	Next nI

Return

/*/{Protheus.doc} fMarca
//TODO Descrição auto-gerada.
@author tecnoligia01-pc
@since 06/04/2020
@version undefined
@example
(examples)
@see (links_or_references)
/*/

Static Function fMarca(nLinha)

	aApelidosValidos[nLinha,01] := !(aApelidosValidos["nLinha",01])

Return

User Function FwLoadApelidos()
	Local aApelidos := {}

	aAdd(aApelidos,{.F.,"01","Sandy"})
	aAdd(aApelidos,{.F.,"02","Plankton"})
	aAdd(aApelidos,{.F.,"03","Bob Esponja"})
	aAdd(aApelidos,{.F.,"04","Patrick"})

Return aApelidos

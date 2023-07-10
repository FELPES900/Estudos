#INCLUDE "TOTVS.CH"
#INCLUDE 'FWMBROWSE.CH'

STATIC cMeuApelido := Space(06)

/*/{Protheus.doc} COMG03AU
Retorna True ou False
@type function
@version 12.1.33
@author vitor.gabriel
@since 08/11/2021
@return variant, lRet
/*/
User Function COMG03AU()

	Private aApelidosValidos := {}
	Private cCodigo          := Space(08)
	Private lRet             := .F.

	lRet := Apelidos()

Return lRet

/*/{Protheus.doc} Apelidos
Contrei um pequeno modal para fazer a seleção do itens
@type function
@version 12.1.33
@author Felipe Fraga
@since 19/05/2023
@return variant, lRet
/*/
Static Function Apelidos()

	Local aApelidos  := {}
	Local aCols      := {}
	Local cCSSButton := "QPushButton{background-repeat: none; margin: 2px;background-color: #ffffff;border-style: outset;border-width: 2px;border: 1px solid #C0C0C0;border-radius: 5px;border-color: #C0C0C0;font: bold 12px Arial;padding: 6px;QPushButton:pressed {background-color: #ffffff;border-style: inset;}"
	Local cCSSGet    := "QLineEdit{ border: 1px solid gray;border-radius: 3px;background-color: #ffffff;selection-background-color: #3366cc;selection-color: #ffffff;padding-left:1px;}"
	Local lChkFil    := .F.
	Local nI         := 0
	Private oBrwPrc  := Nil
	Private oChkFil  := Nil
	Private oCodigo  := Nil
	Private oDlg     := Nil
	Private oFC08    := TFont():New('Courier New',,12,.F.)
	Private oNo      := LoadBitmap(GetResources(),"LBNO")
	Private oOk      := LoadBitmap(GetResources(),"LBOK")

	// Array com dados da consulta F3
	aApelidos := U_FwLoadApelidos()

	For nI := 1 To Len(aApelidos)
		AAdd(aApelidosValidos,{aApelidos[nI][1],Alltrim(aApelidos[nI][2]),AllTrim(aApelidos[nI][3])})
	Next

	// Função contrutora
	oDlg := MsDialog():New( 0, 0, 280, 500, "Cadastro de Apelidos",,,.F.,,,,, oMainWnd,.T.,, ,.F. )

	// Nome das colunas
	aHead   := {"Ok","Código","Descrição"}

	// Método construtor da classe.
	oBrwPrc := TCBrowse():New(023,005,245,095,,aHead,aCols,oDlg,,,,,{||},,oFC08,,,,,.F.,,.T.,{||},.F.,,,)

	// Método construtor da classe.
	oCodigo := TGet():New( 003, 005,{|u| if(PCount()>0,cCodigo:=u,cCodigo)},oDlg,205, 010,"",{|| },0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"",cCodigo,,,,,,,"" + ": ",1 )

	// Define um CSS padrão que será utilizado na criação de componentes visuais.
	oCodigo:SetCss(cCSSGet)

	//Cria uma função que ira selecionar todos os dados que nao conterem um X marcado
	oChkFil := TCheckBox():New(122, 080, "Selecionar todos", {| u | If( PCount() == 0, lChkFil, lChkFil := u ) }, oDlg, 50, 10, , {|| AEval(aApelidosValidos, {|x| x[1] := If(x[1]==.T.,.F.,.T.)}),oBrwPrc:Refresh(.F.)}, , , , , .F., .T., , .F.,)

	//Seta o array da listbox
	oBrwPrc:SetArray(aApelidosValidos)

	// Verifica se o botão foi selecionado
	oBrwPrc:bLDblClick := {|| fMarca( oBrwPrc:nAt )}

	//atualiza a grade de dados
	oBrwPrc:bLine :={|| {If( aApelidosValidos[oBrwPrc:nAT,1],oOk,oNo),aApelidosValidos[oBrwPrc:nAt,2],aApelidosValidos[oBrwPrc:nAt,3]}}

	// Cria o botão
	oButton1 := TButton():New(008, 212," &Pesquisar ",oDlg,{|| Processa({|| FiltroFIL(oBrwPrc:nAT,@aApelidosValidos,cCodigo) },"Hellow Friend...") },037,013,,,.F.,.T.,.F.,,.F.,,,.F. )

	// Estilização do botão
	oButton1:SetCss(cCSSButton)

	// Coluna que tera os dados do array
	SButton():New(122, 005 , 001, {|| ConfApelidos(oBrwPrc:nAt,@aApelidosValidos,@lRet)}, oDlg, .T., ,)
	SButton():New(122, 040 , 002, {|| oDlg:End()}, oDlg, .T., ,)

	oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,.T.,,,, oDlg:bRClicked, )

Return lRet

/*/{Protheus.doc} ConfApelidos
Retorno os nomes dos dados do array
@type function
@version 12.1.33
@author Felipe Fraga
@since 19/05/2023
@param _nPos, variant, param_Posição
@param aApelidosValidos, array, param_Array com os dados da consulta F3
@param lRet, logical, param_tipo logico
@return variant,
/*/
Static Function ConfApelidos(_nPos, aApelidosValidos, lRet)

	Local cApelidos := ""
	Local nF        := 0

	For nF := 1 To Len(aApelidosValidos)
		If aApelidosValidos[nF][1] .And. cApelidos == ""
			cApelidos += AllTrim(aApelidosValidos[nF][3]) + ""
			lRet := .T.
		elseif cApelidos <> ""
			FWAlertWarning("Voce nao pode ter mais de um apelido","Alerta")
			lRet := .F.
		EndIf
	Next

	IIF(lRet,(cMeuApelido:=cApelidos,oDlg:End()),)

Return

/*/{Protheus.doc} COMG03AI
Retorno da descrição
@type function
@version 12.1.33
@author Felipe nFraga
@since 19/05/2023
@return variant, cRet
/*/
User Function COMG03AI()

	Local cRet := ""

	cRet := cMeuApelido

Return cRet

/*/{Protheus.doc} FiltroFIL
Copmo será gerado os dados do modal que foram
gerados pela função fMarca()
@type function
@version 12.1.33
@author Felipe Fraga
@since 19/05/2023
@param nLinha, numeric, param_numero de linhas
@param aApelidosValidos, array, param_Array com os dados
@param cRetCpo, character, param_
@return variant,
/*/
Static Function FiltroFIL(nLinha,aApelidosValidos,cRetCpo)

	Local nI

	For nI := 1 To Len(aApelidosValidos)
		If AllTrim(cRetCpo) $ aApelidosValidos[nI][2] .Or. AllTrim(cRetCpo) $ aApelidosValidos[nI][3]
			oBrwPrc:nAt := nI
			oBrwPrc:Refresh()
			Exit
		EndIf
	Next

Return

/*/{Protheus.doc} fMarca
Retorna os valores que serão apresentados no modal
@type function
@version 12.1.33
@author felip
@since 19/05/2023
@param nLinha, numeric, param_Numero de linhas que serão apresentadas pelo array
@return variant,
/*/
Static Function fMarca(nLinha)

	aApelidosValidos[nLinha,01] := !(aApelidosValidos[nLinha,01])

Return

/*/{Protheus.doc} FwLoadApelidos
Retorna um array, com o os valores que serão apresentados
@type function
@version 12.1.33
@author felip
@since 19/05/2023
@return variant, aApelidps
/*/
User Function FwLoadApelidos()

	Local aApelidos := {}

	aAdd(aApelidos,{.F.,"01","Sandy"})
	aAdd(aApelidos,{.F.,"02","Plankton"})
	aAdd(aApelidos,{.F.,"03","Bob Esponja"})
	aAdd(aApelidos,{.F.,"04","Patrick"})

Return aApelidos

#INCLUDE "TOTVS.CH"

Static oMemo
Static cMemo       := ""
Static cLibVersion := ""
Static cMascara    := Space(03)

/*/{Protheus.doc} CFGA01AA
//Usar somente em base teste
@type function
@version 12.1.25
@author vitor.gabriel
@since 23/11/2021
/*/

User Function CFGA01AA()

	PRIVATE oDlg
	PRIVATE aCritica  := {}
	PRIVATE lCritico  := .F.
	PRIVATE cDataBase := AllTrim(TCGetDB())

	oDlg := MsDialog():New( 0, 0, 330, 600, "Atualizador de Estrutura(SXs) "+cDataBase,,,.F.,,,,,,.T.,, ,.F. )

	oMemo := TMultiGet():New( 3, 3, { | u | If( PCount() == 0, cMemo, cMemo := u ) },oDlg, 297, 130,,.F.,,,,.T.,,.F.,,.F.,.F.,.F.,,,.F.,, )
	oMemo:lReadOnly := .T.
	TSay():New( 138, 003,{||  "Mascara :"},oDlg,,,.F.,.F.,.F.,.T.,,, 050, 006,.F.,.F.,.F.,.F.,.F.,.F. )
	TGet():New( 137, 030, { | u | If( PCount() == 0, cMascara, cMascara := u ) },oDlg, 050, 006, "@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cMascara",,, )
	TSay():New( 138, 085,{||  "-->>  INSIRA A TABELA QUE DESEJA ATUALIZAR OU DEIXE EM BRANCO"},oDlg,,,.F.,.F.,.F.,.T.,,, 300, 006,.F.,.F.,.F.,.F.,.F.,.F. )
	TSay():New( 150, 085,{||  "      PARA TODAS AS TABELAS DO SX2"},oDlg,,,.F.,.F.,.F.,.T.,,, 300, 006,.F.,.F.,.F.,.F.,.F.,.F. )
	PIXEL := SButton():New( 152, 03,1,{||  (Processa({||fOK(cMascara)}))}, oDlg,.T.,,)

	oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,.T.,,,, oDlg:bRClicked, )

Return

Static function fOK(cMascara)

	Local _aAreaSX2	:= {}

	__SetX31Mode(.F.)
	If Empty(cMascara)
		DbSelectArea("SX2")
		SX2->(DbSetOrder(1))
		ProcRegua(SX2->(RecCount()))
		SX2->(DbGotop())
		While !SX2->(Eof())
			_aAreaSX2 := SX2->(GetArea())
			IncProc("Tabela: "+ SX2->X2_CHAVE)
			X31UpdTable(SX2->X2_CHAVE)
			DbSelectArea(SX2->X2_CHAVE)
			If __GetX31Error()
				MsgAlert(__GetX31Trace(),"Atencao!")
				MsgAlert("Ocorreu um erro desconhecido durante a atualizacao!","Atencao!")
				Break
			Else
				cMemo += "Atualizacao realizada com sucesso! " +  SX2->X2_CHAVE + "." + Chr(13) + Chr(10)
				oMemo:Refresh()
			EndIf
			RestArea(_aAreaSX2)
			SX2->(Dbskip())
		EndDo
	Else
		X31UpdTable(cMascara)
		DbSelectArea(cMascara)
		If __GetX31Error()
			MsgAlert(__GetX31Trace(),"Atencao!")
			MsgAlert("Ocorreu um erro desconhecido durante a atualizacao!","Atencao!")
		Else
			cMemo += "Atualizacao realizada com sucesso! " +  cMascara + "." + Chr(13) + Chr(10)
			oMemo:Refresh()
		EndIf
	EndIf

Return


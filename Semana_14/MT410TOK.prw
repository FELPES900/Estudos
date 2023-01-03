#INCLUDE 'TOTVS.CH'

User Function MT410TOK()

	Local lRet     := .T.                                                                                              as Logical
	Local nX       := 0                                                                                                as Numeric
	Local cProduto := GdFieldPos("C6_PRODUTO", aHeader)                                                                as Character
	Local dDtFicti := GdFieldPos("C6_XDFICTI", aHeader)                                                                as Character
	// Local cCodLote := GdFieldPos("C6_XLTFUCT", aHeader)                                                                as Character
	Local oError   := Errorblock({|e| MsgAlert("Erro na validação do codigo. Seu codigo pode estar com problema","")}) as Object

	BEGIN SEQUENCE
		while nX < Len(aCols)
			nX++
			///////////////////////////////////////// LOGICA COMPLEXA ///////////////////////////////////////////
			/*if !Empty(Posicione("SB1", 14, xFilial("SB1") + "1" + aCols[nX][cProduto],"B1_COD"))
				if (;
						((!Empty(aCols[nX][dDtFicti]) == .F. ) .And.(!Empty(aCols[nX][cCodLote]) == .T.)) .Or.;
						((!Empty(aCols[nX][dDtFicti]) == .T. ) .And.(!Empty(aCols[nX][cCodLote]) == .F.)) .Or.;
						((!Empty(aCols[nX][dDtFicti]) == .T. ) .And.(!Empty(aCols[nX][cCodLote]) == .T.));
						)
					lRet := .F.
					Help("",1,,ProcName(),"Erro ao tentar fazer os registros verifique se os produtos selecionados"+;
						"estão com o lote ativado caso esteja preencha os campos 'Dt Ficticia' e 'Lt Ficticio'",1,0)
				endif
			endif*/
			///////////////////////////////////////////// LOGICA SIMPLES ///////////////////////////////////////////
			IF (Posicione("SB1", 14, xFilial("SB1") + "1" + aCols[nX][cProduto],"B1_XLTOE") =="1")
				If Empty(aCols[nX][dDtFicti])
					Help("",1,,ProcName(),"Erro ao tentar fazer os registros verifique se os produtos selecionados"+;
						"estão com o lote ativado caso esteja preencha os campos 'Dt Ficticia",1,0)
					lRet := .F.
				Else
					Help("",1,,ProcName(),"Erro ao tentar fazer os registros verifique se os produtos selecionados"+;
						"estão com o lote ativado caso esteja preencha os campo 'Lt Ficticio'",1,0)
					lRet := .F.
				EndIf
			ENDIF
		end
		RECOVER
		ErrorBlock( oError )
		lRet := .F.
	END SEQUENCE
Return lRet

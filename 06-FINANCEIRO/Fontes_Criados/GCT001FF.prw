#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} U_GCT001FF
Alterar todas as datas de contas a receber
@type function
@version 12.1.33
@author Felipe Fraga
@since 02/02/2023
/*/
Function U_GCT001FF()

	Local aArea      := GetArea()
	Local aColumns   := {}
	Local aRotinaBkp := {}
	Local lRet       := .T.
	Local nX         := 0
	Local oTempTable

	Private aCliente    := {}
	Private aPergs      := {}
	Private aRet        := {}
	Private cTempTable  := ""
	Private dNovaData   := Date()
	Private oMarkBrowse

	if(__cUserID $ GETMV("FS_USERSID"))

		// Faz um bkp dos botoes da rotina
		aRotinaBkp  := aClone(aRotina)

		// Limpa a tela com os botões e cria o que será utulizado
		aSize(aRotina,0)

		// Cria os novos Buttons FWMarkBrowse()
		aAdd(aRotina,{OemToAnsi("Confirmar")	,"U_ContasReceberNovaData(aCliente,dNovaData)",00,03})

		//Alimenta o array
		cTempTable := fBuildTmp(@oTempTable)

		// Selectionando a tabela temporaria
		DbSelectArea(cTempTable)

		// Selecionando o indice que foi criado
		(cTempTable)->( DbSetOrder(1) )

		// Volta para o inicio da tabela
		(cTempTable)->( DbGoTop() )

		// Adiciona os dados que retornaram da consulta SQL
		for nX := 1 to Len(aCliente)
			If( RecLock(cTempTable, .T.) )
				(cTempTable)->E1_FILIAL  := aCliente[nX][1]
				(cTempTable)->E1_CLIENTE := aCliente[nX][2]
				(cTempTable)->E1_NOMCLI  := aCliente[nX][3]
				(cTempTable)->E1_PREFIXO := aCliente[nX][4]
				(cTempTable)->E1_PARCELA := aCliente[nX][5]
				(cTempTable)->E1_LOJA    := aCliente[nX][6]
				(cTempTable)->E1_TIPO    := aCliente[nX][7]
				(cTempTable)->E1_NUM     := aCliente[nX][8]
				(cTempTable)->E1_NATUREZ := aCliente[nX][9]
				(cTempTable)->E1_XCTRALG := aCliente[nX][10]
				(cTempTable)->E1_EMISSAO := StoD(aCliente[nX][11])
				(cTempTable)->E1_VENCTO  := StoD(aCliente[nX][12])
				(cTempTable)->E1_VENCREA := StoD(aCliente[nX][13])
				(cTempTable)->E1_VALOR   := aCliente[nX][14]
				(cTempTable)->E1_BAIXA   := StoD(aCliente[nX][15])
				MsUnLock()
			EndIf
		next

		//Constrói estrutura das colunas do FWMarkBrowse
		aColumns := fBuildColumns()

		//Criando a tela de marke browse
		oMarkBrowse := FWMarkBrowse():New()

		//Indica o alias da tabela que será utilizada no Browse
		oMarkBrowse:SetAlias(cTempTable)

		//Titulo da Janela
		oMarkBrowse:SetDescription('Seleção titulos a receber')

		// Desabilita a impressão do browse
		oMarkBrowse:DisableReport()

		//Indica que o Browse utiliza tabela temporária
		oMarkBrowse:SetTemporary(.T.)

		//Adiciona uma coluna no Browse em tempo de execução
		oMarkBrowse:SetColumns(aColumns)

		//Inicializa com todos registros marcados
		oMarkBrowse:SetFieldMark( "OK" )

		// oMarkBrowse:SetAllMark( { || oMarkBrowse:AllMark() } )
		oMarkBrowse:SetMark( GetMark(), "CREC"+FWTimeStamp(1), "OK" )

		//Ativando a janela
		oMarkBrowse:Activate()

		// Deleta a table temp
		oTempTable:Delete()

		// Desativa a Model
		oMarkBrowse:DeActivate()

		// Eliminção da memória a instância do objeto informado como parâmetro.
		FreeObj(oTempTable)

		// Elimina da memória a instância do objeto informado como parâmetro.
		FreeObj(oMarkBrowse)

		// Restaurando os dados
		RestArea( aArea )

		// Limpa os Botoes da rotina e restaura como estava
		aSize(aRotina,0)
		aRotina := aClone(aRotinaBkp)
		aRotinaBkp := {}
	else
		ALERT("Você não tem permissão para usar esta rotina.")

	endif

return lRet

/*/{Protheus.doc} fBuildTmp
Cria em tempo de execução perguntas para
que a nova data seja informada, junto com
uma tabela temporaria
@type function
@version 12.1.33
@author Felipe Fraga
@since 02/02/2023
/*/
Static Function fBuildTmp(oTempTable)

	Local aTempClient := {}
	Local cAlias      := ""
	Local cClient     := SPACE(6)
	Local cContrat    := SPACE(15)
	Local cLoja       := SPACE(2)
	Local cQuery      := ""
	Local dDatFim     := Date()
	Local oQuerySE1

	// Seleciona um novo alias
	cAlias := GetNextAlias()

	// Cria as perguntas
	aadd(aPergs, {1, "Cliente"  , cClient , "", ".T.", "SA1", ".T.", 50, .T.})
	aadd(aPergs, {1, "Loja"     , cLoja   , "", ".T.", ""   , ".T.", 20, .T.})
	aadd(aPergs, {1, "Contrato" , cContrat, "", ".T.", ""   , ".T.", 70, .T.})
	aadd(aPergs, {1, "Data De"  , dDatFim , "", ".T.", ""   , ".T.", 80, .T.})
	aadd(aPergs, {1, "Data Ate" , dDatFim , "", ".T.", ""   , ".T.", 80, .T.})
	aadd(aPergs, {1, "Nova Data", dDatFim , "", ".T.", ""   , ".T.", 80, .T.})

	// Verifica se o registro existe
	if( ParamBox(aPergs, "Nova Data de Vencimento", aRet))

		// Armazena em memoria a nova data que será inserina nos titulas
		dNovaData := aRet[6]

		cQuery := " SELECT "
		cQuery += " E1_FILIAL,E1_CLIENTE,E1_NOMCLI,"
		cQuery += " E1_PREFIXO,E1_PARCELA,E1_LOJA,"
		cQuery += " E1_TIPO,E1_NUM,E1_NATUREZ,"
		cQuery += " E1_XCTRALG,E1_EMISSAO,E1_VENCTO,"
		cQuery += " E1_VENCREA,E1_VALOR,E1_BAIXA "
		cQuery += " FROM ? "
		cQuery += " WHERE "
		cQuery += " 1=1 AND E1_FILIAL = ? AND E1_CLIENTE = ? "
		cQuery += " AND E1_LOJA = ? AND E1_XCTRALG = ? "
		cQuery += " AND E1_VENCTO BETWEEN ? AND ? "
		cQuery += " AND D_E_L_E_T_ <> '*' "

		cQuery := ChangeQuery(cQuery)
		oQuerySE1 := FWPreparedStatement():New(cQuery)
		oQuerySE1:SetNumeric(1,RetSqlName('SE1'))
		oQuerySE1:SetString(2, xFilial("SE1"))
		oQuerySE1:SetString(3, aRet[1])
		oQuerySE1:SetString(4, aRet[2])
		oQuerySE1:SetString(5, aRet[3])
		oQuerySE1:SetDate(6, aRet[4])
		oQuerySE1:SetDate(7, aRet[5])
		cQuery := oQuerySE1:GetFixQuery()

		cAlias := MPSYSOpenQuery(cQuery)

		while !(cAlias)->(EOF())
			aadd(aCliente, {;
				(cAlias)->E1_FILIAL,;
				(cAlias)->E1_CLIENTE,;
				(cAlias)->E1_NOMCLI,;
				(cAlias)->E1_PREFIXO,;
				(cAlias)->E1_PARCELA,;
				(cAlias)->E1_LOJA,;
				(cAlias)->E1_TIPO,;
				(cAlias)->E1_NUM,;
				(cAlias)->E1_NATUREZ,;
				(cAlias)->E1_XCTRALG,;
				(cAlias)->E1_EMISSAO,;
				(cAlias)->E1_VENCTO,;
				(cAlias)->E1_VENCREA,;
				(cAlias)->E1_VALOR,;
				(cAlias)->E1_BAIXA})
			(cAlias)->(DBSkip())
		end
		// Adiciona o nome dos campos da tabela temporaria
		aadd(aTempClient, {"OK"                                          , "C"                    , 2                      , 0})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E1_FILIAL", "X3_CAMPO")) , TamSX3("E1_FILIAL")[3] , TamSX3("E1_FILIAL")[1] , TamSX3("E1_FILIAL")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E1_CLIENTE", "X3_CAMPO")), TamSX3("E1_CLIENTE")[3], TamSX3("E1_CLIENTE")[1], TamSX3("E1_CLIENTE")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E1_NOMCLI", "X3_CAMPO")) , TamSX3("E1_NOMCLI")[3] , TamSX3("E1_NOMCLI")[1] , TamSX3("E1_NOMCLI")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E1_PREFIXO", "X3_CAMPO")), TamSX3("E1_PREFIXO")[3], TamSX3("E1_PREFIXO")[1], TamSX3("E1_PREFIXO")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E1_PARCELA", "X3_CAMPO")), TamSX3("E1_PARCELA")[3], TamSX3("E1_PREFIXO")[1], TamSX3("E1_PREFIXO")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E1_LOJA", "X3_CAMPO"))   , TamSX3("E1_LOJA")[3]   , TamSX3("E1_LOJA")[1]   , TamSX3("E1_LOJA")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E1_TIPO", "X3_CAMPO"))   , TamSX3("E1_TIPO")[3]   , TamSX3("E1_TIPO")[1]   , TamSX3("E1_TIPO")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E1_NUM", "X3_CAMPO"))    , TamSX3("E1_NUM")[3]    , TamSX3("E1_NUM")[1]    , TamSX3("E1_NUM")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E1_NATUREZ", "X3_CAMPO")), TamSX3("E1_NATUREZ")[3], TamSX3("E1_NATUREZ")[1], TamSX3("E1_NATUREZ")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E1_XCTRALG", "X3_CAMPO")), TamSX3("E1_XCTRALG")[3], TamSX3("E1_XCTRALG")[1], TamSX3("E1_XCTRALG")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E1_EMISSAO", "X3_CAMPO")), TamSX3("E1_EMISSAO")[3], TamSX3("E1_EMISSAO")[1], TamSX3("E1_EMISSAO")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E1_VENCTO", "X3_CAMPO")) , TamSX3("E1_VENCTO")[3] , TamSX3("E1_VENCTO")[1] , TamSX3("E1_VENCTO")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E1_VENCREA", "X3_CAMPO")), TamSX3("E1_VENCREA")[3], TamSX3("E1_VENCREA")[1], TamSX3("E1_VENCREA")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E1_VALOR", "X3_CAMPO"))  , TamSX3("E1_VALOR")[3]  , TamSX3("E1_VALOR")[1]  , 2})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E1_BAIXA", "X3_CAMPO"))  , TamSX3("E1_BAIXA")[3]  , TamSX3("E1_BAIXA")[1]  , TamSX3("E1_BAIXA")[2]})

		// Começa a criação da table temp
		oTempTable:= FWTemporaryTable():New("CREC"+FWTimeStamp(1))

		// Verifica se todos os campos estao seguindo os parametros exigidos
		oTemptable:SetFields( aTempClient )

		// Cria um Index em tempo de execução
		oTempTable:AddIndex("01", {aTempClient[2][1],aTempClient[3][1], aTempClient[6][1]} )

		// Cria a table temp
		oTempTable:Create()

	else
		Help("",1,,ProcName(),"Cliente nao encontrado",1,0)
	endif

Return oTempTable:GetAlias()
/*/{Protheus.doc} fBuildColumns
Cria as colunas da table temporaria
@type function
@version 12.1.33
@author felip
@since 03/02/2023
/*/
Static Function fBuildColumns()

	Local nX       := 0
	Local aColumns := {}
	Local aStruct  := {}

	// Nome das colunas da tabela temporaria
	aadd(aStruct, {"OK"        , "OK"                                   , "C"                    , 2                      , 0})
	aadd(aStruct, {"E1_FILIAL" , GetSx3Cache("E1_FILIAL ", "X3_TITULO") , TamSX3("E1_FILIAL")[3] , TamSX3("E1_FILIAL")[1] , TamSX3("E1_FILIAL")[1]})
	aadd(aStruct, {"E1_CLIENTE", GetSx3Cache("E1_CLIENTE ", "X3_TITULO"), TamSX3("E1_CLIENTE")[3], TamSX3("E1_CLIENTE")[1], TamSX3("E1_CLIENTE")[1]})
	aadd(aStruct, {"E1_NOMCLI" , GetSx3Cache("E1_NOMCLI ", "X3_TITULO") , TamSX3("E1_NOMCLI")[3] , TamSX3("E1_NOMCLI")[1] , TamSX3("E1_NOMCLI")[1]})
	aadd(aStruct, {"E1_PREFIXO", GetSx3Cache("E1_PREFIXO ", "X3_TITULO"), TamSX3("E1_PREFIXO")[3], TamSX3("E1_PREFIXO")[1], TamSX3("E1_PREFIXO")[1]})
	aadd(aStruct, {"E1_PARCELA", GetSx3Cache("E1_PARCELA ", "X3_TITULO"), TamSX3("E1_PARCELA")[3], TamSX3("E1_PREFIXO")[1], TamSX3("E1_PREFIXO")[1]})
	aadd(aStruct, {"E1_LOJA"   , GetSx3Cache("E1_LOJA ", "X3_TITULO")   , TamSX3("E1_LOJA")[3]   , TamSX3("E1_LOJA")[1]   , TamSX3("E1_LOJA")[1]})
	aadd(aStruct, {"E1_TIPO"   , GetSx3Cache("E1_TIPO ", "X3_TITULO")   , TamSX3("E1_TIPO")[3]   , TamSX3("E1_TIPO")[1]   , TamSX3("E1_TIPO")[1]})
	aadd(aStruct, {"E1_NUM"    , GetSx3Cache("E1_NUM ", "X3_TITULO")    , TamSX3("E1_NUM")[3]    , TamSX3("E1_NUM")[1]    , TamSX3("E1_NUM")[1]})
	aadd(aStruct, {"E1_NATUREZ", GetSx3Cache("E1_NATUREZ ", "X3_TITULO"), TamSX3("E1_NATUREZ")[3], TamSX3("E1_NATUREZ")[1], TamSX3("E1_NATUREZ")[1]})
	aadd(aStruct, {"E1_XCTRALG", GetSx3Cache("E1_XCTRALG ", "X3_TITULO"), TamSX3("E1_XCTRALG")[3], TamSX3("E1_XCTRALG")[1], TamSX3("E1_XCTRALG")[1]})
	aadd(aStruct, {"E1_EMISSAO", GetSx3Cache("E1_EMISSAO ", "X3_TITULO"), TamSX3("E1_EMISSAO")[3], TamSX3("E1_EMISSAO")[1], TamSX3("E1_EMISSAO")[1]})
	aadd(aStruct, {"E1_VENCTO" , GetSx3Cache("E1_VENCTO ", "X3_TITULO") , TamSX3("E1_VENCTO")[3] , TamSX3("E1_VENCTO")[1] , TamSX3("E1_VENCTO")[1]})
	aadd(aStruct, {"E1_VENCREA", GetSx3Cache("E1_VENCREA ", "X3_TITULO"), TamSX3("E1_VENCREA")[3], TamSX3("E1_VENCREA")[1], TamSX3("E1_VENCREA")[1]})
	aadd(aStruct, {"E1_VALOR"  , GetSx3Cache("E1_VALOR ", "X3_TITULO")  , TamSX3("E1_VALOR")[3]  , TamSX3("E1_VALOR")[1]  , 2})
	aadd(aStruct, {"E1_BAIXA"  , GetSx3Cache("E1_BAIXA ", "X3_TITULO")  , TamSX3("E1_BAIXA")[3]  , TamSX3("E1_BAIXA")[1]  , TamSX3("E1_BAIXA")[1]})

	For nX := 1 To Len(aStruct)
		// pula a primeira coluna
		if(aStruct[nX][1] <> 'OK')
			// Adiciona as informações e tipos das colunas
			AAdd(aColumns,FWBrwColumn():New())
			aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nX][1]+"}") )
			aColumns[Len(aColumns)]:SetTitle(aStruct[nX][2])
			aColumns[Len(aColumns)]:SetType(aStruct[nX][3])
			aColumns[Len(aColumns)]:SetSize(aStruct[nX][4])
			aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][5])

		endif
	Next
Return aColumns

/*/{Protheus.doc} U_ContasReceberNovaData
Atualiza as datas
@type function
@version 12.1.33
@author felip
@since 06/02/2023
/*/
Function U_ContasReceberNovaData(aCliente,dNovaData)

	Local lRet   := .T.
	Local nValor := 0
	Local nX     := 1

	// Seleciona a table de titulas a pagar
	DBSelectArea("SE1")

	// Seleciona o indice que será usado
	DBSetOrder(2)

	// Retorna para o começo dos registros da table temp
	(cTempTable)->(DBGOTOP())
	While (cTempTable)->(!eof())

		// Ve quais registros estão marcados com um OK
		if (cTempTable)->OK == oMarkBrowse:Mark()

			// Posicina no registro
			if(DBSeek(xFilial("SE1") + (cTempTable)->E1_CLIENTE + (cTempTable)->E1_LOJA + (cTempTable)->E1_PREFIXO + (cTempTable)->E1_NUM + (cTempTable)->E1_PARCELA))

				// Atualiza o registro pocisionado
				if(RecLock("SE1",.F.))
					SE1->E1_VENCTO :=  dNovaData
					SE1->E1_VENCREA := dNovaData

					// Finaliza a operação
					MsUnLock()
				endif
			endif
			nX++
			nValor++
		endif
		(cTempTable)->(DBSkip())
	end

	// Avisa quandos registros foram alterados
	FWAlertSuccess("Sucesso nas atualizações", "Foram atualizadas " + Str(nValor) + " parcelas.")

	// Fecha a tela e volta para a tela principal
	CloseBrowse()

Return lRet

// 000043

#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} U_GCT002FF
Alterar todas as datas de contas a pagar
@type function
@version 12.1.33
@author Felipe Fraga
@since 02/02/2023
/*/

//
// FSW-551 --> Novo Botão do titulos a pagar
//
Function U_GCT002FF()

	Local aArea      := GetArea()
	Local aColumns   := {}
	Local aRotinaBkp := {}
	Local lRet       := .T.
	Local nX         := 0

	Private oTempTable
	Private aFornecedor := {}
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
		aAdd(aRotina,{OemToAnsi("Confirmar")	,"U_ContasPagarNovaData(dNovaData)",00,03})

		//Alimenta o array
		cTempTable := fBuildTmp(@oTempTable)

		// Selectionando a tabela temporaria
		DbSelectArea(cTempTable)

		// Selecionando o indice que foi criado
		(cTempTable)->( DbSetOrder(1) )

		// Volta para o inicio da tabela
		(cTempTable)->( DbGoTop() )

		// Adiciona os dados que retornaram da consulta SQL
		for nX := 1 to Len(aFornecedor)
			If( RecLock(cTempTable, .T.) )
				(cTempTable)->E2_FILIAL  := aFornecedor[nX][1]
				(cTempTable)->E2_FORNECE := aFornecedor[nX][2]
				(cTempTable)->E2_NOMFOR  := aFornecedor[nX][3]
				(cTempTable)->E2_PREFIXO := aFornecedor[nX][4]
				(cTempTable)->E2_PARCELA := aFornecedor[nX][5]
				(cTempTable)->E2_LOJA    := aFornecedor[nX][6]
				(cTempTable)->E2_TIPO    := aFornecedor[nX][7]
				(cTempTable)->E2_NUM     := aFornecedor[nX][8]
				(cTempTable)->E2_NATUREZ := aFornecedor[nX][9]
				(cTempTable)->E2_XCTRALG := aFornecedor[nX][10]
				(cTempTable)->E2_EMISSAO := StoD(aFornecedor[nX][11])
				(cTempTable)->E2_VENCTO  := StoD(aFornecedor[nX][12])
				(cTempTable)->E2_VENCREA := StoD(aFornecedor[nX][13])
				(cTempTable)->E2_VALOR   := aFornecedor[nX][14]
				(cTempTable)->E2_BAIXA   := StoD(aFornecedor[nX][15])
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
		oMarkBrowse:SetDescription('Seleção titulos a pagar')

		// Desabilita a impressão do browse
		oMarkBrowse:DisableReport()

		//Indica que o Browse utiliza tabela temporária
		oMarkBrowse:SetTemporary(.T.)

		//Adiciona uma coluna no Browse em tempo de execução
		oMarkBrowse:SetColumns(aColumns)

		//Inicializa com todos registros marcados
		oMarkBrowse:SetFieldMark( "OK" )

		// oMarkBrowse:SetAllMark( { || oMarkBrowse:AllMark() } )
		oMarkBrowse:SetMark( GetMark(), "CPAG_"+FWTimeStamp(1), "OK" )

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
		ALERT("Você não tem permição para usar está rotina.")
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
	Local dData       := Date()
	Local cQuery := ""
	Local oQuerySE2

	// Seleciona um novo alias
	cAlias := GetNextAlias()

	// Cria as perguntas
	aadd(aPergs, {1, "Cliente"  , cClient , "", ".T.", "SA2", ".T.", 50, .T.})
	aadd(aPergs, {1, "Loja"     , cLoja   , "", ".T.", ""   , ".T.", 20, .T.})
	aadd(aPergs, {1, "Contrato" , cContrat, "", ".T.", ""   , ".T.", 70, .T.})
	aadd(aPergs, {1, "Data De"  , dData   , "", ".T.", ""   , ".T.", 80, .T.})
	aadd(aPergs, {1, "Data Ate" , dData   , "", ".T.", ""   , ".T.", 80, .T.})
	aadd(aPergs, {1, "Nova Data", dData   , "", ".T.", ""   , ".T.", 80, .T.})

	// Verifica se as perguntas foram preenchidas
	if( ParamBox(aPergs, "Nova Data de Vencimento", aRet))

		// Armazena em memoria a nova data que será inserina nos titulas
		dNovaData := aRet[6]

		cQuery := " SELECT "
		cQuery += " E2_FILIAL,E2_FORNECE,E2_NOMFOR, "
		cQuery += " E2_PREFIXO,E2_PARCELA,E2_LOJA, "
		cQuery += " E2_TIPO,E2_NUM,E2_NATUREZ, "
		cQuery += " E2_XCTRALG,E2_EMISSAO,E2_VENCTO, "
		cQuery += " E2_VENCREA,E2_VALOR,E2_BAIXA "
		cQuery += " FROM ? "
		cQuery += " WHERE "
		cQuery += " 1 = 1 AND E2_FILIAL = ?	AND E2_FORNECE = ? "
		cQuery += " AND E2_LOJA = ?	AND E2_XCTRALG = ? "
		cQuery += " AND E2_VENCTO BETWEEN ?	AND ? "
		cQuery += " AND D_E_L_E_T_ <> '*' "

		cQuery := ChangeQuery(cQuery)
		oQuerySE2 := FWPreparedStatement():New(cQuery)
		oQuerySE2:SetNumeric(1,RetSqlName('SE2'))
		oQuerySE2:SetString(2, xFilial("SE2"))
		oQuerySE2:SetString(3, aRet[1])
		oQuerySE2:SetString(4, aRet[2])
		oQuerySE2:SetString(5, aRet[3])
		oQuerySE2:SetDate(6, aRet[4])
		oQuerySE2:SetDate(7, aRet[5])
		cQuery := oQuerySE2:GetFixQuery()

		cAlias := MPSYSOpenQuery(cQuery)

		while !(cAlias)->(EOF())
			aadd(aFornecedor, {;
				(cAlias)->E2_FILIAL,;
				(cAlias)->E2_FORNECE,;
				(cAlias)->E2_NOMFOR,;
				(cAlias)->E2_PREFIXO,;
				(cAlias)->E2_PARCELA,;
				(cAlias)->E2_LOJA,;
				(cAlias)->E2_TIPO,;
				(cAlias)->E2_NUM,;
				(cAlias)->E2_NATUREZ,;
				(cAlias)->E2_XCTRALG,;
				(cAlias)->E2_EMISSAO,;
				(cAlias)->E2_VENCTO,;
				(cAlias)->E2_VENCREA,;
				(cAlias)->E2_VALOR,;
				(cAlias)->E2_BAIXA})
			(cAlias)->(DBSkip())
		end
		// Adiciona o nome dos campos da tabela temporaria
		aadd(aTempClient, {"OK"                                           , "C"                    , 2                      , 0})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E2_FILIAL ", "X3_CAMPO")), TamSX3("E2_FILIAL")[3] , TamSX3("E2_FILIAL")[1] , TamSX3("E2_FILIAL")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E2_FORNECE", "X3_CAMPO")), TamSX3("E2_FORNECE")[3], TamSX3("E2_FORNECE")[1], TamSX3("E2_FORNECE")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E2_NOMFOR", "X3_CAMPO")) , TamSX3("E2_NOMFOR")[3] , TamSX3("E2_NOMFOR")[1] , TamSX3("E2_NOMFOR")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E2_PREFIXO", "X3_CAMPO")), TamSX3("E2_PREFIXO")[3], TamSX3("E2_PREFIXO")[1], TamSX3("E2_PREFIXO")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E2_PARCELA", "X3_CAMPO")), TamSX3("E2_PARCELA")[3], TamSX3("E2_PARCELA")[1], TamSX3("E2_PARCELA")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E2_LOJA", "X3_CAMPO"))   , TamSX3("E2_LOJA")[3]   , TamSX3("E2_LOJA")[1]   , TamSX3("E2_LOJA")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E2_TIPO", "X3_CAMPO"))   , TamSX3("E2_TIPO")[3]   , TamSX3("E2_TIPO")[1]   , TamSX3("E2_TIPO")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E2_NUM", "X3_CAMPO"))    , TamSX3("E2_NUM")[3]    , TamSX3("E2_NUM")[1]    , TamSX3("E2_NUM")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E2_NATUREZ", "X3_CAMPO")), TamSX3("E2_NATUREZ")[3], TamSX3("E2_NATUREZ")[1], TamSX3("E2_NATUREZ")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E2_XCTRALG", "X3_CAMPO")), TamSX3("E2_XCTRALG")[3], TamSX3("E2_XCTRALG")[1], TamSX3("E2_XCTRALG")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E2_EMISSAO", "X3_CAMPO")), TamSX3("E2_EMISSAO")[3], TamSX3("E2_EMISSAO")[1], TamSX3("E2_EMISSAO")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E2_VENCTO", "X3_CAMPO")) , TamSX3("E2_VENCTO")[3] , TamSX3("E2_VENCTO")[1] , TamSX3("E2_VENCTO")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E2_VENCREA", "X3_CAMPO")), TamSX3("E2_VENCREA")[3], TamSX3("E2_VENCREA")[1], TamSX3("E2_VENCREA")[2]})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E2_VALOR", "X3_CAMPO"))  , TamSX3("E2_VALOR")[3]  , TamSX3("E2_VALOR")[1]  , 2})
		aadd(aTempClient, {AllTrim(GetSx3Cache("E2_BAIXA", "X3_CAMPO"))  , TamSX3("E2_BAIXA")[3]  , TamSX3("E2_BAIXA")[1]  , TamSX3("E2_BAIXA")[2]})

		// Começa a criação da table temp
		oTempTable:= FWTemporaryTable():New("CPAG_"+FWTimeStamp(1))

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
Cria as colunas que serão apresentadas no browse
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
	aadd(aStruct, {"E2_FILIAL" , GetSx3Cache("E2_FILIAL ", "X3_TITULO") , TamSX3("E2_FILIAL")[3] , TamSX3("E2_FILIAL")[1] , TamSX3("E2_FILIAL")[2]})
	aadd(aStruct, {"E2_FORNECE", GetSx3Cache("E2_FORNECE ", "X3_TITULO"), TamSX3("E2_FORNECE")[3], TamSX3("E2_FORNECE")[1], TamSX3("E2_FORNECE")[2]})
	aadd(aStruct, {"E2_NOMFOR" , GetSx3Cache("E2_NOMFOR ", "X3_TITULO") , TamSX3("E2_NOMFOR")[3] , TamSX3("E2_NOMFOR")[1] , TamSX3("E2_NOMFOR")[2]})
	aadd(aStruct, {"E2_PREFIXO", GetSx3Cache("E2_PREFIXO ", "X3_TITULO"), TamSX3("E2_PREFIXO")[3], TamSX3("E2_PREFIXO")[1], TamSX3("E2_PREFIXO")[2]})
	aadd(aStruct, {"E2_PARCELA", GetSx3Cache("E2_PARCELA ", "X3_TITULO"), TamSX3("E2_PARCELA")[3], TamSX3("E2_PARCELA")[1], TamSX3("E2_PARCELA")[2]})
	aadd(aStruct, {"E2_LOJA"   , GetSx3Cache("E2_LOJA ", "X3_TITULO")   , TamSX3("E2_LOJA")[3]   , TamSX3("E2_LOJA")[1]   , TamSX3("E2_LOJA")[2]})
	aadd(aStruct, {"E2_TIPO"   , GetSx3Cache("E2_TIPO ", "X3_TITULO")   , TamSX3("E2_TIPO")[3]   , TamSX3("E2_TIPO")[1]   , TamSX3("E2_TIPO")[2]})
	aadd(aStruct, {"E2_NUM"    , GetSx3Cache("E2_NUM ", "X3_TITULO")    , TamSX3("E2_NUM")[3]    , TamSX3("E2_NUM")[1]    , TamSX3("E2_NUM")[2]})
	aadd(aStruct, {"E2_NATUREZ", GetSx3Cache("E2_NATUREZ ", "X3_TITULO"), TamSX3("E2_NATUREZ")[3], TamSX3("E2_NATUREZ")[1], TamSX3("E2_NATUREZ")[2]})
	aadd(aStruct, {"E2_XCTRALG", GetSx3Cache("E2_XCTRALG ", "X3_TITULO"), TamSX3("E2_XCTRALG")[3], TamSX3("E2_XCTRALG")[1], TamSX3("E2_XCTRALG")[2]})
	aadd(aStruct, {"E2_EMISSAO", GetSx3Cache("E2_EMISSAO ", "X3_TITULO"), TamSX3("E2_EMISSAO")[3], TamSX3("E2_EMISSAO")[1], TamSX3("E2_EMISSAO")[2]})
	aadd(aStruct, {"E2_VENCTO" , GetSx3Cache("E2_VENCTO ", "X3_TITULO") , TamSX3("E2_VENCTO")[3] , TamSX3("E2_VENCTO")[1] , TamSX3("E2_VENCTO")[2]})
	aadd(aStruct, {"E2_VENCREA", GetSx3Cache("E2_VENCREA ", "X3_TITULO"), TamSX3("E2_VENCREA")[3], TamSX3("E2_VENCREA")[1], TamSX3("E2_VENCREA")[2]})
	aadd(aStruct, {"E2_VALOR"  , GetSx3Cache("E2_VALOR ", "X3_TITULO")  , TamSX3("E2_VALOR")[3]  , TamSX3("E2_VALOR")[1]  , 2})
	aadd(aStruct, {"E2_BAIXA"  , GetSx3Cache("E2_BAIXA ", "X3_TITULO")  , TamSX3("E2_BAIXA")[3]  , TamSX3("E2_BAIXA")[1]  , TamSX3("E2_BAIXA")[2]})

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

/*/{Protheus.doc} U_ContasPagarNovaData
Atualiza as datas
@type function
@version 12.1.33
@author felip
@since 06/02/2023
/*/
Function U_ContasPagarNovaData(dNovaData)

	Local lRet   := .T.
	Local nValor := 0
	Local nX     := 1
	Local cFilterBkp := SE2->(DBFilter())

	// Seleciona a table de titulas a pagar
	DBSelectArea("SE2")
	DBClearFilter()

	// Seleciona o indice que será usado
	DBSetOrder(6)

	// Retorna para o começo dos registros da table temp
	(cTempTable)->(DBGOTOP())
	While (cTempTable)->(!eof())

		// Ve quais registros estão marcados com um OK
		if (cTempTable)->OK == oMarkBrowse:Mark()

			// Posicina no registro
			if(MsSeek(xFilial("SE2") + (cTempTable)->(E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM + E2_PARCELA)))

				// Atualiza o registro pocisionado
				if(RecLock("SE2",.F.))
					SE2->E2_VENCTO :=  dNovaData
					SE2->E2_VENCREA := dNovaData

					// Finaliza a operação
					MsUnLock()
				endif
			endif
			nX++
			nValor++
		endif
		(cTempTable)->(DBSkip())
	end

	dbSetFilter({|| &cFilterBkp }, cFilterBkp )

	// Avisa quandos registros foram alterados
	FWAlertSuccess("Sucesso nas atualizações", "Foram atualizadas " + Str(nValor) + " parcelas.")

	// Fecha a tela e volta para a tela principal
	CloseBrowse()

Return lRet

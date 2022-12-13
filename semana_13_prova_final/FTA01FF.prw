#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

Function u_FTA01FF()

	Local oBrowse as Object

	// Instancia da classe do browse
	oBrowse := FWMBrowse():New()

	// Definição da tabela
	oBrowse:SetAlias('SZ4')

	// Titulo do Browse
	oBrowse:SetDescription('Movimentação')

	oBrowse:SetMenuDef("FTA01FF")

	oBrowse:Activate()

Return NIL

Static Function MenuDef()
	Local aRotina := {} as Array

	ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PESQBRW" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.FTA01FF' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.FTA01FF' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.FTA01FF' OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruSZ4 := FWFormStruct( 1, 'SZ4' , /*bAvalCampo*/, /*lViewUsado*/ ) as Object
	Local oModel                                                                as Object

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('FTMA01FF', {|| novosaldo()}, /*bPosValidacao*/, {|oModel| GRVSaldo(oModel)}, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'SZ4MASTER', /*cOwner*/, oStruSZ4, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Modelo de Dados de Autor/Interprete' )

	// // Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'SZ4MASTER' ):SetDescription( 'Dados de Autor/Interprete' )

	// Chave primaria
	oModel:SetPrimaryKey({})

Return oModel

Static Function ViewDef()

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'FTA01FF' ) as Object
	// Cria a estrutura a ser usada na View
	Local oStruSZ4 := FWFormStruct( 2, 'SZ4' ) as Object
	Local oView                                as Object

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_SZ4', oStruSZ4, 'SZ4MASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_SZ4', 'TELA' )

Return oView

Static function novosaldo()

	Local lRet := .T. as Logical

	// Selecionando a tabela SZ3
	DbSelectArea("SZ3")

	// Pegando o segundo Indice da tabela
	DbSetOrder(2)

	// Verificando no Indice se o retorno será TRUE
	IF( DbSeek(xFilial("SZ3") + M->Z4_CCONTRA + FWFLDGet("Z4_CODPROD")))

		// Verifica se o peso de saida e maior que o saldo disponivel
		if(M->Z4_PEOSSAI > SZ3->Z3_QSALDO)
			APMsginfo("O peso de saída nao pode ser maior que o saldo disponivel","ATENÇÃO")
			lRet := .F.
			M->Z4_PEOSSAI := 0
		else
			lRet := .T.
		endif
	endif

Return lRet

Static Function GRVSaldo(oModelSZ4)

	// Chamando a user function de contratos para buscar suas models
	Local oModelSZ3 := FWLoadModel("GCTA01FF")	as Object
	Local oSZ3Detail 							as Object

	// Pegando o tipo de operação que esta sendo executada
	Local nOperation := oModelSZ4:GetOperation() as Numeric
	Local lRet := .T.						 	 as Logical
	Local aArea := FwGetArea()
	Local oSZ4Master := oModelSZ4:GetModel("SZ4MASTER")

	// Buscando qual o tipo de operação que esta sendo executada
	oModelSZ3:SetOperation(MODEL_OPERATION_UPDATE)

	// Ativando a model da SZ3
	oModelSZ3:Activate()

	// Chamando a model dos produtos relacionados a o contrato
	oSZ3Detail := oModelSZ3:GetModel('SZ3DETAIL')

	// Chamando a tabela de produtos relacionadas ao contrato
	DbSelectArea("SZ3")

	// Chamando o segundo Indice da tabela
	DbSetOrder(2)

	// Verificando se a consulta será TRUE
	//if( DbSeek(xFilial("SZ3") + M->Z4_CCONTRA + FwFldGet("Z4_CODPROD",,oModelSZ4)))

	If oSZ3Detail:SeekLine({{"Z3_FILIAL",xFilial("SZ3")},{"Z3_CODCON",oSZ4Master:GetValue("Z4_CCONTRA")},{"Z3_CODPROD",oSZ4Master:GetValue("Z4_CODPROD")}})
		// Vendo qual o tipo de operação que será executada
		if(nOperation == 3)
			oSZ3Detail:SetValue("Z3_QSALDO",(SZ3->Z3_QSALDO - M->Z4_PEOSSAI))
			oSZ3Detail:SetValue("Z3_QSAIDA",(SZ3->Z3_QSAIDA + M->Z4_PEOSSAI))
		elseif(nOperation == 5)
			oSZ3Detail:SetValue("Z3_QSALDO",(SZ3->Z3_QSALDO + M->Z4_PEOSSAI))
			oSZ3Detail:SetValue("Z3_QSAIDA",(SZ3->Z3_QSAIDA - M->Z4_PEOSSAI))
		endif
		//Grava modelo da SZ3
		If oModelSZ3:VldData()
			oModelSZ3:CommitData()
		Else
			lRet := .F.
			cLog := cValToChar(oModelSZ3:GetErrorMessage()[4]) + ' - '
			cLog += cValToChar(oModelSZ3:GetErrorMessage()[5]) + ' - '
			cLog += cValToChar(oModelSZ3:GetErrorMessage()[6])

			Help( ,,"CONTRATOS",,cLog, 1, 0 )
		Endif
	endif
	//Fecha model e a area da SZ3
	oModelSZ3:DeActivate()
	oModelSZ3 := Nil
	SZ3->(DbCloseArea())
	//Volto o posicionamento para a SZ4 e faço o commit
	FwRestArea(aArea)
	//Grava modelo principal
	If oModelSZ4:VldData()
		lRet := FWFormCommit(oModelSZ4)
	Else
		lRet := .F.
	EndIf

Return lRet

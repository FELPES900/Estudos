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
	oModel := MPFormModel():New('FTMA01FF', {|| novosaldo()},{|oModel| GRVSaldo(oModel)},/*bCommit*/, /*bCancel*/ )

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

	Local lRet       := .T.                               as Logical
	Local nOperation := oModelSZ4:GetOperation()          as Numeric

	// Chamando a tabela de produtos relacionadas ao contrato
	DbSelectArea("SZ3")

	// Chamando o segundo Indice da tabela
	DbSetOrder(1)

	if DbSeek(xFilial("SZ3") + SZ4->Z4_CODPROD + SZ4->Z4_CCONTRA)

		// Vendo qual o tipo de operação que será executada
		if(nOperation == 3)
			RecLock("SZ3", .F.)
			SZ3->Z3_QSALDO := (SZ3->Z3_QSALDO - SZ4->Z4_PEOSSAI)
			SZ3->Z3_QSAIDA := (SZ3->Z3_QSAIDA + SZ4->Z4_PEOSSAI)
			MsUnlock()
		elseif(nOperation == 5)
			RecLock("SZ3", .F.)
			SZ3->Z3_QSALDO := (SZ3->Z3_QSALDO + SZ4->Z4_PEOSSAI)
			SZ3->Z3_QSAIDA := (SZ3->Z3_QSAIDA - SZ4->Z4_PEOSSAI)
			MsUnlock()
		endif

	endif

Return lRet

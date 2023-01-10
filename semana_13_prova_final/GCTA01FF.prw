#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

Function u_GCTA01FF()

	Local oBrowse as Object

	// Instancia da classe do browse
	oBrowse := FWmBrowse():New()

	// Definição da tabela
	oBrowse:SetAlias( 'SZ2' )

	// Titulo do Browse
	oBrowse:SetDescription( 'Contratos' )

	oBrowse:SetMenuDef("GCTA01FF")

	// Tipos de Legendas no Browse
	oBrowse:AddLegend( "Z2_STATUS=='1'", "GREEN"  , "Aberto"    )
	oBrowse:AddLegend( "Z2_STATUS=='2'", "YELLOW" , "Andamento" )
	oBrowse:AddLegend( "Z2_STATUS=='3'", "RED"    , "Finalizado")

	oBrowse:Activate()

Return NIL

Static Function MenuDef()

	Local aRotina := {} as Array

	ADD OPTION aRotina Title 'Visualizar'  Action 'VIEWDEF.GCTA01FF' OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Incluir'     Action 'VIEWDEF.GCTA01FF' OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Alterar'     Action 'VIEWDEF.GCTA01FF' OPERATION 4 ACCESS 0
	ADD OPTION aRotina Title 'Excluir'     Action 'VIEWDEF.GCTA01FF' OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruSZ2 := FWFormStruct( 1, 'SZ2' ) as Object
	Local oStruSZ3 := FWFormStruct( 1, 'SZ3' ) as Object
	Local oModel                               as Object

	// Modifica a legenda dos contratos
	validacao()

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New( 'GCTM01FF', /*bPreValidacao*/,{|oModel| excluicontrato(oModel)}, /*bCommit*/, /*bCancel*/ )

	oModel:SetVldActivate({|oModel|tipoperacao(oModel)})

	// Adiciona ao modelo uma estrutura de formulÃ¡rio de ediÃ§Ã£o por campo
	oModel:AddFields( 'SZ2MASTER', /*cOwner*/, oStruSZ2 )

	// Adiciona ao modelo uma estrutura de formulÃ¡rio de ediÃ§Ã£o por grid
	oModel:AddGrid( 'SZ3DETAIL', 'SZ2MASTER', oStruSZ3, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

	// Faz relaciomaneto entre os compomentes do model
	oModel:SetRelation( 'SZ3DETAIL', { { 'Z3_FILIAL', 'xFilial( "SZ2" )' }, { 'Z3_CODCON', 'Z2_CODCON' } }, SZ3->( IndexKey( 1 ) ) )

	// Liga o controle de nao repeticao de linha
	oModel:GetModel( 'SZ3DETAIL' ):SetUniqueLine( { 'Z3_CODPROD' } )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Contratos' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'SZ2MASTER' ):SetDescription( 'Contrato' )
	oModel:GetModel( 'SZ3DETAIL' ):SetDescription( 'Produtos do contrato'  )

	// Campos travados ou nao travados --> validando com o tipo de contrato
	oStruSZ2:SetProperty("Z2_LFISICO",MODEL_FIELD_WHEN,{|oModel| valida(oModel,1)})
	oStruSZ2:SetProperty("Z2_CLIFISI",MODEL_FIELD_WHEN,{|oModel| valida(oModel,1)})
	oStruSZ2:SetProperty("Z2_NCFISIC",MODEL_FIELD_WHEN,{|oModel| valida(oModel,1)})
	oStruSZ2:SetProperty("Z2_LFISCA" ,MODEL_FIELD_WHEN,{|oModel| valida(oModel,2)})
	oStruSZ2:SetProperty("Z2_CFISCAL",MODEL_FIELD_WHEN,{|oModel| valida(oModel,2)})
	oStruSZ2:SetProperty("Z2_NCFISCA",MODEL_FIELD_WHEN,{|oModel| valida(oModel,2)})

	// calcula quanto de saldo tem disponivel
	oStruSZ3:AddTrigger( 'Z3_QORIGIN', 'Z3_QSALDO', {||.T. }, {||u_AttSaldo(oModel)} )
	oStruSZ3:AddTrigger( 'Z3_QSAIDA', 'Z3_QSALDO',  {||.T. }, {||u_AttSaldo(oModel)} )

	// Define a chave primaria
	oModel:SetPrimaryKey({"Z2_FILIAL","Z2_CODCON"})

Return oModel

Static Function ViewDef()

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oStruSZ2 := FWFormStruct( 2, 'SZ2' )  as Object
	Local oStruSZ3 := FWFormStruct( 2, 'SZ3' )  as Object
	// Cria a estrutura a ser usada na View
	Local oModel   := FWLoadModel( 'GCTA01FF' ) as Object
	Local oView                                 as Object

	// Remove o campo da grid
	oStruSZ3:RemoveField('Z3_CODCON')

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados serão utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_SZ2', oStruSZ2, 'SZ2MASTER' )

	//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
	oView:AddGrid(  'VIEW_SZ3', oStruSZ3, 'SZ3DETAIL' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR', 45 )
	oView:CreateHorizontalBox( 'INFERIOR', 55 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_SZ2', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_SZ3', 'INFERIOR' )

Return oView

// Fala se os cliente sao do tipo Fiscal ou do tipo Fisico
Static Function valida(oModel, nValor)
	Local lRet  := .F.  as Logical

	// Ativa os campos que serao necessarios dependendo do tipo do contrato
	If((oModel:GetValue("Z2_TIPOCON") == "1" .and. nValor == 1) .or. (oModel:GetValue("Z2_TIPOCON") == "2" .and. nValor == 2))
		lRet := .T.
	endif

Return lRet

// Verificando se a quantidade original e maior ou igual a quantidade de saida
// se nao ele da um HELP falando que o saldo nao pode ser maior que a quantidade original
Function u_attsaldo(oModel)

	Local nValor := 0
	Local oMdlSZ3 := oModel:GetModel('SZ3DETAIL')

	// Subtração que verifica se o saldo e menor que zero
	nValor := oMdlSZ3:GetValue("Z3_QORIGIN") - oMdlSZ3:GetValue("Z3_QSAIDA")

	// Retorno caso seja TRUE
	if(nValor < 0)
		Help("",1,,ProcName(),"A quantidade de saldo não pode ser menor do que Zero",1,0)
		nValor := 0
	Endif

Return nValor

Static function validacao()

	Local cUpZPB1 as Character
	Local cUpZPB2 as Character
	Local cUpZPB3 as Character

	//-- ABERTO
	cUpZPB1 := "UPDATE"
	cUpZPB1 += "	Z2 SET Z2.Z2_STATUS = '1'"
	cUpZPB1 += "FROM"
	cUpZPB1 += "	SZ2990 AS Z2"
	cUpZPB1 += "INNER JOIN("
	cUpZPB1 += "	SELECT"
	cUpZPB1 += "		Z3_CODCON,"
	cUpZPB1 += "		Z3_FILIAL,"
	cUpZPB1 += "		SUM(Z3_QSALDO) AS 'Z3_QSALDO',"
	cUpZPB1 += "		SUM(Z3_QORIGIN) AS 'Z3_QORIGIN',"
	cUpZPB1 += "		SUM(Z3_QSAIDA) AS 'Z3_QSAIDA'"
	cUpZPB1 += "	FROM"
	cUpZPB1 += "		SZ3990"
	cUpZPB1 += "	GROUP BY"
	cUpZPB1 += "		Z3_FILIAL,"
	cUpZPB1 += "		Z3_CODCON)AS Z3 ON"
	cUpZPB1 += "		Z2_CODCON = Z3_CODCON"
	cUpZPB1 += "		AND Z2_FILIAL = Z3_FILIAL"
	cUpZPB1 += "	WHERE"
	cUpZPB1 += "		Z3_QSALDO = Z3_QORIGIN"

	TCSqlExec(cUpZPB1)

	//-- PARCIAL
	cUpZPB2 := "UPDATE"
	cUpZPB2 += "	Z2 SET Z2.Z2_STATUS = '2'"
	cUpZPB2 += "FROM"
	cUpZPB2 += "	SZ2990 AS Z2"
	cUpZPB2 += "INNER JOIN("
	cUpZPB2 += "	SELECT"
	cUpZPB2 += "		Z3_CODCON,"
	cUpZPB2 += "		Z3_FILIAL,"
	cUpZPB2 += "		SUM(Z3_QSALDO) AS 'Z3_QSALDO',"
	cUpZPB2 += "		SUM(Z3_QORIGIN) AS 'Z3_QORIGIN',"
	cUpZPB2 += "		SUM(Z3_QSAIDA) AS 'Z3_QSAIDA'"
	cUpZPB2 += "	FROM"
	cUpZPB2 += "		SZ3990"
	cUpZPB2 += "	GROUP BY"
	cUpZPB2 += "		Z3_FILIAL,"
	cUpZPB2 += "		Z3_CODCON)AS Z3 ON"
	cUpZPB2 += "		Z2_CODCON = Z3_CODCON"
	cUpZPB2 += "		AND Z2_FILIAL = Z3_FILIAL"
	cUpZPB2 += "	WHERE"
	cUpZPB2 += "		Z3_QSAIDA > 0 AND Z3_QSAIDA < Z3_QORIGIN"

	TCSqlExec(cUpZPB2)

	//-- FINALIZADA
	cUpZPB3 := "UPDATE"
	cUpZPB3 += "	Z2 SET Z2.Z2_STATUS = '3'"
	cUpZPB3 += "FROM"
	cUpZPB3 += "	SZ2990 AS Z2"
	cUpZPB3 += "INNER JOIN("
	cUpZPB3 += "	SELECT"
	cUpZPB3 += "		Z3_CODCON,"
	cUpZPB3 += "		Z3_FILIAL,"
	cUpZPB3 += "		SUM(Z3_QSALDO) AS 'Z3_QSALDO',"
	cUpZPB3 += "		SUM(Z3_QORIGIN) AS 'Z3_QORIGIN',"
	cUpZPB3 += "		SUM(Z3_QSAIDA) AS 'Z3_QSAIDA'"
	cUpZPB3 += "	FROM"
	cUpZPB3 += "		SZ3990"
	cUpZPB3 += "	GROUP BY"
	cUpZPB3 += "		Z3_FILIAL,"
	cUpZPB3 += "		Z3_CODCON)AS Z3 ON"
	cUpZPB3 += "		Z2_CODCON = Z3_CODCON"
	cUpZPB3 += "		AND Z2_FILIAL = Z3_FILIAL"
	cUpZPB3 += "	WHERE"
	cUpZPB3 += "		Z3_QSAIDA = Z3_QORIGIN"

	TCSqlExec(cUpZPB3)

Return

Static function excluicontrato(oModel)

	Local lRet := .T.
	Local oSZ2Master := oModel:GetModel("SZ2MASTER")

	// Selecionando a tabela de movimentcao
	DbSelectArea("SZ4")

	// Chamando o indice
	DbSetOrder(2)

	// Verifica se a alguma movimentação usando o contrato
	if (DbSeek(xFilial("SZ4") + oSZ2Master:GetValue("Z2_CODCON")))
		lRet := .F.
		APMsginfo("O contrato não pode ser excluido pois existe movimentações que estão usando este contrato","ATENÇÃO")
	endif

Return

Static function tipoperacao(oModel)

	Local nOperation

	nOperation := oModel:GetOperation()

	if (nOperation == 4 .And.SZ2->Z2_STATUS == "3")
		oModel:GetModel("SZ2MASTER"):GetStruct():SetProperty( '*'  , MODEL_FIELD_WHEN, {|| .F.} )
		oModel:GetModel("SZ3DETAIL"):GetStruct():SetProperty( '*'  , MODEL_FIELD_WHEN, {|| .F.} )
	endif

Return .T.

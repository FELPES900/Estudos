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
	Local oStruSZ2 := FWFormStruct( 1, 'SZ2' , /*bAvalCampo*/, /*lViewUsado*/ ) as Object
	Local oStruSZ3 := FWFormStruct( 1, 'SZ3' , /*bAvalCampo*/, /*lViewUsado*/ ) as Object
	Local oModel                                                                as Object

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New( 'GCTM01FF', /*bPreValidacao*/, {|oModel| modalValida(oModel)}, /*bCommit*/, /*bCancel*/ )

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
	oModel:GetModel( 'SZ2MASTER' ):SetDescription( 'Contato' )
	oModel:GetModel( 'SZ3DETAIL' ):SetDescription( 'Produtos do contrato'  )

	// Campos travados ou nao travados --> validando com o tipo de contrato
	oStruSZ2:SetProperty("Z2_LFISICO",MODEL_FIELD_WHEN,{|oModel| valida(oModel,1)})
	oStruSZ2:SetProperty("Z2_CLIFISI",MODEL_FIELD_WHEN,{|oModel| valida(oModel,1)})
	oStruSZ2:SetProperty("Z2_NCFISIC",MODEL_FIELD_WHEN,{|oModel| valida(oModel,1)})
	oStruSZ2:SetProperty("Z2_LFISCA" ,MODEL_FIELD_WHEN,{|oModel| valida(oModel,2)})
	oStruSZ2:SetProperty("Z2_CFISCAL",MODEL_FIELD_WHEN,{|oModel| valida(oModel,2)})
	oStruSZ2:SetProperty("Z2_NCFISCA",MODEL_FIELD_WHEN,{|oModel| valida(oModel,2)})

	if(oModel:GetOperation() == 4)
		oStruSZ2:SetProperty('*',MODEL_FIELD_WHEN,{|oModel| nedita(oModel)})
	endif

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

	If((oModel:GetValue("Z2_TIPOCON") == "1" .and. nValor == 1) .or. (oModel:GetValue("Z2_TIPOCON") == "2" .and. nValor == 2))
		lRet := .T.
	endif

Return lRet

// Verificando se a quantidade original e maior ou igual a quantidade de saida
// se nao ele da um HELP falando que o saldo nao pode ser maior que a quantidade original
Function u_attsaldo(oModel)

	Local nValor := 0
	Local oMdlSZ3 := oModel:GetModel('SZ3DETAIL')

	nValor := oMdlSZ3:GetValue("Z3_QORIGIN") - oMdlSZ3:GetValue("Z3_QSAIDA")

	if(nValor < 0)
		Help("",1,,ProcName(),"A quantidade de saldo não pode ser menor do que Zero",1,0)
		nValor := 0
	Endif

Return nValor

Static Function modalValida(oModel)

	Local oMdlSZ2 := oModel:GetModel('SZ2MASTER')
	Local oMdlSZ3 := oModel:GetModel('SZ3DETAIL')
	Local lRet := .T.
	Private cAlias := GetNextAlias()

	// Chamando a tabela de produtos relacionadas ao contrato
	DbSelectArea("SZ3")

	// Chamando o segundo Indice da tabela
	DbSetOrder(3)

	if oMdlSZ3:SeekLine({{"Z3_FILIAL",xFilial("SZ3")},{"Z3_QSAIDA",oMdlSZ3:GetValue("Z3_QSAIDA")},{"Z3_CODCON",oMdlSZ3:GetValue("Z3_CODCON")}})

		// Verificar se todos os produtos estao com o saldo zerado
		validacao(oMdlSZ3,cAlias)

		if(oMdlSZ3:GetValue("Z3_QSAIDA") <> oMdlSZ3:GetValue("Z3_QORIGIN"))
			lRet := .T.
			oMdlSZ2:SetValue("Z2_TIPOCON", "2")
			oMdlSZ2:SetValue("Z2_STATUS", "2")
		elseif ((cAlias)->(!Eof())) ==  .F.
			lRet := .T.
			oMdlSZ2:SetValue("Z2_TIPOCON", "3")
			oMdlSZ2:SetValue("Z2_STATUS", "3")
		else
			lRet := .T.
			oMdlSZ2:SetValue("Z2_TIPOCON", "1")
			oMdlSZ2:SetValue("Z2_STATUS", "1")
		Endif
		(cAlias)->(dbCloseArea())
	endif

Return lRet

Static function nedita(oModel)

	Local oMdlSZ2 := oModel:GetModel('SZ2MASTER')
	Local lRet := .T.
	Local nOperation := oMdlSZ2:GetOperation() as Numeric

	if(nOperation == 4)
		lRet := .F.
	Endif

Return lRet


Static function validacao(oMdlSZ3,cAlias)

	BeginSql Alias cAlias
		SELECT
			Z3_CODPROD,
			Z3_NOME,
			Z3_QORIGIN,
			Z3_QSAIDA,
			Z3_QSALDO,
			Z3_CODCON
		FROM
			%Table:SZ3% SZ2
		WHERE
			Z3_QSAIDA = Z3_QORIGIN
			AND Z3_CODCON = %exp:oMdlSZ3:GetValue("Z3_CODCON")%
	EndSql

Return cAlias

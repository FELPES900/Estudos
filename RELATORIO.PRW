#INCLUDE 'TOTVS.CH'
#INCLUDE "TopConn.ch"
#INCLUDE "RPTDef.ch"
#INCLUDE "FWPrintSetup.ch"

//Alinhamentos
#DEFINE PAD_LEFT 0
#DEFINE PAD_RIGHT 1
#DEFINE PAD_CENTER 2

//Cores
#DEFINE COR_CINZA RGB(180, 180, 180)
#DEFINE COR_PRETO RGB(000, 000, 000)

//Colunas
#DEFINE COL_ITEM 0015
#DEFINE COL_PRODUTO 0025
#DEFINE COL_DESCRICAO 0035
#DEFINE COL_UNIDADE 0045
#DEFINE COL_QUANTIDADE 0055
#DEFINE COL_PRECO 0065
#DEFINE COL_TOTAL 0075
#DEFINE COL_LOCAL 0085
#DEFINE COL_NUMSC 0095
#DEFINE COL_ITEMSC 0105
#DEFINE COL_FORNECE 0110
#DEFINE COL_CONTATO 0115
#DEFINE COL_LOJA 0120
#DEFINE COL_NUM 0125
#DEFINE COL_QUJE 0130
#DEFINE COL_NUMCOT 0135
#DEFINE COL_QTDSQL 0140
#DEFINE COL_EMISSAO 0145
#DEFINE COL_DATPRF 0150

//-------------------------------------------------------------------
/*/                                                                     {Protheus.doc} Relatorio Pedido de compras
Modelo de relatorio feito em FWMsPrinter
@author Kayke Laurindo
@since 15/09/2023
@version 22.10
/*/
//-------------------------------------------------------------------
User function PergRelatorio()

	Local aArea            := GetArea()
	Local cperg            := "COMA01"
	If MsgYesNo("Deseja gerar o relatorio do pedido de compras?","Atenção")
	FWMsgRun(, {|oSay|PERGUNTE(cperg,.T.), montaRelatorio() }, "Gerando", "Gerando o relatorio")
	endif
	
	montaRelatorio()

	RestArea(aArea)
return

/*
Gera o Relatório
*/

Static Function montaRelatorio()
	//Variaveis Principais
	Local cCaminho         := ""
	Local cArquivo         := ""
	Local nAtual           := 0
	Local nTotal           := 0

	
	Local nPrimeiro  := 1
	Local aDescProd  := {}
	Local cSolic     := SC1->C1_SOLICIT
	Local nCont      := 0
	Local CFornece01 := ""
	Local cNReduz01  := ""
	Local cFone01    := ""
	Local cContato01 := ""
	Local CFornece02 := ""
	Local cNReduz02  := ""
	Local cFone02    := ""
	Local cContato02 := ""
	Local CFornece03 := ""
	Local cNReduz03  := ""
	Local cFone03    := ""
	Local cContato03 := ""
	Local CFornece04 := ""
	Local cNReduz04  := ""
	Local cFone04    := ""
	Local cContato04 := ""
	Local _cDescVeic := ""
	Local _cAnoFab   := ""
	Local nNao       := 0

	// Local j := 0

	// Variáveis da query

	//Variaveis de linhas e colunas
	Local nLinhaPont       := 212
	Local nLinhaTrac       := 216
	Private nLinhaAtual    := 000
	Private nTamanhoLinha  := 010
	Private nLinFin        := 820
	Private nColunaInicial := 010
	Private nColunaFinal   := 550
	Private nColMeio       := (nColunaFinal-nColunaInicial)/2
	Private nLinhaPrec     := 220
 

	//Variaveis de Impressão
	Private oPrintRelatorio

	//Variaveis de Auxilio
	Private dDataAtual     := Date()
	Private cHoraAtual     := Time()
	Private nPagAtual      := 1
	Private cNomeUsuario   := UsrRetName()
	Private cDataNecess    := ""
	SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
	SetPrvt("NOMEPROG,ALINHA,CPERG,WNREL,ITAM,LI")
	SetPrvt("NPRIMEIRO,ADESCPROD,CSOLIC,NCONT,CFORNECE01,CNREDUZ01")
	SetPrvt("CFONE01,CCONTATO01,CFORNECE02,CNREDUZ02,CFONE02,CCONTATO02")
	SetPrvt("CFORNECE03,CNREDUZ03,CFONE03,CCONTATO03,CFORNECE04,CNREDUZ04")
	SetPrvt("CFONE04,CCONTATO04,NNAO,NNUMSOLIC,NGERAL01,NGERAL02")
	SetPrvt("NGERAL03,NGERAL04,CCOND01,CCOND02,CCOND03,CCOND04")
	SetPrvt("NPRAZO01,NPRAZO02,NPRAZO03,NPRAZO04,CITEM01,CITEM02")
	SetPrvt("CITEM03,CITEM04,NMENOR01,NMENOR02,NMENOR03,NMENOR04")
	SetPrvt("NATEND01,NATEND02,NATEND03,NATEND04,NQTDE01,NQTDE02")
	SetPrvt("NQTDE03,NQTDE04,NTOTMENOR,NDESC01,NDESC02,NDESC03")
	SetPrvt("NDESC04,COBS,CDATASOL,CDATANEC,NPRECO01,NPRECO02,NPRECO03")
	SetPrvt("NPRECO04,NTOTAL01,NTOTAL02,NTOTAL03,NTOTAL04,CPRODUTO")
	SetPrvt("CITEM,J,_cDescVeic")
	//Fontes do texto
	Private cNomeFonte     := "Arial"
	Private oFontLinha     := TFont()      :New(cNomeFonte, 9      , -10, .T., .F., 5, .T.             , 5 , .T., .F.)
	Private oFontColuna    := TFont()      :New(cNomeFonte, 9      , -10, .T., .F., 5, .T.             , 5 , .T., .F.)
	Private oFontRodape    := TFont()      :New(cNomeFonte, 9      , -08, .T., .F., 5, .T.             , 5 , .T., .F.)
	Private oFontTitulo    := TFont()      :New(cNomeFonte, 9      , -13, .T., .F., 5, .T.             , 5 , .T., .F.)
	Private oFontPrec    := TFont()      :New(cNomeFonte, 9      , -20, .T., .F., 5, .T.             , 5 , .T., .F.)

	//Define o diretório do arquivo
	cCaminho               := GetTempPath()
	cArquivo               := "PergRelatorio_" + dToS(dDataAtual) + "_" + StrTran(cHoraAtual, ':' , '-' )

	//Cria o objeto do FWMSPrinter
	oPrintRelatorio        := FWMsPrinter():New(cArquivo  , IMP_PDF, .F., "" , .T.,  , @oPrintRelatorio, "",    ,    , , .T.)

	//Setando os atributos necessários do relatorio
	oPrintRelatorio:SetResolution(72)
	oPrintRelatorio:SetPortrait()
	oPrintRelatorio:SetPaperSize(DMPAPER_A4)
	oPrintRelatorio:SetMargin(60,60,60,60)

	//Function que imprime o cabeçalho
	ImprimeCabec()
	DbSelectArea( 'SC1' )

	// Estrutura do relatório.
	oPrintRelatorio:Box( 060, 010, 800, 550, "-1") // Relatório completo
	oPrintRelatorio:Box( 060, 250, 100, 550, "-1") //
	oPrintRelatorio:Box( 120, 010, 100, 200, "-1") // Solicitante
	oPrintRelatorio:Box( 120, 200, 100, 350, "-1") // Num SC
	oPrintRelatorio:Box( 120, 350, 100, 550, "-1") // Data e Necessecidade
    oPrintRelatorio:line( 140, 010, 140, 550,, "-1") // 1
    oPrintRelatorio:line( 160, 280, 160, 550,, "-1") // 2
    oPrintRelatorio:line( 160, 280, 140, 280,, "-1")
    oPrintRelatorio:line( 200, 280, 200, 550,, "-1") // 3
    oPrintRelatorio:line( 160, 280, 740, 280,, "-1")
    oPrintRelatorio:line( 200, 010, 200, 550,, "-1") // 4
    oPrintRelatorio:line( 220, 010, 220, 550,, "-1") // 5
    oPrintRelatorio:line( 200, 347.5, 740, 347.5,, "-1")
    oPrintRelatorio:line( 200, 415, 740, 415,, "-1")
    oPrintRelatorio:line( 200, 482.5, 740, 482.5,, "-1")
    oPrintRelatorio:line( 200, 040, 590, 040,, "-1") // IT
    oPrintRelatorio:line( 200, 070, 590, 070,, "-1") // UND
    oPrintRelatorio:line( 200, 210, 590, 210,, "-1") // DESC IITEM
    oPrintRelatorio:line( 590, 010, 590, 550,, "-1")
    oPrintRelatorio:line( 620, 140, 620, 550,, "-1")
    oPrintRelatorio:line( 650, 140, 650, 550,, "-1")
    oPrintRelatorio:line( 680, 140, 680, 550,, "-1")
    oPrintRelatorio:line( 710, 140, 710, 550,, "-1")
    oPrintRelatorio:line( 590, 140, 740, 140,, "-1") // ARRUMAR
    oPrintRelatorio:line( 740, 010, 740, 550,, "-1")
    oPrintRelatorio:line( 770, 010, 770, 550,, "-1")
    oPrintRelatorio:line( 770, 183.3, 800, 183.3,, "-1")
    oPrintRelatorio:line( 770, 366.6, 800, 366.6,, "-1")
    oPrintRelatorio:line( 770, 549.9, 800, 549.9,, "-1")

	 // Linha tracejada.
	
	oPrintRelatorio:line( 588, 303.75, 590, 303.75,, "-1")
	oPrintRelatorio:line( 588, 371.25, 590, 371.25,, "-1")
	oPrintRelatorio:line( 588, 506.25, 590, 506.25,, "-1")
	oPrintRelatorio:line( 588, 438.75, 590, 438.75,, "-1") // Arrumar
	
	while !(nLinhaTrac == 584) .and. !(nLinhaPont == 580)
	nLinhaTrac             := nLinhaTrac + 8
	nLinhaPont             := nLinhaPont + 8
	oPrintRelatorio:line( nLinhaPont, 303.75, nLinhaTrac, 303.75,, "-1")
	oPrintRelatorio:line( nLinhaPont, 371.25, nLinhaTrac, 371.25,, "-1")
	oPrintRelatorio:line( nLinhaPont, 438.75, nLinhaTrac, 438.75,, "-1")
	oPrintRelatorio:line( nLinhaPont, 506.25, nLinhaTrac, 506.25,, "-1")

	 loop
	Enddo
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arquivo de solicitacao de compras.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC1")
dbSetOrder(1)
If dbSeek(xFilial()+MV_PAR01)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajusta numero de elementos da regua de relatorios            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	itam := 0
	WHILE (SC1->C1_NUM >= MV_PAR01 .And. SC1->C1_NUM <= MV_PAR02 .And. SC1->C1_ITEM <= MV_PAR04) .And. !EOF()
		itam := itam + 1
		dbSkip()
	End
	
	SC1->(dbSetOrder(1))
	SC1->(dbSeek(xFilial()+MV_PAR01))
	
Else
	MsgBox("Solicitacao de compra nao encontrada.","Alerta","Alert")
	Return
EndIf

/// INICIALIZA REGUA
ProcRegua(itam)

nPrimeiro  := 1
aDescProd  := {}
cSolic     := SC1->C1_SOLICIT
nCont      := 0
CFornece01 := ""
cNReduz01  := ""
cFone01    := ""
cContato01 := ""
CFornece02 := ""
cNReduz02  := ""
cFone02    := ""
cContato02 := ""
CFornece03 := ""
cNReduz03  := ""
cFone03    := ""
cContato03 := ""
CFornece04 := ""
cNReduz04  := ""
cFone04    := ""
cContato04 := ""
_cDescVeic := ""
_cAnoFab   := ""
nNao       := 0
cDataNec   :=""
cDataSol   :=""

WHILE (SC1->C1_NUM >= MV_PAR01 .And. SC1->C1_NUM <= MV_PAR02 .And. SC1->C1_ITEM <= MV_PAR04) .And. !EOF()
	
	nNumSolic := SC1->C1_NUM
	
	// Busca os 04 fornecedores escolhidos para o orcamento
	/*
	dbselectArea("SC8")
	dbsetorder(6)
	If dbseek(xFilial()+nNumSolic)
	*/
	
	QryFORSC8()	
	WHILE !EOF()
		
		IF ZC8teste->C8_NUMSC <> nNumSolic .or. !Empty(cFornece04)
			exit
		endif
	
		dbselectArea("SA2")
		dbSetOrder(1)
		dbseek(xFilial('ZC8teste')+ZC8teste->C8_FORNECE+ZC8teste->C8_LOJA)
		if Empty(cFornece01)
			cFornece01 := ZC8teste->C8_FORNECE
			cNReduz01  := A2_NREDUZ
			cFone01    := A2_TEL
			cContato01 := A2_CONTATO
		endif
		if Empty(cFornece02) .and. cFornece01 <> ZC8teste->C8_FORNECE
			cFornece02 := ZC8teste->C8_FORNECE
			cNReduz02  := A2_NREDUZ
			cFone02    := A2_TEL
			cContato02 := IIF(EMPTY(ZC8teste->C8_CONTATO),SA2->A2_CONTATO, ZC8teste->C8_CONTATO)
		endif
		if Empty(cFornece03) .and. cFornece01 <>  ZC8teste->C8_FORNECE .and. cFornece02 <> ZC8teste->C8_FORNECE
			cFornece03 := ZC8teste->C8_FORNECE
			cNReduz03  := A2_NREDUZ
			cFone03    := A2_TEL
			cContato03 := IIF(EMPTY(ZC8teste->C8_CONTATO),SA2->A2_CONTATO, ZC8teste->C8_CONTATO)
		endif
		if Empty(cFornece04) .and. cFornece01 <>  ZC8teste->C8_FORNECE .and. cFornece02 <> ZC8teste->C8_FORNECE .and. cFornece03 <> ZC8->C8_FORNECE
			cFornece04 := ZC8teste->C8_FORNECE
			cNReduz04  := A2_NREDUZ
			cFone04    := A2_TEL
			cContato04 := IIF(EMPTY(ZC8teste->C8_CONTATO),SA2->A2_CONTATO, ZC8teste->C8_CONTATO)
		endif
		dbSelectArea("ZC8teste")
		dbskip()
	Enddo
	IF SELECT("ZC8teste") > 0
        ZC8teste->( DbCloseArea())	
	ENDIF
	
	//dbSelectArea("SC1")
	nGeral01 := 0
	nGeral02 := 0
	nGeral03 := 0
	nGeral04 := 0
	cCond01  := ""
	cCond02  := ""
	cCond03  := ""
	cCond04  := ""
	nPrazo01 := 0
	nPrazo02 := 0
	nPrazo03 := 0
	nPrazo04 := 0
	cItem01  := ""
	cItem02  := ""
	cItem03  := ""
	cItem04  := ""
	nMenor01 := 0
	nMenor02 := 0
	nMenor03 := 0
	nMenor04 := 0
	nAtend01 := 0
	nAtend02 := 0
	nAtend03 := 0
	nAtend04 := 0
	nQtde01  := 0
	nQtde02  := 0
	nQtde03  := 0
	nQtde04  := 0
	nTotmenor:= 0
	nDesc01 := 0
	nDesc02 := 0
	nDesc03 := 0
	nDesc04 := 0
	cObs    := ""
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no arquivo de centro de custo.                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SI3")
		dbSetOrder(1)
		dbSeek(xFilial()+SC1->C1_CC)

		dbselectArea("SC8")
		dbsetorder(6)
		dbseek(xFilial()+nNumSolic)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no arquivo de veiculos.                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CTD")
		dbSetOrder(1)
		If dbSeek(xFilial()+SC1->C1_ITEMCTA,.F.)//Prefixo dos Veículos - Alterado por Rafael Fedatto 
		_cDescVeic:= CTD->CTD_DESC01//Descrição do Prefixo - Alterado por Rafael Fedatto
		EndIf
	
	dbSelectArea("SC1")
	WHILE (SC1->C1_NUM == nNumSolic .AND. SC1->C1_ITEM <= MV_PAR04) .AND. !EOF()
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial()+SC1->C1_PRODUTO)

		nAtual++
		IncProc("Imprimindo Item " + SC8->C8_NUMSC + " ( " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + ")...")

		//Se a linha atual ocupa mais espaço que será utilizado forem maior que a linha final
		If nLinhaAtual + nTamanhoLinha > nLinFin
			ImprimeRodape()
			ImprimeCabec()
		endif

	
	  // CABEÇALHO 
	    oPrintRelatorio:SayAlign(065,025,SM0->M0_NOMECOM,oFontLinha,220,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(075,025,SM0->M0_ENDCOB,oFontLinha,220,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(085,025,"Tel.: (65)3353-4001 Fax: (65)3623-5000",oFontLinha,220,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(085,345,"COTAÇÃO DE PREÇOS",oFontLinha,220,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(075,335,"SOLICITAÇÃO DE COMPRAS",oFontLinha,220,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(105,025,"Solicitante: "+SC1->C1_SOLICIT,oFontLinha,220,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(105,210,"Num. SC: "+SC1->C1_NUM+" / "+SC8->C8_NUMSC,oFontLinha,220,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(105,360,"Data: "+cValToChar(SC1->C1_EMISSAO)+" => Necessidade: "+cValToChar(SC1->C1_DATPRF),oFontLinha,220,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(125,025,"Aplicacao:"+SC1->C1_ITEMCTA+" - "+_cDescVeic+" - " + " - C.Custo:"+ SI3->I3_CUSTO +" - "+SI3->I3_DESC,oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(145,350,"F O R N E C E D O R E S",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(205,020,"IT",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(205,045,"UND",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(205,080,"DESCRICAO DO ITEM",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(225,080,"BUJAO 823011610",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(205,218,"FABRICANTE",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(665,025," Itens nao Cotados > 8 ",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(745,025,"OBSERVACOES: ",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(773,015,"Coordenador/Gerencia: ",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(773,190,"Autorizante: ",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(773,370,"Aprovacao Diretoria: ",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(600,145,"TOTAL: ",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(630,145,"DESCONTO EMBUTIDO NO PRECO:",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(660,145,"MENOR PRECO: ",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(690,145,"COND. PAGAMENTO: ",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	    oPrintRelatorio:SayAlign(720,145,"PRAZO ENTREGA(DIAS): ",oFontLinha,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
		nLinhaAtual            := nTamanhoLinha

		QrySC8()	
			WHILE !EOF()
				IF ZC8->C8_NUMSC <> nNumSolic .or. nPreco04 > 0
					exit
				endif
				if ZC8->C8_PRODUTO <> cProduto .or. ZC8->C8_ITEMSC <> cItem
					dbskip()
					loop
				endif
				dbselectArea("SE4")
				dbSetOrder(1)
				dbseek(xFilial()+ZC8->C8_COND)
				if cFornece01 == ZC8->C8_FORNECE
					nPreco01 := (((ZC8->C8_PRECO * ZC8->C8_ALIIPI) / 100) + ZC8->C8_PRECO)
					nTotal01 := ((nPreco01 * ZC8->C8_QUANT) - ZC8->C8_VLDESC)
					nGeral01 := (nGeral01 + nTotal01)
					nDesc01  := nDesc01 + ZC8->C8_VLDESC
					if ZC8->C8_PRECO > 0
						cCond01  := SE4->E4_DESCRI
						nPrazo01 := ZC8->C8_PRAZO
					endif
					if nTotal01      > 0
						nAtend01 := nAtend01 + 1
					endif
				endif
				if cFornece02 == ZC8->C8_FORNECE
					nPreco02 := (((ZC8->C8_PRECO * ZC8->C8_ALIIPI) / 100) + ZC8->C8_PRECO)
					nTotal02 := ((nPreco02 * ZC8->C8_QUANT) - ZC8->C8_VLDESC)
					nGeral02 := (nGeral02 + nTotal02)
					nDesc02  := nDesc02 + ZC8->C8_VLDESC
					if ZC8->C8_PRECO > 0
						cCond02  := SE4->E4_DESCRI
						nPrazo02 := ZC8->C8_PRAZO
					endif
					if nTotal02      > 0
						nAtend02 := nAtend02 + 1
					endif
				endif
				if cFornece03 == ZC8->C8_FORNECE
					nPreco03 := (((ZC8->C8_PRECO * ZC8->C8_ALIIPI) / 100) + ZC8->C8_PRECO)
					nTotal03 := ((nPreco03 * ZC8->C8_QUANT) - ZC8->C8_VLDESC)
					nGeral03 := (nGeral03 + nTotal03)
					nDesc03  := nDesc03 + ZC8->C8_VLDESC
					if ZC8->C8_PRECO > 0
						cCond03  := SE4->E4_DESCRI
						nPrazo03 := ZC8->C8_PRAZO
					endif
					if nTotal03 > 0
						nAtend03 := nAtend03 + 1
					endif
				endif
				if cFornece04 == ZC8->C8_FORNECE
					nPreco04 := (((ZC8->C8_PRECO * ZC8->C8_ALIIPI) / 100) + ZC8->C8_PRECO)
					nTotal04 := ((nPreco04 * ZC8->C8_QUANT) - ZC8->C8_VLDESC)
					nGeral04 := (nGeral04 + nTotal04)
					nDesc04  := nDesc04 + ZC8->C8_VLDESC
					if ZC8->C8_PRECO > 0
						cCond04  := SE4->E4_DESCRI
						nPrazo04 := ZC8->C8_PRAZO
					endif
					if nTotal04 > 0
						nAtend04 := nAtend04 + 1
					endif
				endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica Menor Preco da Cotacao     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				if Empty(cFornece01) .or. nTotal01 < 0.02
					nTotal01 := 999999999
				endif
				if Empty(cFornece02) .or. nTotal02 < 0.02
					nTotal02 := 999999999
				endif
				if Empty(cFornece03) .or. nTotal03 < 0.02
					nTotal03 := 999999999
				endif
				if Empty(cFornece04) .or. nTotal04 < 0.02
					nTotal04 := 999999999
				endif
				if  nTotal01 < nTotal02 .and. nTotal01 < nTotal03 .and. nTotal01 < nTotal04
					cItem01  := "*"
					cItem02  := " "
					cItem03  := " "
					cItem04  := " "
				elseif  nTotal02 < nTotal01 .and. nTotal02 < nTotal03 .and. nTotal02 < nTotal04
					cItem02  := "*"
					cItem01  := " "
					cItem03  := " "
					cItem04  := " "
				elseif  nTotal03 < nTotal01 .and. nTotal03 < nTotal02 .and. nTotal03 < nTotal04
					cItem03  := "*"
					cItem01  := " "
					cItem02  := " "
					cItem04  := " "
				elseif  nTotal04 < nTotal01 .and. nTotal04 < nTotal02 .and. nTotal04 < nTotal03
					cItem01  := " "
					cItem02  := " "
					cItem03  := " "
					cItem04  := "*"
				endif
				if Empty(cFornece01) .or. nTotal01 == 999999999
					nTotal01 := 0
				endif
				if Empty(cFornece01) .or. nTotal02 == 999999999
					nTotal02 := 0
				endif
				if Empty(cFornece03) .or. nTotal03 == 999999999
					nTotal03 := 0
				endif
				if Empty(cFornece04) .or. nTotal04 == 999999999
					nTotal04 := 0
				endif
				dbSelectArea("ZC8")
				dbskip()
			End      

		//EndIf
				if nPreco01 > 0
		nLinhaPrec := nLinhaPrec + 10
		oPrintRelatorio:SayAlign(nLinhaPrec,285,nPreco01,oFontPrec,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
				endif
		
				if nTotal01 > 0	 	
		nLinhaPrec := nLinhaPrec + 10
		oPrintRelatorio:SayAlign(nLinhaPrec,308.75,nTotal01,oFontPrec,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
		oPrintRelatorio:SayAlign(nLinhaPrec,311.75,cItem01,oFontPrec,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
				endif
		
				if nPreco02 > 0
		nLinhaPrec := nLinhaPrec + 10
		oPrintRelatorio:SayAlign(nLinhaPrec,376.25,nPreco02,oFontPrec,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
				endif
				if nTotal02 > 0
		nLinhaPrec := nLinhaPrec + 10
		oPrintRelatorio:SayAlign(nLinhaPrec,386.25,nTotal02,oFontPrec,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
		oPrintRelatorio:SayAlign(nLinhaPrec,389.25,cItem02,oFontPrec,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
				endif
		
		if nPreco03 > 0
		nLinhaPrec := nLinhaPrec + 10
		oPrintRelatorio:SayAlign(nLinhaPrec,443.75,nPreco03,oFontPrec,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
		endif
		
		if nTotal03 > 0
		nLinhaPrec := nLinhaPrec + 10
		oPrintRelatorio:SayAlign(nLinhaPrec,453.75,nTotal03,oFontPrec,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
		oPrintRelatorio:SayAlign(nLinhaPrec,456.75,cItem03,oFontPrec,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
				endif

				if nPreco04 > 0
				nLinhaPrec := nLinhaPrec + 10
		oPrintRelatorio:SayAlign(nLinhaPrec, 511.25,nTotal04,oFontPrec,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
		endif
		
		if nTotal04 > 0
		nLinhaPrec := nLinhaPrec + 10
		oPrintRelatorio:SayAlign(nLinhaPrec, 521.25,nTotal04,oFontPrec,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
		oPrintRelatorio:SayAlign(nLinhaPrec, 524.25,cItem04,oFontPrec,550,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
		endif
		
		if cItem01 == "*"
			nMenor01 := nMenor01 + nTotal01
			nQtde01  := nQtde01 + 1
		elseif cItem02 == "*"
			nMenor02 := nMenor02 + nTotal02
			nQtde02  := nQtde02 + 1
		elseif cItem03 == "*"
			nMenor03 := nMenor03 + nTotal03
			nQtde03  := nQtde03 + 1
		elseif cItem04 == "*"
			nMenor04 := nMenor04 + nTotal04
			nQtde04  := nQtde04 + 1
		endif
		if nPreco01 == 0 .and. nPreco02 == 0 .and. nPreco03 == 0 .and. nPreco04 == 0
			nNao := nNao + 1
		endif
		nTotmenor := nMenor01 + nMenor02 + nMenor03 + nMenor04
		dbSelectArea("SC1")
		dbSkip()
		ZC8->(dbCloseArea())
	End

//Se ainda tiver linha sobrando na pagina, ira imprimir o rodapé final
		If nLinhaAtual <= nLinFin
		ImprimeRodape()
		endif

		//Exibe o relatório
		oPrintRelatorio:Preview()
Enddo

return

/*
Imprime o cabeçalho
*/

Static function ImprimeCabec()
	//Variaveis de linha e texto
	Local cTextoCabec      := ""
	Local nLinhaCabec      := 030

	//Inicia a Pagina do relatorio
	oPrintRelatorio:StartPage()

	//Cabeçalho do relatorio
	cTextoCabec            := "Solicitação de compras"
	oPrintRelatorio:SayAlign(nLinhaCabec,nColMeio - 120, cTextoCabec,oFontTitulo,240,20,COR_CINZA,PAD_CENTER,0)

	//Linha separatória
	nLinhaCabec            := (nTamanhoLinha * 2)
	oPrintRelatorio:Line(nLinhaCabec,nColunaInicial,nLinhaCabec,nColunaFinal,COR_CINZA)

	//Cabeçalho das colunas
	nLinhaCabec            := nTamanhoLinha
	oPrintRelatorio:SayAlign(nLinhaCabec,COL_ITEM,"Item",oFontColuna,0080,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	oPrintRelatorio:SayAlign(nLinhaCabec,COL_PRODUTO,"Produto",oFontColuna,0200,nTamanhoLinha,COR_PRETO,PAD_LEFT,0)
	nLinhaCabec            := nTamanhoLinha

	//Atualizando a linha inicial do relatório
	nLinhaAtual            := nLinhaCabec + 3

return

/*
Imprime o rodapé
*/

Static function ImprimeRodape()
	Local nLinhaRodape     := nLinFin + nTamanhoLinha
	Local cTextoEsquerdo   := ''
	Local cTextoDireito    := ''

	//Linha separatória
	oPrintRelatorio:Line(nLinhaRodape,nColunaInicial,nLinhaRodape,nColunaFinal,COR_CINZA)
	nLinhaRodape           := 3

	//Dados da esquerda e da direita
	cTextoEsquerdo         := dToc(dDataAtual) + " " + cHoraAtual + " " + FunName() + " " + cNomeUsuario
	cTextoDireito          := "Página " + cValToChar(nPagAtual)

	//Imprimindo texto
	oPrintRelatorio:SayAlign(nLinhaRodape,nColunaInicial,cTextoEsquerdo,oFontRodape,200,05,COR_CINZA,PAD_LEFT,0)
	oPrintRelatorio:SayAlign(nLinhaRodape,nColunaFinal - 40,cTextoDireito,oFontRodape,040,05,COR_CINZA,PAD_RIGHT,0)

	oPrintRelatorio:EndPage()
	nPagAtual++
return

Static Function QrySC8()

Local cSELECT:= ""
Local cFROM  := ""  
Local cWHERE := ""
Local cORDER := ""

cSELECT:= 	" * "
cFROM  := 	"SC8"+cEmpAnt+"0 "
cWHERE := 	"D_E_L_E_T_ <> '*' AND " + ;
		    "C8_FILIAL = '" + xFilial("SC8") +"' AND " + ; 
			"C8_NUMPED = '' AND " +;
		    "C8_NUMSC = '" + SC1->C1_NUM +"' AND " + ;
		    "C8_PRODUTO = '" + SC1->C1_PRODUTO +"' AND " + ;
		    "C8_ITEMSC = '" + SC1->C1_ITEM +"' " 
cORDER :=   "C8_FILIAL, C8_NUMSC, C8_PRODUTO, C8_ITEMSC, C8_FORNECE "

cQuery :=   "SELECT "+cSELECT+" FROM "+cFROM+" WHERE "+cWHERE+" ORDER BY "+cORDER

TCQUERY cQuery NEW ALIAS "ZC8"
//////////////////////////  FIM  DA  QUERY  /////////////////////////////

Return

Static Function QryFORSC8()

Local cSELECT:= ""
Local cFROM  := ""  
Local cWHERE := "" 	
Local cORDER := ""

cSELECT:= 	"DISTINCT C8_NUMSC, C8_FORNECE, C8_LOJA, C8_CONTATO "
cFROM  := 	"SC8"+cEmpAnt+"0 "
cWHERE := 	"D_E_L_E_T_ <> '*' AND " + ;     
		    "C8_FILIAL = '" + xFilial("SC8") +"' AND " +; 
			"C8_NUMPED = '' AND " +;
		    "C8_NUMSC = '" + SC1->C1_NUM +"' " 
cORDER :=   "C8_NUMSC, C8_FORNECE, C8_LOJA, C8_CONTATO "

cQuery :=   "SELECT "+cSELECT+" FROM "+cFROM+" WHERE "+cWHERE+" GROUP BY "+cORDER

TCQUERY cQuery NEW ALIAS "ZC8teste"
//////////////////////////  FIM  DA  QUERY  /////////////////////////////

Return


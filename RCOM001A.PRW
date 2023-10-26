#include "rwmake.ch"
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RCOM001A  ³ Autor ³ Alessandro Gomes      ³ Data ³ 11.03.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Emissao da solicitacao de compra GRUPO GUIA.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGACOM (Compras)                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RCOM001A()

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

DbSelectArea("SC1")
cString := "SC1"
cDesc1  := OemToAnsi("Este programa tem como objetivo, imprimir a solicitacao ")
cDesc2  := OemToAnsi("de compra conforme parametros.                          ")
cDesc3  := ""
cDesc4  := ""
tamanho := "P"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",2 }
nomeprog:= "RCOM001A"
aLinha  := { }
cperg   := "COMA01"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                    P A R A M E T R O S                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³      MV_PAR01 -  Numero Solicitacao de  ?                    ³
//³      MV_PAR02 -  Numero Solicitacao ate ?                    ³
//³      MV_PAR03 -  Itens Solicitacao de   ?                    ³
//³      MV_PAR04 -  Itens Solicitacao ate  ?                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PERGUNTE(cperg,.F.)

wnrel   := "RCOM001A"   //Nome Default do relatorio em Disco
SetPrint(cString,wnrel,cperg,cDesc1,cDesc2,cDesc3,cDesc4,.F.,"",.F.,tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|| RptDetail() })

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RptDetail ³ Autor ³ Alessandro Gomes      ³ Data ³ 15.09.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RptDetail()

Local j := 0
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
SetRegua(itam)

li         := 0
nPrimeiro  := 1
aDescProd  := {}
cSolic     := SC1->C1_SOLICIT
nCont      := 0
CFornece01 := space(06)
cNReduz01  := space(20)
cFone01    := space(16)
cContato01 := space(15)
CFornece02 := space(06)
cNReduz02  := space(20)
cFone02    := space(16)
cContato02 := space(15)
CFornece03 := space(06)
cNReduz03  := space(20)
cFone03    := space(16)
cContato03 := space(15)
CFornece04 := space(06)
cNReduz04  := space(20)
cFone04    := space(16)
cContato04 := space(15)
_cDescVeic := space(20)
_cAnoFab   := space(04)
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
		
		IF ZC8->C8_NUMSC <> nNumSolic .or. cFornece04 <> space(06)
			exit
		endif
	
		dbselectArea("SA2")
		dbSetOrder(1)
		dbseek(xFilial()+ZC8->C8_FORNECE+ZC8->C8_LOJA)
		if cFornece01 == space(06)
			cFornece01 := ZC8->C8_FORNECE
			cNReduz01  := A2_NREDUZ
			cFone01    := A2_TEL
			cContato01 := A2_CONTATO
		endif
		if cFornece02 == space(06) .and. cFornece01 <>  ZC8->C8_FORNECE
			cFornece02 := ZC8->C8_FORNECE
			cNReduz02  := A2_NREDUZ
			cFone02    := A2_TEL
			cContato02 := IIF(EMPTY(ZC8->C8_CONTATO),SA2->A2_CONTATO, ZC8->C8_CONTATO)
		endif
		if cFornece03 == space(06) .and. cFornece01 <>  ZC8->C8_FORNECE .and. cFornece02 <> ZC8->C8_FORNECE
			cFornece03 := ZC8->C8_FORNECE
			cNReduz03  := A2_NREDUZ
			cFone03    := A2_TEL
			cContato03 := IIF(EMPTY(ZC8->C8_CONTATO),SA2->A2_CONTATO, ZC8->C8_CONTATO)
		endif
		if cFornece04 == space(06) .and. cFornece01 <>  ZC8->C8_FORNECE .and. cFornece02 <> ZC8->C8_FORNECE .and. cFornece03 <> ZC8->C8_FORNECE
			cFornece04 := ZC8->C8_FORNECE
			cNReduz04  := A2_NREDUZ
			cFone04    := A2_TEL
			cContato04 := IIF(EMPTY(ZC8->C8_CONTATO),SA2->A2_CONTATO, ZC8->C8_CONTATO)
		endif
		dbSelectArea("ZC8")
		dbskip()
	End
	ZC8->(dbCloseArea("ZC8"))
	
	//dbSelectArea("SC1")
	nGeral01 := 0
	nGeral02 := 0
	nGeral03 := 0
	nGeral04 := 0
	cCond01  := space(15)
	cCond02  := space(15)
	cCond03  := space(15)
	cCond04  := space(15)
	nPrazo01 := 0
	nPrazo02 := 0
	nPrazo03 := 0
	nPrazo04 := 0
	cItem01  := space(01)
	cItem02  := space(01)
	cItem03  := space(01)
	cItem04  := space(01)
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
	cObs    := space(50)
	
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
	@ 00,00 PSAY AVALIMP(132)
	WHILE (SC1->C1_NUM == nNumSolic .AND. SC1->C1_ITEM <= MV_PAR04) .AND. !EOF()
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial()+SC1->C1_PRODUTO)
		
		cDataSol  := SUBSTR(DTOS(SC1->C1_EMISSAO),7,2)+"/"+SUBSTR(DTOS(SC1->C1_EMISSAO),5,2)+"/"+;
		SUBSTR(DTOS(SC1->C1_EMISSAO),1,4)
		
		cDataNec  := SUBSTR(DTOS(SC1->C1_DATPRF),7,2)+"/"+SUBSTR(DTOS(SC1->C1_DATPRF),5,2)+"/"+;
		SUBSTR(DTOS(SC1->C1_DATPRF),1,4)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³             C A B E C A L H O  D O  R E L A T O R I O        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF li > 55 .OR. nprimeiro == 1
			nprimeiro := nprimeiro + 1
			//@  0,001 PSAY Chr(15)+" "                // Compressao de Impressao VV1_FILIAL+VV1_CHAINT
			@ 02,001 PSAY " _________________________________________________________________________________________________________________________________ "
			@ 03,001 PSAY "|"+SM0->M0_NOMECOM+					   "      |                                                                                  |"
			@ 04,001 PSAY "|"+SM0->M0_ENDCOB +           "                |                  S O L I C I T A C A O   D E   C O M P R A S                     |"
			@ 05,001 PSAY "|Tel.: (65)3353-4001    Fax: (65)3623-5000     |                      C O T A C A O   D E    P R E C O S                          |"
			@ 06,001 PSAY "|______________________________________________|__________________________________________________________________________________|"
			@ 07,001 PSAY "| Solicitante: "+SC1->C1_SOLICIT+SPACE(15)+"   | Num. SC: " +SC1->C1_NUM+" / "+SC8->C8_NUM+SPACE(10)+" | Data: "+cDataSol+" => Necessidade: "+cDataNec+" |"
			@ 08,001 PSAY "|______________________________________________|____________________________________|_____________________________________________|"
			@ 09,001 PSAY "|Aplicacao:"+SC1->C1_ITEMCTA+" - "+_cDescVeic+"    -    " + " - C.Custo:"+SI3->I3_CUSTO+" "+SI3->I3_DESC+SPACE(27)+"           |"
			@ 10,001 PSAY "|_________________________________________________________________________________________________________________________________|"
			@ 11,001 PSAY "                                                           _______________________________________________________________________|"
			@ 12,001 PSAY "                                                          |             F   O   R   N   E   C   E   D   O   R   E   S             |"
			@ 13,001 PSAY "                                                          |_______________________________________________________________________|"
			@ 14,001 PSAY "                                                          |"
			@ 14,060 PSAY Substr(cNReduz01,1,16)
			@ 14,077 PSAY "|"
			@ 14,078 PSAY Substr(cNReduz02,1,16)
			@ 14,095 PSAY "|"
			@ 14,096 PSAY Substr(cNReduz03,1,16)
			@ 14,113 PSAY "|"
			@ 14,114 PSAY Substr(cNReduz04,1,16)
			@ 14,131 PSAY "|"
			@ 15,001 PSAY " _________________________________________________________|"
			@ 15,060 PSAY cFornece01
			@ 15,077 PSAY "|"
			@ 15,078 PSAY cFornece02
			@ 15,095 PSAY "|"
			@ 15,096 PSAY cFornece03
			@ 15,113 PSAY "|"
			@ 15,114 PSAY cFornece04
			@ 15,131 PSAY "|"
			@ 16,001 PSAY "|  |   |        |                              |          |"
			@ 16,060 PSAY Substr(cFone01,1,16)
			@ 16,077 PSAY "|"
			@ 16,078 PSAY Substr(cFone02,1,16)
			@ 16,095 PSAY "|"
			@ 16,096 PSAY Substr(cFone03,1,16)
			@ 16,113 PSAY "|"
			@ 16,114 PSAY Substr(cFone04,1,16)
			@ 16,131 PSAY "|"
			@ 17,001 PSAY "|IT|UND|  Qtde  |Descricao do Item             |Fabricante|_________________|_________________|_________________|_________________|"
			@ 18,001 PSAY "|  |   |        |                              |          |"
			@ 18,060 PSAY Substr(cContato01,1,16)
			@ 18,077 PSAY "|"
			@ 18,078 PSAY Substr(cContato02,1,16)
			@ 18,095 PSAY "|"
			@ 18,096 PSAY Substr(cContato03,1,16)
			@ 18,113 PSAY "|"
			@ 18,114 PSAY Substr(cContato04,1,16)
			@ 18,131 PSAY "|"
			@ 19,001 PSAY "|__|___|________|______________________________|__________|_________________|_________________|_________________|_________________|"
			li:=19
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Icrementa a regua e imprime o corpo ³
		//³ do relatorio.                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncRegua()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Efetua a impressao do detalhe       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		li    := li + 1
		nCont := nCont + 1
		@ li,001 PSAY "|"
//		@ li,002 PSAY SC1->C1_ITEM - Alt. por Fabio Oliveira Pinto Devido atualizacao do Sistema o Item Passa a ter 4 digitos.
		@ li,002 PSAY IIF(Len(AllTrim(SC1->C1_ITEM)) = 4 .AND. SubStr(SC1->C1_ITEM,1,2) = '00', SubStr(SC1->C1_ITEM,3,2), IIF(Len(AllTrim(SC1->C1_ITEM)) = 4 .AND. SubStr(SC1->C1_ITEM,1,2) <> '00', '**',AllTrim(SC1->C1_ITEM)) )
		@ li,004 PSAY "|"
		@ li,005 PSAY SC1->C1_UM
		@ li,008 PSAY "|"
		@ li,009 PSAY SC1->C1_QUANT   PICTURE "@E 99999.99"
		@ li,017 PSAY "|"
		If SUBSTR(SB1->B1_DESC,1,30) = SUBSTR(SC1->C1_DESCRI,1,30)
			If Empty(alltrim(SUBSTR(SB1->B1_DESC,31,30)))
				@ li,018 PSAY SUBSTR(SB1->B1_DESC,1,30)
				@ li,048 PSAY "|"
			Else
				@ li,018 PSAY SUBSTR(SB1->B1_DESC,1,30)
				@ li,048 PSAY "|"
			EndIf
			If !Empty(Alltrim(SUBSTR(SB1->B1_DESC,31,30)))
				@ li,059 PSAY "|"
				@ li,067 PSAY "|"
				@ li,077 PSAY "|"
				@ li,085 PSAY "|"
				@ li,095 PSAY "|"
				@ li,103 PSAY "|"
				@ li,113 PSAY "|"
				@ li,121 PSAY "|"
				@ li,131 PSAY "|"
				li:= li+1
				@ li,001 PSAY "|"
				@ li,004 PSAY "|"
				@ li,008 PSAY "|"
				@ li,017 PSAY "|"
				@ li,018 PSAY Substr(SB1->B1_DESC,31,30)
				@ li,048 PSAY "|"
				@ li,049 PSAY Substr(SB1->B1_FABRIC,1,10)
			Else
				If !Empty(Substr(SB1->B1_FABRIC,1,10))
					//@ li,048 PSAY "|"
					@ li,049 PSAY Substr(SB1->B1_FABRIC,1,10)
				EndIf
			EndIf
		Else
			@ li,018 PSAY SUBSTR(SC1->C1_DESCRI,1,30)
			@ li,048 PSAY "|"
			If !Empty(Substr(SB1->B1_FABRIC,1,10))
				@ li,049 PSAY Substr(SB1->B1_FABRIC,1,10)
			EndIf
		EndIf
		@ li,59 PSAY "|"
		
		nPreco01 := 0
		nPreco02 := 0
		nPreco03 := 0
		nPreco04 := 0
		nTotal01 := 0
		nTotal02 := 0
		nTotal03 := 0
		nTotal04 := 0
		cItem01  := space(01)
		cItem02  := space(01)
		cItem03  := space(01)
		cItem04  := space(01)
		cProduto := SC1->C1_PRODUTO
		cItem    := SC1->C1_ITEM
		if substr(cObs,1,1) == space(01)
			cObs  := SC1->C1_OBS
		endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime valores dos produtos        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		/*
		dbselectArea("SC8")
		dbsetorder(6)
		If dbseek(xFilial("SC8")+nNumSolic+cProduto+cItem)
		*/
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
				if cFornece01 == space(06) .or. nTotal01 < 0.02
					nTotal01 := 999999999
				endif
				if cFornece02 == space(06) .or. nTotal02 < 0.02
					nTotal02 := 999999999
				endif
				if cFornece03 == space(06) .or. nTotal03 < 0.02
					nTotal03 := 999999999
				endif
				if cFornece04 == space(06) .or. nTotal04 < 0.02
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
				if cFornece01 == space(06) .or. nTotal01 == 999999999
					nTotal01 := 0
				endif
				if cFornece02 == space(06) .or. nTotal02 == 999999999
					nTotal02 := 0
				endif
				if cFornece03 == space(06) .or. nTotal03 == 999999999
					nTotal03 := 0
				endif
				if cFornece04 == space(06) .or. nTotal04 == 999999999
					nTotal04 := 0
				endif
				dbSelectArea("ZC8")
				dbskip()
			End      
			ZC8->(dbCloseArea("ZC8"))
		//EndIf
		if nPreco01 > 0
			@ li,060 PSAY nPreco01 PICTURE "@E 9999.99"
		endif
		@ li,067 PSAY "|"
		if nTotal01 > 0
			@ li,068 PSAY nTotal01 PICTURE "@E 99999.99"
			@ li,076 PSAY cItem01
		endif
		@ li,077 PSAY "|"
		if nPreco02 > 0
			@ li,078 PSAY nPreco02 PICTURE "@E 9999.99"
		endif
		@ li,085 PSAY "|"
		if nTotal02 > 0
			@ li,086 PSAY nTotal02 PICTURE "@E 99999.99"
			@ li,094 PSAY cItem02
		endif
		@ li,095 PSAY "|"
		if nPreco03 > 0
			@ li,096 PSAY nPreco03 PICTURE "@E 9999.99"
		endif
		@ li,103 PSAY "|"
		if nTotal03 > 0
			@ li,104 PSAY nTotal03 PICTURE "@E 99999.99"
			@ li,112 PSAY cItem03
		endif
		@ li,113 PSAY "|"
		if nPreco04 > 0
			@ li,114 PSAY nPreco04 PICTURE "@E 9999.99"
		endif
		@ li,121 PSAY "|"
		if nTotal04 > 0
			@ li,122 PSAY nTotal04 PICTURE "@E 99999.99"
			@ li,130 PSAY cItem04
		endif
		@ li,131 PSAY "|"
		
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
	End
	
	//Impressao das grades vazias
	IF nCont < 25
		For j:=nCont to 25
			li    := li + 1
			@ li,001 PSAY "|"
			@ li,004 PSAY "|"
			@ li,008 PSAY "|"
			@ li,017 PSAY "|"
			@ li,048 PSAY "|"
			@ li,059 PSAY "|"
			@ li,067 PSAY "|"
			@ li,077 PSAY "|"
			@ li,085 PSAY "|"
			@ li,095 PSAY "|"
			@ li,103 PSAY "|"
			@ li,113 PSAY "|"
			@ li,121 PSAY "|"
			@ li,131 PSAY "|"
		Next
	ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³             R O D A P E     D O    R E L A T O R I O         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	li := li+1
	@ li  ,001 PSAY  "|__|___|________|______________________________|__________|_______|_________|_______|_________|_______|_________|_______|_________|"
	
	li := li+1
	@ li,030 PSAY "|"
	@ li,032 PSAY "TOTAL: "+SPACE(12)
	@ li,059 PSAY "|"
	@ li,060 PSAY nAtend01  PICTURE "@E 999"
	@ li,063 PSAY "-"
	@ li,067 PSAY nGeral01 PICTURE "@E 999,999.99"
	@ li,077 PSAY "|"
	@ li,078 PSAY nAtend02  PICTURE "@E 999"
	@ li,081 PSAY "-"
	@ li,085 PSAY nGeral02 PICTURE "@E 999,999.99"
	@ li,095 PSAY "|"
	@ li,096 PSAY nAtend03 PICTURE "@E 999"
	@ li,099 PSAY "-"
	@ li,103 PSAY nGeral03 PICTURE "@E 999,999.99"
	@ li,113 PSAY "|"
	@ li,114 PSAY nAtend04 PICTURE "@E 999"
	@ li,117 PSAY "-"
	@ li,121 PSAY nGeral04 PICTURE "@E 999,999.99"
	@ li,131 PSAY "|"
	
	li := li + 1
	@ li,030 PSAY "|----------------------------|"
	@ li,060 PSAY "-----------------|-----------------|-----------------|-----------------|"
	
	li := li + 1
	@ li,030 PSAY  "|"
	@ li,032 PSAY  "DESCONTO EMBUTIDO NO PRECO:"
	@ li,059 PSAY "|"
	@ li,067 PSAY nDesc01 PICTURE "@E 999,999.99"
	@ li,077 PSAY "|"
	@ li,085 PSAY nDesc02 PICTURE "@E 999,999.99"
	@ li,095 PSAY "|"
	@ li,103 PSAY nDesc03 PICTURE "@E 999,999.99"
	@ li,113 PSAY "|"
	@ li,121 PSAY nDesc04 PICTURE "@E 999,999.99"
	@ li,131 PSAY "|"
	
	li := li + 1
	@ li,030 PSAY "|----------------------------|"
	@ li,060 PSAY "-----------------|-----------------|-----------------|-----------------|"
	
	li := li + 1
	@ li,030 PSAY "|"
	@ li,032 PSAY "MENOR PRECO: "
	@ li,045 PSAY nTotMenor PICTURE "@E 999,999.99"
	@ li,059 PSAY "|"
	@ li,060 PSAY nQtde01  PICTURE "@E 999"
	@ li,063 PSAY "-"
	@ li,067 PSAY nMenor01 PICTURE "@E 999,999.99"
	@ li,077 PSAY "|"
	@ li,078 PSAY nQtde02  PICTURE "@E 999"
	@ li,081 PSAY "-"
	@ li,085 PSAY nMenor02 PICTURE "@E 999,999.99"
	@ li,095 PSAY "|"
	@ li,096 PSAY nQtde03  PICTURE "@E 999"
	@ li,099 PSAY "-"
	@ li,103 PSAY nMenor03 PICTURE "@E 999,999.99"
	@ li,113 PSAY "|"
	@ li,114 PSAY nQtde04  PICTURE "@E 999"
	@ li,117 PSAY "-"
	@ li,121 PSAY nMenor04 PICTURE "@E 999,999.99"
	@ li,131 PSAY "|"
	
	
	li := li + 1
	@ li,002  PSAY "Itens nao Cotados > "
	@ li,024 PSAY nNao PICTURE "@E 999"
	@ li,030 PSAY "|----------------------------|"
	@ li,060 PSAY "-----------------|-----------------|-----------------|-----------------|"
	
	li := li + 1
	@ li,030 PSAY  "|"
	@ li,032 PSAY  "COND. PAGAMENTO: "
	@ li,059 PSAY "|"
	@ li,060 PSAY substr(cCond01,1,20)
	@ li,077 PSAY "|"
	@ li,078 PSAY substr(cCond02,1,20)
	@ li,095 PSAY "|"
	@ li,096 PSAY substr(cCond03,1,20)
	@ li,113 PSAY "|"
	@ li,114 PSAY substr(cCond04,1,20)
	@ li,131 PSAY "|"
	
	li := li + 1
	@ li,030 PSAY "|----------------------------|"
	@ li,060 PSAY "-----------------|-----------------|-----------------|-----------------|"
	
	li := li + 1
	@ li,030 PSAY "|"
	@ li,032 PSAY  "PRAZO ENTREGA(DIAS): "
	@ li,059 PSAY "|"
	@ li,067 PSAY nPrazo01 PICTURE "@E 9999"
	@ li,077 PSAY "|"
	@ li,085 PSAY nPrazo02 PICTURE "@E 9999"
	@ li,095 PSAY "|"
	@ li,103 PSAY nPrazo03 PICTURE "@E 9999"
	@ li,113 PSAY "|"
	@ li,121 PSAY nPrazo04 PICTURE "@E 9999"
	@ li,131 PSAY "|"
	
	li := li + 1
	@ li,001 PSAY " ____________________________|____________________________|_________________|_________________|_________________|_________________|"
	
	li := li + 1
	@ li,001 PSAY "| OBSERVACOES: "+cObs
	@ li,131 PSAY "|"
	li := li + 1
	@ li,001 PSAY "|                                                                                                                                 |"
	li := li + 1
	@ li,001 PSAY "|_________________________________________________________________________________________________________________________________|"
	li := li + 1
	@ li,01 PSAY  "| Coordenador/Gerencia:                      | Autorizante:                           | Aprovacao Diretoria:                      |"
	li := li + 1
	@ li,01 PSAY  "|                                            |                                        |                                           |"
	li := li + 1
	@ li,01 PSAY  "|____________________________________________|________________________________________|___________________________________________|"
	li := 50
	li := 60
	
	nCont 	   := 0
	CFornece01 := space(06)
	cNReduz01  := space(20)
	cFone01    := space(16)
	cContato01 := space(15)
	CFornece02 := space(06)
	cNReduz02  := space(20)
	cFone02    := space(16)
	cContato02 := space(15)
	CFornece03 := space(06)
	cNReduz03  := space(20)
	cFone03    := space(16)
	cContato03 := space(15)
	CFornece04 := space(06)
	cNReduz04  := space(20)
	cFone04    := space(16)
	cContato04 := space(15)
	cObs       := space(50)
	
	dbSelectArea("SC1")
	//dbSkip()
	
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³   Rodape do relatorios      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QrySC8    ºAutor  ³Alessandro Gomes    º Data ³  06/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function QrySC8()

Local cSELECT:= ""
Local cFROM  := ""  
Local cWHERE := ""
Local cGROUP := ""
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QryFORSC8 ºAutor  ³Alessandro Gomes    º Data ³  09/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function QryFORSC8()

Local cSELECT:= ""
Local cFROM  := ""  
Local cWHERE := ""
Local cGROUP := ""
Local cORDER := ""

cSELECT:= 	"DISTINCT C8_NUMSC, C8_FORNECE, C8_LOJA, C8_CONTATO "
cFROM  := 	"SC8"+cEmpAnt+"0 "
cWHERE := 	"D_E_L_E_T_ <> '*' AND " + ;     
		    "C8_FILIAL = '" + xFilial("SC8") +"' AND " +; 
			"C8_NUMPED = '' AND " +;
		    "C8_NUMSC = '" + SC1->C1_NUM +"' " 
cORDER :=   "C8_NUMSC, C8_FORNECE, C8_LOJA, C8_CONTATO "

cQuery :=   "SELECT "+cSELECT+" FROM "+cFROM+" WHERE "+cWHERE+" GROUP BY "+cORDER

TCQUERY cQuery NEW ALIAS "ZC8"
//////////////////////////  FIM  DA  QUERY  /////////////////////////////

Return

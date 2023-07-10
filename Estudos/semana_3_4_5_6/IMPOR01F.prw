#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} IMPOR01F
Importação da tabela
@type function
@version 33  
@author felip
@since 08/10/2022
/*/

User function IMPOR01F()

	local oFile
	local cGet := cGetFile("*.csv","Escolha o arquivo",,"C:/",.F.,,.F.)
	// local cGet := "C:\Users\felip\Downloads\MOCK_DATA.csv"
	local nI := 0
	local a
	local aArray := {}
	local nColGender := 0

	//Definindo o arquivo a ser lido
	oFile := FWFileReader():New(cGet)

	//Se o arquivo pode ser aberto
	If (oFile:Open())

		//Se não for fim do arquivo
		If ! (oFile:EoF())
			//Enquanto houver linhas a serem lidas
			While (oFile:HasLine())

				//Buscando o texto da linha atual
				cLinAtu := oFile:GetLine()
				aadd(aArray,STRTOKARR2(cLinAtu, ",",.T.))

			EndDo

			// Verificação para ver qual a posição de cada campo caso seja alterado a posição deles,
			// Para quando for importar nao ocorrer nenhum erro de posição

			if !isblind() //Para ser executado pelo usuario
				PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
			endif

			DbSelectArea("SZ1") // selecionando qual a tabela nos iremos usar
			nColGender := AScan(aArray[1], {|a| a =='gender'})
			for nI := 2 to Len(aArray)

				// aqui vamos fazer uma tradução aos campos do tipo genero caso nao
				// esteja na lingua portuguesa
				if (nColGender == 6)

					if (aArray[nI][nColGender] = "Female")
						aArray[nI][nColGender] := "Mulher"

					elseif (aArray[nI][nColGender] = "Male")
						aArray[nI][nColGender] = "Homem"

					else
						aArray[nI][nColGender] = "Outros"
					endif

				endif

				if(RecLock("SZ1", .T.))
					SZ1->Z1_FILIAL := xFilial("SZ1")
					SZ1->Z1_IDCLI  := aArray[nI][AScan(aArray[1], {|a| a == 'id'        })]
					SZ1->Z1_PRNOME := aArray[nI][AScan(aArray[1], {|a| a == 'first_name'})]
					SZ1->Z1_UTNOME := aArray[nI][AScan(aArray[1], {|a| a == 'last_name' })]
					SZ1->Z1_PAIS   := aArray[nI][AScan(aArray[1], {|a| a == 'country'   })]
					SZ1->Z1_EMAIL  := aArray[nI][AScan(aArray[1], {|a| a == 'email'     })]
					SZ1->Z1_GENERO := aArray[nI][AScan(aArray[1], {|a| a == 'gender'    })]
					SZ1->Z1_IPREDE := aArray[nI][AScan(aArray[1], {|a| a == 'ip_address'})]
					SZ1->Z1_STATUS := aArray[nI][AScan(aArray[1], {|a| a == 'is_active' })]
				endif

				// liberando somente da tabela SZ1.
				SZ1->(MsUnLock())

			next

		EndIf

		// Fecha o arquivo e finaliza o processamento
		oFile:Close()

		if !isblind()
			RESET ENVIRONMENT
		endif
	EndIf

Return(nil)

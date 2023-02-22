#INCLUDE 'TOTVS.CH'

User Function MyClient()
	While MsgYesNo("Envia um processamento a um JOB ?")
		If IpcGo("MYJOB_IPC","U_MYTASK",1,10)
			MsgInfo("Processamento enviado.")
		Else
			MsgSTop("Nao foi possivel enviar a requisicao. Nao há jobs disponiveis.")
		Endif
	Enddo
Return

User Function StatIPC(nTheads)
	Local nX := 0
	Default nTheads := 3

	For nX := 1 To nTheads
		StartJob("U_MYJOB1",GetEnvServer(),.F.)
	Next

Return

User Function Myjob1( cMsg1, cMsg2 )
	Local cFN,p1,p2

	conout("Thread ["+cValToChar(ThreadID())+"] iniciando ... ")

	While !killapp()
		cFN := NIL
		p1 := NIL
		p2 := NIL
		conout("Thread ["+cValToChar(ThreadID())+"] Aguardando um chamado ... ")
		If IpcWaitEx("MYJOB_IPC",5000,@cFN,@p1,@p2)
			conout("Thread ["+cValToChar(ThreadID())+"] Executando " + ProcName())
			&cFN.(p1,p2)
		Endif
	Enddo

	conout("Thread ["+cValToChar(ThreadID())+"] saindo ... ")
return

User Function MyTask(p1,p2)
	Local nX
	conout("Thread ["+cValToChar(ThreadID())+"] --- Inicio da tarefa ...")
	For nX := p1 TO p2
		conout("Thread ["+cValToChar(ThreadID())+"] --- Contando "+cValToChar(nX)+" ( "+cValToChar(p1)+" a "+cValToChar(p2)+" )")
		Sleep(1000)
	Next
	conout("Thread ["+cValToChar(ThreadID())+"] --- Final da tarefa ...")
Return

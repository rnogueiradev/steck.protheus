#INCLUDE "totvs.CH"

/*/{Protheus.doc} STKIMP
Importação de Títulos a pagar
@type function
@version 1.0
@author Luiz Fael
@since 6/21/2023
@return variant, Nil
/*/
User Function STKIMP()
	Local aArquivos 	:= {}
	Local aDados 		:= {}
	Local aCabec  		:= {}
	Local aDadPV		:= {}
	Local nQtdArq       := 0
	Local nx			:= 0
	Local ny			:= 0
	Local cMsg          := ''
	Local cAnt 			:= ''
	Private MVSTKIMP 	:= ''
	Private MVSTKLOG 	:= ''
	Private MVSTKPRC 	:= ''
	Private aLog		:= {}
	Private cDir 		:= ''
	If FWAlertYesNo("Iniciar processo de Importação"+CRLF+"Verificando o(s) arquivo(s).", "Importação. ")
		MVSTKIMP := cGetFile('','Selecione o diretório do(s) Arquio(s)', 0,'', .T., GETF_OVERWRITEPROMPT + GETF_LOCALHARD + GETF_RETDIRECTORY,.T.)
		If !Empty(MVSTKIMP)
			MVSTKPRC 	:= MVSTKIMP+"PRC"
			MVSTKLOG 	:= MVSTKIMP+"LOG"
			If !existDir(MVSTKLOG)
				makeDir(UPPER(MVSTKLOG))
			EndIf
			If !existDir(MVSTKPRC)
				makeDir(UPPER(MVSTKPRC))
			EndIf
			Processa( {|| fLerArq(@aArquivos,@nQtdArq)},"Aguarde Processando Lendo Arquivos "+MVSTKIMP )
			If Len(aLog) <> 0
				Processa( {|| u_fGravaLog()},"Aguarde Processando Log de Arquivos "+MVSTKIMP )
			EndIf
			If Len(aArquivos) <> 0
				If FWAlertYesNo("Localizado "+StrZero(nQtdArq,3,0)+" arquivo(s) na pasta "+MVSTKIMP+CRLF+CRLF+" Inicia o processo de Importação?.", "Importação de dados. ")
					Processa( {|| U_STKDADOS(aArquivos)},"Aguarde Importando Dado(s) "+MVSTKIMP )
					For nx:= 1 to Len(aArquivos)
						Processa( {|| u_fLerDados(aArquivos[nx],@aDados,@aCabec)},"Aguarde Processando Dado(s) "+MVSTKIMP )
						If aArquivos[nx][04]
							If 		aArquivos[nx][02] == 'SE2'
								Processa( {|| U_fGeraSE2(aDados,aCabec,aArquivos[nx][01])},"Aguarde Gravando "+aArquivos[nx][03]+' Arquivo:'+aArquivos[nx][01] )
							ElseIf  aArquivos[nx][02] == 'SC7'
								cAnt := Alltrim(aDados[01][01])
								For ny:=1 to Len(aDados)
									If  cAnt <> Alltrim(aDados[ny][01]) .or. ny==Len(aDados)
										if cAnt == Alltrim(aDados[ny][01])
											aadd(aDadPV,aDados[ny])
										endif
										Processa( {|| U_fGeraSC7(aDadPV,aCabec,aArquivos[nx][01])},"Aguarde Gravando "+aArquivos[nx][03]+' Arquivo:'+aArquivos[nx][01] )
										aDadPV := {}
										cAnt := Alltrim(aDados[ny][01])
									EndIf
									aadd(aDadPV,aDados[ny])
								Next ny
							Endif
						Endif
					Next nx
					If Len(aLog) <> 0
						Processa( {|| u_fGravaLog()},"Aguarde Processando Log de Arquivos "+MVSTKIMP )
					EndIf
					For nx:= 1 to Len(aLog)
						iF File(MVSTKIMP+Alltrim(aLog[nx][02]))
							__CopyFile( MVSTKIMP+Alltrim(aLog[nx][02]) , MVSTKPRC+'\'+Alltrim(aLog[nx][02]))
							fErase(MVSTKIMP+Alltrim(aLog[nx][02]))
						EndIf
					Next nx
					cMsg := "Verifique as pastas: "+ CRLF + CRLF
					cMsg += PADR(MVSTKIMP,20)+ '- Arquivos para Processar.'+ CRLF
					cMsg += PADR(MVSTKLOG,20)+ '- Log do Processamento.'+ CRLF
					cMsg += PADR(MVSTKPRC,20)+ '- Arquivos já Processados.'
					U_STKIMMSG("Fim da Importação",cMsg,3,5000)
				Else
					U_STKIMMSG("Importação","Cancelada",1,5000)
				EndIf
			EndIf
		EndIf
	Else
		U_STKIMMSG("Importação","Cancelada",1,5000)
	EndIf

	FwFreeArray(aLog)
	FwFreeArray(aArquivos)
	FwFreeArray(aDados)
	FwFreeArray(aCabec)
	FwFreeArray(aDadPV)
Return(nil)


/*/{Protheus.doc} fLerArq
Lendo arquivos
@type function
@version 1.0
@author Luiz Fael
@since 6/26/2023
@param aArquivos, array, array com arquivos
@Link https://tdn.totvs.com/display/public/framework/FWX2Nome
@return variant, nil
/*/
Static Function fLerArq(aArquivos,nQtdArq)
	Local nArq	    := 0
	Local cArq	    := ''
	Local cTabela   := ''
	Local aAux      := {}
	Local cSeque    := ''
	aAux := Directory(MVSTKIMP + "*.CSV")
	If Len(aAux) <> 0
		ProcRegua(Len(aArquivos))
		For nArq := 1 to Len(aAux)
			IncProc(Alltrim(aAux[nArq][01]))
			cTabela := Alltrim(FWX2Nome(SubStr(Alltrim(aAux[nArq][01]),1,3)))
			If !Empty(cTabela)
				cArq	:= MVSTKIMP+ Alltrim(aAux[nArq][01])
				aadd(aArquivos,{Alltrim(aAux[nArq][01]),SubStr(Alltrim(aAux[nArq][01]),1,3),cTabela,.T.})
			Else
				cTabela := SubStr(Alltrim(aAux[nArq][01]),1,3)
				cSeque  := 'T'+TIME()+'D'+dTos(date())
				cSeque  := StrTran(cSeque,':')
				aadd(aLog,{"Erro",Alltrim(aAux[nArq][01]),cSeque,cTabela+" Tabela Não Existe."})
			EndIf
		Next nArq
		nQtdArq := Len(aArquivos)
	Else
		U_STKIMMSG("Importação","Não foi localizado aquivos do tipo CSV. "+MVSTKIMP,1,5000)
	EndIf
	FwFreeArray(aAux)
Return(nil)

/*/{Protheus.doc} fGravaLog
Grava log
@type function
@version 1.0
@author Luiz Fael
@since 6/21/2023
@return variant, nil
/*/
User Function fGravaLog()
	Local oFile         := nil
	Local nx			:= 0
	Local nY            := 0
	Local cArq          := ""
	Local nProc         := Len(aLog)*2
	Local cMsg          := ''
	ProcRegua(nProc)
	cArq += "LOG_"
	cArq += StrTran('T'+TIME()+'D'+dTos(date()),':')
	cArq += ".CSV"
	oFile:=FWFileWriter():new(MVSTKLOG +'\'+cArq)
	oFile:nBuffersize = 5000
	if oFile:exists()
		If (oFile:Open())
			oFile:Close()
			oFile:erase()
		EndIf
	EndIf
	If (oFile:Create())
		For nx := 1 to Len(aLog)
			IncProc("Gravando arquivo LOG: "+cArq)
			cMsg := ''
			For ny:=1 to Len(aLog[nx])
				cMsg += aLog[nx][ny]
				If ny < Len(aLog[nx][ny])
					cMsg +=  ';'
				EndIf
			Next ny
			oFile:Write(cMsg + CRLF)
		Next nx
		oFile:close()
	Else
		U_STKIMMSG("Erro da Importação","Erro na geração do Aqrvivo de Log ",1,5000)
	EndIf
	FreeObj(oFile)
Return(nil)

/*/{Protheus.doc} STKIMMSG
Tela para mensagem
@type function
@version 1.0
@author Luiz Fael
@since 6/21/2023
@param cCabec, character, Titulo
@param cMsg, character, mensagem
@param nSize, numeric, Tamnho da mensagem
@param nTimer, numeric, Tempo da mensagem
@return variant, nil
/*/
User Function STKIMMSG(cCabec,cMsg,nSize,nTimer)
	Aviso(cCabec,cMsg,;
		{"OK"};                     //03 - aBotoes - Array com as opções dos botões.
	,nSize;                         //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
	,;    							//05 - cText - Titulo da Descrição (Dentro da Janela)
	,;                              //06 - nRotAutDefault - Opção padrão usada pela rotina automática
	,;                              //07 - cBitmap - Nome do bitmap a ser apresentado
	,.F.;                           //08 - lEdit - Determina se permite a edição do campo memo
	,nTimer;                              //09 - nTimer - Tempo para exibição da mensagem em segundos.
	,;                              //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
	)
Return(nil)


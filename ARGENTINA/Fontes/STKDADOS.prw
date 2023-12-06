#INCLUDE "totvs.CH"

/*/{Protheus.doc} STKDADOS
Impotação de contas a pagar
@type function
@version 1.0
@author Luiz Fael
@since 6/26/2023
@return variant, nil
/*/
User Function STKDADOS(aArquivos)
	Local nArq		:= 0
	Local cArq		:= ''
	Local cAlias    := ''
	Local ny		:= 0
	Local nZ		:= 0
	Local nPosCampo := 0
	Local aTabObr 	:= {}
	Local aAux  	:= {}
	Local aCampos 	:= {}
	Local cCampo	:= ''
	Local cSeque	:= ''
	Local oFile
	//aArquivos[nx][01] Arquivo
	//aArquivos[nx][02] Alias
	//aArquivos[nx][03] Titulo da tabela
	//aArquivos[nx][04] Arquivo valido par importação .t./.f.
	ProcRegua(Len(aArquivos))
	For nArq := 1 to Len(aArquivos)
		cArq	:= MVSTKIMP+Alltrim(aArquivos[nArq][01])
		IncProc(Alltrim(cArq))
		oFile 	:= FwFileReader():New(cArq)
		cAlias  := Alltrim(aArquivos[nArq][02])
		aCampos := FWSX3Util():GetAllFields(cAlias,.F.)
		aTabObr := {}
		aadd(aTabObr,aCampos[01])
		For ny:= 1 to Len(aCampos)
			If cAlias == 'SC7' .AND. aCampos[ny] == 'C7_NUM'
				LOOP
			ElseIf 	cAlias == 'SE2' .AND. aCampos[ny] == 'E2_NUM'
				LOOP
			EndIf
			/*If  X3Obrigat(aCampos[ny])
				aadd(aTabObr,aCampos[ny])
			EndIf*/
		Next ny
		oFile:nBuffersize = 5000
		If (oFile:Open())
			cLine:=oFile:GetLine(.F.)
			oFile:Close()
			aAux := StrTokArr2(cLine, ";")
			If Len(aAux) <> 0
				For ny:= 1 to Len(aTabObr)
					cCampo 	  := ''
					For nZ:=1 to Len(aTabObr[ny])
						If Asc(Substr(aTabObr[ny],nZ,1)) >= 48
							cCampo +=Substr(aTabObr[ny],nZ,1)
						EndIf
					Next nZ
					nPosCampo := AScan(aAux,cCampo)
					If nPosCampo == 0
						cSeque  := 'T'+TIME()+'D'+dTos(date())
						cSeque  := StrTran(cSeque,':')
						aadd(aLog,{"Erro",cArq,cSeque,'Inclua o campo obrigatorios. '+cCampo})
						FWAlertWarning("Erro", 'Inclua o campo obrigatorios. '+cCampo)
						aArquivos[nArq][04] := .F.
					EndIf
				Next ny
				For ny:=2 to Len(aAux)
					cCampo 	  := ''
					For nZ:=1 to Len(aAux[ny])
						If Asc(Substr(aAux[ny],nZ,1)) >= 48
							cCampo +=Substr(aAux[ny],nZ,1)
						EndIf
					Next nZ
					nPosCampo := AScan(aCampos,cCampo)
					If nPosCampo == 0
						cSeque  := 'T'+TIME()+'D'+dTos(date())
						cSeque  := StrTran(cSeque,':')
						aadd(aLog,{"Erro",cArq,cSeque,'Campo não existe na estrutura da tabela: '+cCampo+','+cArq})
						FWAlertWarning("Erro",'Campo não existe na estrutura da tabela: '+cCampo+','+cArq)
						aArquivos[nArq][04] := .F.
					EndIf
				Next ny
			Else
				cSeque  := 'T'+TIME()+'D'+dTos(date())
				cSeque  := StrTran(cSeque,':')
				aadd(aLog,{"Erro",cArq,cSeque,'Estrutura do arquivo: '+cArq})
				FWAlertWarning("Erro",'Estrutura do arquivo: '+cArq)
				aArquivos[nArq][04] := .F.
			EndIf
		Else
			cSeque  := 'T'+TIME()+'D'+dTos(date())
			cSeque  := StrTran(cSeque,':')
			cMsg := OFILE:OERROLOG:MESSAGE
			aadd(aLog,{"Erro",cArq,cSeque,cMsg})
			FWAlertWarning("Erro",cMsg)
			aArquivos[nArq][04] := .F.
		EndIf
	Next nArq
	FreeObj(oFile)
	FwFreeArray(aAux)
	FwFreeArray(aTabObr)
	FwFreeArray(aCampos)
Return(nil)

/*/{Protheus.doc} fLerDados
Ler dados para importar
@type function
@version 1.0
@author Luiz Fael
@since 6/21/2023
@param aArquivo, array, informação do arquivo
@param aDados, array, dados para importar
@return variant, nil
/*/
User Function fLerDados(aArquivo,aDados,aCabec)
	Local cArq		:= MVSTKIMP+Alltrim(aArquivo[01])
	Local oFile 	:= FwFileReader():New(cArq)
	Local aAux  	:= {}
	Local ny		:= 0
	Local nz		:= 0
	Local nValor	:= 0
	Local cCampo	:= ''
	Local cTipo     := ''
	Local nTam		:= 0
	//aArquivos[nx][01] Arquivo
	//aArquivos[nx][02] Alias
	//aArquivos[nx][03] Titulo da tabela
	//aArquivos[nx][04] Arquivo valido par importação .t./.f.
	aDados := {}
	aCabec := {}
	oFile:nBuffersize = 5000
	If (oFile:Open())
		aAux := oFile:GetAllLines() // ACESSA TODAS AS LINHAS
		oFile:Close()
		aCabec := StrTokArr2(aAux[1], ";")
		ProcRegua(Len(aCabec))
		For ny:= 1 to Len(aCabec)
			If ny==1
				aCabec[ny]  := {aCabec[ny],"C"}
			Else
				cCampo		:= aCabec[ny]
				cTipo   	:= GetSx3Cache(aCabec[ny],'X3_TIPO')
				nTam		:= GetSx3Cache(aCabec[ny],'X3_TAMANHO')
				aCabec[ny]  := {cCampo,cTipo,nTam}
			EndIf
		Next ny
		For ny:= 2 to Len(aAux)
			aadd(aDados,StrTokArr(aAux[ny], ";"))
		Next ny
		FreeObj(oFile)
		//FwFreeArray(aAux)
		ProcRegua(Len(aDados))
		For ny:=1 to Len(aDados)
			IncProc('Lendo Dados')
			For nz:= 2 to Len(aCabec)
				If !Empty(aDados[ny][nz])
					aDados[ny][nz] := Alltrim(aDados[ny][nz])
					If 	aCabec[nz][02] == 'C'
						aDados[ny][nz] := Alltrim(aDados[ny][nz])
					ElseIf	aCabec[nz][02] == 'D'
						aDados[ny][nz] := STOD(aDados[ny][nz])
					ElseIf	aCabec[nz][02] == 'N'
						nValor := VAL(Strtran(aDados[ny][nz],',','.'))
						aDados[ny][nz] := nValor
					EndIf
				EndIf
			Next nz
		Next ny
	EndIf
Return(nil)

/*/{Protheus.doc} fGeraSE2
Gera titulo a pagar
@type function
@version 1.0
@author Luiz Fael
@since 6/21/2023
@param aArray, array, dados do titulo para gravação
@param aCabec, array, campos do titulo para gravação
@return variant, nil
/*/
User Function fGeraSE2(aDados,aCabec,cArq)
	Local aCols 	:= {}
	Local nX		:= 0
	Local nO		:= 0
	Local nPosCampo := 0
	Local cSeque  	:= ''
	Local CSE2NUM	:= ''
	Local cMsgErro  := ''
	Private lMsErroAuto := .F.
	Private lAutoErrNoFile := .T.
	Private lMsHelpAuto :=.T.

	For nX:= 1 to Len(aDados)
		aCols := {}
		nPosCampo := AScan(aCabec,"E2_NUM")
		If nPosCampo == 0
			aadd(aCols,{"E2_NUM",'', NIL })
		EndIf
		For nO:= 1 to Len(aCabec)
			If nO > 1
				aadd(aCols,{ aCabec[nO][01], aDados[nX][nO] , NIL })
			EndIf
		Next nO
		CSE2NUM := GetSx8Num("SE2","E2_NUM")
		ConfirmSX8()
		nPosCampo := AScan(aCols,{|a| AllTrim(a[1]) == "E2_NUM"})
		aCols[nPosCampo] := {"E2_NUM",CSE2NUM, NIL }
		Begin Transaction
			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aCols,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
			aErro := {}
			If lMsErroAuto
				aErroAuto := GetAutoGRLog()
				For nO := 1 To Len(aErroAuto)
					cMsgErro += StrTran(StrTran(aErroAuto[nO], "<", ""), "-", "") + " "
				Next nO
				cSeque  := 'T'+TIME()+'D'+dTos(date())
				cSeque  := StrTran(cSeque,':')
				aadd(aLog,{"Erro",cArq,cSeque,'MsExecAuto FINA050 '+cMsgErro})
				FWAlertWarning("Erro",'MsExecAuto FINA050 '+cMsgErro)
				DisarmTransaction()
				FwFreeArray(aCols)
				FwFreeArray(aErroAuto)
				Return(nil)
			Else
				aadd(aLog,{"IMPO",cArq,cSeque,'Sucesso '+CSE2NUM})
				FWAlertSuccess("Importação contas a pagar Sucesso: "+CSE2NUM, "Contas a Pagar")
			Endif
		End Transaction
	Next nI
	FwFreeArray(aCols)
	FwFreeArray(aErroAuto)
Return(nil)

/*/{Protheus.doc} fGeraSC7
Gera pedido de compras
@type function
@version 1.0
@author Luiz Fael
@since 6/26/2023
@param aArray, array, dados do pedido para gravação
@param aCabec, array, campos do pedido para gravação
@return variant, nil
/*/
User Function fGeraSC7(aDados,aCabec,cArq)
	Local aCols 	:= {}
	Local aLinha 	:= {}
	Local aHeader 	:= {}
	Local aErroAuto := {}
	Local aHeCamp	:= {"C7_FILIAL","C7_NUM","C7_EMISSAO","C7_FORNECE","C7_LOJA","C7_COND","C7_CONTATO","C7_FILENT","C7_MOEDA","C7_TXMOEDA"}
	Local nO		:= 0
	Local nX 		:= 0
	Local cSeque  	:= ''
	Local CSC7NUM	:= ''
	Local naModulo  := nModulo
	Local cMsgErro	:= ''
	Private lMsErroAuto := .F.
	Private lAutoErrNoFile := .T.
	Private lMsHelpAuto :=.T.

	SB1->(dbsetOrder(1))

	CSC7NUM 	:= GetSx8Num("SC7","C7_NUM")
	ConfirmSX8()
	For nX := 1 To Len(aDados)
		aLinha		:= {}
		For nO:= 2 to Len(aCabec)
			If AScan(aHeCamp,aCabec[nO][01]) <> 0
				If AScan(aHeader,{|x| x[1]= aCabec[nO][01]}) == 0
					If aCabec[nO][01] == "C7_NUM"
						aadd(aHeader,{"C7_NUM",CSC7NUM})
					Else
						aadd(aHeader,{aCabec[nO][01],aDados[nX][nO]})
					EndIf
				EndIf
			Else
				If aCabec[nO][01] == 'C7_PRODUTO'
					SB1->(dbseek(xFilial('SB1')+aDados[nX][nO]))
					aadd(aLinha,{aCabec[nO][01], aDados[nX][nO] , NIL })
				Else
					aadd(aLinha,{aCabec[nO][01], aDados[nX][nO] , NIL })
				EndIf
			EndIf
		Next nO
		If AScan(aLinha,{|x| x[1]= "C7_TXMOEDA" }) == 0
			aadd(aLinha,{"C7_TXMOEDA", 1 , NIL })
		EndIf
		aadd(aCols,aLinha)
	Next nX

	Begin Transaction
		//MSExecAuto({|v,x,y,z,w| MATA120(v,x,y,z,w)},2,aHeader,aCols,3,.F.) //autorização de entrega
		nModulo := 2
		MSExecAuto({|v,x,y,z,w| MATA120(v,x,y,z,w)},1,aHeader,aCols,3,.F.) //pedido de compra
		nModulo := naModulo
		If lMsErroAuto
			aErroAuto := GetAutoGRLog()
			For nO := 1 To Len(aErroAuto)
				cMsgErro += StrTran(StrTran(aErroAuto[nO], "<", ""), "-", "") + " "
			Next nO
			cSeque  := 'T'+TIME()+'D'+dTos(date())
			cSeque  := StrTran(cSeque,':')
			aadd(aLog,{"Erro",cArq,cSeque,'MsExecAuto MATA120 '+cMsgErro})
			FWAlertWarning("Erro",'MsExecAuto MATA120 '+cMsgErro)
			DisarmTransaction()
			FwFreeArray(aCols)
			FwFreeArray(aLinha)
			FwFreeArray(aHeader)
			FwFreeArray(aErroAuto)
			Return(nil)
		Else
			aadd(aLog,{"IMPO",cArq,cSeque,'Sucesso '+CSC7NUM})
			FWAlertSuccess("Importação pedido de compras Sucesso: "+CSC7NUM, "Pedido de Compras")
		Endif
	End Transaction
	FwFreeArray(aCols)
	FwFreeArray(aLinha)
	FwFreeArray(aHeader)
	FwFreeArray(aErroAuto)
Return(nil)

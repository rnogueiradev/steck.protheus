#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STGAP07         | Autor | GIOVANI.ZAGO              | Data | 01/02/2013  |
|=====================================================================================|
|Descrição |  Validação do gatilho desconto adicional  e acrescimo adicional          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STGAP07                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
//FR - 07/02/2022 - alteração, inserida condição de verificar se há desconto inserido,
// pois estava bloqueando qq situação, tendo desconto ou não quando a chamada vinha 
// de execauto, o gatilho do campo UB_XPORDEC era acionado e bloqueava o orçamento 
// porque a função não fazia validação se o campo desconto  estava preenchido ou não, 
// corrigida esta situação, ok
//-------------------------------------------------------------------------------------// 
*-----------------------------*
User Function STGAP07(cTip,_nRet,_nValr)
	*-----------------------------*

	Local aArea         := GetArea()
	Local lRet          := .F.
	Local _nOld         := n
	Local _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Local _nPosTotItem  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_VLRITEM" ,"C6_VALOR"  	)   })
	Local _nPosPrcven   := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_VRUNIT"	,"C6_PRCVEN"  	)   })
	Local _nPosQtdVen	:= aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_QUANT"	,"C6_QTDVEN"   	)   })
	Local _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_PRODUTO" ,"C6_PRODUTO"	)   })
	Local _nPosXDesc    := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XPORDEC" ,"C6_XPORDEC"	)   })
	Local _nPosXVALdesc := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XVALDES" ,"C6_XVALDES"   )   })
	Local _nPosXAcreP   := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XACREPO" ,"C6_XACREPO"	)   })
	Local _nPosXValAcre := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XACREVA" ,"C6_XACREVA"   )   })
	Local _nPosXPrCcon  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XPRCCON" ,"C6_XPRCCON"   )   })
	Local _nPosBloq     := aScan(aHeader, { |x| AllTrim(x[2]) == IIF(  _Lmomat,"UB_XBLQITE"  ,"C6_ZMOTBLO"  )   })
	Local _nPosUnt      := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_PRCTAB"  ,"C6_XPRCLIS"   )   })// Preço LISTA
	Local _nPosList     := aScan(aHeader, { |x| AllTrim(x[2]) == IIF(  _Lmomat,"UB_XPRCREF"  ,"C6_PRUNIT"  )   }) // Preço Unitário
	Local _nValComiss   := 0
	Local _nTotPed      := 0
	Local lFora 		:= .F.	//FR - 07/02/2022 - ALTERAÇÃO - Quando a chamada vier do post, esta variável ficará = .T.
	Local lValidaDEsc   := .F.  //FR - 07/02/2022 - ALTERAÇÃO - Variável para armazenar o conteúdo do parâmetro ST_XDESC
	Local nPValICMSST   := aScan(aHeader, { |x| AllTrim(x[2]) == IIF(  _Lmomat,"UB_ZVALIST" ,"C6_ZVALIST"	)})	// Posicao do Valor do ICMS ST

	//FR - 07/02/2022 - ALTERAÇÃO - Quando a chamada vier do post, fixar o cTip = '0' porque abaixo, já há a verificação se a origem é de rotina automática
	//por algum motivo mesmo sendo via post, está entrando no bloco do l410Auto, e não deveria, por isso, inseri esta verificação aqui antes
	If IsInCallStack("POST")
		lFora := .T.
		//cTip  := '0'  //FR - TESTE
	Endif 

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		If ValType(_nRet) != "N"
			_nRet:= n
		EndIf

		If ValType(_nValr) != "N"
			If cTip ='1'
				_nValr:= 	aCols[_nRet,_nPosXDesc]
			ElseIf cTip ='2'
				_nValr:= 	aCols[_nRet,_nPosXAcreP]
			Else
				_nValr:=0

			EndIf
		EndIf


		If cTip = '0'

			If !aCols[_nRet,Len(aHeader)+1]
				//If GetMv("ST_XDESC",,.F.)
				lValidaDEsc:= GetNewPar("ST_XDESC" , .F.) //FR - 07/02/2022 - chamada do parâmetro que valida desconto
				If !lValidaDEsc 
					aCols[_nRet,_nPosXValAcre] := 0
					aCols[_nRet,_nPosXAcreP]   := 0
					aCols[_nRet,_nPosXVALdesc] := 0
					aCols[_nRet,_nPosXDesc]    := 0
				EndIf
			EndIf

		ElseIf cTip = '1'

			If !aCols[_nRet,Len(aHeader)+1]
				aCols[_nRet,_nPosPrcven]   := aCols[_nRet,_nPosPrcven] + aCols[_nRet,_nPosXVALdesc]
				aCols[_nRet,_nPosXDesc]    :=_nValr  //Aqui guarda o percentual de desconto (Vai para o campo UB_XPORDEC)
				aCols[_nRet,_nPosXVALdesc] := Round(((	_nValr*aCols[_nRet,_nPosPrcven])/100),2)
				aCols[_nRet,_nPosPrcven]   := ROUND(aCols[_nRet,_nPosPrcven] - aCols[_nRet,_nPosXVALdesc],2)
				aCols[_nRet,_nPosTotItem]  := ROUND(aCols[_nRet,_nPosPrcven]*aCols[_nRet,_nPosQtdVen],2)
				aCols[_nRet,_nPosXPrCcon]  :=  aCols[_nRet,_nPosPrcven]
				aCols[_nRet,_nPosList]         := aCols[_nRet,_nPosPrcven]
				_nTotPed    += aCols[_nRet,_nPosTotItem]
				If (_Lmomat)

					//FR - 07/02/2022 - alteração, inserida condição de verificar se há desconto inserido, 
					//pois estava bloqueando qq situação, tendo desconto ou não
					If _nValr > 0		
						M->UA_XBLOQ :='1'   //1=Bloqueado;2=Liberado;3=Cancelado 
						If    !('DESC' $ ALLTRIM(M->UA_XDESBLQ))
							M->UA_XDESBLQ := 	ALLTRIM(M->UA_XDESBLQ)+'DESC/'
						EndIf
						aCols[_nRet,_nPosBloq] := '5'  //1=Preco Sob Consulta;2=Alteracao Preco;3=Liberado;4=Cond.Pag.;5=Desconto
					Endif 
					//FR - 07/02/2022 - alteração, ver se há desconto, se houver, bloqueia para posterior liberação do responsável

				Else

					U_STMAFISRET() //20220131002377

					//FR - 07/02/2022 - alteração, inserida condição de verificar se há desconto inserido, pois estava bloqueando qq situação, tendo desconto ou não
					If _nValr > 0		
						M->C5_ZBLOQ   :="1"
						If    !('DESC' $ ALLTRIM(M->C5_ZMOTBLO))
							M->C5_ZMOTBLO := 	ALLTRIM(M->C5_ZMOTBLO)+'DESC/'
						EndIf
						aCols[_nRet,_nPosBloq] := '5'
					Endif
					//FR - 07/02/2022 - alteração, inserida condição de verificar se há desconto inserido, pois estava bloqueando qq situação, tendo desconto ou não 

				EndIf
			EndIf
		ElseIf cTip = '2'
			If !aCols[_nRet,Len(aHeader)+1]

				aCols[_nRet,_nPosPrcven]   := aCols[_nRet,_nPosPrcven] - aCols[_nRet,_nPosXVALACR]
				aCols[_nRet,_nPosXAcreP]   := _nValr
				aCols[_nRet,_nPosXVALACR]  := noRound(((	_nValr*aCols[_nRet,_nPosPrcven])/100))
				aCols[_nRet,_nPosPrcven]   := ROUND(aCols[_nRet,_nPosPrcven] +	aCols[_nRet,_nPosXVALACR] ,2)
				aCols[_nRet,_nPosTotItem]  := ROUND(aCols[_nRet,_nPosPrcven]*aCols[_nRet,_nPosQtdVen],2)
				aCols[_nRet,_nPosXPrCcon]  :=  aCols[_nRet,_nPosPrcven]
				aCols[_nRet,_nPosList]     := aCols[_nRet,_nPosPrcven]
				_nTotPed    += aCols[_nRet,_nPosTotItem]

			EndIf
		EndIf

		If !(_Lmomat)
			// Atualiza a Get Dados	e Rodapé
			If _nTotPed > 0
				Ma410Rodap(,,0)

				/*******************************************
				Ação...........: Não permite atualizar o Browse do pedido de venda se for chamado pela função MSTECK5B.
				...............: Esta é uma rotina de importação de itens de pedido via arquivo CSV.
				...............: Se atualizar no meio do processo de imput de informação o browse se perde.
				Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
				Data...........: 22/12/2021
				Chamado........: 20211203025898
				*******************************************/
				IF FWIsInCallStack("MSTECK5B") = .F.
					If ( Type("l410Auto") == "U" .OR. !l410Auto )
						oGetDad:oBrowse:Refresh()
					EndIf
				ENDIF
			Endif

		Else

			n:=_nRet
			U_STTMKG01()
			MaFisRef("IT_VALMERC","TK273",aCols[_nRet,_nPosTotItem])

			U_STTMKG01()
			n:=	_nOld
			// Atualiza totais da tela
			Tk273Trigger()
			Tk273FRefresh()
			Tk273TlvImp()
		Endif
	Endif
	Restarea(aArea)
	Return(lRet)



	/*====================================================================================\
	|Programa  | STTMK_3_5_B       | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
	|=====================================================================================|
	|Descrição |  Troca de Vendedor                                                       |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STTMK_3_5_B                                                               |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*---------------------------------------------------*
User Function STTMB35()
	*---------------------------------------------------*

	Local cVendMemory:=  M->UA_VEND
	Local cVendNew   :=  M->UA_VEND

	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Escolha o Vendedor") From 1,0 To 10,25 OF oMainWnd

	@ 05,04 SAY "Vendedor:" PIXEL OF oDlgEmail
	@ 15,04 MSGet cVendNew 	F3 'SA3'	  Size 35,012  PIXEL OF oDlgEmail Valid ((existcpo("SA3",cVendNew)) .Or. alltrim(cVendNew)='' )
	@ 35,04 SAY substr(Posicione("SA3",1,xFilial("SA3")+cVendNew,"A3_NOME"),1,30)  PIXEL OF oDlgEmail
	@ 053, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	@ 053, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel
	nOpca:=0

	ACTIVATE MSDIALOG oDlgEmail CENTERED

	If nOpca == 1
		M->UA_VEND    := cVendNew
		//M->UA_DESCVEN := Posicione("SA3",1,xFilial("SA3") + M->UA_VEND,"A3_NOME")
		M->UA_XHISVEN := SUBSTR(Alltrim(cusername),1,28)+' / '+dtoc(date())+' / '+Time()
		//U_STTMKI3_7_1('371B')

		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<b>Pedido: </b>'+Alltrim(M->UA_NUM)+'<br><b>Usuário: </b>'+Alltrim(cUserName)+'<br>'
		cMsg += '<b>Vendedor1 de: </b>'+M->UA_VEND+'<br>'
		cMsg += '<b>Vendedor1 para: </b>'+cVendNew+'<br>'
		cMsg += '</body></html>'

		//U_STMAILTES('filipe.nascimento@steck.com.br;daniel.santos@steck.com.br',"","Troca Vendedor",cMsg)

	Else
		M->UA_VEND := cVendMemory
	Endif

	Return()



	*---------------------------------------------------*
User Function STOTRVEN()
	*---------------------------------------------------*

	Local cVendMemory:= SUA->UA_VEND
	Local cVendNew   := SUA->UA_VEND

	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Escolha o Vendedor") From 1,0 To 10,25 OF oMainWnd

	@ 05,04 SAY "Vendedor:" PIXEL OF oDlgEmail
	@ 15,04 MSGet cVendNew 	F3 'SA3'	  Size 35,012  PIXEL OF oDlgEmail Valid ((existcpo("SA3",cVendNew)) .Or. alltrim(cVendNew)='' )
	@ 35,04 SAY substr(Posicione("SA3",1,xFilial("SA3")+cVendNew,"A3_NOME"),1,30)  PIXEL OF oDlgEmail
	@ 053, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	@ 053, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel
	nOpca:=0

	ACTIVATE MSDIALOG oDlgEmail CENTERED

	If nOpca == 1
		RecLock("SUA", .F.)
		SUA->UA_VEND    := cVendNew
		//SUA->UA_DESCVEN := Posicione("SA3",1,xFilial("SA3") +SUA->UA_VEND,"A3_NOME")
		SUA->UA_XHISVEN := SUBSTR(Alltrim(cusername),1,28)+' / '+dtoc(date())+' / '+Time()
		SUA->(MsUnlock())
		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<b>Pedido: </b>'+Alltrim(SUA->UA_NUM)+'<br><b>Usuário: </b>'+Alltrim(cUserName)+'<br>'
		cMsg += '<b>Vendedor1 de: </b>'+SUA->UA_VEND+'<br>'
		cMsg += '<b>Vendedor1 para: </b>'+cVendNew+'<br>'
		cMsg += '</body></html>'

	Endif

Return


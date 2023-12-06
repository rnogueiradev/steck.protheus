#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#define CLRF Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³MT410TOK  ºAutor  ³Microsiga           º Data ³  12/09/09   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³Ponto de Entrada na validacao TUDOOK do pedido de venda     º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT410TOK()
	Local aArea         := GetArea()
	Local lRet 			:= .T.
	Local _lcall 		:= IsInCallSteck("U_STFAT15")
	Local _nPosOPER     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_OPER"   })
	Local _nPosItem     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_ITEM"   })
	Local _nPosEmi     	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_EMISSAO"   })
	Local _nPosQtd    	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_QTDVEN"   })
	Local  _nNfOr		:= aScan(aHeader,{|w| AllTrim(w[2])=="C6_NFORI"})
	Local  _nProd       := aScan(aHeader,{|w| AllTrim(w[2])=="C6_PRODUTO"})
	Local  _ncli       := M->C5_CLIENTE
	Local  _nLoj       := M->C5_LOJACLI
	Local i
	Local _cOerFalRes   := GetMv("ST_OPRESFA",,"94")
	Local lNovaR        := GETMV("STREGRAFT",.F.,.T.)	    // Ticket: 20210811015405 - 24/08/2021
	Local cObs		    := M->C5_XMSGANA
	Local cLogAnali     := ''
	Local _cOper        := GetMv("ST_IBLTRAN",,'88,89,94')
	Local _lTrocNf      := !Empty(Alltrim(M->C5_XTRONF)) //giovani zago 27/01/2014 troca de nf
	Local _lPromo       := GetMv("ST_PROMOMA",,.F.)
	Local _cCity 		:= ' '
	Local _cOperEmb     := SuperGetMV("ST_OPEREMB",.F.,"94") // THIAGO FONSECA - TRATAMENTO PARA FILIAL 04 GERAÇÃO EMBARQUE DT-TI-017 13.07.16
	Local _cCepe        := Posicione("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_CEPE") // Adicionado CHAMADO 005220
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := ' '
	Local cMsg	    := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local _nX
	Local _cQuery  := ""

    //FR - rest para pedidos de venda - 21/09/2021
    Local lFora     := .F.
	LOCAL  cCliDist 	:= SuperGetMV("ST_CLIDIST",.F.,"03346706")

	/***************************************************************************************************************************************
	<<Altera��o>>
	A��o......: N�o permitir incluir um pedido de venda diretamente para a STECK - Distribuidora c�digo "033467"
	Analista..: Marcelo Klopfer Leme - SIGAMAT
	Data......: 29/09/2022
	Chamado...:  20220928018282
	***************************************************************************************************************************************/
	IF ( Type("l410Auto") == "U" .OR. !l410Auto )
		IF INCLUI = .T. .AND. M->C5_TIPO = "N"
			IF M->C5_CLIENTE+M->C5_LOJACLI = ALLTRIM(cCliDist) .AND. cEmpAnt $ ("03/01")
				MSGALERT("Pedidos de Venda para a Distribuidora devem ser originados via Pedido de Compra na Distribuidora!")
				RETURN .F.
			ENDIF
		ENDIF	
	ENDIF	


	/***********************************************************************************************************************
	Fonte........: MSTECK15
	a��o.........: Fun��o para c�lculo dos dias da entrega progamada do Pedido de Venda
	Desenvolvedor: Marcelo Klopfer Leme
	Data.........: 29/04/2022
	Chamado......: 20220429009114 - Oferta Log�stica
	***********************************************************************************************************************/
	lRet := U_MSTECK15()
	IF lRet = .F.
		RETURN lRet
	ENDIF

    If IsBlind()
        lFora := .T.
    Endif 

    If lFora
        Return .T.
    Endif 
    //FR - rest para pedidos de venda - 21/09/2021

	If ( Type("l410Auto") == "U" .OR. !l410Auto )//GIOVANI ZAGO ERRO NA UNICOM COM FRETE CIF 19/05/2016

		If ! _lcall .And. 	!(aCols[1,_nPosOPER] $ _cOerFalRes)  //Giovani Zago MIT006 item 88 (Liberação automatica de estoque e geração de empenho(sdc) sem gerar pa1 e pa2) 21/05/13
			If !_lTrocNf					//giovani zago 27/01/2014 troca de nf
				lRet := U_STFSVE72()  		//Funcao para avaliar o pedido de venda
				If lRet
					lRet := U_STGAP31() 	//Giovani Zago Gap 31   projeto onda 2°   //Funcao para avaliar o pedido de venda
				EndIf
				If lRet
					lRet := U_STXOKCALL() 	//Giovani Zago Endereço Entrega   projeto onda 2°
				EndIf
			EndIf
		Endif

		If ! _lcall .And. (aCols[1,_nPosOPER] $ "74")
			U_ST31GAP()
		EndIf

		If lRet  .And. (aCols[1,_nPosOPER] $ _cOperEmb) .And. cEmpAnt == '01' .And. cFilAnt == '04'
			lRet := U_STEMBAM7() // THIAGO FONSECA - TRATAMENTO PARA FILIAL 04 GERAÇÃO EMBARQUE DT-TI-017 13.07.16
		EndIf

		If lRet  .And. (aCols[1,_nPosOPER] $ _cOper)
			lRet := U_STSALIBL() //Giovani Zago VERIFICA SALDO NA TRANSFERENCIA
		EndIf

		If lRet  .And. (aCols[1,_nPosOPER] $ '19')//Giovani Zago VERIFICA CAMPOS DE BONUS 01/02/2016
			If  (Empty(Alltrim(M->C5_XBONUS))) .Or. Empty(Alltrim(M->C5_XBONUMO))
				MsgInfo("Preencha o Campos de Bonus/Amostra ....!!!")
				lRet := .F.
			EndIf
		EndIf
		If lRet  .And. (aCols[1,_nPosOPER] $ '12/13/19/20')//Giovani Zago VERIFICA CAMPOS DE BONUS 01/02/2016
			If  (Empty(Alltrim(M->C5_XBOBS)))
				MsgInfo("Preencha a Obs. do Bonus/Amostra ....!!!")
				lRet := .F.
			EndIf
		EndIf

		If ! _lcall  .And. _lTrocNf
			lRet := U_STTRONF() //Giovani Zago VERIFICA SALDO NA TRANSFERENCIA
		EndIf

		If _lcall
			cLogAnali := "Analisado por " + cUserName + CRLF + " em " + DtoC(dDatabase) +CRLF+" as " + Time()+ CRLF
			M->C5_XMSGANA := cObs + cLogAnali
		Endif

		//Giovani Zago 26/05/14
		If ! _lcall    .And. lRet .AND. !EMPTY(_cCepe)
			lRet :=	U_STCEPNF()
		EndIf

		//Giovani Zago 30/10/14
		If ! _lcall    .And.  lRet  .And. _lPromo
			lRet :=	U_STPROMOMAR()
		EndIf

		If lRet
			lRet :=	U_STBLQMKT() //Chamado 001109 - Marketing
		EndIf

//		FWAlertInfo(cEmpAnt)
		If aCols[1,_nPosOPER] = '41' .And. cEmpAnt <> '03'
			If Empty(Alltrim(M->C5_XNFORI))
				MsgInfo("Pedido de Remessa Futura devem ter o Campo Nf Original Preenchido..!!!")
				lRet := .F.
			EndIf
		EndIf

	    // ---------------- Valdemir Rabelo 08/02/2022 - Chamado: 20220109000635
		if Empty(Alltrim(M->C5_TRANSP))
		    MsgInfo("Transportadora n�o pode ser em branco. Por favor, verifique..!!!")
			lRet := .F.
		Endif 
		// -------------------
		If !(Empty(Alltrim(M->C5_ZENDENT))) .And. Empty(Alltrim(M->C5_XCODMUN))
			MsgInfo("Preencha o Codigo do Municipio de Entrega ....!!!")
			lRet := .F.
		EndIf

		DbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		If		SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI ))
			If  Alltrim(M->C5_ZCEPE) = Alltrim(SA1->A1_CEP) .And. !Empty(Alltrim(SA1->A1_CEP))
				MsgInfo("Cep de Entrega Igual ao Cep de Faturamento.......!!!")
				lRet := .F.
			EndIf
		EndIf

		If lRet
		    IF lNovaR
			   lRet	:= U_STCHKTRP("P")
			ENDIF 
		EndIf

		//Renato Nogueira 04/05/2015
		If ! _lcall    .And. lRet .And. (aCols[1,_nPosOPER] $ "37")
			lRet :=	U_STREM38() //Chamado 001873
		EndIf
		//gIOVANI ZAGO  CHAMADO 1735
		If lRet .And. GetMv("ST_TRSTE",,.F.) .And. M->C5_XTIPO = '2'//entrega
			DbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			If		SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI ))
				If !(Empty(Alltrim(M->C5_XCODMUN)))
					_cCity :=  M->C5_XCODMUN
				Else
					_cCity :=  SA1->A1_COD_MUN
				EndIf
				If SA1->A1_EST = "SP"
					lRet := U_STSPCITY( M->C5_TRANSP , _cCity )
				EndIf
			EndIf
		EndIf

		If lRet
			If M->C5_TPFRETE<>SC5->C5_TPFRETE
				M->C5_XLOGFRE	:= "Alterado de: "+SC5->C5_TPFRETE+" para: "+M->C5_TPFRETE+" em "+DTOC(Date())+" "+Time()+" por "+cUserName+" - MT410TOK"
			EndIf
			If M->C5_CONDPAG <> SC5->C5_CONDPAG
				//giovani zago	06/03/17 chamado: 005010

				_cEmail	:= " CLAYTON.BRAGA@steck.com.br;DAVI.SOUZA@steck.com.br  "
				_cAssunto := "Altera��o de Cond.Pagamento Pedido: "+SC5->C5_NUM
				cMsg := ""
				cMsg += '<html><head><title></title></head><body>'
				cMsg +=  "Alterado de: "+SC5->C5_CONDPAG+"("+SUBSTR(Alltrim(Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI")),1,40)	+") para: "+M->C5_CONDPAG+"("+SUBSTR(Alltrim(Posicione("SE4",1,xFilial("SE4")+M->C5_CONDPAG,"E4_DESCRI")),1,40)	+") em "+DTOC(Date())+" "+Time()+" por "+cUserName+" - MT410TOK" ;
				+' </body></html>'

				U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

			EndIf

		EndIf

		If lRet .And. (aCols[1,_nPosOPER] $ "95") .And. Empty(M->C5_XPEDTRI) //Nota triangular - Chamado 002583
			MsgInfo("Tipo de opera��o 95 e pedido triangular n�o preenchido")
			lRet := .F.
		EndIf

		If lRet	.And. !Empty(M->C5_XPEDTRI) //Nota triangular - Chamado 002583
			lRet	:= VLDPEDTRI()
		EndIf

		//Regra retirada a pedido do Francisco, ticket 20210616010208
		/*
		If M->C5_TRANSP=="000001" .And. !(M->C5_TPFRETE=="C") //Chamado 002987
			MsgAlert("Transportadora Steck e frete diferente de CIF, verifique!")
			Return(.F.)
		EndIf
		*/

		If !Empty(SA1->A1_XEAN14)  //Chamado 002970
			If !U_EAN14VLD()
				MsgAlert("Problema com cadastro de EAN14, verifique!")
				Return(.F.)
			EndIf
		EndIf

		If M->C5_TIPO <> "B"
			If SA1->A1_XBLOQF=="B" //Chamado 002796
				MsgAlert("Aten��o, cliente bloqueado para gerar pedido, verifique com o financeiro, o pedido não será gerado!")
				Return(.F.)
			EndIf
		EndIf

		IF !M->C5_TIPO $ "B#D"//Ticket 20190628000038 - Everson Santana - 280619
			If SA1->A1_XGERPED=="N"
				MsgAlert("Aten��o, bloqueado para gerar pedido, falta documenta��o, o pedido não será gerado!")
				Return(.F.)
			EndIf
		ENDIF

		If lRet
			U_STMAILPV (1,aCols,aHeader)//Chamado 002881
		Endif
		If lRet
			For i:=1 To Len(aCols)
				If  (aCols[i,_nPosOPER] $ "74")   .And. !( __cUserId $ GetMv("ST_TO410",,"000000/000645")) .And. cEmpAnt == '01' .And. cFilAnt == '04'
					MsgInfo("Utilize a Nova Rotina de Beneficiamento ....!!!")
					lRet := .F.
				EndIf
				If cEmpAnt = '01'
					aCols[i,_nPosEmi] := M->C5_EMISSAO
				EndIf
			Next i
		Endif


	For i:=1 To Len(aCols)

		If  aCols[n,_nPosOPER]$getmv("ST_CONSIG")
			DbSelectArea("SD2")
			DbSetOrder(3)
			If  !DbSeek(xFilial("SD2")+aCols[n, _nNfOr]+"001"+_ncli+_nLoj+aCols[n,_nProd])

				If Select("TSD2") > 0
					DbSelectArea("TSD2")
					DbCloSeArea()
	Endif

				_cQuery := " SELECT SD2.*                                            "
				_cQuery += " FROM "+Alltrim(SuperGetMV("STALIASIND",,"UDBP12"))+".SD2010 SD2  "
				_cQuery += " WHERE SD2.D2_FILIAL = '02'  AND   "
				_cQuery += "       SD2.D_E_L_E_T_ <> '*'                 AND   "
				_cQuery += "       SD2.D2_DOC = '"+aCols[n, _nNfOr]+"'   AND   "
				_cQuery += "       SD2.D2_SERIE='001'                    AND   "
				_cQuery += "       SD2.D2_CLIENTE = '"+_ncli+"'          AND   "
				_cQuery += "       SD2.D2_LOJA    = '"+_nLoj+"'          AND   "
				_cQuery += "      SD2.D2_COD     = '"+aCols[n,_nProd]+"'   "



				TCQUERY _cQuery  NEW ALIAS "TSD2"
				_nRec   := 0
				DbEval({|| _nRec++  })

				If _nRec <= 0 
                    lRet := .F.
					MsgAlert("Aten��o, Existem notas fiscais de origem n�o encontradas, linha "+cValToChar(i))
				ENDIF
	
				
			Endif

		Endif
	Next i


Endif

	If M->C5_TRANSP = "000163" .And. GetMv("ST_TNTCF",,.T.)//   M->C5_TPFRETE = "C"  //Chamado 005994

		cZCodM:= ' '
		If Empty(Alltrim(M->C5_XCODMUN))
			cZCodM:= SA1->A1_COD_MUN
		Else
			cZCodM:= M->C5_XCODMUN
		EndIf

		/*
		Conforme orientação do Kleber essa validação pode ser removida.
		DbSelectArea("CC2")
		CC2->(DbSetOrder(3))
		CC2->(DbGoTop())
		If CC2->(DbSeek(xFilial("CC2")+cZCodM))//CC2->(DbSeek(xFilial("CC2")+cZEstE+cZCodM))
			If  AllTrim(CC2->CC2_XSTECK)="S" .AND. ALLTRIM(SA1->A1_ATIVIDA) <> "VE" // Chamado 006516
				MsgAlert("Atenção, para essa situação a transportadora deve ser Steck")
				Return(.F.)
			EndIf
		EndIf
		*/
	EndIf

	For i:=1 To Len(aCols)

		If cEmpAnt = '01'
			aCols[i,_nPosEmi] := M->C5_EMISSAO
		EndIf
	Next i

	//Regra retirada a pedido do Francisco, ticket 20210616010208
	/*
	If M->C5_TRANSP ="000001" .And. M->C5_XTIPO = '1'  //Chamado 002987
		MsgAlert("Transportadora Steck o Tipo deve ser Entrega, verifique!")
		Return(.F.)
	EndIf
	*/

	/*
	Removido por Valdemir 24/08/2021
	If	  M->C5_XTIPO = '1'  .And. M->C5_TRANSP = '000163'
		MsgAlert("Tipo Retira não utilize TNT, verifique!")
		Return(.F.)
	EndIf
	*/

	If !Empty(M->C5_XTPFRET)

		If Empty(M->C5_TPFRETE)

			lRet := .F.
			MsgAlert("Aten��o, tipo de frete auxiliar preenchido e tipo de frete padr�o em branco, verifique!")

		Else

			Do Case
				Case M->C5_TPFRETE=="F" .And. !M->C5_XTPFRET $ "2#4"
				lRet := .F.
				MsgAlert("Aten��o, frete FOB e tipo de frete auxiliar diferente de 2 ou 4")
				Case M->C5_TPFRETE=="C" .And. !M->C5_XTPFRET $ "3"
				lRet := .F.
				MsgAlert("Aten��o, frete CIF e tipo de frete auxiliar diferente de 3")
			EndCase

		EndIf

	EndIf

	// Valdemir Rabelo Ticket: 20210811015405 - 24/08/2021
	if lRET
	   lRET := u_STVLDT01("SC5")
	endif 

	// Valdemir 19/5/2021 - Ticket: 20200825006248
	if (M->C5_TPFRETE=="C") .and. (M->C5_TRANSP = '000163') .and. (M->C5_XTIPO = '1')
	   MsgAlert("Aten��o, frete CIF com transportadora: 000163 n�o pode ser 1-Retira")
	   lRet := .F.
	Endif 
	// -------------------------------------------

	If !(SubStr(M->C5_NUM,1,1) $ "0123456789")
		lRet := .F.
		MsgAlert("Pedido come�ando com letra, entre em contato com o TI.")
	EndIf

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))

	_aItensExc := {}

	If lRet .And. M->C5_TIPO=="N" .And. Alltrim(SC5->C5_FILIAL)=="02"
		For i:=1 To Len(aCols)
			If aCols[i,Len(aHeader)+1]==.T. //Excluido
				If SC6->(DbSeek(M->C5_FILIAL+M->C5_NUM+aCols[i,_nPosItem]))
					AADD(_aItensExc,{SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->(C6_QTDVEN-C6_QTDENT),SC6->C6_PRCVEN})
				EndIf
			Else
				If SC6->(DbSeek(M->C5_FILIAL+M->C5_NUM+aCols[i,_nPosItem]))
					If SC6->C6_QTDVEN>aCols[i,_nPosQtd] //Diminuiu qtde
						AADD(_aItensExc,{SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_QTDVEN-aCols[i,_nPosQtd],SC6->C6_PRCVEN})
					EndIf
				EndIf
			EndIf
		Next i
	EndIf

	If Len(_aItensExc)>0

		_aMotRej 	:= {}
		_cTabRej   	:= 'Z7'

		aAdd(_aMotRej,' ') // CHAMADO 003971 - ROBSON MAZZAROTTO
		DbSelectArea("SX5")
		SX5->(dbSetOrder(1))
		SX5->(dbSeek(xFilial("SX5") + _cTabRej))
		Do While SX5->(!EOF()).and. xFilial("SX5") = SX5->X5_FILIAL .And. SX5->X5_TABELA  = _cTabRej
			AADD(_aMotRej,ALLTRIM(SX5->X5_CHAVE)+' - '+ALLTRIM(SX5->X5_DESCRI))
			SX5->(DbSkip())
		EndDo

        If !lFora
        
            If Len(_aMotRej) > 1

                lSaida		:= .F.
                cGetCod		:=  space(6)
                cGetMot		:=  space(70)
                cGetMDe       :=  space(110)

                While !lSaida

                    Define msDialog oDlg Title "Motivo da elimina��o" From 10,10 TO 20,65 Style DS_MODALFRAME

                    @ 000,001 Say "Motivo: " Pixel Of oDlg
                    @ 010,003 COMBOBOX cGetMot ITEMS _aMotRej SIZE 165,08 Of oDlg Pixel

                    @ 025,001 Say "Descri��o do motivo: " Pixel Of oDlg
                    @ 035,003 MsGet cGetMDe valid !empty(cGetMDe) size 200,10 Picture "@!" pixel OF oDlg

                    DEFINE SBUTTON FROM 50,20 TYPE 1 ACTION IF(!empty(cGetMot),(nOpcao:=1,lSaida:=.T.,oDlg:End()),msgInfo("Parametro em Branco","Atenção")) ENABLE OF oDlg

                    Activate dialog oDlg centered

                End
            Else
                ApMsgInfo("N�o existem Motivos de rejei��o cadastrados"+ Chr(10) + Chr(13) +;
                CHR(10)+CHR(13)+;
                "Os Itens analisados n�o ser�o rejeitados.",;
                "Rejeição")
                Return
            Endif
        
        Endif 

		_cEmail	  := GetMv("ST_WFRESID",,"renato.oliveira@steck.com.br;vanderlei.souto@steck.com.br")
		_cCopia   := ""
		_cAssunto := "[WFPROTHEUS] - O pedido "+SC5->C5_NUM+" teve itens exclu�dos"
		_aAttach  := {}
		_cCaminho := ""
		_cTipo	  := "Parcial"

		If (SC5->C5_ZFATBLQ = '3' .Or. Empty(Alltrim(SC5->C5_ZFATBLQ)))
			_cTipo := "Total"
		EndIf

		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<b>Filial: </b>'+Alltrim(SC5->C5_FILIAL)+'<br><b>Pedido: </b>'+SC5->C5_NUM
		cMsg += '<br><b>Cliente: </b>'+Alltrim(SA1->A1_NOME)
		cMsg += '<br><b>Motivo: </b>'+Alltrim(cGetMot + "--" + cGetMDe)
		cMsg += '<br><b>Tipo: </b>'+_cTipo
		cMsg += '<br><b>Usu�rio: </b>'+UsrRetName(__cUserId)+'<br><br>'

		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<TR BgColor=#FFFFFF>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Item</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Produto</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Qtde eliminada</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Valor</Font></B></TD>'
		cMsg += '</TR>'

		For _nX:=1 To Len(_aItensExc)

			cMsg += '<TR BgColor=#66FF66>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+_aItensExc[_nX][1]+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+_aItensExc[_nX][2]+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+CVALTOCHAR(_aItensExc[_nX][3])+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+CVALTOCHAR(Round(_aItensExc[_nX][3]*_aItensExc[_nX][4],2))+'</Font></B></TD>'
			cMsg += '</TR>'

		Next

		cMsg += '</Table>'
		cMsg += '</body></html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

	EndIf

	If lRet  .And. GetMv("ST_410WF",,.T.)
		_aMsg:= {}
		Aadd(_aMsg,{ "PEDIDO","PRODUTO","DESCRI","QUANTIDADE ANTERIOR" ,"QUANTIDADE NOVA"      })
		For i:=1 To Len(aCols)
			If aCols[i,Len(aHeader)+1]==.F.
				If SC6->(DbSeek(M->C5_FILIAL+M->C5_NUM+aCols[i,_nPosItem]))
					DbSelectArea("SB1")
					SB1->(DbSetOrder(1))
					SB1->(DbGoTop())
					If	SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
						If Alltrim(SB1->B1_GRUPO) $ '041/042/122/005'
							If SC6->C6_QTDVEN <> aCols[i,_nPosQtd]
								Aadd(_aMsg,{ SC6->C6_NUM,SC6->C6_PRODUTO,SC6->C6_DESCRI,Transform( SC6->C6_QTDVEN ,"@E 999,999,999")   ,Transform( aCols[i,_nPosQtd] ,"@E 999,999,999")      })
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Next i
		If Len(_aMsg)>1
			_cEmail:= GetMv("ST_4101WF",,' alex.lourenco@steck.com.br; ulisses.almeida@steck.com.br    ; filipe.nascimento@steck.com.br')
			STWF410(_aMsg,_cEmail,' ',' ')
		EndIf
	EndIf


	Restarea(aArea)

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³VLDPEDTRI	ºAutor  ³Renato Nogueira     º Data ³  19/10/15   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³Verificar se está amarrado com o outro pedido triangular    º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VLDPEDTRI()

	Local _lRet			:= .T.
	Local _cQuery		:= ""
	Local _cAlias		:= "QRYTEMP"

	_cQuery  := " SELECT * "
	_cQuery  += " FROM "+RetSqlName("SC5")+" C5 "
	_cQuery  += " WHERE C5.D_E_L_E_T_=' ' AND C5_FILIAL='"+cFilAnt+"' "
	_cQuery  += " AND C5_NUM='"+M->C5_XPEDTRI+"' "

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	If (_cAlias)->(!Eof())

		If (_cAlias)->C5_TPFRETE<>M->C5_TPFRETE
			MsgAlert("Tipo de frete diferente para nota triangular, verifique!")
			_lRet	:= .F.
		EndIf
		If (_cAlias)->C5_XTIPF=="2"
			MsgAlert("Tipo de faturamento parcial para nota triangular, verifique!")
			_lRet	:= .F.
		EndIf
		If M->C5_XTIPF=="2"
			MsgAlert("Tipo de faturamento parcial para nota triangular, verifique!")
			_lRet	:= .F.
		EndIf

	Else

		MsgAlert("Pedido de nota triangular n�o encontrado, verifique!")
		_lRet	:= .F.

	EndIf

Return(_lRet)

User Function OPER75()
	Local aArea         := GetArea()
	Local _nPosOPER     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_OPER"   })
	Local _cUser        := GetMv("ST_OPER75",,"000000")+'/000000/000645'
	Local _lRet         := .T.

	If ( Type("l410Auto") == "U" .OR. !l410Auto )//GIOVANI ZAGO ERRO NA UNICOM COM FRETE CIF 19/05/2016

		If !(__cUserID $ _cUser) .And. 	 (aCols[1,_nPosOPER] $ '75')
			MsgInfo("Usuario sem Acesso ao tipo de Opera��o 75...!!!!!!")
			_lRet:= .F.
		EndIf
	EndIf
	Return(_lRet)







	*------------------------------------------------------------------*
Static Function STWF410(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'WF Altera��o de Quantidade Grupos: 041/042/122/005'
	Local cFuncSent		:= "STWF410"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= ""
	default _cCopia  	:= ' '



	If ( Type("l410Auto") == "U" .OR. !l410Auto )



		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'

			EndIf

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)
Return()

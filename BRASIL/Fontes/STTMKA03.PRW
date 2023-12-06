#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#Define CR chr(13)+ chr(10)
#DEFINE DS_MODALFRAME 128

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STTMKA03     ºAutor  ³Renato Nogueira  º Data ³  07/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada que dispara mensagem para o user na 	  º±±
±±º          ³ tela de orçamento 		                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function STTMKA03()
	
	Local lRet			:= .T.
	Local _cOper		:= M->UA_OPER
	Local _cCliente		:= M->UA_CLIENTE
	Local _cLoja		:= M->UA_LOJA
	Local _cOrcamento   := M->UA_NUM
	Local _cEst
	Local _cMsg			:= "Favor validar essa cotacao com a Supervisao"
	Local _criadocVar 	:= GetMv( "FS_USERS" , .F. ,  )
	Local nX			:= 0
	Local _lDesc		:= .F.
	Local cGetMot 		:=  space(200)
	Local _cMsgDesc		:= ""
	Local cArea 		:= getArea()
	Local _nOpcao		:= 0
	Local _nPosULT     := aScan(aHeader, { |x| Alltrim(x[2]) == 'UB_ZLULT'   })
	Local _nPosDesc    := aScan(aHeader, { |x| Alltrim(x[2]) == 'UB_XPORDEC'   })
	
	DbSelectArea("SA1")
	dbSetOrder(1)
	DbGoTop()
	
	If DbSeek(xFilial("SA1")+_cCliente+_cLoja)
		
		If ((A1_EST="AM" .And. _cOper="1") .And. (!__cUserId$_criadocVar))
			MsgAlert(_cMsg)
			UA_OPER:="2"
		Endif
		
	Endif
	
	If AVALORES[5]>0
		MsgAlert("Favor zerar o campo Despesas da aba TOTAIS!")
		lRet	:= .F.
	ElseIf AVALORES[2]>0
		MsgAlert("Favor zerar o campo Descontos da aba TOTAIS!")
		lRet	:= .F.
	ElseIf AVALORES[4]>0
		MsgAlert("Favor zerar o campo Valor do Frete da aba TOTAIS!")
		lRet	:= .F.
	EndIf
	
	If !IsInCallStack('U_STFSVE40')
		
		For nX := 1 to Len(aCols)
			
			If !aCols[nX,len(aCols[nX])]
				
				DbSelectArea("SUB")
				DbSetOrder(1) //UB_FILIAL+UB_NUM+UB_ITEM+UB_PRODUTO
				DbSeek(xFilial("SUB")+M->UA_NUM+aCols[nX][1]+aCols[nX][2])
				
				If !SUB->(Eof())
					
					If aCols[nX][_nPosDesc]<>0 .And. aCols[nX][_nPosDesc]<>SUB->UB_XVALDES
						_lDesc := .T.
					EndIf
					If aCols[nX][_nPosULT]
						_lDesc := .T.
					EndIf
					
				ElseIf SUB->(Eof())
					
					If aCols[nX][_nPosDesc]<>0
						_lDesc := .T.
					EndIf
					
					
					If aCols[nX][_nPosULT]
						_lDesc := .T.
					EndIf
				EndIf
				
			EndIf
			
		Next
		
	ElseiF IsInCallStack('U_STFSVE40')
		
		For nX := 1 to Len(aCols)
			
			If !aCols[nX,len(aCols[nX])]
				If aCols[nX][_nPosDesc]<>0  .Or. aCols[nX][_nPosULT]     ///adicionar ultimo preço
					_lDesc := .T.
				EndIf
			EndIf
			
		Next
		
	EndIf
	
	If _lDesc   //.And. 	Iif( !IsInCallStack('U_STFSVE40')  /*.and.  !Empty(Alltrim(M->UA_XMOTDES))*/ ,.F.,.T.)
		
		If !Empty(Alltrim(M->UA_XMOTDES))
			cGetMot	:= Alltrim(M->UA_XMOTDES)+space(200-(Len(Alltrim(M->UA_XMOTDES))))
		EndIf
		Do While .t.
			
			Define msDialog oDlg Title "Motivo do Desconto/Ult.Preço" From 10,10 TO 20,100 Style DS_MODALFRAME
			
			@ 010,010 say "Motivo: "
			@ 020,010 get cGetMot  size 350,60 Picture "@!"   valid IiF(IsInCallStack('U_STFSVE40'),.t.,IiF( Len(alltrim(cGetMot)) >= 20,.t.,(msgInfo("Motivo deve Conter Minimo de 20 Caracteres!!!!","Atenção"),.f.)))
			
			DEFINE SBUTTON FROM 40,10 TYPE 1 ACTION IiF(IsInCallStack('U_STFSVE40'),(_nOpcao:=1,oDlg:End()),IiF( Len(alltrim(cGetMot)) >= 20,(_nOpcao:=1,oDlg:End()),msgInfo("Motivo deve Conter Minimo de 20 Caracteres!!!!","Atenção"))) ENABLE OF oDlg
			
			Activate dialog oDlg centered
			
			If _nOpcao = 1
				
				If !IsInCallStack('U_STFSVE40')
					_cMsgDesc		:= AllTrim(cGetMot)
					M->UA_XMOTDES	:= _cMsgDesc
					
					_cTime 			:= TIME()
					_cUser 			:= Alltrim(UsrRetName(__CUSERID))
					_cMsgDesc		:= _cUser+" - Motivo do Desconto/Ult.Preço - "+DTOC(DDATABASE)+" "+_cTime+" - "+AllTrim(cGetMot)+" [] "+CR
					M->UA_XALCMSG	:= Alltrim(_cMsgDesc)+ Alltrim(M->UA_XALCMSG)
					
				ElseiF IsInCallStack('U_STFSVE40')
					_cTime 			:= TIME()
					_cUser 			:= Alltrim(UsrRetName(__CUSERID))
					_cMsgDesc		:= _cUser+" - Motivo do Desconto/Ult.Preço - "+DTOC(DDATABASE)+" "+_cTime+" - "+AllTrim(cGetMot)+" [] "
					M->UA_XHISTOR	:= Alltrim(_cMsgDesc)+ Alltrim(M->UA_XHISTOR)
				 
				EndIf
				
				Exit
			Endif
			
		Enddo
		
 
		
	EndIf
	
	RestArea(cArea)
	
 
	
Return(lRet)

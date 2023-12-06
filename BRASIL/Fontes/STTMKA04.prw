#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

#DEFINE DS_MODALFRAME 128

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STTMKA04     �Autor  �Renato Nogueira  � Data �  07/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada que dispara mensagem para o user na 	  ���
���          � tela de pedido	 		                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function STTMKA04()

	Local lRet			:= .T.
	Local nX			:= 0
	Local _lDesc		:= .F.
	Local cGetMot 		:=  space(50)
	Local _cMsgDesc		:= ""
	Local cArea := getArea()

	If !IsInCallStack('U_STFAT15')
	
		For nX := 1 to Len(aCols)
		
			If !aCols[nX,len(aCols[nX])]
			
				DbSelectArea("SC6")
				DbSetOrder(1) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
				DbSeek(xFilial("SC6")+M->C5_NUM+aCols[nX][1]+aCols[nX][2])
			
				If !SC6->(Eof())
				
					If aCols[nX][12]<>0 .And. aCols[nX][12]<>SC6->C6_XVALDES
						_lDesc := .T.
					EndIf
				
				ElseIf SC6->(Eof())
				
					If aCols[nX][12]<>0
						_lDesc := .T.
					EndIf
				
				EndIf
			
			EndIf
		
		Next
	
	ElseiF IsInCallStack('U_STFAT15')
	
		For nX := 1 to Len(aCols)
		
			If !aCols[nX,len(aCols[nX])]
				If aCols[nX][12]<>0
					_lDesc := .T.
				EndIf
			EndIf
		
		Next
	
	EndIf

	If _lDesc
	
		Do While .t.
		
			Define msDialog oDlg Title "Motivo de desconto" From 10,10 TO 20,45 Style DS_MODALFRAME
		
			@ 010,010 say "Motivo: "
			@ 020,010 get cGetMot valid !empty(cGetMot) size 90,60 Picture "@!"
		
			DEFINE SBUTTON FROM 40,10 TYPE 1 ACTION IF( !empty(cGetMot),(nOpcao:=1,oDlg:End()),msgInfo("Parametro em Branco","Aten��o")) ENABLE OF oDlg
		
			Activate dialog oDlg centered
		
			If nOpcao = 1
			
				If !IsInCallStack('U_STFAT15')
					_cMsgDesc		:= AllTrim(cGetMot)
					M->C5_XMOTDES	:= _cMsgDesc
				ElseiF IsInCallStack('U_STFAT15')
					_cTime 			:= TIME()
					_cUser 			:= Alltrim(UsrRetName(__CUSERID))
					_cMsgDesc		:= _cUser+" - Motivo de desconto - "+DTOC(DDATABASE)+" "+_cTime+" - "+AllTrim(cGetMot)+" [] "
					M->C5_XHISTOR	+= _cMsgDesc
				//MSMM(SC5->C5_XHISTOR,,,_cMsgDesc,1,,,"SC5","C5_XHISTOR",,.T.)
				EndIf
			
				Exit
			Endif
		
		Enddo
	
	Else
	
		M->C5_XMOTDES	:= ""
	
	EndIf

	RestArea(cArea)

//�ltima altera��o em 11/07/2013

Return()

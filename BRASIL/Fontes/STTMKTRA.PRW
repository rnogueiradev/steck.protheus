#include 'Protheus.ch'
#include 'RwMake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STTMKRA	�Autor  �Renato Nogueira     � Data �  14/04/15  ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida transportadora  						  		   	���
��																		���	    					    		   	 				        
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STTMKTRA()

	Local aArea	:= GetArea()
	Local _lRet	:= .T.

	_lRet	:= U_STCHKTRP("O")

	RestArea(aArea)

Return(_lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STCHKTRP	�Autor  �Renato Nogueira     � Data �  14/04/15  ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida transportadora  						  		   	���
��																		���	    					    		   	 				        
�������������������������������������������������������������������������͹��
���Parametro � Tipo                                                       ���
�������������������������������������������������������������������������ͼ��
���Retorno   � L�gico                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STCHKTRP(_cTipo)

	Local _aArea	:= GetArea()
	Local _lRet		:= .T.

	DbSelectArea("CC2")
	CC2->(DbSetOrder(1))
	CC2->(DbGoTop())

	Do Case
	Case _cTipo=="O"
		
		If !Empty(M->UA_XCODMUN)
		
			CC2->(DbSeek(xFilial("CC2")+M->UA_ESTE+M->UA_XCODMUN))
			
			If AllTrim(M->UA_TPFRETE)=="C" .And. AllTrim(M->UA_TRANSP)<>"004064" .And. AllTrim(CC2->CC2_XSTECK)=="S" .AND. ALLTRIM(SA1->A1_ATIVIDA) <> "VE" // Chamado 006516 
				_lRet	:= .F.
				MsgAlert("Aten��o, para essa situa��o a transportadora deve ser BrasPress")
			EndIf
			
		Else

			CC2->(DbSeek(xFilial("CC2")+SA1->(A1_EST+A1_COD_MUN)))

			If AllTrim(M->UA_TPFRETE)=="C" .And. AllTrim(M->UA_TRANSP)<>"004064" .And. AllTrim(CC2->CC2_XSTECK)=="S" .AND. ALLTRIM(SA1->A1_ATIVIDA) <> "VE" // Chamado 006516
				_lRet	:= .F.
				MsgAlert("Aten��o, para essa situa��o a transportadora deve ser BrasPress")
			EndIf

		EndIf
		

	Case _cTipo=="P"
		
		If !Empty(M->C5_XCODMUN)

			CC2->(DbSeek(xFilial("CC2")+M->C5_ZESTE+M->C5_XCODMUN))

			If AllTrim(M->C5_TPFRETE)=="C" .And. AllTrim(M->C5_TRANSP)<>"004064" .And. AllTrim(CC2->CC2_XSTECK)=="S" .AND. ALLTRIM(SA1->A1_ATIVIDA) <> "VE" // Chamado 006516
				_lRet	:= .F.
				MsgAlert("Aten��o, para essa situa��o a transportadora deve ser Braspress")
			EndIf

		Else

			CC2->(DbSeek(xFilial("CC2")+SA1->(A1_EST+A1_COD_MUN)))

			If AllTrim(M->C5_TPFRETE)=="C" .And. AllTrim(M->C5_TRANSP)<>"004064" .And. AllTrim(CC2->CC2_XSTECK)=="S" .AND. ALLTRIM(SA1->A1_ATIVIDA) <> "VE" // Chamado 006516
				_lRet	:= .F.
				MsgAlert("Aten��o, para essa situa��o a transportadora deve ser Braspress")
			EndIf

		EndIf
		
	EndCase

	RestArea(_aArea)

Return(_lRet)

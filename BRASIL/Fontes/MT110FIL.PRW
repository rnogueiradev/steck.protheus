#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT110FIL     �Autor  �Joao Rinaldi    � Data �  16/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada utilizado Antes da apresenta�ao da        ���
���          � interface da Mbrowse no inicio da rotina, possibilita      ���
���          � compor um string contendo uma express�o de Filtro          ���
���          � da tabela SC1 para ser passada para MBrowse.               ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � MATA110.PRX                                                ���
���Nome      � Solicita��o de Compra                                      ���
�������������������������������������������������������������������������ͼ��
���Chamado   � 002612 - Automatizar Solicita��o de Compras                ���
���Solic.    � Juliana Queiroz - Depto. Compras                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT110FIL()
	
	//������������������������������������������������������������������������Ŀ
	//�Declara��o das Vari�veis
	//��������������������������������������������������������������������������
	Local aArea1    := GetArea()
	Local aArea2    := SC1->(GetArea())
	Local aArea3    := SAI->(GetArea())
	Local aArea4    := SY1->(GetArea())
	Local cFiltro   := ''
	Local _cFilTi   := ''
	Local _lComp    := .F.
	Local _lSolic   := .F.
	
	DbSelectArea("SY1")
	SY1->(DbSetOrder(3))//Y1_FILIAL+Y1_USER
	SY1->(DbGoTop())
	If DbSeek(xFilial("SY1")+__cUserId)
		_lComp := .T.
	Endif
	
	If !(_lComp)
		DbSelectArea("SAI")
		SAI->(DbSetOrder(2))//AI_FILIAL+AI_USER
		SAI->(DbGoTop())
		If DbSeek(xFilial("SAI")+__cUserId)
			_lSolic := .T.
		Endif
	Endif
	
	If _lComp
		cFiltro   := ''
	ElseIf _lSolic
	
		If __cUserId $ "000172" //Chamado 007399 - 000172 - willian.borges
		//000597 - rafael.reis
		//000342 - felipe.souza
		//000880 - bruno.saimon
		//001053 - paulo.sousa
		//001057 - jonas.silva              
		_cFilTi := "000597#000342#000880#001053#001057#000172"	
		cFiltro := "       C1_USER   $ '" + _cFilTi      + "'"
		cFiltro += " .AND. C1_FILIAL == '" + xFilial("SC1") + "'"
		
		
		Else
		
		cFiltro := "       C1_USER   == '" + __cUserId      + "'"
		cFiltro += " .AND. C1_FILIAL == '" + xFilial("SC1") + "'"
		
		EndIf
		

	Else
		cFiltro := "       C1_USER   == '" + "ABC"          + "'"
		cFiltro += " .AND. C1_FILIAL == '" + "99"           + "'"
	Endif
	
	
	RestArea(aArea4)
	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)
	
Return (cFiltro)

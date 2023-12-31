#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A120PIDF     �Autor  �Joao Rinaldi    � Data �  15/02/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada utilizado para filtrar as Solicita��es de ���
���          � Compras por c�digo de comprador e por Stauts Aprovado pelo ���
���          � Gestor na tela do Pedido de Compra, acionado pelo bot�o F4 ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � MATA120.PRX                                                ���
���Nome      � Pedidos de Compra                                          ���
�������������������������������������������������������������������������ͼ��
���Chamado   � 002612 - Automatizar Solicita��o de Compras                ���
���Solic.    � Juliana Queiroz - Depto. Compras                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A120PIDF()
	
	//������������������������������������������������������������������������Ŀ
	//�Declara��o das Vari�veis
	//��������������������������������������������������������������������������
	Local aArea1    := GetArea()
	Local aArea2    := SC1->(GetArea())
	Local aArea3    := SY1->(GetArea())
	Local cFiltro   := ''
	Local _lComp    := .F.
	Local _cCodComp := ''
	Local cTitle    := "Carregar Solicita��o de Compras (F4)"
	Local aRetFiltro:= {}
	
	DbSelectArea("SY1")
	SY1->(DbSetOrder(3))//Y1_FILIAL+Y1_USER
	SY1->(DbGoTop())
	If !DbSeek(xFilial("SY1")+__cUserId)
		Help( ,, 'Help',, "Usu�rio sem permiss�o para a rotina de "+cTitle+".";
			+CHR(10)+CHR(13)+;
			"A��o n�o permitida.";
			+CHR(10)+CHR(13)+;
			"Favor Verificar.",;
			1, 0 )
	Else
		_cCodComp := SY1->Y1_COD
		_lComp    := .T.
	Endif
	
	If _lComp
		cFiltro := "       C1_CODCOMP == '" + _cCodComp      + "'"
		cFiltro += " .And. C1_ZSTATUS == '3'"
		cFiltro += " .And. C1_FILIAL  == '" + xFilial("SC1") + "'"
	Else
		cFiltro := "       C1_USER   == '" + "ABC"          + "'"
		cFiltro += " .AND. C1_FILIAL == '" + "99"           + "'"
	Endif
	
	aRetFiltro := {cFiltro, }
	
	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)
	
Return (aRetFiltro)

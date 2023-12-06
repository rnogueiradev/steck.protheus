#Include "Protheus.ch"
#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT450FIM  �Autor  �Renato Nogueira     � Data �  19/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada ap�s libera��o manual financeira por pedido���
���          �					                                          ���
�������������������������������������������������������������������������͹��
���Parametros� Pedido                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno	 � Nulo	                                                      ���
������������������������������������������������������������ �������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT450FIM()
	
	Local _aArea     := GetArea()
	
	U_STOFERLG(SC5->C5_FILIAL,SC5->C5_NUM,.T.) //Carregar informa��es da oferta  log�stica - Renato Nogueira - 28/05/2014  
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	
	IF SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM ))
		
		While SC6->(!Eof()) .and. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM = SC5->C5_NUM
			U_STLOGFIN(SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRCVEN,SC6->C6_QTDVEN,.T.,.F.)
			u_LOGJORPED("SC9","3",SC6->C6_PRODUTO,SC6->C6_ITEM,SC6->C6_NUM,"","Liberacao financeira")
			SC6->(DbSkip())
		End
		
	EndIf
	
	If Empty(Alltrim(SC5->C5_PEDEXP))
		_cc5Mail := Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_EMAIL"))+" ; "+Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL"))+" ; "+Alltrim(Posicione("SA3",1,xFilial("SA3")+(Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_SUPER"))),"A3_EMAIL"))
	Else
		_cc5Mail := GetMv("ST_EXMAIL",,'' )
	EndIf
	
	u_StLibFinMail(' ','Libera��o',cusername,dtoc(date()),time(),_cc5Mail,'Libera��o')
	
	RestArea(_aArea)
	
Return()

#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA265MNU �Autor  �Renato Nogueira     � Data �  23/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para adicionar itens no menu do MTA265MNU  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

User Function MTA265MNU()

aAdd(aRotina,{"Mostra NF"  		, "U_STESTC01"   , 0 , 3, 0, .F.})
aAdd(aRotina,{"Mostra user"		, "U_STESTC02"   , 0 , 3, 0, .F.})
aAdd(aRotina,{"Filtra NF"  		, "U_STESTC03"   , 0 , 3, 0, .F.}) //Renato Nogueira - Chamado 000188 
aAdd(aRotina,{"Endere�ar NF"  	, "U_STESTA04"   , 0 , 3, 0, .F.}) 

Return()
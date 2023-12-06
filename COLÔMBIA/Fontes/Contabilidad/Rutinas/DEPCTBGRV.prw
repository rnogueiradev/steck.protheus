#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DEPCTBGRV 	�Autor  �TOTVS              �Fecha �  / /2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � PE - Impresi�n de los asientos contables -Online           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Colombia                                                   ���
�������������������������������������������������������������������������ͼ��
���Cambios   � Lucas Riva Tsuda - 16/03/2017                              ���
���		     � De acuerdo a la solicitud de Liliana Vega, se necesita que ���
���		     � primero se imprima NIIF y despu�s COLGAAP				  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DEPCTBGRV
Local aAreaCtb	:= GetArea()
Local nTpSaldo	:= 3

//If MsgYesNo("Desea Imprimir el comprobante contable?","Impresi�n de comprobante contable")
	//U_CTBI001(.T.)
	
    //��������������������������������������������������������������Ŀ
	//� Imprimir Comprobante Contable - NIIFS                        �
	//����������������������������������������������������������������
    If GetNewPar( "MV_XIMPNIF", .T.)
    	If MsgYesNo("Desea Imprimir el comprobante NIIF?","Impresi�n de comprobante contable NIIF")
    		U_CTBI001(.T.,nTpSaldo)
    	Endif
    Endif
    
    If MsgYesNo("Desea Imprimir el comprobante contable COLGAAP?","Impresi�n de comprobante contable COLGAAP")
    	U_CTBI001(.T.)
    EndIf

//Endif
RestArea(aAreaCtb)
Return

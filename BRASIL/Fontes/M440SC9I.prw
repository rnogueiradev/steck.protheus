#INCLUDE "rwmake.ch"
#include "TOTVS.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �M440SC9I   �Autor �Thiago Rocco          � Data � 13/12/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Acertando o Campo C9_ORDSEP                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo Stek                                             ��� 
���Desenvolvido       � FlexProject                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M440SC9I()

Local aArea := GetArea()
Return() // giovani desabilitei 14/10/17
//Pego o campo ORDSEP
cQuery := " SELECT * "
cQuery += " FROM "+RetSqlName("SC9")+" "
cQuery += " WHERE C9_PEDIDO ='"+SC9->C9_PEDIDO+"' AND C9_NFISCAL <> '         ' AND C9_ORDSEP <> '      ' AND D_E_L_E_T_=' ' "

If SELECT("TRB") > 0
	TRB->(DbCloseArea())
Endif
TcQuery cQuery Alias "TRB" New

//ATUALIZO O NOVO REGISTRO 
cQuery1:= "UPDATE "+RetSqlName("SC9")+" SET C9_ORDSEP ='"+TRB->C9_ORDSEP+"' WHERE C9_PEDIDO ='"+SC9->C9_PEDIDO+"' AND D_E_L_E_T_=' '"
TcSqlExec(cQuery1)   

TRB->(DbCloseArea())
RestArea(aArea)
Return



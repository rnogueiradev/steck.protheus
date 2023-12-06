#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STINIPAD	�Autor  �Renato Nogueira     � Data �  01/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado colocar o inicializador padrao dos produtos ���
���          �					 				  	 				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Caractere									              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STINIPAD(_cCampo)

Local _cConteudo	:= "" 

DO CASE

CASE _cCampo=="B1_XPESOCOL"
_cConteudo	:= (M->B1_PESO*POSICIONE("SB5",1,XFILIAL("SB5")+M->B1_COD,"B5_EAN141"))+POSICIONE("CB3",1,XFILIAL("CB3")+M->B1_XEMBCOL,"CB3_PESO")
CASE _cCampo=="B1_XPESOMAS"
_cConteudo	:= (M->B1_PESO*POSICIONE("SB5",1,XFILIAL("SB5")+M->B1_COD,"B5_EAN142"))+POSICIONE("CB3",1,XFILIAL("CB3")+M->B1_XEMBMAS,"CB3_PESO") 
ENDCASE
                        
Return(_cConteudo)
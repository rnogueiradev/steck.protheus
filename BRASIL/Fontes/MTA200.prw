#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA200    �Autor  �Everlado Gallo      � Data �  15/12/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verificar o Componente que esta sendo manipulado 			  ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ�� 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MTA200()              
Local  _cArea 	 := GetArea()
Local  _nT		 := 0
Local  _cOpc     := PARAMIXB  
Local  _lRet     := .T.		  
/*
dbSelectArea(oTree:cArqTree)

//��������������������������������������������������������������Ŀ
//�Valida se o tipo do componente esta no segundo nivel			 �
//����������������������������������������������������������������
if valtype(_cOpc) <> "U"
	If (_cOpc $ 'EA' .and. val(T_IDTREE) <> 1 ) .OR.  (_cOpc $ 'I' .and. val(T_IDTREE) <> 0 )
   		 MsgStop("Somente itens no no segundo nivel da estrutura podem ser alterados !!!")
   		 _lRet := .f.
	Endif 
Endif           

RestArea(_cArea) 	 
*/
Return _lRet
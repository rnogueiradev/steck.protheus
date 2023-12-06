#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTB350EF    �Autor  �Cristiano Pereira  � Data �  01/15/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava��o dos logs de usu�rio, na efetica��o de saldos        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CTB350EF()

   If Reclock("CT2",.F.)
       CT2->CT2_XRESP1 := cusername
       CT2->CT2_XNOME1 := UsrRetName(RetCodUsr())
       CT2->CT2_XDATAP := DdataBase
       CT2->CT2_XHORA1 := Time()
      MsUnlock()
   Endif
 
Return 

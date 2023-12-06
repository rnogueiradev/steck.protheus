#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050INC    �Autor  �Jorge Mendoza       �Fecha �  25/01/07 ���
���                       �Valid  �Karlo Zumaya        �Fecha �  11/03/09 ���
���                       �Modif  �Wheelock Orozco     �Fecha �  06/07/09 ���
���                       �Valid  �Karlo Zumaya        �Fecha �  10/07/09 ���
���                       �Modif  �Eloisa Jimenez      �Fecha �  12/06/14 ���
���                       �Modif  �EDUAR ANDIA         �Fecha �  19/07/16 ���
�������������������������������������������������������������������������͹��
���Uso       � Reporte para impresi�n de comprobantes contables.          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA050INC()


	Local lRet := .T.

	If FunName()=="FINA677" .and. Inclui
		//_cNumTit := ProxTitulo("SE2","REE")
		E2_NUM := FLF->FLF_PRESTA 

		DbSelectArea("FO7")
		DbSetOrder(1)
		If DbSeek(xFilial("FO7")+FLF->FLF_TIPO+FLF->FLF_PRESTA )
		       FO7->FO7_TITULO := FLF->FLF_PRESTA 
		Endif
   Endif

return(lRet)

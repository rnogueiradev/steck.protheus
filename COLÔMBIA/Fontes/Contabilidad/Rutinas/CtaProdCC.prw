#Include "Protheus.ch"
#Include "TopConn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CtaProdC    �Autor  �Microsiga           � Data �  11/05/15 ���
�������������������������������������������������������������������������͹��
���Desc.     � Obtiene la cuenta contable del producto de acuerdo         ���
���          � al centro de costos informado en el detalle del documento  ���
���          � de compra/devolucion en compra.              		      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CtaProdCC(ccCostos,cCodPro,cBodega)

Local cCuenta:= ""
Local aArea  := GetArea()

	DBSelectArea("SB1")
	DBSetOrder(1)
    DBSeek(xFilial("SB1")+cCodPro)  
 	

   	DBSelectArea("CTT")
   	DBSetOrder(1)
  	DBSeek(xFilial("CTT")+ccCostos)
    CtpGto:=CTT->CTT_XTPCC     

		IF '10'$CtpGto //Costos de oper	aciones de administraci�n o compras generales
			cCuenta:= SB1->B1_CONTA
		ELSEIF '01'$CtpGto //Comercial    
			cCuenta:= SB1->B1_XCONCO
		ENDIF

RestArea(aArea)

Return(cCuenta)

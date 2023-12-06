#include "protheus.ch"
#include "rwmake.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTB105OUTM�Autor  �Karlo Zumaya        � Data �  05/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  PE utilizado para mandar a llamar el Reporte de Impresion ���
���          �  del docto Contable                                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function CTB105OUTM()
Local aAreactb	:= GETAREA()
Local nTpSaldo	:= 3

If FunName() == "CTBA102"            
  /*If MsgYesNo("Desea Imprimir el comprobante contable?","Impresion de comprobante contable") 
	U_CTBI001(.T.)                                      
  Endif*/
  
  	//��������������������������������������������������������������Ŀ
	//� Imprimir Comprobante Contable - NIIFS                        �
	//����������������������������������������������������������������
    If GetNewPar( "MV_XIMPNIF", .T.)
    	If MsgYesNo("�Desea Imprimir el comprobante NIIF?","Impresi�n de comprobante contable NIIF")
    		U_CTBI001(.T.,nTpSaldo)
    	Endif
    Endif
    
    If MsgYesNo("�Desea Imprimir el comprobante contable COLGAAP?","Impresi�n de comprobante contable COLGAAP")
    	U_CTBI001(.T.)
    EndIf  
    
Endif       
                   
RestArea(aAreactb)
Return  .T.     
                      


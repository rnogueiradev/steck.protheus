#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FISTRFNFE� Autor � Everson Santana        � Data �26/07/18  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria o bot�o na tela de Transmiss�o do Factura para         ���
���          � realizar a impress�o									      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FISTRFNFE()

AAdd( aRotina, {"Imprimir Factura"	,"U_ARFAT04"    ,0,2,0 ,NIL}    )
AAdd( aRotina, {"Consultar Factura"	,"MC090Visual"  ,0,2,0 ,NIL}    )
AAdd( aRotina, {"Monitor Steck"	,"U_ARFAT05(1)"  ,0,2,0 ,NIL}    )
AAdd( aRotina, {"Transmision Steck"	,"U_ARFAT05(2)"  ,0,2,0 ,NIL}    )

Return
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FISTRFREM� Autor � Everson Santana        � Data �24/07/18  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria o bot�o na tela de Transmiss�o do Remito para         ���
���          � realizar a impress�o									      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FISTRFREM()

AAdd( aRotina, {"Imprimir Remito"		,"U_ARFAT03A"   ,0,2,0 ,NIL}    )
AAdd( aRotina, {"Incluir Placa"			,"U_ARFATVEI"   ,0,2,0 ,NIL}    )
AAdd( aRotina, {"Cambio Fecha de Emisi�n","U_ARFATEM"   ,0,2,0 ,NIL}    )
AAdd( aRotina, {"Listado de Remitos"	,"U_ARSTREST01" ,0,2,0 ,NIL}    )
AAdd( aRotina, {"Consultar Remito"		,"MC090Visual"  ,0,2,0 ,NIL}    )
AAdd( aRotina, {"Transmisi�n Masiva"	,"U_STACO310"   ,0,2,0 ,NIL}    )

Return

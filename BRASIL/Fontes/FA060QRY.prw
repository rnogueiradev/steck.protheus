#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA060QRY  �Autor  �Cristiano Pereira   � Data �  02/08/19 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na gera��o do border�                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA060QRY()

Local _cQrySE1 := ""


_cQrySE1 := "  NOT EXISTS ( "
_cQrySE1 += "     SELECT SA1.A1_FILIAL AS FILIAL, "
_cQrySE1 += "            SA1.A1_COD    AS COD  ,  "
_cQrySE1 += "            SA1.A1_LOJA   AS LOJA    "
_cQrySE1 += "     FROM "+RetSqlName("SA1")+" SA1  "
_cQrySE1 += "     WHERE   "
_cQrySE1 += "           SA1.A1_COD    = E1_CLIENTE AND "
_cQrySE1 += "           SA1.A1_LOJA   = E1_LOJA    AND "
_cQrySE1 += "           SA1.D_E_L_E_T_ <>'*'           AND "
_cQrySE1 += "           SA1.A1_XCARTE = 'S'    )            " 


return(_cQrySE1)
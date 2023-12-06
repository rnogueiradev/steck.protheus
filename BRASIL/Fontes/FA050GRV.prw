#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100GE2   �Autor  �Cristiano Pereira � Data �  08/11/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada no momento da grava��o do t�tulo a pagar   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA050GRV()


    Local aAreaSE2 := GetArea("SE2")


    If Rtrim(SE2->E2_TIPO)=="PA" .And.  SE2->E2_SALDO == SE2->E2_VALOR
       SE2->E2_EMIS1 := SE2->E2_VENCREA
    Endif
    RestArea(aAreaSE2)
Return
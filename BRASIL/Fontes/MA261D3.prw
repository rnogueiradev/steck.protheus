#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA261D3	�Autor  �Renato Nogueira     � Data �  05/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada utilizado para adicionar campo na rotina   ���
���          �de transfer�ncia modelo 2    		  	 				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum										              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA261D3()

Local _aArea  	:= GetArea()
Local _nPosObs	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_XOBS"})

RecLock("SD3",.F.)
SD3->D3_XOBS     := aCols[n,_nPosObs]
MsUnlock()

U_STFSC10J()  // rotina para realizar a distribui��o de saldo para os documento com pendencia no DP e/ou faltas

Restarea(_aArea)

Return
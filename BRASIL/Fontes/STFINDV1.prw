#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � STFINDV1 � Autor � RGV Solucoes          � Data �07/Fev/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calculo do deposito identificado bradesco                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function STFINDV1(cCodigo)

Local cRet := ""
Local nCodOri := 0
Local nDV := 0

nCodOri := Val(cCodigo)
nDV := nCodOri-(NoRound(nCodOri/7,0)*7)
cRet := CValToChar(nCodOri)+"-"+CValToChar(nDV)+"  "

Return(cRet)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � STFINDV1 � Autor � RGV Solucoes          � Data �07/Fev/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza o campo do deposito identificado bradesco         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function STFINDV2()

DbSelectArea("SA1")
SA1->(DbSetorder(1))
SA1->(DbGoTop())

While SA1->(!Eof())
	Reclock("SA1",.F.)
	SA1->A1_XIDBRAD := U_STFINDV1(SA1->A1_COD)
    MsUnlock()
    SA1->(DbSkip())
End

MsgAlert("Processo Finalizado!")

Return(cRet)
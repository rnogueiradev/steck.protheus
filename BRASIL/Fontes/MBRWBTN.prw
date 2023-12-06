#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MBRWBTN   �Autor  �Microsiga           � Data �  02/22/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada ativado ao pressionar qualquer botao da    ���
���          �MarkBrow ou MBrowse                                         ���
���          �                                                            ���
���Parametros�PARAMIXB[1] = ALIAS                                         ���
���          �PARAMIXB[2] = RECNO                                         ���
���          �PARAMIXB[3] = BOTAO                                         ���
���          �                                                            ���
���          �RETORNO     = LOGICO                                        ��� 
�������������������������������������������������������������������������͹��
���Uso       � GENERICO                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MBRWBTN()

	Local cAlias	:= Paramixb[1]
	Local nRec		:= Paramixb[2]
	Local nBotao	:= Paramixb[3]
	Local lRet		:= .T.
 
	If !('STREGDES'  $ FunName()) //giovani zago sei la isso nao esta funcionando no mvc
		lRet := U_STFSVE74(cAlias, nRec, nBotao)
	EndIf
Return lRet
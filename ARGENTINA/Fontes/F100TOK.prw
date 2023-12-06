#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F100TOK     �Autor  �Cristiano Pereira � Data �  10/31/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o no Tudo OK da mov bancaria financeira             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F100TOK()

Local _lRet := .T.

If Substr(cNumEmp,01,02) =="03"
	
	If Rtrim(M->E5_BANCO)=="200" .And. Empty(M->E5_CCUSTO)
		MsgInfo("Informe o centro de custo.")
		_lRet := .F.
	Endif
	
ElseIf Substr(cNumEmp,01,02) =="01"
	
	If RTrim(M->E5_BANCO)=="716" .And. Empty(M->E5_CCUSTO)
		MsgInfo("Informe o centro de custo.")
		_lRet := .F.
	Endif
	
ElseIf Substr(cNumEmp,01,02) =="07"
	
	If RTrim(M->E5_BANCO)=="BCJ" .And. Empty(M->E5_CCUSTO)
		MsgInfo("Informe o centro de custo.")
		_lRet := .F.
	Endif
	
	
Endif

return(_lRet)

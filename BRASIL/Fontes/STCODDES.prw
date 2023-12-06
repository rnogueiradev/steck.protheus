#include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STCODDES  �Autor  �Renato Nogueira     � Data �  05/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Este programa tem por objetivo bloquear o uso de codigos    ���
���          �ha mais de dois anos                                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STCODDES(_cCod)

	Local _lRet	:= .T.

	If IsInCallStack("U_STTRANSIBL")
		Return(.T.)
	EndIf

	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+_cCod)

	If !SB1->(EOF())
	
		If AllTrim(SB1->B1_XDESAT)=="2"
			_lRet	:= .F.
			MsgAlert("Aten��o, este c�digo foi desativado pelo departamento de Marketing")
		EndIF
		
		If AllTrim(FUNNAME())=="MATA410"
			If cEmpAnt=="03" .And. Empty(SB1->B1_DCRE) .And. M->C5_TIPO=="N" .And. SA1->A1_EST<>"AM" //Chamado 2178
				_lRet	:= .T.//Chamdo 002347 - alterado de .F. para .T.
				MsgAlert("Aten��o, venda para fora do estado e produto sem DCRE preenchida, procure o depto Fiscal!")
			EndIf
		EndIf
	
	EndIf

	If AllTrim(FUNNAME())=="MATA410"
		If M->C5_CLIENTE=='033467' //Chamado 000774 - liberar produtos desativados quando for opera��o entre filiais
			_lRet	:= .T.
		EndIf
	EndIf
	
	If SA1->A1_COD=="008724" .And. SA1->A1_LOJA $ "02#03#04#05" .And. Len(aCols)>30 .And. cEmpAnt=="01" //Chamado 002563
		_lRet	:= .F.
		MsgAlert("Aten��o, n�o � permitido colocar mais de 30 itens para esse cliente, verifique!")
	EndIf 

Return(_lRet)

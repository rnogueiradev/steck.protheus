#INCLUDE "PROTHEUS.CH"

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MT110GRV.prw   | AUTOR | Ricardo Posman     | DATA | 08/12/2007 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | PE na gravacao da Solicitacao de Compra para Calcular data      |//
//|           | necessidade (BUDGET) conforme Motivo de Compra                  |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

User Function MT110GRV()
	Local lRet 		:= .T.
	Local _cNum		:= SC1->C1_NUM
	Local _aArea    := GetArea()
	Local _cod		:= CCODCOMPR
	Local _cMsgSc 	:= ''
	Local _cInfo  	:= ''
	Local _cAltSC	:= .T.
 

	/*
	�������������������������������������������������������������������������ͼ��
	���Chamado   � 002612 - Automatizar Solicita��o de Compras                ���
	���Solic.    � Juliana Queiroz - Depto. Compras                           ���
	���Descr.    � O Comprador da SC ser� definido em rotina espec�fica       ���
	�������������������������������������������������������������������������ͼ��
	*/
	If SC1->C1_ZSTATUS = '1'
		Reclock("SC1",.F.)
		SC1->C1_COMPSTK   := ''//_cod
		SC1->C1_CODCOMP   := ''
		SC1->(MsUnlock())

		If INCLUI
			_cInfo := 'Inclu�do'
		ElseIf ALTERA
			_cInfo := 'Alterado'
		Endif

		_cMsgSc += "===================================" +CHR(13)+CHR(10)
		_cMsgSc += "Item de Solicita��o de Compra "+_cInfo+" por: " +CHR(13)+CHR(10)
		_cMsgSc += "Usu�rio: "+cUserName+CHR(13)+CHR(10)
		_cMsgSc += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)

		Reclock("SC1",.F.)
		SC1->C1_USER    := __cUserId
		SC1->C1_SOLICIT := UsrRetName(RetCodUsr())
		SC1->C1_ZLOG    := SC1->C1_ZLOG + CHR(13)+ CHR(10) + _cMsgSc
		SC1->(MsUnlock())		
	Endif

	RestArea(_aArea)

Return(lRet)

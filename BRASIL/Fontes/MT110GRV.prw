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
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
	±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
	±±ºDescr.    ³ O Comprador da SC será definido em rotina específica       º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	*/
	If SC1->C1_ZSTATUS = '1'
		Reclock("SC1",.F.)
		SC1->C1_COMPSTK   := ''//_cod
		SC1->C1_CODCOMP   := ''
		SC1->(MsUnlock())

		If INCLUI
			_cInfo := 'Incluído'
		ElseIf ALTERA
			_cInfo := 'Alterado'
		Endif

		_cMsgSc += "===================================" +CHR(13)+CHR(10)
		_cMsgSc += "Item de Solicitação de Compra "+_cInfo+" por: " +CHR(13)+CHR(10)
		_cMsgSc += "Usuário: "+cUserName+CHR(13)+CHR(10)
		_cMsgSc += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)

		Reclock("SC1",.F.)
		SC1->C1_USER    := __cUserId
		SC1->C1_SOLICIT := UsrRetName(RetCodUsr())
		SC1->C1_ZLOG    := SC1->C1_ZLOG + CHR(13)+ CHR(10) + _cMsgSc
		SC1->(MsUnlock())		
	Endif

	RestArea(_aArea)

Return(lRet)

/* 
Ação.........: WebService de Consulta de eliminação de resíduo do pedido de venda na indústria
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 06/12/2022
Chamado......: 20220727014715 - Integração de Cotações
*/
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

WSRESTFUL EliminaResInd DESCRIPTION "Eliminação de Resíduo de Pedido de Venda na Indústria"
	WSMETHOD POST DESCRIPTION "Eliminação de Resíduo de Pedido de Venda na Indústria" WSSYNTAX "/rest/EliminaResInd"
END WSRESTFUL

/*
Endereço para WebService Desenvolvimento
http://rest-p12.steck.com.br:9997/rest/conscotacoes -> homologação
*/

WSMETHOD POST WSSERVICE EliminaResInd

	LOCAL nX     := 0
	LOCAL _lRet  := .F.
	LOCAL _cJson := ""
	LOCAL _cEmpAnt  := ""
	LOCAL _cFilAnt  := ""
	LOCAL _cRetorno := ""
	LOCAL lContinua := .F.
	PRIVATE LBLOQUEADOS := .F.
	oJson  := NIL
	oItens := NIL

	::SetContentType("application/json")
	_cJson := StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	_lRet := FWJsonDeserialize(FwNoAccent(_cJson),@oJson)

/*
Valida o Json recebido.
*/

	IF _lRet = .F.
		_cRetorno := '{"ERRO":"DESCRET":"ERRO AO CONVERTER O JSON"}
		::SetResponse(_cRetorno)
		RETURN .T.
	ENDIF

	_cEmpAnt := oJson:EMPRESA
	_cFilAnt := oJson:FILIAL
	oItens := oJson:ITENS

    //RpcClearEnv()
	//RpcSetType(3)
	//RpcSetEnv(_cEmpAnt,_cFilAnt,,,"FAT")	


/*
Posiciona na SC5 para efetuar algumas validações prévias
*/
	SC5->(DBSETORDER(1))
	IF SC5->(DBSEEK(XFILIAL("SC5")+oJson:PEDIDO))
        lContinua:=.T.
		//// Pedido de Venda Faturado Totalmente
		IF SC5->C5_ZFATBLQ = '1' .AND. lContinua = .T.
			lContinua := .F.
		ENDIF

		//// Pedido de Venda Eliminado por Resíduo
		IF ('XXXX' $ SC5->C5_NOTA) .AND. (SC5->C5_ZFATBLQ $ '1/2') .AND. lContinua = .T.
			lContinua:=.F.
		ENDIF

		//// Pedido de Venda Cancelado
		IF ('XXXX' $ SC5->C5_NOTA).AND. (SC5->C5_ZFATBLQ = '3' .OR. EMPTY(ALLTRIM(SC5->C5_ZFATBLQ))) .AND. lContinua = .T.
			lContinua:=.F.
		ENDIF

	ENDIF

/*
Passou pelas validações da SC5 
*/
	IF lContinua = .T.

		Begin Transaction
		
			FOR nX := 1 TO LEN(oItens)
				SC6->(DBSETORDER(1))
				SC6->(DBGOTO(VAL(oItens[nX]:RECNO)))

				IF !SC6->(EOF()) .AND. AllTrim(SC6->C6_BLQ)<>'R'

				   SC9->(DBSETORDER(1))
				   IF SC9->(DBSEEK(XFILIAL("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
					   WHILE SC9->(!EOF() .AND. XFILIAL("SC9")+SC9->C9_PEDIDO+SC9->C9_ITEM == XFILIAL("SC6")+SC6->C6_NUM+SC6->C6_ITEM)

					      //// Pedido de Venda em Separação pela Expedição.
						  IF !EMPTY(SC9->C9_ORDSEP) .AND. EMPTY(SC9->C9_NFISCAL)
						  	 lContinua:=.F.
						  ENDIF
					   	  SC9->(DBSKIP())
					   ENDDO
				   ENDIF


				   IF !EMPTY(SC5->C5_PEDEXP) .AND. SuperGetMv("MV_EECFAT") // Integracao SIGAEEC
					  IF FindFunction("EECZERASALDO")
						 lContinua := EECZeraSaldo(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
					  ELSE
						 lContinua := EECCancelPed(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
					  ENDIF
				   ENDIF

				   lContinua := ExecBlock("M410VRES",.F.,.F.,{VAL(oItens[nX]:RECNO)})

				   IF lContinua  = .T. .AND. (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0
					  MaResDoFat(,.T.,.F.)

					  //// Grava a Data da Eliminação do Pedido de Venda na Indústria
					  SC6->(RECLOCK("SC6",.F.))
					  SC6->C6_QTDEMP 	 := 0
					  SC6->C6_XDTRES   := Date()
					  SC6->C6_XUSRRES  := __cUserId
					  SC6->(MSUNLOCK())
					  SC6->(MaLiberOk({SC5->C5_NUM},.T.))

				   ENDIF
			    ENDIF
			NEXT

			If AllTrim(SC6->C6_BLQ)=="R" //Verifica se foi eliminado com sucesso
				lContinua := .T.
			ELSE 
                DisarmTransaction()
				lContinua := .F.
			EndIf

		End Transaction

	ENDIF


RETURN lContinua

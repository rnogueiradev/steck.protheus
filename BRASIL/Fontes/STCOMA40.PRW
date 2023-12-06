#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} STCOMA40
@name STCOMA40
@type User Function
@desc confirma visualização do pedido de compra
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STCOMA40(_cXml)

	Local cError 	:= ""
	Local cWarning	:= ""
	Local _cEmp		:= ""
	Local _cFil		:= ""
	Local _cXmlResp := ""
	Local _cDesc	:= ""
	Local _cDesen   := ""
	Local _cQuery1  := ""
	Local _cAlias1  := ""

	ConOut(CRLF + "[STCOMA40]["+ FWTimeStamp(2) +"] Inicio da confirmação de pedido.")

	Conout("[STCOMA40]["+ FWTimeStamp(2) +"] - XML recebido - "+_cXml)

	oXml := XmlParser( _cXml, "_", @cError, @cWarning )

	If  Valtype(oXml) != 'O' .or. !empty(cError)
		Conout("[STCOMA40]["+ FWTimeStamp(2) +"] - Erro no parser do xml - "+cError)
		Return("")
	EndIf

	_cEmp 	:= oXml:_DADOS:_CEMP:TEXT
	_cFil 	:= oXml:_DADOS:_CFIL:TEXT
	_cPed	:= oXml:_DADOS:_CPEDIDO:TEXT

	RpcSetType(3)
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	_cAlias1 := GetNextAlias()
	
	_cQuery1 := " SELECT C7.R_E_C_N_O_ RECSC7
	_cQuery1 += " FROM "+RetSqlName("SC7")+" C7
	_cQuery1 += " WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='"+_cFil+"' AND C7_NUM='"+_cPed+"'
	
	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SC7")

	While (_cAlias1)->(!Eof())
	
		SC7->(DbGoTop())
		SC7->(DbGoTo((_cAlias1)->RECSC7))
		If SC7->(!Eof())
			//SC7->(RecLock("SC7",.F.))
			//SC7->C7_XVIS := "S"
			//SC7->(MsUnLock())
		EndIf
	
		(_cAlias1)->(DbSkip())
	EndDo
	
	Conout("[STCOMA40]["+ FWTimeStamp(2) +"] - Fim da confirmação do pedido.")

Return(_cXmlResp)
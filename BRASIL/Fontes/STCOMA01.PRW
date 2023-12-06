#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} STCOMA01
@name STCOMA01
@type User Function
@desc retornar dados do produtos
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STCOMA01(_cXml)

	Local cError 	:= ""
	Local cWarning	:= ""
	Local _cEmp		:= ""
	Local _cFil		:= ""
	Local _cXmlResp := "<DADOS>"
	Local _cDesc	:= ""
	Local _cDesen   := ""
	
	ConOut(CRLF + "[STCOMA01]["+ FWTimeStamp(2) +"] Inicio da consulta de produto.")

	Conout("[STCOMA01]["+ FWTimeStamp(2) +"] - XML recebido - "+_cXml)

	oXml := XmlParser( _cXml, "_", @cError, @cWarning )

	If  Valtype(oXml) != 'O' .or. !empty(cError)
		Return("")
	EndIf	

	_cEmp 	:= oXml:_DADOS:_CEMP:TEXT
	_cFil 	:= oXml:_DADOS:_CFIL:TEXT
	_cProd	:= oXml:_DADOS:_CPROD:TEXT
	
	Reset Environment

	RpcSetType(3)
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	If SB1->(DbSeek(xFilial("SB1")+_cProd))
		_cDesc 	:= SB1->B1_XDESEXD
		_cDesen := SB1->B1_XDESENH
	EndIf

	_cXmlResp += "<DESC>"+_cDesc+"</DESC>"
	_cXmlResp += "<DESEN>"+_cDesen+"</DESEN>"
	_cXmlResp += "</DADOS>"
	
	Conout("[STCOMA01]["+ FWTimeStamp(2) +"] - "+_cXmlResp)
	Conout("[STCOMA01]["+ FWTimeStamp(2) +"] - Fim da consulta de produto.")

Return(_cXmlResp)
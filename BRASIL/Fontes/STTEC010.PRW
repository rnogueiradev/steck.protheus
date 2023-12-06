#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "tbiconn.ch"

/*/{Protheus.doc} STTEC010
@name STTEC010
@type User Function
@desc consultar chamados 
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STTEC010(_cXml)

	Local _cEmp  	:= "01"
	Local _cFil	 	:= "01"
	Local cError 	:= ""
	Local cWarning	:= ""
	Local cXmlResp  := ""
	Local _cQuery1  := ""
	Local _cAlias1  := ""
	Local _cTipo	:= ""
	Local _nTotal	:= 0
	Local _nX		:= 0
	Default _cXml	:= ""

	Reset Environment

	RpcSetType(3)
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	_cAlias1  := GetNextAlias()

	ConOut(CRLF + "[STTEC010]["+ FWTimeStamp(2) +"] Inicio da consulta de chamados.")

	Conout("[STTEC010]["+ FWTimeStamp(2) +"] - XML recebido - "+_cXml)

	oXml := XmlParser( _cXml, "_", @cError, @cWarning )

	If  Valtype(oXml) != 'O' .or. !empty(cError)
		ConOut("[STTEC010] - "+DTOC(Date())+" - "+Time()+" - Falha ao fazer o parser do XML: "+ cError + cWarning)
		cXmlResp += SetResp1("00","Problema ao converter o XML")
		Return(cXmlResp)
	EndIf

	_cTipo 	:= oXml:_CHAMADOS:_TIPO:TEXT

	_cQuery1 := " SELECT ANOMES, SUM(ABERTOS) ABERTOS, SUM(FECHADOS) FECHADOS, SUM(EM_ABERTO) EM_ABERTO
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT SUBSTR(Z0_DTSOLIC,1,6) ANOMES, COUNT(*) ABERTOS, 0 FECHADOS, 0 EM_ABERTO
	_cQuery1 += " FROM "+RetSqlName("SZ0")+" Z0
	_cQuery1 += " WHERE Z0.D_E_L_E_T_=' ' AND SUBSTR(Z0_DTSOLIC,1,4)='"+SubStr(DTOS(Date()),1,4)+"' AND Z0_STATUS NOT IN ('9')
	_cQuery1 += " GROUP BY SUBSTR(Z0_DTSOLIC,1,6)
	_cQuery1 += " UNION
	_cQuery1 += " SELECT SUBSTR(Z0_DTENC,1,6) ANOMES, 0 ABERTOS, COUNT(*) FECHADOS, 0 EM_ABERTO
	_cQuery1 += " FROM "+RetSqlName("SZ0")+" Z0
	_cQuery1 += " WHERE Z0.D_E_L_E_T_=' ' AND SUBSTR(Z0_DTENC,1,4)='"+SubStr(DTOS(Date()),1,4)+"' AND Z0_DTENC<>' '  
	_cQuery1 += " GROUP BY SUBSTR(Z0_DTENC,1,6)
	_cQuery1 += " UNION 
	_cQuery1 += " SELECT SUBSTR(Z0_DTSOLIC,1,6) ANOMES, 0 ABERTOS, 0 FECHADOS, COUNT(*) EM_ABERTO
	_cQuery1 += " FROM "+RetSqlName("SZ0")+" Z0
	_cQuery1 += " WHERE Z0.D_E_L_E_T_=' ' AND SUBSTR(Z0_DTSOLIC,1,4)='"+SubStr(DTOS(Date()),1,4)+"' AND Z0_DTENC=' ' AND Z0_STATUS NOT IN ('1','5','9') 
	_cQuery1 += " GROUP BY SUBSTR(Z0_DTSOLIC,1,6)
	_cQuery1 += " )
	_cQuery1 += " GROUP BY ANOMES
	_cQuery1 += " ORDER BY ANOMES

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	For _nX:=1 To 12

		_cAnoMes := SubStr(DTOS(Date()),1,4)+PADL(CVALTOCHAR(_nX),2,"0")
		_lAchou  := .F.

		(_cAlias1)->(dbGoTop())
		While (_cAlias1)->(!Eof())
			If AllTrim((_cAlias1)->ANOMES)==AllTrim(_cAnoMes)
				_lAchou := .T.
				If _cTipo=="1"
					cXmlResp += CVALTOCHAR((_cAlias1)->FECHADOS)
				ElseIf _cTipo=="2"
					cXmlResp += CVALTOCHAR((_cAlias1)->ABERTOS)
				ElseIf _cTipo=="3"
					cXmlResp += CVALTOCHAR((_cAlias1)->EM_ABERTO)
				EndIf
			EndIf
			(_cAlias1)->(DbSkip())
		EndDo

		If !_lAchou
			cXmlResp += "0"
		EndIf
		If _nX<12
			cXmlResp += ","
		EndIf

	Next

	ConOut(CRLF + "[STTEC010]["+ FWTimeStamp(2) +"] Fim da consulta de chamados.")

Return(cXmlResp)

/*/{Protheus.doc} SetResp1
@name SetResp1
@type Static Function
@desc Setar respostar de retorno do WS
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function SetResp1(cCode,cText)

	Local cRetorno := ""
	Default cCode := "00"
	Default cText := ""

	cRetorno := '<?xml version="1.0" encoding="utf-8"?>'+ CRLF
	cRetorno += '<result>'+ CRLF
	cRetorno += '	<code>'+ cCode +'</code>'+ CRLF
	cRetorno += '	<text>'+ cText +'</text>'+ CRLF
	cRetorno += '	<time>'+ FWTimeStamp(3) + '</time >'+ CRLF
	cRetorno += '</result>'+ CRLF

Return(cRetorno)
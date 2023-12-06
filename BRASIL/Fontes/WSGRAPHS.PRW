#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"

/*/{Protheus.doc} WSGRAPHS
@name WSGRAPHS
@type User Function
@desc estrutura para consultar informações para alimentar os graficos
@author Renato Nogueira
@since 17/05/2018
/*/

WSSERVICE WSGRAPHS DESCRIPTION "Serviço para realizar consultas dos gráficos"

	WSDATA cXmlEnv			AS STRING
	WSDATA cXmlRet			AS STRING

	WSMETHOD GetChamados DESCRIPTION "Método para realizar consulta de chamados"
	WSMETHOD GetMetas DESCRIPTION "Método para consultar as metas dos vendedores"

ENDWSSERVICE

WSMETHOD GetChamados WSRECEIVE cXmlEnv WSSEND cXmlRet WSSERVICE WSGRAPHS

	::cXmlRet := U_STTEC010(::cXmlEnv)

Return .T.

WSMETHOD GetMetas WSRECEIVE cXmlEnv WSSEND cXmlRet WSSERVICE WSGRAPHS

	Local _cEmp  	:= "01"
	Local _cFil	 	:= "02"
	Local cError 	:= ""
	Local cWarning	:= ""
	Local cXmlResp  := ""
	Local _cQuery1  := ""
	Local _cAlias1  := ""
	Local _cTipo	:= ""
	Local _nTotal	:= 0
	Local _nX		:= 0

	Reset Environment

	RpcSetType(3)
	RpcSetEnv(_cEmp,_cFil,,,"FAT")
	
	Conout("[WSGRAPHS]"+FWTimeStamp(2)+" - Inicio do processamento")

	_cAlias1  := GetNextAlias()

	cXmlResp := "<dados>"

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SA3")+" A3
	_cQuery1 += " WHERE A3.D_E_L_E_T_=' ' AND SUBSTR(A3_COD,1,1) IN ('E','R','S','Z')
	_cQuery1 += " AND A3_XPORT='S'

	If !Empty(GetMv("ST_VENDATU"))
		_cQuery1 += " AND A3_COD>='"+GetMv("ST_VENDATU")+"'
	EndIf	

	_cQuery1 += " ORDER BY A3_COD

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		(_cAlias1)->(DbSkip()) //Verifica proximo vendedor
		If (_cAlias1)->(Eof())
			PutMv("ST_VENDATU","")
		Else
			PutMv("ST_VENDATU",(_cAlias1)->A3_COD)
		EndIf
		(_cAlias1)->(dbGoTop())
	EndIf

	cXmlResp += "<vendedor>
	cXmlResp += "<codigo>"+(_cAlias1)->A3_COD+"</codigo>
	cXmlResp += "<nome>"+UPPER((_cAlias1)->A3_NOME)+"</nome>
	cXmlResp += "</vendedor>

	If SubStr((_cAlias1)->A3_COD,1,1)=="S"
		cXmlResp += U_STWSFT10((_cAlias1)->A3_COD,2)
	ElseIf SubStr((_cAlias1)->A3_COD,1,1)=="Z" //exportacao e campanhas
		If AllTrim((_cAlias1)->A3_COD)=="Z00001"
			cXmlResp += U_STWSFT10((_cAlias1)->A3_COD,3)
		Else //Campanhas
			cXmlResp += U_STWSFT20((_cAlias1)->A3_COD)
		EndIf
	Else
		cXmlResp += U_STWSFT10((_cAlias1)->A3_COD,1)
	EndIf

	cXmlResp += "</dados>"

	cXmlResp := TIRAESP(cXmlResp)

	Conout(cXmlResp)
	
	Conout("[WSGRAPHS]"+FWTimeStamp(2)+" - Fim do processamento")

	::cXmlRet := cXmlResp

Return .T.

Static Function TIRAESP(_cRec)

	Local _cResp 	:= ""
	Default _cRec 	:= ""

	_cResp := strtran (_cRec, "&", "E")
	_cResp := strtran (_cRec, "Ç", "C")
	_cResp := strtran (_cRec, "Õ", "O")
	_cResp := strtran (_cRec, "&", "")
	_cResp := strtran (_cRec, "&", "")
	_cResp := strtran (_cRec, "&", "")

Return(_cResp)

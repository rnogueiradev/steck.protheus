#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"

/*====================================================================================\
|Programa  | WSVTCIPA         | Autor | Renato Nogueira            | Data | 23/10/2019|
|=====================================================================================|
|Descrição | Webservice para realizar consultas de RI						          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck..                                                    	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSSERVICE WSVTCIPA DESCRIPTION "Serviço para comunicações com a aplicação de votação CIPA"

	WSDATA _cXmlRec		AS STRING
	WSDATA _cXmlRet		AS STRING

	WSMETHOD ConsultaRI DESCRIPTION "Método que faz a consulta de RI do funcionário"

ENDWSSERVICE

WSMETHOD ConsultaRI WSRECEIVE _cXmlRec WSSEND _cXmlRet WSSERVICE WSVTCIPA

	Local _cQuery1 	:= ""
	Local _cAlias1  := ""
	Local _cXml		:= "<consultari>"

	Reset Environment

	cAviso := ""
	cErro  := ""

	oXml := XmlParser(::_cXmlRec,'_',@cErro,@cAviso)
	
	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"FAT")

	_cCPF := oXml:_CONSULTARI:_CPF:TEXT
	_cNasc := oXml:_CONSULTARI:_DTNASC:TEXT

	_cAlias1  := GetNextAlias()

	_cQuery1 := " SELECT '01' EMP, RA_FILIAL, RA_NOME, RA_CIC, RA_NASC
	_cQuery1 += " FROM SRA010 RA
	_cQuery1 += " WHERE RA.D_E_L_E_T_=' ' AND RA_DEMISSA=' ' AND RA_CIC='"+AllTrim(_cCPF)+"' AND RA_NASC='"+DTOS(CTOD(_cNasc))+"'
	_cQuery1 += " UNION ALL
	_cQuery1 += " SELECT '03' EMP, RA_FILIAL, RA_NOME, RA_CIC, RA_NASC
	_cQuery1 += " FROM SRA030 RA
	_cQuery1 += " WHERE RA.D_E_L_E_T_=' ' AND RA_DEMISSA=' ' AND RA_CIC='"+AllTrim(_cCPF)+"' AND RA_NASC='"+DTOS(CTOD(_cNasc))+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		_cXml += "<status>01</status>
		_cXml += "<nome>"+AllTrim((_cAlias1)->RA_NOME)+"</nome>
		_cXml += "<empresa>"+AllTrim((_cAlias1)->(EMP+RA_FILIAL))+"</empresa>
	Else
		_cXml += "<status>00</status>
		_cXml += "<nome>Não encontrado</nome>
		_cXml += "<cpf>Não encontrado</cpf>
	EndIf

	_cXml += "</consultari>
	
	::_cXmlRet := _cXml

Return .T.

#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"

/*/{Protheus.doc} STESTA05
@name STESTA05
@type User Function
@desc consulta de estoque VFE
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STESTA05(_cXml)

	Local _cEmp  	:= "11"
	Local _cFil	 	:= "01"
	Local cError 	:= ""
	Local cWarning	:= ""
	Local cXmlResp  := ""
	Local _aProdutos:= {}
	Local _nX := 0 
	/*
	//_cXml := ' <?xml version="1.0" encoding="utf-8" ?>
	_cXml := " <INTERFACE_VFE_PROD>
	_cXml += "   <PARAMETROS>
	_cXml += "   <CNPJ_CLIENTE>01438784001926</CNPJ_CLIENTE>
	_cXml += "   <CNPJ_FORNECEDOR>05890658000210</CNPJ_FORNECEDOR>
	_cXml += " </PARAMETROS>
	_cXml += " <PRODUTOS>
	_cXml += "   <PRODUTO>
	_cXml += "     <ID_PRODUTO_CLIENTE>00000000089679695</ID_PRODUTO_CLIENTE>
	_cXml += "     <ID_PRODUTO_FORNECEDOR>234/1-BR</ID_PRODUTO_FORNECEDOR>
	_cXml += "     <EAN>78900016922613</EAN>
	_cXml += "     <UNIDADE_MEDIDA>UN</UNIDADE_MEDIDA>  
	_cXml += "   </PRODUTO>
	_cXml += "   <PRODUTO>
	_cXml += "     <ID_PRODUTO_CLIENTE>00000000089679723</ID_PRODUTO_CLIENTE>
	_cXml += "     <ID_PRODUTO_FORNECEDOR>234/2-BR</ID_PRODUTO_FORNECEDOR>
	_cXml += "     <EAN>78900016922651</EAN>
	_cXml += "     <UNIDADE_MEDIDA>UN</UNIDADE_MEDIDA>  
	_cXml += "   </PRODUTO>
	_cXml += " </PRODUTOS>
	_cXml += " </INTERFACE_VFE_PROD>	
	*/
	Reset Environment

	RpcSetType(3)
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	ConOut(CRLF + "[STESTA05]["+ FWTimeStamp(2) +"] Inicio da consulta de estoque.")

	Conout("[STESTA05]["+ FWTimeStamp(2) +"] - XML recebido - "+_cXml)

	oXml := XmlParser( _cXml, "_", @cError, @cWarning )

	If  Valtype(oXml) != 'O' .or. !empty(cError)
		ConOut("[STESTA05] - "+DTOC(Date())+" - "+Time()+" - Falha ao fazer o parser do XML: "+ cError + cWarning)
		cXmlResp += SetResp1("00","Problema ao converter o XML")
		Return(cXmlResp)
	EndIf

	cXmlResp := "<INTERFACE_VFE_STOCK>
	cXmlResp += "<PARAMETROS>
	cXmlResp += "<CNPJ_CLIENTE>"+oXml:_INTERFACE_VFE_PROD:_PARAMETROS:_CNPJ_CLIENTE:TEXT+"</CNPJ_CLIENTE>
	cXmlResp += "<CNPJ_FORNECEDOR>"+oXml:_INTERFACE_VFE_PROD:_PARAMETROS:_CNPJ_FORNECEDOR:TEXT+"</CNPJ_FORNECEDOR>
	cXmlResp += "</PARAMETROS>
	cXmlResp += "<PRODUTOS>

	Do Case
		Case Type("oXml:_INTERFACE_VFE_PROD:_PRODUTOS:_PRODUTO")=="O"
		AADD(_aProdutos,{;
		oXml:_INTERFACE_VFE_PROD:_PRODUTOS:_PRODUTO:_EAN:TEXT,;
		oXml:_INTERFACE_VFE_PROD:_PRODUTOS:_PRODUTO:_ID_PRODUTO_CLIENTE:TEXT,;
		oXml:_INTERFACE_VFE_PROD:_PRODUTOS:_PRODUTO:_ID_PRODUTO_FORNECEDOR:TEXT,;
		oXml:_INTERFACE_VFE_PROD:_PRODUTOS:_PRODUTO:_UNIDADE_MEDIDA:TEXT;
		}) 
		Case Type("oXml:_INTERFACE_VFE_PROD:_PRODUTOS:_PRODUTO")=="A"
		For _nX:=1 To Len(oXml:_INTERFACE_VFE_PROD:_PRODUTOS:_PRODUTO)
			AADD(_aProdutos,{;
			oXml:_INTERFACE_VFE_PROD:_PRODUTOS:_PRODUTO[_nX]:_EAN:TEXT,;
			oXml:_INTERFACE_VFE_PROD:_PRODUTOS:_PRODUTO[_nX]:_ID_PRODUTO_CLIENTE:TEXT,;
			oXml:_INTERFACE_VFE_PROD:_PRODUTOS:_PRODUTO[_nX]:_ID_PRODUTO_FORNECEDOR:TEXT,;
			oXml:_INTERFACE_VFE_PROD:_PRODUTOS:_PRODUTO[_nX]:_UNIDADE_MEDIDA:TEXT;
			})
		Next
	EndCase

	For _nX:=1 To Len(_aProdutos)
		cXmlResp += SetResp(_aProdutos[_nX])
	Next

	cXmlResp += "</PRODUTOS>
	cXmlResp += "</INTERFACE_VFE_STOCK>

	ConOut(CRLF + "[STESTA05]["+ FWTimeStamp(2) +"] Fim da consulta de estoque.")

Return(cXmlResp)

/*/{Protheus.doc} SetResp
@name SetResp
@type Static Function
@desc Setar respostar de retorno do WS
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function SetResp(_aProduto)

	Local cRetorno := ""
	Local _lNaoEnc := .F.
	Local _cDesc   := ""
	Local _nSaldo  := 0
	Local _cUm	   := ""
	Local _cCod	   := "0"

	_cCodSteck := _aProduto[3]
	_cUmSteck  := ""
	_cCodCli   := _aProduto[2]
	_cEan	   := _aProduto[1]
	_cUm	   := _aProduto[4]
	_cDesc	   := ""
	_nSaldo    := 0

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())

	If !Empty(_cCodSteck)
		If !SB1->(DbSeek(xFilial("SB1")+_cCodSteck)) //Buscar pelo nosso código
			_lNaoEnc := .T.
		EndIf
	EndIf

	SB1->(DbSetOrder(5))
	SB1->(DbGoTop())
	If !Empty(_cEan) //Buscar pelo EAN
		If !SB1->(DbSeek(xFilial("SB1")+_cEan))
			_lNaoEnc := .T.
		EndIf
	EndIf

	If !_lNaoEnc

		_cCodSteck 	:= AllTrim(SB1->B1_COD)
		_cCodCli   	:= _aProduto[2]
		_cEan	   	:= AllTrim(SB1->B1_CODBAR)
		_cDesc 		:= AllTrim(SB1->B1_DESC)
		_cUmSteck	:= AllTrim(SB1->B1_UM)
		_nSaldo 	:= u_versaldo(SB1->B1_COD)

		If !(AllTrim(_cUmSteck)==AllTrim(_cUm))
			_cCod := "2"
		EndIf

	Else

		_cCod    := "1"

	EndIf

	If !(AllTrim(SB1->B1_GRUPO)=="125") //Somente sophie
		_nSaldo := 0
		_cCod   := "3"
		_cDesc  := ""
		_cUm    := ""
	EndIf	

	cRetorno += "<PRODUTO>
	cRetorno += "<ID_PRODUTO_CLIENTE>"+_cCodCli+"</ID_PRODUTO_CLIENTE>
	cRetorno += "<ID_PRODUTO_FORNECEDOR>"+_cCodSteck+"</ID_PRODUTO_FORNECEDOR>
	cRetorno += "<EAN>"+_cEan+"</EAN>
	cRetorno += "<DESCRICAO_PRODUTO>"+_cDesc+"</DESCRICAO_PRODUTO>
	cRetorno += "<UNIDADE_MEDIDA>"+_cUmSteck+"</UNIDADE_MEDIDA>
	cRetorno += "<ESTOQUE_DISPONIVEL>"+cValToChar(_nSaldo)+"</ESTOQUE_DISPONIVEL>
	cRetorno += "<DISPONIBILIDADE_ESTOQUE>"+SubStr(DTOS(Date()),1,4)+"-"+SubStr(DTOS(Date()),5,2)+"-"+SubStr(DTOS(Date()),7,2)+"</DISPONIBILIDADE_ESTOQUE>	
	cRetorno += "<CONTROLE_LOTE></CONTROLE_LOTE>
	cRetorno += "<CODIGO_RETORNO>"+_cCod+"</CODIGO_RETORNO>
	cRetorno += "</PRODUTO>

Return(cRetorno)

/*/{Protheus.doc} SetResp
@name SetResp
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

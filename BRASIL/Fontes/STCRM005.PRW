#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'
#include "Fileio.ch"

/*====================================================================================\
|Programa  | STCRM005        | Adaptado por | Flávia Rocha       | Data | 27/09/2021  |
|=====================================================================================|
|Descricao | Obter um orçamento em pdf (encodado 64), decodifica-lo e grava-lo        |
|          | numa pasta do servidor compactado (.mzp)                                 |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Historico....................................|
\====================================================================================*/

WSRESTFUL orcpdf DESCRIPTION "Receber orcamento PDF"

WSMETHOD POST DESCRIPTION "Receber orcamento PDF" WSSYNTAX "/rest/orcpdf"

END WSRESTFUL

//----------------------------------//
//MÉTODO POST:
//----------------------------------//
// http://rest-p12.steck.com.br:9997/rest/orcpdf -> homologação
// rest-p12.steck.com.br:9997/rest/orcpdf?cOrc=759305  passar como parâmetro o número do orçamento
/*
//PARA TESTAR:
http://localhost:8084/rest/orcpdf?cOrc=750800  //750800 SERIA O NUMERO DO ORÇAMENTO
*/
WSMETHOD POST WSRECEIVE cOrc WSSERVICE orcpdf
LOCAL nHdlXml     := 0
LOCAL lRet 				:= .T.
LOCAL _cFile		  := ""
LOCAL cRet			  := "" //retorno da gravação do arquivo zipado
LOCAL _cPdf			  := ""
LOCAL cDecode64		:= ""
LOCAL _cRetorno		:= ""
LOCAL _cOrcamento := ""
LOCAL _cPastaFil  := ""
LOCAL _lExistSUA	:= .F.
LOCAL _nSave		  := 0
LOCAL _cSave		  := ""
PRIVATE _cPath      := GetSrvProfString("RootPath","")
PRIVATE _cStartPath := "\arquivos\ORCAMENTOANEXOS\"
PRIVATE _cEmp       := ""+cEmpAnt+"\"

oJson := NIL

Conout("[STCRM005][ORCPDF]"+ FWTimeStamp(2)+" - Inicio da gravacao orcamento pdf !")


//_cOrcamento := Self:cOrc  //recebe o número do orçamento
_cOrcamento := Self:AQUERYSTRING[1][2]

If Empty(_cOrcamento)
	_cRetorno := '{"CODRET":"99","DESCRET":"ORCAMENTO VAZIO"}'
	::SetResponse(_cRetorno)
	Return .T.
Endif

DbSelectArea("SUA")
SUA->(DbSetOrder(1))
SUA->(DbGoTop())
If SUA->(DbSeek(xFilial("SUA") + _cOrcamento))
	_lExistSUA := .T.		
EndIf

If _lExistSUA
	//_cPdf := ::GetContent()  //recebe o body do pdf vem em formato encode64
	::SetContentType("application/json")
	_cPdf  := Self:GetContent() 		 // Pega o conteudo do JSON
	lRet := FWJsonDeserialize(FwNoAccent(_cPdf),@oJson)
	IF lRet = .F.
		_cRetorno := '{"CODRET":"99","DESCRET":"ERRO NA MONTAGEM DO PDF"}'
		::SetResponse(_cRetorno)
		RETURN .T.
	ENDIF
Else
	_cRetorno := '{"CODRET":"99","DESCRET":"ORCAMENTO NAO LOCALIZADO: ' + _cOrcamento + '"}'
	::SetResponse(_cRetorno)
	Return .T.
Endif

///_cPdf := oJson:PDF
_cPdf := oJson

_cPastaFil := xFilial("SUA") 	
	
//decodificar
cDecode64 := Decode64(_cPdf)	

//cria as pastas no servidor:	
cNArq  := _cOrcamento +".pdf"  //nome do arquivo
	
//"\arquivos\ORCAMENTOANEXOS\" + empresa
cDir   := "\arquivos\ORCAMENTOANEXOS\"+ Alltrim(cEmpAnt)

If !ExistDir(cDir)
	Makedir(cDir)
EndIf 
	
//"\arquivos\ORCAMENTOANEXOS\"+ empresa + filial
cDir   += "\" + Alltrim(_cPastaFil)  

//junção de "\arquivos\ORCAMENTOANEXOS\" + empresa + filial + numero orçamento 
//ficando assim: "\arquivos\ORCAMENTOANEXOS\01\02\759305"
If !ExistDir(cDir)
	Makedir(cDir)
EndIf

//"\arquivos\ORCAMENTOANEXOS\"+empresa + filial + num orçamento
cDir += "\" + Alltrim(_cOrcamento) + "\" 

If !ExistDir(cDir)
	Makedir(cDir)
EndIf  
		
//----------------------------------//
//grava o arquivo na pasta:
//----------------------------------//
_cFile := cDir+ cNArq  //diretorio mais nome do arquivo
			
nHdlXml:= FCreate(_cFile,0)		//Cria o arquivo no diretorio (cria o nome.extensao na pasta apenas)

If nHdlXml > 0
			
	FWrite(nHdlXml,cDecode64)	//aqui grava o conteudo no arquivo acima gravado na pasta
	FClose(nHdlXml)

Endif 

_nSave := 1		
_cSave := Strzero(_nSave,6)
cRet   := MsCompress(_cFile, (cDir+_cSave + ".mzp") )  //o nome do arquivo comprimido precisa ser 000001.mzp até 000006.mzp
//cRet   := MsCompress(_cFile, (cDir+ _cOrcamento + ".mzp") )
_lRet  := !Empty(cRet)
	
If _lRet
	_cRetorno := '{"CODRET":"01","DESCRET":"ARQUIVO ZIPADO COM SUCESSO: ' + _cOrcamento + '"}'		
Else
	_cRetorno := '{"CODRET":"99","DESCRET":"FALHA AO ZIPAR ORCAMENTO: ' + _cOrcamento + '"}'
EndIf

::SetResponse(_cRetorno)
	

RETURN .T.


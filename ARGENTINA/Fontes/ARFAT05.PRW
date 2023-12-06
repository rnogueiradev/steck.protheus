#INCLUDE "TOTVS.CH"
#INCLUDE "FILEIO.CH"

/*====================================================================================\
|Programa  | ARFAT05         | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function ARFAT05(_nTipo)

	Local _cNota 	:= ""
	Local _cSerie	:= ""

	If Alias()=="SF1"
		_cNota 	:= SF1->F1_DOC
		_cSerie := SF1->F1_SERIE
	Else
		_cNota 	:= SF2->F2_DOC
		_cSerie := SF2->F2_SERIE
	EndIf

	Do Case
		Case _nTipo==1 //monitor

		cArquivo := "\PROFILE\"+__cUserId+"_"+SM0->M0_CODIGO+SM0->M0_CODFIL+"factura de exportacion.prb"

		If File(cArquivo)
			MemoWrite(cArquivo,"")
			_nHandle := fopen(cArquivo,FO_READWRITE+FO_SHARED)
			fWrite(_nHandle,"1Arquivo de configuração - Parambox Protheus"+CRLF)
			fWrite(_nHandle,"C"+_cSerie+CRLF)
			fWrite(_nHandle,"C"+_cNota+CRLF)
			fWrite(_nHandle,"C"+_cNota+CRLF)
			fClose(_nHandle)
		EndIf

		ARGNNFe6Mnt(_cSerie,_cNota,_cNota,.F.)

		Case _nTipo==2 //transmissao

		cArquivo := "\PROFILE\"+__cUserId+SM0->M0_CODIGO+SM0->M0_CODFIL+"factura exportación.prb"

		If File(cArquivo)
			MemoWrite(cArquivo,"")
			_nHandle := fopen(cArquivo,FO_READWRITE+FO_SHARED)
			fWrite(_nHandle,"1Arquivo de configuração - Parambox Protheus"+CRLF)
			fWrite(_nHandle,"C"+_cSerie+CRLF)
			fWrite(_nHandle,"C"+_cNota+CRLF)
			fWrite(_nHandle,"C"+_cNota+CRLF)
			fClose(_nHandle)
		EndIf

		ARGNNFeRe2(_cSerie,_cNota,_cNota,.F.,.F.)

	EndCase

Return()
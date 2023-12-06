#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#include "tbiconn.ch"
#include "fileio.ch"

#Define CR chr(13)+ chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTBALANCAบAutor ณ GIOVANI ZAGO	     บ Data ณ  27/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  										                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  Exporta็ใo                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function STBALANCA()
	Local aArea  := GetArea()
	Local aDirImpor   := {}
	Local cDiretorio  := 'C:\KEEN IT\Kab\Files'
	Local oBal
	Local _nRet		  := 0
	Local nLinhas     := 0
	Local _cDat		  := ' '
	Local GFEFile     := GFEXFILE():New()
	Local cHoraInicio	:= time()
	Local nErr := 0

	If GetMv ("ST_BALKBA",,.T.)
		Return(0)
	EndIf

	//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
	If "TC" $ Upper(GetComputerName())
		Return(0)
	Endif

	shellExecute("Open","C:\KEEN IT\Kab\kba.exe","service","C:\KEEN IT\Kab\",0)
	//Demora 2 segundos para rodar o shellexecute
	sleep(1500)

	_cDat:= substr(Dtos(date()),7,2)+substr(Dtos(date()),5,2)+substr(Dtos(date()),1,4)
	aDirImpor := DIRECTORY(cDiretorio + "\KBA_"+_cDat+".TXT" )

	If Len(aDirImpor) == 0
		MsgInfo("Servi็o da balan็a parado.....!!!!")
		Return(0)
	Endif

	cNomeArq := aDirImpor[1][1]

	GFEFile:Clear()
	GFEFile:Open(cDiretorio + "\" + cNomeArq)
	nLinhas := GFEFile:NQTDELIN
	If nLinhas<=0
		MsgAlert("Aten็ใo, arquivo em branco, verifique!")
		Return(0) 
	EndIf
	cBuffer := GFEFile:ALINHAS[nLinhas]
	GFEFile:Clear()
	MemoWrite(cDiretorio + "\KBA_"+_cDat+".TXT","")

	If !("START PROCESS" $ cBuffer)

		cAviso := ""
		cErro  := ""
		_cXml  := ""
		_cXml:= Alltrim(substr(cBuffer,24,len(cBuffer)))
		_cXml:= FwCutOff(_cXml, .t.)
		oBal := XmlParser(_cXml,"_",@cAviso,@cErro)

		If VALType(oBal) <> "U"
			If valtype(oBal:_nBruto) = 'O'
				_nRet:= val( StrTran( oBal:_nBruto:text,",", "." ))
			EndIf
		EndIf

	EndIf
	RestArea(aArea)
Return(_nRet)


#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTGATCON   บAutor  ณRenato Nogueira    บ Data ณ  20/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STGATCON()

Local _cConta	:= ""
              

If (B1_TIPO="PA" .Or. B1_TIPO="PI") .And. (B1_CLAPROD='I' .Or. B1_CLAPROD='C') .And. Substr(cNumEmp,01,02) =="01"//Incluido em 26/01/2017 por solicita็ใo do usuแrio jadson.silva/eduardo
  _cConta	:="114001005"
ELSEIF B1_TIPO="PA" 
_cConta	:=	"114001001"
ElseIf B1_TIPO="PI"
_cConta	:=	"114001030"
ElseIf B1_TIPO="MP"
_cConta	:=  "114001015"  
ElseIf B1_TIPO="EM"
_cConta	:=  "114001015"  //Alterado em 26/11/2013 por solicita็ใo do usuแrio jadson.silva
ElseIf B1_TIPO="MC"
_cConta	:=  "114001025"
ElseIf B1_TIPO="ME"
_cConta	:=  "114001025"
ElseIf B1_TIPO="IC"
_cConta	:=  "114001015"
ElseIf B1_TIPO="BN"
_cConta	:=  "114001030"  
ElseIf B1_TIPO="AI"
_cConta	:=  "114001025"
Else
_cConta	:= "114001025"  
EndIf

Return(_cConta)
 
 
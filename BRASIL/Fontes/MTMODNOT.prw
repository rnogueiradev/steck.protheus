#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTMODNOT	บAutor  ณRenato Nogueira     บ Data ณ  10/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte utilizado para desconsiderar algumas notas do sped    บฑฑ
ฑฑบ          ณpis/cofins						  	 				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ cEspecie                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ cCodigo										              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MTMODNOT()
//fisxfun.prx
Local _aArea     	:= GetArea()
Local _cCodigo		:= ""

DO CASE
	
	CASE AllTrim(PARAMIXB)=="NT"
		_cCodigo	:= "99" //desconsiderado da gera็ใo do SPED
	CASE AllTrim(PARAMIXB)=="NFFA"
		_cCodigo	:= "99" //desconsiderado da gera็ใo do SPED
	CASE AllTrim(PARAMIXB)=="OCC"
		_cCodigo	:= "99" //desconsiderado da gera็ใo do SPED
	CASE AllTrim(PARAMIXB)=="RC"
		_cCodigo	:= "99" //desconsiderado da gera็ใo do SPED
	CASE AllTrim(PARAMIXB)=="RPS"
		_cCodigo	:= "99" //desconsiderado da gera็ใo do SPED
	CASE AllTrim(PARAMIXB)=="NFPS"
		_cCodigo	:= "99"	//desconsiderado da gera็ใo do SPED
	CASE AllTrim(PARAMIXB)=="NFS"
		_cCodigo	:= "99"	//desconsiderado da gera็ใo do SPED
	CASE AllTrim(PARAMIXB)=="CA"
		_cCodigo	:= "10"
	CASE AllTrim(PARAMIXB)=="CTA"
		_cCodigo	:= "09"
	CASE AllTrim(PARAMIXB)=="CTF"
		_cCodigo	:= "11"
	CASE AllTrim(PARAMIXB)=="CTR"
		_cCodigo	:= "08"
	CASE AllTrim(PARAMIXB)=="CTE"
		_cCodigo	:= "57"
	CASE AllTrim(PARAMIXB)=="NF"
		_cCodigo	:= "01"
	CASE AllTrim(PARAMIXB)=="NFF"
		_cCodigo	:= "01"
	CASE AllTrim(PARAMIXB)=="NFCEE"
		_cCodigo	:= "06"
	CASE AllTrim(PARAMIXB)=="NFE"
		_cCodigo	:= "01"
	CASE AllTrim(PARAMIXB)=="NFST"
		_cCodigo	:= "07"
	CASE AllTrim(PARAMIXB)=="NFSC"
		_cCodigo	:= "21"
	CASE AllTrim(PARAMIXB)=="NTSC"
		_cCodigo	:= "21"
	CASE AllTrim(PARAMIXB)=="NTSC"
		_cCodigo	:= "21"
	CASE AllTrim(PARAMIXB)=="NTST"
		_cCodigo	:= "22"
	CASE AllTrim(PARAMIXB)=="NFCF"
		_cCodigo	:= "02"
	CASE AllTrim(PARAMIXB)=="NFP"
		_cCodigo	:= "04"
	CASE AllTrim(PARAMIXB)=="RMD"
		_cCodigo	:= "18"
	CASE AllTrim(PARAMIXB)=="SPED"
		_cCodigo	:= "55"
	OTHERWISE
		_cCodigo	:= "01"     
		
ENDCASE

RestArea(_aArea)

Return(_cCodigo)
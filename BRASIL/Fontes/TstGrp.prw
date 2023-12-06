#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTSTGRP    บAutor  ณRenato Nogueira     บ Data ณ  22/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para validar se o usuแrio pertence ao grupo da       บฑฑ
ฑฑบ          ณengenharia                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TstGrp(_cCampo)

	Local _aGrupos, _nPos
	Local _lRet		:= .F.
	Local _cGrps 	:= GetMv("FS_GRPENG")
	Local _cUsers	:= GetMv("FS_USRFAN")
	Local _cXDesat	:= GetMv("ST_XDESAT")

	If FUNNAME() $ "RPC"
		__cUserId := "000000"
	EndIF

	If Empty(__cUserId)
		Return
	EndIf

	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos	:= PswRet()
	EndIf

	If  _aGrupos[1][10][1] $ _cGrps .And. Empty(_cCampo)
		_lRet := .T.
	EndIf

	If AllTrim(_cCampo)=="B1_FANTASM" .And. __cUserId $ _cUsers
		_lRet := .T.
	EndIf

	If AllTrim(_cCampo)=="B1_XDESAT" .And. __cUserId $ _cXDesat //Renato Nogueira - Chamado 000081
		_lRet := .T.
	EndIf

Return _lRet
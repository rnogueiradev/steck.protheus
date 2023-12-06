#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTEICPES  บAutor  ณRenato Nogueira     บ Data ณ  06/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa utilizado cadastrar pesos por NCM no embarque     บฑฑ
ฑฑบ          ณ 					                                         	 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STEICPES()
	
	Local 		aArea   		:= GetArea()
	Local 		aAreaSW7  		:= SW7->(GetArea())
	Local 		cQuery 		:= ""
	Local nX:=0
	Private	_aRet 			:= {}
	Private	_aParamBox 	:= {}
	Private	_cNcm			:= ""
	Private	_nPeso			:= 0
	Private	_aDados		:= {}
	Private	_lContinua		:= .F.
	
	AADD(_aParamBox,{1,"NCM" ,Space(8),""					 	,"EXISTCPO('SYD')","SYD","",0,.T.})
	AADD(_aParamBox,{1,"Peso",Space(8),"@E"					,"","","",0,.T.})
	
	If ParamBox(_aParamBox,"Peso por N.C.M.",@_aRet,,,.T.,,500)
		
		_lContinua	:= .T.
		
		_cNcm	:= _aRet[1]
		_nPeso	:= _aRet[2]
		
		_nPeso	:= Val(StrTran(_nPeso,",","."))
		
		AADD(_aDados,{_cNcm,_nPeso})
		
		While MsgYesNo("Deseja cadastrar mais pesos?")
			
			STCADPES()
			
		EndDo
		
	Else
		
		_lContinua	:= .F.
		
	EndIf
	
	If _lContinua
		
		For nX:=1 To Len(_aDados)
			
			cQuery := " UPDATE "+RetSqlName("SW7")+" W7 "
			cQuery += " SET W7_PESO="+CVALTOCHAR(_aDados[nX][2])+" "
			cQuery += " WHERE W7.D_E_L_E_T_=' ' AND W7_FILIAL='"+SW6->W6_FILIAL+"' AND W7_HAWB='"+SW6->W6_HAWB+"' "
			cQuery += "  AND W7_NCM='"+_aDados[nX][1]+"'"
			//Ticket 20200306000906 - Everson Santana - 01/04/2020
			//cQuery += " AND W7_PO_NUM='"+SW6->W6_PO_NUM+"' AND W7_NCM='"+_aDados[nX][1]+"'" // Retirado para aplicar เ atualiza็ใo em toda a invoice
			
			nErrQry := TCSqlExec( cQuery )
			
			If nErrQry <> 0
				MsgAlert('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENวรO')
			EndIf
			
		Next nX
		
		MsgAlert("Pesos atualizados com sucesso!")
		
	EndIf
	
	RestArea(aAreaSW7)
	RestArea(aArea)
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTEICPES  บAutor  ณRenato Nogueira     บ Data ณ  06/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa utilizado cadastrar pesos por NCM no embarque     บฑฑ
ฑฑบ          ณ 					                                         	 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STCADPES()
	
	If ParamBox(_aParamBox,"Peso por N.C.M.",@_aRet,,,.T.,,500)
		
		_lContinua	:= .T.
		
		_cNcm	:= _aRet[1]
		_nPeso	:= _aRet[2]
		
		_nPeso	:= Val(StrTran(_nPeso,",","."))
		
		AADD(_aDados,{_cNcm,_nPeso})
		
	Else
		
		_lContinua	:= .F.
		
	EndIf
	
Return

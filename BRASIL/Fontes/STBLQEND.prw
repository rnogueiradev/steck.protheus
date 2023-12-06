#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STBLQEND  ºAutor  ³Renato Nogueira     º Data ³  05/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Bloqueio de endereços 							          º±±
±±º          ³					                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Steck                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STBLQEND(_cEndereco)

Local aAreaSD3     := GetArea("SD3")
Local aAreaCBA     := GetArea("CBA")
Local aArea	     := GetArea()
Local _lRet		  := .T.
Local _EndBlq      := GetMv("ST_BLQEND")
Local cQuery       := ""
Local cAliasLif    := 'TMP01'
Local _cEndere 	 := ""
Local _cEndDig     := &(ReadVar())
	
If AllTrim(_cEndereco) $ _EndBlq
	MsgInfo("Este endereço foi bloqueado para uso","Erro")
	_lRet	:= .F.
EndIf

cQuery := "SELECT CBA_LOCALI LOCALI FROM " + RetSqlName("CBA")+ "  WHERE CBA_LOCAL = '03' AND CBA_FILIAL = '"+XFILIAL('CBA')+"' AND   CBA_STATUS  IN ( 2, 3, 4 )  AND CBA_XROTAT = '1' AND CBA_LOCALI = '"+_cEndDig+"'  AND D_E_L_E_T_ = ' '  "
cQuery := ChangeQuery(cQuery)
	
If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf
	
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
If Select(cAliasLif) > 0
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	_cEndere := alltrim((cAliasLif)->LOCALI)
		
		IF !EMPTY(_cEndere)
			MSGAlert("Este produto nao poder ser transferido pois esta em inventario rotativo !!!")
			_lRet	:= .F.
		ENDIF	
EndIf

/*
		dbSelectArea("CBA")
		DbSetorder(6)
		//dbOrderNickName("STINVROT3")
		dbGotop()
				
		IF dbSeek(xFilial("CBA")+"03"+_cEndereco)
		
			while !EOF() .and. CBA->CBA_LOCAL+CBA->CBA_LOCALI == "03"+_cEndereco 
		
				IF CBA->CBA_STATUS >= "1" .and. CBA->CBA_STATUS < "5"
				MSGAlert("Este produto nao poder ser transferido pois esta em inventario rotativo !!!")
				_lRet	:= .F.	
				Endif
					
			CBA->(dbSkip())
			
			End
	
		Endif
*/


RestArea(aArea)
RestArea(aAreaCBA)
RestArea(aAreaSD3)
Return(_lRet)
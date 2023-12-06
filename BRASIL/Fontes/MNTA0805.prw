#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNTA0805	ºAutor  ³Renato Nogueira     º Data ³  05/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado para chamar rotina de troca de filial 	  º±±
±±º          ³no cadastro de bens				    				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ 		                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MNTA0805()

Local _aArea 		:= GetArea()
Local _aRet 		:= {}
Local _aParamBox 	:= {}
Local _cQuery  		:= ""
Local _cAlias  		:= "QRYTEMP"

If MsgYesNo("Deseja alterar a filial do bem: "+AllTrim(ST9->T9_CODBEM))
	
	AADD(_aParamBox,{1,"Filial","01","@!","","","",02,.T.}) //50
	
	If ParamBox(_aParamBox,"Alteração de filial",@_aRet,,,.T.,,500)
		
		ST9->(RecLock("ST9",.F.))
		ST9->T9_FILIAL	:= _aRet[1]
		ST9->(MsUnLock())
		
		_cQuery	:= " SELECT TB_FILIAL, TB_CODBEM, TB.R_E_C_N_O_ REGISTRO "
		_cQuery	+= " FROM "+RetSqlName("STB")+" TB "
		_cQuery	+= " WHERE TB.D_E_L_E_T_=' ' AND TB_CODBEM = '"+ST9->T9_CODBEM+"' "
		_cQuery += " ORDER BY TB.R_E_C_N_O_ "
		
		If !Empty(Select(_cAlias))
			DbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)
		
		dbSelectArea(_cAlias)
		(_cAlias)->(dbGoTop())
		
		DbSelectArea("STB")
		
		While (_cAlias)->(!Eof())
			
			STB->(DbGoTop())
			STB->(DbGoTo((_cAlias)->REGISTRO))
			
			If STB->(!Eof())
				STB->(RecLock("STB",.F.))
				STB->TB_FILIAL	:= _aRet[1]
				STB->(MsUnLock())
			EndIf
			
			(_cAlias)->(DbSkip())
		EndDo
		
		_cQuery	:= " SELECT TPY_FILIAL, TPY_CODBEM, TY.R_E_C_N_O_ REGISTRO "
		_cQuery	+= " FROM "+RetSqlName("TPY")+" TY "
		_cQuery	+= " WHERE TY.D_E_L_E_T_=' ' AND TPY_CODBEM = '"+ST9->T9_CODBEM+"' "
		_cQuery += " ORDER BY TY.R_E_C_N_O_ "
		
		If !Empty(Select(_cAlias))
			DbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)
		
		dbSelectArea(_cAlias)
		(_cAlias)->(dbGoTop())
		
		DbSelectArea("TPY")
		
		While (_cAlias)->(!Eof())
			
			TPY->(DbGoTop())
			TPY->(DbGoTo((_cAlias)->REGISTRO))
			
			If TPY->(!Eof())
				TPY->(RecLock("STY",.F.))
				TPY->TPY_FILIAL	:= _aRet[1]
				TPY->(MsUnLock())
			EndIf
			
			(_cAlias)->(DbSkip())
		EndDo
		
		MsgInfo("Filial alterada com sucesso!")
		
	EndIf
	
EndIf

RestArea(_aArea)

Return()
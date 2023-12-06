#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STVLDCG2	ºAutor  ³Renato Nogueira     º Data ³  14/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa utilizado para bloquear a colocação do mesmo cnpj  º±±
±±º          ³para fornecedores diferentes   		  	 				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ A2_CGC                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ LÓGICO										              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STVLDCG2(_cCnpj)

	Local _aArea     := GetArea()
	Local _cQuery 	:= ""
	Local _cAlias 	:= "QRYTEMP"
	Local _lRet		:= .T.
	
	Return(.T.)
	
	//Claudia Ferreira solicitou que fosse retirada a validação pois a entrada do xml é CNPJ+IE - 21/10/2015
	/*
	
	_cQuery  := " SELECT COUNT(*) CONTADOR "
	_cQuery  += " FROM " +RetSqlName("SA2")+ " A2 "
	_cQuery  += " WHERE A2.D_E_L_E_T_=' ' AND A2_CGC='"+_cCnpj+"' "
		
	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)
		
	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())
		
	If (_cAlias)->(CONTADOR)>0
		_lRet := .F.
		MsgInfo("Atenção, esse cnpj já foi cadastrado, verifique!","Erro")
	EndIf
	
	*/
		
	RestArea(_aArea)
	
	Return(_lRet)
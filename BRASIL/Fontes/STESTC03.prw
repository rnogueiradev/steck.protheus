#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#Include "TopConn.ch"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STESTC03      ³Autor  ³ Renato Nogueira  ³ Data ³17.02.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Filtro por nota fiscal							           ³±±
±±³          ³                                                             ³±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STESTC03()

Local aArea     	:= GetArea()
Local aAreaSDA  	:= SDA->(GetArea())
Local aAreaSDB  	:= SDB->(GetArea())
Local _aRet 		:= {}
Local _aParamBox 	:= {}
Local _cFiltro 		:= ""
Local _cNFs			:= ""
Local cQuery 		:= ""
Local cAlias 		:= "QRYTEMP"
Local oBrowse 		:= GetMBrowse()

AADD(_aParamBox,{1,"Nota fiscal",Space(9),"","","","",0,.F.})

If ParamBox(_aParamBox,"Filtro de notas        ",@_aRet,,,.T.,,500)
	
	cQuery := " SELECT DISTINCT QEK_CERFOR DOC "
	cQuery += " FROM " +RetSqlName("QEK") "
	cQuery += " WHERE D_E_L_E_T_=' ' AND QEK_FILIAL='"+xFilial("QEK")+"' AND QEK_NTFISC='"+_aRet[1]+"' "
	cQuery += " UNION "
	cQuery += " SELECT DISTINCT DA_DOC DOC "   
	cQuery += " FROM " +RetSqlName("SDA") "
	cQuery += " WHERE D_E_L_E_T_=' ' AND DA_FILIAL='"+xFilial("SDA")+"' AND DA_DOC='"+_aRet[1]+"' "
	
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	dbSelectArea(cAlias)
	
	(cAlias)->(dbGoTop())   

	_cFiltrAux := 'AllTrim(DA_DOC)$"000000000#'
	While (cAlias)->(!Eof())
		
	//	_cFiltro	+= "DA_DOC == '"+(cAlias)->DOC+"' .Or. "
		_cFiltrAux += alltrim((cAlias)->DOC)+"#"
		(cAlias)->(DbSkip())
		
	EndDo$
	    
	_cFiltrAux	+= '000000000"'
	_cFiltro	:= _cFiltrAux //"DA_DOC == '000000000'"
	
	(cAlias)->(dbCloseArea())
	
EndIf

oBrowse:SetFilterDefault(_cFiltro)

RestArea(aAreaSDA)
RestArea(aAreaSDB)
RestArea(aArea)

Return()
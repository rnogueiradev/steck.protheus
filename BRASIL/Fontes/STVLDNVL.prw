#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³STVLDNVL  ³Autor  ³ Renato Nogueira       ³ Data ³04.11.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Validar o nível do grupo para o tipo de chamado		       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Generico                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STVLDNVL()

Local aArea     := GetArea()
Local _lRet		:= .T.
Local cQuery1 	:= ""
Local cAlias1 	:= "QRYTEMP"

PswOrder(1)
If PswSeek(__cUserId,.T.)
	_aGrupos	:= PswRet()
EndIf

cQuery1	:= " SELECT * "
cQuery1  += " FROM " +RetSqlName("ZZE")+ " ZZE "
cQuery1  += " WHERE ZZE.D_E_L_E_T_=' ' AND ZZE_GRPSOL LIKE '%"+_aGrupos[1][10][1]+"%' "

If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

dbSelectArea(cAlias1)
(cAlias1)->(dbGoTop())

If !Empty((cAlias1)->ZZE_CODIGO)
	
	If (cAlias1)->ZZE_NIVEL==1 .And. M->Z0_CLASERP<>"1"
		_lRet	:= .F.
		MsgAlert("Atenção, este usuário só pode cadastrar chamados do tipo 1 (Erro)")
	EndIf
	
EndIf

RestArea(aArea)

Return(_lRet)
#Include "Protheus.ch"
#Include "TopConn.ch"

User Function STATUB2()

Local cQuery	:= ""
Local cAlias	:= "QRYSB2"

cQuery := "SELECT SB2.R_E_C_N_O_ RECSB2,SB2BKP.B2_FILIAL,SB2BKP.B2_COD,SB2BKP.B2_LOCAL,ISNULL(SB2BKP.B2_QFIM,0)B2_QFIM, "
cQuery += "ISNULL(SB2BKP.B2_VFIM1,0)B2_VFIM1,ISNULL(SB2BKP.B2_VFIM2,0)B2_VFIM2,ISNULL(SB2BKP.B2_VFIM3,0)B2_VFIM3,ISNULL(SB2BKP.B2_VFIM4,0)B2_VFIM4,ISNULL(SB2BKP.B2_VFIM5,0)B2_VFIM5, "
cQuery += "ISNULL(SB2BKP.B2_CMFIM1,0)B2_CMFIM1,ISNULL(SB2BKP.B2_CMFIM2,0)B2_CMFIM2,ISNULL(SB2BKP.B2_CMFIM3,0)B2_CMFIM3,ISNULL(SB2BKP.B2_CMFIM4,0)B2_CMFIM4,ISNULL(SB2BKP.B2_CMFIM5,0)B2_CMFIM5 "
cQuery += "FROM SB2010 SB2 "
cQuery += "LEFT JOIN SB2BKP ON SB2.B2_FILIAL = SB2BKP.B2_FILIAL AND SB2.B2_COD = SB2BKP.B2_COD AND SB2.B2_LOCAL = SB2BKP.B2_LOCAL AND SB2BKP.D_E_L_E_T_ = ' ' "
cQuery += "WHERE  "
cQuery += "SB2.B2_FILIAL <> ' ' AND "
cQuery += "SB2.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)

//Verifica se o Alias esta aberto
If Select(cAlias) > 0
	DbSelectArea(cAlias)
	(cAlias)->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)

TCSetField(cAlias,"B2_QFIM"		,"N",TamSx3("B2_QFIM")[1],TamSx3("B2_QFIM")[2])
TCSetField(cAlias,"B2_VFIM1"	,"N",TamSx3("B2_VFIM1")[1],TamSx3("B2_VFIM1")[2])
TCSetField(cAlias,"B2_VFIM2"	,"N",TamSx3("B2_VFIM2")[1],TamSx3("B2_VFIM2")[2])
TCSetField(cAlias,"B2_VFIM3"	,"N",TamSx3("B2_VFIM3")[1],TamSx3("B2_VFIM3")[2])
TCSetField(cAlias,"B2_VFIM4"	,"N",TamSx3("B2_VFIM4")[1],TamSx3("B2_VFIM4")[2])
TCSetField(cAlias,"B2_VFIM5"	,"N",TamSx3("B2_VFIM5")[1],TamSx3("B2_VFIM5")[2])
TCSetField(cAlias,"B2_CMFIM1"	,"N",TamSx3("B2_CMFIM1")[1],TamSx3("B2_CMFIM1")[2])
TCSetField(cAlias,"B2_CMFIM2"	,"N",TamSx3("B2_CMFIM2")[1],TamSx3("B2_CMFIM2")[2])
TCSetField(cAlias,"B2_CMFIM3"	,"N",TamSx3("B2_CMFIM3")[1],TamSx3("B2_CMFIM3")[2])
TCSetField(cAlias,"B2_CMFIM4"	,"N",TamSx3("B2_CMFIM4")[1],TamSx3("B2_CMFIM4")[2])
TCSetField(cAlias,"B2_CMFIM5"	,"N",TamSx3("B2_CMFIM5")[1],TamSx3("B2_CMFIM5")[2])

dbSelectArea(cAlias)
(cAlias)->(DbGoTop())
While (cAlias)->(!Eof())
	DbSelectArea("SB2")
	SB2->(DbGoto((cAlias)->RECSB2))
	If SB2->(B2_FILIAL+B2_COD+B2_LOCAL) == (cAlias)->(B2_FILIAL+B2_COD+B2_LOCAL)
		RecLock("SB2",.F.)
		SB2->B2_QFIM := (cAlias)->B2_QFIM
		SB2->B2_VFIM1 := (cAlias)->B2_VFIM1
		SB2->B2_VFIM2 := (cAlias)->B2_VFIM2
		SB2->B2_VFIM3 := (cAlias)->B2_VFIM3
		SB2->B2_VFIM4 := (cAlias)->B2_VFIM4
		SB2->B2_VFIM5 := (cAlias)->B2_VFIM5
		SB2->B2_CMFIM1 := (cAlias)->B2_CMFIM1
		SB2->B2_CMFIM2 := (cAlias)->B2_CMFIM2
		SB2->B2_CMFIM3 := (cAlias)->B2_CMFIM3
		SB2->B2_CMFIM4 := (cAlias)->B2_CMFIM4
		SB2->B2_CMFIM5 := (cAlias)->B2_CMFIM5
		MsUnlock()
	EndIf
	(cAlias)->(DbSkip())
EndDo

dbSelectArea(cAlias)
(cAlias)->(DbCloseArea())

Return


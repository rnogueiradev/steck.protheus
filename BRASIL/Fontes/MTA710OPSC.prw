#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TopConn.ch"

/*====================================================================================\
|Programa  | MTA710OPSC          | Autor | giovani zago           | Data | 06/02/2018 |
|=====================================================================================|
|Descrição | MTA710OPSC                                                               |
|          | Aglutinar Sc no MRP												      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MTA710OPSC                                                               |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MTA710OPSC()

	Local _aArea    := GetArea()
	Local cQuery    := ''
	Local cQry      := ''
	Local cTime     := Time()
	Local cHora     := SUBSTR(cTime, 1, 2)
	Local cMinutos  := SUBSTR(cTime, 4, 2)
	Local cSegundos := SUBSTR(cTime, 7, 2)
	Local cAliasLif := 'MTA710OPSC'+cHora+ cMinutos+cSegundos
	Local _cItem    := '0000'
	Local _cData    := ''
	Local _cNum     := ''

	If GetMv("ST_MRPSC",,.T.)

		cQuery := " SELECT
		cQuery += " SC1.R_E_C_N_O_ AS RECSC1, SC1.C1_NUM AS NUM,
		cQuery += " SC1.C1_DATPRF AS DATASC1
		cQuery += " FROM "+RetSqlName("SC1")+" SC1
		cQuery += " WHERE SC1.D_E_L_E_T_ = ' '
		cQuery += " AND C1_MOTIVO = 'MRP'
		cQuery += " AND C1_TPSC   = '1'
		cQuery += " ORDER BY SC1.C1_DATPRF

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

		If  Select(cAliasLif) > 0
			dbSelectArea(cAliasLif)
			(cAliasLif)->(dbgotop())
			While !(cAliasLif)->(Eof())
				If _cData <> (cAliasLif)->DATASC1
					_cItem:= '0001'
					_cData:= (cAliasLif)->DATASC1
					_cNum:=  GetNumSC1()
				Else
					_cItem:= Soma1(_cItem)
				EndIf

				DbSelectArea("SC1")
				SC1->(DbGoTo((cAliasLif)->RECSC1 ))
				If (cAliasLif)->RECSC1    = SC1->(RECNO())
					SC1->(RecLock("SC1",.F.))
					SC1->C1_ITEM := _cItem
					SC1->C1_NUM  := _cNum
					SC1->(MsUnlock())
					SC1->( DbCommit() )
				EndIf

				(cAliasLif)->(dbSkip())
			End

		EndIf

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf
	EndIf
	
	// FMT CONSULTORIA
	If !Empty(_cDestOP)

		cQry := "UPDATE "+RETSQLNAME("SC2")+" SET C2_ZDESTIN='"+_cDestOP+"', C2_ZDEPTO='1'
		cQry += "WHERE C2_SEQMRP='"+c711NumMRP+"' AND C2_FILIAL='"+XFILIAL("SC2")+"' "
		TCSQLEXEC(cQry)		

	Endif

	RestArea(_aArea)

Return()

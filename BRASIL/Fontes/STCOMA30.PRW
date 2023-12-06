#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STCOMA31
@name STCOMA31
@type User Function
@desc fechar cotações vencidas
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STCOMA30()

	Local cNewEmp 	:= "01"
	Local cNewFil	:= "01"
	Local _aAreaSM0 := SM0->(GetArea())

	If IsBlind()
		RpcSetType( 3 )
		RpcSetEnv( cNewEmp, cNewFil,,,"FAT")
	EndIf

	If !LockByName("STCOMA30",.F.,.F.,.T.)
		If IsBlind()
			ConOut("[STCOMA30]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Else
			MsgAlert("[STCOMA30]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		EndIf
		Return()
	EndIf

	ConOut(CRLF + "[STCOMA30]["+ FWTimeStamp(2) +"] Inicio do processamento.")	

	SM0->(DBGoTop())
	While SM0->(!Eof())
		If SM0->M0_CODIGO$"01#03" .And. SM0->M0_CODFIL=="01"
			ConOut(CRLF + "[STCOMA31]["+ FWTimeStamp(2) +"] Inicio do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))	
			StartJob("U_STCOMA31",GetEnvServer(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL)
			ConOut(CRLF + "[STCOMA31]["+ FWTimeStamp(2) +"] Fim do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))	
		EndIf
		SM0->(DbSkip())
	EndDo

	If IsBlind()
		ConOut("[STCOMA30]["+ FWTimeStamp(2) +"] Fim do processamento")
	Else
		MsgAlert("[STCOMA30]["+ FWTimeStamp(2) +"] Fim do processamento")
	EndIf

	UnLockByName("STCOMA30",.F.,.F.,.T.)

	If IsBlind()
		Reset Environment
	EndIf

	RestArea(_aAreaSM0)

Return

/*/{Protheus.doc} STCOMA30
@name STCOMA30
@type User Function
@desc fechar cotações vencidas
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STCOMA31(cNewEmp,cNewFil)

	Local _cQuery1 := ""
	Local _cAlias1 := ""

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT C8.R_E_C_N_O_ RECSC8
	_cQuery1 += " FROM "+RetSqlName("SC8")+" C8
	_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND C8_NUMPED=' ' AND C8_VALIDA<'"+DTOS(Date())+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SC8")

	While (_cAlias1)->(!Eof())

		SC8->(DbGoTo((_cAlias1)->RECSC8))
		If SC8->(!Eof())
			SC8->(RecLock("SC8",.F.))
			SC8->C8_NUMPED 	:= "XXXXXX"
			SC8->C8_ITEMPED	:= "XXXX"
			SC8->(MsUnLock())
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo
	
	Reset Environment

Return
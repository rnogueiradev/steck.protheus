#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STCOM060
@name STCOM060
@type User Function
@desc verifica cotações que não foi enviado wf
@author Renato Nogueira
@since 10/07/2018
/*/

User Function STCOM062()

U_STCOM061("11","01")

Return()

User Function STCOM060()

	Local cNewEmp 	:= "01"
	Local cNewFil	:= "01"

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	ConOut(CRLF + "[STCOM060]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	SM0->(DBGoTop())
	While SM0->(!Eof())
		If SM0->M0_CODIGO$"01#03#11"
			ConOut(CRLF + "[STCOM061]["+ FWTimeStamp(2) +"] Inicio do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))
			StartJob("U_STCOM061",GetEnvServer(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL)
			ConOut(CRLF + "[STCOM061]["+ FWTimeStamp(2) +"] Fim do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))
		EndIf
		SM0->(DbSkip())
	EndDo

	ConOut("[STCOM060]["+ FWTimeStamp(2) +"] Fim do processamento")

	Reset Environment

Return()

/*/{Protheus.doc} STCOM061
@name STCOMA30
@type User Function
@desc processa os wf
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STCOM061(cNewEmp,cNewFil)

	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Default cNewEmp	:= "01"
	Default cNewFil := "04"

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	If !LockByName("STCOM060",.T.,.T.)
		ConOut("[STCOM060]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT C8.C8_FILIAL, C8.C8_NUM, C8.C8_FORNECE, C8.C8_LOJA, C8.R_E_C_N_O_, C8.C8_XENVMAI
	_cQuery1 += " FROM "+RetSqlName("SC8")+" C8
	_cQuery1 += " LEFT JOIN (
	_cQuery1 += " SELECT DISTINCT XC8.C8_FILIAL, XC8.C8_NUM, XC8.C8_FORNECE, XC8.C8_LOJA, XC8.R_E_C_N_O_, XC8.C8_XENVMAI
	_cQuery1 += " FROM "+RetSqlName("SC8")+" XC8
	_cQuery1 += " WHERE XC8.D_E_L_E_T_=' ' AND C8_EMISSAO>='"+DTOS(Date()-30)+"' AND C8_XENVMAI='S' AND C8_NUMPED=' '
	_cQuery1 += " ) XXX
	_cQuery1 += " ON C8.C8_FILIAL=XXX.C8_FILIAL AND C8.C8_NUM=XXX.C8_NUM AND C8.C8_FORNECE=XXX.C8_FORNECE AND C8.C8_LOJA=XXX.C8_LOJA
	_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND C8.C8_EMISSAO>='"+DTOS(Date()-30)+"' AND C8.C8_XENVMAI=' ' AND C8.C8_NUMPED=' ' AND XXX.C8_NUM IS NULL
	_cQuery1 += " AND C8.C8_FILIAL='"+cNewFil+"'
	//_cQuery1 += " AND C8.C8_NUM='006864'
	_cQuery1 += " ORDER BY C8.C8_FILIAL, C8.C8_NUM, C8.C8_FORNECE, C8.C8_LOJA

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SC8")

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	DbSelectArea("SC1")
	SC1->(DbSetOrder(1)) //C1_FILIAL+C1_NUM+C1_ITEM+C1_ITEMGRD

	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))

	While (_cAlias1)->(!Eof())

		SC8->(DbGoTo((_cAlias1)->R_E_C_N_O_))
		If SC8->(!Eof())

			SA2->(DbGoTop())
			If SA2->(DbSeek(xFilial("SA2")+SC8->(C8_FORNECE+C8_LOJA)))

				U_MTA130C8(.T.)

			EndIf
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	UnLockByName("STCOM060",.T.,.T.)

	Reset Environment

Return

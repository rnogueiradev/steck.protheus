#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STCOM210        | Autor | RENATO.OLIVEIRA           | Data | 31/08/2020  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM210()

	Local cNewEmp 	:= "01"
	Local cNewFil	:= "01"

	Return //Desativa pois a rotina u_CONSNFE já está fazendo isso

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	If !LockByName("STCOM210",.F.,.F.,.T.)
		ConOut("[STCOM210]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	ConOut(CRLF + "[STCOM210]["+ FWTimeStamp(2) +"] Inicio do processamento.")	

	SM0->(DBGoTop())
	While SM0->(!Eof())
		If SM0->M0_CODIGO$"01#03"
			ConOut(CRLF + "[STCOM210]["+ FWTimeStamp(2) +"] Inicio do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))	
			StartJob("U_STCOM211",GetEnvServer(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL)
			ConOut(CRLF + "[STCOM210]["+ FWTimeStamp(2) +"] Fim do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))	
		EndIf
		SM0->(DbSkip())
	EndDo

	ConOut("[STCOM210]["+ FWTimeStamp(2) +"] Fim do processamento")

	UnLockByName("STCOM210",.F.,.F.,.T.)

	Reset Environment

Return()

/*====================================================================================\
|Programa  | STCOM211        | Autor | RENATO.OLIVEIRA           | Data | 31/08/2020  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM211(cNewEmp,cNewFil)

	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _aCols 	:= {}
	Local cCnpj	 	:= ""
	Local cUf	 	:= ""
	Default cNewEmp	:= "01"
	Default cNewFil	:= "02"

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	cCnpj	 := Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")
	cUf	 := Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_ESTENT")	

	DbSelectArea("SF1")
	DbSelectArea("SZ9")

	_cAlias1 := GetNextAlias()

	_cQuery1 := " SELECT F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_EMISSAO, F1.R_E_C_N_O_ RECSF1, F1_CHVNFE, Z9.R_E_C_N_O_ RECSZ9
	_cQuery1 += " FROM "+RetSqlName("SF1")+" F1
	_cQuery1 += " LEFT JOIN "+RetSqlName("SZ9")+" Z9
	_cQuery1 += " ON Z9_FILIAL=F1_FILIAL AND Z9_CHAVE=F1_CHVNFE
	_cQuery1 += " WHERE F1.D_E_L_E_T_=' ' AND Z9.D_E_L_E_T_=' ' 
	_cQuery1 += " AND F1_STATUS='A' AND Z9_STATUSA='Ciencia'
	_cQuery1 += " AND F1_EMISSAO>='20200801' AND F1_CHVNFE<>' ' AND F1_FILIAL='"+cNewFil+"'
	_cQuery1 += " ORDER BY F1_CHVNFE

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_aCols := {}

		SZ9->(DbGoTo((_cAlias1)->RECSZ9))

		aadd(_aCols,{'1',SZ9->Z9_CHAVE,,SZ9->Z9_FILIAL})

		If SZ9->(!Eof())
			U_EXEMANIF(_aCols,cCnpj,cUf,1,.F.,2)
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

Return()

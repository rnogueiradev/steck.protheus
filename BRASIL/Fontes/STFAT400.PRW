#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT400        | Autor | RENATO.OLIVEIRA           | Data | 29/11/2019  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT400()

	Local cNewEmp 	:= "01"
	Local cNewFil 	:= "02"
	Local _cQuery1  := ""
	Local _cAlias1  := ""
	Local _nCount	:= 0
	Local _cData	:= ""
	Local _cDados   := ""

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()
	
	DbSelectArea("ZZV")

	_cQuery1 := " SELECT ZZV.R_E_C_N_O_ RECZZV
	_cQuery1 += " FROM "+RetSqlName("ZZV")+" ZZV
	_cQuery1 += " WHERE ZZV.D_E_L_E_T_=' ' AND ZZV_DTREV<>' ' AND ZZV_DTREV<'"+DTOS(Date())+"' AND ZZV_DTAVIS=' ' 

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())
	
	_aAttach 	:= {}
	_cCaminho	:= ""
	
	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))

	While (_cAlias1)->(!Eof())

		ZZV->(DbGoTo((_cAlias1)->RECZZV))

		If ZZV->(!Eof())
		
			_cEmail := ""
			
			PswOrder(2)

			If PswSeek(Alltrim(ZZV->ZZV_SOLIC), .T. )
				aUsuario 	:= PSWRET()
				_cEmail	  	+= ";"+AllTrim(aUsuario[1,14])
			EndIf
			
			If SA3->(DbSeek(xFilial("SA3")+ZZV->ZZV_VEND1))

				_cEmail += ";"+AllTrim(SA3->A3_EMAIL)
				
				If SA3->(DbSeek(xFilial("SA3")+SA3->A3_SUPER))
					_cEmail += ";"+AllTrim(SA3->A3_EMAIL)
				EndIf

			EndIf			
		
			cMsg := ""
			cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
			cMsg += 'Atenção,<br><br>
			cMsg += 'O pré-desconto '+AllTrim(ZZV->ZZV_COD)+' expirou em '+DTOC(ZZV->ZZV_DTREV)+'.
			cMsg += '</body></html>'
			
			_cEmail := "carla.lodetti@steck.com.br"

			U_STMAILTES(_cEmail,"","[WFPROTHEUS] - Pré-desconto "+AllTrim(ZZV->ZZV_COD)+" expirou",cMsg,_aAttach,_cCaminho)
			
			ZZV->(RecLock("ZZV",.F.))
			ZZV->ZZV_DTAVIS := Date()
			ZZV->(MsUnLock())

		EndIf
		
		(_cAlias1)->(DbSkip())
	EndDo

Return()

#include 'Protheus.ch'
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#Define CR chr(13)+ chr(10)

/*====================================================================================\
|Programa  | STZ1B            | Autor | GIOVANI.ZAGO             | Data | 27/03/2017  |
|=====================================================================================|
|Descrição | STZ1B       Grava log de Acesso                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STZ1B                                                                    |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------------------------------------------------------*
User Function STZ1B(_cNomeRot,_cObs,_cFun,_cUserP,_cNomeP,_cIp,_cEmail)
	*-----------------------------------------------------------------------------*
	Local aArea        := GetArea()
	Local _cAttach  := ' '
	Local _cRot		:= ' '
	Local _aCod		:= {}
	Local _aRetUser := {}
	Default _cObs   := ' '
	Default _cFun   := ' '
	Default _cUserP := ""
	Default _cNomeP	:= ""
	Default _cIp	:= Alltrim(GetWebJob())
	Default _cEmail	:= ""

	 

	If !Empty(_cUserP)
		DbSelectArea("Z1B")
		Z1B->(RecLock("Z1B",.T.))
		Z1B->Z1B_FILIAL		:= cfilant
		Z1B->Z1B_DATA		:= DATE()
		Z1B->Z1B_HORA		:= TIME()
		Z1B->Z1B_USUARI		:= _cUserP
		Z1B->Z1B_NOME		:= _cNomeP
		Z1B->Z1B_ROTINA		:= _cNomeRot
		Z1B->Z1B_NOMERO		:= _cNomeRot
		Z1B->Z1B_OBS		:= _cObs
		Z1B->Z1B_MENU		:= "PORTAL_CLIENTE"
		Z1B->Z1B_ORIG		:= "W"
		Z1B->Z1B_PC			:= _cIp
		Z1B->Z1B_EMAIL		:= _cEmail
		Z1B->Z1B_AMB		:= AllTrim(GetEnvServer())
		Z1B->(MsUnlock())
		Z1B->(DbCommit())
		Return(.T.)
	EndIf

	If GetMv("ST_Z1B",,.T.)   .And. ValType(omainwnd) = 'O'  //GRAVA TABELA Z1B log de acesso

		_cRot:= Upper(Alltrim(omainwnd:ctitle))
		If '[' $ _cRot
			_aCod	:= {}
			_aCod   := StrTokArr( _cRot, '[' )

			_cRot:= _aCod[1]
		EndIf
		DbSelectArea("Z1B")
		Z1B->(RecLock("Z1B",.T.))

		Z1B->Z1B_FILIAL		:= cfilant
		Z1B->Z1B_DATA		:= DATE()
		Z1B->Z1B_HORA		:= TIME()
		Z1B->Z1B_USUARI		:= __cUserId
		Z1B->Z1B_NOME		:= Upper(cUserName)
		Z1B->Z1B_ROTINA		:= Iif(Empty(Alltrim(_cFun)),Upper(FunName()),_cFun)
		Z1B->Z1B_NOMERO		:= padl(cvaltochar(nmodulo),2,'0')+ Alltrim(_cNomeRot)+ Upper(Alltrim(_cRot))
		Z1B->Z1B_OBS		:= _cObs
		//Z1B->Z1B_MENU		:= strtran(Upper(FWGetMnuFile()), "\SYSTEM\", "")

		PswOrder(1)
		If PswSeek(__cUserId,.T.)
			_aRetUser := PswRet(1)
			Z1B->Z1B_DEPART		:=   upper(alltrim(_aRetUser[1,12]))
		EndIf

		Z1B->(MsUnlock())
		Z1B->(DbCommit())

	EndIf
		RestArea(aArea)
Return()
 
/* Ticke 20220129002307 - Everson Santana - 29.01.2022 - Retirei está rotina deste fonte e criei o Fonte STXNU2.prw, para não apresentar erro no CFG.
 

User Function STXNU2(cNewEmp,cNewFil,_cCod)
	Local _aArea
	Local _Lret:= .F.


	RpcSetType( 3 )
	RpcSetEnv( "01", "01",,,"FAT")

	_aArea		:= GetArea()

	//If GetMv("ST_XNUST",,.T.)
	DbSelectArea("Z1F")
	Z1F->(DbSetOrder(1))
	While Z1F->(!Eof())
	
	U_2STXNU(z1f->z1f_cod)
	
	Z1F->(DbSkip())
	EndDo
	//	EndIf


	RestArea(_aArea)
	Reset Environment

Return (_Lret)



User Function 2STXNU(_cCod)
	Local 	_aArea
	Local aDirImpor 		:= {}
	Local _Lret				:= .F.
	Local _cMenu    		:=	"\menu\"+ Alltrim(_cCod) + ".xnu"
	Local i 				:= 0
	Local _nCabec			:= 0
	Local _nMaxCabec	    := 30
	Local _cMen				:= '1'
	Private cPerg 			:= Alltrim(_cCod)+"STXNU"
	Private cTime           := ' '
	Private cHora           := ' '
	Private cMinutos    	:= ' '
	Private cSegundos   	:= ' '
	Private cAliasLif   	:= ' '
	Private cQuery     		:= ' '
	Private cr      := chr(13)+ chr(10)
	Private hdl

	//RpcSetType( 3 )
	//RpcSetEnv( "01", "02",,,"FAT")

	//If GetMv("ST_XNUST",,.T.)
	DbSelectArea("Z1F")
	DbSelectArea("Z1E")
	Z1F->(DbSetOrder(1))
	If Z1F->(DbSeek(xFilial("Z1F")+_cCod))


		_aArea		:= GetArea()

		aDirImpor := DIRECTORY( _cMenu )

		For i := 1 To Len(aDirImpor)

			FERASE("\menu\"+ aDirImpor[1,1])

		Next i

		If !(File(_cMenu))À
			hdl := FCreate(_cMenu, 0)
		Else
			hdl := FOpen(_cMenu, 1)
			FSeek(hdl,0,2)
		Endif





		cTime           := Time()
		cHora           := SUBSTR(cTime, 1, 2)
		cMinutos    	:= SUBSTR(cTime, 4, 2)
		cSegundos   	:= SUBSTR(cTime, 7, 2)
		cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos



		cQuery := " SELECT
		cQuery += "   Z1E_FUNCAO,
		cQuery += "   Z1E_DESC,
		cQuery += "   Z1E_MODULO,
		cQuery += "   Z1E_DESCMO
		cQuery += "  FROM "+RetSqlName("Z1F")+"  Z1F "



		cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("Z1G")+") Z1G "
		cQuery += "  ON Z1G.D_E_L_E_T_ = ' '
		cQuery += "  AND Z1G_COD = Z1F_COD
		cQuery += "  AND Z1G_HABILI = '1'

		cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("Z1E")+") Z1E "
		cQuery += "  ON Z1E.D_E_L_E_T_ = ' '
		cQuery += "  AND Z1E_FUNCAO = Z1G_FUNCAO

		cQuery += "  WHERE Z1F.D_E_L_E_T_ = ' '
		cQuery += "  AND Z1F_COD = '"+ Alltrim(_cCod)+" '

		cQuery += " Order by Z1E_MODULO




		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

		FWrite(hdl,	'<ApMenu>'+cr)
		FWrite(hdl,	'<DocumentProperties>'+cr)
		FWrite(hdl,	'<Module></Module>'+cr)
		FWrite(hdl,	'<Version>10.1</Version>'+cr)
		FWrite(hdl,	'</DocumentProperties>'+cr)

		If  Select(cAliasLif) > 0
			(cAliasLif)->(dbgotop())
			_nCabec	:= 0
			_cMen	:= '1'
			_cModlll:= '00'
			While !(cAliasLif)->(Eof())

				_nCabec	++


				If _cModlll <> (cAliasLif)->Z1E_MODULO
					_cModlll:=	(cAliasLif)->Z1E_MODULO
					_cMen	:= '1'
					If _nCabec <>  1
						FWrite(hdl,	'</Menu>'+cr)
					EndIf
					FWrite(hdl,	'<Menu Status="Enable">'+cr)
					FWrite(hdl,	'<Title lang="pt">&'+CMODL((cAliasLif)->Z1E_MODULO) +'</Title>'+cr)
					FWrite(hdl,	'<Title lang="es">&'+CMODL((cAliasLif)->Z1E_MODULO) +'</Title>'+cr)
					FWrite(hdl,	'<Title lang="en">&'+CMODL((cAliasLif)->Z1E_MODULO) +'</Title>'+cr)
					_nCabec			:= 1
				EndIf



				If _nCabec > _nMaxCabec
					_nCabec			:= 1
					_cMen:= Soma1(_cMen)
					FWrite(hdl,	'</Menu>'+cr)
					FWrite(hdl,	'<Menu Status="Enable">'+cr)
					FWrite(hdl,	'<Title lang="pt">&'+CMODL((cAliasLif)->Z1E_MODULO)+'-'+_cMen+'</Title>'+cr)
					FWrite(hdl,	'<Title lang="es">&'+CMODL((cAliasLif)->Z1E_MODULO)+'-'+_cMen+'</Title>'+cr)
					FWrite(hdl,	'<Title lang="en">&'+CMODL((cAliasLif)->Z1E_MODULO)+'-'+_cMen+'</Title>'+cr)
				EndIf

				FWrite(hdl,	'<MenuItem Status="Enable">'+cr)
				FWrite(hdl,	'<Title lang="pt">'+ Alltrim((cAliasLif)->Z1E_DESC)+'</Title>'+cr)
				FWrite(hdl,	'<Title lang="es">'+ Alltrim((cAliasLif)->Z1E_DESC)+'</Title>'+cr)
				FWrite(hdl,	'<Title lang="en">'+ Alltrim((cAliasLif)->Z1E_DESC)+'</Title>'+cr)
				FWrite(hdl,	'<Function>'+ Alltrim((cAliasLif)->Z1E_FUNCAO)+'</Function>'+cr)
				FWrite(hdl,	'<Type>'+ IiF(SUBSTR((cAliasLif)->Z1E_FUNCAO,1,2)=="ST" .OR. SUBSTR((cAliasLif)->Z1E_FUNCAO,1,6)=="RSTFAT",'3','1')+'</Type>'+cr)

				If Alltrim((cAliasLif)->Z1E_FUNCAO)  = 'EDAPP'

					DbSelectArea('Z1H')
					Z1H->(DbSetOrder(1))
					If (Z1H->( dbSeek(xFilial('Z1H')+ Alltrim(_cCod)  )))
						While Z1H->(!Eof()) .And.   Z1H->Z1H_COD =  Alltrim(_cCod)

							FWrite(hdl,	'<Tables>'+ Alltrim(Z1H->Z1H_TABLES)   +'</Tables>'+cr)

							Z1H->(DbSkip())
						EndDo
					EndIf

				EndIf

				FWrite(hdl,	'<Access>xxxxxxxxxx</Access>'+cr)
				FWrite(hdl,	'<Module>'+ Padl(((cAliasLif)->Z1E_MODULO),2,'0')+'</Module>'+cr)
				FWrite(hdl,	'<Owner>0</Owner>'+cr)
				FWrite(hdl,	'</MenuItem>'+cr)


				(cAliasLif)->(dbSkip())
			End
		EndIf




		FWrite(hdl,	'</Menu>'+cr)
		FWrite(hdl,	'<Menu Status="Enable">'+cr)
		FWrite(hdl,	'<Title lang="pt">&Reembolso Financeiro</Title>'+cr)
		FWrite(hdl,	'<Title lang="es">Tecnologia da Informação</Title>'+cr)
		FWrite(hdl,	'<Title lang="en">Tecnologia da Informação</Title>'+cr)
		FWrite(hdl,	'<MenuItem Status="Enable">'+cr)
		FWrite(hdl,	'<Title lang="pt">Reembolso Financeiro</Title>'+cr)
		FWrite(hdl,	'<Title lang="es">Reembolso Financeiro</Title>'+cr)
		FWrite(hdl,	'<Title lang="en">Reembolso Financeiro</Title>'+cr)
		FWrite(hdl,	'<Function>STTELREEM</Function>'+cr)
		FWrite(hdl,	'<Type>03</Type>'+cr)
		FWrite(hdl,	'<Access>xxxxxxxxxx</Access>'+cr)
		FWrite(hdl,	'<Module>05</Module>'+cr)
		FWrite(hdl,	'<Owner>2</Owner>'+cr)
		FWrite(hdl,	'</MenuItem>'+cr)
		FWrite(hdl,	'</Menu>'+cr)



		FWrite(hdl,	'<Menu Status="Enable">'+cr)
		FWrite(hdl,	'<Title lang="pt">&T.I.</Title>'+cr)
		FWrite(hdl,	'<Title lang="es">Tecnologia da Informação</Title>'+cr)
		FWrite(hdl,	'<Title lang="en">Tecnologia da Informação</Title>'+cr)
		FWrite(hdl,	'<MenuItem Status="Enable">'+cr)
		FWrite(hdl,	'<Title lang="pt">Chamados Ti</Title>'+cr)
		FWrite(hdl,	'<Title lang="es">Chamados Ti</Title>'+cr)
		FWrite(hdl,	'<Title lang="en">Chamados Ti</Title>'+cr)
		FWrite(hdl,	'<Function>ST_CHAMA</Function>'+cr)
		FWrite(hdl,	'<Type>03</Type>'+cr)
		FWrite(hdl,	'<Access>xxxxxxxxxx</Access>'+cr)
		FWrite(hdl,	'<Module>05</Module>'+cr)
		FWrite(hdl,	'<Owner>2</Owner>'+cr)
		FWrite(hdl,	'</MenuItem>'+cr)
		FWrite(hdl,	'</Menu>'+cr)



		FWrite(hdl,	'</ApMenu>')


		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf




		FClose(_cMenu)
	EndIf

	//	EndIf



	msunlockall()
	RestArea(_aArea)
	//Reset Environment

Return ()





User Function STXNU(cNewEmp,cNewFil,_cCod)
	Local 	_aArea
	Local aDirImpor 		:= {}
	Local _Lret				:= .F.
	Local _cMenu    		:=	"\menu\"+ Alltrim(_cCod) + ".xnu"
	Local i 				:= 0
	Local _nCabec			:= 0
	Local _nMaxCabec	    := 25
	Local _cMen				:= '1'
	Private cPerg 			:= Alltrim(_cCod)+"STXNU"
	Private cTime           := ' '
	Private cHora           := ' '
	Private cMinutos    	:= ' '
	Private cSegundos   	:= ' '
	Private cAliasLif   	:= ' '
	Private cQuery     		:= ' '
	Private cr      := chr(13)+ chr(10)
	Private hdl

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	//If GetMv("ST_XNUST",,.T.)
	DbSelectArea("Z1F")
	DbSelectArea("Z1E")
	Z1F->(DbSetOrder(1))
	If Z1F->(DbSeek(xFilial("Z1F")+_cCod))


		_aArea		:= GetArea()

		aDirImpor := DIRECTORY( _cMenu )

		For i := 1 To Len(aDirImpor)

			FERASE("\menu\"+ aDirImpor[1,1])

		Next i

		If !(File(_cMenu))À
			hdl := FCreate(_cMenu, 0)
		Else
			hdl := FOpen(_cMenu, 1)
			FSeek(hdl,0,2)
		Endif





		cTime           := Time()
		cHora           := SUBSTR(cTime, 1, 2)
		cMinutos    	:= SUBSTR(cTime, 4, 2)
		cSegundos   	:= SUBSTR(cTime, 7, 2)
		cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos



		cQuery := " SELECT
		cQuery += "   Z1E_FUNCAO,
		cQuery += "   Z1E_DESC,
		cQuery += "   Z1E_MODULO,
		cQuery += "   Z1E_DESCMO
		cQuery += "  FROM "+RetSqlName("Z1F")+"  Z1F "



		cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("Z1G")+") Z1G "
		cQuery += "  ON Z1G.D_E_L_E_T_ = ' '
		cQuery += "  AND Z1G_COD = Z1F_COD
		cQuery += "  AND Z1G_HABILI = '1'

		cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("Z1E")+") Z1E "
		cQuery += "  ON Z1E.D_E_L_E_T_ = ' '
		cQuery += "  AND Z1E_FUNCAO = Z1G_FUNCAO

		cQuery += "  WHERE Z1F.D_E_L_E_T_ = ' '
		cQuery += "  AND Z1F_COD = '"+ Alltrim(_cCod)+" '




		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

		FWrite(hdl,	'<ApMenu>'+cr)
		FWrite(hdl,	'<DocumentProperties>'+cr)
		FWrite(hdl,	'<Module></Module>'+cr)
		FWrite(hdl,	'<Version>10.1</Version>'+cr)
		FWrite(hdl,	'</DocumentProperties>'+cr)
		FWrite(hdl,	'<Menu Status="Enable">'+cr)
		FWrite(hdl,	'<Title lang="pt">&Atualizações</Title>'+cr)
		FWrite(hdl,	'<Title lang="es">&Actualizaciones</Title>'+cr)
		FWrite(hdl,	'<Title lang="en">&Updates</Title>'+cr)

		If  Select(cAliasLif) > 0
			(cAliasLif)->(dbgotop())
			_nCabec	:= 0
			_cMen	:='1'
			While !(cAliasLif)->(Eof())

				//If (cAliasLif)->Z1E_POS = ' ' .Or. (cAliasLif)->Z1E_POS = '1'
					_nCabec	++
					If _nCabec > _nMaxCabec
						_nCabec			:= 1
						_cMen:= Soma1(_cMen)
						FWrite(hdl,	'</Menu>'+cr)
						FWrite(hdl,	'<Menu Status="Enable">'+cr)
						FWrite(hdl,	'<Title lang="pt">&Atualizações '+_cMen+'</Title>'+cr)
						FWrite(hdl,	'<Title lang="es">&Atualizações '+_cMen+'</Title>'+cr)
						FWrite(hdl,	'<Title lang="en">&Atualizações '+_cMen+'</Title>'+cr)
					EndIf

					FWrite(hdl,	'<MenuItem Status="Enable">'+cr)
					FWrite(hdl,	'<Title lang="pt">'+ Alltrim((cAliasLif)->Z1E_DESC)+'</Title>'+cr)
					FWrite(hdl,	'<Title lang="es">'+ Alltrim((cAliasLif)->Z1E_DESC)+'</Title>'+cr)
					FWrite(hdl,	'<Title lang="en">'+ Alltrim((cAliasLif)->Z1E_DESC)+'</Title>'+cr)
					FWrite(hdl,	'<Function>'+ Alltrim((cAliasLif)->Z1E_FUNCAO)+'</Function>'+cr)
					FWrite(hdl,	'<Type>'+ IiF(SUBSTR((cAliasLif)->Z1E_FUNCAO,1,2)=="ST" .OR. SUBSTR((cAliasLif)->Z1E_FUNCAO,1,6)=="RSTFAT",'3','1')+'</Type>'+cr)
					If Alltrim((cAliasLif)->Z1E_FUNCAO)  = 'EDAPP'

						DbSelectArea('Z1H')
						Z1H->(DbSetOrder(1))
						If (Z1H->( dbSeek(xFilial('Z1H')+ Alltrim(_cCod)  )))
							While Z1H->(!Eof()) .And.   Z1H->Z1H_COD =  Alltrim(_cCod)

								FWrite(hdl,	'<Tables>'+ Alltrim(Z1H->Z1H_TABLES)   +'</Tables>'+cr)

								Z1H->(DbSkip())
							EndDo
						EndIf

					EndIf

					FWrite(hdl,	'<Access>xxxxxxxxxx</Access>'+cr)
					FWrite(hdl,	'<Module>'+ Padl(((cAliasLif)->Z1E_MODULO),2,'0')+'</Module>'+cr)
					FWrite(hdl,	'<Owner>0</Owner>'+cr)
					FWrite(hdl,	'</MenuItem>'+cr)

				//EndIf
				(cAliasLif)->(dbSkip())
			End
		EndIf




		FWrite(hdl,	'</Menu>'+cr)
		FWrite(hdl,	'<Menu Status="Enable">'+cr)
		FWrite(hdl,	'<Title lang="pt">&Customizados</Title>'+cr)
		FWrite(hdl,	'<Title lang="es">&Customizados</Title>'+cr)
		FWrite(hdl,	'<Title lang="en">&Customizados</Title>'+cr)

		If  Select(cAliasLif) > 0
			(cAliasLif)->(dbgotop())
			_nCabec	:= 0
			_cMen	:='1'
			While !(cAliasLif)->(Eof())

				//If (cAliasLif)->Z1E_POS = '2'
					_nCabec	++
					If _nCabec > _nMaxCabec
						_nCabec			:= 1
						_cMen:= Soma1(_cMen)
						FWrite(hdl,	'</Menu>'+cr)
						FWrite(hdl,	'<Menu Status="Enable">'+cr)
						FWrite(hdl,	'<Title lang="pt">&Customizados '+_cMen+'</Title>'+cr)
						FWrite(hdl,	'<Title lang="es">&Customizados '+_cMen+'</Title>'+cr)
						FWrite(hdl,	'<Title lang="en">&Customizados '+_cMen+'</Title>'+cr)
					EndIf
					FWrite(hdl,	'<MenuItem Status="Enable">'+cr)
					FWrite(hdl,	'<Title lang="pt">'+ Alltrim((cAliasLif)->Z1E_DESC)+'</Title>'+cr)
					FWrite(hdl,	'<Title lang="es">'+ Alltrim((cAliasLif)->Z1E_DESC)+'</Title>'+cr)
					FWrite(hdl,	'<Title lang="en">'+ Alltrim((cAliasLif)->Z1E_DESC)+'</Title>'+cr)
					FWrite(hdl,	'<Function>'+ Alltrim((cAliasLif)->Z1E_FUNCAO)+'</Function>'+cr)
					FWrite(hdl,	'<Type>'+ IiF(SUBSTR((cAliasLif)->Z1E_FUNCAO,1,2)=="ST" .OR. SUBSTR((cAliasLif)->Z1E_FUNCAO,1,6)=="RSTFAT",'3','1')+'</Type>'+cr)
					If Alltrim((cAliasLif)->Z1E_FUNCAO)  = 'EDAPP'

						DbSelectArea('Z1H')
						Z1H->(DbSetOrder(1))
						If !(Z1H->( dbSeek(xFilial('Z1H')+ Alltrim(_cCod)  )))
							While Z1H->(!Eof()) .And.   Z1H->Z1H_COD =  Alltrim(_cCod)

								FWrite(hdl,	'<Tables>'+ Alltrim(Z1H->Z1H_TABLES)   +'</Tables>'+cr)

								Z1H->(DbSkip())
							EndDo
						EndIf

					EndIf
					FWrite(hdl,	'<Access>xxxxxxxxxx</Access>'+cr)
					FWrite(hdl,	'<Module>'+ Padl(((cAliasLif)->Z1E_MODULO),2,'0')+'</Module>'+cr)
					FWrite(hdl,	'<Owner>0</Owner>'+cr)
					FWrite(hdl,	'</MenuItem>'+cr)

				//EndIf
				(cAliasLif)->(dbSkip())
			End
		EndIf



		FWrite(hdl,	'</Menu>'+cr)
		FWrite(hdl,	'<Menu Status="Enable">'+cr)
		FWrite(hdl,	'<Title lang="pt">&Relatorios</Title>'+cr)
		FWrite(hdl,	'<Title lang="es">&Informes</Title>'+cr)
		FWrite(hdl,	'<Title lang="en">&Reports</Title>'+cr)

		If  Select(cAliasLif) > 0
			(cAliasLif)->(dbgotop())
			_nCabec	:= 0
			_cMen	:='1'
			While !(cAliasLif)->(Eof())

				//If (cAliasLif)->Z1E_POS = '3'
					_nCabec	++
					If _nCabec > _nMaxCabec
						_nCabec			:= 1
						_cMen:= Soma1(_cMen)
						FWrite(hdl,	'</Menu>'+cr)
						FWrite(hdl,	'<Menu Status="Enable">'+cr)
						FWrite(hdl,	'<Title lang="pt">&Relatorios '+_cMen+'</Title>'+cr)
						FWrite(hdl,	'<Title lang="es">&Relatorios '+_cMen+'</Title>'+cr)
						FWrite(hdl,	'<Title lang="en">&Relatorios '+_cMen+'</Title>'+cr)
					EndIf
					FWrite(hdl,	'<MenuItem Status="Enable">'+cr)
					FWrite(hdl,	'<Title lang="pt">'+ Alltrim((cAliasLif)->Z1E_DESC)+'</Title>'+cr)
					FWrite(hdl,	'<Title lang="es">'+ Alltrim((cAliasLif)->Z1E_DESC)+'</Title>'+cr)
					FWrite(hdl,	'<Title lang="en">'+ Alltrim((cAliasLif)->Z1E_DESC)+'</Title>'+cr)
					FWrite(hdl,	'<Function>'+ Alltrim((cAliasLif)->Z1E_FUNCAO)+'</Function>'+cr)
					FWrite(hdl,	'<Type>'+ IiF(SUBSTR((cAliasLif)->Z1E_FUNCAO,1,2)=="ST" .OR. SUBSTR((cAliasLif)->Z1E_FUNCAO,1,6)=="RSTFAT",'3','1')+'</Type>'+cr)
					If Alltrim((cAliasLif)->Z1E_FUNCAO)  = 'EDAPP'

						DbSelectArea('Z1H')
						Z1H->(DbSetOrder(1))
						If !(Z1H->( dbSeek(xFilial('Z1H')+ Alltrim(_cCod)  )))
							While Z1H->(!Eof()) .And.   Z1H->Z1H_COD =  Alltrim(_cCod)

								FWrite(hdl,	'<Tables>'+ Alltrim(Z1H->Z1H_TABLES)   +'</Tables>'+cr)

								Z1H->(DbSkip())
							EndDo
						EndIf

					EndIf
					FWrite(hdl,	'<Access>xxxxxxxxxx</Access>'+cr)
					FWrite(hdl,	'<Module>'+ Padl(((cAliasLif)->Z1E_MODULO),2,'0')+'</Module>'+cr)
					FWrite(hdl,	'<Owner>0</Owner>'+cr)
					FWrite(hdl,	'</MenuItem>'+cr)

				//EndIf
				(cAliasLif)->(dbSkip())
			End
		EndIf


		FWrite(hdl,	'</Menu>'+cr)
		FWrite(hdl,	'<Menu Status="Enable">'+cr)
		FWrite(hdl,	'<Title lang="pt">&Miscelanea</Title>'+cr)
		FWrite(hdl,	'<Title lang="es">&Miscelanea</Title>'+cr)
		FWrite(hdl,	'<Title lang="en">&Miscellaneous</Title>'+cr)
		FWrite(hdl,	'</Menu>'+cr)


		FWrite(hdl,	'<Menu Status="Enable">'+cr)
		FWrite(hdl,	'<Title lang="pt">&Tecnologia da Informação</Title>'+cr)
		FWrite(hdl,	'<Title lang="es">Tecnologia da Informação</Title>'+cr)
		FWrite(hdl,	'<Title lang="en">Tecnologia da Informação</Title>'+cr)
		FWrite(hdl,	'<MenuItem Status="Enable">'+cr)
		FWrite(hdl,	'<Title lang="pt">Chamados Ti</Title>'+cr)
		FWrite(hdl,	'<Title lang="es">Chamados Ti</Title>'+cr)
		FWrite(hdl,	'<Title lang="en">Chamados Ti</Title>'+cr)
		FWrite(hdl,	'<Function>ST_CHAMA</Function>'+cr)
		FWrite(hdl,	'<Type>03</Type>'+cr)
		FWrite(hdl,	'<Access>xxxxxxxxxx</Access>'+cr)
		FWrite(hdl,	'<Module>05</Module>'+cr)
		FWrite(hdl,	'<Owner>2</Owner>'+cr)
		FWrite(hdl,	'</MenuItem>'+cr)
		FWrite(hdl,	'</Menu>'+cr)



		FWrite(hdl,	'</ApMenu>')


		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf




		FClose(_cMenu)

	EndIf
	//	EndIf



	msunlockall()
	RestArea(_aArea)
	Reset Environment

Return ()



User Function STZ1E()

	Private cCadastro := "Cadastro de ROTINAS"
	Private cAlias := "Z1E"
	Private aRotina := {{ "Pesquisar"  , "PesqBrw" ,  0 , 1 },;
		{ "Visualizar" , "AxVisual" , 0 , 2 },;
		{ "Incluir"    , "AxInclui" , 0 , 3 },;
		{ "Alterar"    , "AXaltera" , 0 , 4 },;
		{ "Excluir"    , "AxDeleta" , 0 , 5 }}

	dbSelectArea(cAlias)
	dbSetOrder(1)

	mBrowse(,,,,cAlias)

Return()
User Function STZ1F()

	Private cCadastro := "USUARIOS X ROTINAS"
	Private cAlias := "Z1F"
	Private aRotina := {{ "Pesquisar"  , "PesqBrw" ,  0 , 1 },;
		{ "Visualizar" , "AxVisual" , 0 , 2 },;
		{ "Incluir"    , "AxInclui" , 0 , 3 },;
		{ "Alterar"    , "AXaltera" , 0 , 4 },;
		{ "Excluir"    , "AxDeleta" , 0 , 5 }}

	dbSelectArea(cAlias)
	dbSetOrder(1)

	mBrowse(,,,,cAlias)

Return()
User Function STZ1G()

	Private cCadastro := "USUARIOS X ROTINAS"
	Private cAlias := "Z1G"
	Private aRotina := {{ "Pesquisar"  , "PesqBrw" ,  0 , 1 },;
		{ "Visualizar" , "AxVisual" , 0 , 2 },;
		{ "Incluir"    , "AxInclui" , 0 , 3 },;
		{ "Alterar"    , "AXaltera" , 0 , 4 },;
		{ "Excluir"    , "AxDeleta" , 0 , 5 }}

	dbSelectArea(cAlias)
	dbSetOrder(1)

	mBrowse(,,,,cAlias)

Return()
User Function STZ1H()

	Private cCadastro := "USUARIOS X GENERICOS"
	Private cAlias := "Z1H"
	Private aRotina := {{ "Pesquisar"  , "PesqBrw" ,  0 , 1 },;
		{ "Visualizar" , "AxVisual" , 0 , 2 },;
		{ "Incluir"    , "AxInclui" , 0 , 3 },;
		{ "Alterar"    , "AXaltera" , 0 , 4 },;
		{ "Excluir"    , "AxDeleta" , 0 , 5 }}

	dbSelectArea(cAlias)
	dbSetOrder(1)

	mBrowse(,,,,cAlias)

Return()

	*-----------------------------*
User Function Z1EINSERT()
	*-----------------------------*
	Local	_cRot	:=' '
	Local	_aCod	:= {}
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'





	Dbselectarea("Z1B")

	Z1B->(DbSetOrder(2))
	Z1B->(DbGoTop())

	While Z1B->(!Eof())


		_cRot:=  UPPER(ALLTRIM(Z1B->Z1B_NOMERO ))
		If '[' $ _cRot
			_aCod	:= {}
			_aCod   := StrTokArr( _cRot, '[' )

			_cRot:= _aCod[1]

			Z1B->(RecLock("Z1B",.F.) )
			Z1B->Z1B_NOMERO  		:=	_cRot
			Z1B->(MsUnlock())
			Z1B->(DbCommit())
		EndIf


		DbSelectArea('Z1E')
		Z1E->(DbSetOrder(1))

		If !(Z1E->( dbSeek(xFilial('Z1E')+  ALLTRIM(Z1B->Z1B_ROTINA) )))

			If !(Z1E->( dbSeek(xFilial('Z1E')+  SUBSTR(ALLTRIM(Z1B->Z1B_ROTINA) ,3,LEN(ALLTRIM(Z1B->Z1B_ROTINA))))))

				Z1E->(RecLock("Z1E",.T.) )
				Z1E->Z1E_FUNCAO		:=	Iif (substr(UPPER(ALLTRIM(Z1B->Z1B_ROTINA)),1,2) = 'U_',substr(UPPER(ALLTRIM(Z1B->Z1B_ROTINA)),3,10),UPPER(ALLTRIM(Z1B->Z1B_ROTINA)))
				Z1E->Z1E_MODULO  	:=	substr(UPPER(ALLTRIM(Z1B->Z1B_NOMERO )),1,2)
				//Z1E->Z1E_PC	  		:=	substr(UPPER(ALLTRIM(Z1B->Z1B_NOMERO )),3,1)
				Z1E->Z1E_DESC  		:=	substr(UPPER(ALLTRIM(Z1B->Z1B_NOMERO )),4,50)

				Z1E->(MsUnlock())
				Z1E->(DbCommit())

			EndIf

			DbSelectArea('Z1G')
			Z1G->(DbSetOrder(1))

			If !(Z1G->( dbSeek(xFilial('Z1G')+ Z1B->Z1B_USUARI + ALLTRIM(Z1E->Z1E_FUNCAO) )))
				Z1G->(RecLock("Z1G",.T.) )

				Z1G->Z1G_COD  	 :=  Z1B->Z1B_USUARI
				Z1G->Z1G_FUNCAO	  	:= ALLTRIM(Z1E->Z1E_FUNCAO)
				Z1G->Z1G_DESC	  	:= UPPER(Alltrim(Z1E->Z1E_DESC	))
				Z1G->Z1G_HABILI	  	:='1'

				Z1G->(MsUnlock())
				Z1G->(DbCommit())


			EndIf

		Else
			DbSelectArea('Z1G')
			Z1G->(DbSetOrder(1))
			If !(Z1G->( dbSeek(xFilial('Z1G')+ Z1B->Z1B_USUARI + Iif (substr(UPPER(ALLTRIM(Z1B->Z1B_ROTINA)),1,2) = 'U_',substr(UPPER(ALLTRIM(Z1B->Z1B_ROTINA)),3,10),UPPER(ALLTRIM(Z1B->Z1B_ROTINA))) )))

				Z1G->(RecLock("Z1G",.T.) )

				Z1G->Z1G_COD  	 :=  Z1B->Z1B_USUARI
				Z1G->Z1G_FUNCAO	  	:= Iif (substr(UPPER(ALLTRIM(Z1B->Z1B_ROTINA)),1,2) = 'U_',substr(UPPER(ALLTRIM(Z1B->Z1B_ROTINA)),3,10),UPPER(ALLTRIM(Z1B->Z1B_ROTINA)))
				Z1G->Z1G_DESC	  	:= UPPER(Alltrim(Z1E->Z1E_DESC	))
				Z1G->Z1G_HABILI	  	:='1'

				Z1G->(MsUnlock())
				Z1G->(DbCommit())


			EndIf

		EndIf

		DbSelectArea('Z1F')
		Z1F->(DbSetOrder(1))
		If !(Z1F->( dbSeek(xFilial('Z1F')+ Z1B->Z1B_USUARI   )))

			Z1F->(RecLock("Z1F",.T.) )

			Z1F->Z1F_COD  	 :=  Z1B->Z1B_USUARI
			Z1F->Z1F_NOME  	 :=  Z1B->Z1B_NOME
			Z1F->Z1F_DEPART	 := Alltrim(Z1B->Z1B_DEPART)


			Z1F->(MsUnlock())
			Z1F->(DbCommit())


		EndIf



		Z1B->(DbSkip())

	EndDo

Return()


//User Function ESPnome()

//Return()//"steck"



User Function STMENU()
	Local aCoors := FWGetDialogSize( oMainWnd )
	Local oLayerTabFrete, oLayerNeg
	Local oDialog061
	Local oRelacZ1F
	Private oBrwTabFrete, oBrwNeg
	Private cCadastro := "USUARIOS"

	Z1E->(dbClearFilter())
	Z1E->(dbGoTop())

	Z1F->(dbClearFilter())
	Z1F->(dbGoTop())

	Define MsDialog oDialog061 Title "Menu" From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel
	/* -- Layers -------------------------------------------------- */
/*
	oFWLayer := FWLayer():New()
	oFWLayer:Init(oDialog061, .F., .T.)

	// Tabela de Frete
	oFWLayer:AddLine('TOP', 50, .F.)
	oFWLayer:AddCollumn('ROTINAS', 100, .T., 'TOP') // Tabela de Frete
	oLayerTabFrete := oFWLayer:GetColPanel('ROTINAS', 'TOP')

	// Negociação
	oFWLayer:AddLine('BOTTON', 50, .F.)
	oFWLayer:AddCollumn('USUARIOS', 100, .T., 'BOTTON') // Negociação
	oLayerNeg := oFWLayer:GetColPanel('USUARIOS', 'BOTTON')

	/* -- Browse -------------------------------------------------- */
/*
	oBrwTabFrete := FWMBrowse():New()
	oBrwTabFrete:SetAlias('Z1E')
	oBrwTabFrete:SetOwner(oLayerTabFrete)
	oBrwTabFrete:SetDescription("MENUS")
	oBrwTabFrete:DisableDetails()
	oBrwTabFrete:SetFilterDefault("Z1E->Z1E_FILIAL == xFilial('Z1E')")
	oBrwTabFrete:SetMenuDef("STMENU")
	oBrwTabFrete:SetProfileID("1")
	oBrwTabFrete:SetAmbiente(.F.)
	oBrwTabFrete:SetWalkthru(.F.)
	oBrwTabFrete:SetSeeAll(.F.)

	oBrwNeg := FWMBrowse():New()
	oBrwNeg:SetAlias('Z1F')
	oBrwNeg:SetOwner(oLayerNeg)
	oBrwNeg:SetDescription("Usuarios")
	oBrwNeg:DisableDetails()
	oBrwNeg:SetFilterDefault("Z1F->Z1F_FILIAL == xFilial('Z1F')")
	oBrwNeg:SetMenuDef("STMENUA")
	oBrwNeg:AddButton("Alterar",{|| u_MENU2AL() },,4,,.F.)
	oBrwNeg:AddButton("Incluir",{|| u_MENU2IN() },,3,,.F.)
	oBrwNeg:AddButton("Excluir",{|| u_MENU2EX() },,2,,.F.)
	oBrwNeg:ForceQuitButton(.T.)
	oBrwNeg:SetProfileID("2")
	oBrwNeg:SetAmbiente(.F.)
	oBrwNeg:SetWalkthru(.F.)
	oBrwNeg:SetSeeAll(.F.)

	//O relacionamento deve ser feito e ativado após criar os browses e definir o alias mas antes de ativá-los;
	oRelacZ1F:= FWBrwRelation():New()
	oRelacZ1F:AddRelation(oBrwTabFrete, oBrwNeg, {{'Z1F_FILIAL', 'Z1E_FILIAL'}})
	oRelacZ1F:Activate()

	//Ativar os grids após o relation para exibir o primeiro registro da tabela pai e os filhos corretamente.
	//Os dois activates são necessários para o caso de inclusão via menu do protheus.
	//Caso contrário, após fechar a tela de inclusão o grid da tabela pai não é exibido.
	oBrwTabFrete:Activate()
	oBrwTabFrete:UpdateBrowse()
	oBrwTabFrete:Activate()

	oBrwNeg:Activate()

	//	oBrwNeg:DelColumn(1)
	//	oBrwNeg:DelColumn(2)
	//	oBrwNeg:DelColumn(3)
	//	oBrwNeg:DelColumn(4)
	oBrwNeg:UpdateBrowse() //Para atualizar após a exclusão das colunas

	oBrwTabFrete:UpdateBrowse() //Para dar foco no grid de tabelas.

	Activate MsDialog oDialog061 Center

Return



Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina TITLE "Incluir" 			ACTION "axinclui" OPERATION 3  ACCESS 0 		// "Incluir"
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "axvisual" OPERATION 2  ACCESS 0 		// "Visualizar"
	ADD OPTION aRotina TITLE "Alterar" 			ACTION "axaltera" OPERATION 4  ACCESS 0 		// "Alterar"
	ADD OPTION aRotina TITLE "Excluir" 			ACTION "AxDeleta" OPERATION 5  ACCESS 0 		// "Excluir"

Return aRotina



User Function MENU2IN()

	FWExecView("INCLUIR",'STMENU2', MODEL_OPERATION_INSERT, , {|| .T. },{|| .T.},,,{|| .T.})

	Z1F->(dbClearFilter())

	oBrwTabFrete:Refresh()
	oBrwNeg:Refresh()
Return


User Function MENU2AL()

	FWExecView("ALTERAR",'STMENU2', MODEL_OPERATION_UPDATE, , {|| .T. },{|| .T.},,,{|| .T.})

	oBrwTabFrete:Refresh()
	oBrwNeg:Refresh()
Return



User Function MENU2EX()
	oBrwTabFrete:Refresh()
	oBrwNeg:Refresh()

	FWExecView("EXCLUIR",'STMENU2', MODEL_OPERATION_DELETE, , {|| .T. },{|| .T.},,,{|| .T.})

	oBrwTabFrete:Refresh()
	oBrwNeg:Refresh()
Return



Static Function CMODL(_cMod)
	Local   _cRet := 'Outros'

	Default _cMod := '01'


	If _cMod = '01'
		_cRet := 'Ativo Fixo'
	ElseIf _cMod = '02'
		_cRet := 'Compras'
	ElseIf _cMod = '04'
		_cRet := 'Estoque'
	ElseIf _cMod = '05'
		_cRet := 'Faturamento'
	ElseIf _cMod = '06'
		_cRet := 'Financeiro'
	ElseIf _cMod = '07'
		_cRet := 'Gestao Pessoal'
	ElseIf _cMod = '09'
		_cRet := 'Livros Fiscais'
	ElseIf _cMod = '10'
		_cRet := 'PCP'
	ElseIf _cMod = '13'
		_cRet := 'Call Center'
	ElseIf _cMod = '16'
		_cRet := 'Ponto Eletronico'
	ElseIf _cMod = '17'
		_cRet := 'EIC'
	ElseIf _cMod = '18'
		_cRet := 'Consulta Funcionario'
	ElseIf _cMod = '19'
		_cRet := 'Manut.Ativos'
	ElseIf _cMod = '21'
		_cRet := 'Inspecao de Entrada'
	ElseIf _cMod = '24'
		_cRet := 'Controle de Docuentos'
	ElseIf _cMod = '25'
		_cRet := 'Inspecao de Processos'
	ElseIf _cMod = '26'
		_cRet := 'Treinamento'
	ElseIf _cMod = '29'
		_cRet := 'EEC'
	ElseIf _cMod = '34'
		_cRet := 'Contabilidade'
	ElseIf _cMod = '35'
		_cRet := 'Medicina e Seguranca'
	ElseIf _cMod = '36'
		_cRet := 'Nao Conformidades'
	ElseIf _cMod = '40'
		_cRet := 'Cargos e Salarios'
	ElseIf _cMod = '42'
		_cRet := 'WMS'
	ElseIf _cMod = '44'
		_cRet := 'PMS'
	ElseIf _cMod = '70'
		_cRet := 'Arquitetura Organizacional'
	ElseIf _cMod = '78'
		_cRet := 'GFE'
	ElseIf _cMod = '84'
		_cRet := 'TAF'
	EndIf

Return (_cRet)

*/





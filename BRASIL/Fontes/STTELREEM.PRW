#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "TBICONN.CH"
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | STTELREEM          | Autor | GIOVANI.ZAGO            | Data | 22/05/2017 |
|=====================================================================================|
|Sintaxe   | STTELREEM                                                                |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================
*/
*----------------------------------*
User Function STTELREEM()
	*----------------------------------*
	Local oBrowse2
	Private _UserMvc	:= GetMv('ST_TELREEM',,'000000/000645')
	Private _UserFIN 	:= AllTrim(GetMv('ST_REEFIN',,'000000/000645/000904/000714/000216'))+AllTrim(GetMv('ST_REEFIN1',,''))
	Private _UserLv 	:= GetMv('ST_REELV',,'000243')
	Private _UserVs 	:= GetMv('ST_REEVS',,'000582')
	Private _lPartic 	:= .T.
	Private _xSuper   	:= ' '
	Private _nVrDesc	:= 0
	Private _cGetMDe	:= Space(200)

	Public _cFarol    	:= .f.

	If GetMv("STTELREEM0",,.T.)
		If cEmpAnt=="01" .And. !cFilAnt=="05"
			MsgAlert("Rotina desativada para essa empresa/filial!")
			Return
		EndIf
	EndIf

	If !__cUserId $ _UserFIN
		// Se o usuario nao for um aproivador, é um solicitante ...

		If !(SA1PRT(__cUserId))
			If cEmpAnt $ "7x8"
				MsgInfo(" Atención. Solicite al Departamento Financiero que registre su código Protheus: '" 	+ __cUserId + "', para usar esta rutina...")
			Else
				MsgInfo(" Atenção. Solicite ao Departamento Financeiro o cadastro de seu codigo protheus: '" 	+ __cUserId + "', no cadastro de fornecedor, para utilizar esta Rotina....!!!!")
			EndIf
		EndIf
	Endif

	_xSuper   := u_Super()

	DbSelectArea("Z1O")
	Z1O->(DbSetOrder(1))

	If __cUserId $ '001292'
		Z1O->(dbSetFilter({|| Z1O->Z1O_USER = __cUserId .Or.  ( Z1O->Z1O_USER $ _xSuper .And. Z1O_STATUS <> "1" ) .Or. Z1O->Z1O_STATUS = "5"  },'Z1O->Z1O_USER = __cUserId  .Or.  ( Z1O->Z1O_USER $ _xSuper .And. Z1O_STATUS <> "1" ) .OR. Z1O->Z1O_STATUS = "5"  '))
	Else
		If __cUserId $ _UserFIN .And. !( __cUserId $_UserMvc)
			Z1O->(dbSetFilter({|| Z1O->Z1O_USER = __cUserId .Or.   Z1O_STATUS = "3" .Or.   Z1O_STATUS = "4"  },'Z1O->Z1O_USER = __cUserId  .Or. Z1O_STATUS = "3" .Or.   Z1O_STATUS = "4" '))
		ElseIf   __cUserId $ _UserLv .And. __cUserId $ _UserVs //Klecios e tereza
			Z1O->(dbSetFilter({|| Z1O->Z1O_USER = __cUserId .Or. Z1O->Z1O_USER = "001256" .Or. Z1O->Z1O_USER = "001170"  },' Z1O->Z1O_USER = __cUserId .Or. Z1O->Z1O_USER = "001256" .Or. Z1O->Z1O_USER = "001170"  '))
		ElseIf   __cUserId $ _UserLv
			Z1O->(dbSetFilter({|| Z1O->Z1O_USER = __cUserId .Or. Z1O->Z1O_USER = "001256"  },' Z1O->Z1O_USER = __cUserId .Or. Z1O->Z1O_USER = "001256"  '))
		ElseIf   __cUserId $ _UserVs
			Z1O->(dbSetFilter({|| Z1O->Z1O_USER = __cUserId .Or. Z1O->Z1O_USER = "001170"  },' Z1O->Z1O_USER = __cUserId .Or. Z1O->Z1O_USER = "001170"  '))
		ElseIf  !( __cUserId $_UserMvc)
			Z1O->(dbSetFilter({|| Z1O->Z1O_USER = __cUserId .Or.  ( Z1O->Z1O_USER $ _xSuper .And. Z1O_STATUS = "2" )  },'Z1O->Z1O_USER = __cUserId  .Or.  ( Z1O->Z1O_USER $ _xSuper .And. Z1O_STATUS = "2" )  '))
		EndIF
	EndIF

	oBrowse2 := FWMBrowse():New()
	oBrowse2:SetAlias("Z1O")				// Alias da tabela utilizada
	oBrowse2:SetMenuDef("STTELREEM")		// Nome do fonte onde esta a função MenuDef
	oBrowse2:SetDescription("Solicitação") 	// Descrição do browse
	oBrowse2:AddLegend(" Z1O_STATUS = '1'   "  ,"GREEN"         ,"Em Aberto")
	oBrowse2:AddLegend(" Z1O_STATUS = '2'   "  ,"YELLOW"      	,"Aprovacao Gestor")
	oBrowse2:AddLegend(" Z1O_STATUS = '5'   "  ,"PINK"      	,"Aprovacao Gestor(2ºNivel)")
	oBrowse2:AddLegend(" Z1O_STATUS = '3'   "  ,"BLUE"        	,"Aprovacao Financeiro")
	oBrowse2:AddLegend(" Z1O_STATUS = '4'   "  ,"RED"      		,"Finalizado")

	oBrowse2:SetUseCursor(.T.)

	oBrowse2:Activate()

Return(Nil)

Static Function SA1PRT(_cUssr)
	Local cQuery  	  := " "
	Local cPerg       := 'SA1PRT'
	Local cTime       := Time()
	Local cHora       := SUBSTR(cTime, 1, 2)
	Local cMinutos    := SUBSTR(cTime, 4, 2)
	Local cSegundos   := SUBSTR(cTime, 7, 2)
	Local cAliasLif   := cPerg+cHora+ cMinutos+cSegundos
	Local _lRet  	  := .F.

	cQuery := "  SELECT A2_XCODUSR
	cQuery += "  FROM  "+RetSqlName("SA2")+"  SA2 "
	cQuery += "  WHERE SA2.D_E_L_E_T_ = ' '
	cQuery += "  AND A2_XCODUSR = '"+_cUssr+"'

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		If  (cAliasLif)->A2_XCODUSR = _cUssr
			_lRet:= .T.
		EndIf
	EndIf

Return(_lRet)

User Function Super(_cUsz)
	Local _cCod  := ''

	DbSelectArea('Z1M')
	Z1M->(DbSetOrder(2))
	Z1M->(DbGoTop())

	If Z1M->(dbSeek(xFilial("Z1M")+__cUserId))
		DbSelectArea('Z1N')
		Z1N->(DbSetOrder(1))
		Z1N->(DbGoTop())

		While Z1N->(!eof())
			If Z1N->Z1N_COD = Z1M->Z1M_COD
				_cCod+=Z1N->Z1N_USER+"/"
			EndIf
			Z1N->(Dbskip())
		End

	EndIf

return(_cCod)

Static Function MenuDef()
	Local aRotina := {}
	//-------------------------------------------------------
	// Adiciona botões do browse
	//-------------------------------------------------------

	ADD OPTION aRotina TITLE "Visualizar" 	ACTION "U_REEVI" 	OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Alterar"    	ACTION "U_REEAL" 	OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    	ACTION "U_REEEX" 	OPERATION 5 ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Incluir"    	ACTION "U_REEIN" 	OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Anexo"  		ACTION "U_STANEX(.t.)" 	OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Aprovar"  	ACTION "U_STAPREM" 	OPERATION 2 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Rejeitar"  	ACTION "U_STREREM" 	OPERATION 2 ACCESS 0 //"Incluir"	STREREM
	ADD OPTION aRotina TITLE "Politica"  	ACTION "U_STSX5REEM" 	OPERATION 2 ACCESS 0 //"Incluir" STSX5REEM
	ADD OPTION aRotina TITLE "Impressão"  ACTION "U_RSTFATC4()" OPERATION 9 ACCESS 0 //"Imprimir"

Return aRotina

User Function REEIN()

	FWExecView("INCLUIR",'STREEMBOLSO', MODEL_OPERATION_INSERT, , {|| .T. },{|| .T.},,,{|| .T.})
	RETOT()
Return

User Function REEAL()
	If (Z1O->Z1O_USER = __cUserId .Or.  __cUserId $ _UserLv) .And. Z1O->Z1O_STATUS = '1'
		FWExecView("AVALIAR",'STREEMBOLSO', MODEL_OPERATION_UPDATE, , {|| .T. },{|| .T.},,,{|| .T.})
	Else
		MsgInfo("Somente o usuario pode Alterar a Solicitação...!!!!")
	EndIf
	RETOT()
Return

User Function REEEX()
	If  (Z1O->Z1O_USER = __cUserId .Or.  __cUserId $ _UserLv) .And. Z1O->Z1O_STATUS = '1'
		FWExecView("EXCLUIR",'STREEMBOLSO', MODEL_OPERATION_DELETE, , {|| .T. },{|| .T.},,,{|| .T.})
	Else
		MsgInfo("Somente o usuario pode Excluir a Solicitação...!!!!")
	EndIf
	RETOT()
Return

User Function REEVI()

	FWExecView("VISUALIZAR",'STREEMBOLSO', MODEL_OPERATION_VIEW, , {|| .T. },{|| .T.},,,{|| .T.})

	RETOT()
Return

Static Function RETOT()

	Local _cTp		:= 'R'
	Local 	cQry 	:= " UPDATE " + RetSqlName("Z1O" ) + " Z1O SET Z1O_TOTAL = nvl((SELECT SUM(nvl(Z1P_VALOR,0)) FROM " + RetSqlname("Z1P") + " Z1P WHERE Z1P.D_E_L_E_T_ = ' ' AND Z1P_COD = Z1O_COD),0) WHERE Z1O.D_E_L_E_T_ = ' ' "

	TcSQLExec(cQry)

	//		cQry 	:= " UPDATE " + RetSqlName("Z1O") + " Z1O SET Z1O_TOTAL = nvl((SELECT SUM(nvl(Z1P_VALOR,0)) FROM " + RetSqlName("Z1P") + " Z1P WHERE Z1P.D_E_L_E_T_ = ' ' AND Z1P_COD = Z1O_COD),0) WHERE Z1O.D_E_L_E_T_ = ' ' "
	//TcSQLExec(cQry)

	DbSelectArea('Z1P')
	Z1P->(DbSetOrder(1))

	If Z1P->(dbSeek(xFilial("Z1P")+Z1O->Z1O_COD))
		If Z1P->Z1P_TIPO = 'A'
			_cTp:= 'S'
		ElseIf Z1P->Z1P_TIPO = '9'
			_cTp:= 'A'
		EndIf

		RecLock("Z1O", .F.)
		Z1O->Z1O_TP    := _cTp
		Z1O->(MsUnlock())
		Z1O->(DbCommit())
	EndIf

Return

User Function STAPREM(aAprova, cObsRep, cRefError)
	Local _cMsgSave	:= ' '
	Local _cPara 	:= ' '
	Local _cCop 	:= ' '
	Local _UserFIN  := GetMv('ST_REEFIN',,'000000/000645/000904/000714/000216')+AllTrim(GetMv('ST_REEFIN1',,''))
	Local _LiApro   := GetMv('ST_STAPREM',,800)
	Local _l05 		:= .F.

	If IsInCallStack("U_ZAPVZ1OP")
		Z1O->(DbGoTo(Val(aAprova[1])))
	EndIf

	If Z1O->Z1O_STATUS = '1'
		If	MsgYesNo("Deseja enviar para Aprovação do Gestor ?")
			_cMsgSave += "===================================" +CR
			_cMsgSave += "Enviado Para Aprovação do Gestor. " +CR
			_cMsgSave += "Usuário: "+cUserName+CR
			_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

			DbSelectArea('Z1N')
			Z1N->(DbSetOrder(1))
			Z1N->(DbGoTop())

			While Z1N->(!eof())
				If Z1N->Z1N_USER = Z1O->Z1O_USER
					DbSelectArea('Z1M')
					Z1M->(DbSetOrder(1))
					If Z1M->(dbSeek(xFilial("Z1M")+Z1N->Z1N_COD))
						_cPara+=  UsrRetMail(Z1M->Z1M_APRO) +';'
					EndIf
				EndIf

				Z1N->(Dbskip())
			End

			_cCop 		:=  UsrRetMail(Z1O->Z1O_USER)

			STWFRE("Reembolso de Despesa: " + Z1O->Z1O_COD + ", Enviado para Aprovação do Gestor.",_cPara,_cCop)

			RecLock("Z1O", .F.)
			Z1O->Z1O_LOG    :=  _cMsgSave + CR + Z1O->Z1O_LOG
			Z1O->Z1O_STATUS := '2'
			Z1O->(MsUnlock())
			Z1O->(DbCommit())

		EndIf

	ElseIf Z1O->Z1O_STATUS = '2'

		If IsInCallStack("U_ZAPVZ1OP")
			STAPREM1()
			Return
		EndIf

		_xSuper   := u_Super()

		If !(Z1O->Z1O_USER $ _xSuper)
			MsgInfo("Voce nao é o aprovador desta Solicitação!!!!!!!")
		Else
			If !IsBlind()
				If	MsgYesNo("Deseja enviar para Aprovação do Financeiro ?")
					STAPREM1()
				EndIf
			EndIf
		EndIf
	ElseIf Z1O->Z1O_STATUS = '3'

		If !(__cUserId $ _UserFIN)
			MsgInfo("Voce nao é o aprovador Financeiro!!!!!!!")
		Else
			//>> Chamado 008686 - Everson Santana - 20/12/18
			If  Z1O_XFIL <> cFilAnt

				MsgInfo("Você não esta logado na filial de origem do reembolso!")

			Else
				If	MsgYesNo("Deseja enviar para Pagamento ?")

					If	MsgYesNo("Deseja aplicar algum desconto ?")
						_cGetMDe := STReDesc()
					Else
						_cGetMDe := ""
					Endif

					_cMsgSave += "===================================" +CR
					_cMsgSave += "Enviado Para Pagamento. " +CR
					_cMsgSave += "Usuário: "+cUserName+CR
					_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

					_cCop 		:=  UsrRetMail(Z1O->Z1O_USER)

					RecLock("Z1O", .F.)
					Z1O->Z1O_LOG    :=  _cMsgSave + CR + Z1O->Z1O_LOG
					Z1O->Z1O_OBS3	:=  Alltrim(Z1O->Z1O_OBS3) + _cGetMDe
					Z1O->Z1O_DESC	:=  _nVrDesc
					Z1O->(MsUnlock())
					Z1O->(DbCommit())

					STWFRE("Reembolso de Despesa: "+Z1O->Z1O_COD+", Enviado para Pagamento do Financeiro.",_cPara,_cCop)
					u_GerReemb()

				EndIf
			Endif
		EndIf
	ElseIf Z1O->Z1O_STATUS = '4'

		MsgInfo("Reembolso ja Finalizado")

	ElseIf Z1O->Z1O_STATUS = '5'
		If __cuserId = '001292'

			If	MsgYesNo("Deseja enviar para Aprovação do Financeiro ?")
				_cMsgSave += "===================================" +CR
				_cMsgSave += "Enviado Para Aprovação do Financeiro. " +CR
				_cMsgSave += "Usuário: "+cUserName+CR
				_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR
				_cCop 		:=  UsrRetMail(Z1O->Z1O_USER)

				If cEmpAnt == '07' //Everson Santana - 05/12/18
					_cPara:= " Carolina.Centurion@steckgroup.com;claudia.ferreira@steck.com.br  "
				Else
					_cPara:= GetMv('ST_REEREJ',," eduardo.brambilla@se.com ; jussara.silva@steck.com.br   ; lilia.lima@steck.com.br") //" Eduardo.santos@steck.com.br ; jussara.silva@steck.com.br   ; lilia.lima@steck.com.br"
				EndIF

				STWFRE("Reembolso de Despesa: "+Z1O->Z1O_COD+", Enviado para Aprovação do Financeiro.",_cPara,_cCop)

				RecLock("Z1O", .F.)
				Z1O->Z1O_LOG    :=  _cMsgSave + CR + Z1O->Z1O_LOG
				Z1O->Z1O_STATUS := '3'
				Z1O->(MsUnlock())
				Z1O->(DbCommit())

			EndIf
		Else
			MsgInfo("Apenas o Vanderlei pode Aprovar esta Reembolso...!!!!!")
		EndIf
	EndIf

Return

	*---------------------------------------------------*
Static Function STUnitTel()
	*---------------------------------------------------*

	Local oDlgEmail
	Local _nVal       :=  1
	Local lSaida      := .F.
	Local nOpca       :=  0

	Do While !lSaida
		nOpcao := 0
		DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Digite a Taxa de Conversao") From  1,0 To 80,200 Pixel OF oMainWnd

		@ 02,04 SAY "Valor:" PIXEL OF oDlgEmail
		@ 12,04 MSGet _nVal picture "@E 999,999.99999"   Size 55,013  PIXEL OF oDlgEmail valid _nVal > 0
		@ 12,62 Button "Ok"      Size 28,13 Action iif(_nVal>0,Eval({||lSaida:=.T.,nOpca:=1,oDlgEmail:End()}),msginfo("Valor Deve Ser Maior Que 0"))  Pixel

		ACTIVATE MSDIALOG oDlgEmail CENTERED
	EndDo

Return(round(_nVal,5))

User Function STREREM(aAprova, cObsRep, cRefError)
	Local	_cMsgSave	:= ' '
	Local   _cPara 		:= ' '
	Local   _cCop 		:= ' '
	Local  _UserFIN     := GetMv('ST_REEFIN',,'/000904/000714/000216')+AllTrim(GetMv('ST_REEFIN1',,''))

	If IsInCallStack("U_ZAPVZ1OP")
		Z1O->(DbGoTo(Val(aAprova[1])))
		STREREM1(cObsRep)
		Return
	EndIf

	If Z1O->Z1O_STATUS = '2'
		_xSuper   := u_Super()
		If !(Z1O->Z1O_USER $ _xSuper)
			MsgInfo("Voce nao é o aprovador desta Solicitação!!!!!!!")
		Else
			If	MsgYesNo("Deseja Rejeitar ?")
				STREREM1()
			EndIf
		EndIf
	ElseIf Z1O->Z1O_STATUS = '3'

		If !(__cUserId $ _UserFIN)
			MsgInfo("Voce nao é o aprovador Financeiro!!!!!!!")
		Else
			If	MsgYesNo("Deseja Rejeitar ?")
				_cMsgSave += "===================================" +CR
				_cMsgSave += "Rejeitado pelo Financeiro. " +CR
				_cMsgSave += "Usuário: "+cUserName+CR
				_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR
				_cCop 		:=  UsrRetMail(Z1O->Z1O_USER)

				If cEmpAnt == '07' //Everson Santana - 05/12/18
					_cPara:= " Carolina.Centurion@steckgroup.com;claudia.ferreira@steck.com.br  "
				Else
					_cPara:= GetMv('ST_REEREJ',," eduardo.brambilla@se.com ; jussara.silva@steck.com.br   ; lilia.lima@steck.com.br") //" Eduardo.santos@steck.com.br ; jussara.silva@steck.com.br   ; lilia.lima@steck.com.br"
				EndIF

				Z1O->(RecLock("Z1O", .F.))
				Z1O->Z1O_OBS3   := MOTREJ()+ Alltrim(Z1O->Z1O_OBS3)
				Z1O->Z1O_LOG    :=   _cMsgSave + CR + Z1O->Z1O_LOG
				Z1O->Z1O_STATUS := '1'
				Z1O->(MsUnlock())
				Z1O->(DbCommit())

				STWFRE("Reembolso de Despesa: "+Z1O->Z1O_COD+", Rejeitado pelo Financeiro.",_cPara,_cCop)

			EndIf
		EndIf
	ElseIf Z1O->Z1O_STATUS = '4'

		MsgInfo("Reembolso ja Finalizado")

	EndIf

Return

	*------------------------------------------------------------------*
Static Function STWFRE(_cAssunto,_cEmail,_cCopia )
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local cFuncSent:= "STWFRE"
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
	Local _aMsg    :={}

	If Z1O->Z1O_STATUS == '3'

		Aadd( _aMsg , { "Numero: "          , Z1O->Z1O_COD } )
		Aadd( _aMsg , { "Nome: "    		, Z1O->Z1O_NOME } )
		Aadd( _aMsg , { "Valor: "    		, transform((Z1O->Z1O_TOTAL)	,"@E 999,999,999.99")  } )
		Aadd( _aMsg , { "Emissao: "    		, dtoc(Z1O->Z1O_EMISSA) } )
		Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
		Aadd( _aMsg , { "Hora: "    		, time() } )

	Else

		Aadd( _aMsg , { "Numero: "          , Z1O->Z1O_COD } )
		Aadd( _aMsg , { "Nome: "    		, Z1O->Z1O_NOME } )
		Aadd( _aMsg , { "Valor: "    		, transform((Z1O->Z1O_TOTAL)	,"@E 999,999,999.99")  } )
		Aadd( _aMsg , { "Emissao: "    		, dtoc(Z1O->Z1O_EMISSA) } )
		Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
		Aadd( _aMsg , { "Hora: "    		, time() } )
		Aadd( _aMsg , { "Observação: "    	, Alltrim(Z1O->Z1O_OBS) } )
		Aadd( _aMsg , { "Obs Financeiro: " 	, Alltrim(Z1O->Z1O_OBS3) } )

	Endif

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf

			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)

	EndIf
	RestArea(aArea)
Return()

	*---------------------------------------------------*
Static Function STDAT()
	*---------------------------------------------------*

	Local oDlgEmail
	Local _dVal       :=  ddatabase
	Local lSaida      := .F.
	Local nOpca       :=  0

	Do While !lSaida
		nOpcao := 0
		DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Digite a Data") From  1,0 To 80,200 Pixel OF oMainWnd

		@ 02,04 SAY "Data:" PIXEL OF oDlgEmail
		@ 12,04 MSGet _dVal   Size 55,013  PIXEL OF oDlgEmail
		@ 12,62 Button "Ok"      Size 28,13 Action iif(!(Empty(Alltrim(dtos(_dVal)))),Eval({|| lSaida:=.T.,nOpca:=1,oDlgEmail:End()}),msginfo("Data Invalida....!!!!!!"))  Pixel

		ACTIVATE MSDIALOG oDlgEmail CENTERED
	EndDo

Return(_dVal)

User Function GerReemb()
	Local _cNum       := 'REE'+Z1O->Z1O_COD
	Local _Rec        := U_REBAN("5",Z1O->Z1O_USER)
	Local _cCcd       := U_REBAN("6",Z1O->Z1O_USER)
	Local _cMoeda     := '1'
	Local aVetor 	  := {}
	Local aDadosBco	  := {}
	Local _nVal 	  := 0
	Local _dDate	  := ddatabase
	Local _dDateX	  := ddatabase
	Local 	_nPC	  := Z1O->Z1O_PC
	Local _cConta     := Space(20)
	Private lMsErroAuto := .F.

	DbSelectArea('Z1P')
	Z1P->(DbSetOrder(1))
	Z1P->(DbGoTop())
	If Z1P->(dbSeek(xFilial("Z1P")+Z1O->Z1O_COD))

		If Z1P->Z1P_MOEDA <> '1'

			RecLock("Z1O", .F.)
			Z1O->Z1O_TX    := STUnitTel()
			Z1O->(MsUnlock())
			Z1O->(DbCommit())

		EndIf

		While Z1P->(!eof()) .And. Z1O->Z1O_COD = Z1P->Z1P_COD
			_nVal		+=  ROUND(Z1P->Z1P_VALOR*Z1O->Z1O_TX,2)
			_cMoeda     := Z1P->Z1P_MOEDA
			Z1P->(Dbskip())
		End
		If Z1P->Z1P_MOEDA <> '1'
			If ! MsgYesNo("Valor do titulo: R$"+ Transform(_nVal,"@E 999,999,999.99") +" ,Confirma?")
				Return()
			EndIf

		EndIf
		If !(Empty(Alltrim(_Rec))) .And. _nVal > 0
			DbSelectArea("SA2")
			SA2->(DbGoTo(Val(_Rec)))
			If Val(_Rec)   = SA2->(RECNO())

				DbSelectArea("SE2")
				SE2->(dbSetOrder(1))

				If _nPC = "1"

					_cPref:= 'PC'
				Else
					_cPref:= 'FIN'
				EndIf
				_cTipo:= 'RC'
				_cNatu:= '20111'
				_cPort:= '341'
				_cLa	:=' '
				_cHist:="DESP.SERVICO REF.: Reembolso "+Z1O->Z1O_COD
				cBancoAdt	:=  ''
				cAgenciaAdt	:=  ''
				cNumCon	 	:=  ''
				cChequeAdt	:=  ' '

				DbSelectArea('Z1P')
				Z1P->(DbSetOrder(1))
				Z1P->(DbGoTop())
				If Z1P->(dbSeek(xFilial("Z1P")+Z1O->Z1O_COD))
					If	Z1P->Z1P_TIPO = '9'
						_cPref:= 'PA'
						_cTipo:= 'PA'
						_cNatu:= '20506'
						_cPort:= '341'
						_cLa  := ' '
						_cHist:="Adiantamento de Desp.: Soli. "+Z1O->Z1O_COD
						If cEmpAnt = '01'
							cBancoAdt	:=  '341'
							cAgenciaAdt	:=  '8712'
							cNumCon	 	:=  '105116'
							cChequeAdt	:=  '341'
						ElseIf cEmpAnt = '03'
							cBancoAdt	:=  '341'
							cAgenciaAdt	:=  '8712'
							cNumCon	 	:=  '015844'
							cChequeAdt	:=  '341'
						ElseIf cEmpAnt = '11' //Adicionado por José (Sigamat) 03/05/2022
							cBancoAdt	:=  '341'
							cAgenciaAdt	:=  '8712'
							cNumCon	 	:=  '059594'
							cChequeAdt	:=  '341'
						EndIf
						If	Z1P->Z1P_MOEDA <> '1'
							_cNatu:= '20101'
							cBancoAdt	:=  '716'
							cAgenciaAdt	:=  '003'
							cNumCon	 	:=  '003'
							cChequeAdt	:=  '716'
							_cPort		:=  ' '
						EndIf

					EndIf

					If	Z1P->Z1P_TIPO = 'A'
						DbSelectArea('SA2')
						SA2->(DbSetOrder(1))
						SA2->(DbGoTop())
						If cEmpAnt = '01'
							_cForCod:='00576401'
						Else
							_cForCod:='00586601'
						EndIf
						If SA2->(dbSeek(xFilial("SA2")+_cForCod    ))
							_cHist:="Suprimento de caixa: Soli. "+Z1O->Z1O_COD
							_cNatu:= '30101'
							_cPref:= 'FIN'
							_cTipo:= 'RC'
						EndIf?
					EndIf

				EndIf

				Aadd(aDadosBco,{cBancoAdt})
				Aadd(aDadosBco,{cAgenciaAdt})
				Aadd(aDadosBco,{cNumCon})
				Aadd(aDadosBco,{cChequeAdt})

				_dDate := Ddatabase
				_dDateX:= datavalida(_dDate+1)

				If _cTipo = 'PA'

					_dDate := STDAT()
					_dDateX:= _dDate
				EndIf

				DbSelectArea("CTT")
				DbSetOrder(1)
				If DbSeek(xFilial("CTT")+_cCcd)

					If CTT->CTT_REFCTA=="1"
						DbSelectArea("SED")
						DbSetOrder(1)
						If DbSeek(xFilial("SED")+_cNatu)
							_cConta:=SED->ED_CONTA
						Endif
					ElseIf CTT->CTT_REFCTA=="2"
						DbSelectArea("SED")
						DbSetOrder(1)
						If DbSeek(xFilial("SED")+_cNatu)
							_cConta:=SED->ED_XVEND
						Endif
					ElseIf CTT->CTT_REFCTA=="3" .Or. CTT->CTT_REFCTA=="4"

						DbSelectArea("SED")
						DbSetOrder(1)
						If DbSeek(xFilial("SED")+_cNatu)
							_cConta:=SED->ED_XCUST
						Endif

					Endif

				Endif

				If Z1O->Z1O_DESC>0 //ticket 20191125000007
					_nVal := _nVal-Z1O->Z1O_DESC
				EndIf

				aVetor := {	{"E2_PREFIXO"		, _cPref 			,Nil},;
					{"E2_NUM"					, _cNum				,Nil},;
					{"E2_TIPO"					, _cTipo 			,Nil},;
					{"E2_FORNECE"				, SA2->A2_COD		,Nil},;
					{"E2_LOJA"					, SA2->A2_LOJA		,Nil},;
					{"E2_NOMFOR"				, SA2->A2_NOME		,Nil},;
					{"E2_EMISSAO"				, _dDate			,Nil},;
					{"E2_EMIS1"					, _dDate			,Nil},;
					{"E2_VENCTO"				, _dDateX			,Nil},;
					{"E2_VENCREA"				, _dDateX			,Nil},;
					{"E2_VALOR"					, _nVal				,Nil},;
					{"E2_VLCRUZ"				, _nVal				,Nil},;
					{"E2_NATUREZ"				, _cNatu 			,Nil},;
					{"E2_HIST"					, _cHist			,Nil},;
					{"E2_PORTADO"				, _cPort 			,Nil},;
					{"E2_CONTAD"    			, _cConta			,Nil},;
					{"E2_CCD"					, _cCcd				,Nil},;
					{"E2_XBLQ"					, ""				,Nil},;
					{"E2_XAPROV"				, ""				,Nil},;
					{"E2_BCOPAG"				, _cPort 			,Nil},;
					{"AUTBANCO"					, cBancoAdt 		,Nil},;
					{"AUTAGENCIA"				, cAgenciaAdt		,Nil},;
					{"AUTCONTA"					, cNumCon 			,Nil}}

				MsgRun(OemToAnsi("Gerando registros no Contas a Pagar..." ),,{||MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aVetor,, 3)})
				aVetor := {}
				If lMsErroAuto
					MsgInfo("Erro na geração do titulo ...!!!!!")
					MostraErro()

				Else
					RecLock("SE2", .F.)
					SE2->E2_FILIAL     := Z1O->Z1O_XFIL
					SE2->E2_FILORIG    := Z1O->Z1O_XFIL
					If _cTipo = 'PA'
						SE2->E2_EMIS1    := SE2->E2_EMISSAO
					EndIf

					SE2->(MsUnlock())
					SE2->(DbCommit())

					RecLock("SE5", .T.)
					SE5->E5_FILIAL     := Z1O->Z1O_XFIL
					SE5->E5_FILORIG    := Z1O->Z1O_XFIL
					SE5->(MsUnlock())

					RecLock("Z1O", .F.)
					Z1O->Z1O_STATUS := '4'
					Z1O->Z1O_NUM    := SE2->E2_NUM
					Z1O->Z1O_SERIE  := SE2->E2_PREFIXO
					Z1O->Z1O_PAGTO  := SE2->E2_VENCREA
					Z1O->(MsUnlock())
					Z1O->(DbCommit())

					MsgInfo("Titulo Inserido com Sucesso...!!!!!")
				EndIf
			Else
				MsgInfo("Erro na geração do titulo ...!!!!!")
			EndIf
		EndIf
	Else
		MsgInfo("Erro na geração do titulo ...!!!!!")
	EndIf
Return()

User Function REBAN(_cOpe,_cUssr)
	Local cQuery  	  := " "
	Local cPerg       := 'REBAN'
	Local cTime       := Time()
	Local cHora       := SUBSTR(cTime, 1, 2)
	Local cMinutos    := SUBSTR(cTime, 4, 2)
	Local cSegundos   := SUBSTR(cTime, 7, 2)
	Local cAliasLif   := cPerg+cHora+ cMinutos+cSegundos
	Local _cRet  	  := " "

	cQuery := "  SELECT A2_BANCO ,A2_XCC, A2_AGENCIA,A2_NUMCON, A2.R_E_C_N_O_ AS REC , NVL(X5_DESCRI, ' ')
	cQuery += '  "BANCO"
	cQuery += "  FROM "+RetSqlName("SA2")+"  A2
	cQuery += "  LEFT JOIN(SELECT * FROM "+RetSqlName("SX5")+" ) SX5 "
	cQuery += "  ON SX5.D_E_L_E_T_ = ' '
	cQuery += "  AND SX5.X5_TABELA = 'ZO'
	cQuery += "  AND  TRIM(SX5.X5_CHAVE) = TRIM(A2_BANCO)
	cQuery += "  WHERE A2.D_E_L_E_T_ = ' '
	cQuery += "  AND A2_XCODUSR = '"+_cUssr+"'

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		If _cOpe = '1'
			_cRet:= (cAliasLif)->A2_BANCO
		ElseIf  _cOpe = '2'
			_cRet:= (cAliasLif)->BANCO
		ElseIf  _cOpe = '3'
			_cRet:= (cAliasLif)->A2_AGENCIA
		ElseIf  _cOpe = '4'
			_cRet:= (cAliasLif)->A2_NUMCON
		ElseIf  _cOpe = '5'
			_cRet:= cValToChar((cAliasLif)->REC)
		ElseIf  _cOpe = '6'
			_cRet:= cValToChar((cAliasLif)->A2_XCC)
		EndIf

	EndIf

Return(_cRet)

User Function SECREM()

	//iif(__cUserId $ GetMv('ST_REELV',,'000243'),iif( msgyesno('Reembolso p/ o Luis?'), '000591',__cuserid),__cuserid)
	Local _cRet:= __cuserid

	If (__cUserId $ GetMv('ST_REELV',,'000243'))
		If( msgyesno('Reembolso p/ o Klecios?'))
			_cRet:='001256'
		EndIf
	EndIf

	If (__cUserId $ GetMv('ST_REEVS',,'000582'))
		If( msgyesno('Reembolso p/ o Thomas?'))
			_cRet:='001170'
		EndIf
	EndIf

Return(_cRet)

Static Function MOTREJ()
	Local _Zstat:= ' '
	Local oDlg
	Local cGetMDe:= space(200)
	Local lSaida := .f.

	While !lSaida

		Define msDialog oDlg Title "Motivo de Rejeição" From 10,10 TO 20,65 Style DS_MODALFRAME

		@ 001,001 Say "Descrição do motivo: " Pixel Of oDlg
		@ 011,003 MsGet cGetMDe valid !empty(cGetMDe) size 200,50 Picture "@!" pixel OF oDlg

		DEFINE SBUTTON FROM 50,20 TYPE 1 ACTION IF(!empty(cGetMDe),(nOpcao:=1,lSaida:=.T.,oDlg:End()),msgInfo("Motivo em Branco","Atenção")) ENABLE OF oDlg

		Activate dialog oDlg centered

	End
Return(cGetMDe)

User Function Grafico()
	Local lGraph3D := .T. // .F. Grafico 2 dimensoes  - .T. Grafico 3 dimensoes
	Local lMenuGraph := .T. // .F. Nao exibe menu  - .T. Exibe menu para mudar o tipo de grafico
	Local lMudaCor := .T.
	Local nTipoGraph := 2
	Local nCorDefault := 1
	Local aDados := {{"Valor 1", 100}, {"Valor 2", 500},{"Valor 3", 1000}}
	Local aStru := {}
	Local cArquivo := CriaTrab(,.F.)
	Local i
	If MsgYesNo("Deseja exibir o grafico com os dados do array?") 	//o grafico sera montado a partir dos dados do array aDados
		MatGraph("Graficos",lGraph3D,lMenuGraph,lMudaCor,nTipoGraph,nCorDefault,aDados)
	Else
		aStru := {	{"EixoX"		, "C", 20, 0}, {"EixoY"		, "N", 8, 2} }
		dbCreate(cArquivo,aStru, "TOPCONN" )	// adicionado o driver TOPCONN \Ajustado
		dbUseArea(.T.,'TOPCONN',cArquivo,"GRAFICO",.F.,.F.)
		For i:=1 to Len(aDados)
			("GRAFICO")->( dbAppend() )
			("GRAFICO")->(EixoX) := aDados[i][1]
			("GRAFICO")->(EixoY) := aDados[i][2]
		Next i		//o grafico sera montado a partir dos dados da area de trabalho  "GRAFICO"
		MatGraph("Graficos",lGraph3D,lMenuGraph,lMudaCor,nTipoGraph,nCorDefault,,"GRAFICO",{"EixoX","EixoY"})
		("GRAFICO")->( dbCloseArea() )
	EndIf
Return

User Function MAILREEM() //JOB REEMBOLSO EMAIL

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	DbSelectArea('Z1O')
	Z1O->(DbSetOrder(1))
	Z1O->(DbGoTop())

	While Z1O->(!eof())
		_cCop:= ' '
		_cPara:= ' '

		If '2' = Z1O->Z1O_STATUS
			DbSelectArea('Z1N')
			Z1N->(DbSetOrder(1))
			Z1N->(DbGoTop())

			While Z1N->(!eof())
				If Z1N->Z1N_USER = Z1O->Z1O_USER
					DbSelectArea('Z1M')
					Z1M->(DbSetOrder(1))
					If Z1M->(dbSeek(xFilial("Z1M")+Z1N->Z1N_COD))
						_cPara+=  UsrRetMail(Z1M->Z1M_APRO) +';'
					EndIf
				EndIf
				Z1N->(Dbskip())
			End

			_cCop 		:=  UsrRetMail(Z1O->Z1O_USER)

			STWFRE("Reembolso de Despesa: "+Z1O->Z1O_COD+", Aguarda sua Interação.",_cPara,_cCop)
		EndIf

		If '5' = Z1O->Z1O_STATUS
			_cPara:=  ''
			_cCop 		:=  UsrRetMail(Z1O->Z1O_USER)
			STWFRE("Reembolso de Despesa: "+Z1O->Z1O_COD+", Aguarda sua Interação.",_cPara,_cCop)
		EndIf

		Z1O->(Dbskip())
	End

	DbSelectArea('Z1O')
	Z1O->(DbSetOrder(1))
	Z1O->(DbGoTop())

	While Z1O->(!eof())
		_cCop:= ' '
		_cPara:= ' '

		If '3' = Z1O->Z1O_STATUS
			_cCop 		:=  UsrRetMail(Z1O->Z1O_USER)
			_cPara:= GetMv('ST_REEREJ',," eduardo.brambilla@se.com ; jussara.silva@steck.com.br   ; lilia.lima@steck.com.br") //" Eduardo.santos@steck.com.br ; jussara.silva@steck.com.br  ; lilia.lima@steck.com.br; eric.lopes@steck.com.br"
			STWFRE("Reembolso de Despesa: "+Z1O->Z1O_COD+", Aguardando Financeiro.",_cPara,_cCop)
		EndIf
		Z1O->(Dbskip())
	End

	StartJob("U_AMMAILREEM",GetEnvServer(), .F.,)

Return

User Function MAILRE11() //JOB REEMBOLSO EMAIL

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	DbSelectArea('Z1O')
	Z1O->(DbSetOrder(1))
	Z1O->(DbGoTop())

	While Z1O->(!eof())
		_cCop:= ' '
		_cPara:= ' '

		If '2' = Z1O->Z1O_STATUS
			DbSelectArea('Z1N')
			Z1N->(DbSetOrder(1))
			Z1N->(DbGoTop())

			While Z1N->(!eof())
				If Z1N->Z1N_USER = Z1O->Z1O_USER
					DbSelectArea('Z1M')
					Z1M->(DbSetOrder(1))
					If Z1M->(dbSeek(xFilial("Z1M")+Z1N->Z1N_COD))
						_cPara+=  UsrRetMail(Z1M->Z1M_APRO) +';'
					EndIf
				EndIf
				Z1N->(Dbskip())
			End

			_cCop 		:=  UsrRetMail(Z1O->Z1O_USER)

			STWFRE("Reembolso de Despesa: "+Z1O->Z1O_COD+", Aguarda sua Interação.",_cPara,_cCop)
		EndIf

		If '5' = Z1O->Z1O_STATUS
			_cPara:=  ''
			_cCop 		:=  UsrRetMail(Z1O->Z1O_USER)
			STWFRE("Reembolso de Despesa: "+Z1O->Z1O_COD+", Aguarda sua Interação.",_cPara,_cCop)
		EndIf

		Z1O->(Dbskip())
	End

	DbSelectArea('Z1O')
	Z1O->(DbSetOrder(1))
	Z1O->(DbGoTop())

	While Z1O->(!eof())
		_cCop:= ' '
		_cPara:= ' '

		If '3' = Z1O->Z1O_STATUS
			_cCop 		:=  UsrRetMail(Z1O->Z1O_USER)
			_cPara:= " Eduardo.santos@steck.com.br ; jussara.silva@steck.com.br  ; lilia.lima@steck.com.br; eric.lopes@steck.com.br"
			STWFRE("Reembolso de Despesa: "+Z1O->Z1O_COD+", Aguardando Financeiro.",_cPara,_cCop)
		EndIf
		Z1O->(Dbskip())
	End

	StartJob("U_AMMAILREEM",GetEnvServer(), .F.,)

Return

User Function AMMAILREEM() //JOB REEMBOLSO EMAIL

	RpcSetType( 3 )
	RpcSetEnv("03","01",,,"FAT")

	DbSelectArea('Z1O')
	Z1O->(DbSetOrder(1))
	Z1O->(DbGoTop())

	While Z1O->(!eof())
		_cCop:= ' '
		_cPara:= ' '

		If '2' = Z1O->Z1O_STATUS
			DbSelectArea('Z1N')
			Z1N->(DbSetOrder(1))
			Z1N->(DbGoTop())

			While Z1N->(!eof())
				If Z1N->Z1N_USER = Z1O->Z1O_USER
					DbSelectArea('Z1M')
					Z1M->(DbSetOrder(1))
					If Z1M->(dbSeek(xFilial("Z1M")+Z1N->Z1N_COD))
						_cPara+=  UsrRetMail(Z1M->Z1M_APRO) +';'
					EndIf
				EndIf
				Z1N->(Dbskip())
			End

			_cCop 		:=  UsrRetMail(Z1O->Z1O_USER)

			STWFRE("Reembolso de Despesa: "+Z1O->Z1O_COD+", Aguarda sua Interação.",_cPara,_cCop)
		EndIf

		If '5' = Z1O->Z1O_STATUS
			_cPara:=  ''
			_cCop 		:=  UsrRetMail(Z1O->Z1O_USER)
			STWFRE("Reembolso de Despesa: "+Z1O->Z1O_COD+", Aguarda sua Interação.",_cPara,_cCop)
		EndIf

		Z1O->(Dbskip())
	End

	DbSelectArea('Z1O')
	Z1O->(DbSetOrder(1))
	Z1O->(DbGoTop())

	While Z1O->(!eof())
		_cCop:= ' '
		_cPara:= ' '

		If '3' = Z1O->Z1O_STATUS
			_cCop 		:=  UsrRetMail(Z1O->Z1O_USER)
			_cPara:= GetMv('ST_REEREJ',," eduardo.brambilla@se.com ; jussara.silva@steck.com.br   ; lilia.lima@steck.com.br") //" Eduardo.santos@steck.com.br ; jussara.silva@steck.com.br  ; lilia.lima@steck.com.br"
			STWFRE("Reembolso de Despesa: "+Z1O->Z1O_COD+", Aguardando Financeiro.",_cPara,_cCop)
		EndIf
		Z1O->(Dbskip())
	End

Return

/*
Static Function MOTDESC()
	Local _Zstat	:= ' '
	Local oDlg
	Local cGetMDe	:= space(200)
	Local lSaida 	:= .f.

	While !lSaida

		Define msDialog oDlg Title "Motivo do Desconto" From 10,10 TO 20,65 Style DS_MODALFRAME

		@ 001,001 Say "Descrição do motivo: " Pixel Of oDlg
		@ 011,003 MsGet cGetMDe valid !empty(cGetMDe) size 200,50 Picture "@!" pixel OF oDlg

		DEFINE SBUTTON FROM 50,20 TYPE 1 ACTION IF(!empty(cGetMDe),(nOpcao:=1,lSaida:=.T.,oDlg:End()),msgInfo("Motivo em Branco","Atenção")) ENABLE OF oDlg

		Activate dialog oDlg centered

	End
Return(cGetMDe)
*/

Static Function STReDesc()
	Local oDlgDesc
	Local lSaida	:= .F.
	Local nOpca		:=  0

	Do While !lSaida
		nOpcao := 0

		DEFINE MSDIALOG oDlgDesc TITLE OemToAnsi("Digite o valor autorizado para esse Reembolso") From  1,0 To 180,500 Pixel OF oMainWnd

		@ 02,04 SAY "Valor Solicitado:" PIXEL OF oDlgDesc
		@ 12,04 MSGet Z1O->Z1O_TOTAL picture "@E 999,999.99999"   Size 55,013  PIXEL OF oDlgDesc When .F.

		@ 32,04 SAY "Valor Desconto..:" PIXEL OF oDlgDesc
		@ 42,04 MSGet _nVrDesc picture "@E 999,999.99999"   Size 55,013  PIXEL OF oDlgDesc Valid _nVrDesc < Z1O->Z1O_TOTAL

		@ 32,62 Say "Descrição do motivo: " Pixel Of oDlgDesc
		@ 42,62 MsGet _cGetMDe size 185,013 Picture "@!" pixel OF oDlgDesc

		@ 62,217 Button "Ok"      Size 28,13 Action iif(_nVrDesc < Z1O->Z1O_TOTAL,Eval({||lSaida:=.T.,nOpca:=1,oDlgDesc:End()}),msginfo("Valor não pode ser maior que o total..."))  Pixel

		ACTIVATE MSDIALOG oDlgDesc CENTERED
	EndDo

Return(Alltrim(_cGetMDe))

Static Function STAPREM1()

	_cMsgSave := "===================================" +CR
	_cMsgSave += "Enviado Para Aprovação do Financeiro. " +CR
	_cMsgSave += "Usuário: "+cUserName+CR
	_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR
	_cCop 		:=  UsrRetMail(Z1O->Z1O_USER)

	If cEmpAnt == '07' //Everson Santana - 05/12/18
		_cPara:= " Carolina.Centurion@steckgroup.com;claudia.ferreira@steck.com.br  "
	Else
		_cPara:= GetMv('ST_REEREJ',," eduardo.brambilla@se.com ; jussara.silva@steck.com.br   ; lilia.lima@steck.com.br") //" eduardo.santos@steck.com.br ; jussara.silva@steck.com.br   ; lilia.lima@steck.com.br"
	EndIF

	STWFRE("Reembolso de Despesa: "+Z1O->Z1O_COD+", Enviado para Aprovação do Financeiro.",_cPara,_cCop)
	RecLock("Z1O", .F.)
	Z1O->Z1O_LOG    :=  _cMsgSave + CR + Z1O->Z1O_LOG
	Z1O->Z1O_STATUS := '3'
	Z1O->(MsUnlock())
	Z1O->(DbCommit())

Return()

Static Function STREREM1(cObsRep)

	_cPara := ""

	_cMsgSave := "===================================" +CR
	_cMsgSave += "Rejeitado pelo Gestor. " +CR
	_cMsgSave += "Usuário: "+cUserName+CR
	_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

	DbSelectArea('Z1N')
	Z1N->(DbSetOrder(1))
	Z1N->(DbGoTop())

	While Z1N->(!eof())
		If Z1N->Z1N_USER = Z1O->Z1O_USER
			DbSelectArea('Z1M')
			Z1M->(DbSetOrder(1))
			If Z1M->(dbSeek(xFilial("Z1M")+Z1N->Z1N_COD))
				_cPara+=  UsrRetMail(Z1M->Z1M_APRO) +';'
			EndIf
		EndIf
		Z1N->(Dbskip())
	End

	_cCop 		:=  UsrRetMail(Z1O->Z1O_USER)
	STWFRE("Reembolso de Despesa: "+Z1O->Z1O_COD+", Rejeitado.",_cPara,_cCop)

	RecLock("Z1O", .F.)
	If IsInCallStack("U_ZAPVZ1OP")
		Z1O->Z1O_OBS2   := cObsRep
	Else
		Z1O->Z1O_OBS2   := MOTREJ()+ Alltrim(Z1O->Z1O_OBS2)
	EndIf
	Z1O->Z1O_LOG    :=  _cMsgSave + CR + Z1O->Z1O_LOG
	Z1O->Z1O_STATUS := '1'
	Z1O->(MsUnlock())
	Z1O->(DbCommit())

Return()

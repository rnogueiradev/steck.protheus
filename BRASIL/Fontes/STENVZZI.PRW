#INCLUDE 'TOTVS.CH'
#include 'TOPCONN.CH'
#include 'TBICONN.CH'

/*====================================================================================\
|Programa  | STENVZZI         | Autor | giovani.zago          | Data | 15/09/2015  |
|=====================================================================================|
|DescriГЦo | Fonte para enviar email para o aprovador da alГada apСs x dias			  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STWSPC02                                                                 |
|=====================================================================================|
|Uso       | Compras											                              |
|=====================================================================================|
|........................................HistСrico....................................|
\====================================================================================*/

User Function STENVZZI(aParam)
//User Function STENVZZI(cEmpX,cFilX)

	Local _cQuery		:= ""
	Local _cAlias		:= "QRYTEMP"
	Local _cEmail   	:= ""
	Local _cCopia   	:= ""
	Local _cAssunto 	:= ''
	Local cMsg	    	:= ""
	Local cAttach   	:= ''
	Local _aAttach  	:= {}
	Local _cCaminho 	:= ''
	Local _aMsg 		:= {}
	Local _nLin
	Local cFuncSent 	:= "STENVZZI"

	RpcSetType( 3 )
//	RpcSetEnv("01","02",,,"FAT")
	RpcSetEnv(aParam[1],aParam[2],,,"FAT")

	_cQuery  := " SELECT ZZI_FILANT, ZZI_TIPO, ZZI_COD, ZZI_NUM, ZZI_NOMECL, ZZI_DTAPR, ZZI_VEND1, UA_VEND, ZZI_VEND2, UA_VEND2, "
	_cQuery  += " to_char(sysdate-"+CVALTOCHAR(GETMV("ST_DIASALC"))+",'YYYYMMDD') NOVADATA, SUBSTR(ZZI_USERAP,1,6) USUARIO "
	_cQuery  += " ,NVL((SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=UA_VEND AND (SUBSTR(A3_COD,1,1)<>'R' OR A3_COD IN ('R00262','R00379','R00103','R00104','R00124','R00377','R00105','R00202','R00408','R00134','R00224','R00332','R00051','R00682','R00269','R00268','R00492','R00121','R00184','R00181','R00271','R00471','R00385','R00143','R00027','R00191','R00152','R00192','R00196','R00194','R00961','R00193','R00382','R00386','R00234','R00485','R00585','R00477','R00577','R00571','R00479','R00284','R00685'))),' ') EMAIL1 "
	_cQuery  += " ,NVL((SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=UA_VEND2 AND (SUBSTR(A3_COD,1,1)<>'R' OR A3_COD IN ('R00262','R00379','R00103','R00104','R00124','R00377','R00105','R00202','R00408','R00134','R00224','R00332','R00051','R00682','R00269','R00268','R00492','R00121','R00184','R00181','R00271','R00471','R00385','R00143','R00027','R00191','R00152','R00192','R00196','R00194','R00961','R00193','R00382','R00386','R00234','R00485','R00585','R00477','R00577','R00571','R00479','R00284','R00685'))),' ') EMAIL2 "
	_cQuery  += " ,NVL((SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=(SELECT A3_SUPER FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=UA_VEND) AND SUBSTR(A3_COD,1,1)<>'R'),' ') EMAILSUP "
	_cQuery  += " FROM "+RetSqlName("ZZI")+" ZZI "
	_cQuery  += " LEFT JOIN "+RetSqlName("SUA")+" UA "
	_cQuery  += " ON UA.UA_FILIAL=ZZI.ZZI_FILANT AND UA.UA_NUM=ZZI.ZZI_NUM "
	_cQuery  += " WHERE ZZI.D_E_L_E_T_=' ' AND UA.D_E_L_E_T_=' ' AND "
	_cQuery  += " ( to_char(sysdate-"+CVALTOCHAR(GETMV("ST_DIASALC"))+",'YYYYMMDD')=ZZI_DTAPR OR "
	_cQuery  += " to_char(sysdate-"+CVALTOCHAR(GETMV("ST_DIASALC"))+",'YYYYMMDD')=ZZI_DTENVM ) "
	_cQuery  += " AND ZZI_TIPO='ORгAMENTO' "
	_cQuery  += " AND (SELECT UA_NUMSC5 FROM "+RetSqlName("SUA")+" UA WHERE UA.UA_FILIAL=ZZI_FILANT AND UA.UA_NUM=ZZI_NUM)=' ' "
	_cQuery  += " AND (SELECT UA_OPER FROM "+RetSqlName("SUA")+" UA WHERE UA.UA_FILIAL=ZZI_FILANT AND UA.UA_NUM=ZZI_NUM)='2' "
	_cQuery  += " AND (SELECT UA_CANC FROM "+RetSqlName("SUA")+" UA WHERE UA.UA_FILIAL=ZZI_FILANT AND UA.UA_NUM=ZZI_NUM)=' ' "
	_cQuery  += " AND (SELECT UA_CODCANC FROM "+RetSqlName("SUA")+" UA WHERE UA.UA_FILIAL=ZZI_FILANT AND UA.UA_NUM=ZZI_NUM)=' ' "
	_cQuery  += " AND (SELECT UA_XBLOQ FROM "+RetSqlName("SUA")+" UA WHERE UA.UA_FILIAL=ZZI_FILANT AND UA.UA_NUM=ZZI_NUM)<>'3' "
	_cQuery  += " AND (SELECT COUNT(*) FROM "+RetSqlName("ZZY")+" ZZY WHERE ZZY.D_E_L_E_T_=' ' AND ZZY_FILIAL=ZZI_FILANT AND ZZY_NUM=ZZI_NUM) =0 " //Chamado 003191 - NЦo enviar automАtico quando tiver interaГЦo na agenda
	_cQuery  += " AND UA_XCODCAN=' '
	_cQuery  += " ORDER BY ZZI_NUM "

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	While (_cAlias)->(!Eof())

		DbSelectArea("ZZI")
		ZZI->(DbSetOrder(3)) //ZZI_FILIAL+ZZI_NUM
		ZZI->(DbGoTop())
		If ZZI->(DbSeek(xFilial("ZZI")+(_cAlias)->(ZZI_NUM)))
			ZZI->(RecLock("ZZI",.F.))
			ZZI->ZZI_DTENVM	:= Date()
			ZZI->ZZI_NUMENV	:= ZZI->ZZI_NUMENV+1
			ZZI->(MsUnLock())
		EndIf

		_cEmail	  		:= AllTrim(UsrRetMail((_cAlias)->USUARIO))+";"+AllTrim((_cAlias)->EMAIL1)+";"+AllTrim((_cAlias)->EMAIL2)+";"+AllTrim((_cAlias)->EMAILSUP)

		If AllTrim((_cAlias)->UA_VEND)=="R00202" .Or. AllTrim((_cAlias)->UA_VEND2)=="R00202"  //Chamado 003025
			_cEmail			+= ";monica.jcanterorepres@uol.com.br"
		EndIf

		_cAssunto 		:= '[WFPROTHEUS] - Cobrar '+AllTrim((_cAlias)->ZZI_TIPO)+': '+(_cAlias)->ZZI_NUM+' - LEMBRETE: '+CVALTOCHAR(ZZI->ZZI_NUMENV)
		cMsg 			:= ""
		cMsg 			+= '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg 			+= '<b>[WFPROTHEUS] - Cobrar cotaГЦo: '+(_cAlias)->ZZI_NUM+'</b> - Cliente: '+(_cAlias)->ZZI_NOMECL+'</body></html>'

		If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
		Conout("Problemas no envio de email!")
		EndIf
		(_cAlias)->(DbSkip())
	EndDo

	_cQuery  := " SELECT ZZY_FILIAL, ZZY_NUM, UA_NUM, UA_XNOME, "
	_cQuery  += " NVL((SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=UA_VEND  AND (SUBSTR(A3_COD,1,1)<>'R' OR A3_COD IN ('R00262','R00291','R00379','R00124','R00377','R00103','R00104','R00105','R00202','R00408','R00134','R00224','R00332','R00051','R00682','R00269','R00268','R00492','R00121','R00184','R00181','R00271','R00471','R00385','R00143','R00027','R00191','R00152','R00192','R00196','R00194','R00961','R00193','R00382','R00386','R00234')) ),' ') EMAIL1, "
	_cQuery  += " NVL((SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=UA_VEND2 AND (SUBSTR(A3_COD,1,1)<>'R' OR A3_COD IN ('R00262','R00291','R00379','R00124','R00377','R00103','R00104','R00105','R00202','R00408','R00134','R00224','R00332','R00051','R00682','R00269','R00268','R00492','R00121','R00184','R00181','R00271','R00471','R00385','R00143','R00027','R00191','R00152','R00192','R00196','R00194','R00961','R00193','R00382','R00386','R00234')) ),' ') EMAIL2, "
	_cQuery  += " NVL((SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=(SELECT A3_SUPER FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=UA_VEND) AND SUBSTR(A3_COD,1,1)<>'R'),' ') EMAILSUP "
	_cQuery  += " FROM "+RetSqlName("ZZY")+" ZY "
	_cQuery  += " LEFT JOIN "+RetSqlName("SUA")+" UA "
	_cQuery  += " ON UA_FILIAL=ZZY_FILIAL AND UA_NUM=ZZY_NUM AND UA_NUMSC5 = ' ' "
	_cQuery  += " WHERE ZY.D_E_L_E_T_=' ' AND UA.D_E_L_E_T_=' ' AND ZZY_RETORN=TO_CHAR(sysdate,'YYYYMMDD') "
	_cQuery  += " AND UA_XCODCAN=' '

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	While (_cAlias)->(!Eof())

		_cEmail	  		:= AllTrim((_cAlias)->EMAIL1)+";"+AllTrim((_cAlias)->EMAIL2)+";"+AllTrim((_cAlias)->EMAILSUP)
		_cAssunto 		:= '[WFPROTHEUS] - Cobrar CotaГЦo: '+(_cAlias)->ZZY_NUM
		cMsg 			:= ""
		cMsg 			+= '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg 			+= '<b>[WFPROTHEUS] - Cobrar cotaГЦo: '+(_cAlias)->ZZY_NUM+'</b> - Cliente: '+(_cAlias)->UA_XNOME+'</body></html>'

		If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
		Conout("Problemas no envio de email!")
		EndIf

		(_cAlias)->(DbSkip())
	EndDo
	
	_cQuery  := " SELECT * FROM (
	_cQuery  += " SELECT Z1Y_FILIAL, Z1Y_NUM, PP7_CODIGO,PP7_OBRA,PP7_ENDOBR, PP7_NOME,Z1Y_RETORN,PP7_APROV,  "
	_cQuery  += " NVL((SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=PP7_REPRES  AND (SUBSTR(A3_COD,1,1)<>'R' OR A3_COD IN ('R00262','R00291','R00379','R00124','R00377','R00103','R00104','R00105','R00202','R00408','R00134','R00224','R00332','R00051','R00682','R00269','R00268','R00492','R00121','R00184','R00181','R00271','R00471','R00385','R00143','R00027','R00191','R00152','R00192','R00196','R00194','R00961','R00193','R00382','R00386','R00234')) ),' ') EMAIL1, "
	_cQuery  += " NVL((SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=PP7_VEND AND (SUBSTR(A3_COD,1,1)<>'R' OR A3_COD IN ('R00262','R00291','R00379','R00124','R00377','R00103','R00104','R00105','R00202','R00408','R00134','R00224','R00332','R00051','R00682','R00269','R00268','R00492','R00121','R00184','R00181','R00271','R00471','R00385','R00143','R00027','R00191','R00152','R00192','R00196','R00194','R00961','R00193','R00382','R00386','R00234')) ),' ') EMAIL2, "
	_cQuery  += " NVL((SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=(SELECT A3_SUPER FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=PP7_REPRES) AND SUBSTR(A3_COD,1,1)<>'R'),' ') EMAILSUP,
	_cQuery  += " (SELECT COUNT(*) FROM "+RetSqlName("PP8")+" PP8 WHERE PP8.D_E_L_E_T_=' ' AND PP8_FILIAL=PP7_FILIAL AND PP8_CODIGO=PP7_CODIGO AND PP8_PEDVEN<>' ') PEDGER
	_cQuery  += " FROM "+RetSqlName("Z1Y")+" Z1Y "
	_cQuery  += " LEFT JOIN "+RetSqlName("PP7")+" PP7 "
	_cQuery  += " ON PP7_FILIAL=Z1Y_FILIAL AND PP7_CODIGO=Z1Y_NUM AND PP7.PP7_STATUS NOT IN ('7')  " // Ticket 20190829000025
	_cQuery  += " WHERE Z1Y.D_E_L_E_T_=' ' AND PP7.D_E_L_E_T_=' ' AND Z1Y_RETORN=TO_CHAR(sysdate,'YYYYMMDD')
	_cQuery  += " ) XXX
	_cQuery  += " WHERE PEDGER=0

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	While (_cAlias)->(!Eof())

		_aMsg := {}

		_cEmail	  		:= AllTrim(UsrRetMail((_cAlias)->PP7_APROV))+";"+AllTrim((_cAlias)->EMAIL1)+";"+AllTrim((_cAlias)->EMAIL2)+";"+AllTrim((_cAlias)->EMAILSUP)
		_cAssunto 		:= '[WFPROTHEUS] - Cobrar CotaГЦo Unicon: '+(_cAlias)->Z1Y_NUM
		Aadd( _aMsg , { "Cliente: "    		, (_cAlias)->PP7_NOME } )
		Aadd( _aMsg , { "Obra: "    		, (_cAlias)->PP7_OBRA } )
		Aadd( _aMsg , { "End.: "    		, (_cAlias)->PP7_ENDOBR } )
		Aadd( _aMsg , { "Vendedor1: "    	, (_cAlias)->EMAIL1+' - '+ Alltrim(Posicione("SA3",1,xFilial("SA3")+(_cAlias)->EMAIL1,"A3_NOME")) } )
		Aadd( _aMsg , { "Vendedor2: "    	, (_cAlias)->EMAIL2+' - '+ Alltrim(Posicione("SA3",1,xFilial("SA3")+(_cAlias)->EMAIL2,"A3_NOME")) } )

		//>>Chamado 008169 - Everson Santana - 10.10.2018

		If Select("TRD") > 0
			TRD->(DbCloseArea())
		Endif

		_cQry := " "
		_cQry += " SELECT PP8_CODIGO, SUM(PP8_PRORC) PP8_PRORC, SUM(PP8_PRCOM) PP8_PRCOM FROM "+RetSqlName("PP8") "
		_cQry += " WHERE PP8_CODIGO = '" + (_cAlias)->PP7_CODIGO +"' "
		_cQry += " AND D_E_L_E_T_ = ' ' "
		_cQry += " GROUP BY PP8_CODIGO "

		TcQuery _cQry New Alias "TRD"

		Aadd( _aMsg , { "VLr Orcado   : "    		,TRANSFORM(TRD->PP8_PRORC ,"@E 99,999,999,999.99")	  } )
		Aadd( _aMsg , { "VLr Comercial : "    		,TRANSFORM(TRD->PP8_PRCOM ,"@E 99,999,999,999.99")	  } )

		//<<Chamado 008169

		DbSelectArea("Z1Y")
		Z1Y->(DbSetOrder(1))
		Z1Y->(DbGoTop())
		If Z1Y->(DbSeek((_cAlias)->Z1Y_FILIAL+(_cAlias)->PP7_CODIGO))
			While !(Z1Y->(Eof())) .And. Z1Y->Z1Y_NUM = (_cAlias)->PP7_CODIGO
				_cMtZ1Y:= ' '
				If Z1Y->Z1Y_MOTIVO ='1'
					_cMtZ1Y:= 'SOMENTE CUSTO'
				ElseIf Z1Y->Z1Y_MOTIVO ='2'
					_cMtZ1Y:= 'OUTRO COMPROU'
				ElseIf Z1Y->Z1Y_MOTIVO ='3'
					_cMtZ1Y:= 'ITENS INCL. PEDIDO'
				ElseIf Z1Y->Z1Y_MOTIVO ='4'
					_cMtZ1Y:= 'COMPROU NO DISTRIBUIDOR'
				ElseIf Z1Y->Z1Y_MOTIVO ='5'
					_cMtZ1Y:= 'PERDEU CONCORRENTE'
				ElseIf Z1Y->Z1Y_MOTIVO ='6'
					_cMtZ1Y:= 'PERDEU COTAгцO'
				ElseIf Z1Y->Z1Y_MOTIVO ='7'
					_cMtZ1Y:= 'CANC MASSA'
				ElseIf Z1Y->Z1Y_MOTIVO ='8'
					_cMtZ1Y:= 'COBRAR NOVAMENTE'
				EndIf

				Aadd( _aMsg , { "N╨ AlteraГЦo: " +Z1Y->Z1Y_ITEM   		, 	_cMtZ1Y } )

				Z1Y->(dbSkip())
			End
		EndIf

		If ( Type("l410Auto") == "U" .OR. !l410Auto )

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Definicao do cabecalho do email                                             Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cMsg := ""
			cMsg += '<html>'
			cMsg += '<head>'
			cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
			cMsg += '</head>'
			cMsg += '<body>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
			cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Definicao do texto/detalhe do email                                         Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			For _nLin := 1 to Len(_aMsg)
				IF (_nLin/2) == Int( _nLin/2 )
					cMsg += '<TR BgColor=#B0E2FF>'
				Else
					cMsg += '<TR BgColor=#FFFFFF>'
				EndIF
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '</TR>'
			Next
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Definicao do rodape do email                                                Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cMsg += '</Table>'
			cMsg += '<P>'
			cMsg += '<Table align="center">'
			cMsg += '<tr>'
			cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+"A"+')</td>'
			cMsg += '</tr>'
			cMsg += '</Table>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '</body>'
			cMsg += '</html>'

		EndIf

		If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			Conout("Problemas no envio de email!")
		EndIf

		(_cAlias)->(DbSkip())
	EndDo

	//>> Chamado 008075 - Everson Santana - 26/09/18

	_cQuery  := " SELECT PP7.* "
	_cQuery  += " ,to_char(sysdate - "+CVALTOCHAR(GETMV("ST_DIASALC"))+",'YYYYMMDD')  "
	_cQuery  += " ,NVL((SELECT A3_EMAIL FROM " + RetSqlName("SA3") + " A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=PP7.PP7_REPRES AND (SUBSTR(A3_COD,1,1)<>'R' OR A3_COD IN ('R00262','R00379','R00103','R00104','R00124','R00377','R00105','R00202','R00408','R00134','R00224','R00332','R00051','R00682','R00269','R00268','R00492','R00121','R00184','R00181','R00271','R00471','R00385','R00143','R00027','R00191','R00152','R00192','R00196','R00194','R00961','R00193','R00382','R00386','R00234','R00485','R00585','R00477','R00577','R00571','R00479','R00284','R00685'))),' ') EMAIL1 "
	_cQuery  += " ,NVL((SELECT A3_EMAIL FROM " + RetSqlName("SA3") + " A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=PP7.PP7_VEND AND (SUBSTR(A3_COD,1,1)<>'R' OR A3_COD IN ('R00262','R00379','R00103','R00104','R00124','R00377','R00105','R00202','R00408','R00134','R00224','R00332','R00051','R00682','R00269','R00268','R00492','R00121','R00184','R00181','R00271','R00471','R00385','R00143','R00027','R00191','R00152','R00192','R00196','R00194','R00961','R00193','R00382','R00386','R00234','R00485','R00585','R00477','R00577','R00571','R00479','R00284','R00685'))),' ') EMAIL2  "
	_cQuery  += " ,NVL((SELECT A3_EMAIL FROM " + RetSqlName("SA3") + " A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=(SELECT A3_SUPER FROM " + RetSqlName("SA3") + " A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=PP7.PP7_REPRES) AND SUBSTR(A3_COD,1,1)<>'R'),' ') EMAILSUP  "
	_cQuery  += " FROM " + RetSqlName("PP7") +" PP7 "
	_cQuery  += " WHERE PP7.PP7_STATUS IN ('1','5')  "
	_cQuery  += " AND PP7.PP7_EMISSA > '20180228' "
	_cQuery  += " AND PP7_XCODMC = ' ' "
	_cQuery  += " AND to_char(sysdate - " + CVALTOCHAR(GETMV("ST_DIASALC")) + ",'YYYYMMDD') = PP7.PP7_ENVM "
	_cQuery  += " AND (SELECT COUNT(*) FROM " + RetSqlName("Z1Y") + " Z1Y WHERE Z1Y.D_E_L_E_T_=' ' AND Z1Y_FILIAL=PP7_FILIAL AND Z1Y_NUM=PP7_CODIGO) = 0 "
	_cQuery  += " AND PP7.D_E_L_E_T_ = ' ' "

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	While (_cAlias)->(!Eof())

		DbSelectArea("PP7")
		PP7->(DbSetOrder(1)) //PP7_FILIAL+PP7_CODIGO
		PP7->(DbGoTop())
		If PP7->(DbSeek("02"+(_cAlias)->(PP7_CODIGO)))
			PP7->(RecLock("PP7",.F.))
			PP7->PP7_ENVM	:= Date()
			PP7->PP7_NUMENV	:= PP7->PP7_NUMENV+1
			PP7->(MsUnLock())
		EndIf

		_aMsg := {}

		_cEmail	  		:= AllTrim(UsrRetMail((_cAlias)->PP7_APROV))+";"+AllTrim((_cAlias)->EMAIL1)+";"+AllTrim((_cAlias)->EMAIL2)+";"+AllTrim((_cAlias)->EMAILSUP)

		If AllTrim((_cAlias)->PP7_REPRES)=="R00202" .Or. AllTrim((_cAlias)->PP7_VEND)=="R00202"  //Chamado 003025
			_cEmail			+= ";monica.jcanterorepres@uol.com.br"
		EndIf

		_cAssunto 		:= '[WFPROTHEUS] - Cobrar Unicom '+(_cAlias)->PP7_CODIGO+' - LEMBRETE: '+CVALTOCHAR(PP7->PP7_NUMENV)
		Aadd( _aMsg , { "Cliente: "    		, (_cAlias)->PP7_NOME } )
		Aadd( _aMsg , { "Obra: "    		, (_cAlias)->PP7_OBRA } )
		Aadd( _aMsg , { "End.: "    		, (_cAlias)->PP7_ENDOBR } )
		Aadd( _aMsg , { "Vendedor1: "    	, (_cAlias)->PP7_REPRES+' - '+ Alltrim(Posicione("SA3",1,xFilial("SA3")+(_cAlias)->PP7_REPRES,"A3_NOME")) } )
		Aadd( _aMsg , { "Vendedor2: "    	, (_cAlias)->PP7_VEND+' - '+ Alltrim(Posicione("SA3",1,xFilial("SA3")+(_cAlias)->PP7_VEND,"A3_NOME")) } )

		//>>Chamado 008169 - Everson Santana - 10.10.2018

		If Select("TRD") > 0
			TRD->(DbCloseArea())
		Endif

		_cQry := " "
		_cQry += " SELECT PP8_CODIGO, SUM(PP8_PRORC) PP8_PRORC, SUM(PP8_PRCOM) PP8_PRCOM FROM "+RetSqlName("PP8") "
		_cQry += " WHERE PP8_CODIGO = '" + (_cAlias)->PP7_CODIGO +"' "
		_cQry += " AND D_E_L_E_T_ = ' ' "
		_cQry += " GROUP BY PP8_CODIGO "

		TcQuery _cQry New Alias "TRD"

		Aadd( _aMsg , { "VLr Orcado   : "    		,TRANSFORM(TRD->PP8_PRORC ,"@E 99,999,999,999.99")	  } )
		Aadd( _aMsg , { "VLr Comercial : "    		,TRANSFORM(TRD->PP8_PRCOM ,"@E 99,999,999,999.99")	  } )

		//<<Chamado 008169

		DbSelectArea("Z1Y")
		Z1Y->(DbSetOrder(1))
		Z1Y->(DbGoTop())
		If Z1Y->(DbSeek((_cAlias)->PP7_FILIAL+(_cAlias)->PP7_CODIGO))
			While !(Z1Y->(Eof())) .And. Z1Y->Z1Y_NUM = (_cAlias)->PP7_CODIGO
				_cMtZ1Y:= ' '
				If Z1Y->Z1Y_MOTIVO ='1'
					_cMtZ1Y:= 'SOMENTE CUSTO'
				ElseIf Z1Y->Z1Y_MOTIVO ='2'
					_cMtZ1Y:= 'OUTRO COMPROU'
				ElseIf Z1Y->Z1Y_MOTIVO ='3'
					_cMtZ1Y:= 'ITENS INCL. PEDIDO'
				ElseIf Z1Y->Z1Y_MOTIVO ='4'
					_cMtZ1Y:= 'COMPROU NO DISTRIBUIDOR'
				ElseIf Z1Y->Z1Y_MOTIVO ='5'
					_cMtZ1Y:= 'PERDEU CONCORRENTE'
				ElseIf Z1Y->Z1Y_MOTIVO ='6'
					_cMtZ1Y:= 'PERDEU COTAгцO'
				ElseIf Z1Y->Z1Y_MOTIVO ='7'
					_cMtZ1Y:= 'CANC MASSA'
				ElseIf Z1Y->Z1Y_MOTIVO ='8'
					_cMtZ1Y:= 'COBRAR NOVAMENTE'
				EndIf

				Aadd( _aMsg , { "N╨ AlteraГЦo: " +Z1Y->Z1Y_ITEM   		, 	_cMtZ1Y } )

				Z1Y->(dbSkip())
			End
		EndIf

		If ( Type("l410Auto") == "U" .OR. !l410Auto )

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Definicao do cabecalho do email                                             Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cMsg := ""
			cMsg += '<html>'
			cMsg += '<head>'
			cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
			cMsg += '</head>'
			cMsg += '<body>'
			//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
			cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Definicao do texto/detalhe do email                                         Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			For _nLin := 1 to Len(_aMsg)
				IF (_nLin/2) == Int( _nLin/2 )
					cMsg += '<TR BgColor=#B0E2FF>'
				Else
					cMsg += '<TR BgColor=#FFFFFF>'
				EndIF
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '</TR>'
			Next
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Definicao do rodape do email                                                Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cMsg += '</Table>'
			cMsg += '<P>'
			cMsg += '<Table align="center">'
			cMsg += '<tr>'
			cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+"B"+')</td>'
			cMsg += '</tr>'
			cMsg += '</Table>'
			cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
			cMsg += '</body>'
			cMsg += '</html>'

		EndIf

		If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			Conout("Problemas no envio de email!")
		EndIf

		(_cAlias)->(DbSkip())
	EndDo
	//<<

	Reset Environment

Return()

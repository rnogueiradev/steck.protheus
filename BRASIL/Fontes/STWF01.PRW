#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#Define CR chr(13)+chr(10)
#DEFINE Cr chr(13)+chr(10)

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁSTWF01	╨Autor  ЁGiovani Zago     ╨ Data Ё  02/08/17      ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁWF RH														  ╨╠╠
╠╠╨          Ё   													      ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Parametro Ё Nenhum                                                     ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╨Retorno   Ё Nenhum                                                     ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
User Function STWF01( )

	Local cAliasSuper:= 'STWF01'
	Local cQuery     := ' '
	Local _aMsg 	 := {}
	Local _cDat      := ' '

	RpcSetType( 3 )
	RpcSetEnv("01","04",,,"FAT")


	cQuery := " SELECT C6_NUM, C6_ITEM  ,   C6_PRODUTO, C6_QTDVEN,C6_PRCVEN FROM SC6010 SC6 WHERE SC6.D_E_L_E_T_ = ' ' AND C6_FILIAL = '04' AND C6_CLI = '033467' AND C6_LOJA = '02' AND C6_BLQ <> 'R' AND C6_QTDVEN > C6_QTDENT ORDER BY C6_NUM,C6_ITEM


	cQuery := ChangeQuery(cQuery)

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"Numero","Item","Produto","Qtd.Ven.","Prc.Vend.","Prc.Atual"}  )

		While 	(cAliasSuper)->(!Eof())
			lRet := .F.
			_nVal:= 0
			_nVal:= Round((U_STCUSTO((cAliasSuper)->C6_PRODUTO)/0.82),2)
			If _nVal = 0
				DbSelectArea("SB2")
				SB2->(DbSetOrder(1))
				If SB2->(DbSeek(xFilial("SB2")+(cAliasSuper)->C6_PRODUTO+'01'))
					If SB2->B2_QATU <> 0
						lRet := .T.
					EndIf
				EndIf
				DbSelectArea("SB2")
				SB2->(DbSetOrder(1))
				If SB2->(DbSeek(xFilial("SB2")+(cAliasSuper)->C6_PRODUTO+'03'))
					If SB2->B2_QATU <> 0
						lRet := .T.
					EndIf
				EndIf
				DbSelectArea("SB2")
				SB2->(DbSetOrder(1))
				If SB2->(DbSeek(xFilial("SB2")+(cAliasSuper)->C6_PRODUTO+'15'))
					If SB2->B2_QATU <> 0
						lRet := .T.
					EndIf
				EndIf


				If	lRet

					aadd(_aMsg,{(cAliasSuper)->C6_NUM,;
						(cAliasSuper)->C6_ITEM,;
						(cAliasSuper)->C6_PRODUTO,;
						Transform((cAliasSuper)->C6_QTDVEN,"@E 999,999,999.99") ,;
						Transform((cAliasSuper)->C6_PRCVEN,"@E 999,999,999.99") ,;
						Transform( _nVal ,"@E 999,999,999.99") }  )
				EndIf
			EndIf
			(cAliasSuper)->(dbskip())

		End
	EndIf

	If Len(_aMsg) > 1
		_cEmail  :=  "  reinaldo.franca@steck.com.br  ;gisele.jesus@steck.com.br;ULISSES.ALMEIDA@STECK.COM.BR  "
		STWFRH(_aMsg,_cEmail)
	EndIf
	_aMsg:= {}
	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"Numero","Item","Produto","Qtd.Ven.","Prc.Vend.","Prc.Atual"}  )

		While 	(cAliasSuper)->(!Eof())
			_nVal:= 0
			_nVal:= Round((U_STCUSTO((cAliasSuper)->C6_PRODUTO)/0.82),2)
			If _nVal <> 0
				If (_nVal / (cAliasSuper)->C6_PRCVEN) < 0.95 .Or. (_nVal / (cAliasSuper)->C6_PRCVEN) > 1.05
					aadd(_aMsg,{(cAliasSuper)->C6_NUM,;
						(cAliasSuper)->C6_ITEM,;
						(cAliasSuper)->C6_PRODUTO,;
						Transform((cAliasSuper)->C6_QTDVEN,"@E 999,999,999.99") ,;
						Transform((cAliasSuper)->C6_PRCVEN,"@E 999,999,999.99") ,;
						Transform( _nVal ,"@E 999,999,999.99") }  )
				EndIf
			EndIf
			(cAliasSuper)->(dbskip())

		End
	EndIf

	If Len(_aMsg) > 1
		_cEmail  :=  "  reinaldo.franca@steck.com.br   ;gisele.jesus@steck.com.br;ULISSES.ALMEIDA@STECK.COM.BR  "
		STWFRH(_aMsg,_cEmail)
	EndIf


	Reset Environment
Return()


	*------------------------------------------------------------------*
Static Function STWFRH(_aMsg,_cEmail)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Erro de Valor Pv-Fabrica'
	Local cFuncSent:= "STWFRH"
	//Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  :=''
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
	default _cEmail  :=  "  reinaldo.franca@steck.com.br  ;gisele.jesus@steck.com.br;ULISSES.ALMEIDA@STECK.COM.BR  "

	Dbselectarea('SB1')
	SB1->(dbsetorder(1))

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
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=80%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do texto/detalhe do email                                         Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'



			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'

			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'


		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)


	EndIf
	RestArea(aArea)
Return()




User Function STWF02( )


	Local cAliasSuper:= 'STWF02'
	Local cQuery     := ' '
	Local _aMsg 	 := {}
	Local _cDat      := ' '
	Local _cAviso	 := '000'
	Private _nVal	 := 50000

	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")
	RpcSetEnv("11","01",,,"FAT")       // Valdemir Rabelo 28/01/2022


	cQuery := " SELECT SC5.R_E_C_N_O_ AS REC,A1_COD||'-'||A1_LOJA||' - '|| TRIM(A1_NOME) AS NOMECLI,SUBSTR(SC5.C5_EMISSAO,7,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,5,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,1,4) AS c5_emissao,C5_NUM, C5_VEND1,SA3.A3_NOME N1 ,C5_VEND2,TA3.A3_NOME N2 ,VA3.A3_NOME COORDENADOR,VA3.A3_EMAIL,SUM(round( (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)    ,2)         ) TOTAL  FROM SC5010 SC5 INNER JOIN(SELECT * FROM SC6010)SC6 ON SC6.D_E_L_E_T_ = ' ' AND C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6_OPER = '01' AND C6_QTDVEN> C6_QTDENT AND C6_BLQ <> 'R' INNER JOIN(SELECT * FROM SA3010)SA3 ON SA3.D_E_L_E_T_ = ' ' AND SA3.A3_COD = C5_VEND1 INNER JOIN(SELECT * FROM SA1010)SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = C5_CLIENTE AND SA1.A1_LOJA = C5_LOJACLI INNER JOIN(SELECT * FROM SA3010)TA3 ON TA3.D_E_L_E_T_ = ' ' AND TA3.A3_COD = C5_VEND2 INNER JOIN(SELECT * FROM SA3010)VA3 ON VA3.D_E_L_E_T_ = ' ' AND VA3.A3_COD = SA3.A3_SUPER WHERE SC5.D_E_L_E_T_ = ' '
	//cQuery += " and c5_xmate <> '"+ soma1(substr(dtos(date()),5,2))+" '
	cQuery += " AND  C5_XAANO||c5_xmate||C5_XATE   BETWEEN ' ' AND '"+ soma1(dtos(date()))+" '
	cQuery += " AND C5_EMISSAO > '20160101' AND C5_FILIAL = '02' AND NOT EXISTS( SELECT * FROM PA1010 PA1 WHERE PA1.D_E_L_E_T_ = ' ' AND PA1_FILIAL = C5_FILIAL AND SUBSTR(PA1_DOC,1,6) = C5_NUM) AND NOT EXISTS( SELECT * FROM SC9010 SC9 WHERE SC9.D_E_L_E_T_ = ' ' AND C9_FILIAL = C5_FILIAL AND C9_PEDIDO = C5_NUM AND C9_BLCRED  IN ('01','04','05','06','09') )  AND NOT EXISTS( SELECT * FROM CB7010 CB7 WHERE CB7.D_E_L_E_T_ = ' ' AND CB7_FILIAL = C5_FILIAL AND CB7_PEDIDO = C5_NUM AND CB7_STATUS  IN ('1','2','3','4') ) GROUP BY SC5.R_E_C_N_O_ , A1_COD||'-'||A1_LOJA||' - '|| TRIM(A1_NOME), c5_emissao,C5_NUM, C5_VEND1,SA3.A3_NOME,C5_VEND2,TA3.A3_NOME ,VA3.A3_NOME,VA3.A3_EMAIL ORDER BY VA3.A3_EMAIL,c5_NUM





	cQuery := ChangeQuery(cQuery)

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"Cliente","Numero","EmissЦo","Vend1","Vend2","Coordenador","Valor","Aviso"}  )
		_cmail:= ' '
		While 	(cAliasSuper)->(!Eof())
			If (cAliasSuper)->TOTAL <= _nVal
				If _cmail <> 	(cAliasSuper)->A3_EMAIL
					If Len(_aMsg) > 1
						_cEmail  := _cmail
						STWFR2(_aMsg,_cEmail,_nVal)
						_aMsg:={}
						aadd(_aMsg,{"Cliente","Numero","EmissЦo","Vend1","Vend2","Coordenador","Valor","Aviso"}  )
					EndIf


				EndIf
				DbSelectArea("SC5")
				SC5->(DbGoTo((cAliasSuper)->REC ))
				If (cAliasSuper)->REC    = SC5->(RECNO())
					_cAviso	 := SC5->C5_XAVISO
					If Empty(Alltrim(_cAviso))
						_cAviso:= '000'
					EndIf
					_cAviso:= SOMA1(_cAviso)
					SC5->(RecLock("SC5",.F.))
					SC5->C5_XAVISO	:=  _cAviso
					SC5->(MsUnlock())
					SC5->(DbCommit())
				EndIf

				If SC5->C5_XAVISO <> '001'
					aadd(_aMsg,{(cAliasSuper)->NOMECLI,;
						(cAliasSuper)->C5_NUM,;
						(cAliasSuper)->C5_EMISSAO,;
						(cAliasSuper)->C5_VEND1+' - '+(cAliasSuper)->N1,;
						(cAliasSuper)->C5_VEND2+' - '+(cAliasSuper)->N2,;
						(cAliasSuper)->COORDENADOR,;
						Transform( (cAliasSuper)->TOTAL ,"@E 999,999,999.99"),;
						SC5->C5_XAVISO }  )
				EndIf
				_cmail := 	(cAliasSuper)->A3_EMAIL
			EndIf
			(cAliasSuper)->(dbskip())

		End
	EndIf
	If Len(_aMsg) > 1
		_cEmail  := _cmail

		STWFR2(_aMsg,_cEmail,_nVal)

		_aMsg:={}
		aadd(_aMsg,{"Cliente","Numero","EmissЦo","Vend1","Vend2","Coordenador","Valor","Aviso"}  )
	EndIf

	Reset Environment
Return()


	*------------------------------------------------------------------*
Static Function STWFR2(_aMsg,_cEmail,_nVal)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Pv. Completo Abaixo de R$ ' +Transform(_nVal,'@E 999,999.99')
	Local cFuncSent:= "STWFR2"
	//Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  :=''
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
	default _cEmail  :=""  
	_cEmail:= Alltrim(_cEmail)
	If 'DANIEL' $ Upper(_aMsg[2,6])
		_cEmail+= ';carla.lodetti@STECK.COM.BR;FILIPE.NASCIMENTO@STECK.COM.BR;marcelo.oliveira@steck.com.br;bruno.galvao@steck.com.br"
	ElseIf 'MARLON' $ Upper(_aMsg[2,6])
		_cEmail+= ';carla.lodetti@STECK.COM.BR;FILIPE.NASCIMENTO@STECK.COM.BR;bruno.galvao@steck.com.br'
	ElseIf 'VIVIANE' $ Upper(_aMsg[2,6])
		_cEmail+= ';carla.lodetti@STECK.COM.BR;FILIPE.NASCIMENTO@STECK.COM.BR;bruno.galvao@steck.com.br'
	ElseIf 'PRISCILLA' $ Upper(_aMsg[2,6])
		_cEmail+= ';carla.lodetti@STECK.COM.BR;marcelo.oliveira@steck.com.br'
	ElseIf 'MARCO' $ Upper(_aMsg[2,6])
		_cEmail+= ';carla.lodetti@STECK.COM.BR;FILIPE.NASCIMENTO@STECK.COM.BR;bruno.galvao@steck.com.br'
	ElseIf 'ALESSI' $ Upper(_aMsg[2,6])
		_cEmail+= ';carla.lodetti@STECK.COM.BR;FILIPE.NASCIMENTO@STECK.COM.BR;bruno.galvao@steck.com.br'
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
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=80%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do texto/detalhe do email                                         Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></TD>'
			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'


		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,,,"   ")


	EndIf
	RestArea(aArea)
Return()







User Function STWF03( )


	Local cAliasSuper:= 'STWF03'
	Local cQuery     := ' '
	Local _aMsg 	 := {}
	Local _cDat      := ' '

	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")
	RpcSetEnv("11","01",,,"FAT")                     // Valdemir Rabelo 28/01/2022
	STWFR3()

	// Valdemir Rabelo 28/01/2022 Ajustado para alias banco de dados
	cQuery := " SELECT A1_COD||'-'||A1_LOJA||' - '|| TRIM(A1_NOME) AS NOMECLI,SUBSTR(SC5.C5_EMISSAO,7,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,5,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,1,4) AS c5_emissao,C5_NUM, C5_VEND1,SA3.A3_NOME N1 ,C5_VEND2,TA3.A3_NOME N2 ,VA3.A3_NOME COORDENADOR,VA3.A3_EMAIL,SUM(round( (SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*(SC6.C6_QTDVEN - SC6.C6_QTDENT)    ,2)         ) TOTAL  FROM " + getAliasBD('SC5')[1] +" SC5 INNER JOIN(SELECT * FROM " + getAliasBD('SC6')[1] +")SC6 ON SC6.D_E_L_E_T_ = ' ' AND C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6_OPER = '01' AND C6_QTDVEN> C6_QTDENT AND C6_BLQ <> 'R' INNER JOIN(SELECT * FROM " + getAliasBD('SA3')[1] +")SA3 ON SA3.D_E_L_E_T_ = ' ' AND SA3.A3_COD = C5_VEND1 INNER JOIN(SELECT * FROM " + getAliasBD('SA1')[1] +")SA1 ON SA3.D_E_L_E_T_ = ' ' AND SA1.A1_COD = C5_CLIENTE AND SA1.A1_LOJA = C5_LOJACLI INNER JOIN(SELECT * FROM " + getAliasBD('SA3')[1] +")TA3 ON TA3.D_E_L_E_T_ = ' ' AND TA3.A3_COD = C5_VEND2 INNER JOIN(SELECT * FROM " + getAliasBD('SA3')[1] +")VA3 ON VA3.D_E_L_E_T_ = ' ' AND VA3.A3_COD = SA3.A3_SUPER WHERE SC5.D_E_L_E_T_ = ' '  AND C5_EMISSAO > '20160101' AND C5_FILIAL = '" + getAliasBD('SC5')[2] +"' AND NOT EXISTS( SELECT * FROM " + getAliasBD('PA1')[1] +" PA1 WHERE PA1.D_E_L_E_T_ = ' ' AND PA1_FILIAL = C5_FILIAL AND SUBSTR(PA1_DOC,1,6) = C5_NUM) AND NOT EXISTS( SELECT * FROM " + getAliasBD('SC9')[1] +" SC9 WHERE SC9.D_E_L_E_T_ = ' ' AND C9_FILIAL = C5_FILIAL AND C9_PEDIDO = C5_NUM AND C9_BLCRED NOT IN ('01','04','05','06','09') )  AND NOT EXISTS( SELECT * FROM " + getAliasBD('CB7')[1] +" CB7 WHERE CB7.D_E_L_E_T_ = ' ' AND CB7_FILIAL = C5_FILIAL AND CB7_PEDIDO = C5_NUM AND CB7_STATUS NOT IN ('01','02','03','04') ) GROUP BY  A1_COD||'-'||A1_LOJA||' - '|| TRIM(A1_NOME), c5_emissao,C5_NUM, C5_VEND1,SA3.A3_NOME,C5_VEND2,TA3.A3_NOME ,VA3.A3_NOME,VA3.A3_EMAIL ORDER BY VA3.A3_EMAIL,TOTAL,c5_emissao





	cQuery := ChangeQuery(cQuery)

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0

		_cmail:= ' '
		While 	(cAliasSuper)->(!Eof())

			STWFR2(_aMsg,_cEmail)

			(cAliasSuper)->(dbskip())

		End
	EndIf

	Reset Environment
Return()


	*------------------------------------------------------------------*
Static Function STWFR3(_aMsg,_cEmail)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Campanha de Vendas STECK'
	Local cFuncSent:= "STWFR3"
	//Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  :='"
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
	default _cEmail  :=  "   "
	default _aMsg:={}
	If ( Type("l410Auto") == "U" .OR. !l410Auto )



		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do cabecalho do email                                             Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg := ""

		cMsg := '<html>	<head> 	<title>' + _cAssunto +'</title> </head>
		cMsg += '<body>	<div style="text-align: center;">	<img alt="" src="http://www.steck.com.br/wp-content/themes/temasteck/img/teckinho.png" style="width: 80px; height: 154px;" />OLA CLIENTE STECK, ESTAMOS COM UMA CAMPANHA DE VENDAS IMPERDIVEL, ENTRE EM CONTATO RESPONDENDO ESTE E-MAIL OU PELO TELEFONE: (11) 2248-7000.</div>
		cMsg += '<div style="text-align: center;"> &nbsp;</div> 	</body> </html>


		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)


	EndIf
	RestArea(aArea)
Return()




User Function STWF04( )



	Local _aSTWF04	 := {}
	Local i

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	If Getmv("ST_WF04",,.T.)

		dbSelectArea("Z1V")
		Z1V->(dbgotop())
		Z1V->(dbsetorder(1))
		While 	Z1V->(!Eof())

			Aadd(_aSTWF04,{Z1V->Z1V_COD,"('"+Z1V->Z1V_LOJA+"')"	, Alltrim(Z1V->Z1V_EMAIL1)	,Alltrim(Z1V->Z1V_EMAIL2) 	})


			Z1V->(dbskip())

		End
	Else

		Aadd(_aSTWF04,{'001236',"('01','03','06','09')"	, 'adriano.lijas@andra.com.br'		,'herig.nascimento@steck.com.br ; carla.lodetti@steck.com.br' 	})
		Aadd(_aSTWF04,{'001236',"('04')", 'compras.jvl@andra.com.br'		,'herig.nascimento@steck.com.br ; carla.lodetti@steck.com.br' 	})
		Aadd(_aSTWF04,{'001236',"('05')", 'edgar@andra.com.br'				,'herig.nascimento@steck.com.br ; carla.lodetti@steck.com.br' 	})
		Aadd(_aSTWF04,{'003322',"('01')", 'jessica.freitas@maxel.com.br'	,'danielle.bronharo@steck.com.br; carla.lodetti@steck.com.br' 	})
		Aadd(_aSTWF04,{'003322',"('02')", 'vieira@maxel.com.br ; daiane.vieira@maxel.com.br '	,'danielle.bronharo@steck.com.br; carla.lodetti@steck.com.br' 	})
		Aadd(_aSTWF04,{'006596',"X"		, 'kathiuce.souza@nortel.com.br'	,'carla.lodetti@STECK.COM.BR;FILIPE.NASCIMENTO@STECK.COM.BR;bruno.galvao@steck.com.br' 		})
		Aadd(_aSTWF04,{'000224',"('01')", 'aleksandra.silva@steck.com.br'	,'ana.luiza@steck.com.br;carla.lodetti@steck.com.br; aleksandra.silva@steck.com.br' 		}) //Ticket 20201119010847 Everson Santana 
		Aadd(_aSTWF04,{'000224',"('03')", 'aleksandra.silva@steck.com.br'	,'ana.luiza@steck.com.br;carla.lodetti@steck.com.br; aleksandra.silva@steck.com.br' 		}) //Ticket 20201119010847
		Aadd(_aSTWF04,{'000224',"('04')", 'aleksandra.silva@steck.com.br'	,'ana.luiza@steck.com.br;carla.lodetti@steck.com.br; aleksandra.silva@steck.com.br' 		}) //Ticket 20201119010847
		Aadd(_aSTWF04,{'000224',"('05')", 'aleksandra.silva@steck.com.br'	,'ana.luiza@steck.com.br;carla.lodetti@steck.com.br; aleksandra.silva@steck.com.br' 		}) //Ticket 20201119010847
		Aadd(_aSTWF04,{'003382',"('01')", 'simone.valencio@dimensional.com.br;caroline.savazzi@dimensional.com.br'		,'carla.lodetti@STECK.COM.BR;FILIPE.NASCIMENTO@STECK.COM.BR;bruno.galvao@steck.com.br' 		})
	EndIf

	For i:= 1 To Len(_aSTWF04)

		ASTWF04( _aSTWF04[i])

	Next i

Return()

STATIC Function ASTWF04( _aSTWF04)


	Local cAliasSuper	:= 'STWF04'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:= _aSTWF04[3]
	Local _cCop			:= _aSTWF04[4]

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")



	cQuery := " SELECT
	cQuery += " C5_NUM                 AS PEDIDO,
	cQuery += "  C5_EMISSAO             AS EMISSAO,
	cQuery += " C6_PRODUTO             AS PRODUTO,
	cQuery += " C6_XORDEM              AS ORDEM,
	cQuery += " C6_QTDVEN   			AS QTDVEN  ,
	cQuery += " C6_QTDENT   			AS QTDENT  ,
	cQuery += " C6_XPREV   				AS XPREV  ,
	cQuery += " C6_QTDVEN-C6_QTDENT    AS SALDO ,
	cQuery += "  C6_ITEMPC              AS ITEMPC,
	cQuery += " C6_NUMPCOM             AS NUMPC,
	cQuery += " NVL(PA1_QUANT,0)        AS FALTA,
	cQuery += " NVL(PA2_QUANT,0)        AS RESERVA,
	cQuery += " C6_ENTRE1               AS ENTREGA1,
	cQuery += " C6_ZENTRE2              AS ENTREGA2



	cQuery += "  FROM " + getAliasBD('SC6')[1] +" SC6    "  // Valdemir Rabelo 28/01/2022

	cQuery += " INNER JOIN(SELECT * FROM " + getAliasBD('SC5')[1] +")SC5
	cQuery += " ON SC5.D_E_L_E_T_ = ' '
	cQuery += " AND C5_NUM = C6_NUM
	cQuery += " AND C5_FILIAL = C6_FILIAL
	cQuery += " AND C5_EMISSAO >= '20180101' AND C5_ZMOTBLO NOT LIKE '%EDI%'

	cQuery += " LEFT JOIN(SELECT * FROM " + getAliasBD('PA1')[1] +")PA1
	cQuery += " ON PA1.D_E_L_E_T_ = ' '
	cQuery += " AND PA1.PA1_FILIAL = C6_FILIAL
	cQuery += " AND PA1_DOC = C6_NUM||C6_ITEM

	cQuery += " LEFT JOIN(SELECT * FROM " + getAliasBD('PA2')[1] +")PA2
	cQuery += " ON PA2.D_E_L_E_T_ = ' '
	cQuery += " AND PA2_FILRES = C6_FILIAL
	cQuery += " AND PA2_DOC = C6_NUM||C6_ITEM

	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_BLQ <> 'R'
	cQuery += " AND C6_QTDVEN > C6_QTDENT
	cQuery += " AND C6_FILIAL = '" + getAliasBD('SC6')[2] +"'
	cQuery += " AND C5_CLIENTE = '"+_aSTWF04[1] +"'
	If _aSTWF04[2] <> 'X'
		cQuery += " AND C5_LOJACLI IN  "+_aSTWF04[2]
	EndIf
	cQuery += " ORDER BY C5_NUM,C6_ITEM



	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"PEDIDO-STECK","EMISSAO","PRODUTO-STECK","REF.CLIENTE","QTD.PEDIDA" ,"QTD.ENTREGUE",;
			"QTD.PENDENTE","QTD.RESERVA","PREVISцO DE FATURAMENTO","NUMPC" ,"ITEMPC" })


		While 	(cAliasSuper)->(!Eof())

			aadd(_aMsg,{(cAliasSuper)->PEDIDO,;
				dtoc( stod((cAliasSuper)->EMISSAO)),;
				(cAliasSuper)->PRODUTO,;
				(cAliasSuper)->ORDEM,;
				Transform((cAliasSuper)->QTDVEN,"@E 999,999,999"),;
				Transform((cAliasSuper)->QTDENT,"@E 999,999,999"),;
				Transform((cAliasSuper)->FALTA,"@E 999,999,999"),;
				Transform((cAliasSuper)->RESERVA,"@E 999,999,999"),;
				DTOC(stod(  Iif(   !(Empty(Alltrim((cAliasSuper)->ENTREGA2))),(cAliasSuper)->ENTREGA2  ,(cAliasSuper)->ENTREGA1 )));
				+   Iif(!(Empty(Alltrim((cAliasSuper)->XPREV))),'*'  ,' ') ,;
				(cAliasSuper)->NUMPC,;
				(cAliasSuper)->ITEMPC }  )


			(cAliasSuper)->(dbskip())

		End
	EndIf
	If Len(_aMsg) > 1


		STWFR4(_aMsg,_cmail,_cCop)

		_aMsg:={}

	EndIf

	Reset Environment
Return()


	*------------------------------------------------------------------*
Static Function STWFR4(_aMsg,_cEmail,_cCopia)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'PrevisЦo de faturamento de Pedidos '
	Local cFuncSent		:= "STWFR4"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:=''


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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></TD>'
			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado

		//	U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,,,' ') //nao envia mais para o cliente ate segunda ordem falar com giovani ou tereza mello 18/02/2021
		EndIf

	EndIf
	RestArea(aArea)
Return()

Static Function MMGB1(_cCod)
	Local cAliasSuper:= 'MMGB1'
	Local cQuery     := ' '
	Local _nRet      := 0


	cQuery := "	 SELECT nvl(SUM(ROUND(MMG.C6_QTDVEN - MMG.C6_QTDENT,2)),0) AS COD  FROM " + getAliasBD('SC6')[1] +" MMG WHERE MMG.D_E_L_E_T_ = ' '	  AND MMG.C6_QTDVEN - MMG.C6_QTDENT > 0	 AND MMG.C6_PRODUTO = '"+_cCod+"'	 AND MMG.C6_FILIAL  = '"+ getAliasBD('SC6')[2] +"'	 AND MMG.C6_CLI     = '033467'	  AND MMG.C6_LOJA    = '02'	 AND MMG.C6_OPER    = '94'	 AND MMG.C6_BLQ     <> 'R'


	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		_nRet:= (cAliasSuper)->COD
	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return(_nRet)


Static Function MMGB2(_cCod)
	Local cAliasSuper:= 'MMGB1'
	Local cQuery     := ' '
	Local _nRet      := 0

	// Valdemir Rabelo 28/01/2022 - Adicionado Alias do BD Chamado: 20220124001840
	cQuery := "	 SELECT nvl(SUM(ROUND(MMG.C6_QTDVEN - MMG.C6_QTDENT,2)),0) AS COD  FROM UDBP12.SC6030 MMG WHERE MMG.D_E_L_E_T_ = ' '	  AND MMG.C6_QTDVEN - MMG.C6_QTDENT > 0	 AND MMG.C6_PRODUTO = '"+_cCod+"'	 AND MMG.C6_FILIAL  = '01'	 AND MMG.C6_CLI     = '033467'	  AND MMG.C6_LOJA    = '02'	 AND MMG.C6_OPER    = '15'	 AND MMG.C6_BLQ     <> 'R'


	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		_nRet:= (cAliasSuper)->COD
	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return(_nRet)

User Function STWF05( )
	Local cAliasSuper	:= 'STWF05'
	Local cQuery     	:= ' '
	Local _aMsgi	 	:= {}
	Local _aMsgam	 	:= {}
	Local _aMsgsp	 	:= {}
	Local _cmail		:= '' //Ticket 20201029009696
	Local _cCop			:= '' //Ticket 20201029009696

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")      // '01' - '02' Valdemir Rabelo 28/01/2022 - Chamado: 20220124001840

	cQuery := " SELECT
	cQuery += "  C6_PRODUTO             AS PRODUTO,SB1.B1_GRUPO,
	cQuery += "   CASE WHEN SB1.B1_CLAPROD = 'F' THEN 'SP' ELSE
	cQuery += "   CASE WHEN SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F' THEN 'AM' ELSE
	cQuery += "   CASE WHEN SB1.B1_CLAPROD = 'I' THEN 'IMPORTADO' ELSE ' ' END END END
	cQuery += "   AS ORIGEM ,
	cQuery += " SUM( NVL(PA1_QUANT,0))  AS FALTA
	cQuery += "  FROM " + getAliasBD('SC6')[1] +" SC6
	cQuery += "  INNER JOIN(SELECT * FROM " + getAliasBD('SC5')[1] +")SC5
	cQuery += "  ON SC5.D_E_L_E_T_ = ' '
	cQuery += "  AND C5_NUM = C6_NUM
	cQuery += "  AND C5_FILIAL = C6_FILIAL   AND C5_CLIENTE <> '033467'
	cQuery += "  AND C5_EMISSAO BETWEEN '20200101' AND '"+ DTOS(DATE()-1)+"'
	cQuery += "  INNER JOIN(SELECT * FROM " + getAliasBD('PA1')[1] +")PA1
	cQuery += "  ON PA1.D_E_L_E_T_ = ' '
	cQuery += "  AND PA1.PA1_FILIAL = C6_FILIAL
	cQuery += "  AND PA1_DOC = C6_NUM||C6_ITEM
	cQuery += " INNER JOIN(SELECT * FROM " + getAliasBD('SB1')[1] +")SB1
	cQuery += "  ON SB1.D_E_L_E_T_ = ' '
	cQuery += "  AND SB1.B1_COD = C6_PRODUTO AND SB1.B1_TIPO = 'PA'
	cQuery += "  	LEFT JOIN(SELECT * FROM UDBP12.SB1030)TB1
	cQuery += "  ON TB1.D_E_L_E_T_ = ' '
	cQuery += "  AND TB1.B1_COD = C6_PRODUTO
	cQuery += "  WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += "  AND C6_BLQ <> 'R' AND C6_PRODUTO <> 'CA2010AB'  AND C6_PRODUTO <> 'CA2010B' "//GIOVANI ZAGO TEMPORARIAMNTE DESCONSIDERAR ATE AS RUPTURAS FOR SANADAS 03/03/2021
	cQuery += "  AND C6_QTDVEN > C6_QTDENT
	cQuery += "  AND C6_FILIAL = '02'
	cQuery += "  AND C6_XPREV = ' '  AND EXISTS (SELECT * FROM " + getAliasBD('SC9')[1] +" SC9 WHERE SC9.D_E_L_E_T_ = ' '  AND C9_PEDIDO = C6_NUM AND C9_FILIAL = C6_FILIAL AND C9_ITEM = C6_ITEM AND C9_PRODUTO = C6_PRODUTO AND C9_BLCRED = ' '   )

	cQuery += "  GROUP BY C6_PRODUTO,SB1.B1_GRUPO,  CASE WHEN SB1.B1_CLAPROD = 'F' THEN 'SP' ELSE
	cQuery += "  CASE WHEN SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F' THEN 'AM' ELSE
	cQuery += "  CASE WHEN SB1.B1_CLAPROD = 'I' THEN 'IMPORTADO' ELSE ' ' END END END

	cQuery += "  ORDER BY CASE WHEN SB1.B1_CLAPROD = 'F' THEN 'SP' ELSE
	cQuery += "    CASE WHEN SB1.B1_CLAPROD = 'C' AND TB1.B1_CLAPROD = 'F' THEN 'AM' ELSE
	cQuery += "    CASE WHEN SB1.B1_CLAPROD = 'I' THEN 'IMPORTADO' ELSE ' ' END END END 	,C6_PRODUTO

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())

	If  Select(cAliasSuper) > 0
		aadd(_aMsgI ,{"ITEM","PRODUTO","ORIGEM","QTD.FALTA" })
		aadd(_aMsgAM,{"ITEM","PRODUTO","ORIGEM","QTD.FALTA","GRUPO","MMG"  })
		aadd(_aMsgsp,{"ITEM","PRODUTO","ORIGEM","QTD.FALTA","GRUPO","MMG" })

		While 	(cAliasSuper)->(!Eof())
			If !((cAliasSuper)->PRODUTO <> 'SUNICOM' .And. (cAliasSuper)->B1_GRUPO = '999')
				If Alltrim((cAliasSuper)->ORIGEM) == 'AM'
					If MMGB2((cAliasSuper)->PRODUTO) > 0
						aadd(_aMsgAM,{'',(cAliasSuper)->PRODUTO,;
							(cAliasSuper)->ORIGEM,;
							Transform((cAliasSuper)->FALTA,"@E 999,999,999") ,;
							(cAliasSuper)->B1_GRUPO,;
							Transform(MMGB2((cAliasSuper)->PRODUTO),"@E 999,999,999") }  )
					EndIf
				ElseIf Alltrim((cAliasSuper)->ORIGEM) == 'IMPORTADO'
					aadd(_aMsgI,{'',(cAliasSuper)->PRODUTO,;
						(cAliasSuper)->ORIGEM,;
						Transform((cAliasSuper)->FALTA,"@E 999,999,999") }  )
				ElseIf Alltrim((cAliasSuper)->ORIGEM) == 'SP'
					If MMGB1((cAliasSuper)->PRODUTO) > 0
						aadd(_aMsgsp,{'',(cAliasSuper)->PRODUTO,;
							(cAliasSuper)->ORIGEM,;
							Transform((cAliasSuper)->FALTA,"@E 999,999,999"),;
							(cAliasSuper)->B1_GRUPO,;
							Transform(MMGB1((cAliasSuper)->PRODUTO),"@E 999,999,999") }  )
					EndIf
				EndIf
			EndIf
			(cAliasSuper)->(dbskip())
		End
	EndIf

	If Len(_aMsgsp) > 1
		_cmail:= 'ulisses.almeida@steck.com.br;luciano.fernandes@steck.com.br;alex.lourenco@steck.com.br;paulo.cruz@steck.com.br;rodrigo.ferreira@steck.com.br;thiago.ribeiro@steck.com.br'
		STWFR5(_aMsgsp,_cmail,_cCop,.T.)
		_aMsgsp:={}
	EndIf

	If Len(_aMsgAM) > 1
		//Ticket 20200220000645 - Incluir andre.bugatti@steck.com.br
		_cmail:= 'Tiago.Brandao@steck.com.br;tamires.eufrazio@steck.com.br;sadoque.manoel@steck.com.br;andre.bugatti@steck.com.br;Jander.brito@steck.com.br;valdeniza.nascimento@steck.com.br;marcella.martins@steck.com.br'

		STWFR5(_aMsgAM,_cmail,_cCop,.T.)
		_aMsgAM:={}
	EndIf

	If Len(_aMsgI) > 1
		_cmail:= 'richely.lima@steck.com.br;paulo.filho@steck.com.br'

		STWFR5(_aMsgI,_cmail,_cCop)
		_aMsgI:={}
	EndIf

	Reset Environment
Return()


*------------------------------------------------------------------*
Static Function STWFR5(_aMsg,_cEmail,_cCopia,_Sp)
*------------------------------------------------------------------*
	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'PRODUTOS SEM COMPROMISSO'
	Local cFuncSent		:= "STWFR5"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:=''
	default _Sp			:= .F.

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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'

				If _Sp
					cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
					cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'

				EndIf
			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + PADL(CVALTOCHAR(_nLin-1),3,'0') + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'

				If _Sp
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				EndIf
			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,,," ")
		EndIf

	EndIf
	RestArea(aArea)
Return()









User Function STWF06( )


	Local cAliasSuper:= 'STWF06'
	Local cQuery     := ' '
	Local _aMsg 	 := {}
	Local _cDat      := ' '
	Local _cEmail    := ' '

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")      // Valdemir Rabelo 28/01/2022 '01' - '02'  Chamado: 20220124001840

	cQuery := " SELECT A1_COD,A1_LOJA, A1_NOME, NVL(A1_EMAIL,' ') AS A1_EMAIL, NVL(U5_CONTAT,' ') AS U5_CONTAT,NVL(U5_EMAIL,' ') AS U5_EMAIL , NVL(A3_EMAIL,'carla.lodetti@STECK.COM.BR') AS A3_EMAIL
	cQuery += " FROM " + getAliasBD('SA1')[1] +" SA1 LEFT JOIN(SELECT * FROM " + getAliasBD('SA3')[1] +")SA3 ON SA3.D_E_L_E_T_ = ' ' AND SA3.A3_COD = A1_VEND LEFT JOIN(SELECT * FROM " + getAliasBD('AC8')[1] +")AC8 ON AC8.D_E_L_E_T_ = ' ' AND AC8_CODENT = A1_COD||A1_LOJA AND AC8_ENTIDA = 'SA1' LEFT JOIN(SELECT * FROM " + getAliasBD('SU5')[1] +")SU5 ON SU5.D_E_L_E_T_ = ' ' AND  U5_CODCONT = AC8_CODCON WHERE SA1.D_E_L_E_T_ = ' ' AND  (A1_EMAIL<> ' ' OR U5_EMAIL<> ' ') AND ( A1_EMAIL LIKE '%@%'  OR     U5_EMAIL LIKE '%@%' ) ORDER BY SA1.R_E_C_N_O_


	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0

		_cEmail:= ' '
		While 	(cAliasSuper)->(!Eof())

			STWFR6(_cEmail,Alltrim((cAliasSuper)->A1_NOME))

			(cAliasSuper)->(dbskip())

		End
	EndIf

	Reset Environment
Return()


	*------------------------------------------------------------------*
Static Function STWFR6(_cEmail,cNome)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "steck.informa@steck.com.br"
	Local _cAssunto:= Alltrim(cNome)+ ' Sentimos sua falta.'
	Local cFuncSent:= "STWFR6"
	//Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := "steck.informa@steck.com.br"
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
	default _cEmail  :=  "   "

	If Type("l410Auto") == "U" .OR. !l410Auto


		//cMsg := " "

		//cMsg := ' <html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns:m="http://schemas.microsoft.com/office/2004/12/omml" xmlns="http://www.w3.org/TR/REC-html40"><head><meta http-equiv=Content-Type content="text/html; charset=iso-8859-1"><meta name=Generator content="Microsoft Word 15 (filtered medium)"><!--[if !mso]><style>v\:* {behavior:url(#default#VML);}
		//cMsg += ' o\:* {behavior:url(#default#VML);}w\:* {behavior:url(#default#VML);}.shape {behavior:url(#default#VML);}</style><![endif]--><style><!--/* Font Definitions */@font-face	{font-family:"Cambria Math";	panose-1:2 4 5 3 5 4 6 3 2 4;}@font-face	{font-family:Calibri;	panose-1:2 15 5 2 2 2 4 3 2 4;}@font-face	{font-family:"Bookman Old Style";	panose-1:2 5 6 4 5 5 5 2 2 4;}/* Style Definitions */p.MsoNormal, li.MsoNormal, div.MsoNormal	{margin:0cm;	margin-bottom:.0001pt;	font-size:11.0pt;	font-family:"Calibri",sans-serif;	mso-fareast-language:EN-US;}a:link, span.MsoHyperlink
		//cMsg += ' {mso-style-priority:99;	color:#0563C1;	text-decoration:underline;}a:visited, span.MsoHyperlinkFollowed	{mso-style-priority:99;	color:#954F72;	text-decoration:underline;}span.EstiloDeEmail17	{mso-style-type:personal;	font-family:"Calibri",sans-serif;	color:windowtext;}span.EstiloDeEmail18	{mso-style-type:personal;	font-family:"Calibri",sans-serif;	color:black;}
		//cMsg += ' span.EstiloDeEmail19	{mso-style-type:personal-compose;	font-family:"Calibri",sans-serif;	color:windowtext;}.MsoChpDefault	{mso-style-type:export-only;	font-size:10.0pt;}@page WordSection1	{size:612.0pt 792.0pt;	margin:70.85pt 3.0cm 70.85pt 3.0cm;}div.WordSection1	{page:WordSection1;}--></style><!--[if gte mso 9]><xml><o:shapedefaults v:ext="edit" spidmax="1026" /></xml><![endif]--><!--[if gte mso 9]><xml>
		//cMsg += ' <o:shapelayout v:ext="edit"><o:idmap v:ext="edit" data="1" /></o:shapelayout></xml><![endif]--></head><body lang=PT-BR link="#0563C1" vlink="#954F72"><div class=WordSection1><p class=MsoNormal align=center style=
		cMsg += "'text-align:center'><b><span style='font-size:20.0pt;font-family:
		cMsg += ' "Bookman Old Style",serif
		cMsg += " '>Caro parceiro</span></b><span style='
		cMsg += ' font-size:20.0pt;font-family:"Bookman Old Style",serif
		cMsg += " '><o:p></o:p></span></p><p class=MsoNormal align=center style='text-align:center'><span style='font-size:16.0pt;font-family:
		cMsg += ' "Bookman Old Style",serif
		cMsg += " '><o:p>&nbsp;</o:p></span></p><p class=MsoNormal align=center style='text-align:center'><span style='font-size:16.0pt;font-family:
		cMsg += ' "Bookman Old Style",serif
		cMsg += " '>Notamos a sua ausЙncia hА algum tempo. Talvez vocЙ nЦo saiba todas as novidades que a Steck tЙm para lhe oferecer.<o:p></o:p></span></p><p class=MsoNormal align=center style='text-align:center'><span style='font-size:16.0pt;font-family:
		cMsg += ' "Bookman Old Style",serif
		cMsg += " '><o:p>&nbsp;</o:p></span></p><p class=MsoNormal align=center style='text-align:center'><span style='font-size:16.0pt;font-family:
		cMsg += ' "Bookman Old Style",serif;background:yellow;mso-highlight:yellow
		cMsg += "'>Confira abaixo:</span><span style='font-size:16.0pt;font-family:
		cMsg += ' "Bookman Old Style",serif
		cMsg += " '><o:p></o:p></span></p><p class=MsoNormal><o:p>&nbsp;</o:p></p><p class=MsoNormal align=center style='text-align:center'><span style='mso-fareast-language:PT-BR'
		cMsg += ' ><a href="http://www.steck.com.br/"><span style=
		cMsg += " 'color:windowtext;text-decoration:none'
		cMsg += ' ><img border=0 width=1130 height=1624 id="_x0000_i1033" src="http://steck.hospedagemdesites.ws/img_001.jpg"></span></a></span><o:p></o:p></p></div></body></html>

		_cEmail:= ''
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)


	EndIf

	RestArea(aArea)
Return()











User Function STWF07(_CodCli,_CodLj,_CodNF,_CodSer)
	//	u_STWF07('006596','24','000266914','001')


	Local _aSTWF07	 := {}
	Local i

	//RpcSetType( 3 )
	//RpcSetEnv(cEmpAnt,cFilAnt,,,"FAT")

	dbSelectArea("Z1V")
	Z1V->(dbgotop())
	Z1V->(dbsetorder(1))
	While 	Z1V->(!Eof())
		If _CodCli = Z1V->Z1V_COD .And. _CodLj = Z1V->Z1V_LOJA
			Aadd(_aSTWF07,{Z1V->Z1V_COD,"('"+Z1V->Z1V_LOJA+"')"	, Alltrim(Z1V->Z1V_EMAIL1)	,Alltrim(Z1V->Z1V_EMAIL2) 	})
		EndIF

		Z1V->(dbskip())

	End

	For i:= 1 To Len(_aSTWF07)
		//StartJob("U_ASTWF07",GetEnvServer(), .F.,_aSTWF07[i],SM0->M0_CODFIL)
		U_ASTWF07( _aSTWF07[i],_CodCli,_CodLj,_CodNF,_CodSer)

	Next i


Return()

User Function ASTWF07( _aSTWF07,_CodCli,_CodLj,_CodNF,_CodSer)


	Local cAliasSuper	:= 'STWF07'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:= _aSTWF07[3]
	Local _cCop			:= _aSTWF07[4]

	//RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")



	cQuery := " SELECT
	cQuery += " D2_PEDIDO AS PEDIDO_STECK, D2_ITEM,
	cQuery += " D2_EMISSAO AS EMISSAO,
	cQuery += " D2_COD AS PRODUTO_STECK,
	cQuery += " C6_XORDEM AS  REF_CLIENTE,
	cQuery += " D2_QUANT AS FATURADO,
	cQuery += " C6_QTDVEN-C6_QTDENT AS 	QTD_PENDENTE,
	cQuery += " C6_NUMPCOM AS NUMPC,
	cQuery += " C6_ITEMPC AS ITEMPC
	cQuery += " FROM " + getAliasBD('SD2')[1] +" SD2  "    // Valdemir Rabelo 28/01/2022 - Chamado: 20220124001840
	cQuery += " INNER JOIN (SELECT * FROM " + getAliasBD('SC6')[1] +")SC6
	cQuery += " ON SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_FILIAL = D2_FILIAL
	cQuery += " AND C6_NUM = D2_PEDIDO
	cQuery += " AND C6_ITEM = D2_ITEMPV
	cQuery += " AND C6_PRODUTO = D2_COD
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
	cQuery += " AND D2_DOC = '"+_CodNF+"'
	cQuery += " AND D2_SERIE = '"+_CodSer+"'
	cQuery += " AND D2_CLIENTE = '"+_CodCli+"'
	cQuery += " AND D2_FILIAL = '"+getAliasBD('SD2')[1]+"'
	cQuery += " ORDER BY D2_PEDIDO,D2_ITEM


	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"PEDIDO-STECK","EMISSAO","PRODUTO-STECK","REF.CLIENTE","QTD.FATURADA" ,	"QTD.PENDENTE","NUMPC" ,"ITEMPC" })


		While 	(cAliasSuper)->(!Eof())

			aadd(_aMsg,{(cAliasSuper)->PEDIDO_STECK,;
				dtoc( stod((cAliasSuper)->EMISSAO)),;
				(cAliasSuper)->PRODUTO_STECK,;
				(cAliasSuper)->REF_CLIENTE,;
				Transform((cAliasSuper)->FATURADO,"@E 999,999,999"),;
				Transform((cAliasSuper)->QTD_PENDENTE,"@E 999,999,999"),;
				(cAliasSuper)->NUMPC,;
				(cAliasSuper)->ITEMPC }  )


			(cAliasSuper)->(dbskip())

		End
	EndIf
	If Len(_aMsg) > 1


		STWFR7(_aMsg,_cmail,_cCop,_CodNF)

		_aMsg:={}

	EndIf
	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


	*------------------------------------------------------------------*
Static Function STWFR7(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'Faturamento STECK, Nf: '+_CodNF
	Local cFuncSent		:= "STWFR7"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:=''

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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></B></TD>'

			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></TD>'
			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,,,'  ')
		EndIf

	EndIf
	RestArea(aArea)
Return()

//Adicionado meta de apoio aos externos conforme Ticket 20190412000073 - 310519
User Function STWF08( )

	Local cAliasSuper	:= 'STWF08'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''
	Local _dRef			:= date()
	Local _aRet			:= {}

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	cQuery := " SELECT
	cQuery += " SA3.A3_COD, SA3.A3_NOME  , SA3.A3_EMAIL AS VEND,TA3.A3_EMAIL AS SUP,
	cQuery += " COALESCE((SELECT SUM(ZZD.ZZD_VALOR) FROM ZZD010 ZZD WHERE  ZZD.D_E_L_E_T_ = ' ' AND ZZD.ZZD_MES = '"+substr(dtos(_dRef),5,2)+"' AND ZZD.ZZD_ANO = '"+substr(dtos(_dRef),1,4)+"' AND ZZD.ZZD_FILIAL = '  '   AND ZZD.ZZD_VEND = SA3.A3_COD ),0) AS OBJETIVO,
	cQuery += " ROUND( COALESCE((SELECT SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END) AS VALOR FROM SC6010 SC6 INNER JOIN (SELECT * FROM SB1010 ) SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.B1_FILIAL = '  ' INNER JOIN (SELECT *  FROM  SC5010 )SC5 ON SC5.D_E_L_E_T_ = ' ' AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_FILIAL = SC6.C6_FILIAL AND SUBSTR(SC5.C5_EMISSAO , 1 , 6) ='"+substr(dtos(_dRef),1,6)+"' INNER JOIN(SELECT * FROM SA1010 ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.A1_FILIAL = '  '  LEFT JOIN (SELECT *  FROM  PC1010 )PC1 ON C6_NUM = PC1.PC1_PEDREP AND PC1.D_E_L_E_T_ = ' '  INNER JOIN (SELECT * FROM SF4010 ) SF4 ON SC6.C6_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' WHERE  SC6.D_E_L_E_T_ = ' ' AND SC6.C6_FILIAL = '02' AND SC5.C5_TIPO = 'N' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_EST <> 'EX'  AND PC1.PC1_PEDREP IS NULL   AND SC5.C5_VEND1 = SA3.A3_COD ),0),2) AS CAPTACAO,
	cQuery += " COALESCE((SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM) AS TOTAL  FROM  SF2010 SF2 INNER JOIN(SELECT * FROM SD2010 ) SD2 ON SD2.D_E_L_E_T_ = ' ' AND SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')   WHERE  SUBSTR(F2_EMISSAO,1,6) = '"+substr(dtos(_dRef),1,6)+"' AND SF2.D_E_L_E_T_ = ' ' AND SF2.F2_VEND1 = SA3.A3_COD   AND EXISTS(SELECT * FROM SC6010 SC6 WHERE  SC6.C6_NUM = SD2.D2_PEDIDO AND SC6.C6_FILIAL = SD2.D2_FILIAL AND SC6.D_E_L_E_T_ = ' ' )  ),0) AS FATURAMENTO,
	cQuery += " COALESCE((SELECT  COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0) AS TOTAL  FROM  SD1010 SD1 INNER JOIN(SELECT * FROM SA1010 ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SD1.D1_TIPO = 'D' AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA AND SA1.A1_FILIAL = '  ' INNER JOIN (SELECT *  FROM  SB1010 )SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SD1.D1_COD AND SB1.B1_FILIAL = '  ' INNER JOIN(SELECT * FROM SF2010 ) SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL  WHERE  SD1.D_E_L_E_T_ = ' ' AND SF2.F2_VEND1 = SA3.A3_COD   AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') AND SUBSTR(SD1.D1_EMISSAO,1,6) ='"+substr(dtos(_dRef),1,6)+"' ),0) AS QTD_TOTAL
	cQuery += " FROM SA3010 SA3
	cQuery += " INNER JOIN(SELECT * FROM SA3010)TA3
	cQuery += " ON TA3.D_E_L_E_T_ = ' '
	cQuery += " AND TA3.A3_COD = SA3.A3_SUPER
	cQuery += " WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += " AND SUBSTR(SA3.A3_COD,1,1) <> 'R'
	cQuery += " AND EXISTS (SELECT * FROM ZZD010 ZZD WHERE ZZD.D_E_L_E_T_ = ' ' AND ZZD_MES = '"+substr(dtos(_dRef),5,2)+"' AND ZZD_ANO = '"+substr(dtos(_dRef),1,4)+"' AND ZZD_VEND = SA3.A3_COD)

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"CODIGO","NOME","OBJETIVO","CAPTAгцO","%CAP." ,	"FATURAMENTO","%FAT." })

		While 	(cAliasSuper)->(!Eof())

			aadd(_aMsg,{(cAliasSuper)->A3_COD,;
				(cAliasSuper)->A3_NOME,;
				'R$ '+Transform((cAliasSuper)->OBJETIVO,"@E 999,999,999.99"),;
				'R$ '+Transform((cAliasSuper)->CAPTACAO,"@E 999,999,999.99"),;
				Transform((cAliasSuper)->CAPTACAO/(cAliasSuper)->OBJETIVO*100,"@E 999.99")+'%',;
				'R$ '+Transform((cAliasSuper)->FATURAMENTO-(cAliasSuper)->QTD_TOTAL,"@E 999,999,999.99"),;
				Transform(((cAliasSuper)->FATURAMENTO-(cAliasSuper)->QTD_TOTAL)/(cAliasSuper)->OBJETIVO*100,"@E 999.99")+'%' }  )

			If SubStr((cAliasSuper)->A3_COD,1,1) $ "I"

				_aRet := U_STWFR8A((cAliasSuper)->A3_COD)

				If !Empty(_aRet[02])

					aadd(_aMsg,{_aRet[02],;
						(cAliasSuper)->A3_NOME,;
						'R$ '+Transform(_aRet[09],"@E 999,999,999.99"),;
						'R$ '+Transform(_aRet[14],"@E 999,999,999.99"),;
						Transform(_aRet[14]/_aRet[09]*100,"@E 999.99")+'%',;
						'R$ '+Transform(_aRet[10],"@E 999,999,999.99"),;
						Transform(_aRet[10]/_aRet[09]*100,"@E 999.99")+'%' }  )

				EndIf

			EndIf

			STWFR8(_aMsg,(cAliasSuper)->VEND,(cAliasSuper)->SUP,(cAliasSuper)->A3_NOME)

			_aMsg:={}
			aadd(_aMsg,{"CODIGO","NOME","OBJETIVO","CAPTAгцO","%CAP." ,	"FATURAMENTO","%FAT."})
			(cAliasSuper)->(dbskip())

		End
	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR8(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'Meta Mensal :'+_CodNF
	Local cFuncSent		:= "STWFR8"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0

	default _cEmail  	:= "   "
	default _cCopia  	:=''

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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado

			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,' ')

		EndIf

	EndIf
	RestArea(aArea)

Return()

User Function STWF09( )


	Local cAliasSuper	:= 'STWF09'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")




	cQuery := " SELECT C5_NUM,C6_PRODUTO,C6_DESCRI,C5_XNOME, SUBSTR(C5_EMISSAO,7,2)||'/'||SUBSTR(C5_EMISSAO,5,2)||'/'||SUBSTR(C5_EMISSAO,1,4) as C5_EMISSAO,

	cQuery += " SA3.A3_NOME
	cQuery += ' "VENDN1",SA3.A3_EMAIL
	cQuery += ' "VEND1" ,WA3.A3_NOME,WA3.A3_COD
	cQuery += ' "COORDENADOR",
	cQuery += "  WA3.A3_EMAIL
	cQuery += ' "MCOORDENADOR", VA3.A3_NOME
	cQuery += ' "VENDN2",VA3.A3_EMAIL
	cQuery += ' "VEND2"
	cQuery += " FROM SC6010 SC6

	cQuery += " INNER JOIN(SELECT * FROM SB1010)SB1
	cQuery += " ON SB1.D_E_L_E_T_ = ' '
	cQuery += " AND B1_COD = C6_PRODUTO
	cQuery += " AND B1_GRUPO = '999'

	cQuery += " INNER JOIN(SELECT * FROM SC5010)SC5
	cQuery += " ON SC5.D_E_L_E_T_ = ' '
	cQuery += " AND C5_NUM = C6_NUM
	cQuery += " AND C5_FILIAL = C6_FILIAL
	cQuery += " AND C5_EMISSAO < '"+ DTOS(DATE()-5)+"'

	cQuery += " INNER JOIN(SELECT * FROM SA3010)SA3
	cQuery += " ON SA3.D_E_L_E_T_ = ' '
	cQuery += " AND SA3.A3_COD = C5_VEND1

	cQuery += "  INNER JOIN(SELECT * FROM SA3010)WA3
	cQuery += " ON WA3.D_E_L_E_T_ = ' '
	cQuery += " AND WA3.A3_COD = SA3.A3_SUPER

	cQuery += " LEFT JOIN(SELECT * FROM SA3010)VA3
	cQuery += " ON VA3.D_E_L_E_T_ = ' '
	cQuery += " AND VA3.A3_COD = C5_VEND2

	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_QTDVEN>C6_QTDENT
	cQuery += " AND C6_FILIAL = '02'
	cQuery += " AND C6_BLQ<> 'R'

	cQuery += " ORDER BY C5_VEND1,C5_VEND2




	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"PEDIDO","PRODUTO","DESCRIгцO","CLIENTE","EMISSAO","VEND1","VEND2"})

		_cVen:= ' '
		While 	(cAliasSuper)->(!Eof())

			If _cVen <>	(cAliasSuper)->VENDN1+(cAliasSuper)->VENDN2
				_cVen:=	(cAliasSuper)->VENDN1+(cAliasSuper)->VENDN2
				If Len(_aMsg) > 1
					STWFR9(_aMsg,_cn01+';'+_cn02+';'+_cn03,'filipe.nascimento@steck.com.br;bruno.galvao@steck.com.br'  ,_cn01)

					_aMsg:={}
					aadd(_aMsg,{"PEDIDO","PRODUTO","DESCRIгцO","CLIENTE","EMISSAO","VEND1","VEND2"})
				EndIf
			EndIf
			aadd(_aMsg,{(cAliasSuper)->C5_NUM,;
				(cAliasSuper)->C6_PRODUTO,;
				(cAliasSuper)->C6_DESCRI,;
				(cAliasSuper)->C5_XNOME,;
				(cAliasSuper)->C5_EMISSAO,;
				(cAliasSuper)->VENDN1,;
				(cAliasSuper)->VENDN2,;
				}  )
			_cn01:= (cAliasSuper)->VEND1
			_cn02:= (cAliasSuper)->VEND2
			_cn03:= (cAliasSuper)->MCOORDENADOR
			(cAliasSuper)->(dbskip())

		End
		If Len(_aMsg) > 1
			STWFR9(_aMsg,_cn01+';'+_cn02+';'+_cn03,'filipe.nascimento@steck.com.br;bruno.galvao@steck.com.br'  ,_cn01)

			_aMsg:={}
			aadd(_aMsg,{"PEDIDO","PRODUTO","DESCRIгцO","CLIENTE","EMISSAO","VEND1","VEND2"})
		EndIf
	EndIf





	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


	*------------------------------------------------------------------*
Static Function STWFR9(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'POSICIONAMENTO DE UNICOM :'+_CodNF
	Local cFuncSent		:= "STWFR9"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:=''


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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado

			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')// Ticket 20201030009733 - 30.10.2020

		EndIf

	EndIf
	RestArea(aArea)
Return()

User Function STM10()
	Local aParam:= {}
	Local aConfig:= {}

	aAdd(aParam,{3,"MЙs:"	,1,{"01-Janeiro"	,"02-Fevereiro",;
		"03-MarГo"		,"04-Abril",;
		"05-Maio"		,"06-Junho",;
		"07-Julho"		,"08-Agosto",;
		"09-Setembro"	,"10-Outubro",;
		"11-Novembro"	,"12-Dezembro";
		},50,.T.,.T.})

	If !ParamBox(aParam,"Meta Mensal",aConfig,,,.F.,90,15)
		Return()
	EndIf
	//U_STWF10(Stod(SubStr(dtos(date()),1,4)+ Padl(cValToChar(aConfig[1]),2,'0')+'01'))
	StartJob("U_STWF10",GetEnvServer(), .F.,Stod(SubStr(dtos(date()),1,4)+ Padl(cValToChar(aConfig[1]),2,'0')+'01'))

Return()

User Function STWF10(_dRef )


	Local cAliasSuper	:= 'STWF10'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''
	Local _dDref		:= date()
	Private _Am01		:= 0
	Private _Am02		:= 0
	Private _Am03		:= 0
	Default _dRef		:= date()

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")


	If ValType(_dRef) <> 'D'
		_dRef:= date()
	EndIf
	_dDref		:= _dRef


	cQuery := " SELECT
	cQuery += " SA3.A3_COD, SA3.A3_NOME ,TA3.A3_NOME AS NSUP , SA3.A3_SUPER AS CSUP, SA3.A3_EMAIL AS VEND,TA3.A3_EMAIL AS SUP,
	cQuery += " COALESCE((SELECT SUM(ZZD.ZZD_VALOR) FROM ZZD010 ZZD WHERE  ZZD.D_E_L_E_T_ = ' ' AND ZZD.ZZD_MES = '"+substr(dtos(_dDref),5,2)+"' AND ZZD.ZZD_ANO = '"+substr(dtos(_dDref),1,4)+"' AND ZZD.ZZD_FILIAL = '  '   AND ZZD.ZZD_VEND = SA3.A3_COD ),0) AS OBJETIVO,
	cQuery += " ROUND( COALESCE((SELECT SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END) AS VALOR FROM SC6010 SC6 INNER JOIN (SELECT * FROM SB1010 ) SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.B1_FILIAL = '  ' INNER JOIN (SELECT *  FROM  SC5010 )SC5 ON SC5.D_E_L_E_T_ = ' ' AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_FILIAL = SC6.C6_FILIAL AND SUBSTR(SC5.C5_EMISSAO , 1 , 6) ='"+substr(dtos(_dDref),1,6)+"' INNER JOIN(SELECT * FROM SA1010 ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.A1_FILIAL = '  '  LEFT JOIN (SELECT *  FROM  PC1010 )PC1 ON C6_NUM = PC1.PC1_PEDREP AND PC1.D_E_L_E_T_ = ' '  INNER JOIN (SELECT * FROM SF4010 ) SF4 ON SC6.C6_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' WHERE  SC6.D_E_L_E_T_ = ' ' AND SC6.C6_FILIAL = '02' AND SC5.C5_TIPO = 'N' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_EST <> 'EX'  AND PC1.PC1_PEDREP IS NULL   AND SC5.C5_VEND1 = SA3.A3_COD ),0),2) AS CAPTACAO,
	cQuery += " COALESCE((SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM) AS TOTAL  FROM  SF2010 SF2 INNER JOIN(SELECT * FROM SD2010 ) SD2 ON SD2.D_E_L_E_T_ = ' ' AND SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')   WHERE  SUBSTR(F2_EMISSAO,1,6) = '"+substr(dtos(_dDref),1,6)+"' AND SF2.D_E_L_E_T_ = ' ' AND SF2.F2_VEND1 = SA3.A3_COD   AND EXISTS(SELECT * FROM SC6010 SC6 WHERE  SC6.C6_NUM = SD2.D2_PEDIDO AND SC6.C6_FILIAL = SD2.D2_FILIAL AND SC6.D_E_L_E_T_ = ' ' )  ),0) AS FATURAMENTO,
	cQuery += " COALESCE((SELECT  COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0) AS TOTAL  FROM  SD1010 SD1 INNER JOIN(SELECT * FROM SA1010 ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SD1.D1_TIPO = 'D' AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA AND SA1.A1_FILIAL = '  ' INNER JOIN (SELECT *  FROM  SB1010 )SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SD1.D1_COD AND SB1.B1_FILIAL = '  ' INNER JOIN(SELECT * FROM SF2010 ) SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL  WHERE  SD1.D_E_L_E_T_ = ' ' AND SF2.F2_VEND1 = SA3.A3_COD   AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01') AND SUBSTR(SD1.D1_EMISSAO,1,6) ='"+substr(dtos(_dDref),1,6)+"' ),0) AS QTD_TOTAL
	cQuery += " FROM SA3010 SA3
	cQuery += " INNER JOIN(SELECT * FROM SA3010)TA3
	cQuery += " ON TA3.D_E_L_E_T_ = ' '
	cQuery += " AND TA3.A3_COD = SA3.A3_SUPER
	cQuery += " WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += " AND EXISTS (SELECT * FROM ZZD010 ZZD WHERE ZZD.D_E_L_E_T_ = ' ' AND ZZD_MES = '"+substr(dtos(_dDref),5,2)+"' AND ZZD_ANO = '"+substr(dtos(_dDref),1,4)+"' AND ZZD_VEND = SA3.A3_COD)
	cQuery += " ORDER BY SA3.A3_SUPER





	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"CODIGO","NOME","OBJETIVO","CAPTAгцO","%CAP." ,	"FATURAMENTO","%FAT." })
		_nObj:=0
		_nCap:=0
		_nFat:=0
		_cSuper:= ' '
		_cEmSP:= ' '
		_cnCo:= ' '
		While 	(cAliasSuper)->(!Eof())

			If _cSuper <> (cAliasSuper)->CSUP
				_cSuper:= 	(cAliasSuper)->CSUP
				If Len(_aMsg) > 1

					aadd(_aMsg,{"TOTAL:",;
						_cnCo,;
						'R$ '+Transform(_nObj,"@E 999,999,999.99"),;
						'R$ '+Transform(_nCap,"@E 999,999,999.99"),;
						Transform(_nCap/_nObj*100,"@E 999.99")+'%',;
						'R$ '+Transform(_nFat,"@E 999,999,999.99"),;
						Transform((_nFat)/_nObj*100,"@E 999.99")+'%',;
						}  )
					_nObj:=0
					_nCap:=0
					_nFat:=0

					STWFR10(_aMsg,_cEmSP,   " ",_cnCo+' - '+_cnsUP,substr(dtos(_dDref),5,2)+'/'+substr(dtos(_dDref),1,4))
					_cEmSP:= ' '
					_cnCo:= ' '
					_cnsUP:= ' '
					_aMsg:={}
					aadd(_aMsg,{"CODIGO","NOME","OBJETIVO","CAPTAгцO","%CAP." ,	"FATURAMENTO","%FAT." })

				EndIf
			EndIf
			If (cAliasSuper)->A3_COD = 'R00492'
				STAM10()
			Else
				_Am01		:= 0
				_Am02		:= 0
				_Am03		:= 0
			EndIf

			aadd(_aMsg,{(cAliasSuper)->A3_COD,;
				(cAliasSuper)->A3_NOME,;
				'R$ '+Transform((cAliasSuper)->OBJETIVO,"@E 999,999,999.99"),;
				'R$ '+Transform((cAliasSuper)->CAPTACAO+_Am01,"@E 999,999,999.99"),;
				Transform(((cAliasSuper)->CAPTACAO+_Am01)/(cAliasSuper)->OBJETIVO*100,"@E 999.99")+'%',;
				'R$ '+Transform((cAliasSuper)->FATURAMENTO+_Am02-(cAliasSuper)->QTD_TOTAL-_Am03,"@E 999,999,999.99"),;
				Transform(((cAliasSuper)->FATURAMENTO+_Am02-(cAliasSuper)->QTD_TOTAL-_Am03)/(cAliasSuper)->OBJETIVO*100,"@E 999.99")+'%',;
				}  )
			_nObj+=(cAliasSuper)->OBJETIVO
			_nCap+=(cAliasSuper)->CAPTACAO+_Am01
			_nFat+=(cAliasSuper)->FATURAMENTO-(cAliasSuper)->QTD_TOTAL+_Am02-_Am03
			_cnsUP:= aLLTRIM((cAliasSuper)->NSUP)
			_cnCo:= _cSuper
			_cEmSP:=  (cAliasSuper)->SUP
			(cAliasSuper)->(dbskip())

		End


		If Len(_aMsg) > 1

			aadd(_aMsg,{"TOTAL:",;
				_cnCo,;
				'R$ '+Transform(_nObj,"@E 999,999,999.99"),;
				'R$ '+Transform(_nCap,"@E 999,999,999.99"),;
				Transform(_nCap/_nObj*100,"@E 999.99")+'%',;
				'R$ '+Transform(_nFat,"@E 999,999,999.99"),;
				Transform((_nFat)/_nObj*100,"@E 999.99")+'%',;
				}  )
			_nObj:=0
			_nCap:=0
			_nFat:=0

			STWFR10(_aMsg,_cEmSP,   "", _cnCo+' - '+_cnsUP,substr(dtos(_dDref),5,2)+'/'+substr(dtos(_dDref),1,4))

			_aMsg:={}
			aadd(_aMsg,{"CODIGO","NOME","OBJETIVO","CAPTAгцO","%CAP." ,	"FATURAMENTO","%FAT." })

		EndIf


	EndIf





	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

Static Function STAM10()

	Local cAliasAm	:= 'STAM10'
	Local cQuery     	:= ' '
	Local _dDref		:= date()
	cQuery := " SELECT
	cQuery += " ROUND( COALESCE((SELECT SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END) AS VALOR FROM SC6030 SC6 INNER JOIN (SELECT * FROM SB1030 ) SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.B1_FILIAL = '  ' INNER JOIN (SELECT *  FROM  SC5030 )SC5 ON SC5.D_E_L_E_T_ = ' ' AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_FILIAL = SC6.C6_FILIAL AND SUBSTR(SC5.C5_EMISSAO , 1 , 6) ='"+substr(dtos(_dDref),1,6)+"' INNER JOIN(SELECT * FROM SA1030 ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.A1_FILIAL = '  '  LEFT JOIN (SELECT *  FROM  PC1030 )PC1 ON C6_NUM = PC1.PC1_PEDREP AND PC1.D_E_L_E_T_ = ' '  INNER JOIN (SELECT * FROM SF4030 ) SF4 ON SC6.C6_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' WHERE  SC6.D_E_L_E_T_ = ' ' AND SC6.C6_FILIAL = '01' AND SC5.C5_TIPO = 'N' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_EST <> 'EX'  AND PC1.PC1_PEDREP IS NULL   AND SC5.C5_VEND1 = SA3.A3_COD ),0),2) AS CAPTACAO,
	cQuery += " COALESCE((SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM) AS TOTAL  FROM  SF2030 SF2 INNER JOIN(SELECT * FROM SD2030 ) SD2 ON SD2.D_E_L_E_T_ = ' ' AND SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')   WHERE  SUBSTR(F2_EMISSAO,1,6) = '"+substr(dtos(_dDref),1,6)+"' AND SF2.D_E_L_E_T_ = ' ' AND SF2.F2_VEND1 = SA3.A3_COD   AND EXISTS(SELECT * FROM SC6030 SC6 WHERE  SC6.C6_NUM = SD2.D2_PEDIDO AND SC6.C6_FILIAL = SD2.D2_FILIAL AND SC6.D_E_L_E_T_ = ' ' )  ),0) AS FATURAMENTO,
	cQuery += " COALESCE((SELECT  COALESCE(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0) AS TOTAL  FROM  SD1030 SD1 INNER JOIN(SELECT * FROM SA1030 ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SD1.D1_TIPO = 'D' AND SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA AND SA1.A1_FILIAL = '  ' INNER JOIN (SELECT *  FROM  SB1030 )SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SD1.D1_COD AND SB1.B1_FILIAL = '  ' INNER JOIN(SELECT * FROM SF2030 ) SF2 ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL  WHERE  SD1.D_E_L_E_T_ = ' ' AND SF2.F2_VEND1 = SA3.A3_COD   AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') AND (SD1.D1_FILIAL = '01' OR SD1.D1_FILIAL = '01') AND SUBSTR(SD1.D1_EMISSAO,1,6) ='"+substr(dtos(_dDref),1,6)+"' ),0) AS QTD_TOTAL
	cQuery += " FROM SA3030 SA3
	cQuery += " INNER JOIN(SELECT * FROM SA3030)TA3
	cQuery += " ON TA3.D_E_L_E_T_ = ' '
	cQuery += " AND TA3.A3_COD = SA3.A3_SUPER
	cQuery += " WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += " AND SA3.A3_COD = 'R00492'
	cQuery += " AND EXISTS (SELECT * FROM ZZD010 ZZD WHERE ZZD.D_E_L_E_T_ = ' ' AND ZZD_MES = '"+substr(dtos(_dDref),5,2)+"' AND ZZD_ANO = '"+substr(dtos(_dDref),1,4)+"' AND ZZD_VEND = SA3.A3_COD)



	If Select(cAliasAm) > 0
		(cAliasAm)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasAm)



	dbSelectArea(cAliasAm)
	(cAliasAm)->(dbgotop())
	If  Select(cAliasAm) > 0
		_Am01		:= (cAliasAm)->CAPTACAO
		_Am02		:= (cAliasAm)->FATURAMENTO
		_Am03		:= (cAliasAm)->QTD_TOTAL

	EndIf
	If Select(cAliasAm) > 0
		(cAliasAm)->(dbCloseArea())
	EndIf
Return()

	*------------------------------------------------------------------*
Static Function STWFR10(_aMsg,_cEmail,_cCopia,_CodNF,_cRef)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= ' Meta Mensal :'+ Alltrim(_CodNF) +' Ref.: '+_cRef
	Local cFuncSent		:= "STWFR10"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:=''

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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado

			U_STMAILTES(_cEmail , _cCopia , _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)
Return()





User Function STWF11(_cNumPv,_cn02 )


	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''
	Local cPerg 		:= "STWF11"
	Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos    	:= SUBSTR(cTime, 4, 2)
	Local cSegundos   	:= SUBSTR(cTime, 7, 2)
	Local cAliasSuper   := cPerg+cHora+cMinutos+cSegundos
	Local _cn01			:= ' '
	DEFAULT _cNumPv		:= '490680'
	DEFAULT _cn02		:= ' '

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")




	cQuery := " SELECT
	cQuery += " C5_NUM, C5_CLIENTE,C5_LOJACLI,C5_XNOME,C6_PRCVEN,C5_XORDEM,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_ENTRE1,C6_ZENTRE2,C6_XORDEM,C6_NUMPCOM,C6_ITEMPC,ZD_CODCLI
	cQuery += " FROM SC5010 SC5
	cQuery += " INNER JOIN(SELECT * FROM SC6010)SC6
	cQuery += " ON SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_FILIAL = C5_FILIAL
	cQuery += " AND C6_NUM = C5_NUM

	cQuery += " LEFT JOIN(SELECT * FROM SZD010)SZD
	cQuery += " ON SZD.D_E_L_E_T_ =  ' '
	cQuery += " AND ZD_CODSTE = C6_PRODUTO
	cQuery += " AND ZD_CLIENTE = C5_CLIENTE

	cQuery += " WHERE SC5.D_E_L_E_T_ = ' '
	cQuery += " AND C5_NUM = '"+_cNumPv+"'
	cQuery += " AND C5_FILIAL = '02'
	cQuery += " ORDER BY C5_NUM,C6_ITEM


	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"","","Pv-Steck","Cod.Cliente","Lj.Cliente","Nome","Pedido Compra", "",""})
		aadd(_aMsg,{"","",(cAliasSuper)->C5_NUM,(cAliasSuper)->C5_CLIENTE,(cAliasSuper)->C5_LOJACLI,(cAliasSuper)->C5_XNOME,(cAliasSuper)->C5_XORDEM ,"",""})
		aadd(_aMsg,{"Item" ,;
			"Cod.Steck"   ,;
			"DescriГЦo"   ,;
			"Quantidade"  ,;
			"Entrega Prevista",;
			"Valor" ,;
			"Ordem de Compra",;
			"Item Compra",;
			"Cod.Cliente" })


		_cDtEn:= ' '
		_cVen := ' '
		While 	(cAliasSuper)->(!Eof())
			_cDtEn:= Iif(!(Empty(Alltrim((cAliasSuper)->C6_ENTRE1))),(cAliasSuper)->C6_ENTRE1,(cAliasSuper)->C6_ZENTRE2)
			_cDtEn:= Iif( Empty(Alltrim(_cDtEn)),' ',dtoc(DataValida( stod(_cDtEn))+3))

			aadd(_aMsg,{(cAliasSuper)->C6_ITEM     ,;
				(cAliasSuper)->C6_PRODUTO       ,;
				(cAliasSuper)->C6_DESCRI   ,;
				Transform(   (cAliasSuper)->C6_QTDVEN ,"@E 999,999,999") ,;
				_cDtEn    ,;
				"R$ "+ Transform(   (cAliasSuper)->C6_PRCVEN ,"@E 999,999,999.99") ,;
				(cAliasSuper)->C6_XORDEM       ,;
				(cAliasSuper)->C6_ITEMPC     ,;
				(cAliasSuper)->ZD_CODCLI })

			_cn01:= (cAliasSuper)->C5_XORDEM
			(cAliasSuper)->(dbskip())

		End
		If Len(_aMsg) > 3
			STWFR11(_aMsg,_cn02,' '  ,_cn01)
			_aMsg:={}
		EndIf
	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


	*------------------------------------------------------------------*
Static Function STWFR11(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'EDI-STECK-Pedido Recebido n╨: '+_CodNF
	Local cFuncSent		:= "STWFR11"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "    "
	default _cCopia  	:= ' '


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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1 .or. _nLin = 3

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></TD>'
			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado

			U_STMAILTES(_cEmail , _cCopia , _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)
Return()





User Function STWF12(  )

	Local cAliasSuper	:= 'STWF12'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:= 'thiago.ribeiro@steck.com.br;juliana.ferreira@steck.com.br; andre.bugatti@steck.com.br;luciano.fernandes@steck.com.br;	Ulisses.Almeida@steck.com.br;Paulo.Cruz@steck.com.br; Kleber.Braga@steck.com.br; Simone.Mara@steck.com.br;  Priscilla.Silva@steck.com.br'
	Local _cCop			:= 'jander.brito@steck.com.br;tamires.eufrazio@steck.com.br;marcella.martins@steck.com.br' //Ticket 20200730004904

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	cQuery := " SELECT C5_NUM,
	cQuery += " PA1_CODPRO, SUM(PA1_QUANT) AS QUANT
	cQuery += " FROM SC5010 SC5
	cQuery += " INNER JOIN(SELECT * FROM PA1010)PA1
	cQuery += " ON  PA1.D_E_L_E_T_ = ' '
	cQuery += " AND C5_NUM = SUBSTR(PA1_DOC,1,6)
	cQuery += " WHERE SC5.D_E_L_E_T_ = ' '
	cQuery += " AND SC5.C5_FILIAL = PA1_FILIAL
	cQuery += " AND C5_CLIENTE = '038134'
	cQuery += " GROUP BY C5_NUM,PA1_CODPRO
	cQuery += " ORDER BY C5_NUM,PA1_CODPRO

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"PEDIDO","EMISSAO","PRODUTO","FALTAS" })

		While 	(cAliasSuper)->(!Eof())

			aadd(_aMsg,{(cAliasSuper)->C5_NUM,;
				dtoc(Posicione("SC5",1,xFilial("SC5")+(cAliasSuper)->C5_NUM,"C5_EMISSAO")),;
				(cAliasSuper)->PA1_CODPRO,;
				Transform((cAliasSuper)->QUANT,"@E 999,999,999");
				})

			(cAliasSuper)->(dbskip())

		End
	EndIf
	If Len(_aMsg) > 1


		STWFR12(_aMsg,_cmail,_cCop)

		_aMsg:={}

	EndIf
	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


	*------------------------------------------------------------------*
Static Function STWFR12(_aMsg,_cEmail,_cCopia)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'FALTAS LEROY - PRODUTOS'
	Local cFuncSent		:= "STWFR12"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:=' '

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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'

			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,,,'  ')
		EndIf

	EndIf
	RestArea(aArea)
Return()






User Function STWF13( )


	Local cAliasSuper	:= 'STWF13'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:= ' andre.bugatti@steck.com.br ;jander.brito@steck.com.br'
	Local _cCop			:= ' '


	RpcSetType( 3 )
	RpcSetEnv("03","01",,,"FAT")



	cQuery := " SELECT C5_NUM,
	cQuery += " PA1_CODPRO, SUM(PA1_QUANT) AS QUANT
	cQuery += " FROM SC5030 SC5
	cQuery += " INNER JOIN(SELECT * FROM PA1030)PA1
	cQuery += " ON  PA1.D_E_L_E_T_ = ' '
	cQuery += " AND C5_NUM = SUBSTR(PA1_DOC,1,6)
	cQuery += " WHERE SC5.D_E_L_E_T_ = ' '
	cQuery += " AND SC5.C5_FILIAL = PA1_FILIAL
	cQuery += " AND C5_CLIENTE = '019886'
	cQuery += " GROUP BY C5_NUM,PA1_CODPRO
	cQuery += " ORDER BY C5_NUM,PA1_CODPRO


	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"PEDIDO","EMISSAO","PRODUTO","FALTAS" })


		While 	(cAliasSuper)->(!Eof())



			aadd(_aMsg,{(cAliasSuper)->C5_NUM,;
				dtoc(Posicione("SC5",1,xFilial("SC5")+(cAliasSuper)->C5_NUM,"C5_EMISSAO")),;
				(cAliasSuper)->PA1_CODPRO,;
				Transform((cAliasSuper)->QUANT,"@E 999,999,999");
				})


			(cAliasSuper)->(dbskip())

		End
	EndIf
	If Len(_aMsg) > 1


		STWFR13(_aMsg,_cmail,_cCop)

		_aMsg:={}

	EndIf
	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


	*------------------------------------------------------------------*
Static Function STWFR13(_aMsg,_cEmail,_cCopia)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'FALTAS STECK MиXICO - PRODUTOS'
	Local cFuncSent		:= "STWFR13"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:=' '


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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,,,'  ')
		EndIf

	EndIf
	RestArea(aArea)
Return()





User Function xwf14( )


	Local cAliasSuper	:= 'xwf14'
	Local cQuery     	:= ' '


	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"FAT")



	cQuery := " "
	cQuery += " SELECT R_E_C_N_O_ AS  nRec FROM SZ9010 SZ9
	cQuery += " WHERE SZ9.D_E_L_E_T_ = ' '
	cQuery += " AND SUBSTR(SZ9.Z9_CNPJ,1,8) IN( '01438784','01438784','03840986','63004030','10280765','03439316','23476033')
	cQuery += " ORDER BY SUBSTR(SZ9.Z9_CNPJ,1,8), Z9_DTEMIS


	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0

		While 	(cAliasSuper)->(!Eof())


			//U_STWF14(SZ9->(_nRec))
			StartJob("U_STWF14",GetEnvServer(), .F.,(cAliasSuper)->(nRec))

			(cAliasSuper)->(dbskip())

		End
	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


User Function STWF14(_nRec)


	Local cAliasSuper	:= 'STWF14'
	Local cQuery     	:= ""
	Local _aMsg 	 	:= {}
	Local _cmail		:= 'PRISCILLA.SILVA@STECK.COM.BR ;juliana.ferreira@steck.com.br'
	Local _cCop			:= ""
	Local cAviso		:= ""
	Local cErro 		:= ""
	Local _cXml			:= ""
	Local oNfe
	Local nX			:= 0

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	DbSelectArea("SZ9")
	SZ9->(DbGoTo(_nRec ))
	If _nRec   = SZ9->(RECNO())

		cAviso := ""
		cErro  := ""

		_cXml:= Alltrim(SZ9->Z9_XML)
		_cXml:= FwCutOff(_cXml, .t.)
		oNfe := XmlParser(_cXml,"_",@cAviso,@cErro)

		If VALType(oNFe) <> "U"

			If valType(oNFe:_NfeProc) = 'O'
				oNF := oNFe:_NFeProc:_NFe
			Else
				if valType(oNFe:_NFe)= 'O'
					oNF := oNFe:_NFe
				Else

					Return()
				EndIf
			Endif
		Else

			Return()
		EndIf
		oDet       := oNF:_InfNfe:_Det
		oDet := IIf(ValType(oDet)=="O",{oDet},oDet)

		_cCnpj		:= oNF:_InfNfe:_Emit:_Cnpj:Text

		dbselectarea("SA1")
		SA1->(DbOrderNickName("CGCINSCR1"))
		If	SA1->(dbSeek(xFilial("SA1")+_cCnpj))
			aadd(_aMsg,{"Cod.Steck","Cod.Cliente","DescriГЦo","Quantidade","Valor" })
			For nX := 1 To Len(oDet)
				cProduto:= AllTrim(oDet[nX]:_Prod:_cProd:TEXT)
				xProduto:= ' '
				cDesc:= ' '
				DbSelectArea("SZD")
				SZD->(DbSetOrder(1))
				SZD->(DbGoTop())
				If	SZD->(DbSeek(xFilial("SZD")+SA1->A1_COD+cProduto)) .Or. SZD->(DbSeek(xFilial("SZD")+SA1->A1_COD+'0000000000'+cProduto))
					DbSelectArea("SB1")
					SB1->(DbSetOrder(1))
					SB1->(DbGoTop())
					If	SB1->(DbSeek(xFilial("SB1")+SZD->ZD_CODSTE))
						xProduto:= Alltrim(SB1->B1_COD)
						cDesc:= Alltrim(SB1->B1_DESC)
					EndIf
				EndIf
				aadd(_aMsg,{xProduto,;
					cProduto,;
					cDesc,;
					Transform(Val(oDet[nX]:_Prod:_qCom:TEXT),"@E 999,999,999"),;
					'R$ '+ Transform(Val(oDet[nX]:_Prod:_vProd:TEXT),"@E 999,999,999.99")})
			Next nX
		EndIf
	EndIf

	If Len(_aMsg) > 1
		STWFR14(_aMsg,_cmail,_cCop, 'DevoluГЦo '+ Alltrim(SZ9->Z9_NFOR)+ 'Cod:'+SA1->A1_COD+'-'+SA1->A1_LOJA+' Bairro: '+SA1->A1_BAIRROC+' - Valor: R$ '+ Transform(SZ9->Z9_VALORNF,"@E 999,999,999.99")+' - Chave: '+ Alltrim(SZ9->Z9_CHAVE)+' - Emissao: '+ dtoc(SZ9->Z9_DTEMIS))
		_aMsg:={}
	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


	*------------------------------------------------------------------*
Static Function STWFR14(_aMsg,_cEmail,_cCopia,_cAssunto)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local cFuncSent		:= "STWFR14"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:=' '
	default _cAssunto		:= 'DevoluГЦo '

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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,,,'  ')
		EndIf

	EndIf
	RestArea(aArea)
Return()

User Function STWF15( )
	//Local cAliasSuper	:= 'STWF15'
	//Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cCop			:=  " " //Ticket 20211109024060	
	Local _cmail		:=  " " //Ticket 20211109024060	
	Local cCliHome1  := ""
	Local cCliHome2  := ""
	Local cMailH1    := ""
	Local cMailH2    := ""
		

	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT")	
	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria
	RpcSetEnv("11","01",,,"FAT")

	_cCop			:=  GetMv("STWF15CC",,"Vanessa.Bezerra@steck.com.br") //Ticket 20211109024060	
	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria:
	//_cmail		:=  GetMv("STWF15",," Simone.mara@steck.com.br;jefferson.puglia@steck.com.br;Guilherme.fernandez@steck.com.br;Kleber.braga@steck.com.br;Wellington.gamas@steck.com.br;marcelo.oliveira@steck.com.br;juliana.ferreira@steck.com.br;rafael.souza@steck.com.br") //Ticket 20211109024060	
	
	//quando for necessАrio alterar, И sС cadastrar o parБmetro e colocar os cСdigos de clientes separados por , (vМrgula)
	//parБmetros com os cСdigos de clientes: 
	//ST_WF15CL1 ---> ligado ao parБmetro STWF15EM1
	//ST_WF15CL2 ---> ligado ao parБmetro STWF15EM2

	//parБmetros com os emails:
	//STWF15EM1 
	//STWF15EM2
		
	/*
	TICKET : #20220328006761
	//PARбMETRO: ST_WF15CL1

	LEROY √ 038134  
	C&C - 014519  
	SAINT-GOBAIN √ 028358  
	VILLAGE √ 053211  
	TUMELERO √ 092187  
	CONIBASE √ 064388  
	OBRAMAX √ 090222  
	JOLI √ 036970 
	CONSTRUDECOR √ 023789
	Center Castilho - 047687
	*/
	//Clientes:	
	cCliHome1 := GetNewPar("ST_WF15CL1" , "038134,014519,028358,053211,092187,064388,090222,036970,023789,047687")
	
	//Emails: 
	cMailH1 := GetNewPar("STWF15EM1", "caroline.atouguia@steck.com.br;marcelo.oliveira@steck.com.br;simone.pires@steck.com.br;"+;
	                                   "gerlanio.santos@steck.com.br;simone.mara@steck.com.br;guilherme.fernandez@steck.com.br;"+;
									   "wellington.gamas@steck.com.br;kleber.braga@steck.com.br;vanessa.bezerra@steck.com.br;"+;
									   "fabiano.barile@steck.com.br")
	
	

	//PARбMETRO: ST_WF15CL2
	//AMAZON √ 092887	
	//Clientes:
	cCliHome2 := GetNewPar("ST_WF15CL2" , "092887")  
	//Emails: 
	cMailH2 := GetNewPar("STWF15EM2", "thaiz.santos@steck.com.br;marcelo.oliveira@steck.com.br;ana.rodrigues@steck.com.br;"+;
	                                   "simone.mara@steck.com.br; guilherme.fernandez@steck.com.br; wellington.gamas@steck.com.br;"+;
									   "kleber.braga@steck.com.br;vanessa.bezerra@steck.com.br;fabiano.barile@steck.com.br")
	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria:
	
	
	//FunГЦo para povoar o array de envio conforme grupo de clientes (parБmetro cCliHome)
	//chama 2x porque hА dois grupos de clientes, para cada grupo de cliente И um grupo de pessoas que recebe o email
	STWF15POVOA(cCliHome1,@_aMsg,cMailH1) 

	Sleep(5000)

	_aMsg := {}

	STWF15POVOA(cCliHome2,@_aMsg,cMailH2) 

	Reset Environment

Return 

//FunГЦo para povoar o array de envio conforme grupo de clientes (parБmetro cCliHome)
//pois dependendo do grupo de clientes И um grupo de pessoas que recebem
Static Function STWF15POVOA(cCliHome,_aMsg,_cmail)	
Local cQuery     	:= ' '
Local cAliasSuper	:= 'STWF15'
Local cQuery        := ""
Local _cCop         := ""


	cQuery := " SELECT "+CRLF
	cQuery += " DISTINCT "+CRLF
	cQuery += " C5_NOTA, " + CRLF
	cQuery += " C5_CLIENTE, " +CRLF
	cQuery += " C5_CLIENTE||'/'||C5_LOJACLI as C5_CLILOJ,"+CRLF
	cQuery += "  C5_NUM, "+CRLF
	cQuery += " SUBSTR(C5_EMISSAO,7,2)||'/'||SUBSTR(C5_EMISSAO,5,2)||'/'||SUBSTR(C5_EMISSAO,1,4) as C5_EMISSAO, "+CRLF
	cQuery += " SUBSTR(C5_ZDTCLI,7,2)||'/'||SUBSTR(C5_ZDTCLI,5,2)||'/'||SUBSTR(C5_ZDTCLI,1,4) as C5_ZDTCLI  , "+CRLF
	cQuery += " C5_XORDEM,C5_XNOME, "+CRLF

	cQuery += " CASE WHEN C5_CLIENTE <> '038134' THEN C5_XOBSVEN ELSE A1_XLOJA END AS  A1_XLOJA,C5_XALERTF, "+CRLF
	cQuery += " SUBSTR(C5_XAGENDA,7,2)||'/'||SUBSTR(C5_XAGENDA,5,2)||'/'||SUBSTR(C5_XAGENDA,1,4) as C5_XAGENDA   , "+CRLF
	cQuery += " CASE WHEN "+CRLF
	cQuery += " EXISTS "+CRLF

	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria
	//cQuery += " (SELECT * FROM PA1010 PA1
	cQuery += " (SELECT * FROM " + RetSqlName("PA1") + " PA1 "+CRLF
	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria

	cQuery += " WHERE PA1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "  AND PA1_FILIAL = C5_FILIAL "+CRLF
	cQuery += "  AND SUBSTR(PA1_DOC,1,6) = C5_NUM "+CRLF
	cQuery += "  ) "+CRLF
	cQuery += " THEN 'PARCIAL' ELSE 'TOTAL' END AS TIPO,"+CRLF
	cQuery += " CASE	WHEN CB7_STATUS = '0' THEN '0-Inicio' "+CRLF
	cQuery += "         WHEN CB7_STATUS = '1' THEN '1-Separando' "+CRLF
	cQuery += "       	WHEN CB7_STATUS = '2' THEN '2-Sep.Final' "+CRLF
	cQuery += "         WHEN CB7_STATUS = '3' THEN '3-Embalando' "+CRLF
	cQuery += "         WHEN CB7_STATUS = '4' THEN '4-Emb.Final' "+CRLF
	cQuery += "			WHEN CB7_STATUS = '8' THEN '8-Embarcado' "+CRLF
	cQuery += "       	WHEN CB7_STATUS = '9' THEN '9-Embarque Finalizado' "+CRLF
	cQuery += " ELSE 'SEM OS' "+CRLF
	cQuery += " END STATUSX, "+CRLF
	
	//FR - 29/03/2022 - FlАvia Rocha - Sigamat Consultoria - revisЦo da lСgica por autorizaГЦo de Marcelo Oliveira:  
	//pegar apenas os pedidos totalmente em aberto, se houver faturamento parcial nЦo irА considerar: 
	//cQuery += " ( SELECT COUNT(1) 		FROM " + RetSqlName("SC6") + " SC61 WHERE SC61.D_E_L_E_T_ = ' ' AND SC61.C6_NUM = C5_NUM AND SC61.C6_QTDVEN > SC61.C6_QTDENT AND SC61.C6_BLQ <> 'R' AND SC61.C6_FILIAL = C5_FILIAL )  AS QTD_LINHAS, "   +CRLF
    //cQuery += " ( SELECT SUM(C6_QTDVEN) FROM " + RetSqlName("SC6") + " SC62 WHERE SC62.D_E_L_E_T_ = ' ' AND SC62.C6_NUM = C5_NUM AND SC62.C6_QTDVEN > SC62.C6_QTDENT AND SC62.C6_BLQ <> 'R' AND SC62.C6_FILIAL = C5_FILIAL )  AS QTD_PECAS "+CRLF
	
	cQuery += " ( SELECT COUNT(1) 		FROM " + RetSqlName("SC6") + " SC61 WHERE SC61.D_E_L_E_T_ = ' ' AND SC61.C6_NUM = C5_NUM AND SC61.C6_BLQ <> 'R' AND SC61.C6_FILIAL = C5_FILIAL )  AS QTD_LINHAS, "+CRLF
    cQuery += " ( SELECT SUM(C6_QTDVEN) FROM " + RetSqlName("SC6") + " SC62 WHERE SC62.D_E_L_E_T_ = ' ' AND SC62.C6_NUM = C5_NUM AND SC62.C6_BLQ <> 'R' AND SC62.C6_FILIAL = C5_FILIAL )  AS QTD_PECAS "+CRLF + CRLF
	//FR - 29/03/2022 - FlАvia Rocha - Sigamat Consultoria - revisЦo da lСgica por autorizaГЦo de Marcelo Oliveira:  

	cQuery += " FROM " + RetSqlName("SC5") + " SC5 " +CRLF
	cQuery += " INNER 	JOIN " + RetSqlName("SA1") + " SA1 ON ( A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' )"  +CRLF
	cQuery += " LEFT	JOIN " + RetSqlName("CB7") + " CB7 ON ( CB7_FILIAL = C5_FILIAL AND CB7_PEDIDO = C5_NUM AND CB7.D_E_L_E_T_ = ' ' )"+CRLF
	cQuery += " WHERE SC5.D_E_L_E_T_ = ' ' "+CRLF + CRLF
	
	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria
	//cQuery += " AND C5_CLIENTE IN ("+GetMv("ST_WF1501",,"'038134','014519','028358'")+")
	//cQuery += " AND C5_FILIAL = '02'
	cQuery += " AND C5_CLIENTE IN (" + Alltrim(cCliHome) + ") "	+CRLF + CRLF //aqui os cСdigos de clientes que sЦo selecionados para o envio
	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria
	

	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria
	//cQuery += " AND EXISTS (SELECT * FROM SC6010 SC6
	cQuery += " AND EXISTS (SELECT * FROM " + RetSqlName("SC6") + "  SC6 "+CRLF
	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria

	cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " AND C6_NUM = C5_NUM "+CRLF

	//FR - 29/03/2022 - FlАvia Rocha - Sigamat Consultoria - revisЦo da lСgica por autorizaГЦo de Marcelo Oliveira  
	//cQuery += " AND ( (C6_QTDVEN - C6_QTDENT) > 0 ) "+CRLF	
	//FR - 29/03/2022 - FlАvia Rocha - Sigamat Consultoria - revisЦo da lСgica por autorizaГЦo de Marcelo Oliveira 

	cQuery += " AND C6_BLQ <> 'R' "+CRLF
	cQuery += " AND C6_FILIAL = C5_FILIAL "+CRLF
	cQuery += " ) "+CRLF + CRLF

	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria:	
	//cQuery += " AND NOT EXISTS(SELECT * FROM SD2010 SD2	
	cQuery += " AND NOT EXISTS(SELECT * FROM " + RetSqlName("SD2") + "  SD2 "+CRLF
	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria:
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " AND D2_PEDIDO = C5_NUM "+CRLF
	cQuery += " AND D2_FILIAL = C5_FILIAL) "+CRLF + CRLF
	

	//>> Ticket 20201026009463 - Everon Santana - 27.10.2020
	//FR - 28/03/2022 - FlАvia Rocha - Sigamat Consultoria
	
	cQuery += " UNION "+CRLF + CRLF

	cQuery += " SELECT "+CRLF
	cQuery += " DISTINCT "+CRLF
	cQuery += " C5_NOTA, "+ CRLF
	cQuery += " C5_CLIENTE,  "+CRLF
	cQuery += " C5_CLIENTE||'/'||C5_LOJACLI as C5_CLILOJ,"+CRLF
	cQuery += "  C5_NUM, "+CRLF
	cQuery += " SUBSTR(C5_EMISSAO,7,2)||'/'||SUBSTR(C5_EMISSAO,5,2)||'/'||SUBSTR(C5_EMISSAO,1,4) as C5_EMISSAO, "+CRLF
	cQuery += " SUBSTR(C5_ZDTCLI,7,2)||'/'||SUBSTR(C5_ZDTCLI,5,2)||'/'||SUBSTR(C5_ZDTCLI,1,4) as C5_ZDTCLI  , "+CRLF
	cQuery += " C5_XORDEM,C5_XNOME, "+CRLF

	cQuery += " CASE WHEN C5_CLIENTE <> '038134' THEN C5_XOBSVEN ELSE A1_XLOJA END AS  A1_XLOJA, " + CRLF
	cQuery += " C5_XALERTF, "+CRLF
	cQuery += " SUBSTR(C5_XAGENDA,7,2)||'/'||SUBSTR(C5_XAGENDA,5,2)||'/'||SUBSTR(C5_XAGENDA,1,4) as C5_XAGENDA   , "+CRLF
	cQuery += " CASE WHEN "+CRLF
	cQuery += " EXISTS "+CRLF

	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria
	//cQuery += " (SELECT * FROM PA1010 PA1
	cQuery += " (SELECT * FROM " + RetSqlName("PA1") + "  PA1 "+CRLF
	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria

	cQuery += " WHERE PA1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "  AND PA1_FILIAL = C5_FILIAL "+CRLF
	cQuery += "  AND SUBSTR(PA1_DOC,1,6) = C5_NUM "+CRLF
	cQuery += "  ) "+CRLF
	cQuery += " THEN 'PARCIAL' ELSE 'TOTAL' END AS TIPO,"+CRLF
	cQuery += " CASE	WHEN CB7_STATUS = '0' THEN '0-Inicio'"+CRLF
	cQuery += "         WHEN CB7_STATUS = '1' THEN '1-Separando'"+CRLF
	cQuery += "       	WHEN CB7_STATUS = '2' THEN '2-Sep.Final'"+CRLF
	cQuery += "         WHEN CB7_STATUS = '3' THEN '3-Embalando'"+CRLF
	cQuery += "         WHEN CB7_STATUS = '4' THEN '4-Emb.Final'"+CRLF
	cQuery += "			WHEN CB7_STATUS = '8' THEN '8-Embarcado'"+CRLF
	cQuery += " ELSE 'SEM OS' "+CRLF
	cQuery += " END STATUSX, "+CRLF+CRLF

	cQuery += " ( SELECT COUNT(1) 		                       FROM " + RetSqlName("SC6") + " SC61 WHERE SC61.D_E_L_E_T_ = ' ' AND SC61.C6_NUM = C5_NUM AND SC61.C6_BLQ <> 'R' AND SC61.C6_FILIAL = C5_FILIAL )  AS QTD_LINHAS,"+CRLF
    cQuery += " ( SELECT SUM( SC62.C6_QTDVEN - SC62.C6_QTDENT) FROM " + RetSqlName("SC6") + " SC62 WHERE SC62.D_E_L_E_T_ = ' ' AND SC62.C6_NUM = C5_NUM AND SC62.C6_BLQ <> 'R' AND SC62.C6_FILIAL = C5_FILIAL )  AS QTD_PECAS "+CRLF+CRLF
	
	cQuery += " FROM " + RetSqlName("SC5") + " SC5"+CRLF
	cQuery += " INNER 	JOIN " + RetSqlName("SA1") + " SA1 ON ( A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' )"  +CRLF
	cQuery += " LEFT	JOIN " + RetSqlName("CB7") + " CB7 ON ( CB7_FILIAL = C5_FILIAL AND CB7_PEDIDO = C5_NUM AND CB7.D_E_L_E_T_ = ' ' )"+CRLF
	cQuery += " WHERE SC5.D_E_L_E_T_ = ' ' "+CRLF + CRLF
	
	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria
	//cQuery += " AND C5_CLIENTE IN ('006596') "	
	//cQuery += " AND C5_FILIAL = '02' "
	cQuery += " AND C5_CLIENTE IN (" + Alltrim(cCliHome) + ") "	+CRLF + CRLF //aqui os cСdigos de clientes que sЦo selecionados para o envio
	//cQuery += " AND C5_FILIAL = '02' "
	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria

	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria:
	//cQuery += " AND EXISTS (SELECT * FROM SC6010 SC6
	cQuery += " AND EXISTS (SELECT * FROM " + RetSqlName("SC6") + " SC6 "+CRLF
	//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria:

	cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " AND C6_NUM = C5_NUM "+CRLF
	//cQuery += " AND ( (C6_QTDVEN - C6_QTDENT) > 0 ) "+CRLF  //FR - 29/03/2022 - aqui permite pedidos com saldo, e por solicitaГЦo de Marcelo Oliveira, exibir apenas pedidos que nЦo foram faturados
	cQuery += " AND C6_BLQ <> 'R' "+CRLF
	cQuery += " AND C6_FILIAL = C5_FILIAL "+CRLF
	cQuery += " AND C6_NOTA = '' ) "+CRLF + CRLF

	//<< Ticket 20201026009463
	//FR - 28/03/2022 - FlАvia Rocha - Sigamat Consultoria
	

	cQuery += " ORDER BY C5_CLIENTE,C5_ZDTCLI "+CRLF

	MemoWrite("C:\TEMP\STWF15.TXT" , cQuery )
	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf 

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)

	(cAliasSuper)->(dbgotop())

	If  Select(cAliasSuper) > 0

		(cAliasSuper)->(dbgotop())

		aadd(_aMsg,{"CLIENTE/LJ","PEDIDO","EMISSAO","QTD.LINHAS","QTD.PEгAS","DT.CLIENTE","ORDEM DE COMPRA","REFERENCIA","AGENDAMENTO"  ,"TIPO","ALERTA FAT.", "SITUACAO DO PEDIDO/STATUS"})

		_cVen:= ' '

		dbSelectArea(cAliasSuper)
		
		While 	(cAliasSuper)->(!Eof())

			If _cVen <>	(cAliasSuper)->C5_CLIENTE
				_cVen	:=	(cAliasSuper)->C5_CLIENTE
				
				If Len(_aMsg) > 1
					STWFR15(_aMsg,_cmail,_cCop ,_aMsg[2,1],_aMsg[2,13],SubStr(_aMsg[2,1],1,6))
					_aMsg:={}
					aadd(_aMsg,{"CLIENTE/LJ","PEDIDO","EMISSAO","QTD.LINHAS","QTD.PEгAS","DT.CLIENTE","ORDEM DE COMPRA","REFERENCIA","AGENDAMENTO" ,"TIPO","ALERTA FAT.", "SITUACAO DO PEDIDO/STATUS"})
				EndIf
				
			EndIf

			aadd(_aMsg,{(cAliasSuper)->C5_CLILOJ,;
				(cAliasSuper)->C5_NUM,;
				(cAliasSuper)->C5_EMISSAO,;
				(cAliasSuper)->QTD_LINHAS,;
				(cAliasSuper)->QTD_PECAS,;
				(cAliasSuper)->C5_ZDTCLI,;
				(cAliasSuper)->C5_XORDEM,;
				(cAliasSuper)->A1_XLOJA,;
				(cAliasSuper)->C5_XAGENDA,;
				(cAliasSuper)->TIPO,;
				(cAliasSuper)->C5_XALERTF,;
				(cAliasSuper)->STATUSX ,;
				(cAliasSuper)->C5_XNOME } )

			(cAliasSuper)->(dbskip())

		End

		If Len(_aMsg) > 1
			STWFR15(_aMsg,_cmail,_cCop ,_aMsg[2,1],_aMsg[2,13],SubStr(_aMsg[2,1],1,6))
			_aMsg:={}
			aadd(_aMsg,{"CLIENTE/LJ","PEDIDO","EMISSAO","QTD.LINHAS","QTD.PEгAS","DT.CLIENTE","ORDEM DE COMPRA","REFERENCIA","AGENDAMENTO" ,"TIPO","ALERTA FAT.", "SITUACAO DO PEDIDO/STATUS"})
		EndIf
	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

Static Function STWFR15(_aMsg,_cEmail,_cCopia,_CodNF,_cNome,_cCodCli)
	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'WF Agendamento Home Center: ' + Alltrim(_cNome)
	Local cFuncSent		:= "STWFR15"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	Local _nTot1		:= 0
	Local _nTot2		:= 0

	default _cEmail  	:= "   "
	default _cCopia  	:='  '

	//>> Ticket 20200827006465 - Everson Santana - 01.09.2020 
	If _cCodCli == "006596" 

		_cAssunto := "WF Acompanhamento : " + Alltrim(_cNome)
		//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria
		//_cEmail   := GetMv("STWFR15",," guilherme.fernandez@steck.com.br;jefferson.puglia@steck.com.br;simone.mara@steck.com.br") //Ticket 20211103023513	
		_cEmail   += GetMv("STWFR15",,";guilherme.fernandez@steck.com.br;jefferson.puglia@steck.com.br;simone.mara@steck.com.br") //Ticket 20211103023513	
		//FR - 28/03/2022 - ALTERAгцO - FlАvia Rocha - Sigamat Consultoria
	EndIf

	//_cEmail := ";flah.rocha@gmail.com;flah.rocha@sigamat.com.br" //FR TESTE
	//_cEmail += ";flah.rocha@gmail.com;flah.rocha@sigamat.com.br" //FR TESTE

	//<< Ticket 20200827006465
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
		cMsg += '<HR Width=90% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=90%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do texto/detalhe do email                                         Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf

			If _nLin = 1
				cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
				cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></B></TD>'
				cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></B></TD>'
				cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></B></TD>'
				cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></B></TD>'
				cMsg += '<TD align=center><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,12] + ' </Font></B></TD>'
			Else
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' +;
				Transform(_aMsg[_nLin,4],"@E 999,999,999") + ' </Font></TD>'
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' +;
					Transform(_aMsg[_nLin,5],"@E 999,999,999") + ' </Font></TD>'
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></TD>'
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,09] + ' </Font></TD>'
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></TD>'
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></TD>'
				cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,12] + ' </Font></TD>'
				
				// Alimentar os totalizadores
				_nTot1	+= _aMsg[_nLin,4]
				_nTot2	+= _aMsg[_nLin,5]
			EndIf

		Next

		cMsg += '<TR BgColor=#FFFFFF>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">Totais</Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'

		cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + Transform(_nTot1,"@E 999,999,999") + '</Font></TD>'
		cMsg += '<TD align=center><Font Color=#000000 Size="2" Face="Arial">' + Transform(_nTot2,"@E 999,999,999") + '</Font></TD>'

		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial"></Font></TD>'

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=90% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		//If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			//_cEmail := "everson.santana@steck.com.br"
			//_cCopia := ""
			U_STMAILTES(_cEmail , _cCopia , _cAssunto, cMsg,,,'   ')

			//ENVIA EMAIL FR
			//FRSendMail(_cEmail, _cCopia, _cAssunto, cMsg, "" ) //FRSendMail(cMailTo, cCopia, cAssun, cCorpo, cAnexo )  //FR RETIRAR
		//EndIf

	EndIf
	RestArea(aArea)
Return()

User Function STSB5( )


	Local cAliasSuper	:= 'STSB5'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	RpcSetEnv("03","01",,,"FAT")



	cQuery := " SELECT * FROM SB5010 SB5 WHERE SB5.D_E_L_E_T_ = ' ' AND B5_EAN141 <> 0


	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0

		While 	(cAliasSuper)->(!Eof())


			DbSelectArea("SB5")
			SB5->(DbSetOrder(1))
			SB5->(DbGoTop())
			If  SB5->(DbSeek(xFilial("SB5")+(cAliasSuper)->B5_COD))
				SB5->(RecLock("SB5",.F.))
			Else
				SB5->(RecLock("SB5",.T.))
			EndIf
			SB5->B5_COD  := (cAliasSuper)->B5_COD
			SB5->B5_CEME    := (cAliasSuper)->B5_CEME

			SB5->B5_COMPR  := (cAliasSuper)->B5_COMPR
			SB5->B5_DES    := (cAliasSuper)->B5_DES
			SB5->B5_EMB1   := (cAliasSuper)->B5_EMB1
			SB5->B5_EMB2   := (cAliasSuper)->B5_EMB2
			SB5->B5_ESPESS := (cAliasSuper)->B5_ESPESS
			SB5->B5_ESTMAT := (cAliasSuper)->B5_ESTMAT
			SB5->B5_LARG    := (cAliasSuper)->B5_LARG
			SB5->B5_QE1     := (cAliasSuper)->B5_QE1
			SB5->B5_QE2     := (cAliasSuper)->B5_QE2
			SB5->B5_EAN141:= (cAliasSuper)->B5_EAN141
			SB5->B5_EAN142:= (cAliasSuper)->B5_EAN142
			SB5->B5_EAN143:= (cAliasSuper)->B5_EAN143
			SB5->B5_EAN144:= (cAliasSuper)->B5_EAN144
			SB5->B5_EAN145:= (cAliasSuper)->B5_EAN145
			SB5->B5_EAN146:= (cAliasSuper)->B5_EAN146
			SB5->B5_EAN147:= (cAliasSuper)->B5_EAN147
			SB5->B5_EAN148:= (cAliasSuper)->B5_EAN148
			SB5->(MsUnlock())
			SB5->( DbCommit() )



			(cAliasSuper)->(dbskip())

		End
	EndIf





	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


User Function STWF16X()

	U_STWF16()

Return()

User Function STWF16( )


	Local cAliasSuper	:= 'STWF16'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")




	cQuery := " SELECT
	cQuery += " UA_NUM 	AS NUM,
	cQuery += " UA_EMISSAO AS EMISSAO,
	cQuery += " UA_CLIENTE||'-'||UA_LOJA AS CLIENTE,
	cQuery += " UA_XNOME 	AS NOME,
	cQuery += " SA3.A3_COD||'-'||SA3.A3_NOME AS VEND1,
	cQuery += " SA3.A3_EMAIL AS EMAIL1,
	//cQuery += " ' ' AS EMAIL1,
	cQuery += " TA3.A3_COD||'-'||TA3.A3_NOME AS COORD,
	cQuery += " TA3.A3_EMAIL AS EMAILCOORD,
	cQuery += " NVL(XA3.A3_COD,' ')||'-'||NVL(XA3.A3_NOME,' ') AS VEND2,
	cQuery += " UA_ZVALLIQ, UA_DESCNT, UA_XEMLSZR

	cQuery += " FROM SUA010 SUA

	cQuery += " INNER JOIN(SELECT * FROM SA3010)SA3
	cQuery += " ON SA3.D_E_L_E_T_ = ' '
	cQuery += " AND SA3.A3_COD = UA_VEND

	cQuery += " LEFT JOIN(SELECT * FROM SA3010)TA3
	cQuery += " ON TA3.D_E_L_E_T_ = ' '
	cQuery += " AND TA3.A3_COD = SA3.A3_SUPER

	cQuery += " LEFT JOIN(SELECT * FROM SA3010)XA3
	cQuery += " ON XA3.D_E_L_E_T_ = ' '
	cQuery += " AND XA3.A3_COD = UA_VEND2



	cQuery += " WHERE SUA.D_E_L_E_T_ = ' '
	cQuery += " AND   SUA.UA_FILIAL = '02'
	cQuery += " AND   SUA.UA_NUMSC5 = ' '
	cQuery += " AND   SUA.UA_CANC = ' '
	cQuery += " AND   SUA.UA_CODCANC = ' '
	cQuery += " AND   SUA.UA_XBLOQ<>'3'
//	cQuery += " AND   SUA.UA_ZVALLIQ >= 3500

	cQuery += " 	ORDER BY VEND1,UA_EMISSAO



	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"ORгAMENTO","EMISSцO","CLIENTE","NOME","VALOR","INTERNO","CONTATO","USUARIO PORTAL"})
		_cVen:= ' '
		While 	(cAliasSuper)->(!Eof())

			If _cVen <>	(cAliasSuper)->VEND1
				_cVen:=	(cAliasSuper)->VEND1
				If Len(_aMsg) > 1

					If IsInCallStack("U_STWF16X")
						STWFR16(_aMsg,"","",_cn03)
					Else
						STWFR16(_aMsg,_cn01+';'+_cn02,"",_cn03)
					EndIf

					_aMsg:={}
					aadd(_aMsg,{"ORгAMENTO","EMISSцO","CLIENTE","NOME","VALOR","INTERNO","CONTATO","USUARIO PORTAL"})
				EndIf
			EndIf
			aadd(_aMsg,{(cAliasSuper)->NUM,;
				Dtoc(Stod((cAliasSuper)->EMISSAO)),;
				(cAliasSuper)->CLIENTE,;
				Alltrim((cAliasSuper)->NOME),;
				Transform( (cAliasSuper)->UA_ZVALLIQ ,"@E 999,999,999.99"), ;
				(cAliasSuper)->VEND2,;
				AllTrim((cAliasSuper)->UA_DESCNT),;
				AllTrim((cAliasSuper)->UA_XEMLSZR);
				}  )
			_cn01:= Alltrim((cAliasSuper)->EMAIL1)
			_cn02:= Alltrim((cAliasSuper)->EMAILCOORD)
			_cn03:= Alltrim((cAliasSuper)->VEND1)
			(cAliasSuper)->(dbskip())

		End
		If Len(_aMsg) > 1

			If IsInCallStack("U_STWF16X")
				STWFR16(_aMsg,"","",_cn03)
			Else
				STWFR16(_aMsg,_cn01+';'+_cn02,"",_cn03)
			EndIf

			_aMsg:={}
			aadd(_aMsg,{"ORгAMENTO","EMISSцO","CLIENTE","NOME","VALOR","INTERNO","CONTATO","USUARIO PORTAL"})
		EndIf
	EndIf





	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


	*------------------------------------------------------------------*
Static Function STWFR16(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'OrГamentos em Abertos : '+_CodNF
	Local cFuncSent		:= "STWFR16"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:=''

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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></TD>'

			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado

			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)
Return()



User Function STWF17( )


	Local cAliasSuper	:= 'STWF17'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")




	cQuery := " SELECT
	cQuery += " 'PA2' AS TIPO,
	cQuery += " C6_PRODUTO,
	cQuery += " C6_NUM,
	cQuery += " C6_ITEM,
	cQuery += " PA2_QUANT AS QUANTIDADE,
	cQuery += " C6_BLQ

	cQuery += " FROM PA2010 PA2

	cQuery += " INNER JOIN (SELECT * FROM SC6010)SC6
	cQuery += " ON SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_FILIAL = PA2_FILRES
	cQuery += " AND C6_NUM||C6_ITEM = PA2.PA2_DOC
	cQuery += " AND (C6_QTDVEN<=C6_QTDENT OR C6_BLQ = 'R')

	cQuery += " WHERE PA2.D_E_L_E_T_ = ' '
	cQuery += " AND PA2_FILRES = '02'

	cQuery += " UNION


	cQuery += " SELECT

	cQuery += "  'SDC' AS TIPO,
	cQuery += " C6_PRODUTO,
	cQuery += "  C6_NUM,
	cQuery += "  C6_ITEM,
	cQuery += " DC_QUANT AS QUANTIDADE,
	cQuery += " C6_BLQ
	cQuery += " FROM SDC010 SDC

	cQuery += " INNER JOIN (SELECT * FROM SC6010)SC6
	cQuery += " ON SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_FILIAL = DC_FILIAL
	cQuery += " AND C6_NUM = DC_PEDIDO
	cQuery += " AND C6_ITEM = DC_ITEM
	cQuery += " AND (C6_QTDVEN<=C6_QTDENT OR C6_BLQ = 'R')

	cQuery += " WHERE SDC.D_E_L_E_T_ = ' '
	cQuery += " AND DC_FILIAL = '02'
	cQuery += " AND DC_QUANT <> 0 order by C6_NUM,c6_item




	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"TIPO","PRODUTO","PEDIDO","ITEM","QUANTIDADE","RESIDUO"})

		_cVen:= ' '
		While 	(cAliasSuper)->(!Eof())


			aadd(_aMsg,{(cAliasSuper)->TIPO,;
				(cAliasSuper)->C6_PRODUTO ,;
				(cAliasSuper)->C6_NUM,;
				(cAliasSuper)->C6_ITEM,;
				Transform( (cAliasSuper)->QUANTIDADE ,"@E 999,999,999.99"), ;
				(cAliasSuper)->C6_BLQ;
				}  )

			(cAliasSuper)->(dbskip())

		End
		If Len(_aMsg) > 1
			STWFR17(_aMsg,'',''  ,'')
		EndIf
	EndIf





	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


	*------------------------------------------------------------------*
Static Function STWFR17(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'Empenhos/Reservas '
	Local cFuncSent		:= "STWFR17"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:= ' '

	_cEmail  	:= "   KLEBER.BRAGA@STECK.COM.BR  "
	_cCopia  	:= '  '

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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'

			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado

			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)
Return()



User Function STWF18( )


	Local cAliasSuper	:= 'STWF18'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")




	cQuery := " SELECT
	cQuery += "  C6_NUM,C5_XNOME,C5_EMISSAO,C5_XATE||'/'||C5_XMATE||'/'||C5_XAANO AS PROGRAMACAO,C6_PRODUTO,C6_PRCVEN,C6_QTDVEN,C6_ZVALLIQ,B1_DESC,B1_GRUPO,B1_XLIBDES,PA1_QUANT,C6_ZENTRE2 , C5_XAANO||C5_XMATE||C5_XATE AS ORDERX
	cQuery += " ,NVL(utl_raw.cast_to_varchar2(dbms_lob.substr(PP8_OBS,2000,1)),' ') OBS, NVL(PP8_XSTATU,' ') STATUS
	cQuery += " FROM SC6010 SC6
	cQuery += " INNER JOIN(SELECT * FROM SB1010)SB1
	cQuery += " ON SB1.D_E_L_E_T_ = ' '
	cQuery += " AND B1_COD = C6_PRODUTO
	cQuery += " AND B1_GRUPO IN ('041','042','122')
	cQuery += " INNER JOIN(SELECT * FROM PA1010)PA1
	cQuery += " ON PA1.D_E_L_E_T_ = ' '
	cQuery += " AND PA1_FILIAL = C6_FILIAL
	cQuery += " AND PA1_DOC = C6_NUM||C6_ITEM
	cQuery += " INNER JOIN(SELECT * FROM SC5010)SC5
	cQuery += " ON SC5.D_E_L_E_T_ = ' '
	cQuery += " AND C5_FILIAL = C6_FILIAL
	cQuery += " AND C5_NUM = C6_NUM
	cQuery += " AND SC5.C5_TIPOCLI <> 'X' "

	cQuery += " LEFT JOIN PP8010 PP8
	cQuery += " ON PP8_FILIAL=C6_FILIAL AND PP8_PEDVEN=C6_NUM||C6_ITEM AND PP8_PROD=C6_PRODUTO AND PP8.D_E_L_E_T_=' '

	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_QTDVEN > C6_QTDENT
	cQuery += " AND C6_BLQ <> 'R'
	cQuery += " AND C6_FILIAL = '02'


	cQuery += " UNION

	cQuery += " SELECT
	cQuery += " ' ' AS C6_NUM,' ' AS C5_XNOME,' ' AS C5_EMISSAO,' ' AS PROGRAMACAO,' ' AS C6_PRODUTO,0 AS C6_PRCVEN,0 AS C6_QTDVEN,0 AS C6_ZVALLIQ,'TOTAL PROGRAMADOS' AS B1_DESC,' ' AS B1_GRUPO,' ' AS B1_XLIBDES,SUM(PA1_QUANT),' ' AS C6_ZENTRE2 , ' ' AS ORDERX
	cQuery += " ,' ' OBS, ' ' STATUS
	cQuery += " FROM SC6010 SC6
	cQuery += " INNER JOIN(SELECT * FROM SB1010)SB1
	cQuery += " ON SB1.D_E_L_E_T_ = ' '
	cQuery += " AND B1_COD = C6_PRODUTO
	cQuery += " AND B1_GRUPO IN ('041','042','122')
	cQuery += " INNER JOIN(SELECT * FROM PA1010)PA1
	cQuery += " ON PA1.D_E_L_E_T_ = ' '
	cQuery += " AND PA1_FILIAL = C6_FILIAL
	cQuery += " AND PA1_DOC = C6_NUM||C6_ITEM
	cQuery += " INNER JOIN(SELECT * FROM SC5010)SC5
	cQuery += " ON SC5.D_E_L_E_T_ = ' '
	cQuery += " AND C5_FILIAL = C6_FILIAL
	cQuery += " AND C5_NUM = C6_NUM
	cQuery += " AND SC5.C5_TIPOCLI <> 'X' "
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_QTDVEN > C6_QTDENT
	cQuery += " AND C6_BLQ <> 'R'
	cQuery += " AND C6_FILIAL = '02'
	cQuery += " AND C5_XAANO||C5_XMATE||C5_XATE   <> ' '
	cQuery += " UNION

	cQuery += " SELECT
	cQuery += " ' ' AS C6_NUM,' ' AS C5_XNOME,' ' AS C5_EMISSAO,' ' AS PROGRAMACAO,' ' AS C6_PRODUTO,0 AS C6_PRCVEN,0 AS C6_QTDVEN,0 AS C6_ZVALLIQ,'TOTAL NцO PROGRAMADOS' AS B1_DESC,' ' AS B1_GRUPO,' ' AS B1_XLIBDES,SUM(PA1_QUANT),' ' AS C6_ZENTRE2 , ' ' AS ORDERX
	cQuery += " ,' ' OBS, ' ' STATUS
	cQuery += " FROM SC6010 SC6
	cQuery += " INNER JOIN(SELECT * FROM SB1010)SB1
	cQuery += " ON SB1.D_E_L_E_T_ = ' '
	cQuery += " AND B1_COD = C6_PRODUTO
	cQuery += " AND B1_GRUPO IN ('041','042','122')
	cQuery += " INNER JOIN(SELECT * FROM PA1010)PA1
	cQuery += " ON PA1.D_E_L_E_T_ = ' '
	cQuery += " AND PA1_FILIAL = C6_FILIAL
	cQuery += " AND PA1_DOC = C6_NUM||C6_ITEM
	cQuery += " INNER JOIN(SELECT * FROM SC5010)SC5
	cQuery += " ON SC5.D_E_L_E_T_ = ' '
	cQuery += " AND C5_FILIAL = C6_FILIAL
	cQuery += " AND C5_NUM = C6_NUM
	cQuery += " AND SC5.C5_TIPOCLI <> 'X' "
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_QTDVEN > C6_QTDENT
	cQuery += " AND C6_BLQ <> 'R'
	cQuery += " AND C6_FILIAL = '02'
	cQuery += " AND C5_XAANO||C5_XMATE||C5_XATE   = ' '
	cQuery += " UNION

	cQuery += " SELECT
	cQuery += " ' ' AS C6_NUM,' ' AS C5_XNOME,' ' AS C5_EMISSAO,' ' AS PROGRAMACAO,' ' AS C6_PRODUTO,0 AS C6_PRCVEN,0 AS C6_QTDVEN,0 AS C6_ZVALLIQ,'TOTAL  ' AS B1_DESC,' ' AS B1_GRUPO,' ' AS B1_XLIBDES,SUM(PA1_QUANT),' ' AS C6_ZENTRE2 , ' ' AS ORDERX
	cQuery += " ,' ' OBS, ' ' STATUS
	cQuery += " FROM SC6010 SC6
	cQuery += " INNER JOIN(SELECT * FROM SB1010)SB1
	cQuery += " ON SB1.D_E_L_E_T_ = ' '
	cQuery += " AND B1_COD = C6_PRODUTO
	cQuery += " AND B1_GRUPO IN ('041','042','122')
	cQuery += " INNER JOIN(SELECT * FROM PA1010)PA1
	cQuery += " ON PA1.D_E_L_E_T_ = ' '
	cQuery += " AND PA1_FILIAL = C6_FILIAL
	cQuery += " AND PA1_DOC = C6_NUM||C6_ITEM
	cQuery += " INNER JOIN(SELECT * FROM SC5010)SC5
	cQuery += " ON SC5.D_E_L_E_T_ = ' '
	cQuery += " AND C5_FILIAL = C6_FILIAL
	cQuery += " AND C5_NUM = C6_NUM
	cQuery += " AND SC5.C5_TIPOCLI <> 'X' "
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND C6_QTDVEN > C6_QTDENT
	cQuery += " AND C6_BLQ <> 'R'
	cQuery += " AND C6_FILIAL = '02'

	cQuery += "ORDER BY ORDERX






	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"PEDIDO","CLIENTE","EMISSAO","PROGRAMAгцO","CODIGO","PRODUTO","GRUPO","LIBERAгцO DESENHO","FALTA","COMPROMISSO","VALOR","OBS.","MOTIVO"})

		_cVen:= ' '

		_nVlrPrg := 0
		_nVlrNPg := 0

		While 	(cAliasSuper)->(!Eof())

			//_nPreco := U_STRETSST("01",(cAliasSuper)->C6_PRODUTO,(_cAlias1)->A1_LOJA,AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT),oXml:_PEDIDO:_CONDPG:TEXT,'PRECO')

			_nFalta := (cAliasSuper)->PA1_QUANT

			If Empty(SubStr((cAliasSuper)->PROGRAMACAO,1,1))
				_nVlrNPg += Round(_nFalta*(cAliasSuper)->(C6_ZVALLIQ/C6_QTDVEN),2)
			Else
				_nVlrPrg += Round(_nFalta*(cAliasSuper)->(C6_ZVALLIQ/C6_QTDVEN),2)
			EndIf

			aadd(_aMsg,{(cAliasSuper)->C6_NUM,;
				(cAliasSuper)->C5_XNOME ,;
				DTOC(STOD((cAliasSuper)->C5_EMISSAO)),;
				(cAliasSuper)->PROGRAMACAO,;
				(cAliasSuper)->C6_PRODUTO,;
				(cAliasSuper)->B1_DESC ,;
				(cAliasSuper)->B1_GRUPO,;
				DTOC(STOD((cAliasSuper)->B1_XLIBDES)),;
				IIF( 'TOTAL' $ (cAliasSuper)->B1_DESC,Transform( (cAliasSuper)->PA1_QUANT ,"@E 999,999,999"),Transform( (cAliasSuper)->PA1_QUANT ,"@E 999,999,999.99")), ;
				DTOC(STOD((cAliasSuper)->C6_ZENTRE2)),;
				cValToChar(Round(_nFalta*(cAliasSuper)->(C6_ZVALLIQ/C6_QTDVEN),2)),;
				AllTrim((cAliasSuper)->OBS),;
				(cAliasSuper)->STATUS;
				}  )

			(cAliasSuper)->(dbskip())

		End
		If Len(_aMsg) > 1
			STWFR18(_aMsg,'',''  ,'',_nVlrPrg,_nVlrNPg)
		EndIf
	EndIf





	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


	*------------------------------------------------------------------*
Static Function STWFR18(_aMsg,_cEmail,_cCopia,_CodNF,_nVlrPrg,_nVlrNPg)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'UNICOM nЦo Atendidas'
	Local cFuncSent		:= "STWFR18"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:= ' '

	_cEmail  	:= " ulisses.almeida@steck.com.br;luciano.fernandes@steck.com.br; filipe.nascimento@steck.com.br;alex.lourenco@steck.com.br ; thiago.ribeiro@steck.com.br; paulo.cruz@steck.com.br;bruno.galvao@steck.com.br"
	_cCopia  	:= ' '

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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,12] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,13] + ' </Font></B></TD>'


			Else

				If AllTrim(_aMsg[_nLin,6])=="TOTAL"
					_aMsg[_nLin,11] := cValToChar(_nVlrPrg+_nVlrNPg)
				ElseIf AllTrim(_aMsg[_nLin,6])=="TOTAL NцO PROGRAMADOS"
					_aMsg[_nLin,11] := cValToChar(_nVlrNPg)
				ElseIf AllTrim(_aMsg[_nLin,6])=="TOTAL PROGRAMADOS"
					_aMsg[_nLin,11] := cValToChar(_nVlrPrg)
				EndIf

				If !(Empty(Alltrim(dtos(ctod(_aMsg[_nLin,10]))))) .And. ctod(_aMsg[_nLin,10]) <= date()

					cMsg += '<TD><Font Color=#c62609 Size="3" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#c62609 Size="3" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#c62609 Size="3" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#c62609 Size="3" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#c62609 Size="3" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#c62609 Size="3" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#c62609 Size="3" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#c62609 Size="3" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#c62609 Size="3" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#c62609 Size="3" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#c62609 Size="3" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#c62609 Size="3" Face="Arial">' + _aMsg[_nLin,12] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#c62609 Size="3" Face="Arial">' + _aMsg[_nLin,13] + ' </Font></TD>'
				Else
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,12] + ' </Font></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,13] + ' </Font></TD>'
				EndIf
			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado

			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)
Return()




User Function STWF19( )


	Local cAliasSuper	:= 'STWF19'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")




	cQuery := " SELECT
	cQuery += "    A3_COD,A3_NOME,A3_XDTTERM FROM SA3010 SA3
	cQuery += "   WHERE SA3.D_E_L_E_T_ =  ' '
	cQuery += "   AND   SA3.A3_XDTTERM <> ' '
	cQuery += "   AND   SA3.A3_XDTTERM  <= '"+DTOS(DATE()+30)+"'





	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"Representante","Nome","Vencimento"})

		_cVen:= ' '
		While 	(cAliasSuper)->(!Eof())


			aadd(_aMsg,{(cAliasSuper)->A3_COD,;
				(cAliasSuper)->A3_NOME ,;
				DTOC(STOD((cAliasSuper)->A3_XDTTERM));
				}  )

			(cAliasSuper)->(dbskip())

		End
		If Len(_aMsg) > 1
			STWFR19(_aMsg,'',''  ,'')
		EndIf
	EndIf





	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


	*------------------------------------------------------------------*
Static Function STWFR19(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'Vencimento de Termo Aditivo.'
	Local cFuncSent		:= "STWFR19"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:= ' '

	_cEmail  	:= "  thais.souza@steck.com.br  "
	_cCopia  	:= ' '

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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'

			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado

			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)
Return()



User Function STWF20( )


	Local cAliasSuper	:= 'STWF20'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''
	Local _cn03			:= ''

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")




	cQuery := " SELECT
	cQuery += "  Z1Q.Z1Q_PLACA,Z1Z_NOME,Z1Q.Z1Q_DATA,Z1Q.Z1Q_HORA,Z1Z.Z1Z_VEND,Z1Z.Z1Z_EMAIL,
	cQuery += "  CASE WHEN Z1Q.Z1Q_LAT = '0' OR Z1Q.Z1Q_LONG = '0' THEN 0 ELSE
	cQuery += "  (ROUND((
	cQuery += "  SQRT(POWER((69.1 * ((TO_NUMBER( Z1Q.Z1Q_LAT) ) - (TO_NUMBER((SELECT NVL(T1Q.Z1Q_LAT,'0')
	cQuery += "  FROM Z1Q010 T1Q
	cQuery += "  WHERE T1Q.Z1Q_LAT <> '0'
	cQuery += "  AND T1Q.Z1Q_LONG <> '0'
	cQuery += "  AND T1Q.Z1Q_DATA = Z1Q.Z1Q_DATA
	cQuery += "  AND T1Q.Z1Q_PLACA = Z1Q.Z1Q_PLACA
	cQuery += "  AND ROWNUM = 1)
	cQuery += "  )))) , 2 ) +
	cQuery += "  POWER((53 * ((TO_NUMBER( Z1Q.Z1Q_LONG ) ) - (TO_NUMBER( (SELECT NVL(T1Q.Z1Q_LONG,'0')
	cQuery += "  FROM Z1Q010 T1Q
	cQuery += "  WHERE T1Q.Z1Q_LAT <> '0'
	cQuery += "  AND T1Q.Z1Q_LONG <> '0'
	cQuery += "  AND T1Q.Z1Q_DATA = Z1Q.Z1Q_DATA
	cQuery += "  AND T1Q.Z1Q_PLACA = Z1Q.Z1Q_PLACA
	cQuery += "  AND ROWNUM = 1)) ))), 2))/0.6213711922373301),0)) END
	cQuery += '  "DISTANCIA"
	cQuery += "  FROM Z1Q010 Z1Q
	cQuery += "  INNER JOIN(SELECT * FROM Z1Z010)Z1Z
	cQuery += "  ON Z1Z.D_E_L_E_T_ = ' '
	cQuery += "  AND Z1Z_PLACA = Z1Q.Z1Q_PLACA
	cQuery += "  WHERE Z1Q.Z1Q_DATA BETWEEN '"+dtos(date()-7)+"' AND '"+dtos(date()+1)+"'
	cQuery += "  AND Z1Q.Z1Q_PLACA NOT IN ('FWU4239','FFK2988','GCD2818','FJO6532','FOZ9656' ,'FCS9461','FFS0453','FEX5651','FPZ5983','FTU1528','GFI8149','DMF1891','FOU5481','FPG2459','FQZ9038','FZK3376','GGA5115','GGA8118')
	//cQuery += "   AND Z1Q.Z1Q_PLACA = 'EMV4492'
	cQuery += "   AND Z1Q.Z1Q_HORA BETWEEN '000000' AND '231800'

	cQuery += "  ORDER BY Z1Q.Z1Q_PLACA DESC, Z1Q.Z1Q_DATA DESC

	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0

		aadd(_aMsg,{" ",'','DATA',"RAIO PERCORRIDO","SISTEMA"})
		_cVen:= ' '
		While 	(cAliasSuper)->(!Eof())

			If _cVen <>	(cAliasSuper)->Z1Q_PLACA
				_cVen:=	(cAliasSuper)->Z1Q_PLACA
				If Len(_aMsg) > 1

					STWFR20(_aMsg,_cmail,''  ,_cn03)
					_aMsg:={}
					_cmail:= ' '
					aadd(_aMsg,{" ",'','DATA',"RAIO PERCORRIDO","SISTEMA"})
				EndIf
			EndIf
			If dow( stod((cAliasSuper)->Z1Q_DATA))<> 7  .And. dow( stod((cAliasSuper)->Z1Q_DATA))<> 1
				If 	aScan( _aMsg, { |x| x[1]+x[3] == Alltrim((cAliasSuper)->Z1Q_PLACA)+ Alltrim((cAliasSuper)->Z1Q_DATA) } ) == 0


					aadd(_aMsg,{(cAliasSuper)->Z1Q_PLACA,;
						(cAliasSuper)->Z1Z_NOME ,;
						(cAliasSuper)->Z1Q_DATA ,;
						(cAliasSuper)->DISTANCIA ,;
						Transform(ST20( (cAliasSuper)->Z1Z_VEND,(cAliasSuper)->Z1Q_DATA),"@E 9,999");
						}  )

				Else
					If _aMsg[aScan( _aMsg, { |x| x[1]+x[3] == Alltrim((cAliasSuper)->Z1Q_PLACA)+ Alltrim((cAliasSuper)->Z1Q_DATA) } ) , 4] < (cAliasSuper)->DISTANCIA
						_aMsg[aScan( _aMsg, { |x| x[1]+x[3] == Alltrim((cAliasSuper)->Z1Q_PLACA)+ Alltrim((cAliasSuper)->Z1Q_DATA) } ) , 4] := (cAliasSuper)->DISTANCIA
					EndIf

				EndIf
			EndIf

			_cmail:= Alltrim((cAliasSuper)->Z1Z_EMAIL)
			_cn03:= Alltrim((cAliasSuper)->Z1Q_PLACA)+' - '+Alltrim((cAliasSuper)->Z1Z_NOME)

			(cAliasSuper)->(dbskip())

		End
		If Len(_aMsg) > 1
			STWFR20(_aMsg,_cmail ,''  ,_cn03)
		EndIf
	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

Static Function ST20( _c01,_c02)


	Local cAlias20	:= 'ST20'
	Local cQuery    := ' '
	Local _nRet		:= 0

	cQuery := " SELECT
	cQuery += "   NVL(COUNT(*),0) AS NRET
	cQuery += "   FROM Z1B010 Z1B
	cQuery += "   INNER JOIN(SELECT * FROM SA3010)SA3
	cQuery += "   ON SA3.D_E_L_E_T_ = ' '
	cQuery += "   AND A3_COD = '"+_c01+"'
	cQuery += "   AND A3_CODUSR = Z1B_USUARI
	cQuery += "   WHERE Z1B.D_E_L_E_T_  = ' '
	cQuery += "   AND Z1B_DATA = '"+_c02+"'

	If Select(cAlias20) > 0
		(cAlias20)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias20)

	dbSelectArea(cAlias20)
	(cAlias20)->(dbgotop())
	If  Select(cAlias20) > 0
		_nRet:= (cAlias20)->NRET
	EndIf

	If Select(cAlias20) > 0
		(cAlias20)->(dbCloseArea())
	EndIf


Return(_nRet)
	*------------------------------------------------------------------*
Static Function STWFR20(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'Monitoramento de Veiculos: '+ Alltrim(_CodNF)
	Local cFuncSent		:= "STWFR20"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:= ' '


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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'


			Else
				_cDiaSe:=' '
				If CDOW(STOD(_aMsg[_nLin,3])) = 'Monday'
					_cDiaSe:='SEGUNDA-FEIRA'
				ElseIf CDOW(STOD(_aMsg[_nLin,3])) = 'Tuesday'
					_cDiaSe:='TERгA-FEIRA'
				ElseIf CDOW(STOD(_aMsg[_nLin,3])) = 'Wednesday'
					_cDiaSe:='QUARTA-FEIRA'
				ElseIf CDOW(STOD(_aMsg[_nLin,3])) = 'Thursday'
					_cDiaSe:='QUINTA-FEIRA'
				ElseIf CDOW(STOD(_aMsg[_nLin,3])) = 'Friday'
					_cDiaSe:='SEXTA-FEIRA'
				ElseIf CDOW(STOD(_aMsg[_nLin,3])) = 'Saturday'
					_cDiaSe:='SABADO'
				ElseIf CDOW(STOD(_aMsg[_nLin,3])) = 'Sunday'
					_cDiaSe:='DOMINGO'
				EndIf


				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + DTOC(STOD(_aMsg[_nLin,3]))+' - '+ _cDiaSe + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + CVALTOCHAR(_aMsg[_nLin,4]) + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'

			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado

			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)
Return()



User Function STWF21( )


	Local cAliasSuper	:= 'STWF21'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")




	cQuery := "  SELECT Z0_NUM, Z0_ANALIST,Z0_DESCRI,Z0_DTTERM
	cQuery += "   FROM SZ0010 SZ0
	cQuery += "   WHERE SZ0.D_E_L_E_T_ = ' '
	cQuery += "   AND (Z0_STATUS = '3' OR Z0_STATUS ='4')
	cQuery += "   AND Z0_TIPO = 'C'
	cQuery += "   AND (Z0_DTTERM = ' ' OR Z0_DTTERM <= '"+DTOS(DATE())+"')
	cQuery += "   ORDER BY Z0_ANALIST, Z0_NUM

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"Chamado","Analista","DescriГЦo","Vencimento"})

		_cVen:= ' '
		While 	(cAliasSuper)->(!Eof())

			aadd(_aMsg,{(cAliasSuper)->Z0_NUM,;
				(cAliasSuper)->Z0_ANALIST ,;
				(cAliasSuper)->Z0_DESCRI ,;
				DTOC(STOD((cAliasSuper)->Z0_DTTERM));
				}  )

			(cAliasSuper)->(dbskip())

		End
		If Len(_aMsg) > 1
			STWFR21(_aMsg,'',''  ,'')
		EndIf
	EndIf





	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


	*------------------------------------------------------------------*
Static Function STWFR21(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'Chamados Vencidos.'
	Local cFuncSent		:= "STWFR21"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:= ' '

	_cEmail  	:= "  EVERSON.SANTANA@STECK.COM.BR ; RENATO.OLIVEIRA@STECK.COM.BR ; JEFFERSON.CARLOS@STECK.COM.BR; felipe.souza@steck.com.br  "
	_cCopia  	:= ' '

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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'

			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)
Return()


User Function STWF22( )


	Local cAliasSuper	:= 'STWF22'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")




	cQuery := "  SELECT Z0_NUM, Z0_ANALIST,Z0_DESCRI,Z0_DTENTRE
	cQuery += "   FROM SZ0010 SZ0
	cQuery += "   WHERE SZ0.D_E_L_E_T_ = ' '

	cQuery += "   AND Z0_TIPO = 'C'
	cQuery += "   AND Z0_DTENTRE = '"+DTOS(DATE())+"'
	cQuery += "   ORDER BY Z0_ANALIST, Z0_NUM



	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"Chamado","Analista","DescriГЦo","Entregue"})

		_cVen:= ' '
		While 	(cAliasSuper)->(!Eof())

			aadd(_aMsg,{(cAliasSuper)->Z0_NUM,;
				(cAliasSuper)->Z0_ANALIST ,;
				(cAliasSuper)->Z0_DESCRI ,;
				DTOC(STOD((cAliasSuper)->Z0_DTENTRE));
				}  )

			(cAliasSuper)->(dbskip())

		End
		If Len(_aMsg) > 1
			STWFR22(_aMsg,'',''  ,'')
		EndIf
	EndIf





	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


	*------------------------------------------------------------------*
Static Function STWFR22(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'Chamados Entregues.'
	Local cFuncSent		:= "STWFR22"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:= ' '

	_cEmail  	:= "  EVERSON.SANTANA@STECK.COM.BR ; RENATO.OLIVEIRA@STECK.COM.BR ; JEFFERSON.CARLOS@STECK.COM.BR  "
	_cCopia  	:= '   '

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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'

			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)
Return()



User Function STWF23( )


	Local cAliasSuper	:= 'STWF23'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''

	Local nLineLength 	:= 232
	Local nTabSize 		:= 3
	Local lWrap 		:= .T.
	Local nCurrentLine	:= 0
	Local xText1 := ""


	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")        // Valdemir Rabelo 23/02/2022 - Chamado: 20220120001622
//	RpcSetEnv("01","02",,,"FAT")




	cQuery := "  SELECT
	cQuery += "  PD1_CODROM,PD1_DTEMIS,PD1_QTDVOL,PD1_PLIQ,PD1_PBRUTO,PD1_PLACA,PD1_STATUS,PD1_TPROM,PD1_HRROM, NVL(COUNT(PD2_NFS),0) AS NFS

//	cQuery += "  FROM PD1010 PD1
	cQuery += "  FROM " + RetSqlName("PD1") + " PD1

//	cQuery += "  LEFT JOIN(SELECT * FROM PD2010)PD2
	cQuery += "  LEFT JOIN(SELECT * FROM " + RetSqlName("PD2") + " PD2

	cQuery += "  ON PD2.D_E_L_E_T_ = ' '
	cQuery += "  AND PD2_FILIAL = PD1_FILIAL
	cQuery += "  AND PD2_CODROM = PD1_CODROM
	cQuery += "  WHERE PD1.D_E_L_E_T_ = ' '
	cQuery += "  AND PD1_FILIAL = '02'
	cQuery += "  AND PD1_STATUS <> '3'
	cQuery += "  AND PD1_DTEMIS <= '"+DTOS(DATE()-3)+"'
	cQuery += "  GROUP BY  PD1_CODROM,PD1_DTEMIS,PD1_QTDVOL,PD1_PLIQ,PD1_PBRUTO,PD1_PLACA,PD1_STATUS,PD1_TPROM,PD1_HRROM
	cQuery += "  ORDER BY PD1_DTEMIS,PD1_CODROM





	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)


	_cStatus:=' '
	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"Romaneio","EmissЦo","Volume","P.Liquido","P.Bruto","Placa","Status","Tipo","Hora","Notas","ObservaГЦo"})

		While 	(cAliasSuper)->(!Eof())
			_cStatus:=' '
			If (cAliasSuper)->PD1_STATUS = '0'
				_cStatus:='Nao iniciado'
			ElseIf (cAliasSuper)->PD1_STATUS = '1'
				_cStatus:='Em andamento'
			ElseIf (cAliasSuper)->PD1_STATUS = '2'
				_cStatus:='Fechado'
			ElseIf (cAliasSuper)->PD1_STATUS = '3'
				_cStatus:='Encerrado'
			EndIf

			_cTipo:=' '
			If (cAliasSuper)->PD1_TPROM = '1'
				_cTipo:='Entrega'
			ElseIf (cAliasSuper)->PD1_TPROM = '2'
				_cTipo:='Retira'
			EndIf

			nLines1 := 0
			nCurrentLine1 := 0


			nLines1 := MLCOUNT(POSICIONE("PD1", 1, xFilial("PD1") + (cAliasSuper)->PD1_CODROM, "PD1_OBS"), nLineLength, nTabSize, lWrap)

			FOR nCurrentLine := 1 TO nLines1

				xText1 := MEMOLINE(POSICIONE("PD1", 1, xFilial("PD1") + (cAliasSuper)->PD1_CODROM, "PD1_OBS"), nLineLength, nCurrentLine, nTabSize, lWrap)


			NEXT

			aadd(_aMsg,{(cAliasSuper)->PD1_CODROM,;
				DTOC(STOD((cAliasSuper)->PD1_DTEMIS)),;
				Transform((cAliasSuper)->PD1_QTDVOL,"@E 9,999") ,;
				Transform((cAliasSuper)->PD1_PLIQ,"@E 999,999,999.99") ,;
				Transform((cAliasSuper)->PD1_PBRUTO,"@E 999,999,999.99") ,;
				(cAliasSuper)->PD1_PLACA ,;
				_cStatus ,;
				_cTipo ,;
				Transform((cAliasSuper)->PD1_HRROM,"@R 99:99") ,;
				Transform((cAliasSuper)->NFS,"@E 9,999"),;
				xText1 ;
				}  )

			(cAliasSuper)->(dbskip())

		End
		If Len(_aMsg) > 1
			STWFR23(_aMsg,'',''  ,'')
		EndIf
	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


	*------------------------------------------------------------------*
Static Function STWFR23(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'Romaneios Logistica.'
	Local cFuncSent		:= "STWFR23"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:= ' '

	_cEmail  	:= "   KLEBER.BRAGA@steck.com.br;jefferson.puglia@steck.com.br;raphaella.silva@steck.com.br"
	_cCopia  	:= ' '


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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1


				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></TD>'

			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)
Return()



User Function STWF24( )


	Local cAliasSuper	:= 'STWF24'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	cQuery := "  SELECT
	cQuery += "   DISTINCT UB_PRODUTO,B1_DESC, B1_CLAPROD, B1_TIPO, BM_GRUPO||'-'||BM_DESC AS B1_GRUPO
	cQuery += "  FROM SUB010 SUB
	cQuery += "  INNER JOIN(SELECT * FROM SUA010)SUA
	cQuery += "  ON SUA.D_E_L_E_T_ = ' '
	cQuery += "  AND UA_NUM = UB_NUM
	cQuery += "  AND UA_FILIAL = UB_FILIAL
	cQuery += "  AND UA_EMISSAO > '"+DTOS(DATE()-30)+"'
	cQuery += "  INNER JOIN(SELECT * FROM SB1010)SB1
	cQuery += "  ON SB1.D_E_L_E_T_ = ' '
	cQuery += "  AND B1_COD = UB_PRODUTO
	cQuery += "  AND B1_DESC NOT LIKE '%UNID COMB%'
	cQuery += "  INNER JOIN(SELECT * FROM SBM010)SBM
	cQuery += "  ON SBM.D_E_L_E_T_ = ' '
	cQuery += "  AND BM_GRUPO = B1_GRUPO
	cQuery += "  WHERE SUB.D_E_L_E_T_ = ' '
	cQuery += "  AND UB_FILIAL = '02'
	cQuery += "  ORDER BY B1_TIPO,UB_PRODUTO

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)


	_cStatus:=' '
	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"Produto","DescriГЦo","Origem","Tipo","Grupo"})

		While 	(cAliasSuper)->(!Eof())

			If  U_STCUSTO(Alltrim((cAliasSuper)->UB_PRODUTO)) <= 0

				aadd(_aMsg,{Alltrim((cAliasSuper)->UB_PRODUTO),;
					Alltrim((cAliasSuper)->B1_DESC) ,;
					Alltrim((cAliasSuper)->B1_CLAPROD),;
					Alltrim((cAliasSuper)->B1_TIPO), ;
					Alltrim((cAliasSuper)->B1_GRUPO);
					}  )
			EndIf
			(cAliasSuper)->(dbskip())

		End
		If Len(_aMsg) > 1
			u_STWFR24(_aMsg,'',''  ,'')
		EndIf
	EndIf





	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()


	*------------------------------------------------------------------*
User Function STWFR24(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'Produtos sem Custo em OrГamentos de Vendas'
	Local cFuncSent		:= "STWFR24"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   "
	default _cCopia  	:= ' '

	_cEmail  	:=  "   reinaldo.franca@steck.com.br ; daniel.ribeiro@steck.com.br ; jadson.silva@steck.com.br ; mateus.ferreira@steck.com.br ; gisele.jesus@steck.com.br"
	_cCopia  	:=  "   "


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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1


				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'

			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)
Return()

	/*/{Protheus.doc}    WF Unicom em aberto

	@type function
	@author Everson Santana
	@since 08/02/19
	@version Protheus 12 - Faturamento

	@history ,Chamado 009047 ,

	/*/

User Function STWF25()

	Local cAliasSuper	:= 'STWF25'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''
	Local _cRepres		:= ''
	Local _cNomRep		:= ''

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	cQuery := " SELECT PP7_CODIGO,PP7_EMISSA,PP7_CLIENT,PP7_NOME,PP7_VEND,SA3.A3_NOME,PP7.PP7_REPRES,SA3R.A3_NOME NOMREP,   SA3R.A3_COD AS EMACOD, SA3R.A3_EMAIL AS EMAEXT,SA3S.A3_EMAIL AS EMASUP,
	cQuery += " (
	cQuery += " SELECT SUM(PP8_PRORC) PP8_PRORC FROM "+RetSqlName("PP8")
	cQuery += " WHERE  PP8_CODIGO = PP7_CODIGO
	cQuery += " AND D_E_L_E_T_ = ' '
	cQuery += " ) PP8_PRORC,
	cQuery += " (
	cQuery += " SELECT SUM(PP8_PRCOM) PP8_PRCOM FROM "+RetSqlName("PP8")
	cQuery += " WHERE  PP8_CODIGO = PP7_CODIGO
	cQuery += " AND D_E_L_E_T_ = ' '
	cQuery += " ) PP8_PRCOM
	cQuery += " FROM "+RetSqlName("PP7")+" PP7

	cQuery += " LEFT JOIN "+RetSqlName("SA3")+" SA3
	cQuery += " ON SA3.A3_COD = PP7.PP7_VEND
	cQuery += " AND SA3.D_E_L_E_T_ = ' '

	cQuery += " LEFT JOIN "+RetSqlName("SA3")+" SA3R
	cQuery += " ON SA3R.A3_COD = PP7.PP7_REPRES
	cQuery += " AND SA3R.D_E_L_E_T_ = ' '

	cQuery += " LEFT JOIN "+RetSqlName("SA3")+" SA3S
	cQuery += " ON SA3R.A3_SUPER = SA3S.A3_COD
	cQuery += " AND SA3S.D_E_L_E_T_ = ' '

	cQuery += " WHERE PP7_STATUS = '1'
	cQuery += " AND PP7_ZBLOQ <> '3' " //Ticket 20190729000012 - Everson Santana 31072019
	//cQuery += " AND PP7.PP7_REPRES = 'E00528' "//IN('C00003','E00317',' ') " //AND PP7_EMISSA >= '20180101'
	cQuery += " AND PP7.D_E_L_E_T_ = ' '

	cQuery += "  ORDER BY PP7.PP7_REPRES

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)

	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0

		_cRepres:= ' '

		While 	(cAliasSuper)->(!Eof())

			_cRepres := (cAliasSuper)->PP7_REPRES
			_cNomRep := (cAliasSuper)->NOMREP
			_aMsg	 := {}

			aadd(_aMsg,{"UNICOM","EMISSцO","CLIENTE","NOME","VLR ORгADO","VLR COMPRAS","INTERNO"})

			While 	(cAliasSuper)->(!Eof()) .AND. Alltrim((cAliasSuper)->PP7_REPRES) == Alltrim(_cRepres)

				aadd(_aMsg,{(cAliasSuper)->PP7_CODIGO,;
					Dtoc(Stod((cAliasSuper)->PP7_EMISSA)),;
					(cAliasSuper)->PP7_CLIENT,;
					Alltrim((cAliasSuper)->PP7_NOME),;
					Transform( (cAliasSuper)->PP8_PRORC ,"@E 999,999,999.99"), ;
					Transform( (cAliasSuper)->PP8_PRCOM ,"@E 999,999,999.99"), ;
					(cAliasSuper)->A3_NOME,;
					(cAliasSuper)->EMAEXT,;
					(cAliasSuper)->EMASUP,;
					(cAliasSuper)->EMACOD;
					}  )

				(cAliasSuper)->(dbskip())

			EndDo

			_cNomRep := _cRepres +" - "+_cNomRep

			If Len(_aMsg) > 1

				_cEmail:= ' '
				_cEmail:= IiF(Substr(_aMsg[2,10],1,1)= 'R' .And. !(_cRepres $ 'R00104/R00105')  ,_aMsg[2,09],_aMsg[2,08]+';'+_aMsg[2,09])
				STWFR25(_aMsg,_cEmail,''  ,_cNomRep)
			EndIf

			//(cAliasSuper)->(dbskip())

		EndDo

	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR25(_aMsg,_cEmail,_cCopia,_cNomRep)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'Unicom em Abertos : '+ IIf(Empty(SubStr(_cNomRep,1,6)),'Vendedor Externo NЦo Informado',_cNomRep)
	Local cFuncSent		:= "STWFR25"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "everson.santana@steck.com.br"
	default _cCopia  	:= 'FILIPE.NASCIMENTO@STECK.COM.BR;bruno.galvao@steck.com.br'

	_cCopia  	:= 'FILIPE.NASCIMENTO@STECK.COM.BR;bruno.galvao@steck.com.br'
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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'

			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		//_cEmail  	:= "FILIPE.NASCIMENTO@STECK.COM.BR"

		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado

			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)

Return()

/*/{Protheus.doc} STWF26

WF ITC

@type function
@author Jefferson Carlos
@since 02/04/19
@version Protheus 12 - Faturamento

@history ,Chamado 009047 ,

/*/

User Function STWF26( )

	Local cAliasSuper	:= 'STWF26'
	Local cQuery     	:= ' '
	Local _aMsg 	 	:= {}
	Local _cmail		:=  ''
	Local _cCop			:= ''

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")



	cQuery	+= " SELECT ZZ5_FILIAL, ZZ5_COD, ZZ5_NOMEOB,ZZ5_DTRETO,ZZ5_STATUS,A3_NOME NOMREP,ZZ5_ENDERE,ZZ5_ESTADO,A3_NOME NOMREP,trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(ZZ5_OBS, 2000,1))) Obs,  "
	cQuery	+= " NVL((SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=ZZ5_AREA ),' ') EMAIL1,"
	cQuery	+= " NVL((SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=(SELECT A3_SUPER FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD=ZZ5_AREA)),' ') EMAILSUP "
	cQuery	+= " FROM "+RetSqlName("ZZ5")+" Z5 "
	cQuery	+= " LEFT JOIN "+RetSqlName("SA3")+" A3 "
	cQuery	+= " ON A3_FILIAL=' ' AND A3_COD=ZZ5_AREA "
	cQuery	+= " WHERE Z5.D_E_L_E_T_=' ' AND A3.D_E_L_E_T_=' ' AND ZZ5_DTRETO=TO_CHAR(sysdate,'YYYYMMDD') "

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)
	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"Cod","Obra","Vendedor","EndereГo","UF","Obs","Status","Retorno"})
		_cVen:= ' '
		While 	(cAliasSuper)->(!Eof())
			_cStatus:=' '
			If (cAliasSuper)->ZZ5_STATUS = 'O'
				_cStatus:='Aguardando Visita'
			ElseIf (cAliasSuper)->ZZ5_STATUS = '1'
				_cStatus:='Somente Terreno'
			ElseIf (cAliasSuper)->ZZ5_STATUS = '2'
				_cStatus:='Limpeza do Terreno'
			ElseIf (cAliasSuper)->ZZ5_STATUS = '3'
				_cStatus:='Stand'
			ElseIf (cAliasSuper)->ZZ5_STATUS = '4'
				_cStatus:='Fundacao'
			ElseIf (cAliasSuper)->ZZ5_STATUS = '5'
				_cStatus:='Em Construcao'
			ElseIf (cAliasSuper)->ZZ5_STATUS = '6'
				_cStatus:='Obra Parada'
			ElseIf (cAliasSuper)->ZZ5_STATUS = '7'
				_cStatus:='Obra Pronta'
			ElseIf (cAliasSuper)->ZZ5_STATUS = '8'
				_cStatus:='Outros'
			ElseIf (cAliasSuper)->ZZ5_STATUS = '9'
				_cStatus:='Finalizado'
			EndIf

			aadd(_aMsg,{(cAliasSuper)->ZZ5_COD,;
				(cAliasSuper)->ZZ5_NOMEOB ,;
				(cAliasSuper)->NOMREP ,;
				(cAliasSuper)->ZZ5_ENDERE,;
				(cAliasSuper)->ZZ5_ESTADO,;
				(cAliasSuper)->Obs,;
				_cStatus,;
				DTOC(STOD((cAliasSuper)->ZZ5_DTRETO));
				}  )

			_cmail := (cAliasSuper)->EMAIL1+";"+(cAliasSuper)->EMAILSUP
			If Len(_aMsg) > 1
				STWFR26(_aMsg,_cmail,''  ,'')
			EndIf

			_aMsg := {}
			aadd(_aMsg,{"Cod","Obra","Vendedor","EndereГo","UF","Obs","Status","Retorno"})
			_cmail :=""
			(cAliasSuper)->(dbskip())

		End

	EndIf

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

Return()

	*------------------------------------------------------------------*
Static Function STWFR26(_aMsg,_cEmail,_cCopia,_CodNF)
	*------------------------------------------------------------------*

	Local aArea 		:= GetArea()
	Local _cFrom   		:= "protheus@steck.com.br"
	Local _cAssunto		:= 'Visitar Obra.'
	Local cFuncSent		:= "STWFR26"
	Local i        		:= 0
	Local cArq     		:= ""
	Local cMsg     		:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _nCam    		:= 0
	default _cEmail  	:= "   jefferson.carlos@steck.com.br"
	default _cCopia  	:= ' '

	//_cEmail  	:= "  EMAIL1;EMAILSUP   "
	_cCopia  	:= 'filipe.nascimento@steck.com.br;bruno.galvao@steck.com.br'

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
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1

				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></B></TD>'


			Else

				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></TD>'

			EndIf

		Next

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'



		If dow(date())<> 1  .And. dow(date())<> 7 //domingo ---- sabado
			U_STMAILTES(_cEmail , _cCopia, _cAssunto, cMsg,,,'   ')
		EndIf

	EndIf
	RestArea(aArea)
Return()



/*/{@Protheus.doc} getAliasBD
description
@type function
@version  25
@author Valdemir Rabelo
@since 27/01/2022
@return variant, Array
/*/
static Function getAliasBD(pAlias)
	Local aRET := {}

	// Colunas: 01=Alias BD - 02=Filial  - 03=Loja
	if     (cEmpAnt == '01')
	   aRET := {'UDBP12.'+RetSqlName(pAlias),'05','05'}
	elseif (cEmpAnt == '03')
	   aRET := {'UDBP12.'+RetSqlName(pAlias),'01','01'}
	elseif (cEmpAnt == '11')
	   aRET := {'UDBD11.'+RetSqlName(pAlias),'01','06'}
	endif 

Return aRET




/*==========================================================================
|Funcao    | FRSendMail          | FlАvia Rocha          | Data | 12/08/2015|
============================================================================
|Descricao | Envia um email                              				   | 
|                                   	  						           |
============================================================================
|ObservaГУes: GenИrico      											   |
==========================================================================*/
//FUNгцO FR PARA TESTES
Static Function FRSendMail(cMailTo, cCopia, cAssun, cCorpo, cAnexo )

//Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""


//Local cAccount	:= GetMV( "MV_RELACNT" )
//Local cPassword 	:= GetMV( "MV_RELPSW"  )
//Local cServer		:= GetMV( "MV_RELSERV" )
//Local cFrom		:= GetMV( "MV_RELACNT" )   


Local cAccount	:= "wfprotheus7@steck.com.br" 
Local cPassword := "Teste123"  
Local cServer	:= "smtp.office365.com"
Local cFrom		:= "wfprotheus7@steck.com.br"

/*
Local cAccount	:= "nfe_teste@hfbr.com.br" 	//GetMV( "MV_RELACNT" )    //nfe_teste@hfbr.com.br
Local cPassword := "hfbr2030" 				//GetMV( "MV_RELPSW"  )    //hfbr2030
Local cServer	:= "smtp.hfbr.com.br:587"	//GetMV( "MV_RELSERV" )
Local cFrom		:= "nfe_teste@hfbr.com.br" //GetMV( "MV_RELACNT" )   //relatorio@premierpescados.com.br                                     
*/

//Local cAttach 	:= cAnexo

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	//MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.
	MailAuth( cAccount, cPassword ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//Msgbox("E-mail nЦo enviado...")	
	//else
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult .And. lEnviado )

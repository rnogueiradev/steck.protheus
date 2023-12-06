#INCLUDE "PROTHEUS.CH" 
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"
#DEFINE CR    chr(13)+chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºFun‡„o    M110STTS     Autor ³ Giovani.Zago       º Data ³  04/08/15   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDescri‡„o ³ M110STTS							                          º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±± 20210701011385															±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

********************************************
Alterado em Data.....: 14/10/2021
Analista.: Marcelo Klopfer Leme
Chamado..: 20211005020998
*********************************************

/*/
*----------------------------------------*
User Function M110STTS()
	*----------------------------------------*
	Local cNumSol	:= Paramixb[1]
	Local nOpt		:= Paramixb[2]
	Local cRot 		:= ' '
	Local aEma 		:= {}
	Local _cSolic    := ''//Chamado 002612 - Automatizar Solicitação de Compras
	Local cEx        := ''
	Local _cMsg      := ''
	Local _cAltSC	:= .T.
	Local cExAd     := ""
	Local lServ 	:= .T.
	local cPafFil   := SuperGetMv("ST_M110FIL",.F.,"01") 
    local cPafEMP   := SuperGetMv("ST_M110EMP",.F.,"11") 

	If !AllTrim(FUNNAME()) $ "MATA712" .OR. !AllTrim(FUNNAME()) $ "U_MATA712" .OR. !AllTrim(FUNNAME()) $ "JOBM712"
		cExAd	:= UsrRetMail(RetCodUsr())
	EndIf

	/********************************************
	Alteração: Retirado a condição de Inclusão para o tratamento da alteração da Data de Previsão (C1_DATPRF)
	.........: Conforme solitado pelo usuário Rodrigo Ferreira a data não deve sofrer altração da data gerada pelo sistema durante
	.........: a geração da Solicitação de Compra.
	Analista.: Marcelo Klopfer Leme
	Chamado..: 20211005020998
	Data.....: 14/10/2021
	If INCLUI .or. ALTERA // Chamado Giovani Zago
	*********************************************/


	If ALTERA // Chamado Giovani Zago
		Dbselectarea("SC1")
		SC1->(Dbsetorder(1))
		If SC1->(dbseek(xfilial("SC1")+cNumSol))
			Dbselectarea("SZ1")
			Dbsetorder(1)
			If SZ1->(dbseek(xfilial("SZ1")+SC1->C1_MOTIVO))
				IF SZ1->Z1_NOMES = "S"

					IF Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO,"B1_ORIGEM") <> "1"
						If SC1->C1_DATPRF <> CTOD("  /  /  ")
						
							dData1	 := (LastDate( SC1->C1_DATPRF )+1)     //
							If ALTERA
								_cAltSC := MSGYESNO( "Deseja alterar a Data de Necessidade da Solicit�o de Compras?"+ Chr(13) + Chr(10) + Chr(13) + Chr(10) +" Data Atual: "+dtoC(SC1->C1_DATPRF) +" (NÃO) "+ Chr(13) + Chr(10) + Chr(13) + Chr(10) +" Nova Data: "+dtoc(dData1)+" (SIM) ", "Alteração" )

							EndIf
						//<<
						else
							_cAltSC := .F.	
						EndIf
						If _cAltSC
							While SC1->(!EOF()) .And. cNumSol = SC1->C1_NUM .And. SC1->C1_FILIAL = xfilial("SC1")

								Reclock("SC1",.F.)
								SC1->C1_DATPRF:= dData1
								SC1->(MsUnlock())

								SC1->(dBSkip())
							End
						EndIf
					EndIf
				Endif
			Endif
		Endif
	EndIf
	//>>20200723004584 - Everson Santana - 27.07.2020

	If INCLUI
		If cEmpAnt=="03" //20201126011250

			Dbselectarea("SC1")
			SC1->(Dbsetorder(1))
			SC1->(DbGoTop())
			If SC1->(dbseek(xfilial("SC1")+cNumSol))

				While SC1->(!EOF()) .And. cNumSol = SC1->C1_NUM .And. SC1->C1_FILIAL = xfilial("SC1")

					If Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO,"B1_IMPORT") = "S" .AND. alltrim(SC1->C1_MOTIVO) $ ("SAO#MRP#MAO")

						Reclock("SC1",.F.)
						SC1->C1_COTACAO := ""
						SC1->C1_IMPORT  := ""
						SC1->(MsUnlock())

					EndIF

					SC1->(dBSkip())
				End

			EndIf

		EndIf

	EndIf


	//<<20200723004584

	do case
	case nOpt == 1
		cRot 		:= 'Inclusão de Solicitação de Compra('+cNumSol+')'
	case nOpt == 2
		cRot 		:= 'Alteração de Solicitação de Compra('+cNumSol+')'
	case nOpt == 3
		cRot 		:= 'Exclusão de Solicitação de Compra('+cNumSol+')'
	endcase

	If !(Empty(Alltrim(cRot)))

		Dbselectarea("SC1")
		SC1->(Dbsetorder(1))
		If SC1->(dbseek(xfilial("SC1")+cNumSol))
			_cSolic := SC1->C1_USER//Chamado 002612 - Automatizar Solicitação de Compras
			aadd(aEma,{"Solicitação",cNumSol})
			aadd(aEma,{"Usuario",cUserName})
			aadd(aEma,{"Data",dtoc(dDataBase)})
			aadd(aEma,{"Hora",substr(time(),1,5)})

			aadd(aEma,{"Produto","Quantidade"})
			While SC1->(!EOF()) .And. cNumSol = SC1->C1_NUM .And. SC1->C1_FILIAL = xfilial("SC1")
				SC1->(RecLock("SC1",.F.))
				IF !EMPTY(SC5->C5_XUSER) // Rotina de beneficiamento
					cEx:=SuperGetMV( "ST_XEMABEN",, ""  )
				ENDIF

				//>> Chamado 006693
				If !Empty(cEx) .AND. !Empty(cExAd)
					SC1->C1_XEMAIL 		:= cEx+";"+cExAd
				ElseIf Empty(cEx) .AND. !Empty(cExAd)
					SC1->C1_XEMAIL 		:= cExAd
				ElseIf !Empty(cEx) .AND. Empty(cExAd)
					SC1->C1_XEMAIL 		:= cEx
				Else
					SC1->C1_XEMAIL 		:= cEx
				EndIF
				//<<Chamado 006693

				if SC1->C1_MOTIVO = "IMP" // Chamado 006121.
					cEx := SC1->C1_XEMAIL
				ENDIF

				If !empty(SC1->C1_SEQMRP)  .and. cEmpAnt$cPafEMP   .and. SC1->C1_FILIAL$cPafFil 
					SC1->C1_ZSTATUS := '3'
					SC1->C1_ZDTAPRO := DDATABASE
					SC1->C1_ZHRAPRO := TIME()
					
					_cStatus := 'Aprovado Automaticamente'
					_cMsg += "===================================" +CHR(13)+CHR(10)
					_cMsg += "Aprovação automática autorizada pela Gerência Industrial"
					_cMsg += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
					SC1->C1_ZLOG    := SC1->C1_ZLOG + CHR(13)+ CHR(10) + _cMsg
				end If

				IF SC1->C1_MOTIVO = "APU"
					SC1->C1_ZSTATUS := '3'
					//>>Chamado 006694
					SC1->C1_ZDTAPRO := DDATABASE
					SC1->C1_ZHRAPRO := TIME()
					//<<
					_cStatus := 'Aprovado Pelo Gestor'
					_cMsg += "===================================" +CHR(13)+CHR(10)
					_cMsg += "Aprovação automática autorizada pela Gerência Industrial"
					_cMsg += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
					SC1->C1_ZLOG    := SC1->C1_ZLOG + CHR(13)+ CHR(10) + _cMsg

				ENDIF
				SC1->(MsUnlock())
				aadd(aEma,{ Alltrim(SC1->C1_PRODUTO)+" - "+ Alltrim(SC1->C1_DESCRI),cvaltochar(SC1->C1_QUANT) })
				//>> Ticket 20210429006930 - Everson Santana - 07.05.2021
				If Alltrim(SubStr(SC1->C1_PRODUTO,1,4)) $ "SERV" .and. lServ
					If Empty(cEx)
						cEx := "silvana.silva@steck.com.br"
					else
						cEx += ";silvana.silva@steck.com.br"
					EndIF

					lServ := .F.

				EndIf
				//<< Ticket 20210429006930
				SC1->(dBSkip())
			EndDo
			U_PCEMAIL(cRot,aEma,cEx)
			U_STCOM019(cNumSol,nOpt,_cSolic)//Chamado 002612 - Automatizar Solicitação de Compras
		EndIf
	EndIf
Return ()
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
	±±ºFun‡„o    MT110TEL     Autor ³ Giovani.Zago       º Data ³  04/08/15   º±±
	±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
	±±ºDescri‡„o ³ MT110TEL 						                          º±±
	±±º          ³                                                            º±±
	±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	*----------------------------------------*
User Function MT110TEL()
	*----------------------------------------*
	Local oNewDialog := PARAMIXB[1]
	Local aPosGet    := PARAMIXB[2]
	Local nOpcx      := PARAMIXB[3]
	Local nReg       := PARAMIXB[4]
	Local _nTotal	 := 0
	Local _nTam 	:= 0
	Public cExAd	     := Iif(!Inclui,SC1->C1_XEMAIL,SPACE(100))

	_nTotal	:= STGETTOT()
	_nTam 		:= 100 - Len(UsrRetMail(RetCodUsr()))
	If Inclui
		cExAd 		:= UsrRetMail(RetCodUsr())+Space(_nTam)
	Else
		cExAd	     := Iif(!Inclui,SC1->C1_XEMAIL,SPACE(100))
	EndIf
	@ 63,aPosGet[2,1] SAY 'Email ' PIXEL SIZE 20,9 Of oNewDialog
	@ 62,aPosGet[2,2] MSGET cExAd PIXEL SIZE 150,08 Of oNewDialog

	@ 63,aPosGet[2,3] SAY 'Total: ' + Transform(_nTotal,"@E 999,999,999.99") PIXEL SIZE 100,9 Of oNewDialog

RETURN

	/*====================================================================================\
	|Programa  | PCEMAIL          | Autor | GIOVANI.ZAGO             | Data | 10/04/2015  |
	|=====================================================================================|
	|Descrição | PCEMAIL                                                                  |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | PCEMAIL                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*------------------------------------------------------------------*
User Function PCEMAIL(_cObs,_axcols,cEx)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= _cObs
	Local cFuncSent:= "PCEMAIL"
	Local _aMsg    := _axcols
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ' '
	Local cAttach  := ''

	Local _cEmail  := cEx

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
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'

		If !(Empty(Alltrim(_cEmail)))
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)
		EndIf
	EndIf
	RestArea(aArea)
Return()

Static Function STGETTOT()

	Local _nVal		:= 0
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"

	cQuery1	 := " SELECT SUM(QUANT*VALOR) TOTAL "
	cQuery1	 += " FROM ( "
	cQuery1  += " SELECT C1_QUANT QUANT, "
	cQuery1  += " (SELECT MAX(A5_VLCOTUS) FROM "+RetSqlName("SA5")+" A5 WHERE A5.D_E_L_E_T_=' '
	cQuery1  += " AND A5.A5_FORNECE=C1.C1_FORNECE AND C1.C1_LOJA=A5.A5_LOJA AND C1.C1_PRODUTO=A5.A5_PRODUTO) VALOR "
	cQuery1  += " FROM "+RetSqlName("SC1")+" C1 "
	cQuery1  += " WHERE C1.D_E_L_E_T_=' ' AND C1_FILIAL='"+SC1->C1_FILIAL+"' AND C1_NUM='"+SC1->C1_NUM+"' ) "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->(!Eof())
		_nVal	:= (cAlias1)->TOTAL
	EndIf

Return(_nVal)

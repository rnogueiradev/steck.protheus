#INCLUDE "RWMAKE.CH"
#Include "Colors.ch"
#include 'Protheus.ch'

#Define CR chr(13)+chr(10)



/*====================================================================================\
|Programa  | MTA450R          | Autor | GIOVANI.ZAGO             | Data | 29/08/2018  |
|=====================================================================================|
|Descriзгo | MTA450R                                                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MTA450R                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histуrico....................................|
|Chamado - 008755 - Ajustado para Argentina - Everson Santana - 16.01.2019			  |
\====================================================================================*/
*-----------------------------*
User Function MTA450R()
	*-----------------------------*
	Local cPedido     := SC9->C9_PEDIDO
	Local cFilSC9     := xFilial("SC9")
	Local cInd        := "1"
	Local cGetMotivo  := Space(80)
	Local nOpcao      := 0
	Local lRetorno    := .T.
	Local lBrowser    := .F.
	Local lSaida      := .f.
	Local _aMotRej    := {}
	Local _cItem      := '001'
	Local _cc5Mail		:= ' '
	Local _cVendEx	  := ' '
	Local _cCopia  	:= " "

	DbSelectArea("SX5")
	SX5->(dbSetOrder(1))
	SX5->(dbSeek(xFilial("SX5") + 'ZS'))
	Do While SX5->(!EOF()) .and. xFilial("SX5") = SX5->X5_FILIAL .And. SX5->X5_TABELA  = 'ZS'
		AADD(_aMotRej,ALLTRIM(SX5->X5_CHAVE)+' - '+ALLTRIM(SX5->X5_DESCRI))
		SX5->(DbSkip())
	EndDo
	DbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1") + SC9->C9_CLIENTE + SC9->C9_LOJA))
	cObsFin := ""
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5")+cPedido))
		If Empty(Alltrim( SC5->C5_ZMOTREJ ) )
			Do While !lSaida
				nOpcao := 0

				Define msDialog oDxlg Title "Rejeitando Pedido " From 10,10 TO 260,600 Pixel

				@ 010,010 say "Pedido  " COLOR CLR_BLACK  Of oDxlg Pixel
				@ 020,010 say "Cliente " COLOR CLR_BLACK  Of oDxlg Pixel

				@ 010,050 get cPedido  when .f. size 050,08  Of oDxlg Pixel
				@ 020,050 get SA1->A1_COD when .f. size 120,08  Of oDxlg Pixel

				@ 050,010 say "Observaзгo da Rejeiзгo" COLOR CLR_HBLUE  Of oDxlg Pixel
				@ 060,010 get cGetMotivo valid !empty(cGetMotivo) size 165,08  Of oDxlg Pixel


				@ 080,010 Say "Motivo da Rejeiзгo:"   COLOR CLR_HBLUE  Of oDxlg Pixel
				@ 090,010 COMBOBOX _cItem ITEMS _aMotRej SIZE 110,50 Of oDxlg Pixel

				DEFINE SBUTTON FROM 102,130 TYPE 1 ACTION IF(!empty(cGetMotivo),(lSaida:=.T.,nOpcao:=1,oDxlg:End()),msgInfo("Motivo da rejeiзгo do pedido nгo preenchido","Atenзгo")) ENABLE OF oDxlg

				Activate dialog oDxlg centered

			EndDo

			If nOpcao == 1

				DbSelectArea("SC5")
				SC5->(DbSetOrder(1))
				SC5->(DbSeek(xFilial("SC5")+cPedido))

				_cVendEx := SC5->C5_VEND1

				Reclock("SC5",.F.)
				SC5->C5_ZMOTREJ:= alltrim(cGetMotivo)+' - '+ _cItem +' - '+cusername+' - '+dtoc(date())+' - '+time()
				SC5->C5_ZDTREJE:= Date()
				SC5->C5_XSTAFIN  := 'R'
				SC5->(MsUnLock())
				SC5->( DbCommit() )


				DbSelectArea("SA3")
				DbSetOrder(1)
				DbGotop()
				If DbSeek(xFilial("SA3")+_cVendEx)
					_cCopia := SA3->A3_EMAIL
				EndIF

				_cc5Mail := GetMv("ST_LIBPED",,"everson.santana@steck.com.br")

				u_ArLibFinMail(alltrim(cGetMotivo),_cItem,cusername,dtoc(date()),time(),_cc5Mail,'Rechazo',_cCopia)

			EndIf
		EndIf
	EndIf
	Return(lRetorno)



	/*====================================================================================\
	|Programa  | ArLibFinMail     | Autor | GIOVANI.ZAGO             | Data | 27/03/2013  |
	|=====================================================================================|
	|Descriзгo | ArLibFinMail                                                             |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | ArLibFinMail                                                             |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histуrico....................................|
	\====================================================================================*/
	*------------------------------------------------------------------*
User Function  ArLibFinMail(_cObs,_cMot,_cName,_cDat,_cHora,_cEmail,_cTipe,_cCopia)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   	:= "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto	:= '[WFPROTHEUS] - '+_cTipe+' de la Pedido de Venta ('+SC5->C5_NUM +')'
	Local cFuncSent	:= "ArLibFinMail"
	Local _aMsg    	:={}
	Local i        	:= 0
	Local cArq     	:= ""
	Local cMsg     	:= ""
	Local _nLin

	Local cAttach  	:= ''
	Local _nValBase	:= 0
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"
	Local _nSaldo	:= 0

	cQuery1	 := " SELECT A1_COD,A1_LOJA,NVL(	(	SELECT	SUM(E1_SALDO) SALDOSUB 	FROM	SE1070 E1 	WHERE E1.D_E_L_E_T_=' ' AND E1_CLIENTE=A1_COD AND
	cQuery1	 += " 					E1_LOJA=A1_LOJA AND					E1_TIPO= 'NF' AND					E1_FILIAL= '01'			),0)
	cQuery1	 += ' "ABERTO",
	cQuery1	 += " NVL(	(	SELECT					SUM(E1_SALDO) SALDOSUB 				FROM
	cQuery1	 += " 					SE1070 E1 				WHERE					E1.D_E_L_E_T_=' ' AND					E1_CLIENTE=A1_COD AND
	cQuery1	 += " 					E1_LOJA=A1_LOJA AND					E1_TIPO= 'NCC' AND					E1_FILIAL= '01'			),0)
	cQuery1	 += ' "CREDITO"
	cQuery1	 += " FROM "+RetSqlName("SA1")+" SA1 WHERE SA1.D_E_L_E_T_ = ' ' AND A1_COD ='"+SC5->C5_CLIENTE+"'  AND A1_LOJA = '"+SC5->C5_LOJACLI+"'

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	_nSaldo	:= (cAlias1)->ABERTO-(cAlias1)->CREDITO

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		Aadd( _aMsg , { "Pedido: "          , SC5->C5_NUM } )
		Aadd( _aMsg , { "Cliente - Loja: "  , SC5->C5_CLIENTE+' - '+SC5->C5_LOJACLI } )
		Aadd( _aMsg , { "Nome Cliente: "    , substr(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"),1,35)  } )
		Aadd( _aMsg , { "Avalista: "    	, _cName+" "+DTOC(DDATABASE)+" "+TIME() } ) //chamado 008899 - Everson Santana - 23.01.219
		Aadd( _aMsg , { "Razуn: "    		, SC5->C5_ZMOTREJ } )

		//ЪДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДї
		//і Definicao do cabecalho do email                                             і
		//АДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДЩ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ЪДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДї
		//і Definicao do texto/detalhe do email                                         і
		//АДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДЩ
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
		//ЪДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДї
		//і Definicao do rodape do email                                                і
		//АДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДЩ
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

		U_ARMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

	EndIf
	RestArea(aArea)
Return()
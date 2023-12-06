#Include "RWMake.ch"
#Include "Colors.ch"
#include "Protheus.ch"

#Define CR Chr(13) + Chr(10)

/*====================================================================================\
|Programa  | MTA450R          | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição | MTA450R                                                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MTA450R                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MTA450R()

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
	Local _cc5Mail	  := ' '

	dbSelectArea("SX5")
	SX5->( dbSetOrder(1) )
	SX5->( dbSeek(xFilial("SX5") + 'ZS') )
	Do While SX5->( !Eof() ) .And. xFilial("SX5") == SX5->X5_FILIAL .And. SX5->X5_TABELA == 'ZS'
		aAdd(_aMotRej,Alltrim(SX5->X5_CHAVE) + ' - ' + Alltrim(SX5->X5_DESCRI))
		SX5->( dbSkip() )
	EndDo

	dbSelectArea("SA1")
	SA1->( dbSetOrder(1) )
	SA1->( dbSeek(xFilial("SA1") + SC9->C9_CLIENTE + SC9->C9_LOJA) )
	cObsFin := ""
	
	dbSelectArea("SC5")
	SC5->( dbSetOrder(1) )
	If SC5->( dbSeek(xFilial("SC5") + cPedido) )
		//If Empty(Alltrim( SC5->C5_ZMOTREJ ) ) -> Alterado em 13/06/2013 por João Victor para permitir que o financeiro realize a rejeição de um pedido rejeitado anteriormente a fim de que seja possível alterar o motivo da nova rejeição.
		If Empty(Alltrim( SC5->C5_ZMOTREJ ) )
			Do While !lSaida
				nOpcao := 0
				Define msDialog oDxlg Title "Rejeitando Pedido " From 10,10 TO 260,600 Pixel
				@ 010,010 say "Pedido  " COLOR CLR_BLACK  Of oDxlg Pixel
				@ 020,010 say "Cliente " COLOR CLR_BLACK  Of oDxlg Pixel
				@ 010,050 get cPedido  when .f. size 050,08  Of oDxlg Pixel
				@ 020,050 get SA1->A1_COD when .f. size 120,08  Of oDxlg Pixel
				@ 050,010 say "Observação da Rejeição" COLOR CLR_HBLUE  Of oDxlg Pixel
				@ 060,010 get cGetMotivo valid !empty(cGetMotivo) size 165,08  Of oDxlg Pixel
				@ 080,010 Say "Motivo da Rejeição:"   COLOR CLR_HBLUE  Of oDxlg Pixel
				@ 090,010 COMBOBOX _cItem ITEMS _aMotRej SIZE 110,50 Of oDxlg Pixel
				DEFINE SBUTTON FROM 102,130 TYPE 1 ACTION If(!Empty(cGetMotivo),(lSaida := .T.,nOpcao := 1,oDxlg:End()), MsgInfo("Motivo da rejeição do pedido não preenchido","Atenção")) ENABLE OF oDxlg
				Activate dialog oDxlg centered
			EndDo
			If nOpcao == 1
				dbSelectArea("SC5")
				SC5->( dbSetOrder(1) )
				SC5->( dbSeek(xFilial("SC5") + cPedido) )
				Reclock("SC5",.F.)
				SC5->C5_ZMOTREJ := Alltrim(cGetMotivo) + ' - ' + _cItem + ' - ' + cUserName + ' - ' + DtoC(Date()) + ' - ' + Time()
				SC5->C5_ZDTREJE := Date()
				//Incluído em 20/04/2013 por João Victor para tratamento de legenda de Pedido de Venda.
				If SC5->C5_ZFATBLQ = '3'
					SC5->C5_ZFATBLQ  := ''
				EndIf
				SC5->( MsUnLock() )
				SC5->( dbCommit() )
				If Empty(Alltrim(SC5->C5_PEDEXP))
					_cc5Mail := Alltrim(Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND2,"A3_EMAIL")) + " ; " + Alltrim(Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND1,"A3_EMAIL")) + " ; " + Alltrim(Posicione("SA3",1,xFilial("SA3") + (Alltrim(Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND1,"A3_SUPER"))),"A3_EMAIL"))
				Else
					_cc5Mail := GetMv("ST_EXMAIL",,'')
				EndIf
				u_StLibFinMail(Alltrim(cGetMotivo),_cItem,cUserName,DtoC(Date()),Time(),_cc5Mail,'Rejeição')
			EndIf
		EndIf
	EndIf

Return lRetorno

/*====================================================================================\
|Programa  | StLibFinMail     | Autor | GIOVANI.ZAGO             | Data | 27/03/2013  |
|=====================================================================================|
|Descrição | StLibFinMail                                                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | StLibFinMail                                                             |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function StLibFinMail(_cObs,_cMot,_cName,_cDat,_cHora,_cEmail,_cTipe)

	Local aArea 	:= GetArea()
	//Local _cFrom   	:= "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto	:= 'Financeiro - ' + _cTipe + ' do PV (' + SC5->C5_NUM + ') ' + Alltrim(Substr(_cObs,1,At("-",_cObs) - 1))	// Alltrim(_cMot)
	Local cFuncSent	:= "StLibFinMail"
	Local _aMsg    	:= {}
	//Local i        	:= 0
	//Local cArq     	:= ""
	Local cMsg     	:= ""
	Local _nLin
	//Local _cCopia  	:= " davi.souza@steck.com.br;gleice.freitas@steck.com.br;jonathan.silva@steck.com.br " //Ticket 20200929008103
	Local _cCopia   := ""    //FR - 07/06/2022 - Alteração mediante ticket #20220401007117 - retirar email e colocar em parâmetro os endereços que recebem
	Local cAttach  	:= ''
	Local _nValBase	:= 0
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"
	Local _nSaldo	:= 0 
	Local _cMailAdd1:= ""
	Local _cMailAdd2:= ""
	Local _cMailOrig:= ""

	Default _cEmail  := ""  //"davi.souza@steck.com.br"

	//---------------------------------------------------------------------------------------------------//
	//FR - 07/11/2022 - TICKET #20220112000949 - David Souza solicitou que quando o motivo da rejeição
	//for 001 - CONSULTANDO SERASA, mostrar o motivo no assunto do email
	//Flávia Rocha - Sigamat Consultoria
	//---------------------------------------------------------------------------------------------------//
	If "SERASA" $ UPPER(_cMot)  	
		_cAssunto	:= 'Financeiro - ' + _cMot + ' -  do PV (' + SC5->C5_NUM + ') ' + Alltrim(Substr(_cObs,1,At("-",_cObs) - 1))	// Alltrim(_cMot)
	Endif 
	//FR - 07/11/2022 - TICKET #20220112000949
	//---------------------------------------------------------------------------------------------------//
	
	_cEmail := Alltrim(_cEmail)  //este email vem com os endereços de email dos vendedores 

	//FR - 07/06/2022 - Alteração mediante ticket #20220401007117 - retirar email do Jonathan e colocar em parâmetro os endereços que recebem
	_cMailOrig := GetNewPar("STPVREJEI1" , "david.souza@steck.com.br")    
	_cCopia    := GetNewPar("STPVREJEI2" , "david.souza@steck.com.br;gleice.freitas@steck.com.br;eduardo.santos@steck.com.br;yara.bilio@steck.com.br")  
	_cMailAdd1 := GetNewPar("STPVREJEI3", "FILIPE.NASCIMENTO@STECK.COM.BR;BRUNO.GALVAO@STECK.COM.BR")
	_cMailAdd2 := GetNewPar("STPVREJEI3", "FILIPE.NASCIMENTO@STECK.COM.BR")
	_cEmail    += ";" + _cMailOrig
	//FR - 07/06/2022 - Alteração mediante ticket #20220401007117 - retirar email do Jonathan e colocar em parâmetro os endereços que recebem

	// Valdemir Rabelo 03/01/2021 - Trocado de SA1010 para RetSqlName("SA1") - Ticket: 20220103000070
	cQuery1	 := " SELECT A1_COD,A1_LOJA,NVL(	(	SELECT	SUM(E1_SALDO) SALDOSUB 	FROM	" + RetSqlName("SE1") + " E1 	WHERE E1.D_E_L_E_T_=' ' AND E1_CLIENTE=A1_COD AND
	cQuery1	 += " 					E1_LOJA=A1_LOJA AND					E1_TIPO= 'NF' AND					E1_FILIAL= '01'			),0)
	cQuery1	 += ' "ABERTO",
	cQuery1	 += " NVL(	(	SELECT					SUM(E1_SALDO) SALDOSUB 				FROM
	cQuery1	 += " 	" + RetSqlName("SE1") + "  E1 				WHERE					E1.D_E_L_E_T_=' ' AND					E1_CLIENTE=A1_COD AND
	cQuery1	 += " 					E1_LOJA=A1_LOJA AND					E1_TIPO= 'NCC' AND					E1_FILIAL= '01'			),0)
	cQuery1	 += ' "CREDITO"
	cQuery1	 += " FROM "+RetSqlName("SA1")+" SA1 WHERE SA1.D_E_L_E_T_ = ' ' AND A1_COD ='" + SC5->C5_CLIENTE + "'  AND A1_LOJA = '" + SC5->C5_LOJACLI + "' "
	If !Empty(Select(cAlias1))
		dbSelectArea(cAlias1)
		(cAlias1)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())
	_nSaldo	:= (cAlias1)->ABERTO-(cAlias1)->CREDITO

	If ( Type("l410Auto") == "U" .Or. !l410Auto )
		aAdd( _aMsg , { "Pedido: "          , SC5->C5_NUM } )
		aAdd( _aMsg , { "Cond. Pgto.: "     , SC5->C5_CONDPAG+" - "+Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI") } )
		aAdd( _aMsg , { "Cliente - Loja: "  , SC5->C5_CLIENTE+' - '+SC5->C5_LOJACLI } )
		aAdd( _aMsg , { "Nome Cliente: "    , substr(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"),1,35)  } )
		aAdd( _aMsg , { "Dt. Emissão : "    , DTOC(SC5->C5_EMISSAO)})
		aAdd( _aMsg , { "Dt. "+_cTipe+": "    , _cDat  } )
		aAdd( _aMsg , { "Primeira compra: " , DTOC(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_PRICOM"))  } ) //Chamado 003197
		aAdd( _aMsg , { "Última compra: " 	, DTOC(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_ULTCOM"))  } ) //Chamado 003197
		aAdd( _aMsg , { "Motivo: "    		, _cMot  } )
		aAdd( _aMsg , { "Observação: "    	, _cObs  } )
		aAdd( _aMsg , { "Avalista: "    	, _cName } )
		aAdd( _aMsg , { "Hora: "    		, _cHora } )
		aAdd( _aMsg , { "CNPJ: "    		, Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CGC") } )
		aAdd( _aMsg , { "Total Liq.: " 		, iif(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")= 'EX', 'USD ',"R$ ") +;
			cValToChar(Transform(SC5->C5_ZVALLIQ,"@E 999,999,999.99"))})
		aAdd( _aMsg , { "NS.: "    			, SA1->A1_XNSEG } )  //cvaltochar(ROUND(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XSEGVAL"),0)) } )
		dbSelectArea("SC6")
		SC6->( dbSetOrder(1) )
		IF SC6->( dbSeek(xFilial("SC6") + SC5->C5_NUM) )
			While SC6->( !Eof() ) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM
				U_STLOGFIN(SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRCVEN,SC6->C6_QTDVEN,.F.,.F.)
				_nValBase += SC6->(C6_VALOR+(C6_ZVALIPI*C6_QTDVEN)+(C6_ZVALIST*C6_QTDVEN))
				SC6->( dbSkip() )
			End
		EndIf
		aAdd( _aMsg , { "Total Bruto: " 	, "R$ " + cValToChar(Transform(_nValBase,"@E 999,999,999.99")) 	} )
		aAdd( _aMsg , { "Saldo: "		 	, "R$ " + cValToChar(Transform(_nSaldo,"@E 999,999,999.99"))		} )

		// Definicao do cabecalho do email
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - " + SM0->M0_NOME + "/" + SM0->M0_FILIAL + '</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto + " - " + SM0->M0_NOME + "/" + SM0->M0_FILIAL + '</FONT> </Caption>'
		// Definicao do texto/detalhe do email
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
		// Definicao do rodape do email
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: ' + Dtoc(date()) + '-' + Time() + '  - <font color="red" size="1">(' + cFuncSent + ')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'
		If Substr(AllTrim(Posicione("SA1",1,xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_NOME")),1,3) == 'MRV' .Or. Substr(AllTrim(Posicione("SA1",1,xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_NREDUZ")),1,3) == 'MRV'
			
			//FR - 07/06/2022 - Alteração mediante ticket #20220401007117 - retirar email do Jonathan e colocar em parâmetro os endereços que recebem
			//_cCopia+= ' ; FILIPE.NASCIMENTO@STECK.COM.BR;BRUNO.GALVAO@STECK.COM.BR'
			_cCopia += ";" + Alltrim(_cMailAdd1)
			//FR - 07/06/2022 - Alteração mediante ticket #20220401007117 - retirar email do Jonathan e colocar em parâmetro os endereços que recebem
			
		EndIf
		//> Chamado 008802 - Everson Santana - 21.01.2019
		If SC5->C5_VEND1 $ "E00317#E00493#E00517#E00519" .Or. SC5->C5_VEND2 $ "I08569#I08588#I08598#I08595"
		 	
		 	//FR - 07/06/2022 - Alteração mediante ticket #20220401007117 - retirar email do Jonathan e colocar em parâmetro os endereços que recebem
		 	//_cCopia+= ' ; FILIPE.NASCIMENTO@STECK.COM.BR'
		 	_cCopia += ";" + Alltrim(_cMailAdd2)
		 	//FR - 07/06/2022 - Alteração mediante ticket #20220401007117 - retirar email do Jonathan e colocar em parâmetro os endereços que recebem
		 	
		EndIF
		//<<
		If SC5->C5_FILIAL == "04" 
		
			//FR - 07/06/2022 - Alteração mediante ticket #20220401007117 - retirar email do Jonathan e colocar em parâmetro os endereços que recebem
			//_cEmail := "davi.souza@steck.com.br;jonathan.silva@steck.com.br"//Ticket 20210201001641 - Everson Santana - 01.02.2021
			_cEmail := _cMailOrig
			//FR - 07/06/2022 - Alteração mediante ticket #20220401007117 - retirar email do Jonathan e colocar em parâmetro os endereços que recebem
			_cCopia := ""
		EndIf

		//_cEmail += ";flah.rocha@sigamat.com.br"   //RETIRAR
		//_cAssunto += " >> TESTE !!! << "			//RETIRAR

	   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

	EndIf

	RestArea(aArea)

Return

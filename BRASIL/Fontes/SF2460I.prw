#include 'Protheus.ch'
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³SF2460I   ºAutor  ³FlexProjects        º Data ³  30/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada apos gravacao da nota de saida.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SF2460I()

	Local aArea        := GetArea()
	Local aAreaSC5 := SC5->(GetArea())
	Local aAreaSA1 := SA1->(GetArea())
	Local aAreaSD2 := SD2->(GetArea())
	Local aAreaCB7 := CB7->(GetArea())
	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()

	Local cUltTipoExp
	Local nX         := 0
	Local nQtdeVol   := 0
	Local aOrdSep    := {}
	Local aVolume    := {}
	Local lPIN       := .F.

	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := ""
	Local cMsg		:= ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''
	Local cEST      := ''
	Local cCid      := ''
	//  Ticket: 20210318004396 - Valdemir Rabelo 07/06/2021
	Local aEstCid  := {;
		{'Rio Preto da Eva','AM'},;
		{'Manaus','AM'},;
		{'Presidente Figueiredo','AM'},;
		{'Tabatinga','AM'},;
		{'Boa Vista','RR'},;
		{'Bonfim','RR'},;
		{'Pacaraima','RR'},;
		{'Macapa','AP'},;
		{'Santana','AP'},;
		{'Cruzeiro do Sul','AC'},;
		{'Brasileia','AC'},;
		{'Epitaciolandia','AC'},;
		{'Guajara-mirim','RO'}}

	aEval(aEstCid, {|X| cEST += Upper(X[2]+",") })
	aEval(aEstCid, {|X| cCid += UPPER(X[1]+",") })
	cEST := Substr(cEST,1,Len(cEST)-1)
	cCid := Substr(cCid,1,Len(cCid)-1)

	If cEmpAnt = '03'
		If SUBSTR(Alltrim(SF2->F2_HORA),1,2) = SUBSTR(Alltrim(time()),1,2)
			SF2->(RecLock("SF2",.F.))
			SF2->F2_HORA :=  PADL(CVALTOCHAr(VAL(SUBSTR(Alltrim(SF2->F2_HORA),1,2))-1),2,'0')+SUBSTR(Alltrim(SF2->F2_HORA),3,3)
			SF2->(MsUnlock())
			SF2->(DbCommit())
		EndIF
	EndIf
	SD2->(DbSetOrder(3))
	If ! SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
		Return
	Endif

	//Ticket 20190506000039
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(SD2->(D2_FILIAL+D2_PEDIDO)))

		DbSelectArea("ZS3")
		ZS3->(DbSetOrder(2))
		If ZS3->(DbSeek(SC5->(C5_FILIAL+C5_NUM)))
			If Empty(ZS3->ZS3_NOTAFI)
				RecLock("ZS3", .f. )
				ZS3->ZS3_NOTAFI := SF2->F2_DOC
				MsUnlock()
			EndIf
		EndIf

		If AllTrim(SC5->C5_XORIG)=="2"
		
			DbSelectArea("SE1")
			SE1->(DbSetOrder(2)) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			SE1->(DbSeek(SF2->(F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DOC)))
			While SE1->(!Eof()) .And. SF2->(F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DOC)==SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
			
				SE1->(RecLock("SE1",.F.))
				SE1->E1_XORIG 	:= SC5->C5_XORIG
				SE1->E1_XCANAL	:= SC5->C5_XCANAL
				SE1->E1_XIDAFIL := SC5->C5_XIDAFIL
				SE1->E1_XNMAFIL	:= SC5->C5_XNMAFIL
				SE1->(MsUnLock())
			
				SE1->(DbSkip())
			EndDo
			
			DbSelectArea("Z76")
			Z76->(DbSetOrder(1)) //Z76_FILIAL+Z76_PEDPAI+Z76_PEDFIL
			DbSelectArea("ZH2")
			ZH2->(DbSetOrder(3))
			
			Z76->(DbSeek(xFilial("Z76")+SC5->C5_XNUMWEB))
			While Z76->(!Eof()) .And. Z76->(Z76_FILIAL+Z76_PEDPAI)==xFilial("Z76")+SC5->C5_XNUMWEB
		
				If !ZH2->(DbSeek(xFilial("ZH2")+Z76->Z76_PEDFIL+"2"))
					ZH2->(RecLock("ZH2",.T.))
					ZH2->ZH2_FILIAL := xFilial("ZH2")
					ZH2->ZH2_DTINS	:= Date()
					ZH2->ZH2_HRINS  := Time()
					ZH2->ZH2_TIPO 	:= "2"
					ZH2->ZH2_PEDMKP	:= Z76->Z76_PEDFIL
					ZH2->ZH2_PEDERP := SC5->C5_NUM
					ZH2->ZH2_DOC	:= SF2->F2_DOC
					ZH2->ZH2_SERIE	:= SF2->F2_SERIE
					ZH2->(MsUnLock())
				EndIf
				
			Z76->(DbSkip())
			EndDo
			
		EndIf

		If !Empty(SC5->C5_XPEDTRI)

			_cQuery1 := " SELECT F2_ESPECI1, F2_VOLUME1, F2_PLIQUI, F2_PBRUTO
			_cQuery1 += " FROM "+RetSqlName("SF2")+" F2
			_cQuery1 += " LEFT JOIN "+RetSqlName("SD2")+" D2
			_cQuery1 += " ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE
			_cQuery1 += " AND D2_LOJA=F2_LOJA "
			_cQuery1 += " WHERE F2.D_E_L_E_T_=' ' AND D2.D_E_L_E_T_=' '
			_cQuery1 += " AND D2_FILIAL='"+SC5->C5_FILIAL+"' AND D2_PEDIDO='"+SC5->C5_XPEDTRI+"'

			If !Empty(Select(_cAlias1))
				DbSelectArea(_cAlias1)
				(_cAlias1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

			dbSelectArea(_cAlias1)

			(_cAlias1)->(dbGoTop())

			If (_cAlias1)->(!Eof())

				SF2->(RecLock("SF2",.F.))
				SF2->F2_ESPECI1 := (_cAlias1)->F2_ESPECI1
				SF2->F2_VOLUME1 := (_cAlias1)->F2_VOLUME1
				SF2->F2_PLIQUI  := (_cAlias1)->F2_PLIQUI
				SF2->F2_PBRUTO  := (_cAlias1)->F2_PBRUTO
				SF2->(MsUnlock())

			EndIf

		EndIf
	EndIf

	While ! SD2->(EOF()) .and. xFilial("SD2")  == SD2->D2_FILIAL;
	.and. SD2->D2_DOC     == SF2->F2_DOC;
	.and. SD2->D2_SERIE   == SF2->F2_SERIE;
	.and. SD2->D2_CLIENTE == SF2->F2_CLIENTE ;
	.and. SD2->D2_LOJA    == SF2->F2_LOJA

		SC9->(DbSetOrder(7))
		If SC9->(DbSeek(xFilial("SC9")+SD2->D2_COD+SD2->D2_LOCAL+SD2->D2_NUMSEQ)) .And. SC9->C9_NFISCAL+SC9->C9_SERIENF == SF2->F2_DOC+SF2->F2_SERIE
			If !Empty(SC9->C9_ORDSEP)
				aadd(aOrdSep,{SC9->C9_ORDSEP,SC9->C9_ITEM,SD2->D2_PEDIDO})
			EndIf
		EndIf

		RecLock("SD2",.f.)
		SD2->D2_ORDSEP := SC9->C9_ORDSEP
		SD2->(MsUnlock())

		DbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If		SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD ))

			If SB1->B1_XR01  = '1'
				Dbselectarea('SB2')
				SB2->(DbSetOrder(1))
				If	SB2->(DbSeek(xfilial("SB2") + SB1->B1_COD +'03'))

					If	0 =	(SB2->B2_QATU - (U_STResSDC(SB2->B2_COD) + u_STSldPV(SB2->B2_COD,cFilAnt))-SB2->B2_QACLASS)
						//	If	 	 SB2->B2_QATU <=0
						RecLock("SB1",.F.)
						SB1->B1_MSBLQL := '1'
						SB1->(MsUnLock())

					EndIf

				EndIf
			EndIf
		EndIf
		//Adicionar checagem de codigo FCI conforme solicitação da Veronica - Vitor Merguizo 22/07/2015 
		If Substr(SD2->D2_CLASFIS,1,1)$"358" .And. Empty(SD2->D2_FCICOD)
			RecLock("SD2",.f.)
			SD2->D2_FCICOD := U_STGETFCI(SD2->D2_COD)
			MsUnlock()
		EndIf


		//u_LOGJORPED("SD2","7",SD2->D2_COD,SD2->D2_ITEM,SD2->D2_PEDIDO,"","Geracao NF")

		// incluir aqui rotina para numero do romaneio

		SD2->(DbSkip())
	Enddo

	U_STGRPNF(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE)
	U_STVPPN(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE) //GRAVA DESCONTO DE CLIENTE EX.: LEROY PARA A CONTABILIZAÇÃO

	If Empty(aOrdSep)
		Return
	EndIf

	For nX := 1 to Len(aOrdSep)
		CB7->(DbSetOrder(1))
		If ! CB7->(DBSeek(xFilial('CB7')+aOrdSep[nX][1]))
			MsgBox("OS: "+aOrdSep[nX][1]+" nao encontrada na tabela de ordem de separação, Verifique !!!","Aviso","OK")
			Return
		EndIf

		RecLock("CB7",.F.)
		CB7->CB7_NOTA  := SF2->F2_DOC
		CB7->CB7_SERIE := SF2->F2_SERIE
		CB7->(MsUnLock())

	Next

	U_STKVLFAT(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE)

	//Giovani Zago  18/05/13 Item 060  da  MIT006  ----grava peso e volume corretos pelo total das oredens de separação
	U_STGRPESVLO(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE)

	// Valdemir Rabelo 20/01/2022  - Chamado: 20220119001493
	If cEmpAnt$"01#11" .And. cFilAnt $ "01#02#04" .And. SA1->A1_CGC=="33000167105558" //Chamado 002489

		_cEmail	:= "francisco.smania@steck.com.br;wellington.gamas@steck.com.br;guilherme.fernandez@steck.com.br "
		_cAssunto := "[STECK] - NF "+AllTrim(SF2->F2_DOC)+" - Petroleo Brasileiro S/A"
		cMsg := ""
		cMsg += '<html><head><title></title></head><body>'
		cMsg += '<b>NF: </b>'+Alltrim(SF2->F2_DOC)+' </body></html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

	EndIf

	//Chamado 004252 giovani zago 01/08/2016
	// Valdemir Rabelo 20/01/2022  - Chamado: 20220119001493
	If cEmpAnt=="01#11" .And. cFilAnt $ "01#02#04" .And. Alltrim(SA1->A1_CGC) $ ("03439316000172/03439316000687/03439316006880/03439316004089/03439316007002/03439316007185")

		_cEmail	:= "francisco.smania@steck.com.br;wellington.gamas@steck.com.br;guilherme.fernandez@steck.com.br "
		_cAssunto := "[STECK] - NF "+AllTrim(SF2->F2_DOC)+" - CONSTRUDECOR / COD.23789"
		cMsg := ""
		cMsg += '<html><head><title></title></head><body>'
		cMsg += '<b>NF: </b>'+Alltrim(SF2->F2_DOC)+' </body></html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

	EndIf
	//Chamado 008170 - Everson Santana
	// Valdemir Rabelo 20/01/2022  - Chamado: 20220119001493
	If cEmpAnt=="11" .And. cFilAnt $ "01" .And. Alltrim(SF2->F2_CLIENTE) $ ("080667")

		_cEmail	:= "wellington.gamas@steck.com.br;francisco.smania@steck.com.br "
		_cAssunto := "[STECK] - NF "+AllTrim(SF2->F2_DOC)+" - CLIENTE: "+ SA1->A1_NOME
		cMsg := ""
		cMsg += '<html><head><title></title></head><body>'
		cMsg += '<b>NF: </b>'+Alltrim(SF2->F2_DOC)+' </body></html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

	EndIf

	//>>Ticket 20200827006465  - Everson Santana
	// Valdemir Rabelo 20/01/2022  - Chamado: 20220119001493
	If cEmpAnt=="11" .And. cFilAnt $ "01" .And. Alltrim(SF2->F2_CLIENTE) $ ("006596")

		_cEmail	:= "  francisco.smania@steck.com.br;leandro.nobre@steck.com.br;wellington.gamas@steck.com.br"
		_cAssunto := "EMBARCAR NF "+AllTrim(SF2->F2_DOC)+" - CLIENTE: "+ SA1->A1_NOME
		cMsg := ""
		cMsg += '<html><head><title></title></head><body>'
		cMsg += '<b>NF: </b>'+Alltrim(SF2->F2_DOC)+'<br>
		cMsg += '<b>Pedido: </b>'+Alltrim(SD2->D2_PEDIDO)+'<br>
		cMsg += '<b>OS: </b>'+Alltrim(SD2->D2_ORDSEP)+'<br>
		cMsg += '<b>Cliente: </b>'+Alltrim(SA1->A1_NOME)+'<br>
		cMsg += '<b>Tranportadora: </b>'+Alltrim(SF2->F2_TRANSP)+'<br>
		cMsg += '<b>Peso Bruto: </b>'+TransForm(SF2->F2_PBRUTO,PesqPict("SF2","F2_PBRUTO"))+'<br>
		cMsg += '<b>Volume: </b>'+TransForm(SF2->F2_VOLUME1,PesqPict("SF2","F2_VOLUME1"))+'<br>
		cMsg += '</body></html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

	EndIf
	//<<Ticket 20200827006465

	//Chamado 006899 giovani zago 16/05/2018
	// Valdemir Rabelo 20/01/2022  - Chamado: 20220119001493
	If cEmpAnt=="01#11" .And. cFilAnt $ "01#02#04" .And. Alltrim(SA1->A1_COD) $ ("005958")

		_cEmail	:= "francisco.smania@steck.com.br;wellington.gamas@steck.com.br;guilherme.fernandez@steck.com.br;carla.lodetti@steck.com.br "
		_cAssunto := "[STECK] - NF "+AllTrim(SF2->F2_DOC)+" - CLIENTE: "+ SA1->A1_NOME
		cMsg := ""
		cMsg += '<html><head><title></title></head><body>'
		cMsg += '<b>NF: </b>'+Alltrim(SF2->F2_DOC)+' </body></html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

	EndIf

	// Valdemir Rabelo 20/01/2022  - Chamado: 20220119001493
	If (cFilAnt == '01') .and. (cEmpAnt <> '03')                  // Valdemir Rabelo 18/05/2022
		//StartJob("U_STWF07",GetEnvServer(), .F.,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_DOC,SF2->F2_SERIE)
		U_STWF07(SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_DOC,SF2->F2_SERIE)
	EndIf

	//Ticket 20191002000014
	// Valdemir Rabelo 20/01/2022  - Chamado: 20220119001493
	If cEmpAnt=="11" .And. cFilAnt="01"
		If AllTrim(SF2->F2_EST)=="EX"

			_cEmail	:= GetMv("STWFPEDEX",,"leandro.nobre@steck.com.br")
			_cAssunto := "[STECK] - NF "+AllTrim(SF2->F2_DOC)+" de exportação foi faturada
			cMsg := ""
			cMsg += '<html><head><title></title></head><body>'
			cMsg += '<b>NF: </b>'+Alltrim(SF2->F2_DOC)+'<br>
			cMsg += '<b>Pedido: </b>'+Alltrim(SD2->D2_PEDIDO)+'<br>
			cMsg += '<b>OS: </b>'+Alltrim(SD2->D2_ORDSEP)+'<br>
			cMsg += '<b>Cliente: </b>'+Alltrim(SA1->A1_NOME)+'<br>
			cMsg += '<b>Tranportadora: </b>'+Alltrim(SF2->F2_TRANSP)+'<br>
			cMsg += '</body></html>'

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

		EndIf
		// Valdemir Rabelo - Regra de Declaração 20/02/2020
		if (ALLTRIM(SA1->A1_ATIVIDA)=="E3") .AND. (ALLTRIM(SF2->F2_EST) == 'MS')    // Removido E5 e adicionado E3 - Valdemir Rabelo Ticket: 20210318004396
			IF (SF2->(FieldPos("F2_XDECLA")) > 0)
				RecLock("SF2", .F.)
				SF2->F2_XDECLA := "S"
				MsUnlock()
			Else
				FWMsgRun(,{|| sleep(3000)},"Atenção!","Campo: F2_XDECLA não foi criado. Informe o setor de TI")
			Endif
		Endif
		//Adicionar Regra PIN - 07/06/2021 - Ticket: 20210318004396 
		lPIN := (alltrim(SA1->A1_MUN) $ cCid) .and. (alltrim(SA1->A1_EST) $ cEST)
		if lPIN
			IF (SF2->(FieldPos("F2_XPIN")) > 0)
				RecLock("SF2", .F.)
				SF2->F2_XPIN := "S"
				MsUnlock()
			Else
				FWMsgRun(,{|| sleep(3000)},"Atenção!","Campo: F2_XPIN não foi criado. Informe o setor de TI")
			Endif
		Endif 
	EndIf

	u_LOGJORPED("SD2","7"," "," ",SD2->D2_PEDIDO,"","Geracao NF",SF2->F2_VALBRUT)

	If GetMv("STFAT3621",,.F.)
		U_STFAT362()
	EndIf

	RestArea(aAreaSD2)
	RestArea(aAreaCB7)
	RestArea(aAreaSC5)
	RestArea(aAreaSA1)
	RestArea(aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STKVLFAT  ºAutor  ³ Vitor Merguizo     º Data ³  05/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida os itens da nota fiscal com o pedido liberado e se- º±±
±±º          ³ paração (SD2 x SC9 x CB9)                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STKVLFAT(cFil,cNota,cSerie)

	Local cQuery	:= ""
	Local cAlias	:= "QRYDIF"
	Local cMostra	:= "br_verde"
	Local lDiverg	:= .F.
	Local aDiver    := {}           // Valdemir Rabelo 22/01/2021 - Ticket: 20210115000826
	Local nX        := 0
	Private cCadastro := "Divergencia de Quantidades"
	Private oDlg
	Private oGetDados1

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	cQuery	:= " SELECT FILIAL, PEDIDO, ITEM, COD, B1_DESC, SUM(QTD_D2) QTD_D2, SUM(QTD_C9) QTD_C9, SUM(QTD_SEP) QTD_SEP, SUM(QTD_EMB) QTD_EMB FROM ( "
	cQuery	+= " SELECT D2_FILIAL FILIAL, D2_PEDIDO PEDIDO, D2_ITEMPV ITEM, D2_COD COD, SUM(D2_QUANT) QTD_D2, 0 QTD_C9, 0 QTD_SEP, 0 QTD_EMB "
	cQuery	+= " FROM "+RetSqlName("SD2")+" SD2 "
	cQuery	+= " WHERE "
	cQuery	+= " D2_FILIAL = '"+cFil+"' AND "
	cQuery	+= " D2_DOC = '"+cNota+"' AND "
	cQuery	+= " D2_SERIE = '"+cSerie+"' AND "
	cQuery	+= " SD2.D_E_L_E_T_= ' ' "
	cQuery	+= " GROUP BY D2_FILIAL,D2_PEDIDO, D2_ITEMPV, D2_COD "
	cQuery	+= " UNION ALL "
	cQuery	+= " SELECT C9_FILIAL FILIAL, C9_PEDIDO, C9_ITEM, C9_PRODUTO, 0 QTD_D2, SUM(C9_QTDLIB)QTD_C9, 0 QTD_SEP, 0 QTD_EMB "
	cQuery	+= " FROM "+RetSqlName("SC9")+" SC9 "
	cQuery	+= " WHERE "
	cQuery	+= " C9_FILIAL = '"+cFil+"' AND "
	cQuery	+= " C9_NFISCAL = '"+cNota+"' AND "
	cQuery	+= " C9_SERIENF = '"+cSerie+"' AND "
	cQuery	+= " SC9.D_E_L_E_T_= ' ' "
	cQuery	+= " GROUP BY C9_FILIAL,C9_PEDIDO, C9_ITEM, C9_PRODUTO "
	cQuery	+= " UNION ALL "

	/* GIOVANI ZAGO ESTA DUPLICANDO A CB9
	cQuery	+= " SELECT CB8_FILIAL FILIAL, CB8_PEDIDO, CB8_ITEM, CB8_PROD, 0 QTD_D2, 0 QTD_C9, SUM(CB9_QTESEP)QTD_SEP, SUM(CB9_QTEEMB)QTD_EMB "
	cQuery	+= " FROM "+RetSqlName("CB8")+" CB8 "
	cQuery	+= " INNER JOIN "+RetSqlName("CB9")+" CB9 ON "
	cQuery	+= " CB8_FILIAL = CB9_FILIAL AND CB8_ORDSEP = CB9_ORDSEP AND CB8_PROD = CB9_PROD AND CB8_ITEM = CB9_ITESEP AND CB9.D_E_L_E_T_= ' ' "
	cQuery	+= " WHERE "
	cQuery	+= " CB8_FILIAL = '"+cFil+"' AND "
	cQuery	+= " CB8_ORDSEP IN ( "
	cQuery	+= " SELECT DISTINCT(C9_ORDSEP)  "
	cQuery	+= " FROM "+RetSqlName("SC9")+" SC9 "
	cQuery	+= " WHERE "
	cQuery	+= " C9_FILIAL = '"+cFil+"' AND "
	cQuery	+= " C9_NFISCAL = '"+cNota+"' AND "
	cQuery	+= " C9_SERIENF = '"+cSerie+"' AND "
	cQuery	+= " SC9.D_E_L_E_T_= ' ' "
	cQuery	+= " ) AND CB8.D_E_L_E_T_= ' ' "
	cQuery	+= " GROUP BY CB8_FILIAL,CB8_PEDIDO, CB8_ITEM, CB8_PROD "
	cQuery	+= " )XXX "
	*/

	//____________________________________________________________________________________________________________________________________________________________________________________________
	cQuery	+= " SELECT   CB9_FILIAL FILIAL, CB9_PEDIDO, CB9_ITESEP, CB9_PROD, 0 QTD_D2, 0 QTD_C9, SUM(CB9_QTESEP)QTD_SEP, SUM(CB9_QTEEMB)QTD_EMB  "
	cQuery	+= " FROM "+RetSqlName("CB9")+" CB9      "
	cQuery	+= " WHERE          "
	cQuery	+= " CB9_FILIAL =  '"+cFil+"'
	cQuery	+= " AND  CB9_ORDSEP IN (
	cQuery	+= " SELECT DISTINCT(C9_ORDSEP)
	cQuery	+= " FROM   "+RetSqlName("SC9")+" SC9 "
	cQuery	+= " WHERE
	cQuery	+= " C9_FILIAL = '"+cFil+"' AND "
	cQuery	+= " C9_NFISCAL = '"+cNota+"' AND "
	cQuery	+= " C9_SERIENF = '"+cSerie+"' AND "
	cQuery	+= " SC9.D_E_L_E_T_= ' '   )

	cQuery	+= " AND EXISTS  (SELECT * FROM "+RetSqlName("CB8")+" CB8  WHERE CB8_FILIAL = CB9_FILIAL AND CB8_ORDSEP = CB9_ORDSEP AND CB8_PROD = CB9_PROD AND CB8_ITEM = CB9_ITESEP  AND CB8.D_E_L_E_T_= ' '  )
	cQuery	+= " AND CB9.D_E_L_E_T_= ' ' AND CB9.CB9_VOLUME<>' '
	cQuery	+= " GROUP BY CB9_FILIAL,CB9_PEDIDO, CB9_ITESEP, CB9_PROD    ) XXX
	//____________________________________________________________________________________________________________________________________________________________________________________________

	cQuery	+= " LEFT JOIN "+RetSqlName("SB1")+" SB1 ON COD = B1_COD AND SB1.D_E_L_E_T_= ' ' "
	cQuery	+= " GROUP BY FILIAL,PEDIDO, ITEM, COD, B1_DESC "
	cQuery	+= " ORDER BY FILIAL,PEDIDO, ITEM "

	//cQuery	:= ChangeQuery(cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)

	TcSetField(cAlias,"QTD_D2"	, 	"N",TamSx3("D2_QUANT")[1]	, TamSx3("D2_QUANT")[2])
	TcSetField(cAlias,"QTD_C9"	, 	"N",TamSx3("C9_QTDLIB")[1]	, TamSx3("C9_QTDLIB")[2])
	TcSetField(cAlias,"QTD_SEP"	, 	"N",TamSx3("CB9_QTESEP")[1]	, TamSx3("CB9_QTESEP")[2])
	TcSetField(cAlias,"QTD_EMB"	, 	"N",TamSx3("CB9_QTEEMB")[1]	, TamSx3("CB9_QTEEMB")[2])

	aHeader := {}
	aCols	:= {}

	Aadd(aHeader,{" ",				"XX_LEGEND"	,"@BMP",2,0,".F.","€€€€€€€€€€€€€€€","C","","V","","","","V"})
	aAdd(aHeader,{"Filial",			"XX_FILIAL"	,"@!",TamSx3("D2_FILIAL")[1],0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(aHeader,{"Pedido",			"XX_PEDIDO"	,"@!",TamSx3("D2_PEDIDO")[1],0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(aHeader,{"Item",			"XX_ITEM"	,"@!",TamSx3("D2_ITEMPV")[1],0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(aHeader,{"Produto",		"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(aHeader,{"Descricao",		"XX_DESC"	,"@!",TamSx3("B1_DESC")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(aHeader,{"Qtd. Nota",		"XX_QTDD2"	,"@E 999,999",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(aHeader,{"Qtd. Lib.",		"XX_QTDC9"	,"@E 999,999",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(aHeader,{"Qtd. Sep.",		"XX_QTDSEP"	,"@E 999,999",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(aHeader,{"Qtd. Emb.",		"XX_QTDEMP"	,"@E 999,999",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})

	DbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	While (cAlias)->(!Eof())

		If Round((cAlias)->QTD_D2,0)=Round((cAlias)->QTD_C9,0).And.Round((cAlias)->QTD_D2,0)=Round((cAlias)->QTD_SEP,0).And.Round((cAlias)->QTD_D2,0)=Round((cAlias)->QTD_EMB,0)
			cMostra := "br_verde"
		Else
			cMostra := "br_vermelho"
			lDiverg := .T.
			aAdd(aDiver, (cAlias)->PEDIDO)				// Valdemir Rabelo 22/01/2021 - Ticket: 20210115000826
		Endif

		aAdd(aCols,Array(len(aHeader)+1))
		aCols[Len(aCols),01] 	:= cMostra
		aCols[Len(aCols),02] 	:= (cAlias)->FILIAL
		aCols[Len(aCols),03]	:= (cAlias)->PEDIDO
		aCols[Len(aCols),04]	:= (cAlias)->ITEM
		aCols[Len(aCols),05]	:= (cAlias)->COD
		aCols[Len(aCols),06]	:= (cAlias)->B1_DESC
		aCols[Len(aCols),07]	:= (cAlias)->QTD_D2
		aCols[Len(aCols),08]	:= (cAlias)->QTD_C9
		aCols[Len(aCols),09]	:= (cAlias)->QTD_SEP
		aCols[Len(aCols),10]	:= (cAlias)->QTD_EMB
		aCols[Len(aCols),Len(aHeader)+1] := .F.
		(cAlias)->(dbSkip())
	EndDo

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	If Len(aCols) == 0
		aAdd(aCols,Array(len(aHeader)+1))
	EndIf

	If lDiverg .and. SC5->(FieldPos("C5_XDIVERG") > 0)     // FiedPos adicionado Valdemir 18/02/2022 - Chamado: 20220218004063
	    // Aponto bloqueios na SC5 por existencia de divergencias - Valdemir Rabelo 22/01/2021 - Ticket: 20210115000826
		if (Len(aDiver) > 0)     
		   For nX := 1 to Len(aDiver)
		       SC5->( dbSetOrder(1))
			   if SC5->( dbSeek(xFilial('SC5')+aDiver[nX]) )
			      RecLock('SC5',.F.)
				  SC5->C5_XDIVERG := 'DIV'
				  MsUnlock()
			   endif 
		   Next 
		Endif 
		//-----------------------------------------------------------
		If !IsBlind()      // Valdemir Rabelo 18/05/2022
		MsgAlert("Ocorreram divergencias nas quantidades do pedido!!!")
		else 
		   Conout("Ocorreram divergencias nas quantidades do pedido!!!")
		endif 
		U_StFatMail('',' ',cusername,dtoc(date()),time(),' ',aCols)//Giovani.zago 29/05/13

	Else
		Return
	EndIf

	If !IsBlind()      // Valdemir Rabelo 18/05/2022
	//-- Dimensoes padroes
	aSize    := MsAdvSize(, .F., 400)
	aInfo 	 := {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	aObjects := {{100, 100,.T.,.T. }}
	aPosObj := MsObjSize( aInfo, aObjects,.T. )
	nStyle := GD_UPDATE
	nOpca		:= 0
	acpos		:= {"XX_QTDD2","XX_QTDC9","XX_QTDSEP","XX_QTDEMB"}
	aButtons	:= {}

	Define MSDialog oDlg Title cCadastro From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel

	oGetDados1 := MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nStyle,"AllWaysTrue","AllWaysTrue","",acpos,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,aHeader,aCols)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End() },{||oDlg:End()},,aButtons)

	// se a opcao for encerrar executa a rotina.
	If nOpca == 1

	EndIf

	Endif

Return

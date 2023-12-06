#include 'Protheus.ch' 
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STLIBERPED          | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  STLIBERPED    Liberação de regra                                           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STLIBERPED                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STLIBERPED()
	*-----------------------------*
	Local aArea          := GetArea()
	Local _Lmomat        := IsInCallSteck("U_STFAT15")
	Local _nQtVal        := 0
	Local lCredito       := .T.
	Local _lEnvia		 := .F.
	Local _cConPag      := GetMv("ST_STTS01",,"501")
	Local _cBlOper      := GetMv("ST_STTS03",, '19')
	Private _lPilha		:= .F.
	Private _lEdi		  := .F.
	Private cEmailFor	  := ""
	PRIVATE _nXmargSf7    := 0
	PRIVATE oPrint
	PRIVATE _cNomeCom     := SM0->M0_NOMECOM
	PRIVATE _cEndereco    := SM0->M0_ENDENT
	PRIVATE cCep          := SM0->M0_CEPENT
	PRIVATE cCidade       := SM0->M0_CIDENT
	PRIVATE cEstado       := SM0->M0_ESTENT
	PRIVATE cCNPJ         := SM0->M0_CGC
	PRIVATE cTelefone     := SM0->M0_TEL
	PRIVATE cFax          := SM0->M0_FAX
	PRIVATE cResponsavel  := Alltrim(MV_PAR04)
	PRIVATE cIe           := Alltrim(SM0->M0_INSC)
	PRIVATE _nTotPed      := 0
	PRIVATE	nAliqICM      := 0
	PRIVATE	nValICms      := 0
	PRIVATE nCnt          := 0
	PRIVATE	nAliqIPI      := 0
	PRIVATE	nValIPI       := 0
	PRIVATE	nValICMSST    := 0
	PRIVATE	nValSuf    	  := 0
	PRIVATE	nValPis       := 0
	PRIVATE	nValCof	      := 0
	PRIVATE _cxCliContr   := "SA1->A1_GRPTRIB"
	PRIVATE _cCliEst      := "SA1->A1_EST"
	PRIVATE _cTipoCli 	  := "SC5->C5_TIPOCLI"
	PRIVATE		cCopia    := Alltrim(Lower(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_EMAIL")))
	PRIVATE		titulo	  := "Envio de E-Mail Pedido de Venda nº: " + SC5->C5_NUM + " - STECK INDÚSTRIA ELÉTRICA"
	PRIVATE cBmpName  	  :=''
	PRIVATE cStartPath 	  := '\arquivos\pedido\'//GetSrvProfString("Startpath","") +'orcamento\'
	PRIVATE _cPath		  := GetSrvProfString("RootPath","") //GetPvProfString( GetEnvServer(), "RootPath"	, "", GetAdv97() )
	PRIVATE _cNomePdf     :=''
	Private _cDirRel      := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private _lxRet        := .T.

	/***********************************************************************************************************************
	<<<ALTERAÇÃO>>>
	Ação.........: Retirada a chamada de impressão da Static function xImpress() para chamar a impressão do pedido
	.............: que está validada RSTFAT09.PRW 
	.............: Desta forma evitamos a manutenção em mais de um fonte
	Desenvolvedor: Marcelo Klopfer Leme
	Data.........: 20/05/2022
	Chamado......: 20220429009114 - Oferta Logística
	
	_cNomePdf  :=cEmpAnt+"_Pedido_"+SC5->C5_NUM
	oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , '\arquivos\Pedido\'  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
	oPrint:SetLandScape()     //SetPortrait() ou SetLandscape()
	oPrint:SetMargin(60,60,60,60)
	oPrint:setPaperSize(9)

	xImpress()

	// Indique o caminho onde será gravado o PDF
	FERASE(cStartPath+_cNomePdf+".pdf")
	oPrint:cPathPDF := cStartPath//"c:\"
	oPrint:Print()
	***************************************************************************************/

	If !IsInCallStack("U_CH_PED") .AND. !IsInCallStack("U_STFAT701")
		U_RSTFAT09()
	EndIf

	If AllTrim(SC5->C5_CLIENT)=="006596" //Nortel
		cCopia	:= cCopia+";mariana.silva@rexel.com.br;kathiuce.souza@rexel.com.br;marcelo.oliveira@steck.com.br"
		_lEnvia	:= .T.
	ElseIf AllTrim(SC5->C5_CLIENT)=="008724" //PJ
		cCopia	:= cCopia+";maria.leni@eletricapj.com.br;sylvio.esteves@eletricapj.com.br;thalita.maciel@eletricapj.com.br;jcantero@uol.com.br;eliane.silva@steck.com.br;maria.leni@eletricapj.com.br;erica.oliveira@eletricapj.com.br"
		_lEnvia	:= .T.
	ElseIf AllTrim(SC5->C5_CLIENT)=="010566" //Neblina
		cCopia	:= cCopia+";maria.leni@eletricapj.com.br;andre.rocha@neblina.com.br;thalita.maciel@eletricapj.com.br;jcantero@uol.com.br;eliane.silva@steck.com.br;maria.leni@eletricapj.com.br;erica.oliveira@eletricapj.com.br"
		_lEnvia	:= .T.
	ElseIf AllTrim(SC5->C5_CLIENT)=="003382" //Dimensional
		cCopia	:= cCopia+";simone.valencio@dimensional.com.br;caroline.savazzi@dimensional.com.br"
		_lEnvia	:= .T.
	EndIf

	If _Lmomat

		If msgyesno("Confirma Liberação ?")
			DbSelectArea('SC6')
			SC6->( DbSetOrder(1) )
			If SC6->( DbSeek(xFilial('SC6') + SC5->C5_NUM) )

				If __cUserId $ GetMv("ST_USRFISC",,'000000')
					If cEmpAnt=="01"
						If !(AllTrim(SC6->C6_OPER)=="70")
							MsgAlert("Usuário não autorizado a liberar esse pedido, verifique!")
							Return
						EndIf
					ElseIf cEmpAnt=="03"
						If !(AllTrim(SC6->C6_OPER)=="04")
							MsgAlert("Usuário não autorizado a liberar esse pedido, verifique!")
							Return
						EndIf
					EndIf
				Else
					If cEmpAnt=="01"
						If AllTrim(SC6->C6_OPER)=="70"
							MsgAlert("Usuário não autorizado a liberar esse pedido, verifique!")
							Return
						EndIf
					ElseIf cEmpAnt=="03"
						If AllTrim(SC6->C6_OPER)=="04"
							MsgAlert("Usuário não autorizado a liberar esse pedido, verifique!")
							Return
						EndIf
					EndIf
				EndIf

				Do While SC6->(!EOF()) .And. SC6->C6_FILIAL == xFilial('SC6') .And. SC6->C6_NUM == SC5->C5_NUM

					If SC6->C6_PRCVEN = 0.01      .And. SC6->C6_ZPRCPSC  = 0   //Giovani Zago 25/03/14 chamado 3 32
						_nQtVal++
					EndIf

					If Alltrim(SC6->C6_PRODUTO) $ GetMv("ST_PILHAMA",,"PA15AAA2/PA15AAA4/PA15AA2/PA15AA4/PA15C2/PA15D2/PA09V")   //Giovani Zago 25/03/14 chamado 332
						_lPilha	:= .T.
					EndIf
					SC6->( DbSkip())
				EndDo

			EndIf

			If 	_nQtVal = 0
				SC5->( RecLock('SC5',.F.) )

				SC5->C5_ZBLOQ    := "2"
				SC5->C5_ZMOTBLO  := ""
				SC5->C5_XMSGCLI  := ""
				SC5->(MsUnlock())
				SC5->(DbCommit())

				DbSelectArea("SC6")
				SC6->(DbSetOrder(1))
				
				IF SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM ) )
					
					While SC6->(!Eof()) .and. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM = SC5->C5_NUM
						u_LOGJORPED("SC6","2",SC6->C6_PRODUTO,SC6->C6_ITEM,SC6->C6_NUM,"","Liberacao comercial")
						SC6->(DbSkip())
					End
					
				EndIf

				
				U_STZZI01()

				If _lEnvia
					Processa({|lEnd| xBrEnvMail(oPrint,"Pedido de Venda: "+ SC5->C5_NUM,{"Pedido de Venda: "+ SC5->C5_NUM},cEmailFor,"",{},10)},titulo)
				EndIf

				DbSelectArea('SC6')
				SC6->( DbSetOrder(1) )
				If SC6->( DbSeek(xFilial('SC6') + SC5->C5_NUM) )

					Do While SC6->(!EOF()) .And. SC6->C6_FILIAL == xFilial('SC6') .And. SC6->C6_NUM == SC5->C5_NUM

						SC6->( RecLock('SC6',.F.) )

						SC6->C6_ZMOTBLO  := "3"

						SC6->(MsUnlock())
						SC6->(DbCommit())

						dbSelectArea("SC9")
						SC9->(	dbSetOrder(1) )
						If	SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))   .And. 	Empty (ALLTRIM(SC9->C9_ORDSEP)) .And. Empty(ALLTRIM(SC9->C9_NFISCAL))
							a460estorna()
						EndIf

						//Giovani Zago 05/03/14 liberação de credito automatico
						If SC5->C5_CONDPAG $ _cConPag

							lCredito := .F.
						ElseIf !Empty(SC5->C5_PEDEXP)
							lCredito := .F.
							//giovani zago bloquear pedido sem serasa e serasa vencido 17/08/18 007862
						ElseIf !(Empty(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XDTSERA")))
							If dDataBase > (Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XDTSERA") + getmv("ST_FINLIB3",,160) )
								lCredito := .F.
							Else
								lCredito := .T.
							EndIf
						ElseIf  Empty(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XDTSERA"))
							lCredito := .F.
							////////////////////////
						ElseIf SC6->C6_OPER $ _cBlOper  //giovani zago 06/03/17 chamado 005234
							lCredito := .F.
						Else
							lCredito := MaAvalCred(SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_VALOR,SC5->C5_MOEDA,.F.)
						EndIf

						U_STLOGFIN(SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRCVEN,SC6->C6_QTDVEN,lCredito,.T.)
						nRecno:= SC6->(RecNo())
						MaLibDoFat(SC6->(RecNo()), SC6->C6_QTDVEN-SC6->C6_QTDENT,.F.,.T.,lCredito,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
						MaLiberOk({SC6->C6_NUM},.F.)
						MsUnLockall()
						dbcommitall()
						SC6->(DbGoto(nRecno))

						SC6->( DbSkip())
					EndDo
					If lCredito
						Reclock("SC5",.F.)
						SC5->C5_ZMOTREJ  := ''
						SC5->C5_ZDTREJE  := CTOD('  /  /    ')
						SC5->C5_ZFATBLQ  := ''

						SC5->(MsUnLock())
						SC5->( DbCommit() )
						u_STC9LIB('','',cusername,dtoc(date()),time(),'')
					EndIf
				EndIf

				U_STDESALC(Inclui,Altera)//Giovani Zago 18/12/13 Alçada Comercial
				DbSelectArea('ZZI')
				ZZI->(DbGoTop())
				ZZI->(DbSetOrder(3))
				If ZZI->(DbSeek(xFilial("ZZI")+SC5->C5_NUM))
					If	ZZI->ZZI_BLQ  =  '2' .Or. ZZI->ZZI_BLQ = '3'
						dbSelectArea("ZZH")
						ZZH->(dbSetOrder(1))
						If ZZH->(DbSeek(xFilial("ZZH")+__cUserId)) .or. __cUserId = '000000'
							//_nMin     := ZZH->ZZH_MIN
							//	_nMax     := ZZH->ZZH_MAX
							If 	__cUserId = '000000'
								_nMin     := ZZH->ZZH_MIN
								_nMax     := 100
							Else
								_nMin     := ZZH->ZZH_MIN
								If ZZH->ZZH_DTDE <= ddatabase .And.  ZZH->ZZH_DTATE >= ddatabase .And. ZZH->ZZH_LIMITE > 0
									_nMax     := ZZH->ZZH_LIMITE
								Else
									_nMax     := ZZH->ZZH_MAX
								Endif
							Endif

							If ZZI->ZZI_DESC <= _nMax

								ZZI->(RecLock("ZZI",.F.))
								ZZI->ZZI_BLQ    :=  '1'
								ZZI->ZZI_USERAP := __cUserId+" - "+cUserName
								ZZI->ZZI_DTAPR  := dDataBase
								ZZI->(MsUnlock())
								ZZI->( DbCommit() )

							Else
								MsgInfo("Desconto Fora da Alçada de Aprovação ...!!!!")
								SC5->( RecLock('SC5',.F.) )

								SC5->C5_ZBLOQ    := "1"
								SC5->C5_ZMOTBLO  := "DESC/"
								SC5->C5_XMSGCLI  := ""
								SC5->(MsUnlock())
								SC5->(DbCommit())
							EndIf
						Else

							MsgInfo("Usuario não Cadastrado Como Aprovador...!!!!")
							SC5->( RecLock('SC5',.F.) )

							SC5->C5_ZBLOQ    := "1"
							SC5->C5_ZMOTBLO  := "DESC/"
							SC5->C5_XMSGCLI  := ""
							SC5->(MsUnlock())
							SC5->(DbCommit())
						EndIf
					Endif
				EndIf

			Else

				MSGINFO("Atenção Existem Itens Com Valor de R$ 0,01")
			EndIf

		EndIf

	EndIf
Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³xBrEnvMail³ Autor ³ João Victor           ³ Data ³26/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio do Pedido de Venda por e-mail automaticamente        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xBrEnvMail(oGraphic,cAssunto,aTexto,cTo,cCC,aTabela,nEspacos)

	Local cMailConta	:= GETMV("MV_RELACNT")
	Local cMailServer	:= GETMV("MV_RELSERV")
	Local cMailSenha	:= GETMV("MV_RELPSW")
	Local lAuth 		:= GetMv("MV_RELAUTH",,.F.)

	Local lOk			:= .F.
	Local cMensagem
	Local nx			:= 0
	Local lBmp := !( oGraphic == NIL )
	Local  nWidth := 0
	Local cError
	local _aAttach := {}//'c:\six0101.dbf'
	Local _cCaminho:=cStartPath
	Local _nIni:=1
	Local _nFim:=100

	aadd( _aAttach  ,_cNomePdf+'.pdf')

	If _lPilha
		__CopyFile('manual\Manual_de_Comercializao_Pilhas.pdf', _cCaminho+'Manual_de_Comercializao_Pilhas.pdf',,,.F.)
		aadd( _aAttach  ,'Manual_de_Comercializao_Pilhas.pdf')
		FERASE(_cDirRel+"\Manual_de_Comercializao_Pilhas.pdf")
		CpyS2T('manual\Manual_de_Comercializao_Pilhas.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
		ShellExecute("open",_cDirRel+"\Manual_de_Comercializao_Pilhas.pdf", "", "", 1)
	EndIf
	If Empty(cCC)

	EndIf

	aTexto   := IIF( aTexto == NIL,{},aTexto )
	aTabela  := IIF( aTabela == NIL,{},aTabela)
	nEspacos := IIF( nEspacos == NIL, 10, nEspacos )

	cMensagem := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">'
	cMensagem += '<HTML><HEAD>'
	cMensagem += '<META content="text/html; charset=iso-8859-1" http-equiv=Content-Type>'
	cMensagem += '<META content="MSHTML 5.00.2920.0" name=GENERATOR></HEAD>'
	cMensagem += '<BODY aLink=#ff0000 bgColor=#ffffff link=#0000ee text=#000000 '
	cMensagem += 'vLink=#551a8b><B>'

	cMensagem += "<br><font Face='CALIBRI' >" + "Pedido de Venda enviado automaticamente pelo sistema PROTHEUS" + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "Enviado por: " + UsrFullName(RetCodUsr()) + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "ATENÇÃO!!! AO RESPONDER ESSE E-MAIL FAVOR COPIAR A TODOS OS ENVOLVIDOS NO MESMO!!!" + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "Pedido de Venda nº: " + SC5->C5_NUM + "</font></br>"

	_cMesCorp:= StMSg()
	cMensagem += "<br><div align='left'><font Face='CALIBRI' >"+ strtran(_cMesCorp,'.',".</FONT>  </br></div>   </tr></table></br><div align='left'><font Face='CALIBRI' > ")    +'</FONT></div>'
	cMensagem:=STRTRAN(cMensagem,'ZZZZ','.')
	cMensagem:=STRTRAN(cMensagem,'AAAA',"</FONT></br>  </div>   </tr></table>  <div align='left'><br><font Face='CALIBRI' >")
	cMensagem += '</B>'
	cMensagem += '<BR>&nbsp;</BR>'

	cMensagem += "</CENTER>"
	cMensagem += '</body>'

	ProcRegua(8)

	IncProc()
	IncProc("Conectando servidor...")

	// Envia e-mail com os dados necessarios

	U_STMAILTES(cEmailFor,cCopia,titulo,cMensagem,_aAttach,_cCaminho)


Return lOk

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ xImpress ³ Autor ³ João Victor           ³ Data ³26/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Relatório                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xImpress()

	LOCAL 	_nTxper := GETMV("MV_TXPER")
	LOCAL 	i 		:= 0
	Local	_cDMoed	:= "R$"
	LOCAL 	oBrush
	Local _nTotIPI  := 0
	Local _nTotICMSST:= 0
	Local _nTotvalmerc := 0
	Local _nTotpedvend :=0
	Local _nTotal		:= 0
	Local _nTotSuf		:= 0
	Local _ncount		:= 0

	Private _nLin := 4000

	aBmp := "STECK.BMP"

	//Parâmetros de TFont.New()
	//1.Nome da Fonte (Windows)
	//3.Tamanho em Pixels
	//5.Bold (T/F)
	oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
	oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10 := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10n:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11 := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont13 := TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont13n:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14n:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17 := TFont():New("Arial",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17n:= TFont():New("Arial",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20 := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20n:= TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont18 := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)

	oBrush := TBrush():New("",4)

	_ntotal := 0
	_npagina := 0
	_aItRed	:= {}
	Dbselectarea("SM0")
	Dbselectarea("SC6")
	SC6->(Dbsetorder(1))
	SC6->(Dbseek(xfilial("SC6")+SC5->C5_NUM) )

	oPrint:StartPage()     // INICIALIZA a página
	xCabOrc()

	Do While !eof()  .and. SC5->C5_NUM == SC6->C6_NUM

		DbSelectArea("SA1")
		DbSetOrder(1)
		MsSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

		STMAFISREL()
		_nTotIPI     := (nValIPI)+(_nTotIPI)
		_nTotICMSST  := (nValICMSST)+(_nTotICMSST)
		_nTotSuf	:= (nValSuf)+_nTotSuf
		_nTotvalmerc := (SC6->C6_VALOR)+(_nTotvalmerc)
		_nTotpedvend := (_nTotvalmerc)+(_nTotIPI)+(_nTotICMSST)

		If _nLin > 580
			_nLin+=10
			oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			xCabOrc()
		Endif

		// Posiciona No Cad Produtos
		DbSelectArea("SB1")
		DbSetOrder(1)
		MsSeek(xFilial("SB1")+SC6->C6_PRODUTO)

		// Posiciona No Cad De TES
		DbSelectArea("SF4")
		DbSetOrder(1)
		MsSeek(xFilial("SF4") + SC6->C6_TES,.t.)

		_nXmargSf7:= Posicione('SF7',4,xFilial("SF7")+SB1->B1_GRTRIB+&_cxCliContr+&_cCliEst+&_cTipoCli,'F7_MARGEM')

		//Impressao do Item
		oPrint:Say  (_nLin,020, SC6->C6_ITEM	,oFont8)

		//Impressao do Codigo e Descricao do Produto
		oPrint:Say  (_nLin,040, SC6->C6_produto	,oFont8)
		_nTam		:= 60
		_ctexto  	:= Alltrim(SubStr(SB1->B1_DESC,1,42))
		_nlinhas 	:= mlcount(_ctexto,_nTam)
		for _ncount:= 1 to _nlinhas
			oPrint:Say  (_nLin ,095, memoline(_ctexto,_nTam,_ncount),oFont8)
			If _nCount <> _nLinhas
				_nLin+=60
			EndIf
		next _ncount

		//Impressao da Quantidade e Unidade de Medida
		oPrint:Say  (_nLin,280, transform(SC6->C6_QTDVEN,"@E 999999.99")	,oFont8)
		_nTam		:= 60
		_ctexto  	:= Alltrim(SB1->B1_UM)
		_nlinhas 	:= mlcount(_ctexto,_nTam)
		for _ncount:= 1 to _nlinhas
			oPrint:Say  (_nLin ,320, memoline(_ctexto,_nTam,_ncount),oFont8)
			If _nCount <> _nLinhas
				_nLin+=60
			EndIf
		next _ncount

		//Impressao do Valor Unitario
		oPrint:Say  (_nLin,350, transform(SC6->C6_PRCVEN	,"@E 999,999.99")	,oFont8)

		//Impressao do Percentual de IPI
		oPrint:Say  (_nLin,390, transform(nAliqIPI 	,"@E 999.99")		,oFont8)

		//Impressao do Percentual de ICMS
		oPrint:Say  (_nLin,420, transform(nAliqICM,"@E 999.99")		,oFont8)

		//Impressao do Percentual de IVA
		oPrint:Say  (_nLin,450, transform(_nXmargSf7	,"@E 999.99")	   		,oFont8)

		//Impressao do Valor de ICMS-ST
		oPrint:Say  (_nLin,490, transform((nValICMSST)	,"@E 99,999,999,999.99")		,oFont8)

		//Impressao do Valor Total
		oPrint:Say  (_nLin,550, transform(SC6->C6_VALOR	,"@E 9,999,999.99")	,oFont8)
		_nTotal	+= SC6->C6_VALOR

		//Impressao do Prazo de Entraga
		//oPrint:Say  (_nLin,600, transform(SC6->C6_ENTRE1	,"@E 999.999,99")	,oFont8)

		//Impressao do NCM
		//oPrint:Say  (_nLin,660, transform(SC6->C6_ZNCM  	,"@R 9999.99.99")	,oFont8)
		oPrint:Say  (_nLin,600, transform(SC6->C6_ZNCM  	,"@R 9999.99.99")	,oFont8)

		//Impressao da Ordem de Compra por Item
		//oPrint:Say  (_nLin,720, transform(SC6->C6_XORDEM  	,"@!")	            ,oFont8)
		oPrint:Say  (_nLin,660, transform(SC6->C6_XORDEM  	,"@!")	            ,oFont8)

		//Impressao de dias uteis
		//oPrint:Say  (_nLin,720, transform(SC6->C6_ENTRE1	,"@E 999.999,99")	,oFont8)
		//oPrint:Say  (_nLin,720, transform(CVALTOCHAR(Iif(POSITIVO(SC6->C6_ENTRE1-SC5->C5_EMISSAO),SC6->C6_ENTRE1-SC5->C5_EMISSAO,(SC6->C6_ENTRE1-SC5->C5_EMISSAO)*-1)+1)+" dias corridos"				  	,"@!")	            ,oFont8)
		oPrint:Say  (_nLin,720, transform(CVALTOCHAR(U_STGETPRZ(SC6->C6_PRODUTO,SC6->(C6_QTDVEN-C6_QTDENT),"2"))+" dias corridos"				  	,"@!")	            ,oFont8)

		_nLin+=15

		If _nLin > 580
			_nLin+=10
			oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			xCabOrc()
		Endif

		Dbselectarea("SC6")
		SC6->(DbSkip())

	Enddo

	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	oPrint:Line (_nLin, 005,_nLin,800)
	// Imprime Total do Pedido de Venda
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	oPrint:Say  (_nLin,550, "Valor Total dos Produtos (" + _cDMoed + ")"	,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(/*_nTotvalmerc*/_nTotal,"@E 9,999,999.99")	,oFont10)
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	oPrint:Say  (_nLin,550, "Valor Total IPI (" + _cDMoed + ")"			,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(_nTotIPI,"@E 9,999,999.99")	,oFont10)
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	oPrint:Say  (_nLin,550, "Valor Total ICMS-ST (" + _cDMoed + ")"		,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(_nTotICMSST,"@E 9,999,999.99")	,oFont10)
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	oPrint:Say  (_nLin,550, "Valor Total Suframa (" + _cDMoed + ")"		,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(_nTotSuf,"@E 9999,999.99")	,oFont10)
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	oPrint:Say  (_nLin,550, "Valor Total do Pedido de Venda (" + _cDMoed + ")"	,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(/*_nTotpedvend*/_nTotal+_nTotIPI+_nTotICMSST-_nTotSuf,"@E 9,999,999.99")	,oFont10)
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	// Observação da Cotação:
	oPrint:Say  (_nLin,020, "Observação"						,oFont10)
	oPrint:Say  (_nLin,070, ": " + SC5->C5_ZOBS 				,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	// Inicia Mensagens do Pedido de Venda
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	// Imprime Vendedor
	_cVend1 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_NOME"))
	oPrint:Say  (_nLin,020, "Operador"							,oFont10)
	oPrint:Say  (_nLin,060, ": " + Capital(_cVend1)				,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_cVend2 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_TEL"))
	oPrint:Say  (_nLin,020, "Telefone"							,oFont10)
	oPrint:Say  (_nLin,060, ": " + Capital(_cVend2)				,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_cVend3 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_FAX"))
	oPrint:Say  (_nLin,020, "Fax"						 		,oFont10)
	oPrint:Say  (_nLin,060, ": " + Capital(_cVend3)		 		,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_cVend4 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_EMAIL"))
	oPrint:Say  (_nLin,020, "E-mail"							,oFont10)
	oPrint:Say  (_nLin,060, ": " + lower(_cVend4)				,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina

	oPrint:EndPage()     // Finaliza a página

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³xCabOrc   ºAutor  ³ João Victor        º Data ³ 26/07/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Steck                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xCabOrc ()

	Local _nDias	:= 0

	oPrint:Box(045,005,580,800)

	If File(aBmp)
		oPrint:SayBitmap(060,020,aBmp,095,050 )
	EndIf

	oPrint:Say  (065,120, _cNomeCom  ,oFont12)
	oPrint:Say  (080,120, _cEndereco ,oFont12)
	oPrint:Say  (095,120,"CEP: "+ SUBSTR(cCep,1,5)+"-"+SUBSTR(cCep,6,3) +" - "+Alltrim(cCidade)+" - "+cEstado,oFont12)
	oPrint:Say  (110,120,"TEL.: (11) 2248-7000 | FAX.: (11) 2248-7051 | E-MAIL: contato.vendas@steck.com.br",oFont12)

	dbselectarea("SA1")
	MsSeek(Xfilial("SA1")  + SC5->C5_CLIENTE + SC5->C5_LOJACLI )

	oPrint:Box(125,005,230,800)

	oPrint:Say  (140,020,"Empresa: "+ Upper(SA1->A1_NOME)         									,oFont12)
	oPrint:Say  (155,020,"Código de Cliente: "+ SC5->C5_CLIENTE + " - " + SC5->C5_LOJACLI			,oFont12)

	oPrint:Say  (170,020,"Dados de Faturamento: " 																																								,oFont12)
	oPrint:Say  (185,020,Upper(Alltrim(SA1->A1_END) + " - " + Alltrim(SA1->A1_BAIRRO) + " - " + Alltrim(SA1->A1_MUN) + " - " + Alltrim(SA1->A1_EST) + " - " + Alltrim(SA1->A1_CEP))         					,oFont12)
	oPrint:Say  (200,020,TRANSFORM(SA1->A1_CGC,PESQPICT("SA1","A1_CGC"))			        		   																											,oFont12)
	oPrint:Say  (215,020,"I.E.: "+ SA1->A1_INSCR 											   	   																												,oFont12)

	oPrint:Box(230,005,295,800)
	cBmpName  :=SC5->C5_NUM
	oPrint:Say  (245,020,"Pedido de Venda"						,oFont12)
	oPrint:Say  (245,100,": " + SC5->C5_NUM						,oFont12)
	oPrint:Say  (245,220,"Emissão" 								,oFont12)
	oPrint:Say  (245,310,": " + dtoc(SC5->C5_EMISSAO)			,oFont12)

	//_nDias	:= DIASMAX(SC5->C5_FILIAL , SC5->C5_NUM)

	//oPrint:Say  (245,420,"Entrega dias uteis:"					,oFont12)
	//oPrint:Say  (245,510,CVALTOCHAR(_nDias)						,oFont12)

	dbselectarea("SU5")
	MsSeek(Xfilial("SU5")  + SC5->C5_ZCODCON )
	dbselectarea("SQB")
	MsSeek(Xfilial("SQB")  + SU5->U5_DEPTO )

	_cDepto:=SQB->QB_DESCRIC

	oPrint:Say  (260,020, "Contato" 						,oFont12)
	oPrint:Say  (260,100, ": " + Capital(SU5->U5_CONTAT)	,oFont12)
	oPrint:Say  (260,220, "Departamento"					,oFont12)
	oPrint:Say  (260,310, ": " + (_cDepto)					,oFont12)

	dbselectarea("SE4")
	MsSeek(Xfilial("SE4")  + SC5->C5_CONDPAG )

	oPrint:Say  (275,020, "Cond. Pagto" 					,oFont12)
	oPrint:Say  (275,100, ": " + SE4->E4_DESCRI				,oFont12)
	oPrint:Say  (275,220, "Ordem de Compra" 				,oFont12)
	oPrint:Say  (275,310, ": "+ SC5->C5_XORDEM				,oFont12)

	IF SC5->C5_TPFRETE = "F"
		_cFrete = "FOB"
	Else
		_cFrete = "CIF"
	Endif

	oPrint:Say  (290,020, "Frete"				,oFont12)
	oPrint:Say  (290,100, ": "	+ (_cFrete)		,oFont12)
	oPrint:Say  (290,220, "Atendimento"			,oFont12)
	oPrint:Say  (290,310, ": "+SC5->C5_ZORCAME	,oFont12)

	oPrint:Box(295,005,320,800)
	oPrint:Say  (310,020, "Item"			    	,oFont10)
	oPrint:Say  (310,040, "Código"					,oFont10)
	oPrint:Say  (310,095, "Descrição"				,oFont10)
	oPrint:Say  (310,280, "Qtde." 					,oFont10)
	oPrint:Say  (310,320, "UM"						,oFont10)
	oPrint:Say  (310,350, "Vlr Unit"  				,oFont10)
	oPrint:Say  (310,390, "IPI"				    	,oFont10)
	oPrint:Say  (310,420, "ICMS"				   	,oFont10)
	oPrint:Say  (310,450, "IVA"				    	,oFont10)
	oPrint:Say  (310,490, "ICMS-ST"				    ,oFont10)
	oPrint:Say  (310,550, "Valor Total"				,oFont10)
	//oPrint:Say  (310,600, "Prazo Entrega"			,oFont10)
	//oPrint:Say  (310,660, "Clas. Fiscal"			,oFont10)
	oPrint:Say  (310,600, "Clas. Fiscal"			,oFont10)
	//oPrint:Say  (310,720, "Ordem/Produto"			,oFont10)
	oPrint:Say  (310,660, "Ordem/Produto"			,oFont10)
	oPrint:Say  (310,720, "Prazo de entrega"  			,oFont10)

	_nLin := 330

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³STMAFISREL³ Autor ³ João Victor           ³ Data ³26/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Abre o MAFISRET para trazer os valores dos tributos        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function STMAFISREL()

	MaFisSave()
	MaFisEnd()
	MaFisIni(SC5->C5_CLIENTE,;	// 1-Codigo Cliente/Fornecedor
	SC5->C5_LOJACLI ,;			// 2-Loja do Cliente/Fornecedor
	"C",;					    // 3-C:Cliente , F:Fornecedor
	"N",;					    // 4-Tipo da NF
	SC5->C5_TIPOCLI,;		    // 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")                                                               // 10-Nome da rotina que esta utilizando a funcao

	MaFisAdd(SC6->C6_PRODUTO,;                                               // 1-Codigo do Produto ( Obrigatorio )
	SC6->C6_TES,;                                                            // 2-Codigo do TES ( Opcional )
	SC6->C6_QTDVEN,;                                                         // 3-Quantidade ( Obrigatorio )
	SC6->C6_PRCVEN,;                                                         // 4-Preco Unitario ( Obrigatorio )
	0,;                														 // 5-Valor do Desconto ( Opcional )
	,;                                                                       // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                       // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                       // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                      // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                      // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                      // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                      // 12-Valor do Frete Autonomo ( Opcional )
	SC6->C6_VALOR,;  														 // 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                      // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                      // 15-RecNo do SB1
	0)                                                                       // 16-RecNo do SF4

	nAliqICM 	:= (MaFisRet(1,'IT_ALIQICM',5,2)  )    //Aliquota do ICMS
	nValICms	:= (MaFisRet(1,'IT_VALICM',14,2)  )    //Valor do ICMS

	nAliqIPI 	:= (MaFisRet(1,"IT_ALIQIPI",5,2)  )    //Aliqutota do IPI
	nValIPI 	:= (MaFisRet(1,"IT_VALIPI",14,2)  )    //Valor do IPI

	nValICMSST 	:= (MaFisRet(1,'IT_VALSOL',14,2)  )    //Valor do ICMS-ST
	nValSuf		:= (MaFisRet(1,"IT_DESCZF",14,2)  )	   //Valor do suframa

	nValPis		:= (MaFisRet(1,"IT_VALPS2",14,2)  )    //Valor do PIS
	nValCof		:= (MaFisRet(1,"IT_VALCF2",14,2)  )    //Valor do COFINS

	mafisend()

Return

Static Function StMSg()
	Local _cText:= ("")

Return  (alltrim(_cText))

Static Function DIASMAX(_cFilial,_cNum)

	Local _nDias	:= 0
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"

	cQuery1	:= " SELECT MAX(ZZO_PRAZO) PRAZO "
	cQuery1 += " FROM "+RetSqlName("ZZO")+" ZO "
	cQuery1 += " WHERE ZO.D_E_L_E_T_=' ' AND ZZO_CODIGO IN ( "
	cQuery1 += " SELECT DISTINCT B1_ZCODOL "
	cQuery1 += " FROM "+RetSqlName("SC6")+" C6 "
	cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
	cQuery1	+= " ON B1_COD=C6_PRODUTO "
	cQuery1 += " WHERE C6.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND C6_FILIAL='"+_cFilial+"' AND C6_NUM='"+_cNum+"') "


	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->(!Eof())
		_nDias	:= (cAlias1)->PRAZO
	EndIf

	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf


Return(_nDias)

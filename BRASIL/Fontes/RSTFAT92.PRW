#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#Include "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RSTFAT92     ºAutor  ³Joao Rinaldi    º Data ³  15/01/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função desenvolvida para realizar a impressão gráfica dos  º±±
±±º          ³ Pedidos de Compra Steck                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002103 - Layout Pedido de Compras                          º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//------------------------------------------------------------------------------------------------//
//Alterações realizadas:
//FR - 10/08/2022 - Flávia Rocha - Sigamat Consultoria
//Após a atualização de release, a query na função StQuery não trazia dados
//em virtude de um comando de query usado para um campo memo, provavelmente pela atualização
//o comando não é mais reconhecido, então substituí a chamada do campo por dbseek na Sb1
//Campo: B1_XDESEXD - Descrição estendida
//------------------------------------------------------------------------------------------------//
User Function RSTFAT92(_lPortal)

	Local aArea   := GetArea()
	Local aArea1  := SC7->(GetArea())
	Local aArea2  := SA2->(GetArea())
	Local aArea3  := SE4->(GetArea())
	Local aArea4  := SY1->(GetArea())
	Local aArea5  := SM0->(GetArea())
	//Local   n     := 0

	Private cPerg 		:= "RFAT92"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
	Private cAlias1      := cAliasLif
	Private _aAttach      := {}
	Private _aAttachUs    := {}
	Private cCombo := ""

	Private oPrint

	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//³ Variáveis para envio de E-Mail
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private cEmailFor     := ""
	Private cCopia        := ""
	Private ctitulo       := "Envio de E-Mail Pedido de Compra nº: "
	Private cBmpName  	 := ''
	Private cStartPath 	 := '\arquivos\pedido_compra\'//GetSrvProfString("Startpath","") +'orcamento\'
	Private _cPath		 := GetSrvProfString("RootPath","") //GetPvProfString( GetEnvServer(), "RootPath"	, "", GetAdv97() )
	Private _cNomePdf     :=''
	Private _lRet         := .T.
	Private _cDirRel      := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private _lxRet        := .T.

	//Private _nXmargSf7    := 0
	//Private _nTotPed      := 0
	//Private nAliqICM      := 0
	//Private nValICms      := 0
	//Private nCnt          := 0
	//Private nAliqIPI      := 0
	//Private nValIPI       := 0
	//Private nValICMSST    := 0
	//Private nValPis       := 0
	//Private nValCof       := 0

	Private nTotal        := 0
	Private nTotMerc      := 0
	Private nTotIPI       := 0
	Private nTotIcms      := 0
	Private nTotFrete     := 0
	Private nTotDesp      := 0
	Private nTotSeguro    := 0
	Private nTotalNF      := 0
	Private _cObs         := ''

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variáveis do arquivo de empresas sigamat.emp
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private _cNomeCom    := SM0->M0_NOMECOM
	Private _cEndereco   := SM0->M0_ENDENT
	Private _cCep        := SM0->M0_CEPENT
	Private _cCidade     := SM0->M0_CIDENT
	Private _cEstado     := SM0->M0_ESTENT
	Private _cBairro     := SM0->M0_BAIRENT
	Private _cCNPJ       := SM0->M0_CGC
	Private _cTelefone   := SM0->M0_TEL
	Private _cFax        := SM0->M0_FAX
	Private _cIe         := SM0->M0_INSC
	Private _cCGC        := SM0->M0_CGC
	Private cCident      := ''
	Private cCidcob      := ''

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variáveis do Pedido de Compra
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private cFilPc		  := SC7->C7_FILIAL
	Private cNumPC        := SC7->C7_NUM
	Private cContato      := ''
	Private cCond         := ''
	Private cEmiss        := ''
	Private cFornece      := ''
	Private cLoja         := ''
	Private cTpFrete      := ''
	Private cFilEnt       := ''

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variáveis do Cadastro de Fornecedor
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private cNome         := ''
	Private cEnd          := ''
	Private cBairro       := ''
	Private cMunicip      := ''
	Private cEst          := ''
	Private cCep          := ''
	Private cCGC          := ''
	Private cInscE        := ''
	Private cFone         := ''
	Private cFax          := ''
	Private cDDD          := ''
	Private cMailFor      := ''

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variáveis do Cadastro de Condição de Pagamento
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private cDescCond     := ''

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variáveis do Cadastro de Comprador
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private cComprador     := ''
	Private cTelComprador  := ''
	Private cFaxComprador  := ''
	Private cMailComprador := Space(100)
	Private _lPortal1	   := .F.
	Private _cRet := ""

	Default _lPortal := .F.

	_lPortal1 := _lPortal

	DbSelectArea("SC7")
	SC7->(DbGoTop())
	SC7->(DbSetOrder(1))

	If SC7->(DbSeek(cFilPc+cNumPC))
		cContato := SC7->C7_CONTATO
		cCond    := SC7->C7_COND
		cEmiss   := SC7->C7_EMISSAO
		cFornece := SC7->C7_FORNECE
		cLoja    := SC7->C7_LOJA
		cTpFrete := SC7->C7_TPFRETE
		cCompST  := SC7->C7_COMPSTK
		cFilEnt  := SC7->C7_FILENT
	Else
		_lRet := .F.
	Endif

	DbSelectArea("SA2")
	SA2->(DbGoTop())
	SA2->(DbSetOrder(1))
	If SA2->(DbSeek(xFilial("SA2")+ cFornece + cLoja))
		cNome    := SA2->A2_NOME
		cEnd     := SA2->A2_END
		cBairro  := SA2->A2_BAIRRO
		cMunicip := SA2->A2_MUN
		cEst     := SA2->A2_EST
		cCep     := SA2->A2_CEP
		cCGC     := SA2->A2_CGC
		cInscE   := SA2->A2_INSCR
		cFone    := SA2->A2_TEL
		cFax     := SA2->A2_FAX
		cDDD     := SA2->A2_DDD
		cMailFor := SA2->A2_EMAIL
	Endif

	DbSelectArea("SE4")
	SE4->(DbGoTop())
	SE4->(DbSetOrder(1))
	If SE4->(DbSeek(xFilial("SE4")+ cCond))
		cDescCond := SE4->E4_DESCRI
	Endif

	DbSelectArea("SY1")
	SY1->(DbGoTop())
	SY1->(DbSetOrder(1))
	If SY1->(DbSeek(xFilial("SY1")+ cCompST))
		cComprador     := SY1->Y1_NOME
		cTelComprador  := SY1->Y1_TEL
		cFaxComprador  := SY1->Y1_FAX
		cMailComprador := SY1->Y1_EMAIL
	Endif

	SM0->(dbSetOrder(1))
	nRecnoSM0 := SM0->(Recno())
	If SM0->(dbSeek(SUBS(cNumEmp,1,2)+cFilEnt))
		If SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="02"
			//cCident := "Rua José Pinheiro Bezerra, 66 - Travessa da Rua Juvenal Gomes Coimbra, Famosa Rua da Goodyear"
		Else
			cCident := (Capital(Alltrim(SM0->M0_ENDENT))+"  "+Capital(Alltrim(SM0->M0_CIDENT))+"  - "+Alltrim(SM0->M0_ESTENT)+" - Cep: " + SUBSTR(SM0->M0_CEPENT,1,5)+"-"+SUBSTR(SM0->M0_CEPENT,6,3) )
		EndIf
		cCidcob := (Capital(Alltrim(SM0->M0_ENDCOB))+"  "+Capital(Alltrim(SM0->M0_CIDCOB))+"  - "+Alltrim(SM0->M0_ESTCOB)+" - Cep: " + SUBSTR(SM0->M0_CEPCOB,1,5)+"-"+SUBSTR(SM0->M0_CEPCOB,6,3) )
	Endif

	ctitulo := ctitulo + cNumPC + " - " + _cNomeCom

	Processa({|lEnd|GeraRel()})

	RestArea(aArea5)
	RestArea(aArea4)
	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)
	RestArea(aArea)

Return _cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GeraRel      ºAutor  ³Joao Rinaldi    º Data ³  15/01/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que realiza a geração do Relatório                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002103 - Layout Pedido de Compras                          º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraRel()

	Local nPorta 		:= 21
	Local lWait := .T.
	Local cPath := "D:\TOTVS\Microsiga\Protheus12\PROTHEUS_DATA\scripts\pedidoscompra\"

	If !(_lRet)

		Msgstop("Pedido de Compra Nao Encontrado !!!  Verifique !!! " )

	Else

		_cNomePdf := cEmpAnt+"_"+SC7->C7_NUM
		oPrint    := fwmsprinter():New( _cNomePdf , 6      ,.F.             , cStartPath  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
		oPrint    :SetLandScape()     //SetPortrait() ou SetLandscape()
		oPrint    :SetMargin(60,60,60,60)
		oPrint    :setPaperSize(9)

		_aAreaSC7 := SC7->(GetArea())
		ImpItens()
		RestArea(_aAreaSC7)

		// Indique o caminho onde será gravado o PDF
		FERASE(cStartPath+_cNomePdf+".pdf")
		oPrint:cPathPDF := cStartPath
		oPrint:Print()

		If IsInCallStack("U_STCOMA51") //Chamada via job
			Return
		EndIf

		If _lPortal1

			_cRet := cStartPath+_cNomePdf+".pdf"

			/*
			cDir 	:= GetMv("ST_FTPDIR2",,cStartPath+_cNomePdf+'.pdf')
			cServer	:= GetMv("ST_FTPSRV2",,"www.appstk.com.br")
			cUser	:= GetMv("ST_FTPUSR2",,"renato.oliveira")
			cPass	:= GetMv("ST_FTPPSW2",,"steck@2018")
			cDirFtp	:= GetMv("ST_FTPDIR2",,"/portal_fornecedor/pedidos/")

			oFTPHandle := tFtpClient():New()
			nRet := oFTPHandle:FTPConnect(cServer,nPorta,cUser,cPass)
			nRet := oFTPHandle:ChDir(cDirFtp)
			nRet := oFTPHandle:SendFile(cDir,_cNomePdf+".pdf")
			If nRet==0
				Conout('UpLoad Ok! ')
			Else
				Conout('Falha no UpLoad!')
			EndIf
			
			_cFile := "\scripts\pedidoscompra\"+SC7->C7_NUM+".txt"

			If File(_cFile)
				FErase(_cFile)
			EndIf

			_cCont := "open "+AllTrim(GetMv("ST_ENDFTPS",,"10.152.10.32"))+CHR(13)+CHR(10)
			_cCont += "renato.oliveira"+CHR(13)+CHR(10)
			_cCont += "steck@2020"+CHR(13)+CHR(10)
			_cCont += "cd portalfornecedor/pedidos"+CHR(13)+CHR(10)
			_cCont += "binary"+CHR(13)+CHR(10)
			_cCont += "put D:\TOTVS\Microsiga\Protheus12\PROTHEUS_DATA\arquivos\pedido_compra\"+_cNomePdf+'.pdf'+CHR(13)+CHR(10)
			_cCont += "quit"

			nHdlXml   := FCreate(_cFile,0)
			FWrite(nHdlXml,_cCont)
			FClose(nHdlXml)

			cCommand := "D:\TOTVS\Microsiga\Protheus12\PROTHEUS_DATA\scripts\pedidoscompra\rodar.bat "+SC7->C7_NUM
			CONOUT(cCommand)

			if WaitRunSrv( @cCommand , @lWait , @cPath )
				CONOUT("ok")
			else
				msginfo("n")
			endif

			If File(_cFile)
				FErase(_cFile)
			EndIf
			*/
		Else

			If ExistDir(_cDirRel)
				_lxRet := .T.
			Else
				If MakeDir(_cDirRel) == 0
					MakeDir(_cDirRel)
					Aviso("Criação de Pasta","Fora criado nesse computador uma pasta para que os Pedidos de Compras emitidos lá sejam salvos após a impressão...!!!"+CHR(10)+CHR(13)+;
					CHR(10)+CHR(13)+;
					"Segue o caminho do diretório criado:"+CHR(10)+CHR(13)+;
					CHR(10)+CHR(13)+;
					_cDirRel,;
					{"OK"},3)
					_lxRet := .T.
				Else
					Aviso("Erro na Criação de Pasta","Para salvar o Pedido de Compra em questão é necessário que uma pasta seja criada nesse computador...!!!"+CHR(10)+CHR(13)+;
					CHR(10)+CHR(13)+;
					"Favor entrar em contato com o TI para que a criação da pasta seja realizada...!!!:"+CHR(10)+CHR(13)+;
					CHR(10)+CHR(13)+;
					"Não será possível realizar a abertura do Pedido de Compra em arquivo PDF e consequentemente não será enviado via e-mail ao Fornecedor...!!!",;
					{"OK"},3)
					_lxRet := .F.
				Endif
			Endif

			If _lxRet
				FERASE(_cDirRel+"\"+_cNomePdf+".pdf")
				CpyS2T(cStartPath+_cNomePdf+'.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
				ShellExecute("open",_cDirRel+_cNomePdf+'.pdf', "", "", 1)
				If MsgBox("Envia e-mail ao Fornecedor?","Envio de E-Mail","YESNO")

					If ChkMail() // Abre tela Para Digitar Manualmente E-Mails

						Processa({|lEnd| EnvMail(oPrint,"Pedido de Compra: "+ cNumPC,{"Pedido de Compra: "+ cNumPC},cEmailFor,cCopia,{},10)},ctitulo)

					Endif

				Endif
			Endif

		EndIf

	EndIf

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpItens     ºAutor  ³Joao Rinaldi    º Data ³  15/01/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que realiza a impressão dos itens e total do        º±±
±±º          ³ relatório                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002103 - Layout Pedido de Compras                          º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpItens()

	Local 	oBrush
	Local _ncount
	Local dtNesc    // Valdemir Rabelo Ticket: 20210609009719 02/07/2021

	Local cHrLin1:= Getmv("ST_HRLIN1",,"HORÁRIO DE RECEBIMENTO: Segunda a Quinta das 08:00 as 11:30 e das 13:00 as 16:30h")
	Local cHrLin2:= Getmv("ST_HRLIN2",,"Sexta das 08:00 as 11:30 e das 13:00 as 15:30h ")

	Private _nLin    := 4000
	Private _nLin2   := 000
	Private _nCol    := 000
	Private _nTam    := 30
	Private nConsTex := 0.5
	Private nSpace   := -5

	aBmp := "STECK.BMP"

	//TFont():New( [ cName ], [ uPar2 ], [ nHeight ], [ uPar4 ], [ lBold ], [ uPar6 ], [ uPar7 ], [ uPar8 ], [ uPar9 ], [ lUnderline ], [ lItalic ] )
	//oFont8  := TFont():New( "Courier New"  , 0        , 8          , .T.      , .F.      , 0        , .T.      , 0        , .T.      , .F.           , .F.        )
	oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
	oFont9  := TFont():New("Courier New",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10 := TFont():New("Courier New",9,10,.T.,.F.,5,.T.,5,.T.,.F.)

	//oFont10n:= TFont():New("Courier New",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	//oFont10n := TFont():New('Courier New',,10,.T.)

	oFont7 		:= TFont():New('Courier New',,7)
	oFont8 		:= TFont():New('Courier New',,8)
	oFont8n		:= TFont():New('Courier New',,8,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10n 	:= TFont():New('Courier New',,10)

	oFont11 := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12 := TFont():New("Courier New",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont13 := TFont():New("Courier New",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont13n:= TFont():New("Courier New",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14n:= TFont():New("Courier New",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n:= TFont():New("Courier New",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16 := TFont():New("Courier New",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n:= TFont():New("Courier New",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17 := TFont():New("Courier New",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17n:= TFont():New("Courier New",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20 := TFont():New("Courier New",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20n:= TFont():New("Courier New",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont18 := TFont():New("Courier New",9,18,.T.,.T.,5,.T.,5,.T.,.F.)

	oBrush := TBrush():New("",4)

	dbSelectArea("SC1")			// Valdemir Rabelo Ticket: 20210609009719 02/07/2021
	dbSetOrder(1)

	oPrint:StartPage()     // INICIALIZA a página
	ImpCabec()
	StQuery(cNumPC)

	DbSelectArea(cAlias1)
	(cAlias1)->(DbGoTop())
	If  Select(cAlias1) > 0
		While 	(cAlias1)->(!Eof())

			dtNesc := ""
			STMAFISREL((cAlias1)->A16_FORNECE,(cAlias1)->A17_LOJA,(cAlias1)->A4_PRODUTO,(cAlias1)->A19_TES,(cAlias1)->A9_QUANT,(cAlias1)->A11_PRECO,(cAlias1)->A13_TOTAL)
			//STMAFISREL(cForn                 ,cLj                ,cProd                ,cTes              ,nQuant             ,nPrc                ,nTot)
			IF SC1->( dbSeek(xFilial('SC1')+(cAlias1)->A21_NUMSC+(cAlias1)->A22_ITEMSC) )  // Valdemir Rabelo Ticket: 20210609009719 02/07/2021
			   dtNesc := DTOC(SC1->C1_DATPRF)
			Endif 
			QuebraPagina(_nLin)

			oPrint:Say  (_nLin,010,(cAlias1)->A3_ITEM ,oFont7)

			oPrint:Say  (_nLin,040+nSpace,(cAlias1)->A4_PRODUTO,oFont7)

			oPrint:Say  (_nLin,250+nSpace,StrTran((cAlias1)->A6_XDESENH,"_","."),oFont7)

			oPrint:Say  (_nLin,330+(nSpace-5),(cAlias1)->A7_UM,oFont7)

			oPrint:Say  (_nLin,350+(nSpace-7),(cAlias1)->A8_SEGUM,oFont7)

			oPrint:Say  (_nLin,400+(nSpace-10),StrTran(cValToChar((cAlias1)->A9_QUANT),".",",") ,oFont7)

			oPrint:Say  (_nLin,450+(nSpace-10),StrTran(cValToChar((cAlias1)->A10_QTSEGUM),".",",") ,oFont7)

			oPrint:Say  (_nLin,500+(nSpace-7), AllTrim(TRANSFORM((cAlias1)->A11_PRECO,PesqPict('SC7','C7_PRECO'))) ,oFont7)

			oPrint:Say  (_nLin,570+(nSpace-10),StrTran(cValToChar((cAlias1)->A12_IPI),".",",") ,oFont7)

			oPrint:Say  (_nLin,620+(nSpace-10),AllTrim(TRANSFORM((cAlias1)->A13_TOTAL,PesqPict('SC7','C7_TOTAL'))),oFont7)

			oPrint:Say  (_nLin,670+(nSpace-10),(cAlias1)->A20_XPRAFOR,oFont7)

			oPrint:Say  (_nLin,720+(nSpace-10),(cAlias1)->A14_DATPRF,oFont7)

			oPrint:Say  (_nLin,770+(nSpace-10),dtNesc ,oFont7)                  // Valdemir Rabelo Ticket: 20210609009719 02/07/2021

			_nLin2     := _nLin
			//_ctexto    := Alltrim((cAlias1)->A5_XDESEXD)  //FR - 10/08/2022 - não estava imprimindo itens do PC
			//_ctexto    := U_STTIRAGR(_ctexto)				//FR - 10/08/2022 - não estava imprimindo itens do PC
			//------------------------------------------------------------------------------------------------//
			//Alterações realizadas:
			//FR - 10/08/2022 - Flávia Rocha - Sigamat Consultoria
			//Após a atualização de release, a query na função StQuery não trazia dados
			//em virtude de um comando de query usado para um campo memo, provavelmente pela atualização
			//o comando não é mais reconhecido, então substituí a chamada do campo por dbseek na Sb1
			//Campo: B1_XDESEXD - Descrição estendida
			//------------------------------------------------------------------------------------------------//
			SB1->(OrdSetFocus(1))
			SB1->(Dbseek(xFilial("SB1") + (cAlias1)->A4_PRODUTO ))
			_ctexto := SB1->B1_XDESEXD  //trago o campo para trazer direto da SB1
			//FR - 10/08/2022 - Correção erro na impressão dos itens - trazia em branco

			_nlinhas   := mlcount(_ctexto,_nTam)
			for _ncount:= 1 to _nlinhas
				oPrint:Say  (_nLin2 ,100, memoline(_ctexto,_nTam,_ncount),oFont7)
				If _nCount <> _nLinhas
					_nLin2 += 10
					QuebraPagina(_nLin2)
				EndIf
			next _ncount

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Finaliza a Impressão dos itens
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If _nLin2 > _nLin
				_nLin := _nLin2 + 10
			Else
				_nLin += 10
			Endif

			_nCol := 000

			QuebraPagina(_nLin)
			If !Empty(Alltrim((cAlias1)->A18_OBS))
				_cObs   += U_STTIRAGR(Alltrim((cAlias1)->A18_OBS)+' / ')
			Endif

			nTotal   := nTotal + ((cAlias1)->A13_TOTAL)

			(cAlias1)->(dbskip())

		Enddo
		(cAlias1)->(dbCloseArea())
	Endif
	_cObs := SUBSTR(_cObs, 1   ,RAT( "/"   , _cObs )-1)

	//_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,020, "Observação: "	+ _cObs ,oFont10)

	cTexto  := "Só aceitaremos a mercadoria se na sua Nota Fiscal constar o número do nosso
	cTexto1 := "Pedido de Compras. Os Pedidos de Compra e todos seus anexos serão arquivados
	cTexto2 := "eletronicamente pelo período de 5 anos."
	cTexto3 := ALLTRIM(cHrLin1)
	cTexto4 := ALLTRIM(cHrLin2)

	cTexto29 := "Os pagamentos somente serão realizados nos dias 05, 15 e 25 de cada mês ou no"
	cTexto30 := "primeiro dia útil subsequente quando não houver expediente bancário, e somente"
	cTexto31 := "através de crédito em conta corrente pertencente ao mesmo CNPJ da NF."
	cTexto32 := "Notas fiscais de serviços devem ser emitidas até o dia 25 do mês"
	cTexto33 := "(notas emitidas após este período serão recusadas)."
	
	cTexto21 := "A STECK na qualidade de CONTRATANTE, efetuará os pagamentos de forma direta e"
	cTexto22 := "exclusiva à CONTRATADA, sendo terminantemente vedado à STECK efetuar pagamentos"
	cTexto23 := "à terceiros: “factoring” ou qualquer outra instituição de interesse"
	cTexto24 := "da CONTRATADA, sendo vedada também, a cessão do título a terceiros."

	//>> Chamado 009140 - Everson Santana - 27.02.19

	cTexto25 := "Este Pedido de Compra será regido pelas Condições Gerais de Compras da Steck "
	cTexto26 := "(CGC), parte integrante como Anexo. A fornecedora terá o prazo de 48hs,"

	cTexto27 := "a contar do recebimento do pedido, para apresentar suas considerações"
	cTexto28 := "ao Pedido e seus anexos. Passado este prazo, será dado como aceito."

	/****************************************
	<<< Alteração >>>
	Ação.........: Alteração da tratativa do código da empresa, incluido a empresa 11 "Distribuidora - NewCo"
	Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
	Data.........: 07/01/2022
	Chamados.....: 20220107000493
	****************************************/
	if 	cEmpAnt == "01"    // São Paulo
		cTexto5  := "E-mail: nfe.steck@steck.com.br para envio da NF-e "
	ELSEIF cEmpAnt == "11"    // Empresa 11 - Distribuidora NewCo
		cTexto5  := "E-mail: nfe.steck@steck.com.br para envio da NF-e "
	elseif 	cEmpAnt == "03"    // Manaus
		cTexto5  := "E-mail: nfe.steckam@steck.com.br para envio da NF-e "
	endif
	
	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina

	nLinIni := _nLin

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,010, "NOTA: " + cTexto			,oFont10)
	oPrint:Say  (_nLin,425, cTexto21					,oFont10)

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,010, cTexto1						,oFont10)
	oPrint:Say  (_nLin,425, cTexto22					,oFont10)

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,010, cTexto2						,oFont10)
	oPrint:Say  (_nLin,425, cTexto23					,oFont10)

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,010, cTexto3						,oFont10)
	oPrint:Say  (_nLin,425, cTexto24					,oFont10)

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,010, cTexto4						,oFont10)
	//>> Chamado 009140
	oPrint:Say  (_nLin,425, cTexto25					,oFont10)

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,010, cTexto29					,oFont10)
	oPrint:Say  (_nLin,425, cTexto26					,oFont10)

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,010, cTexto30					,oFont10)
	oPrint:Say  (_nLin,425, cTexto27					,oFont10)

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,010, cTexto31					,oFont10)
	oPrint:Say  (_nLin,425, cTexto28					,oFont10)

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,010, cTexto32					,oFont10)
	oPrint:Say  (_nLin,425, cTexto5						,oFont11)			// Valdemir Rabelo 25/02/2020 ticket Nº 20200123000092 

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,010, cTexto33					,oFont10)

	//<<

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina

	nLinFim := _nLin

	oPrint:Line (nLinIni, 420,nLinFim, 420) // Imprime Linha Fina

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,420,"| IPI"	 ,oFont10)
	oPrint:Say  (_nLin,450,": "	+AllTrim(transform(nTotIPI,PesqPict("SC7","C7_TOTAL") )),oFont10)
	oPrint:Say  (_nLin,530,"| Frete"	 ,oFont10)
	oPrint:Say  (_nLin,578,": "	+AllTrim(transform(nTotFrete,PesqPict("SC7","C7_TOTAL") )),oFont10)
	oPrint:Say  (_nLin,640,"| Total das Mercadorias"	 ,oFont10)
	oPrint:Say  (_nLin,747,": "	+AllTrim(transform(nTotal,PesqPict("SC7","C7_TOTAL") )),oFont10)

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,420,"| ICMS"	 ,oFont10)
	oPrint:Say  (_nLin,450,": "	+AllTrim(transform(nTotIcms,PesqPict("SC7","C7_TOTAL") )),oFont10)
	oPrint:Say  (_nLin,530,"| Despesas"	 ,oFont10)
	oPrint:Say  (_nLin,578,": "	+AllTrim(transform(nTotDesp,PesqPict("SC7","C7_TOTAL") )),oFont10)
	oPrint:Say  (_nLin,640,"| Total com Impostos"	 ,oFont10)
	oPrint:Say  (_nLin,747,": "	+AllTrim(transform(nTotal+nTotIPI,PesqPict("SC7","C7_TOTAL") )),oFont10)

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,530,"| Seguro"	 ,oFont10)
	oPrint:Say  (_nLin,578,": "	+AllTrim(transform(nTotSeguro,PesqPict("SC7","C7_TOTAL") )),oFont10)
	oPrint:Say  (_nLin,640,"| Total Geral"	 ,oFont10)
	oPrint:Say  (_nLin,747,": "	+AllTrim(transform(nTotalNF,PesqPict("SC7","C7_TOTAL") )),oFont10)

	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina

	//nTotal//Total das Mercadorias
	//nTotMerc//Total com Impostos
	//nTotIPI//IPI
	//nTotIcms//ICMS
	//nTotFrete//Frete
	//nTotDesp//Despesas
	//nTotSeguro//Seguro
	//nTotalNF//Total Geral

	oPrint:EndPage()     // Finaliza a página

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpCabec     ºAutor  ³Joao Rinaldi    º Data ³  15/01/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que realiza a impressão do cabeçalho do relatório   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002103 - Layout Pedido de Compras                          º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpCabec ()

	Local _cDescCGC := ''

	_nLin := 000
	_nLin += 045
	oPrint:Box(_nLin,005,590,800)

	_nLin += 10
	If File(aBmp)
		oPrint:SayBitmap(_nLin,020,aBmp,095,050 )
	EndIf

	_nLin += 10
	oPrint:Say  (_nLin,120, _cNomeCom  ,oFont8n)
	oPrint:Say  (_nLin,400, "Razão Social: "+ Upper(Alltrim(cNome)) + " - Código/Loja: "+ cFornece + "/" + cLoja ,oFont8n)

	_nLin += 10
	oPrint:Say  (_nLin,120, Capital(Alltrim(_cEndereco)) + " - " +  Capital(Alltrim(_cBairro)) ,oFont8n)
	oPrint:Say  (_nLin,400,Capital(Alltrim(cEnd)) + " - " + Capital(Alltrim(cBairro)) ,oFont8n)

	// Chamado 005211 - Robson Mazzarotto.
	if cFilAnt == "02"
		_nLin += 10
		oPrint:Say  (_nLin,120, "Galpão Modulos B3 e B4" , oFont8n)
		oPrint:Say  (_nLin,400,"Cep: "+ SUBSTR(cCep,1,5) +"-"+SUBSTR(cCep,6,3)  +" - "+Capital(Alltrim(cMunicip)) +" - " + (Alltrim(cEst))     ,oFont8n)
		_nLin += 10
		//oPrint:Say  (_nLin,120, "da Rua Juvenal Gomes Coimbra, Famosa Rua da Goodyear." , oFont10n)
		oPrint:Say  (_nLin,400,"TEL.: (" + cDDD +") " + Alltrim(cFone) + " - FAX.: (" + cDDD +") " +Alltrim(cFax)		,oFont8n)
	Endif

	_nLin += 10
	oPrint:Say  (_nLin,120,"Cep: "+ SUBSTR(_cCep,1,5)+"-"+SUBSTR(_cCep,6,3) +" - "+Capital(Alltrim(_cCidade)) +" - " + (Alltrim(_cEstado)) ,oFont8n)
	if cFilAnt <> "02"
		oPrint:Say  (_nLin,400,"Cep: "+ SUBSTR(cCep,1,5) +"-"+SUBSTR(cCep,6,3)  +" - "+Capital(Alltrim(cMunicip)) +" - " + (Alltrim(cEst))     ,oFont8n)
	Endif

	if cFilAnt == "02"
		oPrint:Say  (_nLin,400,_cDescCGC + Transform(cCGC,PESQPICT("SA2","A2_CGC"))  + " - I.E.: "+ cInscE ,oFont8n)
	Endif

	_nLin += 10
	If cEmpAnt == "01"
		oPrint:Say  (_nLin,120,"TEL.: (011) 2248-7000 | FAX.: (011) 2248-7051",oFont8n)
	ElseIf cEmpAnt == "03"
		oPrint:Say  (_nLin,120,"TEL.: (092) 3614-8421 | FAX.: (092) 3614-8403",oFont8n)
	Endif
	if cFilAnt <> "02"
		oPrint:Say  (_nLin,400,"TEL.: (" + cDDD +") " + Alltrim(cFone) + " - FAX.: (" + cDDD +") " +Alltrim(cFax)		,oFont8n)
	Endif

	_nLin += 10
	If Len(Alltrim(cCGC)) = 14
		_cDescCGC := "CNPJ: "
	ElseIf Len(Alltrim(cCGC)) = 11
		_cDescCGC := "CPF: "
	Endif

	oPrint:Say  (_nLin,120,"CNPJ: "  + Transform(_cCGC,PESQPICT("SA2","A2_CGC")) + " - I.E.: "+ _cIe   ,oFont8n)

	if cFilAnt <> "02"
		oPrint:Say  (_nLin,400,_cDescCGC + Transform(cCGC,PESQPICT("SA2","A2_CGC"))  + " - I.E.: "+ cInscE ,oFont10n)
	Endif
	_nLin += 10
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina

	_nLin += 10
	oPrint:Say  (_nLin,015,"Pedido de Compra"	,oFont10n)
	oPrint:Say  (_nLin,090,": " + cNumPC  		,oFont10n)
	oPrint:Say  (_nLin,210,"Data Emissão"		,oFont10n)
	oPrint:Say  (_nLin,290,": " + dtoc(cEmiss)	,oFont10n)

	_nLin += 10
	oPrint:Say  (_nLin,015, "Contato" 					,oFont10n)
	oPrint:Say  (_nLin,090, ": " + Capital(cContato)	,oFont10n)
	oPrint:Say  (_nLin,210, "Local de Entrega"          ,oFont10n)
	oPrint:Say  (_nLin,290, ": " + cCident 				,oFont10n)

	_nLin += 10
	oPrint:Say  (_nLin,015, "Cond. Pagto" 		,oFont10n)
	oPrint:Say  (_nLin,090, ": " + cDescCond	,oFont10n)
	oPrint:Say  (_nLin,210, "Local de Cobrança" ,oFont10n)
	oPrint:Say  (_nLin,290, ": " + cCidcob 		,oFont10n)

	_nLin += 10
	Do Case
		Case cTpFrete == "C"
		cTpFrete := "CIF"
		Case cTpFrete == "F"
		cTpFrete := "FOB"
		Case cTpFrete == "T"
		cTpFrete := "Por conta de Terceiros"
		Case cTpFrete == "F"
		cTpFrete := "Sem Frete"
		Case Empty(cTpFrete)
		cTpFrete := "Não Informado"
	EndCase
	oPrint:Say  (_nLin,015, "Frete"				,oFont10n)
	oPrint:Say  (_nLin,090, ": "	+ (cTpFrete),oFont10n)
	oPrint:Say  (_nLin,210, "Comprador"			,oFont10n)
	oPrint:Say  (_nLin,290, ": "+Capital(Alltrim(cComprador)) + " - TEL.: " + Alltrim(cTelComprador) + " - FAX.: " + Alltrim(cFaxComprador) + " - E-MAIL.: " + Alltrim(cMailComprador) ,oFont10n)

	_nLin += 10
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina

	_nLin += 10

	oPrint:Say  (_nLin,010, RetTitle("C7_ITEM")		       ,oFont8n)
	//30
	oPrint:Say  (_nLin,040+nSpace, RetTitle("C7_PRODUTO")  ,oFont8n)
	//60
	oPrint:Say  (_nLin,100+nSpace, RetTitle("B1_XDESEXD")  ,oFont8n)
	//150
	oPrint:Say  (_nLin,250, RetTitle("B1_XDESENH")		   ,oFont8n)
	//80
	oPrint:Say  (_nLin,330+(nSpace-5), "UM"			    	   ,oFont8n)
	//20
	oPrint:Say  (_nLin,350+(nSpace-7), "2a UM"		    	   ,oFont8n)
	//50
	oPrint:Say  (_nLin,400+(nSpace-10), RetTitle("C7_QUANT")	   ,oFont8n)
	//50
	oPrint:Say  (_nLin,450+(nSpace-10), RetTitle("C7_QTSEGUM")  ,oFont8n)
	//50
	oPrint:Say  (_nLin,500+(nSpace-10), RetTitle("C7_PRECO")	   ,oFont8n)
	//70
	oPrint:Say  (_nLin,570+(nSpace-10), RetTitle("C7_IPI")	   ,oFont8n)
	//50
	oPrint:Say  (_nLin,620+(nSpace-10), RetTitle("C7_TOTAL")	   ,oFont8n)
	//50
	oPrint:Say  (_nLin,670+(nSpace-10), RetTitle("C7_XPRAFOR")  ,oFont8n)
	//50
	oPrint:Say  (_nLin,720+(nSpace-10), Left(RetTitle("C7_DATPRF"),8)   ,oFont8n)

	oPrint:Say  (_nLin,770+(nSpace-10), Left(RetTitle("C1_DATPRF"),5)   ,oFont8n)

	_nLin += 10
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina

	_nLin += 10
	_nLin2 := _nLin

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EnvMail      ºAutor  ³Joao Rinaldi    º Data ³  15/01/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que realiza o envio de e-mail                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002103 - Layout Pedido de Compras                          º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EnvMail(oGraphic,cAssunto,aTexto,cTo,cCC,aTabela,nEspacos)

	Local lOk       := .F.
	Local _cCgCSteckPdf	:= "CGC_ Ver102017BR.pdf"
	Local _aAttach  := {}
	Local cMensagem
	Local _cCaminho := cStartPath
	Local nAtt	:= 0

	If cCombo=="Sim"
		aadd( _aAttach  ,_cNomePdf+'.pdf')
		aadd( _aAttach  ,_cCgCSteckPdf)
		aadd( _aAttach  ,'comunicado_xml.pdf')
	EndIf

	For nAtt := 1 to Len(_aAttachUs)
		aadd( _aAttach  ,_aAttachUs[nAtt])
	Next nAtt

	aTexto   := IIF( aTexto == NIL,{},aTexto )
	aTabela  := IIF( aTabela == NIL,{},aTabela)
	nEspacos := IIF( nEspacos == NIL, 10, nEspacos )

	cMensagem := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">'
	cMensagem += '<HTML><HEAD>'
	cMensagem += '<META content="text/html; charset=iso-8859-1" http-equiv=Content-Type>'
	cMensagem += '<META content="MSHTML 5.00.2920.0" name=GENERATOR></HEAD>'
	cMensagem += '<BODY aLink=#ff0000 bgColor=#ffffff link=#0000ee text=#000000 '
	cMensagem += 'vLink=#551a8b><B>'

	cMensagem += "<br><font Face='Courier New' >" + "Pedido de Compra enviado automaticamente pelo sistema PROTHEUS. Comprador responsável: " + UsrFullName(RetCodUsr()) + "</font></br>"
	//cMensagem += "<br><font Face='Courier New' >" + "POR FAVOR CONFIRMAR O RECEBIMENTO DESTE APENAS NO E-MAIL: <a href='mailto:" + cCopia + "'>" + cCopia + "</a></font></br>"
	cMensagem += "<br><font Face='Courier New' >" + "Pedido de Compra nº: " + cNumPC + "</font></br><br>"

	If cEmpAnt=="01" .Or. cEmpAnt=="11"
		_cEmpresa := "São Paulo / Filial "+cFilAnt
	Else
		_cEmpresa := "Manaus / Filial "+cFilAnt
	EndIf

	cMensagem += ' Por favor siga os passos abaixo para confirmar seu pedido.
	cMensagem += ' <br><br>
	cMensagem += ' 1. Acesse o portal pelo link <a href="https://portalfornecedor.steck.com.br/login.php">https://portalfornecedor.steck.com.br/login.php</a><br>
	cMensagem += ' 2. Faça o login com o CNPJ '+SA2->A2_CGC+' pela empresa '+_cEmpresa+'<br>'
	cMensagem += ' 3. Utilize o link <a href="https://portalfornecedor.steck.com.br/editar_pedido.php?cChave='+cNumPC+'">https://portalfornecedor.steck.com.br/editar_pedido.php?cChave='+cNumPC+'</a> para acessar seu pedido.<br>
	cMensagem += ' 4. Confira os dados do seu pedido para verificar se estão corretos.<br>
	cMensagem += ' 5. Utilize o botão Imprimir pedido para confirmar o mesmo <br>

	If cEmpAnt=="03"
		cMensagem += '<br>
		cMensagem += 'Prezado fornecedor, favor considerar o Prazo Fornecedor em seu Pedido e nos informar peso e volume assim que o material ficar pronto, para estabelecermos o modal de embarque. '
		cMensagem += '<br>
	EndIf
	//cMensagem += "<br><font Face='Courier New' >" + "POR FAVOR NÃO RESPONDER ESTE E-MAIL POR SE TRATAR DE ENVIO AUTOMÁTICO, CONFIRMAR O RECEBIMENTO DESTE PEDIDO DE COMPRA APENAS NO E-MAIL DO " + "</font></br>"
	//cMensagem += "<br><font Face='Courier New' >" + "COMPRADOR RESPONSÁVEL: " + cCopia + "</font></br>"
	//cMensagem += "<br><font Face='Courier New' >" + "Enviado por: " + UsrFullName(RetCodUsr()) + "</font></br>"

	//_cMesCorp:= MsgAdic()
	_cMesCorp:= "" // Retirado a pedido da Juliana Queiroz por email. Robson Mazzarotto
	cMensagem += "<br><div align='left'><font Face='Courier New' >"+ strtran(_cMesCorp,'.',".</FONT>  </br></div>   </tr></table></br><div align='left'><font Face='Courier New' > ")    +'</FONT></div>'
	cMensagem := STRTRAN(cMensagem,'ZZZZ','.')
	cMensagem := STRTRAN(cMensagem,'AAAA',"</FONT></br>  </div>   </tr></table>  <div align='left'><br><font Face='Courier New' >")
	cMensagem += '</B>'
	cMensagem += '<BR>&nbsp;</BR>'

	cMensagem += "</CENTER>"
	cMensagem += '</body>'

	ProcRegua(8)

	IncProc()
	IncProc("Conectando servidor...")

	// Ticket - 20201203011698
	//If cEmpAnt=="03"
	//	cCopia += ";debora.rodrigues@steck.com.br"
	//EndIf

	If  !(	U_STMAILTES(cEmailFor,cCopia,ctitulo,cMensagem,_aAttach,_cCaminho)  )
		Help( " " , 1 , "ATENÇÃO" ,"Tente novamente mais tarde!" , "Falha no envio de Email" , 4 , 5 )
		//MsgInfo("Email não Enviado.....!!!!!")
	Else
		Aviso( OemToAnsi( "ATENÇÃO" ) , OemToAnsi( "Email enviado com sucesso" ) , { "Ok" } )

		_cQuery2 := " UPDATE "+RetSqlName("SC7")+" C7
		_cQuery2 += " SET C7_XENV='S'
		_cQuery2 += " WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='"+cFilAnt+"'"
		_cQuery2 += " AND C7_NUM='"+cNumPC+"'"

		TcSqlExec(_cQuery2)

	EndIf

Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ChkMail      ºAutor  ³Joao Rinaldi    º Data ³  15/01/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que realiza a caixa de texto para digitação de      º±±
±±º          ³ e-mail adicional                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002103 - Layout Pedido de Compras                          º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ChkMail()

	Local oEdit1
	Local oEdit2
	Local oEdit3
	Local aOpcAnex := {"Sim","Nao"}
	Local _lRet	:= .F.
	//cEMailFor 		:= 'joao.rinaldi@steck.com.br' + Space(200)
	Private _oDlg				// Dialog Principal

	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Envio Automático de E-Mail") FROM C(330),C(243) TO C(500),C(750) PIXEL

	// Cria Componentes Padrões do Sistema
	@ C(005),C(009) Say "Envia e-mail para o Fornecedor listado abaixo? (Separar por ';')" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

	@ C(015),C(009) Say "Para:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(015),C(040) MsGet oEdit1 Var cMailFor  Size C(200),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"

	@ C(030),C(009) Say "Cópia" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(030),C(040) MsGet oEdit2 Var cMailComprador Size C(200),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"

	@ C(045),C(009) Say "Envia anexos?" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(045),C(040) COMBOBOX oEdit3 VAR cCombo ITEMS aOpcAnex Size C(200),C(009) PIXEL OF _oDlg

	// Adicionado o botão anexar, conforme chamado 003467 Robson Mazzarotto.
	@ C(060),C(010) Button OemtoAnsi("Envia")   Size C(037),C(012) PIXEL OF _oDlg	Action Eval( { || _lRet:= .T. , _oDlg:End() }  )
	@ C(060),C(060) Button OemtoAnsi("Cancela") Size C(037),C(012) PIXEL OF _oDlg	Action(_oDlg:End())
	@ C(060),C(110) Button OemtoAnsi("Anexar")  Size C(037),C(012) PIXEL OF _oDlg	ACTION SaveAnexoPC() Of _oDlg Pixel
	@ C(060),C(160) Button OemtoAnsi("Visualizar") Size C(037),C(012) PIXEL OF _oDlg	ACTION ViewAnexoPC() Of _oDlg Pixel

	ACTIVATE MSDIALOG _oDlg CENTERED

	cEMailFor := cMailFor
	cCopia    := cMailComprador

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MsgAdic      ºAutor  ³Joao Rinaldi    º Data ³  15/01/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que captura o texto que será utilizado para envio   º±±
±±º          ³ no corpo de e-mail                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002103 - Layout Pedido de Compras                          º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MsgAdic()
	Local _cText:= ("")

	_cText := "Informamos que a partir de 18/01/2016 este será o novo layout do Pedido de Compras STECK."

Return  (alltrim(_cText))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STMAFISREL   ºAutor  ³Joao Rinaldi    º Data ³  15/01/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que realiza o cálculo dos impostos                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002103 - Layout Pedido de Compras                          º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function STMAFISREL(cForn,cLj,cProd,cTes,nQuant,nPrc,nTot)

	Local nItem		:= 0
	//MaFisSave()
	MaFisEnd()
	MaFisIni(cForn,;           // 1-Codigo Cliente/Fornecedor
	cLj ,;                     // 2-Loja do Cliente/Fornecedor
	"F",;                      // 3-C:Cliente , F:Fornecedor
	"N",;                      // 4-Tipo da NF
	"R",;                      // 5-Tipo do Cliente/Fornecedor
	{})

	// Inicia a Carga do item nas funcoes MATXFIS
	nItem++
	MaFisIniLoad(nItem)
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek('SC7')
	While !EOF() .AND. (X3_ARQUIVO == 'SC7')
		cValid	:= StrTran(UPPER(SX3->X3_VALID)," ","")
		cValid	:= StrTran(cValid,"'",'"')
		If "MAFISREF" $ cValid
			nPosRef  := AT('MAFISREF("',cValid) + 10
			cRefCols := Substr(cValid,nPosRef,AT('","MT120",',cValid)-nPosRef )
			// Carrega os valores direto do SC7.
			
			If Alltrim(SX3->X3_CAMPO) <> "C7_OPER"
				MaFisLoad(cRefCols,&("SC7->"+ SX3->X3_CAMPO),nItem)
			Endif
		EndIf
		dbSkip()
	End
	MaFisEndLoad(nItem,2)
	dbSelectArea('SC7')
	dbSkip()

	/*
	Nil,;                      //
	Nil,;                  //
	Nil,;                  //
	Nil,;                  //
	"MATA121")             // 10-Nome da rotina que esta utilizando a funcao

	MaFisAdd(cProd,;                        // 1-Codigo do Produto ( Obrigatorio )
	cTes,;                                  // 2-Codigo do TES ( Opcional )
	nQuant,;                                // 3-Quantidade ( Obrigatorio )
	nPrc,;                                  // 4-Preco Unitario ( Obrigatorio )
	0,;                                     // 5-Valor do Desconto ( Opcional )
	,;                                      // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                      // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                      // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                     // 9-Valor do Frete do Item ( Opcional )
	0,;                                     // 10-Valor da Despesa do item ( Opcional )
	0,;                                     // 11-Valor do Seguro do item ( Opcional )
	0,;                                     // 12-Valor do Frete Autonomo ( Opcional )
	nTot,;                                  // 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                     // 14-Valor da Embalagem ( Opcional )
	0,;                                     // 15-RecNo do SB1
	0)                                      // 16-RecNo do SF4
	*/
	nTotIpi    := nTotIpi    + MaFisRet(,'NF_VALIPI')
	nTotIcms   := nTotIcms   + MaFisRet(,'NF_VALICM')
	nTotDesp   := nTotDesp   + MaFisRet(,'NF_DESPESA')
	nTotFrete  := nTotFrete  + MaFisRet(,'NF_FRETE')
	nTotSeguro := nTotSeguro + MaFisRet(,'NF_SEGURO')
	nTotalNF   := nTotalNF   + MaFisRet(,'NF_TOTAL')
	//nTotMerc   := nTotalNF   + nTotIpi

	mafisend()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ StQuery      ºAutor  ³Joao Rinaldi    º Data ³  15/01/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que executa a Query do Relatório                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002103 - Layout Pedido de Compras                          º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function StQuery(_cNumPC)

	Local cQuery1     := ' '

	cQuery1 := "  SELECT "								+ CHR(13) + CHR(10)
	cQuery1 += "  C7_FILIAL  AS A1_FILIAL "				+ CHR(13) + CHR(10)
	cQuery1 += " ,C7_NUM     AS A2_NUM    "				+ CHR(13) + CHR(10)
	cQuery1 += " ,C7_ITEM    AS A3_ITEM   "				+ CHR(13) + CHR(10)
	cQuery1 += " ,C7_PRODUTO AS A4_PRODUTO "			+ CHR(13) + CHR(10)
	
	//------------------------------------------------------------------------------------------------//
	//Alterações realizadas:
	//FR - 10/08/2022 - Flávia Rocha - Sigamat Consultoria
	//Após a atualização de release, a query na função StQuery não trazia dados
	//em virtude de um comando de query usado para um campo memo, provavelmente pela atualização
	//o comando não é mais reconhecido, então substituí a chamada do campo por dbseek na Sb1
	//Campo: B1_XDESEXD - Descrição estendida
	//------------------------------------------------------------------------------------------------//
	//deixar comentada esta linha:
	//cQuery1 += " ,utl_raw.cast_to_varchar2(dbms_lob.substr(B1_XDESEXD, 10000, 1)) AS A5_XDESEXD
	//FR - 10/08/2022 - Correção erro na impressão dos itens - trazia em branco
	
	cQuery1 += " ,B1_XDESENH AS A6_XDESENH "			+ CHR(13) + CHR(10)
	cQuery1 += " ,C7_UM      AS A7_UM      "			+ CHR(13) + CHR(10)
	cQuery1 += " ,C7_SEGUM   AS A8_SEGUM   "			+ CHR(13) + CHR(10)
	cQuery1 += " ,C7_QUANT   AS A9_QUANT   "			+ CHR(13) + CHR(10)
	cQuery1 += " ,C7_QTSEGUM AS A10_QTSEGUM "			+ CHR(13) + CHR(10)
	cQuery1 += " ,C7_PRECO   AS A11_PRECO   "			+ CHR(13) + CHR(10)
	cQuery1 += " ,C7_IPI     AS A12_IPI     "			+ CHR(13) + CHR(10)
	cQuery1 += " ,C7_TOTAL   AS A13_TOTAL   "			+ CHR(13) + CHR(10)
	cQuery1 += " ,SUBSTR( C7_DATPRF,7,2)||'/'|| SUBSTR( C7_DATPRF,5,2)||'/'|| SUBSTR( C7_DATPRF,1,4) AS A14_DATPRF " + CHR(13) + CHR(10)
	cQuery1 += " ,C7_MOTIVO  AS A15_MOTIVO " 	+ CHR(13) + CHR(10)
	cQuery1 += " ,SUBSTR( C7_XPRAFOR,7,2)||'/'|| SUBSTR( C7_XPRAFOR,5,2)||'/'|| SUBSTR( C7_XPRAFOR,1,4) AS A20_XPRAFOR " + CHR(13) + CHR(10)
	cQuery1 += " ,C7_FORNECE AS A16_FORNECE "	+ CHR(13) + CHR(10)
	cQuery1 += " ,C7_LOJA    AS A17_LOJA " 		+ CHR(13) + CHR(10)
	cQuery1 += " ,C7_OBS     AS A18_OBS "		+ CHR(13) + CHR(10)
	cQuery1 += " ,C7_TES     AS A19_TES "		+ CHR(13) + CHR(10)
	cQuery1 += " ,C7_NUMSC AS A21_NUMSC "		+ CHR(13) + CHR(10)
	cQuery1 += " ,C7_ITEMSC AS A22_ITEMSC "		+ CHR(13) + CHR(10)

	cQuery1 += " FROM "+RetSqlName("SC7")+" SC7 "	+ CHR(13) + CHR(10)

	cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" SB1 " + CHR(13) + CHR(10)
	cQuery1 += " ON  SB1.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
	cQuery1 += " AND B1_COD = C7_PRODUTO " + CHR(13) + CHR(10)

	cQuery1 += " WHERE SC7.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
	cQuery1 += " AND C7_FILIAL = '"+cFilPc+"'" + CHR(13) + CHR(10)
	cQuery1 += " AND C7_NUM    = '"+(_cNumPC)+"'" + CHR(13) + CHR(10)

	cQuery1 += " ORDER BY C7_NUM, C7_ITEM " + CHR(13) + CHR(10)

	cQuery1 := ChangeQuery(cQuery1)

	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ QuebraPagina ºAutor  ³Joao Rinaldi    º Data ³  15/01/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que realiza a quebra de página do relatório         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002103 - Layout Pedido de Compras                          º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QuebraPagina(_nValor)

	If _nValor > 580
		_nValor := 590
		_nValor += 10
		oPrint:Say  (_nValor,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		ImpCabec()
	Endif

Return(_nValor)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SaveAnexoPC  ºAutor  ³Joao Rinaldi    º Data ³  07/03/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função desenvolvida para salvar anexo                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SaveAnexoPC()

	Local _cSave := ''
	Local _lRet     := .T.
	Local _cLocArq  := ''
	Local _cDir     := ''
	Local _cArq     := ''
	Local cExtensao := ''
	Local cMascara  := "Todos os arquivos"
	Local cTitulo   := "Escolha o arquivo"
	Local nMascpad  := 0
	Local cDirini   := "c:\"
	Local lSalvar   := .T. /*.F. = Salva || .T. = Abre*/
	Local lArvore   := .F. /*.T. = apresenta o árvore do servidor || .F. = não apresenta*/
	Local _cMsgSave := ""
	Local aArea1    := GetArea()

	_cLocArq  := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar,, lArvore)

	If !(Empty(_cLocArq))
		_cLocArq  := Alltrim(_cLocArq)
		_cDir     := SUBSTR(_cLocArq, 1                      ,RAT( "\"   , _cLocArq ))
		_cArq     := SUBSTR(_cLocArq, RAT( "\"   , _cLocArq ),Len(_cLocArq))
		_cArq     := StrTran(_cArq,"\","")
		cExtensao := SUBSTR(_cLocArq,Rat(".",_cLocArq),Len(_cLocArq))

		/*
		If Len(Directory(cStartPath+_cArq)) = 1
		Aviso("Seleção de Anexos"; //01 - cTitulo - Título da janela
		,"O Arquivo '"+_cArq+"' já foi anexado."+ Chr(10) + Chr(13)+;
		CHR(10)+CHR(13)+;
		"Favor selecionar um novo arquivo para ser anexado.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)

		Return
		Endif
		*/

		If At(".",cExtensao) == 1
			aadd( _aAttachUs  ,_cArq)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Copio o arquivo original da máquina do usuário para o servidor
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lSucess   := __CopyFile(_cLocArq,cStartPath+_cArq)

			If !(lSucess)
				Aviso("Problema ao Anexar Arquivo"; //01 - cTitulo - Título da janela
				,"O Arquivo '"+_cArq+"' não foi anexado."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Favor verificar com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
				,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
				)
			EndIf
		Else
			Aviso("Problema com Extensão do Anexo"; //01 - cTitulo - Título da janela
			,"A Extensão "+cExtensao+" é inválida para anexar junto a Solicitação de Compras."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
			,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
			)
		Endif
	Else
		Aviso("Anexar Arquivo"; //01 - cTitulo - Título da janela
		,"Nenhum Arquivo foi selecionado para ser anexado.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
	Endif

	RestArea(aArea1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ViewAnexoPC ºAutor  ³Joao Rinaldi     º Data ³  07/03/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para que o comprador possa visualizar os arquivos   º±±
±±º          ³ anexados e com a opção de marcar os anexos que serão       º±±
±±º          ³ excluídos                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ViewAnexoPC()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declaração das Variáveis
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local _aAnexo    := {}
	Local _nJ

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Variáveis para montagem da Tela - MsNewGetDados
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local _cTitulo     := "Relação de Anexos"
	Local aSize        := MsAdvSize(, .F., 400)
	Local aInfo        := {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	Local aObjects     := {{100, 100,.T.,.T. }}
	Local aPosObj      := MsObjSize( aInfo, aObjects,.T. )
	Local nStyle       := GD_INSERT+GD_DELETE+GD_UPDATE
	Local _aCamposEdit := {} //{"COR","D2_FILIAL","D2_DOC"}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Variáveis de Ação da MsNewGetDados
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local _aButtons    := {}
	Local _bOk         := {|| (STTOK(@_aAnexo,@oDlgCons))}
	Private _bCancel   := {|| oDlgCons:End() }

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Variáveis de Objeto e Flag da MsNewGetDados
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private oGetDados1
	Private oOk        := LoadBitmap( GetResources(), "LBOK" )//"MARCADO"
	Private oNo        := LoadBitmap( GetResources(), "LBNO" )//"DESMARCADO"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Variávies do Cabeçalho e Itens da MsNewGetDados
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private _aHeader   := {}
	//Private _aAnexo   := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tamanho de Fonte a ser exibida na Tela
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oFont13 := TFont():New("Courier New",9,24,.T.,.F.,5,.T.,5,.T.,.F.)

	If Len(_aAttachUs) >= 1
		For _nJ := 1 to Len (_aAttachUs)
			aAdd(_aAnexo,{"LBNO",;
			cValtoChar(_nJ),;
			_aAttachUs[_nJ],;
			CValtoCHar(Round(Directory(cStartPath+(_aAttachUs[_nJ]))[1,2]/1024,0)) + " KB",;
			.F.})
		Next _nJ
		STaHeader()

		Define MSDialog oDlgCons Title _cTitulo From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel

		@ aPosObj[1,1]+2,aPosObj[1,2]+5 Say "Marque os Arquivos que serão excluídos:" Of oDlgCons Pixel COLOR CLR_HBLUE FONT oFont13
		oGetDados1 := MsNewGetDados():New( aPosObj[1,1]+20      , aPosObj[1,2]+5                , aPosObj[1,3]     , aPosObj[1,4] ,              ,"AllWaysTrue","AllWaysTrue",""        , _aCamposEdit         ,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlgCons,_aHeader,_aAnexo)
		bDbClick := oGetDados1:oBrowse:bLDblClick
		oGetDados1:oBrowse:bldblClick := {|| STClick(@_aAnexo) }
		oGetDados1:oBrowse:SetFocus()

		ACTIVATE MSDIALOG oDlgCons CENTERED ON INIT EnchoiceBar(oDlgCons, _bOk, _bCancel,,_aButtons)

	Else
		Aviso("Seleção de Anexos"; //01 - cTitulo - Título da janela
		,"Não existe nenhum anexo a ser visualizado."+CHR(10)+CHR(13)+;
		CHR(10)+CHR(13)+;
		"",;//02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
	Endif

Return _aAttachUs

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STaHeader ºAutor  ³Joao Rinaldi       º Data ³  07/03/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para retornar o aHeader                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function STaHeader()

	//aAdd(_aHeader,{Título                 ,Campo         ,Picture                      ,Tamanho                  ,Decimal                   ,Validação,Reservado        ,Tipo                    ,Reservado,Reservado})
	Aadd(_aHeader,{"Flag"                   ,"XX_FLAG"     ,"@BMP"                       ,1                        ,0                         ,""       ,""               ,""                      ,"","","","",".T."})
	aAdd(_aHeader,{RetTitle("C7_ITEM")      ,"C7_ITEM"     ,PesqPict("SC7","C7_ITEM")    ,TamSx3("C7_ITEM")[1]     ,TamSx3("C7_ITEM")[2]      ,""       ,"€€€€€€€€€€€€€€€",TamSx3("C7_ITEM")[3]    ,"","","","",".T."})
	aAdd(_aHeader,{RetTitle("J4_NOMARQ")    ,"J4_NOMARQ"   ,PesqPict("SJ4","J4_NOMARQ")  ,TamSx3("J4_NOMARQ")[1]   ,TamSx3("J4_NOMARQ")[2]    ,""       ,"€€€€€€€€€€€€€€€",TamSx3("J4_NOMARQ")[3]  ,"","","","",".T."})
	aAdd(_aHeader,{"Tamanho do Arquivo"     ,"C1_QUANT"    ,"@999,999,999"               ,TamSx3("C1_QUANT")[1]    ,TamSx3("C1_QUANT")[2]     ,""       ,"€€€€€€€€€€€€€€€",TamSx3("C1_QUANT")[3]   ,"","","","",".T."})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STClick   ºAutor  ³Joao Rinaldi       º Data ³  07/03/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para validar o Clique acionado pelo usuário na tela º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function STClick(_aAnexo,oDlgCons)

	Local nPosFLAG := aScan(oGetDados1:aHeader,{|x| AllTrim(x[2]) == "XX_FLAG"})

	If oGetDados1:aCols[oGetDados1:nAt][nPosFLAG] == "LBNO" // DESMARCADO
		oGetDados1:aCols[oGetDados1:nAt][nPosFLAG] := "LBOK" // MARCADO
		oGetDados1:oBrowse:Refresh()
	Else
		oGetDados1:aCols[oGetDados1:nAt][nPosFLAG] := "LBNO" // DESMARCADO
		oGetDados1:oBrowse:Refresh()
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STTOK     ºAutor  ³Joao Rinaldi       º Data ³  07/03/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para validar a Confirmação das informações marcadas º±±
±±º          ³ na tela pelo usuário                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function STTOK(_aAnexo)

	Local nPosFLAG   := aScan(oGetDados1:aHeader,{|x| AllTrim(x[2]) == "XX_FLAG"})
	Local nPosFile   := aScan(oGetDados1:aHeader,{|x| AllTrim(x[2]) == "J4_NOMARQ"})
	Local _nK
	Local cStatus    := ''
	Local _nAnexo    := 0
	Local cTexto1    := ''
	Local cTexto2    := ''

	For _nK := 1 to Len(oGetDados1:aCols)
		IF oGetDados1:aCols[_nK][nPosFLAG] == "LBOK" // MARCADO
			_nAnexo ++
		EndIf
	Next _nK

	If (_nAnexo > 0)
		If _nAnexo == 1
			cTexto1 := "Existe apenas" + cValtoChar(_nAnexo) + " Item Selecionado."
			cTexto2 := "Deseja excluir o anexo ?"
		Else
			cTexto1 := "Existem " + cValtoChar(_nAnexo) + " Itens Selecionados."
			cTexto2 := "Deseja excluir os anexos ?"
		Endif

		If MsgYesNo(cTexto1+ Chr(10) + Chr(13) +cTexto2,"Seleção de Anexos")
			For _nK := 1 to Len(oGetDados1:aCols)
				IF oGetDados1:aCols[_nK][nPosFLAG] == "LBOK" // MARCADO
					FERASE(cStartPath+_aAttachUs[_nK])//Apaga anexos do Servidor
				EndIf
			Next _nK

			_aAttachUs := {}
			For _nK := 1 to Len(oGetDados1:aCols)
				IF !oGetDados1:aCols[_nK][nPosFLAG] == "LBOK" // MARCADO
					aadd( _aAttachUs  ,oGetDados1:aCols[_nK][nPosFile])
				EndIf
			Next _nK
		Endif

	Else
		Aviso("Seleção de Anexos"; //01 - cTitulo - Título da janela
		,"Nenhum Arquivo foi Selecionado para ser excluído."+CHR(10)+CHR(13)+;
		CHR(10)+CHR(13)+;
		"",;                          //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
	Endif

Return oDlgCons:End()


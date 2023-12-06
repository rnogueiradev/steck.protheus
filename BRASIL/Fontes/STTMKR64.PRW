#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "AP5MAIL.CH"
#Include "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ STTMKR64 ³ Autor ³ João Victor           ³ Data ³13/03/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ xImpressao DOS ORCAMENTOS GRAFICOS                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Alteração³   Giovani Zago inverti para fwmsprinter                    ³±±
±±³          ³  					                                      ³±±
±±³          ³  					                                      ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STTMKR3A()

	Local _aSemCBar := {}
	Local _nX
	Private _Lmomat := IsInCallSteck("U_STFSVE46") // .or. IsInCallSteck("TMKA380")

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	DbSelectArea('SUB')
	SUB->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	If SUB->(DbSeek(xFilial("SUB")+SUA->UA_NUM))
		While SUB->(!Eof()) .and. SUB->UB_FILIAL+SUB->UB_NUM == xFilial("SUB")+SUA->UA_NUM

			SUB->(RecLock("SUB",.F.))
			SUB->UB_ZB2QATU :=  u_versaldo(SUB->UB_PRODUTO)
			//	SUB->UB_DTENTRE  :=  u_atudtentre(SUB->UB_ZB2QATU,SUB->UB_PRODUTO,SUB->UB_QUANT)
			SUB->(MsUnlock())
			SUB->( DbCommit() )
			SUB->(DbSkip())

			If SB1->(DbSeek(xFilial("SB1")+SUB->UB_PRODUTO))
				If Empty(AllTrim(SB1->B1_CODBAR))
					AADD(_aSemCBar,{AllTrim(SB1->B1_COD),AllTrim(SB1->B1_DESC)})
				EndIf
			EndIf

		End
	Endif

	If Len(_aSemCBar)>0

		cAttach := ""
		_cEmail := GetMv("STTMKR641",,"isabella.martins@steck.com.br")
		_cCopia := ""

		_cAssunto := "[WFPROTHEUS] - Orçamento com produtos sem código de barras

		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<b>Filial: </b>'+Alltrim(SUA->UA_FILIAL)
		cMsg += '<br><b>Orçamento: </b>'+Alltrim(SUA->UA_NUM)

		cMsg += '<br><br><Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<TR BgColor=#FFFFFF>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Produto</Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Descrição</Font></B></TD>'
		cMsg += '</TR>'

		For _nX:=1 To Len(_aSemCBar)

			cMsg += '<TR BgColor=#66FF66>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+_aSemCBar[_nX][1]+'</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+_aSemCBar[_nX][2]+'</Font></B></TD>'
			cMsg += '</TR>'

		Next

		cMsg += '</Table>'
		cMsg += '</body></html>'

		U_STMAILTES(_cEmail,_cCopia,_cAssunto,cMsg,cAttach)

	EndIf

	If IsBlind()
		Return
	EndIf

	U_STFAT061("1") //Verificar se existem produtos sem custo

	If (M->UA_XBLOQ == "1" )
		cMsg := "O orçamento encontra-se bloqueado e portanto não será possível enviar o relatório de Cotação ao Cliente."
		cMsg += " Entre em contato com seu supervisor para que o mesmo libere este Orçamento!"
		//Alert(cMsg)
		Return .F.
	Else
		DbSelectArea('ZZI')
		ZZI->(DbGoTop())
		ZZI->(DbSetOrder(3))
		If ZZI->(DbSeek(xFilial("ZZI")+M->UA_NUM))
			If ZZI->ZZI_BLQ = '2' .Or. ZZI->ZZI_BLQ = '3'
				cMsg := "O orçamento encontra-se bloqueado e portanto não será possível enviar o relatório de Cotação ao Cliente."
				cMsg += " Entre em contato com seu supervisor para que o mesmo libere este Orçamento!"
				//Alert(cMsg)
				Return .F.
			ElseIf !_Lmomat
				u_STTMKR64()
			EndIf

		ElseIf !_Lmomat
			u_STTMKR64()
		EndIf
	Endif

Return()

User Function STTMKR64()

	LOCAL   n := 0
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
	PRIVATE _cTipoCli 	  := "SUA->UA_XTIPO"
	PRIVATE		cCopia    := Alltrim(Lower(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND2,"A3_EMAIL"))) +';'+Alltrim(Lower(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_EMAIL")))
	PRIVATE		titulo	  := "Envio de E-Mail Cotação nº: " + SUA->UA_NUM + " - STECK INDÚSTRIA ELÉTRICA"
	PRIVATE cBmpName  	  :=''
	PRIVATE cStartPath 	  := '\arquivos\orcamento\'//GetSrvProfString("Startpath","") +'orcamento\'
	PRIVATE _cPath		  := GetSrvProfString("RootPath","") //GetPvProfString( GetEnvServer(), "RootPath"	, "", GetAdv97() )
	PRIVATE _cNomePdf     :=''
	Private _cDirRel      := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private _lxRet         := .T.

	DbSelectArea("SUA")

	Processa({|lEnd|xMontaRel()})

Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MontaRel ³ Autor ³ João Victor           ³ Data ³13/02/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao DO RELATORIO                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xMontaRel()

	Private _lPilha:= .F.
	Dbselectarea("SUA")
	MsSeek(Xfilial("SUA") + SUA->UA_NUM  )

	if SUA->(eof())

		msgstop("Orcamento Nao Encontrado !!!  Verifique !!! " )

	else

		_cNomePdf  :=cEmpAnt+"_Orcamento_"+SUA->UA_NUM
		oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , '\arquivos\orcamento\'  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
		oPrint:SetLandScape()     //SetPortrait() ou SetLandscape()
		oPrint:SetMargin(60,60,60,60)
		oPrint:setPaperSize(9)

		DbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+ SUA->UA_CLIENTE + SUA->UA_LOJA ))

		Dbselectarea("SE4")
		MsSeek(Xfilial("SE4")  + SUA->UA_CONDPG )

		Dbselectarea("SUA")

		xImpress()

		// Indique o caminho onde será gravado o PDF
		FERASE(cStartPath+_cNomePdf+".pdf")
		oPrint:cPathPDF := cStartPath//"c:\"
		oPrint:Print()
		//FERASE('c:\'+_cNomePdf+".pdf")
		//CpyS2T(cStartPath+_cNomePdf+'.pdf','c:\',.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
		//ShellExecute("open",'C:\'+_cNomePdf+'.pdf', "", "", 1)

		If ExistDir(_cDirRel)
			_lxRet := .T.
		Else
			If MakeDir(_cDirRel) == 0
				MakeDir(_cDirRel)
				Aviso("Criação de Pasta","Fora criado nesse computador uma pasta para que as Cotações emitidas lá sejam salvas após a impressão...!!!"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"Segue o caminho do diretório criado:"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				_cDirRel,;
				{"OK"},3)
				_lxRet := .T.
			Else
				Aviso("Erro na Criação de Pasta","Para salvar a Cotação em questão é necessário que uma pasta seja criada nesse computador...!!!"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"Favor entrar em contato com o TI para que a criação da pasta seja realizada...!!!:"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"Não será possível realizar a abertura da Cotação em arquivo PDF e consequentemente não será enviado via e-mail ao cliente...!!!",;
				{"OK"},3)
				_lxRet := .F.
			Endif
		Endif
		_lPilha:=.f.
		If _lxRet
			FERASE(_cDirRel+"\"+_cNomePdf+".pdf")
			CpyS2T(cStartPath+_cNomePdf+'.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
			ShellExecute("open",_cDirRel+"\"+_cNomePdf+'.pdf', "", "", 1)

			DbSelectArea('SUB')
			SUB->(DbSetOrder(1))
			If SUB->(DbSeek(xFilial("SUB")+SUA->UA_NUM))
				While SUB->(!Eof()) .and. SUB->UB_FILIAL+SUB->UB_NUM == xFilial("SUB")+SUA->UA_NUM

					If Alltrim(SUB->UB_PRODUTO) $ GetMv("ST_PILHAMA",,"PA15AAA2/PA15AAA4/PA15AA2/PA15AA4/PA15C2/PA15D2/PA09V") 
						_lPilha:= .T.
					EndIf
					SUB->(DbSkip())
				End
			EndIf


			If _lPilha
				FERASE(_cDirRel+"\Manual_de_Comercializao_Pilhas.pdf")
				CpyS2T('manual\Manual_de_Comercializao_Pilhas.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
				ShellExecute("open",_cDirRel+"\Manual_de_Comercializao_Pilhas.pdf", "", "", 1)
			EndIf
			If MsgBox("Envia e-mail ao cliente?","Envio de E-Mail","YESNO")

				U__xlChkMail() // Abre tela Para Digitar Manualmente E-Mails




				Processa({|lEnd| xBrEnvMail(oPrint,"Cotação: "+ SUA->UA_NUM,{"Cotação: "+ SUA->UA_NUM},cEmailFor,"",{},10)},titulo)

			Endif
		Endif

	EndIf

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ xImpress ³ Autor ³ João Victor           ³ Data ³13/03/13  ³±±
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
	Local _nTotal		:= 0
	Local _nTotSuf		:= 0
	Local _ncount:= 1
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
	Dbselectarea("SUB")
	Dbsetorder(1)
	Dbseek(xfilial("SUB")+SUA->UA_NUM)

	Do While !eof()  .and. SUA->UA_NUM == SUB->UB_NUM

		Dbselectarea("SUA")
		MsSeek(Xfilial("SUA") + SUB->UB_NUM  )

		DbSelectArea("SA1")
		DbSetOrder(1)
		MsSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA)

		Dbselectarea("SUB")
		Dbsetorder(1)
		MsSeek(xfilial("SUB")+SUA->UA_NUM)

		If !Eof()
			If _nLin > 580
				If _npagina <> 0
					_npagina++
					oPrint:EndPage()
				EndIf
				oPrint:StartPage()     // INICIALIZA a página
				xCabOrc()
			EndIf
		EndIf

		Do while SUB->(!eof()) .and. SUB->UB_NUM == SUA->UA_NUM //Ajustado Renato - Não estava imprindo cotação com um item - 301013

			STMAFISREL()
			_nTotIPI    := (nValIPI)+_nTotIPI
			_nTotICMSST := (nValICMSST)+_nTotICMSST
			_nTotSuf	:= (nValSuf)+_nTotSuf

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
			MsSeek(xFilial("SB1")+SUB->UB_PRODUTO)

			// Posiciona No Cad De TES
			DbSelectArea("SF4")
			DbSetOrder(1)
			MsSeek(xFilial("SF4") + SUB->UB_TES,.t.)

			_nXmargSf7:= Posicione('SF7',4,xFilial("SF7")+SB1->B1_GRTRIB+&_cxCliContr+&_cCliEst+&_cTipoCli,'F7_MARGEM')

			IF SUB->UB_NUM <> 'N'

				//Impressao do Item
				oPrint:Say  (_nLin,020, SUB->UB_ITEM	,oFont8)

				//Impressao do Codigo e Descricao do Produto
				oPrint:Say  (_nLin,040, SUB->UB_produto	,oFont8)
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
				oPrint:Say  (_nLin,280, transform(SUB->UB_QUANT,"@E 999999.99")	,oFont8)
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
				oPrint:Say  (_nLin,350, transform(SUB->UB_VRUNIT	,"@E 999,999.99")	,oFont8)

				//Impressao do Percentual de IPI
				oPrint:Say  (_nLin,390, transform(nAliqIPI 	,"@E 999.99")		,oFont8) //SUB->UB_ZIPI

				//Impressao do Percentual de ICMS
				oPrint:Say  (_nLin,420, transform(nAliqICM,"@E 999.99")		,oFont8) //SUB->UB_ZPICMS

				//Impressao do Percentual de IVA
				oPrint:Say  (_nLin,450, transform(_nXmargSf7	,"@E 999.99")	   		,oFont8)

				//Impressao do Valor de ICMS-ST
				oPrint:Say  (_nLin,490, transform((nValICMSST)	,"@E 99,999,999,999.99")		,oFont8) //SUB->UB_ZVALIST

				//Impressao do Valor Total
				oPrint:Say  (_nLin,550, transform(SUB->UB_VLRITEM	,"@E 9,999,999.99")	,oFont8)
				_nTotal	+= SUB->UB_VLRITEM

				//Impressao do Prazo de Entraga
				oPrint:Say  (_nLin,720, transform(CVALTOCHAR(U_STGETPRZ(SUB->UB_PRODUTO,SUB->UB_QUANT,"1"))+" dias corridos"				  	,"@!")	            ,oFont8)
				//oPrint:Say  (_nLin,720, transform(CVALTOCHAR(Posicione("ZZO",1,xFilial("ZZO")+Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_ZCODOL"),"ZZO_PRAZO"))+" dias corridos"				  	,"@!")	            ,oFont8)

				//Impressao do NCM
				oPrint:Say  (_nLin,600, transform(SUB->UB_ZNCM  	,"@R 9999.99.99")	,oFont8)

				//Impressao da Ordem de Compra por Item
				oPrint:Say  (_nLin,660, transform(SUB->UB_XORDEM  	,"@!")	            ,oFont8)

			Endif

			_nLin+=15

			If _nLin > 580
				_nLin+=10
				oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
				oPrint:EndPage()     // Finaliza a página
				oPrint:StartPage()     // INICIALIZA a página
				xCabOrc()
			Endif
			SUB->(DbSkip())
		Enddo

		Dbselectarea("SUB")
		SUB->(DbSkip())

	Enddo

	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	oPrint:Line (_nLin, 005,_nLin,800)
	// Imprime Total Do Orcamento
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	oPrint:Say  (_nLin,550, "Valor Total dos Produtos (" + _cDMoed + ")"	,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(/*SUA->UA_VALMERC*/_nTotal,"@E 9999,999.99")	,oFont10)
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	oPrint:Say  (_nLin,550, "Valor Total IPI (" + _cDMoed + ")"			,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(_nTotIPI,"@E 9999,999.99")	,oFont10)
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	oPrint:Say  (_nLin,550, "Valor Total ICMS-ST (" + _cDMoed + ")"		,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(_nTotICMSST,"@E 9999,999.99")	,oFont10)
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
	oPrint:Say  (_nLin,550, "Valor Total do Orçamento (" + _cDMoed + ")"	,oFont10)
	//oPrint:Say  (_nLin,680, ": " + Transform(SUA->UA_VLRLIQ,"@E 9999,999.99")	,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(/*SUA->UA_VLRLIQ*/_nTotal+_nTotIPI+_nTotICMSST-_nTotSuf,"@E 9999,999.99")	,oFont10)
	//oPrint:Say  (_nLin,680, ": " + Transform(SUA->UA_VLRLIQ+_nTotICMSST,"@E 9999,999.99")	,oFont10) //Renato 050913 - Solicitado somar o ICMS-ST
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
	oPrint:Say  (_nLin,070, ": " + SUA->UA_ZOBS 				,oFont10)
	_nLin+=15
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	_nLin+=15//Chamado 008052 - Everson Santana
	oPrint:Say  (_nLin,070, " Faturamento mínimo para compra À vista R$ 600,00 / 21 dias R$ 1.200,00 / 28 dias R$ 1.500,00 " 				,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	// Inicia Mensagens Do Orcamento
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	// Imprime Vendedor
	//>> Chamado 008924 - Everson Santana - 29.01.2019
	_cVend1 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND2,"A3_NOME"))
	oPrint:Say  (_nLin,020, "Vendedor Interno"							,oFont10)
	oPrint:Say  (_nLin,100, ": " + Capital(_cVend1)				,oFont10)

	_cVend1Ex := Alltrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_NOME"))
	oPrint:Say  (_nLin,220, "Vendedor Externo"							,oFont10)
	oPrint:Say  (_nLin,300, ": " + Capital(_cVend1Ex)				,oFont10)

	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_cVend2 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND2,"A3_TEL"))
	oPrint:Say  (_nLin,020, "Telefone"							,oFont10)
	oPrint:Say  (_nLin,100, ": " + Capital(_cVend2)				,oFont10)

	_cVend2Ex := Alltrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_TEL"))
	oPrint:Say  (_nLin,220, "Telefone"							,oFont10)
	oPrint:Say  (_nLin,300, ": " + Capital(_cVend2Ex)				,oFont10)

	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_cVend4 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND2,"A3_EMAIL"))
	oPrint:Say  (_nLin,020, "E-mail"							,oFont10)
	oPrint:Say  (_nLin,100, ": " + lower(_cVend4)				,oFont10)

	_cVend4Ex := Alltrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_EMAIL"))
	oPrint:Say  (_nLin,220, "E-mail"							,oFont10)
	oPrint:Say  (_nLin,300, ": " + lower(_cVend4Ex)				,oFont10)

	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	/*
	_cVend1 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND2,"A3_NOME"))
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
	_cVend2 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND2,"A3_TEL"))
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
	_cVend3 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND2,"A3_FAX"))
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
	_cVend4 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND2,"A3_EMAIL"))
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
	*/
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina

	oPrint:EndPage()     // Finaliza a página

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³xCabOrc   ºAutor  ³ João Victor        º Data ³ 13/02/13    º±±
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

	oPrint:Box(045,005,580,800)

	If File(aBmp)
		oPrint:SayBitmap(060,020,aBmp,095,050 )
	EndIf

	oPrint:Say  (065,120, _cNomeCom  ,oFont12)
	oPrint:Say  (080,120, _cEndereco ,oFont12)
	oPrint:Say  (095,120,"CEP: "+ SUBSTR(cCep,1,5)+"-"+SUBSTR(cCep,6,3) +" - "+Alltrim(cCidade)+" - "+cEstado,oFont12)
	oPrint:Say  (110,120,"TEL.: (11) 2248-7000 | FAX.: (11) 2248-7051 | E-MAIL: contato.vendas@steck.com.br",oFont12)

	dbselectarea("SA1")
	MsSeek(Xfilial("SA1")  + SUA->UA_CLIENTE + SUA->UA_LOJA )

	oPrint:Box(125,005,230,800)

	oPrint:Say  (140,020,"Empresa: "+ Upper(SA1->A1_NOME)         									,oFont12)
	oPrint:Say  (155,020,"Código de Cliente: "+ SUA->UA_CLIENTE + " - " + SUA->UA_LOJA				,oFont12)

	oPrint:Say  (170,020,"Dados de Faturamento: " 													,oFont12)
	oPrint:Say  (185,020,Upper(Alltrim(SA1->A1_END) + " - " + Alltrim(SA1->A1_BAIRRO) + " - " + Alltrim(SA1->A1_MUN) + " - " + Alltrim(SA1->A1_EST) + " - " + Alltrim(SA1->A1_CEP))         					,oFont12)
	oPrint:Say  (200,020,TRANSFORM(SA1->A1_CGC,PESQPICT("SA1","A1_CGC"))			        			,oFont12)
	oPrint:Say  (215,020,"I.E.: "+ SA1->A1_INSCR 											   			,oFont12)

	oPrint:Box(230,005,295,800)
	cBmpName  :=SUA->UA_NUM
	oPrint:Say  (245,020,"Atendimento"					,oFont12)
	oPrint:Say  (245,080,": " + SUA->UA_NUM				,oFont12)
	oPrint:Say  (245,220,"Emissão" 						,oFont12)
	oPrint:Say  (245,310,": " + dtoc(SUA->UA_EMISSAO)	,oFont12)

	dbselectarea("SU5")
	MsSeek(Xfilial("SU5")  + SUA->UA_CODCONT )
	dbselectarea("SQB")
	MsSeek(Xfilial("SQB")  + SU5->U5_DEPTO )

	_cDepto:=SQB->QB_DESCRIC
	//Giovani Zago 10/03/2014
	oPrint:Say  (245,420,"Tel.Conta." 						,oFont12)
	oPrint:Say  (245,540,": " + SU5->U5_FCOM1	,oFont12)

	oPrint:Say  (260,020, "Contato" 							,oFont12)
	oPrint:Say  (260,080, ": " + Capital(SU5->U5_CONTAT)		,oFont12)
	oPrint:Say  (260,220, "Departamento"						,oFont12)
	oPrint:Say  (260,310, ": " + (_cDepto)					,oFont12)

	dbselectarea("SE4")
	MsSeek(Xfilial("SE4")  + SUA->UA_CONDPG )

	oPrint:Say  (275,020, "Cond. Pagto" 						,oFont12)
	oPrint:Say  (275,080, ": " + SE4->E4_DESCRI				,oFont12)
	oPrint:Say  (275,220, "Ordem de Compra" 					,oFont12)
	oPrint:Say  (275,310, ": "+ SUA->UA_XORDEM				,oFont12)

	IF SUA->UA_TPFRETE = "F"
		_cFrete = "FOB"
	Else
		_cFrete = "CIF"
	Endif

	oPrint:Say  (290,020, "Frete"						,oFont12)
	oPrint:Say  (290,080, ": "	+ (_cFrete)			,oFont12)
	oPrint:Say  (290,220, "Validade"					,oFont12)
	oPrint:Say  (290,310, ": "+dtoc(SUA->UA_DTLIM)	,oFont12)

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
	oPrint:Say  (310,720, "Prazo Entrega"			,oFont10)
	oPrint:Say  (310,600, "Clas. Fiscal"			,oFont10)
	oPrint:Say  (310,660, "Ordem/Produto"			,oFont10)

	_nLin := 330

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³xBrEnvMail³ Autor ³ João Victor           ³ Data ³13/03/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio Do Orcamento/Cotacao por e-mail automaticamente      ³±±
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

	cMensagem += "<br><font Face='CALIBRI' >" + "Cotação enviada automaticamente pelo sistema PROTHEUS" + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "Enviado por: " + UsrFullName(RetCodUsr()) + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "ATENÇÃO!!! AO RESPONDER ESSE E-MAIL FAVOR COPIAR A TODOS OS ENVOLVIDOS NO MESMO!!!" + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "Cotação nº: " + SUA->UA_NUM + "</font></br>"

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³_xlChkMail³ Autor ³ João Victor           ³ Data ³13/03/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Caixa De Texto Para Digitação De E-Mail Opcional.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function _xlChkMail()

	//Variaveis Locais da Funcao
	Local oEdit1
	Local _lRet		:= .f.
	cEMailFor 		:= Alltrim(Lower(SU5->U5_EMAIL)) + Space(200)

	// Variaveis Private da Funcao
	Private _oDlg				// Dialog Principal
	Private INCLUI := .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao

	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Envio Automático de E-Mail") FROM C(330),C(243) TO C(449),C(721) PIXEL

	// Cria Componentes Padroes do Sistema
	@ C(008),C(009) Say "Envia e-mail para Cliente listado abaixo? (Separar por ';')" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(021),C(010) MsGet oEdit1 Var cEMailFor Size C(218),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
	@ C(044),C(137) Button OemtoAnsi("Envia") Size C(037),C(012) PIXEL OF _oDlg	Action Eval( { || _lRet:= .t. , _oDlg:End() }  )
	@ C(044),C(185) Button OemtoAnsi("Cancela") Size C(037),C(012) PIXEL OF _oDlg	Action(_oDlg:End())

	ACTIVATE MSDIALOG _oDlg CENTERED

Return(_lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()      ³ Autor ³ Norbert Waage Junior  ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolução horizontal do Monitor do Usuario.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso        ³ Especifico Steck                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function xC(nTam)
	Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor
	Do Case
		Case nHRes == 640	//Resolucao 640x480
		nTam *= 0.8
		Case nHRes == 800	//Resolucao 800x600
		nTam *= 1
		OtherWise			//Resolucao 1024x768 e acima
		nTam *= 1.28
	EndCase
	If "MP8" $ oApp:cVersion
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para tema "Flat"³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³STMAFISREL³ Autor ³ João Victor           ³ Data ³13/03/13  ³±±
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
	MaFisIni(SUA->UA_CLIENTE,;	// 1-Codigo Cliente/Fornecedor
	SUA->UA_LOJA ,;			// 2-Loja do Cliente/Fornecedor
	"C",;					// 3-C:Cliente , F:Fornecedor
	"N",;					// 4-Tipo da NF
	SUA->UA_XTIPO,;			// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")                                                               // 10-Nome da rotina que esta utilizando a funcao

	MaFisAdd(SUB->UB_PRODUTO,;                                               // 1-Codigo do Produto ( Obrigatorio )
	SUB->UB_TES,;                                                            // 2-Codigo do TES ( Opcional )
	SUB->UB_QUANT,;                                                          // 3-Quantidade ( Obrigatorio )
	SUB->UB_VRUNIT,;                                                         // 4-Preco Unitario ( Obrigatorio )
	0,;                														 // 5-Valor do Desconto ( Opcional )
	,;                                                                       // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                       // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                       // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                      // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                      // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                      // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                      // 12-Valor do Frete Autonomo ( Opcional )
	SUB->UB_VLRITEM,;														 // 13-Valor da Mercadoria ( Obrigatorio )
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
	Local _cText:= ("CONDIÇÕES GERAIS DE VENDA PARA PRODUTOS E SERVIÇOS"+;
	"AAAA"+;
	"PCOM_003_01 - Revisão: 1"+;
	"AAAA"+;
	"01 de Abril de 2013"+;
	"AAAA"+;
	"1º INTRODUÇÃO:"+;
	"AAAA"+;
	"1-1: As Condições Gerais de Venda, doravante denominadas CGV, constituem condições comerciais, técnicas e jurídicas "+;
	"básicas para o FORNECIMENTO de produtos e/ou serviços pela STECK INDÚSTRIA ELÉTRICA LTDA, doravante denominada "+;
	"STECK, e serão aplicadas sempre que referidas como anexo nas propostas, acordos ou quaisquer contratos para "+;
	"FORNECIMENTO de produtos e serviços da STECK. As presentes CGV são aplicáveis sem prejuízo da aplicação de "+;
	"condições específicas que venham a ser mutuamente ajustadas entre as PARTES. "+;
	"1-2: Quaisquer disposições em contrário às presentes CGV, que não tenham sido objeto de acordo, por escrito com a "+;
	"STECK, não criarão nenhuma obrigação para a STECK, que se obriga exclusivamente pelas cláusulas destas CGV, de sua "+;
	"proposta e do instrumento contratual assinado entre a STECK e o CLIENTE. Na ausência de condições específicas "+;
	"mutuamente acordadas entre as PARTES, as disposições das presentes CGV serão as únicas aplicáveis ao FORNECIMENTO."+;
	"1-3: Para efeito das presentes CGV, considerar-se-ão:. "+;
	"Produtos - Todas as peças, equipamentos, materiais, partes, componentes, sistemas ou quaisquer outras referências de "+;
	"PRODUTOS entregues pela STECK, seus subfornecedores e/ou subcontratados, ao CLIENTE. Sendo eles: Caixas de "+;
	"Passagem e Distribuição, Comando e Proteção (disjuntores, relés, contatores, etc), Plugues e Tomadas - Uso "+;
	"Industrial/Comercial/Residencial, Produtos para displays, Quadros de Distribuição, Unidades Combinadas e Bloqueios "+;
	"Mecânicos."+;
	"Serviços - Toda prestação contratada pelo CLIENTE que envolva pré-montagem, montagem, instalação, "+;
	"acompanhamento, supervisão, testes, comissionamento, manutenção, construção ou quaisquer outras referências de "+;
	"SERVIÇOS prestados pela STECK, seus subfornecedores e/ou subcontratados ao CLIENTE."+;
	"Fornecimento – Todos os PRODUTOS e/ou SERVIÇOS, conforme o caso, contratados pelo CLIENTE, e que serão objeto de "+;
	"entrega ou prestação pela STECK, seus subcontratados e/ou subfornecedores."+;
	;
	"2: CARACTERÍSTICAS DOS PRODUTOS, SERVIÇOS E CONDIÇÕES DE FORNECIMENTO:."+;
	"2-1: As quantidades e características dos produtos e serviços objeto do FORNECIMENTO determinar-se-ão pela proposta."+;
	"Nenhuma responsabilidade ou obrigação terá a STECK no que concerne a produtos e serviços que não tenham sido "+;
	"orçados ou que não constem da confirmação do pedido."+;
	"2-2: Todas as informações e dados constantes de documentos anexos à proposta tais como catálogos, fotografias, "+;
	"desenhos, referências técnicas, pesos, medidas e listas de preços, são apenas exemplificativos e somente poderão ser "+;
	"considerados como vinculantes das características do FORNECIMENTO contratado nas suas partes e características que "+;
	"forem expressamente referidas na proposta."+;
	"2-3: Os materiais e seus respectivos fabricantes constantes na proposta são dados apenas como referência para projeto e "+;
	"fabricação. Em casos de dificuldades de aquisição, particularmente por razões de disponibilidade, a STECK reserva-se no "+;
	"direito de substituí-los por outros tecnicamente equivalentes."+;
	;
	"3: VALIDADE DA PROPOSTA:."+;
	"3-1: O prazo de validade das condições técnicas e comerciais será o previsto na proposta ou, caso a proposta não tenha "+;
	"estabelecido prazo, ficará este fixado em 07 (sete) dias corridos contados da apresentação. Após este prazo, as condições "+;
	"deverão ser renegociadas e uma nova proposta deverá ser apresentada."+;
	"3-2: A validade de qualquer proposta apresentada pela STECK, sob qualquer forma, ficará condicionada à aprovação ou "+;
	"confirmação do cadastro e respectivo limite de crédito do CLIENTE podendo eventualmente ser solicitadas garantias de "+;
	"pagamento, sem ônus para a STECK."+;
	;
	"4: PREÇO, REAJUSTE E CONDIÇÕES DE PAGAMENTO:."+;
	"Os preços dos produtos e serviços da STECK são resultantes das estimativas de custos, condições de proposta, condições "+;
	"de política econômica do país e legislação tributária vigente na sua data-base."+;
	"Os preços estarão sujeitos a reajuste, sempre na menor periodicidade permitida pela legislação contada a partir da data "+;
	"da proposta, pela variação do IGPM-FGV, ou outro índice equivalente que venha a substituí-lo."+;
	"O pagamento dos produtos ou serviços será efetuado de acordo com as condições estabelecidas em cada Pedido de "+;
	"Compra aceito pela STECK, através de rede bancária autorizada."+;
	"Considera-se como início de contagem do prazo de pagamento a data de emissão da nota fiscal de faturamento."+;
	"No caso de atrasos de pagamentos, sem prejuízo do direito da STECK de suspender a execução do FORNECIMENTO, o "+;
	"CLIENTE ficará sujeito a aplicação de multa de 2% (dois por cento) ao mês, correção monetária pelo IGP-M-FGV e juros de "+;
	"mora de 1% (um por cento) ao mês pro rata die, todos calculados sobre o valor em atraso. Tais encargos serão devidos a "+;
	"partir do primeiro dia de atraso e até o efetivo pagamento, independentemente de qualquer notificação judicial ou "+;
	"extrajudicial."+;
	;
	"5: PRAZOS DE ENTREGA:."+;
	"Os pedidos serão entregues de acordo com as condições acordadas e com a disponibilidade do estoque da STECK."+;
	"O CLIENTE terá um prazo máximo de 05 (cinco) dias após ter recebido o produto para comunicar a STECK qualquer "+;
	"divergência em relação ao Pedido. A STECK, por sua vez, compromete-se a corrigir as não conformidades dentro do "+;
	"menor prazo possível."+;
	"Eventuais devoluções, contatar o vendedor responsável porem somente serão aceites após a aprovação da diretoria "+;
	"comercial. Não serão aceitas devoluções de produtos fabricados especialmente para atender às necessidades do CLIENTE "+;
	"e/ou produtos com embalagem danificada."+;
	;
	"6: INSPEÇÕES:."+;
	"No caso do CLIENTE desejar que o material seja submetido à inspeção, deverá fazer solicitação durante a negociação do "+;
	"pedido, indicando nesta oportunidade os tipos de provas desejadas. A STECK informará sobre a disponibilidade da "+;
	"inspeção e os custos envolvidos a serem cobrados para cada prova requerida."+;
	;
	"7: PATENTES E DIREITOS DE PROPRIEDADE INDUSTRIAL."+;
	"O direito de propriedade sobre estudos, projetos, relatórios, manuais, desenhos e demais elementos técnicos "+;
	"eventualmente entregues pela STECK ao CLIENTE, inclusive aqueles que venham a ser desenvolvidos em razão do "+;
	"FORNECIMENTO, permanecerão com a STECK. Tais documentos pertencentes à STECK devem ser considerados como "+;
	"confidenciais, motivo pelo qual o CLIENTE deverá manter sigilo quanto a eles, não os transmitindo ou entregando-os a "+;
	"terceiros, salvo com prévia e expressa autorização por escrito da STECK. Da mesma forma, a STECK obriga-se a manter "+;
	"sigilo quanto a desenhos e informações técnicas que sejam recebidos do CLIENTE e declarados por este como "+;
	"confidenciais."+;
	"O CLIENTE terá uma licença limitada, não exclusiva para utilização de desenhos e demais elementos técnicos da STECK "+;
	"relativos ao FORNECIMENTO somente para os fins específicos de operação e manutenção do FORNECIMENTO. Em caso "+;
	"de rescisão do FORNECIMENTO por inadimplemento do CLIENTE fica revogada a licença estabelecida nesta cláusula."+;
	;
	"8: SOLICITAÇÃO DOS PEDIDOS:."+;
	"Os meios para solicitação dos Pedidos de Compra são:."+;
	"e-mail: do vendedor responsável pelo cliente."+;
	"Telefone: 11 2248-7000 ou 0800-12-20-22 fora da Grande São Paulo."+;
	"Fax: 11 2248-7051 11-2248-7069."+;
	"Correio: Avenida Luis Stamatis, 716, Cep: 02260-001, Jaçanã – São Paulo – SP."+;
	;
	"9: ACEITAÇÃO:."+;
	"A STECK analisará os Pedidos de Compra solicitados, e em caso de divergências envolvendo referencia do produto, preço, "+;
	"prazo de entrega, condições de pagamento ou de entrega, informará a empresa compradora para os devidos acertos."+;
	"Devido aos custos com a análise dos pedidos, separação e entrega de produtos, cada solicitação de compra deverá "+;
	"respeitar um valor mínimo descrito no orçamento e que é de R$ 800,00 (Oitocentos reais). Para valores inferiores, a "+;
	"STECK sugere que o CLIENTE adquira os produtos diretamente na rede de Distribuidores Autorizados, que estão "+;
	"localizados em todo o território Nacional."+;
	"Caso o CLIENTE discorde destas alterações, esta deverá informar à STECK em até 24 (vinte e quatro) horas, contadas a "+;
	"partir do recebimento da Confirmação, para que seja possível suspender o faturamento até que as divergências sejam "+;
	"negociadas."+;
	;
	"10: ALTERAÇÕES/CANCELAMENTOS:."+;
	"Eventuais cancelamentos ou alterações de Pedidos deverão ser solicitados diretamente através do e-mail do vendedor "+;
	"responsável pelo cliente ou do fax 11 2248-7051."+;
	"O prazo máximo para solicitações de cancelamentos é de dois dias contados da data de confirmação do pedido."+;
	;
	"11: PRAZOS PARA FATURAMENTO:."+;
	"Eventualmente alguns pedidos registrados na STECK, podem sofrer alterações nos prazos de faturamento, porém, o "+;
	"cliente será informado antecipadamente via e-mail ou telefone sobre a nova data."+;
	;
	"12: GARANTIA:."+;
	"O prazo de garantia contra defeitos de fabricação, devidamente comprovado, é de 12 (doze) meses a contar da data da "+;
	"Nota Fiscal de faturamento."+;
	"A garantia se aplica para produtos entregues em nossa fábrica e não abrangerá estragos e avarias decorrentes de "+;
	"acidentes, instalações inadequadas ou ocorrências causadas por terceiros. Exclui-se também da garantia o desgaste "+;
	"devido ao uso intensivo dos materiais e que ultrapassem a vida elétrica ou mecânica especificada em catálogo, danos "+;
	"causados por negligência, imperícia ou imprudência na manutenção, uso impróprio ou inadequado, armazenagem "+;
	"inadequada e motivos de força maior ou caso fortuito."+;
	"No caso de eventuais defeitos de fabricação ocorridos durante o período de garantia, o CLIENTE deverá informar à STECK "+;
	"sobre o tipo de defeito ocorrido através do e-mail contatoZZZZvendas@STECKZZZZcomZZZZbr ou do fax 11 2248-7051. A STECK se "+;
	"compromete a analisar o ocorrido e consertar ou a substituir o produto dentro do mais curto espaço de tempo possível."+;
	"Confirmado que o defeito se encontra dentro das condições de garantia acima especificadas, eventuais custos de mão de "+;
	"obra e materiais para reparação ou substituição serão assumidos pela STECK."+;
	"As regras acima definidas se aplicam somente para produtos vendidos diretamente pela STECK ou por seus parceiros no "+;
	"mercado brasileiro."+;
	;
	"13: LIMITAÇÃO DE RESPONSABILIDADE POR PERDAS E DANOS:."+;
	"A responsabilidade da STECK por indenizar eventuais perdas e danos que causar relacionadas ao FORNECIMENTO seja por "+;
	"inadimplementos, negligência, imprudência, imperícia, indenizações, quebra de garantias, ou qualquer outra causa, quer "+;
	"se constituam por fato ou ato isolado ou pela totalidade dos mesmos, fica limitada aos danos diretos causados ao "+;
	"CLIENTE durante o prazo de execução do FORNECIMENTO e até o término do prazo de garantia e ao valor total agregado "+;
	"de 50% (cinquenta por cento) do valor do FORNECIMENTO."+;
	"Fica entendido ainda, que a STECK não será responsável, em hipótese alguma por indenizar eventuais lucros cessantes, "+;
	"perdas de receita ou de produção, perdas de contratos, custos de ociosidade, custos adicionais de energia, penalidades "+;
	"do poder concedente, danos a imagem ou quaisquer hipóteses de danos indiretos e/ou consequentes. A limitação de "+;
	"responsabilidade prevista nesta cláusula prevalece e aplica-se para fins de delimitar qualquer disposição contratual que "+;
	"diga respeito a indenizações ou compensações devidas pela STECK."+;
	;
	"14: OBSERVAÇÕES GERAIS:."+;
	"Caso o CLIENTE necessite de uma contratação com características particulares, diferentes das condições aqui "+;
	"estabelecidas, esta se realizará através de um contrato de fornecimento específico, negociado e acordado entre as partes."+;
	"O CLIENTE ao entregar o Pedido de Compra à STECK concorda e aceita integralmente as condições aqui estabelecidas, que "+;
	"prevalecerá sobre qualquer outra condição da compradora."+;
	"Caso a compradora esteja localizada em áreas com benefícios fiscais como, por exemplo, a Zona Franca de Manaus e "+;
	"adquira produtos na STECK com benefícios da não tributação do ICMS e/ou IPI, a mesma deverá proceder de acordo com "+;
	"as informações solicitadas pela SUFRAMA, para internamento da mercadoria, que deverá ocorrer em até 60 dias da data "+;
	"da emissão da Nota Fiscal. O não cumprimento das orientações solicitadas pela SUFRAMA, dentro do prazo acima, implica "+;
	"em penalidades conforme descrito por lei e caso a STECK seja obrigada a recolher os impostos, a mesma repassará estes "+;
	"valores acrescidos de todos os encargos legais para a compradora."+;
	;
	"e-mail: contato@STECKZZZZcomZZZZbrAAAA"+;
	"Comercial / Administração:AAAA"+;
	"Rua Samaritá, 1117 – 3 andarAAAA"+;
	"Jardim das laranjeiras - Cep: 02518-080/SP")

Return  (alltrim(_cText))

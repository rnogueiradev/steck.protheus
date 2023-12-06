#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#Include "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  ³ RSTFAT09 ³ Autor ³ João Victor           ³ Data ³26/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Pedido de Venda Gráfico                       ³±±
±±³          ³ no Browse do Pedido de Venda chamado pelo Ponto de Entrada ³±±
±±³          ³ MA410MNU (Ações Relacionadas)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

//Sempre que alterar este fonte também altere o fonte RSTFAT11

User Function RSTFAT09(_lEdi)

	Local aArea  			:= GetArea()
	Local lRest             := .F.
	Private _lPortal 	 := .F.
	Private cEmailFor	  	:= ""
	Default _lEdi		  	:= .F.
	Private _lPilha			:= .F.
	Private _nXmargSf7    	:= 0
	Private oPrint
	Private _cNomeCom     := SM0->M0_NOMECOM
	Private _cEndereco    := SM0->M0_ENDENT
	Private cCep          := SM0->M0_CEPENT
	Private cCidade       := SM0->M0_CIDENT
	Private cEstado       := SM0->M0_ESTENT
	Private cCNPJ         := SM0->M0_CGC
	Private cTelefone     := SM0->M0_TEL
	Private cFax          := SM0->M0_FAX
	Private cResponsavel  := Alltrim(MV_PAR04)
	Private cIe           := Alltrim(SM0->M0_INSC)
	Private _nTotPed      := 0
	Private	nAliqICM      := 0
	Private	nValICms      := 0
	Private	nValSuf    	  := 0
	Private nCnt          := 0
	Private	nAliqIPI      := 0
	Private	nValIPI       := 0
	Private	nValICMSST    := 0
	Private	nValPis       := 0
	Private	nValCof	      := 0
	Private _cxCliContr   := "SA1->A1_GRPTRIB"
	Private _cCliEst      := "SA1->A1_EST"
	Private _cTipoCli 	  := "SC5->C5_TIPOCLI"
	Private	cCopia    		:= Alltrim(Lower(Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND2,"A3_EMAIL")))
	Private	titulo	  		:= "Envio de E-Mail Pedido de Venda nº: " + SC5->C5_NUM + " - STECK INDÚSTRIA ELÉTRICA"
	Private cBmpName  	  := ''
	Private cStartPath 	  := '\arquivos\pedido\'//GetSrvProfString("Startpath","") +'orcamento\'
	Private _cPath		  	:= GetSrvProfString("RootPath","") //GetPvProfString( GetEnvServer(), "RootPath"	, "", GetAdv97() )
	Private _cNomePdf     :=''
	Private _Lmomat       := IsInCallSteck("MATA410") .OR. _lEdi 
	Private _cDirRel      := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private _lxRet        := .T.
	Private _lRetorno 		:= .T.
	
	If AllTrim(SC5->C5_CLIENT) == "006596" //Nortel
		cCopia	:= cCopia + "mariana.silva@rexel.com.br;kathiuce.souza@rexel.com.br;marcelo.oliveira@steck.com.br"
	ElseIf AllTrim(SC5->C5_CLIENT) == "008724" //PJ
		cCopia	:= cCopia + "maria.leni@eletricapj.com.br;sylvio.esteves@eletricapj.com.br;thalita.maciel@eletricapj.com.br;jcantero@uol.com.br;maria.leni@eletricapj.com.br;erica.oliveira@eletricapj.com.br"
	ElseIf AllTrim(SC5->C5_CLIENT) == "010566" //Neblina
		cCopia	:= cCopia + "maria.leni@eletricapj.com.br;andre.rocha@neblina.com.br;thalita.maciel@eletricapj.com.br;jcantero@uol.com.br;eliane.silva@steck.com.br;juliane.santos@steck.com.br;maria.leni@eletricapj.com.br;erica.oliveira@eletricapj.com.br"
	ElseIf AllTrim(SC5->C5_CLIENT) == "003382" //Dimensional
		cCopia	:= cCopia + ";simone.valencio@dimensional.com.br;caroline.savazzi@dimensional.com.br"
	ElseIf AllTrim(SC5->C5_CLIENT) == "001236" //Andra
		cCopia	:= cCopia + "juliane.santos@steck.com.br;herig.nascimento@steck.com.br"
	EndIf

	If ValType(_lEdi) == "C"
		_lEdi	:= .F.
	EndIf

	If _lEdi .And. IsInCallStack("U_RSTFAT11")
		_lPortal := .T.
	Endif
	//FR - 20/06/2022 - CHAMADA DA GRAVAÇÃO DO ORÇAMENTO MANDA GERAR PDF, NO CASO DE VIR DA API, SENÃO DÁ ERRO DE CRIAÇÃO DE PASTA
	If IsInCallStack("U_STCRM07A") .OR. IsInCallStack("U_STCRM08A") 									 
		lRest := .T.		
	Endif 

	If lRest
		_lRetorno := .F.
		RETURN .F.
	Endif 
	//FR - 20/06/2022 - CHAMADA DA GRAVAÇÃO DO ORÇAMENTO MANDA GERAR PDF, NO CASO DE VIR DA API, SENÃO DÁ ERRO DE CRIAÇÃO DE PASTA

	dbSelectArea("SC5")
	If _lPortal
		xMontaRel(_lEdi)
	Else
		Processa({|lEnd|xMontaRel(_lEdi)})
	EndIf
	If _lRetorno .And. _lPortal

		RestArea(aArea)
		Return {cStartPath,_cNomePdf}
	Endif

Return _lRetorno

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  ³ MontaRel ³ Autor ³ João Victor           ³ Data ³26/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao DO RELATORIO                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function xMontaRel(_lEdi)
	Local aRetPed := {}
	//Local nDiasTra := 0 	//FR - 25/02/2022 - Trazer para a impressão da Data de Entrega, os dias de transporte calculados pelo CEP do cliente
	//Local cCEP        := ""
	Private _lPilha	:= .F.
	Default _lEdi	:= .F.

	If SC5->C5_ZBLOQ = "1" .And. !(AllTrim(SC5->C5_ZMOTBLO) == "EDI/") //.And. !_lEdi
		cMsg := "O Pedido encontra-se bloqueado e portanto não será possível enviar o relatório de Pedido de Venda ao Cliente."
		cMsg += "Entre em contato com seu supervisor para que o mesmo libere este Pedido de Venda!"
		Alert(cMsg)
		_lRetorno := .F.
		Return .F.
	Endif	
	
	/*************************************************************
	<<< ALTERAÇÃO >>> 
	Ação...........: Retirada a validação da variável "_Lmomat" pois não está sendo possível imprimir o pedido de venda após a geração do mesmo via Orçamento
	Desenvolvedor..: Marcelo Klopfer Leme
	Data...........: 16/05/2022
	Chamado........: 20220429009114 - Oferta Logística
	*************************************************************/

	
	///If !_Lmomat
	////	MsgStop("Pedido de Venda Nao Encontrado !!!  Verifique !!! " )
	////Else
		_cNomePdf  :=cEmpAnt+"_Pedido_"+SC5->C5_NUM
		oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , '\arquivos\Pedido\'  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
		oPrint:SetLandScape()     //SetPortrait() ou SetLandscape()
		oPrint:SetMargin(60,60,60,60)
		oPrint:setPaperSize(9)
		DbSelectArea("SA1")
		SA1->( dbSetOrder(1) )
		SA1->( dbSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI) )
		dbselectarea("SE4")
		MsSeek(Xfilial("SE4")  + SC5->C5_CONDPAG )
		dbselectarea("SC5")
		xImpress()
		// Indique o caminho onde será gravado o PDF
		FErase(cStartPath + _cNomePdf + ".pdf")
		oPrint:cPathPDF := cStartPath//"c:\"
		oPrint:Print()
		If _lEdi
			_cDirRel := "\pedidos"
		EndIf
		If ExistDir(_cDirRel)
			_lxRet := .T.
		Else
			If MakeDir(_cDirRel) == 0
				MakeDir(_cDirRel)
				Aviso("Criação de Pasta","Fora criado nesse computador uma pasta para que os Pedidos de Venda emitidos lá sejam salvos após a impressão...!!!"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"Segue o caminho do diretório criado:"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				_cDirRel,;
				{"OK"},3)
				_lxRet := .T.
			Else
				Aviso("Erro na Criação de Pasta","Para salvar o Pedido de Venda em questão é necessário que uma pasta seja criada nesse computador...!!!"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"Favor entrar em contato com o TI para que a criação da pasta seja realizada...!!!:"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"Não será possível realizar a abertura do Pedido de Venda em arquivo PDF e consequentemente não será enviado via e-mail ao cliente...!!!",;
				{"OK"},3)
				_lxRet := .F.
			EndIf
		EndIf
		If _lxRet .And.  !_lPortal
			FErase(_cDirRel + "\" + _cNomePdf + ".pdf")
			If !_lEdi
				CpyS2T(cStartPath + _cNomePdf + '.pdf',_cDirRel + "\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
				ShellExecute("open",_cDirRel + "\" + _cNomePdf + '.pdf', "", "", 1)
				dbSelectArea('SC6')
				SC6->( dbSetOrder(1) )
				If SC6->( dbSeek(xFilial('SC6') + SC5->C5_NUM) )
					Do While SC6->( !Eof() ) .And. SC6->C6_FILIAL == xFilial('SC6') .And. SC6->C6_NUM == SC5->C5_NUM
						If Alltrim(SC6->C6_PRODUTO) $ GetMv("ST_PILHAMA",,"PA15AAA2/PA15AAA4/PA15AA2/PA15AA4/PA15C2/PA15D2/PA09V")   //Giovani Zago 25/03/14 chamado 332
							_lPilha	:= .T.
						EndIf
						SC6->( dbSkip() )
					EndDo
				EndIf
				If _lPilha
					FErase(_cDirRel + "\Manual_de_Comercializao_Pilhas.pdf")
					CpyS2T('manual\Manual_de_Comercializao_Pilhas.pdf',_cDirRel + "\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
					ShellExecute("open",_cDirRel + "\Manual_de_Comercializao_Pilhas.pdf", "", "", 1)
				EndIf
			EndIf

			If !IsInCallStack("U_STSIMPV") 
				If MsgBox("Envia e-mail ao cliente?","Envio de E-Mail","YESNO")
					U__pv2lChkMail() // Abre tela Para Digitar Manualmente E-Mails
					Processa({|lEnd| xBrEnvMail(oPrint,"Pedido de Venda: "+ SC5->C5_NUM,{"Pedido de Venda: "+ SC5->C5_NUM},cEmailFor,"",{},10)},titulo)
				EndIf
			EndIf
		else
			conout("U_RSFAT09.PRW-PDF Pedido Gerado" + cStartPath+_cNomePdf + ".pdf" )
			
		EndIf
	////EndIf
		
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  ³ xImpress ³ Autor ³ João Victor           ³ Data ³26/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Relatório                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function xImpress()

	Local _cDMoed		:= "R$"
	Local oBrush
	Local _nTotIPI  	:= 0
	Local _nTotICMSST	:= 0
	Local _nTotal		:= 0
	Local _nTotSuf		:= 0
	Local _nTotvalmerc 	:= 0
	Local _nTotpedvend 	:= 0
	Local _ncount		:= 0
	Local fr            := 0

	//FR - Flávia Rocha - Sigamat Consultoria - Alteração
	Local  lWF      := .F. //FR - 30/03/2022 - Variável para indicar se envia ou não o WF para Logística em caso de falta de cadastro de Transit Time na CC2
	Local cMsg      := ""
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := ""
	Local nDiasTra  := 0  //FR - 25/02/2022 - Trazer para a impressão da Data de Entrega, os dias de transporte calculados pelo municipio do cliente na tabela CC2
	Local nDiasLog  := 0	//FR - 11/05/2022 - Alteração - validação de Kleber, necessário dias de operação da Logística
	Local nDiasExp  := 0	//FR - 11/05/2022 - Alteração - validação de Kleber, necessário dias de liberação do Financeiro
	Local nDiasFin  := 0 
	Local dPrazoEnt := Ctod("  /  /    ")   //FR - 11/05/2022 - variável que irá armazenar o prazo de entrega (na porta cliente)
	Local nTotPrazo := 0	
	//Local nPrzProduto   := 0    				//FR - 11/05/2022 - Alteração - variável que armazena o prazo de entrega individual de cada produto
	//FR - Flávia Rocha - Sigamat Consultoria - Alteração

	Private _nLin 		:= 4000
	
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

	_nTotal := 0
	_npagina := 0
	_aItRed	:= {}
	dbselectarea("SM0")
	dbselectarea("SC6")
	SC6->( dbsetorder(1) )
	SC6->( dbseek(xfilial("SC6") + SC5->C5_NUM) )

	oPrint:StartPage()     // INICIALIZA a página
	xCabOrc()

	Do While SC6->( !Eof() ) .And. SC5->C5_NUM == SC6->C6_NUM
		dbSelectArea("SA1")
		dbSetOrder(1)
		MsSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI)
		STMAFISREL()
		_nTotIPI     := (nValIPI) + (_nTotIPI)
		_nTotICMSST  := (nValICMSST) + (_nTotICMSST)
		_nTotSuf	 := (nValSuf) + _nTotSuf
		_nTotvalmerc := (SC6->C6_VALOR) + (_nTotvalmerc)
		_nTotpedvend := (_nTotvalmerc) + (_nTotIPI) + (_nTotICMSST)
		If _nLin > 580
			_nLin+=10
			oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
			oPrint:EndPage()	// Finaliza a página
			oPrint:StartPage()	// INICIALIZA a página
			xCabOrc()
		EndIf
		// Posiciona No Cad Produtos
		dbSelectArea("SB1")
		dbSetOrder(1)
		MsSeek(xFilial("SB1") + SC6->C6_PRODUTO)
		// Posiciona No Cad De TES
		dbSelectArea("SF4")
		dbSetOrder(1)
		MsSeek(xFilial("SF4") + SC6->C6_TES,.T.)
		_nXmargSf7 := Posicione('SF7', 4, xFilial("SF7") + SB1->B1_GRTRIB + &_cxCliContr + &_cCliEst + &_cTipoCli, 'F7_MARGEM')
		//Impressao do Item
		oPrint:Say  (_nLin,020, SC6->C6_ITEM	,oFont8)
		//Impressao do Codigo e Descricao do Produto
		oPrint:Say  (_nLin,040, SC6->C6_produto	,oFont8)
		_nTam		:= 60
		_ctexto  	:= Alltrim(SubStr(SB1->B1_DESC,1,42))
		_nlinhas 	:= mlcount(_ctexto,_nTam)
		For _ncount := 1 to _nlinhas
			oPrint:Say  (_nLin ,095, memoline(_ctexto,_nTam,_ncount),oFont8)
			If _nCount <> _nLinhas
				_nLin += 60
			EndIf
		Next _ncount
		//Impressao da Quantidade e Unidade de Medida
		oPrint:Say  (_nLin,280, transform(SC6->C6_QTDVEN,"@E 999999.99")	,oFont8)
		
		/*********************************
		<<<< ALTERAÇÃO >>>> 
		Até que me provem o contrário a unidade de medida não possui 60 caracteres
		_nTam		:= 60
		_ctexto  	:= Alltrim(SB1->B1_UM)
		_nlinhas 	:= mlcount(_ctexto,_nTam)
		For _ncount := 1 to _nlinhas
			oPrint:Say  (_nLin ,310, MemoLine(_ctexto,_nTam,_ncount),oFont8)
			If _nCount <> _nLinhas
				_nLin+=60
			EndIf
		Next _ncount
		*********************************/
		oPrint:Say  (_nLin ,310, ALLTRIM(SB1->B1_UM),oFont8)

		//Impressao do Valor Unitario
		oPrint:Say  (_nLin,330, Transform(SC6->C6_PRCVEN,"@E 999,999.99"  ),oFont8,,,,1)
		//Impressao do Percentual de IPI
		oPrint:Say  (_nLin,370, Transform(nAliqIPI 	    ,"@E 9,999.99"    ),oFont8,,,,1)
		//Impressao do Percentual de ICMS
		oPrint:Say  (_nLin,400, Transform(nAliqICM      ,"@E 9,999.99"    ),oFont8,,,,1)
		//Impressao do Percentual de IVA
		oPrint:Say  (_nLin,430, Transform(_nXmargSf7	  ,"@E 9,999.99"    ),oFont8,,,,1)
		//Impressao do Valor de ICMS-ST
		oPrint:Say  (_nLin,465, Transform(nValICMSST	  ,"@E 9,999.99"    ),oFont8,,,,1)
		//Impressao do Valor Total
		oPrint:Say  (_nLin,500, Transform(SC6->C6_VALOR ,"@E 9,999,999.99"),oFont8,,,,1)
		_nTotal	+= SC6->C6_VALOR
		//Impressao do NCM
		oPrint:Say  (_nLin,550, Transform(SC6->C6_ZNCM  ,"@R 9999.99.99"  ),oFont8,,,,1)
		//Impressao da Ordem de Compra por Item
		oPrint:Say  (_nLin,590, Transform(SC6->C6_XORDEM,"@!"             ),oFont8,,,,1)

		/*************************************************************
		<<< ALTERAÇÃO >>> 
		Ação...........: Trocar Nomenclatura 
		Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
		Data...........: 01/02/2022
		Chamado........:20211207026208- VIRADA APOEMA NEWCO DISTRIBUIDORA
		oPrint:Say  (_nLin,720, Transform(cValtoChar(U_STGETPRZ(SC6->C6_PRODUTO,SC6->(C6_QTDVEN-C6_QTDENT),"2")) + " dias corridos"				  	,"@!")	            ,oFont8)
		*************************************************************/
		//oPrint:Say  (_nLin,720, Transform(cValtoChar(U_STGETPRZ(SC6->C6_PRODUTO,SC6->(C6_QTDVEN-C6_QTDENT),"2")) + " dias úteis"				  	,"@!")	            ,oFont8)
		/*************************************************************
		<<< ALTERAÇÃO >>> 
		Ação...........: Adicionar prazo transportadora
		Desenvolvedora.: Flávia Rocha - FR SIGAMAT
		Data...........: 24/02/2022
		Chamado........:20211130025628- APOEMA - Reestruturação de reservas e prazos de entrega
		*************************************************************/
		/*************************************************************
		<<< ALTERAÇÃO >>> 
		Ação...........: Validação para quando o Pedido de Venda estiver com o campo de Entrega Programada preenchido não altere as datas de entrega.
		...............: Campo C5_XDTENPR
		Desenvolvedor..: Marcelo Klopfer Leme
		Data...........: 16/05/2022
		Chamado........: 20220429009114 - Oferta Logística
		*************************************************************/
		IF EMPTY(SC5->C5_XDTENPR)

			/*************************************************************
			<<< ALTERAÇÃO >>> 
			Ação...........: Validação para quando a data de entrega for anteiror a data de corte da oferta lógistica
			...............: imprime a data no conceito antigo para evitar divergência com o pedido envidado ao cliente
			Desenvolvedor..: Marcelo Klopfer Leme
			Data...........: 01/06/2022
			Chamado........: 20220429009114 - Oferta Logística
			*************************************************************/
			IF SC5->C5_EMISSAO <= STOD("20220531")
				oPrint:Say (_nLin,720, Transform(cValtoChar(U_STGETPRZ(SC6->C6_PRODUTO,SC6->(C6_QTDVEN-C6_QTDENT),"2")) + " dias úteis" ,"@!") ,oFont8)
			ELSE			
				//nDiasTra := U_STFATG03(.T.)			//Traz o prazo de entrega em dias de acordo com o cliente, tabela JC2 //U_STFATG03(lFormula)
				//oPrint:Say  (_nLin,720, Transform(cValtoChar( U_STGETPRZ(SC6->C6_PRODUTO,SC6->(C6_QTDVEN-C6_QTDENT),"2") ) + "+" + Alltrim(str(nDiasTra)) + " dias úteis"				  	,"@!")	            ,oFont8)
				
				//nPrzProduto   := 0
				//nPrzProduto := U_STGETPRZ(SC6->C6_PRODUTO,SC6->(C6_QTDVEN-C6_QTDENT),"2")  //prazo produto -> para operação do pedido digitação e liberação financeiro
				//nDiasLog   := GetNewPar("STDIASLOG",4)	//FR - 11/05/2022 - Alteração - validação de Kleber, necessário dias de operação da Logística
				//nDiasExp    := GetNewPar("STDIASEXP",2)   //FR - 12/05/2022 - Alteração - validação de Kleber, necessário dias de operação da expedição
				
				//// Dias de Translado para a entrega Tabela CC2
				nDiasTra := U_STFATCC2(.T.)				

				//// Dias de operação para o Financeiro
				nDiasFin := GetNewPar("STDIASFIN",2)

				//// Dias de operação para o Comercial
				nDiasCom := GetNewPar("STDIASCOM",0)

				//// Dias de operação para a Logistica 
				nDiasLog := GetNewPar("STDIASLOG",4)
							
				//// Dias de operação para a Expedição
				nDiasExp := GetNewPar("STDIASEXP",2)


				dPrazoEnt     := Ctod("  /  /    ")   		//FR - 11/05/2022 - variável que irá armazenar o prazo de entrega (na porta cliente)

				If nDiasTra > 0

					dPrazoEnt   := Ctod("  /  /    ")
					
					//Prazo produto já está incluída a operação financeiro
					//Fórmula: Data Entrega = Dt. Emissão + Przo Operação Produto + Dias operação logística + Dias liberação expedição + Prazo Transportadora
					
					//// Soma os dias que compõe a opreação total 
					nTotPrazo := nDiasTra + nDiasFin + nDiasCom + nDiasLog + nDiasExp

					/****************************
					Trocado para a variável dPrazoEnt para pegar a C6_ENTREG e não mais C5_EMISSAO
					****************************/
					dPrazoEnt   := DataValida(IIF(EMPTY(SC6->C6_ZENTRE2),SC6->C6_ENTREG,SC6->C6_ZENTRE2))			
					
					/****************************
					Modificado para a variavel FR = 2 pois o dia de início de operação não deve ser contado na soma
					****************************/
					fr := 2
					While fr <= nTotPrazo
						//vai somando de 1 em 1 e vendo se cai sábado ou domingo, então adiciona sempre mais um dia até ficar dia útil 
						dPrazoEnt := DataValida(dPrazoEnt + 1)
						fr++										
					Enddo
					
					//dPrazoEnt é a variável q será impressa				
					dPrazoEnt := DataValida(dPrazoEnt) 				
					
					oPrint:Say  (_nLin,650, Dtoc( dPrazoEnt)  , oFont8)  //FR - 11/05/2022
				
				Else 
					
					oPrint:Say  (_nLin,650, "S/Cadast.TransiT Time"	            ,oFont8)
					lWF := .T. //Qdo esta variável fica .T., indica que vai enviar o Email WF para Logística indicando necessidade cadastro do Transit Time (CC2 - Municípios IBGE)	

				Endif 

			cQuery := "SELECT * FROM "+RetSqlName("Z96")+" Z96 "
			cQuery += "WHERE Z96.D_E_L_E_T_ = ' ' "
			cQuery += "AND Z96.Z96_PA1DOC = '"+SC6->C6_NUM+SC6->C6_ITEM+"' AND Z96.Z96_PROD = '"+SC6->C6_PRODUTO+"' "
			cQuery += "ORDER BY Z96.Z96_DTPVIN "
			cQuery := ChangeQuery(cQuery)
			
			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TZ96', .F., .T.)
			
			IF !EMPTY(TZ96->Z96_PA1DOC)	

				WHILE TZ96->(!EOF())

					/****************************
					Modificado para a variavel FR = 2 pois o dia de início de operação não deve ser contado na soma
					****************************/
			
					dPrazoEnt := DataValida(STOD(TZ96->Z96_DTPVIN))			
			
					fr := 2
					While fr <= nTotPrazo
						//vai somando de 1 em 1 e vendo se cai sábado ou domingo, então adiciona sempre mais um dia até ficar dia útil 
						dPrazoEnt := DataValida(dPrazoEnt + 1)
						fr++										
					Enddo

					_nLin += 15

					If nDiasTra > 0
						oPrint:Say(_nLin,715, TRANSFORM(TZ96->Z96_QTDATE,"@E 999999.99"),oFont8,,,,1)
						oPrint:Say(_nLin,750, DTOC(dPrazoEnt)                           ,oFont8)
					EndIf
			
				TZ96->(DBSKIP())
				ENDDO
			ENDIF
			TZ96->(DBCLOSEAREA())

			ENDIF
			
		ELSE
				oPrint:Say  (_nLin,650,DTOC(SC5->C5_XDTENPR), oFont8)
		ENDIF
		
		_nLin += 15
		If _nLin > 580
			_nLin += 10
			oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			xCabOrc()
		EndIf
		dbselectarea("SC6")
		SC6->( dbSkip() )
	EndDo

	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	EndIf
	oPrint:Line (_nLin, 005,_nLin,800)
	// Imprime Total do Pedido de Venda
	_nLin += 15
	If _nLin > 580
		_nLin += 10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	EndIf
	oPrint:Say  (_nLin,550, "Valor Total dos Produtos (" + _cDMoed + ")"	,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(_nTotal,"@E 9,999,999.99")	,oFont10)
	If _nLin > 580
		_nLin += 10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	EndIf
	_nLin += 15
	oPrint:Say  (_nLin,550, "Valor Total IPI (" + _cDMoed + ")"			,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(_nTotIPI,"@E 9,999,999.99")	,oFont10)
	If _nLin > 580
		_nLin += 10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	EndIf
	_nLin += 15
	oPrint:Say  (_nLin,550, "Valor Total ICMS-ST (" + _cDMoed + ")"		,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(_nTotICMSST,"@E 9,999,999.99")	,oFont10)
	If _nLin > 580
		_nLin += 10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	EndIf
	_nLin += 15
	oPrint:Say  (_nLin,550, "Valor Total Suframa (" + _cDMoed + ")"		,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(_nTotSuf,"@E 9999,999.99")	,oFont10)
	If _nLin > 580
		_nLin += 10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	EndIf
	_nLin += 15
	oPrint:Say  (_nLin,550, "Valor Total do Pedido de Venda (" + _cDMoed + ")"	,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(/*_nTotpedvend*/_nTotal+_nTotIPI+_nTotICMSST-_nTotSuf,"@E 9,999,999.99")	,oFont10)
	If _nLin > 580
		_nLin += 10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	EndIf
	_nLin += 15
	If _nLin > 580
		_nLin += 10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	EndIf
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	_nLin += 15
	If _nLin > 580
		_nLin += 10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	EndIf
	// Observação da Cotação:
	oPrint:Say  (_nLin,020, "Observação"						,oFont10)
	oPrint:Say  (_nLin,070, ": " + SC5->C5_ZOBS 				,oFont10)
	_nLin += 15	
	
	If _nLin > 580
		_nLin += 10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	EndIf
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	// Inicia Mensagens do Pedido de Venda

	//FR - 14/06/2022 - Flávia Rocha - Sigamat Consultoria - Alteração - Ticket #20220609011857 
	oPrint:Say  (_nLin,020, " Faturamento mínimo para compra R$ 2.500,00 " 		,oFont10)
	//FR - 14/06/2022 - Flávia Rocha - Sigamat Consultoria - Alteração - Ticket #20220609011857 
	

	_nLin += 15
	If _nLin > 580
		_nLin += 10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	EndIf
	// Imprime Vendedor
	//>> Chamado 008924 - Everson Santana - 29.01.2019
	_cVend1 := Alltrim(Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND2,"A3_NOME"))
	oPrint:Say  (_nLin,020, "Vendedor Interno"							,oFont10)
	oPrint:Say  (_nLin,100, ": " + Capital(_cVend1)				,oFont10)

	_cVend1Ex := Alltrim(Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND1,"A3_NOME"))
	oPrint:Say  (_nLin,400, "Vendedor Externo"							,oFont10) //Ticket 20200731004941
	oPrint:Say  (_nLin,480, ": " + Capital(_cVend1Ex)				,oFont10) //Ticket 20200731004941

	_nLin += 15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_cVend2 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_TEL"))
	oPrint:Say  (_nLin,020, "Telefone"							,oFont10)
	oPrint:Say  (_nLin,100, ": " + Capital(_cVend2)				,oFont10)

	_cVend2Ex := Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_TEL"))
	oPrint:Say  (_nLin,400, "Telefone"							,oFont10)
	oPrint:Say  (_nLin,480, ": " + Capital(_cVend2Ex)				,oFont10)

	_nLin += 15
	If _nLin > 580
		_nLin += 10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	EndIf
	_cVend4 := Alltrim(Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND2,"A3_EMAIL"))
	oPrint:Say  (_nLin,020, "E-mail"							,oFont10)
	oPrint:Say  (_nLin,100, ": " + Lower(_cVend4)				,oFont10)

	_cVend4Ex := Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL"))
	oPrint:Say  (_nLin,400, "E-mail"							,oFont10)
	oPrint:Say  (_nLin,480, ": " + Lower(_cVend4Ex)				,oFont10)

	_nLin += 15
	If _nLin > 580
		_nLin += 10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	EndIf

	/*Retirado conforme solicitação do Chamado 008924
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
	*/
oPrint:EndPage()     // Finaliza a página

//FR - Flávia Rocha - Sigamat Consultoria - Alteração - 30/03/2022
//Envio de email à logística qdo não houver cadastro do prazo transportadora (transit time) na tabela CC2
If lWF
	//Envia WF para Logística:
	dbSelectArea("SA1")
	dbSetOrder(1)
	MsSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI)

	cMsg    := "Por Gentileza, Efetuar o Cadastro de Transit Time Para o Municipio / Estado: " + Alltrim(SA1->A1_MUN) + " / " + Alltrim(SA1->A1_EST) + CRLF
	cMsg    += "Tabela Padrão CC2 - Municípios IBGE " + CRLF
	cMsg    += "Originado na impressão do Pedido de Venda do Cliente: " + SA1->A1_COD + "/" + SA1->A1_LOJA + "-" + Alltrim(SA1->A1_NOME) + CRLF

	_cEmail := GetNewPar("STRSTFAT09" , "rafael.davanso@steck.com.br;wellington.gamas@steck.com.br")
	_cCopia := ""
	_cAssunto   := "Sem Cadastro Transit Time Municipio/UF: "+ SA1->A1_MUN + "/"+ SA1->A1_MUN

	U_STMAILTES(_cEmail , _cCopia , _cAssunto, cMsg,,,'   ')  //ATIVAR QDO EM PRODUÇÃO
	//FRSendMail(_cEmail, _cCopia, _cAssunto, cMsg, "" ) //FRSendMail(cMailTo, cCopia, cAssun, cCorpo, cAnexo )  //FR SOMENTE PARA TESTES

Endif
//FR - Flávia Rocha - Sigamat Consultoria - Alteração - 30/03/2022

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³xCabOrc   ºAutor  ³ João Victor        º Data ³ 26/07/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Steck                                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function xCabOrc ()

	Local _nDias	:= 0

	oPrint:Box(045,005,580,800)

	If File(aBmp)
		oPrint:SayBitmap(060,020,aBmp,095,050 )
	EndIf

	oPrint:Say  (065,120, _cNomeCom  ,oFont12)
	oPrint:Say  (080,120, _cEndereco ,oFont12)
	oPrint:Say  (095,120,"CEP: " + Substr(cCep,1,5) + "-" + Substr(cCep,6,3) + " - " + Alltrim(cCidade) + " - " + cEstado,oFont12)
	oPrint:Say  (110,120,"TEL.: (11) 2248-7000 | FAX.: (11) 2248-7051 | E-MAIL: contato.vendas@steck.com.br",oFont12)

	dbselectarea("SA1")
	MsSeek(Xfilial("SA1")  + SC5->C5_CLIENTE + SC5->C5_LOJACLI )

	oPrint:Box(125,005,230,800)

	oPrint:Say  (140,020,"Empresa: " + Upper(SA1->A1_NOME)         									,oFont12)
	oPrint:Say  (155,020,"Código de Cliente: "+ SC5->C5_CLIENTE + " - " + SC5->C5_LOJACLI			,oFont12)

	oPrint:Say  (170,020,"Dados de Faturamento: " 																																								,oFont12)
	oPrint:Say  (185,020,Upper(Alltrim(SA1->A1_END) + " - " + Alltrim(SA1->A1_BAIRRO) + " - " + Alltrim(SA1->A1_MUN) + " - " + Alltrim(SA1->A1_EST) + " - " + Alltrim(SA1->A1_CEP))         					,oFont12)
	oPrint:Say  (200,020,Transform(SA1->A1_CGC,PESQPICT("SA1","A1_CGC"))			        		   																											,oFont12)
	oPrint:Say  (215,020,"I.E.: " + SA1->A1_INSCR 											   	   																												,oFont12)

	oPrint:Box(230,005,295,800)
	cBmpName := SC5->C5_NUM
	oPrint:Say  (245,020,"Pedido de Venda"						,oFont12)
	oPrint:Say  (245,100,": " + SC5->C5_NUM						,oFont12)
	oPrint:Say  (245,220,"Emissão" 								,oFont12)
	oPrint:Say  (245,310,": " + DtoC(SC5->C5_EMISSAO)			,oFont12)

	_nDias	:= DIASMAX(SC5->C5_FILIAL,SC5->C5_NUM)

	//oPrint:Say  (245,420,"Entrega dias uteis:"					,oFont12)
	//oPrint:Say  (245,510,CVALTOCHAR(_nDias)						,oFont12)

	dbselectarea("SU5")
	MsSeek(Xfilial("SU5")  + SC5->C5_ZCODCON )
	dbselectarea("SQB")
	MsSeek(Xfilial("SQB")  + SU5->U5_DEPTO )

	_cDepto := SQB->QB_DESCRIC

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

	If SC5->C5_TPFRETE == "F"
		_cFrete := "FOB"
	Else
		_cFrete := "CIF"
	EndIf

	oPrint:Say  (290,020, "Frete"					,oFont12)
	oPrint:Say  (290,100, ": " + (_cFrete)			,oFont12)
	oPrint:Say  (290,220, "Atendimento"				,oFont12)
	oPrint:Say  (290,310, ": " + SC5->C5_ZORCAME	,oFont12)

	oPrint:Box(295,005,320,800)
	oPrint:Say(310,020, "Item"			  ,oFont10)
	oPrint:Say(310,040, "Código"			,oFont10)
	oPrint:Say(310,095, "Descrição"		,oFont10)
	oPrint:Say(310,280, "Qtde." 			,oFont10)
	oPrint:Say(310,310, "UM"				  ,oFont10)
	oPrint:Say(310,340, "Vlr Unit"    ,oFont10)
	oPrint:Say(310,385, "IPI"				  ,oFont10)
	oPrint:Say(310,405, "ICMS"			  ,oFont10)
	oPrint:Say(310,440, "IVA"				  ,oFont10)
	oPrint:Say(310,460, "ICMS-ST"		  ,oFont10)
	oPrint:Say(310,500, "Valor Total" ,oFont10)
	oPrint:Say(310,545, "Clas. Fiscal",oFont10)
	oPrint:Say(310,590, "Ordem/Produt",oFont10)
	
	/*************************************************************
	<<< ALTERAÇÃO >>> 
	Ação...........: Trocar Nomenclatura 
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 01/02/2022
	Chamado........:20211207026208- VIRADA APOEMA NEWCO DISTRIBUIDORA
	oPrint:Say  (310,720, "Prazo de entrega"  		,oFont10)
	*************************************************************/
	//oPrint:Say  (310,720, "Prazo de Faturamento"  		,oFont10)
	/*************************************************************
	<<< ALTERAÇÃO >>> 
	Ação...........: Adicionar prazo transportadora
	Desenvolvedora.: Flávia Rocha - FR SIGAMAT
	Data...........: 24/02/2022
	Chamado........:20211130025628- APOEMA - Reestruturação de reservas e prazos de entrega
		
	*************************************************************/
	//oPrint:Say  (310,715, "Prazo Fat+Dias Transp"  		,oFont10)
	IF SC5->C5_EMISSAO <= STOD("20220531")
		oPrint:Say  (310,715, "Prazo de Faturamento"  		,oFont10)
	Else
		oPrint:Say  (310,650, "Data Entrega"  		,oFont10)
		oPrint:Say  (310,715, "Quant. 2"  		,oFont10)
		oPrint:Say  (310,750, "Dt. Entrega2"  		,oFont10)
	EndIf

	_nLin := 330

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  ³xBrEnvMail³ Autor ³ João Victor           ³ Data ³26/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio do Pedido de Venda por e-mail automaticamente        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function xBrEnvMail(oGraphic,cAssunto,aTexto,cTo,cCC,aTabela,nEspacos)

	//Local cMailConta	:= GETMV("MV_RELACNT")
	//Local cMailServer	:= GETMV("MV_RELSERV")
	//Local cMailSenha	:= GETMV("MV_RELPSW")
	//Local lAuth 		:= GetMv("MV_RELAUTH",,.F.)
	Local lOk			:= .F.
	Local cMensagem
	//Local nx			:= 0
	//Local lBmp 			:= !( oGraphic == Nil )
	//Local nWidth 		:= 0
	//Local cError
	Local _aAttach 		:= {}	//'c:\six0101.dbf'
	Local _cCaminho		:= cStartPath
	//Local _nIni			:= 1
	//Local _nFim			:= 100

	aAdd( _aAttach  ,_cNomePdf + '.pdf')
	
	If _lPilha
		__CopyFile('manual\Manual_de_Comercializao_Pilhas.pdf', _cCaminho + 'Manual_de_Comercializao_Pilhas.pdf',,,.F.)
		aAdd( _aAttach  ,'Manual_de_Comercializao_Pilhas.pdf')
	EndIf

	aTexto   := Iif( aTexto == Nil,{},aTexto )
	aTabela  := Iif( aTabela == Nil,{},aTabela)
	nEspacos := Iif( nEspacos == Nil, 10, nEspacos )

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
	cMensagem += "<br><div align='left'><font Face='CALIBRI' >" + StrTran(_cMesCorp,'.',".</FONT>  </br></div>   </tr></table></br><div align='left'><font Face='CALIBRI' > ") + '</FONT></div>'
	cMensagem := StrTran(cMensagem,'ZZZZ','.')
	cMensagem := StrTran(cMensagem,'AAAA',"</FONT></br>  </div>   </tr></table>  <div align='left'><br><font Face='CALIBRI' >")
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  ³_pv2lChkMail³ Autor ³ João Victor         ³ Data ³26/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Caixa De Texto Para Digitação De E-Mail Opcional.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function _pv2lChkMail()

	Local oEdit1
	Local _lRet		:= .F.
	cEMailFor 		:= Alltrim(Lower(SU5->U5_EMAIL)) + Space(200)
	Private _oDlg				// Dialog Principal
	Private INCLUI := .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao

	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Envio Automático de E-Mail") FROM C(330),C(243) TO C(449),C(721) PIXEL
	// Cria Componentes Padroes do Sistema
	@ C(008),C(009) Say "Envia e-mail para Cliente listado abaixo? (Separar por ';')" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(021),C(010) MsGet oEdit1 Var cEMailFor Size C(218),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
	@ C(044),C(137) Button OemtoAnsi("Envia") Size C(037),C(012) PIXEL OF _oDlg	Action Eval( { || _lRet:= .t. , _oDlg:End() }  )
	@ C(044),C(185) Button OemtoAnsi("Cancela") Size C(037),C(012) PIXEL OF _oDlg	Action(_oDlg:End())
	ACTIVATE MSDIALOG _oDlg CENTERED

Return _lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa   ³   C()      ³ Autor ³ João Victor 		   ³ Data ³26/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolução horizontal do Monitor do Usuario.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso        ³ Especifico Steck                                             ³±±
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
		// Tratamento para tema "Flat"
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf

Return Int(nTam)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  ³STMAFISREL³ Autor ³ João Victor           ³ Data ³26/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Abre o MAFISRET para trazer os valores dos tributos        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

STATIC Function STMAFISREL()

   Local _nAlIc        := 0
   Local _nMargem      := 0

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

	MaFisEnd()


	If SC6->C6_OPER$getmv("ST_CONSIG")

If FUnName()=="MATA410"

        DbSelectArea("SD2")
        DbSetOrder(3)
        If DbSeek(xFilial("SD2")+ SC6->C6_NFORI+"001"+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_PRODUTO ) .And. Rtrim(SD2->D2_CLIENTE)$("098732")
             nAliqIPI:= SD2->D2_IPI
			 nValIPI := SC6->C6_VALOR*(nAliqIPI/100)
			 _nMargem  := SD2->D2_MARGEM
             _nAlIc    := SD2->D2_PICM

			 nValICMSST := ((((SC6->C6_VALOR+ nValIPI)*(1+(_nMargem/100))))*(_nAlIc/100))-(SC6->C6_VALOR*(_nAlIc/100))
        else
             If Select("TSD2") > 0
               DbSelectArea("TSD2")
               DbCloSeArea()
             Endif
    
            _cQuery := " SELECT SD2.*                                                       "  
            _cQuery += " FROM "+Alltrim(SuperGetMV("STALIASIND",,"UDBP12"))+".SD2010 SD2              "
            _cQuery += " WHERE SD2.D2_FILIAL = '02'  AND   "
            _cQuery += "       SD2.D_E_L_E_T_ <> '*'                 AND   "
            _cQuery += "       SD2.D2_DOC = '"+SC6->C6_NFORI+"'   AND   "
            _cQuery += "       SD2.D2_SERIE='001'                    AND   "
            _cQuery += "       SD2.D2_CLIENTE = '"+SC6->C6_CLI+"'          AND   "
            _cQuery += "       SD2.D2_LOJA    = '"+SC6->C6_LOJA+"'          AND   "
            _cQuery += "      SD2.D2_COD     = '"+SC6->C6_PRODUTO+"'  "

    
            TCQUERY _cQuery  NEW ALIAS "TSD2"
            _nRec   := 0
            DbEval({|| _nRec++  })

            If _nRec > 0

			   DbSelectArea("TSD2")
               DbGotop()
               nAliqIPI := TSD2->D2_IPI
			   nValIPI := SC6->C6_VALOR*(nAliqIPI/100)
			   _nMargem  := TSD2->D2_MARGEM
               _nAlIc    := TSD2->D2_PICM
			   	nValICMSST := ((((SC6->C6_VALOR+ nValIPI)*(1+(_nMargem/100))))*(_nAlIc/100))-(SC6->C6_VALOR*(_nAlIc/100))

            Endif
        Endif
    Endif	

Endif

Return

Static Function StMSg()
	
	Local _cText := ("")

Return Alltrim(_cText)

Static Function DIASMAX(_cFilial,_cNum)

	Local _nDias	:= 0
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"

	cQuery1	:= " SELECT MAX(ZZO_PRAZO) PRAZO "
	cQuery1 += " FROM " + RetSqlName("ZZO") + " ZO "
	cQuery1 += " WHERE ZO.D_E_L_E_T_ = ' ' "
	cQuery1 += " 	AND ZZO_CODIGO IN ( "
	cQuery1 += " 						SELECT DISTINCT B1_ZCODOL "
	cQuery1 += " 						FROM " + RetSqlName("SC6") + " C6 "
	cQuery1 += " 						LEFT JOIN " + RetSqlName("SB1") + " B1 "
	cQuery1	+= " 							ON B1_COD=C6_PRODUTO "
	cQuery1 += " 						WHERE C6.D_E_L_E_T_=' ' "
	cQuery1 += " 							AND B1.D_E_L_E_T_ = ' ' "
	cQuery1 += " 							AND C6_FILIAL = '" + _cFilial + "' "
	cQuery1 += " 							AND C6_NUM='" + _cNum + "') "
	If !Empty(Select(cAlias1))
		dbSelectArea(cAlias1)
		(cAlias1)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)
	dbSelectArea(cAlias1)
	(cAlias1)->( dbGoTop() )
	If (cAlias1)->( !Eof() )
		_nDias	:= (cAlias1)->PRAZO
	EndIf

Return _nDias

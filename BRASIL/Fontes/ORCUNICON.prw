#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#Include "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � STTMKR64 � Autor � Jo�o Victor           � Data �13/03/13  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � xImpressao DOS ORCAMENTOS GRAFICOS                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
��� Altera��o�   Giovani Zago inverti para fwmsprinter                    ���
���          �  					                                      ���
���          �  					                                      ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ORCUNICON(_cxItens,_lPreco)

	LOCAL   n := 0
	Private _lItem   	  := MsgYesno("Exibi Itens Ocultos?")
	Private _lNde   	  := MsgYesno("Imprimi NED ?")
	Private cEmailFor	  := ""
	PRIVATE _nXmargSf7    := 0
	PRIVATE oPrint
	PRIVATE _nCabecOr    := 0
	PRIVATE _cTespd:= '501'
	PRIVATE _nVlrTot      := 0
	PRIVATE _nValTotLi    := 0
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
	PRIVATE	nValPis       := 0
	PRIVATE	nValCof	      := 0
	PRIVATE _cxCliContr   := "SA1->A1_GRPTRIB"
	PRIVATE _cCliEst      := "SA1->A1_EST"
	PRIVATE _cTipoCli 	  := "SA1->A1_TIPO"
	PRIVATE _cSuperv       := Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_REPRES,"A3_SUPER"))//Jo�o Rinaldi - Chamado 001491 
	PRIVATE	cCopia    	  := Alltrim(Lower(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND,"A3_EMAIL")))+';'+Alltrim(Lower(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_REPRES,"A3_EMAIL")))+';'+Alltrim(Lower(Posicione("SA3",1,xFilial("SA3")+_cSuperv,"A3_EMAIL")))
	PRIVATE	titulo	      := "Envio de E-Mail Cota��o n�: " + PP7->PP7_CODIGO + " - STECK IND�STRIA EL�TRICA"
	PRIVATE cBmpName  	  :=''
	PRIVATE cStartPath 	  := '\arquivos\orcamento\'//GetSrvProfString("Startpath","") +'orcamento\'
	PRIVATE _cPath		  := GetSrvProfString("RootPath","") //GetPvProfString( GetEnvServer(), "RootPath"	, "", GetAdv97() )
	PRIVATE _cNomePdf     :=''
	PRIVATE _cItens := ' '
	PRIVATE _cObsve := ' '
	PRIVATE _cObsor := ' '
	Default _lPreco:= .t.
	Private _cDirRel      := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private _lxRet         := .T.

	Default _cxItens := ' '
	_cItens := _cxItens
	DbSelectArea("PP7")

	Processa({|lEnd|xMontaRel()})

Return Nil
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MontaRel � Autor � Jo�o Victor           � Data �13/02/13  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao DO RELATORIO                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function xMontaRel()


	Dbselectarea("PP7")
	MsSeek(Xfilial("PP7") + PP7->PP7_CODIGO  )

	if eof()

		msgstop("Orcamento Nao Encontrado !!!  Verifique !!! " )

	else

		_cNomePdf  :=cEmpAnt+"Orcamento_Unicon_"+PP7->PP7_CODIGO
		oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , '\arquivos\orcamento\'  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
		oPrint:SetLandScape()     //SetPortrait() ou SetLandscape()
		oPrint:SetMargin(60,60,60,60)
		oPrint:setPaperSize(9)


		DbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+ PP7->PP7_CLIENT + PP7->PP7_LOJA ))

		Dbselectarea("SE4")
		MsSeek(Xfilial("SE4")  + PP7->PP7_CPAG )

		Dbselectarea("PP7")

		xImpress()

		// Indique o caminho onde ser� gravado o PDF
		FERASE(cStartPath+_cNomePdf+".pdf")
		oPrint:cPathPDF := cStartPath//"c:\"
		oPrint:Print()
		//FERASE('c:\'+_cNomePdf+".pdf")
		//CpyS2T(cStartPath+_cNomePdf+'.pdf','c:\',.T.) // COPIA ARQUIVO PARA MAQUINA DO USU�RIO
		//ShellExecute("open",'C:\'+_cNomePdf+'.pdf', "", "", 1)

		If ExistDir(_cDirRel)
			_lxRet := .T.
		Else
			If MakeDir(_cDirRel) == 0
				MakeDir(_cDirRel)
				Aviso("Cria��o de Pasta","Fora criado nesse computador uma pasta para que as Cota��es (Unicom) emitidas l� sejam salvas ap�s a impress�o...!!!"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"Segue o caminho do diret�rio criado:"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				_cDirRel,;
				{"OK"},3)
				_lxRet := .T.
			Else
				Aviso("Erro na Cria��o de Pasta","Para salvar a Cota��o (Unicom) em quest�o � necess�rio que uma pasta seja criada nesse computador...!!!"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"Favor entrar em contato com o TI para que a cria��o da pasta seja realizada...!!!:"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"N�o ser� poss�vel realizar a abertura da Cota��o (Unicom) em arquivo PDF e consequentemente n�o ser� enviado via e-mail ao cliente...!!!",;
				{"OK"},3)
				_lxRet := .F.
			Endif
		Endif

		If _lxRet
			FERASE(_cDirRel+"\"+_cNomePdf+".pdf")
			CpyS2T(cStartPath+_cNomePdf+'.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USU�RIO
			ShellExecute("open",_cDirRel+"\"+_cNomePdf+'.pdf', "", "", 1)
			If MsgBox("Envia e-mail ao cliente?","Envio de E-Mail","YESNO")

				U__xzlChkMail() // Abre tela Para Digitar Manualmente E-Mails


				Processa({|lEnd| xBrEnvMail(oPrint,"Cota��o: "+ PP7->PP7_CODIGO,{"Cota��o: "+ PP7->PP7_CODIGO},cEmailFor,"",{},10)},titulo)

			Endif
		Endif

	EndIf

Return nil


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � xImpress � Autor � Jo�o Victor           � Data �13/03/13  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Relat�rio                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function xImpress()

	LOCAL 	_nTxper := GETMV("MV_TXPER")
	LOCAL 	i 		:= 0
	Local	_cDMoed	:= "R$"
	LOCAL 	oBrush
	Local _nTotIPI  := 0
	Local _nTotICMSST:= 0
	Local _ncount

	Private _nLin := 4000

	aBmp := "STECK.BMP"

	//Par�metros de TFont.New()
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
	Dbselectarea("PP8")
	Dbsetorder(1)
	Dbseek(xfilial("PP8")+PP7->PP7_CODIGO)


	Do While !eof()  .and. PP7->PP7_CODIGO == PP8->PP8_CODIGO


		DbSelectArea("SA1")
		DbSetOrder(1)
		MsSeek(xFilial("SA1")+PP7->PP7_CLIENT+PP7->PP7_LOJA)



		If !Eof()
			If _nLin > 580
				If _npagina <> 0
					_npagina++
					oPrint:EndPage()
				EndIf
				oPrint:StartPage()     // INICIALIZA a p�gina
				xCabOrc()
			EndIf
		EndIf

		Do while PP8->(!eof()) .and. PP8->PP8_CODIGO  == PP7->PP7_CODIGO .and. PP8->PP8_ITEM $ _cItens //Ajustado Renato - N�o estava imprindo cota��o com um item - 301013
			//Chamado 001423 
			//_cTespd:=	U_STRETSST('01',SA1->A1_COD,SA1->A1_LOJA ,IF(EMPTY(PP8->PP8_PROD),'SUNICOM',PP8->PP8_PROD),PP7->PP7_CPAG  ,'TES')
			_cTespd:=	U_STRETSST('01',SA1->A1_COD,SA1->A1_LOJA ,IF(EMPTY(PP8->PP8_PROD),'SUNICOM',PP8->PP8_PROD),PP7->PP7_CPAG  ,'TES',,PP7->PP7_ZTIPOC, PP7->PP7_ZCONSU,,PP7->PP7_CODIGO,PP8->PP8_ITEM)

			STMAFISREL()
			_nTotIPI    := (nValIPI)+_nTotIPI
			_nTotICMSST := (nValICMSST)+_nTotICMSST

			If _nLin > 555
				_nLin+=10
				oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
				oPrint:EndPage()     // Finaliza a p�gina
				oPrint:StartPage()     // INICIALIZA a p�gina
				xCabOrc('1')
			Endif

			// Posiciona No Cad Produtos
			DbSelectArea("SB1")
			DbSetOrder(1)
			If ! Empty(Alltrim(PP8->PP8_PROD))
				MsSeek(xFilial("SB1")+PP8->PP8_PROD)
			Else
				MsSeek(xFilial("SB1")+'SUNICOM')
			EndIf
			// Posiciona No Cad De TES
			DbSelectArea("SF4")
			DbSetOrder(1)
			MsSeek(xFilial("SF4") + _cTespd,.t.)

			_nXmargSf7:= Posicione('SF7',3,xFilial("SF7")+SB1->B1_GRTRIB+&_cxCliContr+&_cCliEst+&_cTipoCli,'F7_MARGEM')

			IF PP8->PP8_CODIGO <> 'N'

				//Impressao do Item
				oPrint:Say  (_nLin,020, PP8->PP8_ITEM	,oFont10n)

				//Impressao do Codigo e Descricao do Produto
				oPrint:Say  (_nLin,040, SB1->B1_COD	,oFont10n)
				_nTam		:= 60
				_ctexto  	:= Alltrim(subStr(SB1->B1_DESC,1,43))
				If AllTrim(PP8->PP8_PROD)=="SUNICOM" .And. !Empty(PP8->PP8_DESCR)  //Chamado 001237
					_ctexto  	:= Alltrim(subStr(PP8->PP8_DESCR,1,42))
				Endif
				_nlinhas 	:= mlcount(_ctexto,_nTam)
				for _ncount:= 1 to _nlinhas
					oPrint:Say  (_nLin ,095, memoline(_ctexto,_nTam,_ncount),oFont10n)
					If _nCount <> _nLinhas
						_nLin+=60
					EndIf
				next _ncount

				//Impressao da Quantidade e Unidade de Medida
				oPrint:Say  (_nLin,280, transform(PP8->PP8_QUANT,"@E 999999.99")	,oFont10n)
				_nTam		:= 60
				_ctexto  	:= Alltrim(SB1->B1_UM)
				_nlinhas 	:= mlcount(_ctexto,_nTam)
				for _ncount:= 1 to _nlinhas
					oPrint:Say  (_nLin ,320, memoline(_ctexto,_nTam,_ncount),oFont10n)
					If _nCount <> _nLinhas
						_nLin+=60
					EndIf
				next _ncount
				If	_lPreco
					//Impressao do Valor Unitario
					oPrint:Say  (_nLin,350, transform(ROUND(PP8->PP8_PRORC,2)	,"@E 999,999.99")	,oFont10n)

					//Impressao do Percentual de IPI
					oPrint:Say  (_nLin,390, transform(nAliqIPI 	,"@E 999.99")		,oFont10n) //PP8->UB_ZIPI

					//Impressao do Percentual de ICMS
					oPrint:Say  (_nLin,420, transform(nAliqICM,"@E 999.99")		,oFont10n) //PP8->UB_ZPICMS

					//Impressao do Percentual de IVA
					oPrint:Say  (_nLin,450, transform(_nXmargSf7	,"@E 999.99")	   		,oFont10n)

					//Impressao do Valor de ICMS-ST
					oPrint:Say  (_nLin,490, transform((nValICMSST)	,"@E 99,999,999,999.99")		,oFont8) //PP8->UB_ZVALIST

					//Impressao do Valor Total
					oPrint:Say  (_nLin,550, transform(PP8->PP8_PRORC*PP8->PP8_QUANT	,"@E 9,999,999.99")	,oFont10n)
					_nValTotLi+=PP8->PP8_PRORC*PP8->PP8_QUANT
					//Impressao do Prazo de Entraga
					//	oPrint:Say  (_nLin,600, transform(PP8->UB_DTENTRE	,"@E 999.999,99")	,oFont8)

					//Impressao do NCM
					oPrint:Say  (_nLin,600, transform('85371090' 	,"@R 9999.99.99")	,oFont10n)

					//Observa��es
					oPrint:Say  (_nLin,650, PP8->PP8_OBS	,oFont10n)

					//Impressao da TES
					oPrint:Say  (_nLin,760, _cTespd	,oFont10n)				

					//Impressao da Ordem de Compra por Item
					//	oPrint:Say  (_nLin,720, transform(PP8->UB_XORDEM  	,"@!")	            ,oFont8)
				EndIf
				_nLin+=10
				Dbselectarea('SCJ')
				SCJ->(dbsetorder(1))
				Dbseek(xfilial("SCJ") + PP8->PP8_NUMORC )
				oPrint:Say  (_nLin,040, 'Ref.: '+Upper(Alltrim(PP8->PP8_DESCR))+"     Rev.: "+SCJ->CJ_XREVISA+"     Folha.: "+Alltrim(SCJ->CJ_XFOLHA)	,oFont8)
				_nLin+=11

				oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina

			Endif

			_nLin+=15

			Dbselectarea('SCJ')
			SCJ->(dbsetorder(1))
			Dbseek(xfilial("SCJ") + PP8->PP8_NUMORC )
			_cObsve :=SCJ->CJ_OBSORC
			Dbselectarea('SCK')
			SCK->(dbsetorder(1))
			Dbseek(xfilial("SCK") + SCJ->CJ_NUM )
			If !_lNde
				While SCK->(!eof()) .and. SCJ->CJ_NUM == SCK->CK_NUM
					DbSelectArea("SB1")
					DbSetOrder(1)
					MsSeek(xFilial("SB1")+SCK->CK_PRODUTO)
					If !_lItem .And. SCK->CK_XIMPORC = 'N'
						SCK->(DbSkip())
						loop
					EndIf
					If _nLin > 570
						_nLin+=10
						oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
						oPrint:EndPage()     // Finaliza a p�gina
						oPrint:StartPage()     // INICIALIZA a p�gina
						xCabOrc()
					Endif
					oPrint:Say  (_nLin,040, SB1->B1_COD	,oFont8)
					_nTam		:= 60
					_ctexto  	:= IIF(SCK->CK_PRODUTO = 'SUNICOM' .or. SCK->CK_PRODUTO = 'SUNICON',Alltrim(subStr(SCK->CK_DESCRI,1,42)),  Alltrim(subStr(SB1->B1_DESC,1,42)))
					_nlinhas 	:= mlcount(_ctexto,_nTam)
					for _ncount:= 1 to _nlinhas
						oPrint:Say  (_nLin ,095, memoline(_ctexto,_nTam,_ncount),oFont8)
						If _nCount <> _nLinhas
							_nLin+=60
						EndIf
					next _ncount

					//Impressao da Quantidade e Unidade de Medida
					oPrint:Say  (_nLin,280, transform(SCK->CK_QTDVEN,"@E 999999.99")	,oFont8)
					_nTam		:= 60
					_ctexto  	:= Alltrim(SB1->B1_UM)
					_nlinhas 	:= mlcount(_ctexto,_nTam)
					for _ncount:= 1 to _nlinhas
						oPrint:Say  (_nLin ,320, memoline(_ctexto,_nTam,_ncount),oFont8)
						If _nCount <> _nLinhas
							_nLin+=60
						EndIf
					next _ncount


					_nLin+=15
					If _nLin > 570
						_nLin+=10
						oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
						oPrint:EndPage()     // Finaliza a p�gina
						oPrint:StartPage()     // INICIALIZA a p�gina
						xCabOrc()
					Endif
					SCK->(DbSkip())
				End

				_nLin-=10
				oPrint:Line (_nLin, 005,_nLin,800)
				_nLin+=15
				If _nLin > 580
					_nLin+=10
					oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
					oPrint:EndPage()     // Finaliza a p�gina
					oPrint:StartPage()     // INICIALIZA a p�gina
					xCabOrc()
				Endif
				If _nLin > 580
					_nLin+=10
					oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
					oPrint:EndPage()     // Finaliza a p�gina
					oPrint:StartPage()     // INICIALIZA a p�gina
					xCabOrc()
				Endif
				_nLin:=600 
			EndIf
			PP8->(DbSkip())
		Enddo

		Dbselectarea("PP8")
		PP8->(DbSkip())

	Enddo

	If _nLin > 550
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a p�gina
		oPrint:StartPage()     // INICIALIZA a p�gina
		xCabOrc()
	Endif

	oPrint:Line (_nLin, 005,_nLin,800)
	// Imprime Total Do Orcamento
	_nLin+=15
	If _nLin > 550
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a p�gina
		oPrint:StartPage()     // INICIALIZA a p�gina
		xCabOrc()
	Endif
	If _lPreco
		oPrint:Say  (_nLin,550, "Valor Total dos Produtos (" + _cDMoed + ")"	,oFont10)
		oPrint:Say  (_nLin,680, ": " + Transform(_nValTotLi,"@E 9999,999.99")	,oFont10)
		If _nLin > 550
			_nLin+=10
			oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a p�gina
			oPrint:StartPage()     // INICIALIZA a p�gina
			xCabOrc()
		Endif
		_nLin+=15
		oPrint:Say  (_nLin,550, "Valor Total IPI (" + _cDMoed + ")"			,oFont10)
		oPrint:Say  (_nLin,680, ": " + Transform(_nTotIPI,"@E 9999,999.99")	,oFont10)
		If _nLin > 550
			_nLin+=10
			oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a p�gina
			oPrint:StartPage()     // INICIALIZA a p�gina
			xCabOrc()
		Endif
		_nLin+=15
		oPrint:Say  (_nLin,550, "Valor Total ICMS-ST (" + _cDMoed + ")"		,oFont10)
		oPrint:Say  (_nLin,680, ": " + Transform(_nTotICMSST,"@E 9999,999.99")	,oFont10)
		If _nLin > 550
			_nLin+=10
			oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a p�gina
			oPrint:StartPage()     // INICIALIZA a p�gina
			xCabOrc()
		Endif
		_nLin+=15
		//_nVlrTot := u_STMAFISUNI(_nValTotLi)
		oPrint:Say  (_nLin,550, "Valor Total do Or�amento (" + _cDMoed + ")"	,oFont10)
		//Chamado 001423
		oPrint:Say  (_nLin,680, ": " + Transform(_nValTotLi+_nTotICMSST+_nTotIPI,"@E 9999,999.99")	,oFont10)
		//oPrint:Say  (_nLin,680, ": " + Transform(_nVlrTot+_nTotICMSST,"@E 9999,999.99")	,oFont10)
		//oPrint:Say  (_nLin,680, ": " + Transform(SUA->UA_VLRLIQ+_nTotICMSST,"@E 9999,999.99")	,oFont10) //Renato 050913 - Solicitado somar o ICMS-ST
		If _nLin > 580
			_nLin+=10
			oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a p�gina
			oPrint:StartPage()     // INICIALIZA a p�gina
			xCabOrc()
		Endif
	Endif
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a p�gina
		oPrint:StartPage()     // INICIALIZA a p�gina
		xCabOrc()
	Endif

	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	_nLin+=15
	If _nLin > 550
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a p�gina
		oPrint:StartPage()     // INICIALIZA a p�gina
		xCabOrc()
	Endif
	// Observa��o da Cota��o:
	oPrint:Say  (_nLin,020, "Observa��o"						,oFont10)
	oPrint:Say  (_nLin,070, ": " + _cObsve  				,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a p�gina
		oPrint:StartPage()     // INICIALIZA a p�gina
		xCabOrc()
	Endif
	oPrint:Say  (_nLin,020, "Obs. Comercial:"							,oFont10)

	oPrint:Say  (_nLin,090, Alltrim(PP7->PP7_NOTAS) +'A APROVA��O DO DESENHO DEVER� SER FEITA AT� 20 DIAS AP�S O ENVIO DO MESMO. CASO CONTR�RIO, O PEDIDO PODER� SER CANCELADO '					,oFont10)
	_nLin+=15
	oPrint:Say  (_nLin,020,'Prazo de Entrega:'					,oFont10)
	oPrint:Say  (_nLin,090,'AT� 20 DIAS �TEIS AP�S APROVA��O DO DESENHO. CASO HAJA ALTERA��O, SERA INFORMADO PELO DEPARTAMENTO COMERCIAL. '					,oFont10)

	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a p�gina
		oPrint:StartPage()     // INICIALIZA a p�gina
		xCabOrc()
	Endif
	oPrint:Say  (_nLin,020, "Obra:"							,oFont10)
	oPrint:Say  (_nLin,090, PP7->PP7_OBRA					,oFont10)

	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a p�gina
		oPrint:StartPage()     // INICIALIZA a p�gina
		xCabOrc()
	Endif
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	// Inicia Mensagens Do Orcamento
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a p�gina
		oPrint:StartPage()     // INICIALIZA a p�gina
		xCabOrc()
	Endif
	// Imprime Vendedor
	_cVend1 := Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND,"A3_NOME"))
	oPrint:Say  (_nLin,020, "Operador"							,oFont10)
	oPrint:Say  (_nLin,060, ": " + Capital(_cVend1)				,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a p�gina
		oPrint:StartPage()     // INICIALIZA a p�gina
		xCabOrc()
	Endif
	_cVend2 := Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND,"A3_TEL"))
	oPrint:Say  (_nLin,020, "Telefone"							,oFont10)
	oPrint:Say  (_nLin,060, ": " + Capital(_cVend2)				,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a p�gina
		oPrint:StartPage()     // INICIALIZA a p�gina
		xCabOrc()
	Endif
	_cVend3 := Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND,"A3_FAX"))
	oPrint:Say  (_nLin,020, "Fax"						 		,oFont10)
	oPrint:Say  (_nLin,060, ": " + Capital(_cVend3)		 		,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a p�gina
		oPrint:StartPage()     // INICIALIZA a p�gina
		xCabOrc()
	Endif
	_cVend4 := Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND,"A3_EMAIL"))
	oPrint:Say  (_nLin,020, "E-mail"							,oFont10)
	oPrint:Say  (_nLin,060, ": " + lower(_cVend4)				,oFont10)
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a p�gina
		oPrint:StartPage()     // INICIALIZA a p�gina
		xCabOrc()
	Endif
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina

	oPrint:EndPage()     // Finaliza a p�gina
	//oPrint:Preview()
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Programa  �xCabOrc   �Autor  � Jo�o Victor        � Data � 13/02/13    ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Steck                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function xCabOrc (_cRt)

	Local _cFrete	:= ""
	Default _cRt:='2'
	_nCabecOr++

	If _nCabecOr = 1  .Or. _cRt='1'
		oPrint:Box(045,005,580,800)

		If File(aBmp)
			oPrint:SayBitmap(060,020,aBmp,095,050 )
		EndIf

		oPrint:Say  (065,120, _cNomeCom  ,oFont12)
		oPrint:Say  (080,120, _cEndereco ,oFont12)
		oPrint:Say  (095,120,"CEP: "+ SUBSTR(cCep,1,5)+"-"+SUBSTR(cCep,6,3) +" - "+Alltrim(cCidade)+" - "+cEstado,oFont12)
		oPrint:Say  (110,120,"TEL.: (11) 2248-7000 | FAX.: (11) 2248-7051 | E-MAIL: contato.vendas@steck.com.br",oFont12)

		dbselectarea("SA1")
		MsSeek(Xfilial("SA1")  + PP7->PP7_CLIENTE + PP7->PP7_LOJA )

		oPrint:Box(125,005,230,800)

		oPrint:Say  (140,020,"Empresa: "+ Upper(SA1->A1_NOME)         									,oFont12)
		oPrint:Say  (155,020,"C�digo de Cliente: "+ PP7->PP7_CLIENT + " - " + PP7->PP7_LOJA + " - CONTATO: "+ PP7->PP7_CONTAT				,oFont12)

		oPrint:Say  (170,020,"Dados de Faturamento: " 													,oFont12)
		oPrint:Say  (185,020,Upper(Alltrim(SA1->A1_END) + " - " + Alltrim(SA1->A1_BAIRRO) + " - " + Alltrim(SA1->A1_MUN) + " - " + Alltrim(SA1->A1_EST) + " - " + Alltrim(SA1->A1_CEP))         					,oFont12)
		oPrint:Say  (200,020,TRANSFORM(SA1->A1_CGC,PESQPICT("SA1","A1_CGC"))			        			,oFont12)
		oPrint:Say  (215,020,"I.E.: "+ SA1->A1_INSCR 											   			,oFont12)

		oPrint:Box(230,005,295,800)
		cBmpName  :=PP7->PP7_CODIGO
		oPrint:Say  (245,020,"Atendimento"					,oFont12)
		oPrint:Say  (245,080,": " + PP7->PP7_CODIGO				,oFont12)
		oPrint:Say  (245,220,"Emiss�o" 						,oFont12)
		oPrint:Say  (245,310,": " + dtoc(PP7->PP7_EMISSA)	,oFont12)
		/*
		dbselectarea("SU5")
		MsSeek(Xfilial("SU5")  + PP7->PP7_CPAG)
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
		*/
		dbselectarea("SE4")
		MsSeek(Xfilial("SE4")  + PP7->PP7_CPAG )

		oPrint:Say  (275,020, "Cond. Pagto" 						,oFont12)
		oPrint:Say  (275,080, ": " + SE4->E4_DESCRI				,oFont12)
		//oPrint:Say  (275,220, "Ordem de Compra" 					,oFont12)
		//oPrint:Say  (275,310, ": "+ SUA->UA_XORDEM				,oFont12)

		Do case
			Case PP7->PP7_TPFRET = "F"
			_cFrete := "FOB"
			Case PP7->PP7_TPFRET = "C"
			_cFrete := "CIF"
			Case PP7->PP7_TPFRET = "T"
			_cFrete := "TERCEIROS"
			Case PP7->PP7_TPFRET = "S"
			_cFrete := "SEM FRETE"
		EndCase

		oPrint:Say  (260,020, "Frete"						,oFont12)
		oPrint:Say  (260,080, ": "	+ (_cFrete)			,oFont12)
		oPrint:Say  (260,220, "Validade"					,oFont12)
		oPrint:Say  (260,310, ": "+dtoc(ddatabase+15)	,oFont12)

		oPrint:Box(295,005,320,800)
		oPrint:Say  (310,020, "Item"			    	,oFont10)
		oPrint:Say  (310,040, "C�digo"					,oFont10)
		oPrint:Say  (310,095, "Descri��o"				,oFont10)
		oPrint:Say  (310,280, "Qtde." 					,oFont10)
		oPrint:Say  (310,320, "UM"						,oFont10)
		oPrint:Say  (310,350, "Vlr Unit"  				,oFont10)
		oPrint:Say  (310,390, "IPI"				    	,oFont10)
		oPrint:Say  (310,420, "ICMS"				   	,oFont10)
		oPrint:Say  (310,450, "IVA"				    	,oFont10)
		oPrint:Say  (310,490, "ICMS-ST"				    ,oFont10)
		oPrint:Say  (310,550, "Valor Total"				,oFont10)
		//oPrint:Say  (310,600, "Prazo Entrega"			,oFont10)
		oPrint:Say  (310,600, "Clas. Fiscal"			,oFont10)
		oPrint:Say  (310,650, "Observa��es"			,oFont10)
		oPrint:Say  (310,760, "Cod. Fiscal"        			,oFont10)
		//oPrint:Say  (310,720, "Ordem/Produto"			,oFont10)

		_nLin := 330
	Else
		oPrint:Box(045,005,580,800)
		_nLin := 070
		oPrint:Say  (_nLin,020, "Item"			    	,oFont10)
		oPrint:Say  (_nLin,040, "C�digo"					,oFont10)
		oPrint:Say  (_nLin,095, "Descri��o"				,oFont10)
		oPrint:Say  (_nLin,280, "Qtde." 					,oFont10)
		oPrint:Say  (_nLin,320, "UM"						,oFont10)
		oPrint:Say  (_nLin,350, "Vlr Unit"  				,oFont10)
		oPrint:Say  (_nLin,390, "IPI"				    	,oFont10)
		oPrint:Say  (_nLin,420, "ICMS"				   	,oFont10)
		oPrint:Say  (_nLin,450, "IVA"				    	,oFont10)
		oPrint:Say  (_nLin,490, "ICMS-ST"				    ,oFont10)
		oPrint:Say  (_nLin,550, "Valor Total"				,oFont10)
		//oPrint:Say  (310,600, "Prazo Entrega"			,oFont10)
		oPrint:Say  (_nLin,600, "Clas. Fiscal"			,oFont10)
		oPrint:Say  (_nLin,650, "Observa��es"			,oFont10)
		oPrint:Say  (_nLin,760, "Cod. Fiscal"        			,oFont10)

		//oPrint:Say  (310,720, "Ordem/Produto"			,oFont10)
		_nLin += 015
		oPrint:Line (_nLin, 005,_nLin,800)
		_nLin += 020
	EndIf
Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �xBrEnvMail� Autor � Jo�o Victor           � Data �13/03/13  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Envio Do Orcamento/Cotacao por e-mail automaticamente      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

	cMensagem += "<br><font Face='CALIBRI' >" + "Cota��o enviada automaticamente pelo sistema PROTHEUS" + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "Enviado por: " + UsrFullName(RetCodUsr()) + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "ATEN��O!!! AO RESPONDER ESSE E-MAIL FAVOR COPIAR A TODOS OS ENVOLVIDOS NO MESMO!!!" + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "Cota��o n�: " + PP7->PP7_CODIGO + "</font></br>"

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

	If  !(	U_STMAILTES(cEmailFor,cCopia,titulo,cMensagem,_aAttach,_cCaminho)  )
		MsgInfo("Email n�o Enviado.....!!!!!")
	EndIf

Return lOk

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �_xlChkMail� Autor � Jo�o Victor           � Data �13/03/13  ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Caixa De Texto Para Digita��o De E-Mail Opcional.          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function _xzlChkMail()

	//Variaveis Locais da Funcao
	Local oEdit1
	Local _lRet		:= .f.
	cEMailFor 		:= Alltrim(Lower(SU5->U5_EMAIL)) + Space(200)

	// Variaveis Private da Funcao
	Private _oDlg				// Dialog Principal
	Private INCLUI := .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao

	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Envio Autom�tico de E-Mail") FROM C(330),C(243) TO C(449),C(721) PIXEL


	// Cria Componentes Padroes do Sistema
	@ C(008),C(009) Say "Envia e-mail para Cliente listado abaixo? (Separar por ';')" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(021),C(010) MsGet oEdit1 Var cEMailFor Size C(218),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
	@ C(044),C(137) Button OemtoAnsi("Envia") Size C(037),C(012) PIXEL OF _oDlg	Action Eval( { || _lRet:= .t. , _oDlg:End() }  )
	@ C(044),C(185) Button OemtoAnsi("Cancela") Size C(037),C(012) PIXEL OF _oDlg	Action(_oDlg:End())


	ACTIVATE MSDIALOG _oDlg CENTERED

Return(_lRet)

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()      � Autor � Norbert Waage Junior  � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolu��o horizontal do Monitor do Usuario.                  ���
����������������������������������������������������������������������������Ĵ��
���Uso        � Especifico Steck                                             ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/

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
		//���������������������������Ŀ
		//�Tratamento para tema "Flat"�
		//�����������������������������
		If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �STMAFISREL� Autor � Jo�o Victor           � Data �13/03/13  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Abre o MAFISRET para trazer os valores dos tributos        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function STMAFISREL()

	MaFisSave()
	MaFisEnd()
	MaFisIni(SA1->A1_COD,;	// 1-Codigo Cliente/Fornecedor
	SA1->A1_LOJA ,;			// 2-Loja do Cliente/Fornecedor
	"C",;					// 3-C:Cliente , F:Fornecedor
	"N",;					// 4-Tipo da NF
	SA1->A1_TIPO,;			// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")                                                               // 10-Nome da rotina que esta utilizando a funcao

	MaFisAdd( IF(EMPTY(PP8->PP8_PROD),'SUNICOM',PP8->PP8_PROD)	,;                                               // 1-Codigo do Produto ( Obrigatorio )
	_cTespd ,;                                                            // 2-Codigo do TES ( Opcional )
	PP8->PP8_QUANT,;                                                          // 3-Quantidade ( Obrigatorio )
	PP8->PP8_PRORC*PP8->PP8_QUANT,;                                                         // 4-Preco Unitario ( Obrigatorio )
	0,;                														 // 5-Valor do Desconto ( Opcional )
	,;                                                                       // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                       // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                       // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                      // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                      // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                      // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                      // 12-Valor do Frete Autonomo ( Opcional )
	PP8->PP8_PRORC*PP8->PP8_QUANT,;														 // 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                      // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                      // 15-RecNo do SB1
	0)                                                                       // 16-RecNo do SF4

	nAliqICM 	:= (MaFisRet(1,'IT_ALIQICM',5,2)  )    //Aliquota do ICMS
	nValICms	:= (MaFisRet(1,'IT_VALICM',14,2)  )    //Valor do ICMS

	nAliqIPI 	:= (MaFisRet(1,"IT_ALIQIPI",5,2)  )    //Aliqutota do IPI
	nValIPI 	:= (MaFisRet(1,"IT_VALIPI",14,2)  )    //Valor do IPI

	nValICMSST 	:= (MaFisRet(1,'IT_VALSOL',14,2)  )    //Valor do ICMS-ST

	nValPis		:= (MaFisRet(1,"IT_VALPS2",14,2)  )    //Valor do PIS
	nValCof		:= (MaFisRet(1,"IT_VALCF2",14,2)  )    //Valor do COFINS

	mafisend()

Return


Static Function StMSg()
	Local _cText:= ("CONDI��ES GERAIS DE VENDA PARA PRODUTOS E SERVI�OS"+;
	"AAAA"+;
	"PCOM_003_01 - Revis�o: 1"+;
	"AAAA"+;
	"01 de Abril de 2013"+;
	"AAAA"+;
	"1� INTRODU��O:"+;
	"AAAA"+;
	"1-1: As Condi��es Gerais de Venda, doravante denominadas CGV, constituem condi��es comerciais, t�cnicas e jur�dicas "+;
	"b�sicas para o FORNECIMENTO de produtos e/ou servi�os pela STECK IND�STRIA EL�TRICA LTDA, doravante denominada "+;
	"STECK, e ser�o aplicadas sempre que referidas como anexo nas propostas, acordos ou quaisquer contratos para "+;
	"FORNECIMENTO de produtos e servi�os da STECK. As presentes CGV s�o aplic�veis sem preju�zo da aplica��o de "+;
	"condi��es espec�ficas que venham a ser mutuamente ajustadas entre as PARTES. "+;
	"1-2: Quaisquer disposi��es em contr�rio �s presentes CGV, que n�o tenham sido objeto de acordo, por escrito com a "+;
	"STECK, n�o criar�o nenhuma obriga��o para a STECK, que se obriga exclusivamente pelas cl�usulas destas CGV, de sua "+;
	"proposta e do instrumento contratual assinado entre a STECK e o CLIENTE. Na aus�ncia de condi��es espec�ficas "+;
	"mutuamente acordadas entre as PARTES, as disposi��es das presentes CGV ser�o as �nicas aplic�veis ao FORNECIMENTO."+;
	"1-3: Para efeito das presentes CGV, considerar-se-�o:. "+;
	"Produtos - Todas as pe�as, equipamentos, materiais, partes, componentes, sistemas ou quaisquer outras refer�ncias de "+;
	"PRODUTOS entregues pela STECK, seus PP8fornecedores e/ou PP8contratados, ao CLIENTE. Sendo eles: Caixas de "+;
	"Passagem e Distribui��o, Comando e Prote��o (disjuntores, rel�s, contatores, etc), Plugues e Tomadas - Uso "+;
	"Industrial/Comercial/Residencial, Produtos para displays, Quadros de Distribui��o, Unidades Combinadas e Bloqueios "+;
	"Mec�nicos."+;
	"Servi�os - Toda presta��o contratada pelo CLIENTE que envolva pr�-montagem, montagem, instala��o, "+;
	"acompanhamento, supervis�o, testes, comissionamento, manuten��o, constru��o ou quaisquer outras refer�ncias de "+;
	"SERVI�OS prestados pela STECK, seus PP8fornecedores e/ou PP8contratados ao CLIENTE."+;
	"Fornecimento � Todos os PRODUTOS e/ou SERVI�OS, conforme o caso, contratados pelo CLIENTE, e que ser�o objeto de "+;
	"entrega ou presta��o pela STECK, seus PP8contratados e/ou PP8fornecedores."+;
	;
	"2: CARACTER�STICAS DOS PRODUTOS, SERVI�OS, EMBALAGEM E CONDI��ES DE FORNECIMENTO:."+;
	"2-1: As quantidades e caracter�sticas dos produtos e servi�os objeto do FORNECIMENTO determinar-se-�o pela proposta."+;
	"Nenhuma responsabilidade ou obriga��o ter� a STECK no que concerne a produtos e servi�os que n�o tenham sido "+;
	"or�ados ou que n�o constem da confirma��o do pedido."+;
	"2-2: Todas as informa��es e dados constantes de documentos anexos � proposta tais como cat�logos, fotografias, "+;
	"desenhos, refer�ncias t�cnicas, pesos, medidas e listas de pre�os, s�o apenas exemplificativos e somente poder�o ser "+;
	"considerados como vinculantes das caracter�sticas do FORNECIMENTO contratado nas suas partes e caracter�sticas que "+;
	"forem expressamente referidas na proposta."+;
	"2-3: Os materiais e seus respectivos fabricantes constantes na proposta s�o dados apenas como refer�ncia para projeto e "+;
	"fabrica��o. Em casos de dificuldades de aquisi��o, particularmente por raz�es de disponibilidade, a STECK reserva-se no "+;
	"direito de PP8stitu�-los por outros tecnicamente equivalentes."+;
	"2-4: Os produtos ser�o entregues em embalagem padr�o (caixa de papel�o)."+;
	"2-5: 2.5	Todos os produtos s�o bipados e registrados gravando o seu lote (rastreabilidade), caso ocorra algum problema "+;
	" t�cnico com uma linha de produto, � poss�vel identificar atrav�s do lote as notas fiscais de sa�da e consequentemente "+;
	"quais clientes receberem o produto, para que assim sejam realizadas as provid�ncias necess�rias. "+;
	;
	"3: VALIDADE DA PROPOSTA:."+;
	"3-1: O prazo de validade das condi��es t�cnicas e comerciais ser� o previsto na proposta ou, caso a proposta n�o tenha "+;
	"estabelecido prazo, ficar� este fixado em 07 (sete) dias corridos contados da apresenta��o. Ap�s este prazo, as condi��es "+;
	"dever�o ser renegociadas e uma nova proposta dever� ser apresentada."+;
	"3-2: A validade de qualquer proposta apresentada pela STECK, sob qualquer forma, ficar� condicionada � aprova��o ou "+;
	"confirma��o do cadastro e respectivo limite de cr�dito do CLIENTE podendo eventualmente ser solicitadas garantias de "+;
	"pagamento, sem �nus para a STECK."+;
	;
	"4: PRE�O, REAJUSTE E CONDI��ES DE PAGAMENTO:."+;
	"Os pre�os dos produtos e servi�os da STECK s�o resultantes das estimativas de custos, condi��es de proposta, condi��es "+;
	"de pol�tica econ�mica do pa�s e legisla��o tribut�ria vigente na sua data-base."+;
	"Os pre�os estar�o sujeitos a reajuste, sempre na menor periodicidade permitida pela legisla��o contada a partir da data "+;
	"da proposta, pela varia��o do IGPM-FGV, ou outro �ndice equivalente que venha a PP8stitu�-lo."+;
	"O pagamento dos produtos ou servi�os ser� efetuado de acordo com as condi��es estabelecidas em cada Pedido de "+;
	"Compra aceito pela STECK, atrav�s de rede banc�ria autorizada."+;
	"Considera-se como in�cio de contagem do prazo de pagamento a data de emiss�o da nota fiscal de faturamento."+;
	"No caso de atrasos de pagamentos, sem preju�zo do direito da STECK de suspender a execu��o do FORNECIMENTO, o "+;
	"CLIENTE ficar� sujeito a aplica��o de multa de 2% (dois por cento) ao m�s, corre��o monet�ria pelo IGP-M-FGV e juros de "+;
	"mora de 1% (um por cento) ao m�s pro rata die, todos calculados sobre o valor em atraso. Tais encargos ser�o devidos a "+;
	"partir do primeiro dia de atraso e at� o efetivo pagamento, independentemente de qualquer notifica��o judicial ou "+;
	"extrajudicial."+;
	;
	"5: PRAZOS DE ENTREGA:."+;
	"Os pedidos ser�o entregues de acordo com as condi��es acordadas e com a disponibilidade do estoque da STECK."+;
	"O CLIENTE ter� um prazo m�ximo de 03 (tr�s) dias ap�s ter recebido o produto para comunicar a STECK qualquer "+;
	"diverg�ncia em rela��o ao Pedido. A STECK, por sua vez, compromete-se a corrigir as n�o conformidades dentro do "+;
	"menor prazo poss�vel."+;
	"Eventuais devolu��es, contatar o vendedor respons�vel porem somente ser�o aceites ap�s a aprova��o da diretoria "+;
	"comercial. N�o ser�o aceitas devolu��es de produtos fabricados especialmente para atender �s necessidades do CLIENTE "+;
	"e/ou produtos com embalagem danificada."+;
	;
	"6: INSPE��ES:."+;
	"No caso do CLIENTE desejar que o material seja PP8metido � inspe��o, dever� fazer solicita��o durante a negocia��o do "+;
	"pedido, indicando nesta oportunidade os tipos de provas desejadas. A STECK informar� sobre a disponibilidade da "+;
	"inspe��o e os custos envolvidos a serem cobrados para cada prova requerida."+;
	;
	"7: PATENTES E DIREITOS DE PROPRIEDADE INDUSTRIAL."+;
	"O direito de propriedade sobre estudos, projetos, relat�rios, manuais, desenhos e demais elementos t�cnicos "+;
	"eventualmente entregues pela STECK ao CLIENTE, inclusive aqueles que venham a ser desenvolvidos em raz�o do "+;
	"FORNECIMENTO, permanecer�o com a STECK. Tais documentos pertencentes � STECK devem ser considerados como "+;
	"confidenciais, motivo pelo qual o CLIENTE dever� manter sigilo quanto a eles, n�o os transmitindo ou entregando-os a "+;
	"terceiros, salvo com pr�via e expressa autoriza��o por escrito da STECK. Da mesma forma, a STECK obriga-se a manter "+;
	"sigilo quanto a desenhos e informa��es t�cnicas que sejam recebidos do CLIENTE e declarados por este como "+;
	"confidenciais."+;
	"O CLIENTE ter� uma licen�a limitada, n�o exclusiva para utiliza��o de desenhos e demais elementos t�cnicos da STECK "+;
	"relativos ao FORNECIMENTO somente para os fins espec�ficos de opera��o e manuten��o do FORNECIMENTO. Em caso "+;
	"de rescis�o do FORNECIMENTO por inadimplemento do CLIENTE fica revogada a licen�a estabelecida nesta cl�usula."+;
	;
	"8: SOLICITA��O DOS PEDIDOS:."+;
	"Os meios para solicita��o dos Pedidos de Compra s�o:."+;
	"e-mail: do vendedor respons�vel pelo cliente."+;
	"Telefone: 11 2248-7000 "+;
	"Fax: 11 2248-7051 11-2248-7069."+;
	"Correio: : Rua Samarit�, 1117 � 3 andar � S�o Paulo � SP."+;
	;
	"9: ACEITA��O:."+;
	"A STECK analisar� os Pedidos de Compra solicitados, e em caso de diverg�ncias envolvendo referencia do produto, pre�o, "+;
	"prazo de entrega, condi��es de pagamento ou de entrega, informar� a empresa compradora para os devidos acertos."+;
	"Devido aos custos com a an�lise dos pedidos, separa��o e entrega de produtos, cada solicita��o de compra dever� "+;
	"respeitar um valor m�nimo descrito no or�amento e que � de R$ 1.500,00 (Uns Mil e quinhentos reais). Para valores inferiores, a "+;
	"STECK sugere que o CLIENTE adquira os produtos diretamente na rede de Distribuidores Autorizados, que est�o "+;
	"localizados em todo o territ�rio Nacional."+;
	"Caso o CLIENTE discorde destas altera��es, esta dever� informar � STECK em at� 24 (vinte e quatro) horas, contadas a "+;
	"partir do recebimento da Confirma��o, para que seja poss�vel suspender o faturamento at� que as diverg�ncias sejam "+;
	"negociadas."+;
	;
	"10: ALTERA��ES/CANCELAMENTOS:."+;
	"Eventuais cancelamentos ou altera��es de Pedidos dever�o ser solicitados diretamente atrav�s do e-mail do vendedor "+;
	"respons�vel pelo cliente ou do fax 11 2248-7051."+;
	"O prazo m�ximo para solicita��es de cancelamentos � de dois dias contados da data de confirma��o do pedido."+;
	;
	"11: PRAZOS PARA FATURAMENTO:."+;
	"Eventualmente alguns pedidos registrados na STECK, podem sofrer altera��es nos prazos de faturamento, por�m, o "+;
	"cliente ser� informado antecipadamente via e-mail ou telefone sobre a nova data."+;
	;
	"12: GARANTIA:."+;
	"O prazo de garantia contra defeitos de fabrica��o, devidamente comprovado, � de 12 (doze) meses a contar da data da "+;
	"Nota Fiscal de faturamento."+;
	"A garantia se aplica para produtos entregues em nossa f�brica e n�o abranger� estragos e avarias decorrentes de "+;
	"acidentes, instala��es inadequadas ou ocorr�ncias causadas por terceiros. Exclui-se tamb�m da garantia o desgaste "+;
	"devido ao uso intensivo dos materiais e que ultrapassem a vida el�trica ou mec�nica especificada em cat�logo, danos "+;
	"causados por neglig�ncia, imper�cia ou imprud�ncia na manuten��o, uso impr�prio ou inadequado, armazenagem "+;
	"inadequada e motivos de for�a maior ou caso fortuito."+;
	"No caso de eventuais defeitos de fabrica��o ocorridos durante o per�odo de garantia, o CLIENTE dever� informar � STECK "+;
	"sobre o tipo de defeito ocorrido atrav�s do e-mail contato@STECKZZZZcomZZZZbr ou do fax 11 2248-7051. A STECK se "+;
	"compromete a analisar o ocorrido e consertar ou a PP8stituir o produto dentro do mais curto espa�o de tempo poss�vel."+;
	"Confirmado que o defeito se encontra dentro das condi��es de garantia acima especificadas, eventuais custos de m�o de "+;
	"obra e materiais para repara��o ou PP8stitui��o ser�o assumidos pela STECK."+;
	"As regras acima definidas se aplicam somente para produtos vendidos diretamente pela STECK ou por seus parceiros no "+;
	"mercado brasileiro."+;
	;
	"13: LIMITA��O DE RESPONSABILIDADE POR PERDAS E DANOS:."+;
	"A responsabilidade da STECK por indenizar eventuais perdas e danos que causar relacionadas ao FORNECIMENTO seja por "+;
	"inadimplementos, neglig�ncia, imprud�ncia, imper�cia, indeniza��es, quebra de garantias, ou qualquer outra causa, quer "+;
	"se constituam por fato ou ato isolado ou pela totalidade dos mesmos, fica limitada aos danos diretos causados ao "+;
	"CLIENTE durante o prazo de execu��o do FORNECIMENTO e at� o t�rmino do prazo de garantia e ao valor total agregado "+;
	"de 50% (cinquenta por cento) do valor do FORNECIMENTO."+;
	"Fica entendido ainda, que a STECK n�o ser� respons�vel, em hip�tese alguma por indenizar eventuais lucros cessantes, "+;
	"perdas de receita ou de produ��o, perdas de contratos, custos de ociosidade, custos adicionais de energia, penalidades "+;
	"do poder concedente, danos a imagem ou quaisquer hip�teses de danos indiretos e/ou consequentes. A limita��o de "+;
	"responsabilidade prevista nesta cl�usula prevalece e aplica-se para fins de delimitar qualquer disposi��o contratual que "+;
	"diga respeito a indeniza��es ou compensa��es devidas pela STECK."+;
	;
	"14: FOR�A MAIOR:."+;
	"A STECK ser� automaticamente liberada de qualquer compromisso relativo aos per�odos de entrega, bem como n�o ser� "+;
	"respons�vel pelo inadimplemento que resultar de eventos de caso fortuito e/ou for�a maior ou eventos que ocorrerem "+;
	"nas instala��es da STECK, ou nas de seus fornecedores que possam interromper a organiza��o ou a atividade comercial "+;
	"da empresa, como, por exemplo, greves patronais, greves, guerras, impedimentos, inc�ndio, inunda��o, acidente com "+;
	"m�quinas, pe�as sucateadas no processo de fabrica��o, interrup��o ou atraso no transporte ou aquisi��o de mat�ria-prima, "+;
	"energia ou componentes, ou qualquer outro evento fora do controle da STECK ou seus fornecedores. Os prazos definitivos "+;
	"ser�o automaticamente prorrogados nos casos de descumprimento contratual por parte da Compradora sem a aplica��o "+;
	"de qualquer penalidade � STECK tais como: (i) Atrasos de qualquer pagamento ou inadimplemento de qualquer obriga��o "+;
	"da Compradora; (ii) Atraso na entrega ou devolu��o pela Compradora de documentos que este deva apresentar � STECK "+;
	"ou submetidos pela STECK para a aprecia��o/aprova��o da Compradora; (iii) Modifica��o pela Compradora de desenhos e/ou "+;
	"demais dados e/ou documentos t�cnicos j� aprovados; "+;
	"14-1: Leis Aplic�veis, Media��o Informal, Arbitragem e Foro � Controv�rsias; "+;
	"Os contratos de compra e venda sujeitos a estes termos e condi��es ser�o regidos pelas leis vigentes no Brasil, "+;
	"� exclus�o de suas disposi��es de conflito de leis e com a Conven��o de Viena de 1980 sobre a Venda Internacional de Bens (�CISG�). "+;
	"As partes elegem para a solu��o de qualquer controv�rsia relativa a qualquer oferta emitida, ou quaisquer contratos "+;
	"de compra e venda celebrados pela STECK, que n�o possam ser solucionadas extrajudicialmente, o foro da Comarca de S�o Paulo, "+;
	"com a exclus�o de quaisquer outros, mesmo no caso de processos sum�rios, chamamento de terceiros ou v�rios r�us. "+;
	;
	"15: OBSERVA��ES GERAIS:."+;
	"Caso o CLIENTE necessite de uma contrata��o com caracter�sticas particulares, diferentes das condi��es aqui "+;
	"estabelecidas, esta se realizar� atrav�s de um contrato de fornecimento espec�fico, negociado e acordado entre as partes."+;
	"O CLIENTE ao entregar o Pedido de Compra � STECK concorda e aceita integralmente as condi��es aqui estabelecidas, que "+;
	"prevalecer� sobre qualquer outra condi��o da compradora."+;
	"Caso a compradora esteja localizada em �reas com benef�cios fiscais como, por exemplo, a Zona Franca de Manaus e "+;
	"adquira produtos na STECK com benef�cios da n�o tributa��o do ICMS e/ou IPI, a mesma dever� proceder de acordo com "+;
	"as informa��es solicitadas pela SUFRAMA, para internamento da mercadoria, que dever� ocorrer em at� 60 dias da data "+;
	"da emiss�o da Nota Fiscal. O n�o cumprimento das orienta��es solicitadas pela SUFRAMA, dentro do prazo acima, implica "+;
	"em penalidades conforme descrito por lei e caso a STECK seja obrigada a recolher os impostos, a mesma repassar� estes "+;
	"valores acrescidos de todos os encargos legais para a compradora."+;
	;
	"e-mail: contato@STECKZZZZcomZZZZbrAAAA"+;
	"Comercial / Administra��o:AAAA"+;
	"Rua Samarit�, 1117 � 3 andarAAAA"+;
	"Jardim das laranjeiras - Cep: 02518-080/SP")

Return  (alltrim(_cText))
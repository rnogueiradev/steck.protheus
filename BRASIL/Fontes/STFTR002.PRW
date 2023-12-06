#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#Include "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ STFTR002 ³ Autor ³ RGV Solucoes          ³ Data ³07/Fev/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DOS ORCAMENTOS GRAFICOS INTERNO                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STFTR002()
	
	
	
	Private _Lmomat       := IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	/*/
	DbSelectArea('SCK')
	SCK->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	If SCK->(DbSeek(xFilial("SCK")+SCJ->CJ_NUM))
		While SCK->(!Eof()) .and. SCK->CK_FILIAL+SCK->CK_NUM == xFilial("SCK")+SCJ->CJ_NUM
			
			SCK->(RecLock("SCK",.F.))
			SCK->CK_ZB2QATU :=  u_versaldo(SCK->CK_PRODUTO)
			SCK->CK_DTENTRE  :=  u_atudtentre(SCK->CK_ZB2QATU,SCK->CK_PRODUTO,SCK->CK_QUANT)
			SCK->(MsUnlock())
			
			SCK->(DbSkip())
		End
	Endif
	/*/
	
	_lValor := .f.
	if MsgYesno("Imprime Valores ?? ")
		_lValor := .t.
	endif
	
	STTMKR64()
	
Return()


Static Function STTMKR64()
	
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
	PRIVATE	nValPis       := 0
	PRIVATE	nValCof	      := 0
	PRIVATE _cxCliContr   := SA1->A1_GRPTRIB
	PRIVATE _cCliEst      := SA1->A1_EST
	//PRIVATE _cTipoCli 	  := SCJ->CJ_XTIPO
	
	DbSelectArea("SCJ")
	
	Processa({|lEnd|xMontaRel()})
	
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MontaRel ³ Autor ³ RGV Solucoes          ³ Data ³13/02/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao DO RELATORIO                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xMontaRel()
	
	Dbselectarea("SCJ")
	MsSeek(Xfilial("SCJ") + SCJ->CJ_NUM  )
	
	if eof()
		
		msgstop("Orcamento Nao Encontrado !!!  Verifique !!! " )
		
	else
		
		oPrint:= TMSPrinter():New( "Orcamento" )
		oPrint:SetLandScape()     //SetPortrait() // ou SetLandscape()
		
		dbselectarea("SA1")
		MsSeek(Xfilial("SA1")  + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA )
		
		dbselectarea("SE4")
		MsSeek(Xfilial("SE4")  + scj->cj_Condpag )
		
		Dbselectarea("SCJ")
		
		xImpress()
		
		oPrint:Preview()     // ViSCJliza antes de imprimir
		
	Endif
	
Return nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ xImpress ³ Autor ³RGV Solucoes           ³ Data ³13/03/13  ³±±
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
	Local	_cDMoed	:= "R$"//Alltrim(SuperGetMv("MV_SIMB" + Alltrim(Str(SCJ->CJ_MOEDA,1))))
	LOCAL 	oBrush
	Local _nTotIPI  := 0
	Local _nTotICMSST:= 0
	Local _ncount:= 0
	
	
	
	
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
	Dbselectarea("SCK")
	Dbsetorder(1)
	Dbseek(xfilial("SCJ")+SCJ->CJ_NUM)
	
	Do While !eof()  .and. SCJ->CJ_NUM == SCK->CK_NUM
		
		
		Dbselectarea("SCJ")
		MsSeek(Xfilial("SCJ") + SCK->CK_NUM  )
		
		DbSelectArea("SA1")
		DbSetOrder(1)
		MsSeek(xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA)
		
		Dbselectarea("SCK")
		Dbsetorder(1)
		MsSeek(xfilial("SCK")+SCJ->CJ_NUM)
		
		If !Eof()
			If _nLin > 2300
				If _npagina <> 0
					_npagina++
					CUEndPage()
				EndIf
				oPrint:StartPage()     // INICIALIZA a página
				xCabOrc()
			EndIf
		EndIf
		
		
		
		Do while !eof() .and. SCK->CK_NUM == SCJ->CJ_NUM
			
			STMAFISREL()
			_nTotIPI    := (nValIPI)+_nTotIPI
			_nTotICMSST := (nValICMSST)+_nTotICMSST
			
			
			if _nLin > 2300
				_nLin+=30
				oPrint:Say  (_nLin,1400, "* * *   C O N T I N U A    * * *",oFont12)
				oPrint:EndPage()     // Finaliza a página
				xCabOrc()
				oPrint:StartPage()     // INICIALIZA a página
			endif
			
			
			// Posiciona No Cad Produtos
			DbSelectArea("SB1")
			DbSetOrder(1)
			MsSeek(xFilial("SB1")+SCK->CK_PRODUTO)
			
			// Posiciona No Cad De TES
			DbSelectArea("SF4")
			DbSetOrder(1)
			MsSeek(xFilial("SF4") + SCK->CK_TES,.t.)
			
			
			IF SCK->CK_NUM <> 'N'
				
				//Impressao do Item
				oPrint:Say  (_nLin,0100, SCK->CK_ITEM	,oFont8)
				
				//Impressao do Codigo e Descricao do Produto
				oPrint:Say  (_nLin,0170, SCK->CK_produto	,oFont8)
				_nTam		:= 60
				_ctexto  	:= Alltrim(SB1->B1_DESC)
				_nlinhas 	:= mlcount(_ctexto,_nTam)
				for _ncount:= 1 to _nlinhas
					oPrint:Say  (_nLin ,0460, memoline(_ctexto,_nTam,_ncount),oFont8)
					If _nCount <> _nLinhas
						_nLin+=60
					EndIf
				next _ncount
				
				//Impressao da Quantidade e Unidade de Medida
				oPrint:Say  (_nLin,1250, transform(SCK->CK_QTDVEN,"@E 999999.99")	,oFont8)
				_nTam		:= 60
				_ctexto  	:= Alltrim(SB1->B1_UM)
				_nlinhas 	:= mlcount(_ctexto,_nTam)
				for _ncount:= 1 to _nlinhas
					oPrint:Say  (_nLin ,1380, memoline(_ctexto,_nTam,_ncount),oFont8)
					If _nCount <> _nLinhas
						_nLin+=60
					EndIf
				next _ncount
				if _lValor
					//Impressao do Valor Unitario
					oPrint:Say  (_nLin,1500, transform(SCK->CK_PRCVEN	,"@E 999,999.99")	,oFont8)
					
					//Impressao do Percentual de IPI
					oPrint:Say  (_nLin,1650, transform(nAliqIPI 	,"@E 999.99")		,oFont8) //SCK->CK_ZIPI
					
					//Impressao do Percentual de ICMS
					oPrint:Say  (_nLin,1750, transform(nAliqICM,"@E 999.99")		,oFont8) //SCK->CK_ZPICMS
					
					//Impressao do Percentual de IVA
					oPrint:Say  (_nLin,1850, transform(_nXmargSf7	,"@E 999.99")	   		,oFont8)
					
					//Impressao do Valor de ICMS-ST
					oPrint:Say  (_nLin,2000, transform((nValICMSST)	,"@E 99,999,999,999.99")		,oFont8) //SCK->CK_ZVALIST
					
					//Impressao do Valor Total
					oPrint:Say  (_nLin,2200, transform(SCK->CK_VALOR	,"@E 9,999,999.99")	,oFont8)
					
					//Impressao do Prazo de Entraga
					//Print:Say  (_nLin,2400, transform(SCK->CK_DTENTRE	,"@E 999.999,99")	,oFont8)
					
					//Impressao do NCM
					oPrint:Say  (_nLin,2700, transform(SB1->B1_POSIPI  	,"@R 9999.99.99")	,oFont8)
					
					//Impressao da Ordem de Compra por Item
					//oPrint:Say  (_nLin,3000, transform(SCK->CK_XORDEM  	,"@!")	            ,oFont8)
				endif
				_ntotal += SCK->CK_VALOR
				
			Endif
			
			_nLin+=60
			
			if _nLin > 2300
				_nLin+=30
				oPrint:Say  (_nLin,1400, "* * *   C O N T I N U A    * * *",oFont12)
				oPrint:EndPage()     // Finaliza a página
				xCabOrc()
				oPrint:StartPage()     // INICIALIZA a página
			endif
			
			SCK->(DbSkip())
			
		Enddo
		
		Dbselectarea("SCK")
		SCK->(DbSkip())
		
	Enddo
	
	if _nLin > 2300
		_nLin+=30
		oPrint:Say  (_nLin,1400, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		xCabOrc()
		oPrint:StartPage()     // INICIALIZA a página
	endif
	
	oPrint:box  (0100  , 0090 , 2310 , 3400)
	if _lValor
		// Imprime Total Do Orcamento
		_nLin+=200
		oPrint:Line (_nLin, 90,_nLin,3400)
		_nLin+=30
		oPrint:Say  (_nLin,2250, "Valor Total dos Produtos (" + _cDMoed + ")"	,oFont10)
		oPrint:Say  (_nLin,2750, ": " + Transform(_ntotal,"@E 9999,999.99")	,oFont10)
		_nLin+=60
		oPrint:Say  (_nLin,2250, "Valor Total IPI (" + _cDMoed + ")"			,oFont10)
		oPrint:Say  (_nLin,2750, ": " + Transform(_nTotIPI,"@E 9999,999.99")	,oFont10)
		_nLin+=60
		oPrint:Say  (_nLin,2250, "Valor Total ICMS-ST (" + _cDMoed + ")"		,oFont10)
		oPrint:Say  (_nLin,2750, ": " + Transform(_nTotICMSST,"@E 9999,999.99")	,oFont10)
		_nLin+=60
		oPrint:Say  (_nLin,2250, "Valor Total do Orçamento (" + _cDMoed + ")"	,oFont10)
		oPrint:Say  (_nLin,2750, ": " + Transform(_ntotal-_nTotICMSST,"@E 9999,999.99")	,oFont10)
		_nLin+=60
		oPrint:Line (_nLin, 090,_nLin,3400) // Imprime Linha Fina
		
		// Inicia Mensagens Do Orcamento
		_nLin+=30
		//_nLin := 2200 // Linha Inicial Das Mensagens
		
		
		// Imprime Vendedor
		if !empty(PP7->PP7_REPRES)
			_cVend1 := Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_REPRES,"A3_NOME"))
			oPrint:Say  (_nLin,100, "Reprenstante"							,oFont10)
			oPrint:Say  (_nLin,260, ": " + Capital(_cVend1)					,oFont10)
			_nLin+=60
			_cVend2 := Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_REPRES,"A3_TEL"))
			oPrint:Say  (_nLin,100, "Telefone"							,oFont10)
			oPrint:Say  (_nLin,260, ": " + Capital(_cVend2)				,oFont10)
			_nLin+=60
		Endif
		
		if !empty(PP7->PP7_VEND)
			_cVend1 := Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND,"A3_NOME"))
			oPrint:Say  (_nLin,100, "Vendedor"							,oFont10)
			oPrint:Say  (_nLin,260, ": " + Capital(_cVend1)					,oFont10)
			_nLin+=60
			_cVend2 := Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_VEND,"A3_TEL"))
			oPrint:Say  (_nLin,100, "Telefone"							,oFont10)
			oPrint:Say  (_nLin,260, ": " + Capital(_cVend2)				,oFont10)
			_nLin+=60
		Endif
		
		/*/
		_nLin+=60
		_cVend3 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_VEND2,"A3_FAX"))
		oPrint:Say  (_nLin,100, "Fax"						 		,oFont10)
		oPrint:Say  (_nLin,260, ": " + Capital(_cVend3)		 		,oFont10)
		_nLin+=60
		_cVend4 := Alltrim(Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_VEND2,"A3_EMAIL"))
		oPrint:Say  (_nLin,100, "E-mail"							,oFont10)
		oPrint:Say  (_nLin,260, ": " + Capital(_cVend4)				,oFont10)
		/*/
		
	Endif
	
	oPrint:Line (_nLin, 090,_nLin,3400) // Imprime Linha Fina
	
	
	//oPrint:Say  (_nLin,600, Capital(_cVend)											,oFont13)
	
	oPrint:EndPage()     // Finaliza a página
	
Return()




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xCabOrc   ºAutor  ³RGV Solucoes        º Data ³ 13/02/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Steck                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xCabOrc  ()
	
	
	
	oPrint:box  (0100  , 0090 , 2310 , 3400)
	
	
	oPrint:Line (0350 , 0090 , 0350, 3400)
	
	If File(aBmp)
		oPrint:SayBitmap( 0120,0100,aBmp,0480,0200 )
	EndIf
	
	oPrint:Say  (0120,600, _cNomeCom  ,oFont12)
	oPrint:Say  (0180,600, _cEndereco ,oFont12)
	oPrint:Say  (0240,600,"CEP: "+ SUBSTR(cCep,1,5)+"-"+SUBSTR(cCep,6,3) +" - "+Alltrim(cCidade)+" - "+cEstado,oFont12)
	oPrint:Say  (0300,600,"TEL.: "+alltrim(cTelefone)+" FAX.: "+ alltrim(cFax)+ " E-MAIL: vendas@steck.com.br",oFont12)
	
	dbselectarea("SA1")
	MsSeek(Xfilial("SA1")  + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA )
	
	oPrint:Say  (0380,0100,"Empresa: "+ Upper(SA1->A1_NOME)         									,oFont12)
	oPrint:Say  (0440,0100,"Código de Cliente: "+ SCJ->CJ_CLIENTE + " - " + SCJ->CJ_LOJA				,oFont12)
	
	oPrint:Say  (0500,0100,"Dados de Faturamento: " 													,oFont12)
	oPrint:Say  (0560,0100,Upper(Alltrim(SA1->A1_END) + " - " + Alltrim(SA1->A1_BAIRRO) + " - " + Alltrim(SA1->A1_MUN) + " - " + Alltrim(SA1->A1_EST) + " - " + Alltrim(SA1->A1_CEP))         					,oFont12)
	oPrint:Say  (0620,0100,TRANSFORM(SA1->A1_CGC,PESQPICT("SA1","A1_CGC"))			        			,oFont12)
	oPrint:Say  (0680,0100,"I.E.: "+ SA1->A1_INSCR 											   			,oFont12)
	
	oPrint:Line (0740, 090,0740,3400)
	
	oPrint:Say  (0750,0100,"Atendimento"					,oFont12)
	oPrint:Say  (0750,0400,": " + SCJ->CJ_NUM				,oFont12)
	oPrint:Say  (0750,1300,"Emissão" 						,oFont12)
	oPrint:Say  (0750,1700,": " + dtoc(SCJ->CJ_EMISSAO)	,oFont12)
	/*/
	dbselectarea("SU5")
	MsSeek(Xfilial("SU5")  + SCJ->CJ_CODCONT )
	dbselectarea("SQB")
	MsSeek(Xfilial("SQB")  + SU5->U5_DEPTO )
	
	_cDepto:=SQB->QB_DESCRIC
	
	oPrint:Say  (0810,0100, "Contato" 							,oFont12)
	oPrint:Say  (0810,0400, ": " + Capital(SU5->U5_CONTAT)		,oFont12)
	oPrint:Say  (0810,1300, "Departamento"						,oFont12)
	oPrint:Say  (0810,1700, ": " + (_cDepto)					,oFont12)
	/*/
	dbselectarea("SE4")
	MsSeek(Xfilial("SE4")  + scj->cj_Condpag)
	
	oPrint:Say  (0870,0100, "Cond. Pagto" 						,oFont12)
	oPrint:Say  (0870,0400, ": " + SE4->E4_DESCRI				,oFont12)
	//oPrint:Say  (0870,1300, "Ordem de Compra" 					,oFont12)
	//oPrint:Say  (0870,1700, ": " 								,oFont12)//+ SCJ->CJ_XORDEM
	
	//IF SCJ->CJ_TPFRETE = "F"
	_cFrete = "FOB"
	//Else
	_cFrete = "CIF"
	//Endif
	
	oPrint:Say  (0930,0100, "Frete"						,oFont12)
	oPrint:Say  (0930,0400, ": "	+ (_cFrete)			,oFont12)
	//Print:Say  (0930,1300, "Validade"					,oFont12)
	//oPrint:Say  (0930,1700, ": "+dtoc(SCJ->CJ_DTLIM)	,oFont12)
	
	oPrint:Line (0990, 090,0990,3400) // Imprime Linha Fina
	
	oPrint:Say  (1000,0100, "Item"			    		,oFont10)
	oPrint:Say  (1000,0170, "Código"					,oFont10)
	oPrint:Say  (1000,0460, "Descrição"					,oFont10)
	oPrint:Say  (1000,1250, "Qtde." 					,oFont10)
	oPrint:Say  (1000,1380, "UM"						,oFont10)
	oPrint:Say  (1000,1500, "Vlr Unit"  				,oFont10)
	oPrint:Say  (1000,1650, "IPI"				    	,oFont10)
	oPrint:Say  (1000,1750, "ICMS"				    	,oFont10)
	oPrint:Say  (1000,1850, "IVA"				    	,oFont10)
	oPrint:Say  (1000,2000, "ICMS-ST"				    ,oFont10)
	oPrint:Say  (1000,2200, "Valor Total"				,oFont10)
	oPrint:Say  (1000,2400, "Prazo Entrega"		 		,oFont10)
	oPrint:Say  (1000,2700, "Clas. Fiscal"				,oFont10)
	//oPrint:Say  (1000,3000, "Ordem/Produto"				,oFont10)
	
	
	
	oPrint:Line (1060, 090,1060,3400) // Imprime Linha Fina
	
	_nLin := 1070
	
Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()      ³ Autor ³ Norbert Waage Junior  ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolução horizontal do Monitor do USCJrio.                  ³±±
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


/*

cTexto := CONDIÇÕES GERAIS DE VENDA PARA PRODUTOS E SERVIÇOS
PCOM.003.01 - Revisão: 0
17 de Outubro de 2012.


1.	INTRODUÇÃO:

1.1 As Condições Gerais de Venda, doravante denominadas CGV, constituem condições comerciais, técnicas e jurídicas básicas para o FORNECIMENTO de produtos e/ou serviços pela STECK INDÚSTRIA ELÉTRICA LTDA., doravante denominada STECK, e serão aplicadas sempre que referidas como anexo nas propostas, acordos ou quaisquer contratos para FORNECIMENTO de produtos e serviços da STECK. As presentes CGV são aplicáveis sem prejuízo da aplicação de condições específicas que venham a ser mutuamente ajustadas entre as PARTES.

1.2 Quaisquer disposições em contrário às presentes CGV, que não tenham sido objeto de acordo, por escrito com a STECK, não criarão nenhuma obrigação para a STECK, que se obriga exclusivamente pelas cláusulas destas CGV, de SCJ proposta e do instrumento contratual assinado entre a STECK e o CLIENTE. Na ausência de condições específicas mutuamente acordadas entre as PARTES, as disposições das presentes CGV serão as únicas aplicáveis ao FORNECIMENTO.

1.3 Para efeito das presentes CGV, considerar-se-ão:

Produtos - Todas as peças, equipamentos, materiais, partes, componentes, sistemas ou quaisquer outras referências de PRODUTOS entregues pela STECK, seus SCKfornecedores e/ou SCKcontratados, ao CLIENTE. Sendo eles : Caixas de Passagem e Distribuição, Comando e Proteção (disjuntores, relés, contatores, etc), Plugues e Tomadas - Uso Industrial/Comercial/Residencial, Produtos para displays, Quadros de Distribuição, Unidades Combinadas e Bloqueios Mecânicos

Serviços - Toda prestação contratada pelo CLIENTE que envolva pré-montagem, montagem, instalação, acompanhamento, supervisão, testes, comissionamento, manutenção, construção ou quaisquer outras referências de SERVIÇOS prestados pela STECK, seus SCKfornecedores e/ou SCKcontratados ao CLIENTE;
	
Fornecimento - Todos os PRODUTOS e/ou SERVIÇOS, conforme o caso, contratados pelo CLIENTE, e que serão objeto de entrega ou prestação pela STECK, seus SCKcontratados e/ou SCK-fornecedores.

2.	CARACTERÍSTICAS DOS PRODUTOS, SERVIÇOS E CONDIÇÕES DE FORNECIMENTO:

2.1 As quantidades e características dos produtos e serviços objeto do FORNECIMENTO determinar-se-ão pela proposta. Nenhuma responsabilidade ou obrigação terá a STECK no que concerne a produtos e serviços que não tenham sido orçados ou que não constem da confirmação do pedido.

2.2 Todas as informações e dados constantes de documentos anexos à proposta tais como catálogos, fotografias, desenhos, referências técnicas, pesos, medidas e listas de preços, são apenas exemplificativos e somente poderão ser considerados como vinculantes das características do FORNECIMENTO contratado nas SCJs partes e características que forem expressamente referidas na proposta.

2.3 Os materiais e seus respectivos fabricantes constantes na proposta são dados apenas como referência para projeto e fabricação. Em casos de dificuldades de aquisição, particularmente por razões de disponibilidade, a STECK reserva-se no direito de SCKstituí-los por outros tecnicamente equivalentes.
3.	VALIDADE DA PROPOSTA:

3.1 O prazo de validade das condições técnicas e comerciais será o previsto na proposta ou, caso a proposta não tenha estabelecido prazo, ficará este fixado em 07 (sete) dias corridos contados da apresentação. Após este prazo, as condições deverão ser renegociadas e uma nova proposta deverá ser apresentada.

3.2 A validade de qualquer proposta apresentada pela STECK, sob qualquer forma, ficará condicionada à aprovação ou confirmação do cadastro e respectivo limite de crédito do CLIENTE podendo eventualmente ser solicitadas garantias de pagamento, sem ônus para a STECK.

4.	PREÇO, REAJUSTE E CONDIÇÕES DE PAGAMENTO:

Os preços dos produtos e serviços da STECK são resultantes das estimativas de custos, condições de proposta, condições de política econômica do país e legislação tributária vigente na SCJ data-base.

Os preços estarão sujeitos a reajuste, sempre na menor periodicidade permitida pela legislação contada a partir da data da proposta, pela variação do IGPM-FGV, ou outro índice equivalente que venha a SCKstituí-lo.

O pagamento dos produtos ou serviços será efetuado de acordo com as condições estabelecidas em cada Pedido de Compra aceito pela STECK, através de rede bancária autorizada.

Considera-se como início de contagem do prazo de pagamento a data de emissão da nota fiscal de faturamento.

No caso de atrasos de pagamentos, sem prejuízo do direito da STECK de suspender a execução do FORNECIMENTO, o CLIENTE ficará sujeito a aplicação de multa de 2% (dois por cento) ao mês, correção monetária pelo IGP-M-FGV e juros de mora de 1% (um por cento) ao mês pro rata die, todos calculados sobre o valor em atraso. Tais encargos serão devidos a partir do primeiro dia de atraso e até o efetivo pagamento, independentemente de qualquer notificação judicial ou extrajudicial.

5.	PRAZOS DE ENTREGA:

Os pedidos serão entregues de acordo com as condições acordadas e com a disponibilidade do estoque da STECK.

O CLIENTE terá um prazo máximo de 05 (cinco) dias após ter recebido o produto para comunicar a STECK qualquer divergência em relação ao Pedido. A STECK, por SCJ vez, compromete-se a corrigir as não conformidades dentro do menor prazo possível.

Eventuais devoluções, contatar o vendedor responsável porem somente serão aceites após a aprovação da diretoria comercial. Não serão aceitas devoluções de produtos fabricados especialmente para atender às necessidades do CLIENTE e/ou produtos com embalagem danificada.

6.	INSPEÇÕES:

No caso do CLIENTE desejar que o material seja SCKmetido à inspeção, deverá fazer solicitação durante a negociação do pedido, indicando nesta oportunidade os tipos de provas desejadas. A STECK informará sobre a disponibilidade da inspeção e os custos envolvidos a serem cobrados para cada prova requerida.

7.	PATENTES E DIREITOS DE PROPRIEDADE INDUSTRIAL

O direito de propriedade sobre estudos, projetos, relatórios, manuais, desenhos e demais elementos técnicos eventualmente entregues pela STECK ao CLIENTE, inclusive aqueles que venham a ser desenvolvidos em razão do FORNECIMENTO, permanecerão com a STECK. Tais documentos pertencentes à STECK devem ser considerados como confidenciais, motivo pelo qual o CLIENTE deverá manter sigilo quanto a eles, não os transmitindo ou entregando-os a terceiros, salvo com prévia e expressa autorização por escrito da STECK. Da mesma forma, a STECK obriga-se a manter sigilo quanto a desenhos e informações técnicas que sejam recebidos do CLIENTE e declarados por este como confidenciais.

O CLIENTE terá uma licença limitada, não exclusiva para utilização de desenhos e demais elementos técnicos da STECK relativos ao FORNECIMENTO somente para os fins específicos de operação e manutenção do FORNECIMENTO. Em caso de rescisão do FORNECIMENTO por inadimplemento do CLIENTE fica revogada a licença estabelecida nesta cláusula.

8.	SOLICITAÇÃO DOS PEDIDOS:

Os meios para solicitação dos Pedidos de Compra são:

e-mail: do vendedor responsável pelo cliente

Telefone: 11 2248-7000 ou 0800.12.20.22 fora da Grande São Paulo

Fax: 11 2248-7051 11-22487069

Correio: Av. Luis Stamatis, 716, Cep: 02260-001, Jaçana - São Paulo - SP

9.	ACEITAÇÃO:

A STECK analisará os Pedidos de Compra solicitados, e em caso de divergências envolvendo referencia do produto, preço, prazo de entrega, condições de pagamento ou de entrega, informará a empresa compradora para os devidos acertos.

Devido aos custos com a análise dos pedidos, separação e entrega de produtos, cada solicitação de compra deverá respeitar um valor mínimo descrito no orçamento e que é de R$ 800,00 (Oitocentos reais). Para valores inferiores, a STECK sugere que o CLIENTE adquira os produtos diretamente na rede de Distribuidores Autorizados, que estão localizados em todo o território Nacional.

Caso o CLIENTE discorde destas alterações, esta deverá informar à STECK em até 24 (vinte e quatro) horas, contadas a partir do recebimento da Confirmação, para que seja possível suspender o faturamento até que as divergências sejam negociadas.

10.	ALTERAÇÕES/CANCELAMENTOS:

Eventuais cancelamentos ou alterações de Pedidos deverão ser solicitadas diretamente através do e-mail do vendedor responsável pelo cliente ou do fax 11 22487051

O prazo máximo para solicitações de cancelamentos é de dois dias contados da data de confirmação do pedido.

11.	PRAZOS PARA FATURAMENTO:

Eventualmente alguns pedidos registrados na STECK, podem sofrer alterações nos prazos de faturamento, porém, o cliente será informado antecipadamente via e-mail ou telefone sobre a nova data.

12.	GARANTIA:

O prazo de garantia contra defeitos de fabricação, devidamente comprovado, é de 12 (doze) meses a contar da data da Nota Fiscal de faturamento.

A garantia se aplica para produtos entregues em nossa fábrica e não abrangerá estragos e avarias decorrentes de acidentes, instalações inadequadas ou ocorrências causadas por terceiros. Exclui-se também da garantia o desgaste devido ao uso intensivo dos materiais e que ultrapassem a vida elétrica ou mecânica especificada em catálogo, danos causados por negligência, imperícia ou imprudência na manutenção, uso impróprio ou inadequado, armazenagem inadequada e motivos de força maior ou caso fortuito.

No caso de eventuais defeitos de fabricação ocorridos durante o período de garantia, o CLIENTE deverá informar à STECK sobre o tipo de defeito ocorrido através do e-mail contato@STECK.com.br ou do fax 11 22487051. A STECK se compromete a analisar o ocorrido e consertar ou a SCKstituir o produto dentro do mais curto espaço de tempo possível. Confirmado que o defeito se encontra dentro das condições de garantia acima especificadas, eventuais custos de mão de obra e materiais para reparação ou SCKstituição serão assumidos pela STECK.

As regras acima definidas se aplicam somente para produtos vendidos diretamente pela STECK ou por seus parceiros no mercado brasileiro.


13.	LIMITAÇÃO DE RESPONSABILIDADE POR PERDAS E DANOS

A responsabilidade da STECK por indenizar eventuais perdas e danos que causar relacionadas ao FORNECIMENTO seja por inadimplementos, negligência, imprudência, imperícia, indenizações, quebra de garantias, ou qualquer outra causa, quer se constituam por fato ou ato isolado ou pela totalidade dos mesmos, fica limitada aos danos diretos causados ao CLIENTE durante o prazo de execução do FORNECIMENTO e até o término do prazo de garantia e ao valor total agregado de 50% (cinquenta por cento) do valor do FORNECIMENTO.

Fica entendido ainda, que a STECK não será responsável, em hipótese alguma por indenizar eventuais lucros cessantes, perdas de receita ou de produção, perdas de contratos, custos de ociosidade, custos adicionais de energia, penalidades do poder concedente, danos a imagem ou quaisquer hipóteses de danos indiretos e/ou conseqüentes. A limitação de responsabilidade prevista nesta cláusula prevalece e aplica-se para fins de delimitar qualquer disposição contratual que diga respeito a indenizações ou compensações devidas pela STECK.

14.	OBSERVAÇÕES GERAIS:

Caso o CLIENTE necessite de uma contratação com características particulares, diferentes das condições aqui estabelecidas, esta se realizará através de um contrato de fornecimento específico, negociado e acordado entre as partes.

O CLIENTE ao entregar o Pedido de Compra à STECK concorda e aceita integralmente as condições aqui estabelecidas, que prevalecerá sobre qualquer outra condição da compradora.

Caso a compradora esteja localizada em áreas com benefícios fiscais como por exemplo a Zona Franca de Manaus e adquira produtos na STECK com benefícios da não tributação do ICMS e/ou IPI, a mesma deverá proceder de acordo com as informações solicitadas pela SUFRAMA, para internamento da mercadoria, que deverá ocorrer em até 60 dias da data da emissão da Nota Fiscal. O não cumprimento das orientações solicitadas pela SUFRAMA, dentro do prazo acima, implica em penalidades conforme descrito por lei e caso a STECK seja obrigada a recolher os impostos, a mesma repassará estes valores acrescidos de todos os encargos legais para a compradora.

E-Mail: contato@steck.com.br
Comercial / Administração:
Av. Luis Stamatis, Nº. 716
Jaçanã - Cep: 02260-001/SP
*/


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³STMAFISREL³ Autor ³ RGV Solucoes          ³ Data ³13/03/13  ³±±
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
	MaFisIni(SCJ->CJ_CLIENTE,;	// 1-Codigo Cliente/Fornecedor
	SCJ->CJ_LOJA ,;			// 2-Loja do Cliente/Fornecedor
	"C",;					// 3-C:Cliente , F:Fornecedor
	"N",;					// 4-Tipo da NF
	SA1->A1_TIPO,;			// 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461")                                                               // 10-Nome da rotina que esta utilizando a funcao
	
	MaFisAdd(SCK->CK_PRODUTO,;                                               // 1-Codigo do Produto ( Obrigatorio )
	SCK->CK_TES,;                                                            // 2-Codigo do TES ( Opcional )
	SCK->CK_QTDVEN,;                                                          // 3-Quantidade ( Obrigatorio )
	SCK->CK_PRCVEN,;                                                         // 4-Preco Unitario ( Obrigatorio )
	0,;                														 // 5-Valor do Desconto ( Opcional )
	,;                                                                       // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                       // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                       // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                      // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                      // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                      // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                      // 12-Valor do Frete Autonomo ( Opcional )
	SCK->CK_PRCVEN,;														 // 13-Valor da Mercadoria ( Obrigatorio )
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



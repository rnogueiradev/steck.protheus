#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ STFTR001 ³ Autor ³ RGV Solucoes          ³ Data ³07/Fev/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DOS ORCAMENTOS GRAFICOS                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STFTR001()
	
	Private cEmailFor	:= ""
	
	DbSelectArea("SCJ")
	
	Processa({|lEnd|MontaRel()})
	
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MontaRel ³ Autor ³ Relxardo Alberti       ³ Data ³07/Fev/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO RELATORIO                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel()
	
	LOCAL   n := 0
	PRIVATE oPrint
	
	Dbselectarea("SCJ")
	MsSeek(Xfilial("SCJ") + PP8->PP8_NUMORC  )
	
	if eof()
		
		msgstop("Orcamento Nao Encontrado !!!  Verifique !!! " )
		
	else
		
		oPrint:= TMSPrinter():New( "Orcamento" )
		oPrint:SetPortrait() // ou SetLandscape()
		
		dbselectarea("SA1")
		MsSeek(Xfilial("SA1")  + scj->cj_cliente + scj->cj_loja )
		
		dbselectarea("SE4")
		MsSeek(Xfilial("SE4")  + scj->cj_Condpag )
		
		Dbselectarea("SCJ")
		
		//	impress()
		u_fr001Imp()
		oPrint:Preview()     // Visualiza antes de imprimir
		/*/
		If MsgBox("Envia e-mail ao cliente?","Envio de E-Mail","YESNO")
			
			cEmailFor 	:= Alltrim(Lower(SA1->A1_EMAIL))
			titulo		:= "Envio de E-Mail"
			
			U__lChkMail() // Abre tela Para Digitar Manualmente E-Mails
			
			//PmsGrafMail(oPrint,"Pedido de Compras: "+MV_PAR01,{"Pedido de Compras: "+MV_PAR01},{}) //aSaldosM)
			Processa({|lEnd| BrEnvMail(oPrint,"Cotacao: "+MV_PAR01,{"Cotacao: "+MV_PAR01},cEmailFor,"",{},10)},titulo)
			
		Endif
		/*/
	EndIf
	
	//oPrint:Print()
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ RGV Solucoes          ³ Data ³07/Fev/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function fr001Imp()
	
	LOCAL 	_nTxper := GETMV("MV_TXPER")
	LOCAL 	i 		:= 0
	LOCAL 	_ncount 		:= 0
	Local	_cDMoed	:= "R$"//Alltrim(SuperGetMv("MV_SIMB" + Alltrim(Str(SCJ->CJ_MOEDA,1))))
	LOCAL 	oBrush
	Private _lItem   := MsgYesno("Exibi Itens Ocultos?")
	Private _nLin := 4000
	nAliqICM 	:=0
	nValICms	:=0
	
	nAliqIPI 	:=0
	nValIPI 	:=0
	
	nValICMSST 	:=0
	
	nValPis		:=0
	nValCof		:=0
	
	
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
	_ntotipi := 0
	_ntoticmsst := 0
	_npagina := 0
	_aItRed	:= {}
	
	Dbselectarea("PP7")
	Dbsetorder(1)
	dbseek(xfilial("PP7")+PP8->PP8_CODIGO)
	
	//Do While !eof()  .and. PP7->PP7_CODIGO == PP8->PP8_CODIGO
	
	Dbselectarea("SCJ")
	MsSeek(Xfilial("SCJ") + PP8->PP8_NUMORC  )
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	MsSeek(xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA)
	
	dbselectarea("SCK")
	dbsetorder(1)
	MsSeek(xfilial("SCK")+SCJ->CJ_NUM)
	
	if !eof()
		if _nLin > 3000
			if _npagina <> 0
				_npagina++
			EndPage()
		Endif
		oPrint:StartPage()     // INICIALIZA a página
		CabOrc()
	endif
endif

oPrint:Line (_nLin, 090,_nLin,2300)
oPrint:Say  (_nLin+=10,0100, PP8->PP8_item 									,oFont14n)
oPrint:Say  (_nLin,0170, PP8->PP8_DESCR											,oFont14n)
oPrint:Say  (_nLin,1350, transform(PP8->PP8_QUANT	,"@E 9999,999")				,oFont14n) //Era 1300
oPrint:Say  (_nLin,1480, "PC"													,oFont14n)
if _lPreco
	
	STMAFISUNI(iif(PP8->PP8_PRCOM>0,PP8->PP8_PRCOM,PP8->PP8_PRORC))
	_nValor_net := iif(PP8->PP8_PRCOM>0,PP8->PP8_PRCOM,PP8->PP8_PRORC) - nValIPI  - nValICMSST
	oPrint:Say  (_nLin,1700, transform(_nValor_net,"@E 9999,999.99")						,oFont14n)
	oPrint:Say  (_nLin,2100, transform(PP8->PP8_QUANT	* _nValor_net,"@E 9999,999.99")	,oFont14n)
	oPrint:Line (_nLin+=60, 090,_nLin,2300)
	
	_ntotal+=(PP8->PP8_QUANT	* iif(PP8->PP8_PRCOM>0,PP8->PP8_PRCOM,PP8->PP8_PRORC) )
	
endif
Do while !eof() .and. sck->ck_num == SCJ->CJ_NUM
	
	if _nLin > 3000
		oPrint:Say  (3130,800, "* * *   C O N T I N U A    * * *",oFont16n)
		oPrint:EndPage()     // Finaliza a página
		CabOrc()
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
	IF  _lItem
		
		
		oPrint:Say  (_nLin,0170, scK->cK_produto	,oFont10) // Era 230
		
		_nTam		:= 60
		_ctexto  	:= Alltrim(sb1->b1_desc)
		_nlinhas 	:= mlcount(_ctexto,_nTam)
		
		for _ncount:= 1 to _nlinhas
			
			oPrint:Say  (_nLin ,0480, memoline(_ctexto,_nTam,_ncount),oFont10)
			
			If _nCount <> _nLinhas
				_nLin+=60
				
				if _nLin > 3000
					oPrint:Say  (3130,800, "* * *   C O N T I N U A    * * *",oFont16n)
					oPrint:EndPage()     // Finaliza a página
					CabOrc()
					oPrint:StartPage()     // INICIALIZA a página
				endif
			EndIf
		next _ncount
		
		// Determina Prazo De Entrega
		_nEntreg := ""
		
		oPrint:Say  (_nLin,1350, transform(sck->ck_qtdven	,"@E 9999,999")		,oFont10) //Era 1300
		oPrint:Say  (_nLin,1480, sb1->b1_um										,oFont10)
		_nLin+=60
		
		
	ELSEIF SCK->CK_XIMPORC <> 'N'
		
		
		oPrint:Say  (_nLin,0170, scK->cK_produto	,oFont10) // Era 230
		
		_nTam		:= 60
		_ctexto  	:= Alltrim(sb1->b1_desc)
		_nlinhas 	:= mlcount(_ctexto,_nTam)
		
		for _ncount:= 1 to _nlinhas
			
			oPrint:Say  (_nLin ,0480, memoline(_ctexto,_nTam,_ncount),oFont10)
			
			If _nCount <> _nLinhas
				_nLin+=60
				
				if _nLin > 3000
					oPrint:Say  (3130,800, "* * *   C O N T I N U A    * * *",oFont16n)
					oPrint:EndPage()     // Finaliza a página
					CabOrc()
					oPrint:StartPage()     // INICIALIZA a página
				endif
			EndIf
		next _ncount
		
		// Determina Prazo De Entrega
		_nEntreg := ""
		
		oPrint:Say  (_nLin,1350, transform(sck->ck_qtdven	,"@E 9999,999")		,oFont10) //Era 1300
		oPrint:Say  (_nLin,1480, sb1->b1_um										,oFont10)
		_nLin+=60
		
	Endif
	
	if _nLin > 3000
		oPrint:Say  (3130,800, "* * *   C O N T I N U A    * * *",oFont16n)
		oPrint:EndPage()     // Finaliza a página
		CabOrc()
		oPrint:StartPage()     // INICIALIZA a página
	endif
	
	dbselectarea("SCK")
	SCK->(DbSkip())
	
Enddo
/*/
oPrint:EndPage()     // Finaliza a página
CabOrc()
oPrint:StartPage()     // INICIALIZA a página
dbselectarea("PP8")
PP8->(DbSkip())

Enddo
/*/

if _nLin > 2579
	oPrint:Say  (3130,800, "* * *   C O N T I N U A    * * *",oFont16n)
	oPrint:EndPage()     // Finaliza a página
	CabOrc()
	oPrint:StartPage()     // Finaliza a página
endif
oPrint:box  (0100  , 0090 , 2310 , 2300)

if _lPreco
	
	// Imprime Total Do Orcamento
	oPrint:Line (2800, 90,2800,2300)
	oPrint:Say  (2810,1650, "Total (" + _cDMoed + ")"						,oFont13n)
	oPrint:Say  (2810,2100, transform(_nValor_net,"@E 9999,999.99")				,oFont13n)
	oPrint:Line (2880, 90,2880,2300)
	
	//oPrint:box  (0100  , 0090 , 2310 , 2300)
	
	// Imprime Total Do Orcamento
	_nLin+=200
	oPrint:Line (_nLin, 90,_nLin,2300)
	_nLin+=30
	oPrint:Say  (_nLin,1250, "Valor Total dos Produtos (" + _cDMoed + ")"	,oFont10)
	oPrint:Say  (_nLin,1750, ": " + Transform(_nValor_net,"@E 9999,999.99")	,oFont10)
	_nLin+=60
	oPrint:Say  (_nLin,1250, "Valor Total IPI (" + _cDMoed + ")"			,oFont10)
	oPrint:Say  (_nLin,1750, ": " + Transform(nValIPI ,"@E 9999,999.99")	,oFont10)
	_nLin+=60
	oPrint:Say  (_nLin,1250, "Valor Total ICMS-ST (" + _cDMoed + ")"		,oFont10)
	oPrint:Say  (_nLin,1750, ": " + Transform(_nTotICMSST,"@E 9999,999.99")	,oFont10)
	_nLin+=60
	oPrint:Say  (_nLin,1250, "Valor Total do Orçamento (" + _cDMoed + ")"	,oFont10)
	oPrint:Say  (_nLin,1750, ": " + Transform(iif(PP8->PP8_PRCOM>0,PP8->PP8_PRCOM,PP8->PP8_PRORC),"@E 9999,999.99")	,oFont10)
endif
_nLin+=60
oPrint:Line (_nLin, 090,_nLin,2300) // Imprime Linha Fina

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
_nLin+=60
oPrint:Say  (_nLin,100, "Observação:"							,oFont10)
oPrint:Say  (_nLin,280, SCJ->CJ_OBSORC					,oFont10)
_nLin+=60
_nLin+=60
oPrint:Say  (_nLin,100, "Obs. Comercial:"							,oFont10)
oPrint:Say  (_nLin,300, PP7->PP7_NOTAS					,oFont10)
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


//oPrint:Line (_nLin, 090,_nLin,2300) // Imprime Linha Fina



// Inicia Mensagens Do Orcamento

_nLin := 2900 // Linha Inicial Das Mensagens

// Imprime Vendedor
_cVend := Alltrim(Posicione("SA3",1,xFilial("SA3")+PP7->PP7_REPRES,"A3_NOME"))
oPrint:Say  (_nLin,100, "Vendedor: "											,oFont13n)
oPrint:Say  (_nLin,600, Capital(_cVend)											,oFont13 )

_nLin+=60
oPrint:EndPage()     // Finaliza a página

Return()




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CabOrc    ºAutor  ³ RGV Solucoes       º Data ³ 07/Fev/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CabOrc
	PRIVATE cNomeCom     := SM0->M0_NOMECOM
	PRIVATE cEndereco    := SM0->M0_ENDENT
	PRIVATE cCep         := SM0->M0_CEPENT
	PRIVATE cCidade      := SM0->M0_CIDENT
	PRIVATE cEstado      := SM0->M0_ESTENT
	PRIVATE cCNPJ        := SM0->M0_CGC
	PRIVATE cTelefone    := SM0->M0_TEL
	PRIVATE cFax         := SM0->M0_FAX
	PRIVATE cResponsavel := Alltrim(MV_PAR04)
	PRIVATE cIe          := Alltrim(SM0->M0_INSC)
	
	oPrint:box (0100  ,  0090 , 3150 ,2300 )
	
	oPrint:Line (0350, 090,0350,2300)
	
	If File(aBmp)
		oPrint:SayBitmap( 00120,0100,aBmp,0480,0140 )
	EndIf
	
	oPrint:Say  (0120,600,cNomeCom,oFont20 )
	oPrint:Say  (0200,600,cEndereco,oFont13 )
	oPrint:Say  (0250,600,"CEP: "+ SUBSTR(cCep,1,5)+"-"+SUBSTR(cCep,6,3) +" - "+alltrim(cCidade)+" - "+cEstado,oFont13 )
	oPrint:Say  (0300,600,"Tel.:"+alltrim(cTelefone)+" Fax. "+ alltrim(cFax)+ " e-mail:",oFont13 )
	
	dbselectarea("SA1")
	MsSeek(Xfilial("SA1")  + scj->cj_cliente + scj->cj_loja )
	
	oPrint:Say  (0380,0100,"Empresa: "+ Capital(SA1->A1_NOME)											,oFont13n )
	oPrint:Say  (0440,0100,"Cod.Cliente: "+ scj->cj_cliente + "-" + scj->cj_loja						,oFont13n )
	
	oPrint:Say  (0500,0100,"Dados de Faturametno " 														,oFont13n )
	oPrint:Say  (0560,0100,Capital(SA1->A1_END) + " " + Capital(SA1->A1_BAIRRO)						,oFont13n )
	oPrint:Say  (0620,0100,TRANSFORM(SA1->A1_CGC,PESQPICT("SA1","A1_CGC"))								,oFont13n )
	oPrint:Say  (0680,0100,SA1->A1_INSCR 																,oFont13n )
	
	oPrint:Line (0740, 090,0740,2300)
	
	oPrint:Say  (0750,0100,"Ref. Orçamento: UC-"+pp7->pp7_codigo												,oFont13n )
	oPrint:Say  (0750,1000,"Emissão: "		  																,oFont13n )
	oPrint:Say  (0750,1200,dtoc(pp7->pp7_emissa)															,oFont13n )
	
	
	oPrint:Say  (0810,0100, "Contato: " + Capital(SA1->A1_CONTATO)											,oFont13n )
	oPrint:Say  (0810,1000, "Departamento:" 																,oFont13n )
	
	dbselectarea("SE4")
	MsSeek(Xfilial("SE4")  + scj->cj_Condpag )
	
	oPrint:Say  (0870,0100, "Cond. Pagto" + SE4->E4_DESCRI													,oFont13n )
	
	oPrint:Say  (0930,0100, "Frete: "																		,oFont13n )
	
	oPrint:Say  (0930,1000, "Validade:"																		,oFont13n )
	oPrint:Say  (0930,1200, dtoc(ddatabase+10)																,oFont13n )
	
	oPrint:Line (0990, 090,0990,2300) // Imprime Linha Fina
	
	oPrint:Say  (1000,0100, "It."			     															,oFont10n )
	oPrint:Say  (1000,0170, "Codigo"			    														,oFont10n )
	oPrint:Say  (1000,0460, "Descrição"				    													,oFont10n )
	oPrint:Say  (1000,1350, "Quant."					    												,oFont10n )
	oPrint:Say  (1000,1480, "UM"							    											,oFont10n )
	oPrint:Say  (1000,1700, "Valor Unitario"					    											,oFont10n )
	oPrint:Say  (1000,2100, "Valor Total"					    											,oFont10n )
	
	oPrint:Line (1060, 090,1060,2300)
	
	_nLin := 1070
	
Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³BrEnvMail ³ Autor ³ RGV Solucoes          ³ Data ³07/Fev/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio Do Orcamento/Cotacao por e-mail automaticamente      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function BrEnvMail(oGraphic,cAssunto,aTexto,cTo,cCC,aTabela,nEspacos)
	
	Local cStartPath := GetSrvProfString("Startpath","")
	
	
	cBmpName := CriaTrab(,.F.)
	
	
	oGraphic:SaveAllAsJpeg(cStartPath+cBmpName,1260,1680,200)
	
	StEmail("Envio de Protposta",Alltrim(cTo),"Proposta",(cStartPath+cBmpName+"_pag1.jpg"))
	
	If File(cStartPath+cBmpName+"_pag1.jpg")
		Ferase(cStartPath+cBmpName+"_pag1.jpg")
	EndIf
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³_lChkMail ³ Autor ³ RGV Solucoes          ³ Data ³07/Fev/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³ ealberti@microsiga.com.br      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Caixa De Texto Para Digitação De E-Mail Opcional.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function _lChkMail()
	
	//Variaveis Locais da Funcao
	Local oEdit1
	Local _lRet		:= .f.
	cEMailFor := cEMailFor + Space(200)
	
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
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
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




*------------------------------------------------------------------*
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³StEmail   ºAutor  ³Microsiga           º Data ³  26/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia Email de SD                                          º±±
±±º          ³ baseado na funcao e-mail Criado por Giovanni Zago          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function  StEmail(_cTitulo,_cEmail,_cTipo,cAnexo)
	*------------------------------------------------------------------*
	
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= _cTitulo
	Local cFuncSent:= "StLibFinMail"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	
	DEFAULT _cEmail  := "gallo@rvgsolucoes.com.br"
	
	Aadd( _aMsg , { "SD Num: "          , PP8->PP8_CODIGO+ '-'+ PP8->PP8_ITEM } )
	Aadd( _aMsg , { "Ocorrencia: "    	, _cTipo  } )
	Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
	Aadd( _aMsg , { "Hora: "    		, time() } )
	
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
	cMsg += '</body>'
	cMsg += '</html>'
	
	
	U_STMAILTES(_cEmail, cAnexo, _cAssunto, cMsg , "")
	
	RestArea(aArea)
Return()




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTR001  ºAutor  ³Microsiga           º Data ³  05/20/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC Function STMAFISUNI(_nValor)
	
	DbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(dbseek(xfilial("SA1")+PP7->PP7_CLIENTE+PP7->PP7_LOJA))
	C5_TIPOCLI := SA1->A1_TIPO
	_cTipoCli:= SA1->A1_TIPO
	_cTipoCF := 'C'
	
	_cProduto := SuperGetMv("ST_PRDUNIC",,"SUNICOM")
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	DbSeek(xFilial("SB1")+_cProduto)
	
	_nIcms    	:= SA1->A1_CONTRIB
	_cEst		:= SA1->A1_EST
	
	_cTes:=	 U_STRETSST('01',SA1->A1_COD,SA1->A1_LOJA ,_cProduto,PP7->PP7_CPAG  ,'TES')//u_LcStOper()
	
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
	
	MaFisAdd(_cProduto,;                                               // 1-Codigo do Produto ( Obrigatorio )
	_cTes,;                                                            // 2-Codigo do TES ( Opcional )
	1,;                                                          // 3-Quantidade ( Obrigatorio )
	_nValor,;                                                         // 4-Preco Unitario ( Obrigatorio )
	0,;                														 // 5-Valor do Desconto ( Opcional )
	,;                                                                       // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                       // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                       // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                      // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                      // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                      // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                      // 12-Valor do Frete Autonomo ( Opcional )
	_nValor,;														 // 13-Valor da Mercadoria ( Obrigatorio )
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
	
Return( )






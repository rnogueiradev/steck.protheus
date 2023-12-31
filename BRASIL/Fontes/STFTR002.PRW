#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#Include "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � STFTR002 � Autor � RGV Solucoes          � Data �07/Fev/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DOS ORCAMENTOS GRAFICOS INTERNO                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MontaRel � Autor � RGV Solucoes          � Data �13/02/13  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao DO RELATORIO                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � xImpress � Autor �RGV Solucoes           � Data �13/03/13  ���
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
	Local	_cDMoed	:= "R$"//Alltrim(SuperGetMv("MV_SIMB" + Alltrim(Str(SCJ->CJ_MOEDA,1))))
	LOCAL 	oBrush
	Local _nTotIPI  := 0
	Local _nTotICMSST:= 0
	Local _ncount:= 0
	
	
	
	
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
				oPrint:StartPage()     // INICIALIZA a p�gina
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
				oPrint:EndPage()     // Finaliza a p�gina
				xCabOrc()
				oPrint:StartPage()     // INICIALIZA a p�gina
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
				oPrint:EndPage()     // Finaliza a p�gina
				xCabOrc()
				oPrint:StartPage()     // INICIALIZA a p�gina
			endif
			
			SCK->(DbSkip())
			
		Enddo
		
		Dbselectarea("SCK")
		SCK->(DbSkip())
		
	Enddo
	
	if _nLin > 2300
		_nLin+=30
		oPrint:Say  (_nLin,1400, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a p�gina
		xCabOrc()
		oPrint:StartPage()     // INICIALIZA a p�gina
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
		oPrint:Say  (_nLin,2250, "Valor Total do Or�amento (" + _cDMoed + ")"	,oFont10)
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
	
	oPrint:EndPage()     // Finaliza a p�gina
	
Return()




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xCabOrc   �Autor  �RGV Solucoes        � Data � 13/02/13    ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Steck                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	oPrint:Say  (0440,0100,"C�digo de Cliente: "+ SCJ->CJ_CLIENTE + " - " + SCJ->CJ_LOJA				,oFont12)
	
	oPrint:Say  (0500,0100,"Dados de Faturamento: " 													,oFont12)
	oPrint:Say  (0560,0100,Upper(Alltrim(SA1->A1_END) + " - " + Alltrim(SA1->A1_BAIRRO) + " - " + Alltrim(SA1->A1_MUN) + " - " + Alltrim(SA1->A1_EST) + " - " + Alltrim(SA1->A1_CEP))         					,oFont12)
	oPrint:Say  (0620,0100,TRANSFORM(SA1->A1_CGC,PESQPICT("SA1","A1_CGC"))			        			,oFont12)
	oPrint:Say  (0680,0100,"I.E.: "+ SA1->A1_INSCR 											   			,oFont12)
	
	oPrint:Line (0740, 090,0740,3400)
	
	oPrint:Say  (0750,0100,"Atendimento"					,oFont12)
	oPrint:Say  (0750,0400,": " + SCJ->CJ_NUM				,oFont12)
	oPrint:Say  (0750,1300,"Emiss�o" 						,oFont12)
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
	oPrint:Say  (1000,0170, "C�digo"					,oFont10)
	oPrint:Say  (1000,0460, "Descri��o"					,oFont10)
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


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()      � Autor � Norbert Waage Junior  � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolu��o horizontal do Monitor do USCJrio.                  ���
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


/*

cTexto := CONDI��ES GERAIS DE VENDA PARA PRODUTOS E SERVI�OS
PCOM.003.01 - Revis�o: 0
17 de Outubro de 2012.


1.	INTRODU��O:

1.1 As Condi��es Gerais de Venda, doravante denominadas CGV, constituem condi��es comerciais, t�cnicas e jur�dicas b�sicas para o FORNECIMENTO de produtos e/ou servi�os pela STECK IND�STRIA EL�TRICA LTDA., doravante denominada STECK, e ser�o aplicadas sempre que referidas como anexo nas propostas, acordos ou quaisquer contratos para FORNECIMENTO de produtos e servi�os da STECK. As presentes CGV s�o aplic�veis sem preju�zo da aplica��o de condi��es espec�ficas que venham a ser mutuamente ajustadas entre as PARTES.

1.2 Quaisquer disposi��es em contr�rio �s presentes CGV, que n�o tenham sido objeto de acordo, por escrito com a STECK, n�o criar�o nenhuma obriga��o para a STECK, que se obriga exclusivamente pelas cl�usulas destas CGV, de SCJ proposta e do instrumento contratual assinado entre a STECK e o CLIENTE. Na aus�ncia de condi��es espec�ficas mutuamente acordadas entre as PARTES, as disposi��es das presentes CGV ser�o as �nicas aplic�veis ao FORNECIMENTO.

1.3 Para efeito das presentes CGV, considerar-se-�o:

Produtos - Todas as pe�as, equipamentos, materiais, partes, componentes, sistemas ou quaisquer outras refer�ncias de PRODUTOS entregues pela STECK, seus SCKfornecedores e/ou SCKcontratados, ao CLIENTE. Sendo eles : Caixas de Passagem e Distribui��o, Comando e Prote��o (disjuntores, rel�s, contatores, etc), Plugues e Tomadas - Uso Industrial/Comercial/Residencial, Produtos para displays, Quadros de Distribui��o, Unidades Combinadas e Bloqueios Mec�nicos

Servi�os - Toda presta��o contratada pelo CLIENTE que envolva pr�-montagem, montagem, instala��o, acompanhamento, supervis�o, testes, comissionamento, manuten��o, constru��o ou quaisquer outras refer�ncias de SERVI�OS prestados pela STECK, seus SCKfornecedores e/ou SCKcontratados ao CLIENTE;
	
Fornecimento - Todos os PRODUTOS e/ou SERVI�OS, conforme o caso, contratados pelo CLIENTE, e que ser�o objeto de entrega ou presta��o pela STECK, seus SCKcontratados e/ou SCK-fornecedores.

2.	CARACTER�STICAS DOS PRODUTOS, SERVI�OS E CONDI��ES DE FORNECIMENTO:

2.1 As quantidades e caracter�sticas dos produtos e servi�os objeto do FORNECIMENTO determinar-se-�o pela proposta. Nenhuma responsabilidade ou obriga��o ter� a STECK no que concerne a produtos e servi�os que n�o tenham sido or�ados ou que n�o constem da confirma��o do pedido.

2.2 Todas as informa��es e dados constantes de documentos anexos � proposta tais como cat�logos, fotografias, desenhos, refer�ncias t�cnicas, pesos, medidas e listas de pre�os, s�o apenas exemplificativos e somente poder�o ser considerados como vinculantes das caracter�sticas do FORNECIMENTO contratado nas SCJs partes e caracter�sticas que forem expressamente referidas na proposta.

2.3 Os materiais e seus respectivos fabricantes constantes na proposta s�o dados apenas como refer�ncia para projeto e fabrica��o. Em casos de dificuldades de aquisi��o, particularmente por raz�es de disponibilidade, a STECK reserva-se no direito de SCKstitu�-los por outros tecnicamente equivalentes.
3.	VALIDADE DA PROPOSTA:

3.1 O prazo de validade das condi��es t�cnicas e comerciais ser� o previsto na proposta ou, caso a proposta n�o tenha estabelecido prazo, ficar� este fixado em 07 (sete) dias corridos contados da apresenta��o. Ap�s este prazo, as condi��es dever�o ser renegociadas e uma nova proposta dever� ser apresentada.

3.2 A validade de qualquer proposta apresentada pela STECK, sob qualquer forma, ficar� condicionada � aprova��o ou confirma��o do cadastro e respectivo limite de cr�dito do CLIENTE podendo eventualmente ser solicitadas garantias de pagamento, sem �nus para a STECK.

4.	PRE�O, REAJUSTE E CONDI��ES DE PAGAMENTO:

Os pre�os dos produtos e servi�os da STECK s�o resultantes das estimativas de custos, condi��es de proposta, condi��es de pol�tica econ�mica do pa�s e legisla��o tribut�ria vigente na SCJ data-base.

Os pre�os estar�o sujeitos a reajuste, sempre na menor periodicidade permitida pela legisla��o contada a partir da data da proposta, pela varia��o do IGPM-FGV, ou outro �ndice equivalente que venha a SCKstitu�-lo.

O pagamento dos produtos ou servi�os ser� efetuado de acordo com as condi��es estabelecidas em cada Pedido de Compra aceito pela STECK, atrav�s de rede banc�ria autorizada.

Considera-se como in�cio de contagem do prazo de pagamento a data de emiss�o da nota fiscal de faturamento.

No caso de atrasos de pagamentos, sem preju�zo do direito da STECK de suspender a execu��o do FORNECIMENTO, o CLIENTE ficar� sujeito a aplica��o de multa de 2% (dois por cento) ao m�s, corre��o monet�ria pelo IGP-M-FGV e juros de mora de 1% (um por cento) ao m�s pro rata die, todos calculados sobre o valor em atraso. Tais encargos ser�o devidos a partir do primeiro dia de atraso e at� o efetivo pagamento, independentemente de qualquer notifica��o judicial ou extrajudicial.

5.	PRAZOS DE ENTREGA:

Os pedidos ser�o entregues de acordo com as condi��es acordadas e com a disponibilidade do estoque da STECK.

O CLIENTE ter� um prazo m�ximo de 05 (cinco) dias ap�s ter recebido o produto para comunicar a STECK qualquer diverg�ncia em rela��o ao Pedido. A STECK, por SCJ vez, compromete-se a corrigir as n�o conformidades dentro do menor prazo poss�vel.

Eventuais devolu��es, contatar o vendedor respons�vel porem somente ser�o aceites ap�s a aprova��o da diretoria comercial. N�o ser�o aceitas devolu��es de produtos fabricados especialmente para atender �s necessidades do CLIENTE e/ou produtos com embalagem danificada.

6.	INSPE��ES:

No caso do CLIENTE desejar que o material seja SCKmetido � inspe��o, dever� fazer solicita��o durante a negocia��o do pedido, indicando nesta oportunidade os tipos de provas desejadas. A STECK informar� sobre a disponibilidade da inspe��o e os custos envolvidos a serem cobrados para cada prova requerida.

7.	PATENTES E DIREITOS DE PROPRIEDADE INDUSTRIAL

O direito de propriedade sobre estudos, projetos, relat�rios, manuais, desenhos e demais elementos t�cnicos eventualmente entregues pela STECK ao CLIENTE, inclusive aqueles que venham a ser desenvolvidos em raz�o do FORNECIMENTO, permanecer�o com a STECK. Tais documentos pertencentes � STECK devem ser considerados como confidenciais, motivo pelo qual o CLIENTE dever� manter sigilo quanto a eles, n�o os transmitindo ou entregando-os a terceiros, salvo com pr�via e expressa autoriza��o por escrito da STECK. Da mesma forma, a STECK obriga-se a manter sigilo quanto a desenhos e informa��es t�cnicas que sejam recebidos do CLIENTE e declarados por este como confidenciais.

O CLIENTE ter� uma licen�a limitada, n�o exclusiva para utiliza��o de desenhos e demais elementos t�cnicos da STECK relativos ao FORNECIMENTO somente para os fins espec�ficos de opera��o e manuten��o do FORNECIMENTO. Em caso de rescis�o do FORNECIMENTO por inadimplemento do CLIENTE fica revogada a licen�a estabelecida nesta cl�usula.

8.	SOLICITA��O DOS PEDIDOS:

Os meios para solicita��o dos Pedidos de Compra s�o:

e-mail: do vendedor respons�vel pelo cliente

Telefone: 11 2248-7000 ou 0800.12.20.22 fora da Grande S�o Paulo

Fax: 11 2248-7051 11-22487069

Correio: Av. Luis Stamatis, 716, Cep: 02260-001, Ja�ana - S�o Paulo - SP

9.	ACEITA��O:

A STECK analisar� os Pedidos de Compra solicitados, e em caso de diverg�ncias envolvendo referencia do produto, pre�o, prazo de entrega, condi��es de pagamento ou de entrega, informar� a empresa compradora para os devidos acertos.

Devido aos custos com a an�lise dos pedidos, separa��o e entrega de produtos, cada solicita��o de compra dever� respeitar um valor m�nimo descrito no or�amento e que � de R$ 800,00 (Oitocentos reais). Para valores inferiores, a STECK sugere que o CLIENTE adquira os produtos diretamente na rede de Distribuidores Autorizados, que est�o localizados em todo o territ�rio Nacional.

Caso o CLIENTE discorde destas altera��es, esta dever� informar � STECK em at� 24 (vinte e quatro) horas, contadas a partir do recebimento da Confirma��o, para que seja poss�vel suspender o faturamento at� que as diverg�ncias sejam negociadas.

10.	ALTERA��ES/CANCELAMENTOS:

Eventuais cancelamentos ou altera��es de Pedidos dever�o ser solicitadas diretamente atrav�s do e-mail do vendedor respons�vel pelo cliente ou do fax 11 22487051

O prazo m�ximo para solicita��es de cancelamentos � de dois dias contados da data de confirma��o do pedido.

11.	PRAZOS PARA FATURAMENTO:

Eventualmente alguns pedidos registrados na STECK, podem sofrer altera��es nos prazos de faturamento, por�m, o cliente ser� informado antecipadamente via e-mail ou telefone sobre a nova data.

12.	GARANTIA:

O prazo de garantia contra defeitos de fabrica��o, devidamente comprovado, � de 12 (doze) meses a contar da data da Nota Fiscal de faturamento.

A garantia se aplica para produtos entregues em nossa f�brica e n�o abranger� estragos e avarias decorrentes de acidentes, instala��es inadequadas ou ocorr�ncias causadas por terceiros. Exclui-se tamb�m da garantia o desgaste devido ao uso intensivo dos materiais e que ultrapassem a vida el�trica ou mec�nica especificada em cat�logo, danos causados por neglig�ncia, imper�cia ou imprud�ncia na manuten��o, uso impr�prio ou inadequado, armazenagem inadequada e motivos de for�a maior ou caso fortuito.

No caso de eventuais defeitos de fabrica��o ocorridos durante o per�odo de garantia, o CLIENTE dever� informar � STECK sobre o tipo de defeito ocorrido atrav�s do e-mail contato@STECK.com.br ou do fax 11 22487051. A STECK se compromete a analisar o ocorrido e consertar ou a SCKstituir o produto dentro do mais curto espa�o de tempo poss�vel. Confirmado que o defeito se encontra dentro das condi��es de garantia acima especificadas, eventuais custos de m�o de obra e materiais para repara��o ou SCKstitui��o ser�o assumidos pela STECK.

As regras acima definidas se aplicam somente para produtos vendidos diretamente pela STECK ou por seus parceiros no mercado brasileiro.


13.	LIMITA��O DE RESPONSABILIDADE POR PERDAS E DANOS

A responsabilidade da STECK por indenizar eventuais perdas e danos que causar relacionadas ao FORNECIMENTO seja por inadimplementos, neglig�ncia, imprud�ncia, imper�cia, indeniza��es, quebra de garantias, ou qualquer outra causa, quer se constituam por fato ou ato isolado ou pela totalidade dos mesmos, fica limitada aos danos diretos causados ao CLIENTE durante o prazo de execu��o do FORNECIMENTO e at� o t�rmino do prazo de garantia e ao valor total agregado de 50% (cinquenta por cento) do valor do FORNECIMENTO.

Fica entendido ainda, que a STECK n�o ser� respons�vel, em hip�tese alguma por indenizar eventuais lucros cessantes, perdas de receita ou de produ��o, perdas de contratos, custos de ociosidade, custos adicionais de energia, penalidades do poder concedente, danos a imagem ou quaisquer hip�teses de danos indiretos e/ou conseq�entes. A limita��o de responsabilidade prevista nesta cl�usula prevalece e aplica-se para fins de delimitar qualquer disposi��o contratual que diga respeito a indeniza��es ou compensa��es devidas pela STECK.

14.	OBSERVA��ES GERAIS:

Caso o CLIENTE necessite de uma contrata��o com caracter�sticas particulares, diferentes das condi��es aqui estabelecidas, esta se realizar� atrav�s de um contrato de fornecimento espec�fico, negociado e acordado entre as partes.

O CLIENTE ao entregar o Pedido de Compra � STECK concorda e aceita integralmente as condi��es aqui estabelecidas, que prevalecer� sobre qualquer outra condi��o da compradora.

Caso a compradora esteja localizada em �reas com benef�cios fiscais como por exemplo a Zona Franca de Manaus e adquira produtos na STECK com benef�cios da n�o tributa��o do ICMS e/ou IPI, a mesma dever� proceder de acordo com as informa��es solicitadas pela SUFRAMA, para internamento da mercadoria, que dever� ocorrer em at� 60 dias da data da emiss�o da Nota Fiscal. O n�o cumprimento das orienta��es solicitadas pela SUFRAMA, dentro do prazo acima, implica em penalidades conforme descrito por lei e caso a STECK seja obrigada a recolher os impostos, a mesma repassar� estes valores acrescidos de todos os encargos legais para a compradora.

E-Mail: contato@steck.com.br
Comercial / Administra��o:
Av. Luis Stamatis, N�. 716
Ja�an� - Cep: 02260-001/SP
*/


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �STMAFISREL� Autor � RGV Solucoes          � Data �13/03/13  ���
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



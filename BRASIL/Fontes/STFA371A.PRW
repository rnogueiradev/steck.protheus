#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STFA371A         | Autor | GIOVANI.ZAGO             | Data | 17/01/2013  |
|=====================================================================================|
|Descrição |  Adiciona Botao de Rateio P.E. A410CONS                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STFA371A                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STFA371A(aBotao)
*---------------------------------------------------*
local aRetBot:=aclone(aBotao)

DbSelectArea('SA3')
SA3->(DbSetOrder(7))
If SA3->(dbSeek(xFilial('SA3')+__cuserid))
	If Empty(SA3->A3_SUPER)   .Or. Empty(SA3->A3_GEREN)
		aAdd(aRetBot,{"VERNOTA"  , {|| U_STFA371B()} ,"Rateio de Vendedores"})
	EndIf
EndIf

Return ( aRetBot )

/*====================================================================================\
|Programa  | STFA371B         | Autor | GIOVANI.ZAGO             | Data | 17/01/2013  |
|=====================================================================================|
|Descrição |  Gera o Rateio de Vendedores                                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STFA371B                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STFA371B()
*-----------------------------*

Local aArea         := GetArea()
Local lRet          := .T.
Local lComissRet    := U_STFATI3_7_1('371B')
Local cTitulo 		:= "RATEIO DA COMISSÃO POR VENDEDOR"
Local cPedido       := ''
Local cCliente      := ''
Local lSaida        := .F.  
Local i:= 0 
Local _lRetInc      := Inclui  .Or. Altera
Private _nPosTotItem:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_VALOR"   })
Private _nPosPrcven := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_PRCVEN"  })
Private _nPosQtdVen	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_QTDVEN"  })
Private _nPosPrUnit	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_XPRCLIS"  })
Private _nPosProd   := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" })
Private _nPosComiss := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_XVALCOM" })
Private _nPosCom1   := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_COMIS1" })
Private _nPos2Com   := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_COMIS2" })
Private _nPosCom3   := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_COMIS3" })
Private _nPosCom4   := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_COMIS4" })
Private _nPosCom5   := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_COMIS5" })
Private cVend1		:=  IIF(Empty(Alltrim(M->C5_VEND1)),space(6),Alltrim(M->C5_VEND1))
Private cVendNew1   :=  IIF(Empty(Alltrim(M->C5_VEND1)),space(6),Alltrim(M->C5_VEND1))
Private cVend3      :=  IIF(Empty(Alltrim(M->C5_VEND3)),space(6),Alltrim(M->C5_VEND3))
Private cVendNew3   :=  IIF(Empty(Alltrim(M->C5_VEND3)),space(6),Alltrim(M->C5_VEND3))
Private cVend4 		:=  IIF(Empty(Alltrim(M->C5_VEND4)),space(6),Alltrim(M->C5_VEND4))
Private cVendNew4   :=  IIF(Empty(Alltrim(M->C5_VEND4)),space(6),Alltrim(M->C5_VEND4))
Private cVend5      :=  IIF(Empty(Alltrim(M->C5_VEND5)),space(6),Alltrim(M->C5_VEND5))
Private cVendNew5   :=  IIF(Empty(Alltrim(M->C5_VEND5)),space(6),Alltrim(M->C5_VEND5))
Private nValComiss  := 0
Private aSize    	:= MsAdvSize(.F.)
Private nPorVend1   := IIF(Empty(Alltrim(M->C5_VEND1)),0,M->C5_XRATEI1)
Private nValVend1   := IIF(Empty(Alltrim(M->C5_VEND1)),0,M->C5_XVALRA1)
Private nPorVend3   := IIF(Empty(Alltrim(M->C5_VEND3)),0,M->C5_XRATEI3)
Private nValVend3   := IIF(Empty(Alltrim(M->C5_VEND3)),0,M->C5_XVALRA3)
Private nPorVend4   := IIF(Empty(Alltrim(M->C5_VEND4)),0,M->C5_XRATEI4)
Private nValVend4   := IIF(Empty(Alltrim(M->C5_VEND4)),0,M->C5_XVALRA4)
Private nPorVend5   := IIF(Empty(Alltrim(M->C5_VEND5)),0,M->C5_XRATEI5)
Private nValVend5   := IIF(Empty(Alltrim(M->C5_VEND5)),0,M->C5_XVALRA5)
Private nSaldoVend  := 0  
Private nSaldoRat   := 0

Define FONT oFontCn NAME "Courier"
Define FONT oFontCb NAME "Courier" BOLD
Define FONT oFontN  NAME "Arial"
Define FONT oFontB  NAME "Arial" BOLD
Private oFontN  	:= TFont():New("Arial",9,25,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFontB 	    := TFont():New("Arial",9,50,.T.,.T.,5,.T.,5,.T.,.F.)



If M->C5_XTIPF <>'1'
MSGINFO('Rateio Disponivél Apenas Para Tipo de Fatura TOTAL')
return()
EndIf

If !Empty(Alltrim(M->C5_VEND1)) .and. lRet
	
	For i:= 1 To Len(Acols)
		
		If !aCols[i,Len(aHeader)+1]
			nValComiss    += aCols[i,_nPosComiss]
		EndIf
	Next i
	
	cPedido   := 'PEDIDO Nº '+M->C5_NUM
	cCliente  := 'CLIENTE: '+substr(Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_NOME"),1,30)
	nSaldoVend:=(nValComiss-(nValVend1+nValVend3+nValVend4+nValVend5))
	
	Do While !lSaida
		DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Rateio de Vendedores") From 0,0 To aSize[6]-15,aSize[5]-15  PIXEL OF oMainWnd    //From 1,0 To aSize[6],aSize[5] PIXEL OF oMainWnd
		nSaldoVend:=(nValComiss-(nValVend1+nValVend3+nValVend4+nValVend5))
		@ 001,001 To aSize[6]     ,aSize[5]
		@ 002,002 To aSize[6]-1   ,aSize[5]-1
		@ 004,004 To aSize[6]-3   ,aSize[5]-3
		@ 005,005 To aSize[6]-100 ,aSize[5]-100
		@ 05,07 SAY    cTitulo  COLOR CLR_HRED pixel FONT oFontB
		@ 30,07 SAY    cCliente 			   pixel FONT oFontN
		@ 39,07 SAY    cPedido  			   pixel FONT oFontN
		@ 050,005 To 051,aSize[5]
		@ 053,005 To 054,aSize[5]
		@ 055,07  SAY   "Comissão do Pedido: R$ " COLOR CLR_BLUE   pixel FONT oFontN
		@ 055,140 SAY   Transform(nValComiss, "@E 99,999,999.99")   pixel FONT oFontN
		@ 070,07  SAY   "Saldo A Ratear:  R$ "  COLOR CLR_BLUE     pixel FONT oFontN
		@ 070,140 SAY   Transform(iif(nSaldoVend<0,0,nSaldoVend), "@E 99,999,999.99")  pixel FONT oFontN 
		@ 070,300  SAY  "Saldo Rateado:  R$ "  COLOR CLR_BLUE     pixel FONT oFontN
		@ 070,440 SAY   Transform(nSaldoRat, "@E 99,999,999.99")  pixel FONT oFontN
		@ 083,005 To 084,aSize[5]
		@ 086,005 To 087,aSize[5]
		@ 090,07 SAY "Vendedor 1:" COLOR CLR_BLUE pixel FONT oFontN
		@ 105,07 MSGet cVendNew1 	F3 'SA3EXT'	  Size 35,012  PIXEL OF oDlgEmail Valid STVALVEND() WHEN _lRetInc
		@ 133,07 SAY substr(Posicione("SA3",1,xFilial("SA3")+cVendNew1,"A3_NOME"),1,25)  COLOR CLR_BLUE pixel FONT oFontN
		@ 153,07 MSGet nPorVend1 picture "@E 999.99"  When !Empty(cVendNew1).And. _lRetInc Size 35,012  PIXEL OF oDlgEmail valid STVALIDPOR()
		@ 183,07 MSGet nValVend1 picture "@E 99,999,999.99"   When !Empty(cVendNew1).And. _lRetInc Size 50,012  PIXEL OF oDlgEmail   valid  STVALIDBROW()
		@ 087,190 To 200,191
		@ 087,193 To 200,194
		@ 090,200 SAY "Vendedor 3:" PIXEL OF COLOR CLR_BLUE pixel FONT oFontN
		@ 105,200 MSGet cVendNew3 	F3 'SA3EXT'	  Size 35,012  PIXEL OF oDlgEmail Valid STVALVEND()WHEN _lRetInc
		@ 133,200 SAY substr(Posicione("SA3",1,xFilial("SA3")+cVendNew3,"A3_NOME"),1,25)  COLOR CLR_BLUE pixel FONT oFontN
		@ 153,200 MSGet nPorVend3 picture "@E 999.99"  When !Empty(cVendNew3).And. _lRetInc Size 35,012  PIXEL OF oDlgEmail valid STVALIDPOR()
		@ 183,200 MSGet nValVend3 picture "@E 99,999,999.99"   When !Empty(cVendNew3).And. _lRetInc Size 50,012  PIXEL OF oDlgEmail    valid STVALIDBROW()
		@ 087,190+200 To 200,191+200
		@ 087,193+200 To 200,194+200
		@ 090,200+200 SAY "Vendedor 4:" PIXEL OF COLOR CLR_BLUE pixel FONT oFontN
		@ 105,200+200 MSGet cVendNew4 	F3 'SA3EXT'	  Size 35,012  PIXEL OF oDlgEmail Valid STVALVEND()WHEN _lRetInc
		@ 133,200+200 SAY substr(Posicione("SA3",1,xFilial("SA3")+cVendNew4,"A3_NOME"),1,25)  COLOR CLR_BLUE pixel FONT oFontN
		@ 153,200+200 MSGet nPorVend4 picture "@E 999.99"  When !Empty(cVendNew4).And. _lRetInc Size 35,012  PIXEL OF oDlgEmail valid STVALIDPOR()
		@ 183,200+200 MSGet nValVend4 picture "@E 99,999,999.99"   When !Empty(cVendNew4).And. _lRetInc Size 50,012  PIXEL OF oDlgEmail    valid STVALIDBROW()
		@ 087,190+400 To 200,191+400
		@ 087,193+400 To 200,194+400
		@ 090,200+400 SAY "Vendedor 5:" PIXEL OF COLOR CLR_BLUE pixel FONT oFontN
		@ 105,200+400 MSGet cVendNew5 	F3 'SA3EXT'	  Size 35,012  PIXEL OF oDlgEmail Valid STVALVEND()WHEN _lRetInc
		@ 133,200+400 SAY substr(Posicione("SA3",1,xFilial("SA3")+cVendNew5,"A3_NOME"),1,25)  COLOR CLR_BLUE pixel FONT oFontN
		@ 153,200+400 MSGet nPorVend5 picture "@E 999.99"  When !Empty(cVendNew5).And. _lRetInc Size 35,012  PIXEL OF oDlgEmail valid STVALIDPOR()
		@ 183,200+400 MSGet nValVend5 picture "@E 99,999,999.99"   When !Empty(cVendNew5).And. _lRetInc Size 50,012  PIXEL OF oDlgEmail    valid STVALIDBROW()
		@ 200,005 To 201,aSize[5]
		@ 203,005 To 204,aSize[5]
		@ 280, 05 Button "Ok"      Size 28,12 action Eval({|| nOpca:=1,lSaida := STVALIDOK(),oDlgEmail:End()})    Pixel
		@ 280, 70 Button "Cancela" Size 28,12 Action Eval({|| nOpca:=2,lSaida := .T.        ,oDlgEmail:End()})    Pixel
		nOpca:=0
		nSaldoVend:=(nValComiss-(nValVend1+nValVend3+nValVend4+nValVend5))
		ACTIVATE MSDIALOG oDlgEmail CENTERED
	EndDo
	If nOpca == 1
		
		STVALIDNOPCA()
		
	Endif
EndIf
Restarea(aArea)
Return ()

/*====================================================================================\
|Programa  | STVALIDBROW      | Autor | GIOVANI.ZAGO             | Data | 17/01/2013  |
|=====================================================================================|
|Descrição |  Valida o Valor Digitado                                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STVALIDBROW                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function STVALIDBROW()
*-----------------------------*
Local lBret   :=.T.
Local nValRat := nValVend1+nValVend3+nValVend4+nValVend5


If nValRat > nValComiss
	Msginfo("Valor Informado Maior Que o Saldo Disponível !!!!")
	lBret   :=.F.
Else
	nSaldoVend:=nValComiss-nValRat
	nPorVend1:=(nValVend1*100)/nValComiss
	nPorVend3:=(nValVend3*100)/nValComiss
	nPorVend4:=(nValVend4*100)/nValComiss
	nPorVend5:=(nValVend5*100)/nValComiss 
	nSaldoRat:=nPorVend5+nPorVend4+nPorVend3+nPorVend1
EndIf
Return (lBret)

/*====================================================================================\
|Programa  | STVALIDPOR       | Autor | GIOVANI.ZAGO             | Data | 17/01/2013  |
|=====================================================================================|
|Descrição |  Valida a Porcentagem		                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STVALIDPOR                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function STVALIDPOR()
*-----------------------------*
Local lBret   :=.T.
Local nPorRat := nPorVend1+nPorVend3+nPorVend4+nPorVend5


If nPorRat > 100
	Msginfo("Porcentagem Informado Maior Que o Saldo Disponível !!!!")
	lBret   :=.F.
Else
	nSaldoVend:=nValComiss-(nValComiss*((nPorVend1+nPorVend3+nPorVend4+nPorVend5)/100) )
	nValVend1:=(nPorVend1*nValComiss)/100
	nValVend3:=(nPorVend3*nValComiss)/100
	nValVend4:=(nPorVend4*nValComiss)/100
	nValVend5:=(nPorVend5*nValComiss)/100
EndIf
Return (lBret)

/*====================================================================================\
|Programa  | STVALVEND        | Autor | GIOVANI.ZAGO             | Data | 17/01/2013  |
|=====================================================================================|
|Descrição |  Valida o Vendedor				                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STVALVEND                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function STVALVEND()
*-----------------------------*
Local lBret   :=.F.

If Empty(cVendNew1)
	nValVend1:=0
	nPorVend1:=0
EndIf
If Empty(cVendNew3)
	nValVend3:=0
	nPorVend3:=0
EndIf
If Empty(cVendNew4)
	nValVend4:=0
	nPorVend4:=0
EndIf
If Empty(cVendNew5)
	nValVend5:=0
	nPorVend5:=0
EndIf

If (IiF(Empty(cVendNew1),.T.,(existcpo("SA3",cVendNew1) .AND. Posicione("SA3",1,xFilial("SA3")+cVendNew1,"A3_TPVEND")<>"I") .AND. cVendNew1<>cVendNew3 .AND. cVendNew1<>cVendNew4 .AND. cVendNew1<>cVendNew5)  ) .and. ;
	(IiF(Empty(cVendNew3),.T.,(existcpo("SA3",cVendNew3) .AND. Posicione("SA3",1,xFilial("SA3")+cVendNew3,"A3_TPVEND")<>"I") .AND. cVendNew1<>cVendNew3 .AND. cVendNew3<>cVendNew4 .AND. cVendNew3<>cVendNew5)  ) .and. ;
	(IiF(Empty(cVendNew4),.T.,(existcpo("SA3",cVendNew4) .AND. Posicione("SA3",1,xFilial("SA3")+cVendNew4,"A3_TPVEND")<>"I") .AND. cVendNew1<>cVendNew4 .AND. cVendNew3<>cVendNew4 .AND. cVendNew4<>cVendNew5)  ) .and. ;
	(IiF(Empty(cVendNew5),.T.,(existcpo("SA3",cVendNew5) .AND. Posicione("SA3",1,xFilial("SA3")+cVendNew5,"A3_TPVEND")<>"I") .AND. cVendNew1<>cVendNew5 .AND. cVendNew3<>cVendNew5 .AND. cVendNew4<>cVendNew5)  )
	lBret   := .T.
EndIf


Return (lBret)
/*====================================================================================\
|Programa  | STVALIDOK        | Autor | GIOVANI.ZAGO             | Data | 17/01/2013  |
|=====================================================================================|
|Descrição |  Valida OK					                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STVALIDOK                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function STVALIDOK()
*-----------------------------*
Local lBret   :=.T.
Local nPorRat := nPorVend1+nPorVend3+nPorVend4+nPorVend5
Local nValRat := nValVend1+nValVend3+nValVend4+nValVend5

If nPorRat <> 100    .and. nValRat <> nValComiss
	Msginfo("Rateio Possui Saldo Disponível !!!!")
	lBret   :=.F.
	nSaldoVend:=(nValComiss-(nValVend1+nValVend3+nValVend4+nValVend5))
EndIf

Return (lBret)
/*====================================================================================\
|Programa  | STVALIDNOPCA     | Autor | GIOVANI.ZAGO             | Data | 17/01/2013  |
|=====================================================================================|
|Descrição |  Valida OK					                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STVALIDNOPCA                                                             |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function STVALIDNOPCA()
*-----------------------------*
Local nStAcols :=0
Local j :=0

M->C5_VEND1   :=  cVendNew1
M->C5_VEND3   :=  cVendNew3
M->C5_VEND4   :=  cVendNew4
M->C5_VEND5   :=  cVendNew5
M->C5_XRATEI1 :=  nPorVend1
M->C5_XRATEI3 :=  nPorVend3
M->C5_XRATEI4 :=  nPorVend4
M->C5_XRATEI5 :=  nPorVend5
M->C5_XVALRA1 :=  nValVend1
M->C5_XVALRA3 :=  nValVend3
M->C5_XVALRA4 :=  nValVend4
M->C5_XVALRA5 :=  nValVend5

For j:= 1 To Len(Acols)
	
	If !aCols[j,Len(aHeader)+1]  
	    nStAcols :=aCols[j,_nPosTotItem] 
		aCols[j,_nPosCom1] := ROUND( ( ((aCols[j,_nPosComiss]*(M->C5_XRATEI1/100))*100) /nStAcols),2)
		aCols[j,_nPos2Com] := Posicione("SA3",1,xFilial("SA3")+M->C5_VEND2,"A3_COMIS")
		aCols[j,_nPosCom3] := ROUND( ( ((aCols[j,_nPosComiss]*(M->C5_XRATEI3/100))*100) /nStAcols),2)
		aCols[j,_nPosCom4] := ROUND( ( ((aCols[j,_nPosComiss]*(M->C5_XRATEI4/100))*100) /nStAcols),2)
		aCols[j,_nPosCom5] := ROUND( ( ((aCols[j,_nPosComiss]*(M->C5_XRATEI5/100))*100) /nStAcols),2)
	EndIf
Next j

Return ()

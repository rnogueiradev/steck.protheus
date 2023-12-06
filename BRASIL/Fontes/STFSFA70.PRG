#INCLUDE "PROTHEUS.CH" 
#INCLUDE "APVT100.CH" 

Static __cPalAtu := ""
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STFSFA70 ³ Autor ³ Totvs                 ³ Data ³ 03/10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina de Controle de Pallets (Expedicao Manaus)           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK                                                   	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//------------------------------------------------------------------------
//Chamada da funcao para produtos com embalagens padronizadas
User Function STFSF70A()
	STFSFA70(1)
Return

//------------------------------------------------------------------------
//Chamada da funcao para produtos com embalagens despadronizadas
User Function STFSF70B()
	STFSFA70(2)
Return


//------------------------------------------------------------------------
Static Function STFSFA70(nOpc)
Local   bkey09
Local   bkey16
Local   bkey24

Local   cEtiq     := Space(48)
Private cNControl := Space(TamSX3("PE2_CTRL")[01])
Private cPallet   := Space(TamSX3("PE2_PALLET")[01])
Private nQtdVol   := 0
Private nTipoOpc  := nOpc

bkey09 := VTSetKey(09,{|| Informa()},"Informacao")
bkey16 := VTSetKey(16,{|| NewPallet()},"Novo Pallet")
bKey24 := VTSetKey(24,{|| Estorna()},"Estorno")

cNControl := Space(TamSX3("PE2_CTRL")[01])
VTCLEAR
@ 0,0 VTSAY Padc("SEPARACAO",VTMaxCol())
@ 2,0 VTSAY "Numero de Controle:"
@ 3,0 VTGET cNControl PICTURE "@!" F3 "PE1" VALID VldCtrl()
@ 5,0 VTSAY "Tecle ENTER p/ novo"
@ 6,0 VTSAY "volume"
VTREAD
If VTLASTKEY()==27
	If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
		Return
	Endif
Endif

cPallet := RetNumPal(1)
nQtdVol := RetQtdVol()
While .t.
	cEtiq := Space(48)
	VTCLEAR
	@ 0,00 VTSAY Padc("SEPARACAO",VTMaxCol())
	@ 2,00 VTSAY "N.Contr.: " + cNControl
	@ 3,00 VTSAY "N.Pallet:"
	@ 3,10 VTGET cPallet PICTURE "@!" VALID VldPallet() //WHEN VTLastkey() == 5
	@ 4,00 VTSAY "N.Volume: " + StrZero(nQtdVol,3)
	@ 6,00 VTSAY "Etiqueta"
	@ 7,00 VTGET cEtiq PICTURE "@!" VALID VldEtiq(cEtiq) //WHEN VTLastkey() == 5
	VTREAD
	If VTLASTKEY()==27
		If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
			Exit
		EndIf
	EndIf
Enddo
vtsetkey(09,bkey09)
vtsetkey(16,bkey16)
vtsetkey(24,bkey24)

Return


//------------------------------------------------------------------------
Static Function VldCtrl()

If Empty(cNControl)
	If !CBYesNo("Confirma NOVO controle?",".:AVISO:.",.t.)
		Return .f.
	Endif
	cNControl := PE1->(GetSX8Num("PE1","PE1_CTRL"))
	ConfirmSX8()
	PE1->(RecLock("PE1",.T.))
	PE1->PE1_FILIAL := xFilial("PE1")
	PE1->PE1_CTRL   := cNControl
	PE1->PE1_TIPO   := Str(nTipoOpc,1)
	PE1->PE1_STATUS := "0"
	PE1->(MsUnLock())
Endif

PE1->(DbSetOrder(1))
If !PE1->(DbSeek(xFilial("PE1")+cNControl))
	CBAlert("Controle invalido!",".:AVISO:.",.t.,2000,1)
	Return .f.
Endif

If PE1->PE1_STATUS == "1"
	If !CBYesNo("Controle fechado! Confirma reabertura?",".:AVISO:.",.t.)
		Return .f.
	Endif
	PE1->(RecLock("PE1",.F.))
	PE1->PE1_STATUS := "0"
	PE1->(MsUnlock())
ElseIf PE1->PE1_STATUS == "2"
	CBAlert("Pedido de vendas gerado!",".:AVISO:.",.t.,3000,1)
	Return .f.
ElseIf PE1->PE1_STATUS == "3"
	CBAlert("Nota fiscal gerada!",".:AVISO:.",.t.,3000,1)
	Return .f.
Endif

Return .t.


//------------------------------------------------------------------------
Static Function VldPallet()

If Empty(cPallet)
	If Empty(__cPalAtu)
		CBAlert("Pallet vazio!",".:AVISO:.",.t.,2000,1)
		Return .f.
	Else
		cPallet := __cPalAtu
		__cPalAtu := ""
		VTGetRefresh("cPallet")
	Endif
Endif

If !RetNumPal(2,cPallet)
	CBAlert("Pallet invalido!",".:AVISO:.",.t.,2000,1)
	Return .f.
Endif

Return .t.


//------------------------------------------------------------------------
Static Function VldEtiq(cEtiq)
Local aEtiqueta:= {}
Local nSldDisp	:= 0
Local nQE

aEtiqueta := CBRetEtiEan(cEtiq)
If Empty(aEtiqueta)
	VTKeyBoard(chr(20))	
	Return .f.
Endif

SB1->(DbSetOrder(1))
If !SB1->(DbSeek(xFilial("SB1")+aEtiqueta[01]))
	CBAlert("Produto invalidoGIO!",".:AVISO:.",.t.,2000,1)
	VTKeyBoard(chr(20))	
	Return .f.
Endif
nQE := fCBQEmb()

If nQE <> aEtiqueta[02] .AND. nTipoOpc == 1
	CBAlert("Volume com quantidade fora do padrao!",".:AVISO:.",.t.,2000,1)
	VTKeyBoard(chr(20))	
	Return .f.
ElseIf nQE == aEtiqueta[02] .AND. nTipoOpc == 2
	CBAlert("Volume com quantidade padronizada!",".:AVISO:.",.t.,2000,1)
	VTKeyBoard(chr(20))	
	Return .f.
Endif

If Rastro(aEtiqueta[01]) .AND. Empty(aEtiqueta[03])
	CBAlert("Produto controla rastreabilidade! Lote nao informado!",".:AVISO:.",.t.,3000,1)
	VTKeyBoard(chr(20))	
	Return .f.
ElseIf !Rastro(aEtiqueta[01]) .AND. !Empty(aEtiqueta[03])
	CBAlert("Produto nao controla rastreabilidade! Lote informado!",".:AVISO:.",.t.,3000,1)
	VTKeyBoard(chr(20))	
	Return .f.
Endif

//Verifica se existe saldo disponivel do produto
SB2->(DbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
If !SB2->(DbSeek(xFilial("SB2")+SB1->(B1_COD+B1_LOCPAD)))
	CBAlert("Produto nao possui saldo disponivel!",".:AVISO:.",.t.,3000,1)
	VTKeyBoard(chr(20))	
	Return .f.
Endif	
nSldDisp := SaldoSb2()
If nSldDisp == 0
	CBAlert("Produto nao possui saldo disponivel!",".:AVISO:.",.t.,3000,1)
	VTKeyBoard(chr(20))	
	Return .f.
Endif	

//Posiciona novamente o cabecalho - PE1_FILIAL+PE1_CTRL
If !PE1->(DbSeek(xFilial("PE1")+ cNControl))
	CBAlert("Controle não localizado! Impossivel continuar!",".:AVISO:.",.t.,3000,1)
	VTKeyBoard(chr(20))	
	Return .f.
Endif	

If !(PE1->PE1_STATUS == "0")
	CBAlert("Controle modificado pelo gestor! Impossivel continuar",".:AVISO:.",.t.,3000,1)
	VTKeyBoard(chr(20))	
	Return .f.
Endif	
	

//Grava volume lido:
//PE2_FILIAL+PE2_CTRL+PE2_PALLET+PE2_PROD+PE2_LOTE
If PE2->(DbSeek(xFilial("PE2")+cNControl+cPallet+aEtiqueta[01]+aEtiqueta[03]))
	PE2->(RecLock("PE2",.F.))
Else
	PE2->(RecLock("PE2",.T.))
	PE2->PE2_FILIAL := xFilial("PE2")
	PE2->PE2_CTRL   := cNControl
	PE2->PE2_PALLET := cPallet
	PE2->PE2_PROD   := aEtiqueta[01]
	PE2->PE2_LOTE   := aEtiqueta[03]	
Endif
PE2->PE2_QTDE   += aEtiqueta[02]
PE2->(MsUnLock())

U_STFSF70C(cNControl) //Atualiza informacoes do Controle (pesos, quantidades volumes)
nQtdVol := RetQtdVol()
@ 4,00 VTSAY "N.Volume: " + StrZero(nQtdVol,3)

Return .f.


//------------------------------------------------------------------------
//Atualiza informacoes do Controle (pesos, quantidades volumes)
User Function STFSF70C(cNControl)
Local aPallets := {}
Local nVols    := 0
Local nPesoL   := 0
Local nPesoB   := 0
Local nPesoT   := GetNewPar("FS_PESOT",1.8)
Local nPos

SB1->(DbSetOrder(1))
PE1->(DbSetOrder(1))
PE1->(DbSeek(xFilial("PE1")+cNControl))

PE2->(DbSetOrder(1))
PE2->(DbSeek(xFilial("PE2")+cNControl))
While PE2->(!Eof() .AND. PE2_FILIAL+PE2_CTRL == xFilial("PE2")+cNControl)
	++nVols
	nPos := Ascan(aPallets,PE2->PE2_PALLET)
	If nPos == 0
		aadd(aPallets,PE2->PE2_PALLET)
	Endif
	SB1->(DbSeek(xFilial("SB1")+PE2->PE2_PROD))
	nPesoL += (SB1->B1_PESO * PE2->PE2_QTDE)
	PE2->(DbSkip())
Enddo
nPesoB := nPesoL + (nVols * nPesoT)

//Atualiza informacao da tabela de Controle de Pallets:
PE1->(RecLock("PE1",.F.))
PE1->PE1_QTDPAL := Len(aPallets)
PE1->PE1_QTDVOL := nVols
PE1->PE1_PBRUTO := nPesoB
PE1->PE1_PLIQ   := nPesoL
PE1->(MsUnLock())
If IsTelNet()
	VTKeyBoard(chr(20))	
Endif

Return


//------------------------------------------------------------------------
Static Function Informa()
Local aCab,aSize
Local aPallets := {}
Local nVols    := 0
Local nX,nPos
Local aTemp    :={}

If Empty(cNControl)
	Return
Endif

PE2->(DbSetOrder(1))
PE2->(DbSeek(xFilial("PE2")+cNControl))
While PE2->(!Eof() .AND. PE2_FILIAL+PE2_CTRL == xFilial("PE2")+cNControl)
	++nVols
	nPos := Ascan(aPallets,PE2->PE2_PALLET)
	If nPos == 0
		aadd(aPallets,PE2->PE2_PALLET)
	Endif
	aadd(aTemp,{PE2->PE2_PALLET,PE2->PE2_PROD,PE2->PE2_LOTE,PE2->PE2_QTDE})
	PE2->(DbSkip())
Enddo
aSort(aTemp,,, {|x,y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3] })

aSave := VTSAVE()
VTClear()
@ 00,00 VtSay "Total pallets: " + StrZero(Len(aPallets),3)
@ 01,00 VtSay "Total volumes: " + StrZero(nVols,3)

aCab  := {"Pallet","Produto","Lote","Quantidade"}
aSize := {06,15,10,11}
VTaBrowse(2,0,7,19,aCab,aTemp,aSize)
VtRestore(,,,,aSave)
Return


//------------------------------------------------------------------------
Static Function Estorna()
Local   aTela     := VTSave()
Local   cEtiqueta := Space(48)
Private lEstorno  := .f.
VTClear()
@ 00,00 VtSay Padc("Estorno da Leitura",VTMaxCol())
@ 02,00 VtSay "Etiqueta:"
@ 03,00 VtGet cEtiqueta pict "@!" Valid VldEstorno(cEtiqueta)
VtRead
vtRestore(,,,,aTela)

If lEstorno
	U_STFSF70C(cNControl) //Atualiza informacoes do Controle (pesos, quantidades volumes)
	nQtdVol := RetQtdVol()
	@ 4,00 VTSAY "N.Volume: " + StrZero(nQtdVol,3)
Endif

Return

Static Function VldEstorno(cEtiqueta)
Local aEtiqueta := {}
Local nQE

aEtiqueta := CBRetEtiEan(cEtiqueta)
If Empty(aEtiqueta)
	CBAlert("Etiqueta invalida!",".:AVISO:.",.t.,2000,1)
	VTKeyBoard(chr(20))	
	Return .f.
Endif

SB1->(DbSetOrder(1))
If !SB1->(DbSeek(xFilial("SB1")+aEtiqueta[01]))
	CBAlert("Produto invalido!",".:AVISO:.",.t.,2000,1)
	VTKeyBoard(chr(20))	
	Return .f.
Endif
nQE := fCBQEmb()

If nQE <> aEtiqueta[02] .AND. nTipoOpc == 1
	CBAlert("Volume com quantidade padronizada!",".:AVISO:.",.t.,2000,1)
	VTKeyBoard(chr(20))	
	Return .f.
ElseIf nQE == aEtiqueta[02] .AND. nTipoOpc == 2
	CBAlert("Volume com quantidade fora do padrao!",".:AVISO:.",.t.,2000,1)
	VTKeyBoard(chr(20))	
	Return .f.
Endif

PE2->(DbSetOrder(1))
If !PE2->(DbSeek(xFilial("PE2")+cNControl+cPallet+aEtiqueta[01]+aEtiqueta[03]))
	CBAlert("Volume nao lido para o pallet: " + cPallet + "!",".:AVISO:.",.t.,2000,1)
	VTKeyBoard(chr(20))	
	Return .f.
Endif

If !CBYesNo("Confirma estorno do volume?",".:AVISO:.",.t.)
	VTKeyBoard(chr(20))	
	Return .f.
Endif

PE2->(RecLock("PE2",.F.))
PE2->(dbDelete())
PE2->(MsUnLock())
lEstorno := .t.

Return .t.


//------------------------------------------------------------------------
Static Function RetNumPal(nOpc,cPalInfo)
Local   aPallets := {}
Local   nPos
Local   xRet
Default cPalInfo := ""

PE2->(DbSetOrder(1))
PE2->(DbSeek(xFilial("PE2")+cNControl))
While PE2->(!Eof() .AND. PE2_FILIAL+PE2_CTRL == xFilial("PE2")+cNControl)
	nPos := Ascan(aPallets,PE2->PE2_PALLET)
	If nPos == 0
		aadd(aPallets,PE2->PE2_PALLET)
	Endif
	PE2->(DbSkip())
Enddo
aSort(aPallets,,, {|x,y| x < y })

If nOpc == 1 //Retorno do proximo pallet...
	If Empty(aPallets)
		xRet := "000001"
	Else
		xRet := StrZero(Len(aPallets) + 1,6)
	Endif
Else  //Retorno da validacao do pallet informado pelo usuario...
	nPos := Ascan(aPallets,cPalInfo)
	If nPos == 0 .AND. cPalInfo <> StrZero(Len(aPallets) + 1,6)
		xRet := .f.
	Else
		xRet := .t.
	Endif
Endif

Return xRet


//------------------------------------------------------------------------
Static Function NewPallet()
Local cPalTmp
If !CBYesNo("Confirma novo pallet?",".:AVISO:.",.t.)
	Return
Endif

cPalTmp := RetNumPal(1)
__cPalAtu := cPalTmp 
cPallet := cPalTmp 
VTGetRefresh("cPallet")
cPallet := cPalTmp
VTKeyBoard(chr(13))	
Return

//------------------------------------------------------------------------
Static Function RetQtdVol()
Local nRet := 0

PE2->(DbSetOrder(1))
PE2->(DbSeek(xFilial("PE2")+cNControl))
While PE2->(!Eof() .AND. PE2_FILIAL+PE2_CTRL == xFilial("PE2")+cNControl)
	++nRet
	PE2->(DbSkip())
Enddo

Return nRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSFA70  ºAutor  ³Microsiga           º Data ³  11/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a quantidade de embalagem sem qtde 1 como default  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCBQEmb()
Local nRet := 0

SB5->(DbSetOrder(1))
If ! SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD)) .or. SB5->(FieldPos('B5_QEL')) ==0 .or. Empty(SB5->B5_QEL)
	If RetArqProd(SB1->B1_COD)
		nRet := SB1->B1_QE
	Else
		nRet := SBZ->BZ_QE
	EndIf
Else
	nRet :=SB5->B5_QEL 		
EndIf

Return nRet
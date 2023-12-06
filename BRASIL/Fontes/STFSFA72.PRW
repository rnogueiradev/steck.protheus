#INCLUDE "PROTHEUS.CH" 
#INCLUDE "APVT100.CH" 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STFSFA72 ³ Autor ³ Totvs                 ³ Data ³ 03/10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Controle Manaus                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ STECK                                                   	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFSFA72( cAlias, nReg, nOpcx )
Local nOpc
Local cCtrlDe
Local cCtrlAte
Local cPalletDe
Local cPalletAte

Private cString      := "PE1"
Private aOrd         := {}
Private cDesc1       := "Este programa tem como objetivo imprimir informacoes referentes ao "
Private cDesc2       := "Controle Manaus"
Private cDesc3       := ""
Private cPict        := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 220
Private tamanho      := "M"
Private nomeprog     := "STFSF72R" 
Private nTipo        := 18
Private aReturn      := {"Zebrado",1,"Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private titulo       := "Relatorio de Controle Manaus"
Private nLin         := 99
Private Cabec1       := ""
Private Cabec2       := ""
Private cbtxt        := "Registro(s) lido(s)"
Private cbcont       := 0
Private CONTFL       := 01
Private m_pag        := 01
Private imprime      := .T.
Private wnrel        := "STFSF72R"

AjustaSX1()
If !Pergunte("STFSF72R",.t.)
	Return
Endif
nOpc       := MV_PAR01
cCtrlDe    := MV_PAR02
cCtrlAte   := MV_PAR03
cPalletDe  := MV_PAR04
cPalletAte := MV_PAR05
If cCtrlDe > cCtrlAte
	MsgAlert("Parâmetros de Controles inválido!","Aviso")
	Return
Endif

If cPalletDe > cPalletAte
	MsgAlert("Parâmetros de Pallets inválido!","Aviso")
	Return
Endif

wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,Nil,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

Processa({|| ImpRel(nOpc,cCtrlDe,cCtrlAte,cPalletDe,cPalletAte) },Titulo)
Return


//------------------------------------------------------------------------
Static Function ImpRel(nOpc,cCtrlDe,cCtrlAte,cPalletDe,cPalletAte)
Local aImpDet := {}
Local cCtrlAtu
Local cQuery
Local nPos
Local nX

If nOpc == 1  //Por Palelt

	cQuery := " Select PE2_CTRL,PE2_PALLET,PE2_PROD,PE2_LOTE,PE2_QTDE,PE1_PV,B1_DESC "
	cQuery += "   From "+RetSqlName("PE2")+" PE2,"+RetSqlName("PE1")+" PE1,"+RetSqlName("SB1")+" SB1"
	cQuery += "  Where PE2_FILIAL = '" + xFilial("PE2") + "' AND PE1_FILIAL = '" + xFilial("PE1") + "' AND B1_FILIAL = '" + xFilial("SB1") + "' AND"
	cQuery += "        PE2_CTRL >= '"+cCtrlDe+"' AND PE2_CTRL <= '"+cCtrlAte+"' AND"
	cQuery += "        PE2_PALLET >= '"+cPalletDe+"' AND PE2_PALLET <= '"+cPalletAte+"' AND"
	cQuery += "        PE2_CTRL = PE1_CTRL AND"
	cQuery += "        PE2_PROD = B1_COD AND"
	cQuery += "        PE2.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' '"

	//cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)
	TMP->(DbGoTop())
	While TMP->(!Eof())
		nPos := Ascan(aImpDet,{|x| x[01]+x[02]+x[03]+x[04] == TMP->(PE2_CTRL+PE2_PALLET+PE2_PROD+PE2_LOTE)})
		If nPos == 0
			aadd(aImpDet,{TMP->PE2_CTRL,TMP->PE2_PALLET,TMP->PE2_PROD,TMP->PE2_LOTE,TMP->PE2_QTDE,1,TMP->PE1_PV,TMP->B1_DESC})
		Else
			aImpDet[nPos,05] += TMP->PE2_QTDE
			aImpDet[nPos,06] += 1
		Endif
		TMP->(DbSkip())
	Enddo
	TMP->(dbCloseArea())

Else  //Por Produto

	cQuery := " Select PE2_CTRL,PE2_PROD,PE2_QTDE,PE1_PV,B1_DESC "
	cQuery += "   From "+RetSqlName("PE2")+" PE2,"+RetSqlName("PE1")+" PE1,"+RetSqlName("SB1")+" SB1"
	cQuery += "  Where PE2_FILIAL = '" + xFilial("PE2") + "' AND PE1_FILIAL = '" + xFilial("PE1") + "' AND B1_FILIAL = '" + xFilial("SB1") + "' AND"
	cQuery += "        PE2_CTRL >= '"+cCtrlDe+"' AND PE2_CTRL <= '"+cCtrlAte+"' AND"
	cQuery += "        PE2_CTRL = PE1_CTRL AND"
	cQuery += "        PE2_PROD = B1_COD AND"
	cQuery += "        PE2.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' '"

	//cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)
	TMP->(DbGoTop())
	While TMP->(!Eof())
		nPos := Ascan(aImpDet,{|x| x[01]+x[02] == TMP->(PE2_CTRL+PE2_PROD)})
		If nPos == 0
			aadd(aImpDet,{TMP->PE2_CTRL,TMP->PE2_PROD,TMP->PE2_QTDE,1,TMP->PE1_PV,TMP->B1_DESC})
		Else
			aImpDet[nPos,03] += TMP->PE2_QTDE
			aImpDet[nPos,04] += 1
		Endif
		TMP->(DbSkip())
	Enddo
	TMP->(dbCloseArea())

Endif

cCtrlAtu := ""
For nX:=1 to Len(aImpDet)
	If cCtrlAtu <> aImpDet[nX,01]
		Cabec3(nOpc,nX,aImpDet)
		cCtrlAtu := aImpDet[nX,01]
	Endif
	ImpDet(nOpc,nX,aImpDet)
Next

SET DEVICE TO SCREEN
If aReturn[5]==1
	DbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return


//------------------------------------------------------------------------
Static Function ImpDet(nOpc,nX,aImpDet)

If nOpc == 1 //Por Pallet
	@ nLin,000 PSay aImpDet[nX,02]
	@ nLin,008 PSay StrZero(aImpDet[nX,06],3)
	@ nLin,016 PSay AllTrim(aImpDet[nX,03]) + " - " + Left(aImpDet[nX,08],30)
	@ nLin,070 PSay aImpDet[nX,06] Picture "@E 999999"
	@ nLin,078 PSay aImpDet[nX,04]
Else //Por Produto
	@ nLin,000 PSay AllTrim(aImpDet[nX,02]) + " - " + Left(aImpDet[nX,06],30)
	@ nLin,051 PSay aImpDet[nX,03] Picture "@E 999999999"
	@ nLin,065 PSay aImpDet[nX,04] Picture "@E 999999999"
Endif
++nLin

Return


//------------------------------------------------------------------------
Static Function Cabec2()
If nLin > 60
	Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	nLin := 06
EndIf
Return


//------------------------------------------------------------------------
Static Function Cabec3(nOpc,nX,aImpDet)

Cabec2()
@ nLin,000 PSay "CONTROLE: " + aImpDet[nX,01]
++nLin
If nOpc == 1 //Por Pallet
	@ nLin,000 PSay "PEDIDO..: " + aImpDet[nX,07]
	nLin := nLin + 02
	@ nLin,000 PSay "PALLET  VOLUME  PRODUTO                                           QUANTIDADE  LOTE"
	++nLin
	@ nLin,000 PSay "======  ======  ================================================  ==========  =========="
	nLin := nLin + 2
Else  //Por Produto
	@ nLin,000 PSay "PEDIDO..: " + aImpDet[nX,05]
	nLin := nLin + 02
	@ nLin,000 PSay "PRODUTO                                           QTDE TOTAL  QTDE VOLUMES"
	++nLin
	@ nLin,000 PSay "================================================  ==========  ============"
	nLin := nLin + 2
Endif

Return

//------------------------------------------------------------------------
Static Function AjustaSX1()
Local cAlias := Alias()
Local aRegistros:={}
Local i,j:=0

aadd(aRegistros,{Padr("STFSF72R",Len(SX1->X1_GRUPO),""),"01","Tipo relatorio       ?","","","mv_ch1","N",1						,0,0,"C",""	,"mv_par01","Pallet","Pallet","Pallet","","","Produto","Produto","Produto","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{Padr("STFSF72R",Len(SX1->X1_GRUPO),""),"02","Controle de          ?","","","mv_ch2","C",TamSX3("PE1_CTRL")[01]	,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{Padr("STFSF72R",Len(SX1->X1_GRUPO),""),"03","Controle ate         ?","","","mv_ch3","C",TamSX3("PE1_CTRL")[01]	,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{Padr("STFSF72R",Len(SX1->X1_GRUPO),""),"04","Pallet De            ?","","","mv_ch4","C",TamSX3("PE2_PALLET")[01]	,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegistros,{Padr("STFSF72R",Len(SX1->X1_GRUPO),""),"05","Pallet Ate           ?","","","mv_ch5","C",TamSX3("PE2_PALLET")[01]	,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

DbSelectArea("SX1")
SX1->(DbSetOrder(1))
For i:=1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next j
		MsUnlock()
	EndIf
Next I
dbSelectArea(cAlias)
Return



/*
=============================================================================================================
RELATORIO MODELO I (Por Pallets)

CONTROLE: 1111111111
PEDIDO..: 123456

PALLET  VOLUME  PRODUTO                                           QUANTIDADE  LOTE
======  ======  ================================================  ==========  ==========
001     001     123456789012345 - 123456789012345678901234567890      123123  1234567890

=============================================================================================================
RELATORIO MODELO II (Por Produto)

CONTROLE: 1111111111
PEDIDO..: 123456

PRODUTO                                           QTDE TOTAL  QTDE VOLUMES
================================================  ==========  ============
123456789012345 - 123456789012345678901234567890   123456789     123456789  

*/

/////////////////////////////////////////////////////////////////////////////////// 
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | EEC_Cap_Item()| AUTOR | Fernando Pereira    | DATA | 10/08/2013 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Cap-Item ()                                          |//
//|           | Programa que demonstra a utilizacao do relacionamento de duas   |//
//|           | tabela com MsDialog, Enchoice e GetDados.                       |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

/*
+--------------------------------------------------------------------------------
| Parâmetros da MsGetDados():New()
+--------------------------------------------------------------------------------
| MsGetDados():New( nSuperior, nEsquerda, nInferior, nDireita, nOpc, cLinhaOk, ;
|                   cTudoOk, cIniCpos, lApagar, aAlter, uPar1, lVazio, nMax, ;
|                   cCampoOk, cSuperApagar, uPar2, cApagaOk, oWnd )
+--------------------------------------------------------------------------------
| nSuperior....: Distancia entre a MsGetDados e o extremidade superior do objeto que a contém
| nEsquerda....: Distancia entre a MsGetDados e o extremidade esquerda do objeto que a contém
| nInferior....: Distancia entre a MsGetDados e o extremidade inferior do objeto que a contém
| nDireita.....: Distancia entre a MsGetDados e o extremidade direita do objeto que a contém
| nOpc.........: Posição do elemento do vetor aRotina que a MsGetDados usará como referencia
| cLinhaOk.....: Função executada para validar o contexto da linha atual do aCols
| cTudoOk......: Função executada para validar o contexto geral da MsGetDados (todo aCols)
| cIniCpos.....: Nome dos campos do tipo caracter que utilizarão incremento automático.
|                Este parâmetro deve ser no formato "+<nome do primeiro campo>+<nome do
|                segundo campo>+..."
| lApagar......: Habilita deletar linhas do aCols. Valor padrão falso
| aAlter.......: Vetor com os campos que poderão ser alterados
| uPar1........: Parâmetro reservado
| lVazio.......: Habilita validação da primeira coluna do aCols para esta não poder estar vazia.
|                Valor padrão falso
| nMax.........: Número máximo de linhas permitidas. Valor padrão 99
| cCampoOk.....: Função executada na validação do campo
| cSuperApagar.: Função executada quando pressionada as teclas <Ctrl>+<Delete>
| uPar2........: Parâmetro reservado
| cApagaOk.....: Função executada para validar a exclusão de uma linha do aCols
| oWnd.........: Objeto no qual a MsGetDados será criada
+--------------------------------------------------------------------------------
*/
#Include "Protheus.Ch"
#Define ENTER Chr(13)+Chr(10)

User Function EEC_Cap_Item()
Local aCores       := {}

Private nUsado     := 0
Private cCadastro  := "Atualização de Orçamento"
Private cAlias1    := "EE7"
Private cAlias2    := "EE8"
Private cFilEE7    := ""
Private cFilEE8    := ""
Private aRotina    := {}
Private aPos       := {15, 1, 70, 315}
Private oCliente   := Nil
Private oTotal     := Nil
Private cCliente   := ""
Private nTotal     := 0
Public lCommodity  := .F.
Public nOpcI       := ""
Public cPvenda     := EE7->EE7_PEDFAT
Public lEspec      := .T.
Public nSelecao

aAdd( aRotina ,{"Pesquisar" ,"AxPesqui"    ,0,1})
aAdd( aRotina ,{"Alterar"   ,'u_EECMOD3Altera',0,4})

If Empty(Posicione("SX3",1,cAlias1,"X3_ARQUIVO"))
	Help("",1,"","NOX3X2IX","NÃO É POSSÍVEL EXECUTAR, FALTA"+ENTER+"X3, X2, IX E X7",1,0)
	RETURN
Endif

dbSelectArea(cAlias2)
dbSetOrder(1)
cFilEE8 := xFilial(cAlias2)

dbSelectArea(cAlias1)
dbSetOrder(1)
cFilEE7 := xFilial(cAlias1)

mBrowse(,,,,cAlias1)

Return .T.

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | EEC_Cap_item()| AUTOR | Fernando Pereira  | DATA | 10/08/2013   |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - EECMOD3Visual()                                        |//
//|           | Visualiza os dados                                              |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function EECMOD3Visual( cAlias, nRecNo, nOpc )
Local nX        := 0
Local nCols     := 0
Local nOpcA     := 0
Local oDlg      := Nil
Local oGet      := Nil
Local oMainWnd  := Nil

Private aTela   := {}
Private aGets   := {}
Private aHeader := {}
Private aCols   := {}
Private bCampo  := { |nField| Field(nField) }
Private lAprova := lDesCit := lAltera := .t.

cCliente := ""
nTotal := 0

//+----------------------------------
//| Inicia as variaveis para Enchoice
//+----------------------------------
dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTo(nRecNo)
For nX:= 1 To FCount()
	M->&(Eval(bCampo,nX)) := FieldGet(nX)
Next nX

//+----------------
//| Monta o aHeader
//+----------------
CriaHeader()

//+--------------
//| Monta o aCols
//+--------------
dbSelectArea(cAlias2)
dbSetOrder(1)
dbSeek(cFilEE8+EE7->EE7_PEDIDO)

While !Eof() .And. cFilEE8 == EE7->EE7_FILIAL .And. EE8->EE8_PEDIDO == EE7->EE7_PEDIDO
	aAdd(aCols,Array(nUsado+1))
	nCols ++
	nTotal += EE8->EE8_SLDINI*EE8->EE8_PRECO
	
	For nX := 1 To nUsado
		
		If Alltrim(aHeader[nX][2]) $ "EE8_COD_I|EE8_VM_DES|EE8_SLDINI" //"EE8_PRCFIX|EE8_QTDFIX|EE8_DESOPE"
			Loop
		endif
		
		If ( aHeader[nX][10] != "V")
			aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
		Else
			aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
		Endif
	Next nX
	
	aCols[nCols][nUsado+1] := .F.
	
	dbSelectArea(cAlias2)
	dbSkip()
	
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 TO 28,80  OF oMainWnd
EnChoice(cAlias, nRecNo, nOpc,,,,, aPos,, 3)

// Atualizacao do nome do cliente
@ 136,004 SAY "Cliente: "                                     SIZE 070,7 OF oDlg PIXEL
@ 136,024 SAY oCliente VAR cCliente                           SIZE 098,7 OF oDlg PIXEL

// Atualizacao do total
@ 136,240 SAY "Valor Total: "                                 SIZE 070,7 OF oDlg PIXEL
@ 136,270 SAY oTotal VAR nTotal PICTURE "@E 9,999,999,999.99" SIZE 070,7 OF oDlg PIXEL

EECMOD3AtuCli()

oGet := MsGetDados():New(75,2,130,315,nOpc)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(oGet:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()})

Return .T.

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | EEC_Cap_item()| AUTOR | Fernando Pereira  | DATA | 10/08/2013   |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - EECMOD3Altera()                                        |//
//|           | Altera os dados                                                 |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function EECMOD3Altera( cAlias, nRecNo, nOpc )
Local nOpcA      := 0
Local nX         := 0
Local nCols      := 0
Local oDlg       := Nil

Private aTela    := {}
Private aGets    := {}
Private aHeader  := {}
Private aCols    := {}
Private aAltera  := {}
Private bCampo   := {|nField| FieldName(nField) }
Private lAprova := lDesCit := lAltera := .t.

If GetMv("MV_AVG0090",,.t.)// define se o sistema bloqueia a edição do pedido quando todas as quantidades estão embarcadas
	If !AP102CanModify(EE7->EE7_PEDIDO,.t.)
		nSelecao := nOpc
		Return
	EndIf
Endif

***************************************************************
*** Será usado para criticar se existe nota já emitida.
***************************************************************
cNotaSai := Posicione("SC5",1,xFilial("SC5")+EE7->EE7_PEDFAT,"C5_NOTA")
If !Empty(cNotaSai)
	Alert("Nao permite alteração! Pedido já possui Nota "+cNotaSai+" Emitida! ")
	Return
Endif
***************************************************************

cCliente := ""
nTotal := 0

//+----------------------------------
//| Inicia as variaveis para Enchoice
//+----------------------------------
dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTo(nRecNo)

For nX := 1 To FCount()
	M->&(Eval(bCampo,nX)) := FieldGet(nX)
Next nX

//+----------------
//| Monta o aHeader
//+----------------
CriaHeader()


//+--------------
//| Monta o aCols
//+--------------
dbSelectArea(cAlias2)
dbSetOrder(1)
dbSeek(cFilEE8+EE7->EE7_PEDIDO)

While !Eof() .And. cFilEE8 == EE7->EE7_FILIAL .And. EE8->EE8_PEDIDO == EE7->EE7_PEDIDO
	
	aAdd(aCols,Array(nUsado+1))
	nCols ++
	nTotal += EE8->EE8_PRECO * EE8->EE8_SLDINI
	
	For nX := 1 To nUsado
		
		//If !Alltrim(aHeader[nX][2]) $  "EE8_COD_I|EE8_PRECO|EE8_PRCTOT|EE8_SLDINI|EE8_UNIDAD|EE8_DTPREM|EE8_DTENTR|EE8_CODAGE|EE8_TIPCOM" //$ "EE8_PRCFIX|EE8_QTDFIX|EE8_DESOPE"
		If Alltrim(aHeader[nX][2]) $ "EE8_PRCFIX|EE8_QTDFIX|EE8_DESOPE|EE7_CODBOL"
			Loop
		endif
		
		If ( aHeader[nX][10] != "V")
			aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
		Else
			aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
		Endif
		
	Next nX
	
	aCols[nCols][nUsado+1] := .F.
	dbSelectArea(cAlias2)
	aAdd(aAltera,Recno())
	dbSkip()
	
End

//+----------------------------------
//| Envia para processamento dos Gets
//+----------------------------------
DEFINE MSDIALOG oDlg TITLE cCadastro FROM 8,0 TO 28,80 OF oMainWnd

EnChoice( cAlias, nRecNo, nOpc, , , , , aPos, , 3)

// Atualizacao do nome do cliente
@ 136,004 SAY "Cliente: "                                     SIZE 070,7 OF oDlg PIXEL
@ 136,024 SAY oCliente VAR cCliente                           SIZE 098,7 OF oDlg PIXEL

// Atualizacao do total
@ 136,240 SAY "Valor Total: "                                 SIZE 070,7 OF oDlg PIXEL
@ 136,270 SAY oTotal VAR nTotal PICTURE "@E 9,999,999,999.99" SIZE 070,7 OF oDlg PIXEL

EECMOD3AtuCli()

oGet := MSGetDados():New(75,2,130,315,nOpc,"u_EECMOD3LinOk()","u_EECMOD3TudOk()","+C6_ITEM",.T.)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca:=1,If(u_EECMOD3Tudok().And.Obrigatorio(aGets,aTela),oDlg:End(),nOpca:=0)},{||nOpca:=0,oDlg:End()})

If nOpcA == 1
	Begin Transaction
	If EECMOD3Grava(2,aAltera)
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
		Endif
	EndIf
	End Transaction
Else
	If __lSX8
		RollBackSX8()
	Endif
Endif

Return


/******************************************************************************
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
+-----------------------------------------------------------------------------+
| ******************* FUNCOES GENERICA DESTE PROGRAMA ************************|
+-----------------------------------------------------------------------------+
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
******************************************************************************/

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | EEC_Cap_item()| AUTOR | Fernando Pereira  | DATA | 10/08/2013   |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - CriaHeader()                                           |//
//|           | Cria as variaveis vetor aHeader                                 |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function CriaHeader()
nUsado  := 0
aHeader := {}
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias2)
While ( !Eof() .And. SX3->X3_ARQUIVO == cAlias2 )
	If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
		aAdd(aHeader,{ Trim(X3Titulo()), ;
		SX3->X3_CAMPO   , ;
		SX3->X3_PICTURE , ;
		SX3->X3_TAMANHO , ;
		SX3->X3_DECIMAL , ;
		SX3->X3_VALID   , ;
		SX3->X3_USADO   , ;
		SX3->X3_TIPO    , ;
		SX3->X3_ARQUIVO , ;
		SX3->X3_CONTEXT } )
		nUsado++
	Endif
	dbSkip()
End
Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | EEC_Cap_item()| AUTOR | Fernando Pereira  | DATA | 10/08/2013   |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - EECMOD3AtuCli()                                        |//
//|           | Obetivo e atualizar a MsDialog com o nome do cliente            |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function EECMOD3AtuCli()
cCliente := ""
dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek( xFilial("SA1")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA )
	cCliente := Trim(SA1->A1_NREDUZ)
Endif
oCliente:Refresh()
Return .T.

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | EEC_Cap_item()| AUTOR | Fernando Pereira  | DATA | 10/08/2013   |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - EECMOD3LinOK()                                         |//
//|           | Validar a linha antes de mover para cima ou para baixo          |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function EECMOD3LinOk()
Local lRet      := .T.
Local i         := 0
Local nP_QtdVen := 0
Local nP_PrcVen := 0

// Atualiza o total do rodape
nP_QtdVen := aScan(aHeader,{|x| Trim(x[2])=="EE8_SLDINI"})
nP_PrcVen := aScan(aHeader,{|x| Trim(x[2])=="EE8_PRECO"})
nP_Produto := aScan(aHeader,{|x| Trim(x[2])=="EE8_COD_I"})

nTotal := 0

For i := 1 To Len(aCols)
	
	If aCols[i][nUsado+1]// .OR. Alltrim(aHeader[i][2]) $ "EE8_PRCFIX|EE8_QTDFIX|EE8_DESOPE"
		Loop
		
	Else
		
		nTotal += Round(aCols[i][nP_QtdVen]*aCols[i][nP_PrcVen],2)
		
		cProduto := aCols[i][nP_Produto]
		nQtdVen  := aCols[i][nP_QtdVen]
		nPrcVen  := aCols[i][nP_PrcVen]
		
		If Empty(cProduto) //.OR. cProduto != EE8->EE8_COD_I
			cMsg := "Campo PRODUTO nao pode ser alterado"
			lRet := .F.
		Endif
		
		If nQtdVen == 0 .And. lRet //.or. nQtdVen != EE8->EE8_SLDINI
			cMsg := "Campo QUANTIDADE nao pode ser alterado"
			lRet := .F.
		Endif
		
		If nPrcVen == 0 .And. lRet
			cMsg := "Campo PRECO UNITARIO preenchimento obrigatorio"
			lRet := .F.
		Endif
		
		If !lRet
			Help("",1,"","EECMOD3TudOk",cMsg,1,0)
			Exit
		Endif
		
	Endif
	
Next i

oTotal:Refresh()

Return( lRet )

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | EEC_Cap_item()| AUTOR | Fernando Pereira  | DATA | 10/08/2013   |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - ModTudOk()                                             |//
//|           | Valiar se todas as linhas estao ok                              |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function EECMOD3TudOk()
Local lRet       := .T.
Local nP_Produto := 0
Local nP_QtdVen  := 0
Local nP_PrcVen  := 0
Local cMsg       := ""
Local cProduto   := 0
Local nQtdVen    := 0
Local nPrcVen    := 0
Local i    := 0


nP_QtdVen  := aScan(aHeader,{|x| Trim(x[2])=="EE8_SLDINI"})
nP_PrcVen  := aScan(aHeader,{|x| Trim(x[2])=="EE8_PRECO"})
nP_Produto := aScan(aHeader,{|x| Trim(x[2])=="EE8_COD_I"})

For i := 1 To Len(aCols)
	
	If aCols[i][nUsado+1]// .OR. Alltrim(aHeader[i][2]) $ "EE8_PRCFIX|EE8_QTDFIX|EE8_DESOPE"
		Loop
	Endif
	
	cProduto := aCols[i][nP_Produto]
	nQtdVen  := aCols[i][nP_QtdVen]
	nPrcVen  := aCols[i][nP_PrcVen]
	
	If Empty(cProduto) //.OR. cProduto != EE8->EE8_COD_I
		cMsg := "Campo PRODUTO nao pode ser alterado"
		lRet := .F.
	Endif
	
	If nQtdVen == 0 .And. lRet //.or. nQtdVen != EE8->EE8_SLDINI
		cMsg := "Campo QUANTIDADE nao pode ser alterado"
		lRet := .F.
	Endif
	
	If nPrcVen == 0 .And. lRet
		cMsg := "Campo PRECO UNITARIO preenchimento obrigatorio"
		lRet := .F.
	Endif
	
	If !lRet
		Help("",1,"","EECMOD3TudOk",cMsg,1,0)
		Exit
	Endif
	
Next i

Return( lRet )

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | EEC_Cap_item()| AUTOR | Fernando Pereira  | DATA | 10/08/2013   |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - EECMOD3Grava()                                         |//
//|           | Grava os dados nas variaveis M->??? e no vetor aGETS            |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function EECMOD3Grava(nOpc,aAltera)
Local lGravou  := .F.
Local nUsado   := 0
Local nSeq     := 1
Local nX       := 0
Local nI       := 0
Local xnI       := 0 
Private bCampo := { |nField| FieldName(nField) }

nUsado := Len(aHeader) + 1

//+-----------------
//| Se for alteracao
//+-----------------
If nOpc == 2
	************************************************************************************************************************************************
	//EE8->EE8_PRECO -  IIF(ALLTRIM(FUNNAME())=="EECAP100",AP100CRIT("EE8_PRECO").AND.POSITIVO().AND.EECVLEE8("EE8_PRECO").AND.AP104GATPRECO(),.T.)
	************************************************************************************************************************************************
	//+--------------------------------------
	//| Grava os itens conforme as alteracoes
	//+--------------------------------------
	dbSelectArea(cAlias2)
	dbSetOrder(1)
	For nX := 1 To Len(aCols)
		
		If nX <= Len(aAltera)
			dbGoto(aAltera[nX])
			RecLock(cAlias2,.F.)
			If aCols[nX][nUsado]
				//dbDelete()
				//EECMOD3X2Del(cAlias2)
			EndIf
		Else
			If !aCols[nX][nUsado]
				//RecLock(cAlias2,.T.)
			Endif
		Endif
		
		If !aCols[nX][nUsado]
			For nI := 1 To Len(aHeader)
				If Alltrim(aHeader[nI][2]) $ "EE8_PRECO"
					FieldPut(FieldPos(Trim(aHeader[nI,2])),aCols[nX,nI])
				Endif
			Next nI
			
			EE8_PRECOI := EE8->EE8_PRECO
			EE8_PRCTOT := EE8->EE8_PRECO * EE8->EE8_SLDINI
			EE8_PRCINC := EE8->EE8_PRECO * EE8->EE8_SLDINI
			EE8_PRCUN  := EE8->EE8_PRECO
			
			MsUnLock()
			nSeq ++
			lGravou := .T.
		EndIf
	Next nX
	
	If lGravou
		
		cPvenda     := EE7->EE7_PEDFAT
		cOldArea := GetArea()
		
		SC6->(DbSelectArea("SC6"))
		SC6->(DbSetOrder(1))
		
		For xnI := 1 To Len(aCols)
			
			cSeq := StrZero(Val(aCols[xnI,2]),2)
			cProd:= aCols[xnI,3]
			
			If SC6->(DbSeek(xFilial("SC6")+cPvenda+cSeq+cProd))
				
				SC6->(Reclock("SC6"),.f.)
				SC6->C6_PRCVEN := aCols[xnI,29]
				SC6->C6_VALOR  := aCols[xnI,29] * SC6->C6_QTDVEN
				SC6->C6_PRUNIT := aCols[xnI,29]
				SC6->(MsUnlock())
				
			Endif
			
		Next xnI
		
		RestArea(cOldArea)
		
	Endif
	
Endif

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | EEC_Cap_item()| AUTOR | Fernando Pereira  | DATA | 10/08/2013   |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - EECMOD3X2Del()                                         |//
//|           | Incrementa valores no X3_DELET                                  |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function EECMOD3X2Del(cFilSX2)
Local aArea := GetArea()
dbSelectArea("SX2")
dbSetOrder(1)
If dbSeek(cFilSX2)
	/* Removido 11/05/23 - Não executa Recklock na X2
	RecLock("SX2",.F.)
	SX2->X2_DELET := SX2->X2_DELET + 1
	MsUnLock()
	*/
Endif
RestArea( aArea )
Return

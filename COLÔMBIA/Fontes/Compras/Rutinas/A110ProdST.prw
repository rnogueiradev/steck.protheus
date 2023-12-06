
#include "totvs.ch"
/*/ validador en la SX3 que fue sustiuitdo en X3_valid
A093Prod().And.A110Produto() .And. MTPVLSOLPD()
ANTES: 		A093Prod() .And. A110Produto()   .And. MTPVLSOLPD()                                                                                 
DESPUES: 	A093Prod() .And. u_A110ProdSt()  .And. MTPVLSOLPD()
NOTA: Axel Diaz

Se sustituyo la rutina standard A110Producto en  X3_CAMPO=C1_PRODUTO, X3_VALID
por A093Prod() .And. u_A110ProdSt()  .And. MTPVLSOLPD() para quitar la validacion
de B1_IMPORT

������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �A110Produt� Autor � Eduardo Riera         � Data �28.07.2000 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de avaliacao do codigo do produto da solicitacao de   ���
���          �compra                                                       ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Codigo do produto                                     ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo nao permitir a duplicacao do   ���
���          �numero da solicitacao de compra                              ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Materiais                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
user Function A110ProdSt(cProduto)
Local aArea		:= GetArea()
Local nX        := 0
Local nPLoja	:= 0
Local cDescri	:= ""
Local lRetorno  := .T.
Local nPos:=0
Local lVldContrato:= .T.

Local aDadosCfo     := {}
Local aCTBEnt		:= CTBEntArr()

Local lContinua		:= .T.
Local lReferencia	:= .F.
Local lDescSubst	:= .F.
Local lGrade		:= MaGrade()

Local nLoop         := Nil
Local nPProduto		:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_PRODUTO"})
Local nPGrade		:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_GRADE"})
Local nPItemGrd 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_ITEMGRD"})
Local nPItem		:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_ITEM"})
Local nPQtdVen		:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_QUANT"})

Local cProdRef	  := ""
Local cCliTab     := ""
Local cLojaTab    := ""
Local cCodUser    := RetCodUsr()

Local cQry:=""
Local cCtrVal:= .T.

DEFAULT cProduto  := &(ReadVar())

//�������������������������������������������������Ŀ
//�Verifica se o usuario tem permissao de inclusao. �
//���������������������������������������������������
If Inclui
	
		lRetorno := MaAvalPerm(1,{M->C1_PRODUTO,"MTA110",3})
		If !lRetorno
			Help(,,1,'SEMPERM')
		EndIf
	
EndIf
	
lGatilha := If(ValType(lGatilha) == "L",lGatilha,.T.) // .T.=Permite preencher aCols /  .F.=Executando via VldHead() 



If l110Auto
   If n <= Len(aAutoItens)
	   nPos := aScan(aAutoItens[n],{|x| AllTrim(x[1]) == "AUTVLDCONT"})
	   If nPos > 0
    	  If aAutoItens[n,nPos,2] == "N"
        	 lVldContrato:= .f.
			EndIf
		EndIf
	EndIf
EndIf

cProdRef := cProduto
//������������������������������������������������������������������������Ŀ
//�VerIfica se a grade esta ativa e se o produto digitado eh uma referencia�
//��������������������������������������������������������������������������

If lGrade

	If cProdRef == GdFieldGet("C1_PRODUTO") // Nao alterei o produto
		Return(.T.)
	EndIf	

	lReferencia := MatGrdPrrf(@cProdRef)
	
	If lGatilha
		aCols[n][nPQtdVen]:= 0
		//������������������������������������������������������Ŀ
		//� Monta o AcolsGrade e o AheadGrade para este item     �
		//��������������������������������������������������������
	
	 	oGrade:MontaGrade(n,cProdRef,.T.,,lReferencia,.T.)
	
		If ( lReferencia )
			If ( nPGrade > 0 )
				aCols[n][nPGrade] := "S"
				lReferencia := .T.
			EndIf
		Else
			If ( nPGrade > 0 )
			 	oGrade:MontaGrade(n,cProdRef,.T.,,lReferencia)
				If aCols[n][nPGrade] == "S"
					For nLoop := 1 to Len(aHeader)
						If X3Obrigat(aHeader[nLoop, 2]) .Or. AllTrim(aHeader[nLoop, 2]) $ "C1_QUANT, C1_QTSEGUM, C1_GRADE"
							If ! AllTrim(aHeader[nLoop, 2]) $ "C1_ITEM, C1_PRODUTO, C1_DATPRF"
								aCols[n,nLoop] := CriaVar(aHeader[nLoop, 2] , .F.)
							EndIf
						EndIf
					Next
					aCols[n][nPProduto] := Pad(cProdRef, Len(SB1->B1_COD))
					aCols[n][nPGrade]   := "N"
					aCols[n][nPItemGrd] := Space(Len(aCols[n][nPItemGrd]))
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
dbSelectArea("SB1")
dbSetOrder(1)
MsSeek(xFilial("SB1")+cProdRef,.F.)
If lGatilha 
	cDescri := IIf( lReferencia , oGrade:GetDescProd(cProdRef), SB1->B1_DESC )
EndIf

If SB1->B1_CONTRAT == "S" 

cQry:= "SELECT COUNT(*) QTDSC3 FROM "+RetSqlName("SC3")+" SC3 "
cQry+= "WHERE SC3.D_E_L_E_T_<>'*'"
cQry+= "AND C3_PRODUTO = '"+Alltrim(M->C1_PRODUTO)+"' "
cQry+= "AND C3_QUANT > C3_QUJE"

cAliasQry  := GetNextAlias()
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasQry,.F.,.T.)

	If (cAliasQry)->QTDSC3 > 0
		cCtrVal:= .T.
	Else 
		cCtrVal:= .F.
	EndIf 

EndIf

Do Case
	Case SB1->(Eof()) .And. !lReferencia
		lRetorno := .F.
		Help(" ",1,"C1_PRODUTO")
	Case SB1->B1_CONTRAT == "S" .and. lVldContrato .And. !lReferencia 
	If cCtrVal
		lRetorno := .F.
		Help(" ",1,"A110CONTR")
	Else
	lRetorno:= .T.
	EndIf
	Case !A110Valid("P")
		lRetorno := .F.
	Case SB1->B1_SOLICIT =="S" .And. GetMv("MV_RESTSOL")=="S" .And. !A110Restr(cProduto,UsrRetGrp(,cCodUser),cCodUser) .And. !lReferencia
		lRetorno := .F.
EndCase
If lRetorno
	//����������������������������������Ŀ
	//� Posiciona no produto selecionado �
	//������������������������������������
	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek(xFilial("SB1")+cProdRef,.F.)
EndIf
//���������������������������������������Ŀ
//� VerIfica se o Registro esta Bloqueado.�
//�����������������������������������������
If lRetorno .And. !RegistroOk("SB1")
	lRetorno := .F.
EndIf

If lRetorno .And. lGatilha
	If ( Alltrim(mv_par01) == "B5_CEME" )
		dbSelectArea("SB5")
		dbSetOrder(1)
		If MsSeek(xFilial("SB5") + cProduto )
			cDescri := SB5->B5_CEME
		EndIf
	EndIf
	cDescri := PadR(cDescri,Len(SC1->C1_DESCRI))
	//��������������������������������������������������������������Ŀ
	//�Atualiza os campos vinculados ao produto                      �
	//����������������������������������������������������������������
	For nX := 1 To Len(aHeader)
		Do Case
			Case Trim(aHeader[nX][2]) == "C1_FORNECE"
				If ( SB1->B1_MONO=="S" )
					nPLoja := aScan(aHeader,{|x| Alltrim(x[2])=="C1_LOJA"})
					If ( nPLoja > 0 )
						aCols[n][nX] 		:= SB1->B1_PROC
						aCols[n][nPLoja]	:= SB1->B1_LOJPROC
					EndIf
				EndIf
			Case Trim(aHeader[nX][2]) == "C1_UM"			// Unidade Medida
				If !lReferencia
					aCols[n][nX] := SB1->B1_UM
				Else
					If MatOrigGrd() == "SBQ"
						aCols[n][nX] := SBR->BR_UM
					ElseIf MatOrigGrd() == "SB4"
						aCols[n][nX] := SB4->B4_UM
					EndIf
				EndIf
			Case Trim(aHeader[nX][2]) == "C1_SEGUM"		// Segunda Unidade Medida
				If !lReferencia
					aCols[n][nX] := SB1->B1_SEGUM
				Else
					If MatOrigGrd() == "SB4"
						aCols[n][nX] := SB4->B4_SEGUM
					EndIf
				EndIf
				dbSelectArea("SF1")
				a100SegUm()
			Case Trim(aHeader[nX][2]) == "C1_LOCAL"		// AlmoxarIfado
				If !lReferencia
					aCols[n][nX] := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
				Else
					If MatOrigGrd() == "SBQ"
						aCols[n][nX] := SBR->BR_LOCPAD
					ElseIf MatOrigGrd() == "SB4"
						aCols[n][nX] := SB4->B4_LOCPAD
					EndIf
				EndIf
			Case Trim(aHeader[nX][2]) == "C1_CC" .And. !lReferencia			// Centro Custo
				aCols[n][nX] := SB1->B1_CC
			Case Trim(aHeader[nX][2]) == "C1_CONTA" .And. !lReferencia		// Conta Contabil
				aCols[n][nX] := SB1->B1_CONTA
			Case Trim(aHeader[nX][2]) == "C1_DESCRI"							// Descricao
				aCols[n][nX] := cDescri
			Case Trim(aHeader[nX][2]) == "C1_IMPORT" .And. !lReferencia		// Produto Importado
				aCols[n][nX] := SB1->B1_IMPORT
			Case Trim(aHeader[nX][2]) == "C1_ITEMCTA" .And. !lReferencia		// Item da conta contabil
				aCols[n][nX] := SB1->B1_ITEMCC
			Case Trim(aHeader[nX][2]) == "C1_CLVL" .And. !lReferencia		    // Classe de valor
				aCols[n][nX] := SB1->B1_CLVL
		EndCase
	Next nX
	For nX := 1 To Len(aCTBEnt)
		If GDFieldPos("C1_EC"+aCTBEnt[nX]+"CR",aHeader) > 0 .And. SB1->(FieldPos("B1_EC"+aCTBEnt[nX]+"CR")) > 0
			aCols[n,GDFieldPos("C1_EC"+aCTBEnt[nX]+"CR")] := SB1->&("B1_EC"+aCTBEnt[nX]+"CR")
		EndIf
		If GDFieldPos("C1_EC"+aCTBEnt[nX]+"DB",aHeader) > 0 .And. SB1->(FieldPos("B1_EC"+aCTBEnt[nX]+"DB")) > 0
			aCols[n,GDFieldPos("C1_EC"+aCTBEnt[nX]+"DB")] := SB1->&("B1_EC"+aCTBEnt[nX]+"DB")
		EndIf
	Next nX
EndIf
cProduto := IIf(cProduto == Nil,&(ReadVar()),cProduto)
RestArea(aArea)
Return (lRetorno)

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �A110Valid �Rev.   � Eduardo Riera         � Data �28.07.2000 ���
��������������������������������������������������������������������������Ĵ��
���          �Rotina de validacao da quantidade da solicitacao de compra   ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: [P] para Produto                                      ���
���          �       [Q] Para quantidade                                   ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �ExpL1: Indica se a quantidade eh valida                      ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo efetuar a validacao da quantida���
���          �de informada na solicitacao de compras para nao permitir     ���
���          �que a quantidade da solicitacao de compra seja menor que a   ���
���          �quantidade em pedido.                                        ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Materiais                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function A110Valid(cTipo)

Local aArea     := GetArea()
Local cProduto	:= ""
Local nQuant	:= 0
Local nPProduto := aScan(aHeader,{|x| Trim(x[2])=="C1_PRODUTO"})
Local nPQuant   := aScan(aHeader,{|x| Trim(x[2])=="C1_QUANT"})
Local nPItem    := aScan(aHeader,{|x| Trim(x[2])=="C1_ITEM"})
Local lRetorno  := .T.
Local lMta113   := Alltrim(Upper(FunName()))=="MATA113"

If ( cTipo == "P" )
	cProduto := &(ReadVar())
	nQuant   := aCols[n][nPQuant]
Else
	cProduto := aCols[n][nPProduto]
	nQuant   := &(ReadVar())
EndIf
If ( Altera )
	dbSelectArea("SC1")
	dbSetOrder(2)
	If ( MsSeek(xFilial("SC1")+aCols[n][nPProduto]+cA110Num+aCols[n][nPItem]) )
		If ( SC1->C1_QUJE > nQuant )
			Help(" ",1,"A110MAIO")
			lRetorno := .F.
		Else
			lRetorno := MaCanAltSC("SC1")
		EndIf

	EndIf
EndIf
/*/
If lMta113 .And. cTipo == "P" 
	If SB1->B1_IMPORT <> "S" 
		Help(" ",1,"A113IMPORT")
		lRetorno := .F.
	Endif
Endif
/*/
Return(lRetorno)

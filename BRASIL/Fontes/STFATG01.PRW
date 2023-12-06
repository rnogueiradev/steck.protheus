#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ?STFATG01 ?Autor ?Donizeti Lopes         ?Data ?02/01/13 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ?Rotina para gravar o valor total do item no aCols.          ³±?
±±?         ?Esta rotina esta sendo chamada pelo ponto de entrada MTA410 ³±?
±±?         ?, na validacao do TudoOk do Pedido de Venda                 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros?                                                            ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ?STECK                                                       ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function STFATG01(lGrava)
      
Local aArea	:= GetArea()
Local aPedido := {}
Local nPos := 0
Local nCnt := 0

Local nPosItem 		:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_ITEM"})			// Posicao dO Item
//Local nPosVlrImp 	:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_ZVALIMP"})
Local nPosVlrImp 	:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_ZVALICM"})			// Posicao do Valor do ICMS
Local nPosVlrIpi 	:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_ZVALIPI"})			// Posicao do Valor do IPI
Local nPValICMSST	:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_ZVALIST"})			// Posicao do Valor do ICMS ST
Local nPAliqICM 	:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_ZPICMS"})			// Posicao do Aliq. ICMS
Local nPQuant		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_QTDVEN"})			// Posicao da Quantidade
Local nPTotal       := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPValLiq		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_ZVALLIQ"})			// Posicao do Valor do Liquido	 

Local aRet 		:= {}
Local aRefFis 	:= {}
Local aImpostos := {"IT_VALICM","IT_VALIPI","IT_VALSOL","IT_ALIQICM","IT_VALMERC","IT_VALPS2","IT_VALCF2","IT_DESCONTO"}
Local nCnt1 	:= 0
Local nValIcms  := nValor := 0   
Local _lRnCnt := .T. 

Local _nTotPed 	:= 0

If ( Type("l410Auto") == "U" .OR. !l410Auto )
If Inclui .or. Altera
	aRet := U_A001Impos(,"IT_TOTAL",aImpostos)
	If !Empty(aRet[1])
		aPedido := aRet[1]
	Endif
	If !Empty(aRet[2])
		aRefFis := aRet[2]
	Endif

	If ValType(aPedido)=="A" .and. Len(aPedido) > 0 .and. lGrava
		For nCnt := 1 To Len(aCols)
			If !aCols[nCnt][Len(aCols[nCnt])]
				// grava valor total do item com impostos
				nPos := aScan(aPedido,{|x| x[1]=aCols[nCnt][nPosItem]})
				If nPos > 0
					aCols[nCnt][nPosVlrImp] := ROUND(aPedido[nPos][2],2)
				Endif

				nQuant 	:= aCols[nCnt][nPQuant]
				nValICMS:= 0
				nValor	:= 0
				nValor2	:= 0
				
				For nCnt1 := 1 To Len(aImpostos)
					// grava impostos armazenados no array areffis
					nPos := aScan(aRefFis,{|x| x[2]=aCols[nCnt][nPosItem] .and. x[1]=aImpostos[nCnt1]})

					If nPos > 0 
						If nCnt1 = 1 	// icms
							aCols[nCnt][nPosVlrImp] 	:= round(aRefFis[nPos][3] / nQuant,2)
							nValICMS  :=               noround(aRefFis[nPos][3] / nQuant)
						Elseif nCnt1 = 2 // ipi
							aCols[nCnt][nPosVlrIpi] 	:= noround(aRefFis[nPos][3] / nQuant)
						Elseif nCnt1 = 3 // ICMS ST
							aCols[nCnt][nPValICMSST] 	:= noround(aRefFis[nPos][3] / nQuant)
						Elseif nCnt1 = 4 // ALIQUOTA ICMS
							aCols[nCnt][nPAliqICM] 		:= aRefFis[nPos][3]
					   
						
						Elseif nCnt1 = 5 // VALOR LIQUIDO
							aCols[nCnt][nPValLiq] 		:= noround(aRefFis[nPos][3] - nValIcms)
						Elseif nCnt1 = 6 // VALOR LIQUIDO - PIS 2
							aCols[nCnt][nPValLiq] 		:= noround(aCols[nCnt][nPValLiq] - aRefFis[nPos][3])
						Elseif nCnt1 = 7 // VALOR LIQUIDO - COFINS 2
							nValor := noround(aCols[nCnt][nPValLiq] - aRefFis[nPos][3])
						   /*	nValor2:= noround(nValor,2)
							IIf (nValor-nValor2 >= 0.01,nValor -= 0.01,)*/
							aCols[nCnt][nPValLiq] := noround(nValor)       
						Elseif nCnt1 = 8 // VALOR LIQUIDO = VALOR MERC. - DESCONTO
							aCols[nCnt][nPValLiq] := noround(aCols[nCnt][nPValLiq] - aRefFis[nPos][3])
						Endif                                						
					
					Endif
				Next	
			Endif
		Next nCnt
	Endif			
	
//	M->C5_ZVALLIQ:= aRefFis[aScan(aRefFis,{|x| Alltrim(x[1]) = "NF_VALMERC"})][2]  



Endif	
_lRnCnt:=.f.
Endif
RestArea(aArea) 

Return(_lRnCnt)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MA410Impos?Autor ?Eduardo Riera         ?Data ?6.12.2001 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±?         ³Ma410Impos( nOpc)                                            ³±?
±±?         ³Funcao de calculo dos impostos contidos no pedido de venda   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros?nOpc                                                        ³±?
±±?         ?                                                            ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±?
±±?         ?                                                            ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta funcao efetua os calculos de impostos (ICMS,IPI,ISS,etc)³±?
±±?         ³com base nas funcoes fiscais, a fim de possibilitar ao usua- ³±?
±±?         ³rio o valor de desembolso financeiro.                        ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ?STECK                                                       ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteração ?09/01/2003 - Donizeti Lopes - Contemplar os Impostos PIS,   ³±?
±±?         ?Cofins e Valor Liquido (VAL. MERC - (PIS + COFINS))         ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A001Impos(nLinha,cRefFis,aRefFis) //Ma410Impos( nOpc )

Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local aFisGet	:= {}
Local aFisGetSC5:= {}
Local aDupl     := {}
Local aVencto   := {}
Local aEntr     := {}
Local aDuplTmp  := {}
Local aRentab   := {}
Local nPLocal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
Local nPTotal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPValDesc := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_XPRCLIS"})
Local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPDtEntr  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTRE1"})
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPTES     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local nPNfOri   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NFORI"})
Local nPSerOri  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_SERIORI"})
Local nPItemOri := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMORI"})
Local nPIdentB6 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_IDENTB6"})
Local nPItem    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
Local nPProvEnt := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PROVENT"})
Local nPosCfo	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})
Local nPSuframa := 0
Local nUsado    := Len(aHeader)
Local nX        := 0
Local nX1       := 0
Local nAcerto   := 0
Local nPrcLista := 0
Local nValMerc  := 0
Local nValPS2   := 0
Local nValCF2   := 0
Local nDesconto := 0
Local nAcresFin := 0	// Valor do acrescimo financeiro do total do item
Local nQtdPeso  := 0
Local nRecOri   := 0
Local nPosEntr  := 0
Local nItem     := 0
Local nY        := 0 
Local nPosCpo   := 0
Local nPropLot  := 0
Local lDtEmi    := SuperGetMv("MV_DPDTEMI",.F.,.T.)
Local dDataCnd  := M->C5_EMISSAO
Local oDlg
Local oDupl
Local oFolder
Local oRentab
Local lCondVenda := .F. // Template GEM
Local aRentabil := {}
Local cProduto  := ""
Local nTotDesc  := 0
Local lSaldo    := .F. //MV_PAR04 == 1 .And. !INCLUI
Local nQtdEnt   := 0
Local lM410Ipi	:= ExistBlock("M410IPI")
Local lM410Icm	:= ExistBlock("M410ICM")
Local lM410Soli	:= ExistBlock("M410SOLI")
Local lUsaVenc  := .F.
Local lIVAAju   := .F.
Local lRastro	 := ExistBlock("MAFISRASTRO")
Local lRastroLot := .F.
Local aSolid	:= {}
Local nLancAp	:=	0
Local aHeadCDA		:=	{}
Local aColsCDA		:=	{}
Local aTransp	:= {"",""}
Local aSaldos	:= {}
Local aInfLote	:= {}
Local aNfOri	:= {}
Local nAcresUnit:= 0	// Valor do acrescimo financeiro do valor unitario
Local nAcresTot := 0	// Somatoria dos Valores dos acrescimos financeiros dos itens
Local dIni		:= Ctod("//") 
Local cEstado	:= SuperGetMv("MV_ESTADO") 
Local cTesVend  := SuperGetMv("MV_TESVEND",,"")
Local cCliPed   := "" 
Local lCfo      := .F.
Local nlValor	:= 0
Local nValRetImp := 0
Local cImpRet 	 := ""
Local xValorRet
Local nCount := 0 // contador para retorno da referencia fiscal
Local a410Preco := {}  // Retorno da Project Function P_410PRECO com os novos valores das variaveis {nValMerc,nPrcLista}
Local xValorRet2


PRIVATE oLancApICMS
PRIVATE _nTotOper_ := 0		//total de operacoes (vendas) realizadas com um cliente - calculo de IB - Argentina
Private _aValItem_ := {}

Default nLinha := 0
Default cRefFis := ""
Default aRefFis := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Busca referencias no SC6                     ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
aFisGet	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC6")
While !Eof().And.X3_ARQUIVO=="SC6"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGet,,,{|x,y| x[3]<y[3]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Busca referencias no SC5                     ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
aFisGetSC5	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC5")
While !Eof().And.X3_ARQUIVO=="SC5"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})

SA4->(dbSetOrder(1))
If SA4->(dbSeek(xFilial("SA4")+M->C5_TRANSP)) 
	aTransp[01] := SA4->A4_EST
	aTransp[02] := Iif(SA4->(FieldPos("A4_TPTRANS")) > 0,SA4->A4_TPTRANS,"")
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Inicializa a funcao fiscal                   ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ? 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³A Consultoria Tributária, por meio da Resposta ?Consulta n?268/2004, determinou a aplicação das seguintes alíquotas nas Notas Fiscais de venda emitidas pelo vendedor remetente:                                                                         ?
//?) no caso previsto na letra "a" (venda para SP e entrega no PR) - aplicação da alíquota interna do Estado de São Paulo, visto que a operação entre o vendedor remetente e o adquirente originário ?interna;                                              ?
//?) no caso previsto na letra "b" (venda para o DF e entrega no PR) - aplicação da alíquota interestadual prevista para as operações com o Paran? ou seja, 12%, visto que a circulação da mercadoria se d?entre os Estado de São Paulo e do Paran?       ?
//?) no caso previsto na letra "c" (venda para o RS e entrega no SP) - aplicação da alíquota interna do Estado de São Paulo, uma vez que se considera interna a operação, quando não se comprovar a saída da mercadoria do território do Estado de São Paulo,?
//?conforme previsto no art. 36, ?4?do RICMS/SP                                                                                                                                                                                                            ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
If len(aCols) > 0
	If cEstado == 'SP'
		If !Empty(M->C5_CLIENT) .And. M->C5_CLIENT <> M->C5_CLIENTE
			For nX := 1 To Len(aCols)
		   		If Alltrim(aCols[nX][nPTES])$ Alltrim(cTesVend)
		 			lCfo:= .T.
		 		EndIf
		   	Next		   	
		   	If lCfo		
				dbSelectArea(IIF(M->C5_TIPO$"DB","SA2","SA1"))
				dbSetOrder(1)           
				MsSeek(xFilial()+M->C5_CLIENTE+M->C5_LOJAENT)
				If Iif(M->C5_TIPO$"DB", SA2->A2_EST,SA1->A1_EST) == 'SP'
					cCliPed := M->C5_CLIENTE
				Else
					cCliPed := M->C5_CLIENT
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

MaFisSave()
MaFisEnd()
MaFisIni(IIf(!Empty(cCliPed),cCliPed,Iif(Empty(M->C5_CLIENT),M->C5_CLIENTE,M->C5_CLIENT)),;// 1-Codigo Cliente/Fornecedor
	M->C5_LOJAENT,;					// 2-Loja do Cliente/Fornecedor
	IIf(M->C5_TIPO$'DB',"F","C"),;	// 3-C:Cliente , F:Fornecedor
	M->C5_TIPO,;					// 4-Tipo da NF
	M->C5_TIPOCLI,;					// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461",;
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	aTransp)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Realiza alteracoes de referencias do SC5         ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
If Len(aFisGetSC5) > 0
	dbSelectArea("SC5")
	For nY := 1 to Len(aFisGetSC5)
		If !Empty(&("M->"+Alltrim(aFisGetSC5[ny][2])))
			MaFisAlt(aFisGetSC5[ny][1],&("M->"+Alltrim(aFisGetSC5[ny][2])),,.F.)
		EndIf
	Next nY
Endif

//Na argentina o calculo de impostos depende da serie.
If cPaisLoc == 'ARG'
	SA1->(DbSetOrder(1))
	SA1->(MsSeek(xFilial()+IIf(!Empty(M->C5_CLIENT),M->C5_CLIENT,M->C5_CLIENTE)+M->C5_LOJAENT))
	MaFisAlt('NF_SERIENF',LocXTipSer('SA1',MVNOTAFIS))
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
	?Tratamento de IB para monotributistas - Argentina           ?
	?AGIP 177/2009                                               ?
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	If SA1->A1_TIPO == "M"
		dIni := (dDatabase + 1) - 365
		_nTotOper_ := RetTotOper(SA1->A1_COD,SA1->A1_LOJA,"C",dIni,dDatabase,1)
	Endif
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Agrega os itens para a funcao fiscal         ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
If nPTotal > 0 .And. nPValDesc > 0 .And. nPPrUnit > 0 .And. nPProduto > 0 .And. nPQtdVen > 0 .And. nPTes > 0
	For nX := 1 To Len(aCols)
		nQtdPeso := 0
		If Len(aCols[nX])==nUsado .Or. !aCols[nX][nUsado+1]
			nItem++
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			?Tratamento de IB para monotributistas - Argentina           ?
			?AGIP 177/2009                                               ?
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
			If cPaisLoc == "ARG"
				If SA1->A1_TIPO == "M"
					Aadd(_aValItem_,{nItem,.F.,xmoeda(aCols[nX][nPPrcVen],SC5->C5_MOEDA ,1,)})
				Endif
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			//³Posiciona Registros                          ?
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			If lSaldo .And. nPItem > 0
				dbSelectArea("SC6")
				dbSetOrder(1)
				MsSeek(xFilial("SC6")+M->C5_NUM+aCols[nX][nPItem]+aCols[nX][nPProduto])
				nQtdEnt := IIf(!SubStr(SC6->C6_BLQ,1,1)$"RS" .And. Empty(SC6->C6_BLOQUEI),SC6->C6_QTDENT,SC6->C6_QTDVEN)
			Else
				lSaldo := .F.
			EndIf
			
			cProduto := aCols[nX][nPProduto]
			MatGrdPrRf(@cProduto)
			SB1->(dbSetOrder(1))
			If SB1->(MsSeek(xFilial("SB1")+cProduto))
				nQtdPeso := If(lSaldo,aCols[nX][nPQtdVen]-nQtdEnt,aCols[nX][nPQtdVen])*SB1->B1_PESO
			EndIf
        	If nPIdentB6 <> 0 .And. !Empty(aCols[nX][nPIdentB6])
				SD1->(dbSetOrder(4))
				If SD1->(MSSeek(xFilial("SD1")+aCols[nX][nPIdentB6]))
					nRecOri := SD1->(Recno())
				EndIf
        	ElseIf nPNfOri > 0 .And. nPSerOri > 0 .And. nPItemOri > 0
				If !Empty(aCols[nX][nPNfOri]) .And. !Empty(aCols[nX][nPItemOri])
					SD1->(dbSetOrder(1))
					If SD1->(MSSeek(xFilial("SD1")+aCols[nX][nPNfOri]+aCols[nX][nPSerOri]+M->C5_CLIENTE+M->C5_LOJACLI+aCols[nX][nPProduto]+aCols[nX][nPItemOri]))
						nRecOri := SD1->(Recno())
					EndIf
				EndIf
			EndIf
            SB2->(dbSetOrder(1))
            SB2->(MsSeek(xFilial("SB2")+SB1->B1_COD+aCols[nX][nPLocal]))
            SF4->(dbSetOrder(1))
            SF4->(MsSeek(xFilial("SF4")+aCols[nX][nPTES]))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			//³Calcula o preco de lista                     ?
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			nValMerc  := If(aCols[nX][nPQtdVen]==0,aCols[nX][nPTotal],If(lSaldo,(aCols[nX][nPQtdVen]-nQtdEnt)*aCols[nX][nPPrcVen],aCols[nX][nPTotal]))
			nPrcLista := aCols[nX][nPPrUnit]
			If ( nPrcLista == 0 )
				nValMerc  := If(aCols[nX][nPQtdVen]==0,aCols[nX][nPTotal],If(lSaldo,(aCols[nX][nPQtdVen]-nQtdEnt)*aCols[nX][nPPrcVen],aCols[nX][nPTotal]))
			EndIf
			nAcresUnit:= A410Arred(aCols[nX][nPPrcVen]*M->C5_ACRSFIN/100,"D2_PRCVEN")
			nAcresFin := A410Arred(If(lSaldo,aCols[nX][nPQtdVen]-nQtdEnt,aCols[nX][nPQtdVen])*nAcresUnit,"D2_TOTAL")
			nAcresTot += nAcresFin
			nValMerc  += nAcresFin
			nDesconto := a410Arred(nPrcLista*If(lSaldo,aCols[nX][nPQtdVen]-nQtdEnt,aCols[nX][nPQtdVen]),"D2_DESCON")-nValMerc
			nDesconto := IIf(nDesconto<=0,aCols[nX][nPValDesc],nDesconto)
			nDesconto := Max(0,nDesconto)
			nPrcLista += nAcresUnit
			//Para os outros paises, este tratamento e feito no programas que calculam os impostos.
			If cPaisLoc=="BRA"
				nValMerc  += nDesconto
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			//³Verifica a data de entrega para as duplicatas?
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			If ( nPDtEntr > 0 )
				If ( dDataCnd > aCols[nX][nPDtEntr] .And. !Empty(aCols[nX][nPDtEntr]) )
					dDataCnd := aCols[nX][nPDtEntr]
				EndIf
			Else
				dDataCnd  := M->C5_EMISSAO
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			//³Tratamento do IVA Ajustado                   ?
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?		
			SB1->(dbSetOrder(1))
			If SB1->(MsSeek(xFilial("SB1")+cProduto))
               lIVAAju := IIF(SB1->(FieldPos("B1_IVAAJU")) > 0 .And. SB1->B1_IVAAJU == '1' .And. (IIF(lRastro,lRastroLot := ExecBlock("MAFISRASTRO",.F.,.F.),Rastro(cProduto,"S"))),.T.,.F.)			   
			EndIf
			dbSelectArea("SC6")
			dbSetOrder(1)
			MsSeek(xFilial("SC6")+M->C5_NUM)
			If lIVAAju
				dbSelectArea("SC9")
				dbSetOrder(1)
				If MsSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
					If ( SC9->C9_BLCRED $ "  10"  .And. SC9->C9_BLEST $ "  10")
						While ( !Eof() .And. SC9->C9_FILIAL == xFilial("SC9") .And.;
								SC9->C9_PEDIDO == SC6->C6_NUM .And.;
								SC9->C9_ITEM   == SC6->C6_ITEM )
				
							aadd(aSaldos,{SC9->C9_LOTECTL,SC9->C9_NUMLOTE,,,SC9->C9_QTDLIB})	
		
							dbSelectArea("SC9")
							dbSkip()
						EndDo
					Else
						dbSelectArea("SC6")
						dbSetOrder(1)
						MsSeek(xFilial("SC6")+M->C5_NUM)
						lUsaVenc:= If(!Empty(SC6->C6_LOTECTL+SC6->C6_NUMLOTE),.T.,(SuperGetMv('MV_LOTVENC')=='S'))
						aSaldos := SldPorLote(aCols[nX][nPProduto],aCols[nX][nPLocal],aCols[nX][nPQtdVen]/* nQtdLib*/,0/*nQtdLib2*/,SC6->C6_LOTECTL,SC6->C6_NUMLOTE,SC6->C6_LOCALIZ,SC6->C6_NUMSERI,NIL,NIL,NIL,lUsaVenc,nil,nil,dDataBase)					
					EndIf
				Else
					dbSelectArea("SC6")
					dbSetOrder(1)
					MsSeek(xFilial("SC6")+M->C5_NUM)
					lUsaVenc:= If(!Empty(SC6->C6_LOTECTL+SC6->C6_NUMLOTE),.T.,(SuperGetMv('MV_LOTVENC')=='S'))
					aSaldos := SldPorLote(aCols[nX][nPProduto],aCols[nX][nPLocal],aCols[nX][nPQtdVen]/* nQtdLib*/,0/*nQtdLib2*/,SC6->C6_LOTECTL,SC6->C6_NUMLOTE,SC6->C6_LOCALIZ,SC6->C6_NUMSERI,NIL,NIL,NIL,lUsaVenc,nil,nil,dDataBase)									
				EndIf
				For nX1 := 1 to Len(aSaldos)
					nPropLot := aSaldos[nX1][5]
					If lRastroLot
						dbSelectArea("SB8")
						dbSetOrder(5)
						If MsSeek(xFilial("SB8")+cProduto+aSaldos[nX][01])
							aadd(aInfLote,{SB8->B8_DOC,SB8->B8_SERIE,SB8->B8_CLIFOR,SB8->B8_LOJA,nPropLot})
						EndIf		
					Else				
						dbSelectArea("SB8")
						dbSetOrder(2)
						If MsSeek(xFilial("SB8")+aSaldos[nX][02]+aSaldos[nX][01])
							aadd(aInfLote,{SB8->B8_DOC,SB8->B8_SERIE,SB8->B8_CLIFOR,SB8->B8_LOJA,nPropLot})
						EndIf
					EndIf
					dbSelectArea("SF3")
					dbSetOrder(4)
					If !Empty(aInfLote)
						If MsSeek(xFilial("SF3")+aInfLote[nX1][03]+aInfLote[nX1][04]+aInfLote[nX1][01]+aInfLote[nX1][02])
							aadd(aNfOri,{SF3->F3_ESTADO,SF3->F3_ALIQICM,aInfLote[nX1][05],0})
						EndIf
					EndIf
				Next nX1
			EndIf						
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			//³Agrega os itens para a funcao fiscal         ?
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			MaFisAdd(cProduto,;   	// 1-Codigo do Produto ( Obrigatorio )
				aCols[nX][nPTES],;	   	// 2-Codigo do TES ( Opcional )
				If(lSaldo,aCols[nX][nPQtdVen]-nQtdEnt,aCols[nX][nPQtdVen]),;  	// 3-Quantidade ( Obrigatorio )
				nPrcLista,;		  	// 4-Preco Unitario ( Obrigatorio )
				nDesconto,; 	// 5-Valor do Desconto ( Opcional )
				"",;	   			// 6-Numero da NF Original ( Devolucao/Benef )
				"",;				// 7-Serie da NF Original ( Devolucao/Benef )
				nRecOri,;					// 8-RecNo da NF Original no arq SD1/SD2
				0,;					// 9-Valor do Frete do Item ( Opcional )
				0,;					// 10-Valor da Despesa do item ( Opcional )
				0,;					// 11-Valor do Seguro do item ( Opcional )
				0,;					// 12-Valor do Frete Autonomo ( Opcional )
				nValMerc,;			// 13-Valor da Mercadoria ( Obrigatorio )
				0,;					// 14-Valor da Embalagem ( Opiconal )	
				,;					// 15
				,;					// 16
				Iif(nPItem>0,aCols[nX,nPItem],""),; //17
				0,;					// 18-Despesas nao tributadas - Portugal
				0,;					// 19-Tara - Portugal
				aCols[nX,nPosCfo])	// 20-CFO 

			If FindFunction("P_410PRECO")
				a410Preco := P_410PRECO( nX , nValMerc , nPrcLista )
				If Valtype(a410Preco) == "A"
					nValMerc  := a410Preco[1]
					nPrcLista := a410Preco[2]
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			//³Tratamento do IVA Ajustado                   ?
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			If lIVAAju
				For nX1 := 1 To Len(aNfOri)
					MaFisAddIT("IT_ANFORI2",{aNfOri[nX1][__UFORI],aNfOri[nX1][__ALQORI],aNfOri[nX1][__PROPOR],0},nItem,nX1==1)
				Next nX1			
				aSaldos :={}
				aNfOri  :={}
			EndIf				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			//³Provincia de entrega - Ingresos Brutos       ?
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			If cPaisLoc == "ARG"
				If nPProvEnt > 0
					MaFisAlt("IT_PROVENT",aCols[nX,nPProVent],nItem)
				Endif
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			//³Calculo do ISS                               ?
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			SF4->(dbSetOrder(1))
			SF4->(MsSeek(xFilial("SF4")+aCols[nX][nPTES]))
			If ( M->C5_INCISS == "N" .And. M->C5_TIPO == "N")
				If ( SF4->F4_ISS=="S" )
					nPrcLista := a410Arred(nPrcLista/(1-(MaAliqISS(nItem)/100)),"D2_PRCVEN")
					nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(nItem)/100)),"D2_PRCVEN")
					MaFisAlt("IT_PRCUNI",nPrcLista,nItem)
					MaFisAlt("IT_VALMERC",nValMerc,nItem)
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			//³Altera peso para calcular frete              ?
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			MaFisAlt("IT_PESO",nQtdPeso,nItem)
			MaFisAlt("IT_PRCUNI",nPrcLista,nItem)
			MaFisAlt("IT_VALMERC",nValMerc,nItem)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			//³Analise da Rentabilidade                     ?
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			If SF4->F4_DUPLIC=="S"
				nTotDesc += MaFisRet(nItem,"IT_DESCONTO")
				nY := aScan(aRentab,{|x| x[1] == aCols[nX][nPProduto]})
				If nY == 0
					aadd(aRenTab,{aCols[nX][nPProduto],0,0,0,0,0})
					nY := Len(aRenTab)
				EndIf
				If cPaisLoc=="BRA"
					aRentab[nY][2] += (nValMerc - nDesconto)
				Else
					aRentab[nY][2] += nValMerc
				Endif
				aRentab[nY][3] += If(lSaldo,aCols[nX][nPQtdVen]-nQtdEnt,aCols[nX][nPQtdVen])*SB2->B2_CM1
			Else
				If GetNewPar("MV_TPDPIND","1")=="1"
					nTotDesc += MaFisRet(nItem,"IT_DESCONTO")
				EndIf
			EndIf
		EndIf
	Next nX
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Indica os valores do cabecalho               ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ]
If ( ( cPaisLoc == "PER" .Or. cPaisLoc == "COL" ) .And. M->C5_TPFRETE == "F" ) .Or. ( cPaisLoc != "PER" .And. cPaisLoc != "COL" )
	MaFisAlt("NF_FRETE",M->C5_FRETE)
EndIf
MaFisAlt("NF_VLR_FRT",M->C5_VLR_FRT)
MaFisAlt("NF_SEGURO",M->C5_SEGURO)
MaFisAlt("NF_AUTONOMO",M->C5_FRETAUT)
MaFisAlt("NF_DESPESA",M->C5_DESPESA)                 
If cPaisLoc == "PTG"
	MaFisAlt("NF_DESNTRB",M->C5_DESNTRB)
	MaFisAlt("NF_TARA",M->C5_TARA)	
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Indenizacao por valor                        ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
If M->C5_DESCONT > 0
	MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,nTotDesc+M->C5_DESCONT),/*nItem*/,/*lNoCabec*/,/*nItemNao*/,GetNewPar("MV_TPDPIND","1")=="2" )
EndIf

If M->C5_PDESCAB > 0
	MaFisAlt("NF_DESCONTO",A410Arred(MaFisRet(,"NF_VALMERC")*M->C5_PDESCAB/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))
EndIf

If lM410Ipi .Or. lM410Icm .Or. lM410Soli
	nItem := 0
	For nX := 1 To Len(aCols)
		//nItem++
		If Len(aCols[nX])==nUsado .Or. !aCols[nX][nUsado+1]
			nItem++
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ponto de Entrada M410IPI para alterar os valores do IPI referente a planilha financeira           ?
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lM410Ipi 
				VALORIPI    := MaFisRet(nItem,"IT_VALIPI")
				BASEIPI     := MaFisRet(nItem,"IT_BASEIPI")
				QUANTIDADE  := MaFisRet(nItem,"IT_QUANT")
				ALIQIPI     := MaFisRet(nItem,"IT_ALIQIPI")
				BASEIPIFRETE:= MaFisRet(nItem,"IT_FRETE")
				MaFisAlt("IT_VALIPI",ExecBlock("M410IPI",.F.,.F.,{ nItem }),nItem,.T.)
				MaFisLoad("IT_BASEIPI",BASEIPI ,nItem)
				MaFisLoad("IT_ALIQIPI",ALIQIPI ,nItem)
				MaFisLoad("IT_FRETE"  ,BASEIPIFRETE,nItem,"11")
				MaFisEndLoad(nItem,1)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ponto de Entrada M410ICM para alterar os valores do ICM referente a palnilha financeira           ?
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lM410Icm
				_BASEICM    := MaFisRet(nItem,"IT_BASEICM")
				_ALIQICM    := MaFisRet(nItem,"IT_ALIQICM")
				_QUANTIDADE := MaFisRet(nItem,"IT_QUANT")
				_VALICM     := MaFisRet(nItem,"IT_VALICM")
				_FRETE      := MaFisRet(nItem,"IT_FRETE")
				_VALICMFRETE:= MaFisRet(nItem,"IT_ICMFRETE")
				_DESCONTO   := MaFisRet(nItem,"IT_DESCONTO")
				ExecBlock("M410ICM",.F.,.F., { nItem } )
				MaFisLoad("IT_BASEICM" ,_BASEICM    ,nItem)
				MaFisLoad("IT_ALIQICM" ,_ALIQICM    ,nItem)
				MaFisLoad("IT_VALICM"  ,_VALICM     ,nItem)
				MaFisLoad("IT_FRETE"   ,_FRETE      ,nItem)
				MaFisLoad("IT_ICMFRETE",_VALICMFRETE,nItem)
				MaFisLoad("IT_DESCONTO",_DESCONTO   ,nItem) 
				MaFisEndLoad(nItem,1)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ponto de Entrada M410SOLI para alterar os valores do ICM Solidario referente a palnilha financeira?
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lM410Soli
				ICMSITEM    := MaFisRet(nItem,"IT_VALICM")		// variavel para ponto de entrada
				QUANTITEM   := MaFisRet(nItem,"IT_QUANT")		// variavel para ponto de entrada
				BASEICMRET  := MaFisRet(nItem,"IT_BASESOL")	    // criado apenas para o ponto de entrada
				MARGEMLUCR  := MaFisRet(nItem,"IT_MARGEM")		// criado apenas para o ponto de entrada
				aSolid := ExecBlock("M410SOLI",.f.,.f.,{nItem}) 
				aSolid := IIF(ValType(aSolid) == "A" .And. Len(aSolid) == 2, aSolid,{})
				If !Empty(aSolid)
					MaFisLoad("IT_BASESOL",NoRound(aSolid[1],2),nItem)
					MaFisLoad("IT_VALSOL" ,NoRound(aSolid[2],2),nItem)
					MaFisEndLoad(nItem,1) 
				Endif                              
			EndIf
		EndIf
	Next
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Realiza alteracoes de referencias do SC6         ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
dbSelectArea("SC6")
If Len(aFisGet) > 0
	For nX := 1 to Len(aCols)
		If Len(aCols[nX])==nUsado .Or. !aCols[nX][Len(aHeader)+1]
			For nY := 1 to Len(aFisGet)
				nPosCpo := aScan(aHeader,{|x| AllTrim(x[2])==Alltrim(aFisGet[ny][2])})
				If nPosCpo > 0
					If !Empty(aCols[nX][nPosCpo])
						MaFisAlt(aFisGet[ny][1],aCols[nX][nPosCpo],nX,.F.)
					Endif
				EndIf
			Next nX
		Endif
	Next nY
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Realiza alteracoes de referencias do SC5 Suframa ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
nPSuframa:=aScan(aFisGetSC5,{|x| x[1] == "NF_SUFRAMA"})
If !Empty(nPSuframa)
	dbSelectArea("SC5")
	If !Empty(&("M->"+Alltrim(aFisGetSC5[nPSuframa][2])))
		MaFisAlt(aFisGetSC5[nPSuframa][1],Iif(&("M->"+Alltrim(aFisGetSC5[nPSuframa][2])) == "1",.T.,.F.),nItem,.F.)
	EndIf
Endif
If ExistBlock("M410PLNF")
	ExecBlock("M410PLNF",.F.,.F.)
EndIf
MaFisWrite(1)
//
// Template GEM - Gestao de Empreendimentos Imobiliarios
//
// Verifica se a condicao de pagamento tem vinculacao com uma condicao de venda
//
If ExistTemplate("GMCondPagto")
	lCondVenda := .F.
	lCondVenda := ExecTemplate("GMCondPagto",.F.,.F.,{M->C5_CONDPAG,} )
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Calcula os venctos conforme a condicao de pagto  ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
If !M->C5_TIPO == "B"
	If lDtEmi
		dbSelectarea("SE4")
		dbSetOrder(1)
		MsSeek(xFilial("SE4")+M->C5_CONDPAG)
		If ((SE4->E4_TIPO=="9".AND.!(INCLUI.OR.ALTERA)).OR.SE4->E4_TIPO<>"9")				
		
			If SFB->FB_JNS == 'J' .And. cPaisLoc == 'COL'
			    dbSelectArea("SFC")
				dbSetOrder(2)
				If dbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RV0" )
					nValRetImp 	:= MaFisRet(,"NF_VALIV2")
					Do Case
						Case FC_INCDUPL == '1'
							nlValor := MaFisRet(,"NF_BASEDUP") - nValRetImp
						Case FC_INCDUPL == '2'
							nlValor :=MaFisRet(,"NF_BASEDUP") + nValRetImp
						Otherwise
							nlValor :=MaFisRet(,"NF_BASEDUP")
					EndCase
				Elseif dbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RF0" )
					nValRetImp 	:= MaFisRet(,"NF_VALIV4")
					Do Case
						Case FC_INCDUPL == '1'
							nlValor := MaFisRet(,"NF_BASEDUP") - nValRetImp
						Case FC_INCDUPL == '2'
							nlValor :=MaFisRet(,"NF_BASEDUP") + nValRetImp
						Otherwise
							nlValor :=MaFisRet(,"NF_BASEDUP")
					EndCase
				Elseif dbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RC0" )
					nValRetImp 	:= MaFisRet(,"NF_VALIV7")
					Do Case
						Case FC_INCDUPL == '1'
							nlValor := MaFisRet(,"NF_BASEDUP") - nValRetImp
						Case FC_INCDUPL == '2'
							nlValor :=MaFisRet(,"NF_BASEDUP") + nValRetImp
						Otherwise
							nlValor :=MaFisRet(,"NF_BASEDUP")
					EndCase
				Endif
			Else
				nlValor := MaFisRet(,"NF_BASEDUP")
			EndIf				
		
			aDupl := Condicao(nlValor,M->C5_CONDPAG,MaFisRet(,"NF_VALIPI"),dDataCnd,MaFisRet(,"NF_VALSOL"),,,nAcresTot)
			If Len(aDupl) > 0
				If ! lCondVenda
					For nX := 1 To Len(aDupl)
						nAcerto += aDupl[nX][2]
					Next nX
					aDupl[Len(aDupl)][2] += MaFisRet(,"NF_BASEDUP") - nAcerto
				EndIf
	
				aVencto := aClone(aDupl)
				For nX := 1 To Len(aDupl)
					aDupl[nX][2] := TransForm(aDupl[nX][2],PesqPict("SE1","E1_VALOR"))
				Next nX
			Endif
		Else
			aDupl := {{Ctod(""),TransForm(MaFisRet(,"NF_BASEDUP"),PesqPict("SE1","E1_VALOR"))}}
			aVencto := {{dDataBase,MaFisRet(,"NF_BASEDUP")}}
		EndIf
	Else
		nItem := 0	
		For nX := 1 to Len(aCols)
			If Len(aCols[nX])==nUsado .Or. !aCols[nX][nUsado+1]
				If nPDtEntr > 0
					nItem++
					nPosEntr := Ascan(aEntr,{|x| x[1] == aCols[nX][nPDtEntr]})
	 				If nPosEntr == 0
						Aadd(aEntr,{aCols[nX][nPDtEntr],MaFisRet(nItem,"IT_BASEDUP"),MaFisRet(nItem,"IT_VALIPI"),MaFisRet(nItem,"IT_VALSOL"),MaFisRet(nItem,"IT_VALMERC"),MaFisRet(nItem,"IT_VALPS2"),MaFisRet(nItem,"IT_VALCF2")})
					Else    
						aEntr[nPosEntr][2]+= MaFisRet(nItem,"IT_BASEDUP")
						aEntr[nPosEntr][3]+= MaFisRet(nItem,"IT_VALIPI")
						aEntr[nPosEntr][4]+= MaFisRet(nItem,"IT_VALSOL")
						aEntr[nPosEntr][5]+= MaFisRet(nItem,"IT_VALMERC")
						aEntr[nPosEntr][6]+= MaFisRet(nItem,"IT_VALPS2")
						aEntr[nPosEntr][7]+= MaFisRet(nItem,"IT_VALCF2")
					EndIf
				Endif
			Endif
	    Next
		dbSelectarea("SE4")
		dbSetOrder(1)
		MsSeek(xFilial("SE4")+M->C5_CONDPAG)
		If !(SE4->E4_TIPO=="9")
			For nY := 1 to Len(aEntr)
				nAcerto  := 0
				
				If SFB->FB_JNS $ 'J/S' .And. cPaisLoc == 'COL'
				    
				    dbSelectArea("SFC")
					dbSetOrder(2)
					If dbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RV0" )
						nValRetImp 	:= MaFisRet(,"NF_VALIV2")
						Do Case
							Case FC_INCDUPL == '1'
								nlValor := aEntr[nY][2] - nValRetImp
							Case FC_INCDUPL == '2'
								nlValor :=aEntr[nY][2] + nValRetImp
							Otherwise
								nlValor :=aEntr[nY][2]
						EndCase
					Elseif dbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RF0" )
						nValRetImp 	:= MaFisRet(,"NF_VALIV4")
						Do Case
							Case FC_INCDUPL == '1'
								nlValor := aEntr[nY][2] - nValRetImp
							Case FC_INCDUPL == '2'
								nlValor :=aEntr[nY][2] + nValRetImp
							Otherwise
								nlValor :=aEntr[nY][2]
						EndCase
					Elseif dbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RC0" )
						nValRetImp 	:= MaFisRet(,"NF_VALIV7")
						Do Case
							Case FC_INCDUPL == '1'
								nlValor := aEntr[nY][2] - nValRetImp
							Case FC_INCDUPL == '2'
								nlValor :=aEntr[nY][2] + nValRetImp
							Otherwise
								nlValor :=aEntr[nY][2]
						EndCase
					Endif
				Else
					nlValor := aEntr[nY][2]
				EndIf
				
				
				aDuplTmp := Condicao(nlValor,M->C5_CONDPAG,aEntr[nY][3],aEntr[nY][1],aEntr[nY][4],,,nAcresTot)
				If Len(aDuplTmp) > 0
					If ! lCondVenda
						For nX := 1 To Len(aDuplTmp)
							nAcerto += aDuplTmp[nX][2]
						Next nX
						aDuplTmp[Len(aDuplTmp)][2] += aEntr[nY][2] - nAcerto
					EndIf
	
					aVencto := aClone(aDuplTmp)
					For nX := 1 To Len(aDuplTmp)
						aDuplTmp[nX][2] := TransForm(aDuplTmp[nX][2],PesqPict("SE1","E1_VALOR"))
					Next nX
					aEval(aDuplTmp,{|x| Aadd(aDupl,{aEntr[nY][1],x[1],x[2]})})
				EndIf
			Next
		Else
			aDupl := {{Ctod(""),TransForm(MaFisRet(,"NF_BASEDUP"),PesqPict("SE1","E1_VALOR"))}}
			aVencto := {{dDataBase,MaFisRet(,"NF_BASEDUP")}}
		EndIf
	EndIf
Else
	aDupl := {{Ctod(""),TransForm(0,PesqPict("SE1","E1_VALOR"))}}
	aVencto := {{dDataBase,0}}
EndIf
//
// Template GEM - Gestao de empreendimentos Imobiliarios
// Gera os vencimentos e valores das parcelas conforme a condicao de venda
//
If lCondVenda 
	If ExistBlock("GMMA410Dupl")
		aVencto := ExecBlock("GMMA410Dupl",.F.,.F.,{M->C5_NUM ,M->C5_CONDPAG,dDataCnd,,MaFisRet(,"NF_BASEDUP") ,aVencto}, .F., .F.) 
	ElseIf ExistTemplate("GMMA410Dupl")
		aVencto := ExecTemplate("GMMA410Dupl",.F.,.F.,{M->C5_NUM ,M->C5_CONDPAG,dDataCnd,,MaFisRet(,"NF_BASEDUP") ,aVencto}) 
	Endif	
	aDupl := {}
	aEval(aVencto ,{|aTitulo| aAdd( aDupl ,{transform(aTitulo[1],x3Picture("E1_VENCTO")) ,transform(aTitulo[2],x3Picture("E1_VALOR"))}) })
EndIf

If Len(aDupl) == 0
	aDupl := {{Ctod(""),TransForm(MaFisRet(,"NF_BASEDUP"),PesqPict("SE1","E1_VALOR"))}}
	aVencto := {{dDataBase,MaFisRet(,"NF_BASEDUP")}}
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Analise da Rentabilidade - Valor Presente    ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//aRentabil := a410RentPV( aCols ,nUsado ,@aRenTab ,@aVencto ,nPTES,nPProduto,nPLocal,nPQtdVen )

//If cPaisLoc=="BRA" .And. AliasIndic("CDA")
//	aAdd(aTitles,STR0114)	//"Lançamentos da Apuração de ICMS"
//	nLancAp	:=	Len(aTitles)
//EndIf

nCount := 0
If nLinha > 0 // retorna somente uma linha para a referencia fiscal
	xValorRet := 0
	If "IT_" $ cRefFis
		xValorRet := MaFisRet(nLinha,cRefFis)
	Else
		xValorRet := MaFisRet(,cRefFis)
	EndIf
Elseif "IT_" $ cRefFis // retorna um array de todas as linhas do pedido para esta referencia fiscal
	xValorRet := {}
	For nX := 1 To Len(aCols)
		//nCount++
		If Len(aCols[nX])==nUsado .Or. !aCols[nX][nUsado+1]
			nCount++
			aAdd(xValorRet,{aCols[nX][nPItem],MaFisRet(nCount,cRefFis)})
		Endif
	Next nX		
Else // retorna uma linha para a referencia fiscal
	xValorRet := 0
	xValorRet := MaFisRet(,cRefFis)
	// soma o valor de todas as parcelas
	//For nCntFor := 1 To Len(aVencto)
	//	xValorRet += aVencto[nCntFor][2]
	//Next	
EndIf

// verifica se deve retornar outras referencias fiscais
If Len(aRefFis) > 0
	xValorRet2 := {}
	For nX:=1 To Len(aRefFis)
		If !"IT_" $ aRefFis[nX]
			aAdd(xValorRet2,{aRefFis[nX],MaFisRet(,aRefFis[nX])})
		Else
			nCount := 0
			For nX1:=1 To Len(aCols)
				//nCount++
				If Len(aCols[nX1])==nUsado .Or. !aCols[nX1][nUsado+1]
					nCount++
					aAdd(xValorRet2,{aRefFis[nX],aCols[nX1][nPItem],MaFisRet(nCount,aRefFis[nX])})
				Endif
			Next
		Endif	
	Next	
Endif	

If ValType(xValorRet) != "N" .and. ValType(xValorRet) != "A"
	If nLinha > 0 
		xValorRet := 0
	Elseif "IT_" $ cRefFis
		xValorRet := {}
	Else
		xValorRet := 0
	EndIf
Endif

If ValType(xValorRet2) != "N" .and. ValType(xValorRet2) != "A"
	xValorRet2 := {}
Endif

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Monta a tela de exibicao dos valores fiscais ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0043) FROM 09,00 TO 28,80 //"Planilha Financeira"
oFolder := TFolder():New(001,001,aTitles,{"HEADER"},oDlg,,,, .T., .F.,315,140)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Folder 1                                     ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
MaFisRodape(1,oFolder:aDialogs[1],,{005,001,310,60},Nil,.T.)
If cPaisLoc <> "PTG"
	@ 070,005 SAY RetTitle("F2_FRETE")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 070,105 SAY RetTitle("F2_SEGURO")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 070,205 SAY RetTitle("F2_DESCONT")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 085,005 SAY RetTitle("F2_FRETAUT")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 085,105 SAY RetTitle("F2_DESPESA")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 085,205 SAY RetTitle("F2_VALFAT")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 070,050 MSGET MaFisRet(,"NF_FRETE")		PICTURE PesqPict("SF2","F2_FRETE",16,2)		SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 070,150 MSGET MaFisRet(,"NF_SEGURO")  	PICTURE PesqPict("SF2","F2_SEGURO",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 070,250 MSGET MaFisRet(,"NF_DESCONTO")	PICTURE PesqPict("SF2","F2_DESCONTO",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 085,050 MSGET MaFisRet(,"NF_AUTONOMO")	PICTURE PesqPict("SF2","F2_FRETAUT",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 085,150 MSGET MaFisRet(,"NF_DESPESA")		PICTURE PesqPict("SF2","F2_DESPESA",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 085,250 MSGET MaFisRet(,"NF_BASEDUP")		PICTURE PesqPict("SF2","F2_VALFAT",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 105,005 TO 106,310 PIXEL OF oFolder:aDialogs[1]
	@ 110,005 SAY OemToAnsi(STR0048)   SIZE 40,10 PIXEL OF oFolder:aDialogs[1] //"Total da Nota"
	@ 110,050 MSGET MaFisRet(,"NF_TOTAL")      PICTURE Iif(cPaisLoc=="CHI",TM(0,16,NIL),PesqPict("SF2","F2_VALBRUT",16,2))                   	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 110,270 BUTTON OemToAnsi(STR0049)			SIZE 040,11 FONT oFolder:aDialogs[1]:oFont ACTION oDlg:End() OF oFolder:aDialogs[1] PIXEL		//"Sair"
Else 
	@ 070,005 SAY RetTitle("F2_DESCONT")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 070,105 SAY RetTitle("F2_FRETE")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 070,205 SAY RetTitle("F2_SEGURO")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 085,005 SAY RetTitle("F2_DESPESA")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 085,105 SAY RetTitle("F2_DESNTRB")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 085,205 SAY RetTitle("F2_TARA")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 110,005 SAY RetTitle("F2_VALFAT")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
	@ 070,050 MSGET MaFisRet(,"NF_DESCONTO")	PICTURE PesqPict("SF2","F2_DESCONTO",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 070,150 MSGET MaFisRet(,"NF_FRETE")		PICTURE PesqPict("SF2","F2_FRETE",16,2)		SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 070,250 MSGET MaFisRet(,"NF_SEGURO")  	PICTURE PesqPict("SF2","F2_SEGURO",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 085,050 MSGET MaFisRet(,"NF_DESPESA")		PICTURE PesqPict("SF2","F2_DESPESA",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 085,150 MSGET MaFisRet(,"NF_DESNTRB")		PICTURE PesqPict("SF2","F2_DESNTRB",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 085,250 MSGET MaFisRet(,"NF_TARA")		PICTURE PesqPict("SF2","F2_TARA",16,2)		SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 110,050 MSGET MaFisRet(,"NF_BASEDUP")		PICTURE PesqPict("SF2","F2_VALFAT",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 105,005 TO 106,310 PIXEL OF oFolder:aDialogs[1]
	@ 110,105 SAY OemToAnsi(STR0048)   SIZE 40,10 PIXEL OF oFolder:aDialogs[1] //"Total da Nota"
	@ 110,150 MSGET MaFisRet(,"NF_TOTAL")      PICTURE Iif(cPaisLoc=="CHI",TM(0,16,NIL),PesqPict("SF2","F2_VALBRUT",16,2))                   	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
	@ 110,270 BUTTON OemToAnsi(STR0049)			SIZE 040,11 FONT oFolder:aDialogs[1]:oFont ACTION oDlg:End() OF oFolder:aDialogs[1] PIXEL		//"Sair"
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Folder 2                                     ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?                                                                                                     
If lDtEmi
	@ 005,001 LISTBOX oDupl FIELDS TITLE aFlHead[1],aFlHead[2] SIZE 310,095 	OF oFolder:aDialogs[2] PIXEL
Else	
	@ 005,001 LISTBOX oDupl FIELDS TITLE aFlHead[3],aFlHead[1],aFlHead[2] SIZE 310,095 	OF oFolder:aDialogs[2] PIXEL
Endif	
oDupl:SetArray(aDupl)
oDupl:bLine := {|| aDupl[oDupl:nAt] }
@ 105,005 TO 106,310 PIXEL OF oFolder:aDialogs[2]
If cPaisLoc == "BRA"
	@ 110,005 SAY RetTitle("F2_VALFAT")		SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
Else
	@ 110,005 SAY OemToAnsi(STR0051)	    SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
Endif	
@ 110,050 MSGET MaFisRet(,"NF_BASEDUP")		PICTURE PesqPict("SF2","F2_VALFAT",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[2]

//
// Template GEM - Gestao de empreendimentos imobiliarios
// Manutencao dos itens da condicao de venda 
//
If ExistBlock("GMMA410CVND",,.T.)
	If ExistBlock("GMMA410Dupl")
		@ 110,170 BUTTON OemToAnsi("Cond. de Venda") SIZE 050,11 FONT oFolder:aDialogs[1]:oFont ;
		          ACTION ( ExecBlock("GMMA410CVND",.F.,.F.,{nOpc ,M->C5_NUM ,M->C5_CONDPAG ,dDataCnd ,MaFisRet(,"NF_BASEDUP")}) ;
		                  ,aVencto := ExecBlock("GMMA410Dupl",.F.,.F.,{M->C5_NUM ,M->C5_CONDPAG,dDataCnd,,MaFisRet(,"NF_BASEDUP"),aVencto}) ;
		                  ,( aDupl := {} ,aEval(aVencto ,{|aTitulo| aAdd( aDupl ,{transform(aTitulo[1],x3Picture("E1_VENCTO")) ,transform(aTitulo[2],x3Picture("E1_VALOR"))})}) ;
		                  ,aRentabil := a410RentPV( aCols ,nUsado ,@aRenTab ,@aVencto ,nPTES,nPProduto,nPLocal,nPQtdVen ) );
		                  ,(oDupl:SetArray(aDupl),	oDupl:bLine := {|| aDupl[oDupl:nAt] }) ;
		                  ,(oRentab:SetArray(aRentabil) ,oRentab:bLine := {|| aRentabil[oRenTab:nAt] }) ) ;
		          OF oFolder:aDialogs[2] PIXEL
	EndIf
Else
	If ExistTemplate("GMMA410CVND",,.T.) .AND. HasTemplate("LOT")
		If ExistTemplate("GMMA410Dupl")
			@ 110,170 BUTTON OemToAnsi("Cond. de Venda") SIZE 050,11 FONT oFolder:aDialogs[1]:oFont ;
			          ACTION ( ExecTemplate("GMMA410CVND",.F.,.F.,{nOpc ,M->C5_NUM ,M->C5_CONDPAG ,dDataCnd ,MaFisRet(,"NF_BASEDUP")}) ;
			                  ,aVencto := ExecTemplate("GMMA410Dupl",.F.,.F.,{M->C5_NUM ,M->C5_CONDPAG,dDataCnd,,MaFisRet(,"NF_BASEDUP"),aVencto}) ;
			                  ,( aDupl := {} ,aEval(aVencto ,{|aTitulo| aAdd( aDupl ,{transform(aTitulo[1],x3Picture("E1_VENCTO")) ,transform(aTitulo[2],x3Picture("E1_VALOR"))})}) ;
			                  ,aRentabil := a410RentPV( aCols ,nUsado ,@aRenTab ,@aVencto ,nPTES,nPProduto,nPLocal,nPQtdVen ) );
			                  ,(oDupl:SetArray(aDupl),	oDupl:bLine := {|| aDupl[oDupl:nAt] }) ;
			                  ,(oRentab:SetArray(aRentabil) ,oRentab:bLine := {|| aRentabil[oRenTab:nAt] }) ) ;
			          OF oFolder:aDialogs[2] PIXEL
		EndIf
	EndIf
Endif
@ 110,270 BUTTON OemToAnsi(STR0049)			SIZE 040,11 FONT oFolder:aDialogs[1]:oFont ACTION oDlg:End() OF oFolder:aDialogs[2] PIXEL	//"Sair"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Folder 3                                     ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
@ 005,001 LISTBOX oRentab FIELDS TITLE aRFHead[1],aRFHead[2],aRFHead[3],aRFHead[4],aRFHead[5],aRFHead[6] SIZE 310,095 	OF oFolder:aDialogs[3] PIXEL
@ 110,270 BUTTON OemToAnsi(STR0049)			SIZE 040,11 FONT oFolder:aDialogs[3]:oFont ACTION oDlg:End() OF oFolder:aDialogs[3] PIXEL		//"Sair"
If Empty(aRentabil)
	aRentabil   := {{"",0,0,0,0,0}}
EndIf
oRentab:SetArray(aRentabil)
oRentab:bLine := {|| aRentabil[oRentab:nAt] }

If cPaisLoc=="BRA" .And. AliasIndic("CDA")
	oLancApICMS := A410LAICMS(oFolder:aDialogs[nLancAp],{005,001,310,095},@aHeadCDA,@aColsCDA,.T.,.F.)
	@ 110,270 BUTTON OemToAnsi(STR0049)			SIZE 040,11 FONT oFolder:aDialogs[nLancAp]:oFont ACTION oDlg:End() OF oFolder:aDialogs[nLancAp] PIXEL		//"Sair"
EndIf

ACTIVATE MSDIALOG oDlg CENTERED
*/

MaFisEnd()
MaFisRestore()

RestArea(aAreaSA1)
RestArea(aArea)

Return({(xValorRet),(xValorRet2)})

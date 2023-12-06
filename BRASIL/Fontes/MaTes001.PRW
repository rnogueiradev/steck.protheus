#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±|Ponto de  ³MaTes001  |Autor  ³Ricardo Posman         |Data  ³18.09.2007|±±
±±³Entrada   ³          ³       |                       |      |          |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±|Descricao ³Gatilho que substitui funcao da tes inteligente.            |±±
±±|          ³                                                            |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³    Steck                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MaTes001(nEntSai,cTpOper,cClieFor,cLoja,cTipoCF,cProduto,cCampo)
      

Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local aAreaSA2	:= SA2->(GetArea())
Local aAreaSB1	:= SB1->(GetArea())
Local aAreaSX3  := SX3->(GetArea())
Local aTes 		:= {}
Local aDadosCfo:= {} 
Local cTesRet	:= "   "
Local cGrupo	:= ""
Local cGruProd	:= ""
Local cQuery	:= ""  
Local cProg     := "MT100"
Local cNCM      := ""
Local cEstado   := ""
Local cAliasSFM:= "SFM"         
Local cTabela  := ""
Local lQuery	:= .F.
Local nPosCpo	:= 0
Local nPosCfo  := 0
Local nFM_POSIPI := SFM->(FieldPos("FM_POSIPI"))
Local nFM_EST    := SFM->(FieldPos("FM_EST"))
Local cAlias	 := ""		//Tabela a ser utiliza para informacoes do produto
Local c_GRTRIB   := ""		//SBI->BI_GRTRIB	/ 	SB1->B1_GRTRIB
Local c_POSIPI   := "" 		//SBI->BI_POSIPI	/	SB1->B1_POSIPI	 
Local cSb1Sbz    := SuperGetMV("MV_ARQPROD",.F.,"SB1")

Local bCond		:=	{||.T.}
Local bCondAux	:=	{||.T.}
Local bSort		:=	{||}
Local bAddTes	:=	{||.T.}
Local bAtTes	:=	{||.T.}
Local bIFWhile	:=	{||.T.}
Local aRet		:=	{}


Local _Pessoa   := SA1->A1_PESSOA        				//F=Fisica;J=Juridica                                                                                                          
Local _TipoP	:= SA1->A1_TIPO           				// F=Cons.Final;L=Produtor Rural;R=Revendedor;S=Solidario;X=Exportacao
LOCAL _Contrib  := ""
Local _ClTrib   := SA1->A1_TIPO   					  	// F ou S					
Local _ClassPr  := SB1->B1_CLAPROD   				  	// C F I
Local _PrTrib   := SB1->B1_GRTRIB      
Local _Ipi		:= IIF(Empty(SB1->B1_POSIPI),"N","S") 	// NCM
Local _Tes		:= ""
Local _Oper     := ""


DEFAULT cTpOper  := &(ReadVar())
DEFAULT cClieFor := ""
DEFAULT cProduto := ""
DEFAULT nEntSai  := 0
DEFAULT cTipoCF  := "C"
DEFAULT cCampo	  := ""

If  SA1->A1_CONTRIB = "1"                          	// ICMS
_Contrib  := "S"
Else
_Contrib  := "N"
Endif

If  SA1->A1_TIPO = "F" .and.  _Contrib == "N"                         	// ICMS

_ClTrib := "N"

ELSE
_ClTrib := "S"

ENDIF


If FunName() == 'MATA410'
      _Oper :=M->C6_OPER      
ElseIf FunName() == 'MATA415'
      _Oper :=M->CK_OPER
ElseIf FunName() == 'TMKA271'    // UB_TES
      _Oper :=M->UA_OPER2

Endif            

If !Empty(cCampo)
	nPosCpo	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim(cCampo) })
	dbSelectArea("SX3")
	dbSetOrder(2)
	MsSeek(aHeader[nPosCpo,2])
	cTabela  := SX3->X3_ARQUIVO
	RestArea(aAreaSX3)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o grupo de tributacao do cliente/fornecedor         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(IIf(cTipoCF == "C","SA1","SA2"))
dbSetOrder(1)
MsSeek(xFilial()+cClieFor+cLoja)
If cTipoCF == "C"
	cGrupo  := SA1->A1_GRPTRIB
	cEstado := SA1->A1_EST
Else
	cGrupo  := SA2->A2_GRPTRIB
	cEstado := SA2->A2_EST
EndIf

	cAlias 	  := "SB1"
	c_GRTRIB  := "SB1->B1_GRTRIB"
	c_POSIPI  := "SB1->B1_POSIPI" 
    If cSb1Sbz == "SBZ"
		cAlias 	  := "SBZ"
		c_GRTRIB  := "SBZ->BZ_GRTRIB"
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o grupo do produto                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea(cAlias)                 
DbSetOrder(1)
If DbSeek(xFilial(cAlias) + cProduto) 
	cGruProd := &(c_GRTRIB)
	If !Empty(c_POSIPI)
		cNCM     := &(c_POSIPI) 
	Endif
Endif
//		XFM->(dbCloseArea())
		cQuery := " SELECT FM_TS "
		cQuery += " FROM "+RetSqlName("SFM")+ " 
		cQuery += " WHERE FM_FILIAL='"+xFILIAL("SFM")+"' "
		cQuery += " AND  FM_IPI= '" + _Ipi + "' "
		cQuery += " AND  FM_CLAPROD= '" + _ClassPr + "' "
		cQuery += " AND  FM_ICMS= '" + _Contrib + "' "  
		cQuery += " AND  FM_TIPO= '" + _Oper + "' "
		cQuery += " AND  FM_ST= '" + _ClTrib + "' "
		cQuery += " AND  FM_PESSOA= '" + _PESSOA + "' " 
		cQuery += " AND  FM_TIPOP= '" + _TIPOP + "' " 
		cQuery += " AND  FM_EST= '" + cEstado + "' " 
		cQuery += " AND  FM_GRTRIB= '" + cGrupo + "' " 
		cQuery += " AND D_E_L_E_T_ <> '*' "
		cQuery += " ORDER BY FM_TS "
		
		MEMOWRITE("SFM.SQL",cQuery)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"XFM", .F., .T.)
		
		cTesRet := XFM->FM_TS
		                                    
			If Empty(cTesRet)
				MsgAlert("Nao foi possivel localizar a TES desta operacao. Verifique.") 
//  				XFM->(dbCloseArea())

			Endif		
		
		XFM->(dbCloseArea())

//If Len(aTes) = 0   
//	cTesRet := If(nEntSai==1,aTes[1][8],aTes[1][9])
//EndIf
If nPosCpo > 0 .And. !Empty(cTesRet) .And. Type('aCols') <> "U"
	aCols[n][nPosCpo] := cTesRet
	Do Case
		Case cTabela == "SD1"
			nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D1_CF") })
		Case cTabela == "SD2"
			nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D2_CF") })
		Case cTabela == "SC6"     
			dbSelectArea("SF4")
			dbSetOrder(1)
			nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("C6_CF") })
			If nPosCfo > 0 .And. MsSeek(xFilial("SF4")+cTesRet)
				aDadosCfo := {} 
			 	AAdd(aDadosCfo,{"OPERNF","S"})
			 	AAdd(aDadosCfo,{"TPCLIFOR",If(cTipoCF == "C", SA1->A1_TIPO , SA2->A2_TIPO )})
			 	AAdd(aDadosCfo,{"UFDEST"  ,If(cTipoCF == "C", SA1->A1_EST  , SA2->A2_EST  )})
			 	AAdd(aDadosCfo,{"INSCR"   ,If(cTipoCF == "C", SA1->A1_INSCR, SA2->A2_INSCR)})
			 	AAdd(aDadosCfo,{"CONTR"   ,If(cTipoCF == "C", SA1->A1_CONTRIB, "")})
				aCols[n][nPosCfo] := MaFisCfo( ,SF4->F4_CF,aDadosCfo ) 
			EndIf
			nPosCfo := 0      
		Case cTabela == "SC7"
			cProg := "MT120"
		Case cTabela == "SC8"
			cProg := "MT150"
		Case cTabela == "SUB"
			nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UB_CF") })
			cProg := "TK273"
	EndCase
	If nPosCfo > 0
		aCols[n][nPosCfo] := Space(Len(aCols[n][nPosCfo]))
	EndIf
	If MaFisFound("IT",N)
		MaFisAlt("IT_TES",cTesRet,n)
		MaFisRef("IT_TES",cProg,cTesRet)
	EndIf
EndIf
If !Empty(cTesRet)
	dbSelectArea("SF4")
	If MsSeek(xFilial("SF4")+cTesRet)
		If !RegistroOK("SF4")
			cTesRet := Space(Len(cTesRet))
		EndIf
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaSA2)
RestArea(aAreaSA1)
RestArea(aAreaSB1)
RestArea(aArea)


Return(cTesRet)




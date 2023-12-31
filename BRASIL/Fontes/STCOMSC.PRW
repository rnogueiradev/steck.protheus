#INCLUDE "STCOMSC.ch"
#INCLUDE "PROTHEUS.CH"

#DEFINE CRLF Chr(13)+Chr(10)

/*/��������������������������������������������������������������������������
���Descri��o � PLANO DE MELHORIA CONTINUA        �Programa     MATA130.PRX���        	
�������������������������������������������������������������������������Ĵ��
���ITEM PMC  � Responsavel              � Data                            ���
�������������������������������������������������������������������������Ĵ��
���      01  �                          �                                 ���
���      02  �                          �                                 ���
���      03  �                          �                                 ���
���      04  �                          �                                 ���
���      05  � Alexandre Inacio Lemes   � 31/08/06                        ���
���      06  �                          �                                 ���
���      07  � Alexandre Inacio Lemes   � 31/08/06                        ���
���      08  �                          �                                 ���
���      09  �                          �                                 ���
���      10  �                          �                                 ���
�������������������������������������������������������������������������Ŀ��
���Fun��o    � STCOMSC  � Autor �Rodrigo de A Sartorio  � Data � 23/12/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Aglutinacao de SCs                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
���������������������������������������������������������������������������*/

User Function STCOMSC()			//u_STCOMSC()	

Local oDlg
Local oUsado
LOcal nUsado		:= 0
Private cCadastro	:= OemToAnsi(STR0001)	//"Aglutina SCs"
Private cMarca		:= GetMark()

// Verifica as perguntas selecionadas
Pergunte("MTA126",.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        	// De SC                                 �
//� mv_par02        	// Ate SC                                �
//� mv_par03        	// Data de                               �
//� mv_par04        	// Data ate                              �
//� mv_par05        	// De Almoxarifado                       �
//� mv_par06        	// Ate Almoxarifado                      �
//� mv_par07        	// De Produto                            �
//� mv_par08        	// Ate Produto                           �
//� mv_par09        	// De Grupo                              �
//� mv_par10        	// Ate Grupo                             �
//� mv_par11        	// De Tipo                               �
//� mv_par12       		// Ate Tipo                              �
//����������������������������������������������������������������

DEFINE MSDIALOG oDlg FROM  119,5 TO 323,605 TITLE cCadastro PIXEL
@ 15, 20 TO 90,120 LABEL OemToAnsi(STR0002) OF oDlg  PIXEL	//"Per�odos para a Aglutina��o"
@ 15,135 TO 50,280 OF oDlg  PIXEL
@ 25,140 SAY OemToAnsi(STR0003) SIZE 130, 7 OF oDlg PIXEL	//"Este programa permite que as solicitacoes de compra"
@ 32,140 SAY OemToAnsi(STR0004) SIZE 130, 7 OF oDlg PIXEL	//"de um mesmo produto sejam aglutinadas conforme os"
@ 39,140 SAY OemToAnsi(STR0005) SIZE 130, 7 OF oDlg PIXEL	//"per�odos definidos ao lado."
@ 25,25 RADIO oUsado VAR nUsado 3D SIZE 70,10 PROMPT  OemToAnsi(STR0006),;	//"Per�odo Di�rio"
OemToAnsi(STR0007),;	//"Per�odo Semanal"
OemToAnsi(STR0008),;	//"Per�odo Quinzenal"
OemToAnsi(STR0009),;	//"Per�odo Mensal"
OemToAnsi(STR0010),;	//"Per�odo Trimestral"
OemToAnsi(STR0011) OF oDlg PIXEL	//"Per�odo Semestral"
DEFINE SBUTTON FROM 78, 196 TYPE 5 ACTION PERGUNTE("MTA126",.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 78, 223 TYPE 1 ACTION (MTA126EXEC(@nUsado),oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 78, 250 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg

Return

/*���������������������������������������������������������������������������
���Fun��o    �MTA126EXEC� Autor � Rodrigo de A. Sartorio� Data � 04/01/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Executa montagem do arquivo de trabalho e do markbrowse    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � STCOMSC                                                    ���
���������������������������������������������������������������������������*/

Static Function MTA126EXEC(nPeriodo)

Local nTotRegs	:= 0
Local aStru		:= {}
Local aTam		:= TamSX3("C1_NUM")
Local cArqTrab1 := ""
Local cArqTrab2 := ""
Local cKey1		:= ""
Local cKey2		:= ""
Local cSavAlias	:= ""

If nPeriodo > 0
	aAdd(aStru,{ "MARK"   	, "C",02,0})
	aAdd(aStru,{ "NUMSC"  	, "C",aTam[1],0})
	aAdd(aStru,{ "AGLUT"  	, "C",aTam[1],0})
	aAdd(aStru,{ "PRODUTO"	, "C",TAMSX3("B1_COD")[1],0})
	aAdd(aStru,{ "TPOP"   	, "C",01,0})
	aAdd(aStru,{ "DESCRICAO", "C",TAMSX3("B1_DESC")[1],0})
	aAdd(aStru,{ "QUANT"  	, "N",16,4})
	aAdd(aStru,{ "PREVISTA"	, "D",08,0})
	aAdd(aStru,{ "DATAORI"	, "D",08,0})   
	aAdd(aStru,{ "CC"	   	, "C",TAMSX3("C1_CC")[1],0})
	aAdd(aStru,{ "CONTA"  	, "C",TAMSX3("C1_CONTA")[1],0})
	aAdd(aStru,{ "ITEMCTA"	, "C",TAMSX3("C1_ITEMCTA")[1],0})
	aAdd(aStru,{ "ORDEM"  	, "N",04,0})
	aAdd(aStru,{ "TPSC"  	, "C",1,0})
	aAdd(aStru,{ "DESTPSC"  , "C",20,0})
	aAdd(aStru,{ "REGIST" 	, "N",12,0})
	cSavAlias := Alias()
	cArqTrab1 := CriaTrab(aStru)
	cArqTrab2 := CriaTrab(Nil,.F.)
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	cKey1 :="ORDEM"
	cKey2 :="MARK+PRODUTO+TPOP+DTOS(PREVISTA)"
	USE &cArqTrab1 ALIAS TRB NEW
	IndRegua("TRB",Left(cArqTrab1,7) + "I",cKey1,,,STR0012)	//"Selecionando Registros..."
	IndRegua("TRB",cArqTrab2,cKey2,,,STR0012)				      //"Selecionando Registros..."
	dbClearIndex()
	dbSetIndex(Left(cArqTrab1,7) + "I" + OrdBagExt())
	dbSetIndex(cArqTrab2 + OrdBagExt())
	A126Aglut(nPeriodo,@nTotRegs)
	A126Browse(nTotRegs)
	dbSelectArea('TRB')
	dbCloseArea()
	Ferase(cArqTrab1 + GetDBExtension())
	Ferase(Left(cArqTrab1,7) + "I" + OrdBagExt())
	Ferase(cArqTrab2 + OrdBagExt())
	dbSelectArea(cSavAlias)
EndIf

Return

/*���������������������������������������������������������������������������
���Fun��o    �A126Aglut � Autor �Rodrigo de A Sartorio  � Data � 23/12/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processa a aglutinacao das Solicitacoes de Compra          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � STCOMSC                                                    ���
���������������������������������������������������������������������������*/

Static Function A126Aglut(nTipo,nTotRegs)

Local cAliasOri	:= Alias()
Local dData,cKey,cCond
Local dDataFim	:= ""
Local nRegistro := 0
Local cCompara  := ""
Local cDescric  := ""
Local cAliasSC1 := "SC1"    
Local aRegsOk   := {}
Local nAchou    := 0    
Local cFiltro   := ""
Local lPmsInt	:= IsIntegTop(,.T.)
Local aAreaAFG	:= {}
Local nx		:= 0

//Verifica a existencia do campo AFG_VIAINT
dbSelectArea("AFG")
aAReaAFG := AFG->( GetArea() )

//�����������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                            �
//� mv_par01        	// De SC                                    �
//� mv_par02        	// Ate SC                                   �
//� mv_par03        	// Data de                                  �
//� mv_par04        	// Data ate                                 �
//� mv_par05        	// De Almoxarifado                          �
//� mv_par06        	// Ate Almoxarifado                         �
//� mv_par07        	// De Produto                               �
//� mv_par08        	// Ate Produto                              �
//� mv_par09        	// De Grupo                                 �
//� mv_par10        	// Ate Grupo                                �
//� mv_par11        	// De Tipo                                  �
//� mv_par12       	    // Ate Tipo                                 �
//�������������������������������������������������������������������

dbSelectArea("SC1")

cKey := "C1_FILIAL+C1_PRODUTO+C1_TPOP+DTOS(C1_DATPRF)"

// Ponto de Entrada para mudar a Key de aglutinacao das SCs
If ExistBlock("MA126QSC")
	cKey := ExecBlock("MA126QSC",.F.,.F.,{cKey})
	If ValType(cKey) <> "C"
		cKey := "C1_FILIAL+C1_PRODUTO+C1_TPOP+DTOS(C1_DATPRF)"
	EndIf
	nAchou := At("+DTOS(C1_DATPRF)",cKey)
	If nAchou > 0
		cKey := Substr(cKey,1,nAchou-1)+Substr(cKey,nAchou+16) + "+DTOS(C1_DATPRF)"
	EndIf	
EndIf

cAliasSC1 := GetNextAlias()
cCond := " SELECT SC1.*,R_E_C_N_O_ C1REC FROM " + RetSqlName("SC1") + " SC1 "
cCond += " WHERE C1_FILIAL = '" + xFilial('SC1') + "' "
cCond += " 		AND C1_QUJE = 0 "
cCond += " 		AND (C1_COTACAO = '" + Criavar('C1_COTACAO',.F.) + "' OR C1_COTACAO = 'IMPORT') AND "
// AVALIA TIPO DE SOLICITACAO DE COMPRA
If mv_par13 == 1
	cCond += "		(C1_TPOP = 'F' OR C1_TPOP = ' ') AND "
ElseIf mv_par13 == 2
	cCond += "		C1_TPOP = 'P' AND "
EndIf
cCond += "		C1_NUM >= '" + mv_par01 + "' AND C1_NUM <= '" + mv_par02 + "' AND "
cCond += "		C1_DATPRF >= '" + DtoS(mv_par03) + "' AND C1_DATPRF <= '" + DtoS(mv_par04) + "' AND "
cCond += "		C1_LOCAL >='" + mv_par05 + "' AND C1_LOCAL <='" + mv_par06 + "' AND C1_PRODUTO>='" + mv_par07 + "' AND C1_PRODUTO<='" + mv_par08 + "' AND "
cCond += "		C1_APROV <> 'B' AND C1_APROV <> 'R' AND C1_RESIDUO <> 'S' AND "
cCond += "		D_E_L_E_T_=' ' "

// Ponto de Entrada para adicionar filtro BOPS: 152687
If ExistBlock("MA126FIL")
	cFiltro := ExecBlock("MA126FIL",.F.,.F.,{cCond})
	cCond	:= If(ValType(cFiltro) == "C",cFiltro,cCond)
EndIf		

cCond += "ORDER BY " + SqlOrder(cKey)	
cCond := ChangeQuery(cCond)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCond),cAliasSC1,.T.,.T.)
aEval(SC1->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(cAliasSC1,x[1],x[2],x[3],x[4]),Nil)})	
  
nAchou := At("+DTOS(C1_DATPRF)",cKey)
If nAchou > 0
	cKey := Substr(cKey,1,nAchou-1)
EndIf

While !Eof()
	// Valida caracteristicas do produto
	If !(SB1->(MsSeek(xFilial("SB1") + (cAliasSC1)->C1_PRODUTO)) .And. SB1->B1_GRUPO >= mv_par09 .And. SB1->B1_GRUPO <= mv_par10 .And. SB1->B1_TIPO >= mv_par11 .And. SB1->B1_TIPO <= mv_par12)
		dbSkip()
		Loop		
	EndIf		
	// Nao permitir a aglutinacao de uma SC gerada no Totvs Obras e Projetos.
	If lPmsInt
		AFG->( dbSetOrder(2) )
		AFG->( dbSeek(xFilial("AFG") + (cAliasSC1)->C1_NUM + (cAliasSC1)->C1_ITEM) )
		If AFG->AFG_VIAINT == "S"
			dbSkip()
			Loop		
		EndIf	
	EndIf
    cCompara := &(cKey)  
	dData    := C1_DATPRF
	aRegsOk  := {}
	// Verifica todos do mesmo tipo
	While !Eof() .And. cCompara == &(cKey) //.And. A126Periodo(dData,C1_DATPRF,nTipo)
		// Valida caracteristicas do produto
		If !(SB1->(MsSeek(xFilial("SB1") + (cAliasSC1)->C1_PRODUTO)) .And. SB1->B1_GRUPO >= mv_par09 .And. SB1->B1_GRUPO <= mv_par10 .And. SB1->B1_TIPO >= mv_par11 .And. SB1->B1_TIPO <= mv_par12)
			dbSkip()
			Loop		
		EndIf		
		nRegistro := C1REC
		aAdd(aRegsOk,nRegistro)
		dbSkip()
	End	
	// Caso tenha mais de uma SC para aglutinar
	If Len(aRegsOk) > 1
		dDataFim := ""
		nTotRegs++
		For nx := 1 to Len(aRegsOk)	
			SC1->(dbGoto(aRegsOk[nx]))
			// Menor data prevista de NECESSIDADE
			If Empty(dDataFim)
				dDataFim := SC1->C1_DATPRF
			ElseIf !Empty(dDataFim) .And. SC1->C1_DATPRF < dDataFim
				dDataFim := SC1->C1_DATPRF
			EndIf
			// Filtro das SCs (De ... Ate)
			If SB1->( MsSeek(xFilial("SB1") + SC1->C1_PRODUTO) )
				cDescric := Left(SB1->B1_DESC,30)
			EndIf
			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			Replace MARK      With cMarca
			Replace NUMSC     With SC1->C1_NUM
			Replace PRODUTO   With SC1->C1_PRODUTO
			Replace TPOP      With If(Empty(SC1->C1_TPOP),"F",SC1->C1_TPOP)
			Replace DESCRICAO With cDescric
			Replace QUANT     With SC1->C1_QUANT
			Replace PREVISTA  With SC1->C1_DATPRF			//dDataFim
			Replace DATAORI   With SC1->C1_DATPRF
			Replace CC		  With SC1->C1_CC
			Replace CONTA	  With SC1->C1_CONTA
			Replace ITEMCTA	  With SC1->C1_ITEMCTA
			Replace ORDEM     With nTotRegs
			Replace TPSC      With SC1->C1_TPSC
			Replace DESTPSC   With GetDescCmb('C1_TPSC',SC1->C1_TPSC) 
			Replace REGIST    With aRegsOk[nx]
			MsUnlock()
		Next nx
	EndIf
	dbSelectArea(cAliasSC1)
End

dbSelectArea(cAliasSC1)
dbCloseArea()

// Restaura area original
If !Empty(aAreaAFG)
	RestArea(aAReaAFG)
EndIf

dbSelectArea(cAliasOri)

Return

/*����������������������������������������������������������������������������
���Fun��o    �A126Periodo� Autor �Rodrigo de A Sartorio  � Data � 23/12/04 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se as SCs estao no periodo p/ aglutinacao          ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � STCOMSC                                                     ���
����������������������������������������������������������������������������*/

Static Function A126Periodo(dDatRef,dData,nTipo)

Local lRet := .F., nMes

Do Case
	Case nTipo == 1 // Diario
		If dDatRef == dData
			lRet := .T.
		EndIf
	Case nTipo == 2 // Semanal
		If Month(dDatRef) == Month(dData)
			While Dow(dDatRef) != 2
				dDatRef--
			End
			If dData < dDatRef + 7
				lRet := .T.
			EndIf
		EndIf	
	Case nTipo == 3 // Quinzenal
		If Month(dDatRef) == Month(dData)
			If Day(dDatRef) <= 15
				If Day(dData) <= 15
					lRet := .T.
				EndIf
			Else
				If Day(dData) > 15
					lRet := .T.
				EndIf
			EndIf
		EndIf	
	Case nTipo == 4 // Mensal
		If Month(dDatRef) == Month(dData)
			lRet := .T.
		EndIf
	Case nTipo == 5 // Trimestral
		nRef := Month(dDatRef)
		nMes := Month(dData)
		If nRef >= 1 .And. nRef <= 3
			If nMes >= 1 .And. nMes <= 3
				lRet := .T.
			EndIf
		ElseIf nRef >=4 .And. nRef <= 6
			If nMes >=4 .And. nMes <= 6
				lRet := .T.
			EndIf
		ElseIf nRef >=7 .And. nRef <= 9
			If nMes >=7 .And. nMes <= 9
				lRet := .T.
			EndIf
		ElseIf nRef >=10 .And. nRef <= 12
			If nMes >=10 .And. nMes <= 12
				lRet := .T.
			EndIf
		EndIf
	Case nTipo == 6 // Semestral
		If Month(dDatRef) <= 6
			If Month(dData) <= 6
				lRet := .T.
			EndIf
		Else
			If Month(dData) > 6
				lRet := .T.
			EndIf
		EndIf
EndCase

Return lRet

/*����������������������������������������������������������������������������
���Fun��o    �A126Browse � Autor �Rodrigo de A Sartorio  � Data � 23/12/04 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Mostra o Browse para marcacao das SCs                       ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � STCOMSC                                                     ���
����������������������������������������������������������������������������*/

Static Function A126Browse(nTotRegs)

Local aSize		 := MsAdvSize()
Local aObjects 	 := {}
Private lInverte :=.F., oDlg
Private inclui	 := .T.,nOpca := 0

aAdd( aObjects, { 100, 100, .T., .T. } )
aInfo := { aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aObj  := MsObjSize( aInfo, aObjects, .T. )

// Redefinicao do aCampos para utilisar no MarkBrow
aCampos := {{"MARK","A126Marca",STR0013},;		//"Ok"
			{"NUMSC","A126Marca",STR0014},;		//"Solicitacao de Compras"
			{"PRODUTO","A126Marca",STR0015},;	//"Produto"
			{"TPOP","A126Marca",STR0027},;		//"Tipo da Solicitacao"
			{"DESCRICAO","A126Marca",STR0023},;	//"Descricao do Produto"
			{"QUANT","A126Marca",STR0016},;		//"Quantidade"
			{"PREVISTA","A126Marca",STR0025},;  //"Data Prevista"		
			{"DATAORI","A126Marca",STR0024},;	// "Data Original"
			{"DESTPSC","A126Marca",STR0030}}	// "Descri��o do Tipo da SC

dbSelectArea("TRB")
dbGotop()
If Bof() .And. Eof()
	HELP(" ",1,"RECNO")
	Return
Else
	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0017) From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	cAlias := Alias()
	oMark := MsSelect():New(cAlias,"MARK",,aCampos,linverte,cMarca,aObj[1])
	oMark:oBrowse:lCanAllMark:=.T.
	oMark:oBrowse:lHasMark	 :=.T.
	oMark:bMark 			 := {| | A126ESCOL(cMarca,lInverte,oDlg)}
	oMark:oBrowse:bAllMark	 := {| | A126MarkAll(cMarca,oDlg)}
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nopca := 1,If(MTA126OK(),oDlg:End(),)},{||nopca := 0,oDlg:End()})
EndIf

If nOpca == 1
	// Aglutina SCs
	Processa({|lEnd| A126Make(@lEnd,nTotRegs)},cCadastro,OemToAnsi(STR0018),.F.)	//"Aglutinando SCs Selecionadas..."
EndIf

Return

/*����������������������������������������������������������������������������
���Fun��o    � A126Make  � Autor � Ary Medeiros          � Data � 02/06/93 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Grava as SCs aglutinadas, acerta os empenhos e remove as OPs���
���          � antigas do SC1.                                             ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � STCOMSC                                                     ���
����������������������������������������������������������������������������*/

Static Function A126Make(lEnd,nTotRegs)

Local aDeletC1	:= {}
Local aRegs		:= {}
Local nx		:= 0
Local aCampos	:= {}
Local cNumSc	:= ""
Local aNewCampos:= {}
Local lApaga	:= .T.
Local aTipos 	:= {}
Local nPos		:= 0
Local nI		:= 0
Local nI2		:= 0
Local nQtdItem	:= 0
Local aParam	:= {}
Local aRet		:= {}

aAdd(aParam,{1,"Informe a Data Prevista"  ,CtoD(Space(8)),"","","","",50,.F.}) // Data Prevista

If !ParamBox(aParam,"Par�metros",@aRet,,,,,,,,.F.,.F.)
	Return
EndIf

cDatPrev := aRet[1]

dbSelectArea("SC1")
dbSetOrder(2)

ProcRegua(nTotRegs)

dbSelectArea("TRB")
dbSetOrder(1)
dbGotop()

While !Eof()
	If !Empty(TRB->MARK)
		// Array utilizado apenas para deletar os registros que foram marcados para geracao da solicita��o aglutinada
		aAdd(aDeletC1, {TRB->REGIST})
		nPos := aScan( aTipos, {|x| AllTrim(x[1] + x[2]) == AllTrim(TRB->TPSC + TRB->DESTPSC)} )	//  + DtoS(x[3]) ==  + DtoS(TRB->PREVISTA)
		If nPos == 0
			aAdd(aTipos,{TRB->TPSC,TRB->DESTPSC,TRB->PREVISTA,{}})
			nPos := Len(aTipos)		
		EndIf
		nPosA := aScan( aTipos[nPos,4], {|x| AllTrim(x[2] ) == AllTrim(TRB->PRODUTO)} )	// Produto
		If nPosA > 0
			aTipos[1,4,nPosA,3] += TRB->QUANT
		Else
			aAdd(aTipos[nPos,4],{TRB->REGIST,TRB->PRODUTO,TRB->QUANT})
		EndIf
	EndIf				
	dbSkip()	
EndDo

For nI := 1 To Len(aTipos)
	IncProc()
		aRegs		:= aClone(aTipos[nI,4])
		cItem		:= '0000'
		While .T.
			cNumSc := GetNumSC1()	//GetSX8Num("SC1","C1_NUM")      // Numero da ultima Solicitacao de Compra -- comentado estava dando erro de sequencial, alterei para GetNumSC1()
			If SC1->( !dbSeek(xFilial("SC1") + cNumSc) )
				Exit
			EndIf
		EndDo
		// Verifica se o aRegs est� preenchido para efetuar a aglutina��o entre os produtos semelhantes
		For nI2 := 1 To Len(aRegs)
			cItem := Soma1(cItem)
			nQtdItem := aRegs[nI2,3]
			dbSelectArea("SC1")
			SC1->(dbGoto(aRegs[nI2,1]))
			aCampos := {}
			aAdd(aCampos,{"C1_OP"    ,""					})
			aAdd(aCampos,{"C1_NUM"   ,cNumSC				})
			aAdd(aCampos,{"C1_ITEM"  ,cItem					})
			aAdd(aCampos,{"C1_DATPRF",aTipos[nI,3]			})
			aAdd(aCampos,{"C1_OBS"   ,OemToAnsi(STR0026)	})
			// Copia todas as informacoes menos campos contidos no array aCampos
			CopyReg(aCampos)			
			// Ponto de Entrada para alterar valores de outros campos na Aglutinacao
			If ExistBlock("MA126CPO")
				aNewCampos := ExecBlock("MA126CPO",.F.,.F.,{aCampos} )
				For nX := 1 to Len(aNewCampos)
					If ValType(aNewCampos) == "A"
						aAdd(aCampos,aNewCampos[nX])
					EndIf
				Next nX
			EndIf
			SC1->C1_MOTIVO	:= "MRP"
			SC1->C1_CC		:= "115108"
			SC1->C1_DATPRF	:= cDatPrev
			SC1->C1_QUANT	:= nQtdItem
			SC1->C1_QTDORIG	:= nQtdItem
			// Avalia SC criada
			MaAvalSC("SC1",1,NIL,NIL,.F.,.T.)
			// Destrava registros
			SC1->( MsUnlock() )
			// Ponto de Entrada para avaliar a exclusao das SCs relacionadas --- BOPS: 152687
			If ExistBlock("MA126ASC")
				lApaga := ExecBlock("MA126ASC",.F.,.F.,{cNumSC})
				lApaga := Iif(ValType(lApaga) != "L",.T.,lApaga)
			EndIf	
			// Ponto de Entrada apos gravacao da nova SC --- BOPS: 152687
			If ExistBlock("MA126GRV")
				ExecBlock("MA126GRV",.F.,.F.,{cNumSC,aRegs})
			EndIf   		
		Next nI2
		// Apaga todas as SCs relacionadas
		If lApaga
			For nx := 1 to Len(aDeletC1)
				dbSelectArea("SC1")
				SC1->(dbGoto(aDeletC1[nx,1]))
				// Avalia SC que sera excluida
				MaAvalSC("SC1",2,Nil,Nil,.F.,.T.)	
				Reclock("SC1",.F.)
				dbDelete()
				MsUnlock()      
			Next nx             
		EndIf        
		dbSelectArea("TRB")
	//End Transaction    
Next nI

apMsgInfo("Solicita�� de Compra: <FONT COLOR=BLUE SIZE=4><b>" + cNumSc + "</b></FONT> gerada com sucesso.")

Return Nil                                     

/*���������������������������������������������������������������������������
��� Fun��o   �MTA126OK  � Autor �Rodrigo de A. Sartorio � Data � 04/01/96 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Confirmacao antes de executar a Aglutinacao.               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MTA126OK                                                   ���
���������������������������������������������������������������������������*/

Static Function MTA126OK()

Local cText := OemToAnsi(STR0019) + Chr(13)	//"Esta rotina ir� aglutinar as Solicitacoes de Compra"
	  cText += OemToAnsi(STR0020) + Chr(13)	//"conforme os par�metros selecionados."
	  cText += OemToAnsi(STR0021)			//"Confirma a aglutina��o das SCs ?"

Return (MsgYesNo(cText,OemToAnsi(STR0022)))	//"Aten��o"

/*���������������������������������������������������������������������������
���Fun��o    � A126Escol  � Autor �Rodrigo de A.Sartorio� Data � 04/01/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Escolhe as Ops para Aglutinar                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � STCOMSC                                                    ���
���������������������������������������������������������������������������*/

Static Function A126Escol(cMarca,lInverte,oDlg)

If IsMark("MARK",cMarca,lInverte)
	RecLock("TRB",.F.)
	If !lInverte
		Replace TRB->MARK With cMarca
	Else
		Replace TRB->MARK With "  "
	EndIf
	MsUnlock()
Else
	RecLock("TRB",.F.)
	If !lInverte
		Replace TRB->MARK With "  "
	Else
		Replace TRB->MARK With cMarca
	EndIf
	MsUnlock()
EndIf

oDlg:Refresh()

Return .T.

/*���������������������������������������������������������������������������
���Fun��o    � A126MarkAll� Autor �Rodrigo de A.Sartorio� Data � 04/01/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inverte as OPs Marcadas/Desmarcadas                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � STCOMSC                                                    ���
���������������������������������������������������������������������������*/

Static Function A126MarkAll(cMarca,oDlg)

Local nRecno := Recno()

dbGotop()
Do While !Eof()
	RecLock("TRB",.F.)
	If Empty(TRB->MARK)
		Replace TRB->MARK With cMarca
	Else
		Replace TRB->MARK With "  "
	Endif
	MsUnlock()
	dbSkip()
EndDo

dbGoto(nRecno)
oDlg:Refresh()

Return .T.

/*�����������������������������������������������������������������������������
���Fun��o    �CopyReg   � Autor �Rodrigo Sartorio       � Data � 04-04-2003 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao que copia um registro do arquivo.                      ���
���������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                      ���
�����������������������������������������������������������������������������*/

Static Function CopyReg(aCampos)

Local nx
Local aRegistro := {}
Local nPosicao  := 0
Default aCampos	:= {}

// Le as informacoes do registro corrente
For nx := 1 to FCount()
	aAdd(aRegistro,FieldGet(nx))
Next nx                                      

// Efetua a gravacao do novo registro
RecLock(Alias(),.T.)
For nx := 1 to FCount()
	FieldPut(nx,aRegistro[nx])
Next nx

// Altera o conteudo dos campos passados como referencia
For nx := 1 to Len(aCampos)
	nPosicao := FieldPos(aCampos[nx][1])
	If nPosicao > 0
		FieldPut(nPosicao,aCampos[nx][2])
	EndIf
Next nx

Return

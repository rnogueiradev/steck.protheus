#INCLUDE "MATR430.CH"
#INCLUDE "PROTHEUS.CH"


/*/{Protheus.doc} STMatr430
description
	Impressao da Planilha de Formacao de Precos (Steck)
	Origem: MATR430
@type function
@version 
@author Valdemir Rabelo
@since 28/05/2020
@return return_type, return_description
u_STMatr430
/*/
User Function STMatr430()
	Local oReport

	SX1Par('MTR430')						// Valdemir Rabelo 28/05/2020

	If TRepInUse()
		// Interface de impressao                                                  
		oReport := ReportDef()
		oReport:PrintDialog()
		FreeObj(oReport)
	Else
		MATR430R3()
	EndIf

Return



/*/{Protheus.doc} ReportDef
description
	relatorios que poderao ser agendados pelo usuario. 
@type function
@version 
@author Valdemir Rabelo
@since 28/05/2020
@return return_type, return_description
	ExpO1: Objeto do relatorio 
/*/
Static Function ReportDef()

	Local oCell
	Local cPerg	:= "MTR430"
	Local oReport
	Local oSection
	Local nI
	Local cPicQuant	:=PesqPictQt("G1_QUANT",13)
	Local cPicUnit	:=PesqPict("SB1","B1_CUSTD",18)
	Local cPicTot	:=PesqPict("SB1","B1_CUSTD",19)

	// Criacao do componente de impressao                                      
	// TReport():New                                                           
	// ExpC1 : Nome do relatorio                                               
	// ExpC2 : Titulo                                                          
	// ExpC3 : Pergunte                                                        
	// ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  
	// ExpC5 : Descricao                                                       
	                                                                        
	oReport := TReport():New("MATR430",STR0004,, {|oReport| ReportPrint(oReport)},STR0001+" "+STR0002+" "+STR0003)  	//"Emite um relatorio com os calculos da planilha selecionada pa-"##"ra cada produto. Os valores calculados sao os mesmos  referen-"###"tes as formulas da planilha."

	// Verifica as perguntas selecionadas                           
	Pergunte(cPerg,.T.)

	//  Variaveis utilizadas para parametros                         
	//  mv_par01     // Produto inicial                              
	//  mv_par02     // Produto final                                
	//  mv_par03     // Nome da planilha utilizada                   
	//  mv_par04     // Imprime estrutura : Sim / Nao                
	//  mv_par05     // Moeda Secundaria  : 1 2 3 4 5                
	//  mv_par06     // Nivel de detalhamento da estrutura           
	//  mv_par07     // Qual a Quantidade Basica                     
	//  mv_par08     // Considera Qtde Neg na estrutura: Sim/Nao     
	//  mv_par09     // Considera Estrutura / Pre Estrutura          
	//  mv_par10     // Revisao da Estrutura 				         

	//  Forca utilizacao da estrutura caso nao tenha SGG               
	If Select("SGG") == 0
		mv_par09 := 1
	EndIf
	oSection := TRSection():New(oReport,STR0015,{"SB1"}) //"Produtos"
	oSection:SetHeaderPage()

	If UPPER(MV_PAR11)=="R"

		TRCell():New(oSection,"B1_COD"	,"SB1")
		TRCell():New(oSection,"B1_DESC"	,"SB1",,,30)
		TRCell():New(oSection,"TIPO"	,"","Tipo","",2) //"% Part"
		TRCell():New(oSection,"GRUPO"	,"","Grupo","",3) //"% Part"
		TRCell():New(oSection,"CLAPROD","","Class. Prod.","@!",10) //"% Part"
		TRCell():New(oSection,"STDMP"	,"","R$ Mat Std",cPicTot) //"Valor Total"
		TRCell():New(oSection,"STDMBC"	,"","R$ MOD Std MBC",cPicTot) //"Valor Total"
		TRCell():New(oSection,"STDDVC"	,"","R$ MOD Std DVC",cPicTot) //"Valor Total"
		TRCell():New(oSection,"STDBEN"	,"","R$ Benef STD",cPicTot) //"Valor Total"
		TRCell():New(oSection,"STDTOT"	,"","R$ Total Std",cPicTot) //"Valor Total"
		TRCell():New(oSection,"REAMP"	,"","R$ Mat Real",cPicTot) //"Valor Total"
		TRCell():New(oSection,"REAMBC"	,"","R$ MOD Real MBC",cPicTot) //"Valor Total"
		TRCell():New(oSection,"READVC"	,"","R$ MOD Real DVC",cPicTot) //"Valor Total"
		TRCell():New(oSection,"REABEN"	,"","R$ Benef Real",cPicTot) //"Valor Total"
		TRCell():New(oSection,"REATOT"	,"","R$ Total Real",cPicTot) //"Valor Total"

	Else

		If UPPER(MV_PAR12)=="S"

			TRCell():New(oSection,"CEL"		,"",STR0012/*Titulo*/,"99999"/*Picture*/,5/*Tamanho*/,/*lPixel*/,/*{|| Code block }*/) //"Cel."
			TRCell():New(oSection,"NIVEL"	,"",RetTitle("G1_NIV"),"XXXXXX",6)
			TRCell():New(oSection,"B1_COD"	,"SB1")
			TRCell():New(oSection,"B1_DESC"	,"SB1",,,30)
			TRCell():New(oSection,"B1_UM"	,"SB1")
			TRCell():New(oSection,"QUANT"	,"",RetTitle("G1_QUANT"),cPicQuant)

			TRCell():New(oSection,"VALUNI"	,"","Valor Unit Std",cPicUnit) //"Valor Unitario"
			TRCell():New(oSection,"VALTOT"	,"","Valor Total Std",cPicTot) //"Valor Total"
			If UPPER(MV_PAR12)=="N"
				TRCell():New(oSection,"PERCENT","","% PART","999.999",7) //"% Part"
			EndIf

			TRCell():New(oSection,"UNIORI"	,"","Valor Unit Real",cPicUnit) //"Valor Unitario"
			TRCell():New(oSection,"TOTORI"	,"","Valor Total Real",cPicTot) //"Valor Total"
			//TRCell():New(oSection,"PERORI"	,"","% PART",cPicTot) //"Valor Total"

			TRCell():New(oSection,"TIPO","","Tipo","@!",2) //"% Part"
			TRCell():New(oSection,"CLAPROD","","Class. Prod.","@!",10) //"% Part"

			TRCell():New(oSection,"VALUNI2" ,"",STR0013,cPicUnit) //"Valor Unitario"
			TRCell():New(oSection,"VALTOT2" ,"",STR0014,cPicTot) //"Valor Total"

		Else

			TRCell():New(oSection,"CEL"		,"",STR0012/*Titulo*/,"99999"/*Picture*/,5/*Tamanho*/,/*lPixel*/,/*{|| Code block }*/) //"Cel."
			TRCell():New(oSection,"NIVEL"	,"",RetTitle("G1_NIV"),"XXXXXX",6)
			TRCell():New(oSection,"B1_COD"	,"SB1")
			TRCell():New(oSection,"B1_DESC"	,"SB1",,,30)
			TRCell():New(oSection,"B1_UM"	,"SB1")
			TRCell():New(oSection,"QUANT"	,"",RetTitle("G1_QUANT"),cPicQuant)
			TRCell():New(oSection,"VALUNI"	,"",STR0013,cPicUnit) //"Valor Unitario"
			TRCell():New(oSection,"VALTOT"	,"",STR0014,cPicTot) //"Valor Total"
			TRCell():New(oSection,"VALUNI2" ,"",STR0013,cPicUnit) //"Valor Unitario"
			TRCell():New(oSection,"VALTOT2" ,"",STR0014,cPicTot) //"Valor Total"
			TRCell():New(oSection,"PERCENT","",STR0009,"999.999",7) //"% Part"

		EndIf

	EndIf

Return(oReport)


/*/{Protheus.doc} ReportPrint
description
	A funcao estatica ReportDef devera ser criada para todos os
	relatorios que poderao ser agendados pelo usuario. 
@type function
@version 
@author Valdemir Rabelo
@since 28/05/2020
@param oReport, object, param_description
	ExpO1: Objeto Report do Relatorio 
@return return_type, return_description
	Nenhum
/*/
Static Function ReportPrint(oReport)

	Local aArray	:= {}
	Local aArray1	:= {}
	//Local aPar		:= Array(20)
	Local aParC010	:= Array(20)
	Local lFirstCb	:= .T.
	Local nReg
	Local nI, nX
	Local oSection  := oReport:Section(1)
	Local cCondFiltr:= ""
	Local _nX := 0
	Local _lCustoStd := .F.
	Local _nW,_nWy,_nZ

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()

	//  Variaveis privadas exclusivas deste programa                 
	PRIVATE cProg:="R430"  // Usada na funcao externa MontStru()

	//  Custo a ser considerado nos calculos                           
	//  1 = STANDARD    2 = MEDIO     3 = MOEDA2     4 = MOEDA3        
	//  5 = MOEDA4      6 = MOEDA5    7 = ULTPRECO   8 = PLANILHA      
	PRIVATE nQualCusto := 1

	//  Vetor declarado para inversao do calculo do Valor Unitario   
	//  Utilizado no MATC010X -> M010Forma e CalcTot                 
	PRIVATE aAuxCusto

	//  Nome do arquivo que contem a memoria de calculo desta planilha 
	PRIVATE cArqMemo := "STANDARD"

	//  Direcao do calculo .T. para baixo .F. para cima                
	PRIVATE lDirecao := .T.

	PRIVATE lConsNeg := (mv_par08 = 1)     // Esta variavel sera' usada na funcao MC010FORMA

	Private _aCusOri := {}

	Private aPar := Array(20)

	Private _nTotBN   := 0
	Private _nTotMP   := 0
	Private _nTotMOM  := 0
	Private _nTotMOD  := 0
	Private _nTotMP1  := 0
	Private _nTotMOM1 := 0
	Private _nTotMOD1 := 0
	Private _nTotBN1  := 0

	//Salvar variaveis existentes
	For ni := 1 to 20
		aPar[ni] := &("mv_par"+StrZero(ni,2))
	Next ni

	Pergunte("MTC010", .F.)
	//  Forca utilizacao da estrutura caso nao tenha SGG               
	If Select("SGG") == 0
		mv_par09 := 1
	EndIf
	//Salvar variaveis existentes
	For ni := 1 to 20
		aParC010[ni] := &("mv_par"+StrZero(ni,2))
	Next ni
	//Forca mesmo valor do relatorio na pergunta 09
	mv_par09     := aPar[09]
	aParC010[09] := aPar[09]

	// Restaura parametros MTR430
	For ni := 1 to 20
		&("mv_par"+StrZero(ni,2)) := aPar[ni]
	Next ni

	oReport:NoUserFilter()  // Desabilita a aplicacao do filtro do usuario no filtro/query das secoes

	dbSelectArea("SB1")
	// Filtragem do relatorio                                                  
	// Transforma parametros Range em expressao Advpl                          
	MakeAdvplExpr(oReport:uParam)

	//  Mantem o Cad.Produtos posicionado para cada linha impressa da planilha   
	If !(UPPER(MV_PAR11)=="R")
		TRPosition():New(oSection,"SB1",1,{|| xFilial("SB1") + aArray[nX][04] })
	EndIf

	//  Inicializa o nome padrao da planilha com o nome selecionado pelo usuario 
	cArqMemo := apar[03]

	If MR430Plan(.T.,aPar)

		//If MsgYesNo("Deseja rodar o custo standard?")
		//	_lCustoStd := .T.
		//EndIf

		If !(UPPER(MV_PAR11)=="R")
			If apar[05] == 1
				oSection:Cell("VALUNI2"):Disable()
				oSection:Cell("VALTOT2"):Disable()
			EndIf
		EndIf

		// Inicio da impressao do fluxo do relatorio                               
		oReport:SetMeter(SB1->(LastRec()))
		dbSeek(xFilial("SB1")+apar[01],.T.)

		oSection:Init()

		//  Este procedimento e' necessario p/ transformar o filtro selecionado  
		//  pelo usuario em uma condicao de IF, isto porque o filtro age em todo 
		//  o arquivo e devido `a posterior explosao de niveis da estrutura, em  
		//  MATC010X-> M010Forma(), o filtro deve ser validado apenas no While   
		//  principal															 
		cCondFiltr := oSection:GetAdvplExp()
		if Empty(cCondFiltr)
			cCondFiltr := ".T."
		EndIf
		/*
		If !Empty(apar[13])
		cFiltro := "B1_GRUPO = '"+apar[13]+"'"
		SET FILTER TO &(cFiltro)
		EndIf
		*/

		_cQuery1 := " SELECT B1.R_E_C_N_O_ RECSB1
		_cQuery1 += " FROM "+RetSqlName("SB1")+" B1
		_cQuery1 += " WHERE B1.D_E_L_E_T_=' ' AND B1_COD BETWEEN '"+apar[01]+"'
		_cQuery1 += " AND '"+apar[02]+"'

		If !Empty(apar[13])
			_cQuery1 += " AND B1_GRUPO='"+apar[13]+"'
		EndIf
		// ---- Valdemir Rabelo 29/05/2020 ----
		if apar[14]==1
		   cDATA1 := CVALTOCHAR(YEAR(dDATABASE)-1)+'0101'
		   cDATA2 := CVALTOCHAR(YEAR(dDATABASE)-1)+'1231'
			_cQuery1 += " AND (SELECT COUNT(C5_EMISSAO)  " + CRLF
			_cQuery1 += "       FROM "+RETSQLNAME("SC5") + " C5 " + CRLF
			_cQuery1 += "		INNER JOIN "+RETSQLNAME("SC6")+" C6 " + CRLF
			_cQuery1 += "       ON C5.C5_FILIAL=C6.C6_FILIAL AND C5.C5_NUM=C6.C6_NUM  AND C6.D_E_L_E_T_ = '  '  " + CRLF
			_cQuery1 += "		WHERE C5.D_E_L_E_T_ = '  ' " + CRLF
			_cQuery1 += "		 AND C5.C5_EMISSAO BETWEEN '"+cDATA1+"' AND '"+cDATA2+"' AND C6_PRODUTO=B1.B1_COD) > 0 " + CRLF			
		endif 
		if apar[15]==1
			_cQuery1 += " AND (SELECT COUNT(G1_COD) REG FROM " + RETSQLNAME("SG1") + " G1 " + CRLF	
			_cQuery1 += " WHERE G1.D_E_L_E_T_ = ' ' AND G1.G1_FILIAL='"+XFILIAL("SG1")+"' AND G1.G1_COD=B1.B1_COD ) > 1 " + CRLF	
		endif 
		// ------

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		_aRecnos := {}

		While (_cAlias1)->(!Eof())
			AADD(_aRecnos,(_cAlias1)->RECSB1)
			(_cAlias1)->(DbSkip())
		EndDo

		For _nZ:=1 To Len(_aRecnos)

			//While !oReport:Cancel() .And. !SB1->(Eof()) .And. ;
			//		SB1->B1_FILIAL == xFilial("SB1") .And. SB1->B1_COD <= apar[02]

			//DbSelectArea("SB1")
			//DbCloseAll()
			//DbSelectArea("SB1")
			SB1->(DbGoTo(_aRecnos[_nZ]))

			If oReport:Cancel()
				Exit
			EndIf
			// Considera filtro escolhido                                   
			If &(cCondFiltr)
				nReg := SB1->(Recno())

				// Restaura parametros MTC010
				For ni := 1 to 20
					&("mv_par"+StrZero(ni,2)) := aParc010[ni]
				Next ni

				aArray1 := u_STMC010Forma("SB1",nReg,99,apar[07],,.F.,apar[10],_lCustoStd)
				aArray2 := AClone(aArray1)

				If UPPER(aPar[12])=="S"
					aArray1 := U_STCUSSTD(aArray1,aArray2)
				EndIf

				// Restaura parametros MTR430
				For ni := 1 to 20
					&("mv_par"+StrZero(ni,2)) := aPar[ni]
				Next ni

				If Len(aArray1) > 0
					If UPPER(MV_PAR11)=="R"
						oSection:Cell("B1_COD"):SetValue(SB1->B1_COD)
						oSection:Cell("B1_DESC"):SetValue(SB1->B1_DESC)
						oSection:Cell("TIPO"):SetValue(SB1->B1_TIPO)
						oSection:Cell("GRUPO"):SetValue(SB1->B1_GRUPO)
						oSection:Cell("CLAPROD"):SetValue(GETDESC(SB1->B1_CLAPROD))
						oSection:Cell("STDMP"):SetValue(_nTotMP)
						oSection:Cell("STDMBC"):SetValue(_nTotMOM)
						oSection:Cell("STDDVC"):SetValue(_nTotMOD)
						oSection:Cell("STDBEN"):SetValue(_nTotBN)     // Estava '0' e colocado valor Benef. 29/07/2020 - Valdemir
						oSection:Cell("STDTOT"):SetValue(_nTotMP+_nTotMOM+_nTotMOD+_nTotBN)
						oSection:Cell("REAMP"):SetValue(_nTotMP1)
						oSection:Cell("REAMBC"):SetValue(_nTotMOM1)
						oSection:Cell("READVC"):SetValue(_nTotMOD1)
						oSection:Cell("REABEN"):SetValue(_nTotBN1)
						oSection:Cell("REATOT"):SetValue(_nTotMP1+_nTotMOM1+_nTotMOD1+_nTotBN1)
						oSection:PrintLine()
					Else
						aArray	:= aClone(aArray1[2])
						MR430ImpTR(aArray1[1],aArray1[2],aArray1[3],oReport,aPar,aParC010,@nx,@lFirstCb,aArray2[1])
					EndIf
				EndIf

				dbSelectArea("SB1")
				dbGoTo(nReg)
			EndIf
			//(_cAlias1)->(dbSkip())
			oReport:IncMeter()
			//EndDo
		Next
		oSection:Finish()
	EndIf
	dbSelectArea("SB1")
	dbClearFilter()
	dbSetOrder(1)

Return NIL

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДїпїЅпїЅ
пїЅпїЅпїЅFunпїЅпїЅo    пїЅMR430ImpTRпїЅ Autor пїЅ Ricardo Berti 		пїЅ Data пїЅ07.07.2006пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДґпїЅпїЅ
пїЅпїЅпїЅDescriпїЅпїЅo пїЅ Imprime os dados ja' calculados                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДґпїЅпїЅ
пїЅпїЅпїЅSintaxe   пїЅ MR430ImpTR(ExpC1,ExpA1,ExpN1,ExpO1,ExpA2,ExpA3,ExpN2)      пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДґпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДґпїЅпїЅ
пїЅпїЅпїЅ Uso      пїЅ MATR430                                                    пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅЩ±пїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

/*/{Protheus.doc} MR430ImpTR
description
	Imprime os dados ja' calculados 
@type function
@version 
@author Valdemir Rabelo
@since 28/05/2020
@param cCusto, character, param_description
	Parametros ExpC1 = Titulo do custo utilizado                          
			   ExpA1 = Array com os dados ja' calculados                  
			   ExpN1 = Numero do elemento inicial a imprimir              
			   ExpO1 = obj Report                                         
			   ExpA2 = Array com os parametros de MTR430                  
			   ExpA2 = Array com os parametros de MTC010                  
			   ExpN2 = elemento do aArray, passado por referencia		  
			   ExpL1 = indica primeiro acesso, para montagem de cabec.	  

@return return_type, return_description
/*/
Static Function MR430ImpTR(cCusto,aArray,nPosForm,oReport,aPar,aParC010,nx,lFirstCb)

	Local oSection  := oReport:Section(1)
	LOCAL cMoeda1,cMoeda2
	LOCAL nDecimal	:=0
	Local lFirst	:= .T.
	Local cOldAlias
	Local nOrder
	Local nRecno
	Local nValUnit, nCotacao
	Local cTit1,cTit2,cTit3,cTit4
	Local _nW := 0

	DEFAULT lFirstCb := .T.

	cCusto := If(cCusto=Nil,'',AllTrim(Upper(cCusto)))
	If cCusto == 'ULT PRECO'
		nDecimal := TamSX3('B1_UPRC')[2]
	ElseIf 'MEDIO' $ cCusto
		nDecimal := TamSX3('B2_CM1')[2]
	Else
		nDecimal := TamSX3('B1_CUSTD')[2]
	EndIf

	// De acordo com o custo da planilha lida monta a cotacao de    
	// conversao e a variavel cMoeda1 usada no cabecalho.           
	If Str(nQualCusto,1) $ "3/4/5/6"
		nCotacao:=ConvMoeda(dDataBase,,1,Str(nQualCusto-1,1))
		cMoeda1	:=GetMV("MV_SIMB"+Str(nQualCusto-1,1,0))
		If Empty(cMoeda1)
			cMoeda1	:=GetMV("MV_MOEDA"+Str(nQualCusto-1,1,0))
		EndIf
	Else
		nCotacao:=1
		cMoeda1	:=GetMV("MV_SIMB1")
	EndIf

	If lFirstCb
		cMoeda1	:= PADC(Alltrim(cMoeda1),12)
		cTit1:=oSection:Cell("VALUNI"):Title()
		cTit2:=oSection:Cell("VALTOT"):Title()
		oSection:Cell("VALUNI"):SetTitle(cTit1+CRLF+cMoeda1) //"Valor Unitario"
		oSection:Cell("VALTOT"):SetTitle(cTit2+CRLF+cMoeda1) //"Valor Total"
		lFirstCb := .F.
	EndIf

	If apar[05] <> 1
		// De acordo com o parametro da segunda moeda (mv_par05) remonta
		// os titulos de valores no cabecalho p/ moeda secundaria		 
		cMoeda2	:= GetMV("MV_SIMB"+Str(apar[05],1,0))
		If Empty(cMoeda2)
			cMoeda2 := GetMV("MV_MOEDA"+Str(apar[05],1,0))
		EndIf
		cMoeda2	:= PADC(Alltrim(cMoeda2),12)
		cTit3:= oSection:Cell("VALUNI2"):Title()
		cTit4:= oSection:Cell("VALTOT2"):Title()
		oSection:Cell("VALUNI2"):SetTitle(cTit3+CRLF+PadC(AllTrim(cMoeda2),12)) 	//"Valor Unitario"
		oSection:Cell("VALTOT2"):SetTitle(cTit4+CRLF+PadC(AllTrim(cMoeda2),12)) 	//"Valor Total"
	EndIf

	For nX := 1 To Len(aArray)
		//  Verifica o nivel da estrutura para ser impresso ou nao  
		If apar[04] == 1
			If Val(apar[06]) != 0
				If Val(aArray[nX,2]) > Val(apar[06])
					Loop
				Endif
			Endif
		Endif

		If If( (Len(aArray[ nX ])==12),aArray[nX,12],.T. )

			If lFirst
				oReport:SkipLine()
				lFirst := .F.
			EndIf
			oSection:Cell("CEL"):SetValue(aArray[nX][01])
			oSection:Cell("NIVEL"):SetValue(aArray[nX][02])
			oSection:Cell("B1_COD"):SetValue(aArray[nX][04])
			If UPPER(MV_PAR12)=="S"
				If !("---" $ aArray[nX][2])
					oSection:Cell("TIPO"):SetValue(aArray[nX][09])

					_aArea := GetArea()

					SB1->(DbSetOrder(1))
					SB1->(DbGoTop())
					If SB1->(DbSeek(xFilial("SB1")+aArray[nX][04]))
						oSection:Cell("CLAPROD"):SetValue(GETDESC(SB1->B1_CLAPROD))
					EndIF

					RestArea(_aArea)

				Else
					oSection:Cell("TIPO"):SetValue("")
					oSection:Cell("CLAPROD"):SetValue("")
				EndIf
			EndIf

			oSection:Cell("B1_DESC"):SetValue(aArray[nX][03])
			If aArray[nX][04] == Replicate("-",15)
				oSection:Cell("VALTOT"):Hide()
				If UPPER(MV_PAR12)=="N"
					oSection:Cell("PERCENT"):Hide()
				EndIf
				If UPPER(MV_PAR12)=="S"
					oSection:Cell("TOTORI"):Hide()
				EndIf
				//oSection:Cell("PERORI"):Hide()
				If apar[05] <> 1
					oSection:Cell("VALUNI2"):Hide()
					oSection:Cell("VALTOT2"):Hide()
				EndIf
			Else
				If nX < nPosForm-1
					If aParc010[02] == 1
						nValUnit := Round(aAuxCusto[nX]/aArray[nX][05], nDecimal)
					Else
						nValUnit := NoRound(aAuxCusto[nX]/aArray[nX][05], nDecimal)
					EndIf
				EndIf

				_nCusOri :=  0

				For _nW:=1 To Len(_aCusOri)
					If AllTrim(_aCusOri[_nW][1])==AllTrim(aArray[nX][04])
						_nCusOri := _aCusOri[_nW][2]
						Exit
					EndIf
				Next

				If UPPER(MV_PAR12)=="S"
					oSection:Cell("UNIORI"):SetValue(aArray2[2][nX][06]/aArray2[2][nX][05])
					oSection:Cell("TOTORI"):SetValue(aArray2[2][nX][06])
					oSection:Cell("TOTORI"):Show()
				EndIf

				oSection:Cell("VALTOT"):SetValue(aArray[nX][06])
				If UPPER(MV_PAR12)=="N"
					oSection:Cell("PERCENT"):SetValue(aArray[nX][07])
				EndIf
				oSection:Cell("VALTOT"):Show()
				If UPPER(MV_PAR12)=="N"
					oSection:Cell("PERCENT"):Show()
				EndIf
				If apar[05] <> 1
					If nX < nPosForm-1
						oSection:Cell("VALUNI2"):SetValue(Round(ConvMoeda(dDataBase,,nValUnit/nCotacao,Str(apar[05],1)), nDecimal))
						oSection:Cell("VALUNI2"):Show()
					Else
						oSection:Cell("VALUNI2"):Hide()
					EndIf
					oSection:Cell("VALTOT2"):SetValue(ConvMoeda(dDataBase,,(aArray[nX][06]/nCotacao),Str(apar[05],1)))
					oSection:Cell("VALTOT2"):Show()
				EndIf
			EndIf
			If aArray[nX][04] == Replicate("-",15) .Or. nX >= nPosForm-1
				oSection:Cell("B1_UM"):Hide()
				oSection:Cell("QUANT"):Hide()
				oSection:Cell("VALUNI"):Hide()
				If UPPER(MV_PAR12)=="S"
					oSection:Cell("UNIORI"):Hide()
				EndIf
			Else
				oSection:Cell("B1_UM"):Show()
				oSection:Cell("QUANT"):Show()
				oSection:Cell("VALUNI"):Show()
				cOldAlias:=Alias()
				dbSelectArea("SB1")
				nOrder:=IndexOrd()
				nRecno:=Recno()
				dbSetOrder(1)
				dbSeek(xFilial()+aArray[nX][04])
				oSection:Cell("B1_UM"):SetValue(SB1->B1_UM)
				dbSetOrder(nOrder)
				dbGoTo(nRecno)
				dbSelectArea(cOldAlias)
				oSection:Cell("QUANT"):SetValue(aArray[nX][05])
				oSection:Cell("VALUNI"):SetValue(nValUnit)

			EndIf

			oSection:PrintLine()

			If nX == 1 .And. apar[04] == 2
				nX += (nPosForm-3)
			EndIf
		EndIf
	Next
	If !lFirst
		oReport:ThinLine()
	EndIf

Return NIL


/*/{Protheus.doc} MATR430R3
description
	Impressao da Planilha de Formacao de Precos
@type function
@version 
@author Valdemir Rabelo
@since 28/05/2020
@return return_type, return_description
/*/
Static Function MATR430R3()
	// Define Variaveis                                             
	LOCAL Tamanho
	LOCAL cDesc1   := STR0001	//"Emite um relatorio com os calculos da planilha selecionada pa-"
	LOCAL cDesc2   := STR0002	//"ra cada produto. Os valores calculados sao os mesmos  referen-"
	LOCAL cDesc3   := STR0003	//"tes as formulas da planilha."
	LOCAL cString  := "SB1"
	LOCAL nI       := 0

	// Estas variaveis foram deixadas em separado para lembrar que  
	// elas devem ser definidas novamente na funcao MR430Impr()     
	LOCAL titulo   := OemToAnsi(STR0004)	//"Planilha de Formacao de Precos"
	LOCAL wnrel := "MATR430"

	// Variaveis tipo Private padrao de todos os relatorios         
	PRIVATE aReturn := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
	PRIVATE nLastKey := 0 ,cPerg := "MTR430",aPar:=Array(20),aParC010:=Array(20)

	// Verifica as perguntas selecionadas                           
	// Variaveis utilizadas para parametros                         
	// mv_par01     // Produto inicial                              
	// mv_par02     // Produto final                                
	// mv_par03     // Nome da planilha utilizada                   
	// mv_par04     // Imprime estrutura : Sim / Nao                
	// mv_par05     // Moeda Secundaria  : 1 2 3 4 5                
	// mv_par06     // Nivel de detalhamento da estrutura           
	// mv_par07     // Qual a Quantidade Basica                     
	// mv_par08     // Considera Qtde Neg na estrutura: Sim/Nao     
	// mv_par09     // Considera Estrutura / Pre Estrutura          
	pergunte(cPerg,.F.)
	// Forca utilizacao da estrutura caso nao tenha SGG               
	If Select("SGG") == 0
		mv_par09:=1
	EndIf
	//Salvar variaveis existentes
	For ni := 1 to 20
		aPar[ni] := &("mv_par"+StrZero(ni,2))
	Next ni

	Tamanho := IIF(apar[05]==1,"M","G")

	// Envia controle para a funcao SETPRINT                        
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

	If nLastKey = 27
		Set Filter to
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey = 27
		Set Filter to
		Return
	Endif

	//Salvar variaveis existentes
	For ni := 1 to 20
		aPar[ni] := &("mv_par"+StrZero(ni,2))
	Next ni

	RptStatus({|lEnd| C430Imp(@lEnd,wnRel,cString,titulo,Tamanho)},titulo)

Return NIL



/*/{Protheus.doc} C430Imp
description
	Chamada do Relatorio 
@type function
@version 
@author Valdemir Rabelo
@since 28/05/2020
/*/
Static Function C430Imp(lEnd,WnRel,cString,titulo,Tamanho)

	// Variaveis locais exclusivas deste programa                  
	LOCAL cRodaTxt := ""
	LOCAL nCntImpr := 0,nReg
	LOCAL aArray   := {} ,cCondFiltr,lRet
	LOCAL nI       := 0
	LOCAL cProdFim :=""
	// Contadores de linha e pagina                                 
	PRIVATE li := 80 ,m_pag := 1,cProg:="R430"

	// Variaveis privadas exclusivas deste programa                 
	// Custo a ser considerado nos calculos                           
	// 1 = STANDARD    2 = MEDIO     3 = MOEDA2     4 = MOEDA3        
	// 5 = MOEDA4      6 = MOEDA5    7 = ULTPRECO   8 = PLANILHA      
	PRIVATE nQualCusto := 1

	// Vetor declarado para inversao do calculo do Valor Unitario   
	// Utilizado no MATC010X -> M010Forma e CalcTot                 
	PRIVATE aAuxCusto

	
	// Nome do arquivo que contem a memoria de calculo desta planilha 	
	PRIVATE cArqMemo := "STANDARD"

	// Direcao do calculo .T. para baixo .F. para cima                
	PRIVATE lDirecao := .T.

	PRIVATE lConsNeg := apar[08] = 1     // Esta variavel serпїЅ usada na funпїЅпїЅo MC010FORMA

	PERGUNTE("MTC010", .F.)
	// Forca utilizacao da estrutura caso nao tenha SGG               
	If Select("SGG") == 0
		mv_par09:=1
	EndIf
	//Salvar variaveis existentes
	For ni := 1 to 20
		aParC010[ni] := &("mv_par"+StrZero(ni,2))
	Next ni
	//Forca mesmo valor do relatorio na pergunta 09
	mv_par09     := aPar[09]
	aParC010[09] := aPar[09]

	// Este procedimento foi necessario para transformar o filtro sele- 
	// cionado pelo usuario em uma condicao de IF ,isto porque o filtro 
	// age em todo o arquivo e eu preciso dele apenas no While principal
	cCondFiltr := aReturn[7]
	If Empty(cCondFiltr)
		cCondFiltr := ".T."
	EndIf

	DbSelectArea("SB1")
	Set Filter to

	// Inicializa o nome padrao da planilha com o nome selecionado pelo 
	// usuario                                                          
	cArqMemo := apar[03]

	// Inicializa os codigos de caracter Comprimido/Normal da impressora 
	nTipo  := IIF(aReturn[4]==1,15,18)

	dbSelectArea("SB1")
	SetRegua(LastRec())

	Set SoftSeek On
	dbSeek(xFilial()+apar[01])
	Set SoftSeek Off
	lRet:=MR430Plan(.T.,aPar)
	IF !lRet
		SET DEVICE TO SCREEN
		Return Nil
	ENDIF

	cProdFim:=apar[02]

	While !EOF() .And. B1_FILIAL+B1_COD <= xFilial()+cProdFim .And. lRet

		If lEnd
			@ PROW()+1,001 PSay STR0007		//"CANCELADO PELO OPERADOR"
			Exit
		EndIf

		IncRegua()
		nReg := Recno()
		// Considera filtro escolhido                                   
		If &(cCondFiltr)
			aArray := MC010Forma(cString,nReg,99,apar[07],,.F.,apar[10])
			If Len(aArray) > 0
				MR430Impr(aArray[1],aArray[2],aArray[3])
			EndIf
			dbGoTo(nReg)
		EndIf

		dbSelectArea("SB1")
		dbSkip()
	End

	If li != 80 .And. lRet
		Roda(nCntImpr,cRodaTxt,Tamanho)
	EndIf

	// Devolve a condicao original do arquivo principal             
	dbSelectArea(cString)
	Set Filter To
	Set Order To 1

	If aReturn[5] = 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	Endif

	MS_FLUSH()



/*/{Protheus.doc} MR430Impr
description
	Imprime os dados ja' calculados 
@type function
@version 
@author Valdemir Rabelo
@since 28/05/2020
@param 
Parametros ExpC1 = Titulo do custo utilizado                          
           ExpA1 = Array com os dados ja' calculados                  
           ExpN1 = Numero do elemento inicial a imprimir  
@param aArray, array, param_description
@param nPosForm, numeric, param_description
@return return_type, return_description
/*/
Static Function MR430Impr(cCusto,aArray,nPosForm)
	LOCAL nX
	LOCAL nCotacao,nValUnit,nValUnit2
	LOCAL cPicQuant:=PesqPictQt("G1_QUANT",13)
	LOCAL cPicUnit :=PesqPict("SB1","B1_CUSTD",18)
	LOCAL cPicTot	:=PesqPict("SB1","B1_CUSTD",19)
	LOCAL cMoeda1,cMoeda2
	Local nDecimal :=0
	LOCAL nI       :=0

	// Estas variaveis foram deixadas em separado para lembrar que  
	// elas foram definidas no programa principal MATR430 e estao   
	// sendo redefinidas para nao ter que defini-las como PRIVATE.  
	LOCAL Tamanho  := IIF(apar[05]==1,"M","G")
	LOCAL titulo   := STR0004		//"Planilha de Formacao de Precos"
	LOCAL nTipo    := 0
	LOCAL wnrel := "MATR430"
	LOCAL cOldAlias,nOrder,nRecno
	LOCAL cabec1,cabec2
	LOCAL Limite   := IIF(apar[05]==1,132,220)

	cCusto := If(cCusto=Nil,'',AllTrim(Upper(cCusto)))
	If cCusto == 'ULT PRECO'
		nDecimal := TamSX3('B1_UPRC')[2]
	ElseIf 'MEDIO' $ cCusto
		nDecimal := TamSX3('B2_CM1')[2]
	Else
		nDecimal := TamSX3('B1_CUSTD')[2]
	EndIf

	// De acordo com o custo da planilha lida monta a cotacao de    
	// conversao e a variavel cMoeda1 usada no cabecalho.           
	If Str(nQualCusto,1) $ "3/4/5/6"
		nCotacao:=ConvMoeda(dDataBase,,1,Str(nQualCusto-1,1))
		cMoeda1:=GetMV("MV_MOEDA"+Str(nQualCusto-1,1,0))
	Else
		nCotacao:=1
		cMoeda1:=GetMV("MV_MOEDA1")
	EndIf
	cMoeda1:=PADC(Alltrim(cMoeda1),35)

	// De acordo com o parametro da segunda moeda (mv_par05) monta  
	// a variavel cMoeda2 usada no cabecalho.                       
	cMoeda2:=PADC(Alltrim(GetMV("MV_MOEDA"+Str(apar[05],1,0))),38)

	// Monta os Cabecalhos de acordo com a moeda                    
	If apar[05] == 1
		Cabec1 := STR0008+cMoeda1+STR0009			//"CEL.  NIVEL  CODIGO          DESCRICAO                      UM    QUANTIDADE "###"% PART"
		Cabec2 := STR0011										//"                                                                              VALOR UNITARIO      VALOR TOTAL"
	Else
		Cabec1 := STR0008+cMoeda1+cMoeda2+STR0009	//"CEL.  NIVEL  CODIGO          DESCRICAO                      UM    QUANTIDADE "###"% PART"
		Cabec2 := STR0010										//"                                                                              VALOR UNITARIO      VALOR TOTAL   VALOR UNITARIO       VALOR TOTAL"
	Endif
	********                                           99999 999999 123456789012345 123456789012345678901234567890 12 9999999999.99 9.999.999.999,99 99.999.999.999,99 9.999.999.999,99 99.999.999.999,99 999.99
	********   														0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15
	********   														01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901

	// Inicializa os codigos de caracter Comprimido/Normal da impressora 
	nTipo  := IIF(aReturn[4]==1,15,18)

	For nX := 1 To Len(aArray)
		// Verifica o nivel da estrutura para ser impresso ou nao  
		If apar[04] == 1
			If Val(apar[06]) != 0
				If Val(aArray[nX,2]) > Val(apar[06])
					Loop
				Endif
			Endif
		Endif

		If If( (Len(aArray[ nX ])==12),aArray[nX,12],.T. )
			If li > 60
				// Restaura variaveis existentes
				For ni := 1 to 20
					&("mv_par"+StrZero(ni,2)) := aPar[ni]
				Next ni
				Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				// Restaura variaveis existentes
				For ni := 1 to 20
					&("mv_par"+StrZero(ni,2)) := aParc010[ni]
				Next ni
			EndIf
			If nX < nPosForm-1
				If mv_par02 == 1
					nValUnit := Round(aAuxCusto[nX]/aArray[nX][05], nDecimal)
				Else
					nValUnit := NoRound(aAuxCusto[nX]/aArray[nX][05], nDecimal)
				EndIf
				nValUnit2:= Round(ConvMoeda(dDataBase,,nValUnit/nCotacao,Str(apar[05],1)), nDecimal)
			EndIf
			@ li,000 PSay aArray[nX][01] Picture "99999"
			@ li,006 PSay aArray[nX][02]
			@ li,013 PSay aArray[nX][04]
			@ li,029 PSay Left(aArray[nX][03],30)
			If aArray[nX][04] != Replicate("-",15)
				If nX < nPosForm-1
					// Posiciona na UM correta do produto 
					cOldAlias:=Alias()
					dbSelectArea("SB1")
					nOrder:=IndexOrd()
					nRecno:=Recno()
					dbSetOrder(1)
					dbSeek(xFilial()+aArray[nX][04])
					@ li,068 PSay SB1->B1_UM
					dbSetOrder(nOrder)
					dbGoTo(nRecno)
					dbSelectArea(cOldAlias)
					@ li,072 PSay aArray[nX][05] Picture cPicQuant
					@ li,087 PSay nValUnit Picture cPicUnit
				EndIf
				@ li,105 PSay aArray[nX][06] Picture cPictot
				If apar[05] == 1
					@ li,125 PSay aArray[nX][07] Picture "999.999"
				Else
					If nX < nPosForm-1
						@ li,125 PSay nValUnit2 Picture cPicUnit
					EndIf
					@ li,143 PSay ConvMoeda(dDataBase,,(aArray[nX][06]/nCotacao),Str(apar[05],1)) Picture cPictot
					@ li,163 PSay aArray[nX][07] Picture "999.999"
				Endif
			EndIf
			li++
			If nX == 1 .And. apar[04] == 2
				nX += (nPosForm-3)
			EndIf
		EndIf
	Next nX
	@ li,000 PSay Replicate("-",Limite)
	li += 2



/*/{Protheus.doc} MR430Plan
description
	Verifica se a Planilha escolhida existe 
@type function
@version 
@author Valdemir Rabelo
@since 28/05/2020
@param lGravado, logical, param_description
@param aPar, array, param_description
@return return_type, return_description
/*/
Static Function MR430Plan(lGravado,aPar)
	Local cArq := ""
	Local lRet := .T.
	DEFAULT lGravado:=.F.
	cArq:=AllTrim(If(lGravado,apar[03],&(ReadVar())))+".PDV"
	If !File(cArq)
		Help(" ",1,"MR430NOPLA")
		lRet := .F.
	EndIf
Return (lRet)

Static Function GETDESC(_cCod)

	Local _cDesc := ""

	_cCod := AllTrim(_cCod)

	Do Case
		Case _cCod=="C"
		_cDesc := "Comprado"
		Case _cCod=="F"
		_cDesc := "Fabricado"
		Case _cCod=="I"
		_cDesc := "Importado"
	EndCase

Return(_cDesc)


/*/{Protheus.doc} SX1Par
description
	Gera Parametros (Filtro)
@type function
@version 
@author Valdemir Rabelo
@since 28/05/2020
@param pcPerg, param_type, param_description
@return return_type, return_description
/*/
Static Function SX1Par(pcPerg)
    Local cAllPerg := ""
    Local aHelp    := {}
    Local cAllhlp  := ""
    Local oParamet := Nil

	// Chamada via Json
    cAllPerg := '{"AllPerg": [ '
    cAllPerg += '{"X1_PERGUNT": "Produto De", 		  "X1_TIPO": "C", "X1_TAMANHO": 15, "X1_DECIMAL": 0, "X1_PRESEL": 0, "X1_GSC": "G", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "SB1", "X1_PYME": "S"},  '
    cAllPerg += '{"X1_PERGUNT": "Produto Ate", 		  "X1_TIPO": "C", "X1_TAMANHO": 15, "X1_DECIMAL": 0, "X1_PRESEL": 0, "X1_GSC": "G", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "SB1", "X1_PYME": "S"},  '
    cAllPerg += '{"X1_PERGUNT": "Nome da Planilha ?", "X1_TIPO": "C", "X1_TAMANHO": 08, "X1_DECIMAL": 0, "X1_PRESEL": 0, "X1_GSC": "G", "X1_VALID": "MR430Plan", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": "S"},  '
    cAllPerg += '{"X1_PERGUNT": "Imprime estrutura ?","X1_TIPO": "N", "X1_TAMANHO": 01, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "C", "X1_VALID": "", "X1_DEF01": "Sim", "X1_DEF02": "Nгo", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": "S"},  '
    cAllPerg += '{"X1_PERGUNT": "Moeda Secundaria  ?","X1_TIPO": "N", "X1_TAMANHO": 01, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "C", "X1_VALID": "", "X1_DEF01": "Moeda 1", "X1_DEF02": "Moeda 2", "X1_DEF03": "Moeda 3", "X1_DEF04": "Moeda 4", "X1_DEF05": "Moeda 5", "X1_F3": "", "X1_PYME": "S"},  '
    cAllPerg += '{"X1_PERGUNT": "Atй Nнvel Det.?",	  "X1_TIPO": "C", "X1_TAMANHO": 03, "X1_DECIMAL": 0, "X1_PRESEL": 0, "X1_GSC": "G", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "SB1", "X1_PYME": "S"},  '
    cAllPerg += '{"X1_PERGUNT": "Quantidade Basica ?","X1_TIPO": "N", "X1_TAMANHO": 06, "X1_DECIMAL": 0, "X1_PRESEL": 0, "X1_GSC": "G", "X1_VALID": "naovazio", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": "S"},  '
    cAllPerg += '{"X1_PERGUNT": "Considera Qtd. Neg.?", "X1_TIPO": "N", "X1_TAMANHO": 1, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "C", "X1_VALID": "", "X1_DEF01": "Sim", "X1_DEF02": "Nгo", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": "S"},  '
    cAllPerg += '{"X1_PERGUNT": "Mostra ?", 			"X1_TIPO": "N", "X1_TAMANHO": 1, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "C", "X1_VALID": "", "X1_DEF01": "Estrutura", "X1_DEF02": "Pre-Estrutura", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": "N"},  '
    cAllPerg += '{"X1_PERGUNT": "Qual Revisao da Estrutura ?", "X1_TIPO": "C", "X1_TAMANHO": 03, "X1_DECIMAL": 0, "X1_PRESEL": 0, "X1_GSC": "G", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": "N"},  '
    cAllPerg += '{"X1_PERGUNT": "Completo(C) ou Resumido(R)", 	"X1_TIPO": "C", "X1_TAMANHO": 01, "X1_DECIMAL": 0, "X1_PRESEL": 0, "X1_GSC": "G", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": ""},  '
    cAllPerg += '{"X1_PERGUNT": "Standard(S) ou Normal(N)", 	"X1_TIPO": "C", "X1_TAMANHO": 01, "X1_DECIMAL": 0, "X1_PRESEL": 0, "X1_GSC": "G", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": ""},  '
    cAllPerg += '{"X1_PERGUNT": "Grupo", 						"X1_TIPO": "C", "X1_TAMANHO": 04, "X1_DECIMAL": 0, "X1_PRESEL": 0, "X1_GSC": "G", "X1_VALID": "", "X1_DEF01": "", "X1_DEF02": "", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "SBM", "X1_PYME": ""},  '
    cAllPerg += '{"X1_PERGUNT": "Venda ultimo ano", "X1_TIPO": "N", "X1_TAMANHO": 1, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "C", "X1_VALID": "", "X1_DEF01": "Sim", "X1_DEF02": "Nгo", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": "S"},  '
    cAllPerg += '{"X1_PERGUNT": "Tem Estrutura", "X1_TIPO": "N", "X1_TAMANHO": 1, "X1_DECIMAL": 0, "X1_PRESEL": 1, "X1_GSC": "C", "X1_VALID": "", "X1_DEF01": "Sim", "X1_DEF02": "Nгo", "X1_DEF03": "", "X1_DEF04": "", "X1_DEF05": "", "X1_F3": "", "X1_PYME": "S"}  '
    cAllPerg += '] }    '

    aAdd(aHelp, "Informe o Cуdigo do produto Inicial")
    aAdd(aHelp, "Informe o Cуdigo do produto Final")
    aAdd(aHelp, "Informe o o nome da planilha")
	aAdd(aHelp, "Informe se deseja imprimir a estrutura")
	aAdd(aHelp, "Informe a Moeda Secundбria")
	aAdd(aHelp, "Informe atй o Nнvel de Detalhamento")
	aAdd(aHelp, "Informe a quantidade basica")
	aAdd(aHelp, "Informe se considera quantidade negativa")
	aAdd(aHelp, "Selecione opзгo se mostra estrutura/pre-estrutura")
	aAdd(aHelp, "Informe a revisгo da estrutura")
	aAdd(aHelp, "Informe Completo(C) ou Resumido(R)")
	aAdd(aHelp, "Informe Standard(S) ou Normal(N)")
	aAdd(aHelp, "Informe o grupo")
    aAdd(aHelp, "Verifica se houve venda no ultimo ano")
    aAdd(aHelp, "Verificar se tem estrutura")

    oParamet := EVParame():New(pcPerg, cAllPerg, aHelp)
    oParamet:Activate(.F.)

Return
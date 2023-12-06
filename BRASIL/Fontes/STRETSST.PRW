#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma   STRETSST    ºAutor  ³Giovani Zago    º Data ³  26/05/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Retorna preço de venda				                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A415LIOK()
	U_STRETSST('01',M->CJ_CLIENTE,M->CJ_LOJA ,TMP1->CK_Produto,M->CJ_CONDPAG,'TUDO')
Return (.t.)

User Function ST415GAT()
	U_STRETSST('01',M->CJ_CLIENTE,M->CJ_LOJA ,TMP1->CK_Produto,M->CJ_CONDPAG,'TUDO')
Return (.f.)

//User Function STRETSST(_cOper,_cCliente,_cLoja,_cProduto,_cCondPg,_cFunc,lEdi)
//Chamado 001423
User Function STRETSST(_cOper,_cCliente,_cLoja,_cProduto,_cCondPg,_cFunc,lEdi,_cTipoCli,_cZConsum,_cTabela,_cZnum,_cZitem,_XTES)
	Local _aArea  := getarea()
	Local   oReport
	Local nX			:= 0
	Local cQuery 		:= ""
	Local cAlias 		:= "QRYTEMP9"
	Local aDados[2]
	Local nValLiq 		:= 0
	Local nValBrut		:= 0
	Local   _nPosPrv  		:= 0
	Local   _nPosProd  		:= 0
	Local   _nPosTes  		:= 0
	Local	nPValICMS		:= 0
	Local	nPAliqICM  		:= 0
	Local	nPValICMSST		:= 0
	Local	nPValIPI		:= 0
	Local	nPosIpi		    := 0
	Local	nPosList		:= 0
	Local	_nPosDEXC		:= 0
	Local	nPosCOMISS		    := 0
	Local	nPValLiq		    := 0
	Local _nPosDESC         := 0
	Local _cGrupProd        := ' '
	Local oDlg
	Local _ret
	//Local _cTabela  := GETMV("ST_TPRCTMK",,'001')
	Local i
	Private cPerg := "RFAT23"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= GetNextAlias()
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private aDados1[21]
	Private _aOldAcols   :=  {}
	Private _nCofins        := 0
	Private _cTesOcide    := GetMv('ST_TESOCI',,'827/828/829/830/831')	//Giovani Zago 11/02/2014 Reajuste Amazonia Ocidental     (chamado 000161)
	// oGrade:aColsGrade
	Public n
	Default lEdi			:= .F.
	Default _cTabela  		:= GETMV("ST_TPRCTMK",,'001')
	Default _XTES := ""

	//Chamado 001423	
	strelquer(_cOper,_cCliente,_cLoja,_cProduto,_cCondPg,_cTabela,_cZnum,_cZitem)

	// Chamado 005549 - Robson Mazzarotto, colocado a variavel _cOper para levar o codigo da operação correta
	xVALUSST(_cOper,_cCliente,_cLoja,_cProduto,_cCondPg,lEdi,_cTipoCli,_cZConsum,_cZnum,_cZitem,@_XTES)

	_nPosPrv  		:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})     // Preco de venda
	_nPosProd  		:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})    // Codigo do produto
	_nPosTes  		:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == 'TES'})     	// Valor Acrescimo Financeiro  _nPosTes
	nPValICMS		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALICM"})			// Posicao do Valor do ICMS
	nPAliqICM  		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZPICMS"})			// Posicao do Aliq. ICMS
	nPValICMSST		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIST"})			// Posicao do Valor do ICMS ST
	nPValIPI		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIPI"})			// Posicao do Valor do IPI
	nPosIpi		    := Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZIPI"})
	nPosList		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== 'C6_XPRCLIS'})
	_nPosDESC       := Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== 'C6_DESCRI'})
	_nPosDEXC		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== 'C6_DESCONT'})
	nPosCOMISS	    := Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_COMISS"})
	nPValLiq        := Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALLIQ"})
	
	For i:=1 To Len(Acols)

		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+aCols[i][_nPosProd]))
			dbSelectArea("SBM")
			SBM->(DbSetOrder(1)) // Indice FILIAL + GRUPO
			SBM->(DbSeek(xFilial('SBM')+ SB1->B1_GRUPO))

			dbSelectArea("SF4")
			SF4->(dbsetOrder(1))
			If	SF4->(DbSeek(xFilial("SF4")+ aCols[i,_nPosTES]))

				//	aDados1[01]	:= _cGrupProd
				//	aDados1[02]	:=	aCols[i][_nPosProd]
				//	aDados1[03]	:=	ALLTRIM(SB1->B1_DESC)
				//	aDados1[06]	:=	SB1->B1_QE
				//	aDados1[07]	:=  Transform(SB1->B1_POSIPI,' @R 9999.99.99 '  )
				//	aDados1[08]	:=	ALLTRIM(SB1->B1_ORIGEM)
				//	aDados1[09]	:=	Round(aCols[i][nPosList],2)
				//	aDados1[10]	:=  Round(aCols[i][nPAliqICM],2)
				//	aDados1[11]	:=	Round(aCols[i][_nPosDEXC],2)
				//	aDados1[12]	:=	Round(aCols[i][_nPosPrv],2)
				//	aDados1[15]	:=	Posicione('SF7',4,xFilial("SF7")+SB1->B1_GRTRIB+SA1->A1_GRPTRIB+SA1->A1_EST+aCols[i][_nPosDESC]  ,'F7_MARGEM')//		SF4->F4_IVAUTIL
				//	aDados1[13]	:= 	Round(aCols[i][nPosIpi],2)
				//	aDados1[14]	:=	Round(aCols[i][nPValIPI],2)
				//	aDados1[16]	:=	Round(aCols[i][nPValICMSST],2)
				//	aDados1[17]	:=	Round(aCols[i][nPosCOMISS] ,2)
				//	TMP1->CK_PRCVEN	:=  Round(aCols[i][_nPosPrv]  ,2)
				//aDados1[19]	:=  Sb2Saldo(aCols[i][_nPosProd] )
				//aDados1[20]	:=  Round( ( Round(aCols[i][_nPosPrv],2) - aCols[i][nPValLiq]),2)
				//	aDados1[21]	:=  Round(	  ((Round(Round(aCols[i][_nPosPrv],2)   -	aCols[i][nPValLiq],2) / Sb2Saldo(aCols[i][_nPosProd] )) -1),2)

				If _cFunc = 'TUDO'
				   _aValores := {}
				   AADD(_aValores,aCols[i][_nPosPrv])    // 1 Preco Unitario 
				   AADD(_aValores,aCols[i][nPValIPI])    // 2 Valor IPI 
				   AADD(_aValores,aCols[i][nPValICMSST]) // 3 Valor ST. 
				   AADD(_aValores,aCols[i][nPosIpi])     // 4 Aliquota IPI 
				   AADD(_aValores,aCols[i][nPosCOMISS])  // 5 Comissão 
				   AADD(_aValores,aCols[i][nPAliqICM])   // 6 Aliq.ICMS
				   AADD(_aValores,aCols[i][_nPosTes])    // 7 TES. 
				   _ret := _aValores

				ElseIf _cFunc = 'TES'

					/****************************************
					<<<< ALTERAÇÃO >>>>
					Ação.........: Tratamento de Erro da TES Inteligente, se não encontrar a TES retona branco e não mais chumbado 501
					Desenvolvedor: Marcelo Klopfer Leme
					Data.........: 30/08/2022
					Chamado......: 20220727014715 - Integração de Cotações
					_ret :=  Iif(Empty(Alltrim(aCols[i,_nPosTES])),'501',aCols[i,_nPosTES])
					****************************************/
					_ret :=  IIF(EMPTY(ALLTRIM(aCols[i,_nPosTES])),"",aCols[i,_nPosTES])
					//	_ret :=  Iif(Empty(Alltrim(aCols[i,_nPosTES])),u_STTESINTELIGENTE(),aCols[i,_nPosTES]) // CHAMADO 003972
				ElseIf _cFunc = 'PRECO'
					DbSelectArea("DA1")
					DA1->(DbSetOrder(1))
					If  DA1->(Dbseek(xFilial("DA1")+_cTabela+aCols[i][_nPosProd]))
						//_ret := Round(aCols[i][_nPosPrv]  ,2)
						_ret := aCols[i][_nPosPrv] 	//FR - 22/03/2022 - Alteração - retirado arredondamento por haver diferenças de centavos
					Else
						_ret := (u_STCUSTO(aCols[i][_nPosProd])*1.3)
						_ret:= iif(_ret==0,0.01,_ret)
					EndIf
				ElseIf _cFunc = 'IPI'
					If IsInCallStack("CalculaPed")
						_ret := {}
						AADD(_ret,Round(aCols[i][nPValIPI],2))
						AADD(_ret,Round(aCols[i][nPosIpi],2))						
					Else
						_ret := 	Round(aCols[i][nPValIPI],2)
					EndIf
				ElseIf _cFunc = 'ST'
					If IsInCallStack("CalculaPed")
						_ret := {}
						AADD(_ret,Round(aCols[i][nPValICMSST],2))
						AADD(_ret,Round(aCols[i][nPosCOMISS],2))						
					Else
						_ret := 	Round(aCols[i][nPValICMSST],2)
					EndIf
				EndIf
			EndIf
		EndIf
	next i

	Restarea(_aArea)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	aCols := {}

Return  (_ret)

//SELECIONA OS PRODUTOS
//Chamado 001423
//Static Function strelquer(_cOper,_cCliente,_cLoja,_cProduto,_cCondPg)
//Static Function strelquer(_cOper,_cCliente,_cLoja,_cProduto,_cCondPg,_cTabela)
Static Function strelquer(_cOper,_cCliente,_cLoja,_cProduto,_cCondPg,_cTabela,_cZnum,_cZitem)

	Local cQuery     := ' '
	Local _cCGC		 := ""
	//Chamado 001423 abre
	//IF IsInCallStack("U_STFTA001")
	IF IsInCallStack("U_ORCUNICON")
		If _cProduto = 'SUNICOM'

			cQuery := " SELECT '"+_cProduto+"' AS DA1_CODPROD ,PP8.PP8_PRORC AS DA1_PRCVEN  ,SB1.B1_GRUPO  ,SB1.B1_DESC
			cQuery += " FROM "+RetSqlName("PP8")+" PP8 "

			cQuery += " LEFT JOIN(SELECT * FROM "+RetSqlName("SB1")+" ) SB1 "
			cQuery += " ON SB1.B1_COD = '"+_cProduto+"'
			cQuery += " AND SB1.D_E_L_E_T_ = ' '

			cQuery += " AND SB1.B1_COD =  PP8.PP8_PROD
			cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
			cQuery += " LEFT JOIN(SELECT * FROM "+RetSqlName("SBM")+" ) SBM "
			cQuery += " ON SBM.BM_GRUPO =  SB1.B1_GRUPO
			cQuery += " AND SBM.D_E_L_E_T_ = ' '
			cQuery += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"

			cQuery += " WHERE PP8.D_E_L_E_T_     = ' '

			cQuery += " AND PP8.PP8_FILIAL = '"+xFilial("PP8")+"'"
			cQuery += " AND PP8.PP8_CODIGO = '"+_cZnum+"'"
			cQuery += " AND PP8.PP8_ITEM   = '"+_cZitem+"'"
			cQuery += " ORDER BY SB1.B1_GRUPO,SB1.B1_DESC

		Else
			cQuery := " SELECT PP8.PP8_PROD AS DA1_CODPROD ,PP8.PP8_PRORC AS DA1_PRCVEN  ,SB1.B1_GRUPO  ,SB1.B1_DESC
			cQuery += " FROM "+RetSqlName("PP8")+" PP8 "

			cQuery += " LEFT JOIN(SELECT * FROM "+RetSqlName("SB1")+" ) SB1 "
			cQuery += " ON SB1.B1_COD = PP8.PP8_PROD
			cQuery += " AND SB1.D_E_L_E_T_ = ' '

			cQuery += " AND SB1.B1_COD =  PP8.PP8_PROD
			cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
			cQuery += " LEFT JOIN(SELECT * FROM "+RetSqlName("SBM")+" ) SBM "
			cQuery += " ON SBM.BM_GRUPO =  SB1.B1_GRUPO
			cQuery += " AND SBM.D_E_L_E_T_ = ' '
			cQuery += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"

			cQuery += " WHERE PP8.D_E_L_E_T_     = ' '

			cQuery += " AND PP8.PP8_FILIAL = '"+xFilial("PP8")+"'"
			cQuery += " AND PP8.PP8_PROD =  '"+_cProduto+"'
			cQuery += " ORDER BY SB1.B1_GRUPO,SB1.B1_DESC
		Endif

	Else
		_cCGC := Posicione("SA1",1,xFilial('SA1')+_cCliente+_cLoja,"A1_CGC")	
		//Chamado 001423 fecha
		cQuery := " SELECT DA1.DA1_CODPRO DA1_CODPROD  ,DA1.DA1_PRCVEN ,SB1.B1_GRUPO  ,SB1.B1_DESC
		//>>
		If _cCGC == "44415136000138" //CNPJ Distribuidora
			/*************************************************************
			<<< ALTERAÇÃO >>> 
			Ação...........: Tratamento para incluir ALIAS do acesso ao banco Steck - Distribuidora
			Desenvolvedor..: Marcelo Klopfer Leme
			Data...........: 05/10/2022
			cQuery += " FROM UDBD11.DA1110 DA1 "
			*************************************************************/
			cQuery += " FROM "+AllTrim(GetMv("STALIASDIS"))+".DA1110 DA1 "
		Else
			cQuery += " FROM "+RetSqlName("DA1")+" DA1 "
		EndIf
		//<<
		cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+" ) SB1 "
		cQuery += " ON SB1.B1_COD = DA1.DA1_CODPRO
		cQuery += " AND SB1.D_E_L_E_T_ = ' '

		cQuery += " AND SB1.B1_COD =  DA1.DA1_CODPRO
		cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SBM")+" ) SBM "
		cQuery += " ON SBM.BM_GRUPO =  SB1.B1_GRUPO
		cQuery += " AND SBM.D_E_L_E_T_ = ' '
		cQuery += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"

		cQuery += " WHERE DA1.D_E_L_E_T_     = ' '

		cQuery += " AND DA1.DA1_FILIAL = '"+xFilial("DA1")+"'"
		If cEmpAnt == '03' .And. _cCliente == '033467'
			cQuery += " AND DA1.DA1_CODTAB = 'T02'"
			/*************************************************************
			<<< ALTERAÇÃO >>> 
			Ação...........: Tratamento para incluir o código do cliente "033467" Steck - Distribuidora
			Desenvolvedor..: Marcelo Klopfer Leme
			Data...........: 05/10/2022
			elseif cEmpAnt == '01' .And. _cCliente == '035444' // Robson Mazzarotto
			*************************************************************/
		elseif cEmpAnt == '01' .And. _cCliente $ '035444/033467' // Robson Mazzarotto
			cQuery += " AND DA1.DA1_CODTAB = 'T01'"
		elseif cEmpAnt == '01' .And. _cCliente == '012047'
			cQuery += " AND DA1.DA1_CODTAB = 'GUA'"
		Else
			If _cTabela <> ALLTRIM(GETMV("ST_TPRCFAT"))
				cQuery += " AND DA1.DA1_CODTAB = '"+_cTabela+"'"
			Else
				cQuery += " AND DA1.DA1_CODTAB = '"+ ALLTRIM(GETMV("ST_TPRCFAT"))+"'"
			Endif
		Endif
		cQuery += " AND DA1.DA1_CODPRO =  '"+_cProduto+"'
		cQuery += " ORDER BY SB1.B1_GRUPO,SB1.B1_DESC

	Endif

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

	*-----------------------------*
//Static Function   xVALUSST(_cOper,_cCliente,_cLoja,_cProduto,_cCondPg,lEdi)
//Chamado 001423 //       (_cOper,_cCliente,_cLoja,_cProduto,_cCondPg,lEdi,_cTipoCli,_cZConsum,_cZnum,_cZitem)
Static Function   xVALUSST(_cOper,_cCliente,_cLoja,_cProduto,_cCondPg,lEdi,_cTipoCli,_cZConsum,_XTES)
	*-----------------------------*
	Local _lRet   		:= .F.
	Local _nOld   		:= 1
	Local _nPosOper     := 0
	Local _nPosProd     := 0
	Local _nPosTES      := 0
	Local _nPosClas     := 0
	Local _nPosPrc    	:= 0
	Local _nPosDESC     := 0
	Local _nPosDEXC     := 0
	Local _nICMPAD	    :=_nICMPAD2 :=0
	Local _nDescPad		:=0
	Local _nPis 		:=0
	Local _nCofis		:=0
	Local _nIcms    	:= SA1->A1_CONTRIB
	Local _cEst			:= SA1->A1_EST
	Local _nOpcao 		:= 3
	Local _xAlias 		:= GetArea()
	Local aFields 		:= {}
	Local aCpoEnch		:= {}
	Local aTam  		:= {}
	Local aNoEnch		:= {"C5_NUM","C5_CLIENTE"}
	Local oDlg
	Local _cCodAut  	:= GetMv("ST_CODFIS",,'000000')
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tipos das Opcoes						  ³
	//³ _nOpcao == 1 -> Incluir					  ³
	//³ _nOpcao == 2 -> Visualizar                ³
	//³ _nOpcao == 3 -> Alterar                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local bCampoSC5		:= { |nCPO| Field(nCPO) }
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Arrays de controle dos campos que deverao ser alterados  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aCposAlt 		:= {}
	Local nCntFor
	Local _ni
	Local i
	Local _nCamDes := 0
	Local _nValAcre     := Posicione("SE4",1,xFilial("SE4")+_cCondPg,"E4_XACRESC")
	Local _nAliqICM     := 0	
	Local _xOrigFab     := ""

//Ricardo Munhoz - Unificação de Preço
	aRetX := {}

	PRIVATE cZConsumo

	Default lEdi	:= .F.
	Public aHeader 		:= {}
	Public aCols		:={}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria variaveis M->????? da Enchoice                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nCntFor := 1 TO FCount()
		M->&(EVAL(bCampoSC5,nCntFor)) := FieldGet(nCntFor)
	Next nCntFor

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria aHeader e aCols da GetDados                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nUsado:=0

	//				  1-Campo    , 2-Tipo, 3-Tam	, 4-Dec	, 5-Titulo		, 6-Validacao  											, 7-ComboBox
	aTam := TamSX3("C6_PRODUTO")
	AAdd( aFields, { 'C6_PRODUTO', 'C'	, aTam[1]	, 0		, 'PRODUTO'		, " "													, ''				  					} )
	aTam := TamSX3('C6_DESCRI')
	AAdd( aFields, { 'C6_DESCRI' , 'C'	, aTam[1]	, 0		, 'DESCRIÇÃO'	, " "													, ''				  					} )
	aTam := TamSX3('C6_ITEM')
	AAdd( aFields, { 'C6_ITEM' 	 , 'C'	, aTam[1]	, 0		, 'ITEM	 '  	, " "													, ''				  					} )
	aTam := TamSX3('C6_OPER')
	AAdd( aFields, { 'TPOPER'	 , 'C'	, aTam[1]   , 0		, 'Tp.Oper.	 ' 	, " "				   									, ''				   					} )
	aTam := TamSX3('C6_TES')
	AAdd( aFields, { 'TES'	     , 'C'	, aTam[1]   , 0		, 'TES	 ' 		, " "				   									, ''				   					} )
	aTam := TamSX3("C6_CF")
	AAdd( aFields, { 'CFOP' 	 , 'C'	, aTam[1]   , 0		, 'Cod. Fiscal'	, " "	  							   					, ''  									} )
	aTam := TamSX3("C6_CLASFIS")
	AAdd( aFields, { 'CLASSI' 	 , 'C'	, aTam[1]   , 0		, 'Sit. Trib.'	, " "	  							   					, ''  									} )
	AAdd( aFields, { 'RECNO' 	 , 'N'	, 20   		, 0		, 'RECNO'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { 'C6_PRCVEN'  , 'N'	, 14   	, 0		, 'PRECO'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { 'C6_XPRCLIS'  , 'N'	, 14   	, 0		, 'PRECOLIST'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { 'C6_ZVALICM'  , 'N'	, 14   	, 0		, 'VALICM'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { "C6_ZPICMS"  , 'N'	, 14   	, 0		, 'ICMPOR'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { "C6_ZVALIST"  , 'N'	, 14   	, 0		, 'ICMSST'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { "C6_ZVALIPI"  , 'N'	, 14   	, 0		, 'VALIPI'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { "C6_ZIPI"  , 'N'	, 14   	, 0		, 'IPIPOR'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { "BM_DESC"  , 'C'	, 20   	, 0		, 'DESC'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { 'C6_DESCONT'  , 'N'	, 14   	, 0		, 'C6DESC'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { 'C6_COMISS'  , 'N'	, 14   	, 0		, 'C6_COMISS'   	, " "	  							   					, ''  									} )
	AAdd( aFields, { "C6_ZVALLIQ"  , 'N'	, 14   	, 0		, "C6_ZVALLIQ"   	, " "	  							   					, ''  									} )
	AAdd( aFields, { "C6_XPORACR"  , 'N'	, 6   	, 2		, "C6_XPORACR"   	, " "	  							   					, ''  									} )
	AAdd( aFields, { "C6_XVALACR"  , 'N'	, 6   	, 2		, "C6_XVALACR"   	, " "	  							   					, ''  									} )
	AAdd( aFields, { "C6_QTDVEN"  , 'N'	, 12   	, 2		, "C6_QTDVEN"   	, " "	  							   					, ''  									} )
	AAdd( aFields, { "C6_VALOR"  , 'N'	, 12   	, 2		, "C6_VALOR"   	, " "	  							   					, ''  									} )

	aHeader := {}	// Monta Cabecalho do aHeader. A ordem dos elementos devem obedecer a sequencia da estrutura dos campos logo acima. aFields[0,6]
	// 	01-Titulo			   			        , 02-Campo		, 03-Picture, 04-Tamanho	, 05-Decimal, 06-Valid		, 07-Usado	, 08-Tipo		, 09-F3		, 10-Contexto	, 11-ComboBox	, 12-Relacao	, 13-When		  , 14-Visual	, 15-Valid Usuario
	aAdd( aHeader, {	aFields[01,5]+Space(20)	, aFields[01,1]	, '@!'		, aFields[01,3]	, 0			, aFields[01,6]	, ''		, aFields[01,2]	, ''		, 'R'			, aFields[01,7]	, ''			, ''   			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[02,5]+Space(20)	, aFields[02,1]	, '@!'		, aFields[02,3]	, 0			, aFields[02,6]	, ''		, aFields[02,2]	, ''		, 'R'			, aFields[02,7]	, ''			, ''  			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[03,5]+Space(20)	, aFields[03,1]	, '@!'		, aFields[03,3]	, 0			, aFields[03,6]	, ''		, aFields[03,2]	, ''		, 'R'			, aFields[03,7]	, ''			, '' 			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[04,5]+Space(20)	, aFields[04,1]	, '@!'		, aFields[04,3]	, 0			, aFields[04,6]	, ''		, aFields[04,2]	, 'DJ'		, 'R'			, aFields[04,7]	, ''			, 'U_STRWHENOPE()', ''		, 'U_VALUSST(M->TPOPER)'				} )
	aAdd( aHeader, {	aFields[05,5]+Space(20)	, aFields[05,1]	, '@!'		, aFields[05,3]	, 0			, aFields[05,6]	, ''		, aFields[05,2]	, 'SF4'		, 'R'			, aFields[05,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[06,5]+Space(20)	, aFields[06,1]	, '@!'		, aFields[06,3]	, 0			, aFields[06,6]	, ''		, aFields[06,2]	, '13'		, 'R'			, aFields[06,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[07,5]+Space(20)	, aFields[07,1]	, '@!'		, aFields[07,3]	, 0			, aFields[07,6]	, ''		, aFields[07,2]	, ''		, 'R'			, aFields[07,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[08,5]+Space(20)	, aFields[08,1]	, ''		, aFields[08,3]	, 0			, aFields[08,6]	, ''		, aFields[08,2]	, ''		, 'R'			, aFields[08,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[09,5]+Space(20)	, aFields[09,1]	, '@E 999,999,999.99'		, aFields[09,3]	, 0			, aFields[09,6]	, ''		, aFields[09,2]	, ''		, 'R'			, aFields[09,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[10,5]+Space(20)	, aFields[10,1]	, '@E 999,999,999.99'		, aFields[10,3]	, 0			, aFields[10,6]	, ''		, aFields[10,2]	, ''		, 'R'			, aFields[10,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[11,5]+Space(20)	, aFields[11,1]	, '@E 999,999,999.99'		, aFields[11,3]	, 0			, aFields[11,6]	, ''		, aFields[11,2]	, ''		, 'R'			, aFields[11,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[12,5]+Space(20)	, aFields[12,1]	, '@E 999,999,999.99'		, aFields[12,3]	, 0			, aFields[12,6]	, ''		, aFields[12,2]	, ''		, 'R'			, aFields[12,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[13,5]+Space(20)	, aFields[13,1]	, '@E 999,999,999.99'		, aFields[13,3]	, 0			, aFields[13,6]	, ''		, aFields[13,2]	, ''		, 'R'			, aFields[13,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[14,5]+Space(20)	, aFields[14,1]	, '@E 999,999,999.99'		, aFields[14,3]	, 0			, aFields[14,6]	, ''		, aFields[14,2]	, ''		, 'R'			, aFields[14,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[15,5]+Space(20)	, aFields[15,1]	, '@E 999,999,999.99'		, aFields[15,3]	, 0			, aFields[15,6]	, ''		, aFields[15,2]	, ''		, 'R'			, aFields[15,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[16,5]+Space(20)	, aFields[16,1]	, '@!'		, aFields[16,3]	, 0			, aFields[16,6]	, ''		, aFields[16,2]	, ''		, 'R'			, aFields[16,7]	, ''			, ''			  , ''		, ''				} )
	aAdd( aHeader, {	aFields[17,5]+Space(20)	, aFields[17,1]	, '@E 999,999,999.99'		, aFields[17,3]	, 0			, aFields[17,6]	, ''		, aFields[17,2]	, ''		, 'R'			, aFields[17,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[18,5]+Space(20)	, aFields[18,1]	, '@E 999,999,999.99'		, aFields[18,3]	, 0			, aFields[18,6]	, ''		, aFields[18,2]	, ''		, 'R'			, aFields[18,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[19,5]+Space(20)	, aFields[19,1]	, '@E 999,999,999.99'		, aFields[19,3]	, 0			, aFields[19,6]	, ''		, aFields[19,2]	, ''		, 'R'			, aFields[19,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[20,5]+Space(20)	, aFields[20,1]	, '@E 999,999,999.99'		, aFields[20,3]	, 0			, aFields[20,6]	, ''		, aFields[20,2]	, ''		, 'R'			, aFields[20,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[21,5]+Space(20)	, aFields[21,1]	, '@E 999,999,999.99'		, aFields[21,3]	, 0			, aFields[21,6]	, ''		, aFields[21,2]	, ''		, 'R'			, aFields[21,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[22,5]+Space(20)	, aFields[22,1]	, '@E 999,999,999.99'		, aFields[22,3]	, 0			, aFields[22,6]	, ''		, aFields[22,2]	, ''		, 'R'			, aFields[22,7]	, ''			, '.F.'			  , 'V'		, ''				} )
	aAdd( aHeader, {	aFields[23,5]+Space(20)	, aFields[23,1]	, '@E 999,999,999.99'		, aFields[23,3]	, 0			, aFields[23,6]	, ''		, aFields[23,2]	, ''		, 'R'			, aFields[23,7]	, ''			, '.F.'			  , 'V'		, ''				} )

	nUsado:=len(aHeader)
	public aCols:={}
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			AADD(aCols,Array(nUsado+1))
			For _ni:=1 to nUsado
				If aHeader[_ni,2] = 'TES'
					aCols[Len(aCols),_ni]:=""
				ElseIf aHeader[_ni,2] = 'CFOP'
					aCols[Len(aCols),_ni]:=""
				ElseIf aHeader[_ni,2] = 'TPOPER'
					aCols[Len(aCols),_ni]:=""
				ElseIf aHeader[_ni,2] = 'CLASSI'
					aCols[Len(aCols),_ni]:=""
				ElseIf aHeader[_ni,2] = 'RECNO'
					aCols[Len(aCols),_ni]:=0
				ElseIf aHeader[_ni,2] = 'C6_PRODUTO'
					aCols[Len(aCols),_ni]:=	(cAliasLif)->DA1_CODPROD
				ElseIf aHeader[_ni,2] = 'C6_PRCVEN'
					aCols[Len(aCols),_ni]:=	(cAliasLif)->DA1_PRCVEN
					//Conout(DA1->DA1_CODTAB+" "+CVALTOCHAR((cAliasLif)->DA1_PRCVEN))
				ElseIf aHeader[_ni,2] = 'C6_XPRCLIS'
					aCols[Len(aCols),_ni]:=	(cAliasLif)->DA1_PRCVEN
				ElseIf aHeader[_ni,2] = 'C6_XPORACR'
					aCols[Len(aCols),_ni]:= 0
				ElseIf aHeader[_ni,2] = 'C6_XVALACR'
					aCols[Len(aCols),_ni]:= 0
				ElseIf aHeader[_ni,2] = 'C6_QTDVEN'
					aCols[Len(aCols),_ni]:= 1
				ElseIf aHeader[_ni,2] = 'C6_VALOR'
					aCols[Len(aCols),_ni]:= 0
				EndIf
			Next
			aCols[Len(aCols),nUsado+1]:=.F.

			(cAliasLif)->(dbskip())

		End

		(cAliasLif)->(DbCloseArea())

		M->C5_TIPO    := 'C'
		M->C5_LOJACLI :=  _cLoja
		M->C5_CLIENTE := _cCliente
		DbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+ M->C5_CLIENTE + M->C5_LOJACLI ))
		M->C5_TIPOCLI := SA1->A1_TIPO
		M->C5_ZCONSUM := ' '
		M->C5_TIPO    := 'N'
		M->C5_XCONDPG := _cCondPg
		//FR - 05/07/2022 -Sigamat Consultoria -  #20220704013334 - TICKET erro preço a função abaixo executa o acréscimo financeiro no preço
		//PRECISA ALIMENTAR ESTE CAMPO QUE É LIDO NA FUNÇÃO ST04GAX
		M->C5_ZCONDPG := _cCondPg	
		//	U_STTESTEL()

		//M->C5_ZCONSUM := IIF(	M->C5_TIPOCLI='S','','2')
		//M->C5_ZCONSUM := SA1->A1_CONTRIB

		If IsInCallStack("U_STCONSPROD") .Or. !(Type("_lPrtCli")=="U") .Or. IsInCallStack("U_RSTFAT08")
			U_STTESTEL()
		EndIf

		_cTabela:= U_STXZ2B(_cCliente,_cLoja)
		M->C5_TABELA := _cTabela

		If lEdi
			M->C5_ZCONSUM :=  cZConsumo
		EndIf		
		//Chamado 001423 abre
		IF IsInCallStack("U_STFTA001") .Or. IsInCallStack("U_SXGERSC5") .Or. IsInCallStack("U_STSEB010") .Or. IsInCallStack("U_MSTECK09");
		   .Or. IsInCallStack("U_STCONSCOT") .Or. IsInCallStack("U_STCRM07A")  .Or. IsInCallStack("U_STCRM08A")  //FR - 17/06/2022
			M->C5_TIPOCLI := _cTipoCli  //FR - 22/04/2022 - ALTERAÇÃO REST COTAÇÕES: PARA ASSUMIR O TIPO CLIENTE, composição necessária para trazer o TES correto
			//M->C5_ZCONSUM := _cZConsum  //FR - 22/04/2022 - ALTERAÇÃO REST COTAÇÕES: PARA ASSUMIR o TIPO CONSUMO, composição necessária para trazer o TES correto
		Endif
		//Chamado 001423 fecha		
		_nIcms    	:= SA1->A1_CONTRIB
		_cEst		:= SA1->A1_EST

	EndIf

	_nPosOper     := aScan(aHeader, { |x| Alltrim(x[2]) == 'TPOPER'    })
	_nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_PRODUTO'    })
	_nPosTES      := aScan(aHeader, { |x| Alltrim(x[2]) == 'TES'    })
	_nPosClas     := aScan(aHeader, { |x| Alltrim(x[2]) == 'CLASSI'    })
	_nPosPrc      := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_PRCVEN'    })
	_nPosDESC     := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_DESCRI'    })
	_nPosDEXC     := aScan(aHeader, { |x| Alltrim(x[2]) == 'C6_DESCONT'    })
	//SetRegua(Len(Acols))

	For i:=1 To Len(Acols)
		//	IncRegua( "Analisando Produto: "+aCols[i,_nPosProd] )
		n:=i
		aCols[i,_nPosOper]:= _cOper
		If Valtype(aCols[i][_nPosProd]) <> 'C'
			aCols[i][_nPosProd]:=' '
		EndIf

		U_STTESINTELIGENTE()
		IF !EMPTY(aCols[i][_nPosTes])
		  _xTes := aCols[i][_nPosTes]
		ENDIF

		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+aCols[i][_nPosProd]))
			dbSelectArea("SBM")
			SBM->(DbSetOrder(1)) // Indice FILIAL + GRUPO
			SBM->(DbSeek(xFilial('SBM')+ SB1->B1_GRUPO))
			dbSelectArea("SF4")
			SF4->(dbsetOrder(1))
			If	SF4->(DbSeek(xFilial("SF4")+ aCols[i,_nPosTES]))
				aCols[i][_nPosClas]:=SB1->B1_ORIGEM+SF4->F4_SITTRIB
			EndIf

			_cTipoCli := SA1->A1_TIPO

//Ricardo Munhoz - Unificação de Preço
//User Function STCalcPrc(aDados,nPrecoX,cTabelaX,nPrcCamX,cOperX,cTESX,lPrcCond)
//aRetX, [1] = Preço, [2] = Regra
			aRetX := U_STCalcPrc({SA1->(Recno()),SB1->(Recno())},aCols[i][_nPosPrc],M->C5_TABELA,0,,_xTes,)
			aCols[i][_nPosPrc] := aRetX[1]

			//FR - 05/07/2022 -Sigamat Consultoria -  #20220704013334 - TICKET erro preço a função abaixo executa o acréscimo financeiro no preço
			//If !IsInCallStack("U_STCONSPROD") //Ticket 20220126002041 - Everson Santana - 01.02.2021
//Melhorar
			U_ST04GAX()
			//EndIf
			//FR - 05/07/2022 -Sigamat Consultoria -  #20220704013334 - TICKET erro preço a função abaixo executa o acréscimo financeiro no preço

/*
			//Não estava puxando o reajuste da amazonia ocidental
			If IsInCallStack("U_STCONSPROD")
				If  aCols[n,_nPosTes]  $  _cTesOcide
					_nPrAtu:= OciPreco(aCols[n,_nPosPrc])
					aCols[i][_nPosPrc] :=_nPrAtu
				EndIf
			EndIf
*/

			aCols[i][_nPosDESC]:=   M->C5_TIPOCLI
			xretmafis()

			//________________________________________________________________________________________________________________________
		EndIf

	Next i
	n:= _nOld
	_lRet   := .T.

Return  ()

	*-----------------------------*
Static Function xMafis(_xTES)
	*-----------------------------*

	Local _nPosPrv  	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})     // Preco de venda
	Local _nPosProd  	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})    // Codigo do produto
	Local _nPosTes  	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == 'TES'})     	// Valor Acrescimo Financeiro  _nPosTes
	Local _nTotPed 		:= 0
	Local nAliqICM 		:= 0
	Local nValICms		:= 0
	Local nCnt 			:= 0
	Local nAliqIPI 		:= 0
	Local nValIPI 		:= 0
	Local nValICMSST 	:= 0
	Local nValPis		:= 0
	Local nValCof		:= 0

	MaFisSave()

	MaFisEnd()

	MaFisIni(M->C5_CLIENTE,;				// 1-Codigo Cliente/Fornecedor
		M->C5_LOJACLI,;						// 2-Loja do Cliente/Fornecedor
		IIf(M->C5_TIPO$'DB',"F","C"),;		// 3-C:Cliente , F:Fornecedor
		M->C5_TIPO,;						// 4-Tipo da NF
		M->C5_TIPOCLI,;						// 5-Tipo do Cliente/Fornecedor
		Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461")
	
	If IsInCallStack("U_STCONSCOT") .OR. IsInCallStack("U_STCRM07A") .OR. IsInCallStack("U_STCRM08A")

		//conout("<< U_STCONSCOT - TRATA TES >>>")

		MaFisAdd(aCols[n,_nPosProd],;                                 	// 1-Codigo do Produto ( Obrigatorio )
		_xTES ,; 					                                	// 2-Codigo do TES ( Opcional )
		1,;                                                         	// 3-Quantidade ( Obrigatorio )
		aCols[n,_nPosPrv],;                                     	    // 4-Preco Unitario ( Obrigatorio )
		0,;                												// 5-Valor do Desconto ( Opcional )
		,;                                                              // 6-Numero da NF Original ( Devolucao/Benef )
		,;                                                              // 7-Serie da NF Original ( Devolucao/Benef )
		,;                                                              // 8-RecNo da NF Original no arq SD1/SD2
		0,;                                                             // 9-Valor do Frete do Item ( Opcional )
		0,;                                                             // 10-Valor da Despesa do item ( Opcional )
		0,;                                                             // 11-Valor do Seguro do item ( Opcional )
		0,;                                                             // 12-Valor do Frete Autonomo ( Opcional )
		aCols[n,_nPosPrv],;												// 13-Valor da Mercadoria ( Obrigatorio )
		0,;                                                             // 14-Valor da Embalagem ( Opiconal )
		0,;                                                             // 15-RecNo do SB1
		0)                                                              // 16-RecNo do SF4

	Else

		MaFisAdd(aCols[n,_nPosProd],;                                 	// 1-Codigo do Produto ( Obrigatorio )
		aCols[n,_nPosTes],;                                				// 2-Codigo do TES ( Opcional )
		1,;                                                         	// 3-Quantidade ( Obrigatorio )
		aCols[n,_nPosPrv],;                                     	    // 4-Preco Unitario ( Obrigatorio )
		0,;                												// 5-Valor do Desconto ( Opcional )
		,;                                                              // 6-Numero da NF Original ( Devolucao/Benef )
		,;                                                              // 7-Serie da NF Original ( Devolucao/Benef )
		,;                                                              // 8-RecNo da NF Original no arq SD1/SD2
		0,;                                                             // 9-Valor do Frete do Item ( Opcional )
		0,;                                                             // 10-Valor da Despesa do item ( Opcional )
		0,;                                                             // 11-Valor do Seguro do item ( Opcional )
		0,;                                                             // 12-Valor do Frete Autonomo ( Opcional )
		aCols[n,_nPosPrv],;												// 13-Valor da Mercadoria ( Obrigatorio )
		0,;                                                             // 14-Valor da Embalagem ( Opiconal )
		0,;                                                             // 15-RecNo do SB1
		0)                                                              // 16-RecNo do SF4
 
	Endif 

	nAliqICM 	:= round(MaFisRet(1,'IT_ALIQICM',5,2) ,2 )

	mafisend()

Return  (nAliqICM)
	/*====================================================================================\
	|Programa  | xretmafis        | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
	|=====================================================================================|
	|Descrição |  xretmafis                                                               |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | xretmafis                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function xretmafis()
	*-----------------------------*
	Local   _nPosPrv  		:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})     // Preco de venda
	Local   _nPosProd  		:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})    // Codigo do produto
	Local   _nPosTes  		:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == 'TES'})     	// Valor Acrescimo Financeiro  _nPosTes
	Local	nPValICMS		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALICM"})			// Posicao do Valor do ICMS
	Local	nPAliqICM  		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZPICMS"})			// Posicao do Aliq. ICMS
	Local	nPValICMSST		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIST"})			// Posicao do Valor do ICMS ST
	Local	nPValIPI		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIPI"})			// Posicao do Valor do IPI
	Local	nPosIpi		    := Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZIPI"})
	Local	nPosCOMISS		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_COMISS"})
	Local	nPValLiq		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALLIQ"})			// Posicao do Valor do Liquido
	Local   _nTotPed 		:= 0
	Local	nAliqICM 		:= 0
	Local	nValICms		:= 0
	Local   nCnt 			:= 0
	Local	nAliqIPI 		:= 0
	Local	nValIPI 		:= 0
	Local	nValICMSST 		:= 0
	Local	nValPis			:= 0
	Local  naliqICMSST      := 0
	Local	nValCof			:= 0
	Local   nQuant			:= 1  //SEMPRE 1 QUANTIDADE DE PRODUTO
	Local   nValCmp , nValDif 							:= 0
	MaFisSave()
	MaFisEnd()
	MaFisIni(M->C5_CLIENTE,;// 1-Codigo Cliente/Fornecedor
	M->C5_LOJACLI,;		// 2-Loja do Cliente/Fornecedor
	IIf(M->C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
	M->C5_TIPO,;				// 4-Tipo da NF
	M->C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")
	// 10-Nome da rotina que esta utilizando a funcao
	MaFisAdd(aCols[n,_nPosProd],;                                                     // 1-Codigo do Produto ( Obrigatorio )
	aCols[n,_nPosTes],;                                                                           // 2-Codigo do TES ( Opcional )
	nQuant,;                                                           // 3-Quantidade ( Obrigatorio )
	aCols[n,_nPosPrv],;                                                            // 4-Preco Unitario ( Obrigatorio )
	0,;                // 5-Valor do Desconto ( Opcional )
	,;                                                                                                                             // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                                                                             // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                                          // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                                                           // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                                                           // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                           // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                                                           // 12-Valor do Frete Autonomo ( Opcional )
	aCols[n,_nPosPrv],;// 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                                                           // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                                           // 15-RecNo do SB1
	0)                                                                                                            // 16-RecNo do SF4

	nAliqICM 	:= round(MaFisRet(1,'IT_ALIQICM',5,2) ,2 )
	nValICms	:= round(MaFisRet(1,'IT_VALICM',14,2) ,2 )

	nAliqIPI 	:= round(MaFisRet(1,"IT_ALIQIPI",5,2) ,2 )
	nValIPI 	:= round(MaFisRet(1,"IT_VALIPI",14,2) ,2 )

	nValICMSST 	:= round(MaFisRet(1,'IT_VALSOL',14,2) ,2 )
	naliqICMSST 	:= nValICMSST*100/round(MaFisRet(1,'IT_BASEICM',14,2) ,2 )

	nValPis		:= round(MaFisRet(1,"IT_VALPS2",14,2) ,2 )
	nValCof		:= round(MaFisRet(1,"IT_VALCF2",14,2) ,2 )

	//DIFAL
	nValCmp 	:= noround(MaFisRet(1,"IT_VALCMP",14,2)  )
	nValDif 	:= noround(MaFisRet(1,"IT_DIFAL",14,2)  )

	mafisend()

	//Retornar Valores Unitários

	aCols[n][nPValICMS]		:=  round(nValICMS 	/ nQuant      ,2)
	aCols[n][nPAliqICM]		:=	nAliqICM
	aCols[n][nPValICMSST]	:=  round(nValICMSST	/ nQuant   ,2   )
	aCols[n][nPValIPI] 		:=  round(nValIPI		/ nQuant   ,2   )
	aCols[n][nPosIpi]		:= 	 nAliqIPI
	aCols[n][nPosCOMISS]	:=  naliqICMSST

	aCols[n][nPValLiq]		:=   nValICMS   + nValPis + nValCof + nValCmp + nValDif

	Return

	/*====================================================================================\
	|Programa  | A415Total        | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
	|=====================================================================================|
	|Descrição |  A415Total                                                               |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | A415Total                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function A415Total(oDlg)

	Local aArea   	:= GetArea()
	Local aAreaTmp1	:= TMP1->(GetArea())
	Local nTotVal 	:= 0
	Local nTotDesc	:= 0
	Local nPerDesc  := M->CJ_DESC4
	Local nX  := 0
	Local aControl

	l415Auto := If(Type("l415Auto")<>"U",l415Auto,.F.)
	l416Auto := If(Type("l416Auto")<>"U",l416Auto,.F.)

	If !(l415Auto) .and. !(l416Auto)
		aControl := oDlg:aControls
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soma o os valores e os descontos, mostrando-os na tela³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotVal := 0
	nTotDesc:= 0
	dbSelectArea("TMP1")
	dbGotop()
	While ( !Eof() )
		If ( !TMP1->CK_FLAG )

			nTotVal  += TMP1->CK_VALOR
			nTotDesc += TMP1->CK_VALDESC
		EndIf
		dbSelectArea("TMP1")
		dbSkip()
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soma as variaveis da Enchoice                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotVal += M->CJ_FRETE
	nTotVal += M->CJ_SEGURO
	nTotVal += M->CJ_DESPESA
	nTotVal += M->CJ_FRETAUT

	If !( l415Auto .or. l416Auto)
		For nX := 1 To Len(aControl)
			If ValType(aControl[nX]) <> "U" .AND. ValType(aControl[nX]:Cargo)=="C"
				Do Case
				Case ( aControl[nX]:Cargo $ "Total" )
					aControl[nX]:SetText(nTotVal)
				Case ( aControl[nX]:Cargo $ "Desconto" )
					aControl[nX]:SetText(nTotDesc)
				Case ( aControl[nX]:Cargo $ "Valor" )
					aControl[nX]:SetText(nTotVal+nTotDesc)
				EndCase
			EndIf
		Next nX
	EndIf
	RestArea(aAreaTmp1)
	RestArea(aArea)
	Return(Nil)
	/*====================================================================================\
	|Programa  | A415Total        | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
	|=====================================================================================|
	|Descrição |  A415Total                                                               |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | A415Total                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*---------------------------------------------*
Static Function STPRODTIPO(_cProd)
	*---------------------------------------------*
	Local _cRetPro := ' '

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+_cProd))

		// IMPORTADOS *******************************************************************************************************************************************
		If   SB1->B1_CLAPROD = 'I'  //Importado
			_cRetPro := 'S'
			// COMPRADOS *******************************************************************************************************************************************
		ElseIf SB1->B1_CLAPROD = 'C'

			If SB1->B1_XPCSTK  <> 0 //Custo de manaus carga diaria
				_cRetPro := 'S'
			Else
				_cRetPro := 'M'
			EndIf

			// FABRICADOS *******************************************************************************************************************************************
		ElseIf SB1->B1_CLAPROD = 'F'
			_cRetPro := 'S'
		EndIf
	EndIf

	Return(_cRetPro)

	/*====================================================================================\
	|Programa  | OciPreco            | Autor | GIOVANI.ZAGO          | Data | 11/02/2014  |
	|=====================================================================================|
	|Descrição |  Reajuste de preço amazonia ocidental				                      |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | OciPreco                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*---------------------------------------------------*
Static Function OciPreco(_nPrcTes)
	*---------------------------------------------------*
	Local _nReajus:= 0
	Local _aArea1 	:= GetArea()
	Local _nPosProd  	:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	If SB1->(DbSeek(xFilial("SB1")+aCols[n,_nPosProd]))

		If ALLTRIM(SB1->B1_GRUPO) $ "066/068/160/161/162/166/167/173/178/183"
			_nReajus:= 3
		ElseIf   ALLTRIM(SB1->B1_GRUPO) $ "049/050/063/064/149/150/152/153/176/075/159/170/171/175/177/184/186/158"
			_nReajus:= 5
		ElseIf   ALLTRIM(SB1->B1_GRUPO) $ "154"
			_nReajus:= 7
		ElseIf   ALLTRIM(SB1->B1_GRUPO) $ "048/148/151"
			_nReajus:= 8
		ElseIf   ALLTRIM(SB1->B1_GRUPO) $ "015/020/069/070/071/072/073"
			_nReajus:= 12
		EndIf
		If _nReajus > 0
			_nPrcTes:= (_nPrcTes+(_nPrcTes*(_nReajus/100)))
		EndIf
	EndIf
	RestArea(_aArea1)
Return  (_nPrcTes)

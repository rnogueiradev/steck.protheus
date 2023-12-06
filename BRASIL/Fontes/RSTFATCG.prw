#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "EECRDM.CH"

#DEFINE STR0001  "TEL.: "
#DEFINE STR0002  " FAX: "
#DEFINE STR0003  "Unidade de medida "
#DEFINE STR0004  " nào cadastrada em "
#DEFINE STR0005  "Aviso"
#DEFINE STR0006  "Notas Fiscais:"
#DEFINE STR0007  "Código"
#DEFINE STR0008  "Descrição"
#DEFINE STR0009  "Documentos Para"
#DEFINE STR0010  "Notify's"
#DEFINE STR0011  "Mensagens"
#DEFINE STR0012  "Observações"
#DEFINE STR0013  "Imprime N.C.M."
#DEFINE STR0014  "Sim"
#DEFINE STR0015  "Não"
#DEFINE STR0016  "Imprime Peso Bruto"
#DEFINE STR0017  "Assinante"
#DEFINE STR0018  "Cargo"
#DEFINE STR0019  "Doct.Para"
#DEFINE STR0020  "Tipo Mensagem"
#DEFINE STR0021  "Configurações"
#DEFINE STR0022  "Unidades de Medida"
#DEFINE STR0023  "U.M. Qtde.:"
#DEFINE STR0024  "U.M. Preço.:"
#DEFINE STR0025  "U.M. Peso.:"
#DEFINE STR0026  "Impressão"

#DEFINE cPict1 "@E 999,999,999"
#DEFINE cPict2 "@E 999,999,999.99"

/*====================================================================================\
|Programa  | RSTFATCG        | Autor | Renan Rosário             | Data | 24/05/2019  |
|=====================================================================================|
|Descrição | Relatorio EEC   				                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function RSTFATCG()

	Local   oReport
	Private cPerg 			:= "RSTFATCG"
	Private cTime        	:= Time()
	Private cHora        	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cPergTit 		:= cAliasLif

	xPutSx1(cPerg, "01", "Filial:"				,"Filial:" 				,"Filial:" 					,"mv_ch1","C",2 ,0,0,"G","",'SM0' 		,"","","mv_par01","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "02", "Pedido Export"		,"Pedido Export" 		,"Pedido Export" 			,"mv_ch2","C",20,0,0,"G","",'EE7' 		,"","","mv_par02","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "03", "Processo Embarque:"	,"Processo Embarque:" 	,"Processo Embarque:" 		,"mv_ch3","C",20,0,0,"G","",'EEC' 		,"","","mv_par03","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "04", "Cliente:"				,"Cliente:" 			,"Cliente:" 				,"mv_ch4","C",20,0,0,"G","",'SA1' 		,"","","mv_par04","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "05", "Loja:"				,"Loja:" 				,"Loja:" 					,"mv_ch5","C",2 ,0,0,"G","",'' 			,"","","mv_par05","","","","","","","","","","","","","","","","")

	Pergunte(cPerg,.F.)

	If pergunte(cPerg,.T.)	

		Processa( {|| ReportDef() }, "Aguarde...", "Carregando definição do Relatório...",.F.)

	EndIf	

	Return
	/*====================================================================================\
	|Programa  | ReportDef        | Autor | Renan Rosário             | Data | 24/05/2019 |
	|=====================================================================================|
	|Descrição | Gera Relatorio EEC				                                          |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | 		                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*-----------------------------*
Static Function ReportDef()
	*-----------------------------*
	Local lAdjustToLegacy 	:= .F.
	Local lDisableSetup  	:= .T.
	Local _aParamBox 		:= {}
	Local aUsers 			:= {}
	Local aUsuarios 		:= {}
	Local _aRet 			:= {}
	Local cQuery1  			:= ' '
	Local _Origem     		:= GetMv("ST_COMORI",,'NBO/NGB/SHA/SGH/CTG/BNV')
	Private lIngles 		:= .t.
	Private cAlias1 		:=  'RSTFATCG'
	Private _cNomePdf 		:= "EEC"
	Private cStartPath		:= '\arquivos\eec\'
	Private _cDirRel  		:= ''//Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private oPrinter
	Private	_nFator 		:= 100
	Private	_nIni   		:= 150
	Private	_ntamLin 		:= 10
	Private _cOrigem 		:= ' '
	Private _nCol01		  	:= 42
	Private _nCol02		  	:= 90
	Private _nCol03		  	:= 500
	Private _nCol04		  	:= 350
	Private _nCol05		  	:= 510
	Private _nCol06		  	:= 210
	Private _nCol07		  	:= 350
	Private _nCol08		  	:= 510
	Private cPict 		  	:= "999,999,999.99"
	Private cVol 		  	:= ""
	Private nPesBrParc 	  	:= 0
	Private cPictDecPrc 	:= if(EEC->EEC_DECPRC > 0, "."+Replic("9",EEC->EEC_DECPRC),"")
	Private cPictDecPes 	:= if(EEC->EEC_DECPES > 0, "."+Replic("9",EEC->EEC_DECPES),"")
	Private cPictDecQtd 	:= if(EEC->EEC_DECQTD > 0, "."+Replic("9",EEC->EEC_DECQTD),"")

	Private cPictPreco 		:= "999,999,999"+cPictDecPrc
	Private cPictPeso  		:= "9,999,999.999" //+cPictDecPes
	Private cPictQtde  		:= "9,999,999"+cPictDecQtd

	Private nPesLiq 		:= 0
	Private nPesBru 		:= 0
	Private nPallet 		:= 0
	Private _nC00 			:= 0
	Private _nC01 			:= 0
	Private _nC02 			:= 0
	Private _nPag 			:= 0
	Private _Origem     	:= GetMv("ST_COMORI",,'NBO/NGB/SHA/SGH/CTG/BNV')

	If EEC->EEC_ORIGEM $ _Origem

		_cOrigem := 'Back to Back'

	ElseIf EEC->EEC_AMOSTR = '1'

		_cOrigem := 'Sample'

	EndIf

	_cDirRel := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')

	cQuery1  := " SELECT *

	cQuery1  += " FROM "+RetSqlName("EEC")+" EEC "

	cQuery1  += " LEFT JOIN(SELECT * FROM "+RetSqlName("SA2")+" ) SA2 "
	cQuery1  += " ON SA2.D_E_L_E_T_ 	= ' '
	cQuery1  += " AND SA2.A2_COD 		= EEC.EEC_EXPORT
	cQuery1  += " AND SA2.A2_LOJA 		= EEC.EEC_EXLOJA

	cQuery1  += " LEFT JOIN(SELECT * FROM "+RetSqlName("SA2")+" ) TA2 "
	cQuery1  += " ON TA2.D_E_L_E_T_ 	= ' '
	cQuery1  += " AND TA2.A2_COD 		= EEC.EEC_FORN
	cQuery1  += " AND TA2.A2_LOJA 		= EEC.EEC_FOLOJA


	cQuery1  += " INNER JOIN (SELECT * FROM "+RetSqlName("EE9")+" ) EE9 "
	cQuery1  += " ON EE9.D_E_L_E_T_ 	= ' '
	cQuery1  += " AND EE9_PREEMB 		= EEC_PREEMB
	cQuery1  += " AND EE9_FILIAL 		= EEC_FILIAL

	cQuery1  += " INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+" ) SB1 "
	cQuery1  += " ON SB1.D_E_L_E_T_ 	=  ' '
	cQuery1  += " AND B1_COD 			= EE9_COD_I

	cQuery1  += " LEFT JOIN(SELECT * FROM "+RetSqlName("SA7")+" ) SA7 "
	cQuery1  += " ON SA7.D_E_L_E_T_ 	= ' '
	cQuery1  += " AND SA7.A7_CLIENTE 	= EEC.EEC_FORN
	cQuery1  += " AND SA7.A7_LOJA 		= EEC.EEC_FOLOJA
	cQuery1  += " AND SA7.A7_PRODUTO 	= EE9_COD_I

	cQuery1  += " WHERE EEC.D_E_L_E_T_	= ' '
	cQuery1  += " AND EEC_FILIAL 		= '"+MV_PAR01+"' 
	cQuery1  += " AND EEC_PEDREF 		= '"+MV_PAR02+"' 
	cQuery1  += " AND EEC_PREEMB 		= '"+MV_PAR03+"'

	If !Empty (MV_PAR04) .AND. !Empty (MV_PAR05) 

		cQuery1  += " AND EEC_CONSIG 		= '"+MV_PAR04+"'
		cQuery1  += " AND EEC_COLOJA 		= '"+MV_PAR05+"'

	EndIf

	cQuery1  += " ORDER BY EE9_POSIPI,EE9_COD_I


	If !Empty(Select(cAlias1))

		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())

	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)
	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	_cNomePdf := DTOS(Date())+StrTran(Time(),":")

	oPrinter := FWMSPrinter():New(_cNomePdf, 6, .F.,'\arquivos\eec\'					,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
	oPrinter:SetPortrait()     //Retrato - SetPortrait() ou Paisagem - SetLandscape()
	oPrinter:SetMargin(30,30,30,30)
	oPrinter:setPaperSize(9)


	oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
	oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10 := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10n:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11 := TFont():New("Arial",9,11,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont11n:= TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12 := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont12n:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont13 := TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont13n:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14n:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17 := TFont():New("Arial",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17n:= TFont():New("Arial",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20 := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20n:= TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont18 := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont08  := TFont():New( "Arial",,08,,.f.,,,,,.f. )
	oFont08b := TFont():New( "Arial",,08,,.t.,,,,,.f. )
	oFont09  := TFont():New( "Arial",,09,,.f.,,,,,.f. )
	oFont09b := TFont():New( "Arial",,09,,.t.,,,,,.f. )
	oFont10  := TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont10b := TFont():New( "Times New Roman",,10,,.t.,,,,,.f. )
	oFont11  := TFont():New( "Arial",,11,,.f.,,,,,.f. )
	oFont11b := TFont():New( "Arial",,11,,.t.,,,,,.f. )
	oFont12  := TFont():New( "Arial",,12,,.f.,,,,,.f. )
	oFont12B := TFont():New( "Times New Roman",,12,,.t.,,,,,.f. )
	oFont12BI:= TFont():New( "Arial",,12,,.t.,,,,,.t. )
	oFont16b := TFont():New( "Times New Roman",,16,,.t.,,,,,.f. )
	oFont20b := TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
	oFont22b := TFont():New( "Times New Roman",,22,,.t.,,,,,.f. )
	oFont24b := TFont():New( "Times New Roman",,24,,.t.,,,,,.f. )

	aBmp := "STECK.BMP"
	_nlarg := 560

	oPrinter:StartPage()     // INICIALIZA a página

	_nToGer		:=0
	_nPesGer	:=0

	xCab('1')

	_cPosipi	:= ' '

	STCOL()

	While (cAlias1)->(!Eof())
		_nC00+= 1

		If _cPosipi <> (cAlias1)->EE9_POSIPI

			_cPosipi := (cAlias1)->EE9_POSIPI
			_nC00+= 2

		EndIf

		//_cdesc01:= ' '
		//_cdesc01:= Substr(Alltrim(MSMM((cAlias1)->EE9_DESC,AVSX3("EE9_VM_DES",3)) ),1,63)

		(cAlias1)->(DbSkip())

	EndDo

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())
	_cPosipi:= ' '

	ProcRegua(RecCount())

	While (cAlias1)->(!Eof())

		IncProc()

		_nC01		+= 1
		_nC02		+= 1
		_nToTal		:= 0
		_nPrcven	:= 0

		STCOL()

		_nIni+= _ntamLin

		If (cAlias1)->EEC_PRECOA = "1"

			_nPrcven :=  (cAlias1)->EE9_PRECO

		Else

			_nPrcven :=  Round((cAlias1)->EE9_PRECO*(cAlias1)->EE9_SLDINI,2)

		EndIf

		_nPrcven 	:= (cAlias1)->EE9_PRECO
		_nToTal 	+= Round((cAlias1)->EE9_PRECO*(cAlias1)->EE9_SLDINI,2)
		_nToGer 	+= _nToTal
		_nPesGer	+= (cAlias1)->EE9_PSLQTO
		//_cdesc01	:= ' '
		_cdesc02	:= ' '
		//_cdesc01	:= U_XTiraGraf( Substr(Alltrim(  U_xSTGETSYP((cAlias1)->EE9_DESC) ),1,46))
		_cdesc02	:= Alltrim(Posicione("SA7", 1, xFilial("SA7") + AllTrim (MV_PAR04)+ AllTrim (MV_PAR05) + ALLTRIM ((cAlias1)->EE9_COD_I), "A7_DESCCLI")) //U_XTiraGraf(     Substr(Alltrim(  U_xSTGETSYP((cAlias1)->EE9_DESC) ),64,120))
		_cCodCli	:= Alltrim(Posicione("SA7", 1, xFilial("SA7") + AllTrim (MV_PAR04)+ AllTrim (MV_PAR05) + ALLTRIM ((cAlias1)->EE9_COD_I), "A7_CODCLI")) //U_XTiraGraf(     Substr(Alltrim(  U_xSTGETSYP((cAlias1)->EE9_DESC) ),64,120))

		oPrinter:Say  (_nIni,5            , Transf(AVTransUnid((cAlias1)->EE9_UNIDAD,CriaVar("EE9_UNPRC"),(cAlias1)->EE9_COD_I,(cAlias1)->EE9_SLDINI,.f.),cPictQtde)  	,oFont08,,,,1	)
		oPrinter:Say  (_nIni,_nCol01+3    , _cCodCli						   																						  	,oFont08,,,,0	)
		oPrinter:Say  (_nIni,_nCol02+3    , Substr(Alltrim(_cdesc02),1,46)																  								,oFont08	 	)
		oPrinter:Say  (_nIni,_nCol03+5    , Alltrim((cAlias1)->EE9_COD_I)																								,oFont08,,,,1	)
		//oPrinter:Say  (_nIni,_nCol04+5    , _cdesc01 																													,oFont08,,,,1	)

		STCOL()

		If (_nIni + _ntamLin) > 789

			xPag()
			_nC02:=0

		EndIf

		(cAlias1)->(DbSkip())

	EndDo

	If _nC02 >= 19 .And. (_nC00-_nC01) < 50 

		xPag()
		_nC02	:=0

	EndIf
	
	(cAlias1)->(dbGoTop())
	DbSelectArea("EEC")
	EEC->(DbSetOrder(1))
	EEC->(DbSeek(xFilial("EEC")+(cAlias1)->EEC_PREEMB))
	
	xRoda()

	oPrinter:Say  (840,_nCol05+25 , cValTochar(_nPag+1)+ "º"  	,oFont08)
	oPrinter:EndPage()

	FERASE(cStartPath+_cNomePdf+".pdf")
	oPrinter:cPathPDF := cStartPath

	oPrinter:Print()
	oPrinter:EndPage()

	FERASE(_cDirRel+_cNomePdf+".pdf")
	CpyS2T(cStartPath+_cNomePdf+'.pdf',_cDirRel,.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
	ShellExecute("open",_cDirRel+_cNomePdf+'.pdf', "", "", 1)

	If !Empty(Select(cAlias1))

		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())

	Endif

Return

/*====================================================================================\
|Programa  | xPag             | Autor | 			              | Data | 24/05/2019 |
|=====================================================================================|
|Descrição | INICIALIZA a página			                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
Static Function xPag()

	_nPag		+=1
	_nIni		+= _ntamLin

	oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)
	oPrinter:Say  (840,_nCol05+25 , cValTochar(_nPag) + "º"  	,oFont08)
	oPrinter:EndPage()
	oPrinter:StartPage()     // INICIALIZA a página

	xCab(' ')

	_nIni += (_ntamLin*1)
Return()

/*====================================================================================\
|Programa  | xCab             | Autor |                           | Data | 24/05/2019 |
|=====================================================================================|
|Descrição | Gera Cabeçalho Relatorio EEC		                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
Static Function xCab(_cCab)

	Private _cNomeCom     := SM0->M0_NOMECOM
	Private _cEndereco    := Alltrim(SM0->M0_ENDENT)
	Private cCep          := SM0->M0_CEPENT
	Private cCidade       := SM0->M0_CIDENT
	Private cEstado       := SM0->M0_ESTENT
	Private cCNPJ         := Transform(SM0->M0_CGC, "@R 99.999.999-9999/99")
	Private cTelefone     := SM0->M0_TEL
	Private cFax          := SM0->M0_FAX


	oPrinter:Box(045,005,130,_nlarg)

	aBmp := "STECK.BMP"

	If File(aBmp)

		oPrinter:SayBitmap(060,020,aBmp,095,050 )

	EndIf

	oPrinter:Say  (055,150, _cNomeCom  																				,oFont12n)
	oPrinter:Say  (070,150, _cEndereco + " CEP: "+ SUBSTR(cCep,1,5)+"-"+SUBSTR(cCep,6,3) +" - BRASIL - "+cEstado	,oFont12)
	oPrinter:Say  (085,150, "CNPJ: "+cCNPJ 																			,oFont12)
	oPrinter:Say  (100,150, "TELEFONE: 55 11 2248-7081"  															,oFont12)
	oPrinter:Say  (120,150, Iif(_cOrigem= 'Sample',' ','DELIVERY')+' RECEIPT - '+ Iif(_cOrigem= 'Sample',_cOrigem+'  ',' ')+ Alltrim(Posicione("EE7", 1, xFilial("EE7") + AllTrim (MV_PAR02), "EE7_XSEQUE"))+'  '+Iif(_cOrigem= 'Sample',' ',_cOrigem)  ,oFont16b)
	oPrinter:Box(140,005,830,_nlarg)

	_nFator 	:= 100
	_nIni   	:= 150
	_ntamLin 	:= 10

	oPrinter:Say  (_nIni				,10     	    , "CONSIGNEE: "				,oFont08)
	oPrinter:Say  (_nIni 				,60     	    , (cAlias1)->EEC_IMPODE  	,oFont08)
	oPrinter:Say  (_nIni+_ntamLin		,60    			, (cAlias1)->EEC_ENDIMP		,oFont08)
	oPrinter:Say  (_nIni+(_ntamLin*2)	,60				, (cAlias1)->EEC_END2IM   	,oFont08)

	If SA1->(dbSeek(xFilial("SA1")+(cAlias1)->EEC_CONSIG+(cAlias1)->EEC_COLOJA))

		oPrinter:Say  (_nIni+(_ntamLin*3),60					, substr(SA1->A1_EMAIL,1,46)  			,oFont08)
		oPrinter:Say  (_nIni+(_ntamLin*4),60					, '('+ALLTRIM (SA1->A1_DDI)+')'			,oFont08)
		oPrinter:Say  (_nIni+(_ntamLin*4),80					, SA1->A1_TEL  							,oFont08)
		oPrinter:Say  (_nIni+(_ntamLin*5),60					, SA1->A1_XRUCNIT						,oFont08)

		_nIni	+= 3

	EndIf

	oPrinter:Say  (_nIni				 ,320					, Alltrim(Posicione("EE7", 1, xFilial("EE7") + AllTrim (MV_PAR02), "EE7_REFIMP"))   ,oFont08)

	_nIni += (_ntamLin*5)

	oPrinter:Line(_nIni   , 5 , _nIni 		,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+1 , 5 , _nIni +1	,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+2 , 5 , _nIni +2	,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+3 , 5 , _nIni +3	,_nlarg)   	// horizontal

	_nIni+=3

	_nIni+= _ntamLin

	oPrinter:Say  (_nIni,70              			, "P R O D U C T: "  	,oFont08)

	_nIni += (_ntamLin*1)

	oPrinter:Line(_nIni   , 5 , _nIni 		,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+1 , 5 , _nIni +1	,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+2 , 5 , _nIni +2	,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+3 , 5 , _nIni +3	,_nlarg)   	// horizontal

	_nIni	+=3

	_nIni	+= _ntamLin

	oPrinter:Say  (_nIni,10              						, "QTY/UNI"  						,oFont08)
	oPrinter:Say  (_nIni,_nCol01+5       						, "CODE CLI."  						,oFont08)
	oPrinter:Say  (_nIni,_nCol02+15              				, "D E S C R I P T I O N CLIENTE"  	,oFont08)
	oPrinter:Say  (_nIni,_nCol03+5       						, "CODE STECK"  					,oFont08)
	//oPrinter:Say  (_nIni,_nCol04+15       						, "D E S C R I P T I O N " 		,oFont08)
	//oPrinter:Say  (_nIni,_nCol05+3      						, "NET WEIGHT"  					,oFont08)

	STCOL()

	_nIni += (_ntamLin*1)

	STCOL()

	_nIni += (_ntamLin*1)

	oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+1 , 5 , _nIni +1,_nlarg)   	// horizontal

	_nIni+=3

Return

/*====================================================================================\
|Programa  | STCOL            | Autor |                           | Data | 24/05/2019 |
|=====================================================================================|
|Descrição | Gera Colunas Relatorio EEC		                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
Static Function STCOL()

	oPrinter:Line(_nIni-_ntamLin   , _nCol01  , _nIni+(_ntamLin*1) 	,_nCol01 )
	oPrinter:Line(_nIni-_ntamLin   , _nCol02  , _nIni+(_ntamLin*1)	,_nCol02 )
	oPrinter:Line(_nIni-_ntamLin   , _nCol03  , _nIni+(_ntamLin*1) 	,_nCol03 )
	//oPrinter:Line(_nIni-_ntamLin   , _nCol04  , _nIni+(_ntamLin*1) 	,_nCol04  )
	//oPrinter:Line(_nIni-_ntamLin   , _nCol05  , _nIni+400 	,_nCol05  )

Return

/*====================================================================================\
|Programa  | xRoda            | Autor |                           | Data | 24/05/2019 |
|=====================================================================================|
|Descrição | Gera Colunas Rodapé horizontal Relatorio EEC		                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
Static Function xRoda()

	Local nINC:=1

	oPrinter:Line(_nIni + 10   , 5 , _nIni + 10	,_nlarg)

	_nIni	:= 580

	oPrinter:Line(_nIni+(_ntamLin*16.8)   	, 5 , _nIni+(_ntamLin*16.8) 	,_nlarg)
	oPrinter:Line(_nIni+(_ntamLin*17)   	, 5 , _nIni+(_ntamLin*17) 		,_nlarg)   	// horizontal

	// regras para carregar dados
	SA2->(dbSetOrder(1))

	IF !EMPTY(EEC->EEC_EXPORT) .AND. SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))

		cExp_Cod     := EEC->EEC_EXPORT+EEC->EEC_EXLOJA
		cEXP_NOME    := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
		cEXP_CONTATO := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1)  //nome do contato seq 1
		cEXP_FONE    := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4)  //fone do contato seq 1
		cEXP_FAX     := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",7)  //fax do contato seq 1
		cEXP_CARGO   := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",2)  //CARGO

	ELSE

		SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))
		cExp_Cod     := EEC->EEC_FORN+EEC->EEC_FOLOJA
		cEXP_NOME    := SA2->A2_NOME
		cEXP_CONTATO := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
		cEXP_FONE    := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
		cEXP_FAX     := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
		cEXP_CARGO   := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",2,EEC->EEC_RESPON)  //CARGO

	ENDIF

	oPrinter:Say  (_nIni+(_ntamLin*18)	,05  		, cEXP_NOME  																																																		,oFont08,,,,0)
	oPrinter:Say  (_nIni+(_ntamLin*19)	,05 		, AllTrim(SA2->A2_MUN)+", "+Upper(IF(lIngles,cMonth(EEC->EEC_DTINVO),IF(EMPTY(EEC->EEC_DTINVO),"",aMeses[Month(EEC->EEC_DTINVO)])))+" "+StrZero(Day(EEC->EEC_DTINVO),2)+", "+Str(Year(EEC->EEC_DTINVO),4)+"." 		,oFont08,,,,0)
	oPrinter:Say  (_nIni+(_ntamLin*22)	,05			, cEXP_CONTATO  																																																	,oFont08,,,,0)
	oPrinter:Say  (_nIni+(_ntamLin*23)	,05			, cEXP_CARGO  																																																		,oFont08,,,,0)	
	//oPrinter:Line(_nIni+(_ntamLin*15)   ,_nCol07  	, 830 ,_nCol07 )


Return()

/*====================================================================================\
|Programa  | xPutSx1	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;	
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    	:= Iif( cPyme           == Nil, " ", cPyme          )
	cF3      	:= Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg 	:= Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   	:= Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      	:= Iif( cHelp          == Nil, "" , cHelp          )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid
		Replace X1_VAR01   With cVar01
		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg

		If Fieldpos("X1_PYME") > 0

			If cPyme != Nil

				Replace X1_PYME With cPyme

			Endif

		Endif

		Replace X1_CNT01   With cCnt01

		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1
			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2
			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3
			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4
			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()

	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl

			RecLock("SX1",.F.)

			If lPort

				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"

			EndIf

			If lSpa

				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"

			EndIf

			If lIngl

				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"

			EndIf

			SX1->(MsUnLock())

		EndIf

	Endif

	RestArea( aArea )

Return
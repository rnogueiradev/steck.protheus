#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFATAC    บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio EAA STIP		 				                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFATAC()// u_RSTFATAC()
	*-----------------------------*
	Local lAdjustToLegacy 	:= .F.
	Local lDisableSetup  	:= .T.
	
	Local _aParamBox 		:= {}
	Local aUsers 			:= {}
	Local aUsuarios 			:= {}
	Local _aRet 			:= {}
	Local cQuery1  			:= ' '
		Local j		:= 0
			Local i		:= 0
	Private cAlias1 			:=  'RSTFATAC'
	Private _cNomePdf 		:= "Eaa Stip"
	Private cStartPath		:= 'C:\arquivos_protheus\'
	Private _cDirRel  		:= ''//Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private oPrinter
	
	Private	_nFator := 100
	Private	_nIni   := 150
	Private	_ntamLin := 10
	
	
	If !(__cuserid $ Getmv("ST_STFATAC",,"000000/000645/000308/000591") )
		MsgInfo("usuario sem acesso")
		Return()
	EndIf
	
	
	//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
	_cDirRel  		:= Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	
	AADD(_aParamBox,{1,"Participante de"	,Space(6) ,""  ,"","US1","",0,.F.}) //50
	AADD(_aParamBox,{1,"Participante ate"	,Space(6) ,""  ,"",'US1',"",0,.F.}) //50
	AADD(_aParamBox,{1,"Ano de"				,Space(4) ,""  ,"","","",0,.F.}) //50
	AADD(_aParamBox,{1,"Ano ate"			,Space(4) ,""  ,"","","",0,.F.}) //50
	
	If ParamBox(_aParamBox,"Filtro de Participantes       ",@_aRet,,,.T.,,500)
		
		
		
		cQuery1  := " SELECT
		cQuery1  += " PH3_USERID, PH1_NOME ,PH1_SETOR, PH1_SUP,     PH1_ADMISS ,    PH1_CARGO ,      PH1_LID ,
		cQuery1  += " PH3_ANO,
		cQuery1  += " trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_M1, 3200,1)))
		cQuery1  += ' "PH3_M1",
		cQuery1  += " PH3_T1,
		cQuery1  += " PH3_MI1,
		cQuery1  += " PH3_MA1,
		cQuery1  += " trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_OBSA1, 3200,1)))
		cQuery1  += ' "PH3_OBSA1",
		cQuery1  += " trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_OBSP1, 3200,1)))
		cQuery1  += ' "PH3_OBSP1",
		cQuery1  += " trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_M2, 3200,1)))
		cQuery1  += ' "PH3_M2",
		cQuery1  += " PH3_T2     ,
		cQuery1  += " PH3_MI2     ,
		cQuery1  += " PH3_MA2     ,
		cQuery1  += "      trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_OBSA2, 3200,1)))
		cQuery1  += ' "PH3_OBSA2",
		cQuery1  += "       trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_OBSP2, 3200,1)))
		cQuery1  += ' "PH3_OBSP2",
		cQuery1  += "           trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_M3, 3200,1)))
		cQuery1  += ' "PH3_M3",
		cQuery1  += " PH3_T3      ,
		cQuery1  += " PH3_MI3     ,
		cQuery1  += " PH3_MA3     ,
		cQuery1  += " trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_OBSA3, 3200,1)))
		cQuery1  += ' "PH3_OBSA3",
		cQuery1  += " trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_OBSP3, 3200,1)))
		cQuery1  += ' "PH3_OBSP3",
		cQuery1  += " trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_M4, 3200,1)))
		cQuery1  += ' "PH3_M4",
		
		cQuery1  += " PH3_T4      ,
		cQuery1  += " PH3_MI4     ,
		cQuery1  += " PH3_MA4     ,
		
		cQuery1  += " trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_OBSA4, 3200,1)))
		cQuery1  += ' "PH3_OBSA4",
		cQuery1  += " trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_OBSP4, 3200,1)))
		cQuery1  += ' "PH3_OBSP4",
		cQuery1  += " trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_M5, 3200,1)))
		cQuery1  += ' "PH3_M5",
		
		cQuery1  += " PH3_T5      ,
		cQuery1  += " PH3_MI5     ,
		cQuery1  += " PH3_MA5     ,
		
		cQuery1  += " trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_OBSA5, 3200,1)))
		cQuery1  += ' "PH3_OBSA5",
		cQuery1  += " trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_OBSP5, 3200,1)))
		cQuery1  += ' "PH3_OBSP5",
		
		cQuery1  += " PH3_AC1     ,
		cQuery1  += " PH3_AC2     ,
		cQuery1  += " PH3_AC3     ,
		cQuery1  += " PH3_AC4     ,
		cQuery1  += " PH3_AC5     ,
		cQuery1  += " PH3_AC6     ,
		cQuery1  += " PH3_AC7     ,
		cQuery1  += " PH3_AC8     ,
		cQuery1  += " PH3_AC9     ,
		cQuery1  += " PH3_AC10     ,
		cQuery1  += " PH3_AC11     ,
		
		cQuery1  += " trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_COME01, 3200,1)))
		cQuery1  += ' "PH3_COME01",
		cQuery1  += " PH3_AVAV     ,
		cQuery1  += " trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PH3_COME02, 3200,1)))
		cQuery1  += ' "PH3_COME02",
		
		cQuery1  += " PH3_AVPA     ,
		cQuery1  += " PH3_PC1     ,
		cQuery1  += " PH3_PC2     ,
		cQuery1  += " PH3_PC3     ,
		cQuery1  += " PH3_PC4     ,
		cQuery1  += " PH3_PC5     ,
		cQuery1  += " PH3_PC6     ,
		cQuery1  += " PH3_PC7     ,
		cQuery1  += " PH3_PC8     ,
		cQuery1  += " PH3_PC9     ,
		cQuery1  += " PH3_PC10     ,
		cQuery1  += " PH3_PC11     ,
		cQuery1  += " PH3_A1     ,
		cQuery1  += " PH3_A2     ,
		cQuery1  += " PH3_A3     ,
		cQuery1  += " PH3_A4     ,
		cQuery1  += " PH3_A5     ,
		cQuery1  += " PH3_B1     ,
		cQuery1  += " PH3_B2     ,
		cQuery1  += " PH3_B3     ,
		cQuery1  += " PH3_B4     ,
		cQuery1  += " PH3_B5
		cQuery1  += "  FROM PH3010 PH3
		cQuery1  += "  INNER JOIN(SELECT * FROM PH1010)PH1
		cQuery1  += "  ON PH1.D_E_L_E_T_ = ' '
		cQuery1  += "  AND PH1_USER = PH3_USERID
		cQuery1  += "  AND PH1_ANO = PH3_ANO
		cQuery1  += " WHERE PH3_ANO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
		cQuery1  += " AND PH3.PH3_USERID BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQuery1  += " AND PH3.D_E_L_E_T_   = ' '
		//cQuery1  += " AND PH3.PH3_T1  <> ' '
		
		
		
		
		
		
		If !Empty(Select(cAlias1))
			DbSelectArea(cAlias1)
			(cAlias1)->(dbCloseArea())
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)
		
		
		
		dbSelectArea(cAlias1)
		(cAlias1)->(dbGoTop())
		
		
		
		
		
		
		
		
		oPrinter := FWMSPrinter():New(_cNomePdf, IMP_PDF, lAdjustToLegacy,'\arquivos\Pedido\', lDisableSetup, , , , , , .F., )
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
		oFont20b := TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
		oFont22b := TFont():New( "Times New Roman",,22,,.t.,,,,,.f. )
		oFont24b := TFont():New( "Times New Roman",,24,,.t.,,,,,.f. )
		
		aBmp := "STECK.BMP"
		_nlarg := 520
		While (cAlias1)->(!Eof())
			
			oPrinter:StartPage()     // INICIALIZA a pแgina
			
			xCab()
			
			p:=95
			for i:= 1 to 5
				_nIni += (_ntamLin)
				xPag()
				oPrinter:Say  (_nIni,10              , "META - "+PADL( i,1,'0') ,oFont12B)
				_nIni += (_ntamLin)
				_nIni += 3
				xPag()
				oPrinter:Say  (_nIni,10              , "Meta:" ,oFont11n)
				
				oPrinter:Say  (_nIni,350              , "Target:" ,oFont11n)
				oPrinter:Say  (_nIni,400              , "Minimo:" ,oFont11n)
				oPrinter:Say  (_nIni,450              , "Maximo:" ,oFont11n)
				_nIni += (_ntamLin)
				xPag()
				_cCamp:= "PH3_T"+cvaltochar(i)
				oPrinter:Say  (_nIni,350            ,   Alltrim((cAlias1)->(&_cCamp))  ,oFont08)
				_cCamp:= "PH3_MI"+cvaltochar(i)
				oPrinter:Say  (_nIni,400             ,   Alltrim((cAlias1)->(&_cCamp))  ,oFont08)
				_cCamp:= "PH3_MA"+cvaltochar(i)
				oPrinter:Say  (_nIni,450            ,   Alltrim((cAlias1)->(&_cCamp))  ,oFont08)
				_nIni -= (_ntamLin)
				
				_cCamp:= "PH3_M"+cvaltochar(i)
				w:=0
				If Len(Alltrim((cAlias1)->&(_cCamp))) > p
					For j:=1 to (round((Len(Alltrim((cAlias1)->(&_cCamp)))/p),0)+1)
						l:= w
						
						_nIni += (_ntamLin)
						xPag()
						oPrinter:Say  (_nIni,10             ,   substr(Alltrim((cAlias1)->(&_cCamp)),w+1,p)  ,oFont08)
						w:=l+p
					Next j
				Else
					_nIni += (_ntamLin)
					xPag()
					oPrinter:Say  (_nIni,10             ,   Alltrim((cAlias1)->(&_cCamp))  ,oFont08)
				EndIf
				
				_nIni += (_ntamLin)
				_nIni += 3
				xPag()
				oPrinter:Say  (_nIni,400              , "Performance:" ,oFont11n)
				_nIni += (_ntamLin)
				_cCamp:= "PH3_A"+cvaltochar(i)
				xPag()
				If (cAlias1)->(&_cCamp)='1'
					_cRet := 'Exceeds Target'
				ElseIf (cAlias1)->(&_cCamp)='2'
					_cRet := 'On Target'
				ElseIf (cAlias1)->(&_cCamp)='3'
					_cRet := 'Partially On Target'
				ElseIf (cAlias1)->(&_cCamp)='4'
					_cRet := 'Below Target'
				Else
					_cRet := ''
				EndIf
				
				oPrinter:Say  (_nIni,400            ,   _cRet  ,oFont08)
				_nIni -= (_ntamLin)
				
				oPrinter:Say  (_nIni,10              , "Obs.Participante:" ,oFont11n)
				
				
				
				_cCamp:= "PH3_OBSP"+cvaltochar(i)
				w:=0
				If Len(Alltrim((cAlias1)->&(_cCamp))) > p
					For j:=1 to (round((Len(Alltrim((cAlias1)->(&_cCamp)))/p),0)+1)
						l:= w
						
						_nIni += (_ntamLin)
						xPag()
						oPrinter:Say  (_nIni,10             ,   substr(Alltrim((cAlias1)->(&_cCamp)),w+1,p)  ,oFont08)
						w:=l+p
					Next j
				Else
					_nIni += (_ntamLin)
					xPag()
					oPrinter:Say  (_nIni,10             ,   Alltrim((cAlias1)->(&_cCamp))  ,oFont08)
				EndIf
				
				_nIni += (_ntamLin)
				_nIni += 3
				xPag()
				oPrinter:Say  (_nIni,400              , "Performance:" ,oFont11n)
				_nIni += (_ntamLin)
				xPag()
				_cCamp:= "PH3_B"+cvaltochar(i)
				If (cAlias1)->(&_cCamp)='1'
					_cRet := 'Exceeds Target'
				ElseIf (cAlias1)->(&_cCamp)='2'
					_cRet := 'On Target'
				ElseIf (cAlias1)->(&_cCamp)='3'
					_cRet := 'Partially On Target'
				ElseIf (cAlias1)->(&_cCamp)='4'
					_cRet := 'Below Target'
				Else
					_cRet := ''
				EndIf
				
				oPrinter:Say  (_nIni,400            ,   _cRet  ,oFont08)
				_nIni -= (_ntamLin)
				
				oPrinter:Say  (_nIni,10              , "Obs.Avaliador:" ,oFont11n)
				
				
				
				_cCamp:= "PH3_OBSA"+cvaltochar(i)
				w:=0
				If Len(Alltrim((cAlias1)->&(_cCamp))) > p
					For j:=1 to (round((Len(Alltrim((cAlias1)->(&_cCamp)))/p),0)+1)
						l:= w
						
						_nIni += (_ntamLin)
						xPag()
						oPrinter:Say  (_nIni,10             ,   substr(Alltrim((cAlias1)->(&_cCamp)),w+1,p)  ,oFont08)
						w:=l+p
					Next j
				Else
					_nIni += (_ntamLin)
					xPag()
					oPrinter:Say  (_nIni,10             ,   Alltrim((cAlias1)->(&_cCamp))  ,oFont08)
				EndIf
				
				
				_nIni += (_ntamLin)
				oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)   	// horizontal
				
				xPag()
				
				
				
				
				
				_nIni += (_ntamLin)
				oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)   	// horizontal
				
				xPag()
			next i
			
			_nIni += (_ntamLin)
			xPag()
			oPrinter:Say  (_nIni,10              , "AVALIAวรO COMPORTAMENTAL" ,oFont12B)
			_nIni += (_ntamLin)
			_nIni += 3
			xPag()
			oPrinter:Say  (_nIni,10              , "Participante:" ,oFont11n)
			If 			(cAlias1)->PH1_LID = 'Sim'
				
				_nIni += (_ntamLin)
				xPag()
				oPrinter:Say  (_nIni,100             ,   'Business dev'  ,oFont08b)
				oPrinter:Say  (_nIni,250            ,   'Team builder'  ,oFont08b)
				_nIni += (_ntamLin)
				xPag()
				If Alltrim((cAlias1)->PH3_AC1)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_AC1)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_AC1)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,100             ,     _cRet  ,oFont08)
				If Alltrim((cAlias1)->PH3_AC2)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_AC2)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_AC2)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,250             ,   _cRet    ,oFont08)
				
				_nIni += (_ntamLin*2)
				xPag()
				oPrinter:Say  (_nIni,100             ,   'Team player'  ,oFont08b)
				oPrinter:Say  (_nIni,250            ,   'Values role'  ,oFont08b)
				_nIni += (_ntamLin)
				xPag()
				If Alltrim((cAlias1)->PH3_AC3)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_AC3)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_AC3)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,100             ,     _cRet  ,oFont08)
				If Alltrim((cAlias1)->PH3_AC4)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_AC4)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_AC4)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,250             ,   _cRet    ,oFont08)
				
				_nIni += (_ntamLin*2)
				xPag()
				oPrinter:Say  (_nIni,100             ,   'Great profes'  ,oFont08b)
				oPrinter:Say  (_nIni,250            ,   'Decision mak'  ,oFont08b)
				_nIni += (_ntamLin)
				xPag()
				If Alltrim((cAlias1)->PH3_AC5)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_AC5)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_AC5)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,100             ,     _cRet  ,oFont08)
				If Alltrim((cAlias1)->PH3_AC6)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_AC6)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_AC6)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,250             ,   _cRet    ,oFont08)
				
			Else
				
				
				_nIni += (_ntamLin)
				xPag()
				oPrinter:Say  (_nIni,100             ,   'Passionate  '  ,oFont08b)
				oPrinter:Say  (_nIni,250            ,   'Open'  ,oFont08b)
				_nIni += (_ntamLin)
				xPag()
				If Alltrim((cAlias1)->PH3_AC7)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_AC7)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_AC7)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,100             ,     _cRet  ,oFont08)
				If Alltrim((cAlias1)->PH3_AC8)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_AC8)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_AC8)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,250             ,   _cRet    ,oFont08)
				
				_nIni += (_ntamLin*2)
				xPag()
				oPrinter:Say  (_nIni,100             ,   'Straightforw'  ,oFont08b)
				oPrinter:Say  (_nIni,250            ,   'Effective   '  ,oFont08b)
				_nIni += (_ntamLin)
				xPag()
				If Alltrim((cAlias1)->PH3_AC9)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_AC9)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_AC9)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,100             ,     _cRet  ,oFont08)
				If Alltrim((cAlias1)->PH3_AC10)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_AC10)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_AC10)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,250             ,   _cRet    ,oFont08)
				
				_nIni += (_ntamLin*2)
				xPag()
				oPrinter:Say  (_nIni,100             ,   'Respect'  ,oFont08b)
				
				_nIni += (_ntamLin)
				xPag()
				If Alltrim((cAlias1)->PH3_AC11)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_AC11)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_AC11)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,100             ,     _cRet  ,oFont08)
				
				
				
				
			EndIf
			
			
			
			_nIni += (_ntamLin)
			_nIni += 3
			xPag()
			oPrinter:Say  (_nIni,10              , "Avaliador:" ,oFont11n)
			
			If 			(cAlias1)->PH1_LID = 'Sim'
				
				_nIni += (_ntamLin)
				xPag()
				oPrinter:Say  (_nIni,100             ,   'Business dev'  ,oFont08b)
				oPrinter:Say  (_nIni,250            ,   'Team builder'  ,oFont08b)
				_nIni += (_ntamLin)
				xPag()
				If Alltrim((cAlias1)->PH3_PC1)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_PC1)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_PC1)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,100             ,     _cRet  ,oFont08)
				If Alltrim((cAlias1)->PH3_PC2)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_PC2)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_PC2)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,250             ,   _cRet    ,oFont08)
				
				_nIni += (_ntamLin*2)
				xPag()
				oPrinter:Say  (_nIni,100             ,   'Team player'  ,oFont08b)
				oPrinter:Say  (_nIni,250            ,   'Values role'  ,oFont08b)
				_nIni += (_ntamLin)
				xPag()
				If Alltrim((cAlias1)->PH3_PC3)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_PC3)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_PC3)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,100             ,     _cRet  ,oFont08)
				If Alltrim((cAlias1)->PH3_PC4)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_PC4)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_PC4)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,250             ,   _cRet    ,oFont08)
				
				_nIni += (_ntamLin*2)
				xPag()
				oPrinter:Say  (_nIni,100             ,   'Great profes'  ,oFont08b)
				oPrinter:Say  (_nIni,250            ,   'Decision mak'  ,oFont08b)
				_nIni += (_ntamLin)
				xPag()
				If Alltrim((cAlias1)->PH3_PC5)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_PC5)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_PC5)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,100             ,     _cRet  ,oFont08)
				If Alltrim((cAlias1)->PH3_PC6)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_PC6)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_PC6)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,250             ,   _cRet    ,oFont08)
				
			Else
				
				
				_nIni += (_ntamLin)
				xPag()
				oPrinter:Say  (_nIni,100             ,   'Passionate  '  ,oFont08b)
				oPrinter:Say  (_nIni,250            ,   'Open'  ,oFont08b)
				_nIni += (_ntamLin)
				xPag()
				If Alltrim((cAlias1)->PH3_PC7)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_PC7)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_PC7)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,100             ,     _cRet  ,oFont08)
				If Alltrim((cAlias1)->PH3_PC8)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_PC8)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_PC8)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,250             ,   _cRet    ,oFont08)
				
				_nIni += (_ntamLin*2)
				xPag()
				oPrinter:Say  (_nIni,100             ,   'Straightforw'  ,oFont08b)
				oPrinter:Say  (_nIni,250            ,   'Effective   '  ,oFont08b)
				_nIni += (_ntamLin)
				xPag()
				If Alltrim((cAlias1)->PH3_PC9)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_PC9)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_PC9)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,100             ,     _cRet  ,oFont08)
				If Alltrim((cAlias1)->PH3_PC10)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_PC10)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_PC10)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,250             ,   _cRet    ,oFont08)
				
				_nIni += (_ntamLin*2)
				xPag()
				oPrinter:Say  (_nIni,100             ,   'Respect'  ,oFont08b)
				
				_nIni += (_ntamLin)
				xPag()
				If Alltrim((cAlias1)->PH3_PC11)='1'
					_cRet := 'Improvement Area'
				ElseIf Alltrim((cAlias1)->PH3_PC11)='2'
					_cRet := 'Demonstrated'
				ElseIf Alltrim((cAlias1)->PH3_PC11)='3'
					_cRet := 'Role Model'
				Else
					_cRet := ''
				EndIf
				oPrinter:Say  (_nIni,100             ,     _cRet  ,oFont08)
				
				
				
				
			EndIf
			
			_nIni += (_ntamLin)
			
			oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)   	// horizontal
			
			xPag()
			
			_nIni += (_ntamLin*2)
			xPag()
			
			
			
			oPrinter:Say  (_nIni,400              , "Avali็ใo Final:" ,oFont11n)
			_nIni += (_ntamLin)
			xPag()
			_cCamp:= "PH3_AVPA"
			If (cAlias1)->(&_cCamp)='1'
				_cRet := 'High Performer'
			ElseIf (cAlias1)->(&_cCamp)='2'
				_cRet := 'Performer'
			ElseIf (cAlias1)->(&_cCamp)='3'
				_cRet := 'Competent'
			ElseIf (cAlias1)->(&_cCamp)='4'
				_cRet := 'Under-performer '
			Else
				_cRet := ''
			EndIf
			
			oPrinter:Say  (_nIni,400            ,   _cRet  ,oFont08)
			_nIni -= (_ntamLin)
			
			oPrinter:Say  (_nIni,10              , "Comentario Participante:" ,oFont11n)
			
			
			
			_cCamp:= "PH3_COME02"
			w:=0
			If Len(Alltrim((cAlias1)->&(_cCamp))) > p
				For j:=1 to (round((Len(Alltrim((cAlias1)->(&_cCamp)))/p),0)+1)
					l:= w
					
					_nIni += (_ntamLin)
					xPag()
					oPrinter:Say  (_nIni,10             ,   substr(Alltrim((cAlias1)->(&_cCamp)),w+1,p)  ,oFont08)
					w:=l+p
				Next j
			Else
				_nIni += (_ntamLin)
				xPag()
				oPrinter:Say  (_nIni,10             ,   Alltrim((cAlias1)->(&_cCamp))  ,oFont08)
			EndIf
			
			
			_nIni += (_ntamLin)
			oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)   	// horizontal
			
			xPag()
			_nIni += (_ntamLin)
			
			oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)   	// horizontal
			
			xPag()
			
			_nIni += (_ntamLin*2)
			xPag()
			
			
			
			oPrinter:Say  (_nIni,400              , "Avali็ใo Final:" ,oFont11n)
			_nIni += (_ntamLin)
			xPag()
			_cCamp:= "PH3_AVAV"
			If (cAlias1)->(&_cCamp)='1'
				_cRet := 'High Performer'
			ElseIf (cAlias1)->(&_cCamp)='2'
				_cRet := 'Performer'
			ElseIf (cAlias1)->(&_cCamp)='3'
				_cRet := 'Competent'
			ElseIf (cAlias1)->(&_cCamp)='4'
				_cRet := 'Under-performer '
			Else
				_cRet := ''
			EndIf
			
			oPrinter:Say  (_nIni,400            ,   _cRet  ,oFont08)
			_nIni -= (_ntamLin)
			
			oPrinter:Say  (_nIni,10              , "Comentario Avaliador:" ,oFont11n)
			
			
			
			_cCamp:= "PH3_COME01"
			w:=0
			If Len(Alltrim((cAlias1)->&(_cCamp))) > p
				For j:=1 to (round((Len(Alltrim((cAlias1)->(&_cCamp)))/p),0)+1)
					l:= w
					
					_nIni += (_ntamLin)
					xPag()
					oPrinter:Say  (_nIni,10             ,   substr(Alltrim((cAlias1)->(&_cCamp)),w+1,p)  ,oFont08)
					w:=l+p
				Next j
			Else
				_nIni += (_ntamLin)
				xPag()
				oPrinter:Say  (_nIni,10             ,   Alltrim((cAlias1)->(&_cCamp))  ,oFont08)
			EndIf
			
			
			_nIni += (_ntamLin)
			oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)   	// horizontal
			
			xPag()
			
			
			
			
			
			
			
			oPrinter:EndPage()
			(cAlias1)->(DbSkip())
			
		EndDo
		
		
		FERASE(_cDirRel+_cNomePdf+".pdf")
		oPrinter:cPathPDF := cStartPath
		
		oPrinter:Print()
		oPrinter:EndPage()
		
		//CpyS2T(cStartPath+_cNomePdf+'.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUมRIO
		ShellExecute("open",_cDirRel+"\"+_cNomePdf+'.pdf', "", "", 1)
		
	EndIf
	
	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif
Return


Static Function xPag()
	If _nIni >= 800
		oPrinter:EndPage()
		oPrinter:StartPage()     // INICIALIZA a pแgina
		xCab()
		_nIni += (_ntamLin*2)
	EndIf
Return()

Static Function xCab()
	
	Private _cNomeCom     := SM0->M0_NOMECOM
	Private _cEndereco    := SM0->M0_ENDENT
	Private cCep          := SM0->M0_CEPENT
	Private cCidade       := SM0->M0_CIDENT
	Private cEstado       := SM0->M0_ESTENT
	Private cCNPJ         := SM0->M0_CGC
	Private cTelefone     := SM0->M0_TEL
	Private cFax          := SM0->M0_FAX
	
	
	oPrinter:Box(045,005,130,520)
	
	aBmp := "STECK.BMP"
	
	If File(aBmp)
		oPrinter:SayBitmap(060,020,aBmp,095,050 )
	EndIf
	
	oPrinter:Say  (070,120, _cNomeCom  ,oFont12)
	oPrinter:Say  (085,120, _cEndereco ,oFont12)
	oPrinter:Say  (100,120,"CEP: "+ SUBSTR(cCep,1,5)+"-"+SUBSTR(cCep,6,3) +" - "+Alltrim(cCidade)+" - "+cEstado,oFont12)
	oPrinter:Say  (120,350, 'Avalia็ใo E. A. A.'  ,oFont20b)
	oPrinter:Box(140,005,800,_nlarg)
	
	_nFator := 100
	_nIni   := 150
	_ntamLin := 10
	
	
	
	oPrinter:Say  (_nIni,10              , "Colaborador: "  ,oFont08)
	oPrinter:Say  (_nIni,100             ,   (cAlias1)->PH1_NOME  ,oFont08)
	oPrinter:Say  (_nIni+_ntamLin,10     , "Ano: "  		,oFont08)
	oPrinter:Say  (_nIni+_ntamLin,100    , (cAlias1)->PH3_ANO,oFont08)
	oPrinter:Say  (_nIni+(_ntamLin*2),10 , "Cargo: "  		,oFont08)
	oPrinter:Say  (_nIni+(_ntamLin*2),100, (cAlias1)->PH1_CARGO   ,oFont08)
	oPrinter:Say  (_nIni+(_ntamLin*3),10 , "Setor: "  		,oFont08)
	oPrinter:Say  (_nIni+(_ntamLin*3),100, (cAlias1)->PH1_SETOR   ,oFont08)
	
	_nIni += (_ntamLin*4)
	
	oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+1 , 5 , _nIni +1,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+2 , 5 , _nIni +2,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+3 , 5 , _nIni +3,_nlarg)   	// horizontal
	
	_nIni+=3
Return

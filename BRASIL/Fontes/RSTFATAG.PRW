#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "EECRDM.CH"

//#INCLUDE "EECPEM11.ch"
#define STR0001  "TEL.: "
#define STR0002  " FAX: "
#define STR0003  "Unidade de medida "
#define STR0004  " nào cadastrada em "
#define STR0005  "Aviso"
#define STR0006  "Notas Fiscais:"
#define STR0007  "Código"
#define STR0008  "Descrição"
#define STR0009  "Documentos Para"
#define STR0010  "Notify's"
#define STR0011  "Mensagens"
#define STR0012  "Observações"
#define STR0013  "Imprime N.C.M."
#define STR0014  "Sim"
#define STR0015  "Não"
#define STR0016  "Imprime Peso Bruto"
#define STR0017  "Assinante"
#define STR0018  "Cargo"
#define STR0019  "Doct.Para"
#define STR0020  "Tipo Mensagem"
#define STR0021  "Configurações"
#define STR0022  "Unidades de Medida"
#define STR0023  "U.M. Qtde.:"
#define STR0024  "U.M. Preço.:"
#define STR0025  "U.M. Peso.:"
#define STR0026  "Impressão"

#define cPict1 "@E 999,999,999"
#define cPict2 "@E 999,999,999.99"




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATAG    ºAutor  ³Giovani Zago    º Data ³  23/03/16     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio EEC  		 				                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFATAG()// u_RSTFATAG()
	*-----------------------------*
	Local lAdjustToLegacy 	:= .F.
	Local lDisableSetup  	:= .T.
	Local _aParamBox 		:= {}
	Local aUsers 			:= {}
	Local aUsuarios 			:= {}
	Local _aRet 			:= {}
	Local cQuery1  			:= ' '
	Local _Origem     := GetMv("ST_COMORI",,'NBO/NGB/SHA/SGH/CTG/BNV')
	Private lIngles := .t.
	Private cAlias1 			:=  'RSTFATAG'
	Private _cNomePdf 		:= "EEC"
	Private cStartPath		:= 'C:\arquivos_protheus\'
	Private _cDirRel  		:= ''//Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private oPrinter
	Private	_nFator := 100
	Private	_nIni   := 150
	Private	_ntamLin := 10
	Private _cOrigem := ' '
	Private _nCol01		  := 42
	Private _nCol02		  := 105
	Private _nCol03		  := 415
	Private _nCol04		  := 465
	Private _nCol05		  := 510
	Private _nCol06		  := 210
	Private _nCol07		  := 350
	Private _nCol08		  := 510
	Private cPict 		  := "999,999,999.99"
	Private cVol 		  := ""
	Private nPesBrParc 	  := 0
	Private cPictDecPrc := if(EEC->EEC_DECPRC > 0, "."+Replic("9",EEC->EEC_DECPRC),"")
	Private cPictDecPes := if(EEC->EEC_DECPES > 0, "."+Replic("9",EEC->EEC_DECPES),"")
	Private cPictDecQtd := if(EEC->EEC_DECQTD > 0, "."+Replic("9",EEC->EEC_DECQTD),"")

	Private cPictPreco := "999,999,999"+cPictDecPrc
	Private cPictPeso  := "9,999,999.999" //+cPictDecPes
	Private cPictQtde  := "9,999,999"+cPictDecQtd

	Private nPesLiq 	:= 0
	Private nPesBru 	:= 0
	Private nPallet 	:= 0
	Private nPsPall     := 0
	Private _nC00 		:= 0
	Private _nC01 		:= 0
	Private _nC02 		:= 0
	Private _nPag 		:= 0
	Private _Origem     := GetMv("ST_COMORI",,'NBO/NGB/SHA/SGH/CTG/BNV')

	If EEC->EEC_ORIGEM $ _Origem
		_cOrigem := 'Back to Back'
	ElseIf EEC->EEC_AMOSTR = '1'
		_cOrigem := 'Sample'
	EndIf

	_cDirRel  		:= Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')

	cQuery1  := " SELECT *

	cQuery1  += " FROM "+RetSqlName("EEC")+" EEC "

	cQuery1  += " LEFT JOIN(SELECT * FROM "+RetSqlName("SA2")+" ) SA2 "
	cQuery1  += " ON SA2.D_E_L_E_T_ = ' '
	cQuery1  += " AND SA2.A2_COD = EEC.EEC_EXPORT
	cQuery1  += " AND SA2.A2_LOJA = EEC.EEC_EXLOJA

	cQuery1  += " LEFT JOIN(SELECT * FROM "+RetSqlName("SA2")+" ) TA2 "
	cQuery1  += " ON TA2.D_E_L_E_T_ = ' '
	cQuery1  += " AND TA2.A2_COD = EEC.EEC_FORN
	cQuery1  += " AND TA2.A2_LOJA = EEC.EEC_FOLOJA


	cQuery1  += " INNER JOIN (SELECT * FROM "+RetSqlName("EE9")+" ) EE9 "
	cQuery1  += " ON EE9.D_E_L_E_T_ = ' '
	cQuery1  += " AND EE9_PREEMB = EEC_PREEMB
	cQuery1  += " AND EE9_FILIAL = EEC_FILIAL

	cQuery1  += " INNER JOIN(SELECT * FROM "+RetSqlName("SB1")+" ) SB1 "
	cQuery1  += " ON SB1.D_E_L_E_T_ =  ' '
	cQuery1  += " AND B1_COD = EE9_COD_I



	cQuery1  += " WHERE EEC.D_E_L_E_T_ = ' '
	cQuery1  += " AND EEC_PREEMB = '"+EEC->EEC_PREEMB+"'
	cQuery1  += " AND EEC_FILIAL = '"+xFilial("EEC")+"'  ORDER BY EE9_POSIPI,EE9_COD_I


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
	oFont16b := TFont():New( "Times New Roman",,16,,.t.,,,,,.f. )
	oFont20b := TFont():New( "Times New Roman",,20,,.t.,,,,,.f. )
	oFont22b := TFont():New( "Times New Roman",,22,,.t.,,,,,.f. )
	oFont24b := TFont():New( "Times New Roman",,24,,.t.,,,,,.f. )

	aBmp := "STECK.BMP"
	_nlarg := 560

	oPrinter:StartPage()     // INICIALIZA a página
	_nToGer:=0
	_nPesGer:=0
	xCab('1')
	_cPosipi:= ' '
	STCOL()

	While (cAlias1)->(!Eof())
		_nC00+= 1

		If _cPosipi <> (cAlias1)->EE9_POSIPI
			_cPosipi := (cAlias1)->EE9_POSIPI
			_nC00+= 2
		EndIf

		_cdesc01:= ' '
		_cdesc02:= ' '
		_cdesc01:= Substr(Alltrim(MSMM((cAlias1)->EE9_DESC,AVSX3("EE9_VM_DES",3)) ),1,63)
		_cdesc02:= Substr(Alltrim(MSMM((cAlias1)->EE9_DESC,AVSX3("EE9_VM_DES",3)) ),64,120)

		If !(Empty(Alltrim(_cdesc02)))
			_nC00+= 1
		EndIf

		(cAlias1)->(DbSkip())

	EndDo

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())
	_cPosipi:= ' '
	While (cAlias1)->(!Eof())
		_nC01+= 1
		_nC02+= 1
		_nToTal	:= 0
		_nPrcven:= 0
		If _cPosipi <> (cAlias1)->EE9_POSIPI
			_cPosipi := (cAlias1)->EE9_POSIPI
			_nIni+= _ntamLin
			STCOL()
			_nIni+= _ntamLin
			oPrinter:Say  (_nIni,_nCol02+35 , Transf((cAlias1)->EE9_POSIPI,AVSX3("EE9_POSIPI",6))  	,oFont08)
			_nIni+= (_ntamLin/2)
			oPrinter:Say  (_nIni,_nCol02+30 , Replic("-",25)  	,oFont08)
			STCOL()
			_nC01+= 2
			_nC02+= 1
		EndIf
		STCOL()
		_nIni+= _ntamLin

		If (cAlias1)->EEC_PRECOA = "1"
			_nPrcven :=  (cAlias1)->EE9_PRECO
		Else
			_nPrcven :=  Round((cAlias1)->EE9_PRECO*(cAlias1)->EE9_SLDINI,2)
		EndIf
		_nPrcven :=  (cAlias1)->EE9_PRECO
		_nToTal += Round((cAlias1)->EE9_PRECO*(cAlias1)->EE9_SLDINI,2)
		_nToGer += _nToTal
		_nPesGer+= (cAlias1)->EE9_PSLQTO
		_cdesc01:= ' '
		_cdesc02:= ' '
		//FR - 12/09/2022 - Descrição vir do SB1 e não do EE9 (embarque) - Ticket #20211011021618
		//_cdesc01:= u_xTiraGraf(     Substr(Alltrim(  U_xSTGETSYP((cAlias1)->EE9_DESC) ),1,63))  //comentado por //FR
		//_cdesc02:= u_xTiraGraf(     Substr(Alltrim(  U_xSTGETSYP((cAlias1)->EE9_DESC) ),64,120))  //comentado por //FR
		
		
		SB1->(OrdSetFocus(1))
		SB1->(Dbseek(xFilial("SB1") + (cAlias1)->EE9_COD_I ))
		_cdesc01 := u_xTiraGraf(Substr(Alltrim( U_xSTGETSYP(SB1->B1_DESC_I )),1,63))
		_cdesc02 := u_xTiraGraf(Substr(Alltrim( U_xSTGETSYP(SB1->B1_DESC_I )),1,63))
		//FR - 12/09/2022 - Flávia Rocha - Sigamat Consultoria
		
		oPrinter:Say  (_nIni,5            , Transf(AVTransUnid((cAlias1)->EE9_UNIDAD,CriaVar("EE9_UNPRC"),(cAlias1)->EE9_COD_I,(cAlias1)->EE9_SLDINI,.f.),cPictQtde)  ,oFont08,,,,1)
		oPrinter:Say  (_nIni,_nCol01+3    , Alltrim((cAlias1)->EE9_COD_I)   	,oFont08,,,,0)
		oPrinter:Say  (_nIni,_nCol02+3    , _cdesc01	,oFont08)
		//oPrinter:Say  (_nIni,_nCol03+5    , Transf((cAlias1)->EE9_PSLQTO,cPictPeso)  	,oFont08,,,,1)
		oPrinter:Say  (_nIni,_nCol04+5    , Transf(_nPrcven,cPict ) 	,oFont08,,,,1)
		oPrinter:Say  (_nIni,_nCol05+5    , Transf(_nToTal,cPict)  	,oFont08,,,,1)

		STCOL()
		If !(Empty(Alltrim(_cdesc02)))
			_nIni+= _ntamLin
			//oPrinter:Say  (_nIni,_nCol02+3    , _cdesc02	,oFont08)
			STCOL()
			_nC01+= 1
			_nC02+= 1
		EndIf
		If (_nIni+ _ntamLin) > 789
			xPag()
			_nC02:=0
		EndIf

		(cAlias1)->(DbSkip())

	EndDo

	If _nC02 >= 19 .And. (_nC00-_nC01) < 46 // If _nC02 >= 23 .And. (_nC00-_nC01) < 46 Chamado 006991 - Everson Santana - Correção na quebra de pagina
		xPag()
		_nC02:=0
	EndIf

	STCOLROD()

	xRoda()

	oPrinter:Say  (835,_nCol05+25 , cValTochar(_nPag+1)+"º"  	,oFont08)
	oPrinter:EndPage()

	FERASE(_cDirRel+_cNomePdf+".pdf")
	oPrinter:cPathPDF := cStartPath

	oPrinter:Print()
	oPrinter:EndPage()

	//CpyS2T(cStartPath+_cNomePdf+'.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
	ShellExecute("open",_cDirRel+"\"+_cNomePdf+'.pdf', "", "", 1)

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif
Return


Static Function xPag()
	//If _nIni >= 789
	_nPag+=1
	_nIni+= _ntamLin
	oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)
	oPrinter:Say  (835,_nCol05+25 , cValTochar(_nPag)+"º"  	,oFont08)
	oPrinter:EndPage()
	oPrinter:StartPage()     // INICIALIZA a página
	xCab(' ')
	_nIni += (_ntamLin*1)
	//EndIf
Return()

Static Function xCab(_cCab)
	Local lMv_Logod := If( GetNewPar("MV_LOGOD", "N" ) == "S", .T., .F. )
	Local cLogoD	:= ""
	Local cDescLogo		:= ""
	Local cGrpCompany	:= ""
	Local cCodEmpGrp	:= ""
	Local cUnitGrp		:= ""
	Local cFilGrp		:= ""

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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Logotipo                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMv_Logod
		cGrpCompany	:= AllTrim(FWGrpCompany())
		cCodEmpGrp	:= AllTrim(FWCodEmp())
		cUnitGrp	:= AllTrim(FWUnitBusiness())
		cFilGrp		:= AllTrim(FWFilial())

		If !Empty(cUnitGrp)
			cDescLogo	:= cGrpCompany + cCodEmpGrp + cUnitGrp + cFilGrp
		Else
			cDescLogo	:= cEmpAnt + cFilAnt
		EndIf

		cLogoD := GetSrvProfString("Startpath","") + "STECK" + cDescLogo + ".BMP"
		If !File(cLogoD)
			cLogoD	:= GetSrvProfString("Startpath","") + "STECK" + cEmpAnt + ".BMP"
			If !File(cLogoD)
				lMv_Logod := .F.
			EndIf
		EndIf
	EndIf

	If lMv_Logod
		oPrinter:SayBitmap(060,020,cLogoD,097,019) //Steck Novo
	Else
		oPrinter:SayBitmap(060,020,cLogoD,097,019) //Steck Novo
	EndIf

	/*
	If File(aBmp)
		oPrinter:SayBitmap(060,020,aBmp,095,050 )
	EndIf
	*/

	oPrinter:Say  (055,150, _cNomeCom  ,oFont12n)
	oPrinter:Say  (070,150, _cEndereco + " CEP: "+ SUBSTR(cCep,1,5)+"-"+SUBSTR(cCep,6,3) +" - BRASIL - "+cEstado,oFont12)
	oPrinter:Say  (085,150, "CNPJ: "+cCNPJ ,oFont12)
	oPrinter:Say  (100,150, "TELEFONE: 55 11 2248-7081"  ,oFont12)
	oPrinter:Say  (120,150, Iif(_cOrigem= 'Sample',' ','COMMERCIAL')+' INVOICE - '+ Iif(_cOrigem= 'Sample',_cOrigem+'  ',' ')+ Alltrim(EEC->EEC_PREEMB)+'  '+Iif(_cOrigem= 'Sample',' ',_cOrigem)  ,oFont16b)
	//oPrinter:Say  (135,150, Alltrim(EEC->EEC_PREEMB)  ,oFont12)
	oPrinter:Box(140,005,830,_nlarg)

	_nFator := 100
	_nIni   := 150
	_ntamLin := 10




	oPrinter:Say  (_nIni,10              , "TO: "  ,oFont08)
	oPrinter:Say  (_nIni,30             ,   EEC->EEC_IMPODE  ,oFont08)
	oPrinter:Say  (_nIni+_ntamLin,30    , EEC->EEC_ENDIMP,oFont08)
	oPrinter:Say  (_nIni+(_ntamLin*2),30, EEC->EEC_END2IM   ,oFont08)

	oPrinter:Say  (_nIni,10+(_nlarg/2)              , "CONSIGNEE: "  ,oFont08)
	oPrinter:Say  (_nIni,60+(_nlarg/2)             ,  SUBSTR( Posicione("SA1",1,xFilial("SA1")+EEC->EEC_CONSIG+EEC->EEC_COLOJA,"A1_NOME"),1,54) ,oFont08)
	oPrinter:Say  (_nIni+_ntamLin,60+(_nlarg/2)    ,  SUBSTR( EECMEND("SA1",1,EEC->EEC_CONSIG+EEC->EEC_COLOJA,.T.,58,1),1,54),oFont08)
	oPrinter:Say  (_nIni+(_ntamLin*2),60+(_nlarg/2), SUBSTR(  EECMEND("SA1",1,EEC->EEC_CONSIG+EEC->EEC_COLOJA,.T.,60,2),1,54)   ,oFont08)



	oPrinter:Line(_nIni-_ntamLin   , (_nlarg/2)-0.5 , _nIni+(_ntamLin*4) 	,(_nlarg/2)-0.5)
	oPrinter:Line(_nIni-_ntamLin   , (_nlarg/2)+0.5 , _nIni+(_ntamLin*4) 	,(_nlarg/2)+0.5)
	_nIni += (_ntamLin*4)

	oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+1 , 5 , _nIni +1,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+2 , 5 , _nIni +2,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+3 , 5 , _nIni +3,_nlarg)   	// horizontal

	_nIni+=3



	If _cCab = '1'
		_nIni+= _ntamLin

		oPrinter:Say  (_nIni,10              	, "Notify: "  	,oFont08)
		IF EEN->(dbSeek(xFilial()+AvKey(EEC->EEC_PREEMB,"EEN_PROCES")))
			oPrinter:Say  (_nIni,30             	, EEN->EEN_IMPODE  	,oFont08)
			oPrinter:Say  (_nIni+_ntamLin,30    	, EEN->EEN_ENDIMP	,oFont08)
			oPrinter:Say  (_nIni+(_ntamLin*2),30	, EEN->EEN_END2IM  	,oFont08)
			If SA1->(dbSeek(xFilial("SA1")+EEN->EEN_IMPORT+EEN->EEN_IMLOJA))
				oPrinter:Say  (_nIni+(_ntamLin*3),30	, substr(SA1->A1_EMAIL,1,46)  	,oFont08)
				oPrinter:Say  (_nIni+(_ntamLin*4),30	, SA1->A1_TEL  	,oFont08)

				oPrinter:Say  (_nIni,10   +(_nlarg/2)           	, "Documents: "  	,oFont08)
				oPrinter:Say  (_nIni,60    +(_nlarg/2)         	,  SUBSTR( EEC->EEC_IMPODE ,1,54) 	,oFont08)
				oPrinter:Say  (_nIni+_ntamLin,60   +(_nlarg/2) 	,  SUBSTR( EEC->EEC_ENDIMP,1,54)	,oFont08)
				oPrinter:Say  (_nIni+(_ntamLin*2),60	+(_nlarg/2), SUBSTR(  EEC->EEC_END2IM,1,54) 	,oFont08)
				oPrinter:Say  (_nIni+(_ntamLin*3),60+(_nlarg/2)	,  SUBSTR( SA1->A1_XRUCNIT,1,54)  	,oFont08)
				//oPrinter:Say  (_nIni+(_ntamLin*4),60+(_nlarg/2)	, SA1->A1_TEL  	,oFont08)

			EndIf
		EndIf


		oPrinter:Line(_nIni-_ntamLin   , (_nlarg/2)-0.5 , _nIni+(_ntamLin*5) 	,(_nlarg/2)-0.5)
		oPrinter:Line(_nIni-_ntamLin   , (_nlarg/2)+0.5 , _nIni+(_ntamLin*5) 	,(_nlarg/2)+0.5)
		_nIni += (_ntamLin*5)

		oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)   	// horizontal
		oPrinter:Line(_nIni+1 , 5 , _nIni +1,_nlarg)   	// horizontal
		oPrinter:Line(_nIni+2 , 5 , _nIni +2,_nlarg)   	// horizontal
		oPrinter:Line(_nIni+3 , 5 , _nIni +3,_nlarg)   	// horizontal

		_nIni+=3


	EndIf

	_nIni+= _ntamLin

	oPrinter:Say  (_nIni,70              				, "P R O D U C T: "  	,oFont08)
	oPrinter:Say  (_nIni,_nCol04+10           	, "V A L U E S    I N: "+EEC->EEC_MOEDA  	,oFont08)

	oPrinter:Line(_nIni-_ntamLin   , _nCol04-0.5 , _nIni+(_ntamLin*1) 	,_nCol04-0.5)
	oPrinter:Line(_nIni-_ntamLin   , _nCol04+0.5 , _nIni+(_ntamLin*1) 	,_nCol04+0.5)
	_nIni += (_ntamLin*1)

	oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+1 , 5 , _nIni +1,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+2 , 5 , _nIni +2,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+3 , 5 , _nIni +3,_nlarg)   	// horizontal

	_nIni+=3



	_nIni+= _ntamLin

	oPrinter:Say  (_nIni,7              						, "QTY/UN"  	,oFont08)
	oPrinter:Say  (_nIni,_nCol01+5       						, "CODE"  	,oFont08)
	oPrinter:Say  (_nIni,_nCol02+15              				, "D E S C R I P T I O N "  	,oFont08)
	oPrinter:Say  (_nIni,_nCol03+3       						, ""  	,oFont08)
	oPrinter:Say  (_nIni,_nCol04+3       						, "UNIT PRICE"  	,oFont08)
	oPrinter:Say  (_nIni,_nCol05+15      						, "TOTAL"  	,oFont08)


	STCOL()

	_nIni += (_ntamLin*1)

	oPrinter:Say  (_nIni,_nCol03+15       				, ""  	,oFont08)
	oPrinter:Say  (_nIni,_nCol04+15              				, EEC->EEC_MOEDA  	,oFont08)
	STCOL()

	_nIni += (_ntamLin*1)


	oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+1 , 5 , _nIni +1,_nlarg)   	// horizontal

	_nIni+=3



Return


Static Function STCOL()



	oPrinter:Line(_nIni-_ntamLin   , _nCol01  , _nIni+(_ntamLin*1) 	,_nCol01 )
	oPrinter:Line(_nIni-_ntamLin   , _nCol02  , _nIni+(_ntamLin*1) 	,_nCol02 )
	//oPrinter:Line(_nIni-_ntamLin   , _nCol03  , _nIni+(_ntamLin*1) 	,_nCol03 )
	oPrinter:Line(_nIni-_ntamLin   , _nCol04  , _nIni+(_ntamLin*1) 	,_nCol04  )
	oPrinter:Line(_nIni-_ntamLin   , _nCol05  , _nIni+(_ntamLin*1) 	,_nCol05  )

Return


Static Function STCOLROD()



	oPrinter:Line(_nIni-_ntamLin   , _nCol01  , 580 	,_nCol01 )
	oPrinter:Line(_nIni-_ntamLin   , _nCol02  , 580 	,_nCol02 )
	//oPrinter:Line(_nIni-_ntamLin   , _nCol03  , 580 	,_nCol03 )
	oPrinter:Line(_nIni-_ntamLin   , _nCol04  , 580 	,_nCol04  )
	oPrinter:Line(_nIni-_ntamLin   , _nCol05  , 580 	,_nCol05  )

Return

Static Function xRoda()

	Local nINC:=1

	_nIni:= 580

	oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+1 , 5 , _nIni +1,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+2 , 5 , _nIni +2,_nlarg)   	// horizontal
	oPrinter:Line(_nIni+3 , 5 , _nIni +3,_nlarg)   	// horizontal

	_nIni+=3

	_nIni+= _ntamLin

	oPrinter:Say  (_nIni,80             		, "P A C K I N G"  	,oFont08,,,,0)
	oPrinter:Say  (_nIni,_nCol06+50           	, "M A R K S"  		,oFont08,,,,0)
	//totais
	oPrinter:Say  (_nIni+(_ntamLin*0),_nCol07+5           	, "Goods Value Due:"  	,oFont08)
	oPrinter:Say  (_nIni+(_ntamLin*0),_nCol05+5     , Transf(_nToGer,cPict)  	,oFont08,,,,1)
	oPrinter:Line (_nIni+(_ntamLin*1)   , _nCol07 , _nIni+(_ntamLin*1) 	,_nlarg)   	// horizontal

	oPrinter:Say  (_nIni+(_ntamLin*2),_nCol07+5           	, "Discount:"  	,oFont08)
	//EE7_XDESC
	_nDescEE7:= 0
	//If ddatabase > stod('20160329') //retirar pois o campo nao esta criado.

	dbSelectArea('EE7')
	EE7->(dbSetOrder(1))
	If EE7->(dbSeek(xFilial()+EEC->EEC_PEDREF))
		_nDescEE7:= EE7->EE7_XDESC
	EndIf
	//EndIf
	oPrinter:Say  (_nIni+(_ntamLin*2),_nCol05+5     , Transf(_nDescEE7,cPict)  	,oFont08,,,,1)
	oPrinter:Line (_nIni+(_ntamLin*3)   , _nCol07 , _nIni+(_ntamLin*3) 	,_nlarg)   	// horizontal


	oPrinter:Say  (_nIni+(_ntamLin*4),_nCol07+5           	, "Sub-Total:"  	,oFont08)
	oPrinter:Say  (_nIni+(_ntamLin*4),_nCol05+5     , Transf(_nToGer-_nDescEE7,cPict)  	,oFont08,,,,1)
	oPrinter:Line (_nIni+(_ntamLin*5)   , _nCol07 , _nIni+(_ntamLin*5) 	,_nlarg)   	// horizontal

	oPrinter:Say  (_nIni+(_ntamLin*6),_nCol07+5           	, "Freight:"  	,oFont08)
	oPrinter:Say  (_nIni+(_ntamLin*6),_nCol05+5     , Transf(EEC->EEC_FRPREV,cPict)  	,oFont08,,,,1)
	oPrinter:Line (_nIni+(_ntamLin*7)   , _nCol07 , _nIni+(_ntamLin*7) 	,_nlarg)   	// horizontal

	oPrinter:Say  (_nIni+(_ntamLin*8),_nCol07+5           	, "Insurance:"  	,oFont08)
	oPrinter:Say  (_nIni+(_ntamLin*8),_nCol05+5     , Transf(EEC->EEC_SEGPRE,cPict)  	,oFont08,,,,1)
	oPrinter:Line (_nIni+(_ntamLin*9)   , _nCol07 , _nIni+(_ntamLin*9) 	,_nlarg)   	// horizontal

	SYR->(dbSeek(xFilial()+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA))

	//*** BHF - 12/08/08 - Não descreve a origem no total.
	IF Posicione("SYJ",1,xFilial("SYJ")+EEC->EEC_INCOTE,"YJ_CLFRETE") $ cSim
		_cIncote := " "+AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR")) // Porto de Destino
	Else
		_cIncote  := " "+AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR")) // Porto de Origem
	Endif




	oPrinter:Say  (_nIni+(_ntamLin*10),_nCol07+5           	, 'TOTAL '+ Alltrim(EEC->EEC_INCOTE)+_cIncote   	,oFont08)
	oPrinter:Say  (_nIni+(_ntamLin*10),_nCol05+5     , Transf(_nToGer-_nDescEE7+EEC->EEC_FRPREV+EEC->EEC_SEGPRE,cPict)  	,oFont08,,,,1)
	oPrinter:Line (_nIni+(_ntamLin*11)   , _nCol07 , _nIni+(_ntamLin*11) 	,_nlarg)   	// horizontal


	STCOL01('1')

	_nIni+= _ntamLin

	oPrinter:Line(_nIni   , 5 , _nIni 	,_nlarg)   	// horizontal

	_nIni+= _ntamLin

	// Packing
	//quebrar linha para 1 virgula
	IF ( len(alltrim(EEC->EEC_PACKAG))>0 )
		cPACKAG  :=ALLTRIM(EEC->EEC_PACKAG)
		acRETPAC:={}
		FOR nINC:=1 TO LEN(cPACKAG)
			nCONT:=AT(",",cPACKAG)	  //PREPARADO PARA VARIAS VIRGULAS
			nCONT:=IF(nCONT==0,LEN(cPACKAG),nCONT)
			AADD(acRETPAC,SUBSTR(cPACKAG,1,nCONT)) //DFS - 14/12/2010 - Retirado o -1 que estava cortando sempre a ultima letra do campo.
			IF ( LEN(cPACKAG)<nCONT+1 )
				EXIT
			ENDIF
			cPACKAG  :=ALLTRIM(SUBSTR(cPACKAG,nCONT+1))
		NEXT nINC

		oPrinter:Say  (_nIni,30             		,  IF(LEN(acRETPAC)>=1,acRETPAC[1],"")  ,oFont08,,,,0)

		oPrinter:Say  (_nIni+_ntamLin,30             		,  IF(LEN(acRETPAC)>=2,acRETPAC[2],"") 	,oFont08,,,,0)
	ENDIF

	STCOL01('2')



	oPrinter:Line(_nIni+(_ntamLin*2)   , 5 , _nIni+(_ntamLin*2) 	,_nCol06)   	// horizontal

	cPictCub := AllTrim(StrTran(Upper(AVSX3("EEC_CUBAGE",6)),"@E",""))


	_nNet	:=0
	_nGross	:=0
	_nCub	:=0

	If !(Empty(Alltrim(_cOrigem))) .And. _cOrigem <> 'Sample'

		_nNet	:= EEC->EEC_PESLIQ
		_nGross	:= EEC->EEC_PESBRU
		_nCub	:= EEC->EEC_CUBAGE

	Else


		cPallt()
		_nNet	:= nPesLiq
		_nGross	:= nPesBru+nPallet
		_nCub	:=  ' '
		nCubageTot := Posicione("EX9",1,xFilial("EX9")+EEC->EEC_PREEMB,"EX9->EX9_XCUB")
		//cTotVolum := DecPoint(LTrim(Transf(nCubageTot,cPictPeso)),2)
		//cTotVolum += If(!Empty(cTotVolum)," m3","")

		_nCub	:= nCubageTot
	EndIf

	oPrinter:Say  (_nIni+(_ntamLin*3),05             		, "Net  Weigth  (KG):"  	,oFont08,,,,0)
	oPrinter:Say  (_nIni+(_ntamLin*3),150             		, Transf(_nNet,cPictPeso)  	,oFont08,,,,1)
	oPrinter:Say  (_nIni+(_ntamLin*4),05             		, "Gross Weigth (KG):"  	,oFont08,,,,0)
	oPrinter:Say  (_nIni+(_ntamLin*4),150             		, Transf(_nGross,cPictPeso)  ,oFont08,,,,1)
	oPrinter:Say  (_nIni+(_ntamLin*5),05             		, "Measurement  (M³):"  	,oFont08,,,,0)
	oPrinter:Say  (_nIni+(_ntamLin*5),150             		, Transf(_nCub,cPictCub)   	,oFont08,,,,1)


	oPrinter:Line(_nIni+(_ntamLin*6)   , 5 , _nIni+(_ntamLin*6) 	,_nCol06)   	// horizontal
	SYQ->(dbSetOrder(1))
	SYQ->(dbSeek(xFilial()+EEC->EEC_VIA))


	oPrinter:Say  (_nIni+(_ntamLin*7),05             		, "Way:  "+ Alltrim(IF(Left(SYQ->YQ_COD_DI,1) == "4",IF(lIngles,"BY AIR","AEREA"),SYQ->YQ_DESCR))  	,oFont08,,,,0)

	oPrinter:Line(_nIni+(_ntamLin*8)   , 5 , _nIni+(_ntamLin*8) 	,_nCol06)   	// horizontal



	SYR->(dbSeek(xFilial()+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA))
	If !(Empty(Alltrim(_cOrigem)))  .And. _cOrigem <> 'Sample'
		oPrinter:Say  (_nIni+(_ntamLin*9),05             		, "Country of Origin:  "+ AllTrim(BuscaPais(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_PAIS")))  	,oFont08,,,,0)

	Else
		oPrinter:Say  (_nIni+(_ntamLin*9),05             		, "Country of Origin:  "+ Alltrim(Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM"))  	,oFont08,,,,0)
	EndIf
	oPrinter:Line(_nIni+(_ntamLin*10)   , 5 , _nIni+(_ntamLin*10) 	,_nCol07)   	// horizontal

	oPrinter:Say  (_nIni+(_ntamLin*11),25             		, "Port of Loading:  "  	,oFont08,,,,0)

	oPrinter:Say  (_nIni+(_ntamLin*11),25+_nCol06           , "Port of Unloading:  "  	,oFont08,,,,0)






	// Port of Loading
	_cPort:= ' '
	If EEC->(FieldPos("EEC_PTINT")) > 0 .And. !Empty(EEC->EEC_PTINT)
		_cPort := alltrim(Posicione("SY9",2,xFilial("SY9")+EEC->EEC_PTINT,"Y9_DESCR")) //+" "+AllTrim(BuscaPais(Posicione("SY9",2,xFilial("SY9")+EEC->EEC_PTINT,"Y9_PAIS")))
	Else
		_cPort := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR")) //+" "+AllTrim(BuscaPais(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_PAIS")))
	EndIf



	oPrinter:Say  (_nIni+(_ntamLin*12),25             		, _cPort  	,oFont08,,,,0)

	oPrinter:Say  (_nIni+(_ntamLin*12),25+_nCol06           , alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR"))  	,oFont08,,,,0)

	oPrinter:Line(_nIni+(_ntamLin*13)   , 5 , _nIni+(_ntamLin*13) 	,_nlarg)   	// horizontal



	// Cond.Pagto ...
	oPrinter:Say  (_nIni+(_ntamLin*14),05          , "Payment Terms: "+ SY6Descricao(EEC->EEC_CONDPA+Str(EEC->EEC_DIASPA,AVSX3("EEC_DIASPA",3),AVSX3("EEC_DIASPA",4)),EEC->EEC_IDIOMA,1) 	,oFont08,,,,0)

	oPrinter:Line(_nIni+(_ntamLin*15)   , 5 , _nIni+(_ntamLin*15) 	,_nlarg)   	// horizontal


	// Obs
	oPrinter:Say  (_nIni+(_ntamLin*16),05  , "Obs: "  	,oFont08,,,,0)
	Public Inclui := .f.
	cMemo := ' '
	cMemo :=  E_MSMM(EEC->EEC_CODMEM,60)
	oPrinter:Say  (_nIni+(_ntamLin*18),05  ,   Alltrim(cMemo) 	,oFont08,,,,0)



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

	oPrinter:Say  (_nIni+(_ntamLin*16),05+_nCol07  , cEXP_NOME  	,oFont08,,,,0)
	oPrinter:Say  (_nIni+(_ntamLin*17),05+_nCol07   ,   	 AllTrim(SA2->A2_MUN)+", "+Upper(IF(lIngles,cMonth(EEC->EEC_DTINVO),IF(EMPTY(EEC->EEC_DTINVO),"",aMeses[Month(EEC->EEC_DTINVO)])))+" "+StrZero(Day(EEC->EEC_DTINVO),2)+", "+Str(Year(EEC->EEC_DTINVO),4)+"." 	,oFont08,,,,0)

	oPrinter:Say  (_nIni+(_ntamLin*20),05+_nCol07   , cEXP_CONTATO  	,oFont08,,,,0)
	oPrinter:Say  (_nIni+(_ntamLin*21),05+_nCol07   , cEXP_CARGO  	,oFont08,,,,0)


	oPrinter:Line(_nIni+(_ntamLin*15)    , _nCol07  , 830  	,_nCol07 )





	//marks
	cMemo := ' '
	cMemo := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO))

	oPrinter:Say  (_nIni+(_ntamLin*1),_nCol06+5             		,  MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),1) 	,oFont08,,,,0)
	oPrinter:Say  (_nIni+(_ntamLin*2),_nCol06+5              		,  MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),2) 	,oFont08,,,,0)
	oPrinter:Say  (_nIni+(_ntamLin*3),_nCol06+5              		,  MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),3) 	,oFont08,,,,0)
	oPrinter:Say  (_nIni+(_ntamLin*4),_nCol06+5              		,  MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),4) 	,oFont08,,,,0)
	oPrinter:Say  (_nIni+(_ntamLin*5),_nCol06+5              		,  MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),5) 	,oFont08,,,,0)
	oPrinter:Say  (_nIni+(_ntamLin*6),_nCol06+5              		,  MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),6) 	,oFont08,,,,0)




	//totais



Return()

Static Function STCOL01(_cRt)

	oPrinter:Line(_nIni-_ntamLin   , _nCol06  , _nIni+(_ntamLin*13) 	,_nCol06 )
	oPrinter:Line(_nIni-_ntamLin   , _nCol07  , _nIni+(_ntamLin*13) 	,_nCol07 )
	oPrinter:Line(_nIni-_ntamLin   , _nCol08  , _nIni+(_ntamLin*13) 	,_nCol08 )


Return()



Static Function cPallt()

	Local nxTotVal := 0


	cPallet := ' '
	cPallet := Posicione("EX9",1,xFilial("EX9")+EEC->EEC_PREEMB,"EX9_XPALLE")
	If cPallet == "S"
		nPallet := 0
		// Valdemir Rabelo 14/04/2021 - Ticket: 20210412005829
		IF EX9->( FieldPos("EX9_XPSPAL") ) > 0           //   Movido para dentro da condição cPallet == "S" - Ticket: 20210716012888 - Valdemir Rabelo 19/07/2021
			nPsPall := Posicione("EX9",1,xFilial("EX9")+EEC->EEC_PREEMB,"EX9_XPSPAL")
		ELSE
			MsgInfo("Campo (EX9_XPSPAL) peso do pallet não foi criado. Por favor, comunique o depto. TI","Atenção!")
			Return
		Endif
	Endif

	ZZA->(DbSetOrder(2)) // ZZA_FILIAL+ZZA_PREEMB+ZZA_CONTNR+ZZA_PALLET+ZZA_VOLUME

	cOldArea := GetArea()
	ZZA->(DbSeek(xFilial("ZZA")+EEC->EEC_PREEMB))
	cPallet := ''

	Do While ZZA->(!Eof() .And. ZZA_FILIAL == xFilial("ZZA")) .And. ZZA->ZZA_PREEMB == EEC->EEC_PREEMB

		// Peso Liquido do Volume
		*** Peso liq alterado em 22/11/2013 ****
		nPesoLiqProd 			:= Posicione("SB1",1,xFilial("SB1")+ZZA->ZZA_PROD,"B1_PESO")
		nPesLiq   			:= nPesLiq + (ZZA->ZZA_QTEEMB * nPesoLiqProd)

		// Peso Bruto do Volume
		//Giovani Zago 01/05/14*********************************************************************
		If !(ALLTRIM(ZZA->ZZA_ORDSEP)+ALLTRIM(ZZA->ZZA_VOLUME) $ cVol)
			nPesBrutoCx := Posicione("CB6",1,xFilial("CB6")+ALLTRIM(ZZA->ZZA_ORDSEP)+ALLTRIM(ZZA->ZZA_VOLUME),"CB6_XPESO")
			nPesBru 	  := nPesBru + nPesBrutoCx
			cvol := cVol + ALLTRIM(ZZA->ZZA_ORDSEP)+ALLTRIM(ZZA->ZZA_VOLUME) + "|"
		Endif

		If !(ZZA->ZZA_PALLET $ cPallet)
			If  nPallet <   val(ZZA->ZZA_PALLET)
				nPallet:= val(ZZA->ZZA_PALLET)
				cPallet := cPallet+ZZA->ZZA_PALLET +'/'
			Endif
		Endif
		//***********************************************************************************************************
		nPesBrParc := nPesBrParc + ZZA->ZZA_PESVOL

		ZZA->(DbSkip())

	EndDo
	//nPallet:= nPallet*10
	nPallet:= nPallet*nPsPall             // Adicionado ticket: 20210412005829 - Valdemir

Return()

User function xTiraGraf (_sOrig)
	local _sRet := _sOrig
	_sRet = strtran (_sRet, "á", "a")
	_sRet = strtran (_sRet, "é", "e")
	_sRet = strtran (_sRet, "í", "i")
	_sRet = strtran (_sRet, "ó", "o")
	_sRet = strtran (_sRet, "ú", "u")
	_SRET = STRTRAN (_SRET, "Á", "A")
	_SRET = STRTRAN (_SRET, "É", "E")
	_SRET = STRTRAN (_SRET, "Í", "I")
	_SRET = STRTRAN (_SRET, "Ó", "O")
	_SRET = STRTRAN (_SRET, "Ú", "U")
	_sRet = strtran (_sRet, "ã", "a")
	_sRet = strtran (_sRet, "õ", "o")
	_SRET = STRTRAN (_SRET, "Ã", "A")
	_SRET = STRTRAN (_SRET, "Õ", "O")
	_sRet = strtran (_sRet, "â", "a")
	_sRet = strtran (_sRet, "ê", "e")
	_sRet = strtran (_sRet, "î", "i")
	_sRet = strtran (_sRet, "ô", "o")
	_sRet = strtran (_sRet, "û", "u")
	_SRET = STRTRAN (_SRET, "Â", "A")
	_SRET = STRTRAN (_SRET, "Ê", "E")
	_SRET = STRTRAN (_SRET, "Î", "I")
	_SRET = STRTRAN (_SRET, "Ô", "O")
	_SRET = STRTRAN (_SRET, "Û", "U")
	_sRet = strtran (_sRet, "ç", "c")
	_sRet = strtran (_sRet, "Ç", "C")
	_sRet = strtran (_sRet, "à", "a")
	_sRet = strtran (_sRet, "À", "A")
	_sRet = strtran (_sRet, "º", ".")
	_sRet = strtran (_sRet, "ª", ".")
	_sRet = strtran (_sRet, "\13\10", " ")
	_sRet = strtran (_sRet, chr (9), " ") // TAB
return _sRet


User Function xSTGETSYP(_cCodSyp)

	Local _cMsg	:= ""

	Local cQuery1 	:= ""
	Local _cAlias1 	:= "QRYTEMP"

	cQuery1  := " SELECT YP_TEXTO "
	cQuery1  += " FROM  "+RetSqlName("SYP")+" YP "
	cQuery1  += " WHERE YP.D_E_L_E_T_=' ' AND YP_CHAVE='"+_cCodSyp+"' order by YP_SEQ "

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())
	While (_cAlias1)->(!Eof())
		_cMsg	+= (_cAlias1)->YP_TEXTO

		(_cAlias1)->(DbSkip())

	End
Return(_cMsg)



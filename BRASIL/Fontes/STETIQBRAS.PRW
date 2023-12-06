#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    STETIQBRAS บ Autor ณ Giovani.Zago       บ Data ณ  24/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ rGera etiqueta braspress                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*----------------------------------------*
User Function STETIQBRAS(_cNote,_cSeriousPD2)
	*----------------------------------------*
	Private _xCodTran       := GetMv("ST_TRANBRA",,'000012')
	Private cPerg       	:= "BRASPRESS"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private	nRotaEnt   		:= ""
	Private	nSgFilOrig 		:= ""
	Private	nClassif   		:= ""
	Private	nSequen    		:= ""
	
	dbSelectArea("SF2")
	//SF2->(DbOrderNickName('ROMANEIO  '))
	SF2->(DbSetOrder(1))
	If SF2->(DbSeek( xFilial("SF2") + _cNote + _cSeriousPD2))
		If SF2->F2_TRANSP == _xCodTran
			StQuery( _cNote , _cSeriousPD2)
			dbSelectArea(cAliasLif)
			(cAliasLif)->(dbgotop())
			If  Select(cAliasLif) > 0
				
				While 	(cAliasLif)->(!Eof())
					If !Empty(alltrim((cAliasLif)->C5_ZCEPE))
						
						rotacep((cAliasLif)->C5_ZCEPE)
					Else
						rotacep((cAliasLif)->A1_CEP)
					EndIf
					If 	(cAliasLif)->F2_VOLUME1 > 0   .And. ( !(Empty(alltrim((cAliasLif)->C5_ZCEPE)) ) .or.  !(Empty(alltrim((cAliasLif)->A1_CEP)) ))
						ImpBras()
					EndIf
					(cAliasLif)->(dbskip())
				End
			EndIf
		EndIf
	EndIf
	
Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    StQuery    บ Autor ณ Giovani.Zago       บ Data ณ  24/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Query seleciona notas de acordo com o numero do romaneio   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*----------------------------------------*
Static Function StQuery( _cNote , _cSeriousPD2)
	*----------------------------------------*
	Local cQuery     := ' '
	
	cQuery := 'SELECT A1_NOME,A1_MUN    ,A1_EST    ,A1_CEP, A1_NREDUZ, F2_VOLUME1,  F2_DOC, F2_SERIE, D2_PEDIDO,  D2_ITEM, F2_TRANSP,  C5_ZENDENT , C5_ZBAIRRE  , C5_ZMUNE , C5_ZESTE , C5_ZCEPE , F2_TPFRETE
	cQuery += " FROM " + RetSQLName("SA1")+', '+ RetSQLName("SF2")+', '+ RetSQLName("SD2")+', '+ RetSQLName("SC5")
	cQuery += " WHERE F2_DOC = '" + _cNote + "'"
	cQuery += " AND F2_SERIE = '" + _cSeriousPD2 + "'"
	cQuery += " AND F2_CLIENTE = A1_COD"
	cQuery += " AND F2_LOJA = A1_LOJA"
	cQuery += " AND F2_DOC = D2_DOC"
	cQuery += " AND F2_SERIE = D2_SERIE"
	cQuery += " AND F2_FILIAL = '" + xFilial('SF2') + "'"
	cQuery += " AND D2_FILIAL = '" + xFilial('SD2') + "'"
	cQuery += " AND C5_FILIAL = '" + xFilial('SC5') + "'"
	cQuery += " AND F2_TRANSP  = '"+_xCodTran+"'"
	cQuery += " AND C5_NUM = D2_PEDIDO"
	cQuery += " AND D2_ITEM = '01'"
	cQuery += " AND " + RetSQLName("SA1")+".D_E_L_E_T_ <> '*'"
	cQuery += " AND " + RetSQLName("SF2")+".D_E_L_E_T_ <> '*'"
	cQuery += " AND " + RetSQLName("SD2")+".D_E_L_E_T_ <> '*'"
	cQuery += " AND " + RetSQLName("SC5")+".D_E_L_E_T_ <> '*'"
	cQuery += "ORDER BY F2_DOC, F2_SERIE"
	
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
Return()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    rotacep    บ Autor ณ Giovani.Zago       บ Data ณ  24/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Query seleciona rota de acordo com a tabela da braspress   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*---------------------------------*
Static Function rotacep(nCepCli)
	*---------------------------------*
	Local QRY2 := ""
	Local cFilImola := ""
	
	nRotaEnt   := ""
	nSgFilOrig := ""
	nClassif   := ""
	nSequen    := ""
	
	
	QRY2 := "SELECT ZZC_NUMROT, ZZC_SGFILI, ZZC_CLASSI, ZZC_SEQUEN"
	QRY2 += " FROM " + RetSQLName("ZZC")
	QRY2 += " WHERE ZZC_CEPINI <= '" + nCepCli + "'"
	QRY2 += " AND ZZC_CEPFIM >= '" + nCepCli + "'"
	QRY2 += " AND ZZC_TRANSP = '" + _xCodTran + "'"
	QRY2 += " AND " + RetSQLName("ZZC") + ".D_E_L_E_T_ <> '*'"
	QRY2 += "ORDER BY ZZC_ROTA"
	
	#xcommand TCQUERY <sql_expr>                          ;
		[ALIAS <a>]                                           ;
		[<new: NEW>]                                          ;
		[SERVER <(server)>]                                   ;
		[ENVIRONMENT <(environment)>]                         ;
		=> dbUseArea(                                         ;
		<.new.>,                                              ;
		"TOPCONN",                                            ;
		TCGENQRY(<(server)>,<(environment)>,<sql_expr>),      ;
		<(a)>, .F., .T.)
	
	// Processa Query SQL
	DbCommitAll()
	TcQuery QRY2 NEW ALIAS "QRY2"         // Abre uma workarea com o resultado da query
	memowrite('ZZC.SQL',QRY2)
	
	DbSelectArea("QRY2")
	QRY2->(dbGotop())
	
	nRotaEnt   := QRY2->ZZC_NUMROT
	nSgFilOrig := QRY2->ZZC_SGFILI
	nClassif   := QRY2->ZZC_CLASSI
	nSequen    := QRY2->ZZC_SEQUEN
	
	DbSelectArea("QRY2")
	QRY2->(DbCloseArea())
	
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ImpBras    บ Autor ณ Giovani.Zago       บ Data ณ  24/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ imprimi a etiqueta  da braspress                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*-------------------------*
Static Function ImpBras()
	*-------------------------*
	Local cCmd
	Local cPortaImp := "LPT1"
	Local _cBarrasSt := ' '
	Local i := 0
	If   CB5SetImp('000011')
		For i:=1  To (cAliasLif)->F2_VOLUME1
			
			_cBarrasSt := '1'+'155' + PADR(Right((cAliasLif)->F2_SERIE,2),2) + PADR(ALLTRIM(RIGHT((cAliasLif)->F2_DOC,6)),6) + strzero(	i,4)
			
			
			MSCBInfoEti("BRAS","")
			MSCBBEGIN(1,6)
			MSCBBOX(03,02,103,98,5)
			
			MSCBBOX(03,02,52,15,52,"B")
			MSCBSAY(05,04,nSgFilOrig,"N","0","100,085",.T.)
			MSCBSAY(58,05,nRotaEnt,"N","0","100,085")
			MSCBSAY(85,11,nSequen,"N","0","040,026")
			MSCBLineH(03,15,103,5,"B")
			
			
			
			MSCBLineV(40,15,25,5)
			MSCBLineV(70,15,25,5)
			MSCBLineH(03,25,103,5,"B")
			
			MSCBBOX(03,16,10,19,20,"B")
			MSCBSAY(05,16.5,"NF:","N","0","020,013",.T.)
			MSCBSAY(05,19.5,   ALLTRIM(	(cAliasLif)->F2_DOC),"N","0","060,060")
			
			MSCBBOX(43,16,50,19,20,"B")
			MSCBSAY(45,16.5,"Ped:","N","0","020,013",.T.)
			MSCBSAY(50,20,   cvaltochar(	(cAliasLif)->D2_PEDIDO),"N","0","040,036")
			
			MSCBBOX(73,16,80,19,20,"B")
			MSCBSAY(75,16.5,"Vol:","N","0","020,013",.T.)
			MSCBSAY(80,20,   cvaltochar(i)+'/'+cvaltochar(	(cAliasLif)->F2_VOLUME1),"N","0","040,036")
			
			
			//remetente
			MSCBLineH(03,33,103,5,"B")
			MSCBLineV(70,15,33,5)
			MSCBBOX(03,26,10,29,20,"B")
			MSCBSAY(05,26.5,"Rem:","N","0","020,013",.T.)
			MSCBSAY(05,29.5,   ALLTRIM(SM0->M0_NOMECOM),"N","0","035,026")
			
			//origem
			MSCBBOX(70,25,103,41,65,"B")
			MSCBSAY(75,26,"Origem:","N","0","038,026",.T.)
			MSCBSAY(80,30,   "CCT","N","0","068,036",.T.)
			
			//destinatario
			MSCBLineH(03,41,103,5,"B")
			MSCBLineV(70,15,41,5)
			MSCBBOX(03,34,10,37,20,"B")
			MSCBSAY(05,34.5,"Des:","N","0","020,013",.T.)
			MSCBSAY(05,37.5,   ALLTRIM(	(cAliasLif)->A1_NOME),"N","0","035,026")
			
			//CIDADE E UF DESTINO
			MSCBLineH(03,47,103,5,"B")
			If !Empty(alltrim((cAliasLif)->C5_ZCEPE))
				MSCBSAY(05,42,   ALLTRIM(	(cAliasLif)->C5_ZMUNE)+' - '+;
					ALLTRIM(	(cAliasLif)->C5_ZESTE)+;
					' -  CEP: '+;
					SUBSTR(ALLTRIM((cAliasLif)->C5_ZCEPE ),1,LEN(ALLTRIM((cAliasLif)->C5_ZCEPE ))-3)+'-'+SUBSTR(ALLTRIM((cAliasLif)->C5_ZCEPE ),LEN(ALLTRIM((cAliasLif)->C5_ZCEPE ))-2,3 ),"N","0","050,026")
			Else
				MSCBSAY(05,42,   ALLTRIM(	(cAliasLif)->A1_MUN)+' - '+;
					ALLTRIM(	(cAliasLif)->A1_EST)+;
					' -  CEP: '+;
					SUBSTR(ALLTRIM((cAliasLif)->A1_CEP ),1,LEN(ALLTRIM((cAliasLif)->A1_CEP ))-3)+'-'+SUBSTR(ALLTRIM((cAliasLif)->A1_CEP ),LEN(ALLTRIM((cAliasLif)->A1_CEP ))-2,3 ),"N","0","050,026")
				
				
				
			Endif
			
			//COD BARRAS
			//	MSCBSAYBAR(05,48              ,_cBarrasSt,"MB07","C",10.36,.F.,.T.,.F.,   ,2  ,1)
			MSCBSAYBAR(15,52              ,_cBarrasSt   ,"N","MB07",26  ,.F.,.T.,.F.,"C",3.6,2,.F.)
			
			
			//obs.:
			MSCBLineH(03,85,103,5,"B")
			MSCBBOX(03,86,10,89,20,"B")
			MSCBSAY(05,86.5,"Obs:","N","0","020,013",.T.)
			MSCBEND()
			
			
		Next i
		MSCBCLOSEPRINTER()
	EndIf
	
Return





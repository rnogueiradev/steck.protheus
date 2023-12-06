#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "TOTVS.CH"
#INCLUDE "STR.CH"
#INCLUDE "FWMVCDEF.CH"

User Function STXMLROMAN(_C01,_C02)
	
	Local lRomOk := .F.
	Local nTotalRomaneios := 0
	Private aAgrFrt    := {}
	Private aDocCarg   := {}
	Private aTrchDoc   := {}
	Private aItDoc     := {}
	Private aRetCalc   := {}
	Private nRomCount  := 0
	Private nCountOk   := 0
	Private nCountErro := 0
	Private cAliasGWN  := GetNextAlias()
	Private cQueryUpd  := ' '
	
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
	
	 

	cQueryUpd := " UPDATE GW8010 SET GW8_PESOR =
	cQueryUpd += " ROUND(
	cQueryUpd += " NVL((SELECT F2_PBRUTO FROM SF2010 SF2 WHERE SF2.D_E_L_E_T_ = ' ' AND F2_DOC = GW8_NRDC AND F2_SERIE = GW8_SERDC AND F2_FILIAL = GW8_FILIAL),0)
	cQueryUpd += " /(
	cQueryUpd += " CASE WHEN
	cQueryUpd += " NVL((SELECT Count(*) FROM SD2010 SD2 WHERE SD2.D_E_L_E_T_ = ' '  AND D2_DOC = GW8_NRDC AND D2_SERIE = GW8_SERDC AND D2_FILIAL = GW8_FILIAL),1) = 0 THEN 1 ELSE
	cQueryUpd += " NVL((SELECT Count(*) FROM SD2010 SD2 WHERE SD2.D_E_L_E_T_ = ' '  AND D2_DOC = GW8_NRDC AND D2_SERIE = GW8_SERDC AND D2_FILIAL = GW8_FILIAL),1) END),6)
	TcSqlExec(cQueryUpd)
	
	cQueryUpd := " UPDATE GW1010 TW1 SET GW1_ENTNRC = NVL((
	cQueryUpd += " SELECT TRIM(SD2.D2_EST)||SC5.C5_XCODMUN FROM GW1010 GW1 INNER JOIN(SELECT * FROM SD2010) SD2 ON SD2.D2_DOC = GW1.GW1_NRDC
	cQueryUpd += " AND SD2.D2_SERIE = GW1.GW1_SERDC AND SD2.D2_ITEM = '01' AND SD2.D_E_L_E_T_ = ' ' AND GW1.GW1_FILIAL = SD2.D2_FILIAL
	cQueryUpd += " INNER JOIN(SELECT * FROM SC5010) SC5 ON SD2.D2_PEDIDO = SC5.C5_NUM AND SC5.C5_XCODMUN <> ' ' AND SC5.D_E_L_E_T_ = ' '
	cQueryUpd += " AND SC5.C5_FILIAL = SD2.D2_FILIAL WHERE GW1.D_E_L_E_T_ = ' ' AND GW1.GW1_FILIAL = '02' AND TW1.GW1_NRDC = GW1.GW1_NRDC
	cQueryUpd += " AND TW1.GW1_SERDC = GW1.GW1_SERDC ),' ') WHERE TW1.D_E_L_E_T_ = ' ' AND TW1.GW1_FILIAL = '02'
	TcSqlExec(cQueryUpd)
	
	
	cQueryUpd := " UPDATE GW1010 TW1 SET GW1_ENTNRC = NVL((
	cQueryUpd += " SELECT DISTINCT GU7_NRCID FROM GU7010 GU7 WHERE SUBSTR(GU7_NRCID,3,5) = SUBSTR( RTRIM(LTRIM(TW1.GW1_ENTNRC)),3,5)  AND GU7_CDUF = SUBSTR(RTRIM(LTRIM(TW1.GW1_ENTNRC)),1,2) AND GU7.D_E_L_E_T_ = ' '),' ')
	cQueryUpd += " WHERE GW1_ENTNRC <> ' '
	TcSqlExec(cQueryUpd)
	
	
	
	cQuery := "SELECT GWN.* FROM " + RetSQLName("GWN") + " GWN WHERE"
	cQuery += "		GWN.GWN_FILIAL >= '02' AND GWN.GWN_FILIAL <= '02' AND "
	cQuery += "		GWN.GWN_CDTRP  = '95591723003800'  AND " 
	cQuery += "		GWN.GWN_SIT  = '1'  AND "
	//cQuery += "		GWN.GWN_NRROM  >= '00144531' AND
	/*
	cQuery += "		GWN.GWN_NRROM  >= '00000901' AND GWN.GWN_NRROM  <= '" + cRomaneioFim	+ "' AND "
	cQuery += "		GWN.GWN_CDCLFR >= '" + cClassIni    	+ "' AND GWN.GWN_CDCLFR <= '" + cClassFim		+ "' AND "
	cQuery += "		GWN.GWN_CDTPOP >= '" + cTpOpIni    		+ "' AND GWN.GWN_CDTPOP <= '" + cTpOpFim		+ "' AND "
	cQuery += "		GWN.GWN_DTIMPL >= '" + DTOS(dDataIni)	+ "' AND GWN.GWN_DTIMPL <= '" + DTOS(dDataFim) 	+ "' AND "
	
	If lConsCalculados == 2
		cQuery += "GWN_CALC != '1' AND "
	EndIf
	*/
	cQuery += "   GWN.GWN_DTIMPL >= '20210101' AND  GWN.D_E_L_E_T_ <> '*' "
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasGWN, .F., .T.)
	
	dbSelectArea((cAliasGWN))
	(cAliasGWN)->( dbGoTop() )
	
	If (cAliasGWN)->( Eof() )
		Return
	EndIf
	
	(cAliasGWN)->( dbGoTop() )
	While !(cAliasGWN)->( Eof() )
		
		dbSelectArea("GWN")
		dbSetOrder(1)
		If dbseek((cAliasGWN)->GWN_FILIAL + (cAliasGWN)->GWN_NRROM)
			IF GWN->GWN_SIT  = '1'
				
				
				//IncProc("Filial: " + (cAliasGWN)->GWN_FILIAL + ", Romaneio: " + AllTrim((cAliasGWN)->GWN_NRROM))
				nRomCount++
				// conout("Roamenio: " + AllTrim((cAliasGWN)->GWN_NRROM) + " [" + AllTrim(Str((cAliasGWN)->(RecNo()))) + "/" + AllTrim(Str(nTotalRomaneios)) + "]")
				
				
				aSize(aAgrFrt , 0)
				aSize(aDocCarg, 0)
				aSize(aTrchDoc, 0)
				aSize(aItDoc  , 0)
				aSize(aRetCalc, 0)
				
				// Romaneio
				aAdd(aAgrFrt,{(cAliasGWN)->GWN_NRROM,  ;	// Numero do Agrupador
				(cAliasGWN)->GWN_CDTRP,  ;  	// Transportador
				(cAliasGWN)->GWN_CDTPVC, ; 	// Tipo de Veiculo
				(cAliasGWN)->GWN_CDCLFR, ; 	// Classificacao de Frete
				(cAliasGWN)->GWN_CDTPOP, ; 	// Tipo de Operacao
				(cAliasGWN)->GWN_DISTAN, ; 	// Distancia Percorrida
				(cAliasGWN)->GWN_NRCIDD, ; 	// Cidade Destino
				(cAliasGWN)->GWN_CEPD})   	// CEP Destino
				
				// Documentos de Carga
				dbSelectArea("GW1")
				GW1->(dbSetOrder(09))
				If	GW1->(dbSeek((cAliasGWN)->GWN_FILIAL + (cAliasGWN)->GWN_NRROM))
					While !GW1->(Eof()) .AND. ;
							GW1->GW1_FILIAL == (cAliasGWN)->GWN_FILIAL .AND. ;
							GW1->GW1_NRROM  == (cAliasGWN)->GWN_NRROM
						
						// Totaliza unitizadores do documento selecionado
						nQtde := 0
						dbSelectArea("GWB")
						dbSetOrder(02)
						dbSeek(GW1->GW1_FILIAL + GW1->GW1_CDTPDC + GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC)
						While !GWB->(Eof()) .AND. ;
								GWB->GWB_FILIAL == GW1->GW1_FILIAL .AND. ;
								GWB->GWB_CDTPDC == GW1->GW1_CDTPDC .AND. ;
								GWB->GWB_EMISDC == GW1->GW1_EMISDC .AND. ;
								GWB->GWB_SERDC  == GW1->GW1_SERDC  .AND. ;
								GWB->GWB_NRDC   == GW1->GW1_NRDC
							nQtde += GWB->GWB_QTDE
							GWB->(dbSkip())
						EndDo
						
						aAdd(aDocCarg,{GW1->GW1_EMISDC, ;	// Emitente do Documento
						GW1->GW1_SERDC , ; 	// Serie do Documento
						GW1->GW1_NRDC  , ; 	// Numero do Documento
						GW1->GW1_CDTPDC, ; 	// Tipo do Documento
						GW1->GW1_CDREM , ;  	// Remetente do Documento
						GW1->GW1_CDDEST, ; 	// Destinatario do Documento
						GW1->GW1_ENTEND, ; 	// Endereco de Entrega
						GW1->GW1_ENTBAI, ; 	// Bairro de entrega
						GW1->GW1_ENTNRC, ; 	// Cidade de Entrega
						GW1->GW1_ENTCEP, ; 	// CEP de Entrega
						GW1->GW1_NRREG , ;  	// Região de destino
						GW1->GW1_TPFRET, ; 	// Tipo de Frete
						GW1->GW1_ICMSDC, ; 	// ICMS?
						GW1->GW1_USO   , ;  	// Finalidade da mercadoria
						GW1->GW1_CARREG, ; 	// Número do carregamento
						GW1->GW1_NRROM , ;  	// Numero do Agrupador
						IIf(nQtde > 0, nQtde, GW1->GW1_QTVOL)}) //Quantidade
						
						// Trechos do Documento de Carga
						dbSelectArea("GWU")
						dbSetOrder(01)
						dbSeek(GW1->GW1_FILIAL + GW1->GW1_CDTPDC + GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC)
						While GWU->(!Eof()) .AND. ;
								GWU->GWU_FILIAL == GW1->GW1_FILIAL .AND. ;
								GWU->GWU_CDTPDC == GW1->GW1_CDTPDC .AND. ;
								GWU->GWU_EMISDC == GW1->GW1_EMISDC .AND. ;
								GWU->GWU_SERDC  == GW1->GW1_SERDC  .AND. ;
								GWU->GWU_NRDC   == GW1->GW1_NRDC
							
							aAdd(aTrchDoc,{GWU->GWU_EMISDC, ;	// Emitente do Documento
							GWU->GWU_SERDC , ;  	// Serie do Documento
							GWU->GWU_NRDC  , ;  	// Numero do Documento
							GWU->GWU_CDTPDC, ; 	// Tipo do Documento
							GWU->GWU_SEQ   , ;  	// Sequencia do Trecho
							GWU->GWU_CDTRP , ;  	// Transportador do Trecho
							GWU->GWU_NRCIDD, ; 	// Cidade Destino
							GWU->GWU_CDTPVC, ; 	// Tipo de Veiculo do Trecho
							GWU->GWU_PAGAR})  	// Trecho eh pago ou nao?
							GWU->(dbSkip())
						EndDo
						
						// Itens do Documento
						dbSelectArea("GW8")
						dbSetOrder(01)
						dbSeek(GW1->GW1_FILIAL + GW1->GW1_CDTPDC + GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC)
						While GW8->(!Eof()) .AND. ;
								GW8->GW8_FILIAL == GW1->GW1_FILIAL .AND. ;
								GW8->GW8_EMISDC == GW1->GW1_EMISDC .AND. ;
								GW8->GW8_CDTPDC == GW1->GW1_CDTPDC .AND. ;
								GW8->GW8_SERDC  == GW1->GW1_SERDC  .AND. ;
								GW8->GW8_NRDC   == GW1->GW1_NRDC
							
							aAdd(aItDoc,{GW8->GW8_EMISDC, ;	// Emitente do Documento
							GW8->GW8_SERDC , ;	// Serie do Documento
							GW8->GW8_NRDC  , ;	// Numero do Documento
							GW8->GW8_CDTPDC, ;	// Tipo do Documento
							GW8->GW8_ITEM  , ;	// Item
							GW8->GW8_CDCLFR, ;	// Classificacao de Frete
							GW8->GW8_TPITEM, ;	// Classificacao de Frete
							GW8->GW8_QTDE  , ;	// Quantidade do Item
							GW8->GW8_PESOR , ;	// Peso do Item
							GW8->GW8_PESOC , ;	// Peso Cubado
							GW8->GW8_QTDALT, ;	// Quantidade/Peso Alternativo
							GW8->GW8_VALOR , ;	// Valor do Item
							GW8->GW8_VOLUME, ;	// Volume ocupado (m3)
							GW8->GW8_TRIBP})  	// Frete tributado PIS
							
							GW8->(dbSkip())
						EndDo
						
						GW1->(dbSkip())
					EndDo
					
				EndIf
				CalculaRomaneios()
			EndIf
		EndIf
		(cAliasGWN)->(dbSkip())
		
		
	EndDo
	
	
RETURN ()


Static Function CalculaRomaneios()
	Local cMotivoErro
	Local aErr
	Local nY
	Local nZ := 0
	Local lLog := IIF(SuperGetMv("MV_LOGCALC",,'1') == '2',.F., .T.)//Indica se será gerado ou não o log de cálculo, de acordo com os parametros do módulo
	
	Private _lSemHelp := .F. // Variável usada para não exibir os Help's da função GFEA50LIB()
	
	cFilAtual := cFilAnt
	cFilAnt := (cAliasGWN)->GWN_FILIAL
	
	aRetCalc := GFECLCFRT(aAgrFrt, aDocCarg, aTrchDoc, aItDoc, /*aTblFrt*/, .T. /*lReal*/ , 0 /*iLogProc*/, /*lTabProv*/, /*lParCons*/, /*iTpSimul*/, .T. /*lCalcLote*/, .T. /* HideProgress */, lLog)
	
	cFilAnt := cFilAtual
	
	
	If aRetCalc[1]
		nCountOk++
		
		
		
		// Atualiza o romaneio como calculado e a Data/Hora como atual
		dbSelectArea("GWN")
		dbSetOrder(1)
		If dbseek((cAliasGWN)->GWN_FILIAL + (cAliasGWN)->GWN_NRROM)
			RecLock('GWN', .F. )
			GWN->GWN_CALC := "1"
			GWN->GWN_MTCALC := ""
			GWN->GWN_DTCALC := DDATABASE
			GWN->GWN_HRCALC := TIME()
			
			cMsg := ""
			GFEA050LIB(.T., ' ',DDATABASE+1,TIME())
			
			GWN->( MsUnLock() )
			
		Endif
		
		/*
		GWN->(dbSelectArea("GWN"))
		GWN->(dbGoTop())
		While GWN->(!Eof())
			If (GWN->GWN_SIT = '1' .Or. GWN->GWN_SIT = '2')
				GFEA050LIB(.T., ' ',DDATABASE+1,TIME())
			Endif
			
			GWN->(DbSkip())
		End
		*/
		
	Endif
Return





#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "rwmake.ch"
#include "TOTVS.CH"

/*====================================================================================\
|Programa  | LPJOBROMANEIO     | Autor | GIOVANI.ZAGO             | Data | 01/01/2016 |
|=====================================================================================|
|Sintaxe   | JOB automatização do romaneio de carga									  |
|          |  									                                      |
|=====================================================================================|
|Uso       | Especifico La Pastina                                                    |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================
*/
*----------------------------*
User Function LPJOBROMANEIO()
	*----------------------------*
	
	Local aNFe		:= {}
	Local nCont		:= 0
	Local _cRoman   := ' '
	Local cQuery    := ''
	Local cQuery2   := ''
	Local cAlias2   := 'ROM1'
	Local cAliasLif := 'ROM2'
	
	PREPARE ENVIRONMENT EMPRESA '03' FILIAL '13'
	
	
	cQuery := " SELECT DISTINCT
	cQuery += " GW1.GW1_CDDEST,
	cQuery += " GW1.GW1_DTEMIS
	
	cQuery += " FROM "+RetSqlName('GW1')+" GW1 "
	cQuery += " WHERE GW1.D_E_L_E_T_ = ' '
	cQuery += " AND GW1.GW1_FILIAL ='"+xFilial("GW1")+"'"
	cQuery += " AND GW1.GW1_SIT    = '4'
	cQuery += " AND GW1.GW1_NRROM  <> ' '
	cQuery += " AND EXISTS(SELECT * FROM "+RetSqlName('GW1')+" TW1 "
	cQuery += " WHERE TW1.D_E_L_E_T_ = ' '
	cQuery += " AND TW1.GW1_FILIAL = GW1.GW1_FILIAL
	cQuery += " AND TW1.GW1_SIT    = GW1.GW1_SIT
	cQuery += " AND TW1.GW1_NRROM  <> ' '
	cQuery += " AND TW1.GW1_NRROM  <> GW1.GW1_NRROM
	cQuery += " AND TW1.GW1_CDDEST = GW1.GW1_CDDEST
	cQuery += " AND TW1.GW1_DTEMIS = GW1.GW1_DTEMIS
	cQuery += " AND TW1.R_E_C_N_O_ <> GW1.R_E_C_N_O_ )
	
	//cQuery += " AND GW1.GW1_CDDEST = '00239147000139'
	
	
	cQuery += " ORDER BY GW1.GW1_CDDEST,GW1.GW1_DTEMIS
	
	
	
	cQuery := ChangeQuery(cQuery)
	
	DbCommitAll()
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif,.T.,.T.)
	
	
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbGoTop())
	
	
	While !(cAliasLif)->(Eof())
		
		
		
		
		cQuery2 := " SELECT
		cQuery2 += " GW1_DANFE
		
		cQuery2 += " FROM "+RetSqlName('GW1')+" GW1 "
		cQuery2 += " WHERE GW1.D_E_L_E_T_ = ' '
		cQuery2 += " AND GW1.GW1_FILIAL = '"+xFilial("GW1")+"'"
		cQuery2 += " AND GW1.GW1_SIT    = '4'
		cQuery2 += " AND GW1.GW1_NRROM  <> ' '
		cQuery2 += " AND GW1.GW1_CDDEST = '"+(cAliasLif)->GW1_CDDEST+"'
		cQuery2 += " AND GW1.GW1_DTEMIS = '"+(cAliasLif)->GW1_DTEMIS+"'
		
		
		cQuery2 := ChangeQuery(cQuery2)
		
		DbCommitAll()
		If Select(cAlias2) > 0
			(cAlias2)->(dbCloseArea())
		EndIf
		
		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery2),cAlias2,.T.,.T.)
		
		
		dbSelectArea(cAlias2)
		(cAlias2)->(dbGoTop())
		
		
		While !(cAlias2)->(Eof())
			
			Aadd(aNFe,{(cAlias2)->GW1_DANFE})
			
			(cAlias2)->(dbSkip())
		End
		
		//49459613000180
		If  Len(aNFe) > 1
			dbSelectArea("GW1")
			GW1->(dbSetOrder(12)) //indice da chave da NFe
			For nCont := 1 To Len(aNFe)
				If GW1->(dbSeek(aNFe[nCont,1]))
					dbSelectArea("GWN")
					GWN->(dbSetOrder(1))
					If GWN->(dbSeek(xFilial("GWN")+GW1->GW1_NRROM))
						
						//reabrir romaneio
						If GWN->GWN_SIT = "3"	// Liberado
							GFEA050REA(.T.)
						EndIf
						
						//(lValid, lOcor) Função para eliminar os Cálculos do Documento de Carga  Requere que o Documento de Carga já esteja posicionado(GW1).
						If GFEA44DELC(.t.,.f.)
							
							// Elimina do Romaneio o Documento de Carga escolhido
							RecLock("GW1",.F.)
							GW1->GW1_NRROM 	:= ""
							GW1->GW1_SIT 	:= "3" // Liberado
							MsUnLock("GW1")
							_cRoman:= GWN->GWN_NRROM
						EndIf
					EndIf
					
					
				EndIf
			Next nCont
			
			dbSelectArea("GW1")
			GW1->(dbSetOrder(12)) //indice da chave da NFe
			For nCont := 1 To Len(aNFe)
				If GW1->(dbSeek(aNFe[nCont,1]))
					
					// Elimina do Romaneio o Documento de Carga escolhido
					RecLock("GW1",.F.)
					GW1->GW1_CALCAT	:= " "
					GW1->GW1_NRROM 	:= _cRoman
					GW1->GW1_SIT 	:= "4" // Liberado
					MsUnLock("GW1")
					
				EndIf
			Next nCont
			dbSelectArea("GWN")
			GWN->(dbSetOrder(1))
			If GWN->(dbSeek(xFilial("GWN")+_cRoman))
				
				GFE050CALC()
				
				If (GWN->GWN_SIT = '1' .Or. GWN->GWN_SIT = '2')
					GFEA050LIB(.T., ' ',DDATABASE+1,TIME())
				Endif
				
				
			EndIf
			
		EndIf
		
		
		(cAliasLif)->(dbSkip())
	End
	If Select(cAlias2) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
Return .T.


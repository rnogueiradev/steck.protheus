#Include 'Protheus.ch'
#Include 'Topconn.ch'
#Include 'rwmake.ch'

/*/{Protheus.doc} STFATMON

Tela para Monitorar o Faturamento Automatico

@type function
@author Everson Santana
@since 08/12/2020
@version Protheus 12 - Faturamento

@history ,Ticket 20191106000024
/*/

User Function STFATMON()

	Private oFont20b 	:= tFont():New("Arial",nil,-20,,.t.,nil,nil,nil,nil,.F.,.F.)
	Private oFont18b 	:= tFont():New("Arial",nil,-18,,.t.,nil,nil,nil,nil,.F.,.F.)
	Private oFont14b	:= tFont():New("Arial",nil,-14,,.t.,nil,nil,nil,nil,.F.,.F.)
	Private oFont20 	:= tFont():New("Arial",nil,-20,,.t.,nil,nil,nil,nil,.F.,.F.)
	Private oFont12		:= tFont():New("Arial",nil,-12,,.f.,nil,nil,nil,nil,.F.,.F.)
	Private oFont10		:= tFont():New("Arial",nil,-12,,.f.,nil,nil,nil,nil,.F.,.F.)
	Private oFont07		:= tFont():New("Arial",nil,-07,,.f.,nil,nil,nil,nil,.F.,.F.)
	Private oFont08		:= tFont():New("Arial",nil,-08,,.f.,nil,nil,nil,nil,.F.,.F.)
	Private oFont09		:= tFont():New("Arial",nil,-09,,.f.,nil,nil,nil,nil,.F.,.F.)
	Private aStruTMP	:= {}
	Private cQuery		:= ""
	Private oMenuUF 	:= NIL
	Private cEmail      := "" //U_GETZPA("EMAIL_ERRO_MERCANET","ZZ")        // E-mail para envio de avisos aos responsáveis

	//Variaveis do dialogo
	Private oDlg1		:= NIL
	Private oBrw1		:= 0
	Private nOpc 	  	:= 0                  //GD_INSERT+GD_DELETE+GD_UPDATE
	Private cLinhaOk	:= 'AllwaysTrue()'
	Private cTudoOk		:= 'AllwaysTrue()'
	Private cIniCpos	:= ''				  //Campos com incremento automatico
	Private aAlter    	:= {}				  //Vetor com os campos que poderão ser alterados.
	Private nFreeze		:= 0
	Private nMax		:= 999999999	      //Numero maximos de registros a serem exibidos
	Private cFieldOk	:= 'AllwaysTrue()'    //Validacao de campo
	Private cSuperDel	:= ''				  //Super Del
	Private cDelOk		:= 'AllwaysTrue()'	  //Validacao da Exclusão da Linha
	Private aHeader		:= {}
	Private aCols		:= {}
	Private lAsc        := .F.                // Ordem ascendente
	Private cFATBLQU 	:= GetMv('ST_FATBLQU',,'000000#001036',)
	Private _FATBLQ 	:=  GetMv('ST_FATBLQ')
	Private cSemaforo   := ""
	Private cFiltro     := "T"
	Private cPerg       := "STFATMON"

	If _FATBLQ
		cSemaforo := "ON"
	else
		cSemaforo := "OFF"
	EndIf

	criaSX1(cPerg)

	if !LoadAcols(cFiltro)
		msgBox("Sem dados a apresentar")
		return
	endif

	BuildHeader()

	BScreen()

Return

Static Function LoadAcols(_par01)

	Local aTmp    := {}
	Local cSqySF2 := ""
	Local cFiltro := _par01
	Local aWFs    := {}
	Local i, ik

	cSqySF2 := "SELECT COUNT(F2_CHVNFE) FROM "+RETSQLNAME("SF2")+" A WHERE A.D_E_L_E_T_ = ' ' "
	cSqySF2 += " AND A.F2_FILIAL= CB7_FILIAL AND A.F2_DOC = CB7_NOTA AND A.F2_SERIE = CB7_SERIE AND A.F2_CHVNFE =' ' "   // F2_FIMP / 20230825010834 -> inclusao A.F2_SERIE = CB7_SERIE 


	// --------------------------------------------------------
	// Monta a query de seleção de dados, a ordem colocada aqui,
	// será a mesma da tela de exibição
	// --------------------------------------------------------

	cQuery := " SELECT CB7_FILIAL,CB7_ORDSEP,CB7_PEDIDO,CB7_CLIENT,CB7_LOJA,CB7_DTEMIS,CB7_NOTA,
	cQuery += " CASE WHEN CB7_NOTA <> ' ' THEN 'BR_VERMELHO' ELSE 'BR_VERDE'  END MNTNOTA,"          // Valdemir Rabelo 04/10/2021 - Ticket: 20210615010129
	cQuery += " CASE WHEN C5_ZBLOQ = 1 AND C5_ZMOTBLO IN('MSG') THEN 'BR_VERMELHO' ELSE 'BR_VERDE'  END MSGCLI,
	cQuery += " CASE WHEN C5_ZBLOQ = 1 AND C5_ZMOTBLO IN('COND') THEN 'BR_VERMELHO' ELSE 'BR_VERDE'  END CONDPAG, "
	cQuery += " CASE WHEN C5_ZBLOQ = 1 AND C5_ZMOTBLO IN('DESC') THEN 'BR_VERMELHO' ELSE 'BR_VERDE'  END DESCONTO, "
	cQuery += " CASE WHEN C5_ZBLOQ = 1 AND C5_ZMOTBLO IN('PSC') THEN 'BR_VERMELHO' ELSE 'BR_VERDE'  END PRECOCON, "
	cQuery += " CASE WHEN C5_ZBLOQ = 1 AND C5_ZMOTBLO IN('VLR') THEN 'BR_VERMELHO' ELSE 'BR_VERDE'  END VLRMIN, "
	cQuery += " CASE WHEN C5_ZBLOQ = 1 AND C5_ZMOTBLO IN('OPE') THEN 'BR_VERMELHO' ELSE 'BR_VERDE'  END OPER, "
	cQuery += " CASE WHEN A1_XBLQFIN = '1' THEN 'BR_VERMELHO' ELSE 'BR_VERDE'  END FINAN, "
	cQuery += " CASE WHEN C5_ZREFNF = '1' THEN 'BR_VERMELHO' ELSE 'BR_VERDE'  END C5_ZREFNF,"
	cQuery += " C5_XALERTF "
	cQuery += " FROM "+RetSqlName("CB7")+" CB7 ""
	//-->> Clientes Autorizados a Faturar Automaticamente
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 "
	cQuery += "    ON SA1.A1_FILIAL = ' ' "
	cQuery += "        AND SA1.A1_COD = CB7.CB7_CLIENT "
	cQuery += "        AND SA1.A1_LOJA = CB7.CB7_LOJA "
	cQuery += "        AND SA1.A1_XFATAU = '1' "
	cQuery += "        AND SA1.A1_EST NOT IN('EX') "
	//-->>Estado que precisa de Guia GNRE ST/DIFAL(PE/RO/SE/TO/CE/MT) - PIN(RO/AM/RR/AC/AP)
	// cQuery += "        AND SA1.A1_EST NOT IN('EX','PE','RO','SE','TO','CE','MT','AM','RR','AC','AP') "
	//--<<
	cQuery += "        AND SA1.D_E_L_E_T_ = ' ' "
	//--<<

	//-->> Alerta Faturamento
	cQuery += " INNER JOIN "+RetSqlName("SC5")+" SC5 "
	cQuery += "    ON SC5.C5_FILIAL = CB7.CB7_FILIAL "
	cQuery += "        AND SC5.C5_NUM = CB7.CB7_PEDIDO "
//	cQuery += "        AND SC5.C5_XALERTF = ' ' "
	cQuery += "        AND SC5.C5_ZREFNF  = ' ' " //Refaturamento
	//cQuery += "        AND SC5.C5_XTIPO = '1' " //Somente Retira
	cQuery += "        AND SC5.D_E_L_E_T_ = ' ' "
	//--<<

	//-->> Valida Condição Pagamento utilizada
	cQuery += " INNER JOIN "+RetSqlName("SE4")+" SE4 "
	cQuery += "    ON SC5.C5_CONDPAG = SE4.E4_CODIGO "
	cQuery += "        AND SE4.D_E_L_E_T_ = ' ' "
	//--<<

	cQuery += " WHERE CB7.CB7_STATUS = '4'" //-- Embalagem Finalizada
	//cQuery += " AND CB7.CB7_FILIAL = '02' "
	cQuery += " AND CB7.CB7_FILIAL = '01' "      // Valdemir Rabelo 16/05/2022 - Chamado: 20220516010273
	cQuery += " AND ((CB7_NOTA = ' ') or (CB7_NOTA <> ' ' and (("+cSqySF2+") > 0))) "    // Valdemir Rabelo 04/10/2021 - Ticket: 20210615010129
	cQuery += " AND CB7_DTEMIS >= '"+DtoS(MV_PAR01)+"' "
	cQuery += " AND CB7_LOCAL = '03' "
	cQuery += " AND CB7.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY CB7.CB7_NOTA,CB7.CB7_DTEMIS "




	IF SELECT("TMP")>0
		TMP->(DbCloseArea())
	EndIF

	TCQUERY cQuery NEW ALIAS "TMP"
	DbSelectArea("TMP")
	DbGotop()

	aCols		:= {}
	aStruTMP	:= TMP->(DbStruct())

	// -----------------------------------------------------
	// Ajuste do tamanho dos campos com base no tamanho real
	// -----------------------------------------------------
	For i:=1 to Len(aStruTMP)
		If aStruTMP[i][2]=="N"
			aStruTMP[i][3]:= 10
			aStruTMP[i][4]:= 2
		ElseIf aStruTMP[i][1] $ "CB7_DTEMIS"
			aStruTMP[i][3]:= 10
			aStruTMP[i][4]:= 0
		Else
			aStruTMP[i][3]:= Len(&("TMP->"+aStruTMP[i][1]))
		EndIF
	Next

	//------------------------------------
	// Trata se não houver dados na query
	//------------------------------------
	If Eof()
		return(.F.)
	EndIf

	// ---------------------------------------------
	// -- Faz a montagem do aCols
	// ---------------------------------------------
	//_nSeq:=0
	While !Eof()
		aTmp:={}
		For ik:= 1 to Len(aStruTMP)
			If aStruTMP[ik][1]=="CB7_FILIAL"
				AADD(aTmp,CB7_FILIAL)
				//		ElseIf aStruTMP[ik][1]=="_SEQ"
				//			AADD(aTmp,strZero(_nseq,10,0))
			ElseIf aStruTMP[ik][1] $ "CB7_DTEMIS"
				AADD(aTmp,STOD(&("TMP->"+aStruTMP[ik][1])))
			Else
				AADD(aTmp,&("TMP->"+aStruTMP[ik][1]))
			EndIf

		Next
		//	_nSeq++
		AADD(aTmp,.F.)	    //ADD o flag de fim de grid
		AADD(aCols,aTmp)	//Add do Acols
		// Valdemir Rabelo 05/10/2021 - Ticket: 20210615010129
		if (TMP->MNTNOTA=="BR_VERMELHO")
		   aAdd(aWFs, {})
		endif 
		// ---------------------------------------------------
		DbSkip()
	End
	TMP->(DbCloseArea())

Return(.T.)

//==============================================
// 
//  Monta o Header
//
//==============================================
Static Function BuildHeader()

	AADD(aHeader,{RetTitle("CB7_FILIAL") , "CB7_FILIAL"	 		,PesqPict('CB7',"CB7_FILIAL")	, TamSX3("CB7_FILIAL")[1] 	, 00 , ".T." 	, ,"C" ,"",""}) //01
	AADD(aHeader,{RetTitle("CB7_ORDSEP") , "CB7_ORDSEP"  		,PesqPict('CB7',"CB7_ORDSEP")	, TamSX3("CB7_ORDSEP")[1] 	, 00 , ".T." 	, ,"C" ,"",""}) //02
	AADD(aHeader,{RetTitle("CB7_PEDIDO") , "CB7_PEDIDO"  		,PesqPict('CB7',"CB7_PEDIDO")	, TamSX3("CB7_PEDIDO")[1] 	, 00 , ".T." 	, ,"C" ,"",""}) //03
	AADD(aHeader,{RetTitle("CB7_CLIENT") , "CB7_CLIENT"  		,PesqPict('CB7',"CB7_CLIENT")	, TamSX3("CB7_CLIENT")[1] 	, 00 , ".T." 	, ,"C" ,"",""}) //04
	AADD(aHeader,{RetTitle("CB7_LOJA")   , "CB7_LOJA"    		,PesqPict('CB7',"CB7_LOJA")		, TamSX3("CB7_LOJA")[1]   	, 00 , ".T." 	, ,"C" ,"",""}) //05
	AADD(aHeader,{RetTitle("CB7_DTEMIS") , "CB7_DTEMIS"  		,PesqPict('CB7',"CB7_DTEMIS")	, TamSX3("CB7_DTEMIS")[1] 	, 00 , ".T." 	, ,"D" ,"",""}) //06
	AADD(aHeader,{RetTitle("CB7_NOTA")   , "CB7_NOTA"    		,PesqPict('CB7',"CB7_NOTA")		, TamSX3("CB7_NOTA")[1] 	, 00 , ".T." 	, ,"C" ,"",""}) //07
	AADD(aHeader,{'Monitor NF'           , "Monitor"    		,"@BMP"		                    , 10 					    , 00 , ".T." 	, ,"C" ,"",""}) //08     Valdemir Rabelo 14/10/2021 Ticket: 20210615010129
	AADD(aHeader,{"Msg. Cliente"      	 , "Msg. Cliente"   	,"@BMP"                         , 10   						, 00 , ""  		, ,"C" ,"",""}) //09
	AADD(aHeader,{"Cond. Pagt."       	 , "Cond. Pagt."   		,"@BMP"                         , 10   						, 00 , ""  		, ,"C" ,"",""}) //10
	AADD(aHeader,{"Desconto"          	 , "Desconto"       	,"@BMP"                         , 10   						, 00 , ""  		, ,"C" ,"",""}) //11
	AADD(aHeader,{"Preço Sob Consulta"	 , "Preço Sob Consulta" ,"@BMP"                         , 10   						, 00 , ""  		, ,"C" ,"",""}) //12
	AADD(aHeader,{"Vlr. Min."         	 , "Vlr. Min."      	,"@BMP"                         , 10   						, 00 , ""  		, ,"C" ,"",""}) //13
	AADD(aHeader,{"Operação"          	 , "Operação"       	,"@BMP"                         , 10   						, 00 , ""  		, ,"C" ,"",""}) //14
	AADD(aHeader,{"Financeiro"        	 , "FINAN"     			,"@BMP"                         , 10   						, 00 , ""  		, ,"C" ,"",""}) //15
	AADD(aHeader,{"Refaturamento"      	 , "Refaturamento"     	,"@BMP"                         , 10   						, 00 , ""  		, ,"C" ,"",""}) //16
	AADD(aHeader,{RetTitle("C5_XALERTF") , "C5_XALERTF"    		,PesqPict('SC5',"C5_XALERTF")	, TamSX3("C5_XALERTF")[1] 	, 00 , ".T." 	, ,"C" ,"",""}) //17

Return

//===========================================================
// 
//  Monta a interface padrão com o usuário
// 
//===========================================================
Static Function BScreen()

	Local aAdvSize		 := {}
	Local aInfoAdvSize	 := {}
	Local aObjSize		 := {}
	Local aObjCoords	 := {}
	Local aButtons   	 := {}

	//------------------------------------------------
	// Monta as Dimensoes dos Objetos
	//------------------------------------------------
	aSizeAut := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 315,  50, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	aInfo   := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects, .T. )

	oDlg1  := MSDialog():New( aSizeAut[7],00, aSizeAut[6],aSizeAut[5],"Monitor Faturamento Automatico",,,.F.,,,,,,.T.,,,.T. )

	//----------------------------------------------------------
	//Executa o renew a cada X minutos conforme parametro
	//----------------------------------------------------------
	nSegundos    := ( mv_par02 * 600 )
	//nSegundos		:= 6000
	otimer		 :=TTimer():New(nSegundos,{|| oTimer:DeActivate(),Renew(cFiltro),oTimer:Activate() },oDlg1)
	oTimer:Activate()

	//---------------------------------------------------------------------------------------------------------------
	// Grupo para ligar ou desligar a integração entre Protheus x Mercanet
	//---------------------------------------------------------------------------------------------------------------
	oGrp1      := TGroup():New( 002,004,050,100," Faturamento Automatico ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oBtnOn     := TButton():New( 015,10 , "ON"  , oGrp1 , {|| semaforo("ON") },055,013,,,,.T.,,"",,,,.F. )
	oBtnOff    := TButton():New( 030,10 , "OFF" , oGrp1 , {|| semaforo("OFF") },055,013,,,,.T.,,"",,,,.F. )
	oGrp2      := TGroup():New( 013,074,045,090,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oTBitOn    := TBitmap():New(15, 76, 40, 80, NIL, "VERDE.PNG"    , .T., oGrp2,{||Alert("Integração está ativada.")}    , NIL, .F., .F., NIL, NIL, .F., NIL, .T., NIL, .F.)
	oTBitOff   := TBitmap():New(30, 76, 40, 80, NIL, "VERMELHO.PNG" , .T., oGrp2,{||Alert("Integração está desativada.")} , NIL, .F., .F., NIL, NIL, .F., NIL, .T., NIL, .F.)

	//--------------------------------------------------------------------
	// Avalia status do semaforo para atualizar na tela
	//--------------------------------------------------------------------
	avalSemaforo(cSemaforo)

	//--------------------------------------------------------------------
	// Botoes de refresh , visualização de pedidos / erros
	//--------------------------------------------------------------------
	oGrp2      := TGroup():New(  005,110,050,245,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	cDateTime    := dtoc(dDataBase) + " - " + time() + " hs."
	oSay2        := TSay():New( 018,118,{|| "Última atualização: "} , oGrp2,,oFont10,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,244,012)
	oSay3        := TSay():New( 018,178,{|| cDateTime }             , oGrp2,,oFont10,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,244,012)
	oBtnRenew    := TButton():New( 034,148 , "Atualizar"            , oGrp2 , {|| renew(cFiltro) },055,013,,,,.T.,,"",,,,.F. )

	//------------------------------------- SAYs --------------------------------------------
	oGrp3      := TGroup():New(  005,250,050,540,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1        := TSay():New( 012,320,{|| SM0->M0_NOMECOM }       , oGrp3,,oFont20b,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,244,012)
	oSay1        := TSay():New( 030,330,{|| SM0->M0_FILIAL }       , oGrp3,,oFont18b,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,244,012)

	//------------------- Estatisticas -------------------------------------------------------------------
	oGrp5        := TGroup():New(  005,545,050,647,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oBtnSair   := TButton():New( 012,570 , "Sair"                 , oGrp5 , {|| oDlg1:end() },055,013,,,,.T.,,"",,,,.F. )
	oBtnParam    := TButton():New( 030,570 , "Parâmetros"         , oGrp5 , {|| pergunte(cPerg,.T.),oTimer:nInterval:= (mv_par02*600),renew(cFiltro) },055,013,,,,.T.,,"",,,,.F. )
	//----------------------------------------------------BROWSE------------------------------------------
	oBrw1 := MsNewGetDados():New(aPosObj[2,1]-60, aPosObj[2,2] , aPosObj[2,3] , aPosObj[2,4] ,nOpc,cLinhaOk,cTudoOk,cIniCpos,aAlter,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oDlg1,aHeader,aCols)

	//---------------------------------------------------------
	// Metodo para Ordenar Coluna quando Clicada
	//---------------------------------------------------------
	oBrw1:oBROWSE:bHEADERCLICK := { |oBRW,nCOL,ADIM|oBrw1:oBROWSE:nCOLPOS := nCOL,FORDENA(nCOL),GETCELLRECT(oBRW,@ADIM)}

	oBrw1:oBrowse:SetFocus()

	//Ativa o dialogo
	oDlg1:Activate(,,,.T.)

Return

//================================================================
//
//
// Funcao para ordernar a coluna clicada pelo usuario
//
//
//================================================================
Static Function fORDENA(nCOL)

	if  lAsc
		aSORT(oBrw1:aCOLS,,,{|X,Y|(X[nCOL] < Y[nCOL])})
		lAsc := .F.
	else
		aSORT(oBrw1:aCOLS,,,{|X,Y|(X[nCOL] > Y[nCOL])})
		lAsc := .T.
	endif

	oBrw1:oBROWSE:REFRESH()

Return

//=================================================================================
// 
// Funcao para avaliar status do semaforo e atualizar informações em tela
//
//================================================================================= 
Static Function avalSemaforo(cSemaforo)

	if cSemaforo=="ON"
		oBtnOn:lActive    := .F.
		oBtnOff:lActive   := .T.
		oTBitOn:lVisible  := .T.
		oTBitOff:lVisible := .F.
	else
		oBtnOn:lActive:=.T.
		oBtnOff:lActive:=.F.
		oTBitOn:lVisible  := .F.
		oTBitOff:lVisible := .T.
	endif

Return

//=================================================================================
// 
// Funcao para ativar ou desativar integracao dos pedidos Mercanet x Protheus 
//
//================================================================================= 
Static Function semaforo(_par01)

	Local cTitulo := ""
	Local cTexto  := ""
	Local cAnexos := ""

	Default _FATBLQ := .T.

	If __cUserId $ cFATBLQU

		cSemaforo := _par01

		If cSemaforo $ "ON"
			_FATBLQ := .T.
		ElseIf cSemaforo $ "OFF"
			_FATBLQ := .F.
		EndIf

		PutMv("ST_FATBLQ",_FATBLQ)

		avalSemaforo(cSemaforo)

		Renew(cFiltro)
	else

		MsgAlert("Usuário sem permissão para utilizar está rotina")

	EndIf

Return
//=================================================================================
// 
// Funcao de refresh da tela  
//
//================================================================================= 
Static Function Renew(cFiltro)

	//Recarrega/Atualiza o Array Acols
	LoadAcols(cFiltro)

	//Atualiza Data e Hora da obteção dos dados
	cDateTime    := dtoc(dDataBase) + " - " + time() + " hs."
	oSay3:SetText(cDateTime)
	oSay3:CtrlRefresh()

	//Define o acols da grid
	oBrw1:SetArray(aCols,.t.)
	oBrw1:Refresh()
	oBrw1:oBrowse:SetFocus()

Return

/*****************************************
**FUNCAO PARA CRIAR A PERGUNTA
******************************************/
Static Function CriaSX1(cPerg)

	Private bValid	:=Nil
	Private cF3		:=Nil
	Private cSXG	:=Nil
	Private cPyme	:=Nil

	PutSx1(cPerg,'01','Data OS a partir de','','','mv_ch1','D',8,0,1,'G',bValid,"",cSXG,cPyme,'MV_PAR01',,,,,,,)
	PutSx1(cPerg,'02','Tempo Refresh (Minutos)','','','mv_ch2','N',3,0,1,'G',bValid,"",cSXG,cPyme,'MV_PAR02',,,,,,,)

	pergunte(cPerg,.F.)

RETURN

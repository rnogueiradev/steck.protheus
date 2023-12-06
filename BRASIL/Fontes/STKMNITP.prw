#Include "PROTHEUS.CH"
#Include "HBUTTON.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE ENTER CHAR(13) + CHAR(10)

//--------------------------------------------------------------
/*/Protheus.doc Monitoramento dos Apontamentos
Description
author: Jackson Santos
return xRet Return Description
author  -
since
/*/
//--------------------------------------------------------------

User Function STKMNTP(lJobExec)
	
	Local oButton1
	Local oSay1


	Private cUserSis   := "" 
	Private oSayHuawei
	Private oBitmapH
	Private cCodHuawei := ""
	private oFont1     := TFont():New("Arial Narrow",,022,,.T.,,,,,.F.,.F.)
	private oFont2     := TFont():New("Arial",,020,,.F.,,,,,.F.,.F.)
	private oFont3     := TFont():New("Arial",,022,,.T.,,,,,.F.,.F.)
	private oFont4     := TFont():New("Myriad Arabic",,044,,.T.,,,,,.F.,.F.)
	private oFont5     := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
	Private _lok       := .F.
	Private cEtiqOfc   := SPACE(30)
	Private cCliente   := ""
	Private cCodOp     := ""
	Private cNcomp     := ""
	Private nQtdOri    := 0
	Private nQtdEnt    := 0
	private cCodPai    :=""
	Private cNomePai   := ""
	Private oEtiq
	Private oNomeCli
	Private oCodPai
	Private oNomePai
	Private oCodOP
	Private oQtdOri
	Private oQtdEnt
	Private cStartPath:= GetSrvProfString('Startpath','')
	Private aAux 		:= {LoadBitmap( GetResources(), "BR_VERMELHO"),LoadBitmap( GetResources(), "BR_AMARELO"),LoadBitmap( GetResources(), "BR_VERDE"),LoadBitmap( GetResources(), "BR_PRETO")}
	Private oOk      	:= LoadBitmap( GetResources(), "VERDE" )
	Private oNo      	:= LoadBitmap( GetResources(), "VERMELHO" )
	Private oIn      	:= LoadBitmap( GetResources(), "AMARELO" )
	private cCodProd	:= ""
	Private c2Leg1      := "1"
	Private n2Leg1      := RGB(176,224,230)
	Private c2Leg2      := "2"
	Private n2Leg2      := RGB(248,248,255)

	Private nPosBut		:= 100
	Private nDistBut	:= 045
	Private nPosBitm	:= 568
	Private nLBitm		:= 030
	Private nRegs		:= 030

	Private cTpProd	    := ""

	Private cComp 		:= "" 
	
	Private dDataIni	:= CTOD("  /  /  ")
	Private cLocOP 		:= ""
	Private oDtIni
	Private oLocOp
	Private lCheckBo1	:= .F.
	Private cNotTps 		:= ""
	Private _cTitulo
	Private lFibraFs := .F.
	Private cCodOpOri:=""
	PRIVATE lPrintID:= .f.
	Private lVldSenf	:= .T.
	Private aOpsComErro := {}
	Static oDlg
	Default lJobExec :=".T."
	
	If IsBlind() .Or. &(lJobExec)
		cNewEmp := "03"
		cNewFil := "01"
		Reset Environment
		RpcSetType( 3 )
		RpcSetEnv( cNewEmp, cNewFil,,,"PCP")
	EndIf
	cCliente   := CRIAVAR("A1_NOME")
	cCodOp     := CRIAVAR("D4_OP")
	cNcomp     := CRIAVAR("B1_DESC")
	cComp 	   := CriaVar("B1_COD")
	cLocOP 	   := CRIAVAR("D4_OP")
	dDataIni   := dDataBase
	cUserSis 			:= Upper(AllTrim(Substr(cUsuario,7,15)))
	cFileErro			:= cStartPath + 'errado.png'
	cFileok				:= cStartPath + 'certo.png'
	cFileLogo			:= cStartPath + 'logo.png'
	cFileAten			:= cStartPath + 'Atencao.png'
	cFileInter			:= cStartPath + 'Interroga.png'
	cPerc00				:= cStartPath + 'PERC00.png'
	cPerc25				:= cStartPath + 'PERC25.png'
	cPerc50				:= cStartPath + 'PERC50.png'
	cPerc75				:= cStartPath + 'PERC75.png'
	cPerc99			    := cStartPath + 'PERC99.png'
	cLogoHu				:= cStartPath + 'huawei_lg.png'

	//cNotTps  := "'PA'"
	_cTitulo := "MONITORAMENTO TRASNF. DO 01 PARA O 90"
	lFibraFs := .T.


	DEFINE MSDIALOG oDlg TITLE "" FROM 000, 000  TO 800, 1366 COLORS 0, 16777215 PIXEL
	oDlg:lMaximized := .T.
	cHoraAtu := Time()
	@ 027, 030 SAY oSay1 PROMPT _cTitulo  SIZE 389, 080 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
	@ 006, 019 GROUP oGroup1 TO 080,450 OF oDlg COLOR 0, 16777215 PIXEL
	@ 006, 455 GROUP oGroup2 TO 080,660 OF oDlg COLOR 0, 16777215 PIXEL

	@ 010, 460 SAY oSay10 PROMPT "Data Atual" SIZE 060, 016  OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	@ 020, 460 MSGET oDtIni VAR dDataIni SIZE 100, 015 When(.F.) OF oDlg COLORS 16711680, 16777215 FONT oFont3 PIXEL

	//@ 040, 460 SAY oSay10 PROMPT "Hora Atual" SIZE 060, 016 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	//@ 060, 460 MSGET oDtIni VAR cHoraAtu SIZE 100, 015 When(.F.) OF oDlg COLORS 16711680, 16777215 FONT oFont3 PIXEL

	//@ 060, 460 SAY oSay9 PROMPT "Procurar OP" SIZE 060, 016 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	//@ 070, 460 MSGET oLocOp VAR cLocOP SIZE 100, 015 OF oDlg COLORS 16711680, 16777215 FONT oFont3 PIXEL
	
	//Atributos dos botoes
	cCSSBtN1 :=	"QPushButton{background-color: #f6f7fa; color: #707070; font: bold 20px MS Sans Serif }"+;
		"QPushButton:pressed {background-color: #50b4b4; color: white; font: bold 20px MS Sans Serif; }"+;
		"QPushButton:hover {background-color: #878787 ; color: white; font: bold 20px MS Sans Serif; }"

	nTamBut:= 100
	nPColBt:= 460
	@ 044, nPColBt BUTTON oButton1 PROMPT "Proc.Transf." Action (ProcTransf(oGetDados:aCols)) SIZE nTamBut, 25 OF oDlg FONT oFont1 PIXEL
	oButton1:setCSS(cCSSBtN1)

	oBtn2 := TBtnBmp2():New( 578,400,26,26,"VERMELHO",,,,,oDlg,,,.T. )
	@ 292, 214 SAY oLeg2 PROMPT "Op Com Erro de saldo" 	SIZE 150, 012 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	oBtn3 := TBtnBmp2():New( 578,650,26,26,"AMARELO",,,,,oDlg,,,.T. )
	@ 292, 340 SAY oLeg3 PROMPT "Em Andamento" 	SIZE 150, 012 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	
	oBtn1 := TBtnBmp2():New( 578,900,26,26,"VERDE",,,,,oDlg,,,.T. )
	@ 292, 468 SAY oLeg1 PROMPT  "Não Transferido" 	SIZE 150, 012 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
	

	aHeader := {}
	aCols   := {}
	AADD(aHeader,  {    ""					, "FLAG"   	   	,"@BMP" 			,01,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,".F."   ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Produto" 			, "COMP"  		,"@R"				,15,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Desc.Produto"		, "DESC2"  		,"@R"				,40,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Qtd.Empenho"	 	, "QTDOP"  		,"@E 999,999.999" 	,07,0,""    ,"??????????????°","N"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Qtd.Entregue" 		, "QTDENT" 		,"@E 999,999.999" 	,07,0,""    ,"??????????????°","N"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Dt.Program."    	, "DTPROG"  	,"@R"				,08,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "OP"		       	, "OP"  		,"@R" 				,11,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    ""	 				, "COR"  		,"@R"				,01,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Ord.Sep."	       	, "ORDSEP"  	,"@R" 				,06,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	AADD(aHeader,  {    "Pedido"		    , "PEDIDO"  	,"@R" 				,06,0,""    ,"??????????????°","C"     ,""     ,"R"         ,""            ,""           ,""      ,"V"      , ""               , ""        , ""        })
	
	oGetDados:= (MsNewGetDados():New( 083, 021 , 288 ,660 /*450*/,NIL ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*VldCpo*/,/*superdel*/,/*delok*/,oDlg,aHeader,aCols))
	MontaTela()
	//oGetDados:oBrowse:lUseDefaultColors := .F.
	//oGetDados:oBrowse:SetBlkBackColor({|| CorGd02(oGetDados:nAt,8421376)})
	//oGetDados:oBrowse:oFont  := oFont4
	//oGetDados:oBrowse:oFont:NHEIGHT  := 50
	//oGetDados:oBrowse:oFont:Nwidth   := 50
	oGetDados:oBrowse:Refresh()


	nMilissegundos := 3000 //30000
	//DEFINE TIMER oTimer INTERVAL 30000 ACTION /*fAtualiza(oTimer,oGetDados2)*/ OF oDlg
	oTimer := TTimer():New(nMilissegundos, {|| fAtualiza(oTimer,oGetDados) }, oDlg )
	oTimer:Activate()

	ACTIVATE MSDIALOG oDlg CENTERED
	If IsBlind() .Or. &(lJobExec)
		Reset Environment
	EndIf
Return

//--------------------------------------------------------------
/*/Protheus.doc DOMROT - ROTEIRO DE PRODUÇÃO DOMEX
	Atualiza a tela via refresh temporário
	author: Jackson Santos
/*/
//--------------------------------------------------------------

Static Function fAtualiza(oTimer,oGetDados)
	oTimer:DeActivate()	
		MsgRun("Processando Transferência Pendentes! Aguarde!",,{|| ProcTransf(oGetDados:aCols)} )
	oTimer:Activate()
Return



Static Function MontaTela()
	Local cQuery:= ""
	


	If select("QRY2") > 0
		QRY2->(dbClosearea())
	Endif
	//UDBP12."
	cQuery := " SELECT CB7.CB7_OP,CB7_ORDSEP,CB7_PEDIDO,SD4.D4_LOCAL,CB8.CB8_PROD,SB1.B1_DESC,CB8_SALDOE,CB8_LOCAL,CB8.* 
	cQuery += ENTER +  " FROM " + RetSqlName("CB8") + " CB8 
	cQuery += ENTER +  " JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ <> '*' AND SB1.B1_FILIAL  = ' ' AND SB1.B1_COD = CB8.CB8_PROD 
	cQuery += ENTER +  " JOIN " + RetSqlName("CB7") + " CB7 ON CB7.D_E_L_E_T_ <> '*' AND CB7.CB7_FILIAL = CB8.CB8_FILIAL AND CB7.CB7_ORDSEP = CB8.CB8_ORDSEP
	cQuery += ENTER +  " JOIN " + RetSqlName("SD4") + " SD4 ON SD4.D_E_L_E_T_  <> '*' AND SD4.D4_FILIAL  = CB8.CB8_FILIAL AND SD4.D4_OP = CB8.CB8_OP AND CB8.CB8_PROD = SD4.D4_COD 
	cQuery += ENTER +  " 	AND SD4.D4_QTDEORI = CB8.CB8_QTDORI AND SD4.D4_LOCAL  <> CB8.CB8_LOCAL 
	cQuery += ENTER +  " WHERE CB8.D_E_L_E_T_ <> '*' AND CB8.CB8_FILIAL = '" + xFilial("CB8") + "' AND CB8_SALDOS = 0 AND SD4.D4_QUANT > 0
	cQuery += ENTER +  " AND SB1.B1_LOCPAD = SD4.D4_LOCAL
	cQuery += ENTER +  " ORDER BY CB7.CB7_OP,CB8.CB8_PROD
	If Select("QRY2") > 0
		QRY2->(DbCloeseArae())
	EndIf
	TCQUERY cQuery NEW ALIAS "QRY2"
	//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY2",.T.,.T.)

	oGetDados:aCols := {}

	If QRY2->(!eof())
		
		While QRY2->(!eof())

			
			nPos:= aScan(oGetDados:aCols,{|x| AllTrim(x[2]) == AllTrim(QRY2->CB8_PROD) })
			/*
			IF nPos > 0
				oGetDados:aCols[nPos,aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'QTDOP' })] += nQtdOp
			Else*/
				AADD(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'FLAG'  })] := oOk 
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'COMP'  })] := AllTrim(QRY2->CB8_PROD)
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'DESC2' })] := AllTrim(QRY2->B1_DESC)
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'QTDOP' })] := QRY2->CB8_SALDOE
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'QTDENT'})] := 0
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'DTPROG'})] := DTOC(dDatabase)
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'OP' 	 })] := AllTrim(QRY2->CB7_OP)
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'ORDSEP'})] := AllTrim(QRY2->CB7_ORDSEP)
				oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'PEDIDO'})] := AllTrim(QRY2->CB7_PEDIDO)
				oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1 ] := .F.
			//Endif
			QRY2->(DbSkip())
		EndDo
	Else
		AADD(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'FLAG'  })] := oNo
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'COMP'  })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'DESC2' })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'QTDOP' })] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'QTDENT'})] := 0
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'DTPROG'})] := DTOC(dDatabase)
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'OP' })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'ORDSEP' })] := ""
		oGetDados:aCols[Len(oGetDados:aCols),aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'PEDIDO' })] := ""		
		oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1 ] := .T.
	EndIf

	oGetDados:Refresh()
	QRY2->(dbCloseArea())

Return

Static Function ProcTransf(aItensTrf)
Local lRet := .T.
Default aItensTrf := {}
Local cOrdSep       := ""
Local cPedido   := ""
Local cOrdProd  := ""
Local cOperador    := ""

Local nk 		:= 0 
Local aOpsExec  := {}
Local nPosOp 	:= 0


//Fazer o tratamento do Array para transferir apenas 1 vez a OP.
For nK:=1 To Len(aItensTrf)
	//Atualiza o Status
	oGetDados:aCols[nK,aScan(oGetDados:aHeader,{|aVet| AllTrim(aVet[2]) == 'FLAG'  })] := oIn
	nPosOp := aScan(aOpsExec,{|x| x[1] == Alltrim(aItensTrf[nK][7])}) 
	If nPosOp == 0
		AaDd(aOpsExec,{aItensTrf[nk][7],aItensTrf[nk][9],aItensTrf[nk][10]}) 
	EndIf
Next nK
oGetDados:Refresh()
//Inicia as Transferências
If Len(aOpsExec) >0
	For nk:=1 To Len(aOpsExec)
		CB7->(DbSetOrder(1))
		If CB7->(DbSeek(xFilial("CB7")+ aOpsExec[nK][2]))//Pesquisa a Ordem de separação
			cOrdSep     := CB7->CB7_ORDSEP
			cPedido 	:= CB7->CB7_PEDIDO 
			cOrdProd    := CB7->CB7_OP 
			cOperador 	:= CB7->CB7_CODOPE //operador estoque

			CB8->(OrdSetFocus(1))
			If CB8->(Dbseek(xFilial("CB8") + cOrdSep ))
				//Posiciona na CB8 e processa a rotina de transferência do coletor.
				U_STTranArm(cPedido,cOrdProd,cOperador,.T./*Tela*/)	
			Endif			
		EndIf
	Next nK
Endif 

Return lRet



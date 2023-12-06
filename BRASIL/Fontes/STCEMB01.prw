#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"+;
"QPushButton:pressed {	color: #FFFFFF; "+;
"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"



/*/{Protheus.doc} STCEMB01
    (long_desCRLFiption)
    Rotina para acompanhamento de Pedidos Embalados
    @type  Function
    @author user
    Valdemir Rabelo
    @since 14/04/2020
    @version version
    @param 
/*/
USER FUNCTION STCEMB01()
    Local aAreaT     := GetArea()
    Local cTabTMP    := GetNextAlias() 
	Local aStru		 := {}
	Local aCMBO      := {}
	Local aBrowse    := {}
	Local aIndex     := {}
	Local nX		 := 0
	Local nCBO       := 0
	Local cTitu      := ""
	
	Private aColunas := {}
	Private cData1   := ctod("  /  /  ")
	Private cData2   := ctod("  /  /  ")
	Private cPedido1 := ""
	Private cPedido2 := ""
	Private cOS1     := ""
	Private cOS2     := ""
	Private cCLIENT  := ""
	Private cLOJA    := ""
	Private cTitulo  := "Gerenciamento Pedidos Embalados"
	PRIVATE oConteudo   := nil
	PRIVATE oCBO        := nil	
	PRIVATE aCmbo       := {}
	PRIVATE cConteudo   := Space(100)
	PRIVATE cPict       := "@!"
	PRIVATE oLbx

	Static oDlg

	aCbo := {   {'PEDOS','Pedido+OS'},;
				{'PEDIDO','Pedido'},;
				{'OS','Ordem Serviço'},;
				{'EMISSAO' ,'Data Emissão'  },;
				{'CLIENTE' ,'Cliente'};
	}
	
	aEval(aCbo, {|x| aAdd(aCmbo, X[2]) })

     if !CRLFiaSX1()
       Return
     Endif

	 Processa( {|| aColunas := strelquer(cTabTMP) }, cTitulo)

	 if Len(aColunas)==0
	    MsgInfo("Não existe dados a serem apresentados","Atenção!")
		Return
	 Endif


	//+-----------------------------------------------+
	//| Monta a tela para usuario visualizar consulta |
	//+-----------------------------------------------+
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 To 570,1292 COLORS 0,16772829 PIXEL //STYLE nOR( WS_VISIBLE, WS_POPUP )
	oFWLMain := FWLayer():New()
	oFWLMain:Init( oDlg, .T. )
	oFWLMain:AddLine("LineSup",075,.T.)
	oFWLMain:AddLine("LineInf",022,.T.)
	oFWLMain:AddCollumn( "ColSP01", 098, .T.,"LineSup" )
	oFWLMain:AddWindow( "ColSP01", "WinSP01", "Registros", 100, .F., .F.,/*bAction*/,"LineSup",/*bGotFocus*/)
	oWinSP01 := oFWLMain:GetWinPanel('ColSP01','WinSP01',"LineSup" )
	oFWLMain:AddCollumn( "Col01", 098, .T.,"LineInf" )
	oFWLMain:AddWindow( "Col01", "Win01", "Ação"      ,100, .F., .F.,/*bAction*/,"LineInf",/*bGotFocus*/)
	oWin1 := oFWLMain:GetWinPanel('Col01','Win01',"LineInf" )

	@001,010 SAY "Campo" SIZE 020, 007 OF oWinSP01 COLORS 0, 16777215 PIXEL
	@000,030 MSCOMBOBOX oCBO VAR nCBO ITEMS aCmbo  SIZE 056, 09 OF oWinSP01 COLORS 0, 16777215 ON CHANGE SelChange(oCBO, nCBO, aCBO, oWinSP01, oBTProc,oLbx) PIXEL
	@000,085 MsGet oConteudo Var cConteudo PICTURE cPict SIZE 100, 09 OF oWinSP01 PIXEL
	@000,186 BUTTON oBTProc PROMPT "Localiza" SIZE 037, 09 OF oWinSP01 ACTION LocReg(oCBO, cConteudo, oLbx) PIXEL
	oCBO:nAT := 2

	@ 40,10 LISTBOX oLbx FIELDS HEADER ;
	'Pedido+OS','Pedido','Os','Separador','Volumes','Status','Tipo','Cliente','Loja','Nome','Data Emissao','TipoCli','Transp','Romaneio','Nf','Emissao NF','Bloq','Refaturamento Blq?','Entrega','Frete','Vendedor','Cubagem','Vlr Res Liq','Vlr Bruto NF','Peso total','Qtde Linhas','Qtde Pecas','Embalador','Alerta Fatur','Alerta Finan','Status Serasa','Dt Emissao OS','Hr Emissao OS','Dt Final Emb','Hr Final Emb','Dt Lib.Fin','Hr Lib Fin','Dt Cliente','Ord Compra' ;
	SIZE 620,165 OF oDlg PIXEL	
	AtuTela(oLbx, aColunas)			

	@002,244 BUTTON oCons 		PROMPT "Planilha"  SIZE 060, 034 Font oDlg:oFont ACTION GeraPlan(oLbx)  OF oWin1  PIXEL
	@002,304 BUTTON oCancela 	PROMPT  "Sair"	   SIZE 060, 034 Font oDlg:oFont ACTION oDlg:End() 	 OF oWin1  PIXEL
	oCons:SetCSS(CSSBOTAO)
	oCancela:SetCSS(CSSBOTAO)
	oCancela:cToolTip 	 := "Sair da tela"
	oCons:cToolTip 		 := "Gerar Planilha"
	oConteudo:cPlaceHold := "Informe o conteudo a pesquisar"
				   
	ACTIVATE MSDIALOG oDlg CENTER	                    


    if Select(cTabTMP) > 0
		(cTabTMP)->( dbCloseArea() )
	endif	

     RestArea( aAreaT )

Return




/*/{Protheus.doc} CRLFiaSX1
    (long_desCRLFiption)
    Rotina para abrir parâmetro
    @type  Function
    @author user
    Valdemir Rabelo
    @since 14/04/2020
    @version version
    @param 
/*/
Static Function CRLFiaSX1()
    Local aPergs := {}
    Local aRet   := {}
    Local lRET   := .F.
	Local cTMP

    aAdd( aPergs ,{1,"Data de", dDataBase    ,"@D 99/99/9999"       ,'.T.'    ,    ,'.T.',60,.F.}) 
    aAdd( aPergs ,{1,"Data ate",dDataBase    ,"@D 99/99/9999"       ,'.T.'    ,	   ,'.T.',60,.T.}) 
    aAdd( aPergs ,{1,"Pedido  de", Space(FWTamSX3('C5_NUM')[1])     ,"@!"         		   ,'.T.'    ,'','.T.',60,.F.}) 
    aAdd( aPergs ,{1,"Pedido ate",  '999999'                        ,"@!"                  ,'.T.'    ,'','.T.',60,.T.}) 
    aAdd( aPergs ,{1,"OS de", Space(FWTamSX3('CB7_ORDSEP')[1])      ,"@!"         		   ,'.T.'    ,'','.T.',60,.F.}) 
    aAdd( aPergs ,{1,"OS ate",  '999999999'                         ,"@!"                  ,'.T.'    ,'CTT','.T.',60,.T.}) 
    aAdd( aPergs ,{2,"Com NF",1            , {"1-SIM", "2-NAO","3-TODOS"}   , 50  ,'.T.',.T.})   
    aAdd( aPergs ,{1,"Cliente",Space(FWTamSX3('A1_COD')[1]),"@!"                  ,'.T.'    ,'SA1','.T.',60,.F.}) 
    aAdd( aPergs ,{1,"Loja",Space(FWTamSX3('A1_LOJA')[1])  ,"@!"                  ,'.T.'    ,'SA1','.T.',60,.F.}) 
    
    // FWTamSX3('RA_SITFOLH')[1]
    If ParamBox(aPergs ,"Entre com os dados", @aRet)   
	   cData1   := aRET[01]
	   cData2   := aRET[02]
	   cPedido1 := aRET[03]
	   cPedido2 := aRET[04]
	   cOS1     := aRET[05]
	   cOS2     := aRET[06]
	   cTMP     := aRET[07]
	   cCLIENT  := aRET[08]
	   cLOJA    := aRET[09]

	   if ValType(cTMP)=="N"
	      cCOMNF=1
	   else 
	      cCOMNF := Val(Left(cTMP,1))
	   endif
	   MV_PAR07 := cCOMNF
	   lRET    := .T.
	Endif

Return lRET




/*/{Protheus.doc} strelquer
    (long_desCRLFiption)
    Rotina montagem de query
    @type  Function
    @author user
    Valdemir Rabelo
    @since 14/04/2020
    @version version
    @param 
/*/
Static Function strelquer(cTabTMP)
	Local CR         := CRLF
	Local cQuery     := ""
	Local aRET       := {}
	Local _nCubag	 := 0
	Local _nVlrRes	 := 0
	Local _nPesTot	 := 0
	Local _nSerasa	 := 0
	Local nTot       := 0

	cQuery += " WITH EMB AS "+CR
	cQuery += " ( "+CR

	cQuery += " SELECT 	   "+CR
	cQuery += " SC5.C5_NUM "+CR
	cQuery += ' "PEDIDO",  '+CR

	cQuery += " (SELECT COUNT(*) QTDLINHAS FROM "+RetSqlName("CB8")+" CB8 WHERE CB8.D_E_L_E_T_=' ' AND CB8.CB8_FILIAL=CB7.CB7_FILIAL AND CB8.CB8_ORDSEP=CB7.CB7_ORDSEP) AS QTDLINHAS, "+CR
	cQuery += " (SELECT SUM(CB8_QTDORI) QTDPECAS  FROM "+RetSqlName("CB8")+" CB8 WHERE CB8.D_E_L_E_T_=' ' AND CB8.CB8_FILIAL=CB7.CB7_FILIAL AND CB8.CB8_ORDSEP=CB7.CB7_ORDSEP) AS QTDPECAS, "+CR
	cQuery += " (SELECT CB1_NOME NOMEEMB FROM "+RetSqlName("CB6")+" CB6 LEFT JOIN "+RetSqlName("CB1")+" CB1 ON CB1.CB1_FILIAL=CB6.CB6_FILIAL AND CB1.CB1_CODOPE=CB6.CB6_XOPERA WHERE CB1.D_E_L_E_T_=' ' AND CB6.D_E_L_E_T_=' ' AND CB7.CB7_FILIAL=CB6.CB6_FILIAL AND CB7.CB7_ORDSEP=CB6.CB6_XORDSE AND ROWNUM=1) AS EMBALADOR, "+CR
	cQuery += ' SA1.A1_XDTSERA '+CR
	cQuery += ' "XDTSERA",     '+CR  
	cQuery += " (SELECT DISTINCT CASE WHEN Count(PA1_DOC) > 0 THEN 'PARCIAL' ELSE 'TOTAL' END FROM "+RetSqlName("PA1")+" WHERE SubStr(PA1_DOC,1,6) = SC5.C5_NUM AND D_E_L_E_T_ = ' ') as TIPO, "+CR 
	cQuery += ' SC5.C5_ZDTCLI '+CR 
	cQuery += ' "ZDTCLI",  	  '+CR 

	cQuery += ' SC5.C5_XORDEM '+CR
	cQuery += ' "XORDEM",     '+CR 


	cQuery += " SC5.C5_FILIAL "+CR
	cQuery += ' "FILIAL",     '+CR
	cQuery += " SC5.C5_ZREFNF "+CR
	cQuery += ' "REFATUR",    '+CR 
	cQuery += " CB7.CB7_ORDSEP "+CR
	cQuery += ' "OS", '+CR

	cQuery += " CB7.CB7_DTEMIS "+CR
	cQuery += ' "DTEMIS", '+CR
	cQuery += " CB7.CB7_HREMIS "+CR
	cQuery += ' "HREMIS", '+CR

	cQuery += " NVL((SELECT TRIM(CB1.CB1_NOME) FROM  "+RetSqlName("CB1")+" CB1 "+CR
	cQuery += " WHERE CB1.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND CB1.CB1_FILIAL= '"+xFilial("CB1")+"'" +CR
	cQuery += " AND CB1.CB1_CODOPE  = CB7.CB7_XOPEXP), ' ') "+CR
	cQuery += ' "SEPARADOR", '+CR

	cQuery += " (SELECT MAX(CB6_XDTFIN || CB6_XHFIN || ':00') "+CR
	cQuery += " FROM "+RetSqlName("CB6")+" CB6 "+CR
	cQuery += " WHERE CB6.D_E_L_E_T_ = ' '  "+CR
	cQuery += " AND CB6_PEDIDO = SC5.C5_NUM "+CR
	cQuery += " AND CB6.CB6_FILIAL = '"+xFilial("CB6")+"'" +CR
	cQuery += " AND CB6.CB6_XORDSE = CB7.CB7_ORDSEP) "+CR
	cQuery += ' "DTHRFIME", '+CR
	
	cQuery += " (SELECT MAX(CB8_XDTFIM || CB8_XHFIM || ':00') "+CR
	cQuery += " FROM "+RetSqlName("CB8")+" CB8 "+CR
	cQuery += " WHERE CB8.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND CB8.CB8_FILIAL = CB7.CB7_FILIAL  "+CR
	cQuery += " AND CB8.CB8_ORDSEP = CB7.CB7_ORDSEP) "+CR
	cQuery += ' "DTHRFIMS", '+CR

	cQuery += " (SELECT COUNT(CB6_PEDIDO) "+CR
	cQuery += " FROM "+RetSqlName("CB6")+" CB6 "+CR
	cQuery += " WHERE CB6.D_E_L_E_T_ = ' '  "+CR
	cQuery += " AND CB6_PEDIDO = SC5.C5_NUM "+CR
	cQuery += " AND CB6.CB6_FILIAL = '"+xFilial("CB6")+"'" +CR
	cQuery += " AND CB6.CB6_XORDSE = CB7.CB7_ORDSEP) "+CR
	cQuery += ' "VOLUME", '+CR
	cQuery += " CASE WHEN CB7.CB7_STATUS = '0' THEN '0-Inicio' ELSE    "+CR
	cQuery += " CASE WHEN CB7.CB7_STATUS = '1' THEN '1-Separando' ELSE "+CR
	cQuery += " CASE WHEN CB7.CB7_STATUS = '2' THEN '2-Sep.Final' ELSE "+CR
	cQuery += " CASE WHEN CB7.CB7_STATUS = '3' THEN '3-Embalando' ELSE "+CR
	cQuery += " CASE WHEN CB7.CB7_STATUS = '4' THEN '4-Emb.Final' ELSE "+CR
	cQuery += " CASE WHEN CB7.CB7_STATUS = '8' THEN '8-Embarcado' ELSE "+CR
	cQuery += " CASE WHEN CB7.CB7_STATUS = '9' THEN '9-Embarque Finalizado' ELSE 'SEM NUMERACAO' "+CR
	cQuery += " END END END END END END END "+CR
	cQuery += ' "STATUSX", '+CR
	cQuery += " SC5.C5_CLIENTE "+CR
	cQuery += ' "CLIENTE", '+CR

	cQuery += " SC5.C5_LOJACLI "+CR
	cQuery += ' "LOJA" , '+CR
	cQuery += " SC5.C5_XALERTF "+CR
	cQuery += ' "ALERTFAT" , '+CR
	cQuery += " SA1.A1_NOME  "+CR 
	cQuery += ' "NOME" , SA1.A1_XBLQFIN, '+CR
	cQuery += " SC5.C5_TRANSP "+CR
	cQuery += ' "COD.TRANSP", '+CR
	cQuery += " SC5.C5_TIPOCLI "+CR
	cQuery += ' "TIPOCLI" ,   '+CR
	cQuery += " SC5.C5_EMISSAO "+CR
	cQuery += ' "EMISSAO" ,  '+CR
	cQuery += " SC5.C5_VEND2 "+CR
	cQuery += ' "XVEND", '+CR
	cQuery += " NVL(SA4.A4_NOME,' ') "+CR
	cQuery += ' "TRANSP"  , '+CR
	cQuery += " SA3.A3_NOME "+CR
	cQuery += ' "NVEND"  ,  '+CR
	cQuery += " NVL((SELECT MAX(PD2_CODROM) FROM "+RetSqlName("PD2")+" PD2 "+CR
	cQuery += " WHERE PD2.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND PD2.PD2_NFS    = CB7.CB7_NOTA "+CR
	cQuery += " AND PD2.PD2_SERIES = CB7.CB7_SERIE "+CR
	cQuery += " AND PD2.PD2_CLIENT    = SC5.C5_CLIENTE "+CR
	cQuery += " AND PD2.PD2_LOJCLI = SC5.C5_LOJACLI "+CR
	cQuery += " AND PD2.PD2_FILIAL = '"+xFilial("PD2")+"' ),' ') "+CR
	cQuery += ' "ROMANEIO" , '+CR
	cQuery += " CB7.CB7_NOTA "+CR
	cQuery += ' "NF", '+CR
	cQuery += " nvl((SELECT "+CR
	cQuery += " SUBSTR( F2_EMISSAO,7,2)||'/'|| SUBSTR( F2_EMISSAO,5,2)||'/'|| SUBSTR( F2_EMISSAO,1,4) "+CR
	cQuery += " FROM "+RetSqlName("SF2")+"  SF2 "+CR
	cQuery += " WHERE SF2.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND SF2.F2_DOC   = CB7.CB7_NOTA "+CR
	cQuery += " AND SF2.F2_SERIE = CB7.CB7_SERIE "+CR
	cQuery += " AND SF2.F2_FILIAL = '"+xFilial("SF2")+"'),'  /  /    ') "+CR
	cQuery += ' "EMISSAONF", '+CR
	cQuery += " CASE WHEN SC5.C5_CONDPAG = '501' AND SC5.C5_XLIBAVI <> 'S' THEN 'Bloqueado à Vista' ELSE 'LIBERADO' END "+CR
	cQuery += ' "BLOQVISTA", '+CR
	cQuery += "  CASE WHEN SC5.C5_TRANSP = ' '   THEN 'Transportadora em Branco' ELSE 'LIBERADO' END "+CR
	cQuery += ' "BLOQTRANSP", '+CR
	cQuery += " CASE WHEN SC5.C5_XTIPO ='1' THEN 'RETIRA' ELSE 'ENTREGA' END "+CR
	cQuery += ' "ENTREGA", '+CR
	cQuery += " CASE WHEN SC5.C5_TPFRETE ='F' THEN 'FOB' ELSE 'CIF' END "+CR
	cQuery += ' "FRETE", '+CR
	cQuery += " SC5.C5_CONDPAG "+CR
	cQuery += ' "COND", '+CR
	cQuery += " (SELECT E4_DESCRI FROM "+RetSqlName("SE4")+"  SE4 "+CR
	cQuery += " WHERE E4_CODIGO = SC5.C5_CONDPAG "+CR
	cQuery += " AND SE4.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND SE4.E4_FILIAL = '"+xFilial("SE4")+"' ) "+CR
	cQuery += ' "DESCRI", '+CR
	cQuery += " (SELECT X5_DESCRI FROM "+RetSqlName("SX5")+"  SX5 " +CR
	cQuery += " WHERE SX5.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND SX5.X5_TABELA = 'SX' " +CR
	cQuery += " AND SX5.X5_CHAVE = "+CR
	cQuery += " (SELECT DISTINCT SC6.C6_OPER FROM "+RetSqlName("SC6")+"  SC6 " +CR
	cQuery += " WHERE  C6_NUM = SC5.C5_NUM "+CR
	cQuery += " AND C6_FILIAL = SC5.C5_FILIAL "+CR
	cQuery += " AND SC6.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND SC6.C6_OPER <> '') "+CR
	cQuery += " AND SX5.X5_FILIAL = '"+xFilial("SX5")+"' ) "+CR
	cQuery += ' "VENDA", '+CR
	//valor total da nota
	cQuery += " nvl((SELECT "+CR
	cQuery += " F2_VALBRUT "+CR
	cQuery += " FROM "+RetSqlName("SF2")+"  SF2 "+CR
	cQuery += " WHERE SF2.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND SF2.F2_DOC   = CB7.CB7_NOTA "+CR
	cQuery += " AND SF2.F2_SERIE = CB7.CB7_SERIE "+CR
	cQuery += " AND SF2.F2_FILIAL = '"+xFilial("SF2")+"'),0) "+CR
	cQuery += ' "TOTAL" '+CR
	//*******************************************************************************
	cQuery += ' ,NVL((SELECT SUM(C6_ZVALLIQ/C6_QTDVEN*CB8_QTDORI) RESLIQ '+CR
	cQuery += " FROM "+RetSqlName("CB8")+"  CB8 "+CR
	cQuery += " LEFT JOIN( SELECT * FROM "+RetSqlName("SC6")+" ) SC6 "+CR
	cQuery += ' ON CB8_FILIAL=C6_FILIAL '+CR
	cQuery += ' AND CB8_PEDIDO=C6_NUM '+CR
	cQuery += ' AND CB8_ITEM=C6_ITEM '+CR
	cQuery += ' AND C6_PRODUTO=CB8_PROD '+CR
	cQuery += " WHERE CB8.D_E_L_E_T_= ' ' "+CR
	cQuery += " AND SC6.D_E_L_E_T_= ' ' "+CR
	cQuery += ' AND CB8_ORDSEP = CB7.CB7_ORDSEP '+CR
	cQuery += ' AND CB8_FILIAL = CB7.CB7_FILIAL),0) "RESLIQ" '+CR

	cQuery += " ,NVL((SELECT SUM (CB6.CB6_XPESO) "+CR
	cQuery += " FROM "+RetSqlName("CB6")+"  CB6 " +CR
	cQuery += " WHERE CB6.D_E_L_E_T_= ' ' "+CR
	cQuery += ' AND CB6.CB6_XORDSE = CB7.CB7_ORDSEP '+CR
	cQuery += ' AND CB6.CB6_FILIAL = CB7.CB7_FILIAL ),0) "XPESO" '+CR

	cQuery += " ,NVL((SELECT SUM (CB3.CB3_VOLUME) "+CR
	cQuery += " FROM "+RetSqlName("CB6")+"  CB6 "+CR
	cQuery += " INNER JOIN( SELECT * FROM "+RetSqlName("CB3")+" ) CB3 "+CR
	cQuery += ' ON CB3_FILIAL = CB6.CB6_FILIAL '+CR
	cQuery += ' AND CB3.CB3_CODEMB = CB6.CB6_TIPVOL '+CR
	cQuery += " AND CB3.D_E_L_E_T_= ' ' "+CR

	cQuery += " WHERE CB6.D_E_L_E_T_= ' ' "+CR
	cQuery += ' AND CB6.CB6_XORDSE = CB7.CB7_ORDSEP '+CR
	cQuery += ' AND CB6.CB6_FILIAL = CB7.CB7_FILIAL ),0) "XCUBA" '+CR

	cQuery += " FROM "+RetSqlName("SC5")+" SC5 "+CR

	cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("CB7")+" )CB7 "+CR
	cQuery += " ON CB7.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND CB7_PEDIDO = SC5.C5_NUM "+CR
	cQuery += " AND CB7_ORDSEP  BETWEEN '"+ MV_PAR05 +"' AND '"+ MV_PAR06 +"' "+CR
	cQuery += " AND CB7.CB7_FILIAL = '"+xFilial("CB7")+"'"+CR
	
	cQuery += " AND CB7.CB7_DTEMIS BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "+CR

	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "+CR
	cQuery += " ON SA1.D_E_L_E_T_   = ' ' "+CR
	cQuery += " AND SA1.A1_COD = SC5.C5_CLIENTE "+CR
	cQuery += " AND SA1.A1_LOJA = SC5.C5_LOJACLI "+CR
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"+CR

	cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SA3")+" )SA3 "+CR
	cQuery += " ON SA3.D_E_L_E_T_   = ' ' "+CR
	cQuery += " AND SA3.A3_COD = SC5.C5_VEND2 "+CR

	cQuery += " left JOIN(SELECT * FROM "+RetSqlName("SA4")+" )SA4 "+CR
	cQuery += " ON SA4.D_E_L_E_T_   = ' ' "+CR
	cQuery += " AND SA4.A4_COD = SC5.C5_TRANSP "+CR
	cQuery += " AND SA4.A4_FILIAL = '"+xFilial("SA4")+"'"+CR

	cQuery += " WHERE SC5.D_E_L_E_T_ = ' ' "+CR
	cQuery += " AND SC5.C5_FILIAL = '"+xFilial("SC5")+"'"+CR
	
	cQuery += " AND SC5.C5_NUM  BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"' "+CR
	cQuery += " ORDER BY SC5.C5_NUM "+CR

	cQuery += " ) "+CR

	cQuery += " SELECT EMB.*, "+CR
	cQuery += " (SELECT MAX(ZA_DATA || ZA_HORA) FROM " + RetSqlName("SZA") + " SZA "+CR
	cQuery += " WHERE ZA_FILIAL = '" + xFilial("SZA") + "' "+CR
	cQuery += " AND ZA_FILIAL = EMB.FILIAL "+CR
	cQuery += " AND ZA_CLIENTE = EMB.CLIENTE "+CR
	cQuery += " AND ZA_LOJA = EMB.LOJA "+CR
	cQuery += " AND ZA_PEDIDO = EMB.PEDIDO "+CR
	cQuery += " AND SZA.D_E_L_E_T_ = ' ' "+CR
	cQuery += " GROUP BY ZA_FILIAL, ZA_PEDIDO "+CR
	cQuery += " ) AS DTHRLIBF "+CR
	
	cQuery += " ,nvl((SELECT " +CR
	cQuery += " SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_VALICM-D2_DIFAL-D2_ICMSCOM) "+CR 
	cQuery += " VALOR " +CR
	cQuery += " FROM "+RetSqlName("SD2")+"  SD2 "+CR 
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' ' " +CR
	cQuery += " AND SD2.D2_DOC   = NF  "  +CR
	cQuery += " AND SD2.D2_FILIAL = '02' "+CR
	cQuery += " ),0) " +CR
	cQuery += " VALIQ " +CR

	cQuery += " FROM EMB"+CR

	//Memowrite("C:\Temp\RSTFAT13.txt", cQuery)

	If Select(cTabTMP) > 0
		(cTabTMP)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery), (cTabTMP) )

	(cTabTMP)->( dbEval( {|| nTot++ },,{|| !Eof() }) )

	ProcRegua( nTot )

	dbGotop()
	While (cTabTMP)->(  !Eof() )
		IncProc()
		If  Mv_Par07 = 1 .And.  !(Empty(Alltrim((cTabTMP)->NF))) .Or. Mv_Par07 = 2 .And.  Empty(Alltrim((cTabTMP)->NF)) .Or. Mv_Par07 = 3
			_nCubag	 := (cTabTMP)->XCUBA
			_nPesTot := (cTabTMP)->XPESO
			_nVlrRes := (cTabTMP)->RESLIQ

			nLin := aScan(aRET, { |X| X[43]==(cTabTMP)->PEDIDO+(cTabTMP)->OS })
			if nLin==0
			   aAdd(aRET, Array(43))
			   nLin := Len(aRET)
			Endif
			 
			aRET[nLin][01]	:=	(cTabTMP)->PEDIDO+(cTabTMP)->OS
			aRET[nLin][02]	:=	(cTabTMP)->PEDIDO
			aRET[nLin][03]	:=	(cTabTMP)->OS
			aRET[nLin][04]	:=	(cTabTMP)->SEPARADOR
			aRET[nLin][05]	:=	(cTabTMP)->VOLUME
			aRET[nLin][06]	:=	(cTabTMP)->STATUSX
			aRET[nLin][07]	:= 	(cTabTMP)->TIPO
			aRET[nLin][08]	:=	(cTabTMP)->CLIENTE
			aRET[nLin][09]	:=	(cTabTMP)->LOJA
			aRET[nLin][10]	:=	(cTabTMP)->NOME				
			aRET[nLin][11]	:= 	DTOC(STOD((cTabTMP)->EMISSAO))

			//F=Cons.Final;L=Prod.Rural;R=Revendedor;S=Solidario;X=Exportacion/Importacion

			If (cTabTMP)->TIPOCLI = "X"
				aRET[nLin][12] :=  "EXPORTACAO"
			ElseIf	(cTabTMP)->TIPOCLI = "F"
				aRET[nLin][12] := "Cons.Final"
			ElseIf  (cTabTMP)->TIPOCLI = "L"
				aRET[nLin][12] := "Prod.Rural"
			ElseIf (cTabTMP)->TIPOCLI = "R"
				aRET[nLin][12] := "Revendedor"
			ElseIf   (cTabTMP)->TIPOCLI = "S"
				aRET[nLin][12] := "Solidario"
			EndIf

			aRET[nLin][13]	:= 	(cTabTMP)->TRANSP
			aRET[nLin][14]	:=	(cTabTMP)->ROMANEIO
			aRET[nLin][15]	:=	(cTabTMP)->NF
			aRET[nLin][16]	:=	(cTabTMP)->EMISSAONF

			If "LIBERADO" $ (cTabTMP)->BLOQVISTA .And. "LIBERADO" $ (cTabTMP)->BLOQTRANSP
				aRET[nLin][17]	:=  "LIBERADO"
			ElseIf !("LIBERADO" $ (cTabTMP)->BLOQVISTA) .And. "LIBERADO" $ (cTabTMP)->BLOQTRANSP
				aRET[nLin][17]	:=  (cTabTMP)->BLOQVISTA
			ElseIf "LIBERADO" $ (cTabTMP)->BLOQVISTA .And. !("LIBERADO" $ (cTabTMP)->BLOQTRANSP)
				aRET[nLin][17]	:=  (cTabTMP)->BLOQTRANSP
			EndIf

			aRET[nLin][18]	:= IIf((cTabTMP)->REFATUR == "1","S","N")
			aRET[nLin][19]	:=	(cTabTMP)->ENTREGA
			aRET[nLin][20]	:= 	(cTabTMP)->FRETE
			aRET[nLin][21]	:= 	(cTabTMP)->NVEND
			aRET[nLin][22]	:= 	_nCubag

			If (cTabTMP)->TOTAL > 0
				aRET[nLin][23]	:=	0
			Else
				aRET[nLin][23]	:=	_nVlrRes
			EndIf

			aRET[nLin][24]	:= (cTabTMP)->TOTAL
			aRET[nLin][25]	:=	_nPesTot
			aRET[nLin][26]	:= (cTabTMP)->QTDLINHAS
			aRET[nLin][27]	:= (cTabTMP)->QTDPECAS
			aRET[nLin][28]	:= (cTabTMP)->EMBALADOR
			aRET[nLin][29]	:= (cTabTMP)->ALERTFAT

			If (cTabTMP)->A1_XBLQFIN == "1"
				aRET[nLin][30] := "Cliente bloqueado Fin."
			Else
				aRET[nLin][30] := ' '
			EndIf

			_nSerasa    := 	dDataBase - stod((cTabTMP)->XDTSERA) 

			If _nSerasa > 90
				aRET[nLin][31]	:= 	"Bloqueado"
			Else
				aRET[nLin][31]	:= 	"Liberado"
			EndIf 			
			
			aRET[nLin][32]	:= 	StoD((cTabTMP)->DTEMIS)
			aRET[nLin][33]	:= 	Alltrim((cTabTMP)->HREMIS)+":00"
			aRET[nLin][34]	:= 	StoD(Substr((cTabTMP)->DTHRFIME,01,08))
			aRET[nLin][35]	:= 	Substr((cTabTMP)->DTHRFIME,09,08)
			aRET[nLin][36]	:= 	StoD(Substr((cTabTMP)->DTHRLIBF,01,08))
			aRET[nLin][37]	:= 	Substr((cTabTMP)->DTHRLIBF,09,08)
			aRET[nLin][38]	:= 	Stod((cTabTMP)->ZDTCLI)
			aRET[nLin][39]	:= 	(cTabTMP)->XORDEM



			aRET[nLin][40] := (cTabTMP)->VALIQ 			
			aRET[nLin][41]	:= 	StoD(Substr((cTabTMP)->DTHRFIMS,01,08))
			aRET[nLin][42]	:= 	Substr((cTabTMP)->DTHRFIMS,09,08)
			aRET[nLin][43]    := aRET[nLin][1]+aRET[nLin][2]
			
			_nCubag := _nVlrRes := _nPesTot := 0

		EndIf

		(cTabTMP)->( dbSkip() )
	EndDo

Return(aRET)



/*/{Protheus.doc} MntCabec
    (long_desCRLFiption)
    Rotina para abrir parâmetro
    @type  Function
    @author user
    Valdemir Rabelo
    @since 15/04/2020
    @version version
    @param 
/*/
Static Function MntCabec()
	Local aRET := {}
	aRET :=  {{'Pedido+OS','PEDOS'},;
			  {'Pedido','PEDIDO'},;
	          {'Os','OS'},;
			  {'Separador','SEPARADOR'},;
			  {'Volumes','VOLUME'},;
			  {'Status','STATUSX'},;
			  {'Tipo','TIPO'},;
			  {'Cliente','CLIENTE'},;
			  {'Loja','LOJA'},;
			  {'Nome','NOME'},;
			  {'Data Emissao','EMISSAO'},;
			  {'TipoCli','TIPOCLI'},;
			  {'Transp','TRANSP'},;
			  {'Romaneio','ROMANEIO'},;
			  {'Nf','NF'},;
			  {'Emissao NF','EMISSAONF'},;
			  {'Bloq','BLOQ'},;
			  {'Refaturamento Blq?','REFATUR'},;
			  {'Entrega','ENTREGA'},;
			  {'Frete','FRETE'},;
			  {'Vendedor','NVEND'},;
			  {'Cubagem','XCUBA'},;
			  {'Vlr Res Liq','RESLIQ'},;
			  {'Vlr Bruto NF','TOTAL'},;
			  {'Peso total','XPESO'},;
			  {'Qtde Linhas','QTDLINHAS'},;
			  {'Qtde Pecas','QTDPECAS'},;
			  {'Embalador','EMBALADOR'},;
			  {'Alerta Fatur','ALERTFAT'},;
			  {'Alerta Finan','ALERTFIN'},;                          // Deve ser tratado na query
			  {'Status Serasa','STATSERA'},;						 // Deve ser tratado na query
			  {'Dt Emissao OS','DTEMIS'},;
			  {'Hr Emissao OS','HREMIS'},;
			  {'Dt Final Emb','DTHRFIME'},;
			  {'Hr Final Emb','DTHRFIME'},;
			  {'Dt Lib Fin','DTHRFIMS'},;
			  {'Hr Lib Fin','DTHRFIMS'},;
			  {'Dt Cliente','DTHRLIBF'},;
			  {'Ord Compra','XORDEM'};
			  }

Return aRET


/*/{Protheus.doc} AtuTela
    (long_desCRLFiption)
    Rotina para atualizar dados do grid
    @type  Function
    @author user
    Valdemir Rabelo
    @since 15/04/2020
    @version version
    @param 
/*/
Static Function AtuTela(oLbx, aColunas)
	oLbx:SetArray( aColunas )
	oLbx:bLine := {|| { ;
					aColunas[oLbx:nAt,1],;
					aColunas[oLbx:nAt,2],;
					aColunas[oLbx:nAt,3],;
					aColunas[oLbx:nAt,4],;
					aColunas[oLbx:nAt,5],;
					aColunas[oLbx:nAt,6],;
					aColunas[oLbx:nAt,7],;
					aColunas[oLbx:nAt,8],;
					aColunas[oLbx:nAt,9],;
					aColunas[oLbx:nAt,10],;
					aColunas[oLbx:nAt,11],;
					aColunas[oLbx:nAt,12],;
					aColunas[oLbx:nAt,13],;
					aColunas[oLbx:nAt,14],;
					aColunas[oLbx:nAt,15],;
					aColunas[oLbx:nAt,16],;
					aColunas[oLbx:nAt,17],;
					aColunas[oLbx:nAt,18],;
					aColunas[oLbx:nAt,19],;
					aColunas[oLbx:nAt,20],;
					aColunas[oLbx:nAt,21],;
					aColunas[oLbx:nAt,22],;
					aColunas[oLbx:nAt,23],;
					aColunas[oLbx:nAt,24],;
					aColunas[oLbx:nAt,25],;
					aColunas[oLbx:nAt,26],;
					aColunas[oLbx:nAt,27],;
					aColunas[oLbx:nAt,28],;
					aColunas[oLbx:nAt,29],;
					aColunas[oLbx:nAt,30],;
					aColunas[oLbx:nAt,31],;
					aColunas[oLbx:nAt,32],;
					aColunas[oLbx:nAt,33],;
					aColunas[oLbx:nAt,34],;
					aColunas[oLbx:nAt,35],;
					aColunas[oLbx:nAt,36],;
					aColunas[oLbx:nAt,37],;
					aColunas[oLbx:nAt,38],;
					aColunas[oLbx:nAt,39]}}
	oLbx:Refresh()
	oLbx:SetFocus()
Return	


/*/{Protheus.doc} LocReg
    (long_desCRLFiption)
    Rotina para localizar registro
    @type  Function
    @author user
    Valdemir Rabelo
    @since 15/04/2020
    @version version
    @param 
/*/
Static Function LocReg(oCBO, cConteudo, oLbx)
	Local nPos := 0

	oLbx:nAt := 1
	If (oCBO:nAT == 4)
		nPos := aScan(aColunas, { |x|  x[11] == dtoc(cConteudo) } )
	ElseIf (oCBO:nAT >= 1) .and. (oCBO:nAT <= 3) 
		nPos := aScan(aColunas, { |x| Alltrim(x[oCBO:nAT]) == Alltrim(cConteudo)} )
	Else
 	    nPos := aScan(aColunas, { |x| x[oCBO:nAT] $ Alltrim(cConteudo)} )
	EndIf
	If nPos > 0
		oLbx:nAT := nPos
	EndIf
	oLbx:SetFocus()

Return

/*/{Protheus.doc} VLDCONT
    (long_desCRLFiption)
    Rotina para validar campo de pesquisa
    @type  Function
    @author user
    Valdemir Rabelo
    @since 15/04/2020
    @version version
    @param 
/*/
Static Function VLDCONT(oBTProc)
	Local lRet := (!Empty(cConteudo))
	If lRet
		oBTProc:SetFocus()
	Else
		oLbx:SetFocus()
		lRet := .T.
	EndIf
Return lRet

/*/{Protheus.doc} SelChange
    (long_desCRLFiption)
    Rotina para valida seleção do combo
    @type  Function
    @author user
    Valdemir Rabelo
    @since 15/04/2020
    @version version
    @param 
/*/
Static Function SelChange(oCBO, nCBO, aCBO, oDlg, oBTProc,oLbx)
	Local cReadVar
	Local aArea := GetArea()
	// Ordena conforme sele?o
	if oCBO:nAT == 4
		aSort(aColunas,,,{ |x,y| x[11] < y[11]} )
	else 
		aSort(aColunas,,,{ |x,y| x[oCBO:nAT] < y[oCBO:nAT]} )
	endif
	if oLbx != nil
		oLbx:nAt := 1
		oLbx:Refresh()
	Endif

	If (oCBO:nAT >= 1) .and. (oCBO:nAT <= 3) 
		cConteudo := Space(12)
		cPict    := "@!"
	ElseIf (oCBO:nAT == 4) 
		cConteudo := CtoD(Space(8) )
		cPict     := "@D 99/99/9999"
	ElseIf (oCBO:nAT == 5) 
		cConteudo := Space(10)
	EndIf

	oConteudo:Refresh()
	oConteudo:SetFocus()

	RestArea( aArea )

Return


/*/{Protheus.doc} GeraPlan
    (long_desCRLFiption)
    Rotina para gerar planilha
    @type  Function
    @author user
    Valdemir Rabelo
    @since 15/04/2020
    @version version
    @param 
/*/
Static Function GeraPlan(oLbx)
	Local aCabec     := MntCabec()
	Local aTipo      := {"C","C","C","C","C","C","C","C","C","C","D","C","C","C","C","D","C","C","C","C","C","N","N","N","N","N","N","C","C","C","C","D","C","D","C","D","C","D","C","D","C"}
	Local _aCols     := {}
	Local _aTMP      := {}
	Local nL         := 1
	Local aColunm    := aClone(aColunas)
	Local _aCab      := {}
	Local nTotCol    := 0
	Local nC

	aEval(aCabec, {|X| aAdd(_aCab, X[1]) })
	nTotCol := Len(_aCab)
	For nL := 1 to Len(aColunm)
		_aTMP := aColunm[nL]
		For nC := Len(aColunm[nL]) to 1 Step-1
		    if nC > nTotCol
			   aDel(_aTMP, nC)			   
			Endif
		Next
		aSize(_aTMP, Len(_aCab))
		if _aTMP[3] != Nil 
		   aAdd(_aCols, _aTMP)
		endif 
		_aTMP := {}
	Next

	IF Len(_aCols) > 0
		//StaticCall (STFSLIB, ExpotMsExcel, _aCab, _aCols, aTipo, cTitulo)
		u_ExpotMsExcel(_aCab, _aCols, aTipo, cTitulo)
	Else
		FWMsgrun(,{|| sleep(3000) },"Atenção!","Não é possível gerar planilha sem registros") 
	Endif

	AtuTela(oLbx, aColunas)

Return

#include 'protheus.ch'
#include 'parmtype.ch'

User Function DADOSLOG()

	Private cPergx		:= "DADOSLOG1"
	Private cPath			:=	"C:\TEMP"
	Private cArq			:=	"DADOSLOG_"+Dtos(dDataBase)+"_"+StrTran(TIME(),":","")	+".xls"
	Private cCaminho	:=	""

	U_STPutSx1( cPergx, "01","Produto de:	"	,"MV_PAR01","mv_ch1","C",TamSX3("B1_COD")[1]		,0,"G",,"SB1","")
	U_STPutSx1( cPergx, "02","Produto ate:	"	,"MV_PAR02","mv_ch2","C",TamSX3("B1_COD")[1]		,0,"G",,"SB1","")
	U_STPutSx1( cPergx, "03","Grupo de:	"		,"MV_PAR03","mv_ch3","C",TamSX3("B1_GRUPO")[1]	,0,"G",,"SBM","")
	U_STPutSx1( cPergx, "04","Grupo ate:	"	,"MV_PAR04","mv_ch4","C",TamSX3("B1_GRUPO")[1]	,0,"G",,"SBM","")

	If !Pergunte(cPergx,.T.)
		Return()
	EndIf

	If !ExistDir(cPath)
		MakeDir(cPath)
	EndIf

	cPath:= cGetFile("Arquivos xls  (*.xls)  | *.xls  "," ",1,"C:\TEMP",.T.,GETF_LOCALHARD+GETF_RETDIRECTORY ,.F.,.T.)

	If Empty(cPath)
		msgStop('Diretório incorreto!!!','Erro')
		Return()
	EndIf

	cCaminho	:=	cPath+"\"+cArq

	MsgRun("Carregando dados...","Processando....",{||DADOSLOG1()})

Return()

Static Function DADOSLOG1()

	Local cTop01		:=	"SQL01"
	Local cHora			:= StrTran( Time(), ":", "" )
	Local cSheet1		:=	"Detalhes"
	Local cTable		:=	"DADOS LOGÍSTICOS"
	Local oExcel		:=	FWMSEXCEL():New()	

	oExcel:AddworkSheet(cSheet1)

	oExcel:AddTable (cSheet1,cTable)
	oExcel:AddColumn(cSheet1,cTable,"Código"														,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Descricao"													,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Class Prod"													,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Tipo"															,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Grupo"															,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Código Barras"											,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Bloqueado"													,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Desativado"													,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Altura/Comprimento (mm)"						,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Largura (mm)	"											,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Profundidade/Espessura (mm)"					,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Peso Bruto (Kg)"											,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Código Barras EAN141"								,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Descrição Caixa EAN141"							,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Código Caixa EAN141"								,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Quantidade EAN141"									,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Altura/Comprimento EAN141 (m)"			,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Largura EAN141 (m)"									,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Profundidade/Espessura EAN141 (m)"		,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Volume EAN141 (m3)"								,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Peso EAN141 (Kg)"										,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Código Barras EAN142 "								,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Descrição Caixa EAN142 "							,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Código Caixa EAN142"								,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Quantidade EAN142"									,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Altura/Comprimento EAN142 (m)"			,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Largura EAN142 (m)"									,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Profundidade/Espessura EAN142 (m)"		,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Volume EAN142 (m3)"								,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Peso EAN142 (Kg)"										,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Curva FMR"													,1,1)
	oExcel:AddColumn(cSheet1,cTable,"Curva ABC"													,1,1)

	cQuery	:=		" 	SELECT B1_COD	COD_BARRAS, 	" + CRLF  
	cQuery+= 	" 	B1_DESC			DESCRICAO,  			" + CRLF  
	cQuery+= 	" 	B1_CLAPROD		CLASS_PROD,  " + CRLF  
	cQuery+= 	" 	B1_TIPO			TIPO,  " + CRLF  
	cQuery+= 	" 	B1_GRUPO		GRUPO,  " + CRLF  
	cQuery+= 	" 	B1_CODBAR		COD_BAR,  " + CRLF  
	cQuery+= 	" 	CASE WHEN B1_MSBLQL = '1' THEN 'SIM' ELSE 'NAO' END	BLOQUEADO,  " + CRLF  
	cQuery+= 	" 	CASE WHEN B1_XDESAT = '2' THEN 'SIM' ELSE 'NAO' END DESATIVADO,  " + CRLF  
	cQuery+= 	" 	B5_COMPR		ALT_COMP,  " + CRLF  
	cQuery+= 	" 	B5_LARG			LARGURA,  " + CRLF  
	cQuery+= 	" 	B5_ESPESS		PROF_ESP,  " + CRLF  
	cQuery+= 	" 	B1_PESBRU		BRUTO,  " + CRLF  
	cQuery+= 	" 	'1' || SUBSTR(B1_CODBAR,1,12)	EAN141,  " + CRLF  
	cQuery+= 	" 	CB3C.CB3_DESCRI DESC_141,  " + CRLF  
	cQuery+= 	" 	CB3C.CB3_CODEMB COD_141,  " + CRLF  
	cQuery+= 	" 	B5_EAN141		QTD_141,  " + CRLF  
	cQuery+= 	" 	CB3C.CB3_ALTURA ALT_141,  " + CRLF  
	cQuery+= 	" 	CB3C.CB3_LARGUR LARG_141,  " + CRLF  
	cQuery+= 	" 	CB3C.CB3_PROFUN PROF_141,  " + CRLF  
	cQuery+= 	" 	ROUND(CB3C.CB3_ALTURA*CB3C.CB3_LARGUR*CB3C.CB3_PROFUN,4) VOL_141,  " + CRLF  
	cQuery+= 	" 	ROUND((B1_PESBRU*B5_EAN141)+CB3C.CB3_PESO,4) PESO_141,  " + CRLF  
	cQuery+= 	" 	'2' || SUBSTR(B1_CODBAR,1,12)	EAN142,  " + CRLF  
	cQuery+= 	" 	CB3M.CB3_DESCRI DESCRI_142,  " + CRLF  
	cQuery+= 	" 	CB3M.CB3_CODEMB EMB_142,  " + CRLF  
	cQuery+= 	" 	B5_EAN142		QTD_142,  " + CRLF  
	cQuery+= 	" 	CB3M.CB3_XMTRAL ALT_142,  " + CRLF  
	cQuery+= 	" 	CB3M.CB3_XMTRLA LARG_142,  " + CRLF  
	cQuery+= 	" 	CB3M.CB3_XMTRPR PROFESP_142,  " + CRLF  
	cQuery+= 	" 	ROUND(CB3M.CB3_XMTRAL*CB3M.CB3_XMTRLA*CB3M.CB3_XMTRPR,4) VOL_142,  " + CRLF  
	cQuery+= 	" 	B1_XFMR			CURVA_FMR,  " + CRLF  
	cQuery+= 	" 	B1_XABC			CURVA_ABC,  " + CRLF  

	cQuery+= 	" 	CB3M.CB3_PESO	PESO_M  " + CRLF  

	cQuery+= 	" 	FROM "+RetSqlName("SB1")+" SB1  " + CRLF  
	cQuery+= 	" 	LEFT JOIN "+RetSqlName("SB5")+" SB5 ON B5_FILIAL='"+xFilial("SB5")+"' AND B5_COD=B1_COD AND SB5.D_E_L_E_T_!='*'  " + CRLF  
	cQuery+= 	" 	LEFT JOIN "+RetSqlName("CB3")+" CB3C ON CB3C.CB3_FILIAL='"+xFilial("CB3")+"' AND CB3C.CB3_CODEMB = SB1.B1_XEMBCOL AND CB3C.D_E_L_E_T_!='*'  " + CRLF   
	cQuery+= 	" 	LEFT JOIN "+RetSqlName("CB3")+" CB3M ON CB3M.CB3_FILIAL='"+xFilial("CB3")+"' AND CB3M.CB3_CODEMB = SB1.B1_XEMBMAS AND CB3M.D_E_L_E_T_!='*'   " + CRLF  
	cQuery+= 	" 	WHERE B1_FILIAL='"+xFilial("SB1")+"' AND B1_TIPO='PA' AND B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " + CRLF  
	cQuery+= 	" 	AND B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND SB1.D_E_L_E_T_!='*'  " + CRLF  

	If !Empty(Select(cTop01))
		DbSelectArea(cTop01)
		(cTop01)->(dbCloseArea())
	Endif

	dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery),cTop01, .T., .T. )

	While (cTop01)->(!Eof())

		oExcel:AddRow(cSheet1,cTable,{;
		(cTop01)->COD_BARRAS,;
		(cTop01)->DESCRICAO,;
		(cTop01)->CLASS_PROD,;
		(cTop01)->TIPO,;
		(cTop01)->GRUPO,;
		(cTop01)->COD_BAR,;
		(cTop01)->BLOQUEADO,;
		(cTop01)->DESATIVADO,;
		(cTop01)->ALT_COMP,;
		(cTop01)->LARGURA,;
		(cTop01)->PROF_ESP,;
		(cTop01)->BRUTO,;
		(cTop01)->EAN141 + U_STEAN14F((cTop01)->EAN141),;
		(cTop01)->DESC_141,;
		(cTop01)->COD_141,;
		(cTop01)->QTD_141,;
		(cTop01)->ALT_141,;
		(cTop01)->LARG_141,;
		(cTop01)->PROF_141,;
		(cTop01)->VOL_141,;
		(cTop01)->PESO_141,;
		(cTop01)->EAN142 + U_STEAN14F((cTop01)->EAN142),;
		(cTop01)->DESCRI_142,;
		(cTop01)->EMB_142,;
		(cTop01)->QTD_142,;
		(cTop01)->ALT_142,;
		(cTop01)->LARG_142,;
		(cTop01)->PROFESP_142,;
		(cTop01)->VOL_142,;
		( ( (cTop01)->QTD_142 / (cTop01)->QTD_141) * (cTop01)->PESO_141 ) + (cTop01)->PESO_M,;		
		(cTop01)->CURVA_FMR,;
		(cTop01)->CURVA_ABC;
		})

		(cTop01)->(dbSkip())

	EndDo

	oExcel:Activate()
	oExcel:GetXMLFile(cCaminho)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cCaminho)
	oExcelApp:SetVisible(.T.)

Return()
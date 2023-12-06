/****************************************
Ação.........: Job de geração de:
.............: 1 - Pedidos de Compra na Distribuidora sem Pedido de Venda da Indústria amarrado
.............: 2 - Pedidos de Compra na Distribuidora com Pedido de Venda da Indústria mas com datas diferentes
.............: 3 - Registros na PA1 sem amarração na tabela Z96
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 30/11/2022
Chamado......: 20220429009114 - Oferta Logística
****************************************/
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#DEFINE CL CHR(13)+CHR(10)

USER FUNCTION MSTECK26()

PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'

	//// Pedidos de Compra na Distribuidora sem Pedido de Venda da Indústria amarrado
	MSTECK26A()

	//// Pedidos de Compra na Distribuidora com Pedido de Venda da Indústria mas com datas diferentes - GUARAREMA
	MSTECK26B()

	//// Pedidos de Compra na Distribuidora com Pedido de Venda da Indústria mas com datas diferentes - MANAUS
	MSTECK26C()

	//// Registros na PA1 sem amarração na tabela Z96
	MSTECK26D()

RESET ENVIRONMENT

RETURN

STATIC FUNCTION MSTECK26A()
LOCAL cMailTo := GETMV("MSTECK26",,"renato.oliveira@steck.com.br;leandro.godoy@steck.com.br")
LOCAL cCopia  := ""
LOCAL cAssun  := ""
LOCAL cAnexo  := ""
LOCAL cMsg  := ""

cQuery := "SELECT C7.C7_FORNECE,C7.C7_LOJA,C7.C7_NUM, C7.C7_EMISSAO FROM "+RetSqlName("SC7")+" C7 "
cQuery += "WHERE C7.D_E_L_E_T_ = ' ' "
cQuery += "AND C7.C7_FORNECE IN ('005866','005764') "
cQuery += "AND C7.C7_RESIDUO = ' ' "
cQuery += "AND C7.C7_PO_EIC = ' ' "
cQuery += "AND (C7.C7_QUANT - C7.C7_QUJE) > 0 "
cQuery += "AND C7.C7_XPEDVEN = ' ' AND C7.C7_XITEMPV = ' '  "
cQuery += "GROUP BY C7.C7_FORNECE,C7.C7_LOJA,C7.C7_NUM, C7.C7_EMISSAO "
cQuery += "ORDER BY C7.C7_FORNECE,C7.C7_LOJA,C7.C7_NUM, C7.C7_EMISSAO "
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC7', .F., .T.)
IF !EMPTY(TSC7->C7_NUM)

  cAssun  := "Pedidos de Compras sem Pedido de Venda na Indústria"
  cMsg := "<HTML> "
  cMsg += "<HEAD> "
  cMsg += "<TITLE> "
  cMsg += " <img src='https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42' width='300' height='49'> </td> "
  cMsg += "</TITLE> "
  cMsg += "</HEAD> "
  cMsg += " <br> <br>"

  cMsg += " <table width='1000' border='2'> "
  cMsg += " <tr> "
  cMsg += "   <td><div align='center'><font face='Verdana' size='1'><B>Pedidos de Compras sem Pedido de Venda na Indústria</B></font></div></td> "
  cMsg += " </tr> "
  cMsg += " </table> "

  //// Itens do Pedido de Venda
  cMsg += " <table width='1000' border='2' cellspacing='0' cellpadding='0'> "
  cMsg += "   <tr> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Indústria Destino</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Pedido de Compra na Distribuidora</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Emissão</font></div></td> "
  cMsg += "   </tr> "

  WHILE TSC7->(!EOF())
    cMsg += "   <tr> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+IIF(TSC7->C7_FORNECE = "005764", "GUARAREMA", "MANAUS")+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC7->C7_NUM+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+DTOC(STOD(TSC7->C7_EMISSAO))+"</font></div></td> "
    cMsg += "   </tr> "
    TSC7->(DBSKIP())
  ENDDO 
  cMsg += " </table> "
  cMsg += " <br> <br> "
  cMsg += "MSTECK26.PRW"
  cMsg += "</HTML> "

  //U_STMAILTES(cMailTo, cCopia, cAssun, cMsg, cAnexo)
  FRSendMail(cMailTo, cCopia, cAssun, cMsg, cAnexo )
ENDIF
TSC7->(DBCLOSEAREA())

RETURN

STATIC FUNCTION MSTECK26B()
LOCAL cMailTo := GETMV("MSTECK26",,"renato.oliveira@steck.com.br;leandro.godoy@steck.com.br")
LOCAL cCopia  := ""
LOCAL cAssun  := ""
LOCAL cAnexo  := ""
LOCAL cMsg  := ""

cQuery := "SELECT (CASE WHEN C7.C7_FORNECE = '005866' THEN 'MANAUS' ELSE 'GUARAREMA' END) INDUSTRIA,C7.C7_NUM, C7.C7_ITEM, "
cQuery += "C7.C7_XPEDVEN, C7.C7_XITEMPV, IND.C6_NUM, IND.C6_ITEM,C7.C7_XDTENT2, "
cQuery += "(CASE WHEN IND.C6_ZENTRE2 <> ' ' THEN IND.C6_ZENTRE2 ELSE IND.C6_ENTREG END) DATAPV "
cQuery += "FROM "+RetSqlName("SC7")+" C7  "
cQuery += "INNER JOIN "+AllTrim(GetMv("STALIASIND"))+".SC6030 IND ON IND.D_E_L_E_T_ = ' ' AND IND.C6_NUM = C7.C7_XPEDVEN AND IND.C6_ITEM = C7.C7_XITEMPV "
cQuery += "WHERE C7.D_E_L_E_T_ =  ' ' "
cQuery += "AND C7.C7_XDTENT2 <> (CASE WHEN IND.C6_ZENTRE2 <> ' ' THEN IND.C6_ZENTRE2 ELSE IND.C6_ENTREG END) "
cQuery += "AND C7.C7_FORNECE = '005866' "
cQuery += "AND C7.C7_RESIDUO = ' '  "
cQuery += "AND C7.C7_PO_EIC = ' '  "
cQuery += "AND (C7.C7_QUANT - C7.C7_QUJE) > 0 "
cQuery += "ORDER BY C7.C7_NUM,C7.C7_ITEM "
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC7', .F., .T.) 
IF !EMPTY(TSC7->C7_NUM)

  cAssun  := "Pedidos de Compra na Distribuidora com Pedido de Venda da Indústria mas com datas diferentes - GUARAREMA"
  cMsg := "<HTML> "
  cMsg += "<HEAD> "
  cMsg += "<TITLE> "
  cMsg += " <img src='https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42' width='300' height='49'> </td> "
  cMsg += "</TITLE> "
  cMsg += "</HEAD> "
  cMsg += " <br> <br>"

  cMsg += " <table width='1000' border='2'> "
  cMsg += " <tr> "
  cMsg += "   <td><div align='center'><font face='Verdana' size='1'><B>Pedidos de Compra na Distribuidora com Pedido de Venda da Indústria mas com datas diferentes - GUARAREMA</B></font></div></td> "
  cMsg += " </tr> "
  cMsg += " </table> "

  //// Itens do Pedido de Venda
  cMsg += " <table width='1000' border='2' cellspacing='0' cellpadding='0'> "
  cMsg += "   <tr> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PC. Número</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PC. Item</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PV. Número</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PV. Item</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PC. Data</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PV. Data</font></div></td> "
  cMsg += "   </tr> "

  WHILE TSC7->(!EOF())
    cMsg += "   <tr> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC7->C7_NUM+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC7->C7_ITEM+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC7->C6_NUM+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC7->C6_ITEM+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+DTOC(STOD(TSC7->C7_XDTENT2))+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+DTOC(STOD(TSC7->DATAPV))+"</font></div></td> "
    cMsg += "   </tr> "
    TSC7->(DBSKIP())
  ENDDO 
  cMsg += " </table> "
  cMsg += " <br> <br> "
  cMsg += "MSTECK26.PRW"
  cMsg += "</HTML> "

  //U_STMAILTES(cMailTo, cCopia, cAssun, cMsg, cAnexo)
  FRSendMail(cMailTo, cCopia, cAssun, cMsg, cAnexo )
ENDIF
TSC7->(DBCLOSEAREA())

RETURN

STATIC FUNCTION MSTECK26C()
LOCAL cMailTo := GETMV("MSTECK26",,"renato.oliveira@steck.com.br;leandro.godoy@steck.com.br")
LOCAL cCopia  := ""
LOCAL cAssun  := ""
LOCAL cAnexo  := ""
LOCAL cMsg  := ""

cQuery := "SELECT (CASE WHEN C7.C7_FORNECE = '005866' THEN 'MANAUS' ELSE 'GUARAREMA' END) INDUSTRIA,C7.C7_NUM, C7.C7_ITEM, "
cQuery += "C7.C7_XPEDVEN, C7.C7_XITEMPV, IND.C6_NUM, IND.C6_ITEM,C7.C7_XDTENT2, "
cQuery += "(CASE WHEN IND.C6_ZENTRE2 <> ' ' THEN IND.C6_ZENTRE2 ELSE IND.C6_ENTREG END) DATAPV "
cQuery += "FROM "+RetSqlName("SC7")+" C7  "
cQuery += "INNER JOIN "+AllTrim(GetMv("STALIASIND"))+".SC6010 IND ON IND.D_E_L_E_T_ = ' ' AND IND.C6_NUM = C7.C7_XPEDVEN AND IND.C6_ITEM = C7.C7_XITEMPV "
cQuery += "WHERE C7.D_E_L_E_T_ =  ' ' "
cQuery += "AND C7.C7_XDTENT2 <> (CASE WHEN IND.C6_ZENTRE2 <> ' ' THEN IND.C6_ZENTRE2 ELSE IND.C6_ENTREG END) "
cQuery += "AND C7.C7_FORNECE = '005866' "
cQuery += "AND C7.C7_RESIDUO = ' '  "
cQuery += "AND C7.C7_PO_EIC = ' '  "
cQuery += "AND (C7.C7_QUANT - C7.C7_QUJE) > 0 "
cQuery += "ORDER BY C7.C7_NUM,C7.C7_ITEM "
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC7', .F., .T.) 
IF !EMPTY(TSC7->C7_NUM)

  cAssun  := "Pedidos de Compra na Distribuidora com Pedido de Venda da Indústria mas com datas diferentes - MANAUS"
  cMsg := "<HTML> "
  cMsg += "<HEAD> "
  cMsg += "<TITLE> "
  cMsg += " <img src='https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42' width='300' height='49'> </td> "
  cMsg += "</TITLE> "
  cMsg += "</HEAD> "
  cMsg += " <br> <br>"

  cMsg += " <table width='1000' border='2'> "
  cMsg += " <tr> "
  cMsg += "   <td><div align='center'><font face='Verdana' size='1'><B>Pedidos de Compra na Distribuidora com Pedido de Venda da Indústria mas com datas diferentes - MANAUS</B></font></div></td> "
  cMsg += " </tr> "
  cMsg += " </table> "

  //// Itens do Pedido de Venda
  cMsg += " <table width='1000' border='2' cellspacing='0' cellpadding='0'> "
  cMsg += "   <tr> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PC. Número</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PC. Item</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PV. Número</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PV. Item</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PC. Data</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PV. Data</font></div></td> "
  cMsg += "   </tr> "

  WHILE TSC7->(!EOF())
    cMsg += "   <tr> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC7->C7_NUM+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC7->C7_ITEM+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC7->C6_NUM+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC7->C6_ITEM+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+DTOC(STOD(TSC7->C7_XDTENT2))+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+DTOC(STOD(TSC7->DATAPV))+"</font></div></td> "
    cMsg += "   </tr> "
    TSC7->(DBSKIP())
  ENDDO 
  cMsg += " </table> "
  cMsg += " <br> <br> "
  cMsg += "MSTECK26.PRW"
  cMsg += "</HTML> "

  //U_STMAILTES(cMailTo, cCopia, cAssun, cMsg, cAnexo)
  FRSendMail(cMailTo, cCopia, cAssun, cMsg, cAnexo )
ENDIF
TSC7->(DBCLOSEAREA())

RETURN


STATIC FUNCTION MSTECK26D()
LOCAL cMailTo := GETMV("MSTECK26",,"renato.oliveira@steck.com.br;leandro.godoy@steck.com.br")
LOCAL cCopia  := ""
LOCAL cAssun  := ""
LOCAL cAnexo  := ""
LOCAL cMsg  := ""

cQuery := "SELECT PA1.PA1_DOC, PA1.PA1_CODPRO,PA1.PA1_SALDO, C6.C6_NUM, C6.C6_ITEM, NVL(Z96.Z96_PA1DOC, ' ') Z96_PA1DOC, C5.C5_EMISSAO FROM "+RetSqlName("PA1")+" PA1 
cQuery += "INNER JOIN "+RetSqlName("SC6")+" C6 ON C6.D_E_L_E_T_ = ' ' AND C6.C6_NUM||C6.C6_ITEM = PA1.PA1_DOC AND C6.C6_BLQ <> 'R' AND (C6.C6_QTDVEN - C6.C6_QTDENT) > 0 "
cQuery += "INNER JOIN "+RetSqlName("SC5")+" C5 ON C5.D_E_L_E_T_ = ' ' AND C5.C5_NUM = C6.C6_NUM "
cQuery += "LEFT JOIN Z96110 Z96 ON Z96.D_E_L_E_T_ = ' ' AND Z96.Z96_PA1DOC = C6.C6_NUM||C6.C6_ITEM "
cQuery += "WHERE PA1.D_E_L_E_T_ = ' ' "
cQuery += "AND NVL(Z96.Z96_PA1DOC, ' ') = ' ' "
cQuery += "ORDER BY PA1.PA1_DOC "
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TPA1', .F., .T.) 
IF !EMPTY(TPA1->PA1_DOC)

  cAssun  := "Registros na PA1 sem amarração na tabela Z96"
  cMsg := "<HTML> "
  cMsg += "<HEAD> "
  cMsg += "<TITLE> "
  cMsg += " <img src='https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42' width='300' height='49'> </td> "
  cMsg += "</TITLE> "
  cMsg += "</HEAD> "
  cMsg += " <br> <br>"

  cMsg += " <table width='1000' border='2'> "
  cMsg += " <tr> "
  cMsg += "   <td><div align='center'><font face='Verdana' size='1'><B>Registros na PA1 sem amarração na tabela Z96</B></font></div></td> "
  cMsg += " </tr> "
  cMsg += " </table> "

  //// Itens do Pedido de Venda
  cMsg += " <table width='1000' border='2' cellspacing='0' cellpadding='0'> "
  cMsg += "   <tr> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Código PA1</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Produto</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Saldo PA1</font></div></td> "
  cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Emissão Pedido</font></div></td> "
  cMsg += "   </tr> "

  WHILE TPA1->(!EOF())
    cMsg += "   <tr> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TPA1->PA1_DOC+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TPA1->PA1_CODPRO+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TRANSFORM(TPA1->PA1_SALDO,"@E 999,999,99")+"</font></div></td> "
    cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+DTOC(STOD(TPA1->C5_EMISSAO))+"</font></div></td> "
    cMsg += "   </tr> "
    TPA1->(DBSKIP())
  ENDDO 
  cMsg += " </table> "
  cMsg += " <br> <br> "
  cMsg += "MSTECK26.PRW"
  cMsg += "</HTML> "

  //U_STMAILTES(cMailTo, cCopia, cAssun, cMsg, cAnexo)
  FRSendMail(cMailTo, cCopia, cAssun, cMsg, cAnexo )
ENDIF
TPA1->(DBCLOSEAREA())

RETURN


Static Function FRSendMail(cMailTo, cCopia, cAssun, cCorpo, cAnexo )

//Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""


Local cAccount	:= "wfprotheus7@steck.com.br" 
Local cPassword := "Teste123"  
Local cServer	:= "smtp.office365.com"
Local cFrom		:= "wfprotheus7@steck.com.br"

//Local cAttach 	:= cAnexo

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	//MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.
	MailAuth( cAccount, cPassword ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//Msgbox("E-mail não enviado...")	
	//else
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return


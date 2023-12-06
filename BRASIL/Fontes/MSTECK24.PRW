/**************************************** 
Ação.........: Job de geração de pedido de venda na industria
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 25/05/2022
Chamado......: 20220429009114 - Oferta Logística
****************************************/
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#DEFINE CL CHR(13)+CHR(10)

USER FUNCTION MSTECK24()

PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'

Private cEmailTo:=""

	//// Roda o WorkFlow de Manaus e Guararema. 
	MSTECK24A()

	//// Roda o WorkFlow dos Importados
	MSTECK24B()

RESET ENVIRONMENT

RETURN

STATIC FUNCTION MSTECK24A()

LOCAL cMailTo := ""
LOCAL cCopia  := ""
LOCAL cAssun  := ""
LOCAL cAnexo  := ""
LOCAL cMsg    := ""
LOCAL aEmp    := {}
Local nDias   :=SuperGetMv("ST_DIASWFA",.f.,-1)
LOCAL cQuery  :=""

AADD(aEmp,{'03','01'})
AADD(aEmp,{'01','05'})

FOR NX:=1 To len(aEmp)
  
   IF aEmp[NX,1]=='03'
      cMailTo:=SuperGetMv("ST_ST24MAO",.f.,'')
   ELSEIF aEmp[NX,1]=='01'
      cMailTo:=SuperGetMv("ST_ST24GUA",.f.,'')
   ENDIF   

   cMsg:=""
   cQuery:=""
   
   
   cQuery += "SELECT C6_ENTREG,C6_ZENTRE2,C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,C7_NUM,C7_ITEM,C6_QTDVEN,C6_QTDENT "
   cQuery += "FROM ( "
   cQuery += "SELECT C6.C6_ENTREG,C6.C6_ZENTRE2,C6.C6_NUM,C6.C6_ITEM,C6.C6_PRODUTO,C6.C6_DESCRI,C7.C7_NUM,C7.C7_ITEM,C6.C6_QTDVEN,C6.C6_QTDENT "
   cQuery += "FROM "+AllTrim(GetMv("STALIASIND"))+".SC6"+aEmp[NX,1]+"0 C6 "
   cQuery += "LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SD2"+aEmp[NX,1]+"0 D2 ON D2.D2_FILIAL = C6.C6_FILIAL AND D2.D2_PEDIDO = C6.C6_NUM AND D2.D2_ITEMPV = C6.C6_ITEM AND D2.D_E_L_E_t_ = ' ' "
   cQuery += "INNER JOIN UDBD11."+RetSqlName("Z96")+" Z96 ON Z96.Z96_EMPFIL = '"+aEmp[NX,1]+aEmp[NX,2]+"' AND Z96.Z96_PVIND = C6.C6_NUM AND Z96.Z96_ITPVIN = C6.C6_ITEM AND Z96.D_E_L_E_T_ = ' ' "
   cQuery += "INNER JOIN UDBD11."+RetSqlName("PA1")+" PA1 ON PA1.PA1_FILIAL = Z96.Z96_FILIAL AND PA1.PA1_CODPRO = Z96.Z96_PROD AND TRIM(PA1.PA1_DOC) = TRIM(Z96.Z96_PA1DOC) AND PA1.D_E_L_E_T_ = ' ' AND PA1.PA1_SALDO = 0 "
   cQuery += "INNER JOIN UDBD11."+RetSqlName("SC7")+" C7  ON C7.C7_FILIAL=Z96.Z96_FILIAL AND  C7.C7_NUM = Z96.Z96_PEDCOM AND C7.C7_ITEM = Z96.Z96_ITECOM  AND C7.D_E_L_E_T_ = ' '  "
   cQuery += "INNER JOIN UDBD11."+RetSqlName("SC6")+" XC6 ON XC6.C6_FILIAL = Z96.Z96_FILIAL AND  XC6.C6_NUM||XC6.C6_ITEM = Z96.Z96_PA1DOC AND XC6.D_E_L_E_T_ = ' ' "
   cQuery += "AND XC6.C6_BLQ <> 'R' "
   cQuery += "AND ( XC6.C6_ZENTRE2 < '"+DTOS(dDatabase+nDias)+"' OR ( XC6.C6_ZENTRE2 = '  ' AND XC6.C6_ENTREG< '"+DTOS(dDatabase+nDias)+"' ) ) "
   cQuery += "WHERE C6.C6_FILIAL = '"+aEmp[NX,2]+"' "
   cQuery += "AND C6.C6_CLI = '033467' AND C6.C6_LOJA = '06' "
   cQuery += "AND ( C6.C6_ZENTRE2 < '"+DTOS(dDatabase+nDias)+"' OR ( C6.C6_ZENTRE2 = '  ' AND C6.C6_ENTREG< '"+DTOS(dDatabase+nDias)+"' ) ) "
   cQuery += "AND C6.C6_BLQ <> 'R' "
   cQuery += "AND C6.D_E_L_E_T_ = ' ' ) "
   cQuery += "GROUP BY C6_ENTREG,C6_ZENTRE2,C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,C7_NUM,C7_ITEM,C6_QTDVEN,C6_QTDENT "
   cQuery += "ORDER BY C6_PRODUTO "
   
   DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC6', .F., .T.)

   IF aEmp[nx,1]='03'
      cAssun  := "Pedidos de Vendas com atraso na indústria de Manaus"
   ELSE 
      cAssun  := "Pedidos de Vendas com atraso na indústria de Guararema"
   ENDIF   
   
   
   cMsg := "<HTML> "
   cMsg += "<HEAD> "
   cMsg += "<TITLE> "
   cMsg += " <img src='https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42' width='300' height='49'> </td> "
   cMsg += "</TITLE> "
   cMsg += "</HEAD> "
   cMsg += " <br> <br>"

   cMsg += " <table width='1000' border='2'> "
   cMsg += " <tr> "
   IF aEmp[nx,1]='03'
      cMsg += "   <td><div align='center'><font face='Verdana' size='1'><B>Pedido de venda com atraso na indústria de Manaus</B></font></div></td> "
   ELSE 
      cMsg += "   <td><div align='center'><font face='Verdana' size='1'><B>Pedido de venda com atraso na indústria de Guararema</B></font></div></td> "
   ENDIF      
   cMsg += " </tr> "
   cMsg += " </table> "

   //// Itens do Pedido de Venda
   cMsg += " <table width='1000' border='2' cellspacing='0' cellpadding='0'> "
   cMsg += "   <tr> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Número</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Item</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Produto</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Descrição</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Dt. Entrega</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Dt. Entrega2</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PC. Dist.</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PC. Item</font></div></td> "
   //cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PV. Cliente</font></div></td> "
   //cMsg += "    <td><div align='left'><font face='Verdana' size='1'>PV. Item</font></div></td> "
   //cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Nf. Industria</font></div></td> "
   //cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Dt. Emissao</font></div></td> "
   //cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Qtd.Item</font></div></td> "
   //cMsg += "    <td><div align='left'><font face='Verdana' size='1'>QTd.Faturada</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Qtd.Pedido</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Qtd.Faturada</font></div></td> "
   cMsg += "   </tr> "
   WHILE TSC6->(!EOF())
     cMsg += "   <tr> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC6->C6_NUM+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC6->C6_ITEM+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC6->C6_PRODUTO+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC6->C6_DESCRI+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+DTOC(STOD(TSC6->C6_ENTREG))+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+DTOC(STOD(TSC6->C6_ZENTRE2))+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC6->C7_NUM+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC6->C7_ITEM+"</font></div></td> "
     //cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC6->NUMCLI+"</font></div></td> "
     //cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC6->ITEMCLI+"</font></div></td> "
     //cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TSC6->D2_DOC+"</font></div></td> "
     //cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+DTOC(STOD(TSC6->D2_EMISSAO))+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+ALLTRIM(STR(TSC6->C6_QTDVEN,10))+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+ALLTRIM(STR(TSC6->C6_QTDENT,10))+"</font></div></td> "

     cMsg += "   </tr> "
     TSC6->(DBSKIP())
   ENDDO 
   TSC6->(DBCLOSEAREA())
   cMsg += " </table> "

   cMsg += " <br> <br> "
   cMsg += "MSTECK24.PRW"
   cMsg += "</HTML> "

   U_STMAILTES(cMailTo, cCopia, cAssun, cMsg, cAnexo)
   /*/
   IF aEmp[nx,2]=='01'
      MemoWrite("C:\ARQ\TESTE1_MANAUS.html",cMsg)
   ELSE 
      MemoWrite("C:\ARQ\TESTE1_GUARA.html",cMsg)
   ENDIF
   /*/
NEXT NX 


// Envia WF DOS IMPORTADOS. 
STATIC FUNCTION MSTECK24B()


LOCAL cCopia  := ""
LOCAL cAssun  := ""
LOCAL cAnexo  := ""
LOCAL cMsg    := ""
LOCAL aEmp    := {}
Local nDias   :=SuperGetMv("ST_DIASWFA",.f.,-1)
LOCAL cQuery  :=""
LOCAL cMailTo :=SuperGetMv("ST_ST24IMP",.f.,'')

// Envia WF DOS IMPORTADOS. 
cQuery:=""
cQuery+=" SELECT ZA6.ZA6_PO,ZA6.ZA6_ITEM, ZA6_PROD,SC6.C6_DESCRI,SC6.C6_ENTREG,SC6.C6_ZENTRE2,ZA6.ZA6_DATA,SC7.C7_QUANT,sc7.c7_quje ,ZA6.ZA6_SEQPO "
cQuery+=" FROM UDBD11."+RetSqlName("ZA6")+" ZA6 " 
cQuery+=" INNER JOIN UDBD11."+RetSqlName("Z96")+" Z96 ON Z96.Z96_FILIAL = ZA6.ZA6_FILIAL AND Z96.Z96_PROD = ZA6.ZA6_PROD AND Z96.Z96_PEDCOM = ZA6.ZA6_PO "
cQuery+= "INNER JOIN UDBD11."+RetSqlName("PA1")+" PA1 ON PA1.PA1_FILIAL = Z96.Z96_FILIAL AND PA1.PA1_CODPRO = Z96.Z96_PROD AND TRIM(PA1.PA1_DOC) = TRIM(Z96.Z96_PA1DOC) AND PA1.D_E_L_E_T_ = ' ' AND PA1.PA1_SALDO = 0 "
cQuery+=" INNER JOIN UDBD11."+RetSqlName("SC6")+" SC6 ON SC6.C6_FILIAL = Z96.Z96_FILIAL AND SC6.C6_NUM||SC6.C6_ITEM= Z96.Z96_PA1DOC  "
cQuery+=" AND ( ( SC6.C6_ZENTRE2<> '  ' AND SC6.C6_ZENTRE2 <= '20230714' ) OR  ( SC6.C6_ZENTRE2 = '  ' AND SC6.C6_ENTREG< '20230713' )) "
cQuery+=" AND SC6.C6_BLQ <> 'R' AND SC6.D_E_L_E_T_ = ' ' "
cQuery+=" AND SC6.C6_QTDVEN > SC6.C6_QTDENT "
cQuery+=" INNER JOIN UDBD11."+RetSqlName("SC7")+" SC7 ON SC7.C7_FILIAL = ZA6.ZA6_FILIAL AND SC7.C7_NUM = ZA6.ZA6_PO AND SC7.C7_ITEM = ZA6.ZA6_ITEM "
cQuery+=" AND Z96.Z96_ITECOM = ZA6.ZA6_ITEM AND Z96.Z96_SEQUEN = ZA6.ZA6_SEQPO AND Z96.D_E_L_E_T_ = ' ' AND Z96.Z96_TIPREG = 'PO' "
cQuery+=" WHERE ZA6.ZA6_FILIAL = '"+XFILIAL('ZA6')+"' "
cQuery+=" AND ZA6.d_e_l_e_t_ = ' ' "
cQuery+=" GROUP BY ZA6_PO,ZA6_ITEM,ZA6_PROD,C6_DESCRI,C6_ENTREG,C6_ZENTRE2,ZA6_DATA,C7_QUANT,C7_QUJE ,ZA6_SEQPO "
cQuery+=" ORDER BY ZA6_PROD "

 
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TZA6', .F., .T.)

cAssun  := " Pedidos Com Atraso Importados "
   
   
   cMsg := "<HTML> "
   cMsg += "<HEAD> "
   cMsg += "<TITLE> "
   cMsg += " <img src='https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42' width='300' height='49'> </td> "
   cMsg += "</TITLE> "
   cMsg += "</HEAD> "
   cMsg += " <br> <br>"

   cMsg += " <table width='1000' border='2'> "
   cMsg += " <tr> "
   cMsg += "   <td><div align='center'><font face='Verdana' size='1'><B>Pedidos com atraso importados</B></font></div></td> "
   cMsg += " </tr> "
   cMsg += " </table> "

   //// Itens do Pedido 
   cMsg += " <table width='1000' border='2' cellspacing='0' cellpadding='0'> "
   cMsg += "   <tr> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Número</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Item</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Produto</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Descrição</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Dt. Entrega</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Dt. Entrega2</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Qtd.Pedido</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Qtd.Entregue</font></div></td> "
   cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Seq.PO</font></div></td> "
   cMsg += "   </tr> "
   WHILE TZA6->(!EOF())
     cMsg += "   <tr> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TZA6->ZA6_PO+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TZA6->ZA6_ITEM+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TZA6->ZA6_PROD+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+TZA6->C6_DESCRI+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+DTOC(STOD(TZA6->C6_ENTREG))+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+DTOC(STOD(TZA6->C6_ZENTRE2))+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+ALLTRIM(STR(TZA6->C7_QUANT,10))+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+ALLTRIM(STR(TZA6->C7_QUJE,10))+"</font></div></td> "
     cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+ALLTRIM(TZA6->ZA6_SEQPO)+"</font></div></td> "
     cMsg += "   </tr> "
     TZA6->(DBSKIP())
   ENDDO 
   TZA6->(DBCLOSEAREA())
   cMsg += " </table> "

   cMsg += " <br> <br> "
   cMsg += "MSTECK24.PRW"
   cMsg += "</HTML> "

   U_STMAILTES(cMailTo, cCopia, cAssun, cMsg, cAnexo)
   //MemoWrite("C:\ARQ\TESTE_IMPORTADOS.html",cMsg)

RETURN()



#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "Fileio.ch"
#include "Totvs.ch"
#Include 'FwMVCDef.ch'


/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Gerar HTM pedidos de compra duplicados 
<Data> : 16/10/2023
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> :
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Autor> :Antonio Cordeiro de Moura
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

User Function STFAT706()

// Manaus 
StartJob("U_FAT706WF",GetEnvserver(),.T.,'03','01') 

// Guararema 
StartJob("U_FAT706WF",GetEnvserver(),.T.,'01','05') 

Return() 


User Function FAT706WF(cEmp,cFil)


Local  aProc   :={}
Private cMsg    :=""
Private cMailTo := ""
Private NX      :=0
Private cAnexo  :=""
Private cCopia  :=""
Private cAssun  :=""


RpcClearEnv()
RpcSetType(3)
RpcSetEnv(cEmp,cFil,,,"FAT")	


IF cEmp=='03'
    cAssun  := "Houve duplicidade de pedidos na Industria em Manaus "
ELSEIF cEmp=='01'   
    cAssun  := "Houve duplicidade de pedidos na Industria em Guararema "
ENDIF    

cMailTo := SuperGetMv("ST_MAILDUP",.f.,'leandro.godoy@steck.com.br')

cMsg := "<HTML> "
cMsg += "<HEAD> "
cMsg += "<TITLE> "
cMsg += " <img src='https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42' width='300' height='49'> </td> "
cMsg += "</TITLE> "
cMsg += "</HEAD> "
cMsg += " <br> <br>"

cMsg += " <table width='1000' border='2'> "
cMsg += " <tr> "
IF cEmp=='03'
   cMsg += " <td><div align='center'><font face='Verdana' size='1'><B>Alerta Pedidos Duplicados na Industria Manaus </B></font></div></td> "
ELSE 
   cMsg += " <td><div align='center'><font face='Verdana' size='1'><B>Alerta Pedidos Duplicados na Industria Guararema</B></font></div></td> "
ENDIF
cMsg += " </tr> "
cMsg += " </table> "

//// Itens do Pedido de Venda
cMsg += " <table width='1000' border='2' cellspacing='0' cellpadding='0'> "
cMsg += "   <tr> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Base</font></div></td> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Filial</font></div></td> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Pedido Industria</font></div></td> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Cliente</font></div></td> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Loja</font></div></td> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Ped Compra Origem</font></div></td> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Emissao</font></div></td> "
cMsg += "   </tr> "

aProc:={}
aProc:=BuscaDupli()

IF LEN(aProc)>0
   FOR NX:=1 TO LEN(aProc)
      cMsg += "   <tr> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aProc[NX,1]+"</font></div></td> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aProc[NX,2]+"</font></div></td> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aProc[NX,3]+"</font></div></td> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aProc[NX,4]+"</font></div></td> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aProc[NX,5]+"</font></div></td> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aProc[NX,6]+"</font></div></td> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aProc[NX,7]+"</font></div></td> "
      cMsg += "   </tr> "
   NEXT 
   cMsg += " </table> "
   cMsg += " <br> <br> "
   cMsg += "STFAT706.PRW"
   cMsg += "</HTML> "
   U_STMAILTES(cMailTo, cCopia, cAssun, cMsg, cAnexo)
ENDIF

Return()




// Ver Cor. 
Static Function BuscaDupli()

Local cAlias  := GetNextAlias()
Local cQuery  :=""
Local aRet    :={}
Local cCliDis :=SuperGetMv("ST_CLIDIS",.f.,'033467')

IF cEmpAnt=='03'
   cQuery +=" SELECT 'MANAUS' BASE,C5_FILIAL,C5_NUM,C5_CLIENTE,C5_LOJACLI,C5_ZNUMPC,C5_EMISSAO "
ELSE 
   cQuery +=" SELECT 'GUARAREMA' BASE,C5_FILIAL,C5_NUM,C5_CLIENTE,C5_LOJACLI,C5_ZNUMPC,C5_EMISSAO "
ENDIF
cQuery +=" FROM "+RetSqlName("SC5")+ " SC5 "
cQuery +=" WHERE C5_FILIAL||C5_CLIENTE||C5_LOJACLI||C5_ZNUMPC IN ( "
cQuery +=" SELECT C5_FILIAL||C5_CLIENTE||C5_LOJACLI||C5_ZNUMPC FROM ( "
cQuery +=" SELECT SC5.C5_FILIAL,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_ZNUMPC,COUNT(*) TOTAL "
cQuery +=" FROM "+RetSqlName("SC5")+ " SC5 "
cQuery +=" WHERE SC5.C5_FILIAL = '"+XFILIAL('SC5')+"' "
cQuery +=" AND SC5.C5_CLIENTE = '"+cCliDis+"' "
cQuery +=" AND SC5.D_E_L_E_T_ = ' ' "
cQuery +=" AND SC5.C5_ZNUMPC <> ' ' "
cQuery +=" AND SC5.C5_NOTA = ' ' "
cQuery +=" AND SC5.C5_EMISSAO>='"+DTOS(DATE()-20)+"' "
cQuery +=" GROUP BY SC5.C5_FILIAL,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_ZNUMPC "
cQuery +=" HAVING COUNT(*) >1 "
cQuery +=" ) 
cQuery +=" ) 
cQuery +=" AND C5_CLIENTE = '033467' "
cQuery +=" AND D_E_L_E_T_ = ' ' "
cQuery +=" AND C5_ZNUMPC <> ' ' "
cQuery +=" AND C5_NOTA = ' ' "
cQuery +=" AND C5_EMISSAO>='"+DTOS(DATE()-20)+"' "

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
(cAlias)->(DBGOTOP())
WHile ! (cAlias)->(EOF())
   AADD(aRet,{(cAlias)->BASE,(cAlias)->C5_FILIAL,(cAlias)->C5_NUM,(cAlias)->C5_CLIENTE,(cAlias)->C5_LOJACLI,(cAlias)->C5_ZNUMPC,(cAlias)->C5_EMISSAO})
   (cAlias)->(DBSKIP())
ENDDO 
(cAlias)->( DbcloseArea())

Return(aRet)

#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "Fileio.ch"
#include "Totvs.ch"
#Include 'FwMVCDef.ch'

#Define CENVSRV   AllTrim(Upper(GetEnvServer()))
#define INCLUSAO 3
#define ALTERACAO 4


#xCommand @ <nRow>, <nCol> GET <uVar> ;
[ OBJECT <oGet> ];
[ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
[ PICTURE <cPict> ] ;
[ VALID <ValidFunc> ] ;
[ F3 <cF3> ];
[ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
[ SIZE <nWidth>, <nHeight> ]  ;
[ FONT <oFont> ] ;
[ <design: DESIGN> ] ;
[ CURSOR <oCursor> ] ;
[ <pixel: PIXEL> ] ;
[ MESSAGE <cMsg> ] ;
[ <update: UPDATE> ] ;
[ WHEN <uWhen> ] ;
[ <lCenter: CENTER, CENTERED> ] ;
[ <lRight: RIGHT> ] ;
[ ON CHANGE <uChange> ] ;
[ <readonly: READONLY, NO MODIFY> ] ;
[ <pass: PASSWORD> ] ;
[ <lNoBorder: NO BORDER, NOBORDER> ] ;
[ <help:HELPID, HELP ID> <nHelpId> ] ;
;
=> [ <oGet> := ] TGet():New( <nRow>, <nCol>, bSETGET(<uVar>), [<oWnd>], <nWidth>,;
<nHeight>, <cPict>, <{ValidFunc}>, <nClrFore>, <nClrBack>, <oFont>,;
<.design.>, <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
<.lCenter.>, <.lRight.>, [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,;
<.pass.> , [<cF3>],<(uVar)>,,[<.lNoBorder.>], [<nHelpId>])

User Function STFAT702()
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Filtro principal do browse.
<Data> : 27/07/2023
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> :
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Autor> :Antonio Cordeiro de Moura
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/



//Local aBrwModel	:= {}
//Local aBrwCol   := {}
//Local aBrwSeek  := {}
//Local aBrwFil   := {}

Private oBrowse      := FWmBrowse():New()
Private cCadastro    := "Consulta Pedidos Aglutinados"
Private cNomTmp      := ""
Private cAliasTmp    := GetNextAlias()
Private _aRotina     := MenuDef()
Private aRetorno     :={}
Private aCampos      := {}
Private cPerg			:= "STFAT702"
Private aPergunt	:= {}

//aAdd(aBrwModel, {"Filial"      ,"@!", 02, 00, 1})
//aAdd(aBrwModel, {"Pedido"      ,"@!", 06, 00, 1})
//aAdd(aBrwModel, {"Dt.Aglutina" ,"@!", 08, 00, 1})
//aAdd(aBrwModel, {"Cod.Cliente" ,"@!", 06, 00, 1})
//aAdd(aBrwModel, {"Loja"        ,"@!", 02, 00, 1})

//For nI := 1 To Len(aBrwModel)
//   aAdd(aBrwFil, {aBrwModel[nI,1], aBrwModel[nI,1], "C", aBrwModel[nI,3], aBrwModel[nI,4], aBrwModel[nI,2]} )
//   aAdd(aBrwCol, FwBrwColumn():New())
//   aBrwCol[Len(aBrwCol)]:SetData( &("{ || aBrwData[oBrowse:nAt," + cValToChar(nI) + "]}") )
//   aBrwCol[Len(aBrwCol)]:SetTitle(aBrwModel[nI,   1])
//   aBrwCol[Len(aBrwCol)]:SetPicture(aBrwModel[nI, 2])
//   aBrwCol[Len(aBrwCol)]:SetSize(aBrwModel[nI,    3])
//   aBrwCol[Len(aBrwCol)]:SetDecimal(aBrwModel[nI, 4])
//   aBrwCol[Len(aBrwCol)]:SetAlign(aBrwModel[nI,   5])
//Next nI


cPerg		:= Padr("STFAT702",Len(SX1->X1_GRUPO))
Aadd(aPergunt,{cPerg	,"01","Cliente","mv_ch1","C",06,00,"G","","mv_par01","","","","","","SA1",""})
Aadd(aPergunt,{cPerg	,"02","Data JunÁ„o de ","mv_ch2","D",08,00,"G","","mv_par02","","","","","","",""})
Aadd(aPergunt,{cPerg	,"03","Data JunÁ„o AtÈ ","mv_ch3","D",08,00,"G","","mv_par03","","","","","","",""})
Aadd(aPergunt,{cPerg	,"04","Ordenar Por?","mv_ch4","N",01,00,"C","","mv_par04","Cliente","Pedido","Dt.Aglutinacao","","","",""})


//Aadd(aPergunt,{cPerg	,"03","Nota","mv_ch3","C",09,00,"G","","mv_par03","","","","","","",""})
//Aadd(aPergunt,{cPerg	,"04","Visualiza","mv_ch4","N",01,00,"C","","mv_par04","An·litico","SintÈtico","","","","",""})
//Aadd(aPergunt,{cPerg	,"05","Data Vencimento","mv_ch5","D",08,00,"G","","mv_par05","","","","","","",""})
ValidSX1(aPergunt)


AADD(aCampos,{'Filial'     ,'C5_FILIAL'   ,'C','@!'         , ,02,0})
AADD(aCampos,{'Pedido'     ,'C5_NUM'      ,'C','@!'         , ,06,0})
AADD(aCampos,{'Dt.Algutina','C6_XDTINSE'  ,'D','@!'         , ,08,0})
AADD(aCampos,{'Cod.Cliente','C5_CLIENTE'  ,'C','@!'         , ,06,0})
AADD(aCampos,{'Loja'       ,'C5_LOJACLI'  ,'C','@!'         , ,02,0})
AADD(aCampos,{'Nome'       ,'A1_NREDUZ'   ,'C','@!'         , ,40,0})
AADD(aCampos,{'Vendedor'   ,'C5_VEND1'    ,'C','@!'         , ,06,0})
AADD(aCampos,{'Transp'     ,'C5_TRANSP'   ,'C','@!'         , ,06,0})
AADD(aCampos,{'Cond.Pagto' ,'C5_CONDPAG'  ,'C','@!'         , ,03,0})
AADD(aCampos,{'xTipo'      ,'C5_XTIPO'    ,'C','@!'         , ,01,0})
AADD(aCampos,{'xTipf'      ,'C5_XTIPF'    ,'C','@!'         , ,01,0})
//AADD(aCampos,{'Tot.Pedidos','TOTAL'       ,'N','@E 999'        ,0,8,0})
//AADD(aCampos,{'Vl.Total'   ,'TOTAL3'      ,'N','@E 999,999,999.99',0,15,2})

IF !Pergunte(cPerg,.t.)
   Return()
ENDIF   

MsgRun("Selecionando Registros...",,{|| AbreTMP() })

//oBrowse:AddLegend("  TOTAL =2  " ,"GREEN"   ,"2 Pedidos")  //
//oBrowse:AddLegend("  TOTAL >2 " ,"YELLOW"   ,"Mais q 2 pedidos ")  //

oBrowse:AddLegend(".T."         ,"White"  ,"Outros")

oBrowse:SetAlias(cAliasTmp)
oBrowse:SetDescription(cCadastro)
oBrowse:SetFields(aCampos)
oBrowse:SetSeek(.T.,NIL)

//oBrowse:SetUseFilter()
//oBrowse:SetFieldFilter(aBrwFil)


oBrowse:Activate()

dbSelectArea(cAliasTmp)
dbCloseArea()
fErase(cNomTmp+GetDbExtension())
fErase(cNomTmp+OrdBagExt())

Return nil



Static Function MenuDef()
Local _aRotina := {}

ADD OPTION _aRotina Title 'Filtrar'            Action 'U_FAT70201' OPERATION 3 ACCESS 0    //
ADD OPTION _aRotina Title 'Vizualiza JunÁ„o'   Action 'U_FAT70202' OPERATION 3 ACCESS 0    //
ADD OPTION _aRotina Title 'Legenda'            Action 'U_FAT70299' OPERATION 3 ACCESS 0   //


Return _aRotina



Static Function AbreTMP()


/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Abertura do arquivo tempor·rio
<Data> : 21/03/2017
<Parametros> : aRotina
<Retorno> : Nenhum
<Processo> :
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : E
<Autor> :Antonio Cordeiro Moura.
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/


cCadastro    := "Pedidos Aglutinados"  //+iif(mv_par03==1,'008810','008850')
oBrowse:SetDescription(cCadastro)
oBrowse:Refresh(.T.)


If !Empty(cNomTmp)
	dbSelectArea(cAliasTmp)
	dbCloseArea()
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())
Else
	cNomTmp := CriaTrab(,.F.)
Endif

//Pergunte(cPerg,.t.)


 cQuery := " SELECT * FROM  (  SELECT C5_FILIAL,C5_NUM,C6_XDTINSE,C5_CLIENTE,C5_LOJACLI,C5_VEND1,C5_TRANSP,C5_CONDPAG,C5_XTIPO,C5_XTIPF,A1_NREDUZ  FROM ( " +CRLF
 cQuery += " SELECT SC5.C5_FILIAL,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_VEND1,SC5.C5_TRANSP,SC5.C5_NUM,SC5.C5_CONDPAG,SC5.C5_XTIPO,SC5.C5_XTIPF,SC6.C6_XDTINSE,SC5.C5_NATUREZ,SA1.A1_NREDUZ " +CRLF
 cQuery += " FROM "+RetSqlName("SC6")+" SC6 " +CRLF
 cQuery += " INNER JOIN "+RetSqlName("SC5")+" SC5 ON SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM AND SC5.D_E_L_E_T_ = ' ' " +CRLF
 cQuery += " AND SC5.C5_EMISSAO >= '"+dtos(ddatabase-180)+"' "+CRLF
 cQuery += " AND SC6.C6_XPEDORI<>'   ' " +CRLF
 cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON SC5.C5_CLIENTE = SA1.A1_COD AND sc5.c5_lojacli = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' " +CRLF
 cQuery += " WHERE SC6.C6_FILIAL = '"+XFILIAL('SC6')+"' "
 IF !Empty(MV_PAR01)
    cQuery += " AND SC6.C6_CLI = '"+MV_PAR01+"' "
 ENDIF   
 IF !Empty(MV_PAR02)
    cQuery += " AND SC6.C6_XDTINSE >= '"+DTOS(MV_PAR02)+"' "
 ENDIF   
 IF !Empty(MV_PAR03)
    cQuery += " AND SC6.C6_XDTINSE <= '"+DTOS(MV_PAR03)+"' "
 ENDIF   
 cQuery += " AND SC6.D_E_L_E_T_ = ' ' " +CRLF

 cQuery += " GROUP BY  C5_FILIAL,C5_CLIENTE,C5_LOJACLI,C5_VEND1,C5_TRANSP,SC5.C5_NUM,SC5.C5_CONDPAG,SC5.C5_XTIPO,SC5.C5_XTIPF,SC5.C5_NATUREZ,SA1.A1_NREDUZ,SC6.C6_XDTINSE " +CRLF
 cQuery += " ) " +CRLF
 cQuery += " GROUP BY C5_FILIAL,C5_NUM,C6_XDTINSE,C5_CLIENTE,C5_LOJACLI,C5_VEND1,C5_TRANSP,C5_CONDPAG,C5_XTIPO,C5_XTIPF,A1_NREDUZ ) " +CRLF
 
 IF MV_PAR04==1
    cQuery += " ORDER BY C5_FILIAL,A1_NREDUZ "
 ELSEIF MV_PAR04==2
    cQuery += " ORDER BY C5_FILIAL,C5_NUM " 
 ELSE    
    cQuery += " ORDER BY C5_FILIAL,C6_XDTINSE " 
 ENDIF    

/*/
cQuery := " SELECT * FROM  ( "
cQuery += " SELECT C5_FILIAL,C5_CLIENTE,C5_LOJACLI,C5_VEND1,C5_TRANSP,C5_CONDPAG,C5_XTIPO,C5_XTIPF,A1_NREDUZ,COUNT(*) TOTAL,SUM(TOTAL2) TOTAL3 "
cQuery += " FROM ( " +CRLF
cQuery += " SELECT SC5.C5_FILIAL, SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_VEND1,SC5.C5_TRANSP,SC5.C5_NUM,SC5.C5_CONDPAG,SC5.C5_XTIPO,SC5.C5_XTIPF,SC5.C5_NATUREZ,SA1.A1_NREDUZ,SUM((SC6.C6_QTDVEN-SC6.C6_QTDENT)*SC6.C6_PRCVEN) TOTAL2 " +CRLF
cQuery += " FROM UDBD1103."+RetSqlName("SC6")+" SC6 " +CRLF
cQuery += " INNER JOIN UDBD1103."+RetSqlName("SC5")+" SC5 ON SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM AND SC5.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " AND SC5.C5_EMISSAO >= '"+dtos(ddatabase-180)+"' "+CRLF
cQuery += " AND SC6.C6_XPEDORI<>'   ' "+CRLF  //" AND SC6.C6_BLQ <> 'R'  "+CRLF
cQuery += " INNER JOIN UDBD1103."+RetSqlName("SA1")+" SA1 ON SC5.C5_CLIENTE = SA1.A1_COD AND sc5.c5_lojacli = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " GROUP BY  C5_FILIAL,C5_CLIENTE,C5_LOJACLI,C5_VEND1,C5_TRANSP,SC5.C5_NUM,SC5.C5_CONDPAG,SC5.C5_XTIPO,SC5.C5_XTIPF,SC5.C5_NATUREZ,SA1.A1_NREDUZ "+CRLF
cQuery += " ) "+CRLF
cQuery += " GROUP BY C5_FILIAL,C5_CLIENTE,C5_LOJACLI,C5_VEND1,C5_TRANSP,C5_CONDPAG,C5_XTIPO,C5_XTIPF,A1_NREDUZ ) "+CRLF
//cQuery += " WHERE TOTAL>1 AND TOTAL3 > '"+ALLTRIM(STR(nValorMin))+"' "
/*/

cArqSql := GetNextAlias()
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cArqSql, .T., .T.)
TCSetField(cArqSql, "C6_XDTINSE"  ,"D",8,0)
dbSelectArea(cArqSql)
Dbgotop()
Copy to &cNomTmp

dbUseArea(.T.,,cNomTmp,cAliasTmp,.F.,.F.)
DbSelectArea(cAliasTmp)

Return()


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ ValidSX1 ∫Autor  ≥Bruno Daniel Borges ∫ Data ≥  22/06/05   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Funcao que valida as perguntas do SX1 e cria os novos regis-∫±±
±±∫          ≥tros                                                        ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ T4F                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function ValidSX1(aPergunt)
Local aAreaBKP := GetArea()
Local cGrpPerg := ""
Local lTipLocl := .T.
Local i

dbSelectArea("SX1")
SX1->(dbSetOrder(1))
SX1->(dbGoTop())

If Len(aPergunt) <= 0
	Return(Nil)
EndIf

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Valida as perguntas do usuario≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
cGrpPerg := aPergunt[1,1]
For i := 1 To Len(aPergunt)
	lTipLocl := !SX1->(dbSeek(cGrpPerg+aPergunt[i,2]))
	SX1->(RecLock("SX1",lTipLocl))
	SX1->X1_GRUPO		:= cGrpPerg
	SX1->X1_ORDEM		:= aPergunt[i,2]
	SX1->X1_PERGUNT		:= aPergunt[i,3]
	SX1->X1_PERSPA		:= aPergunt[i,3]
	SX1->X1_PERENG		:= aPergunt[i,3]
	SX1->X1_VARIAVL		:= aPergunt[i,4]
	SX1->X1_TIPO		:= aPergunt[i,5]
	SX1->X1_TAMANHO		:= aPergunt[i,6]
	SX1->X1_DECIMAL		:= aPergunt[i,7]
	SX1->X1_GSC			:= aPergunt[i,8]
	SX1->X1_VALID		:= aPergunt[i,09]
	SX1->X1_VAR01		:= aPergunt[i,10]
	SX1->X1_DEF01		:= aPergunt[i,11]
	SX1->X1_DEF02		:= aPergunt[i,12]
	SX1->X1_DEF03		:= aPergunt[i,13]
	SX1->X1_DEF04		:= aPergunt[i,14]
	SX1->X1_DEF05		:= aPergunt[i,15]
	SX1->X1_F3			:= aPergunt[i,16]
	SX1->X1_PICTURE		:= aPergunt[i,17]
	SX1->(MsUnlock())
Next i

RestArea(aAreaBKP)

Return(Nil)



/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Filtro principal do browse.
<Data> : 21/03/2017
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> :
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Autor> :Antonio Cordeiro de Moura
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

User Function FAT70201()

if Pergunte(cPerg,.T.)
   MsgRun("Selecionando Registros...",,{|| AbreTMP() })
endif   

Return()


/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Alterar pedido e eliminar residuo na origem. 
<Data> : 21/03/2017
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> :
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Autor> :Antonio Cordeiro de Moura
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

User Function FAT70202()

Processa({|| RunCont() },"","Processando Pedidos... Aguarde!!!")

Return()
                             
Static Function RunCont()

Local cFil1     :=''
Local NX        :=0
Local NY        :=0
Local cTipoCli  :=""
Local cNaturez  :=""
Local cOrdem    :=""
Local nMaxItem  :=""
Local lContinua :=.T.
Local cCliente:=''
Local cLojaCli:=''
Local cNum:=''
Local xDtInse:=''
Local aAreaSX3:=SX3->(GETAREA())

Private aItemNovo:={}
Private aCab     :={} 
Private aItens   :={}   
Private aTodos   :={}
Private aLinha   :={}
Private lMSErroAuto:=.F.
Private cCampos :=""
Private aCampos1 :={}

cCampos:="/C6_ITEM/C6_PRODUTO/C6_QTDVEN/C6_QTDVEN/C6_QTDLIB/C6_UM/C6_PRUNIT/C6_PRCVEN/C6_LOCAL/C6_TES	/C6_OPER/C6_ENTREG/C6_NUM/C6_PEDCLI/C6_VALOR/C6_XORDEM/C6_ZENTRE2/C6_ENTRE1/C6_OP/C6_XOPER/C6_XDTINSE/C6_XPEDORI/C6_XITEORI/C6_NUMPCOM/C6_ITEMPC/"
SX3->(DBSETORDER(1))
IF SX3->(DBSEEK('SC6'))
   WHILE ! SX3->(EOF()) .AND. SX3->X3_ARQUIVO=='SC6'
      IF ALLTRIM(SX3->X3_CAMPO) $ cCampos 
          AADD(aCampos1,ALLTRIM(SX3->X3_CAMPO))
      ENDIF   
      SX3->(DBSKIP())  
     ENDDO
ENDIF  

   cFil1   :=(cAliasTmp)->C5_FILIAL
   cCliente:=(cAliasTmp)->C5_CLIENTE  
   cLojaCli:=(cAliasTmp)->C5_LOJACLI 
   cNum    :=(cAliasTmp)->C5_NUM 
   xDtInse :=(cAliasTmp)->C6_XDTINSE 


   cVend1  :=(cAliasTmp)->C5_VEND1
   cTransp :=(cAliasTmp)->C5_TRANSP 
   cCondPag:=(cAliasTmp)->C5_CONDPAG  
   cFil1   :=(cAliasTmp)->C5_FILIAL
   
   
   SA1->(DBSETORDER(1))
   IF SA1->(DBSEEK(XFILIAL('SA1')+cCliente+cLojaCli))
      cTipoCli:=SA1->A1_TIPO
      cNaturez:=SA1->A1_NATUREZ
   
      aItens:={}
      aTodos:={}
      cOrdem:=""
      aTodos:=U_Bitens(cFil1,cNum,xDtInse,cCliente,cLojaCli)
      
      aSort(aTodos  ,,, { |x,y| y[2] > x[2]} )

      IF LEN(aTodos)>0 
         cPed1:=aTodos[1,2]
      ELSE 
         MsgBox('Os Itens n„o foram selecionados')
         return()
      ENDIF    

      //nMaxItem:=U_SC6PRI1(cFilant,cPed1)  // Insere os itens do pedido principal. 

      // insere os outros itens. 
      FOR NX:=1 TO LEN(aTodos)
        //IF aTodos[NX,2]<>cPed1
           aLinha := {}
           DBSELECTAREA('SC6')
           DBGOTO(aTodos[NX,1])
           IF ! SC6->(EOF())
              FOR NY :=1 to len(aCampos1)
                  /*/
                  IF ALLTRIM(aCampos1[NY])=='C6_ITEM'
                     nMaxItem:=Soma1(nMaxItem)
                     AADD(aItemNovo,nMaxItem)
                     aAdd(aLinha, {aCampos1[NY],nMaxItem, nil})
                  ELSEIF ALLTRIM(aCampos1[NY])=='C6_XDTINSE'
                     aAdd(aLinha, {aCampos1[NY],dDatabase, nil})
                  ELSEIF ALLTRIM(aCampos1[NY])=='C6_XPEDORI'
                     aAdd(aLinha, {aCampos1[NY],SC6->C6_NUM, nil})
                  ELSEIF ALLTRIM(aCampos1[NY])=='C6_XITEORI'
                     aAdd(aLinha, {aCampos1[NY],SC6->C6_ITEM, nil})
                  ELSE 
                     aAdd(aLinha, {aCampos1[NY],&(aCampos1[NY]), nil})
                  ENDIF   
                  /*/
                  aAdd(aLinha, {aCampos1[NY],&(aCampos1[NY]), nil})
              NEXT 
           ENDIF
           aAdd(aItens,aLinha)
        //ENDIF
      NEXT 

      // Carregar cabeÁalho  
      DBSELECTAREA('SC5')
      SC5->(DBSETORDER(1))
      IF DBSEEK(XFILIAL('SC5')+cPed1)
         aCab:={}

         aAdd(aCab, {"C5_NUM"     , SC5->C5_NUM        , Nil})
         aAdd(aCab, {"C5_TIPO"    , SC5->C5_TIPO       , Nil})
         aAdd(aCab, {"C5_CLIENTE" , SC5->C5_CLIENTE    , Nil})
         aAdd(aCab, {"C5_LOJACLI" , SC5->C5_LOJACLI    , Nil})
         aAdd(aCab, {"C5_LOJAENT" , SC5->C5_LOJAENT    , Nil})
         aAdd(aCab, {"C5_CONDPAG" , SC5->C5_CONDPAG    , Nil})
         aAdd(aCab, {"C5_ZCONDPG" , SC5->C5_ZCONDPG    , Nil})
         aAdd(aCab, {"C5_XTIPO"   , SC5->C5_XTIPO      , Nil})
         aAdd(aCab, {"C5_XTIPF"   , SC5->C5_XTIPF      , Nil})

      ENDIF
   ENDIF  

   Visualiza(aCab,aItens)

Return()


User Function FAT70299()

Local aLegenda := {}
aAdd(aLegenda,{"BR_VERDE"     ,"Sem Nota e Sem Pedido"})
aAdd(aLegenda,{"BR_AMARELO"   ,"Pedido Gerado"})
aAdd(aLegenda,{"BR_VERMELHO"  ,"Pedido e Nota Gerado"})
aAdd(aLegenda,{"BR_BRANCO"    ,"Sem classificaÁ„o" })
BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil


User Function BItens(Filial,cNum,dDtInse,Cliente,Loja)

Local cAlias1 := GetNextAlias()
Local aItens1 :={}
Local cQuery  :={}

//cQuery := " SELECT C6_PRODUTO,C6_QTDVEN,C6_QTDENT,C6_PRCVEN,C6_TES,SC6.R_E_C_N_O_ RECNO ,SC5.C5_XORDEM ,SC5.C5_NUM "
cQuery := " SELECT SC6.R_E_C_N_O_ RECNO ,SC5.C5_NUM,SC5.C5_XORDEM "
cQuery += " FROM "+RetSqlName("SC6")+" SC6 " +CRLF
cQuery += " INNER JOIN "+RetSqlName("SC5")+" SC5 ON SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_CLIENTE = SC6.C6_CLI AND SC5.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " WHERE SC6.C6_FILIAL = '"+Filial+"' "+CRLF
cQuery += "   AND SC6.C6_CLI = '"+Cliente+"' "+CRLF
cQuery += "   AND SC6.C6_LOJA= '"+Loja+"' "+CRLF
cQuery += "   AND SC6.C6_NUM = '"+cNum+"' "+CRLF
cQuery += "   AND SC6.C6_XDTINSE = '"+dtos(dDtInse)+"' "+CRLF
cQuery += "   AND SC6.C6_XPEDORI <> '  ' "+CRLF
cQuery += "   AND SC6.D_E_L_E_T_ = ' ' "+CRLF

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias1,.T.,.T.)
DBSELECTAREA(cAlias1)
(cAlias1)->(DBGOTOP())

While (cAlias1)->( ! Eof())
   //aAdd(aItens1,{(cAlias1)->C6_PRODUTO,(cAlias1)->C6_QTDVEN-(cAlias1)->C6_QTDENT,(cAlias1)->C6_PRCVEN,(cAlias1)->C6_TES,(cAlias1)->RECNO,(cAlias1)->C5_XORDEM,(cAlias1)->C5_NUM })
   aAdd(aItens1,{(cAlias1)->RECNO,(cAlias1)->C5_NUM ,(cAlias1)->C5_XORDEM})
   (cAlias1)->(DBSKIP())
ENDDO 

IF SELECT(cAlias1)>0
   DBSELECTAREA(cAlias1)
   DBCLOSEAREA()
ENDIF 

Return(aItens1)




User Function SC6PRI1(cFil,cPedido)

   Local nx      :=0
   Local aItens1 :={}
   Local nMaxItem:=""

   PA2->(DBSETORDER(4))

   DBSELECTAREA('SC6') 
   SC6->(DBSETORDER(1)) 
   IF SC6->(DBSEEK(cFil+cPedido))
      While ! SC6->(EOF()) .AND. ;
          SC6->C6_FILIAL = cFil .AND. ;
          SC6->C6_NUM    = cPedido 
          IF SC6->C6_ZENTRE2<=dDataBase
             IF PA2->(DBSEEK(XFILIAL('PA2')+SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM))
                IF PA2->PA2_QUANT>0
                   nMaxItem:=IIF(SC6->C6_ITEM>nMaxItem,SC6->C6_ITEM,nMaxItem)
                   aItens1 := {}
                   FOR NX :=1 to len(aCampos1)
                      aAdd(aItens1, {aCampos1[NX],&(aCampos1[NX]), nil})
                   NEXT 
                   aAdd(aItens, aItens1)
                ENDIF   
             ENDIF   
          ENDIF             
          SC6->(DBSKIP())        
      ENDDO
   ENDIF       

Return(nMaxItem)




User Function ST700RE1(cFil,cNum,cItem)

	Local lContinua	:= .T.   
   Local lvalido   := .T. 
	
   //Primeiro estona a liberaÁ„o do item. 
   SC9->(DBSETORDER(1))
   IF SC9->(DbSeek(cFil+cNum+cItem))
      While ! SC9->(EOF()) .AND. SC9->C9_FILIAL = cFil .AND.;
         SC9->C9_PEDIDO = cNum .and. SC9->C9_ITEM == cItem
         a460Estorna()
         SC9->(DBSKIP())    
      ENDDO
   ENDIF    

   DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	IF SC5->(DbSeek(cFil+cNum))
   		dbSelectArea("SC6")
		   dbSetOrder(1)
		   IF MsSeek(SC5->C5_FILIAL+SC5->C5_NUM+cItem)
				//Chamado 001591 - Gravar data da eliminaÁ„o de resÌduo
				SC6->(RecLock("SC6",.F.))
				SC6->C6_QTDEMP 	 := 0
				SC6->C6_XDTRES   := Date()
				SC6->C6_XUSRRES  := __cUserId
				SC6->(MsUnlock())
				SC6->(DbCommit())
				dbSelectArea("PA1")
				PA1->(DbSetOrder(3))
				If PA1->(DbSeek(xFilial('PA1')+SC6->C6_NUM+SC6->C6_ITEM))
					PA1->(RecLock('PA1',.F.))
					PA1->PA1_OBS:="ELIMINA«√O DE RESIDUO "+cUserName+' - '+__cuserId+' - '+dTOc(date())  +' - '+TIME()
					PA1->(DbDelete())
					PA1->(MsUnlock())
				EndIf
				dbSelectArea("PA2")
				PA2->(DbSetOrder(3))
				If PA2->(DbSeek(xFilial('PA2')+SC6->C6_NUM+SC6->C6_ITEM))
					PA2->(RecLock('PA2',.F.))
					PA2->PA2_OBS:="ELIMINA«√O DE RESIDUO "+cUserName+' - '+__cuserId+' - '+dTOc(date())  +' - '+TIME()
					PA2->(DbDelete())
					PA2->(MsUnlock())
    			EndIf


				IF SDC->(DBSEEK(XFILIAL("SDC")+SC6->C6_PRODUTO+SC6->C6_LOCAL+"SC6"+SC6->C6_NUM+SC6->C6_ITEM))
					SDC->(reclock("SDC", .F.))
    				SDC->( dbdelete() )
					SDC->( msunlock() )
						SBF->(DBSETORDER(1))
						IF SBF->(DBSSEK(XFILIAL("SBF")+SDC->DC_LOCAL+SDC->DC_LOCALIZ+SDC->DC_PRODUTO))
							SBF->(RECKLOCK("SBF",.F.))
								SBF->BF_EMPENHO := SBF->BF_EMPENHO - SDC->DC_QUANT
							SBF->(MSUNLOCK())
						ENDIF
            ENDIF 

		  	  lValido  := .T.
			  If lValido .And. !Empty(SC5->C5_PEDEXP) .And. SuperGetMv("MV_EECFAT") // Integracao SIGAEEC
			     If FindFunction("EECZERASALDO")
					  lValido := EECZeraSaldo(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
				  Else
					  lValido := EECCancelPed(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
				  EndIf
 				ENDIF
            If lValido .And. (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0
				   MaResDoFat(,.T.,.F.)
				EndIf
				SC6->(MaLiberOk({SC5->C5_NUM},.T.))
		   EndIf
   ENDIF      

Return(lContinua)


Static Function Visualiza(aCab2,aItens2)

Local lRet:=.F.

Local aListBox :={}
Local lOpcoes  := .T.
Local cCod     :="" 
Local cCliente :=""
Local cNome    :="" 
Local cLoja    :=""
Local cPedido  :=""
Local nOpc     :=0
Local nx       :=0
Local nH       :=0
Local oOK      := LoadBitmap(GetResources(),'br_verde')
Local oNO      := LoadBitmap(GetResources(),'br_amarelo')
Local nPos     :=0
Local aCampos5 :={} 
Local aDados   :={}
Local cDescri  :=""
Local cNota   :=""
Local nQtdEnt :=0
Local nReserva:=0 
Local dDtAlgu :=ctod('  /  /  ')
Local OrdSep  :=""

//Private oOk    := LoadBitMap(GetResources(),"LBOK")
//Private oNo    := LoadBitMap(GetResources(),"NADA")

nPos:=aScan(aCab2,{|x| AllTrim(x[1]) == 'C5_CLIENTE'})
cCod:=ACAB2[NPOS,2]

nPos:=aScan(aCab2,{|x| AllTrim(x[1]) == 'C5_LOJACLI'})
cLoja:=ACAB2[NPOS,2]
cNome:=Posicione("SA1",1,xFilial("SA1")+cCod+cLoja,"A1_NOME")
cCliente:=cCod+' - '+cLoja+' - '+cNome

nPos:=aScan(aCab2,{|x| AllTrim(x[1]) == 'C5_NUM'})
cPedido:=ACAB2[NPOS,2]

AADD(aCampos5,{'C6_ITEM','C6_PRODUTO','C6_QTDVEN','C6_XPEDORI','C6_XITEORI'})

FOR NX:=1 TO Len(aItens2)
   lOpcoes  := .T.
       aDados  :={}
       cDescri :=""
       nQtdEnt :=0
       cNota   :=''
       FOR NH:=1 TO LEN(aCampos5[1])
           nPos:=aScan(aItens2[NX],{|x| AllTrim(x[1]) == aCampos5[1,NH]})
           IF nPos<>0
              AADD(aDados,aItens[NX,Npos,2])
           ELSE 
              IF NH=3 
                 AADD(aDados,0)
              ELSE
                 AADD(aDados,'NAO ACHOU')
              ENDIF   
           ENDIF   
        NEXT 
        cNota   :=""
        nQtdEnt :=0
        nReserva:=0
        OrdSep:=""
        cDescri:=Posicione("SB1",1,xFilial("SB1")+aDados[2],"B1_DESC")
        SC6->(DBSETORDER(1))
        lOpcoes:=.F.
        IF SC6->(DBSEEK(XFILIAL('SC6')+cPedido+aDados[1]))
           cNota  :=SC6->C6_NOTA 
           nQtdEnt:=SC6->C6_QTDENT 
           PA2->(DBSETORDER(3))
           IF PA2->(DBSEEK(XFILIAL('PA2')+cPedido+aDados[1]))
              nReserva:=PA2->PA2_QUANT 
           ELSE 
              CB8->(DBSETORDER(2))
              IF CB8->(DBSEEK(XFILIAL('CB8')+SC6->C6_NUM+SC6->C6_ITEM))
                 IF CB8->CB8_SALDOE > 0
                    OrdSep:=CB8->CB8_ORDSEP 
                  ELSE 
                     While ! CB8->(EOF()) .AND. CB8->CB8_PEDIDO == SC6->C6_NUM .AND. ;
                         CB8->CB8_ITEM == SC6->C6_ITEM 
                         OrdSep:=CB8->CB8_ORDSEP 
                         IF CB8->CB8_SALDOE > 0
                            OrdSep:=CB8->CB8_ORDSEP 
                            EXIT
                         ENDIF
                         CB8->(DBSKIP())   
                     ENDDO    
                  ENDIF   
              ENDIF   
           ENDIF  
           IF nReserva>0 .OR. ( SC6->C6_QTDENT==SC6->C6_QTDVEN)  .OR. ALLTRIM(SC6->C6_BLQ)=='R';
              .OR. !Empty(OrdSep)
              lOpcoes:=.T.
           ENDIF   
           dDtAlgu :=SC6->C6_XDTINSE
        ENDIF
        AADD(aListBox,{lOpcoes,aDados[1],aDados[2],aDados[3],cDescri,aDados[4],aDados[5],nQtdEnt,nReserva,OrdSep,cNota})
NEXT    


//DEFINE MSDIALOG oDlg1 TITLE 'Pedido Consolidado' FROM  175,020 TO 500,650 PIXEL OF oMainWnd
DEFINE MSDIALOG oDlg1 TITLE 'Pedido Consolidado em: '+dtoc(dDtAlgu) FROM  000,020 TO 500,1300 PIXEL OF oMainWnd
@ 012,010 Say "Pedido:" SIZE 50,9 PIXEL
@ 010,040 MSGET oNomeCli Var cPedido OF oDlg1 PIXEL SIZE 50,9 WHEN .F.

@ 012,100 Say "Cliente:" SIZE 50,9 PIXEL
@ 010,140 MSGET oNomeCli Var cCliente OF oDlg1 PIXEL SIZE 200,9 WHEN .F.


IF LEN(aListBox)>0

     @ 025,004 LISTBOX oListBox VAR cVar FIELDS HEADER	" "			,;
     "Item.",;
     "Codigo",;
     "Qtd",;
     "DescriÁ„o",;
     "Ped. Origem",;
     "Item Origem",;
     "Entregue",;
     "Reservado",;
     "Ord.Sep.",;
     "Nota" SIZE 600,200 PIXEL of oDlg1 ;  //450
     //ON dblClick (aListBox:=DesTroca(oListBox:nAt,aListBox),oListBox:Refresh())
     oListBox:SetArray(aListBox)
     oListBox:bLine:={|| {If(aListBox[oListBox:nAt,1],oOk,oNo)  ,;
     aListBox[oListBox:nAt,2],;
     aListBox[oListBox:nAt,3],;
     Transform(aListBox[oListBox:nAt,4], "@E 9,999"),;
	  aListBox[oListBox:nAt,5],;
     aListBox[oListBox:nAt,6],;
     aListBox[oListBox:nAt,7],;
     Transform(aListBox[oListBox:nAt,8], "@E 9,999"),;
     Transform(aListBox[oListBox:nAt,9], "@E 9,999"),;
     aListBox[oListBox:nAt,10],;
     aListBox[oListBox:nAt,11]}}
     

     DEFINE SBUTTON FROM 230,400 TYPE 1 Action (nOpc:=1,oDlg1:End()) ENABLE OF oDlg1
     //DEFINE SBUTTON FROM 230,360 TYPE 2 Action (nOpc:=0,oDlg1:End()) ENABLE OF oDlg1
     ACTIVATE MSDIALOG oDlg1 Centered 

     //IF nOpc==1
     //   lRet:=.T.
     //ELSE 
     //   lRet:=.F.   
     //ENDIF   
ELSE 
   MsgBox('N„o existe dados para aglutinar','AtenÁ„o','Info')
ENDIF   

Return()


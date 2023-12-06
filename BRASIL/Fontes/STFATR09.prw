#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STFATR09  ºAutor ³ Antonio Cordeiro   º Data ³  02/10/23   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Saldo Cancelado                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STFATR09()

Private _oReport
Private _cPerg  := "STFATR09"
Private aOp     :={}
Private aPro    :={}
Private aMO     :={}
Private nCont   :=0
Private aFator  :={}
Private cOpAnt  :=""
Private cAlias := GetNextAlias()


_oReport := _oImpRelt()
_oReport:PrintDialog()

Return

Static Function _oImpRelt()

Local _oReport
Local _oSection1
Local cTitle      := "Saldos Cancelados"

oAjustaSx1()
Pergunte(_cPerg,.F.)

_oReport   := TReport():New("STFATR09",cTitle,_cPerg, {|_oReport| ReportPrint(_oReport)},"Imprime Relatório Saldo Cancelado")
_oSection1 := TRSection():New(_oReport,"Monitor",{"SC5",cAlias})
_oReport:SetLandscape()
_oReport:oPage:nPaperSize := 9 

TRCell():New(_oSection1,"FILIAL"     ,cAlias,"Filial"     ,"",05,,,,,"LEFT")
TRCell():New(_oSection1,"PEDIDO"     ,cAlias,"Pedido"     ,"",01,,,,,"LEFT")
TRCell():New(_oSection1,"CLIENTE"    ,cAlias,"Cliente"    ,"",09,,,,,"LEFT")
TRCell():New(_oSection1,"LOJA"       ,cAlias,"Loja"       ,"",03,,,,,"LEFT")
TRCell():New(_oSection1,"EMISSAO"    ,cAlias,"Dt.Emissao" ,"",10,,,,,"LEFT")
TRCell():New(_oSection1,"NOME"       ,cAlias,"Nome"       ,"",30,,,,,"LEFT")

TRCell():New(_oSection1,"ITEM"       ,cAlias,"Item"       ,"",30,,,,,"LEFT")
TRCell():New(_oSection1,"PRODUTO"    ,cAlias,"Produto"    ,"",30,,,,,"LEFT")
TRCell():New(_oSection1,"QTDVEN"     ,cAlias,"Qtd.Vend"   ,PesqPict('SC6',"C6_QTDVEN")	,TamSX3("C6_QTDVEN")[1],,,,,"LEFT")
TRCell():New(_oSection1,"QTDENT"     ,cAlias,"Qtd.Entregue",PesqPict('SC6',"C6_QTDENT")	,TamSX3("C6_QTDENT")[1],,,,,"LEFT")
TRCell():New(_oSection1,"XDTRES"     ,cAlias,"Dt.Elim.Res","",10,,,,,"LEFT")
TRCell():New(_oSection1,"BLQ"        ,cAlias,"Residuo","",10,,,,,"LEFT")

//TRCell():New(_oSection1,"DATAIMP"    ,cAlias,"Dt.Importa" ,"",10,,,,,"LEFT")
//TRCell():New(_oSection1,"DATAPRE"    ,cAlias,"Dt.PréNota" ,"",10,,,,,"LEFT")
//TRCell():New(_oSection1,"DT_CLASS"   ,cAlias,"Dt.Class"   ,"",10,,,,,"LEFT")
//TRCell():New(_oSection1,"DCLASS"     ,cAlias,"Dias da Class"   ,"",10,,,,,"LEFT")
//TRCell():New(_oSection1,"HORAIMP"    ,cAlias,"Hr.Imp."    ,"",10,,,,,"LEFT")
//TRCell():New(_oSection1,"UF"         ,cAlias,"UF"         ,"",02,,,,,"LEFT")
//TRCell():New(_oSection1,"STATUS"    ,cAlias,"Hr.Imp."   ,"",01,,,,,"LEFT")
//TRCell():New(_oSection1,"CHAVENF"   ,cAlias,"Hr.Imp."   ,"",50,,,,,"LEFT")
//TRCell():New(_oSection1,"STATUS_CLASS",cAlias,"Status.Class."   ,"",20,,,,,"LEFT")
//TRCell():New(_oSection1,"STATUS1",cAlias,"Status.Manifestação"   ,"",20,,,,,"LEFT")
//TRCell():New(_oSection1,"GRPTRIB",cAlias,"Grupo Tributario"   ,"",03,,,,,"LEFT")


Return(_oReport)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFATR09  ºAutor  ³ Antonio Cordeiro   º Data ³  02/10/23   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o relatorio                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(_oReport)

Local _oSection1 := _oReport:Section(1)
Local cQuery    :=""
LOCAL CanalHome:=GetMv("ST_CANHOME",,"('D3')")
LOCAL CliHome :=GetMv("ST_CLIHOME",,"('038134','036970')")


cQuery := " SELECT SC5.C5_FILIAL FILIAL ,SC5.C5_NUM PEDIDO, SC5.C5_LOJACLI LOJA, SC5.C5_XNOME NOME, SC5.C5_EMISSAO EMISSAO , SC5.C5_XDTRES XDTRES ,SC6.C6_ITEM ITEM , SC6.C6_PRODUTO PRODUTO, SC6.C6_QTDVEN QTDVEN , SC6.C6_QTDENT QTDENT , SC6.C6_BLQ BLQ  "
cQuery += " FROM "+RetSqlName("SC5")+ " SC5 "
cQuery += " INNER JOIN "+RetSqlName("SA1")+ " SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
//cQuery += " AND SA1.A1_GRPVEN = '"+CanalHome+"' "
//cQuery += " AND SA1.A1_GRPVEN IN "+CanalHome+CRLF
//IF ! Empty(CliHome)
//    cQuery += " AND SA1.A1_COD IN "+CliHome+CRLF
//ENDIF
cQuery += " INNER JOIN "+RetSqlName("SC6")+ " SC6 ON SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NUM = SC5.C5_NUM 
cQuery += " AND SC6.C6_CLI = SC5.C5_CLIENTE AND SC6.C6_LOJA = SC5.C5_LOJACLI AND SC6.D_E_L_E_T_ = ' ' "
cQuery += " AND SC6.C6_BLQ = 'R' "
cQuery += " WHERE SC5.C5_FILIAL = '"+XFILIAL('SC5')+"' "

cQuery += " AND SC5.C5_EMISSAO >= '"+DTOS(MV_PAR03)+"' "
cQuery += " AND SC5.C5_EMISSAO <= '"+DTOS(MV_PAR04)+"' "

cQuery += " AND SC5.C5_NOTA='XXXXXXXXX' "

cQuery += " AND SC5.C5_XDTRES >= '"+DTOS(MV_PAR01)+"' "
cQuery += " AND SC5.C5_XDTRES <= '"+DTOS(MV_PAR02)+"' "

cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
//cQuery += " GROUP BY SC5.C5_FILIAL,SC5.C5_NUM "
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
TCSETFIELD( cAlias, "EMISSAO", "D", 8)
TCSETFIELD( cAlias, "XDTRES", "D", 8)

_oSection1:Init()
dbSelectArea(cAlias)
dbGoTop()
While !Eof() .And. !_oReport:Cancel()

   _oReport:IncMeter()
   If _oReport:Cancel()
	  Exit
   EndIf
   //ndEmis :=alltrim(str(ddatabase-STOD(SUBSTR((cAlias)->EMISSAO,7,4)+SUBSTR((cAlias)->EMISSAO,4,2)+SUBSTR((cAlias)->EMISSAO,1,2)),10))
   //ndClass:=alltrim(str(ddatabase-STOD(SUBSTR((cAlias)->DT_CLASS,7,4)+SUBSTR((cAlias)->DT_CLASS,4,2)+SUBSTR((cAlias)->DT_CLASS,1,2)),10))
   //_oSection1:Cell("DEMISS"):SetValue(ndEmis)
   //_oSection1:Cell("DCLASS"):SetValue(ndClass)
   
   _oSection1:PrintLine()
   //_oReport:SkipLine()
   DBSKIP()
Enddo

_oSection1:Finish()

(cAlias)->( DbcloseArea())

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³oAjustaSX1ºAutor  ³ Adriano Oliveira   º Data ³  02/10/23   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajusta o Arquivo SX1 conforme necessidade do relatorio     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function oAjustaSx1()

Local _aPerg  := {}
Local _ni

Aadd(_aPerg,{"Dt Elim. De:..","mv_ch1","D",8,"G","mv_par01","","","","",""})
Aadd(_aPerg,{"Dt Elim.Até:..","mv_ch2","D",8,"G","mv_par02","","","","",""})
Aadd(_aPerg,{"Emissao De:..","mv_ch3","D",8,"G","mv_par03","","","","",""})
Aadd(_aPerg,{"Emissao Ate:..","mv_ch4","D",8,"G","mv_par04","","","","",""})


_cPerg := _cPerg + IIf(Len(SX1->X1_GRUPO)-Len(_cPerg)>0,Space(Len(SX1->X1_GRUPO)-Len(_cPerg)),"")
dbSelectArea("SX1")
For _ni := 1 To Len(_aPerg)
	If !dbSeek(_cPerg+StrZero(_ni,2))
		RecLock("SX1",.T.)
		SX1->X1_GRUPO    := _cPerg
		SX1->X1_ORDEM    := StrZero(_ni,2)
		SX1->X1_PERGUNT  := _aPerg[_ni][1]
		SX1->X1_VARIAVL  := _aPerg[_ni][2]
		SX1->X1_TIPO     := _aPerg[_ni][3]
		SX1->X1_TAMANHO  := _aPerg[_ni][4]
		SX1->X1_GSC      := _aPerg[_ni][5]
		SX1->X1_VAR01    := _aPerg[_ni][6]
		SX1->X1_DEF01    := _aPerg[_ni][7]
		SX1->X1_DEF02    := _aPerg[_ni][8]
		SX1->X1_DEF03    := _aPerg[_ni][9]
		SX1->X1_F3       := _aPerg[_ni][10]
		SX1->X1_CNT01    := _aPerg[_ni][11]
		MsUnLock()
	EndIf
Next _ni

Return

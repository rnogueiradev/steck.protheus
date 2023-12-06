#include "Protheus.ch"
#include "RwMake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#Include "TopConn.ch"
#DEFINE CR    chr(13)+chr(10)

/*====================================================================================\
|Programa  | STConsFalta    | Autor | GIOVANI.ZAGO               | Data | 29/08/2013  |
|=====================================================================================|
|Descrição | Consulta de falta													      |
|          |  													                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STConsFalta                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function STConsFalta()
*---------------------------------------------------*
Private cPerg       := 'FALTAIBL'
Private cTime       := Time()
Private cHora       := SUBSTR(cTime, 1, 2)
Private cMinutos    := SUBSTR(cTime, 4, 2)
Private cSegundos   := SUBSTR(cTime, 7, 2)
Private cAliasLif   := cPerg+cHora+ cMinutos+cSegundos
Private cAliasPed   := cPerg+cHora+ cMinutos+cSegundos
Private cAliasSal   := cPerg+cHora+ cMinutos+cSegundos
Private aSize    	:= MsAdvSize(.F.)
Private lMark   	:=  .T.
Private aVetor 		:= {}
Private aSbfLoc		:= {}
Private lSaida  	:= .F.
Private aCpoEnch	:= {}
Private nOpcA		:= 0
Private oOk	   		:= LoadBitmap( GetResources(), "LBOK" )
Private oNo	   		:= LoadBitmap( GetResources(), "LBNO" )
Private oChk
Private lRetorno    := .F.
Private lChk	 	:= .F.
Private aVetor	 	:= {}
Private oLbx
Private oLbxz
Private lInverte 	:= .F.
Private nContLin 	:= 0
Private lLote    	:= .F.
Private oDlg
Private oDlgx
Private oList
Private _nQtd   	:= 0
Private  _nMeta 	:= 0
Private oVlrSelec
Private nVlrSelec 	:= 0
Private oMarcAll
Private lMarcAll    	:= .T.
Private oMarked	 := LoadBitmap(GetResources(),'LBOK')
Private oNoMarked:= LoadBitmap(GetResources(),'LBNO')
Private oMeta
Private oPesc
Private aTam     := {}
Private cPesc    := ''
Private _cSerIbl := IIF(CFILANT='04','001','001')
Private _cFil    := IIF(CFILANT='04','02','04')
Private bFiltraBrw
Private AFILBRW    := {}
Private _cEndeStxx  := 'Endereços(SBF): '
aTam   := TamSX3("BF_LOCALIZ")
cPesc  := space(aTam[1])
cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
aFilBrw		:=	{'SF2',cCondicao}
Private cPerg       	:= "FALIBL"




Processa({|| 	STQUERY()},'Selecionando Produtos')

Processa({|| 	CompMemory()},'Compondo Faltas')

If len(aVetor) > 0
	MonTaSlec() // monta a tela
Else
	MsgInfo("Não Existe Produto Disponivel !!!!!")
EndIf


Return()

/*====================================================================================\
|Programa  | STQUERY          | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |   Executa select mediante os parametros                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STQUERY                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function STQUERY()
*-----------------------------*
Local cQuery     := ''

DbSelectArea("PA1")
PA1->(DbSetOrder(1))



cQuery := " SELECT
cQuery += ' PA1.PA1_CODPRO              "PRODUTO",
cQuery += ' B1_DESC                     "DESCRI",
cQuery += ' SUM(PA1.PA1_QUANT)          "FALTA",  

cQuery += " CASE WHEN B1_MSBLQL='1' THEN 'Bloq.' ELSE 'Libe.' END 
cQuery += ' "BLOQ"  , 
cQuery += " CASE WHEN B1_XDESAT='2' THEN 'Bloq.' ELSE 'Libe.' END 
cQuery += '  "BLOQM"  ,

cQuery += ' NVL((SELECT SUM(SC6.C6_QTDVEN - SC6.C6_QTDENT) FROM SC6010 SC6
cQuery += " WHERE SC6.C6_OPER = '88'
cQuery += ' AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0
cQuery += " AND SC6.C6_FILIAL  = '"+xFilial("SC6")+"'"
cQuery += ' AND SC6.C6_PRODUTO = PA1.PA1_CODPRO
cQuery += " AND SC6.D_E_L_E_T_ = ' ' ),0)
cQuery += ' "PEDIDO",


cQuery += ' NVL((SELECT SUM(SB2.B2_QACLASS) FROM SB2010 SB2
cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
cQuery += ' AND SB2.B2_COD = PA1.PA1_CODPRO
cQuery += " AND SB2.B2_LOCAL = '03'
cQuery += " AND SB2.B2_FILIAL   = '"+_cFil+"'"
cQuery += ' AND  SB2.B2_QACLASS > 0 ),0)    "ENDERECAR",

cQuery += " nvl((SELECT SUM(BF_QUANT)
cQuery += ' "BF_QUANT"
cQuery += " FROM "+RetSqlName('SBF')+" SBF "
cQuery += " WHERE SBF.D_E_L_E_T_ = ' '
cQuery += " AND  SBF.BF_LOCAL = '03'
cQuery += " AND SBF.BF_QUANT  > 0
cQuery += " AND SBF.BF_FILIAL = '"+xFilial("SBF")+"'"
cQuery += ' AND SBF.BF_PRODUTO = PA1.PA1_CODPRO ),0) "SALDO",
//cQuery += " GROUP BY BF_PRODUTO,BF_LOCAL,BF_FILIAL
//cQuery += " AND TBF.BF_PRODUTO = PA1.PA1_CODPRO


//cQuery += ' SUM(TBF.BF_QUANT)           "SALDO",
//cQuery += " SUM(TBF.BF_QUANT)-
cQuery += " nvl((SELECT SUM(BF_QUANT)
cQuery += ' "BF_QUANT"
cQuery += " FROM "+RetSqlName('SBF')+" SBF "
cQuery += " WHERE SBF.D_E_L_E_T_ = ' '
cQuery += " AND  SBF.BF_LOCAL = '03'
cQuery += " AND SBF.BF_QUANT  > 0
cQuery += " AND SBF.BF_FILIAL = '"+xFilial("SBF")+"'"
cQuery += ' AND SBF.BF_PRODUTO = PA1.PA1_CODPRO ),0) -

cQuery += ' NVL((SELECT SUM(PA2_QUANT)  "PA2_QUANT"
cQuery += "  FROM PA2010 PA2
cQuery += " WHERE PA2.D_E_L_E_T_ = ' '
cQuery += " AND PA2.PA2_FILIAL   = '"+xFilial("PA2")+"'"
cQuery += " AND PA2.PA2_FILRES   = '"+xFilial("PA1")+"'"
cQuery += " AND PA2.PA2_CODPRO   = PA1.PA1_CODPRO
cQuery += ' GROUP BY PA2.PA2_CODPRO),0) "DISPONIVEL"

cQuery += " FROM "+RetSqlName('PA1')+" PA1 "
/*
cQuery += " INNER JOIN(SELECT BF_PRODUTO,BF_LOCAL,BF_FILIAL,SUM(BF_QUANT)
cQuery += ' "BF_QUANT"
cQuery += " FROM "+RetSqlName('SBF')+" SBF "
cQuery += " WHERE SBF.D_E_L_E_T_ = ' '
cQuery += " AND  SBF.BF_LOCAL = '03'
cQuery += " AND SBF.BF_QUANT  > 0
cQuery += " AND SBF.BF_FILIAL = '"+xFilial("SBF")+"'"
cQuery += " GROUP BY BF_PRODUTO,BF_LOCAL,BF_FILIAL   )TBF
cQuery += " ON TBF.BF_PRODUTO = PA1.PA1_CODPRO
*/
cQuery += " INNER JOIN (SELECT *
cQuery += " FROM "+RetSqlName('SB1')+" )SB1 "
cQuery += " ON SB1.B1_COD = PA1.PA1_CODPRO
cQuery += " AND SB1.D_E_L_E_T_ = ' '


cQuery += " WHERE PA1.D_E_L_E_T_ = ' '
cQuery += " AND PA1.PA1_FILIAL   = '"+_cFil+"'"
cQuery += " and nvl((SELECT SUM(BF_QUANT)
cQuery += ' "BF_QUANT"
cQuery += " FROM "+RetSqlName('SBF')+" SBF "
cQuery += " WHERE SBF.D_E_L_E_T_ = ' '
cQuery += " AND  SBF.BF_LOCAL = '03'
cQuery += " AND SBF.BF_QUANT  > 0
cQuery += " AND SBF.BF_FILIAL = '"+xFilial("SBF")+"'"
cQuery += ' AND SBF.BF_PRODUTO = PA1.PA1_CODPRO ),0) > 0


If CFILANT = '02'
	cQuery += " AND PA1.PA1_TIPO     = '2'
EndIf


cQuery += " GROUP BY PA1.PA1_CODPRO,SB1.B1_DESC,SB1.B1_MSBLQL ,SB1.B1_XDESAT
cQuery += " ORDER BY FALTA




cQuery := ChangeQuery(cQuery)

DbCommitAll()
If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif,.T.,.T.)


Return()


/*====================================================================================\
|Programa  | CompMemory       | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |    crio o avetor                                                         |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | CompMemory                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function CompMemory()
*-----------------------------*
 Local _lBloq := .T.
dbSelectArea(cAliasLif)
(cAliasLif)->(dbGoTop())
ProcRegua(RecCount()) // Numero de registros a processar
_nQtd:=0
While !(cAliasLif)->(Eof())
	If (	(cAliasLif)->FALTA -((cAliasLif)->ENDERECAR+(cAliasLif)->PEDIDO) )> 0
		_nQtd++
		IncProc() 
	   If 	(cAliasLif)->DISPONIVEL<=0
		_lBloq := .F.     
		EndIf
		 If 	(cAliasLif)->BLOQ = 'Bloq.'  .Or. 	(cAliasLif)->BLOQM =   'Bloq.'
		_lBloq := .F.     
		EndIf
		
		aadd(aVetor ,{ _lBloq,;
		(cAliasLif)->PRODUTO ,; //01 PRODUTO
		(cAliasLif)->DESCRI		 ,;	//02   DESCRI
		(cAliasLif)->FALTA		 ,;	//03   FALTA
		(cAliasLif)->PEDIDO		 ,;	//04   PEDIDO
		(cAliasLif)->ENDERECAR		 ,;	//05   ENDEREÇAR
		(cAliasLif)->FALTA -((cAliasLif)->ENDERECAR+(cAliasLif)->PEDIDO)		 ,;	//06   FALTA REAL
		(cAliasLif)->SALDO		 ,;	//07   SALDO
		(cAliasLif)->DISPONIVEL	 ,;	//08   DISPONIVEL
		(cAliasLif)->BLOQ	 ,;    //09 BLOQ
		(cAliasLif)->BLOQM	 ,;         //10 BLOQ MARKTING
		IIF(   ((cAliasLif)->FALTA -((cAliasLif)->ENDERECAR+(cAliasLif)->PEDIDO)) <=	(cAliasLif)->DISPONIVEL,(	(cAliasLif)->FALTA -((cAliasLif)->ENDERECAR+(cAliasLif)->PEDIDO)),	(cAliasLif)->DISPONIVEL) ,;         //À Gerar
					})
	EndIf
	
	_lBloq := .T.
	
	(cAliasLif)->(dbSkip())
End


Return()

/*====================================================================================\
|Programa  | MonTaSlec        | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MonTaSlec                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function MonTaSlec()
*-----------------------------*

Local aButtons := {{"LBTIK",{|| U_StFAlRel(aVetor)} ,"Imprimir Rel."} }
   If cfilant = '02'
   aButtons := {{"LBTIK",{|| Processa({|| 	GeraPed()},'Gerando Pedido.....!!!!!')  } ,"Gerar Pedido"},{"LBTIK",{|| U_StFAlRel(aVetor)} ,"Imprimir Rel."} }
   EndIf
_nMeta:=_nQtd
Do While !lSaida
	nOpcao := 0
	
	Define msDialog odlg title "Consulta Falta" From 0,0 To aSize[6]-15,aSize[5]-15  PIXEL OF oMainWnd //from 178,181 to 590,1100 pixel
	
	cLinOk    :="AllwaysTrue()"
	cTudoOk   :="AllwaysTrue()"//'STxGRV()'
	aCpoEnchoice:={'NOUSER'}
	aAltEnchoice := {}
	
	Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
	bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
	Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0
	
	@ 010,010 say "Quantidade( Produtos ) :"   Of odlg Pixel
	@ 010,080 msget  _nQtd picture "@E 999,999" when .f. size 55,013  Of odlg Pixel
	@ 025,010 say "Selecionados:"   Of odlg Pixel
	@ 025,080 msget  oVlrSelec Var _nMeta picture "@E 999,999" when .f. size 55,013 	 Of odlg Pixel
	
	@ 010,200 say "Pesquisar:"   Of odlg Pixel
	@ 010,230 msget  oPesc Var cPesc   when .t. size 45,013   valid (fpesc(cPesc))	 Of odlg Pixel
	
	//Cria a listbox
	@ 040,000 listbox oLbx fields header '',"Produto", "Descrição",'Falta('+_cFil+')','Pedido','Endereçar','Falta Real','Saldo('+xFilial("PA1")+')','Disponivel('+xFilial("PA1")+')','Bloq.','BloqM','à Gerar','.'   size  aSize[3]-05,255 of oDlg pixel on dbLclick(edlista(oLbx:nat,oVlrSelec))
	
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
	aVetor[oLbx:nAt,2],;
	aVetor[oLbx:nAt,3],;
	aVetor[oLbx:nAt,4],;
	aVetor[oLbx:nAt,5],;
	aVetor[oLbx:nAt,6],;
	aVetor[oLbx:nAt,7],;
	aVetor[oLbx:nAt,8],;
	aVetor[oLbx:nAt,9],;
	aVetor[oLbx:nAt,10],;
	aVetor[oLbx:nAt,11],; 
	aVetor[oLbx:nAt,12],;
	' '	}}
	
	//	@ aSize[4]-28 ,005 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg on CLICK(aEval(aVetor,{|x| x[1]:=lChk}),fMarca(),oLbx:Refresh())
	
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||nOpca:=1,lSaida:=.t.,oDlg:End()}	,{|| nOpca := 0,lSaida:=.t.,oDlg:End()},,aButtons)
	
End
If nOpca =1
	//	If MSGYESNO("Deseja Gerar o Pedido de Transferencia Com os Endereços Selecionados ?")
	//	Processa({|| 	GeraPed()},'Gerando Pedido .......')
	//	EndIf
EndIf
Return()


/*====================================================================================\
|Programa  | EdLista          | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | EdLista                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function EdLista()
*-----------------------------*
Local b

_nMeta:=0    
If aVetor[oLbx:nAt,9]  > 0  .Or. aVetor[oLbx:nAt,10] = '1'  .Or. aVetor[oLbx:nAt,11] = '2'
aVetor[oLbx:nAt,1]	:= !aVetor[oLbx:nAt,1] 
EndIf 
If  aVetor[oLbx:nAt,10] = 'B'  .Or. aVetor[oLbx:nAt,11] = 'B'
aVetor[oLbx:nAt,1]	:= !aVetor[oLbx:nAt,1] 
EndIf
for b:= 1 to Len(aVetor)
	
	If aVetor[b,1]  
		_nMeta++
	EndIf
	
next b

oVlrSelec:Refresh()
oLbx:Refresh()
oDlg:Refresh()
Return ()


/*====================================================================================\
|Programa  | fpesc            | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | fpesc                                                                    |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function fpesc(_cXPesc)
*-----------------------------*
local b
Local _lRex := .f.

If !(Empty(Alltrim(_cXPesc)))
	for b:= 1 to Len(aVetor)
		
		If UPPER(ALLTRIM(aVetor[b,2]))   =  UPPER(ALLTRIM(_cXPesc) )
			_lRex:= .T.
		EndIf
	next b
	
Else
	_lRex:= .T.
EndIf
If _lRex .And. !(Empty(Alltrim(_cXPesc)))
	oLbx:nAt:= aScan(aVetor, {|x| Upper(AllTrim(x[2])) == UPPER(Alltrim(_cXPesc))})
EndIf
oLbx:Refresh()
oDlg:Refresh()
opesc:Refresh()
Return( _lRex )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  StFAlRel     ºAutor  ³Giovani Zago    º Data ³  10/07/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de Expedição                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function StFAlRel()
*-----------------------------*
Local   oReport
Private cPerg 			:= "RFALTA"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.


PutSx1( cPerg, "01","Data?"			,"","","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")

oReport		:= ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New(cPerg,"RELATÓRIO PRODUTOS COM FALTA",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Falta .")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Análise  Expedição",{"SC5"})


TRCell():New(oSection,"Produto"			,,"Produto"			,,09,.F.,)
TRCell():New(oSection,"Descricao"		,,"Descricao"		,,50,.F.,)
TRCell():New(oSection,"Falta" 			,,"Falta"			,"@E 99,999,999.99",14)
TRCell():New(oSection,"Pedido" 			,,"Pedido"			,"@E 99,999,999.99",14)
TRCell():New(oSection,"Enderecar" 		,,"Enderecar"		,"@E 99,999,999.99",14)
TRCell():New(oSection,"Real" 		    ,,"Real"			,"@E 99,999,999.99",14)
TRCell():New(oSection,"Saldo" 			,,"Saldo"			,"@E 99,999,999.99",14)
TRCell():New(oSection,"Disponivel" 		,,"Disponivel"		,"@E 99,999,999.99",14)
TRCell():New(oSection,"Bloq" 			,,"Bloq"			,,05,.F.,)
TRCell():New(oSection,"BloqM" 		    ,,"BloqM"		    ,,05,.F.,)
TRCell():New(oSection,"Gerar" 		,,"Gerar"		,"@E 99,999,999.99",14)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("DA1")

Return oReport

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local nX			:= 0
Local cQuery 	:= ""
Local cAlias 		:= "QRYTEMP9"
Local aDados[2]
Local aDados1[11]
Local b		:= 0

oSection1:Cell("Produto")       :SetBlock( { || aDados1[01] } )
oSection1:Cell("Descricao")		:SetBlock( { || aDados1[02] } )
oSection1:Cell("Falta")			:SetBlock( { || aDados1[03] } )
oSection1:Cell("Pedido")		:SetBlock( { || aDados1[04] } )
oSection1:Cell("Enderecar")		:SetBlock( { || aDados1[05] } )
oSection1:Cell("Real")   	  	:SetBlock( { || aDados1[06] } )
oSection1:Cell("Saldo")			:SetBlock( { || aDados1[07] } )
oSection1:Cell("Disponivel")	:SetBlock( { || aDados1[08] } )
oSection1:Cell("Bloq")			:SetBlock( { || aDados1[09] } )
oSection1:Cell("BloqM")			:SetBlock( { || aDados1[10] } )
oSection1:Cell("Gerar")			:SetBlock( { || aDados1[11] } )

oReport:SetTitle("Análise de Produtos com Falta")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()

If  Len(aVetor) > 0
	for b:= 1 to Len(aVetor)
		
		aDados1[01]	:=	aVetor[b,2]
		aDados1[02]	:=	aVetor[b,3]
		aDados1[03]	:=	aVetor[b,4]
		aDados1[04]	:=	aVetor[b,5]
		aDados1[05]	:=	aVetor[b,6]
		aDados1[06]	:=	aVetor[b,7]
		aDados1[07]	:=	aVetor[b,8]
		aDados1[08]	:=	aVetor[b,9]
		aDados1[09]	:=	aVetor[b,10]
		aDados1[10]	:=	aVetor[b,11] 
		aDados1[11]	:=	aVetor[b,12] 
		oSection1:PrintLine()
		aFill(aDados1,nil)
		
	next b
	
EndIf

oReport:SkipLine()

Return oReport

/*====================================================================================\
|Programa  | GeraPed          | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |   msexecauto                                                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | GeraPed                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function GeraPed( )
*-----------------------------*
Local aCabec     := {}
Local aItens     := {}
Local aLogErr    := {}
Local cNumPed    := GetSX8Num("SC5","C5_NUM")
Local _nxSaldo   := 0
Local _nxEnd     := 0
Local _cmsg      := ' '
Local nTam       := 0
Local b
Local _nIt       := 0
Local _nQtd       := 0
Private lMsErroAuto     := .F.
Private lMsHelpAuto     := .T.

//RollBAckSx8()
ProcRegua(4) // Numero de registros a processar
IncProc()

aAdd(aCabec, {"C5_NUM"		,     cNumPed						,Nil}) // Numero do Pedido
aAdd(aCabec, {"C5_TIPO"		,"N"								,Nil}) // Tipo do Pedido
aAdd(aCabec, {"C5_CLIENTE"	,"033467"							,Nil}) // Codigo do Cliente
aAdd(aCabec, {"C5_LOJACLI"	,IIF(CFILANT='04','02','03')		,Nil}) // Loja do Cliente
aAdd(aCabec, {"C5_CLIENT"	,"033467"							,Nil}) // Codigo do Cliente para entrega
aAdd(aCabec, {"C5_LOJAENT"	,IIF(CFILANT='04','02','03')		,Nil}) // Loja para entrega
aAdd(aCabec, {"C5_TIPOCLI"	,"F"								,Nil}) // Tipo do Cliente
aAdd(aCabec, {"C5_CONDPAG"	,"501"								,Nil}) // Condicao de pagamanto
aAdd(aCabec, {"C5_EMISSAO"	,dDatabase							,Nil}) // Data de Emissao
aAdd(aCabec, {"C5_ZCONDPG"	,"501"								,Nil}) // COND PG
aAdd(aCabec, {"C5_TABELA"	,IIF(CFILANT='04',"001",'') 		,Nil}) // TABELA
aAdd(aCabec, {"C5_VEND1"	,IIF(CFILANT='04',"R00099",'E00006'),Nil}) //VENDEDOR 1
aAdd(aCabec, {"C5_TPFRETE"	,"C"								,Nil}) // Moeda
aAdd(aCabec, {"C5_XTIPO"	,"2"								,Nil}) // Moeda C5_XTIPO
aAdd(aCabec, {"C5_XTIPF"	,"1"								,Nil}) // Moeda C5_XTIPO   C5_XTIPF




IncProc()
For b:= 1 To Len(aVetor)
	
	If aVetor[b,1]
		
		
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+aVetor[b,2]))
		_nxSaldo:= Sb2Saldo()
		_nxSaldo:= (_nxSaldo/0.82)
		If _nxSaldo <= 0
			_nxSaldo:= 0.02
		Endif
		// Itens
		_nIt++
		If aVetor[b,7] <= aVetor[b,9]
			_nQtd:=aVetor[b,7]
		Else
			_nQtd:=aVetor[b,9]
		Endif
		If _nQtd > 0
			Aadd(aItens,{{"C6_ITEM"		,PadR(StrZero(_nIt,2),2)								,Nil},; // Numero do Item no Pedido
			{"C6_PRODUTO"	,aVetor[b,2]														,Nil},; // Codigo do Produto
			{"C6_UM"   		,SB1->B1_UM  														,Nil},; // Unidade de Medida Primar.
			{"C6_QTDVEN"	,_nQtd 																,Nil},; // Quantidade Vendida
			{"C6_PRCVEN"	,_nxSaldo								  							,Nil},; // Preco Venda
			{"C6_PRUNIT"	,_nxSaldo															,Nil},; // Preco Unitario
			{"C6_VALOR"		,round(_nxSaldo*_nQtd,2)			 						   		,Nil},; // Valor Total do Item
			{"C6_TES"		,"664"																,Nil},; // Tipo de Entrada/Saida do Item
			{"C6_LOCAL"		,"03"																,Nil},; // Almoxarifado
			{"C6_CLI"		,"033467"															,Nil},; // Cliente
			{"C6_OPER"		,"88"																,Nil},; // OPERAÇÃO
			{"C6_ENTRE1"	,dDataBase															,Nil}}) // Data da Entrega
			
		EndIf
		_nxSaldo:= 0
	EndIf
	
Next b
IncProc()
If len(aItens) > 0
	Begin Transaction
	MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aItens, 3)
	End Transaction
	IncProc()
	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
	Else
		Reclock("SC5",.F.)
		Replace C5_ZOBS With "Rotina de Transferencia"
		MsUnlock()
		
		MsgInfo("Pedido gerado com Sucesso n°: "+SC5->C5_NUM)
		aVetor:={}
		Processa({|| 	STQUERY()},'Selecionando Produtos')
		
		Processa({|| 	CompMemory()},'Compondo Faltas')
		
		oLbx:nAt:=0
		oLbx:SetArray( aVetor )
		oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
		aVetor[oLbx:nAt,2],;
		aVetor[oLbx:nAt,3],;
		aVetor[oLbx:nAt,4],;
		aVetor[oLbx:nAt,5],;
		aVetor[oLbx:nAt,6],;
		aVetor[oLbx:nAt,7],;
		aVetor[oLbx:nAt,8],;
		aVetor[oLbx:nAt,9],;
		aVetor[oLbx:nAt,10],;
		aVetor[oLbx:nAt,11],;
		' '	}}
		
		oLbx:Refresh()
		oDlg:Refresh()
		opesc:Refresh()
	EndIf 
EndIf
Return ()

/*====================================================================================\
|Programa  | Sb2Saldo            | Autor | GIOVANI.ZAGO          | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  Retorna saldo do sb2(custo)                                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | Sb2Saldo                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------*
Static Function Sb2Saldo()
*---------------------------*
Local _aArea	:= GetArea()
Local cQuery     := ' '
Local  _nQut    := 0
Local  _nVal    := 0
Local  _nCust    := 0
cPerg       := 'SALDO'
cTime       := Time()
cHora       := SUBSTR(cTime, 1, 2)
cMinutos    := SUBSTR(cTime, 4, 2)
cSegundos   := SUBSTR(cTime, 7, 2)
cAliasSal   := cPerg+cHora+ cMinutos+cSegundos




cQuery := " SELECT B2_COD, B2_LOCAL,B2_FILIAL,B2_QATU,B2_VATU1 ,B2_CMFIM1
cQuery += " FROM "+RetSqlName("SB2")+" SB2 "
cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
cQuery += " AND   SB2.B2_COD   = '"+SB1->B1_COD+"'"
cQuery += " AND   SB2.B2_LOCAL = '"+SB1->B1_LOCPAD+"'"
cQuery += " AND   SB2.B2_FILIAL= '"+xFilial("SB2")+"'"
cQuery += " ORDER BY SB2.R_E_C_N_O_



cQuery := ChangeQuery(cQuery)

If Select(cAliasSal) > 0
	(cAliasSal)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSal)
dbSelectArea(cAliasSal)
If  Select(cAliasSal) > 0
	(cAliasSal)->(dbgotop())
	While (cAliasSal)->(!Eof())
		_nCust  := (cAliasSal)->B2_CMFIM1
		(cAliasSal)->(DbSkip())
	End
EndIf



If Select(cAliasSal) > 0
	(cAliasSal)->(dbCloseArea())
EndIf

RestArea(_aArea)
Return(round(_nCust,2))


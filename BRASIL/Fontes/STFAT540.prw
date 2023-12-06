#include "TOTVS.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TOPCONN.CH"

//----------------------------------------------------------------------------------//
//Programa : STFAT540  - Autoria: Flávia Rocha - Data   : 30/05/2022 
//Objetivo : Tela para liberação em massa de pedidos de venda
//Cliente  : Daniel Santos - Ticket #20220525010909
//----------------------------------------------------------------------------------//
User Function STFAT540()

Local aArea   := {}
Local lRet    := .T.
Local aTpFrete:= {"C=CIF",;
				  "F=FOB",;
				  "T=Todos"}

Local aAlerta := {"A=Com Alerta",;
				  "S=Sem Alerta",;
				  "T=TODOS"}

Local aOrdem := {"1=Maior p/ Menor",;
				 "2=Menor p/ Maior"}				

Private aRet	:= {}
Private aParam	:= {}
Private aDadosT := [99]
Private aDadosR := {}
Private aDados1 := {}

aArea   := GetArea()

aAdd(aParam	,{1, "Pedido De:"  					, SPACE(TamSX3('C5_NUM')[01])		, "", "", "SC5", "", 80, .F.})
aAdd(aParam	,{1, "Pedido Até:" 					, Repli("Z",TamSX3('C5_NUM')[01])	, "", "", "SC5", "", 80, .T.})
AAdd(aParam, {2, "Tipo de Frete:"				,	"A"    							,aTpFrete,	100, "AllwaysTrue()"		,	.T.})
AAdd(aParam, {2, "Filtra Alerta Faturamento"	,	"T"     						,aAlerta,	100, "AllwaysTrue()"		,	.T.})
AAdd(aParam, {2, "Ordem de Valores"				,	"1"     						,aOrdem,	100, "AllwaysTrue()"		,	.T.})
aAdd(aParam	,{1, "Cliente De:"  				, SPACE(TamSX3('A1_COD')[01])		, "", "", "SA1", "", 80, .F.})
aAdd(aParam	,{1, "Cliente Até:" 				, Repli("Z",TamSX3('A1_COD')[01])	, "", "", "SA1", "", 80, .F.})
aAdd(aParam	,{1, "Vlr. Reservado A partir:"		, 999999999999						, "", "", ""   , "", 80,.F.})
aAdd(aParam	,{1, "Selecionar o Canal:" 			, SPACE(250)	, "", "", "GRPF3", "", 120, .F.})


	If !ParamBox(aParam,"Parâmetros", @aRet,,,,,,,,.F.,.F.)
		MsgInfo("Operação Cancelada Pelo Operador")
		Return
	EndIf



Processa( {|| MONTAPVBRW() }, "Aguarde...", "Reunindo Dados de Pedidos...",.F.)		

RestArea(aArea)

Return(lRet)

//----------------------------------------------------------------------------------//
//Função  : MONTAPVBRW - Reúne dados de pedidos via query para a Tela MarkBrowse
//Autoria  : Flávia Rocha
//Data     : 30/05/2022 
//----------------------------------------------------------------------------------//
Static Function MONTAPVBRW()

Local aArea     := GetArea()
Local lRet      := .F.
Local lTMP      := .F.
Local cQuery    := ""
Local cPedDe    := ""
Local cPedAte   := "" 
Local cTpFrete  := ""
Local cAlertaFat:= ""
Local cOrdem    := ""
Local cCliDe    := ""
Local cCliAte   := ""
Local nVallimite:= 0
Local cCanal    :=""


Private oTempTable
Private cGetAlias := "TMPHF"
Private cArq      := ""
Private oFont01   := TFont():New("Arial",07,14,,.T.,,,,.T.,.F.)
Private cTabela   := ""
Private cWhere    := ""
Private cOrder    := ""
Private cCampos   := ""
Private cMarcaOK  := GetMark()

//-------------------
//Criação do objeto
//-------------------
oTempTable := FWTemporaryTable():New( cGetAlias )

lTMP := CriaTMP()

If !lTMP
   U_MyAviso("Erro","Não foi possível criar o Arquivo Temporário."+CRLF+;
	"Verifique suas permissõess e tente novamente.",{"OK"},1)	
	RestArea(aArea)	
	Return(.F.)	
Endif


cPedDe      := aRet[1]
cPedAte     := aRet[2]
cTpFrete    := aRet[3]
cAlertaFat  := aRet[4]
cOrdem      := aRet[5]
cCliDe      := aRet[6]
cCliAte     := aRet[7]
nVallimite  := aRet[8]
cCanal      := aRet[9]


//MONTA MASSA DE DADOS: 
cQuery := " SELECT "        + CRLF 

cQuery += " C5_FILIAL, C5_NUM, A1_COD,A1_NOME,C5_XPRIORI,  " + CRLF 

cQuery += " CASE WHEN C5_XTIPF = '1' then '1-TOTAL'  ELSE '2-PARCIAL' END AS C5_XTIPF, " + CRLF

//cQuery += " C5_XSTARES , "  + CRLF 
//C5_XSTARES - Status Reserva Steck: 0=Nao Controla; 1=Atendido; 2=Nao Atendido; 3=Dependencia DF; 4=Parcial                                                             
cQuery += " CASE WHEN C5_XSTARES = '0' THEN '0-NAO CONTROLA RESERVA' 		ELSE " + CRLF
cQuery += " CASE WHEN C5_XSTARES = '1' THEN '1-RESERVA ATENDIDA'     		ELSE " + CRLF
cQuery += " CASE WHEN C5_XSTARES = '2' THEN '2-RESERVA NAO ATENDIDA' 		ELSE " + CRLF
cQuery += " CASE WHEN C5_XSTARES = '3' THEN '3-RESERVA DEPENDE DF'   		ELSE " + CRLF
cQuery += " CASE WHEN C5_XSTARES = '4' THEN '4-RESERVA ATENDIDA PARCIAL'	END END END END END AS C5_XSTARES, " + CRLF

cQuery += " C5_XBLQFMI , "  + CRLF

cQuery += " SUM(CASE WHEN NVL(PA2_QUANT,-1)<0 THEN 0 ELSE ROUND((C6_ZVALLIQ/C6_QTDVEN) * PA2_QUANT,2) END) AS RESERVADO, " + CRLF

cQuery += " C5_XAANO||C5_XMATE||C5_XATE AS XC5MATE , " + CRLF
cQuery += " C5_XTIPF, " + CRLF
cQuery += " substr(C5_XPRIORI,1,1) as ERA," + CRLF
cQuery += " C5_ZREFNF,C5_XALERTF,

cQuery += " C5_TPFRETE, " + CRLF
//cQuery += " CASE WHEN C5_TPFRETE = 'C' THEN 'C-CIF' ELSE 'F-FOB' END AS C5_TPFRETE ," + CRLF + CRLF

cQuery += " C5_EMISSAO, C5_XDTEN, " + CRLF
cQuery += " sum(C6_QTDENT) as PARCIAL, " + CRLF
cQuery += " SUM(C6_VALOR) AS TOTAL ,  " + CRLF
cQuery += " SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END) AS NET, " + CRLF
cQuery += " SUM(PA2_QUANT) AS PA2QUANT, " + CRLF
cQuery += " SUM(CASE WHEN NVL(PA2_QUANT,-1)< 0 THEN 0 ELSE ROUND((C6_ZVALLIQ/C6_QTDVEN)*PA2_QUANT,2) END) AS RESERVADO, " + CRLF
cQuery += " SUM(CASE WHEN NVL(PA1_QUANT,-1)< 0 THEN 0 ELSE ROUND((C6_ZVALLIQ/C6_QTDVEN)*PA1_QUANT,2) END) AS FALTA " + CRLF


cQuery += " FROM " + RetSqlName("SC6") + " SC6 " + CRLF

cQuery += " INNER JOIN (SELECT * FROM " + RetSqlName("SB1") + ") SB1 " + CRLF
cQuery += " ON SB1.D_E_L_E_T_ = ' ' " + CRLF
cQuery += " AND SB1.B1_COD = SC6.C6_PRODUTO " + CRLF
cQuery += " AND SB1.B1_FILIAL = ' ' " + CRLF

cQuery += " INNER JOIN (SELECT * FROM " + RetSqlName("SBM") +") SBM " + CRLF
cQuery += " ON SBM.D_E_L_E_T_ = ' ' " + CRLF
cQuery += " AND SB1.B1_GRUPO = SBM.BM_GRUPO " + CRLF

cQuery += " INNER JOIN (SELECT * FROM " + RetSqlName("SC5") + ") SC5 " + CRLF
cQuery += " ON SC5.D_E_L_E_T_ = ' ' " + CRLF
cQuery += " AND SC5.C5_NUM = SC6.C6_NUM " + CRLF
cQuery += " AND SC5.C5_FILIAL = SC6.C6_FILIAL " + CRLF
//cQuery += " --AND C5_TPFRETE = 'C' " + CRLF
//cQuery += " --AND C5_XPRIORI <> '99999999999999' " + CRLF

cQuery += " INNER JOIN(SELECT * FROM " + RetSqlName("SA1") + ") SA1 " + CRLF
cQuery += " ON SA1.D_E_L_E_T_ = ' ' " + CRLF
cQuery += " AND A1_COD = C5_CLIENTE " + CRLF
cQuery += " AND A1_LOJA = C5_LOJACLI " + CRLF
cQuery += " AND A1_FILIAL = ' ' " + CRLF
IF !Empty(cCanal)
   cQuery += " AND TRIM(A1_GRPVEN) IN ("+alltrim(cCanal)+") "
ENDIF   

cQuery += " LEFT JOIN (SELECT * FROM " + RetSqlName("PC1") + " ) PC1 ON C6_NUM = PC1.PC1_PEDREP AND PC1.D_E_L_E_T_ = ' ' " + CRLF
cQuery += " LEFT JOIN (SELECT * FROM " + RetSqlName("PA2") + " ) PA2 " + CRLF
cQuery += " ON PA2.D_E_L_E_T_ = ' ' " + CRLF
cQuery += " AND PA2.PA2_FILIAL = ' ' " + CRLF
cQuery += " AND PA2_DOC = C6_NUM||C6_ITEM " + CRLF

cQuery += " LEFT JOIN (SELECT * FROM " + RetSqlName("PA1") + ") PA1 " + CRLF
cQuery += " ON PA1.D_E_L_E_T_ = ' ' " + CRLF
cQuery += " AND PA1.PA1_FILIAL = '02' " + CRLF
cQuery += " AND PA1_DOC = C6_NUM||C6_ITEM " + CRLF

cQuery += " INNER JOIN (SELECT * FROM " + RetSqlName("SF4") + " ) SF4 ON SC6.C6_TES = SF4.F4_CODIGO " + CRLF
cQuery += " AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' " + CRLF

cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' " + CRLF
cQuery += " AND SC6.C6_FILIAL = '01' " + CRLF
cQuery += " AND SC5.C5_TIPO = 'N' " + CRLF
cQuery += " AND SA1.A1_GRPVEN <> 'ST' " + CRLF
cQuery += " AND SA1.A1_EST <> 'EX' " + CRLF
cQuery += " AND PC1.PC1_PEDREP IS NULL " + CRLF
cQuery += " AND C6_QTDVEN > C6_QTDENT " + CRLF
cQuery += " AND C6_BLQ <> 'R' " + CRLF
cQuery += " AND C5_CLIENTE NOT IN ('038134','014519','028358','092887','092187','053211') " + CRLF

//parâmetros para filtro: 
cQuery += " AND (C5_XAANO||C5_XMATE||C5_XATE <= '" + DTOS(Date()) + "' OR C5_XAANO||C5_XMATE||C5_XATE=' ') " + CRLF

cQuery += " AND C5_NUM >= '" + cPedDe  + "' AND C5_NUM <= '" + cPedAte + "' " + CRLF

If Alltrim(cTpFrete) <> "T"
	cQuery += " AND C5_TPFRETE = '" + cTpFrete  + "' " + CRLF
Endif

If !Empty(cCliAte)
	cQuery += " AND C5_CLIENTE >= '" + cCliDe + "' AND C5_CLIENTE <= '" + cCliAte + "' " + CRLF 
Endif 

If Alltrim(cAlertaFat) <> "T"
	If cAlertaFat == "A"
		cQuery += " AND C5_XALERTF <> '' " + CRLF 
	Else
		cQuery += " AND C5_XALERTF = '' " + CRLF
	Endif 
Endif 

cQuery += " GROUP BY " + CRLF

cQuery += " C5_XTIPF , "    + CRLF
cQuery += " C5_XSTARES , "  + CRLF 
cQuery += " C5_XBLQFMI , "  + CRLF
cQuery += " A1_COD,A1_NOME,C5_XPRIORI, C5_FILIAL, C5_NUM,C5_TPFRETE,C5_XAANO||C5_XMATE||C5_XATE,C5_XTIPF,C5_ZREFNF," + CRLF
cQuery += " C5_XALERTF, C5_EMISSAO, C5_XDTEN " + CRLF
cQuery += " ORDER BY " + CRLF

If cOrdem == "1" //do maior para menor coluna "RESERVADO"
	
	cQuery += " SUM(CASE WHEN NVL(PA2_QUANT,-1)<0 THEN 0 ELSE ROUND((C6_ZVALLIQ/C6_QTDVEN) * PA2_QUANT,2) END) DESC, " + CRLF 
	
Else 
	
	cQuery += " SUM(CASE WHEN NVL(PA2_QUANT,-1)<0 THEN 0 ELSE ROUND((C6_ZVALLIQ/C6_QTDVEN) * PA2_QUANT,2) END) , " + CRLF 
Endif 

cQuery += " C5_FILIAL, C5_NUM " + CRLF 


MemoWrite("C:\TEMP\FRTELALIB.TXT" , cQuery)

cQuery := ChangeQuery(cQuery)


If ( SELECT("TRBAC2") ) > 0
	dbSelectArea("TRBAC2")
	TRBAC2->(dbCloseArea())
EndIf

TcQuery cQuery Alias "TRBAC2" New

dbSelectArea("TRBAC2")
TRBAC2->(dbGoTop())



If TRBAC2->( !EOF() )
	While TRBAC2->( !EOF() )

		lRet := .T. //indica que há dados	
				
		If TRBAC2->RESERVADO >= nVallimite  //valor teto máximo para a coluna "RESERVADO"

			DbSelectArea( "TMPHF" )
			RecLock( "TMPHF", .T. )

			/*
			//qdo liberar , gravar o seguinte conteudo nestes campos: 
			C5_XTIPF = '2'
			C5_XSTARES ='4'
			C5_XBLQFMI = 'N'
			*/

			TMPHF->OK           := " "
			If '2' $ TRBAC2->C5_XTIPF .AND. '4' $ TRBAC2->C5_XSTARES .AND. TRBAC2->C5_XBLQFMI == 'N' //JÁ LIBERADO
				TMPHF->ST := "1"
			Else 
				TMPHF->ST := " "  //status se já liberou ou não
			Endif 
			TMPHF->C5_XTIPF     := TRBAC2->C5_XTIPF
			TMPHF->C5_XSTARES   := TRBAC2->C5_XSTARES 
			TMPHF->C5_XBLQFMI   := TRBAC2->C5_XBLQFMI

			TMPHF->RESERVADO    := TRBAC2->RESERVADO
			TMPHF->A1_COD       := TRBAC2->A1_COD
			TMPHF->A1_NOME      := TRBAC2->A1_NOME
			TMPHF->C5_XPRIORI   := TRBAC2->C5_XPRIORI
			TMPHF->C5_FILIAL    := TRBAC2->C5_FILIAL
			TMPHF->C5_NUM       := TRBAC2->C5_NUM
			TMPHF->XC5MATE      := Stod( TRBAC2->XC5MATE )
			TMPHF->ERA          := TRBAC2->ERA
			TMPHF->C5_ZREFNF    := TRBAC2->C5_ZREFNF
			TMPHF->C5_XALERTF   := TRBAC2->C5_XALERTF
			
			If TRBAC2->C5_TPFRETE == 'C' 
				TMPHF->C5_TPFRETE := 'C-CIF' 
			Else 
				TMPHF->C5_TPFRETE := 'F-FOB'
			Endif 
			
			TMPHF->C5_EMISSAO   := Stod( TRBAC2->C5_EMISSAO )
			TMPHF->C5_XDTEN     := Stod( TRBAC2->C5_XDTEN   )
			TMPHF->PARCIAL      := TRBAC2->PARCIAL
			TMPHF->TOTAL        := TRBAC2->TOTAL 
			TMPHF->NET          := TRBAC2->NET 
			TMPHF->PA2QUANT     := TRBAC2->PA2QUANT
			TMPHF->FALTA        := TRBAC2->FALTA 
						
			//alimenta o array do relatório
			aDadosT := Array(21)

			aDadosT[1] 			:= TRBAC2->C5_FILIAL
			aDadosT[2]			:= TRBAC2->C5_NUM
			aDadosT[3]			:= Stod( TRBAC2->C5_EMISSAO )
			aDadosT[4]			:= TRBAC2->A1_COD
			aDadosT[5]			:= TRBAC2->A1_NOME
			aDadosT[6]			:= Stod( TRBAC2->C5_XDTEN   )
			aDadosT[7]			:= TRBAC2->C5_XTIPF
			aDadosT[8]			:= TRBAC2->C5_XSTARES 
			aDadosT[9]			:= TRBAC2->C5_XBLQFMI
			aDadosT[10]			:= TRBAC2->RESERVADO
			aDadosT[11]			:= TRBAC2->C5_XPRIORI
			aDadosT[12]			:= Stod( TRBAC2->XC5MATE )
			aDadosT[13]			:= TRBAC2->ERA
			aDadosT[14]			:= TRBAC2->C5_ZREFNF
			aDadosT[15]			:= TRBAC2->C5_XALERTF
			
			If TRBAC2->C5_TPFRETE == 'C' 
				aDadosT[16]	 := 'C-CIF' 
			Else 
				aDadosT[16]	 := 'F-FOB'
			Endif 
			
			aDadosT[17]			:= TRBAC2->PARCIAL
			aDadosT[18]			:= TRBAC2->TOTAL 
			aDadosT[19]			:= TRBAC2->NET 
			aDadosT[20]			:= TRBAC2->PA2QUANT
			aDadosT[21]			:= TRBAC2->FALTA 

			Aadd(aDadosR, aDadosT)

			TMPHF->( MsUnLock() )	
	
		Endif 
		dbSelectArea("TRBAC2")
		TRBAC2->( dbSkip() )
		
	Enddo
Endif 

If lRet
	MULTPVBrw()	
Else
	MyAviso("Atenção","Não Há Dados de Pedidos de Venda",{"Sair"},3)
EndIf

dbSelectArea("TRBAC2")
TRBAC2->(dbCloseArea())

dbSelectArea( "TMPHF" )
TMPHF->( dbCloseArea() )

//---------------------------------
//Exclui a tabela
//---------------------------------
oTempTable:Delete() 
//fErase( cArq+GetDBExtension() )

RestArea(aArea)

Return(lRet)

//---------------------------------------------------------------------------//
//Monta estrutura das colunas que aparecerÃ£o no browse:  
//Criar temporario para markbrowse
//---------------------------------------------------------------------------//
Static Function CriaTMP()

Local aStru := {}

	
aadd( aStru, { "OK"             ,"C",02,0 } )
aadd( aStru, { "ST"             ,"C",01,0 } )

aadd( aStru, { "C5_XTIPF"       ,"C",10,0 } )
aadd( aStru, { "C5_XSTARES"     ,"C",30,0 } )
aadd( aStru, { "C5_XBLQFMI"     ,"C",20,0 } )

aadd( aStru, { "RESERVADO"      ,"N",16,2 } )
aadd( aStru, { "A1_COD"         ,"C",06,0 } )
aadd( aStru, { "A1_NOME"        ,"C",30,0 } )
aadd( aStru, { "C5_XPRIORI"     ,"C",01,0 } )
aadd( aStru, { "C5_FILIAL"      ,"C",02,0 } )
aadd( aStru, { "C5_NUM"         ,"C",06,0 } )
aadd( aStru, { "XC5MATE"        ,"D",08,0 } )
aadd( aStru, { "ERA"            ,"C",1,0  } )
aadd( aStru, { "C5_ZREFNF"      ,"C",1,0  } )
aadd( aStru, { "C5_XALERTF"     ,"C",30,0 } )
aadd( aStru, { "C5_TPFRETE"     ,"C",10,0 } )
aadd( aStru, { "C5_EMISSAO"     ,"D",8,0  } )
aadd( aStru, { "C5_XDTEN"       ,"D",8,0  } )
aadd( aStru, { "PARCIAL"        ,"N",10,0 } )
aadd( aStru, { "TOTAL"          ,"N",16,2 } )
aadd( aStru, { "NET"            ,"N",16,2 } )
aadd( aStru, { "PA2QUANT"       ,"N",10,0 } )
aadd( aStru, { "FALTA"          ,"N",10,0 } )

oTemptable:SetFields( aStru )


//oTempTable:AddIndex( "01", { "TOTAL" } ) 
//oTempTable:AddIndex( "02", { "C5_FILIAL", "C5_NUM" } ) 


//------------------
//Criação da tabela
//------------------
oTempTable:Create()

Return( .T. )


//-------------------------------------------------------------------------------------//
//Estrutura dos campos do markbrowse da tela liberação múltipla dos pedidos de venda:
//-------------------------------------------------------------------------------------// 
Static Function MULTPVBrw()

Local aButtons	:= {}
Local oDlg01	:= Nil
Local oMarkBw	:= Nil
Local lInverte	:= .F.
Local lOk		:= .F.
Local aCpos     := {}
Local aCores    := {}

Private cMarcaOK := GetMark()
Private aSIZE			:= {}

CALCTELA() // advsize()  //redimensiona as medidas da tela de acordo com a resolução do monitor

//campos que serão mostrados no markbrowse: 
aCpos := {}

aadd( aCpos, {"OK"   	    ,,""                    } )
//aadd( aCpos, {"ST"   	    ,,"Status"              } )         //não precisa aparecer no markbrowse esse campo
aadd( aCpos, {"C5_FILIAL"   ,,"FILIAL" 		    	,"@!"   } )
aadd( aCpos, {"C5_NUM"      ,,"PEDIDO" 		    	,"@!"   } )
aadd( aCpos, {"C5_EMISSAO"  ,,"EMISSAO"		      	,"@D"   } )
aadd( aCpos, {"A1_COD"      ,,"COD.CLIENTE"     	,"@!"   } )
aadd( aCpos, {"A1_NOME"     ,,"NOME CLIENTE"    	,"@!"   } )
aadd( aCpos, {"C5_XDTEN"    ,,"DT.ENTREGA"      	,"@D"   } )

aadd( aCpos, {"C5_XTIPF"    ,,"TIPO FATURA"     	,"@!"   } )
aadd( aCpos, {"C5_XSTARES"  ,,"ST RESERVA"      	,"@!"   } )
aadd( aCpos, {"C5_XBLQFMI"  ,,"BLOQ FAT MIN"    	,"@!"   } )

aadd( aCpos, {"RESERVADO"   ,,"RESERVADO"       	,"@E 9,999,999,999.99"   } )
aadd( aCpos, {"C5_XPRIORI"  ,,"PRIORIDADE"      	,"@!"   } )

aadd( aCpos, {"XC5MATE"     ,,"OS ATÉ"          	,"@!"   } )
aadd( aCpos, {"ERA"         ,,"ERA"             	,"@!"   } )
aadd( aCpos, {"C5_ZREFNF"   ,,"REFATURA NFE"    	,"@!"   } )
aadd( aCpos, {"C5_XALERTF"  ,,"ALERTA FATURAMENTO"  ,"@!"   } )
aadd( aCpos, {"C5_TPFRETE"  ,,"TIPO FRETE"      	,"@!"   } )

aadd( aCpos, {"PARCIAL"     ,,"PARCIAL"        	 	,"@E 99,999,999"   } )
aadd( aCpos, {"TOTAL"       ,,"TOTAL"           	,"@E 9,999,999,999.99"   } )
aadd( aCpos, {"NET"         ,,"NET"             	,"@E 9,999,999,999.99"   } )
aadd( aCpos, {"PA2QUANT"    ,,"PA2QUANT"        	,"@E 99,999,999"   } )
aadd( aCpos, {"FALTA"       ,,"FALTA"           	,"@E 99,999,999"   } )

//C5_XSTARES - Status Reserva Steck: 0=Nao Controla; 1=Atendido; 2=Nao Atendido; 3=Dependencia DF; 4=Parcial                                                             
aCores := {}
/*
aAdd(aCores,{"TMPHF->C5_XSTARES == '0'","BR_BRANCO"    })
aAdd(aCores,{"TMPHF->C5_XSTARES == '1'","BR_VERDE"	    })
aAdd(aCores,{"TMPHF->C5_XSTARES == '2'","BR_VERMELHO"  })
aAdd(aCores,{"TMPHF->C5_XSTARES == '3'","BR_AMARELO"   })	
aAdd(aCores,{"TMPHF->C5_XSTARES == '4'","BR_AZUL"      })	
*/

aCores := {}
aAdd(aCores,{"TMPHF->ST == '1'","BR_VERMELHO"	})  //pedido liberado
aAdd(aCores,{"TMPHF->ST == ' '","BR_VERDE"      })	//pedido não liberado


dbSelectArea("TMPHF")
//COUNT TO nQtdReg

//TMPHF->( dbSetORder( 1 ) )    	

TMPHF->( dbGotop() )

//--------------------------------------------------------------------------------------//
//Apresenta botao se nao for visualizacao 
//--------------------------------------------------------------------------------------//
aAdd(aButtons,{'CHECKED' ,{ || MULTPVInv(cMarcaOK,@oMarkBw)     }, "Inverter Marcação"      , "Inverter"		})
aAdd(aButtons,{'DESTINOS',{ || MULTPVInv(cMarcaOK,@oMarkBw,.T.) }, "Marcar todos os tí­tulos", "Marc Todos"		 })
aAdd(aButtons,{'DESTINOS',{ || MULTPVLEG() 					    }, "Legenda"				, "LEGENDA"   		})	
aAdd(aButtons,{'DESTINOS',{ || FATR540() 			    		}, "Exportar Excel"			, "Exportar Excel"  })	


//Definicao da tela
cTITULO := "Liberação Múltipla de Pedidos de Venda"

//DEFINE MSDIALOG oDlg01 TITLE "Liberação Múltipla de Pedidos de Venda" FROM 000,000 TO 430,800 OF oMainWnd PIXEL
Define MsDialog oDlg01 TITLE cTITULO STYLE DS_MODALFRAME From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL

oDlg01:lMaximized := .F.

//----------------------------------------------//
//Cria o objeto Mark para a selecao dos pedidos
//----------------------------------------------//
oMarkBw := MsSelect():New("TMPHF","OK","",aCpos,@lInverte,@cMarcaOK,{17,10,150,400},,,,,aCores) //oFolder:aDialogs[1]

oMarkBw:oBrowse:Refresh()
oMarkBw:oBrowse:lhasMark    := .T.
oMarkBw:oBrowse:lCanAllmark := .T.
oMarkBw:oBrowse:Align       := CONTROL_ALIGN_ALLCLIENT	//Usado no modelo FLAT

//------------------------------------------------//
//Permite selecao se nao for visualizacao 
//------------------------------------------------//
oMarkBw:oBrowse:bAllMark    := { || MULTPVInv(cMarcaOK,@oMarkBw) }
oMarkBw:oBrowse:bChange     := { || MULTPVChg(@oMarkBw) }
oMarkBw:BMark               := { || MULTPVDis(@oMarkBw,cMarcaOK) }  //duplo clique já marca [x]


ACTIVATE MSDIALOG oDlg01 CENTERED  ON INIT EnchoiceBar(oDlg01,;
{|| processa({|| MULTPVLIB(@oMarkBw)}, "Gerar...","Gravando Liberação Pedidos ...") },;
{|| iif( msgYesNo("Sair da Liberação Multipla de PV ?","Pegunta"),oDlg01:End(),lOk := .F. )},,aButtons)

Return( .T. )


//--------------------------------------------------------------------------//
//Função    : MULTPVINV
//Descricao : Esta rotina ira marcar ou desmarcar os pedidos             
//--------------------------------------------------------------------------//
Static Function MULTPVInv(cMarcaOK,oMarkBw,lMarkAll)

Local aGetArea	:= GetArea()
Local lMarcSim	:= .F.

If lMarkAll
	lMarcSim := Aviso( "Marcar/Desmarcar todos", "Deseja marcar ou desmarcar todos os pedidos?", { "Marcar", "Desmarcar" } ) == 1
EndIf

//---------------------------------------------------//
// While para marcar ou desmarcar os produtos
//---------------------------------------------------//
TMPHF->( dbGotop() )
While TMPHF->( !EOF() )

	If lMarkAll

		RecLock("TMPHF", .F.)		
		TMPHF->OK	:= if(TMPHF->ST == "1", "  ", If(lMarcSim, cMarcaOK, "  ") )		 //if(TMPHF->ST == "1", "  ", If(lMarcSim, cMarcaOK, "  ") )		
		TMPHF->( MsUnLock() )
	
	Else

		If  TMPHF->OK == cMarcaOK		
			RecLock("TMPHF", .F.)			
			TMPHF->OK	:= "  "			
			TMPHF->( MsUnLock() )			
		Else		
			RecLock("TMPHF", .F.)			
			TMPHF->OK	:= if(TMPHF->ST == "1", "  ", cMarcaOK )			
			TMPHF->( MsUnLock() )			
		EndIf

	EndIf

	TMPHF->( dbSkip() )	

EndDo

oMarkBw:oBrowse:Refresh(.T.)
RestArea( aGetArea )

Return

/*/
//-------------------------------------------------------------------------//
Programa:  MULTPVChg
Autoria :  Flávia Rocha
Objetivo:  bChange da linha de markbrowse (refresh de linha)
Data    :  30/05/2022
//-------------------------------------------------------------------------//
/*/
Static Function MULTPVChg(oMarkBw)

Local cRetFun := " "

oMarkBw:oBrowse:Refresh(.T.)

Return cRetFun


/*/
//-------------------------------------------------------------------------//
Programa:  MULTPVDis
Autoria :  Flávia Rocha
Objetivo:  Inverter marcação da linha posicionada
Data    :  30/05/2022
//-------------------------------------------------------------------------//
/*/
Static Function MULTPVDis(oMarkBw, cMarcaOK)

Local aGetArea := GetArea()


If TMPHF->ST == "1" //.and. TMPHF->OK == cMarcaOK 
    MsgAlert("Pedido Já Liberado !")
    
        RecLock("TMPHF", .F.)
        TMPHF->OK := "  "
        TMPHF->( MsUnLock() )	    
    
 Endif 


oMarkBw:oBrowse:Refresh(.T.)
RestArea( aGetArea )

Return

//==================================================================================//
//Função  : MULTPVLeg 
//Autoria : Flávia Rocha
//Data    : 17/03/2021
//Objetivo: Exibe Legenda 
//==================================================================================//
Static Function MULTPVLeg()
Local aLegenda := {}

/*
aAdd(aCores,{"TMPHF->ST == '1'","BR_VERMELHO"	})  //pedido liberado
aAdd(aCores,{"TMPHF->ST == ' '","BR_VERDE"      })	//pedido não liberado

*/
AADD(aLegenda,{"BR_VERDE" 		,"Não Liberado"			})
AADD(aLegenda,{"BR_VERMELHO"	,"Liberado" 			})


BrwLegenda("Status Pedidos", "Legenda", aLegenda)

Return Nil

//==================================================================================//
//Função  : MULTPVLib
//Autoria : Flávia Rocha
//Data    : 30/05/2022
//Objetivo: Grava nos pedidos selecionados, a respectiva liberaÃ§Ã£o
//==================================================================================//

Static Function MULTPVLIB(oMarkBw)

If !MsgYesNo("Confirma a Liberação Do(s) Pedido(s) Marcado(s) Abaixo ?")
	MsgInfo("Operação Cancelada Pelo Usuário")
	Return 
Endif 

DbSelectArea( "TMPHF" )

Count To nTotReg

ProcRegua( nTotReg )

cMsg := "Gravando Liberação de Pedidos" + CRLF

TMPHF->( DbGotop() )

While .not. TMPHF->( Eof() )

	IncProc("Processando " + TMPHF->C5_NUM)	
	
    If .not. empty( TMPHF->OK ) // == cMarcaOK	
				
		If TMPHF->ST <> "1"  //só deixa liberar se não tive sido liberado 1-Liberado, "vazio" não liberado
			DbSelectArea( "TMPHF" )

			/*
			C5_XTIPF = '2'
			C5_XSTARES ='4'
			C5_XBLQFMI = 'N'
			*/
			
			RecLock( "TMPHF", .F. )              	
			TMPHF->OK := "  "
			TMPHF->ST := "1"		           		
			TMPHF->( MsUnLock() ) 

			DbSelectArea("SC5")
			SC5->(OrdSetFocus(1))  //C5_FILIAL + C5_NUM
			If SC5->(Dbseek( TMPHF->C5_FILIAL + TMPHF->C5_NUM))

				RecLock("SC5" , .F.)
				SC5->C5_XTIPF   := '2'
				SC5->C5_XSTARES := '4'
				SC5->C5_XBLQFMI := 'N'
				SC5->(MsUnlock())

			Endif 
		Endif 
    Endif 

	DbSelectArea( "TMPHF" )
	TMPHF->( DbSkip() )

Enddo

Return 




/*
//-------------------------------------------------------------------------//
//MyAviso - Interface para exibir dialog de aviso ao usuário
//-------------------------------------------------------------------------//
*/
Static Function MyAviso(cCaption,cMensagem,aBotoes,nSize,cCaption2, nRotAutDefault,cBitmap,lEdit,nTimer,nOpcPadrao,lAuto)
Local ny        := 0
Local nx        := 0
Local aSize  := {  {134,304,35,155,35,113,51},;  // Tamanho 1
				{134,450,35,155,35,185,51},; // Tamanho 2
				{227,450,35,210,65,185,99} } // Tamanho 3
Local nLinha    := 0
Local cMsgButton:= ""
Local oGet 
Local nPass := 0
Private oDlgAviso
Private nOpcAviso := 0

DEFAULT lEdit := .F.
If lEdit
	nSize := 3
EndIf

lMsHelpAuto := .F.

cCaption2 := Iif(cCaption2 == Nil, cCaption, cCaption2)


//Quando for rotina automatica, envia o aviso ao Log.        
If Type('lMsHelpAuto') == 'U'
	lMsHelpAuto := .F.
EndIf

If !lMsHelpAuto
	If nSize == Nil
		
		//Verifica o numero de botoes Max. 5 e o tamanho da Msg		
		If  Len(aBotoes) > 3
			If Len(cMensagem) > 286
				nSize := 3
			Else
				nSize := 2
			EndIf
		Else
			Do Case
				Case Len(cMensagem) > 170 .And. Len(cMensagem) < 250
					nSize := 2
				Case Len(cMensagem) >= 250
					nSize := 3
				OtherWise
					nSize := 1
			EndCase
		EndIf
	EndIf
	If nSize <= 3
		nLinha := nSize
	Else
		nLinha := 3
	EndIf

	DEFINE MSDIALOG oDlgAviso FROM 0,0 TO aSize[nLinha][1],aSize[nLinha][2] TITLE cCaption OF oDlgAviso PIXEL
	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
//	@ 0, 0 BITMAP RESNAME "LOGIN" oF oDlgAviso SIZE aSize[nSize][3],aSize[nSize][4] NOBORDER WHEN .F. PIXEL ADJUST .T.
	@ 11 ,35  TO 13 ,400 LABEL '' OF oDlgAviso PIXEL
	If cBitmap <> Nil
//		@ 2, 37 BITMAP RESNAME cBitmap oF oDlgAviso SIZE 18,18 NOBORDER WHEN .F. PIXEL
		@ 3  ,50  SAY cCaption2 Of oDlgAviso PIXEL SIZE 130 ,9 FONT oBold
	Else
		@ 3  ,37  SAY cCaption2 Of oDlgAviso PIXEL SIZE 130 ,9 FONT oBold
	EndIf
	If nSize < 3
		@ 16 ,38  SAY cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5]
	Else
		If !lEdit
			@ 16 ,38  GET oGet VAR cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5] READONLY MEMO
		Else
			@ 16 ,38  GET oGet VAR cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5] MEMO
		EndIf
		
	EndIf
	If Len(aBotoes) > 1 .Or. nTimer <> Nil
		TButton():New(1000,1000," ",oDlgAviso,{||Nil},32,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
	EndIf
	ny := (aSize[nLinha][2]/2)-36
	For nx:=1 to Len(aBotoes)
		cAction:="{||nOpcAviso:="+Str(Len(aBotoes)-nx+1)+",oDlgAviso:End()}"
		bAction:=&(cAction)
		cMsgButton:= OemToAnsi(AllTrim(aBotoes[Len(aBotoes)-nx+1]))
		cMsgButton:= IF(  "&" $ Alltrim(cMsgButton), cMsgButton ,  "&"+cMsgButton )
		TButton():New(aSize[nLinha][7],ny,cMsgButton, oDlgAviso,bAction,32,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
		ny -= 35
	Next nx
	If nTimer <> Nil
		oTimer := TTimer():New(nTimer,{|| nOpcAviso := nOpcPadrao,IIf(nPass==0,nPass++,oDlgAviso:End()) },oDlgAviso)
		oTimer:Activate()       
		bAction:= {|| oTimer:DeActivate() }
		TButton():New(aSize[nLinha][7],ny,"Timer off", oDlgAviso,bAction,32,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
	Endif
	ACTIVATE MSDIALOG oDlgAviso CENTERED
Else
	If ValType(nRotAutDefault) == "N" .And. nRotAutDefault <= Len(aBotoes)
		cMensagem += " " + aBotoes[nRotAutDefault]
		nOpcAviso := nRotAutDefault
	Endif
	ConOut(Repl("*",40))
	ConOut(cCaption)
	ConOut(cMensagem)
	ConOut(Repl("*",40))
	AutoGrLog(cCaption)
	AutoGrLog(cMensagem)
EndIf

Return (nOpcAviso)


//--------------------------------------------------------------------------------//
//Programa : CALCTELA Autor Flávia Rocha                            Data 30/03/2020
//Descricao: Calcula o tamanho da tela de acordo com a resolução
//--------------------------------------------------------------------------------//       
STATIC FUNCTION CALCTELA()
	//-------------------------------------------------------//
	//Retorna area de trabalho e coordenadas para janela
	//-------------------------------------------------------//
	aSIZE := MsAdvSize(.T.)
	// .T. se tera enchoicebar
	* Retorno:
	* 1 Linha inicial area trabalho.
	* 2 Coluna inicial area trabalho.
	* 3 Linha final area trabalho.
	* 4 Coluna final area trabalho.    
	* 5 Coluna final dialog (janela).
	* 6 Linha final dialog (janela).
	* 7 Linha inicial dialog (janela).
	                  
	//--------------------------------------------------------------------------------------//
	//Contera parametros utilizados para calculo de posicao usadas pelo objetos na tela
	//--------------------------------------------------------------------------------------//
	aObjects := {}
	
	AAdd( aObjects, { 0, 95, .T., .F., .F. } ) // Coordenadas para o ENCHOICE
	// largura
	// altura
	// .t. permite alterar largura
	// .t. permite alterar altura
	// .t. retorno: linha, coluna, largura, altur
	//     OU
	// .f. retorno: linha, coluna, linha, coluna
	
	AAdd( aObjects, { 0, 0, .T., .T., .F. } ) // Coordenadas para o MSGETDADOS
	// largura
	// altura
	// .t. permite alterar largura
	// .f. NAO permite alterar altura ***
	// .t. retorno: linha, coluna, largura, altura
	//     OU
	// .f. retorno: linha, coluna, linha, coluna
	
	
	AAdd( aObjects, { 0, 60, .T., .F., .T. } ) // Coordenadas para o FOLDER
	// largura
	// altura
	// .t. permite alterar largura
	// .f. NAO permite alterar altura ***
	// .t. retorno: linha, coluna, largura, altura
	//     OU
	// .f. retorno: linha, coluna, linha, coluna
	
	//-------------------------------------------------------------------//
	//Informacoes referente a janela que serao passadas ao MsObjSize
	//-------------------------------------------------------------------//
	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 } 
	// aSize[1] LI 
	// aSize[2] CI 
	// aSize[3] LF 
	// aSize[4] CF 
	// 3        separacao horizontal  
	// 3        separacao vertical
	
	aPos  := MsObjSize( aInfo, aObjects )
	               
	// {  {} , {} , {} } 
	
	// aPos - array bidimensional, cada elemento sera um array com as coordenadas 
	// para cada objeto
	//
	// 1 -> Linha inicial        aObjects[ N , 5 ] ==== .F. 
	// 2 -> Coluna inicial
	// 3 -> Linha final
	// 4 -> Coluna final
	// 
	// ou
	// 
	// 1 -> Linha inicial        aObjects[ N , 5 ] ==== .T. 
	// 2 -> Coluna inicial
	// 3 -> Largura X
	// 4 -> Altura Y
	
RETURN


Static Function FATR540()

	Local   oReport
	Private cPerg 			:= "FATR540"
	Private cTime           := Time()
	Private cHora           := Substr(cTime, 1, 2)
	Private cMinutos    	:= Substr(cTime, 4, 2)
	Private cSegundos   	:= Substr(cTime, 7, 2)
	Private cAliasLif   	:= cPerg + cHora + cMinutos + cSegundos
	Private lXlsHeader      := .F.
	Private lXmlEndRow      := .F.
	Private cPergTit 		:= cAliasLif
	/*
	PutSx1(cPerg, "01", "Pedido de:" 	,"Pedido de:" 	 ,"Pedido de:" 			,"mv_ch1","C",6,0,0 ,"G","","SC5","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Pedido Ate:"	,"Pedido Ate:"   ,"Pedido Ate:" 		,"mv_ch2","C",6,0,0 ,"G","","SC5","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Produto de:" 	,"Produto de:" 	 ,"Produto de:" 		,"mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Produto Ate:"	,"Produto Ate:"  ,"Produto Ate:"		,"mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "05", "Da Emissao:"	,"Da Emissao:"	 ,"Da Emissao:"			,"mv_ch5","D",08,0,0,"G","","   ","","","mv_par05","","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "06", "Até a Emissao:","Até a Emissao:","Até a Emissao:" 		,"mv_ch6","D",08,0,0,"G","","   ","","","mv_par06","","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "07", "Destino  :"	,"Destino  :"    ,"Destino  :"       	,"mv_ch7","N", 1,0,0,"C","","   ","","","mv_par07","1-Fabrica","","","","2-CD","","","3-Ambos","","","","","","","")
	*/

	oReport	:= ReportDef()
	oReport:PrintDialog()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ReportDef    ºAutor  ³Giovani Zago    º Data ³  04/07/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio PVG 							                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATÓRIO LIB. PEDIDOS EM MASSA",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório a Tela PV em Massa")

	//Pergunte(cPerg,.F.)

	
	oSection := TRSection():New(oReport,"LIBPV",{"SC6"})

	TRCell():New(oSection,"01",,"FILIAL"			,,06,.F.,)
	TRCell():New(oSection,"02",,"PEDIDO"			,,06,.F.,)
	TRCell():New(oSection,"03",,"EMISSAO"			,,10,.F.,)
	TRCell():New(oSection,"04",,"COD.CLIENTE"		,,06,.F.,)
	TRCell():New(oSection,"05",,"NOME CLIENTE"		,,50,.F.,)
	TRCell():New(oSection,"06",,"DT.ENTREGA"		,,10,.F.,)
	TRCell():New(oSection,"07",,"TIPO FATURA"		,,06,.F.,)
	TRCell():New(oSection,"08",,"ST.RESERVA"		,,06,.F.,)
	TRCell():New(oSection,"09",,"BLOQ.FAT MIN"		,,06,.F.,)	
	TRCell():New(oSection,"10",,"RESERVADO"			,"@E 999,999,999.99",14)
	TRCell():New(oSection,"11",,"PRIORIDADE"	    ,,06,.F.,)
	TRCell():New(oSection,"12",,"OS ATÉ"		    ,,03,.F.,)
	TRCell():New(oSection,"13",,"ERA"			    ,,03,.F.,)
	TRCell():New(oSection,"14",,"REFATURA NFE"	    ,,03,.F.,)
	TRCell():New(oSection,"15",,"ALERTA FATURMTO"   ,,03,.F.,)
	TRCell():New(oSection,"16",,"TIPO FRETE"	    ,,03,.F.,)
	TRCell():New(oSection,"17",,"PARCIAL"			,"@E 99,999,999",14)
	TRCell():New(oSection,"18",,"TOTAL"				,"@E 9,999,999,999",14)
	TRCell():New(oSection,"19",,"NET" 				,"@E 9,999,999,999.99",14)
	TRCell():New(oSection,"20",,"PA2QUANT"			,"@E 99,999,999",14)
	TRCell():New(oSection,"21",,"FALTA"				,"@E 99,999,999",14)

	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC6")

Return oReport


//-----------------------------------------//
//REPORT PRINT
//-----------------------------------------//
Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local aDados[2]
	//Local aDados1[99]
	Local aDados1 := {}
	Local fr      := 0

	oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
	oSection1:Cell("08") :SetBlock( { || aDados1[08] } )
	oSection1:Cell("09") :SetBlock( { || aDados1[09] } )
	oSection1:Cell("10") :SetBlock( { || aDados1[10] } )
	oSection1:Cell("11") :SetBlock( { || aDados1[11] } )
	oSection1:Cell("12") :SetBlock( { || aDados1[12] } )
	oSection1:Cell("13") :SetBlock( { || aDados1[13] } )
	oSection1:Cell("14") :SetBlock( { || aDados1[14] } )
	oSection1:Cell("15") :SetBlock( { || aDados1[15] } )
	oSection1:Cell("16") :SetBlock( { || aDados1[16] } )
	oSection1:Cell("17") :SetBlock( { || aDados1[17] } )
	oSection1:Cell("18") :SetBlock( { || aDados1[18] } )
	oSection1:Cell("19") :SetBlock( { || aDados1[19] } )
	oSection1:Cell("20") :SetBlock( { || aDados1[20] } )
	oSection1:Cell("21") :SetBlock( { || aDados1[21] } )

	oReport:SetTitle("LIBERA_PV")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,Nil)
	aFill(aDados1,Nil)
	oSection:Init()

	fr := 1
	rf := 1
	
	If Len(aDadosR) > 0		

		For fr := 1 to Len(aDadosR)

			aDados1 := Array(21)

			aDados1[1] 			:= aDadosR[fr,1]
			aDados1[2]			:= aDadosR[fr,2]
			aDados1[3]			:= aDadosR[fr,3]
			aDados1[4]			:= aDadosR[fr,4]
			aDados1[5]			:= aDadosR[fr,5]
			aDados1[6]			:= aDadosR[fr,6]
			aDados1[7]			:= aDadosR[fr,7]
			aDados1[8]			:= aDadosR[fr,8]
			aDados1[9]			:= aDadosR[fr,9]
			aDados1[10]			:= aDadosR[fr,10]
			aDados1[11]			:= aDadosR[fr,11]
			aDados1[12]			:= aDadosR[fr,12]
			aDados1[13]			:= aDadosR[fr,13]
			aDados1[14]			:= aDadosR[fr,14]
			aDados1[15]			:= aDadosR[fr,15]
				
			If aDadosR[fr,16]== 'C' 
				aDados1[16]	 := 'C-CIF' 
			Else 
				aDados1[16]	 := 'F-FOB'
			Endif 
					
			aDados1[17]			:= aDadosR[fr,17]
			aDados1[18]			:= aDadosR[fr,18]
			aDados1[19]			:= aDadosR[fr,19]
			aDados1[20]			:= aDadosR[fr,20]
			aDados1[21]			:= aDadosR[fr,21]
				
			oSection1:PrintLine()
			aFill(aDados1,Nil)
		NEXT

	EndIf

	oReport:SkipLine()

Return oReport

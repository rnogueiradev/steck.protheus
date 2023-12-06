 
 /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STESTR10 ºAutor  ³RVG                 º Data ³  18/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STESTR10


Local oReport         

Private cPerg:="STESTR1002" 

_fCriaSx1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= ReportDef()
oReport:PrintDialog()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Marcos V. Ferreira     ³ Data ³13/06/05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR350			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local aOrdem    := {}
Local cPictQt   := PesqPict("SB2","B2_QATU")
Local nTamQt    := TamSX3('B2_QATU')[1]
Local oCabec
Local oFaltas
Private cAliasTRB := "TRB"

 
oReport:= TReport():New("STESTR10","Medias de Consumo Periodo", cPerg, {|oReport| ReportPrint(oReport)},"O relatorio irá listar estoque STECK ")

oSection1 := TRSection():New(oReport,"Medias de Consumo Periodo",{},aOrdem)  
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,'CODIGO'    	,"TRB",'Produto',		/*Picture*/,15,/*lPixel*/, )
TRCell():New(oSection1,'DESCRI' 	,"TRB",'Descricao',		/*Picture*/,35,/*lPixel*/, )
TRCell():New(oSection1,'TIPO' 		,"TRB",'Tipo' ,			/*Picture*/,4,/*lPixel*/, )
TRCell():New(oSection1,'GRUPO' 		,"TRB",'Grupo',			/*Picture*/,5,/*lPixel*/, )
TRCell():New(oSection1,'FRM'		,"TRB",'FMR',			/*Picture*/,4,/*lPixel*/, )
TRCell():New(oSection1,'ABC'		,"TRB",'ABC',			/*Picture*/,4,/*lPixel*/, )
TRCell():New(oSection1,'CLAPROD'	,"TRB",'Class.',		/*Picture*/,4,/*lPixel*/, )
TRCell():New(oSection1,'LOTEMIN'	,"TRB","Lote Min"  	 	,"@E 999999,999.99"	,14,/*lPixel*/,,,,"LEFT") 
TRCell():New(oSection1,'PRAZO'		,"TRB","Lead Time" 		,"@E 9999"			,04,/*lPixel*/,,,,"LEFT") 
TRCell():New(oSection1,'CONSUMO'	,"TRB","Cosnumo" 	  	,"@E 999999,999.99"	,14,/*lPixel*/,,,,"LEFT") 
TRCell():New(oSection1,'OCORRENCIAS',"TRB","Ocorrencias"   	,"@E 999999"		,06,/*lPixel*/,,,,"LEFT") 
TRCell():New(oSection1,'ULT_VENDA'	,"TRB","Ultima Venda"  	, 					,08,/*lPixel*/,,,,"LEFT")                   
TRCell():New(oSection1,'ULT_MOVINT'	,"TRB","Ultima Reqs"   	, 					,08,/*lPixel*/,,,,"LEFT") 
TRCell():New(oSection1,'CUSTO_MED'	,"TRB","Custo Medio"   	,"@E 999999,999.99"	,14,/*lPixel*/,,,,"LEFT")      
TRCell():New(oSection1,'SLD_ATUAL'	,"TRB","Saldo Atual"   	,"@E 999999,999.99"	,14,/*lPixel*/,,,,"LEFT")      
TRCell():New(oSection1,'LIQUIDO'	,"TRB","SAldo Liquido"  ,"@E 999999,999.99"	,14,/*lPixel*/,,,,"LEFT")      
 
 
Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint ³ Autor ³ RVG                 ³ Data ³05/04/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportPrint devera ser criada para todos  ³±±
±±³          ³os relatorios que poderao ser agendados pelo usuario.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³       			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,aOrdem,cAliasTRB)

Local oSection1    := oReport:Section(1)
Local nOrdem       := oSection1:GetOrder()
                         
pergunte("STESTR1002",.f.)

//MV_PAR07 :=  ctod(MV_PAR07)
//MV_PAR08 :=  ctod(MV_PAR08) 

_dini := dtos(MV_PAR07)   
_dfim := dtos(MV_PAR08)

BeginSql Alias 'TRB'
	SELECT TEMPb.*, 
	 	 NVL((SELECT MAX(B2_CM1) FROM %Table:SB2%   WHERE B2_COD = TEMPb.CODIGO AND  D_E_L_E_T_ = ' ' AND B2_FILIAL  BETWEEN  %Exp:MV_PAR09% AND %Exp:MV_PAR10% ),0) AS CUSTO_MED, 
		 NVL((SELECT SUM(B2_QATU) FROM %Table:SB2%  WHERE B2_COD = TEMPb.CODIGO AND  D_E_L_E_T_ = ' ' AND B2_FILIAL  BETWEEN  %Exp:MV_PAR09% AND %Exp:MV_PAR10% ),0) AS SLD_ATUAL,
	 	(NVL((SELECT SUM(B2_QATU) FROM %Table:SB2%  WHERE B2_COD = TEMPb.CODIGO AND  D_E_L_E_T_ = ' ' AND B2_FILIAL  BETWEEN  %Exp:MV_PAR09% AND %Exp:MV_PAR10% ),0)
	 	  - NVL((SELECT SUM(PA2_QUANT) FROM %Table:PA2% WHERE PA2_CODPRO = TEMPb.CODIGO AND  D_E_L_E_T_ = ' ' AND PA2_FILRES  BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%),0) ) AS LIQUIDO  
	FROM 
	 (
	
	SELECT CODIGO,SB1.B1_DESC AS DESCRI , 
	              SB1.B1_TIPO AS TIPO ,
	              SB1.B1_GRUPO AS GRUPO ,
	              SB1.B1_XFMR AS FMR ,
	              SB1.B1_XABC AS ABC ,
	              SB1.B1_CLAPROD AS CLAPROD ,
	              SB1.B1_PE AS PRAZO ,
	              SB1.B1_LM AS LOTEMIN ,
	              SUM(CONSUMO) AS CONSUMO ,
	              SUM(OCORRENCIAS) AS OCORRENCIAS , 
	              MAX(ULT_VENDA) AS ULT_VENDA ,  
	              MAX(ULT_MOVINT ) AS ULT_MOVINT  
	 
	FROM 
	
	(
	  SELECT '  ' AS FILIAL ,D2_COD AS CODIGO,SUM(D2_QUANT) AS CONSUMO, COUNT(*) AS OCORRENCIAS , '  ' AS PERIODO  ,MAX(D2_EMISSAO) AS ULT_VENDA , ' ' AS ULT_MOVINT 
	            FROM %Table:SD2% SD2 
	
	            LEFT JOIN %Table:SF4% SF4 ON F4_FILIAL = '  ' AND F4_CODIGO = D2_TES 
	
	            WHERE  D2_EMISSAO BETWEEN %Exp:_dini% AND %Exp:_dfim%  
	                   AND SD2.%NotDel%  
	                   AND SF4.%NotDel%  
	                   AND  F4_ESTOQUE = 'S'   
	                   AND  F4_DUPLIC = 'S' 
	                   AND D2_FILIAL BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10% 
	
	         
	  GROUP BY D2_COD,SUBSTR(D2_EMISSAO,1,6) 
	
	  UNION ALL 
	
	  SELECT '  ' FILIAL,D3_COD AS CODIGO,SUM(D3_QUANT) AS CONSUMO, COUNT(*) AS OCORRENCIAS ,   '   ' AS PERIODO ,' '  AS ULT_VENDA , MAX(D3_EMISSAO) AS ULT_MOVINT 
	                                      
	  FROM %Table:SD3% SD3 
	        WHERE D3_EMISSAO  BETWEEN %Exp:_dini% AND %Exp:_dfim%   
	              	AND D3_FILIAL  BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10% 
	  	    		AND SD3.%NotDel%   
	  	    		AND D3_DOC <> 'INVENT ' 
	  	    		AND D3_CF  LIKE 'RE%' 
	  	    		AND D3_ESTORNO = ' '    
	
	   GROUP BY  D3_COD,SUBSTR(D3_EMISSAO,1,6) 
	
	) TEMP
	
	LEFT JOIN %Table:SB1% SB1 ON B1_FILIAL = ' ' 
         AND B1_COD = TEMP.CODIGO 
         AND SB1.%NotDel% 
 
	
	WHERE B1_COD <> ' '  
	      AND B1_TIPO   BETWEEN  %Exp:MV_PAR05% AND %Exp:MV_PAR06% 
	      AND B1_GRUPO  BETWEEN  %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
	      AND B1_COD    BETWEEN  %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
	
	GROUP BY CODIGO,B1_DESC, B1_TIPO,B1_GRUPO,B1_XFMR,B1_XABC,B1_CLAPROD,B1_PE,B1_LM
	
	) TEMPb 
	
	ORDER BY CODIGO        
	
EndSql

 
dbSelectArea("TRB")
DbGoTop()

_nRec := 0
DbEval({|| _nRec++  })

DbGoTop()

oSection1:Init()

oReport:SetMeter(_nRec)

Do While !eof()
	
	oReport:IncMeter()
	  
	oSection1:PrintLine()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	dbSelectArea("TRB")
	DbSkip()
	
Enddo

oSection1:Finish()

dbSelectArea("TRB")
dbCloseArea("TRB")
 
Return

                 





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LMP_B2B8  ºAutor  ³RVG                 º Data ³  18/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function _fCriaSx1()
/* Removido - 18/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
DbSelectArea("SX1")
DbSetOrder(1)

If ! DbSeek(cPerg+"01",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Do Produto"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 15
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SB1"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"02",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Ate Produto"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 15
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par02"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SB1"
	MsUnLock()
EndIf
 
If ! DbSeek(cPerg+"03",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Do Grupo ??"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 4
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_F3		:= "SBM"
	MsUnLock()
EndIf
                        

If ! DbSeek(cPerg+"04",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Ate o Grupo ??"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 4
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""     
	SX1->X1_VAR01   := "mv_par04"
	SX1->X1_F3		:= "SBM"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"05",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Tipo de"
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par05"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"06",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Tipo ate"
	SX1->X1_VARIAVL := "mv_ch6"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par06"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"07",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "07"
	SX1->X1_PERGUNT := "Date de"
	SX1->X1_VARIAVL := "mv_ch7"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_F3      := ""
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par07"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"08",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "08"
	SX1->X1_PERGUNT := "Data Ate"
	SX1->X1_VARIAVL := "mv_ch8"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par08"
	MsUnLock()
EndIf

If ! DbSeek(cPerg+"09",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "09"
	SX1->X1_PERGUNT := "Filial Ate"
	SX1->X1_VARIAVL := "mv_ch9
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par09"
	SX1->X1_F3      := "SM0"
	MsUnLock()
EndIf


If ! DbSeek(cPerg+"10",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "10"
	SX1->X1_PERGUNT := "Filial Ate"
	SX1->X1_VARIAVL := "mv_ch9
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 2
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par10"
	SX1->X1_F3      := "SM0"
	MsUnLock()
EndIf
*/

Return

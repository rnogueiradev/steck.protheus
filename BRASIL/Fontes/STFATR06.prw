#Include "Protheus.ch"
#Include "TopConn.ch"
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STFATR06   บ Autor ณ Cristiano Pereiraบ Data ณ  30/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Capta็ใo Diaria p/ Grupo de Produto           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function STFATR06()

Local oReport
Local aArea	:= GetArea()
Private aGrupo := {}

Ajusta()

If Pergunte("STFATR06",.T.)

	//Obtem Dados do Grupo
	DbSelectArea("SBM")
	DbSetOrder(1)
	SBM->(DbGoTop())
	While SBM->(!Eof())
	            
	    If SBM->BM_GRUPO < MV_PAR03 .And. SBM->BM_GRUPO > MV_PAR04   
	        SBM->(dbSkip())   
	        LOOP
	    Else  
			AADD(aGrupo,{SBM->BM_GRUPO,SBM->BM_DESC})                                   		
		EndIf 
		SBM->(dbSkip())

	EndDo
	
	While Len(aGrupo) < 8
		AADD(aGrupo,{"","",0})
	EndDo

	oReport 	:= ReportDef()
	oReport		:PrintDialog()
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณMicrosiga           บ Data ณ  03/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Definicao do layout do Relatorio                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()

Local oReport
Local oSection1,oSection2,oSection3
Local _z

oReport := TReport():New("STFATR06","Relatorio de Captacao Diaria p/ Grupo Produto","STFATR06",{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir o Resumo de Captacao Diaria p/ Grupo Produto conforme parametros.")

oReport:SetLandscape()
pergunte("STFATR06",.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros						  ณ
//ณ mv_par01			// Mes							 		  ณ
//ณ mv_par02			// Ano									  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 

oSection1 := TRSection():New(oReport,"Metas",{"SA3"},)


TRCell():New(oSection1,"DESC"		,,"                             .",,001,.F.,)
TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)
//TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)   

                        
For _z:=1 to len(aGrupo)

TRCell():New(oSection1,"SUP01"+StrZero(_z,3)		,,IIF(!Empty(aGrupo[_z][2]),aGrupo[_z][1]+" - "+Alltrim(aGrupo[_z][2]),"Grupo"+StrZero(_z,3)),"@E 99,999,999",018,.F.,)
//TRCell():New(oSection1,"VAZIO"		,,"                             .",,001,.F.,)

Next _z  

//TRCell():New(oSection1,"TOTAL"		,,"Total"		,"@E 99,999,999",018,.F.,)


oSection1:SetHeaderSection(.T.)
oSection1:Setnofilter("SA3")
                                               


oSection2 := TRSection():New(oReport,"Captacao",{"SC6"},)  


TRCell():New(oSection2,"DIA"		,,"Dia"			,,006,.F.,)
TRCell():New(oSection2,"CAPT"		,,"Capt.Dia"	,"@E 999,999,999",012,.F.,)   




For _z:=1 to len(aGrupo) 
   TRCell():New(oSection2,"AC01"+aGrupo[_z,1],,"Ac."		,"@E 999.99",009,.F.,)  
Next _z  

//TRCell():New(oSection2,"OB01"		,,"% Obj.1"		,"@E 999.99",009,.F.,)

oSection2:SetHeaderSection(.T.)
oSection2:Setnofilter("SC6")

oSection3 := TRSection():New(oReport,"Programados",{"SC6"},)
TRCell():New(oSection3,"MES"		,,"Mes/Ano"		,,020,.F.,)
TRCell():New(oSection3,"ACUM"		,,"Acum. Ind."	,"@E 999,999",024,.F.,)
oSection3:SetHeaderSection(.T.)
oSection3:Setnofilter("SC6")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณReportPrintณ Autor ณMicrosiga		          ณ Data ณ12.05.12 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri็ใo ณA funcao estatica ReportDef devera ser criada para todos os  ณฑฑ
ฑฑณ          ณrelatorios que poderao ser agendados pelo usuario.           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpO1: Objeto Report do Relat๓rio                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao efetuada                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                             ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportPrint(oReport)

Local cTitulo		:= OemToAnsi("Captacao Diaria p/ Grupo")
Local cAlias1		:= "QRY1C6"
Local cQuery1		:= ""
Local nRecSM0		:= SM0->(Recno())
Local _i			:= 0 
Local _z            := 0
Local nCont			:= 0
Local nPos			:= 0
Local nPos1         := 0
Local nValor		:= 0
Local nMeta			:= 0
Local aEmpresa		:= {}
Local aCapt			:= {}
Local aDados1[12]
Local aDados2[2]
Local aDados3[2]            
Local oSection1  := oReport:Section(1)
Local oSection2  := oReport:Section(2)
Local oSection3  := oReport:Section(3)            
Local _cDiaS     := ""  
Local _aDias     := {}
Local _y         := 0
Local _aAcDia[len(aGrupo)+1]  


        
           
oSection2:Cell("DIA"  )		:SetBlock( { || aDados2[1] })
oSection2:Cell("CAPT" )		:SetBlock( { || aDados2[2] })

For _z:=1 to len(aGrupo)        
oSection2:Cell("AC01"+aGrupo[_z,1])	:SetBlock( {||_aAcDia[_z] })    
Next _z                 


//oSection2:Cell("OB01" )		:SetBlock( { || aDados2[5] })

                 
oSection3:Cell("MES"  )		:SetBlock( { || aDados3[1] })
oSection3:Cell("ACUM" )		:SetBlock( { || aDados3[2] })

//Obtem Empresas
DbSelectArea("SM0")
DbSetOrder(1)
SM0->(DbGoTop())
While SM0->(!Eof())
	nPos := aScan(aEmpresa,{ |x| x = SM0->M0_CODIGO } )
	If nPos = 0 .and. SM0->M0_CODIGO $ ('01/02/03/04')
		AADD(aEmpresa,SM0->M0_CODIGO)
	EndIf
	nPos := 0
	SM0->(dbSkip())
EndDo
SM0->(Dbgoto(nRecSM0))

//Monta Query para Extrair dados de Capta็ใo
cQuery1 := " SELECT C5_DIA,A3_SUPER,SUM(C6_VALOR) C6_VALOR,B1_GRUPO  FROM ("
For _i := 1 to Len(aEmpresa)
	If _i > 1
		cQuery1 += " UNION ALL"
	EndIf
	cQuery1 += " SELECT SUBSTRING(C5_EMISSAO,7,2) C5_DIA,A3_SUPER,"
	If aEmpresa[_i]="01"
		cQuery1 += " SUM(CASE WHEN C6_BLQ = 'R' AND C6_ZVALLIQ > 0 THEN C6_ZVALLIQ/C6_QTDVEN*C6_QTDENT WHEN C6_ZVALLIQ > 0 THEN C6_ZVALLIQ WHEN C6_BLQ = 'R' THEN C6_VALOR/C6_QTDVEN*C6_QTDENT ELSE C6_VALOR END) C6_VALOR,B1_GRUPO " // Alterar apos criacao do campo em outras empresas
	Else
		cQuery1 += " SUM(CASE WHEN C6_BLQ = 'R' THEN C6_VALOR/C6_QTDVEN*C6_QTDENT ELSE C6_VALOR END) C6_VALOR,B1_GRUPO "
	EndIf
	cQuery1 += " FROM SC5"+aEmpresa[_i]+"0 SC5 "
	cQuery1 += " INNER JOIN SC6"+aEmpresa[_i]+"0 SC6 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA AND SC6.D_E_L_E_T_ = ' ' "
	cQuery1 += " LEFT JOIN SA3"+aEmpresa[_i]+"0 SA3 ON A3_FILIAL = '"+xFilial("SA3")+"' AND C5_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = '' "
	cQuery1 += " LEFT JOIN SA1"+aEmpresa[_i]+"0 SA1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery1 += " LEFT JOIN SF4"+aEmpresa[_i]+"0 SF4 ON F4_FILIAL = '"+xFilial("SF4")+"' AND C6_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "
	cQuery1 += " LEFT JOIN SB1"+aEmpresa[_i]+"0 SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	cQuery1 += " LEFT JOIN SBM010 SBM ON BM_FILIAL = '"+xFilial("SBM")+"' AND B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ' '  AND BM_GRUPO >= '"+MV_PAR03+"' AND BM_GRUPO <= '"+MV_PAR04+"'  "
	If aEmpresa[_i]="01"
		cQuery1 += " LEFT JOIN PC1"+aEmpresa[_i]+"0 PC1 ON C6_NUM=PC1_PEDREP AND PC1.D_E_L_E_T_ = ' ' "
	EndIf
	cQuery1 += " WHERE "
	cQuery1 += " C5_FILIAL <> ' ' AND"
	cQuery1 += " SUBSTRING(C5_EMISSAO,1,6) = '"+StrZero(mv_par02,4,0)+StrZero(mv_par01,2,0)+"' AND "
	cQuery1 += " C5_TIPO = 'N' AND "
	cQuery1 += " A1_GRPVEN NOT IN ('ST','SC') AND "
	cQuery1 += " A1_EST <> 'EX' AND "
	cQuery1 += " F4_DUPLIC = 'S' AND "
	cQuery1 += " BM_XAGRUP <> ' ' AND "
	If aEmpresa[_i]="01"
		cQuery1 += " PC1_PEDREP IS NULL AND
	EndIf
	cQuery1 += " SC5.D_E_L_E_T_ = ' ' "  
	 //Giovani Zago 10/10/2013 projeto ibl separa por filial
	 //cQuery1 += " AND SC5.C5_FILIAL = '"+xFilial("SC5")+"'" 
	 //******************************************************
	cQuery1 += " GROUP BY SUBSTRING(C5_EMISSAO,7,2),A3_SUPER,B1_GRUPO "
Next _i	
cQuery1 += " )SC GROUP BY C5_DIA,A3_SUPER,B1_GRUPO "
cQuery1 += " ORDER BY 1,2,4 "

cQuery1 := ChangeQuery(cQuery1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fecha Alias se estiver em Uso ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta Area de Trabalho executando a Query ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery1),cAlias1,.T.,.T.)

TCSetField(cAlias1,"C6_VALOR","N",TamSx3("C6_VALOR")[1],TamSx3("C6_VALOR")[2])

oReport:SetTitle(cTitulo)

dbeval({||nCont++})

oReport:SetMeter(nCont)

aFill(aDados1,nil)
oSection1:Init()

dbSelectArea(cAlias1)
(cAlias1)->(dbGoTop())

//Atualiza Array com dados de Capta็ใo
While (cAlias1)->(!Eof()) 



	oReport:IncMeter()
	
	nValor	:= (cAlias1)->C6_VALOR
	nPos	:= aScan(aCapt,{ |x| x[1] = (cAlias1)->C5_DIA .And. x[3] = AllTrim((cAlias1)->B1_GRUPO) } )
	
	nPos1	:= aScan(_aDias,{|x| x[1] = (cAlias1)->C5_DIA  } )
	
	If nPos > 0
	
		aCapt[nPos][02] += nValor		   	
	Else    
	    AADD(aCapt,{;
		(cAlias1)->C5_DIA,nValor,(cAlias1)->B1_GRUPO})
	EndIf 
	
	If nPos1 > 0
	
		_aDias[nPos1][02] += nValor	   	
	Else    
	    AADD(_aDias,{;
		(cAlias1)->C5_DIA,nValor})
		
	EndIf
	(cAlias1)->(dbSkip())
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fecha Alias se estiver em Uso ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

//Imprime os dados de Metas
aFill(aDados1,nil)
oSection1:Init()
   
oSection1:PrintLine()
aFill(aDados1,nil)

oReport:SkipLine()
oSection1:Finish() 


//Imprime Acumlado
aFill(aDados2,nil)
aFill(_aAcDia,nil) 
oSection2:Init()

For _i := 1 To Len(_aDias)                                      
 
	aDados2[01]  := _aDias[_i][01]
	aDados2[02]  := _aDias[_i][02] 
	
   For _z:=1 to len(aGrupo)
        
     	For _y := 1 to Len(aCapt)
     	  
     	 nPos := 0
     	  
     	 If  AllTrim(aCapt[_y,03]) ==  AllTrim(aGrupo[_z,01]) .And. aCapt[_y,01] ==  _aDias[_i][01] 
	   	    oSection2:ACELL[(_z+2)]:UVALUE := aCapt[_y,02]   
	   	 Endif       
	    Next _y  
   Next _z 
   
   
   

   oSection2:PrintLine()
   aFill(aDados2,nil)
   aFill(_aAcDia,nil)
   
   For _z:=1 to len(aGrupo)       	         
	oSection2:ACELL[(_z+2)]:UVALUE := 0
   Next _z 
   	
    
Next _i

oReport:SkipLine()
oSection2:Finish()



Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusta    บAutor  ณMicrosiga           บ Data ณ  03/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Insere novas perguntas na tabela SX1 a Ajusta o Picture    บฑฑ
ฑฑบ          ณ dos valores no SX3                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Mes ?                          ","Mes ?                         ","Mes ?                         ","mv_ch1","N",2,0,0,"G","NaoVazio().and.MV_PAR01<=12","mv_par01","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Ano ?             	         ","Ano ?             	          ","Ano ?                         ","mv_ch2","N",4,0,0,"G","NaoVazio().and.MV_PAR02<=2100.and.MV_PAR02>2000","mv_par02","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""}) 
Aadd(aPergs,{"Grupo De ?             	     ","Grupo De ?             	      ","Grupo De ?                    ","mv_ch3","C",4,0,0,"G","NaoVazio() ","mv_par03","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Grupo Ate ?             	     ","Grupo Ate ?             	  ","Grupo Ate ?                   ","mv_ch4","C",4,0,0,"G","NaoVazio() ","mv_par04","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})


//AjustaSx1("STFATR06",aPergs)

Return

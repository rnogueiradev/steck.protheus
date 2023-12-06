#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTRCIMP1  บAutor  ณMicrosiga           บ Data ณ  28/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para atualiza็ใo da Tabela CFD conforme defini็ใo daบฑฑ
ฑฑบ          ณ area fiscal da Steck                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STRCIMP1()

Ajusta()

If Pergunte("STRCIMP1",.t.)

	Processa({||STRCIMPA(),"Processando... "})

EndIf

Return

Static Function STRCIMPA()

Local	cAlias 		:= GetNextAlias()
Local	cQuery		:= ""
Local	cAlias1		:= GetNextAlias()
Local	cQuery1		:= ""
Local	nValorVI	:= 0
Local	nCount		:= 0

Private	aPrdImp		:= {}
Private cCodPrd		:= ""
Private aEstPrdImp	:= {}
Private nValorI		:= 0
Private nValorE		:= 0
Private cDtImp		:= 0
Private cDtExt		:= 0

//Monta a Regua
ProcRegua(nCount)

IncProc("Lendo Documentos de Entrada.")

cQuery	:=	"SELECT TEMP.D1_COD,TEMP.DT_IMP,"
cQuery	+=	"(SELECT CASE WHEN SUM(D1_QUANT)>0 THEN ROUND(SUM(D1_TOTAL+D1_VALFRE+D1_SEGURO)/SUM(D1_QUANT),6) ELSE 0 END D1_CI "
cQuery	+=	"FROM "+RetSqlName("SD1")+" SD1 "
cQuery	+=	"WHERE "
cQuery	+=	"D1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery	+=	"SUBSTR(D1_CF,1,1)='3' AND "
cQuery	+=	"SD1.D1_COD=TEMP.D1_COD AND "
cQuery	+=	"SUBSTR(SD1.D1_EMISSAO,1,6)=TEMP.DT_IMP AND "
cQuery	+=	"D_E_L_E_T_=' ' "
cQuery	+=	") AS D1_CI FROM ( "
cQuery	+=	"SELECT D1_COD,MAX(SUBSTR(D1_EMISSAO,1,6))DT_IMP "
cQuery	+=	"FROM "+RetSqlName("SD1")+" SD1 "
cQuery	+=	"INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD=D1_COD AND SB1.D_E_L_E_T_=' ' "
cQuery	+=	"WHERE "
cQuery	+=	"D1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery	+=	"D1_EMISSAO BETWEEN '20120101' AND '"+mv_par01+"1231' AND "
cQuery	+=	"SUBSTR(D1_CF,1,1)='3' AND "
cQuery	+=	"D1_QUANT>0 AND "
cQuery	+=	"B1_ORIGEM='1' AND "
cQuery	+=	"SD1.D_E_L_E_T_=' ' "
cQuery	+=	"GROUP BY D1_COD ORDER BY D1_COD)TEMP "

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)

TCSetField(cAlias,"D1_CI","N",14,6 )

dbSelectArea(cAlias)
(cAlias)->(DbGoTop())

While (cAlias)->(!Eof())
	IncProc("Listando produtos com CI: "+(cAlias)->D1_COD)
	AADD(aPrdImp,{(cAlias)->D1_COD,(cAlias)->DT_IMP,(cAlias)->D1_CI} )
	(cAlias)->(DbSkip())
End

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
EndIf

IncProc("Lendo Documentos de Saida.")

cQuery1	:=	"SELECT TEMP.D2_COD,"
cQuery1	+=	"(SELECT CASE WHEN SUM(D2_QUANT)>0 THEN ROUND(SUM(D2_VALBRUT-D2_ICMSRET-D2_VALICM-D2_VALIPI)/SUM(D2_QUANT),2) ELSE 0 END D2_VE  "
cQuery1	+=	"FROM "+RetSqlName("SD2")+" SD2 "
cQuery1	+=	"WHERE "
cQuery1	+=	"D2_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery1	+=	"D2_CF IN ('6107','6101','6103','6105','6109','6111','6113','6116','6118','6122','6124','6125','6401','6402','6404','6910','6911','6923','6949') AND "
cQuery1	+=	"SD2.D2_COD=TEMP.D2_COD AND "
cQuery1	+=	"SUBSTR(SD2.D2_EMISSAO,1,4)=TEMP.DT_EXT AND "
cQuery1	+=	"D_E_L_E_T_=' ' "
cQuery1	+=	") AS D2_VE,DT_EXT,"
cQuery1	+=	"(SELECT CASE WHEN SUM(D2_QUANT) > 0 THEN ROUND(SUM(D2_VALBRUT-D2_ICMSRET-D2_VALICM-D2_VALIPI)/SUM(D2_QUANT),2) ELSE 0 END D2_VI  "
cQuery1	+=	"FROM "+RetSqlName("SD2")+" SD2 "
cQuery1	+=	"WHERE  "
cQuery1	+=	"D2_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery1	+=	"D2_CF IN ('5107','5101','5103','5105','5109','5111','5113','5116','5118','5122','5124','5125','5401','5402','5404','5151','5910','5911','5923','5949') AND "
cQuery1	+=	"SD2.D2_COD=TEMP.D2_COD AND "
cQuery1	+=	"SUBSTR(SD2.D2_EMISSAO,1,4)=TEMP.DT_INT AND "
cQuery1	+=	"D_E_L_E_T_=' ' "
cQuery1	+=	") AS D2_VI,DT_INT  "
cQuery1	+=	"FROM ( "
cQuery1	+=	"SELECT D2_COD,MAX(DT_EXT)DT_EXT,MAX(DT_INT)DT_INT FROM ( "
cQuery1	+=	"SELECT D2_COD,"
cQuery1	+=	"CASE WHEN D2_CF IN ('6107','6101','6103','6105','6109','6111','6113','6116','6118','6122','6124','6125','6401','6402','6404','6910','6911','6923','6949') THEN SUBSTR(D2_EMISSAO,1,4) ELSE '        ' END AS DT_EXT,"
cQuery1	+=	"CASE WHEN D2_CF IN ('5107','5101','5103','5105','5109','5111','5113','5116','5118','5122','5124','5125','5401','5402','5404','5151','5910','5911','5923','5949') THEN SUBSTR(D2_EMISSAO,1,4) ELSE '        ' END AS DT_INT "
cQuery1	+=	"FROM "+RetSqlName("SD2")+" SD2 "
cQuery1	+=	"INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD=D2_COD AND SB1.D_E_L_E_T_=' ' "
cQuery1	+=	"WHERE "
cQuery1	+=	"D2_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery1	+=	"SUBSTR(D2_EMISSAO,1,4) = '"+mv_par01+"' AND "
cQuery1	+=	"D2_CF IN ('6107','6101','6103','6105','6109','6111','6113','6116','6118','6122','6124','6125','6401','6402','6404','6910','6911','6923','6949','5107','5101','5103','5105','5109','5111','5113','5116','5118','5122','5124','5125','5401','5402','5404','5151','5910','5911','5923','5949') AND "
cQuery1	+=	"D2_QUANT > 0 AND "
cQuery1	+=	"D2_COD BETWEEN ' ' AND 'zzzzzzzzzzzzzzzzzz' AND "
cQuery1	+=	"B1_ORIGEM IN ('0','3','5','8') AND "
cQuery1	+=	"SD2.D_E_L_E_T_=' ')SD2 "
cQuery1	+=	"GROUP BY D2_COD ORDER BY D2_COD)TEMP "

If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery1),cAlias1,.F.,.T.)

TCSetField(cAlias1,"D2_VE","N",16,2 )
TCSetField(cAlias1,"D2_VI","N",16,2 )

dbSelectArea(cAlias1)
(cAlias1)->(DbGoTop())
While (cAlias1)->(!Eof())
	
	IncProc("Analisando o Produto: "+(cAlias1)->D2_COD)
	
	cCodPrd		:= (cAlias1)->D2_COD
	nValorI		:= (cAlias1)->D2_VI
	nValorE		:= (cAlias1)->D2_VE
	cDtExt		:= (cAlias1)->DT_EXT
	cDtImp		:= (cAlias1)->DT_INT

	nValorVI	:= Round(STRCIMPB((cAlias1)->D2_COD,1),2)
	
	cCodPrd		:= ""
	nValorI		:= 0
	nValorE		:= 0

	(cAlias1)->(DbSkip())
End

If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
EndIf

//IncProc("Imprimindo.")

//STRCIMPD()

MsgInfo("Processo Finalizado!")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTRCIMPB  บAutor  ณMicrosiga           บ Data ณ  10/15/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para calculo do valor de importa็ใo com base no ca- บฑฑ
ฑฑบ          ณ dastro de estruturas de produto                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STRCIMPB(cCodigo,nQtdMult)

Local cQuery2	:= ""
Local cAlias2	:= GetNextAlias()
Local nImp		:= 0
Local nRet		:= 0

cQuery2	+= "SELECT G1_NIVEL,G1_COD,G1_COMP,SUM(G1_QUANT) G1_QUANT FROM ( "
cQuery2	+= "SELECT 'N' G1_NIVEL,SG11.G1_COD,SG11.G1_COMP,SG11.G1_QUANT AS G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery2	+= "SG12.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT 'N',SG11.G1_COD,SG12.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery2	+= "SG13.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT 'N',SG11.G1_COD,SG13.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT*SG13.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG14 ON SG13.G1_FILIAL=SG14.G1_FILIAL AND SG13.G1_COMP=SG14.G1_COD AND SG14.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery2	+= "SG14.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT 'N',SG11.G1_COD,SG14.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT*SG13.G1_QUANT*SG14.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG14 ON SG13.G1_FILIAL=SG14.G1_FILIAL AND SG13.G1_COMP=SG14.G1_COD AND SG14.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG15 ON SG14.G1_FILIAL=SG15.G1_FILIAL AND SG14.G1_COMP=SG15.G1_COD AND SG15.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery2	+= "SG15.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT 'N',SG11.G1_COD,SG15.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT*SG13.G1_QUANT*SG14.G1_QUANT*SG15.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG14 ON SG13.G1_FILIAL=SG14.G1_FILIAL AND SG13.G1_COMP=SG14.G1_COD AND SG14.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG15 ON SG14.G1_FILIAL=SG15.G1_FILIAL AND SG14.G1_COMP=SG15.G1_COD AND SG15.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG16 ON SG15.G1_FILIAL=SG16.G1_FILIAL AND SG15.G1_COMP=SG16.G1_COD AND SG16.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery2	+= "SG16.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT 'N',SG11.G1_COD,SG16.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT*SG13.G1_QUANT*SG14.G1_QUANT*SG15.G1_QUANT*SG16.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG14 ON SG13.G1_FILIAL=SG14.G1_FILIAL AND SG13.G1_COMP=SG14.G1_COD AND SG14.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG15 ON SG14.G1_FILIAL=SG15.G1_FILIAL AND SG14.G1_COMP=SG15.G1_COD AND SG15.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG16 ON SG15.G1_FILIAL=SG16.G1_FILIAL AND SG15.G1_COMP=SG16.G1_COD AND SG16.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG17 ON SG16.G1_FILIAL=SG17.G1_FILIAL AND SG16.G1_COMP=SG17.G1_COD AND SG17.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery2	+= "SG17.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT 'N',SG11.G1_COD,SG17.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT*SG13.G1_QUANT*SG14.G1_QUANT*SG15.G1_QUANT*SG16.G1_QUANT*SG17.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG14 ON SG13.G1_FILIAL=SG14.G1_FILIAL AND SG13.G1_COMP=SG14.G1_COD AND SG14.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG15 ON SG14.G1_FILIAL=SG15.G1_FILIAL AND SG14.G1_COMP=SG15.G1_COD AND SG15.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG16 ON SG15.G1_FILIAL=SG16.G1_FILIAL AND SG15.G1_COMP=SG16.G1_COD AND SG16.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG17 ON SG16.G1_FILIAL=SG17.G1_FILIAL AND SG16.G1_COMP=SG17.G1_COD AND SG17.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG18 ON SG17.G1_FILIAL=SG18.G1_FILIAL AND SG17.G1_COMP=SG18.G1_COD AND SG18.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery2	+= "SG18.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT 'N',SG11.G1_COD,SG18.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT*SG13.G1_QUANT*SG14.G1_QUANT*SG15.G1_QUANT*SG16.G1_QUANT*SG17.G1_QUANT*SG18.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG14 ON SG13.G1_FILIAL=SG14.G1_FILIAL AND SG13.G1_COMP=SG14.G1_COD AND SG14.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG15 ON SG14.G1_FILIAL=SG15.G1_FILIAL AND SG14.G1_COMP=SG15.G1_COD AND SG15.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG16 ON SG15.G1_FILIAL=SG16.G1_FILIAL AND SG15.G1_COMP=SG16.G1_COD AND SG16.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG17 ON SG16.G1_FILIAL=SG17.G1_FILIAL AND SG16.G1_COMP=SG17.G1_COD AND SG17.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG18 ON SG17.G1_FILIAL=SG18.G1_FILIAL AND SG17.G1_COMP=SG18.G1_COD AND SG18.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG19 ON SG18.G1_FILIAL=SG19.G1_FILIAL AND SG18.G1_COMP=SG19.G1_COD AND SG19.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery2	+= "SG19.G1_FILIAL IS NULL AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= "UNION ALL "
cQuery2	+= "SELECT CASE WHEN SG10.G1_FILIAL IS NULL THEN 'N' ELSE 'S'END,SG11.G1_COD,SG19.G1_COMP,SG11.G1_QUANT*SG12.G1_QUANT*SG13.G1_QUANT*SG14.G1_QUANT*SG15.G1_QUANT*SG16.G1_QUANT*SG17.G1_QUANT*SG18.G1_QUANT*SG19.G1_QUANT "
cQuery2	+= "FROM "+RetSqlName("SG1")+" SG11 "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG12 ON SG11.G1_FILIAL=SG12.G1_FILIAL AND SG11.G1_COMP=SG12.G1_COD AND SG12.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG13 ON SG12.G1_FILIAL=SG13.G1_FILIAL AND SG12.G1_COMP=SG13.G1_COD AND SG13.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG14 ON SG13.G1_FILIAL=SG14.G1_FILIAL AND SG13.G1_COMP=SG14.G1_COD AND SG14.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG15 ON SG14.G1_FILIAL=SG15.G1_FILIAL AND SG14.G1_COMP=SG15.G1_COD AND SG15.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG16 ON SG15.G1_FILIAL=SG16.G1_FILIAL AND SG15.G1_COMP=SG16.G1_COD AND SG16.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG17 ON SG16.G1_FILIAL=SG17.G1_FILIAL AND SG16.G1_COMP=SG17.G1_COD AND SG17.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG18 ON SG17.G1_FILIAL=SG18.G1_FILIAL AND SG17.G1_COMP=SG18.G1_COD AND SG18.D_E_L_E_T_=' ' "
cQuery2	+= "INNER JOIN "+RetSqlName("SG1")+" SG19 ON SG18.G1_FILIAL=SG19.G1_FILIAL AND SG18.G1_COMP=SG19.G1_COD AND SG19.D_E_L_E_T_=' ' "
cQuery2	+= "LEFT JOIN "+RetSqlName("SG1")+" SG10 ON SG19.G1_FILIAL=SG10.G1_FILIAL AND SG19.G1_COMP=SG10.G1_COD AND SG10.D_E_L_E_T_=' ' "
cQuery2	+= "WHERE "
cQuery2	+= "SG11.G1_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery2	+= "SG11.D_E_L_E_T_=' ' "
cQuery2	+= ")TEMP "
cQuery2	+= "WHERE G1_COD='"+cCodigo+"' "
cQuery2	+= "GROUP BY G1_COD,G1_COMP,G1_NIVEL "

If !Empty(Select(cAlias2))
	DbSelectArea(cAlias2)
	(cAlias2)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery2),cAlias2,.F.,.T.)

TCSetField(cAlias2,"G1_QUANT","N",14,6 )

dbSelectArea(cAlias2)
(cAlias2)->(DbGoTop())

While (cAlias2)->(!Eof())
	
	nPosComp := Ascan(aPrdImp,{ |x| x[1] == (cAlias2)->G1_COMP })
	
	If nPosComp=0
		If (cAlias2)->G1_NIVEL="S"
			nRet += STRCIMPC((cAlias2)->G1_COMP,(cAlias2)->G1_QUANT)
		EndIf
	Else
		nImp := aPrdImp[nPosComp][3]
		If (cAlias2)->G1_QUANT>0
			//Aadd(aEstPrdImp,{cCodPrd,(cAlias2)->G1_COMP,aPrdImp[nPosComp][2],aPrdImp[nPosComp][3],(cAlias2)->G1_QUANT*nQtdMult,(cAlias2)->G1_QUANT*nQtdMult*nImp,nValorI,nValorE})
			RecLock("SZ8",.T.)
			SZ8->Z8_FILIAL	:= xFilial("SZ8")
			SZ8->Z8_COD		:= cCodPrd
			SZ8->Z8_DEXT	:= cDtExt
			SZ8->Z8_DINT	:= cDtImp
			SZ8->Z8_VEXT	:= nValorE
			SZ8->Z8_VINT	:= nValorI
			SZ8->Z8_COMP	:= (cAlias2)->G1_COMP
			SZ8->Z8_DIMP	:= aPrdImp[nPosComp][2]
			SZ8->Z8_VIMP	:= aPrdImp[nPosComp][3]
			SZ8->Z8_QCOMP	:= (cAlias2)->G1_QUANT*nQtdMult
			SZ8->Z8_CIMP	:= (cAlias2)->G1_QUANT*nQtdMult*nImp
			SZ8->Z8_DCALC	:= dDataBase
			MsUnlock()			
			nRet += ((cAlias2)->G1_QUANT*nQtdMult*nImp)
		Else
			//Aadd(aEstPrdImp,{cCodPrd,(cAlias2)->G1_COMP,aPrdImp[nPosComp][2],aPrdImp[nPosComp][3],(cAlias2)->G1_QUANT*nQtdMult,(cAlias2)->G1_QUANT*nQtdMult*nImp,nValorI,nValorE})
			RecLock("SZ8",.T.)
			SZ8->Z8_FILIAL	:= xFilial("SZ8")
			SZ8->Z8_COD		:= cCodPrd
			SZ8->Z8_DEXT	:= cDtExt
			SZ8->Z8_DINT	:= cDtImp
			SZ8->Z8_VEXT	:= nValorE
			SZ8->Z8_VINT	:= nValorI
			SZ8->Z8_COMP	:= (cAlias2)->G1_COMP
			SZ8->Z8_DIMP	:= aPrdImp[nPosComp][2]
			SZ8->Z8_VIMP	:= aPrdImp[nPosComp][3]
			SZ8->Z8_QCOMP	:= 0.0001
			SZ8->Z8_CIMP	:= 0.0001*nImp
			SZ8->Z8_DCALC	:= dDataBase
			MsUnlock()			
			nRet += (0.0001*nImp)
		EndIf
	EndIf
	
	(cAlias2)->(DbSkip())
	
End

If !Empty(Select(cAlias2))
	DbSelectArea(cAlias2)
	(cAlias2)->(dbCloseArea())
EndIf

Return(nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTRCIMPC  บAutor  ณMicrosiga           บ Data ณ  09/29/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcใo para valida็ใo do componente caso seja intermediarioบฑฑ
ฑฑบ          ณ processa novamente                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function STRCIMPC(cProduto,nQtdMult)

Local cQuery3	:= ""
Local cAlias3	:= GetNextAlias()
Local nRet		:= 0
Local lValid	:= .F.

cQuery3	:= "SELECT G1_COD FROM "+RetSqlName("SG1")+" SG1 WHERE G1_COD='"+cProduto+"' AND SG1.D_E_L_E_T_= ' ' GROUP BY G1_COD "

If !Empty(Select(cAlias3))
	DbSelectArea(cAlias3)
	(cAlias3)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery3),cAlias3,.F.,.T.)

dbSelectArea(cAlias3)
(cAlias3)->(DbGoTop())
While (cAlias3)->(!Eof())
	If (cAlias3)->G1_COD=cProduto
		lValid := .T.
	EndIf
	(cAlias3)->(DbSkip())
End

If !Empty(Select(cAlias3))
	DbSelectArea(cAlias3)
	(cAlias3)->(dbCloseArea())
Endif

If lValid
	nRet += STRCIMPB(cProduto,nQtdMult)
EndIf

Return(nRet)

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

Aadd(aPergs,{"Ano ?             	         ","Ano ?             	          ","Ano ?                         ","mv_ch1","N",4,0,0,"G","NaoVazio().and.MV_PAR01<=2100.and.MV_PAR01>2000"	,"mv_par01","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})

//AjustaSx1("STRCIMP1",aPergs)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTRCIMPD  บAutor  ณMicrosiga           บ Data ณ  01/31/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera็ใo de Relatorio com dados de conteudo de importa็ใo    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/*
Static Function STRCIMPD()

Local oReport

oReport 	:= ReportDef()
oReport		:PrintDialog()

Return

Static Function ReportDef()
Local oReport
Local oSection1

oReport := TReport():New("STRCIMPD","RELATORIO DE CONTEUDO DE IMPORTACAO","STRCIMPD",{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir o conteudo de importa็ใo conforme parametros selecionados.")
oReport:SetLandscape()

oSection1 := TRSection():New(oReport,"Componentes",{"SG1"},)
TRCell():New(oSection1,"CODIGO"		,,"Cod.      ",,15,.F.,)
TRCell():New(oSection1,"DESC"		,,"Desc.     ",,30,.F.,)
TRCell():New(oSection1,"COMP"		,,"Componente",,15,.F.,)
TRCell():New(oSection1,"DCOMP"		,,"Desc.Comp.",,30,.F.,)
TRCell():New(oSection1,"DATAIMP"	,,"Data Imp. ",,10,.F.,)
TRCell():New(oSection1,"VALORIMP"	,,"Valor Imp.","@E 9,999,999.99",12,.F.,)
TRCell():New(oSection1,"QUANT"		,,"Quantidade","@E 9,999.999999",12,.F.,)
TRCell():New(oSection1,"TOTAL"		,,"Total     ","@E 9,999,999.99",12,.F.,)
TRCell():New(oSection1,"SAIDAI"		,,"Vlr.SaidaI","@E 9,999,999.99",12,.F.,)
TRCell():New(oSection1,"SAIDAE"		,,"Vlr.SaidaE","@E 9,999,999.99",12,.F.,)

oSection1:Cell("VALORIMP"	):SetHeaderAlign("RIGHT")
oSection1:Cell("QUANT"		):SetHeaderAlign("RIGHT")
oSection1:Cell("TOTAL"		):SetHeaderAlign("RIGHT")
oSection1:Cell("SAIDAI"		):SetHeaderAlign("RIGHT")
oSection1:Cell("SAIDAE"		):SetHeaderAlign("RIGHT")

oSection1:SetHeaderSection(.T.)
oSection1:Setnofilter("SG1")

Return oReport

Static Function ReportPrint(oReport)

Local cTitulo		:= OemToAnsi("Quantidades Vendidas refente "+mv_par01)
Local aDados1[10]

TRCell():New(oSection1,"CODIGO"		,,"Cod.      ",,15,.F.,)
TRCell():New(oSection1,"DESC"		,,"Desc.     ",,30,.F.,)
TRCell():New(oSection1,"COMP"		,,"Componente",,15,.F.,)
TRCell():New(oSection1,"DCOMP"		,,"Desc.Comp.",,30,.F.,)
TRCell():New(oSection1,"DATAIMP"	,,"Data Imp. ",,10,.F.,)
TRCell():New(oSection1,"VALORIMP"	,,"Valor Imp.","@E 9,999,999.99",12,.F.,)
TRCell():New(oSection1,"QUANT"		,,"Quantidade","@E 9,999.999999",12,.F.,)
TRCell():New(oSection1,"TOTAL"		,,"Total     ","@E 9,999,999.99",12,.F.,)
TRCell():New(oSection1,"SAIDAI"		,,"Vlr.SaidaI","@E 9,999,999.99",12,.F.,)
TRCell():New(oSection1,"SAIDAE"		,,"Vlr.SaidaE","@E 9,999,999.99",12,.F.,)

oSection1:Cell("CODIGO")	:SetBlock( { || aDados1[1]})
oSection1:Cell("DESC")		:SetBlock( { || aDados1[2]})
oSection1:Cell("COMP")		:SetBlock( { || aDados1[3]})
oSection1:Cell("DCOMP")		:SetBlock( { || aDados1[4]})
oSection1:Cell("DATAIMP")	:SetBlock( { || aDados1[5]})
oSection1:Cell("VALORIMP")	:SetBlock( { || aDados1[6]})
oSection1:Cell("QUANT")		:SetBlock( { || aDados1[7]})
oSection1:Cell("TOTAL")		:SetBlock( { || aDados1[8]})
oSection1:Cell("SAIDAI")	:SetBlock( { || aDados1[9]})
oSection1:Cell("SAIDAE")	:SetBlock( { || aDados1[10]})

oReport:SetMeter(0)

oReport:SetTitle(cTitulo)

aFill(aDados1,nil)
oSection1:Init()


DbSelectArea("SZ8")
SZ8->(DbSetOrder(1))
SZ8->(DbGotop())

While SZ8->(!Eof())
	DbSelectArea("SB1")
	SB1->(DbSetorder(1))
	SB1->(DbSeek(xFilial("SB1")+SZ8->Z8_COD))

	aDados1[1] := SZ8->Z8_COD
	aDados1[2] := SB1->B1_DESC
    
	DbSelectArea("SB1")
	SB1->(DbSetorder(1))
	SB1->(DbSeek(xFilial("SB1")+SZ8->Z8_COMP))

	aDados1[3] := SZ8->Z8_COMP
	aDados1[4] := SB1->B1_DESC

	aDados1[5] := SZ8->Z8_DIMP
	aDados1[6] := SZ8->Z8_VIMP
	aDados1[7] := SZ8->Z8_QCOMP
	aDados1[8] := SZ8->Z8_CIMP
	aDados1[9] := SZ8->Z8_VINT
	aDados1[10] := SZ8->Z8_VEXT

	oSection1:PrintLine()
	aFill(aDados1,nil)
	
	SZ8->(DbSkip())
End
oSection1:Finish()

Return
*/
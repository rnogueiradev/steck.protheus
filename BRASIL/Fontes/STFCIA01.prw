#Include "Protheus.ch" 
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFCIA01  บAutor  ณMicrosiga           บ Data ณ  28/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para atualiza็ใo da Tabela CFD conforme defini็ใo daบฑฑ
ฑฑบ          ณ area fiscal da Steck                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFCIA01()
	
	Local aSays		:= {}
	Local aButtons	:= {}
	
	Private cCadastro 	:= OemToAnsi("Atualiza็ใo da Tabela CFD para gera็ใo da FCI.")
	Private cPerg 		:= "STFCIA01"
	Private aHeader 	:= {}
	Private aCols		:= {}
	Private cTabela		:= ""
	Private oGetDados1
	Private nOpcao 		:= 0
	
	// Funcao para criacao de perguntas da rotina.
	Ajusta()
	
	Pergunte(cPerg,.t.)
	
	AAdd(aSays,"Este programa tem como objetivo atualizar a tabela CFD")
	AAdd(aSays,"Ficha de Conteudo de Importa็ใo com base nos parametros")
	AAdd(aSays,"selecionados.")
	
	AAdd(aButtons,{ 5,.T.,{|| Pergunte(cPerg,.t.) } } )
	AAdd(aButtons,{ 1,.T.,{|| IIF(fConfMark(),FechaBatch(),nOpcao := 0) } } )
	AAdd(aButtons,{ 2,.T.,{|| FechaBatch() } } )
	
	FormBatch(cCadastro,aSays,aButtons)
	
	If nOpcao == 1
		If ApMsgYesNo("Atualiza a Tabela FCI. (S/N)?")
			Processa({||STFCIA01A(),"Processando... "})
		EndIf
	EndIf
	
Return

Static Function STFCIA01A()
	
	Local	cAlias 		:= "STFQRY"
	Local	cQuery		:= ""
	Local	cAlias1		:= "STFQRY1"
	Local	cQuery1		:= ""
	Local	aFci		:= {}
	Local	cProduto	:= ""
	Local	cPerVen		:= ""
	Local	nValorVI	:= 0
	Local	nValorVO	:= 0
	Local	nValorCI	:= 0
	Local	nCount		:= 0
	Local	nX			:= 0
	Local	lValid		:= .F.
	
	Private	aPrdImp		:= {}
	Private cCodPrd		:= ""
	Private nValorI		:= 0
	Private nValorE		:= 0
	Private cDtImp		:= 0
	Private cDtExt		:= 0
	
	//Monta a Regua
	ProcRegua(nCount)
	
	/*
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
	cQuery	+=	"D1_EMISSAO BETWEEN '20120101' AND '"+StrZero(mv_par02,4,0)+StrZero(mv_par01,2,0)+"31' AND "
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
	*/
	
	If mv_par03 = 1
		IncProc("Lendo Documentos de Saida.")
		
		cQuery1	:=	"SELECT TEMP.D2_COD,"
		cQuery1	+=	"(SELECT CASE WHEN SUM(D2_QUANT)>0 THEN ROUND(SUM(D2_VALBRUT-D2_ICMSRET-D2_VALICM-D2_VALIPI)/SUM(D2_QUANT),2) ELSE 0 END D2_VE  "
		cQuery1	+=	"FROM "+RetSqlName("SD2")+" SD2 "
		cQuery1	+=	"WHERE "
		cQuery1	+=	"D2_FILIAL BETWEEN '  ' AND 'ZZ' AND "
		cQuery1	+=	"D2_CF IN ('6107','6101','6103','6105','6109','6111','6113','6116','6118','6122','6124','6125','6401','6402','6404','6910','6911','6923','6949') AND "
		cQuery1	+=	"SD2.D2_COD=TEMP.D2_COD AND "
		cQuery1	+=	"SUBSTR(SD2.D2_EMISSAO,1,6)=TEMP.DT_EXT AND "
		cQuery1	+=	"D_E_L_E_T_=' ' "
		cQuery1	+=	") AS D2_VE,DT_EXT,"
		cQuery1	+=	"(SELECT CASE WHEN SUM(D2_QUANT) > 0 THEN ROUND(SUM(D2_VALBRUT-D2_ICMSRET-D2_VALICM-D2_VALIPI)/SUM(D2_QUANT),2) ELSE 0 END D2_VI  "
		cQuery1	+=	"FROM "+RetSqlName("SD2")+" SD2 "
		cQuery1	+=	"WHERE  "
		cQuery1	+=	"D2_FILIAL BETWEEN '  ' AND 'ZZ' AND "
		cQuery1	+=	"D2_CF IN ('5107','5101','5103','5105','5109','5111','5113','5116','5118','5122','5124','5125','5401','5402','5404','5151','5910','5911','5923','5949') AND "
		cQuery1	+=	"SD2.D2_COD=TEMP.D2_COD AND "
		cQuery1	+=	"SUBSTR(SD2.D2_EMISSAO,1,6)=TEMP.DT_INT AND "
		cQuery1	+=	"D_E_L_E_T_=' ' "
		cQuery1	+=	") AS D2_VI,DT_INT  "
		cQuery1	+=	"FROM ( "
		cQuery1	+=	"SELECT D2_COD,MAX(DT_EXT)DT_EXT,MAX(DT_INT)DT_INT FROM ( "
		cQuery1	+=	"SELECT D2_COD,"
		cQuery1	+=	"CASE WHEN D2_CF IN ('6107','6101','6103','6105','6109','6111','6113','6116','6118','6122','6124','6125','6401','6402','6404','6910','6911','6923','6949') THEN SUBSTR(D2_EMISSAO,1,6) ELSE '        ' END AS DT_EXT,"
		cQuery1	+=	"CASE WHEN D2_CF IN ('5107','5101','5103','5105','5109','5111','5113','5116','5118','5122','5124','5125','5401','5402','5404','5151','5910','5911','5923','5949') THEN SUBSTR(D2_EMISSAO,1,6) ELSE '        ' END AS DT_INT "
		cQuery1	+=	"FROM "+RetSqlName("SD2")+" SD2 "
		cQuery1	+=	"INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD=D2_COD AND SB1.D_E_L_E_T_=' ' "
		cQuery1	+=	"WHERE "
		cQuery1	+=	"D2_FILIAL BETWEEN '  ' AND 'ZZ' AND "
		cQuery1	+=	"SUBSTR(D2_EMISSAO,1,6) = '"+StrZero(mv_par02,4,0)+StrZero(mv_par01,2,0)+"' AND "
		cQuery1	+=	"D2_CF IN ('6107','6101','6103','6105','6109','6111','6113','6116','6118','6122','6124','6125','6401','6402','6404','6910','6911','6923','6949','5107','5101','5103','5105','5109','5111','5113','5116','5118','5122','5124','5125','5401','5402','5404','5151','5910','5911','5923','5949') AND "
		cQuery1	+=	"D2_QUANT > 0 AND "
		cQuery1	+=	"D2_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
		cQuery1	+=	"B1_ORIGEM IN ('3','5','8') AND "
		cQuery1	+=	"SD2.D_E_L_E_T_=' ')SD2 "
		cQuery1	+=	"GROUP BY D2_COD ORDER BY D2_COD)TEMP "
		
	Else
		IncProc("Lendo Cadastro de Produtos.")
		
		cQuery1	:=	"SELECT B1_COD D2_COD, 0 D2_VE, '"+StrZero(mv_par01,2,0)+StrZero(mv_par02,4,0)+"' DT_EXT, 0 D2_VI, '"+StrZero(mv_par01,2,0)+StrZero(mv_par02,4,0)+"' DT_INT FROM ( "
		cQuery1	+=	"SELECT B1_COD "
		cQuery1	+=	"FROM "+RetSqlName("SB1")+" SB1 "
		cQuery1	+=	"LEFT JOIN "+RetSqlName("CFD")+" CFD ON CFD_FILIAL = ' ' AND CFD_COD=B1_COD AND CFD.D_E_L_E_T_ = ' ' "
		cQuery1	+=	"INNER JOIN (SELECT G1_COD FROM "+RetSqlName("SG1")+" SG1 WHERE G1_FILIAL BETWEEN ' ' AND 'ZZ' AND SG1.D_E_L_E_T_ = ' ' GROUP BY G1_COD)SG1 ON G1_COD=B1_COD "
		cQuery1	+=	"WHERE "
		cQuery1	+=	"B1_FILIAL = ' ' AND "
		cQuery1	+=	"B1_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
		cQuery1	+=	"CFD_FILIAL IS NULL AND "
		cQuery1	+=	"B1_MSBLQL <> '1' AND "
		cQuery1	+=	"B1_GRUPO <> '999' AND "
		cQuery1	+=	"B1_ORIGEM IN ('3','5','8') AND "
		cQuery1	+=	"SB1.D_E_L_E_T_ = ' '" // AND  NOT EXISTS(SELECT * FROM "+RetSqlName("CFD")+" CFD WHERE CFD_FILIAL = ' ' AND CFD_COD=B1_COD AND CFD.D_E_L_E_T_ = ' ' ) "
		cQuery1	+=	"ORDER BY SB1.R_E_C_N_O_ DESC "
		cQuery1	+=	")TEMP "
		cQuery1	+=	"WHERE ROWNUM <= 1000 "
		
	EndIf
	
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
		
		Begin Transaction
			
			nCount++
			
			IncProc("Atualizando FCI do Produto: "+(cAlias1)->D2_COD+" - "+cValtochar(nCount))
			
			nValorVO	:= 0
			nValorVI	:= 0
			nValorCI	:= 0
			
			cCodPrd		:= (cAlias1)->D2_COD
			nValorI		:= (cAlias1)->D2_VI
			nValorE		:= (cAlias1)->D2_VE
			cDtImp		:= (cAlias1)->DT_INT
			cDtExt		:= (cAlias1)->DT_EXT
			
			//Se nใo possuir data interestadual ou se a mesma for menor que a data Interna utilizar a interna
			If Empty((cAlias1)->DT_EXT) .Or. (cAlias1)->DT_INT>(cAlias1)->DT_EXT
				cProduto	:= (cAlias1)->D2_COD
				cPerVen		:= Substr((cAlias1)->DT_INT,5,2)+Substr((cAlias1)->DT_INT,1,4)
				nValorVO	:= (cAlias1)->D2_VI
				nValorVI	:= Round(U_STFCIB01((cAlias1)->D2_COD,1),2)
			Else
				cProduto	:= (cAlias1)->D2_COD
				cPerVen		:= Substr((cAlias1)->DT_EXT,5,2)+Substr((cAlias1)->DT_EXT,1,4)
				nValorVO	:= (cAlias1)->D2_VE
				nValorVI	:= Round(U_STFCIB01((cAlias1)->D2_COD,1),2)
			EndIf
			
			cCodPrd		:= ""
			nValorI		:= 0
			nValorE		:= 0
			cDtImp		:= ""
			cDtExt		:= ""
			
			If nValorVO = 0 .And. nValorVI > 0
				nValorVO	:= Round(U_STFCIC01((cAlias1)->D2_COD),2)
				If nValorVO = 0
					DbSelectArea("SB1")
					SB1->(DbSetOrder(1))
					SB1->(DbSeek(xFilial("SB1")+cProduto))
					If SB1->B1_ORIGEM="5"
						nValorVO	:= Round(nValorVI/0.3,2)
					ElseIf SB1->B1_ORIGEM="3"
						nValorVO	:= Round(nValorVI/0.5,2)
					Else
						nValorVO	:= Round(nValorVI/0.8,2)
					EndIf
					If nValorVO = 0
						nValorVO := 0.01
					EndIf
				EndIf
			EndIf
			
			nValorCI	:= IIf(nValorVO>0.AND.nValorVI>0,Round(nValorVI/nValorVO*100,2),0)
			
			If nValorVI > 0
				//AADD(aFci,{cProduto,nValorVO,nValorVI,nValorCI,IIF(nValorCI<40,5,IIF(nValorCI<70,3,8))} )
				DbSelectArea("CFD")
				CFD->(DbSetOrder(1))
				If !CFD->(DbSeek(xFilial("CFD")+mv_par04+StrZero(mv_par01,2,0)+StrZero(mv_par02,4,0)+cProduto))//CFD_FILIAL+CFD_PERCAL+CFD_PERVEN+CFD_COD
					RecLock("CFD",.T.)
					CFD->CFD_FILIAL := "  "
					CFD->CFD_PERCAL := mv_par04
					CFD->CFD_PERVEN := StrZero(mv_par01,2,0)+StrZero(mv_par02,4,0)
					CFD->CFD_COD	:= cProduto
					CFD->CFD_VSAIIE	:= nValorVO
					CFD->CFD_VPARIM	:= nValorVI
					CFD->CFD_CONIMP	:= nValorCI
					CFD->CFD_FILOP	:= "01"
					CFD->CFD_ORIGEM	:= IIF(nValorCI<=40,"5",IIF(nValorCI<=70,"3","8"))
					CFD->(MsUnLock())
					
					If nValorVO = 0
						lValid := .T.
					EndIf
					nX++
				EndIf
			Else
				RecLock("SZ8",.T.)
				SZ8->Z8_FILIAL	:= xFilial("SZ8")
				SZ8->Z8_COD		:= cProduto
				SZ8->Z8_COMP	:= ""
				SZ8->Z8_DCALC	:= dDataBase
				MsUnlock()
			EndIf
			
		End Transaction
		(cAlias1)->(DbSkip())
	End
	
	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	EndIf
	
	MsgAlert("Processo Finalizado!!! Foram gerados "+cValtochar(nX)+" registros de um total de "+cValtochar(nCount)+".")
	
	If lValid
		MsgAlert("Foram gerado produtos com valores zerados. Favor validar os mesmos!")
	EndIf
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFCIB01  บAutor  ณMicrosiga           บ Data ณ  10/15/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para calculo do valor de importa็ใo com base no ca- บฑฑ
ฑฑบ          ณ dastro de estruturas de produto                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFCIB01(cCodigo,nQtdMult)
	
	Local cQuery2	:= ""
	Local cAlias2	:= GetNextAlias()
	Local nImp		:= 0
	Local nRet		:= 0
	Local aStru		:= {}
	Local RecSM0	:= 0
	Local cArqTrab
	Local oTable
	
	/*
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
				nRet += U_STFCIVLD((cAlias2)->G1_COMP,(cAlias2)->G1_QUANT*nQtdMult)
			EndIf
		Else
			nImp := aPrdImp[nPosComp][3]
			If (cAlias2)->G1_QUANT>0
				nRet += ((cAlias2)->G1_QUANT*nQtdMult*nImp)
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
			Else
				nRet += (0.0001*nImp)
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
			EndIf
		EndIf
		
		(cAlias2)->(DbSkip())
		
	End
	
	If !Empty(Select(cAlias2))
		DbSelectArea(cAlias2)
		(cAlias2)->(dbCloseArea())
	EndIf
	*/
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Arquivo de Trabalho para a escolha do Grupo de Compra ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Aadd( aStru,{ "XX_TIPO"		,"C",01,0} )
	Aadd( aStru,{ "XX_FILIAL"	,"C",02,0} )
	Aadd( aStru,{ "XX_COD"		,"C",15,0} )
	Aadd( aStru,{ "XX_DESC"		,"C",30,0} )
	Aadd( aStru,{ "XX_QTD"		,"N",16,4} )
	Aadd( aStru,{ "XX_CM1"		,"N",16,4} )
	Aadd( aStru,{ "XX_CTOTAL"	,"N",16,4} )
	Aadd( aStru,{ "XX_FORNEC"	,"C",06,0} )
	Aadd( aStru,{ "XX_LOJA"		,"C",02,0} )
	Aadd( aStru,{ "XX_NOTA"		,"C",09,0} )
	Aadd( aStru,{ "XX_SERIE"	,"C",03,0} )
	Aadd( aStru,{ "XX_DATA"		,"D",08,0} )
	Aadd( aStru,{ "XX_ORIGEM"	,"C",01,0} )
	
	//cArqTrab := CriaTrab(aStru) 			  //Fun็ใo CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New(cAlias2) //adicionado 22/05/23
	oTable:SetFields(aStru)				      //adicionado 22/05/23

	oTable:AddIndex("01", {"XX_TIPO","XX_COD"} )

	If Select(cAlias2) > 0	// VERIFICA SE TABELA TRB ESTม ABERTA          
		(cAlias2)->(dbclosearea())
	EndIf 

	oTable:Create()							  //adicionado 22/05/23
	cArqTrab := oTable:GetRealName()		  //adicionado 22/05/23
	//IndRegua((cAlias2),cArqTrab,"XX_TIPO+XX_COD",,,"Indexando Arquivo...")

	
	DbSelectArea("SM0")
	SM0->(DbSetOrder(1))
	RecSM0 := SM0->(Recno())
	SM0->(DbGoTop())
	While SM0->(!Eof())
		If cEmpAnt = SM0->M0_CODIGO .And. SM0->M0_CODFIL = '05'
			//Alimenta Tabela Temporaria Estrutura
			If U_STENGRB1(cCodPrd,1,cAlias2,SM0->M0_CODFIL)
				Exit
				//Alimenta Tabela Temporaria Pr้-Estrutura
			ElseIf U_STENGRB2(cCodPrd,1,cAlias2,SM0->M0_CODFIL)
				Exit
			EndIf
		EndIf
		
		SM0->(DbSkip())
	End
	SM0->(DbGoTo(RecSM0))
	
	DbSelectArea(cAlias2)
	(cAlias2)->(dbGoTop())
	While (cAlias2)->(!Eof())
		If (cAlias2)->XX_TIPO="0"
			RecLock("SZ8",.T.)
			SZ8->Z8_FILIAL := (cAlias2)->XX_FILIAL
			SZ8->Z8_COD		:= cCodPrd
			SZ8->Z8_DEXT	:= cDtExt
			SZ8->Z8_DINT	:= cDtImp
			SZ8->Z8_VEXT	:= nValorE
			SZ8->Z8_VINT	:= nValorI
			SZ8->Z8_COMP	:= (cAlias2)->XX_COD
			SZ8->Z8_QCOMP	:= (cAlias2)->XX_QTD
			SZ8->Z8_VIMP	:= (cAlias2)->XX_CM1
			SZ8->Z8_CIMP	:= (cAlias2)->XX_CTOTAL
			SZ8->Z8_DCALC	:= dDataBase
			MsUnlock()
			/*
			aDados1[01] := IIF((cAlias2)->XX_TIPO="0","Importado","Nacional")
			aDados1[04] := (cAlias2)->XX_DESC
			aDados1[08] := (cAlias2)->XX_FORNEC
			aDados1[09] := (cAlias2)->XX_LOJA
			aDados1[10] := (cAlias2)->XX_NOTA
			aDados1[11] := (cAlias2)->XX_SERIE
			aDados1[12] := (cAlias2)->XX_DATA
			aDados1[13] := (cAlias2)->XX_ORIGEM
			*/
			nRet += IIF((cAlias2)->XX_CTOTAL>0,(cAlias2)->XX_CTOTAL,0.0001)
		EndIf
		
		(cAlias2)->(dbSkip())
	EndDo
	
Return(nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFCIVLD  บAutor  ณMicrosiga           บ Data ณ  09/29/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcใo para valida็ใo do componente caso seja intermediarioบฑฑ
ฑฑบ          ณ processa novamente                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFCIVLD(cProduto,nQtdM)
	
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
		nRet += U_STFCIB01(cProduto,nQtdM)
	EndIf
	
Return(nRet)

Static Function fConfMark()
	
	Local _lRet := .T.
	
	nOpcao := 1
	
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFCIC01  บAutor  ณMicrosiga           บ Data ณ  10/15/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para calculo do valor de opera็ใo estimado para os  บฑฑ
ฑฑบ          ณ casos em que o valor calculado ้ zero.                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFCIC01(cProduto)
	
	//Local cQuery3	:= ""
	//Local cAlias3	:= GetNextAlias()
	Local cQuery4	:= ""
	Local cAlias4	:= GetNextAlias()
	Local nRet		:= 0
	/*
	cQuery3	 := " SELECT C6_PRODUTO, C6_PRCVEN-C6_ZVALIPI-C6_ZVALICM PRECO, R_E_C_N_O_ REGISTRO "
	cQuery3  += " FROM " +RetSqlName("SC6")+ " C6 "
	cQuery3  += " WHERE R_E_C_N_O_ = ( "
	cQuery3	 += " SELECT MAX(R_E_C_N_O_) "
	cQuery3  += " FROM " +RetSqlName("SC6")+ " C6 "
	cQuery3  += " WHERE C6_FILIAL BETWEEN '  ' AND 'ZZ' AND D_E_L_E_T_ = ' ' AND C6_PRODUTO='"+cProduto+"' AND C6_PRCVEN-C6_ZVALIPI-C6_ZVALICM>0 "
	cQuery3  += " GROUP BY C6_PRODUTO) "
	
	If !Empty(Select(cAlias3))
		DbSelectArea(cAlias3)
		(cAlias3)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),cAlias3,.T.,.T.)
	
	dbSelectArea(cAlias3)
	(cAlias3)->(dbGoTop())
	While (cAlias3)->(!Eof())
		nRet	:= (cAlias3)->PRECO
		(cAlias3)->(DbSkip())
	End
	
	If !Empty(Select(cAlias3))
		DbSelectArea(cAlias3)
		(cAlias3)->(dbCloseArea())
	Endif
	
	If nRet = 0
		
		cQuery4	:= " SELECT UB_PRODUTO, UB_VRUNIT-UB_ZVALIPI-UB_ZVALICM PRECO, R_E_C_N_O_ REGISTRO "
		cQuery4 += " FROM " +RetSqlName("SUB")+ " UB "
		cQuery4 += " WHERE R_E_C_N_O_ = (  "
		cQuery4 += " SELECT MAX(R_E_C_N_O_) "
		cQuery4 += " FROM " +RetSqlName("SUB")+ " UB "
		cQuery4 += " WHERE D_E_L_E_T_=' ' AND UB_PRODUTO='"+cProduto+"' AND UB_VRUNIT-UB_ZVALIPI-UB_ZVALICM>0  GROUP BY UB_PRODUTO) "
		
		If !Empty(Select(cAlias4))
			DbSelectArea(cAlias4)
			(cAlias4)->(dbCloseArea())
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery4),cAlias4,.T.,.T.)
		
		dbSelectArea(cAlias4)
		(cAlias4)->(dbGoTop())
		
		While (cAlias4)->(!Eof())
			nRet	:= (cAlias4)->PRECO
			(cAlias4)->(DbSkip())
		End
		
		If !Empty(Select(cAlias4))
			DbSelectArea(cAlias4)
			(cAlias4)->(dbCloseArea())
		Endif
		
	EndIf
	*/
	
	cQuery4 := " SELECT B1_COD, "
	cQuery4 += " (SELECT D2_PRCVEN "
	cQuery4 += " FROM "+RetSqlName("SD2")+" SD2 "
	cQuery4 += " INNER JOIN (SELECT D2_COD DX_COD,MAX(R_E_C_N_O_)DX_REC "
	cQuery4 += "  		FROM "+RetSqlName("SD2")+" SD2 "
	cQuery4 += "  		WHERE SD2.D2_FILIAL <> ' ' AND SD2.D2_PRCVEN > 0 AND SD2.D_E_L_E_T_ = ' '  "
	cQuery4 += "  		GROUP BY D2_COD)SDX ON SDX.DX_COD=SD2.D2_COD AND SDX.DX_REC=SD2.R_E_C_N_O_  "
	cQuery4 += " WHERE SD2.D2_FILIAL <> ' ' AND SD2.D2_COD = SB1.B1_COD  "
	cQuery4 += " ) AS D2_PRCVEN, "
	cQuery4 += " (SELECT C6_PRCVEN "
	cQuery4 += " FROM "+RetSqlName("SC6")+" SC6 "
	cQuery4 += " INNER JOIN (SELECT C6_PRODUTO CX_COD,MAX(R_E_C_N_O_)CX_REC "
	cQuery4 += "  		FROM "+RetSqlName("SC6")+" SC6 "
	cQuery4 += "  		WHERE SC6.C6_FILIAL <> ' ' AND SC6.C6_PRCVEN > 0 AND SC6.D_E_L_E_T_ = ' '  "
	cQuery4 += "  		GROUP BY C6_PRODUTO)SCX ON SCX.CX_COD=SC6.C6_PRODUTO AND SCX.CX_REC=SC6.R_E_C_N_O_  "
	cQuery4 += " WHERE SC6.C6_FILIAL <> ' ' AND SC6.C6_PRODUTO = SB1.B1_COD  "
	cQuery4 += " ) AS C6_PRCVEN, "
	cQuery4 += " (SELECT UB_VRUNIT "
	cQuery4 += " FROM "+RetSqlName("SUB")+" SUB "
	cQuery4 += " INNER JOIN (SELECT UB_PRODUTO CX_COD,MAX(R_E_C_N_O_)CX_REC "
	cQuery4 += "  		FROM "+RetSqlName("SUB")+" SUB "
	cQuery4 += "  		WHERE SUB.UB_FILIAL <> ' ' AND SUB.UB_VRUNIT > 0 AND SUB.D_E_L_E_T_ = ' '  "
	cQuery4 += "  		GROUP BY UB_PRODUTO)SCX ON SCX.CX_COD=SUB.UB_PRODUTO AND SCX.CX_REC=SUB.R_E_C_N_O_  "
	cQuery4 += " WHERE SUB.UB_FILIAL <> ' ' AND SUB.UB_PRODUTO = SB1.B1_COD  "
	cQuery4 += " ) AS UB_VRUNIT "
	cQuery4 += " FROM "+RetSqlName("SB1")+" SB1 "
	cQuery4 += " WHERE B1_FILIAL = ' ' AND B1_COD = '"+cProduto+"' AND SB1.D_E_L_E_T_ = ' ' "
	
	If !Empty(Select(cAlias4))
		DbSelectArea(cAlias4)
		(cAlias4)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery4),cAlias4,.F.,.T.)
	
	TCSetField(cAlias4,"D2_PRCVEN"	,"N",14,2 )
	TCSetField(cAlias4,"C6_PRCVEN"	,"N",14,2 )
	TCSetField(cAlias4,"UB_VRUNIT"	,"N",14,2 )
	
	dbSelectArea(cAlias4)
	(cAlias4)->(DbGoTop())
	While (cAlias4)->(!Eof())
		If (cAlias4)->D2_PRCVEN>0
			//cObs := "Valor da Ultima Saida"
			nRet := (cAlias4)->D2_PRCVEN
		ElseIf (cAlias4)->C6_PRCVEN>0
			//cObs := "Valor do Ultimo Pedido"
			nRet := (cAlias4)->C6_PRCVEN
		ElseIf (cAlias4)->UB_VRUNIT>0
			//cObs := "Valor do Ultimo Or็amento"
			nRet := (cAlias4)->UB_VRUNIT
		Else
			nRet := 0
		EndIf
		(cAlias4)->(DbSkip())
	End
	
	//Adicionado Conforme solicita็ใo da Veronica 04/08/2016
	If nRet <= 0.1
		nRet := 0
	EndIf
	
	
	If !Empty(Select(cAlias4))
		DbSelectArea(cAlias4)
		(cAlias4)->(dbCloseArea())
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
	
	Aadd(aPergs,{"Mes ?                          ","Mes ?                         ","Mes ?                         ","mv_ch1","N",2,0,0,"G","NaoVazio().and.MV_PAR01<=12"						,"mv_par01","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Ano ?             	         ","Ano ?             	          ","Ano ?                         ","mv_ch2","N",4,0,0,"G","NaoVazio().and.MV_PAR02<=2100.and.MV_PAR02>2000"	,"mv_par02","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Modo de Gera็ใo?               ","Modo de Gera็ใo?              ","Modo de Gera็ใo?              ","mv_ch3","N",1,0,2,"C",""													,"mv_par03","Faturamento    ","Faturamento    ","Faturamento    ","","","Cadastro       ","Cadastro       ","Cadastro       ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Periodo de Calculo ?           ","Periodo de Calculo ?          ","Periodo de Calculo ?          ","mv_ch4","C",6,0,0,"G","NaoVazio()"										,"mv_par04","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Produto de ?                   ","Produto de ?                  ","Produto de ?                  ","mv_ch5","C",15,0,0,"G",""													,"mv_par05","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","SB1","S","",""})
	Aadd(aPergs,{"Produto ate ?                  ","Produto ate ?                 ","Produto ate ?                 ","mv_ch6","C",15,0,0,"G",""													,"mv_par06","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","SB1","S","",""})
	
	//AjustaSx1("STFCIA01",aPergs)
	
Return

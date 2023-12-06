#INCLUDE "PROTHEUS.ch"
#DEFINE CRLF    chr(13)+chr(10) // Carreage Return (Fim de Linha)
/*====================================================================================\
|Programa  | STFINR14       | Autor | GIOVANI.ZAGO               | Data | 27/12/2012  |
|=====================================================================================|
|Descrição | Relatorio de Captação Mensal por Grupo de Produtos.                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STFINR14                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function STFINR14()
	*---------------------------------------------------*
	Local wnrel
	Local cString  := "SB1"
	Local titulo   := "Relatorio de Captação Mensal por Grupo de Produtos"
	Local NomeProg := "STFINR01"
	Local Tamanho  := "G"
	Local aOrd 	   := {}
	Local cDesc1   :="Este programa tem como objetivo imprimir relatorio "
	Local cDesc2   :="de Captação Mensal por Grupo de Produtos. "
	Private cPerg  := "SFIR14"
	Private nEsp   := 12
	Private cAliasLif := ' '
	Private  aQuerSd2 :={}
	Private aDados    :={}
	Private aDados2    :={}
	Private aReturn := {'Zebrado', 1,'Administra‡„o', 2, 2, 1, '',1}
	Private	_aMeses := { "Janeiro"+space(nEsp-len("Janeiro")),"Fevereiro"+space(nEsp-len("Fevereiro")),"Março"+space(nEsp-len("Marco")),"Abril"+space(nEsp-len("Abril"))   ,"Maio"+space(nEsp-len("Maio")),;
		"Junho"+space(nEsp-len("Junho"))  ,"Julho"+space(nEsp-len("Julho"))   ,"Agosto"+space(nEsp-len("Agosto")),"Setembro"+space(nEsp-len("Setembro")),"Outubro"+space(nEsp-len("Outubro")),"Novembro"+space(nEsp-len("Novembro")),"Dezembro"+space(nEsp-len("Dezembro")),"Media"+space(nEsp-len("Media"))}
	
	ajustaSX1(cPerg)
	If !Pergunte(cPerg,.T.)    		// Solicita parametros
		Return
	EndIf
	
	WnRel:=SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,'',.T.,'',.F.)
	
	SetDefault(aReturn,cString)
	
	RptStatus({|lEnd| U_TestRel(@lEnd,wnRel,cString,Tamanho,NomeProg)},titulo)
	
Return


*-----------------------------------------------------------*
User Function TestRel(lEnd,WnRel,cString,Tamanho,NomeProg)
	*-----------------------------------------------------------*
	LOCAL cabec1 	:=  ""
	LOCAL cabec2 	:=  ""
	LOCAL cRodaTxt 	:= oemtoansi("Rodapé")
	Local nCntImpr
	Local nTipo
	Local nEspVal  	:=0
	Local nEsprepl 	:=0
	Local lRet		:= .T.
	Local cAdados	:=''
	Local cAdados2	:=''
	Local cAdados3	:=''
	Local cPictQuant:="@E 9,999,999"// PesqPict('SD2','D2_TOTAL',12)
	Local cPictval  :="@E 999.9"
	Local cPQuant 	:="@E 9999"
	//Local cPictqtd 	:="@E 999.9"
	Local cPictval3 :="@E 999.99"
	Local cPict3Quant:="@E 9,999,999.99"
	Local nDados2  	:=0
	Local nDados1  	:=0
	Local i:=1
	Local j:=1
	Local l:=1
	nCntImpr := 0
	li := 80
	m_pag := 1
	nTipo := 15
	titulo:= oemtoansi("Relatorio de Captação Mensal por Grupo de Produtos")
	nEspVal  :=nEsp-8
	nEsprepl :=nEsp+2
	
	lRet:=QuerySd2()//Executa a Query
	
	If lRet
		
		
		
		
		
		For i:=1 To Len(aDados)
			aDados2    :={}
			For j:=1 To 13
				
				
				If j < 13
					cAdados:=cAdados+"|"+Transform(aDados[i,j], cPictQuant) +" "+Transform(aDados[i,j+14], cPQuant)
					aadd(aDados2,{aDados[i,j],aDados[i,j+14]})
				Else
					nDados1:=((aDados[i,1]+aDados[i,2]+aDados[i,3]+aDados[i,4]+aDados[i,5]+aDados[i,6] ;
						+aDados[i,7]+aDados[i,8]+aDados[i,9]+aDados[i,10]+aDados[i,11]+aDados[i,12])/ ;
						(aDados[i,15]+aDados[i,16]+aDados[i,17]+aDados[i,18]+aDados[i,19]+aDados[i,20] ;
						+aDados[i,21]+aDados[i,22]+aDados[i,23]+aDados[i,24]+aDados[i,25]+aDados[i,26]))
					
					cAdados:=cAdados+"|"+Transform(nDados1, cPict3Quant) +"  "
					aadd(aDados2,{nDados1})
				EndIf
				
				
				
				
			next j
			
			
			For l:=1 To 13
				If i < Len(aDados)
					if  aDados[i+1,14] =  MV_PAR01
						If l < 13
							
							cAdados2:=cAdados2+"|"+Transform(aDados[i+1,l], cPictQuant) +" "+Transform(aDados[i+1,l+14], cPQuant)
							
							nValAl:=((aDados[i+1,l]*100)/aDados2[l,1])-100
							nValQtd :=((aDados[i+1,l+14]*100)/aDados2[l,2])-100
							If aDados[i+1,l] = 0 .Or. aDados2[l,1] = 0 .Or.aDados[i+1,l+14] = 0 .Or. aDados2[l,2] = 0
								cAdados3:=cAdados3+ "|"+replicate(" ",nEsprepl)
							Else
								cAdados3:=cAdados3+"| "+Transform(nValAl, cPictval) +"% "+Transform(nValQtd, cPictval)+"%"
							Endif
							
						Else
							nDados2  :=((aDados[i+1,1]+aDados[i+1,2]+aDados[i+1,3]+aDados[i+1,4]+aDados[i+1,5]+aDados[i+1,6] ;
								+aDados[i+1,7]+aDados[i+1,8]+aDados[i+1,9]+aDados[i+1,10]+aDados[i+1,11]+aDados[i+1,12])/;
								(aDados[i+1,15]+aDados[i+1,16]+aDados[i+1,17]+aDados[i+1,18]+aDados[i+1,19]+aDados[i+1,20] ;
								+aDados[i+1,21]+aDados[i+1,22]+aDados[i+1,23]+aDados[i+1,24]+aDados[i+1,25]+aDados[i+1,26]) )
							
							cAdados2:=cAdados2+"|"+Transform(nDados2, cPict3Quant) +"  "
							
							nValAl:=((nDados2*100)/aDados2[l,1])-100
							
							
							cAdados3:=cAdados3+"|    "+Transform(nValAl, cPictval3) +"%   "
							
							
						Endif
						
					Else
						cAdados2:=cAdados2+ "|      00,0"+replicate(" ",nEsprepl-12)+"0 "
						cAdados3:=cAdados3+ "|"+replicate(" ",nEsprepl)
					Endif
					
					
					
				Endif
				
				
				
			next l
			
			cAdados:=cAdados+"|"
			cAdados2:=cAdados2+"|"
			cAdados3:=cAdados3+"|"
			If Li > 60
				
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
				//	@ Li,0 PSAY __PrtThiLie()
				
				@Li,000 PSAY    " __________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________"
				li++
				@Li,000 PSAY    "| Codigo |      |"+replicate(replicate(" ",nEsprepl)+"|",13)
				li++
				@Li,000 PSAY    "| Descri.|      | "+_aMeses[1]+" | "+_aMeses[2]+" | "+_aMeses[3]+" | "+_aMeses[4]+" | "+_aMeses[5]+" | "+_aMeses[6]+" | "+_aMeses[7]+" | "+_aMeses[8]+" | "+_aMeses[9]+" | "+_aMeses[10]+" | "+_aMeses[11]+" | "+_aMeses[12]+" | "+_aMeses[13]+" |"
				li++
				@Li,000 PSAY    "|________|______|"+replicate(replicate("_",nEsprepl)+"|",13)
				li++
			Endif
			
			
			If  aDados[i,14] =  CVALTOCHAR(VAL(MV_PAR01)-1)
				
				@Li,000 PSAY   "|        |      |"+replicate(" Valor"+replicate(" ",nEspVal)+"QTD |",12) +"     Valor"+replicate(" ",nEspVal) +"|"
				li++
				@Li,000 PSAY   "|  "+	ALLTRIM(aDados[i,13] )+"   | "+CVALTOCHAR(VAL(MV_PAR01)-1)+" "+cAdados
				li++
				@Li,000 PSAY   "| "+SUBSTR(	Posicione("SBM",1,XFILIAL("SBM")+aDados[i,13],"BM_DESC") ,1,06)+" | "+MV_PAR01+" "+cAdados2
				li++
				@Li,000 PSAY   "| "+SUBSTR(	Posicione("SBM",1,XFILIAL("SBM")+aDados[i,13],"BM_DESC") ,7,06)+" | A.H  "+cAdados3//replicate(replicate(" ",nEsprepl)+"|",12)
				li++
				@Li,000 PSAY   "|________|______|"+replicate(replicate("_",nEsprepl)+"|",13)
				li++
			Endif
			cAdados:=''
			cAdados2:=''
			cAdados3:=''
		next i
		
		
		//Totais
		
		StTotais(lEnd,WnRel,cString,Tamanho,NomeProg,nEsprepl,nEspVal)
		
		Set Device to Screen
		If aReturn[5] = 1
			Set Printer To
			dbCommitAll()
			OurSpool(wnrel)
		Endif
		MS_FLUSH()
	EndIf
Return

*---------------------------------------------------*
Static Function StTotais(lEnd,WnRel,cString,Tamanho,NomeProg,nEsprepl,nEspVal)
	*---------------------------------------------------*
	LOCAL cabec1 :=  ""
	LOCAL cabec2 :=  ""
	Local nAnoAnt :=   0
	Local nAnoAtu :=   0
	Local nProdAnt :=   0
	Local nProdAtu :=   0
	Local cAdados4 := ''
	Local cAdados5 := ''
	Local cAdados6 := ''
	Local nValAl1 :=   0
	Local nValQtd1:=   0
	Local g:=   0
	Local n:=   0
	Local cPictQuant :="@E 9,999,999"// PesqPict('SD2','D2_TOTAL',12)
	Local cPictval   :="@E 999.9"
	Local cPictval3   :="@E 999.99"
	Local cPQuant :="@E 9999"
	//Local cPictqtd :="@E 999.9"
	For n:=1 To 12
		For g:=1 To Len(aDados)
			
			If 	aDados[g,14] =  CVALTOCHAR(VAL(MV_PAR01)-1)
				nAnoAnt:=nAnoAnt +aDados[g,n]
				nProdAnt:=nProdAnt +aDados[g,n+14]
			Else
				nAnoAtu:=nAnoAtu +aDados[g,n]
				nProdAtu:=nProdAtu +aDados[g,n+14]
			Endif
			
		next g
		
		
		
		cAdados4:=cAdados4+"|"+Transform(nAnoAnt, cPictQuant) +" "+Transform(nProdAnt, cPQuant)
		cAdados5:=cAdados5+"|"+Transform(nAnoAtu, cPictQuant) +" "+Transform(nProdAtu, cPQuant)
		
		nValAl1:=((nAnoAtu*100)/nAnoAnt)-100
		nValQtd1 :=((nProdAtu*100)/nProdAnt)-100
		If nAnoAnt = 0 .Or. nProdAnt = 0 .Or.nAnoAtu = 0 .Or. nProdAtu = 0
			cAdados6:=cAdados6+ "|"+replicate(" ",nEsprepl)
		Else
			cAdados6:=cAdados6+ "| "+Transform(nValAl1, cPictval) +"% "+Transform(nValQtd1, cPictval)+"%"
		Endif
		nValAl1 :=0
		nValQtd1:=0
		nAnoAtu :=0
		nAnoAnt :=0
		nProdAtu :=0
		nProdAnt:=0
	next n
	cAdados4:=cAdados4+"|"
	cAdados5:=cAdados5+"|"
	cAdados6:=cAdados6+"|"
	If Li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	Endif
	li++
	@Li,000 PSAY   replicate(" ",100)+"TOTAL"
	
	li++
	@Li,000 PSAY    " __________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________"
	li++
	@Li,000 PSAY    "|        |      |"+replicate(replicate(" ",nEsprepl)+"|",13)
	li++
	@Li,000 PSAY    "|        |      | "+_aMeses[1]+" | "+_aMeses[2]+" | "+_aMeses[3]+" | "+_aMeses[4]+" | "+_aMeses[5]+" | "+_aMeses[6]+" | "+_aMeses[7]+" | "+_aMeses[8]+" | "+_aMeses[9]+" | "+_aMeses[10]+" | "+_aMeses[11]+" | "+_aMeses[12]+" | "+_aMeses[13]+" |"
	li++
	@Li,000 PSAY    "|________|______|"+replicate(replicate("_",nEsprepl)+"|",13)
	li++
	
	@Li,000 PSAY   "|        |      |"+replicate(" Valor"+replicate(" ",nEspVal)+"QTD |",12)+"     Valor"+replicate(" ",nEspVal) +"|"
	li++
	@Li,000 PSAY   "|        | "+CVALTOCHAR(VAL(MV_PAR01)-1)+" "+cAdados4
	li++
	@Li,000 PSAY   "|        | "+MV_PAR01+" "+cAdados5
	li++
	@Li,000 PSAY   "|        | A.H  "+cAdados6
	li++
	@Li,000 PSAY   "|________|______|"+replicate(replicate("_",nEsprepl)+"|",13)
	li++
	
	
	
	
Return()


*---------------------------------------------------*
Static Function QuerySd2()
	*---------------------------------------------------*
	
	Local aArea    	:= GetArea()
	Local lRetBlo  	:= .F.
	Local cQuery    := ''
	Local nPosProd  :=0
	
	
	cAliasLif := "TMP1"
	cQuery := " SELECT
	cQuery += " ROUND(SUM(NVL(TOTAL1,0)*NVL(SF2.F2_XPERCE1,0)/100)+SUM(NVL(TOTAL3,0)*NVL(SF2.F2_XPERCE3,0)/100)+SUM((NVL(TOTAL4,0)*NVL(SF2.F2_XPERCE4,0))/100)+SUM((NVL(TOTAL5,0)*NVL(SF2.F2_XPERCE5,0))/100),2) AS TOTAL
	cQuery += " ,ROUND(SUM(NVL(QTD1,0)*NVL(SF2.F2_XPERCE1,0)/100)  +SUM(NVL(QTD3,0)*NVL(SF2.F2_XPERCE3,0)/100)+SUM((NVL(QTD4,0)*NVL(SF2.F2_XPERCE4,0))/100)+SUM((NVL(QTD5,0)*NVL(SF2.F2_XPERCE5,0))/100),2) AS QTD
	cQuery += " ,TBM.BM_GRUPO   AS GRUPO
	cQuery += " ,EMISSA1 AS EMISSAO
	//cQuery += " ,TBM.BM_DESC  AS  DESCR
	
	cQuery += "  FROM "+RetSqlName('SF2')+" SF2 "
	
	cQuery += " LEFT JOIN(SELECT SUM(TD1.D2_TOTAL) AS TOTAL1 ,SUM(TD1.D2_QUANT) AS QTD1 ,TD1.D2_SERIE,TD1.D2_DOC,TD1.D2_GRUPO AS  GRUD1,SUBSTRING(TD1.D2_EMISSAO,1,6) AS EMISSA1
	cQuery += " FROM "+RetSqlName('SD2')+" TD1 "
	cQuery += " WHERE TD1.D_E_L_E_T_ = ' '
	cQuery += " AND TD1.D2_FILIAL ='"+xFilial('SD2')+"'"
	cQuery += " AND TD1.D2_TP = 'PA'
	cQuery += " GROUP BY TD1.D2_DOC,TD1.D2_SERIE,TD1.D2_GRUPO,SUBSTRING(TD1.D2_EMISSAO,1,6))DD1
	cQuery += " ON  DD1.D2_DOC = SF2.F2_DOC
	cQuery += " AND DD1.D2_SERIE = SF2.F2_SERIE
	cQuery += " AND DD1.GRUD1 BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'
	
	cQuery += " AND SF2.F2_XPERCE1 > 0
	cQuery += " AND SF2.F2_VEND1 = (SELECT A3_COD FROM "+RetSqlName('SA3')+" SA3 "
	cQuery += " WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += " AND SA3.A3_FILIAL = '"+xFilial('SA3')+"'"
	cQuery += " AND SA3.A3_COD = SF2.F2_VEND1
	cQuery += " AND SA3.A3_SUPER BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'
	cQuery += " AND SA3.A3_GEREN BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"')
	
	cQuery += " LEFT JOIN(SELECT SUM(TD3.D2_TOTAL)AS TOTAL3,SUM(TD3.D2_QUANT) AS QTD3,TD3.D2_SERIE,TD3.D2_DOC,TD3.D2_GRUPO  AS  GRUD3 ,SUBSTRING(TD3.D2_EMISSAO,1,6)  AS EMISSA3
	cQuery += " FROM "+RetSqlName('SD2')+" TD3 "
	cQuery += " WHERE TD3.D_E_L_E_T_ = ' '
	cQuery += " AND TD3.D2_FILIAL = '"+xFilial('SD2')+"'"
	cQuery += " AND TD3.D2_TP = 'PA'
	cQuery += " GROUP BY TD3.D2_DOC,TD3.D2_SERIE,TD3.D2_GRUPO,SUBSTRING(TD3.D2_EMISSAO,1,6))DD3
	cQuery += " ON  DD3.D2_DOC = SF2.F2_DOC
	cQuery += " AND DD3.D2_SERIE = SF2.F2_SERIE
	cQuery += " AND DD3.GRUD3 BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'
	
	cQuery += " AND SF2.F2_XPERCE3 > 0
	cQuery += " AND SF2.F2_VEND3 = (SELECT A3_COD FROM "+RetSqlName('SA3')+" EA3 "
	cQuery += " WHERE EA3.D_E_L_E_T_ = ' '
	cQuery += " AND EA3.A3_FILIAL = '"+xFilial('SA3')+"'"
	cQuery += " AND EA3.A3_COD = SF2.F2_VEND3
	cQuery += " AND EA3.A3_SUPER BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'
	cQuery += " AND EA3.A3_GEREN BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"')
	
	cQuery += " LEFT JOIN(SELECT SUM(TD4.D2_TOTAL)AS TOTAL4,SUM(TD4.D2_QUANT) AS QTD4,TD4.D2_SERIE,TD4.D2_DOC,TD4.D2_GRUPO AS GRUD4,SUBSTRING(TD4.D2_EMISSAO,1,6) AS EMISSA4
	cQuery += " FROM "+RetSqlName('SD2')+" TD4 "
	cQuery += " WHERE TD4.D_E_L_E_T_ = ' '
	cQuery += " AND TD4.D2_FILIAL ='"+xFilial('SD2')+"'"
	cQuery += " AND TD4.D2_TP = 'PA'
	cQuery += " GROUP BY TD4.D2_DOC,TD4.D2_SERIE,TD4.D2_GRUPO,SUBSTRING(TD4.D2_EMISSAO,1,6))DD4
	cQuery += " ON  DD4.D2_DOC = SF2.F2_DOC
	cQuery += " AND DD4.D2_SERIE = SF2.F2_SERIE
	cQuery += " AND DD4.GRUD4  BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'
	
	cQuery += " AND SF2.F2_XPERCE4 > 0
	cQuery += " AND SF2.F2_VEND4 = (SELECT A3_COD FROM "+RetSqlName('SA3')+" DA3 "
	cQuery += " WHERE DA3.D_E_L_E_T_ = ' '
	cQuery += " AND DA3.A3_FILIAL = '"+xFilial('SA3')+"'"
	cQuery += " AND DA3.A3_COD = SF2.F2_VEND4
	cQuery += " AND DA3.A3_SUPER BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'
	cQuery += " AND DA3.A3_GEREN BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"')
	
	cQuery += " LEFT JOIN(SELECT SUM(TD5.D2_TOTAL)AS TOTAL5,SUM(TD5.D2_QUANT) AS QTD5,TD5.D2_SERIE,TD5.D2_DOC,TD5.D2_GRUPO AS GRUD5,SUBSTRING(TD5.D2_EMISSAO,1,6) AS EMISSA5
	cQuery += " FROM "+RetSqlName('SD2')+" TD5 "
	cQuery += " WHERE TD5.D_E_L_E_T_ = ' '
	cQuery += " AND TD5.D2_FILIAL ='"+xFilial('SD2')+"'"
	cQuery += " AND TD5.D2_TP = 'PA'
	cQuery += " GROUP BY TD5.D2_DOC,TD5.D2_SERIE,TD5.D2_GRUPO,SUBSTRING(TD5.D2_EMISSAO,1,6))DD5
	cQuery += " ON  DD5.D2_DOC = SF2.F2_DOC
	cQuery += " AND DD5.D2_SERIE   = SF2.F2_SERIE
	cQuery += " AND DD5.GRUD5 BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'
	cQuery += " AND SF2.F2_XPERCE5 > 0
	cQuery += " AND SF2.F2_VEND5 = (SELECT A3_COD FROM "+RetSqlName('SA3')+" CA3 "
	cQuery += " WHERE CA3.D_E_L_E_T_ = ' '
	cQuery += " AND CA3.A3_FILIAL = '"+xFilial('SA3')+"'"
	cQuery += " AND CA3.A3_COD = SF2.F2_VEND5
	cQuery += " AND CA3.A3_SUPER BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'
	cQuery += " AND CA3.A3_GEREN BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"')
	
	
	cQuery += " INNER JOIN ( SELECT BM_GRUPO,BM_FILIAL,BM_DESC FROM "+RetSqlName('SBM')+" SBM "
	cQuery += " WHERE SBM.D_E_L_E_T_ = ' '
	cQuery += " AND SBM.BM_FILIAL = '"+xFilial('SBM')+"')TBM
	cQuery += " ON (TBM.BM_GRUPO = GRUD1
	cQuery += " OR TBM.BM_GRUPO = GRUD3
	cQuery += " OR TBM.BM_GRUPO = GRUD4
	cQuery += " OR TBM.BM_GRUPO = GRUD5)
	
	
	cQuery += " WHERE SF2.D_E_L_E_T_ = ' '
	cQuery += " AND SF2.F2_EMISSAO BETWEEN '"+cvaltochar(val(MV_PAR01)-1)+"0101' AND '"+MV_PAR01+"1231'
	cQuery += " AND (SF2.F2_VEND1 BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"'
	cQuery += " OR SF2.F2_VEND3 BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"'
	cQuery += " OR SF2.F2_VEND4 BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"'
	cQuery += " OR SF2.F2_VEND5 BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"')
	cQuery += " AND SF2.F2_FILIAL = '"+xFilial('SF2')+"'"
	cQuery += " AND SF2.F2_CLIENTE = (SELECT A1_COD FROM "+RetSqlName('SA1')+" SA1 "
	cQuery += " WHERE SA1.A1_COD = SF2.F2_CLIENTE
	cQuery += " AND SA1.A1_LOJA = SF2.F2_LOJA
	cQuery += " AND SA1.A1_FILIAL = '"+xFilial('SA1')+"'"
	cQuery += " AND SA1.D_E_L_E_T_ = ' '
	cQuery += " AND SUBSTRING(RTRIM(LTRIM(SA1.A1_GRPVEN)),1,2) <> 'ST'
	cQuery += " AND SA1.A1_EST <> 'EX')
	cQuery += " AND (SF2.F2_VEND1 <> ' ' OR SF2.F2_VEND3 <> ' ' OR SF2.F2_VEND4 <> ' ' OR SF2.F2_VEND5 <> ' ' )
	
	
	cQuery += " GROUP BY TBM.BM_GRUPO,EMISSA1
	cQuery += " ORDER BY TBM.BM_GRUPO,EMISSA1
	
	cQuery := ChangeQuery(cQuery)
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasLif)
	
	
	If  Select(cAliasLif) > 0
		lRetBlo:= .T.
	EndIf
	
	
	If !(lRetBlo)
		msginfo(" Não Encontrado Dados, Verifique os Paramêtros  !!!!!!!!")
	Else
		dbSelectArea(cAliasLif)
		(cAliasLif)->(dbgotop())
		Do While (cAliasLif)->(!Eof())
			
			
			nPosProd:= Ascan(aDados,{|x| x[13] +  x[14] == (cAliasLif)->GRUPO+Substr((cAliasLif)->EMISSAO,1,4)   })
			If nPosProd == 0
				AADD(aDados,{0,0,0,0,0,0,0,0,0,0,0,0,(cAliasLif)->GRUPO,Substr((cAliasLif)->EMISSAO,1,4),0,0,0,0,0,0,0,0,0,0,0,0} )
				nPosProd:=LEN(ADADOS)
			Endif
			
			aDados[nPosProd][val(substr((cAliasLif)->EMISSAO,5,2))]+=  (cAliasLif)->TOTAL
			aDados[nPosProd][val(substr((cAliasLif)->EMISSAO,5,2))+14]+=  (cAliasLif)->QTD
			
			(cAliasLif)->(dbSkip())
		EndDo
		(cAliasLif)->(dbCloseArea())
		
		
	EndIf
	
	
	
	RestArea( aArea )
	
Return(lRetBlo)

*---------------------------------------------------*
Static Function ajustaSX1(cPerg)
	*---------------------------------------------------*
	Local _sAlias := GetArea()
	Local _aTamSX3:= {}
	Local j:=   0
	Local i:=   0
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	
	cPerg := PADR(cPerg, Len(SX1->X1_GRUPO)," " )
	
	aRegs:={}
	
	//------------ Grupo/Ordem/Pergunta/PERGING/PERGESP/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3
	
	AADD(aRegs,{cPerg,"01","Ano de Referência :  ","","","mv_ch1","C",4			 ,0,0,"G","","MV_PAR01","","","","","","","","","","","","","",""})
	_aTamSX3 := TamSX3("BM_GRUPO")
	AADD(aRegs,{cPerg,"02","Grupo de :  ","","","mv_ch2","C",_aTamSX3[1]	 ,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",'SBM'})
	_aTamSX3 := TamSX3("BM_GRUPO")
	AADD(aRegs,{cPerg,"03","Grupo até:  ","","","mv_ch3","C",_aTamSX3[1]	  ,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",'SBM'})
	_aTamSX3 := TamSX3("A3_COD")
	AADD(aRegs,{cPerg,"04","Gerente de  	  :  ","","","mv_ch4","C",_aTamSX3[1],0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",'SA3GER'})
	AADD(aRegs,{cPerg,"05","Gerenta Até	 	  :  ","","","mv_ch5","C",_aTamSX3[1],0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",'SA3GER'})
	_aTamSX3 := TamSX3("A3_COD")
	AADD(aRegs,{cPerg,"06","Supervisor de  	  :  ","","","mv_ch6","C",_aTamSX3[1],0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",'SA3SUP'})
	AADD(aRegs,{cPerg,"07","Supervisor Até	  :  ","","","mv_ch7","C",_aTamSX3[1],0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","",'SA3SUP'})
	_aTamSX3 := TamSX3("A3_COD")
	AADD(aRegs,{cPerg,"08","Vendedor de  	  :  ","","","mv_ch8","C",_aTamSX3[1],0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","",'SA3'})
	AADD(aRegs,{cPerg,"09","Vendedor Até	  :  ","","","mv_ch9","C",_aTamSX3[1],0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","",'SA3'})
	
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	
	dbSelectArea(_sAlias)
	
Return

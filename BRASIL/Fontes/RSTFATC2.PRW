#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFATC2        | Autor | RENATO.OLIVEIRA           | Data | 29/10/2018  |
|=====================================================================================|
|Descri็ใo | RELATORIO MARGEM CONSIGNADO                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
|Chamado 006473 																	  |
\====================================================================================*/

User Function RSTFATC2()

	Local   oReport
	Private cPerg 			:= "RFATC2"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	xPutSx1(cPerg, "01", "Situa็๕es ?"	,"Situa็๕es ?" 		,"Situa็๕es ?" 		,"mv_ch1","C",5,0,0,"G","fSituacao()",'',"","","mv_par01","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "02", "Data de:" 	,"Data de: ?" 		,"Data de: ?" 		,"mv_ch2","D",8,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "03", "Data ate:" 	,"Data ate: ?" 		,"Data ate: ?" 		,"mv_ch3","D",8,0,0,"G","",''    ,"","","mv_par03","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "04", "Func. de:" 	,"Func. de: ?" 		,"Func. de: ?" 		,"mv_ch4","C",6,0,0,"G","",'SRA' ,"","","mv_par04","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "05", "Func. ate:"	,"Func. ate: ?" 	,"Func. ate: ?" 	,"mv_ch5","C",6,0,0,"G","",'SRA' ,"","","mv_par05","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "06", "Filial. de:" 	,"Filial. de: ?" 	,"Filial. de: ?" 	,"mv_ch6","C",2,0,0,"G","",'' 	 ,"","","mv_par06","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "07", "Filial. ate:"	,"Filial. ate: ?" 	,"Filial. ate: ?" 	,"mv_ch7","C",2,0,0,"G","",'' 	 ,"","","mv_par07","","","","","","","","","","","","","","","","")	

	oReport:=ReportDef()
	oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณ				     บ Data ณ  	          บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  								                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"Relat๓rio de margem consignado",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de margem consignado")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Relat๓rio de margem consignado",{"SRA"})

	TRCell():New(oSection,"FILIAL"	  			 ,,"FILIAL"		,,TamSx3("RA_FILIAL")[1],.F.,)
	TRCell():New(oSection,"CODIGO"  			 ,,"CODIGO"		,,TamSx3("RA_MAT")[1],.F.,)
	TRCell():New(oSection,"NOME"  			 	 ,,"NOME"		,,TamSx3("RA_NOME")[1],.F.,)
	TRCell():New(oSection,"CODDEP" 			 	 ,,"COD. DEPTO"	,,TamSx3("CTT_CUSTO")[1],.F.,)
	TRCell():New(oSection,"DEPTO"  			 	 ,,"DEPTO"		,,TamSx3("CTT_DESC01")[1],.F.,)
	TRCell():New(oSection,"DTADM"  			 	 ,,"DATA ADMIS.",,TamSx3("RA_ADMISSA")[1],.F.,)
	TRCell():New(oSection,"CPF"  			 	 ,,"CPF"		,,TamSx3("RA_CIC")[1],.F.,)
	TRCell():New(oSection,"SITFOL" 			 	 ,,"SIT. FOLHA" ,,TamSx3("RA_SITFOLH")[1],.F.,)
	TRCell():New(oSection,"CODFUN" 			 	 ,,"COD. FUNCAO",,TamSx3("RA_CODFUNC")[1],.F.,)
	TRCell():New(oSection,"DESFUN" 			 	 ,,"DES. FUNCAO",,TamSx3("RJ_DESC")[1],.F.,)
	TRCell():New(oSection,"SALARIO"			 	 ,,"SALARIO"    ,,TamSx3("RA_SALARIO")[1],.F.,)
	TRCell():New(oSection,"MESES"		 	 	 ,,"QTDE MESES"	,"@E 99",2,.F.,)
	TRCell():New(oSection,"MEDPAG"		 	 	 ,,"MEDIA PAGTO","@R 999,999,999.99",TamSx3("RD_VALOR")[1],.F.,)
	TRCell():New(oSection,"30PPAG"		 	 	 ,,"30% PAGTO"	,"@R 999,999,999.99",TamSx3("RD_VALOR")[1],.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SRD")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportPrinบAutor  ณ				     บ Data ณ  	          บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  								                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportPrint(oReport)

	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados1[99]
	Local _cSta 	:= ''
	Local _aArea	:= {}

	oSection1:Cell("FILIAL")    			:SetBlock( { || aDados1[01] } )
	oSection1:Cell("CODIGO")  				:SetBlock( { || aDados1[02] } )
	oSection1:Cell("NOME")  				:SetBlock( { || aDados1[03] } )
	oSection1:Cell("DEPTO")  				:SetBlock( { || aDados1[04] } )
	oSection1:Cell("MESES")  				:SetBlock( { || aDados1[05] } )
	oSection1:Cell("MEDPAG")  				:SetBlock( { || aDados1[06] } )
	oSection1:Cell("30PPAG")  				:SetBlock( { || aDados1[07] } )

	oSection1:Cell("CODDEP")  				:SetBlock( { || aDados1[08] } )
	oSection1:Cell("DTADM")  				:SetBlock( { || aDados1[09] } )
	oSection1:Cell("CPF")  					:SetBlock( { || aDados1[10] } )
	oSection1:Cell("SITFOL")  				:SetBlock( { || aDados1[11] } )
	oSection1:Cell("CODFUN")  				:SetBlock( { || aDados1[12] } )
	oSection1:Cell("DESFUN")  				:SetBlock( { || aDados1[13] } )
	oSection1:Cell("SALARIO")  				:SetBlock( { || aDados1[14] } )

	oReport:SetTitle("Relat๓rio m้dia salarial")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	oSection1:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))

	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:=	(cAliasLif)->RD_FILIAL
			aDados1[02]	:= 	(cAliasLif)->RD_MAT
			aDados1[03]	:=  (cAliasLif)->RA_NOME
			aDados1[04]	:= 	(cAliasLif)->CTT_DESC01
			aDados1[05]	:=  (cAliasLif)->QTD
			aDados1[06]	:=	(cAliasLif)->MEDIA
			aDados1[07]	:=	(cAliasLif)->MED30P

			aDados1[08]	:=	(cAliasLif)->CTT_CUSTO
			aDados1[09]	:=	DTOC(STOD((cAliasLif)->RA_ADMISSA))
			aDados1[10]	:=	(cAliasLif)->RA_CIC
			aDados1[11]	:=	(cAliasLif)->RA_SITFOLH
			aDados1[12]	:=	(cAliasLif)->RA_CODFUNC
			aDados1[13]	:=	(cAliasLif)->RJ_DESC

			nSalario	:= 0
			nSalMes		:= 0
			nSalDia		:= 0
			nSalHora	:= 0

			_aArea := GetArea()

			If SRA->(DbSeek((cAliasLif)->(RD_FILIAL+RD_MAT)))

				fSalInc(@nSalario,@nSalMes,@nSalHora,@nSalDia,.T.)

				aDados1[14]	:= nSalario

			Else
				aDados1[14]	:= 0
			EndIf

			RestArea(_aArea)

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())

		End

	EndIf

	oReport:SkipLine()

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณStQuery	บAutor  ณ				     บ Data ณ  	          บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  								                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function StQuery()

	Local cQuery     := ' '
	Local cSituacao  := mv_par01
	Local nReg

	cQuery := " SELECT RD_FILIAL, RD_MAT, MEDIA, MEDIA*30/100 MED30P, RA_NOME, CTT_DESC01, QTD
	cQuery += " ,CTT_CUSTO ,RA_ADMISSA, RA_CIC, RA_SITFOLH, RA_CODFUNC, RJ_DESC, RA_SALARIO
	cQuery += " FROM (
	cQuery += " SELECT RD_FILIAL, RD_MAT, ROUND(AVG(VALOR),2) MEDIA, SUM(QTD) QTD
	cQuery += " FROM (
	cQuery += " SELECT RD_FILIAL, RD_MAT, RD_MES, SUM(RD_VALOR) VALOR, 1 QTD
	cQuery += " FROM "+RetSqlName("SRD")+" RD
	cQuery += " LEFT JOIN "+RetSqlName("SRA")+" RA
	cQuery += " ON RA_FILIAL=RD_FILIAL AND RA_MAT=RD_MAT
	cQuery += " WHERE RD.D_E_L_E_T_=' ' AND RA.D_E_L_E_T_=' ' 
	cQuery += " AND RD_DATPGT BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"'
	cQuery += " AND RD_MAT BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'
	cQuery += " AND RD_FILIAL BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'

	cSitQuery := ""
	For nReg := 1 to Len(cSituacao)
		cSitQuery += "'"+Subs(cSituacao,nReg,1)+"'"
		If ( nReg+1 ) <= Len(cSituacao)
			cSitQuery += "," 
		Endif
	Next nReg        
	cSitQuery := cSitQuery

	cQuery += "  AND RA_SITFOLH	IN	("+cSitQuery+")

	cQuery += " AND RD_PD IN ('999','170')
	cQuery += " GROUP BY RD_FILIAL, RD_MAT, RD_MES
	cQuery += " ORDER BY RD_MES
	cQuery += " ) XXX
	cQuery += " GROUP BY RD_FILIAL, RD_MAT
	cQuery += " ) YYY
	cQuery += " LEFT JOIN "+RetSqlName("SRA")+" RA
	cQuery += " ON RA_FILIAL=RD_FILIAL AND RA_MAT=RD_MAT
	cQuery += " LEFT JOIN "+RetSqlName("CTT")+" CTT
	cQuery += " ON RA_CC=CTT_CUSTO
	cQuery += " LEFT JOIN "+RetSqlName("SRJ")+" RJ
	cQuery += " ON RJ_FUNCAO=RA_CODFUNC
	cQuery += " WHERE RA.D_E_L_E_T_=' ' AND CTT.D_E_L_E_T_=' ' AND RJ.D_E_L_E_T_=' '
	cQuery += " ORDER BY RD_FILIAL, RD_MAT
	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para valida็ใo dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
/* Removido - 12/05/2023 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf*/
	Endif

	RestArea( aArea )

Return

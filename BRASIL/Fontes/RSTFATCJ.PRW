#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*/{Protheus.doc} RSTFATCJ.PRW
(Relatório de Horas Abonadas)

@author jefferson.carlos
@since 22/07/2019
@version 1.0
@return ${return}, ${return_description}

/*/

User Function RSTFATCJ()

	Local   oReport
	Private cPerg		:= "RFATCJ"
	Private cTime		:= Time()
	Private cHora		:= SUBSTR(cTime, 1, 2)
	Private cMinutos	:= SUBSTR(cTime, 4, 2)
	Private cSegundos	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif	:= cPerg+cHora+cMinutos+cSegundos
	Private cPergTit	:= cAliasLif

	xPutSx1(cPerg, "01", "Data da Demissao de?"		,"Data da Demissao de?" 	,"Data da Demissao de?" 	,"MV_CH1","D",8,0,0,"G","",'' 			,"","","MV_PAR01","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "02", "Data da Demissao ate?"	,"Data da Demissao ate?" 	,"Data da Demissao ate?" 	,"MV_CH2","D",8,0,0,"G","",'' 			,"","","MV_PAR02","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "03", "Admissão Até?"			,"Admissão Até?" 			,"Admissão Até?"		 	,"MV_CH3","D",8,0,0,"G","",'' 			,"","","MV_PAR03","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "04", "Percentual Premio?"		,"Percentual Premio??" 		,"Percentual Premio?"	 	,"MV_CH4","N",17,8,0,"G","",'' 			,"","","MV_PAR04","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "05", "Capital Mínimo?"			,"Capital Mínimo?" 			,"Capital Mínimo?"		 	,"MV_CH5","N",17,2,0,"G","",'' 			,"","","MV_PAR05","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "06", "Capital Máximo?"			,"Capital Máximo?" 			,"Capital Máximo?"		 	,"MV_CH6","N",17,2,0,"G","",'' 			,"","","MV_PAR06","","","","","","","","","","","","","","","","")


	oReport	:= ReportDef()
	oReport:PrintDialog()

Return


/*/{Protheus.doc} RSTFATCJ
(Relatório seguro de vida)

@author jefferson.carlos
@since 22/07/2019
@version 1.0

/*/

Static Function ReportDef()

	Local oReport
	Local oSection1
	Local oSection2

	oReport		:= TReport():New(cPergTit,"Relatório Seguro de Vida",cPerg ,{|oReport| ReportPrint(oReport)},"Impressão funcionários seguro de vida ")

//Pergunte(cPerg,.F.)

	oSection1	:= TRSection():New(oReport,"Relatório Seguro de Vida",{"MOV"})

	TRCell():New(oSection1,"01",,"FILIAL"		,,TamSx3("RA_FILIAL")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"02",,"MATRICULA"	,,TamSx3("RA_MAT")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"03",,"NOME"			,,TamSx3("RA_NOME")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"04",,"C.CUSTO"		,,TamSx3("CTT_DESC01")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"05",,"DATA NASC."	,,TamSx3("RA_NASC")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"06",,"ADMISSAO"		,,TamSx3("RA_ADMISSA")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"07",,"CPF"			,,TamSx3("RA_CIC")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"08",,"DEMISSAO"		,,TamSx3("RA_DEMISSA")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"09",,"SALARIO"		,,TamSx3("RA_SALARIO")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"10",,"CAPITAL"		,,TamSx3("RA_SALARIO")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"11",,"PREMIO"		,,TamSx3("RA_SALARIO")[1]	,.F.,,,,,,,.T.)

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("MOV")

Return oReport


/*/{Protheus.doc} RSTFATCJ
(Relatório seguro de vida)

@author jefferson.carlos
@since 22/07/2019
@version 1.0

/*/

Static Function ReportPrint(oReport)

	Local oSection1	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(2)
	Local nX		:= 0
	Local aDados1[99]
	Local aDados2[99]
	Local _nPremio := 0

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

	oReport:SetTitle("MOV")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	aFill(aDados2,nil)
	oSection1:Init()

	oSection2:Init()

	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	If  Select(cAliasLif) > 0

		While (cAliasLif)->(!Eof())

			aDados1[01]	:=	(cAliasLif)->FILIAL
			aDados1[02]	:=	(cAliasLif)->MATRICULA
			aDados1[03]	:=	(cAliasLif)->NOME
			aDados1[04]	:=	(cAliasLif)->DESC_CCUSTO
			aDados1[05]	:=	DTOC(STOD((cAliasLif)->DATA_NASC))
			aDados1[06]	:=  DTOC(STOD((cAliasLif)->ADMISSAO))//(cAliasLif)->ADMISSAO
			aDados1[07]	:=	(cAliasLif)->CPF
			aDados1[08]	:=	DTOC(STOD((cAliasLif)->DEMISSAO))//(cAliasLif)->DEMISSAO
			aDados1[09]	:=	(cAliasLif)->SALARIO

			If (cAliasLif)->CAPITAL <= MV_PAR05
				_nPremio := ((MV_PAR05 * MV_PAR04 ) / 100 ) 
			ElseIf (cAliasLif)->CAPITAL >= MV_PAR06
				_nPremio := ((MV_PAR06 * MV_PAR04 ) / 100 ) 
			else
				_nPremio := (cAliasLif)->PREMIO
			ENDIF

			aDados1[10]	:=	(cAliasLif)->CAPITAL
			aDados1[11]	:=	_nPremio

			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End

		oSection1:PrintLine()
		aFill(aDados1,nil)

		(cAliasLif)->(dbCloseArea())

	EndIf

	oReport:SkipLine()

Return oReport


/*/{Protheus.doc} RSTFATCJ.PRW
(Gera Consulta no Banco de Dados)

@author jefferson.carlos
@since 07/02/2019
@version 1.0
/*/

Static Function StQuery()

	Local cQuery1	:= ' '

	//>> Funcionarios Ativos	
	cQuery1+= " SELECT
	cQuery1+= " RA_FILIAL AS FILIAL, RA_MAT AS MATRICULA, RA_NOME AS NOME, CTT_DESC01 AS DESC_CCUSTO, RA_NASC AS DATA_NASC, RA_ADMISSA AS ADMISSAO, "
	cQuery1+= " RA_CIC AS CPF, RA_DEMISSA AS DEMISSAO, CASE WHEN RA_CATFUNC = 'H' THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SALARIO, "
	cQuery1+= " CASE WHEN RA_CATFUNC = 'H' THEN (RA_SALARIO * RA_HRSMES)*12 ELSE RA_SALARIO * 12 END AS CAPITAL, "
	cQuery1+= " CASE WHEN RA_CATFUNC = 'H' THEN ((((RA_SALARIO * RA_HRSMES)*12)* "+str(MV_PAR04)+")/100) ELSE (((RA_SALARIO*12)*"+Str(MV_PAR04)+")/100) END AS PREMIO "
	cQuery1+= " FROM " + RetSqlName("SRA") + " RA "
	cQuery1+= " INNER JOIN " + RetSqlName("CTT") + " TT "
	cQuery1+= " ON CTT_CUSTO = RA_CC "
	cQuery1+= " WHERE RA.D_E_L_E_T_ = ' ' "
	cQuery1+= " AND RA_CATFUNC IN ('H','M') "
	cQuery1+= " AND RA.RA_SITFOLH IN (' ','A','F') "
	cQuery1+= " AND RA_ADMISSA <= '" + DTOS(MV_PAR03) + "' "
	cQuery1+= " AND RA_RESCRAI NOT IN ('30','31') "
	//<< Funcionarios Ativos	
	cQuery1+= " UNION "
	//>> Funcionarios Demitidos Fora do Periodo é considerado Ativo
	cQuery1+= " SELECT
	cQuery1+= " RA_FILIAL AS FILIAL, RA_MAT AS MATRICULA, RA_NOME AS NOME, CTT_DESC01 AS DESC_CCUSTO, RA_NASC AS DATA_NASC, RA_ADMISSA AS ADMISSAO, "
	cQuery1+= " RA_CIC AS CPF, ' ' AS DEMISSAO, CASE WHEN RA_CATFUNC = 'H' THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SALARIO, "
	cQuery1+= " CASE WHEN RA_CATFUNC = 'H' THEN (RA_SALARIO * RA_HRSMES)*12 ELSE RA_SALARIO * 12 END AS CAPITAL, "
	cQuery1+= " CASE WHEN RA_CATFUNC = 'H' THEN ((((RA_SALARIO * RA_HRSMES)*12)* "+str(MV_PAR04)+")/100) ELSE (((RA_SALARIO*12)*"+Str(MV_PAR04)+")/100) END AS PREMIO "
	cQuery1+= " FROM " + RetSqlName("SRA") + " RA "
	cQuery1+= " INNER JOIN " + RetSqlName("CTT") + " TT "
	cQuery1+= " ON CTT_CUSTO = RA_CC "
	cQuery1+= " WHERE RA.D_E_L_E_T_ = ' ' "
	cQuery1+= " AND RA_CATFUNC IN ('H','M') "
	cQuery1+= " AND RA_SITFOLH = 'D' "
	cQuery1+= " AND RA_DEMISSA >= '" + DTOS(MV_PAR03) + "' "
	cQuery1+= " AND RA_RESCRAI NOT IN ('30','31') "
	//<< Funcionarios Demitidos Fora do Periodo
	cQuery1+= " UNION "
	//>> Funcionarios Demitidos no Periodo
	cQuery1+= " SELECT
	cQuery1+= " RA_FILIAL AS FILIAL, RA_MAT AS MATRICULA, RA_NOME AS NOME, CTT_DESC01 AS DESC_CCUSTO, RA_NASC AS DATA_NASC, RA_ADMISSA AS ADMISSAO, "
	cQuery1+= " RA_CIC AS CPF, RA_DEMISSA AS DEMISSAO, CASE WHEN RA_CATFUNC = 'H' THEN RA_SALARIO * RA_HRSMES ELSE RA_SALARIO END AS SALARIO, "
	cQuery1+= " CASE WHEN RA_CATFUNC = 'H' THEN (RA_SALARIO * RA_HRSMES)*12 ELSE RA_SALARIO * 12 END AS CAPITAL, "
	cQuery1+= " CASE WHEN RA_CATFUNC = 'H' THEN ((((RA_SALARIO * RA_HRSMES)*12)* "+str(MV_PAR04)+")/100) ELSE (((RA_SALARIO*12)*"+Str(MV_PAR04)+")/100) END AS PREMIO "
	cQuery1+= " FROM " + RetSqlName("SRA") + " RA "
	cQuery1+= " INNER JOIN " + RetSqlName("CTT") + " TT "
	cQuery1+= " ON CTT_CUSTO = RA_CC "
	cQuery1+= " WHERE RA.D_E_L_E_T_ = ' ' "
	cQuery1+= " AND RA_CATFUNC IN ('H','M') "
	cQuery1+= " AND RA_SITFOLH = 'D' "
	cQuery1+= " AND RA_DEMISSA BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
	cQuery1+= " AND RA_RESCRAI NOT IN ('30','31') "
	//<< Funcionarios Demitidos no Periodo

	cQuery1+= " ORDER BY FILIAL, MATRICULA "

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAliasLif)

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

	LOCAL aArea	:= GetArea()
	Local cKey
	Local lPort	:= .f.
	Local lSpa	:= .f.
	Local lIngl	:= .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme	:= Iif( cPyme	== Nil, " ", cPyme)
	cF3		:= Iif( cF3		== NIl, " ", cF3)
	cGrpSxg	:= Iif( cGrpSxg	== Nil, " ", cGrpSxg)
	cCnt01	:= Iif( cCnt01	== Nil, "" , cCnt01)
	cHelp	:= Iif( cHelp	== Nil, "" , cHelp)

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt	:= If(! "?" $ cPergunt	.And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa		:= If(! "?" $ cPerSpa	.And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng		:= If(! "?" $ cPerEng	.And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
/* Removido - 12/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
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

		lPort	:= ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa	:= ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl	:= ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)

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

#Include 'Protheus.ch'
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFATC8        | Autor | RENATO.OLIVEIRA           | Data | 10/01/2019  |
|=====================================================================================|
|Descrição | Relatório de calculo da campanha interna                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function RSTFATC8()

	Local   oReport
	Private cPerg 			:= "RFATC8"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	//xPutSx1(cPerg, "01", "Período:" 	,"Período: ?" 	,"Período: ?" 	,"mv_ch1", "C", 01, 0, 0, "C", "", ""		,"","S","mv_par01","1 Trimestre","","","","2 Trimestre","","","3 Trimestre","","","4 Trimestre","","","","","",,,)
	//xPutSx1(cPerg, "02", "Ano"			,"Ano"			,"Ano"			,"mv_ch2", "N", 04, 0, 0, "C", "", ""		,"","" ,"mv_par02","","","","","","","","","","","","","","","","",,,)

	oReport:=ReportDef()
	oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³				     º Data ³  	          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  								                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Local oSection2

	oReport := TReport():New(cPergTit,"Relatório de campanha interna",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de campanha interna")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Campanha interna",{"Z22"})

	TRCell():New(oSection,"01"	  			 ,,"VENDEDOR"		,,TamSx3("A3_COD")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"02"	  			 ,,"NOME"			,,TamSx3("A3_NOME")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"03"  			 ,,"ANO"			,,04,.F.,,,,,,,.T.)
	TRCell():New(oSection,"04"  			 ,,"MES INICIAL"	,,02,.F.,,,,,,,.T.)
	TRCell():New(oSection,"05"  			 ,,"MES FINAL"		,,02,.F.,,,,,,,.T.)
	TRCell():New(oSection,"06"  			 ,,"FATURADO"		,"@E 999,999,999.99",15)
	TRCell():New(oSection,"07"  			 ,,"META"			,"@E 999,999,999.99",15)
	TRCell():New(oSection,"08"  			 ,,"% ATINGIDO"		,"@E 999,999,999.99",15)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("Z22")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrinºAutor  ³				     º Data ³  	          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  								                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportPrint(oReport)

	Local oSection1	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(2)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados1[99]
	Local aDados2[99]
	Local _cSta 	:= ''
	Local _aArea	:= {}
	Local _cAlias1 := GetNextAlias()
	Local _aLocais := {}
	Local _nX := 0

	oSection1:Cell("01")    			:SetBlock( { || aDados1[01] } )
	oSection1:Cell("02")  				:SetBlock( { || aDados1[02] } )
	oSection1:Cell("03")  				:SetBlock( { || aDados1[03] } )
	oSection1:Cell("04")  				:SetBlock( { || aDados1[04] } )
	oSection1:Cell("05")  				:SetBlock( { || aDados1[05] } )
	oSection1:Cell("06")  				:SetBlock( { || aDados1[06] } )
	oSection1:Cell("07")  				:SetBlock( { || aDados1[07] } )
	oSection1:Cell("08")  				:SetBlock( { || aDados1[08] } )

	oReport:SetTitle("Relatório de campanha interna")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	oSection1:Init()

	Processa({|| U_RSTFA_C8( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:=	(cAliasLif)->A3_COD
			aDados1[02]	:= 	(cAliasLif)->A3_NOME
			aDados1[03]	:= 	CVALTOCHAR(Z22->Z22_ANO)
			aDados1[04]	:=  CVALTOCHAR(Z22->Z22_MESINI)
			aDados1[05]	:=	CVALTOCHAR(Z22->Z22_MESFIM)
			aDados1[06]	:=	(cAliasLif)->FATURADO
			aDados1[07]	:=	(cAliasLif)->Z30_OBJETI
			aDados1[08]	:= ((cAliasLif)->FATURADO/(cAliasLif)->Z30_OBJETI)*100

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())
		EndDo

	EndIf

	oSection1:Finish()

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³StQuery	ºAutor  ³				     º Data ³  	          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  								                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFA_C8()

	Local cQuery     := ' '
	Local nReg

	cQuery := " SELECT * 
	cQuery += " FROM (
	cQuery += " SELECT A3_COD, A3_NOME, Z30_OBJETI, FATURADO, ROUND(FATURADO/Z30_OBJETI*100,2) PERCENT
	cQuery += " FROM (
	cQuery += " SELECT A3_COD, A3_NOME, Z30_OBJETI, NVL(SUM(D2.D2_TOTAL-D2.D2_VALICM-D2.D2_VALIMP5-D2.D2_VALIMP6-D2.D2_DIFAL-D2.D2_ICMSCOM),0) FATURADO
	cQuery += " FROM "+RetSqlName("Z22")+" Z22
	cQuery += " LEFT JOIN "+RetSqlName("Z30")+" Z30
	cQuery += " ON Z22_FILIAL=Z30_FILIAL AND Z22_CODIGO=Z30_CODIGO
	cQuery += " LEFT JOIN "+RetSqlName("Z40")+" Z40
	cQuery += " ON Z22_FILIAL=Z40_FILIAL AND Z22_CODIGO=Z40_CODIGO
	cQuery += " LEFT JOIN "+RetSqlName("SF2")+" F2
	cQuery += " ON F2_FILIAL='"+xFilial("SF2")+"' AND F2_VEND1=Z30_VEND AND SUBSTR(F2_EMISSAO,1,6) BETWEEN '"+CVALTOCHAR(Z22->Z22_ANO)+PADL(Z22->Z22_MESINI,2,"0")+"' AND '"+CVALTOCHAR(Z22->Z22_ANOATE)+PADL(Z22->Z22_MESFIM,2,"0")+"' AND F2.D_E_L_E_T_=' '
	cQuery += " LEFT JOIN "+RetSqlName("SD2")+" D2
	cQuery += " ON D2.D2_FILIAL=F2.F2_FILIAL AND D2.D2_DOC=F2.F2_DOC AND D2.D2_SERIE=F2.F2_SERIE AND D2.D2_CLIENTE=F2.F2_CLIENTE AND D2.D2_LOJA=F2.F2_LOJA
	cQuery += " AND D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') AND EXISTS ( SELECT * FROM "+RetSqlName("SC6")+" C6 WHERE C6.C6_NUM=D2.D2_PEDIDO AND C6.C6_FILIAL=D2.D2_FILIAL AND C6.D_E_L_E_T_ = ' ') AND D2_GRUPO=Z40_GRUPO AND D2.D_E_L_E_T_=' '
	cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1
	cQuery += " ON B1.B1_COD=D2.D2_COD AND B1.D_E_L_E_T_=' ' 
	cQuery += " LEFT JOIN "+RetSqlName("SBM")+" BM
	cQuery += " ON B1.B1_GRUPO=BM.BM_GRUPO AND BM.D_E_L_E_T_=' ' 
	cQuery += " LEFT JOIN "+RetSqlName("SA3")+" A3
	cQuery += " ON A3.A3_COD=Z30_VEND AND A3.D_E_L_E_T_=' ' 
	cQuery += " WHERE Z22.D_E_L_E_T_=' ' AND Z30.D_E_L_E_T_=' ' AND Z40.D_E_L_E_T_=' ' AND Z22_CODIGO='"+Z22->Z22_CODIGO+"'
	cQuery += " GROUP BY A3_COD, A3_NOME, Z30_OBJETI
	cQuery += " ) XXX
	cQuery += " ) ZZZ
	cQuery += " ORDER BY PERCENT DESC
	
	conout(cQuery)
	
	conout(Time())

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
	conout(Time())

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xPutSx1	ºAutor  ³				     º Data ³  	          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  								                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

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

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
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

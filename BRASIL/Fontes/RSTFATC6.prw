#Include 'Protheus.ch'
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFATC6        | Autor | RENATO.OLIVEIRA           | Data | 19/12/2018  |
|=====================================================================================|
|Descrição | Relatório de endereçamento                                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|Chamado 008457																		  |
|........................................Histórico....................................|
\====================================================================================*/

User Function RSTFATC6()

	Local   oReport
	Private cPerg 			:= "RFATC6"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	
	xPutSx1(cPerg, "01", "Filial. de:" 	,"Filial. de: ?" 	,"Filial. de: ?" 	,"mv_ch1","C",2,0,0,"G","",'' 	 ,"","","mv_par01","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "02", "Filial. ate:"	,"Filial. ate: ?" 	,"Filial. ate: ?" 	,"mv_ch2","C",2,0,0,"G","",'' 	 ,"","","mv_par02","","","","","","","","","","","","","","","","")	
	xPutSx1(cPerg, "03", "Data de:" 	,"Data de: ?" 		,"Data de: ?" 		,"mv_ch3","D",8,0,0,"G","",'' 	 ,"","","mv_par03","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "04", "Data ate:"	,"Data ate: ?" 		,"Data ate: ?" 		,"mv_ch4","D",8,0,0,"G","",'' 	 ,"","","mv_par04","","","","","","","","","","","","","","","","")	
	xPutSx1(cPerg, "05", "Armazem de:"	,"Armazem de: ?" 	,"Armazem de: ?"	,"mv_ch5","C",2,0,0,"G","",'' 	 ,"","","mv_par05","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "06", "Armazem ate:"	,"Armazem ate: ?" 	,"Armazem ate: ?" 	,"mv_ch6","C",2,0,0,"G","",'' 	 ,"","","mv_par06","","","","","","","","","","","","","","","","")

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

	oReport := TReport():New(cPergTit,"Relatorio de enderecamento",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de endereçamento")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Relatorio de enderecamento",{"SDA"})

	TRCell():New(oSection,"01"	  			 ,,"FILIAL"			,,TamSx3("DA_FILIAL")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"11"	  			 ,,"NOTA FISCAL"	,,TamSx3("QEK_NTFISC")[1],.F.,,,,,,,.T.)	
	TRCell():New(oSection,"02"	  			 ,,"DOCUMENTO"		,,TamSx3("DA_DOC")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"03"  			 ,,"PRODUTO"		,,TamSx3("DA_PRODUTO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"08"  			 ,,"LOCAL"			,,TamSx3("DA_LOCAL")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"04"  			 ,,"QTDE"			,,TamSx3("DB_QUANT")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"05"  			 ,,"USUARIO"		,,20,.F.,,,,,,,.T.)
	TRCell():New(oSection,"12"  			 ,,"DATA ENTRADA"	,,10,.F.,,,,,,,.T.)
	TRCell():New(oSection,"06"  			 ,,"DATA ENDERECAMENTO"			,,10,.F.,,,,,,,.T.)
	TRCell():New(oSection,"07"  			 ,,"HORA"			,,08,.F.,,,,,,,.T.)
	TRCell():New(oSection,"09"  			 ,,"FMR"			,,TamSx3("B1_XFMR")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"10"  			 ,,"ENDERECO"		,,TamSx3("DB_LOCALIZ")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"13"  			 ,,"QTD ENDERECO"	,,10,.F.,,,,,,,.T.)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SDA")

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
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados1[99]
	Local _cSta 	:= ''
	Local _aArea	:= {}

	oSection1:Cell("01")    			:SetBlock( { || aDados1[01] } )
	oSection1:Cell("02")  				:SetBlock( { || aDados1[02] } )
	oSection1:Cell("03")  				:SetBlock( { || aDados1[03] } )
	oSection1:Cell("04")  				:SetBlock( { || aDados1[04] } )
	oSection1:Cell("05")  				:SetBlock( { || aDados1[05] } )
	oSection1:Cell("06")  				:SetBlock( { || aDados1[06] } )
	oSection1:Cell("07")  				:SetBlock( { || aDados1[07] } )
	oSection1:Cell("08")  				:SetBlock( { || aDados1[08] } )
	oSection1:Cell("09")  				:SetBlock( { || aDados1[09] } )
	oSection1:Cell("10")  				:SetBlock( { || aDados1[10] } )
	oSection1:Cell("11")  				:SetBlock( { || aDados1[11] } )
	oSection1:Cell("12")  				:SetBlock( { || aDados1[12] } )
	oSection1:Cell("13")  				:SetBlock( { || aDados1[13] } )

	oReport:SetTitle("Relatório de endereçamento")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	oSection1:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:=	(cAliasLif)->DA_FILIAL
			aDados1[02]	:= 	(cAliasLif)->DA_DOC
			aDados1[03]	:= 	(cAliasLif)->DA_PRODUTO
			aDados1[04]	:=  (cAliasLif)->DB_QUANT
			aDados1[05]	:=	(cAliasLif)->DA_XUSER
			aDados1[06]	:=	Stod((cAliasLif)->DA_XDATA)
			aDados1[07]	:=	(cAliasLif)->DA_XHORA
			aDados1[08]	:=	(cAliasLif)->DA_LOCAL
			aDados1[09]	:=	(cAliasLif)->B1_XFMR
			aDados1[10]	:=	(cAliasLif)->DB_LOCALIZ
			aDados1[11]	:=	(cAliasLif)->QEK_NTFISC
			aDados1[12]	:=	Stod((cAliasLif)->DA_DATA)
			aDados1[13]	:=	(cAliasLif)->QTDEND
			
			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())
		EndDo

	EndIf

	oReport:SkipLine()

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

Static Function StQuery()

	Local cQuery     := ' '
	Local cSituacao  := mv_par01
	Local nReg

	cQuery := " SELECT DA_FILIAL,QEK.QEK_NTFISC,DA_DOC,DA_PRODUTO,DB.DB_QUANT,DA_XUSER,DA_DATA,DA_XDATA,DA_XHORA,DA_LOCAL,B1.B1_XFMR,DB_LOCALIZ,	
	cQuery += "  ( SELECT COUNT(*) FROM "+RetSqlName("SBF")+" BF "
	cQuery += " WHERE BF.BF_LOCAL = DA.DA_LOCAL "
	cQuery += " AND BF.BF_PRODUTO = DA.DA_PRODUTO "
	cQuery += " AND BF.D_E_L_E_T_ = ' ' "
	cQuery += " ) QTDEND"
 	cQuery += " FROM "+RetSqlName("SDA")+" DA
	cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
	cQuery += " ON B1.B1_COD = DA.DA_PRODUTO "
	cQuery += " AND B1.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN "+RetSqlName("SDB")+" DB "
	cQuery += " ON DB.DB_PRODUTO = DA.DA_PRODUTO "
	cQuery += " AND DB.DB_NUMSEQ = DA.DA_NUMSEQ "
	cQuery += " AND DB.DB_LOCAL = DA.DA_LOCAL "
	cQuery += " AND DB.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN "+RetSqlName("QEK")+" QEK "
	cQuery += " ON QEK.QEK_CERFOR = DA.DA_DOC "
	cQuery += " AND QEK.D_E_L_E_T_ = ' ' "
 	cQuery += " WHERE DA.D_E_L_E_T_=' ' AND DA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' 
	cQuery += " AND DA_XDATA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"'
	cQuery += " AND DA_LOCAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
	cQuery += " ORDER BY DA_FILIAL,DA_DOC,DA_XDATA,DA_XHORA

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

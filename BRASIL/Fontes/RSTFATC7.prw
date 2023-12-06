#Include 'Protheus.ch'
#Include "Rwmake.ch"
#Include "TopConn.ch"

#DEFINE CL CHR(13)+CHR(10)
/*====================================================================================\
|Programa  | RSTFATC7        | Autor | RENATO.OLIVEIRA           | Data | 19/12/2018  |
|=====================================================================================|
|Descri็ใo | Relat๓rio de contagem de estoque CD                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|Chamado 008552																		  |
|........................................Hist๓rico....................................|
\====================================================================================*/

User Function RSTFATC7()

	Local   oReport
	Private cPerg 			:= "RFATC7"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	xPutSx1(cPerg, "01", "Produto de:" 	,"Produto de: ?" 	,"Produto de: ?" 	,"mv_ch1","C",15,0,0,"G","",'SB1' 	 ,"","","mv_par01","","","","","","","","","","","","","","","","")

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
	Local oSection2

	oReport := TReport():New(cPergTit,"Relat๓rio de contagem de estoque",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de contagem de estoque")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Contagem de estoque - SDC",{"SDC"})

	TRCell():New(oSection,"01"	  			 ,,"FILIAL"			,,TamSx3("DC_FILIAL")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"02"	  			 ,,"PRODUTO"		,,TamSx3("DC_PRODUTO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"03"  			 ,,"LOCAL"			,,TamSx3("DC_LOCAL")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"04"  			 ,,"LOCALIZACAO"	,,TamSx3("DC_LOCALIZ")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"05"  			 ,,"QTDE"			,,TamSx3("DC_QUANT")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"06"  			 ,,"PEDIDO"			,,TamSx3("DC_PEDIDO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"07"  			 ,,"STATUS"			,,20,.F.,,,,,,,.T.)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SDC")

	oSection2 := TRSection():New(oReport,"Contagem de estoque - SBF",{"SBF"})

	TRCell():New(oSection2,"01"	  			 ,,"FILIAL"			,,TamSx3("BF_FILIAL")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection2,"02"	  			 ,,"PRODUTO"		,,TamSx3("BF_PRODUTO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection2,"03"  			 ,,"LOCAL"			,,TamSx3("BF_LOCAL")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection2,"04"  			 ,,"LOCALIZACAO"	,,TamSx3("BF_LOCALIZ")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection2,"05"  			 ,,"QTDE"			,,TamSx3("BF_QUANT")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection2,"06"  			 ,,"EMPENHO"		,,TamSx3("BF_EMPENHO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection2,"07"  			 ,,"EMPENHO SEP"	,,TamSx3("BF_EMPENHO")[1],.F.,,,,,,,.T.)

	oSection2:SetHeaderSection(.t.)
	oSection2:Setnofilter("SBF")

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

	oSection2:Cell("01")    			:SetBlock( { || aDados2[01] } )
	oSection2:Cell("02")  				:SetBlock( { || aDados2[02] } )
	oSection2:Cell("03")  				:SetBlock( { || aDados2[03] } )
	oSection2:Cell("04")  				:SetBlock( { || aDados2[04] } )
	oSection2:Cell("05")  				:SetBlock( { || aDados2[05] } )
	oSection2:Cell("06")  				:SetBlock( { || aDados2[06] } )
	oSection2:Cell("07")  				:SetBlock( { || aDados2[07] } )

	oReport:SetTitle("Relat๓rio de contagem de estoque")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	oSection1:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	DbSelectArea("SDC")

	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:=	(cAliasLif)->DC_FILIAL
			aDados1[02]	:= 	(cAliasLif)->DC_PRODUTO
			aDados1[03]	:= 	(cAliasLif)->DC_LOCAL
			aDados1[04]	:=  (cAliasLif)->DC_LOCALIZ
			aDados1[05]	:=	(cAliasLif)->DC_QUANT
			aDados1[06]	:=	(cAliasLif)->DC_PEDIDO
			aDados1[07]	:=	IIf((cAliasLif)->CB8_SALDOS==0,"SEPARADO","NAO SEPARADO")

			_lAchou := .F.

			For _nX:=1 To Len(_aLocais)
				If AllTrim(_aLocais[_nx][1])==AllTrim((cAliasLif)->DC_LOCALIZ)
					If (cAliasLif)->CB8_SALDOS==0
						_aLocais[_nx][2] += (cAliasLif)->DC_QUANT
					EndIf
					_lAchou := .T.
					Exit
				EndIf
			Next

			If !_lAchou

				If (cAliasLif)->CB8_SALDOS==0
					_nQuant := (cAliasLif)->DC_QUANT
				Else
					_nQuant := 0
				EndIf

				AADD(_aLocais,{(cAliasLif)->DC_LOCALIZ,_nQuant})

			EndIf

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())
		EndDo

	EndIf

	oSection1:Finish()
	oSection2:Init()

	_cQuery1 := " SELECT BF_FILIAL, BF_PRODUTO, BF_LOCAL, BF_LOCALIZ, BF_QUANT, BF_EMPENHO "+CL
	_cQuery1 += " FROM "+RetSqlName("SBF")+" BF "+CL
	_cQuery1 += " WHERE BF.D_E_L_E_T_=' ' AND BF_FILIAL='"+xFilial("SBF")+"' "+CL
	_cQuery1 += " AND BF_PRODUTO='"+MV_PAR01+"' "+CL
	_cQuery1 += " ORDER BY BF_LOCALIZ "+CL

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		aDados2[01]	:=	(_cAlias1)->BF_FILIAL
		aDados2[02]	:= 	(_cAlias1)->BF_PRODUTO
		aDados2[03]	:= 	(_cAlias1)->BF_LOCAL
		aDados2[04]	:=  (_cAlias1)->BF_LOCALIZ
		aDados2[05]	:=	(_cAlias1)->BF_QUANT
		aDados2[06]	:=	(_cAlias1)->BF_EMPENHO

		For _nX:=1 To Len(_aLocais)
			If AllTrim(_aLocais[_nx][1])==AllTrim((_cAlias1)->BF_LOCALIZ)
				aDados2[07]	:=	_aLocais[_nx][2]
				Exit
			EndIf
		Next

		oSection2:PrintLine()
		aFill(aDados2,nil)

		(_cAlias1)->(DbSkip())
	EndDo

	oSection2:Finish()

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
	Local nReg

	cQuery := " SELECT DC_FILIAL, DC_PRODUTO, DC_LOCAL, DC_LOCALIZ, DC_QUANT, DC_PEDIDO, CB8_SALDOS "+CL
	cQuery += " FROM "+RetSqlName("SDC")+" DC "+CL
	cQuery += " LEFT JOIN "+RetSqlName("CB8")+" CB8 "+CL
	cQuery += " ON CB8_FILIAL=DC_FILIAL AND CB8_PEDIDO=DC_PEDIDO AND CB8_ITEM=DC_ITEM AND CB8_QTDORI=DC_QUANT  "+CL
	cQuery += " WHERE DC.D_E_L_E_T_=' ' AND CB8.D_E_L_E_T_=' ' "+CL

	/*************************************************************
	<<< ALTERAวรO >>> 
	A็ใo...........: Corre็ใo da Query
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 01/02/2022
	Chamado........: 20220124001876 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	*************************************************************/
	IF cEmpAnt <> "11"
		cQuery += " AND DC_FILIAL='02' AND DC_QUANT>0 "+CL
	ELSE
		cQuery += " AND DC_FILIAL='01' AND DC_QUANT>0 "+CL
	ENDIF

	cQuery += " AND DC_PRODUTO = '"+MV_PAR01+"' "+CL
	cQuery += " ORDER BY DC_PEDIDO "+CL

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

/*====================================================================================\
|Programa  | GETSTATUS        | Autor | RENATO.OLIVEIRA           | Data | 19/12/2018 |
|=====================================================================================|
|Descri็ใo | Retornar status                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|Chamado 008552																		  |
|........................................Hist๓rico....................................|
\====================================================================================*/

Static Function GETSTATUS(_cStatus)

	Local _cDesc := ""

	_cStatus := AllTrim(_cStatus)

	//0=Inicio;1=Separando;2=Sep.Final;3=Embalando;4=Emb.Final;5=Gera Nota;6=Imp.nota;7=Imp.Vol;8=Embarcado;9=Embarque Finalizado

	Do Case
		Case _cStatus=="0"
		_cDesc := "INICIO"
		Case _cStatus=="1"
		_cDesc := "SEPARANDO"
		Case _cStatus=="2"
		_cDesc := "SEPARACAO FINALIZADA"
		Case _cStatus=="3"
		_cDesc := "EMBALANDO"
		Case _cStatus=="4"
		_cDesc := "EMBALAGEM FINALIZADA"
		Case _cStatus=="5"
		_cDesc := "NOTA GERADA"
		Case _cStatus=="6"
		_cDesc := "NOTA IMPRESSA"
		Case _cStatus=="7"
		_cDesc := "VOLUME IMPRESSO"
		Case _cStatus=="8"
		_cDesc := "EMBARCADO"
		Case _cStatus=="9"
		_cDesc := "EMBARQUE FINALIZADO"
	EndCase

Return(_cDesc)

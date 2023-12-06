#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFATCO        | Autor | RENATO.OLIVEIRA           | Data | 02/05/2019  |
|=====================================================================================|
|Descrição | Relatório de residuo	                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function RSTFATCO()

	Local   oReport
	Private cPerg 			:= "RFATCO"
	Private cTime        	:= Time()
	Private cHora        	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cPergTit 		:= cAliasLif

	xPutSx1(cPerg, "01", "Pedido de:"		,"Pedido de: ?" 	,"Pedido de: ?" 	,"mv_ch1","C",6,0,0,"G","",'' 			,"","","mv_par01","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "02", "Pedido ate:"		,"Pedido ate: ?" 	,"Pedido ate: ?" 	,"mv_ch2","C",6,0,0,"G","",'' 			,"","","mv_par02","","","","","","","","","","","","","","","","")

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return

/*====================================================================================\
|Programa  | ReportDef       | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function ReportDef()

	Local oReport
	Local oSection1
	Local oSection2

	oReport := TReport():New(cPergTit,"Relatório de resíduo",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de resíduo")

	Pergunte(cPerg,.F.)

	oSection1 := TRSection():New(oReport,"Z51",{"Z51"})

	TRCell():New(oSection1,"01"	  			 ,,"Filial"				,,02,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"12"	  			 ,,"Código"				,,TamSx3("Z51_CODIGO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"02"	  			 ,,"Pedido"				,,TamSx3("Z51_PEDIDO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"03"	  			 ,,"Data"				,,TamSx3("Z51_DATA")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"04"	  			 ,,"Hora"				,,TamSx3("Z51_HORA")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"05"	  			 ,,"Motivo"				,,TamSx3("Z51_MOTIVO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"06"	  			 ,,"Tipo"				,,TamSx3("Z51_TIPO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"07"	  			 ,,"Usuário"			,,TamSx3("Z51_USER")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"08"	  			 ,,"Item"				,,TamSx3("Z52_ITEM")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"09"	  			 ,,"Produto"			,,TamSx3("Z52_PROD")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"10"	  			 ,,"Qtde"				,,TamSx3("Z52_QTD")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"11"	  			 ,,"Valor"				,,TamSx3("Z52_VALOR")[1],.F.,,,,,,,.T.)

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("Z51")

Return oReport

/*====================================================================================\
|Programa  | ReportPrint     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function ReportPrint(oReport)

	Local oSection1	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(2)
	Local nX		:= 0
	Local aDados1[99]
	Local aDados2[99]
	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()

	oSection1:Cell('01')      :SetBlock( { || aDados1[01] } )
	oSection1:Cell('02')      :SetBlock( { || aDados1[02] } )
	oSection1:Cell('03')      :SetBlock( { || aDados1[03] } )
	oSection1:Cell('04')      :SetBlock( { || aDados1[04] } )
	oSection1:Cell('05')      :SetBlock( { || aDados1[05] } )
	oSection1:Cell('06')      :SetBlock( { || aDados1[06] } )
	oSection1:Cell('07')      :SetBlock( { || aDados1[07] } )
	oSection1:Cell('08')      :SetBlock( { || aDados1[08] } )
	oSection1:Cell('09')      :SetBlock( { || aDados1[09] } )
	oSection1:Cell('10')      :SetBlock( { || aDados1[10] } )
	oSection1:Cell('11')      :SetBlock( { || aDados1[11] } )
	oSection1:Cell('12')      :SetBlock( { || aDados1[12] } )

	oReport:SetTitle("Relatório de resíduo")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	aFill(aDados2,nil)
	oSection1:Init()
	oSection2:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:= (cAliasLif)->Z51_FILIAL
			aDados1[02]	:= (cAliasLif)->Z51_PEDIDO
			aDados1[03]	:= STOD((cAliasLif)->Z51_DATA)
			aDados1[04]	:= (cAliasLif)->Z51_HORA
			aDados1[05]	:= (cAliasLif)->Z51_MOTIVO
			aDados1[06]	:= (cAliasLif)->Z51_TIPO
			aDados1[07]	:= (cAliasLif)->Z51_USER
			aDados1[08]	:= (cAliasLif)->Z52_ITEM
			aDados1[09]	:= (cAliasLif)->Z52_PROD
			aDados1[10]	:= (cAliasLif)->Z52_QTD
			aDados1[11]	:= (cAliasLif)->Z52_VALOR
			aDados1[12]	:= (cAliasLif)->Z51_CODIGO

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())
		EndDo

	EndIf

	oSection1:Finish()

Return oReport

/*====================================================================================\
|Programa  | StQuery	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function StQuery()

	Local cQuery     := ' '
	Local nReg

	cQuery := " SELECT *
	cQuery += " FROM "+RetSqlName("Z51")+" Z51
	cQuery += " LEFT JOIN "+RetSqlName("Z52")+" Z52
	cQuery += " ON Z51_FILIAL=Z52_FILIAL AND Z51_PEDIDO=Z52_PEDIDO AND Z51_CODIGO=Z52_CODIGO
	cQuery += " WHERE Z51.D_E_L_E_T_=' ' AND Z52.D_E_L_E_T_=' ' AND Z51_FILIAL='"+cFilAnt+"'
	
	If !Empty(MV_PAR01) .Or. !Empty(MV_PAR02)
		cQuery += " AND Z51_PEDIDO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	EndIf
	
	cQuery += " ORDER BY Z51_FILIAL, Z51_PEDIDO, Z51_DATA, Z51_HORA

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

/*====================================================================================\
|Programa  | xPutSx1	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

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

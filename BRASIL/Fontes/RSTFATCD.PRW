#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFATCD        | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição | Relatório eaa antigo - 2018	                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function RSTFATCD()

	Local   oReport
	Private cPerg 		:= "RFATCD"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader   := .F.
	Private lXmlEndRow   := .F.
	Private cPergTit 		:= cAliasLif

	xPutSx1(cPerg, "01", "Matricula de:"	,"Matricula de: ?" 	,"Matricula de: ?" 		,"mv_ch1","C",6,0,0,"G","",'SRA' 		,"","","mv_par01","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "02", "Matricula ate:"	,"Matricula ate: ?" ,"Matricula ate: ?" 	,"mv_ch2","C",6,0,0,"G","",'SRA' 		,"","","mv_par02","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "03", "Ano:"				,"Ano: ?" 			,"Ano: ?" 				,"mv_ch3","C",4,0,0,"G","",'' 			,"","","mv_par03","","","","","","","","","","","","","","","","")

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
	Local oSection
	Local oSection2

	oReport := TReport():New(cPergTit,"Relatório de acompanhamento do EAA "+Alltrim(mv_par03),cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de acompanhamento do EAA 2018")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"EAA "+Alltrim(mv_par03),{"PPM"})
	
	TRCell():New(oSection,"17"	  			 ,,"Empresa"			,,02,.F.,,,,,,,.T.)
	TRCell():New(oSection,"18"	  			 ,,"Filial"				,,02,.F.,,,,,,,.T.)
	TRCell():New(oSection,"01"	  			 ,,"Matrícula"			,,06,.F.,,,,,,,.T.)
	TRCell():New(oSection,"02"	  			 ,,"Nome participante" 	,,50,.F.,,,,,,,.T.)
	TRCell():New(oSection,"03"	  			 ,,"Setor" 				,,50,.F.,,,,,,,.T.)

	TRCell():New(oSection,"16"	  			 ,,"Fez o EAA/METAS"	,,03,.F.,,,,,,,.T.)

	TRCell():New(oSection,"04"	  			 ,,"Avaliador"			,,50,.F.,,,,,,,.T.)
	TRCell():New(oSection,"05"	  			 ,,"Ano"				,,04,.F.,,,,,,,.T.)
	TRCell():New(oSection,"06"	  			 ,,"Dt avaliação"		,,08,.F.,,,,,,,.T.)

	//Perguntas
	TRCell():New(oSection,"07"	  			 ,,"O Cliente em Primeiro Lugar" 	,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"08"	  			 ,,"Ser Disruptivo" 				,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"09"	  			 ,,"Abraçar o Diferente"			,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"10"	  			 ,,"Aprender Todos os Dias"			,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"11"	  			 ,,"Ser Dono do Negócio"			,,30,.F.,,,,,,,.T.)

	TRCell():New(oSection,"12"	  			 ,,"Comentário funcionario"			,,10,.F.,,,,,,,.T.)
	TRCell():New(oSection,"13"	  			 ,,"Pontos positivos"				,,10,.F.,,,,,,,.T.)
	TRCell():New(oSection,"14"	  			 ,,"Pontos de melhorias"			,,10,.F.,,,,,,,.T.)
	TRCell():New(oSection,"15"	  			 ,,"Nota"							,,10,.F.,,,,,,,.T.)

	oSection:SetHeaderSection(.T.)
	oSection:Setnofilter("PPM")

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
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados1[99]
	Local aDados2[99]
	Local _cSta 	:= ''
	Local _aArea	:= {}
	Local _cAlias1 := GetNextAlias()
	Local _aLocais := {}
	Local _nX := 0
	Local _cQuery2 := ""
	Local _cAlias2 := GetNextAlias()

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
	oSection1:Cell('13')      :SetBlock( { || aDados1[13] } )
	oSection1:Cell('14')      :SetBlock( { || aDados1[14] } )
	oSection1:Cell('15')      :SetBlock( { || aDados1[15] } )
	oSection1:Cell('16')      :SetBlock( { || aDados1[16] } )
	oSection1:Cell('17')      :SetBlock( { || aDados1[17] } )
	oSection1:Cell('18')      :SetBlock( { || aDados1[18] } )

	oReport:SetTitle("Relatório do EAA "+Alltrim(mv_par03))// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	oSection1:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	DbSelectArea("PPM")

	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			PPM->(DbGoTo((cAliasLif)->R_E_C_N_O_))
			
			aDados1[17]	:= (cAliasLif)->EMP
			aDados1[18]	:= (cAliasLif)->RA_FILIAL
			
			aDados1[01]	:= (cAliasLif)->RA_MAT
			aDados1[02]	:= (cAliasLif)->RA_NOME
			aDados1[03]	:= Posicione("SQB",1,xFilial("SQB")+(cAliasLif)->RA_DEPTO,"QB_DESCRIC")
			If PPM->(!Eof())
				aDados1[04] := PPM->PPM_04
			Else
				aDados1[04] := ""
			EndIf
			aDados1[05] :=PPM->PPM_ANO
			If PPM->(!Eof())
				aDados1[06] := DTOC(PPM->PPM_06)
			Else
				aDados1[06] := ""
			EndIf

			If PPM->(!Eof())
				aDados1[07] := GETSTATUS1(PPM->PPM_09)
				aDados1[08] := GETSTATUS1(PPM->PPM_10)
				aDados1[09] := GETSTATUS1(PPM->PPM_11)
				aDados1[10] := GETSTATUS1(PPM->PPM_12)
				aDados1[11] := GETSTATUS1(PPM->PPM_13)

				aDados1[12] := PPM->PPM_07
				aDados1[13] := PPM->PPM_08
				aDados1[14] := PPM->PPM_46
				aDados1[15] := GETSTATUS2(PPM->PPM_NOTA)
			Else
				aDados1[07] := ""
				aDados1[08] := ""
				aDados1[09] := ""
				aDados1[10] := ""
				aDados1[11] := ""

				aDados1[12] := ""
				aDados1[13] := ""
				aDados1[14] := ""
				aDados1[15] := ""

				_cQuery2 := " SELECT *
				_cQuery2 += " FROM PH3010 PH3
				_cQuery2 += " WHERE PH3.D_E_L_E_T_=' ' AND PH3_USERID='"+(cAliasLif)->RA_XUSRCFG+"' AND PH3_ANO='"+MV_PAR03+"'

				If !Empty(Select(_cAlias2))
					DbSelectArea(_cAlias2)
					(_cAlias2)->(dbCloseArea())
				Endif

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

				dbSelectArea(_cAlias2)
				(_cAlias2)->(dbGoTop())

				If (_cAlias2)->(!Eof())
					aDados1[16] := "Sim"
				EndIf

			EndIf

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

	cQuery += " SELECT *
	cQuery += " FROM (
	cQuery += " SELECT '01' EMP, RA_FILIAL,RA_MAT,RA_NOME, RA_DEMISSA, RA_XUSRCFG, RA_DEPTO FROM SRA010 RA WHERE RA.D_E_L_E_T_=' ' AND RA_DEMISSA=' ' AND RA_SITFOLH NOT IN ('D','T')
	cQuery += " UNION
	cQuery += " SELECT '03' EMP, RA_FILIAL,RA_MAT,RA_NOME, RA_DEMISSA, RA_XUSRCFG, RA_DEPTO FROM SRA030 RA WHERE RA.D_E_L_E_T_=' ' AND RA_DEMISSA=' ' AND RA_SITFOLH NOT IN ('D','T')
	cQuery += " ) XXX
	cQuery += " LEFT JOIN PPM010 PPM
	cQuery += " ON PPM.PPM_EMP=XXX.EMP AND PPM.PPM_FILIAL=XXX.RA_FILIAL AND PPM.PPM_MAT=XXX.RA_MAT AND PPM.D_E_L_E_T_=' '  AND PPM_ANO='"+MV_PAR03+"'
	cQuery += " WHERE RA_DEMISSA=' '

	If !Empty(mv_par01) .Or. !Empty(mv_par02)
		cQuery += " AND RA_MAT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	EndIf

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

/*====================================================================================\
|Programa  | GETSTATUS2	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
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

Static Function GETSTATUS2(_cOpcao)

	Local _cDesc := ""

	_cOpcao := AllTrim(_cOpcao)

	Do Case
		Case _cOpcao=="1"
		_cDesc := "Alta perfomance"
		Case _cOpcao=="2"
		_cDesc := "Perfomance"
		Case _cOpcao=="3"
		_cDesc := "Competente"
		Case _cOpcao=="4"
		_cDesc := "Baixa perfomance"
	EndCase

Return(_cDesc)

/*====================================================================================\
|Programa  | GETSTATUS1	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
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

Static Function GETSTATUS1(_cOpcao)

	Local _cDesc := ""

	_cOpcao := Alltrim(_cOpcao)

	If _cOpcao=="1"
		_cDesc := "Fortaleza"
	Else
		_cDesc := "Área de desenvolvimento"
	EndIf

Return(_cDesc)

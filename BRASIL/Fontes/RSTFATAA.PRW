#INCLUDE "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RSTFAT66 ³ Autor ³ Renato Nogueira       ³ Data ³ 25/02/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Impressao do EAA					                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 		                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFATAA()

	Local lContinua      := .T.
	Private cString      := "PPM"
	Private aOrd         := {}
	Private cDesc1       := "Este programa tem como objetivo imprimir informacoes do" //
	Private cDesc2       := "EAA 2018" //
	Private cPict        := ""
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "RSTFATAA" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := {"Zebrado",1,"Administracao",2,2,1,"",1}  //###
	Private nLastKey     := 0
	Private cPerg        := "RFAT66"
	Private titulo       := "Relatório EAA - 2018" //
	Private nLin         := 06
	Private Cabec1       := ""
	Private Cabec2       := ""
	Private cbtxt        := "Regsitro(s) lido(s)" //
	Private cbcont       := 0
	Private CONTFL       := 01
	Private m_pag        := 01
	Private lRet         := .T.
	Private imprime      := .T.
	Private wnrel        := "RSTFATAA" // Coloque aqui o nome do arquivo usado para impressao em disco

	xPutSx1(cPerg, "01", "Avaliador:"		,"Avaliador: ?" 	,"Avaliador: ?" 		,"mv_ch1","C",25,0,0,"G","",'' 			,"","","mv_par01","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "02", "Matricula de:"	,"Matricula de: ?" 	,"Matricula de: ?" 		,"mv_ch2","C",6,0,0,"G","",'SRA' 		,"","","mv_par02","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "03", "Matricula ate:"	,"Matricula ate: ?" ,"Matricula ate: ?" 	,"mv_ch3","C",6,0,0,"G","",'SRA' 		,"","","mv_par03","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "04", "Informe o Ano:"	,"Informe o Ano: ?" ,"Informe o Ano: ?" 	,"mv_ch4","C",6,0,0,"G","",'' 		    ,"","","mv_par04","","","","","","","","","","","","","","","","")

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,Nil,.F.,aOrd,.F.,Tamanho,,.T.)

	Pergunte(cPerg,.F.)

	If	nLastKey == 27
		lContinua := .F.
	EndIf

	If	lContinua
		SetDefault(aReturn,cString)
	EndIf

	If	nLastKey == 27
		lContinua := .F.
	EndIf

	If	lContinua
		RptStatus({|| Relatorio() },Titulo)
	EndIf

	PPM->(DbClearFilter())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RSTFAT66 ³ Autor ³ Renato Nogueira       ³ Data ³ 25/02/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Impressao do EAA					                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 		                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Relatorio()

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()

	DbSelectArea("PPM")

	_cQuery1 := " SELECT R_E_C_N_O_
	_cQuery1 += " FROM PPM010 PPM
	_cQuery1 += " WHERE PPM.D_E_L_E_T_=' ' AND PPM_ANO='"+MV_PAR04+"'

	If !Empty(MV_PAR02) .Or. !Empty(MV_PAR03)
		_cQuery1 += " AND PPM_MAT BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'
	EndIf

	If __cUserId $ GetMv("RSTFATAA01",,"000952#000915#001013#000975")
		If !Empty(MV_PAR01)
			_cQuery1 += " AND PPM_04='"+MV_PAR01+"'
		EndIf
	Else
		_cQuery1 += " AND PPM_04='"+UsrRetName(__cUserId)+"'
	EndIf

	_cQuery1 += " ORDER BY PPM_MAT

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	SetRegua(RecCount()-Recno())

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

	While (_cAlias1)->(!Eof())

		PPM->(DbGoTo((_cAlias1)->R_E_C_N_O_))

		IncRegua("Imprimindo")  //
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***" //
			//		Exit
		Endif
		Imprime()

		(_cAlias1)->(DbSkip())
	EndDo

	Fim()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RSTFAT66 ³ Autor ³ Renato Nogueira       ³ Data ³ 25/02/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Impressao do EAA					                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 		                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Imprime(lRet)

	Local nWidth  := 0.050
	Local nHeigth := 0.75
	Local oPr

	@ 006, 000 PSay "Avaliado: "+PPM->PPM_01
	@ 007, 000 Psay "Departamento: "+PPM->PPM_03
	@ 008, 000 Psay "Avaliador: "+PPM->PPM_04
	@ 009, 000 Psay "Data de admissão: "+DTOC(PPM->PPM_05)
	@ 010, 000 Psay "Data da avaliação: "+DTOC(PPM->PPM_06)
	@ 011, 000 Psay __PrtThinLine()

	nLin := 12
	nLin++

	@ nLin, 000 PSay "O Cliente em Primeiro Lugar"
	nLin++
	@ nLin, 000 Psay GETSTATUS1(PPM->PPM_09)
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Ser Disruptivo"
	nLin++
	@ nLin, 000 Psay GETSTATUS1(PPM->PPM_10)
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Abraçar o Diferente"
	nLin++
	@ nLin, 000 Psay GETSTATUS1(PPM->PPM_11)
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Aprender Todos os Dias"
	nLin++
	@ nLin, 000 Psay GETSTATUS1(PPM->PPM_12)
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Ser Dono do Negócio"
	nLin++
	@ nLin, 000 Psay GETSTATUS1(PPM->PPM_13)
	nLin++
	@ nLin,000 PSay __PrtThinLine()

	nLin++
	@ nLin, 000 PSay "Comentário funcionario"
	nLin++
	@ nLin, 000 Psay PPM->PPM_07
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Pontos positivos"
	nLin++
	@ nLin, 000 Psay PPM->PPM_08
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Pontos de melhorias"
	nLin++
	@ nLin, 000 Psay PPM->PPM_46
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay "Nota"
	nLin++
	@ nLin, 000 Psay GETSTATUS2(PPM->PPM_NOTA)
	nLin++
	@ nLin,000 PSay __PrtThinLine()

	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function Fim()

	SET DEVICE TO SCREEN
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RSTFAT66 ³ Autor ³ Renato Nogueira       ³ Data ³ 25/02/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Impressao do EAA					                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 		                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RESPOSTA1(_nResp,_cPerg)

	Local _nPerg	:= Val(SubStr(_cPerg,10,2))
	Local _cResp	:= ""
	_nResp	:= Val(_nResp)

	//If _nPerg <= 16
	DO CASE
		CASE _nResp=1
		_cResp	:= "Baixa performance"
		CASE _nResp=2
		_cResp	:= "Competente"
		CASE _nResp=3
		_cResp	:= "Performance"
		CASE _nResp=4
		_cResp	:= "Auto performance"
	ENDCASE
	//EndIf

Return(_cResp)

Static Function RESPOSTA(_nResp,_cPerg)

	Local _cResp	:= ""

	DO CASE
		CASE _nResp=="1"
		_cResp	:= "Meta não alcançada"
		CASE _nResp=="2"
		_cResp	:= "Meta parcialmente alcançada"
		CASE _nResp=="3"
		_cResp	:= "Meta alcançada"
		CASE _nResp=="4"
		_cResp	:= "Meta excedida"
		CASE _nResp=="5"
		_cResp	:= "Meta constantemente excedida"
	ENDCASE

Return(_cResp)

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

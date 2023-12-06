#Include "RWMake.ch"

#DEFINE cEol Chr(13) + Chr(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ STHOLITA บAutor  ณEduardo Silva       บ Data ณ 23/09/2020  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera CNAB de Holerite para o Banco Itau		              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function STHOLITA()

Private cPerg     	:= 'GDLQIT'
Private cString   	:= 'SRA'
Private cSeqReBb	:= ''
Private cLin		:= ''
Private cNomeArq	:= ''
Private nQtFunc		:= 0
Private nHdl		:= 0
Private lLiq		:= .F.
Private lData		:= .F.
Private lHeader		:= .F.
Private lContinua	:= .T.
Private oGeraTxt

fAsrPerg(cPerg)
Pergunte(cPerg,.F.)

dbSelectArea( "SRA" )
dbSetOrder(1)

// Montagem da tela de processamento
@ 200,001 To 330,385 Dialog oGeraTxt Title OemToAnsi( "Geracao do Arquivo de Pagamento" )
@ 005,005 To 060,190
@ 010,010 Say "Este programa gerara o arquivo de demonstrativo de pagamento do Itau"
// Botoes
@ 040,098 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 040,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 040,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
Activate Dialog oGeraTxt Centered

If lLiq
	Aviso("ATENCAO","Valor liquido de alguns funcionarios com diferen็as",{"Continuar"})
Endif

If nHdl > 0
	If fClose(nHdl)
		If lContinua .And. lData
			ApMsgInfo( 'Arquivo Gerado.  Processamento Concluido. ', 'ATENวรO' )
		Else
			If fErase(cNomeArq) == 0
				If !lContinua .Or. !lData
					ApMsgInfo( 'Nao Existem Registros a Serem Gravados. Processamento Concluido.', 'ATENวรO' )
				EndIf
			Else
				MsgAlert('Ocorreram problemas na tentativa de deleo do arquivo ' + AllTrim(cNomeArq)+'.')
			EndIf
		EndIf
	Else
		MsgAlert('Ocorreram problemas no fechamento do arquivo ' + AllTrim(cNomeArq)+'.')
	EndIf
Else
	If !lContinua
		ApMsgInfo( 'Processamento Abortado.', 'ATENวรO' )
	Endif
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบFuno    ณOKGERATXT บ Autor ณ Eduardo Silva      บ Data ณ  23/09/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck			                                          บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function OkGeraTxt()

Processa({|| RunCont() },"Processando...")

Close(oGeraTxt)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ Eduardo Silva      บ Data ณ  23/09/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck				                                      บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function RunCont()

Local cMesArqRef
//Local aOrdBag     := {}
//Local cArqMov     := ""
//Local cAliasMov   := ""
Local nReg		  := 0
Local cAcessaSR1  := &("{ || " + ChkRH("GPER030","SR1","2") + "}")
Local cAcessaSRA  := &("{ || " + ChkRH("GPER030","SRA","2") + "}")
Local cAcessaSRC  := &("{ || " + ChkRH("GPER030","SRC","2") + "}")
Local cAcessaSRI  := &("{ || " + ChkRH("GPER030","SRI","2") + "}")
Local cAcessaSRR  := &("{ || " + ChkRH("GPER030","SRR","2") + "}")

//Variaveis para emissao do arquivo de ferias
Local cDataBas	:= ""
Local cDBaseAt	:= ""
Local cDFerias	:= ""
Local cDAbonPe	:= ""

Private dDataRef, cEsc, nEsc, Semana, cFilDe, cFilAte, cCcDe, cCcAte, cMatDe
Private cMatAte, Mensag1, Mensag2, Mensag3, cSit, cCat
Private cMesAnoRef, lAtual, dDtBusFer, dDtFerIni
Private _cBanco, _cAgencia, _cConta
Private cFinPgt, nSequenc, dDataPagto, dDataDe, dDataAte
Private aTotLote := {0,0}
Private TOTVENC, TOTDESC, FLAG, CHAVE
Private Desc_Fil, Desc_End, DESC_CGC, DESC_FUNC
Private DESC_MSG1, DESC_MSG2, DESC_MSG3
Private cFilialAnt, cFuncaoAnt, cCcAnt, Vez, OrdemZ
Private nAteLim, nBaseFgts, nFgts, nBaseIr, nBaseIrFe, nLiquido
Private aLanca := {}
Private aProve := {}
Private aDesco := {}
Private aBases := {}
Private aInfo  := {}
Private aCodFol:= {}
Private cFolMes_ := GetMV("MV_FOLMES")

Pergunte(cPerg,.F.)
dDataRef   := Mv_Par01
cEsc       := Mv_Par02
cFilDe     := Mv_Par03
cFilAte    := mv_Par04
cCcDe      := Mv_Par05
cCcAte     := Mv_Par06
cMatDe     := Mv_Par07
cMatAte    := Mv_Par08
Mensag1    := Mv_Par09
Mensag2    := Mv_Par10
Mensag3    := Mv_Par11
cSit       := Mv_Par12
cCat       := Mv_Par13
cNomeArq   := Alltrim(Mv_Par14)
dDataPagto := Mv_Par15
_cBanco    := Mv_Par16
_cAgencia  := Mv_Par17
_cConta    := Mv_Par18
dDataDe	   := Mv_Par19
dDataAte   := Mv_Par20

For nReg := 1 to Len(cEsc)
	If !("*" == Substr(cEsc,nReg,1))
		nEsc	:= Val(Substr(cEsc,nReg,1))
		Exit
	EndIf
Next nReg

//Cria o arquivo texto
While .T.
	If File(cNomeArq)
		If (nAviso := Aviso('AVISO','Deseja substituir o ' + AllTrim(cNomeArq) + ' existente ?', {'Sim','No','Cancela'})) == 1
			If fErase(cNomeArq) == 0
				Exit
			Else
				MsgAlert('Ocorreram problemas na tentativa de deleo do arquivo ' + AllTrim(cNomeArq) + '.')
			EndIf
		ElseIf nAviso == 2
			Pergunte(cPerg,.T.)
			Loop
		Else
			lContinua := .F.
			Return
		EndIf
	Else
		Exit
	EndIf
EndDo

nHdl := fCreate(cNomeArq)

If nHdl == -1
	MsgAlert("O arquivo de nome " + cNomeArq + " nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
EndIf

cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
cMesArqRef := If(nEsc == 4,"13" + Right(cMesAnoRef,4),cMesAnoRef)

// Verifica se existe o arquivo de fechamento do mes informado
/*
If nEsc <> 6
	//	lAtual := ( !fExistArq( cMesArqRef,,0 ) .And. MesAno(dDataRef) == MesAno(dDataBase) )
	lAtual := ( !fExistArq( cMesArqRef,,0 ) .And. MesAno(dDataRef) == cFolMes_ )
	If !lAtual
		If !fIniArqMov( cMesArqRef, @cAliasMov , @aOrdBag , @cArqMov )
			ChkFile( cAliasMov , .F. )
			Return
		EndIf
	EndIf
EndIf
*/

// Selecionando a Ordem de impressao escolhida no parametro.
dbSelectArea( "SI3" )
dbSetOrder(1)
dbSelectArea( "SRF" )
dbSetOrder(1)
dbSelectArea( "SRH" )
dbSetOrder(1)
dbSelectArea( "SRJ" )
dbSetOrder(1)
dbSelectArea( "SRR" )
dbSetOrder(1)
dbSelectArea( "SRA" )
dbSetOrder(1)
dbGoTop()

// Selecionando o Primeiro Registro e montando Filtro.
dbSeek(cFilDe + cMatDe,.T.)
cCond := "SRA->RA_FILIAL + SRA->RA_MAT <= cFilAte + cMatAte"

dbSelectArea("SRA")
ProcRegua(RecCount(0))

TOTVENC    := TOTDESC   := FLAG      := CHAVE     := 0
Desc_Fil   := Desc_End  := DESC_CGC  := DESC_FUNC := ""
DESC_MSG1  := DESC_MSG2 := DESC_MSG3 := Space(01)
cFilialAnt := "  "
cFuncaoAnt := "    "
cCcAnt     := Space(9)
Vez        := 0
OrdemZ     := 0
nSequenc   := 0

If nEsc == 1			// Adiantamento
	cFinPgt := "02"
ElseIf nEsc == 2		// Folha
	cFinPgt := "01"
ElseIf nEsc == 3		// 1a Parcela
	cFinPgt := "04"
ElseIf nEsc == 4		// 2a Parcela
	cFinPgt := "04"
ElseIf nEsc	== 5		// Extras
	cFinPgt := "10"
ElseIf nEsc == 6		// Ferias
	cFinPgt := "07"
EndIf

If _cBanco != '341'	// Subst(cBancoDe,1,3) != '341'.Or. Subst(cBancoAte,1,3) != '341'
	Aviso("ATENCAO BANCO ITAU","Banco/Agencia De ou Banco/Agencia Ate Diferente de 341",{"Continuar"})
	Return
EndIf

dbSelectArea("SRA")
Do While SRA->( !Eof() ) .And. &cCond .And. lContinua	
	If (SRA->RA_FILIAL < cFilDe) .Or. (SRA->RA_FILIAL > cFilAte) .Or. (SRA->RA_CC < cCcDe) .Or. (SRA->RA_CC > cCcAte) .Or. (SRA->RA_MAT < cMatDe) .Or. (SRA->RA_MAT > cMatAte)
		SRA->( dbSkip() )
		Loop
	EndIf
	IncProc("Filial: " + SRA->RA_FILIAL + "  Matricula: " + SRA->RA_MAT)
	// Verifica Data Demissao
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CtoD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4),"DDMMYY")
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	EndIf
	// Consiste situacao e categoria dos funcionarios
	If !( cSitFunc $ cSit ) .Or. !( SRA->RA_CATFUNC $ cCat )
		dbSkip()
		Loop
	EndIf
	If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
		dbSkip()
		Loop
	EndIf
	// Filtra Bancos e Contas
	If (Substr(SRA->RA_BCDEPSA,1,3) < _cBanco)
		SRA->( dbSkip() )
		Loop
	EndIf
	aLanca  := {}
	aProve  := {}
	aDesco  := {}
	aBases  := {}
	cDataBas	:= ""
	cDBaseAt	:= ""
	cDFerias	:= ""
	cDAbonPe	:= ""
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := nLiquido := 0.00
	// Consiste controle de acessos e filiais validas
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		SRA->( dbSkip() )
		Loop
	EndIf
	If SRA->RA_CODFUNC # cFuncaoAnt           // Descricao da Funcao
		DescFun(Sra->Ra_Codfunc,Sra->Ra_Filial)
		cFuncaoAnt := Sra->Ra_CodFunc
	EndIf
	If SRA->RA_CC # cCcAnt                   // Centro de Custo
		DescCC(Sra->Ra_Cc,Sra->Ra_Filial)
		cCcAnt := SRA->RA_CC
	EndIf
	If SRA->RA_Filial # cFilialAnt
		If !Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. !fInfo(@aInfo,Sra->Ra_Filial)
			lContinua := .F.
			Exit
		EndIf
		Desc_Fil := aInfo[3]
		Desc_End := aInfo[4]                // Dados da Filial
		Desc_CGC := aInfo[8]
		DESC_MSG1:= DESC_MSG2 := DESC_MSG3 := Space(01)
		// MENSAGENS
		If MENSAG1 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL + MENSAG1)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  " + MENSAG1)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
			EndIf
		EndIf
		If MENSAG2 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL + MENSAG2)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  " + MENSAG2)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
			EndIf
		EndIf
		If MENSAG3 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL + MENSAG3)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  " + MENSAG3)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
			EndIf
		EndIf
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	EndIf
	Totvenc := Totdesc := 0
	SI3->(dbSeek( xFilial("SI3",SRA->RA_FILIAL)+SRA->RA_CC ))
	SRJ->(dbSeek( xFilial("SRJ",SRA->RA_FILIAL)+SRA->RA_CODFUNC ))
	SRH->(dbSeek( xFilial("SRH",SRA->RA_FILIAL)+SRA->RA_MAT ))
	If nEsc == 1 .Or. nEsc == 2
		dbSelectArea("SRC")
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			Do While !Eof() .And. SRC->RC_FILIAL + SRC->RC_MAT == SRA->RA_FILIAL + SRA->RA_MAT
				If !Eval(cAcessaSRC)
					dbSkip()
					Loop
				EndIf
				If (nEsc == 1) .And. (SRC->RC_PD == aCodFol[7,1])      // Desconto de Adto
					fSomaPd("P",aCodFol[6,1],SRC->RC_HORAS,SRC->RC_VALOR)
					TOTVENC += SRC->RC_VALOR
				ElseIf (nEsc == 1) .And. (SRC->RC_PD == aCodFol[12,1])
					fSomaPd("D",aCodFol[9,1],SRC->RC_HORAS,SRC->RC_VALOR)
					TOTDESC += SRC->RC_VALOR
				ElseIf (nEsc == 1) .And. (SRC->RC_PD == aCodFol[8,1])
					fSomaPd("P",aCodFol[8,1],SRC->RC_HORAS,SRC->RC_VALOR)
					TOTVENC += SRC->RC_VALOR
				Else
					If PosSrv( SRC->RC_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
						If (nEsc #1) .Or. (nEsc == 1 .And. PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_ADIANTA") == "S")
							fSomaPd("P",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
							TOTVENC += SRC->RC_VALOR
						EndIf
					Elseif PosSrv( SRC->RC_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"
						If (nEsc #1) .Or. (nEsc == 1 .And. PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_ADIANTA") == "S")
							fSomaPd("D",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
							TOTDESC += SRC->RC_VALOR
						EndIf
					ElseIf PosSrv( SRC->RC_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "3"
						If (nEsc #1) .Or. (nEsc == 1 .And. PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_ADIANTA") == "S")
							fSomaPd("B",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
						EndIf
					EndIf
				EndIf
				If nEsc == 1
					If SRC->RC_PD == aCodFol[10,1]
						nBaseIr := SRC->RC_VALOR
					EndIf
				ElseIf SRC->RC_PD == aCodFol[13,1]
					nAteLim += SRC->RC_VALOR
				ElseIf SRC->RC_PD$ aCodFol[108,1] + '*' + aCodFol[17,1]
					nBaseFgts += SRC->RC_VALOR
				ElseIf SRC->RC_PD$ aCodFol[109,1] + '*' + aCodFol[18,1]
					nFgts += SRC->RC_VALOR
				ElseIf SRC->RC_PD == aCodFol[15,1]
					nBaseIr += SRC->RC_VALOR
				ElseIf SRC->RC_PD == aCodFol[16,1]
					nBaseIrFe += SRC->RC_VALOR
				ElseIf SRC->RC_PD == aCodFol[47,1]
					nLiquido := SRC->RC_VALOR
				EndIf
				dbSelectArea("SRC")
				dbSkip()
			Enddo
		EndIf
	ElseIf nEsc == 3
		dbSelectArea("SRC")
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			Do While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRC->RC_FILIAL + SRC->RC_MAT
				If !Eval(cAcessaSRC)
					dbSkip()
					Loop
				EndIf
				If SRC->RC_PD == aCodFol[22,1]
					fSomaPd("P",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
					TOTVENC += SRC->RC_VALOR
				ElseIf SRC->RC_PD == aCodFol[172,1]
					fSomaPd("D",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
					TOTDESC += SRC->RC_VALOR
				ElseIf SRC->RC_PD == aCodFol[108,1] .Or. SRC->RC_PD == aCodFol[109,1] .Or. SRC->RC_PD == aCodFol[173,1]
					fSomaPd("B",SRC->RC_PD,SRC->RC_HORAS,SRC->RC_VALOR)
				EndIf
				If SRC->RC_PD == aCodFol[108,1]
					nBaseFgts := SRC->RC_VALOR
				ElseIf SRC->RC_PD == aCodFol[109,1]
					nFgts     := SRC->RC_VALOR
				EndIf
				dbSelectArea("SRC")
				dbSkip()
			Enddo
			nLiquido := TOTVENC - TOTDESC
		EndIf
	ElseIf nEsc == 4
		dbSelectArea("SRI")
		dbSetOrder(2)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT)
			Do While !Eof() .And. SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT == SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT
				If !Eval(cAcessaSRI)
					dbSkip()
					Loop
				EndIf
				If PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPd("P",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
					TOTVENC = TOTVENC + SRI->RI_VALOR
				ElseIf PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"
					fSomaPd("D",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
					TOTDESC = TOTDESC + SRI->RI_VALOR
				ElseIf PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "3"
					fSomaPd("B",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
				EndIf
				If SRI->RI_PD == aCodFol[19,1]
					nAteLim += SRI->RI_VALOR
				ElseIf SRI->RI_PD$ aCodFol[108,1]
					nBaseFgts += SRI->RI_VALOR
				ElseIf SRI->RI_PD$ aCodFol[109,1]
					nFgts += SRI->RI_VALOR
				ElseIf SRI->RI_PD == aCodFol[27,1]
					nBaseIr += SRI->RI_VALOR
				ElseIf SRI->RI_PD == aCodFol[21,1]
					nLiquido := SRI->RI_VALOR
				EndIf
				dbSkip()
			Enddo
		EndIf
	ElseIf nEsc == 5
		dbSelectArea("SR1")
		dbSetOrder(1)
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			Do While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
				If !Eval(cAcessaSR1)
					dbSkip()
					Loop
				EndIf
				If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPd("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTVENC = TOTVENC + SR1->R1_VALOR
				ElseIf PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"
					fSomaPd("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTDESC = TOTDESC + SR1->R1_VALOR
				ElseIf PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "3"
					fSomaPd("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
				EndIf
				dbskip()
			Enddo
			nLiquido := TOTVENC - TOTDESC
		EndIf
	ElseIf nEsc == 6		
		dDtFerIni := CtoD("  /  /  ")
		dDtBusFer := CtoD("  /  /  ")
		//Busca Data Inicial e Data de Pagamento de F้rias
		fCheckFer('INI') // Busca RH_DATAINI
		If (dDtFerIni >= dDataDe .And. dDtFerIni <= dDataAte)
			If SRR->(dbSeek( xFilial("SRR",SRA->RA_FILIAL) + SRA->RA_MAT + "F" + DtoS(dDtBusFer),.T.))
				Do While SRR->( !Eof() ) .And. (SRA->RA_FIlIAL + SRA->RA_MAT + "F" + DtoS(dDtBusFer) == SRR->RR_FILIAL + SRR->RR_MAT + SRR->RR_TIPO3 + DtoS(SRR->RR_DATA))	
					If !Eval(cAcessaSRR)
						dbSkip()
						Loop
					EndIf
					If SRR->RR_PD # aCodFol[102,1]
						If PosSrv( SRR->RR_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
							fSomaPd("P",SRR->RR_PD,SRR->RR_HORAS,SRR->RR_VALOR)
							TOTVENC := TOTVENC + SRR->RR_VALOR
						ElseIf PosSrv( SRR->RR_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"
							fSomaPd("D",SRR->RR_PD,SRR->RR_HORAS,SRR->RR_VALOR)
							TOTDESC := TOTDESC + SRR->RR_VALOR
						EndIf
					EndIf
					If SRR->RR_PD == aCodFol[013,1]
						nAteLim += SRR->RR_VALOR
					ElseIf SRR->RR_PD == aCodFol[016,1]
						nBaseIr += SRR->RR_VALOR
					ElseIf SRR->RR_PD == aCodFol[102,1]
						nLiquido := SRR->RR_VALOR
					EndIf
					SRR->( dbSkip() )
				Enddo
			EndIf
		EndIf
	EndIf
	dbSelectArea("SRA")
	If TOTVENC == 0 .And. TOTDESC == 0
		SRA->( dbSkip() )
		Loop
	EndIf
	nSequenc++
	cDataBas	:= DtoC(SRH->RH_DATABAS)
	cDBaseAt	:= DtoC(SRH->RH_DBASEAT)
	cDFerias	:= Str(SRH->RH_DFERIAS)
	cDAbonPe	:= Str(SRH->RH_DABONPE)
	//Hแ dados a ser informado
	If lData
		//Verifica Header
		If !lHeader
			// Monta Header de Arquivo - Registro Tipo "0"
			fMonta0()
			// Monta Header de Lote - Registro Tipo "1"
			fMonta1()
			lHeader := .T.
		EndIf
		// Monta Detalhe - Registro Tipo "3" Segmento "A"
		fMonta3A()
		// Monta Detalhe - Registro Tipo "3" Segmento "D"
		fMonta3D()
		// Monta Detalhe - Registro Tipo "3" Segmento "E" --> Proventos
		fMonta3E( aProve, "1" )
		// Monta Detalhe - Registro Tipo "3" Segmento "E" --> Descontos
		fMonta3E( aDesco, "2" )
		// Monta Detalhe - Registro Tipo "3" Segmento "E" --> Bases
		//fMonta3E( aBases, "3" )
		// Monta Detalhe - Registro Tipo "3" Segmento "F"
		fMonta3F(cDataBas,cDBaseAt,cDFerias,cDAbonPe)
		//Verifica Liquidos
		If nLiquido == 0
			nLiquido := TOTVENC-TOTDESC
		EndIf
		If nEsc <> 6
			// Verifica Iconsistencias de Liquidos
			If nLiquido != (TotVenc - TotDesc)
				lLiq := .F.
			EndIf
		EndIf
	EndIf
	dbSelectArea("SRA")
	dbSkip()
	TOTDESC := TOTVENC := 0
EndDo

//Ha Dados a Serem Gerados
If lData
	// Monta Trailler de Lote - Registro Tipo "5"
	fMonta5()
	// Monta Trailler de Arquivo - Registro Tipo "9"
	fMonta9()
EndIf

// Termino do relatorio
dbSelectArea("SRC")
dbSetOrder(1)          // Retorno a ordem 1
dbSelectArea("SRI")
dbSetOrder(1)          // Retorno a ordem 1
dbSelectArea("SRA")
SET FILTER TO

fClose( nHdl )
If !(Type("cNomeArq") == "U")
	fErase(cNomeArq + OrdBagExt())
EndIf

MS_FLUSH()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑณFun…o    ณfSomaPd   ณ Autor ณ R.H. - Mauro          ณ Data ณ 24.09.95 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Somar as Verbas no Array                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ fSomaPd(Tipo,Verba,Horas,Valor)                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fSomaPd(cTipo,cPd,nHoras,nValor)

Local Desc_paga

lData	:= .T.  //Hแ Dados a serem informados

Desc_paga := DescPd(cPd,SRA->RA_FILIAL)  // mostra como pagto

If cTipo # 'B'
	//--Array para Recibo Pre-Impresso
	nPos := Ascan(aLanca,{ |X| X[2] = cPd })
	If nPos == 0
		aAdd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor})
	Else
		aLanca[nPos,4] += nHoras
		aLanca[nPos,5] += nValor
	EndIf
EndIf

//--Array para o Recibo Pre-Impresso
If cTipo = 'P'
	cArray := "aProve"
ElseIf cTipo = 'D'
	cArray := "aDesco"
ElseIf cTipo = 'B'
	cArray := "aBases"
EndIf

nPos := Ascan(&cArray,{ |X| X[1] = cPd })
If nPos == 0
	aAdd(&cArray,{cPd + " " + Left(Desc_Paga,19),nHoras,nValor })
Else
	&cArray[nPos,2] += nHoras
	&cArray[nPos,3] += nValor
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณTransformaบAutor  ณMicrosiga           บ Data ณ  09/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Transforma as datas no formato DD/MM/AAAA()                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function Transforma(dData)

Return(StrZero(Day(dData),2) +"/"+ StrZero(Month(dData),2) +"/"+ Right(Str(Year(dData)),4))

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณfConvData บAutor  ณMicrosiga           บ Data ณ  09/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fConvData( dData, xTipo )

Local cRet := Space(08)

If xTipo == "DDMMAAAA"
	cRet := StrZero(Day(dData),2) + StrZero(Month(dData),2) + StrZero(Year(dData),4)
ElseIf xTipo == "MMAAAA"
	cRet := StrZero(Month(dData),2) + StrZero(Year(dData),4)
EndIf

Return cRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณfCheckFer บAutor  ณMicrosiga           บ Data ณ  09/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Checa a situa็ใo do Funcionario.                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fCheckFer( xTipo)

Local aOld := GetArea()
Local cRet := Replicate("0",08)

//Alterado em 15/10/2007 - Marcos Pereira - Posiciona no SRH utilizando a dDataDe como pesquisa
//If SRA->RA_SITFOLH $ "F*A" 
If SRA->RA_SITFOLH $ " *F*A" // SRP - 30/04/2008 - Incluido a situa็ใo "branco" normal. 
	SRH->( dbsetorder(2) )
  	SRH->(dbSeek( SRA->(RA_FILIAL + RA_MAT) + DtoS(dDataDe),.T. ))
	If SRH->(RH_FILIAL + RH_MAT) == SRA->(RA_FILIAL + RA_MAT) .And. SRH->RH_DATAINI <= dDataAte
		If xTipo == "INI"
			cRet := fConvData( SRH->RH_DATAINI, "DDMMAAAA" )
			dDtBusFer	:= SRH->RH_DTRECIB
			dDtFerIni   := SRH->RH_DATAINI
		ElseIf xTipo == "FIM"
			cRet := fConvData( SRH->RH_DATAFIM, "DDMMAAAA" )
		EndIf
	EndIf
	SRH->( dbsetorder(1) )
EndIf

RestArea( aOld )

Return cRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณfConvHora บAutor  ณMicrosiga           บ Data ณ  09/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fConvHora( cHora )

Local cRet := SubStr(cHora,1,2)+SubStr(cHora,4,2)+SubStr(cHora,7,2)

Return cRet

/*****************************************************************************
/                   INICIO DO LAY-OUT DO BANCO ITAU                          *
/*****************************************************************************

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณfMonta0   บAutor  ณMicrosiga           บ Data ณ  09/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Montagem do Header do Arquivo                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMonta0()
 
cLin := "341"                  	                        	// 001 a 003 Codigo do Banco
cLin += "0000"             	                            	// 004 a 007 Codigo do Lote
cLin += "0"            	                                	// 008 a 008 Tipo do Registro
cLin += Space(06)   	            	                    // 009 a 014 Brancos
cLin += "081"                          	                	// 015 a 017 Lay-Out do Arquivo
cLin += "2"									                // 018 a 018 Tipo Inscricao Empresa
cLin += SM0->M0_CGC                       	        		// 019 a 032 Cnpj Empresa
cLin += Space(20)                                  	    	// 033 a 052 Brancos
cLin += PadL(Alltrim(_cAgencia),5,"0")               		// 053 a 057 Agencia Debitada
cLin += Space(01)                                      		// 058 a 058 Brancos
cLin += PadL(Substr(Alltrim(_cConta),1,5),12,"0")   		// 059 a 070 Conta Corrente Debitada
cLin += Space(01)                                      		// 071 a 071 Brancos
cLin += Right(Alltrim(_cConta),1)    						// 072 a 072 Digito Conta Corrente
cLin += SUBS(SM0->M0_NOMECOM,1,30)               			// 073 a 102 Nome da Empresa
cLin += "BANCO ITAU S/A                "               		// 103 a 132 Nome do Banco
cLin += Space(10)                                  	    	// 133 a 142 Brancos
cLin += "1"                                            		// 143 a 143 Codigo Remessa
cLin += fConvData( dDataBase, "DDMMAAAA" )                	// 144 a 151 Data Geracao Arquivo
cLin += fConvHora( Time() )                             	// 152 a 157 Hora Geracao Arquivo
cLin += "000000000"                                    		// 158 a 166 Zeros
cLin += "00000"                                        		// 167 a 171 Densidade de Gravacao
cLin += Space(69)                                  	    	// 172 a 240 Brancos
cLin += cEol  

fGravaTxt()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ fMonta1  บAutor  ณMicrosiga           บ Data ณ  09/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Montagem do Header do Lote                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMonta1()

cLin := "341"                  	                        	// 001 a 003 Codigo do Banco
cLin += "0001"             	                            	// 004 a 007 Codigo do Lote
cLin += "1"            	                                	// 008 a 008 Tipo do Registro
cLin += "C"                        	                    	// 009 a 009 Tipo Operacao "C=Credito"
cLin += "30"        	            	                    // 010 a 011 Tipo Pagamento "30=Salarios"
cLin += "01"        	            	                    // 012 a 013 Forma Pagamento "01=Credito CC"
cLin += "040"       	            	                    // 014 a 016 Lay-Out do Lote
cLin += Space(01)                      	                	// 017 a 017 Brancos
cLin += "2"                                	            	// 018 a 018 Tipo Inscricao Empresa
cLin += SM0->M0_CGC                       	        		// 019 a 032 Cnpj Empresa
cLin += Space(20)                                  	    	// 033 a 052 Brancos
cLin += PadL(Alltrim(_cAgencia),5,"0")						// 053 a 057 Agencia Debitada --- "08712"
cLin += Space(01)                                      		// 058 a 058 Brancos
cLin += PadL(Substr(Alltrim(_cConta),1,5),12,"0")    		// 059 a 070 Conta Corrente Debitada
cLin += Space(01)                                      		// 071 a 071 Brancos
cLin += Right(Alltrim(_cConta),1)                    		// 072 a 072 Digito Conta Corrente
cLin += Subs(SM0->M0_NOMECOM,1,30)               			// 073 a 102 Nome da Empresa
cLin += cFinPgt + "PAGAMENTO DE SALARIOS       "        	// 103 a 132 Finalidades do Lote
cLin += Space(10)                                  	    	// 133 a 142 Historico da CC Debitada
cLin += PadR(Iif(Empty(SM0->M0_ENDENT),SM0->M0_ENDCOB,SM0->M0_ENDENT),30)		// 143 a 172 Endereco da Empresa
cLin += "00000"                                        		// 173 a 177 Numero do Endereco
cLin += Space(15)		                              		// 178 a 192 Compl do Endereco
cLin += PadR(Iif(Empty(SM0->M0_CIDENT),SM0->M0_CIDCOB,SM0->M0_CIDENT),20)		// 193 a 212 Cidade do Endereco
cLin += PadR(Iif(Empty(SM0->M0_CEPENT),SM0->M0_CEPCOB,SM0->M0_CEPENT),8,"0")	// 213 a 220 Cep do Endereco
cLin += PadR(Iif(Empty(SM0->M0_ESTENT),SM0->M0_ESTCOB,SM0->M0_ESTENT),2)		// 221 a 222 Estado do Endereco
cLin += Space(08)                                  	    	// 223 a 230 Brancos
cLin += Space(10)                                  	    	// 231 a 240 Ocorrencias de Retorno
cLin += cEol

fGravaTxt()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณfMonta3A  บAutor  ณMicrosiga           บ Data ณ  09/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Montagem do Detalhe A                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMonta3A()

cLin := "341"                  	                        	// 001 a 003 Codigo do Banco
cLin += "0001"             	                            	// 004 a 007 Codigo do Lote
cLin += "3"            	                                	// 008 a 008 Tipo do Registro
cLin += StrZero(nSequenc,5)           	                    // 009 a 013 Sequencial de Registros
cLin += "A"        	            	                    	// 014 a 014 Segmento "A"
cLin += "000"       	            	                    // 015 a 017 Tipo Movimento
cLin += "000"       	            	                    // 018 a 020 Zeros
cLin += Left(SRA->RA_BCDEPSA,3)                         	// 021 a 023 Banco Favorecido
cLin += "0"						                         	// 024 a 024 Zero						\
cLin += Subs(SRA->RA_BCDEPSA,4,4)	                        // 025 a 028 Agencia                     \
cLin += Space(01)		                        			// 029 a 029 Branco                       \
cLin += StrZero(0,7)					                    // 030 a 036 Zeros                         |---------->		(Nota 11 - Pag. 43)
cLin += Left(StrZero(Val(SRA->RA_CTDEPSA),5),5)          	// 037 a 041 Conta Creditada              /
cLin += Space(01)                       					// 042 a 042 Branco                      /
cLin += Right(Alltrim(SRA->RA_CTDEPSA),1)         			// 043 a 043 Digito da Conta Creditada	/
cLin += Left(SRA->RA_NOME,30)                      			// 044 a 073 Nome do Favorecido
cLin += Space(20)					                        // 074 a 093 Numero do Documento atribuido pela Empresa
cLin += fConvData( dDataPagto, "DDMMAAAA" )               	// 094 a 101 Data do Pagamento
cLin += "REA"                                	            // 102 a 104 Tipo Moeda
cLin += Replicate("0",15)        	                        // 105 a 119 Zeros
cLin += StrZero((nLiquido*100),15,0)                        // 120 a 134 Valor do Pagamento
cLin += Space(15)                       					// 135 a 149 Nosso Numero
cLin += Space(05)                      	                	// 150 a 154 Brancos
cLin += "00000000"                     	                	// 155 a 162 Data Efetivacao Pagto
cLin += Replicate("0",15)        	                        // 163 a 177 Valor Efetivo Pagamento
cLin += Space(18)                      	                	// 178 a 195 Finalidade Detalhe
cLin += Space(02)                      	                	// 196 a 197 Brancos
cLin += Replicate("0",06)        	                        // 198 a 203 Numero Documento
cLin += StrZero(Val(SRA->RA_CIC),14)                        // 204 a 217 Numero Inscricao Favorecido
cLin += Space(02)                      	                	// 218 a 219 Brancos
cLin += "00010"		                             			// 220 a 224 Finalidade da TED
cLin += Space(05)                      	                	// 225 a 229 Brancos
cLin += "0"                                        			// 230 a 230 Aviso ao Favorecido
cLin += Space(10)                                  	    	// 231 a 240 Ocorrencias de Retorno
cLin += cEol

aTotLote[1] ++
aTotLote[2] += nLiquido

fGravaTxt()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณfMonta3D  บAutor  ณMicrosiga           บ Data ณ  09/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Montagem do Detalhe D                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMonta3D()

Local aArea	:= GetArea()

cLin := "341"                  	                        	// 001 a 003 Codigo do Banco
cLin += "0001"             	                            	// 004 a 007 Codigo do Lote
cLin += "3"            	                                	// 008 a 008 Tipo do Registro
cLin += StrZero(nSequenc,5)           	                    // 009 a 013 Sequencial de Registros
cLin += "D"        	            	                    	// 014 a 014 Segmento "D"
cLin += Space(03)   	            	                    // 015 a 017 Brancos
cLin += fConvData( dDataRef, "MMAAAA" )                		// 018 a 023 Mes/Ano Referencia
cLin += Left(SI3->I3_DESC+Space(15),15)                    	// 024 a 038 Centro de Custo
cLin += Left(SRA->RA_MAT+Space(15),15)                    	// 039 a 053 Matricula
cLin += Left(SRJ->RJ_DESC+Space(30),30)                    	// 054 a 083 Funcao
cLin += fCheckFer( "INI" )                               	// 084 a 091 Periodo Ferias De
cLin += fCheckFer( "FIM" )                               	// 092 a 099 Periodo Ferias Ate
cLin += StrZero(Val(SRA->RA_DEPIR),2)                     	// 100 a 101 Dependentes p/ IR
cLin += StrZero(Val(SRA->RA_DEPSF),2)                     	// 102 a 103 Dependentes p/ SF
cLin += StrZero(Int(SRA->RA_HRSEMAN),2)                     // 104 a 105 Horas Semanais
cLin += StrZero((nAteLim*100),15,0)                       	// 106 a 120 Salario de Contribuicao
cLin += StrZero((nFgts*100),15,0)                         	// 121 a 135 FGTS
cLin += StrZero((TOTVENC*100),15,0)                       	// 136 a 150 Total dos Proventos
cLin += StrZero((TOTDESC*100),15,0)                       	// 151 a 165 Total dos Descontos
cLin += PadL((TOTVENC-TOTDESC)*100,15,"0")             		// 166 a 180 Liquido a Pagar --- StrZero(((TOTVENC-TOTDESC)*100),15,0)
cLin += StrZero((SRA->RA_SALARIO*100),15,0)               	// 181 a 195 Salario Base
cLin += StrZero((nBaseIr*100),15,0)                       	// 196 a 210 Base do IRRF
cLin += StrZero((nBaseFgts*100),15,0)                     	// 211 a 225 Base do IRRF
cLin += "00"						                        // 226 a 227 Prazo p/ Disponibilizar Holerite
cLin += Space(03)		                        			// 228 a 230 Brancos
cLin += Space(10)                                  	    	// 231 a 240 Ocorrencias de Retorno
cLin += cEol

aTotLote[1]++

fGravaTxt()

RestArea( aArea )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณfMonta3E  บAutor  ณMicrosiga           บ Data ณ  09/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Montagem do Detalhe E                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMonta3E( aTemp, xTipo )

Local i, nLen

// Calcula Quantidade de Proventos
nLen := Len(aTemp)
If nLen == 0
	Return
EndIf
// Incrementa Contador com Multiplos de 4
Do While .T.
	If nLen % 4 == 0
		Exit
	EndIf
	
	nLen++
EndDo
// Processa Array
For i := 1 To nLen
	If i % 4 == 1
		cLin := "341"                  	                        	// 001 a 003 Codigo do Banco
		cLin += "0001"             	                            	// 004 a 007 Codigo do Lote
		cLin += "3"            	                                	// 008 a 008 Tipo do Registro
		cLin += StrZero(nSequenc,5)        	                    	// 009 a 013 Sequencial de Registros
		cLin += "E"        	            	                    	// 014 a 014 Segmento "E"
		cLin += Space(03)   	           	                    	// 015 a 017 Brancos
		cLin += xTipo                                          		// 018 a 018 Tipo do Movimento
	EndIf
	If i <= Len(aTemp)
		//      cLin += Left(aTemp[i,1]+Space(30),30)               // 019 a 048 Salario de Contribuicao
		cLin += Left(aTemp[i,1]+" " + if(aTemp[i,2]>0,Transform(aTemp[i,2],"@E 999.99"),space(6))+Space(30),30) // 019 a 048 Salario de Contribuicao
		cLin += Space(05)                                 	    	// 049 a 053 Brancos
		cLin += StrZero((aTemp[i,3]*100),15,0)                 		// 054 a 068 Salario de Contribuicao
	Else
		cLin += Space(30)					                       	// 019 a 048 Salario de Contribuicao
		cLin += Space(05)                          	       	    	// 049 a 053 Brancos
		cLin += StrZero(0,15)					                   	// 054 a 068 Salario de Contribuicao
	EndIf
	If i % 4 == 0
		cLin += Space(12)                                  	    	// 219 a 230 Brancos
		cLin += Space(10)                                  	    	// 231 a 240 Ocorrencias de Retorno
		cLin += cEol		
		aTotLote[1]++
		fGravaTxt()
	EndIf
Next

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณfMonta3F  บAutor  ณMicrosiga           บ Data ณ  09/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Montagem do Detalhe F                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMonta3F(cDataBas,cDBaseAt,cDFerias,cDAbonPe)

cLin := "341"                  	                        	// 001 a 003 Codigo do Banco
cLin += "0001"             	                            	// 004 a 007 Codigo do Lote
cLin += "3"            	                                	// 008 a 008 Tipo do Registro
cLin += StrZero(nSequenc,5)           	                    // 009 a 013 Sequencial de Registros
cLin += "F"        	            	                    	// 014 a 014 Segmento "F"
cLin += Space(03)   	            	                    // 015 a 017 Brancos

If nEsc == 6 //Ferias	
	DESC_MSG1 := "Periodo Aquisitivo: " +  cDataBas + " a " + cDBaseAt
	//Quantidade de dias
	DESC_MSG2 := "Dias de Ferias: " + cDFerias
	//Abono Pecuniario
	DESC_MSG3 := "Dias de Abono Pecuniario: " + cDAbonPe
EndIf

cLin += Left(DESC_MSG1+Space(48),48) 	                    // 018 a 065 Mensagem 1
cLin += Left(DESC_MSG2+Space(48),48) 	                    // 066 a 113 Mensagem 2
cLin += Left(DESC_MSG3+Space(48),48) 	                    // 114 a 161 Mensagem 3
cLin += Space(69)                                  	    	// 162 a 230 Brancos
cLin += Space(10)                                  	    	// 231 a 240 Ocorrencias de Retorno
cLin += cEol

aTotLote[1]++

fGravaTxt()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณfMonta5   บAutor  ณMicrosiga           บ Data ณ  09/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Montagem do Trailer do Lote                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMonta5()

cLin := "341"                  	                        	// 001 a 003 Codigo do Banco
cLin += "0001"             	                            	// 004 a 007 Codigo do Lote
cLin += "5"            	                                	// 008 a 008 Tipo do Registro "5"
cLin += Space(09)                                  	    	// 009 a 017 Brancos
cLin += StrZero(aTotLote[1]+2,6)        	                // 018 a 023 Total de Registros do Lote
cLin += StrZero((aTotLote[2]*100),18,0)                   	// 024 a 041 Valor Total do Lote
cLin += StrZero(0,18)               	                    // 042 a 059 Zeros
cLin += Space(171)   	            	                    // 060 a 230 Brancos
cLin += Space(10)                                  	    	// 231 a 240 Ocorrencias de Retorno
cLin += cEol

fGravaTxt()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณfMonta9   บAutor  ณMicrosiga           บ Data ณ  09/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Montagem do Trailer do Arquivo                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMonta9()

cLin := "341"                  	                        	// 001 a 003 Codigo do Banco
cLin += "9999"             	                            	// 004 a 007 Codigo do Lote
cLin += "9"            	                                	// 008 a 008 Tipo do Registro "9"
cLin += Space(09)                                  	    	// 009 a 017 Brancos
cLin += "000001"                      	                    // 018 a 023 Total de Registros do Lote
cLin += StrZero(aTotLote[1]+4,6)        	                // 024 a 029 Total de Registros do Lote
cLin += Space(211)   	            	                    // 030 a 240 Brancos
cLin += cEol

fGravaTxt()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  fGravaTxt  บAutor  ณMicrosiga           บ Data ณ  09/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida a gravacao das informacoes no arquivo               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fGravaTxt()

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบFuncao    ณfRecibos() บAutor  ณTania Bronzeri      บ Data ณ 31/05/2007  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria fOpcoes para tipos de recibos.                          บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico Larruดs				                   	       บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function fRecibos()

Local cTitulo	:=	""
Local MvParDef	:=	""
Local l1Elem 	:= .T.
Local MvPar		:= ""
Local oWnd

Private aResul	:= {}

oWnd 	:= GetWndDefault()
MvPar	:= &(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
mvRet	:= Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno

cTitulo := "Tipos de Recibos"
aResul  := {"Adiantamento","Folha","1a Parcela","2a Parcela","Extra","Ferias"}

MvParDef :=	"123456"

f_Opcoes(@MvPar,cTitulo,aResul,MvParDef,12,49,l1Elem,,1)		// Chama funcao f_Opcoes
&MvRet := mvpar 					   	// Devolve Resultado

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบFuno    ณfAsrPerg  บ Autor ณ AP5 IDE            บ Data ณ  27/10/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fAsrPerg(cPerg)

Local i
Local j

Local aHelp		:= {}
Local aHelpE	:= {}
Local aHelpI	:= {}
Local cHelp		:= ""

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PadR(cPerg,10)
aRegs := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{ cPerg,'01','Data de Referencia			','Data de Referencia		','Data de Referencia		','mv_ch1','D',08,0,0,'G','NaoVazio'   ,'mv_par01',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })

aHelp := { "Informe o tipo de recibo que deseja ", "emitir. Apenas um tipo de recibo ", "podera ser selecionado." }
aHelpE:= { "Informe o tipo de recibo que deseja ", "emitir. Apenas um tipo de recibo ", "podera ser selecionado." }
aHelpI:= { "Informe o tipo de recibo que deseja ", "emitir. Apenas um tipo de recibo ", "podera ser selecionado." }
cHelp := ".GDLQIT02."

aAdd(aRegs,{ cPerg,'02','Emitir Recibos				','Emitir Recibos           ','Emitir Recibos           ','MV_CH2','C',06,0,0,'G','U_fRecibos()','MV_PAR02',''                ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','','',aHelp  ,aHelpI   ,aHelpE  ,cHelp})
//aAdd(aRegs,{ cPerg,'03','Numero da Semana         ','Numero da Semana         ','Numero da Semana         ','mv_ch3','C',02,0,0,'G',''           ,'mv_par03',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'03','Filial De                  ','Filial De                ','Filial De                ','mv_ch3','C',02,0,0,'G',''           ,'mv_par03',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'04','Filial Ate                 ','Filial Ate               ','Filial Ate               ','mv_ch4','C',02,0,0,'G','NaoVazio'   ,'mv_par04',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'05','Centro Custo De            ','Centro Custo De          ','Centro Custo De          ','mv_ch5','C',09,0,0,'G',''           ,'mv_par05',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'CTT','' })
aAdd(aRegs,{ cPerg,'06','Centro Custo Ate           ','Centro Custo Ate         ','Centro Custo Ate         ','mv_ch6','C',09,0,0,'G','NaoVazio'   ,'mv_par06',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'CTT','' })
aAdd(aRegs,{ cPerg,'07','Matricula De               ','Matricula De             ','Matricula De             ','mv_ch7','C',06,0,0,'G',''           ,'mv_par07',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'08','Matricula Ate              ','Matricula Ate            ','Matricula Ate            ','mv_ch8','C',06,0,0,'G','NaoVazio'   ,'mv_par08',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'09','Mensagem 1                 ','Mensagem 1               ','Mensagem 1               ','mv_ch9','C',01,0,0,'G',''           ,'mv_par09',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'10','Mensagem 2                 ','Mensagem 2               ','Mensagem 2               ','mv_chA','C',01,0,0,'G',''           ,'mv_par10',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'11','Mensagem 3                 ','Mensagem 3               ','Mensagem 3               ','mv_chB','C',01,0,0,'G',''           ,'mv_par11',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'12','Situacoes                  ','Situacoes                ','Situacoes                ','mv_chC','C',05,0,0,'G','fSituacao'  ,'mv_par12',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'13','Categorias                 ','Categorias               ','Categorias               ','mv_chD','C',12,0,0,'G','fCategoria' ,'mv_par13',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'14','Arquivo de Saida           ','Arquivo de Saida         ','Arquivo de Saida         ','mv_chE','C',30,0,0,'G','NaoVazio'   ,'mv_par14',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'15','Data Para Pagamento        ','Data Para Pagamento      ','Data Para Pagamento      ','mv_chF','D',08,0,0,'G','NaoVazio'   ,'mv_par15',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'16','Banco             			','Banco			        ','Banco			        ','mv_chG','C',03,0,0,'G',''           ,'mv_par16',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'SA6','' })
aAdd(aRegs,{ cPerg,'17','Agencia            		','Agencia		            ','Agencia			        ','mv_chH','C',05,0,0,'G','NaoVazio'   ,'mv_par17',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'18','Conta Corrente            	','Conta Corrente           ','Conta Corrente           ','mv_chI','C',12,0,0,'G',''           ,'mv_par18',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'19','Data de Ferias De          ','Data de Ferias De        ','Data de Ferias De        ','mv_chK','D',08,0,0,'G',''           ,'mv_par19',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'20','Data de Ferias Ate         ','Data de Ferias Ate       ','Data de Ferias Ate       ','mv_chL','D',08,0,0,'G','NaoVazio'   ,'mv_par20',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''        ,'','','' ,'   ','' })

//ValidPerg(aRegs,cPerg)

For i := 1 to Len(aRegs)
	If !dbSeek(cPerg + aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 To Len(aRegs[i])
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	EndIf
Next

dbSkip()
dbSelectArea(_sAlias)

Return

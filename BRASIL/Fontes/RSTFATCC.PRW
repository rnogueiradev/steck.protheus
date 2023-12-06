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

User Function RSTFATCC()
	
	Local lContinua      := .T.
	Private cString      := "PPM"
	Private aOrd         := {}
	Private cDesc1       := "Este programa tem como objetivo imprimir informacoes do" //
	Private cDesc2       := "EAA" //
	Private cPict        := ""
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "RSTFATCC" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := {"Zebrado",1,"Administracao",2,2,1,"",1}  //###
	Private nLastKey     := 0
	Private cPerg        := PadR ("RFAT66", Len (SX1->X1_GRUPO))
	Private titulo       := "" //
	Private nLin         := 06
	Private Cabec1       := ""
	Private Cabec2       := ""
	Private cbtxt        := "Regsitro(s) lido(s)" //
	Private cbcont       := 0
	Private CONTFL       := 01
	Private m_pag        := 01
	Private lRet         := .T.
	Private imprime      := .T.
	Private wnrel        := "RSTFAT66" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private aCombo			:= {}
	Private __aRet := {}
	Private aParamBox := {}
	Private _cAno		:= Space(4)
	
	//AjustaSX1()
	
	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,Nil,.F.,aOrd,.F.,Tamanho,,.T.)
	
	//Pergunte(cPerg,.F.)
		
	aCombo := {"TODOS","adadiel.soares","altamir.constante","anderson.silva","andre.bugatti","clayton.braga","camile.paula","carla.lodetti","daniel.santos","denis.bueno","edmar.rodrigues","eirivaldo.julio","fernanda.bereki","fabio.lessa","filipe.nascimento","gilberto.santos","giovani.zago","janaina.paixao","juliana.queiroz","kleber.braga","lucas.machado","marines.santos","marlon.repres","michele.florencio","pamela.ambrosio","priscilla.silva","reginaldo.silva","rita.silva","sebastiana.coelho","suely.guinati","valmir.melo","valter.cardoso","vanderlei.souto","vinicius.gibrail","viviane.dias","wilson.cardoso"}

	AADD(aParamBox,{1,"Informe o Ano" ,_cAno   ,'@!','.T.',,'.T.',05,.F.})
	AADD(aParamBox,{2,"Selecione o avaliador",,aCombo,50,"",.T.})
 
	If !ParamBox(aParamBox,"Tipo de Análise: ",@__aRet,,,.T.,,500)
		Return
	Endif
	
	If Empty(__aRet[1])
		MsgAlert("Informe o Ano que deseja imprimir o relatorio.","Atenção!")
		lContinua := .F.
	EndIf

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
		titulo       := "Relatório EAA - " + __aRet[1]
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
	
	DbSelectArea("PPM")
	PPM->(DbSetOrder(1))
	PPM->(DbGoTop())
	//PPM->(DbSeek(xFilial("CB7")+MV_PAR01,.T.)) // Posiciona no 1o.reg. satisfatorio
	SetRegua(RecCount()-Recno())
	
	While !PPM->(Eof())
		
		//"01-TODOS","02-VENDAS INTERNAS","03-VENDAS EXTERNAS"
		If AllTrim(__aRet[2]) <> Alltrim(PPM->PPM_04) .And. AllTrim(__aRet[2]) <> "TODOS"
			PPM->(DbSkip())
			Loop
		Endif
		
		IF Alltrim(PPM->PPM_ANO) <> Alltrim(__aRet[1])
			PPM->(DbSkip())
			Loop
		EndIF
		/*
		If CB7->CB7_DTEMIS < MV_PAR03 .or. CB7->CB7_DTEMIS > MV_PAR04 // Nao considera as ordens que nao tiver dentro do range de datas
			CB7->(DbSkip())
			Loop
		Endif
		*/

		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

		IncRegua("Imprimindo")  //
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***" //
			//		Exit
		Endif
		Imprime()
		PPM->(DbSkip())
	Enddo
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
	
	Local _cTexto07  := PPM->PPM_07
	Local _cTexto08  := PPM->PPM_08

	Local _nlinhas07 := mlcount(_cTexto07,200)
	Local _nlinhas08 := mlcount(_cTexto08,200)

	Local _nCount := 0
	
	@ 006, 000 PSay "Avaliado: "+PPM->PPM_01
	@ 007, 000 Psay "Departamento: "+PPM->PPM_03
	@ 008, 000 Psay "Avaliador: "+PPM->PPM_04
	@ 009, 000 Psay "Data de admissão: "+DTOC(PPM->PPM_05)
	@ 010, 000 Psay "Data da avaliação: "+DTOC(PPM->PPM_06)
	@ 011, 000 Psay __PrtThinLine()
	
	nLin := 12
	//nLin++
	
	@ nLin, 000 PSay 'O Cliente em Primeiro Lugar'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_09,"PPM->PPM_09")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay 'Ser Disruptivo'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_10,"PPM->PPM_10")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay 'Abraçar o Diferente.'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_11,"PPM->PPM_11")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay 'Aprender Todos os Dias.'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_12,"PPM->PPM_12")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	@ nLin, 000 PSay 'Ser Dono do Negócio'
	nLin++
	@ nLin, 000 Psay RESPOSTA(PPM->PPM_13,"PPM->PPM_13")
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++

//	@ nLin,000 PSay __PrtThinLine()
	//nLin++
	
		
	nLin++
	@ nLin,000 PSay __PrtThinLine()
	nLin++
 /*	@ nLin, 000 PSay "Levantamento de necessidade de treinamento técnico e/ou operacional "
	nLin++
	If ! Empty(Alltrim(PPM->PPM_CURSO1))
		@ nLin, 000 Psay PPM->PPM_CURSO1
		nLin++
	EndIf

	If ! Empty(Alltrim(PPM->PPM_CURSO2))
		@ nLin, 000 Psay PPM->PPM_CURSO2
		nLin++
	EndIf

	If ! Empty(Alltrim(PPM->PPM_CURSO3))
		@ nLin, 000 Psay PPM->PPM_CURSO3
		nLin++
	EndIf

	If ! Empty(Alltrim(PPM->PPM_CURSO4))
		@ nLin, 000 Psay PPM->PPM_CURSO4
		nLin++
	EndIf

	If ! Empty(Alltrim(PPM->PPM_CURSO5))
		@ nLin, 000 Psay PPM->PPM_CURSO5
		nLin++
	EndIf

	@ nLin,000 PSay __PrtThinLine()
	*/  nLin++

	@ nLin, 000 PSay "Comentário funcionário "
	nLin++
	For _nCount := 1 to _nlinhas07
		@ nLin, 000 PSay memoline(_cTexto07,200,_nCount)
		nLin++
	Next _nCount
	
	@ nLin,000 PSay __PrtThinLine()
	nLin++

	//@ nLin, 000 Psay PPM->PPM_07
	//nLin++

	@ nLin, 000 PSay "Comentário avaliador "
	nLin++
	
	For _nCount := 1 to _nlinhas08
		@ nLin, 000 PSay memoline(_cTexto08,200,_nCount)
		nLin++
	Next _nCount
	
	@ nLin,000 PSay __PrtThinLine()
	nLin++
	
	//Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	/*
	If nLin > 50
		//imprime o rodape
		nLin++
		@ nLin,000 PSay __PrtThinLine()
		
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 06
		//@ nLin, 000 PSay "Armazem  Endereco         Produto          Descricao                       Composicao                          Quantidade  Lote        Data Validade  Observacao"
		@ nLin, 000 PSay "Teste  "
		nLin++
		@ nLin, 000 PSay __PrtThinLine()
		nLin++
		
	Endif
	*/
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
Criacao e apresentacao das perguntas
*/
Static Function ValidPerg()
	Local _sAlias := GetArea()
	Local _aRegs  := {}
	Local i:= 0
	Local j := 0
	cPerg         := PADR(cPerg,10)
	AADD(_aRegs,{cPerg,"01","Informe o Ano ?  ","","","mv_ch1","C",04,0,0,"G"," ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(_aRegs,{_cPerg,"02","Data Final ?    ","","","mv_ch2","D",08,0,0,"G"," ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	for i := 1 to len(_aRegs)
		If !SX1->(dbSeek(cPerg+_aRegs[i,2]))
			RecLock("SX1",.T.)
			for j := 1 to FCount()
				If j <= Len(_aRegs[i])
					FieldPut(j,_aRegs[i,j])
				Else
					Exit
				EndIf
			next
			MsUnlock()
		EndIf
	next
	RestArea(_sAlias)
return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1³ Autor ³                       ³ Data ³ 26/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINR190                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
	
	Local _aArea  := GetArea()
	Local _Nx     := 0
	Local _aRegs  := {}
	Local _cOrdem := 1
	
	cPerg := PADR(cPerg,10)  //CORRIGIDO DIA 11/06 - EUGENIO
	AAdd(_aRegs,{OemToansi("Ordem Separacao de          ?"),OemToansi("Ordem Separacao de          ?"),OemToansi("Ordem Separacao de          ?"),"mv_ch1","C", 6,0,0,"G","","mv_par01","","","","","","","","","CB7",""})
	AAdd(_aRegs,{OemToansi("Ordem Separacao ate         ?"),OemToansi("Ordem Separacao ate         ?"),OemToansi("Ordem Separacao ate         ?"),"mv_ch2","C", 6,0,0,"G","","mv_par02","","","",REPLICATE("Z",4),"","","","","CB7",""})
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	For _Nx:=1 to Len(_aRegs)
		_cOrdem := StrZero(_Nx,2)/* Removido - 12/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
		If !MsSeek(cPerg+_cOrdem)
			RecLock("SX1",.T.)
			SX1->X1_GRUPO		:= cPerg
			SX1->X1_ORDEM		:= _cOrdem
			SX1->X1_PERGUNTE	:= _aRegs[_Nx][01]
			SX1->X1_PERSPA		:= _aRegs[_Nx][02]
			SX1->X1_PERENG		:= _aRegs[_Nx][03]
			SX1->X1_VARIAVL		:= _aRegs[_Nx][04]
			SX1->X1_TIPO		:= _aRegs[_Nx][05]
			SX1->X1_TAMANHO		:= _aRegs[_Nx][06]
			SX1->X1_DECIMAL		:= _aRegs[_Nx][07]
			SX1->X1_PRESEL		:= _aRegs[_Nx][08]
			SX1->X1_GSC			:= _aRegs[_Nx][09]
			SX1->X1_VALID		:= _aRegs[_Nx][10]
			SX1->X1_VAR01		:= _aRegs[_Nx][11]
			SX1->X1_DEF01		:= _aRegs[_Nx][12]
			SX1->X1_DEFSPA1		:= _aRegs[_Nx][13]
			SX1->X1_DEFENG1		:= _aRegs[_Nx][14]
			SX1->X1_CNT01		:= _aRegs[_Nx][15]
			SX1->X1_VAR02		:= _aRegs[_Nx][16]
			SX1->X1_DEF02		:= _aRegs[_Nx][17]
			SX1->X1_DEFSPA2		:= _aRegs[_Nx][18]
			SX1->X1_DEFENG2		:= _aRegs[_Nx][19]
			SX1->X1_F3			:= _aRegs[_Nx][20]
			SX1->X1_GRPSXG		:= _aRegs[_Nx][21]
			MsUnlock()
		Endif*/
	Next
	RestArea(_aArea)
	
Return NIL

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

Static Function RESPOSTA(_nResp,_cPerg)
	
	Local _nPerg	:= Val(SubStr(_cPerg,10,2))
	Local _cResp	:= ""
	_nResp	:= Val(_nResp)
	
	If _nPerg <= 12
		DO CASE
		CASE _nResp=1
			_cResp	:= "Fortaleza"
		CASE _nResp=2
			_cResp	:= "Área de Desenvolvimento"
		CASE _nResp=3
			_cResp	:= "Meta alcançada"
		CASE _nResp=4
			_cResp	:= "Meta excedida"
		CASE _nResp=5
			_cResp	:= "Meta constantemente excedida"
		ENDCASE
	ElseIf _nPerg <= 33
		DO CASE
		CASE _nResp=1
			_cResp	:= "Fortaleza"
		CASE _nResp=2
			_cResp	:= "Área de Desenvolvimento"
		CASE _nResp=3
			_cResp	:= "Meta alcançada"
		CASE _nResp=4
			_cResp	:= "Meta excedida"
		CASE _nResp=5
			_cResp	:= "Meta constantemente excedida"
		ENDCASE
	Else
		DO CASE
		CASE _nResp=1
			_cResp	:= "Fortaleza"
		CASE _nResp=2
			_cResp	:= "Área de Desenvolvimento"
		CASE _nResp=3
			_cResp	:= "Bom"
		CASE _nResp=4
			_cResp	:= "Ótimo"
		CASE _nResp=5
			_cResp	:= "Excelente"
		ENDCASE
	EndIf
	
Return(_cResp)

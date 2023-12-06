#INCLUDE "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STACDR01 ³ Autor ³ Leonardo Kichitaro    ³ Data ³ 03/03/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Impressao das ordens de separacao                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STACDR01()
Local lContinua      := .T.
Private cString      := "CB7"
Private aOrd         := {}
Private cDesc1       := "Este programa tem como objetivo imprimir informacoes das" //
Private cDesc2       := "Ordens de Separacao" //
Private cPict        := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "STACDR01" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := {"Zebrado",1,"Administracao",2,2,1,"",1}  //###
Private nLastKey     := 0
Private cPerg        := "ACD100"
Private titulo       := "Impressao das Ordens de Separacao" //
Private nLin         := 06
Private Cabec1       := ""
Private Cabec2       := ""
Private cbtxt        := "Regsitro(s) lido(s)" //
Private cbcont       := 0
Private CONTFL       := 01
Private m_pag        := 01
Private lRet         := .T.
Private imprime      := .T.
Private wnrel        := "STACDR01" // Coloque aqui o nome do arquivo usado para impressao em disco

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas como Parametros                                ³
//³ MV_PAR01 = Ordem de Separacao de       ?                            ³
//³ MV_PAR02 = Ordem de Separacao Ate      ?                            ³
//³ MV_PAR03 = Data de Emissao de          ?                            ³
//³ MV_PAR04 = Data de Emissao Ate         ?                            ³
//³ MV_PAR05 = Considera Ordens encerradas ?                            ³
//³ MV_PAR06 = Imprime Codigo de barras    ?                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AjustaSX1()

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

CB7->(DbClearFilter())
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ Relatorioº Autor ³ Leonardo Kichitaro º Data ³  03/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAACD                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Relatorio()

CB7->(DbSetOrder(1))
CB7->(DbSeek(xFilial("CB7")+MV_PAR01,.T.)) // Posiciona no 1o.reg. satisfatorio 
SetRegua(RecCount()-Recno())

While ! CB7->(EOF()) .and. (CB7->CB7_ORDSEP >= MV_PAR01 .and. CB7->CB7_ORDSEP <= MV_PAR02)
	If CB7->CB7_DTEMIS < MV_PAR03 .or. CB7->CB7_DTEMIS > MV_PAR04 // Nao considera as ordens que nao tiver dentro do range de datas 
		CB7->(DbSkip())
		Loop
	Endif
	If MV_PAR05 == 2 .and. CB7->CB7_STATUS == "9" // Nao Considera as Ordens ja encerradas
		CB7->(DbSkip())
		Loop
	Endif
	CB8->(DbSetOrder(1))
	If ! CB8->(DbSeek(xFilial("CB8")+CB7->CB7_ORDSEP))
		CB7->(DbSkip())
		Loop
	EndIf
	IncRegua("Imprimindo")  //
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***" //
		Exit
	Endif
	Imprime()
	CB7->(DbSkip())
Enddo
Fim()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ Imprime  º Autor ³ Leonardo Kichitaro º Data ³  03/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela funcao Relatorio              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAACD                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Imprime(lRet)
Local cOrdSep := Alltrim(CB7->CB7_ORDSEP)
Local cPedido := Alltrim(CB7->CB7_PEDIDO)
Local cCliente:= Alltrim(CB7->CB7_CLIENT)
Local cLoja   := Alltrim(CB7->CB7_LOJA	)
Local cNota   := Alltrim(CB7->CB7_NOTA)
Local cSerie  := Alltrim(CB7->CB7_SERIE)
Local cOP     := Alltrim(CB7->CB7_OP)
Local cStatus := RetStatus(CB7->CB7_STATUS)
Local nWidth  := 0.050
Local nHeigth := 0.75  
Local nQtdItem:= 0
Local oPr

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

dbSelectArea("SD2")
SD2->(dbSetOrder(3))
SD2->(dbSeek(xFilial("SD2")+Padr(cNota,9)+Padr(cSerie,3)+cCliente+cLoja ) )

dbSelectArea("SC5")
SC5->(dbSetOrder(1))
SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO ))

@ 006, 000 PSay "STECK MATERIAIS ELETRICOS"
@ 008, 000 Psay "Ordem de Separacao: "+cOrdSep
@ 009, 000 PSay "Cliente...........: " + AllTrim(Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"SA1->A1_NOME")) + " (" + cCliente+"-"+cLoja + ")"
@ 010, 000 PSay "Pedido............: " + SD2->D2_PEDIDO + "    Emissao: " + DToC(SC5->C5_EMISSAO)
@ 011, 000 PSay "NF................: " + cNota + "-" + cSerie + "    Emissao: " + DToC(SD2->D2_EMISSAO)
@ 012, 000 PSay "Observacao........: " + SC5->C5_XOBSEXP
@ 013, 000 PSay "Transportadora....: " + AllTrim(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"SA4->A4_NOME" )) + " (" + SC5->C5_TRANSP + ")"
@ 014, 000 PSay "Tipo Frete........: " + Iif(SC5->C5_TPFRETE == "C","CIF",Iif(SC5->C5_TPFRETE == "F","FOB","")) 

If MV_PAR06 == 1 .And. aReturn[5] # 1
	oPr:= ReturnPrtObj()
	MSBAR3("CODE128",2.2,0.6,cOrdSep,oPr,Nil,Nil,Nil,nWidth,nHeigth,.t.,Nil,"B",Nil,Nil,Nil,.f.)
EndIf

@ 015, 000 Psay __PrtThinLine()
nLin := 15

nLin++
//@ nLin, 000 PSay "Armazem  Endereco         Produto          Descricao                       Composicao                      UM     Quantidade  Lote        Data Validade  Observacao  "
@ nLin, 000 PSay "Armazem  Endereco         Produto          Descricao                       UM     Quantidade  "
nLin++
@ nLin, 000 PSay __PrtThinLine()
nLin++

CB8->(DbSetOrder(1))
CB8->(DbSeek(xFilial("CB8")+cOrdSep))

While ! CB8->(EOF()) .and. (CB8->CB8_ORDSEP == cOrdSep)
	//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//0         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200
	//Armazem  Endereco         Produto          Descricao                       Composicao                      UM     Quantidade  Lote        Data Validade  Observacao  
	//99       XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX 999,999,999.99  XXXXXXXXXX       99/99/99  _____________________________________________________________
	//99       XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX 999,999,999.99  XXXXXXXXXX       99/99/99  _____________________________________________________________
	//99       XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX 999,999,999.99  XXXXXXXXXX       99/99/99  _____________________________________________________________
	//99       XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX 999,999,999.99  XXXXXXXXXX       99/99/99  _____________________________________________________________

	If nLin > 50
		//imprime o rodape  
		nLin++
		@ nLin,000 PSay __PrtThinLine()
/*
		nLin+= 2
		//@ nLin,000 PSay "Qtd. Itens: " + AllTrim(Str(nQtdItem)) + "           Qtd. Volumes: (_________________)"
		//nLin+=2
		@ nLin,000 PSay "Separador.: __________________________________________ Codigo: _______________"
		nLin+= 2
		@ nLin,000 PSay "Conferente: __________________________________________ Codigo: _______________"
		nLin++
*/	
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 06
		//@ nLin, 000 PSay "Armazem  Endereco         Produto          Descricao                       Composicao                          Quantidade  Lote        Data Validade  Observacao"
		@ nLin, 000 PSay "Armazem  Endereco         Produto          Descricao                       Quantidade  "
		nLin++
		@ nLin, 000 PSay __PrtThinLine()
		nLin++ 
		
		nQtdItem := 0
	Endif
	
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+CB8->CB8_PROD ))
	
	dbSelectArea("SB8")
	SB8->(dbSetOrder(3))
	SB8->(dbSeek(xFilial("SB8")+CB8->CB8_PROD+CB8->CB8_LOCAL+CB8->CB8_LOTECT ))

	@ nLin, 000 Psay CB8->CB8_LOCAL
	@ nLin, 009 PSay CB8->CB8_LCALIZ
	@ nLin, 026 PSay CB8->CB8_PROD
	@ nLin, 043 PSay SubStr(SB1->B1_DESC,1,30)
	//@ nLin, 075 PSay SubStr(SB1->B1_COMPOS,1,30)
	@ nLin, 075 PSay SB1->B1_UM
	@ nLin, 078 PSay Transform(CB8->CB8_QTDORI,"@E 999,999,999.99")
//	@ nLin, 126 Psay CB8->CB8_LOTECT
//	@ nLin, 143 PSay DToC(SB8->B8_DTVALID)
//	@ nLin, 153 PSay "_____________________________________________________________"
	nQtdItem++
	nLin++
	
	CB8->(DbSkip())
Enddo

nLin++
@ nLin,000 PSay __PrtThinLine()
/*
nLin+=2		
//@ nLin,000 PSay "Qtd. Itens: " + AllTrim(Str(nQtdItem)) + "           Qtd. Volumes: (_________________)"
//nLin+=2
@ nLin,000 PSay "Separador.: _________________________________________ Codigo: _______________"
nLin+=2
@ nLin,000 PSay "Conferente: _________________________________________ Codigo: _______________"
nLin++
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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RetStatusº Autor ³ Leonardo Kichitaro º Data ³  03/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela funcao Imprime                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAACD                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RetStatus(cStatus)
Local cDescri:= " "

If Empty(cStatus) .or. cStatus == "0"
	cDescri:= "Nao iniciado" //
ElseIf cStatus == "1"
	cDescri:= "Em separacao" //
ElseIf cStatus == "2"
	cDescri:= "Separacao finalizada" //
ElseIf cStatus == "3"
	cDescri:= "Em processo de embalagem" //
ElseIf cStatus == "4"
	cDescri:= "Embalagem Finalizada" //
ElseIf cStatus == "5"
	cDescri:= "Nota gerada" //
ElseIf cStatus == "6"
	cDescri:= "Nota impressa" //
ElseIf cStatus == "7"
	cDescri:= "Volume impresso" //
ElseIf cStatus == "8"
	cDescri:= "Em processo de embarque" //
ElseIf cStatus == "9"
	cDescri:=  "Finalizado" //
EndIf

Return(cDescri)

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
AAdd(_aRegs,{OemToansi("Data Emissao de             ?"),OemToansi("Data Emissao de             ?"),OemToansi("Data Emissao de             ?"),"mv_ch3","D",	8,0,0,"G","","mv_par03","","","","","","","","","",""})
AAdd(_aRegs,{OemToansi("Data Emissao Ate            ?"),OemToansi("Data Emissao Ate            ?"),OemToansi("Data Emissao Ate            ?"),"mv_ch4","D",	8,0,0,"G","","mv_par04","","","","","","","","","",""})
AAdd(_aRegs,{OemToansi("Considera Ordens encerradas ?"),OemToansi("Considera Ordens encerradas ?"),OemToansi("Considera Ordens encerradas ?"),"mv_ch5","C", 1,0,0,"C","","mv_par05","Sim","","","","","Nao","","","",""})
AAdd(_aRegs,{OemToansi("Imprime Codigo de barras    ?"),OemToansi("Imprime Codigo de barras    ?"),OemToansi("Imprime Codigo de barras    ?"),"mv_ch6","C", 1,0,0,"C","","mv_par06","Sim","","","","","Nao","","","",""})

dbSelectArea("SX1")
dbSetOrder(1)
For _Nx:=1 to Len(_aRegs)
	_cOrdem := StrZero(_Nx,2)
	/* Removido - 18/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
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

#INCLUDE "FISA026.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "RwMake.ch"
#Include "Ap5Mail.ch"
#INCLUDE "TBICONN.CH"
#include "TOTVS.CH" 


#DEFINE CR    chr(13)+chr(10)

#DEFINE _SEPARADOR ";"
#DEFINE _POSCGC    5
#DEFINE _POSDATINI 3
#DEFINE _POSDATFIN 4
#DEFINE _POSALQPER 9
#DEFINE _POSALQRET 9
#DEFINE _POSREG 1
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ARFISXX  ³ Autor ³ Cristiano Pereira   ³ Data ³ 01.06.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Processa a partir de um arquivo TXT gerado pela AFIP       ³±±
±±³          ³ atualizando as aliquotas de percepcao/retencao na tabela   ³±±
±±³          ³ SFH (ingressos brutos).                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Uso      ³ Fiscal - Buenos Aires - Argentina                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Laura Medina  ³17/06/14³TPVX35³La AFIP modifico el archivo TXT (ahora  ³±±
±±³              ³        ³      ³genera: 1Reg para Percepcion y 1reg de  ³±±
±±³              ³        ³      ³para Retencion, se adecuo la funcionali-³±±
±±³              ³        ³      ³dad a este esquema.                     ³±±
±±³Laura Medina  ³30/06/14³TPVZ44³Error en Query.                         ³±±
±±³Emanuel V.V.  ³        ³TQNAU0³Correccion funcion donde se cicla si    ³±±
±±³              ³        ³      ³el DBMS es diferente de SQLServer.      ³±±
±±³              ³        ³      ³replica del llamado TQAWQ5              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ARFISXX()

	Local   cCombo := ""
	Local   aCombo := {}
	Local   oDlg   := Nil
	Local   oFld   := Nil
	Private cMes   := StrZero(Month(dDataBase),2)
	Private cAno   := StrZero(Year(dDataBase),4)
	Private lRet   := .T.
	Private lPer   := .T.

	Public aQry := {}

	aAdd( aCombo, STR0002 ) //"1- Fornecedor"
	aAdd( aCombo, STR0003 ) //"2- Cliente"
	aAdd( aCombo, STR0004 ) //"3- Ambos"

	DEFINE MSDIALOG oDlg TITLE STR0005 FROM 0,0 TO 250,450 OF oDlg PIXEL //"Resolucao 70/07 para IIBB - Buenos Aires "

	@ 006,006 TO 040,170 LABEL STR0006 OF oDlg PIXEL //"Info. Preliminar"

	@ 011,010 SAY STR0007 SIZE 065,008 PIXEL OF oFld //"Arquivo :"
	@ 020,010 COMBOBOX oCombo VAR cCombo ITEMS aCombo SIZE 65,8 PIXEL OF oFld ON CHANGE ValidChk(cCombo)

	//+----------------------
	//| Campos Check-Up
	//+----------------------
	@ 10,115 SAY STR0008 SIZE 065,008 PIXEL OF oFld //"Imposto: "

	@ 020,115 CHECKBOX oChk1 VAR lPer PROMPT STR0009 SIZE 40,8 PIXEL OF oFld ON CHANGE ValidChk(cCombo)  //"Percepcao"
	@ 030,115 CHECKBOX oChk2 VAR lRet PROMPT STR0010 SIZE 40,8 PIXEL OF oFld ON CHANGE ValidChk(cCombo) //"Retencao"

	@ 041,006 FOLDER oFld OF oDlg PROMPT STR0011 PIXEL SIZE 165,075 //"&Importação de Arquivo TXT"

	//+----------------
	//| Campos Folder 2
	//+----------------
	@ 005,005 SAY STR0012 SIZE 150,008 PIXEL OF oFld:aDialogs[1] //"Esta opcao tem como objetivo atualizar o cadstro    "
	@ 015,005 SAY STR0013 SIZE 150,008 PIXEL OF oFld:aDialogs[1] //"Fornecedor / Cliente  x Imposto segundo arquivo TXT  "
	@ 025,005 SAY STR0014 SIZE 150,008 PIXEL OF oFld:aDialogs[1] //"disponibilizado pelo governo                         "
	@ 045,005 SAY STR0015 SIZE 150,008 PIXEL OF oFld:aDialogs[1] //"Informe o periodo:"
	@ 045,055 MSGET cMes PICTURE "@E 99" VALID !Empty(cMes) SIZE  015,008 PIXEL OF oFld:aDialogs[1]
	@ 045,070 SAY "/" SIZE  150, 8 PIXEL OF oFld:aDialogs[1]
	@ 045,075 MSGET cAno PICTURE "@E 9999" VALID !Empty(cMes) SIZE 020,008 PIXEL OF oFld:aDialogs[1]

	//+-------------------
	//| Boton de MSDialog
	//+-------------------
	@ 055,178 BUTTON STR0016 SIZE 036,016 PIXEL ACTION u_GeraImp(aCombo,cCombo) //"&Importar"
	@ 075,178 BUTTON STR0018 SIZE 036,016 PIXEL ACTION oDlg:End() //"&Sair"
	//@ 075,178 BUTTON STR0017 SIZE 036,016 PIXEL ACTION verResu()  //"&Resumo"
	//@ 095,178 BUTTON STR0018 SIZE 036,016 PIXEL ACTION oDlg:End() //"&Sair"

	ACTIVATE MSDIALOG oDlg CENTER

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ValidChk ³ Autor ³ Paulo Augusto       ³ Data ³ 30.03.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Programa que impede o uso do check de retencao para        ³±±
±±³          ³ clientes.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cPar01 - Variavel com o valor escolhido no combo.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ lRet - .T. se validado ou .F. se incorreto                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Buenos Aires Argentina                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static function ValidChk(cCombo)

	If lRet == .T. .and. Subs(cCombo,1,1) $ "2"    // Cliente nao tem retenção
		lRet :=.F.
	EndIf
	oChk2:Refresh()

Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ImpArq   ³ Autor ³ Ivan Haponczuk      ³ Data ³ 01.06.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inicializa a importacao do arquivo.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aPar01 - Variavel com as opcoes do combo cliente/fornec.   ³±±
±±³          ³ cPar01 - Variavel com a opcao escolhida do combo.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Buenos Aires Argentina                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GeraImp(aCombo,cCombo)

	Local   nPos     := 0
	Local   cLine    := ""
	Local   cFile    := ""
	Local   lVBanco  := "MSSQL"$Upper(TCGetDB())
	Private dDataIni := ""
	Private dDataFim := ""
	Private lFor     := .F.
	Private lCli     := .F.
	Private lImp     := .F.

	nPos := aScan(aCombo,{|x| AllTrim(x) == AllTrim(cCombo)})
	If nPos == 1 // Fornecedor
		lFor := .T.
	ElseIf nPos == 2 // Cliente
		lCli := .T.
	ElseIf nPos == 3 // Ambos
		lFor := .T.
		lCli := .T.
	EndIf

	//Seleciona o arquivo
	cFile := FGetFile()
	If Empty(cFile)
		Return Nil
	EndIf

	If MsgYesNo("Confirma reprocesamiento de la información del retenciones ? ")
		oProcess := MsNewProcess():New({|lEnd| __RunProc(lEnd,oProcess,cFile)},"Processando","Lendo...",.T.)
		oProcess:Activate()
	Endif

	MsgAlert("Arquivo Importado") //"Arquivo importado!"

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FGetFile ³ Autor ³ Ivan Haponczuk      ³ Data ³ 09.06.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela de seleção do arquivo txt a ser importado.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ cRet - Diretori e arquivo selecionado.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Buenos Aires Argentina - MSSQL                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FGetFile()

	Local cRet := Space(50)

	oDlg01 := MSDialog():New(000,000,100,500,STR0043,,,,,,,,,.T.)//"Selecionar arquivo"

	oGet01 := TGet():New(010,010,{|u| If(PCount()>0,cRet:=u,cRet)},oDlg01,215,10,,,,,,,,.T.,,,,,,,,,,"cRet")
	oBtn01 := TBtnBmp2():New(017,458,025,028,"folder6","folder6",,,{|| FGetDir(oGet01)},oDlg01,STR0043,,.T.)//"Selecionar arquivo"

	oBtn02 := SButton():New(035,185,1,{|| oDlg01:End() }         ,oDlg01,.T.,,)
	oBtn03 := SButton():New(035,215,2,{|| cRet:="",oDlg01:End() },oDlg01,.T.,,)

	oDlg01:Activate(,,,.T.,,,)

	cRet:= "C:\Ingressos Brutos\"

Return cRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FGetDir  ³ Autor ³ Ivan Haponczuk      ³ Data ³ 09.06.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela para procurar e selecionar o arquivo nos diretorios   ³±±
±±³          ³ locais/servidor/unidades mapeadas.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oPar1 - Objeto TGet que ira receber o local e o arquivo    ³±±
±±³          ³         selecionado.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - Buenos Aires Argentina - MSSQL                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FGetDir(oTGet)

	Local cDir := ""

	cDir := cGetFile(,STR0043,,,.T.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE)//"Selecionar arquivo"
	If !Empty(cDir)
		oTGet:cText := cDir
		oTGet:Refresh()
	Endif
	oTGet:SetFocus()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³__RunProc ºAutor  ³Cristiano Pereira   º Data ³  11/24/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executa processamento!                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function __RunProc(lEnd,oObj,cFile)

	Local _ni
	Private   _cDir
	Private  _cArqEnt , _nTamReg , nLidos , _cBUFFER
	Private  _aFiles
	Private _cSeek  := ""
	Private GFEFile     := GFEXFILE():New()
	_aFiles := {}
	// Carrega arquivos recebidos
	_cDir  :="C:\Ingressos Brutos\"

	_aFiles:= DIRECTORY(_cDir+ "*.TXT")


	aSort(_aFiles,,, { |x,y| x[1] < y[1] })

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Incia leitura do TXT                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	_nRecebe := 0
	oObj:SetRegua1(Len(_aFiles))

	dDataIni    :=  Stod('20201001')
	dDataFim    :=  Stod('20201031')

	for _ni:= 1 to len(_aFiles)

		_cArqEnt := cFile+ALLTRIM(_aFiles[_ni,1])
		_nTamReg := 55
		nLidos  := 0
		oObj:IncRegua1(time()+" Processando Arquivo: "+_aFiles[_ni,1])

		CONOUT("ANTES DO OPEN " + TIME())

		GFEFile:Clear()
		GFEFile:Open(_cArqEnt)
		CONOUT("DEPOIS DO OPEN " + TIME())
		While !GFEFile:FEof()

			_cBUFFER    := GFEFile:Line()
			//	_cBUFFER    += chr(13)+chr(10)

			oObj:IncRegua2("Falta processar: "+cvaltochar(GFEFile:NQTDELIN))
			CONOUT("Falta processar: "+cvaltochar(GFEFile:NQTDELIN))

			If SubStr(_cBUFFER,1,1) == "P"
				_cSeek      :=  SubStr(_cBUFFER,30,11)
				//dDataIni    :=  Stod(SubStr(_cBUFFER,16,4)+SubStr(_cBUFFER,14,2)+SubStr(_cBUFFER,12,2))
				//dDataFim    :=  Stod(SubStr(_cBUFFER,25,4)+SubStr(_cBUFFER,23,2)+SubStr(_cBUFFER,21,2))


				DbSelectArea("SA1")
				SA1->(DbSetOrder(3))
				If DbSeek(xFilial("SA1")+Rtrim(_cSeek))
					dbSelectArea("SFH")
					//	SFH->(dbSetOrder(6))
					//	SFH->(dbGoTop())
					//	cChave := xFilial("SFH")+SA1->A1_COD+SA1->A1_LOJA+"IB2"+"BA"+dtos(dDataIni)+dtos(dDataFim)


					//	If !(SFH->(dbSeek(cChave)))  

					If SA1->A1_TIPO $ "I|M" 
						nAliq := 0
						nAliq := Val(StrTran(SubStr(_cBUFFER,48,4),",","."))  
						If RecLock("SFH",.T.)
							SFH->FH_FILIAL	:= xFilial("SFH")
							SFH->FH_AGENTE	:= "S"
							SFH->FH_ZONFIS	:= "BA"
							SFH->FH_CLIENTE	:= SA1->A1_COD
							SFH->FH_LOJA	:= SA1->A1_LOJA
							SFH->FH_NOME	:= SA1->A1_NOME
							SFH->FH_IMPOSTO	:= "IB2"
							SFH->FH_PERCIBI	:= "S"
							If (nAliq == 0)
								SFH->FH_ISENTO := "S"
							Else
								SFH->FH_ISENTO := "N"
							EndIf
							SFH->FH_PERCENT	:= 0
							SFH->FH_APERIB	:= "S"
							SFH->FH_ALIQ	:= nAliq  
							SFH->FH_COEFMUL	:= 0
							SFH->FH_INIVIGE := dDataIni
							SFH->FH_FIMVIGE := dDataFim
							SFH->FH_TIPO    := "*"
							SFH->(MsUnlock())
						EndIf
					EndIf
				EndIf

				//	Endif

			ElseIf SubStr(_cBUFFER,1,1) == "R"

				_cSeek      :=  SubStr(_cBUFFER,30,11)
				//dDataIni    :=  Stod(SubStr(_cBUFFER,16,4)+SubStr(_cBUFFER,14,2)+SubStr(_cBUFFER,12,2))
				//dDataFim    :=  Stod(SubStr(_cBUFFER,25,4)+SubStr(_cBUFFER,23,2)+SubStr(_cBUFFER,21,2))


				DbSelectArea("SA2")
				SA2->(DbSetOrder(3))
				If DbSeek(xFilial("SA2")+Rtrim(_cSeek))
					dbSelectArea("SFH")
					//SFH->(dbSetOrder(5))
					//SFH->(dbGoTop())

					//cChave := xFilial("SFH")+SA2->A2_COD+SA2->A2_LOJA+"IBR"+"BA"+dtos(dDataIni)+dtos(dDataFim)


					//If !(SFH->(dbSeek(cChave)))   

					If SA2->A2_TIPO $ "I|M"  
						nAliq := 0
						nAliq := Val(StrTran(SubStr(_cBUFFER,48,4),",","."))
						If RecLock("SFH",.T.)
							SFH->FH_FILIAL  := xFilial("SFH")
							SFH->FH_AGENTE  := "S"
							SFH->FH_ZONFIS  := "BA"
							SFH->FH_FORNECE := SA2->A2_COD
							SFH->FH_LOJA    := SA2->A2_LOJA
							SFH->FH_NOME    := SA2->A2_NOME
							SFH->FH_IMPOSTO := "IBR"
							SFH->FH_PERCIBI := "N"
							If (nAliq == 0)
								SFH->FH_ISENTO := "S"
							Else
								SFH->FH_ISENTO := "N"
							EndIf
							SFH->FH_PERCENT := 0
							SFH->FH_APERIB  := "N"
							SFH->FH_ALIQ    := nAliq
							SFH->FH_COEFMUL := 0
							SFH->FH_INIVIGE := dDataIni
							SFH->FH_FIMVIGE := dDataFim
							SFH->FH_TIPO    := "*"
							MsUnlock()
						EndIf
					EndIf
					//EndIf


				Endif



			Endif
			// Pula para proximo registro
			GFEFile:FNext()
		Enddo




	Next _ni


	CONOUT("DEPOIS DE GRAVAR " + TIME())
	Reset Environment
Return             







User Function IGARG()

	Local _ni
	Private   _cDir
	Private  _cArqEnt , _nTamReg , nLidos , _cBUFFER
	Private  _aFiles
	Private _cSeek  := ""

	_aFiles := {}

	//RpcSetType( 3 )
	//RpcSetEnv("07","01",,,"FAT" )   

	// Carrega arquivos recebidos
	_cDir  := "C:\Ingressos Brutos\"

	_aFiles:= DIRECTORY(_cDir+ "*.TXT")


	aSort(_aFiles,,, { |x,y| x[1] < y[1] })

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Incia leitura do TXT                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	_nRecebe := 0
	//oObj:SetRegua1(Len(_aFiles))

	dDataIni    :=  STOD(AllTrim(GetMv("ARFISXX001",,"20210101")))
	dDataFim    :=  STOD(AllTrim(GetMv("ARFISXX002",,"20210131")))

	ConOut("[ARFISXX]["+ FWTimeStamp(2) +"] - Data inicial "+DTOC(dDataIni))
	ConOut("[ARFISXX]["+ FWTimeStamp(2) +"] - Data final "+DTOC(dDataFim))

	for _ni:= 1 to len(_aFiles)
		_cArqEnt := _cDir+ALLTRIM(_aFiles[_ni,1])
		//CONOUT(" startjob: "+_aFiles[_ni,1] + TIME())

		If !LockByName(_cArqEnt,.F.,.F.,.T.)
			ConOut("[IGARG]["+ _cArqEnt +"] Já existe uma sessão em processamento."+time())
		Else
			U_IGARG01(_cArqEnt)
			//StartJob("U_IGARG01",GetEnvServer(), .F.,_cArqEnt)
			UnLockByName(_cArqEnt,.F.,.F.,.T.)
			ConOut("[IGARG]["+ _cArqEnt +"] Unlock."+time())
		EndIf

		//sleep(5000)


	Next _ni


	CONOUT("DEPOIS DE GRAVAR " + TIME())

Return             



User Function IGARG01(_cArqEnt)


	Local  _cBUFFER
	Local  _aFiles
	Local _cSeek  := ""
	Local GFEFile := GFEXFILE():New()

	dDataIni    :=  STOD(AllTrim(GetMv("ARFISXX001",,"20210101")))
	dDataFim    :=  STOD(AllTrim(GetMv("ARFISXX002",,"20210131")))

	//	RpcSetType( 3 )
	//	RpcSetEnv("07","01",,,"FAT") 


	CONOUT("ANTES DO OPEN " + TIME())

	GFEFile:Clear()
	GFEFile:Open(_cArqEnt)
	CONOUT(_cArqEnt+ " " + TIME())

	CONOUT("Falta processar: "+cvaltochar(GFEFile:NQTDELIN))
	While !GFEFile:FEof()
		_cBUFFER    := GFEFile:Line()
		//oObj:IncRegua2("Falta processar: "+cvaltochar(GFEFile:NQTDELIN))
		CONOUT("Falta processar: "+cvaltochar(GFEFile:NQTDELIN))

		If SubStr(_cBUFFER,1,1) == "P"
			_cSeek      :=  SubStr(_cBUFFER,30,11)


			DbSelectArea("SA1")
			SA1->(DbSetOrder(3))
			If DbSeek(xFilial("SA1")+Rtrim(_cSeek)) .And. !(Empty(Alltrim(_cSeek)))
				dbSelectArea("SFH")


				If SA1->A1_TIPO $ "I|M"  .And. !(Empty(SA1->A1_CGC))
					nAliq := 0
					nAliq := Val(StrTran(SubStr(_cBUFFER,48,4),",","."))  
					If RecLock("SFH",.T.)
						SFH->FH_FILIAL	:= xFilial("SFH")
						SFH->FH_AGENTE	:= "S"
						SFH->FH_ZONFIS	:= "BA"
						SFH->FH_CLIENTE	:= SA1->A1_COD
						SFH->FH_LOJA	:= SA1->A1_LOJA
						SFH->FH_NOME	:= SA1->A1_NOME
						SFH->FH_IMPOSTO	:= "IB2"
						SFH->FH_PERCIBI	:= "S"
						If (nAliq == 0)
							SFH->FH_ISENTO := "S"
						Else
							SFH->FH_ISENTO := "N"
						EndIf
						SFH->FH_PERCENT	:= 0
						SFH->FH_APERIB	:= "S"
						SFH->FH_ALIQ	:= nAliq  
						SFH->FH_COEFMUL	:= 0
						SFH->FH_INIVIGE := dDataIni
						SFH->FH_FIMVIGE := dDataFim
						SFH->FH_TIPO    := "*"
						SFH->(MsUnlock())
					EndIf
				EndIf
			EndIf



		ElseIf SubStr(_cBUFFER,1,1) == "R"

			_cSeek      :=  SubStr(_cBUFFER,30,11)


			DbSelectArea("SA2")
			SA2->(DbSetOrder(3))
			If DbSeek(xFilial("SA2")+Rtrim(_cSeek)) .And. !(Empty(Alltrim(_cSeek)))
				dbSelectArea("SFH")


				If SA2->A2_TIPO $ "I|M"    .And. !(Empty(SA2->A2_CGC))
					nAliq := 0
					nAliq := Val(StrTran(SubStr(_cBUFFER,48,4),",","."))
					If RecLock("SFH",.T.)
						SFH->FH_FILIAL  := xFilial("SFH")
						SFH->FH_AGENTE  := "S"
						SFH->FH_ZONFIS  := "BA"
						SFH->FH_FORNECE := SA2->A2_COD
						SFH->FH_LOJA    := SA2->A2_LOJA
						SFH->FH_NOME    := SA2->A2_NOME
						SFH->FH_IMPOSTO := "IBR"
						SFH->FH_PERCIBI := "N"
						If (nAliq == 0)
							SFH->FH_ISENTO := "S"
						Else
							SFH->FH_ISENTO := "N"
						EndIf
						SFH->FH_PERCENT := 0
						SFH->FH_APERIB  := "N"
						SFH->FH_ALIQ    := nAliq
						SFH->FH_COEFMUL := 0
						SFH->FH_INIVIGE := dDataIni
						SFH->FH_FIMVIGE := dDataFim
						SFH->FH_TIPO    := "*"
						MsUnlock()
					EndIf
				EndIf
			Endif
		Endif

		GFEFile:FNext()
	Enddo

	//	CpyS2T(_cArqEnt,"C:\Ingressos Brutos\ok\",.T.)
	FERASE(_cArqEnt)

	//Reset Environment
Return()

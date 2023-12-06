#INCLUDE "TBICONN.CH"
#INCLUDE "MATA712.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "DBTREE.CH"
#INCLUDE "FILEIO.CH"
#DEFINE _CRLF CHR(13)+CHR(10)
#DEFINE _NEWLINE chr(13)+chr(13)

Static lA710SINI	:= ExistBlock("A710SINI")
Static lA710REV		:= ExistBlock("A710REV")
Static lPeMT710EXP  := ExistBlock("MT710EXP")
Static lM710Qtde	:= ExistBlock("M710QTDE")
Static lA710PAR		:= ExistBlock("A710PAR")
Static lUsaMOpc		:= If(SuperGetMv('MV_REPGOPC',.F.,"N") == "S",.T.,.F.)
Static cRevBranco   := Nil
		
Static lMRPCINQ     := Nil
Static lIsADVPR
Static aGeraOPC 	:= {}
STATIC lPCPREVATU	:= FindFunction('PCPREVATU')  .AND.  SuperGetMv("MV_REVFIL",.F.,.F.)
Static oSemLocal    := Nil
Static oComLocal    := Nil
Static oVerAlt      := Nil
Static oExplEs      := Nil
Static cLocCQ       := Nil
Static lConsVenc    := Nil
Static lMopcGRV		:= SuperGetMv("MV_MOPCGRV",.F.,.F.) // Parametro criado para definir se gravas os opcionais somente no Produto Pai ( Seq pai igual a branco/vazio).
Static oUpdCzi      := Nil // Utilizado com o parametro MV_MOPCGRV
Static aCacheOpc    := {}
//Variasveis que verifica o campo RECNO, se � controlado pelo TOTVS DBAcess ou pelo SGBD (2= TOTVS DBAcess, 1= SGBD )
// F = Controla pelo SGBD, T = Controla pelo SGBD
Static lAutoCZK := InfoSX2('CZK','X2_AUTREC') <> '1'
Static lAutoCZI := InfoSX2('CZI','X2_AUTREC') <> '1'
Static lAutoCZJ := InfoSX2('CZJ','X2_AUTREC') <> '1'
Static cFilQryCZI := " AND 1 = 1"
Static cFilTabCZI := "1 = 1"
Static cNomCZITTP := "CZITTP"+StrTran(cEmpAnt+cFilAnt," ", "_")
Static cNomCZITGR := "CZITGR"+StrTran(cEmpAnt+cFilAnt," ", "_")
Static cNomCZINNR := "CZINNR"+StrTran(cEmpAnt+cFilAnt," ", "_")

/*--------------------------------------------------------------------*/
/*/{Protheus.doc} MATA712
MRP

@author Ricardo Prandi
@since 17/09/2013
@version P11
@obs Programa c�pia do MATA710, reescrito para TOP
/*/
/*-------------------------------------------------------------------*/
User Function MATA712(lParBatch, aParAuto)

//Inicializa vari�veis locais
Local cSavAlias  	:= Alias()
Local cVarQ      	:= ""
Local cVarQ2		:= ""
Local cCapital	    := ""
Local cStrTipo   	:= ""
Local cStrGrupo	    := ""
Local nOk        	:= 0
Local nzz			:= 0
Local nInd       	:= 0
Local aRetPar    	:= {}
Local aTreeProc  	:= {}
Local bBlNewProc 	:= {|oCenterPanel|a712MCond(@cStrTipo,@cStrGrupo),U_MATA712INP(lPedido,lVisualiza,cStrTipo,cStrGrupo,oCenterPanel)}
Local lUsaNewPrc 	:= UsaNewPrc()
Local lOkExec		:= .T.
Local lVisualiza 	:= .F.
Local aTipos        := {}
Local nI            := 0
//Inicializa vari�veis de interface
Local oUsado,oChk,oChk2,oQual,oQual2,oChkQual,lQual,oChkQual2,lQual2
Local cFilSBM := xFilial("SBM")

Local dDtBsBkp := dDataBase

//Inicializa vari�veis private
PRIVATE nQuantPer		:= 030
PRIVATE nUsado			:= 1
PRIVATE nTamTipo711 	:= TamSX3("B1_TIPO")[1]
PRIVATE nTamGr711   	:= TamSX3("B1_GRUPO")[1]
PRIVATE nRecZero		:= 1
PRIVATE oOk      		:= LoadBitmap( GetResources(), "LBOK")
PRIVATE oNo      		:= LoadBitmap( GetResources(), "LBNO")
PRIVATE aLogMRP710  	:= {}
PRIVATE A711Tipo    	:= {}
PRIVATE A711Grupo		:= {}
PRIVATE aPergs711   	:= {}
PRIVATE aAuto  			:= aClone(aParAuto)
PRIVATE lGeraPI     	:= SuperGetMV("MV_GERAPI",.F.,.T.)
PRIVATE lDigNumOp   	:= .F.
PRIVATE lPedido  		:= .F.
PRIVATE lLogMRP			:= .F.
PRIVATE cCadastro		:= STR0001  //"MRP"
PRIVATE cPictB2Local 	:= PesqPict("SB2","B2_LOCAL")
PRIVATE cPictB2Qatu  	:= PesqPict("SB2","B2_QATU" )
PRIVATE cPictB2QNPT  	:= PesqPict("SB2","B2_QNPT" )
PRIVATE cPictB2QTNP  	:= PesqPict("SB2","B2_QTNP" )
PRIVATE cPictD7QTDE  	:= PesqPict("SD7","D7_QTDE" )
PRIVATE cPictDDSaldo 	:= PesqPict("SDD","DD_SALDO")
PRIVATE cAliasCZJ		:= "CZJ"
PRIVATE cAliasCZK		:= "CZK"
PRIVATE cDadosProd		:= Alltrim(SuperGetMV("MV_ARQPROD",.F.,"SB1"))  	// Projeto Implementeacao de campos MRP e FANTASM no SBZ
PRIVATE cIntgPPI     	:= "1" // Integra��o de OP's com o PPI atrav�s do MRP. 1 = N�o integra; 2 = Gera pend�ncia; 3 = Integra;

//Verifica a permissao do programa em relacao aos modulos
PRIVATE lBatch := lParBatch # Nil .And. lParBatch

//Verifica se mostra logs em tela
PRIVATE lMsHelpAuto  := !(SuperGetMv("MV_HELPMRP",NIL,.T.))
PRIVATE lMostraErro  := .F.

PRIVATE aOpcoes[2][7]
PRIVATE aFilAlmox
PRIVATE aAlmoxNNR

//Variavels para valida opcionas default
PRIVATE cProdx 		:= ""
PRIVATE cretx 		:= ""
PRIVATE aRetrOpcx 	:= {}
PRIVATE cProPaix 	:= ""
PRIVATE cProAntx 	:= ""
Private lMrpEmax	:= SUPERGETMV("MV_MRPEMAX",.F.,.F.)

PRIVATE aPerOpAuto := {}
PRIVATE aPerScAuto := {}
PRIVATE aDtDivAuto := {}
PRIVATE lOpMaxAuto := .T.

clrStatic()

If !LockByName("MRPEXCL"+cEmpAnt+cFilAnt,.T.,.T.,.T.)
	Help( ,, 'MATA712',, STR0152, 1, 0 ) //"O MRP j� est� sendo processado por outro usu�rio. Aguarde o t�rmino do processamento para executar o MRP novamente."
	Return
EndIf

If AliasInDic("SOQ")
	dbSelectArea("SOQ")
	SOQ->(dbSetOrder(1))
	If SOQ->(dbSeek(xFilial("SOQ")))
	   Help( ,, 'MATA712',, STR0151, 1, 0 )//"MRP Multi-empresas j� processado. Execu��o do MATA712 n�o permitida. Para realizar o processamento do MRP, utilize o PCPA107."
	   Return
	EndIf
EndIf
If AMIIn(10,44,4)
	If cRevBranco == Nil
		cRevBranco := CriaVar("B1_REVATU",.F.)
	EndIf
	If PCPIntgPPI()
		//Busca o par�metro de integra��o de OP's com o PPI.
		cIntgPPI := PCPIntgMRP()
	EndIf
	//Inicializa o log de processamento
	ProcLogIni({},"MATA712")

	//Atualiza o log de processamento
	ProcLogAtu("INICIO")

	//Cria as tabelas para controle dos grupos, tipo e locais
	MATA712TMP()

	//Monta a Tabela de Tipos
	aTipos := FWGetSX5("02")
	For nI := 1 To Len(aTipos)
		cCapital := OemToAnsi(Capital(aTipos[nI,4]))
		AADD(A711Tipo,{.T.,SubStr(aTipos[nI,3],1,nTamTipo711)+" - "+cCapital})
	Next nI

	//Monta a Tabela de Grupos
	dbSelectArea("SBM")
	dbSeek(cFilSBM)
	AADD(A711Grupo,{.T.,Criavar("B1_GRUPO",.F.)+" - "+STR0003}) //"Grupo em Branco"
	Do While (BM_FILIAL == cFilSBM) .AND. !Eof()
		cCapital := OemToAnsi(Capital(BM_DESC))
		AADD(A711Grupo,{.T.,SubStr(BM_GRUPO,1,nTamGr711)+" - "+cCapital})
		dbSkip()
	EndDo
	dbCloseArea()

	//------------------------------------------------------------------------------------//
	// MV_PAR01    ->  tipo de alocacao           1-p/ fim          2-p/inicio            //
	// MV_PAR02    ->  Geracao de SC.             1-p/OPs           2-p/necess.           //
	// MV_PAR03    ->  Geracao de OP PIS          1-p/OPs           2-p/necess.           //
	// MV_PAR04    ->  Periodo p/Gerar OP/SC      1-Junto           2-Separado            //
	// MV_PAR05    ->  PV/PMP De  Data                                                    //
	// MV_PAR06    ->  PV/PMP Ate Data                                                    //
	// MV_PAR07    ->  Inc. Num. OP               1- Item	        2- Numero             //
	// MV_PAR08    ->  De Local                   1- Sim            2- Nao                //
	// MV_PAR09    ->  Ate Local                  1- Sim            2- Nao                //
	// MV_PAR10    ->  Gera OPs / SCs             1- Firme          2- Prevista           //
	// MV_PAR11    ->  Apaga OPs/SCs Previstas    1- Sim            2- Nao                //
	// MV_PAR12    ->  Considera Sab.?Dom.?       1- Sim            2- Nao                //
	// MV_PAR13    ->  Considera OPs Suspensas    1- Sim            2- Nao                //
	// MV_PAR14    ->  Considera OPs Sacrament    1- Sim            2- Nao                //
	// MV_PAR15    ->  Recalcula Niveis   ?       1- Sim            2- Nao                //
	// MV_PAR16    ->  Gera OPs Aglutinadas       1- Sim            2- Nao                //
	// MV_PAR17    ->  Pedidos de Venda Coloca    1- Subtrai        2- Nao Subtrai        //
	// MV_PAR18    ->  Considera Sld Estoque      1- Atual          2- Calcest            //
	// MV_PAR19    ->  Ao atingir Estoque Maximo? 1-Qtde. Original  2- Ajusta Est. Max    //
	// MV_PAR20    ->  Qtd. nossa Poder 3         1- Soma           2- Ignora             //
	// MV_PAR21    ->  Qtd. 3� nosso Poder        1- Subtrai        2- Ignora             //
	// MV_PAR22    ->  Saldo rejeitado pelo CQ    1-Subtrai         2- Nao Subtrai        //
	// MV_PAR23    ->  PV/PMP De  Documento                                               //
	// MV_PAR24    ->  PV/PMP Ate Documento                                               //
	// MV_PAR25    ->  Saldo bloqueado            1-Subtrai         2- Nao Subtrai        //
	// MV_PAR26    ->  Considera Est. Seguranca   1-Sim     2-Nao   3- So necessidade.    //
	// MV_PAR27    ->  Ped. Venda Bloq. Credito?  1-Sim             2- Nao                //
	// MV_PAR28    ->  Mostra dados resumidos  ?  1-Sim             2- Nao                //
	// MV_PAR29    ->  Detalha lotes vencidos  ?  1-Sim             2- Nao                //
	// MV_PAR30    ->  Pedidos de Venda Fatura    1- Subtrai        2- Nao Subtrai        //
	// MV_PAR31    ->  Considera Ponto de Pedido  1- Sim            2- Nao                //
	// MV_PAR32    ->  Gera tabela necessidades   1- Sim            2- Nao                //
	// MV_PAR33    ->  Data inicial Ped Faturados                                         //
	// MV_PAR34    ->  Data final Ped Faturados                                           //
	//------------------------------------------------------------------------------------//

	//Ponto de entrada para alterar a parametrizacao inicial do MRP
	If lA710PAR
		aRetPar := ExecBlock("A710PAR",.F.,.F.,{nUsado,nQuantPer,a711Tipo,a711Grupo,lPedido})
		If Len(aRetPar[1]) == 5
			For nInd :=1 to Len(aRetPar[1])
				//Valida os valores numericos
				If nInd == 1
					If ValType(aRetPar[1][nInd]) # "N"
						lOkExec:=.F.
						Exit
					Else
						If aRetPar[1][nInd] < 1 .Or. aRetPar[1][nInd] > 7
							lOkExec := .F.
							Exit
						EndIf
					EndIf
				//Valida os valores numericos
				ElseIf nInd == 2
					If ValType(aRetPar[1][nInd]) # "N"
						lOkExec:=.F.
						Exit
					EndIf
				//Valida os valores array
				ElseIf nInd == 3 .Or. nInd == 4
					//Valida o conteudo dos arrays
					If ValType(aRetPar[1][nInd]) == "A"
						For nzz:=1 to Len(aRetPar[1][nInd])
							If ValType(aRetPar[1][nInd,nzz,1]) # "L" .Or. ValType(aRetPar[1][nInd,nzz,2]) # "C"
								lOkExec:=.F.
								Exit
							EndIf
						Next nzz
					Else
						lOkExec:=.F.
						Exit
					EndIf
				//Valida o valor logico
				ElseIf nInd == 5 .And. ValType(aRetPar[1][nInd]) # "L"
					lOkExec:=.F.
					Exit
				EndIf
			Next nInd

			//Assume valores retornados pelo ponto de entrada
			If lOkExec
				nUsado   :=aRetPar[1][1]
				nQuantPer:=aRetPar[1][2]
				a711Tipo :=aRetPar[1][3]
				a711Grupo:=aRetPar[1][4]
				lPedido  :=aRetPar[1][5]
			EndIf
		EndIf
	EndIf

	If !lBatch
		If lUsaNewPrc
			aAdd(aTreeProc,{OemToAnsi(STR0004),{|oCenterPanel|A712MontPer(oCenterPanel)},"filtro1"})
			aAdd(aTreeProc,{OemToAnsi(STR0005),{|oCenterPanel|A712MontVis(oCenterPanel,@lVisualiza)},"watch"})

			tNewProcess():New("MATA712",OemToAnsi(STR0001),bBlNewProc,OemToAnsi(STR0006)+_NEWLINE+OemToAnsi(STR0007)+_NEWLINE+OemToAnsi(STR0008),"MTA712",aTreeProc)
		Else
			DEFINE MSDIALOG oDlg TITLE  From 145,0 To 445,628 OF oMainWnd PIXEL
			@ 10,15 TO 129,115 LABEL STR0009 OF oDlg  PIXEL //"Periodicidade do MRP"
			@ 25,20 RADIO oUsado VAR nUsado 3D SIZE 70,10 PROMPT	OemToAnsi(STR0010),;	//"Periodo Di�rio"
																		OemToAnsi(STR0011),;	//"Periodo Semanal"
																		OemToAnsi(STR0012),;	//"Periodo Quinzenal"
																		OemToAnsi(STR0013),;	//"Periodo Mensal"
																		OemToAnsi(STR0014),;	//"Periodo Trimestral"
																		OemToAnsi(STR0015),;	//"Periodo Semestral"
																		OemToAnsi(STR0016) OF oDlg PIXEL //"Periodos Diversos"
			@ 102,020 Say OemToAnsi(STR0017) SIZE 60,10 OF oDlg PIXEL //"Quantidade de Periodos:"
			@ 102,085 MSGET nQuantPer Picture "999" Valid Positivo() .And. NaoVazio() SIZE 15,10 OF oDlg PIXEL
			@ 10,130 TO 129,300 LABEL "" OF oDlg PIXEL
			@ 16,135 CHECKBOX oChk  VAR lPedido PROMPT OemToAnsi(STR0018) SIZE 85, 10 OF oDlg PIXEL ;oChk:oFont := oDlg:oFont	//"Considera Pedidos em Carteira"
			@ 26,135 CHECKBOX oChk2 VAR lLogMRP PROMPT OemToAnsi(STR0019) SIZE 85, 10 OF oDlg PIXEL ;oChk2:oFont := oDlg:oFont	//"Log de eventos do MRP"
			@ 36,135 CHECKBOX oChkQual VAR lQual  PROMPT OemToAnsi(STR0020) SIZE 50, 10 OF oDlg PIXEL ON CLICK (AEval(a711Tipo , {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oQual:Refresh(.F.)) //"Inverter Selecao"
			@ 47,130 LISTBOX oQual VAR cVarQ Fields HEADER "",OemToAnsi(STR0021)  SIZE 78,081 ON DBLCLICK (A711Tipo:=CA712Troca(oQual:nAt,A711Tipo),oQual:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oQual,oOk,oNo,@A711Tipo) NoScroll OF oDlg PIXEL	//"Tipos de Material"

			oQual:SetArray(A711Tipo)
			oQual:bLine := { || {If(A711Tipo[oQual:nAt,1],oOk,oNo),A711Tipo[oQual:nAt,2]}}

			@ 37,226 CHECKBOX oChkQual2 VAR lQual2 PROMPT OemToAnsi(STR0020) SIZE 50, 10 OF oDlg PIXEL ON CLICK (AEval(a711Grupo, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual2:Refresh(.F.)) //"Inverter Selecao"
			@ 47,221 LISTBOX oQual2 VAR cVarQ2 Fields HEADER "",OemToAnsi(STR0022)  SIZE 78,081 ON DBLCLICK (A711Grupo:=CA712Troca(oQual2:nAt,A711Grupo),oQual2:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oQual2,oOk,oNo,@A711Grupo) NoScroll OF oDlg  PIXEL	//"Grupos de Material"

			oQual2:SetArray(A711Grupo)
			oQual2:bLine := { || {If(A711Grupo[oQual2:nAt,1],oOk,oNo),A711Grupo[oQual2:nAt,2]}}

			DEFINE SBUTTON FROM 134,180 TYPE 5 ACTION (Pergunte("MTA712",.T.),A712FilAlm(.T.)) ENABLE OF oDlg
			DEFINE SBUTTON FROM 134,210 TYPE 15 ACTION (nOk:=1,oDlg:End(),lVisualiza:=.T.) ENABLE OF oDlg
			DEFINE SBUTTON FROM 134,240 TYPE 1 ACTION (MTA712OK(@nOK,A711Tipo,A711Grupo),IIf(nOk=1,oDlg:End(),)) ENABLE OF oDlg
			DEFINE SBUTTON FROM 134,270 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg




			ACTIVATE MSDIALOG oDlg CENTERED
		EndIf
	Else
		nUsado    := aAuto[1]
		nQuantPer := aAuto[2]
		If ValType(aAuto[3]) == "L"
			lPedido   := aAuto[3]
		Endif
		If ValType(aAuto[4]) == "A"
			a711Tipo := aAuto[4]
		Endif
		If ValType(aAuto[5]) == "A"
			a711Grupo := aAuto[5]
		Endif
		If ValType(aAuto[7]) == "L"
			lLogMRP := aAuto[7]
		EndIf
		If Len(aAuto) >= 9 .And. ValType(aAuto[9]) == "C"
			dDatabase := cToD(aAuto[9])
		EndIf
		If Len(aAuto) >= 10 .And. ValType(aAuto[10]) == "A"
			aPerOpAuto := aAuto[10]
		EndIf
		If Len(aAuto) >= 11 .And. ValType(aAuto[11]) == "A"
			aPerScAuto := aAuto[11]
		EndIf
		If Len(aAuto) >= 12 .And. ValType(aAuto[12]) == "L"
			lOpMaxAuto := aAuto[12]
		EndIf
		If Len(aAuto) >= 13 .And. ValType(aAuto[13]) == "A"
			aDtDivAuto := aAuto[13]
		EndIf
		nOk := 1
	Endif

	If nOk = 1
		If !lBatch
			//Atualiza as coordenadas da Janela Principal
			oMainWnd:CoorsUpdate()
		EndIf
		If !lUsaNewPrc
          	a712MCond(@cStrTipo,@cStrGrupo)
   			FWMsgRun(,{|| U_MATA712INP(lPedido,lVisualiza,cStrTipo,cStrGrupo) },STR0108,STR0154) //"Conectando ao link informado..." //"Aguarde"
		EndIf
	Endif
	DeleteObject(oOk)
	DeleteObject(oNo)

	//Atualiza o log de processamento
	ProcLogAtu("FIM")

	dDataBase := dDtBsBkp
EndIf

dbSelectArea(cSavAlias)
UnLockByName("MRPEXCL"+cEmpAnt+cFilAnt,.T.,.T.,.T.)

RETURN

/*------------------------------------------------------------------------//
//Programa:	A712FilAlm
//Autor:		Andre Anjos
//Data:		20/08/12
//Descricao:	Filtra armazens por range quando MV_MRPFILA ativo.
//Parametros:	lSeleciona: indica se abre tela de selecao.
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712FilAlm(lSeleciona)
Local aDados  := {}
Local oDlg    := NIL
Local oBrw	  	:= NIL
Local nInd	  	:= 0
Local cAlmDe  := If(lSeleciona,mv_par08,aPergs711[8])
Local cAlmAte := If(lSeleciona,mv_par09,aPergs711[9])
Local cSql		:= ""
Local cFilNNR := xFilial("NNR")

Default lSeleciona := .F.


NNR->(dbSetOrder(1))
NNR->(dbSeek(cFilNNR))
While !NNR->(EOF()) .And. NNR->NNR_FILIAL == cFilNNR
	If NNR->NNR_CODIGO >= cAlmDe .And. NNR->NNR_CODIGO <= cAlmAte .And. NNR->NNR_MRP # '2'
		aAdd(aDados,{.T.,NNR->NNR_CODIGO,NNR->NNR_DESCRI})
	EndIf
	NNR->(dbSkip())
End

If SuperGetMV("MV_MRPFILA",.F.,.F.)
	If lSeleciona .And. !Empty(aDados)
		oDlg := MSDialog():New(0,0,280,390,STR0023,,,,,,,,oMainWnd,.T.) //Sele��o de armaz�ns
		oDlg:nStyle := DS_MODALFRAME
		oDlg:lEscClose := .F.
		TSay():Create(oDlg,{|| STR0024},05,05,,,,,,.T.,,,200,10) //Selecione os armaz�ns cujos saldos devem ser considerados no c�lculo MRP:
		oBrw := TWBrowse():New(20,05,190,100,{|| {If(aDados[oBrw:nAt,1],oOk,oNo),aDados[oBrw:nAt,2],aDados[oBrw:nAt,3]}},{"",RetTitle("NNR_CODIGO"),RetTitle("NNR_DESCRI")},,oDlg,,,,,{|| aDados[oBrw:nAt,1] := !aDados[oBrw:nAt,1],oBrw:Refresh()},,,,,,,,,.T.)
		oBrw:SetArray(aDados)
		oBrw:bLine := {|| {If(aDados[oBrw:nAt,1],oOk,oNo),aDados[oBrw:nAt,2],aDados[oBrw:nAt,3]}}
		oTButMarDe := TButton():New(00,00, ,oBrw,{|| MarcaTodos(oBrw)},8,10,,,.F.,.T.,.F.,,.F.,,,.F.)
		TButton():Create(oDlg,125,5,STR0025,{|| oDlg:End()},70,10,,,,.T.) //Confirmar
		oDlg:Activate(,,,.T.)
	EndIf
EndIf

//Limpa a tabela
cSql := " DELETE FROM " +cNomCZINNR
TCSQLExec(cSql)

aAlmoxNNR := {}
For nInd := 1 TO Len(aDados)
	If aDados[nInd][1] == .T.
		Aadd(aAlmoxNNR,{aDados[nInd][2]})

		//Insere na tabela
		cSql := " INSERT INTO " +cNomCZINNR +" (NR_LOCAL, R_E_C_N_O_) VALUES ('" + aDados[nInd][2] + "'," + Str(nInd) + ") "
		TCSQLExec(cSql)
	EndIf
Next nInd

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MarcaTodos�                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � MATA712                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarcaTodos( oBrowse )

If aScan(oBrowse:aArray, {|x| !x[1] }) > 0
	aEval(@oBrowse:aArray, {|x| x[1] := .T.})
Else
	aEval(@oBrowse:aArray, {|x| x[1] := .F.})
EndIf

oBrowse:Refresh()

Return NIL

/*------------------------------------------------------------------------//
//Programa:	CA712Troca
//Autor:		Rodrigo de Almeida Sartorio
//Data:		20/08/12
//Descricao:	Troca marcador entre x e branco
//Parametros:	nIt		- Linha onde o click do mouse ocorreu
//				aArray	- Array com as opcoes para selecao
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function CA712Troca(nIt,aArray)

aArray[nIt,1] := !aArray[nIt,1]

Return aArray

/*------------------------------------------------------------------------//
//Programa:	MTA712OK
//Autor:		Rodrigo de Almeida Sartorio
//Data:		20/08/12
//Descricao:	Confirmacao antes de executar o MRP
//Parametros:	nOk			- Variavel numerica com o retorno
//				a711Tipo	- Array com os tipos disponiveis para selecao
//				a711Grupo 	- Array com os grupos disponiveis para selecao
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MTA712OK(nOK,A711Tipo,A711Grupo)
Local aButtons	:= {STR0026, STR0027, STR0028} //"Log Ativo","Log Inativo","Cancelar"
Local nRet 		:= 0
Local lRet 		:= .T.
Local nAcho1		:= Ascan(A711Tipo,{|x| x[1] == .T.})
Local nAcho2		:= Ascan(A711Grupo,{|x| x[1] == .T.})

If nAcho1 = 0 .Or. nAcho2 = 0
	Help(" ",1,"A711MENU")
	lRet := .F.
EndIf

If ExistBlock( "MTA710AP" )
   lRet := ExecBlock("MTA710AP",.F.,.F.)
   If ValType(lRet) <> "L"
     	lRet:=.T.
   EndIf
Endif

/*
   Verifica se existe uma thread da integra��o das ordens de produ��o do MRP em execu��o.
   se estiver, n�o deixa realizar o processamento.
*/
If lRet .And. cIntgPPI != "1"
   cValue := GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt)
   If !Empty(cValue) .And. (cValue != "3" .And. cValue != "30")
      MsgInfo(STR0148,STR0030) //"A integra��o das ordens de produ��o com o PC-Factory ainda est� em processamento. Execu��o do MRP n�o permitida neste momento." "Aten��o"
      lRet := .F.
   EndIf
EndIf

If lRet
	lRet := IIf(MsgYesNo(OemToAnsi(STR0029),OemToAnsi(STR0030)),nOk:=1,nOk:=2) //"Confirma o MRP?
EndIf

If lLogMrp .And. lRet == 1
	nRet := Aviso(STR0030,STR0031,aButtons) //"O log de eventos est� ativo e isto aumentar� o tempo de processamento da rotina. Como deseja prosseguir?"
	If nRet == 2
		lLogMrp := .F.
	ElseIf nRet == 3
		nOk := 2
	Endif
EndIf

Return lRet

/*------------------------------------------------------------------------//
//Programa:	a712MCond
//Autor:		Ricardo Prandi
//Data:		20/09/2013
//Descricao:	Rotina que monta condicao default da projecao, strings de
//            filtro para tipos e grupos e array aPergs711
//Parametros:	cStrTipo	- String de tipo de produto
//				cStrGrupo	- String de grupo de produto
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function a712MCond(cStrTipo,cStrGrupo)
Local nZ 		:= 0
Local cInsert 	:= ""
local aPergs712	:={}
Local i
//Monta condicao default da projecao
For nz:=1 to 7
	If nUsado = nz
		aOpcoes[1][nz] := "x"
	Else
		aOpcoes[1][nz] := " "
	EndIf
Next nz
aOpcoes[2][1] := nQuantPer  // Numero de Periodos

//Move A711Tipo para aStrTipo
cStrTipo := Criavar("B1_TIPO",.f.)+"|"
FOR nZ:=1 TO LEN(A711Tipo)
	If A711Tipo[nZ,1]
		//Inclui na tabela
		cInsert := " INSERT INTO " +cNomCZITTP +" (TP_TIPO, R_E_C_N_O_) VALUES ('" + SubStr(A711Tipo[nZ,2],1,nTamTipo711) + "'," + Str(nZ) + ") "
		TCSQLExec(cInsert)
		cStrTipo += SubStr(A711Tipo[nZ,2],1,nTamTipo711)+"|"
	EndIf
Next nZ

//Move A711Grupo para aStrGrupo
FOR nZ:=1 TO LEN(A711Grupo)
	If A711Grupo[nZ,1]
		//Inclui na tabela
		cInsert := " INSERT INTO " +cNomCZITGR +" (GR_GRUPO, R_E_C_N_O_) VALUES ('" + SubStr(A711Grupo[nZ,2],1,nTamGr711) + "'," + Str(nZ) + ") "
		TCSQLExec(cInsert)
		cStrGrupo += SubStr(A711Grupo[nZ,2],1,nTamGr711)+"|"
	EndIf
Next nZ

//Alimenta array aPergs711 com os dados do SX1
Pergunte("MTA712",.F.)
aPergs711 := Array(35)
For nZ := 1 To Len(aPergs711)
	aPergs711[nZ] := &("mv_par"+StrZero(nZ,2))
Next nZ

If Empty(aPergs711[35])
	aPergs711[35] := 1
EndIf

//Ponto de entrada para manipular os Parametros do MRP
If (ExistBlock( "M712PERG" ) )
	aPergs712 := ExecBlock("M712PERG",.F.,.F.,{aPergs711})
	If ValType(aPergs712) == "A" .AND. LEN(aPergs712) == len(aPergs711)
		For i := 1 to Len(aPergs712)
			IF  aPergs711[i] != aPergs712[i]
				aPergs711[i] := aPergs712[i]
			EndIF
		Next i
	Endif
Endif

//Filtra armazens conforme MV_MRPFILA e NNR_MRP
If aAlmoxNNR == NIL
	A712FilAlm(.F.)
EndIf

Return

/*------------------------------------------------------------------------//
//Programa:	MATA712INP
//Autor:		Ricardo Prandi
//Data:		17/09/2013
//Descricao:	Funcao que dispara todo processo de montagem da interface
//Parametros:	lPedido		- Indica se considera pedidos de venda no MRP
//				lVisualiza		- Indica se esta utilizando visualizacao do MRP
//				cStrTipo		- String com tipos a serem processados
//				cStrGrupo		- String com grupos a serem processados
//				oCenterPanel	- Objeto do painel da tela
//Uso: 		MATA712
//------------------------------------------------------------------------*/
User Function MATA712INP(lPedido,lVisualiza,cStrTipo,cStrGrupo,oCenterPanel)
//Variaveis array
Local aOpc				:= {}
Local aListaJob 		:= {}
Local aParamJob		    := {}
Local aThreads      	:= {}
Local aJobAux       	:= {}
Local aButtons		    := {}
Local aADDButtons		:= {}
Local aCampos			:= {}
Local aTamQuant  		:= TamSX3("B2_QFIM")
Local aPages			:= {"HEADER","HEADER"}
Local aTitles			:= {STR0032,STR0033} //"Dados"###Legenda
Local aSize  			:= MsAdvSize()
Local bChange			:= {|| Nil }

//Variaveis l�gicas
Local M710Niv			:= .F.
Local lAtvFilTmp		:= .F.
Local lThreads   		:= .F.
Local lConsSusp  		:= aPergs711[13] == 1
Local lConsSacr  		:= aPergs711[14] == 1
Local lCalcNivelEstr	:= aPergs711[15] == 1
Local lPedBloc      	:= aPergs711[27] == 1
Local lFlatMode		:= FlatMode()
Local lA710SQL		:= ExistBlock("A710SQL")

Local lM710NOPC		:= ExistBlock("M710NOPC")
Local lExistBB1		:= ExistBlock("A710FILALM")
Local lExistBB2	 	:= ExistBlock("MT710B2")
Local lConsPreRe		:= SuperGetMV("MV_MRPSCRE",.F.,.T.) == .T.
Local lAllTp			:= Ascan(A711Tipo,{|x| x[1] == .F.}) == 0
Local lAllGrp	 		:= Ascan(A711Grupo,{|x| x[1] == .F.}) == 0
Local lShAlt 			:= If(ExistBlock("M710ShAlt"),execblock('M710SHAlt',.F.,.F.),.F.)
Local lProcSC4          := .T.

//Variaveis char
Local cAliasTop  		:= ""
Local cMsgAviso		:= ""
Local cMsgPontP		:= ""
Local cBotFun			:= ""
Local cTopFun			:= ""
Local cQueryB1  		:= ""
Local cFileJob 		:= ""
Local cAliasView		:= ""
Local cComp1			:= CriaVar("C6_BLQ")
Local cComp2			:= "N"+Space(Len(cComp1)-1)
Local cNumOpDig		:= Criavar("C2_NUM",.F.)
Local cOpc711Vaz		:= CriaVar("C2_OPC",.F.)
Local cRev711Vaz		:= ""//CriaVar("B1_REVATU",.F.)
Local cStartPath 		:= GetSrvProfString("Startpath","")
Local cTxtEstSeg 		:= RetTitle("B1_ESTSEG")
Local cTxtPontPed 	:= RetTitle("B1_EMIN")
Local cRevisao		:= Nil
Local cSelOpc			:= SuperGetMv('MV_SELEOPC',.F.,'N')

//Variaveis date
Local dInicio 		:= dDataBase

//Variaveis num�ricas
Local z				:= 0
Local nz				:= 0
Local nx				:= 0
Local nSaldo			:= 0
Local nEstSeg			:= 0
Local nQtdAviso		:= 0
Local nPontoPed		:= 0
Local nQtdPontP		:= 0
Local nOldEnch		:= 1
Local i				:= 0
Local nRetry_0 		:= 0
Local nRetry_1 		:= 0
Local nHandle    		:= 0
Local nPoLin 			:= 0
Local nLin				:= 0
Local nInd				:= 0
Local nCol	    		:= aSize[5]
Local nPeriodos		:= aOpcoes[2][1]
Local nTop				:= If(lBatch,0,oMainWnd:nTop)
Local nLeft			:= If(lBatch,0,oMainWnd:nLeft+5)
Local nBottom			:= If(lBatch,0,oMainWnd:nBottom-30)
Local nRight			:= If(lBatch,0,oMainWnd:nRight-10)
Local DatFim
Local lOpcOK := .T.
//Variaveis do tipo objeto
Local oFont,oDlg,oFolder,oBmp,oMenu1,oMenu2,oSay1,oSay2

//Variavel da enchoice
Local aEnch[11]

//Vari�vel MEMO
Local mOpc := ""

//Vari�veis Tela Gera��o OPs/SCs
Local aSays    := {}
Local lOpMax99 := .T.
Local nOpcA    := 0
Local nEstmax  := 0
Local lPrcPad := SuperGetMV("MV_A712PRC",.F.,"1") == "1"
Local oTempTable := Nil
local lMrpSeg
Local cFilSB1 := ""
Local cFilSBZ := ""
//Variaveis PRIVATE
PRIVATE c711NumMRP	:= ""
PRIVATE cIndSB6		:= ""
PRIVATE nIndSB6		:= ""
PRIVATE cMT710B2		:= ""
PRIVATE cProdDetSld 	:= ""
PRIVATE cFilNess		:= ""
PRIVATE cAlmoxd		:= aPergs711[8]
PRIVATE cAlmoxa		:= aPergs711[9]
PRIVATE cPictQuant	:= PesqPictQt("B2_QFIM",aTamQuant[1]+2)
PRIVATE cPictLOCAL  	:= PesqPict("SB2","B2_LOCAL")
PRIVATE cPictQATU   	:= PesqPict("SB2","B2_QATU")
PRIVATE cPictQNPT   	:= PesqPict("SB2","B2_QNPT")
PRIVATE cPictQTNP   	:= PesqPict("SB2","B2_QTNP")
PRIVATE cPictQTDE   	:= PesqPict("SD7","D7_QTDE")
PRIVATE cPictSALDO  	:= PesqPict("SDD","DD_SALDO")
PRIVATE cSelPer		:= cSelPerSC :=""
PRIVATE cSelF   		:= cSelFSC :=""
PRIVATE cFilSB1Old	:= SB1->(DbFilter())
PRIVATE aPeriodos		:= {}
PRIVATE aDiversos		:= {}
PRIVATE aDbTree 		:= {}
PRIVATE a711SvAlias	:= {}
PRIVATE aTotais		:= {{}}
PRIVATE aDelOpsPPI      := {}
PRIVATE lDiasHl 		:= .T.
PRIVATE lDiasHf 		:= .T.
PRIVATE lAtvFilNes	:= .F.
PRIVATE nTipo			:= 0

//Variaveis do tipo objeto
PRIVATE oTreeM711,oPanelM711,oScrollM711

PRIVATE lVisRes         := aPergs711[35] == 1 .And. !lBatch

DEFAULT lVisualiza := .F.
If cRevBranco == Nil
	cRevBranco := CriaVar("B1_REVATU",.F.)
EndIf
cRev711Vaz := cRevBranco
If lMRPCINQ == Nil
	lMRPCINQ := SuperGetMV("MV_MRPCINQ",.F.,.F.)
EndIf

If cDadosProd == "SBZ"
	cFilSBZ := xFilial("SBZ")
EndIf

If !lVisualiza
	//Verifica os dados para montar/visualizar arquivos do MRP
	For i:= 1 to 7
		If aOpcoes[1][i] = "x"
			nTipo := i
		EndIf
	Next i

	//Monta as datas de acordo com os parametros
	A712AtuPeriodo(lVisualiza,@nTipo,@dInicio,@aPeriodos,aOpcoes)

	If !lVisRes
		//Variaveis com a periodicidade de geracao de OPs e SCs.
		cSelPer := cSelPerSC:=Replicate("�",Len(aPeriodos))
		If aPergs711[10] == 1
			cSelF := cSelFSC := Replicate("�",Len(aPeriodos))
		Else
			cSelF := cSelFSC := Replicate(" ",Len(aPeriodos))
		EndIf

		If lBatch
			A712AltPer()
			lOpMax99 := lOpMaxAuto
		EndIf
	EndIf
EndIf

If !lBatch .And. !lVisRes .And. !lVisualiza
	AADD(aSays,OemToAnsi(STR0121))
	AADD(aSays,OemToAnsi(STR0122))
	AADD(aSays,OemToAnsi(STR0123))
	AADD(aButtons, { 1,.T.,{|o| nOpcA:= 1,If(MsgYesNo(OemToAnsi(STR0124),OemToAnsi(STR0030)),o:oWnd:End(),nOpcA:=2) } } )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	If aPergs711[4] == 2
		AADD(aButtons, { 5,.T.,{|o| cSelPerSC:=A712SelPer(cSelPerSc,STR0125,"SC",@cNumOpDig,@lOpMax99,@cSelFSC) }} )
		AADD(aButtons, { 5,.T.,{|o| cSelPer:=A712SelPer(cSelPer,STR0126,"OP",@cNumOpDig,@lOpMax99,@cSelF) }} )
	Else
		AADD(aButtons, { 5,.T.,{|o| cSelPerSC:=cSelPer:=A712SelPer(cSelPer,STR0125+" / "+STR0126,"SCOP",@cNumOpDig,@lOpMax99,@cSelF) }} )
	EndIf

	FormBatch(STR0030,aSays,aButtons,,200,450)
EndIf

ProcLogAtu("MENSAGEM","Inicio calculo MRP","Inicio calculo MRP")

If SuperGetMv('MV_A710THR',.F.,1) > 1
	lThreads := .T.
Endif

A712GrvTm(oCenterPanel,STR0034) //"Inicio do Processamento."

If !lVisualiza
	MATA712Ctb()
EndIf

If lVisRes
	If UsaNewPrc()
		nLin := aSize[6]-55
	Else
		nLin := aSize[6]
	EndIf

	//Definicao dos botoes da rotina
	aadd(aButtons,{'LOCALIZA'	,{|| (A712Pesq())},STR0035} ) //"Pesquisa Produto"
	aadd(aButtons,{'RELATORIO'	,{|| (lAtvFilTmp := lAtvFilNes, If(lAtvFilTmp,M712FilNec(.T.),.T.),MATR882(.T.),If(lAtvFilTmp,M712FilNec(.T.),.T.))},STR0036}) //"Imprime MRP"
	aadd(aButtons,{'BMPTRG'   	,{|| (lAtvFilTmp := lAtvFilNes, If(lAtvFilTmp,M712FilNec(.T.),.T.),A712Gera(@cNumOpDig,cStrTipo,cStrGrupo,@oTempTable),If(lAtvFilTmp,M712FilNec(.T.),.T.),Eval(bChange)) },STR0037} ) //"Geracao de OPs/SCs"

	//Define tipo de consulta de produto
	If aPergs711[28]==1 .And. !lBatch
		MENU oMenu2 POPUP
			MENUITEM STR0038 ACTION (A712ExpTre(),Eval(bChange)) //"Expande Detalhes"
			MENUITEM STR0039 ACTION (A712ShPrd(),Eval(bChange))   //"Dados do Produto"
		ENDMENU

		aadd(aButtons,{'VERNOTA',{|| If(lFlatMode,oMenu2:Activate(500,47,oDlg),oMenu2:Activate(220,30,oDlg)) },STR0039})
	Else
		aadd(aButtons,{'VERNOTA',{|| (A712ShPrd(),Eval(bChange)) },STR0039}) //"Dados do Produto"
	EndIf

	If lShAlt
		aadd(aButtons,{'SDUCOUNT' ,{|| A712ShAlt() },'Alternativos'})
	EndIf

	aadd(aButtons,{'FILTRO',{|| If(lFlatMode,oMenu1:Activate(nCol-290,aSize[2]+30,oDlg,.T.),oMenu1:Activate(445,30,oDlg,.T.))},STR0040,STR0041}) //"Mostra somente as necessidades" //'Filtro'
	aadd(aButtons,{'FORM',{|| A712ViewSld(aFilAlmox)},STR0042}) //"Det.Saldo"

	//Executa ponto de entrada para montar array com botoes a serem apresentados na tela
	If (ExistBlock( "M710BUT" ) )
		aADDButtons := ExecBlock("M710BUT",.F.,.F.)
		If ValType(aADDButtons) == "A"
			For i := 1 to Len(aADDButtons)
				AADD(aButtons,aADDButtons[i])
			Next i
		EndIf
	Endif

	//Caso gere o Log habilita o botao de consulta
	If lLogMRP
		AADD(aButtons,{'DESTINOS' ,{|| (A712ShLog(),Eval(bChange))},STR0019,STR0043}) //"Log de eventos do MRP" //"Log"
	EndIf
EndIf

If lVisualiza
	//Recupera parametrizacao gravada no ultimo processamento
	dbSelectArea("CZI")
	dbSetOrder(2)
	dbSeek(xFilial("CZI")+"PAR")
	While CZI->CZI_ALIAS == "PAR"
		nTipo       := CZI->CZI_NRRGAL
		dInicio     := CZI->CZI_DTOG
		nPeriodos   := CZI->CZI_QUANT
		aOpcoes[2,1]:= CZI->CZI_QUANT

		//Verifica se o exibe os dados resumido de acordo com o ultimo calculo
		//lParResu := AllTrim(CZI->CZI_ITEM) == "1"
		If nTipo == 7
			AADD(aDiversos,CTOD(Alltrim(CZI->CZI_OPCORD)))
		EndIf

		//NUMERO DO MRP
		c711NumMRP := CZI->CZI_NRMRP
		dbSkip()
	EndDo

	If nTipo == 7
		//Correcao do array adiversos
		aDiversos := ASORT(aDiversos)
		//Transforma data em caracter
		For i := 1 to Len(aDiversos)
			aDiversos[i] := DTOC(aDiversos[i])
		Next i
	EndIf

	//Monta as datas de acordo com os parametros
	A712AtuPeriodo(lVisualiza,@nTipo,@dInicio,@aPeriodos,aOpcoes)

	If cPaisLoc == "RUS" .And. Len(aPeriodos) > 250
		Help( ,, 'MATA712',, STR0153, 1, 0 )	//"Visualization is not available for more than 250 periods."
		Return
	EndIf

	A712GrvTm(oCenterPanel,STR0044)
Else
	If (oCenterPanel <> Nil)
		oCenterPanel:SetRegua2(7)//oito processamentos
	EndIf
	// Grava as informacoes do processamento no arquivo CZI colocando informacoes
	// que garantam que o registro nao ira aparecer
	// Alias PAR                                -> CZI_ALIAS
	// Tipo utilizado                           -> CZI_NRRGAL
	// Data inicial                             -> CZI_DTOG
	// Numero de periodos                       -> CZI_QUANT
	// Para periodos variaveis data em caracter -> CZI_OPC
	// Opca Resumido ("1" Sim / "2" Nao)        -> CZI_ITEM
	If nTipo != 7
		A712CriCZI(aPeriodos[1],/*02*/,/*03*/,/*04*/,"PAR",nTipo,/*07*/,Alltrim(Str(aPergs711[28])),/*09*/,nPeriodos,"1",.F.,/*13*/,/*14*/,.F.,/*16*/,/*17*/,/*18*/,/*19*/,cStrTipo,cStrGrupo,/*22*/,/*23*/,/*24*/,/*25*/,"01")
	Else
		For i:=1 to Len(aDiversos)
			A712CriCZI(dDatabase,/*02*/,aDiversos[i],/*04*/,"PAR",nTipo,/*07*/,Alltrim(Str(aPergs711[28])),/*09*/,Len(aPeriodos),"1",.F.,aPergs711[28]==1,/*14*/,.F.,/*16*/,/*17*/,/*18*/,/*19*/,cStrTipo,cStrGrupo,/*22*/,/*23*/,/*24*/,/*25*/,"01")
		Next
	EndIf
	A712GrvTm(oCenterPanel,STR0045) //"Termino da Montagem do Arquivo de Trabalho."

	If aPergs711[11] == 1
		FWMsgRun(,{|lEnd| MTApagaPre(,,,,,oCenterPanel,.T.)},STR0157,STR0154) //""Apagando OPs/SCs/AEs previstas"" //"Aguarde"
		A712GrvTm(oCenterPanel,STR0046) //"Termino da delecao das OPs e SCs Previstas."
		If cIntgPPI != "1"
			//Inicia a thread para rodar a integra��o das OP's excluidas.
			StartJob("A712IntPPI",GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,c711NumMRP,cIntgPPI,__cUserId,aDelOpsPPI,.T.)

			//Neste ponto, apenas valida se conseguiu subir a thread.
			//ap�s subir a thread, deixa executando e antes de fechar o MRP � feita a valida��o da thread em execu��o.
			//Apenas vai fechar o MRP quando terminar o processamento da thread.
			While .T.
				Do Case
					//TRATAMENTO PARA ERRO DE SUBIDA DE THREAD
					Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '0'
						If nRetry_0 > 50
							//Conout(Replicate("-",65))
							//Conout("MATA712: "+ "N�o foi possivel realizar a subida da thread 'A712IntPPI'")
							//Conout(Replicate("-",65))

							//Atualiza o log de processamento
							ProcLogAtu("MENSAGEM","N�o foi possivel realizar a subida da thread 'A712IntPPI'","N�o foi possivel realizar a subida da thread 'A712IntPPI'")
							Final(STR0166) //"N�o foi possivel realizar a subida da thread 'A712IntPPI'"
						Else
							nRetry_0 ++
						EndIf

					//TRATAMENTO PARA ERRO DE CONEXAO
					Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '10'
						If nRetry_1 > 5
							//Conout(Replicate("-",65))
							//Conout("MATA712: Erro de conexao na thread 'A712IntPPI'")
							//Conout("Numero de tentativas excedidas")
							//Conout(Replicate("-",65))

							//Atualiza o log de processamento
							ProcLogAtu("MENSAGEM","MATA712: Erro de conexao na thread 'A712IntPPI'","MATA712: Erro de conexao na thread 'A712IntPPI'")
							Final(STR0167) //"MATA712: Erro de conexao na thread 'A712IntPPI'"
						Else
							//Inicializa variavel global de controle de Job
							PutGlbValue("A712IntPPI"+cEmpAnt+cFilAnt,"0")
							GlbUnLock()

							//Reiniciar thread
							//Conout(Replicate("-",65))
							//Conout("MATA712: Erro de conexao na thread 'A712IntPPI'")
							//Conout("Tentativa numero: " + StrZero(nRetry_1,2))
							//Conout(Replicate("-",65))

							//Atualiza o log de processamento
							ProcLogAtu("MENSAGEM","Reiniciando a thread : A712IntPPI","Reiniciando a thread : A712IntPPI")

							//Dispara thread para Stored Procedure
							StartJob("A712IntPPI",GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,c711NumMRP,cIntgPPI,__cUserId)
						EndIf
						nRetry_1++

					//TRATAMENTO PARA ERRO DE APLICACAO
					Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '20'
						//Conout(Replicate("-",65))
						//Conout("MATA712: Erro ao efetuar a conex�o na thread 'A712IntPPI'")
						//Conout(Replicate("-",65))

						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","MATA712: Erro ao efetuar a conex�o na thread 'A712IntPPI'","MATA712: Erro ao efetuar a conex�o na thread 'A712IntPPI'")
						Final(STR0167) //"MATA712: Erro ao efetuar a conex�o na thread 'A712IntPPI'"
					Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '2'
						//Thread iniciou processamento, continua a execu��o do programa.
						//Conout("MATA712: Thread A712IntPPI iniciou o processamento.")
						Exit
					Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '3'
						//J� finalizou o processamento.
						Exit
					Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '30'
						//J� finalizou o processamento. mas com erros.
						//Conout(GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt+"ERRO"))
						Exit
					EndCase
					Sleep(500)
			End
		EndIf
	EndIf

	//Atualiza Niveis das Estruturas
	If ExistBlock ("M710NIV")
		M710Niv := ExecBlock("M710NIV",.F.,.F.)
		If ValType(M710NIV) != "L"
			M710Niv := .F.
		EndIf
	EndIf

	If M710Niv .Or. (SuperGETMV("MV_NIVALT",.F.,"N") == "S"  .and. lCalcNivelEstr)
		MA320Nivel(Nil,.t.,.f.)
		A712GrvTm(oCenterPanel,STR0047) //"Termino do Recalculo dos Niveis das Estruturas."
	EndIf

	//Monta Saldo Inicial por MULT-THREAD
	If lThreads .And. (lPrcPad .Or. aPergs711[18] == 2)
		//Atualiza o log de processamento
		ProcLogAtu("MENSAGEM","Iniciando Montagem do Saldo Inicial","Iniciando Montagem do Saldo Inicial")

		//Calcula Quebra por Threads
		aThreads := MATA712TB1(@cQueryB1)
		//ProcRegua(((Len(aThreads)*2) + 8))

		For nX := 1 to Len(aThreads)
			//IncProc()

			//Informacoes do semaforo
			cJobFile:= cStartPath + CriaTrab(Nil,.F.)+".job"

			//Adiciona o nome do arquivo de Job no array aJobAux
			aAdd(aJobAux,{StrZero(nX,2),cJobFile})

			//Inicializa variavel global de controle de thread
			cJobAux := "c712P" + cEmpAnt + cFilAnt + StrZero(nX,2)
			PutGlbValue(cJobAux,"0")
			GlbUnLock()

			//Atualiza o log de processamento
			ProcLogAtu("MENSAGEM","Iniciando Montagem do Saldo Inicial - Thread:" + StrZero(nX,2),"Iniciando Montagem do Saldo Inicial - Thread:" + StrZero(nX,2))

			//Dispara thread para Stored Procedure
			StartJob("A712JOBINI",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aThreads[nX,1],cJobFile,StrZero(nX,2),aPeriodos,aPergs711,c711NumMrp,cStrTipo,cStrGrupo,cTxtEstSeg,cRev711Vaz,lExistBB1,lExistBB2,lM710NOPC,lLogMRP,cTxtPontPed,aAlmoxNNR,nTipo,{cPictLOCAL,cPictQATU,cPictQNPT,cPictQTNP,cPictQTDE,cPictSALDO},cSelOpc)

		Next nX

        IF lMrpEmax .AND. LEN(aThreads) > 0
        	a712LogEM(aThreads)
        Endif

		//Controle de Seguranca para MULTI-THREAD
		For nX := 1 to Len(aThreads)
			nRetry_0 := 0
			nRetry_1 := 0
			
			nPos := ASCAN(aJobAux,{|x| x[1] == StrZero(nX,2)})

			//Informacoes do semaforo
			cJobFile := aJobAux[nPos,2]

			//Inicializa variavel global de controle de thread
			cJobAux :="c712P"+cEmpAnt+cFilAnt+StrZero(nX,2)

			While .T.
				Do Case
					//TRATAMENTO PARA ERRO DE SUBIDA DE THREAD
					Case GetGlbValue(cJobAux) == '0'
						If nRetry_0 > 50
							//Conout(Replicate("-",65))
							//Conout("MATA712: "+ "N�o foi possivel realizar a subida da thread" + " " + StrZero(nX,2))
							//Conout(Replicate("-",65))

							//Atualiza o log de processamento
							ProcLogAtu("MENSAGEM","N�o foi possivel realizar a subida da thread","N�o foi possivel realizar a subida da thread") //"N�o foi possivel realizar a subida da thread"
							Final(STR0161 ) // "N�o foi possivel realizar a subida da thread"
						Else
							nRetry_0 ++
						EndIf

					//TRATAMENTO PARA ERRO DE CONEXAO
					Case GetGlbValue(cJobAux) == '1'
						If FCreate(cJobFile) # -1
							If nRetry_1 > 5
								//Conout(Replicate("-",65))
								//Conout("MATA712: Erro de conexao na thread")
								//Conout("Thread numero : " + StrZero(nX,2) )
								//Conout("Numero de tentativas excedidas")
								//Conout(Replicate("-",65))

								//Atualiza o log de processamento
								ProcLogAtu("MENSAGEM","MATA712: Erro de conexao na thread","MATA712: Erro de conexao na thread")
								Final(STR0162) //"MATA712: Erro de conexao na thread"
							Else
				    			//Inicializa variavel global de controle de Job
								PutGlbValue(cJobAux,"0")
								GlbUnLock()

								//Reiniciar thread
								//Conout(Replicate("-",65))
								//Conout("MATA712: Erro de conexao na thread")
								//Conout("Tentativa numero: "		+StrZero(nRetry_1,2))
								//Conout("Reiniciando a thread : "+StrZero(nX,2))
								//Conout(Replicate("-",65))

								//Atualiza o log de processamento
								ProcLogAtu("MENSAGEM","Reiniciando a thread : " + StrZero(nX,2),"Reiniciando a thread : " + StrZero(nX,2))

								//Dispara thread para Stored Procedure
								StartJob("A712JOBINI",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aThreads[nX,1],cJobFile,StrZero(nX,2),aPeriodos,aPergs711,c711NumMrp,cStrTipo,cStrGrupo,cTxtEstSeg,cRev711Vaz,lExistBB1,lExistBB2,lM710NOPC,lLogMRP,cTxtPontPed,aAlmoxNNR,nTipo,{cPictLOCAL,cPictQATU,cPictQNPT,cPictQTNP,cPictQTDE,cPictSALDO})
							EndIf
							nRetry_1 ++
						EndIf

					//TRATAMENTO PARA ERRO DE APLICACAO
					Case GetGlbValue(cJobAux) == '2'
						If FCreate(cJobFile) # -1
							//Conout(Replicate("-",65))
							//Conout("MATA712: Erro de aplicacao na thread ")
							//Conout("Thread numero : "+StrZero(nX,2))
							//Conout(Replicate("-",65))

							//Atualiza o log de processamento
							ProcLogAtu("MENSAGEM","MATA712: Erro de aplicacao na thread","MATA712: Erro de aplicacao na thread")
							Final(STR0163) //"MATA712: Erro de aplicacao na thread"
						EndIf

					//THREAD PROCESSADA CORRETAMENTE
					Case GetGlbValue(cJobAux) == '3'
						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","Termino da Montagem do Saldo Inicial - Thread:" + StrZero(nX,2),"Termino da Montagem do Saldo Inicial - Thread:" + StrZero(nX,2))
						//IncProc()
						Exit
				EndCase
				Sleep(500)
			End
		Next nX
	ElseIf lPrcPad .Or. aPergs711[18] == 2
		//Atualiza LOG
		ProcLogAtu("MENSAGEM","Iniciando Montagem do Saldo Inicial","Iniciando Montagem do Saldo Inicial")

		//Monta Saldo Inicial
		dbSelectArea("SB1")
		If (oCenterPanel <> Nil)
			oCenterPanel:SetRegua1(SB1->(LastRec()))
		EndIf

		cFilSB1 := xFilial("SB1")
		cAliasTop := "ITENS"
		//Projeto Implementeacao de campos MRP e FANTASM no SBZ
		If cDadosProd == "SBZ"
			//Query principal de itens
			cQuery := " SELECT SB1.B1_FILIAL, " +;
			                 " SB1.B1_COD, " +;
			                 " COALESCE(BZ_FANTASM,B1_FANTASM) B1_FANTASM, " +;
			                 " COALESCE(BZ_MRP,B1_MRP) B1_MRP,     " +;
			                 " SB1.B1_TIPO, " +;
			                 " SB1.B1_GRUPO, " +;
			                 " SB1.B1_REVATU, " +;
			                 " COALESCE(BZ_OPC,B1_OPC) B1_OPC, " +;
			                 " SB1.R_E_C_N_O_ B1REC, " +;
			                 " COALESCE(BZ_EMIN,B1_EMIN) B1_EMIN, " +;
			                 " COALESCE(BZ_ESTFOR,B1_ESTFOR) B1_ESTFOR, " +;
			                 " COALESCE(BZ_EMAX,B1_EMAX) B1_EMAX, " +;
			                 " SB1.B1_DESC " +;
			            " FROM "+RetSqlName("SB1")+" SB1 Left Outer Join "+RetSqlName("SBZ")+" SBZ " +;
		  	              " ON BZ_FILIAL = '"+cFilSBZ+"' " +;
		  	             " AND BZ_COD    = B1_COD AND SBZ.D_E_L_E_T_ = ' ' " +;
		  	           " WHERE "

			//Query com a clausula WHERE
			cQueryX1 := "      SB1.B1_FILIAL='"+cFilSB1+"' "
			cQueryX1 += "  AND COALESCE(BZ_FANTASM, B1_FANTASM) <> 'S' "
			cQueryX1 += "  AND COALESCE(BZ_MRP,     B1_MRP    ) IN (' ','S') "
			cQueryX1 += "  AND SB1.D_E_L_E_T_ = ' ' "
			cQueryX1 += " AND B1_MSBLQL<>'1'" //ITEM BLOQUEADO
		Else
			//Query principal de itens
			cQuery := " SELECT B1_FILIAL, " +;
			                 " B1_COD, " +;
			                 " B1_FANTASM, " +;
			                 " B1_MRP, " +;
			                 " B1_TIPO, " +;
			                 " B1_GRUPO, " +;
			                 " B1_REVATU, " +;
		  	                 " B1_OPC, " +;
			                 " R_E_C_N_O_ B1REC, " +;
			                 " B1_EMIN, " +;
			                 " B1_ESTFOR, " +;
			                 " B1_EMAX, " +;
			                 " B1_DESC " +;
			            " FROM "+RetSqlName("SB1")+" SB1 " +;
			           " WHERE "

			//Query com a clausula WHERE
			cQueryX1 := "     SB1.B1_FILIAL   = '"+cFilSB1 +"' "
			cQueryX1 += " AND SB1.B1_FANTASM <> 'S' "
			cQueryX1 += " AND SB1.D_E_L_E_T_  = ' ' "
			cQueryX1 += " AND SB1.B1_MRP     IN (' ','S')"
			cQueryX1 += " AND B1_MSBLQL<>'1'" //ITEM BLOQUEADO
		Endif

		//Query com o filtro para os JOBS
		cQueryB1 := "  AND SB1.B1_FILIAL   = '"+cFilSB1+"' "
 		cQueryB1 += "  AND SB1.B1_FANTASM <> 'S' "
		cQueryB1 += "  AND SB1.D_E_L_E_T_  = ' ' "
		cQueryB1 += "  AND B1_MSBLQL<>'1'" //ITEM BLOQUEADO
		If cDadosProd == "SBZ"
			cQueryB1 += "  AND ( (SELECT COUNT(*) "
			cQueryB1 +=           " FROM " + RetSqlName("SBZ") + " SBZ "
			cQueryB1 +=          " WHERE SBZ.BZ_FILIAL = '"+cFilSBZ+"' "
			cQueryB1 +=            " AND SB1.D_E_L_E_T_ = ' ' "
			cQueryB1 +=            " AND SB1.B1_MSBLQL<>'1'" //ITEM BLOQUEADO
			cQueryB1 +=            " AND SBZ.D_E_L_E_T_ = ' ' "
			cQueryB1 +=            " AND SB1.B1_COD    = SBZ.BZ_COD "
			cQueryB1 +=            " ) > 0   "

			cQueryB1 += "  AND  (SELECT COUNT(*) "
			cQueryB1 +=           " FROM " + RetSqlName("SBZ") + " SBZ "
			cQueryB1 +=          " WHERE SBZ.BZ_FILIAL = '"+cFilSBZ+"' "
			cQueryB1 +=            " AND SB1.D_E_L_E_T_ = ' ' "
			cQueryB1 +=            " AND SB1.B1_MSBLQL<>'1'" //ITEM BLOQUEADO
			cQueryB1 +=            " AND SBZ.D_E_L_E_T_ = ' ' "
			cQueryB1 +=            " AND SB1.B1_COD    = SBZ.BZ_COD "
			cQueryB1 +=            " AND SBZ.BZ_MRP IN ( ' ', 'S' ) ) > 0   "


			cQueryB1 +=       	   " OR ( (SELECT COUNT(*) "
			cQueryB1 +=            " FROM " + RetSqlName("SBZ") + " SBZ "
			cQueryB1 +=            " WHERE SBZ.BZ_FILIAL = '"+cFilSBZ+"' "
			cQueryB1 +=            " AND SB1.D_E_L_E_T_ = ' ' "
			cQueryB1 +=            " AND SB1.B1_MSBLQL<>'1'" //ITEM BLOQUEADO
			cQueryB1 +=            " AND SBZ.D_E_L_E_T_ = ' ' "
			cQueryB1 +=            " AND SB1.B1_COD = SBZ.BZ_COD "
			cQueryB1 +=            " ) = 0 "
			cQueryB1 +=            " AND SB1.B1_MRP = 'S' ) )"
		Else
			cQueryB1 += "  AND SB1.B1_MRP     IN (' ','S')"
		EndIf

		//Caso n�o tenha sido selecionado todos, coloca TIPOS na QUERY
		If !lAllTp
			cQueryX1 += " AND SB1.B1_TIPO IN (SELECT TP_TIPO FROM " +cNomCZITTP +") "
			cQueryB1 += " AND SB1.B1_TIPO IN (SELECT TP_TIPO FROM " +cNomCZITTP +") "
		EndIf

		//Caso n�o tenha sido selecionado todos e o parametro estiver marcado, coloca os GRUPOS na QUERY
		If !lAllGrp .And. lMRPCINQ
			cQueryX1 += " AND SB1.B1_GRUPO IN (SELECT GR_GRUPO FROM " +cNomCZITGR +") "
			cQueryB1 += " AND SB1.B1_GRUPO IN (SELECT GR_GRUPO FROM " +cNomCZITGR +") "
		End If

		//CH TRAAXW - Inicio

		/*/Filtra o item j� com o local do parametro
		If !Empty(aPergs711[8])
			cQueryX1 += " AND SB1.B1_LOCPAD >= '" + aPergs711[8] + "' "
		EndIf

		//Filtra o item j� com o local do parametro
		If !Empty(aPergs711[9])
			cQueryX1 += " AND SB1.B1_LOCPAD <= '" + aPergs711[9] + "' "
		EndIf

		//Filtra se foi informado locais
		If aAlmoxNNR # Nil
			cQueryX1 += " AND SB1.B1_LOCPAD IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
		EndIf*/

		//CH TRAAXW - Fim

		cQuery:= ChangeQuery(cQuery + cQueryX1)

		If lA710SQL
 			cA710Fil := ExecBlock("A710SQL", .F., .F., {"SB1", cQuery})
			If ValType(cA710Fil) == "C"
				cQuery := cA710Fil
			Endif
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
		aEval(SB1->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})

		A712GrvTm(oCenterPanel,STR0048) //"Termino do Filtro no Arquivo SB1."
		dbSelectArea(cAliasTop)

		While !Eof()

			SB1->(dbGoTo((cAliasTop)->(B1REC)))
			If cDadosProd == "SBZ"
				If SBZ->(dbSeek(cFilSBZ+SB1->B1_COD))
					mOpc := SBZ->BZ_MOPC
				Else
					mOpc := SB1->B1_MOPC
				EndIf
			Else
				mOpc := SB1->B1_MOPC
			EndIf

			If (oCenterPanel <> Nil)
				oCenterPanel:IncRegua1(OemToAnsi(STR0049))
			EndIf

			aFilAlmox := RetExecBlock("A710FILALM", {(cAliasTop)->B1_COD, cAlmoxd, cAlmoxa}, "A", Nil,NIL,NIL,lExistBB1)
			cMT710B2  := RetExecBlock("MT710B2"   , {(cAliasTop)->B1_COD, cAlmoxd, cAlmoxa}, "C", Nil,NIL,NIL,lExistBB2)

			If ValType(aFilAlmox) == "A" .And. aScan(aFilAlmox, {|z| ValType(z) # "C"}) > 0
				aFilAlmox := Nil
			Endif

			//Inicializa variaveis de saldo, estoque de seguranca e ponto de pedido
			nSaldo := 0
			nEstSeg := 0

			//Obtem saldo, estoque de seguranca
			A712DSaldo((cAliasTop)->B1_COD,@nSaldo,@aFilAlmox,/*04*/,/*05*/,@nEstSeg,cAliasTop)

			//Ponto de Entrada MA710NOPC para indicar saldo por opcional
			If lM710NOPC
				aOpc := ExecBlock('M710NOPC',.F.,.F.,{(cAliasTop)->B1_COD,nSaldo})
				If ValType(aOpc) == 'A'
					For nz := 1 to Len(aOpc)
						// Avalia o LOG do MRP para o evento 001 - Saldo em estoque inicial menor que zero
						A712CriaLOG("001",(cAliasTop)->B1_COD,{aOPc[nz,2]},lLogMRP,c711NumMrp)
						cRevisao := If(A712TrataRev() .And. Len(aOpc[nz]) >= 3, aOpc[nz, 3], cRev711Vaz)
						A712CriCZJ((cAliasTop)->B1_COD,/*02*/,cRevisao,/*04*/,"001",aOPc[nz,2],"1",cAliasTop,/*09*/,cStrTipo,cStrGrupo,.F.,aOPc[nz,1])
					Next nz
				Else
					// Avalia o LOG do MRP para o evento 001 - Saldo em estoque inicial menor que zero
					A712CriaLOG("001",(cAliasTop)->B1_COD,{nSaldo},lLogMRP,c711NumMrp)
					A712CriCZJ((cAliasTop)->B1_COD,IIF(cSelOpc == 'S',RetFldProd((cAliasTop)->B1_COD,"B1_OPC",cAliasTop),CriaVar("B1_OPC")),cRev711Vaz,/*04*/,"001",nSaldo,"1",cAliasTop,/*09*/,cStrTipo,cStrGrupo,.F.,IIF(cSelOpc == 'S',mOpc,CriaVar("B1_MOPC")))
				EndIf
			Else
				//Avalia o LOG do MRP para o evento 001 - Saldo em estoque inicial menor que zero
				A712CriaLOG("001",(cAliasTop)->B1_COD,{nSaldo},lLogMRP,c711NumMrp)
				A712CriCZJ((cAliasTop)->B1_COD,IIF(cSelOpc == 'S',RetFldProd((cAliasTop)->B1_COD,"B1_OPC",cAliasTop),CriaVar("B1_OPC")),cRev711Vaz,/*04*/,"001",nSaldo,"1",cAliasTop,/*09*/,cStrTipo,cStrGrupo,.F.,IIF(cSelOpc == 'S',mOpc,CriaVar("B1_MOPC")))
			EndIf

			If aPergs711[31] == 1
				nPontoPed := (cAliasTop)->B1_EMIN
			EndIf

			//Checa informacoes para inclusao no tree
			nQtdAviso := 0
			cMsgAviso := ""

			//Valida opcionais na estrutura e se tem opcionas default
			cProdx 		:= (cAliasTop)->B1_COD
			lOpcOK := MT712VLOPC(cProdx, cretx, aRetrOpcx, cProPaix, cProAntx, , ,.F. , 1 )

			//Caso o estoque de seguranca esteja preenchido
			If QtdComp(nEstSeg,.T.) > QtdComp(0,.T.)
				IF ! lOpcOK
					nQtdAviso := 0
				Else
					nQtdAviso := nEstSeg
					cMsgAviso := RetTitle("B1_ESTSEG")
				EndIf

			EndIf

			//Checa informacoes para inclusao no tree
			nQtdPontP := 0
			cMsgPontP := ""
			//Caso o ponto de pedido esteja preenchido
			If QtdComp(nPontoPed,.T.) > QtdComp(0,.T.)

				IF ! lOpcOK
					nQtdPontP := 0
				Else
					nQtdPontP:=nPontoPed
					cMsgPontP:=RetTitle("B1_EMIN")
				ENDIF

			EndIf

			//VALIDA ESTOQUE MAXIMA
			lMrpSeg :=  .T.
			nEstmax := 0
			If lMrpEmax  //Visualizar estoque Maximo

				IF (cAliasTop)->B1_EMAX > 0
				 	nEstmax := (cAliasTop)->B1_EMAX

				If nQtdAviso > 0
				 	cMsgAviso := ALLTRIM(cMsgAviso) + " / Estoque Maximo"
				 	lMrpSeg := .F.

				ProcLogAtu("MENSAGEM", "Produto com Estoque Maximo: "+ALLTRIM((cAliasTop)->B1_COD)+' - '+" QTD: "+ALLTRIM(CVALTOCHAR((cAliasTop)->B1_EMAX)) ,;
				                       "Produto com Estoque Maximo: "+(cAliasTop)->B1_COD+' - '+(cAliasTop)->B1_DESC+" QTD: "+CVALTOCHAR((cAliasTop)->B1_EMAX) )

				EndIf

				Endif

			EndIF

			If QtdComp(nSaldo,.T.) < QtdComp(0,.T.) .And. QtdComp((Abs(nSaldo)-(IF(nEstSeg>0,nEstSeg,0))),.T.) > QtdComp(0,.T.)
				A712CriCZI(aPeriodos[1],(cAliasTop)->B1_COD,(cAliasTop)->B1_OPC, IIF(lPCPREVATU , PCPREVATU((cAliasTop)->B1_COD), (cAliasTop)->B1_REVATU ) /*(cAliasTop)->B1_REVATU*/,"SB2",0,STR0177,/*08*/,/*09*/,(Abs(nSaldo)-(IF(nEstSeg>0,nEstSeg,0))),/*11*/,.F.,.F.,cAliasTop,.F.,/*16*/,/*17*/,/*18*/,/*19*/,cStrTipo,cStrGrupo,/*22*/,/*23*/,/*24*/,mOpc,/*26*/) //"Saldo Negativo"
			EndIf

			//Monta no tree
			If QtdComp(nQtdAviso,.T.) > QtdComp(0,.T.)
				A712CriCZI(aPeriodos[1],(cAliasTop)->B1_COD,(cAliasTop)->B1_OPC,IIF(lPCPREVATU , PCPREVATU((cAliasTop)->B1_COD), (cAliasTop)->B1_REVATU ),"SB1",(cAliasTop)->B1REC,cMsgAviso,/*08*/,/*09*/,nQtdAviso,/*11*/,.F.,.F.,cAliasTop,.F.,/*16*/,/*17*/,/*18*/,/*19*/,cStrTipo,cStrGrupo,/*22*/,/*23*/,/*24*/,mOpc,/*26*/)
			EndIf

			//Monta no tree
			If QtdComp(nQtdPontP,.T.) > QtdComp(0,.T.)
				A712CriCZI(aPeriodos[1],(cAliasTop)->B1_COD,(cAliasTop)->B1_OPC,IIF(lPCPREVATU , PCPREVATU((cAliasTop)->B1_COD), (cAliasTop)->B1_REVATU ),"SB1",(cAliasTop)->B1REC,cMsgPontP,/*08*/,/*09*/,nQtdPontP,/*11*/,.F.,.F.,cAliasTop,.F.,/*16*/,/*17*/,/*18*/,/*19*/,cStrTipo,cStrGrupo,/*22*/,/*23*/,/*24*/,mOpc,/*26*/)
			EndIf

			// Monta tree se tiver ESTOQUE MAXIMO
			If nEstmax > 0 .AND. lMrpEmax .AND. lMrpSeg
				A712CriCZI(aPeriodos[1],(cAliasTop)->B1_COD,(cAliasTop)->B1_OPC,IIF(lPCPREVATU , PCPREVATU((cAliasTop)->B1_COD), (cAliasTop)->B1_REVATU ),"SB1",(cAliasTop)->B1REC,"Estoque Maximo",/*08*/,/*09*/,0,/*11*/,.F.,.F.,cAliasTop,.F.,/*16*/,/*17*/,/*18*/,/*19*/,cStrTipo,cStrGrupo,/*22*/,/*23*/,/*24*/,mOpc,/*26*/)
				ProcLogAtu("MENSAGEM", "Produto com Estoque Maximo: "+ALLTRIM((cAliasTop)->B1_COD)+' - '+" QTD: "+ALLTRIM(CVALTOCHAR((cAliasTop)->B1_EMAX)) ,;
				                       "Produto com Estoque Maximo: "+(cAliasTop)->B1_COD+' - '+(cAliasTop)->B1_DESC+" QTD: "+CVALTOCHAR((cAliasTop)->B1_EMAX) )
			EndIf

		dbSelectArea(cAliasTop)
			dbSkip()
		End

		If (oCenterPanel <> Nil)
			oCenterPanel:IncRegua2()
		EndIf

		dbSelectArea(cAliasTop)
		dbCloseArea()
	Else
		ProcLogAtu("MENSAGEM","Iniciando Montagem do Saldo Inicial","Iniciando Montagem do Saldo Inicial")
		prcSldIni(@cQueryB1,lAllTp,lAllGrp,cAlmoxd,cAlmoxa,aPeriodos,cStrTipo,cStrGrupo)
	Endif


	//Atualiza LOG
	ProcLogAtu("MENSAGEM","Fim Montagem do Saldo Inicial","Fim Montagem do Saldo Inicial")

	DatFim    := MATA712DtF()
	lProcSC4 := aPergs711[1] == 1 .And. (aPergs711[30] == 1 .Or. aPergs711[17] == 1)

	If !lPrcPad
		/*---------------INICIO PROCESSAMENTO SC1-----------------*/
		procSC1(cQueryB1,cAlmoxd,cAlmoxa,DatFim,aPeriodos,lConsSusp,lConsSacr)

		/*---------------INICIO PROCESSAMENTO SC7-----------------*/
		procSC7(cQueryB1,cAlmoxd,cAlmoxa,DatFim,aPeriodos,lConsSusp,lConsSacr)

		/*---------------INICIO PROCESSAMENTO SC2-----------------*/
		procSC2(cQueryB1,cAlmoxd,cAlmoxa,DatFim,aPeriodos,lConsSusp,lConsSacr)

		/*---------------INICIO PROCESSAMENTO SD4-----------------*/
		procSD4(cQueryB1,cAlmoxd,cAlmoxa,DatFim,aPeriodos,lConsSusp,lConsSacr)

		If lPedido
			U_procSC6(cQueryB1,cAlmoxd,cAlmoxa,DatFim,aPeriodos,cComp1,cComp2)
		EndIf

		/*---------------INICIO PROCESSAMENTO AFJ-----------------*/
		procAFJ(cQueryB1,DatFim,aPeriodos)

		If aPergs711[1] == 1
			/*---------------INICIO PROCESSAMENTO SC4-----------------*/
			U_procSC4(cQueryB1,cAlmoxd,cAlmoxa,DatFim,aPeriodos,cComp1,cComp2,nTipo)
		ElseIf aPergs711[1] == 2
			/*---------------INICIO PROCESSAMENTO SHC-----------------*/
			procSHC(cQueryB1,DatFim,aPeriodos)
		EndIf

		If aPergs711[29] == 1
			/*---------------INICIO PROCESSAMENTO SB8-----------------*/
			//Monta Lotes Vencidos
			procSB8(cQueryB1,cAlmoxd,cAlmoxa,DatFim,aPeriodos)
		EndIf

		//Atualiza as tabelas CZJ e CZK.
		procTabMRP()
	Else
		/*---------------INICIO JOBSC1-----------------*/
		//Monta Solicitacoes de Compra
		cAliasTop := "BUSCASC1"

		//Atualiza o log de processamento
		ProcLogAtu("MENSAGEM","Iniciando Processamento SC1","Iniciando Processamento SC1")

		PutGlbValue("A712JobC1","0")
		GlbUnLock()

		//Parametros para o Job
		aParamJob := {c711NumMRP,nTipo,aPeriodos,aPergs711,cStrTipo,cStrGrupo,cAliasTop,cAlmoxd,cAlmoxa,cQueryB1,lA710Sql,cOpc711Vaz,cRev711Vaz,lLogMrp,lConsPreRe,aAlmoxNNR,DatFim,cNomCZINNR}

		//Array com jobs inicializados
		cFileJob := cStartPath+CriaTrab(,.F.)+".job"

		//Para seguranca, apaga se existir
		FErase(cFileJob)
		AADD(aListaJob,{"A712JobC1",aParamJob,Seconds(),cFileJob})

		//Processa thread
		StartJob("A712JobC1",GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob)


		/*---------------INICIO JOBSC7-----------------*/
		//Monta Pedidos de Compra
		cAliasTop := "BUSCASC7"

		//Atualiza o log de processamento
		ProcLogAtu("MENSAGEM","Iniciando Processamento SC7","Iniciando Processamento SC7")

		//Inicializa variavel global de controle de thread
		PutGlbValue("A712JobC7","0")
		GlbUnLock()

		//Parametros para o Job
		aParamJob := {c711NumMRP,nTipo,aPeriodos,aPergs711,cStrTipo,cStrGrupo,cAliasTop,cAlmoxd,cAlmoxa,cQueryB1,lA710Sql,cOpc711Vaz,cRev711Vaz,lLogMRP,aAlmoxNNR,DatFim,cNomCZINNR}

		//Array com jobs inicializados
		cFileJob := cStartPath+CriaTrab(,.F.)+".job"

		//Para seguranca, apaga se existir
		FErase(cFileJob)
		AADD(aListaJob,{"A712JobC7",aParamJob,Seconds(),cFileJob})

		//Processa thread
		StartJob("A712JobC7",GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob)

		/*---------------INICIO JOBSC2-----------------*/
		//Monta Ordens de Producao
		cAliasTop := "BUSCASC2"

		//Atualiza o log de processamento
		ProcLogAtu("MENSAGEM","Iniciando Processamento SC2","Iniciando Processamento SC2")

		//Inicializa variavel global de controle de thread
		PutGlbValue("A712JobC2","0")
		GlbUnLock()

		//Parametros para o Job
		aParamJob := {c711NumMRP,nTipo,aPeriodos,cStrTipo,cStrGrupo,cAliasTop,cAlmoxd,cAlmoxa,cQueryB1,lA710Sql,lConsSusp,lConsSacr,lLogMRP,aPergs711,aAlmoxNNR,DatFim,cNomCZINNR}

		//Array com jobs inicializados
		cFileJob:=cStartPath+CriaTrab(,.F.)+".job"

		//Para seguranca, apaga se existir
		FErase(cFileJob)
		AADD(aListaJob,{"A712JobC2",aParamJob,Seconds(),cFileJob})

		//Processa thread
		StartJob("A712JobC2",GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob,lUsaMOpc)

		/*---------------INICIO JOBSD4-----------------*/
		//Monta Empenhos
		cAliasTop := "BUSCASD4"

		//Atualiza o log de processamento
		ProcLogAtu("MENSAGEM","Iniciando Processamento SD4","Iniciando Processamento SD4")

		//Inicializa variavel global de controle de thread
		PutGlbValue("A712JobD4","0")
		GlbUnLock()

		//Parametros para o Job
		aParamJob := {c711NumMRP,nTipo,aPeriodos,aPergs711,cStrTipo,cStrGrupo,cAliasTop,cAlmoxd,cAlmoxa,cQueryB1,lA710Sql,cRev711Vaz,lLogMRP,aAlmoxNNR,A711Grupo,lMRPCINQ,DatFim,cNomCZINNR}

		//Array com jobs inicializados
		cFileJob := cStartPath+CriaTrab(,.F.)+".job"

		//Para seguranca, apaga se existir
		FErase(cFileJob)
		AADD(aListaJob,{"A712JobD4",aParamJob,Seconds(),cFileJob})

		//Processa thread
		StartJob("A712JobD4",GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob)

		/*---------------INICIO JOBSC6-----------------*/
		//Monta Pedidos de Venda
		If lPedido .Or. lProcSC4
			cAliasTop := "BUSCASC6"

			//Atualiza o log de processamento
			ProcLogAtu("MENSAGEM","Iniciando Processamento SC6","Iniciando Processamento SC6")

			//Inicializa variavel global de controle de thread
			PutGlbValue("A712JobC6","0")
			GlbUnLock()

			//Parametros para o Job
			aParamJob := {c711NumMRP,nTipo,aPeriodos,aPergs711,cStrTipo,cStrGrupo,cAliasTop,_MVSTECK08,_MVSTECK08,cQueryB1,lA710Sql,lPedBloc,cComp1,cComp2,lProcSC4,cRev711Vaz,lLogMRP,lPedido,aAlmoxNNR,DatFim,cNomCZINNR}

			//Array com jobs inicializados
			cFileJob:=cStartPath+CriaTrab(,.F.)+".job"

			//Para seguranca, apaga se existir
			FErase(cFileJob)
			AADD(aListaJob,{"A712JobC6",aParamJob,Seconds(),cFileJob})

			//Processa thread
			StartJob("A712JobC6",GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob,lUsaMOpc)
		EndIf

		/*---------------INICIO JOBAFJ-----------------*/
		//Monta Empenhos para projetos
		cAliasTop := "BUSCAAFJ"

		//Atualiza o log de processamento
		ProcLogAtu("MENSAGEM","Iniciando Processamento AFJ","Iniciando Processamento AFJ")

		//Inicializa variavel global de controle de thread
		PutGlbValue("A712JobAFJ","0")
		GlbUnLock()

		//Parametros para o Job
		aParamJob := {c711NumMRP,nTipo,aPeriodos,cStrTipo,cStrGrupo,cAliasTop,cQueryB1,lA710Sql,cOpc711Vaz,cRev711Vaz,lLogMRP,aPergs711,DatFim}

		//Array com jobs inicializados
		cFileJob := cStartPath+CriaTrab(,.F.)+".job"

		//Para seguranca, apaga se existir
		FErase(cFileJob)
		AADD(aListaJob,{"A712JobAFJ",aParamJob,Seconds(),cFileJob})

		//Processa thread
		StartJob("A712JobAFJ",GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob)

		/*---------------INICIO JOBSC4 e JOBSHC-----------------*/
		//Monta Previsoes de Venda. S� processa caso nao tenha processado junto dos pedidos de venda.
		If aPergs711[1] == 1 .And. !lProcSC4 //aPergs711[30] == 2 .And. !(lPedido .And. aPergs711[17] == 1)
			cAliasTop := "BUSCASC4"

			//Atualiza o log de processamento
			ProcLogAtu("MENSAGEM","Iniciando Processamento SC4","Iniciando Processamento SC4")

			//Inicializa variavel global de controle de thread
			PutGlbValue("A712JobC4","0")
			GlbUnLock()

			//Parametros para o Job
			aParamJob := {c711NumMRP,nTipo,aPeriodos,cStrTipo,cStrGrupo,cAliasTop,_MVSTECK08,_MVSTECK08,cQueryB1,ACLONE(aPergs711),.T.,{{}},cRev711Vaz,aAlmoxNNR,lA710Sql,DatFim,cNomCZINNR}

			//Array com jobs inicializados
			cFileJob := cStartPath+CriaTrab(,.F.)+".job"

			FErase(cFileJob) //para seguranca, apaga se existir
			AADD(aListaJob,{"A712JobC4",aParamJob,Seconds(),cFileJob})

			//Processa thread
			StartJob("A712JobC4",GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob,lUsaMOpc)
		ElseIf aPergs711[1] == 2
			//Monta Plano Mestre de Producao
			cAliasTop := "BUSCASHC"

			//Atualiza o log de processamento
			ProcLogAtu("MENSAGEM","Iniciando Processamento SHC","Iniciando Processamento SHC")

			//Inicializa variavel global de controle de thread
			PutGlbValue("A712JobHC","0")
			GlbUnLock()

			//Parametros para o Job
			aParamJob := {c711NumMRP,nTipo,aPeriodos,cStrTipo,cStrGrupo,cAliasTop,cQueryB1,ACLONE(aPergs711),cRev711Vaz,DatFim}

			//Array com jobs inicializados
			cFileJob := cStartPath+CriaTrab(,.F.)+".job"

			//Para seguranca, apaga se existir
			FErase(cFileJob)
			AADD(aListaJob,{"A712JobHC",aParamJob,Seconds(),cFileJob})

			//Processa thread
			StartJob("A712JobHC",GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob,lUsaMOpc)
		EndIf

		/*---------------INICIO JOBSB8-----------------*/
		//Monta Lotes Vencidos
		If aPergs711[29] == 1
			cAliasTop := "BUSCASB8"

			//Inicializa variavel global de controle de thread
			PutGlbValue("A712JobB8","0")
			GlbUnLock()

			//Parametros para o Job
			aParamJob := {c711NumMRP,nTipo,aPeriodos,cStrTipo,cStrGrupo,cAliasTop,cQueryB1,ACLONE(aPergs711),cRev711Vaz,aAlmoxNNR,cNomCZINNR}

			//Array com jobs inicializados
			cFileJob := cStartPath+CriaTrab(,.F.)+".job"

			//Para seguranca, apaga se existir
			FErase(cFileJob)
			AADD(aListaJob,{"A712JobB8",aParamJob,Seconds(),cFileJob})

			//Processa thread
			StartJob("A712JobB8",GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,aParamJob,nRetry_1,cFileJob)
		EndIf

		For i:=1 to Len(aListaJob)
			//Analise das Threads em Execucao
			nRetry_0 := 0
			nRetry_1 := 1

			While .T.
				Do Case
				Case GetGlbValue(aListaJob[i,1]) == '0'
					If nRetry_0 > 50
						//Conout(Replicate("-",65))
						//Conout(STR0050+aListaJob[i,1]) //"Nao foi possivel realizar a subida da thread "
						//Conout(Replicate("-",65))
						Final(STR0050+aListaJob[i,1]) //"Nao foi possivel realizar a subida da thread "
				    Else
						nRetry_0 ++
					EndIf

				//Tratamento para erro de conexao
				Case GetGlbValue(aListaJob[i,1]) == '1'
					nHandle := FCreate(aListaJob[i,4])
					If nHandle # -1
						FClose(nHandle)

						//Apaga apos teste
						FErase(aListaJob[i,4])
						If nRetry_1 > 10
							//Conout(Replicate("-",65))
							//Conout(STR0051+aListaJob[i,1]) 	//"Erro de conexao na thread "
							//Conout(STR0052) 					// "Numero de tentativas excedido"
							//Conout(Replicate("-",65))
							Final(STR0051+aListaJob[i,1]) 	//"Erro de conexao na thread "
						Else
				    		//Inicializa variavel global de controle de Job
							PutGlbValue(aListaJob[i,1],"0")
							GlbUnLock()

							//Reiniciar thread
							//Conout(Replicate("-",65))
							//Conout(STR0051+aListaJob[i,1]) 			//"Erro de conexao na thread "
							//Conout(STR0053+aListaJob[i,1])
							//Conout(STR0054+StrZero(nRetry_1,2))	//"Tentativa numero: "
							//Conout(Replicate("-",65))
							StartJob(aListaJob[i,1],GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,aListaJob[i,2],nRetry_1,aListaJob[i,4])
						EndIf
						nRetry_1 ++
					EndIf

				Case GetGlbValue(aListaJob[i,1]) == '2'
					If FCreate(aListaJob[i,4]) # -1
						//Conout(Replicate("-",65))
						//Conout(STR0055+aListaJob[i,1]) 			//"Erro na execucao da thread"
						//Conout(Replicate("-",65))
						Final(STR0055+aListaJob[i,1])
					EndIf

				//THREAD PROCESSADA CORRETAMENTE
				Case GetGlbValue(aListaJob[i,1]) == '3'
					//IncProc()
					If aListaJob[i,1] == "A712JobC1"
						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","Termino Processamento SC1","Termino Processamento SC1")
						//Conout("Termino Processamento SC1")
				 	ElseIf aListaJob[i,1] == "A712JobC7"
						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","Termino Processamento SC7","Termino Processamento SC7")
						//Conout("Termino Processamento SC7")
					ElseIf aListaJob[i,1] == "A712JobC2"
						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","Termino Processamento SC2","Termino Processamento SC2")
						//Conout("Termino Processamento SC2")
					ElseIf aListaJob[i,1] == "A712JobD4"
						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","Termino Processamento SD4","Termino Processamento SD4")
						//Conout("Termino Processamento SD4")
					ElseIf aListaJob[i,1] == "A712JobC6"
						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","Termino Processamento SC6","Termino Processamento SC6")
						//Conout("Termino Processamento SC6")
					ElseIf aListaJob[i,1] == "A712JobAFJ"
						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","Termino Processamento AFJ","Termino Processamento AFJ")
						//Conout("Termino Processamento AFJ")
					ElseIf aListaJob[i,1] == "A712JobC4"
						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","Termino Processamento SC4","Termino Processamento SC4")
						//Conout("Termino Processamento SC4")
					ElseIf aListaJob[i,1] == "A712JobHC"
						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","Termino Processamento SHC","Termino Processamento SHC")
						//Conout("Termino Processamento SHC")
					EndIf
					Exit
				EndCase
				Sleep(500)
			End
		Next i
	EndIf

	If aPergs711[1] == 2
		//Atualiza o log de processamento
		ProcLogAtu("MENSAGEM","Iniciando Explosao PMP","Iniciando Explosao PMP")

		//Explode estrutura dos produtos que tiveram PMP
		MATA712EHC(cStrTipo,cStrGrupo,oCenterPanel)

		//Atualiza o log de processamento
		ProcLogAtu("MENSAGEM","Fim Explosao PMP","Fim Explosao PMP")
	EndIf

	//Atualiza o log de processamento
	ProcLogAtu("MENSAGEM","Iniciando recalculo necessidades","Iniciando recalculo necessidades")

	//Chama funcao que recalcula saldo - ANTES DA EXPLOSAO DE ESTRUTURA
	MA712ClNes(/*01*/,oCenterPanel)

	//Atualiza o log de processamento
	ProcLogAtu("MENSAGEM","Fim recalculo necessidades","Fim recalculo necessidades")
	ProcLogAtu("MENSAGEM","Inicio da Explosao da Estrutura","Inicio da Explosao da Estrutura")

	//Explode estrutura e calcula necessidade por PRODUTO
	MATA712MAT(oCenterPanel)

	//Atualiza o log de processamento
	ProcLogAtu("MENSAGEM","Termino da Explosao da Estrutura","Termino da Explosao da Estrutura")

	//Avalia eventos do log do MRP
	If lLogMRP
        A712LOG()
    EndIf
EndIf

If lVisRes
	//Variaveis com a periodicidade de geracao de OPs e SCs.
	cSelPer := cSelPerSC:=Replicate("�",Len(aPeriodos))
	If aPergs711[10] == 1
		cSelF := cSelFSC := Replicate("�",Len(aPeriodos))
	Else
		cSelF := cSelFSC := Replicate(" ",Len(aPeriodos))
	EndIf
EndIf

//Executa ponto de entrada
If (ExistBlock("MTA710"))
	ExecBlock("MTA710",.F.,.F.)
EndIf

//Cria variavel "inclui" e "altera" para nao gerar erro de inicialializador padrao.
 If Type("Inclui") == "U"
	Private Inclui := .F.
EndIf
If Type("ALTERA") == "U"
	Private ALTERA := .F.
EndIf

//Monta arquivo com TREE e consulta de DADOS
If !lBatch .And. (lVisualiza .Or. lVisRes)
	A712GrvTm(oCenterPanel,STR0056) //"Inicio da montagem de tela."

	DEFINE FONT oFont NAME "Arial" SIZE 0, -10
	DEFINE MSDIALOG oDlg TITLE cCadastro + " - " + STR0057 + " " + c711NumMRP + " Local - "+_MVSTECK08 OF oMainWnd PIXEL FROM nTop,nLeft TO nBottom,nRight

	//Cria Variaveis PRIVATE nessa funcao
	SB1->(RegToMemory("SB1",.F.))
	SC1->(RegToMemory("SC1",.F.))
	SC7->(RegToMemory("SC7",.F.))
	SC2->(RegToMemory("SC2",.F.))
	SHC->(RegToMemory("SHC",.F.))
	SD4->(RegToMemory("SD4",.F.))
	SC6->(RegToMemory("SC6",.F.))
	SC4->(RegToMemory("SC4",.F.))
	AFJ->(RegToMemory("AFJ",.F.))

	//Definicao de Menu para o botao de Filtro
	MENU oMenu1 POPUP OF oMainWnd
		MENUITEM STR0040 ACTION (M712FilNec(.T.),Eval(bChange),oTreeM711:Refresh()) //"Mostra somente as necessidades"
		MENUITEM STR0156 ACTION (M712FilNec(.F.), oTreeM711:Refresh()) //Limpar Filtro
		MENUITEM STR0058 ACTION (M712FilGen(),Eval(bChange),oTreeM711:Refresh()) //"Filtrar Produtos"
	ENDMENU

	//Folder do Tree e dos dados
	oFolder := TFolder():New(30,0,aTitles,aPages,oDlg,,,, .T., .F.,((nRight-nLeft)/2)+5,nBottom-nTop-30,)  //Dados  / Legenda
	oFolder:aDialogs[1]:oFont := oDlg:oFont

	//Definicao do objeto SAY para descricao do produto
	@ 0,3 Say oSay1 Prompt "" Size 125,10 OF oFolder:aDialogs[1] Pixel
	@ 5,3 Say oSay2 Prompt "" Size 125,8 OF oFolder:aDialogs[1] Pixel
	oSay1:SetColor(CLR_HRED,GetSysColor(15))
	oSay2:SetColor(CLR_HRED,GetSysColor(15))

	//Panel com dados
	oPanelM711 := TPanel():New(0,165,'',oFolder:aDialogs[1],oDlg:oFont,.T.,.T.,,,(nRight-nLeft)/2-164,((nBottom-nTop)/2)-36,.T.,.T. )

	//Cria o array dos campos para o browse
	AADD(aCampos,{"TEXTO","",STR0059,20}) //"Tipo"
	AADD(aCampos,{"PRODSHOW","",STR0060,LEN(CZJ->CZJ_PROD)}) //"Produtos"
	AADD(aCampos,{"OPCSHOW","",STR0061,LEN(CZJ->CZJ_OPCORD)}) //"Opcionais"
	AADD(aCampos,{"REVSHOW","",STR0062,4}) //"Revisao"
	For nInd := 1 to Len(aPeriodos)
		AADD(aCampos,{"PER"+StrZero(nInd,3),cPictQuant,DtoC(aPeriodos[nInd]),aTamQuant[1]+5})
	Next nInd

	//Monta o arquivo para a tela.
	If !lPrcPad
		cAliasView := a712MVW2(@oTempTable)
	Else
		cAliasView := MATA712MVW(,@oTempTable)
	EndIf

	If UsaNewPrc()
		nBottom := nBottom-32
	EndIf

	//Monta browse de todos os produtos
	nOldEnch := 1
	aEnch[nOldEnch] := MaMakeBrow(oPanelM711,cAliasView,{0,0,(nRight-nLeft)/2-164,((nBottom-nTop)/2)-50},,.F.,aCampos,,cTopFun,cBotFun,NIL,NIL,2)

	//Informacoes da Legenda
	nPoLin:=10
	@ nPoLin,08 BITMAP oBmp RESNAME "PMSEDT4" Of oFolder:aDialogs[2] Size 9,9 Pixel NoBorder
	@ nPoLin,23 SAY STR0060 Of oFolder:aDialogs[2] Size 50,50 Pixel
	If lShAlt
		@ 20,08 BITMAP oBmp RESNAME "PMSEDT2" Of oFolder:aDialogs[2] Size 9,9 Pixel NoBorder
		@ 20,23 SAY 'Produto com Alternativos' Of oFolder:aDialogs[2] Size 100,50 Pixel // 'Produto com Alternativos'
		nPoLin:=20
	EndIF
	@ nPoLin+10,08 BITMAP oBmp RESNAME "PMSEDT3" Of oFolder:aDialogs[2] Size 9,9 Pixel NoBorder
	@ nPoLin+10,23 SAY STR0063 Of oFolder:aDialogs[2] Size 50,50 Pixel
	@ nPoLin+20,08 BITMAP oBmp RESNAME "PMSEDT1" Of oFolder:aDialogs[2] Size 9,9 Pixel NoBorder
	@ nPoLin+20,23 SAY STR0064 Of oFolder:aDialogs[2] Size 50,50 Pixel
	@ nPoLin+30,08 BITMAP oBmp RESNAME "PMSDOC" Of oFolder:aDialogs[2] Size 9,9 Pixel NoBorder
	@ nPoLin+30,23 SAY STR0065 Of oFolder:aDialogs[2] Size 50,50 Pixel
	@ nPoLin+40,08 BITMAP oBmp RESNAME "relacionamento_direita" Of oFolder:aDialogs[2] Size 9,9 Pixel NoBorder
	@ nPoLin+40,23 SAY STR0066 Of oFolder:aDialogs[2] Size 150,50 Pixel

	//Definicao do objeto tree
	oTreeM711 := dbTree():New(14,2,((nBottom-nTop)/2)-50,164,oFolder:aDialogs[1],,,.T.)
	oTreeM711:bChange := {|| MT712DlgV(@aEnch,{0,0,((nBottom-nTop)/2)-50,((nRight-nLeft)/2)-164},@nOldEnch,oSay1,cAliasView,oSay2),Eval(bChange)}
	oTreeM711:SetFont(oFont)
	oTreeM711:lShowHint:= .F.

	//Monta Tree
	If !lPrcPad
		MT712Tree2(aPergs711[28]==1,oCenterPanel)
	Else
		MT712Tree(aPergs711[28]==1,oCenterPanel,.F.,lVisualiza)
	EndIf

	// Refaz browse com informacoes de todos os produtos
	oPanelM711:Refresh()
	oPanelM711:Show()
	
	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||fechaTela(oDlg)},{||fechaTela(oDlg)},,aButtons))
	Release Object oTreeM711
	
	(cAliasView)->(dbCloseArea())

	SFCDelTab(cAliasView)
Endif

//Atualiza LOG
ProcLogAtu("MENSAGEM","Fim calculo MRP","Fim calculo MRP")

//Fecha arquivos utilizados
If lBatch .And. ValType(aAuto[6]) == "L" .And. aAuto[6]
	If Len(aAuto) >= 8 .And. ValType(aAuto[8]) == "C"
		cNumOpDig := aAuto[8]
	Endif
	A712Gera(@cNumOpDig,cStrTipo,cStrGrupo)
Endif

If !lBatch .And. ( !lVisRes .And. nOpcA == 1 )
	A712Gera(@cNumOpDig,cStrTipo,cStrGrupo)
EndIf

If oComLocal != Nil
	oComLocal:Destroy()
EndIf

If oSemLocal != Nil
	oSemLocal:Destroy()
EndIf

If oSqlEstSeg != Nil
	oSqlEstSeg:Destroy()
EndIf

If oSqlVerEst != Nil
	oSqlVerEst:Destroy()
EndIf

If oVerAlt != Nil
	oVerAlt:Destroy()
EndIf

If oExplEs != Nil
	oExplEs:Destroy()
EndIf

//Retira o semaforo de uso exclusivo da operacao
UnLockByName("CZIUSO"+cEmpAnt+cFilAnt,.T.,.T.,.T.)

Return

Static Function fechaTela(oDlg)
Local cValue := ""
Local cTotal := 0
Local cCount := 0
/*
   Verifica se existe uma thread da integra��o das ordens de produ��o do MRP em execu��o.
   se estiver, n�o deixa realizar o processamento.
*/
If cIntgPPI != "1"

   cValue := GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt)
   cTotal := GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt+"TOTAL")
   cCount := GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt+"COUNT")
   If !Empty(cValue) .And. (cValue != "3" .And. cValue != "30")
      MsgInfo(STR0149+CHR(13)+CHR(10)+ " " + STR0080 + " " + cCount + STR0098 + cTotal,STR0030) //"A integra��o das ordens de produ��o com o PC-Factory ainda est� em processamento, por favor aguarde." \n Ordem de produ��o XXX de XXX" "Aten��o"
   Else
      oDlg:End()
   EndIf
Else
   oDlg:End()
EndIf

Return

/*------------------------------------------------------------------------//
//Programa:	A712GrvTm
//Autor:		Felipe Nunes de Toledo
//Data:		27/12/07
//Descricao:	Grava um log com os principais processos do MRP
//Parametros:	ExpO1 - Objeto tNewProcess
//				ExpC2 - Texto a ser gravado no log
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712GrvTm(oMainPainel, cTexto)

If (oMainPainel <> Nil) .And. !Empty(cTexto)
	oMainPainel:SaveLog(ctexto)
EndIf

Return Nil

/*------------------------------------------------------------------------//
//Programa:	MATA712Ctb
//Autor:		Ricardo Prandi
//Data:		17/09/2013
//Descricao:	Limpa a tabela de necessidades por filial.
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MATA712Ctb()
Local cDelete := ""

If aPergs711[32] == 1
	//Delete diretamente o registro, pois anteriormente o programa fazia dbDelete e ap�s isso um Pack para limpar
	cDelete := " DELETE FROM "+RetSqlName("SHF")
	cDelete += " WHERE HF_FILIAL      = '"+xFilial("SHF")+"' "
	cDelete +=   " AND HF_FILNEC      = '"+cFilAnt+"' "
	TCSQLExec(cDelete)
EndIf

cDelete := " DELETE FROM "+RetSqlName("CZI")
cDelete += " WHERE CZI_FILIAL = '"+xFilial("CZI")+"' "
TCSQLExec(cDelete)

cDelete := " DELETE FROM "+RetSqlName("CZJ")
cDelete += " WHERE CZJ_FILIAL = '"+xFilial("CZJ")+"' "
TCSQLExec(cDelete)

cDelete := " DELETE FROM "+RetSqlName("CZK")
cDelete += " WHERE CZK_FILIAL = '"+xFilial("CZK")+"' "
TCSQLExec(cDelete)

//Numero do mrp
c711NumMRP:=GetMV("MV_NEXTMRP")
PutMV("MV_NEXTMRP",Soma1(Substr(c711NumMRP,1,Len(SC2->C2_SEQMRP))))

Return

/*------------------------------------------------------------------------//
//Programa:	A712Pesq
//Autor:		Rodrigo de A. Sartorio
//Data:		21/08/02
//Descricao:	Pesquisa por um determinado produto + opcional
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712Pesq()
Local cPrd711Vaz		:= CriaVar("B1_COD",.F.)
Local cOpc711Vaz		:= Space(len(aDbTree[1,2]))
Local cRev711Vaz		:= ""//CriaVar("B1_REVATU",.F.)
Local cPesq 			:= ""
Local oDlg,lCancel	:= .F.
Local cOldCargo		:= oTreeM711:GetCargo()
Local nPos

If cRevBranco == Nil
	cRevBranco := CriaVar("B1_REVATU",.F.)
EndIf
cRev711Vaz := cRevBranco

cPesq := cPrd711Vaz+cOpc711Vaz+cRev711Vaz //DMANSMARTSQUAD1-10534 - Corrigido a op��o Pesquisa da Tree

DEFINE MSDIALOG oDlg TITLE STR0035 From 145,0 To 270,400 OF oMainWnd PIXEL
@ 10,15 TO 40,185 LABEL STR0067 OF oDlg PIXEL	//"Produto + Opcional a Pesquisar "
@ 20,20 MSGET cPesq Picture "@!S25" OF oDlg PIXEL
DEFINE SBUTTON FROM 50,131 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
DEFINE SBUTTON FROM 50,158 TYPE 2 ACTION (oDlg:End(),lCancel:=.T.) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg

//Pesquisa no tree o conteudo digitado
If !lCancel .And. !Empty(cPesq)
	nPos := AsCan(aDbTree,{|x| x[1]+x[2]+x[3]==cPesq})
	If !Empty(nPos) .And. !oTreeM711:TreeSeek("01"+aDbTree[nPos,7]+StrZero(0,12))
		oTreeM711:TreeSeek(cOldCargo)
	Else
		Eval(oTreeM711:bChange)
	EndIf
EndIf

Return

/*------------------------------------------------------------------------//
//Programa:	A712ShPrd
//Autor:		Rodrigo de A. Sartorio
//Data:		11/12/02
//Descricao:	Mostra os dados do produto
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712ShPrd()
Local nPos	  	:= AsCan(aDbTree,{|x| x[7]==SubStr(oTreeM711:GetCargo(),3,12)})
Local cProduto:= IIf(Empty(nPos),Space(15),aDbTree[nPos,1])
Local aArea	:= GetArea()

dbSelectArea("SB1")
dbSetOrder(1)
If MSSeek(xFilial("SB1")+cProduto)
	cCadastro:=cCadastro+" - "+STR0039
	AxVisual("SB1",SB1->(Recno()),1)
	cCadastro := STR0001
EndIf
RestArea(aArea)

Return

/*------------------------------------------------------------------------//
//Programa:	A712ViewSld
//Autor:		Erike Yuri da Silva
//Data:		20/10/05
//Descricao:	Visualizador do Detalhamento de saldos em estoque do produto
//Parametros:	aFilAlmox - Array com os armaz�ns filtrados
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712ViewSld(aFilAlmox)
Local aViewB2 := {}
Local aSaldos := {}
Local oDlg,oBold,oListBox

DbSelectArea("SB1")
DbSetOrder(1)
MsSeek(xFilial("SB1")+cProdDetSld)

aSaldos := A712DSaldo(cProdDetSld,/*02*/,@aFilAlmox,.T.,aViewB2,/*06*/,/*07*/)

If Empty(aViewB2)
	Aviso(STR0030,STR0068,{STR0069},2) //"Atencao"###"Nao exitem informacoes a serem visualizadas. Verifique se o produto foi selecionado no Tree."###"Voltar"
Else
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg FROM 000,000  TO 350,600 TITLE STR0070 Of oMainWnd PIXEL  //"Detalhamento do Saldo em Estoque Disponivel no Calculo do MRP"
		@ 023,004 To 24,296 Label "" of oDlg PIXEL
		@ 113,004 To 114,296 Label "" of oDlg PIXEL
		oListBox := TWBrowse():New( 30,2,297,69,,{RetTitle("B2_LOCAL"),RetTitle("B2_QATU"),RetTitle("B2_QNPT"),RetTitle("B2_QTNP"),STR0071,STR0072,STR0073},{17,55,55,55,55,55},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)  //"Qtd.Rej.CQ"###"Qtd.Bloqueada por Lote"###"Sld.Disponivel"
		oListBox:SetArray(aViewB2)
		oListBox:bLine := { || aViewB2[oListBox:nAT]}
		@ 004,010 SAY SM0->M0_CODIGO+"/"+FWGETCODFILIAL+" - "+SM0->M0_FILIAL+"/"+SM0->M0_NOME  Of oDlg PIXEL SIZE 245,009
		@ 014,010 SAY Alltrim(cProdDetSld)+ " - "+SB1->B1_DESC Of oDlg PIXEL SIZE 245,009 FONT oBold
		@ 104,010 SAY STR0074 Of oDlg PIXEL SIZE 30 ,9 FONT oBold  //"TOTAL "

		@ 120,007 SAY STR0075 of oDlg PIXEL //"Quantidade Disponivel    "
		@ 119,075 MsGet aSaldos[1] Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.

		@ 120,155 SAY RetTitle("B2_QNPT") of oDlg PIXEL
		@ 119,223 MsGet aSaldos[2] Picture PesqPict("SB2","B2_QEMP") of oDlg PIXEL SIZE 070,009 When .F.

		@ 135,007 SAY RetTitle("B2_QTNP") of oDlg PIXEL
		@ 134,075 MsGet aSaldos[3] Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.

		@ 135,155 SAY STR0071 of oDlg PIXEL  //"Qtd.Rej.CQ"
		@ 134,223 MsGet aSaldos[4] Picture PesqPict("SB2","B2_SALPEDI") of oDlg PIXEL SIZE 070,009 When .F.

		@ 150,007 SAY STR0072 of oDlg PIXEL
		@ 149,075 MsGet aSaldos[5] Picture PesqPict("SDD","DD_SALDO") of oDlg PIXEL SIZE 070,009 When .F.

		@ 160,244  BUTTON STR0069 SIZE 045,010  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL   //"Voltar"
	ACTIVATE MSDIALOG oDlg CENTERED
EndIf
Return

/*------------------------------------------------------------------------//
//Programa:	A712AtuPeriodo
//Autor:		Ricardo Prandi
//Data:		18/09/2013
//Descricao:	Funcao responsavel pela atualizacao de periodos e cria��o
//            da aPeriodos
//Parametros:	ExpL1 : Indica se o MRP sera executado em modo visualizacao
//				ExpN1 : Indica o tipo de periodo escolhido pelo operador
//				ExpD1 : Data de inicio dos periodos
//				ExpA1 : Array com os periodos que serao retornados por refer
//				ExpA2 : Array com parametros (opcoes)
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712AtuPeriodo(lVisualiza,nTipo,dInicio,aPeriodos,aOpcoes)
Local cForAno 	:= ""
Local nPosAno 	:= 0
Local nTamAno 	:= 0
Local i 			:= 0
Local nY2T			:= If(__SetCentury(),2,0)

DEFAULT lVisualiza := .F.

If __SetCentury()
	nPosAno := 1
	nTamAno := 4
	cForAno := "ddmmyyyy"
Else
	nPosAno := 3
	nTamAno := 2
	cForAno := "ddmmyy"
Endif

//Monta a data de inicio de acordo com os parametros
If (nTipo == 2)                         // Semanal
	While Dow(dInicio)!=2
		dInicio--
	end
ElseIf (nTipo == 3) .or. (nTipo == 4)   // Quinzenal ou Mensal
	dInicio:= CtoD("01/"+Substr(DtoS(dInicio),5,2)+Substr(DtoC(dInicio),6,3+nY2T),cForAno)
ElseIf (nTipo == 5)                     // Trimestral
	If Month(dInicio) < 4
		dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	ElseIf (Month(dInicio) >= 4) .and. (Month(dInicio) < 7)
		dInicio := CtoD("01/04/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	ElseIf (Month(dInicio) >= 7) .and. (Month(dInicio) < 10)
		dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	ElseIf (Month(dInicio) >=10)
		dInicio := CtoD("01/10/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	EndIf
ElseIf (nTipo == 6)                     // Semestral
	If Month(dInicio) <= 6
		dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	Else
		dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
	EndIf
EndIf

//Monta as datas de acordo com os parametros
If nTipo != 7
	For i := 1 to aOpcoes[2][1]
		dInicio := A712NextUtil(dInicio,aPergs711)
		AADD(aPeriodos,dInicio)
		If nTipo == 1
			dInicio ++
		ElseIf nTipo == 2
			dInicio += 7
		ElseIf nTipo == 3
			dInicio := StoD(If(Substr(DtoS(dInicio),7,2)<"15",Substr(DtoS(dInicio),1,6)+"15",;
			                If(Month(dInicio)+1<=12,Str(Year(dInicio),4)+StrZero(Month(dInicio)+1,2)+"01",;
			                Str(Year(dInicio)+1,4)+"0101")),cForAno)
		ElseIf nTipo == 4
			dInicio := CtoD("01/"+If(Month(dInicio)+1<=12,StrZero(Month(dInicio)+1,2)+;
			                "/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		ElseIf nTipo == 5
			dInicio := CtoD("01/"+If(Month(dInicio)+3<=12,StrZero(Month(dInicio)+3,2)+;
			                "/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		ElseIf nTipo == 6
			dInicio := CtoD("01/"+If(Month(dInicio)+6<=12,StrZero(Month(dInicio)+6,2)+;
			                "/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
		EndIf
	Next i
ElseIf nTipo == 7
	//Seleciona periodos variaveis se nao for visualizacao
	If !lVisualiza

		If lBatch
			If Len(aDtDivAuto) > 0
				aDiversos := ACLONE(aDtDivAuto)
			EndIf
		Else
			A712Diver()
		EndIf
	EndIf
	For i:=1 to Len(aDiversos)
		AADD(aPeriodos, StoD(DtoS(CtoD(aDiversos[i])),cForAno) )
	Next
Endif

//Ponto de entrada customizacoes na atualizacoes de periodos
If ExistBlock("A710PERI")
	aPeriodos := ExecBlock("A710PERI", .F., .F., aPeriodos )
EndIf

Return

/*------------------------------------------------------------------------//
//Programa:	A712NextUtil
//Autor:		Marcelo Iuspa
//Data:		02/02/04
//Descricao:	Retorna proxima segunda se data for sab/dom e parametro
//            de considera sabado/domingo estiver como NAO
//Parametros:	dData     - Data a ser avaliada
//				aPergs711 - Array com as perguntas a serem consideradas
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712NextUtil(dData,aPergs711,lSoma)
Local dDataOld := dData
Local dDataNew := dData
Local lWeekend := aPergs711[12] == 1 //Considera Sab.Dom

Default lSoma := .T.

If !lWeekend .And. Dow(dData) == 7
	If lSoma
		dData += 2
	Else
		dData -= 1
	EndIf
ElseIf !lWeekend .And. Dow(dData) == 1
	If lSoma
		dData += 1
	Else
		dData -= 2
	EndIf
Endif

dDataNew := dData

// Ponto de entrada para alterar a data a ser considerada nos documentos.
If ExistBlock("A710DTUTIL")
	dData := ExecBlock("A710DTUTIL",.F.,.F.,{dData, lWeekend, dDataOld, .F.})
	If ValType(dData) != "D"
		dData := dDataNew
	EndIf
EndIf

Return(dData)

/*------------------------------------------------------------------------//
//Programa:	A712Diver
//Autor:		Rodrigo A. Sartorio
//Data:		30/08/02
//Descricao:	Seleciona Periodos para opcao de apresentacao diversos
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712Diver()
Local nTamArray 	:= Len(aDiversos)
Local dInicio   	:= dDataBase
Local lConsSabDom	:= aPergs711[12] == 1
Local nI         	:= 0
Local nOpca		:= 1
Local cVarQ 		:= "  "
Local cTitle		:= OemToAnsi(STR0076)	//"Sele��o de periodos Variaveis"
Local aBack		:=	{}
//Variaveis do tipo objeto
Local oQual,oDlg,oGet
Local cDtget		:= dtoc(dDataBase)

Default lAutomacao := .F.

//Verifica se ainda nao foi criado o Array com as datas, ou se o numero de dias foi
//alterado. Se nao foi criado sugere as datas com a opcao de diario
If Len(aDiversos) == 0 .Or. aOpcoes[2][1] != Len(aDiversos)
	If aOpcoes[2][1] > Len(aDiversos)
		If Len(aDiversos) == 0


			//O inicio do array e a database
			dInicio := STOD(DTOS(dDataBase),"ddmmyy")
		Else
			//Caso tenha sido aumentado o numero de dias ele mantem os dados que ja existiam e cria
			//os novos dias a partir da ultima data do array
			dInicio := cTod(aDiversos[Len(aDiversos)],"ddmmyy")
		EndIf
		For nI := 1 to (aOpcoes[2][1] - nTamArray)
			AADD(aDiversos,dToc(dInicio))
			dInicio ++
			While !lConsSabDom .And. ( DOW(dInicio) == 1 .or. DOW(dInicio) == 7 )
				dInicio++
			End
		Next
	Else
		//Caso tenha sido diminuido o numero de dias apaga os dias a mais (do fim para o comeco) e mantem os dados digitados
		For nI:=Len(aDiversos) to (aOpcoes[2][1]+1) Step -1
			aDel(aDiversos,nI)
			Asize(aDiversos,nTamArray-1)
			nTamArray:=Len(aDiversos)
		Next
	EndIf
EndIf

aBack := aClone(aDiversos)

//Monta a tela
If !lAutomacao
	DEFINE MSDIALOG oDlg TITLE cTitle From 145,70 To 350,400 OF oMainWnd PIXEL
	@ 10,13 TO 80,152 LABEL "" OF oDlg  PIXEL
	@ 20,18 LISTBOX oQual VAR cVarQ Fields HEADER OemToAnsi(STR0016) SIZE 65,55 NOSCROLL ON DBLCLICK oGet:SetFocus() OF oDlg PIXEL
	@ 30,90 Say OemToAnsi(STR0077) SIZE 25,10 OF oDlg PIXEL
	oQual:SetArray(aDiversos)
	oQual:bLine := { || {aDiversos[oQual:nAt]} }
	@ 40,90 MSGET oGet VAR cDtget /*aDiversos[oQual:nAt]*/ Picture "99/99/99" + If(__SetCentury(),"99","") Valid A712VDiver(oQual:nAT,aDiversos[oQual:nAt],@oQual,@oGet) SIZE 40,10 OF oDlg PIXEL
	DEFINE SBUTTON FROM 86,042 TYPE 1 ACTION (nOpca:=2,oDlg:End()) ENABLE OF oDlg PIXEL
	DEFINE SBUTTON FROM 86,069 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg
EndIf

If nOpca = 1
	aDiversos:={}
	aDiversos:=ACLONE(aBack)
EndIf


Return

/*------------------------------------------------------------------------//
//Programa:	A712VDiver
//Autor:		Rodrigo A. Sartorio
//Data:		30/08/02
//Descricao:	Validacao da digitacao do periodo
//Parametros:	nOpt      = numero da linha que esta sendo editada
//				cDiversos = conteudo do array antes do get
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712VDiver(nOpt,cDiversos,oQual,oGet)
	Local lRet				:= .T.
	Local lConsSabDom		:= aPergs711[12] == 1
	Local nI         		:= 0

	//Valida se � uma data V�lida
	If ! empty(ctod(oGet:cText)) //variavel cDtget

		//Nao permite que o usuario digite uma data que seja sabado ou domingo
		If !lConsSabDom .And. (DOW(cTod(oGet:cText)) == 1 .Or. DOW(cTod(oGet:cText)) == 7)
			lRet := .F.
		else
			//Nao permite que o usuario digite uma data menor ou igual a anterior,enviando um help e retornando ao valor anterior.
			If nOpt != 1
				If  cTod(oGet:cText) <= cTod(aDiversos[nOpt - 1])
					//aDiversos[nOpt]:=cDiversos
					lRet := .F.
				EndIf
			EndIf
			//Verifica se a data alterada � maior ou igual a proxima e refaz as datas a partir da data digitada ate o fim. So nao entra
			//nesta opcao quando a data alterada for a ultima
			If nOpt < Len(aDiversos)

				//If cTod(aDiversos[nOpt + 1]) <= cTod(oGet:cText)
				   dInicio:= StoD(DtoS(cTod(oGet:cText)),"ddmmyy")

					For nI:=nOpt+1 to Len(aDiversos)
						dInicio ++
						While !lConsSabDom .And. (DOW(dInicio) == 1 .or. DOW(dInicio) == 7)
							dInicio++
						End
						aDiversos[ni] := dToc(dInicio)
					Next
				//EndIf
			 EndIf
		EndIf

	else

		lRet := .F.
	Endif

	If lRet
		aDiversos[nOpt]:= oGet:cText
		oQual:SetArray(aDiversos)
		oQual:Refresh()
		oQual:SetFocus()
	Else
		oGet:Refresh()
		oGet:SetFocus()

	EndIf


Return lRet

/*------------------------------------------------------------------------//
//Programa:	A712CriCZI
//Autor:		Ricardo Prandi
//Data:		19/09/2013
//Descricao:	Cria registros no arquivo de detalhe do MRP
//Parametros:	01.dDataOri  		- Data da necessidade do material
//          	02.cProduto  		- Produto
//          	03.cOpc      		- Opcional
//          	04.cRevisao  		- Revisao Estrutura
//          	05.cAliasMov 		- Alias do movimento
//          	06.nRecno    		- Registro
//          	07.cDoc      		- Documento
//          	08.cItem     		- Item do Documento
//          	09.cDocKey   		- Documento Chave para ligacao
//          	10.nQuant    		- Quantidade
//          	11.cTipo711  		- Indica o tipo de movimento nos arquivo SHA/SH5
//          	12.lAddTree  		- Adiciona registro no tree
//          	13.lRevisao  		- Indica se utiliza controle de revisoes
//          	14.cAliasTop 		- Alias do banco em SQL
//          	15.lCalcula  		- Indica se recalcula apos inclusao
//          	16.lInJob    		- Identifica que foi chamado por JOB
//          	17.aParPeriodos 	- Array com periodos (utilizado em job)
//          	18.nParTipo     	- Tipo de calculo (utilizado em job)
//          	19.cPar711Num   	- Numero do processamento do MRP
//          	20.cStrTipo  		- String com tipos a serem processados
//          	21.cStrGrupo 		- String com grupos a serem processados
//   				22.nPrazoEnt		- Prazo de entrega
//					23.cProdOri		- Produto original (no caso de alternativos)
//					24.aOpc			- Array de opcionais
//					25.mOpc			- Array origem dos opcionais
//					26.cNivelEstr 	- Nivel da estrutura
//					27.nNivExpl		- N�vel atual da estrutura que est� sendo explodido
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712CriCZI(dDataOri,cProduto,cOpc,cRevisao,cAliasMov,nRecno,cDoc,cItem,cDocKey,nQuant,cTipo711,lAddTree,lRevisao,cAliasTop,lCalcula,lInJob,aParPeriodos,nParTipo,cPar711Num,cStrTipo,cStrGrupo,nPrazoEnt,cProdOri,aOpc,mOpc,cNivelEstr,nNivExpl)
Static cRev711Vaz := Nil
Local cPeriodo 	  := A650DtoPer(dDataOri,aParPeriodos,nParTipo,cProduto,nQuant)
Local i			  := 0
Local nAchouTot   := 0
Local mOpcAux     := Nil

Local aAreaSB1 	:= SB1->(GetArea())
Local aAreaSGI	:= SGI->(GetArea())
Local aAreaCZI	:= CZI->(GetArea())
Local aAreaCZJ	:= CZJ->(GetArea())
Local aAreaCZK	:= CZK->(GetArea())
Local aAreaSG1	:= SG1->(GetArea())
Local cQueryOPC := ''
Local cQryUpd   := ''
//Setando valores padr�es
Default lRevisao 		:= .T.
Default lCalcula 		:= .F.
Default lInJob   		:= .F.
Default cAliasTop		:= "SB1"
Default cStrTipo 		:= ""
Default cStrGrupo		:= ""
Default cProdOri		:= ""
Default cNivelEstr	:= ""
Default cOpc			:= ""
Default mOpc			:= ""
Default nPrazoEnt		:= 0
Default aOpc 			:= {}
Default nNivExpl		:= 0

//So soma no tree caso nao seja resumido
lAddTree := lAddTree .And. aPergs711[28]==2

If cRev711Vaz == Nil
	cRev711Vaz := CriaVar("B1_REVATU",.F.)
EndIf

//Considera numero do processamento do MRP passado como parametro
If ValType(cPar711Num) == "C"
	c711NumMRP := cPar711Num
EndIf

//Verificar se usa a revis�o
If !A712TrataRev()
	cRevisao := Space(Len(SB1->B1_REVATU))
	lRevisao := .F.
Endif

//Verifica se o movimento esta dentro do periodo
If !Empty(cPeriodo)
	//Se o n�vel n�o foi passado no parametro, busca da tabela SG1
	If Empty(cNivelEstr)
		SG1->(dbSetOrder(1))
		cNivelEstr := IIf(SG1->(dbSeek(xFilial("SG1")+cProduto)),SG1->G1_NIV,"99")
	EndIf

	cOpc := IIf(cNivelEstr == "99",Space(Len(cOpc)),cOpc)

	//Adiciona registros na tabela de objetos
	dbSelectArea("CZI")
	Reclock("CZI",.T.)
	Replace CZI_FILIAL	With xFilial("CZI")
	Replace CZI_DTOG	With IIF(cAliasMov = 'CZJ',A712NextUtil(dDataOri,aPergs711,.F.),SomaPrazo(dDataOri,-nPrazoEnt))
	Replace CZI_PERMRP  With cPeriodo
	Replace CZI_PROD	With cProduto
	Replace CZI_ALIAS	With cAliasMov
	Replace CZI_DOC		With cDoc
	Replace CZI_DOCKEY	With cDocKey
	Replace CZI_ITEM    With cItem
	Replace CZI_NRLV    With cNivelEstr
	Replace CZI_QUANT	With nQuant
	Replace CZI_TPRG	With cTipo711
	Replace CZI_NRMRP	With c711NumMRP
	Replace CZI_PRODOG  With cProdOri
	If lRevisao
		Replace CZI_NRRV	With cRevisao
	Else
		Replace CZI_DOCREV	With cRevisao
	Endif

	If Len(aOpc) > 0 .And. (mOpcAux := Array2Str(aOpc,.F.)) != Nil
		mOpc := mOpcAux
	EndIf

	//Grava somente opcionais utilizados nesse produto, de acordo com a estrutura.
	If !Empty(mOpc) .And. !Empty(cProduto)
		If Empty(cStrTipo) .And. Type('a711Tipo') == "A"
			For i := 1 To Len(a711Tipo)
				If a711Tipo[i,1]
					cStrTipo += SubStr(a711Tipo[i,2],1,nTamTipo711)+"|"
				EndIf
			Next i
		EndIf

		If Empty(cStrGrupo) .And. Type('a711Grupo') == "A"
			cStrGrupo := Criavar("B1_GRUPO",.f.)+"|"
			For i := 1 To Len(a711Grupo)
				If a711Grupo[i,1]
					cStrGrupo += SubStr(a711Grupo[i,2],1,nTamGr711)+"|"
				EndIf
			Next i
		EndIf

		cGrupos := A712EstOpc(cProduto,MontaOpc(mOpc),Nil,Nil,cStrTipo,cStrGrupo)
		If IsInCallStack("MAT712OPSC")
			If Empty(cOpc) //Quando estiver gerando as ordens, j� vem com o cOpc carregado corretamente.
				cOpc := IIf(Empty(cGrupos),"",A712AvlOpc(MontaOpc(mOpc,cProduto,Iif(nNivExpl==0,cNivelEstr,nNivExpl)),cGrupos))
			EndIf
		Else
			cOpc := IIf(Empty(cGrupos),"",A712AvlOpc(MontaOpc(mOpc,cProduto,Iif(nNivExpl==0,cNivelEstr,nNivExpl)),cGrupos))
		EndIf
	EndIf

	Replace CZI_OPC		With mOpc //cOpc
	Replace CZI_OPCORD	With cOpc	

	If nRecno = 0
		Replace CZI_NRRGAL   With nRecZero
		nRecZero ++
	Else
		Replace CZI_NRRGAL   With nRecno
	EndIf
	MsUnlock()

    nRecno := CZI->(RECNO())

	If !Empty(cProduto) .And. !Empty(cTipo711)
		If !lInJob .And. lAddTree .And. !lBatch .And. lVisRes
			//Adiciona registro em array totalizador utilizado no TREE

			If Len(aTotais[Len(aTotais)]) > 4095
				AADD(aTotais,{})
			EndIf

			For i := 1 to Len(aTotais[1])
				if aTotais[1,i,1] == CZI->CZI_PROD+CZI->CZI_OPCORD+CZI->CZI_NRRV .And. aTotais[1,i,2] == CZI->CZI_PERMRP .And. aTotais[1,i,3] == CZI->CZI_ALIAS
					nAchouTot := i
				Else
					nAchouTot := 0
					loop
				EndIf
				If nAchouTot != 0
					aTotais[1,nAchouTot,4] += CZI->CZI_QUANT
					Exit
				EndIf
			Next i

			If nAchouTot == 0
				AADD(aTotais[Len(aTotais)],{CZI->CZI_PROD + CZI->CZI_OPCORD + CZI->CZI_NRRV,CZI->CZI_PERMRP,CZI->CZI_ALIAS,CZI->CZI_QUANT})
			EndIf
			A712AdTree(.F.,{{CZI->CZI_PROD,CZI->CZI_OPCORD,CZI->CZI_NRRV,CZI->CZI_ALIAS,CZI->CZI_TPRG,CZI->CZI_DOC,StrZero(CZI->(Recno()),12),CZI->CZI_DOCREV}},aPergs711[28]==1)
		EndIf
		//Cria registro na tabela CZJ
		A712CriCZJ(cProduto,cOpc,If(lRevisao,cRevisao, cRev711Vaz),cNivelEstr,cPeriodo,nQuant,cTipo711,cAliasTop,lCalcula,cStrTipo,cStrGrupo,.F.,mOpc,nNivExpl)
	EndIf

   // Tratamento para diminuir o tamanho do campo CZI_OPC, para quando estrutura tiver muitos itens com opcionais.

   If lMopcGRV
		fMopcGrv(CZI->CZI_OPC,nRecno)
   EndIf
EndIf

SB1->(RestArea(aAreaSB1))
CZI->(RestArea(aAreaCZI))
CZJ->(RestArea(aAreaCZJ))
CZK->(RestArea(aAreaCZK))
SGI->(RestArea(aAreaSGI))
SG1->(RestArea(aAreaSG1))

Return

/*/{Protheus.doc} fMopcGrv
	@type  Static Function
	@author mauricio.joao
	@since 11/11/2020
/*/
Static Function fMopcGrv(cOpc,nRecno)
Local cQueryOpc := ""
Local cAliasTmp := ""
Local cQryUpd 	:= ""

	IF ! EMPTY(cOpc)
		IF oUpdCzi = NIL
			cQueryOPC  := " SELECT R_E_C_N_O_  AS REC FROM " + RetSqlName("CZI") + " CZI "
			cQueryOPC  += " WHERE " + RetSqlCond("CZI") + 'AND CZI.CZI_OPC IS NOT NULL '
			cQueryOPC  += " AND CZI.R_E_C_N_O_ <> ? "

			If (TCGetDB() $ "POSTGRES/DB2/400/INFORMIX")
				cQueryOPC  += " AND CAST(CZI.CZI_OPC as varchar(4000) ) = ( SELECT CAST(CZI_OPC as varchar(4000) )  AS REC FROM "+ RetSqlName("CZI") + " CZI " + " WHERE "+ RetSqlCond("CZI")
				cQueryOPC  += " AND CZI.R_E_C_N_O_ = ? ) "
			ElseIf (TCGetDB() $ "ORACLE")
				cQueryOPC  += " AND (dbms_lob.compare(CZI.czi_opc, ( SELECT  czi_opc AS REC FROM "+ RetSqlName("CZI") + " CZI " + " WHERE "+ RetSqlCond("CZI")
				cQueryOPC  += " AND CZI.R_E_C_N_O_ = ? )) =0) "
			Else
				cQueryOPC  += " AND CZI.CZI_OPC = ( SELECT CZI_OPC  AS REC FROM "+ RetSqlName("CZI") + " CZI " + " WHERE "+ RetSqlCond("CZI")
				cQueryOPC  += " AND CZI.R_E_C_N_O_ = ? )"
			EndIf

			cQueryOPC := ChangeQuery(cQueryOPC)
			oUpdCzi   := FWPreparedStatement():New(cQueryOPC)
		endif

			oUpdCzi:SetString(1,CVALTOCHAR(nRecno)  )
			oUpdCzi:SetString(2,CVALTOCHAR(nRecno)  )
			cQueryOPC := oUpdCzi:GetFixQuery()
			cAliasTmp := MPSysOpenQuery(cQueryOPC)

			IF ! EMPTY((cAliastmp)->REC)
			cQryUpd := " Update " + RetSqlName("CZI")
			cQryUpd += " Set CZI_OPC = CAST( 'REC' +'" +CVALTOCHAR((cAliastmp)->REC)+ "'" + " AS VARBINARY) "
			cQryUpd += " WHERE R_E_C_N_O_ = '" + CVALTOCHAR(nRecno) + "'"
			TCSQLExec(cQryUpd)
		EndIF
			(cAliastmp)->(DBCLOSEAREA())
	EndIF
Return .T.


/*------------------------------------------------------------------------//
//Programa:	A712TrataRev
//Autor:		Marcelo Iuspa
//Data:		22/06/04
//Descricao:	Retorna se existe campos especificos para tratamento de
//				revisao na Previsao de Venda e Plano Mestre Producao
//				Campos: HC_REVISAO e C4_REVISAO
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712TrataRev()
Static lTrataRev := Nil

If lTrataRev == Nil
	If lA710REV
		lTrataRev := ExecBlock("A710REV",.F.,.F.)
		If ValType(lTrataRev) # "L"
			lTrataRev := .F.
		EndIf
	Else
		lTrataRev := .F.
	EndIf
Endif

Return(lTrataRev)

/*------------------------------------------------------------------------//
//Programa:	A712CriCZJ
//Autor:		Ricardo Prandi
//Data:		19/09/2013
//Descricao:	Cria registros no arquivo de totais do MRP
//Parametros:	01.cProduto  		- Produto
//          	02.cOpc      		- Opcional
//          	03.cRevisao  		- Revisao Estrutura
//          	04.cNivelEstr    	- Nivel do produto
//          	05.cPeriodo  		- Periodo
//          	06.nQuant    		- Quantidade
//          	07.cTipo711  		- 1-Sld Inicial 2-Entrada 3-Saida 5-Saida Relacionada
//          	08.cAliasTop 		- Alias do banco em SQL
//          	09.lCalcula  		- Indica se recalcula apos inclusao
//          	10.cStrTipo  		- String com tipos a serem processados
//          	11.cStrGrupo 		- String com grupos a serem processados
//					12.lVerRev			- Indica se refaz a verifica��o da revis�o
//					13.mOpc			- Memo de opcionais
//					14.nNivExpl		- N�vel atual em que a estrutura est� sendo explodida.
//Observacao:	Tipos de Registro
// 					1 Saldo Inicial
// 					2 Entrada
// 					3 Saida
// 					4 Saida pela Estrutura
// 					5 Saldo
// 					6 Necessidade
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712CriCZJ(cProduto,cOpc,cRevisao,cNivelEstr,cPeriodo,nQuant,cTipo711,cAliasTop,lCalcula,cStrTipo,cStrGrupo,lVerRev,mOpc,nNivExpl,lBuscaOPC)
Local cGrupos     	:= ""
Local cSeek			:= ""
Local nRecCzj			:= 0
Local lExiste     	:= .F.
Local cFilCZJ := xFilial("CZJ")
Local cFilCZK := xFilial("CZK")
//Seta valores padr�es para os argumentos
DEFAULT cPeriodo  	:= "001"
DEFAULT cNivelEstr	:= ""
DEFAULT cTipo711  	:= ""
DEFAULT cAliasTop 	:= "SB1"
DEFAULT cStrTipo  	:= ""
DEFAULT cStrGrupo 	:= ""
DEFAULT cOpc			:= ""
DEFAULT mOpc			:= ""
DEFAULT lCalcula  	:= .F.
DEFAULT lVerRev		:= .T.
DEFAULT nNivExpl	:= 0
DEFAULT lBuscaOPC   := .T.

If lVerRev
	If !A712TrataRev()
		cRevisao := Space(Len(SB1->B1_REVATU))
	Endif
EndIf

//Se o n�vel n�o foi passado no parametro, busca da tabela SG1
If Empty(cNivelEstr)
	SG1->(dbSetOrder(1))
	cNivelEstr := IIf (SG1->(dbSeek(xFilial("SG1")+cProduto)),SG1->G1_NIV,"99")
EndIf
If lBuscaOPC
	If /*Empty(cOpc) .And.*/ !Empty(mOpc) .And. !Empty(cProduto)
		cGrupos := A712EstOpc(cProduto,MontaOpc(mOpc),Nil,Nil,cStrTipo,cStrGrupo)
		If IsInCallStack("MAT712OPSC")
			If Empty(cOpc) //Quando estiver gerando as ordens, j� vem com o cOpc carregado corretamente.
				cOpc := IIf(Empty(cGrupos),"",A712AvlOpc(MontaOpc(mOpc,cProduto,Iif(nNivExpl==0,cNivelEstr,nNivExpl)),cGrupos))
			EndIf
		Else
			cOpc := IIf(Empty(cGrupos),"",A712AvlOpc(MontaOpc(mOpc,cProduto,Iif(nNivExpl==0,cNivelEstr,nNivExpl)),cGrupos))
		EndIf
	EndIf
EndIf

//Se n�o existir registro para o primeiro tipo, n�o vai existir para o restante, ent�o n�o precisa verificar novamente
//Caso exista, � necess�rio verificar para pegar o R_E_C_N_O_ da CZJ
//lExiste := MATA712EZJ(cProduto,cOpc,cRevisao)
CZJ->(dbSetOrder(3))
cSeek := cFilCZJ+cProduto+IIF(LEN(cOpc)>200,Substr(cOpc,1,200),PADR(cOpc,TamSx3("CZJ_OPCORD")[1],''))+cRevisao
lExiste := CZJ->(dbSeek(cSeek))

//Inclui registros caso necessario
If !lExiste
	//Insere na CZJ
	Reclock("CZJ",.T.)
	Replace CZJ->CZJ_FILIAL  	With cFilCZJ
	Replace CZJ->CZJ_PROD   	With cProduto
	Replace CZJ->CZJ_OPC		With cOpc
	Replace CZJ->CZJ_NRRV		With cRevisao
	Replace CZJ->CZJ_NRLV	   	With cNivelEstr
	Replace CZJ->CZJ_NRMRP  	With c711NumMRP
	Replace CZJ->CZJ_MOPC		With mOpc
	Replace CZJ->CZJ_OPCORD		With cOpc
	CZJ->(MsUnlock())
	nRecCzj := CZJ->(RecNo())

	//Insere na CZK
	Reclock("CZK",.T.)
	Replace CZK->CZK_FILIAL	With cFilCZK
	Replace CZK->CZK_NRMRP	With c711NumMRP
	Replace CZK->CZK_RGCZJ	With nRecCzj
	Replace CZK->CZK_PERMRP	With cPeriodo
	Replace CZK->CZK_QTSLES	With IIf(cTipo711 == '1',nQuant,0)
	Replace CZK->CZK_QTENTR	With IIf(cTipo711 == '2',nQuant,0)
	Replace CZK->CZK_QTSAID	With IIf(cTipo711 == '3',nQuant,0)
	Replace CZK->CZK_QTSEST	With IIf(cTipo711 == '4',nQuant,0)
	Replace CZK->CZK_QTSALD	With IIf(cTipo711 == '5',nQuant,0)
	Replace CZK->CZK_QTNECE	With IIf(cTipo711 == '6',nQuant,0)
	CZK->(MsUnlock())
Else
	cSeek := cFilCZK+STR(CZJ->(RecNo()),10,0)+cPeriodo
	If CZK->(dbSeek(cSeek))
		Reclock("CZK",.F.)
		Do Case
			Case cTipo711 == '1'
				CZK->CZK_QTSLES += nQuant
			Case cTipo711 == '2'
				CZK->CZK_QTENTR += nQuant
			Case cTipo711 == '3'
				CZK->CZK_QTSAID += nQuant
			Case cTipo711 == '4'
				CZK->CZK_QTSEST += nQuant
			Case cTipo711 == '5'
				CZK->CZK_QTSALD += nQuant
			Case cTipo711 == '6'
				CZK->CZK_QTNECE += nQuant
		EndCase
		CZK->(MsUnlock())
	Else
		Reclock("CZK",.T.)
		Replace CZK->CZK_FILIAL	With cFilCZK
		Replace CZK->CZK_NRMRP	With c711NumMRP
		Replace CZK->CZK_RGCZJ	With CZJ->(RecNo())
		Replace CZK->CZK_PERMRP	With cPeriodo
		Replace CZK->CZK_QTSLES	With IIf(cTipo711 == '1',nQuant,0)
		Replace CZK->CZK_QTENTR	With IIf(cTipo711 == '2',nQuant,0)
		Replace CZK->CZK_QTSAID	With IIf(cTipo711 == '3',nQuant,0)
		Replace CZK->CZK_QTSEST	With IIf(cTipo711 == '4',nQuant,0)
		Replace CZK->CZK_QTSALD	With IIf(cTipo711 == '5',nQuant,0)
		Replace CZK->CZK_QTNECE	With IIf(cTipo711 == '6',nQuant,0)
		MsUnlock()
	EndIf
EndIf

If lCalcula
	MA712Recalc(cProduto,cOpc,cRevisao,cPeriodo,/*05*/,/*06*/,/*07*/,CZJ->(RecNo()),/*09*/)
EndIf

Return

/*------------------------------------------------------------------------//
//Programa:	MATA712EZJ
//Autor:		Ricardo Prandi
//Data:		20/09/2013
//Descricao:	Retorna se j� existe o registro na CZJ
//Parametros:	1. cProduto	- C�digo do produto
//				2. cOpc		- Memo de opcionais
//				3. cRevisao	- Revis�o da estrutura
//Uso: 		MATA712
//------------------------------------------------------------------------*/
/*Static Function MATA712EZJ(cProduto,cOpc,cRevisao)
Local lRet 	:= .F.
Local cSql 	:= ""

If Len(cOpc) > 200
	cOpc := Substr(cOpc,1,200)
EndIf

cAliasCZJ := "EXISTECZJ"
cSql := " SELECT CZJ.R_E_C_N_O_ CZJREC"
cSql +=   " FROM " + RetSqlName("CZJ") + " CZJ "
cSql +=  " WHERE CZJ_FILIAL = '" + xFilial("CZJ") + "' "
cSql +=    " AND D_E_L_E_T_ = ' ' "
If !Empty(cProduto)
	cSql += " AND CZJ_PROD = '" + cProduto + "' "
EndIf
If !Empty(cOpc)
	cSql += " AND CZJ_OPCORD = '" + cOpc + "' "
EndIf
If !Empty(cRevisao)
	cSql += " AND CZJ_NRRV = '" + cRevisao + "' "
EndIf

cSql := ChangeQuery(cSql)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cAliasCZJ,.T.,.T.)

lRet := IIf((cAliasCZJ)->(Eof()),.F., .T.)

Return lRet*/

/*------------------------------------------------------------------------//
//Programa:	MATA712TMP
//Autor:		Ricardo Prandi
//Data:		20/09/2013
//Descricao:	Cria as tabelas para controle de grupos e tipos de produto
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MATA712TMP()
Local aTipo 	  := {{"TP_TIPO","C",02,0}}
Local aGrupo 	  := {{"GR_GRUPO","C",04,0}}
Local aLocal	  := {{"NR_LOCAL","C",TamSx3('NNR_CODIGO')[1],0}}

//-- Garante exclus�o das tabelas
If TCCanOpen(cNomCZITTP)
	TCSQLExec("DELETE FROM " +cNomCZITTP)
Else
	//-- Cria tabela
	DbCreate(cNomCZITTP,aTipo,"TOPCONN")
EndIf
If TCCanOpen(cNomCZITGR)
	TCSQLExec("DELETE FROM " +cNomCZITGR)
Else
	//-- Cria tabela
	DbCreate(cNomCZITGR,aGrupo,"TOPCONN")
EndIf
If TCCanOpen(cNomCZINNR)
	TCSQLExec("DELETE FROM " +cNomCZINNR)
Else
	//-- Cria tabela
	DbCreate(cNomCZINNR,aLocal,"TOPCONN")
EndIf

Return

/*------------------------------------------------------------------------//
//Programa:	A712DSaldo
//Autor:		Ricardo Prandi
//Data:		20/09/2013
//Descricao:	Detalhamento do Saldo em Estoque do MRP
//Parametros:	01.cProduto  		- Produto
//          	02.nSaldo      	- Variavel que retornara por passagem de parametro o saldo em estoque do produto
//          	03.aFilAlmox 		- Variavel de controle para customizacao
//          	04.lViewDetalhe  	- Permite visualizar gera detalhamento do saldo
//          	05.aViewB2  		- Array com detalhamento dos saldos por local
//          	06.nEstSeg   		- Variavel que retornara por passagem de parametro o estoque de seguran�a do produto
//				07.cAliasSB1		- Alias da tabela SB1
//Retorno:		Array com os saldos do produto aglutinados por armazem
// 					[1] Saldo Disponivel
// 					[2] QTD NOSSO EM TERCEIROS
// 					[3] QTD TECEIROS EM NOSSO PODER
// 					[4] SALDO REJEITADO PELO CQ
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712DSaldo(cProduto,nSaldo,aFilAlmox,lViewDetalhe,aViewB2,nEstSeg,cAliasSB1)
Local nSldLocPos	:= 0
Local nSldNs3		:= 0
Local nSld3Ns		:= 0
Local nSldRejCQ		:= 0
Local nSldPE		:= 0
Local nInd			:= 0
Local cQuery   		:= ""
Local cAliasEst		:= ""
Local cArqProd   	:= SuperGetMV("MV_ARQPROD",.F.,"SB1")
Local aRetSldTot	:= {0,0,0,0,0}     //Retorno dos saldos totalizados quando eh visualizado os detalhes
Local aAreaSB1 		:= SB1->(GetArea())
Local lEstSeg   	:= aPergs711[26] == 1
Private nSldSDD		:= 0
Static oSqlEstSeg   := Nil
Static oSqlVerEst   := Nil

Default nSaldo 		:= 0
Default aFilAlmox   := Nil
Default lViewDetalhe:= .F.
Default aViewB2		:= {}
Default cAliasSB1	:= "SB1"

//Calcula estoque de seguran�a
If lEstSeg
	cAliasSeg := "EstSeg"
	If oSqlEstSeg == Nil
		If cArqProd == "SBZ"
			cQuery := " SELECT COALESCE(BZ_ESTSEG,B1_ESTSEG) B1_ESTSEG, "+;
			                 " COALESCE(BZ_ESTFOR,B1_ESTFOR) B1_ESTFOR " + ;
		                " FROM " + RetSqlName("SB1") + " SB1 Left Outer Join "+RetSqlName("SBZ")+" SBZ " +;
		                  " ON BZ_FILIAL      = '"+xFilial("SBZ")+"' " +;
		                 " AND BZ_COD         = B1_COD AND SBZ.D_E_L_E_T_ = ' ' " +;
		               " WHERE SB1.B1_FILIAL  = '" + xFilial("SB1") + "' " +;
		                 " AND SB1.B1_COD     = ? " +;  //cProduto
		                 " AND SB1.D_E_L_E_T_ = ' ' "
		Else
			cQuery := " SELECT B1_ESTSEG, "+;
			                 " B1_ESTFOR " + ;
		               " FROM " + RetSqlName("SB1") + " SB1 " +;
		              " WHERE SB1.B1_FILIAL  = '" + xFilial("SB1") + "' " +;
		                " AND SB1.B1_COD     = ? " +;  //cProduto
		                " AND SB1.D_E_L_E_T_ = ' ' "
		EndIf

		cQuery := ChangeQuery(cQuery)
		oSqlEstSeg := FWPreparedStatement():New(cQuery)
	EndIf

	oSqlEstSeg:SetString(1,cProduto)
	cQuery := oSqlEstSeg:GetFixQuery()

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSeg,.F.,.F.)

	If !(cAliasSeg)->(Eof())
		If(!Empty((cAliasSeg)->B1_ESTFOR))
			nEstSeg:=Formula((cAliasSeg)->B1_ESTFOR)

			If(ValType(nEstSeg) # "N")
				Aviso('STR0026',OemToAnsi(STR0035)+cProduto+OemToAnsi(STR0036),{'Ok'}) //"A formula de estoque de seguranca do produto "###" esta retornando valor incorreto. A formula sera desconsiderada"
				nEstSeg := (cAliasSeg)->B1_ESTSEG
			Endif
		Else
			nEstSeg := (cAliasSeg)->B1_ESTSEG
		Endif
	Else
		nEstSeg := 0
	Endif

	IF 	nEstSeg > 0

		IF ! MT712VLOPC(cProduto, "",{},"","", , ,.F. , 1 )
			nEstSeg := 0
		ENDIF

	ENDIF

	nSaldo -= nEstSeg

	(cAliasSeg)->(dbCloseArea())
EndIf

nSldNs3 := 0
nSld3Ns := 0

cAliasEst := "VEREST"

If oSqlVerEst == Nil
	cQuery := " SELECT SB2.B2_FILIAL, " +;
				     " SB2.B2_COD, " +;
                     " SB2.B2_LOCAL, " +;
                     " SB2.B2_QATU, " +;
                     " SB2.B2_QNPT, " +;
                     " SB2.B2_QTNP " +;
                " FROM " + RetSqlName("SB2") + " SB2 " +;
               " WHERE SB2.B2_FILIAL = '" + xFilial("SB2") + "' " +;
                 " AND SB2.B2_COD    = ? " +; //1 - cProduto
                 " AND SB2.B2_LOCAL >= ? " +; //2 - cAlmoxd
                 " AND SB2.B2_LOCAL <= ? " +; //3 - cAlmoxa
                 " AND D_E_L_E_T_    = ' ' "

    If aAlmoxNNR # Nil
    	cQuery += " AND SB2.B2_LOCAL IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
    EndIf

    If aFilAlmox # Nil
    	cQuery += " AND SB2.B2_LOCAL IN ('"+Criavar("B2_LOCAL",.F.) + "' "
    	For nInd := 1 to Len(aFilAlmox)
    		cQuery += ",'"+aFilAlmox[nInd]+"' "
    	Next nInd
    	cQuery += ") "
    EndIf

    cQuery += " ORDER BY B2_FILIAL, "
    cQuery +=          " B2_COD, "
    cQuery +=          " B2_LOCAL "

    cQuery := ChangeQuery(cQuery)
    oSqlVerEst := FWPreparedStatement():New(cQuery)
EndIf

//Produto
oSqlVerEst:SetString(1,cProduto)

//Almoxarifado de
oSqlVerEst:SetString(2,cAlmoxd)

//Almoxarifado at�
oSqlVerEst:SetString(3,cAlmoxa)

//Busca query fixada com os valores
cQuery := oSqlVerEst:GetFixQuery()

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasEst,.F.,.F.)

While !(cAliasEst)->(Eof())
	If cMT710B2 # Nil .And. !&(cMT710B2) .And. cMT710B2 # "" // CH TRAAXW
		dbSkip()
		Loop
	Endif

	//Saldo bloqueado
	If aPergs711[25] == 1
		nSldSDD := A712QtdDD((cAliasEst)->B2_COD, (cAliasEst)->B2_LOCAL)
		nSaldo  -= nSldSDD
	Endif

	nSldLocPos	:= 0
	nSldLocPos	:= If(aPergs711[18]==1,(cAliasEst)->B2_QATU,CalcEst((cAliasEst)->B2_COD,(cAliasEst)->B2_LOCAL,aPeriodos[1]+1)[1]) - RetLotVenc(cProduto,aPeriodos[1],(cAliasEst)->B2_LOCAL,nSldSDD)
	nSaldo		+= nSldLocPos
	If lViewDetalhe
		aAdd(aViewB2,{TransForm((cAliasEst)->B2_LOCAL,cPictB2Local),;	//[1] LOCAL
						TransForm(nSldLocPos,cPictB2Qatu),;	  			//[2] SALDO ATUAL OU POR MOVIMENTO
						"-",;													//[3] QTD NOSSO EM TERCEIROS
						"-",;													//[4] QTD TECEIROS EM NOSSO PODER
						"-",;                                    			//[5] SALDO REJEITADO PELO CQ
						"-",;                                    			//[6] SALDO BLOQUEADO POR LOTE
						NIL})    												//[7] SALDO A SER CONSIDERADO
	EndIf

	//Considera quantidade nossa em poder de terceiro
	If aPergs711[18] == 1 .And. aPergs711[20] == 1
		nSaldo += (cAliasEst)->B2_QNPT
		If lViewDetalhe
			nSldLocPos		+= (cAliasEst)->B2_QNPT
			aRetSldTot[2] += (cAliasEst)->B2_QNPT
			aViewB2[Len(aViewB2),3] := TransForm((cAliasEst)->B2_QNPT,cPictB2QNPT)
		EndIf
	EndIf

	//Considera quantidade de terceiro em nosso poder
	If aPergs711[18] == 1 .And. aPergs711[21] == 1
		nSaldo -= (cAliasEst)->B2_QTNP
		If lViewDetalhe
			nSldLocPos 	-= (cAliasEst)->B2_QTNP
			aRetSldTot[3] += (cAliasEst)->B2_QTNP
			aViewB2[Len(aViewB2),4] := TransForm((cAliasEst)->B2_QTNP,cPictB2QTNP)
		EndIf
	EndIf

	//Saldo em CQ
	If aPergs711[22] == 1
		nSldRejCQ   := A712QtdCQ((cAliasEst)->B2_COD, (cAliasEst)->B2_LOCAL, aPeriodos[1]+1)
		If nSldRejCQ <= nSaldo	
			nSaldo -= nSldRejCQ
		EndIf
		If lViewDetalhe
			nSldLocPos      -= nSldRejCQ
			aRetSldTot[4] += nSldRejCQ
			aViewB2[Len(aViewB2),5] := TransForm(nSldRejCQ,cPictD7QTDE)
		EndIf
	Endif

	//Saldo bloqueado
	If aPergs711[25] == 1
		If lViewDetalhe
			nSldLocPos   	-= nSldSDD
			aRetSldTot[5] += nSldSDD
			aViewB2[Len(aViewB2),6] := TransForm(nSldSDD,cPictDDSaldo)
		EndIf
	Endif

	//Calcula o saldo se MV_PAR18 = 2 e se teve algum filtro de locais.
	If (aFilAlmox # Nil .Or. cMT710B2 # Nil .Or. aAlmoxNNR # Nil) .And. aPergs711[18] == 2
		If Empty(aViewB2)
			aAdd(aViewB2,{"*",TransForm(nSaldo,cPictB2Qatu),"-",TransForm(nSld3Ns,cPictB2QTNP),"-","-",TransForm(nSaldo,cPictB2Qatu)})
		Else
			aViewB2[Len(aViewB2),1] := "*"
		EndIf

		//Considera quantidade nossa em poder de terceiro
		If aPergs711[20] == 1
			nSldNs3 := SaldoTerc((cAliasEst)->B2_COD, (cAliasEst)->B2_LOCAL, "T", aPeriodos[1]+1, (cAliasEst)->B2_LOCAL)[1]
			nSaldo	 += nSldNs3
			If lViewDetalhe
				nSldLocPos 	+= nSldNs3
				aRetSldTot[2] += nSldNs3
				aViewB2[Len(aViewB2),3] := TransForm(nSldNs3,cPictB2QNPT)
			EndIf
		Endif

		//Considera quantidade de terceiro em nosso poder
		If aPergs711[21] == 1
			nSld3Ns := SaldoTerc((cAliasEst)->B2_COD, (cAliasEst)->B2_LOCAL, "D", aPeriodos[1]+1, (cAliasEst)->B2_LOCAL)[1]
			nSaldo	 -= nSld3Ns
			If lViewDetalhe
				nSldLocPos 	-= nSld3Ns
				aRetSldTot[3]	+= nSld3Ns
				aViewB2[Len(aViewB2),4] := TransForm(nSld3Ns,cPictB2QTNP)
			EndIf
		Endif
	Endif

	//Se est� consultando para visualizar, atualiza array
	If lViewDetalhe
		aRetSldTot[1]	+= nSldLocPos
		aViewB2[Len(aViewB2),7] := TransForm(nSldLocPos,cPictB2Qatu)
	EndIf

	//Pr�ximo registro
	dbSelectArea(cAliasEst)
	dbSkip()
End

nSld3Ns := 0
nSldNs3 := 0

//Calcula o saldo se MV_PAR18 = 2 e se n�o h� filtros para os locais
If aPergs711[18] == 2 .And. aFilAlmox == Nil .And. cMT710B2 # Nil .And. aAlmoxNNR == Nil
	//Considera quantidade nossa em poder de terceiro
	If aPergs711[20] == 1
		nSldNs3 := SaldoTerc(cProduto, cAlmoxd, "T", aPeriodos[1]+1, cAlmoxa)[1]
		nSaldo	 += nSldNs3
		If lViewDetalhe
			aRetSldTot[2]	+= nSldNs3
			aRetSldTot[1]	:= nSaldo
			aAdd(aViewB2,{"*",TransForm(nSaldo,cPictB2Qatu),TransForm(nSldNs3,cPictB2QNPT),"-","-","-",TransForm(nSaldo,cPictB2Qatu)})
		EndIf
	Endif

	//Considera quantidade de terceiro em nosso poder
	If aPergs711[21] == 1
		nSld3Ns := SaldoTerc(cProduto, cAlmoxd, "D", aPeriodos[1]+1, cAlmoxa)[1]
		nSaldo	 -= nSld3Ns
		If lViewDetalhe
			aRetSldTot[3]	+= nSld3Ns
			aRetSldTot[1]	:= nSaldo
			If Empty(aViewB2)
				aAdd(aViewB2,{"*",TransForm(nSaldo,cPictB2Qatu),"-",TransForm(nSld3Ns,cPictB2QTNP),"-","-",TransForm(nSaldo,cPictB2Qatu)})
			Else
				aViewB2[Len(aViewB2),4] := TransForm(nSld3Ns,cPictB2QTNP)
				aViewB2[Len(aViewB2),7] := TransForm(nSaldo,cPictB2Qatu)
			EndIf
		EndIf
	Endif
Endif

If lA710SINI
	nSldPE := ExecBlock("A710SINI",.F.,.F.,{cProduto,nSaldo})
	If ValType(nSldPE) == "N"
		nSaldo := nSldPE
	EndIf
EndIf

(cAliasEst)->(dbCloseArea())

RestArea(aAreaSB1)

Return aClone(aRetSldTot)

/*------------------------------------------------------------------------//
//Programa:	  RetLotVenc
//Autor:	  Ricardo Prandi
//Data:		  31/11/2018
//Descricao:  Calcula o saldo de lotes vencidos, conforme MV_LOTVENC
//Parametros: 01.cProduto - Produto
//            02.dData    - Data de refer�ncia
//            03.cLocal	  - Local da verifica��o
//            04.nSldSDD  - Saldo retornado da tabela SDD
//Uso:     	  MATA712
//------------------------------------------------------------------------*/
Static Function RetLotVenc(cProduto,dData,cLocal,nSldSDD)
Local cSql    := ""
Local cQuery  := ""
Local cArqTrb := "LOTVNC"
Local nInd    := 0
Local nPos    := 0
Local nQtde   := 0
Local aArea   := GetArea()

Default cLocal  := ""
Default nSldSDD := 0

//Verifica se considera lote vencido
If lConsVenc == Nil
	lConsVenc := SuperGetMV("MV_LOTVENC",.F.,"N") == "S"
EndIf

//Se n�o considera Lote Vencido ou o produto n�o possui rastro, sai da fun��o
If lConsVenc .Or. !Rastro(cProduto)
	Return 0
EndIf

//Se considera CQ, busca o par�metro
If aPergs711[22] == 1 .And. cLocCQ == Nil
	cLocCQ := Substr(SuperGetMV("MV_CQ",.F.,"98"),1,2)
EndIf

//Busca posi��o do per�odo
nPos := aScan(aPeriodos,dData)

//Prepara SQL sem considerar o cLocal
If oSemLocal == Nil
	cSql += " SELECT SUM(B8_SALDO) AS B8_SALDO " +;
	          " FROM " +RetSQLName("SB8") +;
	         " WHERE B8_FILIAL   = '" +xFilial("SB8") + "' " +;
	           " AND B8_PRODUTO  = ? " +; //1
	           " AND B8_LOCAL   >= ? " +; //2
	           " AND B8_LOCAL   <= ? " +; //3
	           " AND B8_SALDO    > 0 " +;
	           " AND B8_DTVALID >= ? " +; //4
	           " AND B8_DTVALID  < ? " +; //5
	           " AND D_E_L_E_T_ = ' ' "

	If aAlmoxNNR # Nil
		cSql += " AND B8_LOCAL IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
	EndIf

	If aFilAlmox # Nil
		cSql += " AND B8_LOCAL IN ('"+Criavar("B8_LOCAL",.F.)+"' "
		For nInd := 1 to Len(aFilAlmox)
			cSql += ",'"+aFilAlmox[nInd]+"' "
		Next nInd
		cSql += ") "
	EndIf

	If aPergs711[22] == 1
		cSql += " AND B8_LOCAL <> '" +cLocCQ +"' "
	EndIf

	cSql := ChangeQuery(cSql)

	// Ajuste para banco DB2 - Utilizado ap�s o changeQuery
	If AllTrim(TcGetDb()) == "DB2"
		cSql := STRTRAN( cSql, "FOR READ ONLY", "" )
	EndIf
	oSemLocal := FWPreparedStatement():New(cSql)
EndIf

//Prepara SQL considerando o cLocal
If oComLocal == Nil
	cSql += " AND B8_LOCAL = ? " //6

	cSql := ChangeQuery(cSql)

	// Ajuste para banco DB2 - Utilizado ap�s o changeQuery
	If AllTrim(TcGetDb()) == "DB2"
		cSql := STRTRAN( cSql, "FOR READ ONLY", "" )
	EndIf

	oComLocal := FWPreparedStatement():New(cSql)
EndIf

//Define qual objeto usar (com ou sem local)
If cLocal == ""
	//PRODUTO
	oSemLocal:SetString(1,cProduto)
    //LOCAL DE
    oSemLocal:SetString(2,aPergs711[8])
    //LOCAL ATE
    oSemLocal:SetString(3,aPergs711[9])

    //DATA VALIDADE DE e DATA VALIDADE ATE
    If nPos == 1
    	oSemLocal:SetString(4,'20000101')
    	oSemLocal:SetString(5,DToS(dData))
    Else
    	oSemLocal:SetString(4,DToS(aPeriodos[nPos-1]))
    	oSemLocal:SetString(5,DToS(dData))
    EndIf

    //Busca query fixada com os valores
    cQuery := oSemLocal:GetFixQuery()
Else
	//PRODUTO
	oComLocal:SetString(1,cProduto)
    //LOCAL DE
    oComLocal:SetString(2,aPergs711[8])
    //LOCAL ATE
    oComLocal:SetString(3,aPergs711[9])

    //DATA VALIDADE DE e //DATA VALIDADE ATE
    If nPos == 1
    	oComLocal:SetString(4,'20000101')
    	oComLocal:SetString(5,DToS(dData))
    Else
    	oComLocal:SetString(4,DToS(aPeriodos[nPos-1]))
    	oComLocal:SetString(5,DToS(dData))
    EndIf

    //LOCAL
    oComLocal:SetString(6,cLocal)

    //Busca query fixada com os valores
    cQuery := oComLocal:GetFixQuery()
EndIf

//Executa a query
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cArqTrb,.F.,.T.)

//Pega a quantidade
nQtde += (cArqTrb)->B8_SALDO

//Fecha arquivo de trabalho
(cArqTrb)->(dbCloseArea())

//Retorna Area anterior
RestArea(aArea)

If nQtde >= nSldSDD
	nQtde -= nSldSDD
EndIf

Return(nQtde)

/*------------------------------------------------------------------------//
//Programa:	A712LotVnc
//Autor:		Andre Anjos
//Data:		09/10/08
//Descricao:	Calcula o saldo de lotes vencidos, conforme MV_LOTVENC
//Parametros:	01.cProduto  		- Produto
//          	02.dData      	- Data de refer�ncia
//          	03.cLocal	 		- Local da verifica��o
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712LotVnc(cProduto,dData,cLocal)
Local aArea     := {}
Local nQtde     := 0
Local cFiltro   := ""
Local cArqTrb   := ""
Local nPos      := 0
Local nInd		:= 0

DEFAULT cLocal := ""

If lConsVenc == Nil
	lConsVenc := SuperGetMV("MV_LOTVENC",.F.,"N")=="S"
EndIf
If cLocCQ == Nil
	cLocCQ    := Substr(SuperGetMV("MV_CQ",.F.,"98"),1,2)
EndIf
If !lConsVenc .And. Rastro(cProduto)
	aArea := GetArea()
	nPos := aScan(aPeriodos,dData)

	cArqTrb := "LOTVNC"
	cFiltro += " SELECT SUM(B8_SALDO) AS B8_SALDO " +;
	            " FROM " +RetSQLName("SB8") +;
	           " WHERE B8_FILIAL  = '" +xFilial("SB8") + "' " +;
	             " AND B8_PRODUTO = '" +cProduto +"' " +;
	             " AND B8_LOCAL  >= '" +aPergs711[8] +"' " +;
	             " AND B8_LOCAL  <= '" +aPergs711[9] +"' " +;
	             " AND B8_SALDO   > 0 " +;
	             " AND D_E_L_E_T_ = ' ' "

	If aPergs711[22] == 1 //ja e tratado indiretamente na A712QtdCQ
		cFiltro += " AND B8_LOCAL <> '" +cLocCQ +"' "
	EndIf

	If cLocal <> ""
		cFiltro += " AND B8_LOCAL = '" +cLocal+ "' "
	EndIf

	If nPos == 1
		cFiltro += " AND B8_DTVALID > '20000101' "
		cFiltro += " AND B8_DTVALID < '" +DToS(dData) +"' "
	Else
		cFiltro += " AND B8_DTVALID >= '" +DToS(aPeriodos[nPos-1]) +"' "
		cFiltro += " AND B8_DTVALID  < '" +DToS(dData) +"' "
	EndIf

	If aAlmoxNNR # Nil
		cFiltro += " AND B8_LOCAL IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
	EndIf

	If aFilAlmox # Nil
		cFiltro += " AND B8_LOCAL IN ('"+Criavar("B8_LOCAL",.F.)+"' "
		For nInd := 1 to Len(aFilAlmox)
			cFiltro += ",'"+aFilAlmox[nInd]+"' "
		Next nInd
		cFiltro += ") "
	EndIf

	cFiltro := ChangeQuery(cFiltro)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cFiltro),cArqTrb,.F.,.T.)

	nQtde += (cArqTrb)->B8_SALDO

	(cArqTrb)->(dbCloseArea())
	RestArea(aArea)
EndIf

Return(nQtde)

/*------------------------------------------------------------------------//
//Programa:	A712QtdCQ
//Autor:		Ricardo Prandi
//Data:		23/09/2013
//Descricao:	Calcula o saldo rejeitado do produto no almoxarifado de CQ
//Parametros:	01.cProduto  		- Produto
//          	02.cLocal      	- Local da verifica��o
//          	03.dData	 		- Data de refer�ncia
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712QtdCQ(cProduto, cLocal, dData)
Local nQtde  	:= 0
Local cQuery 	:= ""
Local cArqTrb := "BUSCACQ"
Local aArea := GetArea()

Default dData  := dDataBase
Default cLocal := GetMv("MV_CQ")

cQuery := " SELECT SD7.D7_FILIAL, " +;
                 " SD7.D7_PRODUTO, " +;
                 " SD7.D7_NUMSEQ, " +;
                 " SD7.D7_NUMERO, " +;
                 " SD7.D7_TIPO, " +;
                 " SD7.D7_QTDE, " +;
                 " SD7.D7_FORNECE, " +;
                 " SD7.D7_LOJA, " +;
                 " SD7.D7_DOC, " +;
                 " SD7.D7_SERIE " +;
           " FROM " + RetSQLName("SD7") + " SD7 " +;
          " WHERE SD7.D7_FILIAL   = '" + xFilial("SB8") + "' " +;
            " AND SD7.D7_PRODUTO  = '" + cProduto + "' " +;
            " AND SD7.D7_LOCDEST  = '" + cLocal + "' " +;
            " AND SD7.D7_DATA     < '" + dTos(dData) + "' " +;
            " AND SD7.D7_ESTORNO <> 'S' " +;
            " AND SD7.D_E_L_E_T_  = ' ' " +;
          " ORDER BY SD7.D7_FILIAL, " +;
                   " SD7.D7_PRODUTO, " +;
                   " SD7.D7_NUMSEQ, " +;
                   " SD7.D7_NUMERO "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cArqTrb,.F.,.T.)

Do While !(cArqTrb)->(Eof())
	If (cArqTrb)->D7_TIPO == 2   	//Rejeitada
		If (cArqTrb)->D7_QTDE > 0
			nQtde += A712AbDev((cArqTrb)->D7_FORNECE,(cArqTrb)->D7_LOJA,(cArqTrb)->D7_DOC,(cArqTrb)->D7_SERIE,(cArqTrb)->D7_QTDE,(cArqTrb)->D7_PRODUTO)
		Endif
	ElseIf (cArqTrb)->D7_TIPO == 6  //Estorno da Liberacao
		nQtde += (cArqTrb)->D7_QTDE
	Endif
	(cArqTrb)->(dbSkip())
EndDo

(cArqTrb)->(dbCloseArea())
RestArea(aArea)

Return(nQtde)

/*------------------------------------------------------------------------//
//Programa:	A712AbDev
//Autor:		Sergio S. Fuzinaka
//Data:		18.09.09
//Descricao:	Retorna a Quantidade, subtraindo as quantidades das Notas
//				Fiscais de Devolucao de Compras
//Parametros:	01.cFornece  		- Fornecedor
//          	02.cLoja      	- Loja
//				03.cDoc			- Documento
//				04.cSerie		- Serio da nota fiscal
//				05.nQtdD7		- Quantidade
//				06.cCodProd		- Codigo Produto
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712AbDev(cFornece,cLoja,cDoc,cSerie,nQtdD7,cCodProd)
Local nQtde			:= 0
Local nQtDev		:= 0
Local cAliasTop		:= "BUSCAABDEV"
Default cCodProd	:= " "

BeginSql Alias cAliasTop
SELECT SUM(D2_QUANT) QTDEV
  FROM %table:SD2% SD2
 WHERE SD2.D2_FILIAL  = %xFilial:SD2%
   AND SD2.D2_TIPO    = 'D'
   AND SD2.D2_CLIENTE = %Exp:cFornece%
   AND SD2.D2_LOJA    = %Exp:cLoja%
   AND SD2.D2_NFORI   = %Exp:cDoc%
   AND SD2.D2_SERIORI = %Exp:cSerie%
   AND SD2.D2_cod = %Exp:cCodProd%
   AND SD2.%NotDel%
EndSql
nQtDev := (cAliasTop)->QTDEV

nQtde := IIf(nQtdD7 >= nQtDev,nQtdD7 - nQtDev,nQtdD7)

(cAliasTop)->(dbCloseArea())

Return nQtde

/*------------------------------------------------------------------------//
//Programa:	A712QtdDD
//Autor:		Ricardo Prandi
//Data:		23/09/2013
//Descricao:	Calcula o saldo bloqueado do produto no arquivo SDD
//Parametros:	01.cProduto  		- Produto
//          	02.cLocal      	- Local da verifica��o
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712QtdDD(cProduto, cLocal)
Local cArqTrb := "BUSCADD"
Local nQtde  	:= 0
Local aArea := GetArea()

BeginSql Alias cArqTrb
SELECT SUM(DD_SALDO) QTSALDO
  FROM %table:SDD% SDD
 WHERE SDD.DD_FILIAL  = %xFilial:SD2%
   AND SDD.DD_PRODUTO = %Exp:cProduto%
   AND SDD.DD_LOCAL   = %Exp:cLocal%
   AND SDD.DD_MOTIVO <> 'VV'
   AND SDD.%NotDel%
EndSql
nQtde += (cArqTrb)->QTSALDO

(cArqTrb)->(dbCloseArea())
RestArea(aArea)

Return (nQtde)

/*------------------------------------------------------------------------//
//Programa:	A712CriaLog
//Autor:		Rodrigo Sartorio
//Data:		27/08/03
//Descricao:	Avalia as informacoes relacioandas ao evento e caso o log
//				do MRP esteja ativo alimenta o arquivo de LOG do sistema
//Parametros:	01.cEvento  		- Codigo do Evento que deve ser avaliado
//          	02.cProduto      	- Codigo do produto que deve ser avaliado
//				03.aDados			- Array com os dados utilizados na avaliacao do evento informado
//				04.lLogMRP   		- Indica se ir� gravar o LOG
//				05.c711NumMrp		- N�mero do MRP
//Uso: 		MATA712
//------------------------------------------------------------------------//
Evento 001 - Saldo em estoque inicial menor que zero
	aDados[1] - Saldo inicial do Produto
Evento 002 - Atrasar o evento
	aDados[1] - Data original
	aDados[2] - Numero do Documento
	aDados[3] - Item ou outro dado complementar do documento
	aDados[4] - Alias do documento
	aDados[5] - Data para atrasar
Evento 003 - Adiantar o evento
	aDados[1] - Data original
	aDados[2] - Numero do Documento
	aDados[3] - Item ou outro dado complementar do documento
	aDados[4] - Alias do documento
	aDados[5] - Data para atrasar
Evento 004 - Data de necessidade invalida - Data anterior a database
	aDados[1] - Codigo do produto que gerou a necessidade
	aDados[2] - Quantidade da necessidade
	aDados[3] - Data calculada
Evento 005 - Data de necessidade invalida - Data posterior ao prazo maximo do MRP
	aDados[1] - Codigo do produto que gerou a necessidade
	aDados[2] - Quantidade da necessidade
	aDados[3] - Data calculada
Evento 006 - Documento planejado em atraso
	aDados[1] - Data planejada do evento
	aDados[2] - Numero do Documento
	aDados[3] - Item ou outro dado complementar do documento
	aDados[4] - Alias do documento
Evento 007 - Cancelar o documento
	aDados[1] - Data do documento
	aDados[2] - Numero do Documento
	aDados[3] - Item ou outro dado complementar do documento
	aDados[4] - Alias do documento
Evento 008 - Saldo em estoque maior ou igual ao estoque maximo
	aDados[1] - Estoque maximo
	aDados[2] - Saldo em estoque
	aDados[3] - Data do periodo
	aDados[4] - Alias do documento
Evento 009 - Saldo em estoque menor ou igual ao ponto de pedido
	aDados[1] - Ponto de pedido
	aDados[2] - Saldo em estoque
aDados[3] - Data do periodo
aDados[4] - Alias do documento
//------------------------------------------------------------------------*/
Static Function A712CriaLOG(cEvento,cProduto,aDados,lLogMRP,c711NumMrp)
LOCAL aArea 			:= {} // GetArea()
LOCAL aDescEventos	:= {}
LOCAL aDocs			:= {}
LOCAL aTamSB2			:= {}
LOCAL nAcho			:= 0
LOCAL nAchoDoc		:= 0
LOCAL cDocumento		:= ""
LOCAL cTexto			:= ""
LOCAL cItem			:= ""
LOCAL cArquivo		:= ""
LOCAL cCodOri			:= ""

// So avalia eventos se o LOG do MRP estiver ativo
If lLogMRP
	// Array contendo a descricao dos documentos
	AADD(aDocs,{"SC1",STR0078})
	AADD(aDocs,{"SC7",STR0079})
	AADD(aDocs,{"SC2",STR0080})
	AADD(aDocs,{"SHC",STR0081})
	AADD(aDocs,{"SD4",STR0082})
	AADD(aDocs,{"SC6",STR0083})
	AADD(aDocs,{"SC4",STR0084})
	AADD(aDocs,{"AFJ",STR0085})
	AADD(aDocs,{"ENG",STR0086})
	AADD(aDocs,{"SB1",STR0087})
	AADD(aDocs,{"SBP",STR0088})

	// Array contendo o codigo dos eventos e a descricao relacionada
	AADD(aDescEventos,{"001",OemToAnsi(STR0089)}) //"Saldo em estoque inicial menor que zero. Saldo "
	AADD(aDescEventos,{"002",OemToAnsi(STR0090)}) //"Atrasar o documento "
	AADD(aDescEventos,{"003",OemToAnsi(STR0091)}) //"Adiantar o documento "
	AADD(aDescEventos,{"004",OemToAnsi(STR0092)}) //"Data de necessidade invalida - Data anterior a database do calculo. Produto origem da necessidade "
	AADD(aDescEventos,{"005",OemToAnsi(STR0093)}) //"Data de necessidade invalida - Data posterior a data limite do calculo. Produto origem da necessidade "
	AADD(aDescEventos,{"006",OemToAnsi(STR0094)}) //"Documento planejado em atraso. Planejado para "
	AADD(aDescEventos,{"007",OemToAnsi(STR0095)}) //"Cancelar o documento "
	AADD(aDescEventos,{"008",OemToAnsi(STR0096)}) //"Saldo em estoque maior que o estoque maximo "
	AADD(aDescEventos,{"009",OemToAnsi(STR0097)}) //"Saldo em estoque menor ou igual ao ponto de pedido "

	// Verifica se o evento esta cadastrado
	nAcho := ASCAN(aDescEventos,{|x| x[1] == cEvento})

	// Busca posicao do alias de acordo com o evento
	// Eventos sem alias devem ser adicionados nesta condicao
	If !(cEvento $ "001*004*005")
		nAchoDoc := aScan(aDocs,{|x| x[1] == aDados[4]})
	EndIf

	// So avalia eventos se o LOG do MRP estiver ativo
	If nAcho > 0
		aArea := GetArea()

		aTamSB2 := TamSX3("B2_QATU")

		If cEvento == "001" .And. QtdComp(aDados[1]) < QtdComp(0)
			cTexto := aDescEventos[nAcho,2] +AllTrim(Str(aDados[1],aTamSB2[1],aTamSB2[2]))
		ElseIf cEvento == "002"
			cTexto := aDescEventos[nAcho,2] +AllTrim(aDados[2]) +If(!Empty(aDados[3])," / " +AllTrim(aDados[3]),"") +" - "
			cTexto += aDocs[nAchoDoc,2] +OemToAnsi(STR0098) +DTOC(aDados[1]) +OemToAnsi(STR0099)+DTOC(aDados[5]) //" de "###" para "
			cDocumento := aDados[2]
			cItem := aDados[3]
			cArquivo := aDados[4]
		ElseIf cEvento == "003"
			cTexto := aDescEventos[nAcho,2] +AllTrim(aDados[2]) +If(!Empty(aDados[3])," / " +AllTrim(aDados[3]),"") +" - "
			cTexto +=aDocs[nAchoDoc,2] +OemToAnsi(STR0098)+DTOC(aDados[1])+OemToAnsi(STR0099)+DTOC(aDados[5]) //" de "###" para "
			cDocumento := aDados[2]
			cItem := aDados[3]
			cArquivo := aDados[4]
		ElseIf cEvento == "004"
			cCodOri := aDados[1]
			If aDados[3] < aPeriodos[1]
				cTexto := aDescEventos[nAcho,2] +AllTrim(aDados[1]) +STR0100 +AllTrim(Str(aDados[2],aTamSB2[1],aTamSB2[2])) //" Quantidade "
			ElseIf aDados[3] > aPeriodos[Len(aPeriodos)]
				cEvento := "005"
				nAcho := ASCAN(aDescEventos,{|x| x[1] == cEvento})
				cTexto := aDescEventos[nAcho,2] +AllTrim(aDados[1]) +STR0100 +AllTrim(Str(aDados[2],aTamSB2[1],aTamSB2[2]))	//" Quantidade "
			EndIf
		ElseIf cEvento == "006" .And. aDados[1] < dDataBase
			cTexto := aDescEventos[nAcho,2] +DTOC(aDados[1]) +"." +AllTrim(aDados[2]) +If(!Empty(aDados[3])," / " +AllTrim(aDados[3]),"")
			cTexto += " - " +aDocs[nAchoDoc,2]
			cDocumento := aDados[2]
			cItem := aDados[3]
			cArquivo := aDados[4]
		ElseIf cEvento == "007" .And. aDados[4] # "SBP"
			cTexto := aDescEventos[nAcho,2] +AllTrim(aDados[2]) +If(!Empty(aDados[3])," / " +AllTrim(aDados[3]),"")
			cTexto += " - " +aDocs[nAchoDoc,2] +OemToAnsi(STR0101) +DTOC(aDados[1]) +OemToAnsi(STR0102) //" Data Original "###" pois seu saldo nao sera utilizado em nenhum periodo"
			cDocumento := aDados[2]
			cItem := aDados[3]
			cArquivo := aDados[4]
		ElseIf cEvento == "008"
			cTexto := aDescEventos[nAcho,2] +OemToAnsi(STR0103) +AllTrim(Str(aDados[1],aTamSB2[1],aTamSB2[2])) +" "+OemToAnsi(STR0042)
			cTexto += AllTrim(Str(aDados[2],aTamSB2[1],aTamSB2[2])) +OemToAnsi(STR0104) +DToC(aDados[3]) +" - " +aDocs[nAchoDoc,2]
			cArquivo := aDados[4]
		ElseIf cEvento == "009"
			cTexto := aDescEventos[nAcho,2] +OemToAnsi(STR0105) +AllTrim(Str(aDados[1],aTamSB2[1],aTamSB2[2])) +" "+OemToAnsi(STR0042)
			cTexto += AllTrim(Str(aDados[2],aTamSB2[1],aTamSB2[2])) +OemToAnsi(STR0104) +DToC(aDados[3]) +" - " +aDocs[nAchoDoc,2]
			cArquivo := aDados[4]
		EndIf

		If !Empty(cTexto)
			Reclock("SHG",.T.)
			Replace HG_FILIAL With xFilial("SHG")
			Replace HG_SEQMRP With c711NumMRP
			Replace HG_COD    With cProduto
			Replace HG_CODLOG With cEvento
			Replace HG_LOGMRP With cTexto
			Replace HG_DOC    With AllTrim(cDocumento)
			Replace HG_ITEM   With AllTrim(cItem)
			Replace HG_ALIAS  With cArquivo
			Replace HG_CODORI With cCodOri
			MsUnlock()
		EndIf
		RestArea(aArea)
	EndIf
EndIf

Return

/*------------------------------------------------------------------------//
//Programa:	MontaOpc
//Autor:		Anieli Rodrigues
//Data:		02/01/2013
//Descricao:	Monta String com o codigo do opcional (Campo C6_MOPC)
//Parametros:	01.cMopc	- Conteudo do campo memo a ser transformado
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MontaOpc(cMOpc,cProd,cNivelEstr)
Local cRet    := ""
Local aAux    := {}
Local nI      := 0
Local nNivel  := 0
Local nTamPrd := TamSX3("B1_COD")[1]
Local nTamSeq := TamSX3("G1_TRT")[1]
Local nPos    := 0
Default cProd      := ""
Default cNivelEstr := ""

If !Empty(cMOpc)
	nPos := aScan(aCacheOpc,{|x| x[1] ==  bin2str(cMOpc)   })
	If nPos > 0
		aOpc := aCacheOpc[nPos][2]
	Else
		aOpc := Str2Array(cMOpc,.F.)
		aAdd(aCacheOpc,{bin2str(cMOpc),aOpc})
	EndIf

	If aOpc != Nil
		aAux := aOpc
	EndIf

EndIf

//If !Empty(aAux := STR2Array(cMOpc,.F.))
If ! Empty(aAux)
	If !Empty(cProd) .And. !Empty(cNivelEstr)
		nNivel := Iif(ValType(cNivelEstr)=="N",cNivelEstr,Val(cNivelEstr))
		If nNivel <= 1
			nPos := 1
		Else
			nPos := nTamPrd + ((nTamPrd+nTamSeq)*(nNivel-2)) + 1
		EndIf

		if lUsaMOpc
			For nI := 1 To Len(aAux)
				If cProd $ SubStr(aAux[nI,1],nPos,Len(aAux[nI,1])) .And. Len(SubStr(aAux[nI,1],nPos,Len(aAux[nI,1]))) != nTamPrd+nTamSeq
					cRet += aAux[nI,2] + "/"
				EndIf
			Next nI
		else
			For nI := 1 To Len(aAux)
			    If at(aAux[nI,2],cRet) == 0
			    	cRet += aAux[nI,2] + "/"
			    endif
			Next nI
		endif
	Else
		aEval(aAux,{|x| cRet += x[2]})
	EndIf
Endif

If Len(cRet) == 0
	cRet := AllTrim(cMOpc)
EndIf

Return cRet

/*------------------------------------------------------------------------//
//Programa:	A712EstOpc
//Autor:		Rodrigo de A. Sartorio
//Data:		29/08/02
//Descricao:	Funcao recursiva para verificar opcionais utilizados
//Parametros:	01.cProduto 	= Codigo do produto a ser explodido
//				02.cOpcionais = Opcionais utilizados
//				03.lRecursiva	= Indica se a fun��o ser� recursiva
//				04.lRetOpc 	= Indica se ir� retornar para os opcionais
//				05.cStrTipo	= String dos tipos de itens selecionados
//				06.cStrGrupo	= String dos grupos de itens selecionados
//				07.lMATA650	= Indica se o programa est� sendo chamado do MATA650
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712EstOpc(cProduto,cOpcionais,lRecursiva,lRetOpc,cStrTipo,cStrGrupo,lMATA650)
Local aArea		:= GetArea()
Local cRetGr	:= ""
Local i			:= 0
Local aRegs		:= {}
Local aRegGr	:= {}
Local cOpcAux 	:= ""
Local nTamGrupo	:= TamSX3("G1_GROPC")[01]
Local nX 		:= 0
Local cFilSG1 := xFilial("SG1")
Local cRevEstrutura := PCPREVATU(cProduto)

Default lRecursiva := .T.
Default lRetOpc    := .F.
Default cStrTipo   := ""
Default cStrGrupo  := ""
Default lMATA650   := .F.

If !Empty(cOpcionais) .And. !Empty(cProduto)
	cAliasSG1 := GetNextAlias() 
	//Gera a Query 
	BeginSql alias cAliasSG1 
	SELECT
		SG1.*
	FROM
		%table:SG1% SG1
	WHERE
		SG1.G1_FILIAL= %Exp:cFilSG1% AND
		SG1.G1_COD = %Exp:cProduto% AND
		SG1.G1_REVINI <= %Exp:cRevEstrutura% AND
		SG1.G1_REVFIM >= %Exp:cRevEstrutura% AND
		SG1.%notDel% 
	EndSql
	//While no resultado da Query
	While (cAliasSG1)->(!Eof())
		If !Empty((cAliasSG1)->G1_GROPC) .And.;
		 	( AllTrim((cAliasSG1)->G1_GROPC+(cAliasSG1)->G1_OPC) $ AllTrim(cOpcionais) ) .And.;
		 	!( AllTrim((cAliasSG1)->G1_GROPC+(cAliasSG1)->G1_OPC) $ AllTrim(cOpcAux) )	

			cOpcAux += AllTrim((cAliasSG1)->G1_GROPC+(cAliasSG1)->G1_OPC) + "/"
			aRegGr := aClone(StrTokArr(cOpcAux,"/"))
			If !lRetOpc
				For nX := 1 To Len(aRegGr)
					aRegGr[nX] := Substr(aRegGr[nX],1,nTamGrupo)
				Next nX
			EndIf
		Else
			//Caso nao tenha opcionais neste nivel, guarda o registro para pesquisar em niveis inferiores
			AADD(aRegs,{(cAliasSG1)->R_E_C_N_O_,(cAliasSG1)->G1_NIV})
		EndIf			
		
		(cAliasSG1)->(DbSkip())
	Enddo
	//Fecha a tabela
	(cAliasSG1)->(DbCloseArea())

	ASORT(aRegGr,,,{|x,y| x < y})
	For i:=1 To Len(aRegGr)
		cRetGr+=If(lRetOpc .And. !Empty(cRetGr),"/","")+aRegGr[i]
	Next i

	If lRecursiva
		ASORT(aRegs,,,{|x,y| x[2] < y[2]})
		//Varre o array para que sejam selecionados os itens restantes
		For i:=1 to Len(aRegs)
			SG1->(dbGoto(aRegs[i,1]))
			cRetGr += A712EstOpc(SG1->G1_COMP,cOpcionais,NIL,If(lMATA650,.T.,NIL),cStrTipo,cStrGrupo,lMATA650)
		Next I
	Endif
EndIf

RestArea(aArea)

Return cRetGr

/*------------------------------------------------------------------------//
//Programa:	A712AvlOpc
//Autor:		Rodrigo de A. Sartorio
//Data:		29/08/02
//Descricao:	Funcao para verificar opcionais utilizados
//Parametros:	01.ExpC1 = Codigo do produto a ser explodido
//				02.ExpC2 = Grupos de opcionais utilizados
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712AvlOpc(cOpcArq,cGrupos)
Local cOpc711Vaz	:= CriaVar("C2_OPC",.F.)
Local cRetOpc  	:= ""
Local cGrScan		:= ""
Local nTamGrupo	:= Len(SG1->G1_GROPC)
Local nTamItGr 	:= Len(SG1->G1_OPC)
Local aArea		:= GetArea()

cOpcArq := "/" + cOpcArq

While !Empty(cGrupos)
	//Obtem o grupo a ser pesquisado
	cGrScan := Substr(cGrupos,1,nTamGrupo)
	//Retira grupo a ser pesquisado da lista de grupos originais
	cGrupos := Substr(cGrupos,nTamGrupo+1)
	//Procura grupo no campo de opcionais do arquivo
	nString := AT("/"+cGrScan,cOpcArq)
	cItem:= (Substr(cOpcArq,nString+1,nTamGrupo+nTamItGr+1))

	If nString > 0 .And. (!cItem $ cRetOpc)	
		
		cRetOpc += cItem		
		cOpcArq := StrTran( cOpcArq, cItem, "" )
	EndIf
End

RestArea(aArea)
cRetOpc := cRetOpc+Space(Len(cOpc711Vaz)-Len(cRetOpc))

Return cRetOpc

/*------------------------------------------------------------------------//
//Programa:	MATA712EHC
//Autor:		Ricardo Prandi
//Data:		27/09/2013
//Descricao:	Explode estrutura dos registros de plano mestre de produ��o
//Parametros:	cStrTipo		- String com os tipos de itens
//				cStrGrupo		- String com os grupos dos itens
//				oCenterPanel	- Objeto do painel de processamento
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MATA712EHC(cStrTipo,cStrGrupo,oCenterPanel)
Local cQuery 		:= ""
Local mOpc			:= ""
Local cOpc          := ""
Local aOpc          := ""
Local cAliasTop 	:= "ESTSHC"
Local nRecno		:= 0
Local lMT710EXP	:= .T.

cQuery := " SELECT CZI.CZI_FILIAL, "
cQuery +=        " CZI.CZI_PROD, "
cQuery +=        " CZI.CZI_NRRV, "
cQuery +=        " CZI.CZI_QUANT, "
cQuery +=        " CZI.CZI_DTOG, "
cQuery +=        " CZI.CZI_NRRGAL, "
cQuery +=        " CZI.CZI_NRLV, "
cQuery +=        " CZI.R_E_C_N_O_ CZIREC "
cQuery +=   " FROM " + RetSqlName("CZI")+ " CZI "
cQuery +=  " WHERE CZI.CZI_FILIAL = '" + xFilial("CZI") + "' "
cQuery +=    " AND CZI.CZI_ALIAS  = 'SHC' "
cQuery += "  ORDER BY " + SqlOrder(CZI->(IndexKey(2)))

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
aEval(CZI->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})

dbSelectArea(cAliasTop)

While !Eof()
	If (oCenterPanel <> Nil)
		oCenterPanel:IncRegua1(OemToAnsi(STR0106))
	EndIf

	nRecno := (cAliasTop)->CZI_NRRGAL

	SHC->(DbGoTo(nRecno))
	cOpc := SHC->HC_OPC
	mOpc := SHC->HC_MOPC

	//caso os opcionais estejam em branco no pmp, ele pega do produto
	If Empty(mOpc)
		mOpc := POSICIONE('SB1',1,Xfilial('SB1')+SHC->HC_PRODUTO,'B1_MOPC')
	EndIf

	If Empty((aOpc := Str2Array(mOpc,.F.)))
		aOpc := {}
	EndIf

	If lPeMT710EXP
		lMT710EXP := ExecBlock("MT710EXP",.F.,.F.,{CZI_PROD,mOpc,CZI_NRRV,CZI_QUANT})
		If ValType(lMT710EXP) # "L"
			lMT710EXP := .T.
		EndIf
	EndIf

	If lMT710EXP
		A712ExplEs(CZI_PROD,cOpc,CZI_NRRV,CZI_QUANT,A650DtoPer(CZI_DTOG),cStrTipo,cStrGrupo,aOpc,.T.,1)
	EndIf

	dbSelectArea(cAliasTop)
	dbSkip()
End

(cAliasTop)->(dbCloseArea())

//a712OnlyOPC()

A712GrvTm(oCenterPanel,STR0107) //"Termino da Explosao da Estrutura dos Itens relacionados ao Plano Mestre de Producao - SHC."

If (oCenterPanel <> Nil)
	oCenterPanel:IncRegua2()
EndIf

Return(Nil)


/*Static Function a712OnlyOPC()
Local cAliasOPC := "ESTOPC"
Local cFilCZI := xFilial("CZI")
Local cFilSG1 := ""
aGeraOPC		:= {}

cQuery := " SELECT CZI.CZI_OPCORD, "
cQuery +=        " CZI.R_E_C_N_O_ CZIREC "
cQuery +=   " FROM " + RetSqlName("CZI")+ " CZI "
cQuery +=  " WHERE CZI.CZI_FILIAL = '" + cFilCZI + "' "
cQuery +=    " AND CZI.CZI_ALIAS  = 'SHC' "
cQuery +=    " AND CZI.CZI_OPCORD <> '' "

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasOPC,.T.,.T.)

mOpc := (cAliasOPC)->CZI_OPCORD
(cAliasOPC)->(dbCloseArea())

If ! Empty(mOpc)
	cFilSG1 := xFilial("SG1")
	//Opcionais n�o selecionados - n�o gerar
	cQuery := " SELECT CZI.R_E_C_N_O_ CZIREC"
	cQuery += " FROM " + RetSqlName("CZI")+ " CZI "
	cQuery += " WHERE CZI.CZI_FILIAL = '" + cFilCZI + "' "
	cQuery += "AND CZI.CZI_ALIAS  = 'CZJ' "
	cQuery += "AND CZI.CZI_NRLV = '99' "
	cQuery += "AND NOT EXISTS (SELECT 1 FROM  " + RetSqlName("SG1") + " SG1"
	cQuery += " WHERE SG1.G1_FILIAL = '" + cFilSG1 + "' "
	cQuery += "AND SG1.G1_COMP = CZI.CZI_PROD "
 	cQuery += "AND CZI.CZI_OPCORD LIKE '%'||SG1.G1_GROPC||SG1.G1_OPC || '%')"

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasOPC,.T.,.T.)

	TCSetField( cAliasOPC, 'CZIREC','N', 6, 0 )

	dbEval({|| ZeraReg(cAliasOPC)})
	(cAliasOPC)->(dbCloseArea())

	//Opcionais selecionados - gerar
	cQuery := " SELECT CZI.CZI_PROD,CZI_NRLV"
	cQuery += " FROM " + RetSqlName("CZI")+ " CZI "
	cQuery += " WHERE CZI.CZI_FILIAL = '" + cFilCZI + "' "
	cQuery += "AND CZI.CZI_ALIAS  = 'CZJ' "
	cQuery += "AND CZI.CZI_NRLV = '99' "
	cQuery += "AND EXISTS (SELECT 1 FROM " + RetSqlName("SG1") + " SG1"
	cQuery += " WHERE SG1.G1_FILIAL = '" + cFilSG1 + "' "
	cQuery += "AND SG1.G1_COMP = CZI.CZI_PROD "
 	cQuery += "AND CZI.CZI_OPCORD LIKE '%'||SG1.G1_GROPC||SG1.G1_OPC || '%')"

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasOPC,.T.,.T.)

	dbEval( {|| aAdd(aGeraOPC,{CZI_PROD,CZI_NRLV})},{|| Ascan(aGeraOPC,{|s|s[1] == CZI_PROD})==0 } )
	(cAliasOpc)->(dbCloseArea())
Endif
Return()


Static Function ZeraReg(cAliasOPC)
CZI->(dbGoto((cAliasOPC)->CZIREC))
CZI->(dbrLock())
CZI->(dbDelete())
CZI->(dbrUnlock())
Return(Nil)*/

/*------------------------------------------------------------------------//
//Programa:	A712ExplEs
//Autor:		Ricardo Prandi
//Data:		27/09/2013
//Descricao:	Explode a estrutura do produto no MRP
//Parametros:	01.cProduto		- Codigo do produto a ser explodido
//				02.cOpcionais 	- Grupos de opcionais utilizados
//				03.cRevisao		- Revisao Estrutura
//				04.nQuant		- Quantidade base a ser explodida
//				05.cPeriodo		- Periodo da necessidade do produto
//				06.cParStrTipo	- String com tipos a serem processados
//				07.cParStrGrupo	- String com grupos a serem processados
//				08.aOpc			- Array de opcionais
//				09.lRecalc		- Indica se vai recalcular as necessidades
//				10.nNivExpl		- N�vel da estrutura que est� sendo explodido.
//				11.cProdFan     - Produto pai do produto fantasma.
//				12.lRecursivo	- Indica que a explos�o da estrutura ser� recursiva. Utilizado para subprodutos que atendem a necessidade produzindo.
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712ExplEs(cProduto,cOpcionais,cRevisao,nQuant,cPeriodo,cParStrTipo,cParStrGrupo,aOpc,lRecalc,nNivExpl,cProdFan,lRecursivo)

Static cComando := Nil

Local aDados 	 	:= {}
Local lAllTp		:= Ascan(A711Tipo,{|x| x[1] == .F.}) == 0
Local lAllGrp		:= Ascan(A711Grupo,{|x| x[1] == .F.}) == 0
Local dDataNes 	:= dDataBase
Local nQuantItem 	:= 0
Local nSaldoMP	:= 0
Local nQuantParc 	:= 0
Local nPrazoEnt	:= CalcPrazo(cProduto,nQuant,,,.F.,aPeriodos[Val(cPeriodo)])
Local cRev711Vaz 	:= ""//CriaVar("B1_REVATU",.F.)
Local cQuery 		:= ""
Local cAliasSG1 	:= ""
Local cAliasSB1	:= ""
Local cTipoEst	:= ""
Local cStrTipo	:= ""
Local cStrGrupo	:= ""
Local cFilSG1   := xFilial("SG1")
Local cNivel		:= "99"
Local lCompNeg	:= .F.
Local lMT710EXP	:= .T.
Local lHasAlt   := .F.
Local cRelac    := Nil
Local mOpc      := ""
Local cGrupos   := ""
Local cOpcBKP   := cOpcionais
Local aOpcBKP   := aOpc

Default aOpc 		:= {}
Default lRecalc 	:= .T.
Default nNivExpl	:= 0
Default cProdFan	:= Nil
Default lRecursivo	:= .F.

lGeraOPI:= SuperGETMV("MV_GERAOPI")

If cRevBranco == Nil
	cRevBranco := CriaVar("B1_REVATU",.F.)
EndIf

cRev711Vaz := cRevBranco

If cComando == Nil
	If "MSSQL" $ AllTrim(Upper(TcGetDb()))
		cComando := "ISNULL"
	Else
		cComando := "COALESCE"
	EndIf
EndIf

If lMRPCINQ == Nil
	lMRPCINQ := SuperGetMV("MV_MRPCINQ",.F.,.F.)
EndIf

If ValType(cParStrTipo) == "C"
	cStrTipo := cParStrTipo
EndIf

If ValType(cParStrGrupo) == "C"
	cStrGrupo := cParStrGrupo
EndIf

//Verifica se o movimento esta dentro do periodo
If !Empty(cPeriodo)
	dDataNes := aPeriodos[Val(cPeriodo)]

	If nQuant > 0 .And. lLogMRP
		aDados := {cProduto,nQuant,SomaPrazo(dDataNes,-nPrazoEnt)}
		A712CriaLOG("004",cProduto,aDados,lLogMRP,c711NumMrp)
	EndIf

	cAliasSG1 := GetNextAlias()
	cAliasSB1 := cAliasSG1

    //Prepara SQL
    If oExplEs == Nil
        cQuery := " SELECT SG1.G1_FILIAL, " +;
	                     " SG1.G1_COD, " +;
	                     " SG1.G1_COMP, " +;
	                     " SG1.G1_POTENCI, " +;
	                     " SG1.G1_GROPC, " +;
    	                 " SG1.G1_OPC, " +;
	                     " SG1.G1_INI, " +;
	                     " SG1.G1_FIM, " +;
	                     " SG1.G1_PERDA, " +;
	                     " SG1.G1_FIXVAR, " +;
	                     " SG1.G1_TRT, " +;
    	                 " SG1.G1_REVINI, " +;
	                     " SG1.G1_REVFIM, " +;
	                     " SG1.G1_QUANT, " +;
	                     " SB1C.B1_REVATU BC_REVATU, " +;
	                     " SB1C.B1_TIPODEC BC_TIPODEC, " +;		
						 " SB1C.R_E_C_N_O_ BCREC, " +;				 
	                     " SB1P.B1_REVATU B1_REVATU, " +;
	                     " SB1P.B1_QBP B1_QBP, "

	    If cDadosProd == "SBZ"
		    cQuery += cComando + "(SBZC.BZ_FILIAL ,SB1C.B1_FILIAL)  BC_FILIAL, " +;
		              cComando + "(SBZC.BZ_COD    ,SB1C.B1_COD)     BC_COD, " +;
		              cComando + "(SBZC.BZ_FANTASM,SB1C.B1_FANTASM) BC_FANTASM, " +;
		              cComando + "(SBZC.BZ_EMIN   ,SB1C.B1_EMIN)    BC_EMIN, " +;
		              cComando + "(SBZP.BZ_FILIAL ,SB1P.B1_FILIAL)  B1_FILIAL, " +;
		              cComando + "(SBZP.BZ_COD    ,SB1P.B1_COD)     B1_COD, " +;
		              cComando + "(SBZP.BZ_OPC    ,SB1P.B1_OPC)     B1_OPC, " +;
		              cComando + "(SBZP.BZ_QB     ,SB1P.B1_QB)      B1_QB "
	    Else
		    cQuery += " SB1C.B1_FILIAL BC_FILIAL, " +;
		              " SB1C.B1_COD BC_COD, " +;
		              " SB1C.B1_FANTASM BC_FANTASM, " +;
		              " SB1C.B1_EMIN BC_EMIN, " +;
		              " SB1P.B1_FILIAL B1_FILIAL, " +;
		              " SB1P.B1_COD B1_COD, " +;
		              " SB1P.B1_OPC B1_OPC, " +;
		              " SB1P.B1_QB B1_QB "
	    EndIf

	    If cDadosProd == "SBZ"
		    cQuery += " FROM " + RetSqlName("SG1") + " SG1, " +; //estrutura
		                         RetSqlName("SB1") + " SB1C " +; //produto linkado com o componente
		                         " LEFT OUTER JOIN " + RetSqlName("SBZ") + " SBZC " +;
		                         "   ON SBZC.BZ_FILIAL = '" + xFilial("SBZ") + "' " +;
		                         "  AND SBZC.BZ_COD    = SB1C.B1_COD " +;
		                         "  AND SBZC.D_E_L_E_T_ = ' ', " +;
    		                     RetSqlName("SB1") + " SB1P " +; //produto linkado com o pai
	    	                     " LEFT OUTER JOIN " + RetSqlName("SBZ") + " SBZP " +;
	       	                     "   ON SBZP.BZ_FILIAL = '" + xFilial("SBZ") + "' " +;
		                         "  AND SBZP.BZ_COD    = SB1P.B1_COD " +;
		                         "  AND SBZP.D_E_L_E_T_ = ' ' "
	    Else
		    cQuery += " FROM " + RetSqlName("SG1") + " SG1, "  +;//estrutura
		                         RetSqlName("SB1") + " SB1C, " +;//produto linkado com o componente
		                         RetSqlName("SB1") + " SB1P "    //produto linkado com o pai
	    EndIf

	    cQuery +=  " WHERE SG1.G1_FILIAL   = '" + cFilSG1 + "' " +;
	                 " AND SB1C.B1_FILIAL  = '" + xFilial("SB1") + "' " +;
	                 " AND SB1P.B1_FILIAL  = '" + xFilial("SB1") + "' " +;
	                 " AND SB1C.D_E_L_E_T_ = ' ' " +;
    	             " AND SB1P.D_E_L_E_T_ = ' ' " +;
	                 " AND SG1.G1_COMP     = SB1C.B1_COD " +;
	                 " AND SG1.G1_COD      = SB1P.B1_COD " +;
	                 " AND SG1.G1_COD      = ? " +; //cProduto
	                 " AND SG1.D_E_L_E_T_  = ' ' " +;
    	             " AND SB1P.D_E_L_E_T_ = ' ' " +;
	                 " AND SB1C.D_E_L_E_T_ = ' ' " +;
		    		 " AND SB1P.B1_MSBLQL  <> '1'" +;
                     " AND SB1C.B1_MSBLQL  <> '1'"

	    If cDadosProd == "SBZ"
		    cQuery += " AND " + cComando + "(SBZC.BZ_MRP,SB1C.B1_MRP) IN (' ','S') "
		    cQuery += " AND (((SBZC.D_E_L_E_T_ IS NOT NULL AND SBZC.D_E_L_E_T_ = ' ' )  AND SBZP.D_E_L_E_T_ IS NULL) OR "
            cQuery += "      ((SBZP.D_E_L_E_T_ IS NOT NULL AND SBZP.D_E_L_E_T_ = ' ' )  AND SBZC.D_E_L_E_T_ IS NULL) OR "
            cQuery += "      ((SBZP.D_E_L_E_T_ IS NOT NULL AND SBZP.D_E_L_E_T_ = ' ' )  AND (SBZC.D_E_L_E_T_ IS NOT NULL AND SBZC.D_E_L_E_T_ = ' ' )) OR "
            cQuery += "      (SBZC.D_E_L_E_T_ IS NULL      AND SBZP.D_E_L_E_T_ IS NULL)) "
	    Else
		    cQuery += " AND SB1C.B1_MRP IN (' ','S') "
	    EndIf

	    //Filtra os tipos
	    If !lAllTp
		    cQuery += " AND SB1C.B1_TIPO IN (SELECT TP_TIPO FROM " +cNomCZITTP +") "
	    EndIf

	    //Filtro os grupos
	    If !lAllGrp .And. lMRPCINQ
		    cQuery += " AND SB1C.B1_GRUPO IN (SELECT GR_GRUPO FROM " +cNomCZITGR +") "
	    End If

        cQuery += " ORDER BY " + SqlOrder(SG1->(IndexKey(1)))
        cQuery := ChangeQuery(cQuery)

        oExplEs := FWPreparedStatement():New(cQuery)
    EndIf

    //PRODUTO
	oExplEs:SetString(1,cProduto)

	//Busca query fixada com os valores
	cQuery := oExplEs:GetFixQuery()

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSG1,.T.,.T.)
	dbSelectArea(cAliasSG1)

	While !Eof()

		cOpcionais := cOpcBKP
		aOpc       := aOpcBKP

		mOpc := ""
		If Len(aOpc) > 0
			If Empty((mOpc := Array2Str(aOpc,.F.)))
				mOpc := ""
			EndIf
		EndIf
	
		cB1Rest := SB1->(GetArea())	 				
		nRecno := (cAliasSG1)->BCREC
		SB1->(DbGoTo(nRecno))
		cOpcI := SB1->B1_OPC
		mOpcI := SB1->B1_MOPC		
		SB1->(RestArea(cB1Rest))

		If (Empty(mOpc) .Or. lGeraOPI = .F.) .And. !Empty(mOpcI)
			mOpc := mOpcI
			If (aOpc := Str2Array(mOpc,.F.)) == Nil
				aOpc := {}
        	EndIf
		EndIf

		If SG1->(MsSeek(cFilSG1+(cAliasSG1)->G1_COMP))
			cTipoEst := "F"
			cNivel   := SG1->G1_NIV
		Else
			cTipoEst := "C"
			cNivel   := "99"
		EndIf

		If !Empty(mOpc) .And. !Empty(cProduto)
			cGrupos := A712EstOpc(cProduto,MontaOpc(mOpc),Nil,Nil,cStrTipo,cStrGrupo)
			cOpcionais := IIf(Empty(cGrupos),"",A712AvlOpc(MontaOpc(mOpc,cProduto,Iif(nNivExpl==0,cNivel,nNivExpl)),cGrupos))
		EndIf

		//Calcula quantidade
		nQuantItem :=  ExplEstr(nQuant,dDataNes-nPrazoEnt,cOpcionais,cRevisao,/*05*/,/*06*/,/*07*/,cAliasSG1,cAliasSB1,.T.)

		//Calcula decimais
		Do Case
			Case ((cAliasSG1)->BC_TIPODEC == "A")
				nQuantItem := Round(nQuantItem,0)
			Case ((cAliasSG1)->BC_TIPODEC == "I")
				nQuantItem := Int(nQuantItem) + If(((nQuantItem-Int(nQuantItem)) > 0),1,0)
			Case ((cAliasSG1)->BC_TIPODEC == "T")
				nQuantItem := Int(nQuantItem)
		EndCase

		If (QtdComp(nQuantItem) == QtdComp(0))
			dbSkip()
			Loop
		EndIf

		lCompNeg := QtdComp(nQuantItem,.T.) < QtdComp(0,.T.)

		//Calcula potencia
		If !Empty((cAliasSG1)->G1_POTENCI) .And. PotencLote((cAliasSG1)->G1_COMP) .And. QtdComp(nQuantItem) > QtdComp(0)
			nQuantItem := nQuantItem * ((cAliasSG1)->G1_POTENCI/100)
		EndIf

		If (cAliasSG1)->BC_FANTASM == "S" .Or. (cTipoEst == "F" .And. !lGeraPI)
			If lPEMT710EXP
				lMT710EXP := ExecBlock("MT710EXP",.F.,.F.,{(cAliasSG1)->G1_COMP,cOpcionais,cRevisao,nQuantItem})
				If ValType(lMT710EXP) # "L"
					lMT710EXP := .T.
				EndIf
			EndIf

			If lMT710EXP
				A712ExplEs((cAliasSG1)->G1_COMP,cOpcionais,cRevisao,nQuantItem,A650DtoPer(SomaPrazo(dDataNes,-nPrazoEnt)),cStrTipo,cStrGrupo,aOpc,.T.,nNivExpl+1,(cAliasSG1)->G1_COD)
			EndIf
		ElseIf QtdComp(nQuantItem,.T.) # QtdComp(0,.T.)
			//Ponto de Entrada M710QTDE - Necessidade do Produto
			If lM710Qtde
				nQtdRet := ExecBlock( "M710QTDE", .F., .F., {cProduto, nQuantItem, dDataNes} )
				If ValType(nQtdRet) == "N"
					nQuantItem := nQtdRet
				EndIf
			EndIf

			//Avalia saldo do componente para verificar alternativos
			lHasAlt := ProdHasAlt((cAliasSG1)->G1_COMP)
			If lHasAlt
				nSaldoMP := A712SldCZK((cAliasSG1)->G1_COMP,cPeriodo,Space(Len((cAliasSG1)->(G1_GROPC+G1_OPC))),IIF(lPCPREVATU , PCPREVATU((cAliasSG1)->B1_COD), (cAliasSG1)->B1_REVATU) ,cNivel,(cAliasSG1)->BC_EMIN,lRecalc)
			Else
				nSaldoMP := 0
			EndIf
			cRelac := Nil

            //Gera CZI para uso do saldo (seja parcial ou integral)
			If (lCompNeg .Or. (nQuantItem > 0 .And. nSaldoMP > 0))
				//Quantidade a gerar no CZI
				nQuantParc := If(lCompNeg,nQuantItem,Min(nSaldoMP,nQuantItem))

				//Gera log MRP e CZI
				If lLogMRP
					aDados := {(cAliasSG1)->G1_COD,nQuantParc,SomaPrazo(dDataNes,-nPrazoEnt)}
					A712CriaLOG("004",(cAliasSG1)->G1_COMP,aDados,lLogMRP,c711NumMrp)
				EndIf
				cRelac := cValToChar(nRecZero)
				A712CriCZI(SomaPrazo(dDataNes,-nPrazoEnt),(cAliasSG1)->G1_COMP,/*03*/,cRevisao,If(lCompNeg,"ENG","CZJ"),0,Iif(cProdFan != Nil,cProdFan,(cAliasSG1)->G1_COD),/*08*/,cRelac,ABS(nQuantParc),If(lCompNeg,"2","4"),.F.,/*13*/,/*14*/,Iif(lRecalc .And. lRecursivo,.T.,.F.),.T.,/*17*/,/*18*/,/*19*/,cParStrTipo,cParStrGrupo,nPrazoEnt,/*23*/,aOpc,cOpcionais,cNivel,nNivExpl+1)

				//Avalia se o produto eh utilizado na tabela SGI como original ou alternativo
				If lHasAlt .Or. A712ExSGI((cAliasSG1)->G1_COMP)
					//Avalia se o produto n�o foi utilizado como alternativo em data futura e troca
					A712AvSldA((cAliasSG1)->G1_COMP,cPeriodo,cRev711Vaz,cParStrTipo,cParStrGrupo,SomaPrazo(dDataNes,-nPrazoEnt))
				EndIf
			EndIf

			//Se nao componente negativo e ficou saldo a gerar na CZK, tenta usar componentes
			If !lCompNeg .And. nSaldoMP < nQuantItem
				//Quantidade a procurar os alternativos
				nQuantParc := nQuantItem - Max(nSaldoMP,0)

				//Avalia existencia de saldo e possivel utilizacao de alternativos (SGI)
				If lHasAlt
					nQuantItem := A712VerAlt((cAliasSG1)->G1_COMP,Iif(cProdFan != Nil,cProdFan,(cAliasSG1)->G1_COD),cPeriodo,nQuantParc,cParStrTipo,cParStrGrupo,cRev711Vaz,dDataNes,nPrazoEnt,cOpcionais,cAliasSG1,lRecalc)
				EndIf

				//-- Gera Log MRP e SH5 da sobra (o que nao atendeu por alternativo)
				If nQuantItem > 0
					If lLogMRP
						aDados := {(cAliasSG1)->G1_COMP,nQuantItem,SomaPrazo(dDataNes,-nPrazoEnt)}
						A712CriaLOG("004",(cAliasSG1)->G1_COMP,aDados,lLogMRP,c711NumMrp)
					EndIf

					A712CriCZI(SomaPrazo(dDataNes,-nPrazoEnt),(cAliasSG1)->G1_COMP,/*(cAliasSG1)->(G1_GROPC+G1_OPC)03*/,cRevisao,"CZJ",0,Iif(cProdFan != Nil,cProdFan,(cAliasSG1)->G1_COD),/*08*/,cRelac,nQuantItem,"4",.F.,/*13*/,/*14*/,Iif(lRecalc .And. lRecursivo,.T.,.F.),.T.,/*17*/,/*18*/,/*19*/,cParStrTipo,cParStrGrupo,nPrazoEnt,/*23*/,aOpc,/*(IIF(Len((cAliasSG1)->(G1_GROPC+G1_OPC)) > 0," ",*/cOpcionais/*))*/,cNivel,nNivExpl+1)
					If lRecursivo
						A712ExplEs((cAliasSG1)->G1_COMP,cOpcionais,cRevisao,nQuantItem,A650DtoPer(SomaPrazo(dDataNes,-nPrazoEnt)),cStrTipo,cStrGrupo,aOpc,.T.,nNivExpl+1,Nil,lRecursivo)
					EndIf
				EndIf
			EndIf
		EndIf
		dbSelectArea(cAliasSG1)
		dbSkip()
	Enddo

	(cAliasSg1)->(dbCloseArea())
EndIf

Return

/*------------------------------------------------------------------------//
//Programa:		A712AvSldA
//Autor:		Ricardo Prandi
//Data:			30/04/2015
//Descricao:	Funcao utilizada para avaliar se o saldo do alternativo foi
//				consumido em data futura, avaliando a existencia de outrO
//          	alternativo para substituicao
//Parametros:	01.cProdAlt 	- Codigo do produto alternativo a ser avaliado
//				02.cPeriodo 	- Periodo inicial da avalia��o
//				03.cRev711Vaz	- Revisao Estrutura
//				04.cParStrTipo	- String com tipos a serem processados
//				05.cParStrGrupo	- String com tipos os grupos a serem processados
//				06.dDataNes		- Data da necessidade
//              07.lCalcula     - Indica se ser� realizado o rec�lculo das necessidades
//Uso: 			MATA712
//------------------------------------------------------------------------*/
Static Function A712AvSldA(cProdAlt,cPeriodo,cRev711Vaz,cParStrTipo,cParStrGrupo,dDataNes,lCalcula)
Local nSaldo 	 := 0
Local nQuant	 := 0
Local nQuantParc := 0
Local nQtdConv	 := 0
Local nNewPer	 := 0
Local cProdTroca := ""
Local cDocTroca	 := ""
Local dDataTroca := dDataBase
Local aAreaSB1 	 := SB1->(GetArea())
Local aAreaSGI	 := SGI->(GetArea())
Local aAreaCZI	 := CZI->(GetArea())
Local aAreaCZJ	 := CZJ->(GetArea())
Local aAreaCZK	 := CZK->(GetArea())
Local aAreaSG1	 := SG1->(GetArea())
Local cCziPos    := ""
Local cFilSB1    := xFilial("SB1")
Local cFilCZI    := xFilial("CZI")
Local cOpcOrd    := CriaVar("CZI_OPCORD")

Default lCalcula := .T.

SB1->(dbSetOrder(1))
SGI->(dbSetOrder(1))
CZJ->(dbSetOrder(1))

For nNewPer := Val(cPeriodo)+1 To Len(aPeriodos)
	cPeriodo := StrZero(nNewPer,3)

	If SB1->B1_COD != cProdAlt
        //Posiciona no cadastro do produto
	    SB1->(dbSeek(xFilial("SB1")+cProdAlt))
    EndIf

	//Verifica saldo do produto alternativo no periodo.
	nSaldo := A712SldCZK(cProdAlt,cPeriodo,cOpcOrd, IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU ),/*05*/,/*06*/,lCalcula)

    //Trava para garantir que o recalculo seja executado uma unica vez dentro do FOR
    If lCalcula
		lCalcula := .F.
	EndIf

	If nSaldo < 0

		CZI->(DbSetOrder(1))
		CZI->(dbSeek(cFilCZI+cProdAlt+If(A712TrataRev(),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU )/*SB1->B1_REVATU*/,cRev711Vaz)+cPeriodo+"4"))

		While nSaldo < 0 .And. !CZI->(EOF()) .And. CZI->(CZI_PROD+CZI_NRRV+CZI_PERMRP+CZI_TPRG) == ;
		                        cProdAlt+If(A712TrataRev(),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU )/*SB1->B1_REVATU*/,cRev711Vaz)+cPeriodo+"4"


			//Quantidade a trocar
			nQuantParc := Min(CZI->CZI_QUANT,Abs(nSaldo))

       		//Se a saida � do produto principal
       		If Empty(CZI->CZI_PRODOG)
       			//Procura disponibilidade do saldo utilizado nos produtos alternativos ja fazendo a troca
       			nQuant := A712VerAlt(cProdAlt,CZI->CZI_DOC,cPeriodo,nQuantParc,cParStrTipo,cParStrGrupo,cRev711Vaz,CZI->CZI_DTOG,0,cOpcOrd)
       			//Trocou saida inteira por alternativos
       			If nQuant == 0 .and. nQuantParc == CZI->CZI_QUANT
					//Remove saida da linha de saidas da estrutura
					CZJ->(dbSeek(xFilial("CZJ")+cProdAlt+If(A712TrataRev(),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU )/*SB1->B1_REVATU*/,cRev711Vaz)))

					CZK->(dbSeek(xFilial("CZK")+STR(CZJ->(RecNo()),10)+cPeriodo))
					RecLock("CZK",.F.)
					CZK->CZK_QTSEST -= CZI->CZI_QUANT
					CZK->(MsUnLock())

					//Remove saida
					RecLock("CZI",.F.)
					CZI->(dbDelete())
					CZI->(MsUnlock())

					//Recalcula saldo do produto no periodo
					cCziPos := CZI->(GetArea())
					MA712Recalc(cProdAlt,cOpcOrd,If(A712TrataRev(),IIF(lPCPREVATU,PCPREVATU(SB1->B1_COD),SB1->B1_REVATU ),cRev711Vaz),cPeriodo,/*05*/,/*06*/,/*07*/,CZJ->(RecNo()),SB1->B1_EMIN)
					CZI->(RestArea(cCziPos))
				ElseIf (nQuant < CZI->CZI_QUANT .And. nQuant > 0 .And. nQuant != nQuantParc) .Or. (nQuant == 0 .And. nQuantParc < CZI->CZI_QUANT ) //Trocou parte da saida por alternativos
					//-- Diminui saida da linha de saidas da estrutura
					CZJ->(dbSeek(xFilial("CZJ")+cProdAlt+If(A712TrataRev(),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU )/*SB1->B1_REVATU*/,cRev711Vaz)))

					CZK->(dbSeek(xFilial("CZK")+STR(CZJ->(RecNo()),10)+cPeriodo))
					RecLock("CZK",.F.)
					CZK->CZK_QTSEST -= nQuantParc - nQuant
					CZK->(MsUnLock())

					//Diminui saida do registro de necessidade
					RecLock("CZI",.F.)
					CZI->CZI_QUANT := CZI->CZI_QUANT - (nQuantParc - nQuant)
					CZI->(MsUnLock())

					//Recalcula saldo do produto no periodo
					cCziPos := CZI->(GetArea())
					MA712Recalc(cProdAlt,cOpcOrd,If(A712TrataRev(),IIF(lPCPREVATU,PCPREVATU(SB1->B1_COD),SB1->B1_REVATU ),cRev711Vaz),cPeriodo,/*05*/,/*06*/,/*07*/,CZJ->(RecNo()),SB1->B1_EMIN)
					CZI->(RestArea(cCziPos))
				EndIf
    	   	Else
       			//Se a saida e de produto alternativo de algum principal, posiciona SB1 no produto origem
       			SB1->(dbSeek(cFilSB1+CZI->CZI_PRODOG))

       			//Posiciona SGI no registro da mp original para pegar o fator de conversao
	       		SGI->(dbSeek(xFilial("SGI")+CZI->CZI_PRODOG))

	       		While !SGI->(EOF()) .And. SGI->(GI_FILIAL+GI_PRODORI) == xFilial("SGI")+CZI->CZI_PRODOG
	       			If SGI->GI_PRODALT == cProdAlt
		       			Exit
		       		EndIf
		       		SGI->(dbSkip())
	       		End

	       	    If SGI->GI_TIPOCON == "M"
					nQtdConv := nQuantParc / SGI->GI_FATOR
				Else
					nQtdConv := nQuantParc * SGI->GI_FATOR
				EndIf

				//Procura disponibilidade do saldo utilizado nos produtos alternativos ja fazendo a troca
				nQuant := A712VerAlt(CZI->CZI_PRODOG,CZI->CZI_DOC,cPeriodo,nQtdConv,cParStrTipo,cParStrGrupo,cRev711Vaz,CZI->CZI_DTOG,0,cOpcOrd)

       			//Trocou saida inteira por alternativo ou principal
       			If nQuantParc == CZI->CZI_QUANT
       				//Remove saida da linha de saidas da estrutura
					CZJ->(dbSeek(xFilial("CZJ")+cProdAlt+If(A712TrataRev(),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU )/*SB1->B1_REVATU*/,cRev711Vaz)))

       				CZK->(dbSeek(xFilial("CZK")+STR(CZJ->(RecNo()),10)+cPeriodo))
       				RecLock("CZK",.F.)
       				CZK->CZK_QTSEST -= CZI->CZI_QUANT
       				CZK->(MsUnLock())

       				cProdTroca := CZI->CZI_PRODOG
       				dDataTroca := CZI->CZI_DTOG
       				cDocTroca  := CZI->CZI_DOC

	       			//Remove saida
	       			RecLock("CZI",.F.)
	       			CZI->(dbDelete())
	       			CZI->(MsUnlock())

	       			//Recalcula saldo do produto no periodo
	       			cCziPos := CZI->(GetArea())
	       			MA712Recalc(cProdAlt,cOpcOrd,If(A712TrataRev(),IIF(lPCPREVATU,PCPREVATU(SB1->B1_COD),SB1->B1_REVATU ),cRev711Vaz),cPeriodo,/*05*/,/*06*/,/*07*/,CZJ->(RecNo()),SB1->B1_EMIN)
					CZI->(RestArea(cCziPos))
       			ElseIf nQuantParc < CZI->CZI_QUANT //Trocou parte da saida por alternativos
					//Diminui saida da linha de saidas da estrutura
					CZJ->(dbSeek(xFilial("CZJ")+cProdAlt+If(A712TrataRev(),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU )/*SB1->B1_REVATU*/,cRev711Vaz)))

       				CZK->(dbSeek(xFilial("CZK")+STR(CZJ->(RecNo()),10)+cPeriodo))
       				RecLock("CZK",.F.)
       				CZK->CZK_QTSEST -= nQuantParc
       				CZK->(MsUnLock())

					cProdTroca := CZI->CZI_PRODOG
       				dDataTroca := CZI->CZI_DTOG
       				cDocTroca  := CZI->CZI_DOC

					//Diminui saida do registro de necessidade
					RecLock("CZI",.F.)
					CZI->CZI_QUANT := CZI->CZI_QUANT - nQuantParc
					CZI->(MsUnLock())

					//Recalcula saldo do produto no periodo
					cCziPos := CZI->(GetArea())
					MA712Recalc(cProdAlt,cOpcOrd,If(A712TrataRev(),IIF(lPCPREVATU,PCPREVATU(SB1->B1_COD),SB1->B1_REVATU),cRev711Vaz),cPeriodo,/*05*/,/*06*/,/*07*/,CZJ->(RecNo()),SB1->B1_EMIN)
					CZI->(RestArea(cCziPos))
				EndIf

                //Gera saida do principal, ja que nao encontrou outros alternativos
				If nQuant > 0
					aDados := {cProdAlt,nQuant,dDataTroca}
					A712CriaLOG("004",cProdTroca,aDados,lLogMRP,c711NumMrp)

					A712CriCZI(dDataTroca, cProdTroca,CriaVar("CZI_OPCORD")  ,IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU )/*SB1->B1_REVATU*/,"CZJ",0,Padr(cDocTroca,Len(SG1->G1_COD)),/*08*/,/*09*/,nQuant,"4",.F.,/*13*/,/*14*/,.F.,.T.,/*17*/,/*18*/,/*19*/,cParStrTipo,cParStrGrupo,/*22*/,/*23*/,/*24*/,/*25*/,/*26*/)

					//Recalcula saldo do produto no periodo
					cCziPos := CZI->(GetArea())
					MA712Recalc(cProdTroca,cOpcOrd,If(A712TrataRev(),IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU ),cRev711Vaz),cPeriodo,/*05*/,/*06*/,/*07*/,CZJ->(RecNo()),SB1->B1_EMIN)
					CZI->(RestArea(cCziPos))

					//-- Avalia se o produto nao foi utilizado em data futura e troca se necess�rio
					A712AvSldA(cProdTroca,A650DtoPer(dDataTroca),cRev711Vaz,cParStrTipo,cParStrGrupo,dDataTroca)
				EndIf
			EndIf

			//-- Atualiza saldo do produto
			cCziPos := CZI->(GetArea())
			nSaldo := A712SldCZK(cProdAlt,cPeriodo,cOpcOrd,IIF(lPCPREVATU,PCPREVATU(SB1->B1_COD),SB1->B1_REVATU),/*05*/,/*06*/,.F.)
			CZI->(RestArea(cCziPos))

			CZI->(dbSkip())
		EndDo
	EndIf
Next nNewPer

SB1->(RestArea(aAreaSB1))
CZI->(RestArea(aAreaCZI))
CZJ->(RestArea(aAreaCZJ))
CZK->(RestArea(aAreaCZK))
SGI->(RestArea(aAreaSGI))
SG1->(RestArea(aAreaSG1))

Return

/*------------------------------------------------------------------------//
//Programa:	A712SldCZK
//Autor:		Ricardo Prandi
//Data:		    01/10/2013
//Descricao:	Retorna o saldo de um produto em determinado periodo pela projecao do MRP
//Parametros:	01.cProduto 		- Codigo do produto a ser explodido
//				02.cPeriodo		- Periodo da necessidade do produto
//				03.cOpc			- Lista de opcionais
//				04.cRevisao		- Revis�o da estrutura do item
//				05.cNivel			- Nivel do item
//				06.nPontoPed		- Ponto de pedido
//				07.lRecalc			- Indica se vai recalcular as necessidades
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712SldCZK(cProduto,cPeriodo,cOpc,cRevisao,cNivel,nPontoPed,lRecalc)
Local nRet   := 0
Local cSeek  := ""

Default lRecalc := .T.

If cRevBranco == Nil
	cRevBranco := CriaVar("B1_REVATU",.F.)
EndIf

cRevisao := If(!Empty(cRevisao) .And. A712TrataRev(),cRevisao,cRevBranco)
cOpc     := PadR(cOpc,Len(CZJ->CZJ_OPCORD))

CZJ->(dbSetOrder(3))
cSeek := xFilial("CZJ")+cProduto+IIF(LEN(cOpc)>200,Substr(cOpc,1,200),PADR(cOpc,TamSx3("CZJ_OPCORD")[1],''))+cRevisao
CZJ->(dbSeek(cSeek))

If lRecalc
	//Recalcula saldo para garantir integridade
	MA712Recalc(cProduto,cOpc,cRevisao,/*04*/,/*05*/,/*06*/,/*07*/,CZJ->(RecNo()),nPontoPed)
EndIf

CZK->(dbSetOrder(1))

cSeek := xFilial("CZK")+STR(CZJ->(RecNo()),10,0)+cPeriodo
If !CZK->(dbSeek(cSeek))
	nRet := 0
Else
	nRet := CZK->CZK_QTSLES + CZK->CZK_QTENTR - CZK->CZK_QTSAID - CZK->CZK_QTSEST
EndIf

Return nRet

/*------------------------------------------------------------------------//
//Programa:	MA712Recalc
//Autor:		Ricardo Prandi
//Data:		01/10/2013
//Descricao:	Rotina para recalcular saldos e necessidades do produto
//Parametros:	01.cProduto    	- Produto a ser recalculado
//				02.cOpc        	- Opcional do produto a ser recalculado
//				03.cRevisao   	- Revisao do produto relacionada ao movimento
//				04.cPeriodo    	- Periodo inicial do recalculo
//				05.nNovoSalIni 	- Novo saldo inicial do produto no periodo inicial
//				06.lForcaCalc		- Indica se for�a o calculo
//				07.lInJob			- Indica se est� em JOB
//				08.nRecNoCZJ		- Numero do registro na tabela do MRP
//				09.nPontoPed		- Ponto de pedido
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MA712Recalc(cProduto,cOpc,cRevisao,cPeriodo,nNovoSalIni,lForcaCalc,lInJob,nRecNoCZJ,nPontoPed,cNivel)
Local nEntrada	   := 0
Local nSaida	   := 0
Local nSaldoAtu	   := 0
Local nNecessidade := 0
Local nSaidaEstr   := 0
Local nEstSeg	   := 0
Local nHFSALDO	   := 0
Local cSeek		   := ""
Local nLotVnc	   := 0
Local nTotSaida	   := 0
Local nQtdPP	   := 0  //CH TRAAXW
Local nTamProd     := 0
Local w			   := 0
Local nQtdNec  	   := 0
Local nSldAtuBkp   := 0
Local cQuery   	   := ""
Local cAliasNec    := ""
Local nQtdCalc     := 0
Local cNivelEstr   := "99"
Local aAreaSG1 	   := SG1->(GetArea())
Local nSldCons 	   := 0
Local lSemSld  	   := .F.
Local nNecOri      := 0
Local nNecDif      := 0
Local lM712Need    := ExistBlock('M712NEED')
Local lM712Sai	   := ExistBlock('M712SAI')
//Variavels para valida opcionas default
Local lOpSc         := IsInCallStack("MAT712OPSC")
Local cFilSHF       := ''
Local cFilCZK       := xFilial("CZK")
Local lFezLock      := .F.
Local cPerAtu       := ""
Local cFilCZI 		:= ""
Local nSizFil		:= FWSizeFilial()
Local nBackSaidas	:= 0
Local cSai			:= 0

DEFAULT cPeriodo	:= "001"
DEFAULT nNovoSalIni	:= 0
DEFAULT lForcaCalc 	:= .F.
DEFAULT lInJob    	:= .F.
DEFAULT nPontoPed	:= 0
DEFAULT cNivel      := Nil

If aPergs711[32] == 1
	nTamProd := TamSX3("HF_PRODUTO")[1]
EndIf

If Empty(nRecNoCZJ)
	CZJ->(dbSetOrder(1))
	CZJ->(dbSeek(xFilial("CZJ")+cProduto+cOpc+cRevisao))
EndIf

If Empty(cNivel)
	SG1->(dbSetOrder(1))
	cNivelEstr := IIf (SG1->(msSeek(xFilial("SG1")+cProduto)),SG1->G1_NIV,"99")
	SG1->(RestArea(aAreaSG1))
Else
	cNivelEstr := cNivel
EndIf

nTotSaida := 0

//Se calcular estoque de seguran�a ou ponto de pedido, posiciona a SB1
If aPergs711[26] == 3 .Or. aPergs711[31] == 1
	SB1->(MsSeek(xFilial("SB1") + cProduto))

	If aPergs711[26] == 3
		nEstSeg := CalcEstSeg(RetFldProd(SB1->B1_COD,"B1_ESTFOR"))
	EndIf

	If aPergs711[31] == 1 .And. Empty(nPontoPed)
		nPontoPed := RetFldProd(SB1->B1_COD,"B1_EMIN")
	EndIf

	//se nao tiver opcional default - zera o Ponto de Pedido e o Estoque seguranca para nao aparecer na tree
	If !MT712VLOPC(SB1->B1_COD, "", {}, "", "", , ,.F. , 1 )
		nPontoPed := 0
		nEstSeg := 0
	EndIf
EndIf

CZK->(dbSetOrder(1))
If aPergs711[32] == 1
	SHF->(dbSetOrder(1))
	cFilSHF := xFilial("SHF")
EndIf

dbSelectArea("SB1")

//Apos gravar registro recalcula todos periodos posteriores
For w := Val(cPeriodo) To Len(aPeriodos)
	lFezLock    := .F.
	cPerAtu     := StrZero(w,3)
	nEntrada	:= 0
	nSaida		:= 0
	nSaidaEstr	:= 0
	nLotVnc 	:= RetLotVenc(cProduto,aPeriodos[w])

	//Verifica o consumo dos lotes vencidos com o total de sa�das do produto.
	If nLotVnc <= nTotSaida
		nTotSaida 	-= nLotVnc
		nLotVnc 	:= 0
	Else
		nLotVnc 	-= nTotSaida
		nTotSaida 	:= 0
	EndIf

	//Se o total do lote vencido foi maior que o saldo incial, zera
	If nLotVnc <= nNovoSalIni
		nNovoSalIni -= nLotVnc
	Else
		nNovoSalIni := 0
	EndIf

	cSeek := cFilCZK+STR(nRecNoCZJ,10,0)+cPerAtu
	If CZK->(dbSeek(cSeek))
		//Pega o valor do saldo inicial em estoque
		If w == Val(cPeriodo)
			nNovoSalIni := CZK->CZK_QTSLES
		ElseIf CZK->CZK_QTSLES <> nNovoSalIni
			lFezLock := .T.
			If Reclock("CZK",.F.,,,lInJob)
				CZK->CZK_QTSLES := nNovoSalIni
				//CZK->(MsUnlock())
			EndIf
		EndIf
		//Pega o Valor da Saida
		cSai := CZK->CZK_QTSAID

		//Ponto de entrada, para altera��o das quantidade de Saidas dos produtos
		If lM712Sai
			cSai:=ExecBlock("M712SAI",.F.,.F.,{cProduto,cSai,aPeriodos[w]})
			If ValType(cSai) = "N" .And. CZK->CZK_QTSAID != cSai
				If !lFezLock
					lFezLock := .T.
					Reclock("CZK",.F.,,,lInJob)
				EndIf
				CZK->CZK_QTSAID := cSai
			EndIf
		endif

		//Obtem Entradas
		nEntrada += CZK->CZK_QTENTR

		//Obtem Saidas
		nSaida += CZK->CZK_QTSAID
		nTotSaida += nSaida

		//Obtem Saidas pela Estrutura
		nSaidaEstr += CZK->CZK_QTSEST
		nTotSaida += nSaidaEstr

		//Calcula Saldo Atual e Necessidade
		nSaldoAtu := nNovoSalIni + nEntrada - nSaida - nSaidaEstr

		//Calcula necessidade
		nHFSALDO := nNovoSalIni

		//Verifica estoque de seguran�a
		/*If aPergs711[26] == 3
			SB1->(MsSeek(xFilial("SB1") + cProduto))
			nEstSeg := CalcEstSeg(RetFldProd(SB1->B1_COD,"B1_ESTFOR"))
		EndIf*/

	    //Verifica ponto de pedido
	    If aPergs711[31] == 1
			/*If Empty(nPontoPed)
				SB1->(MsSeek(xFilial("SB1") + cProduto))
				nPontoPed := RetFldProd(SB1->B1_COD,"B1_EMIN")
			EndIf*/
			If !Empty(nPontoPed)
				//nPontoPed++            //CH TRAAXW
				nQtdPP := nPontoPed + 1  //CH TRAAXW
			EndIf
		EndIf

		//Calcula necessidade e saldo inicial do proximo periodo
		If QtdComp(nSaldoAtu - (nEstSeg + nQtdPP)) < QtdComp(0)  //CH TRAAXW
			nNecessidade := A712Lote(ABS((nEstSeg+nQtdPP)- nSaldoAtu),cProduto)  //CH TRAAXW
			nNecessidade := A711NecMax(cProduto, nSaldoAtu -(nEstSeg+nQtdPP), nNecessidade)
			//Ajusta necessidade caso passe do estoque maximo
			If aPergs711[19] == 2 .And. nNecessidade+nSaldoAtu > A711Sb1EstMax(cProduto) .And. A711Sb1EstMax(cProduto) > 0
				nNecessidade  := A711Sb1EstMax(cProduto)-nSaldoAtu
			EndIf
			nNovoSalIni  := nNecessidade+nSaldoAtu
			If aPergs711[16] == 2 .And. !lOpSc .And. ;
			   ((cNivelEstr == "99" .And. aPergs711[2] == 1) .Or. (cNivelEstr <> "99" .And. aPergs711[3] == 1)) .And. ;
			   !SB1->(B1_QE == 0 .And. B1_EMIN == 0 .And. B1_ESTSEG == 0 .And. B1_LE == 0 .And. B1_LM == 0 .And. B1_PE == 0 .And. B1_EMAX == 0)
				//Se estiver parametrizado para n�o aglutinar as ordens e gerar op/sc POR OP, calcula a qtd separada,
				//por cada sa�da de estrutura, para considerar corretamente as pol�ticas de estoque de acordo com as ops/scs que ser�o geradas.
				nSldCons := 0
				cFilCZI := xFilial("CZI")
				CZI->(dbSetOrder(1))
				If CZI->(dbSeek(cFilCZI+cProduto+cRevisao+cPerAtu+"4"))
				//	nNecessidade := 0
					nSldAtuBkp   := nSaldoAtu
					nNecDif      := 0
					nNecOri      := 0

					nSaldoAtu += nSaida // Desconta as sa�das, pois elas ser�o calculadas separadamente depois.

					cAliasNec := GetNextAlias() + cValToChar(ThreadId())
					cQuery := " SELECT SUM(CZI.CZI_QUANT) QTDCZI, CZI.CZI_DOC, CZI.CZI_DOCKEY "
					cQuery +=   " FROM " + RetSqlName("CZI") + " CZI "
					cQuery +=  " WHERE CZI.CZI_FILIAL = '"+cFilCZI+"' "
					cQuery +=    " AND CZI.CZI_PROD   = '"+cProduto+"' "
					cQuery +=    " AND CZI.CZI_NRRV   = '"+cRevisao+"' "
					cQuery +=    " AND CZI.CZI_PERMRP = '"+cPerAtu+"' "
					cQuery +=    " AND CZI.CZI_TPRG   = '4' "
					cQuery +=  " GROUP BY CZI.CZI_DOC, CZI.CZI_DOCKEY "

					//cQuery := ChangeQuery(cQuery)

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNec,.T.,.T.)
					While (cAliasNec)->(!Eof())
						nSaldoAtu += (cAliasNec)->(QTDCZI)
						//Se a necessidade atual calculada, menos o saldo anterior for maior que 0, � porqu� a necessidade
						//j� atende todas as demandas do per�odo, e n�o � mais necess�rio gerar saldos.
						If nNecessidade-ABS(nSldAtuBkp) >= 0
							(cAliasNec)->(dbSkip())
							Loop
						EndIf

						IF nSaldoAtu-(nEstSeg+nQtdPP)>0
						 	nQtdCalc := (cAliasNec)->(QTDCZI) - (nSaldoAtu-(nEstSeg+nQtdPP))
						ELSE
							nQtdCalc := ((nEstSeg+nQtdPP)-nSaldoAtu) + (cAliasNec)->(QTDCZI)
						ENDIF

						//nQtdCalc := (cAliasNec)->(QTDCZI) - Iif(nSaldoAtu-(nEstSeg+nQtdPP)>0,nSaldoAtu-(nEstSeg+nQtdPP),0)
						If nQtdCalc < 0
							nQtdCalc := 0
							nSldCons += (cAliasNec)->(QTDCZI)
						EndIf

						nNecOri += nQtdCalc

						nQtdNec := A712Lote(ABS(nQtdCalc),cProduto)  //CH TRAAXW
						nQtdNec := A711NecMax(cProduto, ABS(nQtdCalc), nQtdNec)

						nNecessidade += nQtdNec

						If nQtdNec > 0 .And. nQtdNec > (cAliasNec)->(QTDCZI)
							nSaldoAtu := nSaldoAtu + (nQtdNec - (cAliasNec)->(QTDCZI))
						EndIf

						(cAliasNec)->(dbSkip())
					End

					(cAliasNec)->(DbCloseArea())
					dbSelectArea("CZK")

                    //Recalcula as quantidades que n�o s�o de sa�das de estrutura.
					If nSaldoAtu >= (nEstSeg+nQtdPP)
						nQtdNec := 0
					Else
						nQtdNec := ABS((nEstSeg+nQtdPP)- nSaldoAtu)
					EndIf

                    //nSaldoAtu := nSldAtuBkp
					lSemSld := .F.

                    If nSldCons >= nSaldoAtu
						lSemSld := .T.
					EndIf

                    CZI->(dbSeek(cFilCZI+cProduto+cRevisao+cPerAtu))

                    While CZI->(!Eof()) .And. CZI->(CZI_FILIAL+CZI_PROD+CZI_NRRV+CZI_PERMRP) == cFilCZI+cProduto+cRevisao+cPerAtu
						If ! CZI->CZI_TPRG $ " 1245"
							If lSemSld .Or. nSldCons+CZI->CZI_QUANT > nSaldoAtu
								nQtdNec += CZI->CZI_QUANT - Iif(lSemSld,0,(nSaldoAtu-nSldCons))
								lSemSld := .T.
							Else
								nSldCons += CZI->CZI_QUANT
							EndIf
						EndIf
						CZI->(dbSkip())
					End

					If nQtdNec != 0 .And. nNecessidade-ABS(nSaldoAtu) < 0
						If nNecessidade > nNecOri
							nNecDif := nNecessidade - nNecOri
							If nQtdNec > nNecDif
								nQtdNec += nNecOri
								nQtdNec := A712Lote(nQtdNec,cProduto)
								nNecessidade := nQtdNec
							EndIf
						Else
							nQtdNec := A712Lote(nQtdNec,cProduto)
							nNecessidade += nQtdNec
						EndIf
					EndIf

					If (nSldAtuBkp + nNecessidade) < 0
						nNecessidade := ABS(nSldAtuBkp)
					EndIf

                    nSaldoAtu := nSldAtuBkp
					nNovoSalIni := nNecessidade+nSaldoAtu
				EndIf
			EndIf
		Else
			nNecessidade := 0
			nNovoSalIni := nSaldoAtu
		EndIf

        //Ponto de Entrada - M712Need para altera��o do valor da necessidade
		If lM712Need
			nBackNeed := nNecessidade

			cData := StrZero(Day(aPeriodos[w]),2)+"/"+StrZero(Month(aPeriodos[w]),2)+"/"+SubStr(StrZero(Year(aPeriodos[w]),4),3,2)

			aRetNeed := ExecBlock('M712NEED', .F., .F., {cProduto,nNecessidade,cData})

			IF !empty(aRetNeed) .AND. LEN(aRetNeed	[1]) == 2
				If ValType(aRetNeed[1][1]) # 'N' .OR. ValType(aRetNeed[1][2]) # "C"
					nNecessidade := nBackNeed
				Else
					IF  cData = aRetNeed[1][2]
						nNecessidade := aRetNeed[1][1]
					EndIf
				EndIf
			EndIf

			nNovoSalIni := nNecessidade+nSaldoAtu
		EndIf

		If CZK->CZK_QTSALD != nSaldoAtu .OR. CZK->CZK_QTNECE != nNecessidade
		    If !lFezLock
				lFezLock := .T.
			    Reclock("CZK",.F.,,,lInJob)
		    EndIf

		    CZK->CZK_QTSALD := nSaldoAtu
		    CZK->CZK_QTNECE := nNecessidade
		EndIf

        If lFezLock
		    CZK->(MsUnlock())
		EndIf
	Else
		//Pega o valor do saldo inicial em estoque
		If w == 1
			nNovoSalIni := 0
		EndIf

		//Obtem Entradas
		nEntrada += 0

		//Obtem Saidas
		nSaida += 0

		//Ponto de entrada, para altera��o das quantidade de Saidas dos produtos
		If lM712Sai
			nBackSaidas:= nSaida
			cSai:=ExecBlock("M712SAI",.F.,.F.,{cProduto,nSaida,aPeriodos[w]})

            If ValType(cSai) = "N"
				nSaida := cSai
			Else
				nSaida:=nBackSaidas
			EndIF
		EndIf

		nTotSaida += nSaida

		//Obtem Saidas pela Estrutura
		nSaidaEstr += 0
		nTotSaida += nSaidaEstr

		//Calcula Saldo Atual e Necessidade
		nSaldoAtu := nNovoSalIni + nEntrada - nSaida - nSaidaEstr

		//Calcula necessidade
		nHFSALDO := nNovoSalIni

		//Calcula necessidade e saldo inicial do proximo periodo
		/*If aPergs711[26] == 3
			SB1->(MsSeek(xFilial("SB1") + cProduto))
			nEstSeg := CalcEstSeg(RetFldProd(SB1->B1_COD,"B1_ESTFOR"))
		EndIf*/

		If aPergs711[31] == 1 .And. !Empty(nPontoPed)
			//nPontoPed++            //CH TRAAXW
			nQtdPP := nPontoPed + 1  //CH TRAAXW
		EndIf

		If QtdComp(nSaldoAtu - (nEstSeg + nQtdPP)) < QtdComp(0)  //CH TRAAXW
			nNecessidade := A712Lote(ABS((nEstSeg+nQtdPP)- nSaldoAtu),cProduto)  //CH TRAAXW
			nNecessidade := A711NecMax(cProduto, nSaldoAtu -(nEstSeg+nQtdPP), nNecessidade)

            //Ajusta necessidade caso passe do estoque maximo
			If aPergs711[19] == 2 .And. nNecessidade+nSaldoAtu > A711Sb1EstMax(cProduto) .And. A711Sb1EstMax(cProduto) > 0
				nNecessidade  := A711Sb1EstMax(cProduto)-nSaldoAtu
			EndIf

            nNovoSalIni  := nNecessidade+nSaldoAtu
		Else
			nNecessidade:=0
			nNovoSalIni :=nSaldoAtu
		EndIf

		//Ponto de Entrada - M712Need para altera��o do valor da necessidade
		If lM712Need
			nBackNeed 		:= nNecessidade

			cData := StrZero(Day(aPeriodos[w]),2)+"/"+StrZero(Month(aPeriodos[w]),2)+"/"+SubStr(StrZero(Year(aPeriodos[w]),4),3,2)

			aRetNeed := ExecBlock('M712NEED', .F., .F., {cProduto,nNecessidade,cData})

			IF !empty(aRetNeed) .AND. LEN(aRetNeed	[1]) == 2
				If ValType(aRetNeed[1][1]) # 'N' .OR. ValType(aRetNeed[1][2]) # "C"
					nNecessidade := nBackNeed
				ElseIF cData = aRetNeed[1][2]
					nNecessidade := aRetNeed[1][1]
				EndIf
			Endif

			nNovoSalIni := nNecessidade+nSaldoAtu
		EndIf

		If Reclock("CZK",.T.,,,lInJob)
			Replace CZK->CZK_FILIAL	With cFilCZK
			Replace CZK->CZK_NRMRP	With c711NumMRP
			Replace CZK->CZK_RGCZJ	With nRecNoCZJ
			Replace CZK->CZK_PERMRP	With cPerAtu
			Replace CZK->CZK_QTSLES	With nNovoSalIni
			Replace CZK->CZK_QTENTR	With nEntrada
			Replace CZK->CZK_QTSAID	With nSaida
			Replace CZK->CZK_QTSEST	With nSaidaEstr
			Replace CZK->CZK_QTSALD	With nSaldoAtu
			Replace CZK->CZK_QTNECE	With nNecessidade
			MsUnlock()
		EndIf
	EndIf

	If aPergs711[32] == 1
		cSeek := cFilSHF+Padr(cFilAnt,nSizFil,"")+Padr(cProduto,nTamProd)+DToS(aPeriodos[w])

		If SHF->(dbSeek(cSeek))
			If  SHF->HF_SALDO != nHFSALDO .OR. SHF->HF_ENTRADA != nEntrada .OR. ;
			   (SHF->HF_SAIDAS != (nSaida + nSaidaEstr)) .OR. SHF->HF_NECESSI != nNecessidade
			    RecLock("SHF",.F.,,,lInJob)
			    SHF->HF_SALDO	:= nHFSALDO
			    SHF->HF_ENTRADA	:= nEntrada
			    SHF->HF_SAIDAS	:= nSaida + nSaidaEstr
			    SHF->HF_NECESSI	:= nNecessidade
			    SHF->(MsUnLock())
			EndIf
		Else
			RecLock("SHF",.T.,,,lInJob)
			Replace SHF->HF_FILIAL 	With cFilSHF
			Replace SHF->HF_FILNEC	With cFilAnt
			Replace SHF->HF_PRODUTO	With cProduto
			Replace SHF->HF_DATA	With aPeriodos[w]
			Replace SHF->HF_SALDO	With nHFSALDO
			Replace SHF->HF_ENTRADA	With nEntrada
			Replace SHF->HF_SAIDAS	With nSaida + nSaidaEstr
			Replace SHF->HF_NECESSI	With nNecessidade
			SHF->(MsUnLock())
		EndIf
	EndIf
Next w

Return

/*------------------------------------------------------------------------//
//Programa:	A712ExSGI
//Autor:		Anieli Rodrigues
//Data:		26/10/12
//Descricao:	Verifica se um produto existe como Produto Original
//				ou como Produto Alternativo na tabela SGI
//Parametros:	cProduto: codigo do produto a ser buscado na tabela
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712ExSGI(cProduto)
Local aArea  		:= GetArea()
Local lRet 	 	:= .F.
Local cQuery 		:= ""

//Avalia se o produto eh alternativo ou possui algum alternativo
cAlias := "AVALT"
cQuery := " SELECT COUNT(*) nCount " +;
            " FROM " + RetSqlName("SGI") + " SGI " +;
           " WHERE (SGI.GI_FILIAL  = '" + xFilial("SGI") + "') " +;
             " AND (SGI.GI_PRODORI = '" + cProduto + "' " +;
             "  OR  SGI.GI_PRODALT = '" + cProduto + "') " +;
             " AND SGI.D_E_L_E_T_  = ' ' "
//cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
If (cAlias)->nCount < 1
	lRet := .F.
Else
	lRet := .T.
EndIf

(cAlias)->(DbCloseArea())
RestArea(aArea)

Return lRet

/*------------------------------------------------------------------------//
//Programa:		ProdHasAlt
//Autor:		Lucas Konrad Fran�a
//Data:			11/07/18
//Descricao:	Verifica se existem produtos alternativos para um determinado produto.
//Parametros:	cProduto: Produto que ser� verificado se existem alternativos
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function ProdHasAlt(cProduto)
Local aArea  := SGI->(GetArea())
Local lRet   := .F.

SGI->(dbSetOrder(1))
If SGI->(MsSeek(xFilial("SGI")+cProduto))
	lRet := .T.
EndIf

SGI->(RestArea(aArea))
Return lRet

/*------------------------------------------------------------------------//
//Programa:	A712VerAlt
//Autor:		Ricardo Prandi
//Data:		01/10/2013
//Descricao:	Verifica se ha produtos alternativos para substituicao na
//				geracao de necessidades.
//Parametros:	01.cProd			- Codigo do produto a ser buscado na tabela
//				02.cProdPai		- Codigo do item pai
//				03.cPeriodo		- N�mero do periodo
//				04.nQuantItem		- Quantidade do item
//				05.cParStrTipo	- String de tipos do item
//				06.cParStrGrupo	- String de grupos do item
//				07.cRev711Vaz		- Revis�o vazio
//				08.dDataNes		- Data da necessidade
//				09.nPrazoEnt		- Prazo de entrega
//				10.cOpcionais		- Opcionais
//				11.cAliasSG1		- Alias da SG1
//				12.lRecalc			- Indica se vai recalcular as necessidades
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712VerAlt(cProd,cProdPai,cPeriodo,nQuantItem,cParStrTipo,cParStrGrupo,cRev711Vaz,dDataNes,nPrazoEnt,cOpcionais,cAliasSG1,lRecalc)
Local nSldAlt		:= 0
Local nSldMp		:= 0
Local nQtdAlter	    := 0
Local cQuery		:= ""
Local cAliasSGI	    := ""
Local lVldAlt	    := .T.
Local lA712VLALT    := ExistBlock("A712VLALT")

Default cAliasSG1	:= "SG1"
Default lRecalc	:= .T.

If ValType(cParStrTipo) == "C"
	cStrTipo := cParStrTipo
EndIf

//Prepara SQL
If oVerAlt == Nil
    cQuery := " SELECT SGI.GI_FILIAL, " +;
                     " SGI.GI_PRODORI, " +;
                     " SGI.GI_PRODALT, " +;
                     " SGI.GI_TIPOCON, " +;
                     " SGI.GI_FATOR, " +;
                     " SB1.B1_REVATU, " +;
    				 " SB1.B1_COD, " +;
                     " SB1.B1_EMIN " +;
                " FROM " + RetSqlName("SGI") + " SGI, " + RetSqlName("SB1") + " SB1 " +;
               " WHERE SGI.GI_FILIAL  = '" + xFilial("SGI") + "' " +;
                 " AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "' " +;
                 " AND SB1.D_E_L_E_T_ = ' ' " +;
                 " AND SGI.GI_PRODALT = SB1.B1_COD " +;
                 " AND SGI.GI_PRODORI = ? " +; //cProd
                 " AND SGI.GI_MRP     = 'S' " +;
                 " AND SB1.B1_MRP     = 'S' " +;
                 " AND SGI.D_E_L_E_T_ = ' ' "

    oVerAlt := FWPreparedStatement():New(cQuery)
EndIf

//PRODUTO
oVerAlt:SetString(1,cProd)

//Busca query fixada com os valores
cQuery := oVerAlt:GetFixQuery()

//Busca Alias
cAliasSGI := GetNextAlias() + cValToChar(ThreadId())

//Executa Query
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSGI,.T.,.T.)
dbSelectArea(cAliasSGI)

While nQuantItem > 0 .And. !(cAliasSGI)->(Eof())
	//Ponto de Entrada para valida��o da utiliza��o deste alternativo
	If lA712VLALT
		lVldAlt := ExecBlock("A712VLALT",.F.,.F.,{(cAliasSGI)->GI_PRODORI,(cAliasSGI)->GI_PRODALT})
		If ValType(lVldAlt) == "L" .And. !lVldAlt
			(cAliasSGI)->(dbSkip())
			Loop
		EndIf
	EndIf

	//Converte a quantidade faltante conforme fator do alternativo
	If (cAliasSGI)->GI_TIPOCON == "M"
		nQtdAlter := (nQuantItem - Max(nSldMp,0)) * (cAliasSGI)->GI_FATOR
	Else
		nQtdAlter := (nQuantItem - Max(nSldMp,0)) / (cAliasSGI)->GI_FATOR
	EndIf

	//Obtem saldo do produto alternativo no periodo analisado
	nSldAlt := A712SldCZK((cAliasSGI)->GI_PRODALT,cPeriodo,cOpcionais,IIF(lPCPREVATU , PCPREVATU((cAliasSGI)->B1_COD), (cAliasSGI)->B1_REVATU )	,/*05*/,(cAliasSGI)->B1_EMIN,lRecalc)

	//Se tem saldo do alternativo, o utiliza
	If Min(nQtdAlter,nSldAlt) > 0
		//Gera Log MRP e SH5 da quantidade utilizada do alternativo
		aDados := {(cAliasSG1)->G1_COD,Min(nQtdAlter,nSldAlt),SomaPrazo(dDataNes,-nPrazoEnt)}

		A712CriaLOG("004",(cAliasSGI)->GI_PRODALT,aDados,lLogMRP,c711NumMrp)
		A712CriCZI(SomaPrazo(dDataNes,-nPrazoEnt),(cAliasSGI)->GI_PRODALT,(cAliasSG1)->(G1_GROPC+G1_OPC),IIF(lPCPREVATU , PCPREVATU((cAliasSGI)->B1_COD), (cAliasSGI)->B1_REVATU )	,"CZJ",0,cProdPai,/*08*/,/*09*/,Min(nQtdAlter,nSldAlt),"4",.F.,/*13*/,/*14*/,.T.,.T.,/*17*/,/*18*/,/*19*/,cParStrTipo,cParStrGrupo,/*22*/,cProd,/*24*/,cOpcionais,/*26*/)

		//Avalia se o alternativo nao foi utilizado em data futura e troca
		A712AvSldA((cAliasSGI)->GI_PRODALT,cPeriodo,cRev711Vaz,cParStrTipo,cParStrGrupo,dDataNes)

		//Volta nQuantItem com o saldo nao atendido
		If (cAliasSGI)->GI_TIPOCON == "M"
			nQuantItem -= Min(nQtdAlter,nSldAlt) / (cAliasSGI)->GI_FATOR
		Else
			nQuantItem -= Min(nQtdAlter,nSldAlt) * (cAliasSGI)->GI_FATOR
		EndIf
	EndIf
	(cAliasSGI)->(dbSkip())
End

(cAliasSGI)->(dbCloseArea())

Return nQuantItem

/*------------------------------------------------------------------------//
//Programa:	MA712ClNes
//Autor:		Ricardo Prandi
//Data:		02/10/2013
//Descricao:	Rotina para recalcular necessidades produto a produto
//Parametros:	01.cNivEst			- Nivel da estrutura para recalculo das necessidades
//				02.oCenterPanel 	- Objeto da tela de processamento
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MA712ClNes(cNivEst,oCenterPanel)
Local cJobFile 	:= ""
Local cJobAux  	:= ""
Local aThreads 	:= {}
Local aJobAux  	:= {}
Local nRetry_0 	:= 0
Local nRetry_1 	:= 0
Local nX       	:= 0
Local nPos     	:= 0
Local cStartPath	:= ""
//Local lThrSeq   	:= .F.
Local cOpc     	:= Space(Len(CZJ->CZJ_OPC))
Local lThreads 	:= .F.
Local cQuery		:= ""
Local cAliasTop	:= ""

If SuperGetMv('MV_A710THR',.F.,1) > 1
	lThreads := .T.
Endif

If lThreads
	//Diretorio do servidor protheus
	cStartPath := GetSrvProfString("Startpath","")
	//Habilita processamento de thread em sequencia
	//lThrSeq    := SuperGetMV("MV_THRSEQ",.F.,.F.)
	//Calcula Quebra por Threads
	aThreads := MATA712TZJ(cNivEst)
	//ProcRegua(Len(aThreads))

	For nX := 1 to Len(aThreads)
		//Informacoes do semaforo
		cJobFile := cStartPath + CriaTrab(Nil,.F.)+".job"

		//Adiciona o nome do arquivo de Job no array aJobAux
		aAdd(aJobAux,{StrZero(nX,2),cJobFile})

		//Inicializa variavel global de controle de thread
		cJobAux := "c712P"+cEmpAnt+cFilAnt+StrZero(nX,2)
		PutGlbValue(cJobAux,"0")
		GlbUnLock()

		//Atualiza o log de processamento
		ProcLogAtu("MENSAGEM","Iniciando de Recalculo das Necessidades - Thread:" + StrZero(nX,2),"Iniciando de Recalculo das Necessidades - Thread:" + StrZero(nX,2))

		//Dispara thread para Stored Procedure
		StartJob("A712JOBNes",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aThreads[nX,1],cJobFile,StrZero(nX,2),aPeriodos,aPergs711,aAlmoxNNR,c711NumMrp,aFilAlmox)
	Next nX

	//Controle de Seguranca para MULTI-THREAD
	For nX :=1 to Len(aThreads)
		nRetry_0 := 0
		nRetry_1 := 0
		
		nPos := ASCAN(aJobAux,{|x| x[1] == StrZero(nX,2)})

		//Informacoes do semaforo
		cJobFile := aJobAux[nPos,2]

		//Inicializa variavel global de controle de thread
		cJobAux := "c712P"+cEmpAnt+cFilAnt+StrZero(nX,2)

		While .T.
			Do Case
				//TRATAMENTO PARA ERRO DE SUBIDA DE THREAD
				Case GetGlbValue(cJobAux) == '0'
					If nRetry_0 > 50
						//Conout(Replicate("-",65))
						//Conout("MATA712: "+ "N�o foi possivel realizar a subida da thread" + " " + StrZero(nX,2))
						//Conout(Replicate("-",65))

						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","N�o foi possivel realizar a subida da thread","N�o foi possivel realizar a subida da thread")
						Final(STR0161) //"N�o foi possivel realizar a subida da thread"
					Else
						nRetry_0 ++
					EndIf

				//TRATAMENTO PARA ERRO DE CONEXAO
				Case GetGlbValue(cJobAux) == '1'
					If FCreate(cJobFile) # -1
						If nRetry_1 > 5
							//Conout(Replicate("-",65))
							//Conout("MATA712: Erro de conexao na thread")
							//Conout("Thread numero : " + StrZero(nX,2) )
							//Conout("Numero de tentativas excedidas")
							//Conout(Replicate("-",65))

							//Atualiza o log de processamento
							ProcLogAtu("MENSAGEM","MATA712: Erro de conexao na thread de procedures","MATA712: Erro de conexao na thread")
							Final(STR0162) //"MATA712: Erro de conexao na thread"
						Else
			    			//Inicializa variavel global de controle de Job
							PutGlbValue(cJobAux,"0")
							GlbUnLock()

							//Reiniciar thread
							//Conout(Replicate("-",65))
							//Conout("MATA712: Erro de conexao na thread")
							//Conout("Tentativa numero: "		+StrZero(nRetry_1,2))
							//Conout("Reiniciando a thread : "+StrZero(nX,2))
							//Conout(Replicate("-",65))

							//Atualiza o log de processamento
							ProcLogAtu("MENSAGEM","Reiniciando a thread : "+StrZero(nX,2),"Reiniciando a thread : "+StrZero(nX,2))

							//Dispara thread para Stored Procedure
							StartJob("A712JOBNes",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aThreads[nX,1],cJobFile,StrZero(nX,2),aPeriodos,aPergs711,aAlmoxNNR,c711NumMrp,aFilAlmox)
						EndIf
						nRetry_1 ++
					EndIf

				//TRATAMENTO PARA ERRO DE APLICACAO
				Case GetGlbValue(cJobAux) == '2'
					If FCreate(cJobFile) # -1
						//Conout(Replicate("-",65))
						//Conout("MATA712: Erro de aplicacao na thread ")
						//Conout("Thread numero : "+StrZero(nX,2))
						//Conout(Replicate("-",65))

						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","MATA712: Erro de aplicacao na thread","MATA712: Erro de aplicacao na thread")
						Final(STR0163) //"MATA712: Erro de aplicacao na thread"
					EndIf

				//THREAD PROCESSADA CORRETAMENTE
				Case GetGlbValue(cJobAux) == '3'
					//Atualiza o log de processamento
					ProcLogAtu("MENSAGEM","Termino do Recalculo das Necessidades - Thread:" + StrZero(nX,2),"Termino do Recalculo das Necessidades - Thread:" + StrZero(nX,2))
					//IncProc()
					Exit
			EndCase
			Sleep(500)
		End
	Next nX
Else
	//Verifica todos produtos utilizados
	cAliasTop := "RECNECES"
	If cDadosProd == "SBZ"
		cQuery += " SELECT DISTINCT CZJ.CZJ_PROD CZJ_PROD, " +;
		                          " CZJ.CZJ_NRRV CZJ_NRRV, " +;
		                          " COALESCE(BZ_EMIN,B1_EMIN) B1_EMIN, " +;
		                          " CZJ.CZJ_NRLV NIVEL, " +;
		                          " CZJ.R_E_C_N_O_ CZJREC " +;
		            " FROM " + RetSqlName("CZJ") + " CZJ, " +;
	              	         RetSqlName("CZK") + " CZK, " +;
	              	         RetSqlName("SB1") + " SB1 " +;
	              	         " LEFT OUTER JOIN " + RetSqlName("SBZ") + " SBZ  " +;
	              	           " ON SBZ.BZ_FILIAL  = '"+xFilial("SBZ")+"' " +;
		                        " AND SBZ.BZ_COD     = SB1.B1_COD " +;
		                        " AND SBZ.D_E_L_E_T_ = ' ' " +;
		           " WHERE CZJ.CZJ_FILIAL   = '" + xFilial("CZJ") + "' " +;
		             " AND CZK.CZK_FILIAL   = '" + xFilial("CZK") + "' " +;
		             " AND SB1.B1_FILIAL    = '" + xFilial("SB1") + "' " +;
		             " AND SB1.D_E_L_E_T_ = ' ' " +;
		             " AND CZJ.R_E_C_N_O_   = CZK.CZK_RGCZJ " +;
		             " AND CZJ.CZJ_PROD     = SB1.B1_COD " +;
		             " AND (CZK.CZK_QTNECE <> 0 " +;
		             "  OR  CZK.CZK_QTSAID <> 0 " +;
		             "  OR  CZK.CZK_QTSALD <> 0 " +;
		             "  OR  CZK.CZK_QTSEST <> 0 " +;
		             "  OR  CZK.CZK_QTENTR <> 0 " +;
		             "  OR  CZK.CZK_QTSLES <> 0 " +;
		             "  OR  COALESCE(BZ_EMIN,B1_EMIN) <> 0) "

		If !Empty(cNivEst)
			cQuery += " AND CZJ.CZJ_NRLV = '" + cNivEst + "' "
		EndIf

		cQuery += 	" ORDER BY CZJ.CZJ_PROD, " +;
	                 	  	  " CZJ.CZJ_NRRV, " +;
	                 	  	  " CZJ.R_E_C_N_O_ "
	Else
		cQuery += " SELECT DISTINCT CZJ.CZJ_PROD CZJ_PROD, " +;
		                          " CZJ.CZJ_NRRV CZJ_NRRV, " +;
		                          " SB1.B1_EMIN B1_EMIN, " +;
		                          " CZJ.CZJ_NRLV NIVEL, " +;
		                          " CZJ.R_E_C_N_O_ CZJREC " +;
		            " FROM " + RetSqlName("CZJ") + " CZJ, " +;
	              	         RetSqlName("CZK") + " CZK, " +;
	              	         RetSqlName("SB1") + " SB1 " +;
		           " WHERE CZJ.CZJ_FILIAL   = '" + xFilial("CZJ") + "' " +;
		             " AND CZK.CZK_FILIAL   = '" + xFilial("CZK") + "' " +;
		             " AND SB1.B1_FILIAL    = '" + xFilial("SB1") + "' " +;
		             " AND SB1.D_E_L_E_T_ = ' ' " +;
		             " AND CZJ.R_E_C_N_O_   = CZK.CZK_RGCZJ " +;
		             " AND CZJ.CZJ_PROD     = SB1.B1_COD " +;
		             " AND (CZK.CZK_QTNECE <> 0 " +;
		             "  OR  CZK.CZK_QTSAID <> 0 " +;
		             "  OR  CZK.CZK_QTSALD <> 0 " +;
		             "  OR  CZK.CZK_QTSEST <> 0 " +;
		             "  OR  CZK.CZK_QTENTR <> 0 " +;
		             "  OR  CZK.CZK_QTSLES <> 0 " +;
		             "  OR  B1_EMIN        <> 0) "

		If !Empty(cNivEst)
			cquery += " AND CZJ.CZJ_NRLV = '" + cNivEst + "' "
		EndIf

		cQuery += 	" ORDER BY CZJ.CZJ_PROD, " +;
	                 	  	  " CZJ.CZJ_NRRV, " +;
 	                	  	  " SB1.B1_EMIN, " +;
	                 	  	  " CZJ.R_E_C_N_O_ "
	EndIf

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
 	dbSelectArea(cAliasTop)

	If (oCenterPanel <> Nil)
		oCenterPanel:SetRegua1((cAliasTop)->(LastRec()))
	EndIf

	dbGotop()

	While !Eof()
		If (oCenterPanel <> Nil)
			oCenterPanel:IncRegua1(OemToAnsi(STR0108))
		EndIf

		nRecno := CZJREC
		CZJ->(DbGoTo(nRecno))
		cOpc := CZJ->CZJ_OPC

		MA712Recalc((cAliasTop)->CZJ_PROD,cOpc,(cAliasTop)->CZJ_NRRV,/*04*/,/*05*/,/*06*/,/*07*/,(cAliasTop)->CZJREC,(cAliasTop)->B1_EMIN,(cAliasTop)->NIVEL)

		dbSelectArea(cAliasTop)
		dbSkip()
	Enddo

	(cAliasTop)->(dbCloseArea())
Endif

If (oCenterPanel<>Nil)
	oCenterPanel:IncRegua2()
EndIf

Return

/*------------------------------------------------------------------------//
//Programa:	MATA712MAT
//Autor:		Ricardo Prandi
//Data:		03/10/2013
//Descricao:	Rotina que ir� processar nivel a nivel os itens
//Parametros:	01.oCenterPanel 	- Objeto da tela de processamento
//				02.cStrTipo		- String com os tipos do item
//				03.cStrGrupo		- String com os grupos do item
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MATA712MAT(oCenterPanel,cStrTipo,cStrGrupo)
Local cAliasTop 	:= ""
Local cQuery		:= ""
Local cOpc			:= ""
Local cNivMax		:= 1
Local nInd 		    := 0
Local nRecNo   	    := 0
Local nz			:= 0
Local lMT710EXP	    := .T.
Local aNegEst    	:= {}
Local aOpc			:= {}
Local mOpc			:= ""

//Busca o nivel m�ximo
cAliasTop := "BUSCANIV"

//CH TRAAXW - Inicio

BeginSql Alias cAliasTop
SELECT MAX(SG1.G1_NIV) NIVMAX
  FROM %table:SG1% SG1
 WHERE SG1.G1_FILIAL  = %xFilial:SG1%
   AND SG1.G1_NIV     <> '99'
   AND SG1.%NotDel%
EndSql

//CH TRAAXW - Fim

cNivMax := (cAliasTop)->NIVMAX

dbCloseArea()

//Seta regua
If (oCenterPanel <> Nil)
	oCenterPanel:SetRegua1(VAL(cNivMax))
EndIf

//Percorre os n�veis para calcular os componentes
nInd := 1

While nInd <= VAL(cNivMax) //For nInd := 1 to VAL(cNivMax)
	//Atualiza o log de processamento
	ProcLogAtu("MENSAGEM","Inicio nivel " + STR(nInd),"Inicio nivel " + STR(nInd))

	//Calcula as necessidades. Se for o primeiro nivel, n�o � necess�rio, pois j� calculou antes de entrar nessa fun��o
	If nInd # 1
		MA712ClNes(StrZero(nInd,2,0),oCenterPanel)
	EndIf

	//Incrementa regua
	If (oCenterPanel <> Nil)
		oCenterPanel:IncRegua1(OemToAnsi(STR0108))
	EndIf

	//Busca os itens por nivel para calcular as necessidades
	cAliasTop := "BUSCAEST"
	cQuery := " SELECT CZJ.CZJ_PROD, " +;
	                 " CZJ.CZJ_NRRV, " +;
	                 " CZK.CZK_PERMRP, " +;
	                 " CZK.CZK_QTNECE, " +;
	                 " SB1.B1_REVATU, " +;
	                 " CZJ.R_E_C_N_O_ CZJREC " +;
	            " FROM " + RetSqlName("CZJ") + " CZJ, " +;
	                       RetSqlName("CZK") + " CZK, " +;
	                       RetSqlName("SB1") + " SB1 " +;
	           " WHERE CZJ.CZJ_FILIAL  = '" + xFilial("CZJ") + "' " +;
	             " AND CZK.CZK_FILIAL  = '" + xFilial("CZK") + "' " +;
	             " AND SB1.B1_FILIAL   = '" + xFilial("SB1") + "' " +;
	             " AND SB1.D_E_L_E_T_ = ' ' " +;
	             " AND CZJ.R_E_C_N_O_  = CZK.CZK_RGCZJ " +;
	             " AND CZJ.CZJ_PROD    = SB1.B1_COD " +;
	             " AND CZJ.CZJ_NRLV    = '" + StrZero(nInd,2,0) + "' " +;
	             " AND CZK.CZK_QTNECE  > 0 "
	If nInd == 99
		//S� calcula o n�vel 99 para os produtos que atendem a necessidade produzindo, e s�o subprodutos em alguma estrutura.
		cQuery += " AND SB1.B1_PRODSBP = 'P' " +;
		          " AND EXISTS (SELECT 1 FROM " + RetSqlName("SG1") + " SG1 " +;
		                       " WHERE SG1.G1_FILIAL  = '" + xFilial("SG1") + "' " +;
		                         " AND SG1.D_E_L_E_T_ = ' ' " +;
		                         " AND SG1.G1_COMP    = SB1.B1_COD " +;
		                         " AND SG1.G1_QUANT   < 0)"
	EndIf

    cQuery += " ORDER BY CZK.CZK_PERMRP, CZJ.CZJ_PROD "

	//cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.F.,.F.)
	dbSelectArea(cAliasTop)

	While !Eof()
		//Pega o RecNo para o opcional
		nRecno := (cAliasTop)->CZJREC

		//Busca o opcional, pois n�o � poss�vel colocar campo MEMO na query
		CZJ->(DbGoTo(nRecno))
		cOpc := CZJ->CZJ_OPC
		mOpc := CZJ->CZJ_MOPC

		//Verifica PE para explodir estrutura
		If lPeMT710EXP
			lMT710EXP := ExecBlock("MT710EXP",.F.,.F.,{(cAliasTop)->CZJ_PROD,cOpc,(cAliasTop)->CZJ_NRRV,(cAliasTop)->CZK_QTNECE})
			If ValType(lMT710EXP) # "L"
				lMT710EXP := .T.
			EndIf
		EndIf

		//Explode estrutura
		If lMT710EXP
			//Verifica se � subproduto
			aNegEst := IsNegEstr((cAliasTop)->CZJ_PROD,aPeriodos[VAL((cAliasTop)->CZK_PERMRP)],(cAliasTop)->CZK_QTNECES)

			//Se o pai do subproduto for um fantasma, dever� ser chamado novamente a fun��o isNegEstr para buscar o pai imediatamente superior que n�o seja fantasma.
			If !Empty(aNegEst[2])
                SB1->(MsSeek(xFilial("SB1")+aNegEst[2]))
			    If SB1->B1_FANTASM == 'S'
				    aNegEst := IsNegEstr((cAliasTop)->CZJ_PROD,aPeriodos[VAL((cAliasTop)->CZK_PERMRP)],(cAliasTop)->CZK_QTNECES,aNegEst[2])
			    Endif
            EndIf

			If aNegEst[1]
				SB1->(MsSeek(xFilial("SB1")+aNegEst[2]))
				For nz := 1 To aNegEst[5]
					A712CriCZI(aPeriodos[VAL((cAliasTop)->CZK_PERMRP)],aNegEst[2],aNegEst[3],IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU )/*SB1->B1_REVATU*/,"SBP",0,(cAliasTop)->CZJ_PROD,/*08*/,/*09*/,aNegEst[4],"2",.F.,.T.,/*14*/,.T.,.T.,aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo,/*22*/,/*23*/,/*24*/,mOpc,/*26*/)
					A712ExplEs(aNegEst[2],aNegEst[3],IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU )/*SB1->B1_REVATU*/,aNegEst[4],(cAliasTop)->CZK_PERMRP,cStrTipo,cStrGrupo,aOpc,.T.,nInd,,.T.)
					A712CriCZI(aPeriodos[VAL((cAliasTop)->CZK_PERMRP)],aNegEst[2],aNegEst[3],IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU )/*SB1->B1_REVATU*/,"BLQ",0,(cAliasTop)->CZJ_PROD,/*08*/,/*09*/,aNegEst[4],"3",.F.,.T.,/*14*/,.T.,.T.,aPeriodos,nTipo,c711NumMRP,cStrTipo,cStrGrupo,/*22*/,/*23*/,/*24*/,mOpc,/*26*/)
				Next nz
			Else
				//Decompoe os opcionais
				If !Empty(mOpc)
                    If (aOpc := Str2Array(mOpc,.F.)) == Nil
					    aOpc := {}
                    EndIf
				EndIf

				//Explode estrutura
				A712ExplEs((cAliasTop)->CZJ_PROD,cOpc,(cAliasTop)->CZJ_NRRV,(cAliasTop)->CZK_QTNECE,(cAliasTop)->CZK_PERMRP,cStrTipo,cStrGrupo,aOpc,.F.,nInd)
			EndIf
		EndIf

		//Pr�ximo registro
		dbSelectArea(cAliasTop)
		dbSkip()
	End
	//Fecha Alias
	(cAliasTop)->(dbCloseArea())

	//Atualiza LOG
	ProcLogAtu("MENSAGEM","Fim nivel " + STR(nInd),"Fim nivel " + STR(nInd))

	If Val(cNivMax) == nInd .And. cNivMax != "99"
		/*
			Ap�s calcular todos os n�veis, busca os produtos do n�vel 99 para que caso exista algum produto
			que atenda a necessidade produzindo (campos B1_PRODSBP e B1_ESTRORI) seja calculada a produ��o desses componentes (fun��o IsNegEstr chamada acima).
		*/
		cNivMax := "99"
		nInd := 98
	EndIf
	nInd++
End

//Atualiza LOG
ProcLogAtu("MENSAGEM","Inicio recalculo necessidade nivel 99","Inicio recalculo necessidade nivel 99")

//Recalcula as necessidades do n�vel 99
MA712ClNes("99",oCenterPanel)

//Atualiza LOG
ProcLogAtu("MENSAGEM","Fim recalculo necessidade nivel 99","Fim recalculo necessidade nivel 99")

A712GrvTm(oCenterPanel,STR0109) //"Termino do Calculo das Necessidade."

Return

/*-------------------------------------------------------------------------/
//Programa:	MATA712MVW
//Autor:		Ricardo Prandi
//Data:		04/10/2013
//Descricao:	Monta o arquivo tempor�rio da CZJ e CZK para mostrar em tela
//Parametros:	aCampos - Arry de campos (por refer�ncia)
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MATA712MVW(lAtualiza,oTempTbl)
Local cQuery	:= ""
Local cProdAnt	:= ""
Local cOpcAnt	:= ""
Local cRevAnt	:= ""
Local cAliasTab	:= "CRIATAB"
Local cAliasTop	:= "BUSCADADOS"
Local aIndex    := {"PRODUTO","OPCIONAL","REVISAO"}
Local nInd		:= 0
Local aTamQuant := TamSX3("B2_QFIM")
Local aRecNo	:= {}
Local aFields	:= {}
Local aStruct   := {}

Default lAtualiza := .T.
Default oTempTbl := Nil

//Autaliza LOG
ProcLogAtu("MENSAGEM","Inicio montagem arquivo de trabalho","Inicio montagem arquivo de trabalho")

//Cria o array dos campos para o arquivo
AADD(aFields,{"TIPO","C",1,0})
AADD(aFields,{"TEXTO","C",30,0})
AADD(aFields,{"PRODUTO","C",LEN(CZJ->CZJ_PROD),0})
AADD(aFields,{"PRODSHOW","C",LEN(CZJ->CZJ_PROD),0})
AADD(aFields,{"OPCIONAL","C",LEN(CZJ->CZJ_OPCORD),0})
AADD(aFields,{"OPCSHOW","C",LEN(CZJ->CZJ_OPCORD),0})
AADD(aFields,{"REVISAO","C",4,0})
AADD(aFields,{"REVSHOW","C",4,0})
AADD(aFields,{"MRP","C",6,0}) //TREXG3

For nInd := 1 to Len(aPeriodos)
	AADD(aFields,{"PER"+StrZero(nInd,3),"N",aTamQuant[1],aTamQuant[2]})
Next nInd

aStruct�:=�{aFields,�aIndex}
������
//Cria o arquivo�
If oTempTbl == Nil
	oTempTbl := SFCCriFWTa(aStruct)
Else
	TcSqlExec("DELETE FROM " + oTempTbl:GetRealName())
EndIf
cAliasTab := oTempTbl:GetAlias()

cQuery := " SELECT CZJ.CZJ_PROD, " +;
                 " CZJ.CZJ_OPCORD, " +;
                 " CZJ.CZJ_NRRV, " +;
                 " CZJ.CZJ_NRMRP, " +; //TREXG3
                 " CZK.CZK_PERMRP, " +;
                 " CZK.CZK_QTSLES, " +;
                 " CZK.CZK_QTENTR, " +;
                 " CZK.CZK_QTSAID, " +;
                 " CZK.CZK_QTSEST, " +;
                 " CZK.CZK_QTSALD, " +;
                 " CZK.CZK_QTNECE " +;
            " FROM " + RetSqlName("CZJ") + " CZJ, " +;
                       RetSqlName("CZK") + " CZK " +;
           " WHERE CZJ.CZJ_FILIAL   = '" + xFilial("CZJ") + "' " +;
             " AND CZK.CZK_FILIAL   = '" + xFilial("CZK") + "' " +;
             " AND CZJ.R_E_C_N_O_   = CZK.CZK_RGCZJ " +;
           " ORDER BY CZJ.CZJ_PROD, " +;
                    " CZJ.CZJ_OPCORD, " +;
                    " CZJ.CZJ_NRRV, " +;
                    " CZK.CZK_PERMRP "

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
dbSelectArea(cAliasTop)

While !Eof()
	nInd := VAL((cAliasTop)->CZK_PERMRP)

	//Se mudar o item, grava novo registro
	If cProdAnt # (cAliasTop)->CZJ_PROD .Or. cOpcAnt # (cAliasTop)->CZJ_OPCORD .Or. cRevAnt # (cAliasTop)->CZJ_NRRV
		cProdAnt 	:= (cAliasTop)->CZJ_PROD
		cOpcAnt  	:= (cAliasTop)->CZJ_OPCORD
		cRevAnt  	:= (cAliasTop)->CZJ_NRRV
		aRecNo		:= {}

		//Grava Saldo inicial
		RecLock(cAliasTab,.T.)
		(cAliasTab)->TIPO 	 := '1'
		(cAliasTab)->TEXTO 	 := STR0110
		(cAliasTab)->PRODUTO  := (cAliasTop)->CZJ_PROD
		(cAliasTab)->PRODSHOW := (cAliasTop)->CZJ_PROD
		(cAliasTab)->OPCIONAL := (cAliasTop)->CZJ_OPCORD
		(cAliasTab)->OPCSHOW	 := (cAliasTop)->CZJ_OPCORD
		(cAliasTab)->REVISAO  := (cAliasTop)->CZJ_NRRV
		(cAliasTab)->REVSHOW  := (cAliasTop)->CZJ_NRRV
		(cAliasTab)->MRP 		 := (cAliasTop)->CZJ_NRMRP //TREXG3
		(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSLES
		MsUnLock(cAliasTab)

		AADD(aRecNo,{(cAliasTab)->(RecNo())})

		//Grava Entradas
		RecLock(cAliasTab,.T.)
		(cAliasTab)->TIPO 	 := '2'
		(cAliasTab)->TEXTO := STR0063
		(cAliasTab)->PRODUTO  := (cAliasTop)->CZJ_PROD
		(cAliasTab)->OPCIONAL := (cAliasTop)->CZJ_OPCORD
		(cAliasTab)->REVISAO  := (cAliasTop)->CZJ_NRRV
		(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTENTR
		MsUnLock(cAliasTab)

		AADD(aRecNo,{(cAliasTab)->(RecNo())})

		//Grava Saida
		RecLock(cAliasTab,.T.)
		(cAliasTab)->TIPO 	 := '3'
		(cAliasTab)->TEXTO := STR0064
		(cAliasTab)->PRODUTO  := (cAliasTop)->CZJ_PROD
		(cAliasTab)->OPCIONAL := (cAliasTop)->CZJ_OPCORD
		(cAliasTab)->REVISAO  := (cAliasTop)->CZJ_NRRV
		(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSAID
		MsUnLock(cAliasTab)

		AADD(aRecNo,{(cAliasTab)->(RecNo())})

		//Grava Saida por estrutura
		RecLock(cAliasTab,.T.)
		(cAliasTab)->TIPO 	 := '4'
		(cAliasTab)->TEXTO := STR0111
		(cAliasTab)->PRODUTO  := (cAliasTop)->CZJ_PROD
		(cAliasTab)->OPCIONAL := (cAliasTop)->CZJ_OPCORD
		(cAliasTab)->REVISAO  := (cAliasTop)->CZJ_NRRV
		(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSEST
		MsUnLock(cAliasTab)

		AADD(aRecNo,{(cAliasTab)->(RecNo())})

		//Grava Saldo final
		RecLock(cAliasTab,.T.)
		(cAliasTab)->TIPO 	 := '5'
		(cAliasTab)->TEXTO := STR0112
		(cAliasTab)->PRODUTO  := (cAliasTop)->CZJ_PROD
		(cAliasTab)->OPCIONAL := (cAliasTop)->CZJ_OPCORD
		(cAliasTab)->REVISAO  := (cAliasTop)->CZJ_NRRV
		(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSALD
		MsUnLock(cAliasTab)

		AADD(aRecNo,{(cAliasTab)->(RecNo())})

		//Grava Necessidades
		RecLock(cAliasTab,.T.)
		(cAliasTab)->TIPO 	 := '6'
		(cAliasTab)->TEXTO := STR0113
		(cAliasTab)->PRODUTO  := (cAliasTop)->CZJ_PROD
		(cAliasTab)->OPCIONAL := (cAliasTop)->CZJ_OPCORD
		(cAliasTab)->REVISAO  := (cAliasTop)->CZJ_NRRV
		(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTNECE
		MsUnLock(cAliasTab)

		AADD(aRecNo,{(cAliasTab)->(RecNo())})
	Else
		dbSelectArea(cAliasTab)
		(cAliasTab)->(dbGoTo(aRecNo[1][1]))

		RecLock(cAliasTab,.F.)
		(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSLES
		MsUnLock(cAliasTab)

		(cAliasTab)->(dbGoTo(aRecNo[2][1]))

		RecLock(cAliasTab,.F.)
		(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTENTR
		MsUnLock(cAliasTab)

		(cAliasTab)->(dbGoTo(aRecNo[3][1]))

		RecLock(cAliasTab,.F.)
		(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSAID
		MsUnLock(cAliasTab)

		(cAliasTab)->(dbGoTo(aRecNo[4][1]))

		RecLock(cAliasTab,.F.)
		(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSEST
		MsUnLock(cAliasTab)

		(cAliasTab)->(dbGoTo(aRecNo[5][1]))

		RecLock(cAliasTab,.F.)
		(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSALD
		MsUnLock(cAliasTab)

		(cAliasTab)->(dbGoTo(aRecNo[6][1]))

		RecLock(cAliasTab,.F.)
		(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTNECE
		MsUnLock(cAliasTab)
	EndIf

	dbSelectArea(cAliasTop)
	dbSkip()
End

(cAliasTab)->(DbGoTop())

(cAliasTop)->(dbCloseArea())

//Autaliza LOG
ProcLogAtu("MENSAGEM","Fim montagem arquivo de trabalho","Fim montagem arquivo de trabalho")
Return cAliasTab

/*-------------------------------------------------------------------------/
//Programa:	a712MVW2
//Autor:		Lucas Konrad Fran�a
//Data:		13/06/2018
//Descricao:	Monta o arquivo tempor�rio da CZJ e CZK para mostrar em tela
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function a712MVW2(oTempTbl)
	Local nInd		:= 0
	Local nX        := 0
	Local cQuery    := ""
	Local cTable    := ""
	Local cInsert   := ""
	Local cAliasTab	:= "CRIATAB"
	Local cBanco    := AllTrim(Upper(TcGetDb()))
	Local cComando  := "COALESCE"
	Local aQuery    := {}
	Local aFields	:= {}
	Local aStruct   := {}
	Local aIndex    := {"PRODUTO","OPCIONAL","REVISAO"}
	Local aTamQuant := TamSX3("B2_QFIM")

	Default oTempTbl := Nil

	//Autaliza LOG
	ProcLogAtu("MENSAGEM","Inicio montagem arquivo de trabalho","Inicio montagem arquivo de trabalho")

	If "MSSQL" $ cBanco
		cComando := "ISNULL"
	EndIf

	//Cria o array dos campos para o arquivo
	AADD(aFields,{"TIPO","C",1,0})
	AADD(aFields,{"TEXTO","C",30,0})
	AADD(aFields,{"PRODUTO","C",LEN(CZJ->CZJ_PROD),0})
	AADD(aFields,{"PRODSHOW","C",LEN(CZJ->CZJ_PROD),0})
	AADD(aFields,{"OPCIONAL","C",LEN(CZJ->CZJ_OPCORD),0})
	AADD(aFields,{"OPCSHOW","C",LEN(CZJ->CZJ_OPCORD),0})
	AADD(aFields,{"REVISAO","C",4,0})
	AADD(aFields,{"REVSHOW","C",4,0})
	AADD(aFields,{"MRP","C",6,0}) //TREXG3

	For nInd := 1 to Len(aPeriodos)
		AADD(aFields,{"PER"+StrZero(nInd,3),"N",aTamQuant[1],aTamQuant[2]})
	Next nInd

	aStruct�:=�{aFields,�aIndex}
	������
	//Cria o arquivo�
	If oTempTbl == Nil
		oTempTbl  := SFCCriFWTa(aStruct)
	Else
		TcSqlExec("DELETE FROM " + oTempTbl:GetRealName())
	EndIf
	cAliasTab := oTempTbl:GetAlias()
	cTable    := oTempTbl:GetRealName()

	aAdd(aQuery,{"'1'",;
				"'"+STR0110+"'",;
				"CZJ.CZJ_PROD",;
				"CZJ.CZJ_PROD",;
				"CZJ.CZJ_OPCORD",;
				"CZJ.CZJ_OPCORD",;
				"CZJ.CZJ_NRRV",;
				"CZJ.CZJ_NRRV",;
				"CZJ.CZJ_NRMRP",;
				"CZK.CZK_QTSLES"})
	aAdd(aQuery,{"'2'",;
				"'"+STR0063+"'",;
				"CZJ.CZJ_PROD",;
				"' '",;
				"CZJ.CZJ_OPCORD",;
				"' '",;
				"CZJ.CZJ_NRRV",;
				"' '",;
				"CZJ.CZJ_NRMRP",;
				"CZK.CZK_QTENTR"})
	aAdd(aQuery,{"'3'",;
				"'"+STR0064+"'",;
				"CZJ.CZJ_PROD",;
				"' '",;
				"CZJ.CZJ_OPCORD",;
				"' '",;
				"CZJ.CZJ_NRRV",;
				"' '",;
				"CZJ.CZJ_NRMRP",;
				"CZK.CZK_QTSAID"})
	aAdd(aQuery,{"'4'",;
				"'"+STR0111+"'",;
				"CZJ.CZJ_PROD",;
				"' '",;
				"CZJ.CZJ_OPCORD",;
				"' '",;
				"CZJ.CZJ_NRRV",;
				"' '",;
				"CZJ.CZJ_NRMRP",;
				"CZK.CZK_QTSEST"})
	aAdd(aQuery,{"'5'",;
				"'"+STR0112+"'",;
				"CZJ.CZJ_PROD",;
				"' '",;
				"CZJ.CZJ_OPCORD",;
				"' '",;
				"CZJ.CZJ_NRRV",;
				"' '",;
				"CZJ.CZJ_NRMRP",;
				"CZK.CZK_QTSALD"})
	aAdd(aQuery,{"'6'",;
				"'"+STR0113+"'",;
				"CZJ.CZJ_PROD",;
				"' '",;
				"CZJ.CZJ_OPCORD",;
				"' '",;
				"CZJ.CZJ_NRRV",;
				"' '",;
				"CZJ.CZJ_NRMRP",;
				"CZK.CZK_QTNECE"})

	cInsert := " INSERT INTO " + cTable
	cInsert +=          " (TIPO, "
	cInsert +=           " TEXTO, "
	cInsert +=           " PRODUTO, "
	cInsert +=           " PRODSHOW, "
	cInsert +=           " OPCIONAL, "
	cInsert +=           " OPCSHOW, "
	cInsert +=           " REVISAO, "
	cInsert +=           " REVSHOW, "
	cInsert +=           " MRP, "
	For nInd := 1 To Len(aPeriodos)
		cInsert +=       " PER" + StrZero(nInd,3) + ", "
	Next nInd
	cInsert +=           " D_E_L_E_T_, "
	//cInsert +=           " R_E_C_N_O_,"
	cInsert +=           " R_E_C_D_E_L_)"

	cQuery := " SELECT TEMP.TIPO, "
	cQuery +=        " TEMP.TEXTO, "
	cQuery +=        " TEMP.PRODUTO, "
	cQuery +=        " TEMP.PRODSHOW, "
	cQuery +=        " TEMP.OPCIONAL, "
	cQuery +=        " TEMP.OPCSHOW, "
	cQuery +=        " TEMP.REVISAO, "
	cQuery +=        " TEMP.REVSHOW, "
	cQuery +=        " TEMP.MRP, "
	For nInd := 1 To Len(aPeriodos)
		cQuery +=    " TEMP.PER" + StrZero(nInd,3) + ", "
	Next nInd
	cQuery +=        " ' ', " //D_E_L_E_T_
	//cQuery +=        " ROW_NUMBER() OVER (ORDER BY TEMP.PRODUTO), " //R_E_C_N_O_
	cQuery +=        " 0 " //R_E_C_D_E_L_
	cQuery +=   " FROM ( "
	For nX := 1 To Len(aQuery)
		If nX > 1
			cQuery += " UNION "
		EndIf
		cQuery +=     " SELECT " + aQuery[nX,1] + " TIPO, "
		cQuery +=                  aQuery[nX,2] + " TEXTO, "
		cQuery +=                  aQuery[nX,3] + " PRODUTO, "
		cQuery +=                  aQuery[nX,4] + " PRODSHOW, "
		cQuery +=                  aQuery[nX,5] + " OPCIONAL, "
		cQuery +=                  aQuery[nX,6] + " OPCSHOW, "
		cQuery +=                  aQuery[nX,7] + " REVISAO, "
		cQuery +=                  aQuery[nX,8] + " REVSHOW, "
		cQuery +=                  aQuery[nX,9] + " MRP, "
		For nInd := 1 To Len(aPeriodos)
			cQuery += cComando + "((SELECT " + aQuery[nX,10]
			cQuery +=               " FROM " + RetSqlName("CZK") + " CZK "
			cQuery +=              " WHERE CZK.CZK_FILIAL = '"+xFilial("CZK")+"' "
			cQuery +=                " AND CZK.D_E_L_E_T_ = ' ' "
			cQuery +=                " AND CZK.CZK_RGCZJ  = CZJ.R_E_C_N_O_ "
			cQuery +=                " AND CZK.CZK_PERMRP = '" + StrZero(nInd,3) + "'),0) PER" + StrZero(nInd,3)
			If nInd < Len(aPeriodos)
				cQuery += ", "
			EndIf
		Next nInd
		cQuery +=       " FROM " + RetSqlName("CZJ") + " CZJ "
		cQuery +=      " WHERE CZJ.CZJ_FILIAL = '"+xFilial("CZJ")+"' "
		cQuery +=        " AND CZJ.D_E_L_E_T_ = ' ' "
		cQuery +=        " AND EXISTS(SELECT 1 "
		cQuery +=                     " FROM " + RetSqlName("CZK") + " CZK "
		cQuery +=                     " WHERE CZK.CZK_FILIAL = '"+xFilial("CZK")+"' "
		cQuery +=                       " AND CZK.D_E_L_E_T_ = ' ' "
		cQuery +=                       " AND CZK.CZK_RGCZJ = CZJ.R_E_C_N_O_ )"
	Next nX
	If cBanco == "ORACLE"
		cQuery += " ) TEMP "
	Else
		cQuery += " ) as TEMP "
	EndIf
	cQuery +=  " ORDER BY TEMP.PRODUTO, "
	cQuery +=           " TEMP.OPCIONAL, "
	cQuery +=           " TEMP.REVISAO, "
	cQuery +=           " TEMP.TIPO "

	//Une o comando insert com o select tratado.
	cInsert += cQuery
	//Executa a query.
	If TcSqlExec(cInsert) < 0
		Final("Erro na carga do arquivo de trabalho.", TCSQLError() + cInsert)
	EndIf

	(cAliasTab)->(dbGoTop())

	//Autaliza LOG
	ProcLogAtu("MENSAGEM","Fim montagem arquivo de trabalho","Fim montagem arquivo de trabalho")
Return cAliasTab

/*-------------------------------------------------------------------------/
//Programa:	MT712Tree2
//Autor:		Lucas Konrad Fran�a
//Data:		12/06/2018
//Descricao:	Funcao que monta o Tree do MRP
//Parametros:	01.lResumido		- Indica se apresenta os dados resumidos
//				02.oCenterPanel	- Objeto do painel de progress bar
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MT712Tree2(lResumido,oCenterPanel)
	Local nZ            := 0
	Local nAchouTot     := 0
	Local nRecno        := 0
	Local cAliasTop     := ""
	Local cQuery        := ""
	Local cLegen        := ""
	Local cProduto      := ""
	Local cOpc          := ""
	Local cRevisao      := ""
	Local cOldAlias     := ""
	Local cImg          := ""
	Local aTexto        := {}
	//Local aNodes        := {}
	Local lShAlt 		:= If(ExistBlock("M710ShAlt"),execblock('M710SHAlt',.F.,.F.),.F.)

	Default lAutomacao := .F.
	
	AADD(aTexto,{"SC1",STR0078}) //"Solicitacao de Compra"
	AADD(aTexto,{"SC7",STR0079}) //"Pedido de Compra / Autorizacao de Entrega"
	AADD(aTexto,{"SC2",STR0080}) //"Ordem de Producao"
	AADD(aTexto,{"SHC",STR0081}) //"Plano Mestre de Producao"
	AADD(aTexto,{"SD4",STR0082}) //"Empenho"
	AADD(aTexto,{"SC6",STR0083}) //"Pedido de Venda"
	AADD(aTexto,{"SC4",STR0084}) //"Previsao de Venda"
	AADD(aTexto,{"AFJ",STR0085}) //"Empenhos para Projeto"
	AADD(aTexto,{"CZJ",STR0116}) //"Necessidade Estrutura"
	AADD(aTexto,{"ENG",STR0086}) //"Subproduto Estrutura"
	AADD(aTexto,{"SB1",STR0117}) //"Cadastro de Produto"
	AADD(aTexto,{"SB8",STR0118}) //"Lotes Vencidos"
	AADD(aTexto,{"SBP",STR0088}) //"Nec. Subproduto"
	AADD(aTexto,{"BLQ",STR0155}) //"Saldo bloqueado de Subproduto"
	AADD(aTexto,{"SB2",STR0178}) //"Saldo Estoque"

	If !lAutomacao
		oTreeM711:BeginUpdate()
		oTreeM711:Reset()
	EndIf

	aDbTree := {}

	//Atualiza o log de processamento
	ProcLogAtu("MENSAGEM","Iniciando Montagem do Tree do MRP","Iniciando Montagem do Tree do MRP")

	//Verifica todos produtos utilizados pelo arquivo de resumo ou de detalhe
	If lResumido
		//Grava dados resumidos
		cAliasTop := "MONTATREE"
		cQuery := " SELECT DISTINCT CZJ.CZJ_PROD, "
		cQuery +=                 " CZJ.CZJ_OPCORD, "
		cQuery +=                 " CZJ.CZJ_NRRV, "
		cQuery +=                 " CZJ.R_E_C_N_O_ CZJREC "
		cQuery +=            " FROM " + RetSqlName("CZJ") + " CZJ, "
		cQuery +=                       RetSqlName("CZK") + " CZK "
		cQuery +=           " WHERE CZJ.CZJ_FILIAL   = '" + xFilial("CZJ") + "' "
		cQuery +=             " AND CZK.CZK_FILIAL   = '" + xFilial("CZK") + "' "
		cQuery +=             " AND CZJ.R_E_C_N_O_   = CZK.CZK_RGCZJ "
		cQuery +=             " AND (CZK.CZK_QTNECE <> 0 "
		cQuery +=             "  OR  CZK.CZK_QTSAID <> 0 "
		cQuery +=             "  OR  CZK.CZK_QTSALD <> 0 "
		cQuery +=             "  OR  CZK.CZK_QTSEST <> 0 "
		cQuery +=             "  OR  CZK.CZK_QTENTR <> 0 "
		cQuery +=             "  OR  CZK.CZK_QTSLES <> 0) "
		cQuery +=           " ORDER BY CZJ.CZJ_PROD, "
		cQuery +=                    " CZJ.CZJ_OPCORD, "
		cQuery +=                    " CZJ.CZJ_NRRV "

 		cQuery := ChangeQuery(cQuery)

 		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
		dbSelectArea(cAliasTop)

 		If (oCenterPanel <> Nil)
			oCenterPanel:SetRegua1((cAliasTop)->(LastRec()))
		EndIf

		CZI->(dbSetOrder(5))

		While (cAliasTop)->(!Eof())
			If (oCenterPanel <> Nil)
				oCenterPanel:IncRegua1(OemToAnsi(STR0106))
			EndIf

			If CZI->(dbSeek(xFilial("CZI")+(cAliasTop)->CZJ_PROD+(cAliasTop)->CZJ_OPCORD+(cAliasTop)->CZJ_NRRV))
				nRecno := CZI->(Recno())
			Else
				nRecno := 0
			EndIf

			AADD(aDbTree,{(cAliasTop)->CZJ_PROD,(cAliasTop)->CZJ_OPCORD,(cAliasTop)->CZJ_NRRV,"","","",StrZero(nRecno,12),""})

			nZ := Len(aDbTree)

			// Muda a legenda se o produto tiver alternativo, se tem SGI e se PE M710ShAlt = T
			cLegen := 'PMSEDT4'
			If lShAlt
				dbSelectArea("SGI")
				dbSetOrder(1)
				If MSSeek(xFilial("SGI")+aDbTree[nZ,1])
					cLegen := 'PMSEDT2'
				EndIf
			EndIF

			//Verifica se mudou o produto ou se � o primeiro produto
			If cProduto+cOpc+cRevisao # aDbTree[nZ,1]+aDbTree[nZ,2]+aDbTree[nz,3]
				If !lAutomacao
					If Empty(cProduto+cOpc+cRevisao)
						//Coloca titulo no TREE
						//aAdd(aNodes,{"00","00"+aDbTree[nZ,7]+StrZero(0,12),"",STR0060+" / "+STR0061+Space(80),cLegen,cLegen})
						oTreeM711:AddTree(STR0060+" / "+STR0061+Space(80),.T.,,,cLegen,cLegen,"00"+aDbTree[nZ,7]+StrZero(0,12))
					Else
						//Encerra tree do produto
						oTreeM711:EndTree()
					EndIf
					
					cProduto  := aDbTree[nZ,1]
					cOpc      := aDbTree[nZ,2]
					cRevisao  := aDbTree[nZ,3]
					cOldAlias := ""

					//Adiciona Produto no TREE
					//aAdd(aNodes,{"01","01"+aDbTree[nZ,7]+StrZero(0,12),"",AllTrim(cProduto)+If(Empty(cOpc),""," / "+Alltrim(cOpc)) + A712StrRev(cRevisao),cLegen,cLegen})
					oTreeM711:AddTree(AllTrim(cProduto)+If(Empty(cOpc),""," / "+Alltrim(cOpc)) + A712StrRev(cRevisao),.T.,,,cLegen,cLegen,"01"+aDbTree[nz,7]+StrZero(0,12))
				EndIf
			EndIf

			(cAliasTop)->(dbSkip())
		End
		If (oCenterPanel<>Nil)
			oCenterPanel:IncRegua2()
		EndIf

		(cAliasTop)->(dbCloseArea())
	Else
		//Zera os valores para recalculo do produto posicionado
		aTotais := {{}}

		cAliasTop := "FILTRATREE"
		cQuery := " SELECT DISTINCT CZI.R_E_C_N_O_ CZIREC, "
		cQuery +=                 " CZI.CZI_FILIAL, "
		cQuery +=                 " CZI.CZI_ALIAS, "
		cQuery +=                 " CZI.CZI_PROD, "
		cQuery +=                 " CZI.CZI_OPCORD, "
		cQuery +=                 " CZI.CZI_NRRV, "
		cQuery +=                 " CZI.CZI_TPRG, "
		cQuery +=                 " CZI.CZI_DOC, "
		cQuery +=                 " CZI.CZI_DOCREV, "
		cQuery +=                 " CZI.CZI_PERMRP, "
		cQuery +=                 " CZI.CZI_QUANT "
		cQuery +=   " FROM " + RetSqlName("CZI") + " CZI "
		cQuery +=  " WHERE CZI.CZI_FILIAL = '" + xFilial("CZI") + "' "
		cQuery +=    " AND CZI.D_E_L_E_T_ = ' ' "
		cQuery +=  " ORDER BY CZI.CZI_PROD, "
		cQuery +=           " CZI.CZI_OPCORD, "
		cQuery +=           " CZI.CZI_NRRV, "
		cQuery +=           " CZI.CZI_ALIAS, "
		cQuery +=           " CZI.CZI_TPRG "
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
		dbSelectArea(cAliasTop)

		//Busca os dados detalhados, todos os registros da CZI
		If (oCenterPanel <> Nil)
			oCenterPanel:SetRegua1((cAliasTop)->(LastRec()))
		EndIf

		While (cAliasTop)->(!Eof())
			If (oCenterPanel <> Nil)
				oCenterPanel:IncRegua1(OemToAnsi(STR0106))
			EndIf

			If (cAliasTop)->(CZI_ALIAS) # "PAR"
				// Estrutura do array
				// Produto
				// Opcional
				// Revisao
				// Alias
				// Tipo
				// Documento
				// Recno
				// DocRev
				AADD(aDbTree,{(cAliasTop)->(CZI_PROD),;
							(cAliasTop)->(CZI_OPCORD),;
							(cAliasTop)->(CZI_NRRV),;
							(cAliasTop)->(CZI_ALIAS),;
							(cAliasTop)->(CZI_TPRG),;
							(cAliasTop)->(CZI_DOC),;
							StrZero((cAliasTop)->(CZIREC),12),;
							(cAliasTop)->(CZI_DOCREV)})

				//Adiciona registro em array totalizador utilizado no TREE
				If Len(aTotais[Len(aTotais)]) > 4095
					AADD(aTotais,{})
				EndIf
				For nZ := 1 to Len(aTotais[nZ])
					If aTotais[1,nZ,1] == (cAliasTop)->(CZI_PROD+CZI_OPCORD+CZI_NRRV) .And. ;
						aTotais[1,nZ,2] == (cAliasTop)->(CZI_PERMRP)				  .And. ;
						aTotais[1,nZ,3] == (cAliasTop)->(CZI_ALIAS)
						nAchouTot := nZ
					Else
						nAchouTot := 0
						Loop
					EndIf
					If nAchouTot != 0
						aTotais[1,nAchouTot,4] += (cAliasTop)->(CZI_QUANT)
						Exit
					EndIf
				Next nZ

				If nAchouTot == 0
					AADD(aTotais[Len(aTotais)],{(cAliasTop)->(CZI_PROD+CZI_OPCORD+CZI_NRRV),(cAliasTop)->(CZI_PERMRP),(cAliasTop)->(CZI_ALIAS),(cAliasTop)->(CZI_QUANT)})
				EndIf

				nZ := Len(aDbTree)

				// Muda a legenda se o produto tiver alternativo, se tem SGI e se PE M710ShAlt = T
		   		cLegen := 'PMSEDT4'
		   		If lShAlt
					dbSelectArea("SGI")
					dbSetOrder(1)
					If MSSeek(xFilial("SGI")+aDbTree[nZ,1])
						cLegen := 'PMSEDT2'
					EndIf
				EndIF

				//Verifica se mudou o produto ou se � o primeiro produto
				If cProduto+cOpc+cRevisao # aDbTree[nZ,1]+aDbTree[nZ,2]+aDbTree[nZ,3]
					If !lAutomacao
						If Empty(cProduto+cOpc+cRevisao)
							//Coloca titulo no TREE
							//aAdd(aNodes,{"00","00"+aDbTree[nZ,7]+StrZero(0,12),"",STR0060+" / "+STR0061+Space(80),cLegen,cLegen})
							oTreeM711:AddTree(STR0060+" / "+STR0061+Space(80),.T.,,,cLegen,cLegen,"00"+aDbTree[nz,7]+StrZero(0,12))
						Else
							//Encerra tree do produto
							oTreeM711:EndTree()
						EndIf

						cProduto  := aDbTree[nZ,1]
						cOpc      := aDbTree[nZ,2]
						cRevisao  := aDbTree[nZ,3]
						cOldAlias := ""

						//Adiciona Produto no TREE
						//aAdd(aNodes,{"01","01"+aDbTree[nZ,7]+StrZero(0,12),"",AllTrim(cProduto)+If(Empty(cOpc),""," / "+Alltrim(cOpc)) + A712StrRev(cRevisao),cLegen,cLegen})
						oTreeM711:AddTree(AllTrim(cProduto)+If(Empty(cOpc),""," / "+Alltrim(cOpc)) + A712StrRev(cRevisao),.T.,,,cLegen,cLegen,"01"+aDbTree[nz,7]+StrZero(0,12))
					EndIf
				EndIf

				//Verifica se mudou o tipo de arquivo totalizado
				If cOldAlias # aDbTree[nZ,4]

					cOldAlias := aDbTree[nZ,4]
					//Adiciona na TREE

					If aDbTree[nZ,5]=="2"
						cImg := "PMSEDT3"
					Else
						cImg := "PMSEDT1"
					EndIf

					If aDbTree[nz,4] == "BLQ"
						cImg := "BPMSEDT2E"
					EndIf

					//aAdd(aNodes,{"02","02"+aDbTree[nz,7]+aDbTree[nz,4],"",aTexto[Ascan(aTexto,{ |x| x[1] == aDbTree[nz,4]}),2],cImg,cImg})
					If !lAutomacao
						oTreeM711:AddTree(aTexto[Ascan(aTexto,{ |x| x[1] == aDbTree[nz,4]}),2],.T.,,,cImg,cImg,"02"+aDbTree[nz,7]+aDbTree[nz,4])
					EndIf
				EndIf

				//Verifica condi��o do DOCKEY
				If aDbTree[nZ,5]$"23" .And. If(aDbTree[nZ,4]=="ENG",!Empty(CZI->CZI_DOCKEY),aDbTree[nZ,4]#"SBP")
					cImg := "PMSDOC"
				Else
					cImg := "relacionamento_direita"
				EndIf
				If aDbTree[nz,4] == "BLQ"
					cImg := "relacionamento_direita"
				EndIf
				//Adiciona na TREE
				//aAdd(aNodes,{"03","03"+aDbTree[nZ,7]+aDbTree[nZ,7],"",AllTrim(aDbTree[nZ,6])+A712StrRev(aDbTree[nZ,8]),cImg,cImg})
				If !lAutomacao
					oTreeM711:AddTreeItem(AllTrim(aDbTree[nz,6])+A712StrRev(aDbTree[nz,8]),cImg,cImg,"03"+aDbTree[nz,7]+aDbTree[nz,7])
				EndIf
			EndIf
			(cAliasTop)->(dbSkip())
			If (cAliasTop)->(Eof()) .Or. ;
				(Len(aDbTree)>0 .And. (cAliasTop)->(CZI_ALIAS) # aDbTree[nZ,4]) .Or. ;
				(Len(aDbTree)>0 .And. (cAliasTop)->(CZI_PROD+CZI_OPCORD+CZI_NRRV) # aDbTree[nZ,1]+aDbTree[nZ,2]+aDbTree[nZ,3] )
				//Encerra tree do Alias
				If Len(aDbTree) > 0 
					If !lAutomacao
						oTreeM711:EndTree()
					EndIf
				EndIF
			EndIf
		End

		(cAliasTop)->(dbCloseArea())
	EndIf

	If Len(aDbTree) > 0
		If !lAutomacao
			// Encerra tree do produto
			oTreeM711:EndTree()
			// Encerra tree inteiro
			oTreeM711:EndTree()

			oTreeM711:EndUpdate()
		EndIf
	EndIf


	If (oCenterPanel<>Nil)
		oCenterPanel:IncRegua2()
	EndIf

	//Atualiza o log de processamento
	ProcLogAtu("MENSAGEM","Termino da Montagem Tree do MRP","Termino da Montagem Tree do MRP")
Return

/*-------------------------------------------------------------------------/
//Programa:	MT712Tree
//Autor:		Ricardo Prandi
//Data:		07/10/2013
//Descricao:	Funcao que monta o Tree do MRP
//Parametros:	01.lResumido		- Indica se apresenta os dados resumidos
//				02.oCenterPanel	- Objeto do painel de progress bar
//				03.lFilNeces		- Indica se filtra apenas produtos com necessidades
//				04.lVisualiza		- Indica se � visualiza��o ou processo
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MT712Tree(lResumido,oCenterPanel,lFilNeces,lVisualiza)
Local nAchouTot  	:= 0
Local i          	:= 0
Local nX         	:= 0
Local nY         	:= 0
Local nPos       	:= 0
Local nRetry_0   	:= 0
Local nRetry_1   	:= 0
Local nHd1       	:= 0
Local nHd2       	:= 0
Local lInJob     	:= SuperGetMv('MV_A710THR',.F.,1) > 1
Local cStartPath 	:= GetSrvProfString("Startpath","")
Local cJobFile   	:= ""
Local cJobAux    	:= ""
Local cFileTotal 	:= ""
Local cFileTree  	:= ""
Local cLinha     	:= ""
Local aNewTotal  	:= {}
Local aNewDbTree 	:= {}
Local aThreads   	:= {}
Local aJobAux    	:= {}
//Local lThrSeq    	:= SuperGetMV("MV_THRSEQ",.F.,.F.)
Local nTamProd   	:= TamSX3("CZI_PROD")[1]
Local nTamOpc    	:= TamSX3("CZI_OPCORD")[1]
Local nTamRev    	:= TamSX3("B1_REVATU")[1]
Local nTamCod    	:= nTamProd+nTamOpc+nTamRev
Local nTamDocRev 	:= Len(SC2->C2_REVISAO)
Local nTamDoc    	:= TamSX3("CZI_DOC")[1]
Local nTamRecno  	:= 12
Local nTamPer    	:= 3
Local nTamAlias  	:= 3
Local nTamTipo   	:= 1
Local nRecNo        := 0
Local cAliasTop	    := ""
Local cQuery		:= ""

Default lResumido  := .F.
Default lFilNeces  := .F.
Default lVisualiza := .F.
Default lAutomacao := .F.

aDbTree := {}

//Atualiza o log de processamento
ProcLogAtu("MENSAGEM","Iniciando Montagem do Tree do MRP","Iniciando Montagem do Tree do MRP")

//Execucao da montagem da Tela em Threads
If lInJob .And. !lResumido //.And. lVisualiza
	//Calcula Quebra por Threads
	aThreads := MATA712TZI(lFilNeces)
	//ProcRegua(((Len(aThreads)*2) + 8))

	For nX := 1 to Len(aThreads)
		//IncProc()

		//Informacoes do semaforo
		cJobFile := cStartPath + CriaTrab(Nil,.F.)+".job"

		//Adiciona o nome do arquivo de Job no array aJobAux
		aAdd(aJobAux,{StrZero(nX,2),cJobFile})

		//Arquivo de totalizadores
		cFileTotal := "TO"+cEmpAnt+cFilAnt+StrZero(nX,2)+".job"

		//Arquivo do DbTree
		cFileTree := "TR"+cEmpAnt+cFilAnt+StrZero(nX,2)+".job"

		//Inicializa variavel global de controle de thread
		cJobAux := "c712T"+cEmpAnt+cFilAnt+StrZero(nX,2)
		PutGlbValue(cJobAux,"0")
		GlbUnLock()

		//Atualiza o log de processamento
		ProcLogAtu("MENSAGEM","Iniciando Montagem do Tree do MRP - Thread:" + StrZero(nX,2),"Iniciando Montagem do Tree do MRP - Thread:" + StrZero(nX,2))

		//Dispara thread para Stored Procedure
		StartJob("A712JobTree",GetEnvServer(),.F.,cEmpAnt,cFilAnt,aThreads[nX,1],cJobFile,StrZero(nX,2),cFileTotal,cFileTree,lUsaMOpc)
	Next nX

	//Controle de Seguranca para MULTI-THREAD
	For nX := 1 to Len(aThreads)
		nRetry_0 := 0
		nRetry_1 := 0

		nPos := ASCAN(aJobAux,{|x| x[1] == StrZero(nX,2)})

		//Arquivo de totalizadores
		cFileTotal := "TO"+cEmpAnt+cFilAnt+StrZero(nX,2)+".job"

		//Arquivo do DbTree
		cFileTree := "TR"+cEmpAnt+cFilAnt+StrZero(nX,2)+".job"

		//Informacoes do semaforo
		cJobFile:= aJobAux[nPos,2]

		//Inicializa variavel global de controle de thread
		cJobAux := "c712T"+cEmpAnt+cFilAnt+StrZero(nX,2)

		While .T.
			Do Case
				//TRATAMENTO PARA ERRO DE SUBIDA DE THREAD
				Case GetGlbValue(cJobAux) == '0'
					If nRetry_0 > 50
						//Conout(Replicate("-",65))
						//Conout("MATA712: "+ "N�o foi possivel realizar a subida da thread" + " " + StrZero(nX,2) )
						//Conout(Replicate("-",65))

						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","N�o foi possivel realizar a subida da thread","N�o foi possivel realizar a subida da thread")
						Final(STR0166)  //"N�o foi possivel realizar a subida da thread"
					Else
						nRetry_0 ++
					EndIf

				//TRATAMENTO PARA ERRO DE CONEXAO
				Case GetGlbValue(cJobAux) == '1'
					If FCreate(cJobFile) # -1
						If nRetry_1 > 5
							//Conout(Replicate("-",65))
							//Conout("MATA712: Erro de conexao na thread")
							//Conout("Thread numero : " + StrZero(nX,2) )
							//Conout("Numero de tentativas excedidas")
							//Conout(Replicate("-",65))

							//Atualiza o log de processamento
							ProcLogAtu("MENSAGEM","MATA712: Erro de conexao na thread","MATA712: Erro de conexao na thread")
							Final(STR0162) //"MATA712: Erro de conexao na thread"
						EndIf
						nRetry_1 ++
					EndIf

				//TRATAMENTO PARA ERRO DE APLICACAO
				Case GetGlbValue(cJobAux) == '2'
					If FCreate(cJobFile) # -1
						//Conout(Replicate("-",65))
						//Conout("MATA712: Erro de aplicacao na thread ")
						//Conout("Thread numero : "+StrZero(nX,2))
						//Conout(Replicate("-",65))

						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","MATA712: Erro de aplicacao na thread","MATA712: Erro de aplicacao na thread")
						Final(STR0163) //"MATA712: Erro de aplicacao na thread"
					EndIf

				//THREAD PROCESSADA CORRETAMENTE
				Case GetGlbValue(cJobAux) == '3'
					//Atualizacao do Array aTotais
					If File(cFileTotal) .And. ((nHdl := FOpen(cFileTotal,FO_READWRITE)) > 0)
						//Fecha o arquivo para utilizacao da fun��o FT_USE
						fClose(nHd1)
						//Reinicia o array de Totais
						aNewTotal := {}
						//Abertura do arquivo de trabalho
						FT_FUse( cFileTotal )
						// Criacao do array aNewTotal
						FT_FGOTOP()

						While !FT_FEof()
							cLinha := FT_FREADLN()
							AADD(aNewTotal,{SubStr( cLinha, 1								  , nTamCod	)	,;
					   						  SubStr( cLinha, nTamCod+1						  , nTamPer 	)	,;
					    	                SubStr( cLinha, nTamCod+nTamPer+1			  , nTamAlias ) 	,;
						   			  	   Val( SubStr( cLinha, nTamCod+nTamPer+nTamAlias+1, 18 ) ) } )
						   FT_FSKIP()
						EndDo

						FT_FUSE()

						//Atualiza o array aTotais com o valores calculados pela Thread
          				For nY := 1 to Len(aNewTotal)
							AAdd(aTotais[1],{aNewTotal[nY,1],aNewTotal[nY,2],aNewTotal[nY,3],aNewTotal[nY,4]})
                   	Next nY
					Else
						Final(STR0164) //"MATA712: Erro de abertura no arquivo de Totais"
					EndIf
					//Atualizacao do Array aDbTree
					If File(cFileTree) .And. ((nHd2:=FOpen(cFileTree,FO_READWRITE)) > 0)
						//Fecha o arquivo para utilizacao da fun��o FT_USE
						fClose(nHd2)
						//Reinicia o array de Totais
						aNewDbTree := {}
						//Abertura do arquivo de trabalho
						FT_FUse( cFileTree )
						//Criacao do array aNewDbTree
						FT_FGOTOP()

						While !FT_FEof()
						   cLinha := FT_FREADLN()

						   AADD(aNewDbTree,{	SubStr( cLinha, 1                                                              , nTamProd		)	,;
					   							SubStr( cLinha, nTamProd+1	                                                   , nTamOpc 		)	,;
					   							SubStr( cLinha, nTamProd+nTamOpc+1	                                            , nTamRev		) 	,;
					   							SubStr( cLinha, nTamProd+nTamOpc+nTamRev+1										  , nTamAlias 	) 	,;
					   							SubStr( cLinha, nTamProd+nTamOpc+nTamRev+nTamAlias+1		                       , nTamTipo 		) 	,;
					   							SubStr( cLinha, nTamProd+nTamOpc+nTamRev+nTamAlias+nTamTipo+1					  , nTamDoc 		) 	,;
					   							SubStr( cLinha, nTamProd+nTamOpc+nTamRev+nTamAlias+nTamTipo+nTamDoc+1	     	  , nTamRecno 	) 	,;
					   							SubStr( cLinha, nTamProd+nTamOpc+nTamRev+nTamAlias+nTamTipo+nTamDoc+nTamRecno+1, nTamDocRev 	) } )

						   FT_FSKIP()
						EndDo

						FT_FUSE()

						//Atualiza o array aDbTree com os dados do aNewDbTree
						If Len(aNewDbTree) > 0
                     	For nY := 1 to Len(aNewDbTree)
                         	AAdd(adbTree,aNewDbTree[nY])
                     	Next nY
						EndIf

						adbTree := ASORT(adbTree,1,3)
					Else
						Final(STR0165) //"MATA712: Erro de abertura no arquivo de Tree"
					EndIf
					//Atualiza o log de processamento
					ProcLogAtu("MENSAGEM","Termino da Montagem do Tree do MRP - Thread:" + StrZero(nX,2),"Termino da Montagem do Tree do MRP - Thread:"+ StrZero(nX,2))
					//IncProc()
					Exit
			EndCase
			Sleep(500)
		End
	Next nX
Else
	//Verifica todos produtos utilizados pelo arquivo de resumo ou de detalhe
	If lResumido
		//Grava dados resumidos
		cAliasTop := "MONTATREE"
		cQuery := " SELECT DISTINCT CZJ.CZJ_PROD, " +;
                        " CZJ.CZJ_OPCORD, " +;
                        " CZJ.CZJ_NRRV, " +;
                        " CZJ.R_E_C_N_O_ CZJREC " +;
                   " FROM " + RetSqlName("CZJ") + " CZJ, " +;
                              RetSqlName("CZK") + " CZK " +;
                  " WHERE CZJ.CZJ_FILIAL   = '" + xFilial("CZJ") + "' " +;
                    " AND CZK.CZK_FILIAL   = '" + xFilial("CZK") + "' " +;
                    " AND CZJ.R_E_C_N_O_   = CZK.CZK_RGCZJ "

       If lFilNeces
       	cQuery += " AND CZK.CZK_QTNECE <> 0 "
       Else
       	cQuery += " AND (CZK.CZK_QTNECE <> 0 " +;
       	          "  OR  CZK.CZK_QTSAID <> 0 " +;
       	          "  OR  CZK.CZK_QTSALD <> 0 " +;
       	          "  OR  CZK.CZK_QTSEST <> 0 " +;
       	          "  OR  CZK.CZK_QTENTR <> 0 " +;
       	          "  OR  CZK.CZK_QTSLES <> 0) "
		EndIf

		cQuery += " ORDER BY CZJ.CZJ_PROD, " +;
		                   " CZJ.CZJ_OPCORD, " +;
		                   " CZJ.CZJ_NRRV "

 		cQuery := ChangeQuery(cQuery)

 		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
		dbSelectArea(cAliasTop)

 		If (oCenterPanel <> Nil)
			oCenterPanel:SetRegua1((cAliasTop)->(LastRec()))
		EndIf

		CZI->(dbSetOrder(5))

		While !Eof()
			If (oCenterPanel <> Nil)
				oCenterPanel:IncRegua1(OemToAnsi(STR0106))
			EndIf

			If CZI->(dbSeek(xFilial("CZI")+(cAliasTop)->CZJ_PROD+(cAliasTop)->CZJ_OPCORD+(cAliasTop)->CZJ_NRRV))
				nRecno := CZI->(Recno())
			Else
				nRecno := 0
			EndIf

			AADD(aDbTree,{(cAliasTop)->CZJ_PROD,(cAliasTop)->CZJ_OPCORD,(cAliasTop)->CZJ_NRRV,"","","",StrZero(nRecno,12),""})

			dbSkip()
		End
		If (oCenterPanel<>Nil)
			oCenterPanel:IncRegua2()
		EndIf

		(cAliasTop)->(dbCloseArea())
	Else		
		//Zera os valores para recalculo do produto posicionado
		aTotais := {{}}

		cAliasTop := fZeraValores(lFilNeces)

		//Busca os dados detalhados, todos os registros da CZI

		If (oCenterPanel <> Nil)
			oCenterPanel:SetRegua1((cAliasTop)->(LastRec()))
		EndIf

		While !Eof() .And. (CZI_FILIAL == xFilial("CZI"))

			If (cAliasTop <> "CZI") .OR. (cAliasTop == "CZI" .And. &(cFilTabCZI))
				If (oCenterPanel <> Nil)
					oCenterPanel:IncRegua1(OemToAnsi(STR0106))
				EndIf

				If lFilNeces
					CZI->(dbGoTo((cAliasTop)->CZIREC))
				EndIf

				If CZI->CZI_ALIAS # "PAR"
					// Estrutura do array
					// Produto
					// Opcional
					// Revisao
					// Alias
					// Tipo
					// Documento
					// Recno
					// DocRev

					AADD(aDbTree,{CZI->CZI_PROD,CZI->CZI_OPCORD,CZI->CZI_NRRV,CZI->CZI_ALIAS,CZI->CZI_TPRG,CZI->CZI_DOC,StrZero(CZI->(Recno()),12),CZI->CZI_DOCREV})

					//Adiciona registro em array totalizador utilizado no TREE
					If Len(aTotais[Len(aTotais)]) > 4095
						AADD(aTotais,{})
					EndIf

					For i := 1 to Len(aTotais[1])
						if aTotais[1,i,1] == CZI->CZI_PROD+CZI->CZI_OPCORD+CZI->CZI_NRRV .And. aTotais[1,i,2] == CZI->CZI_PERMRP .And. aTotais[1,i,3] == CZI->CZI_ALIAS
							nAchouTot := i //ASCAN(aTotais[i],{ |x| x[1] == CZI->CZI_PROD+CZI->CZI_OPCORD+CZI->CZI_NRRV .And. x[2] == CZI->CZI_PERMRP .And. x[3] == CZI->CZI_ALIAS})
						else
							nAchouTot := 0
							loop
						EndIf
						If nAchouTot != 0
							aTotais[1,nAchouTot,4] += CZI->CZI_QUANT
							Exit
						EndIf
					Next i

					If nAchouTot == 0
						//AADD(aTotais[Len(aTotais)],{CZI->CZI_PROD + IIf(Len(CZI->CZI_OPC) < 80,PADR(CZI->CZI_OPC,80),CZI->CZI_OPC) + CZI->CZI_NRRV,CZI->CZI_PERMRP,CZI->CZI_ALIAS,CZI->CZI_QUANT})
						AADD(aTotais[Len(aTotais)],{CZI->CZI_PROD + CZI->CZI_OPCORD + CZI->CZI_NRRV,CZI->CZI_PERMRP,CZI->CZI_ALIAS,CZI->CZI_QUANT})
					EndIf
				EndIf
			EndIf

			If lFilNeces
				dbSelectArea(cAliasTop)
			EndIf

			dbSkip()
		End

		If lFilNeces
			(cAliasTop)->(dbCloseArea())
		Else
			CZI->(dbCloseArea())
		EndIf

		If (oCenterPanel<>Nil)
			oCenterPanel:IncRegua2()
		EndIf
	EndIf
EndIf

If !lAutomacao
	A712GrvTm(oCenterPanel,STR0114) //"Termino da Montagem da Arvore de Produtos (Tree)."
	ASORT(aDbTree,,,{|x,y| x[1]+x[2]+x[3]+x[4]+x[5] < y[1]+y[2]+y[3]+y[4]+y[5]})
	A712AdTree(.T.,aDbTree,lResumido)
	A712GrvTm(oCenterPanel,STR0115) //"FIM - Termino da Montagem da Tela"
EndIf

//Atualiza o log de processamento
ProcLogAtu("MENSAGEM","Termino da Montagem Tree do MRP","Termino da Montagem Tree do MRP")

Return

/*/{Protheus.doc} fZeraValores
	@type  Static Function
	@author mauricio.joao
	@since 12/11/2020
	@version 1.0
/*/
Static Function fZeraValores(lFilNeces)
Local cAliasTop 	:= ""
Local cQuery 		:= ""

	If lFilNeces
		cAliasTop := "FILTRATREE"
		cQuery := " SELECT DISTINCT CZI.R_E_C_N_O_ CZIREC, CZI.CZI_FILIAL " 
		cQuery += " FROM " + RetSqlName("CZI") + " CZI, " 
		cQuery += RetSqlName("CZJ") + " CZJ, " 
		cQuery += RetSqlName("CZK") + " CZK  " 
		cQuery += " WHERE CZI.CZI_FILIAL = '" + xFilial("CZI") + "' " 
		cQuery += " AND CZJ.CZJ_FILIAL = '" + xFilial("CZJ") + "' " 
		cQuery += " AND CZK.CZK_FILIAL = '" + xFilial("CZK") + "' " 
		cQuery += " AND CZI.CZI_PROD   = CZJ.CZJ_PROD " 
		cQuery += " AND CZI.CZI_OPCORD = CZJ.CZJ_OPCORD " 
		cQuery += " AND CZI.CZI_NRRV   = CZJ.CZJ_NRRV " 
		cQuery += " AND CZJ.R_E_C_N_O_ = CZK.CZK_RGCZJ " 
		cQuery += " AND CZK.CZK_QTNECE > 0 "
		cQuery += " AND CZI.D_E_L_E_T_ = ' ' " 
		cQuery += " AND CZJ.D_E_L_E_T_ = ' ' " 
		cQuery += " AND CZK.D_E_L_E_T_ = ' ' "

		If !Empty(cFilQryCZI)
			cQuery += cFilQryCZI
		EndIf
		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
		dbSelectArea(cAliasTop)
	Else
		dbSelectArea("CZI")
		dbSetOrder(1)
		dbSeek(xFilial("CZI"))
		cAliasTop := "CZI"
	EndIf

Return cAliasTop

/*-------------------------------------------------------------------------/
//Programa:	A712AdTree
//Autor:		Ricardo Prandi
//Data:		08/10/2013
//Descricao:	Rotina para incluir documento do arquivo SH5 no tree do MRP
//Parametros:	01.lTodosDados	- Indica inclusao de multiplos itens no TREE
//				02.aDadosTree		- Array com dados organizados para inclusao no TREE
//				03.lResumido		- Monta Array resumido somente com os produtos
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712AdTree(lTodosDados,aDadosTree,lResumido)
Local aTexto   		:= {}
Local cOldAlias		:= ""
Local nz			:= 0
Local nPos			:= 0
Local cProduto		:= ""
Local cOpc   		:= ""
Local cRevisao		:= ""
Local cDadosPrd		:= ""
Local cDadosArq		:= ""
Local cImg 			:= ""
Local clegen		:= ""
Local lShAlt 		:= If(ExistBlock("M710ShAlt"),execblock('M710SHAlt',.F.,.F.),.F.)
Local cOldCargo		:= ""

Default lTodosDados := .F.
Default lResumido   := .F.
Default lAutomacao 	:= .F.

If !lAutomacao 
	cOldCargo := oTreeM711:GetCargo()
EndIf

AADD(aTexto,{"SC1",STR0078}) //"Solicitacao de Compra"
AADD(aTexto,{"SC7",STR0079}) //"Pedido de Compra / Autorizacao de Entrega"
AADD(aTexto,{"SC2",STR0080}) //"Ordem de Producao"
AADD(aTexto,{"SHC",STR0081}) //"Plano Mestre de Producao"
AADD(aTexto,{"SD4",STR0082}) //"Empenho"
AADD(aTexto,{"SC6",STR0083}) //"Pedido de Venda"
AADD(aTexto,{"SC4",STR0084}) //"Previsao de Venda"
AADD(aTexto,{"AFJ",STR0085}) //"Empenhos para Projeto"
AADD(aTexto,{"CZJ",STR0116}) //"Necessidade Estrutura"
AADD(aTexto,{"ENG",STR0086}) //"Subproduto Estrutura"
AADD(aTexto,{"SB1",STR0117}) //"Cadastro de Produto"
AADD(aTexto,{"SB8",STR0118}) //"Lotes Vencidos"
AADD(aTexto,{"SBP",STR0088}) //"Nec. Subproduto"
AADD(aTexto,{"BLQ",STR0155}) //"Saldo bloqueado de Subproduto"
AADD(aTexto,{"SB2",STR0178}) //"Saldo Estoque"

//Incrementa os dados do array no tree - SEMPRE CONTEM DADOS DE UM UNICO PRODUTO
If !lTodosDados
	// Estrutura do array
	// 01 Produto
	// 02 Opcional
	// 03 Revisao
	// 04 Alias
	// 05 Tipo
	// 06 Documento
	// 07 Recno
	// 08 DocRev
	For nz := 1 to Len(aDadosTree)
		//Incluir produto caso necessario e muda a legenda se o produto tiver alternativo, se Tem SGI e PE M710ShAlt = T
   		cLegen := 'PMSEDT4'
	    If lShAlt
			dbSelectArea("SGI")
			dbSetOrder(1)
			If MSSeek(xFilial("SGI")+aDadosTree[nz,1])
				cLegen := 'PMSEDT2'
			EndIf
		endIf

		nPos := ASCAN(aDbTree,{|x| x[1] == aDadosTree[nz,1] .And. x[2] == aDadosTree[nz,2]})

		If Empty(nPos)
			If !lAutomacao
				oTreeM711:AddItem(AllTrim(aDadosTree[nz,1])+If(Empty(aDadosTree[nz,2]),""," / "+Alltrim(aDadosTree[nz,2])) + A712StrRev(aDadosTree[nz,3]),"01"+aDadosTree[nz,7]+StrZero(0,12),cLegen,cLegen,,,2)
			EndIf
			cDadosPrd:=aDadosTree[nz,7]+StrZero(0,12)
		Else
			cDadosPrd:=aDbTree[nPos,7]+StrZero(0,12)
		EndIf

		If !lResumido
			//Inclui tipo de arquivo caso necessario
			nPos := ASCAN(aDbTree,{|x| x[1]+x[2]+x[4] == aDadosTree[nz,1]+aDadosTree[nz,2]+aDadosTree[nz,4]})
			If Empty(nPos)
				cDadosArq := aDadosTree[nz,7]+aDadosTree[nz,4]
			Else
				cDadosArq := aDbTree[nPos,7]+aDbTree[nPos,4]
			EndIf

			If !lAutomacao
				//Pesquisa no TREE tipo de arquivo
				If !oTreeM711:TreeSeek("02"+cDadosArq)
					//Posiciona no TREE produto
					oTreeM711:TreeSeek("01"+cDadosPrd)

					If aDadosTree[nz,5]=="2"
						cImg := "PMSEDT3"
					Else
						cImg := "PMSEDT1"
					EndIf

					If aDadosTree[nz,4] == "BLQ"
						cImg := "BPMSEDT2E"
					EndIf

					//Coloca tipo de arquivo - TREE
					oTreeM711:AddItem(aTexto[Ascan(aTexto,{ |x| x[1] == aDadosTree[nz,4]}),2],"02"+aDadosTree[nz,7]+aDadosTree[nz,4],cImg,cImg,,,2)
				EndIf

				//Posiciona tipo de arquivo - TREE
				oTreeM711:TreeSeek("02"+cDadosArq)
			EndIf

			CZI->(dbGoTo(Val(aDadosTree[nz,7])))
			If aDadosTree[nz,5]$"23" .And. If(aDadosTree[nz,4]=="ENG",!Empty(CZI->CZI_DOCKEY),aDadosTree[nz,4]#"SBP")
				cImg := "PMSDOC"
			Else
				cImg := "relacionamento_direita"
			EndIf
			If aDadosTree[nz,4] == "BLQ"
				cImg := "relacionamento_direita"
			EndIf

			If !lAutomacao
				If !oTreeM711:TreeSeek("03"+aDadosTree[nz,7]+aDadosTree[nz,7])
					//Coloca documento - TREE
					oTreeM711:AddItem(AllTrim(aDadosTree[nz,6])+A712StrRev(aDadosTree[nz,8]),"03"+aDadosTree[nz,7]+aDadosTree[nz,7],cImg,cImg,,,2)
				EndIf
			EndIf
		EndIf

		nPos:=ASCAN(aDbTree,{|x| x[7] == aDadosTree[nz,7]})

		//Adiciona no array do tree
		If Empty(nPos)
			AADD(aDbTree,aDadosTree[nz])
		EndIf
	Next nz

	If !lAutomacao
		oTreeM711:TreeSeek(cOldCargo)
	EndIf

Else //Inclui todos os itens no tree
	//Monta tree na primeira vez
	If !lAutomacao
		oTreeM711:BeginUpdate()
		oTreeM711:Reset()
		oTreeM711:EndUpdate()
	EndIf
	// Estrutura do array
	// Produto
	// Opcional
	// Alias
	// Revisao
	// Tipo
	// Documento
	// Recno
	For nz := 1 to Len(aDadosTree)
		// Muda a legenda se o produto tiver alternativo, se tem SGI e se PE M710ShAlt = T
   		cLegen := 'PMSEDT4'
   		If lShAlt
			dbSelectArea("SGI")
			dbSetOrder(1)
			If MSSeek(xFilial("SGI")+aDadosTree[nz,1])
				cLegen := 'PMSEDT2'
			EndIf
		EndIF

		//Verifica se mudou o produto ou se � o primeiro produto
		If cProduto+cOpc+cRevisao # aDadosTree[nz,1]+aDadosTree[nz,2]+aDadosTree[nz,3]
			If Empty(cProduto+cOpc+cRevisao)
				//Coloca titulo no TREE
				If !lAutomacao
					oTreeM711:AddTree(STR0060+" / "+STR0061+Space(80),.T.,,,cLegen,cLegen,"00"+aDadosTree[nz,7]+StrZero(0,12))
				EndIf
			Else
				//Encerra tree do produto
				oTreeM711:EndTree()
			EndIf

			cProduto  := aDadosTree[nz,1]
			cOpc      := aDadosTree[nz,2]
			cRevisao  := aDadosTree[nz,3]
			cOldAlias := ""

			//Adiciona Produto no TREE
			If !lAutomacao
				oTreeM711:AddTree(AllTrim(cProduto)+If(Empty(cOpc),""," / "+Alltrim(cOpc)) + A712StrRev(cRevisao),.T.,,,cLegen,cLegen,"01"+aDadosTree[nz,7]+StrZero(0,12))
			EndIf
		EndIf

		//Verifica se mudou o tipo de arquivo totalizado
		If !lResumido
			If cOldAlias # aDadosTree[nz,4]
				cOldAlias := aDadosTree[nz,4]
				//Adiciona na TREE

				If aDadosTree[nz,5]=="2"
					cImg := "PMSEDT3"
				Else
					cImg := "PMSEDT1"
				EndIf

				If aDadosTree[nz,4] == "BLQ"
					cImg := "BPMSEDT2E"
				EndIf
				If !lAutomacao
					oTreeM711:AddTree(aTexto[Ascan(aTexto,{ |x| x[1] == aDadosTree[nz,4]}),2],.T.,,,cImg,cImg,"02"+aDadosTree[nz,7]+aDadosTree[nz,4])
				EndIf
			EndIf

			//Posiciona para buscar DOCKEY
			CZI->(dbGoTo(Val(aDadosTree[nz,7])))

			//Verifica condi��o do DOCKEY
			If aDadosTree[nz,5]$"23" .And. If(aDadosTree[nz,4]=="ENG",!Empty(CZI->CZI_DOCKEY),aDadosTree[nz,4]#"SBP")
				cImg := "PMSDOC"
			Else
				cImg := "relacionamento_direita"
			EndIf
			If aDadosTree[nz,4] == "BLQ"
				cImg := "relacionamento_direita"
			EndIf
			//Adiciona na TREE
			If !lAutomacao
				oTreeM711:AddTreeItem(AllTrim(aDadosTree[nz,6])+A712StrRev(aDadosTree[nz,8]),cImg,cImg,"03"+aDadosTree[nz,7]+aDadosTree[nz,7])

				If (nz < Len(aDadosTree) .And. ((aDadosTree[nz+1,4] # cOldAlias) .Or. (cProduto+cOpc+cRevisao # aDadosTree[nz+1,1]+aDadosTree[nz+1,2]+aDadosTree[nz+1,3]))) .Or. nz == Len(aDadosTree)
					//Encerra tree do tipo de arquivo qdo muda de tipo de arquivo ou muda de produto
					oTreeM711:EndTree()
				EndIf
			EndIf
		EndIf
	Next nz
	
	If Len(aDadosTree) > 0
		If !lAutomacao
			// Encerra tree do produto
			oTreeM711:EndTree()
			// Encerra tree inteiro
			oTreeM711:EndTree()
		EndIf
	EndIf
EndIf

Return

/*-------------------------------------------------------------------------/
//Programa:	MT712DlgV
//Autor:		Ricardo Prandi
//Data:		08/10/2013
//Descricao:	Funcao que mostra as informacoes detalhadas da consulta
//Parametros:	01.aEnch		- Array com os objetos a serem apresentados
//				02.aPos		- Array com as coordenadas utilizadas na apresentacao
//				03.nOldEnch	- Variavel com o objeto anteriormente apresentado
//				04.oSay1		- Objeto com a descricao do produto
//				05.cAliasTab	- Passa o Alias da tabela de resultados
//				06.oSay2		- Objeto com a descricao do produto
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MT712DlgV(aEnch,aPos,nOldEnch,oSay1,cAliasTab, oSay2)
Local cAliasPos		:= ''
Local aTamQuant		:= TamSX3("B2_QFIM")
Local lOneColumn	:= If(aPos[4]-aPos[2]>312,.F.,.T.)
Local aTexto		:= {}
Local aAdPeriodos	:= {}
Local aTextoVazio	:= Array(Len(aPeriodos))
Local i    			:= 0
Local z				:= 0
Local nInd			:= 0
Local w				:= 0
Local nPosTree		:= 0
Local nAchouTot		:= 0
Local nRecno		:= 0
Local aCampos		:= {}
Local desc1
Local desc2
Local aTamOpc		:= TamSX3("CZI_OPCORD")
Local cFilSB1		:= ""
Local cTipo711		:= ""
Local cRecno		:= ""

PRIVATE cProdShow	:= CriaVar("CZI_PROD")
PRIVATE cOpcShow	:= CriaVar("CZI_OPCORD")
PRIVATE cRevisao	:= CriaVar("CZI_NRRV")
PRIVATE cBotFun		:= ''
PRIVATE cTopFun		:= ''
PRIVATE aRotina		:= {{" "," ", 0 , 2}}

Default lAutomacao  := .F.

If !lAutomacao
	cTipo711	:=SubStr(oTreeM711:GetCargo(),1,2)
	nRecno		:=Val(SubStr(oTreeM711:GetCargo(),3,12))
	cRecno		:= SubStr(oTreeM711:GetCargo(),3,12)
EndIf

//Possiciona array do tree
nPosTree := AsCan(aDbTree,{|x| x[7]==cRecno})

//Inicializa variaveis
If nPosTree > 0
	cAliasPos	:= aDbTree[nPosTree,4]
	cProdShow	:= aDbTree[nPosTree,1]
	cOpcShow	:= IIf(LEN(aDbTree[nPosTree,2]) > aTamOpc[1],Substr(aDbTree[nPosTree,2],1,aTamOpc[1]),aDbTree[nPosTree,2])
	cRevisao	:= aDbTree[nPosTree,3]

	nLenOpc     := Len(cOpcShow)
	If nLenOpc < aTamOpc[1]
		cOpcShow := cOpcShow + Space(aTamOpc[1]-nLenOpc)
	EndIf

	cFilSB1 := xFilial("SB1")
	//Preenche descricao do produto
	if Len((Posicione('SB1',1,cFilSB1+cProdShow,"B1_DESC"))) > 30
		desc1 := SubStr((Posicione('SB1',1,cFilSB1+cProdShow,"B1_DESC")),1,30)
		desc2 := SubStr((Posicione('SB1',1,cFilSB1+cProdShow,"B1_DESC")),31,20)
		oSay1:SetText(desc1)
		oSay2:SetText(desc2)
	else
		If !lAutomacao
			oSay1:SetText(Posicione('SB1',1,cFilSB1+cProdShow,"B1_DESC"))
		EndIf
	End if

	//Atualiza com o produto posicionado
	cProdDetSld := cProdShow
Else
	cTipo711 := "00"
EndIf

//Monta Numero de Colunas de acordo com numero de periodos
AFILL(aTextoVazio,"")

If !lAutomacao
	MsFreeObj(@oPanelM711 , .T.)
	MsFreeObj(@oScrollM711, .T.)
EndIf
//SCROLL BOX com texto vazio ou totalizador por tipo de documento
If cTipo711 == "00"
	//Limpa conteudo de variavel
	cProdDetSld := ""
	If !lAutomacao
		oSay1:SetText("")
		oPanelM711:Hide()
	EndIf
	//Cria o array dos campos para o browse
	aCampos := {{"TEXTO","",STR0059,20}} //"Tipo"
	AADD(aCampos,{"PRODSHOW","",STR0060,LEN(CZJ->CZJ_PROD)}) //"Produtos"
	AADD(aCampos,{"OPCSHOW","",STR0061,LEN(CZJ->CZJ_OPCORD)}) //"Opcionais"
	AADD(aCampos,{"REVSHOW","",STR0062,4}) //"Revisao"

	For nInd := 1 to Len(aPeriodos)
		AADD(aCampos,{"PER"+StrZero(nInd,3),cPictQuant,DtoC(aPeriodos[nInd]),aTamQuant[1]+2})
	Next i

	dbSelectArea(cAliasTab)

	//Monta browse de todos os produtos
	nOldEnch := 1
	If !lAutomacao
		aEnch[nOldEnch] := MaMakeBrow(oPanelM711,cAliasTab,{aPos[1],aPos[2],aPos[4],aPos[3]-2},,.F.,aCampos,,cTopFun,cBotFun,NIL,NIL,2)

		// Refaz browse com informacoes de todos os produtos	
		oPanelM711:Refresh()
		oPanelM711:Show()
	EndIf
ElseIf cTipo711 == "01"
	If !lAutomacao
		oPanelM711:Hide()
	EndIf 
	//Monta array com os campos a serem utilizados no Browse
	cBotFun   := PutAspas(cProdShow+cOpcShow+cRevisao)
	cTopFun   := PutAspas(cProdShow+cOpcShow+cRevisao)

	aCampos:={{"TEXTO","",STR0059,20}} //"Tipo"
	For i := 1 to Len(aPeriodos)
		AADD(aCampos,{"PER"+StrZero(i,3),cPictQuant,DtoC(aPeriodos[i]),aTamQuant[1]+2})
	Next i

	dbSelectArea(cAliasTab)

	//Monta browse referente a esse produto
	nOldEnch := 1
	If !lAutomacao
		aEnch[nOldEnch] := MaMakeBrow(oPanelM711,cAliasTab,{aPos[1],aPos[2],aPos[4],aPos[3]-2},,.F.,aCampos,,cTopFun,cBotFun,NIL,NIL,1)
	EndIf
	//Posiciona no primeiro registro desse produto
	(cAliasTab)->(dbSeek(cProdShow+cOpcShow+cRevisao))

	//Posiciona no primeiro registro
	(cAliasTab)->(dbGotop())
	If !lAutomacao
		aEnch[nOldEnch]:GoBottom() //DMANSMARTSQUAD1-10534 - incluso para que carregue corretamente a grid ao realizar a pesquisa
		aEnch[nOldEnch]:GoTop()
		//Refaz browse com informacoes desse produto
		
		oPanelM711:Refresh()
		oPanelM711:Show()
	EndIf
ElseIf cTipo711 == "02"
	//Procura totalizadores por tipo de documento para esse produto+opcional
	aAdPeriodos := ACLONE(aTextoVazio)

	//Coloca na primeira coluna texto
	aAdPeriodos[1] := STR0119 //"Totais"
	AADD(aTexto,aAdPeriodos)
	aAdPeriodos := ACLONE(aTextoVazio)

	//Coloca data nas colunas
	For w := 1 to Len(aPeriodos)
		aAdPeriodos[w] := DTOC(aPeriodos[w])
	Next w

	AADD(aTexto,aAdPeriodos)
	aAdPeriodos := ACLONE(aTextoVazio)

	//Monta os valores de acordo com os periodos
	For z := 1 to Len(aPeriodos)
		For i:=1 to Len(aTotais)		
			nAchouTot:=ASCAN(aTotais[i],{ |x| x[1] == cProdShow+cOpcShow+cRevisao .And. x[2] == StrZero(z,3) .And. x[3] == cAliasPos})
			If nAchouTot != 0
				aAdPeriodos[z] := Transform(aTotais[i,nAchouTot,4],cPictQuant)
				Exit
			Else
				aAdPeriodos[z] := Transform(0, cPictQuant)
			EndIf
		Next i
	Next z

	AADD(aTexto,aAdPeriodos)
	aAdPeriodos := ACLONE(aTextoVazio)

	//Coloca na primeira coluna texto
	aAdPeriodos[1] := STR0120 //"Data Limite para Compra / Producao"
	AADD(aTexto,aAdPeriodos)
	aAdPeriodos := ACLONE(aTextoVazio)

	//Coloca data limite nas colunas de acordo com as datas especificadas
	For z := 1 to Len(aPeriodos)
		For i := 1 to Len(aTotais)
			nAchouTot := ASCAN(aTotais[i],{ |x| x[1] == cProdShow + cOpcShow + cRevisao .And. x[2] == StrZero(z,3) .And. x[3] == cAliasPos})
			If nAchouTot != 0
				aAdPeriodos[z] := DTOC(SomaPrazo(aPeriodos[z], - CalcPrazo(cProdShow,aTotais[i,nAchouTot,4],,,.F.,aPeriodos[z])))
				Exit
			Else
				aAdPeriodos[z] := ""
			EndIf
		Next i
	Next z

	AADD(aTexto,aAdPeriodos)

	MatScrDisp(aTexto,@oScrollM711,@oPanelM711,{aPos[1],aPos[2],Round(aPos[3],0)-3,aPos[4]},NIL,{{2,CLR_RED},{4,CLR_GREEN}})
	nOldEnch := 2
	aEnch[nOldEnch]:=oScrollM711
ElseIf cTipo711 == "03"	//Detalhe dos documentos
	//Monta MSMGET para apresentar dados detalhados
	dbSelectArea("CZI")
	MsGoto(nRecno)

	cAliasPos := CZI->CZI_ALIAS
	nRecPos   := CZI->CZI_NRRGAL

	//Necessidade relacionada a estrutura
	If cAliasPos == "CZJ"
		aTexto := {{STR0066,CZI->CZI_DOC}}

		AADD(aTexto,{lTrim(STR0113),Str(CZI->CZI_QUANT,aTamQuant[1],aTamQuant[2])})
		AADD(aTexto,{STR0077,DTOC(aPeriodos[Val(CZI->CZI_PERMRP)])})

		MatScrDisp(aTexto,@oScrollM711,@oPanelM711,{aPos[1],aPos[2],Round(aPos[3],0)-3,aPos[4]},{{1,CLR_RED}})
		nOldEnch := 3
		aEnch[nOldEnch] := oScrollM711
	ElseIf cAliasPos $ "ENG/SBP"  //Quantidade negativa na estrutura
		aTexto := {{STR0086,CZI->CZI_DOC}}

		AADD(aTexto,{lTrim(STR0100),Str(CZI->CZI_QUANT,aTamQuant[1],aTamQuant[2])})
		AADD(aTexto,{STR0077,DTOC(aPeriodos[Val(CZI->CZI_PERMRP)])})

		MatScrDisp(aTexto,@oScrollM711,@oPanelM711,{aPos[1],aPos[2],Round(aPos[3],0)-3,aPos[4]},{{1,CLR_RED}})
		nOldEnch := 3
		aEnch[nOldEnch] := oScrollM711
	ElseIf cAliasPos == "SB1" .And. SBZ->(DbSeek(xFilial("SBZ")+SB1->B1_COD))
		nRecPos := Recno()
		RegToMemory("SBZ",.F.)
		MsMGet():New("SBZ",nRecPos,1,,,,,{aPos[1],aPos[2],Round(aPos[3],0)-3,aPos[4]},,3,,,,oPanelM711,,,lOneColumn)
	ElseIf cAliasPos == "BLQ" //Saldo bloqueado de subproduto
		aTexto := {{STR0155,CZI->CZI_DOC}}

		AADD(aTexto,{lTrim(STR0100),Str(CZI->CZI_QUANT,aTamQuant[1],aTamQuant[2])})
		AADD(aTexto,{STR0077,DTOC(aPeriodos[Val(CZI->CZI_PERMRP)])})

		MatScrDisp(aTexto,@oScrollM711,@oPanelM711,{aPos[1],aPos[2],Round(aPos[3],0)-3,aPos[4]},{{1,CLR_RED}})
		nOldEnch := 3
		aEnch[nOldEnch] := oScrollM711
	ElseIf cAliasPos == "SB2" //Saldo Negativo
		aTexto := {{STR0176,CZI->CZI_PROD}} //"Saldo Inicial Negativo"

		AADD(aTexto,{STR0175,Str(CZI->CZI_QUANT,aTamQuant[1],aTamQuant[2])}) //"Quantidade"
		AADD(aTexto,{STR0077,DTOC(aPeriodos[Val(CZI->CZI_PERMRP)])}) //"Data"

		MatScrDisp(aTexto,@oScrollM711,@oPanelM711,{aPos[1],aPos[2],Round(aPos[3],0)-3,aPos[4]},{{1,CLR_RED}})
		nOldEnch := 3
		aEnch[nOldEnch] := oScrollM711
	Else //MSMGET com detalhe do documento
		dbSelectArea(cAliasPos)
		dbGoto(nRecPos)
		RegToMemory(cAliasPos,.F.)
		MsMGet():New(cAliasPos,nRecPos,1,,,,,{aPos[1],aPos[2],Round(aPos[3],0)-3,aPos[4]},,3,,,,oPanelM711,,,lOneColumn)
	EndIf
EndIf

Return

/*-------------------------------------------------------------------------/
//Programa:	A712Gera
//Autor:		Rodrigo de Almeida Sartorio
//Data:		22.08.02
//Descricao:	Gera OP/SC de acordo com os Periodos Selecionados
//Parametros:	01.cNumOpDig - Numero da Op inicial a ser digitado pelo usuario
//				02.cStrTipo  - String com tipos a serem processados
//				03.cStrGrupo - String com grupos a serem processados
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712Gera(cNumOpDig,cStrTipo,cStrGrupo,oTempTable)
Local aSays		:= {}
Local aButtons	:= {}
Local nOpca		:= 0
Local lOpMax99	:= .T.
Local nRetry_0  := 0
Local nRetry_1  := 0
Local cValue    := ""
Local cTotal    := ""
Local cCount    := ""
Default oTempTable := Nil

If lVisRes
	AADD(aSays,OemToAnsi(STR0121))
	AADD(aSays,OemToAnsi(STR0122))
	AADD(aSays,OemToAnsi(STR0123))
	AADD(aButtons, { 1,.T.,{|o| nOpcA:= 1,If(MsgYesNo(OemToAnsi(STR0124),OemToAnsi(STR0030)),o:oWnd:End(),nOpcA:=2) } } )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	If aPergs711[4] == 2
		AADD(aButtons, { 5,.T.,{|o| cSelPerSC:=A712SelPer(cSelPerSc,STR0125,"SC",@cNumOpDig,@lOpMax99,@cSelFSC) }} )
		AADD(aButtons, { 5,.T.,{|o| cSelPer:=A712SelPer(cSelPer,STR0126,"OP",@cNumOpDig,@lOpMax99,@cSelF) }} )
	Else
		AADD(aButtons, { 5,.T.,{|o| cSelPerSC:=cSelPer:=A712SelPer(cSelPer,STR0125+" / "+STR0126,"SCOP",@cNumOpDig,@lOpMax99,@cSelF) }} )
	EndIf
EndIf

If cIntgPPI != "1"
	cValue := GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt)
	cTotal := GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt+"TOTAL")
	cCount := GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt+"COUNT")
EndIf

If !lBatch .And. lVisRes
	If cIntgPPI != "1"
		If !Empty(cValue) .And. (cValue != "3" .And. cValue != "30")
			MsgInfo(STR0150+CHR(13)+CHR(10)+ STR0080 + " " + cCount + STR0098 + cTotal,STR0030) //"A integra��o da exclus�o de ordens de produ��o previstas com o PC-Factory ainda est� em processamento, por favor aguarde." \n "Ordem de produ��o " XXX de XXX "Aten��o"
			Return Nil
		EndIf
	EndIf
	FormBatch(STR0030,aSays,aButtons,,200,450)
Else
	//Se existe a integra��o com o PPI, aguarda a finaliza��o da thread que
	//envia as ordens excluidas.
	If cIntgPPI != "1"
		While !Empty(cValue) .And. (cValue != "3" .And. cValue != "30")
			Sleep(500)
			cValue := GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt)
		End
	EndIf
	nOpca := 1
Endif

If lBatch
	lOpMax99 := lOpMaxAuto
EndIf

lDigNumOp := !Empty(cNumOpDig)

If nOpca == 1
	//Emite OP's e SC's
	FWMsgRun(,{|lEnd| MAT712OPSC(cNumOpDig,lOpMax99,cStrTipo,cStrGrupo,@oTempTable)},STR0128,STR0154) //"Conectando ao link informado..." //"Aguarde"

	//Inicia thread para integrar as ordens de produ��o com o PPI.
	If cIntgPPI != "1"
		StartJob("A712IntPPI",GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,c711NumMRP,cIntgPPI,__cUserId)

		//Neste ponto, apenas valida se conseguiu subir a thread.
		//ap�s subir a thread, deixa executando e antes de fechar o MRP � feita a valida��o da thread em execu��o.
		//Apenas vai fechar o MRP quando terminar o processamento da thread.
		While .T.
			Do Case
				//TRATAMENTO PARA ERRO DE SUBIDA DE THREAD
				Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '0'
					If nRetry_0 > 50
						//Conout(Replicate("-",65))
						//Conout("MATA712: "+ "N�o foi possivel realizar a subida da thread 'A712IntPPI'")
						//Conout(Replicate("-",65))

						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","N�o foi possivel realizar a subida da thread 'A712IntPPI'","N�o foi possivel realizar a subida da thread 'A712IntPPI'")
						Final(STR0166) //"N�o foi possivel realizar a subida da thread 'A712IntPPI'"
					Else
						nRetry_0 ++
					EndIf

				//TRATAMENTO PARA ERRO DE CONEXAO
				Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '10'
					If nRetry_1 > 5
						//Conout(Replicate("-",65))
						//Conout("MATA712: Erro de conexao na thread 'A712IntPPI'")
						//Conout("Numero de tentativas excedidas")
						//Conout(Replicate("-",65))

						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","MATA712: Erro de conexao na thread 'A712IntPPI'","MATA712: Erro de conexao na thread 'A712IntPPI'")
						Final(STR0167) //"MATA712: Erro de conexao na thread 'A712IntPPI'"
					Else
						//Inicializa variavel global de controle de Job
						PutGlbValue("A712IntPPI"+cEmpAnt+cFilAnt,"0")
						GlbUnLock()

						//Reiniciar thread
						//Conout(Replicate("-",65))
						//Conout("MATA712: Erro de conexao na thread 'A712IntPPI'")
						//Conout("Tentativa numero: " + StrZero(nRetry_1,2))
						//Conout(Replicate("-",65))

						//Atualiza o log de processamento
						ProcLogAtu("MENSAGEM","Reiniciando a thread : A712IntPPI","Reiniciando a thread : A712IntPPI")

						//Dispara thread para Stored Procedure
						StartJob("A712IntPPI",GetEnvServer(),MT712ADVPR(),cEmpAnt,cFilAnt,c711NumMRP,cIntgPPI,__cUserId)
					EndIf
					nRetry_1++

				//TRATAMENTO PARA ERRO DE APLICACAO
				Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '20'
					//Conout(Replicate("-",65))
					//Conout("MATA712: Erro ao efetuar a conex�o na thread 'A712IntPPI'")
					//Conout(Replicate("-",65))

					//Atualiza o log de processamento
					ProcLogAtu("MENSAGEM","MATA712: Erro ao efetuar a conex�o na thread 'A712IntPPI'","MATA712: Erro ao efetuar a conex�o na thread 'A712IntPPI'")
					Final(STR0168) // "MATA712: Erro ao efetuar a conex�o na thread 'A712IntPPI'"
				Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '2'
					//Thread iniciou processamento, continua a execu��o do programa.
					//Conout("MATA712: Thread A712IntPPI iniciou o processamento.")
					Exit
				Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '3'
					//J� finalizou o processamento.
					Exit
				Case GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt) == '30'
					//J� finalizou o processamento. mas com erros.
					//Conout(GetGlbValue("A712IntPPI"+cEmpAnt+cFilAnt+"ERRO"))
					Exit
			EndCase
			Sleep(500)
		End
	EndIf

	//Ponto de Entrada apos criacao de OPs/SCs
	If (ExistBlock("MTA710OPSC"))
		ExecBlock("MTA710OPSC",.F.,.F.,{cNumOpdig})
	EndIf
EndIf

Return Nil

/*-------------------------------------------------------------------------/
//Programa:	A712SelPer
//Autor:		Rodrigo de Almeida Sartorio
//Data:		22.08.02
//Descricao:	Seleciona periodo para geracao de OPs/SCs
//Parametros:	01.cPer      - Variavel com os periodos marcados/desmarcados
//				02.cTitulo   - Titulo a ser apresentado na DIALOG
//				03.cTipo711  - Tipo da Selecao - OP / SC / OP e SC
//				04.cNumOpDig - Numero da Op inicial a ser digitado pelo usuario
//				05.lOpMax99  - Indica se o maximo de itens por op e 99
//				06.cTpOP     - Tipo da OP
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712SelPer(cPer,cTitulo,cTipo711,cNumOpDig,lOpMax99,cTpOP)
Local lOp        	:= "OP" $ cTipo711
Local lOpMaxDig  	:= lOpMax99
Local aAlterGDa  	:= {}
Local aHeaderPER 	:= {}
Local aColsPER   	:= {}
Local nOpca      	:= 0
Local nI			:= 0
Local cNumOpGet  	:= cNumOpDig
Local cTitle	 	:= OemToAnsi(STR0129+cTitulo)	//"Periodos para geracao de "
Local cSelPer		:= ""
Local nSelec	 	:= 1
Local dDatDe  	:= dDataBase
Local dDatAte 	:= dDataBase
//Variaveis tipo objeto
Local oGetPer,oDlgPer

//Divide cabe�alho
oSize := FwDefSize():New()
oSize:SetWindowSize({000,000,300,350})
oSize:AddObject("NUMERO",100,80,.T.,.T.) //Dimensionavel
oSize:AddObject("OP"    ,100,20,.T.,.T.) //Dimensionavel
oSize:lProp := .T. //Proporcional
oSize:aMargins := {3,3,3,3} //Espaco ao lado dos objetos 0, entre eles 3
//Dispara os calculos
oSize:Process()

Aadd(aHeaderPER,{" "	,;
                 "CHKOK"	,;
                 "@BMP",;
                 1,;
                 0,;
                 "",;
                 "",;
                 "",;
                 "",;
                 "",;
                 "",;
                 "",;
                 ""})

Aadd(aHeaderPER,{STR0169,;  // "Periodos"
                 "PERMRP",;
				   "@!",;
                 10,;
                 0,;
                 "",;
                 "",;
                 "D",;
                 "",;
                 "",;
                 "",;
                 "",;
                 ""})

Aadd(aHeaderPER,{STR0170,; //TIPO
 		          "C2_TPOP",;
                 "@!",;
                 1,;
                 0,;
                 "Pertence('12')",;
                 "",;
                 "C",;
                 "",;
                 "",;
                 STR0130,; // "1=Firme;2=Previsto"
                 "",;
                 ""})

AADD(aAlterGDa,"C2_TPOP")

AADD(aAlterGDa,"CHKOK")

For nI:=1 to Len(aPeriodos)
	AADD(aColsPER,{If(Substr(cPer,nI,1)=="�",oOk,oNo),DTOC(aPeriodos[nI]),If(Substr(cTpOP,nI,1)=="�","1","2"),.F.})
Next nI

//Verifica se seleciona OP
If lOP .And. Empty(cNumOpGet)
	cNumOpGet := CRIAVAR("C2_NUM",.F.)
EndIf

DEFINE MSDIALOG oDlgPer TITLE cTitle FROM 000,000 TO 400,350 OF oMainWnd PIXEL

oGetPer := MsNewGetDados():New(oSize:GetDimension("NUMERO","LININI"),oSize:GetDimension("NUMERO","COLINI"),;
                               oSize:GetDimension("NUMERO","LINEND"),oSize:GetDimension("NUMERO","COLEND"),;
	     				          3,"AllwaysTrue","AllwaysTrue",/*cIniCpos*/,aAlterGDa,/*nFreeze*/,990,/*cFieldOk*/, /*cSuperDel*/,;
                               "AllwaysFalse", oDlgPer, @aHeaderPER, @aColsPER)
oGetPer:SetEditLine(.F.)
oGetPer:AddAction("CHKOK",{||If(oGetPer:aCols[oGetPer:nAT,1] == oOk,oNo,oOk)})
oGetPer:lInsert := .F.

oTButMarDe := TButton():New(oSize:GetDimension("NUMERO","LININI")+1,oSize:GetDimension("NUMERO","COLINI")+1,,;
                            oDlgPer,{|| AT712IMarc(@oGetPer)},16,10,,,.F.,.T.,.F.,,.F.,,,.F.)

@ oSize:GetDimension("OP","LININI")+2,oSize:GetDimension("OP","COLINI") Say OemtoAnsi(STR0131) SIZE 100,7 OF oDlgPer PIXEL
@ oSize:GetDimension("OP","LININI")  ,oSize:GetDimension("OP","COLINI")+15 MSGET dDatDe PICTURE "99/99/99" SIZE 50,09 OF oDlgPer PIXEL
@ oSize:GetDimension("OP","LININI")+2,oSize:GetDimension("OP","COLINI")+80 Say OemtoAnsi(STR0132) SIZE 100,7 OF oDlgPer PIXEL
@ oSize:GetDimension("OP","LININI")  ,oSize:GetDimension("OP","COLINI")+100 MSGET dDatAte PICTURE "99/99/99" SIZE 50,09 OF oDlgPer PIXEL

@ oSize:GetDimension("OP","LININI")+15,oSize:GetDimension("OP","COLINI") RADIO oRdx VAR nSelec SIZE 70,10 PROMPT  OemToAnsi(STR0133),OemToAnsi(STR0134)
@ oSize:GetDimension("OP","LININI")+35,oSize:GetDimension("OP","COLINI") BUTTON STR0135 SIZE 055,010 ACTION A712Reprog(@oGetPer,nSelec,dDatDe,dDatAte) OF oDlgPer PIXEL

If lOP
	@ oSize:GetDimension("OP","LININI")+55,oSize:GetDimension("OP","COLINI") Say OemtoAnsi(STR0136) SIZE 100,7 OF oDlgPer PIXEL	//"Numero Inicial p/geracao"
	@ oSize:GetDimension("OP","LININI")+53,oSize:GetDimension("OP","COLINI")+100 MSGET cNumOpGet SIZE 50,09 OF oDlgPer PIXEL
	@ oSize:GetDimension("OP","LININI")+70,oSize:GetDimension("OP","COLINI") CHECKBOX oChk VAR lOPMaxDig PROMPT OemToAnsi(STR0137) SIZE 85, 10 OF oDlgPer PIXEL //"Maximo de 99 itens por OP"
	oChk:oFont := oDlgPer:oFont
EndIf

ACTIVATE MSDIALOG oDlgPer ON INIT EnchoiceBar(oDlgPer,{||nOpca:=2,oDlgPer:End()},{||oDlgPer:End()}) CENTERED

If nOpca = 2
	If lOp
		lOpMax99 := lOpMaxDig
		If Empty(cNumOpGet)
			cNumOpDig := GetNumSc2()
		Else
			cNumOpDig := cNumOpGet
		EndIf
	EndIf

	For nI:=1 to Len(oGetPer:aCols)
		If oGetPer:aCols[nI][1] == oOk
			If nI == 1
				cSelPer :="�"
			Else
				cSelPer :=cSelPer+"�"
			EndIf
		Else
			If nI == 1
				cSelPer :=" "
			Else
				cSelPer :=cSelPer+" "
			EndIf
		EndIf

		If oGetPer:aCols[nI][3] == "1"
			If nI == 1
				cTpOP :="�"
			Else
				cTpOP :=cTpOP+"�"
			EndIf
		Else
			If nI == 1
				cTpOP :=" "
			Else
				cTpOP :=cTpOP+" "
			EndIf
		EndIf
	Next nI
	cPer := cSelPer
EndIf

Return cPer

/*----------------------------------------------------------------------------/
//Programa:	 A712AltPer
//Autor:	 Renan Roeder
//Data:		 13/09/2018
//Descricao: Rotina que marca os periodos passados por parametro via batch.
//Parametros:
//Uso: 		 MATA712
//---------------------------------------------------------------------------*/
Static Function A712AltPer()
Local nPer := 0

If Len(aPerOpAuto) > 0
	cSelPer := Replicate(" ",Len(aPeriodos))
	For nPer:=1 to Len(aPerOpAuto)
		cSelPer := stuff(cSelPer,aPerOpAuto[nPer],1,"�")
	Next nPer
EndIf

If Len(aPerScAuto) > 0
	cSelPerSC := Replicate(" ",Len(aPeriodos))
	For nPer:=1 to Len(aPerScAuto)
		cSelPerSC := stuff(cSelPerSC,aPerScAuto[nPer],1,"�")
	Next nPer
EndIf

Return .T.

/*-------------------------------------------------------------------------/
//Programa:	MAT712OPSC
//Autor:		Ricardo Prandi
//Data:		09/10/2013
//Descricao:	Rotina de controle da emissao de OP's e SC's
//Parametros:	01.cNumOpDig - Numero da Op inicial a ser digitado pelo usuario
//				02.lOpMax99  - Indica se o maximo de itens por op e 99
//				03.cStrTipo  - String com tipos a serem processados
//				04.cStrGrupo - String com grupos a serem processados
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MAT712OPSC(cNumOpDig,lOpMax99,cStrTipo,cStrGrupo,oTempTable)
Local cNumOP		:= ""
Local cProduto	:= ""
Local cOpcional	:= ""
Local cOpcOri  	:= ""
Local cAliasTop 	:= ""
Local cQuery		:= ""
Local mOpc			:= ""
Local cItemOP		:= "01"
Local cRevisao	:= ""//CriaVar("B1_REVATU",.F.)
Local nSequenOP	:= 1
Local nPer			:= 0
Local zxy			:= 0
Local nRecPMP  	:= 0
Local nZ			:= 0
Local nBkpI	   	:= 0
Local nPrimDt  	:= 0
Local nAgluMrp 	:= 0
Local lA650CCF 	:= ExistBlock("A650CCF")
Local aSH5FixR 	:= {}

Local nQtdAglut  := 0
Local nPerIni    := 0
Local aCampos    := {}
Local oTTAglut
Local cAliasAglu := "TTAGLUT"
Local cProdOP    := ""
Local lGeraNec   := .F. //.T. - For�a o MATA650 gerar OP por necessidade -- .F. - (Default) Mant�m como est�.
Local cGeraOP    := "1" //INDICA A FORMA DE GERA��O DAS OPS DO PRODUTO PAI -- 1 - GERA POR OP, 2 - GERA POR NECESSIDADE
Local aProdOP    := {}

Local cFilCZI := xFilial("CZI")
Local cFilCZK := xFilial("CZK")

Default oTempTable := Nil
PRIVATE INCLUI  := .F.
PRIVATE ALTERA  := .F.
PRIVATE aUsoSH5 := {}
If cRevBranco == Nil
	cRevBranco := CriaVar("B1_REVATU",.F.)
EndIf

cRevisao := cRevBranco

oTTAglut := FWTemporaryTable():New( cAliasAglu )
aAdd(aCampos,{"FILIAL","C",TamSX3("CZI_FILIAL")[1],0})
aAdd(aCampos,{"PRODPAI","C",TamSX3("CZI_PROD")[1],0})
aAdd(aCampos,{"FORMMRPPAI","C",1,0})
aAdd(aCampos,{"COMPON","C",TamSX3("CZI_PROD")[1],0})
aAdd(aCampos,{"PERIODO","C",TamSX3("CZI_PERMRP")[1],0})
aAdd(aCampos,{"QUANT","N",TamSX3("CZI_QUANT")[1],TamSX3("CZI_QUANT")[2]})
oTTAglut:SetFields( aCampos )
oTTAglut:AddIndex("1", {"FILIAL","COMPON", "PERIODO"} )
oTTAglut:AddIndex("2", {"FILIAL","COMPON", "FORMMRPPAI"} )
oTTAglut:Create()

Pergunte("MTA650",.F.)
mv_par03 := aPergs711[08]
mv_par04 := aPergs711[09]

//Obtem numero da proxima OP
dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial("SC2")+AllTrim(cNumOpDig))
cNumOp := If(!Empty(cNumOpDig) .And. Eof(),cNumOpDig, GetNumSc2())

//Quando utiliza PMP gera Ordens de Producao pela CZI. Apos gerar as OPs do PMP deve considerar as demais necessidades.
//O PMP tem a particularidade de gerar OPs mesmo que o saldo do produto exista, por isso sua utilizacao por empresas
//que produzem para estoque.
If aPergs711[1] == 2
	//Atualiza o log de processamento
	ProcLogAtu("MENSAGEM","Iniciando Gera��o de OPs/SCs PMP","Iniciando Gera��o de OPs/SCs PMP")

	cAliasTop := "BUSCASHC"
	cQuery := " SELECT CZI.CZI_PROD, " +;
	                 " CZI.CZI_NRRV, " +;
	                 " CZI.CZI_QUANT, " +;
	                 " CZI.CZI_NRRGAL, " +;
	                 " CZI.CZI_PERMRP, " +;
	                 " CZI.CZI_NRLV, " +;
	                 " SB1.B1_CONTRAT, " +;
	                 " SB1.B1_TIPO, " +;
	                 " SB1.B1_APROPRI, " +;
	                 " SB1.B1_LOCPAD, " +;
	                 " SB1.B1_PROC, " +;
	                 " SB1.B1_LOJPROC, " +;
	                 " SB1.B1_CC, " +;
	                 " CZI.R_E_C_N_O_ CZIREC " +;
	            " FROM " + RetSqlName("CZI") + " CZI, " +;
	                       RetSqlName("SHC") + " SHC, " +;
	                       RetSqlName("SB1") + " SB1 " +;
	           " WHERE CZI.CZI_FILIAL  = '" + cFilCZI + "' " +;
	             " AND SB1.B1_FILIAL   = '" + xFilial("SB1") + "' " +;
	             " AND SB1.D_E_L_E_T_ = ' ' " +;
	             " AND CZI.CZI_NRRGAL  = SHC.R_E_C_N_O_ " +;
	             " AND CZI.CZI_PROD    = SB1.B1_COD " +;
	             " AND CZI.CZI_ALIAS   = 'SHC' " +;
	             " AND CZI.CZI_QUANT   > 0 " +;
	             " AND SHC.HC_OP       = ' ' " +;
	             " AND CZI.D_E_L_E_T_  = ' ' "
	cQuery += " ORDER BY " + SqlOrder(CZI->(IndexKey(2)))
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	dbSelectArea(cAliasTop)

	//ProcRegua(LastRec())

	While !Eof()
		//IncProc()
		//Produto do PMP
		cProduto := (cAliasTop)->CZI_PROD

		//Registro do SHC
		nRecPMP := (cAliasTop)->CZI_NRRGAL

		//Opcionais do PMP
		CZI->(dbGoTo((cAliasTop)->CZIREC))

        if ! lMopcGRV
            mOpc      := CZI->CZI_OPC
        Else
            mOpc:=  BuscaMopc(CZI->CZI_OPC)
        Endif

        cOpcional := CZI->CZI_OPCORD

		//Revisao
		cRevisao := (cAliasTop)->CZI_NRRV

		//Quantidade do PMP
		nLoteQtd := (cAliasTop)->CZI_QUANT

		//Periodo
		nPer := Val((cAliasTop)->CZI_PERMRP)

		//Verifica o tipo
		cTipo711 := IIF((cAliasTop)->CZI_NRLV = '99',"C","F")

		A712CriCZJ(cProduto,cOpcional,cRevisao,(cAliasTop)->CZI_NRLV,(cAliasTop)->CZI_PERMRP,-nLoteQtd,"2",cAliasTop,/*09*/,cStrTipo,cStrGrupo,.F.,/*13*/)

		//Executa execblock para verificar se produto sera fabricado ou comprado
		If lA650CCF
			cOldTipo := cTipo711
			cTipo711 := ExecBlock("A650CCF",.F.,.F.,{cProduto,cTipo711,aPeriodos[nPer]})
			If !(ValType(cTipo711) == "C") .Or. !(cTipo711 $ "FCI")
				cTipo711 := cOldtipo
			EndIf
		EndIf

		If cTipo711 == "C"
			//Se for nivel 99, gera SC
			If ((aPergs711[04] == 1 .And. Substr(cSelPer,nPer,1) == "�") .Or. (aPergs711[04] == 2 .And. Substr(cSelPerSC,nPer,1) == "�")) .AND. A712VerHl(aPeriodos[nPer],cProduto)
				A712GeraSC(nPer,nLoteQtd,cProduto,cAliasTop)

				//Atualiza o status do plano mestre de produ��o para executado.
				dbSelectArea("SHC")
				dbGoto(nRecPMP)
				RecLock("SHC",.F.)
				Replace HC_STATUS With "E"
				MsUnlock()
			EndIf
		ElseIf cTipo711 == "F"
			//Se for nivel <> 99, gera OP
			If Substr(cSelPer,nPer,1) == "�" .AND. A712VerHl(aPeriodos[nPer],cProduto)
				U_A712GeraOP(@cNumOP,cItemOP,nSequenOP,nPer,nLoteQtd,cProduto,cOpcional,cRevisao,lOpMax99,mOpc)

				//Atualiza numero da OP no arquivo de PMP
				dbSelectArea("SHC")
				dbGoto(nRecPMP)
				RecLock("SHC",.F.)
				Replace HC_STATUS With "E"
				Replace HC_OP With cNumOp+cItemOP+StrZero(nSequenOP,3,0)
				MsUnlock()

				//Incrementa numeracao da OP
				If aPergs711[07] == 1
					cItemOP:=Soma1(cItemOp)
					If cItemOP > "99" .And. lOpMax99
						If lDigNumOp
							cNumOp := Soma1(cNumOp)
						Else
							cNumOp := GetNumSc2()
						Endif
						cItemOP := "01"
						nSequenOp := 1
					EndIf
				Else
					If lDigNumOp
						cNumOp := Soma1(cNumOp)
					Else
						cNumOp := GetNumSc2()
					Endif
					cItemOP := "01"
					nSequenOp := 1
				EndIf
			EndIf
		EndIf
		dbSelectArea(cAliasTop)
		dbSkip()
	End

	(cAliasTop)->(dbCloseArea())

	//Atualiza o log de processamento
	ProcLogAtu("MENSAGEM","Fim Gera��o de OPs/SCs PMP","Fim Gera��o de OPs/SCs PMP")
EndIf

//Atualiza o log de processamento
ProcLogAtu("MENSAGEM","Iniciando Gera��o de OPs/SCs","Iniciando Gera��o de OPs/SCs")

cAliasTop := "GERAOPSC"
cQuery := " SELECT CZJ.CZJ_PROD, " +;
                 " CZJ.CZJ_OPCORD, " +;
                 " CZJ.CZJ_NRRV, " +;
                 " CZJ.CZJ_NRLV, " +;
                 " CZK.CZK_PERMRP, " +;
                 " CZK.CZK_QTNECE, " +;
                 " SB1.B1_CONTRAT, " +;
                 " SB1.B1_TIPO, " +;
                 " SB1.B1_APROPRI, " +;
                 " SB1.B1_LOCPAD, " +;
                 " SB1.B1_PROC, " +;
                 " SB1.B1_LOJPROC, " +;
                 " SB1.B1_CC, " +;
                 " CZJ.R_E_C_N_O_ CZJREC, " +;
                 " CZK.R_E_C_N_O_ CZKREC " +;
            " FROM " + RetSqlName("CZJ") + " CZJ, " +;
                       RetSqlName("CZK") + " CZK, " +;
                       RetSqlName("SB1") + " SB1 " +;
           " WHERE CZJ.CZJ_FILIAL   = '" + xFilial("CZJ") + "' " +;
             " AND CZK.CZK_FILIAL   = '" + cFilCZK + "' " +;
             " AND SB1.B1_FILIAL    = '" + xFilial("SB1") + "' " +;
             " AND SB1.D_E_L_E_T_ = ' ' " +;
             " AND CZJ.R_E_C_N_O_   = CZK.CZK_RGCZJ " +;
             " AND CZJ.CZJ_PROD     = SB1.B1_COD " +;
             " AND EXISTS (SELECT 1 " +;
                           " FROM " + RetSqlName("CZK") + " CZKB " +;
                          " WHERE CZKB.CZK_FILIAL = '" + cFilCZK + "' " +;
                            " AND CZKB.CZK_RGCZJ  = CZJ.R_E_C_N_O_ " +;
                            " AND (CZKB.CZK_QTNECE > 0 OR (CZKB.CZK_QTNECE = 0 " +;
                            " AND EXISTS(SELECT 1 " +;
                                         " FROM " + RetSqlName("CZI") + " CZI " +;
                                        " WHERE CZI.CZI_FILIAL = '"+cFilCZI+"' " +;
                                          " AND CZI.D_E_L_E_T_ = ' ' " +;
                                          " AND CZI.CZI_ALIAS  = 'SBP' " +;
                                          " AND CZI.CZI_PROD   = CZJ.CZJ_PROD " +;
                                          " AND CZI.CZI_PERMRP = CZKB.CZK_PERMRP " +;
                                          " AND CZKB.CZK_RGCZJ = CZJ.R_E_C_N_O_ )))) "
If aPergs711[16] == 2
	cQuery += " ORDER BY CZJ.CZJ_NRLV, " +;
								" CZJ.CZJ_FILIAL, " +;
								" CZK.CZK_PERMRP, " +;
								" CZJ.CZJ_PROD, " +;
								" CZJ.CZJ_OPCORD "
Else
	cQuery += " ORDER BY CZJ.CZJ_NRLV, " +;
								" CZJ.CZJ_FILIAL, " +;
								" CZJ.CZJ_PROD, " +;
								" CZJ.CZJ_OPCORD, " +;
								" CZK.CZK_PERMRP "
EndIf
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
dbSelectArea(cAliasTop)

//ProcRegua(LastRec())

//Gera OP's para todos os periodos da projecao
While !Eof()
	//IncProc()

	//Periodo
	nPer := Val((cAliasTop)->CZK_PERMRP)

	cTipo711 := IIf((cAliasTop)->CZJ_NRLV = "99","C","F")

	//Produto
	cProduto := (cAliasTop)->CZJ_PROD

	//Executa execblock para verificar se produto sera fabricado ou comprado
	If lA650CCF
		cOldTipo := cTipo711
		cTipo711 := ExecBlock("A650CCF",.F.,.F.,{cProduto,cTipo711,aPeriodos[nPer]})
		If !(ValType(cTipo711) == "C") .Or. !(cTipo711 $ "FCI")
			cTipo711:=cOldtipo
		EndIf
	EndIf

	If cTipo711 = "C" .And. ((aPergs711[04] == 1 .And. Substr(cSelPer,nPer,1) # "�") .Or. (aPergs711[04] == 2 .And. Substr(cSelPerSC,nPer,1) # "�"))
		dbSelectArea(cAliasTop)
		dbSkip()
		loop
	ElseIf cTipo711 == "F" .And. Substr(cSelPer,nPer,1) # "�"
		dbSelectArea(cAliasTop)
		dbSkip()
		loop
	EndIf

	If (aPergs711[04] == 1 .And. Substr(cSelPer,nPer,1) == "�") .Or. aPergs711[04] == 2
		//Produto
		cProduto := (cAliasTop)->CZJ_PROD

		//Opcional
		CZJ->(dbGoTo((cAliasTop)->CZJREC))
		cOpcional := CZJ->CZJ_OPC
		cOpcOri := CZJ->CZJ_MOPC

		//Revisao
		cRevisao := (cAliasTop)->CZJ_NRRV

		aSH5FixR := {}

		//Posiciona na CZK para pegar possiveis atualiza��es de saldo e necessidade
		CZK->(dbGoTo((cAliasTop)->CZKREC))
		nLoteQtd:= CZK->CZK_QTNECE


		/** INICIO ALTERA��O AGLUTINA��O DE OPI/SC **/

		lGeraNec := .F.

		If (nPerIni >= nPer) .Or. (nPerIni == 0)
			cFormMrp := getFormMRP(cProduto)
			If cFormMrp == "2" .Or. ((Empty(cFormMrp) .Or. cFormMrp == "1")  .And. ((cTipo711 == "C" .And. aPergs711[2] == 1) .Or. (cTipo711 == "F" .And. aPergs711[3] == 1)))
				cGeraOP  := "1"
			Else
				cGeraOp := "2"
			EndIf
			For nPerIni := nPer To Len(aPeriodos)
				CZI->(dbSetOrder(4))
				CZI->(dbSeek(cFilCZI+"CZJ"+PadR(cProduto,TamSX3("CZI_DOC")[1])+DTOS(aPeriodos[nPerIni])))
				While !CZI->(EOF()) .And. "CZJ"+PadR(cProduto,TamSX3("CZI_DOC")[1])+DTOS(aPeriodos[nPerIni])== CZI->(CZI_ALIAS+CZI_DOC+DTOS(CZI_DTOG))
					nAgluMrp := Val(getAgluMRP(CZI->CZI_PROD))
					If (nUsado < nAgluMrp) .Or. (nUsado==7)
						RecLock(cAliasAglu,.T.)
						Replace FILIAL     With CZI->CZI_FILIAL
						Replace PRODPAI    With cProduto
						Replace FORMMRPPAI With cGeraOp
						Replace COMPON     With CZI->CZI_PROD
						Replace PERIODO    With CZI->CZI_PERMRP
						Replace QUANT      With CZI->CZI_QUANT
						MsUnlock()
					EndIf
					CZI->(dbSkip())
				End
			Next nPerIni
			nPerIni := nPer
		EndIf

		If QtdComp(nLoteQtd) > QtdComp(0)
			(cAliasAglu)->(dbSetOrder(2))
			If (cAliasAglu)->(dbSeek(cFilCZI+cProduto+"1"))
				(cAliasAglu)->(dbSetOrder(1))
				IF (cAliasAglu)->(dbSeek(cFilCZI+cProduto))
					ASize(aProdOP, 0)
					cProdOP := ""
					While !(cAliasAglu)->(eof()) .And. (cAliasAglu)->(FILIAL+COMPON) == cFilCZI+cProduto
						If (cAliasAglu)->FORMMRPPAI == "1"
							If aScan(aProdOP,{|x| x == (cAliasAglu)->PRODPAI}) == 0
								aAdd(aProdOP,(cAliasAglu)->PRODPAI)
							EndIf
						EndIf
						RecLock(cAliasAglu,.F.,.T.)
						dbDelete()
						MsUnlock()
						dbSkip()
					EndDo
					For nZ := 1 to Len(aProdOP)
						If Empty(cProdOp)
							cProdOP := AllTrim(aProdOP[nZ])
						Else
							cProdOP := cProdOP + " / " + AllTrim(aProdOP[nZ])
						EndIf
					Next nZ
					ProcLogAtu("MENSAGEM","OPIs/SCs do componente "+AllTrim(cProduto)+" n�o aglutinadas.","Os produtos pais "+cProdOp+" est�o gerando os documentos por OP.")
				EndIf
			Else
				(cAliasAglu)->(dbSetOrder(1))
				If (cAliasAglu)->(dbSeek(cFilCZI+cProduto))
					nAgluMrp := Val(Posicione("SB5",1,xFilial("SB5")+cProduto,"B5_AGLUMRP"))
					While !(cAliasAglu)->(eof()) .And. (cAliasAglu)->(FILIAL+COMPON) == cFilCZI+cProduto
						If A712Periodo(aPeriodos[nPer],If(Val((cAliasAglu)->PERIODO)>Len(aPeriodos),SToD(''),aPeriodos[Val((cAliasAglu)->PERIODO)]),nAgluMrp)
							nQtdAglut += (cAliasAglu)->QUANT
							RecLock(cAliasAglu,.F.,.T.)
							dbDelete()
							MsUnlock()
						Else
							Exit
						EndIf
						dbSkip()
					EndDo
					If nQtdAglut > nLoteQtd
						nLoteQtd := nQtdAglut
					EndIf
					nQtdAglut := 0
					lGeraNec  := .T.
				EndIf
			EndIf
		EndIf

		/** FIM ALTERA��O AGLUTINA��O DE OPI/SC **/

		//Soma ao lote de producao/compra quantidades originadas pelo indicador SBP (Subproduto) quando subproduto for
		//variavel (fixo deve gerar OP's separadas				|
		CZI->(dbSetOrder(3))
		CZI->(dbSeek(cFilCZI+cProduto+"SBP"))

		While CZI->(!EOF()) .And. CZI->(CZI_PROD+CZI_ALIAS) == cProduto+"SBP"
			If AllTrim(CZI->CZI_PERMRP) == StrZero(nPer,3) .And. AllTrim(cOpcional) == AllTrim(CZI->CZI_OPCORD) .And. cRevisao == CZI->CZI_NRRV
				SG1->(dbSeek(xFilial("SG1")+CZI->(CZI_PROD+CZI_DOC)))

				If SG1->G1_FIXVAR $ " V"
					nLoteQtd += CZI->CZI_QUANT
				Else
					aAdd(aSH5FixR,CZI->(Recno()))
				EndIf
				A712CriCZJ(cProduto,CZI->CZI_OPCORD,CZI->CZI_NRRV,CZI->CZI_NRLV,CZI->CZI_PERMRP,-CZI->CZI_QUANT,"2",/*08*/,/*09*/,cStrTipo,cStrGrupo,.F.,/*13*/)
			EndIf
			CZI->(dbSkip())
		End

		If (QtdComp(nLoteQtd) > QtdComp(0) .Or. !Empty(aSH5FixR)) .And. RetFldProd(cProduto,"B1_FANTASM") # "S" .And. !IsProdMod(cProduto)
			If cTipo711 == "C"
				If (aPergs711[04] == 1 .And. Substr(cSelPer,nPer,1) == "�") .Or. (aPergs711[04] == 2 .And. Substr(cSelPerSC,nPer,1) == "�")
					//Quebras as quantidades das SCs
					aQtdes := CalcLote(cProduto,nLoteQtd,"C")
					aQtdes := A711LotMax(cProduto, nLoteQtd, aQtdes)
					For zxy := 1 to Len(aQtdes)
						A712GeraSC(nPer,aQtdes[zxy],cProduto,cAliasTop)
					Next zxy
					MA712Recalc((cAliasTop)->CZJ_PROD,(cAliasTop)->CZJ_OPCORD,(cAliasTop)->CZJ_NRRV,(cAliasTop)->CZK_PERMRP,/*05*/,/*06*/,/*07*/,(cAliasTop)->CZJREC,/*09*/)
				EndIf
			ElseIf cTipo711 == "F"
				If Substr(cSelPer,nPer,1) == "�"
					//Gera OP's para necessidade SBP quando subproduto fixo
					For nZ := 1 to Len(aSH5FixR)
						CZI->(dbGoTo(aSH5FixR[nZ]))
						aQtdes := CalcLote(cProduto,CZI->CZI_QUANT,"F")
						aQtdes := A711LotMax(cProduto,CZI->CZI_QUANT,aQtdes)

						For zxy := 1 To Len(aQtdes)
							U_A712GeraOP(@cNumOP,cItemOP,nSequenOP,nPer,aQtdes[zxy],cProduto,CZI->CZI_OPCORD,CZI->CZI_NRRV,lOpMax99,cOpcOri)

							//Incrementa numeracao da OP
							If aPergs711[07] == 1
								cItemOP := Soma1(cItemOp)

								If cItemOP > "99" .And. lOpMax99
									If lDigNumOp
										cNumOp := Soma1(cNumOp)
									Else
										cNumOp := GetNumSc2()
									Endif

									cItemOP := "01"
									nSequenOp := 1
								EndIf
							Else
								If lDigNumOp
									cNumOp := Soma1(cNumOp)
								Else
									cNumOp := GetNumSc2()
								Endif

								cItemOP := "01"
								nSequenOp := 1
							EndIf
						Next zxy
					Next nZ

					aQtdes := CalcLote(cProduto,nLoteQtd,"F")
					aQtdes := A711LotMax(cProduto,nLoteQtd,aQtdes)

					For zxy:=1 to Len(aQtdes)
						U_A712GeraOP(@cNumOP,cItemOP,nSequenOP,nPer,aQtdes[zxy],cProduto,cOpcional,cRevisao,lOpMax99,cOpcOri,lGeraNec)

						// Incrementa numeracao da OP
						If aPergs711[07] == 1
							cItemOP:=Soma1(cItemOp)

							If cItemOP > "99" .And. lOpMax99
								If lDigNumOp
									cNumOp := Soma1(cNumOp)
								Else
									cNumOp := GetNumSc2()
								Endif
								cItemOP := "01"
								nSequenOp := 1
							EndIf
						Else
							If lDigNumOp
								cNumOp := Soma1(cNumOp)
							Else
								cNumOp := GetNumSc2()
							Endif

							cItemOP := "01"
							nSequenOp := 1
						EndIf
					Next zxy
				EndIf
			EndIf
		EndIf
	Endif
	If !Empty(nBkpI)
		nPer    := nBkpI
		nPrimDt := 0
		nBkpI   := 0
	EndIf
	dbSelectArea(cAliasTop)
	dbSkip()
End

(cAliasTop)->(dbCloseArea())

//Atualiza o log de processamento
ProcLogAtu("MENSAGEM","Fim Gera��o de OPs/SCs","Fim Gera��o de OPs/SCs")

oTTAglut:Delete()
//Recalcula as necessidades do n�vel 99
If !lBatch .And. lVisRes
	MA712ClNes("99")
	If SuperGetMV("MV_A712PRC",.F.,"1") == "1"
		MATA712MVW(,@oTempTable)
	Else
		a712MVW2(@oTempTable)
	EndIf
EndIf

If lMostraErro
	If lBatch
		Mostraerro()//Conout(STR0138+NomeAutoLog()) //"Verificar inconsistencia de rotina automatica em MRP - arquivo : "
	Else
		Mostraerro()
	EndIf
EndIf

Return

/*-------------------------------------------------------------------------/
//Programa:	A712GeraSC
//Autor:		Rodrigo de A. Sartorio
//Data:		27/08/02
//Descricao:	Rotina de geracao de SC's
//Parametros:	01.nPeriodo  - Periodo para geracao de SCs
//				02.nQuant    - Quantidade a ser gerada na SC
//				03.cProduto  - Produto a ser gerado na SC
//				04.cAliasTop - Alias do produto
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712GeraSC(nPeriodo,nQuant,cProduto,cAliasTop)
Local nNewQtdBx := 0
Local nI        := 0
Local aCampos	   := {}
Local aRetPE    := {}

Default cAliasTop := "SB1"

//If Len( aGeraOPC ) == 0 .or. Ascan( aGeraOPC, {|a| a[1] == cProduto } ) > 0

  //Verifica se o produto tem contrato de parceria, se nao, gera solic.Compra. Se sim, gera Autor. de Entrega
  If (cAliasTop)->B1_CONTRAT $ "N "
  	U_A712GravC1(nPeriodo,nQuant,cProduto,/*04*/,/*05*/,/*06*/,cAliasTop)
  Else
  	If ExistBlock("A710QtdBx")
  		//Ponto de Entrada para manipular quantidade a ser entregue pelo contrato de parceria
  		If ValType(nNewQtdBx := ExecBlock("A710QtdBx",.F.,.F., {nQuant,nPeriodo,aPeriodos[nPeriodo]})) == "N" .And. nNewQtdBx <= nQuant
  			nQuant := nNewQtdBx
  		Endif
  	EndIf

  	aAdd(aCampos,{"DATPRF",aPeriodos[nPeriodo]})
  	aAdd(aCampos,{"SEQMRP",c711NumMRP})
  	aAdd(aCampos,{"TPOP",A712VerHf(aPeriodos[nPeriodo],cProduto)})
  	aAdd(aCampos,{"USER",   RetCodUsr( )})

  	If ExistBlock("A712CNTSC1")
  		//Ponto de Entrada para manipular quantidade a ser entregue pelo contrato de parceria
  		aRetPE := ExecBlock("A712CNTSC1",.F.,.F.,{cProduto,nQuant,aCampos})
  		If Valtype(aRetPE) == "A"
  			For nI := 1 To Len(aRetPE)
  				If aScan(aCampos,{|x| x[1] == aRetPE[nI,1]}) < 1
  					aAdd(aCampos,aRetPE[nI])
  				EndIf
  			Next nI
  		EndIf
  	EndIf
  	MatGeraAE(cProduto,nQuant,aCampos,"MATA712")
  EndIf
//EndIf

Return

/*-------------------------------------------------------------------------/
//Programa:	A712GravC1
//Autor:		Rodrigo de A. Sartorio
//Data:		27/08/02
//Descricao:	Rotina de gravacao SC's
//Parametros:	01.nPeriodo  - Periodo para geracao de SCs
//				02.nQuant    - Quantidade a ser gerada na SC
//				03.cProduto  - Produto a ser gerado na SC
//				04.lAutEnt   - Indica se produto gera AUTORIZACAO DE ENTREGA
//				05.lSemData  - Indica se produto tem Contrato de Parceria fora
//								 da data - > Fora da Data do Contrato
//				06.lSemQuant - Indica se produto tem Contrato de Parceria sem
//								 quantidade - > Quantidade Esgotada
//				07.cAliasTop - Alias do produto
//Uso: 		MATA712
//------------------------------------------------------------------------*/
User Function A712GravC1(nPeriodo,nQuant,cProduto,lAutEnt,lSemData,lSemQuant,cAliasTop)
Static cUser
Static lExeBloC1

Local aCab 		:= {}
Local aItem		:= {}
Local cItem		:= StrZero(1,Len(SC1->C1_ITEM),0)
Local cTextoObs	:= ""
Local cLocal  	:= ""
Local aRetPE  	:= {}
Local cRevisao	:= Space(3)
Local aParam 		:= {aPeriodos[nPeriodo],nQuant, cProduto}

Private lMsErroAuto 	:= .F.

Default lAutEnt  	:= .F.
Default lSemData 	:= .F.
Default lSemQuant	:= .F.
Default cAliasTop	:= "SB1"

lExeBloC1 := If(lExeBloC1==NIL,ExistBlock("A711CSC1"),lExeBloC1)

//PE para tratamento se deve ou n�o incluir a SC. Se retornar F n�o inclui a SC.
If (ExistBlock("MT711VLSC"))
	lRet:= Execblock ("MT711VLSC",.F.,.F.,aParam)
	If !lRet
		Return
	EndIf
EndIf

cUser:= IF(cUser == NIL,RetCodUsr(),cUser)

//Nao gera para mao de obra e tipo = "BN" (Beneficiamento)
If !IsProdMod(cProduto) .And. ((cAliasTop)->B1_TIPO != "BN" .Or. ((cAliasTop)->B1_TIPO == "BN" .And. MatBuyBN()))
	If lAutEnt
		If lSemData
			cTextoObs := STR0139	//"FORA DA DATA CONTR. PARCERIA"
		ElseIf lSemQuant
			cTextoObs := STR0140	//"QUANT. DO CONTRATO ESGOTADA"
		Else
			cTextoObs := STR0141	//"SEM CONTRATO DE PARCERIA"
		EndIf
	EndIf

	//Verifica se o produto eh intermediario e se deve ou nao considerar o armazem de processo na geracao de SCs.
	If (cAliasTop)->B1_APROPRI == "I" .And. SuperGetMV("MV_GRVLOCP",.F.,.T.)
		cLocal := GETMV("MV_LOCPROC")
	Else
		cLocal	:= RetFldProd(SB1->B1_COD,"B1_LOCPAD")
	EndIf

	aCab:={{"C1_EMISSAO",dDataBase  	 		,Nil},; // Data de Emissao
			{"C1_FORNECE",SB1->B1_PROC   		,Nil},; // Fornecedor
			{"C1_LOJA"   ,SB1->B1_LOJPROC		,Nil},; // Loja do Fornecedor
			{"C1_SOLICIT",CriaVar("C1_SOLICIT"),Nil},;
			{"MRPNOVO"   ,"S"						,Nil}}	 //Indica se � o MRP NOVO

	aItem:={{{"C1_ITEM"	 ,cItem										 ,Nil},; //Numero do Item
		   	  {"C1_PRODUTO",cProduto										 ,Nil},; //Codigo do Produto
			  {"C1_QUANT"  ,nQuant										 ,Nil},; //Quantidade
			  {"C1_LOCAL"  ,cLocal										 ,Nil},; //Armazem
			  {"C1_DATPRF" ,aPeriodos[nPeriodo]						 ,Nil},; //Data
			  {"C1_TPOP"   ,A712VerHf(aPeriodos[nPeriodo],cProduto)	 ,Nil},; // Tipo SC
			  {"C1_CC"  	 ,SB1->B1_CC									 ,Nil},; //Centro de Custos
			  {"C1_GRUPCOM",MaRetComSC(SB1->B1_COD,UsrRetGrp(),cUser),Nil},; //Grupo de Compras
			  {"C1_SEQMRP" ,c711NumMRP									 ,Nil},; //Numero da Programacao do MRP
			  {"C1_OBS"  	 ,cTextoObs									 ,Nil},; //Observacao
			  {"C1_FORNECE" 	,SB1->B1_PROC		  						 ,Nil},; //Fornecedor
			  {"C1_LOJA"    	,SB1->B1_LOJPROC	  						 ,Nil},; // FMT - CONSULTORIA
			  {"C1_MOTIVO "    	,"MRP"		  						 ,Nil},; //Loja do Fornecedor - FMT 
			  {"C1_ZAPROV "    	,IIF(cEmpAnt=="03","001582","001521" ) ,Nil},; //ID APROVADOR - FMT
			  {"AUTVLDCONT","N",Nil},;
			  {"MRPNOVO"   ,"S",Nil}}}						//Indica se � o MRP NOVO

	cRevisao := Posicione("SB5",1,xFilial("SB5")+cProduto,"B5_VERSAO")
	AAdd(aTail(aItem),{"C1_REVISAO",cRevisao,NIL})

	If lExeBloC1
		aRetPE :=ExecBlock("A711CSC1",.f.,.f.,ACLONE(aItem))
		If Valtype(aRetPE) == "A"
			aItem:=ACLONE(aRetPE)
		EndIf
	EndIf

	MSExecAuto({|v,x,y,z| MATA110(v,x,y,z)},aCab,aItem,3,.T.)

	//Mostra Erro na geracao de Rotinas automaticas
	If lMsErroAuto
		lMostraErro:= .t.
	EndIf
EndIf

Return

/*-------------------------------------------------------------------------/
//Programa:	A712GeraOP
//Autor:		Rodrigo de A. Sartorio
//Data:		27/08/02
//Descricao:	Rotina de gravacao SC's
//Parametros:	01.cNumOP     - Numero da Op a ser gerada
//				02.cItem      - Item da OP a ser gerada
//				03.nSequen    - Sequencia da OP a ser gerada
//				04.nPeriodo   - Periodo para a geracao da OP
//				05.nQuant     - Quantidade da OP a ser gerada
//				06.cProduto   - Produto da OP a ser gerada
//				07.cOpcionais - Opcionais da OP a ser gerada
//				08.cRevisao   - Revisao da estrutura
//				09.lOpMax99   - Indica o numero maximo de itens
//				10.mOpc		  - Memo de opcionais
//				11.lGeraNec   - Indica se for�a a gera��o por necessidade
//Uso: 		MATA712
//------------------------------------------------------------------------*/
User Function A712GeraOP(cNumOp,cItem,nSequen,nPeriodo,nQuant,cProduto,cOpcionais,cRevisao,lOpMax99,mOpc,lGeraNec)
Static lM711SC2

Local aMata650  :={}
Local dPeriodo  := aPeriodos[nPeriodo]
Local nQuant2UM := ConvUm(cProduto,nQuant,0,2)
Local nPrazo    := CalcPrazo(cProduto,nQuant,,,.F.,dPeriodo)
Local aRetPE    := {}
Local cRoteiro  := ''

Private lMsErroAuto := .F.

Default lGeraNec := .F.

lM711SC2 := If(lM711SC2==NIL,ExistBlock("M711SC2"),lM711SC2)

//Obtem ROTEIRO
dbSelectArea("SG2")
dbSetOrder(1)

//Obtem numero da proxima OP
dbSelectArea("SC2")
dbSetOrder(1)

While dbSeek(xFilial("SC2")+AllTrim(cNumOp)+cItem)
	//Incrementa numeracao da OP
	If aPergs711[07] == 1
		cItem:=Soma1(cItem)
		If cItem > "99" .And. lOpMax99
			If lDigNumOp
				cNumOp := Soma1(cNumOp)
			Else
				cNumOp := GetNumSc2()
			Endif
			cItem   := "01"
			nSequen := 1
		EndIf
	Else
		If lDigNumOp
			cNumOp := Soma1(cNumOp)
		Else
			cNumOp := GetNumSc2()
		Endif
		cItem := "01"
		nSequen := 1
	EndIf
End

// FMT - Roteiro de Operacoes
cRoteiro := ''
IF SG2->(DBSEEK(XFILIAL("SG2") + PadR(cProduto,15) ))
	cRoteiro := SG2->G2_CODIGO
Endif

//Monta array para utilizacao da Rotina Automatica
aMata650 := { {'C2_NUM'		 ,cNumOp,"A710ValNum()"},;
		      {'C2_ITEM'     ,cItem,"A710ValNum()"},;
		      {'C2_SEQUEN'   ,StrZero(nSequen,Len(SC2->C2_SEQUEN)),"A710ValNum()"},;
		      {'C2_PRODUTO'  ,cProduto,NIL},;
		      {'C2_LOCAL'    ,_MVSTECK08 /*RetFldProd(SB1->B1_COD,"B1_LOCPAD")*/,NIL},;
		      {'C2_QUANT'    ,nQuant,NIL},;
		      {'C2_QTSEGUM'  ,nQuant2UM,NIL},;
		      {'C2_UM'       ,SB1->B1_UM	,NIL},;
		      {'C2_CC'       ,SB1->B1_CC	,NIL},;
		      {'C2_SEGUM'    ,SB1->B1_SEGUM,NIL},;
		      {'C2_DATPRI'   ,SomaPrazo(dPeriodo, - nPrazo),NIL},;
		      {'C2_DATPRF'   ,iif(dPeriodo<ddatabase,ddatabase,dPeriodo), NIL},;
		      {'C2_REVISAO'  ,If(A712TrataRev(),cRevisao,IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU )/*SB1->B1_REVATU*/),NIL},;
		      {'C2_TPOP'     ,A712VerHf(dPeriodo,cProduto),NIL},;
		      {'C2_EMISSAO'  ,dDataBase,NIL},;
		      {'C2_OPC'      ,cOpcionais,NIL},;
		      {'C2_SEQMRP'   ,c711NumMRP,Nil},;
		      {'C2_IDENT'    ,"P",Nil},;
		      {'MRP'         ,'S',NIL},;
		      {'AUTEXPLODE'  ,'S',NIL},;
		      {'MRPNOVO'	 ,'S',NIL}}
			  ///{'C2_ROTEIRO'  ,cRoteiro ,Nil},/*FMT - STECK*/;

If lUsaMOpc
	AAdd (aMata650, {'C2_MOPC',mOpc,NIL})
EndIf

aAdd (aMata650, {'GERANEC',lGeraNec,NIL})

//P.E. utilizado para manipular o Array aMata650, antes da geracao da Ordem de Producao.
If lM711SC2
	aRetPE := ExecBlock("M711SC2",.f.,.f.,ACLONE(aMata650))
	If Valtype(aRetPE) == "A"
		aMata650 := ACLONE(aRetPE)
	EndIf
EndIf

//Chamada da rotina automatica
msExecAuto({|x,Y| Mata650(x,Y)},aMata650,3)

//Mostra Erro na geracao de Rotinas automaticas
If lMsErroAuto
	MostraErro()
	lMostraErro:= .t.
EndIf

Return

/*-------------------------------------------------------------------------/
//Programa:	A712Periodo
//Autor:		Leonardo Quintania
//Data:		27/10/11
//Descricao:	Verifica peridiocidade para aglutinacao.
//Parametros:	01.dDatRef - Data de refer�ncia
//				02.dData   - Pr�ximo dia
//				03.nTipo   - Tipo de aglutina��o
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712Periodo(dDatRef,dData,nTipo)
Local lRet := .F.
Local nMes := 0
Local nDif := 0

Default nTipo := 1

Do Case
	Case nTipo == 0 .OR. nTipo == 1 // Pelo Programa
	Case nTipo == 2 // Diario

	Case nTipo == 3 // Semanal
		nDif := 7-Dow(dDatRef)
		If dData >= dDatRef .And. dData <= (dDatRef+nDif)
			lRet := .T.
		EndIf
	Case nTipo == 4 // Quinzenal
		If (Day(dDatRef)<=15) == (Day(dData)<=15)
			lRet := .T.
		EndIf
	Case nTipo == 5 // Mensal
		If Month(dDatRef) == Month(dData)
			lRet := .T.
		EndIf
	Case nTipo == 6 // Trimestral
		nRef := Month(dDatRef)
		nMes := Month(dData)
		If nRef >=1 .and. nRef <= 3
			If nMes >= 1 .and. nMes <= 3
				lRet := .T.
			EndIf
		ElseIf nRef >=4 .and. nRef <= 6
			If nMes >=4 .and. nMes <= 6
				lRet := .T.
			EndIf
		ElseIf nRef >=7 .and. nRef <= 9
			If nMes >=7 .and. nMes <= 9
				lRet := .T.
			EndIf
		ElseIf nRef >=10 .and. nRef <= 12
			If nMes >=10 .and. nMes <= 12
				lRet := .T.
			EndIf
		EndIf
	Case nTipo == 7 // Semestral
		If (Month(dDatRef)<=6) == (Month(dData)<=6)
			lRet := .T.
		EndIf
EndCase

Return lRet

/*-------------------------------------------------------------------------/
//Programa:	MATA712TB1
//Autor:		Ricardo Prandi
//Data:		14/10/2013
//Descricao:	Dividir os itens por threads a serem executadas em paralelo
//Parametros:	cQueryB1 - Filtro de itens (parametro por referencia
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MATA712TB1(cQueryB1)
Local aThreads   	:= {}
Local aProdutos  	:= {}
Local nX         	:= 0
Local nY         	:= 0
Local nInicio    	:= 0
Local nRegProc   	:= 0
Local nThreads   	:= SuperGetMv('MV_A710THR',.F.,1)
Local cAliasSB1  	:= "ITENSTHR"
Local cQuery   	:= ""
Local cQueryX1	:= ""
Local cA710Fil   	:= ""
Local lAllTp		:= Ascan(A711Tipo,{|x| x[1] == .F.}) == 0
Local lA710SQL   	:= ExistBlock("A710SQL")
Local lAllGrp 	:= Ascan(A711Grupo,{|x| x[1] == .F.}) == 0
Local cFilSB1 := xFilial("SB1")

If lMRPCINQ == Nil
	lMRPCINQ := SuperGetMV("MV_MRPCINQ",.F.,.F.)
EndIf

If nThreads <= 0
	nThreads := 1
EndIf

//Projeto Implementeacao de campos MRP e FANTASM no SBZ
If cDadosProd == "SBZ"
	cQueryX1 := fSBZSelec(@cQuery,cFilSB1)
Else
	//Query principal de itens
	cQuery := " SELECT B1_COD " +;
	            " FROM "+RetSqlName("SB1")+" SB1 " +;
	           " WHERE "
		//Query com a clausula WHERE
	cQueryX1 := "     SB1.B1_FILIAL   = '"+cFilSB1 +"' "
	cQueryX1 += " AND SB1.B1_FANTASM <> 'S' "
	cQueryX1 += " AND SB1.D_E_L_E_T_  = ' ' "
	cQueryX1 += " AND SB1.B1_MRP     IN (' ','S')"
	cQueryX1 += " AND B1_MSBLQL<>'1'" //ITEM BLOQUEADO
Endif

//Query com o filtro para os JOBS
cQueryB1 := "  AND SB1.B1_FILIAL   = '"+cFilSB1+"' "
cQueryB1 += "  AND SB1.B1_FANTASM <> 'S' "
cQueryB1 += "  AND SB1.D_E_L_E_T_  = ' ' "
cQueryB1 += " AND SB1.B1_MSBLQL<>'1'" //ITEM BLOQUEADO
//cQueryB1 += "  AND SB1.B1_MRP     IN (' ','S')"
If cDadosProd == "SBZ"
	fSBZWhere(@cQueryB1)
Else
	cQueryB1 += "  AND SB1.B1_MRP     IN (' ','S')"
EndIf
//Caso n�o tenha sido selecionado todos, coloca TIPOS na QUERY
If !lAllTp
	cQueryX1 += " AND SB1.B1_TIPO IN (SELECT TP_TIPO FROM " +cNomCZITTP +") "
	cQueryB1 += " AND SB1.B1_TIPO IN (SELECT TP_TIPO FROM " +cNomCZITTP +") "
EndIf

//Caso n�o tenha sido selecionado todos e o parametro estiver marcado, coloca os GRUPOS na QUERY
If !lAllGrp .And. lMRPCINQ
	cQueryX1 += " AND SB1.B1_GRUPO IN (SELECT GR_GRUPO FROM " +cNomCZITGR +") "
	cQueryB1 += " AND SB1.B1_GRUPO IN (SELECT GR_GRUPO FROM " +cNomCZITGR +") "
End If

//CH TRAAXW - Inicio

/*/Filtra o item j� com o local do parametro
If !Empty(aPergs711[8])
	cQueryX1 += " AND SB1.B1_LOCPAD >= '" + aPergs711[8] + "' "
EndIf

//Filtra o item j� com o local do parametro
If !Empty(aPergs711[9])
	cQueryX1 += " AND SB1.B1_LOCPAD <= '" + aPergs711[9] + "' "
EndIf

//Filtra se foi informado locais
If aAlmoxNNR # Nil
	cQueryX1 += " AND SB1.B1_LOCPAD IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
EndIf*/

//CH TRAAXW - Fim

cQuery:= ChangeQuery(cQuery + cQueryX1)

If lA710SQL
	cA710Fil := ExecBlock("A710SQL", .F., .F., {"SB1", cQuery})
	If ValType(cA710Fil) == "C"
		cQuery := cA710Fil
	Endif
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
aEval(SB1->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasSB1,x[1],x[2],x[3],x[4]),Nil)})

Do While (cAliasSB1)->(!Eof())
	aAdd(aProdutos,(cAliasSB1)->B1_COD)
	(cAliasSB1)->(dbSkip())
EndDo

//Verifica Limite Maximo de 30 Threads
If nThreads > 30
	nThreads := 30
EndIf

//Analisa a quantidade de Threads X nRegistros
If Len(aProdutos) == 0
	aThreads := {}
ElseIf Len(aProdutos) < nThreads
	aThreads := ARRAY(1)			// Processa somente em uma thread
Else
	aThreads := ARRAY(nThreads) // Processa com o numero de threads informada
EndIf

//Calcula o registro original de cada thread e aciona thread gerando arquivo de fila.
For nX:=1 to Len(aThreads)
	aThreads[nX] := {{},1}

	//Registro inicial para processamento
	nInicio := IIf( nX == 1 , 1 , aThreads[nX-1,2]+1 )

	//Quantidade de registros a processar
	nRegProc += IIf( nX == Len(aThreads) , Len(aProdutos) - nRegProc, Int(Len(aProdutos)/Len(aThreads)) )

	aThreads[nX,2] := nRegProc

	For nY := nInicio To nRegProc
		aAdd(aThreads[nX,1],aProdutos[nY])
	Next nY
Next nX

//Encerra cAliasSB1
dbSelectArea(cAliasSB1)
dbCloseArea()

Return aThreads

/*/{Protheus.doc} fSBZSelec
	(long_description)
	@type  Static Function
	@author mauricio.joao
	@since 12/11/2020
	@version 1.0
/*/
Static Function fSBZSelec(cQuery,cFilSB1)
Local cQueryX1 := ""

	//Query principal de itens
	cQuery := " SELECT SB1.B1_COD " +;
	            " FROM "+RetSqlName("SB1")+" SB1 Left Outer Join "+RetSqlName("SBZ")+" SBZ " +;
  	              " ON BZ_FILIAL = '"+xFilial("SBZ")+"' " +;
  	             " AND BZ_COD    = B1_COD AND SBZ.D_E_L_E_T_ = ' ' " +;
  	           " WHERE "
		//Query com a clausula WHERE
	cQueryX1 := "      SB1.B1_FILIAL='"+cFilSB1+"' "
	cQueryX1 += "  AND COALESCE(BZ_FANTASM, B1_FANTASM) <> 'S' "
	cQueryX1 += "  AND COALESCE(BZ_MRP,     B1_MRP    ) IN (' ','S') "
	cQueryX1 += "  AND SB1.D_E_L_E_T_ = ' ' "
	cQueryX1 += " AND B1_MSBLQL<>'1'" //ITEM BLOQUEADO

Return cQueryX1


/*/{Protheus.doc} fSBZwhere
	@type  Static Function
	@author mauricio.joao
	@since 12/11/2020
	@version 1.0
/*/

Static Function fSBZwhere(cQueryB1)
Local cFilSBZ := xFilial("SBZ")

	cQueryB1 += "  AND ( (SELECT COUNT(*) "
	cQueryB1 +=           " FROM " + RetSqlName("SBZ") + " SBZ "
	cQueryB1 +=          " WHERE SBZ.BZ_FILIAL = '"+cFilSBZ+"' "
	cQueryB1 +=            " AND SB1.D_E_L_E_T_ = ' ' "
	cQueryB1 += 		   " AND SB1.B1_MSBLQL<>'1'" //ITEM BLOQUEADO
	cQueryB1 +=            " AND SBZ.D_E_L_E_T_ = ' ' "
	cQueryB1 +=            " AND SB1.B1_COD    = SBZ.BZ_COD "
	cQueryB1 +=            " ) > 0   "

	cQueryB1 += "  AND  (SELECT COUNT(*) "
	cQueryB1 +=           " FROM " + RetSqlName("SBZ") + " SBZ "
	cQueryB1 +=          " WHERE SBZ.BZ_FILIAL = '"+cFilSBZ+"' "
	cQueryB1 +=            " AND SB1.D_E_L_E_T_ = ' ' "
	cQueryB1 += 			" AND SB1.B1_MSBLQL<>'1'" //ITEM BLOQUEADO
	cQueryB1 +=            " AND SBZ.D_E_L_E_T_ = ' ' "
	cQueryB1 +=            " AND SB1.B1_COD    = SBZ.BZ_COD "
	cQueryB1 +=            " AND SBZ.BZ_MRP IN ( ' ', 'S' ) ) > 0   "

	cQueryB1 +=       	   " OR ( (SELECT COUNT(*) "
	cQueryB1 +=            " FROM " + RetSqlName("SBZ") + " SBZ "
	cQueryB1 +=            " WHERE SBZ.BZ_FILIAL = '"+cFilSBZ+"' "
	cQueryB1 +=            " AND SB1.D_E_L_E_T_ = ' ' "
	cQueryB1 += 			" AND SB1.B1_MSBLQL<>'1'" //ITEM BLOQUEADO
	cQueryB1 +=            " AND SBZ.D_E_L_E_T_ = ' ' "
	cQueryB1 +=            " AND SB1.B1_COD = SBZ.BZ_COD "
	cQueryB1 +=            " ) = 0 "
	cQueryB1 +=            " AND SB1.B1_MRP = 'S' ) )"
	
Return .T.



/*-------------------------------------------------------------------------/
//Programa:	MATA712TZJ
//Autor:		Ricardo Prandi
//Data:		14/10/2013
//Descricao:	Dividir os itens por threads a serem executadas em paralelo
//Parametros:	cQueryB1 - Nivel da estrutura a ser processado
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MATA712TZJ(cNivEst)
Local cAliasTop 	:= "RECNECEST"
Local cQuery    	:= ""
Local cOpc			:= ""
Local aProdutos	:= {}
Local aItens     	:= {}
Local aThreads   	:= {}
Local nRecno		:= 0
Local nY			:= 0
Local nX			:= 0
Local nInicio    	:= 0
Local nRegProc   	:= 0
Local nThreads   	:= SuperGetMv('MV_A710THR',.F.,1)

//Verifica todos produtos utilizados
If cDadosProd == "SBZ"
	cQuery += " SELECT DISTINCT CZJ.CZJ_PROD CZJ_PROD, " +;
	                          " CZJ.CZJ_NRRV CZJ_NRRV, " +;
	                          " COALESCE(BZ_EMIN,B1_EMIN) B1_EMIN, " +;
	                          " CZJ.R_E_C_N_O_ CZJREC " +;
	            " FROM " + RetSqlName("CZJ") + " CZJ, " +;
              	         RetSqlName("CZK") + " CZK, " +;
              	         RetSqlName("SB1") + " SB1 " +;
              	         " LEFT OUTER JOIN " + RetSqlName("SBZ") + " SBZ  " +;
              	           " ON SBZ.BZ_FILIAL  = '"+xFilial("SBZ")+"' " +;
	                        " AND SBZ.BZ_COD     = SB1.B1_COD " +;
	                        " AND SBZ.D_E_L_E_T_ = ' ' " +;
	           " WHERE CZJ.CZJ_FILIAL   = '" + xFilial("CZJ") + "' " +;
	             " AND CZK.CZK_FILIAL   = '" + xFilial("CZK") + "' " +;
	             " AND SB1.B1_FILIAL    = '" + xFilial("SB1") + "' " +;
	             " AND SB1.D_E_L_E_T_ = ' ' " +;
	             " AND CZJ.R_E_C_N_O_   = CZK.CZK_RGCZJ " +;
	             " AND CZJ.CZJ_PROD     = SB1.B1_COD " +;
	             " AND (CZK.CZK_QTNECE <> 0 " +;
	             "  OR  CZK.CZK_QTSAID <> 0 " +;
	             "  OR  CZK.CZK_QTSALD <> 0 " +;
	             "  OR  CZK.CZK_QTSEST <> 0 " +;
	             "  OR  CZK.CZK_QTENTR <> 0 " +;
	             "  OR  CZK.CZK_QTSLES <> 0 " +;
	             "  OR  COALESCE(BZ_EMIN,B1_EMIN) <> 0) "

	If !Empty(cNivEst)
		cQuery += " AND CZJ.CZJ_NRLV = '" + cNivEst + "' "
	EndIf

	cQuery += 	" ORDER BY CZJ.CZJ_PROD, " +;
                 	  	  " CZJ.CZJ_NRRV, " +;
                 	  	  " CZJ.R_E_C_N_O_ "
Else
	cQuery += " SELECT DISTINCT CZJ.CZJ_PROD CZJ_PROD, " +;
	                 " CZJ.CZJ_NRRV CZJ_NRRV, " +;
	                 " SB1.B1_EMIN B1_EMIN, " +;
	                 " CZJ.R_E_C_N_O_ CZJREC " +;
	            " FROM " + RetSqlName("CZJ") + " CZJ, " +;
	                       RetSqlName("CZK") + " CZK, " +;
	                       RetSqlName("SB1") + " SB1 " +;
	           " WHERE CZJ.CZJ_FILIAL   = '" + xFilial("CZJ") + "' " +;
	             " AND CZK.CZK_FILIAL   = '" + xFilial("CZK") + "' " +;
	             " AND SB1.B1_FILIAL    = '" + xFilial("SB1") + "' " +;
	             " AND SB1.D_E_L_E_T_ = ' ' " +;
	             " AND CZJ.R_E_C_N_O_   = CZK.CZK_RGCZJ " +;
	             " AND CZJ.CZJ_PROD     = SB1.B1_COD " +;
	             " AND (CZK.CZK_QTNECE <> 0 " +;
	             "  OR  CZK.CZK_QTSAID <> 0 " +;
	             "  OR  CZK.CZK_QTSALD <> 0 " +;
	             "  OR  CZK.CZK_QTSEST <> 0 " +;
	             "  OR  CZK.CZK_QTENTR <> 0 " +;
	             "  OR  CZK.CZK_QTSLES <> 0 " +;
	             "  OR  B1_EMIN        <> 0) "

	If !Empty(cNivEst)
		cquery += " AND CZJ.CZJ_NRLV = '" + cNivEst + "' "
	EndIf

	cQuery += 	" ORDER BY CZJ.CZJ_PROD, " +;
	                 	  " CZJ.CZJ_NRRV, " +;
	                 	  " SB1.B1_EMIN, " +;
	                 	  " CZJ.R_E_C_N_O_ "
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
dbSelectArea(cAliasTop)

While !Eof()
	nRecno := CZJREC
	CZJ->(DbGoTo(nRecno))
	cOpc := CZJ->CZJ_OPC

	aItens := {}
	aAdd(aItens,{(cAliasTop)->CZJ_PROD,cOpc,(cAliasTop)->CZJ_NRRV,(cAliasTop)->CZJREC,(cAliasTop)->B1_EMIN})
	aAdd(aProdutos,aItens)

	dbSkip()
EndDo

(cAliasTop)->(dbCloseArea())

//Verifica Limite Maximo de 30 Threads
If nThreads > 30
	nThreads := 30
EndIf

//Analisa a quantidade de Threads X nRegistros
If Len(aProdutos) == 0
	aThreads := {}
ElseIf Len(aProdutos) < nThreads
	aThreads := ARRAY(1)			// Processa somente em uma thread
Else
	aThreads := ARRAY(nThreads)	// Processa com o numero de threads informada
EndIf

//Calcula o registro original de cada thread e aciona thread gerando arquivo de fila.
For nX := 1 to Len(aThreads)
	aThreads[nX] := {{},1}

	//Registro inicial para processamento
	nInicio := IIf(nX == 1,1,aThreads[nX-1,2]+1)

	//Quantidade de registros a processar
	nRegProc += IIf(nX == Len(aThreads),Len(aProdutos) - nRegProc,Int(Len(aProdutos)/Len(aThreads)))

	aThreads[nX,2] := nRegProc
	For nY := nInicio To nRegProc
		aAdd(aThreads[nX,1],aProdutos[nY,1])
	Next nY

Next nX

Return aThreads

/*-------------------------------------------------------------------------/
//Programa:	MATA712TZI
//Autor:		Ricardo Prandi
//Data:		14/10/2013
//Descricao:	Dividir os itens por threads a serem executadas em paralelo para vizualiza��o
//Parametros:	lFilNeces - Indica se filtra apenas necessidades
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MATA712TZI(lFilNeces)
Local nInicio		:= 0
Local nX			:= 0
Local nY			:= 0
Local nRegProc	:= 0
Local nThreads   	:= SuperGetMv('MV_A710THR',.F.,1)
Local aProdutos	:= {}
Local aItens		:= {}
Local aThreads	:= {}
Local cAliasTop	:= ""
Local cQuery		:= ""
Local cFilCZI := xFilial("CZI")

If lFilNeces
	cAliasTop := "FILTRATREE"
	cQuery := " SELECT DISTINCT CZI.R_E_C_N_O_ CZIREC " +;
	            " FROM " + RetSqlName("CZI") + " CZI, " +;
	                       RetSqlName("CZJ") + " CZJ, " +;
	                       RetSqlName("CZK") + " CZK  " +;
	           " WHERE CZI.CZI_FILIAL = '" + cFilCZI + "' " +;
	             " AND CZJ.CZJ_FILIAL = '" + xFilial("CZJ") + "' " +;
	             " AND CZK.CZK_FILIAL = '" + xFilial("CZK") + "' " +;
	             " AND CZI.CZI_PROD   = CZJ.CZJ_PROD " +;
	             " AND CZI.CZI_OPCORD = CZJ.CZJ_OPCORD " +;
	             " AND CZI.CZI_NRRV   = CZJ.CZJ_NRRV " +;
	             " AND CZJ.R_E_C_N_O_ = CZK.CZK_RGCZJ " +;
	             " AND CZK.CZK_QTNECE > 0 "
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	dbSelectArea(cAliasTop)

	While !Eof()
		aItens := {}
		aAdd(aItens,{(cAliasTop)->(CZIREC)})
		aAdd(aProdutos,aItens)
		dbSkip()
	End

	(cAliasTop)->(dbCloseArea())
Else
	dbSelectArea("CZI")
	dbSetOrder(1)
	dbSeek(cFilCZI)

	Do While !Eof() .And. (CZI_FILIAL == cFilCZI)
		If CZI->CZI_ALIAS = 'PAR'
			dbSkip()
			Loop
		EndIf

		aItens := {}
		aAdd(aItens,{CZI->(RecNo())})
		aAdd(aProdutos,aItens)
		dbSkip()
	EndDo
EndIf

//Verifica Limite Maximo de 30 Threads
If nThreads > 30
	nThreads := 30
EndIf

//Analisa a quantidade de Threads X nRegistros
If Len(aProdutos) == 0
	aThreads := {}
ElseIf Len(aProdutos) < nThreads
	//Processa somente em uma thread
	aThreads := ARRAY(1)
Else
	//Processa com o numero de threads informada
	aThreads := ARRAY(nThreads)
EndIf

//Calcula o registro original de cada thread e aciona thread gerando arquivo de fila.
For nX := 1 to Len(aThreads)
	aThreads[nX]:={{},1}

	//Registro inicial para processamento
	nInicio := IIf(nX == 1 , 1 , aThreads[nX-1,2]+1 )

	//Quantidade de registros a processar
	nRegProc += IIf( nX == Len(aThreads) , Len(aProdutos) - nRegProc, Int(Len(aProdutos)/Len(aThreads)) )

	aThreads[nX,2] := nRegProc

	For nY := nInicio To nRegProc
		aAdd(aThreads[nX,1],aProdutos[nY,1])
	Next nY
Next nX

Return aThreads

/*-------------------------------------------------------------------------/
//Programa:	A712StrRev
//Autor:		Marcelo Iuspa
//Data:		28/06/04
//Descricao:	Retorna STRING com numero da revisao caso esteja em uso
//Parametros:	01.cRevisao   - Revisao utilizada
//				02.cStrAntes  - Texto usado antes
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712StrRev(cRevisao, cStrAntes)
Local cRet := ""

If A712TrataRev() .And. ! Empty(cRevisao)
	Default cStrAntes := " "
	cRet := cStrAntes + STR0062 + ": " + cRevisao
Endif

Return(cRet)

/*-------------------------------------------------------------------------/
//Programa:	A712MontPer
//Autor:		Andre Anjos
//Data:		12/12/07
//Descricao:	Monta o painel para selecao da peridiocidade
//Parametros:	oCenterPanel - Objeto do painel
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712MontPer(oCenterPanel)
Local oUsado,oChk,oChk2,oChkQual,oChkQual2,oQual,oQual2
Local lQual,lQual2

@ 10,10 TO 125,115 LABEL OemToAnsi(STR0009) OF oCenterPanel  PIXEL //"Periodicidade do MRP"
@ 25,20 RADIO oUsado VAR nUsado 3D SIZE 70,10 PROMPT  OemToAnsi(STR0010),;	//"Per�odo Di�rio"
OemToAnsi(STR0011),;	//"Per�odo Semanal"
OemToAnsi(STR0012),;	//"Per�odo Quinzenal"
OemToAnsi(STR0013),;	//"Per�odo Mensal"
OemToAnsi(STR0014),;	//"Per�odo Trimestral"
OemToAnsi(STR0015),;	//"Per�odo Semestral"
OemToAnsi(STR0016) OF oCenterPanel PIXEL	//"Per�odos Diversos"
@ 102,020 Say OemToAnsi(STR0017) SIZE 60,10 OF oCenterPanel PIXEL	//"Quantidade de Per�odos:"
@ 100,085 MSGET nQuantPer Picture "999" SIZE 15,10 OF oCenterPanel PIXEL

@ 10,130 TO 125,400 LABEL OemToAnsi(STR0041) OF oCenterPanel PIXEL //"Filtro"
//Tipo
@ 25,150 CHECKBOX oChkQual VAR lQual  PROMPT OemToAnsi(STR0020) SIZE 50, 10 OF oCenterPanel PIXEL ON CLICK (AEval(a711Tipo , {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oQual:Refresh(.F.)) //"Inverter Selecao"
oQual := TCBrowse():New(35,150,100,81,,,,oCenterPanel,,,,,{||A711Tipo:=CA711Troca(oQual:nAt,A711Tipo),oQual:Refresh()},,,,,,,.T.,,.T.,,.F.,,)
oQual:SetArray(a711Tipo)

oQual:AddColumn(TCColumn():New("",{|| If(a711Tipo[oQual:nAt,1],oOk,oNo)},,,,"LEFT",,.T.,.F.,,,,.T.,))
oQual:AddColumn(TCColumn():New(OemToAnsi(STR0021),{|| a711Tipo[oQual:nAt,2]},,,,"LEFT",,.F.,.F.,,,,.F.,))
oQual:Refresh()

//Grupo
@ 25,280 CHECKBOX oChkQual2 VAR lQual2 PROMPT OemToAnsi(STR0020) SIZE 50, 10 OF oCenterPanel PIXEL ON CLICK (AEval(a711Grupo, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual2:Refresh(.F.)) //"Inverter Selecao"
oQual2 := TCBrowse():New(35,280,100,81,,,,oCenterPanel,,,,,{||a711Grupo:=CA711Troca(oQual2:nAt,A711Grupo),oQual2:Refresh()},,,,,,,.T.,,.T.,,.F.,,)
oQual2:SetArray(a711Grupo)

oQual2:AddColumn(TCColumn():New("",{|| If(a711Grupo[oQual2:nAt,1],oOk,oNo)},,,,"LEFT",,.T.,.F.,,,,.T.,))
oQual2:AddColumn(TCColumn():New(OemToAnsi(STR0022),{|| a711Grupo[oQual2:nAt,2]},,,,"LEFT",,.F.,.F.,,,,.F.,))
oQual2:Refresh()

@ 135,10 TO 180,400 LABEL OemToAnsi(STR0061) OF oCenterPanel PIXEL //"Opcionais"
@ 150,20 CHECKBOX oChk  VAR lPedido PROMPT OemToAnsi(STR0018) SIZE 85, 10 OF oCenterPanel PIXEL ;oChk:oFont := oCenterPanel:oFont	//"Considera Pedidos em Carteira"
@ 160,20 CHECKBOX oChk2 VAR lLogMRP PROMPT OemToAnsi(STR0019) SIZE 85, 10 OF oCenterPanel PIXEL ;oChk2:oFont := oCenterPanel:oFont	//"Log de eventos do MRP"

Return

/*-------------------------------------------------------------------------/
//Programa:	A712MontVis
//Autor:		Andre Anjos
//Data:		29/04/08
//Descricao:	Monta o painel para visualizacao da ultima exececucao do MRP
//Parametros:	oCenterPanel - Objeto do painel
//				lVisualiza   - Indica o tipo de visualiza��o
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712MontVis(oCenterPanel,lVisualiza)
Local oSay1, oSay2, oCheck
Local cProgra 	:= ""
Local aSize   	:= MsAdvSize()
Local aInfo   	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local aPosObj 	:= {}
Local aObjects 	:= {}

AADD(aObjects,{450,20,.T.,.T.,.F.})
aPosObj:=MsObjSize(aInfo,aObjects)

oSay1:= tSay():New(10,10,{|| OemToAnsi(STR0142+" "+STR0143)},oCenterPanel,,,,,,.T.,,,aPosObj[1,4]-200,aPosObj[1,3])
oSay2:= tSay():New(45,10,{|| OemToAnsi(STR0144)},oCenterPanel,,,,,,.T.,,,aPosObj[1,4]-200,aPosObj[1,3])
oCheck := TCheckBox():New(60,10,OemToAnsi(STR0145),{|| lVisualiza},oCenterPanel,100,210,,;
			{|| lVisualiza:=!lVisualiza},,,,,,.T.,,,) //Ativar visualiza��o

dbSelectArea("CZJ")
dbSetOrder(1)
dbGotop()

If !Eof()
	cProgra := AllTrim(CZJ->CZJ_NRMRP)
	dbCloseArea()
	oSay2:= tSay():New(45,75,{|| cProgra},oCenterPanel,,,,,,.T.,,,aPosObj[1,4]-200,aPosObj[1,3])
	oCheck:Enable()
Else
	oSay2:= tSay():New(45,75,{|| OemToAnsi(STR0146)},oCenterPanel,,,,,,.T.,CLR_RED,,aPosObj[1,4]-200,aPosObj[1,3])
	oCheck:Disable()
EndIf

Return

/*-------------------------------------------------------------------------/
//Programa:	M712FilNec
//Autor:		Ricardo Prandi
//Data:		16/10/2013
//Descricao:	Ativa/Desativa Filtro exibindo somente os produtos com necessidade
//Uso: 		MATA712(lFiltro)
//Par�metro:  .T. -> filtra por necessidade, .F.-> desativa o filtro
//------------------------------------------------------------------------*/
Static Function M712FilNec(lFiltro)

	If lFiltro
		MT712Tree(aPergs711[28]==1,/*02*/,.T.)
		lAtvFilNes := .T.
	Else
		//Limpa os filtros
		cFilQryCZI := " AND 1 = 1"
		cFilTabCZI := "1 = 1"
		MT712Tree(aPergs711[28]==1,,.F.,.F.)
	EndIf

	oTreeM711:TreeSeek("")
	Eval(oTreeM711:bChange)
Return .T.

/*-------------------------------------------------------------------------/
//Programa:	AT712IMarc
//Autor:		Leonardo Quintania
//Data:		09/05/2012
//Descricao:	Marca todas as linhas com evento de clique no cabe�alho do browse
//Parametros:	oBrowse - Objeto do browse
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function AT712IMarc(oBrowse)
Local aChks         :={}

aEval(oBrowse:aCols, {|x| aAdd(aChks,If(x[1]==oOK,.T.,.F.))})

If aScan(aChks, {|x| !x }) > 0
	aEval(@oBrowse:aCols, {|x| x[1] := oOK})
Else
	aEval(@oBrowse:aCols, {|x| x[1] := oNO})
EndIf

oBrowse:Refresh()

Return

/*-------------------------------------------------------------------------/
//Programa:	A712Reprog
//Autor:		Cleber Maldonado
//Data:		25/05/2012
//Descricao:	Reprograma as op��es Firme/Prevista na tela per�odos para gera��o de SC's / OP's
//Parametros:	Param1 - Objeto com os per�odos do MRP
//				Param2 - Numero da op��o selecionada (Firme/Prevista)
//				Param3 - Data de inicio para reprogramar op��es
//				Param4 - Data limite para reprogramar op��es
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712Reprog(oGetPer,nSelec,dDatDe,dDatAte)
Local nX := 1

For nX := 1 To Len(oGetPer:aCols)
	If CTOD(oGetPer:aCols[nX,2]) >= dDatde .and. CTOD(oGetPer:aCols[nX,2]) <= dDatAte
		oGetPer:aCols[nX,3] := Alltrim(Str(nSelec))
	Endif
Next nX

Return .T.

/*-------------------------------------------------------------------------/
//Programa:	A712VerHl
//Autor:		Leonardo Quintania
//Data:		20/12/11
//Descricao:	Verifica se o produto informado possui Horizonte Liberacao
//Parametros:	dDatPrf  - Data de referencia
//				cProduto - Codigo do produto
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712VerHl(dDatPrf,cProduto)
Local nDiasHf := Posicione("SB5",1,xFilial("SB5")+AllTrim(cProduto),"B5_DIASHL")
Local lGera	:= .T.

If !Empty(nDiasHf)
	If (dDatPrf <= (dDataBase + nDiasHf))
		lGera:= .T.
	Else
		lGera:= .F.
	EndIf
EndIf

Return lGera

/*-------------------------------------------------------------------------/
//Programa:	A712VerHf
//Autor:		Leonardo Quintania
//Data:		20/12/11
//Descricao:	Verifica se o produto informado possui Horizonte Firme
//Parametros:	dDatPrf  - Data de referencia
//				cProduto - Codigo do produto
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712VerHf(dDatPrf,cProduto)
Local nDiasHf  := Posicione("SB5",1,xFilial("SB5")+AllTrim(cProduto),"B5_DIASHF")
Local cTpOp    := If(aPergs711[10] == 1,"F","P")
Local cTpOpPar := ""
Local i        := aScan(aPeriodos,{|x| x == dDatPrf})
Local cFC      := "C"

SG1->(dbSetOrder(1))
If SG1->(dbSeek(xFilial("SG1")+cProduto))
	cFC := "F"
EndIf

If ExistBlock("A650CCF")
	cFC := ExecBlock("A650CCF",.F.,.F.,{cProduto,cTipo711,dDatPrf})
	If ValType(cFC) # "C"
		cFC := If(SG1->(dbSeek(xFilial("SG1")+cProduto)),"F","C")
	EndIf
EndIf

cTpOpPar := If(aPergs711[04] == 1 .Or. cFC == "F",cSelF,cSelFSC)

If !Empty(nDiasHf)
	If (dDatPrf <= (dDataBase + nDiasHf))
		cTpOp:= "F"
	Else
		cTpOp:= "P"
	EndIf
ElseIf Substr(cTpOpPar,i,1) == "�"
    cTpOp:= "F"
Else
	cTpOp:= "P"
EndIf

Return cTpOp

/*-------------------------------------------------------------------------/
//Programa:	MATA712LCK
//Autor:		Ricardo Prandi
//Data:		23/10/2013
//Descricao:	Cria semaforo para as tabelas
//Parametros:	lInJob - Indica se veio de JOB
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MATA712LCK(lInJob)
Local nTentativa := 0

Default lInJob := .F.

While !LockByName("CZIUSO"+cEmpAnt+cFilAnt,.T.,.T.,.T.)
	nTentativa ++
	If nTentativa > 10000
		ProcLogAtu("MENSAGEM","Limite de tentativas ultrapassado.","Limite de tentativas ultrapassado.")
		Exit
	EndIf
End

Return .T.

/*-------------------------------------------------------------------------/
//Programa:	MATA712LOG
//Autor:		Ricardo Prandi
//Data:		11/11/2013
//Descricao:	Monta LOG de processamento do MRP
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function MATA712LOG()
Local cQuery 		:= ""
Local cAliasTop 	:= "MONTALOG"
Local nRegAnt		:= 0
Local nAcho		:= 0
Local nz			:= 0
Local z			:= 0
Local nSaldo		:= 0
Local nB1Emin		:= 0
Local nB1Emax		:= 0
Local nQtdEnt       := 0
Local nInd          := 0
Local lCalcula	:= .F.
Local lLog008		:= .F.
Local lLog009		:= .F.
Local lVoltaSaldo	:= .F.
Local aSaldos		:= {}
Local aDados		:= {}
Local cFilCZJ := xFilial("CZJ")

//Atualiza o log de processamento
ProcLogAtu("MENSAGEM","Iniciando montagem do Log MRP","Iniciando montagem do Log MRP")

cQuery := " SELECT CZJ.CZJ_PROD, " +;
                 " CZK.CZK_PERMRP, " +;
                 " CZK.CZK_QTSLES, " +;
                 " CZK.CZK_QTENTR, " +;
                 " CZK.CZK_QTSAID, " +;
                 " CZK.CZK_QTSEST, " +;
                 " CZK.CZK_QTSALD, " +;
                 " CZK.CZK_QTNECE, " +;
                 " SB1.B1_EMIN, " +;
                 " SB1.B1_EMAX, " +;
                 " CZJ.R_E_C_N_O_ CZJREC " +;
            " FROM " + RetSqlName("CZJ") + " CZJ, " +;
                       RetSqlName("CZK") + " CZK, " +;
                       RetSqlName("SB1") + " SB1 " +;
           " WHERE CZJ.CZJ_FILIAL   = '" + cFilCZJ + "' " +;
             " AND CZK.CZK_FILIAL   = '" + xFilial("CZK") + "' " +;
             " AND SB1.B1_FILIAL    = '" + xFilial("SB1") + "' " +;
             " AND SB1.D_E_L_E_T_ = ' ' " +;
             " AND CZJ.R_E_C_N_O_   = CZK.CZK_RGCZJ " +;
             " AND CZJ.CZJ_PROD     = SB1.B1_COD " +;
             " AND SB1.D_E_L_E_T_   = ' ' " +;
             " AND EXISTS (SELECT 1 " +;
                           " FROM " + RetSqlName("CZK") + " CZKA, " +;
                          " WHERE CZKA.CZK_FILIAL   = '" + xFilial("CZK") + "' " +;
                            " AND CZKA.CZK_RGCZJ    = CZJ.R_E_C_N_O_ " +;
                            " AND (CZKA.CZK_QTNECE <> 0 " +;
                            "  OR  CZKA.CZK_QTSAID <> 0 " +;
                            "  OR  CZKA.CZK_QTSALD <> 0 " +;
                            "  OR  CZKA.CZK_QTSEST <> 0 " +;
                            "  OR  CZKA.CZK_QTENTR <> 0 " +;
                            "  OR  CZKA.CZK_QTSLES <> 0)) " +;
           " ORDER BY CZJ.R_E_C_N_O_, " +;
                    " CZK.CZK_PERMRP "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)

While !Eof()
	If nRegAnt <> (cAliasTop)->CZJREC
		If nRegAnt <> 0
			lCalcula := .T.
		Else
			nRegAnt := (cAliasTop)->CZJREC
		EndIf
	EndIf

	If !lCalcula
		AADD(aSaldos,{((cAliasTop)->CZK_QTSAID + (cAliasTop)->CZK_QTSEST),;
						(cAliasTop)->CZK_QTSALD,;
						(cAliasTop)->CZK_QTENTR,;
						(cAliasTop)->CZK_QTSLES})
		nB1Emin := (cAliasTop)->B1_EMIN
		nB1Emax := (cAliasTop)->B1_EMAX
		dbSkip()
	EndIf

	If lCalcula .Or. Eof()
		lLog008 := .T.
		lLog009 := .T.
		lCalcula := .F.
		CZJ->(dbGoto(nRegAnt))

		For nz := 1 to Len(aPeriodos)
			If nz <= Len(aSaldos)
				nSaldo := aSaldos[nz,2]

				If QtdComp(nSaldo) > QtdComp(0)
					//Reativa a exibicao do log pois o saldo voltou
					If nSaldo > nB1Emin
						lLog009 := .T.
					EndIf

					//Verifica se atingiu ponto de pedido
					If lLog009 .And. nB1Emin > 0 .And. QtdComp(nSaldo) <= QtdComp(nB1Emin)
						A712CriaLOG("009",CZJ->CZJ_PROD,{nB1Emin,nSaldo,aPeriodos[nz],"SB1"},lLogMRP,c711NumMrp)
						//Desativa a exibicao do log para os periodos seguintes.
						lLog009 := .F.
					EndIf

					//Reativa a exibicao do log pois o saldo voltou
					If nSaldo <= nB1Emax
						lLog008 := .T.
					EndIf

					//Verifica se atingiu estoque maximo
					If lLog008 .And. nB1Emax > 0 .And. QtdComp(nSaldo) > QtdComp(nB1Emax)
						A712CriaLOG("008",CZJ->CZJ_PROD,{nB1Emax,nSaldo,aPeriodos[nz],"SB1"},lLogMRP,c711NumMrp)
						lLog008 := .F.
					EndIf

					//Le os movimentos e grava as quantidades de maneira analitica no array aDados
					aDados:={}
					dbSelectArea("CZI")
					dbSetOrder(5)

					If dbSeek(cFilCZJ+CZJ->CZJ_PROD+CZJ->CZJ_OPCORD+CZJ->CZJ_NRRV+StrZero(nz,3))
						While !Eof() .AND. cFilCZJ+CZJ->CZJ_PROD+CZJ->CZJ_OPCORD+CZJ->CZJ_NRRV+StrZero(nz,3)+"2" == xFilial("CZI")+CZI_PROD+CZI_OPCORD+CZI_NRRV+CZI_PERMRP+CZI_TPRG							// ARRAY CONTENDO QUANTIDADE, REGISTRO E IDENTIFICADOR SE JA FOI MARCADO
							//PARA ATRASO
							AADD(aDados,{CZI_QUANT,Recno(),.F.,CZI_DTOG,.F.})
							dbSkip()
						End

						//Ordena registros pela quantidade
						ASORT(aDados,,,{|x,y| x[4] < y[4]})
					EndIf

					For z := nz + 1 To Len(aPeriodos)
						//Pega a qtd. de entradas acumuladas no per�odo.
						nQtdEnt := 0
						For nInd := nZ To z
							nQtdEnt += QtdComp(aSaldos[nInd,3])
						Next nInd
						//Se tem saida verifica quais movimentos podem ser atrasados
						While (QtdComp(aSaldos[z,1]) > QtdComp(0)) .And. (QtdComp(nQtdEnt) > QtdComp(0))
							//Primeiro desconta a qtd. de saldo inicial.
							If aSaldos[1,4] > 0
								If QtdComp(aSaldos[1,4]) < QtdComp(aSaldos[z,1])
									aSaldos[z,1] -= aSaldos[1,4]
									aSaldos[1,4] := 0
								Else
									//Zerou a sa�da com o saldo atual.
									aSaldos[1,4] -= aSaldos[z,1]
									aSaldos[z,1] := 0
									Loop
								EndIf
							EndIf
							nAcho := Ascan(aDados,{|x| x[3] == .F. /*.And. x[1] <= aSaldos[z,1]*/})

							If nAcho > 0
								CZI->(dbGoto(aDados[nAcho,2]))
								If !aDados[nAcho,5] //Verifica se j� foi gerado LOG do documento. Se sim, apenas atualiza as quantidades.
									A712CriaLOG("002",CZI->CZI_PROD,{CZI->CZI_DTOG,CZI->CZI_DOC,CZI->CZI_ITEM,CZI->CZI_ALIAS,aPeriodos[z]},lLogMRP,c711NumMrp)
								EndIf
								If aDados[nAcho,1] > aSaldos[z,1]
									//Se a qtd. do documento � maior que a necessidade do per�odo, desconta a qtd. do documento.
									aDados[nAcho,1] -= aSaldos[z,1]
									aDados[nAcho,5] := .T.
									aSaldos[nz,3]   -= aSaldos[z,1]
									aSaldos[z,1]    := 0
								Else
									aSaldos[z,1]  -= aDados[nAcho,1]
									aSaldos[nz,3] -= aDados[nAcho,1]
									aDados[nAcho,5] := .T.
									aDados[nAcho,3] := .T.
								EndIf
							Else
								Exit
							EndIf
						End
					Next z

					//Verifica todos movimentos que podem ser cancelados pois nao tem saida subsequente
					If QtdComp(nSaldo) > QtdComp(0)
						While .T.
							lVoltaSaldo := .F.
							nAcho := Ascan(aDados,{|x| x[3] == .F. .And. x[5] == .F.})

							If nAcho > 0
								aDados[nAcho,3] := .T.
								aDados[nAcho,5] := .T.

								If QtdComp(aDados[nAcho,1]) <= QtdComp(nSaldo)
									CZI->(dbGoto(aDados[nAcho,2]))

									//Verifica se existe necessidade anterior ao periodo
									For z := nz to 1 Step -1
										If QtdComp(aSaldos[z,2]) < QtdComp(0)
											lVoltaSaldo := .T.
											A712CriaLOG("003",CZI->CZI_PROD,{CZI->CZI_DTOG,CZI->CZI_DOC,CZI->CZI_ITEM,CZI->CZI_ALIAS,aPeriodos[z]},lLogMRP,c711NumMrp)
										EndIf
									Next z

									//Caso nao tenha necessidade anterior ao periodo identifica que evento pode ser cancelado
									If !lVoltaSaldo
										A712CriaLOG("007",CZI->CZI_PROD,{CZI->CZI_DTOG,CZI->CZI_DOC,CZI->CZI_ITEM,CZI->CZI_ALIAS},lLogMRP,c711NumMrp)
									EndIf

									//Retira o saldo de todos os periodos subsequentes
									For z := nz to Len(aSaldos)
										aSaldos[z,2]-=aDados[nAcho,1]
									Next z

									//Retira o saldo
									nSaldo-=aDados[nAcho,1]
								EndIf
							Else
								Exit
							EndIf
						End
					EndIf
				EndIf
			EndIf
		Next nz

		DbSelectArea(cAliasTop)

		nRegAnt := (cAliasTop)->CZJREC
		aSaldos := {}

		AADD(aSaldos,{((cAliasTop)->CZK_QTSAID + (cAliasTop)->CZK_QTSEST),;
						(cAliasTop)->CZK_QTSALD,;
						(cAliasTop)->CZK_QTENTR,;
						(cAliasTop)->CZK_QTSLES})
		nB1Emin := (cAliasTop)->B1_EMIN
		nB1Emax := (cAliasTop)->B1_EMAX
		dbSkip()
	EndIf
End

(cAliasTop)->(dbCloseArea())

//Atualiza o log de processamento
ProcLogAtu("MENSAGEM","Termino da montagem do Log MRP","Termino da montagem do Log MRP")

Return

/*-------------------------------------------------------------------------/
//Programa:	A712ShLog
//Autor:		Rodrigo A Sartorio
//Data:		15/09/03
//Descricao:	Mostra os dados do LOG do MRP para o produto posicionado
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712ShLog()
Local aArea		:= GetArea()
Local cProduto	:= Iif(Empty(nPos),Space(15),aDbTree[nPos,1])
Local cCadastro	:= OemToAnsi(STR0019) //"Log de eventos do MRP"
Local oDlg
Local oGetd
Local aObjects   := {}
Local aPosObj    := {}
Local aSize      := MsAdvSize()
Local aInfo      := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local cSeek      := xFilial("SHG")+c711NumMRP
Local bSeekWhile := { || SHG->HG_FILIAL+SHG->HG_SEQMRP } //Condicao While para montar o aCols
Local aNoFields  := {}
Local cCargo	 := ""
Local nPos	     := 0	
Private aHeader  := {}
Private aCols    := {}
Private aRotina  := {{ "","",0,1},; //"Pesquisar"
						{ "","",0,2}}  //"Visualizar"


Default lAutomacao  := .F.

If !lAutomacao
	cCargo		:= oTreeM711:GetCargo()
	nPos	    := AsCan(aDbTree,{|x| x[7]==SubStr(cCargo,3,12)})
EndIf

//Verifica se consulta LOG total ou do produto
If !Empty(cProduto) .And. (Substr(cCargo,1,2) <> "00")
	aNoFields  := {"HG_COD"}
	cCadastro  += " - "+cProduto
	cSeek      += cProduto
	bSeekWhile := { || SHG->HG_FILIAL+SHG->HG_SEQMRP+SHG->HG_COD }
EndIf

//Sintaxe da FillGetDados(/*nOpcX*/,/*Alias*/,/*nOrdem*/,/*cSeek*/,/*bSeekWhile*/,/*uSeekFor*/,/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,/*lEmpty*/,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/) |
FillGetDados(1,'SHG',1,cSeek,bSeekWhile,,aNoFields,,,,,,,,,)

//Caso possua informacoes apresenta GETDADOS com as Informa�oes
If Len(aCols) > 0
	// Array com objetos utilizados
	AADD(aObjects,{70,70,.T.,.T.,.F.})
	aPosObj:=MsObjSize(aInfo,aObjects)
	If !lAutomacao
		DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
		oGetd := MsGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],1)
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})
	EndIf
EndIf

RestArea(aArea)

Return

//---------------------------------------------------------------/
// fun��o para retornar a data fim a ser considerar no MRP
// Autor: Lucas Pereira
// Data: 20/02/2014
// Uso: M712JCTB
//---------------------------------------------------------------/
Static Function MATA712DtF()
Local dFimProj

If Len(aPeriodos) > 1 .And. nTipo # 1 .And. nTipo # 7 .And. nTipo # 2 .And. nTipo # 3

	IF nTipo == 4
		dFimProj := LastDay(aPeriodos[Len(aPeriodos)])
	Else
		dFimProj := aPeriodos[Len(aPeriodos)] + (aPeriodos[Len(aPeriodos)] - aPeriodos[Len(aPeriodos)-1])
	Endif

	If nTipo == 4 .And. Month(dFimProj-30)==2
		nSomaDia := 30- Day(CTOD("01/03/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)-1]),4),3,2))-1)
		dFimProj := aPeriodos[Len(aPeriodos)] + (aPeriodos[Len(aPeriodos)] - aPeriodos[Len(aPeriodos)-1])+nSomaDia
	EndIf
Else
	If nTipo == 1 .or. nTipo == 7		// Projecao Diaria ou Periodos Variaveis
		dFimProj := aPeriodos[Len(aPeriodos)]
	ElseIf nTipo == 2	// Projecao Semanal
		IF aPergs711[12] != 1
			dFimProj := aPeriodos[Len(aPeriodos)] + 4
		Else
			dFimProj := aPeriodos[Len(aPeriodos)] + 6
		EndIF

	ElseIf nTipo == 3	// Projecao Quinzenal
		dFimProj := CtoD(If(Substr(DtoC(aPeriodos[Len(aPeriodos)]),1,2)="01","15"+Substr(DtoC(aPeriodos[Len(aPeriodos)]),3,6),;
			"01/"+If(Month(aPeriodos[Len(aPeriodos)])+1<=12,StrZero(Month(aPeriodos[Len(aPeriodos)])+1,2)+"/"+;
			SubStr(DtoC(aPeriodos[Len(aPeriodos)]),7,4),"01/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)])+1,4),3,2))),"ddmmyy")
	ElseIf nTipo == 4	// Projecao Mensal
		dFimProj := CtoD("01/"+If(Month(aPeriodos[Len(aPeriodos)])+1<=12,StrZero(Month(aPeriodos[Len(aPeriodos)])+1,2)+;
			"/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)]),4),3,2),"01/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)])+1,4),3,2)),"ddmmyy")
	ElseIf nTipo == 5	// Projecao Trimestral
		dFimProj := CtoD("01/"+If(Month(aPeriodos[Len(aPeriodos)])+3<=12,StrZero(Month(aPeriodos[Len(aPeriodos)])+3,2)+;
			"/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)]),4),3,2),"01/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)])+1,4),3,2)),"ddmmyy")
	ElseIf nTipo == 6	// Projecao Semestral
		dFimProj := CtoD("01/"+If(Month(aPeriodos[Len(aPeriodos)])+6<=12,StrZero(Month(aPeriodos[Len(aPeriodos)])+6,2)+;
			"/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)]),4),3,2),"01/"+Substr(Str(Year(aPeriodos[Len(aPeriodos)])+1,4),3,2)),"ddmmyy")
	EndIf
EndIf

Return dFimProj

/*-------------------------------------------------------------------------/
//Programa:	CA711Troca
//Autor:		Rodrigo de Almeida Sartorio
//Data:		21/08/02
//Descricao:	Troca marcador entre x e branco
//Parametros:	nIt        Linha onde o click do mouse ocorreu
//				aArray     Array com as opcoes para selecao
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function CA711Troca(nIt,aArray)
aArray[nIt,1] := !aArray[nIt,1]
Return aArray

/*-------------------------------------------------------------------------/
//Programa:	A712ExpTre
//Autor:		Erike Yuri da Silva
//Data:		24/04/07
//Descricao:	Rotina que expande o no  do produto corrente no tree
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function A712ExpTre()

Local cProdExpl	:= CriaVar("CZI_PROD",.F.)
Local cOpcExpl	:= CriaVar("CZI_OPCORD",.F.)
Local cRevisao	:= CriaVar("CZI_NRRV",.F.)
Local nI         	:= 0
Local aDadosEnvio	:= {}
Local cAliasTop	:= "EXPTREE"
Local cOldCargo	:= ""
Local nRecno    := 0
 
Default lAutomacao := .F.

If !lAutomacao
	cOldCargo := oTreeM711:GetCargo() 
	nRecno    := Val(SubStr(cOldCargo,3,12))
EndIf

//Possiciona array do tree
If nRecno > 0
	//Posiciona no registro correto
	DbSelectArea("CZI")
	DbSetOrder(5)
	DbGoto(nRecno)

 	cProdExpl	:= CZI_PROD
	cOpcExpl	:= CZI_OPCORD
	cRevisao	:= CZI_NRRV

	cQuery := " SELECT DISTINCT CZI_PROD, " +;
	                          " CZI_OPCORD, " +;
	                          " CZI_NRRV, " +;
	                          " CZI_PERMRP, " +;
	                          " CZI_ALIAS, " +;
	                          " CZI_QUANT, " +;
	                          " CZI_DOC, " +;
	                          " CZI_TPRG, " +;
	                          " CZI_DOCREV, " +;
	                          " CZI_NRRGAL, " +;
	                          " CZI_FILIAL, " +;
	                          " CZI.R_E_C_N_O_ CZIREC " +;
                " FROM " + RetSqlName("CZI") + " CZI " +;
               " WHERE CZI.CZI_FILIAL   = '" + xFilial("CZI") + "' " +;
                 " AND CZI_PROD         = '" + cProdExpl + "' " +;
                 " AND CZI_OPCORD       = '" + cOpcExpl + "' " +;
                 " AND CZI_NRRV         = '" + cRevisao + "' " +;
               " ORDER BY CZI_FILIAL, " +;
                        " CZI_PROD, " +;
                        " CZI_OPCORD, " +;
                        " CZI_NRRV, " +;
                        " CZI_ALIAS, " +;
                        " CZI_NRRGAL "

	cQuery := ChangeQuery(cQuery)

 	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	dbSelectArea(cAliasTop)

	//Zera os valores para recalculo do produto posicionado
	While (cAliasTop)->(!Eof() .And. CZI_PROD+CZI_OPCORD+CZI_NRRV == cProdExpl+cOpcExpl+cRevisao)
		For nI := 1 to Len(aTotais)
			nAchouTot := ASCAN(aTotais[nI],{|x| x[1] == CZI_PROD+CZI_OPCORD+CZI_NRRV .And. x[2] == CZI_PERMRP .And. x[3] == CZI_ALIAS})
			If nAchouTot != 0
				aTotais[nI,nAchouTot,4] := 0
				Exit
			EndIf
		Next nI
		(cAliasTop)->(DbSkip())
	Enddo

	dbGoTop()

	//Alimenta Tree somente para o produto posicionado
	While (cAliasTop)->(!Eof() .And. CZI_PROD+CZI_OPCORD+CZI_NRRV == cProdExpl+cOpcExpl+cRevisao)
		//Adiciona registro em array totalizador utilizado no TREE  �
		If Len(aTotais[Len(aTotais)]) > 4095
			AADD(aTotais,{})
		EndIf
		For nI := 1 to Len(aTotais)
			nAchouTot := ASCAN(aTotais[nI],{|x| x[1] == CZI_PROD+CZI_OPCORD+CZI_NRRV .And. x[2] == CZI_PERMRP .And. x[3] == CZI_ALIAS})
			If nAchouTot != 0
				aTotais[nI,nAchouTot,4] += CZI_QUANT
				Exit
			EndIf
		Next i
		If nAchouTot ==0
			AADD(aTotais[Len(aTotais)],{CZI_PROD+CZI_OPCORD+CZI_NRRV,CZI_PERMRP,CZI_ALIAS,CZI_QUANT})
		EndIf
		// Estrutura do array
		// Produto
		// Opcional
		// Revisao
		// Alias
		// Tipo
		// Documento
		// Recno
		// DocRev
		//                  01              02          03               04             05         06           07                         08
		AADD(aDadosEnvio,{(cAliasTop)->CZI_PROD,(cAliasTop)->CZI_OPCORD,(cAliasTop)->CZI_NRRV,(cAliasTop)->CZI_ALIAS,(cAliasTop)->CZI_TPRG,(cAliasTop)->CZI_DOC,StrZero((cAliasTop)->CZIREC,12),(cAliasTop)->CZI_DOCREV})
		(cAliasTop)->(DbSkip())
	End

	(cAliasTop)->(dbCloseArea())
EndIf
A712AdTree(.F.,aDadosEnvio,.F.)
Return

/*-------------------------------------------------------------------------/
//Fun��o:	 A712RetVld
//Autor:	 Ricardo Prandi
//Data:		 28/09/2015
//Descricao: Retorna a quantidade no periodo conforme o tipo informado
//Uso: 		 MATA650
//------------------------------------------------------------------------*/
Static Function A712RetVld(cProduto, dEntrega, cTipo)

Local cPeriodo := A650DtoPer(dEntrega)
Local aSavAre  := GetArea()
Local nNeces   := 0

CZJ->(dbSetOrder(1))

If CZJ->(dbSeek(xFilial("CZJ")+cProduto))
	CZK->(dbSetOrder(1))

	If CZK->(dbSeek(xFilial("CZK")+STR(CZJ->(RecNo()),10)+cPeriodo))
		Do Case
			Case cTipo == '1'
				nNeces := CZK->CZK_QTSLES
			Case cTipo == '2'
				nNeces := CZK->CZK_QTENTR
			Case cTipo == '3'
				nNeces := CZK->CZK_QTSAID
			Case cTipo == '4'
				nNeces := CZK->CZK_QTSEST
			Case cTipo == '5'
				nNeces := CZK->CZK_QTSALD
			Case cTipo == '6'
				nNeces := CZK->CZK_QTNECE
		End Case
	EndIf
EndIf

RestArea(aSavAre)

Return(nNeces)

/*-------------------------------------------------------------------------/
//Fun��o:	 A712ShAlt
//Autor:	 Nilton MK
//Data:		 11/06/2012
//Descricao: Mostra produtos alternativos
//Uso: 		 MATA712
//------------------------------------------------------------------------*/
Static Function A712ShAlt()
Local nPos	   := AsCan(aDbTree,{|x| x[7]==SubStr(oTreeM711:GetCargo(),3,12)})
Local cProduto := IIf(Empty(nPos),Space(15),aDbTree[nPos,1])
Local aArea    := GetArea()

Local oDlg,oBold,oListBox
Local aViewSGI:= {}

Local cFilSGI := xFilial("SGI")

dbSelectArea("SGI")
dbSetOrder(1)
If MSSeek(cFilSGI+cProduto)
	While !Eof() .And. GI_FILIAL+GI_PRODORI == cFilSGI+cProduto
	    aadd(aViewSGI,{SGI->GI_PRODORI,GI_PRODALT,GI_FATOR,GI_MRP})
		dbSkip()
	Enddo
EndIf

If Empty(aViewSGI)
	Aviso(STR0171 ,STR0172,{STR0173},2)
Else
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg FROM 000,000  TO 250,400 TITLE STR0174 +cProduto Of oMainWnd PIXEL //"Lista de produtos alternativos de "
		oListBox := TWBrowse():New( 25,2,200,69,,{RetTitle("GI_PRODORI"),RetTitle("GI_PRODALT"),RetTitle("GI_FATOR"),RetTitle("GI_MRP"),,,},{17,55,55,55,55,55},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oListBox:SetArray(aViewSGI)
		oListBox:bLine := { || aViewSGI[oListBox:nAT]}
		@ 110,144  BUTTON STR0109 SIZE 045,010  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL   //"Voltar"
	ACTIVATE MSDIALOG oDlg CENTERED
EndIf

RestArea(aArea)

RETURN


/*-------------------------------------------------------------------------/
//{Protheus.doc} A712OpcDft
// Busca o opcional default do produto (B1_OPC/B1_MOPC)

@author lucas.franca
@since 01/02/2018
@param cProduto	- C�digo do produto para buscar os opcionais
@param aOpc		- Array com os opcionais preenchidos do produto. aOpc[1] -> B1_OPC, aOpc[2] -> B1_MOPC
@return aOpc	- Array com os opcionais default do produto. aOpc[1] -> B1_OPC, aOpc[2] -> B1_MOPC
@version 1.0
//------------------------------------------------------------------------*/
Static Function A712OpcDft(cProduto,aOpc)
	Local aArea   := GetArea()
	Local aAreaB1 := SB1->(GetArea())

	Default aOpc := {Nil,Nil}

	//Se n�o tiver nenhum opcional informado, busca o opcional default do produto.
	//Se existir opcional default na SB1, ele ser� considerado.
	If Empty(aOpc[1]) .And. Empty(aOpc[2])
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+cProduto))
			If !Empty(SB1->B1_OPC) .Or. !Empty(SB1->B1_MOPC)
				aOpc := {SB1->B1_OPC,SB1->B1_MOPC}
			EndIf
		EndIf
	EndIf

	SB1->(RestArea(aAreaB1))
	RestArea(aArea)
Return aOpc


/*-------------------------------------------------------------------------/
//{Protheus.doc} M712FilGen
// Ativa e define o filtro de produtos
@since 09/04/2018
@version 1.0
//------------------------------------------------------------------------*/
Static Function M712FilGen()
Local cFilSB1	 := ""
Local aProdAux	 := {}
Local lContinua	 := .T.
Local cExpFiltro := ""

Default lAutomacao := .F.

If !lAutomacao
	cExpFiltro := SB1->(BuildExpr("SB1") )
EndIf

cFilQryCZI := " AND 1 = 1"
cFilTabCZI := "1 = 1"

If Empty(cExpFiltro)
	//Restaura situalcao anterior
	If Empty(cFilSB1Old)
		SB1->(DBClearFilter())
	Else
		SB1->(DBClearFilter())
		SB1->(dbSetFilter({|| &cFilSB1Old}, cFilSB1Old))
	EndIf
	CZI->(DBClearFilter())
	MT712Tree(aPergs711[28]==1,/*02*/,/*.T.*/)
	lAtvFilNes	:= .F.
	lContinua	:= .F.
EndIf

If lContinua
	SB1->(dbSetFilter({|| &cExpFiltro}, cExpFiltro))
	SB1->(DbGotop())
	While SB1->(!Eof())
		If Empty(AsCan(aProdAux,{|x| x == SB1->B1_COD}))
			Aadd(aProdAux,SB1->B1_COD)
			cFilSB1 += SB1->B1_COD+"|"
		EndIf
		SB1->(DbSkip())
	EndDo

	//Restaura situacao anterior
	If Empty(cFilSB1Old)
		SB1->(DBClearFilter())
	Else
		SB1->(DBClearFilter())
		SB1->(dbSetFilter({|| &cFilSB1Old}, cFilSB1Old))
	EndIf
EndIf

If lContinua .And. Empty(aProdAux)
	lContinua := .F.
EndIf

If lContinua
	//Filtra a tabela CZIcom base na tabela SB1.
	cFilTabCZI := " CZI->CZI_PROD $ ('"+cFilSB1+"')"

	cFilQryCZI := " AND CZI.CZI_PROD IN ('" + StrTran(cFilSB1,"|","','") + ")"
	cFilQryCZI := StrTran(cFilQryCZI,",')",")")

	//CZI->(dbSetFilter({|| &cFilCZI}, cFilCZI))
	MT712Tree(aPergs711[28]==1,,)
EndIf
If !lAutomacao
	oTreeM711:TreeSeek("")
	Eval(oTreeM711:bChange)
EndIf

Return

/*-------------------------------------------------------------------------/
//{Protheus.doc} MT712Autom
// Seta o valor da FLAG, para identificar que o MRP est� sendo executado pela automa��o de testes (ADVPR)
@param lFlag	- L�gico. .T. - Execu��o pela automa��o de testes. .F. - Execu��o padr�o.
@author lucas.franca
@since 27/04/2018
@version 1.0
/-------------------------------------------------------------------------*/
Static Function MT712Autom(lFlag)
	//Limpa as vari�veis est�ticas do fonte MATA712, para garantir a integridade da automa��o.
	clrStatic()
	lIsADVPR := lFlag
Return

/*-------------------------------------------------------------------------/
//{Protheus.doc} MT712ADVPR
// Retorna a FLAG para identificar se o MRP est� sendo executado pela automa��o de testes (ADVPR)
@author lucas.franca
@since 27/04/2018
@return lIsAdvpr	- L�gico. Se .T., o MRP est� sendo executado pela automa��o de testes (ADVPR)
@version 1.0
/-------------------------------------------------------------------------*/
Static Function MT712ADVPR()
Return Iif(lIsADVPR==Nil,.F.,lIsADVPR)

/*-------------------------------------------------------------------------/
//{Protheus.doc} MT712VLOPC
//VALIDA SE TEM OPCIONAS E SE OPCIONAIS ESTA COMO OBRIGATORIO
--copiado fo fonte sigacusb.prx funcao e adaptado para fun��o MT712VLOPC
@author thiago.zoppi
@since 10/05/2018
@version 1.0
/-------------------------------------------------------------------------*/
Static Function MT712VLOPC(cProduto,cRet,aRetorOpc,cProdPai,cProdAnt,cProg,cOpcMarc,lVisual,nNivel,nQtd,dDataVal,cRevisao,lPreEstr)

	Local aArea		:=GetArea()

	Local nAcho		:=0
	Local nString	:=0
	Local nOpca		:=1
	Local aGrupos	:={}
	Local aRegs		:={}
	Local cOpcionais:="" // Variavel utilizada para retorno da string
	Local nTamDif	:=(Len(SGA->GA_OPC)+Len(SGA->GA_DESCOPC)+13)-(Len(SGA->GA_GROPC)+Len(SGA->GA_DESCGRP)+3)
	Local lOpcPadrao:= SuperGetMV("MV_REPGOPC",.F.,"N") == "N"

	Local aOpcionais	:={}
	Local aOpcionAUX 	:={}
	Local nQuantItem	:= 1
	Local cOpcSele 		:= ""
	Local cOpcComp 		:= ""
	Local cOpcDefa 		:= ""
	Local lOpcDefa 		:= .F.

	Default cProg 	 :=""
	Default cOpcMarc :=""
	Default lVisual  :=.F.
	Default nQtd     :=0
	Default dDataVal :=dDataBase
	Default lPreEstr :=.F.

	cProduto := PadR(cProduto,Len(SB1->B1_COD))

	//�������������������������������������������������������������������������Ŀ
	//� Caso nao exista cria array que registra todos os niveis da estrutura    �
	//���������������������������������������������������������������������������
	If Type("aRetorOpc") <> "A"
		aRetorOpc:={}
	EndIf

	//�������������������������������������������������������������Ŀ
	//� Estrutura do array dos opcionais                            �
	//���������������������������������������������������������������
	// 1 Marcado (.T. ou .F.)
	// 2 Titulo("0") ou Item("1")
	// 3 Item Opcional+Descricao Opcional
	// 4 Grupo de Opcionais
	// 5 Registro no SG1
	// 6 Nivel no SG1
	// 7 Recno do SG1
	// 8 Componente Ok (.T.) ou Vencido (.F.)
	// 9 Codigo do componente
	//10 Default ?

	If Empty(cOpcDefa)
		dbSelectArea("SB1")
		dbSetOrder(1)
		lAchouB1 := MsSeek(xFilial("SB1")+cProduto)
		If lAchouB1
			cOpcDefa := SB1->B1_OPC
		EndIf
	EndIf

	//�������������������������������������������������������������Ŀ
	//� Varre a estrutura do produto                                �
	//���������������������������������������������������������������
	dbSelectArea(IIf(lPreEstr,"SGG","SG1"))
	dbSetOrder(1)
	dbSeek(xFilial()+cProduto)
	Do While !Eof() .And. IIf(lPreEstr,SGG->GG_FILIAL+SGG->GG_COD == xFilial("SGG")+cProduto,SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+cProduto)
		If !Empty(IIf(lPreEstr,SGG->GG_GROPC,SG1->G1_GROPC)) .And. !Empty(IIf(lPreEstr,SGG->GG_OPC,SG1->G1_OPC))

			cOpcArq := If(lPreEstr,SGG->GG_GROPC+SGG->GG_OPC,SG1->G1_GROPC+SG1->G1_OPC)

			If (!Empty(cOpcDefa) .And. !Empty(cOpcArq) .And. !(cOpcArq $ cOpcDefa)) .Or. (Empty(cOpcDefa) .Or. Empty(cOpcArq))
				lOpcDefa := .F.
			Else
				lOpcDefa := .T.
			EndIf

			// Caso ja tenha opcionais preenchidos, pesquisa se nao � o grupo
			// atual
			If !Empty(cRet)
				// Verifica se � a primeira posicao
				If Substr(cRet,1,Len(SGA->GA_GROPC)) == IIf(lPreEstr,SGG->GG_GROPC,SG1->G1_GROPC)
					nString:=1
				Else
					// Procura grupo no campo de opcionais default
					nString:=AT("/"+IIf(lPreEstr,SGG->GG_GROPC,SG1->G1_GROPC),cRet)
				EndIf
				If nString > 0 .And. lOpcPadrao
					cOpcSele := SubStr(cRet,Iif(nString==1,1,nString+1),Len(SGA->GA_GROPC)+Len(SGA->GA_OPC))
					cOpcComp := IIf(lPreEstr,SGG->GG_GROPC+SGG->GG_OPC,SG1->G1_GROPC+SG1->G1_OPC)

					//somente incluir se o opcional do componente for o opcional selecionado
					If cOpcSele == cOpcComp
						If SGA->(dbSeek(xFilial("SGA")+IIf(lPreEstr,SGG->GG_GROPC+SGG->GG_OPC,SG1->G1_GROPC+SG1->G1_OPC)))
							// Verifica se o grupo ja foi incluido
							nAcho:=ASCAN(aGrupos,IIf(lPreEstr,SGG->GG_GROPC,SG1->G1_GROPC))
							//Valida datas e revisao
							If !Empty(nQtd)
								nQuantItem := Round(ExplEstr(nQtd,dDataVal,"",cRevisao,,lPreEstr,,,,,,.T.,.F.),TamSX3("D4_QUANT")[2])
							EndIf
							If nAcho == 0
								AADD(aGrupos,IIf(lPreEstr,SGG->GG_GROPC,SG1->G1_GROPC))
								// Adiciona titulo ao array
								AADD(aOpcionAUX,{.F.,"0",SGA->GA_GROPC+" - "+SGA->GA_DESCGRP+Space(nTamDif),SGA->GA_GROPC,SGA->(Recno()),IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),QtdComp(nQuantItem)>QtdComp(0),IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP),lOpcDefa})
							EndIf

							// Verifica se o grupo ja foi digitado neste nivel
							nAcho:=ASCAN(aOpcionAUX,{ |x| x[2] == "1" .And. x[4] == SGA->GA_GROPC .And. x[5] == SGA->(Recno())})
							If nAcho == 0
								// Adiciona item ao array
								AADD(aOpcionAUX,{.T.,;
								"1",;
								SGA->GA_OPC+" - "+SGA->GA_DESCOPC,;
								SGA->GA_GROPC,;
								SGA->(Recno()),;
								IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),;
								IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),;
								QtdComp(nQuantItem)!=QtdComp(0),;
								IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP),;
								lOpcDefa})
							Else
								// Verifica se o grupo e produto ja foi digitado neste nivel
								nAcho:=ASCAN(aOpcionAUX,{ |x| x[2] == "1" .And. x[4] == SGA->GA_GROPC .And. x[5] == SGA->(Recno()) .And. x[9] == SG1->G1_COMP })
								If nAcho == 0
									// Adiciona item ao array
									If SG1->G1_INI > dDataBase .Or. SG1->G1_FIM < dDataBase
										AADD(aOpcionAUX,{.T.,"1",SGA->GA_OPC+" - "+SGA->GA_DESCOPC,SGA->GA_GROPC,SGA->(Recno()),IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),QtdComp(nQuantItem,.T.)>QtdComp(0,.T.),IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP),lOpcDefa})
									Else
										AADD(aOpcionAUX,{.T.,"1",SGA->GA_OPC+" - "+SGA->GA_DESCOPC,SGA->GA_GROPC,SGA->(Recno()),IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),.T.,IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP),lOpcDefa})
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
					dbSkip()
					Loop
				EndIf
			EndIf
			If SGA->(dbSeek(xFilial("SGA")+IIf(lPreEstr,SGG->GG_GROPC+SGG->GG_OPC,SG1->G1_GROPC+SG1->G1_OPC)))

				// Verifica se o grupo ja foi incluido
				nAcho:=ASCAN(aGrupos,IIf(lPreEstr,SGG->GG_GROPC,SG1->G1_GROPC))
				//Valida datas e revisao
				If !Empty(nQtd)
					nQuantItem := Round(ExplEstr(nQtd,dDataVal,"",cRevisao,,lPreEstr,,,,,,.T.,.F.),TamSX3("D4_QUANT")[2])
				EndIf
				If nAcho == 0
					AADD(aGrupos,IIf(lPreEstr,SGG->GG_GROPC,SG1->G1_GROPC))
					// Adiciona titulo ao array
					AADD(aOpcionais,;
						{.F.,;
						"0",;
						SGA->GA_GROPC+" - "+SGA->GA_DESCGRP+Space(nTamDif),;
						SGA->GA_GROPC,;
						SGA->(Recno()),;
						IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),;
						IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),;
						QtdComp(nQuantItem)!=QtdComp(0),;
						IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP),;
						lOpcDefa})
					AADD(aOpcionAUX,aClone(aTail(aOpcionais)))
				EndIf

				// Verifica se o grupo ja foi digitado neste nivel
				nAcho:=ASCAN(aOpcionais,{ |x| x[2] == "1" .And. x[4] == SGA->GA_GROPC .And. x[5] == SGA->(Recno())})
				If nAcho == 0
					// Adiciona item ao array
					AADD(aOpcionais,{OpcSelec(cOpcMarc, SGA->GA_GROPC+SGA->GA_OPC, cProdAnt, IIf(lPreEstr,SGG->GG_COMP+SGG->GG_TRT,SG1->G1_COMP+SG1->G1_TRT)),;
					"1",;
					SGA->GA_OPC+" - "+SGA->GA_DESCOPC,;
					SGA->GA_GROPC,;
					SGA->(Recno()),;
					IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),;
					IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),;
					QtdComp(nQuantItem)!=QtdComp(0),;
					IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP),;
					lOpcDefa})

					AADD(aOpcionAUX,aClone(aTail(aOpcionais)))
				Else
					// Verifica se o grupo e produto ja foi digitado neste nivel
					nAcho:=ASCAN(aOpcionAUX,{ |x| x[2] == "1" .And. x[4] == SGA->GA_GROPC .And. x[5] == SGA->(Recno()) .And. x[7] == IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())) })
					If nAcho == 0
						// Adiciona item ao array
						If SG1->G1_INI > dDataBase .Or. SG1->G1_FIM < dDataBase
							AADD(aOpcionAUX,{SGA->GA_GROPC+SGA->GA_OPC $ cOpcMarc,"1",SGA->GA_OPC+" - "+SGA->GA_DESCOPC,SGA->GA_GROPC,SGA->(Recno()),IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),QtdComp(nQuantItem,.T.)>QtdComp(0,.T.),IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP),lOpcDefa})
							nAcho:=ASCAN(aOpcionais,{ |x| x[2] == "1" .And. x[4] == SGA->GA_GROPC .And. x[5] == SGA->(Recno())})
							If nAcho > 0
								aOpcionais[nAcho,8] := .T.
							EndIf
						Else
							AADD(aOpcionAUX,{SGA->GA_GROPC+SGA->GA_OPC $ cOpcMarc,"1",SGA->GA_OPC+" - "+SGA->GA_DESCOPC,SGA->GA_GROPC,SGA->(Recno()),IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),.T.,IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP),lOpcDefa})
							nAcho:=ASCAN(aOpcionais,{ |x| x[2] == "1" .And. x[4] == SGA->GA_GROPC .And. x[5] == SGA->(Recno())})
							If nAcho > 0
								aOpcionais[nAcho,8] := .T.
							EndIf
						EndIf
					Else
						If QtdComp(nQuantItem,.T.)!=QtdComp(0,.T.)
							aOpcionAUX[nAcho,8] := .T.
							nAcho:=ASCAN(aOpcionais,{ |x| x[2] == "1" .And. x[4] == SGA->GA_GROPC .And. x[5] == SGA->(Recno())})
							If nAcho > 0
								aOpcionais[nAcho,8] := .T.
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			// Caso nao tenha opcionais neste nivel, guarda o registro para
			// pesquisar em niveis inferiores
			AADD(aRegs,{IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP)})
		EndIf
		dbSkip()
	EndDo

	If Len(aOpcionais) > 0
	nOpca:=0

		IF (ASCAN(aOpcionais,{|x| x[8]})) > 0

			If	M712OpcOk(cProduto,aOpcionais,aGrupos,@aRegs,@cOpcionais,,,cRet)
				nOpcA := 1
			Endif

		Else
			nOpcA := 1
		EndIf

	Else
		nOpcA := 1
	EndIf

	RestArea(aArea)
Return nOpcA == 1

/*-------------------------------------------------------------------------/
//{Protheus.doc} M712OpcOk
//VALIDA GRUPO NOS CAMPOS DE OPCIONAIS
--copiado do fonte sigacusb.prx e adaptado para fun��o  M712OpcOk
@author thiago.zoppi
@since 10/05/2018
@version 1.0
/-------------------------------------------------------------------------*/
Static Function M712OpcOk(cProduto,aArray,aGrupos,aRegs,cOpcionais,cProg,aOpcionAUX,cOpcMark)
LOCAL nAcho:=0,nString:=0,i
LOCAL lRet:=.T.
LOCAL cDefault:=""
Local aArea := GetArea()
Local lObrigat := .T.
Local cOpcSB1  := ""

Default cOpcMark := ""

	//�������������������������������������������������������������Ŀ
	//�Valida se todos grupos tiveram um item selecionado ou possuem�
	//�opcional default cadastrado no SB1                           �
	//���������������������������������������������������������������
	SB1->(dbSetOrder(1))
	For i:=1 to Len(aGrupos)
		lObrigat := .T.
		nAcho := IIF(ASCAN(aArray,{|x| x[4] == aGrupos[i] .And. x[8]}) != 0,ASCAN(aArray,{|x| x[4] == aGrupos[i] .And. x[1]}),1)
		// Pesquisa no array se grupo nao teve item marcado
		//nAcho:=ASCAN(aArray,{|x| x[4] == aGrupos[i] .And. x[1]})
		// Caso nao achou item marcado procura opcional default
		If nAcho == 0
			If SGA->(dbSeek(xFilial("SGA")+aGrupos[i]))
				lObrigat := Iif(SGA->GA_OBG=="0",.F.,.T.)
			EndIf

			If lObrigat .And. SB1->(dbSeek(xFilial("SB1")+cProduto))
				cOpcSB1 := Iif(Empty(SB1->B1_MOPC),SB1->B1_OPC,SB1->B1_MOPC)
				If !Empty(cOpcSB1)
					// Verifica se o grupo esta na primeira posicao
					If Substr(cOpcSB1,1,Len(SGA->GA_GROPC)) == aGrupos[i]
						nString:=1
					Else
						// Procura grupo nas posicoes seguintes
						nString:=AT("/"+aGrupos[i],cOpcSB1)
					EndIf
					If nString > 0
						nString:=IF(nString=1,1,nString+1)
						cDefault:=Substr(cOpcSB1,nString,Len(SGA->GA_GROPC+SGA->GA_OPC))
						nAcho:=0
						nAcho:=ASCAN(aArray,{|x| Substr(x[3],1,Len(SGA->GA_OPC)) == Substr(cDefault,Len(SGA->GA_GROPC)+1) })
						If nAcho > 0
							cOpcionais+=cDefault+"/"
						EndIf
					EndIf
				EndIf
				// Caso nao achou o grupo no campo de opcionais default
				If nString <=0 .Or. nAcho <= 0
					If lObrigat
						lRet := .F.
						exit
					EndIf

				EndIf
			EndIf
		 endif
	Next i


RestArea(aArea)
Return lRet

/*-------------------------------------------------------------------------/
//{Protheus.doc} a712LogEM
//Tratamento de mensagens quando tiver estoque maximo e for MultiThreads.
@author Thiago Zoppi
@since 05/06/2018
/-------------------------------------------------------------------------*/
Static Function a712LogEM (aProdutos)
local nK 		:= 0
local ny 		:= 0
local aAreaSB1	:= SB1->(GETAREA())
Local nThreads  := Len(aProdutos)

	For nK := 1 To nThreads

		IF LEN(aProdutos[nk][1]) > 1

			for ny := 1 to len(aProdutos[nk][1])

				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbseek(xFilial("SB1")+aProdutos[nK,1,ny] )

					IF SB1->B1_EMAX > 0
						ProcLogAtu("MENSAGEM", "Produto com Estoque Maximo: "+ALLTRIM(SB1->B1_COD)+' - '+" QTD: "+ALLTRIM(CVALTOCHAR(SB1->B1_EMAX)) ,;
								   "Produto com Estoque Maximo: "+SB1->B1_COD+' - '+SB1->B1_DESC+" QTD: "+CVALTOCHAR(SB1->B1_EMAX))
					EndIf

				Endif

			Next ny

		ELSE

			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbseek(xFilial("SB1")+aProdutos[nK,1,1] )

				IF SB1->B1_EMAX > 0
					ProcLogAtu("MENSAGEM", "Produto com Estoque Maximo: "+ALLTRIM(SB1->B1_COD)+' - '+" QTD: "+ALLTRIM(CVALTOCHAR(SB1->B1_EMAX)) ,;
							   "Produto com Estoque Maximo: "+SB1->B1_COD+' - '+SB1->B1_DESC+" QTD: "+CVALTOCHAR(SB1->B1_EMAX))
				EndIf

			Endif


		ENDIF


	Next nK

RestArea(aAreaSB1)

Return

/*/{Protheus.doc} gSqlPerMRP
Monta query com a l�gica para recuperar o n�mero do per�odo do MRP.

@author lucas.franca
@since 24/05/2018
@version 1.0

@param aPeriodos	- Array com os per�odos do MRP.
@param cCampoDate	- Campo que cont�m a informa��o da data. Ex: "SC1.C1_DATPRF"
@param dDatFim		- Data final a ser considerada no processamento do MRP.

@return cSqlPeriod	- Query com a l�gica para recuperar o per�odo do MRP.
/*/
Static Function gSqlPerMRP(aPeriodos, cCampoDate, dDatFim)
	Local cSqlPeriod := ""
	Local nX         := 0
	Local cSqlDate   := gSqlNxtUti(cCampoDate)

	cSqlPeriod := " CASE WHEN " + cSqlDate + " <= '" + DtoS(aPeriodos[1]) + "' THEN '001' "

	If Len(aPeriodos) >= 2
		For nX := 2 To Len(aPeriodos)
			//Verifica se a data esta entre o periodo atual e o periodo anterior, devendo assumir o periodo anterior.
			cSqlPeriod += " WHEN " + cSqlDate + " <  '" + DtoS(aPeriodos[nX]) + "' "
			cSqlPeriod +=  " AND " + cSqlDate + " >= '" + DtoS(aPeriodos[nX-1]) + "' "
			cSqlPeriod += " THEN '" + StrZero(nX-1,3) + "' "
		Next nX
	EndIf

	//Verifica se a data est� entre o �ltimo per�odo e a data final do MRP, devendo considerar o �ltimo per�odo.
	cSqlPeriod += " WHEN " + cSqlDate + " >= '" + DtoS(aPeriodos[Len(aPeriodos)]) + "' "
	cSqlPeriod +=  " AND " + cSqlDate + " <= '" + DtoS(dDatFim) + "' "
	cSqlPeriod += " THEN '" + StrZero(Len(aPeriodos),3) + "' "

	cSqlPeriod += " WHEN " + cSqlDate + " = '" + DtoS(dDatFim) + "' "
	cSqlPeriod += " THEN '" + StrZero(Len(aPeriodos),3) + "' "


	cSqlPeriod += " ELSE '   ' " //Nenhum per�odo v�lido, retorna branco.
	cSqlPeriod += " END "
Return cSqlPeriod

/*/{Protheus.doc} gSqlNxtUti
Monta query com a l�gica para recuperar o pr�ximo dia �til.
L�gica ser� utilizada quando o par�metro 12 do MRP estiver diferente de 1 (n�o considera finais de semana)

@author lucas.franca
@since 28/05/2018
@version 1.0

@param cCampoDate	- Campo que cont�m a informa��o da data. Ex: "SC1.C1_DATPRF"

@return cSqlNxtUti	- Query com a l�gica para recuperar a pr�xima data �til.
/*/
Static Function gSqlNxtUti(cCampoDate)
	Local cSqlNxtUti := ""
	Local cBanco     := AllTrim(Upper(TcGetDb()))

	If aPergs711[12] != 1
		If cBanco == "POSTGRES"
			cSqlNxtUti := " CASE WHEN extract(dow FROM TO_TIMESTAMP("+cCampoDate+",'YYYYMMDD')) = 6 "
			cSqlNxtUti +=      " THEN " + gSqlSomaDt(cCampoDate,2)
			cSqlNxtUti +=      " WHEN extract(dow FROM TO_TIMESTAMP("+cCampoDate+",'YYYYMMDD')) = 0 "
			cSqlNxtUti +=      " THEN " + gSqlSomaDt(cCampoDate,1)
			cSqlNxtUti +=      " ELSE " + cCampoDate
			cSqlNxtUti += " END "
		ElseIf cBanco == "ORACLE"
			cSqlNxtUti := " CASE WHEN TO_CHAR(TO_DATE("+cCampoDate+",'YYYYMMDD'), 'D') = 7 "
			cSqlNxtUti +=      " THEN " + gSqlSomaDt(cCampoDate,2)
			cSqlNxtUti +=      " WHEN TO_CHAR(TO_DATE("+cCampoDate+",'YYYYMMDD'), 'D') = 1 "
			cSqlNxtUti +=      " THEN " + gSqlSomaDt(cCampoDate,1)
			cSqlNxtUti +=      " ELSE " + cCampoDate
			cSqlNxtUti += " END "
		Else
			cSqlNxtUti := " CASE WHEN DATEPART(dw,"+cCampoDate+") = 7 "
			cSqlNxtUti +=      " THEN " + gSqlSomaDt(cCampoDate,2)
			cSqlNxtUti +=      " WHEN DATEPART(dw,"+cCampoDate+") = 1 "
			cSqlNxtUti +=      " THEN " + gSqlSomaDt(cCampoDate,1)
			cSqlNxtUti +=      " ELSE " + cCampoDate
			cSqlNxtUti += " END "
		EndIf
	Else
		//Se estiver parametrizado para considerar finais de semana
		//n�o precisa fazer o c�lculo da data.
		cSqlNxtUti := cCampoDate
	EndIf

Return cSqlNxtUti

/*/{Protheus.doc} gSqlSomaDt
Monta query com a l�gica para somar dias em um campo de data, que � salvo no banco de dados no formato string (AAAAMMDD).

@author lucas.franca
@since 07/06/2018
@version 1.0

@param cCampo	- Campo que cont�m a informa��o da data. Ex: "SC1.C1_DATPRF"
@param nDias	- Quantidade de dias que ser�o somados no campo de data.

@return cSqlSomaDt	- Query com a l�gica para recuperar a pr�xima data �til.
/*/
Static Function gSqlSomaDt(cCampo,nDias)
	Local cSqlSomaDt := cCampo
	Local cBanco     := AllTrim(Upper(TcGetDb()))

	If cBanco == "POSTGRES"
		cSqlSomaDt := " TO_CHAR(TO_TIMESTAMP("+cCampo+",'YYYYMMDD') + interval '"+cValToChar(nDias)+" day','YYYYMMDD') "
	ElseIf cBanco == "ORACLE"
		cSqlSomaDt := " TO_CHAR(TO_DATE("+cCampo+",'YYYYMMDD')+"+cValToChar(nDias)+",'YYYYMMDD') "
	Else
		cSqlSomaDt := " CONVERT(VARCHAR,DATEADD(dd,"+cValToChar(nDias)+",CAST("+cCampo+" AS DATE)),112) "
	EndIf

Return cSqlSomaDt

/*/{Protheus.doc} gSqlNivPrd
Monta query com a l�gica para recuperar o n�vel do produto.

@author lucas.franca
@since 25/05/2018
@version 1.0

@param cCampoProd	- Campo que cont�m a informa��o do c�digo do produto. Ex: "SC2.C2_PRODUTO"

@return cSqlNivel	- Query com a l�gica para recuperar o per�odo do MRP.
/*/
Static Function gSqlNivPrd(cCampoProd)
	Local cSqlNivel := ""

	cSqlNivel := " (SELECT CASE"
	cSqlNivel +=             " WHEN MIN(SG1.G1_NIV) < '99' THEN MIN(SG1.G1_NIV) "
	cSqlNivel +=         " ELSE '99' "
	cSqlNivel +=         " END "
	cSqlNivel +=    " FROM " + RetSqlName("SG1") + " SG1 "
	cSqlNivel +=    " WHERE SG1.G1_FILIAL  = '"+xFilial("SG1")+"'"
	cSqlNivel +=      " AND SG1.G1_COD     = " + cCampoProd
	cSqlNivel +=      " AND SG1.D_E_L_E_T_ = ' ')
Return cSqlNivel

/*/{Protheus.doc} gSqlRecno
Gera query SQL para gera��o do campo R_E_C_N_O_ das tabelas

@param cTable	- Tabela que ser� gerado a numera��o do RECNO
@param cField	- Campo da consulta para gerar o contador de registros.

@return cSqlRecno	- Query montada para busca do RECNO das tabelas.

@author lucas.franca
@since 30/05/2018
@version 1.0
@return Nil
/*/
Static Function gSqlRecno(cTable,cField)
	Local cSqlRecno := ""

	cSqlRecno += "("
	cSqlRecno += " ( " + ChangeQuery("SELECT COALESCE(MAX("+RetSqlName(cTable)+".R_E_C_N_O_),1) " +;
	                            " FROM "+RetSqlName(cTable)) + " ) "
	cSqlRecno +=              " + ROW_NUMBER() OVER ( ORDER BY "+cField+" ) "
	cSqlRecno += ") "

Return cSqlRecno

/*/{Protheus.doc} prcSldIni
Carga da tabela CZI/CZK com os saldos iniciais dos produtos.

@param cQueryB1		- Vari�vel por refer�ncia, para recuperar a query a ser utilizada nos processos da SB1.
@param lAllTp		- Identifica se foram selecionados todos os tipos de produto.
@param lAllGrp		- Identifica se foram selecionados todos os grupos de produto.
@param cAlmoxd		- Armaz�m de - para filtro dos produtos.
@param cAlmoxa		- Armaz�m at� - para filtro dos produtos.
@param aPeriodos	- Per�odos de processamento do MRP.
@param cStrTipo		- String com tipos a serem processados
@param cStrGrupo	- String com grupos a serem processados
@author lucas.franca
@since 21/05/2018
@version 1.0
@return Nil
/*/
Static Function prcSldIni(cQueryB1,lAllTp,lAllGrp,cAlmoxd,cAlmoxa,aPeriodos,cStrTipo,cStrGrupo)
	Local cQuery    := ""
	Local cInsert   := ""
	Local cArqTrb   := ""
	Local cProdAnt  := ""
	Local cNameCZK  := RetSqlName("CZK")
	Local nQtde     := 0
	Local nEstSeg   := 0
	Local cTxtSeg   := RetTitle("B1_ESTSEG")
	Local cTxtPPed  := RetTitle("B1_EMIN")
	Local cBanco    := AllTrim(Upper(TcGetDb()))
	Local cSelOpc   := SuperGetMv('MV_SELEOPC',.F.,'N')
	Local lMRPCINQ  := SuperGetMV("MV_MRPCINQ",.F.,.F.)
	Local lUsaLote  := SuperGetMV("MV_RASTRO",.F.,'N') == "S"
	Local cLocCQ    := Substr(SuperGetMV("MV_CQ",.F.,"98"),1,TamSX3("B1_LOCPAD")[1])
	Local lConsVenc := SuperGetMV("MV_LOTVENC",.F.,"N")=="S"

	/*
		Inserir todos os produtos na CZJ, mesmo que n�o tenham saldo.
		Inserir as quantidades de saldo na CZK para o primeiro per�odo.
		Se tiver estoque de seguran�a ou ponto de pedido, inserir na CZI e atualizar a CZK.
		Se existir produtos com f�rmula no estoque de seguran�a, dever� ser realizado loop no ADVPL para fazer o c�lculo do estoque de seguran�a.
	*/

	cInsert := " INSERT INTO " + RetSqlName("CZJ")
	cInsert +=               " (CZJ_FILIAL,"
	cInsert +=               "  CZJ_PROD,"
	cInsert +=               "  CZJ_NRRV,"
	cInsert +=               "  CZJ_NRLV,"
	cInsert +=               "  CZJ_NRMRP,"
	cInsert +=               "  CZJ_OPC,"
	cInsert +=               "  CZJ_MOPC,"
	cInsert +=               "  CZJ_OPCORD,"
	cInsert +=               "  D_E_L_E_T_,"
	IF lAutoCZJ
		cInsert +=               "  R_E_C_N_O_,"
	endif
	cInsert +=               "  R_E_C_D_E_L_) "

	cQuery := " SELECT '" + xFilial("CZJ") + "', " //CZJ_FILIAL
	cQuery +=        " SB1.B1_COD, " //CZJ_PROD
	cQuery +=        " ' '," //CZJ_NRRV
	cQuery +=        gSqlNivPrd("SB1.B1_COD") + ", " //CZJ_NRLV
	cQuery +=        " '"+c711NumMRP+"', " //CZJ_NRMRP
	If cSelOpc == 'S'
		If cBanco == 'POSTGRES'
			cQuery +=" CAST(SB1.B1_OPC AS BYTEA), " //CZJ_OPC
		ElseIf cBanco == "ORACLE"
			cQuery +=" utl_raw.cast_to_raw(SB1.B1_OPC), " //CZJ_OPC
		Else
			cQuery +=" CONVERT(varbinary(max), SB1.B1_OPC), " //CZJ_OPC
		EndIf
		cQuery +=    " SB1.B1_MOPC, " //CZJ_MOPC
		cQuery +=    " SB1.B1_OPC, " //CZJ_OPCORD
	Else
		If cBanco == 'POSTGRES'
			cQuery +=" CAST(' ' AS BYTEA), " //CZJ_OPC
		ElseIf cBanco == "ORACLE"
			cQuery +=" utl_raw.cast_to_raw(' '), " //CZJ_OPC
		Else
			cQuery +=" CONVERT(varbinary(max), ' '), " //CZJ_OPC
		EndIf
		cQuery +=    " NULL, " //CZJ_MOPC
		cQuery +=    " ' ', " //CZJ_OPCORD
	EndIf
	cQuery +=        " ' ', " //D_E_L_E_T_

	IF lAutoCZJ
		cQuery +=        gSqlRecno("CZJ","SB1.R_E_C_N_O_") + "," //R_E_C_N_O_
	EndIF
	cQuery +=        " 0 " //R_E_C_D_E_L_
	If cDadosProd == "SBZ"
		cQuery += " FROM "+RetSqlName("SB1")+" SB1 Left Outer Join "+RetSqlName("SBZ")+" SBZ "
		cQuery +=                                " ON SBZ.BZ_FILIAL = '"+xFilial("SBZ")+"' "
		cQuery +=                               " AND SBZ.BZ_COD    = SB1.B1_COD AND SBZ.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"' "
		cQuery +=   " AND COALESCE(SBZ.BZ_FANTASM, SB1.B1_FANTASM) <> 'S' "
		cQuery +=   " AND COALESCE(SBZ.BZ_MRP,     SB1.B1_MRP    ) IN (' ','S') "
		cQuery +=   " AND SB1.D_E_L_E_T_ = ' ' "
		cQuery +=   " AND SB1.B1_MSBLQL <> '1'" //ITEM BLOQUEADO
	Else
		cQuery += " FROM "+RetSqlName("SB1")+" SB1 "
		cQuery += " WHERE SB1.B1_FILIAL   = '"+xFilial("SB1") +"' "
		cQuery +=   " AND SB1.B1_FANTASM <> 'S' "
		cQuery +=   " AND SB1.D_E_L_E_T_  = ' ' "
		cQuery +=   " AND SB1.B1_MRP     IN (' ','S')"
		cQuery +=   " AND B1_MSBLQL      <> '1'" //ITEM BLOQUEADO
	EndIf

	//Query com o filtro para os JOBS
	cQueryB1 := "  AND SB1.B1_FILIAL   = '"+xFilial("SB1")+"' "
	cQueryB1 += "  AND SB1.B1_FANTASM <> 'S' "
	cQueryB1 += "  AND SB1.D_E_L_E_T_  = ' ' "
	cQueryB1 += "  AND SB1.B1_MSBLQL <> '1'" //ITEM BLOQUEADO
	If cDadosProd == "SBZ"
		cQueryB1 += "  AND ( (SELECT COUNT(*) "
		cQueryB1 +=           " FROM " + RetSqlName("SBZ") + " SBZ "
		cQueryB1 +=          " WHERE SBZ.BZ_FILIAL = '"+xFilial("SBZ")+"' "
		cQueryB1 +=            " AND SB1.D_E_L_E_T_ = ' ' "
		cQueryB1 +=            " AND SB1.B1_MSBLQL<>'1'" //ITEM BLOQUEADO
		cQueryB1 +=            " AND SBZ.D_E_L_E_T_ = ' ' "
		cQueryB1 +=            " AND SB1.B1_COD    = SBZ.BZ_COD "
		cQueryB1 +=            " ) > 0   "

		cQueryB1 += "  AND  (SELECT COUNT(*) "
		cQueryB1 +=           " FROM " + RetSqlName("SBZ") + " SBZ "
		cQueryB1 +=          " WHERE SBZ.BZ_FILIAL = '"+xFilial("SBZ")+"' "
		cQueryB1 +=            " AND SB1.D_E_L_E_T_ = ' ' "
		cQueryB1 +=            " AND SB1.B1_MSBLQL<>'1'" //ITEM BLOQUEADO
		cQueryB1 +=            " AND SBZ.D_E_L_E_T_ = ' ' "
		cQueryB1 +=            " AND SB1.B1_COD    = SBZ.BZ_COD "
		cQueryB1 +=            " AND SBZ.BZ_MRP IN ( ' ', 'S' ) ) > 0   "


		cQueryB1 +=       	   " OR ( (SELECT COUNT(*) "
		cQueryB1 +=            " FROM " + RetSqlName("SBZ") + " SBZ "
		cQueryB1 +=            " WHERE SBZ.BZ_FILIAL = '"+xFilial("SBZ")+"' "
		cQueryB1 +=            " AND SB1.D_E_L_E_T_ = ' ' "
		cQueryB1 +=            " AND SB1.B1_MSBLQL<>'1'" //ITEM BLOQUEADO
		cQueryB1 +=            " AND SBZ.D_E_L_E_T_ = ' ' "
		cQueryB1 +=            " AND SB1.B1_COD = SBZ.BZ_COD "
		cQueryB1 +=            " ) = 0 "
		cQueryB1 +=            " AND SB1.B1_MRP = 'S' ) )"
	Else
		cQueryB1 += "  AND SB1.B1_MRP     IN (' ','S')"
	EndIf

	//Caso n�o tenha sido selecionado todos, coloca TIPOS na QUERY
	If !lAllTp
		cQuery   += " AND SB1.B1_TIPO IN (SELECT TP_TIPO FROM " +cNomCZITTP +") "
		cQueryB1 += " AND SB1.B1_TIPO IN (SELECT TP_TIPO FROM " +cNomCZITTP +") "
	EndIf

	//Caso n�o tenha sido selecionado todos e o parametro estiver marcado, coloca os GRUPOS na QUERY
	If !lAllGrp .And. lMRPCINQ
		cQuery   += " AND SB1.B1_GRUPO IN (SELECT GR_GRUPO FROM " +cNomCZITGR +") "
		cQueryB1 += " AND SB1.B1_GRUPO IN (SELECT GR_GRUPO FROM " +cNomCZITGR +") "
	End If

	cQuery := ChangeQuery(cQuery)

	// Ajuste para banco DB2 - Utilizado ap�s o changeQuery
	If AllTrim(TcGetDb()) == "DB2"
		cQuery := STRTRAN( cQuery, "FOR READ ONLY", "" )
	EndIf

	//Une o comando insert com o select tratado.
	cInsert += cQuery
	//Executa a query.
	If TcSqlExec(cInsert) < 0
		Final("Erro na carga dos produtos do MRP.", TCSQLError() + cInsert)
	EndIf

	cInsert := " INSERT INTO " + cNameCZK
	cInsert +=   "(CZK_FILIAL, "
	cInsert +=   " CZK_NRMRP, "
	cInsert +=   " CZK_RGCZJ, "
	cInsert +=   " CZK_PERMRP, "
	cInsert +=   " CZK_QTSLES, "
	cInsert +=   " CZK_QTENTR, "
	cInsert +=   " CZK_QTSAID, "
	cInsert +=   " CZK_QTSEST, "
	cInsert +=   " CZK_QTSALD, "
	cInsert +=   " CZK_QTNECE, "
	cInsert +=   " D_E_L_E_T_, "
	IF lAutoCZK
		cInsert +=   " R_E_C_N_O_, "
	EndIF
	cInsert +=   " R_E_C_D_E_L_) "

	cQuery := " SELECT '"+xFilial("CZK")+"',"//CZK_FILIAL
	cQuery +=        " '"+c711NumMRP+"', " //CZK_NRMRP
	cQuery +=        " CZJ.R_E_C_N_O_, " //CZK_RGCZJ
	cQuery +=        " '001', " //CZK_PERMRP
	cQuery +=        "("
	cQuerySld :=      " SELECT COALESCE(SUM(SB2.B2_QATU),0) "
	//Considera quantidade nossa em poder de terceiro
	If aPergs711[18] == 1 .And. aPergs711[20] == 1
		cQuerySld += " + COALESCE(SUM(SB2.B2_QNPT),0) "
	EndIf
	//Considera quantidade de terceiro em nosso poder
	If aPergs711[18] == 1 .And. aPergs711[21] == 1
		cQuerySld += " - COALESCE(SUM(SB2.B2_QTNP),0) "
	EndIf
	cQuerySld +=           " FROM " + RetSqlName("SB2") + " SB2 "
	cQuerySld +=          " WHERE SB2.B2_FILIAL = '" + xFilial("SB2") + "' "
	cQuerySld +=            " AND SB2.B2_COD    = CZJ.CZJ_PROD "
	cQuerySld +=            " AND SB2.B2_LOCAL >= '" + cAlmoxd + "' "
	cQuerySld +=            " AND SB2.B2_LOCAL <= '" + cAlmoxa + "' "
	cQuerySld +=            " AND SB2.D_E_L_E_T_ = ' ' "
	If aAlmoxNNR # Nil
		cQuerySld +=        " AND SB2.B2_LOCAL IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
	EndIf
	cQuerySld := ChangeQuery(cQuerySld)
	cQuery += cQuerySld + " )"
	If !lConsVenc .And. lUsaLote
		fUsaLote(@cQuery,cAlmoxd,cAlmoxa,cLocCQ)
	EndIf
	//Saldo bloqueado
	If aPergs711[25] == 1
		cQuerySld := "  SELECT COALESCE(SUM(SDD.DD_SALDO),0) "
		cQuerySld +=    " FROM " + RetSqlName("SDD") + " SDD "
		cQuerySld +=   " WHERE SDD.DD_FILIAL  = '" + xFilial("SDD") + "' "
		cQuerySld +=     " AND SDD.D_E_L_E_T_ = ' ' "
		cQuerySld +=     " AND SDD.DD_PRODUTO = CZJ.CZJ_PROD "
		cQuerySld +=     " AND SDD.DD_MOTIVO <> 'VV' "
		cQuerySld +=     " AND SDD.DD_LOCAL >= '" + cAlmoxd + "' "
		cQuerySld +=     " AND SDD.DD_LOCAL <= '" + cAlmoxa + "' "
		If aAlmoxNNR # Nil
			cQuerySld += " AND SDD.DD_LOCAL IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
		EndIf
		cQuerySld += " AND EXISTS(SELECT 1"
		cQuerySld +=              " FROM " + RetSqlName("SB2") + " SB2BLQ "
		cQuerySld +=             " WHERE SB2BLQ.B2_FILIAL  = '"+xFilial("SB2")+"' "
		cQuerySld +=               " AND SB2BLQ.D_E_L_E_T_ = ' ' "
		cQuerySld +=               " AND SB2BLQ.B2_COD     = SDD.DD_PRODUTO "
		cQuerySld +=               " AND SB2BLQ.B2_LOCAL   = SDD.DD_LOCAL )"
		cQuerySld := ChangeQuery(cQuerySld)
		cQuery += " - (" + cQuerySld + ")"
	EndIf
	cQuery +=        ","//CZK_QTSLES
	cQuery +=        " 0, " //CZK_QTENTR
	cQuery +=        " 0, " //CZK_QTSAID
	cQuery +=        " 0, " //CZK_QTSEST
	cQuery +=        " 0, " //CZK_QTSALD
	cQuery +=        " 0, " //CZK_QTNECE
	cQuery +=        " ' ', " //D_E_L_E_T_
	IF lAutoCZK
		cQuery +=        gSqlRecno("CZK","CZJ.R_E_C_N_O_") + "," //R_E_C_N_O_
	ENDIF
	cQuery +=        " 0 " //R_E_C_D_E_L_
	cQuery +=   " FROM " + RetSqlName("CZJ") + " CZJ "
	cQuery +=   " WHERE CZJ.CZJ_FILIAL = '" +xFilial("CZJ") +"' "

	cQuery := ChangeQuery(cQuery)

	//Une o comando insert com o select tratado.
	cInsert += cQuery
	//Executa a query.
	If TcSqlExec(cInsert) < 0
		Final("Erro na carga dos saldos dos produtos do MRP.", TCSQLError() + cInsert)
	EndIf

	//Necess�rio executar a TCRefresh para atualizar o cache do DBACCESS referente a tabela CZJ.
	//Se n�o for chamada esta fun��o, ocorrer� erro ao realizar uma insers�o por RecLock.
	TCRefresh(RetSqlName("CZJ"))
	TCRefresh(RetSqlName("CZK"))

	//Saldo em CQ
	If aPergs711[22] == 1
		cArqTrb := "BUSCACQ"

		cQuery := " SELECT SD7.D7_FILIAL, "
		cQuery +=        " SD7.D7_PRODUTO, "
		cQuery +=        " SD7.D7_NUMSEQ, "
		cQuery +=        " SD7.D7_NUMERO, "
		cQuery +=        " SD7.D7_TIPO, "
		cQuery +=        " SD7.D7_QTDE, "
		cQuery +=        " SD7.D7_FORNECE, "
		cQuery +=        " SD7.D7_LOJA, "
		cQuery +=        " SD7.D7_DOC, "
		cQuery +=        " SD7.D7_SERIE, "
		cQuery +=        " CZJ.R_E_C_N_O_ RECCZJ "
		cQuery +=   " FROM " + RetSQLName("SD7") + " SD7, "
		cQuery +=              RetSqlName("CZJ") + " CZJ "
		cQuery +=  " WHERE SD7.D7_FILIAL   = '" + xFilial("SD7") + "' "
		cQuery +=    " AND SD7.D7_LOCDEST >= '" + cAlmoxd + "' "
		cQuery +=    " AND SD7.D7_LOCDEST <= '" + cAlmoxa + "' "
		If aAlmoxNNR # Nil
			cQuery += " AND SD7.D7_LOCDEST IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
		EndIf
		cQuery +=    " AND SD7.D7_DATA     < '" + dTos(aPeriodos[1]+1) + "' "
		cQuery +=    " AND SD7.D7_ESTORNO <> 'S' "
		cQuery +=    " AND SD7.D_E_L_E_T_  = ' ' "
		cQuery +=    " AND CZJ.CZJ_FILIAL = '" + xFilial("CZJ") + "' "
		cQuery +=    " AND CZJ.D_E_L_E_T_ = ' ' "
		cQuery +=    " AND CZJ.CZJ_PROD   = SD7.D7_PRODUTO "
		cQuery +=  " ORDER BY SD7.D7_FILIAL, "
		cQuery +=           " SD7.D7_PRODUTO, "
		cQuery +=           " SD7.D7_NUMSEQ, "
		cQuery +=           " SD7.D7_NUMERO "

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cArqTrb,.F.,.T.)

		cProdAnt := Nil

		Do While !(cArqTrb)->(Eof())
			If cProdAnt == Nil
				cProdAnt := (cArqTrb)->D7_PRODUTO
			EndIf

			If (cArqTrb)->D7_TIPO == 2   	//Rejeitada
				If (cArqTrb)->D7_QTDE > 0
					nQtde += A712AbDev((cArqTrb)->D7_FORNECE,(cArqTrb)->D7_LOJA,(cArqTrb)->D7_DOC,(cArqTrb)->D7_SERIE,(cArqTrb)->D7_QTDE,(cArqTrb)->D7_PRODUTO)
				EndIf
			ElseIf (cArqTrb)->D7_TIPO == 6  //Estorno da Liberacao
				nQtde += (cArqTrb)->D7_QTDE
			EndIf
			(cArqTrb)->(dbSkip())

			If cProdAnt != (cArqTrb)->D7_PRODUTO .Or. (cArqTrb)->(Eof())
				If nQtde > 0 .And. CZK->(dbSeek(xFilial("CZK")+STR((cArqTrb)->RECCZJ,10)+"001"))
					RecLock("CZK",.F.)
						CZK->CZK_QTSLES -= nQtde
					CZK->(MsUnLock())
				EndIf
				nQtde := 0
			EndIf

		EndDo
		(cArqTrb)->(dbCloseArea())

	EndIf

	//Estoque de seguran�a.
	If aPergs711[26] == 1
		cInsert := " INSERT INTO " + RetSqlName("CZI")
		cInsert +=    "(CZI_FILIAL,"
		cInsert +=    " CZI_DTOG,"
		cInsert +=    " CZI_PERMRP,"
		cInsert +=    " CZI_NRMRP, "
		cInsert +=    " CZI_NRLV,"
		cInsert +=    " CZI_PROD,"
		cInsert +=    " CZI_NRRV,"
		cInsert +=    " CZI_ALIAS,"
		cInsert +=    " CZI_NRRGAL,"
		cInsert +=    " CZI_TPRG,"
		cInsert +=    " CZI_DOC,"
		cInsert +=    " CZI_DOCKEY,"
		cInsert +=    " CZI_ITEM,"
		cInsert +=    " CZI_QUANT,"
		cInsert +=    " CZI_OPC,"
		cInsert +=    " CZI_PRODOG,"
		cInsert +=    " CZI_OPCORD,"
		cInsert +=    " D_E_L_E_T_,"
		IF lAutoCZI
			cInsert +=    " R_E_C_N_O_,"
		Endif
		cInsert +=    " R_E_C_D_E_L_) "

		cQuery := " SELECT '"+xFilial("CZI")+"', " //CZI_FILIAL
		cQuery +=        " '"+DtoS(aPeriodos[1])+"'," //CZI_DTOG
		cQuery +=        " '001', "//CZI_PERMRP
		cQuery +=        " '"+c711NumMRP+"', " //CZI_NRMRP
		cQuery +=        gSqlNivPrd("SB1.B1_COD") + ", "//CZI_NRLV
		cQuery +=        " SB1.B1_COD, "//CZI_PROD
		cQuery +=        " ' '," //CZI_NRRV
		cQuery +=        " 'SB1', " //CZI_ALIAS
		cQuery +=        " SB1.R_E_C_N_O_, " //CZI_NRRGAL
		cQuery +=        " ' '," //CZI_TPRG
		cQuery +=        " '"+cTxtSeg+"',"//CZI_DOC
		cQuery +=        " ' ', " //CZI_DOCKEY
		cQuery +=        " ' ', " //CZI_ITEM
		cQuery +=        " "
		If cDadosProd == "SBZ"
			cQuery +=    " COALESCE(SBZ.BZ_ESTSEG,SB1.B1_ESTSEG), " //CZI_QUANT
		Else
			cQuery +=    " SB1.B1_ESTSEG, " //CZI_QUANT
		EndIf
		cQuery +=        " SB1.B1_MOPC, " //CZI_OPC
		cQuery +=        " ' '," //CZI_PRODOG
		cQuery +=        " SB1.B1_OPC, "//CZI_OPCORD
		cQuery +=        " ' ', " //D_E_L_E_T_
		IF lAutoCZI
			cQuery +=        gSqlRecno("CZI","SB1.R_E_C_N_O_") + "," //R_E_C_N_O_
		EndIF
		cQuery +=        " 0 " //R_E_C_D_E_L_
		cQuery +=   " FROM " + RetSqlName("CZJ") + " CZJ, "
		cQuery +=              RetSqlName("SB1") + " SB1 "
		If cDadosProd == "SBZ"
			cQuery += " Left Outer Join " + RetSqlName("SBZ") + " SBZ "
			cQuery +=              " ON SBZ.BZ_FILIAL  = '" + xFilial("SBZ") + "' "
			cQuery +=             " AND SBZ.BZ_COD     = SB1.B1_COD "
			cQuery +=             " AND SBZ.D_E_L_E_T_ = ' '"
		EndIf
		cQuery +=  " WHERE SB1.D_E_L_E_T_ = ' ' "
		cQuery +=    " AND SB1.B1_FILIAL  = '"+xFilial("SB1")+"' "
		cQuery +=    " AND SB1.B1_COD     = CZJ.CZJ_PROD "
		cQuery +=    " AND CZJ.CZJ_FILIAL = '"+xFilial("CZJ")+"' "
		cQuery +=    " AND CZJ.D_E_L_E_T_ = ' ' "
		If cDadosProd == "SBZ"
			cQuery +=" AND COALESCE(SBZ.BZ_ESTSEG,SB1.B1_ESTSEG) <> 0 "
			cQuery +=" AND COALESCE(SBZ.BZ_ESTFOR,SB1.B1_ESTFOR) = ' ' "
		Else
			cQuery +=" AND SB1.B1_ESTSEG <> 0 "
			cQuery +=" AND SB1.B1_ESTFOR = ' ' "
		EndIf

		//Une o comando insert com o select tratado.
		cInsert += cQuery
		//Executa a query.
		If TcSqlExec(cInsert) < 0
			Final("Erro na carga do estoque de seguran�a dos produtos do MRP.", TCSQLError() + cInsert)
		EndIf

		//Atualiza os valores de entradas na tabela CZK, de acordo com os registro da tabela CZI.
		cUpdate := " UPDATE " + cNameCZK
		cUpdate +=    " SET CZK_QTSLES = CZK_QTSLES - ( SELECT SUM(CZI.CZI_QUANT) "

		cCondUpd :=                                     " FROM " + RetSqlName("CZI") + " CZI, "
		cCondUpd +=                                                RetSqlName("CZJ") + " CZJ "
		cCondUpd +=                                     " WHERE " + cNameCZK + ".CZK_FILIAL = '"+ xFilial("CZK")+ "' "
		cCondUpd +=                                       " AND " + cNameCZK + ".D_E_L_E_T_ = ' ' "
		cCondUpd +=                                       " AND " + cNameCZK + ".CZK_RGCZJ  = CZJ.R_E_C_N_O_ "
		cCondUpd +=                                       " AND CZJ.CZJ_FILIAL = '" + xFilial("CZJ") + "' "
		cCondUpd +=                                       " AND CZI.CZI_FILIAL = '" + xFilial("CZI") + "' "
		cCondUpd +=                                       " AND CZJ.D_E_L_E_T_ = ' ' "
		cCondUpd +=                                       " AND CZI.D_E_L_E_T_ = ' ' "
		cCondUpd +=                                       " AND CZI.CZI_PROD   = CZJ.CZJ_PROD "
		cCondUpd +=                                       " AND CZI.CZI_OPCORD = CZJ.CZJ_OPCORD "
		cCondUpd +=                                       " AND CZI.CZI_NRRV   = CZJ.CZJ_NRRV "
		cCondUpd +=                                       " AND CZI.CZI_TPRG   = ' ' "
		cCondUpd +=                                       " AND CZI.CZI_DOC    = '"+cTxtSeg+"'"
		cCondUpd +=                                       " AND CZI.CZI_PERMRP = "+cNameCZK+".CZK_PERMRP "
		cCondUpd +=                                       " AND CZI.CZI_ALIAS  = 'SB1' )"

		cUpdate += cCondUpd
		cUpdate += " WHERE EXISTS (SELECT 1 " + cCondUpd

		//Executa a query.
		If TcSqlExec(cUpdate) < 0
			Final("Erro na carga da tabela CZK - Estoque de seguran�a (CZK_QTSLES). ", TCSQLError() + cInsert)
		EndIf
		//Necess�rio executar a TCRefresh para atualizar o cache do DBACCESS referente a tabela CZJ.
		//Se n�o for chamada esta fun��o, ocorrer� erro ao realizar uma insers�o por RecLock.
		TCRefresh(RetSqlName("CZI"))
		TCRefresh(RetSqlName("CZK"))

		//Processa o estoque de seguran�a para os produtos que utilizam f�rmula (B1_ESTFOR)
		cArqTrb := "BUSCESTSEG"
		SB1->(dbSetOrder(1))

		cQuery := " SELECT SB1.B1_COD, "
		cQuery +=        " CZJ.R_E_C_N_O_ CZJREC, "
		If cDadosProd == "SBZ"
			cQuery +=    " COALESCE(SBZ.BZ_ESTSEG,SB1.B1_ESTSEG) B1_ESTSEG, "
			cQuery +=    " COALESCE(SBZ.BZ_ESTFOR,SB1.B1_ESTFOR) B1_ESTFOR "
		Else
			cQuery +=    " SB1.B1_ESTSEG, "
			cQuery +=    " SB1.B1_ESTFOR "
		EndIf
		cQuery +=   " FROM " + RetSqlName("CZJ") + " CZJ, "
		cQuery +=              RetSqlName("SB1") + " SB1 "
		If cDadosProd == "SBZ"
			cQuery += " Left Outer Join " + RetSqlName("SBZ") + " SBZ "
			cQuery +=              " ON SBZ.BZ_FILIAL  = '" + xFilial("SBZ") + "' "
			cQuery +=             " AND SBZ.BZ_COD     = SB1.B1_COD "
			cQuery +=             " AND SBZ.D_E_L_E_T_ = ' '"
		EndIf
		cQuery +=  " WHERE SB1.D_E_L_E_T_ = ' ' "
		cQuery +=    " AND SB1.B1_FILIAL  = '"+xFilial("SB1")+"' "
		cQuery +=    " AND SB1.B1_COD     = CZJ.CZJ_PROD "
		cQuery +=    " AND CZJ.CZJ_FILIAL = '"+xFilial("CZJ")+"' "
		cQuery +=    " AND CZJ.D_E_L_E_T_ = ' ' "
		If cDadosProd == "SBZ"
			cQuery +=" AND COALESCE(SBZ.BZ_ESTFOR,SB1.B1_ESTFOR) <> ' ' "
		Else
			cQuery +=" AND SB1.B1_ESTFOR <> ' ' "
		EndIf
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqTrb,.F.,.F.)
		While (cArqTrb)->(!Eof())
			SB1->(dbSeek(xFilial("SB1")+(cArqTrb)->B1_COD))
			nEstSeg := Formula((cArqTrb)->B1_ESTFOR)
			If(ValType(nEstSeg) # "N")
				Aviso(STR0026,OemToAnsi(STR0035)+(cArqTrb)->B1_COD+OemToAnsi(STR0036),{'Ok'}) //"A formula de estoque de seguranca do produto "###" esta retornando valor incorreto. A formula sera desconsiderada"
				nEstSeg := (cArqTrb)->B1_ESTSEG
			Endif
			If nEstSeg <> 0
				A712CriCZI(aPeriodos[1],SB1->B1_COD,SB1->B1_OPC,IIF(lPCPREVATU , PCPREVATU(SB1->B1_COD), SB1->B1_REVATU )/*SB1->B1_REVATU*/,"SB1",SB1->(Recno()),cTxtSeg,/*08*/,/*09*/,nEstSeg,/*11*/,.F.,.F.,"SB1",.F.,/*16*/,/*17*/,/*18*/,/*19*/,cStrTipo,cStrGrupo,/*22*/,/*23*/,/*24*/,SB1->B1_MOPC,/*26*/)
				If CZK->(dbSeek(xFilial("CZK")+STR((cArqTrb)->CZJREC,10)+"001"))
					RecLock("CZK",.F.)
						CZK->CZK_QTSLES -= nEstSeg
					CZK->(MsUnLock())
				EndIf
			EndIf
			(cArqTrb)->(dbSkip())
		End
		(cArqTrb)->(dbCloseArea())
	EndIf

	//Ponto de pedido.
	If aPergs711[31] == 1
		cInsert := " INSERT INTO " + RetSqlName("CZI")
		cInsert +=    "(CZI_FILIAL,"
		cInsert +=    " CZI_DTOG,"
		cInsert +=    " CZI_PERMRP,"
		cInsert +=    " CZI_NRMRP, "
		cInsert +=    " CZI_NRLV,"
		cInsert +=    " CZI_PROD,"
		cInsert +=    " CZI_NRRV,"
		cInsert +=    " CZI_ALIAS,"
		cInsert +=    " CZI_NRRGAL,"
		cInsert +=    " CZI_TPRG,"
		cInsert +=    " CZI_DOC,"
		cInsert +=    " CZI_DOCKEY,"
		cInsert +=    " CZI_ITEM,"
		cInsert +=    " CZI_QUANT,"
		cInsert +=    " CZI_OPC,"
		cInsert +=    " CZI_PRODOG,"
		cInsert +=    " CZI_OPCORD,"
		cInsert +=    " D_E_L_E_T_,"
		IF lAutoCZI
			cInsert +=    " R_E_C_N_O_,"
		EndiF
		cInsert +=    " R_E_C_D_E_L_) "

		cQuery := " SELECT '"+xFilial("CZI")+"', " //CZI_FILIAL
		cQuery +=        " '"+DtoS(aPeriodos[1])+"'," //CZI_DTOG
		cQuery +=        " '001', "//CZI_PERMRP
		cQuery +=        " '"+c711NumMRP+"', " //CZI_NRMRP
		cQuery +=        gSqlNivPrd("SB1.B1_COD") + ", "//CZI_NRLV
		cQuery +=        " SB1.B1_COD, "//CZI_PROD
		cQuery +=        " ' '," //CZI_NRRV
		cQuery +=        " 'SB1', " //CZI_ALIAS
		cQuery +=        " SB1.R_E_C_N_O_, " //CZI_NRRGAL
		cQuery +=        " ' '," //CZI_TPRG
		cQuery +=        " '"+cTxtPPed+"',"//CZI_DOC
		cQuery +=        " ' ', " //CZI_DOCKEY
		cQuery +=        " ' ', " //CZI_ITEM
		cQuery +=        " "
		If cDadosProd == "SBZ"
			cQuery +=    " COALESCE(SBZ.BZ_EMIN,SB1.B1_EMIN), " //CZI_QUANT
		Else
			cQuery +=    " SB1.B1_EMIN, " //CZI_QUANT
		EndIf
		cQuery +=        " SB1.B1_MOPC, " //CZI_OPC
		cQuery +=        " ' '," //CZI_PRODOG
		cQuery +=        " SB1.B1_OPC, "//CZI_OPCORD
		cQuery +=        " ' ', " //D_E_L_E_T_

		IF lAutoCZI
			cQuery +=        gSqlRecno("CZI","SB1.R_E_C_N_O_") + "," //R_E_C_N_O_
		Endif
		cQuery +=        " 0 " //R_E_C_D_E_L_
		cQuery +=   " FROM " + RetSqlName("CZJ") + " CZJ, "
		cQuery +=              RetSqlName("SB1") + " SB1 "
		If cDadosProd == "SBZ"
			cQuery += " Left Outer Join " + RetSqlName("SBZ") + " SBZ "
			cQuery +=              " ON SBZ.BZ_FILIAL  = '" + xFilial("SBZ") + "' "
			cQuery +=             " AND SBZ.BZ_COD     = SB1.B1_COD "
			cQuery +=             " AND SBZ.D_E_L_E_T_ = ' '"
		EndIf
		cQuery +=  " WHERE SB1.D_E_L_E_T_ = ' ' "
		cQuery +=    " AND SB1.B1_FILIAL  = '"+xFilial("SB1")+"' "
		cQuery +=    " AND SB1.B1_COD     = CZJ.CZJ_PROD "
		cQuery +=    " AND CZJ.CZJ_FILIAL = '"+xFilial("CZJ")+"' "
		cQuery +=    " AND CZJ.D_E_L_E_T_ = ' ' "
		If cDadosProd == "SBZ"
			cQuery +=" AND COALESCE(SBZ.BZ_EMIN,SB1.B1_EMIN) <> 0 "
		Else
			cQuery +=" AND SB1.B1_EMIN <> 0 "
		EndIf

		//Une o comando insert com o select tratado.
		cInsert += cQuery
		//Executa a query.
		If TcSqlExec(cInsert) < 0
			Final("Erro na carga do ponto de pedido dos produtos do MRP.", TCSQLError() + cInsert)
		EndIf

		//Necess�rio executar a TCRefresh para atualizar o cache do DBACCESS referente a tabela CZI.
		//Se n�o for chamada esta fun��o, ocorrer� erro ao realizar uma insers�o por RecLock.
		TCRefresh(RetSqlName("CZI"))
	EndIf
Return Nil

/*/{Protheus.doc} fUsaLote
	@type  Static Function
	@author mauricio.joao
	@since 13/11/2020
	@version 1.0
/*/
Static Function fUsaLote(cQuery,cAlmoxd,cAlmoxa,cLocCQ)
Local cQuerySld := ""

	cQuerySld := " SELECT COALESCE(SUM(SB8.B8_SALDO),0) "
	cQuerySld +=   " FROM " +RetSQLName("SB8") + " SB8 "
	cQuerySld +=  " WHERE SB8.B8_FILIAL  = '" +xFilial("SB8") + "' "
	cQuerySld +=    " AND SB8.B8_PRODUTO = CZJ.CZJ_PROD "
	cQuerySld +=    " AND SB8.B8_LOCAL  >= '" + cAlmoxd + "' "
	cQuerySld +=    " AND SB8.B8_LOCAL  <= '" + cAlmoxa + "' "
	cQuerySld +=    " AND SB8.B8_SALDO   > 0 "
	cQuerySld +=    " AND SB8.D_E_L_E_T_ = ' ' "

	If aPergs711[22] == 1 //ja e tratado indiretamente na A712QtdCQ
		cQuerySld += " AND SB8.B8_LOCAL <> '" +cLocCQ +"' "
	EndIf
	cQuerySld += " AND SB8.B8_DTVALID > '20000101' "
	cQuerySld += " AND SB8.B8_DTVALID < '" +DToS(aPeriodos[1]) +"' "
	If aAlmoxNNR # Nil
		cQuerySld += " AND SB8.B8_LOCAL IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
	EndIf
	cQuerySld += " AND EXISTS(SELECT 1"
	cQuerySld +=              " FROM " + RetSqlName("SB2") + " SB2LT "
	cQuerySld +=             " WHERE SB2LT.B2_FILIAL  = '"+xFilial("SB2")+"' "
	cQuerySld +=               " AND SB2LT.D_E_L_E_T_ = ' ' "
	cQuerySld +=               " AND SB2LT.B2_COD     = SB8.B8_PRODUTO "
	cQuerySld +=               " AND SB2LT.B2_LOCAL   = SB8.B8_LOCAL )"
	cQuerySld := ChangeQuery(cQuerySld)
	cQuery += " - ( " + cQuerySld + ") "

Return .T.

/*/{Protheus.doc} procSC1
Busca os dados das solicita��es de compra para carregar a tabela CZI.
@author lucas.franca
@since 21/05/2018
@version 1.0

@param cQueryB1		- Query para filtro dos produtos (SB1)
@param cAlmoxd		- Armaz�m de - para filtro das solicita��es de compra.
@param cAlmoxa		- Armaz�m at� - para filtro das solicita��es de compra.
@param dDatFim		- Data final para filtro das solicita��es de compra.
@param aPeriodos	- Array com os per�odos do MRP.
@param lConsSusp	- Indicador para considerar ordens suspensas
@param lConsSacr	- Indicador para considerar ordens sacramentadas

@return Nil
/*/
Static Function procSC1(cQueryB1,cAlmoxd,cAlmoxa,dDatFim,aPeriodos,lConsSusp,lConsSacr)
	Local cQuery   := ""
	Local cInsert  := ""
	Local cBanco     := AllTrim(Upper(TcGetDb()))
	Local cComando   := "COALESCE"

	ProcLogAtu("MENSAGEM","Iniciando Processamento SC1","Iniciando Processamento SC1")

	If "MSSQL" $ cBanco
		cComando := "ISNULL"
	EndIf

	cInsert := "INSERT INTO " + RetSqlName("CZI")
	cInsert +=    "(CZI_FILIAL,"
	cInsert +=    " CZI_DTOG,"
	cInsert +=    " CZI_PERMRP,"
	cInsert +=    " CZI_NRMRP, "
	cInsert +=    " CZI_NRLV,"
	cInsert +=    " CZI_PROD,"
	cInsert +=    " CZI_NRRV,"
	cInsert +=    " CZI_ALIAS,"
	cInsert +=    " CZI_NRRGAL,"
	cInsert +=    " CZI_TPRG,"
	cInsert +=    " CZI_DOC,"
	cInsert +=    " CZI_DOCKEY,"
	cInsert +=    " CZI_ITEM,"
	cInsert +=    " CZI_QUANT,"
	cInsert +=    " CZI_OPC,"
	cInsert +=    " CZI_PRODOG,"
	cInsert +=    " CZI_OPCORD,"
	cInsert +=    " D_E_L_E_T_,"
	IF lAutoCZI
		cInsert +=    " R_E_C_N_O_,"
	Endif
	cInsert +=    " R_E_C_D_E_L_) "

	cQuery := " SELECT '"+ xFilial("CZI") +"', " //CZI_FILIAL
	cQuery +=        gSqlNxtUti("SC1.C1_DATPRF") + ", " //CZI_DTOG
	cQuery +=        gSqlPerMRP(aPeriodos, "SC1.C1_DATPRF", dDatFim) + " ," //CZI_PERMRP
	cQuery +=        " '"+c711NumMRP+"'," //CZI_NRMRP
	cQuery +=        gSqlNivPrd("SC1.C1_PRODUTO") + ", "//CZI_NRLV
	cQuery +=        " SC1.C1_PRODUTO," //CZI_PROD
	cQuery +=        " ' ',"            //CZI_NRRV
	cQuery +=        " 'SC1', "         //CZI_ALIAS
	cQuery +=        " SC1.R_E_C_N_O_," //CZI_NRRGAL
	cQuery +=        " '2',"            //CZI_TPRG
	cQuery +=        " SC1.C1_NUM, "    //CZI_DOC
	If Upper(TcGetDb()) == "ORACLE"
		cQuery += cComando + "(TRIM(SC1.C1_OP), ' '), " //CZI_DOCKEY
	Else
		cQuery += cComando + "(SC1.C1_OP,' '), "     //CZI_DOCKEY
	EndIf
	cQuery +=        " SC1.C1_ITEM, "   //CZI_ITEM
	cQuery +=        " SC1.C1_QUANT - SC1.C1_QUJE , "  //CZI_QUANT
	cQuery +=        " NULL, "          //CZI_OPC
	cQuery +=        " ' ', "           //CZI_PRODOG
	cQuery +=        " ' ', "           //CZI_OPCORD
	cQuery +=        " ' ', "           //D_E_L_E_T_

	IF lAutoCZI
		cQuery +=        gSqlRecno("CZI","SC1.R_E_C_N_O_") + "," //R_E_C_N_O_
	EndiF
	cQuery +=        " 0 "              //R_E_C_D_E_L_
	cQuery +=   " FROM " + RetSqlName("SC1") + " SC1, " + RetSqlName("SB1") + " SB1 "
	cQuery +=  " WHERE ((SC1.C1_FILIAL  = '" + xFilial("SC1") + "' "
	cQuery +=    " AND  (SC1.C1_FILENT  = '" + xFilial("SC1") + "' "
	cQuery +=    "  OR   SC1.C1_FILENT  = '')) "
	cQuery +=    "  OR  (SC1.C1_FILIAL <> '" + xFilial("SC1") + "' "
	cQuery +=    " AND   SC1.C1_FILENT  = '" + xFilial("SC1") + "')) "
	cQuery +=    " AND SC1.C1_LOCAL    >= '" + cAlmoxd + "' "
	cQuery +=    " AND SC1.C1_LOCAL    <= '" + cAlmoxa + "' "
	cQuery +=    " AND SC1.C1_RESIDUO   = '" + CriaVar("C1_RESIDUO",.F.) + "' "
	cQuery +=    " AND SC1.C1_DATPRF   <= '" + Dtos(dDatFim) + "' "
	cQuery +=    " AND SC1.C1_QUANT     > SC1.C1_QUJE "
	cQuery +=    " AND SC1.D_E_L_E_T_   = ' ' "
	cQuery +=    " AND SC1.C1_PRODUTO   = SB1.B1_COD "
	cQuery +=    " AND SB1.D_E_L_E_T_   = ' ' "
	If !SuperGetMV("MV_MRPSCRE",.F.,.T.)
		cQuery += "AND SC1.C1_ORIGEM <> 'MATA106' "
	EndIf
	If aAlmoxNNR # Nil
		cQuery += " AND SC1.C1_LOCAL IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
	EndIf

	If !lConsSusp .Or. !lConsSacr
		cQuery += " AND (SC1.C1_OP = ' ' "
		cQuery +=  " OR  SC1.C1_OP NOT IN ( " + MT712QNOC2(lConsSusp, lConsSacr) + ") )"
	EndIf

	cQuery += cQueryB1

	//Une o comando insert com o select tratado.
	cInsert += cQuery
	//Executa a query.
	If TcSqlExec(cInsert) < 0
		Final("Erro na carga das solicita��es de compra. ", TCSQLError() + cInsert)
	EndIf

	//Necess�rio executar a TCRefresh para atualizar o cache do DBACCESS referente a tabela CZI.
	//Se n�o for chamada esta fun��o, ocorrer� erro ao realizar uma insers�o por RecLock.
	TCRefresh(RetSqlName("CZI"))

	ProcLogAtu("MENSAGEM","Termino Processamento SC1","Termino Processamento SC1")
Return Nil

/*/{Protheus.doc} procSC2
Busca os dados das ordens de produ��o para carregar a tabela CZI.
@author lucas.franca
@since 21/05/2018
@version 1.0

@param cQueryB1		- Query para filtro dos produtos (SB1)
@param cAlmoxd		- Armaz�m de - para filtro das ordens de produ��o.
@param cAlmoxa		- Armaz�m at� - para filtro das ordens de produ��o.
@param dDatFim		- Data final para filtro das ordens de produ��o.
@param aPeriodos	- Array com os per�odos do MRP.
@param lConsSusp	- Indicador para considerar ordens suspensas
@param lConsSacr	- Indicador para considerar ordens sacramentadas

@return Nil
/*/
Static Function procSC2(cQueryB1,cAlmoxd,cAlmoxa,dDatFim,aPeriodos,lConsSusp,lConsSacr)
	Local cQuery   := ""
	Local cInsert  := ""
	Local lPerdInf := SuperGetMV("MV_PERDINF",.F.,.F.)
	Local cGetDB   := Upper(TcGetDb())
	Local nTamNum  := TamSx3("C2_NUM")[1]
	Local nTamItem := TamSx3("C2_ITEM")[1]

	ProcLogAtu("MENSAGEM","Iniciando Processamento SC2","Iniciando Processamento SC2")

	cInsert := "INSERT INTO " + RetSqlName("CZI")
	cInsert +=    "(CZI_FILIAL,"
	cInsert +=    " CZI_DTOG,"
	cInsert +=    " CZI_PERMRP,"
	cInsert +=    " CZI_NRMRP, "
	cInsert +=    " CZI_NRLV,"
	cInsert +=    " CZI_PROD,"
	cInsert +=    " CZI_NRRV,"
	cInsert +=    " CZI_ALIAS,"
	cInsert +=    " CZI_NRRGAL,"
	cInsert +=    " CZI_TPRG,"
	cInsert +=    " CZI_DOC,"
	cInsert +=    " CZI_DOCKEY,"
	cInsert +=    " CZI_ITEM,"
	cInsert +=    " CZI_QUANT,"
	cInsert +=    " CZI_OPC,"
	cInsert +=    " CZI_PRODOG,"
	cInsert +=    " CZI_OPCORD,"
	cInsert +=    " D_E_L_E_T_,"
	IF lAutoCZI
		cInsert +=    " R_E_C_N_O_,"
	Endif
	cInsert +=    " R_E_C_D_E_L_) "

	cQuery := " SELECT '"+xFilial("CZI")+"', "   //CZI_FILIAL
	cQuery +=        gSqlNxtUti("SC2.C2_DATPRF") + ", "          //CZI_DTOG
	cQuery +=        gSqlPerMRP(aPeriodos, ;
	                            "SC2.C2_DATPRF", ;
	                            dDatFim) + " ,"  //CZI_PERMRP
	cQuery +=        " '"+c711NumMRP+"',"        //CZI_NRMRP
	cQuery +=        gSqlNivPrd("SC2.C2_PRODUTO") + ;
	                 ", "                        //CZI_NRLV
	cQuery +=        " SC2.C2_PRODUTO, "         //CZI_PROD
	cQuery +=        " ' ',"                     //CZI_NRRV
	cQuery +=        " 'SC2', "                  //CZI_ALIAS
	cQuery +=        " SC2.R_E_C_N_O_, "         //CZI_NRRGAL
	cQuery +=        " '2', "                    //CZI_TPRG
	If cGetDB $ 'ORACLE,DB2,POSTGRES,INFORMIX' //CZI_DOC
		cQuery +=    " SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD, "
	Else
		cQuery +=    " SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN+SC2.C2_ITEMGRD, "
	EndIf
	cQuery +=        " CASE "
	cQuery +=            " WHEN SC2.C2_PEDIDO = '' THEN ' ' "
	If cGetDB $ 'ORACLE,DB2,POSTGRES,INFORMIX'
		cQuery +=            " ELSE SC2.C2_PEDIDO||'/'||SC2.C2_ITEMPV"
	Else
		cQuery +=            " ELSE SC2.C2_PEDIDO+'/'+SC2.C2_ITEMPV"
	EndIf
	cQuery +=        " END, "                    //CZI_DOCKEY
	cQuery +=        " ' ', "                    //CZI_ITEM
	cQuery +=        " CASE "
	cQuery +=           " WHEN C2_QUANT-C2_QUJE-" + Iif(lPerdInf,"0","C2_PERDA") + " >= 0 "
	cQuery +=           " THEN C2_QUANT-C2_QUJE-" + Iif(lPerdInf,"0","C2_PERDA")
	cQuery +=           " ELSE 0 "
	cQuery +=        " END, "                    //CZI_QUANT
	cQuery +=        " SC2.C2_MOPC, "            //CZI_OPC
	cQuery +=        " ' ', "                    //CZI_PRODOG
	cQuery +=        " SC2.C2_OPC, "             //CZI_OPCORD
	cQuery +=        " ' ', "                    //D_E_L_E_T_

	IF lAutoCZI
		cQuery +=        gSqlRecno("CZI","SC2.R_E_C_N_O_") + "," //R_E_C_N_O_
	EndiF
	cQuery +=        " 0 "                        //R_E_C_D_E_L_
	cQuery +=   " FROM " + RetSqlName("SC2")+" SC2, " + RetSqlName("SB1") + " SB1 "
	cQuery +=  " WHERE SC2.C2_FILIAL  = '" + xFilial("SC2") + "' "
	cQuery +=    " AND SC2.C2_DATRF   = '" + Space(Len(DTOS(SC2->C2_DATRF))) + "' "
	cQuery +=    " AND SC2.C2_LOCAL  >= '" + cAlmoxd + "' "
	cQuery +=    " AND SC2.C2_LOCAL  <= '" + cAlmoxa + "' "
	cQuery +=    " AND SC2.C2_DATPRF <= '" + Dtos(dDatFim) + "' "
	cQuery +=    " AND SC2.D_E_L_E_T_ = ' ' "
	cQuery +=    " AND SC2.C2_PRODUTO = SB1.B1_COD "

	//Inclui condicao se nao considera OPs Suspensas
	If !lConsSusp
		cQuery += " AND SC2.C2_STATUS <> 'U' "
	EndIf

	//Inclui condicao se nao considera OPs Sacramentadas
	If !lConsSacr
		cQuery += " AND SC2.C2_STATUS <> 'S' "
	EndIf

	If aAlmoxNNR # Nil
		cQuery += " AND SC2.C2_LOCAL IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
	EndIf

	cQuery += cQueryB1

	//Une o comando insert com o select tratado.
	cInsert += cQuery

	//Executa a query.
	If TcSqlExec(cInsert) < 0
		Final("Erro na carga das ordens de produ��o. ", TCSQLError() + cInsert)
	EndIf

	//Necess�rio executar a TCRefresh para atualizar o cache do DBACCESS referente a tabela CZI.
	//Se n�o for chamada esta fun��o, ocorrer� erro ao realizar uma insers�o por RecLock.
	TCRefresh(RetSqlName("CZI"))

	//Ajustes dos opcionais caso parametro MV_MOPCGRAV estiver com .T.	
	 IF lMopcGRV
	 	cUpd01 	  := " UPDATE " + RetSQLName("CZI")

		If(TCGetDB() $ "ORACLE/POSTGRES/DB2/400/INFORMIX")
			cSubQuery := " SELECT  MIN(CAST('REC' || CAST(CZI2.R_E_C_N_O_ AS VARCHAR(15) ) AS VARCHAR(15) ))  "
		Else
			cSubQuery := " SELECT  MIN(CAST('REC' + CAST(CZI2.R_E_C_N_O_ AS VARCHAR(15) ) AS VARBINARY ))  "
		EndIf
		cSubQuery += "   FROM " + RetSQLName("CZI") + " CZI2 "
		cSubQuery +=  " WHERE CZI2.CZI_FILIAL = '" + xFilial("CZI") + "' AND SUBSTRING(CZI2.CZI_DOC,1," + ALLTRIM(STR(nTamNum+nTamItem)) + ") = SUBSTRING("+RetSQLName("CZI")+".CZI_DOC,1," + ALLTRIM(STR(nTamNum+nTamItem))+ ") "
		cSubQuery +=  " AND CZI2.CZI_OPC IS NOT NULL AND CZI2.CZI_ALIAS = 'SC2' AND  SUBSTRING(CAST(CZI2.CZI_OPC AS varchar(15) ),1,1) = 'A'  AND CZI2.CZI_ALIAS = 'SC2'  "
		cSubQuery :=  ChangeQuery(cSubQuery)
		cUpd01 	  +=  " SET CZI_OPC = (" +cSubQuery + ")"
		cUpd01 	  += " WHERE  CZI_FILIAL = '" + xFilial("CZI") + "'  AND CZI_ALIAS = 'SC2' AND CZI_OPC IS NULL  AND  D_E_L_E_T_ = ' ' "

		If TcSqlExec(cUpd01) < 0
			Final("Erro na carga das ordens de produ��o. ", TCSQLError() + cInsert)
		EndIf

	 EndIf

	ProcLogAtu("MENSAGEM","Termino Processamento SC2","Termino Processamento SC2")
Return Nil

/*/{Protheus.doc} procSD4
Busca os dados dos empenhos para carregar a tabela CZI.
@author lucas.franca
@since 21/05/2018
@version 1.0

@param cQueryB1		- Query para filtro dos produtos (SB1)
@param cAlmoxd		- Armaz�m de - para filtro dos empenhos.
@param cAlmoxa		- Armaz�m at� - para filtro dos empenhos.
@param dDatFim		- Data final para filtro dos empenhos.
@param aPeriodos	- Array com os per�odos do MRP.
@param lConsSusp	- Indicador para considerar ordens suspensas
@param lConsSacr	- Indicador para considerar ordens sacramentadas

@return Nil
/*/
Static Function procSD4(cQueryB1,cAlmoxd,cAlmoxa,dDatFim,aPeriodos,lConsSusp,lConsSacr)
	Local cQuery     := ""
	Local cInsert    := ""
	Local cBanco     := AllTrim(Upper(TcGetDb()))
	Local cNameIndex := ""
	Local cError     := ""
	Local nResult    := 0
	Local lC2Op      := .F.
	Local lRet       := .T.
	Local nTamNum    := TamSx3("C2_NUM")[1]
	Local nTamItem   := TamSx3("C2_ITEM")[1]

	If cBanco == "POSTGRES"
		ProcLogAtu("MENSAGEM","Iniciando cria��o do indice GET_OP","Iniciando cria��o do indice GET_OP")

		cNameIndex := RetSqlName("SC2")+"_get_op"
		cQuery := "CREATE INDEX "+cNameIndex+" ON "+RetSqlName("SC2")+" ((C2_NUM||C2_ITEM||C2_SEQUEN||C2_ITEMGRD))"
		TcSqlExec(cQuery)

		ProcLogAtu("MENSAGEM","Termino cria��o do indice GET_OP","Termino cria��o do indice GET_OP")
	EndIf

	If "MSSQL" $ cBanco

		cNameIndex := RetSqlName("SD4")+"_get_op"

		If !existeIndx(cNameIndex, "SD4")
			ProcLogAtu("MENSAGEM","Iniciando cria��o do indice GET_OP","Iniciando cria��o do indice GET_OP")

			cQuery := " CREATE NONCLUSTERED INDEX " + cNameIndex + " ON " + RetSqlName("SD4") + " ([D4_FILIAL],[D_E_L_E_T_],[D4_LOCAL],[D4_DATA],[D4_QUANT]) INCLUDE ([D4_COD],[D4_OP],[R_E_C_N_O_]) "
			TcSqlExec(cQuery)

			ProcLogAtu("MENSAGEM","Termino cria��o do indice GET_OP","Termino cria��o do indice GET_OP")
		EndIf

	EndIf

	dbSelectArea("SC2")
	If SC2->(FieldPos("C2_OP")) > 0
		lC2Op := .T.
		lRet := AtuOPSC2(@cError)
	EndIf

	ProcLogAtu("MENSAGEM","Iniciando Processamento SD4","Iniciando Processamento SD4")

	If lRet
		cInsert := "INSERT INTO " + RetSqlName("CZI")
		cInsert +=    "(CZI_FILIAL,"
		cInsert +=    " CZI_DTOG,"
		cInsert +=    " CZI_PERMRP,"
		cInsert +=    " CZI_NRMRP, "
		cInsert +=    " CZI_NRLV,"
		cInsert +=    " CZI_PROD,"
		cInsert +=    " CZI_NRRV,"
		cInsert +=    " CZI_ALIAS,"
		cInsert +=    " CZI_NRRGAL,"
		cInsert +=    " CZI_TPRG,"
		cInsert +=    " CZI_DOC,"
		cInsert +=    " CZI_DOCKEY,"
		cInsert +=    " CZI_ITEM,"
		cInsert +=    " CZI_QUANT,"
		cInsert +=    " CZI_OPC,"
		cInsert +=    " CZI_PRODOG,"
		cInsert +=    " CZI_OPCORD,"
		cInsert +=    " D_E_L_E_T_,"

		IF lAutoCZI
			cInsert +=    " R_E_C_N_O_,"
		EndIF

		cInsert +=    " R_E_C_D_E_L_) "
		cQuery := " SELECT '"+xFilial("CZI")+"', "   //CZI_FILIAL
		cQuery +=        gSqlNxtUti("SD4.D4_DATA") + ", " //CZI_DTOG
		cQuery +=        gSqlPerMRP(aPeriodos, ;
		                            "SD4.D4_DATA", ;
		                            dDatFim) + " ,"  //CZI_PERMRP
		cQuery +=        " '"+c711NumMRP+"',"        //CZI_NRMRP
		cQuery +=        gSqlNivPrd("SD4.D4_COD") + ;
		                 ", "                        //CZI_NRLV
		cQuery +=        " SD4.D4_COD, " //CZI_PROD
		cQuery +=        " ' ', " //CZI_NRRV
		cQuery +=        " 'SD4', " //CZI_ALIAS
		cQuery +=        " SD4.R_E_C_N_O_, " //CZI_NRRGAL
		cQuery +=        " CASE WHEN SD4.D4_QUANT > 0 THEN '3' ELSE '2' END, " //CZI_TPRG
		cQuery +=        " SD4.D4_OP, " //CZI_DOC
		If cBanco == "ORACLE"
			cQuery +=    " TRIM(SD4.D4_OP), " //CZI_DOCKEY
		Else
			cQuery +=    " SD4.D4_OP, " //CZI_DOCKEY
		EndIf
		cQuery +=        " ' ', " //CZI_ITEM
		cQuery +=       " ABS(SD4.D4_QUANT), " //CZI_QUANT
		cQuery +=        " SC2.C2_MOPC, "
		cQuery +=        " ' ', " //CZI_PRODOG
		cQuery +=        " ' ', " //CZI_OPCORD
		cQuery +=        " ' ', " //D_E_L_E_T_

		IF lAutoCZI
			cQuery +=        gSqlRecno("CZI","SD4.R_E_C_N_O_") + "," //R_E_C_N_O_
		EndIF
		cQuery +=        " 0 " //R_E_C_D_E_L_
		cQuery +=   " FROM " + RetSqlName("SD4") + " SD4 "
		cQuery +=  " INNER JOIN " + RetSqlName("SB1") + " SB1 "
		cQuery +=     " ON SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
		cQuery +=    " AND SD4.D4_FILIAL  = '" + xFilial("SD4") + "' "
		cQuery +=    " AND SB1.B1_COD     = SD4.D4_COD "
		cQuery +=    " AND SB1.D_E_L_E_T_ = ' ' "
		cQuery +=  " INNER JOIN " + RetSqlName("SC2") + " SC2 "
		cQuery +=     " ON SC2.C2_FILIAL  = '" + xFilial("SC2") + "' "
		cQuery +=    " AND SD4.D4_FILIAL  = '" + xFilial("SD4") + "' "
		cQuery +=    " AND SC2.D_E_L_E_T_ = ' ' "

		If lC2Op
			cQuery +=    " AND SC2.C2_OP = CASE WHEN SD4.D4_OPORIG <> ' ' THEN SD4.D4_OPORIG ELSE SD4.D4_OP END "
		ElseIf cBanco $ 'ORACLE,DB2,POSTGRES,INFORMIX'
			cQuery +=    " AND SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD = CASE WHEN SD4.D4_OPORIG <> ' ' THEN SD4.D4_OPORIG ELSE SD4.D4_OP END "
		Else
			cQuery +=    " AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN+SC2.C2_ITEMGRD = CASE WHEN SD4.D4_OPORIG <> ' ' THEN SD4.D4_OPORIG ELSE SD4.D4_OP END "
		EndIf

		If !lConsSusp .Or. !lConsSacr
			cQuery += " AND SC2.C2_STATUS NOT IN ("
			If !lConsSusp
				cQuery += "'U'"
			EndIf
			If !lConsSacr
				cQuery += Iif(!lConsSusp,",","") + "'S'"
			EndIf
			cQuery += ")"
		EndIf

		cQuery +=  " WHERE SD4.D4_QUANT  <> 0 "
		cQuery +=    " AND SD4.D4_LOCAL  >= '" + cAlmoxd + "' "
		cQuery +=    " AND SD4.D4_LOCAL  <= '" + cAlmoxa + "' "
		cQuery +=    " AND SD4.D4_DATA   <= '" + Dtos(dDatFim) + "' "
		cQuery +=    " AND SD4.D_E_L_E_T_ = ' ' "

		If !(aPergs711[13]==1)
			cQuery += " AND (SD4.D4_QUANT-SD4.D4_QSUSP) <> 0 "
		EndIf

		If aAlmoxNNR # Nil
			cQuery += " AND SD4.D4_LOCAL IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
		EndIf

		cQuery += cQueryB1

		//Une o comando insert com o select tratado.
		cInsert += cQuery

		//Executa a query.
		nResult := TcSqlExec(cInsert)
	EndIf

	If cBanco == "POSTGRES"
		cQuery := "DROP INDEX " + cNameIndex
		TcSqlExec(cQuery)
	EndIf

	If nResult < 0 .Or. !lRet
		If Empty(cError)
			Final("Erro na carga dos empenhos. ", TCSQLError() + cInsert)
		Else
			Final("Erro na carga dos empenhos. ", cError)
		EndIf
	EndIf

	//Necess�rio executar a TCRefresh para atualizar o cache do DBACCESS referente a tabela CZI.
	//Se n�o for chamada esta fun��o, ocorrer� erro ao realizar uma insers�o por RecLock.
	TCRefresh(RetSqlName("CZI"))

	//Ajustes dos opcionais caso parametro MV_MOPCGRAV estiver com .T.
	IF lMopcGRV
		cUpd01 	  := " UPDATE " + RetSQLName("CZI")
		If(TCGetDB() $ "ORACLE/POSTGRES/DB2/400/INFORMIX")
			cSubQuery := " SELECT  MIN(CAST('REC' || CAST(CZI2.R_E_C_N_O_ AS VARCHAR(15) ) AS VARCHAR(15) ))  "
		Else
			cSubQuery := " SELECT  MIN(CAST('REC' + CAST(CZI2.R_E_C_N_O_ AS VARCHAR(15) ) AS VARBINARY ))  "
		EndIf
		cSubQuery +=  "   FROM " + RetSQLName("CZI") + " CZI2 "
		cSubQuery +=  "  WHERE CZI2.CZI_FILIAL = '" + xFilial("CZI") + "' AND SUBSTRING(CZI2.CZI_DOC,1," + ALLTRIM(STR(nTamNum+nTamItem)) + ") = SUBSTRING("+RetSQLName("CZI")+".CZI_DOC,1," + ALLTRIM(STR(nTamNum+nTamItem))+ ") "
		cSubQuery +=  "    AND CZI2.CZI_OPC IS NOT NULL  AND  SUBSTRING(CAST(CZI2.CZI_OPC AS varchar(15) ),1,1) = 'A' AND CZI2.CZI_ALIAS = 'SD4'  "
		cSubQuery :=  ChangeQuery(cSubQuery)

		cUpd01 	  +=  "  SET CZI_OPC = (" +cSubQuery + ")"
		cUpd01 	  += " WHERE CZI_FILIAL = '" + xFilial("CZI") + "'  AND CZI_ALIAS = 'SD4' AND CZI_OPC IS NULL  AND  D_E_L_E_T_ = ' ' "

		If TcSqlExec(cUpd01) < 0
			Final("Erro na carga das ordens de produ��o. ", TCSQLError() + cInsert)
		EndIf
	EndIf

	ProcLogAtu("MENSAGEM","Termino Processamento SD4","Termino Processamento SD4")
Return Nil

/*/{Protheus.doc} procSC7
Busca os dados dos pedidos de compra/autoriza��o de entrega para carregar a tabela CZI.
@author lucas.franca
@since 04/06/2018
@version 1.0

@param cQueryB1		- Query para filtro dos produtos (SB1)
@param cAlmoxd		- Armaz�m de - para filtro dos pedidos de compra/autoriza��o de entrega.
@param cAlmoxa		- Armaz�m at� - para filtro dos pedidos de compra/autoriza��o de entrega.
@param dDatFim		- Data final para filtro dos pedidos de compra/autoriza��o de entrega.
@param aPeriodos	- Array com os per�odos do MRP.
@param lConsSusp	- Indicador para considerar ordens suspensas
@param lConsSacr	- Indicador para considerar ordens sacramentadas

@return Nil
/*/
Static Function procSC7(cQueryB1,cAlmoxd,cAlmoxa,dDatFim,aPeriodos,lConsSusp,lConsSacr)
	Local cQuery     := ""
	Local cInsert    := ""
	Local cBanco     := AllTrim(Upper(TcGetDb()))
	Local cComando   := "COALESCE"

	ProcLogAtu("MENSAGEM","Iniciando Processamento SC7","Iniciando Processamento SC7")

	If "MSSQL" $ cBanco
		cComando := "ISNULL"
	EndIf

	cInsert := "INSERT INTO " + RetSqlName("CZI")
	cInsert +=    "(CZI_FILIAL,"
	cInsert +=    " CZI_DTOG,"
	cInsert +=    " CZI_PERMRP,"
	cInsert +=    " CZI_NRMRP, "
	cInsert +=    " CZI_NRLV,"
	cInsert +=    " CZI_PROD,"
	cInsert +=    " CZI_NRRV,"
	cInsert +=    " CZI_ALIAS,"
	cInsert +=    " CZI_NRRGAL,"
	cInsert +=    " CZI_TPRG,"
	cInsert +=    " CZI_DOC,"
	cInsert +=    " CZI_DOCKEY,"
	cInsert +=    " CZI_ITEM,"
	cInsert +=    " CZI_QUANT,"
	cInsert +=    " CZI_OPC,"
	cInsert +=    " CZI_PRODOG,"
	cInsert +=    " CZI_OPCORD,"
	cInsert +=    " D_E_L_E_T_,"
	IF lAutoCZI
		cInsert +=    " R_E_C_N_O_,"
	EndIF
	cInsert +=    " R_E_C_D_E_L_) "


	cQuery := " SELECT '"+xFilial("CZI")+"', "   //CZI_FILIAL
	cQuery +=        gSqlNxtUti("SC7.C7_DATPRF") + ", " //CZI_DTOG
	cQuery +=        gSqlPerMRP(aPeriodos, ;
	                            "SC7.C7_DATPRF", ;
	                            dDatFim) + " ,"  //CZI_PERMRP
	cQuery +=        " '"+c711NumMRP+"',"        //CZI_NRMRP
	cQuery +=        gSqlNivPrd("SC7.C7_PRODUTO") + ;
	                 ", "                        //CZI_NRLV
	cQuery +=        " SC7.C7_PRODUTO, " //CZI_PROD
	cQuery +=        " ' ', " //CZI_NRRV
	cQuery +=        " 'SC7'," //CZI_ALIAS
	cQuery +=        " SC7.R_E_C_N_O_, " //CZI_NRRGAL
	cQuery +=        " '2', " //CZI_TPRG
	cQuery +=        " SC7.C7_NUM, " //CZI_DOC
	If cBanco == "ORACLE"
		cQuery += cComando + "(TRIM(SC7.C7_OP),' '), " //CZI_DOCKEY
	Else
		cQuery += cComando + "(SC7.C7_OP,' '), " //CZI_DOCKEY
	EndIf
	cQuery +=        " SC7.C7_ITEM, " //CZI_ITEM
	cQuery +=        " CASE WHEN SC7.C7_QUANT-SC7.C7_QUJE < 0 THEN 0 "
	cQuery +=        " ELSE SC7.C7_QUANT-SC7.C7_QUJE "
	cQuery +=        " END, " //CZI_QUANT
	cQuery +=        " NULL, " //CZI_OPC
	cQuery +=        " ' ', " //CZI_PRODOG
	cQuery +=        " ' ', " //CZI_OPCORD
	cQuery +=        " ' ', " //D_E_L_E_T_

	IF lAutoCZI
		cQuery +=        gSqlRecno("CZI","SC7.R_E_C_N_O_") + "," //R_E_C_N_O_
	EndIF
	cQuery +=        " 0 " //R_E_C_D_E_L_
	cQuery +=   " FROM " + RetSqlName("SC7")+ " SC7, " + RetSqlName("SB1") + " SB1 "
	cQuery +=  " WHERE ((SC7.C7_FILIAL  = '" + xFilial("SC7") + "' "
	cQuery +=    " AND  (SC7.C7_FILENT  = '" + xFilial("SC7") + "' "
	cQuery +=    "  OR   SC7.C7_FILENT  = '')) "
	cQuery +=    "  OR  (SC7.C7_FILIAL <> '" + xFilial("SC7") + "' "
	cQuery +=    " AND   SC7.C7_FILENT  = '" + xFilial("SC7") + "')) "
	cQuery +=    " AND SC7.C7_LOCAL    >= '" + cAlmoxd + "' "
	cQuery +=    " AND SC7.C7_LOCAL    <= '" + cAlmoxa + "' "
	cQuery +=    " AND SC7.C7_DATPRF   <= '" + Dtos(dDatFim) + "' "
	cQuery +=    " AND SC7.C7_QUJE      < SC7.C7_QUANT "
	cQuery +=    " AND SC7.C7_RESIDUO   = '" + CriaVar("C7_RESIDUO", .F.) + "' "
	cQuery +=    " AND SC7.D_E_L_E_T_   = ' ' "
	cQuery +=    " AND SC7.C7_PRODUTO   = SB1.B1_COD "

	If aAlmoxNNR # Nil
		cQuery += " AND SC7.C7_LOCAL IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
	EndIf

	If !lConsSusp .Or. !lConsSacr
		cQuery += " AND (SC7.C7_OP = ' ' "
		cQuery +=  " OR  SC7.C7_OP NOT IN ( " + MT712QNOC2(lConsSusp, lConsSacr) + ") )"
	EndIf

	cQuery += cQueryB1

	//Une o comando insert com o select tratado.
	cInsert += cQuery

	//Executa a query.
	If TcSqlExec(cInsert)
		Final("Erro na carga dos pedidos de compra/autoriza��o de entrega. ", TCSQLError() + cInsert)
	EndIf

	//Necess�rio executar a TCRefresh para atualizar o cache do DBACCESS referente a tabela CZI.
	//Se n�o for chamada esta fun��o, ocorrer� erro ao realizar uma insers�o por RecLock.
	TCRefresh(RetSqlName("CZI"))

	ProcLogAtu("MENSAGEM","Termino Processamento SC7","Termino Processamento SC7")
Return Nil

/*/{Protheus.doc} procSHC
Busca os dados do plano mestre de produ��o para carregar a tabela CZI.
@author lucas.franca
@since 07/06/2018
@version 1.0

@param cQueryB1		- Query para filtro dos produtos (SB1)
@param dDatFim		- Data final para filtro do plano mestre.
@param aPeriodos	- Array com os per�odos do MRP.

@return Nil
/*/
Static Function procSHC(cQueryB1,dDatFim,aPeriodos)
	Local cQuery     := ""
	Local cInsert    := ""
	Local cBanco     := AllTrim(Upper(TcGetDb()))
	Local cComando   := "COALESCE"

	ProcLogAtu("MENSAGEM","Iniciando Processamento SHC","Iniciando Processamento SHC")

	If "MSSQL" $ cBanco
		cComando := "ISNULL"
	EndIf

	cInsert := "INSERT INTO " + RetSqlName("CZI")
	cInsert +=    "(CZI_FILIAL,"
	cInsert +=    " CZI_DTOG,"
	cInsert +=    " CZI_PERMRP,"
	cInsert +=    " CZI_NRMRP, "
	cInsert +=    " CZI_NRLV,"
	cInsert +=    " CZI_PROD,"
	cInsert +=    " CZI_NRRV,"
	cInsert +=    " CZI_ALIAS,"
	cInsert +=    " CZI_NRRGAL,"
	cInsert +=    " CZI_TPRG,"
	cInsert +=    " CZI_DOC,"
	cInsert +=    " CZI_DOCKEY,"
	cInsert +=    " CZI_ITEM,"
	cInsert +=    " CZI_QUANT,"
	cInsert +=    " CZI_OPC,"
	cInsert +=    " CZI_PRODOG,"
	cInsert +=    " CZI_OPCORD,"
	cInsert +=    " D_E_L_E_T_,"
	IF lAutoCZI
		cInsert +=    " R_E_C_N_O_,"
	EndIF
	cInsert +=    " R_E_C_D_E_L_) "


	cQuery := " SELECT '"+xFilial("CZI")+"', "   //CZI_FILIAL
	cQuery +=        gSqlNxtUti("SHC.HC_DATA") + ", " //CZI_DTOG
	cQuery +=        gSqlPerMRP(aPeriodos, ;
	                            "SHC.HC_DATA", ;
	                            dDatFim) + " ,"  //CZI_PERMRP
	cQuery +=        " '"+c711NumMRP+"',"        //CZI_NRMRP
	cQuery +=        gSqlNivPrd("SHC.HC_PRODUTO") + ;
	                 ", "                        //CZI_NRLV
	cQuery +=        " SHC.HC_PRODUTO, " //CZI_PROD
	cQuery +=        " ' ', " //CZI_NRRV
	cQuery +=        " 'SHC'," //CZI_ALIAS
	cQuery +=        " SHC.R_E_C_N_O_, " //CZI_NRRGAL
	cQuery +=        " '2', " //CZI_TPRG
	cQuery +=        " SHC.HC_DOC, " //CZI_DOC
	cQuery +=        " ' ', " //CZI_DOCKEY
	cQuery +=        " ' ', " //CZI_ITEM
	cQuery +=        " SHC.HC_QUANT, " //CZI_QUANT
	cQuery += cComando + "(SHC.HC_MOPC,(SELECT SB1.B1_MOPC "
	cQuery +=                           " FROM " + RetSqlName("SB1") + " SB1 "
	cQuery +=                          " WHERE SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
	cQuery +=                            " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery +=                            " AND SB1.B1_COD     = SHC.HC_PRODUTO)), " //CZI_OPC
	cQuery +=        " ' ', " //CZI_PRODOG
	cQuery += cComando + "(SHC.HC_OPC,(SELECT SB1.B1_OPC "
	cQuery +=                           " FROM " + RetSqlName("SB1") + " SB1 "
	cQuery +=                          " WHERE SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
	cQuery +=                            " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery +=                            " AND SB1.B1_COD     = SHC.HC_PRODUTO)), " //CZI_OPCORD
	cQuery +=        " ' ', " //D_E_L_E_T_

	IF lAutoCZI
		cQuery +=        gSqlRecno("CZI","SHC.R_E_C_N_O_") + "," //R_E_C_N_O_
	EndIF
	cQuery +=        " 0 " //R_E_C_D_E_L_
	cQuery +=  " FROM " + RetSqlName("SHC") + " SHC, " + RetSqlName("SB1") + " SB1 "
	cQuery += " WHERE SHC.HC_FILIAL  = '" + xFilial("SHC") + "' "
	cQuery +=   " AND SHC.HC_STATUS  = '" + Space(LEN(SHC->HC_STATUS)) + "' "
	cQuery +=   " AND SHC.HC_OP      = '" + Space(Len(SHC->HC_OP)) + "' "
	cQuery +=   " AND SHC.HC_DATA   >= '" + DTOS(aPergs711[05]) + "' "
	cQuery +=   " AND SHC.HC_DATA   <= '" + DTOS(aPergs711[06]) + "' "
	cQuery +=   " AND SHC.HC_DATA   <= '" + DTOS(dDatFim) + "' "
	cQuery +=   " AND SHC.HC_DOC    >= '" + aPergs711[23] + "' "
	cQuery +=   " AND SHC.HC_DOC    <= '" + aPergs711[24] + "' "
	cQuery +=   " AND SHC.D_E_L_E_T_ = ' ' "
	cQuery +=   " AND SHC.HC_PRODUTO = SB1.B1_COD "

	cQuery += cQueryB1

	//Une o comando insert com o select tratado.
	cInsert += cQuery

	//Executa a query.
	If TcSqlExec(cInsert)
		Final("Erro na carga do plano mestre de produ��o. ", TCSQLError() + cInsert)
	EndIf

	//Necess�rio executar a TCRefresh para atualizar o cache do DBACCESS referente a tabela CZI.
	//Se n�o for chamada esta fun��o, ocorrer� erro ao realizar uma insers�o por RecLock.
	TCRefresh(RetSqlName("CZI"))

	ProcLogAtu("MENSAGEM","Termino Processamento SHC","Termino Processamento SHC")
Return Nil

/*/{Protheus.doc} procSB8
Busca os dados dos lotes vencidos para carregar a tabela CZI.
@author lucas.franca
@since 04/06/2018
@version 1.0

@param cQueryB1		- Query para filtro dos produtos (SB1)
@param cAlmoxd		- Armaz�m de - para filtro dos lotes.
@param cAlmoxa		- Armaz�m at� - para filtro dos lotes.
@param dDatFim		- Data final para filtro dos lotes.
@param aPeriodos	- Array com os per�odos do MRP.

@return Nil
/*/
Static Function procSB8(cQueryB1,cAlmoxd,cAlmoxa,dDatFim,aPeriodos)
	Local cQuery     := ""
	Local cInsert    := ""
	Local cBanco     := AllTrim(Upper(TcGetDb()))
	Local cComando   := "COALESCE"
	Local cB8DTVALID := ""

	If "MSSQL" $ cBanco
		cComando := "ISNULL"
	EndIf

	cInsert := "INSERT INTO " + RetSqlName("CZI")
	cInsert +=    "(CZI_FILIAL,"
	cInsert +=    " CZI_DTOG,"
	cInsert +=    " CZI_PERMRP,"
	cInsert +=    " CZI_NRMRP, "
	cInsert +=    " CZI_NRLV,"
	cInsert +=    " CZI_PROD,"
	cInsert +=    " CZI_NRRV,"
	cInsert +=    " CZI_ALIAS,"
	cInsert +=    " CZI_NRRGAL,"
	cInsert +=    " CZI_TPRG,"
	cInsert +=    " CZI_DOC,"
	cInsert +=    " CZI_DOCKEY,"
	cInsert +=    " CZI_ITEM,"
	cInsert +=    " CZI_QUANT,"
	cInsert +=    " CZI_OPC,"
	cInsert +=    " CZI_PRODOG,"
	cInsert +=    " CZI_OPCORD,"
	cInsert +=    " D_E_L_E_T_,"
	IF lAutoCZI
		cInsert +=    " R_E_C_N_O_,"
	EndIF
	cInsert +=    " R_E_C_D_E_L_) "

	cB8DTVALID := gSqlSomaDt("SB8.B8_DTVALID",1)

	cQuery := " SELECT '"+xFilial("CZI")+"', "   //CZI_FILIAL
	cQuery +=        gSqlNxtUti(cB8DTVALID) + ", " //CZI_DTOG
	cQuery +=        gSqlPerMRP(aPeriodos, ;
	                            cB8DTVALID, ;
	                            dDatFim) + " ,"  //CZI_PERMRP
	cQuery +=        " '"+c711NumMRP+"',"        //CZI_NRMRP
	cQuery +=        gSqlNivPrd("SB8.B8_PRODUTO") + ;
	                 ", "                        //CZI_NRLV
	cQuery +=        " SB8.B8_PRODUTO, " //CZI_PROD
	cQuery +=        " ' ', " //CZI_NRRV
	cQuery +=        " 'SB8'," //CZI_ALIAS
	cQuery +=        " SB8.R_E_C_N_O_, " //CZI_NRRGAL
	cQuery +=        " ' ', " //CZI_TPRG
	cQuery +=        " CASE WHEN (SELECT SB1.B1_RASTRO "
	cQuery +=                     " FROM " + RetSqlName("SB1") + " SB1 "
	cQuery +=                    " WHERE SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
	cQuery +=                      " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery +=                      " AND SB1.B1_COD     = SB8.B8_PRODUTO) = 'L' "
	cQuery +=             " THEN SB8.B8_LOTECTL "
	cQuery +=             " ELSE "

	If "MSSQL" $ cBanco
		cQuery += " RTRIM(SB8.B8_LOTECTL) + '/' + LTRIM(SB8.B8_NUMLOTE) "
	Else
		cQuery += " TRIM(SB8.B8_LOTECTL)||'/'||TRIM(SB8.B8_NUMLOTE) "
	EndIf

	cQuery +=        " END , " //CZI_DOC
	cQuery +=        " ' ', " //CZI_DOCKEY
	cQuery +=        " ' ', " //CZI_ITEM
	cQuery +=        " SB8.B8_SALDO, " //CZI_QUANT
	cQuery +=        " NULL, " //CZI_OPC
	cQuery +=        " ' ', " //CZI_PRODOG
	cQuery +=        " ' ', " //CZI_OPCORD
	cQuery +=        " ' ', " //D_E_L_E_T_
	IF lAutoCZI
		cQuery +=        gSqlRecno("CZI","SB8.R_E_C_N_O_") + "," //R_E_C_N_O_
	EndIF
	cQuery +=        " 0 " //R_E_C_D_E_L_
	cQuery +=   " FROM " + RetSqlName("SB8") + " SB8, " + RetSqlName("SB1") + " SB1 "
	cQuery +=  " WHERE SB8.B8_FILIAL  = '" + xFilial("SB8") + "' "
	cQuery +=    " AND SB8.B8_SALDO   > 0 "
	cQuery +=    " AND SB8.B8_LOCAL   >= '" + cAlmoxd + "' "
	cQuery +=    " AND SB8.B8_LOCAL   <= '" + cAlmoxa + "' "
	cQuery +=    " AND SB8.B8_LOCAL   <> '" + AlmoxCQ() + "' "
	cQuery +=    " AND SB8.B8_DTVALID  < '" + DTOS(aPeriodos[Len(aPeriodos)]) + "' "
	cQuery +=    " AND SB8.D_E_L_E_T_  = ' ' "
	cQuery +=    " AND SB8.B8_PRODUTO  = SB1.B1_COD "

	If aAlmoxNNR # Nil
		cQuery += " AND SB8.B8_LOCAL IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
	EndIf

	cQuery += cQueryB1

	//Une o comando insert com o select tratado.
	cInsert += cQuery

	//Executa a query.
	If TcSqlExec(cInsert)
		Final("Erro na carga dos lotes vencidos. ", TCSQLError() + cInsert)
	EndIf

	//Necess�rio executar a TCRefresh para atualizar o cache do DBACCESS referente a tabela CZI.
	//Se n�o for chamada esta fun��o, ocorrer� erro ao realizar uma insers�o por RecLock.
	TCRefresh(RetSqlName("CZI"))
Return Nil

/*/{Protheus.doc} procAFJ
Busca os dados dos empenhos de projeto para carregar a tabela CZI.
@author lucas.franca
@since 08/06/2018
@version 1.0

@param cQueryB1		- Query para filtro dos produtos (SB1)
@param dDatFim		- Data final para filtro dos empenhos de projeto.
@param aPeriodos	- Array com os per�odos do MRP.

@return Nil
/*/
Static Function procAFJ(cQueryB1,dDatFim,aPeriodos)
	Local cQuery     := ""
	Local cInsert    := ""

	ProcLogAtu("MENSAGEM","Iniciando Processamento AFJ","Iniciando Processamento AFJ")

	cInsert := "INSERT INTO " + RetSqlName("CZI")
	cInsert +=    "(CZI_FILIAL,"
	cInsert +=    " CZI_DTOG,"
	cInsert +=    " CZI_PERMRP,"
	cInsert +=    " CZI_NRMRP, "
	cInsert +=    " CZI_NRLV,"
	cInsert +=    " CZI_PROD,"
	cInsert +=    " CZI_NRRV,"
	cInsert +=    " CZI_ALIAS,"
	cInsert +=    " CZI_NRRGAL,"
	cInsert +=    " CZI_TPRG,"
	cInsert +=    " CZI_DOC,"
	cInsert +=    " CZI_DOCKEY,"
	cInsert +=    " CZI_ITEM,"
	cInsert +=    " CZI_QUANT,"
	cInsert +=    " CZI_OPC,"
	cInsert +=    " CZI_PRODOG,"
	cInsert +=    " CZI_OPCORD,"
	cInsert +=    " D_E_L_E_T_,"
	IF lAutoCZI
		cInsert +=    " R_E_C_N_O_,"
	EndIF
	cInsert +=    " R_E_C_D_E_L_) "

	cQuery := " SELECT '"+xFilial("CZI")+"', "   //CZI_FILIAL
	cQuery +=        gSqlNxtUti("AFJ.AFJ_DATA") + ", " //CZI_DTOG
	cQuery +=        gSqlPerMRP(aPeriodos, ;
	                            "AFJ.AFJ_DATA", ;
	                            dDatFim) + " ,"  //CZI_PERMRP
	cQuery +=        " '"+c711NumMRP+"',"        //CZI_NRMRP
	cQuery +=        gSqlNivPrd("AFJ.AFJ_COD") + ;
	                 ", "                        //CZI_NRLV
	cQuery +=        " AFJ.AFJ_COD, " //CZI_PROD
	cQuery +=        " ' ', " //CZI_NRRV
	cQuery +=        " 'AFJ'," //CZI_ALIAS
	cQuery +=        " AFJ.R_E_C_N_O_, " //CZI_NRRGAL
	cQuery +=        " '3', " //CZI_TPRG
	cQuery +=        " AFJ.AFJ_PROJET, " //CZI_DOC
	cQuery +=        " ' ', " //CZI_DOCKEY
	cQuery +=        " ' ', " //CZI_ITEM
	cQuery +=        " AFJ.AFJ_QEMP-AFJ.AFJ_QATU, " //CZI_QUANT
	cQuery +=        " NULL, " //CZI_OPC
	cQuery +=        " ' ', " //CZI_PRODOG
	cQuery +=        " ' ', " //CZI_OPCORD
	cQuery +=        " ' ', " //D_E_L_E_T_

	IF lAutoCZI
		cQuery +=        gSqlRecno("CZI","AFJ.R_E_C_N_O_") + "," //R_E_C_N_O_
	EndIF
	cQuery +=        " 0 " //R_E_C_D_E_L_
	cQuery +=   " FROM " + RetSqlName("AFJ") + " AFJ, " + RetSqlName("SB1") + " SB1 "
	cQuery +=  " WHERE AFJ.AFJ_FILIAL  = '" + xFilial("AFJ") + "' "
	cQuery +=    " AND AFJ.AFJ_QATU    < AFJ.AFJ_QEMP "
	cQuery +=    " AND AFJ.AFJ_DATA   <= '" + Dtos(dDatFim) + "' "
	cQuery +=    " AND AFJ.D_E_L_E_T_  = ' ' "
	cQuery +=    " AND AFJ.AFJ_COD     = SB1.B1_COD "

	cQuery += cQueryB1

	//Une o comando insert com o select tratado.
	cInsert += cQuery

	//Executa a query.
	If TcSqlExec(cInsert)
		Final("Erro na carga dos empenhos de projeto. ", TCSQLError() + cInsert)
	EndIf

	//Necess�rio executar a TCRefresh para atualizar o cache do DBACCESS referente a tabela CZI.
	//Se n�o for chamada esta fun��o, ocorrer� erro ao realizar uma insers�o por RecLock.
	TCRefresh(RetSqlName("CZI"))

	ProcLogAtu("MENSAGEM","Termino Processamento AFJ","Termino Processamento AFJ")
Return Nil

/*/{Protheus.doc} procSC6
Busca os dados dos pedidos de venda para carregar a tabela CZI.

@author lucas.franca
@since 08/06/2018
@version 1.0

@param cQueryB1		- Query para filtro dos produtos (SB1)
@param cAlmoxd		- Armaz�m de - para filtro dos pedidos de venda.
@param cAlmoxa		- Armaz�m at� - para filtro dos pedidos de venda.
@param dDatFim		- Data final para filtro dos pedidos de venda.
@param aPeriodos	- Array com os per�odos do MRP.
@param cComp1		- Filtro para busca de pedidos bloqueados (C6_BLQ).
@param cComp2		- Filtro para busca de pedidos bloqueados (C6_BLQ).

@return Nil
/*/
User Function procSC6(cQueryB1,cAlmoxd,cAlmoxa,dDatFim,aPeriodos,cComp1,cComp2)
	Local cQuery     := ""
	Local cInsert    := ""
	Local cBanco     := AllTrim(Upper(TcGetDb()))
	Local cComando   := "COALESCE"
	Local lA712SQL	 := ExistBlock("A712SQL")
	Local cA712Fil	 := ""

	ProcLogAtu("MENSAGEM","Iniciando Processamento SC6","Iniciando Processamento SC6")

	If "MSSQL" $ cBanco
		cComando := "ISNULL"
	EndIf

	cInsert := "INSERT INTO " + RetSqlName("CZI")
	cInsert +=    "(CZI_FILIAL,"
	cInsert +=    " CZI_DTOG,"
	cInsert +=    " CZI_PERMRP,"
	cInsert +=    " CZI_NRMRP, "
	cInsert +=    " CZI_NRLV,"
	cInsert +=    " CZI_PROD,"
	cInsert +=    " CZI_NRRV,"
	cInsert +=    " CZI_ALIAS,"
	cInsert +=    " CZI_NRRGAL,"
	cInsert +=    " CZI_TPRG,"
	cInsert +=    " CZI_DOC,"
	cInsert +=    " CZI_DOCKEY,"
	cInsert +=    " CZI_ITEM,"
	cInsert +=    " CZI_QUANT,"
	cInsert +=    " CZI_OPC,"
	cInsert +=    " CZI_PRODOG,"
	cInsert +=    " CZI_OPCORD,"
	cInsert +=    " D_E_L_E_T_,"
	IF lAutoCZI
		cInsert +=    " R_E_C_N_O_,"
	EndIF
	cInsert +=    " R_E_C_D_E_L_) "

	cQuery := " SELECT '"+xFilial("CZI")+"', "   //CZI_FILIAL
	cQuery +=        gSqlNxtUti("SC6.C6_ENTREG") + ", " //CZI_DTOG
	cQuery +=        gSqlPerMRP(aPeriodos, ;
	                            "SC6.C6_ENTREG", ;
	                            dDatFim) + " ,"  //CZI_PERMRP
	cQuery +=        " '"+c711NumMRP+"',"        //CZI_NRMRP
	cQuery +=        gSqlNivPrd("SC6.C6_PRODUTO") + ;
	                 ", "                        //CZI_NRLV
	cQuery +=        " SC6.C6_PRODUTO, " //CZI_PROD
	cQuery +=        " ' ', " //CZI_NRRV
	cQuery +=        " 'SC6'," //CZI_ALIAS
	cQuery +=        " SC6.R_E_C_N_O_, " //CZI_NRRGAL
	cQuery +=        " '3', " //CZI_TPRG
	cQuery +=        " SC6.C6_NUM, " //CZI_DOC
	cQuery +=        " ' ', " //CZI_DOCKEY
	cQuery +=        " SC6.C6_ITEM, " //CZI_ITEM
	cQuery +=        " CASE WHEN SC6.C6_QTDVEN-SC6.C6_QTDENT < 0 THEN 0 "
	cQuery +=             " ELSE SC6.C6_QTDVEN-SC6.C6_QTDENT "
	cQuery +=        " END, " //CZI_QUANT
	cQuery += cComando + "(SC6.C6_MOPC,(SELECT SB1.B1_MOPC "
	cQuery +=                           " FROM " + RetSqlName("SB1") + " SB1 "
	cQuery +=                          " WHERE SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
	cQuery +=                            " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery +=                            " AND SB1.B1_COD     = SC6.C6_PRODUTO)), " //CZI_OPC
	cQuery +=        " ' ', " //CZI_PRODOG
	cQuery += cComando + "(SC6.C6_OPC,(SELECT SB1.B1_OPC "
	cQuery +=                           " FROM " + RetSqlName("SB1") + " SB1 "
	cQuery +=                          " WHERE SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
	cQuery +=                            " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery +=                            " AND SB1.B1_COD     = SC6.C6_PRODUTO)), " //CZI_OPCORD
	cQuery +=        " ' ', " //D_E_L_E_T_
	IF lAutoCZI
		cQuery +=        gSqlRecno("CZI","SC6.R_E_C_N_O_") + "," //R_E_C_N_O_
	Endif

	cQuery +=        " 0 " //R_E_C_D_E_L_
	cQuery +=  " FROM " + RetSqlName("SC6") + " SC6, " + RetSqlName("SB1") + " SB1," + RetSqlName("SF4") + " SF4 "
	cQuery += U_gWhereSC6(cQueryB1,cAlmoxd,cAlmoxa,cComp1,cComp2,dDatFim,.T.)

	If lA712SQL
		cA712Fil := ExecBlock("A712SQL", .F., .F., "SC6")
		If ValType(cA712Fil) == "C"
			cQuery += " AND " + cA712Fil
		EndIf
	EndIf

	//Une o comando insert com o select tratado.
	cInsert += cQuery

	//Executa a query.
	If TcSqlExec(cInsert)
		Final("Erro na carga dos pedidos de venda. ", TCSQLError() + cInsert)
	EndIf

	//Necess�rio executar a TCRefresh para atualizar o cache do DBACCESS referente a tabela CZI.
	//Se n�o for chamada esta fun��o, ocorrer� erro ao realizar uma insers�o por RecLock.
	TCRefresh(RetSqlName("CZI"))

	ProcLogAtu("MENSAGEM","Termino Processamento SC6","Termino Processamento SC6")
Return Nil

/*/{Protheus.doc} gWhereSC6
Monta a cl�usula WHERE padr�o para busca de dados na tabela SC6.

@author lucas.franca
@since 08/06/2018
@version 1.0

@param cQueryB1		- Query para filtro dos produtos (SB1)
@param cAlmoxd		- Armaz�m de - para filtro dos pedidos de venda.
@param cAlmoxa		- Armaz�m at� - para filtro dos pedidos de venda.
@param dDatFim		- Data final para filtro dos pedidos de venda.
@param aPeriodos	- Array com os per�odos do MRP.
@param cComp1		- Filtro para busca de pedidos bloqueados (C6_BLQ).
@param cComp2		- Filtro para busca de pedidos bloqueados (C6_BLQ).
@param lVldQtd		- Indica se ser� aplicado o filtro de quantidade faturada.

@return cWhere	- Condi��o SQL para filtro da tabela SC6.
/*/
User Function gWhereSC6(cQueryB1,cAlmoxd,cAlmoxa,cComp1,cComp2,dDatFim,lVldQtd)
	Local cWhere := ""

	cWhere += " WHERE SC6.C6_FILIAL  = '" + xFilial("SC6") + "' "
	//cWhere +=   " AND SC6.C6_LOCAL  >= '" + cAlmoxd + "' "
	//cWhere +=   " AND SC6.C6_LOCAL  <= '" + cAlmoxa + "' "
	
	cWhere +=   " AND SC6.C6_LOCAL  = '" + _MVSTECK08 + "' "
		
	cWhere +=   " AND (SC6.C6_BLQ    = '" + cComp1 + "' "
	cWhere +=   "  OR  SC6.C6_BLQ    = '" + cComp2 + "') "
	cWhere +=   " AND SC6.C6_ENTREG <= '" + Dtos(dDatFim) + "' "
	cWhere +=   " AND SC6.D_E_L_E_T_ = ' ' "
	cWhere +=   " AND SC6.C6_PRODUTO = SB1.B1_COD "
	cWhere +=   " AND SF4.F4_FILIAL  = '" + xFilial("SF4") + "' "
	cWhere +=   " AND SF4.F4_CODIGO  = SC6.C6_TES "
	cWhere +=   " AND SF4.F4_ESTOQUE = 'S' "
	cWhere +=   " AND SF4.D_E_L_E_T_ = ' ' "

	If lVldQtd
		cWhere +=   " AND SC6.C6_QTDENT < SC6.C6_QTDVEN "
	EndIf

	If aPergs711[27] != 1
		cWhere += " AND SC6.C6_OP <> '02' "
	EndIf

	//If aAlmoxNNR # Nil
	//	cWhere += " AND SC6.C6_LOCAL IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
	//EndIf

	cWhere += cQueryB1
Return cWhere

/*/{Protheus.doc} procSC4
Busca os dados dos previs�es de venda para carregar a tabela CZI.

@author lucas.franca
@since 25/05/2018
@version 1.0

@param cQueryB1		- Query para filtro dos produtos (SB1)
@param cAlmoxd		- Armaz�m de - para filtro das previs�es de venda.
@param cAlmoxa		- Armaz�m at� - para filtro das previs�es de venda.
@param dDatFim		- Data final para filtro das previs�es de venda.
@param aPeriodos	- Array com os per�odos do MRP.
@param cComp1		- Filtro para busca de pedidos bloqueados (C6_BLQ).
@param cComp2		- Filtro para busca de pedidos bloqueados (C6_BLQ).

@return Nil
/*/
USER Function procSC4(cQueryB1,cAlmoxd,cAlmoxa,dDatFim,aPeriodos,cComp1,cComp2,nTipo)
	Local cQuery     := ""
	Local cInsert    := ""
	Local cBanco     := AllTrim(Upper(TcGetDb()))
	Local cComando   := "COALESCE"
	Local cAliasC4   := "PEDSC4"
	Local cAliasC6   := "PEDSC6"
	Local nQtdPed    := 0
	Local nPos       := 0
	Local aPedidos   := {}
	Local lValido    := .T.

	ProcLogAtu("MENSAGEM","Iniciando Processamento SC4","Iniciando Processamento SC4")

	If "MSSQL" $ cBanco
		cComando := "ISNULL"
	EndIf

	cInsert := "INSERT INTO " + RetSqlName("CZI")
	cInsert +=    "(CZI_FILIAL,"
	cInsert +=    " CZI_DTOG,"
	cInsert +=    " CZI_PERMRP,"
	cInsert +=    " CZI_NRMRP, "
	cInsert +=    " CZI_NRLV,"
	cInsert +=    " CZI_PROD,"
	cInsert +=    " CZI_NRRV,"
	cInsert +=    " CZI_ALIAS,"
	cInsert +=    " CZI_NRRGAL,"
	cInsert +=    " CZI_TPRG,"
	cInsert +=    " CZI_DOC,"
	cInsert +=    " CZI_DOCKEY,"
	cInsert +=    " CZI_ITEM,"
	cInsert +=    " CZI_QUANT,"
	cInsert +=    " CZI_OPC,"
	cInsert +=    " CZI_PRODOG,"
	cInsert +=    " CZI_OPCORD,"
	cInsert +=    " D_E_L_E_T_,"
	IF lAutoCZI
		cInsert +=    " R_E_C_N_O_,"
	EndIF
	cInsert +=    " R_E_C_D_E_L_) "

	cQuery := " SELECT '"+xFilial("CZI")+"', "   //CZI_FILIAL
	cQuery +=          gSqlNxtUti("SC4.C4_DATA") + ", " //CZI_DTOG
	cQuery +=          gSqlPerMRP(aPeriodos, ;
	                              "SC4.C4_DATA", ;
	                              dDatFim) + ", "  //CZI_PERMRP
	cQuery +=          " '"+c711NumMRP+"', "        //CZI_NRMRP
	cQuery +=          gSqlNivPrd("SC4.C4_PRODUTO") + ;
	                   " , "                        //CZI_NRLV
	cQuery +=          " SC4.C4_PRODUTO, " //CZI_PROD
	cQuery +=          " ' ', " //CZI_NRRV
	cQuery +=          " 'SC4'," //CZI_ALIAS
	cQuery +=          " SC4.R_E_C_N_O_, " //CZI_NRRGAL
	cQuery +=          " '3', " //CZI_TPRG
	cQuery +=          " SC4.C4_DOC, " //CZI_DOC
	cQuery +=          " ' ', " //CZI_DOCKEY
	cQuery +=          " ' ', " //CZI_ITEM
	cQuery +=          " SC4.C4_QUANT, " //CZI_QUANT
	cQuery += cComando + "(SC4.C4_MOPC,(SELECT SB1.B1_MOPC "
	cQuery +=                           " FROM " + RetSqlName("SB1") + " SB1 "
	cQuery +=                          " WHERE SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
	cQuery +=                            " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery +=                            " AND SB1.B1_COD     = SC4.C4_PRODUTO)) OPC, " //CZI_OPC
	cQuery +=          " ' ', " //CZI_PRODOG
	cQuery += cComando + "(SC4.C4_OPC,(SELECT SB1.B1_OPC "
	cQuery +=                           " FROM " + RetSqlName("SB1") + " SB1 "
	cQuery +=                          " WHERE SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
	cQuery +=                            " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery +=                            " AND SB1.B1_COD     = SC4.C4_PRODUTO)), " //CZI_OPCORD
	cQuery +=          " ' ', " //D_E_L_E_T_
	IF lAutoCZI
		cQuery +=          gSqlRecno("CZI","SC4.R_E_C_N_O_") + ", " //R_E_C_N_O_
	Endif
	cQuery +=          " 0 " //R_E_C_D_E_L_
	cQuery +=   " FROM " + RetSqlName("SC4") + " SC4, " + RetSqlName("SB1") + " SB1 "
	cQuery +=  " WHERE SC4.C4_FILIAL  = '" + xFilial("SC4") + "' "
	cQuery +=    " AND SC4.C4_DATA   >= '" + DTOS(aPergs711[05]) + "' "
	cQuery +=    " AND SC4.C4_DATA   <= '" + DTOS(aPergs711[06]) + "' "
	//cQuery +=    " AND SC4.C4_LOCAL  >= '" + cAlmoxd + "' "
	//cQuery +=    " AND SC4.C4_LOCAL  <= '" + cAlmoxa + "' "
	// FMT - CONSULTORIA
	cQuery +=    " AND SC4.C4_LOCAL  = '" + _MVSTECK08 + "' "
	//cQuery +=    " AND SC4.C4_LOCAL  <= '" + _MVSTECK08 + "' "
	// FMT - CONSULTORIA
	cQuery +=    " AND SC4.C4_DOC    >= '" + aPergs711[23] + "' "
	cQuery +=    " AND SC4.C4_DOC    <= '" + aPergs711[24] + "' "
	cQuery +=    " AND SC4.C4_DATA   <= '" + Dtos(dDatFim) + "' "
	cQuery +=    " AND SC4.D_E_L_E_T_ = ' ' "
	cQuery +=    " AND SC4.C4_PRODUTO = SB1.B1_COD "

	//If aAlmoxNNR # Nil
	//	cQuery += " AND SC4.C4_LOCAL IN (SELECT NR_LOCAL FROM " +cNomCZINNR +") "
	//EndIf

	cQuery += cQueryB1

	//Une o comando insert com o select tratado.
	cInsert += cQuery

	//Executa a query.
	If TcSqlExec(cInsert)
		Final("Erro na carga das previs�es de venda. ", TCSQLError() + cInsert)
	EndIf

	//Necess�rio executar a TCRefresh para atualizar o cache do DBACCESS referente a tabela CZI.
	//Se n�o for chamada esta fun��o, ocorrer� erro ao realizar uma insers�o por RecLock.
	TCRefresh(RetSqlName("CZI"))

	//Atualiza a quantidade das previs�es de venda, de acordo com os pedidos de venda.
	If aPergs711[17] == 1 .Or. aPergs711[30] == 1
		cQuery := " SELECT CZI.R_E_C_N_O_ RECCZI, "
		cQuery +=        " SC4.R_E_C_N_O_ RECSC4 "
		cQuery +=   " FROM " + RetSqlName("CZI") + " CZI, "
		cQuery +=              RetSqlName("SC4") + " SC4 "
		cQuery +=  " WHERE CZI.CZI_FILIAL = '"+xFilial("CZI")+"' "
		cQuery +=    " AND CZI.D_E_L_E_T_ = ' ' "
		cQuery +=    " AND CZI.CZI_ALIAS  = 'SC4' "
		cQuery +=    " AND SC4.C4_FILIAL  = '"+xFilial("SC4")+"' "
		cQuery +=    " AND SC4.D_E_L_E_T_ = ' ' "
		cQuery +=    " AND SC4.R_E_C_N_O_ = CZI.CZI_NRRGAL "
		cQuery +=    " AND EXISTS( SELECT 1 "
		cQuery +=                  " FROM " + RetSqlName("SC6") + " SC6, " + RetSqlName("SB1") + " SB1," + RetSqlName("SF4") + " SF4 "
		cQuery +=                  gWhereSC6(cQueryB1,cAlmoxd,cAlmoxa,cComp1,cComp2,dDatFim,aPergs711[30] != 1)
		cQuery +=                   " AND SC6.C6_PRODUTO = SC4.C4_PRODUTO "
		cQuery +=                   " AND SC6.C6_ENTREG <> ' ' "
		cQuery +=                  gWhereSC4(nTipo)
		cQuery +=                   " AND ((SC6.C6_MOPC IS NULL AND SC4.C4_MOPC IS NULL) "
		cQuery +=                   "  OR  (SC6.C6_OPC   = SC4.C4_OPC) "
		If cBanco == "ORACLE"
			cQuery +=               "  OR  (dbms_lob.compare(SC6.C6_MOPC,SC4.C4_MOPC)=0) ) )"
		Else
			cQuery +=               "  OR  (SC6.C6_MOPC  = SC4.C4_MOPC) ) )"
		EndIf

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasC4,.T.,.T.)
		
		While (cAliasC4)->(!Eof())			
			CZI->(dbGoTo((cAliasC4)->(RECCZI)))
			nQtdPed := 0

			cQuery := " SELECT SC6.C6_DATFAT, "
			cQuery +=        " SC6.C6_QTDVEN, "
			cQuery +=        " SC6.C6_QTDENT, "
			cQuery +=        " SC6.R_E_C_N_O_ RECSC6"
			cQuery +=  " FROM " + RetSqlName("SC6") + " SC6, "
			cQuery +=             RetSqlName("SB1") + " SB1, "
			cQuery +=             RetSqlName("SF4") + " SF4, "
			cQuery +=             RetSqlName("SC4") + " SC4  "
			cQuery += gWhereSC6(cQueryB1,cAlmoxd,cAlmoxa,cComp1,cComp2,dDatFim,aPergs711[30] != 1)
			cQuery +=   " AND SC4.R_E_C_N_O_ = " + cValToChar((cAliasC4)->(RECSC4))
			cQuery +=   " AND SC6.C6_PRODUTO = SC4.C4_PRODUTO "
			cQuery +=   " AND SC6.C6_ENTREG <> ' ' "
			cQuery +=     gWhereSC4(nTipo)
			cQuery +=   " AND ((SC6.C6_MOPC IS NULL AND SC4.C4_MOPC IS NULL) "
			cQuery +=   "  OR  (SC6.C6_OPC   = SC4.C4_OPC) "
			If cBanco == "ORACLE"
				cQuery += " OR  (dbms_lob.compare(SC6.C6_MOPC,SC4.C4_MOPC)=0) ) "
			Else
				cQuery += " OR  (SC6.C6_MOPC  = SC4.C4_MOPC) ) "
			EndIf


			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasC6,.T.,.T.)

			While (cAliasC6)->(!Eof())
				nQtdPed := 0
				nPos := aScan(aPedidos,{|x| x[1] == (cAliasC6)->(RECSC6) })
				If nPos <= 0
					lValido := .T.
					If aPergs711[30] == 1
						If (cAliasC6)->(C6_QTDENT) > 0
			            	If !Empty(aPergs711[33]) .And. !Empty(aPergs711[34])
			                	If !(StoD((cAliasC6)->(C6_DATFAT)) >= aPergs711[33] .And. StoD((cAliasC6)->(C6_DATFAT)) <= Iif(aPergs711[34]<dDatFim,aPergs711[34],dDatFim))
			                    	lValido := .F.
			                  	EndIf
			               	EndIf
			               	If !Empty(aPergs711[33]) .And. Empty(aPergs711[34])
			                	If !(StoD((cAliasC6)->(C6_DATFAT)) >= aPergs711[33] .And. StoD((cAliasC6)->(C6_DATFAT)) <= dDatFim)
			                    	lValido := .F.
			                  	EndIf
			               	EndIf
			               	If Empty(aPergs711[33]) .And. !Empty(aPergs711[34])
			                	If !(StoD((cAliasC6)->(C6_DATFAT)) <= Iif(aPergs711[34]<dDatFim,aPergs711[34],dDatFim))
			                    	lValido := .F.
			                  	EndIf
			               	EndIf
						Else
				        	lValido := .F.
				        EndIf
					EndIf

					If aPergs711[17] == 1 //Se subtrai os pedidos de venda colocados da previs�o.
						nQtdPed += (cAliasC6)->(C6_QTDVEN-C6_QTDENT)
					EndIf
					//Se subtrai os pedidos de venda faturados da previs�o E
					//o pedido est� em uma data v�lida para subtrair (par�metros 33 e 34).
					If aPergs711[30] == 1 .And. lValido
						nQtdPed += (cAliasC6)->(C6_QTDENT)
					EndIf

					aAdd(aPedidos,{(cAliasC6)->(RECSC6),nQtdPed})
					nPos := Len(aPedidos)
				EndIf

				If aPedidos[nPos,2] <= 0
					(cAliasC6)->(dbSkip())
					Loop
				EndIf

				If aPedidos[nPos,2] >= CZI->CZI_QUANT
					aPedidos[nPos,2] -= CZI->CZI_QUANT
					cQuery := " DELETE FROM " + RetSqlName("CZI")
					cQuery += " WHERE R_E_C_N_O_ = " + cValToChar((cAliasC4)->(RECCZI))
					If TcSqlExec(cQuery)
						Final("Erro na carga das previs�es de venda. ", TCSQLError() + cQuery)
					EndIf
					Exit
				Else
					RecLock("CZI",.F.)
						CZI->CZI_QUANT := CZI->CZI_QUANT - aPedidos[nPos,2]
					CZI->(MsUnLock())
					aPedidos[nPos,2] := 0
				EndIf

				(cAliasC6)->(dbSkip())
			End

			(cAliasC6)->(dbCloseArea())
			(cAliasC4)->(dbSkip())
		End
		(cAliasC4)->(dbCloseArea())
		TCRefresh(RetSqlName("CZI"))
	EndIf

	ProcLogAtu("MENSAGEM","Termino Processamento SC4","Termino Processamento SC4")
Return Nil

/*/{Protheus.doc} gWhereSC4
Monta a cl�usula WHERE padr�o para relacionamento dos campos C4_DATA e C6_ENTREG

@author juliana.oliveira
@since 08/04/2020
@version 1.0

@param nTipo		- Periodicidade do MRP

@return cWhere	- Condi��o SQL para relacionamento dos campos C4_DATA e C6_ENTREG.
/*/
Static Function gWhereSC4(nTipo)
	Local cQryAno	:= ""
	Local cQryMes	:= ""
	Local cWhere	:= ""
	Local cBanco	:= ""

	Default lAutomacao  := .F.
	
	If !lAutomacao
		cBanco	:= AllTrim(Upper(TcGetDb()))
	EndIf
	
	If cBanco == "POSTGRES"
	    cQryAno := " OR DATE_PART('YEAR' , TO_DATE(SC4.C4_DATA,'YYYYMMDD')) = DATE_PART('YEAR' , TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) "
	    cQryMes := " AND DATE_PART('MONTH', TO_DATE(SC4.C4_DATA,'YYYYMMDD')) = DATE_PART('MONTH', TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) "
	ElseIf cBanco == "ORACLE"
	   	cQryAno := " OR EXTRACT(YEAR  FROM TO_DATE(SC4.C4_DATA,'YYYYMMDD')) = EXTRACT(YEAR  FROM TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) "
	   	cQryMes := " AND EXTRACT(MONTH FROM TO_DATE(SC4.C4_DATA,'YYYYMMDD')) = EXTRACT(MONTH FROM TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) "
	Else
	   	cQryAno := " OR YEAR( CAST(SC4.C4_DATA   AS DATE)) = YEAR( CAST(SC6.C6_ENTREG AS DATE)) "
	   	cQryMes := " AND MONTH(CAST(SC4.C4_DATA   AS DATE)) = MONTH(CAST(SC6.C6_ENTREG AS DATE)) "
	EndIf

	cWhere += " AND ((C4_DATA <= '" + DtoS(aPeriodos[1]) +"' "
	cWhere += " AND   C6_ENTREG <= '" + DtoS(aPeriodos[1]) +"') "

	Do Case
	    Case nTipo == 1 //Di�rio
	        cWhere += " OR SC6.C6_ENTREG = SC4.C4_DATA) "
	    Case nTipo == 2 //Semanal
			If cBanco $ "POSTGRES|ORACLE"
				// A convers�o TO_CHAR(TO_DATE(SC4.C4_DATA,'YYYYMMDD'), 'IYYY-IW') retorna
				// o valor do ANO + N�mero da semana.
				//Exemplo: Data '20190101'. A convers�o ir� retornar o valor 2019-01, sendo '01' o n�mero da semana no ano.
				cWhere +=   " OR TO_CHAR(TO_DATE(SC4.C4_DATA,'YYYYMMDD'), 'IYYY-IW') = TO_CHAR(TO_DATE(SC6.C6_ENTREG,'YYYYMMDD'), 'IYYY-IW')) " //Compara se a data da SC4 e SC6 est�o na mesma semana.
			Else
				cWhere += cQryAno //Compara o ANO da SC6 e da SC4
				cWhere +=   " AND DATEPART(WEEK, CAST(SC4.C4_DATA AS DATE)) = DATEPART(WEEK, CAST(SC6.C6_ENTREG AS DATE))) " // Compara se a data da SC4 e SC6 est�o na mesma semana do ano.
			EndIf
	    Case nTipo == 3 //Quinzenal
	    	cWhere += cQryAno //Compara o ANO da SC6 e da SC4
			cWhere += cQryMes //Compara o M�S da SC6 e da SC4
			If cBanco == "POSTGRES"
				cWhere +=   " AND ((DATE_PART('DAY', TO_DATE(SC4.C4_DATA,'YYYYMMDD'))   BETWEEN 1  AND 15 "  //Compara se os dias da SC6 e SC4 est�o na primeira quinzena do m�s
    			cWhere +=   " AND   DATE_PART('DAY', TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 1  AND 15) " //Compara se os dias da SC6 e SC4 est�o na primeira quinzena do m�s
				cWhere +=   "  OR  (DATE_PART('DAY', TO_DATE(SC4.C4_DATA,'YYYYMMDD'))   BETWEEN 16 AND 31 "   //Compara se os dias da SC6 e SC4 est�o na segunda quinzena do m�s
				cWhere +=   " AND   DATE_PART('DAY', TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 16 AND 31)) " //Compara se os dias da SC6 e SC4 est�o na segunda quinzena do m�s
			ElseIf cBanco == "ORACLE"
				cWhere +=   " AND ((EXTRACT(DAY FROM TO_DATE(SC4.C4_DATA  ,'YYYYMMDD')) BETWEEN 1  AND 15 "  //Compara se os dias da SC6 e SC4 est�o na primeira quinzena do m�s
				cWhere +=   " AND   EXTRACT(DAY FROM TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 1  AND 15) " //Compara se os dias da SC6 e SC4 est�o na primeira quinzena do m�s
				cWhere +=   "  OR  (EXTRACT(DAY FROM TO_DATE(SC4.C4_DATA  ,'YYYYMMDD')) BETWEEN 16 AND 31 "   //Compara se os dias da SC6 e SC4 est�o na segunda quinzena do m�s
				cWhere +=   " AND   EXTRACT(DAY FROM TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 16 AND 31)) " //Compara se os dias da SC6 e SC4 est�o na segunda quinzena do m�s
			Else
				cWhere +=   " AND ((DAY(CAST(SC4.C4_DATA   AS DATE)) BETWEEN 1  AND 15 "  //Compara se os dias da SC6 e SC4 est�o na primeira quinzena do m�s
				cWhere +=   " AND   DAY(CAST(SC6.C6_ENTREG AS DATE)) BETWEEN 1  AND 15) " //Compara se os dias da SC6 e SC4 est�o na primeira quinzena do m�s
				cWhere +=   "  OR  (DAY(CAST(SC4.C4_DATA   AS DATE)) BETWEEN 16 AND 31 "   //Compara se os dias da SC6 e SC4 est�o na segunda quinzena do m�s
				cWhere +=   " AND   DAY(CAST(SC6.C6_ENTREG AS DATE)) BETWEEN 16 AND 31)) " //Compara se os dias da SC6 e SC4 est�o na segunda quinzena do m�s
			EndIf
			cWhere += " ) "
		Case nTipo == 4 //Mensal
			cWhere += cQryAno //Compara o ANO da SC6 e da SC4
			cWhere += cQryMes //Compara o M�S da SC6 e da SC4
			cWhere += " ) "
		Case nTipo == 5 //Trimestral
			cWhere += cQryAno //Compara o ANO da SC6 e da SC4
			If cBanco == "POSTGRES"
				cWhere +=   " AND ((DATE_PART('MONTH', TO_DATE(SC4.C4_DATA,'YYYYMMDD'))   BETWEEN 1   AND 3 "    //Compara se os dias da SC6 e SC4 est�o no primeiro trimestre do ano
    			cWhere +=   " AND   DATE_PART('MONTH', TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 1   AND 3) "   //Compara se os dias da SC6 e SC4 est�o no primeiro trimestre do ano
    			cWhere +=   "  OR  (DATE_PART('MONTH', TO_DATE(SC4.C4_DATA,'YYYYMMDD'))   BETWEEN 4   AND 6 "    //Compara se os dias da SC6 e SC4 est�o no segundo trimestre do ano
    			cWhere +=   " AND   DATE_PART('MONTH', TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 4   AND 6) "   //Compara se os dias da SC6 e SC4 est�o no segundo trimestre do ano
    			cWhere +=   "  OR  (DATE_PART('MONTH', TO_DATE(SC4.C4_DATA,'YYYYMMDD'))   BETWEEN 7   AND 9 "    //Compara se os dias da SC6 e SC4 est�o no terceiro trimestre do ano
    			cWhere +=   " AND   DATE_PART('MONTH', TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 7   AND 9) "   //Compara se os dias da SC6 e SC4 est�o no terceiro trimestre do ano
				cWhere +=   "  OR  (DATE_PART('MONTH', TO_DATE(SC4.C4_DATA,'YYYYMMDD'))   BETWEEN 10  AND 12 "   //Compara se os dias da SC6 e SC4 est�o no quarto trimestre do ano
				cWhere +=   " AND   DATE_PART('MONTH', TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 10  AND 12))) " //Compara se os dias da SC6 e SC4 est�o no quarto trimestre do ano
			ElseIf cBanco == "ORACLE"
				cWhere +=   " AND ((EXTRACT(MONTH FROM TO_DATE(SC4.C4_DATA  ,'YYYYMMDD')) BETWEEN 1  AND 3 "     //Compara se os dias da SC6 e SC4 est�o no primeiro trimestre do ano
				cWhere +=   " AND   EXTRACT(MONTH FROM TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 1  AND 3) "    //Compara se os dias da SC6 e SC4 est�o no primeiro trimestre do ano
				cWhere +=   "  OR  (EXTRACT(MONTH FROM TO_DATE(SC4.C4_DATA  ,'YYYYMMDD')) BETWEEN 4  AND 6 "     //Compara se os dias da SC6 e SC4 est�o no segundo trimestre do ano
				cWhere +=   " AND   EXTRACT(MONTH FROM TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 4  AND 6) "    //Compara se os dias da SC6 e SC4 est�o no segundo trimestre do ano
				cWhere +=   "  OR  (EXTRACT(MONTH FROM TO_DATE(SC4.C4_DATA  ,'YYYYMMDD')) BETWEEN 7  AND 9 "     //Compara se os dias da SC6 e SC4 est�o no terceiro trimestre do ano
				cWhere +=   " AND   EXTRACT(MONTH FROM TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 7  AND 9) "    //Compara se os dias da SC6 e SC4 est�o no terceiro trimestre do ano
				cWhere +=   "  OR  (EXTRACT(MONTH FROM TO_DATE(SC4.C4_DATA  ,'YYYYMMDD')) BETWEEN 10  AND 12 "   //Compara se os dias da SC6 e SC4 est�o no quarto trimestre do ano
				cWhere +=   " AND   EXTRACT(MONTH FROM TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 10  AND 12))) " //Compara se os dias da SC6 e SC4 est�o no quarto trimestre do ano
			Else
				cWhere +=   " AND DATEPART(QUARTER, CAST(SC4.C4_DATA AS DATE)) = DATEPART(QUARTER, CAST(SC6.C6_ENTREG AS DATE))) " // Compara se a data da SC4 e SC6 est�o no mesmo trimestre do ano.
			EndIf
		Case nTipo == 6 //Semestral
			cWhere += cQryAno //Compara o ANO da SC6 e da SC4
			If cBanco == "POSTGRES"
			   	cWhere +=   " AND ((DATE_PART('MONTH', TO_DATE(SC4.C4_DATA,'YYYYMMDD'))   BETWEEN 1  AND 6 "    //Compara se os dias da SC6 e SC4 est�o no primeiro semestre do ano
    			cWhere +=   " AND   DATE_PART('MONTH', TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 1  AND 6) "   //Compara se os dias da SC6 e SC4 est�o no primeiro semestre do ano
				cWhere +=   "  OR  (DATE_PART('MONTH', TO_DATE(SC4.C4_DATA,'YYYYMMDD'))   BETWEEN 7  AND 12 "   //Compara se os dias da SC6 e SC4 est�o no segundo semestre do ano
				cWhere +=   " AND   DATE_PART('MONTH', TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 7  AND 12)) " //Compara se os dias da SC6 e SC4 est�o no segundo semestre do ano
			ElseIf cBanco == "ORACLE"
			   	cWhere +=   " AND ((EXTRACT(MONTH FROM TO_DATE(SC4.C4_DATA  ,'YYYYMMDD')) BETWEEN 1  AND 6 "    //Compara se os dias da SC6 e SC4 est�o no primeiro semestre do ano
				cWhere +=   " AND   EXTRACT(MONTH FROM TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 1  AND 6) "   //Compara se os dias da SC6 e SC4 est�o no primeiro semestre do ano
				cWhere +=   "  OR  (EXTRACT(MONTH FROM TO_DATE(SC4.C4_DATA  ,'YYYYMMDD')) BETWEEN 7  AND 12 "   //Compara se os dias da SC6 e SC4 est�o no segundo semestre do ano
				cWhere +=   " AND   EXTRACT(MONTH FROM TO_DATE(SC6.C6_ENTREG,'YYYYMMDD')) BETWEEN 7  AND 12)) " //Compara se os dias da SC6 e SC4 est�o no segundo semestre do ano
			Else
				cWhere +=   " AND ((DATEPART(MONTH, CAST(SC4.C4_DATA AS DATE))   BETWEEN 1  AND 6 "    //Compara se os dias da SC6 e SC4 est�o no primeiro semestre do ano
				cWhere +=   " AND   DATEPART(MONTH, CAST(SC6.C6_ENTREG AS DATE)) BETWEEN 1  AND 6) "   //Compara se os dias da SC6 e SC4 est�o no primeiro semestre do ano
				cWhere +=   "  OR  (DATEPART(MONTH, CAST(SC4.C4_DATA AS DATE))   BETWEEN 7  AND 12 "   //Compara se os dias da SC6 e SC4 est�o no segundo semestre do ano
				cWhere +=   " AND   DATEPART(MONTH, CAST(SC6.C6_ENTREG AS DATE)) BETWEEN 7  AND 12)) " //Compara se os dias da SC6 e SC4 est�o no segundo semestre do ano
				cWhere += " ) "
			EndIf
		Case nTipo == 7 //Diversos
	       	cWhere += " OR SC6.C6_ENTREG = SC4.C4_DATA) "
	EndCase

Return cWhere

/*/{Protheus.doc} procTabMRP
Cria os registros necess�rios na tabela CZJ e CZK, com base nos dados existentes na tabela CZI.
Utilizado somente para alimentar a tabela CZJ e CZK quando for utilizado o comando INSERT/SELECT para cria��o da CZI.

@author lucas.franca
@since 25/05/2018
@version 1.0

@return Nil
/*/
Static Function procTabMRP()
	Local cQuery    := ""
	Local cInsert   := ""
	Local cBanco    := AllTrim(Upper(TcGetDb()))

	//Primeiro cria a CZJ para os produtos que possuem opcionais.
		ProcLogAtu("MENSAGEM","INICIO - procOpcMrp - Cria tabela CZJ OPC ","Rotina - procOpcMrp - Cria tabela CZJ OPC ")
		procOpcMrp()
		ProcLogAtu("MENSAGEM","FIM - procOpcMrp - Cria tabela CZJ OPC ","Rotina - procOpcMrp - Cria tabela CZJ OPC ")

	cInsert := " INSERT INTO " + RetSqlName("CZJ")
	cInsert +=      "(CZJ_FILIAL,"
	cInsert +=      " CZJ_NRMRP,"
	cInsert +=      " CZJ_NRLV,"
	cInsert +=      " CZJ_PROD,"
	cInsert +=      " CZJ_OPCORD,"
	cInsert +=      " CZJ_NRRV,"
	cInsert +=      " CZJ_OPC,"
	cInsert +=      " CZJ_MOPC,"
	cInsert +=      " D_E_L_E_T_,"
	IF lAutoCZJ
		cInsert +=      " R_E_C_N_O_,"
	EndIF

	cInsert +=      " R_E_C_D_E_L_)"

	cQuery := " SELECT PRDCZI.FILIAL, "  //CZJ_FILIAL
	cQuery +=        " PRDCZI.NRMRP, "   //CZJ_NRMRP
	cQuery +=        " PRDCZI.NIVEL, "   //CZJ_NRLV
	cQuery +=        " PRDCZI.PRODUTO, " //CZJ_PROD
	cQuery +=        " PRDCZI.OPCORD, "  //CZJ_OPCORD
	cQuery +=        " PRDCZI.REVISAO, " //CZJ_NRRV
	cQuery +=        " PRDCZI.OPC, "     //CZJ_OPC
	cQuery +=        " NULL, "           //CZJ_MOPC
	cQuery +=        " ' ', " //D_E_L_E_T_
	IF lAutoCZJ
		cQuery +=        gSqlRecno("CZJ","PRDCZI.PRODUTO") + "," //R_E_C_N_O_
	EndIF
	cQuery +=        " 0 "    //R_E_C_D_E_L_
	cQuery += "  FROM ( "
	cQuery += " SELECT DISTINCT '" + xFilial("CZJ") + "' AS FILIAL, "  //CZJ_FILIAL
	cQuery +=                 " '"+c711NumMRP+"'         AS NRMRP, "   //CZJ_NRMRP
	cQuery +=                 " CZI.CZI_NRLV             AS NIVEL, "   //CZJ_NRLV
	cQuery +=                 " CZI.CZI_PROD             AS PRODUTO, " //CZJ_PROD
	cQuery +=                 " CZI.CZI_OPCORD           AS OPCORD, "  //CZJ_OPCORD
	cQuery +=                 " CZI.CZI_NRRV             AS REVISAO, " //CZJ_NRRV
	If cBanco == 'POSTGRES'
		cQuery +=             " CAST(' ' AS BYTEA)       AS OPC " //CZJ_OPC
	ElseIf cBanco == "ORACLE"
		cQuery +=             " utl_raw.cast_to_raw(' ') AS OPC " //CZJ_OPC
	Else
		cQuery +=             " CONVERT(varbinary(max), ' ') AS OPC " //CZJ_OPC
	EndIf
	cQuery +=   " FROM " + RetSqlName("CZI") + " CZI "
	cQuery +=  " WHERE CZI.CZI_FILIAL = '" + xFilial("CZI") + "'"
	cQuery +=    " AND CZI.D_E_L_E_T_ = ' ' "
	cQuery +=    " AND CZI.CZI_ALIAS <> ' ' "
	cQuery +=    " AND CZI.CZI_PROD  <> ' ' "
	cQuery +=    " AND (CZI.CZI_OPCORD = ' ' AND CZI.CZI_OPC IS NULL)"
	cQuery +=    " AND NOT EXISTS ( SELECT 1 "
	cQuery +=                       " FROM " + RetSqlName("CZJ") + " CZJEXT "
	cQuery +=                      " WHERE CZJEXT.CZJ_FILIAL = '" + xFilial("CZJ") + "'"
	cQuery +=                        " AND CZJEXT.D_E_L_E_T_ = ' ' "
	cQuery +=                        " AND CZJEXT.CZJ_PROD   = CZI.CZI_PROD "
	cQuery +=                        " AND CZJEXT.CZJ_OPCORD = CZI.CZI_OPCORD "
	cQuery +=                        " AND CZJEXT.CZJ_NRRV   = CZI.CZI_NRRV )"
	If cBanco == "ORACLE"
		cQuery += " ) PRDCZI "
	Else
		cQuery += " ) as PRDCZI "
	EndIf

	//Une o comando insert com o select tratado.
	cInsert += cQuery

	//Executa a query.
	If TcSqlExec(cInsert) < 0
		Final("Erro na carga da tabela CZJ. ", TCSQLError() + cInsert)
	EndIf

	//Necess�rio executar a TCRefresh para atualizar o cache do DBACCESS referente a tabela CZJ.
	//Se n�o for chamada esta fun��o, ocorrer� erro ao realizar uma insers�o por RecLock.
	TCRefresh(RetSqlName("CZJ"))

	//Executa a carga da tabela CZK com as quantidades dos documentos.
	procCZK()
Return Nil


/*/{Protheus.doc} procOpcMrp
Cria a tabela CZJ para os produtos que possuem opcionais

@author lucas.franca
@since 11/06/2018
@version 1.0
@return Nil
/*/
Static Function procOpcMrp()
	Local cQuery    := ""
	Local cAlias    := "CZJOPC"
	Local cGrupos   := ""
	Local cStrTipo  := ""
	Local cStrGrupo := ""
	Local nX        := 0

	For nX := 1 To Len(a711Tipo)
		If a711Tipo[nX,1]
			cStrTipo += SubStr(a711Tipo[nX,2],1,nTamTipo711)+"|"
		EndIf
	Next nX

	cStrGrupo := Criavar("B1_GRUPO",.f.)+"|"
	For nX := 1 To Len(a711Grupo)
		If a711Grupo[nX,1]
			cStrGrupo += SubStr(a711Grupo[nX,2],1,nTamGr711)+"|"
		EndIf
	Next nX

	cQuery := " SELECT CZI.R_E_C_N_O_ REC "
	cQuery +=   " FROM " + RetSqlName("CZI") + " CZI "
	cQuery +=  " WHERE CZI.CZI_FILIAL = '" + xFilial("CZI") + "' "
	cQuery +=    " AND CZI.D_E_L_E_T_ = ' ' "
	cQuery +=    " AND CZI.CZI_ALIAS <> 'PAR' "
	cQuery +=    " AND (CZI.CZI_OPCORD <> ' ' OR CZI.CZI_OPC IS NOT NULL) "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	While (cAlias)->(!Eof())
		CZI->(dbGoTo((cAlias)->(REC)))

		//Necess�rio tratar aqui para o banco POSTGRES, que salva o campo MEMO com valores no banco, mesmo que seja valor NULL.
		If Empty(CZI->CZI_OPC) .And. Empty(CZI->CZI_OPCORD)
			(cAlias)->(DBSKIP())
			Loop
		EndIf

		IF lMopcGRV
				cMopcGrv := BuscaMopc(CZI->CZI_OPC)
				cGrupos := A712EstOpc(CZI->CZI_PROD,MontaOpc(cMopcGrv),Nil,Nil,cStrTipo,cStrGrupo)
				cOpc := IIf(Empty(cGrupos),"",A712AvlOpc(MontaOpc(cMopcGrv,CZI->CZI_PROD,CZI->CZI_NRLV),cGrupos))
		ELSE
				cGrupos := A712EstOpc(CZI->CZI_PROD,MontaOpc(CZI->CZI_OPC),Nil,Nil,cStrTipo,cStrGrupo)
				cOpc := IIf(Empty(cGrupos),"",A712AvlOpc(MontaOpc(CZI->CZI_OPC,CZI->CZI_PROD,CZI->CZI_NRLV),cGrupos))
		ENDIF

		If cOpc <> CZI->CZI_OPCORD
			RecLock("CZI",.F.)
				CZI->CZI_OPCORD := cOpc
			CZI->(MsUnLock())
		EndIf

		IF lMopcGRV
      A712CriCZJ(CZI->CZI_PROD,CZI->CZI_OPCORD,CZI->CZI_NRRV,CZI->CZI_NRLV,CZI->CZI_PERMRP,CZI->CZI_QUANT,CZI->CZI_TPRG,;
			CZI->CZI_ALIAS,.F.,cStrTipo,cStrGrupo,.F.,cMopcGrv,,.F.)
    Else
      A712CriCZJ(CZI->CZI_PROD,CZI->CZI_OPCORD,CZI->CZI_NRRV,CZI->CZI_NRLV,CZI->CZI_PERMRP,CZI->CZI_QUANT,CZI->CZI_TPRG,;
			CZI->CZI_ALIAS,.F.,cStrTipo,cStrGrupo,.F.,CZI->CZI_OPC,,.F.)
    EndIF

		(cAlias)->(DBSKIP())
	End
	(cAlias)->(dbCloseArea())
Return Nil

/*/{Protheus.doc} procCZK
Cria os registros necess�rios na tabela CZK, com base nos dados existentes na tabela CZI.
Utilizado somente para alimentar a tabela CZK quando for utilizado o comando INSERT/SELECT para cria��o da CZI.

@author lucas.franca
@since 25/05/2018
@version 1.0

@return Nil
/*/
Static Function procCZK()
	Local cQuery    := ""
	Local cInsert   := ""
	Local cNameCZK  := RetSqlName("CZK")
	Local cCondUpd  := ""
	Local cBanco    := AllTrim(Upper(TcGetDb()))
	//Primeiro alimenta a tabela CZK com quantidade zerada, para os per�odos que existem
	//na tabela CZI mas n�o existem na tabela CZK.

	cInsert := " INSERT INTO " + cNameCZK
	cInsert +=   "(CZK_FILIAL, "
	cInsert +=   " CZK_NRMRP, "
	cInsert +=   " CZK_RGCZJ, "
	cInsert +=   " CZK_PERMRP, "
	cInsert +=   " CZK_QTSLES, "
	cInsert +=   " CZK_QTENTR, "
	cInsert +=   " CZK_QTSAID, "
	cInsert +=   " CZK_QTSEST, "
	cInsert +=   " CZK_QTSALD, "
	cInsert +=   " CZK_QTNECE, "
	cInsert +=   " D_E_L_E_T_, "

	IF lAutoCZK
		cInsert +=   " R_E_C_N_O_, "
	Endif
	cInsert +=   " R_E_C_D_E_L_) "

	cQuery := " SELECT NECCZK.FILIAL, "
	cQuery +=        " NECCZK.NRMRP,  "
	cQuery +=        " NECCZK.RECCZJ, "
	cQuery +=        " NECCZK.PERMRP, "
	cQuery +=        " NECCZK.QTSLES, "
	cQuery +=        " NECCZK.QTENTR, "
	cQuery +=        " NECCZK.QTSAID, "
	cQuery +=        " NECCZK.QTSEST, "
	cQuery +=        " NECCZK.QTSALD, "
	cQuery +=        " NECCZK.QTNECE, "
	cQuery +=         " ' ', "
	IF lAutoCZK
		cQuery +=        gSqlRecno("CZK","NECCZK.RECCZJ") + ","
	EndIF
	cQuery +=         " 0 "
	cQuery +=   " FROM (SELECT DISTINCT '" + xFilial("CZK") + "' FILIAL, "
	cQuery +=                         " '"+c711NumMRP+"' NRMRP, "
	cQuery +=                         " CZJ.R_E_C_N_O_ RECCZJ, "
	cQuery +=                         " CZI.CZI_PERMRP PERMRP, "
	cQuery +=                         " 0 QTSLES, "
	cQuery +=                         " 0 QTENTR, "
	cQuery +=                         " 0 QTSAID, "
	cQuery +=                         " 0 QTSEST, "
	cQuery +=                         " 0 QTSALD, "
	cQuery +=                         " 0 QTNECE "
	cQuery +=           " FROM " + RetSqlName("CZI") + " CZI, "
	cQuery +=                      RetSqlName("CZJ") + " CZJ "
	cQuery +=          " WHERE CZI.CZI_FILIAL = '" + xFilial("CZI") + "' "
	cQuery +=            " AND CZI.D_E_L_E_T_ = ' ' "
	cQuery +=            " AND CZI.CZI_ALIAS <> ' ' "
	cQuery +=            " AND CZI.CZI_PROD  <> ' ' "
	cQuery +=            " AND CZJ.CZJ_FILIAL = '" + xFilial("CZJ") + "' "
	cQuery +=            " AND CZJ.D_E_L_E_T_ = ' ' "
	cQuery +=            " AND CZJ.CZJ_PROD   = CZI.CZI_PROD "
	cQuery +=            " AND CZJ.CZJ_OPCORD = CZI.CZI_OPCORD "
	cQuery +=            " AND CZJ.CZJ_NRRV   = CZI.CZI_NRRV "
	cQuery +=            " AND NOT EXISTS ( SELECT 1 "
	cQuery +=                               " FROM " + cNameCZK + " CZK "
	cQuery +=                              " WHERE CZK.D_E_L_E_T_ = ' ' "
	cQuery +=                                " AND CZK.CZK_FILIAL = '" + xFilial("CZK") + "' "
	cQuery +=                                " AND CZK.CZK_PERMRP = CZI.CZI_PERMRP "
	cQuery +=                                " AND CZK.CZK_RGCZJ  = CZJ.R_E_C_N_O_ ) "
	If cBanco == "ORACLE"
		cQuery +=   " )  NECCZK"
	Else
		cQuery +=   " ) AS NECCZK"
	EndIf

	//Trata o comando select.
	cQuery := ChangeQuery(cQuery)

	//Une o comando insert com o select tratado.
	cInsert += cQuery

	//Executa a query.
	If TcSqlExec(cInsert) < 0
		Final("Erro na carga da tabela CZK. ", TCSQLError() + cInsert)
	EndIf

	//Atualiza os valores de entradas na tabela CZK, de acordo com os registro da tabela CZI.
	cUpdate := " UPDATE " + cNameCZK
	cUpdate +=    " SET CZK_QTENTR = CZK_QTENTR + ( SELECT SUM(CZI.CZI_QUANT) "

	cCondUpd :=                                     " FROM " + RetSqlName("CZI") + " CZI, "
	cCondUpd +=                                                RetSqlName("CZJ") + " CZJ "
	cCondUpd +=                                     " WHERE " + cNameCZK + ".CZK_FILIAL = '"+ xFilial("CZK")+ "' "
	cCondUpd +=                                       " AND " + cNameCZK + ".D_E_L_E_T_ = ' ' "
	cCondUpd +=                                       " AND " + cNameCZK + ".CZK_RGCZJ  = CZJ.R_E_C_N_O_ "
	cCondUpd +=                                       " AND CZJ.CZJ_FILIAL = '" + xFilial("CZJ") + "' "
	cCondUpd +=                                       " AND CZI.CZI_FILIAL = '" + xFilial("CZI") + "' "
	cCondUpd +=                                       " AND CZJ.D_E_L_E_T_ = ' ' "
	cCondUpd +=                                       " AND CZI.D_E_L_E_T_ = ' ' "
	cCondUpd +=                                       " AND CZI.CZI_PROD   = CZJ.CZJ_PROD "
	cCondUpd +=                                       " AND CZI.CZI_OPCORD = CZJ.CZJ_OPCORD "
	cCondUpd +=                                       " AND CZI.CZI_NRRV   = CZJ.CZJ_NRRV "
	cCondUpd +=                                       " AND CZI.CZI_TPRG   = '2' "
	cCondUpd +=                                       " AND CZI.CZI_PERMRP = "+cNameCZK+".CZK_PERMRP "
	cCondUpd +=                                       " AND (CZI.CZI_OPC   IS NULL AND CZI.CZI_OPCORD = ' ')"
	cCondUpd +=                                       " AND CZI.CZI_ALIAS <> ' ' "
	cCondUpd +=                                       " AND CZI.CZI_PROD  <> ' ' )"

	cUpdate += cCondUpd
	cUpdate += " WHERE EXISTS (SELECT 1 " + cCondUpd

	//Executa a query.
	If TcSqlExec(cUpdate) < 0
		Final("Erro na carga da tabela CZK - Entradas (CZK_QTENTR). ", TCSQLError() + cInsert)
	EndIf

	//Atualiza os valores de entradas na tabela CZK, de acordo com os registro da tabela CZI.
	cUpdate := " UPDATE " + cNameCZK
	cUpdate +=    " SET CZK_QTSAID = CZK_QTSAID + ( SELECT SUM(CZI.CZI_QUANT) "

	cCondUpd :=                                     " FROM " + RetSqlName("CZI") + " CZI, "
	cCondUpd +=                                                RetSqlName("CZJ") + " CZJ "
	cCondUpd +=                                     " WHERE " + cNameCZK + ".CZK_FILIAL = '"+ xFilial("CZK")+ "' "
	cCondUpd +=                                       " AND " + cNameCZK + ".D_E_L_E_T_ = ' ' "
	cCondUpd +=                                       " AND " + cNameCZK + ".CZK_RGCZJ  = CZJ.R_E_C_N_O_ "
	cCondUpd +=                                       " AND CZJ.CZJ_FILIAL = '" + xFilial("CZJ") + "' "
	cCondUpd +=                                       " AND CZI.CZI_FILIAL = '" + xFilial("CZI") + "' "
	cCondUpd +=                                       " AND CZJ.D_E_L_E_T_ = ' ' "
	cCondUpd +=                                       " AND CZI.D_E_L_E_T_ = ' ' "
	cCondUpd +=                                       " AND CZI.CZI_PROD   = CZJ.CZJ_PROD "
	cCondUpd +=                                       " AND CZI.CZI_OPCORD = CZJ.CZJ_OPCORD "
	cCondUpd +=                                       " AND CZI.CZI_NRRV   = CZJ.CZJ_NRRV "
	cCondUpd +=                                       " AND CZI.CZI_TPRG   = '3' "
	cCondUpd +=                                       " AND CZI.CZI_PERMRP = "+cNameCZK+".CZK_PERMRP "
	cCondUpd +=                                       " AND (CZI.CZI_OPC   IS NULL AND CZI.CZI_OPCORD = ' ')"
	cCondUpd +=                                       " AND CZI.CZI_ALIAS <> ' ' "
	cCondUpd +=                                       " AND CZI.CZI_PROD  <> ' ' )"

	cUpdate += cCondUpd
	cUpdate += " WHERE EXISTS (SELECT 1 " + cCondUpd

	//Executa a query.
	If TcSqlExec(cUpdate) < 0
		Final("Erro na carga da tabela CZK - Sa�das (CZK_QTSAID). ", TCSQLError() + cInsert)
	EndIf

	//Necess�rio executar a TCRefresh para atualizar o cache do DBACCESS referente a tabela CZK.
	//Se n�o for chamada esta fun��o, ocorrer� erro ao realizar uma insers�o por RecLock.
	TCRefresh(RetSqlName("CZK"))
Return Nil

/*/{Protheus.doc} getFormMRP

Recupera a forma de gera��o do MRP de determinado produto (B5_FORMMRP)

@author lucas.franca

@since 05/06/2018

@version 1.0

@return cRet - Conte�do do campo B5_FORMMRP do produto. Valor padr�o � 1.

@param cProduto, characters, c�digo do produto para buscar o valor do B5_FORMMRP

/*/

Static Function getFormMRP(cProduto)
	Static cFilSB5 := Nil

	Local cRet := '1'

	If cFilSB5 == Nil
		cFilSB5 := xFilial("SB5")
	EndIf
	SB5->(dbSetOrder(1))
	If SB5->(dbSeek(cFilSB5+cProduto))
		cRet := SB5->B5_FORMMRP
	EndIf
Return cRet

/*/{Protheus.doc} getAgluMRP
Recupera a forma de aglutina��o do MRP de determinado produto (B5_AGLUMRP)
@author lucas.franca
@since 05/06/2018
@version 1.0
@return cRet - Conte�do do campo B5_AGLUMRP do produto. Valor padr�o � 1.
@param cProduto, characters, c�digo do produto para buscar o valor do B5_AGLUMRP
/*/
Static Function getAgluMRP(cProduto)

	Local cRet := '1'

	If cFilSB5 == Nil //cFilSB5 definida como Static no fonte.
		cFilSB5 := xFilial("SB5")
	EndIf
	SB5->(dbSetOrder(1))
	If SB5->(dbSeek(cFilSB5+cProduto))
		cRet := SB5->B5_AGLUMRP
	EndIf
Return cRet

/*/{Protheus.doc} clrStatic
Limpa as vari�veis do tipo Static deste fonte. Necess�rio para garantir integridade dos scripts de Automa��o.

@author lucas.franca
@since 05/10/2018
@version 1.0
@return Nil
/*/
Static Function clrStatic()
	lUsaMOpc	:= If(SuperGetMv('MV_REPGOPC',.F.,"N") == "S",.T.,.F.)
	cRevBranco	:= Nil
	lMRPCINQ	:= Nil
	lIsADVPR	:= Nil
	aGeraOPC	:= {}
	lPCPREVATU	:= FindFunction('PCPREVATU')  .AND.  SuperGetMv("MV_REVFIL",.F.,.F.)
	cRev711Vaz	:= Nil
	lTrataRev	:= Nil
	lConsVenc	:= Nil
	cLocCQ		:= Nil
	cComando	:= Nil
	cUser		:= Nil
	cFilSB5		:= Nil
	oSqlEstSeg 	:= Nil
	oSqlVerEst 	:= Nil
	oSemLocal   := Nil
	oComLocal   := Nil
    oVerAlt		:= Nil
	oExplEs     := Nil

Return

/*/{Protheus.doc} A712LOG
Nova fun��o a ser utilizado na rotina de LOG do MRP
@author Thiago.Zoppi
@since 21/11/2018
@version 1.0
/*/
Static Function A712LOG()
	Local cQuery    	:= ""
	Local cAliasTop 	:= GETNEXTALIAS()
	Local cFilCZJ   	:= xFilial("CZJ")
	Local nRegAnt   	:= 0
	Local aFields 		:= {}
	Local cAliastmp 	:= GETNEXTALIAS()
	Local oSqlLogDoc 	:= Nil
	Local oSqlLogPer 	:= Nil
	Local cAlias 		:= ''
	Local cAlias01 		:= ''
	Local cAlias02 		:= ''
	Local cAlias2 		:= ''
	Local nSAldo  		:= 0
	Local nNecessidade 	:= 0
	Local nB1Emin 		:= 0
	Local nB1Emax 		:= 0
	Local nEntrINI 		:= 0
	Local nSaidaINI 	:= 0
	Local cQryDoc 		:= ''
	Local nValor 		:= 0
	Local aDocumentos 	:= {}
	Local cQuery01    	:= ''
	Local nPerDesc	 	:= 0
	Local lPerDif	 	:= .T.
	Local lEmin
	Local lAdianta
	Local oTempTable

	ProcLogAtu("MENSAGEM","Iniciando montagem do Log MRP","Iniciando montagem do Log MRP")

	// --  Tab. temporaria para armazenar os Saldos de todas necessidades calculadas -- //
	oTempTable := FWTemporaryTable():New( cAliastmp )
	aadd(aFields,{"CZK_FILIAL"  ,"C",TAMSX3("CZK_FILIAL")[1],0})
	aadd(aFields,{"CZK_NRMRP"   ,"C",TAMSX3("CZK_NRMRP")[1],0})
	aadd(aFields,{"CZK_RGCZJ"   ,"N",TAMSX3("CZK_RGCZJ")[1],1})
	aadd(aFields,{"CZK_PERMRP"  ,"C",TAMSX3("CZK_PERMRP")[1],0})
	aadd(aFields,{"CZK_QTNECE"  ,"N",TAMSX3("CZK_QTNECE")[1],2})

	oTemptable:SetFields( aFields )
	oTempTable:AddIndex("01", {"CZK_FILIAL","CZK_RGCZJ","CZK_PERMRP" } )
	oTempTable:Create()

	DBSELECTAREA(cAliastmp)
	(cAliastmp)-> (dbsetorder(1))

	cAlias2 := GetNextAlias()
	BeginSql Alias cAlias2
		SELECT CZK_FILIAL,CZK_QTSLES, CZK_NRMRP,CZK_RGCZJ,CZK_PERMRP, CZK_QTNECE,CZK_QTSAID,CZK_QTSEST,CZK_QTENTR, B1_EMIN
		FROM %Table:CZK% CZK , %Table:CZJ% CZJ, %Table:SB1% SB1
		WHERE   CZK_FILIAL   = %xFilial:CZK%
		AND CZJ_FILIAL   = %xFilial:CZJ%
		AND SB1.B1_FILIAL   = %xFilial:SB1%
		AND SB1.%NotDel%
		AND CZJ.R_E_C_N_O_   = CZK.CZK_RGCZJ
		AND CZJ.CZJ_PROD     = SB1.B1_COD
		ORDER BY CZK_RGCZJ, CZK_PERMRP
	EndSql

	WHILE !(cAlias2)->(EOF())

		nNecessidade := 0
		lEmin := (cAlias2)->B1_EMIN > 0

		IF (cAlias2)->CZK_PERMRP = '001'
			nSaldo  := (cAlias2)->CZK_QTSLES
		Endif

		nEntrINI  := (cAlias2)->CZK_QTENTR
		nSaidaINI := ((cAlias2)->CZK_QTSAID+(cAlias2)->CZK_QTSEST)

		nSaldo -=  nSaidaINI

		IF lEmin .AND. nSaldo < (cAlias2)->B1_EMIN
			nNecessidade :=  abs(nSaldo - ((cAlias2)->B1_EMIN +1 ) )
			nSaldo := ((cAlias2)->B1_EMIN +1 )

		Else
			IF nSaldo < 0
				nNecessidade := ABS(nSaldo)
				NSALDO := 0
			Else
				nNecessidade := 0
			Endif

		End

		RECLOCK(cAliastmp, .T. )
		(CALIASTMP)->CZK_FILIAL := (CALIAS2)->CZK_FILIAL
		(CALIASTMP)->CZK_NRMRP  := (CALIAS2)->CZK_NRMRP
		(CALIASTMP)->CZK_RGCZJ  := (CALIAS2)->CZK_RGCZJ
		(CALIASTMP)->CZK_PERMRP := (CALIAS2)->CZK_PERMRP
		(CALIASTMP)->CZK_QTNECE := nNecessidade
		MSUNLOCK()

		(CALIAS2)->(DBSKIP())

	ENDDO

	If TCGetDB() $ "ORACLE"
		If DWCanOpenView("TMP")
			cQuery := " DROP VIEW TMP "
			MATExecQry(cQuery)
		EndIf

		cQuery := " CREATE VIEW TMP AS " +;
		" SELECT CZJ.CZJ_PROD, " +;
		" CZK.CZK_PERMRP, " +;
		" CZK.CZK_QTSLES, " +;
		" CZK.CZK_QTENTR, " +;
		" CZK.CZK_QTSAID, " +;
		" CZK.CZK_QTSEST, " +;
		" CZK.CZK_QTSALD, " +;
		" CZK.CZK_QTNECE, " +;
		" SB1.B1_EMIN, " +;
		" SB1.B1_EMAX, " +;
		"CZJ.CZJ_OPCORD,CZJ.CZJ_NRRV, "+;
		" CZJ.R_E_C_N_O_ CZJREC, " +;
		" (CASE WHEN SB1.B1_EMIN > 0 AND  CZK.CZK_QTSALD  <= SB1.B1_EMIN  THEN 'T' " +;
		" ELSE 'F' END ) AS EVE009  ," +;
		" (CASE WHEN SB1.B1_EMAX > 0  "+;
		"   AND  COALESCE(( SELECT CZK1.CZK_QTSALD  FROM " + RetSqlName("CZK")+" CZK1 "+;
					"WHERE  CZK.CZK_FILIAL = CZK1.CZK_FILIAL  "+;
						" AND CZK.CZK_RGCZJ = CZK1.CZK_RGCZJ" +;
						" AND  CAST(CZK1.CZK_PERMRP AS INT) = ( CAST(CZK.CZK_PERMRP AS INT) - 1 )),0) <= SB1.B1_EMAX "+;
		" AND  CZK.CZK_QTSALD  > SB1.B1_EMAX  THEN 'T' " +;
		" ELSE 'F' END ) AS EVE008 , "+;
		" ( Select COALESCE(SUM(CZI_QUANT),0) FROM "+ RetSqlName("CZI") +"  CZI  "+;
		"   WHERE CZI_FILIAL    = CZJ.CZJ_FILIAL "+;
		"     AND CZI_PROD    = CZJ.CZJ_PROD  "+;
		"     AND CZI_OPCORD    = CZJ.CZJ_OPCORD "+;
		"     AND CZI_NRRV    = CZJ.CZJ_NRRV "+;
		"     AND CZI_PERMRP    = CZK.CZK_PERMRP "+;
		"     AND CZI_TPRG    = '2' "+;
		"     AND CZI.D_E_L_E_T_  = ''  )  TOT_DOC, "+;
		" ( Select count(CZI_DOC) FROM "+ RetSqlName("CZI") +"  CZI  "+;
		"     WHERE CZI_FILIAL    = CZJ.CZJ_FILIAL  "+;
		"       AND CZI_PROD    = CZJ.CZJ_PROD  "+;
		"       AND CZI_OPCORD    = CZJ.CZJ_OPCORD  "+;
		"       AND CZI_NRRV    = CZJ.CZJ_NRRV  "+;
		"       AND CZI_PERMRP    = CZK.CZK_PERMRP  "+;
		"       AND CZI_TPRG    = '2'  "+;
		"       AND CZI.D_E_L_E_T_  = ''  )  QTD_DOC "+;
		"  FROM " + RetSqlName("CZJ") + " CZJ, " +;
		RetSqlName("CZK") + " CZK, " +;
		RetSqlName("SB1") + " SB1 " +;
		" WHERE CZJ.CZJ_FILIAL   = '" + cFilCZJ + "' " +;
		" AND CZK.CZK_FILIAL   = '" + xFilial("CZK") + "' " +;
		" AND SB1.B1_FILIAL    = '" + xFilial("SB1") + "' " +;
		" AND SB1.D_E_L_E_T_ = ' ' " +;
		" AND CZJ.R_E_C_N_O_   = CZK.CZK_RGCZJ " +;
		" AND CZJ.CZJ_PROD     = SB1.B1_COD " +;
		" AND EXISTS (SELECT 1 " +;
		" FROM " + RetSqlName("CZK") + " CZKA " +;
		" WHERE CZKA.CZK_FILIAL   = '" + xFilial("CZK") + "' " +;
		" AND CZKA.CZK_RGCZJ    = CZJ.R_E_C_N_O_ " +;
		" AND (CZKA.CZK_QTNECE <> 0 " +;
		"  OR  CZKA.CZK_QTSAID <> 0 " +;
		"  OR  CZKA.CZK_QTSALD <> 0 " +;
		"  OR  CZKA.CZK_QTSEST <> 0 " +;
		"  OR  CZKA.CZK_QTENTR <> 0 " +;
		"  OR  CZKA.CZK_QTSLES <> 0)) "

		//n?o usar ChangeQuery pois converte errado o create view
		MATExecQry(cQuery)

		cQuery := " SELECT * FROM TMP" +;
					" WHERE TMP.CZK_QTENTR > 0 OR TMP.EVE008 = 'T' OR TMP.EVE009 = 'T' "+;
					" ORDER BY TMP.CZJREC , " +;
					 	     " TMP.CZK_PERMRP "


	ELSE
		// -- Seleciona itens que tiveram entradas ou necessidade de estoque maximo ou ponto de pedidos -- //
		cQuery := " SELECT * FROM (" +;
		" SELECT CZJ.CZJ_PROD, " +;
		" CZK.CZK_PERMRP, " +;
		" CZK.CZK_QTSLES, " +;
		" CZK.CZK_QTENTR, " +;
		" CZK.CZK_QTSAID, " +;
		" CZK.CZK_QTSEST, " +;
		" CZK.CZK_QTSALD, " +;
		" CZK.CZK_QTNECE, " +;
		" SB1.B1_EMIN, " +;
		" SB1.B1_EMAX, " +;
		"CZJ.CZJ_OPCORD,CZJ.CZJ_NRRV, "+;
		" CZJ.R_E_C_N_O_ CZJREC, " +;
		" (CASE WHEN SB1.B1_EMIN > 0 AND  CZK.CZK_QTSALD  <= SB1.B1_EMIN  THEN 'T' " +;
		" ELSE 'F' END ) AS EVE009  ," +;
		" (CASE WHEN SB1.B1_EMAX > 0  "+;
		"   AND  COALESCE(( SELECT CZK1.CZK_QTSALD  FROM " + RetSqlName("CZK")+" CZK1 "+;
					"WHERE  CZK.CZK_FILIAL = CZK1.CZK_FILIAL  "+;
						" AND CZK.CZK_RGCZJ = CZK1.CZK_RGCZJ" +;
						" AND  CAST(CZK1.CZK_PERMRP AS INT) = ( CAST(CZK.CZK_PERMRP AS INT) - 1 )),0) <= SB1.B1_EMAX "+;
		" AND  CZK.CZK_QTSALD  > SB1.B1_EMAX  THEN 'T' " +;
		" ELSE 'F' END ) AS EVE008 , "+;
		" ( Select COALESCE(SUM(CZI_QUANT),0) FROM "+ RetSqlName("CZI") +"  CZI  "+;
		"   WHERE CZI_FILIAL    = CZJ.CZJ_FILIAL "+;
		"     AND CZI_PROD    = CZJ.CZJ_PROD  "+;
		"     AND CZI_OPCORD    = CZJ.CZJ_OPCORD "+;
		"     AND CZI_NRRV    = CZJ.CZJ_NRRV "+;
		"     AND CZI_PERMRP    = CZK.CZK_PERMRP "+;
		"     AND CZI_TPRG    = '2' "+;
		"     AND CZI.D_E_L_E_T_  = ''  )  TOT_DOC, "+;
		" ( Select count(CZI_DOC) FROM "+ RetSqlName("CZI") +"  CZI  "+;
		"     WHERE CZI_FILIAL    = CZJ.CZJ_FILIAL  "+;
		"       AND CZI_PROD    = CZJ.CZJ_PROD  "+;
		"       AND CZI_OPCORD    = CZJ.CZJ_OPCORD  "+;
		"       AND CZI_NRRV    = CZJ.CZJ_NRRV  "+;
		"       AND CZI_PERMRP    = CZK.CZK_PERMRP  "+;
		"       AND CZI_TPRG    = '2'  "+;
		"       AND CZI.D_E_L_E_T_  = ''  )  QTD_DOC "+;
		"  FROM " + RetSqlName("CZJ") + " CZJ, " +;
		RetSqlName("CZK") + " CZK, " +;
		RetSqlName("SB1") + " SB1 " +;
		" WHERE CZJ.CZJ_FILIAL   = '" + cFilCZJ + "' " +;
		" AND CZK.CZK_FILIAL   = '" + xFilial("CZK") + "' " +;
		" AND SB1.B1_FILIAL    = '" + xFilial("SB1") + "' " +;
		" AND SB1.D_E_L_E_T_ = ' ' " +;
		" AND CZJ.R_E_C_N_O_   = CZK.CZK_RGCZJ " +;
		" AND CZJ.CZJ_PROD     = SB1.B1_COD " +;
		" AND EXISTS (SELECT 1 " +;
		" FROM " + RetSqlName("CZK") + " CZKA " +;
		" WHERE CZKA.CZK_FILIAL   = '" + xFilial("CZK") + "' " +;
		" AND CZKA.CZK_RGCZJ    = CZJ.R_E_C_N_O_ " +;
		" AND (CZKA.CZK_QTNECE <> 0 " +;
		"  OR  CZKA.CZK_QTSAID <> 0 " +;
		"  OR  CZKA.CZK_QTSALD <> 0 " +;
		"  OR  CZKA.CZK_QTSEST <> 0 " +;
		"  OR  CZKA.CZK_QTENTR <> 0 " +;
		"  OR  CZKA.CZK_QTSLES <> 0)) " +;
		" ) AS TMP " +;
		" WHERE TMP.CZK_QTENTR > 0 OR TMP.EVE008 = 'T' OR TMP.EVE009 = 'T' "+;
		" ORDER BY TMP.CZJREC , " +;
		" TMP.CZK_PERMRP "

	ENDIF

//	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)


	While ! (cAliasTop)->(Eof())
		nRegAnt := (cAliasTop)->CZJREC
		nB1Emin := (cAliasTop)->B1_EMIN
		nB1Emax := (cAliasTop)->B1_EMAX

		If (cAliasTop)->EVE009 = 'T'
			A712CriaLOG("009",(cAliasTop)->CZJ_PROD,{nB1Emin,(cAliasTop)->CZK_QTSALD,aPeriodos[val((cAliastop)->CZK_PERMRP)],"SB1"},lLogMRP,c711NumMrp)

		EndIf

		//Verifica se atingiu estoque maximo
		If  (cAliasTop)->EVE008 = 'T'
			A712CriaLOG("008",(cAliasTop)->CZJ_PROD,{nB1Emax,(cAliasTop)->CZK_QTSALD,aPeriodos[val((cAliastop)->CZK_PERMRP)],"SB1"},lLogMRP,c711NumMrp)
		EndIf

		IF (cAliasTop)->CZK_PERMRP = '001'
			nSaldo    := (cAliasTop)->CZK_QTSLES
		Endif

		nEntrINI  := (cAliasTop)->CZK_QTENTR
		nSaidaINI := ((cAliasTop)->CZK_QTSAID+(cAliasTop)->CZK_QTSEST)

		lEmin := (cAliasTop)->B1_EMIN > 0

		IF lEmin .AND. nSaldo < (cAlias2)->B1_EMIN
			nNecessidade :=  abs(nSaldo - ((cAlias2)->B1_EMIN +1 ) )
			nSaldo := ((cAlias2)->B1_EMIN +1 )

		Else
			IF nSaldo < 0
				nNecessidade := ABS(nSaldo)
				NSALDO := 0
			Else
				nNecessidade := 0
			Endif

		End

		IF (cAliasTop)->CZK_QTENTR > 0  // TEM ENTRADAS

			//EXISTEM MAIS QUE 1 DOC PARA O PERIODO OU A NECESSIDADE � IGUAL A ZERO, E EXISTEM ENTRADAS
			//IF (cAliasTop)->QTD_DOC > 1 .OR. nNecessidade = 0

			IF (cAliasTop)->TOT_DOC <= nNecessidade    // TOTAL DOS DOCUEMTOS MENOR OU IGUAL AS NECESSIDADES, ENTAO CONSOME TUDO

				iF (cAliastmp)->(dbSeek(xFilial("CZK")+STR((cAliasTOP)->CZJREC,10)+(cAliasTop)->CZK_PERMRP))
					RECLOCK(cAliastmp, .F. )
					(CALIASTMP)->CZK_QTNECE := nNecessidade - (cAliasTop)->TOT_DOC
					MsUnLock()
				EndIF
				(cAliasTop)->(DBSKIP())
				Loop

			ELSE
				//-------------------------------------------------------//
				// -- DISTRIBUIR OS DOCS QUE N�O FORAM UTILIZADOS        //
				//-------------------------------------------------------//
				IF oSqlLogDoc == nil
					cQryDoc:= " SELECT CZI_PERMRP,CZI_PROD, CZI_QUANT,CZI_DOC, CZI_ALIAS,CZI_ITEM,CZI_DTOG "
					cQryDoc+= " FROM "+ RetSqlName("CZI") + " CZI "
					cQryDoc+= " WHERE CZI_FILIAL   = '" + xFilial("CZI") + "' "
					cQryDoc+= " AND  CZI_TPRG  = '2' "
					cQryDoc+= " AND CZI_PROD   = ? "
					cQryDoc+= " AND CZI_OPCORD = ? "
					cQryDoc+= " AND CZI_NRRV   = ? "
					cQryDoc+= " AND CZI_PERMRP = ? "
					cQryDoc+= " AND CZI.D_E_L_E_T_ = '' "
					cQryDoc+= " ORDER BY CZI_DTOG "

					cQryDoc := ChangeQuery(cQryDoc)
					oSqlLogDoc := FWPreparedStatement():New(cQryDoc)

				EndIf
				oSqlLogDoc:SetString(1,(cAliasTop)->CZJ_PROD  )
				oSqlLogDoc:SetString(2,(cAliasTop)->CZJ_OPCORD  )
				oSqlLogDoc:SetString(3,(cAliasTop)->CZJ_NRRV  )
				oSqlLogDoc:SetString(4,(cAliasTop)->CZK_PERMRP  )

				cQryDoc := oSqlLogDoc:GetFixQuery()
				cAlias := MPSysOpenQuery( cQryDoc )

				nValor    := 0

				(cAlias)->(dbgoTop())

				While (cAlias)->(!eof())
					aDocumentos := {}
					nValor += (cAlias)->CZI_QUANT  // Soma valor dos documentos

					If oSqlLogPer == Nil
						cQuery01 := " SELECT  CZK_NRMRP,CZK_RGCZJ, CZK_PERMRP, CZK_QTNECE  FROM "+ oTempTable:GetRealName()
						cQuery01 += " WHERE CZK_FILIAL = '"+ xFilial("CZK") + "' "
						cQuery01 += " AND CZK_RGCZJ = ? "
						cQuery01 += " AND CZK_QTNECE > 0 "
						cquery01 += " ORDER BY CZK_RGCZJ, CZK_PERMRP "
						cQuery01 := ChangeQuery(cQuery01)
						oSqlLogPer := FWPreparedStatement():New(cquery01)

					Endif

					oSqlLogPer:SetString(1,ALLTRIM(STR(nRegAnt)))
					cQuery01 := oSqlLogPer:GetFixQuery()
					cAlias01 := MPSysOpenQuery( cQuery01 )

					IF  EMPTY((cAlias01)->CZK_PERMRP) // NAO EXISTEM REGISTROS
						//Nao existem necessidades - ent�o cancela o Doc
						A712CriaLOG("007",(cAlias)->CZI_PROD,{STOD((cAlias)->CZI_DTOG),(cAlias)->CZI_DOC,(cAlias)->CZI_ITEM,(cAlias)->CZI_ALIAS,aPeriodos[val((cAlias)->CZI_PERMRP)]},lLogMRP,c711NumMrp)
						If Select( (cAlias) ) > 0
							(cAlias)->(DBSKIP())
						EndIf
						(cAlias01)->(dbCloseArea())
						LOOP
					EndIF

					// valor do doc. maiOr que a necessidade
					IF  nValor >= (cAlias01)->CZK_QTNECE

						nValor -= (cAlias01)->CZK_QTNECE // desconto o valor da necessidade

						(cAliastmp)-> (DBGoTop())
						IF (cAliastmp)-> (DBSEEK(XFILIAL("CZK")+PADR((cAlias01)->CZK_RGCZJ,TAMSX3("CZK_RGCZJ")[1],'')+(cAlias01)->CZK_PERMRP))
							RECLOCK(cAliastmp, .F. )
							(cAliastmp)->CZK_QTNECE := 0
							MsUnLock()
						EndIF
						nPerDesc := (cAliastmp)->CZK_PERMRP // Periodo utilizado no Log

						IF nValor > 0 //sobrou saldo, atualizar saldos

							If oSqlLogPer == Nil
								cQuery01 := " SELECT  CZK_NRMRP,CZK_RGCZJ, CZK_PERMRP, CZK_QTNECE  FROM "+ oTempTable:GetRealName()
								cQuery01 += " WHERE CZK_FILIAL = '"+ xFilial("CZK") + "' "
								cQuery01 += " AND CZK_RGCZJ = ? "
								cQuery01 += " AND CZK_QTNECE > 0 "
								cquery01 += " ORDER BY CZK_RGCZJ, CZK_PERMRP "
								cQuery01 := ChangeQuery(cQuery01)
								oSqlLogPer := FWPreparedStatement():New(cquery01)

							Endif

							oSqlLogPer:SetString(1,ALLTRIM(STR(nRegAnt)))
							cQuery01 := oSqlLogPer:GetFixQuery()
							cAlias02 := MPSysOpenQuery( cQuery01 )

							While  ! (cAlias02)->(EOF())

								nValor -= (cAlias02)->CZK_QTNECE

								(cAliastmp)->(DBGOTOP())

								IF (cAliastmp)->(DBSEEK(XFILIAL("CZK")+PADR((cAlias02)->CZK_RGCZJ,TAMSX3("CZK_RGCZJ")[1],'')+(cAlias02)->CZK_PERMRP))
									RECLOCK(cAliastmp, .F. )
									IF  nValor >= 0
										(cAliastmp)->CZK_QTNECE :=  0
									Else
										(cAliastmp)->CZK_QTNECE := abs(nvalor)
									endif
									MsUnLock()

								EndIF

								if nValor <= 0  // se nao tiver mais saldo, sai do loop que refaz o saldo
									Exit
								EndIf

								(cAlias02)->(dbskip())
							ENDDO

							// verifica se o periodo do documento � o mesmo da CZK
							lPerDif := nPerDesc = (cAlias)->CZI_PERMRP

							if  Ascan(aDocumentos,{|x| x[1] == (cAlias)->CZI_PERMRP }) == 0

								If ! lPerDif
									lAdianta := IIF((cAlias)->CZI_PERMRP > nPerDesc  ,.T.,.F. )

									IF lAdianta
										A712CriaLOG("003",(cAlias)->CZI_PROD,{STOD((cAlias)->CZI_DTOG),(cAlias)->CZI_DOC,(cAlias)->CZI_ITEM,(cAlias)->CZI_ALIAS,aPeriodos[val(nPerDesc)]},lLogMRP,c711NumMrp)
									else
										A712CriaLOG("002",(cAlias)->CZI_PROD,{STOD((cAlias)->CZI_DTOG),(cAlias)->CZI_DOC,(cAlias)->CZI_ITEM,(cAlias)->CZI_ALIAS,aPeriodos[val(nPerDesc)]},lLogMRP,c711NumMrp)
									endif

								Endif
								AADD(aDocumentos,{(cAlias)->CZI_PERMRP} )

							EndIF

							(cAlias02)->(dbCloseArea())
						ENDIF

					ELSE

						//Necessidade maior que documento
						dbSelectArea(cAliastmp)
						(cAliastmp)->(DBGOTOP())
						IF (cAliastmp)->(DBSEEK(XFILIAL("CZK")+PADR((cAlias01)->CZK_RGCZJ,TAMSX3("CZK_RGCZJ")[1],'')+(cAlias01)->CZK_PERMRP))

							nvalor := (cAlias01)->CZK_QTNECE - nValor
							RECLOCK(cAliastmp, .F. )
							(CALIASTMP)->CZK_QTNECE := nValor   // DESCONTO O VALOR DAS NECESSIDADES DA TAB. TEMP
							MsUnLock()
							nValor := 0

						EndIF
						// verifica se o periodo do documento � o mesmo da CZK
						lPerDif := (cAliastmp)->CZK_PERMRP = (cAlias)->CZI_PERMRP

						if  Ascan(aDocumentos,{|x| x[1] == (cAlias)->CZI_PERMRP }) == 0
							if ! lPerDif
								lAdianta := IIF((cAlias)->CZI_PERMRP > (cAlias01)->CZK_PERMRP  ,.T.,.F. )

								IF lAdianta
									A712CriaLOG("003",(cAlias)->CZI_PROD,{STOD((cAlias)->CZI_DTOG),(cAlias)->CZI_DOC,(cAlias)->CZI_ITEM,(cAlias)->CZI_ALIAS,aPeriodos[val((cAliastmp)->CZK_PERMRP)]},lLogMRP,c711NumMrp)
								else
									A712CriaLOG("002",(cAlias)->CZI_PROD,{STOD((cAlias)->CZI_DTOG),(cAlias)->CZI_DOC,(cAlias)->CZI_ITEM,(cAlias)->CZI_ALIAS,aPeriodos[val((cAliastmp)->CZK_PERMRP)]},lLogMRP,c711NumMrp)
								endif

							EndIF
						endif

						AADD(aDocumentos,{(cAlias)->CZI_PERMRP} )

					ENDIF
					nValor := 0
					If Select((cAlias)) > 0
						(cAlias)->(dbskip())
					EndIf
					(cAlias01)->(dbCloseArea())

				Enddo

				(cAlias)->(dbCloseArea())
			ENDIF

		ENDIF
		(cAliasTop)->(DBSKIP())

	EndDo

	oTempTable:Delete()
	(cAliasTop)->(dbCloseArea())
	(cAlias2)->(dbCloseArea())
	//Atualiza o log de processamento
	ProcLogAtu("MENSAGEM","Termino da montagem do Log MRP","Termino da montagem do Log MRP")

	//DESTRUIR OBJETOS DA QUERY
	If oSqlLogPer != Nil
		oSqlLogPer:Destroy()
	EndIf
	If oSqlLogDoc != Nil
		oSqlLogDoc:Destroy()
	EndIf

Return

/*/{Protheus.doc} A712LOG
Busca o Mopc caso parametro MV_MOPCGRV estiver habilitado
@author Thiago.Zoppi
@since 02/2019
/*/
Static Function BuscaMopc(cReg)
local cRet      :=  cReg
local aCzi      := CZI->(GETAREA())

	IF substr(cReg,1,3) == 'REC'
			CZI->(dbGoto(val(substr(cReg,4,12))) )
			cRet := CZI->CZI_OPC
	EndIF

RestArea(aCzi)
Return cret

/*/{Protheus.doc} AtuOPSC2(cError)
    @type  Static Function
    @author ricardo.prandi
    @since 01/05/2019
    @version 1.0
    @param cError, Char, Descri��o do erro
    @return lRet, L�gico, Indica se atualizou as ordens com sucesso
    /*/
Static Function AtuOPSC2(cError)

    Local lRet    := .T.
	Local cSql    := ""
	Local nResult := 0

    ProcLogAtu("MENSAGEM","Iniciando Atualiza��o C2_OP","Iniciando Atualiza��o C2_OP")

	cSql := " UPDATE " + RetSqlName("SC2") + " SET C2_OP = "

    If Upper(TcGetDb()) $ 'ORACLE,DB2,POSTGRES,INFORMIX'
		cSql += " C2_NUM||C2_ITEM||C2_SEQUEN||C2_ITEMGRD "
	Else
		cSql += " C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD "
	EndIf

	cSql += " WHERE C2_FILIAL  = '" + xFilial("SC2") + "' "
	cSql +=   " AND D_E_L_E_T_ = ' ' "
	cSql +=   " AND C2_OP      = ' ' "

	nResult := TcSqlExec(cSql)

	If nResult < 0
		cError := TCSQLError() + cSql
		lRet   := .F.
	EndIf

	ProcLogAtu("MENSAGEM","Termino Atualiza��o C2_OP","Fim Atualiza��o C2_OP")
Return lRet

/*/{Protheus.doc} A712Lote(nQtdTotal,cProduto)
    @type  Static Function
    @author ricardo.prandi
    @since 01/05/2019
    @version 1.0
    @param nQtdTotal, Num�rico, Quantidade total do produto
    @return nQtdTotal, return_type, return_description
    /*/
Static Function A712Lote(nQtdTotal,cProduto)

    Local cAlias   := Alias()
    Local aQtdes   := {}
    Local nx       := 0
    Local aAreaSG1 := SG1->(GetArea())

    dbSelectArea("SG1")
    dbSetOrder(1)
    If dbSeek(xFilial("SG1")+cProduto)
	    aQtdes := CalcLote(cProduto,nQtdTotal,"F")
    Else
	    aQtdes := CalcLote(cProduto,nQtdTotal,"C")
    EndIf

    nQtdTotal:=0

    For nX := 1 to Len(aQtdes)
	    nQtdTotal+= aQtdes[nX]
    Next

    RestArea(aAreaSG1)

    If !Empty(cAlias)
	    dbSelectArea(cAlias)
    EndIf

Return nQtdTotal

/*/{Protheus.doc} existeIndx
Verifica se um �ndice existe para a tabela.

@type  Static Function
@author lucas.franca
@since 03/04/2020
@version P12.1.30
@param cNameIndex, Character, Nome do �ndice no banco de dados
@param cTable    , Character, Nome da tabela
@return lExiste, Logic, Indica se o �ndice existe ou n�o.
/*/
Static Function existeIndx(cNameIndex, cTable)
	Local cAlias  := GetNextAlias()
	Local cBanco  := AllTrim(Upper(TcGetDb()))
	Local cQuery  := ""
	Local lExiste := .F.

	cNameIndex := Upper(cNameIndex)
	cTable     := RetSqlName(cTable)

	If "MSSQL" $ cBanco
		cQuery := "SELECT COUNT(*) TOTAL "
		cQuery +=  " FROM sys.indexes "
		cQuery += " WHERE UPPER(name) = '" + cNameIndex + "' "
		cQuery +=   " AND object_id = OBJECT_ID('" + cTable + "')"
	EndIf

	If !Empty(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		If (cAlias)->(TOTAL) > 0
			lExiste := .T.
		EndIf
		(cAlias)->(dbCloseArea())
	EndIf

Return lExiste

#INCLUDE "MATA712.CH"
#INCLUDE "totvs.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICODE.CH"

#DEFINE EOL	Chr(13)+Chr(10)

User Function jobm712()

// Variaceis da Tela
Local oButton1
Local oButton2
//Local oButton3
Local oGet1
Local oGroup1
Local oRadMenu1
Local oSay1
Local oCheckBo1
Local oCheckOP
Local nTamTipo711 	:= TamSX3("B1_TIPO")[1]
Local nTamGr711   	:= TamSX3("B1_GRUPO")[1]
Local nTamNNR   	:= TamSX3("NNR_CODIGO")[1]
Local cFilSBM := xFilial("SBM")
Local oQual,oQual2,OQUAL3,oChkQual,lQual,oChkQual2,lQual2,oChkQual3,lQual3
Local nI := 0`
Local oOk      		:= LoadBitmap( GetResources(), "LBOK")
Local oNo      		:= LoadBitmap( GetResources(), "LBNO")

Static oDlg

Private nRadMenu1 := 1
Private nGet1 := 30
Private lCheckBo1 := .T.
Private lCheckOp  := .f.
Private a711TpST    := {}
Private A711GrpST	:= {}

Public _A711NNR		:= {}

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
// MV_PAR21    ->  Qtd. 3§ nosso Poder        1- Subtrai        2- Ignora             //
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
// MV_PAR35    ->  Mostra Tela no Final       1-Sim             2- Nao                //
//------------------------------------------------------------------------------------//

//Pergunte("MTA712",.T.)

//Monta a Tabela de Tipos
aTipos := FWGetSX5("02")
For nI := 1 To Len(aTipos)
	cCapital := OemToAnsi(Capital(aTipos[nI,4]))
	AADD(a711TpST,{.T.,SubStr(aTipos[nI,3],1,nTamTipo711)+" - "+cCapital})
Next nI

//Monta a Tabela de Grupos
dbSelectArea("SBM")
dbSeek(cFilSBM)
AADD(A711GrpST,{.T.,Criavar("B1_GRUPO",.F.)+" - "+STR0003}) //"Grupo em Branco"
Do While (BM_FILIAL == cFilSBM) .AND. !Eof()
	cCapital := OemToAnsi(Capital(BM_DESC))
	AADD(A711GrpST,{.T.,SubStr(BM_GRUPO,1,nTamGr711)+" - "+cCapital})
	dbSkip()
EndDo
dbCloseArea()

//Monta a Tabela de aArmaz�ns
dbSelectArea("NNR")
dbSeek(cFilAnt)
Do While (NNR_FILIAL == cFilAnt) .AND. !Eof()
	If NNR_MRP == '1'
		cCapital := OemToAnsi(Capital(NNR_DESCRI))     
		AADD(_A711NNR,{.T.,SubStr(NNR_CODIGO,1,nTamNNR)+" - "+cCapital})
	Endif	
	dbSkip()
EndDo
dbCloseArea()

if Empty(_A711NNR)
	MsgAlert("Ajustar o Cadastro de Locais de Estoque, preencha com MRP=Sim !")
	RETURN
Endif	

DEFINE MSDIALOG oDlg TITLE "MRP Steck - Destinos" FROM 000, 000  TO 380, 600 COLORS 0, 16777215 PIXEL

@ 011, 011 GROUP oGroup1 TO 138, 115 PROMPT "Periodicidade do MRP " OF oDlg COLOR 0, 16777215 PIXEL
@ 031, 020 RADIO oRadMenu1 VAR nRadMenu1 ITEMS "Per�odo di�rio","Per�odo semanal","Per�odo quinzenal","Per�odo mensal","Per�odo trimestral","Per�odo semestral" SIZE 092, 052 OF oDlg COLOR 0, 16777215 PIXEL
@ 098, 020 SAY oSay1 PROMPT "Quantidade de Periodos:" SIZE 067, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 095, 085 MSGET oGet1 VAR nGet1 SIZE 019, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 112, 020 CHECKBOX oCheckOP  VAR lCheckOp PROMPT "Gera OP/SC Automatico" SIZE 072, 008 OF oDlg COLORS 0, 16777215 PIXEL
@ 124, 020 CHECKBOX oCheckBo1 VAR lCheckBo1 PROMPT "Consid.Ped.em Carteira" SIZE 072, 008 OF oDlg COLORS 0, 16777215 PIXEL

@ 155, 005 BUTTON oButton1 PROMPT "Par�metros" SIZE 035, 012 OF oDlg PIXEL ACTION Pergunte("MTA712",.T.)
@ 155, 045 BUTTON oButton2 PROMPT "Processar" SIZE 035, 012 OF oDlg PIXEL ACTION GeraMRP()
@ 155, 084 BUTTON oButton2 PROMPT "Cancelar" SIZE 035, 012 OF oDlg PIXEL ACTION (oDlg:End())
//@ 140, 049 BUTTON oButton3 PROMPT "Visualizar" SIZE 037, 012 OF oDlg PIXEL ACTION (oDlg:End(),U_MRPNECESS("") )
//@ 159, 005 BUTTON oButton4 PROMPT "SC's Geradas" SIZE 037, 012 OF oDlg PIXEL ACTION U_GERASCMRP()

@ 12,130 CHECKBOX oChkQual VAR lQual  PROMPT OemToAnsi(STR0020) SIZE 50, 10 OF oDlg PIXEL ON CLICK (AEval(a711TpST , {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oQual:Refresh(.F.)) //"Inverter Selecao"
@ 22,125 LISTBOX oQual VAR cVarQ Fields HEADER "",OemToAnsi(STR0021)  SIZE 78,081 ON DBLCLICK (a711TpST:=CA712Troca(oQual:nAt,a711TpST),oQual:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oQual,oOk,oNo,@a711TpST) NoScroll OF oDlg PIXEL	//"Tipos de Material"

oQual:SetArray(a711TpST)
oQual:bLine := { || {If(a711TpST[oQual:nAt,1],oOk,oNo),a711TpST[oQual:nAt,2]}}

@ 12,221 CHECKBOX oChkQual2 VAR lQual2 PROMPT OemToAnsi(STR0020) SIZE 50, 10 OF oDlg PIXEL ON CLICK (AEval(A711GrpST, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual2:Refresh(.F.)) //"Inverter Selecao"
@ 22,216 LISTBOX oQual2 VAR cVarQ2 Fields HEADER "",OemToAnsi(STR0022)  SIZE 78,081 ON DBLCLICK (A711GrpST:=CA712Troca(oQual2:nAt,A711GrpST),oQual2:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oQual2,oOk,oNo,@A711GrpST) NoScroll OF oDlg  PIXEL	//"Grupos de Material"

oQual2:SetArray(A711GrpST)
oQual2:bLine := { || {If(A711GrpST[oQual2:nAt,1],oOk,oNo),A711GrpST[oQual2:nAt,2]}}

@ 105,130 CHECKBOX oChkQual3 VAR lQual3 PROMPT OemToAnsi(STR0020) SIZE 50, 10 OF oDlg PIXEL ON CLICK (AEval(_a711NNR, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual3:Refresh(.F.)) //"Inverter Selecao"
@ 115,125 LISTBOX oQual3 VAR cVarQ3 Fields HEADER "",OemToAnsi("Locais de Estoque")  SIZE 170,065 ON DBLCLICK (A711NNR:=CA712Troca(oQual3:nAt,_A711NNR),oQual3:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oQual3,oOk,oNo,@A711NNR) NoScroll OF oDlg  PIXEL	//"Grupos de Material"

oQual3:SetArray(_A711NNR)
oQual3:bLine := { || {If(_A711NNR[oQual3:nAt,1],oOk,oNo),_A711NNR[oQual3:nAt,2]}}


ACTIVATE MSDIALOG oDlg CENTERED

Return Nil

// MV_PAR08    ->  De Local                   1- Sim            2- Nao                //
// MV_PAR09    ->  Ate Local                  1- Sim            2- Nao                //

//==================================================
Static Function GeraMRP()

Local nTipoPer  :=  nRadMenu1 //2   //-> Tipo de período 1=Diário;2=Semanal;3=Quinzenal;4=Mensal;5=Trimestral;6=Semestral;7=Diversos
Local nPeriodos :=  nGet1 //4   //-> Quantidade de períodos

Local aLocais := {}
Local lBatch    := .T.  //-> Identifica MRP rodado em modo Batch
Local lLogMrp   := .F.  //-> Indica se monta log do MRP
Local cNumOpDig := GetSX8Num("SC2","C2_NUM") //-> Número da Op Inicial
Local cDatabase := DtoC(dDatabase)
Local aPerOP := {1,3,5} // {0,0,0}
Local aPerSC := {1,3,5}
Local lMaxItemOp := .F.
Local aDataDiv := {}
Local i := 0
Local cDescAL := ''

PRIVATE	 _lGeraOpSc := .T.  //-> Gera/Não Gera OPs e SCs depois do cálculo da necessidade.

Public _MVSTECK08 := ""
Public _MVSTECK09 := ""
Public _MVSTECK10 := 2 // Gera SC/OP
Public _MVSTECK11 := 1 // Apaga SC Prevista
Public _MVSTECK35 := 1 // Mostra tela após calculo
Public _MVSTECK26 := 1 // Considera Est. seguranca somente para armazem 01
Public _MVSTECK23 := '      ' // PV/PMP De  Documento
Public _MVSTECK24 := 'ZZZZZZ' // MV_PAR24    ->  PV/PMP Ate Documento
Public _MVSTECK20 := 2 //  Qtd. nossa Poder 3         1- Soma           2- Ignora             //
PUBLIC lPedidos   := lCheckBo1 //.F.  //-> Considera Pedidos em Carteira

oDlg:End()

Pergunte("MTA712",.F.)

_MVSTECK04 := MV_PAR04
_MVSTECK05 := MV_PAR05
_MVSTECK06 := MV_PAR06
_MVSTECK08 := MV_PAR08
_MVSTECK09 := MV_PAR09
//_MVSTECK10 := 1 //MV_PAR10
_MVSTECK11 := MV_PAR11
_MVSTECK20 := MV_PAR20 // Qtd. nossa Poder 3         1- Soma           2- Ignora             //
_MVSTECK23 := MV_PAR23 // PV/PMP De  Documento
_MVSTECK24 := MV_PAR24 // MV_PAR24    ->  PV/PMP Ate Documento
_MVSTECK26 := MV_PAR26
_MVSTECK35 := MV_PAR35

If MV_PAR01 == 2 // PMP
	MsgInfo("Esta rotina s� pode ser utilizada com Prev.Vendas e/ou Pedidos";
			+CHR(13)+CHR(10);
			+CHR(13)+CHR(10);
			+"Altere o primeiro par�metro !", "Info")
	RETURN		
ENDIF

cQuery := "SELECT C4_LOCAL AS LOCAIS FROM "+RETSQLNAME("SC4")+" WHERE D_E_L_E_T_='' "
cQuery += "AND C4_FILIAL='"+XFILIAL("SC4")+"' AND C4_LOCAL<>'' "
cQuery += "AND C4_LOCAL>='"+_MVSTECK08+"' AND C4_LOCAL<='"+_MVSTECK09+"' "
cQuery += "AND C4_DOC>='"+_MVSTECK23+"' AND C4_DOC<='"+_MVSTECK24+"' "
cQuery += "AND C4_DATA>='"+DTOS(_MVSTECK05)+"' AND C4_DATA<='"+DTOS(_MVSTECK06)+"' "
cQuery += "GROUP BY C4_LOCAL "

cQuery := ChangeQuery(cQuery)

TCQUERY cQuery NEW ALIAS "SC4A"

SC4A->(DBGOTOP())
While !SC4A->(eof())
	AADD(aLocais, {SC4A->LOCAIS })
	SC4A->(DBskip())
End
SC4A->(DBCLOSEAREA())

//se aLocais estiver em brando Checar Locais no SC6
IF lCheckBo1
	cQuery := "SELECT C6_LOCAL AS LOCAIS FROM "+RETSQLNAME("SC6")+", "+RETSQLNAME("SF4")+" WHERE "+RETSQLNAME("SC6")+".D_E_L_E_T_='' "
	cQuery += "AND " +RETSQLNAME("SF4")+".D_E_L_E_T_='' "
	cQuery += "AND C6_FILIAL='"+XFILIAL("SC6")+"' "
	cQuery += "AND F4_FILIAL='"+XFILIAL("SF4")+"' "
	cQuery += "AND C6_TES=F4_CODIGO AND F4_DUPLIC='S' "
	//cQuery += "AND C6_LOCAL>='"+_MVSTECK08+"' AND C6_LOCAL<='"+_MVSTECK09+"' "
	cQuery += "AND C6_ENTREG>='"+DTOS(_MVSTECK05)+"' AND C6_ENTREG<='"+DTOS(_MVSTECK06)+"' "
	cQuery += "AND (C6_QTDENT < C6_QTDVEN) AND C6_OP <>'02' "
	cQuery += "GROUP BY C6_LOCAL "

	cQuery := ChangeQuery(cQuery)

	TCQUERY cQuery NEW ALIAS "SC6A"

	SC6A->(DBGOTOP())
	While !SC6A->(eof())
		nPos := aScan(aLocais,{|x| ALLTrim(x[1])==SC6A->LOCAIS })
		IF nPos == 0
			AADD(aLocais, {SC6A->LOCAIS })
		ENDIF	
		SC6A->(DBskip())
	End
	SC6A->(DBCLOSEAREA())
Endif


If _MVSTECK11==1
	PROCESSA( {|| EncerOP() }, "Encerrando OP's e SC's Previstas" )

	/// Excluir SC's Previstas
	cQuery := "UPDATE "+RETSQLNAME("SC1")+" SET D_E_L_E_T_='*',R_E_C_D_E_L_=R_E_C_N_O_, C1_OBS='CANCELADA PELO SISTEMA.' "
	cQuery += "WHERE C1_TPOP='P' AND D_E_L_E_T_='' "
	TCSQLEXEC(cQuery)
Endif

// Durante o processamentos dos Locais n�o limpar novamemnte as Previstas
MV_PAR11 := 2 
lPedidos := lCheckBo1
MV_PAR04 := iif(_lGeraOpSc,1,MV_PAR04) // 1 gera OP/SC junto - 2 Gera separado OP/SC

//limpar as filiais PARA O LOCAIS QUE NAO ESTAO SENDO EXECUTADOS
// na MATA712 nao tem ponto de entrada para filtrar o local ns SC4
/*
cQuery := "UPDATE "+RETSQLNAME("SC4")+" SET C4_XLOCANT=C4_LOCAL, C4_XFILANT=C4_FILIAL WHERE C4_XLOCANT='  ' AND C4_XFILANT='  ' AND D_E_L_E_T_<>'*' " 
If TcSqlExec(cQuery) > 0
	MsgAlert('Problema na ATUALIZACAO das previs�es !','AVISO')
	RETURN
Endif
*/

ASort(aLocais,,,{|x,y| (x[1]) < (y[1])})
lview := .f.

For i:=1 to Len(aLocais)
	
	//IF MSGYESNO("Processar MRP do Armazém: "+aLocais[i]+" ?")
	IF NNR->(DBSEEK(XFILIAL("NNR") + aLocais[i,1] ))
		cDescAL := NNR->NNR_DESCRI
	Endif
	
	_MVSTECK08 := aLocais[i,1] // Local De
	_MVSTECK09 := aLocais[i,1] // Local Ate

	// Setar como nao, para nao apagar as OP's e SC's dos calculos anteriores
	_MVSTECK11 := 2

	_lGeraOpSc := lCheckOp 	// gera OP/SC automatico
	lPedidos   := lCheckBo1	// Considera Pedidos em carteira

	If MsgYesNo("Processa o Armazem: "+_MVSTECK08+" ?", "Info")
		PROCESSA( {|| U_MATA712(lBatch,{nTipoPer,nPeriodos,lPedidos,a711TpST,A711GrpST,_lGeraOpSc,lLogMRP,cNumOpDig,cDatabase,aPerOP,aPerSC,lMaxItemOp,aDataDiv}) }, ;
		"Processando Destino "+_MVSTECK08+" - "+cDescAL +chr(13)+chr(10)+chr(13)+chr(10)+"." ) 

		If _lGeraOpSc==.F.
			U_MATA712()
		Else
			If MsgYesNo("Deseja Visualizar os Resultados ?", "Info")
				U_MATA712()
			Endif
		Endif		
	Endif
	
Next

Return Nil
//===============================================================
Static Function EncerOP()

Local aMATA650 := {} //-Array com os campos
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ 3 - Inclusao ³
//³ 4 - Alteracao ³
//³ 5 - Exclusao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpc := 5
Local cQuery:= "SELECT * FROM "+RETSQLNAME("SC2")+" WHERE D_E_L_E_T_='' AND C2_TPOP='P' AND C2_FILIAL='"+XFILIAL("SC2")+"' ORDER BY C2_NUM "  // Previstas
Private lMsErroAuto := .F.

TCQUERY cQuery NEW ALIAS "SC2A"

SC2A->(DbGotop())

While !SC2A->(eof())
	
	aMATA650 := { {'C2_FILIAL' ,XFILIAL("SC1") ,NIL},;
	{'C2_NUM' ,SC2A->C2_NUM ,NIL},;
	{'C2_ITEM' ,SC2A->C2_ITEM ,NIL},;
	{'C2_SEQUEN' ,SC2A->C2_SEQUEN ,NIL},;
	{'C2_PRODUTO' ,SC2A->C2_PRODUTO ,NIL},;
	{'C2_LOCAL' ,SC2A->C2_LOCAL ,NIL},;
	{'AUTEXPLODE' ,"S" ,NIL}}
	
	SC2->(DBGOTO(SC2A->R_E_C_N_O_ ))
	msExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc)
	If !lMsErroAuto
		ConOut("Sucesso! ")
	Else
		ConOut("Erro!")
		//MostraErro()
	EndIf
	
	SC2A->(DbSkip())
End

SC2A->(DBCLOSEAREA())

Return Nil

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

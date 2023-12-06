#INCLUDE "RWMAKE.CH"
#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

#DEFINE _OPC_cGETFILE ( GETF_RETDIRECTORY + GETF_ONLYSERVER + GETF_LOCALHARD + GETF_LOCALFLOPPY )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ BOLITAU  ³ Autor ³ Giovani Zago          ³ Data ³ 06/04/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO BANCO ITAU COM CODIGO DE BARRAS        ³±±
±±³			Faturamento												  	   ±±³
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STITAU01()
	LOCAL	aPergs := {}
	PRIVATE lExec    := .F.
	PRIVATE cIndexName := ''
	PRIVATE cIndexKey  := ''
	PRIVATE cFilter    := ''
	Private _cBanco	:= ""
	Private _cBancoR  := ""

	Tamanho  := "M"
	titulo   := "Impressao de Boleto com Codigo de Barras"
	cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
	cDesc2   := ""
	cDesc3   := ""
	cString  := "SE1"
	wnrel    := "BOL341"
	lEnd     := .F.
	cPerg     :="BOL341    "
	aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	nLastKey := 0

	If !( __cUserId $ GetMv("ST_PDFBOL",,"000000/000645")+'/000000/000645')
		MsgInfo("Usuario sem acesso: "+__cuserid)
		Return()
	EndIf
	dbSelectArea("SE1")

	//_cCaminho	:= cGetFile( "Selecione o Diretorio | " , OemToAnsi( "Selecione Diretorio" ) , NIL , "" , .F. , _OPC_cGETFILE )

	MakeDir("C:\arquivos_protheus")
	MakeDir("C:\arquivos_protheus\boletos")

	_cCaminho   := "C:\arquivos_protheus\boletos"

	Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Numero","","","mv_ch3","C",9,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",9,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Parcela","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Portador","","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	Aadd(aPergs,{"Ate Portador","","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	Aadd(aPergs,{"De Cliente","","","mv_ch9","C",6,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Cliente","","","mv_cha","C",6,0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Loja","","","mv_chb","C",2,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Loja","","","mv_chc","C",2,0,0,"G","","MV_PAR12","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Emissao","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Emissao","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Vencimento","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Vencimento","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Do Bordero","","","mv_chh","C",6,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Bordero","","","mv_chi","C",6,0,0,"G","","MV_PAR18","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})

	AjustaSx1("BOL341    ",aPergs)

	Pergunte (cPerg,.t.)

	cIndexName	:= Criatrab(Nil,.F.)
	//cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
	cIndexKey	:= "E1_PORTADO+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+DTOS(E1_EMISSAO)" //alterado Por Nádia em 12/08/13
	cFilter		+= "E1_SALDO>0.And."
	cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And."
	cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
	cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
	cFilter		+= "E1_PORTADO>='" + MV_PAR07 + "'.And.E1_PORTADO<='" + MV_PAR08 + "'.And."
	cFilter		+= "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR10 + "'.And."
	cFilter		+= "E1_LOJA>='" + MV_PAR11 + "'.And.E1_LOJA<='"+MV_PAR12+"'.And."
	cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par13)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par14)+"'.And."
	cFilter		+= 'DTOS(E1_VENCREA)>="'+DTOS(mv_par15)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par16)+'".And.'
	cFilter		+= "E1_NUMBOR>='" + MV_PAR17 + "'.And.E1_NUMBOR<='" + MV_PAR18 + "'.And."
	cFilter		+= "!(E1_TIPO$MVABATIM).And."
	cFilter		+= "E1_PORTADO $ ('001#341#237') "

	IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
	DbSelectArea("SE1")
	#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
	#ENDIF
	dbGoTop()
	@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
	@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
	@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
	@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
	ACTIVATE DIALOG oDlg CENTERED

	dbGoTop()
	If lExec

		_cTitulo := ""
		_aParcs  := {}

		dbGoTop()
		ProcRegua(RecCount())
		Do While !EOF()

			If Marked("E1_OK")

				_cTitulo := SE1->E1_NUM

				AADD(_aParcs,SE1->E1_PARCELA)

				MV_PAR01 := SE1->E1_NUM
				MV_PAR02 := SE1->E1_NUM
				MV_PAR03 := SE1->E1_PREFIXO
				MV_PAR04 := 2
				MV_PAR05 := 2
				MV_PAR06 := 2
				//Processa({U_MONTAR(,,,,.T.,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR01,,)})

				_aAreaSE1 := SE1->(GetArea())
				SE1->(DbSkip())
				If SE1->(Eof())
					SE1->(DbSkip(-1))
					U_MONTAR(,,,,.T.,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR01,,,.t.,_cCaminho,_aParcs)
					_aParcs := {} 
				Else
					If !(SE1->E1_NUM==_cTitulo)
						SE1->(DbSkip(-1))
						U_MONTAR(,,,,.T.,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR01,,,.t.,_cCaminho,_aParcs)
						_aParcs := {}
					EndIf
				EndIf
				RestArea(_aAreaSE1)

				//U_MONTAR(,,,,.T.,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR01,,,.t.,_cCaminho,SE1->E1_PARCELA)
				MsUnLockAll()
				Sleep(5000)
				StartJob("U_EnvBolItau",GetEnvServer(), .F.,"\arquivos\BOLETOS_ITAU\" , MV_PAR01+ "_BOLETO.pdf",MV_PAR19)

			EndIf

			DbSkip()

		EndDo
		//MsgInfo("Boletos Gerados e enviados....!!!!!")
	Endif
	RetIndex("SE1")
	Ferase(cIndexName+OrdBagExt())

	Return Nil

return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MontaR(xBanco,xAgencia,xConta,xSubCt,lSetup,cNotIni,cNotFim,cSerie,cChave,_cCliente,_cLoja,_lImpPr,_cCaminho,_aParcs)

	LOCAL oPrint
	LOCAL nX := 0

	//--- Marciane 11.10.05 - Criar variaveis para a agencia
	Local _cNomeAgen := ""
	Local _cCNPJAgen := ""
    Local cCNPJX := ""
	LOCAL aDadosEmp    := {}
	Local _cMulta	   := GetMV("MV_XTXMUL")
	LOCAL aDadosTit
	LOCAL aDadosBanco
	LOCAL aDatSacado
	LOCAL nI           := 1
	LOCAL aCB_RN_NN    := {}
	LOCAL nVlrAbat		:= 0
	Local xSetup       := iif(lSetup==nil,.f.,lSetup)
	Local _nX

	Local _cQuery	:= ""
	Local _cAlias	:= GetNextAlias()
	Private _cBanco	:= ""
	Private _cBancoR  := ""
	PRIVATE cStartPath 	  := ''
	PRIVATE _cNomePdf     :=''
	Private _cDirRel      := ''
	Default	_cCliente	:= ""
	Default	_cLoja	:= ""
	Default _cCaminho := 'C:\ARQUIVOS_PROTHEUS\BOLETOS_CITI\'+cEmpAnt
	Default _aParcs   := {}

DbSelectArea("SM0")
SM0->(dbSetOrder(1))
SM0->(dbSeek(cEmpAnt + cFilAnt))
cCNPJX := StrTran(AllTrim(SM0->M0_CGC),".","")
aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
	SM0->M0_ENDCOB                                     							,; //[2]Endereço
	AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
	"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
	"PABX/FAX: "+"55-11-22067610"                                                  ,; //[5]Telefones
	"CNPJ: "+Subs(cCNPJX,1,2)+"."+Subs(cCNPJX,3,3)+"."+          ; //[6]
	Subs(cCNPJX,6,3)+"/"+Subs(cCNPJX,9,4)+"-"+                       ; //[6]
	Subs(cCNPJX,13,2)                                                    ,; //[6]CGC
	"I.E.: "+Subs("116686352116",1,3)+"."+Subs("116686352116",4,3)+"."+            ; //[7]
	Subs("116686352116",7,3)+"."+Subs("116686352116",10,3)                        }  //[7]I.E

	_cDirRel := _cCaminho

	IncProc()
	_cQuery	:= " SELECT E1_FILIAL, E1_NUM, E1_PREFIXO, E1_CLIENTE, E1_LOJA, E1.R_E_C_N_O_ REGISTRO "
	_cQuery += " FROM "+RetSqlName("SE1")+"  E1 "
	_cQuery += " WHERE E1.D_E_L_E_T_=' '  AND E1_NUM BETWEEN '"+cNotIni+"' AND '"+cNotIni+"' "
	//  AND F2_FILIAL='"+cFilAnt+"'
	_cQuery += " AND E1_PREFIXO='"+cSerie+"' "

	If Len(_aParcs)>0
		_cQuery += " AND (
		For _nX:=1 To Len(_aParcs)
			_cQuery += " (E1_PARCELA='"+_aParcs[_nX]+"')
			If !(_nX==Len(_aParcs))
				_cQuery += " OR
			EndIf
		Next
		_cQuery += " )
	EndIf

	_cQuery += " AND E1_SALDO>0 AND E1_PORTADO = '341' "
	//_cQuery += " AND E1_XIMPBOL='1' AND E1_XFORMPG='BOL'  "

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())

	cNroDoc :=  " "

	//if isBlind()
	//_cDir 			:= "\BOLETOS_ITAU\"
	cStartPath 	  	:= "\arquivos\BOLETOS_ITAU\"
	_cNomePdf     	:= AllTrim(cChave)+ '_BOLETO'
	If _lImpPr
		//_cDirRel      	:=  'C:\ARQUIVOS_PROTHEUS\BOLETOS_ITAU\'+cEmpAnt
		If ! (ExistDir(_cDirRel))
			If MakeDir(_cDirRel) == 0
				MakeDir(_cDirRel)
			Endif
		Endif
	Endif

	//oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , '\orcamento\'  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
	//oPrint := FwMSPrinter():New(_cNomePdf , 6 , .f. , _cDir, .T., , , ,.f. , .F., ,.f. )
	oPrint := FwMSPrinter():New(_cNomePdf , IMP_PDF , .T. , cStartPath,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )//, .T., , , , , .F., ,!isBlind() )
	oPrint:SetPortrait()
	oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:SetMargin(5,5,5,0)

	cIndexName := ''
	cIndexKey  := ''
	cFilter    := ''

	Tamanho            := "M"
	titulo             := "Impressao de Boleto com Codigo de Barras"
	cDesc1             := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
	cDesc2             := ""
	cDesc3             := ""
	cString            := "SE1"
	wnrel              := "RFINR01"
	cPerg              := "FINR01"
	aReturn            := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
	nLastKey           := 00
	lEnd               := .F.

	cIndexName	:= Criatrab(Nil,.F.)
	//--- Pela chamada da DANFE não imprimir boleto se já imprimiu uma vez.
	cIndexKey	:= "E1_PORTADO+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+DTOS(E1_EMISSAO)"  //alterado ordem impressão por Nádia em 12/08/13
	cFilter		+= "E1_FILIAL =='"+xFilial("SE1")+"'.And.E1_SALDO>0.And. "
	//	cFilter		+= "E1_PREFIXO =='" + cSerie + "'.And. "
	cFilter		+= "E1_SERIE =='" + cSerie + "'.And. "

	cFilter		+= " ( "
	While (_cAlias)->(!Eof())
		//cFilter		+= "E1_NUM>='" + cNotIni + "'.And.E1_NUM<='" + cNotFim + "'.And. "
		cFilter		+= " ( E1_NUM=='"+(_cAlias)->E1_NUM+"' .And. E1_CLIENTE=='"+(_cAlias)->E1_CLIENTE+"' .And. E1_LOJA='"+(_cAlias)->E1_LOJA+"' ) "
		(_cAlias)->(DbSkip())

		If (_cAlias)->(!Eof())
			cFilter		+= " .Or. "
		EndIf

	EndDo
	cFilter		+= " ) "

	cFilter		+= " .And. !(E1_TIPO$MVABATIM) .and. "
	cFilter		+= "E1_PORTADO <> '   ' .and. SE1->E1_XIMPBOL == '1'  "
	/*
	If !Empty(_cCliente) .And. !Empty(_cLoja)
	cFilter		+= " .And. E1_CLIENTE=='"+_cCliente+"' .And. E1_LOJA=='"+_cLoja+"'  "
	EndIf
	*/

	//IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
	dbSelectArea("SE1")

	SE1->(dbGoTop())
	ProcRegua(RecCount())

	(_cAlias)->(dbGoTop())

	Do While (_cAlias)->(!EOF())

		SE1->(DbGoTo((_cAlias)->REGISTRO))

		//Posiciona o SA6 (Bancos)
		DbSelectArea("SA6")
		DbSetOrder(1)
		DbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,.T.)

		//Posiciona na Arq de Parametros CNAB
		DbSelectArea("SEE")
		DbSetOrder(1)
		// ALTERADO EM 050112
		If !DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
			if IsInCallStack("U_GC05A07")
				//	RecLock("SF2",.F.)
				//	SF2->F2_XEXPBOL := "E"
				//	SF2->(MsUnlock())
			else
				MsgBox("Banco/Ag/conta nao cadastrado em parametros de bancos ref titulo: " + SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
			endif
			DbSelectArea("SE1")
			DbSkip()
			Loop
		endif

		Do Case
			Case SEE->EE_CODIGO=="341"
			_cBanco := "Banco Itaú SA"
			_cBancoR:= "ITAÚ"
			Case SEE->EE_CODIGO=="237"
			_cBanco := "Banco Bradesco"
			_cBancoR:= "Bradesco"
			Case SEE->EE_CODIGO=="001"
			_cBanco := "Banco do Brasil"
			_cBancoR:= "Banco do Brasil"
		EndCase

		ccart := '112'

		cNroDoc	:=  Alltrim(SE1->E1_NUMBCO)

		// calcula valor dos abatimentos
		nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		_nMoll:= 0
		_nMoll:=    (SE1->E1_SALDO - nVlrAbat)
		_nMoll:=  Round(( 5.9 * _nMoll/30/100),2)
		cmsg1 := "APOS O VENCIMENTO COBRAR MORA DE R$ " + AllTrim(Transform(_nMoll ,"@E 999,999,999.99")) + " AO DIA"

		cmsg2 := " "

		cmsg3 :="SUJEITO A PROTESTO SE NAO FOR PAGO NO VENCTO"
		cmsg4 := "REF. NF: "+SE1->E1_NUM+SE1->E1_PARCELA
		cmsg5 := "COBRANCA ESCRITURAL."

		aBolText     := {cmsg1 ,;
		cmsg2 ,;
		cmsg3 ,;
		cmsg4 ,;
		cmsg5 ,}

		//Posiciona o SA1 (Cliente)
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)

		DbSelectArea("SE1")
		If Empty(Alltrim(SA6->A6_DVCTA))
			aDadosBanco  := {SA6->A6_COD                           ,;   // [1]Numero do Banco
			_cBanco       	          	                           ,;   //SA6->A6_NOME [2]Nome do Banco
			SUBSTR(SA6->A6_AGENCIA, 1, 4)                          ,; 	// [3]Agência
			SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1),; 	// [4]Conta Corrente 5 digitos
			SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)  ,; 	// [5]Dígito da conta corrente 1 digito
			ccart                                             		}	// [6]Codigo da Carteira
		Else
			aDadosBanco  := {SA6->A6_COD                           ,;   // [1]Numero do Banco
			_cBanco       	          	                           ,;   // SA6->A6_NOME [2]Nome do Banco
			SUBSTR(SA6->A6_AGENCIA, 2, 4)                          ,;   // [3]Agência
			Alltrim(SA6->A6_NUMCON)                                ,;   // [4]Conta Corrente 5 digitos
			SA6->A6_DVCTA                                          ,;   // [5]Dígito da conta corrente 1 digito
			ccart                                             		}   // [6]Codigo da Carteira
		Endif

		If Empty(SA1->A1_ENDCOB)
			aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
			AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endereço
			AllTrim(SA1->A1_MUN )                            ,;  		// [4]Cidade
			SA1->A1_EST                                      ,;    		// [5]Estado
			SA1->A1_CEP                                      ,;      	// [6]CEP
			SA1->A1_CGC										          ,;  			// [7]CGC
			SA1->A1_PESSOA										}       				// [8]PESSOA
		Else
			aDatSacado   := {AllTrim(SA1->A1_NOME)            	 ,;   	// [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]Código
			AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
			AllTrim(SA1->A1_MUNC)	                             ,;   	// [4]Cidade
			SA1->A1_ESTC	                                     ,;   	// [5]Estado
			SA1->A1_CEPC                                        ,;   	// [6]CEP
			SA1->A1_CGC												 		 ,;		// [7]CGC
			SA1->A1_PESSOA												 }				// [8]PESSOA
		Endif

		//nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

		//Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo.
		//Abaixo apenas uma sugestao
		//cNroDoc	:= StrZero(	Val(Alltrim(SE1->E1_NUM)+Alltrim(SE1->E1_PARCELA)),8)

		If AllTrim(SE1->E1_PORTADO)=="237" //Bradesco
			aDadosEmp[1] := "GC DISTRIBUIDORA LTDA"
		EndIf

		//Monta codigo de barras
		If AllTrim(SE1->E1_PORTADO)=="237" //Bradesco
			aCB_RN_NN    := Ret_cBarr2(aDadosBanco[1],aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cCart,cNroDoc,(E1_VALOR-nVlrAbat),E1_VENCREA)
		ElseIf AllTrim(SE1->E1_PORTADO)=="001" //BB
			aCB_RN_NN    := Ret_cBarr3(aDadosBanco[1],aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cCart,cNroDoc,(E1_VALOR-nVlrAbat),E1_VENCREA)
		Else
			aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cNroDoc,(E1_VALOR-nVlrAbat),E1_VENCREA)
		EndIf

		//Preciso da agencia para ser o sacador/avalista do boleto
		_cNomeAgen := ""
		_cCNPJAgen := ""
		aDadosTit	:= {AllTrim(E1_NUM)                 		,;  // [1] Número do título            //tinha o numero da parcela, retirei pois so é usado na impressao
		E1_EMISSAO                          ,;  // [2] Data da emissão do título
		dDataBase                    		,;  // [3] Data da emissão do boleto
		E1_VENCREA                           ,;  // [4] Data do vencimento
		(E1_SALDO - nVlrAbat)               ,;  // [5] Valor do título
		aCB_RN_NN[3]                        ,;  // [6] Nosso número (Ver fórmula para calculo)
		E1_PREFIXO                          ,;  // [7] Prefixo da NF
		E1_TIPO	                           	,;  // [8] Tipo do Titulo
		_cNomeAgen                      	,;  // [9] Nome da Agencia
		_cCNPJAgen                      	,;  // [10] CNPJ/CPF da Agencia
		E1_VALJUR                           ,}  // [11] Valor Taxa de Permanencia Diaria
		//         " parc.: " + STRZERO(QTPARC,2) + " de " +STRZERO(Val(nrparc),2)         }  // [12] Quantidade de parcelas
		//			" parc.: " + STRZERO(VAL(nrparc),2) + " de " +STRZERO(QTPARC,2)

		//	If Marked("E1_OK")
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,SE1->E1_PARCELA)
		nX := nX + 1
		//	EndIf
		(_cAlias)->(dbSkip())
		IncProc()
		nI := nI + 1
	EndDo

	FERASE(cStartPath + _cNomePdf+".pdf")
	oPrint:cPathPDF := cStartPath//"c:\"
	oPrint:Print()
	oPrint:EndPage()
	If _lImpPr
		FERASE(_cDirRel+"\"+_cNomePdf+".pdf")
		CpyS2T(cStartPath+_cNomePdf+'.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
		//ShellExecute("open",_cDirRel+"\"+_cNomePdf+'.pdf', "", "", 1)
	EndIf

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,_cParcela)
	LOCAL oFont8
	LOCAL oFont9n
	LOCAL oFont11c
	LOCAL oFont10
	LOCAL oFont14
	LOCAL oFont16n
	LOCAL oFont15
	LOCAL oFont14n
	LOCAL oFont24
	LOCAL nI := 0

	//Parametros de TFont.New()
	//1.Nome da Fonte (Windows)
	//3.Tamanho em Pixels
	//5.Bold (T/F)
	/*
	oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9n  := TFont():New("Arial",9,9,.T.,.T.,5,.T.,5,.T.,.F.)      //criado em 28/12/2011 - Renan - TOTVS
	oFont11a := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)   //Criano em 08/05/2013 - Natanael Simões - Grand Cru
	oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
	*/

	oFont8   := TFont():New("Arial",,8+4,.T.,.F.)
	oFont9n  := TFont():New("Arial",,9+4,.T.,.T.)
	oFont11a := TFont():New("Arial",,11+4,.T.,.T.)
	oFont11c := TFont():New("Courier New",,11+4,.T.,.T.)
	oFont10  := TFont():New("Arial",,10+4,.T.,.T.)
	oFont14  := TFont():New("Arial",,14+4,.T.,.T.)
	oFont20  := TFont():New("Arial",,20+4,.T.,.T.)
	oFont21  := TFont():New("Arial",,21+4,.T.,.T.)
	oFont16n := TFont():New("Arial",,16+4,.T.,.F.)
	oFont15  := TFont():New("Arial",,15+4,.T.,.T.)
	oFont15n := TFont():New("Arial",,15+4,.T.,.F.)
	oFont14n := TFont():New("Arial",,14+4,.T.,.F.)
	oFont24  := TFont():New("Arial",,24+4,.T.,.T.)

	oPrint:StartPage()   // Inicia uma nova página

	/******************/
	/* PRIMEIRA PARTE */
	/******************/

	nRow1 := 0

	oPrint:Line (nRow1+0150,500,nRow1+0070, 500)
	oPrint:Line (nRow1+0150,710,nRow1+0070, 710)

	oPrint:Say  (nRow1+0084+(oFont14:nHeight*2),100,aDadosBanco[2],oFont14 )	// [2]Nome do Banco

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow1+0075+(oFont21:nHeight*2),513,aDadosBanco[1]+"-2",oFont21 )		// [1]Numero do Banco
	Else
		oPrint:Say  (nRow1+0075+(oFont21:nHeight*2),513,aDadosBanco[1]+"-7",oFont21 )		// [1]Numero do Banco
	EndIf

	oPrint:Say  (nRow1+0084+(oFont10:nHeight*2),1900,"Comprovante de Entrega",oFont10)
	oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow1+0150+(oFont8:nHeight*2),100 ,"Beneficiário",oFont8)
	Else
		oPrint:Say  (nRow1+0150+(oFont8:nHeight*2),100 ,"Cedente",oFont8)
	EndIf
	oPrint:Say  (nRow1+0200+(oFont10:nHeight*2),100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow1+0150+(oFont8:nHeight*2),1060,"Agência/Código Beneficiário",oFont8)
		oPrint:Say  (nRow1+0200+(oFont10:nHeight*2),1060,SubStr(aDadosBanco[3],1,4)+"-8"+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
	Else
		oPrint:Say  (nRow1+0150+(oFont8:nHeight*2),1060,"Agência/Código Cedente",oFont8)
		oPrint:Say  (nRow1+0200+(oFont10:nHeight*2),1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
	EndIf

	oPrint:Say  (nRow1+0150+(oFont8:nHeight*2),1510,"Nro.Documento",oFont8)
	//oPrint:Say  (nRow1+0200+(oFont9n:nHeight*2),1510,aDadosTit[7]+aDadosTit[1],oFont9n) //Prefixo +Numero+Parcela    28/12/2011 -> alterado oFont10 para oFont9n
	oPrint:Say  (nRow1+0200+(oFont9n:nHeight*2),1510,AllTrim(_cParcela)+" "+aDadosTit[1],oFont9n) //Prefixo +Numero+Parcela    28/12/2011 -> alterado oFont10 para oFont9n
	//oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow1+0250+(oFont8:nHeight*2),100 ,"Pagador",oFont8)
	Else
		oPrint:Say  (nRow1+0250+(oFont8:nHeight*2),100 ,"Sacado",oFont8)
	EndIf
	oPrint:Say  (nRow1+0300+(oFont10:nHeight*2),100 ,aDatSacado[1],oFont10)				//Nome

	oPrint:Say  (nRow1+0250+(oFont8:nHeight*2),1060,"Vencimento",oFont8)
	oPrint:Say  (nRow1+0300+(oFont10:nHeight*2),1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

	oPrint:Say  (nRow1+0250+(oFont8:nHeight*2),1510,"Valor do Documento",oFont8)
	oPrint:Say  (nRow1+0300+(oFont10:nHeight*2),1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

	oPrint:Say  (nRow1+0400+(oFont10:nHeight*2),0100,"Recebi(emos) o bloqueto/título",oFont10)
	oPrint:Say  (nRow1+0450+(oFont10:nHeight*2),0100,"com as características acima.",oFont10)
	oPrint:Say  (nRow1+0350+(oFont8:nHeight*2),1060,"Data",oFont8)
	oPrint:Say  (nRow1+0350+(oFont8:nHeight*2),1410,"Assinatura",oFont8)
	oPrint:Say  (nRow1+0450+(oFont8:nHeight*2),1060,"Data",oFont8)
	oPrint:Say  (nRow1+0450+(oFont8:nHeight*2),1410,"Entregador",oFont8)

	oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 )
	oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )
	oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 ) //---
	oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )

	oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
	oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
	oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) //--
	oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )

	oPrint:Say  (nRow1+0165+(oFont8:nHeight*2),1910,"(  )Mudou-se"                                	,oFont8)
	oPrint:Say  (nRow1+0205+(oFont8:nHeight*2),1910,"(  )Ausente"                                    ,oFont8)
	oPrint:Say  (nRow1+0245+(oFont8:nHeight*2),1910,"(  )Não existe nº indicado"                  	,oFont8)
	oPrint:Say  (nRow1+0285+(oFont8:nHeight*2),1910,"(  )Recusado"                                	,oFont8)
	oPrint:Say  (nRow1+0325+(oFont8:nHeight*2),1910,"(  )Não procurado"                              ,oFont8)
	oPrint:Say  (nRow1+0365+(oFont8:nHeight*2),1910,"(  )Endereço insuficiente"                  	,oFont8)
	oPrint:Say  (nRow1+0405+(oFont8:nHeight*2),1910,"(  )Desconhecido"                            	,oFont8)
	oPrint:Say  (nRow1+0445+(oFont8:nHeight*2),1910,"(  )Falecido"                                   ,oFont8)
	oPrint:Say  (nRow1+0485+(oFont8:nHeight*2),1910,"(  )Outros(anotar no verso)"                  	,oFont8)

	/*****************/
	/* SEGUNDA PARTE */
	/*****************/

	nRow2 := 0

	//Pontilhado separador
	For nI := 100 to 2300 step 50
		oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
	Next nI

	oPrint:Line (nRow2+0710,100,nRow2+0710,2300)
	oPrint:Line (nRow2+0710,500,nRow2+0630, 500)
	oPrint:Line (nRow2+0710,710,nRow2+0630, 710)

	oPrint:Say  (nRow2+0644+(oFont14:nHeight*2),100,aDadosBanco[2],oFont14 )		// [2]Nome do Banco

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow2+0644+(oFont10:nHeight*2),1800,"Recibo do Pagador",oFont10)
		oPrint:Say  (nRow2+0635+(oFont21:nHeight*2),513,aDadosBanco[1]+"-2",oFont21 )	// [1]Numero do Banco
	Else
		oPrint:Say  (nRow2+0644+(oFont10:nHeight*2),1800,"Recibo do Sacado",oFont10)
		oPrint:Say  (nRow2+0635+(oFont21:nHeight*2),513,aDadosBanco[1]+"-7",oFont21 )	// [1]Numero do Banco
	EndIf

	oPrint:Line (nRow2+0810,100,nRow2+0810,2300 )
	oPrint:Line (nRow2+0910,100,nRow2+0910,2300 )
	oPrint:Line (nRow2+0980,100,nRow2+0980,2300 )
	oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )

	oPrint:Line (nRow2+0910,500,nRow2+1050,500)
	oPrint:Line (nRow2+0980,750,nRow2+1050,750)
	oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
	oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
	oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)

	oPrint:Say  (nRow2+0710+(oFont8:nHeight*2),100 ,"Local de Pagamento",oFont8)
	oPrint:Say  (nRow2+0725+(oFont10:nHeight*2),400 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO "+_cBancoR,oFont10)
	oPrint:Say  (nRow2+0765+(oFont10:nHeight*2),400 ,"APÓS O VENCIMENTO, SOMENTE NO "+_cBancoR,oFont10)

	oPrint:Say  (nRow2+0710+(oFont8:nHeight*2),1810,"Vencimento"                                     ,oFont8)
	cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0750+(oFont11c:nHeight*2),nCol,cString,oFont11c)

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow2+0810+(oFont8:nHeight*2),100 ,"Beneficiário"                                        ,oFont8)
		oPrint:Say  (nRow2+0840+(oFont10:nHeight*2),100 ,AllTrim(aDadosEmp[1])+" - "+aDadosEmp[6],oFont10) //Nome + CNPJ
		oPrint:Say  (nRow2+0870+(oFont10:nHeight*2),100 ,AllTrim(aDadosEmp[2])+" - "+aDadosEmp[3],oFont10) //Nome + CNPJ
	Else
		oPrint:Say  (nRow2+0810+(oFont8:nHeight*2),100 ,"Cedente"                                        ,oFont8)
		oPrint:Say  (nRow2+0850+(oFont10:nHeight*2),100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
	EndIf

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow2+0810+(oFont8:nHeight*2),1810,"Agência/Código Beneficiário",oFont8)
		cString := Alltrim(SubStr(aDadosBanco[3],1,4)+"-8"+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	Else
		oPrint:Say  (nRow2+0810+(oFont8:nHeight*2),1810,"Agência/Código Cedente",oFont8)
		cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	EndIf

	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0850+(oFont11c:nHeight*2),nCol,cString,oFont11c)

	oPrint:Say  (nRow2+0910+(oFont8:nHeight*2),100 ,"Data do Documento"                              ,oFont8)
	oPrint:Say  (nRow2+0940+(oFont10:nHeight*2),100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

	oPrint:Say  (nRow2+0910+(oFont8:nHeight*2),505 ,"Nro.Documento"                                  ,oFont8)
	//oPrint:Say  (nRow2+0940+(oFont10:nHeight*2),505 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela            28/12/2011 alterado de oFonte10 para oFonte8
	oPrint:Say  (nRow2+0940+(oFont10:nHeight*2),505 ,+aDadosTit[1] +" "+ AllTrim(_cParcela),oFont10) //Prefixo +Numero+Parcela            28/12/2011 alterado de oFonte10 para oFonte8

	oPrint:Say  (nRow2+0910+(oFont8:nHeight*2),1005,"Espécie Doc."                                   ,oFont8)

	oPrint:Say  (nRow2+0940+(oFont10:nHeight*2),1050,"DM"										,oFont10) //Tipo do Titulo

	oPrint:Say  (nRow2+0910+(oFont8:nHeight*2),1305,"Aceite"                                         ,oFont8)
	oPrint:Say  (nRow2+0940+(oFont10:nHeight*2),1400,"A"                                             ,oFont10)

	oPrint:Say  (nRow2+0910+(oFont8:nHeight*2),1485,"Data do Processamento"                          ,oFont8)
	oPrint:Say  (nRow2+0940+(oFont10:nHeight*2),1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

	oPrint:Say  (nRow2+0910+(oFont8:nHeight*2),1810,"Nosso Número"                                   ,oFont8)

	If SEE->EE_CODIGO=="237"
		cString := Alltrim(Substr(aDadosTit[6],1,2)+"/"+Substr(aDadosTit[6],3))
	Else
		cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4))
	EndIf

	nCol := 1810+(374-(len(cString)*20))
	oPrint:Say  (nRow2+0940+(oFont11c:nHeight*2),nCol,cString,oFont11c)

	oPrint:Say  (nRow2+0980+(oFont8:nHeight*2),100 ,"Uso do Banco"                                   ,oFont8)

	oPrint:Say  (nRow2+0980+(oFont8:nHeight*2),505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (nRow2+1010+(oFont10:nHeight*2),555 ,aDadosBanco[6]                                  	,oFont10)

	oPrint:Say  (nRow2+0980+(oFont8:nHeight*2),755 ,"Espécie"                                        ,oFont8)
	oPrint:Say  (nRow2+1010+(oFont10:nHeight*2),805 ,"R$"                                             ,oFont10)

	oPrint:Say  (nRow2+0980+(oFont8:nHeight*2),1005,"Quantidade"                                     ,oFont8)
	oPrint:Say  (nRow2+0980+(oFont8:nHeight*2),1485,"Valor"                                          ,oFont8)

	oPrint:Say  (nRow2+0980+(oFont8:nHeight*2),1810,"Valor do Documento"                          	,oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+1010+(oFont11c:nHeight*2),nCol,cString ,oFont11c)

	oPrint:Say  (nRow2+1050+(oFont8:nHeight*2),100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
	oPrint:Say  (nRow2+1100+(oFont10:nHeight*2),100 ,aBolText[1],oFont10)
	oPrint:Say  (nRow2+1150+(oFont10:nHeight*2),100 ,aBolText[2],oFont10)
	oPrint:Say  (nRow2+1200+(oFont10:nHeight*2),100 ,aBolText[3],oFont10)
	//oPrint:Say  (nRow2+1200,100 ,aBolText[6],oFont10)
	oPrint:Say  (nRow2+1250+(oFont11a:nHeight*2),100 ,aBolText[4],oFont11a)
	oPrint:Say  (nRow2+1300+(oFont11a:nHeight*2),100 ,aBolText[5],oFont11a)

	oPrint:Say  (nRow2+1050+(oFont8:nHeight*2),1810,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (nRow2+1120+(oFont8:nHeight*2),1810,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (nRow2+1190+(oFont8:nHeight*2),1810,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (nRow2+1260+(oFont8:nHeight*2),1810,"(+)Outros Acréscimos"                           ,oFont8)
	oPrint:Say  (nRow2+1330+(oFont8:nHeight*2),1810,"(=)Valor Cobrado"                               ,oFont8)

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow2+1400+(oFont8:nHeight*2),100 ,"Pagador"                                         ,oFont8)
	Else
		oPrint:Say  (nRow2+1400+(oFont8:nHeight*2),100 ,"Sacado"                                         ,oFont8)
	EndIf
	oPrint:Say  (nRow2+1430+(oFont10:nHeight*2),400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
	if aDatSacado[8] = "J"
		oPrint:Say  (nRow2+1430+(oFont10:nHeight*2),1850 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:Say  (nRow2+1430+(oFont10:nHeight*2),1850 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
	EndIf
	oPrint:Say  (nRow2+1483+(oFont10:nHeight*2),400 ,aDatSacado[3]                                    ,oFont10)
	oPrint:Say  (nRow2+1536+(oFont10:nHeight*2),400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

	oPrint:Say  (nRow2+1536+(oFont10:nHeight*2),1850,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4)  ,oFont10)

	oPrint:Say  (nRow2+1605+(oFont8:nHeight*2),100 ,"",oFont8)   //Sacador/Avalista"

	//--- Marciane 11.10.05 - Imprimir os dados da agencia como sacador/Avalista
	If !Empty(aDadosTit[9])
		oPrint:Say  (nRow2+1589+(oFont10:nHeight*2),400 ,aDadosTit[9],oFont10)
		if len(alltrim(aDadosTit[10])) < 14
			oPrint:Say  (nRow2+1589+(oFont10:nHeight*2),1850,"CPF: "+TRANSFORM(aDadosTit[10],"@R 999.999.999-99"),oFont10) 	// CPF
		Else
			oPrint:Say  (nRow2+1589+(oFont10:nHeight*2),1850,"CNPJ: "+TRANSFORM(aDadosTit[10],"@R 99.999.999/9999-99"),oFont10) // CGC
		EndIf
	EndIf
	//--- fim Marciane 11.10.05

	oPrint:Say  (nRow2+1645+(oFont8:nHeight*2),1500,"Autenticação Mecânica",oFont8)

	oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 )
	oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
	oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
	oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
	oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )
	oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
	oPrint:Line (nRow2+1640,100 ,nRow2+1640,2300 )

	/******************/
	/* TERCEIRA PARTE */
	/******************/

	nRow3 := 0

	For nI := 100 to 2300 step 50
		oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
	Next nI

	oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
	oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
	oPrint:Line (nRow3+2000,710,nRow3+1920, 710)

	oPrint:Say  (nRow3+1934+(oFont14:nHeight*2),100,aDadosBanco[2],oFont14 )		// 	[2]Nome do Banco
	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+1925+(oFont21:nHeight*2),513,aDadosBanco[1]+"-2",oFont21 )	// 	[1]Numero do Banco
	Else
		oPrint:Say  (nRow3+1925+(oFont21:nHeight*2),513,aDadosBanco[1]+"-7",oFont21 )	// 	[1]Numero do Banco
	EndIf
	oPrint:Say  (nRow3+1934+(oFont15n:nHeight*2),755,aCB_RN_NN[2],oFont15n)			//		Linha Digitavel do Codigo de Barras

	oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
	oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
	oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
	oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )

	oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
	oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
	oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
	oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
	oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

	oPrint:Say  (nRow3+2000+(oFont8:nHeight*2),100 ,"Local de Pagamento",oFont8)
	oPrint:Say  (nRow3+2015+(oFont10:nHeight*2),400 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO "+_cBancoR,oFont10)
	oPrint:Say  (nRow3+2055+(oFont10:nHeight*2),400 ,"APÓS O VENCIMENTO, SOMENTE NO "+_cBancoR,oFont10)

	oPrint:Say  (nRow3+2000+(oFont8:nHeight*2),1810,"Vencimento",oFont8)
	cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol	 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2040+(oFont11c:nHeight*2),nCol,cString,oFont11c)

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+2100+(oFont8:nHeight*2),100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow3+2130+(oFont10:nHeight*2),100 ,AllTrim(aDadosEmp[1])+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
		oPrint:Say  (nRow3+2160+(oFont10:nHeight*2),100 ,AllTrim(aDadosEmp[2])+" - "+aDadosEmp[3]	,oFont10) //Nome + CNPJ
	Else
		oPrint:Say  (nRow3+2100+(oFont8:nHeight*2),100 ,"Cedente",oFont8)
		oPrint:Say  (nRow3+2140+(oFont10:nHeight*2),100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
	EndIf

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+2100+(oFont8:nHeight*2),1810,"Agência/Código Beneficiário",oFont8)
		cString := Alltrim(SubStr(aDadosBanco[3],1,4)+"-8"+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	Else
		oPrint:Say  (nRow3+2100+(oFont8:nHeight*2),1810,"Agência/Código Cedente",oFont8)
		cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
	EndIf

	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2140+(oFont11c:nHeight*2),nCol,cString ,oFont11c)

	oPrint:Say  (nRow3+2200+(oFont8:nHeight*2),100 ,"Data do Documento"                              ,oFont8)
	oPrint:Say (nRow3+2230+(oFont10:nHeight*2),100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

	oPrint:Say  (nRow3+2200+(oFont8:nHeight*2),505 ,"Nro.Documento"                                  ,oFont8)
	//oPrint:Say  (nRow3+2230+(oFont10:nHeight*2),505 ,aDadosTit[7]+aDadosTit[1]	,oFont10) //Prefixo +Numero+Parcela
	oPrint:Say  (nRow3+2230+(oFont10:nHeight*2),505 ,  aDadosTit[1]+" "+ AllTrim(_cParcela)	,oFont10) //Prefixo +Numero+Parcela
	oPrint:Say  (nRow3+2200+(oFont8:nHeight*2),1005,"Espécie Doc."                                   ,oFont8)

	oPrint:Say  (nRow3+2230+(oFont10:nHeight*2),1050,"DM"										,oFont10) //Tipo do Titulo

	oPrint:Say  (nRow3+2200+(oFont8:nHeight*2),1305,"Aceite"                                         ,oFont8)
	oPrint:Say  (nRow3+2230+(oFont10:nHeight*2),1400,"A"                                             ,oFont10)

	oPrint:Say  (nRow3+2200+(oFont8:nHeight*2),1485,"Data do Processamento"                          ,oFont8)
	oPrint:Say  (nRow3+2230+(oFont10:nHeight*2),1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

	oPrint:Say  (nRow3+2200+(oFont8:nHeight*2),1810,"Nosso Número"                                   ,oFont8)

	If SEE->EE_CODIGO=="237"
		cString := Alltrim(Substr(aDadosTit[6],1,2)+"/"+Substr(aDadosTit[6],3))
	Else
		cString := Alltrim(Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4))
	EndIf

	nCol 	 := 1810+(374-(len(cString)*20))
	oPrint:Say  (nRow3+2230+(oFont11c:nHeight*2),nCol,cString,oFont11c)

	oPrint:Say  (nRow3+2270+(oFont8:nHeight*2),100 ,"Uso do Banco"                                   ,oFont8)

	oPrint:Say  (nRow3+2270+(oFont8:nHeight*2),505 ,"Carteira"                                       ,oFont8)
	oPrint:Say  (nRow3+2300+(oFont10:nHeight*2),555 ,aDadosBanco[6]                                  	,oFont10)

	oPrint:Say  (nRow3+2270+(oFont8:nHeight*2),755 ,"Espécie"                                        ,oFont8)
	oPrint:Say  (nRow3+2300+(oFont10:nHeight*2),805 ,"R$"                                             ,oFont10)

	oPrint:Say  (nRow3+2270+(oFont8:nHeight*2),1005,"Quantidade"                                     ,oFont8)
	oPrint:Say  (nRow3+2270+(oFont8:nHeight*2),1485,"Valor"                                          ,oFont8)

	oPrint:Say  (nRow3+2270+(oFont8:nHeight*2),1810,"Valor do Documento"                          	,oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2300+(oFont11c:nHeight*2),nCol,cString,oFont11c)

	oPrint:Say  (nRow3+2340+(oFont8:nHeight*2),100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
	oPrint:Say  (nRow3+2390+(oFont10:nHeight*2),100 ,aBolText[1],oFont10)
	oPrint:Say  (nRow3+2440+(oFont10:nHeight*2),100 ,aBolText[2],oFont10)
	oPrint:Say  (nRow3+2490+(oFont10:nHeight*2),100 ,aBolText[3],oFont10)     //Retirado uma linha em branco da parte inferior do boleto (09-05-2013)
	//oPrint:Say  (nRow3+2490,100 ,aBolText[6],oFont10)
	oPrint:Say  (nRow3+2540+(oFont11a:nHeight*2),100 ,aBolText[4],oFont11a)
	oPrint:Say  (nRow3+2590+(oFont11a:nHeight*2),100 ,aBolText[5],oFont11a)

	oPrint:Say  (nRow3+2340+(oFont8:nHeight*2),1810,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (nRow3+2410+(oFont8:nHeight*2),1810,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (nRow3+2480+(oFont8:nHeight*2),1810,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (nRow3+2550+(oFont8:nHeight*2),1810,"(+)Outros Acréscimos"                           ,oFont8)
	oPrint:Say  (nRow3+2620+(oFont8:nHeight*2),1810,"(=)Valor Cobrado"                               ,oFont8)

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+2690+(oFont8:nHeight*2),100 ,"Pagador"                                         ,oFont8)
	Else
		oPrint:Say  (nRow3+2690+(oFont8:nHeight*2),100 ,"Sacado"                                         ,oFont8)
	EndIf
	oPrint:Say  (nRow3+2700+(oFont10:nHeight*2),400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)

	if aDatSacado[8] = "J"
		oPrint:Say  (nRow3+2700+(oFont10:nHeight*2),1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:Say  (nRow3+2700+(oFont10:nHeight*2),1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
	EndIf

	If SEE->EE_CODIGO=="237"
		oPrint:Say  (nRow3+2740+(oFont10:nHeight*2),400 ,aDatSacado[3]+" - "+aDatSacado[6]+" - "+aDatSacado[4]+" - "+aDatSacado[5]                                    ,oFont10)
	Else
		oPrint:Say  (nRow3+2740+(oFont10:nHeight*2),400 ,aDatSacado[3]                                    ,oFont10)
		oPrint:Say  (nRow3+2780+(oFont10:nHeight*2),400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
	EndIf

	oPrint:Say  (nRow3+2780+(oFont10:nHeight*2),1750,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4)  ,oFont10)

	//If SEE->EE_CODIGO=="237"
	//	oPrint:Say  (nRow3+2900+(oFont8:nHeight*2),100 ,"Sacador/Avalista"                               ,oFont8)
	//Else
	oPrint:Say  (nRow3+2815+(oFont8:nHeight*2),100 ,"Sacador/Avalista"                               ,oFont8)
	//EndIf

	//--- Marciane 11.10.05 - Imprimir os dados da agencia como sacador/Avalista
	If !Empty(aDadosTit[9])
		oPrint:Say  (nRow3+2815+(oFont10:nHeight*2),400 ,aDadosTit[9],oFont10)
		if len(alltrim(aDadosTit[10])) < 14

			oPrint:Say  (nRow3+2815+(oFont10:nHeight*2),1750,"CPF: "+TRANSFORM(aDadosTit[10],"@R 999.999.999-99"),oFont10) 	// CPF
		Else
			oPrint:Say  (nRow3+2815+(oFont10:nHeight*2),1750,"CNPJ: "+TRANSFORM(aDadosTit[10],"@R 99.999.999/9999-99"),oFont10) // CGC
		EndIf
	EndIf
	//--- fim Marciane 11.10.05

	//If SEE->EE_CODIGO=="237"
	//	oPrint:Say  (nRow3+2935+(oFont8:nHeight*2),1500,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont8)
	//Else
	oPrint:Say  (nRow3+2855+(oFont8:nHeight*2),1500,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont8)
	//EndIf

	oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
	oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
	oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
	oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
	oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
	oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )

	//If SEE->EE_CODIGO=="237"
	//	oPrint:Line (nRow3+2930,100,nRow3+2930,2300  )
	//Else
	oPrint:Line (nRow3+2850,100,nRow3+2850,2300  )
	//EndIf

	//MSBAR("INT25",13.0,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.013,0.9,Nil,Nil,"A",.F.)
	//oPrint:FWMsBar("INT25",68,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,0.9,Nil,Nil,"A",.F.)

	//--- Diogo Moura - 29/01/2018 ---//
	If SEE->EE_CODIGO=="237"
		//oPrint:FWMsBar("INT25",68,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.0250,1.2,Nil,Nil,"A",.F.)
		//oPrint:FWMsBar("INT25",40,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.0250,1.2,Nil,Nil,"A",.F.)
		oPrint:FWMsBar("INT25",67.5,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.017,1.2,Nil,Nil,"A",.F.)
		oPrint:FWMsBar("INT25",39.5,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.017,1.2,Nil,Nil,"A",.F.)
		//Fim --- Diogo Moura - 29/01/2018 ---//
	ElseIf SEE->EE_CODIGO=="001"
		oPrint:FWMsBar("INT25",68,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.017,1.2,Nil,Nil,"A",.F.)
		oPrint:FWMsBar("INT25",40,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.017,1.2,Nil,Nil,"A",.F.)
	Else
		oPrint:FWMsBar("INT25",68,3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,0.9,Nil,Nil,"A",.F.)
	EndIf

	oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
	LOCAL L,D,P := 0
	LOCAL B     := .F.
	L := Len(cData)
	B := .T.
	D := 0
	While L > 0
		P := Val(SubStr(cData, L, 1))
		If (B)
			P := P * 2
			If P > 9
				P := P - 9
			End
		End
		D := D + P
		L := L - 1
		B := !B
	End
	D := 10 - (Mod(D,10))
	If D = 10
		D := 0
	End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
	LOCAL L, D, P := 0
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	D := 11 - (mod(D,11))
	If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
		D := 1
	End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)

	LOCAL cValorFinal := StrZero((nvalor*100),10)  //strzero(int(nValor*100),10)
	LOCAL cNroDoc := strzero(val(cNroDoc),8)
	LOCAL nDvnn			:= 0
	LOCAL nDvcb			:= 0
	LOCAL nDv			:= 0
	LOCAL cNN			:= ''
	LOCAL cRN			:= ''
	LOCAL cCB			:= ''
	LOCAL cS				:= ''
	LOCAL cFator      := strzero(dVencto - ctod("07/10/97"),4)
	//--- Marciane 11.10.05 - O parametro define o codigo da carteira
	//LOCAL cCart			:= "109"
	//--- fim Marciane 11.10.05
	//-----------------------------
	// Definicao do NOSSO NUMERO
	// ----------------------------
	cS    :=  cAgencia + cConta + cDacCC + cCart + cNroDoc
	nDvnn := modulo10(cS) // digito verifacador Agencia + Conta + Carteira + Nosso Num
	cNN   := cCart + cNroDoc + '-' + AllTrim(Str(nDvnn))

	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	cS:= cBanco + cFator +  cValorFinal + Subs(cNN,1,11) + Subs(cNN,13,1) + cAgencia + cConta + cDacCC + '000'
	nDvcb := modulo11(cS)
	cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,25) + AllTrim(Str(nDvnn))+ SubStr(cS,31)

	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

	// 	CAMPO 1:
	//	AAA	= Codigo do banco na Camara de Compensacao
	//	  B = Codigo da moeda, sempre 9
	//	CCC = Codigo da Carteira de Cobranca
	//	 DD = Dois primeiros digitos no nosso numero
	//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

	cS    := cBanco + cCart + SubStr(cNroDoc,1,2)
	nDv   := modulo10(cS)
	cRN   := SubStr(cS, 1, 5) + '.' + SubStr(cS, 6, 4) + AllTrim(Str(nDv)) + '  '

	// 	CAMPO 2:
	//	DDDDDD = Restante do Nosso Numero
	//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
	//	   FFF = Tres primeiros numeros que identificam a agencia
	//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

	cS :=Subs(cNN,6,6) + Alltrim(Str(nDvnn))+ Subs(cAgencia,1,3)
	nDv:= modulo10(cS)
	cRN := Subs(cBanco,1,3) + "9" + Subs(cCart,1,1)+'.'+ Subs(cCart,2,3) + Subs(cNN,4,2) + SubStr(cRN,11,1)+ ' '+  Subs(cNN,6,5) +'.'+ Subs(cNN,11,1) + Alltrim(Str(nDvnn))+ Subs(cAgencia,1,3) +Alltrim(Str(nDv)) + ' '

	// 	CAMPO 3:
	//	     F = Restante do numero que identifica a agencia
	//	GGGGGG = Numero da Conta + DAC da mesma
	//	   HHH = Zeros (Nao utilizado)
	//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	cS    := Subs(cAgencia,4,1) + Subs(cConta,1,4) +  Subs(cConta,5,1)+Alltrim(cDacCC)+'000'
	nDv   := modulo10(cS)
	cRN   := cRN + Subs(cAgencia,4,1) + Subs(cConta,1,4) +'.'+ Subs(cConta,5,1)+Alltrim(cDacCC)+'000'+ Alltrim(Str(nDv))

	//	CAMPO 4:
	//	     K = DAC do Codigo de Barras
	cRN   := cRN + ' ' + AllTrim(Str(nDvcb)) + '  '

	// 	CAMPO 5:
	//	      UUUU = Fator de Vencimento
	//	VVVVVVVVVV = Valor do Titulo
	cRN   := cRN + cFator + StrZero((nvalor*100),10)  //StrZero(Int(nValor * 100),14-Len(cFator))

Return({cCB,cRN,cNN})

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Microsiga            	³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                    	  		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg, aPergs)

	Local _sAlias	:= Alias()
	Local aCposSX1	:= {}
	Local nX 		:= 0
	Local lAltera	:= .F.
	Local nCondicao
	Local cKey		:= ""
	Local nJ			:= 0

	aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
	"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
	"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
	"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
	"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
	"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
	"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
	"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

	dbSelectArea("SX1")
	dbSetOrder(1)
	For nX:=1 to Len(aPergs)
		lAltera := .F.
		If MsSeek(cPerg+Right(aPergs[nX][11], 2))
			If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
				aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
				lAltera := .T.
			Endif
		Endif

		If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]
			lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
		Endif

		If ! Found() .Or. lAltera
			/* Removido - 18/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
			RecLock("SX1",If(lAltera, .F., .T.))
			Replace X1_GRUPO with cPerg
			Replace X1_ORDEM with Right(aPergs[nX][11], 2)
			For nj:=1 to Len(aCposSX1)
				If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
					Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
				Endif
			Next nj
			MsUnlock()*/
			cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

			If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
				aHelpSpa := aPergs[nx][Len(aPergs[nx])]
			Else
				aHelpSpa := {}
			Endif

			If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
				aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
			Else
				aHelpEng := {}
			Endif

			If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
				aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
			Else
				aHelpPor := {}
			Endif

			PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		Endif
	Next

Return()

Static Function Ret_cBarr2(cBanco,cAgencia,cConta,cDacCC,cCart,cNroDoc,nValor,dVencto)

	LOCAL cValorFinal  := strzero((nValor*100),10) // alterado por Whilton em 08/06/07 retirado função "int"
	LOCAL dvnn         := 0
	LOCAL dvcb         := 0
	LOCAL dv           := 0
	LOCAL NN           := ""
	LOCAL RN           := ""
	LOCAL CB           := ""
	LOCAL snn          := ""
	LOCAL cFator       := strzero(dVencto - ctod("07/10/97"),4)
	//Banco + Moeda
	cBanco += alltrim("9")

	//-----------------------------
	// Definicao do NOSSO NUMERO
	//----------------------------
	snn  := cCart + cNroDoc
	dvnn := Mod11_Bas7(snn)

	//dvnn := modulo11(snn)  //Digito verificador no Nosso Numero   cCarteira + cNroDoc
	NN   := snn + AllTrim(dvnn)

	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	//Banco + Moeda ( 9 = Real ) + DAC Cod Barra + Fator Vencimento + Valor + Campo Livre
	//  3       1                      1              4                10		25
	//----------------------------------
	//	 Definicao do Campo Livre
	//----------------------------------"
	//Agencia s/ DAC + Carteira + Nosso Num sem DAC + Conta s/ DAC + "0"

	cLivre := cAgencia + cCart + cNroDoc + cConta + '0'
	scb    := cBanco + cFator + cValorFinal + cLivre
	dvcb   := mod11CB(scb)	//digito verificador do codigo de barras
	CB     := SubStr(scb,1,4) + AllTrim(Str(dvcb)) + SubStr(scb,5)

	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	//	AAABC.CCCCX		DDDDD.DDDDDY	DDDDD.DDDDDZ	K			UUUUVVVVVVVVVV

	// 	CAMPO 1:
	//	AAA	= Codigo do banco na Camara de Compensacao
	//	  B = Codigo da moeda, sempre 9
	//CCCCC = 5 primeiros digitos do campo livre
	//	  X = DAC que amarra o campo, calculado pelo Modulo 10 mulltiplo superior

	srn := cBanco + Substr(cLivre,1,5)
	dv  := Modulo10LD(srn)
	RN  := SubStr(srn, 1, 5) + "." + SubStr(srn,6,4) + AllTrim(Str(dv)) + " "

	// 	CAMPO 2:
	//DDDDD.DDDDD = 6 ao 15 do campo livre
	//	        Y = DAC que amarra o campo, calculado pelo Modulo 10 mulltiplo superior

	srn := SubStr(cLivre,6,10)	// posicao 6 a 15 do campo livre
	dv  := modulo10LD(srn)
	RN  += SubStr(srn,1,5) + "." + SubStr(srn,6,5) + AllTrim(Str(dv)) + " "

	// 	CAMPO 3:
	//DDDDDDDDDD = 16 ao 25 do campo livre
	//	       Z = DAC que amarra o campo, calculado pelo Modulo 10 mulltiplo superior

	srn := SubStr(cLivre,16)
	dv  := modulo10LD(srn)
	RN  += SubStr(srn,1,5) + "." + SubStr(srn,6,5) + AllTrim(Str(dv)) + " "

	// CAMPO 4:
	// K = Digito de controle do código de Barra
	RN  += AllTrim(Str(dvcb)) + " "

	// CAMPO 5:
	//       UUUU = Fator de Vencimento
	// VVVVVVVVVV = Valor do Documento
	RN  += cFator + cValorFinal

Return({CB,RN,NN})

Static Function Ret_cBarr3(cBanco,cAgencia,cConta,cDacCC,cCart,cNroDoc,nValor,dVencto)

	LOCAL cValorFinal  := strzero((nValor*100),10) // alterado por Whilton em 08/06/07 retirado função "int"
	LOCAL dvnn         := 0
	LOCAL dvcb         := 0
	LOCAL dv           := 0
	LOCAL NN           := ""
	LOCAL RN           := ""
	LOCAL CB           := ""
	LOCAL snn          := ""
	LOCAL cFator       := strzero(dVencto - ctod("07/10/97"),4)
	//Banco + Moeda
	cBanco += alltrim("9")

	//-----------------------------
	// Definicao do NOSSO NUMERO
	//----------------------------
	snn  := cCart + cNroDoc
	dvnn := Mod11_Bas7(snn)

	//dvnn := modulo11(snn)  //Digito verificador no Nosso Numero   cCarteira + cNroDoc
	NN   := snn + AllTrim(dvnn)

	//----------------------------------
	//	 Definicao do CODIGO DE BARRAS
	//----------------------------------
	//Banco + Moeda ( 9 = Real ) + DAC Cod Barra + Fator Vencimento + Valor + Campo Livre
	//  3       1                      1              4                10		25
	//----------------------------------
	//	 Definicao do Campo Livre
	//----------------------------------"
	//Agencia s/ DAC + Carteira + Nosso Num sem DAC + Conta s/ DAC + "0"

	cLivre := cCart + cNroDoc + "17" //+ cAgencia + cConta +
	scb    := cBanco + cFator + cValorFinal + Replicate("0",6) + cLivre
	dvcb   := mod11CB(scb)	//digito verificador do codigo de barras
	CB     := SubStr(scb,1,4) + AllTrim(Str(dvcb)) + SubStr(scb,5)

	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	//	AAABC.CCCCX		DDDDD.DDDDDY	DDDDD.DDDDDZ	K			UUUUVVVVVVVVVV

	// 	CAMPO 1:
	//	AAA	= Codigo do banco na Camara de Compensacao
	//	  B = Codigo da moeda, sempre 9
	//CCCCC = 5 primeiros digitos do campo livre
	//	  X = DAC que amarra o campo, calculado pelo Modulo 10 mulltiplo superior

	RN := ""
	srn := Substr(CB,1,4) + Substr(CB,20,5)
	dv := cValToChar(modulo10(srn))
	RN += SubStr(srn, 1, 5) + "." + SubStr(srn, 6) + dv + " "

	srn :=  Substr(CB,25,10)
	dv := cValToChar(modulo10(srn))
	RN += SubStr(srn, 1, 5) + "." + SubStr(srn, 6) + dv+ " "

	srn := Substr(CB,35,10)
	dv := cValToChar(modulo10(srn))
	RN += SubStr(srn, 1, 5) + "." + SubStr(srn, 6) + dv+ " "

	dv := cValToChar(dvcb)
	RN += dv + " " + cFator + cValorFinal

	/*
	srn := cBanco + Substr(cLivre,1,5)
	dv  := Modulo10LD(srn)
	RN  := SubStr(srn, 1, 5) + "." + SubStr(srn,6,4) + AllTrim(Str(dv)) + " "

	// 	CAMPO 2:
	//DDDDD.DDDDD = 6 ao 15 do campo livre
	//	        Y = DAC que amarra o campo, calculado pelo Modulo 10 mulltiplo superior

	srn := SubStr(cLivre,6,10)	// posicao 6 a 15 do campo livre
	dv  := modulo10LD(srn)
	RN  += SubStr(srn,1,5) + "." + SubStr(srn,6,5) + AllTrim(Str(dv)) + " "

	// 	CAMPO 3:
	//DDDDDDDDDD = 16 ao 25 do campo livre
	//	       Z = DAC que amarra o campo, calculado pelo Modulo 10 mulltiplo superior

	srn := SubStr(cLivre,16)
	dv  := modulo10LD(srn)
	RN  += SubStr(srn,1,5) + "." + SubStr(srn,6,5) + AllTrim(Str(dv)) + " "

	// CAMPO 4:
	// K = Digito de controle do código de Barra
	RN  += AllTrim(Str(dvcb)) + " "

	// CAMPO 5:
	//       UUUU = Fator de Vencimento
	// VVVVVVVVVV = Valor do Documento
	RN  += cFator + cValorFinal
	*/
Return({CB,RN,NN})

//Funcao criada em 20/03/2006 por Paulo Moreto
//Digito verificador estava sendo recusado pelo bradesco
//Esta funcao substituiu a funcao Modulo11.
Static Function Mod11_Bas7(cData)

	Local _cDigito
	Local _nPos      := 1
	Local _nTam      := Len(cData)
	Local _nTotal    := 0
	Local _nFator    := 8
	Local _nValAtu   := 0
	Local _nResto    := 0
	Local _nValResto := 0

	While _nTam > 0
		If _nFator >= 7
			_nFator := 2
		Else
			_nFator ++
		Endif
		_nValAtu := Val(Substr(cData,_nTam,1))
		_nTotal += _nValAtu * _nFator
		_nTam--
	EndDo

	_nResto := Mod(_nTotal,11)

	If _nResto <> 0
		_nValResto := (11-_nResto)
	Else
		_nValResto := _nResto
	Endif

	If _nValResto == 0
		_cDigito := Str(0)
	ElseIf _nValResto == 10
		_cDigito := "P"
	Else
		_cDigito := Str(_nValResto)
	Endif

	Return(_cDigito)

	***************************
Static Function Mod11CB(cData) // Modulo 11 com base 9

	LOCAL CBL, CBD, CBP := 0
	CBL := Len(cdata)
	CBD := 0
	CBP := 1

	While CBL > 0
		CBP := CBP + 1
		CBD := CBD + (Val(SubStr(cData, CBL, 1)) * CBP)
		If CBP = 9
			CBP := 1
		End
		CBL := CBL - 1
	End
	_nCBResto := mod(CBD,11)  //Resto da Divisao
	CBD := 11 - _nCBResto
	If (CBD == 0 .Or. CBD == 1 .Or. CBD > 9)
		CBD := 1
	End

	Return(CBD)

	*******************************
Static Function Modulo10LD(cData)

	LOCAL L,D,P := 0
	LOCAL B     := .F.
	L := Len(cData)
	B := .T.
	D := 0

	While L > 0
		P := Val(SubStr(cData, L, 1))
		If (B)
			P := P * 2
			If P > 9
				P := P - 9
			End
		End
		D := D + P
		L := L - 1
		B := !B
	End
	MS := (INT(D/10) + 1) * 10 // Multiplo Superior
	D  := MS - D
	If D = 10
		D := 0
	End

Return(D)

User Function EnvBolItau(cStartPath,_cNomePdf,cEmail)
	local _aAttach  := {}
	Local _cCaminho := cStartPath
	Local titulo	:= 'Boleto Steck'
	Local cMensagem	:= 'Segue Boleto Steck '
	RpcSetType( 3 )
	RpcSetEnv( '11', '01',,,"FAT")
	aadd( _aAttach  ,_cNomePdf )

	//Processa({|lEnd| xBrEnvMail(oPrint,"Pedido de Venda: "+ SC5->C5_NUM,{"Pedido de Venda: "+ SC5->C5_NUM},cEmailFor,"",{},10)},titulo)

	U_STMAILTES(cEmail,' ',titulo,cMensagem,_aAttach,_cCaminho)

Return()

User Function BOLPORTAL(_cSerie,_cNf,_cmail)

	Local _cQuery2	:= ""
	Local _cAlias2	:= GetNextAlias()

	default _cSerie	:= '001'
	default _cNf	:= '000290981'
	default _cmail	:= 'Eduardo.Santos@steck.com.br'

	_cQuery2 := " SELECT E1_NUM, E1_PARCELA, E1_PORTADO
	_cQuery2 += " FROM "+RetSqlName("SE1")+" E1
	_cQuery2 += " WHERE E1.D_E_L_E_T_=' ' AND E1_FILIAL='"+xFilial("SE1")+"'
	_cQuery2 += " AND E1_PREFIXO='"+_cSerie+"' AND E1_NUM='"+SubStr(_cNf,1,9)+"'

	If Len(_cNf)>10
		_cQuery2 += " AND E1_PARCELA='"+SubStr(_cNf,11,3)+"'
	EndIf
	
	If !Empty(Select(_cAlias2))
		DbSelectArea(_cAlias2)
		(_cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbGoTop())

	If (_cAlias2)->(!Eof())
		If AllTrim((_cAlias2)->E1_PORTADO) $ '001#341#237' //Itau

			_aParcs := {}
		
			AADD(_aParcs,(_cAlias2)->E1_PARCELA)

			U_MONTAR(,,,,.T.,SubStr(_cNf,1,9),SubStr(_cNf,1,9),_cSerie,SubStr(_cNf,1,9),,,.F.,,_aParcs)
			
			MsUnLockAll()
			If !(Empty(Alltrim(_cmail)))
				Sleep(5000)
				StartJob("U_EnvBolItau",GetEnvServer(), .F.,"\arquivos\BOLETOS_ITAU\" , SubStr(_cNf,1,9)+"_BOLETO.pdf",_cmail)
			EndIf
			
		ElseIf AllTrim((_cAlias2)->E1_PORTADO) $ '745' //Citi
		
			_aParcs := {}
		
			AADD(_aParcs,(_cAlias2)->E1_PARCELA)
					
			U_MTCITIR(,,,,.T.,SubStr(_cNf,1,9),SubStr(_cNf,1,9),_cSerie,SubStr(_cNf,1,9),,,.F.,,_aParcs)
			
			MsUnLockAll()
			If !(Empty(Alltrim(_cmail)))
				Sleep(5000)
				StartJob("U_EnvBolCiti",GetEnvServer(), .F.,"\arquivos\BOLETOS_CITI\" , SubStr(_cNf,1,9)+ "_BOLETO.pdf",_cmail)
			EndIf
		
		EndIf
	EndIf

Return()

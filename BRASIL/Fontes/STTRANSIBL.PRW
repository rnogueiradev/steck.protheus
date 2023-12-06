#include "Protheus.ch"
#include "RwMake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#DEFINE CR    chr(13)+chr(10)


/*/{Protheus.doc} STTRANSIBL
Gera P.V. de Transferencia entre Steck 01 para Steck 02 de acordo com os parametros de endereços
@type User function
@author GIOVANI.ZAGO
@since 09/08/2013
@version 1.0
@return ${return}, ${return_description}
@example
Alteracao para steck 04 - thiago.fonseca 23062016
/*/

User Function STTRANSIBL()

	Private cPerg       := 'TRANSIBL'
	Private cTime       := Time()
	Private cHora       := SUBSTR(cTime, 1, 2)
	Private cMinutos    := SUBSTR(cTime, 4, 2)
	Private cSegundos   := SUBSTR(cTime, 7, 2)
	Private cAliasLif   := cPerg+cHora+ cMinutos+cSegundos
	Private cAliasPed   := cPerg+cHora+ cMinutos+cSegundos
	Private cAliasSal   := cPerg+cHora+ cMinutos+cSegundos
	Private aSize    	:= MsAdvSize(.F.)
	Private lMark   	:=  .F.
	Private aVetor 		:= {}
	Private aSbfLoc		:= {}
	Private lSaida  	:= .F.
	Private aCpoEnch	:= {}
	Private nOpcA		:= 0
	Private oOk	   		:= LoadBitmap( GetResources(), "LBOK" )
	Private oNo	   		:= LoadBitmap( GetResources(), "LBNO" )
	Private oChk
	Private lRetorno    := .F.
	Private lChk	 	:= .F.
	Private oLbx
	Private oLbxz
	Private lInverte 	:= .F.
	Private nContLin 	:= 0
	Private lLote    	:= .F.
	Private oDlg
	Private oDlgx
	Private oList
	Private _nQtd   	:= 0
	Private  _nMeta 	:= 0
	Private oVlrSelec
	Private nVlrSelec 	:= 0
	Private oMarcAll
	Private lMarcAll    	:= .T.
	Private oMarked	 := LoadBitmap(GetResources(),'LBOK')
	Private oNoMarked:= LoadBitmap(GetResources(),'LBNO')
	Private oMeta
	Private oPesc
	Private aTam     := {}
	Private cPesc    := ''
	Private _cSerIbl := IIF(CFILANT='01','001','001')
	Private bFiltraBrw
	Private AFILBRW    := {}
	Private _cEndeStxx  := 'Endereços(SBF): '
	Private nItBloq	:= 0
	Private cDeLoc	:= ""
	Private cAteLoc	:= ""
	aTam   := TamSX3("BF_LOCALIZ")
	cPesc  := space(aTam[1])
	cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
	aFilBrw		:=	{'SF2',cCondicao}

	fCriaSx1(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	cDeLoc		:= MV_PAR01
	cAteLoc	:= MV_PAR02
	nItBloq	:= MV_PAR03
	cLojDest := MV_PAR04

//If cfilant = '02'

	Processa({|| 	STQUERY()},'Selecionando Endereços')

	Processa({|| 	CompMemory()},'Compondo Endereços')

	If len(aVetor) > 0
		MonTaSlec() // monta a tela
	Else
		MsgInfo("Não Existe Saldos nos Endereços !!!!!")
	EndIf
//Else
//	msginfo("Disponivel Apenas para  Filial 02")

//EndIf
Return()

/*====================================================================================\
|Programa  | STQUERY          | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |   Executa select mediante os parametros                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STQUERY                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function STQUERY()
*-----------------------------*
Local cQuery     := ''

DbSelectArea("SBF")
SBF->(DbSetOrder(1))


cQuery := " SELECT
cQuery += " BF_LOCALIZ,
cQuery += " BF_LOCAL,
cQuery += ' SUM(BF_QUANT) "BF_QUANT"
cQuery += " FROM "+RetSqlName('SBF')+" SBF "
cQuery += " WHERE  SBF.D_E_L_E_T_   = ' '
cQuery += " AND SBF.BF_LOCAL  BETWEEN '"+cDeLoc+"' AND '"+cAteLoc+"' "
cQuery += " AND SBF.BF_QUANT > 0
cQuery += " AND SBF.BF_FILIAL ='"+xFilial("SBF")+"'"
cQuery += " GROUP BY BF_LOCAL,BF_LOCALIZ
cQuery += " ORDER BY BF_LOCAL,BF_LOCALIZ

cQuery := ChangeQuery(cQuery)

DbCommitAll()
	If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
	EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif,.T.,.T.)


Return()


/*====================================================================================\
|Programa  | CompMemory       | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |    crio o avetor                                                         |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | CompMemory                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function CompMemory()
*-----------------------------*

dbSelectArea(cAliasLif)
(cAliasLif)->(dbGoTop())
ProcRegua(RecCount()) // Numero de registros a processar

	If (cAliasLif)->(Eof())
	aadd(aVetor ,{ lMark ,; //01
	""		 ,;	//02   ENDEREÇO
	""		 ,;	//03   ARMAZEM
	0		 ,;	//04   SALDO
	})
	EndIf

	While !(cAliasLif)->(Eof())
	_nQtd++
	IncProc()
	aadd(aVetor ,{ lMark ,; //01
	(cAliasLif)->BF_LOCALIZ		 ,;	//02   ENDEREÇO
	(cAliasLif)->BF_LOCAL		 ,;	//03   ARMAZEM
	(cAliasLif)->BF_QUANT		 ,;	//04   SALDO
	})

	(cAliasLif)->(dbSkip())
	End


Return()

/*====================================================================================\
|Programa  | MonTaSlec        | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MonTaSlec                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function MonTaSlec()
*-----------------------------*

Local aButtons := {{"LBTIK",{|| PedStx()} ,"Gerar Pedido"},{"LBTIK",{|| EndComp(oLbx:nat)} ,"Cons.Endereço"} }

	Do While !lSaida
	nOpcao := 0

	Define msDialog odlg title "Transferencia" From 0,0 To aSize[6]-15,aSize[5]-15  PIXEL OF oMainWnd //from 178,181 to 590,1100 pixel

	cLinOk    :="AllwaysTrue()"
	cTudoOk   :="AllwaysTrue()"//'STxGRV()'
	aCpoEnchoice:={'NOUSER'}
	aAltEnchoice := {}

	Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
	bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
	Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0

	@ 035,360 say "Quantidade( Endereços ):"   Of odlg Pixel
	@ 035,440 msget  _nQtd picture "@E 999,999" when .f. size 55,013  Of odlg Pixel

	@ 035,010 say "Selecionados:"   Of odlg Pixel
	@ 035,080 msget  oVlrSelec Var _nMeta picture "@E 999,999" when .f. size 55,013 	 Of odlg Pixel

	@ 035,200 say "Pesquisar:"   Of odlg Pixel
	@ 035,240 msget  oPesc Var cPesc   when .t. size 35,013   valid (fpesc(cPesc))	 Of odlg Pixel

	//Cria a listbox
	@ 060,000 listbox oLbx fields header " ", "Endereço",'Armazém',"Saldo"  size  aSize[3]-05,255 of oDlg pixel on dbLclick(edlista(oLbx:nat,oVlrSelec))

	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
	aVetor[oLbx:nAt,2],;
	aVetor[oLbx:nAt,3],;
	aVetor[oLbx:nAt,4]}}

	//	@ aSize[4]-28 ,005 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg on CLICK(aEval(aVetor,{|x| x[1]:=lChk}),fMarca(),oLbx:Refresh())


	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||nOpca:=1,lSaida:=.t.,oDlg:End()}	,{|| nOpca := 0,lSaida:=.t.,oDlg:End()},,aButtons)

	End
	If nOpca =1
	//	If MSGYESNO("Deseja Gerar o Pedido de Transferencia Com os Endereços Selecionados ?")
	//	Processa({|| 	GeraPed()},'Gerando Pedido .......')
	//	EndIf
	EndIf
Return()


/*====================================================================================\
|Programa  | fMarca           | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | fMarca                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function PedStx()
*-----------------------------*

	If MSGYESNO("Deseja Gerar o Pedido de Transferencia Com os Endereços Selecionados?")
	Processa({|| 	GeraPed()},'Gerando Pedido .......')
	EndIf

STQUERY()
aVetor:= {}
_nQtd := 0
_nMeta:= 0
Processa({|| 	CompMemory()},'Atualizando Endereços.....')



oVlrSelec:Refresh()
oLbx:Refresh()
oDlg:Refresh()
oDlg:End()

Return()


/*====================================================================================\
|Programa  | EndComp          | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | EndComp                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function EndComp(_nSbfCod)
*-----------------------------*
Local _aArea	:= GetArea()
Local cQuery     := ' '
Local  _nQut    := 0
Local  _nVal    := 0
Local  _nCust    := 0
cPerg       := 'SB2QTD'
cTime       := Time()
cHora       := SUBSTR(cTime, 1, 2)
cMinutos    := SUBSTR(cTime, 4, 2)
cSegundos   := SUBSTR(cTime, 7, 2)
cAliasSal   := cPerg+cHora+ cMinutos+cSegundos


	cQuery := " SELECT
	cQuery += " BF_LOCALIZ,
	cQuery += " BF_LOCAL,
	cQuery += ' BF_QUANT,
	cQuery += ' BF_PRODUTO
	cQuery += " FROM "+RetSqlName('SBF')+" SBF "
	cQuery += " WHERE  SBF.D_E_L_E_T_   = ' '
	cQuery += " AND SBF.BF_LOCAL  BETWEEN '"+cDeLoc+"' AND '"+cAteLoc+"' "
	cQuery += " AND SBF.BF_QUANT > 0
	cQuery += " AND SBF.BF_FILIAL  = '"+xFilial("SBF")+"'"
	cQuery += " AND SBF.BF_LOCALIZ = '"+aVetor[_nSbfCod,2]+"'"
	cQuery += " ORDER BY BF_LOCAL,BF_LOCALIZ

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasSal) > 0
		(cAliasSal)->(dbCloseArea())
	EndIf
	aSbfLoc:={}
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSal)
	dbSelectArea(cAliasSal)
	If  Select(cAliasSal) > 0
		(cAliasSal)->(dbgotop())
		While (cAliasSal)->(!Eof())


			aadd(aSbfLoc ,{ (cAliasSal)->BF_PRODUTO ,;	//01   PRODUTO
			(cAliasSal)->BF_QUANT	 ,;	//02   SALDO
			(cAliasSal)->BF_LOCAL		 ,;	//03   ARMAZEM
			(cAliasSal)->BF_LOCALIZ		 ,;	//04   ENDEREÇO
		   ' '	})


			(cAliasSal)->(DbSkip())
		End
	EndIf



	If Select(cAliasSal) > 0
		(cAliasSal)->(dbCloseArea())
	EndIf

	If len(	aSbfLoc) >0
		Define msDialog odlgx title "Endereço" From 0,0 To ((aSize[6]-15)/2),((aSize[5]-15)/2)  PIXEL OF oMainWnd //from 178,181 to 590,1100 pixel

		cLinOk    :="AllwaysTrue()"
		cTudoOk   :="AllwaysTrue()"//'STxGRV()'
		aCpoEnchoice:={'NOUSER'}
		aAltEnchoice := {}

		Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
		bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
		Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0

		//Cria a listbox
		@ 000,000 listbox oLbxz fields header "Produto ","Saldo",'Armazém', "Endereço",'.'  size  aSize[3]-05,255 of oDlgx pixel

		oLbxz:SetArray( aSbfLoc )
		oLbxz:bLine := {|| {	aSbfLoc[oLbxz:nAt,1],;
		aSbfLoc[oLbxz:nAt,2],;
		aSbfLoc[oLbxz:nAt,3],;
		aSbfLoc[oLbxz:nAt,4],;
		aSbfLoc[oLbxz:nAt,5],;
		' '	}}


		ACTIVATE MSDIALOG oDlgx CENTERED ON INIT EnchoiceBar(oDlgx, {|| oDlgx:End()}	,{|| oDlgx:End()},,)

	EndIf


oLbx:Refresh()
oDlg:Refresh()
RestArea(_aArea)

Return()
/*====================================================================================\
|Programa  | fMarca           | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | fMarca                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function fMarca()
*-----------------------------*
local b

_nMeta:=0

	for b:= 1 to Len(aVetor)

		If aVetor[oLbx:nAt,1]
		_nMeta++
		EndIf

	next b

oVlrSelec:Refresh()
oLbx:Refresh()
oDlg:Refresh()

Return( .t. )


/*====================================================================================\
|Programa  | fpesc            | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | fpesc                                                                    |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function fpesc(_cXPesc)
*-----------------------------*
local b
Local _lRex := .f.

	If !(Empty(Alltrim(_cXPesc)))
		for b:= 1 to Len(aVetor)

			If UPPER(ALLTRIM(aVetor[b,2]))   =  UPPER(ALLTRIM(_cXPesc) )
			_lRex:= .T.
			EndIf

		next b

	Else
	_lRex:= .T.
	EndIf
	If _lRex .And. !(Empty(Alltrim(_cXPesc)))
	oLbx:nAt:= aScan(aVetor, {|x| Upper(AllTrim(x[2])) == UPPER(Alltrim(_cXPesc))})
	EndIf
oLbx:Refresh()
oDlg:Refresh()
opesc:Refresh()
Return( _lRex )

/*====================================================================================\
|Programa  | EdLista          | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | EdLista                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function EdLista()
*-----------------------------*
Local b

_nMeta:=0
aVetor[oLbx:nAt,1]	:= !aVetor[oLbx:nAt,1]

	for b:= 1 to Len(aVetor)

		If aVetor[b,1]
		_nMeta++
		EndIf

	next b

oVlrSelec:Refresh()
oLbx:Refresh()
oDlg:Refresh()
Return ()
/*====================================================================================\
|Programa  | GeraPed          | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |   msexecauto                                                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | GeraPed                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function GeraPed( )
*-----------------------------*
Local aCabec     := {}
Local aItens     := {}
Local aLogErr    := {}
Local cNumPed    := ""
Local _nxSaldo   := 0
Local _nxEnd     := 0
Local _cmsg      := ' '
Local nTam       := 0
Local _nIt       := 0
Local b			:= 0

Private lMsErroAuto     := .F.
Private lMsHelpAuto     := .T.


cNumPed := GetSxeNum("SC5", "C5_NUM",, 1)
ConfirmSX8()

IncProc("Gerando pedido de venda " + cNumPed)  //"Gerando pedido de venda "

//RollBAckSx8()


aCabec := {   {"C5_NUM"    , cNumPed         					,Nil}, ;
              {"C5_TIPO"   , "N"             					,Nil}, ;
              {"C5_CLIENTE", "033467"     					,Nil}, ;
              {"C5_LOJACLI"	,cLojDest	,Nil}, ;
              {"C5_LOJAENT"	,cLojDest	,Nil}, ;
              {"C5_TIPOCLI"	,"F"								,Nil}, ;
              {"C5_CONDPAG"	,"501"								,Nil}, ;
			  {"C5_ZCONDPG"	,"501"								,Nil}, ;
              {"C5_VEND1"	,"R00099"							,Nil}, ;
              {"C5_TPFRETE"	,"F"								,Nil}, ;
			  {"C5_TRANSP"	,"10000"							,Nil}, ;
			  {"C5_ZCONSUM"	,"2"								,Nil}, ;
              {"C5_XTIPO"	,"2"								,Nil}, ;
              {"C5_XTIPF"	,"1"								,Nil},;
			  {"C5_ZENDENT"	,"Av. Adilia Barbosa Neves, 3925"								,Nil},;
			  {"C5_ZBAIRRE"	,"Bairro do Portao"								,Nil},;
			  {"C5_ZMUNE"	,"ARUJA"								,Nil},;
			  {"C5_ZCEPE"	,"07413000"								,Nil},;
			  {"C5_ZESTE"	,"SP"								,Nil};
			  }


	For b:= 1 To Len(aVetor)

		If aVetor[b,1]
		_nxEnd++
		_cEndeStxx+= "  "+cvaltochar(_nxEnd)+"="+aVetor[b,2]
		xSTQUERY(aVetor[b,2])

		dbSelectArea(cAliasPed)
		//(cAliasPed)->(dbGoTop())
		ProcRegua(RecCount()) // Numero de registros a processar

			While ! (cAliasPed)->(Eof())

			IncProc()
			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+(cAliasPed)->BF_PRODUTO))

			_nxSaldo:= Sb2Saldo()
			_nxSaldo:= Round((_nxSaldo/0.82),2)

				If _nxSaldo <= 0
				_nxSaldo:= 0.02
				Endif
			// Itens
			_nIt++
			Aadd(aItens,{{"C6_ITEM"		,PadR(StrZero(_nIt,2),2)								,Nil},; //01 Numero do Item no Pedido
			{"C6_PRODUTO"	,(cAliasPed)->BF_PRODUTO											,Nil},; //02 Codigo do Produto
			{"C6_OPER"		,"86"																,Nil},; //11 OPERAÇÃO
			{"C6_TES"		,"854"																,Nil},; //08 Tipo de Entrada/Saida do Item			
			{"C6_CF"		,"5949"																,Nil},; //08 Tipo de Entrada/Saida do Item			
			{"C6_QTDVEN"	,(cAliasPed)->BF_QUANT												,Nil},; //04 Quantidade Vendida
			{"C6_PRCVEN"	,Round(_nxSaldo*(cAliasPed)->BF_QUANT/ (cAliasPed)->BF_QUANT,2),Nil},; //05 Preco Venda
			{"C6_PRUNIT"	,round(_nxSaldo*(cAliasPed)->BF_QUANT/(cAliasPed)->BF_QUANT,2),Nil},; //06 Preco Unitario
			{"C6_VALOR"		,round(_nxSaldo*(cAliasPed)->BF_QUANT,2)							,Nil},; //07 Valor Total do Item
			{"C6_LOCAL"		,(cAliasPed)->BF_LOCAL										,Nil},; //09 Almoxarifado
			{"C6_LOCALIZ"	,(cAliasPed)->BF_LOCALIZ											,Nil},;
			{"C6_CLASFIS"			,""																              ,Nil}})

			_nxSaldo:= 0
			(cAliasPed)->(dbSkip())
			End



		EndIf

	Next b


MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aItens, 3)


	If lMsErroAuto
	MostraErro()
	
	Else
	Reclock("SC5",.F.)
	Replace C5_ZOBS With _cEndeStxx
	MsUnlock()

	AjustPrc(SC5->C5_NUM) //Deixar C6_PRCVEN=C6_PRUNIT

		If MSGYESNO("Gera Nota Fiscal ?")
		//Begin Transaction
		STGERNF()
		//End Transaction

		AutoNfeEnv(cEmpAnt,SF2->F2_DOC,"0",AllTrim(GetMv("FS_TPAMBNF",,"2")),SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC)

		_cmsg:= "  Nota: "+SF2->F2_DOC
		msginfo("Pedido: "+SC5->C5_NUM+_cmsg)
		/*
			If MSGYESNO("Transmitir a Nota?")
			StSped(_cSerIbl,SF2->F2_DOC,SF2->F2_DOC,,) //transmitir a nota
				If MSGYESNO("Danfe ?")
				dbSelectArea("SX1")
					If dbSeek (Padr( "NFSIGW" , Len( X1_GRUPO ) , ' ' )+"01")  // Busca a pergunta para mv_par03
					Reclock("SX1",.F.)
					Replace X1_CNT01 With SF2->F2_DOC
					MsUnlock()
					Endif
					If dbSeek (Padr( "NFSIGW" , Len( X1_GRUPO ) , ' ' )+"02")  // Busca a pergunta para mv_par03
					Reclock("SX1",.F.)
					Replace X1_CNT01 With SF2->F2_DOC
					MsUnlock()
					Endif
					If dbSeek (Padr( "NFSIGW" , Len( X1_GRUPO ) , ' ' )+"03")  // Busca a pergunta para mv_par03
					Reclock("SX1",.F.)
					Replace X1_CNT01 With SF2->F2_SERIE
					MsUnlock()
					Endif


				nTam:= 1000000
				ProcRegua(nTam) // Numero de registros a processar
					For i=1 to nTam
					IncProc("Transmitindo a Nota Fiscal")
					Next

				SpedDanfe()  //danfe
				EndIf
			EndIf
		*/
		Else
			msginfo("Pedido: "+SC5->C5_NUM)

		EndIf


	EndIf


	_cEndeStxx:= ' '


Return ()

/*====================================================================================\
|Programa  | xSTQUERY         | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |   Executa select mediante os parametros                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | xSTQUERY                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function xSTQUERY(_cEnder)
*-----------------------------*
Local cQuery     := ''
cPerg       := 'ENDER'
cTime       := Time()
cHora       := SUBSTR(cTime, 1, 2)
cMinutos    := SUBSTR(cTime, 4, 2)
cSegundos   := SUBSTR(cTime, 7, 2)
cAliasPed   := cPerg+cHora+ cMinutos+cSegundos


cQuery := " SELECT
cQuery += " BF_LOCALIZ,
cQuery += " BF_LOCAL,
cQuery += ' BF_QUANT,
cQuery += ' BF_PRODUTO
cQuery += " FROM "+RetSqlName('SBF')+" SBF "
cQuery += " WHERE  SBF.D_E_L_E_T_   = ' '
cQuery += " AND SBF.BF_LOCAL    BETWEEN '"+cDeLoc+"' AND '"+cAteLoc+"' "
cQuery += " AND SBF.BF_QUANT > 0
cQuery += " AND SBF.BF_FILIAL  = '"+xFilial("SBF")+"'"
cQuery += " AND SBF.BF_LOCALIZ = '"+_cEnder+"'"
cQuery += " ORDER BY BF_LOCALIZ,BF_LOCAL

cQuery := ChangeQuery(cQuery)


	If Select(cAliasPed) > 0
	(cAliasPed)->(dbCloseArea())
	EndIf


dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasPed,.T.,.T.)


Return()


/*====================================================================================\
|Programa  | Sb2Saldo            | Autor | GIOVANI.ZAGO          | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  Retorna saldo do sb2(custo)                                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | Sb2Saldo                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------*
Static Function Sb2Saldo()
*---------------------------*
Local _aArea	:= GetArea()
Local cQuery     := ' '
Local  _nQut    := 0
Local  _nVal    := 0
Local  _nCust    := 0
cPerg       := 'SALDO'
cTime       := Time()
cHora       := SUBSTR(cTime, 1, 2)
cMinutos    := SUBSTR(cTime, 4, 2)
cSegundos   := SUBSTR(cTime, 7, 2)
cAliasSal   := cPerg+cHora+ cMinutos+cSegundos




cQuery := " SELECT B2_COD, B2_LOCAL,B2_FILIAL,B2_QATU,B2_VATU1 ,B2_CMFIM1
cQuery += " FROM "+RetSqlName("SB2")+" SB2 "
cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
cQuery += " AND   SB2.B2_COD   = '"+SB1->B1_COD+"'"
cQuery += " AND   SB2.B2_LOCAL = '"+SB1->B1_LOCPAD+"'"
cQuery += " AND   SB2.B2_FILIAL= '"+xFilial("SB2")+"'"
cQuery += " ORDER BY SB2.R_E_C_N_O_



cQuery := ChangeQuery(cQuery)

	If Select(cAliasSal) > 0
	(cAliasSal)->(dbCloseArea())
	EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSal)
dbSelectArea(cAliasSal)
	If  Select(cAliasSal) > 0
	(cAliasSal)->(dbgotop())
		While (cAliasSal)->(!Eof())
		_nCust  := (cAliasSal)->B2_CMFIM1
		(cAliasSal)->(DbSkip())
		End
	EndIf



	If Select(cAliasSal) > 0
	(cAliasSal)->(dbCloseArea())
	EndIf

RestArea(_aArea)
Return(round(_nCust,2))

/*====================================================================================\
|Programa  | STGERNF             | Autor | GIOVANI.ZAGO          | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  Gera nf						                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STGERNF                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------*
Static Function STGERNF()
*---------------------------*
Local cNumPed:= SC5->C5_NUM
Local aPvlNfs  := {}
Local _cNota   := ''

/*
SC6->(DbSetOrder(1))
	If SC6->(DbSeek(xFilial("SC6")+cNumPed))
		While SC6->(!EOF() .and. C6_FILIAL+C6_NUM == xFilial("SC6")+cNumPed)
MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.T.)
SC6->(Dbskip())
		EndDo
	Endif
*/
//MaLiberOk({ cNumPed },.T.)

	SC9->(DbSetOrder(1))
	If SC9->(DbSeek(xFilial("SC9")+cNumPed))
		While SC9->(!EOF() .and. C9_FILIAL+C9_PEDIDO == xFilial("SC9")+cNumPed)
			Reclock("SC9",.F.)
			Replace C9_BLEST With ""
			Replace C9_BLCRED With ""
			MsUnlock()
			DbSelectArea("SC6")
			SC6->(DbSetOrder(1))
			If SC6->(DbSeek(xFilial("SC9")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
				DbSelectArea("SE4")
				SE4->(DbSetOrder(1))
				If SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG))
					DbSelectArea("SB1")
					SB1->(DbSetOrder(1))
					If		SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO))
						DbSelectArea("SB2")
						SB2->(DbSetOrder(1))
						If		SB2->(DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL))
							DbSelectArea("SF4")
							SF4->(DbSetOrder(1))
							If		SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES))
								Aadd(aPvlNfs,{;
									SC9->C9_PEDIDO,;
									SC9->C9_ITEM,;
									SC9->C9_SEQUEN,;
									SC9->C9_QTDLIB,;
									SC9->C9_PRCVEN,;
									SC9->C9_PRODUTO,;
									.F.,;
									SC9->(RecNo()),;
									SC5->(RecNo()),;
									SC6->(RecNo()),;
									SE4->(RecNo()),;
									SB1->(RecNo()),;
									SB2->(RecNo()),;
									SF4->(RecNo())})
							Endif
						Endif
					Endif
				Endif
			Endif
			SC9->(Dbskip())
		EndDo
	Endif

	_cNota:=MaPvlNfs(aPvlNfs, _cSerIbl, .F., .F., .F., .T., .F., 0, 0, .T., .F.)

Return(_cNota)
/*====================================================================================\
|Programa  |  StSped             | Autor | GIOVANI.ZAGO          | Data | 15/08/2013  |
|=====================================================================================|
|Descrição |  Realiza a transmissao automatica pra sefaz                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | StSped                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*-------------------------------------------------------------*
static Function StSped(cSerie,cNotaIni,cNotaFim,lCTe,lRetorno)
*-------------------------------------------------------------*


Local aArea       := GetArea()
Local aPerg       := {}
Local aParam      := { }
Local aTexto      := {}
Local aXML        := {}

Local cRetorno    := ""
Local cIdEnt      := ""
Local cModalidade := ""
Local cAmbiente   := ""
Local cVersao     := ""
Local cVersaoCTe  := ""
Local cVersaoDpec := ""
Local cMonitorSEF := ""
Local cSugestao   := ""
Local cURL        := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cUsaColab	  := GetNewPar("MV_SPEDCOL","N")
Local cUSERNEOG	  := GetNewPar("MV_USERCOL","")
Local cPASSWORD	  := GetNewPar("MV_PASSCOL","")
Local cCONFALL	  := GetNewPar("MV_CONFALL","N")
Local cDocsColab  := GetNewPar("MV_DOCSCOL","0")
Local cParNfeRem  := SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEREM"
Local cConteudo   := ""


Local nRetCol	  := GetNewPar("MV_NRETCOL",10)
Local nAmbCTeC	  := GetNewPar("MV_AMBICOL",2)
Local nAmbNFeC	  := GetNewPar("MV_AMBCTEC",2)
Local nX          := 0

Local lOk         := .T.

Local oWs
Local oWizard

Default lCTe      := .F.
Default lRetorno  := .F.



aArea       := GetArea()
aPerg       := {}
aParam      := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC))}

	If cSerie == Nil
	MV_PAR01 := aParam[01] := PadR(ParamLoad(cParNfeRem,aPerg,1,aParam[01]),Len(SF2->F2_SERIE))
	MV_PAR02 := aParam[02] := PadR(ParamLoad(cParNfeRem,aPerg,2,aParam[02]),Len(SF2->F2_DOC))
	MV_PAR03 := aParam[03] := PadR(ParamLoad(cParNfeRem,aPerg,3,aParam[03]),Len(SF2->F2_DOC))
	Else
	MV_PAR01 := aParam[01] := cSerie
	MV_PAR02 := aParam[02] := cNotaIni
	MV_PAR03 := aParam[03] := cNotaFim
	EndIf

aadd(aPerg,{1,"Serie da Nota Fiscal",aParam[01],"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"
aadd(aPerg,{1,"Nota fiscal inicial",aParam[02],"",".T.","",".T.",30,.T.})	//"Nota fiscal inicial"
aadd(aPerg,{1,"Nota fiscal final",aParam[03],"",".T.","",".T.",30,.T.}) //"Nota fiscal final"

	If IsReady()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Obtem o codigo da entidade                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cIdEnt := GetIdEnt()

		If !Empty(cIdEnt)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Obtem o ambiente de execucao do Totvs Services SPED                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oWS := WsSpedCfgNFe():New()
		oWS:cUSERTOKEN := "TOTVS"
		oWS:cID_ENT    := cIdEnt
		oWS:nAmbiente  := 0
		oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
		lOk := oWS:CFGAMBIENTE()
		cAmbiente := oWS:cCfgAmbienteResult
			If lOk
			lOk := oWs:CfgTSSVersao()
			EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Obtem a modalidade de comunicacao com a SEFAZ TSS ou TOTVS Colaboracao  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lOk .And. oWs:cCfgTssVersaoResult >= "1.35"
			oWS:cUSERTOKEN := "TOTVS"
			oWS:cID_ENT    := cIdEnt
			oWS:cUSACOLAB  := cUsaColab
			oWS:nNUMRETNF  := nRetCol
			oWS:nAMBIENTE  := 0
			oWS:nMODALIDADE:= 0
			oWS:cVERSAONFE := ""
			oWS:cVERSAONSE := ""
			oWS:cVERSAODPEC:= ""
			oWS:cVERSAOCTE := ""
			oWS:cUSERNEOG  := cUSERNEOG
			oWS:cPASSWORD  := cPASSWORD
			oWS:cCONFALL   := cCONFALL
				IF oWs:cCfgTssVersaoResult >= "1.43"
					If "1" $ Upper(cDocsColab)
					cConteudo += "1"
					EndiF
					If "2" $ Upper(cDocsColab)
					cConteudo += "2"
					EndIF
					If "3" $ Upper(cDocsColab)
					cConteudo += "3"
					EndIF
					If "4" $ Upper(cDocsColab)
					cConteudo := "4"
					EndIF
					If "0" $ Upper(cDocsColab)
					cConteudo := "0"
					EndIF
				oWS:cDOCSCOL	:= cConteudo
				oWS:nAMBNFECOLAB:= IIF(nAmbNFeC >= 1 .And. nAmbNFeC <=2,nAmbNFeC,2)
				oWS:nAMBCTECOLAB:= IIF(nAmbCTeC >= 1 .And. nAmbCTeC <=2,nAmbCTeC,2)
				EndIF
			oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
			oWS:CFGPARAMSPED()
			EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Obtem a modalidade de execucao do Totvs Services SPED                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lOk
			oWS:cUSERTOKEN := "TOTVS"
			oWS:cID_ENT    := cIdEnt
			oWS:nModalidade:= 0
			oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
			lOk := oWS:CFGModalidade()
			cModalidade    := oWS:cCfgModalidadeResult
				If oWS:CFGModalidade()
				cModalidade    := SubStr(oWS:cCfgModalidadeResult,1,1)
				Else
				cModalidade    := ""
				EndIf

			EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Obtem a versao de trabalho da NFe do Totvs Services SPED                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lOk
			oWS:cUSERTOKEN := "TOTVS"
			oWS:cID_ENT    := cIdEnt
			oWS:cVersao    := "0.00"
			oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
			lOk := oWS:CFGVersao()
			cVersao        := oWS:cCfgVersaoResult
			EndIf
			If lOk
			oWS:cUSERTOKEN := "TOTVS"
			oWS:cID_ENT    := cIdEnt
			oWS:cVersao    := "0.00"
			oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
			lOk := oWS:CFGVersaoCTe()
			cVersaoCTe     := oWS:cCfgVersaoCTeResult
			EndIf
			If lOk
			oWS:cUSERTOKEN := "TOTVS"
			oWS:cID_ENT    := cIdEnt
			oWS:cVersao    := "0.00"
			oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
			lOk := oWS:CFGVersaoDpec()
			cVersaoDpec	   := oWS:cCfgVersaoDpecResult
			EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica o status na SEFAZ                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lOk
			oWS:= WSNFeSBRA():New()
			oWS:cUSERTOKEN := "TOTVS"
			oWS:cID_ENT    := cIdEnt
			oWS:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"
			lOk := oWS:MONITORSEFAZMODELO()
				If lOk
				aXML := oWS:oWsMonitorSefazModeloResult:OWSMONITORSTATUSSEFAZMODELO
					For nX := 1 To Len(aXML)
						Do Case
						Case aXML[nX]:cModelo == "55"
							cMonitorSEF += "- NFe"+CRLF
							cMonitorSEF += "Versao do layout: "+cVersao+CRLF	//"Versao do layout: "
							If !Empty(aXML[nX]:cSugestao)
								cSugestao += "Sugestão"+"(NFe)"+": "+aXML[nX]:cSugestao+CRLF //"Sugestão"
							EndIf

						Case aXML[nX]:cModelo == "57"
							cMonitorSEF += "- CTe"+CRLF
							cMonitorSEF += "Versao do layout: "+cVersaoCTe+CRLF	//"Versao do layout: "
							If !Empty(aXML[nX]:cSugestao)
								cSugestao += "Sugestão"+"(CTe)"+": "+aXML[nX]:cSugestao+CRLF //"Sugestão"
							EndIf
						EndCase
					cMonitorSEF += Space(6)+"Versão da mensagem"+": "+aXML[nX]:cVersaoMensagem+CRLF //"Versão da mensagem"
					cMonitorSEF += Space(6)+"Código do Status"+": "+aXML[nX]:cStatusCodigo+"-"+aXML[nX]:cStatusMensagem+CRLF //"Código do Status"
					cMonitorSEF += Space(6)+"UF Origem"+": "+aXML[nX]:cUFOrigem //"UF Origem"
						If !Empty(aXML[nX]:cUFResposta)
						cMonitorSEF += "("+aXML[nX]:cUFResposta+")"+CRLF //"UF Resposta"
						Else
						cMonitorSEF += CRLF
						EndIf
						If aXML[nX]:nTempoMedioSEF <> Nil
						cMonitorSEF += Space(6)+"Tempo de espera"+": "+Str(aXML[nX]:nTempoMedioSEF,6)+CRLF //"Tempo de espera"
						EndIf
						If !Empty(aXML[nX]:cMotivo)
						cMonitorSEF += Space(6)+"Motivo"+": "+aXML[nX]:cMotivo+CRLF //"Motivo"
						EndIf
						If !Empty(aXML[nX]:cObservacao)
						cMonitorSEF += Space(6)+"Observação"+": "+aXML[nX]:cObservacao+CRLF //"Observação"
						EndIf
					Next nX
				EndIf
			EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem da Interface                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ((lOk == .T. .or. lOk == Nil) .And. (!lCTe))

			SpedNFeTrf("SF2",cSerie,cNotaIni,cNotaFim,cIdEnt,cAmbiente,'1','2.00',.t.,,.t.)

			ElseIf (lCTe) .And. (lOk)
			SpedNFeTrf(aArea[1],aParam[1],aParam[2],aParam[3],cIdEnt,cAmbiente,'1',cVersaoCTe,.T., lCTe,.t.)
			EndIf
		lRetorno := lOk
		Else
		lRetorno := .F.
		EndIf

	EndIf

RestArea(aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³IsReady   ³ Autor ³Eduardo Riera          ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se a conexao com a Totvs Sped Services pode ser    ³±±
±±³          ³estabelecida                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: URL do Totvs Services SPED                        OPC³±±
±±³          ³ExpN2: nTipo - 1 = Conexao ; 2 = Certificado             OPC³±±
±±³          ³ExpL3: Exibe help                                        OPC³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IsReady(cURL,nTipo,lHelp)

Local nX       := 0
Local cHelp    := ""
Local oWS
Local lRetorno := .F.
DEFAULT nTipo := 1
DEFAULT lHelp := .F.
	If !Empty(cURL) .And. !PutMV("MV_SPEDURL",cURL)
	/* Removido\Ajustado - Não executa mais RecLock na X6. Criação/alteração de dados deve ser feita apenas pelo módulo Configurador ou pela rotina de atualização de versão.
	RecLock("SX6",.T.)
	SX6->X6_FIL     := xFilial( "SX6" )
	SX6->X6_VAR     := "MV_SPEDURL"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "URL SPED NFe"
	MsUnLock()*/
	PutMV("MV_SPEDURL",cURL)
	EndIf
SuperGetMv() //Limpa o cache de parametros - nao retirar
DEFAULT cURL      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o servidor da Totvs esta no ar                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWs := WsSpedCfgNFe():New()
oWs:cUserToken := "TOTVS"
oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
	If oWs:CFGCONNECT()
	lRetorno := .T.
	Else
		If lHelp
		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"ok"},3)
		EndIf
	lRetorno := .F.
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o certificado digital ja foi transferido                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTipo <> 1 .And. lRetorno
	oWs:cUserToken := "TOTVS"
	oWs:cID_ENT    := GetIdEnt()
	oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
		If oWs:CFGReady()
		lRetorno := .T.
		Else
			If nTipo == 3
			cHelp := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
				If lHelp .And. !"003" $ cHelp
				Aviso("SPED",cHelp,{"ok"},3)
				lRetorno := .F.
				EndIf
			Else
			lRetorno := .F.
			EndIf
		EndIf
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o certificado digital ja foi transferido                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTipo == 2 .And. lRetorno
	oWs:cUserToken := "TOTVS"
	oWs:cID_ENT    := GetIdEnt()
	oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
		If oWs:CFGStatusCertificate()
			If Len(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE) > 0
				For nX := 1 To Len(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE)
					If oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE[nx]:DVALIDTO-30 <= Date()

					Aviso("SPED","O certificado digital irá vencer em: "+Dtoc(oWs:oWSCFGSTATUSCERTIFICATERESULT:OWSDIGITALCERTIFICATE[nX]:DVALIDTO),{"ok"},3) //"O certificado digital irá vencer em: "

					EndIf
				Next nX
			EndIf
		EndIf
	EndIf

Return(lRetorno)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GetIdEnt  ³ Autor ³Eduardo Riera          ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtem o codigo da entidade apos enviar o post para o Totvs  ³±±
±±³          ³Service                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: Codigo da entidade no Totvs Services                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
Local lUsaGesEmp := IIF(FindFunction("FWFilialName") .And. FindFunction("FWSizeFilial") .And. FWSizeFilial() > 2,.T.,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"

oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := IIF(lUsaGesEmp,FWFilialName(),Alltrim(SM0->M0_NOME))
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
	If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
	Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"ok"},3)
	EndIf

RestArea(aArea)
Return(cIdEnt)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GetIdEnt  ³ Autor ³Eduardo Riera          ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtem o codigo da entidade apos enviar o post para o Totvs  ³±±
±±³          ³Service                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: Codigo da entidade no Totvs Services                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AjustPrc(cNum)

Local aArea     := GetArea()
Local aAreaSC5  := SC5->(GetArea())
Local aAreaSC6  := SC6->(GetArea())
Local aAreaSC9  := SC9->(GetArea())

DbSelectArea("SC6")
SC6->(DbGoTop())
SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial("SC6")+cNum))

	While SC6->(!Eof()) .And. SC6->C6_FILIAL==xFilial("SC6") .And. SC6->C6_NUM==cNum

	SC6->(RecLock("SC6"),.F.)
	SC6->C6_PRUNIT	:= SC6->C6_PRCVEN
	SC6->(MsUnLock())

	SC6->(DbSkip())

	EndDo

RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)
RestArea(aArea)

Return()

/*/{Protheus.doc} fCriaSx1
Definicao dos parametros de pergunta
@author thiago.fonseca
@since 14/10/2015
@version 1.0
@param cPerg, character, (Descrição do parâmetro)
@return ${return}, ${return_description}
/*/

Static Function fCriaSx1(cPerg)

	Local aHelpPor		:= {}

	aHelpPor	:= {}
	AAdd(aHelpPor ,"Somente armazem 01 ou 03!" )
	PutSx1(cPerg, "01", "Do Local:"		,"Do Local:"	 	,"Do Local:"			,"mv_ch1","C"   	,02      	,0     ,0     ,"G",''     ,""	 	,"","","mv_par01","","","","","","","","","","","","","","","","")

	aHelpPor	:= {}
	AAdd(aHelpPor ,"Somente armazem 01 ou 03!" )
	PutSx1(cPerg, "02", "Ate Local:"	,"Ate Local:"	 	,"Ate Local:"			,"mv_ch2","C"   	,02      	,0     ,0     ,"G",'',""	 	,"","","mv_par02","","","","","","","","","","","","","","","","")

	aHelpPor	:= {}
	AAdd(aHelpPor ,"Considerar bloqueados" )
	PutSx1( cPerg, "03", "Considerar bloqueados e desativados?"     ,"","","mv_ch3","N",1,0,0,"C","naovazio"                                          ,""   ,"","","mv_par03","Sim","","","","Não","","")

Return


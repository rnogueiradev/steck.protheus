#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | COFAT110        | Autor | RENATO.OLIVEIRA           | Data | 11/02/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function COFAT110()

	Local _aParamBox		:= {}
	Local _aRet				:= {}
	Private _nTotLiq		:= 0
	Private oProcess
	Private lMsErroAuto		:= .F.
	Private cArquivo 		:= ""
	Private _lValoriza		:= .T.

	AADD(_aParamBox,{1,"Factura de nacionalizacion"	,Space(13) ,"","","","",0,.F.})

	If !ParamBox(_aParamBox,"Valoración",@_aRet,,,.T.,,500)
		Return
	EndIf
	
	DbSelectArea("SF1")
	SF1->(DbSetOrder(1))
	
	If Empty(MV_PAR01)
		_lValoriza := .F.
	EndIf
	
	If _lValoriza

		If !SF1->(DbSeek(xFilial("SF1")+MV_PAR01))
			MsgAlert("No se encuentra la factura de nacionalizacion!")
			Return
		EndIf
	
		DbSelectArea("SD1")
		SD1->(DbSetOrder(1))
		If !SD1->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
			MsgAlert("Artículos no encontrados!")
			Return
		EndIf
	
		_nTotLiq := 0
	
		While SD1->(!Eof()) .And. SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)==;
		SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
			If AllTrim(SD1->D1_COD)=="SERV0006"
				If SF1->F1_MOEDA==2
					_nTotLiq += SD1->D1_TOTAL*SF1->F1_TXMOEDA
				Else
					_nTotLiq += SD1->D1_TOTAL
				EndIf
			EndIf
			SD1->(DbSkip())
		EndDo
	
	EndIf
	
	/*
	If SF1->F1_MOEDA==2
	_nTotLiq 	:= SF1->F1_VALMERC*SF1->F1_TXMOEDA
	ElseIf SF1->F1_MOEDA==1
	_nTotLiq 	:= SF1->F1_VALMERC
	EndIf
	*/

	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*|","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)

	If !File(cArquivo)
		MsgStop("O arquivo " +cDir+cArq + " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return
	EndIf

	oProcess := MsNewProcess():New( { || PROCESSA() } , "Procesando" , "Procesando, por favor espere ..." , .F. )
	oProcess:Activate()

Return()

/*====================================================================================\
|Programa  | PROCESSA        | Autor | RENATO.OLIVEIRA           | Data | 11/02/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function PROCESSA()

	Local cLinha  		:= ""
	Local lPrim   		:= .T.
	Local aCampos 		:= {}
	Local aDados  		:= {}
	Local _nX	  		:= 0
	Local aTransf 		:= {}
	Local _cQuery1    	:= ""
	Local _cAlias1		:= GetNextAlias()
	Local _nQtdTot		:= 0
	Local _nTotal		:= 0
	Local _nQtdIte		:= 0

	oProcess:SetRegua1(FT_FLASTREC())

	FT_FUSE(cArquivo)                   // abrir arquivo
	FT_FGOTOP()                          // ir para o topo do arquivo
	While !FT_FEOF()                     // faça enquanto não for fim do arquivo

		oProcess:IncRegua1("Leyendo el archivo")

		cLinha := FT_FREADLN()           // lendo a linha

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo
	
	If !_lValoriza
		cNumSd3	:=	GetSxeNum("SD3","D3_DOC")
	Else
		cNumSd3 := SF1->F1_DOC
	EndIf
	
	_nTam := 0
	
	For _nX:=1 To Len(aDados)
		If !Empty(aDados[_nX][1]) .And. !Empty(aDados[_nX][2])
			_nTam++
		EndIf
	Next

	aTransf:=Array(_nTam+1)
	aTransf[1] := { cNumSd3 , dDataBase}

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	DbSelectArea("SB2")
	SB2->(DbSetOrder(1))

	oProcess:SetRegua1(Len(aDados))

	For _nX:=1 To Len(aDados)

		oProcess:IncRegua1("Realización de transferencia al almacén 03")
		
		If !Empty(aDados[_nX][1]) .And. !Empty(aDados[_nX][2])

			If !SB2->(DbSeek(xFilial("SB2")+PADR(aDados[_nX][1],15)+"03"))
				CriaSB2(aDados[_nX][1],"03")
			EndIf
	
			SB1->(DbSeek(xFilial("SB1")+aDados[_nX][1]))
	
			aTransf[_nX+1]:=  {{"D3_COD" 	 , SB1->B1_COD							,NIL}}
			aAdd(aTransf[_nX+1],{"D3_DESCRI" , SB1->B1_DESC							,NIL})
			aAdd(aTransf[_nX+1],{"D3_UM"     , SB1->B1_UM							,NIL})
			aAdd(aTransf[_nX+1],{"D3_LOCAL"  , "02"									,NIL})
			aAdd(aTransf[_nX+1],{"D3_LOCALIZ", ""									,NIL})
			aAdd(aTransf[_nX+1],{"D3_COD"    , SB1->B1_COD							,NIL})
			aAdd(aTransf[_nX+1],{"D3_DESCRI" , SB1->B1_DESC							,NIL})
			aAdd(aTransf[_nX+1],{"D3_UM"     , SB1->B1_UM							,NIL})
			aAdd(aTransf[_nX+1],{"D3_LOCAL"  , "03"									,NIL})
			aAdd(aTransf[_nX+1],{"D3_LOCALIZ", ""									,NIL})
			aAdd(aTransf[_nX+1],{"D3_NUMSERI", CriaVar("D3_NUMSERI",.F.) 			,NIL})//numserie
			aAdd(aTransf[_nX+1],{"D3_LOTECTL", CriaVar("D3_LOTECTL",.F.)			,NIL})//lote
			aAdd(aTransf[_nX+1],{"D3_NUMLOTE", CriaVar("D3_NUMLOTE",.F.)			,NIL})//sublote
			aAdd(aTransf[_nX+1],{"D3_DTVALID", CriaVar("D3_DTVALID",.F.)			,NIL})
			aAdd(aTransf[_nX+1],{"D3_POTENCI", CriaVar("D3_POTENCI",.F.)			,NIL})
			aAdd(aTransf[_nX+1],{"D3_QUANT"  , Val(StrTran(StrTran(aDados[_nX][2],".",""),",",".")) 	,NIL})
			aAdd(aTransf[_nX+1],{"D3_QTSEGUM", CriaVar("D3_QTSEGUM",.F.)			,NIL})
			aAdd(aTransf[_nX+1],{"D3_ESTORNO", CriaVar("D3_ESTORNO",.F.)			,NIL})
			aAdd(aTransf[_nX+1],{"D3_NUMSEQ" , CriaVar("D3_NUMSEQ",.F.)				,NIL})
			aAdd(aTransf[_nX+1],{"D3_LOTECTL", CriaVar("D3_LOTECTL",.F.)			,NIL})
			aAdd(aTransf[_nX+1],{"D3_DTVALID", CriaVar("D3_DTVALID",.F.)			,NIL})
		
		EndIf

	Next

	//Transferência do armazém 02 para 03
	MSExecAuto({|x,y| MATA261(x,y)},aTransf,3)

	If lMsErroAuto
		MostraErro()
		SD3->(RollBackSX8())
	Else
		SD3->(ConfirmSX8())
	EndIf
	
	If _lValoriza

		//Valorização no armazém 03 pela fatura de nacionalização
		_cQuery1 := " SELECT *
		_cQuery1 += " FROM "+RetSqlName("SD3")+" D3
		_cQuery1 += " WHERE D3.D_E_L_E_T_=' ' AND D3_DOC='"+SF1->F1_DOC+"'
		_cQuery1 += " AND D3_TM='499' AND D3_LOCAL='03'
	
		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)
	
		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())
	
		While (_cAlias1)->(!Eof())
			_nQtdTot++
			_nTotal += (_cAlias1)->D3_CUSTO1
			(_cAlias1)->(DbSkip())
		EndDo
	
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
	
		oProcess:SetRegua1(_nQtdTot)
	
		(_cAlias1)->(dbGoTop())
		While (_cAlias1)->(!Eof())
	
			oProcess:IncRegua1("Valoración de artículos en el almacén 03")
	
			SB1->(DbSeek(xFilial("SB1")+(_cAlias1)->D3_COD))
	
			_nPercIt	:= (_cAlias1)->D3_CUSTO1/_nTotal
			_nCustAgIt	:= _nPercIt*_nTotLiq
	
			aMovSD3 := {}
	
			aAdd(aMovSD3, {"D3_FILIAL" 	, xFilial('SD3') , NIL})
			aAdd(aMovSD3, {"D3_TM" 		, "400"			 , NIL})
			aAdd(aMovSD3, {"D3_COD"		, (_cAlias1)->D3_COD	 , NIL})
			aAdd(aMovSD3, {"D3_UM"      , SB1->B1_UM	 , NIL})
			aAdd(aMovSD3, {"D3_QUANT"   , 0				 , NIL})
			aAdd(aMovSD3, {"D3_CUSTO1"  , _nCustAgIt     , NIL})
			aAdd(aMovSD3, {"D3_LOCAL"   , (_cAlias1)->D3_LOCAL  , NIL})
			aAdd(aMovSD3, {"D3_EMISSAO" , DDATABASE		 , NIL})
			aAdd(aMovSD3, {"D3_USUARIO" , cUserName 	 , NIL})
			aAdd(aMovSD3, {"D3_CF"      , "DE6" 		 , Nil})
	
			aAdd(aMovSD3, {"D3_XITE1"      , "" 					 , Nil})
			aAdd(aMovSD3, {"D3_XNF1"       , "" 					 , Nil})
			aAdd(aMovSD3, {"D3_XSER1"      , "" 					 , Nil})
			aAdd(aMovSD3, {"D3_XFOR1"      , "" 					 , Nil})
			aAdd(aMovSD3, {"D3_XLOJ1"      , ""				 		 , Nil})
	
			aAdd(aMovSD3, {"D3_XITE1"      , (_cAlias1)->D3_NUMSEQ 	 , Nil})
			aAdd(aMovSD3, {"D3_XNF2"       , SF1->F1_DOC 			 , Nil})
			aAdd(aMovSD3, {"D3_XSER2"      , SF1->F1_SERIE			 , Nil})
			aAdd(aMovSD3, {"D3_XFOR2"      , SF1->F1_FORNECE	     , Nil})
			aAdd(aMovSD3, {"D3_XLOJ2"      , SF1->F1_LOJA	 		 , Nil})
	
			MSExecAuto({|x| MATA240(x)}, aMovSD3 )
	
			lMsErroAuto := .F.
	
			If lMsErroAuto
				MostraErro()
			EndIf
	
			(_cAlias1)->(DbSkip())
		EndDo
	
	EndIf

Return()
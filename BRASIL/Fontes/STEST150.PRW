#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | STEST150         | Autor | Renato Nogueira            | Data | 21/09/2020|
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                     	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STEST150()

	Local _aParamBox 	:= {}
	Local _aRet 		:= {}
	Local _cQuery1		:= ""
	Local _cAlias1 		:= GetNextAlias()
	Local aHeader		:= {}
	Local aCols			:= {}
	Local lSaida   		:= .T.
	Local aSize	   		:= MsAdvSize(.F.)
	Local aCampoEdit	:= {}
	Local oWindow
	Local nY
	Local aHead				:= {}
	Local bOk 				:= {||(	lSaida:=.f., lConfirma:=.T.,oWindow:End()) }
	Local bCancel 	    	:= {||(	lSaida:=.f.,oWindow:End()) }
	Local aButtons	    	:= {}
	Local lConfirma 		:= .F.
	Local _nX				:= 0

	AADD(aHeader,{"Marcar" 			, "CHECK" 	  	  , "@BMP" 				,    02    ,      0 ,"",   	,"C" 	,""		,"R"		,""})
	AADD(aHeader,{"Produto"			, "PRODUTO" 	  , "@!" 				,    15    ,      0 ,"",   	,"C" 	,""		,"R"		,""})
	AADD(aHeader,{"Localização"		, "LOCALIZ" 	  , "@!" 				,    15    ,      0 ,"",   	,"C" 	,""		,"R"		,""})
	AADD(aHeader,{"Qtde"			, "QTDE" 	  	  , "@E" 				,    12    ,      2 ,"",   	,"C" 	,""		,"R"		,""})
	AADD(aHeader,{"Registro"		, "RECNO" 	  	  , "@E" 				,    12    ,      0 ,"",   	,"C" 	,""		,"R"		,""})

	AADD(_aParamBox,{1,"Armazém"		,Space(02),"@!","","",".T.",50,.T.})
	AADD(_aParamBox,{1,"Endereço de"	,Space(15),"@!","","SBE",".T.",50,.T.})
	AADD(_aParamBox,{1,"Endereço para"	,Space(15),"@!","","SBE",".T.",50,.T.})

	If !ParamBox(_aParamBox,"Endereçamento",@_aRet,,,.T.,,500)
		Return
	EndIf

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SBF")+" BF
	_cQuery1 += " WHERE BF.D_E_L_E_T_=' ' AND BF_QUANT>0 
	_cQuery1 += " AND BF_FILIAL='"+xFilial("SBF")+"'
	_cQuery1 += " AND BF_LOCAL='"+MV_PAR01+"'
	_cQuery1 += " AND BF_LOCALIZ='"+MV_PAR02+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	DbSelectArea("SB2")
	SB2->(DbSetOrder(1))
	DbSelectArea("SBF")
	SBF->(DbSetOrder(1))

	_nCount := 0

	While (_cAlias1)->(!Eof())

		AADD(aCols,Array(Len(aHeader)+1))

		For nY := 1 To Len(aHeader)

			DO CASE

			CASE AllTrim(aHeader[nY][2]) ==  "CHECK"
				aCols[Len(aCols)][nY] := "LBNO"
			CASE AllTrim(aHeader[nY][2]) ==  "PRODUTO"
				aCols[Len(aCols)][nY] := (_cAlias1)->BF_PRODUTO
			CASE AllTrim(aHeader[nY][2]) ==  "QTDE"
				aCols[Len(aCols)][nY] := (_cAlias1)->BF_QUANT
			CASE AllTrim(aHeader[nY][2]) ==  "LOCALIZ"
				aCols[Len(aCols)][nY] := (_cAlias1)->BF_LOCALIZ
			CASE AllTrim(aHeader[nY][2]) ==  "RECNO"
				aCols[Len(aCols)][nY] := (_cAlias1)->R_E_C_N_O_

			ENDCASE

		Next

		aCols[Len(aCols)][Len(aHeader)+1] := .F.

		(_cAlias1)->(DbSkip())
	EndDo

	While lSaida
		DEFINE MSDIALOG oWindow FROM 0,0 TO 300,800 TITLE Alltrim(OemToAnsi("Transferência")) Pixel //430,531
		oGet	:= MsNewGetDados():New(030,000,oWindow:nClientHeight/2-5,oWindow:nClientWidth/2-5, GD_UPDATE ,"AllWaysTrue()","AllWaysTrue()",,aCampoEdit,,Len(aCols),,, ,oWindow, aHeader, aCols )
		bDbClick := oGet:oBrowse:bLDblClick
		oGet:oBrowse:bLDblClick := {|| (Iif(oGet:aCols[oGet:nAt,1]=="LBNO",;
		oGet:aCols[oGet:nAt,1]:="LBOK",;
		oGet:aCols[oGet:nAt,1]:="LBNO"),;
		oGet:oBrowse:Refresh())}
		ACTIVATE MSDIALOG oWindow CENTERED ON INIT EnchoiceBar(oWindow,bOk,bCancel,,aButtons)
	EndDo

	If lConfirma
		For _nX:=1 To Len(oGet:aCols)
			If oGet:aCols[_nX][1]=="LBOK"
				SBF->(DbGoTo(oGet:aCols[_nX][Len(oGet:aCols[_nX])-1]))
				If SBF->(!Eof())

					If !SB1->(DbSeek(xFilial("SB1")+SBF->BF_PRODUTO))
						Loop
					EndIf
		
					aAuto := {}
					aItem := {}
					aLinha:= {}
					
					cNumSd3	:=	GetSxeNum("SD3","D3_DOC")
					aadd(aAuto,{cNumSd3,dDataBase}) //Cabecalho

					aadd(aLinha,{"D3_COD", 		SB1->B1_COD							, Nil})
					aadd(aLinha,{"D3_DESCRI", 	SB1->B1_DESC						, Nil})
					aadd(aLinha,{"D3_UM", 		SB1->B1_UM							, Nil})
					aadd(aLinha,{"D3_LOCAL",	SBF->BF_LOCAL						, Nil})
					aadd(aLinha,{"D3_LOCALIZ",	SBF->BF_LOCALIZ						, Nil})
					aadd(aLinha,{"D3_COD",		SB1->B1_COD							, Nil})
					aadd(aLinha,{"D3_DESCRI",	SB1->B1_DESC						, Nil})
					aadd(aLinha,{"D3_UM",		SB1->B1_UM							, Nil})
					aadd(aLinha,{"D3_LOCAL",	SBF->BF_LOCAL						, Nil})
					aadd(aLinha,{"D3_LOCALIZ",	MV_PAR03							, Nil})
					aadd(aLinha,{"D3_NUMSERI",	CriaVar("D3_NUMSERI",.F.)			, Nil})
					aadd(aLinha,{"D3_LOTECTL",	CriaVar("D3_LOTECTL",.F.)			, Nil})
					aadd(aLinha,{"D3_NUMLOTE",	CriaVar("D3_NUMLOTE",.F.)			, Nil})
					aadd(aLinha,{"D3_DTVALID",	CriaVar("D3_DTVALID",.F.)			, Nil})
					aadd(aLinha,{"D3_POTENCI",	CriaVar("D3_POTENCI",.F.)			, Nil})
					aadd(aLinha,{"D3_QUANT",	SBF->BF_QUANT						, Nil})
					aadd(aLinha,{"D3_QTSEGUM",	CriaVar("D3_QTSEGUM",.F.)			, Nil})
					aadd(aLinha,{"D3_ESTORNO",	CriaVar("D3_ESTORNO",.F.)			, Nil})
					aadd(aLinha,{"D3_NUMSEQ",	CriaVar("D3_NUMSEQ",.F.)			, Nil})
					aadd(aLinha,{"D3_LOTECTL",	CriaVar("D3_LOTECTL",.F.)			, Nil})
					aadd(aLinha,{"D3_DTVALID",	CriaVar("D3_DTVALID",.F.)			, Nil})

					aAdd(aAuto,aLinha)

					_cRet := StartJob("U_STEST151",GetEnvServer(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL,aAuto)
					If _cRet=="OK"
						_nCount++
					Else
						MsgAlert(_cRet)
					EndIf
		
				EndIf
			EndIf
		Next
	EndIf

	MsgAlert("Foram transferidos "+cValTochar(_nCount)+" produtos!")

	U_STEST150()

Return()

User Function STEST151(_cEmp,_cFil,aAuto)

	Local _cProc := ""
	Private lMsErroAuto := .F.

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"COM")

	MSExecAuto({|x,y| mata261(x,y)},aAuto,3)

	If lMsErroAuto
		_cProc := MostraErro("arquivos\logs",dtos(date())+time()+".log")
		SD3->(RollBackSX8())
	Else
		_cProc := "OK"
		SD3->(ConfirmSX8())
	EndIf

Return(_cProc)

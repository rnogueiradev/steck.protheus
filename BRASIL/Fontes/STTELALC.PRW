#include 'Protheus.ch' 
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#DEFINE CR    chr(13)+chr(10)
/*====================================================================================\
|Programa  | STTELALC         | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição | STTELALC                                                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTELALC                 	                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STTELALC(_cTip,_cStPed,_n01,_n02)
	*-----------------------------*
	Local nOpca 	:= 0
	Local _nOpcao 	:= 3
	Local _xAlias 	:= GetArea()
	Local aFields 	:= {}
	Local aCpoEnch	:= {}
	Local aTam  	:= {}
	Local aNoEnch	:= {}
	Local oDlg
	Local aSize 	:= MsAdvSize()
	Local bCampoSC5	:= { |nCPO| Field(nCPO) }
	Local aCposAlt 	:= {}
	Local aHeader	:= {}
	Local aHeader2	:= {}
	Local aCols		:={}
	Local aCols2:={}
	Local aObjects	:= {}
	Local aInfo		:= {}
	Local aPosObj	:= {}
	Local aGrup		:= {}
	Local _nAsc  := 0
	Local aButtons		:= {}
	Local _ni:=1
	Local k:=1
	Local nUsado			:= 0
	Local aContra    :={}
	Local nCusto     :=0
	Local nValLiq    :=0
	Private _lCancel := .F.
	AAdd( aObjects, { 100, 450, .T., .T. } )
	AAdd( aObjects, { 200, 200, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria variaveis M->????? da Enchoice                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RegToMemory("ZZI", .F. , .F.)
	/*
	For nCntFor := 1 TO FCount()
	M->&(EVAL(bCampoSC5,nCntFor)) := FieldGet(nCntFor)
	Next nCntFor
	*/

ProcRegua(17)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria aHeader e aCols da GetDados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nUsado:=0

Aadd(aHeader,{" ",				"XX_LEGEND"	,"@BMP",2,0,".F.","€€€€€€€€€€€€€€€","C","","V","","","","V"})
aAdd(aHeader,{"Item",			"XX_ITEM"	,"@!",TamSx3("D2_ITEMPV")[1],0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
aAdd(aHeader,{"Produto",		"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
aAdd(aHeader,{"Qtd.",			"XX_QTD1"	,"@E 999999.99",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
aAdd(aHeader,{"Prc.Ven.",		"XX_QTD2"	,"@E 999,999.99",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
aAdd(aHeader,{"Prc.Plat"  ,		"XX_QTD9"	,"@E 999,999.99",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
aAdd(aHeader,{"Ult.Prc.",		"XX_QTD3"	,"@E 999,999.99",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
aAdd(aHeadeR,{"Ult. Comp.",		"XX_QTDA"   ," " ,TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
aAdd(aHeader,{"Prc.Tab.",		"XX_QTD4"   ,"@E 999,999.99",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
aAdd(aHeader,{"Prc.Camp.",		"XX_QTD8"   ,"@E 999,999.99",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
aAdd(aHeader,{"Desc.%",			"XX_QTD5"   ,"@E 999,999.99",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
aAdd(aHeader,{"Contrato",		"XX_CONTRA"   ,"@!",TamSx3("Z73_CODIGO")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})

If __cUserID $ AllTrim(GetMv("STTELALC01",,""))
	//aAdd(aHeader,{"Custo",			"XX_QTD6"   ,"@E 999,999.99",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(aHeader,{"GM % ",			    "XX_QTD7"   ,"@E 999,999.99",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
EndIf

nUsado:=len(aHeader)
aCols:={}
If _cTip = '1'
	SC5->(dbSelectArea("SC5"))
	SC5->(dbSetOrder(1))
	If	SC5->(dbSeek(xFilial("SC5")+_cStPed))
		SC6->(dbSelectArea("SC6"))
		SC6->(dbSetOrder(1))
		If	SC6->(dbSeek(xFilial("SC6")+_cStPed))
			While !SC6->(eof()) .and. SC6->C6_NUM == _cStPed
				incproc()
				SB1->(dbSelectArea("SB1"))
				SB1->(DbSetOrder(1))
				If SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
					dbSelectArea("SBM")
					SBM->(dbSetOrder(1))
					SBM->(dbSeek(xFilial("SBM")+SB1->B1_GRUPO))
					AADD(	aGrup,{SB1->B1_GRUPO , SBM->BM_DESC ,SC6->C6_QTDVEN* IIF(SC6->C6_XCUSTO <> 0,SC6->C6_XCUSTO ,U_STCUSTO(SC6->C6_PRODUTO) ) ,  SC6->C6_ZVALLIQ })
				EndIf
				AADD(aCols,Array(nUsado+1))
				nCusto:=U_STCUSTO1(SC6->C6_PRODUTO)
				nValLiq:=SC6->C6_ZVALLIQ/SC6->C6_QTDVEN
				For _ni:=1 to nUsado
					If aHeader[_ni,2] = "XX_ITEM"
						aCols[Len(aCols),_ni]:=SC6->C6_ITEM
					ElseIf aHeader[_ni,2] = "XX_COD"
						aCols[Len(aCols),_ni]:=SC6->C6_PRODUTO
					ElseIf aHeader[_ni,2] = "XX_QTD6"
						aCols[Len(aCols),_ni]:=nCusto //    IIF(SC6->C6_XCUSTO <> 0,SC6->C6_XCUSTO ,U_STCUSTO(SC6->C6_PRODUTO) )
					ElseIf aHeader[_ni,2] = "XX_QTD7"
						//aCols[Len(aCols),_ni]:=((SC6->C6_PRCVEN-nCusto) / SC6->C6_PRCVEN)*100        //(SC6->C6_ZVALLIQ/SC6->C6_QTDVEN)/ IIF(SC6->C6_XCUSTO <> 0,SC6->C6_XCUSTO ,U_STCUSTO(SC6->C6_PRODUTO) )
					    aCols[Len(aCols),_ni]:=((nValLiq-nCusto) / nValliq)*100        //(SC6->C6_ZVALLIQ/SC6->C6_QTDVEN)/ IIF(SC6->C6_XCUSTO <> 0,SC6->C6_XCUSTO ,U_STCUSTO(SC6->C6_PRODUTO) )
					ElseIf aHeader[_ni,2] = "XX_QTD8"
						aCols[Len(aCols),_ni]:=SC6->C6_XCAMPA
					ElseIf aHeader[_ni,2] = "XX_QTD9"
						_cUf:= 'SP'
						DbSelectArea("SA1")
						SA1->(dbSetOrder(1))
						If		SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI )) .And. Substr(SA1->A1_GRPVEN,1,1) <> 'E'
							_cUf:= SA1->A1_EST
						EndIf
						aCols[Len(aCols),_ni]:=U_STRETSST('01',GetMv("ST_CLIPAD",,'094320') , _cUf,SC6->C6_PRODUTO,GetMv("ST_CONDPAG",,'502'),'PRECO')
					ElseIf aHeader[_ni,2] = "XX_QTD1"
						aCols[Len(aCols),_ni]:=SC6->C6_QTDVEN
					ElseIf aHeader[_ni,2] = "XX_QTD2"
						aCols[Len(aCols),_ni]:=SC6->C6_PRCVEN
					ElseIf aHeader[_ni,2] = "XX_QTD3"
						aCols[Len(aCols),_ni]:=SC6->C6_XULTPRC
					ElseIf aHeader[_ni,2] = "XX_QTDA"
						aCols[Len(aCols),_ni]:=SC6->C6_XULTCOM
					ElseIf aHeader[_ni,2] = "XX_QTD4"
						aCols[Len(aCols),_ni]:=SC6->C6_ZPRCTAB
					ElseIf aHeader[_ni,2] = "XX_QTD5"
						aCols[Len(aCols),_ni]:= iif(SC6->C6_ZPRCTAB<>0,100-((SC6->C6_PRCVEN*100)/SC6->C6_ZPRCTAB),SC6->C6_XPORDEC)
					ElseIf aHeader[_ni,2] = "XX_LEGEND"
						aCols[Len(aCols),_ni]:=IIF(SC6->C6_PRCVEN>=SC6->C6_ZPRCTAB,"br_verde", "br_vermelho")
						If SC6->C6_XCUSTO   = 0//IIF(SC6->C6_XCUSTO <> 0,SC6->C6_XCUSTO ,U_STCUSTO(SC6->C6_PRODUTO) ) = 0
							aCols[Len(aCols),_ni]:= "br_amarelo"
						EndIf
						If SC6->C6_ZPRCTAB = 0
							aCols[Len(aCols),_ni]:= "br_azul"
						EndIf
					ELSEIF aHeader[_ni,2] = "XX_CONTRA"
					    aContra:=U_STFAT391(SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRODUTO)
						IF LEN(aContra)>0
                           aCols[Len(aCols),_ni]:=aContra[1,3]
						ENDIF
					EndIf
				Next
				aCols[Len(aCols),nUsado+1]:=.F.
				SC6->(dbSkip())
			End
		EndIf
	EndIf
Else
	dbSelectArea("SUB")
	SUB->(dbSetOrder(1))
	If	SUB->(dbSeek(xFilial()+_cStPed))
		While !SUB->(eof()) .and. SUB->UB_NUM==_cStPed
			incproc()
			SB1->(dbSelectArea("SB1"))
			SB1->(DbSetOrder(1))
			If SB1->(DbSeek(xFilial("SB1")+SUB->UB_PRODUTO))
				dbSelectArea("SBM")
				SBM->(dbSetOrder(1))
				SBM->(dbSeek(xFilial("SBM")+SB1->B1_GRUPO))
				AADD(	aGrup,{SB1->B1_GRUPO,SBM->BM_DESC  ,SUB->UB_QUANT* IIF(SUB->UB_XCUSTO <> 0,SUB->UB_XCUSTO ,U_STCUSTO(SUB->UB_PRODUTO) ) ,  SUB->UB_ZVALLIQ })
			EndIf

			AADD(aCols,Array(nUsado+1))
			nCusto:=U_STCUSTO1(SUB->UB_PRODUTO)
			nValLiq:=SUB->UB_ZVALLIQ/SUB->UB_QUANT
			For _ni:=1 to nUsado
				If aHeader[_ni,2] = "XX_ITEM"
					aCols[Len(aCols),_ni]:=SUB->UB_ITEM
				ElseIf aHeader[_ni,2] = "XX_COD"
					aCols[Len(aCols),_ni]:=SUB->UB_PRODUTO
				ElseIf aHeader[_ni,2] = "XX_QTD6"
					aCols[Len(aCols),_ni]:=nCusto //IIF(SUB->UB_XCUSTO <> 0,SUB->UB_XCUSTO ,U_STCUSTO1(SUB->UB_PRODUTO) )
				ElseIf aHeader[_ni,2] = "XX_QTD7"
					//aCols[Len(aCols),_ni]:=((SUB->UB_VRUNIT-nCusto) / SUB->UB_VRUNIT)*100  // (SUB->UB_ZVALLIQ/SUB->UB_QUANT)/IIF(SUB->UB_XCUSTO <> 0,SUB->UB_XCUSTO ,U_STCUSTO(SUB->UB_PRODUTO) )
				    aCols[Len(aCols),_ni]:=((nValLiq-nCusto) / nValLiq)*100  // (SUB->UB_ZVALLIQ/SUB->UB_QUANT)/IIF(SUB->UB_XCUSTO <> 0,SUB->UB_XCUSTO ,U_STCUSTO(SUB->UB_PRODUTO) )
				ElseIf aHeader[_ni,2] = "XX_QTD8"
					aCols[Len(aCols),_ni]:=SUB->UB_XCAMPA
				ElseIf aHeader[_ni,2] = "XX_QTD9"
					_cUf:= 'SP'
					DbSelectArea("SA1")
					SA1->(dbSetOrder(1))
					If		SA1->(DbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA )) .And. Substr(SA1->A1_GRPVEN,1,1) <> 'E'
						_cUf:=  SA1->A1_EST
					EndIf

					aCols[Len(aCols),_ni]:=U_STRETSST('01',GetMv("ST_CLIPAD",,'094320') , _cUf ,SUB->UB_PRODUTO,GetMv("ST_CONDPAG",,'502'),'PRECO')
				ElseIf aHeader[_ni,2] = "XX_QTD1"
					aCols[Len(aCols),_ni]:=SUB->UB_QUANT
				ElseIf aHeader[_ni,2] = "XX_QTD2"
					aCols[Len(aCols),_ni]:=SUB->UB_VRUNIT
				ElseIf aHeader[_ni,2] = "XX_QTD3"
					aCols[Len(aCols),_ni]:=SUB->UB_XULTPRC
				ElseIf aHeader[_ni,2] = "XX_QTDA"
					aCols[Len(aCols),_ni]:=SUB->UB_XULTCOM
				ElseIf aHeader[_ni,2] = "XX_QTD4"
					aCols[Len(aCols),_ni]:=SUB->UB_ZPRCTAB
				ElseIf aHeader[_ni,2] = "XX_QTD5"
					aCols[Len(aCols),_ni]:= iif(SUB->UB_ZPRCTAB <> 0 ,100-((SUB->UB_VRUNIT*100)/SUB->UB_ZPRCTAB),0)
				ElseIf aHeader[_ni,2] = "XX_LEGEND"
					aCols[Len(aCols),_ni]:=IIF(SUB->UB_VRUNIT >= SUB->UB_ZPRCTAB , "br_verde" , "br_vermelho")
					If SUB->UB_XCUSTO  = 0//IIF(SUB->UB_XCUSTO <> 0,SUB->UB_XCUSTO ,U_STCUSTO(SUB->UB_PRODUTO) ) = 0
						aCols[Len(aCols),_ni]:= "br_amarelo"
					EndIf
					If SUB->UB_ZPRCTAB = 0
						aCols[Len(aCols),_ni]:= "br_azul"
					EndIf
				ELSEIF aHeader[_ni,2] = "XX_CONTRA"
				    aContra:=U_STFAT391(SUA->UA_CLIENTE,SUA->UA_LOJA,SUB->UB_PRODUTO)
					IF LEN(aContra)>0
                       aCols[Len(aCols),_ni]:=aContra[1,3]
					ENDIF
				EndIf
			Next
			aCols[Len(aCols),nUsado+1]:=.F.
			SUB->(dbSkip())
		End
	EndIf
EndIf

//***********************************************************************************
/*/
aAdd(aHeader2,{"Grupo",			"XX_ITEM"	,"@!",TamSx3("B1_GRUPO")[1],0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
aAdd(aHeader2,{"Descrição",		"XX_COD"	,"@!",TamSx3("D2_COD")[1]	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})

If __cUserID $ AllTrim(GetMv("STTELALC01",,""))
	aAdd(aHeader2,{"Custo",			"XX_QTD1"	,"@E 999,999.99",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(aHeader2,{"Markup",			"XX_QTD3"   ,"@E 999,999.99",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})
EndIf

aAdd(aHeader2,{"Net",		"XX_QTD2"	,"@E 999,999.99",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","€€€€€€€€€€€€€€€","N","","","","",".T."})

nUsado:=len(aHeader2)
aCols2:={}

For k:=1 To Len(aGrup)
	_nAsc  := 0
	_nAsc  := aScan(aCols2, { |x| Alltrim(x[1]) == alltrim(aGrup[k,1])    })
	If _nAsc > 0
		For _ni:=1 to nUsado
			If aHeader2[_ni,2] = "XX_ITEM"
				aCols2[ _nAsc,_ni]:=aGrup[k,1]
			ElseIf aHeader2[_ni,2] = "XX_COD"
				aCols2[_nAsc,_ni]:=aGrup[k,2]
			ElseIf aHeader2[_ni,2] = "XX_QTD1"
				aCols2[_nAsc,_ni]:=aCols2[_nAsc,_ni] + aGrup[k,3]
			ElseIf aHeader2[_ni,2] = "XX_QTD2"
				aCols2[_nAsc,_ni]:=aCols2[_nAsc,_ni] + aGrup[k,4]
			ElseIf aHeader2[_ni,2] = "XX_QTD3"
				aCols2[_nAsc,_ni]:= aCols2[_nAsc,4]/aCols2[_nAsc,3]
			EndIf
		Next _ni

	Else
		AADD(aCols2,Array(nUsado+1))
		For _ni:=1 to nUsado
			If aHeader2[_ni,2] = "XX_ITEM"
				aCols2[Len(aCols2),_ni]:=aGrup[k,1]
			ElseIf aHeader2[_ni,2] = "XX_COD"
				aCols2[Len(aCols2),_ni]:=aGrup[k,2]
			ElseIf aHeader2[_ni,2] = "XX_QTD1"
				aCols2[Len(aCols2),_ni]:=aGrup[k,3]
			ElseIf aHeader2[_ni,2] = "XX_QTD2"
				aCols2[Len(aCols2),_ni]:=aGrup[k,4]
			ElseIf aHeader2[_ni,2] = "XX_QTD3"
				aCols2[Len(aCols2),_ni]:=aGrup[k,4]/aGrup[k,3]
			EndIf
		Next _ni
		aCols2[Len(aCols2),nUsado+1]:=.F.

	EndIf
Next k
//***********************************************************************************
For _ni:=1 to len(aCols2)
	//aCols2[_ni, 5]:= aCols2[_ni, 4]/aCols2[_ni, 3]
Next _ni

aSort(aCols2  ,,, { |x,y| y[1] > x[1]} )
/*/
IF Len(aCols)>0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a Modelo 3                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTitulo:=OemToAnsi("Alçada Desconto")

	cLinOk    :="AllwaysTrue()"
	cTudoOk   :="AllwaysTrue()"
	aCpoEnchoice:={'ZZI_REFER','ZZI_USERAP','ZZI_DTAPR'}
	aAltEnchoice := {'ZZI_REJEI','ZZI_RASTRO','ZZI_MREJEI','ZZI_MOBS'}

	Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
		bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
	Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	EnChoice( "ZZI" ,ZZI->(Recno()), 4, , , , aCpoEnchoice, aPosObj[1], aAltEnchoice, 3 )
	oGetDados  := MSNewGetDados()   :New (aPosObj[2,1], aPosObj[2,2] , aPosObj[2,3], aPosObj[2,4],	,cLinOk			,cTudoOk		,""			,		, 		 ,1			,			,Len(aCols),		,   				,	aHeader,aCols		)
	//oGetDados  := MSNewGetDados()   :New (aPosObj[2,1], aPosObj[2,2] , aPosObj[2,3], aPosObj[2,4]-215,	,cLinOk			,cTudoOk		,""			,		, 		 ,1			,			,Len(aCols),		,   				,	aHeader,aCols		)
	//o2GetDados  := MSNewGetDados()   :New (aPosObj[2,1], aPosObj[2,4]-213 , aPosObj[2,3], aPosObj[2,4],	,cLinOk			,cTudoOk		,""			,		, 		 ,1			,			,Len(aCols2),		,   				,	aHeader2,aCols2		)
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,IiF(_n01 > _n02,.t.,u_GRVALC()),oDlg:End() },{||oDlg:End()},,aButtons)

EndIF

RestArea(_xAlias)

If _lCancel
	nOpca := 0
EndIf

_cRejei 	:= M->ZZI_REJEI
_cMRejei 	:= M->ZZI_MREJEI

Return (nOpca)

User Function GRVALC()
	Local _cEmailDes 	:= ""
	Local _cEmailSup 	:= ""
	Local _cEmailInt 	:= ""

	//Bloquear quando houver itens sem custo - Solicitação Vanderlei Souto em 03/01/2019

	_lSemCusto := .F.

	Do Case
	Case AllTrim(ZZI->ZZI_TIPO)=="ORÇAMENTO"

		DbSelectArea("SUA")
		SUA->(dbSetOrder(1))

		If SUA->(DbSeek(xFilial("SUA")+ZZI->ZZI_NUM))

			DbSelectArea("SUB")
			SUB->(DbSetOrder(1))
			SUB->(DbSeek(SUA->(UA_FILIAL+UA_NUM)))

			While SUB->(!Eof()) .And. SUA->(UA_FILIAL+UA_NUM)==SUB->(UB_FILIAL+UB_NUM)
				If U_STCUSTO(SUB->UB_PRODUTO)<=0
					_lSemCusto := .T.
				EndIf
				SUB->(DbSkip())
			EndDo

		EndIf

	Case AllTrim(ZZI->ZZI_TIPO)=="PEDIDO"

		DbSelectArea("SC5")
		SC5->(dbSetOrder(1))

		If SC5->(DbSeek(xFilial("SC5")+ZZI->ZZI_NUM))

			DbSelectArea("SC6")
			SC6->(DbSetOrder(1))
			SC6->(DbSeek(SC5->(C5_FILIAL+C5_NUM)))

			While SC6->(!Eof()) .And. SC5->(C5_FILIAL+C5_NUM)==SC6->(C6_FILIAL+C6_NUM)
				If U_STCUSTO(SC6->C6_PRODUTO)<=0
					_lSemCusto := .T.
				EndIf
				SC6->(DbSkip())
			EndDo

		EndIf
	EndCase
	/*
	If _lSemCusto
		MsgAlert("Atenção, existem itens sem custo neste orçamento/pedido e ele não poderá ser liberado, verifique!")
		_lCancel := .T.
		Return
	EndIf
	*/
	If !('PEDIDO' $ ZZI->ZZI_TIPO)

		dbSelectArea("SUA")
		SUA->(dbSetOrder(1))

		If SUA->(DbSeek(xFilial("SUA")+ZZI->ZZI_NUM))

			If !(Empty(Alltrim(SUA->UA_XDESBLQ)))
				_nRetorno := CABALCX()
				If !(_nRetorno==1)
					MsgAlert("Liberação cancelada!")
					_lCancel := .T.
					Return()
				EndIf
			EndIf

            Begin Transaction 

			ALTZZI()

			_aMail:= {}
			If	 ZZI->ZZI_REJEI = '1'
				SUA->(RecLock("SUA",.F.))
				SUA->UA_XDESBLQ := 'REJEITADO'
				cLogAnali 		:= "Analisado por: " + cUserName + CR+ CR+ " em " + DtoC(dDatabase) + CR+CR+" às " + Time()+ CR+  CR
				_cMsgDesc		:= cLogAnali+ CR+" - REJEITADO- " + AllTrim(ZZI->ZZI_MREJEI)+ ' - Obs.: '+ AllTrim(ZZI->ZZI_RASTRO) +CR+CR
				SUA->UA_XALCMSG	:= aLLTRIM(_cMsgDesc)+ CR+ CR+	CR +  aLLTRIM(SUA->UA_XALCMSG)
				SUA->(MsUnlock())
				SUA->( DbCommit() )
			Else
				SUA->(RecLock("SUA",.F.))
				cLogAnali 		:= "Analisado por: " + cUserName + CR+ CR + " em " + DtoC(dDatabase) + CR+CR+" às " + Time()+ CR+ CR
				_cMsgDesc		:= cLogAnali+ CR+" - APROVADO - Obs.: " + AllTrim(ZZI->ZZI_RASTRO) +CR+CR
				SUA->UA_XALCMSG	:= aLLTRIM(_cMsgDesc)+ CR+	CR + CR+  aLLTRIM(SUA->UA_XALCMSG)
				SUA->(MsUnlock())
				SUA->( DbCommit() )
			EndIf

			Aadd(_aMail,{ZZI->ZZI_TIPO 	,ZZI->ZZI_NUM,'',''})
			Aadd(_aMail,{'Cliente' 		,ZZI->ZZI_CLIENT+'-'+ZZI->ZZI_LOJA,'',''})
			Aadd(_aMail,{'Nome' 		,ZZI->ZZI_NOMECL,'',''})
			Aadd(_aMail,{'Coordenador' 	,ZZI->ZZI_SUPER+' - '+Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_SUPER,"A3_NOME"),'',''})
			Aadd(_aMail,{'Vendedor 01' 	,ZZI->ZZI_VEND1+' - '+ZZI->ZZI_NVEND1,'',''})
			Aadd(_aMail,{'Vendedor 02' 	,ZZI->ZZI_VEND2+' - '+ZZI->ZZI_NVEND2,'',''})
			Aadd(_aMail,{'%Desconto' 	,Transform( ZZI->ZZI_DESC  ,"@E 999,999,999.99")+'%','',''})
			Aadd(_aMail,{'Obs.:' 	, Alltrim(ZZI->ZZI_OBSVEN),'',''})
			Aadd(_aMail,{'Historico:' 	, Alltrim(SUA->UA_XALCMSG),'',''})

			If ZZI->ZZI_REJEI = '1'
				Aadd(_aMail,{'Considerações,:' 	,Alltrim( ZZI->ZZI_MREJEI ),'',''})
			Else
				Aadd(_aMail,{'Considerações,:' 	,Alltrim( ZZI->ZZI_RASTRO ),'',''})
			EndIf

			If GetMv("ST_DES001",,.T.)
				
				//_cEmailDes :=";
				//	Alltrim(Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND1,"A3_EMAIL" ))+";"+ ;
				//	Alltrim(Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND2,"A3_EMAIL" ))

				// Ticket: 20201020009133
				// Garantir o envio de WF ao Daniel, somente dessas areas

				/*/
				If ZZI->ZZI_SUPER $ "S00009/S00010/S00003/R00563/R00296/R00195/C00009/C00010"
					_cEmailDes += "; daniel.santos@steck.com.br"
				Endif
				_cEmailSup 	:= Alltrim(Posicione("SA3",1,xFilial("SA3")+Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND2,"A3_SUPER"),	"A3_EMAIL" ))
				_cEmailInt 	:= Alltrim(Posicione("SA3",1,xFilial("SA3")+Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND1,"A3_XSUPINT"),	"A3_EMAIL" ))
				If !_cEmailSup $ _cEmailDes
					_cEmailDes += "; " + _cEmailSup
				EndIf
				If !_cEmailInt $ _cEmailDes
					_cEmailDes += "; " + _cEmailInt
				EndIf
                /*/

		        _cEmailDes:=AllTrim(GetMv("STDESALC03",,""))+;
			    Alltrim(Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND1,"A3_EMAIL" ))+";"+ ;
			    Alltrim(Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND2,"A3_EMAIL" ))+";"+ ;
			    Alltrim(Posicione("SA3",1,xFilial("SA3")+Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND2,"A3_XSUPINT"),"A3_EMAIL" ))+";"+ ;
			    Alltrim(Posicione("SA3",1,xFilial("SA3")+Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND1,"A3_SUPER"),"A3_EMAIL" ))

				ZZIMAIL(_aMail, _cEmailDes)
			
			EndIf

            End Transaction

		EndIf

	Else

		Begin Transaction 
		
		ALTZZI()

		_aMail:= {}

		DbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		If SC5->(DbSeek(xFilial("SC5")+ZZI->ZZI_NUM))

			Aadd(_aMail,{ZZI->ZZI_TIPO 	,ZZI->ZZI_NUM,'',''})
			Aadd(_aMail,{'Cliente' 		,ZZI->ZZI_CLIENT+'-'+ZZI->ZZI_LOJA,'',''})
			Aadd(_aMail,{'Nome' 		,ZZI->ZZI_NOMECL,'',''})
			Aadd(_aMail,{'Coordenador' 	,ZZI->ZZI_SUPER+' - '+Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_SUPER,"A3_NOME"),'',''})
			Aadd(_aMail,{'Vendedor 01' 	,ZZI->ZZI_VEND1+' - '+ZZI->ZZI_NVEND1,'',''})
			Aadd(_aMail,{'Vendedor 02' 	,ZZI->ZZI_VEND2+' - '+ZZI->ZZI_NVEND2,'',''})
			Aadd(_aMail,{'%Desconto' 	,Transform( ZZI->ZZI_DESC  ,"@E 999,999,999.99")+'%','',''})
			Aadd(_aMail,{'Obs.:' 	, Alltrim(ZZI->ZZI_OBSVEN),'',''})
			Aadd(_aMail,{'Historico:' 	, Alltrim(SC5->C5_XALCMSG),'',''})
			If ZZI->ZZI_REJEI = '1'
				Aadd(_aMail,{'Considerações,:' 	,Alltrim( ZZI->ZZI_MREJEI ),'',''})
			Else
				Aadd(_aMail,{'Considerações,:' 	,Alltrim( ZZI->ZZI_RASTRO ),'',''})
			EndIf
			If GetMv("ST_DES001",,.T.)
				ZZIMAIL(_aMail,;
					Alltrim(Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND1,"A3_EMAIL" ))+";"+ ;
					Alltrim(Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND2,"A3_EMAIL" ))+";"+ ;
					Alltrim(Posicione("SA3",1,xFilial("SA3")+Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND2,"A3_XSUPINT"),"A3_EMAIL" ))+";"+ ;
					Alltrim(Posicione("SA3",1,xFilial("SA3")+Posicione("SA3",1,xFilial("SA3")+ZZI->ZZI_VEND1,"A3_SUPER"),"A3_EMAIL" )))
			EndIf

		EndIf

        End Transaction 

	EndIf

Return()

Static Function ZZIMAIL(_aMsg,_cEmail,_cAssunto)

	Local _nLin := 0

	Local	_cAssunto := "Controle de Alçada de Desconto "+ZZI->ZZI_TIPO+": "+ ZZI->ZZI_NUM+' - '+ Iif(ZZI->ZZI_REJEI = '1',"Rejeitado","Aprovado")
	Local cFuncSent := "STTELALC"

	Default   _cEmail	  := "klecios.souza@steckgroup.com "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do cabecalho do email                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do texto/detalhe do email                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nLin := 1 to Len(_aMsg)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
		cMsg += '</TR>'
	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do rodape do email                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

	U_STMAILTES(_cEmail, '', _cAssunto, cMsg,,,' ')

Return()

Static Function CABALCX ()

	Local cVendNew    :=  ''
	Local cVendNew2   :=  ''
	Local cxVendNew2   :=  ''

	cVendNew    :=  SUA->UA_CONDPG
	cVendNew2   :=  SUA->UA_TPFRETE
	cxVendNew2   :=  SUA->UA_TRANSP

	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Orçamento: "+SUA->UA_NUM) From 1,0 To 16,25 OF oMainWnd

	@ 05,40 SAY Alltrim(SUA->UA_XDESBLQ) PIXEL OF oDlgEmail

	@ 05,04 SAY "Cond.Pag.:" PIXEL OF oDlgEmail
	@ 15,04 MSGet cVendNew 	 	F3 "SE4_01"  Size 35,012  PIXEL OF oDlgEmail Valid(  !(Empty(cVendNew)) .And. ExistCpo("SE4",cVendNew) )

	@ 05+30,04 SAY "Frete" PIXEL OF oDlgEmail
	@ 15+30,04 MSGet cVendNew2 	Picture "@!"  Size 35,012  PIXEL OF oDlgEmail Valid ( !(Empty(cVendNew2)))

	@ 05+60,04 SAY "Transp." PIXEL OF oDlgEmail
	@ 15+60,04 MSGet cxVendNew2 	 F3 "SA4"	  Size 35,012  PIXEL OF oDlgEmail Valid ( !(Empty(cXVendNew2)) .And. ExistCpo("SA4",cxVendNew2) )

	@ 053+45, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	@ 053+45, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel

	nOpca:=0

	ACTIVATE MSDIALOG oDlgEmail CENTERED

	If nOpca == 1
		If MsgYesno("Confirma a Liberação da COTAÇÃO: "+SUA->UA_NUM)
			SUA->(RecLock("SUA",.F.))
			SUA->UA_CONDPG  := cVendNew
			SUA->UA_XCONDPG := cVendNew
			SUA->UA_TPFRETE := cVendNew2
			SUA->UA_TRANSP  := cXVendNew2
			SUA->UA_XDESBLQ := ' '
			SUA->UA_XBLOQ 	:= "2"
			SUA->(MsUnLock())
			SUA->( DbCommit() )

			If cEmpAnt=="11" //Somente distribuidora

				xRetStatus := "2"  //LIBERADO
				_cRetorno  := ""
				lNectar    := .F.
				cUAXGUID   := SUA->UA_XGUID
				_cDataHora := FWTimeStamp( 6, Date(), Time())  //-> NIL //FWTimeStamp([ nType ], [ dDate ], [ cTime ])-> NIL
				cStatusEnv := ""

				_cRetorno := '{' +;
					'"nec_statusorcamento":' 	+ '"' 	+ xRetStatus      			+ '"' + ',' +;
					'"nec_motivodobloqueio":'	+ '"' 	+ Alltrim(SUA->UA_XDESBLQ)	+ '"' + ',' + ;
					'"statuscode": 279440003,'  +;
					'"nec_codigo_protheus":' 			+ '"' + SUA->UA_NUM + '"' + ','+ ;
					'"nec_orcamentoatualizadoem":' 		+ '"' + _cDataHora + '"' + ;
					'}'

				//Atualiza o cabeçalho da cotação:
				lNectar := U_PatchNectar(_cRetorno,cUAXGUID, "C")

				//atualiza tab temporária CABEÇALHO Z94
				If lNectar
					cStatusEnv := "1"  //0-não enviado; 1-enviado com Sucesso
				Else
					cStatusEnv := "0"
				Endif

				DbselectArea("Z94")
				Z94->(OrdSetFocus(2))  //Z94_XGUID
				If Z94->(Dbseek(cUAXGUID))
					If Reclock("Z94" , .F.)

						Z94->Z94_STENV  := cStatusEnv		//0=Não Enviado;1=Enviado com Sucesso
						Z94->Z94_STORC  := "O"

						If cStatusEnv <> "1"
							Z94->Z94_DTGRAV := Date()  //dta gravação
							Z94->Z94_HRGRAV := Time()  //hora gravação
						Else
							Z94->Z94_DTENVI:= Date()  //dta envio
							Z94->Z94_HRENVI:= Time()  //hora envio
						Endif

						Z94->(MsUnlock())

					Endif
				Endif

			EndIf
			//FR - 03/06/2022 - Flávia Rocha - Sigamat Consultoria - revisão do retorno para api da Nectar com status orçamento
        Else 
		   nOpca:=0
		Endif
	Endif

Return(nOpca)

Static Function ALTZZI()

	ZZI->(RecLock("ZZI",.F.))
	ZZI->ZZI_MREJEI :=  M->ZZI_MREJEI
	ZZI->ZZI_REJEI  :=  M->ZZI_REJEI
	ZZI->ZZI_BLQ    :=  IiF(ZZI->ZZI_REJEI = '1','3','1')
	ZZI->ZZI_USERAP := __cUserId+" - "+cUserName
	ZZI->ZZI_DTAPR  := dDataBase
	ZZI->ZZI_RASTRO := Alltrim(M->ZZI_RASTRO)
	ZZI->(MsUnlock())
	ZZI->( DbCommit() )

Return()

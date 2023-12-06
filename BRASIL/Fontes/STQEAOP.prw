#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STQETXT  ºAutor  ³RVG Solcuoes        º Data ³  18/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STQEAOP
Local _iB1
Local _aB1
//-- Pesquisa codigo do produto
DbSelectArea('SB1')
DbSetOrder(1)
If MSSeek( xFilial('SB1')+QEK->QEK_PRODUT   )
	//-- Valida Dados passados como parametro
	dDtPrIni := dDataBase
	dDtPrFim := dDataBase
	cTpOP    := 'F'
	cItemOp  := 'FT'
	cNumeroOp:= QEK->QEK_XFATEC
 	cSeqOP   := '001'          
 	_cProduto := QEK->QEK_PRODUT
	//-- Valida numero da Ordem de Producao
	DbSelectArea('SC2')
	DbSetOrder(1)
	While SC2->( MSSeek( xFilial('SC2') + cNumeroOP+cItemOP+cSeqOP ) )
		cNumeroOP:=GetNumSC2()
	End
	
	cRevisao := SB1->B1_REVATU
	cRoteiro :=  SB1->B1_OPERPAD
	
	//-- Monta array para utilizacao da Rotina Automatica
	aMata650  := {{'C2_NUM',cNumeroOp,NIL},;
	{'C2_ITEM'     ,cItemOp			,NIL},;
	{'C2_SEQUEN'   ,cSeqOP			,NIL},;
	{'C2_PRODUTO'  ,_cProduto		,NIL},;
	{'C2_LOCAL'    ,SB1->B1_LOCPAD			,NIL},;
	{'C2_QUANT'    ,QEK->QEK_TAMLOT	,NIL},;
	{'C2_UM'       ,SB1->B1_UM		,NIL},;
	{'C2_SEGUM'    ,SB1->B1_SEGUM	,NIL},;
	{'C2_DATPRI'   ,dDtPrIni		,NIL},;
	{'C2_DATPRF'   ,dDtPrFim		,NIL},;
	{'C2_REVI'     ,cRevisao		,NIL},;
	{'C2_TPOP'     ,cTpOP			,NIL},;
	{'AUTEXPLODE'  ,'N'				,NIL}}
	//-- Chamada da rotina automatica
	msExecAuto({|x,Y|Mata650(x,Y)},aMata650,3)
	//-- Verifica se houve algum erro
	If lmsErroAuto
		MsgStop("Erro na Abertura da OP, Veririque ")
	Else
		SB1->(DBSetOrder(1))
		SB1->(DBSeek(xFilial("SB1")+_cProduto ))
		_cDesc := SB1->B1_DESC
		_aB1 := {}
		For _iB1 :=1 to SB1->(fCount())
			AADD(_aB1,SB1->(FieldGet(_iB1)))
		Next
		
		// Cria o produto caso nao exista no SB1
		SB1->(DBSetOrder(1))
		If !SB1->(DBSeek(xFilial("SB1")+ALLTRIM(_cProduto)+"R"))
			SB1->(DBSeek(xFilial("SB1")+_cProduto))
			RecLock("SB1",.T.)
			For _iB1 :=1 to SB1->(fCount())
				If FieldName(_iB1)=="B1_COD"
					FieldPut(_iB1,ALLTRIM(_aB1[_iB1])+"R")
				ElseIf FieldName(_iB1)=="B1_DESC"
					FieldPut(_iB1,ALLTRIM(_aB1[_iB1])+" - RETRABALHO")
				ElseIf FieldName(_iB1)$"B1_LOCALIZ/B1_RASTRO"
					FieldPut(_iB1,"N")
				Else
					FieldPut(_iB1,_aB1[_iB1])
				EndIf
			Next
			MsUnlock()
		EndIf                       
		
		SB1->(DBSeek(xFilial("SB1")+_cProduto))
		
		If !a260Processa(SB1->B1_COD,SuperGetMV("ST_LCRTFTC",,"90"),QEK->QEK_TAMLOT,"FT"+QEK->QEK_XFATEC,dDataBase,QEK->QEK_TAMLOT,,,dDataBase+999, ,,SB1->B1_COD+"R",SuperGetMV("ST_LCRTFTC",,"90"), ,.F.,NIL,NIL,"MATA260",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,1)
			
			lRet := .F.
			cErro  := "ExecAuto"
			MostraErro()
			
		Endif

		dbSelectArea("SD4")
		RecLock("SD4",.T.)
		Replace D4_FILIAL  With xFilial("SD4")
		Replace D4_DATA    With DDATABASE
		Replace D4_COD     With ALLTRIM(_cProduto)+"R"
		Replace D4_LOCAL   With SuperGetMV("ST_LCRTFTC",,'90')
		Replace D4_QUANT   With QEK->QEK_TAMLOT
		Replace D4_QTDEORI With QEK->QEK_TAMLOT
		Replace D4_OP      With cItemOp+cNumeroOp+cSeqOP             

		MSUNLOCK()

	 	MsgStop("Foi aberta a OP "+ cNumeroOp + cItemOp + cSeqOp)

	EndIf

EndIf

                                  

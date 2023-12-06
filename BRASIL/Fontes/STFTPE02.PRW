#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTPE02  ºAutor  ³RGV Solcuoes        º Data ³  03/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Copia orcamento para outro Orcamento                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STFTPE02()
	
	if SCJ->CJ_STATUS = 'X'
		MsgInfo("Orçamento Liberado p/ Vendas...!!!!")
		Return()
	EndIf
	_cCodProd :=SPACE(TamSX3("B1_COD")[1])
	
	@ 096,042 TO 280,505 DIALOG oDlgX TITLE "Copia de Orcamento"
	@ 002,010 TO 066,222
	@ 015,020 SAY "Cod.Orcamento"
	@ 015,060 Get _cCodProd Picture "@!" SIZE 075,15  VALID NAOVAZIO()
	
	@ 075,0150 BMPBUTTON TYPE 1 ACTION   _fGrStru()
	@ 075,0180 BMPBUTTON TYPE 2 ACTION  oDlgX:End()
	
	
	ACTIVATE DIALOG oDlgX CENTERED
	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFTPE01  ºAutor  ³RGV Solucoes         º Data ³  03/03/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function _fGrStru
	Local _nPreco := 0
	Local nSE5 := 0
	oDlgX:End()
	
	
	_cQuery := "SELECT * FROM "+RetSqlName("SCK")+" WHERE D_E_L_E_T_ = '' AND CK_FILIAL = '"+XFilial("SCK")+"' "
	_cQuery += "AND CK_NUM = '"+_cCodProd+"' "
	_cQuery := ChangeQuery(_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TRB",.t.,.t.)
	aStruSE5:= SCK->(dbStruct())
	
	For nSE5 := 1 To Len(aStruSE5)
		If aStruSE5[nSE5][2] <> "C" .and.  FieldPos(aStruSE5[nSE5][1]) > 0
			TcSetField("TRB",aStruSE5[nSE5][1],aStruSE5[nSE5][2],aStruSE5[nSE5][3],aStruSE5[nSE5][4])
		EndIf
	Next nSE5
	
	dbSelectArea("TRB")
	
	
	_cLast := "00"
	
	Dbselectarea("SCK")
	Dbsetorder(1)
	Dbseek(xfilial("SCK")+SCJ->CJ_NUM)
	
	Do While !eof() .and. SCJ->CJ_NUM == SCK->CK_NUM
		_cLast:=SCK->CK_ITEM
		DbSkip()
	Enddo
	
	Dbselectarea("TRB")
	DbGoTop()
	
	Do While !eof()
		
		_cLast := SOMA1(_cLast)
		
		_nPreco := U_STRETSST('01',scj->cj_cliente , scj->cj_loja,TRB->CK_PRODUTO,scj->cj_Condpag,'PRECO')
		_nPreco := iif(_nPreco = Nil .Or. _nPreco == 0,0.01,_nPreco)
		
		
		DbSelectarea("SCK")
		RecLock("SCK",.T.)
		SCK->CK_FILIAL   	:= XFILIAL("SCK")
		SCK->CK_NUM   		:= SCJ->CJ_NUM
		SCK->CK_ITEM   		:= _cLast
		SCK->CK_PRODUTO		:= TRB->CK_PRODUTO
		SCK->CK_UM			:= TRB->CK_UM
		SCK->CK_QTDVEN		:= TRB->CK_QTDVEN
		SCK->CK_PRCVEN		:= _nPreco
		SCK->CK_TES         := TRB->CK_TES
		SCK->CK_VALOR		:= _nPreco*TRB->CK_QTDVEN
		SCK->CK_LOCAL		:= TRB->CK_LOCAL
		SCK->CK_DESCRI		:= TRB->CK_DESCRI
		SCK->CK_PRUNIT		:= _nPreco
		SCK->CK_CLIENTE 	:= scj->cj_cliente
		SCK->CK_LOJA    	:= scj->cj_loja
		SCK->CK_OBS			:= TRB->CK_OBS
		SCK->CK_XTP_PRD  	:= TRB->CK_XTP_PRD
		msunlock()
		
		Dbselectarea("TRB")
		DbSkip()
		
	Enddo
	
	MsgStop("Copia efetuada com sucesso !")
	
	Dbselectarea("TRB")
	DbClosearea("TRB")
	
Return


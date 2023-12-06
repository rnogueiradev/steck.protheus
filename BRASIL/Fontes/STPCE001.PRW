#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA650I   ºAutor  ³ RVG Solcuoes       º Data ³  05/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preencher automaticamente cadastro do produto de Retrabalhoº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STPCE001() // STeck PCp p.ENtrada seq 001
	
	Local _iB1:= 0
	
	_Alias := Alias()
	_nOrd  := IndexOrd()
	_nReg  := RecNo()
	
	DbSelectarea("SC2")
	_nOrdC2  := IndexOrd()
	_nRegC2  := RecNo()
	_cOp     := SC2->C2_NUM
	cProduto := SC2->C2_PRODUTO
	
	DbSelectArea("SC2")
	DbSetOrder(1)
	DbSeek(xFilial("SC2")+_cOp)
	
	IF SC2->C2_XRETRAB == '1'
		
		SB1->(DBSetOrder(1))
		SB1->(DBSeek(xFilial("SB1")+SC2->C2_PRODUTO ))
		_cDesc := SB1->B1_DESC
		_aB1 := {}
		For _iB1 :=1 to SB1->(fCount())
			AADD(_aB1,SB1->(FieldGet(_iB1)))
		Next
		
		// Cria o produto caso nao exista no SB1
		SB1->(DBSetOrder(1))
		If !SB1->(DBSeek(xFilial("SB1")+ALLTRIM(cProduto)+"R"))
			SB1->(DBSeek(xFilial("SB1")+cProduto))
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
	Endif
	
	
	// Chamado 005631 - Robson Mazzarotto
	dbSelectArea("SG1")
	dbSetOrder(1)
	dbGotop()
	
	if dbSeek(xFilial("SG1")+SC2->C2_PRODUTO)
		
		while !eof() .and. SG1->G1_COD == SC2->C2_PRODUTO
			
			if Posicione("SB1",1,xFilial("B1")+SG1->G1_COMP,"B1_MSBLQL") == '1'
				
				msgalert("O item "+SG1->G1_COMP+ "esta bloqueado, verifique!")
				
			Endif
			
			SG1->(dbSkip())
		End
		
	Endif
	
	
	
	DbSelectArea(_Alias)
	DbSetOrder(_nOrd)
	DbGoTo(_nReg)
	
Return

#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "COLORS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STCOM022     ºAutor  ³Joao Rinaldi    º Data ³  10/02/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função desenvolvida para retornar status dos campos        º±±
±±º          ³ listados a seguir:                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºCampos    ³ 1 - ZH_STATUS  - X3_INIBRW e X3_RELACAO                    º±±
±±º          ³ 2 - ZH_STATUS  - X3_RELACAO                                º±±
±±º          ³ 3 - C1_ZDESCCC - X3_INIBRW e X3_RELACAO                    º±±
±±º          ³ 4 - C1_ZSTATU2 - X3_INIBRW e X3_RELACAO                    º±±
±±º          ³ 5 - C1_ZANEXO  - X3_INIBRW e X3_RELACAO                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STCOM022(_cOpc,cAPROVP)
	
	Local aArea1      := GetArea()
	Local aArea2      := SC1->(GetArea())
	Local aArea3      := SZH->(GetArea())
	Local aArea4      := CTT->(GetArea())
	Local _cCod 	  := ''
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ X3_INIBRW e X3_RELACAO - Campo ZH_STATUS
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _cOpc == '1'
		DbSelectArea("SZH")
		SZH->(DbSetOrder(1))//ZH_FILIAL+ZH_APROVP
		SZH->(DbGoTop())
		If DbSeek(xFilial("SZH")+cAPROVP)
			If !EMPTY(ZH_APROVP).And. Empty(ZH_DTFIMAP)
				_cCod := '3-Bloqueado'
			ElseIf !EMPTY(ZH_APROVP) .And. ZH_DTFIMAP < dDatabase
				_cCod := '1-Inativo'
			ElseIf !EMPTY(ZH_APROVP).And. ZH_DTFIMAP >= dDatabase .And. ZH_DTFIMAS < dDatabase
				_cCod := '2-Ativo'
			ElseIf !EMPTY(ZH_APROVS).And. ZH_DTFIMAS >= dDatabase .And. ZH_DTFIMAP >= dDatabase
				_cCod := '4-Substituto'
			Endif
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ X3_RELACAO - Campo ZH_STATUS
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf _cOpc == '2'
		_cCod := '5-Novo Cadastro'
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ X3_INIBRW e X3_RELACAO - Campo C1_ZDESCCC
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf _cOpc == '3'
		
		If Type('Inclui') == 'L' .and. Inclui
			Return (_cCod)
		EndIf
		
		If (Type('aCols') == 'A') .and. (Type('N') == 'N') .and. (n > 0 ) .and. (n <= Len(aCols)) .and. (Len(aCols[1]) <> Len(aCols[n]))
			Return (_cCod)
		EndIf
		
		_cCod := Posicione("CTT",1,xFilial("CTT")+SC1->C1_CC,"CTT_DESC01")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ X3_INIBRW e X3_RELACAO - Campo C1_ZSTATU2
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf _cOpc == '4'
		
		If Type('Inclui') == 'L' .and. Inclui
			Return (_cCod)
		EndIf
		
		If (Type('aCols') == 'A') .and. (Type('N') == 'N') .and. (n > 0 ) .and. (n <= Len(aCols)) .and. (Len(aCols[1]) <> Len(aCols[n]))
			Return (_cCod)
		EndIf
		
		DbSelectArea("SZH")
		SZH->(DbSetOrder(1))//ZH_FILIAL+ZH_APROVP
		SZH->(DbGoTop())
		If DbSeek(xFilial("SZH")+cAPROVP)
			If !EMPTY(ZH_APROVP).And. Empty(ZH_DTFIMAP)
				_cCod := '3-Bloqueado'
			ElseIf !EMPTY(ZH_APROVP) .And. ZH_DTFIMAP < dDatabase
				_cCod := '1-Inativo'
			ElseIf !EMPTY(ZH_APROVP).And. ZH_DTFIMAP >= dDatabase .And. ZH_DTFIMAS < dDatabase
				_cCod := '2-Ativo'
			ElseIf !EMPTY(ZH_APROVS).And. ZH_DTFIMAS >= dDatabase .And. ZH_DTFIMAP >= dDatabase
				_cCod := '4-Substituto'
			Endif
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ X3_INIBRW e X3_RELACAO - Campo C1_ZANEXO
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf _cOpc == '5'
		If Type('Inclui') == 'L' .and. Inclui
			Return (_cCod)
		EndIf
		
		If (Type('aCols') == 'A') .and. (Type('N') == 'N') .and. (n > 0 ) .and. (n <= Len(aCols)) .and. (Len(aCols[1]) <> Len(aCols[n]))
			Return (_cCod)
		EndIf
		
		_cCod := (ADir("\arquivos\SC\"+cEmpAnt+"\"+cFilAnt+"\"+SC1->C1_NUM+"\*.MZP*"))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ X3_INIBRW e X3_RELACAO - Campo C1_ZNOMEAP
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf _cOpc == '6'
		If Type('Inclui') == 'L' .and. Inclui
			Return (_cCod)
		EndIf
		
		If (Type('aCols') == 'A') .and. (Type('N') == 'N') .and. (n > 0 ) .and. (n <= Len(aCols)) .and. (Len(aCols[1]) <> Len(aCols[n]))
			Return (_cCod)
		EndIf
		
		_cCod := USRRETNAME(SC1->C1_ZAPROV)
		
	Endif
	
	RestArea(aArea4)
	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)
	
Return (_cCod)


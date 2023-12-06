#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT381VLD   บAutor  ณJoao Rinaldi       บ Data ณ  11/09/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEste ponto de entrada utilizado para confirmar a grava็ใo   บฑฑ
ฑฑบ          ณdo Ajuste Empenho Modelo 2                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ MATA381.PRX                                                บฑฑ
ฑฑบNome      ณ Ajuste de Empenho Modelo 2                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MT381VLD

	Local _cItem     := ''
	Local lSaida     := .F.
	Local _aMotRej   := {}
	Local cGetMotivo := Space(100)
	Local nOpcao     := 0
	Local _cArea     := getarea()
	Local _cOp       := cOp //SD4->D4_OP Ticket 20191129000007 
	Local _lRet      := .T.
	Local _nK
	Local _nL
	Local _nA
	Local _nB
	Local _aDados   := {}
	Local _cDescri  := ""
	Local _cTipo    := ""
	Local _cUnidade := ""
	Local _cApropri := ""
	Local _nSld90   := 0
	Local _nEmp90   := 0
	Local _nEmpSDC  := 0
	Local _nEndTela := 0
	Local _nCheck   := 0
	Local aSize     := MsAdvSize(, .F., 400)
	Local aButtons  := {}
	Local cmenslog  := ""
	Private oListBox
	Private _aCampos  := {}
	Private _cAlias1  := GetNextAlias()
	Private _cAlias2  := GetNextAlias()
	Private _cQuery1  := ''
	Private _cQuery2  := ''
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณnOpc == 4 -> Op็ใo de Altera็ใo
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
	If l381Alt

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValida se estแ zerando empenho da OP acionado pela op็ใo 'Zera Emp.' (A381ZEmp)
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		If !(lZeraEmp2)
 	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValida็ใo para verificar se exsite Sequ๊ncia de Componente Repetida na OP
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 	
			For _nA := 1 to Len(aCols)
				For _nB := 1 to Len(aCols)
					If ((aCols[_nA][1] = aCols[_nB][1]) .And. (aCols[_nA][6] = aCols[_nB][6]) .And. (aCols[_nA][17] <> aCols[_nB][17]) .And. !(aCols[_nA][18]) .And. !(aCols[_nB][18]))
						_lRet := .F.
						MSGALERT( "O Componente "+Alltrim(aCols[_nA][1])+" estแ com a sequ๊ncia repetida mais de uma vez no empenho da Ordem de Produ็ใo...!!!"+ Chr(10) + Chr(13) +;
							Chr(10) + Chr(13) +;
							"Nใo ้ permitido para o mesmo Componente ter a sequ๊ncia repetida...!!!"+ Chr(10) + Chr(13)+;
							Chr(10) + Chr(13) +;
							"Favor ajustar a sequ๊ncia do Componente "+Alltrim(aCols[_nA][1])+"...!!!"+ Chr(10) + Chr(13),;
							"Sequ๊ncia de Componente Repetida")
						//Armazenar o log.
						cmenslog += "Sequ๊ncia de Componente Repetida -> O Componente "+Alltrim(aCols[_nA][1])+" estแ com a sequ๊ncia repetida mais de uma vez no empenho da Ordem de Produ็ใo...!!!"+ Chr(10) + Chr(13) +;
							Chr(10) + Chr(13) +;
							"Nใo ้ permitido para o mesmo Componente ter a sequ๊ncia repetida...!!!"+ Chr(10) + Chr(13)+;
							Chr(10) + Chr(13) +;
							"Favor ajustar a sequ๊ncia do Componente "+Alltrim(aCols[_nA][1])+"...!!! | "+ Chr(10) + Chr(13) 
						Exit
					Endif
				Next _nB
				If !_lRet
					Exit
				Endif
			Next _nA

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValida็ใo para verificar se existe diverg๊ncia entre os empenhos da Ordem de Produ็ใo e os empenhos do Endere็o no armaz้m 90
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
			If _lRet
				For _nK := 1 to Len(aCols)
					IF !(aCols[_nK][21])//Robson.Alterado para 20 posi็๕es devido a cria็ใo dos campos roteiro e opera็ใo ap๓s rodar o update UPDPCP32.
						If aCols[_nK][2] = '90'

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAnแlise dos dados do Cadastro do Produto	
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู							
							DbSelectarea("SB1")
							SB1->(DbSetOrder(1))//B1_FILIAL+B1_COD
							SB1->(DbGoTop())
							If SB1->(DbSeek(xFilial("SB1")+(aCols[_nK][1])))
								_cDescri  := SB1->B1_DESC
								_cTipo    := SB1->B1_TIPO
								_cUnidade := SB1->B1_UM
								_cApropri := SB1->B1_APROPRI
							Endif
							DO CASE
							CASE _cApropri = "D"
								_cApropri := "Direta"
							CASE _cApropri = "I"
							ENDCASE

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAvalia as informa็๕es somente para produtos de Apropria็ใo Direta 
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู				
							If _cApropri = "D"

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAnแlise dos dados de Saldos por Endere็o
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู				
								DbSelectarea("SBF")
								SBF->(DbSetOrder(1))//BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE
								SBF->(DbGoTop())
								If SBF->(DbSeek(xFilial("SBF")+(aCols[_nK][2])+'PRODUCAO'+ Space(7)+(aCols[_nK][1])))
									_nSld90    := SBF->BF_QUANT
									_nEmp90    := SBF->BF_EMPENHO
								Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAnแlise dos dados de Composi็ใo de Empenho
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู				
								DbSelectarea("SDC")
								SDC->(DbSetOrder(2))//DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI
								SDC->(DbGoTop())
								If SDC->(DbSeek(xFilial("SDC")+(aCols[_nK][1])+(aCols[_nK][2])+(_cOp)+(aCols[_nK][6])))
									While SDC->(! Eof() .and. SDC->(DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT) == (xFilial('SDC')+(aCols[_nK][1])+(aCols[_nK][2])+(_cOp)+(aCols[_nK][6])))
										_nEmpSDC    := _nEmpSDC+SDC->DC_QUANT
										SDC->(DbSkip())
									End
								Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAnแlise dos dados de Endere็os que o usuแrio alterou na Tela acionado pela op็ใo 'Endere็os' (a381Ender)
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู				
								For _nL := 1 to Len(aEnderecos)
									If (aCols[_nK][1]) = aEnderecos[_nL][10] .And. (aCols[_nK][2]) = aEnderecos[_nL][11] .And. !(aEnderecos[_nL][7])
										_nEndTela := _nEndTela+aEnderecos[_nL][4]
									Endif
								Next _nL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica็ใo entre os empenhos na SDC e os ajustados na tela acionado pela op็ใo 'Endere็os' (a381Ender)
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู					
								If _nEndTela > 0
									If _nEndTela == _nEmpSDC
										_nCheck := _nEndTela
									ElseIf _nEndTela > _nEmpSDC
										_nCheck := _nEndTela
									ElseIf (aCols[_nK][5]) == _nEndTela
										_nCheck := _nEndTela
									Else
										_nCheck := _nEndTela
									Endif
								Else
									_nCheck := _nEmpSDC
								Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do Array
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
								If _nCheck <> (aCols[_nK][5])
									Aadd(_aDados,{	(aCols[_nK][1]),;
										(aCols[_nK][6]),;
										_cDescri,;
										_cTipo,;
										_cUnidade,;
										_cApropri,;
										(aCols[_nK][5]),;
										_nCheck,;
										(aCols[_nK][2])})
								Endif
							Endif
						Endif
					Endif
					
					//Validar se o saldo do emepnho estแ maior que o saldo do estoque.

					nQtdVldEmp := 0
					If (_nEmp90 - aCols[_nK][5]) > 0
						nQtdVldEmp := (_nEmp90 - aCols[_nK][5]) + _nCheck
					Else
						nQtdVldEmp := _nEmp90  + _nCheck
					Endif
					
					if nQtdVldEmp > _nSld90
						MsgStop("O Empenho ficarแ maior que o saldo do armaz้m 90, nใo serแ possํvel fazer a altera็ใo.","Empenho maior que o saldo")
						_lRet := .F.
						exit
					EndIf 

					_nSld90    := 0
					_nEmp90    := 0
					_nEmpSDC   := 0
					_nEndTela  := 0
					_nCheck    := 0
				Next _nK
		
				If Len (_aDados) > 0
					_lRet := .F.
					MSGSTOP( "Existem diverg๊ncias entre os empenhos da Ordem de Produ็ใo e os empenhos do Endere็o no armaz้m 90...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor verificar na tela que serแ exibida a seguir os componentes com diverg๊ncia...!!!"+ Chr(10) + Chr(13)+;
						Chr(10) + Chr(13) +;
						"Com o c๓digo dos componentes, clique em 'A็๕es Relacionadas' e depois em 'Endere็os' e realize o devido ajuste...!!!"+ Chr(10) + Chr(13)+;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
						"Diverg๊ncia de Empenho")

					//Armazenar o log.	
					cmenslog += "Diverg๊ncia de Empenho-> Existem diverg๊ncias entre os empenhos da Ordem de Produ็ใo e os empenhos do Endere็o no armaz้m 90...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor verificar na tela que serแ exibida a seguir os componentes com diverg๊ncia...!!!"+ Chr(10) + Chr(13)+;
						Chr(10) + Chr(13) +;
						"Com o c๓digo dos componentes, clique em 'A็๕es Relacionadas' e depois em 'Endere็os' e realize o devido ajuste...!!!"+ Chr(10) + Chr(13)+;
						Chr(10) + Chr(13) +;
						"Favor Verificar ...!!!"+ Chr(10) + Chr(13)

					Define MSDialog oDlgCons Title "Consulta de Itens de Apropria็ใo Direta Divergentes refente a Ordem de Produ็ใo: "+_cOp From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel

					@ 45, 05 LISTBOX oListBox VAR nPosLbx FIELDS HEADER "C๓digo","Sequ๊ncia","Descri็ใo","Tipo","Unidade","Apropria็ใo","Empenho OP","Empenho Endere็o","Armaz้m" SIZE 440,150 OF oDlgCons PIXEL NOSCROLL

					oListBox:SetArray(_aDados)
					oListBox:bLine := { ||{_aDados[oListBox:nAT][1],;
						_aDados[oListBox:nAT][2],;
						_aDados[oListBox:nAT][3],;
						_aDados[oListBox:nAT][4],;
						_aDados[oListBox:nAT][5],;
						_aDados[oListBox:nAT][6],;
						_aDados[oListBox:nAT][7],;
						_aDados[oListBox:nAT][8],;
						_aDados[oListBox:nAT][9]}}
					oListBox:blDblClick := {|| _aDados[ oListBox:nAt, 01] ,oDlgCons:End()}
					oListBox:Align := CONTROL_ALIGN_ALLCLIENT // Retorno da pesquisa em tela cheia
					oListBox:Refresh()
	
					ACTIVATE MSDIALOG oDlgCons ON INIT EnchoiceBar(oDlgCons,{|| nOpca := 1,oDlgCons:End() },{||oDlgCons:End()},,aButtons)
			//giovani zago 17/02/2020 nao entendi esta msg fora de contesto.
					//MSGSTOP( "A altera็ใo de empenho nใo serแ confirmada enquanto nใo houver o ajuste entre os empenhos da Ordem de Produ็ใo e os empenhos do Endere็o no armaz้m 90...!!!"+ Chr(10) + Chr(13) +;
					//	Chr(10) + Chr(13) +;
					//	"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
					//	"Diverg๊ncia de Empenho")
				Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณNใo havendo nenhum bloqueio das valida็๕es, ้ apresentada a tela para informar o motivo da altera็ใo de empenho e para gravar as altera็๕es realizadas na tabela ZZ4
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
				If _lRet
					AADD(_aMotRej,' ')
					DbSelectArea("SX5")
					SX5->(dbSetOrder(1))
					SX5->(dbSeek(xFilial("SX5") + 'Z2'))
					Do While SX5->(!EOF()) .and. xFilial("SX5") = SX5->X5_FILIAL .And. SX5->X5_TABELA  = 'Z2'
						AADD(_aMotRej,ALLTRIM(SX5->X5_CHAVE)+' - '+ALLTRIM(SX5->X5_DESCRI))
						SX5->(DbSkip())
					EndDo

					Do While !lSaida
						nOpcao := 0
	
						Define msDialog oDxlg Title "Informar Motivo Altera็ใo de Empenho" From 10,10 TO 250,400 Pixel
	
						@ 010,010 say "OP: " COLOR CLR_BLACK  Of oDxlg Pixel
						@ 010,050 get _cOp   when .f. size 060,08  Of oDxlg Pixel
	
						@ 030,010 say "Observa็ใo da Altera็ใo de Empenho:" COLOR CLR_HBLUE  Of oDxlg Pixel
						@ 040,010 get cGetMotivo  size 165,08  Of oDxlg Pixel
	
						@ 060,010 Say "Motivo da Altera็ใo de Empenho:"   COLOR CLR_HBLUE  Of oDxlg Pixel
						@ 070,010 COMBOBOX _cItem ITEMS _aMotRej SIZE 165,08 Of oDxlg Pixel
	
						@ 100,085 Button "OK"    Size 28,12 Action Eval({||IF(!empty(alltrim(_cItem)),(lSaida:=.T.,nOpcao:=1,oDxlg:End()),msgInfo("Motivo da Altera็ใo de Empenho nใo preenchido","Aten็ใo"))}) OF oDxlg Pixel
	
						Activate Dialog oDxlg Centered
	
					EndDo
					cmenslog += "Motivo da Altera็ใo do Empenho->" + _cOp + "-" +_cItem  +"-" +  cGetMotivo

					Processa({||AltOPMail('',' ',cusername,dtoc(date()),time(),' ',_cOp,_cItem,cGetMotivo),"Enviando E-mail... " })
					Processa({||GRAVAZZ4(cusername,dtoc(date()),time(),_cOp,_cItem,cGetMotivo, _aCampos),"Atualizando Registros... " })
				Endif
			Endif
		ElseIf	MsgYesNo("Os empenhos da Ordem de Produ็ใo serใo encerrados e dessa forma essa Ordem de Produ็ใo nใo mais poderแ ser utilizada...!!!"+ Chr(10) + Chr(13) +;
				Chr(10) + Chr(13) +;
				"Deseja Confirmar a limpeza dos empenhos da Ordem de Produ็ใo??")
			_lRet:= .T.

			cmenslog += "Zerar Empenhos-> Os empenhos da Ordem de Produ็ใo serใo encerrados e dessa forma essa Ordem de Produ็ใo nใo mais poderแ ser utilizada...!!!"+ Chr(10) + Chr(13) 
		Else
			_lRet:= .F.
		Endif
	Endif

	If !Empty(Alltrim(cmenslog)) .Or. _lRet
		//Gravar log de movimenta็ใo da OP.
		cProdOp := Posicione("SC2",1,xFilial("SC2") + _cOp,"C2_PRODUTO")
		aRetLog:=U_STKGLGOP("",_cOp,cProdOp,__cUserID,+SubStr(cUsuario, 7, 15),DDataBase,Time(),Funname(),;
				cmenslog,cmenslog,"3",/*dDatFimMv*/,/*cHorFimMv*/,/*cRotFimMv*/)
	Endif
	RestArea(_cArea)

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT381VLD   บAutor  ณJoao Rinaldi       บ Data ณ  11/09/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para verificar os campos que foram alterados no acolsบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ MATA381.PRX                                                บฑฑ
ฑฑบNome      ณ Ajuste de Empenho Modelo 2                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VALIDSD4()

	Local aArea    := GetArea()
	Local aAreaSD4 := SD4->(GetArea())
	Local aCampos  := {}
	Local lRet     := .T.
	Local _aCols2  := {}
	Local _cAlias  := "SD4"
	Local _cStatus := ""
	Local _nI
	Local _nJ
 
	For _nI := 1 to Len(aCols)
			
		SD4->(DbGoto(aCols[_nI][20]))//Recno
		
		DbSelectArea("SX3")
		SX3->(DbGoTop())
		SX3->(DbSetOrder(1))
		SX3->(DbSeek("SD4"))
      	
		While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="SD4"
			For _nJ := 1 to Len(aHeader)
				If ((aHeader[_nJ][2]) == (SX3->X3_CAMPO))
					If  !(aCols[_nI][_nJ]  ==  &("SD4->"+SX3->X3_CAMPO)) .Or. (aCols[_nI][21])//Conte๚do
						DO CASE
						CASE (aCols[_nI][20]) = 0
							_cStatus := "Novo Registro"
						CASE (aCols[_nI][21])
							_cStatus := "Registro Deletado"
						CASE !(aCols[_nI][_nJ]  ==  &("SD4->"+SX3->X3_CAMPO))
							_cStatus := "Registro Alterado"
						ENDCASE
						
						DO CASE
						CASE AllTrim(SX3->X3_TIPO )=="C"
                                      //Recno          ,C๓d do Produto ,Campo SX3        ,Descrica็ใo SX3  ,Conte๚do Antigo            ,Novo Conte๚do                             ,Status	  ,Tipo SX3						
							aadd(_aCampos,{(aCols[_nI][20]),(aCols[_nI][1]),(aHeader[_nJ][2]),(aHeader[_nJ][1]),(&("SD4->"+SX3->X3_CAMPO)),IIF(!(aCols[_nI][20]),(aCols[_nI][_nJ]),""),_cStatus,(aHeader[_nJ][8])})
						CASE AllTrim(SX3->X3_TIPO )=="N"
							aadd(_aCampos,{(aCols[_nI][20]),(aCols[_nI][1]),(aHeader[_nJ][2]),(aHeader[_nJ][1]),(CVALTOCHAR(&("SD4->"+SX3->X3_CAMPO))),IIF(!(aCols[_nI][20]),(CVALTOCHAR(aCols[_nI][_nJ])),""),_cStatus,(aHeader[_nJ][8])})
						CASE AllTrim(SX3->X3_TIPO )=="D"
							aadd(_aCampos,{(aCols[_nI][20]),(aCols[_nI][1]),(aHeader[_nJ][2]),(aHeader[_nJ][1]),(DTOC(&("SD4->"+SX3->X3_CAMPO))),IIF(!(aCols[_nI][20]),(DTOC(aCols[_nI][_nJ])),""),_cStatus,(aHeader[_nJ][8])})
						ENDCASE
					EndIf
				Endif
			Next _nJ
			SX3->(DbSkip())
		EndDo
	Next _nI
     
	RestArea(aAreaSD4)
	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltOPMail  บAutor  ณJoao Rinaldi       บ Data ณ  11/09/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para envio de e-mail                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ MATA381.PRX                                                บฑฑ
ฑฑบNome      ณ Ajuste de Empenho Modelo 2                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AltOPMail(_cObs,_cMot,_cName,_cDat,_cHora,_cxEmail,_cOp,_cItem,cGetMotivo)

	Local aArea 	  := GetArea()
	Local _cAssunto := 'Altera็ใo de Empenho: '+Alltrim(_cOp) +' - Na empresa: '+ cEmpAnt+' - Usuแrio: '+_cName + ' - Dia: '+_cDat+' เs: '+_cHora
	Local cFuncSent := "AltOPMail"
	Local _aMsg     :={}
	Local cMsg      := ""
	Local _cEmail   := ""//SuperGetMV("ST_MAILOP",.F.,"joao.rinaldi@steck.com.br")
	Local _cCopia   := GetMV("ST_MAILOP",.F.,"joao.rinaldi@steck.com.br")
	Local cAttach   := ''
	Local _nLin

	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos  := PswRet()
		_cEmail := _aGrupos[1][14]
	Endif
	
			
	VALIDSD4()
	Aadd( _aMsg , {"Registro","Produto","Campo","Descri็ใo","Alterado De","Alterado Para","Status"} )
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Definicao do cabecalho do email                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + '</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<TR>'
	cMsg += '<TH><FONT COLOR=#000000 FACE= "ARIAL" SIZE=5 Align=Centered>'+_cItem+'</FONT></TH>'
	cMsg += '</TR>'
	cMsg += '<TR>'
	cMsg += '<TH><FONT COLOR=#000000 FACE= "ARIAL" SIZE=5 Align=Centered>'+cGetMotivo+'</FONT></TH>'
	cMsg += '</TR>'
	cMsg += '<TR>'
	cMsg += '<TH><FONT COLOR=#000000 FACE= "ARIAL" SIZE=5 Align=Centered>'+_cAssunto+'</FONT></TH>'
	cMsg += '</TR>'
	cMsg += '</Table>'
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Definicao do texto/detalhe do email                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(_aCampos) > 0
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<TR BgColor=#FFFFFF>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,1] + ' </Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,2] + ' </Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,3] + ' </Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,4] + ' </Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,5] + ' </Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,6] + ' </Font></B></TD>'
		cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">' + _aMsg[1,7] + ' </Font></B></TD>'

		For _nLin := 1 to Len(_aCampos)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#66FF66>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF

			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cvaltochar(_aCampos[_nLin,1]) + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aCampos[_nLin,2] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aCampos[_nLin,3] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aCampos[_nLin,4] + ' </Font></TD>'
		
			If ValType(_aCampos[_nLin,1]) = "C"
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aCampos[_nLin,5] + ' </Font></TD>'
			ElseIf ValType(_aCampos[_nLin,1]) = "N"
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cvaltochar(_aCampos[_nLin,5]) + ' </Font></TD>'
			Else
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aCampos[_nLin,5] + ' </Font></TD>'
			Endif
		
			If ValType(_aCampos[_nLin,1]) = "C"
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aCampos[_nLin,6] + ' </Font></TD>'
			ElseIf ValType(_aCampos[_nLin,1]) = "N"
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cvaltochar(_aCampos[_nLin,6]) + ' </Font></TD>'
			Else
				cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aCampos[_nLin,6] + ' </Font></TD>'
			Endif
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aCampos[_nLin,7] + ' </Font></TD>'
			cMsg += '</TR>'
		
		Next
	Else
		//cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">Altera็ใo de empenho realizada sem inclusใo, altera็ใo ou exclusใo de componentes...!!!<font color="red" size="1"></td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
	Endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Definicao do rodape do email                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
	
	If !(  U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach) )
		MsgInfo("Email nใo Enviado..!!!!")
	EndIf

	RestArea(aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGRAVAZZ4   บAutor  ณJoao Rinaldi       บ Data ณ  11/09/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para gravar as altera็๕es de empenho na tabela ZZ4   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ MATA381.PRX                                                บฑฑ
ฑฑบNome      ณ Ajuste de Empenho Modelo 2                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GRAVAZZ4(_cName,_cDat,_cHora,_cOp,_cItem,cGetMotivo, _aCampos)

	Local _nI
	Local _cSeq := ''

	_cQuery2 := " SELECT MAX(R_E_C_N_O_) AS REGISTRO
	_cQuery2 += " FROM "+RetSqlName("ZZ4")+" ZZ4 "
	_cQuery2 += " WHERE ZZ4.D_E_L_E_T_ = ' '
	_cQuery2 += " AND ZZ4_TABELA = 'SD4'

	If Select(_cAlias2) > 0
		(_cAlias2)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery2),_cAlias2)

	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbGoTop())
	
	dbSelectArea("ZZ4")
	ZZ4->(DbSetOrder(1))//ZZ4_FILIAL+ZZ4_TABELA+ZZ4_SEQUEN
	ZZ4->(dbGoTop())
	ZZ4->(DbGoTo((_cAlias2)->REGISTRO))//Recno
	
	_cSeq    := Soma1(ZZ4->ZZ4_SEQUEN,TamSX3("ZZ4_SEQUEN")[1])
		
	If Len (_aCampos) > 0
		For _nI := 1 to Len(_aCampos)
			DbSelectArea('ZZ4')
			ZZ4->(DbSetOrder(1))//ZZ4_FILIAL+ZZ4_TABELA+ZZ4_SEQUEN
			ZZ4->(RecLock("ZZ4",.T.))

			ZZ4->ZZ4_FILIAL := xFilial("SD4")
			ZZ4->ZZ4_TABELA := "SD4"
			ZZ4->ZZ4_CAMPO  := _aCampos[_nI][3]
			ZZ4->ZZ4_DESCRI := _aCampos[_nI][4]
			ZZ4->ZZ4_TIPO   := _aCampos[_nI][8]
			ZZ4->ZZ4_RECNO  := _aCampos[_nI][1]
			ZZ4->ZZ4_REG01  := "C๓digo de Produto: "+_aCampos[_nI][2]
			ZZ4->ZZ4_REG02  := "Ordem de Produ็ใo: "+_cOp
			ZZ4->ZZ4_DE     := _aCampos[_nI][5]
			ZZ4->ZZ4_PARA   := _aCampos[_nI][6]
			ZZ4->ZZ4_STATUS := _aCampos[_nI][7]
			ZZ4->ZZ4_MOTIVO := cGetMotivo
			ZZ4->ZZ4_OBS    := _cItem
			ZZ4->ZZ4_USER   := _cName
			ZZ4->ZZ4_DATA   := CTOD(_cDat)
			ZZ4->ZZ4_HORA   := _cHora
			ZZ4->ZZ4_SEQUEN := _cSeq
	
			ZZ4->(Msunlock())
			ZZ4->(DbCommit())
		Next _nI
	Endif

Return

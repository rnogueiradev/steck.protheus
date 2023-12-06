#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STMAILC5 ³ Autor ³ Renato Nogueira		      	 								   ³ Data ³ 12/02/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Enviar e-mail quando pedido não for PA					                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil																											³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cliente   ³ Steck						  																 			 		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STMAILC5()
 
	Local _aArea		:= GetArea()
	Local _nX			:= 0
	Local _nPosProd	:= 0
	Local _lEnvMail	:= .F.
	Local _cEmail   := ""
	Local _cCopia   := ""
	Local _cAssunto := ''
	Local cMsg	    := ""
	Local cAttach   := ''
	Local _aAttach  := {}
	Local _cCaminho := ''		
	//>>Chamado 006759 - Everson Santana - 09.02.2018
	Local _aEmailEX := {}
	Local _cExport	:= ''
	Local _lOrigem	:= .F.
	Local _nPosQtdVen := 0
	Local _nY			:= 0
	_cExport			:= M->C5_TIPOCLI
	_cNum  			:= M->C5_NUM
	_nPosQtdVen		:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_QTDVEN"})
	//<<Chamado 006759
	
	_nPosProd  		:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})
	
		For _nX:=1 To Len(aCols)

		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())
		
		If SB1->(DbSeek(xFilial("SB1")+aCols[_nX][_nPosProd]))
		
			If AllTrim(SB1->B1_TIPO)<>"PA"
		
				_lEnvMail	:= .T.
		
			EndIf
			
			//>>Chamado 006759
			If Alltrim(SB1->B1_ORIGEM) == "1"
				_lOrigem := .T.
			EndIf
			
			If _lOrigem .and. _cExport $ 'EX'
			
			Aadd(_aEmailEX,{_cNum,aCols[_nX][_nPosProd],SB1->B1_DESC,aCols[_nX][_nPosQtdVen]})
			
			EndIf
			//<<Chamado 006759
		EndIf

	Next
	
	If _lEnvMail
	
		_cEmail	  := GetMv("ST_MAILPCP")
		
		_cAssunto := 'Pedido '+AllTrim(M->C5_NUM)+' Filial '+cFilAnt+' diferente de origem PA'
		
		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
	
		If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			MsgInfo("Problemas no envio de email!")
		EndIf

	EndIf
	
	//>> Chamado 006759
	If _lOrigem .and. _cExport $ 'EX'
	
		_cEmail	  := GetMv("ST_MAILPCP")
		
		_cAssunto := 'Pedido de exportação '+AllTrim(M->C5_NUM)+' Filial '+cFilAnt+' com origem importação'
		
		cMsg := ""
		cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
		cMsg += '<body>'
		cMsg += '<form action="mailto:%WFMailTo%" method="POST" name="formulario"> '
		cMsg += '<table>'
		cMsg += '<tbody>'
		cMsg += '<tr>'
		cMsg += '<td align="left"   height="21" width="015"><span class="style1"><b>'
		cMsg += '<span style="font-size: 10pt;">Pedido</span></b></span></td>'
		cMsg += '<td align="left"   height="21" width="015"><span class="style1"><b>'
		cMsg += '<span style="font-size: 10pt;">Codigo</span></b></span></td>'
		cMsg += '<td align="left"   height="21" width="200"><span class="style1"><b>'
		cMsg += '<span style="font-size: 10pt;">Produto</span></b></span></td>'
		cMsg += '<td align="left"   height="21" width="030"><span class="style1"><b>'
		cMsg += '<span style="font-size: 10pt;">Quantidade</span></b></span></td>'
		cMsg += '</tr>'
		cMsg += '</tbody>'
		cMsg += '<tbody>'				
		
		For _nY := 1 To Len(_aEmailEX)
		
						cMsg += '<tr>'
						cMsg += '<td align="left"   height="21" width="015"><span><b>'
						cMsg += '<span style="font-size: 8pt;">'+_aEmailEX[_nY][01]+'</span></b></span></td>'
						cMsg += '<td align="left"   height="21" width="015"><span><b>'
						cMsg += '<span style="font-size: 8pt;">'+_aEmailEX[_nY][02]+'</span></b></span></td>'
						cMsg += '<td align="left"   height="21" width="200"><span ><b>'
						cMsg += '<span style="font-size: 8pt;">'+_aEmailEX[_nY][03]+'</span></b></span></td>'
						cMsg += '<td align="left"   height="21" width="030"><span><b>'
						cMsg += '<span style="font-size: 8pt;">'+Transform(_aEmailEX[_nY][04],"@E 999,999,999")+'</span></b></span></td>'
						cMsg += '</tr>'
		
		
		Next _nY 
		
		cMsg += '</tbody>'
		cMsg += '</table>'
		cMsg += '</body>'
			
		If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			MsgInfo("Problemas no envio de email!")
		EndIf

	EndIf
	//<< Chamado 006759
	
	RestArea(_aArea)
 
Return
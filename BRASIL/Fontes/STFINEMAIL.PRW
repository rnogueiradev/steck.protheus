#INCLUDE "RWMAKE.CH"
#Include "Colors.ch"
#include 'Protheus.ch'

#Define CR chr(13)+chr(10)



/*====================================================================================\
|Programa  | STFINEMAIL       | Autor | GIOVANI.ZAGO             | Data | 09/04/2013  |
|=====================================================================================|
|Descrição | STFINEMAIL                                                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STFINEMAIL                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STFINEMAIL(cPedido)
	*-----------------------------*
	
	Local aSC6Area	  := SC6->(GetArea())
	Local aArea		  := GetArea()
	Local aSC5Area	  := SC5->(GetArea())
	Local n           := 0
	Local j          := 0
	Local k          := 0
	Local lSaida      := .f.
	Local cGetMotivo  := space(90)
	Local nOpcao      := 0
	Local oDxlg
	Local _cAne01  	  :=space(90)
	Local _cAne02  	  :=space(90)
	Local _cAne03     :=space(90)
	Local _cAne04     :=space(90)
	Local _cAne05     :=space(90)
	Local aDirs1      := {}
	Local aDirs2      := {}
	Local aDirs3      := {}
	Local aDirs4      := {}
	Local aDirs5      := {}
	Local cDir        := ''
	Local _aDirs      := {}
	Local cGetCoppi   :=space(90)
	Private _aDest    :={}
	PRIVATE cStartPath := "\anexos\"
	
	
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5")+cPedido))
		
		
		
		Do While !lSaida
			nOpcao := 0
			
			Define msDialog oDxlg Title "Selecione os Anexos " From 10,10 TO 450,600 Pixel
			
			
			@ 005,010 say "Pedido  " COLOR CLR_BLACK  Of oDxlg Pixel
			@ 015,010 say "Cliente " COLOR CLR_BLACK  Of oDxlg Pixel
			
			@ 005,050 get cPedido  when .f. size 050,08  Of oDxlg Pixel
			@ 015,050 get SA1->A1_COD when .f. size 120,08  Of oDxlg Pixel
			
			@ 030,010 say "Enviar Copia:" COLOR CLR_HBLUE  Of oDxlg Pixel
			@ 040,010 get cGetCoppi  size 165,08  Of oDxlg Pixel
			
			@ 055,010 say "Observação Para o Financeiro" COLOR CLR_HBLUE  Of oDxlg Pixel
			@ 065,010 get cGetMotivo valid !empty(cGetMotivo) size 165,08  Of oDxlg Pixel
			
			
			@ 082,010 Say "Anexo - 01"   COLOR CLR_HBLUE  Of oDxlg Pixel
			@ 090,010 get _cAne01     when .f.   size 165,08  Of oDxlg Pixel
			@ 090,180 BUTTON 'Anexar' SIZE 30,10 ACTION (_cAne01:=xsttela(),oDxlg:End())  Of oDxlg Pixel
			@ 090,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne01:=space(90),oDxlg:End()) Of oDxlg Pixel
			
			
			@ 102,010 Say "Anexo - 02"   COLOR CLR_HBLUE  Of oDxlg Pixel
			@ 110,010 get _cAne02     when .f.   size 165,08  Of oDxlg Pixel
			@ 110,180 BUTTON 'Anexar' SIZE 30,10 ACTION (_cAne02:=xsttela(),oDxlg:End())  Of oDxlg Pixel
			@ 110,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne02:=space(90),oDxlg:End()) Of oDxlg Pixel
			
			@ 122,010 Say "Anexo - 03"   COLOR CLR_HBLUE  Of oDxlg Pixel
			@ 130,010 get _cAne03     when .f.   size 165,08  Of oDxlg Pixel
			@ 130,180 BUTTON 'Anexar' SIZE 30,10 ACTION (_cAne03:=xsttela(),oDxlg:End())  Of oDxlg Pixel
			@ 130,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne03:=space(90),oDxlg:End()) Of oDxlg Pixel
			
			@ 142,010 Say "Anexo - 04"   COLOR CLR_HBLUE  Of oDxlg Pixel
			@ 150,010 get _cAne04     when .f.   size 165,08  Of oDxlg Pixel
			@ 150,180 BUTTON 'Anexar' SIZE 30,10 ACTION (_cAne04:=xsttela(),oDxlg:End())  Of oDxlg Pixel
			@ 150,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne04:=space(90),oDxlg:End()) Of oDxlg Pixel
			
			@ 162,010 Say "Anexo - 05"   COLOR CLR_HBLUE  Of oDxlg Pixel
			@ 170,010 get _cAne05     when .f.   size 165,08  Of oDxlg Pixel
			@ 170,180 BUTTON 'Anexar' SIZE 30,10 ACTION (_cAne05:=xsttela(),oDxlg:End())  Of oDxlg Pixel
			@ 170,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne05:=space(90),oDxlg:End()) Of oDxlg Pixel
			
			
			
			DEFINE SBUTTON FROM 200,130 TYPE 1 ACTION IF(!empty(cGetMotivo),(lSaida:=.T.,nOpcao:=1,oDxlg:End()),msgInfo("Observação do pedido não preenchido","Atenção")) ENABLE OF oDxlg
			DEFINE SBUTTON FROM 200,160 TYPE 2 ACTION (lSaida:=.T.,nOpcao:=2,oDxlg:End()) ENABLE OF oDxlg
			
			Activate dialog oDxlg centered
			
		EndDo
		
		If nOpcao == 1
			
			If !Empty(Alltrim(_cAne01))
				aadd(_aDest,_cAne01 )
			EndIf
			If !Empty(Alltrim(_cAne02))
				aadd(_aDest,_cAne02 )
			EndIf
			If !Empty(Alltrim(_cAne03))
				aadd(_aDest,_cAne03 )
			EndIf
			If !Empty(Alltrim(_cAne04))
				aadd(_aDest,_cAne04 )
			EndIf
			If !Empty(Alltrim(_cAne05))
				aadd(_aDest,_cAne05 )
			EndIf
			
			for j:=1 To Len(_aDest)
				
				If j = 1
					aDirs1:=separa(  _aDest[j],'\',.T.)
				ElseIf j = 2
					aDirs2:=separa(  _aDest[j],'\',.T.)
				ElseIf j = 3
					aDirs3:=separa(  _aDest[j],'\',.T.)
				ElseIf j = 4
					aDirs4:=separa(  _aDest[j],'\',.T.)
				ElseIf j = 5
					aDirs5:=separa(  _aDest[j],'\',.T.)
				EndIf
			next j
			
			If Len(aDirs1) > 0
				For j := 1 To Len(aDirs1)
					cDir:=allTrim(aDirs1[j])
				next
				aadd(_aDirs,cDir)
			EndIf
			If Len(aDirs2) > 0
				For j := 1 To Len(aDirs2)
					cDir:=allTrim(aDirs2[j])
				next
				aadd(_aDirs,cDir)
			EndIf
			If Len(aDirs3) > 0
				For j := 1 To Len(aDirs3)
					cDir:=allTrim(aDirs3[j])
				next
				aadd(_aDirs,cDir)
			EndIf
			If Len(aDirs4) > 0
				For j := 1 To Len(aDirs4)
					cDir:=allTrim(aDirs4[j])
				next
				aadd(_aDirs,cDir)
			EndIf
			If Len(aDirs5) > 0
				For j := 1 To Len(aDirs5)
					cDir:=allTrim(aDirs5[j])
				next
				aadd(_aDirs,cDir)
			EndIf
			
			For k:=1 To Len(_aDest)
				FERASE(cStartPath+_aDirs[k])
				CpyT2S( _aDest[k],cStartPath, .T. )
			next k
			
			StFatMail(alltrim(cGetMotivo),cusername,SC5->C5_ZDTREJE,time(),Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_EMAIL"))+';'+cGetCoppi,_aDirs,cStartPath)
			
		EndIf
		
	EndIf
	
	
	
	RestArea(aSC5Area)
	RestArea(aSC6Area)
	RestArea(aArea)
Return()



/*====================================================================================\
|Programa  | StFatMail        | Autor | GIOVANI.ZAGO             | Data | 27/03/2013  |
|=====================================================================================|
|Descrição | StFatMail                                                                |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | StFatMail                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*------------------------------------------------------------------*
Static Function  StFatMail(_cObs,_cName,_cDat,_cHora,_cEmail,_aAnexo,_cCaminho)
	*------------------------------------------------------------------*
	
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= 'Faturamento - Anexos do Pedido de Venda ('+SC5->C5_NUM +')'
	Local cFuncSent:= "StFatMail"
	Local _aMsg    :={}
	Local i        := 0
	Local h        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := _cEmail//"    davi.souza@steck.com.br"
	
	
	_cEmail:="  davi.souza@steck.com.br"
	
	
	If __cuserid = '000000'
		_cEmail  :=''
		_cObs    :='Teste de envio de email favor desconsiderar e-mail'
	EndIf
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		
		Aadd( _aMsg , { "Pedido: "          , SC5->C5_NUM } )
		Aadd( _aMsg , { "Cond. Pgto.: "     , SC5->C5_CONDPAG } )
		Aadd( _aMsg , { "Cliente - Loja: "  , SC5->C5_CLIENTE+' - '+SC5->C5_LOJACLI } )
		Aadd( _aMsg , { "Nome Cliente: "    , substr(Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"),1,35)  } )
		Aadd( _aMsg , { "Dt. Emissão : "    , DTOC(SC5->C5_EMISSAO)})
		
		If !Empty(Alltrim(	SC5->C5_ZMOTREJ))
			Aadd( _aMsg , { "Dt. Rejeição: "    , dtoc(_cDat)  } )
			Aadd( _aMsg , { "Mot. Rejeição: "   , alltrim(	SC5->C5_ZMOTREJ)  } )
		EndIf
		Aadd( _aMsg , { "Vendedor: "    	, _cName } )
		Aadd( _aMsg , { "Observação Vendedor: " , _cObs  } )
		Aadd( _aMsg , { "Data/Hora: "    		, dtoc(date())+'    --    '+_cHora } )
		For h:=1 To Len(_aAnexo)
			Aadd( _aMsg , { "Anexo - ("+cvaltochar(h)+")"    		, _aAnexo[h] } )
		Next h
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
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
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'
		
		
		If !(   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAnexo,_cCaminho) )
			MsgInfo("Email não Enviado..!!!!")
		EndIf
	EndIf
	RestArea(aArea)
Return()


Static Function xsttela()
	Local _cxCaminho:=cGetFile("Todos os Arquivos","*.*",,"c:\",,,.f.)
Return(_cxCaminho)

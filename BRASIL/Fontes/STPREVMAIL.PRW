#INCLUDE "RWMAKE.CH"
#Include "Colors.ch"
#Include "TOPCONN.CH"
#include 'Protheus.ch'

/*====================================================================================\
|Programa  | STPREVMAIL          | Autor | GIOVANI.ZAGO          | Data | 15/05/2014  |
|=====================================================================================|
|DescriГЦo | Email de previsao de chegada de produtos                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPREVMAIL                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................HistСrico....................................|
\====================================================================================*/

*-------------------------------*
User Function STPREVMAIL()
	*-------------------------------*
	
	
	Private _cProdprv := Space(15)
	Private _nQuant  := 0
	Private _dDat    := ddatabase
	Private _aResul  := {}
	
	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Email PrevisЦo") From 1,0 To 17,25 OF oMainWnd
	
	@ 08,04 SAY "Produto:" PIXEL OF oDlgEmail
	@ 15,04 MSGet _cProdprv 	F3 'SB1'	  Size 58,012  PIXEL OF oDlgEmail Valid ((existcpo("SB1",_cProdprv))  )
	@ 33,04 SAY "Quantidade:" PIXEL OF oDlgEmail
	@ 40,04 MSGet _nQuant 	Picture '@E 999,999,999'	  Size 58,012  PIXEL OF oDlgEmail Valid _nQuant > 0
	@ 58,04 SAY "Data Chegada:" PIXEL OF oDlgEmail
	@ 65,04 MSGet _dDat 	  Size 40,012  PIXEL OF oDlgEmail Valid _dDat >= ddatabase
	
	@ 085, 05 Button "Enviar"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	@ 085, 67 Button "Cancela"   Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel
	nOpca:=0
	
	ACTIVATE MSDIALOG oDlgEmail CENTERED
	
	If nOpca == 1
		
		STENVPREV()
		If Len (_aResul) >0
			Msginfo("teste")
			STMAIPREV()
		Endif
	Endif
	
return()



/*====================================================================================\
|Programa  | STENVPREV           | Autor | GIOVANI.ZAGO          | Data | 14/01/2013  |
|=====================================================================================|
|DescriГЦo |  Processa o Envio de email                                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STENVPREV                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................HistСrico....................................|
\====================================================================================*/

*---------------------------*
Static Function STENVPREV()
	*---------------------------*
	Local _aArea	:= GetArea()
	Local cAliasLif  := 'TMPB2'
	Local cQuery     := ' '
	
	
	cQuery := " SELECT
	cQuery += " C5_CLIENTE
	cQuery += ' "CLIENTE",
	cQuery += " C5_LOJACLI
	cQuery += ' "LOJA",
	cQuery += " C5_XNOME
	cQuery += ' "NOME",
	cQuery += " C5_NUM
	cQuery += ' "NUMERO",
	cQuery += " C5_XORDEM
	cQuery += ' "ORDEM",
	cQuery += " SUM(PA1_QUANT)
	cQuery += ' "QTD",
	cQuery += " C5_XPRIORI
	cQuery += ' "PRIORIDADE",
	cQuery += "  CASE WHEN C5_VEND2 <> ' ' THEN C5_VEND2 ELSE  C5_VEND1 END
	cQuery += ' "VENDEDOR",
	cQuery += "   NVL((SELECT A3_NOME FROM "+RetSqlName("SA3")+" SA3 "
	cQuery += "   WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += "   AND SA3.A3_COD = C5_VEND2
	cQuery += "   AND SA3.A3_FILIAL = ' ' ),
	cQuery += "   NVL((SELECT A3_NOME FROM "+RetSqlName("SA3")+" SA3 "
	cQuery += "   WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += "   AND SA3.A3_COD = C5_VEND1
	cQuery += "   AND SA3.A3_FILIAL = ' ' ),' ') )
	cQuery += '   "NVEND",
	cQuery += "  NVL((SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" SA3 "
	cQuery += "   WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += "   AND SA3.A3_COD = C5_VEND2
	cQuery += "   AND SA3.A3_FILIAL = ' ' ),
	cQuery += "  NVL((SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" SA3 "
	cQuery += "   WHERE SA3.D_E_L_E_T_ = ' '
	cQuery += "   AND SA3.A3_COD = C5_VEND1
	cQuery += "   AND SA3.A3_FILIAL = ' ' ),' ') )
	cQuery += '   "EMAIL"
	
	cQuery += " FROM "+RetSqlName("SC5")+" SC5 "
	
	
	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("PA1")+" ) PA1 "
	cQuery += " ON PA1.D_E_L_E_T_ = ' '
	cQuery += " AND PA1.PA1_FILIAL = SC5.C5_FILIAL
	cQuery += " AND PA1.PA1_CODPRO  = '"+_cProdprv+"'
	cQuery += " AND SUBSTR(PA1_DOC,1,6) = SC5.C5_NUM
	cQuery += " AND PA1.PA1_TIPO = '1'
	
	cQuery += " WHERE SC5.D_E_L_E_T_ =  ' '
	cQuery += " AND   SC5.C5_FILIAL  = '"+xFilial("SC5")+"'"
	cQuery += " AND SC5.C5_TIPOCLI <> 'X'
	
	cQuery += " GROUP BY C5_NUM,C5_XORDEM,C5_XPRIORI,C5_VEND2,C5_VEND1,C5_CLIENTE,C5_LOJACLI,C5_XNOME
	cQuery += " ORDER BY SC5.C5_XPRIORI
	
	
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		While (cAliasLif)->(!Eof())
			aadd(	_aResul,{ (cAliasLif)->CLIENTE   ,;
				(cAliasLif)->LOJA   ,;
				(cAliasLif)->NUMERO  ,;
				(cAliasLif)->QTD   ,;
				(cAliasLif)->PRIORIDADE  ,;
				(cAliasLif)->VENDEDOR  , ;
				(cAliasLif)->NVEND  ,;
				(cAliasLif)->EMAIL  ,;
				(cAliasLif)->ORDEM  ;
				})
			
			
			(cAliasLif)->(DbSkip())
		End
	EndIf
	
Return()


/*====================================================================================\
|Programa  | STMAIPREV           | Autor | GIOVANI.ZAGO          | Data | 14/01/2013  |
|=====================================================================================|
|DescriГЦo |  Processa o Envio de email                                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STMAIPREV                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................HistСrico....................................|
\====================================================================================*/

*---------------------------*
Static Function STMAIPREV()
	*---------------------------*
	Local _nSoQuan  := 0
	Local k:=1
	
	
	For k:=1 To Len(_aResul)
		
		If _nSoQuan <= _aResul[k,4]
			
			MailPrev(k)
			
		EndIf
		
		_nSoQuan+=_aResul[k,4]
		
	Next k
	
	
Return()
/*====================================================================================\
|Programa  | MailPrev         | Autor | GIOVANI.ZAGO             | Data | 27/03/2013  |
|=====================================================================================|
|DescriГЦo | MailPrev                                                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MailPrev                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................HistСrico....................................|
\====================================================================================*/
*------------------------------------------------------------------*
Static Function  MailPrev(f)
	*------------------------------------------------------------------*
	
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Faturamento -PrevisЦo de Chegada.('+_cProdprv+')'
	Local cFuncSent:= "MailPrev"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ' '
	Local cAttach  := ''
	
	If __cuserid = '000000'
		_cAssunto:= "TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR"
	EndIf
	_cEmail  := _aResul[f,8]

	// Valdemir Rabelo 20/08/2020 - ticket N╨ 20200609002790 
	_cCopia += "filipe.nascimento@steck.com.br;bruno.galvao@steck.com.br"	

	// Valdemir Rabelo 20/08/2020 - ticket N╨ 20200609002790 
	cVend := Posicione("SA1",1,xFilial("SA1")+_aResul[f,1]+_aResul[f,2],"A1_VEND")
	IF !EMPTY(cVend)
		cTMP := Posicione("SA3",1,xFilial("SA3")+cVend, "A3_EMAIL")
		if !Empty(cTMP)
			_cEmail += ","+cTMP
		Endif		   
	Endif	
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		
		Aadd( _aMsg , { "Pedido: "          , _aResul[f,3]} )
		Aadd( _aMsg , { "Ordem: "          , _aResul[f,9]} )
		Aadd( _aMsg , { "Cliente - Loja: "  , _aResul[f,1]+' - '+_aResul[f,2] } )
		Aadd( _aMsg , { "Nome Cliente: "    , substr(Posicione("SA1",1,xFilial("SA1")+_aResul[f,1]+_aResul[f,2],"A1_NOME"),1,35)  } )
		Aadd( _aMsg , { "Vendedor : "    , _aResul[f,6]})
		Aadd( _aMsg , { "Nome Vendedor: "    , _aResul[f,7]  } )
		Aadd( _aMsg , { "Produto:"    	, _cProdprv } )
		Aadd( _aMsg , { "Quantidade: "    		, transform((_aResul[f,4])	,"@E 99,999,999,999")  } )
		Aadd( _aMsg , { "PrevisЦo:"    	, Dtoc(_dDat) } )
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do cabecalho do email                                             Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do texto/detalhe do email                                         Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Definicao do rodape do email                                                Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'
		
		
		    U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)  
		 
	EndIf
	RestArea(aArea)
Return()




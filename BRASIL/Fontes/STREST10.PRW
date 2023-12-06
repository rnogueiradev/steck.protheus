#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

/*====================================================================================\
|Programa  | STREST10        | Autor | RENATO.OLIVEIRA           | Data | 27/08/2018  |
|=====================================================================================|
|Descrição | ROTINA PARA CONSULTAR PEDIDOS DE VENDA	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSRESTFUL conspedido DESCRIPTION "Consultar pedido de venda"

WSDATA cPed As String

WSMETHOD GET DESCRIPTION "Consultar pedido de venda" WSSYNTAX "/html-protheus/rest"

END WSRESTFUL

/*====================================================================================\
|Programa  | conspedido      | Autor | RENATO.OLIVEIRA           | Data | 27/08/2018  |
|=====================================================================================|
|Descrição | ROTINA PARA CONSULTAR PEDIDOS DE VENDA	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSMETHOD GET WSRECEIVE cPed WSSERVICE conspedido

	Local cRet 		:= ""
	Local cPedido 	:= Decode64(Self:cPed)
	Local _cQuery1 	:= ""
	Local _cAlias1	:= ""
	Local _cQuery2 	:= ""
	Local _cAlias2	:= ""
	Local _cQuery3 	:= ""
	Local _cAlias3	:= ""
	Local _nX
	//Private _cEndereco:= "http://www.appstk.com.br"
	Private _cEndereco:= ""

	::SetContentType("text/html")

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	Conout(cFilAnt)

	_cAlias3	:= GetNextAlias()

	_cQuery3 := " SELECT A1_CGC
	_cQuery3 += " FROM "+RetSqlName("SC5")+" C5
	_cQuery3 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery3 += " ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI
	_cQuery3 += " WHERE C5.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND C5_FILIAL='02'
	_cQuery3 += " AND C5_NUM='"+cPedido+"'

	If !Empty(Select(_cAlias3))
		DbSelectArea(_cAlias3)
		(_cAlias3)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

	dbSelectArea(_cAlias3)
	(_cAlias3)->(dbGoTop())

	If (_cAlias3)->(!Eof())

		_aCnpjs := U_STFAT440(AllTrim(HTTPHEADER('email')))

		If Len(_aCnpjs)>0
			_lAchou := .F.
			For _nX:=1 To Len(_aCnpjs)
				If AllTrim(_aCnpjs[_nX])==AllTrim((_cAlias3)->A1_CGC)
					_lAchou := .T.
				EndIf
			Next
			If !_lAchou
				::SetResponse("Nao autorizado visualizacao deste pedido para este login")
				Return .T.
			EndIf
		Else
			If Len(AllTrim(HTTPHEADER('login')))==8
				If !SubStr((_cAlias3)->A1_CGC,1,8)==AllTrim(HTTPHEADER('login'))
				::SetResponse("Nao autorizado visualizacao deste pedido para este login")
				Return .T.
				EndIf
			Else
				If !(_cAlias3)->A1_CGC==AllTrim(HTTPHEADER('login'))
				::SetResponse("Nao autorizado visualizacao deste pedido para este login")
				Return .T.
				EndIf
			EndIf
		EndIf

	EndIf

	_cEndereco := GetMv("ST_WSPRT01",,"https://protheusportal.000webhostapp.com")

	_cAlias1	:= GetNextAlias()
	_cAlias2	:= GetNextAlias()

	_cQuery1 += " SELECT C5_FILIAL, C5_NUM, A1_NOME, E4_DESCRI, C6_ITEM, B1_COD, B1_DESC, C6_QTDVEN, E4_CODIGO
	_cQuery1 += " ,C5_ZNUMPC, A4_NOME, C5_TPFRETE, C6_NUMPCOM, C6_ITEMPC, A7_CODCLI, C6_ENTRE1, C6_ZENTRE2, C6_ENTREG
	_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC6")+" C6
	_cQuery1 += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI
	_cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" B1
	_cQuery1 += " ON B1_COD=C6_PRODUTO
	_cQuery1 += " LEFT JOIN "+RetSqlName("SE4")+" E4
	_cQuery1 += " ON E4_CODIGO=C5_CONDPAG
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA4")+" A4
	_cQuery1 += " ON A4_COD=C5_TRANSP AND A4.D_E_L_E_T_=' ' 
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA7")+" A7
	_cQuery1 += " ON A7_CLIENTE=A1_COD AND A7_LOJA=A1_LOJA AND A7_PRODUTO=C6_PRODUTO AND A7.D_E_L_E_T_=' ' 
	_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND E4.D_E_L_E_T_=' '  
	_cQuery1 += " AND C5_FILIAL='01' AND C5_NUM='"+cPedido+"'
	_cQuery1 += " ORDER BY C6_ITEM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		::SetResponse("Pedido não encontrado!")
		Return .T.
	EndIf

	cRet += ' <html>
	cRet += ' <head>
	//cRet += '   <meta name="viewport" content="width=device-width, initial-scale=1.0">
	//cRet += '   <meta http-equiv="X-UA-Compatible" content="ie=edge">
	cRet += '   <script src="'+_cEndereco+'/js/utils.js"></script>
	//cRet += '   <script src="'+_cEndereco+'/portal_cliente/js/tether.js"></script>
	cRet += '   <script src="'+_cEndereco+'/js/tether.min.js"></script>
	cRet += '   <script src="'+_cEndereco+'/js/popper.min.js"></script>
	cRet += '   <script src="'+_cEndereco+'/js/jquery-3.3.1.min.js"></script>
	cRet += '   <script src="'+_cEndereco+'/js/bootstrap.min.js"></script>
	cRet += '   <script src="'+_cEndereco+'/js/login.js"></script>
	cRet += '   <link href="'+_cEndereco+'/css/bootstrap.min.css" rel="stylesheet" type="text/css" rel="stylesheet" media="screen" />
	cRet += '   <link rel="stylesheet" type="text/css">
	cRet += '   </head>
	cRet += ' <title>stkComercial</title>
	cRet += ' <body>
	cRet += ' <tbody>
	cRet += ' 
	//cRet += ' <div class="container-fluid">
	cRet += ' <div class="container">
	cRet += ' 
	cRet += ' <div class="table-responsive">
	cRet += ' 
	cRet += '   <table border="2" bordercolor="black" class="table">
	cRet += '     <thead>
	//cRet += '       <tr bgcolor="#FF7256">
	cRet += '       <tr>
	cRet += '         <td colspan="2" scope="col"><center><img src="'+_cEndereco+'/imagens/steck.jpg"></center>
	//cRet += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	cRet += '</td>
	cRet += '       </tr>
	cRet += '       <tr>
	cRet += '         <td><b>Pedido:</b> '+(_cAlias1)->C5_NUM+'</td>
	cRet += '         <td><b>Ordem de compra:</b> '+(_cAlias1)->C5_ZNUMPC+'</td>
	cRet += '         <tr>
	cRet += '           <td><b>Cliente:</b> '+(_cAlias1)->A1_NOME+'</td>
	cRet += '           <td><b>Frete:</b> '+GETDESC1((_cAlias1)->C5_TPFRETE)+'</td>
	cRet += '           <tr>
	cRet += '             <td><b>Condicao de pagamento:</b> '+(_cAlias1)->E4_CODIGO+" - "+(_cAlias1)->E4_DESCRI+'</td>
	cRet += '             <td><b>Transportadora:</b> '+(_cAlias1)->A4_NOME+'</td>
	cRet += '           </tr>
	cRet += '     </thead>
	cRet += ' </div>
	cRet += ' 
	cRet += ' <div class="table-responsive">
	cRet += ' <table border="2" bordercolor="black" class="table table-sm">
	cRet += '   <thead>
	cRet += '     <tr>
	cRet += '       <td scope="col"><b><center>Item</center></b></td>
	cRet += '       <td scope="col"><b>Codigo</b></td>
	cRet += '       <td scope="col"><b>Descricao</b></td>
	cRet += '       <td scope="col"><b>Cod. Cliente</b></td>
	cRet += '       <td scope="col"><b><center>Total</center></b></td>
	cRet += '       <td scope="col"><b>Ped. Compra</b></td>
	cRet += '       <td scope="col"><b>Item Ped.</b></td>
	cRet += '       <td scope="col"><b>Faturamento previsto</b></td>
	cRet += '     </tr>
	cRet += '   </thead>
	cRet += '   <tbody>

	DbSelectArea("SC5")
	SC5->(DbSeek(xFilial("SC5")+cPedido))

	nDiasTra := U_STFATCC2(.T.,"PEDIDO")				
	nDiasFin := GetNewPar("STDIASFIN",2)
	nDiasCom := GetNewPar("STDIASCOM",0)
	nDiasLog := GetNewPar("STDIASLOG",4)
	nDiasExp := GetNewPar("STDIASEXP",2)

	While (_cAlias1)->(!Eof())

	cRet += '     <tr bgcolor="#FF6347">
	cRet += '       <th><center>'+(_cAlias1)->C6_ITEM+'</center></th>
	cRet += '       <td>'+AllTrim((_cAlias1)->B1_COD)+'</td>
	cRet += '       <td>'+AllTrim((_cAlias1)->B1_DESC)+'</td>
	cRet += '       <td>'+AllTrim((_cAlias1)->A7_CODCLI)+'</td>
	cRet += '       <td><center>'+CVALTOCHAR((_cAlias1)->C6_QTDVEN)+'</center></td>
	cRet += '       <td>'+AllTrim((_cAlias1)->C6_NUMPCOM)+'</td>
	cRet += '       <td>'+AllTrim((_cAlias1)->C6_ITEMPC)+'</td>

	If nDiasTra > 0

		dPrazoEnt     := Ctod("  /  /    ")

		nTotPrazo := nDiasTra + nDiasFin + nDiasCom + nDiasLog + nDiasExp

		dPrazoEnt   := DataValida(IIF(EMPTY((_cAlias1)->C6_ZENTRE2),STOD((_cAlias1)->C6_ENTREG),STOD((_cAlias1)->C6_ZENTRE2)))

		fr := 2
		While fr <= nTotPrazo
			//vai somando de 1 em 1 e vendo se cai sábado ou domingo, então adiciona sempre mais um dia até ficar dia útil 
			dPrazoEnt := DataValida(dPrazoEnt + 1)
			fr++										
		Enddo

		dPrazoEnt := DataValida(dPrazoEnt)

		cRet += '       <td>'+DTOC(dPrazoEnt)+'</td>

	Else

		cRet += '       <td>S/Cadast.TransiT Time</td>

	EndIf

	cRet += '     </tr>

	_cQuery2 := " SELECT C9_ORDSEP, C9_NFISCAL, C9_QTDLIB, C9_BLEST, C9_BLCRED, NVL(CB8_SALDOS,0) CB8_SALDOS, NVL(CB8_SALDOE,0) CB8_SALDOE, NVL(CB8_QTDORI,0) CB8_QTDORI
	_cQuery2 += " ,NVL(F2_EMISSAO,' ') F2_EMISSAO, NVL(F2_CHVNFE,' ') F2_CHVNFE 
	_cQuery2 += " FROM "+RetSqlName("SC9")+" C9
	_cQuery2 += " LEFT JOIN "+RetSqlName("CB8")+" CB8
	_cQuery2 += " ON CB8_FILIAL=C9_FILIAL AND CB8_ORDSEP=C9_ORDSEP AND C9_ITEM=CB8_ITEM AND CB8.D_E_L_E_T_=' '
	_cQuery2 += " LEFT JOIN "+RetSqlName("SF2")+" F2
	_cQuery2 += " ON F2_FILIAL=C9_FILIAL AND F2_DOC=C9_NFISCAL AND F2_SERIE=C9_SERIENF AND F2_CLIENTE=C9_CLIENTE AND F2_LOJA=C9_LOJA AND F2.D_E_L_E_T_=' '  
	_cQuery2 += " WHERE C9.D_E_L_E_T_=' ' AND C9_FILIAL='"+(_cAlias1)->C5_FILIAL+"' 
	_cQuery2 += " AND C9_PEDIDO='"+(_cAlias1)->C5_NUM+"' AND C9_ITEM='"+(_cAlias1)->C6_ITEM+"'  

		If !Empty(Select(_cAlias2))
	DbSelectArea(_cAlias2)
	(_cAlias2)->(dbCloseArea())
		Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbGoTop())
	
	_lPrim := .T.

		While (_cAlias2)->(!Eof())
	
			If _lPrim
	cRet += '     <tr bgcolor="#DCDCDC">
	cRet += '       <td colspan="2"><center><font color="gray"><b>Ordem de Separacao</b></font></center></td>
	cRet += '       <td colspan="2"><center><font color="gray"><b>Nota Fiscal</b></font></center></td>
	cRet += '       <td><center><font color="gray"><b>Qtde</b></font></center></td>
	cRet += '       <td><center><font color="gray"><b>Data faturamento</b></font></center></td>
	cRet += '       <td colspan="2"><center><font color="gray"><b>Status</b></font></center></td>
	cRet += ' 	  </tr>
	_lPrim := .F.
			EndIf
	
	cRet += '     <tr bgcolor="#DCDCDC">
	cRet += '       <td colspan="2"><center>'+AllTrim((_cAlias2)->C9_ORDSEP)+'</center></td>
	cRet += '       <td colspan="2"><center><a href="'+_cEndereco+'/download_danfe.php?cChave='+(_cAlias2)->F2_CHVNFE+'&cTipo=2 target="_blank">'+AllTrim((_cAlias2)->C9_NFISCAL)+'</a></center></td>
	cRet += '       <td><center>'+AllTrim(CVALTOCHAR((_cAlias2)->C9_QTDLIB))+'</center></td>
	cRet += '       <td><center>'+DTOC(STOD((_cAlias2)->F2_EMISSAO))+'</center></td>
	cRet += '       <td colspan="3"><center>'+GETSTATUS((_cAlias2)->C9_ORDSEP,(_cAlias2)->C9_NFISCAL,(_cAlias2)->C9_BLEST,(_cAlias2)->C9_BLCRED,(_cAlias2)->CB8_SALDOS,(_cAlias2)->CB8_SALDOE,(_cAlias2)->CB8_QTDORI)+'</center></td>
	cRet += '     </tr>

	(_cAlias2)->(DbSkip())
		EndDo

	(_cAlias1)->(DbSkip())
	EndDo

	cRet += '     </tbody>
	cRet += '     <table>
	cRet += '     </div>
	cRet += '     </div>
	cRet += ' </body>
	cRet += ' </html>

	::SetResponse(cRet)

	Return .T.

	/*====================================================================================\
	|Programa  | GETSTATUS      | Autor | RENATO.OLIVEIRA           | Data | 27/08/2018   |
	|=====================================================================================|
	|Descrição | RETORNA STATUS DO ITEM					                                  |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | 		                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/	

Static Function GETSTATUS(_cOrdSep,_cNF,_cEst,_cFin,_nSep,_nEmb,_nOri)

	Local _cRetorno := ""

	_cEst 		:= AllTrim(_cEst)
	_cFin 		:= AllTrim(_cFin)
	_cOrdSep	:= AllTrim(_cOrdSep)
	_cNF		:= AllTrim(_cNF)

	Do Case

	Case _cEst$"09#04#01" //Bloqueado no financeiro
	_cRetorno := '<img src="'+_cEndereco+'/imagens/leg_preto.png"> - Bloqueado no financeiro'
	Case _cEst=="02" //Bloqueado no estoque
	_cRetorno := '<img src="'+_cEndereco+'/imagens/leg_preto.png"> - Bloqueado no estoque'
	Case !Empty(_cNF)
	_cRetorno := '<img src="'+_cEndereco+'/imagens/leg_verde.png"> - Faturado'
	Case !Empty(_cOrdSep)
		If _nOri>_nSep .And. _nSep>0
	_cRetorno := '<img src="'+_cEndereco+'/imagens/leg_azul.png"> - Separando'
		ElseIf _nOri>_nEmb .And. _nEmb>0
	_cRetorno := '<img src="'+_cEndereco+'/imagens/leg_azul.png"> - Embalando'
		ElseIf _nEmb==0
	_cRetorno := '<img src="'+_cEndereco+'/imagens/leg_azul.png"> - Embalado'
		ElseIf _nSep==0
	_cRetorno := '<img src="'+_cEndereco+'/imagens/leg_azul.png"> - Separado'
		Else
	_cRetorno := '<img src="'+_cEndereco+'/imagens/leg_azul.png"> - Aguardando separacao'
		EndIf
	Case Empty(_cOrdSep)
	_cRetorno := '<img src="'+_cEndereco+'/imagens/leg_vermelho.png"> - Aguardando separacao'
	EndCase

	Return(_cRetorno)

	/*====================================================================================\
	|Programa  | GETDESC1       | Autor | RENATO.OLIVEIRA           | Data | 27/08/2018   |
	|=====================================================================================|
	|Descrição | RETORNA DESCRICAO DO FRETE				                                  |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | 		                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/		

Static Function GETDESC1(_cTpFrete)

	Local _cDesc := ""

	_cTpFrete := AllTrim(_cTpFrete)

	Do case
	Case _cTpFrete=="C"
	_cDesc := "CIF"
	Case _cTpFrete=="F"
	_cDesc := "FOB"
	Case _cTpFrete=="T"
	_cDesc := "Por conta de terceiros"
	Case _cTpFrete=="S"
	_cDesc := "Sem frete"
	EndCase

	Return(_cDesc)

#INCLUDE "APWEBSRV.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"
#INCLUDE "fileio.ch"

#DEFINE ENTER CHAR(13) + CHAR(10)

/*====================================================================================\
|Programa  | WSPRTCLI         | Autor | Renato Nogueira            | Data | 16/11/2016|
|=====================================================================================|
|Descrição | Webservice para realizar as comunicações com o portal do cliente         |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck..                                                    	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSSERVICE WSPRTCLI DESCRIPTION "Serviço para comunicações com o portal do cliente"

	WSDATA _cLogin		AS STRING
	WSDATA _cPassword	AS STRING
	WSDATA _cPassword2	AS STRING
	WSDATA lRetorno  	AS BOOLEAN
	WSDATA _cXml  		AS STRING
	WSDATA _cChave 		AS STRING
	WSDATA _cBoleto 	AS STRING
	WSDATA _cEmail		AS STRING
	WSDATA _cEmail1		AS STRING
	WSDATA _cNome		AS STRING
	WSDATA _cXmlRec		AS STRING
	WSDATA _cIP			AS STRING
	WSDATA _cTipo 		AS STRING
	WSDATA _cOrc		AS STRING
	WSDATA _cRotina		AS STRING
	WSDATA _cCliente	AS STRING
	WSDATA _cSenha		AS STRING
	WSDATA _cProd		AS STRING

	WSMETHOD Logar DESCRIPTION "Método que retorna se o usuário e senha estão corretos"
	WSMETHOD GetPeds DESCRIPTION "Método que retorna os pedidos do cliente"
	WSMETHOD GetSolics DESCRIPTION "Método que retorna as solicitações de mkt do cliente"
	WSMETHOD GetOrcs DESCRIPTION "Método que retorna os orçamentos do cliente"
	WSMETHOD GetNfs DESCRIPTION "Método que retorna as notas do cliente"
	WSMETHOD BaixaNf DESCRIPTION "Método que baixa nota fiscal"
	WSMETHOD EnviaSenha DESCRIPTION "Método para reenviar senha ao cliente"
	WSMETHOD ListaBoletos DESCRIPTION "Método para listar os boletos"
	WSMETHOD EnviaBoleto DESCRIPTION "Método para enviar boleto por email"
	WSMETHOD AlteraSenha DESCRIPTION "Método para alterar senha do cliente"
	WSMETHOD GetSb1 DESCRIPTION "Método para retornar produtos"
	WSMETHOD GetSa4 DESCRIPTION "Método para retornar transportadoras"
	WSMETHOD CalculaPed DESCRIPTION "Método para calcular o valor do pedido de venda"
	WSMETHOD ConsultaPrz DESCRIPTION "Método para consultar disponibilidade dos produtos"
	WSMETHOD GetOrc DESCRIPTION "Método para retornar orçamento"
	WSMETHOD InserePed DESCRIPTION "Método para inserir pedido de venda"
	WSMETHOD GetClientes DESCRIPTION "Método que retorna os clientes do vendedor"
	WSMETHOD GetEmpresas DESCRIPTION "Método que retorna as empresas do cliente"
	WSMETHOD GetClientesVend DESCRIPTION "Método que retorna os clientes do vendedor"
	WSMETHOD GetSimilar DESCRIPTION "Método que retorna os produtos da tabela de similaridade"
	WSMETHOD BaixaOrc DESCRIPTION "Método que baixa orçamento em pdf"
	WSMETHOD EnviarTermo DESCRIPTION "Método que grava o aceite do termo"
	WSMETHOD GetAcessos DESCRIPTION "Método que retorna os acessos do superior"
	WSMETHOD SetAcessos DESCRIPTION "Método que seta os acessos do superior"

ENDWSSERVICE

WSMETHOD Logar WSRECEIVE _cLogin,_cPassword,_cIp WSSEND _cXml WSSERVICE WSPRTCLI

	Local _aUser 	:= {}
	Local _cQuery1 	:= ""
	Local _cAlias1  := ""
	Local _cQuery2 	:= ""
	Local _cAlias2  := ""
	Local _cQuery3 	:= ""
	Local _cAlias3  := ""
	Local _nX
	Local TelaConsumo:=""

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	DbSelectArea("Z79")
	Z79->(DbSetOrder(1))

	_cAlias1  := GetNextAlias()
	_cAlias2  := GetNextAlias()
	_cAlias3  := GetNextAlias()

	::_cLogin := Upper(::_cLogin)

	_cXml := "<login><resultado>

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SZR")+" ZR
	_cQuery1 += " WHERE ZR.D_E_L_E_T_=' ' AND UPPER(ZR_EMAIL)='"+Upper(::_cLogin)+"'
	_cQuery1 += " AND ZR_STATUS='A'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		_cXml += "<status>ERRO</status>
		_cXml += "<msg>Login não encontrado</msg>
		_cXml += "<nome></nome>
	Else

		If Empty((_cAlias1)->ZR_SENHA)
			_cXml += "<status>ERRO</status>
			_cXml += "<msg>Sem senha cadastrada, entre em contato com a Steck</msg>
			_cXml += "<nome></nome>
		ElseIf AllTrim((_cAlias1)->ZR_SENHA)==AllTrim(::_cPassword)

			_cXml += "<status>OK</status>
			_cXml += "<msg></msg>
			If Empty((_cAlias1)->ZR_CODCONT)
				_cXml += "<codcont>.</codcont>
			Else
				_cXml += "<codcont>"+(_cAlias1)->ZR_CODCONT+"</codcont>
			EndIf
			_cXml += "<nome>"+AllTrim((_cAlias1)->ZR_NOME)+"</nome>
			_cXml += "<tpuser>"+AllTrim((_cAlias1)->ZR_TPUSER)+"</tpuser>
			_cXml += "<login>"+AllTrim((_cAlias1)->ZR_LOGIN)+"</login>
			_cXml += "<email>"+AllTrim((_cAlias1)->ZR_EMAIL)+"</email>
			_cXml += "<acessos>"+IIf(Empty((_cAlias1)->ZR_ACESSOS),".",(_cAlias1)->ZR_ACESSOS)+"</acessos>
			_cXml += "<primeiroacesso>"+(_cAlias1)->ZR_1ACESSO+"</primeiroacesso>"
			_cXml += "<viraped>"+(_cAlias1)->ZR_VIRAPED+"</viraped>"

			If Empty((_cAlias1)->ZR_DTULT)
				_cXml += "<ultimoacesso>"+DTOC(Date())+" - "+Time()+"</ultimoacesso>"
			Else
				_cXml += "<ultimoacesso>"+DTOC(STOD((_cAlias1)->ZR_DTULT))+" - "+(_cAlias1)->ZR_HRULT+"</ultimoacesso>"
			EndIf

			_cTermo := "N"

			If !Empty((_cAlias1)->ZR_DTACEIT)
				_cTermo := "S"
			EndIf

			_cXml += "<termo>"+_cTermo+"</termo>"

			DbSelectArea("SZR")
			SZR->(DbGoTop())
			SZR->(DbGoTo((_cAlias1)->R_E_C_N_O_))
			If SZR->(!Eof()) .And. SZR->ZR_TPUSER=="C"

				SZR->(RecLock("SZR",.F.))
				SZR->ZR_DTULT := Date()
				SZR->ZR_HRULT := Time()
				SZR->(MsUnLock())

				_cXml += "<empresas>

				_cQuery3 := " SELECT A1_CGC, A1_TRANSP, A1_TPFRET, A1_NOME, A1_NREDUZ, A1_MSBLQL, A1_ZCONDPG, A1_TIPO, A1_COD,A1_LOJA
				_cQuery3 += " ,A1_CONTRIB, A1_ATIVIDA, A1_INSCR, NVL(E4_DESCRI,' ') E4_DESCRI,
				_cQuery3 += " NVL(E4_XVLRMIN,0) E4_XVLRMIN, NVL(E4_XACRESC,0) E4_XACRESC, NVL(A4_NOME,' ') A4_NOME
				_cQuery3 += " FROM "+RetSqlName("SA1")+" A1
				_cQuery3 += " LEFT JOIN "+RetSqlName("SE4")+" E4
				_cQuery3 += " ON E4_CODIGO=A1_ZCONDPG AND E4.D_E_L_E_T_=' '
				_cQuery3 += " LEFT JOIN "+RetSqlName("SA4")+" A4
				_cQuery3 += " ON A4_COD=A1_TRANSP AND A4.D_E_L_E_T_=' '
				_cQuery3 += " WHERE A1.D_E_L_E_T_=' '

				_aCnpjs := U_STFAT440(SZR->ZR_EMAIL)

				If Len(_aCnpjs)>0
					_cQuery3 += " AND (
					For _nX:=1 To Len(_aCnpjs)
						_cQuery3 += " (A1_CGC='"+_aCnpjs[_nX]+"')
						If !_nX==Len(_aCnpjs)
							_cQuery3 += " OR
						EndIf
					Next
					_cQuery3 += " )	
				Else
					If Len(AllTrim(SZR->ZR_LOGIN))==8
						_cQuery3 += " AND SUBSTR(A1_CGC,1,8)='"+AllTrim(SZR->ZR_LOGIN)+"'
					Else
						_cQuery3 += " AND A1_CGC='"+AllTrim(SZR->ZR_LOGIN)+"'
					EndIf
				EndIf

				If !Empty(Select(_cAlias3))
					DbSelectArea(_cAlias3)
					(_cAlias3)->(dbCloseArea())
				Endif

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

				dbSelectArea(_cAlias3)
				(_cAlias3)->(dbGoTop())

				While (_cAlias3)->(!Eof())

					cTransp 	:= (_cAlias3)->A1_TRANSP+" - "+(_cAlias3)->A4_NOME
					cTpFrete 	:= (_cAlias3)->A1_TPFRET

					If Empty(cTpFrete)
						cTpFrete := "C"
					EndIf

					TelaConsumo:=U_TELACONSUMO((_cAlias3)->A1_COD,(_cAlias3)->A1_LOJA)

					_cXml += "<empresa>
					_cXml += "<cnpj>"+(_cAlias3)->A1_CGC+"</cnpj>
					_cXml += "<condpg>"+(_cAlias3)->A1_ZCONDPG+"</condpg>
					_cXml += "<desccond>"+(_cAlias3)->E4_DESCRI+" - TX "+cValToChar((_cAlias3)->E4_XACRESC)+"% - Vlr. Min. R$ "+cValToChar((_cAlias3)->E4_XVLRMIN)+"</desccond>
					_cXml += "<msblql>"+(_cAlias3)->A1_MSBLQL+"</msblql>
					_cXml += "<transp>"+cTransp+"</transp>
					_cXml += "<tpfrete>"+cTpFrete+"</tpfrete>
					_cXml += "<nome>"+(_cAlias3)->A1_NREDUZ+"</nome>
					_cXml += "<a1_tipo>"+(_cAlias3)->A1_TIPO+"</a1_tipo>"
					_cXml += "<a1_contrib>"+(_cAlias3)->A1_CONTRIB+"</a1_contrib>"
					_cXml += "<a1_ativida>"+(_cAlias3)->A1_ATIVIDA+"</a1_ativida>"
					_cXml += "<a1_inscr>"+(_cAlias3)->A1_INSCR+"</a1_inscr>"
					_cXml += "<abre_consumo>"+TelaConsumo+"</abre_consumo>"
					_cXml += "</empresa>
					(_cAlias3)->(DbSkip())
				EndDo

				_cXml += "</empresas>

			EndIf

		ElseIf AllTrim((_cAlias1)->ZR_STATUS)=="I"
			_cXml += "<status>ERRO</status>
			_cXml += "<msg>Usuário não habilitado, entre em contato com a Steck</msg>
			_cXml += "<nome></nome>
		Else
			_cXml += "<status>ERRO</status>
			_cXml += "<msg>A senha digitada está incorreta</msg>
			_cXml += "<nome></nome>
		EndIf

	EndIf

	_cXml += "</resultado></login>

	_cXml := U_STTIRAGR(_cXml)

	U_STZ1B("Logar","","Logar","portal","",::_cIp,AllTrim((_cAlias1)->ZR_EMAIL))

	::_cXml := _cXml

Return .T.

WSMETHOD GetPeds WSRECEIVE _cLogin,_cNome,_cCliente,_cEmail WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cRet 	:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cQuery2	:= ""
	Local _cAlias2	:= GetNextAlias()
	Local _cNome	:= ::_cNome
	Local _cCliente := SubStr(::_cCliente,1,6)
	Local _cLoja 	:= SubStr(::_cCliente,7,2)
	Local _cEndRest := ""
	Local _nX

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	_cEndRest := GetMv("ST_RESTPOR",,"http://mail2.steck.com.br:9105")

	_cQuery1 := " SELECT C5_NUM, C5_EMISSAO, C5_ZORCAME, C5_XORDEM, SUM(C6_VALOR+(C6_QTDVEN*C6_ZVALIPI)+(C6_QTDVEN*C6_ZVALIST)) TOTAL
	_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC6")+" C6
	_cQuery1 += " ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM
	_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' '
	_cQuery1 += " AND C5_FILIAL='01' AND C5_EMISSAO>'"+DTOS(MonthSub(Date(),6))+"'
	_cQuery1 += " AND SUBSTR(C5_NOTA,1,1)<>'X'

	If !Empty(::_cCliente)
		_cQuery1 += " AND A1_COD='"+_cCliente+"' AND A1_LOJA='"+_cLoja+"'
	Else

		_aCnpjs := U_STFAT440(::_cEmail)

		If Len(_aCnpjs)>0
			_cQuery1 += " AND (
			For _nX:=1 To Len(_aCnpjs)
					_cQuery1 += " (A1_CGC='"+_aCnpjs[_nX]+"')
				If !_nX==Len(_aCnpjs)
					_cQuery1 += " OR
				EndIf
			Next
			_cQuery1 += " )	
		Else
			If Len(AllTrim(::_cLogin))==8 //Pegar todas as filiais
				_cQuery1 += " AND SUBSTR(A1_CGC,1,8)='"+::_cLogin+"'
			Else
				_cQuery1 += " AND A1_CGC='"+::_cLogin+"'
			EndIf
		EndIf
	EndIf

	_cQuery1 += " GROUP BY C5_NUM, C5_EMISSAO, C5_ZORCAME, C5_XORDEM
	_cQuery1 += " ORDER BY C5_EMISSAO DESC

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_nCount := 0

	While (_cAlias1)->(!Eof())

		_nCount++

		_cRet += '				<div class="row" id="'+AllTrim((_cAlias1)->C5_NUM)+'">
		//_cRet += '					<div class="cell" data-title="Pedido"><a href="'+AllTrim(_cEndRest)+'/rest/conspedido?cped='+Encode64((_cAlias1)->C5_NUM)+'" target="_blank">'+(_cAlias1)->C5_NUM+'</a></div>
		_cRet += '					<div class="cell" data-title="Pedido"><a href="'+GetMv("ST_WSPRT01",,"http://portalcliente.steck.com.br")+'/tracking.php?cped='+Encode64((_cAlias1)->C5_NUM)+'" target="_blank">'+(_cAlias1)->C5_NUM+'</a></div>
		_cRet += '					<div class="cell" data-title="Emissão">'+DTOC(STOD((_cAlias1)->C5_EMISSAO))+'</div>
		_cRet += '					<div class="cell" data-title="Orçamento">'+(_cAlias1)->C5_ZORCAME+'</div>
		_cRet += '					<div class="cell" data-title="Ordem de compra">'+(_cAlias1)->C5_XORDEM+'</div>
		//_cRet += '					<div class="cell" data-title="Valor">R$ '+Transform((_cAlias1)->TOTAL,"@E 99,999,999,999.99")+'</div>
		_cRet += '				</div>

		(_cAlias1)->(DbSkip())
	EndDo

	U_STZ1B("GetPeds","","GetPeds","portal","",,::_cEmail)

	::_cXml := _cRet

Return .T.

WSMETHOD GetNfs WSRECEIVE _cLogin,_cNome,_cCliente,_cEmail WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cRet 	:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cQuery2	:= ""
	Local _cAlias2	:= GetNextAlias()
	Local _cNome	:= ::_cNome
	Local _cCliente := SubStr(::_cCliente,1,6)
	Local _cLoja 	:= SubStr(::_cCliente,7,2)
	Local _nX

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SF2")+" F2
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA
	_cQuery1 += " WHERE F2.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' '
	_cQuery1 += " AND F2_FILIAL='01' AND F2_EMISSAO>'"+DTOS(MonthSub(Date(),6))+"'
	_cQuery1 += " AND F2_CHVNFE<>' '

	If !Empty(::_cCliente)
		_cQuery1 += " AND A1_COD='"+_cCliente+"' AND A1_LOJA='"+_cLoja+"'
	Else

		_aCnpjs := U_STFAT440(::_cEmail)

		If Len(_aCnpjs)>0
			_cQuery1 += " AND (
			For _nX:=1 To Len(_aCnpjs)
					_cQuery1 += " (A1_CGC='"+_aCnpjs[_nX]+"')
				If !_nX==Len(_aCnpjs)
					_cQuery1 += " OR
				EndIf
			Next
			_cQuery1 += " )	
		Else
			If Len(AllTrim(::_cLogin))==8 //Pegar todas as filiais
				_cQuery1 += " AND SUBSTR(A1_CGC,1,8)='"+::_cLogin+"'
			Else
				_cQuery1 += " AND A1_CGC='"+::_cLogin+"'
			EndIf
		EndIf

	EndIf

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		//u_STXPRTNF((_cAlias1)->F2_CHVNFE)

		_cRet += '				<div class="row" id="'+AllTrim((_cAlias1)->F2_DOC)+'">
		_cRet += '					<div class="cell" data-title="Nota Fiscal">'+(_cAlias1)->F2_DOC+'</div>
		_cRet += '					<div class="cell" data-title="Emissão">'+DTOC(STOD((_cAlias1)->F2_EMISSAO))+'</div>
		_cRet += '					<div class="cell" data-title="Valor">R$ '+Transform((_cAlias1)->F2_VALBRUT,"@E 999,999,999.99")+'</div>
		_cRet += '					<div class="cell" data-title="Chave">'+(_cAlias1)->F2_CHVNFE+'</div>
		_cRet += '					<div class="cell" data-title="Xml"><a href="download_danfe.php?cChave='+(_cAlias1)->F2_CHVNFE+'&cTipo=1"><img src="./imagens/download.png"/></a></div>
		_cRet += '					<div class="cell" data-title="Danfe"><a href="download_danfe.php?cChave='+(_cAlias1)->F2_CHVNFE+'&cTipo=2"><img src="./imagens/download.png"/></a></div>
		_cRet += '				</div>

		(_cAlias1)->(DbSkip())
	EndDo

	U_STZ1B("GetNfs","","GetNfs","portal","",,::_cEmail)

	::_cXml := _cRet

Return .T.

WSMETHOD BaixaNf WSRECEIVE _cChave,_cLogin,_cNome,_cTipo,_cEmail WSSEND _cXml WSSERVICE WSPRTCLI

	Local cRet 		:= ""
	Local cChave 	:= ::_cChave
	Local _cQuery2	:= ""
	Local _cAlias2	:= GetNextAlias()
	Local _cNome	:= ::_cNome

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	If ::_cTipo=="1"
		U_STFAT030(cChave)
	Else
		U_STXPRTNF(cChave)
	EndIf

	cRet += "<baixarnf><resultado>OK</resultado></baixarnf>"

	U_STZ1B("BaixaNf","","BaixaNf","portal","",,::_cEmail)

	::_cXml := cRet

Return .T.

WSMETHOD EnviaSenha WSRECEIVE _cLogin WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cQuery1 	:= ""
	Local _cAlias1  := ""
	Local _cQuery2 	:= ""
	Local _cAlias2  := ""
	Local _cLogin	:= AllTrim(::_cLogin)

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	_cAlias1  := GetNextAlias()
	_cAlias2  := GetNextAlias()

	_cXml := "<senha><resultado>

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SZR")+" ZR
	_cQuery1 += " WHERE ZR.D_E_L_E_T_=' ' AND ZR_EMAIL='"+::_cLogin+"'"

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		_cXml += "<status>ERRO</status>
		_cXml += "<msg>Login não encontrado, entre em contato com a Steck</msg>
		_cXml += "<nome></nome>
	Else

		_aAttach := {}
		cMsg 	 := "<html><head><title></title></head><body>
		cMsg 	 += "Segue abaixo seus dados para acesso ao portal de clientes da Steck<br><br>
		cMsg	 += "Login: <b>"+AllTrim((_cAlias1)->ZR_EMAIL)+" </b><br>"
		cMsg	 += "Senha: <b>"+AllTrim((_cAlias1)->ZR_SENHA)+"</b>"
		cMsg	 += "</body></html>
		cEmail 	 := AllTrim((_cAlias1)->ZR_EMAIL)

		If U_STMAILTES(cEmail,"","[STECK] - Reenvio de senha do portal do cliente", cMsg,_aAttach,"","")
			_cXml += "<status>OK</status>
			_cXml += "<msg>Senha enviada com sucesso para "+AllTrim((_cAlias1)->ZR_EMAIL)+"</msg>
			_cXml += "<nome></nome>
		Else
			_cXml += "<status>ERRO</status>
			_cXml += "<msg>Erro ao enviar o email, entre em contato com a Steck</msg>
			_cXml += "<nome></nome>
		EndIf
	EndIf

	_cXml += "</resultado></senha>

	U_STZ1B("EnviaSenha","","EnviaSenha","portal","",,::_cLogin)

	::_cXml := _cXml

Return .T.

WSMETHOD ListaBoletos WSRECEIVE _cLogin,_cNome,_cCliente,_cEmail WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cRet 	:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cQuery2	:= ""
	Local _cAlias2	:= GetNextAlias()
	Local _cNome	:= ::_cNome
	Local _cCliente := SubStr(::_cCliente,1,6)
	Local _cLoja 	:= SubStr(::_cCliente,7,2)
	Local _nX

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SE1")+" E1
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA
	_cQuery1 += " WHERE E1.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' '
	_cQuery1 += " AND E1_FILIAL='01' AND E1_EMISSAO>'"+DTOS(MonthSub(Date(),12))+"'
	_cQuery1 += " AND E1_SALDO>0 AND E1_TIPO IN ('NF')
	//_cQuery1 += " AND E1_PORTADO IN ('001','341','237')

	If !Empty(::_cCliente)
		_cQuery1 += " AND A1_COD='"+_cCliente+"' AND A1_LOJA='"+_cLoja+"'
	Else

		_aCnpjs := U_STFAT440(::_cEmail)

		If Len(_aCnpjs)>0
			_cQuery1 += " AND (
			For _nX:=1 To Len(_aCnpjs)
					_cQuery1 += " (A1_CGC='"+_aCnpjs[_nX]+"')
				If !_nX==Len(_aCnpjs)
					_cQuery1 += " OR
				EndIf
			Next
			_cQuery1 += " )	
		Else
			If Len(AllTrim(::_cLogin))==8 //Pegar todas as filiais
				_cQuery1 += " AND SUBSTR(A1_CGC,1,8)='"+::_cLogin+"'
			Else
				_cQuery1 += " AND A1_CGC='"+::_cLogin+"'
			EndIf
		EndIf

	EndIf

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		//u_STXPRTNF((_cAlias1)->F2_CHVNFE)

		_cApost := "'"

		_cRet += '				<div class="row" id="'+(_cAlias1)->E1_NUM+"-"+(_cAlias1)->E1_PARCELA+'">
		_cRet += '					<div class="cell" data-title="Número"><a href="#" onClick="window.open('+_cApost+'envia_boleto.php?cBoleto='+(_cAlias1)->E1_NUM+"-"+(_cAlias1)->E1_PARCELA+_cApost+','+_cApost+'Titulo da Janela'+_cApost+', '+_cApost+'STATUS=NO, TOOLBAR=NO, LOCATION=NO, DIRECTORIES=NO, RESISABLE=NO, SCROLLBARS=YES, TOP=99, LEFT=99, WIDTH=500, HEIGHT=150'+_cApost+');">'+(_cAlias1)->E1_NUM+"-"+(_cAlias1)->E1_PARCELA+'</a></div>
		_cRet += '					<div class="cell" data-title="Prefixo">'+(_cAlias1)->E1_PREFIXO+'</div>
		_cRet += '					<div class="cell" data-title="Parcela">'+(_cAlias1)->E1_PARCELA+'</div>
		_cRet += '					<div class="cell" data-title="Emissão">'+DTOC(STOD((_cAlias1)->E1_EMISSAO))+'</div>
		_cRet += '					<div class="cell" data-title="Vencto">'+DTOC(STOD((_cAlias1)->E1_VENCREA))+'</div>
		_cRet += '					<div class="cell" data-title="Valor">R$ '+Transform((_cAlias1)->E1_VALOR,"@E 999,999,999.99")+'</div>
		_cRet += '				</div>

		(_cAlias1)->(DbSkip())
	EndDo

	U_STZ1B("ListaBoletos","","ListaBoletos","portal","",,::_cEmail)

	::_cXml := _cRet

Return .T.

WSMETHOD EnviaBoleto WSRECEIVE _cBoleto,_cLogin,_cEmail,_cNome,_cEmail1 WSSEND _cXml WSSERVICE WSPRTCLI

	Local cRet 		:= ""
	Local cChave 	:= ::_cChave
	Local _cQuery2	:= ""
	Local _cAlias2	:= GetNextAlias()
	Local _cNome	:= ::_cNome

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	U_BOLPORTAL('001',::_cBoleto,::_cEmail)

	cRet += "<html><head></head><title></title><body>
	cRet += "Solicitação de boleto efetuada com sucesso!<br>
	cRet += "Você irá receber o boleto dentro de no máximo 15 minutos, obrigado!"

	U_STZ1B("EnviaBoleto","","EnviaBoleto","portal","",,::_cEmail1)

	::_cXml := cRet

Return .T.

WSMETHOD AlteraSenha WSRECEIVE _cLogin,_cPassword,_cNome,_cEmail,_cPassword2 WSSEND _cXml WSSERVICE WSPRTCLI

	Local cRet 		:= "Ocorreu algum erro ao tentar alterar a senha, entre em contato com a Steck"
	Local cChave 	:= ::_cChave
	Local _cQuery2	:= ""
	Local _cAlias2	:= GetNextAlias()
	Local _cNome	:= ::_cNome
	Local _cLogin	:= AllTrim(::_cLogin)

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	If !(AllTrim(::_cPassword)==AllTrim(::_cPassword2))
		cRet := "As senhas estão diferentes, verifique!"
		::_cXml := cRet
		Return .T.
	EndIf

	_cQuery2 := " SELECT ZR.R_E_C_N_O_ RECSZR
	_cQuery2 += " FROM "+RetSqlName("SZR")+" ZR
	_cQuery2 += " WHERE ZR.D_E_L_E_T_=' ' AND ZR_EMAIL='"+::_cEmail+"'

	If !Empty(Select(_cAlias2))
		DbSelectArea(_cAlias2)
		(_cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbGoTop())

	If (_cAlias2)->(!Eof())

		DbSelectArea("SZR")
		SZR->(DbGoTop())
		SZR->(DbGoTo((_cAlias2)->RECSZR))
		If SZR->(!Eof())

			SZR->(RecLock("SZR",.F.))
			SZR->ZR_SENHA := ::_cPassword
			SZR->ZR_1ACESSO := "N"
			SZR->(MsUnLock())

			cRet := "[OK] - Sua senha foi alterada com sucesso, obrigado!"

		EndIf

	EndIf

	U_STZ1B("AlteraSenha","","AlteraSenha","portal","",,::_cEmail)

	::_cXml := cRet

Return .T.

WSMETHOD GetSb1 WSRECEIVE _cLogin WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cQuery1 			:= ""
	Local _cAlias1			:= GetNextAlias()
	Local _cRetorno			:= "<produtos>"
	Local _cTabela			:= ""

	_cTabela  		:= GETMV("ST_TPRCTMK",,'001')

	_cQuery1 := " SELECT B1_COD, B1_DESC, B1_CODBAR
	_cQuery1 += " FROM "+RetSqlName("SB1")+" B1
	_cQuery1 += " WHERE B1.D_E_L_E_T_=' '
	_cQuery1 += " AND B1_MSBLQL='2'
	_cQuery1 += " AND B1_XDESAT<>'2'
	_cQuery1 += " AND B1_TIPO='PA'
	_cQuery1 += " AND B1_GRUPO NOT IN ('041','042','122')

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_cRetorno += "<produto>
		_cRetorno += "<codigo>"+AllTrim((_cAlias1)->B1_COD)+"</codigo>"
		_cRetorno += "<descri>"+AllTrim((_cAlias1)->B1_DESC)+"</descri>"
		_cRetorno += "<codbar>"+AllTrim((_cAlias1)->B1_CODBAR)+"</codbar>"
		_cRetorno += "</produto>

		(_cAlias1)->(DbSkip())
	EndDo

	_cRetorno += "</produtos>"

	//Conout(_cRetorno)

	::_cXml := _cRetorno

Return .T.

WSMETHOD InserePed WSRECEIVE _cLogin,_cXmlRec,_cEmail WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cXml 	:= ::_cXmlRec
	Local cAviso	:= ""
	Local cErro		:= ""
	Local _cNumZT	:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cQuery2	:= ""
	Local _cAlias2	:= ""
	Local _cQuery3	:= ""
	Local _cAlias3	:= ""
	Local _cQuery4	:= ""
	Local _cAlias4	:= ""
	Local _cQuery5	:= ""
	Local _cAlias5	:= ""
	Local _cRetorno	:= ""
	Local _nX		:= 0
	Local aCabec    := {}
	Local aItens	:= {}
	Local aLinha	:= {}
	Local _cCliEst      := "SA1->A1_EST"
	Local _cCliContrib  := "SA1->A1_CONTRIB"
	Local _cCliInscr    := "SA1->A1_INSCR"
	Local _cCliTip      := "SA1->A1_TIPO"
	Local _cCliGru      := "SA1->A1_ATIVIDA"
	Local _cCli008      := "SA1->A1_SATIV1"
	Local _cCliSufra    := "SA1->A1_SUFRAMA"
	Local _cCliMun      := "SA1->A1_COD_MUN"
	Local _cxCliContr   := "SA1->A1_GRPTRIB"
	Local _lEst         := .T.
	Local _cTipoCli		:= ""
	Local _lSemPrc		:= .F.
	Local _aSemPrc		:= {}
	Local _cAssunto 	:= ""
	Local _cEmail 		:= ""
	Local _cCopia		:= "renato.oliveira@steck.com.br"
	Local cAttach		:= ""
	Local _cNumOrc		:= ""
	Local _nTotal		:= 0

	Local nX     := 0
	Local nCount := 0
	Local cLogFile := "" //nome do arquivo de log a ser gravado
	Local aLog 	 := {}
	Local aVetor := {}
	Local nHandle
	Local lRet := .F.   // variável de controle interno da rotina automatica que informa se houve erro durante o processamento
    Local _cLockBy      :=""
	Local cGuid   :=""

	PRIVATE lMsErroAuto := .F.// variável que define que o help deve ser gravado no arquivo de log e que as informações estão vindo à partir da rotina automática.
	Private lMsHelpAuto	:= .T.    // força a gravação das informações de erro em array para manipulação da gravação ao invés de gravar direto no arquivo temporário
	Private lAutoErrNoFile := .T.
	Private _cConsumo := ""

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"TMK")

	__cUserId := "001168"

	_cAlias2	:= GetNextAlias()
	_cAlias3    := GetNextAlias()
	_cAlias4    := GetNextAlias()
	_cAlias5    := GetNextAlias()

	Conout("[WSPRTCLI][InserePed]"+FWTimeStamp(2)+" - Inicio da alteração/inserção do orçamento!")
	Conout("[WSPRTCLI][InserePed]"+FWTimeStamp(2)+" - Xml recebido: "+_cXmlRec)

	oXml := XmlParser(_cXml,"_",@cAviso,@cErro)

	Conout(cAviso)
	Conout(cErro)

	aCabec := {}

	_nOpc := IIf(AllTrim(oXml:_PEDIDO:_COTACAO:TEXT)=="nova",3,4)

	DbSelectArea("SUA")
	SUA->(DbSetOrder(1))

	If _nOpc==4

		If SUA->(DbSeek(xFilial("SUA")+oXml:_PEDIDO:_COTACAO:TEXT))

			_cNumOrc := SUA->UA_NUM

			If !Empty(SUA->UA_NUMSC5) .Or. SUA->UA_OPER == "1"
				_cRetorno := "Pedido "+SUA->UA_NUMSC5+" já gerado para este orçamento!"
				::_cXml := _cRetorno
				Return .T.
			EndIf

			If AllTrim(SUA->UA_STATUS)=="CAN"
				_cRetorno := "Este orçamento foi cancelado, verifique!"
				::_cXml := _cRetorno
				Return .T.
			EndIf

			DbSelectArea("SC5")
			SC5->(DbSetOrder(11))
			If SC5->(DbSeek(SUA->(UA_FILIAL+UA_NUM)))
				_cRetorno := "Pedido "+SC5->C5_NUM+" já gerado para este orçamento!"
				::_cXml := _cRetorno
				Return .T.
			EndIf

		Else

			_cRetorno := "Orçamento não encontrado, entre em contato com o depto de TI"
			::_cXml := _cRetorno
			Return .T.

		EndIf

		AADD(aCabec,{"UA_NUM" ,SUA->UA_NUM    ,Nil})

	EndIf

	DbSelectArea("SUB")
	SUB->(DbSetOrder(1))

	lMsErroAuto := .F.
	aItens := {}
	aLinha := {}

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SA1")+" A1
	_cQuery1 += " WHERE A1.D_E_L_E_T_=' '
	_cQuery1 += " AND A1_CGC='"+oXml:_PEDIDO:_CNPJ:TEXT+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		_cRetorno := "Cliente não encontrado, entre em contato com a Steck!"
		::_cXml := _cRetorno
		Return .T.
	Else
		DbSelectArea("SA1")
		SA1->(DbGoTo((_cAlias1)->R_E_C_N_O_))
	EndIf

	//If !Empty(SA1->A1_XDESTP)
		//_cConsumo := SA1->A1_XDESTP
		_cConsumo:=AllTrim(oXml:_PEDIDO:_TPCONSUM:TEXT)
	//EndIf

	If _nOpc==3

		AADD(aCabec,{"UA_CLIENTE" ,(_cAlias1)->A1_COD     ,Nil})
		AADD(aCabec,{"UA_LOJA"    ,(_cAlias1)->A1_LOJA    ,Nil})

		//buscar pelo email
		_cQuery5 := " SELECT AC8_CODCON
		_cQuery5 += " FROM "+RetSqlName("SU5")+" U5
		_cQuery5 += " LEFT JOIN "+RetSqlName("AC8")+" AC8
		_cQuery5 += " ON AC8_CODCON=U5_CODCONT
		_cQuery5 += " WHERE U5.D_E_L_E_T_=' ' AND AC8.D_E_L_E_T_=' '
		_cQuery5 += " AND AC8_CODENT='"+(_cAlias1)->(A1_COD+A1_LOJA)+"'
		_cQuery5 += " AND U5_EMAIL='"+AllTrim(::_cEmail)+"'

		If !Empty(Select(_cAlias5))
			DbSelectArea(_cAlias5)
			(_cAlias5)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery5),_cAlias5,.T.,.T.)

		dbSelectArea(_cAlias5)
		(_cAlias5)->(dbGoTop())

		If (_cAlias5)->(!Eof())
			AADD(aCabec,{"UA_CODCONT"   ,(_cAlias5)->AC8_CODCON        ,Nil})
		Else
			DbSelectArea("AC8")
			AC8->(DbSetOrder(2))
			AC8->(DbGoTop())
			If AC8->(DbSeek(xFilial("AC8")+"SA1"+xFilial("AC8")+(_cAlias1)->(A1_COD+A1_LOJA)))
				AADD(aCabec,{"UA_CODCONT"   ,AC8->AC8_CODCON           ,Nil})
			EndIf
		EndIf

		AADD(aCabec,{"UA_XORIG"    ,"1"    ,Nil})

	EndIf

	_cTipoCli   := SA1->A1_TIPO
	cItem 		:= oXml:_PEDIDO:_TPCONSUM:TEXT
	_cZconsum   := " "
	_cTipoCF    := "C"

	If _cTipoCF == "C"
		If (&_cCliTip $ 'R' .And. &_cCliContrib = '1'  .And. (alltrim(&_cCliGru) $ 'D1/D2/D3/R1/R2/R3/R5' ) .And. (!Empty(ALLTRIM(&_cCliInscr)) .Or. 'ISENT' $ Upper(ALLTRIM(&_cCliInscr))))
			_cZconsum := '1'
		EndIf
	Endif

	AADD(aCabec,{"UA_OPERADO"  	,"000002"           ,Nil})
	AADD(aCabec,{"UA_OPER"   	,SubStr(oXml:_PEDIDO:_TPOPER:TEXT,1,1)           ,Nil})
	AADD(aCabec,{"UA_TMK"		,"1"			,Nil})	//1-Ativo 2-Receptivo
	//AADD(aCabec,{"UA_ZCONSUM"	,_cZconsum		,Nil})	//1-Ativo 2-Receptivo
	AADD(aCabec,{"UA_ZCONSUM"	,_cConsumo		,Nil})	//1-Ativo 2-Receptivo
	AADD(aCabec,{"UA_CONDPG"   	,SubStr(oXml:_PEDIDO:_CONDPG:TEXT,1,3)           ,Nil})
	AADD(aCabec,{"UA_XCONDPG"   ,SubStr(oXml:_PEDIDO:_CONDPG:TEXT,1,3)           ,Nil})
	AADD(aCabec,{"UA_TPFRETE"   ,SubStr(oXml:_PEDIDO:_TPFRETE:TEXT,1,1)           ,Nil})
	AADD(aCabec,{"UA_TRANSP"   	,SubStr(oXml:_PEDIDO:_TRANSP:TEXT,1,6)     ,Nil})
	AADD(aCabec,{"UA_XTIPOPV"   ,SubStr(oXml:_PEDIDO:_TPENT:TEXT,1,1)           ,Nil})
	AADD(aCabec,{"UA_XTIPFAT"   ,SubStr(oXml:_PEDIDO:_TPFAT:TEXT,1,1)           ,Nil})
	AADD(aCabec,{"UA_ZOBS"   	,SZT->ZT_OBS           ,Nil})
	AADD(aCabec,{"UA_XORDEM"   	,oXml:_PEDIDO:_OCCABEC:TEXT           ,Nil})

	IF TYPE("oXml:_PEDIDO:UA_XENTFAT:TEXT") <> "U"
		AADD(aCabec,{"UA_XENTFAT"   	,oXml:_PEDIDO:UA_XENTFAT:TEXT           ,Nil})
		IF TYPE("oXml:_PEDIDO:UA_XDTENPR:TEXT") <> "U"
			AADD(aCabec,{"UA_XDTENPR"   	,STOD(oXml:_PEDIDO:UA_XDTENPR:TEXT)           ,Nil})
		EndIf
	EndIf

	If _nOpc==4
		AADD(aCabec,{"UA_TIPOCLI"   	,SUA->UA_TIPOCLI     ,Nil})
	Else
		AADD(aCabec,{"UA_TIPOCLI"   	,_cTipoCli     ,Nil})
	EndIf

	AADD(aCabec,{"UA_XEMLSZR"   	,AllTrim(::_cEmail)     ,Nil})

	_cItem := "00"
	_aItens := {}

	Do Case

	Case Type("oXml:_PEDIDO:_PRODUTOS:_PRODUTO")=="O"

		AADD(_aItens,{;
		oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT,;
		Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_QTDE:TEXT),;
		oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_NUMOC:TEXT,;
		oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_ITEMOC:TEXT,;
		Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_PRECO:TEXT),;
		SubStr(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_ITEM:TEXT,1,2),;
		.F.,;
		.F.,;
		0;
		})

		If Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_PRECO:TEXT)<=0.01
			_lSemPrc := .T.
			AADD(_aSemPrc,{"01",oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT})
		EndIf

		_nTotal := Round(Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_TOTAL:TEXT),2)

	Case Type("oXml:_PEDIDO:_PRODUTOS:_PRODUTO")=="A"

		For _nX:=1 To Len(oXml:_PEDIDO:_PRODUTOS:_PRODUTO)

			AADD(_aItens,{;
			oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT,;
			Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_QTDE:TEXT),;
			oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_NUMOC:TEXT,;
			oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_ITEMOC:TEXT,;
			Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_PRECO:TEXT),;
			SubStr(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_ITEM:TEXT,1,2),;
			.F.,;
			.F.,;
			0;
			})

			If Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_PRECO:TEXT)<=0.01
				_lSemPrc := .T.
				AADD(_aSemPrc,{SubStr(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_ITEM:TEXT,1,2),oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT})
			EndIf

			_nTotal += Round(Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_TOTAL:TEXT),2)

		Next _nX

	EndCase

	DbSelectArea("SE4")
	SE4->(DbSetOrder(1))
	SE4->(DbSeek(xFilial("SE4")+SubStr(oXml:_PEDIDO:_CONDPG:TEXT,1,3)))

	If SubStr(oXml:_PEDIDO:_TPOPER:TEXT,1,1)=="1" //Faturamento
		If _nTotal<SE4->E4_XVLRMIN
			_cRetorno := "[ERRO] - O valor mínimo virar este orçamento para pedido é R$ "+cValToChar(SE4->E4_XVLRMIN)
			::_cXml := _cRetorno
			Return .t.
		EndIf
	EndIf

	If _nOpc==4

		SUB->(DbSeek(xFilial("SUB")+SUA->UA_NUM))

		While SUB->(!Eof()) .And. SUA->(UA_FILIAL+UA_NUM)==SUB->(UB_FILIAL+UB_NUM)

			_lDeleta := .T.
			_lAchou  := .F.

			For _nX:=1 To Len(_aItens)

				If AllTrim(_aItens[_nX][6])==AllTrim(SUB->UB_ITEM)
					_lDeleta := .F.
					_lAchou  := .T.
					Exit
				EndIf

			Next

			If _lDeleta

				AADD(_aItens,{;
				SUB->UB_PRODUTO,;
				SUB->UB_QUANT,;
				SUB->UB_NUMPCOM,;
				SUB->UB_ITEMPC,;
				SUB->UB_VRUNIT,;
				SUB->UB_ITEM,;
				_lDeleta,;
				_lAchou,;
				0;
				})

			EndIf

			If !_lDeleta .And. _lAchou
				_aItens[_nX][8] := .T.
				_aItens[_nX][1] := SUB->UB_PRODUTO
				_aItens[_nX][6] := SUB->UB_ITEM
			EndIf

			SUB->(DbSkip())
		EndDo

	EndIf

	For _nX:=1 To Len(_aItens)

		aLinha := {}

		If _nOpc==4
			If _aItens[_nX][8]
				aadd(aLinha,{"LINPOS","UB_ITEM",_aItens[_nX][6]})
			Else
				aadd(aLinha,{"UB_ITEM"  	,SubStr(_aItens[_nX][6],1,2)  ,Nil})
			EndIf
			If _aItens[_nX][7]
				aadd(aLinha,{"AUTDELETA","S"        ,Nil})
			Else
				aadd(aLinha,{"AUTDELETA","N"        ,Nil})
			EndIf
		Else
			aadd(aLinha,{"UB_ITEM"  	,SubStr(_aItens[_nX][6],1,2)  ,Nil})
		EndIf

		aadd(aLinha,{"UB_PRODUTO"  	,_aItens[_nX][1]  ,Nil})
		aadd(aLinha,{"UB_QUANT"  	,_aItens[_nX][2]  ,Nil})

		If _aItens[_nX][9]>0 //Desconto

			_nPDesc := _aItens[_nX][9]

			If _nPDesc>0
				_aItens[_nX][5]	:= Round((100/_nPDesc)*_aItens[_nX][5],2)
			EndIf

		EndIf

		aadd(aLinha,{"UB_VRUNIT"  	,_aItens[_nX][5]  ,Nil})

		If _aItens[_nX][9]>0 //Desconto
			aadd(aLinha,{"UB_XPORDEC"  	,_aItens[_nX][9]  ,Nil})
		EndIf

		aadd(aLinha,{"UB_NUMPCOM"  	,_aItens[_nX][3]  ,Nil})
		aadd(aLinha,{"UB_ITEMPC"  	,_aItens[_nX][4]  ,Nil})

		aadd(aItens,aLinha)

	Next

	cRotina := "2"

	If _nOpc==4

		_nQtdT := 0
		While !SUA->(RLock())

			If _nQtdT>=4

				_cRetorno := "Outro usuário está alterando este orçamento, por favor tente novamente mais tarde, obrigado!"
				Conout("[WSPRTCLI][InserePed]"+FWTimeStamp(2)+" - Fim da alteração/inserção do orçamento!")
				::_cXml := _cRetorno
				Return .t.

			EndIf

			_nQtdT++
			Sleep(5000)
			Loop

		EndDo

		cLock := "SUA"+xFilial("SUA")+SUA->UA_NUM
		UnLockByName(cLock,.T.,FWModeAccess("SUA",3) == "E",.T.)
	EndIf

	If _nOpc==3
		//Checar duplicados

		_cChkQry := ""
		_cChkRec := ""

		_cQuery4 := " SELECT *
		_cQuery4 += " FROM (
		_cQuery4 += " SELECT UA_FILIAL, UA_NUM, COUNT(UB_NUM) QTDITENS
		_cQuery4 += " FROM "+RetSqlName("SUA")+" UA
		_cQuery4 += " LEFT JOIN "+RetSqlName("SUB")+" UB
		_cQuery4 += " ON UB_FILIAL=UA_FILIAL AND UB_NUM=UA_NUM
		_cQuery4 += " WHERE UA.D_E_L_E_T_=' ' AND UB.D_E_L_E_T_=' '
		_cQuery4 += " AND UA_FILIAL='"+xFilial("SUA")+"' AND UA_CLIENTE='"+(_cAlias1)->A1_COD+"'
		_cQuery4 += " AND UA_LOJA='"+(_cAlias1)->A1_LOJA+"'
		_cQuery4 += " AND UA_EMISSAO='"+DTOS(Date())+"'
		_cQuery4 += " AND UA_XORIG='1'
		_cQuery4 += " GROUP BY UA_FILIAL, UA_NUM
		_cQuery4 += " ) XXX
		_cQuery4 += " WHERE QTDITENS="+cValToChar(Len(_aItens))

		If !Empty(Select(_cAlias4))
			DbSelectArea(_cAlias4)
			(_cAlias4)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery4),_cAlias4,.T.,.T.)

		dbSelectArea(_cAlias4)
		(_cAlias4)->(dbGoTop())

		While (_cAlias4)->(!Eof())

			_cQuery3 := " SELECT UA_FILIAL, UA_NUM, UB_PRODUTO, UB_QUANT
			_cQuery3 += " FROM "+RetSqlName("SUA")+" UA
			_cQuery3 += " LEFT JOIN "+RetSqlName("SUB")+" UB
			_cQuery3 += " ON UB_FILIAL=UA_FILIAL AND UB_NUM=UA_NUM
			_cQuery3 += " WHERE UA.D_E_L_E_T_=' ' AND UB.D_E_L_E_T_=' '
			_cQuery3 += " AND UA_FILIAL='"+(_cAlias4)->UA_FILIAL+"' AND UA_NUM='"+(_cAlias4)->UA_NUM+"'
			_cQuery3 += " ORDER BY UB_ITEM

			If !Empty(Select(_cAlias3))
				DbSelectArea(_cAlias3)
				(_cAlias3)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

			dbSelectArea(_cAlias3)
			(_cAlias3)->(dbGoTop())

			While (_cAlias3)->(!Eof())
				_cChkQry += AllTrim((_cAlias3)->UB_PRODUTO)+AllTrim(cValToChar((_cAlias3)->UB_QUANT))
				(_cAlias3)->(DbSkip())
			EndDo

			For _nX:=1 To Len(_aItens)

				_nPosProd 	:= aScan(aItens[_nX],{|x| Upper(AllTrim(x[1])) == "UB_PRODUTO"})
				_nPosQuant	:= aScan(aItens[_nX],{|x| Upper(AllTrim(x[1])) == "UB_QUANT"})

				_cChkRec += AllTrim(aItens[_nX][_nPosProd][2])+AllTrim(CVALTOCHAR(aItens[_nX][_nPosQuant][2]))

			Next

			If AllTrim(_cChkRec)==AllTrim(_cChkQry)
				::_cXml := "Já existe um orçamento ("+(_cAlias4)->UA_NUM+") idêntico a esse que foi inserido na data de hoje, entre pela rotina alterar orçamentos!"
				Return .T.
			EndIf

			(_cAlias4)->(DbSkip())
		EndDo

	EndIf
	//Gravação do Log de Erro
	If 	_nOpc == 3 //Pedido Novo
		cLogErro := FWTimeStamp(2) + Space(2) + "Novo Pedido" 
	else
		cLogErro := FWTimeStamp(2) + Space(2) + _cNumOrc
	Endif

	//Efetua o lock para processamento. 
	If TYPE("oXml:_PEDIDO:_GUID:TEXT") <> "U"
		cGuid   := AllTrim(oXml:_PEDIDO:_GUID:TEXT)
		_cLockBy  := cGuid //SA1->A1_COD
		IF !LockByName(_cLockBy,.F.,.F.,.T.)
		_cRetorno := "[WSPRTCLI][InserePed]" + "Erro ao Inserrir Registro "  + ENTER + 'ID.: '+_cLockBy+' ainda em processamento '
		::_cXml := _cRetorno
		RETURN .T.
		ENDIF   
	EndIf

	Begin Transaction 

	TMKA271(aCabec,aItens,_nOpc,cRotina)

	If TYPE("oXml:_PEDIDO:_GUID:TEXT") <> "U"	
    	UnLockByName(_cLockBy,.F.,.F.,.T.)
	EndIf


	If !lMsErroAuto

		_cOrcIns := ""

		_cQuery2 := " SELECT UA_NUM
		_cQuery2 += " FROM "+RetSqlName("SUA")+" UA
		_cQuery2 += " WHERE UA.D_E_L_E_T_=' ' AND UA_FILIAL='"+cFilAnt+"' AND UA_CLIENTE='"+(_cAlias1)->A1_COD+"'
		_cQuery2 += " AND UA_LOJA='"+(_cAlias1)->A1_LOJA+"' AND UA_XORIG='1'
		_cQuery2 += " ORDER BY UA_NUM DESC

		If !Empty(Select(_cAlias2))
			DbSelectArea(_cAlias2)
			(_cAlias2)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

		dbSelectArea(_cAlias2)
		(_cAlias2)->(dbGoTop())

		If (_cAlias2)->(!Eof())
			_cOrcIns := (_cAlias2)->UA_NUM
		EndIf

		If _nOpc==4
			_cRetorno := "[OK] - Orçamento "+_cNumOrc+" alterado com sucesso, obrigado :)"
			SUA->(DbSeek(cFilAnt+_cNumOrc))
		Else
			_cRetorno := "[OK] - Orçamento "+_cOrcIns+" inserido com sucesso, obrigado :)"
			SUA->(DbSeek(cFilAnt+_cOrcIns))
		EndIf

		If SUA->(!Eof())
		
			If _lSemPrc
				SUA->(RecLock("SUA",.F.))
				SUA->UA_XBLOQ 	:= "1"
				SUA->UA_XDESBLQ := AllTrim(SUA->UA_XDESBLQ)+"PSC/"
				SUA->(MsUnLock())
			EndIf
				
			If SubStr(SUA->UA_VEND,1,1)=="R"
				SUA->(RecLock("SUA",.F.))
				SUA->UA_VEND2 := SUA->UA_VEND
				SUA->(MsUnLock())
			EndIf

			_cEmail := AllTrim(::_cEmail)
			_cCopia := "carla.lodetti@steck.com.br;marcelo.oliveira@steck.com.br"

			DbSelectArea("SA3")
			SA3->(DbSetOrder(1))
			If SA3->(DbSeek(xFilial("SA3")+SUA->UA_VEND))
				_cCopia += ";"+AllTrim(SA3->A3_EMAIL)
			EndIf
			
			If _nOpc==3

				_cAssunto := "[WFPROTHEUS] - Orçamento "+SUA->UA_NUM+" inserido via portal 
				
				If AllTrim(SUA->UA_XBLOQ)=="1"
					_cAssunto += " (bloqueado)
				EndIf

				cMsg := ""
				cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
				cMsg += '<img src="http://www.appstk.com.br/portal_cliente/imagens/teckinho.jpg"><br><br>
				cMsg += 'Olá <b>'+Alltrim((_cAlias1)->A1_NOME)+'</b>,<br><br>
				cMsg += 'Obrigado por cotar pelo nosso portal!<br><br>

				cMsg += 'Número do orçamento gerado: <b>'+SUA->UA_NUM+'</b><br><br>'

				If AllTrim(SUA->UA_XBLOQ)=="1"
					cMsg += 'Seu orçamento possui ficou bloqueado e será analisado pela nossa equipe interna.<br>
					cMsg += 'Em breve você receberá uma outra mensagem informando que o orçamento já está liberado para acesso.<br><br>
				EndIf

				cMsg += 'Atenciosamente,<br>
				cMsg += 'Steck Indústria Elétrica Ltda
				cMsg += '</body></html>'

				U_STMAILTES(_cEmail,_cCopia,_cAssunto,cMsg,cAttach)
			
			Else
				
				If AllTrim(SUA->UA_XBLOQ)=="1"
				
					_cAssunto := "[WFPROTHEUS] - Orçamento "+SUA->UA_NUM+" alterado via portal
					
					If AllTrim(SUA->UA_XBLOQ)=="1"
						_cAssunto += " (bloqueado)
					EndIf
		
					cMsg := ""
					cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
					cMsg += '<img src="http://www.appstk.com.br/portal_cliente/imagens/teckinho.jpg"><br><br>
					cMsg += 'Olá <b>'+Alltrim((_cAlias1)->A1_NOME)+'</b>,<br><br>
					cMsg += 'Obrigado por cotar pelo nosso portal!<br><br>
		
					cMsg += 'Número do orçamento gerado: <b>'+SUA->UA_NUM+'</b><br><br>'
		
					cMsg += 'Seu orçamento possui ficou bloqueado e será analisado pela nossa equipe interna.<br>
					cMsg += 'Em breve você receberá uma outra mensagem informando que o orçamento já está liberado para acesso.<br><br>
		
					cMsg += 'Atenciosamente,<br>
					cMsg += 'Steck Indústria Elétrica Ltda
					cMsg += '</body></html>'
		
					U_STMAILTES(_cEmail,_cCopia,_cAssunto,cMsg,cAttach)
				
				EndIf

			EndIf

		EndIf

	Else

		DisarmTransaction()

		AutoGrLog("[WSPRTCLI][InserePed]" + "Erro ao Inserrir Registro "+Alltrim(cLogErro))
		AutoGrLog("")
		AutoGrLog(Replicate("-", 80))	

		cLogFile := "\LOGS\"+"PEDIDOPORTAL_"+(_cAlias1)->A1_COD+(_cAlias1)->A1_LOJA+dtos(date())+time()+".log"
		cArqLog := ""
		aLog := GetAutoGRLog()
		
		cErroRet := ""
		cProduto := ""
		cDescrProd := ""

		Conout("Gravando o Log retornodo pelo WS INSEREPED")
		
		For nX := 1 To Len(aLog)	
			cArqLog += aLog[nX]+CHR(13)+CHR(10)
			If At("Invalido",cArqLog) > 0
				If At("UA_",Substr(cArqLog,At("Invalido",cArqLog)-45,53)) > 0
					cErroRet :=	"Conteúdo inválido informado para o campo : " + Substr(cArqLog,At("Invalido",cArqLog)-45,53)
				ElseIf  At("UB_",Substr(cArqLog,At("Invalido",cArqLog)-46,53)) > 0				
					
					If(Alltrim(Substr(cArqLog,At("UB_PRODUTO",cArqLog),Len("UB_PRODUTO")))) == "UB_PRODUTO"
						cProduto   := Alltrim(Substr(cArqLog,At("UB_PRODUTO",cArqLog) + 11,30))
						cProduto   := Alltrim(Substr(cProduto,At(":=",cProduto)+2,15))
						cDescrProd := Posicione("SB1",1,xFilial("SB1") + Alltrim(cProduto) ,"B1_DESC" )
					EndIf
					
					If(Alltrim(Substr(cArqLog,At("UB_QUANT",cArqLog),10))) == "UB_QUANT" .And. At("UB_QUANT",Substr(cArqLog,At("Invalido",cArqLog)-46,53)) > 0
						if !Empty(cProduto)
							cErroRet := "Conteúdo inválido informado para o campo : "  + "Quantidade" 
							cErroRet += "Produto: " + cProduto  +   " - " + cDescrProd
							cErroRet += "A quantidade informada é inválida ou nção pertence ao múltiplo do produto"
						Else
							cErroRet := "Conteúdo inválido informado para o campo : "  + "Quantidade" 
							cErroRet += "A quantidade informada é inválida ou nção pertence ao múltiplo do produto"
						EndIf
					elseIf(Alltrim(Substr(cArqLog,At("UB_VRUNIT",cArqLog),10))) == "UB_VRUNIT" .And. At("UB_VRUNIT",Substr(cArqLog,At("Invalido",cArqLog)-46,53)) > 0
						if !Empty(cProduto)
							cErroRet := "Conteúdo inválido informado para o campo : "  + "Valor Unitário" 
							cErroRet += "Produto: " + cProduto  +   " - " + cDescrProd
							cErroRet += "O Preço unitário é inválido ou está fora do valor mínimo para o produto."
						Else
							cErroRet := "Conteúdo inválido informado para o campo : "  + "Valor Unitário" 
							cErroRet += "A quantidade informada é inválida ou nção pertence ao múltiplo do produto."
						EndIf						
					Else	 
						If !Empty(Alltrim(cDescrProd))
							cErroRet :=	cProduto + "-" + cDescrProd + " "
							cErroRet += Substr(cArqLog,At("Invalido",cArqLog)-57,65) + cDescrProd	 	
						else
							cErroRet := Substr(cArqLog,At("Invalido",cArqLog)-57,65) 
						EndIf				
					EndIf					
				EndIf
			else
					
				If At("Erro no item",Alltrim(cArqLog)) > 0
					If(Alltrim(Substr(cArqLog,At("UB_PRODUTO",cArqLog),Len("UB_PRODUTO")))) == "UB_PRODUTO"
						cProduto   := Alltrim(Substr(cArqLog,At("UB_PRODUTO",cArqLog)+11,30))
						cProduto   := Alltrim(Substr(cProduto,At(":=",cProduto)+2,15))
						cDescrProd := Posicone("SB1",1,xFilial("SB1") + Alltrim(cProduto) ,"B1_DESC" )
					EndIf
					cErroRet :=  Substr(cArqLog,At("Erro no item",cArqLog),20) 
					cErroRet += "Produto" + cProduto + " - " + cDescrProd + " "
					cErroRet += Substr(cArqLog,1,135)
					
				else
					cErroRet := Substr(cArqLog,1,135)	
							
				EndIf	
			Endif
		Next nX
	
		lRet := MemoWrite(cLogFile, cArqLog)

		//If lRet
		Conout("Gravando o Log retornodo pelo WS INSEREPED" + cLogFile)
		If !Empty(Alltrim(cErroRet))
			_cRetorno := "[WSPRTCLI][InserePed]" + "Erro ao Inserrir Registro "  + ENTER + cErroRet			
		Else
			_cRetorno := cArqLog	
		EndIf
		//Else
		//	_cRetorno := "[ERRO] - "+MostraErro("LOGS","PEDIDOPORTAL_"+(_cAlias1)->A1_COD+(_cAlias1)->A1_LOJA+dtos(date())+time()+".log")
		//EndIf
		DisarmTransaction()
	Endif

	If _nOpc==4
		cLock := "SUA"+xFilial("SUA")+oXml:_PEDIDO:_COTACAO:TEXT
		UnLockByName(cLock,.T.,FWModeAccess("SUA",3) == "E",.T.)
	EndIf

	End Transaction

	Conout("[WSPRTCLI][InserePed]"+FWTimeStamp(2)+" - Fim da alteração/inserção do orçamento!")

	U_STZ1B("InserePed","","InserePed","portal","",,::_cEmail)

	::_cXml := _cRetorno

Return .T.

WSMETHOD CalculaPed WSRECEIVE _cLogin,_cXmlRec,_cEmail WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cXml 		:= ::_cXmlRec
	Local cAviso		:= ""
	Local cErro			:= ""
	Local _cNumZT		:= ""
	Local _cQuery1		:= ""
	Local _cAlias1		:= GetNextAlias()
	Local _cRetorno		:= "<calculaped>"
	Local _nX			:= 0
	Local _nTotal		:= 0
	Local _nTotalF		:= 0
	Local _nQtdProds	:= 0
	Local _lSemPrc		:= .F.
	Local _cSemPrc  	:= ""
	Local _aTodos       :={}
	Private _lPrtCli	:= .T.
	Private _cConsumo   :=""

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	oXml := XmlParser(_cXml,"_",@cAviso,@cErro)

	Conout(cAviso)
	Conout(cErro)

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SA1")+" A1
	_cQuery1 += " WHERE A1.D_E_L_E_T_=' ' AND A1_CGC='"+oXml:_PEDIDO:_CNPJ:TEXT+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		_cRetorno := "Cliente não encontrado, entre em contato com a Steck!"
		::_cXml := _cRetorno
		Return .T.
	EndIf

	_nValCif := (_cAlias1)->A1_XCIF

	_cItem := "00"

    _cConsumo  := AllTrim(oXml:_PEDIDO:_TPCONSUM:TEXT)

	DbSelectArea("Z38")
	_cNumero := GetSXENum("Z38","Z38_NUM")

	Z38->(RecLock("Z38",.T.))
	Z38->Z38_FILIAL := cFilAnt
	Z38->Z38_NUM    := _cNumero
	Z38->Z38_COD	:= (_cAlias1)->A1_COD
	Z38->Z38_LOJ	:= (_cAlias1)->A1_LOJA
	Z38->Z38_NOME	:= (_cAlias1)->A1_NOME
	Z38->Z38_CNPJ	:= (_cAlias1)->A1_CGC
	Z38->Z38_OPER   := oXml:_PEDIDO:_TPOPER:TEXT
	Z38->Z38_CONDPG := oXml:_PEDIDO:_CONDPG:TEXT
	Z38->Z38_TPFRET := oXml:_PEDIDO:_TPFRETE:TEXT
	//Z38->Z38_CPROP 	:= oXml:_PEDIDO:_TPFRETE:TEXT
	Z38->Z38_TPENT	:= oXml:_PEDIDO:_TPENT:TEXT
	Z38->Z38_TRANSP := oXml:_PEDIDO:_TRANSP:TEXT
	Z38->Z38_TPFAT  := oXml:_PEDIDO:_TPFAT:TEXT
	Z38->Z38_OBS    := oXml:_PEDIDO:_OBS:TEXT
	//Z38->Z38_OC     := oXml:_PEDIDO:_OC:TEXT
	Z38->Z38_DATA  	:= Date()
	Z38->Z38_HORA  	:= Time()
	Z38->(MsUnLock())

	DbSelectArea("Z39")

	_cRetorno += "<produtos>"
	
	_cTabela:= '001'
	_cTabela:= U_STXZ2B((_cAlias1)->A1_COD,(_cAlias1)->A1_LOJA)
	Conout(_cTabela)

	Do Case

	Case Type("oXml:_PEDIDO:_PRODUTOS:_PRODUTO")=="O"

		_nQtdProds := 1

	Case Type("oXml:_PEDIDO:_PRODUTOS:_PRODUTO")=="A"

		_nQtdProds := 2

	EndCase

	If _nQtdProds==1

		Z39->(RecLock("Z39",.T.))
		Z39->Z39_FILIAL := cFilAnt
		Z39->Z39_NUM    := _cNumero
		Z39->Z39_COD    := (_cAlias1)->A1_COD
		Z39->Z39_LOJA   := (_cAlias1)->A1_LOJA
		Z39->Z39_DATA   := Date()
		Z39->Z39_HORA   := Time()
		Z39->Z39_ITEM   := AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_ITEM:TEXT)
		Z39->Z39_CODPRO := AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT)
		Z39->Z39_DESCPR := AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_DESC:TEXT)
		Z39->Z39_BARPRO := ""
		Z39->Z39_QTDE   := Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_QTDE:TEXT)
		Z39->Z39_DESC   := Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_DESC:TEXT)
		Z39->Z39_OC     := oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_NUMOC:TEXT
		Z39->Z39_ITEMOC := oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_ITEMOC:TEXT
		Z39->(MsUnLock())

		//_cItem := Soma1(_cItem)
		
		// _nPreco := U_STRETSST("01",(_cAlias1)->A1_COD,(_cAlias1)->A1_LOJA,AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT),oXml:_PEDIDO:_CONDPG:TEXT,'PRECO',.F.,,,_cTabela)
		// _nIPI   := U_STRETSST("01",(_cAlias1)->A1_COD,(_cAlias1)->A1_LOJA,AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT),oXml:_PEDIDO:_CONDPG:TEXT,'IPI')
		// _nIcmSt := U_STRETSST("01",(_cAlias1)->A1_COD,(_cAlias1)->A1_LOJA,AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT),oXml:_PEDIDO:_CONDPG:TEXT,'ST')
        _aTodos:={} 
 		_aTodos:=U_STRETSST("01",(_cAlias1)->A1_COD,(_cAlias1)->A1_LOJA,AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT),oXml:_PEDIDO:_CONDPG:TEXT,'TUDO',.F.,(_cAlias1)->A1_TIPO,_cConsumo,_cTabela)
		if ValType(_aTodos)=="A"
		   IF LEN(_aTodos)>0
		      // 1 Preco Unitario 
		      // 2 Valor IPI 
		      // 3 Valor ST. 
		      // 4 Aliquota IPI 
		      // 5 Aliquota ST. 
		      // 6 Aliq.ICMS
		      // 7 TES. 
	          _nPreco :=_aTodos[1]
		      _nIpi   :=_aTodos[2]
		      _nIcmSt :=_aTodos[3]
		      _nAIPI  :=_aTodos[4]
		      _nAST  := _aTodos[5]
		   ELSE 
	          _nPreco :=0
		      _nIpi   :=0
		      _nIcmSt :=0
		      _nAIPI  :=0
		      _nAST   :=0
		   ENDIF
		ELSE 
           _nPreco :=0
		   _nIpi   :=0
		   _nIcmSt :=0
		   _nAIPI  :=0
		   _nAST   :=0
		ENDIF   

		If Type("_nPreco")=="U"
			_nPreco := 0.01
		EndIf
		If _nPreco<=0.01
			_lSemPrc := .T.
			_cSemPrc += AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT)+" "
			_nIPI := 0
			_nIcmSt := 0
		EndIf

		_cRetorno += "<produto>"
		_cRetorno += "<item>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_ITEM:TEXT)+"</item>"
		_cRetorno += "<prod>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT)+"</prod>"
		_cRetorno += "<desc>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_DESC:TEXT)+"</desc>"
		_cRetorno += "<qtde>"+oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_QTDE:TEXT+"</qtde>"
		_cRetorno += "<oc>"+oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_NUMOC:TEXT+"</oc>"
		_cRetorno += "<itemoc>"+oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_ITEMOC:TEXT+"</itemoc>"

		_nvDesc := 0
		_nPDesc := GetMv("ST_WSPRT02",,0)

		If _nPDesc>0
			_nvDesc	:= Round(((	_nPDesc*_nPreco)/100),2)
			_nPreco := Round(_nPreco - _nvDesc,2)
		EndIf

		_cRetorno += "<preco>"+CVALTOCHAR(_nPreco)+"</preco>"
		//_cRetorno += "<desconto>"+CVALTOCHAR(_nPDesc)+"</desconto>"
		_cRetorno += "<ipi>"+CVALTOCHAR(_nIPI)+"</ipi>"
		_cRetorno += "<aliqipi>"+CVALTOCHAR(_nAIPI)+"</aliqipi>"
		_cRetorno += "<icmst>"+CVALTOCHAR(_nIcmSt)+"</icmst>"
		_cRetorno += "<aliqst>"+CVALTOCHAR(Round(_nAST,2))+"</aliqst>"

		_nQtde  := Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_QTDE:TEXT)
		_nTotal := _nQtde*_nPreco
		_nTotal += _nQtde*_nIPI
		_nTotal += _nQtde*_nIcmSt

		_nTotalF += _nTotal

		_cRetorno += "<total>"+CVALTOCHAR(_nTotal)+"</total>"
		_cRetorno += "<obs>"+GETOBS(AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT),Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_QTDE:TEXT))+"</obs>"

		_nSaldo			:= u_versaldo(AllTrim(AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT)))
		_dDtEntrega		:= u_atudtentre(_nSaldo,AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT),Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_QTDE:TEXT),'PORTAL','XX')
		_dDtEntrega		:= CVALTOCHAR(DateDiffDay(Date(),_dDtEntrega))+" dias corridos"

		_cRetorno += "<dtent>"+_dDtEntrega+"</dtent>
		_cRetorno += "</produto>"

	Else

		For _nX:=1 To Len(oXml:_PEDIDO:_PRODUTOS:_PRODUTO)

			Z39->(RecLock("Z39",.T.))
			Z39->Z39_FILIAL := cFilAnt
			Z39->Z39_NUM    := _cNumero
			Z39->Z39_COD    := (_cAlias1)->A1_COD
			Z39->Z39_LOJA   := (_cAlias1)->A1_LOJA
			Z39->Z39_DATA   := Date()
			Z39->Z39_HORA   := Time()
			Z39->Z39_ITEM   := AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_ITEM:TEXT)
			Z39->Z39_CODPRO := AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT)
			Z39->Z39_DESCPR := AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_DESC:TEXT)
			Z39->Z39_BARPRO := ""
			Z39->Z39_QTDE   := Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_QTDE:TEXT)
			Z39->Z39_DESC   := Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_DESC:TEXT)
			Z39->Z39_OC     := oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_NUMOC:TEXT
			Z39->Z39_ITEMOC := oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_ITEMOC:TEXT
			Z39->(MsUnLock())

			//_nPreco	:= U_STRETSST("01",(_cAlias1)->A1_COD,(_cAlias1)->A1_LOJA,AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT),oXml:_PEDIDO:_CONDPG:TEXT,'PRECO',.F.,,,_cTabela)
			//_nIPI	:= U_STRETSST("01",(_cAlias1)->A1_COD,(_cAlias1)->A1_LOJA,AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT),oXml:_PEDIDO:_CONDPG:TEXT,'IPI')
			//_nIcmSt	:= U_STRETSST("01",(_cAlias1)->A1_COD,(_cAlias1)->A1_LOJA,AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT),oXml:_PEDIDO:_CONDPG:TEXT,'ST')

	        _nPreco :=0
		    _nIpi   :=0
		    _nIcmSt :=0
		    _nAIPI  :=0
		    _nAST   :=0
            
			_aTodos:={} 
            _aTodos:=U_STRETSST("01",(_cAlias1)->A1_COD,(_cAlias1)->A1_LOJA,AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT),oXml:_PEDIDO:_CONDPG:TEXT,'TUDO',.F.,(_cAlias1)->A1_TIPO,_cConsumo,_cTabela)
            
			if ValType(_aTodos)=="A"
			   IF LEN(_aTodos)>0
		          // 1 Preco Unitario 
		          // 2 Valor IPI 
		          // 3 Valor ST. 
		          // 4 Aliquota IPI 
		          // 5 Aliquota ST. 
		          // 6 Aliq.ICMS
		          // 7 TES. 

	              _nPreco :=_aTodos[1]
		          _nIpi   :=_aTodos[2]
		          _nIcmSt :=_aTodos[3]
		          _nAIPI  :=_aTodos[4]
		          _nAST  := _aTodos[5]
		       ELSE 
	              _nPreco :=0
		          _nIpi   :=0
		          _nIcmSt :=0
		          _nAIPI  :=0
		          _nAST   :=0
		       ENDIF
            ELSE 
              _nPreco :=0
	          _nIpi   :=0
	          _nIcmSt :=0
	          _nAIPI  :=0
	          _nAST   :=0
			ENDIF

			If Type("_nPreco")=="U"
				_nPreco := 0.01
			EndIf
			If _nPreco<=0.01
				_lSemPrc := .T.
				_cSemPrc += AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT)+" "
				_nIPI := 0
				_nIcmSt := 0
			EndIf

			_cRetorno += "<produto>"
			_cRetorno += "<item>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_ITEM:TEXT)+"</item>"
			_cRetorno += "<prod>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT)+"</prod>"
			_cRetorno += "<desc>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_DESC:TEXT)+"</desc>"
			_cRetorno += "<qtde>"+oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_QTDE:TEXT+"</qtde>"
			_cRetorno += "<oc>"+oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_NUMOC:TEXT+"</oc>"
			_cRetorno += "<itemoc>"+oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_ITEMOC:TEXT+"</itemoc>"

			_nvDesc := 0
			_nPDesc := GetMv("ST_WSPRT02",,0)

			If _nPDesc>0
				_nvDesc	:= Round(((	_nPDesc*_nPreco)/100),2)
				_nPreco := Round(_nPreco - _nvDesc,2)
			EndIf

			_cRetorno += "<preco>"+CVALTOCHAR(_nPreco)+"</preco>"
			//_cRetorno += "<desconto>"+CVALTOCHAR(_nPDesc)+"</desconto>"
			_cRetorno += "<ipi>"+CVALTOCHAR(_nIPI)+"</ipi>"
			_cRetorno += "<aliqipi>"+CVALTOCHAR(_nAIPI)+"</aliqipi>"
			_cRetorno += "<icmst>"+CVALTOCHAR(_nIcmSt)+"</icmst>"
			_cRetorno += "<aliqst>"+CVALTOCHAR(Round(_nAST,2))+"</aliqst>"

			_nQtde  := Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_QTDE:TEXT)
			_nTotal := _nQtde*_nPreco
			_nTotal += _nQtde*_nIPI
			_nTotal += _nQtde*_nIcmSt

			_nTotalF += _nTotal

			_cRetorno += "<total>"+CVALTOCHAR(_nTotal)+"</total>"
			_cRetorno += "<obs>"+GETOBS(AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT),Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_QTDE:TEXT))+"</obs>"

			_nSaldo			:= u_versaldo(AllTrim(AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT)))
			_dDtEntrega		:= u_atudtentre(_nSaldo,AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT),Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_QTDE:TEXT),'PORTAL','XX')
			_dDtEntrega		:= CVALTOCHAR(DateDiffDay(Date(),_dDtEntrega))+" dias corridos"

			_cRetorno += "<dtent>"+_dDtEntrega+"</dtent>

			_cRetorno += "</produto>"

		Next _nX

	EndIf

	_cRetorno += "</produtos>"

	_cRetorno += "<cabecalho>"
	_cRetorno += "<cliente>"+(_cAlias1)->A1_COD+"</cliente>"
	_cRetorno += "<loja>"+(_cAlias1)->A1_LOJA+"</loja>"
	_cRetorno += "<nome>"+(_cAlias1)->A1_NOME+"</nome>"
	_cRetorno += "<cnpj>"+(_cAlias1)->A1_CGC+"</cnpj>"

	DbSelectArea("SE4")
	SE4->(DbSetOrder(1))
	SE4->(DbSeek(xFilial("SE4")+oXml:_PEDIDO:_CONDPG:TEXT))

	_cRetorno += "<condpg>"+oXml:_PEDIDO:_CONDPG:TEXT+" - "+AllTrim(SE4->E4_DESCRI)+"</condpg>"

	_cTpEnt := AllTrim(oXml:_PEDIDO:_TPENT:TEXT)

	If AllTrim(_cTpEnt)=="1"
		_cTpEnt += " - Retira"
	Else
		_cTpEnt += " - Entrega"
	EndIf

	_cRetorno += "<tpent>"+_cTpEnt+"</tpent>"

	_cTpConsum := AllTrim(oXml:_PEDIDO:_TPCONSUM:TEXT)
	
	If AllTrim(_cTpConsum)=="1"
		_cTpConsum += " - Não"
	Else
		_cTpConsum += " - Sim"
	EndIf

	_cRetorno += "<tpconsum>"+_cTpConsum+"</tpconsum>"

	_cTpFat := AllTrim(oXml:_PEDIDO:_TPFAT:TEXT)

	If AllTrim(_cTpFat)=="1"
		_cTpFat += " - Total"
	Else
		_cTpFat += " - Parcial"
	EndIf

	_cRetorno += "<tpfat>"+_cTpFat+"</tpfat>"

	_cTpFrete := AllTrim(oXml:_PEDIDO:_TPFRETE:TEXT)

	If _nValCif>0
		If _nTotalF<_nValCif
			_cTpFrete := "F"
		EndIf
	EndIf

	If _cTpFrete=="C"
		_cTpFrete += " - CIF"
	Else
		_cTpFrete += " - FOB"
	EndIf

	_cRetorno += "<tpfrete>"+_cTpFrete+"</tpfrete>"

	_cTransp := oXml:_PEDIDO:_TRANSP:TEXT

	If !Empty(_cTransp)

		DbSelectArea("SA4")
		SA4->(DbSetOrder(1))
		If SA4->(DbSeek(xFilial("SA4")+_cTransp))
			_cTransp += " - "+SA4->A4_NOME
		EndIf

	EndIf

	_cRetorno += "<transp>"+_cTransp+"</transp>"
	_cRetorno += "<nomtransp>TESTE</nomtransp>"
	_cRetorno += "<obs>"+oXml:_PEDIDO:_OBS:TEXT+"</obs>"
	_cRetorno += "<totprods>"+CVALTOCHAR(_nQtdProds)+"</totprods>"
	_cRetorno += "</cabecalho>"

	_cRetorno += "<totais>"

	_cAlerta := "."
	If _lSemPrc
		_cAlerta := "(EXISTEM PRODUTOS SEM PREÇO E ESSE ORÇAMENTO FICARÁ SOB CONSULTA)"
	EndIf

	_cRetorno += "<valortotal>R$ "+Transform(_nTotalF,"@E 999,999,999.99")+"</valortotal>"
	_cRetorno += "<alerta>"+_cAlerta+"</alerta>"
	_cRetorno += "<semprc>"+IIf(Empty(_cSemPrc),".",_cSemPrc)+"</semprc>"
	_cRetorno += "</totais>"
	_cRetorno += "</calculaped>"

	Conout(_cRetorno)
	_cRetorno := U_STTIRAGR(_cRetorno)

	Z38->(ConfirmSX8())

	U_STZ1B("CalculaPed","","CalculaPed","portal","",,::_cEmail)

	::_cXml := _cRetorno

Return .T.

WSMETHOD ConsultaPrz WSRECEIVE _cLogin,_cXmlRec,_cEmail WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cXml 	:= ::_cXmlRec
	Local cAviso	:= ""
	Local cErro		:= ""
	Local _cNumZT	:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cRetorno	:= "<consultaprz>"
	Local _nX		:= 0
	Local _nTotal	:= 0
	Local _nTotalF	:= 0
	Local _nQtdProds:= 0
	Local _lSemPrc	:= .F.
	Local _nTotProds:= 0

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	oXml := XmlParser(_cXml,"_",@cAviso,@cErro)

	Conout(cAviso)
	Conout(cErro)

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SZR")+" ZR
	_cQuery1 += " WHERE ZR.D_E_L_E_T_=' ' AND UPPER(ZR_EMAIL)='"+Upper(::_cEmail)+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		_cRetorno := "Cadastro não encontrado, entre em contato com a Steck!"
		::_cXml := _cRetorno
		Return .T.
	Else
		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))

		If Empty((_cAlias1)->ZR_LOJA)
			_cLoja := "01"
		Else
			_cLoja := (_cAlias1)->ZR_LOJA
		EndIf

		If (_cAlias1)->ZR_TPUSER=="C"
			If !SA1->(DbSeek(xFilial("SA1")+(_cAlias1)->ZR_CODIGO+_cLoja))
				_cRetorno := "Cliente não encontrado, entre em contato com a Steck!"
				::_cXml := _cRetorno
				Return .T.
			EndIf
		EndIf

	EndIf

	_cItem := "00"

	Do Case
	Case Type("oXml:_PEDIDO:_PRODUTOS:_PRODUTO")=="O"
		_nQtdProds := 1
	Case Type("oXml:_PEDIDO:_PRODUTOS:_PRODUTO")=="A"
		_nQtdProds := 2
	EndCase

	DbSelectArea("Z38")
	_cNumero := GetSXENum("Z38","Z38_NUM")

	Z38->(RecLock("Z38",.T.))
	Z38->Z38_FILIAL := cFilAnt
	Z38->Z38_NUM    := _cNumero

	If (_cAlias1)->ZR_TPUSER=="C"
		Z38->Z38_COD	:= SA1->A1_COD
		Z38->Z38_LOJ	:= SA1->A1_LOJA
		Z38->Z38_NOME	:= SA1->A1_NOME
		Z38->Z38_CNPJ	:= SA1->A1_CGC
	Else
		Z38->Z38_COD	:= (_cAlias1)->ZR_LOGIN
		Z38->Z38_LOJ	:= ""
		Z38->Z38_NOME	:= (_cAlias1)->ZR_NOME
		Z38->Z38_CNPJ	:= ""
	EndIf
	Z38->Z38_DATA  	:= Date()
	Z38->Z38_HORA  	:= Time()
	Z38->(MsUnLock())

	DbSelectArea("Z39")

	_cRetorno += "<produtos>"

	If _nQtdProds==1

		_lAchou := .T.

		AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT) := Upper(AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT))
		If !SB1->(DbSeek(xFilial("SB1")+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT)))
			_lAchou := .F.
		EndIf

		_nTotProds := 1

		Z39->(RecLock("Z39",.T.))
		Z39->Z39_FILIAL := cFilAnt
		Z39->Z39_NUM    := _cNumero
		If (_cAlias1)->ZR_TPUSER=="C"
			Z39->Z39_COD    := SA1->A1_COD
			Z39->Z39_LOJA   := SA1->A1_LOJA
		Else
			Z38->Z38_COD	:= (_cAlias1)->ZR_LOGIN
			Z38->Z38_LOJ	:= ""
		EndIf
		Z39->Z39_DATA   := Date()
		Z39->Z39_HORA   := Time()
		Z39->Z39_ITEM   := AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_ITEM:TEXT)
		Z39->Z39_CODPRO := AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT)
		Z39->Z39_DESCPR := AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_DESC:TEXT)
		Z39->Z39_BARPRO := ""
		Z39->Z39_QTDE   := Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_QTDE:TEXT)
		Z39->(MsUnLock())

		_cRetorno += "<produto>"
		_cRetorno += "<item>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_ITEM:TEXT)+"</item>"
		_cRetorno += "<prod>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT)+"</prod>"
		_cRetorno += "<desc>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_DESC:TEXT)+"</desc>"
		_cRetorno += "<ean>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_EAN:TEXT)+"</ean>"
		_cRetorno += "<ncm>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_NCM:TEXT)+"</ncm>"
		_cRetorno += "<qtdlot>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_QTDELOT:TEXT)+"</qtdlot>"
		_cRetorno += "<qtde>"+oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_QTDE:TEXT+"</qtde>"

		If _lAchou
			_nSaldo			:= u_versaldo(AllTrim(AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT)))
			_dDtEntrega		:= u_atudtentre(_nSaldo,AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_CODIGO:TEXT),Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO:_QTDE:TEXT),'PORTAL','XX')
			_dDtEntrega		:= CVALTOCHAR(DateDiffDay(Date(),_dDtEntrega)+1)+" dias corridos"
			_cRetorno += "<dtent>"+_dDtEntrega+"</dtent>
		Else
			_cRetorno += "<dtent>Produto nao encontrado</dtent>
		EndIf
		_cRetorno += "</produto>"

	Else

		_nTotProds := Len(oXml:_PEDIDO:_PRODUTOS:_PRODUTO)

		For _nX:=1 To Len(oXml:_PEDIDO:_PRODUTOS:_PRODUTO)

			_lAchou := .T.

			AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT) := Upper(AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT))
			If !SB1->(DbSeek(xFilial("SB1")+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT)))
				_lAchou := .F.
			EndIf

			Z39->(RecLock("Z39",.T.))
			Z39->Z39_FILIAL := cFilAnt
			Z39->Z39_NUM    := _cNumero
			If (_cAlias1)->ZR_TPUSER=="C"
				Z39->Z39_COD    := SA1->A1_COD
				Z39->Z39_LOJA   := SA1->A1_LOJA
			Else
				Z38->Z38_COD	:= (_cAlias1)->ZR_LOGIN
				Z38->Z38_LOJ	:= ""
			EndIf
			Z39->Z39_DATA   := Date()
			Z39->Z39_HORA   := Time()
			Z39->Z39_ITEM   := AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_ITEM:TEXT)
			Z39->Z39_CODPRO := AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT)
			Z39->Z39_DESCPR := AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_DESC:TEXT)
			Z39->Z39_BARPRO := ""
			Z39->Z39_QTDE   := Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_QTDE:TEXT)
			Z39->(MsUnLock())

			_cRetorno += "<produto>"
			_cRetorno += "<item>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_ITEM:TEXT)+"</item>"
			_cRetorno += "<prod>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT)+"</prod>"
			_cRetorno += "<desc>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_DESC:TEXT)+"</desc>"
			_cRetorno += "<ean>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_EAN:TEXT)+"</ean>"
			_cRetorno += "<ncm>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_NCM:TEXT)+"</ncm>"
			_cRetorno += "<qtdlot>"+AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_QTDELOT:TEXT)+"</qtdlot>"
			_cRetorno += "<qtde>"+oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_QTDE:TEXT+"</qtde>"

			If _lAchou
				_nSaldo			:= u_versaldo(AllTrim(AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT)))
				_dDtEntrega		:= u_atudtentre(_nSaldo,AllTrim(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_CODIGO:TEXT),Val(oXml:_PEDIDO:_PRODUTOS:_PRODUTO[_nX]:_QTDE:TEXT),'PORTAL','XX')
				_dDtEntrega		:= CVALTOCHAR(DateDiffDay(Date(),_dDtEntrega)+1)+" dias corridos"
				_cRetorno += "<dtent>"+_dDtEntrega+"</dtent>
			Else
				_cRetorno += "<dtent>Produto nao encontrado</dtent>
			EndIf

			_cRetorno += "</produto>"

		Next _nX

	EndIf

	_cRetorno += "</produtos>"

	_cRetorno += "<cabecalho>"
	_cRetorno += "<totprods>"
	_cRetorno += cValToChar(_nTotProds)
	_cRetorno += "</totprods>"
	_cRetorno += "</cabecalho>"

	_cRetorno += "</consultaprz>"

	Conout(_cRetorno)

	Z38->(ConfirmSX8())

	U_STZ1B("ConsultaPrz","","ConsultaPrz","portal","",,::_cEmail)

	::_cXml := _cRetorno

Return .T.

WSMETHOD GetSa4 WSRECEIVE _cLogin WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cQuery1 			:= ""
	Local _cAlias1			:= GetNextAlias()
	Local _cRetorno			:= "<transportadoras>"
	Local _cTabela			:= ""

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SA4")+" A4
	_cQuery1 += " WHERE A4.D_E_L_E_T_=' ' AND A4_MSBLQL='2'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_cRetorno += "<transportadora>
		_cRetorno += "<A4_COD>"+AllTrim((_cAlias1)->A4_COD)+"</A4_COD>"
		_cRetorno += "<A4_NOME>"+U_STTIRAGR(AllTrim((_cAlias1)->A4_NOME))+"</A4_NOME>"
		_cRetorno += "<A4_XSTEENT>"+(_cAlias1)->A4_XSTEENT+"</A4_XSTEENT>"
		_cRetorno += "<A4_MSBLQL>"+(_cAlias1)->A4_MSBLQL+"</A4_MSBLQL>"
		_cRetorno += "<A4_XCIF>"+(_cAlias1)->A4_XCIF+"</A4_XCIF>"
		_cRetorno += "</transportadora>

		(_cAlias1)->(DbSkip())
	EndDo

	_cRetorno += "</transportadoras>"

	Conout(_cRetorno)

	::_cXml := _cRetorno

Return .T.

/*====================================================================================\
|Programa  | GETOBS           | Autor | Renato Nogueira            | Data | 16/11/2016|
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function GETOBS(_cProduto,_nQuant)

	Local _cRetorno 		:= "OK"
	Local _cGrpStella	  	:= GetMv("ST_QUANV01",,'105')

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	If SB1->(DbSeek(xFilial("SB1")+_cProduto))
		If SB1->B1_XLM  > 0
			If   SB1->B1_XTIPLM $ 'M'

				If 		(SUBSTR(SA1->A1_GRPVEN,1,1)=="C" .And. SB1->B1_XEMBC=="S") .Or.;
				(SUBSTR(SA1->A1_GRPVEN,1,1)=="D" .And. SB1->B1_XEMBD=="S") .Or.;
				(SUBSTR(SA1->A1_GRPVEN,1,1)=="E" .And. SB1->B1_XEMBE=="S") .Or.;
				(SUBSTR(SA1->A1_GRPVEN,1,1)=="I" .And. SB1->B1_XEMBI=="S") .Or.;
				(SUBSTR(SA1->A1_GRPVEN,1,1)=="R" .And. SB1->B1_XEMBR=="S")

					_nResul:= (_nQuant/SB1->B1_XLM)  - Round((_nQuant/SB1->B1_XLM),0)
						If _nResul <> 0
						_cRetorno := "ERRO - Quantidade fora do permitido, utilize multiplo de "+AllTrim(transform(SB1->B1_XLM,'@E 999,999.99'))
					EndIf

				EndIf

			Else
				If _nQuant < SB1->B1_XLM
					_cRetorno := "ERRO - Quantidade inferior ao permitido, mínimo permitido "+AllTrim(transform(SB1->B1_XLM,'@E 999,999.99'))
				EndIf
			EndIf

		EndIf
	Else
		_cRetorno := "ERRO - Produto não encontrado"
	EndIf

Return(_cRetorno)

WSMETHOD GetOrcs WSRECEIVE _cLogin,_cNome,_cCliente,_cEmail WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cRet 	:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cQuery2	:= ""
	Local _cAlias2	:= GetNextAlias()
	Local _cNome	:= ::_cNome
	Local _cCliente := SubStr(::_cCliente,1,6)
	Local _cLoja 	:= SubStr(::_cCliente,7,2)
	Local _nX

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	_cQuery1 := " SELECT UA_NUM, UA_EMISSAO, UA_CONDPG, UA_VALBRUT, UA_XORDEM, UA_NUMSC5, UA_XORIG
	_cQuery1 += " FROM "+RetSqlName("SUA")+" UA
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON A1_COD=UA_CLIENTE AND A1_LOJA=UA_LOJA
	_cQuery1 += " WHERE UA.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' '
	_cQuery1 += " AND UA_FILIAL='01' AND UA_EMISSAO>'"+DTOS(MonthSub(Date(),6))+"'

	If !Empty(::_cCliente)
		_cQuery1 += " AND UA_CLIENTE='"+_cCliente+"' AND A1_LOJA='"+_cLoja+"'
	Else

		_aCnpjs := U_STFAT440(::_cEmail)

		If Len(_aCnpjs)>0
			_cQuery1 += " AND (
			For _nX:=1 To Len(_aCnpjs)
					_cQuery1 += " (A1_CGC='"+_aCnpjs[_nX]+"')
				If !_nX==Len(_aCnpjs)
					_cQuery1 += " OR
				EndIf
			Next
			_cQuery1 += " )	
		Else
			If Len(AllTrim(::_cLogin))==8 //Pegar todas as filiais
				_cQuery1 += " AND SUBSTR(A1_CGC,1,8)='"+::_cLogin+"'
			Else
				_cQuery1 += " AND A1_CGC='"+::_cLogin+"'
			EndIf
		EndIf

	EndIf

	_cQuery1 += " ORDER BY UA_NUM DESC

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_nCount := 0
	INCLUI := .F.
	DbSelectArea("SUA")
	SUA->(DbSetOrder(1))

	While (_cAlias1)->(!Eof())

		_nCount++

		_cRet += '				<div class="row" id="'+AllTrim((_cAlias1)->UA_NUM)+'">

		SUA->(DbSeek(xFilial("SUA")+(_cAlias1)->UA_NUM))

		_cStatus := ""

		If SUA->UA_XBLOQ=="1"
			_cStatus := "Bloqueado"
		ElseIf SUA->UA_XBLOQ=="2"
			_cStatus := "Liberado"
		ElseIf SUA->UA_XBLOQ=="3"
			_cStatus := "Pedido gerado"
		EndIf

		If SUA->UA_XBLOQ $ "1#3" .Or. !Empty(SUA->UA_NUMSC5) .Or. !(AllTrim(SUA->UA_XORIG)=="1") .Or. !(SUA->UA_OPER=="2") .Or. (AllTrim(SUA->UA_STATUS)=="CAN")
			_cRet += '					<div class="cell" data-title="Orçamento">'+(_cAlias1)->UA_NUM+'</div>
		Else
			_cRet += '					<div class="cell" data-title="Orçamento"><a href="altera_orcamento.php?cOrcamento='+(_cAlias1)->UA_NUM+'">'+(_cAlias1)->UA_NUM+'</a></div>
		EndIf
		_cRet += '					<div class="cell" data-title="Pedido">'+(_cAlias1)->UA_NUMSC5+'</div>
		_cRet += '					<div class="cell" data-title="Emissão">'+DTOC(STOD((_cAlias1)->UA_EMISSAO))+'</div>
		_cRet += '					<div class="cell" data-title="Cond. Pagto">'+(_cAlias1)->UA_CONDPG+'</div>
		_cRet += '					<div class="cell" data-title="Ordem de compra">'+(_cAlias1)->UA_XORDEM+'</div>
		_cRet += '					<div class="cell" data-title="Valor">R$ '+Transform((_cAlias1)->UA_VALBRUT,"@E 99,999,999,999.99")+'</div>
		_cRet += '					<div class="cell" data-title="Status">'+_cStatus+'</div>
		_cRet += '					<div class="cell" data-title="Imprimir"><a href="download_orcamento.php?cChave='+(_cAlias1)->UA_NUM+'" target="_blank"><img src="./imagens/download.png"/></a></div>
		_cRet += '				</div>

		(_cAlias1)->(DbSkip())
	EndDo

	U_STZ1B("GetOrcs","","GetOrcs","portal","",,::_cEmail)

	::_cXml := _cRet

Return .T.

WSMETHOD GetOrc WSRECEIVE _cLogin,_cOrc,_cEmail WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cRetorno	:= "<getorc>"
	Local nRegs 	:= 0

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	_cQuery1 := " SELECT A1_CGC,A1_NOME,UA_OPER,UA_CONDPG,UA_TPFRETE,UA_XTIPOPV,UA_TRANSP
	_cQuery1 += " ,UA_XTIPFAT,UB_PRODUTO,B1_DESC,B1_CODBAR,UB_NUMPCOM,UB_ITEMPC,UB_QUANT, UB_XPORDEC
	_cQuery1 += " ,UB_ITEM
	_cQuery1 += " ,UA_ZOBS, UA_ZCONSUM, UA_XORDEM, (CASE WHEN B1_XLM>0 AND B1_XTIPLM='M' THEN B1_XLM ELSE 0 END) B1_XLM
	_cQuery1 += " FROM "+RetSqlName("SUA")+" UA
	_cQuery1 += " LEFT JOIN "+RetSqlName("SUB")+" UB
	_cQuery1 += " ON UA_FILIAL=UB_FILIAL AND UA_NUM=UB_NUM
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON UA_CLIENTE=A1_COD AND UA_LOJA=A1_LOJA
	_cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" B1
	_cQuery1 += " ON B1_COD=UB_PRODUTO
	_cQuery1 += " WHERE UA.D_E_L_E_T_=' ' AND UB.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' '
	_cQuery1 += " AND UA_FILIAL='"+xFilial("SUA")+"'
	_cQuery1 += " AND UA_NUM='"+::_cOrc+"'
	_cQuery1 += " ORDER BY UB_ITEM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	Count To nRegs

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		_cRetorno := "Orçamento não encontrado, entre em contato com a Steck!"
		::_cXml := _cRetorno
		Return .T.
	EndIf

	_cItem := "00"

	_cRetorno += "<cabecalho>"
	_cRetorno += "<cnpj>"+(_cAlias1)->A1_CGC+"</cnpj>"
	_cRetorno += "<nome>"+(_cAlias1)->A1_NOME+"</nome>"
	_cRetorno += "<tpoper>"+(_cAlias1)->UA_OPER+"</tpoper>"
	_cRetorno += "<condpg>"+(_cAlias1)->UA_CONDPG+"</condpg>"
	_cRetorno += "<tpfrete>"+(_cAlias1)->UA_TPFRETE+"</tpfrete>"
	_cRetorno += "<tpent>"+(_cAlias1)->UA_XTIPOPV+"</tpent>"
	_cRetorno += "<transp>"+AllTrim((_cAlias1)->UA_TRANSP+" - "+Posicione("SA4",1,xFilial("SA4")+(_cAlias1)->UA_TRANSP,"A4_NOME"))+"</transp>"
	_cRetorno += "<tpfat>"+(_cAlias1)->UA_XTIPFAT+"</tpfat>"
	_cRetorno += "<obs>"+AllTrim((_cAlias1)->UA_ZOBS)+"</obs>"
	_cRetorno += "<tpconsum>"+IIf(Empty((_cAlias1)->UA_ZCONSUM),"0",(_cAlias1)->UA_ZCONSUM)+"</tpconsum>"
	_cRetorno += "<totprods>"+CVALTOCHAR(nRegs)+"</totprods>"
	_cRetorno += "<occabec>"+(_cAlias1)->UA_XORDEM+"</occabec>"
	_cRetorno += "</cabecalho>
	_cRetorno += "<produtos>

	While (_cAlias1)->(!Eof())

		_cRetorno += "<produto>"
		_cRetorno += "<item>"+(_cAlias1)->UB_ITEM+"</item>
		_cRetorno += "<codigo>"+(_cAlias1)->UB_PRODUTO+"</codigo>
		_cRetorno += "<desc>"+(_cAlias1)->B1_DESC+"</desc>
		_cRetorno += "<ean>"+AllTrim((_cAlias1)->B1_CODBAR)+"</ean>
		_cRetorno += "<qtdlote>"+CVALTOCHAR((_cAlias1)->B1_XLM)+"</qtdlote>
		_cRetorno += "<qtde>"+CVALTOCHAR((_cAlias1)->UB_QUANT)+"</qtde>
		_cRetorno += "<oc>"+Alltrim((_cAlias1)->UB_NUMPCOM)+"</oc>
		_cRetorno += "<itemoc>"+AllTrim((_cAlias1)->UB_ITEMPC)+"</itemoc>
		_cRetorno += "<desconto>"+CVALTOCHAR((_cAlias1)->UB_XPORDEC)+"</desconto>
		_cRetorno += "</produto>"

		(_cAlias1)->(DbSkip())
	EndDo

	_cRetorno += "</produtos></getorc>

	U_STZ1B("GetOrc","","GetOrc","portal","",,::_cEmail)

	::_cXml := _cRetorno

Return .T.

WSMETHOD GetClientes WSRECEIVE _cLogin,_cNome,_cRotina WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cRet 	:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cQuery2	:= ""
	Local _cAlias2	:= GetNextAlias()
	Local _cNome	:= ::_cNome

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	_cQuery1 := " SELECT A1_COD, A1_NOME, A1_CGC, A1_LOJA
	_cQuery1 += " FROM "+RetSqlName("SA1")+" A1
	_cQuery1 += " WHERE A1.D_E_L_E_T_=' '
	_cQuery1 += " AND A1_VEND='"+::_cLogin+"'
	_cQuery1 += " AND A1_MSBLQL='2'
	_cQuery1 += " ORDER BY A1_NOME

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_cRet += '				<div class="row" id="'+AllTrim((_cAlias1)->A1_CGC)+'">
		_cRet += '					<div class="cell" data-title="CNPJ"><a href="'+AllTrim(_cRotina)+'.php?cCliente='+(_cAlias1)->(A1_COD+A1_LOJA)+'">'+(_cAlias1)->A1_CGC+'</a></div>
		_cRet += '					<div class="cell" data-title="Código">'+(_cAlias1)->A1_COD+'</div>
		_cRet += '					<div class="cell" data-title="Loja">'+(_cAlias1)->A1_LOJA+'</div>
		_cRet += '					<div class="cell" data-title="Nome">'+(_cAlias1)->A1_NOME+'</div>
		_cRet += '				</div>

		(_cAlias1)->(DbSkip())
	EndDo

	::_cXml := _cRet

Return .T.

WSMETHOD GetEmpresas WSRECEIVE _cCliente WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cXml := ""
	Local _cQuery3 	:= ""
	Local _cAlias3  := ""
	Local _cCliente := SubStr(::_cCliente,1,6)
	Local _cLoja 	:= SubStr(::_cCliente,7,2)

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	_cAlias3  := GetNextAlias()

	_cXml := "<resultado><empresas>

	_cQuery3 := " SELECT A1_CGC, A1_TRANSP, A1_TPFRET, A1_NOME, A1_NREDUZ, A1_MSBLQL, A1_ZCONDPG, A1_TIPO
	_cQuery3 += " ,A1_CONTRIB, A1_ATIVIDA, A1_INSCR
	_cQuery3 += " FROM "+RetSqlName("SA1")+" A1
	_cQuery3 += " WHERE A1.D_E_L_E_T_=' ' AND A1_COD='"+_cCliente+"' AND A1_LOJA='"+_cLoja+"'
	_cQuery3 += " AND A1_MSBLQL='2'

	If !Empty(Select(_cAlias3))
		DbSelectArea(_cAlias3)
		(_cAlias3)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

	dbSelectArea(_cAlias3)
	(_cAlias3)->(dbGoTop())

	While (_cAlias3)->(!Eof())

		cTransp 	:= AllTrim((_cAlias3)->A1_TRANSP)
		cTpFrete 	:= (_cAlias3)->A1_TPFRET

		If Empty(cTransp)
			cTransp := "000000"
		EndIf
		If Empty(cTpFrete)
			cTpFrete := "N"
		EndIf

		_cXml += "<empresa>
		_cXml += "<cnpj>"+(_cAlias3)->A1_CGC+"</cnpj>
		_cXml += "<condpg>"+(_cAlias3)->A1_ZCONDPG+"</condpg>
		_cXml += "<msblql>"+(_cAlias3)->A1_MSBLQL+"</msblql>
		_cXml += "<transp>"+cTransp+"</transp>
		_cXml += "<tpfrete>"+cTpFrete+"</tpfrete>
		_cXml += "<nome>"+(_cAlias3)->A1_NREDUZ+"</nome>
		_cXml += "<a1_tipo>"+(_cAlias3)->A1_TIPO+"</a1_tipo>
		_cXml += "<a1_contrib>"+(_cAlias3)->A1_CONTRIB+"</a1_contrib>
		_cXml += "<a1_ativida>"+(_cAlias3)->A1_ATIVIDA+"</a1_ativida>
		_cXml += "<a1_inscr>"+(_cAlias3)->A1_INSCR+"</a1_inscr>
		_cXml += "</empresa>
		(_cAlias3)->(DbSkip())
	EndDo

	_cXml += "</empresas></resultado>

	::_cXml := _cXml

Return .T.

WSMETHOD GetClientesVend WSRECEIVE _cLogin,_cNome,_cRotina WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cRet 	:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cQuery2	:= ""
	Local _cAlias2	:= GetNextAlias()
	Local _cNome	:= ::_cNome

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	_cQuery1 := " SELECT A1_COD, A1_NOME, A1_CGC, A1_LOJA
	_cQuery1 += " FROM "+RetSqlName("SA1")+" A1
	_cQuery1 += " WHERE A1.D_E_L_E_T_=' '
	_cQuery1 += " AND A1_VEND='"+::_cLogin+"'
	_cQuery1 += " AND A1_MSBLQL='2'
	_cQuery1 += " ORDER BY A1_NOME

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_cRet += '				<div class="row" id="'+AllTrim((_cAlias1)->A1_COD)+'">
		_cRet += '					<div class="cell" data-title="CNPJ"><a href="'+AllTrim(_cRotina)+'.php?cCliente='+(_cAlias1)->(A1_COD+A1_LOJA)+'">'+(_cAlias1)->A1_CGC+'</a></div>
		_cRet += '					<div class="cell" data-title="Código">'+(_cAlias1)->A1_COD+'</div>
		_cRet += '					<div class="cell" data-title="Loja">'+(_cAlias1)->A1_LOJA+'</div>
		_cRet += '					<div class="cell" data-title="Nome">'+(_cAlias1)->A1_NOME+'</div>
		_cRet += '				</div>

		(_cAlias1)->(DbSkip())
	EndDo

	::_cXml := _cRet

Return .T.

WSMETHOD GetSimilar WSRECEIVE _cLogin,_cProd,_cEmail WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cQuery1 	:= ""
	Local _cAlias1 	:= GetNextAlias()
	Local _cXml 	:= "<resultado>
	Local _nTotProds:= 0
	Local _cCodPro  := ""

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")
	
	_cCodPro := ::_cProd
	_cCodPro := StrTran(_cCodPro," ")
	_cCodPro := StrTran(_cCodPro,"-")

	_cQuery1 := " SELECT B1_COD, B1_DESC, Z37_CONCO EMPRESA, Z37_CODCOC REFCONC
	_cQuery1 += " FROM "+RetSqlName("Z37")+" Z37
	_cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" B1
	_cQuery1 += " ON B1_COD=Z37_COD
	_cQuery1 += " WHERE Z37.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' '
	_cQuery1 += " AND REPLACE(REPLACE(Z37_CODCOC,' ',''),'-','') LIKE '%"+AllTrim(UPPER(_cCodPro))+"%'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_cStatus := "0"

	If (_cAlias1)->(!Eof())

		_cStatus := "1"

		_cXml += "<produtos>

		While (_cAlias1)->(!Eof())
			_nTotProds++
			_cXml += "<produto>"+AllTrim((_cAlias1)->B1_COD)+"</produto>
			_cXml += "<descricao>"+AllTrim((_cAlias1)->B1_DESC)+"</descricao>
			_cXml += "<referencia>"+AllTrim((_cAlias1)->REFCONC)+"</referencia>
			_cXml += "<empresa>"+AllTrim((_cAlias1)->EMPRESA)+"</empresa>
			(_cAlias1)->(DbSkip())
		EndDo

		_cXml += "</produtos>

	EndIf

	_cXml += "<totprod>"+cValToChar(_nTotProds)+"</totprod>"
	_cXml += "<status>"+_cStatus+"</status>
	_cXml += "</resultado>

	U_STZ1B("GetSimilar","","GetSimilar","portal","",,::_cEmail)

	::_cXml := _cXml

Return .T.

WSMETHOD BaixaOrc WSRECEIVE _cOrc,_cEmail WSSEND _cXml WSSERVICE WSPRTCLI

	Local cRet 		:= "<baixarorc>"
	Local cChave 	:= ::_cChave
	Local _cQuery2	:= ""
	Local _cAlias2	:= GetNextAlias()
	Local _cNome	:= ::_cNome

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	DbSelectArea("SUA")
	SUA->(DbSetOrder(1))
	If !SUA->(DbSeek(xFilial("SUA")+::_cOrc))

		cRet += "<status>0</status>"
		cRet += "<descricao>Orçamento não encontrado, entre em contato com a Steck!</descricao>"

	Else

		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SUA->(UA_CLIENTE+UA_LOJA)))

		If U_RSTFAT11(.T.)
			cRet += "<status>1</status>"
			cRet += "<descricao></descricao>"
		Else
			cRet += "<status>0</status>"
			cRet += "<descricao>Orçamento bloqueado, não será possível imprimir!</descricao>"
		EndIf

		cRet += "</baixarorc>"

	EndIf

	U_STZ1B("BaixaOrc","","BaixaOrc","portal","",,::_cEmail)

	::_cXml := cRet

Return .T.

WSMETHOD EnviarTermo WSRECEIVE _cEmail,_cIp WSSEND _cXml WSSERVICE WSPRTCLI

	Local cRet 		:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SZR")+" ZR
	_cQuery1 += " WHERE ZR.D_E_L_E_T_=' ' AND UPPER(ZR_EMAIL)='"+Upper(::_cEmail)+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		cRet := "ERRO"
	Else

		DbSelectArea("SZR")
		SZR->(DbGoTop())
		SZR->(DbGoTo((_cAlias1)->R_E_C_N_O_))
		If SZR->(!Eof())

			SZR->(RecLock("SZR",.F.))
			SZR->ZR_DTACEIT := Date()
			SZR->ZR_HRACEIT := Time()
			SZR->ZR_IPACEIT := ::_cIp
			SZR->(MsUnLock())

			cRet := "OK"

		EndIf

	EndIf

	U_STZ1B("ACEITETERMO","","ACEITETERMO",::_cLogin,(_cAlias1)->ZR_NOME,::_cIp,(_cAlias1)->ZR_EMAIL)

	::_cXml := cRet

Return .T.

WSMETHOD GetSolics WSRECEIVE _cLogin,_cNome,_cCliente,_cEmail WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cRet 	:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cQuery2	:= ""
	Local _cAlias2	:= GetNextAlias()
	Local _cNome	:= ::_cNome
	Local _cCliente := SubStr(::_cCliente,1,6)
	Local _cLoja 	:= SubStr(::_cCliente,7,2)
	Local _cEndRest := ""

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("Z63")+" Z63
	_cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+" A1
	_cQuery1 += " ON A1_COD=Z63_CLIENT AND A1_LOJA=Z63_LOJA
	_cQuery1 += " WHERE Z63.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' '

	If !Empty(::_cCliente)
		_cQuery1 += " AND A1_COD='"+_cCliente+"' AND A1_LOJA='"+_cLoja+"'
	Else
		If Len(AllTrim(::_cLogin))==8 //Pegar todas as filiais
			_cQuery1 += " AND SUBSTR(A1_CGC,1,8)='"+::_cLogin+"'
		Else
			_cQuery1 += " AND A1_CGC='"+::_cLogin+"'
		EndIf
	EndIf

	_cQuery1 += " ORDER BY Z63_NUMERO

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_nCount := 0

	While (_cAlias1)->(!Eof())

		_nCount++

		_cRet += '				<div class="row" id="'+AllTrim((_cAlias1)->Z63_NUMERO)+'">
		_cRet += '					<div class="cell" data-title="Status"><img src="./imagens/'+GetStaMkt((_cAlias1)->Z63_STATUS,1)+'.png"/></div>
		_cRet += '					<div class="cell" data-title="Solicitação"><a href="altera_solicitacao.php?cSolic='+(_cAlias1)->Z63_NUMERO+'">'+(_cAlias1)->Z63_NUMERO+'</a></div>
		_cRet += '					<div class="cell" data-title="Descrição">'+AllTrim((_cAlias1)->Z63_DESC)+'</div>
		_cRet += '					<div class="cell" data-title="Emissão">'+DTOC(STOD((_cAlias1)->Z63_DTEMIS))+'</div>
		_cRet += '					<div class="cell" data-title="Solicitante">'+(_cAlias1)->Z63_SOLIC+'</div>
		_cRet += '					<div class="cell" data-title="Descrição Status">'+GetStaMkt((_cAlias1)->Z63_STATUS,2)+'</div>
		_cRet += '				</div>

		(_cAlias1)->(DbSkip())
	EndDo

	U_STZ1B("GetSolics","","GetSolics","portal","",,::_cEmail)

	::_cXml := _cRet

Return .T.

Static Function GetStaMkt(_cStatus,_nTipo)

	Local _cRet := ""

	_cStatus := AllTrim(_cStatus)

	Do Case
	Case _nTipo==1
		If _cStatus=="1"
			_cRet := "leg_preto"
		ElseIf _cStatus=="2"
			_cRet := "leg_vermelho"
		ElseIf _cStatus=="3"
			_cRet := "leg_laranja"
		ElseIf _cStatus=="4"
			_cRet := "leg_azul"
		ElseIf _cStatus=="5"
			_cRet := "leg_verde"
		EndIf
	Case _nTipo==2
		If _cStatus=="1"
			_cRet := "Pendente MKT (Análise)"
		ElseIf _cStatus=="2"
			_cRet := "Pendente cliente (Comprovante)"
		ElseIf _cStatus=="3"
			_cRet := "Pendente MKT (Comprovante)"
		ElseIf _cStatus=="4"
			_cRet := "Pendente financeiro"
		ElseIf _cStatus=="5"
			_cRet := "Finalizado"
		EndIf
	EndCase

Return(_cRet)

WSMETHOD GetAcessos WSRECEIVE _cEmail WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cRet 	:= "<getacessos>"
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _nX		:= 0

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("SZR")+" ZR
	_cQuery1 += " WHERE ZR.D_E_L_E_T_=' ' AND ZR_EMLSUP='"+Alltrim(::_cEmail)+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_cRet += "<usuario>
		_cRet += "<nome>"+AllTrim((_cAlias1)->ZR_NOME)+"</nome>
		_cRet += "<status>"+AllTrim((_cAlias1)->ZR_STATUS)+"</status>
		_cRet += "<virapedido>"+AllTrim((_cAlias1)->ZR_VIRAPED)+"</virapedido>
		_cRet += "<email>"+AllTrim((_cAlias1)->ZR_EMAIL)+"</email>
		_cRet += "<acessos>"+(_cAlias1)->ZR_ACESSOS+"</acessos>

		_aCnpjs := U_STFAT440((_cAlias1)->ZR_EMAIL)

		_cRet += "<cnpjs>"
		For _nX:=1 To Len(_aCnpjs)
			_cRet += "<cnpj>"+_aCnpjs[_nX]+"</cnpj>
		Next
		_cRet += "</cnpjs>"

		_cRet += "</usuario>

		(_cAlias1)->(DbSkip())
	EndDo

	_cRet += "</getacessos>"

	U_STZ1B("GetAcessos","","GetAcessos","portal","",,::_cEmail)

	::_cXml := _cRet

Return .T.

WSMETHOD SetAcessos WSRECEIVE _cXmlRec,_cEmail WSSEND _cXml WSSERVICE WSPRTCLI

	Local _cRet 	:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _nX		:= 0

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")
	
	oJson := JSonObject():New()
	cErr  := oJSon:fromJson(::_cXmlRec)

	_lInclui := .F.

	DbSelectArea("Z79")
	Z79->(DbSetOrder(2))

	DbSelectArea("SZR")
	SZR->(DbSetOrder(2))
	If SZR->(DbSeek(xFilial("SZR")+oJson:GetJSonObject('email')))
		SZR->(RecLock("SZR",.F.))
	Else
		SZR->(RecLock("SZR",.T.))
		SZR->ZR_SENHA 	:= cValToChar(Randomize(100000,999999))
		SZR->ZR_1ACESSO := "N"
		_lInclui := .T.
	EndIf

	SZR->ZR_TPUSER  := "C"
	SZR->ZR_STATUS 	:= oJson:GetJSonObject('status')
	SZR->ZR_EMAIL  	:= oJson:GetJSonObject('email')
	SZR->ZR_ACESSOS	:= oJson:GetJSonObject('acessos')
	SZR->ZR_NOME	:= oJson:GetJSonObject('nome')
	SZR->ZR_VIRAPED	:= oJson:GetJSonObject('virapedido')
	SZR->ZR_EMLSUP	:= oJson:GetJSonObject('parent')

	_cUpd := " DELETE FROM Z79010 Z79 WHERE Z79_EMAIL='"+SZR->ZR_EMAIL+"'
	TcSqlExec(_cUpd)

	aCnpjs := StrTokArr( oJson:GetJSonObject('empresas') , ',' )
	For _nX:=1 To Len(aCnpjs)
		If _nX==1
			SZR->ZR_LOGIN := aCnpjs[_nX]
		EndIf
		If !Z79->(DbSeek(xFilial("Z79")+SZR->ZR_EMAIL+aCnpjs[_nX]))
			Z79->(RecLock("Z79",.T.))
			Z79->Z79_EMAIL := SZR->ZR_EMAIL
			Z79->Z79_CNPJS := aCnpjs[_nX]
			Z79->(MsUnLock())
		EndIf
	Next

	SZR->(MsUnLock())

	If _lInclui
		U_STSZR001()
	EndIf

	cRet := "ok"

	U_STZ1B("SetAcessos","","SetAcessos","portal","",,::_cEmail)

	::_cXml := cRet

Return .T.

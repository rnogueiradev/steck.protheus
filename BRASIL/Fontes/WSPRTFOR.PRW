#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"

/*/{Protheus.doc} WSPRTFOR
@name WSPRTFOR
@type User Function
@desc estrutura de integração com o portal do fornecedor
@author Renato Nogueira
@since 17/05/2018
/*/

WSSERVICE WSPRTFOR DESCRIPTION "Serviço para realizar integração com o portal do fornecedor"

	WSDATA cXmlEnv			AS STRING
	WSDATA cXmlRet			AS STRING
	WSDATA _cLogin			AS STRING
	WSDATA _cPassword		AS STRING
	WSDATA _cEmpresa		AS STRING
	WSDATA _cXml  			AS STRING
	WSDATA _cCotacao		AS STRING
	WSDATA _cPedido		AS STRING
	WSDATA _cXmlRec			AS STRING

	WSMETHOD ConsultarProd DESCRIPTION "Método para realizar consulta de produto"
	WSMETHOD ConfirmaPed DESCRIPTION "Método para confirmar a visualização do pedido"
	WSMETHOD ImprimePed DESCRIPTION "Método para fazer a impressão do pedido"
	WSMETHOD Logar DESCRIPTION "Método que retorna se o usuário e senha estão corretos"
	WSMETHOD GetCots DESCRIPTION "Método que retorna as cotações do fornecedor"
	WSMETHOD GetPeds DESCRIPTION "Método que retorna os pedidos do fornecedor"
	WSMETHOD GetCot DESCRIPTION "Método retornar os dados da cotação selecionada"
	WSMETHOD GetPed DESCRIPTION "Método retornar os dados do pedido selecionado"
	WSMETHOD InsereCot DESCRIPTION "Método para atualizar dados da cotacao"
	WSMETHOD EnviaSenha DESCRIPTION "Método para reenviar senha ao fornecedor"
	WSMETHOD AlteraSenha DESCRIPTION "Método para alterar senha do fornecedor"
    WSMETHOD GetPedFornecAberto DESCRIPTION "Método retornar os dados dos pedidos em aberto do forncedor"

ENDWSSERVICE

WSMETHOD ConsultarProd WSRECEIVE cXmlEnv WSSEND cXmlRet WSSERVICE WSPRTFOR

	::cXmlRet := U_STCOMA01(::cXmlEnv)

Return .T.

WSMETHOD Logar WSRECEIVE _cLogin,_cPassword,_cEmpresa WSSEND _cXml WSSERVICE WSPRTFOR

	Local _aUser 	:= {}
	Local _cQuery1 	:= ""
	Local _cAlias1  := ""
	Local _cQuery2 	:= ""
	Local _cAlias2  := ""
	Local _cQuery3 	:= ""
	Local _cAlias3  := ""
	Local _cEmp		:= SubStr(::_cEmpresa,1,2)
	Local _cFil		:= SubStr(::_cEmpresa,3,2)

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	_cAlias1  := GetNextAlias()
	_cAlias2  := GetNextAlias()
	_cAlias3  := GetNextAlias()

	_cXml := "<login><resultado>

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM AI3"+_cEmp+"0 AI3
	_cQuery1 += " WHERE AI3.D_E_L_E_T_=' ' AND AI3_LOGIN='"+::_cLogin+"'

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

		If AllTrim((_cAlias1)->AI3_PSW)==AllTrim(::_cPassword)

			_cXml += "<status>OK</status>
			_cXml += "<msg></msg>
			_cXml += "<nome>"+AllTrim((_cAlias1)->AI3_NOME)+"</nome>

		Else

			_cXml += "<status>ERRO</status>
			_cXml += "<msg>A senha digitada está incorreta</msg>
			_cXml += "<nome></nome>
		EndIf

	EndIf

	_cXml += "</resultado></login>

	::_cXml := _cXml

Return .T.

WSMETHOD GetCots WSRECEIVE _cLogin,_cEmpresa WSSEND _cXml WSSERVICE WSPRTFOR

	Local _cRet 	:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cEmp		:= SubStr(::_cEmpresa,1,2)
	Local _cFil		:= SubStr(::_cEmpresa,3,2)

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	_cQuery1 := " SELECT DISTINCT C8_NUM, C8_NUMPED, C8_EMISSAO
	_cQuery1 += " FROM SC8"+_cEmp+"0 C8
	_cQuery1 += " LEFT JOIN SA2"+_cEmp+"0 A2
	_cQuery1 += " ON C8_FORNECE=A2_COD AND C8_LOJA=A2_LOJA
	_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND A2.D_E_L_E_T_=' '
	_cQuery1 += " AND C8_FILIAL='"+_cFil+"' AND A2_CGC='"+::_cLogin+"'
	_cQuery1 += " AND C8_EMISSAO>='"+DTOS(Date()-180)+"'
	_cQuery1 += " ORDER BY C8_NUM DESC

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_cRet += '				<div class="row" id="'+AllTrim((_cAlias1)->C8_NUM)+'">

		If Empty((_cAlias1)->C8_NUMPED)
			_cRet += '<div class="cell" data-title="Cotação"><a href="editar_cotacao.php?cChave='+(_cAlias1)->C8_NUM+'">'+(_cAlias1)->C8_NUM+'</a></div>
		Else
			_cRet += '<div class="cell" data-title="Cotação">'+(_cAlias1)->C8_NUM+'</div>
		EndIf

		_cRet += '					<div class="cell" data-title="Status">'+IIf(Empty((_cAlias1)->C8_NUMPED),"Aberta","Fechada")+'</div>
		_cRet += '					<div class="cell" data-title="Pedido">'+(_cAlias1)->C8_NUMPED+'</div>
		_cRet += '					<div class="cell" data-title="Data emissão">'+DTOC(STOD((_cAlias1)->C8_EMISSAO))+'</div>
		_cRet += '				</div>

		(_cAlias1)->(DbSkip())
	EndDo

	::_cXml := _cRet

Return .T.

WSMETHOD GetCot WSRECEIVE _cLogin,_cEmpresa,_cCotacao WSSEND _cXml WSSERVICE WSPRTFOR

	Local _cRetorno	:= '<?xml version="1.0" encoding="utf-8"?><resumocot>
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cEmp		:= SubStr(::_cEmpresa,1,2)
	Local _cFil		:= SubStr(::_cEmpresa,3,2)
	Local nRegs          := 0

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	_cQuery1 := " SELECT C8.*, A2.*, C8.R_E_C_N_O_ RECSC8
	_cQuery1 += " FROM SC8"+_cEmp+"0 C8
	_cQuery1 += " LEFT JOIN SA2"+_cEmp+"0 A2
	_cQuery1 += " ON C8_FORNECE=A2_COD AND C8_LOJA=A2_LOJA
	_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND A2.D_E_L_E_T_=' '
	_cQuery1 += " AND C8_FILIAL='"+_cFil+"' AND A2_CGC='"+::_cLogin+"' AND C8_NUM='"+::_cCotacao+"'
	_cQuery1 += " ORDER BY C8_ITEM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	Count To nRegs

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		_cRetorno += "<cabecalho>"
		_cRetorno += "<tpfrete>"+(_cAlias1)->C8_TPFRETE+"</tpfrete>"
		_cRetorno += "<condpg>"+(_cAlias1)->C8_COND+"</condpg>"
		_cRetorno += "<frete>"+CVALTOCHAR((_cAlias1)->C8_VALFRE)+"</frete>"
		_cRetorno += "<noment>"+(_cAlias1)->C8_XNOMENT+"</noment>"
		_cRetorno += "<endent>"+(_cAlias1)->C8_XENDENT+"</endent>"
		_cRetorno += "<cident>"+(_cAlias1)->C8_XCIDENT+"</cident>"
		_cRetorno += "<cepent>"+(_cAlias1)->C8_XCEPENT+"</cepent>"
		_cRetorno += "<cnpjent>"+SM0->M0_CGC+"</cnpjent>"
		_cRetorno += "<forcnpj>"+(_cAlias1)->C8_XCGCFOR+"</forcnpj>"
		_cRetorno += "<fornome>"+(_cAlias1)->C8_XNOMFOR+"</fornome>"
		_cRetorno += "<forend>"+(_cAlias1)->C8_XENDFOR+"</forend>"
		_cRetorno += "<totprods>"+CVALTOCHAR(nRegs)+"</totprods>"
		_cRetorno += "</cabecalho>"
	EndIf

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	DbSelectArea("SC8")

	_cRetorno += "<produtos>"

	While (_cAlias1)->(!Eof())

		SC8->(DbGoTo((_cAlias1)->RECSC8))

		SB1->(DbGoTop())
		SB1->(DbSeek(xFilial("SB1")+(_cAlias1)->C8_PRODUTO))

		_cRetorno += "<produto>"
		_cRetorno += "<item>"+(_cAlias1)->C8_ITEM+"</item>"
		_cRetorno += "<codigo>"+(_cAlias1)->C8_PRODUTO+"</codigo>"
		_cRetorno += "<desc>"+AllTrim(SB1->B1_XDESEXD)+"</desc>"
		_cRetorno += "<prium>"+(_cAlias1)->C8_UM+"</prium>"
		_cRetorno += "<priqt>"+CVALTOCHAR((_cAlias1)->C8_QUANT)+"</priqt>"
		_cRetorno += "<priprc>"+CVALTOCHAR((_cAlias1)->C8_PRECO)+"</priprc>"

		If !Empty((_cAlias1)->C8_SEGUM)
			_cRetorno += "<segum>"+(_cAlias1)->C8_SEGUM+"</segum>"
			_cRetorno += "<segqt>"+CVALTOCHAR((_cAlias1)->C8_QTSEGUM)+"</segqt>"
		Else
			_cRetorno += "<segum>.</segum>"
			_cRetorno += "<segqt>.</segqt>"
		EndIf

		_cRetorno += "<ipi>"+CVALTOCHAR((_cAlias1)->C8_ALIIPI)+"</ipi>"
		_cRetorno += "<icms>"+CVALTOCHAR((_cAlias1)->C8_PICM)+"</icms>"

		_cRetorno += "<segprc>"+CVALTOCHAR((_cAlias1)->C8_XVL2UM)+"</segprc>"
		_cRetorno += "<ptax>"+CVALTOCHAR((_cAlias1)->C8_XTAXA)+"</ptax>"
		_cRetorno += "<prazo>"+CVALTOCHAR((_cAlias1)->C8_PRAZO)+"</prazo>"
		_cRetorno += "<desconto>"+CVALTOCHAR((_cAlias1)->C8_DESC)+"</desconto>"

		If Empty(SC8->C8_OBS)
			_cRetorno += "<obsitem>.</obsitem>"
		Else
			_cRetorno += "<obsitem>"+AllTrim(SC8->C8_OBS)+"</obsitem>"
		EndIf

		If !Empty((_cAlias1)->C8_XDESENH)
			_cRetorno += "<desenho>"+(_cAlias1)->C8_XDESENH+"</desenho>"
		Else
			_cRetorno += "<desenho>.</desenho>"
		EndIf

		_cRetorno += "<recusado>"+CVALTOCHAR((_cAlias1)->C8_XRECUSA)+"</recusado>"
		_cRetorno += "<justificativa>"+AllTrim(SC8->C8_XMOTREC)+"</justificativa>"

		_cRetorno += "</produto>"

		(_cAlias1)->(DbSkip())
	EndDo

	_cRetorno += "</produtos>"

	_cRetorno += "</resumocot>"

	//_cRetorno := EncodeUTF8(_cRetorno)

	Conout(_cRetorno)

	::_cXml := _cRetorno

Return .T.

WSMETHOD InsereCot WSRECEIVE _cLogin,_cEmpresa,_cCotacao,_cXmlRec WSSEND _cXml WSSERVICE WSPRTFOR

	Local _cRetorno	:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cQuery2	:= ""
	Local _cAlias2	:= GetNextAlias()
	Local _cEmp		:= SubStr(::_cEmpresa,1,2)
	Local _cFil		:= SubStr(::_cEmpresa,3,2)
	Local nRegs          := 0
	Local _cXml 	:= ::_cXmlRec
	Local _nX
	Local cAviso := ""
	Local cErro := ""
	Local _nTotal

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	Conout(_cEmp)
	Conout(_cFil)

	oXml := XmlParser(_cXml,"_",@cAviso,@cErro)

	Conout(cAviso)
	Conout(cErro)

	_cCodFor := ""
	_cLojFor := ""

	_cQuery1 := " SELECT A2_COD, A2_LOJA
	_cQuery1 += " FROM SA2"+_cEmp+"0 A2
	_cQuery1 += " WHERE A2.D_E_L_E_T_=' '
	_cQuery1 += " AND A2_CGC='"+::_cLogin+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	Count To _nTotal

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		_cRetorno := "Fornecedor não encontrado!"
		Return .T.
	EndIf

	_cCodFor := (_cAlias1)->A2_COD
	_cLojFor := (_cAlias1)->A2_LOJA

	If _nTotal>1

		_cQuery2 := " SELECT C8_LOJA
		_cQuery2 += " FROM sc8"+_cEmp+"0 C8
		_cQuery2 += " WHERE C8.D_E_L_E_T_=' ' AND C8_FILIAL='"+_cFil+"' AND C8_NUM='"+::_cCotacao+"'
		_cQuery2 += " AND C8_FORNECE='"+(_cAlias1)->A2_COD+"'

		If !Empty(Select(_cAlias2))
			DbSelectArea(_cAlias2)
			(_cAlias2)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

		dbSelectArea(_cAlias2)
		(_cAlias2)->(dbGoTop())

		If (_cAlias2)->(Eof())
			_cRetorno := "Fornecedor não encontrado!"
			Return .T.
		EndIf

	EndIf

	DbSelectArea("SC8")
	SC8->(DbSetOrder(1))
	SC8->(DbGoTop())

	Do Case

		Case Type("oXml:_COTACAO:_PRODUTOS:_PRODUTO")=="O"

		If SC8->(DbSeek(_cFil+::_cCotacao+_cCodFor+_cLojFor+oXml:_COTACAO:_PRODUTOS:_PRODUTO:_ITEM:TEXT))

			SC8->(RecLock("SC8",.F.))

			_nPreco := 0
			_nQtde	:= 0

			SC8->C8_PRECO 	:= 0
			SC8->C8_DESC  	:= 0
			SC8->C8_VLDESC	:= 0

			If Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO:_SEGPRC:TEXT)>0
				_nPreco := Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO:_SEGPRC:TEXT)
				_nQtde  := SC8->C8_QTSEGUM
				SC8->C8_XVL2UM := _nPreco
				SC8->C8_XPORTAL :=  "S"
			ElseIf Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO:_PRIPRC:TEXT)>0
				_nPreco := Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO:_PRIPRC:TEXT)
				_nQtde  := SC8->C8_QUANT
				SC8->C8_PRECO := _nPreco
				SC8->C8_XPORTAL :=  "S"
			EndIf

			If SC8->C8_XPRCORC==0
				SC8->C8_XPRCORC := _nPreco
			EndIf

			SC8->C8_TOTAL 	:= 	Round(_nPreco*_nQtde,2)

			If Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO:_DESCONTO:TEXT)>0
				SC8->C8_DESC := Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO:_DESCONTO:TEXT)
				SC8->C8_VLDESC := NoRound(SC8->C8_TOTAL*SC8->C8_DESC/100,TamSx3("C8_VLDESC")[2])
			EndIf

			SC8->C8_XTAXA 	:= 	Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO:_PTAX:TEXT)
			SC8->C8_ALIIPI 	:= 	Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO:_IPI:TEXT)
			SC8->C8_PICM 	:= 	Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO:_ICMS:TEXT)
			SC8->C8_PRAZO 	:= 	Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO:_PRAZO:TEXT)
			SC8->C8_OBS		:=  oXml:_COTACAO:_PRODUTOS:_PRODUTO:_OBSITEM:TEXT
			SC8->C8_COND	:=  oXml:_COTACAO:_CONDPG:TEXT
			SC8->C8_TPFRETE :=  oXml:_COTACAO:_TPFRETE:TEXT
			SC8->C8_VALFRE  :=  Val(oXml:_COTACAO:_FRETE:TEXT)
			SC8->C8_TOTFRE  :=  SC8->C8_VALFRE
			SC8->C8_BASEICM := 	SC8->C8_TOTAL+SC8->C8_VALFRE-SC8->C8_VLDESC
			SC8->C8_VALICM 	 := Round(SC8->C8_PICM/100*SC8->C8_BASEICM,TamSx3("C8_VALICM")[2])
			SC8->C8_BASEIPI := 	SC8->C8_TOTAL+SC8->C8_VALFRE-SC8->C8_VLDESC
			SC8->C8_VALIPI 	:= 	Round(SC8->C8_ALIIPI/100*SC8->C8_BASEIPI,TamSx3("C8_VALIPI")[2])
			If SC8->C8_XTAXA>0
				SC8->C8_XPRC2	:= SC8->C8_PRECO / SC8->C8_XTAXA
			EndIf
			If SC8->C8_XVL2UM>0 .And. SC8->C8_QTSEGUM>0
				SC8->C8_TOTAL := Round(SC8->C8_XVL2UM * SC8->C8_QTSEGUM,2)
				SC8->C8_PRECO := SC8->C8_TOTAL / SC8->C8_QUANT
			EndIf
			SC8->C8_XLOG 	:= "Alterado preço para "+cValToChar(SC8->C8_PRECO)+" em "+DTOC(Date())+" "+Time()+CRLF+SC8->C8_XLOG

            //Campos de recusa/declínio do item na cotação
            SC8->C8_XRECUSA	:=  Iif(oXml:_COTACAO:_PRODUTOS:_PRODUTO:_RECUSADO:TEXT == "true", .T., .F.)
            SC8->C8_XMOTREC	:=  oXml:_COTACAO:_PRODUTOS:_PRODUTO:_JUSTIFICATIVA:TEXT

			SC8->(MsUnLock())

		EndIf

		Case Type("oXml:_COTACAO:_PRODUTOS:_PRODUTO")=="A"

		For _nX:=1 To Len(oXml:_COTACAO:_PRODUTOS:_PRODUTO)

			If SC8->(DbSeek(_cFil+::_cCotacao+_cCodFor+_cLojFor+oXml:_COTACAO:_PRODUTOS:_PRODUTO[_nX]:_ITEM:TEXT))

				SC8->(RecLock("SC8",.F.))

				_nFrete := Val(oXml:_COTACAO:_FRETE:TEXT)

				If _nX==1
					SC8->C8_VALFRE  :=  _nFrete
				EndIf

				SC8->C8_TOTFRE  :=  _nFrete

				_nPreco := 0
				_nQtde	:= 0

				SC8->C8_PRECO 	:= 0
				SC8->C8_DESC  	:= 0
				SC8->C8_VLDESC	:= 0

				If Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO[_nX]:_SEGPRC:TEXT)>0
					_nPreco := Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO[_nX]:_SEGPRC:TEXT)
					_nQtde  := SC8->C8_QTSEGUM
					SC8->C8_XVL2UM := _nPreco
					SC8->C8_XPORTAL :=  "S"
				ElseIf Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO[_nX]:_PRIPRC:TEXT)>0
					_nPreco := Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO[_nX]:_PRIPRC:TEXT)
					_nQtde  := SC8->C8_QUANT
					SC8->C8_PRECO := _nPreco
					SC8->C8_XPORTAL :=  "S"				
				EndIf

				If SC8->C8_XPRCORC==0
					SC8->C8_XPRCORC := _nPreco
				EndIf

				SC8->C8_TOTAL 	:= 	Round(_nPreco*_nQtde,2)

				If Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO[_nX]:_DESCONTO:TEXT)>0
					SC8->C8_DESC := Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO[_nX]:_DESCONTO:TEXT)
					SC8->C8_VLDESC := NoRound(SC8->C8_TOTAL*SC8->C8_DESC/100,TamSx3("C8_VLDESC")[2])
				EndIf

				SC8->C8_XTAXA 	:= 	Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO[_nX]:_PTAX:TEXT)
				SC8->C8_ALIIPI 	:= 	Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO[_nX]:_IPI:TEXT)
				SC8->C8_PICM 	:= 	Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO[_nX]:_ICMS:TEXT)
				SC8->C8_PRAZO 	:= 	Val(oXml:_COTACAO:_PRODUTOS:_PRODUTO[_nX]:_PRAZO:TEXT)
				SC8->C8_OBS		:=  oXml:_COTACAO:_PRODUTOS:_PRODUTO[_nX]:_OBSITEM:TEXT
				SC8->C8_COND	:=  oXml:_COTACAO:_CONDPG:TEXT
				SC8->C8_TPFRETE :=  oXml:_COTACAO:_TPFRETE:TEXT
				SC8->C8_BASEICM := 	SC8->C8_TOTAL+SC8->C8_VALFRE-SC8->C8_VLDESC
				SC8->C8_VALICM 	 := Round(SC8->C8_PICM/100*SC8->C8_BASEICM,TamSx3("C8_VALICM")[2])
				SC8->C8_BASEIPI := 	SC8->C8_TOTAL+SC8->C8_VALFRE-SC8->C8_VLDESC
				SC8->C8_VALIPI 	:= 	Round(SC8->C8_ALIIPI/100*SC8->C8_BASEIPI,TamSx3("C8_VALIPI")[2])
				If SC8->C8_XTAXA>0
					SC8->C8_XPRC2	:= SC8->C8_PRECO / SC8->C8_XTAXA
				EndIf
				If SC8->C8_XVL2UM>0 .And. SC8->C8_QTSEGUM>0
					SC8->C8_TOTAL := Round(SC8->C8_XVL2UM * SC8->C8_QTSEGUM,2)
					SC8->C8_PRECO := SC8->C8_TOTAL / SC8->C8_QUANT
				EndIf
				SC8->C8_XLOG 	:= "Alterado preço para "+cValToChar(SC8->C8_PRECO)+" em "+DTOC(Date())+" "+Time()+CRLF+SC8->C8_XLOG

                //Campos de recusa/declínio do item na cotação
                SC8->C8_XRECUSA	:=  Iif(oXml:_COTACAO:_PRODUTOS:_PRODUTO[_nX]:_RECUSADO:TEXT == "true", .T., .F.)
                SC8->C8_XMOTREC	:=  oXml:_COTACAO:_PRODUTOS:_PRODUTO[_nX]:_JUSTIFICATIVA:TEXT

				SC8->(MsUnLock())

			EndIf

		Next _nX

	EndCase

	_cRetorno := "Cotação atualizada com sucesso, obrigado!"

	::_cXml := _cRetorno

Return .T.

WSMETHOD EnviaSenha WSRECEIVE _cLogin,_cEmpresa WSSEND _cXml WSSERVICE WSPRTFOR

	Local _cQuery1 	:= ""
	Local _cAlias1  := ""
	Local _cQuery2 	:= ""
	Local _cAlias2  := ""
	Local _cLogin	:= AllTrim(::_cLogin)
	Local _cEmp		:= SubStr(::_cEmpresa,1,2)

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,"01",,,"FAT")

	_cAlias1  := GetNextAlias()
	_cAlias2  := GetNextAlias()

	_cXml := "<senha><resultado>

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM AI3"+_cEmp+"0 AI3
	_cQuery1 += " WHERE AI3.D_E_L_E_T_=' ' AND AI3_LOGIN='"+::_cLogin+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(Eof())
		_cXml += "<status>ERRO</status>
		_cXml += "<msg>Login não encontrado para a empresa selecionada!</msg>
		_cXml += "<nome></nome>

	Else

		_aAttach := {}
		cMsg 	 := "<html><head><title></title></head><body>
		cMsg 	 += "Segue abaixo seus dados para acesso ao portal de fornecedores da Steck<br><br>
		cMsg	 += "Login: <b>"+AllTrim((_cAlias1)->AI3_LOGIN)+"</b><br>"
		cMsg	 += "Senha: <b>"+AllTrim((_cAlias1)->AI3_PSW)+"</b>"
		cMsg	 += "</body></html>

		cEmail 	 := AllTrim((_cAlias1)->AI3_EMAIL)

		If U_STMAILTES(cEmail,"","[STECK] - Reenvio de senha do portal do fornecedor", cMsg,_aAttach,"","")
			_cXml += "<status>OK</status>
			_cXml += "<msg>Senha enviada com sucesso para "+AllTrim((_cAlias1)->AI3_EMAIL)+"</msg>
			_cXml += "<nome></nome>
		Else
			_cXml += "<status>ERRO</status>
			_cXml += "<msg>Erro ao enviar o email, entre em contato com a Steck</msg>
			_cXml += "<nome></nome>
		EndIf
	EndIf

	_cXml += "</resultado></senha>

	::_cXml := _cXml

Return .T.

WSMETHOD AlteraSenha WSRECEIVE _cLogin,_cPassword,_cEmpresa WSSEND _cXml WSSERVICE WSPRTFOR

	Local cRet 		:= "Ocorreu algum erro ao tentar alterar a senha, entre em contato com a Steck"
	Local _cQuery2	:= ""
	Local _cAlias2	:= GetNextAlias()
	Local _cLogin	:= AllTrim(::_cLogin)
	Local _cEmp		:= SubStr(::_cEmpresa,1,2)
	Local _cFil		:= SubStr(::_cEmpresa,3,2)

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	_cQuery2 := " SELECT *
	_cQuery2 += " FROM AI3"+_cEmp+"0 AI3
	_cQuery2 += " WHERE AI3.D_E_L_E_T_=' ' AND AI3_LOGIN='"+_cLogin+"'

	If !Empty(Select(_cAlias2))
		DbSelectArea(_cAlias2)
		(_cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbGoTop())

	If (_cAlias2)->(!Eof())

		DbSelectArea("AI3")
		AI3->(DbGoTop())
		AI3->(DbGoTo((_cAlias2)->R_E_C_N_O_))
		If AI3->(!Eof())

			AI3->(RecLock("AI3",.F.))
			AI3->AI3_PSW := ::_cPassword
			AI3->(MsUnLock())

			cRet := "Sua senha foi alterada com sucesso, obrigado!"

		EndIf

	EndIf

	::_cXml := cRet

Return .T.

WSMETHOD GetPeds WSRECEIVE _cLogin,_cEmpresa WSSEND _cXml WSSERVICE WSPRTFOR

	Local _cRet 	:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cEmp		:= SubStr(::_cEmpresa,1,2)
	Local _cFil		:= SubStr(::_cEmpresa,3,2)

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	_cQuery1 := " SELECT DISTINCT C7_NUM, C7_COND, C7_EMISSAO, C7_XVIS
	_cQuery1 += " FROM SC7"+_cEmp+"0 C7
	_cQuery1 += " LEFT JOIN SA2"+_cEmp+"0 A2
	_cQuery1 += " ON C7_FORNECE=A2_COD AND C7_LOJA=A2_LOJA
	_cQuery1 += " WHERE C7.D_E_L_E_T_=' ' AND A2.D_E_L_E_T_=' '
	_cQuery1 += " AND C7_FILIAL='"+_cFil+"' AND A2_CGC='"+::_cLogin+"'
	_cQuery1 += " AND C7_EMISSAO>='"+DTOS(Date()-180)+"'
	_cQuery1 += " AND C7_CONAPRO='L'
	_cQuery1 += " ORDER BY C7_NUM DESC

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_cRet += '<div class="row" id="'+AllTrim((_cAlias1)->C7_NUM)+'">

		_cRet += '<div class="cell" data-title="Pedido"><a href="editar_pedido.php?cChave='+(_cAlias1)->C7_NUM+'">'+(_cAlias1)->C7_NUM+'</a></div>

		_cRet += '					<div class="cell" data-title="Cond. Pag">'+(_cAlias1)->C7_COND+'</div>
		_cRet += '					<div class="cell" data-title="Emissão">'+DTOC(STOD((_cAlias1)->C7_EMISSAO))+'</div>
		_cRet += '					<div class="cell" data-title="Status">'+IIf((_cAlias1)->C7_XVIS=="S","Confirmado","Pendente")+'</div>
		_cRet += '				</div>

		(_cAlias1)->(DbSkip())
	EndDo

	::_cXml := _cRet

Return .T.

WSMETHOD GetPed WSRECEIVE _cLogin,_cEmpresa,_cPedido WSSEND _cXml WSSERVICE WSPRTFOR

	Local _cRetorno	:= "<resumoped>"
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cEmp		:= SubStr(::_cEmpresa,1,2)
	Local _cFil		:= SubStr(::_cEmpresa,3,2)
	Local nRegs          := 0

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	DbSelectArea("SC7")

	_cQuery1 := " SELECT C7.R_E_C_N_O_ RECSC7, C7.*, A2.*
	_cQuery1 += " FROM SC7"+_cEmp+"0 C7
	_cQuery1 += " LEFT JOIN SA2"+_cEmp+"0 A2
	_cQuery1 += " ON C7_FORNECE=A2_COD AND C7_LOJA=A2_LOJA
	_cQuery1 += " WHERE C7.D_E_L_E_T_=' ' AND A2.D_E_L_E_T_=' '
	_cQuery1 += " AND C7_FILIAL='"+_cFil+"' AND A2_CGC='"+::_cLogin+"' AND C7_NUM='"+::_cPedido+"'
	_cQuery1 += " ORDER BY C7_ITEM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	Count To nRegs

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())

		_cRetorno += "<cabecalho>"
		_cRetorno += "<numero>"+(_cAlias1)->C7_NUM+"</numero>"
		_cRetorno += "<emissao>"+DTOC(STOD((_cAlias1)->C7_EMISSAO))+"</emissao>"
		_cRetorno += "<condpg>"+(_cAlias1)->C7_COND+" - "+Posicione("SE4",1,xFilial("SE4")+(_cAlias1)->C7_COND,"E4_DESCRI")+"</condpg>"

		DbSelectArea("SX6")
		SX6->(DbSetOrder(1))
		SX6->(DbSeek(xFilial("SX6")+"MV_MOEDA"+CVALTOCHAR((_cAlias1)->C7_MOEDA)))

		_cRetorno += "<moeda>"+AllTrim(SX6->X6_CONTEUD)+"</moeda>"
		_cRetorno += "<contato>"+(_cAlias1)->C7_CONTATO+"</contato>"
		_cRetorno += "<confirmado>"+IIf((_cAlias1)->C7_XVIS=="S","S","N")+"</confirmado>"
		_cRetorno += "<totprods>"+CVALTOCHAR(nRegs)+"</totprods>"
		_cRetorno += "</cabecalho>"
	EndIf

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	_cRetorno += "<produtos>"

	While (_cAlias1)->(!Eof())

		SC7->(DbGoTop())
		SC7->(DbGoTo((_cAlias1)->RECSC7))
		If SC7->(!Eof())
			SC7->(RecLock("SC7",.F.))
			SC7->C7_XVIS := "S"
			SC7->(MsUnLock())
		EndIf

		SB1->(DbGoTop())
		SB1->(DbSeek(xFilial("SB1")+(_cAlias1)->C7_PRODUTO))

		_cRetorno += "<produto>"
		_cRetorno += "<item>"+(_cAlias1)->C7_ITEM+"</item>"
		_cRetorno += "<codigo>"+(_cAlias1)->C7_PRODUTO+"</codigo>"
		_cRetorno += "<desc>"+SB1->B1_XDESEXD+"</desc>"
		_cRetorno += "<um>"+(_cAlias1)->C7_UM+"</um>"
		_cRetorno += "<quant>"+CVALTOCHAR((_cAlias1)->C7_QUANT)+"</quant>"
		_cRetorno += "<preco>"+CVALTOCHAR((_cAlias1)->C7_PRECO)+"</preco>"
		_cRetorno += "<total>"+CVALTOCHAR((_cAlias1)->C7_TOTAL)+"</total>"
		_cRetorno += "<dtentrega>"+DTOC(STOD((_cAlias1)->C7_DATPRF))+"</dtentrega>"
		_cRetorno += "<saldo>"+CVALTOCHAR((_cAlias1)->C7_QUANT - (_cAlias1)->C7_QUJE)+"</saldo>"
		_cRetorno += "<quantentregue>"+CVALTOCHAR((_cAlias1)->C7_QUJE)+"</quantentregue>"
		_cRetorno += "<sla>"+TRANSFORM(DateDiffDay(Date(),STOD((_cAlias1)->C7_DATPRF)),"@E 999")+"</sla>"
		_cRetorno += "</produto>"

		(_cAlias1)->(DbSkip())
	EndDo

	_cRetorno += "</produtos>"

	_cRetorno += "</resumoped>"

	::_cXml := _cRetorno

Return .T.

WSMETHOD GetPedFornecAberto WSRECEIVE _cLogin,_cEmpresa WSSEND _cXml WSSERVICE WSPRTFOR

	Local _cRetorno	:= "<resumoped>"
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cEmp		:= SubStr(::_cEmpresa,1,2)
	Local _cFil		:= SubStr(::_cEmpresa,3,2)
	Local nRegs          := 0

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	DbSelectArea("SC7")

    _cQuery1 := " SELECT SC7.C7_NUM, SC7.C7_ITEM, SC7.C7_PRODUTO, SC7.C7_UM, SC7.C7_QUANT, NVL(SC7.C7_PRECO,0) C7_PRECO, SC7.C7_TOTAL, SC7.C7_DATPRF, SC7.C7_QUANT, SC7.C7_QUJE
    _cQuery1 += " FROM SC7"+_cEmp+"0 SC7
    _cQuery1 += " INNER JOIN SA2"+_cEmp+"0 SA2 ON ( SA2.A2_COD = SC7.C7_FORNECE AND SA2.A2_FILIAl =  '  '  AND SA2.A2_LOJA=SC7.C7_LOJA)
    _cQuery1 += " INNER JOIN SC1"+_cEmp+"0 SC1 ON ( C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC AND SC1.D_E_L_E_T_= ' ' )  
    _cQuery1 += " WHERE SC7.D_E_L_E_T_=' ' AND SA2.D_E_L_E_T_=' '
    _cQuery1 += " AND SC7.C7_QUJE < SC7.C7_QUANT
    _cQuery1 += " AND SC7.C7_RESIDUO = ' '
    _cQuery1 += " AND SC7.C7_FILIAL='"+_cFil+"' AND SA2.A2_CGC='"+::_cLogin+"'"
    _cQuery1 += " GROUP BY SC7.C7_NUM, SC7.C7_ITEM, SC7.C7_PRODUTO, SC7.C7_UM, SC7.C7_QUANT, SC7.C7_PRECO, SC7.C7_TOTAL, SC7.C7_DATPRF, SC7.C7_QUANT, SC7.C7_QUJE
    _cQuery1 += " ORDER BY C7_NUM, C7_ITEM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	Count To nRegs

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	_cRetorno += "<produtos>"

	While (_cAlias1)->(!Eof())
		SB1->(DbGoTop())
		SB1->(DbSeek(xFilial("SB1")+(_cAlias1)->C7_PRODUTO))

		_cRetorno += "<produto>"
		_cRetorno += "<pedido>"+(_cAlias1)->C7_NUM+"</pedido>"
		_cRetorno += "<item>"+(_cAlias1)->C7_ITEM+"</item>"
		_cRetorno += "<codigo>"+(_cAlias1)->C7_PRODUTO+"</codigo>"
		_cRetorno += "<desc>"+SB1->B1_XDESEXD+"</desc>"
		_cRetorno += "<um>"+(_cAlias1)->C7_UM+"</um>"
		_cRetorno += "<quant>"+CVALTOCHAR((_cAlias1)->C7_QUANT)+"</quant>"
		_cRetorno += "<preco>"+CVALTOCHAR((_cAlias1)->C7_PRECO)+"</preco>"
		_cRetorno += "<total>"+CVALTOCHAR((_cAlias1)->C7_TOTAL)+"</total>"
		_cRetorno += "<dtentrega>"+DTOC(STOD((_cAlias1)->C7_DATPRF))+"</dtentrega>"
		_cRetorno += "<saldo>"+CVALTOCHAR((_cAlias1)->C7_QUANT - (_cAlias1)->C7_QUJE)+"</saldo>"
		_cRetorno += "<quantentregue>"+CVALTOCHAR((_cAlias1)->C7_QUJE)+"</quantentregue>"
		_cRetorno += "<sla>"+TRANSFORM(DateDiffDay(Date(),STOD((_cAlias1)->C7_DATPRF)),"@E 999")+"</sla>"
		_cRetorno += "</produto>"

		(_cAlias1)->(DbSkip())
	EndDo

	_cRetorno += "</produtos>"

	_cRetorno += "</resumoped>"

	::_cXml := _cRetorno

Return .T.

WSMETHOD ConfirmaPed WSRECEIVE _cLogin,_cEmpresa,_cPedido WSSEND _cXml WSSERVICE WSPRTFOR

	Local _cRetorno	:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cEmp		:= SubStr(::_cEmpresa,1,2)
	Local _cFil		:= SubStr(::_cEmpresa,3,2)
	Local nRegs          := 0

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	_cQuery1 := " SELECT C7.R_E_C_N_O_ RECSC7
	_cQuery1 += " FROM SC7"+_cEmp+"0 C7
	_cQuery1 += " WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='"+_cFil+"' AND C7_NUM='"+::_cPedido+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SC7")

	If (_cAlias1)->(Eof())
		_cRetorno := "Pedido não encontrado, entre em contato com a Steck!"
	EndIf

	While (_cAlias1)->(!Eof())

		SC7->(DbGoTop())
		SC7->(DbGoTo((_cAlias1)->RECSC7))
		If SC7->(!Eof())
			//SC7->(RecLock("SC7",.F.))
			//SC7->C7_XVIS := "S"
			//SC7->(MsUnLock())
			_cRetorno := "Pedido confirmado com sucesso, obrigado :)"
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	::_cXml := _cRetorno

Return .T.

WSMETHOD ImprimePed WSRECEIVE _cLogin,_cEmpresa,_cPedido WSSEND _cXml WSSERVICE WSPRTFOR

	Local _cRetorno	:= ""
	Local _cQuery1	:= ""
	Local _cAlias1	:= GetNextAlias()
	Local _cEmp		:= SubStr(::_cEmpresa,1,2)
	Local _cFil		:= SubStr(::_cEmpresa,3,2)
	Local nRegs          := 0

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv(_cEmp,_cFil,,,"FAT")

	DbSelectArea("SC7")
	SC7->(DbSetOrder(1))
	SC7->(DbGoTop())
	If SC7->(DbSeek(_cFil+::_cPedido))
		U_RSTFAT92(.T.)
	EndIf

	_cQuery1 := " SELECT C7.R_E_C_N_O_ RECSC7
	_cQuery1 += " FROM SC7"+_cEmp+"0 C7
	_cQuery1 += " WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='"+_cFil+"' AND C7_NUM='"+::_cPedido+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SC7")

	If (_cAlias1)->(Eof())
		_cRetorno := "Pedido não encontrado, entre em contato com a Steck!"
	EndIf

	While (_cAlias1)->(!Eof())

		SC7->(DbGoTop())
		SC7->(DbGoTo((_cAlias1)->RECSC7))
		If SC7->(!Eof())
			//SC7->(RecLock("SC7",.F.))
			//SC7->C7_XVIS := "S"
			//SC7->(MsUnLock())
			//_cRetorno := "Pedido confirmado com sucesso, obrigado :)"
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	_cRetorno += "<imprimeped><resultado>OK</resultado></imprimeped>"

	::_cXml := _cRetorno

Return .T.

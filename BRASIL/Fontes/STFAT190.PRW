#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT190        | Autor | RENATO.OLIVEIRA           | Data | 14/08/2019  |
|=====================================================================================|
|Descrição | Verificar pedido sem rota na TNT			                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT190()

	Local _cQuery8  := ""
	Local _cAlias8  := GetNextAlias()

	//Aviso de pedido sem rota de entrega TNT
	If SC5->C5_TRANSP=="000163"

		_aEndEnt := U_STTNT011()

		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		If SA1->(DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI)))

			_cQuery8 := " SELECT *
			_cQuery8 += " FROM "+RetSqlName("SZV")+" ZV
			_cQuery8 += " WHERE ZV.D_E_L_E_T_=' ' AND '"+_aEndEnt[1][1]+"' BETWEEN ZV_CEPDE AND ZV_CEPATE

			If !Empty(Select(_cAlias8))
				DbSelectArea(_cAlias8)
				(_cAlias8)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery8),_cAlias8,.T.,.T.)

			dbSelectArea(_cAlias8)

			(_cAlias8)->(dbGoTop())

			If (_cAlias8)->(Eof())

				_cEmail		:= GetMv("MT410TOK01",,"renato.oliveira@steck.com.br;kleber.braga@steck.com.br")
				_cAssunto 	:= "[WFPROTHEUS] - Pedido sem rota na TNT"

				cMsg := ""
				cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
				cMsg += '<b>Filial: </b>'+Alltrim(SC5->C5_FILIAL)+'<br>
				cMsg += '<b>Pedido: </b>'+SC5->C5_NUM+'<br>
				cMsg += '<b>Cnpj: </b>'+SA1->A1_CGC+'<br>
				cMsg += '<b>Nome: </b>'+SA1->A1_NOME+'<br>
				cMsg += '<b>Endereço: </b>'+_aEndEnt[1][2]+'<br>

				_cComplem := SA1->A1_COMPLEM
				If _aEndEnt[1][7]
					_cComplem := ""
				EndIf

				cMsg += '<b>Complemento: </b>'+_cComplem+'<br>
				cMsg += '<b>Estado: </b>'+_aEndEnt[1][6]+'<br>
				cMsg += '<b>Cód. Munic.: </b>'+_aEndEnt[1][4]+'<br>
				cMsg += '<b>Município: </b>'+_aEndEnt[1][5]+'<br>
				cMsg += '<b>Bairro: </b>'+_aEndEnt[1][3]+'<br>
				cMsg += '<b>DDD: </b>'+SA1->A1_DDD+'<br>
				cMsg += '<b>Telefone: </b>'+SA1->A1_TEL+'<br>
				cMsg += '<b>Cep: </b>'+_aEndEnt[1][1]+'<br>
				cMsg += '<b>Inscrição estadual: </b>'+SA1->A1_INSCR+'<br>
				cMsg += '</body></html>'

				U_STMAILTES(_cEmail,"",_cAssunto, cMsg,{},"")

			EndIf

		EndIf

	EndIf

Return()
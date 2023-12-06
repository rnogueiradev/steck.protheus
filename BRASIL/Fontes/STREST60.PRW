#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

Static lPrepEnv := u_xPrepEnv()

/*====================================================================================\
|Programa  | STREST60        | Autor | RENATO.OLIVEIRA           | Data | 01/03/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

WSRESTFUL getRomaneios DESCRIPTION "Aplicativo Steck"

WSMETHOD POST DESCRIPTION "Listar romaneios, notas e volumes" WSSYNTAX "/rest/getRomaneios"

END WSRESTFUL

WSMETHOD POST WSSERVICE getRomaneios

	Local cResp 	:= ""
	Local _cXmlRec 	:= StrTran(StrTran(::GetContent(),Chr(13),""),Chr(10),"")
	Local _cQuery1 	:= ""
	Local _cAlias1 	:= ""
	Local _cQuery2 	:= ""
	Local _cAlias2 	:= ""
	Local _cQuery3 	:= ""
	Local _cAlias3 	:= ""
	Local _nX		:= 0
	Local _cUsuario	:= ""

	ConOut("[STREST60]["+ FWTimeStamp(2) +"] - Usuario "+__cUserId+" realizou o acesso.")
	ConOut("[STREST60]["+ FWTimeStamp(2) +"] - Conteudo do body: "+_cXmlRec)

	_cUsuario := __cUserId

	Reset Environment

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	_cAlias1 := GetNextAlias()
	_cAlias2 := GetNextAlias()
	_cAlias3 := GetNextAlias()

	DbSelectArea("PD1")

	_cQuery1 := " SELECT DISTINCT PD1_FILIAL, PD1_CODROM, PD1_KMSAID, PD1_KMCHEG, 
	_cQuery1 += " PD1_XCHKV, PD1_XCONF, PD1_XDTCH1, PD1_XDTCH2, PD1_DTENT, PD1_PLACA
	_cQuery1 += " ,PD1_MOTORI, PD1_AJUDA1, PD1_XROTA, PD1_AJUDA2, PD1.R_E_C_N_O_ PD1REC, PD1_XCHKVO, PD1_STATUS
	_cQuery1 += " ,PD1_USRMOT,PD1_USRAJ1,PD1_USRAJ2
	_cQuery1 += " FROM "+RetSqlName("PD1")+" PD1
	_cQuery1 += " LEFT JOIN "+RetSqlName("PD2")+" PD2
	_cQuery1 += " ON PD2_FILIAL=PD1_FILIAL AND PD2_CODROM=PD1_CODROM
	_cQuery1 += " WHERE PD1.D_E_L_E_T_=' '
	_cQuery1 += " AND PD1_FILIAL='02' AND PD1_STATUS IN ('2','4','5') AND PD1_PLACA NOT IN ('RET','TNT')
	/*
	If !(_cUsuario $ GetMv("STRESTD01",,"000677"))

		_cQuery1 += " AND (
		_cQuery1 += " (PD1_USRMOT='"+_cUsuario+"') OR
		_cQuery1 += " (PD1_USRAJ1='"+_cUsuario+"') OR 
		_cQuery1 += " (PD1_USRAJ2='"+_cUsuario+"') 
		_cQuery1 += " )

	EndIf
	*/
	_cQuery1 += " ORDER BY PD1_CODROM

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	cResp := '{
	cResp += '"qtdbipes":"'+AllTrim(GetMv("STREST601",,"15"))+'",
	cResp += '"supervisores":"'+AllTrim(GetMv("STRESTD01",,"000677"))+'",
	cResp += '"romaneios":{

	If (_cAlias1)->(!Eof())

		cResp += '"numeros": [

		While (_cAlias1)->(!Eof())

			PD1->(DbGoTo((_cAlias1)->PD1REC))

			cResp += '{
			cResp += '"codigo": "'+(_cAlias1)->PD1_CODROM+'",

			_cChecSup  := "N"
			_cChecVeic := "N"
			_cCheckIn  := "N"
			_cCheckOut := "N"

			If !Empty((_cAlias1)->PD1_XDTCH2)
				_cChecVeic := "S"
			EndIf
			If !Empty((_cAlias1)->PD1_XDTCH1)
				_cCheckIn := "S"
			EndIf
			If !Empty((_cAlias1)->PD1_XCONF)
				_cChecSup := "S"
			EndIf
			If !Empty((_cAlias1)->PD1_KMCHEG)
				_cCheckOut := "S"
			EndIf

			_cAlertasC := AllTrim((_cAlias1)->PD1_XCHKV)
			_cAlertasD := ""

			For _nX:=1 To Len(_cAlertasC)
				If SubStr(_cAlertasC,_nX,1)=="F"
					Do Case
						Case _nX==1
						_cAlertasD += "Cinto de seguranca / "
						Case _nX==2
						_cAlertasD += "Retrovisores / "
						Case _nX==3
						_cAlertasD += "Limpeza externa/interna / "
						Case _nX==4
						_cAlertasD += "Farois / "
						Case _nX==5
						_cAlertasD += "Setas e buzina / "
						Case _nX==6
						_cAlertasD += "Freio / "
						Case _nX==7
						_cAlertasD += "Freio de mao / "
						Case _nX==8
						_cAlertasD += "Limpador de para-brisas / "
						Case _nX==9
						_cAlertasD += "Lampadas internas / "
						Case _nX==10
						_cAlertasD += "Ruidos anormais / "
						Case _nX==11
						_cAlertasD += "Funcionamento painel / "
						Case _nX==12
						_cAlertasD += "Estado das portas / "
						Case _nX==13
						_cAlertasD += "Estados dos vidros / "
						Case _nX==14
						_cAlertasD += "Nivel agua e oleo motor/radiador / "
						Case _nX==15
						_cAlertasD += "Lacre das placas / "
						Case _nX==16
						_cAlertasD += "Estepe/chave de roda/triangulo / "
						Case _nX==17
						_cAlertasD += "Calibragem dos pneus / "
						Case _nX==18
						_cAlertasD += "Suspensao/molas/amortecedor / "
						Case _nX==19
						_cAlertasD += "Estado da direcao e oleo / "
						Case _nX==20
						_cAlertasD += "Bancos e estofados / "
						Case _nX==21
						_cAlertasD += "Nivel do arla / "
						Case _nX==22
						_cAlertasD += "Estado do carrinho de mao / "
						Case _nX==23
						_cAlertasD += "Capacetes/colete/capa de chuva / "
						Case _nX==24
						_cAlertasD += "Teclado positron/gps/mensagem / "
						Case _nX==25
						_cAlertasD += "Disco de tacografo / "
					EndCase
				EndIf
			Next
			
			cResp += '"status": "'+AllTrim((_cAlias1)->PD1_STATUS)+'",
			cResp += '"alertas": "'+_cAlertasD+AllTrim((_cAlias1)->PD1_XCHKVO)+'",
			cResp += '"kmsaida": "'+(_cAlias1)->PD1_KMSAID+'",
			cResp += '"data": "'+DTOC(STOD((_cAlias1)->PD1_DTENT))+'",
			cResp += '"placa": "'+(_cAlias1)->PD1_PLACA+'",
			cResp += '"motorista": "'+(_cAlias1)->PD1_MOTORI+'",
			cResp += '"codmot": "'+AllTrim((_cAlias1)->PD1_USRMOT)+'",
			cResp += '"ajudante": "'+(_cAlias1)->PD1_AJUDA1+'",
			cResp += '"codaj1": "'+AllTrim((_cAlias1)->PD1_USRAJ1)+'",	
			cResp += '"ajudante2": "'+(_cAlias1)->PD1_AJUDA2+'",
			cResp += '"codaj2": "'+AllTrim((_cAlias1)->PD1_USRAJ2)+'",
			cResp += '"rota": "'+(_cAlias1)->PD1_XROTA+'",

			cResp += '"checksup": "'+_cChecSup+'",
			cResp += '"checkveic": "'+_cChecVeic+'",
			cResp += '"checkin": "'+_cCheckIn+'",
			cResp += '"checkout": "'+_cCheckOut+'",
			cResp += '"notas": [

			_cQuery2 := " SELECT F2_DOC, F2_CHVNFE, PD2_SERIES, PD2_CLIENT, PD2_LOJCLI, PD2_STATUS
			_cQuery2 += " FROM "+RetSqlName("PD1")+" PD1
			_cQuery2 += " LEFT JOIN "+RetSqlName("PD2")+" PD2
			_cQuery2 += " ON PD1_FILIAL=PD2_FILIAL AND PD1_CODROM=PD2_CODROM
			_cQuery2 += " LEFT JOIN "+RetSqlName("SF2")+" F2
			_cQuery2 += " ON F2_FILIAL=PD2_FILIAL AND F2_DOC=PD2_NFS
			_cQuery2 += " AND F2_SERIE=PD2_SERIES AND F2_CLIENTE=PD2_CLIENT AND F2_LOJA=PD2_LOJCLI
			_cQuery2 += " WHERE PD1.D_E_L_E_T_=' ' AND PD2.D_E_L_E_T_=' '
			_cQuery2 += " AND F2.D_E_L_E_T_=' '
			_cQuery2 += " AND PD1_FILIAL='"+(_cAlias1)->PD1_FILIAL+"' AND PD1_CODROM='"+(_cAlias1)->PD1_CODROM+"'

			If !Empty(Select(_cAlias2))
				DbSelectArea(_cAlias2)
				(_cAlias2)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

			dbSelectArea(_cAlias2)

			(_cAlias2)->(dbGoTop())

			While (_cAlias2)->(!Eof())

				cResp += '{"nota": "'+(_cAlias2)->F2_DOC+'", "chave": "'+(_cAlias2)->F2_CHVNFE+'", "status": "'+GetStNf((_cAlias2)->PD2_STATUS)+'",
				cResp += '"volumes": [

				_cQuery3 := " SELECT CB6_VOLUME
				_cQuery3 += " FROM "+RetSqlName("PD1")+" PD1
				_cQuery3 += " LEFT JOIN "+RetSqlName("PD2")+" PD2
				_cQuery3 += " ON PD1_FILIAL=PD2_FILIAL AND PD1_CODROM=PD2_CODROM
				_cQuery3 += " LEFT JOIN "+RetSqlName("SF2")+" F2
				_cQuery3 += " ON F2_FILIAL=PD2_FILIAL AND F2_DOC=PD2_NFS
				_cQuery3 += " AND F2_SERIE=PD2_SERIES AND F2_CLIENTE=PD2_CLIENT AND F2_LOJA=PD2_LOJCLI
				_cQuery3 += " LEFT JOIN "+RetSqlName("CB7")+" CB7
				_cQuery3 += " ON CB7_FILIAL=F2_FILIAL AND CB7_NOTA=F2_DOC
				_cQuery3 += " AND CB7_SERIE=F2_SERIE AND CB7_CLIENT=F2_CLIENTE AND CB7_LOJA=F2_LOJA
				_cQuery3 += " LEFT JOIN "+RetSqlName("CB6")+" CB6
				_cQuery3 += " ON CB6_FILIAL=CB7_FILIAL AND CB7_PEDIDO=CB6_PEDIDO AND CB7_ORDSEP=CB6_XORDSE
				_cQuery3 += " WHERE PD1.D_E_L_E_T_=' ' AND PD2.D_E_L_E_T_=' '
				_cQuery3 += " AND F2.D_E_L_E_T_=' ' AND CB7.D_E_L_E_T_=' ' AND CB6.D_E_L_E_T_=' '
				_cQuery3 += " AND PD1_FILIAL='"+(_cAlias1)->PD1_FILIAL+"' AND PD1_CODROM='"+(_cAlias1)->PD1_CODROM+"'
				_cQuery3 += " AND PD2_NFS='"+(_cAlias2)->F2_DOC+"' AND PD2_SERIES='"+(_cAlias2)->PD2_SERIES+"'
				_cQuery3 += " ORDER BY PD1_CODROM, F2_DOC, CB6_VOLUME

				If !Empty(Select(_cAlias3))
					DbSelectArea(_cAlias3)
					(_cAlias3)->(dbCloseArea())
				Endif

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

				dbSelectArea(_cAlias3)

				(_cAlias3)->(dbGoTop())

				While (_cAlias3)->(!Eof())

					cResp += '{"volume": "'+(_cAlias3)->CB6_VOLUME+'"}

					(_cAlias3)->(DbSkip())

					If (_cAlias3)->(!Eof())
						cResp += ','
					EndIf

				EndDo

				cResp += ']}

				(_cAlias2)->(DbSkip())

				If (_cAlias2)->(!Eof())
					cResp += ',
				EndIf

			EndDo

			cResp += ']
			cResp += '}

			(_cAlias1)->(DbSkip())

			If (_cAlias1)->(!Eof())
				cResp += ',
			EndIf

		EndDo

		cResp += ']

	EndIf

	cResp += '}}
	
	Conout(cResp)

	::SetResponse(cResp)

Return .T.

Static Function GetStNf(_cStatus)

	Local _cDesc := ""

	_cStatus := AllTrim(_cStatus)

	Do Case
		Case _cStatus=="3"
		_cDesc := "Pendente entrega"
		Case _cStatus=="4"
		_cDesc := "Entregue"
		Case _cStatus=="5"
		_cDesc := "Não entregue"
	EndCase

Return(_cDesc)
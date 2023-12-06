#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT120        | Autor | RENATO.OLIVEIRA           | Data | 07/05/2019  |
|=====================================================================================|
|Descrição | Enviar wf do resíduo						                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT120()

	Local _cQuery1 := ""
	Local _cAlias1 := ""
	Local _cQuery2 := ""
	Local _cAlias2 := ""
	Local cNewEmp  := "01"
	Local cNewFil  := "02"
	
	Reset Environment

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	_cAlias1 := GetNextAlias()
	_cAlias2 := GetNextAlias()

	_cQuery1 := " SELECT C5.R_E_C_N_O_ RECSC5
	_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
	_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND C5_FILIAL='"+cNewFil+"'
	_cQuery1 += " AND SUBSTR(C5_NOTA,1,1)='X' AND C5_XWFRES=' ' AND C5_TIPO='N' AND C5_XMOTRES<>' '

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	DbSelectArea("SC5")

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	While (_cAlias1)->(!Eof())

		SC5->(DbGoTo((_cAlias1)->RECSC5))
		SA1->(DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI)))

		If SC5->(!Eof()) .And. SA1->(!Eof())

			_cEmail	  := GetMv("ST_WFRESID",,"renato.oliveira@steck.com.br")
			_cCopia   := " "
			_cAssunto := "[WFPROTHEUS] - Pedido "+SC5->C5_NUM+" foi eliminado resíduo"
			_aAttach  := {}
			_cCaminho := ""
			_cTipo	  := "Parcial"

			If (SC5->C5_ZFATBLQ = '3' .Or. Empty(Alltrim(SC5->C5_ZFATBLQ)))
				_cTipo := "Total"
			EndIf

			cMsg := ""
			cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
			cMsg += '<b>Filial: </b>'+Alltrim(SC5->C5_FILIAL)+'<br><b>Pedido: </b>'+SC5->C5_NUM
			cMsg += '<br><b>Cliente: </b>'+Alltrim(SA1->A1_NOME)
			cMsg += '<br><b>Motivo: </b>'+Alltrim(SC5->C5_XMOTRES)
			cMsg += '<br><b>Tipo: </b>'+_cTipo

			_cQuery2 := " SELECT C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_QTDENT, C6_PRCVEN, C6_XUSRRES, C6.D_E_L_E_T_ as XDEL
			_cQuery2 += " FROM "+RetSqlName("SC6")+" C6
			_cQuery2 += " WHERE C6_FILIAL='"+SC5->C5_FILIAL+"' AND C6_NUM='"+SC5->C5_NUM+"'
			_cQuery2 += " AND (C6_BLQ='R' OR C6.D_E_L_E_T_='*') AND C6_XUSRRES <> ' '
			_cQuery2 += " ORDER BY   C6_ITEM  

			If !Empty(Select(_cAlias2))
				DbSelectArea(_cAlias2)
				(_cAlias2)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

			dbSelectArea(_cAlias2)
			(_cAlias2)->(dbGoTop())

			If (_cAlias2)->(!Eof())
				cMsg += '<br><b>Usuário: </b>'+UsrRetName((_cAlias2)->C6_XUSRRES)+'<br><br>'
			EndIf
			
			_cUser := UsrRetName((_cAlias2)->C6_XUSRRES)

			cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
			cMsg += '<TR BgColor=#FFFFFF>'
			cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Item</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Produto</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Qtde eliminada</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Valor</Font></B></TD>'
			cMsg += '<TD><B> <Font Color="red" Size="3" Face="Arial">Tipo</Font></B></TD>'
			cMsg += '</TR>'
			
			_aItensExc := {}

			While (_cAlias2)->(!Eof())

				cMsg += '<TR BgColor=#66FF66>'
				cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias2)->C6_ITEM+'</Font></B></TD>'
				cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+(_cAlias2)->C6_PRODUTO+'</Font></B></TD>'
				cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+CVALTOCHAR((_cAlias2)->(C6_QTDVEN-C6_QTDENT))+'</Font></B></TD>'
				cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+CVALTOCHAR((_cAlias2)->(C6_QTDVEN-C6_QTDENT)*(_cAlias2)->C6_PRCVEN)+'</Font></B></TD>'
				cMsg += '<TD><B> <Font Color="#000000" Size="2" Face="Arial">'+IiF(Empty(Alltrim((_cAlias2)->XDEL)),'Residuo','Excluido')+'</Font></B></TD>'
				cMsg += '</TR>'
				
				AADD(_aItensExc,{(_cAlias2)->C6_ITEM,(_cAlias2)->C6_PRODUTO,(_cAlias2)->(C6_QTDVEN-C6_QTDENT),(_cAlias2)->(C6_QTDVEN-C6_QTDENT)*(_cAlias2)->C6_PRCVEN})

				(_cAlias2)->(DbSkip())
			EndDo

			cMsg += '</Table>'
			cMsg += '</body></html>'

			If !Empty(SC5->C5_ZDTREJE) //Rejeitado pelo financeiro
				_cEmail 	:= Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_EMAIL"))+" ; "+Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL"))+" ; "+Alltrim(Posicione("SA3",1,xFilial("SA3")+(Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_SUPER"))),"A3_EMAIL"))
				_cCopia  	:= " davi.souza@steck.com.br;eduardo.santos@steck.com.br "
			EndIf
			
			U_STGRVZ51(SC5->C5_NUM,Date(),Time(),Alltrim(SC5->C5_XMOTRES),"Total",_cUser,_aItensExc)
			U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

			SC5->(RecLock("SC5",.F.))
			SC5->C5_XWFRES := "S"
			SC5->(MsUnLock())

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

Return()
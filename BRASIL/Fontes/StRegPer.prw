#include 'protheus.ch'
#include 'parmtype.ch'

User Function StRegPer()

	Local aBkArea			:=	GetArea()
	Local cTop01			:= GetNextAlias()
	Local lAtivo				:=SuperGetMv("STREGPER01",.F.,.T.)			//PARAMETRO UTILIZADO PARA DESATIVAR ROTINA
	Local cCodTransp	:=SuperGetMv("STREGPER02",.F.,"000163|")//PARAMETRO UTILIZADO PARA INFORMAR AS TRANSPORTADORAS UTILIZADAS NA ROTINA
	Local cTpOper			:=SuperGetMv("STREGPER03",.F.,"91|")			//PARAMETRO UTILIZADO PARA REGISTRAR O TIPO DE OPERAÇÃO UTILIZADO PARA GRAVAR NA TABELA Z29 PEDIDO DE VENDA UTLIZAR "|" PARA 

	If !lAtivo
		Return()
	EndIf

	If SF2->F2_TIPO="N" .And. AllTrim(SF2->F2_TRANSP) $ cCodTransp

		cQuery	:=		" SELECT COUNT(C6_OPER) OPER " + CRLF
		cQuery	+=	" FROM "+RetSqlName("SD2")+" SD2 " + CRLF
		cQuery+=	" INNER JOIN "+RetSqlName("SC6")+" SC6 ON C6_FILIAL=D2_FILIAL AND C6_NUM=D2_PEDIDO AND C6_ITEM=D2_ITEMPV AND C6_OPER IN "+FormatIn(cTpOper,"|")+" AND SC6.D_E_L_E_T_!='*' " + CRLF 
		cQuery+=	" WHERE D2_FILIAL='"+cFilAnt+"' AND D2_DOC='"+SF2->F2_DOC+"' AND D2_SERIE='"+SF2->F2_SERIE+"' AND SD2.D_E_L_E_T_!='*' " + CRLF

		If !Empty(Select(cTop01))
			DbSelectArea(cTop01)
			(cTop01)->(dbCloseArea())
		Endif

		dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery),cTop01, .T., .T. )

		If (cTop01)->OPER>0

			dbSelectArea("Z29")
			Z29->(dbSetOrder(2))
			/*
			1 - Z29_FILIAL+DTOS(Z29_DATA)
			2 - Z29_FILIAL+Z29_CLI+Z29_LOJA+Z29_DOC+Z29_SERIE
			3 - Z29_FILIAL+Z29_DOC+Z29_SERIE+Z29_CLI+Z29_LOJA
			*/	
			If !Z29->(dbSeek(xFilial("SF2")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE))
				RecLock("Z29",.T.)
				Z29->Z29_FILIAL	:= 	SF2->F2_FILIAL
				Z29->Z29_DATA		:=		SF2->F2_EMISSAO
				Z29->Z29_CODTRA:=	SF2->F2_TRANSP
				Z29->Z29_NTRANS:=	GetAdvFVal("SA4","A4_NOME",xFilial("SA4")+SF2->F2_TRANSP,1,"ERRO")
				Z29->Z29_DOC		:=		SF2->F2_DOC
				Z29->Z29_SERIE		:=		SF2->F2_SERIE
				Z29->Z29_CLI			:=		SF2->F2_CLIENTE
				Z29->Z29_LOJA		:=		SF2->F2_LOJA
				Z29->Z29_NCLI		:=		GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"ERRO")
				Z29->Z29_VALOR	:=		SF2->F2_VALBRUT
				Z29->Z29_STATUS	:=		'1'
				Z29->(MsUnLock())
			EndIf

		EndIf

	EndIf

	RestArea(aBkArea)

Return()
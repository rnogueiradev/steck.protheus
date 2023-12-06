#include 'Protheus.ch'
#include 'Topconn.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | M410STTS         | Autor | RENATO.OLIVEIRA          | Data | 04/02/2020  |
|=====================================================================================|
|Descrição |  PE no final da alteração do pedido                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function M410STTS()
	Local _nOper  := PARAMIXB[1]
	Local _aArea  := GetArea()
	Local cArea   := GetNextAlias()
	Local cSQL    := ""
	Local nBase   := 0
	Local cMun    := ""
	Local cMuniSt := ''
	Local aTPACTI := &(" "+SuperGetMV("ST_TPACTI",.T., "{'4659', '4663' }" )+" ")   
	Local aMUNICI := &(" "+SuperGetMV("ST_MUNIC" ,.T., "{{'11001', 980000 },{'68001', 980000 },{'05001', 980000 } }" )+" ") 	
	Local cCIIU	  := ''
	Local cCIIUSA1:= ''
	Local nY:=0
	Local nX:=0
	// Inicio revision si cumple con la base ICA
	If _nOper==3 .or.  ; //- Inclusão
	   _nOper==4 // - Alteração
	   	If Select(cArea) > 0  //Abierto ? cerrar..
			dbSelectArea(cArea)
			dbCloseArea()
		EndIf
		cSQL:="SELECT C5_NUM, SUM(C6_VALOR) AS SUMA FROM " + RETSQLNAME("SC5") +" SC5  LEFT JOIN " + RETSQLNAME("SC6") +" SC6 ON C5_NUM=C6_NUM AND SC6.D_E_L_E_T_='' WHERE SC5.D_E_L_E_T_='' AND C5_NUM='"+SC5->C5_NUM+"' GROUP BY C5_NUM "
		cSQL:=ChangeQuery(cSQL)
		dbUseArea(.T., 'TOPCONN', TCGENQRY(,,cSQL), cArea , .F., .T.)
		DbSelectArea(cArea)
		cMun     := alltrim(POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_COD_MUN"))
		cCIIUSA1 := POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_ATIVIDA")
		If !('SB'$cCIIUSA1)  // Se salta cuando el cliente siempre retiene 
			For nX:=1 to len(aMUNICI)
				nBase := aMUNICI[nX][2] // BASE ICA  POSICIONE("SFF",)
				cMuniSt:=aMUNICI[nX][1]
				For nY:=1 to len(aTPACTI)
					IF ALLTRIM(SC5->C5_TPACTIV)==aTPACTI[nY]
						cCIIU:=aTPACTI[nY]
					EndIf
				Next

				// Valdemir Rabelo 27/06/2023 - Irá assumir o que está no cliente
				cCIIU :=  cCIIUSA1                          //if(EMPTY(cCIIU),"4659",cCIIU)
				/*
					Removido devido as orientação da Jaqueline 27/06/2023


				IF (cArea)->SUMA >= nBase .AND. cMun==cMuniSt //Base ICA
					SC5->(RecLock("SC5",.F.))
					SC5->C5_TPACTIV:=SUBSTR(cCIIU+'SB       ',1,7)  //oBLIGA A CALCULAR ica
					SC5->(MsUnLock())
				ElseIf	(cArea)->SUMA < nBase .AND. cMun==cMuniSt //Base ICA
					SC5->(RecLock("SC5",.F.))
					SC5->C5_TPACTIV:=SUBSTR(cCIIU+'CB       ',1,7) // iMPIDE CALCULO ICA
					SC5->(MsUnLock())
				EndIf
				*/
			Next
		EndIf
		(cArea)->(dbCloseArea())
	EndIf
	// Fin revision si cumple con la base ICA



	/*/ Temporal por Axel
	U_COFAT040()
	/*/ //MATA416
	
	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	If INCLUI
		If SA3->(DbSeek(xFilial("SA3")+__cUserId))
			SC5->(RecLock("SC5",.F.))
			SC5->C5_VEND1 	:= SA3->A3_COD
			SC5->C5_XCODINC := __cUserID
			SC5->C5_XNOMINC := cUserName
			SC5->(MsUnLock())
		EndIf
	EndIf



	RestArea(_aArea)

Return()

/*====================================================================================\
|Programa  | COFAT040         | Autor | RENATO.OLIVEIRA          | Data | 04/02/2020  |
|=====================================================================================|
|Descrição |  Atualizar status do pedido de venda                                     |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function COFAT040()

	Local _cQuery1 	:= ""
	Local _cAlias1  := GetNextAlias()
	Local _cStatus  := ""

	/*
	0 - Pedido pendente
	1 - Bloqueado no financeiro
	2 - Bloqueado no estoque
	3 - Bloqueado no estoque/financeiro
	4 - Aguardando aprovação
	5 - Aprovado
	6 - Faturado
	7 - Cancelado
	*/

	_cQuery1 := " SELECT DISTINCT C9_BLEST, C9_BLCRED
	_cQuery1 += " FROM "+RetSqlName("SC9")+" C9
	_cQuery1 += " WHERE C9.D_E_L_E_T_=' ' AND C9_FILIAL='"+SC5->C5_FILIAL+"' AND C9_PEDIDO='"+SC5->C5_NUM+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_lBlCre := .F.
	_lBlEst	:= .F.
	_lFat	:= .F.
	_lCanc	:= .F.
	_lPend	:= .F.
	_lLib	:= .F.

	If (_cAlias1)->(!Eof())
		While (_cAlias1)->(!Eof())

			If (_cAlias1)->C9_BLCRED $ "01#04#05"
				_lBlCre := .T.
			EndIf
			If (_cAlias1)->C9_BLEST $ "02#03"
				_lBlEst := .T.
			EndIf
			If Empty((_cAlias1)->C9_BLCRED) .And. Empty((_cAlias1)->C9_BLEST)
				_lLib := .T.
			EndIf
			If (_cAlias1)->C9_BLCRED=="10" .And. (_cAlias1)->C9_BLEST=="10"
				_lFat := .T.
			EndIf
			If SubStr(SC5->C5_NOTA,1,1)=="X"
				_lCanc := .T.
			EndIf

			(_cAlias1)->(DbSkip())
		EndDo
	Else
		_lPend := .T.
	EndIf

	If _lFat
		_cStatus := "6"
	EndIf
	If _lLib
		_cStatus := "4"
	EndIf
	If _lBlCre
		_cStatus := "1"
	EndIf
	If _lBlEst
		_cStatus := "2"
	EndIf
	If _lBlCre .And. _lBlEst
		_cStatus := "3"
	EndIf
	If _lPend
		_cStatus := "0"
	EndIf
	If _lCanc
		_cStatus := "7"
	EndIf

	_lDesc 		:= .F.
	_lAmostra	:= .F.

	If AllTrim(_cStatus)=="4"

		DbSelectArea('SC6')
		SC6->(DbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
		If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
			While SC6->(!Eof()) .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM
				If SC6->C6_DESCONT>60 //Caso o desconto seja maior que isso necessita de aprovação
					_lDesc := .T.
				EndIf
				If AllTrim(SC6->C6_TES)=="503"
					_lAmostra := .T.
				EndIf
				SC6->(DbSkip())
			EndDo
		EndIf

		If !_lDesc .And. _lLib
			_cStatus := "5"
		EndIf
		If _lAmostra .And. _lLib
			_cStatus := "4"
		EndIf

		If GetMv("ST_BLQPEDS",,.T.)
			_cStatus := "4"
		EndIf

	EndIf

	SC5->(RecLock("SC5",.F.))
	SC5->C5_XSTATUS := _cStatus
	SC5->(MsUnLock())

Return()

/*====================================================================================\
|Programa  | COFAT041         | Autor | RENATO.OLIVEIRA          | Data | 04/02/2020  |
|=====================================================================================|
|Descrição |  Aprovar pedido de venda			                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function COFAT041()

	If !__cUserId $ GetMv("COFAT04101",,"001179#001184")
		MsgAlert("Usuario sin acceso!")
		Return()
	EndIf

	If !SC5->C5_XSTATUS=="4"
		MsgAlert("Este pedido no está pendiente de aprobación!")
		Return()
	EndIf

	If !MsgYesNo("Confirma la liberación del pedido?")
		Return()
	EndIf

	SC5->(RecLock("SC5",.F.))
	SC5->C5_XSTATUS := "5"
	SC5->(MsUnLock())

Return()

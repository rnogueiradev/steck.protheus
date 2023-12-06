#include 'Protheus.ch'
#include 'RwMake.ch'
#DEFINE CR    chr(13)+chr(10)
/*====================================================================================\
|Programa  | ms520vld          | Autor | GIOVANI.ZAGO             | Data | 16/04/2013 |
|=====================================================================================|
|Descrição | ms520vld                                                                 |
|          |  Valida estorno da NF saida			                                  |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | ms520vld                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*-----------------------------*
User Function ms520vld()
	*-----------------------------*
	Local _aarea      := getarea()
	Local _lRetG      := STRETGUIA() //Verifica se existe se2 guia a pagar Giovani Zago 17/01/14

	_lRetG := GETROMAN()

	Restarea(_aarea)
	Return(_lRetG)   

	/*====================================================================================\
	|Programa  | STRETGUIA         | Autor | GIOVANI.ZAGO             | Data | 16/04/2013 |
	|=====================================================================================|
	|Descrição | STRETGUIA                                                                |
	|          |  Valida estorno da NF saida			                                  |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STRETGUIA                                                                |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/

	*-----------------------------*
Static Function STRETGUIA()
	*-----------------------------*
	Local _lRetX    := .T.
	Local _xAlias  := GetArea()

	If !(Empty(Alltrim(SF2->F2_XGUIA)))

		dbselectarea("SE2")
		SE2->(dbSetOrder(1))
		If SE2->(DbSeek(Xfilial("SE2")  +'FIN'+SF2->F2_EST+Right( AllTrim( SF2->F2_DOC ) , 5 )+'  '+'   '+'TX '+'ESTADO'+'00'  ) )
			//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
			If !(Empty(Alltrim(SE2->E2_NUMBOR)))
				_lRetX    := .T.
				MsgInfo('Existe Titulo no Financeiro(Guia de Recolhimento)'+CR+CR+'Avise ao Financeiro')

			Else
				DbSelectArea("SM0")
				DbSelectArea("SF6")
				SF6->(dbSetOrder(1))
				If SF6->(DbSeek(Xfilial("SF6")  +SF2->F2_EST+SE2->E2_NUM ) )
					SF6->(RecLock("SF6",.T.))
					SF6->(DbDelete())
					SF6->(MsUnlock())
					SF6->(DbCommit())
				EndIf
				RecLock('SE2',.F.)
				SE2->E2_XGUIA := 	ALLTRIM(SE2->E2_XGUIA)+"//Excluido Usuario: "+cusername+" - Data: "+dtoc(date())+" - Hora: "+Time()
				SE2->( DbDelete())
				SE2->( MsUnLock())
				SE2->( DbCommit())
			EndIf
		EndIf
	EndIf
	RestArea(_xAlias)
Return(_lRetX)

/*/{Protheus.doc} GETROMAN
@name GETROMAN
@type Static Function
@desc verificar se nota já possui romaneio gerado
@author Renato Nogueira
@since 17/05/2018
/*/

Static Function GETROMAN()

	Local _lRet 	:= .T.
	Local _cQuery1 	:= ""
	Local _cAlias1  := GetNextAlias()

	_cQuery1 := " SELECT PD2_CODROM
	_cQuery1 += " FROM "+RetSqlName("PD2")+" PD2
	_cQuery1 += " WHERE PD2.D_E_L_E_T_=' ' AND PD2_FILIAL='"+SF2->F2_FILIAL+"' AND PD2_NFS='"+SF2->F2_DOC+"'
	_cQuery1 += " AND PD2_SERIES='"+SF2->F2_SERIE+"' AND PD2_CLIENT='"+SF2->F2_CLIENTE+"' AND PD2_LOJCLI='"+SF2->F2_LOJA+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		_lRet := .F.
		MsgAlert("ESSA OPERAÇAO NÃO PODE SER REALIZADA POIS A NOTA FISCAL POSSUI ROAMANEIO DE ENTREGA, FAVOR VERIFICAR COM O TRANSPORTE!"+CRLF+;
		"Romaneio "+Alltrim((_cAlias1)->PD2_CODROM))
	EndIf	 

Return(_lRet)
#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STATF01    บ Autor ณ Vitor Merguizo     บ Data ณ  02/06/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo Criada para retornar o proximo numero de Ativo      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function STATF01()

Local aArea		:= GetArea()
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local cRet 		:= "0000000000"

cQuery := "SELECT MAX(N1_CBASE) N1_CBASE FROM "+RetSqlName("SN1")+" SN1 WHERE N1_FILIAL <> '  ' AND D_E_L_E_T_= ' '"

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)

TCSetField(cAlias,"N1_CBASE"	,"C",10,0 )

DbSelectArea(cAlias)
(cAlias)->(dbGoTop())
While (cAlias)->(!Eof())
	cRet := (cAlias)->N1_CBASE	
	(cAlias)->(dbSkip())
EndDo

cRet := SOMA1(cRet)
/* Removido\Ajustado - Nใo executa mais RecLock na X6. Cria็ใo/altera็ใo de dados deve ser feita apenas pelo m๓dulo Configurador ou pela rotina de atualiza็ใo de versใo.
DbSelectArea("SX6")
SX6->(DbSetOrder(1))
If SX6->(DbSeek(xFilial("SX6")+"MV_CBASEAF"))
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := SX6->X6_CONTSPA := SX6->X6_CONTENG := SOMA1(cRet)
	MsUnlock()	
EndIf*/

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

RestArea(aArea)

Return(cRet)

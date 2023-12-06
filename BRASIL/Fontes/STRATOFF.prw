#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTRATOFF  บAutor  ณMicrosiga           บ Data ณ  09/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza a conta de origem dos lancamentos de rateios de   บฑฑ
ฑฑบ          ณ custos                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STRATOFF()

Local aSays		:= {}
Local aButtons	:= {}

Private cCadastro 	:= OemToAnsi("Atualiza็ใo de Lan็amentos de Rateio Off-Line.")
Private cPerg 		:= "STRATOFF"
Private aHeader 	:= {}
Private aCols		:= {}
Private cTabela		:= ""
Private oGetDados1
Private nOpcao 		:= 0

// Funcao para criacao de perguntas da rotina.
Ajusta()

Pergunte(cPerg,.t.)

AAdd(aSays,"Este programa tem como objetivo atualizar os Lan็amentos")
AAdd(aSays,"de Rateio Off-line com base nos parametros selecionados.")

AAdd(aButtons,{ 5,.T.,{|| Pergunte(cPerg,.t.) } } )
AAdd(aButtons,{ 1,.T.,{|| IIF(fConfMark(),FechaBatch(),nOpcao := 0) } } )
AAdd(aButtons,{ 2,.T.,{|| FechaBatch() } } )

FormBatch(cCadastro,aSays,aButtons)

If nOpcao == 1
	If ApMsgYesNo("Atualiza a conta de origem conforme parametros selecionados (S/N)?")
		Processa({||STRATOFA(),"Processando... "})
	EndIf
EndIf

MsgAlert("Processo Finalizado!")

Return

Static Function STRATOFA()

Local	cAlias 	:= "RATOFFQRY"
Local	cQuery	:= ""
Local	nCount	:= 0
Local	nC		:= 0
Local	cOrigem := ""

cQuery	:= "SELECT CT2REC, CTQ_RATEIO,CT2_DEBITO,CT2_CREDIT,CT2_CCD, CT2_CCC, ORIGEM FROM ( "
cQuery	+= " SELECT CT2.R_E_C_N_O_ CT2REC,CTQ_RATEIO,CT2_DEBITO,CT2_CREDIT,CT2_CCD, CT2_CCC, "
cQuery	+= " CASE WHEN CTQ_CTCPAR = CT2_DEBITO THEN '2' ELSE '1' END ORIGEM "
cQuery	+= " FROM "+RetSqlName("CT2")+" (NOLOCK) CT2 "
cQuery	+= " INNER JOIN "+RetSqlName("CTQ")+" (NOLOCK) CTQ ON "
cQuery	+= " CTQ_FILIAL = '"+xFilial("CTQ")+"' AND CTQ_MSBLQL = '2' AND CTQ.D_E_L_E_T_ = ' ' AND ( "
cQuery	+= " CTQ_CCORI = CT2_CCD AND CTQ_CCCPAR = CT2_CCC AND CTQ_CTCPAR = CT2_CREDIT AND (CTQ_CTORI = ' ' OR CTQ_CTORI = CT2_DEBITO) OR "
cQuery	+= " CTQ_CCORI = CT2_CCC AND CTQ_CCCPAR = CT2_CCD AND CTQ_CTCPAR = CT2_DEBITO AND (CTQ_CTORI = ' ' OR CTQ_CTORI = CT2_CREDIT)) "
cQuery	+= " WHERE "
cQuery	+= " CT2_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery	+= " CT2_LOTE = '001000' AND "
cQuery	+= " SUBSTR(CT2_DATA,1,6) = '"+StrZero(mv_par02,4,0)+StrZero(mv_par01,2,0)+"' AND "
cQuery	+= " CTQ.D_E_L_E_T_ = ' ' "
cQuery	+= " )XXX GROUP BY CT2REC, CTQ_RATEIO,CT2_DEBITO,CT2_CREDIT,CT2_CCD, CT2_CCC, ORIGEM ORDER BY CTQ_RATEIO,CT2REC"

cQuery	:= ChangeQuery(cQuery)

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)


dbSelectArea(cAlias)
(cAlias)->(DbGoTop())
dbeval({||nCount++})

//Monta a Regua
ProcRegua(nCount)

dbSelectArea(cAlias)
(cAlias)->(DbGoTop())
While (cAlias)->(!Eof())
	nC++
	IncProc("Atualizando Rateio: "+(cAlias)->CTQ_RATEIO+" - "+cValToChar(nC)+"/"+cValToChar(nCount))
	DbSelectArea("CT2")
	DbGoTo((cAlias)->CT2REC)
	If (cAlias)->CT2REC = CT2->(Recno())
		cOrigem := "D"+CT2->CT2_DEBITO+"C"+CT2->CT2_CREDIT
		If (cAlias)->ORIGEM = "2"
			RecLock("CT2",.F.)
			CT2->CT2_ORIGEM := cOrigem
			If AllTrim((cAlias)->CTQ_RATEIO)="000001"
				If Substr((cAlias)->CT2_CREDIT,1,3)="410"
					CT2->CT2_CREDIT := "410195002"  //IIF(AllTrim((cAlias)->CTQ_RATEIO)="000001","411095002",IIF(AllTrim((cAlias)->CTQ_RATEIO)="000002","411095003","550501001")) //(cAlias)->CT2_DEBITO
				ElseIf Substr((cAlias)->CT2_CREDIT,1,1)="4"
					CT2->CT2_CREDIT := "411095002"
				Else
					CT2->CT2_CREDIT := "550501002"
				EndIf
			ElseIf AllTrim((cAlias)->CTQ_RATEIO)="000002"
				If Substr((cAlias)->CT2_CREDIT,1,3)="410"
					CT2->CT2_CREDIT := "410195003"
				ElseIf Substr((cAlias)->CT2_CREDIT,1,1)="4"
					CT2->CT2_CREDIT := "411095003"
				Else
					CT2->CT2_CREDIT := "550501003" 
				EndIf
			Else
				If Substr((cAlias)->CT2_CREDIT,1,3)="410"
					CT2->CT2_CREDIT := "410195001"
				ElseIf Substr((cAlias)->CT2_CREDIT,1,1)="4"
					CT2->CT2_CREDIT := "411095001"
				Else
					CT2->CT2_CREDIT := "550501001"
				EndIf
			EndIf
			MsUnlock()
		Else
			RecLock("CT2",.F.)
			CT2->CT2_ORIGEM := cOrigem
			If AllTrim((cAlias)->CTQ_RATEIO)="000001"
				If Substr((cAlias)->CT2_DEBITO,1,3)="410"
					CT2->CT2_DEBITO := "410195002"  //IIF(AllTrim((cAlias)->CTQ_RATEIO)="000001","411095002",IIF(AllTrim((cAlias)->CTQ_RATEIO)="000002","411095003","550501001")) //(cAlias)->CT2_CREDIT
				ElseIf Substr((cAlias)->CT2_DEBITO,1,1)="4"
					CT2->CT2_DEBITO := "411095002"
				Else
					CT2->CT2_DEBITO := "550501002"
				EndIf
			ElseIf AllTrim((cAlias)->CTQ_RATEIO)="000002"
				If Substr((cAlias)->CT2_DEBITO,1,3)="410"
					CT2->CT2_DEBITO := "410195003"
				ElseIf Substr((cAlias)->CT2_DEBITO,1,1)="4"
					CT2->CT2_DEBITO := "411095003"
				Else
					CT2->CT2_DEBITO := "550501003"
				EndIf
			Else
				If Substr((cAlias)->CT2_DEBITO,1,3)="410"
					CT2->CT2_DEBITO := "410195001"
				ElseIf Substr((cAlias)->CT2_DEBITO,1,1)="4"
					CT2->CT2_DEBITO := "411095001"
				Else
					CT2->CT2_DEBITO := "550501001"
				EndIf
			EndIf
			MsUnlock()
		EndIf
	EndIf
	(cAlias)->(DbSkip())
End

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusta    บAutor  ณMicrosiga           บ Data ณ  03/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Insere novas perguntas na tabela SX1 a Ajusta o Picture    บฑฑ
ฑฑบ          ณ dos valores no SX3                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Mes ?                          ","Mes ?                         ","Mes ?                         ","mv_ch1","N",2,0,0,"G","NaoVazio().and.MV_PAR01<=12","mv_par01","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Ano ?             	         ","Ano ?             	          ","Ano ?                         ","mv_ch2","N",4,0,0,"G","NaoVazio().and.MV_PAR02<=2100.and.MV_PAR02>2000","mv_par02","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})

//AjustaSx1("STRATOFF",aPergs)

Return

Static Function fConfMark()

nOpcao := 1

Return(.T.)

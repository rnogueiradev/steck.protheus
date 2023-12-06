#Include "Protheus.Ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³DCRE      ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 07.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Preparacao do meio-magnetico para o DCR-E - Zona Franca     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STXML01()

Local aSays		:= {}
Local aButtons	:= {}

Private cCadastro 	:= OemToAnsi("Exportação de XML!")
Private cPerg 		:= "STXML01"
Private aHeader 	:= {}
Private aCols		:= {}
Private cTabela		:= ""
Private oGetDados1
Private nOpcao 		:= 0

// Funcao para criacao de perguntas da rotina.
Ajusta()

Pergunte(cPerg,.t.)

AAdd(aSays,"Este programa tem como objetivo exportar arquivos XML ")
AAdd(aSays,"com base nos parametros selecionados.")

AAdd(aButtons,{ 5,.T.,{|| Pergunte(cPerg,.t.) } } )
AAdd(aButtons,{ 1,.T.,{|| IIF(fConfMark(),FechaBatch(),nOpcao := 0) } } )
AAdd(aButtons,{ 2,.T.,{|| FechaBatch() } } )

FormBatch(cCadastro,aSays,aButtons)

If nOpcao == 1
		Processa({||STXML01A(),"Processando... "})
EndIf

MsgAlert("Processo Finalizado!")

Return

Static Function STXML01A()

Local cAlias	:= "QRYSPD50"
Local cDir		:= IIF(Empty(mv_par04),"C:\TEMP\",mv_par04)
Local cDest		:= ""
Local cNewFile	:= ""
Local cDrive    := ""
Local cExt      := ""
Local cDirRec	:= ""
Local nProcFil	:= 0
Local aProcFil	:= {.F.,cFilAnt}
Local nHandle	:= 0
Local nHdle	:= 0
Local aBufferFim := {}
Local nCount	:= 0
Local nPosChave := 0
Local cChave	:= ""
Private cBuffer	:= ""

cQuery := "SELECT ID_ENT,NFE_ID, "
cQuery += "CASE WHEN STATUSCANC = 2 THEN UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIGCAN,2000,00001)) ELSE UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIG,2000,00001)) END XML1, "
cQuery += "CASE WHEN STATUSCANC = 2 THEN UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIGCAN,2000,02001)) ELSE UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIG,2000,02001)) END XML2, "
cQuery += "STATUSCANC XML_TIPO "
cQuery += "FROM SPED050 "
cQuery += "WHERE "
cQuery += "ID_ENT = '"+mv_par05+"' AND "
cQuery += "NFE_ID BETWEEN '"+mv_par01+mv_par02+"' AND '"+mv_par01+mv_par03+"' "
cQuery += "ORDER BY 1,2 "

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
	IncProc("Gerando XML: "+(cAlias)->NFE_ID)

	cChave	:= ""
	cBuffer	:= ""
	cBuffer += AllTrim((cAlias)->XML1)
    
	If At(">",cBuffer) = 0
		cBuffer := U_STXML01C((cAlias)->ID_ENT,AllTrim((cAlias)->NFE_ID))
	EndIf

	nPosChave := At("chNFe>",cBuffer)
	If nPosChave > 0
		cChave := Substr(cBuffer,nPosChave+6,44)
	Else
		nPosChave := At("NFe351",cBuffer)
		If nPosChave > 0
			cChave := Substr(cBuffer,nPosChave+3,44)
		Else
			nPosChave := At("NFe350",cBuffer)
			If nPosChave > 0
				cChave := Substr(cBuffer,nPosChave+3,44)
			Else
				nPosChave := At("ID350",cBuffer)
				If nPosChave > 0
					cChave := Substr(cBuffer,nPosChave+2,44)
				Else
					nPosChave := At("ID351",cBuffer)
					If nPosChave > 0
						cChave := Substr(cBuffer,nPosChave+2,44)
	
					EndIf	
				EndIf
			EndIf
		EndIf
	EndIf
	
	cBuffer += AllTrim((cAlias)->XML2)

	If !Empty(AllTrim((cAlias)->XML2))
		U_STXML01B((cAlias)->ID_ENT,AllTrim((cAlias)->NFE_ID),2001)
	EndIf
    
	If Empty(cChave) .Or. Substr(cBuffer,1,1) <> "<"
		cDest := AllTrim((cAlias)->ID_ENT)+"_"+AllTrim((cAlias)->NFE_ID)+IIF((cAlias)->XML_TIPO=2,"-ped-canc","-nfe")+".xml"
	Else
		cDest := cChave+IIF((cAlias)->XML_TIPO=2,"-ped-canc","-nfe")+".xml"
	EndIf
	cNewFile := cDir + cDest
	SplitPath(cNewFile,@cDrive,@cDir,@cDest,@cExt)
	cDir := cDrive + cDir
	cDest+= cExt
	cDirRec := cDir
	aProcFil := {.F.,cFilAnt}
	Makedir(cDirRec)
	nHandle	:= 0
	nHdle := 0
	aBufferFim := {}
	
	FErase (cDir+cDest)
	nHdle := FCreate (cDir+cDest, 0)
			
	If ( FError() == 0 )
		FWrite(nHdle, cBuffer)
		FT_FUse()
		FClose(nHdle)
	EndIf
	(cAlias)->(DbSkip())
End

Return

User Function STXML01B(cEnt,cID,nStr)

Local cAlias1 := GetNextAlias()
Local cQuery1 := ""
Local nX := 0

cQuery1 := "SELECT ID_ENT,NFE_ID, "
For nX := 1 to 15
	nStr += 2000
	cQuery1 += "CASE WHEN STATUSCANC = 2 THEN UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIGCAN,2000,"+cValToChar(nStr)+")) ELSE UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIG,2000,"+cValToChar(nStr)+")) END XML"+cValToChar(nX)+", "
Next
cQuery1 += "STATUSCANC XML_TIPO "
cQuery1 += "FROM SPED050 "
cQuery1 += "WHERE "
cQuery1 += "ID_ENT = '"+cEnt+"' AND "
cQuery1 += "NFE_ID = '"+cID+"' "
cQuery1 += "ORDER BY 1,2 "

If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1),cAlias1, .F., .T.)

dbSelectArea(cAlias1)
(cAlias1)->(DbGoTop())
While (cAlias1)->(!Eof())
	cBuffer += AllTrim((cAlias1)->XML1)
	cBuffer += AllTrim((cAlias1)->XML2)
	cBuffer += AllTrim((cAlias1)->XML3)
	cBuffer += AllTrim((cAlias1)->XML4)
	cBuffer += AllTrim((cAlias1)->XML5)
	cBuffer += AllTrim((cAlias1)->XML6)
	cBuffer += AllTrim((cAlias1)->XML7)
	cBuffer += AllTrim((cAlias1)->XML8)
	cBuffer += AllTrim((cAlias1)->XML9)
	cBuffer += AllTrim((cAlias1)->XML10)
	cBuffer += AllTrim((cAlias1)->XML11)
	cBuffer += AllTrim((cAlias1)->XML12)
	cBuffer += AllTrim((cAlias1)->XML13)
	cBuffer += AllTrim((cAlias1)->XML14)
	cBuffer += AllTrim((cAlias1)->XML15)
	If !Empty(AllTrim((cAlias1)->XML15))
		U_STXML01B(cEnt,cID,nStr)
	EndIf
	(cAlias1)->(dbSkip())
End

If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

Return



User Function STXML01C(cEnt,cID,nStr)

Local cAlias2 := GetNextAlias()
Local cQuery2 := ""

cQuery2 := "SELECT CASE WHEN STATUSCANC = 2 THEN UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIGCAN,1994,7)) ELSE UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(XML_SIG,1994,7)) END XML1 "
cQuery2 += "FROM SPED050 "
cQuery2 += "WHERE "
cQuery2 += "ID_ENT = '"+cEnt+"' AND "
cQuery2 += "NFE_ID = '"+cID+"' "

If !Empty(Select(cAlias2))
	DbSelectArea(cAlias2)
	(cAlias2)->(dbCloseArea())
Endif

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery2),cAlias2, .F., .T.)

dbSelectArea(cAlias2)
(cAlias2)->(DbGoTop())
While (cAlias2)->(!Eof())
	cRet := AllTrim((cAlias2)->XML1)
	(cAlias2)->(dbSkip())
End

If !Empty(Select(cAlias2))
	DbSelectArea(cAlias2)
	(cAlias2)->(dbCloseArea())
Endif

Return(cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ajusta    ºAutor  ³Microsiga           º Data ³  03/30/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Insere novas perguntas na tabela SX1 a Ajusta o Picture    º±±
±±º          ³ dos valores no SX3                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Serie ?                        ","Serie ?                        ","Serie ?                        ","mv_ch1","C",03,0,0,"G","NaoVazio()","mv_par01","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Nota Fiscal de ?               ","Nota Fiscal de ?               ","Nota Fiscal de ?               ","mv_ch2","C",09,0,0,"G","NaoVazio()","mv_par02","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Nota Fiscal ate ?              ","Nota Fiscal ate ?              ","Nota Fiscal ate ?              ","mv_ch3","C",09,0,0,"G","NaoVazio()","mv_par03","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Local de Geração?              ","Local de Geração?              ","Local de Geração?              ","mv_ch4","C",60,0,0,"G",            ,"mv_par04","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Entidade ?                     ","Entidade ?                     ","Entidade ?                     ","mv_ch5","C",06,0,0,"G","NaoVazio()","mv_par05","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})

//AjustaSx1("STXML01",aPergs)

Return

Static Function fConfMark()

nOpcao := 1

Return(.T.)

#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FroxLoja  ºAutor:                         ºData ³ 01/04/03 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FroxLoja()
Local CodLoja, CodFor, strCodLoja
Local aintTabASCII, i, intASC, intTab, bolVaiUm, strNovaString
Local cAliaAnte,nAreaAnte,nRegiAnte

cAliaAnte := Alias()
nAreaAnte := IndexOrd()
nRegiAnte := RecNo()


If M->A2_TIPO <> "X" .AND. SUBSTR(M->A2_CGC,1,8) <> "00000000" 
	CodFor := Trim(M->A2_COD)
	strCodLoja := "01"
	dbSelectArea("SA2")                
	dbSetOrder(1)


	IF !dbSeek(xFilial("SA2")+CodFor)

	CodLoja := "01"

    Else
	    cQuery := " SELECT MAX(A2_LOJA) +1 ITEM FROM " +RetSqlName("SA2")+ " 
		cQuery += " WHERE A2_FILIAL = '"+xFilial("SA2")+"'"
		cQuery += " AND A2_COD = '"+CodFor+"'"
		cQuery += " AND D_E_L_E_T_ <> '*'"            
		MEMOWRITE("SA2.SQL",cQuery)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP8", .F., .T.)
	
		dbSelectArea("TMP8")
		If TMP8->(Eof())
			CodLoja := "01" 
			lOk		:=.t.
		Else
			CodLoja := StrZero(TMP8->ITEM,2)  
			lOk		:=.t.
		EndIf  
		
    
    ENDIF

ELSE
CodLoja := "01"
ENDIF
		               
dbSelectArea(cAliaAnte)
dbSetOrder(nAreaAnte)
dbGoTo(nRegiAnte)

Return(CodLoja)
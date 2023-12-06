#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ProxLoja ºAutor:                          ºData ³ 01/04/03 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ProxLoja()
Local CodLoja, CodCli, strCodLoja
Local aintTabASCII, i, intASC, intTab, bolVaiUm, strNovaString
Local cAliaAnte,nAreaAnte,nRegiAnte

cAliaAnte := Alias()
nAreaAnte := IndexOrd()
nRegiAnte := RecNo()

CodCli := Trim(M->A1_COD)
strCodLoja := "01"
dbSelectArea("SA1")                
dbSetOrder(1)

If M->A1_PESSOA = "J" .AND. M->A1_TIPO <> "X" .AND. SUBSTR(M->A1_CGC,1,8) <> "00000000" 

	IF !dbSeek(xFilial("SA1")+CodCli)

	CodLoja := "01"

    Else
	    cQuery := " SELECT MAX(A1_LOJA) +1 ITEM FROM " +RetSqlName("SA1")+ " 
		cQuery += " WHERE A1_FILIAL = '"+xFilial("SA1")+"'"
		cQuery += " AND A1_COD = '"+CodCli+"'"
		cQuery += " AND D_E_L_E_T_ <> '*'"            
		MEMOWRITE("SA1.SQL",cQuery)
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

Elseif M->A1_PESSOA = "F"

		CodLoja := "01" 

Endif	               

dbSelectArea(cAliaAnte)
dbSetOrder(nAreaAnte)
dbGoTo(nRegiAnte)

Return(CodLoja)
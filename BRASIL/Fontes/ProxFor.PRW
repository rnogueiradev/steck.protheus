#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ProxFor ºAutor:                           ºData ³ 01/04/03 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ProxFor()
Local NewFor, strCodFor, CodFor
Local aintTabASCII, i, intASC, intTab, bolVaiUm, strNovaString
Local cAliaAnte,nAreaAnte,nRegiAnte

If M->A2_TIPO <> "X" .AND. SUBSTR(M->A2_CGC,1,8) <> "00000000" 
	cAliaAnte := Alias()
	nAreaAnte := IndexOrd()
	nRegiAnte := RecNo()
	
	NewFor := Trim(SUBSTR(M->A2_CGC,1,8))
	strCodLoja := "01"
	dbSelectArea("SA2")                
	dbSetOrder(3)
	
	If dbSeek(xFilial("SA2")+NewFor,.t.)
	
		CodFor := SA2->A2_COD  
		
	ELSE
	
		CodFor := GETSXENUM("SA2") 
	Endif                      
	        
	dbSelectArea(cAliaAnte)
	dbSetOrder(nAreaAnte)
	dbGoTo(nRegiAnte)
ELSE
CodFor := GETSXENUM("SA2")
ENDIF
Return(CodFor)
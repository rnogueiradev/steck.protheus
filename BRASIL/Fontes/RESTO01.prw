#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Programa  ≥ RESTO01  ∫Autor  ≥Ricardo Posman   ∫ Data ≥ JANEIRO/2008   ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Descricao ≥ Criacao do codigo de produto sequencial dentro de cada     ∫±±
±±∫          ≥ grupo de produtos.                                         ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Uso       ≥ Cadastro de Produtos                                       ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Propriet. ≥ Steck                                                     ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

USER FUNCTION RESTO01() 
Local aArea:=GetArea()
Private oDlg1
Private lOk		:=.f.
Private cOrigem	:=Space(2)    // passa a numero
Private cRevisao:=Space(2)
Private cFamilia:=Space(4)    // 
Private cSeq	:=Space(5)
Private cCod	:=Space(13)

if __cinternet == "AUTOMATICO"

//cCod	:= "             " 
Return If(!lOk,Space(13),cFamilia+cSeq+cOrigem+cRevisao)
Else


/*
@ 060,100 To 300,500 DIALOG TelaCodigo TITLE OemToAnsi("ComposiÁ„o do CÛdigo do Produto")
@ 015,005 Say OemToAnsi("Revisao:") 
@ 015,050 Get cRevisao Picture "@!"
@ 025,005 Say OemToAnsi("Origem:") 
@ 025,050 Get cOrigem Picture "@!"
@ 035,005 Say OemToAnsi("Grupo:") 
@ 035,050 Get cFamilia Picture "!!!!" ;
           Valid(ExistCpo("SBM",cFamilia,1)).and.U_OKCOD(cFamilia, @cSeq); 
           F3("SBM") 
@ 050,005 Say OemToAnsi("PrÛximo CÛdigo: ")
@ 103,010 BmpButton Type 1 Action (lOk := .T., Close(TelaCodigo))
@ 103,050 BmpButton Type 2 Action (lOk := .F., (TelaCodigo:End()))
ACTIVATE DIALOG TelaCodigo CENTERED     
*/
RestArea(aArea)
eNDIF
Return If(!lOk,Space(13),cFamilia+cSeq+cOrigem+cRevisao)

//************************************** 
//cQuery += "AND SUBSTRING(B1_COD,2,3)= '"+SUBSTR(cFamilia,2,3)+"'"+CHR(13)

User Function OKCOD(cFamilia, cSeq)
Local aArea:=GetArea()  
Local cItem :=" "

cQuery := " SELECT MAX(substr(B1_COD,5,05)) +1 ITEM FROM " +RetSqlName("SB1")+ " 
cQuery += " WHERE B1_FILIAL = '"+xFilial("SB1")+"'"
cQuery += " AND SUBSTR(B1_COD,1,4)= '"+cFamilia+"'"
cQuery += " AND SUBSTR(B1_COD,10,2)= '"+cOrigem+"'"
cQuery += " AND D_E_L_E_T_ <> '*'"            
MEMOWRITE("sb1.SQL",cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP8", .F., .T.)

dbSelectArea("TMP8")
If TMP8->(Eof())
	cItem := '00001' 
	lOk		:=.t.
Else
	cItem := StrZero(TMP8->ITEM,5)  
	lOk		:=.t.
EndIf        

	if cItem = "00000"  
	   cItem = "00001"
	endif   	
cSeq:=cItem    
cCod:=cFamilia+cSeq+cOrigem+cRevisao  

TMP8->(dbCloseArea())


RestArea(aArea)
@ 050,050 Say OemToAnsi(cFamilia+cSeq+cOrigem+cRevisao)   
Return lOk	
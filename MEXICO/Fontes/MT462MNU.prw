#include "rwmake.ch"
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪勘�
北矲uncion   � MT462MNU � Autor � Alejandro     � Fecha � 23/01/2007 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪幢�
北矰escripcion punto de entrada para impresion                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Varios                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function MT462MNU()
Private cArea        := alias()

//If !"MATA467N" $ AllTrim(Funname()) //No poner la Opcion cuando es Fact de Salida
	aadd(aRotina,{'IMPRESION','U_IMPRVARIOS()' , 0 , 4,0,NIL})
//EndIf                                  

Return

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪勘�
北矲uncion   � IMPRFET  � Autor � Claudia Gusmao     � Fecha � 23/01/2007 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪幢�
北矰escripcion Rutina para elegir impresion transferencia entrada / salida潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � Stock  -                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function IMPRVARIOS()

Local cPerg     := ""
Local aConteudo := {}
If "MATA462N" $ AllTrim(Funname()) //Remision de Venta
	cPerg     := "EFAT005R  "
	aConteudo := {}
	aAdd(aConteudo	,{SF2->F2_DOC,SF2->F2_DOC	; //15
	,""			,""			; //13
	,""			,""			; //13
	,"",""})
		
	dbSelectArea("SX1")
	dbSetOrder(1)
	dbSeek(cPerg)
	While !SX1->(Eof()) .And. SX1->X1_GRUPO == cPerg
		RecLock("SX1",.F.)		
		If ValType(aConteudo[1,Val(SX1->X1_ORDEM)]) == "N"
			SX1->X1_PRESEL:= aConteudo[1,Val(SX1->X1_ORDEM)]
		ELse
			SX1->X1_CNT01 := aConteudo[1,Val(SX1->X1_ORDEM)]
		EndIf		
		MsUnlock()		
		SX1->(DbSkip())
	EndDo

	U_EFAT005R()	
ElseIf "MATA462DN" $ AllTrim(Funname())
		MsgStop("Reporte en desarrollo - MT462MNU (REMISION DEVOLUCION)")	
ElseIf "MATA465N" $ AllTrim(Funname())
	cPerg     := "EFAT002R  "
	aConteudo := {}
	
	aAdd(aConteudo	,{DTOC(SF1->F1_EMISSAO),DTOC(SF1->F1_EMISSAO)	; //15
	,SF1->F1_SERIE			,SF1->F1_SERIE			; //13
	,SF1->F1_DOC			,SF1->F1_DOC			; //13
	,2,2})
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	dbSeek(cPerg)
	While !SX1->(Eof()) .And. SX1->X1_GRUPO == cPerg
		RecLock("SX1",.F.)		
		If ValType(aConteudo[1,Val(SX1->X1_ORDEM)]) == "N"
			SX1->X1_PRESEL:= aConteudo[1,Val(SX1->X1_ORDEM)]
		ELse
			SX1->X1_CNT01 := aConteudo[1,Val(SX1->X1_ORDEM)]
		EndIf		
		MsUnlock()		
		SX1->(DbSkip())
	EndDo
	U_EFAT002B()	

ElseIf "MATA467N" $ AllTrim(Funname())
	cPerg     := "EFAT002R  "
	aConteudo := {}
	
	aAdd(aConteudo	,{DTOC(SF2->F2_EMISSAO),DTOC(SF2->F2_EMISSAO)	; //15
	,SF2->F2_SERIE			,SF2->F2_SERIE			; //13
	,SF2->F2_DOC			,SF2->F2_DOC			; //13
	,1,1})
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	dbSeek(cPerg)
	While !SX1->(Eof()) .And. SX1->X1_GRUPO == cPerg
		RecLock("SX1",.F.)		
		If ValType(aConteudo[1,Val(SX1->X1_ORDEM)]) == "N"
			SX1->X1_PRESEL:= aConteudo[1,Val(SX1->X1_ORDEM)]
		ELse
			SX1->X1_CNT01 := aConteudo[1,Val(SX1->X1_ORDEM)]
		EndIf		
		MsUnlock()		
		SX1->(DbSkip())
	EndDo
	U_EFAT002B()

ElseIf "MATA462R" $ AllTrim(Funname())
		MsgStop("Reporte en desarrollo - MT462MNU (DEVOLUCION SIMBOLICA)")		
ElseIf "MATA102N" $ AllTrim(Funname())	
	cPerg     := "EFAT005E  "
	aConteudo := {}
	
	aAdd(aConteudo	,{SF1->F1_DOC,SF1->F1_DOC	; //15
	,""			,""			; //13
	,""			,""			; //13
	,"",""})
		
	dbSelectArea("SX1")
	dbSetOrder(1)
	dbSeek(cPerg)
	While !SX1->(Eof()) .And. SX1->X1_GRUPO == cPerg
		RecLock("SX1",.F.)		
		If ValType(aConteudo[1,Val(SX1->X1_ORDEM)]) == "N"
			SX1->X1_PRESEL:= aConteudo[1,Val(SX1->X1_ORDEM)]
		ELse
			SX1->X1_CNT01 := aConteudo[1,Val(SX1->X1_ORDEM)]
		EndIf		
		MsUnlock()		
		SX1->(DbSkip())
	EndDo
U_EFAT005E()
EndIf
Return

#Include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STFSRE20  ºAutor  ³Microsiga           º Data ³  02/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao de identificação de produto (cartao              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteração ³ Giovani Zago                          º Data ³  06/12/12   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function STFSRE20()  // chamada com as 4 opcoes
	U_XACDI011()
Return

User Function STFSRE21()  // chamada somente para Nota fiscal
	U_XACDI011()
Return

User Function STFSRE22()  // chamada somente para Produto
	U_XACDI011()
Return

User Function STFSRE23()  // chamada somente para OP
	U_XACDI011()
Return

User Function STFSRE24()  // chamada somente para Ordem de Separacao para Produção
	U_XACDI011()
Return
            


User Function STFSRE25(nCopias,nQtde,cLote,cOP,dEmissao)
	Local cQtd		:= Alltrim(str(nQtde))
	Local cCodBar	:= U_STBarra(SB1->B1_COD,cLote,nQtde)
//Local cParte1	:= MemoLine(Alltrim(SB1->B1_DESC), 38, 1)
//Local cParte2	:= MemoLine(Alltrim(SB1->B1_DESC), 38, 2)           
	Local cParte1	:= SubStr(Alltrim(SB1->B1_DESC),1,20)
	Local cParte2	:= SubStr(Alltrim(SB1->B1_DESC),21,20)
	Local nLinH	:= 0
	Local nLinV := 0
	Local _cDepto := ''
	Local _cCombo := ''
	Local _adados := {}
	Local _nI
	Local _npos

	Default dEmissao := dDatabase
	//Chamado 003005 abre
	If ! Empty(cOP)
		DbSelectArea("SC2")
		SC2->(DbGoTop())
		SC2->(DbSetOrder(1))//C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
		If DbSeek( xFilial("SC2") + cOP)
			If SC2->(FieldPos("C2_ZDEPTO")) > 0
				dbSelectArea("SX3")
				SX3->(DbGoTop())
				SX3->(dbSetOrder(2))
				If dbSeek( "C2_ZDEPTO" )
					_cCombo  := X3Cbox()
					while (_npos := at(";",_cCombo) ) > 0
						aadd( _adados,substr(_cCombo,1,_npos-1) )
						_cCombo:= substr(_cCombo,_npos+1,len(_cCombo))
					end
					aadd( _adados , _cCombo )
				EndIf
				For _nI := 1 to Len(_adados)
					If SC2->C2_ZDEPTO == SUBSTR(_adados[_nI],1,1)
						_cDepto := _adados[_nI]
						Exit
					Endif
				Next _nI
			
			Endif
		Endif
	Endif
	//Chamado 003005 fecha
	MSCBInfoEti("Cartão","")
	MSCBBEGIN(nCopias,6,60)
 	//MSCBBox(nLinH+03,nLinV+03,nLinH+100,nLinV+79,5)	//Somente para o enquadramento - Tirar ao concluir.

	//MSCBSAYBAR(nLinH+13,nLinV+10,cCodBar,"N","MB07",13,.F.,.T.,.T.,"B",2,2,.F.) //	MSCBSAYBAR(nLinH+15,nLinV+10,cCodBar,"N","MB07",13,.F.,.T.,.T.,"B",2,2,.F.)
	MSCBSAYBAR(nLinH+13,nLinV+10,cCodBar,"N","MB07",12,.F.,.t.,.F.,"C",1,1,.F.)
	//MSCBSAYBAR(nLinH+13,nLinV+10,cCodBar,"N","MB07",14,.F.,.t.,.F.,"C",2,2,.F.)
	MSCBSAY(nLinH+15,nLinV+35,Dtoc(dEmissao)		,"B","0","035,040")
	MSCBSAY(nLinH+22,nLinV+35,SB1->B1_COD	,"B","0","035,040")
	MSCBSAY(nLinH+36,nLinV+25,cParte1 		,"B","0","035,040")
	MSCBSAY(nLinH+40,nLinV+25,cParte2		,"B","0","035,040")
	MSCBSAY(nLinH+49,nLinV+35,cQtd			,"B","0","035,040")
	MSCBSAY(nLinH+57,nLinV+35,cLote			,"B","0","035,040")
	
	If ! Empty(cOP)
		MSCBSAY(nLinH+81,nLinV+28,"OP: "+cOP				,"B","0","035,040")
		If !Empty(_cDepto)
			MSCBSAY(nLinH+88,nLinV+28,_cDepto				,"B","0","035,040")
		Endif
	EndIf

		
	MSCBEND()
Return



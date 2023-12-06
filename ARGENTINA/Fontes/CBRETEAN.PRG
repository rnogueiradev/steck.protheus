#include "RWMAKE.CH"
#include "APVT100.CH"
Static __LoteX := Space(10)
Static __EmpEti:=""
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CBRETEAN ³ Autor ³ FABRICA DE SOFTWARE    	 								  ³ Data ³ 16/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ PE na validacao da leitura de etiquetas                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Tipo Array																						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cliente   ³ Especifico cliente Steck  													 			 		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CBRETEAN()
	Local cId		:= Paramixb[1]
	Local cLote		:= Space(10)
	Local cNumSer	:= Space(20)
	Local nQtde		:= 1
	Local cProduto	:= ""
	Local dValid	:= CTOD("//")
	Local aBarras	:= {}
	Local aRet		:= {}
	Local aSave
	Local aArea		:= GetArea()
	Local aAreaSB1	:= SB1->(GetArea())
	Local _aAreaCB8	:= {}
	
	If AT("==",cId)>0
		cId := StrTran(cId,"==","= =")
	EndIf
	
	__EmpEti:=""
	
	cId	:=	U_STAVALET(cId)
	
	If Empty(cId)
		Return aRet
	Endif
	
	If At("=",cID) > 0 .or. At("|",cID) > 0
		If At("=",cID) > 0
			aBarras :=StrTokArr( cId, '=' )
		ElseIf At("|",cID) > 0
			aBarras :=StrTokArr( cId, '|' )
		EndIf
		If len(aBarras) < 3
			ApMsgAlert("Codigo de barras Steck Invalido","Atencao")
			Return aRet
		EndIf
		cProduto := Padr(aBarras[1],Len(SB1->B1_COD))
		cLote		:= Padr(aBarras[2],Len(SD3->D3_LOTECTL))
		nQtde		:= Val(aBarras[3])/1
		If len(aBarras) == 4
			__EmpEti :=aBarras[4]
		EndIf
	Else
		cProduto := Padr(cId,15)
		cLote		:= Space(10)
		nQtde		:= 0
	EndIf
	
	If Empty(cProduto)
		Return aRet
	Endif
	
	SB1->(DbSetOrder(1))
	If ! SB1->(DBSeek(xFilial("SB1")+cProduto)) .And. !(AllTrim(FUNNAME())=="T_ACDV035") //Alteração em 29/06/2015 - Inventario
		
		SB1->(DbSetOrder(1))
		If ! SB1->(DBSeek(xFilial("SB1")+cProduto))
			RestArea(aAreaSB1)
			RestArea(aArea)
			aRet := {'',0,cLote,dValid,cNumSer}
			Return aRet
		Endif
	EndIf
	
	If IsTelNet()
		aSave := VTSAVE()
		VtClear()
		@ 1,0 VtSay "Informe a "
		@ 2,0 VtSay "Quantidade:"
		@ 3,0 VTGet nQtde pict PesqPict("SB2","B2_QATU")  Valid !Empty(nQtde)
		VTRead
		VtRestore(,,,,aSave)
		
		If ! Rastro(SB1->B1_COD)
			If Empty(cLote) .and. ! xRastro(@cLote,SB1->B1_COD,nQtde)
				aRet := {alltrim(SB1->B1_COD),0,cLote,dValid,cNumSer}
				RestArea(aAreaSB1)
				RestArea(aArea)
				Return aRet
			EndIf
			__LoteX:= cLote
			cLote := Space(10) //lote invalido - verificar
		Else
			__LoteX:= cLote
		EndIf
	Else
		If ! Rastro(SB1->B1_COD)
			__LoteX:= cLote
			cLote := Space(10)
		Else
			__LoteX:= cLote
		EndIf
	EndIf
	
	aRet := {SB1->B1_COD,nQtde,cLote,dValid,cNumSer}
	
	RestArea(aAreaSB1)
	RestArea(aArea)
	__PulaItem:= .T.
Return aClone(aRet)


Static Function xRastro(cLote,cProduto,_nQtde)
	Local aSave		:= VTSAVE()
	Local cOrdSepX	:= ""
	Local _nxSaldoCB8:= 0
	
	If IsInCallStack("U_STFSF70A")
		Return .T.
	Endif
	
	VTClear
	@ 0,0 VTSay ".:Especifico:."
	@ 2,0 VTSay "Informe o Lote"
	@ 3,0 VtGet cLote pict '@!'
	VTREAD
	VtRestore(,,,,aSave)
	If VTLastKey() == 27
		VTAlert("Lote especifico invalido","Aviso",.t.,3000)
		Return .f.
	EndIf
	
	If IsInCallStack('ACDV176X') .or.  (IsInCallStack('ACDV166X') .and. IsInCallStack('ESTORNA'))
		
		cOrdSepx 	:= If(!Empty(CB7->CB7_XOSPAI),CB7->CB7_XOSPAI,CB7->CB7_ORDSEP)
		DbSelectArea("CB8")
		CB8->(DbSetOrder(7))
		CB8->(DbSeek(xFilial("CB8")+cOrdSepx+cArmazem+alltrim(cEndereco)+REPLICATE(" ",15-LEN(alltrim(cEndereco)))+ALLTRIM(cProduto)+REPLICATE(" ",15-LEN(alltrim(cProduto)))))
		
		
		cOrdSepx 	:= If(!Empty(CB7->CB7_XOSPAI),CB7->CB7_XOSPAI,CB7->CB7_ORDSEP)
		
		While  ! Eof() .and. CB8->CB8_FILIAL+CB8->CB8_ORDSEP+CB8->CB8_LCALIZ+CB8->CB8_PROD == xFilial("CB8")+cOrdSepx+alltrim(cEndereco)+REPLICATE(" ",15-LEN(alltrim(cEndereco)))+ALLTRIM(cProduto)+REPLICATE(" ",15-LEN(alltrim(cProduto)))
			
			If CB8->CB8_SALDOS = 0
				_nxSaldoCB8	+=	CB8->CB8_QTDORI
			EndIf
			CB8->(DbSkip())
		EndDo
		If _nQtde <> _nxSaldoCB8
			VTAlert("Quantidade Incorreta Utilize a Quant: "+cvaltochar(_nxSaldoCB8),"Atencao",.t.,3000)
			Return .f.
		EndIf
		DbSelectArea("PA0")
		PA0->(DbGoTop())
		PA0->(DbSetOrder(4))
		DbSelectArea("CB8")
		CB8->(DbGoTop())
		CB8->(DbSetOrder(7))
		CB8->(DbSeek(xFilial("CB8")+cOrdSepx+cArmazem+alltrim(cEndereco)+REPLICATE(" ",15-LEN(alltrim(cEndereco)))+ALLTRIM(cProduto)+REPLICATE(" ",15-LEN(alltrim(cProduto)))))
		/*
		If ! PA0->(DbSeek(xFilial("PA0")+cOrdSepx+CB8->(CB8_PROD)+cLote))
			VTAlert("Lote especifico não encontrado","Atencao",.t.,3000)
			Return .f.
		EndIf
		*/
		
		
	EndIf
	
Return .t.

User Function RetLoteX()
Return __LoteX

User Function RetEmpX()
Return __EmpEti

#include "rwmake.ch"
#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SD3250I   ºAutor  ³Everaldo Gallo      º Data ³  02/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Endereca apos a producao                                   º±±
±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function SD3250I

Private _aArea	:=GetArea()

DbSelectArea("SD3")

Private _cOp 	 := SD3->D3_OP
Private _cNumSeq := SD3->D3_NUMSEQ
Private _cDoc	 := SD3->D3_DOC

_aAreaD3 := GetArea()

IF ALLTRIM(SD3->D3_FILIAL) == '04'

	DbSelectArea("SD3")
	DbSetOrder(1)      					// filial+op+cod+local
	DbSeek (Xfilial("SD3")+_cOP,.T.)
	
	Do While !Eof() .and. SD3->D3_OP ==  _cOp 													//enquanto for a mesma OP
		
		If Substr(SD3->D3_CF,1,2) == "PR"  .AND. _cNumSeq == SD3->D3_NUMSEQ
			
			If Alltrim(SD3->D3_LOCAL) == Alltrim(GetMV("MV_LOCPROC"))   
			
				SDA->(DbSetOrder(1))
				If SDA->(DbSeek(xFilial("SDA")+SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_NUMSEQ+SD3->D3_DOC))
					
					If SDA->DA_SALDO  > 0
						
						_aArSB2	:= SB2->(GetArea())
						DbSelectArea("SB2")
						DbSetOrder(1)
						MsSeek(xFilial("SB2") + SDA->DA_PRODUTO + SDA->DA_LOCAL)
						
						cLocaliz := PadR(GetMV("ST_ENDPROC"),Len(SBE->BE_LOCALIZ))
						A100Distri(SDA->DA_PRODUTO,SDA->DA_LOCAL,SDA->DA_NUMSEQ,SDA->DA_DOC,Nil,Nil,Nil,cLocaliz,Nil,SDA->DA_SALDO,SDA->DA_LOTECTL,SDA->DA_NUMLOTE)
						
						RestArea(_aArSB2)
						
					EndIf
				EndIf
			EndIf
			
		Endif
		
		DbSelectArea("SD3")
		SD3->(DbSkip())
		
	EndDo
Endif       

RestArea(_aAreaD3)
RestArea(_aArea)

Return()

#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA080VLD	ºAutor  ³Renato Nogueira     º Data ³  14/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado gerar log de alteração das TES		      º±±
±±º          ³									  	 				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Lógico										              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA080VLD()

Local aArea     	:= GetArea()
Local aAreaSF4  	:= SF4->(GetArea())
Local aCampos		:= {}
Local lRet			:= .T.
Local _cMsg			:= ""
Local _lAlterado	:= .F.

If ALTERA
	
	_cMsg	+= "Usuário: "+cUserName+CHR(13) +CHR(10)
	_cMsg	+= "Alterado em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13) +CHR(10)
	_cMsg	+= "Campo | Anterior | Novo "+CHR(13) +CHR(10)
	
	DbSelectArea("SX3")
	SX3->(DbGoTop())
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("SF4"))
	
	While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="SF4"
		
		If !(M->(&(SX3->X3_CAMPO)) == &("SF4->"+SX3->X3_CAMPO))
			
			_cMsg		+= SX3->X3_CAMPO+" | "
			
			DO CASE
				CASE AllTrim(SX3->X3_TIPO )=="C"
					_cMsg		+= &("SF4->"+SX3->X3_CAMPO)+" | "+M->(&(SX3->X3_CAMPO))+CHR(13)+CHR(10)
				CASE AllTrim(SX3->X3_TIPO )=="N"
					_cMsg		+= CVALTOCHAR(&("SF4->"+SX3->X3_CAMPO))+" | "+CVALTOCHAR(M->(&(SX3->X3_CAMPO)))+CHR(13)+CHR(10)
				CASE AllTrim(SX3->X3_TIPO )=="D"
					_cMsg		+= DTOC(&("SF4->"+SX3->X3_CAMPO))+" | "+DTOC(M->(&(SX3->X3_CAMPO)))+CHR(13)+CHR(10)
			ENDCASE
			
			_lAlterado	:= .T.
		EndIf
		
		SX3->(DbSkip())
		
	EndDo
	
EndIf

If _lAlterado
	M->F4_XLOG	:= _cMsg+CHR(13)+CHR(10)+M->F4_XLOG
EndIf

RestArea(aAreaSF4)
RestArea(aArea)

Return(lRet)
#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA080VLD	�Autor  �Renato Nogueira     � Data �  14/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado gerar log de altera��o das TES		      ���
���          �									  	 				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � L�gico										              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA080VLD()

Local aArea     	:= GetArea()
Local aAreaSF4  	:= SF4->(GetArea())
Local aCampos		:= {}
Local lRet			:= .T.
Local _cMsg			:= ""
Local _lAlterado	:= .F.

If ALTERA
	
	_cMsg	+= "Usu�rio: "+cUserName+CHR(13) +CHR(10)
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
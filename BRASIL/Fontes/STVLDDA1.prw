#Include "Protheus.ch"
#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STVLDDA1  �Autor  �Renato Nogueira     � Data �  28/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o utilizada para validar a altera��o do pre�o de      ���
���          � venda			                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STVLDDA1()

Local aArea     	:= GetArea()
Local aAreaDA1  	:= DA1->(GetArea())
Local _lRet			:= .F.
Local cST_GRPSUPV	:= SuperGetMV("ST_GRPSUPV",,"")  	//Supervisores de venda
Local cST_GRPMKT 	:= SuperGetMV("ST_GRPMKT",,"")	//Usu�rios marketing
Local _cGrupo		:= ""
Local _cProd        := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "DA1_CODPRO"})
Local _cControl  	:= SuperGetMV("ST_TRANSPR",,"000000")
DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+	aCols[n,_cProd])

If SB1->(!Eof())
	_cGrupo	:= SB1->B1_GRUPO
EndIf

PswOrder(1)
If PswSeek(__cUserId,.T.)
	_aGrupos	:= PswRet()
EndIf

_nPosVen := ASCAN(_aGrupos, { |x| Alltrim(x) $ cST_GRPSUPV })
_nPosMkt := ASCAN(_aGrupos, { |x| Alltrim(x) $ cST_GRPMKT })
If __cuserId $ _cControl
	_lRet	:= .T.
Else
	DO CASE
		
		CASE _aGrupos[1][10][1] $ cST_GRPMKT //Usu�rios do marketing podem alterar qualquer pre�o
			
			_lRet	:= .T.
			
		CASE _aGrupos[1][10][1] $ cST_GRPSUPV .And. AllTrim(_cGrupo) $ "040#041#042#999"
			
			_lRet	:= .T.
			
		OTHERWISE
			
			MsgAlert("Aten��o, seu usu�rio n�o possui permiss�o para alterar pre�o, contate o Administrador")
			
	ENDCASE
	
EndIf
RestArea(aAreaDA1)
RestArea(aArea)

Return(_lRet)

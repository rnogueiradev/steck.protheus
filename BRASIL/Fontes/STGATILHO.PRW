/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Programa  �STGatilho �Autor  �Donizeti Lopes      � Data �  25/01/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Executa valida��o do dicionario e gatilhos de campos mani- ���
���          � pulados pelo fonte.                                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STGatilho(_cVar,_uConteudo,_nLin)
Local _lRet     	:= .T.
Local _aArea      	:= GetArea()
Local _cVarOld 		:= ReadVar()
Local _uContOld
            
//-- Acerta o nome da vari�vel de mem�ria
If "M->" $ _cVar
                __ReadVar := _cVar
Else
                __ReadVar := "M->"+_cVar
EndIf

//-- Salva o conteudo anterior da vari�vel de mem�ria
If Type(__ReadVar) != "U"
                _uContOld := &(__ReadVar)
EndIf

//-- Atribui o conte�do � vari�vel de mem�ria
&(__ReadVar) := _uConteudo

//-- Executa valida��o do dicion�rio
If (_lRet := CheckSX3(_cVar, _uConteudo ) )
                //-- Executa gatilho
                If ExistTrigger( _cVar )
                               RunTrigger(2,_nLin,,/**/,_cVar ) 
                EndIf
EndIf

//-- Restaura area
RestArea(_aArea)

//-- Em caso de falha, retorna o conte�do da vari�vel de mem�ria
If !_lRet .And. _uContOld != Nil
                &(__ReadVar) := _uContOld
EndIf

//-- Retorna o "ponteiro" de leitura/valida��o.
__ReadVar := _cVarOld
                
Return _lRet

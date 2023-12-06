/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³STGatilho ºAutor  ³Donizeti Lopes      º Data ³  25/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa validação do dicionario e gatilhos de campos mani- º±±
±±º          ³ pulados pelo fonte.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STGatilho(_cVar,_uConteudo,_nLin)
Local _lRet     	:= .T.
Local _aArea      	:= GetArea()
Local _cVarOld 		:= ReadVar()
Local _uContOld
            
//-- Acerta o nome da variável de memória
If "M->" $ _cVar
                __ReadVar := _cVar
Else
                __ReadVar := "M->"+_cVar
EndIf

//-- Salva o conteudo anterior da variável de memória
If Type(__ReadVar) != "U"
                _uContOld := &(__ReadVar)
EndIf

//-- Atribui o conteúdo à variável de memória
&(__ReadVar) := _uConteudo

//-- Executa validação do dicionário
If (_lRet := CheckSX3(_cVar, _uConteudo ) )
                //-- Executa gatilho
                If ExistTrigger( _cVar )
                               RunTrigger(2,_nLin,,/**/,_cVar ) 
                EndIf
EndIf

//-- Restaura area
RestArea(_aArea)

//-- Em caso de falha, retorna o conteúdo da variável de memória
If !_lRet .And. _uContOld != Nil
                &(__ReadVar) := _uContOld
EndIf

//-- Retorna o "ponteiro" de leitura/validação.
__ReadVar := _cVarOld
                
Return _lRet

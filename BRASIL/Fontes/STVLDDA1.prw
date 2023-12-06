#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STVLDDA1  ºAutor  ³Renato Nogueira     º Data ³  28/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função utilizada para validar a alteração do preço de      º±±
±±º          ³ venda			                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STVLDDA1()

Local aArea     	:= GetArea()
Local aAreaDA1  	:= DA1->(GetArea())
Local _lRet			:= .F.
Local cST_GRPSUPV	:= SuperGetMV("ST_GRPSUPV",,"")  	//Supervisores de venda
Local cST_GRPMKT 	:= SuperGetMV("ST_GRPMKT",,"")	//Usuários marketing
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
		
		CASE _aGrupos[1][10][1] $ cST_GRPMKT //Usuários do marketing podem alterar qualquer preço
			
			_lRet	:= .T.
			
		CASE _aGrupos[1][10][1] $ cST_GRPSUPV .And. AllTrim(_cGrupo) $ "040#041#042#999"
			
			_lRet	:= .T.
			
		OTHERWISE
			
			MsgAlert("Atenção, seu usuário não possui permissão para alterar preço, contate o Administrador")
			
	ENDCASE
	
EndIf
RestArea(aAreaDA1)
RestArea(aArea)

Return(_lRet)

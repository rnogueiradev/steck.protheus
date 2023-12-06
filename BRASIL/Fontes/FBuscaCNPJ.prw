#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FBuscaCNPJ ºAutor:                        ºData ³ 01/04/03 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION FBuscaCNPJ ()
Private nRetorno, aArea, cCodFor
nRetorno := .t.

aArea:=GetArea()

If !ISINCALLSTACK("U_STINCSA2")           

cCodFor := M->A2_COD

If M->A2_TIPO <> "X" .AND. SUBSTR(M->A2_CGC,1,8) <> "00000000"
	dbSelectArea("SA2")             
	dbSetOrder(3) 
	dbSeek(xFilial("SA2")+SUBSTR(M->A2_CGC,1,8))
	If Found() .and. cCodFor <> SA2->A2_COD  
		//FR - 27/10/2022 - QUANDO A CHAMADA VIER DO JOB U_STBPO001
		If !IsBlind()
			IF MSGYESNO("O Fornecedor "+Alltrim(SA2->A2_NOME)+", CNPJ "+SUBSTR(M->A2_CGC,1,8)+" ja se encontra cadastrado com o codigo "+SA2->A2_COD+" Caso voce esteja cadastrando uma nova loja para o Fornecedor continue com a operacao")
					M->A2_COD := SA2->A2_COD
					nRetorno := .T.	
		
			ENDIF
		Else 
			M->A2_COD := SA2->A2_COD
			nRetorno := .T.	
		Endif 
		//FR - 27/10/2022 - Flávia Rocha - Sigamat Consultoria	
	Endif
ENDIF	

EndIf 

restarea(aArea)   

RETURN(nRetorno)

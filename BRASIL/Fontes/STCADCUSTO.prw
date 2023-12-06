#include 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³STCADCUSTO   ºAutor  ³Renato Nogueira  º Data ³  17/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina criada para carregar os custos dos produtos na SB2   º±±
±±º          ³		                             					      º±±
±±º          ³    									  				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

User Function STCADCUSTO()

Local cGetCod :=  space(15)
Local nGetCus :=  0

Do While .t.
	
	Define msDialog oDlg Title "Cadastro de custo por produto - SB2" From 10,10 TO 25,50
	
	@ 001,001 say "Produto: "
  	@ 023,007 msget cGetCod size 50,12 valid (existcpo("SB1",cGetCod)) Picture "@!" F3 "SB1" Pixel Of oDlg
	@ 003,001 say "Custo: "
	@ 048,007 msget nGetCus valid !empty(nGetCus) size 50,12 Picture PesqPict("SB2","B2_CMFIM1",14,4) Pixel Of oDlg
	
	DEFINE SBUTTON FROM 75,15 TYPE 1 ACTION IF( !empty(cGetCod) .Or. !empty(nGetCus),(nOpcao:=1,oDlg:End()),msgInfo("Parametro em Branco","Atenção")) ENABLE OF oDlg
	DEFINE SBUTTON FROM 75,55 TYPE 2 ACTION (nOpcao:=0,oDlg:End()) ENABLE OF oDlg
	
	Activate dialog oDlg centered
	
	If nOpcao = 1
		
		Processa({|| ALTCUSTO(cGetCod,nGetCus) }, "Cadastrando custo na tabela SB2. Aguarde! ...")
		
		Exit
		
	Else
		Exit
	Endif
Enddo

	If nOpcao = 1
		U_STCADCUSTO()
	EndIf
	
return()

Static Function ALTCUSTO(cGetCod,nGetCus)

DbSelectArea("SB2")
DbSetOrder(1) ////B2_FILIAL+B2_COD+B2_LOCAL
DbSeek(xFilial("SB2")+cGetCod)

If SB2->(Eof())
MsgAlert("Produto não encontrado na tabela SB2")
Return
EndIf

While !SB2->(Eof()) .And. SB2->B2_COD == cGetCod

RecLock("SB2",.F.)
SB2->B2_CMFIM1 := nGetCus
MsUnLock()

SB2->(DbSkip())

EndDo

MsgAlert("Custo do produto: "+AllTrim(cGetCod)+" atualizado com sucesso!")  

Return()
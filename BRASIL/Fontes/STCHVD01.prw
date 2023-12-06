#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA103MNU ºAutor  ³Vitor Merguizo      º Data ³  24/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para alterar a chacve NF-e nas tabelas SFT (FT_CHVNFE)º±±
±±º          ³e SF1 (F1_CHVNFE)                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STCHVD01()

Local 	aArea 		:= GetArea()
Local 	nOpca 		:= 0
Private oDlg
Private cChave 		:= SF1->F1_CHVNFE
Private cFormul 	:= "N"
Private cEspecie	:= "SPED"

If Alltrim(SF1->F1_ESPECIE) $ "CTE|SPED"

	cEspecie	:= Alltrim(SF1->F1_ESPECIE) 
	
	If Empty(cChave) .Or. MsgYesNo("Esta Nota Fiscal possui a Chave: "+SF1->F1_CHVNFE+". Deseja alterá-la?","Chave NF-e")

		DEFINE MSDIALOG oDlg TITLE "Alteração de Chave NF-e" FROM 000,000 TO 100,300 PIXEL

		 	@ 02,04 SAY "Chave:" PIXEL OF oDlg
			@ 12,04 MSGet cChave picture "@!"   Size 140,13 PIXEL OF oDlg Valid (!Empty(cChave) .And. A103ConsNfeSef())  //Renato Nogueira - Inserida validação para consultar chave na Sefaz
			@ 32,04 Button "Gravar" Size 28,13 Action IIF(!Empty(cChave),Eval({||lSaida:=.T.,nOpca:=1,oDlg:End()}),msginfo("Chave deve ser informada!")) Pixel

		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpca = 1 .And. !Empty(cChave)
			DbSelectArea("SF1")
			RecLock("SF1", .F.)
			SF1->F1_CHVNFE := cChave
			SF1->(MsUnLock())
			
			DbSelectArea("SFT")
			SFT->(DbSetOrder(1))
			If SFT->(DbSeek( SF1->F1_FILIAL+"E"+SF1->(F1_SERIE+F1_DOC+F1_FORNECE+F1_LOJA) ))
				While SFT->(!Eof()) .And. SFT->(FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA) == SF1->F1_FILIAL+"E"+SF1->(F1_SERIE+F1_DOC+F1_FORNECE+F1_LOJA)
					RecLock("SFT", .F.)
					SFT->FT_CHVNFE := cChave
					SFT->(MsUnLock())					
					SFT->(DbSkip())
				End
			EndIf
			
			DbSelectArea("SF3")
			SF3->(DbSetOrder(5))
			If SF3->(DbSeek( SF1->(F1_FILIAL+F1_SERIE+F1_DOC+F1_FORNECE+F1_LOJA) ))
				While SF3->(!Eof()) .And. SF3->(F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIEFOR+F3_LOJA) == SF1->(F1_FILIAL+F1_SERIE+F1_DOC+F1_FORNECE+F1_LOJA)
					RecLock("SF3", .F.)
					SF3->F3_CHVNFE := cChave
					SF3->(MsUnLock())					
					SF3->(DbSkip())
				End
			EndIf
			
		EndIf
	EndIf
Else
	MsgAlert("Apenas Notas Fiscais e Conhecimentos Eletronicos, possuem chave!")
EndIf

RestArea(aArea)

MsgAlert("Processo Finalizado!")

Return
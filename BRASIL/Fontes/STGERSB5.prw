#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STGERSB5	ºAutor  ³Renato Nogueira     º Data ³  18/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado para criar registro na tabela SB5 		  º±±
±±º          ³referente as informações da desoneração da folha		      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum										              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STGERSB5()

	Local aArea     := GetArea()
	Local aAreaSB1  := SB1->(GetArea())

	DbSelectArea("SB5")
	SB5->(DbGoTop())
	SB5->(DbSetOrder(1)) //B5_FILIAL+B5_COD
	SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD))

	If SB5->(!Eof())

		SB5->(RecLock("SB5",.F.))

		DO CASE
			CASE AllTrim(SB1->B1_CLAPROD)=="F"
			SB5->B5_INSPAT	:= "1"
			SB5->B5_CODATIV	:= "99999999"
			CASE AllTrim(SB1->B1_CLAPROD) $ "C#I"
			SB5->B5_INSPAT	:= "2"
			SB5->B5_CODATIV	:= "99999999"
		ENDCASE

		If SB1->B1_TIPO=="PA"
			SB5->B5_2CODBAR := SB1->B1_CODBAR
		EndIf

		SB5->(MsUnLock())

	Else

		SB5->(RecLock("SB5",.T.))
		SB5->B5_COD		:= SB1->B1_COD
		SB5->B5_CEME	:= SB1->B1_DESC

		DO CASE
			CASE AllTrim(SB1->B1_CLAPROD)=="F"
			SB5->B5_INSPAT	:= "1"
			SB5->B5_CODATIV	:= "99999999"
			CASE "C#I" $ AllTrim(SB1->B1_CLAPROD)
			SB5->B5_INSPAT	:= "2"
			SB5->B5_CODATIV	:= "99999999"
		ENDCASE

		If SB1->B1_TIPO=="PA"
			SB5->B5_2CODBAR := SB1->B1_CODBAR
		EndIf

		SB5->(MsUnLock())

	EndIf

	//Chamado 007613
	If AllTrim(SB1->B1_GRUPO) $ "039#040#041#042" .And. SB1->B1_TIPO=="PA" .And. SB1->B1_CLAPROD=="F"
		SB5->(RecLock("SB5",.F.))
		SB5->B5_EAN13 := "1"
		SB5->(MsUnLock())
	EndIf

	RestArea(aAreaSB1)
	RestArea(aArea)

Return
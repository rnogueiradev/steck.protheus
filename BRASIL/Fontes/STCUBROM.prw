#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STCUBROM      ³Autor  ³ Renato Nogueira  ³ Data ³18.02.2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Função utilizada para retornar informações de cubagem do     ³±±
±±³          ³romaneio                                                     ³±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STCUBROM()

	Local aArea     := GetArea()
	Local aAreaPD1  := PD1->(GetArea())
	Local aAreaPD2  := PD2->(GetArea())
	Local _nVal		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"
 
	If IsInCallStack("U_STROMA00") 
		If xInclui
			Return (0)
		Endif
	Endif

	/*
	cQuery	:= " SELECT DISTINCT C9_FILIAL, C9_ORDSEP, C9_NFISCAL "
	cQuery  += " FROM " +RetSqlName("SC9")+ " C9 "
	cQuery  += " WHERE C9.D_E_L_E_T_=' ' AND C9_FILIAL||C9_NFISCAL IN ( "
	cQuery  += " SELECT DISTINCT PD2_FILIAL||PD2_NFS "
	cQuery  += " FROM " +RetSqlName("PD2")+ " PD2 "
	cQuery  += " WHERE PD2.D_E_L_E_T_=' ' AND PD2_CODROM='"+PD1->PD1_CODROM+"' AND PD2_FILIAL='"+PD1->PD1_FILIAL+"') "
	*/
	cQuery  := " SELECT DISTINCT C9_FILIAL, C9_ORDSEP, C9_NFISCAL  FROM " +RetSqlName('SC9')+ " C9
	cQuery  += " inner join( SELECT DISTINCT *  FROM " +RetSqlName('PD2')+ " )PD2  on PD2.D_E_L_E_T_=' ' AND PD2_CODROM='"+PD1->PD1_CODROM+"' AND PD2_FILIAL='"+PD1->PD1_FILIAL+"'  and PD2_FILIAL = C9_FILIAL  and PD2_NFS = C9_NFISCAL WHERE C9.D_E_L_E_T_=' '








	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())

		CB6->(DbOrderNickName("STFSCB601"))    //CB6_FILIAL+CB6_XORDSE+CB6_VOLUME
		If	CB6->(DbSeek(xFilial('CB6')+(cAlias)->C9_ORDSEP))

			While CB6->(!Eof() .and. CB6_FILIAL+CB6_XORDSE == xFilial('CB6')+(cAlias)->C9_ORDSEP)

				_nVal	+= Posicione("CB3",1,XFILIAL("CB3")+CB6->CB6_TIPVOL,"CB3_VOLUME") //Renato Nogueira - Chamado 000214

				CB6->(DbSkip())

			EndDo
		Endif
		(cAlias)->(DbSkip())

	EndDo

	RestArea(aAreaPD1)
	RestArea(aAreaPD2)
	RestArea(aArea)

Return(_nVal)

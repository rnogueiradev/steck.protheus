#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STEXPPED	ºAutor  ³Renato Nogueira     º Data ³  23/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa utilizado para exportar pedidos de manaus          º±±
±±º          ³para arquivo txt										      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum										              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STEXPPED()

Local _aRet 		:= {}
Local _aParamBox 	:= {}
Local cQuery 		:= ""
Local cAlias 		:= "QRYTEMP"
Local cArq			:= ""
Local cDir	  		:= GetSrvProfString("startpath","")+"pedidosam\"

If AllTrim(cEmpAnt)=="03"
	
	AADD(_aParamBox,{1,"Data maior ou igual a:",DDATABASE,"99/99/9999","","","",50,.F.})
	
	If ParamBox(_aParamBox,"Exportar tabela de pedidos - SC7 - AM",@_aRet,,,.T.,,500)
		
		cQuery := " SELECT C7_ITEM, C7_PRODUTO, C7_QUANT, C7_PRECO, C7_DATPRF, C7_FORNECE, C7_LOJA, C7_EMISSAO, C7_NUM, C7_QUJE, 'ROTAUTO' "
		cQuery += " FROM SC7030 C7 "
		cQuery += " WHERE C7.D_E_L_E_T_=' ' AND C7_EMISSAO>='"+DTOS(_aRet[1])+"' "
		
		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		
		dbSelectArea(cAlias)
		
		(cAlias)->(dbGoTop())
		
		While (cAlias)->(!Eof())
			
			cArq	+= AllTrim((cAlias)->C7_ITEM)+"|"+;
					   AllTrim((cAlias)->C7_PRODUTO)+"|"+;
					   AllTrim(CVALTOCHAR((cAlias)->C7_QUANT))+"|"+;
					   AllTrim(StrTran(CVALTOCHAR((cAlias)->C7_PRECO),".",","))+"|"+;
					   AllTrim(DTOC(STOD((cAlias)->C7_DATPRF)))+"|"+;
					   AllTrim((cAlias)->C7_FORNECE)+"|"+;
					   AllTrim((cAlias)->C7_LOJA)+"|"+;
					   AllTrim(DTOC(STOD((cAlias)->C7_EMISSAO)))+"|"+;					   
					   AllTrim((cAlias)->C7_NUM)+"|"+;
					   AllTrim(CVALTOCHAR((cAlias)->C7_QUJE))+"|"+;
					   "ROTAUTO"+CHR(13)+CHR(10)
			
			(cAlias)->(DbSkip())
		EndDo
		
		nHdlXml   := FCreate(cDir+StrTran(DTOC(DDATABASE),"/","")+".TXT",0)
		If nHdlXml > 0
			FWrite(nHdlXml,cArq)
			FClose(nHdlXml)
		Endif
		
		MsgInfo("Arquivo gerado com sucesso!")
		
	EndIf
	
Else
	
	MsgAlert("Atenção, essa rotina só pode ser utilizada na empresa 03 - Manaus")
	
EndIf

Return()
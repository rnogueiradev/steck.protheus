#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

#DEFINE _OPC_cGETFILE ( GETF_RETDIRECTORY + GETF_ONLYSERVER + GETF_LOCALHARD + GETF_LOCALFLOPPY )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STEXPSC7	ºAutor  ³Renato Nogueira     º Data ³  23/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa utilizado para exportar pedidos de são paulo       º±±
±±º          ³para arquivo txt										      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum										              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STEXPSC7()

Local _aRet 		:= {}
Local _aParamBox 	:= {}
Local cQuery 		:= ""
Local cAlias 		:= "QRYTEMP"
Local cArq			:= ""
Local cDir	  		:= cGetFile( "Selecione o Diretorio | " , OemToAnsi( "Selecione Diretorio" ) , NIL , "" , .F. , _OPC_cGETFILE )

If AllTrim(cEmpAnt)=="01" .And. AllTrim(cFilAnt)=="02"
	
	AADD(_aParamBox,{1,"Data maior ou igual a:",DDATABASE,"99/99/9999","","","",50,.F.})
	AADD(_aParamBox,{1,"Data menor ou igual a:",DDATABASE,"99/99/9999","","","",50,.F.})
	AADD(_aParamBox,{1,"Pedido de:"			   ,Space(6) ,""		  ,"","","",0 ,.F.})
	AADD(_aParamBox,{1,"Pedido ate:"		   ,Space(6) ,""		  ,"","","",0 ,.F.})
	
	If ParamBox(_aParamBox,"Exportar tabela de pedidos - SC7 - SP",@_aRet,,,.T.,,500)
		
		cQuery := " SELECT C7_FILIAL, C7_ITEM, C7_PRODUTO, C7_QUANT, C7_PRECO, C7_DATPRF, C7_FORNECE, C7_LOJA, C7_EMISSAO, C7_NUM, C7_QUJE, C7_MOTIVO, C7_XMESMRP, C7_XANOMRP, 'ROTAUTO' "
		cQuery += " FROM "+RetSqlName("SC7")+" C7 "
		cQuery += " WHERE C7.D_E_L_E_T_=' ' AND C7_EMISSAO BETWEEN '"+DTOS(_aRet[1])+"' AND '"+DTOS(_aRet[2])+"' AND C7_FORNECE='005866' AND C7_LOJA='01' AND C7_FILIAL='"+xFilial("SC7")+"' "
		cQuery += " AND C7_NUM BETWEEN '"+_aRet[3]+"' AND '"+_aRet[4]+"' "
		
		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		
		dbSelectArea(cAlias)
		
		(cAlias)->(dbGoTop())
		
		While (cAlias)->(!Eof())
			
			cArq	+= AllTrim((cAlias)->C7_FILIAL)+"|"+;
			           AllTrim((cAlias)->C7_NUM)+"|"+;
					   AllTrim((cAlias)->C7_ITEM)+"|"+;	
					   AllTrim((cAlias)->C7_PRODUTO)+"|"+;
					   AllTrim(CVALTOCHAR((cAlias)->C7_QUANT))+"|"+;
					   AllTrim(DTOC(STOD((cAlias)->C7_DATPRF)))+"|"+;
					   AllTrim((cAlias)->C7_MOTIVO)+"|"+;
					   AllTrim(DTOC(STOD((cAlias)->C7_EMISSAO)))+"|"+;	
					   AllTrim((cAlias)->C7_XMESMRP)+"|"+;
					   AllTrim((cAlias)->C7_XANOMRP)+"|"+;
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
	
	MsgAlert("Atenção, essa rotina só pode ser utilizada na empresa 01 filial 02")
	
EndIf

Return()
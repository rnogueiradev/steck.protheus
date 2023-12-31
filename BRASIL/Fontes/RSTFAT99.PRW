#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  RSTFAT99     �Autor  �Renato Nogueira � Data �  14/10/15     ���
�������������������������������������������������������������������������͹��
���Desc.     � Relat�rio de observa��es do cliente	             	       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
User Function RSTFAT99()
*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFAT99"
	Private cTime        	:= Time()
	Private cHora        	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader   	:= .f.
	Private lXmlEndRow   	:= .f.
	Private cPergTit		:= cAliasLif

	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	SA3->(DbGoTop())
	If SA3->(DbSeek(xFilial("SA3")+__cUserId))
		If !SubStr(SA3->A3_COD,1,1) $ "S#G" //Acesso somente para supervisores e gerentes
			MsgAlert("Aten��o, rotina dispon�vel somente para supervisores e gerentes, verifique!")
			Return
		EndIf
	EndIf

	PutSx1(cPerg, "01", "Cliente de:"		,"Cliente de:"			,"Cliente de:"				,"mv_ch1","C"   ,06      ,0       ,0      , "G",""    ,"SA1" 	 ,""         ,""   ,"mv_par01",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg, "02", "Cliente ate:"		,"Cliente ate:"			,"Cliente ate:"				,"mv_ch2","C"   ,06      ,0       ,0      , "G",""    ,"SA1" 	 ,""         ,""   ,"mv_par02",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ReportDef    �Autor  �Giovani Zago    � Data �  04/07/15     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio MMG 							                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELAT�RIO DE OBSERVA��ES",cPerg,{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir um relat�rio de observa��es dos clientes")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"SA1",{"SA1"})

	TRCell():New(oSection,"01"				,,"CLIENTE"					,,06,.F.,)
	TRCell():New(oSection,"02"				,,"LOJA"					,,02,.F.,)
	TRCell():New(oSection,"03"				,,"NOME"					,,40,.F.,)
	TRCell():New(oSection,"04"				,,"SUPERVISOR"				,,25,.F.,)
	TRCell():New(oSection,"05"				,,"OBSERVA��O"				,,,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SA1")

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ReportPrint  �Autor  �Giovani Zago    � Data �  04/07/15     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio MMG 							                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local aDados[2]
	Local aDados1[99]

oSection1:Cell('01')  		:SetBlock( { || aDados1[01] } )
oSection1:Cell('02')  		:SetBlock( { || aDados1[02] } )
oSection1:Cell('03')  		:SetBlock( { || aDados1[03] } )
oSection1:Cell('04') 		:SetBlock( { || aDados1[04] } )
oSection1:Cell('05')  		:SetBlock( { || aDados1[05] } )

	oReport:SetTitle("SA1")// Titulo do relat�rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
	
		While 	(cAliasLif)->(!Eof())
		
			aDados1[01]	:=  (cAliasLif)->CLIENTE
			aDados1[02]	:=	(cAliasLif)->LOJA
			aDados1[03]	:=	(cAliasLif)->NOME
			aDados1[04]	:=	(cAliasLif)->SUPERVISOR
			aDados1[05]	:=	(cAliasLif)->OBS

			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End
	
		oSection1:PrintLine()
		aFill(aDados1,nil)
	
		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  StQuery      �Autor  �Giovani Zago    � Data �  04/07/15     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio MMG 							                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
Static Function StQuery(_ccod)
*-----------------------------*

	Local cQuery     := ' '

		cQuery := " SELECT A1_COD CLIENTE, A1_LOJA LOJA, A1_NOME NOME, "  
		cQuery += " (SELECT A3_NREDUZ FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD = "
		cQuery += " (SELECT A3_SUPER FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_=' ' AND A3_COD = A1.A1_VEND)) SUPERVISOR, "
		cQuery += " utl_raw.cast_to_varchar2(dbms_lob.substr(A1_XMSG2, 2000, 1)) OBS "
		cQuery += " FROM "+RetSqlName("SA1")+" A1 "
		cQuery += " WHERE A1.D_E_L_E_T_=' ' AND A1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQuery += " AND utl_raw.cast_to_varchar2(dbms_lob.substr(A1_XMSG2, 2000, 1))<>'                       ' "

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
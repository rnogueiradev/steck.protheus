#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RSTFAT68  �Autor  �Renato Nogueira     � Data �  27/02/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relat�rio de elimina��o de res�duo		                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �  Exporta��o                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
User Function RSTFAT68()
*-----------------------------*
Local   oReport
Private cPerg 				:= "RFAT68"
Private cTime            	:= Time()
Private cHora           		:= SUBSTR(cTime, 1, 2)
Private cMinutos    			:= SUBSTR(cTime, 4, 2)
Private cSegundos   			:= SUBSTR(cTime, 7, 2)
Private cAliasLif   			:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      		:= .f.
Private lXmlEndRow      		:= .f.
Private cPergTit 				:= cAliasLif

Ajusta()

oReport		:= ReportDef()
oReport:PrintDialog()

FreeObj(oReport)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportDef �Autor  �Renato Nogueira     � Data �  22/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  								                          ���
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

oReport := TReport():New(cPergTit,"Relat�rio de pedidos eliminado res�duo",cPerg,{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir um relat�rio de pedidos eliminados")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Pedidos eliminados",{"SC6"})

	TRCell():New(oSection,"FILIAL"	  			 ,,"FILIAL"						,"@!"		   				,2  ,.F.,)
	TRCell():New(oSection,"NUMERO"			 	 ,,"NUMERO"						,"@!"		   				,6  ,.F.,)
	TRCell():New(oSection,"CLIENTE"				 ,,"CLIENTE"						,"@!" 			   			,6  ,.F.,)
	TRCell():New(oSection,"LOJA"				 ,,"LOJA"							,"@!"				  		,2  ,.F.,)
	TRCell():New(oSection,"DATA"				 ,,"DATA"							,"@!"						,10 ,.F.,)
	TRCell():New(oSection,"USUARIO"				 ,,"USUARIO"						,"@!"				  		,6  ,.F.,)
	TRCell():New(oSection,"MOTIVO"				 ,,"MOTIVO"							,"@!"				  		,200  ,.F.,)
	TRCell():New(oSection,"VALOR"				,,"VALOR"				,"@E 99,999,999.99",14)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SC6")

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportPrint�Autor  �Renato Nogueira     � Data �  22/07/14  ���
�������������������������������������������������������������������������͹��
���Desc.     �  								                          ���
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
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados1[99]
Local cCodOpe	:= ""
Local lImprime	:= .F.
Local cHoraFim	:= ""
Local cOrdSep	:= ""         
Local nHours
Local nMinuts
Local nSeconds

	oSection1:Cell("FILIAL")    			:SetBlock( { || aDados1[01] } )
	oSection1:Cell("NUMERO")  				:SetBlock( { || aDados1[02] } )
	oSection1:Cell("CLIENTE")  				:SetBlock( { || aDados1[03] } )
	oSection1:Cell("LOJA")		  			:SetBlock( { || aDados1[04] } )
	oSection1:Cell("DATA")		  			:SetBlock( { || aDados1[05] } )
	oSection1:Cell("USUARIO")	  			:SetBlock( { || aDados1[06] } )
	oSection1:Cell("MOTIVO")	  			:SetBlock( { || aDados1[07] } )
	oSection1:Cell("VALOR")	  				:SetBlock( { || aDados1[08] } )

oReport:SetTitle("Pedidos eliminados")// Titulo do relat�rio

oReport:SetMeter(0)
aFill(aDados1,nil)
oSection:Init()

	Processa({|| StQuery() },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	
	If  Select(cAliasLif) > 0
		
		While (cAliasLif)->(!Eof())
			
			aDados1[01]	:=	(cAliasLif)->FILIAL
			aDados1[02]	:=	(cAliasLif)->NUMERO
			aDados1[03]	:=	(cAliasLif)->CLIENTE
			aDados1[04]	:= 	(cAliasLif)->LOJA
			aDados1[05]	:=	DTOC(STOD((cAliasLif)->DATA))
			aDados1[06]	:=	UsrRetName((cAliasLif)->USUARIO)
			aDados1[07]	:=	(cAliasLif)->MOTIVO
aDados1[08]	:=	(cAliasLif)->VALOR

			oSection1:PrintLine()
			aFill(aDados1,nil)
			
			(cAliasLif)->(dbskip())
			
		EndDo

		oReport:SkipLine()
		
	EndIf
	
Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  StQuery      �Autor  �Renato Nogueira � Data �  21/02/14     ���
�������������������������������������������������������������������������͹��
���Desc.     �  Relatorio COMISSAO				                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
Static Function StQuery(cCodOpe)
*-----------------------------*

Local cQuery     := ' '

	cQuery := " SELECT DISTINCT C6_FILIAL FILIAL, C6_NUM NUMERO, C6_CLI CLIENTE, C6_LOJA LOJA, C6_XDTRES DATA, C6_XUSRRES USUARIO, C5_XMOTRES MOTIVO ,SUM(round( (C6.C6_ZVALLIQ/C6.C6_QTDVEN)*(C6.C6_QTDVEN - C6.C6_QTDENT)    ,2)         ) 	VALOR" 
	cQuery += " FROM "+RetSqlName("SC6")+" C6 "
	cQuery += " LEFT JOIN "+RetSqlName("SC5")+" C5 "
	cQuery += " ON C5.C5_FILIAL=C6.C6_FILIAL AND C5.C5_NUM=C6.C6_NUM "
	cQuery += " WHERE C6.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' AND C6_XDTRES<>' ' AND C6_XUSRRES<>' ' " 
	cQuery += " AND C6_XDTRES BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'   GROUP BY C6_FILIAL  , C6_NUM  , C6_CLI  , C6_LOJA  , C6_XDTRES  , C6_XUSRRES  , C5_XMOTRES  
	cQuery += " ORDER BY C6_FILIAL, C6_NUM "
	
cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

/*
���������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������Ŀ��
���Fun��o	 �Ajusta    � Autor � Vitor Merguizo 		  � Data � 16/08/2012		���
�����������������������������������������������������������������������������������Ĵ��
���Descri��o � Insere novas perguntas na tabela SX1 a Ajusta o Picture dos valores	���
���          � no SX3                                                           	���
�����������������������������������������������������������������������������������Ĵ��
���Sintaxe e � 																		���
������������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������
*/

Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Data de ?                 ","Data de ?                 ","Data de ?                 ","mv_ch1","D",8,0,0,"G",""                    ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","",""   ,"S","",""})
Aadd(aPergs,{"Data ate ?                ","Data ate ?                ","Data ate ?                ","mv_ch2","D",8,0,0,"G",""                    ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","",""   ,"S","",""})

//AjustaSx1(cPerg,aPergs)

Return
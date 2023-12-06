#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RSTFAT36	�Autor  �Renato Nogueira     � Data �  15/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio utilizado para imprimir informa��es do contas     ���
���          �a pagar				    		  	 				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum										              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RSTFAT36()

Local   oReport
Private cPerg 			:= "RFAT36"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif

PutSx1(cPerg, "01", "Emissao de:" 		,"Emissao de: ?" 		,"Emissao de: ?" 		,"mv_ch1","D",8,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Emissao ate:" 		,"Emissao ate: ?" 		,"Emissao ate: ?" 		,"mv_ch2","D",8,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")

oReport:=ReportDef()
 oReport:PrintDialog()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportDef �Autor  �				     � Data �  	          ���
�������������������������������������������������������������������������͹��
���Desc.     �  								                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New(cPergTit,"Relat�rio contas a pagar",cPerg,{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir um relat�rio de titulos a pagar")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Contas a pagar",{"SE2"})

TRCell():New(oSection,"NUMERO"	  			 ,,"NUMERO"		,,9,.F.,)
TRCell():New(oSection,"PARCELA"  			 ,,"PARCELA"	,,3,.F.,)
TRCell():New(oSection,"TIPO"  			 	 ,,"TIPO"		,,3,.F.,)
TRCell():New(oSection,"FORNEC"  			 ,,"FORNECEDOR"	,,6,.F.,)
TRCell():New(oSection,"LOJA"  			 	 ,,"LOJA"		,,2,.F.,)
TRCell():New(oSection,"EMISSAO"			 	 ,,"EMISSAO"	,"@!",10,.F.,)
TRCell():New(oSection,"VALOR"     			 ,,"VALOR"		,"@E 999,999,999,999,999.99",17)
TRCell():New(oSection,"ATIVIDA"			 	 ,,"ATIVIDADE"  ,,7,.F.,)    
TRCell():New(oSection,"VENCREA"			 	 ,,"VENC REAL"	,"@!",10,.F.,)
TRCell():New(oSection,"CNPJ"  			 	 ,,"CNPJ"		,,14,.F.,)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SE2")

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportPrin�Autor  �				     � Data �  	          ���
�������������������������������������������������������������������������͹��
���Desc.     �  								                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

Static Function ReportPrint(oReport)

Local oSection1	:= oReport:Section(1)
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados1[10]
Local _cSta 	:= ''

oSection1:Cell("NUMERO")    			:SetBlock( { || aDados1[01] } )
oSection1:Cell("PARCELA")  				:SetBlock( { || aDados1[02] } )
oSection1:Cell("TIPO")  				:SetBlock( { || aDados1[03] } )
oSection1:Cell("FORNEC")  				:SetBlock( { || aDados1[04] } )
oSection1:Cell("LOJA")  				:SetBlock( { || aDados1[05] } )
oSection1:Cell("EMISSAO")  				:SetBlock( { || aDados1[06] } )
oSection1:Cell("VALOR")  				:SetBlock( { || aDados1[07] } )
oSection1:Cell("ATIVIDA")  				:SetBlock( { || aDados1[08] } )
oSection1:Cell("VENCREA")  				:SetBlock( { || aDados1[09] } )
oSection1:Cell("CNPJ")  				:SetBlock( { || aDados1[10] } )

oReport:SetTitle("Titulos a pagar")// Titulo do relat�rio

oReport:SetMeter(0)
aFill(aDados1,nil)
oSection1:Init()

Processa({|| StQuery( ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())

If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		aDados1[01]	:=	(cAliasLif)->E2_NUM
		aDados1[02]	:= 	(cAliasLif)->E2_PARCELA
		aDados1[03]	:=  (cAliasLif)->E2_TIPO
		aDados1[04]	:= 	(cAliasLif)->E2_FORNECE
		aDados1[05]	:=  (cAliasLif)->E2_LOJA
		aDados1[06]	:=	STOD((cAliasLif)->E2_EMISSAO)
		aDados1[07]	:=	(cAliasLif)->E2_VALOR
		aDados1[08]	:=	(cAliasLif)->A2_ATIVIDA
		aDados1[09]	:=  STOD((cAliasLif)->E2_VENCREA)
		aDados1[10]	:=  (cAliasLif)->A2_CGC
		
		oSection1:PrintLine()
		aFill(aDados1,nil)
		
		(cAliasLif)->(dbskip())
		
	End
	
EndIf

oReport:SkipLine()

Return oReport


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �StQuery	�Autor  �				     � Data �  	          ���
�������������������������������������������������������������������������͹��
���Desc.     �  								                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

Static Function StQuery()

Local cQuery     := ' '

cQuery := " SELECT E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_EMISSAO, E2_VALOR, A2_ATIVIDA, E2_VENCREA, A2_CGC "	
cQuery += " FROM "+RetSqlName("SE2")+" E2 "
cQuery += " LEFT JOIN "+RetSqlName("SA2")+" A2 "
cQuery += " ON E2_FORNECE=A2_COD AND E2_LOJA=A2_LOJA "
cQuery += " WHERE E2.D_E_L_E_T_=' ' AND A2.D_E_L_E_T_=' ' AND E2_FORNECE NOT IN ('002009','003741','005764','005866','005871','009433','010586','MUNIC','ESTADO','UNIAO') " //Retirar steck
cQuery += " AND A2_TIPO<>'X' AND E2_VALOR>0 AND E2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
cQuery += " ORDER BY E2_NUM "

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RSTFAT55  �Autor  �Renato Nogueira     � Data �  09/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio de diverg�ncia da FCI x produto                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 	                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RSTFAT55()

Local   oReport
Private cPerg 			:= "RFAT55"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private cPergTit 		:= cAliasLif
/*
PutSx1( cPerg, "01","Produto de:"			,"","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "02","Produto at�:"			,"","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "03","Grupo de:"    			,"","","mv_ch3","C",4,0,0,"G","","SBM" ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "04","Grupo At�:"   			,"","","mv_ch4","C",4,0,0,"G","","SBM" ,"","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "05","Data de?" 				,"","","mv_ch5","D",8,0,0,"G","",""    ,"","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "06","Data ate?"				,"","","mv_ch6","D",8,0,0,"G","",""    ,"","","mv_par06","","","","","","","","","","","","","","","","")
*/
oReport		:= ReportDef()
oReport:PrintDialog()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportDef �Autor  �Renato Nogueira     � Data �  04/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio OTDS						                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 	                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New(cPergTit,"Relat�rio FCI",/*cPerg*/,{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir um relat�rio de diverg�ncia da FCI")

//Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Relat�rio FCI",{"CFD"})

TRCell():New(oSection,"CODIGO"	  			 ,,"CODIGO"		,"@!",15,.F.,)
TRCell():New(oSection,"CFDORIGEM" 			 ,,"CFD ORIGEM" ,"@!",01,.F.,)
TRCell():New(oSection,"SB1ORIGEM" 			 ,,"SB1 ORIGEM" ,"@!",01,.F.,)
TRCell():New(oSection,"STATUS"	 			 ,,"STATUS"	    ,"@!",01,.F.,)
TRCell():New(oSection,"POSIPI"	 			 ,,"POSIPI"	    ,"@!",08,.F.,)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("CFD")

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportPrin�Autor  �Renato Nogueira     � Data �  04/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio OTDS						                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 	                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados[5]
Local _cSta 	:= ''

oSection1:Cell("CODIGO")    			:SetBlock( { || aDados[01] } )
oSection1:Cell("CFDORIGEM")  			:SetBlock( { || aDados[02] } )
oSection1:Cell("SB1ORIGEM")				:SetBlock( { || aDados[03] } )
oSection1:Cell("STATUS")    			:SetBlock( { || aDados[04] } )
oSection1:Cell("POSIPI" )	 		 	:SetBlock( { || aDados[05] } )

oReport:SetTitle("Relat�rio FCI")// Titulo do relat�rio

oReport:SetMeter(0)
aFill(aDados,nil)
oSection:Init()


Processa({|| StQuery(  ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		aDados[01]	:=	(cAliasLif)->CFD_COD
		aDados[02]	:= 	(cAliasLif)->CFD_ORIGEM
		aDados[03]	:=  (cAliasLif)->B1_ORIGEM
		aDados[04]	:=  (cAliasLif)->STATUS1
		aDados[05]	:=  (cAliasLif)->B1_POSIPI
		
		oSection1:PrintLine()
		aFill(aDados,nil)
		(cAliasLif)->(dbskip())
		
	End
	(cAliasLif)->(dbCloseArea())
EndIf
oReport:SkipLine()
Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �StQuery	�Autor  �Renato Nogueira     � Data �  04/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio OTDS						                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 	                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function StQuery(_ccod)


Local cQuery     := ' '


cQuery := " SELECT CFD_COD,MAX(CFD_ORIGEM)CFD_ORIGEM,MAX(B1_ORIGEM)B1_ORIGEM, MIN(STATUS)STATUS1,MAX(B1_POSIPI) B1_POSIPI FROM ( "
cQuery += " SELECT CFD.CFD_COD,CFD.CFD_ORIGEM,B1_ORIGEM,'1' STATUS, B1_POSIPI FROM "+RetSqlName("CFD")+" CFD "
cQuery += " INNER JOIN (SELECT CFD_COD,MAX(R_E_C_N_O_)REC FROM "+RetSqlName("CFD")+" WHERE D_E_L_E_T_= ' ' GROUP BY CFD_COD)CF ON CF.CFD_COD = CFD.CFD_COD AND CF.REC =CFD.R_E_C_N_O_ "
cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = ' ' AND B1_COD = CFD.CFD_COD AND SB1.D_E_L_E_T_= ' ' "
cQuery += " UNION ALL  "
cQuery += " SELECT B1_COD, ' ' , B1_ORIGEM, CASE WHEN SG1.G1_COD IS NULL AND SG12.G1_COD IS NULL THEN '2' WHEN SG12.G1_COD IS NULL THEN '3' ELSE '4' END, B1_POSIPI "
cQuery += " FROM "+RetSqlName("SB1")+" SB1 "
cQuery += " LEFT JOIN "+RetSqlName("SG1")+" SG1 ON SG1.G1_FILIAL <> ' ' AND SG1.G1_COD = B1_COD AND SG1.D_E_L_E_T_= ' '  "
cQuery += " LEFT JOIN SG1030 SG12 ON SG12.G1_FILIAL <> ' ' AND SG12.G1_COD = B1_COD AND SG12.D_E_L_E_T_= ' ' "
cQuery += " WHERE B1_FILIAL = ' ' AND B1_ORIGEM IN ('3','5','8') AND B1_GRUPO <> '999' AND B1_MSBLQL <> '1' AND SB1.D_E_L_E_T_= ' ' "
cQuery += " )XXX GROUP BY CFD_COD "


//cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
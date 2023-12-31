#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

#DEFINE PULALINHA chr(10)+chr(13)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RSTFAT74  �Autor  �Renato Nogueira     � Data �  04/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio de notas de exporta��o por data                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 	                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RSTFAT74()

Local   oReport
Private cPerg 			:= "RFAT74"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private cPergTit 		:= cAliasLif

PutSx1( cPerg, "01","Data de?" 				   					,"","","mv_ch1" ,"D",8,0,0,"G","",""    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1( cPerg, "02","Data ate?"				   					,"","","mv_ch2" ,"D",8,0,0,"G","",""    ,"","","mv_par02","","","","","","","","","","","","","","","","")

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
Local oSection1
Local nX		:= 0
Local nY		:= 1
aDados2:= {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'','' }}
oReport := TReport():New(cPergTit,"Relat�rio de notas - exporta��o",cPerg,{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir um relat�rio de notas - exporta��o")

Pergunte(cPerg,.F.)

oSection1 := TRSection():New(oReport,"Relat�rio de notas - exporta��o",{"SF2"})

	TRCell():New(oSection1,"NFISCAL"  		,,"Nota"				,"@!",09,/*lPixel*/,{||_cNum})
	TRCell():New(oSection1,"SERIE" 			,,"Tipo"				,"@!",03,/*lPixel*/,{||_cTipo})
	TRCell():New(oSection1,"TITULO"			,,"T�tulo" 				,"@!",09,/*lPixel*/,{||_cTit})
	TRCell():New(oSection1,"CLIENTE"		,,"Cliente"				,"@!",06,/*lPixel*/,{||_cCli})
	TRCell():New(oSection1,"LOJA"			,,"Loja" 				,"@!",02,/*lPixel*/,{||_cLoja})
	TRCell():New(oSection1,"NOME"			,,"Nome" 				,"@!",40,/*lPixel*/,{||_cNome})
	TRCell():New(oSection1,"EMISSAO"		,,"Emiss�o"				,"@!",10,/*lPixel*/,{||_dEmis})
	TRCell():New(oSection1,"VLRBRU" 		,,"Vlr. Bruto"			,"@E 999,999,999.99",14,/*lPixel*/,{||_nVlrB})
	TRCell():New(oSection1,"VLRMER" 		,,"Vlr. Liq."			,"@E 999,999,999.99",14,/*lPixel*/,{||_nVlrL})
	TRCell():New(oSection1,"CNPJ"   		,,"CNPJ"				,"@!",14,/*lPixel*/,{||_cCnpj})
	TRCell():New(oSection1,"CATIV"   		,,"Atividade"			,"@!",06,/*lPixel*/,{||_cAtiv})
	TRCell():New(oSection1,"TX2" 			,,"Taxa 2" 				,"@E 999,999,999.99",14,/*lPixel*/,{||_nTx2})
	TRCell():New(oSection1,"TX3" 			,,"Taxa 3"				,"@E 999,999,999.99",14,/*lPixel*/,{||_nTx3})
	TRCell():New(oSection1,"TX4" 			,,"Taxa 4"				,"@E 999,999,999.99",14,/*lPixel*/,{||_nTx4})
	TRCell():New(oSection1,"TX5" 			,,"Taxa 5"				,"@E 999,999,999.99",14,/*lPixel*/,{||_nTx5})

oSection1:SetHeaderSection(.t.)
oSection1:Setnofilter("SF2")

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
Local nX			:= 0
Local cQuery 		:= ""
Local cAlias 		:= "QRYTEMP0"
Local _cSta 		:= ''
Private oSection1	:= oReport:Section(1)
Private aDados	:= {}
Private aDados2	:= {}
Private nY			:= 0

oReport:SetTitle("Relat�rio de notas - exporta��o")// Titulo do relat�rio

oReport:SetMeter(0)
aFill(aDados,nil)
oSection1:Init()

Processa({|| StQuery(  ) },"Compondo Relatorio")

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

Static Function StQuery()

Local cQuery	:= ""
Local nX		:= 0
Local lPrimeira	:= .T.

//Adiciona estrutura
aDados	:= {}

			cQuery := " SELECT F2_DOC, F2_SERIE, F2_DUPL, F2_CLIENTE, F2_LOJA, F2_EMISSAO, F2_VALBRUT, F2_VALMERC, A1_CGC, A1_ATIVIDA "+PULALINHA
			cQuery += " , (SELECT A1_NOME FROM "+RetSqlName("SA1")+" A1 WHERE A1.D_E_L_E_T_=' ' AND A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA) NOME "+PULALINHA
			cQuery += " , NVL((SELECT M2_MOEDA2 FROM "+RetSqlName("SM2")+" M21 WHERE M21.D_E_L_E_T_=' ' AND M21.M2_DATA=F2.F2_EMISSAO),0) TX2 "+PULALINHA
			cQuery += " , NVL((SELECT M2_MOEDA3 FROM "+RetSqlName("SM2")+" M22 WHERE M22.D_E_L_E_T_=' ' AND M22.M2_DATA=F2.F2_EMISSAO),0) TX3 "+PULALINHA
			cQuery += " , NVL((SELECT M2_MOEDA4 FROM "+RetSqlName("SM2")+" M23 WHERE M23.D_E_L_E_T_=' ' AND M23.M2_DATA=F2.F2_EMISSAO),0) TX4 "+PULALINHA
			cQuery += " , NVL((SELECT M2_MOEDA5 FROM "+RetSqlName("SM2")+" M24 WHERE M24.D_E_L_E_T_=' ' AND M24.M2_DATA=F2.F2_EMISSAO),0) TX5 "+PULALINHA
			cQuery += " FROM "+RetSqlName("SF2")+" F2 "+PULALINHA
			cQuery += " LEFT JOIN "+RetSqlName("SA1")+" A1 "+PULALINHA
			cQuery += " ON A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA "+PULALINHA
			cQuery += " WHERE A1.D_E_L_E_T_=' ' AND F2.D_E_L_E_T_=' ' AND F2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND F2_TIPOCLI='X' "

	//cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	
	//Count to nQtdReg
	
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
				_cNum		:= (cAliasLif)->F2_DOC
				_cTipo		:= (cAliasLif)->F2_SERIE
				_cTit		:= (cAliasLif)->F2_DUPL
				_cCli		:= (cAliasLif)->F2_CLIENTE
				_cLoja		:= (cAliasLif)->F2_LOJA
				_dEmis		:= DTOC(STOD((cAliasLif)->F2_EMISSAO))
				_nVlrB		:= (cAliasLif)->F2_VALBRUT
				_nVlrL		:= (cAliasLif)->F2_VALMERC
				_cCnpj		:= (cAliasLif)->A1_CGC
				_cAtiv		:= (cAliasLif)->A1_ATIVIDA
				_cNome		:= (cAliasLif)->NOME
				_nTx2		:= (cAliasLif)->TX2
				_nTx3		:= (cAliasLif)->TX3
				_nTx4		:= (cAliasLif)->TX4
				_nTx5		:= (cAliasLif)->TX5
				
				oSection1:PrintLine()
				
			(cAliasLif)->(DbSkip())
			
		End
		
	EndIf

Return()
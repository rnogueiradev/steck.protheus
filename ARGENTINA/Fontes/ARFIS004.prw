#Include "Protheus.ch"
#Include "TopConn.ch"
 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ARFIS004  � Autor � Cristiano Pereira� Data �  30/03/13    ���
�������������������������������������������������������������������������͹��
���Descricao � Listado das retenciones Steck Libro Compras                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ARFIS004()

Local oReport
Local aArea	:= GetArea()



If Pergunte("ARFIS04",.T.)
	oReport 	:= ReportDef()
	oReport		:PrintDialog()
EndIf

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportDef �Autor  �Microsiga           � Data �  03/30/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Definicao do layout do Relatorio                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportDef()

Local oReport
Local oSection1

oReport := TReport():New("ARFIS04","Libro Compras x Impuestos","ARFIS04",{|oReport| ReportPrint(oReport)},"Libro Compras.")

oReport:SetLandscape()
pergunte("ARFIS04",.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros						  �
//� mv_par01			// Mes							 		  �
//� mv_par02			// Ano									  �
//���������������������������������������������������������������� 


oSection1 := TRSection():New(oReport,"Libro Compras",{"SD1"},)  

TRCell():New(oSection1,"EMISION"	    ,,"EMISION"	,"@!",008,.F.,) 
TRCell():New(oSection1,"FECHA_EMISION"	,,"FECHA EMISION","@!",008,.F.,) 
TRCell():New(oSection1,"NUM_FAT"		,,"NUM. FACTURA" ,"@!",010,.F.,)   
TRCell():New(oSection1,"DENOMINACION"   ,,"DENOMINACION" ,"@!",040,.F.,)
TRCell():New(oSection1,"CUIT"		    ,,"CUIT"	,"@!",025,.F.,) 
TRCell():New(oSection1,"PROVINCIA"		    ,,"PROVINCIA"	,"@!",05,.F.,)
TRCell():New(oSection1,"BASE_IMPONIBLE"		,,"BASE IMPONIBLE"	,"@!",20,.F.,) 
TRCell():New(oSection1,"PERCEP_IVA"		,,"PERCEPCIONES IVA"	,"@!",20,.F.,) 
TRCell():New(oSection1,"PERCEP_IGR"		,,"PERCEPCIONES INGRESSO BRUTO"	,"@!",20,.F.,) 
TRCell():New(oSection1,"PERCEP_GAN"		,,"PERCEPCIONES GANANCIAS"	,"@!",20,.F.,)
TRCell():New(oSection1,"PERCEP_SUS"		,,"PERCEPCIONES SUSS"	,"@!",20,.F.,)
 

oBreak1 := TRBreak():New(oSection1,".T.","Total general",.F.) 
oFunction := TRFunction():New(oSection1:Cell('BASE_IMPONIBLE'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.) 
oFunction := TRFunction():New(oSection1:Cell('PERCEP_IVA'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.) 
oFunction := TRFunction():New(oSection1:Cell('PERCEP_IGR'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.) 
oFunction := TRFunction():New(oSection1:Cell('PERCEP_GAN'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.)
oFunction := TRFunction():New(oSection1:Cell('PERCEP_SUS'),NIL,"SUM",oBreak1,"Total general",PesqPict("SE2","E2_VALOR"),/*uFormula*/,.F.,.F.)



oSection1:SetHeaderSection(.T.)
oSection1:Setnofilter("SD1")


Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint� Autor �Microsiga		          � Data �12.05.12 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os  ���
���          �relatorios que poderao ser agendados pelo usuario.           ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                            ���
��������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                          ���
��������������������������������������������������������������������������Ĵ��
���          �               �                                             ���
���������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ReportPrint(oReport)

Local cTitulo		:= OemToAnsi("Libro Compras")
Local cAlias1		:= "QRY1SD1"
Local cQuery1		:= ""
Local nRecSM0		:= SM0->(Recno())
Local aDados1[11]
Local oSection1  := oReport:Section(1)
        
oSection1:Cell("EMISION"  )		:SetBlock( { || aDados1[1] })
oSection1:Cell("FECHA_EMISION" )		:SetBlock( { || aDados1[2] })
oSection1:Cell("NUM_FAT" )		:SetBlock( { || aDados1[3] })
oSection1:Cell("DENOMINACION" )		:SetBlock( { || aDados1[4] })
oSection1:Cell("CUIT" )	    	:SetBlock( { || aDados1[5] })
oSection1:Cell("PROVINCIA" )	    	:SetBlock( { || aDados1[6] }) 
oSection1:Cell("BASE_IMPONIBLE" )	:SetBlock( { || aDados1[7] }) 
oSection1:Cell("PERCEP_IVA" )	:SetBlock( { || aDados1[8] }) 
oSection1:Cell("PERCEP_IGR" )	:SetBlock( { || aDados1[9] }) 
oSection1:Cell("PERCEP_GAN" )	:SetBlock( { || aDados1[10] })
oSection1:Cell("PERCEP_SUS" )	:SetBlock( { || aDados1[11] })   






 
cQuery1 := "      SELECT  SUBSTR(SD1.D1_EMISSAO,7,2)||'/'|| SUBSTR(SD1.D1_EMISSAO,5,2)||'/'|| SUBSTR(SD1.D1_EMISSAO,1,4) AS emision,    "
cQuery1 += "        SUBSTR(SD1.D1_DTDIGIT,7,2)||'/'|| SUBSTR(SD1.D1_DTDIGIT,5,2)||'/'|| SUBSTR(SD1.D1_DTDIGIT,1,4) AS Fecha_de_publicacion,    "
cQuery1 += "        SD1.D1_DOC AS numero_de_factura,                                                                                           "
cQuery1 += "        SA2.A2_NOME AS denominacion,     "
cQuery1 += "        SA2.A2_CGC  AS numero_de_CUIT,   "
cQuery1 += "        SA2.A2_EST  AS provincia,        "
cQuery1 += "        SUM(SD1.D1_TOTAL) AS base_imponible, "
cQuery1 += "        SUM(SD1.D1_VALIMPC+SD1.D1_VALIMP4)  AS percepc_IVA,              " //--4 
cQuery1 += "       SUM(SD1.D1_VALIMP6)  AS percepc_i_brutos,                 "
cQuery1 += "        SUM(SD1.D1_VALIMP5)  AS percepc_ganancias,                       "
cQuery1 += "        SF1.F1_RETSUSS AS suss                                                "
                                                                                          "
cQuery1 += "  FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SA2")+" SA2 , "+RetSqlName("SF1")+" SF1 "
cQuery1 += "  WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"'                                                                  AND    "
cQuery1 += "        SD1.D_E_L_E_T_ <> '*'                                                                                 AND    "
cQuery1 += "        SD1.D1_DTDIGIT >='"+Dtos(MV_PAR01)+"'                                                                 AND    "
cQuery1 += "        SD1.D1_DTDIGIT <='"+Dtos(MV_PAR02)+"'                                                                 AND    "
cQuery1 += "        SD1.D1_FORNECE= SA2.A2_COD                                                                            AND    "
cQuery1 += "        SD1.D1_LOJA   = SA2.A2_LOJA                                                                           AND    "
cQuery1 += "        SA2.D_E_L_E_T_ <> '*'                                                                                 AND    "
cQuery1 += "        SD1.D1_FILIAL = SF1.F1_FILIAL                                                                         AND    "
cQuery1 += "        SD1.D1_DOC    = SF1.F1_DOC                                                                            AND    "
cQuery1 += "        SD1.D1_FORNECE = SF1.F1_FORNECE                                                                       AND    "
cQuery1 += "        SD1.D1_LOJA    = SF1.F1_LOJA                                                                          AND    "
cQuery1 += "        SD1.D1_SERIE   = SF1.F1_SERIE                                                                         AND    "
cQuery1 += "        SF1.D_E_L_E_T_ <> '*'                                                                                    " 
     
      
cQuery1 += "  GROUP BY SD1.D1_EMISSAO,SD1.D1_DTDIGIT,SD1.D1_DOC,SA2.A2_NOME,SA2.A2_CGC,SA2.A2_EST,SF1.F1_RETSUSS                 "


                 
cQuery1 := ChangeQuery(cQuery1)

//�������������������������������Ŀ
//� Fecha Alias se estiver em Uso �
//���������������������������������
If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif

//���������������������������������������������
//� Monta Area de Trabalho executando a Query �
//���������������������������������������������
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery1),cAlias1,.T.,.T.)


oReport:SetTitle(cTitulo)
               
nCont:= 0
dbeval({||nCont++})

oReport:SetMeter(nCont)

aFill(aDados1,nil)
oSection1:Init()

dbSelectArea(cAlias1)
(cAlias1)->(dbGoTop())
  
//Imprime Dcre
aFill(aDados1,nil)
oSection1:Init()


//Atualiza Array com dados de Capta��o
While (cAlias1)->(!Eof())
     
	aDados1[01]  := (cAlias1)->(emision) 
	aDados1[02]  := (cAlias1)->(Fecha_de_publicacion) 
	aDados1[03]  := (cAlias1)->(numero_de_factura)
	aDados1[04]  := (cAlias1)->(denominacion) 
	aDados1[05]  := (cAlias1)->(numero_de_CUIT) 
	aDados1[06]  := (cAlias1)->(provincia) 
	aDados1[07]  := Alltrim(Transform((cAlias1)->(base_imponible),PesqPict("SE2","E2_VALOR")))
	aDados1[08]  := Alltrim(Transform((cAlias1)->(percepc_IVA),PesqPict("SE2","E2_VALOR")))
	aDados1[09]  := Alltrim(Transform((cAlias1)->(percepc_i_brutos),PesqPict("SE2","E2_VALOR"))) 
	aDados1[10]  := Alltrim(Transform((cAlias1)->(percepc_ganancias),PesqPict("SE2","E2_VALOR")))
	aDados1[11]  := Alltrim(Transform((cAlias1)->(suss),PesqPict("SE2","E2_VALOR")))   
 
    
    oSection1:PrintLine()
	aFill(aDados1,nil)

	(cAlias1)->(dbSkip())
EndDo

//�������������������������������Ŀ
//� Fecha Alias se estiver em Uso �
//���������������������������������
If !Empty(Select(cAlias1))
	DbSelectArea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif
 
//Imprime os dados de Metas
aFill(aDados1,nil)
oSection1:Init()
   
oSection1:PrintLine()
aFill(aDados1,nil)

oReport:SkipLine()
oSection1:Finish() 

Return


#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STFIS03  � Autor � Cristiano Pereira� Data �  17/07/2017  ���
�������������������������������������������������������������������������͹��
���Descricao � Rela��o de Carta de Corre��o por Per�odo                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function STFIS03()

	Local oReport
	Local aArea	:= GetArea()

	Ajusta()

	If Pergunte("STFIS03",.T.)
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
Static aDados1[08]

Static Function ReportDef()

	Local oReport
	Local oSection1
	Private oBreak1
	Private oSecFil

	oReport := TReport():New("STFIS03","Rela��o das cartas de corre��es","STFIS03",{|oReport| ReportPrint(oReport)},"Este programa ir� imprimir a an�lise das cartas de corre��es.")

	oReport:SetLandscape()
	pergunte("STFIS03",.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros						  �
//� mv_par01			// Mes							 		  �
//� mv_par02			// Ano									  �
//����������������������������������������������������������������

	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 7

	oSection1 := TRSection():New(oReport,"Carta de Corre��o",{"SF2"},)

	TRCell():New(oSection1,"FILIAL"	     	,,"FILIAL"	    ,"@!",002,.F.,)
	TRCell():New(oSection1,"NFISCAL"	,,"NOTA FISCAL"	,"@!",009,.F.,)
	TRCell():New(oSection1,"CLI"		,,"CLIENTE"	,"@!",006,.F.,)
	TRCell():New(oSection1,"LOJA"		,,"LOJA"	,"@!",002,.F.,)
	TRCell():New(oSection1,"NOME"		,,"NOME"	,"@!",030,.F.,)

	TRCell():New(oSection1,"EMIS"	,,"EMISS�O"	,,010,.F.,)
	TRCell():New(oSection1,"IDEVEN"		,,"ID EVENTO"	,"@!",050,.F.,)
	TRCell():New(oSection1,"CORREC"		,,"CORRE��O"	,"@!",100,.F.,)

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("SF2")



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

	Local cTitulo		:= OemToAnsi("Carta de Corre��o")
	Local cAlias1		:= "QRY1SF2"
	Local cQuery1		:= ""
	Local _cQry150    := ""
	Local nRecSM0		:= SM0->(Recno())
	Local oSection1  := oReport:Section(1)
	Private	aSaldo  := {}
	Private _nTpeso



	oSection1:Cell("FILIAL"  )	     	:SetBlock( { || aDados1[1] })
	oSection1:Cell("NFISCAL" )		:SetBlock( { || aDados1[2] })
	oSection1:Cell("CLI" )	   	:SetBlock( { || aDados1[3] })
	oSection1:Cell("LOJA" )	    	:SetBlock( { || aDados1[4] })
	oSection1:Cell("NOME" )	    	:SetBlock( { || aDados1[5] })

	oSection1:Cell("EMIS" )    	:SetBlock( { || aDados1[6] })
	oSection1:Cell("IDEVEN" )      	:SetBlock( { || aDados1[7] })
	oSection1:Cell("CORREC" )      	:SetBlock( { || aDados1[8] })


	If Select(cAlias1) > 0
		DbSelectArea(cAlias1)
		DbCloSeArea()
	Endif


	cQuery1 :=  " SELECT SF2.*                     "
	cQuery1 +=  " FROM   "+RetSqlName("SF2")+" SF2 "

	cQuery1 +=  " WHERE SF2.F2_FILIAL >= '"+MV_PAR01+"' AND SF2.F2_FILIAL <= '"+MV_PAR02+"' AND SF2.D_E_L_E_T_ <> '*'     AND "
	cQuery1 +=  "       SF2.F2_EMISSAO >= '"+DTOS(MV_PAR03)+"' AND SF2.F2_EMISSAO <='"+DTOS(MV_PAR04)+"'                  AND "
	cQuery1 +=  "       SF2.F2_IDCCE <> ''                                                                                    "

	cQuery1 +=  "  ORDER BY SF2.F2_FILIAL,SF2.F2_DOC,SF2.F2_EMISSAO                                                           "

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


		If Select("SPD150") > 0
			DbSelectArea("SPD150")
			DbCloSeArea()
		Endif
   
        
		If Substr(cNumEmp,03,02) <> "03"
       
			_cQry150 := " SELECT SUBSTR(utl_raw.cast_to_varchar2(XML_ERP),INSTR(utl_raw.cast_to_varchar2(XML_ERP),'<xCorrecao>'),INSTR(utl_raw.cast_to_varchar2(XML_ERP),'</xCorrecao>')-INSTR(utl_raw.cast_to_varchar2(XML_ERP),'<xCorrecao>')) AS MOTIVO    "
			_cQry150   += " FROM SPED150 SPD                                                               "
			_cQry150   += " WHERE SPD.ID_EVENTO = '"+AllTrim((cAlias1)->(F2_IDCCE))+"'         AND                  "
			_cQry150   += "       SPD.ID_ENT IN ('000001','000002','000007','000008')                               "
     
			TCQUERY _cQry150 NEW ALIAS "SPD150"
     
			_nRec := 0
			DbEval({|| _nRec++  }) 
			
			DbSelectArea("SPD150") 
			DbGotop()
	
       
		Else
       
			_cQry150 := " SELECT SUBSTR(utl_raw.cast_to_varchar2(XML_ERP),INSTR(utl_raw.cast_to_varchar2(XML_ERP),'<xCorrecao>'),INSTR(utl_raw.cast_to_varchar2(XML_ERP),'</xCorrecao>')-INSTR(utl_raw.cast_to_varchar2(XML_ERP),'<xCorrecao>')) AS MOTIVO    "
			_cQry150   += " FROM SPED150 SPD                                                               "
			_cQry150   += " WHERE SPD.ID_EVENTO = '"+AllTrim((cAlias1)->(F2_IDCCE))+"'      AND                     "
			_cQry150   += "       SPD.ID_ENT IN ('000004','000009')   "
     
			TCQUERY _cQry150 NEW ALIAS "SPD150"
     
			_nRec := 0
			DbEval({|| _nRec++  })
		DbSelectArea("SPD150") 
			DbGotop()
       
		Endif
   
		
	
		DbSelectArea("SA1")
		DbSetOrder(1)
		If DbSeek(xFilial("SA1")+(cAlias1)->(F2_CLIENTE)+(cAlias1)->(F2_LOJA))
			aDados1[01]  := (cAlias1)->(F2_FILIAL)
			aDados1[02]  := (cAlias1)->(F2_DOC)
			aDados1[03]  := (cAlias1)->(F2_CLIENTE)
			aDados1[04]  := (cAlias1)->(F2_LOJA)
			aDados1[05]  := SA1->A1_NOME
			aDados1[06]  := DTOC(STOD((cAlias1)->(F2_EMISSAO)))
			aDados1[07]  := (cAlias1)->(F2_IDCCE)
			aDados1[08]  := IIF(_nRec > 0 ,STRTRAN(STRTRAN(SPD150->MOTIVO,'<xCorrecao>',''),'</xCorrecao>',''),"N�O ENCONTRADO, VERIFICAR SEFAZ!")
		Endif
	
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


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Ajusta    �Autor  �Cristiano Pereira  � Data �  03/20/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


Static Function Ajusta()

	Local aPergs 	:= {}

	Aadd(aPergs,{"Filial De ?              ","Filial De?              ","Filial De ?             ","mv_ch1","C",2,0,0,"G","NaoVazio() ","mv_par01","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Filial Ate ?             ","Filial Ate?              ","Filial Ate ?             ","mv_ch2","C",2,0,0,"G","NaoVazio() ","mv_par02","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Data De ?                ","Data De ?             	  ","Data De ?                ","mv_ch3","D",8,0,0,"C","NaoVazio() ","mv_par03","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Data Ate ?               ","Data Ate ?             	  ","Data Ate?                    ","mv_ch4","D",8,0,0,"C","NaoVazio() ","mv_par04","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})

//AjustaSx1("STFIS03",aPergs)

Return
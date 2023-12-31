#INCLUDE "MATR620.CH" 
#Include "FIVEWIN.Ch"
                  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MATR620  � Autor � Marco Bianchi         � Data � 11/09/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao Vendas por Produto                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function xMATR620()

Local oReport   
PutSx1("MTR620", "13", "Do Grupo:" ,"Do Grupo: ?" ,"Do Grupo: ?"        ,"mv_chd","C",4,0,0,"G","",'SBM' ,"","","mv_par13","","","","","","","","","","","","","","","","")             ///////////////                     ///////////
PutSx1("MTR620", "14", "Ate Grupo:" ,"Ate Grupo: ?" ,"Ate Grupo: ?"    ,"mv_che","C",4,0,0,"G","",'SBM' ,"","","mv_par14","","","","","","","","","","","","","","","","")

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	u_xxMATR620R()
EndIf

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Marco Bianchi         � Data � 11/09/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport
Local oVenProd
#IFDEF TOP
	Local cAliasQry := GetNextAlias()
#ELSE	
	Local cAliasQry := "SC6"
#ENDIF	

Local cProd			:= ""
Local nTotQuant 	:= 0
Local nTotFat 		:= 0
Local cUM 			:= ""
Local nTotDesc 	:= 0
Local nTotVal 		:= 0


//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport := TReport():New("MATR620",STR0012,"MTR620", {|oReport| ReportPrint(oReport,cAliasQry,oVenProd)},STR0013 + " " + STR0014)	// "Relacao de Pedidos por Produto"###"Este relatorio ira emitir a relacao de Vendas por"###"ordem de Produto."
oReport:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                          				�
//��������������������������������������������������������������������������
AjustaSX1()
Pergunte(oReport:uParam,.F.)

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oVenProd := TRSection():New(oReport,STR0023,{"SC6","SB1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)		// "Relacao de Pedidos por Produto"
oVenProd:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Define celulas da secao                                                 �
//��������������������������������������������������������������������������
TRCell():New(oVenProd,"CPROD"	  	,/*Tabela*/	,STR0015,PesqPict("SB1","B1_COD")		,TamSx3("B1_COD")	 [1],/*lPixel*/,{|| cProd })			    // "Produto"
TRCell():New(oVenProd,"B1_DESC"		,"SB1"		,STR0016,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")	 [1],/*lPixel*/,{|| SB1->B1_DESC })	    // "Denominacao"
TRCell():New(oVenProd,"NTOTQUANT1"	,/*Tabela*/	,STR0017,PesqPict("SC6","C6_QTDVEN",19)	,TamSx3("C6_QTDVEN") [1],/*lPixel*/,{|| nTotQuant }) 		    // "Qtd.Vendida"
TRCell():New(oVenProd,"NTOTQUANT2"	,/*Tabela*/	,STR0017,PesqPict("SC6","C6_UNSVEN",19)	,TamSx3("C6_QTDVEN") [1],/*lPixel*/,{|| nTotQuant })		    // "Qtd.Vendida"
TRCell():New(oVenProd,"NTOTFAT1"	,/*Tabela*/	,STR0018,PesqPict("SC6","C6_QTDVEN",19)	,TamSx3("C6_QTDVEN") [1],/*lPixel*/,{|| nTotFat })			    // "Qtd.Faturada"
TRCell():New(oVenProd,"NTOTFAT2"	,/*Tabela*/	,STR0018,PesqPict("SC6","C6_UNSVEN",19)	,TamSx3("C6_QTDVEN") [1],/*lPixel*/,{|| nTotFat })			    // "Qtd.Faturada"
TRCell():New(oVenProd,"CUM"			,/*Tabela*/	,STR0019,PesqPict("SB1","B1_UM")	    ,TamSx3("B1_UM")	 [1],/*lPixel*/,{|| cUM })				    // "UM"
TRCell():New(oVenProd,"NTOTDESC"	,/*Tabela*/	,STR0020,PesqPict("SC6","C6_PRUNIT",19)	,TamSx3("C6_PRUNIT") [1],/*lPixel*/,{|| nTotDesc },,,"RIGHT")	// "Desconto"
TRCell():New(oVenProd,"NTOTVAL"		,/*Tabela*/	,STR0021,PesqPict("SC6","C6_VALOR",19)	,TamSx3("C6_VALOR")	 [1],/*lPixel*/,{|| nTotVal },,,"RIGHT")	// "Valor Total"

TRFunction():New(oVenProd:Cell("NTOTQUANT1")	,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oVenProd:Cell("NTOTQUANT2")	,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oVenProd:Cell("NTOTFAT1")		,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oVenProd:Cell("NTOTFAT2")		,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oVenProd:Cell("NTOTDESC")	    ,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oVenProd:Cell("NTOTVAL")		,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)


Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Marco Bianchi         � Data � 11/09/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasQry,oVenProd)


Local cMascara :=GetMv("MV_MASCGRD")
Local nTamRef  :=Val(Substr(cMascara,1,2))
Local cQueryD2 := "", cChaveD := "", cQueryD1 := ""
Local cDupli	:= If( (MV_PAR10 == 1),"S",If( (MV_PAR10 == 2),"N","SN" ) )
Local cEstoq	:= If( (MV_PAR11 == 1),"S",If( (MV_PAR11 == 2),"N","SN" ) )
Local cNomArq	:= cNomArq1 := ""       
Local lF620Qry  := ExistBlock("F620QRY")  
Local cQueryAdd := ""


#IFNDEF TOP
	Local cCondicao := ""
#ENDIF


If mv_par05 == 1
	oReport:Section(1):Cell("NTOTQUANT1" ):SetBlock({|| nTotQuant})
	oReport:Section(1):Cell("NTOTFAT1" ):SetBlock({|| nTotFat})
Else
	oReport:Section(1):Cell("NTOTQUANT2" ):SetBlock({|| nTotQuant})
	oReport:Section(1):Cell("NTOTFAT2" ):SetBlock({|| nTotFat})
EndIf

oReport:Section(1):Cell("CPROD" ):SetBlock({|| cProd})
oReport:Section(1):Cell("CUM" ):SetBlock({|| cUM})
oReport:Section(1):Cell("NTOTDESC" ):SetBlock({|| nTotDesc})
oReport:Section(1):Cell("NTOTVAL" ):SetBlock({|| nTotVal})

cProd	:= ""
nTotQuant	:= 0
nTotFat		:= 0
cUM			:= ""
nTotDesc		:= 0
nTotVal		:= 0


//������������������������������������������������������������������������Ŀ
//�Metodo TrPosition()                                                     �
//�                                                                        �
//�Posiciona em um registro de uma outra tabela. O posicionamento ser�     �
//�realizado antes da impressao de cada linha do relat�rio.                �
//�                                                                        �
//�                                                                        �
//�ExpO1 : Objeto Report da Secao                                          �
//�ExpC2 : Alias da Tabela                                                 �
//�ExpX3 : Ordem ou NickName de pesquisa                                   �
//�ExpX4 : String ou Bloco de c�digo para pesquisa. A string ser� macroexe-�
//�        cutada.                                                         �
//�                                                                        �
//��������������������������������������������������������������������������
TRPosition():New(oReport:Section(1),"SB1",1,{|| SB1->B1_FILIAL+cProd })


//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)                                                

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SC6")		// Itens do Pedido de Vendas
dbSetOrder(2)				// Produto,Numero
#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	
	BeginSql Alias cAliasQry
	SELECT C6_FILIAL,C6_QTDVEN,C6_QTDENT,C6_BLQ,C6_GRADE,C6_TES,C6_NUM,C6_SEGUM,C6_UNSVEN,C6_VALOR,C6_PRUNIT,;
			 C6_PRCVEN,C6_VALDESC,C6_PRODUTO,C6_UM
	FROM %Table:SC6% SC6 ,%Table:SB1% SB1 , %Table:SBM%  SBM 
	WHERE C6_FILIAL = %xFilial:SC6% 
		AND C6_PRODUTO >= %Exp:mv_par03% AND C6_PRODUTO <= %Exp:mv_par04% 
		AND SC6.%NotDel%
				     AND SB1.%NotDel%
 AND SB1.B1_COD    = C6_PRODUTO
 AND SB1.B1_FILIAL = %xFilial:SB1%
		     AND SBM.%NotDel%
 AND SBM.BM_GRUPO    = SB1.B1_GRUPO 
 AND SBM.BM_GRUPO >= %Exp:mv_par13% AND  SBM.BM_GRUPO <= %Exp:mv_par14% 
 AND SBM.BM_FILIAL = %xFilial:SBM%
	ORDER BY C6_PRODUTO
	EndSql 
	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�                                                                        �
	//�Prepara o relat�rio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
#ELSE
		cCondicao := 'C6_FILIAL=="'+xFilial("SC6") + '"'
		cCondicao += '.And.C6_PRODUTO >= "'+ mv_par03+'"'
		cCondicao += '.And.C6_PRODUTO <= "'+ mv_par04+'"'
	cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
cQuery += " ON SB1.D_E_L_E_T_   = ' '
cQuery += " AND SB1.B1_COD    = SC6.C6_PRODUTO
cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("SBM")+" )SBM "
cQuery += " ON SBM.D_E_L_E_T_   = ' '
cQuery += " AND SBM.BM_GRUPO    = SB1.B1_GRUPO
cQuery += " AND SBM.BM_FILIAL = '"+xFilial("SBM")+"'"   
	
		oReport:Section(1):SetFilter(cCondicao,IndexKey())
#ENDIF		

//������������������������������������������������������������������������Ŀ
//�Filtra Notas de Saida para busca das devolucoes                         �
//��������������������������������������������������������������������������
cNomArq := CriaTrab("",.F.)
dbSelectArea("SD2")
cQueryD2 := "D2_FILIAL=='"+xFilial("SD2")+"'.And."
cQueryD2 += "Dtos(D2_EMISSAO)>='"+Dtos(MV_PAR01)+"'.And."
cQueryD2 += "Dtos(D2_EMISSAO)<='"+Dtos(MV_PAR02)+"'.And."
cQueryD2 += "D2_COD>='"+MV_PAR03+"'.And."
cQueryD2 += "D2_COD<='"+MV_PAR04+"'"    


		
If lF620Qry
	cQueryAdd := ExecBlock("F620QRY", .F., .F., {aReturn[7]})
	If ValType(cQueryAdd) == "C"
		cQueryD2 += " .AND. (" + cQueryAdd + ")"
	EndIf
EndIf 
IndRegua("SD2",cNomArq,"D2_FILIAL+D2_COD",,cQueryD2,STR0022)		//"Selecionando Registros "

//������������������������������������������������������������������������Ŀ
//�Filtra Devolucoes                                                       �
//��������������������������������������������������������������������������
If mv_par12 <> 3
	cNomArq1 := CriaTrab("",.F.)
	dbSelectArea("SD1")
	cQueryD1 := "D1_FILIAL=='"+xFilial("SD1")+"'"
	If mv_par12 == 2 //Devolucao pela Data de NF.Devolucao
		cQueryD1 += ".And. Dtos(D1_EMISSAO)>='"+Dtos(MV_PAR01)+"'.And."
		cQueryD1 +=       "Dtos(D1_EMISSAO)<='"+Dtos(MV_PAR02)+"'"
	EndIf
	IndRegua("SD1",cNomArq1,"D1_FILIAL+D1_COD+D1_NFORI+D1_SERIORI+D1_ITEMORI",,cQueryD1,STR0022)

EndIf

SF2->(DbSetOrder(1))

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()

If mv_par05 == 1
	oReport:Section(1):Cell("NTOTQUANT2"):Disable()
	oReport:Section(1):Cell("NTOTFAT2"):Disable()
Else
	oReport:Section(1):Cell("NTOTQUANT1"):Disable()
	oReport:Section(1):Cell("NTOTFAT1"):Disable()
EndIf

While !oReport:Cancel() .And. !(cAliasQry)->(Eof())
	//	���������������������������������������������Ŀ
	//	� Valida o produto conforme a mascara         �
	//	�����������������������������������������������
	lRet:=ValidMasc((cAliasQry)->C6_PRODUTO,MV_PAR06)
	If !lRet
		dbSelectArea(cAliasQry)
		dbSkip()
		Loop
	Endif
	If ( MV_PAR08==2.And.((cAliasQry)->C6_QTDVEN-(cAliasQry)->C6_QTDENT==0.Or.Alltrim((cAliasQry)->C6_BLQ)=="R"))
		dbSelectArea(cAliasQry)
		dbSkip()
		Loop
	EndIf
	cProd 	 := (cAliasQry)->C6_PRODUTO
	nTotQuant := nTotFat := nTotVal := nTotDesc := 0
	If (cAliasQry)->C6_GRADE == "S" .And. MV_PAR07 == 1
		cProd := Substr((cAliasQry)->C6_PRODUTO,1,nTamRef)
	Endif
	While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .AND. xFIlial("SC6")==(cAliasQry)->C6_FILIAL .And. IIF((cAliasQry)->C6_GRADE=="S".And.MV_PAR07==1,Substr((cAliasQry)->C6_PRODUTO,1,nTamRef),(cAliasQry)->C6_PRODUTO)==cProd
		oReport:IncMeter()
		lRet:=ValidMasc((cAliasQry)->C6_PRODUTO,MV_PAR06)
		cUM       := IIF( mv_par05 == 1, (cAliasQry)->C6_UM, (cAliasQry)->C6_SEGUM )
		If !lRet
			dbSelectArea(cAliasQry)
			dbSkip()
			Loop
		Endif
		If ( MV_PAR08==2.And.((cAliasQry)->C6_QTDVEN-(cAliasQry)->C6_QTDENT==0.Or.Alltrim((cAliasQry)->C6_BLQ)=="R"))
			dbSelectArea(cAliasQry)
			dbSkip()
			Loop
		EndIf
		//���������������������������������������������Ŀ
		//� Avalia TES a Ser Impresso                   �
		//�����������������������������������������������
		If !AvalTes((cAliasQry)->C6_TES,cEstoq,cDupli)
			dbSelectArea(cAliasQry)
			dbSkip()
			Loop
		Endif
		
		//��������������������������������������������������������������Ŀ
		//� Verifica se produto devera ser impresso                      �
		//����������������������������������������������������������������
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xFilial("SC5")+(cAliasQry)->C6_NUM)
		IF (C5_EMISSAO < mv_par01 .Or. C5_EMISSAO > mv_par02) .Or. C5_TIPO=="D"
			dbSelectArea(cAliasQry)
			dbSkip()
			Loop
		EndIF
		dbSelectArea(cAliasQry)
		IF mv_par05 == 2
			IF Empty((cAliasQry)->C6_SEGUM)
				dbSelectArea(cAliasQry)
				dbSkip()
				Loop
			Endif
		Endif
		nTotQuant += IIF( mv_par05 == 1, (cAliasQry)->C6_QTDVEN, (cAliasQry)->C6_UNSVEN )
		
		dbSelectArea(cAliasQry)
		nTotVal   += xMoeda((cAliasQry)->C6_VALOR,SC5->C5_MOEDA,MV_PAR09)
		nVlrDesc  := xMoeda((cAliasQry)->C6_PRUNIT-(cAliasQry)->C6_PRCVEN,SC5->C5_MOEDA,MV_PAR09)*((cAliasQry)->C6_QTDVEN-(cAliasQry)->C6_QTDENT)
		
		If ((cAliasQry)->C6_QTDVEN-(cAliasQry)->C6_QTDENT) = 0
			nTotDesc  += (cAliasQry)->C6_VALDESC
		Else
			nTotDesc  += IIF(nVlrDesc < 0.00, 0, nVlrDesc)
		Endif
		
		dbSelectArea(cAliasQry)
		dbSkip()
	EndDo
	dbSelectArea("SD2") // IndRegua()
	dbSeek(xFilial()+cProd)
	While ( !Eof() .And. xFilial("SD2")+cProd==SD2->D2_FILIAL+SubStr(SD2->D2_COD,1,Len(cProd)))
		If AvalTes(SD2->D2_TES,cEstoq,cDupli)
			SF2->(DbSeek(xFilial("SD2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA))
			If SF2->F2_TIPO<>"D"
				If mv_par12 <> 3 // inclui devolucao
					dbSelectArea("SD1")
					If mv_par12 == 1
						cChaveD := xFilial("SD1")+SD2->(D2_COD+D2_DOC+D2_SERIE)
					Else
						cChaveD := xFilial("SD1")+SD2->D2_COD
					EndIf
					dbSeek(cChaveD,.T.)
					While Subs(cChaveD,1,2+Len(D1_COD)) == D1_FILIAL + D1_COD .And. !Eof()
						If D1_TIPO == "D"
							If mv_par12 == 1 //Nf Original
								If SD2->(D2_DOC+D2_SERIE) == D1_NFORI+D1_SERIORI
									nTotFat    -= D1_QUANT
								EndIf
							Else // Pela Data da Devolucao
								nTotFat    -= D1_QUANT
							EndIf
						EndIf
						dbSkip()
					EndDo
					dbSelectArea("SD2")
				EndIf
				If D2_EMISSAO <= mv_par02 .And. D2_EMISSAO >= mv_par01
					nTotFat    += IIF( mv_par05 == 1, D2_QUANT, D2_QTSEGUM )
				Endif
			Endif
		EndIf
		dbSelectArea("SD2")
		dbSkip()
	EndDo
	
	If nTotQuant+nTotFat+nTotVal+nTotDesc # 0
		oReport:Section(1):PrintLine()
	EndIf		
	
	dbSelectArea(cAliasQry)
EndDo
oReport:Section(1):Finish()

dbSelectArea("SD2")
RetIndex("SD2")
dbSetOrder(1)
dbClearFilter()
If File(cNomArq+OrdBagExt())
	Ferase(cNomArq+OrdBagExt())
Endif

If mv_par12 <> 3
	dbSelectArea("SD1")
	RetIndex("SD1")
	dbSetOrder(1)
	dbClearFilter()
	If File(cNomArq1+OrdBagExt())
		Ferase(cNomArq1+OrdBagExt())
	EndIf
Endif


Return


/*/
�����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� DATA   � BOPS �Prograd.�ALTERACAO                                      ���
��������������������������������������������������������������������������Ĵ��
���08.09.98�17588A�Eduardo �Acerto na impressao do Codigo do Produto       ���
���08.09.98�      �Eduardo �Inclusao da Pergunta mv_par08                  ���
���30.03.99�      �Edson   �Passar o tamanho na Setprint.                  ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR620  � Autor � Paulo Boschetti       � Data � 27.04.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao Vendas por Produto                                 ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR620(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function xxMatr620R()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL CbTxt
LOCAL CbCont,cabec1,cabec2,wnrel
LOCAL titulo := OemToAnsi(STR0001)	//"Relacao de Pedidos por Produto"
LOCAL cDesc1 := OemToAnsi(STR0002)	//"Este relatorio ira emitir a relacao de Vendas por"
LOCAL cDesc2 := OemToAnsi(STR0003)	//"ordem de Produto."
LOCAL cDesc3 := ""
LOCAL tamanho:= "M"
LOCAL limite := 132
LOCAL cString:= "SC6"
LOCAL lContinua := .T.,nVlrDesc:=0
LOCAL nTotGer:=nTotQuant:=nTotProd:=nTotVend:=nTotDesc:=nTotGDesc:=0
LOCAL nTotQtdGer:=nTotFatGer:=0
LOCAL cUM := "  "
LOCAL cMascara :=GetMv("MV_MASCGRD")
LOCAL nTamRef  :=Val(Substr(cMascara,1,2))
LOCAL nTamLin  :=Val(Substr(cMascara,4,2))
LOCAL nTamCol  :=Val(Substr(cMascara,7,2))

PRIVATE aReturn := { STR0004, 1,STR0005, 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="MATR620"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="MTR620"
//������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape  �
//��������������������������������������������������������������
cbtxt    := Space(10)
cbcont   := 00
li       := 80
m_pag    := 01

//�������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                          �
//���������������������������������������������������������������
AjustaSX1()
pergunte("MTR620",.F.)
//�������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                        �
//� mv_par01  // A partir da data                               �
//� mv_par02  // Ate a data                                     �
//� mv_par03  // Produto de                                     �
//� mv_par04  // Produto ate                                    �
//� mv_par05  // 1a. ou 2a. Unidade de Medida                   �
//� mv_par06  // Mascara                                        �
//� mv_par07  // Aglutina Grade (S/N)                           �
//� mv_par08  // Considera Entregues? sim/nao                   �
//� mv_par09  // Moedas ?													 �
//� mv_par10  // TES Qto Faturamento                      		 �
//� mv_par11  // TES Qto Estoque                          		 �
//� mv_par12  // Qto a Devolucao  NF Origem   NF Devolucao  Nao �
//���������������������������������������������������������������
//�������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                       �
//���������������������������������������������������������������
wnrel := "MATR620"

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif      


RptStatus({|lEnd| C620Imp(@lEnd,wnRel,cString)},Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C620IMP  � Autor � Rosane Luciane Chene  � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR620			                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function C620Imp(lEnd,WnRel,cString)
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL CbTxt
LOCAL CbCont,cabec1,cabec2
LOCAL titulo := OemToAnsi(STR0001)	//"Relacao de Pedidos por Produto"
LOCAL tamanho:= "M"
LOCAL lContinua := .T.,nVlrDesc:=0
LOCAL nTotGer:=nTotQuant:=nTotProd:=nTotVend:=nTotDesc:=nTotGDesc:=0
LOCAL nTotQtdGer:=nTotFatGer:=0
LOCAL cUM := "  "
LOCAL cMascara :=GetMv("MV_MASCGRD")
LOCAL nTamRef  :=Val(Substr(cMascara,1,2))
Local cQueryD2 := "", cChaveD := "", cQueryD1 := ""
LOCAL cDupli	:= If( (MV_PAR10 == 1),"S",If( (MV_PAR10 == 2),"N","SN" ) )
LOCAL cEstoq	:= If( (MV_PAR11 == 1),"S",If( (MV_PAR11 == 2),"N","SN" ) )
Local cNomArq	:= cNomArq1 := ""       
Local lF620Qry  := ExistBlock("F620QRY")  
Local cQueryAdd := ""
//������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape  �
//��������������������������������������������������������������
cbtxt    := Space(10)
cbcont   := 00
li       := 80
m_pag    := 01
//��������������������������������������������������������������Ŀ
//� Definicao dos cabecalhos                                     �
//����������������������������������������������������������������
titulo := STR0006	//"RELACAO DE VENDAS POR PRODUTO"
cabec1 := STR0007	//"CODIGO          DENOMINACAO                           QUANTIDADE       QUANTIDADE UN          DESCONTO             VALOR"
cabec2 := STR0008	//"PRODUTO                                                  VENDIDA         FATURADA                                  TOTAL"

nTipo:=IIF(aReturn[4]==1,15,18)

cNomArq := CriaTrab("",.F.)
dbSelectArea("SD2")
cQueryD2 := "D2_FILIAL=='"+xFilial("SD2")+"'.And."
cQueryD2 += "Dtos(D2_EMISSAO)>='"+Dtos(MV_PAR01)+"'.And."
cQueryD2 += "Dtos(D2_EMISSAO)<='"+Dtos(MV_PAR02)+"'.And."
cQueryD2 += "D2_COD>='"+MV_PAR03+"'.And."
cQueryD2 += "D2_COD<='"+MV_PAR04+"'"        
		
If lF620Qry
	cQueryAdd := ExecBlock("F620QRY", .F., .F., {aReturn[7]})
	If ValType(cQueryAdd) == "C"
		cQueryD2 += " .AND. (" + cQueryAdd + ")"
	EndIf
EndIf 

IndRegua("SD2",cNomArq,"D2_FILIAL+D2_COD",,cQueryD2,STR0009)		//"Selecionando Registros "

If mv_par12 <> 3
	cNomArq1 := CriaTrab("",.F.)
	dbSelectArea("SD1")
	cQueryD1 := "D1_FILIAL=='"+xFilial("SD1")+"'"
	If mv_par12 == 2 //Devolucao pela Data de NF.Devolucao
		cQueryD1 += ".And. Dtos(D1_EMISSAO)>='"+Dtos(MV_PAR01)+"'.And."
		cQueryD1 +=       "Dtos(D1_EMISSAO)<='"+Dtos(MV_PAR02)+"'"
	EndIf
	IndRegua("SD1",cNomArq1,"D1_FILIAL+D1_COD+D1_NFORI+D1_SERIORI+D1_ITEMORI",,cQueryD1,STR0009)
EndIf

SF2->(DbSetOrder(1))

dbSelectArea("SC6")
dbSetOrder(2)
Set SoftSeek On
dbSeek(cFilial+mv_par03)
Set SoftSeek Off

SetRegua(RecCount())		// Total de Elementos da regua

While !EOF() .And. lContinua .And. C6_PRODUTO >= mv_par03 .And. C6_PRODUTO <= mv_par04 .and. cFilial = C6_FILIAL
	//	���������������������������������������������Ŀ
	//	� Valida o produto conforme a mascara         �
	//	�����������������������������������������������
	lRet:=ValidMasc(SC6->C6_PRODUTO,MV_PAR06)
	If !lRet
		dbSkip()
		Loop
	Endif
	If ( MV_PAR08==2.And.(SC6->C6_QTDVEN-SC6->C6_QTDENT==0 .Or. Alltrim(SC6->C6_BLQ)=="R"))
		dbSkip()
		Loop
	EndIf
	cProd := C6_PRODUTO
	nTotQuant := nTotFat := nTotVal := nTotDesc := 0
	If C6_GRADE == "S" .And. MV_PAR07 == 1
		cProd := Substr(C6_PRODUTO,1,nTamRef)
	Endif
	While !Eof() .AND. cFilial==C6_FILIAL .And. IIF(C6_GRADE=="S".And.MV_PAR07==1,Substr(C6_PRODUTO,1,nTamRef),C6_PRODUTO)==cProd
		IncRegua()
		lRet:=ValidMasc(SC6->C6_PRODUTO,MV_PAR06)
		If !lRet
			dbSkip()
			Loop
		Endif
		If ( MV_PAR08==2.And.(SC6->C6_QTDVEN-SC6->C6_QTDENT==0.Or.Alltrim(SC6->C6_BLQ)=="R"))
			dbSkip()
			Loop
		EndIf
		//���������������������������������������������Ŀ
		//� Avalia TES a Ser Impresso                   �
		//�����������������������������������������������
		If !AvalTes(C6_TES,cEstoq,cDupli)
			dbSkip()
			Loop
		Endif

		If lEnd
			@PROW()+1,001 Psay STR0010		//"CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		Endif
		//��������������������������������������������������������������Ŀ
		//� Verifica se produto devera ser impresso                      �
		//����������������������������������������������������������������
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(cFilial+SC6->C6_NUM)
		IF (C5_EMISSAO < mv_par01 .Or. C5_EMISSAO > mv_par02) .Or. C5_TIPO=="D"
			dbSelectArea("SC6")
			dbSkip()
			Loop
		EndIF
		dbSelectArea("SC6")
		IF mv_par05 == 2
			IF Empty(C6_SEGUM)
				dbSkip()
				Loop
			Endif
		Endif
		nTotQuant += IIF( mv_par05 == 1, C6_QTDVEN, C6_UNSVEN )
		nTotQtdGer+= IIF( mv_par05 == 1, C6_QTDVEN, C6_UNSVEN )
		dbSelectArea("SC6")
		nTotVal   += xMoeda(C6_VALOR,SC5->C5_MOEDA,MV_PAR09)
		nTotGer   += xMoeda(C6_VALOR,SC5->C5_MOEDA,MV_PAR09)
		nVlrDesc  := xMoeda(C6_PRUNIT-C6_PRCVEN,SC5->C5_MOEDA,MV_PAR09)*(C6_QTDVEN-C6_QTDENT)

        If (C6_QTDVEN-C6_QTDENT) = 0
     		nTotDesc  += C6_VALDESC 
        Else
	    	nTotDesc  += IIF(nVlrDesc < 0.00, 0, nVlrDesc)
        Endif          

		cUM       := IIF( mv_par05 == 1, C6_UM, C6_SEGUM )
		dbSelectArea("SC6")
		dbSkip()
	EndDo
	dbSelectArea("SD2") // IndRegua()
	dbSeek(xFilial()+cProd)
	While ( !Eof() .And. xFilial("SD2")+cProd==SD2->D2_FILIAL+SubStr(SD2->D2_COD,1,Len(cProd)))
		If AvalTes(SD2->D2_TES,cEstoq,cDupli)
			SF2->(DbSeek(xFilial("SD2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA))
			If SF2->F2_TIPO<>"D"
				If mv_par12 <> 3 // inclui devolucao
					dbSelectArea("SD1")
					If mv_par12 == 1
						cChaveD := xFilial("SD1")+SD2->(D2_COD+D2_DOC+D2_SERIE)
					Else
						cChaveD := xFilial("SD1")+SD2->D2_COD
					EndIf
					dbSeek(cChaveD,.T.)
					While Subs(cChaveD,1,2+Len(D1_COD)) == D1_FILIAL + D1_COD .And. !Eof()
						If D1_TIPO == "D"
							If mv_par12 == 1 //Nf Original
								If SD2->(D2_DOC+D2_SERIE) == D1_NFORI+D1_SERIORI
									nTotFat    -= D1_QUANT
									nTotFatGer -= D1_QUANT
								EndIf
							Else // Pela Data da Devolucao
								nTotFat    -= D1_QUANT
								nTotFatGer -= D1_QUANT
							EndIf
						EndIf
						dbSkip()
					EndDo
					dbSelectArea("SD2")
				EndIf	
				If D2_EMISSAO <= mv_par02 .And. D2_EMISSAO >= mv_par01
					nTotFat    += IIF( mv_par05 == 1, D2_QUANT, D2_QTSEGUM )
					nTotFatGer += IIF( mv_par05 == 1, D2_QUANT, D2_QTSEGUM )
				Endif
			Endif
		EndIf
		dbSelectArea("SD2")
		dbSkip()
	EndDo
	nTotGDesc  += nToTDesc
	IF li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	If nTotQuant+nTotFat+nTotVal+nTotDesc # 0
		dbSelectArea("SB1")
		dbSeek(cFilial+cProd)
		@li,  0 Psay cProd
		@li, 16 Psay Substr(B1_DESC,1,30)
		@li, 47 Psay nTotQuant	  Picture IIF( mv_par05 == 1, PesqPict("SC6","C6_QTDVEN",19), PesqPict("SC6","C6_UNSVEN",19) )
		@li, 67 Psay nTotFat	     PicTure IIF( mv_par05 == 1, PesqPict("SC6","C6_QTDVEN",19), PesqPict("SC6","C6_UNSVEN",19) )
		@li, 87 Psay cUM
		@li, 90 Psay nTotDesc      Picture PesqPict("SC6","C6_PRUNIT",20)
		@li,111 Psay nTotVal       Picture PesqPict("SC6","C6_VALOR",21)
		Li++
	EndIf
	dbSelectArea("SC6")
EndDo
IF li != 80
	li++
	@li,  0 Psay STR0011	//"T O T A L  G E R A L : "
	@li, 47 Psay nTotQtdGer   Picture Tm(nTotQtdGer,19)
	@li, 67 Psay nTotFatGer   Picture Tm(nTotFatGer,19)
	@li, 90 Psay nTotGDesc    Picture Tm(nTotGDesc,20)
	@li,111 Psay nTotGer      Picture Tm(nTotGer,21)
	roda(cbcont,cbtxt)
EndIF

dbSelectArea("SD2")
RetIndex("SD2")
dbSetOrder(1)
dbClearFilter()
If File(cNomArq+OrdBagExt())
	Ferase(cNomArq+OrdBagExt())
Endif

If mv_par12 <> 3
	dbSelectArea("SD1")
	RetIndex("SD1")
	dbSetOrder(1)
	dbClearFilter()
	If File(cNomArq1+OrdBagExt())
		Ferase(cNomArq1+OrdBagExt())
	EndIf
Endif

dbSelectArea("SC6")
dbClearFilter()
dbSetOrder(1)


If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX1 �Autor  �                    � Data � 06/04/2006  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1()
If cPaisLoc<>"BRA"
	SX1->(dbSetOrder(1))
	If SX1->(DbSeek("MTR62001"))
		RecLock("SX1",.F.)
		Replace SX1->X1_PERSPA With "�De Fecha ?"
		Replace SX1->X1_PERENG With "From Date ?"
		SX1->(MsUnLock())
		SX1->(DbCommit())
	Endif
Endif
Return
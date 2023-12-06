#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"
/*
*****************************************************************
* Programa    : STFAT59A                                      	*
* Data Criação: 18/08/2022                                      *
* Autor       : Rogério Costa | CRM Services               		*
* Cliente     : Steck                                           *
*****************************************************************
* Detalhes    : Geração de arquivo *.CSV do cadastro de  		*
*			  : produtos para envio a empresa Juntos Somos+		*
*****************************************************************
*/

User Function STFAT59A(cEmp,cFil)

	Local cNomeArquivo 	:= "OM_TXT_Material_"+FWTimeStamp()+".csv"

	Private lSchedule := .F.

	Default cEmp 	:=	'11'
	Default cFil 	:=	'01'

	cEmp 	:=	'11'
	cFil 	:=	'01'

	If Select("SX3") == 0            // Verifico se está sendo chamada por Schedule
		lSchedule := .T.
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT" TABLES "SB1"
	EndIf

	Conout("Inicio da execução da rotina STFAT59A na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

	Processa({|| CSVPROD(cNomeArquivo)}, "Gerando as informações")

	Conout("Término da execução da rotina STFAT59A na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

	If lSchedule
		RESET ENVIRONMENT
	Endif

Return

/*
************************************************************************
* Função que processa as informações e gera o arquivo conforme layout  *
************************************************************************
*/
Static Function CSVPROD(cArquivo)

	Local cQuery 	:= ' '
	Local cAlias 	:= ' '
	Local nFator	:= 0

	Private cLocArq := SuperGetMv("STFAT591",.F.,"\arquivos\SFTP-INTEGRAÇÕES\JUNTOS\PENDING")

	cQuery := " SELECT B1_COD, B1_DESC, BM_DESC, B1_XFATOR FATOR" + CRLF
	cQuery += " FROM "+RetSqlName("DA1") + " DA1, " +RetSqlName("SB1") + " SB1 " + CRLF
	cQuery += " 	LEFT JOIN "+RetSqlName("SBM") + " SBM "		+ CRLF
	cQuery += " 	ON BM_GRUPO = B1_GRUPO" 					+ CRLF
	cQuery += " 	AND SBM.D_E_L_E_T_ =' '"					+ CRLF
	cQuery += " WHERE DA1.DA1_CODPRO = SB1.B1_COD "				+ CRLF
	cQuery += "  	AND DA1.DA1_CODTAB = '001' "				+ CRLF
	cQuery += "  	AND DA1.D_E_L_E_T_ = ' '"					+ CRLF
	cQuery += " 	AND SB1.D_E_L_E_T_=' '"                 	+ CRLF

	TCQuery cQuery  New Alias (cAlias:=GetNextAlias())

	dbSelectArea(cAlias)

	(cAlias)->(dbGoTop())

	oFWriter := FWFileWriter():New(cLocArq +"\"+ cArquivo, .T.)
	oFWriter:SetCaseSensitive(.T.)

	If ! oFWriter:Create()
		Conout("Houve um erro ao gerar o arquivo: " + CRLF + oFWriter:Error():Message)
	Else
		While !(cAlias)->(Eof())

			nFator := If(Val((cAlias)->FATOR)== 0,"0.00",(cAlias)->FATOR)

			oFWriter:Write(AllTrim((cAlias)->B1_COD)	+";"+;//1-Identificador único do produto.
			'"'+AllTrim((cAlias)->B1_DESC)+'"'+";"+;//2-Descrição
			'"'+AllTrim((cAlias)->BM_DESC)+'"'+";"+;//3-Familia/Grupo
			AllTrim(cValToChar(nFator))+ CRLF)		  //4-Fator de conversao

			(cAlias)->(dbSkip())
		EndDo

		oFWriter:Close()

		(cAlias)->(dbCloseArea())

	EndIf
Return

/*
*****************************************************************
* Programa    : STFAT59B                                      	*
* Data Criação: 18/08/2022                                      *
* Autor       : Rogério Costa | CRM Services               		*
* Cliente     : Steck                                           *
*****************************************************************
* Detalhes    : Geração de arquivo *.CSV do cadastro de  		*
*			  : regiao de vendas para envio a empresa 			*
*			  : Juntos Somos+									*
*****************************************************************
*/

User Function STFAT59B(cEmpresa,cFililial)

	Local cNomeArquivo 	:= "OM_TXT_Reg_vendas_"+FWTimeStamp()+".csv"

	Private lSchedule := .F.

	Default cEmp 	:=	'11'
	Default cFil 	:=	'01'

	cEmp 	:=	'11'
	cFil 	:=	'01'

	If Select("SX3") == 0            // Verifico se está sendo chamada por Schedule
		lSchedule := .T.
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT"
	EndIf

	Conout("Inicio da execução da rotina STFAT59B na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

	Processa({|| CSVREG(cNomeArquivo)}, "Gerando as informações")

	Conout("Término da execução da rotina STFAT59B na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

	If lSchedule
		RESET ENVIRONMENT
	Endif

Return

/*
************************************************************************
* Função que processa as informações e gera o arquivo conforme layout  *
************************************************************************
*/
Static Function CSVREG(cArquivo)

	Local aDados	:= {}
	Local n			:= 0

	Private cLocArq := SuperGetMv("STFAT591",.F.,"\arquivos\SFTP-INTEGRAÇÕES\JUNTOS\PENDING")

	aDados := FWGetSX5("A2")

	oFWriter := FWFileWriter():New(cLocArq +"\"+ cArquivo, .T.)
	oFWriter:SetCaseSensitive(.T.)

	//Se houve falha ao criar, mostra a mensagem
	If ! oFWriter:Create()
		Conout("Houve um erro ao gerar o arquivo: " + CRLF + oFWriter:Error():Message)
	Else

		For n := 1 To Len(aDados)
			//Pega a chave e o conteúdo
			cChave    := aDados[n][3]
			cConteudo := aDados[n][4]
			oFWriter:Write(AllTrim(cChave)+";"+AllTrim(cConteudo)+ CRLF)
		Next n

		//Encerra o arquivo
		oFWriter:Close()
	EndIf

Return

/*
*****************************************************************
* Programa    : STFAT59C                                      	*
* Data Criação: 18/08/2022                                      *
* Autor       : Rogério Costa | CRM Services               		*
* Cliente     : Steck                                           *
*****************************************************************
* Detalhes    : Geração de arquivo *.CSV do cadastro de  		*
*			  : escritório de vendas para envio a empresa 		*
*			  : Juntos Somos+									*
*****************************************************************
*/

User Function STFAT59C(cEmpresa,cFililial)

	Local cNomeArquivo 	:= "OM_TXT_Escr_vendas_"+FWTimeStamp()+".csv"

	Private lSchedule := .F.

	Default cEmp 	:=	'11'
	Default cFil 	:=	'01'

	cEmp 	:=	'11'
	cFil 	:=	'01'

	If Select("SX3") == 0            // Verifico se está sendo chamada por Schedule
		lSchedule := .T.
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT"
	EndIf

	Conout("Inicio da execução da rotina STFAT59C na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

	Processa({|| CSVESCR(cNomeArquivo)}, "Gerando as informações")

	Conout("Término da execução da rotina STFAT59C na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

	If lSchedule
		RESET ENVIRONMENT
	Endif

Return

/*
************************************************************************
* Função que processa as informações e gera o arquivo conforme layout  *
************************************************************************
*/
Static Function CSVESCR(cArquivo)

	Local aInfSM0 	:= FWLoadSM0()
	Local n			:= 0

	Private cLocArq := SuperGetMv("STFAT591",.F.,"\arquivos\SFTP-INTEGRAÇÕES\JUNTOS\PENDING")

	oFWriter := FWFileWriter():New(cLocArq +"\"+ cArquivo, .T.)
	oFWriter:SetCaseSensitive(.T.)

	//Se houve falha ao criar, mostra a mensagem
	If ! oFWriter:Create()
		Conout("Houve um erro ao gerar o arquivo: " + CRLF + oFWriter:Error():Message)
	Else
		For n:=1 To Len(aInfSM0)
			oFWriter:Write(AllTrim(aInfSM0[n][1])+Alltrim(aInfSM0[n][2])+";"+AllTrim(aInfSM0[n][21])+ CRLF)
		Next n

		//Encerra o arquivo
		oFWriter:Close()

	EndIf

Return

/*
*****************************************************************
* Programa    : STFAT59D                                      	*
* Data Criação: 18/08/2022                                      *
* Autor       : Rogério Costa | CRM Services               		*
* Cliente     : Steck                                           *
*****************************************************************
* Detalhes    : Geração de arquivo *.CSV do cadastro de  		*
*			  : vendedores  para envio a empresa Juntos Somos+	*
*****************************************************************
*/

User Function STFAT59D(cEmpresa,cFililial)

	Local cNomeArquivo 	:= "OM_TXT_Coord_Vend_"+FWTimeStamp()+".csv"

	Private lSchedule 	:= .F.

	Default cEmp	  	:= '11'
	Default cFil	  	:= '01'

	cEmp	  	:= '11'
	cFil	  	:= '01'

	If Select("SX3") == 0            // Verifico se está sendo chamada por Schedule
		lSchedule := .T.
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT"
	EndIf

	Conout("Inicio da execução da rotina STFAT59D na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

	Processa({|| CSVVEND(cNomeArquivo)}, "Gerando as informações")

	Conout("Término da execução da rotina STFAT59D na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

	If lSchedule
		RESET ENVIRONMENT
	Endif

Return

/*
************************************************************************
* Função que processa as informações e gera o arquivo conforme layout  *
************************************************************************
*/
Static Function CSVVEND(cArquivo)

	Local cQuery 	:= ' '
	Local cAlias 	:= ' '
	Private cLocArq := SuperGetMv("STFAT591",.F.,"\arquivos\SFTP-INTEGRAÇÕES\JUNTOS\PENDING")

	cQuery := " SELECT A3_COD, A3_NOME, A3_CGC, A3_EMAIL, A3_DDDTEL, A3_TEL" + CRLF
	cQuery += " FROM " + RetSqlName("SA3") 									 + CRLF
	//cQuery += " WHERE  SUBSTRING(A3_COD,1,1) <>  'R'	AND		"			 + CRLF
	cQuery += " WHERE  	"			 										 + CRLF	
	cQuery += "  	D_E_L_E_T_=' '"											 + CRLF
	cQuery += " ORDER BY A3_COD"											 + CRLF

	cQuery := ChangeQuery(cQuery)

	TCQuery cQuery  New Alias (cAlias:=GetNextAlias())

	dbSelectArea(cAlias)

	(cAlias)->(dbGoTop())

	oFWriter := FWFileWriter():New(cLocArq +"\"+ cArquivo, .T.)
	oFWriter:SetCaseSensitive(.T.)

	//Se houve falha ao criar, mostra a mensagem
	If ! oFWriter:Create()
		Conout("Houve um erro ao gerar o arquivo: " + CRLF + oFWriter:Error():Message)
	Else

		While !(cAlias)->(Eof())
			oFWriter:Write(AllTrim((cAlias)->A3_COD)	+";"+;	//1-codigo
			AllTrim((cAlias)->A3_NOME)	+";"+;	//2-nome
			AllTrim((cAlias)->A3_CGC)	+";"+;	//3-CPF
			AllTrim((cAlias)->A3_EMAIL)	+";"+;	//4-Email
			""							+";"+;	//5-DDD
			""							+ CRLF)	//6-TELEFONE

			(cAlias)->(dbSkip())
		EndDo

		//Encerra o arquivo
		oFWriter:Close()

		(cAlias)->(dbCloseArea())
	EndIf

Return


/*
*****************************************************************
* Programa    : STFAT59E                                      	*
* Data Criação: 18/08/2022                                      *
* Autor       : Rogério Costa | CRM Services               		*
* Cliente     : Steck                                           *
*****************************************************************
* Detalhes    : Geração de arquivo *.CSV do cadastro de  		*
*			  : cliente  para envio a empresa Juntos Somos+		*
*****************************************************************
*/

User Function STFAT59E(cEmpresa,cFililial)

	Local cNomeArquivo 	:= "OM_Cad_clientes_"+FWTimeStamp()+".csv"

	Private lSchedule 	:= .F.

	Default cEmp		:= '11'
	Default cFil		:= '01'

	cEmp		:= '11'
	cFil		:= '01'

	If Select("SX3") == 0            // Verifico se está sendo chamada por Schedule
		lSchedule := .T.
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT"
	EndIf

	Conout("Inicio da execução da rotina STFAT59E na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

	Processa({|| CSVCLI(cNomeArquivo)}, "Gerando as informações")

	Conout("Término da execução da rotina STFAT59E na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

	If lSchedule
		RESET ENVIRONMENT
	Endif


Return

/*
************************************************************************
* Função que processa as informações e gera o arquivo conforme layout  *
************************************************************************
*/
Static Function CSVCLI(cArquivo)

	Local cQuery 	:= ' '
	Local cAlias 	:= ' '
	Local cEnd	 	:= ' '
	Local cDocto	:= ' '

	Private cLocArq := SuperGetMv("STFAT591",.F.,"\arquivos\SFTP-INTEGRAÇÕES\JUNTOS\PENDING")

	cQuery := " SELECT A1_COD,A1_LOJA,A1_PESSOA, A1_NOME, A1_MUN,  A1_GRPVEN , A1_REGIAO, A1_XJUNTOS, " + CRLF
	cQuery += " A1_COD_MUN, A1_TEL, A1_CEP, A1_EST,A1_END," + CRLF
	cQuery += " A1_CGC, A1_BAIRRO, A1_TEL, A1_DDD,A1_EMAIL " + CRLF
	cQuery += " FROM "+RetSqlName("SA1") + " SA1 "    + CRLF
	cQuery += " WHERE D_E_L_E_T_=' '"                 + CRLF

	TCQuery cQuery  New Alias (cAlias:=GetNextAlias())

	dbSelectArea(cAlias)

	(cAlias)->(dbGoTop())

	oFWriter := FWFileWriter():New(cLocArq +"\"+ cArquivo, .T.)
	oFWriter:SetCaseSensitive(.T.)

	//Se houve falha ao criar, mostra a mensagem
	If ! oFWriter:Create()
		Conout("Houve um erro ao gerar o arquivo: " + CRLF + oFWriter:Error():Message)
	Else
		While !(cAlias)->(Eof())

			cEnd := StrTran((cAlias)->A1_END,',',' ')
			cDocto := StrZero(Val((cAlias)->A1_CGC),14)

			oFWriter:Write(AllTrim((cAlias)->(A1_COD+A1_LOJA))		+";"+;	//	1	Código ERP	NOT NULL / UNIQUE
			AllTrim((cAlias)->A1_NOME)  							+";"+;	//	2	Razão social	NOT NULL
			AllTrim((cAlias)->A1_MUN)  								+";"+;	//	3	Cidade	NULL
			AllTrim((cAlias)->A1_GRPVEN)							+";"+;	//	4	Grupo de segmentos	NULL
			AllTrim((cAlias)->A1_REGIAO)							+";"+;	//	5	Região de negócios	NULL
			AllTrim((cAlias)->A1_COD_MUN)							+";"+;	//	6	Código do município	NULL
			''              										+";"+;	//	7	-	NULL
			''	 													+";"+;	//	8	Telefone fixo PRINCIPAL da loja	NULL
			AllTrim((cAlias)->A1_CEP) 								+";"+;	//	9	Código postal (CEP)	NULL
			AllTrim((cAlias)->A1_EST) 	 							+";"+;	//	10	Abreviação da unidade federativa	NULL
			''              										+";"+;	//	11	-	NULL
			AllTrim(cEnd)			  								+";"+;	//	12	Nome da rua com número e complemento	NULL
			AllTrim(cDocto)			  								+";"+;	//	13	CNPJ da loja	NOT NULL / UNIQUE
			AllTrim((cAlias)->A1_BAIRRO)  							+";"+;	//	14	Bairro	NULL
			'' 														+";"+;	//	15	Telefone celular PRINCIPAL do comprador da loja	NULL
			''													 	+";"+;	//	16	Telefone celular de um contato da loja	NULL
			''              										+";"+;	//	17	CNPJ da loja matriz	NULL
			''              										+";"+;	//	18	Data de cadastro da loja na empresa	NULL
			''							 							+";"+;	//	19	E-mail de um contato da loja	NULL
			'' 														+";"+;	//	20	E-mail PRINCIPAL da loja	NULL
			'' 							 							+";"+;	//	21	NULL
			AllTrim(IIf(Empty((cAlias)->A1_XJUNTOS),"N",(cAlias)->A1_XJUNTOS))							+";"+;	//	22	Segmento	NOT NULL -- TRATATIVA PARA ENVIO OU NÃO DO CLIENTE
			'' 							 							+";"+;	//	23	NULL
			''              										+";"+;	//	24	Mesorregião da loja	NULL
			''              										+";"+;	//	25	Microrregião da loja	NULL
			''              										+";"+;	//	26	Microsegmento	NULL
			''              										+";"+;	//	27	Grupo centralizador	NULL
			''							 							+";"+;	//	28	E-mail do comprador da loja	NULL
			'' 														+CRLF) 	//  29  Telefone celular PRINCIPAL da loja

			(cAlias)->(dbSkip())
		EndDo

		//Encerra o arquivo
		oFWriter:Close()

		(cAlias)->(dbCloseArea())

	EndIf

Return

/*
*****************************************************************
* Programa    : STFAT59F                                      	*
* Data Criação: 18/08/2022                                      *
* Autor       : Rogério Costa | CRM Services               		*
* Cliente     : Steck                                           *
*****************************************************************
* Detalhes    : Geração de arquivo *.CSV da relação entre  		*
*			  : cliente e vendedor para envio a empresa 		*
*			  : Juntos Somos+									*
*****************************************************************
*/

User Function STFAT59F(cEmpresa,cFililial)

	Local cNomeArquivo 	:= "OM_Rel_cli_vend_"+FWTimeStamp()+".csv"

	Private lSchedule 	:= .F.

	Default cEmp		:= '11'
	Default cFil		:= '01'

	cEmp		:= '11'
	cFil		:= '01'

	If Select("SX3") == 0            // Verifico se está sendo chamada por Schedule
		lSchedule := .T.
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT"
	EndIf

	Conout("Inicio da execução da rotina STFAT59F na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

	Processa({|| CSVCLVEND(cNomeArquivo)}, "Gerando as informações")

	Conout("Término da execução da rotina STFAT59F na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

	If lSchedule
		RESET ENVIRONMENT
	Endif


Return

/*
************************************************************************
* Função que processa as informações e gera o arquivo conforme layout  *
************************************************************************
*/
Static Function CSVCLVEND(cArquivo)

	Local 	cQuery 		:= ' '
	Local 	cEscritorio	:= ' '
	Local 	cAlias 		:= ' '
	Private cLocArq 	:= SuperGetMv("STFAT591",.F.,"\arquivos\SFTP-INTEGRAÇÕES\JUNTOS\PENDING")

	cQuery := " SELECT A1_COD,A1_LOJA, A3_COD, A3_GEREN, A3_SUPER, A1_REGIAO " 				+ CRLF
	cQuery += " FROM "+RetSqlName("SA1") + " SA1, " +RetSqlName("SA3") + " SA3 "    + CRLF
	cQuery += " WHERE A1_VEND = A3_COD"												+ CRLF
	cQuery += " AND SUBSTRING(A3_COD,1,1) <>  'R'"						 + CRLF
	cQuery += " AND SA1.D_E_L_E_T_=' '"                 							+ CRLF
	cQuery += " AND SA3.D_E_L_E_T_=' '"                 							+ CRLF

	cQuery := ChangeQuery(cQuery)

	TCQuery cQuery  New Alias (cAlias:=GetNextAlias())

	dbSelectArea(cAlias)

	(cAlias)->(dbGoTop())

	oFWriter := FWFileWriter():New(cLocArq +"\"+ cArquivo, .T.)
	oFWriter:SetCaseSensitive(.T.)

	//Se houve falha ao criar, mostra a mensagem
	If ! oFWriter:Create()
		Conout("Houve um erro ao gerar o arquivo: " + CRLF + oFWriter:Error():Message)
	Else
		While !(cAlias)->(Eof())

			cEscritorio := AllTrim(cEmp)+Alltrim(cFil)

			oFWriter:Write(AllTrim((cAlias)->(A1_COD+A1_LOJA))	+";"+;//	1 Cliente (Código ERP do Cadastro de Clientes)
			''											+";"+;//	2 Deixar em branco
			''						  					+";"+;//	3 Deixar em branco
			''						  					+";"+;//	4 Deixar em branco
			AllTrim((cAlias)->A3_COD)   				+";"+;//	5 Vendedor (Código ERP de Funcionários)
			AllTrim((cAlias)->A3_GEREN) 				+";"+;//    6 Gerente (Código ERP de Funcionários)
			Alltrim(cEscritorio)						+";"+;//	7 Escritório de vendas (Código ERP da Escritório de Vendas)
			AllTrim((cAlias)->A3_SUPER) 				+";"+;//  	8 Coordenador (Código ERP de Funcionários)
			AllTrim((cAlias)->A1_REGIAO)				+";"+;//  	9 Região de vendas (Código ERP da Região de Vendas)
			'' 											+ CRLF)//	10 Deixar em branco

			(cAlias)->(dbSkip())
		EndDo

		//Encerra o arquivo
		oFWriter:Close()

		(cAlias)->(dbCloseArea())
	EndIf

Return

/*
*****************************************************************
* Programa    : STFAT59G                                      	*
* Data Criação: 18/08/2022                                      *
* Autor       : Rogério Costa | CRM Services               		*
* Cliente     : Steck                                           *
*****************************************************************
* Detalhes    : Geração de arquivo *.CSV de faturamento  		*
*			  : para envio a empresa Juntos Somos+				*
*****************************************************************
*/

User Function STFAT59G(cEmpresa,cFililial)

	Local cNomeArquivo 	:= "OM_Faturamentos_"+FWTimeStamp()+".csv"
	Local cDataIni		:= 	''
	Local cDataFim		:= 	''
	
	Private lSchedule 	:= .F.

	Default	cEmp		:=	'11'
	Default	cFil		:=	'01'

	cEmp		:=	'11'
	cFil		:=	'01'

	If Select("SX3") == 0            // Verifico se está sendo chamada por Schedule
		lSchedule := .T.
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT"
	EndIf

	cDataIni	:= 	DtoS(FirstDate(dDataBase))
	cDataFim	:= 	DtoS(LastDate(dDataBase))

	Conout("Inicio da execução da rotina STFAT59G na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

	Processa({|| CSVFAT(cNomeArquivo,cDataIni,cDataFim)}, "Gerando as informações")

	Conout("Término da execução da rotina STFAT59G na empresa: "+FwCodEmp()+" Filial: "+FwCodFil()+" as "+Time())

	If lSchedule
		RESET ENVIRONMENT
	Endif

Return

/*
************************************************************************
* Função que processa as informações e gera o arquivo conforme layout  *
************************************************************************
*/
Static Function CSVFAT(cArquivo,cDataIni,cDataFim)

	Local cQuery 	:= ' '
	Local cAlias 	:= ' '
	Private cLocArq := SuperGetMv("STFAT591",.F.,"\arquivos\SFTP-INTEGRAÇÕES\JUNTOS\PENDING")

	cQuery += "       SELECT 'SP'                            AS EMPRESA,"    + CRLF
	cQuery += "              'C'                             AS MODALIDADE,"    + CRLF
	cQuery += "              f2_doc                          AS NOTA_FISCAL,"    + CRLF
	cQuery += "              f2_serie                        AS SERIE_FISCAL,"    + CRLF
	cQuery += "              Substr(f2_emissao, 7, 2)"    + CRLF
	cQuery += "              ||'/'"    + CRLF
	cQuery += "              ||Substr(f2_emissao, 5, 2)"    + CRLF
	cQuery += "              ||'/'"    + CRLF
	cQuery += "              ||Substr(f2_emissao, 1, 4)      AS EMISSAO,"    + CRLF
	cQuery += "              Substr(f2_emissao, 5, 2)"    + CRLF
	cQuery += "              ||'/'"    + CRLF
	cQuery += "              ||Substr(f2_emissao, 1, 4)      AS MES_ANO,"    + CRLF
	cQuery += "              d2_quant                        AS QUANTIDADE,"    + CRLF
	cQuery += "              d2_cod                          AS PRODUTO,"    + CRLF
	cQuery += "              SB1.b1_desc                     AS DESCRICAO,"    + CRLF
	cQuery += "              Nvl(bm_grupo, 'S/G')            AS GRUPO,"    + CRLF
	cQuery += "              Nvl(bm_desc, 'SEM GRUPO')       AS DESC_GRUPO,"    + CRLF
	cQuery += "              Nvl(Trim(TX5.x5_descri), 'N/A') AS AGRUPAMENTO,"    + CRLF
	cQuery += "              a1_grpven                       AS GRUPO_VENDAS,"    + CRLF
	cQuery += "              a1_cod                          AS CODIGO,"    + CRLF
	cQuery += "              a1_loja                         AS LOJA,"    + CRLF
	cQuery += "              a1_nome                         AS RAZAO_SOCIAL,"    + CRLF
	cQuery += "              a1_cgc                          AS CNPJ,"    + CRLF
	cQuery += "              a1_est                          AS ESTADO,"    + CRLF
	cQuery += "              a1_mun                          AS MUNICIPIO,"    + CRLF
	cQuery += "              a1_cod_mun                      AS CODIGO_MUNICIPIO,"    + CRLF
	cQuery += "              Trim(SX5.x5_descri)             AS REGIAO,"    + CRLF
	cQuery += "              SA3.a3_cod                      AS VENDEDOR,"    + CRLF
	cQuery += "              SA3.a3_nome                     AS NOME_VENDEDOR,"    + CRLF
	cQuery += "              TA3.a3_cod                      AS COORDENADOR,"    + CRLF
	cQuery += "              TA3.a3_nome                     AS NOME_COORDENADOR,"    + CRLF
	cQuery += "              CASE"    + CRLF
	cQuery += "                WHEN SB9.b9_cm1 <> 0 THEN Round(SB9.b9_cm1, 2)"    + CRLF
	cQuery += "                ELSE"    + CRLF
	cQuery += "                  CASE"    + CRLF
	cQuery += "                    WHEN TB9.b9_cm1 <> 0 THEN Round(TB9.b9_cm1, 2)"    + CRLF
	cQuery += "                    ELSE Round(SB1.b1_xpcstk, 2)"    + CRLF
	cQuery += "                  END"    + CRLF
	cQuery += "              END                             AS CUSTO,"    + CRLF
	cQuery += "              SD2.r_e_c_n_o_                  AS RECNO,"    + CRLF
	cQuery += "              SD2.d2_total                    AS BRUTO_FATURAMENTO,"    + CRLF
	cQuery += "              ( CASE"    + CRLF
	cQuery += "                  WHEN c5_xorig = '2' THEN 'MKP'"    + CRLF
	cQuery += "                  WHEN c5_xorig = '3' THEN 'EDI'"    + CRLF
	cQuery += "                  WHEN c5_xorig = '1' THEN 'PORTAL'"    + CRLF
	cQuery += "                  ELSE ' '"    + CRLF
	cQuery += "                END )                         ORIGEM"    + CRLF
	cQuery += "       FROM   sd2110 SD2"    + CRLF
	cQuery += "              inner join(SELECT *"    + CRLF
	cQuery += "                         FROM   sa1110)SA1"    + CRLF
	cQuery += "                      ON SA1.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                         AND a1_cod = d2_cliente"    + CRLF
	cQuery += "                         AND a1_loja = d2_loja"    + CRLF
	cQuery += "                         AND SA1.a1_grpven <> 'ST'"    + CRLF
	cQuery += "                         AND SA1.a1_grpven <> 'SC'"    + CRLF
	cQuery += "                         AND SA1.a1_est <> 'EX'"    + CRLF
	cQuery += "              left join sc5110 C5"    + CRLF
	cQuery += "                     ON c5_filial = d2_filial"    + CRLF
	cQuery += "                        AND c5_num = d2_pedido"    + CRLF
	cQuery += "                        AND C5.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sf2110)SF2"    + CRLF
	cQuery += "                     ON SF2.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND f2_doc = d2_doc"    + CRLF
	cQuery += "                        AND f2_serie = d2_serie"    + CRLF
	cQuery += "                        AND f2_filial = d2_filial"    + CRLF
	cQuery += "              inner join(SELECT *"    + CRLF
	cQuery += "                         FROM   sb1110 SB1"    + CRLF
	cQuery += "                               inner join da1110 DA1"    + CRLF
	cQuery += "                                       ON DA1.da1_codpro = SB1.b1_cod"    + CRLF
	cQuery += "                                          AND DA1.da1_codtab = '001'"    + CRLF
	cQuery += "                                          AND DA1.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                         WHERE  SB1.d_e_l_e_t_ = ' ')SB1"    + CRLF
	cQuery += "                      ON SB1.b1_cod = d2_cod"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   UDBP12.sb1030 SB1"    + CRLF
	cQuery += "                               inner join da1110 DA1"    + CRLF
	cQuery += "                                       ON DA1.da1_codpro = SB1.b1_cod"    + CRLF
	cQuery += "                                          AND DA1.da1_codtab = '001'"    + CRLF
	cQuery += "                                          AND DA1.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        WHERE  SB1.d_e_l_e_t_ = ' ')TB1"    + CRLF
	cQuery += "                     ON TB1.b1_cod = d2_cod"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sbm110)SBM"    + CRLF
	cQuery += "                     ON SBM.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND bm_grupo = SB1.b1_grupo"    + CRLF
	cQuery += "                        AND SBM.bm_xagrup <> ' '"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sa3110)SA3"    + CRLF
	cQuery += "                     ON SA3.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND SA3.a3_cod = f2_vend1"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sa3110)TA3"    + CRLF
	cQuery += "                     ON TA3.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND TA3.a3_cod = SA3.a3_super"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sx5110)SX5"    + CRLF
	cQuery += "                     ON SX5.x5_tabela = 'A2'"    + CRLF
	cQuery += "                        AND SX5.x5_chave = SA1.a1_regiao"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sx5110)TX5"    + CRLF
	cQuery += "                     ON Trim(TX5.x5_tabela) = 'ZZ'"    + CRLF
	cQuery += "                        AND Trim(TX5.x5_chave) = Trim(SBM.bm_xagrup)"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   UDBP12.sb9030)SB9"    + CRLF
	cQuery += "                     ON SB9.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND SB9.b9_filial = '01'"    + CRLF
	cQuery += "                        AND SB9.b9_cod = SD2.d2_cod"    + CRLF
	cQuery += "                        AND SB9.b9_data = d2_emissao"    + CRLF
	cQuery += "                        AND SB9.b9_local = '15'"    + CRLF
	cQuery += "                        AND SB1.b1_claprod = 'C'"    + CRLF
	cQuery += "                        AND TB1.b1_claprod = 'F'"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sb9110)TB9"    + CRLF
	cQuery += "                     ON TB9.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND TB9.b9_filial = '01'"    + CRLF
	cQuery += "                        AND TB9.b9_cod = SD2.d2_cod"    + CRLF
	cQuery += "                        AND TB9.b9_data = d2_emissao"    + CRLF
	cQuery += "                        AND TB9.b9_local = '03'"    + CRLF
	cQuery += "       WHERE  SD2.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "              AND SD2.d2_cf IN ( '5101', '5102', '5109', '5116',"    + CRLF
	cQuery += "                                 '5117', '5118', '5119', '5122',"    + CRLF
	cQuery += "                                 '5123', '5401', '5405', '5403',"    + CRLF
	cQuery += "                                 '5501', '5551', '5922', '5502',"    + CRLF
	cQuery += "                                 '6101', '6102', '6107', '6108',"    + CRLF
	cQuery += "                                 '6109', '6110', '6111', '6114',"    + CRLF
	cQuery += "                                 '6116', '6117', '6118', '6119',"    + CRLF
	cQuery += "                                 '6122', '6123', '6401', '6403',"    + CRLF
	cQuery += "                                 '6404', '6501', '6502', '6551',"    + CRLF
	cQuery += "                                 '6922', '7101', '7102' )"    + CRLF
	cQuery += "              AND d2_emissao BETWEEN '"+DTOS(Date()-45)+"' AND '"+DTOS(Date())+"'      "    + CRLF
	cQuery += "       UNION"    + CRLF
	cQuery += "       SELECT 'AM'                            AS EMPRESA,"    + CRLF
	cQuery += "              'C'                           AS MODALIDADE,"    + CRLF
	cQuery += "              f2_doc                          AS NOTA_FISCAL,"    + CRLF
	cQuery += "              f2_serie                        AS SERIE_FISCAL,"    + CRLF
	cQuery += "              Substr(f2_emissao, 7, 2)"    + CRLF
	cQuery += "              ||'/'"    + CRLF
	cQuery += "              ||Substr(f2_emissao, 5, 2)"    + CRLF
	cQuery += "              ||'/'"    + CRLF
	cQuery += "              ||Substr(f2_emissao, 1, 4)      AS EMISSAO,"    + CRLF
	cQuery += "              Substr(f2_emissao, 5, 2)"    + CRLF
	cQuery += "              ||'/'"    + CRLF
	cQuery += "              ||Substr(f2_emissao, 1, 4)      AS MES_ANO,"    + CRLF
	cQuery += "              d2_quant                        AS QUANTIDADE,"    + CRLF
	cQuery += "              d2_cod                          AS PRODUTO,"    + CRLF
	cQuery += "              SB1.b1_desc                     AS DESCRICAO,"    + CRLF
	cQuery += "              Nvl(bm_grupo, 'S/G')            AS GRUPO,"    + CRLF
	cQuery += "              Nvl(bm_desc, 'SEM GRUPO')       AS DESC_GRUPO,"    + CRLF
	cQuery += "              Nvl(Trim(TX5.x5_descri), 'N/A') AS AGRUPAMENTO,"    + CRLF
	cQuery += "              a1_grpven                       AS GRUPO_VENDAS,"    + CRLF
	cQuery += "              a1_cod                          AS CODIGO,"    + CRLF
	cQuery += "              a1_loja                         AS LOJA,"    + CRLF
	cQuery += "              a1_nome                         AS RAZAO_SOCIAL,"    + CRLF
	cQuery += "              a1_cgc                          AS CNPJ,"    + CRLF
	cQuery += "              a1_est                          AS ESTADO,"    + CRLF
	cQuery += "              a1_mun                          AS MUNICIPIO,"    + CRLF
	cQuery += "              a1_cod_mun                      AS CODIGO_MUNICIPIO,"    + CRLF
	cQuery += "              Trim(SX5.x5_descri)             AS REGIAO,"    + CRLF
	cQuery += "              SA3.a3_cod                      AS VENDEDOR,"    + CRLF
	cQuery += "              SA3.a3_nome                     AS NOME_VENDEDOR,"    + CRLF
	cQuery += "              TA3.a3_cod                      AS COORDENADOR,"    + CRLF
	cQuery += "              TA3.a3_nome                     AS NOME_COORDENADOR,"    + CRLF
	cQuery += "              CASE"    + CRLF
	cQuery += "                WHEN SB9.b9_cm1 <> 0 THEN Round(SB9.b9_cm1, 2)"    + CRLF
	cQuery += "                ELSE"    + CRLF
	cQuery += "                  CASE"    + CRLF
	cQuery += "                    WHEN TB9.b9_cm1 <> 0 THEN Round(TB9.b9_cm1, 2)"    + CRLF
	cQuery += "                    ELSE Round(SB1.b1_xpcstk, 2)"    + CRLF
	cQuery += "                  END"    + CRLF
	cQuery += "              END                             AS CUSTO,"    + CRLF
	cQuery += "              SD2.r_e_c_n_o_                  AS RECNO,"    + CRLF
	cQuery += "              SD2.d2_total                    AS BRUTO_FATURAMENTO,"    + CRLF
	cQuery += "              ' '                             ORIGEM"    + CRLF
	cQuery += "       FROM   UDBP12.sd2030 SD2"    + CRLF
	cQuery += "              inner join(SELECT *"    + CRLF
	cQuery += "                         FROM   UDBP12.sa1030)SA1"    + CRLF
	cQuery += "                      ON SA1.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                         AND a1_cod = d2_cliente"    + CRLF
	cQuery += "                         AND a1_loja = d2_loja"    + CRLF
	cQuery += "                         AND SA1.a1_grpven <> 'ST'"    + CRLF
	cQuery += "                         AND SA1.a1_grpven <> 'SC'"    + CRLF
	cQuery += "                         AND SA1.a1_est <> 'EX'"    + CRLF
	cQuery += "              inner join(SELECT *"    + CRLF
	cQuery += "                         FROM   UDBP12.sf2030)SF2"    + CRLF
	cQuery += "                      ON SF2.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                         AND f2_doc = d2_doc"    + CRLF
	cQuery += "                         AND f2_serie = d2_serie"    + CRLF
	cQuery += "                         AND f2_filial = d2_filial"    + CRLF
	cQuery += "              inner join(SELECT *"    + CRLF
	cQuery += "                         FROM   sb1110 SB1"    + CRLF
	cQuery += "                                inner join da1110 DA1"    + CRLF
	cQuery += "                                        ON DA1.da1_codpro = SB1.b1_cod"    + CRLF
	cQuery += "                                           AND DA1.da1_codtab = '001'"    + CRLF
	cQuery += "                                           AND DA1.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                         WHERE  SB1.d_e_l_e_t_ = ' ')SB1"    + CRLF
	cQuery += "                      ON SB1.b1_cod = d2_cod"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   UDBP12.sb1030 SB1"    + CRLF
	cQuery += "                               inner join da1110 DA1"    + CRLF
	cQuery += "                                       ON DA1.da1_codpro = SB1.b1_cod"    + CRLF
	cQuery += "                                          AND DA1.da1_codtab = '001'"    + CRLF
	cQuery += "                                          AND DA1.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        WHERE  SB1.d_e_l_e_t_ = ' ')TB1"    + CRLF
	cQuery += "                     ON TB1.b1_cod = d2_cod"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sbm110)SBM"    + CRLF
	cQuery += "                     ON SBM.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND bm_grupo = SB1.b1_grupo"    + CRLF
	cQuery += "                        AND SBM.bm_xagrup <> ' '"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   UDBP12.sa3030)SA3"    + CRLF
	cQuery += "                     ON SA3.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND SA3.a3_cod = f2_vend1"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   UDBP12.sa3030)TA3"    + CRLF
	cQuery += "                     ON TA3.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND TA3.a3_cod = SA3.a3_super"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   UDBP12.sx5030)SX5"    + CRLF
	cQuery += "                     ON SX5.x5_tabela = 'A2'"    + CRLF
	cQuery += "                        AND SX5.x5_chave = SA1.a1_regiao"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sx5110)TX5"    + CRLF
	cQuery += "                     ON Trim(TX5.x5_tabela) = 'ZZ'"    + CRLF
	cQuery += "                        AND Trim(TX5.x5_chave) = Trim(SBM.bm_xagrup)"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   UDBP12.sb9030)SB9"    + CRLF
	cQuery += "                     ON SB9.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND SB9.b9_filial = '01'"    + CRLF
	cQuery += "                        AND SB9.b9_cod = SD2.d2_cod"    + CRLF
	cQuery += "                        AND SB9.b9_data = d2_emissao"    + CRLF
	cQuery += "                        AND SB9.b9_local = '15'"    + CRLF
	cQuery += "                        AND SB1.b1_claprod = 'C'"    + CRLF
	cQuery += "                        AND TB1.b1_claprod = 'F'"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sb9110)TB9"    + CRLF
	cQuery += "                     ON TB9.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND TB9.b9_filial = '01'"    + CRLF
	cQuery += "                        AND TB9.b9_cod = SD2.d2_cod"    + CRLF
	cQuery += "                        AND TB9.b9_data = d2_emissao"    + CRLF
	cQuery += "                        AND TB9.b9_local = '03'"    + CRLF
	cQuery += "       WHERE  SD2.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "              AND SD2.d2_cf IN ( '5101', '5102', '5109', '5116',"    + CRLF
	cQuery += "                                 '5117', '5118', '5119', '5122',"    + CRLF
	cQuery += "                                 '5123', '5401', '5405', '5403',"    + CRLF
	cQuery += "                                 '5501', '5551', '5922', '5502',"    + CRLF
	cQuery += "                                 '6101', '6102', '6107', '6108',"    + CRLF
	cQuery += "                                 '6109', '6110', '6111', '6114',"    + CRLF
	cQuery += "                                 '6116', '6117', '6118', '6119',"    + CRLF
	cQuery += "                                 '6122', '6123', '6401', '6403',"    + CRLF
	cQuery += "                                 '6404', '6501', '6502', '6551',"    + CRLF
	cQuery += "                                 '6922', '7101', '7102' )"    + CRLF
	cQuery += "              AND d2_emissao BETWEEN '"+DTOS(Date()-45)+"' AND '"+DTOS(Date())+"'   "    + CRLF
	cQuery += "              AND d2_filial = '01'"    + CRLF
	cQuery += "       UNION"    + CRLF
	cQuery += "       SELECT 'SP'                            AS EMPRESA,"    + CRLF
	cQuery += "              'D'                             AS MODALIDADE,"    + CRLF
	cQuery += "              d1_doc                          AS NOTA_FISCAL,"    + CRLF
	cQuery += "              d1_serie                        AS SERIE_FISCAL,"    + CRLF
	cQuery += "              Substr(d1_dtdigit, 7, 2)"    + CRLF
	cQuery += "              ||'/'"    + CRLF
	cQuery += "              ||Substr(d1_dtdigit, 5, 2)"    + CRLF
	cQuery += "              ||'/'"    + CRLF
	cQuery += "              ||Substr(d1_dtdigit, 1, 4)      AS EMISSAO,"    + CRLF
	cQuery += "              Substr(d1_dtdigit, 5, 2)"    + CRLF
	cQuery += "              ||'/'"    + CRLF
	cQuery += "              ||Substr(d1_dtdigit, 1, 4)      AS MES_ANO,"    + CRLF
	cQuery += "              d1_quant                        AS QUANTIDADE,"    + CRLF
	cQuery += "              d1_cod                          AS PRODUTO,"    + CRLF
	cQuery += "              SB1.b1_desc                     AS DESCRICAO,"    + CRLF
	cQuery += "              Nvl(bm_grupo, 'S/G')            AS GRUPO,"    + CRLF
	cQuery += "              Nvl(bm_desc, 'SEM GRUPO')       AS DESC_GRUPO,"    + CRLF
	cQuery += "              Nvl(Trim(TX5.x5_descri), 'N/A') AS AGRUPAMENTO,"    + CRLF
	cQuery += "              a1_grpven                       AS GRUPO_VENDAS,"    + CRLF
	cQuery += "              a1_cod                          AS CODIGO,"    + CRLF
	cQuery += "              a1_loja                         AS LOJA,"    + CRLF
	cQuery += "              a1_nome                         AS RAZAO_SOCIAL,"    + CRLF
	cQuery += "              a1_cgc                          AS CNPJ,"    + CRLF
	cQuery += "              a1_est                          AS ESTADO,"    + CRLF
	cQuery += "              a1_mun                          AS MUNICIPIO,"    + CRLF
	cQuery += "              a1_cod_mun                      AS CODIGO_MUNICIPIO,"    + CRLF
	cQuery += "              Trim(SX5.x5_descri)             AS REGIAO,"    + CRLF
	cQuery += "              SA3.a3_cod                      AS VENDEDOR,"    + CRLF
	cQuery += "              SA3.a3_nome                     AS NOME_VENDEDOR,"    + CRLF
	cQuery += "              TA3.a3_cod                      AS COORDENADOR,"    + CRLF
	cQuery += "              TA3.a3_nome                     AS NOME_COORDENADOR,"    + CRLF
	cQuery += "              CASE"    + CRLF
	cQuery += "                WHEN SB9.b9_cm1 <> 0 THEN Round(SB9.b9_cm1, 2)"    + CRLF
	cQuery += "                ELSE"    + CRLF
	cQuery += "                  CASE"    + CRLF
	cQuery += "                    WHEN TB9.b9_cm1 <> 0 THEN Round(TB9.b9_cm1, 2)"    + CRLF
	cQuery += "                    ELSE Round(SB1.b1_xpcstk, 2)"    + CRLF
	cQuery += "                  END"    + CRLF
	cQuery += "              END                             AS CUSTO,"    + CRLF
	cQuery += "              SD1.r_e_c_n_o_                  AS RECNO,"    + CRLF
	cQuery += "              ( d1_total ) *- 1               AS BRUTO_FATURAMENTO,"    + CRLF
	cQuery += "              ' '                             ORIGEM"    + CRLF
	cQuery += "       FROM   sd1110 SD1"    + CRLF
	cQuery += "              inner join(SELECT *"    + CRLF
	cQuery += "                         FROM   sa1110)SA1"    + CRLF
	cQuery += "                      ON SA1.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                         AND SA1.a1_cod = SD1.d1_fornece"    + CRLF
	cQuery += "                         AND SA1.a1_loja = SD1.d1_loja"    + CRLF
	cQuery += "                         AND SA1.a1_filial = '  '"    + CRLF
	cQuery += "                         AND SA1.a1_grpven <> 'ST'"    + CRLF
	cQuery += "                         AND SA1.a1_grpven <> 'SC'"    + CRLF
	cQuery += "                         AND SA1.a1_est <> 'EX'"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sf2110)SF2"    + CRLF
	cQuery += "                     ON SF2.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND SF2.f2_doc = d1_nfori"    + CRLF
	cQuery += "                        AND SF2.f2_serie = d1_seriori"    + CRLF
	cQuery += "                        AND SF2.f2_filial = SD1.d1_filial"    + CRLF
	cQuery += "              inner join(SELECT *"    + CRLF
	cQuery += "                         FROM   sb1110 SB1"    + CRLF
	cQuery += "                                inner join da1110 DA1"    + CRLF
	cQuery += "                                        ON DA1.da1_codpro = SB1.b1_cod"    + CRLF
	cQuery += "                                           AND DA1.da1_codtab = '001'"    + CRLF
	cQuery += "                                           AND DA1.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                         WHERE  SB1.d_e_l_e_t_ = ' ')SB1"    + CRLF
	cQuery += "                      ON SB1.b1_cod = d1_cod"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   UDBP12.sb1030 SB1"    + CRLF
	cQuery += "                               inner join da1110 DA1"    + CRLF
	cQuery += "                                       ON DA1.da1_codpro = SB1.b1_cod"    + CRLF
	cQuery += "                                          AND DA1.da1_codtab = '001'"    + CRLF
	cQuery += "                                          AND DA1.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        WHERE  SB1.d_e_l_e_t_ = ' ')TB1"    + CRLF
	cQuery += "                     ON TB1.b1_cod = d1_cod"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sbm110)SBM"    + CRLF
	cQuery += "                     ON SBM.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND bm_grupo = SB1.b1_grupo"    + CRLF
	cQuery += "                        AND SBM.bm_xagrup <> ' '"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sa3110)SA3"    + CRLF
	cQuery += "                     ON SA3.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND SA3.a3_cod = f2_vend1"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sa3110)TA3"    + CRLF
	cQuery += "                     ON TA3.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND TA3.a3_cod = SA3.a3_super"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sx5110)SX5"    + CRLF
	cQuery += "                     ON SX5.x5_tabela = 'A2'"    + CRLF
	cQuery += "                        AND SX5.x5_chave = SA1.a1_regiao"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sx5110)TX5"    + CRLF
	cQuery += "                     ON Trim(TX5.x5_tabela) = 'ZZ'"    + CRLF
	cQuery += "                        AND Trim(TX5.x5_chave) = Trim(SBM.bm_xagrup)"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   UDBP12.sb9030)SB9"    + CRLF
	cQuery += "                     ON SB9.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND SB9.b9_filial = '01'"    + CRLF
	cQuery += "                        AND SB9.b9_cod = SD1.d1_cod"    + CRLF
	cQuery += "                        AND SB9.b9_data = d1_dtdigit"    + CRLF
	cQuery += "                        AND SB9.b9_local = '15'"    + CRLF
	cQuery += "                        AND SB1.b1_claprod = 'C'"    + CRLF
	cQuery += "                        AND TB1.b1_claprod = 'F'"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sb9110)TB9"    + CRLF
	cQuery += "                     ON TB9.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND TB9.b9_filial = '01'"    + CRLF
	cQuery += "                        AND TB9.b9_cod = SD1.d1_cod"    + CRLF
	cQuery += "                        AND TB9.b9_data = d1_dtdigit"    + CRLF
	cQuery += "                        AND TB9.b9_local = '03'"    + CRLF
	cQuery += "       WHERE  SD1.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "              AND SD1.d1_cf IN ( '1201', '1202', '1410', '1411',"    + CRLF
	cQuery += "                                 '2201', '2202', '2410', '2411',"    + CRLF
	cQuery += "                                 '2203', '1918', '2918', '3201',"    + CRLF
	cQuery += "                                 '3202', '3211' )"    + CRLF
	cQuery += "              AND SD1.d1_dtdigit BETWEEN '"+DTOS(Date()-45)+"' AND '"+DTOS(Date())+"' "    + CRLF
	cQuery += "              AND SD1.d1_tipo = 'D'"    + CRLF
	cQuery += "       UNION"    + CRLF
	cQuery += "       SELECT 'AM'                            AS EMPRESA,"    + CRLF
	cQuery += "              'D'                             AS MODALIDADE,"    + CRLF
	cQuery += "              d1_doc                          AS NOTA_FISCAL,"    + CRLF
	cQuery += "              d1_serie                        AS SERIE_FISCAL,"    + CRLF
	cQuery += "              Substr(d1_dtdigit, 7, 2)"    + CRLF
	cQuery += "              ||'/'"    + CRLF
	cQuery += "              ||Substr(d1_dtdigit, 5, 2)"    + CRLF
	cQuery += "              ||'/'"    + CRLF
	cQuery += "              ||Substr(d1_dtdigit, 1, 4)      AS EMISSAO,"    + CRLF
	cQuery += "              Substr(d1_dtdigit, 5, 2)"    + CRLF
	cQuery += "              ||'/'"    + CRLF
	cQuery += "              ||Substr(d1_dtdigit, 1, 4)      AS MES_ANO,"    + CRLF
	cQuery += "              d1_quant                        AS QUANTIDADE,"    + CRLF
	cQuery += "              d1_cod                          AS PRODUTO,"    + CRLF
	cQuery += "              SB1.b1_desc                     AS DESCRICAO,"    + CRLF
	cQuery += "              Nvl(bm_grupo, 'S/G')            AS GRUPO,"    + CRLF
	cQuery += "              Nvl(bm_desc, 'SEM GRUPO')       AS DESC_GRUPO,"    + CRLF
	cQuery += "              Nvl(Trim(TX5.x5_descri), 'N/A') AS AGRUPAMENTO,"    + CRLF
	cQuery += "              a1_grpven                       AS GRUPO_VENDAS,"    + CRLF
	cQuery += "              a1_cod                          AS CODIGO,"    + CRLF
	cQuery += "              a1_loja                         AS LOJA,"    + CRLF
	cQuery += "              a1_nome                         AS RAZAO_SOCIAL,"    + CRLF
	cQuery += "              a1_cgc                          AS CNPJ,"    + CRLF
	cQuery += "              a1_est                          AS ESTADO,"    + CRLF
	cQuery += "              a1_mun                          AS MUNICIPIO,"    + CRLF
	cQuery += "              a1_cod_mun                      AS CODIGO_MUNICIPIO,"    + CRLF
	cQuery += "              Trim(SX5.x5_descri)             AS REGIAO,"    + CRLF
	cQuery += "              SA3.a3_cod                      AS VENDEDOR,"    + CRLF
	cQuery += "              SA3.a3_nome                     AS NOME_VENDEDOR,"    + CRLF
	cQuery += "              TA3.a3_cod                      AS COORDENADOR,"    + CRLF
	cQuery += "              TA3.a3_nome                     AS NOME_COORDENADOR,"    + CRLF
	cQuery += "              CASE"    + CRLF
	cQuery += "                WHEN SB9.b9_cm1 <> 0 THEN Round(SB9.b9_cm1, 2)"    + CRLF
	cQuery += "                ELSE"    + CRLF
	cQuery += "                  CASE"    + CRLF
	cQuery += "                    WHEN TB9.b9_cm1 <> 0 THEN Round(TB9.b9_cm1, 2)"    + CRLF
	cQuery += "                    ELSE Round(SB1.b1_xpcstk, 2)"    + CRLF
	cQuery += "                  END"    + CRLF
	cQuery += "              END                             AS CUSTO,"    + CRLF
	cQuery += "              SD1.r_e_c_n_o_                  AS RECNO,"    + CRLF
	cQuery += "              ( d1_total ) *- 1               AS BRUTO_FATURAMENTO,"    + CRLF
	cQuery += "              ' '                             ORIGEM"    + CRLF
	cQuery += "       FROM   UDBP12.sd1030 SD1"    + CRLF
	cQuery += "              inner join(SELECT *"    + CRLF
	cQuery += "                         FROM   UDBP12.sa1030)SA1"    + CRLF
	cQuery += "                      ON SA1.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                         AND SA1.a1_cod = SD1.d1_fornece"    + CRLF
	cQuery += "                         AND SA1.a1_loja = SD1.d1_loja"    + CRLF
	cQuery += "                         AND SA1.a1_filial = '  '"    + CRLF
	cQuery += "                         AND SA1.a1_grpven <> 'ST'"    + CRLF
	cQuery += "                         AND SA1.a1_grpven <> 'SC'"    + CRLF
	cQuery += "                         AND SA1.a1_est <> 'EX'"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   UDBP12.sf2030)SF2"    + CRLF
	cQuery += "                     ON SF2.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND SF2.f2_doc = d1_nfori"    + CRLF
	cQuery += "                        AND SF2.f2_serie = d1_seriori"    + CRLF
	cQuery += "                        AND SF2.f2_filial = SD1.d1_filial"    + CRLF
	cQuery += "              inner join(SELECT *"    + CRLF
	cQuery += "                         FROM   sb1110 SB1"    + CRLF
	cQuery += "                                inner join da1110 DA1"    + CRLF
	cQuery += "                                        ON DA1.da1_codpro = SB1.b1_cod"    + CRLF
	cQuery += "                                           AND DA1.da1_codtab = '001'"    + CRLF
	cQuery += "                                           AND DA1.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                         WHERE  SB1.d_e_l_e_t_ = ' ')SB1"    + CRLF
	cQuery += "                      ON SB1.b1_cod = d1_cod"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   UDBP12.sb1030 SB1"    + CRLF
	cQuery += "                               inner join da1110 DA1"    + CRLF
	cQuery += "                                       ON DA1.da1_codpro = SB1.b1_cod"    + CRLF
	cQuery += "                                          AND DA1.da1_codtab = '001'"    + CRLF
	cQuery += "                                          AND DA1.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        WHERE  SB1.d_e_l_e_t_ = ' ')TB1"    + CRLF
	cQuery += "                     ON TB1.b1_cod = d1_cod"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sbm110)SBM"    + CRLF
	cQuery += "                     ON SBM.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND bm_grupo = SB1.b1_grupo"    + CRLF
	cQuery += "                        AND SBM.bm_xagrup <> ' '"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sa3110)SA3"    + CRLF
	cQuery += "                     ON SA3.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND SA3.a3_cod = f2_vend1"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sa3110)TA3"    + CRLF
	cQuery += "                     ON TA3.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND TA3.a3_cod = SA3.a3_super"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sx5110)SX5"    + CRLF
	cQuery += "                     ON SX5.x5_tabela = 'A2'"    + CRLF
	cQuery += "                        AND SX5.x5_chave = SA1.a1_regiao"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sx5110)TX5"    + CRLF
	cQuery += "                     ON Trim(TX5.x5_tabela) = 'ZZ'"    + CRLF
	cQuery += "                        AND Trim(TX5.x5_chave) = Trim(SBM.bm_xagrup)"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   UDBP12.sb9030)SB9"    + CRLF
	cQuery += "                     ON SB9.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND SB9.b9_filial = '01'"    + CRLF
	cQuery += "                        AND SB9.b9_cod = SD1.d1_cod"    + CRLF
	cQuery += "                        AND SB9.b9_data = d1_dtdigit"    + CRLF
	cQuery += "                        AND SB9.b9_local = '15'"    + CRLF
	cQuery += "                        AND SB1.b1_claprod = 'C'"    + CRLF
	cQuery += "                        AND TB1.b1_claprod = 'F'"    + CRLF
	cQuery += "              left join(SELECT *"    + CRLF
	cQuery += "                        FROM   sb9110)TB9"    + CRLF
	cQuery += "                     ON TB9.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "                        AND TB9.b9_filial = '01'"    + CRLF
	cQuery += "                        AND TB9.b9_cod = SD1.d1_cod"    + CRLF
	cQuery += "                        AND TB9.b9_data = d1_dtdigit"    + CRLF
	cQuery += "                        AND TB9.b9_local = '03'"    + CRLF
	cQuery += "       WHERE  SD1.d_e_l_e_t_ = ' '"    + CRLF
	cQuery += "              AND SD1.d1_cf IN ( '1201', '1202', '1410', '1411',"    + CRLF
	cQuery += "                                 '2201', '2202', '2410', '2411',"    + CRLF
	cQuery += "                                 '2203', '1918', '2918', '3201',"    + CRLF
	cQuery += "                                 '3202', '3211' )"    + CRLF
	cQuery += "              AND SD1.d1_filial = '01'"    + CRLF
	cQuery += "              AND SD1.d1_dtdigit BETWEEN '"+DTOS(Date()-45)+"' AND '"+DTOS(Date())+"'  "    + CRLF
	cQuery += "              AND SD1.d1_tipo = 'D' "    + CRLF
	
	cQuery := Changequery(cQuery)

	TCQuery cQuery  New Alias (cAlias:=GetNextAlias())

	dbSelectArea(cAlias)

	(cAlias)->(dbGoTop())

	oFWriter := FWFileWriter():New(cLocArq +"\"+ cArquivo, .T.)
	oFWriter:SetCaseSensitive(.T.)

	If ! oFWriter:Create()
		Conout("Houve um erro ao gerar o arquivo: " + CRLF + oFWriter:Error():Message)
	Else
		While !(cAlias)->(Eof())
			oFWriter:Write(""+";"+;						//1 - Deixar em branco
			""+";"+;									//2 - Deixar em branco
			""+";"+;									//3 - Deixar em branco
			(cAlias)->MODALIDADE+";"+;					//4 - Tipo de faturamento
			DtoS(CtoD((cAlias)->EMISSAO))	+";"+;		//5 - Data do faturamento
			(cAlias)->(CODIGO+LOJA)+";"+;				//6 - Emissor da ordem (Código ERP do Cadastro de Clientes)
			""				+";"+;						//7 - Recebedor de mercadoria (Código ERP do Cadastro de Clientes)
			""				+";"+;						//8 - Vendedor (Código ERP de Funcionários)
			Alltrim((cAlias)->PRODUTO)+";"+;			//9 - Material envolvido (Código SKU do Texto Material)
			""+";"+;									//10 - Tipo da embalagem do material
			(cAlias)->(SERIE_FISCAL+NOTA_FISCAL)+";"+;	//11 - Código da ordem do faturamento
			ALLTRIM(STR((cAlias)->QUANTIDADE))+";"+;	//12 - Quantidade do SKU em unidade
			";"+;										//13 - Realizado
			ALLTRIM(STR((cAlias)->BRUTO_FATURAMENTO))+ CRLF)//14 - Faturamento total do item em dinheiro

			(cAlias)->(dbSkip())
		EndDo

		oFWriter:Close()

		(cAlias)->(dbCloseArea())

	EndIf

Return

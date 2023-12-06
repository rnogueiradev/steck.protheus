#include "topconn.ch"
#include "tbiconn.ch"
#include "protheus.ch"

/*/
{Protheus.doc} U_STGPE021

@author Igor Pedracolli
@since   06/05/2022

@obs - Dados dos Colaboradores.		
/*/

User Function STGPE021(xEmp,xFil,xMin,xMax)

Local cTexto	:=	""

Local cQuery	:=	"Select * From SRACRMD "
Local lPriVez	:=	.t.
Local lIsBlind	:=	IsBlind() .or. Type("__LocalDriver") == "U"   
Local cArquivo	:= 	""

Default xMin	:=	Date() - 10
Default xMax	:=	Date() 
Default xEmp	:=	"11"    													// Empresa do Grupo 
Default xFil	:=	"01"    													// Filial do Grupo 

if	lIsBlind	
	//RpcSetType(3)
	Prepare Environment Empresa "11" Filial "01"  
  	SetModulo("SIGAEST","EST")
	cArquivo	:= 	"C:\Temp\Transferencia\JoinRH\DEMITIDOS_2022.csv"//SuperGetMv("ST_EXPSA21",.f.,"\arquivos\SFTP-INTEGRAÇÕES\LINKEDRH\PENDING\DEMITIDOS_2022.csv")
elseif !MsgYesNo("Deseja gerar o CSV ?")
	Return	
endif

TcQuery ChangeQuery(@cQuery) New Alias "XQRY" 

do while XQRY->(!Eof())       
		if	lPriVez
		lPriVez	:=	.f.
		cTexto	+= 	"ANO_VIGENCIA"	    						 + ";"     
	    cTexto	+= 	"MES_VIGENCIA"	     						 + ";"      
		cTexto	+=	"ID_FUNCIONARIO"					    	 + ";"      	
	    cTexto	+=  "MATRICULA"        						     + ";"      	 
		cTexto	+=	"ID_SUPERIOR"                 			   	 + ";"      	
	    cTexto	+=	"NOME_FUNCIONARIO"                     		 + ";"      
		cTexto	+=	"CODIGO_CARGO"                	  		     + ";"      
		cTexto	+=	"NOME_CARGO"               	  				 + ";"      
		cTexto	+=	"EMAIL"	             					     + ";"      	
		cTexto	+=	"CODIGO_EMPRESA"               	 	         + ";"      	
	    cTexto	+=	"NOME_EMPRESA"                  			 + ";"           
		cTexto	+=	"CODIGO_FILIAL"                  	  	     + ";"      	
	    cTexto	+=  "NOME_FILIAL"        						 + ";"      	
	    cTexto	+=	"CODIGO_DEPARTAMENTO"                      	 + ";"      
		cTexto	+=  "NOME_DEPARTAMENTO" 						 + ";"      	
		cTexto	+=  "CENTRO_DE_CUSTO"    						 + ";"      
		cTexto	+=  "NOME_CENTRO_CUSTO"      					 + ";"    	
		cTexto	+=	"DATA_NASCIMENTO"	                         + ";"       
	    cTexto	+=	"ADMISSAO_EMPRESA" 	                         + ";"       
		cTexto	+=	"ADMISSAO_CARGO"	                         + ";"       
	    cTexto	+=	"DATA_DEMISSAO"                      		 + ";"       
		cTexto	+=	"JORNADA_TRABALHO"   			             + ";"  	    
		cTexto	+=	"TIPO_SALARIO"	   				             + ";"        
		cTexto	+=  "SEXO" 	 	     					         + ";"       
	    cTexto	+=	"CODIGO_GRAUINST"                        	 + ";"       
	    cTexto	+=	"GRAU_INSTRUCAO"	             			 + ";"       
		cTexto	+=	"SALARIO_NOMINAL"		                     + ";"       
	    cTexto	+=  "SALARIO_REMUNERACAO"    					 + ";"       
		cTexto	+=	"TOTAL_REMUNERACAO"                     	 + ";"      
	    cTexto	+=	"TURNO"                         	   	     + ";"       
		cTexto	+=	"TURNO_DESC"                              	 + ";"       
	    cTexto	+=	"VINCULO_EMPREGATICIO"                       + ";"      
	    cTexto	+=  "RESICAO_CODIGO" 	     				  	 + ";"      
		cTexto	+=  "RESICAO_DESCRICAO"							+ CRLF         
	
	endif

	cTexto		+= 	Year2Str(Date())    						+ ";"      	// ANO VIGENCIA 
    cTexto		+= 	Month2Str(Date())    						+ ";"      	// MES VIGENCIA 
	cTexto		+=	Alltrim(XQRY->ID_Funcionario)     			+ ";"      	// RA_CIC 
    cTexto		+=	Alltrim(XQRY->Matricula) 					+ ";"      	// RA_MAT	
    cTexto		+=  Alltrim(XQRY->ID_SUPERIOR)   		      	+ ";"      	// RA_NOME
    cTexto		+=	Alltrim(XQRY->Nome_Funcionario) 	  		+ ";"      	// ||SRA.RA_FILIAL||SRA.RA_CODFUNC
	cTexto		+=	Alltrim(XQRY->Codigo_Cargo) 	  			+ ";"      	// RJ_DESC
	cTexto		+=	Alltrim(XQRY->Nome_Cargo) 	  				+ ";"      	// RJ_DESC
	cTexto		+=	Alltrim(XQRY->Email) 	  					+ ";"      	// RA_EMAIL
	cTexto		+=	Alltrim(XQRY->CODIGO_EMPRESA)     			+ ";"      	// ALIAS 
    cTexto		+=	Alltrim(XQRY->NOME_EMPRESA)     			+ ";"      	// ALIAS          
	cTexto		+=	Alltrim(XQRY->CODIGO_FILIAL)	  			+ ";"      	// RA_FILIAL
    cTexto		+=  Alltrim(XQRY->NOME_FILIAL)				    + ";"      	// SRA.RA_FILIAL WHEN '01' THEN 'FABRICA - MANAUS' WHEN '02' THEN 'Filial'
    cTexto		+=	Alltrim(XQRY->Codigo_Departamento)	  		+ ";"      	// RA_DEPTO
	cTexto		+=  Alltrim(XQRY->NOME_DEPARTAMENTO)     		+ ";"      	// QB_DESCRIC
	cTexto		+=	Alltrim(XQRY->Centro_de_Custo)	  			+ ";"       // RA_CC
    cTexto		+=	Alltrim(XQRY->Nome_Centro_Custo)	 	 	+ ";"       // CTT_DESC01
	cTexto		+=	Alltrim(XQRY->Data_Nascimento)				+ ";"       // SUBSTR(SRA.RA_NASC,7,2)||'/'||SUBSTR(SRA.RA_NASC,5,2)||'/'||SUBSTR(SRA.RA_NASC,1,4)
    cTexto		+=	Alltrim(XQRY->Admissao_Empresa)				+ ";"       // SUBSTR(SRA.RA_ADMISSA,7,2)||'/'||SUBSTR(SRA.RA_ADMISSA,5,2)||'/'||SUBSTR(SRA.RA_ADMISSA,1,4)
	cTexto		+=	Alltrim(XQRY->Admissao_Cargo)				+ ";"  	    // SUBSTR(SRA.RA_ADMISSA,7,2)||'/'||SUBSTR(SRA.RA_ADMISSA,5,2)||'/'||SUBSTR(SRA.RA_ADMISSA,1,4)
	cTexto		+=	Alltrim(XQRY->Data_Demissao)	   			+ ";"       // "" 
    cTexto		+=  Alltrim(Str(XQRY->JORNADA_TRABALHO))		+ ";"       // RA_HRSMES     //TRATAR  - cTexto +=	XQRY->Jornada_Trabalho	   + ";" 
    cTexto		+=	Alltrim(XQRY->Tipo_Salario)          		+ ";"       // RA_CATFUNC  -- ERRO SCHEDULE
	cTexto		+=	Alltrim(XQRY->Sexo)	   						+ ";"       // RA_SEXO
	cTexto		+=	Alltrim(XQRY->Codigo_GrauInst)	 			+ ";"       // RA_GRINRAI
	cTexto		+=  Alltrim(XQRY->GRAU_INSTRUCAO)				+ ";"       // X5_DESCRI  -- NOME GRAU DE INSTITUIÇÃO - AMARRAR TABELA 26 - SX5

	If Alltrim(XQRY->Tipo_Salario) $ 'H'
    cTexto		+=	Alltrim(Transform(XQRY->Salario_Nominal*220,"@E 999999.99"))			   		+ ";"       // RA_SALARIO
	else
	cTexto		+=	Alltrim(Transform(XQRY->Salario_Nominal,"@E 999999.99"))	   					+ ";"       // RA_SALARIO
	EndIf	

	If Alltrim(XQRY->Tipo_Salario) $ 'H'
	cTexto		+=	Alltrim(Transform(XQRY->Salario_Remuneracao*220,"@E 999999.99"))	   	+ ";"       // RA_SALARIO
	else
	cTexto		+=	Alltrim(Transform(XQRY->Salario_Remuneracao,"@E 999999.99"))	   	+ ";"       // RA_SALARIO
	EndIf 

	If Alltrim(XQRY->Tipo_Salario) $ 'H'
    cTexto		+=	Alltrim(Transform(XQRY->Total_Remuneracao*220,"@E 999999.99"))	   	+ ";"       // RA_SALARIO
	else
	cTexto		+=	Alltrim(Transform(XQRY->Total_Remuneracao,"@E 999999.99"))	   	+ ";"       // RA_SALARIO
	EndIf 

    cTexto		+=	Alltrim(XQRY->TURNO)	   			     	+ ";"       // RA_TNOTRAB
    cTexto		+=	Alltrim(XQRY->TURNO_DESC)			     	+ ";"       // R6_DESC
    cTexto		+=	Alltrim(XQRY->Vinculo_Empregaticio)	        + ";"       //  SX525.X5_DESCRI
    cTexto		+=  Alltrim(XQRY->RESICAO_CODIGO) 				+ ";"       // ""
	cTexto		+=  Alltrim(XQRY->RESICAO_DESCRICAO)			+ CRLF      // ""
 

	XQRY->(dbskip())
enddo

XQRY->(dbclosearea())

if !ExistDir("\system\temp")			
	MakeDir("\system\temp")
endif

if	File(cArquivo) 
	fErase(cArquivo) 
endif

MemoWrite(cArquivo,cTexto)

if	lIsBlind	
	Reset Environment  
endif

Return 

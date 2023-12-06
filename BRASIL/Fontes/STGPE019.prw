#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "PROTHEUS.CH"


/*/
{Protheus.doc} u_STGPE019

@author Igor Pedracolli 
@since   06/05/2022

@obs - Verbas Folha de Pagamento.		
/*/

User Function STGPE019(xEmp,xFil,xMin,xMax)

Local cTexto	:=	""

Local cQuery	:=	"Select * From SRACRM4 "
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
    cArquivo	:= 	SuperGetMv("ST_EXPSA19",.f.,"\system\temp\stgpe019.csv") 
elseif !MsgYesNo("Deseja gerar o CSV ?")
	Return	
endif


TcQuery ChangeQuery(@cQuery) New Alias "XQRY" 

do while XQRY->(!Eof())       
		if	lPriVez
		lPriVez	:=	.f.
		cTexto	+= 	"DATA_OCORRENCIA"	    						 + ";"     
	    cTexto	+= 	"ID_FUNCIONARIO"	     						 + ";"      
		cTexto	+=	"NOME_FUNCIONARIO"					         	 + ";"      	
	    cTexto	+=  "CODIGO_VERBA"        						     + ";"      	 
		cTexto	+=	"DESCRICAO_VERBA"                 			   	 + ";"      	
        cTexto	+=	"QUANTIDADE"                 			     	 + ";"   
        cTexto	+=	"VALOR"                 			       	     + ";"   
        cTexto	+=	"CODIGO_CENTRO_CUSTO"                  	    	 + ";"   
        cTexto	+=	"NOME_CENTRO_DE_CUSTO"                 		   	 + ";"   
        cTexto	+=	"CODIGO_EMPRESA"                 			   	 + ";"   
        cTexto	+=	"NOME_EMPRESA"                 			     	 + ";"   
        cTexto	+=	"CODIGO_FILIAL"                 			   	 + ";"   
        cTexto	+=	"NOME_FILIAL"                 			    	 + CRLF    	// ALIAS 

endif
		   
       cTexto		+=	Alltrim(XQRY->DATA_OCORRENCIA)	   			+ ";"       // SUBSTR(RD_DATPGT,7,2)||'/'||SUBSTR(RD_DATPGT,5,2)||'/'||SUBSTR(RD_DATPGT,1,4) 
       cTexto	    +=	Alltrim(XQRY->ID_FUNCIONARIO)     		    + ";"       // RA_CIC 
       cTexto		+=	Alltrim(XQRY->NOME_FUNCIONARIO) 	  		+ ";"      	// RA_NOME
       cTexto		+=	Alltrim(XQRY->CODIGO_VERBA) 	      		+ ";"    	// RD_PD
	   cTexto		+=	Alltrim(XQRY->DESCRICAO_VERBA) 	      		+ ";"    	// RV_DESC
       cTexto		+=	Alltrim(Str(XQRY->QUANTIDADE)) 	                + ";"     	// RD_HORAS
       cTexto		+=	Alltrim(Str(XQRY->VALOR))	            	+ ";"       // RD_VALOR 
       cTexto		+=	Alltrim(XQRY->CODIGO_CENTRO_CUSTO) 	      	+ ";"      	// RD_CC
       cTexto		+=	Alltrim(XQRY->NOME_CENTRO_DE_CUSTO) 	    + ";"       // CTT_DESC01
       cTexto		+=	Alltrim(XQRY->CODIGO_EMPRESA)	  			+ ";"      	// ALIAS
       cTexto		+=	Alltrim(XQRY->NOME_EMPRESA)	  			    + ";"      	// ALIAS 
       cTexto		+=	Alltrim(XQRY->CODIGO_FILIAL)	  		     +";"      	// RD_FILIAL
       cTexto		+=	Alltrim(XQRY->NOME_FILIAL)	  		        + CRLF    	// CASE RA_FILIAL WHEN '01' THEN 'MATRIZ' WHEN '05' THEN 'Fábrica - SP - Guararema'

	
    
    XQRY->(dbskip())
	
enddo

XQRY->(dbclosearea())

if !ExistDir("\System\TEMP")			
  	MakeDir("\System\TEMP")

endif

if	File(cArquivo) 
	fErase(cArquivo) 
endif

MemoWrite(cArquivo,cTexto)

if	lIsBlind	
	Reset Environment  
endif

Return 

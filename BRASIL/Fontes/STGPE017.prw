#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"


/*/
{Protheus.doc} u_STGPE017

@author Igor Pedracolli 
@since   06/05/2022

@obs - Historico de Cargos.		
/*/

User Function STGPE017(xEmp,xFil,xMin,xMax)

Local cTexto	:=	""

Local cQuery	:=	"Select * From SRACRM2"
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
	cArquivo	:= 	SuperGetMv("ST_EXPSA17",.f.,"\system\temp\stgpe017.csv") 
elseif !MsgYesNo("Deseja gerar o CSV ?")
	Return	
endif

TcQuery ChangeQuery(@cQuery) New Alias "XQRY" 
		   

do while XQRY->(!Eof())       
		if	lPriVez
		lPriVez	:=	.f.
		cTexto	+= 	"CPF"	    					         	 + ";"     
	    cTexto	+= 	"NOME_FUNCIONARIO"	     	        		 + ";"      
		cTexto	+=	"DATA_ADMISSAO"					         	 + ";"      	
	    cTexto	+=  "CODIGO_CARGO"           			  	     + ";"      	 
		cTexto	+=  "NOME_CARGO"           			  	     + ";"      	 
		cTexto	+=	"NOME_DEPARTAMENTO"                 	 	 + ";"      	
	    cTexto	+=	"EMPRESA"                     		         + CRLF    
	 
	endif

    cTexto		+=	Alltrim(XQRY->CPF)     		             	+ ";"      	// RA_CIC 
    cTexto		+=	Alltrim(XQRY->NOME_FUNCIONARIO) 	  		+ ";"      	// RA_NOME
    cTexto		+=	Alltrim(XQRY->DATA_ADMISSAO)	   			+ ";"       // SUBSTR(R7_DATA,7,2)||'/'||SUBSTR(R7_DATA,5,2)||'/'||SUBSTR(R7_DATA,1,4)
    cTexto		+=	Alltrim(XQRY->CODIGO_CARGO)   		        + ";"       // '01'||R7_FILIAL||R7_FUNCAO
	cTexto		+=	Alltrim(XQRY->NOME_CARGO)   		        + ";"       // '01'||R7_FILIAL||R7_FUNCAO
    cTexto		+=	Alltrim(XQRY->NOME_DEPARTAMENTO)      		+ ";"       // R7_DESCFUN NOME_CARGO,QB_DESCRIC
    cTexto		+=	Alltrim(XQRY->Empresa) 	        	    	+ CRLF     	// RA_NOME
 

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

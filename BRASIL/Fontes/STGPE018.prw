#include "topconn.ch"
#include "tbiconn.ch"
#include "protheus.ch"

/*/
{Protheus.doc} u_STGPE018

@author Igor Pedracolli
@since   06/05/2022

@obs - Historico Salarial.
/*/

User Function STGPE018(xEmp,xFil,xMin,xMax)

	Local cTexto	:=	""

	Local cQuery	:=	"Select * From SRACRM3 "
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
		cArquivo	:= 	SuperGetMv("ST_EXPSA18",.f.,"\system\temp\stgpe018.csv") 
	elseif !MsgYesNo("Deseja gerar o CSV ?")
		Return
	endif

	TcQuery ChangeQuery(@cQuery) New Alias "XQRY"

	do while XQRY->(!Eof())
		if	lPriVez
			lPriVez	:=	.f.
			cTexto	+= 	"CPF"	    					         	 + ";"
			cTexto	+= 	"NOME_FUNCIONARIO"	     	        		 + ";"
			cTexto	+=	"DATA_ALTERACAO"					    	 + ";"
			cTexto	+=  "SALARIO"        						     + ";"
			cTexto	+=	"TIPO_SALARIO"                 			   	 + ";"
			cTexto	+=	"CODIGO MOTIVO"                     		 + ";"
			cTexto	+=	"MOTIVO_DA_ALTERACAO_SALARIAL" 	  		     + ";"
			cTexto	+=	"JORNADA_TRABALHO"            				 + CRLF


		endif

		cTexto		+=	Alltrim(XQRY->CPF)     		             	+ ";"      	// RA_CIC
		cTexto		+=	Alltrim(XQRY->NOME_FUNCIONARIO) 	  		+ ";"      	// RA_NOME
		cTexto		+=	Alltrim(XQRY->DATA_ALTERACAO)	   			+ ";"       // R7_DATA

		If Alltrim(XQRY->Tipo_Salario) $ 'H'
			cTexto		+=	Alltrim(Str(XQRY->SALARIO*220))		   		+ ";"       // RA_SALARIO
		else
			cTexto		+=	Alltrim(Str(XQRY->SALARIO))	   				+ ";"       // RA_SALARIO
		EndIf

		//cTexto		+=	Alltrim(Str(XQRY->SALARIO))	   		        + ";"       // R2_SALARIO
		cTexto		+=	Alltrim(XQRY->TIPO_SALARIO)          		+ ";"       // RA_CATFUNC  -- ERRO SCHEDULE
		cTexto		+=	Alltrim(XQRY->CODIGO_MOTIVO) 	  	    	+ ";"      	// RA_NOME
		cTexto		+=	Alltrim(XQRY->MOTIVO_DA_ALTERACAO_SALARIAL) + ";"      	// RA_NOME
		cTexto		+=  Alltrim(Str(XQRY->JORNADA_TRABALHO))    	+ CRLF      // RA_HRSMES     //TRATAR  - cTexto +=	XQRY->Jornada_Trabalho	   + ";"

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

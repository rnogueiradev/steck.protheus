#Include "TOTVS.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
//BORDER POSITIONS
#DEFINE BORDER_POSITION_LEFT           	1
#DEFINE BORDER_POSITION_RIGHT          	2
#DEFINE BORDER_POSITION_TOP          	3
#DEFINE BORDER_POSITION_BOTTOM         	4

#DEFINE BORDER_POSITION_DIAGONAL_LEFT  	5
#DEFINE BORDER_POSITION_DIAGONAL_RIGHT 	6
                                         
//BORDER LINE STYLES
#DEFINE BORDER_LINE_CONTINUOUS    		1
#DEFINE BORDER_LINE_DOT                 2
#DEFINE BORDER_LINE_DASHDOT             3	
#DEFINE BORDER_LINE_DASHDOTDOT         	4 	
#DEFINE BORDER_LINE_SLANTDASHDOT       	5
#DEFINE BORDER_LINE_DOUBLE             	6
        
//ALIGN CELL                             
#DEFINE HORIZONTAL_ALIGN_RIGHT    		1
#DEFINE HORIZONTAL_ALIGN_CENTER    		2
#DEFINE HORIZONTAL_ALIGN_LEFT    		3

#DEFINE VERTICAL_ALIGN_TOP    			1
#DEFINE VERTICAL_ALIGN_CENTER    		2
#DEFINE VERTICAL_ALIGN_BOTTOM			3

//FORMAT STYLES
//NUMBER
#DEFINE NUMBER_CURRENCY_REAL    		1
#DEFINE NUMBER_CURRENCY_RED_REAL        2
#DEFINE NUMBER_CURRENCY_HORA	        3
#DEFINE NUMBER_CURRENCY_DATA	        4
#DEFINE NUMBER_CURRENCY_NUMERO          5
#DEFINE NUMBER_PERC						6
#DEFINE ENTER chr(13)+chr(10)
/*
Campos No Standard usados

A2_XTPCTAB	C	20	Tipo Cta Bco	Tipo de cuenta Bancaria	@!	Vazio() .or. Pertence("01/02/19/52")		01=Corriente;02=Ahorro;
A2_XCTABCO	C	150	Cta Bancaria	Numero Cuenta Bancaria	@!			
A2_XCODBCO	C	40	Cod BcoCITIBANK	Cod Banco en el CITIBANK	@!	Vazio() .or. ValidF3I("U002", M->A2_XCODBCO,1,4) .or. .T.	COLU02	
EK_XTXT	    L	10	Txt Generado	Txt Generado	@!	
EK_XTXFEH	F	8	Fecha TXT	TXT Fecha		
EK_XTXTIM	C	5	Hora TXT	Hora TXT		



*/
/*/{Protheus.doc} TXTCITI
description
@type function
@version  
@author 
@since 10/2023
@return variant, return_description
/*/
User Function TXTCITI()
Return Nil

/*/{Protheus.doc} TXTRANSF
description
@type function
@version  
@author 
@since 10/2023
@return variant, return_description
/*/
User Function TXTRANSF()
	Private cPerg := "TXTCITBAK"
	AjustaSX1(cPerg)
	If Pergunte(cPerg,.T.)
		MsgRun( "Espere, Leyendo información de pagos ..." ,, {|| U_cTXTRANSF() } )
	EndIf
Return Nil

/*/{Protheus.doc} 2TXTRANSF
description
@type function
@version  
@author 
@since 10/2023
@return variant, return_description
/*/
User Function cTXTRANSF()
	Local aCpos 	:= {}
	Local aCampos 	:= {}
	Local aCores  	:= {}
	Local cQry1		:= ""
	Local cQry2		:= ""
	Local cQry3		:= ""	
	Local _cAlias	:= GetNextAlias()
	Local _cAlias2	:= GetNextAlias()
	Local _cAlias3	:= GetNextAlias()
	Local _cOPs		:= ""
	Local nForJ		:= 0
	Private aRotina 	:= {}
	Private cCadastro 	:= "Genera Pago Masivo Banco CITIBANK Colombia"
	Private cMarcaSE2   := GetMark()
	Private aTotales	:= {}
	Private aOrdenes	:= {}
	Private _cTipos		:= ""
	Private aCodBcoCIT	:= {}
	//Private aTipDocCIT	:= {}
	Private aTipCtaCIT  := {{"01","01-Corriente"},{"02","02-Ahorro"}}
	
	_cTipos := Alltrim(MV_PAR05)
	_cTipos := "'"+Replace(_cTipos,"/","','")+"'"
	//_cTipos := Substr(_cTipos,1,Len(_cTipos)-2)
	//AAdd( aCores , { "TXEMP->EK_XTXT==.T. .AND. TXEMP->E2_BAIXA <> STOD('  /  /    ')" , "BR_VERMELHO"	,"OP Debitada"	} )             //OP Debitada
	AAdd( aCores , { "TXEMP->EK_XTXT==.T. " , "BR_VERMELHO"	,"OP Generada en Archivo"	} ) //OP Generada en Archivo
	AAdd( aCores , { "TXEMP->EK_XTXT==.F. " , "BR_VERDE"	,"OP Sin Generar"	} ) 		//OP Sin Generar

	If Select("TRB") > 0
		TRB->( dbCloseArea() )
	End

	// Tabla temporal a crear
	cQry1 += "SELECT " +CRLF
	cQry1 += " EK_ORDPAGO,EK_BANCO,EK_AGENCIA,EK_CONTA, E2_NUM, E2_TIPO,"+CRLF
	cQry1 += " EK_VALOR,EK_EMISSAO,EK_VENCTO,"+CRLF
	cQry1 += " EK_FORNEPG,EK_MOEDA,EK_XTXT,"+CRLF
	cQry1 += " EK_LOJAPG,EK_SALDO,"+CRLF
	cQry1 += " EK_TIPO,E2_BAIXA,E2_NOMFOR,A2_NOME,"+CRLF
	cQry1 += " A2_XCTABCO,A2_XTPCTAB,A2_XCODBCO, "+CRLF
	cQry1 += " CASE WHEN A2_TIPDOC='31' THEN A2_CGC ELSE A2_PFISICA END A2_IDFORNE, "+CRLF
	cQry1 += " A2_TIPDOC,A2_CGC,A2_PFISICA, "+CRLF
	cQry1 += " A2_EMAIL,A2_CONTATO, SEK.R_E_C_N_O_ EKRECNO, "+CRLF
	cQry1 += " (EK_FILIAL || EK_ORDPAGO || EK_TIPODOC || EK_PREFIXO || EK_NUM || EK_PARCELA || EK_TIPO || EK_SEQ) EK_INDICE, "+CRLF
	cQry1 += " EK_VLMOED1,EK_NUM, A2_END,A2_MUN,A2_EST,A2_TEL, EK_PREFIXO "+CRLF
	cQry1 += "FROM "+RetSQLName('SEK')+" SEK "+CRLF
	cQry1 += "LEFT JOIN "+ RetSQLName('SE2') + " SE2 ON EK_ORDPAGO=E2_ORDPAGO AND EK_TIPO=E2_TIPO "+CRLF
	cQry1 += " AND EK_NUM=E2_NUM AND SE2.D_E_L_E_T_<>'*' AND E2_FILIAL='"+xFilial("SE2")+"' "+CRLF
	cQry1 += "LEFT JOIN "+ RetSQLName('SA2') + " SA2 ON EK_FORNEPG=A2_COD AND "
	cQry1 += " EK_LOJAPG=A2_LOJA AND SA2.D_E_L_E_T_<>'*' AND A2_FILIAL='"+xFilial("SA2")+"' "+CRLF
	cQry1 += "WHERE EK_FILIAL ='"+xFilial("SEK")+"'"+CRLF
	//cQry1 += " AND EK_VENCTO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'"+CRLF
	cQry1 += " AND EK_TIPODOC='CP'"+CRLF
	cQry1 += " AND EK_BANCO='"+MV_PAR06+"'"+CRLF
	cQry1 += " AND A2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+CRLF
	cQry1 += " AND EK_CANCEL<>'T'"+CRLF
	cQry1 += " AND EK_MOEDA='1'"+CRLF	
	cQry1 += " AND SEK.D_E_L_E_T_ <>'*' "+CRLF
	
	

	If MV_PAR05==1								// NO Generados + generados del dia
		cQry1 += " AND ((EK_XTXFEH='"+DTOS(DDATABASE)+"' AND EK_XTXT='T') OR ((EK_VENCTO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"')"+" AND (EK_XTXT='F')))"
	ElseIf MV_PAR05==2							// Generados
		cQry1 += " AND ((EK_XTXT='T')AND (EK_VENCTO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'))" 
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),_cAlias,.T.,.T.)
	_cOPs := "'"
	While (_cAlias)->( !Eof() )
		Aadd( aTotales, { (_cAlias)->EK_ORDPAGO,(_cAlias)->EK_VALOR,(_cAlias)->EK_INDICE,"",(_cAlias)->EK_XTXT } )
		Aadd( aOrdenes, { ;
				(_cAlias)->EK_ORDPAGO,;  	//1
				(_cAlias)->EK_FORNEPG,;  	//2
				(_cAlias)->EK_VALOR,;  		//3
				(_cAlias)->EK_EMISSAO,;  	//4
				(_cAlias)->EK_VENCTO,;  	//5
				(_cAlias)->EK_MOEDA,;  		//6
				(_cAlias)->EK_XTXT,;  		//7
                "----------",;              //8
				(_cAlias)->EK_LOJAPG,;  		//9
				(_cAlias)->EK_BANCO,;		//10
				(_cAlias)->EK_AGENCIA,;		//11
				(_cAlias)->EK_CONTA,;		//12
				(_cAlias)->EK_TIPO,;		//13
				(_cAlias)->EK_NUM,;			//14
				(_cAlias)->E2_BAIXA,;		//15
				(_cAlias)->EK_SALDO,;		//16
				FwNoAccent((_cAlias)->A2_NOME),;		//17
				(_cAlias)->A2_XCTABCO,;		//18
				"-----",;					//19
				(_cAlias)->A2_XTPCTAB,;		//20
                "----------",;              //21
				(_cAlias)->A2_XCODBCO,;		//22
				(_cAlias)->A2_IDFORNE,;		//23
				(_cAlias)->A2_EMAIL,;		//24
				(_cAlias)->A2_CONTATO,;		//25
				(_cAlias)->EKRECNO,;		//26
				(_cAlias)->EK_INDICE,;		//27
				(_cAlias)->A2_TIPDOC,;		//28 <-- Agregados
				(_cAlias)->A2_CGC,;			//29 <-- Agregados
				(_cAlias)->A2_PFISICA,;		//30 <-- Agregados
				(_cAlias)->EK_VLMOED1,;		//31 <-- Agregados
				FwNoAccent((_cAlias)->A2_END),;	//32 <-- Agregados		
				FwNoAccent((_cAlias)->A2_MUN),;	//33 <-- Agregados		
				(_cAlias)->A2_EST,;			//34 <-- Agregados		
				(_cAlias)->A2_TEL,;			//35 <-- Agregados	
				(_cAlias)->EK_PREFIXO;		//36 <-- Agregados	
				})
		(_cAlias)->( dbSkip() )
	End
	(_cAlias)->( dbCloseArea() )




	cQry3 += "SELECT SUBSTR(F3I_CONTEU,1,3) AS COD, SUBSTR(F3I_CONTEU,4,40) AS BANCO, TRIM(SUBSTR(F3I_CONTEU,1,3)) + '.' + SUBSTR(F3I_CONTEU,4,40) AS CODB "
	cQry3 += "FROM "+RetSQLName('F3I')+" F3I "+CRLF
	cQry3 += "WHERE F3I_FILIAL ='"+xFilial("F3I")+"'"+CRLF
	cQry3 += "AND F3I.D_E_L_E_T_ <>'*' "+CRLF
	cQry3 += "AND F3I_CODIGO='U002' "+CRLF

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry3),_cAlias3,.T.,.T.)
	While (_cAlias3)->( !Eof() )
		aAdd(aCodBcoCIT,{(_cAlias3)->COD,(_cAlias3)->BANCO,(_cAlias3)->CODB})	
		(_cAlias3)->( dbSkip() )
	End
	(_cAlias3)->( dbCloseArea() )

	If Select("TRB") > 0
		TRB->( dbCloseArea() )
	EndIf
	If Select("TXEMP") > 0
		TXEMP->( dbCloseArea() )
	EndIf
	aStruct := {}

	cArq := CriaTrab(Nil,.F.)
	AAdd( aStruct,{ "E2_OK"				,"C",02						,0	} )
	AAdd( aStruct,{ "E2_NUM"	   		,"C",TamSX3("E2_NUM")[1]	,0	} )
	AAdd( aStruct,{ "E2_TIPO"			,"C",TamSX3("E2_TIPO")[1]	,0	} )
	AAdd( aStruct,{ "E2_FORNECE"		,"C",TamSX3("E2_FORNECE")[1],0	} )
	AAdd( aStruct,{ "E2_LOJA"			,"C",TamSX3("E2_LOJA")[1]	,0	} )
	AAdd( aStruct,{ "E2_NOMFOR"			,"C",TamSX3("E2_NOMFOR")[1]	,0	} )
	AAdd( aStruct,{ "EK_SALDO"			,"N",TamSX3("EK_SALDO")[1]	,2	} )
	AAdd( aStruct,{ "E2_ORDPAGO"		,"C",TamSX3("E2_ORDPAGO")[1],0	} )
	AAdd( aStruct,{ "E2_EMISSAO"		,"D",TamSX3("E2_EMISSAO")[1],0	} )
	AAdd( aStruct,{ "E2_VENCTO"			,"D",TamSX3("E2_VENCTO")[1]	,0	} )
	AAdd( aStruct,{ "E2_VALOR"			,"N",TamSX3("E2_VALOR")[1]	,2	} )
	AAdd( aStruct,{ "EK_XTXT"			,"L",01						,0	} )

	AAdd( aStruct,{ "E2_MOEDA"			,"C",TamSX3("E2_MOEDA")[1]	,0	} )
	AAdd( aStruct,{ "EK_BANCO"			,"C",TamSX3("EK_BANCO")[1]	,0	} )
	AAdd( aStruct,{ "EK_AGENCIA"		,"C",TamSX3("EK_AGENCIA")[1],0	} )
	AAdd( aStruct,{ "EK_CONTA"			,"C",TamSX3("EK_CONTA")[1]	,0	} )
	AAdd( aStruct,{ "EK_TIPO"			,"C",TamSX3("EK_TIPO")[1]	,0	} )
	AAdd( aStruct,{ "EK_NUM"			,"C",TamSX3("EK_NUM")[1]	,0	} )
	AAdd( aStruct,{ "E2_BAIXA"			,"D",TamSX3("E2_BAIXA")[1]	,0	} )

	AAdd( aStruct,{ "A2_XTPID"			,"C",5	,0	} )  // No VA

	AAdd( aStruct,{ "A2_XTPCTAB"		,"C",TamSX3("A2_XTPCTAB")[1],0	} ) // Tipo Cta Bco	Tipo de cuenta Bancaria
	AAdd( aStruct,{ "A2_XCTABCO"		,"C",TamSX3("A2_XCTABCO")[1],0	} ) // Cta Bancaria	Numero Cuenta Bancaria
	AAdd( aStruct,{ "A2_XCODBCO"		,"C",TamSX3("A2_XCODBCO")[1],0	} ) // Cod BcoCITIBANK	Cod Banco en el CITIBANK
	AAdd( aStruct,{ "A2_IDFORNE"		,"C",TamSX3("A2_PFISICA")[1],0	} )
	AAdd( aStruct,{ "A2_EMAIL"			,"C",TamSX3("A2_EMAIL")[1],0	} )
	AAdd( aStruct,{ "A2_CONTATO"		,"C",TamSX3("A2_CONTATO")[1],0	} )
	AAdd( aStruct,{ "EKRECNO"			,"N",12,0						} ) 
	AAdd( aStruct,{ "A2_TIPDOC"			,"C",TamSX3("A2_TIPDOC")[1],0	} ) // <--- Agregados TIPO DOocumento NIT=31
	AAdd( aStruct,{ "A2_CGC"			,"C",TamSX3("A2_CGC")[1],0		} ) // <--- Agregados NIT
	AAdd( aStruct,{ "A2_PFISICA"		,"C",TamSX3("A2_PFISICA")[1],0	} ) // <--- Agregados Cedula
	AAdd( aStruct,{ "EK_VLMOED1"		,"N",TamSX3("EK_VLMOED1")[1],2	} ) // <--- Valor en Moneda 1
	AAdd( aStruct,{ "A2_END"			,"C",TamSX3("A2_END")[1],0		} ) // <--- Agregados Cedula
	AAdd( aStruct,{ "A2_MUN"			,"C",TamSX3("A2_MUN")[1],0		} ) // <--- Agregados Municipio
	AAdd( aStruct,{ "A2_EST"			,"C",TamSX3("A2_EST")[1],0		} ) // <--- Agregados Estado
	AAdd( aStruct,{ "A2_TEL"			,"C",TamSX3("A2_TEL")[1],0		} ) // <--- Agregados Telefono
	AAdd( aStruct,{ "EK_PREFIXO"		,"C",TamSX3("EK_PREFIXO")[1],0	} ) // <--- Agregados pREFIJO fAC

	nLongIndice:= 	TamSX3("EK_FILIAL")[1]+ TamSX3("EK_ORDPAGO")[1]+TamSX3("EK_TIPODOC")[1]+;
					TamSX3("EK_PREFIXO")[1]+TamSX3("EK_NUM")[1]+ 	TamSX3("EK_PARCELA")[1]+;
					TamSX3("EK_TIPO")[1]+TamSX3("EK_SEQ")[1]
	AAdd( aStruct,{ "EK_INDICE"			,"C",nLongIndice,0			} ) 

	DbCreate(cArq , aStruct )
	DbUseArea(.T. ,, cArq ,"TXEMP",.T.,.F.)
	IndRegua("TXEMP" , cArq ,"E2_ORDPAGO",,,"Indexando registros ..." , .T. )

	For nForJ := 1 to Len( aOrdenes )

		cQry1 := " SELECT E2_OK,E2_ORDPAGO,E2_NUM,E2_PREFIXO,E2_TIPO,R_E_C_N_O_ "+CRLF
		cQry1 += "   FROM "+RetSQLName('SE2')+CRLF
		cQry1 += "  WHERE E2_FILIAL ='"+xFilial("SE2")+"'"+CRLF
		cQry1 += " AND E2_ORDPAGO='" + aOrdenes[nForJ][1] + "'"+CRLF
		cQry1 += " AND E2_FORNECE='" + aOrdenes[nForJ][2] + "'"+CRLF
		cQry1 += " AND E2_LOJA='" + aOrdenes[nForJ][9] + "'"+CRLF
		cQry1 += " AND D_E_L_E_T_ <>'*' "+CRLF

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),"TRB",.T.,.T.)

		cNums := " "
		cTips := " "

		If TRB->( !Eof() )
			While TRB->( !Eof() )
				cNums := cNums + Alltrim(TRB->E2_NUM)+"/"
				cTips := cTips + Alltrim(TRB->E2_TIPO)+"/"
				TRB->( dbSkip() )
			End
		EndIf

		If Select("TRB") > 0
			TRB->( dbCloseArea() )
		EndIf


		TXEMP->( RecLock("TXEMP",.T.) )
		TXEMP->E2_OK			:= Space(2)
		TXEMP->E2_NUM	 		:= cNums
		TXEMP->E2_TIPO			:= cTips
		TXEMP->E2_FORNECE		:= aOrdenes[nForJ][2]
		TXEMP->E2_LOJA			:= aOrdenes[nForJ][9]
		TXEMP->E2_NOMFOR		:= aOrdenes[nForJ][17]
		TXEMP->E2_ORDPAGO		:= aOrdenes[nForJ][1]
		TXEMP->E2_EMISSAO		:= Stod(aOrdenes[nForJ][4])
		TXEMP->E2_VENCTO		:= Stod(aOrdenes[nForJ][5])
		TXEMP->E2_VALOR			:= aOrdenes[nForJ][3]
		TXEMP->E2_MOEDA			:= aOrdenes[nForJ][6]
		TXEMP->EK_XTXT			:= if(aOrdenes[nForJ][7]=="F",.F.,.T.)
		TXEMP->EK_SALDO			:= aOrdenes[nForJ][16]
		TXEMP->EK_BANCO			:= aOrdenes[nForJ][10]  // Codigo Banco Origen
		TXEMP->EK_AGENCIA		:= aOrdenes[nForJ][11]  //Codigo Agencia Origen
		TXEMP->EK_CONTA			:= aOrdenes[nForJ][12]  //Num cuenta Bancaria Origen
		TXEMP->E2_BAIXA			:= Stod(aOrdenes[nForJ][15])
		TXEMP->A2_XCTABCO		:= aOrdenes[nForJ][18]  // Cta Bancaria	Numero Cuenta Bancaria
		TXEMP->A2_XTPID			:= aOrdenes[nForJ][19]  // NO VA
		TXEMP->A2_XTPCTAB		:= aOrdenes[nForJ][20]  // Tipo Cta Bco	Tipo de cuenta Bancaria 
		TXEMP->A2_XCODBCO		:= aOrdenes[nForJ][22]  // Cod BcoCITIBANK	Cod Banco en el CITIBANK
		TXEMP->A2_IDFORNE		:= aOrdenes[nForJ][23]
		TXEMP->A2_EMAIL			:= aOrdenes[nForJ][24]
		TXEMP->A2_CONTATO		:= aOrdenes[nForJ][25]
		TXEMP->EKRECNO			:= aOrdenes[nForJ][26]
		TXEMP->EK_INDICE		:= aOrdenes[nForJ][27]

		TXEMP->A2_TIPDOC		:= aOrdenes[nForJ][28] // <--- Agregados
		TXEMP->A2_CGC			:= aOrdenes[nForJ][29] // <--- Agregados
		TXEMP->A2_PFISICA		:= aOrdenes[nForJ][30] // <--- Agregados
		TXEMP->EK_VLMOED1		:= aOrdenes[nForJ][31] // <--- Agregados
		TXEMP->EK_NUM			:= aOrdenes[nForJ][14] // <--- Agregados
		TXEMP->A2_END			:= aOrdenes[nForJ][32] // <--- Agregados
		TXEMP->A2_MUN			:= aOrdenes[nForJ][33] // <--- Agregados
		TXEMP->A2_EST			:= aOrdenes[nForJ][34] // <--- Agregados
		TXEMP->A2_TEL			:= aOrdenes[nForJ][35] // <--- Agregados
		TXEMP->EK_PREFIXO		:= aOrdenes[nForJ][36] // <--- Agregados
		TXEMP->( MsUnLock() )
	Next nForJ

	DbSelectArea("TXEMP")
if MV_PAR05==1
	AADD(aRotina,{"Generar Excel"	,"U_ExecTRANF(2)"	,0,2})
	AADD(aRotina,{"Generar TXT"		,"U_ExecTRANF(1)"	,0,3})
	AADD(aRotina,{"Verif.Totales"	,"U_adpVeTot"		,0,3})
	AADD(aRotina,{"Leyenda"			,"U_LEYCITA1"		,0,3})
ELSE
	AADD(aRotina,{"Verif.Totales"	,"U_adpVeTot"		,0,3})
	AADD(aRotina,{"Leyenda"			,"U_LEYCITA1"		,0,3})
ENDIF
	AADD(aCpos, "E2_OK" )
	//AAdd(aCpos, {"E2_OK",  .T.})
	aCampos := {}

	AAdd( aCampos,{ "E2_OK"				,"","",					"@!"				} )
	AAdd( aCampos,{ "E2_ORDPAGO"		,"","Orden Pago",		"@!"				} )
	AAdd( aCampos,{ "E2_NUM"			,"","Num.Titulo",		"@!"				} )
	AAdd( aCampos,{ "E2_TIPO"			,"","Tipo",				"@!"				} )
	AAdd( aCampos,{ "E2_FORNECE"		,"","Proveedor",		"@!"				} )
	AAdd( aCampos,{ "E2_LOJA"			,"","Tienda",			"@!"				} )
	AAdd( aCampos,{ "E2_NOMFOR"			,"","Nombre Proveedor",	"@!"				} )
	AAdd( aCampos,{ "E2_EMISSAO"		,"","Emision",			"@!"				} )
	AAdd( aCampos,{ "E2_VENCTO"			,"","Vencimiento",		"@!"				} )
	AAdd( aCampos,{ "E2_VALOR"			,"","Valor",			"999,999,999,999.99"} )
	AAdd( aCampos,{ "A2_XTPCTAB"		,"","Tipo Cta Bco",		"@!"				} )  //Charater 2	Tipo Cta Bco	X3_CBOX -> 01=Corriente;02=Ahorro   
	AAdd( aCampos,{ "A2_XCTABCO"		,"","Cta Bancaria",		"@!"				} )  //cHARACTER 12 Cta Banco
	AAdd( aCampos,{ "A2_XCODBCO"		,"","Cod BcoCiti",		"@!"				} )
	AAdd( aCampos,{ "A2_EMAIL"			,"","eMail",			"@!"				} )
	AAdd( aCampos,{ "A2_CONTATO"		,"","Contacto",			"@!"				} )

	MarkBrow("TXEMP",aCpos[1],,aCampos,,cMarcaSE2,/*"U_MarkCIT1()"*/,,,,'u_MarkCIT2()',,,,aCores)
//  MarkBrow ( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 [ aColors ] [ uPar16 ] )
Return

/*/{Protheus.doc} GETMOEDA
description
@type function
@version  
@author 
@since 10/2023
@param cCuenta, character, param_description
@return variant, return_description
/*/
Static Function GETMOEDA(cCuenta)
	Local x_area	:= getArea()
	Local nMoeda	:= 0
	Local cQry2		:= ""
	Local cSQL2		:= GetNextAlias()

	cQry2 := "SELECT A6_MOEDA "
	cQry2 += "  FROM " + RetSqlName("SA6")
	cQry2 += " WHERE A6_FILIAL='"+xFilial("SA6")+"'"
	cQry2 += "   AND A6_NUMCON='"+ALLTRIM(cCuenta)+"'"
	cQry2 += "   AND D_E_L_E_T_<>'*'"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry2),cSQL2,.T.,.T.)

	nMoeda := (cSQL2)->A6_MOEDA

	(cSQL2)->( dbCloseArea() )

	RestArea( x_area )
Return(nMoeda)

/*/{Protheus.doc} MarkCIT1
description
@type function
@version  
@author 
@since 10/2023
@return variant, return_description
/*/
User Function MarkCIT1()
	Local aArea  := GetArea()
	Local lMarca := Nil
	Local nX:=0
	TXEMP->( dbGotop() )
	While TXEMP->( !Eof() )
		If (lMarca == Nil)
			lMarca := (TXEMP->E2_OK == cMarcaSE2)
		EndIf
		TXEMP->( RecLock("TXEMP",.F.) )

        if lMarca .AND.(TXEMP->EK_XTXT==.F.)
           //TXEMP->E2_OK := If( lMarca,"",cMarcaSE2 )
		   TXEMP->E2_OK := ""

		elseif !(lMarca) .AND.(TXEMP->EK_XTXT==.F.)
		    TXEMP->E2_OK := cMarcaSE2 
		endif	   
		TXEMP->( MsUnLock() )

		For nX:=1 To len(aTotales)
			If aTotales[nX][3]==TXEMP->EK_INDICE.AND.(TXEMP->EK_XTXT==.F.)
				aTotales[nX][4]:=If( lMarca,"",cMarcaSE2 )
			EndIf
		Next

		TXEMP->( dbSkip() )
	EndDo

	RestArea(aArea)
	MarkBRefresh()
	CloseBrowse()
Return Nil


/*/{Protheus.doc} ExecTRANF
description
@type function
@version  
@author 
@since 10/2023
@param _op, variant, param_description
@return variant, return_description
/*/
User Function ExecTRANF(_op)
	Local aPagos	:= {}
	Local cResultado:= ""
	Local nPos1		:= 0
	Local nPos2		:= 0
	Local nPos3		:= 0
	Local nPos4		:= 0
	Local cPos1,cPos2,cPos3,cPos4:=''
	Local cHora     := GETMV("CO_CITITIME")
	TXEMP->( dbGotop() )

	While TXEMP->( !Eof() )
		If !Empty(TXEMP->E2_OK).OR.(TXEMP->EK_XTXT==.T.)

		    IF TIME()>cHora
			   cResultado	:= "Se encuentra fuera de la hora limite de generación de archivo TXT "+ ENTER
			END IF
			If EMPTY(TXEMP->A2_XCTABCO) .or. EMPTY(TXEMP->A2_XTPCTAB) .or. EMPTY(TXEMP->A2_XCODBCO)
				cResultado	+=	"Proveedor " +  alltrim(TXEMP->E2_FORNECE) + " Sin Número, tipo o Codigo de Banco registrado " + ENTER
			ENDIF
			IF empty(TXEMP->A2_IDFORNE)
				cResultado	+=	"Proveedor " +  alltrim(TXEMP->E2_FORNECE) + " sin Documento ID/NIT registrado" + ENTER
			EndIf

			nPos1 := 0 //aScan(aTipDocCIT, {|x| AllTrim(Upper(x[1])) == ALLTRIM(TXEMP->A2_XTPID)})    //
			nPos2 := aScan(aCodBcoCIT, {|x| AllTrim(Upper(x[1])) == ALLTRIM(TXEMP->A2_XCODBCO)})  // Cod Banco de la lista de Citibank
			nPos3 := aScan(aTipCtaCIT, {|x| AllTrim(Upper(x[1])) == ALLTRIM(TXEMP->A2_XTPCTAB)})  // Tipo Cuenta Ahorro Corriente
			nPos4 := 0 //aScan(aTipPagCIT, {|x| AllTrim(Upper(x[1])) == ALLTRIM(TXEMP->xxxxxxxxxA2_XTPPAGO)})
			cPos1 := " " //If(nPos1==0,' ',aTipDocCIT[nPos1][3])
			cPos2 := If(nPos2==0,' ',aCodBcoCIT[nPos2][3])
			cPos3 := If(nPos3==0,' ',aTipCtaCIT[nPos3][2])
			cPos4 := " " //If(nPos4==0,' ',aTipPagCIT[nPos4][2])
			Aadd(aPagos,;
				{TXEMP->E2_NUM			,;	//01	TITULO
				TXEMP->E2_FORNECE		,;	//02	PROVeedor
				TXEMP->E2_NOMFOR		,;	//03	nombre proveedor
				AllTrim(Transform(((TXEMP->E2_VALOR)),"@E 99999999999999.99")),;	//IMPORTE
				TXEMP->A2_XCTABCO		,;	//05	CUENTA ABONO
				TXEMP->EK_XTXT			,;  //06	FLAG ENVIO A BANCO
				TXEMP->E2_LOJA			,;	//07	TIENDA
				" "						,;	//08	SERIE ORIGEN
				TXEMP->E2_MOEDA			,;	//09	MONEDA
				" "						,;	//PREFIJO
				TXEMP->E2_ORDPAGO		,;	//11	ORDEN DE PAGO
				TXEMP->A2_XTPID			,;	//12	Tipo Doc ID CITA
				TXEMP->A2_XTPCTAB		,;	//13	Tipo Cta Bco	X3_CBOX -> 01=Corriente;02=Ahorro
				" "                     ,;  //14 
				TXEMP->A2_XCODBCO		,;	//15	Cod Banco en Colombia
				TXEMP->A2_EMAIL			,;	//16	EMail 
				TXEMP->A2_CONTATO		,;  //17	Contacto
				TXEMP->A2_IDFORNE		,;	//18	# Documento
				TXEMP->EKRECNO			,;	//19	rECNO sek
				cPos1					,;  //20    VACIO
				cPos2					,;	//21    Cod Banco de la lista de Citibank
				cPos3					,;	//22    Tipo Cuenta Ahorro Corriente
				cPos4					,;	//23    VACIO
				TXEMP->EK_INDICE		,;	//24
				TXEMP->A2_TIPDOC		,;  //25    tipo de Doc (31=nit)
				TXEMP->A2_CGC			,;  //26    nit
				TXEMP->A2_PFISICA		,;	//27	Cédula
				TXEMP->EK_BANCO			,;	//28	Codigo Banco Origen
				TXEMP->EK_AGENCIA		,;	//29	Codigo Agencia Origen
				TXEMP->EK_CONTA			,;	//30	Num cuenta Bancaria Origen
				TXEMP->EK_VLMOED1		,;	//31	Vlr Mda.Est.
				TXEMP->EK_NUM			,;	//32 	Num titulo
				TXEMP->A2_END			,;	//33 	Direccion
				TXEMP->A2_MUN			,;	//34 	Municipio
				TXEMP->A2_EST			,;	//35	Estado
				TXEMP->A2_TEL			,;	//36 	Telefono
				TXEMP->E2_TIPO			,;	//37 	Tipo	
				TXEMP->EK_PREFIXO		;	//38	Prefijo Factura	
				})			
		EndIf
		TXEMP->( dbSkip() )
	End

	If ALLTRIM( cResultado ) <> ""
		cResultado += ENTER + "Verifique antes de generar el archivo ..."
		mensaje(cResultado, "Inconsistencias encontradas ")
	Else
		CONFIRMA(aPagos,_op)
	EndIf
	MarkBRefresh()
	CloseBrowse()
Return Nil


STATIC Function Mensaje(cMensaje, ctitulo)
	Local cObserva := cMensaje
	Local oDlgMsj

	define msDialog oDlgMsj title ctitulo from 00,00 to 400,600 pixel
	@ 003,003 GET oObserva VAR cObserva OF oDlgMsj MULTILINE SIZE 280,160 COLORS 0, 16777215 NO VSCROLL PIXEL
	@ 180, 250 BUTTON oBtCerrar PROMPT "Cerrar" SIZE 037, 012 OF oDlgMsj ACTION oDlgMsj:End() PIXEL
	ACTIVATE MSDIALOG oDlgMsj CENTERED
RETURN


User Function MarkCIT2()
	Local nX:=0
	If IsMark( 'E2_OK', cMarcaSE2 ).AND.(TXEMP->EK_XTXT==.F.)
		TXEMP->( RecLock( 'TXEMP', .F. ) )
		TXEMP->E2_OK := Space(2)
		TXEMP->( MsUnLock() )
		For nX:=1 To len(aTotales)
			If aTotales[nX][3]==TXEMP->EK_INDICE.AND.(TXEMP->EK_XTXT==.F.)
			   aTotales[nX][4]:=Space(2)
			EndIf
		Next
	Elseif !(IsMark( 'E2_OK', cMarcaSE2 )).AND.(TXEMP->EK_XTXT==.F.)
		
		TXEMP->( RecLock( 'TXEMP', .F. ) )
		TXEMP->E2_OK := cMarcaSE2
		TXEMP->( MsUnLock() )
		For nX:=1 To len(aTotales)
			If aTotales[nX][3]==TXEMP->EK_INDICE.AND.(TXEMP->EK_XTXT==.F.)
			   aTotales[nX][4]:=cMarcaSE2
			EndIf
		Next		
	EndIf
Return


Static Function GraEXC(nSum, nCantidad, nChecksum, aPagos)
	//Local cFehLimit := if(EMPTY(DTOS(MV_PAR06)),u_adpDTOSS(dDataBase),u_adpDTOSS(MV_PAR06))
	Local _cTime	:= Time()
	//Local cFileName:="CITA_"+DTOS(dDataBase)+"_H"+SUBSTR(_cTime,1,2)+"M"+SUBSTR(_cTime,4,2)+"S"+SUBSTR(_cTime,7,2)+".XML"
	Local cFileName	:= "CITI_STECKCOL"+DTOS(dDataBase)+".XML"
	Local lWriteDb := .T.
	Local cDestPath:="C:\TOTVS\"//GETMV("CO_CITIDIR")
	Local oExlXlsx := Nil
	Local lRet := .T.
	//Local cPasta := "c:\spool\" //GetSrvProfString("RootPath","") + "\spool\"
	Local oOpnXlsx := Nil	
	Local nForJ := 0 

	oExlXlsx := FwMsExcelXlsx():New()
	//Habilita dados de processamento no BD e com Bulk ocorrendo com até 200 mil registros.
	lWriteDb := oExlXlsx:SetWriteinDb(.T., 200000)
	
	If !lWriteDb
		conout("Não foi possível habilitar o recurso de dados em disco, o processamento consumirá a memória do servidor.")
	EndIf

	
	lRet := oExlXlsx:IsWorkSheet("Hoja01")
	// FwMsExcelXlsx():AddWorkSheet(< cWorkSheet >)
	oExlXlsx:AddworkSheet("Hoja01")
	lRet := oExlXlsx:IsWorkSheet("Hoja01")
	// FwMsExcelXlsx():AddTable(< cWorkSheet >, < cTable >)
	oExlXlsx:AddTable ("Hoja01","Hoja de Pagos (Adaptacion)")
	// FwMsExcelXlsx():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, [< nAlign >], [< nFormat >], [< lTotal >], [ < cPicture >])
	oExlXlsx:AddColumn("Hoja01","Hoja de Pagos (Adaptacion)","Tipo"				,1,1,.F., "")
	oExlXlsx:AddColumn("Hoja01","Hoja de Pagos (Adaptacion)","Orden Pago"		,1,1,.F., "")
	oExlXlsx:AddColumn("Hoja01","Hoja de Pagos (Adaptacion)","Num Titulo"		,1,1,.F., "")
	oExlXlsx:AddColumn("Hoja01","Hoja de Pagos (Adaptacion)","Numero Id"		,1,1,.F., "")
	oExlXlsx:AddColumn("Hoja01","Hoja de Pagos (Adaptacion)","Nombre"			,1,1,.F., "")	
	oExlXlsx:AddColumn("Hoja01","Hoja de Pagos (Adaptacion)","Tipo Cta"			,1,1,.F., "")
	oExlXlsx:AddColumn("Hoja01","Hoja de Pagos (Adaptacion)","Numero Cta"		,1,1,.F., "")
	oExlXlsx:AddColumn("Hoja01","Hoja de Pagos (Adaptacion)","Banco"			,1,1,.F., "")
	oExlXlsx:AddColumn("Hoja01","Hoja de Pagos (Adaptacion)","eMail"			,1,1,.F., "")			
	oExlXlsx:AddColumn("Hoja01","Hoja de Pagos (Adaptacion)","Tipo de Pago"		,1,1,.F., "")
	oExlXlsx:AddColumn("Hoja01","Hoja de Pagos (Adaptacion)","Importe($)"		,3,2,.F., "99999999999999.9999")
	//oExlXlsx:AddColumn("Hoja01","Hoja de Pagos (Adaptacion)","Fecha Limite"		,1,4,.F., "")

	If nReg >= 1
		For nForJ := 1 to nReg
			oExlXlsx:AddRow("Hoja01","Tabela_01",{;
			aPagos[nForJ][20],;  // Tipo Id
			aPagos[nForJ][11],;  // Orden de Pago
			aPagos[nForJ][01],;  // Num Titulo
			aPagos[nForJ][18],;  // Numero Id
			aPagos[nForJ][03],;  // Nombre
			aPagos[nForJ][22],;	 // Tipo Cuenta
			aPagos[nForJ][05],;	 // Numero Cuenta
			aPagos[nForJ][15],;	 // Banco
			aPagos[nForJ][16],;	 // EMail			
			aPagos[nForJ][23],;	 // Tipo Pago
		    aPagos[nForJ][04];	 // Valor cFehLimit;			 // Fecha Limite
			})
		Next nForJ
		oExlXlsx:AddRow("Hoja01","Tabela_01",{;
		" ",;  // Tipo Id
		" ",;  // Orden de Pago
		" ",;  // Num Titulo
		" ",;  // Numero Id
		" ",;  // Nombre
		" ",;	 // Tipo Cuenta
		" ",;	 // Numero Cuenta
		" ",;	 // Banco
		" ",;	 // EMail			
		" ",;	 // Tipo Pago
		nSum;	 // Valor " ";			 // Fecha Limite
		})

		TXEMP->( dbGotop() )
		While TXEMP->( !Eof() )
			TXEMP->( RecLock("TXEMP",.F.) )
			TXEMP->E2_OK := Space(2)
			TXEMP->( MsUnLock() )
			TXEMP->( dbSkip() )
		EndDo
	EndIf

	oExlXlsx:SetFont("Calibri")

	oExlXlsx:SetFontSize(12)
	oExlXlsx:SetItalic(.F.)
	oExlXlsx:SetBold(.T.)
	oExlXlsx:SetUnderline(.F.)
	oExlXlsx:Activate()
	oExlXlsx:GetXMLFile( cDestPath+cFileName )
	oOpnXlsx:= MsExcel():New()
	oOpnXlsx:WorkBooks:Open( cDestPath+cFileName )
	oOpnXlsx:SetVisible(.T.)
	oOpnXlsx:Destroy()
	oExlXlsx:DeActivate()
return

User Function adpVeTot
	Local nForJ		:= 0
	Local cTotales := ""
	Local oDlgMsj
	Local nTotGeneral := 0
	Local oFont := TFont():New('Courier new',,-18,.T.)

	For nForJ := 1 to Len(aTotales)
		IF aTotales[nForJ][4]==cMarcaSE2.OR.((aTotales[nForJ][5])=='T')
			cTotales := cTotales + "O.P. " + aTotales[nForJ][1] + " = " + Transform(aTotales[nForJ][2],"99,999,999,999.99") + ENTER
			nTotGeneral := nTotGeneral + aTotales[nForJ][2]
		EndIf
	Next nForJ

	cTotales := cTotales + "Total " + Transform(nTotGeneral,"99,999,999,999.99") + ENTER

	define msDialog oDlgMsj title "Totales - CITIBANK" from 00,00 to 400,600 pixel
	@ 003,003 GET oObserva VAR cTotales FONT oFont OF oDlgMsj MULTILINE SIZE 280,160 COLORS 0, 16777215 NO VSCROLL PIXEL
	@ 180, 250 BUTTON oBtCerrar PROMPT "Cerrar" SIZE 037, 012 OF oDlgMsj ACTION oDlgMsj:End() PIXEL
	ACTIVATE MSDIALOG oDlgMsj CENTERED

Return

Static Function AjustaSX1(cGrpPerg)
	Local aRegs 	:= {}
	Local I,J	:= 0

	cPerg := PADR(cGrpPerg,10)

	dbSelectArea("SX1")
	dbSetOrder(1)
	aAdd(aRegs,{cPerg,"01","De Fecha digitacion OP"		,"De Fecha Vencimento OP"	,"De Fecha Vencimento OP"	,"MV_CH1","D",8,0,0	,"G","!Vazio()"	,"MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Hasta Fecha digitación OP"	,"Hasta Fecha digitacion OP","Hasta Fecha digitación OP","MV_CH1","D",8,0,0	,"G","!Vazio()"	,"MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Del Proveedor"				,"Del Proveedor"			,"Del Proveedor"			,"MV_CH1","C",15,0,0,"G",""			,"MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","","",""})
	aAdd(aRegs,{cPerg,"04","Hasta el Proveedor"			,"Hasta el Proveedor"		,"Hasta el Proveedor"		,"MV_CH1","C",15,0,0,"G","!Vazio()"	,"MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","","",""})
	aAdd(aRegs,{cPerg,"05","Dato a Listar"				,"Dato a Listar"			,"Dato a Listar"			,"MV_CH1","N",1,0,1	,"C",""			,"MV_PAR05","No Gene + DeDia","No Gene + DeDia","No Gene + DeDia","","","Generados","Generados","Generados","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Banco Origen"				,"Banco Origen"				,"Banco Origen"				,"MV_CH1","C",3,0,1	,"G","!Vazio()"	,"MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","","",""})
	aAdd(aRegs,{cPerg,"07","Fecha para pago"			,"Fecha para pago"			,"Fecha para Pago"			,"MV_CH1","D",1,0,1	,"G","!Vazio()"	,"MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	SX1->(dbCloseArea())
Return nil

User Function LEYCITA1()
	Local aColors	:= {}

	//aAdd( aColors, {"BR_VERMELHO"	,"OP Debitada"})
	aAdd( aColors, {"BR_VERMELHO"	,"OP Generada en Archivo"})
	aAdd( aColors, {"BR_VERDE"		,"OP Sin Generar"})

	BrwLegenda("Pagos Masivos CITIBANK","Leyenda de estado de Pagos Masivos", aColors)
Return


/*/{Protheus.doc} adpDTOSS
Recibe una Fecha y devuelve "YYYY-MM-DD"
@type function
@version 
@author 
@since 10/2023
@param dFecha, date, param_description
@return return_type, return_description
/*/
User Function adpDTOSS(dFecha)
	Local cFecha:=DTOS(dFecha)
Return cfecha:=LEFT(cFecha,4)+"-"+SUBSTR(cFecha,5,2)+"-"+RIGHT(cFecha,2)


/*/{Protheus.doc} CONFIRMA
description
@type function
@version  
@author 
@since 10/2023
@param aPagos, array, param_description
@param _op, variant, param_description
@return variant, return_description
/*/
Static Function CONFIRMA( aPagos,_op )
	Local nSum		:= 0
	Local nCantidad	:= 0
	Local nForJ		:= 0
	Local nChecksum	:=	0
	Private nReg	:=	Len(aPagos)

	For nForJ:=1 to nReg
		nSum		:=	nSum + VAL(aPagos[nForJ][4])
		nCantidad	++
	Next nForJ

	If _op==1
		GraTXT(nSum, nCantidad, nChecksum, aPagos)
		
	Else
		GraEXC(nSum, nCantidad, nChecksum, aPagos)
		
	EndIf

Return 



/*********************************************************/
/*     CITI                                              */
/*********************************************************/
STATIC FUNCTION QuitaTab(cTexALimp)
	cTexALimp := strtran(cTexALimp, chr (10),"")
	cTexALimp := strtran(cTexALimp, chr (9)," ")
	cTexALimp := strtran(cTexALimp, chr (2)," ")
	cTexALimp := strtran(cTexALimp, chr (3)," ")
	cTexALimp := strtran(cTexALimp, chr (4)," ")
	cTexALimp := strtran(cTexALimp, chr (5)," ")
	cTexALimp := strtran(cTexALimp, chr (6)," ")
	cTexALimp := strtran(cTexALimp, chr (7)," ")
	cTexALimp := strtran(cTexALimp, chr (8)," ")
RETURN cTexALimp

/*/{Protheus.doc} GraTXT
description
@type function
@version  
@author 
@since 10/2023
@param nTot, numeric, param_description
@param nPay, numeric, param_description
@param nChecksum, numeric, param_description
@param aPagos, array, param_description
@return variant, return_description
/*/
Static Function GraTXT(nTot, nPay, nChecksum, aPagos)
	Local cSecPa   := '00000000'
	Local aAreaAnt  := GETAREA()
	Local cCITA		:= SuperGetMV("MV_XCITA"  ,.F. , "0013" ) //'0013'
	Local nForJ		:= 0
	Local _cTime	:= Time()
	//Local cFehLimit := if(EMPTY(DTOS(MV_PAR06)),u_adpDTOSS(dDataBase),u_adpDTOSS(MV_PAR06))
	Local _ARQUIVO	:= GETMV("CO_CITIDIR")+"CITI_STECKCOL"+DTOS(dDataBase)+".TXT"//+"_H"+SUBSTR(_cTime,1,2)+"M"+SUBSTR(_cTime,4,2)+".TXT"//+"S"+SUBSTR(_cTime,7,2)
	Local _cBanco	:= ' '
	Local _Conteudo := ''
	Local cQry1		:= ''
	Private nSecuen := 0
	Private nTotPag := 0
	Private nTot := 0
	Private nPay:=0
	Private handle:=nil



	nTotPAY:=0
	nVoy   :=0

	If nReg >= 1
		handle := FCREATE(_ARQUIVO)
		For nForJ := 1 to nReg
			aDeta := { }
			aVOI := { }

			cTpesoa		:= aPagos[nForJ][27] //Alltrim(Posicione("SA2",1, xFilial("SA2") + TRB->EK_FORNECE + TRB->EK_LOJA, "A2_PESSOA"))
			cEsNit      := aPagos[nForJ][25] //Alltrim(Posicione("SA2",1, xFilial("SA2") + TRB->EK_FORNECE + TRB->EK_LOJA, "A2_TIPDOC"))
			cNitSolo	:= aPagos[nForJ][26] //alltrim(Posicione("SA2",1, xFilial("SA2") + TRB->EK_FORNECE + TRB->EK_LOJA, "A2_CGC"))

			if Empty(cNitSolo)
				cNitSolo	:= cTpesoa
			EndIF
			
			if (cTpesoa=='F')
				cNitSolo	:= left(cNitSolo,len(cNitSolo)-1)
			endif
            nPay:=nPay+1
			//*******************PAYLINK - DATOS DEL PAGO **********************************//
			cCodBanco	:= aPagos[nForJ][15]
			cNumCuenta	:= aPagos[nForJ][05]
			cTipReg     := "PAY" 							//Tipo de registro, PAY indica pago , caracter 3
			cPais       := "170"  							//Numero de pais del cliente pagador, 170 corresponde a colombia, numerico 3
			cCtaCli     := alltrim(aPagos[nForJ][30])		//Numero de cuenta el cliente pagador, numerico 10 //Cuenta Origen
			cFhPag      := substr(DTOS(MV_PAR07),3,6)		//Fecha de pago, fecha 6 AA/MM/DD 20180101
			cTpPag      := IIF(cCodBanco=='009','072','071')//"071"// Tipo de pago, caracter 3, ‘071’ — Transferencia CRÉDITO interbancaria de fondos a otra cuenta diferente de Citibank. ‘072’ — Transferencia CRÉDITO de fondos de una cuenta Citibank a otra cuenta Citibank. ‘073’ — Cheque de gerencia
			cRefCli     := "OP " + ALLTRIM(aPagos[nForJ][32])+replicate(" ",6)				//Referencia del cliente pagador, caracter 15
			cSecPa      := soma1(cSecPa)					//Secuencia de pago, numerico 8
			cNIT        := cNitSolo+REPLICATE(" ",20-LEN(cNitSolo))//NIT del beneficiario,caracter 20
			cCodM       := "COP" 							//Cod moneda de pago, caracter 3, COP=pesos Colombianos
			cCodBen     := cNitSolo+REPLICATE(" ",20-LEN(cNitSolo))
			nMonto      := REPLICATE("0",15-LEN(ALLTRIM(STR((aPagos[nForJ][31]*100)))))+ALLTRIM(STR((aPagos[nForJ][31]*100)))//REPLICATE("0",15-LEN(TRB->EK_VLMOED1*100))+(TRB->EK_VLMOED1*100)//replicate("0",15)//Monto a pagar,numerico 15  dos ultimos valores son decimales ***
			dFcVen      := replicate(" ",6)			//Fecha de vencimiento para letra de cambio, no aplica en Colombia, fecha 6
			cDesc1      := "OP " +ALLTRIM(aPagos[nForJ][32])+ replicate(" ",35-len("OP " +ALLTRIM(aPagos[nForJ][32])))//Formato libre para describir detalle de pago 1, caracter 35
			cDesc2      := replicate(" ",35)				//Formato libre para describir detalle de pago 2, caracter 35
			cDesc3      := replicate(" ",35)				//Formato libre para describir detalle de pago 3, caracter 35
			cDesc4      := replicate(" ",35)				//Formato libre para describir detalle de pago 4, caracter 35
			cTipDoc     := "31"							//Tipo de documento y autorizacion de transferencias, numerico 2, '31' para proveedores con validación
			cTpCtaC     := aPagos[nForJ][13] 				// Ahorro Corriente
			cNomBen     := QuitaTab(substr(Alltrim(aPagos[nForJ][03])+replicate(" ",80-len(alltrim( aPagos[nForJ][03] ) ) ) ,1,80))  //NIT del beneficiario,caracter 20//Nombre del beneficiario, caracter 80
			cDirBe1     := iif(LEN(ALLTRIM(aPagos[nForJ][33]))>35,QuitaTab(SUBSTR(ALLTRIM(aPagos[nForJ][33]),1,35)),ALLTRIM(aPagos[nForJ][33])+replicate(" ",35-len(ALLTRIM(aPagos[nForJ][33]))))	//Direccion del beneficiario 1, caracter 35
			cDirBe2     := replicate(" ",35)				//Direccion del beneficiario 2, caracter 35
			cCiuBen     := iif(len(alltrim(aPagos[nForJ][34]))>15,substr(alltrim(aPagos[nForJ][34]),1,15),alltrim(aPagos[nForJ][34])+replicate(" ",15-len(alltrim(aPagos[nForJ][34]))))				//Ciudad del beneficiario, caracter 15
			cDepBen     := aPagos[nForJ][35]				//Departamento del beneficiario, caracter 2
			cCPBen      := replicate(" ",12)				//Codigo portal del beneficioario, no aplica en Colombia, caracter 12
			cTelBen     := iif(len(alltrim(aPagos[nForJ][36]))>16,substr(alltrim(aPagos[nForJ][36]),1,16),alltrim(aPagos[nForJ][36])+replicate(" ",16-len(alltrim(aPagos[nForJ][36]))))			//Telefono del beneficiario, caracter 16
			cNumBco     := IIF(cCodBanco=='009','000',cCodBanco)//Codigo de compesacion asociado en paylink al banco del beneficiario, tabla instituciones financieras, si es CityBank debe ser ceros, numerico 3
			cAgBco      :="0001    "						//Numero de sucursal del banco del beneficiario si se conoce, sino llenar con '0001' que corresponde a bogota, caracter 8
			cCtaBen     :=IIF (cCodBanco<>'009',cNumCuenta+replicate(" ",35-len(cNumCuenta)),REPLICATE(" ",35))//Numero de cuenta bancaria distinta de citybank del beneficiario,caracter 35
			cTpCtaB     :=IIF (cCodBanco<>'009',aPagos[nForJ][13],"00")//Tipo de cuenta a acreditar en banco diferente a citibank,numerico 2, 01=corriente, 02= ahorros
			cDiBcoB     :="PPAL"+ replicate(" ",26)			//Direccion del banco de beneficiario,sino se conoce colocar ciudad o sucursal PPAL, caracter 30
			cReser1     :=Replicate(" ",41)				//Reservado para uso futuro,caracter 41
			cNumfax     :=replicate("0",16)					//Numero de fax 1 del beneficiario,numerico 16
			cNomfax     :=replicate("0",20)					//Nombre de la persona a quien se dirige el fax,caracter 20
			cDptoFax    :="FINANCIERO"+replicate(" ",5)		//Nombre del departamento del fax,caracter 15
			cCtaBCB     :=IIF (cCodBanco=='009',cNumCuenta+replicate(" ",10-len(cNumCuenta)),REPLICATE(" ",10))//Cuenta del beneficiario en CitiBank, numerico 10
			cTpCtBC     :=IIF (cCodBanco=='009',aPagos[nForJ][13],"00")//Tipo de cuenta CitiBank a acreditar, numerico 2, 01=Corriente, 02=ahorro
			cSucDes     :='116' 							//IIF (cNumBco=='009','104','000')//Codigo de sucursal de cuenta de beneficiario en citibank, tabla de sucursales citibank Colombia, numerico 3
			cIDCob      := replicate(" ",50)				//ID de cobranza, no aplica en Colombia, caracter 50
			cCodAct     := replicate(" ",5)					//Codigo activo del beneficiario, no aplica en Colombia,numerico 5

			cEMailB     :=substr(aPagos[nForJ][16],1,50)	//Direccion email del beneficiario,caracter 50
			cValMaxP    :='999999999999999'  				//Valor maximo a ser pagado por transaccion, 13 enteris y dos decimales sin puntos ni comas, numerico 15
			cReser2     := replicate(" ",267)				//Reservado para uso futuro, caracter 267
			cReser3     := replicate(" ",1)  				//Reservado para uso futuro confidencial, caracter 1
			cReser4     := replicate(" ",15) 				//Reservado para uso futuro confidencial, caracter 15

			AAdd( aDeta,{cTipReg,cPais,cCtaCli,cFhPag,cTpPag,cRefCli,cSecPa,cNIT,cCodM,cCodBen,;
			nMonto,dFcVen,cDesc1,cDesc2,cDesc3,cDesc4,cTipDoc,cTpCtaC,cNomBen,cDirBe1,;
			cDirBe2,cCiuBen,cDepBen,cCPBen,cTelBen,cNumBco,cAgBco,cCtaBen,cTpCtaB,cDiBcoB,;
			cReser1,cNumfax,cNomfax,cDptoFax,cCtaBCB,cTpCtBC,cSucDes,cIDCob,cCodAct,cEMailB,;
			cValMaxP,cReser2,cReser3,cReser4})//cReser3,cReser4})

			nTotPAY+=(aPagos[nForJ][31]*100)


//
			dbSelectArea("SEK")
			SEK->(dbSetOrder(1))
			if SEK->(DbSeek(xFilial("SEK")+aPagos[nForJ][11]+'CP')) //EK_FILIAL || EK_ORDPAGO || EK_TIPODOC || EK_PREFIXO || EK_NUM || EK_PARCELA || EK_TIPO || EK_SEQ EK_INDICE
				SEK->( RecLock("SEK",.F.) )
				SEK->EK_XTXT:=.T.
				SEK->EK_XTXFEH:=dDatabase
				SEK->EK_XTXTIM:= SUBSTR(_cTime,1,2)+":"+SUBSTR(_cTime,4,2)
				SEK->( MsUnLock() )
			Else
				Alert("Error actualizando campos Tabla SEK, registro no encontrado OrdPago:"+aPagos[nForJ][11] )
			EndIf

//

			cQry1 :=  " SELECT EK_ORDPAGO, EK_VLMOED1, EK_NUM, EK_PREFIXO, EK_TIPO  "+CRLF
			cQry1 +=  "  FROM "+RetSQLName('SEK')+CRLF
			cQry1 +=  " WHERE EK_ORDPAGO='" + aPagos[nForJ][32] + "' AND D_E_L_E_T_<>'*' " +CRLF
			cQry1 +=  "  AND EK_FILIAL ='"+xFilial("SEK")+"'"+CRLF
			cQry1 +=  "  AND EK_TIPODOC<>'CP' AND EK_FORNEPG='"+ aPagos[nForJ][2] + "' " +CRLF
			cQry1 +=  "  AND EK_LOJAPG='" + aPagos[nForJ][7] + "'" +CRLF

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),"TRB",.T.,.T.)

			cNums := " "
			cTips := " "
			cSubSec    := '0000'
			If TRB->( !Eof() )
				While TRB->( !Eof() )
				nVoy:=nVoy+1
				//*******************REGISTRO DE DETALLE DE FACTURAS**********************************//
				cTpreg     :="VOI"//Valor de control que indica que es un registro de pago "VOI",
				cCodPai    :="170"//Codigo del pais del pagador,numerico 3
				cNoCtaP    := cCtaCli //alltrim(Posicione("SA6",1,xFilial("SA6") + TRB->EK_BANCO + TRB->EK_AGENCIA + TRB->EK_CONTA,"A6_NUMCON"))//Numero de cuenta del pagador, numerico 10
				cRefCli    :="PAGO OP  "+ALLTRIM(TRB->EK_ORDPAGO)//Referencia del pagador,caracter 15
				cSecDet    :=cSecPa//cSecEn//Secuencia iagual a secuencia del pago, numerico, 8
				cSubSec    :=soma1(cSubSec)//Secuencia dle numero de facturas dentro de un pago, maximo 50 facturas desde 0001 hasta 0050, numerico 4
				cDesPag    :=SUBSTR(ALLTRIM(TRB->EK_TIPO)+"/"+IIF(!EMPTY(TRB->EK_PREFIXO),ALLTRIM(TRB->EK_PREFIXO)+"-"," ")+ALLTRIM(TRB->EK_NUM)+">>"+alltrim(Transform(TRB->EK_VLMOED1,"@E 99999999999999.99")) +replicate(' ',75),1,75) //Descripcion del pago formato libre, caracter 75
				cReser3    :=replicate(" ",132)//Reservado para uso futuro,caracter 132
				AAdd( aVOI,{cTpreg,cCodPai,cNoCtaP,cRefCli,cSecDet,cSubSec,cDesPag,cReser3 })
				TRB->( dbSkip() )
				End
			EndIf

			If Select("TRB") > 0
				TRB->( dbCloseArea() )
			EndIf

			If Len(aDeta) > 0
				GenDeta(aDeta,1)
			EndIf
			If Len(aVOI) > 0
				GenDeta(aVOI,2)
			EndIf
		Next nForJ
		GePago(nTotPay,nPay,nVoy)
		FCLOSE(M->handle)		
	
		TXEMP->( dbGotop() )
		While TXEMP->( !Eof() )
			TXEMP->( RecLock("TXEMP",.F.) )
			TXEMP->E2_OK := Space(2)
			TXEMP->( MsUnLock() )
			TXEMP->( dbSkip() )
		EndDo
		RESTAREA(aAreaAnt)
		Aviso("Aviso","Layout generado con exito... ",{"OK"})
	
	EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄ-ÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³  GePago  ³ Autor ³ Yamila Mikati         ³ Data ³ 25/01/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄ-ÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.   ³ Generacion del registro de pago.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄ-ÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso        ³ Transferencia Bancaria                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄ-ÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GePago(nTotPay,nPay,nVoy)
	Local nNumRg:= nPay+nVoy
	//cFecEmi  	:= SUBSTR(str(Year(dDatabase),4),3,2)+ Strzero(Month(dDatabase),2) + Strzero(Day(dDatabase),2)

	cTipo    	:= "TRL" //Valor de control indicando que es un tipo trailer 3 caracteres
	nPay        := replicate("0",15-LEN(ALLTRIM(STR(NPAY))))+ALLTRIM(STR(NPAY))//replicate(" ",15)//ntotreg//+replicate(" ",15-len(nTotreg))//Numero de registros pay enviados numerico 15
	cValor      := replicate("0",15-LEN(ALLTRIM(STR(NTOTPAY))))+ALLTRIM(STR(NTOTPAY)) //replicate(" ",15)//REPLICATE("0",15-LEN(ALLTRIM(STR((nTotPay)))))+ALLTRIM(STR((nTotPay)))//Valor total de los registros PAY numerico 15
	nNumReg     := replicate('0',15)//Numero de registros del beneficiario numeroco 15 llenar con ceros
	nRegs       := replicate("0",15-LEN(ALLTRIM(STR(NNUMRG))))+ALLTRIM(STR(NNUMRG)) //replicate(" ",64-len(nTotreg))//replicate('0',64)//Numero de los registros previos al trailer enviados, no considerar trailer
	nResFut     := replicate(' ',37)//reservado para uso futuro
	aTRL        :={}
	//cString  := cTipo + cNitEnt + 'I' + '               ' + cClase + /*'PAGO DE PR'*/cPropTrans + cFecEmi + cEnvio+ cFecAplic + Strzero(nTotReg,6)  + Strzero(0,17)+ Strzero((nTot * 100),17) +  SubStr(cCtaPpal,1,11) + cTipoCtaB + '                                                                                                                                                     '
	cString  := cTipo + nPay + cValor +nNumreg + nRegs+ nResFut

	AAdd( aTRL,{cTipo, nPay , cValor ,nNumreg , nRegs, nResFut })

	GenDeta(aTRL,3)

	//GrabaLog( cString )

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄ-ÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³  GenDeta  ³ Autor ³ Yamila Mikato		   ³ Data ³ 25/01/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄ-ÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.   ³ Generacion del registro de Detalle.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄ-ÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso        ³ Transferencia Bancaria                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄ-ÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GenDeta(aDeta,nOpc)
	Local xI:=0
	Local cString := ""

	FOR xI := 1 TO Len(aDeta)
		IF nOpc==1
			cString :=""
			cString := aDeta[xI,1] + aDeta[xI,2] + aDeta[xI,3] +aDeta[xI,4] + aDeta[xI,5] +aDeta[xI,6]+ aDeta[xI,7] + aDeta[xI,8] +aDeta[xI,9] + aDeta[xI,10] +aDeta[xI,11]+ aDeta[xI,12] + aDeta[xI,13] +aDeta[xI,14] + aDeta[xI,15] +aDeta[xI,16]+;
				aDeta[xI,17] + aDeta[xI,18] + aDeta[xI,19] +aDeta[xI,20] + aDeta[xI,21] +aDeta[xI,22]+ aDeta[xI,23] + aDeta[xI,24] +aDeta[xI,25] + aDeta[xI,26] +aDeta[xI,27]+ aDeta[xI,28] + aDeta[xI,29] +aDeta[xI,30] + aDeta[xI,31] +aDeta[xI,32]+;
				aDeta[xI,33] + aDeta[xI,34] + aDeta[xI,35] +aDeta[xI,36] + aDeta[xI,37] +aDeta[xI,38]+ aDeta[xI,39] + aDeta[xI,40] +aDeta[xI,41] + aDeta[xI,42]
			//GrabaLog( cString )
			FWrite( handle, cString+Chr(13)+Chr(10))
		elseif nOpc==2
			cString :=""
			cString := aDeta[xI,1] + aDeta[xI,2] + aDeta[xI,3] +aDeta[xI,4] + aDeta[xI,5] +aDeta[xI,6]+ aDeta[xI,7] + aDeta[xI,8]
			//GrabaLog( cString )
			FWrite( handle,cString+Chr(13)+Chr(10))//,Chr(13)+Chr(10))
		elseif nOpc==3
			cString :=""
			cString := aDeta[xI,1] + aDeta[xI,2] + aDeta[xI,3] +aDeta[xI,4] + aDeta[xI,5] +aDeta[xI,6]
			//GrabaLog( cString )
			FWrite( handle,cString)
		endif
	NEXT
Return




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ GrabaLog³ Autor ³ Yamila Mikati		 ³ Data ³ 25/01/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Genera el Log de las migraciones...                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso         ³ MultiMig                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GrabaLog( cString )

	FWrite( handle, cString + Chr(13)+ Chr(10) )
	
Return

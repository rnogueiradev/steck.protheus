#include 'Protheus.ch'
#include 'RwMake.ch'
#DEFINE CR    chr(13)+chr(10)
/*====================================================================================\
|Programa  | STPIRAMIDE          | Autor | GIOVANI.ZAGO          | Data | 28/05/2014  |
|=====================================================================================|
|Descrição |  Retorna Gera txt integração com sistema piramide                        |
|=====================================================================================|
|Sintaxe   | STPIRAMIDE                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------*
User Function STPIRAMIDE()
*---------------------------*
Local oDlgEmail
Local lSaida      	:= .F.
Local nOpca       	:=  0
Local nHandle  		:= 0
Local _cArqDEMA 	:= "C:\piramide"
Private cPerg 			:= "RFAT37"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private _dDtDe      := ddatabase
Private _dDtAte     := ddatabase

_cArqDEMA 	+= cHora+ cMinutos+cSegundos+'.txt'   

Do While !lSaida
	nOpcao := 0
	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Parametros") From  1,0 To 180,200 Pixel OF oMainWnd
	
	@ 02,04 SAY "Data de:" PIXEL OF oDlgEmail
	@ 12,04 MSGet _dDtDe   Size 55,013  PIXEL OF oDlgEmail
	@ 28,04 SAY "Data Ate:" PIXEL OF oDlgEmail
	@ 38,04 MSGet _dDtAte   Size 55,013  PIXEL OF oDlgEmail
	
	@ 54,05 Button "Ok"      Size 28,13 Action Eval({||lSaida:=.T.,nOpca:=1,oDlgEmail:End()})  Pixel
	@ 54,50 Button "Cancela"      Size 28,13 Action Eval({||lSaida:=.T.,nOpca:=0,oDlgEmail:End()})  Pixel
	
	ACTIVATE MSDIALOG oDlgEmail CENTERED
EndDo


If nOpca = 1
	
	
	Processa({|| SelPiram() },"Selecionando Registros..")
	
	If !File(_cArqDEMA)
		nHandle := MsfCreate(Upper(_cArqDEMA),0)
	Endif
	If nHandle > 0
		
		FWrite(nHandle,'E00100582.0.060'+CR)
		
		dbSelectArea(cAliasLif)
		If  Select(cAliasLif) > 0
			(cAliasLif)->(dbgotop())
			While (cAliasLif)->(!Eof())
				
				FWrite(nHandle, ;
				Padr(Alltrim((cAliasLif)->a1 ),  4)+;
				Padr(Alltrim((cAliasLif)->a2 ), 14)+;
				Padr(Alltrim((cAliasLif)->a3 ), 60)+;
				Padr(Alltrim((cAliasLif)->a4 ),  8)+;
				Padr(Alltrim((cAliasLif)->a5 ),  8)+;
				Padr(Alltrim((cAliasLif)->a6 ),  8)+;
				Padr(Alltrim((cAliasLif)->a7 ),  8)+;
				Padr(Alltrim((cAliasLif)->a8 ), 14)+;
				Padr(Alltrim((cAliasLif)->a9 ),  2)+;
				Padr(Alltrim((cAliasLif)->a10),  2)+;
				Padr(Alltrim((cAliasLif)->a11),  4)+;
				Padr(Alltrim((cAliasLif)->a12), 15)+;
				Padr(Alltrim((cAliasLif)->a13),100)+;
				Padr(Alltrim((cAliasLif)->a14),  1)+;
				Padr(Alltrim((cAliasLif)->a15),  4)+;
				Padr(Alltrim((cAliasLif)->a16),  9)+;
				Padr(Alltrim((cAliasLif)->a17),  6)+;
				Padr(Alltrim((cAliasLif)->a18),  6)+;
				Padr(Alltrim((cAliasLif)->a19), 14)+;
				Padr(Alltrim((cAliasLif)->a20),  3)+;
				Padr(Alltrim((cAliasLif)->a21), 14)+;
				Padr(Alltrim((cAliasLif)->a22),  5)+;
				Padr(Alltrim((cAliasLif)->a23),  5)+;
				Padr(Alltrim((cAliasLif)->a24),  2)+;
				Padr(Alltrim((cAliasLif)->a25),  5)+;
				Padr(Alltrim((cAliasLif)->a26), 50)+;
				Padr(Alltrim((cAliasLif)->a27),  7)+;
				Padr(Alltrim((cAliasLif)->a28),  7)+;
				Padr(Alltrim((cAliasLif)->a29),  1)+;
				Padr(Alltrim((cAliasLif)->a30),  7)+;
				Padr(Alltrim((cAliasLif)->a31), 14)+;
				Padr(Alltrim((cAliasLif)->a32),  1)+;
				Padr(Alltrim((cAliasLif)->a33),  2)+;
				Padr(Alltrim((cAliasLif)->a34),  2)+;
				Padr(Alltrim((cAliasLif)->a35),  2)+;
				Padr(Alltrim((cAliasLif)->a36),  1)+;
				Padr(Alltrim((cAliasLif)->a37),  3)+;
				Padr(Alltrim((cAliasLif)->a38),  2)+;
				Padr(Alltrim((cAliasLif)->a39), 60)+;
				Padr(Alltrim((cAliasLif)->a40),  5)+;
				Padr(Alltrim((cAliasLif)->a41),  1)+;
				CR )
				
				
				
				(cAliasLif)->(DbSkip())
			End
		EndIf
		
		
		FClose(nHandle)
	EndIf
EndIf
Return ()


/*====================================================================================\
|Programa  | SelPiram            | Autor | GIOVANI.ZAGO          | Data | 02/06/2014  |
|=====================================================================================|
|Descrição |  Retorna registro da piramide                                            |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | SelPiram                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------*
Static Function SelPiram()
*---------------------------*
Local _aArea	:= GetArea()
Local cQuery     := ' '


cQuery := " SELECT
cQuery += " 'E020'
cQuery += ' "a1",
cQuery += " case when sb1.b1_xcodste=' ' then SD1.D1_COD else sb1.b1_xcodste end
cQuery += ' "a2",
cQuery += " SB1.B1_DESC
cQuery += ' "a3",
cQuery += " '20100101'
cQuery += ' "a4",
cQuery += " '        '
cQuery += ' "a5",
cQuery += " '20100101'
cQuery += ' "a6",
cQuery += " '        '
cQuery += ' "a7",
cQuery += " '        '
cQuery += ' "a8",
cQuery += " '        '
cQuery += ' "a9",
cQuery += " CASE WHEN SB1.B1_TIPO = 'MP' THEN '01' ELSE CASE WHEN SB1.B1_TIPO = 'PA' THEN '04' ELSE CASE WHEN SB1.B1_TIPO = 'PI' THEN '06' ELSE CASE WHEN SB1.B1_TIPO = 'EM' THEN '02' ELSE '07' END END END END
cQuery += ' "a10",
cQuery += " '        '
cQuery += ' "a11",
cQuery += " CASE WHEN SB1.B1_POSIPI <> ' ' THEN SUBSTR(SB1.B1_POSIPI,1,4)||'.'||SUBSTR(SB1.B1_POSIPI,5,2)||'.'||SUBSTR(SB1.B1_POSIPI,7,2) ELSE ' ' END
cQuery += ' "a12",
cQuery += " '        '
cQuery += ' "a13",
cQuery += " 'N'
cQuery += ' "a14",
cQuery += " '        '
cQuery += ' "a15",
cQuery += " '        '
cQuery += ' "a16",
cQuery += " SB1.B1_UM
cQuery += ' "a17",
cQuery += " SB1.B1_UM
cQuery += ' "a18",
cQuery += " '00000000000000'
cQuery += ' "a19",
cQuery += " '000'
cQuery += ' "a20",
cQuery += " '00000000000000'
cQuery += ' "a21",
cQuery += " '00000'
cQuery += ' "a22",
cQuery += " '00000'
cQuery += ' "a23",
cQuery += " '        '
cQuery += ' "a24",
cQuery += " '        '
cQuery += ' "a25",
cQuery += " SB1.B1_CONTA
cQuery += ' "a26",
cQuery += " '0000012'
cQuery += '"a27",
cQuery += " '0000000'
cQuery += ' "a28",
cQuery += " 'N'
cQuery += ' "a29",
cQuery += " '0000000'
cQuery += ' "a30",
cQuery += " '00000000000000'
cQuery += ' "a31",
cQuery += " '0'         
cQuery += ' "a32",
cQuery += " '00'
cQuery += ' "a33",
cQuery += " '00'
cQuery += ' "a34",
cQuery += " '20'
cQuery += ' "a35",
cQuery += " '2'
cQuery += ' "a36",
cQuery += " '        '
cQuery += ' "a37",
cQuery += " '        '
cQuery += ' "a38",
cQuery += " '        '
cQuery += ' "a39"
cQuery += " ,
cQuery += " '        '
cQuery += ' "a40",
cQuery += " '0'
cQuery += ' "a41"
cQuery += " FROM SD1030 SD1
cQuery += " INNER JOIN(SELECT * FROM SB1030) SB1
cQuery += " ON SB1.D_E_L_E_T_ = ' '
cQuery += " AND SB1.B1_COD = SD1.D1_COD
cQuery += " AND SB1.B1_FILIAL = ' '

cQuery += " WHERE SD1.D_E_L_E_T_ = ' '
cQuery += " AND SD1.D1_TIPO = 'N'
cQuery += " AND SD1.D1_EMISSAO BETWEEN '"+DTOS(_dDtDe)+"' AND '"+DTOS(_dDtATE)+"'
cQuery += " AND SD1.D1_FILIAL = '01'



cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
dbSelectArea(cAliasLif)

RestArea(_aArea)
Return()


#INCLUDE  "rwMake.ch"
#INCLUDE "tbiConn.ch"
#INCLUDE  "topConn.CH"

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao    � ARWF001    � Autor � Cristiano Pereira    � Data � 27/08/08 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Env韔 de flujo de trabajo para enumerar sucesos pendientes.  潮�
北�          �                                                              潮�
北�          �                                                              潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User function ARWF001( aParams )

aParams := { "07", "01" }
prepare environment empresa aParams[1] filial aParams[2] Tables "SB1"
U_AWF001A()
RETURN


/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao    � AWF001A   � Autor � Kelle D Ramos         � Data � 27/08/08 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Env韔 de flujo de trabajo para enumerar sucesos pendientes.  潮�
北�          �                                                              潮�
北�          �                                                              潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/

User Function AWF001A()

Local _nK := 0
Private oP, oHtml    ,	_nItens :=0
Private _cQryCQK  :="",_dData:=""
 

SETPRVT("_ANOME, _NPOS, _CPARAM, AUSERS")

_dData := DTOS(dDataBase)


// Verifica se arquivo esta aberto
If Select("TCQK") > 0
	dbSelectArea("TCQK")
	dbCloseArea()
Endif

_cQryCQK := " SELECT SB1.*                                                                                                  "
_cQryCQK += " FROM "+RetSqlName("SB1")+" SB1                                                                                "
_cQryCQK += " WHERE SB1.B1_FILIAL = '"+xFilial("SB1")+"'  AND                                                               "
_cQryCQK += "       SB1.D_E_L_E_T_ <>'*'                  AND                                                               " 
_cQryCQK += "       SB1.B1_X_RAT <> 'S'                   AND                                                               "
_cQryCQK += "       SB1.B1_MSBLQL <> '1'                  AND                                                               "
_cQryCQK += "      ( SUBSTR(SB1.B1_COD,1,4)='SERV' OR SUBSTR(SB1.B1_COD,1,1)='E' OR SUBSTR(SB1.B1_COD,1,1)='U' ) AND        "
_cQryCQK += "      NOT EXISTS(                                                                                              "
_cQryCQK += "        SELECT CQK.CQK_XPROD                                                                                   "
_cQryCQK += "        FROM "+RetSqlName("CQK")+" CQK   "                                                                                     "
_cQryCQK += "        WHERE CQK.CQK_FILIAL ='"+xFilial("CQK")+"'  AND                                                                        "
_cQryCQK += "              CQK.D_E_L_E_T_ <>'*'  AND                                                                        "
_cQryCQK += "              CQK.CQK_XPROD=SB1.B1_COD )                                                                       "


TCQUERY _cQryCQK  NEW ALIAS "TCQK"


_nRec   := 0
DbEval({|| _nRec++  })


_nRegistro  := 0
_aNome      := {}
aUsers      := {}
_nPos       := 0
_cParam     := ""

If _nRec > 0
	
	// Inicializa a classe TWFProcess
	oP := TWFProcess():New( "ENVIO", "Productos con eventos pendientes.")
	
	// Cria-se uma nova tarefa para o processo.
	oP:NewTask( "100400", "\WORKFLOW\ARWF001.htm" )
	
	// Faz uso do objeto oHtml que pertence ao processo
	oHtml := oP:oHtml
	
	// Assinala os valores no html
	oHtml:ValByName("Data" , MsDate()  )
	
	
	_nItens := 0
	dbSelectArea("TCQK")
	dbGoTop()
	
	While !Eof()
		
		AAdd(oHtml:valbyname("t1.0" ) , TCQK->B1_COD          )
		AAdd(oHtml:valbyname("t1.1" ) , TCQK->B1_DESC         )
		_nItens++
		
		dbSelectArea("TCQK")
		DbSkip()
	Enddo
	
Endif


_aNome  := {}
aUsers  := {}
_nPos   := 0
_cParam := ""

If _nItens > 0
	
	// Informando o destinat醨io
	_cParam := getmv("AR_WF001")
	_nJ := 0
	while !empty(_cParam)
		_nJ++
		// Busca nome do usuario ate o caracter '/'
		_nPos := at("/",_cParam)
		
		// Se contiver apenas 1 elemento nao tem barra
		if _nPos == 0
			Aadd( _aNome, substr(_cParam,1) )
			
			//Retira o usuario, que ja foi carragado na lista, da variavel do paramentro
			_cParam := ""
		else
			Aadd( _aNome, Alltrim(substr(_cParam,1,_nPos-1)) )
			
			//Retira o usuario, que ja foi carragado na lista, da variavel do paramentro
			_cParam := substr(_cParam,_nPos+1)
		Endif
	EndDo
	
	If _nJ <> 0
		
		//Busca o cadastro dos usuarios
		aUsers := AllUsers(.T.)
		
		//Pega a posicao do primeiro usuario do parametro no array aUsers
		_nPos := aScan( aUsers, {|x| Alltrim(Upper(_aNome[1])) == alltrim(Upper(x[1][2])) } )
		
		//Define o primeiro usuario do paramentro como email principal de Destinat醫io
		oP:cTo := aUsers[_nPos][1][14]
		
		//Se no parametro contiver mais de um usuario carregar os Destinat醫ios Com Copia 'oP:cCC'
		if _nJ > 1
			oP:cCC := ""
			for _nK = 2 to _nJ
				_nPos := aScan( aUsers,{ |x| Alltrim(Upper(_aNome[_nK])) == alltrim(Upper(x[1][2])) } )
				oP:cCC += aUsers[_nPos][1][14]+","
			next _nK
		endif
	endif
	
	// O Assundo da mensagem
	oP:cSubject := "Productos con eventos pendientes."
	
	// Gerando os arquivos de controle deste processo e enviando a mensagem
	oP:Start()
	
	dbSelectArea("TCQK")
	dbCloseArea()
	
	// Finaliza o processo.
	oP:Finish()
	
Endif

Return

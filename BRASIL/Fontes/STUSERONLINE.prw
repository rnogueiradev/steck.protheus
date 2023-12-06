#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"
#include "TOTVS.CH"
 

User Function STUSERONLINE()//VerOnline

	Local oUsuarios
	Local aOnline 	:= {}
	Local aUsuarios := {}
	Local nx := 0
	
	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")
	
	aUsuarios := allusers()
	//ProcRegua(Len(aUsuarios))
	//oUsuarios:SetOrder(1)
	//oUsuarios:GoTop()
	For nx := 1 to Len(aUsuarios)
		PSWOrder( 1 )
		If PSWSeek( aUsuarios[nx][1][1], .T.)
			//Incproc("Processando "+Alltrim(PswRet()[1,4]))

			aLogon := FWUsrUltLog(PswRet()[1,1])
			if(aLogon[1]==dDatabase)
				nDuracao := SubtHoras(aLogon[1],aLogon[2],dDataBase,Left(Time(),5))
				If nDuracao < 0
					nDuracao := 0
				EndIf
				
				
				Z10->(RecLock("Z10",.T.))
				Z10->Z10_COD	:= Alltrim(PswRet()[1,1])
				Z10->Z10_NOME	:= Upper(Alltrim(PswRet()[1,2]))
				Z10->Z10_DATA	:= aLogon[1]
				Z10->Z10_HORA	:= SubStr(aLogon[2],1,5)
				Z10->Z10_DURACA	:= nDuracao*60
				Z10->Z10_FIM	:= 'N'
				Z10->(MsUnlock())
				Z10->(DbCommit())
				
				cDuracao := SUBSTR(STRZERO(nDuracao, 5, 2), 1, 2) + ":" + STRZERO((nDuracao - INT(nDuracao) )* 60, 2)
				//aadd(aOnline,{Alltrim(PswRet()[1,4]),dtoc(aLogon[1]),aLogon[2],cDuracao,aLogon[3],aLogon[4],aLogon[5]})
				
				
				
			Endif
		Endif
	Next
	//cSayOn1 := "Usuários OnLine ("+Alltrim(Str(nx))+"):"
	//oSayOn1:Refresh()
	//oOnline:SetOrder(1)
	//oUsuarios:GoTop()
	//oOnline:Refresh()



Return

User Function fAtuOn()
	Local cQry:= ' '
	Local l := 0
	Local i := 0
	Local y := 0
	Private aUsrOn := {}
	Private _aMsg := {}

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")


	UsrArray()
	aOnline := {}
	
	cQry := "	UPDATE Z10010  SET Z10_FIM = 'S' WHERE Z10_FIM <> 'S' AND D_E_L_E_T_ = ' ' 
	TcSQLExec(cQry)
	
	
	For i:= 1 to len(aUsrOn)
		
		For y:= 1 to len(aUsrOn[i])
			PSWOrder( 2 )
			If PSWSeek( aUsrOn[i][y][1], .T.)
			
				_cCodx:= Alltrim(PswRet()[1,1])
				If _cCodx= '000941'
				_cCodx:= '000941'
				EndIf
				If 	aScan( _aMsg, { |x| x[1] == _cCodx } ) == 0
		
					Aadd(_aMsg,{_cCodx,;
						Upper(Alltrim(PswRet()[1,2])),;
						date(),;
						Substr(aUsrOn[i][y][7],12,5),;
						(val(SUBSTR(aUsrOn[i][y][8], 1, 2))*60)+val(SUBSTR(aUsrOn[i][y][8], 4, 2)),;
						'N';
						})
		 
				Else
					If _aMsg[aScan( _aMsg, { |x| x[1] == _cCodx } ) , 4] >	Substr(aUsrOn[i][y][7],12,5)
					
						_aMsg[aScan( _aMsg, { |x| x[1] == _cCodx } ) , 4] := Substr(aUsrOn[i][y][7],12,5)
						_aMsg[aScan( _aMsg, { |x| x[1] == _cCodx } ) , 5] := (val(SUBSTR(aUsrOn[i][y][8], 1, 2))*60)+val(SUBSTR(aUsrOn[i][y][8], 4, 2))
					EndIf
		 
				EndIf
			EndIf
		Next y
	Next i
	ASort(_aMsg,,,{|x,y| (x[1]) < (y[1])})
	For l:=1 To Len(_aMsg)
	
		Dbselectarea("Z10")
		Z10->(Dbsetorder(1))
		If Z10->(dbseek(xfilial("Z10")+_aMsg[l,1]+ dtos(_aMsg[l,3])+_aMsg[l,4]))
			Z10->(RecLock("Z10",.F.))
		Else
			Z10->(RecLock("Z10",.T.))
			Z10->Z10_HORAIN	:= SubStr(TIME(),1,5)
		EndIf
		Z10->Z10_COD	:= _aMsg[l,1]
		Z10->Z10_NOME	:= _aMsg[l,2]
		Z10->Z10_DATA	:= _aMsg[l,3]
		Z10->Z10_HORA	:= _aMsg[l,4]
		Z10->Z10_DURACA	:= _aMsg[l,5]
		Z10->Z10_FIM	:= _aMsg[l,6] 
		Z10->(MsUnlock())
		Z10->(DbCommit())
	
	Next l
	
	
 
Return

static Function UsrArray()
	local oSrv     := nil
	local cEnv     := 'P12'//GetEnvServer() //Ambiente
	local aUsers   := {}
	local nIdx     := 0
	local aServers := {}
	local aTmp     := {}
	Local cSrvIp   := GETSERVERIP()
	Local aPortas  := {12000,12061,12062,12063}
 	Local i := 0
	CURSORWAIT()
	IncProc("Localizando balances...")
	
	// neste caso, quero apenas o balance, que me retorna todos os slaves conectados.
	For i:=1 to Len(aPortas)
		aadd(aServers, {cSrvIp, aPortas[i]})
	Next i
	
	
	aUsrOn := {}
	
	For nIdx := 1 to len(aServers)
		IncProc("Ambiente: "+cEnv+" | Servidor: "+aServers[nIdx,1]+"/"+Alltrim(Str(aServers[nIdx,2])))
	     // conecta no slave via rpc
		oSrv := rpcconnect(aServers[nIdx,1], aServers[nIdx,2], cEnv, "01", "02")
		if valtype(oSrv) == "O"
			oSrv:callproc("RPCSetType", 3)
	          // chama a funcao remotamente no server, retornando a lista de usuarios conectados
			aTmp := oSrv:callproc("GetUserInfoArray")
			aadd(aUsrOn, aclone(aTmp))
			aTmp := nil
	          // limpa o ambiente
			oSrv:callproc("RpcClearEnv")
	          // fecha a conexao
			rpcdisconnect(oSrv)
		else
			return "Falha ao obter a lista de usuarios."
		endif
	Next nIdx
	CursorArrow()
Return varInfo("usr",aUsers)

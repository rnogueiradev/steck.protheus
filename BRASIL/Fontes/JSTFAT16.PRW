#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"

/*
Job de Envio de Relatório RSTFAT16

*/
User Function JSTFAT16(cNewEmp,cNewFil,clJobExec)
    Local lRet := .T.
	
	Private cEnvServer := Upper(GetEnvserv())
	Default cNewEmp  := ""
	Default cNewFil  := ""
    Default  clJobExec := ".T."


    If (Empty(cNewEmp) .And. Empty(cNewFil)) .Or. &(clJobExec)
        IF cEnvServer == "PROD" .Or. Left(cEnvServer,5) == "EMERG" .Or. Alltrim(cEnvServer) == "D01_DIST"  .Or. Alltrim(cEnvServer) == "D02_DIST" //Distribuidora
            cNewEmp := "11"
            cNewFil := "01"
        elseIf  cEnvServer == "P12" .or. Left(cEnvServer,9) == "P12_EMERG" .Or. Alltrim(cEnvServer) == "D01_IND" .Or. Alltrim(cEnvServer) == "D02_IND" //Industria
            cNewEmp := "01"
            cNewFil := "01"
        EndIf
    EndIf
  
    If IsBlind() .Or. &(clJobExec)
        Reset Environment
        RpcSetType( 3 )
        RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

        //Cham a Função do relatório para envio do email.    
        U_xRSTFAT16(.T.)

    
    EndIf    
Return lRet    

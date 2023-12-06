#INCLUDE "TOTVS.CH"
User Function ATUTOP()

	DbSelectArea("SX2")

	While SX2->(!Eof())
		StartJob("U_ATUTOP2",GetEnvServer(),.T.,SX2->X2_CHAVE)
		SX2->(DbSkip())
	EndDo

Return()

User Function ATUTOP2(_cTabela)

	RpcSetType( 3 )
	RpcSetEnv("01","01",,'COM')

	Conout("iniciado tabela "+SX2->X2_CHAVE)
	X31UPDTABLE(_cTabela)
	Conout("tabela "+SX2->X2_CHAVE+"finalizada")

Return
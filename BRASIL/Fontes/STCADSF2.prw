#Include 'Protheus.ch'

User Function STCADSF2()

	Local 	_aRotina	:= {}
	Private cCadastro 	:= "Cadastro de Armazenagem"
	Private aRotina 	:= { 	{"Pesquisar" 		,"AxPesqui"		,0,1} ,;
		{"Alterar"   		,"AxAltera"		,0,4}}
          
 
	Private cString := "SF2" 


	If __cuserid $ GetMv("ST_CADSF2",,"000000/000645/000923/000677")

		Dbselectarea("SF2")
		dbSetOrder(1)

		mBrowse( 6,1,22,75,cString,,,,,,,,,,,,,,,)

	Else

		MsgInfo("usuario sem acesso....!!!!")

	EndIF
Return .t.
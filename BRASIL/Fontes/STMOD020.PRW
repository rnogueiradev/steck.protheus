#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'

/*====================================================================================\
|Programa  | STMOD020        | Autor | RENATO.OLIVEIRA           | Data | 27/08/2018  |
|=====================================================================================|
|Descrição | ROTINA PARA CRIAR USUARIOS NO MOODLE STECK                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STMOD020()

	Local _cToken		:= "e8bc8a3b76149d6ebee4720883455ee1"
	Local nTimeOut 		:= 60
	Local aHeadOut 		:= {}
	Local cHeadRet 		:= ""
	Local _cUrl 		:= "http://mail2.steck.com.br:8355/moodle/webservice/rest/server.php?

	aAdd( aHeadOut , "Content-type:application/json;charset=UTF-8")
	aAdd( aHeadOut , "Accept: application/json")

	_cParam := "wstoken="+escape("e8bc8a3b76149d6ebee4720883455ee1")
	_cParam += "&wsfunction="+escape("core_user_create_users")
	_cParam += "&users[0][username]="+escape("48896632587")
	_cParam += "&users[0][auth]="+escape("manual")
	_cParam += "&users[0][password]="+escape("567608")
	_cParam += "&users[0][firstname]="+escape("Adeval")
	_cParam += "&users[0][lastname]="+escape("Albino de Santana")
	_cParam += "&users[0][email]="+escape("48896632587@noemail.com.br")
	_cParam += "&users[0][city]="+escape("Guarulhos")
	_cParam += "&users[0][country]="+escape("Brasil")
	_cParam += "&users[0][customfields][0][type]="+escape("filial_cadprotheus")
	_cParam += "&users[0][customfields][0][value]="+escape("02")
	_cParam += "&users[0][customfields][1][type]="+escape("emp_cadprotheus")
	_cParam += "&users[0][customfields][1][value]="+escape("01")
	_cParam += "&users[0][customfields][2][type]="+escape("mat_cadprotheus")
	_cParam += "&users[0][customfields][2][value]="+escape("000014")
	_cParam += "&users[0][customfields][3][type]="+escape("cpf_cadprotheus")
	_cParam += "&users[0][customfields][3][value]="+escape("488.966.325-87")
	_cParam += "&users[0][customfields][4][type]="+escape("profilerole")
	_cParam += "&users[0][customfields][4][value]="+escape("Estudante")
	_cParam += "&users[0][customfields][5][type]="+escape("department_cadprotheus")
	_cParam += "&users[0][customfields][5][value]="+escape("EXPEDICAO")

	cHttpPost := HTTPPost (_cUrl, _cParam, "", nTimeOut, aHeadOut, @cHeadRet )

Return()
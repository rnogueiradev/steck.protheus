#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "FILEIO.CH"
//#INCLUDE "XMLCSVCS.CH"
#Define CR chr(13)+ chr(10)
/*====================================================================================\
|Programa  | STSA1COM       | Autor | GIOVANI.ZAGO             | Data | 19/05/2017 |
|=====================================================================================|
|Sintaxe   | STSA1COM                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================
*/
*----------------------------------*
User Function STSA1COM()
	*----------------------------------*
	Local oBrowse
	
	Private _UserMvc := GetMv('ST_STREEM',,'000000/000308/000210')
	
	
	
	
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	//SA1->(dbSetFilter({|| SA1->SA1_USER = __cUserId .Or.   __cUserId $ _xSuper   },'SA1->SA1_USER = __cUserId  .Or.   __cUserId $ __xSuper  '))
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SA1")					// Alias da tabela utilizada
	oBrowse:SetMenuDef("STSA1COM")				// Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription("Clientes")   	// Descrição do browse
	
	oBrowse:AddLegend(" A1_ULTCOM  >=  dDatabase-90    "  ,"GREEN"         ,"Ate 90 dias")
	oBrowse:AddLegend(" A1_ULTCOM  >=  dDatabase-180  .AND. A1_ULTCOM  <  dDatabase-90   "  ,"YELLOW"      	,"90 - 180 dias")
	oBrowse:AddLegend(" A1_ULTCOM  >=  dDatabase-360  .AND. A1_ULTCOM  <  dDatabase-180   "   ,"BLUE"        	,"180 - 360 dias")
	oBrowse:AddLegend("  A1_ULTCOM  <  dDatabase-360  .AND. A1_ULTCOM <> stod('        ')"   ,"RED"        	,"mais de 360 dias")
	oBrowse:AddLegend(" A1_ULTCOM = stod('        ')"  ,"BLACK"      		,"NUNCA COMPROU")
	oBrowse:SetUseCursor(.T.)
	oBrowse:Activate()
	
Return(Nil)

Static Function MenuDef()
	Local aRotina := {}
	//-------------------------------------------------------
	// Adiciona botões do browse
	//-------------------------------------------------------
	//	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION "AxPesqui"      	   OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	ADD OPTION aRotina TITLE "Carregar Lat-Lon" ACTION "u_tstpost('07041030')" OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Mapa-Geral" ACTION "u_Mapa2()" OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Mapa Vendedor"  ACTION "u_Mapa3()" OPERATION 3 ACCESS 0 //"Incluir"
	//ADD OPTION aRotina TITLE "MAPA"    ACTION "U_Navegador" OPERATION 3 ACCESS 0 //"Incluir"
	//ADD OPTION aRotina TITLE "Bloquear/Desbloquear"   ACTION "u_BXDES" OPERATION 8 ACCESS 0 //"Imprimir"
	
	
Return aRotina

user function Mapa2( )
	
	Local cArq	 := "arquivo1.html"
	Local cFile  := "\html\"+cArq
	Local _cDirRel := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS')
	Local nH
	Local _cRR:= ' '
	Processa({|| 	_cRR:= STLATLON()},'Consultando...Aguarde.....!!!!!')
	 
	If !(Empty(Alltrim(_cRR)))
		
		_cTes:="<!DOCTYPE html>
		_cTes+=CR+" <html>
		_cTes+=CR+" <head>
		_cTes+=CR+' <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
		_cTes+=CR+' <meta charset="utf-8">
		_cTes+=CR+" <title>Marker Clustering</title>
		_cTes+=CR+" <style>
		_cTes+=CR+" /* Always set the map height explicitly to define the size of the div
		_cTes+=CR+" * element that contains the map. */
		_cTes+=CR+" #map {
		_cTes+=CR+" height: 100%;
			_cTes+=CR+" 	}
		_cTes+=CR+" /* Optional: Makes the sample page fill the window. */
		_cTes+=CR+" html, body {
		_cTes+=CR+" height: 100%;
			_cTes+=CR+" margin: 0;
			_cTes+=CR+" padding: 0;
			_cTes+=CR+" }
		_cTes+=CR+" </style>
		_cTes+=CR+" </head>
		_cTes+=CR+" <body>
		_cTes+=CR+' <div id="map"></div>
		_cTes+=CR+" <script>
		
		_cTes+=CR+" function initMap() {
		
		_cTes+=CR+" var map = new google.maps.Map(document.getElementById('map'), {
		_cTes+=CR+" zoom: 3,
		_cTes+=CR+" center: {lat: -22.73218, lng: -47.37218}
		_cTes+=CR+" });
			
			_cTes+=CR+" // Create an array of alphabetical characters used to label the markers.
		_cTes+=CR+" var labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
			
			_cTes+=CR+" // Add some markers to the map.
		_cTes+=CR+" // Note: The code uses the JavaScript Array.prototype.map() method to
		_cTes+=CR+' // create an array of markers based on a given "locations" array.
		_cTes+=CR+" // The map() method here has nothing to do with the Google Maps API.
		_cTes+=CR+" var markers = locations.map(function(location, i) {
		_cTes+=CR+" return new google.maps.Marker({
		_cTes+=CR+" position: location,
		_cTes+=CR+" label: labels[i % labels.length]
		_cTes+=CR+" });
			_cTes+=CR+" });
			
			_cTes+=CR+" // Add a marker clusterer to manage the markers.
		_cTes+=CR+" var markerCluster = new MarkerClusterer(map, markers,
		_cTes+=CR+" {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});
			_cTes+=CR+" }
		_cTes+=CR+" var locations = [
		_cTes+=CR+_cRR
		_cTes+=CR+" ]
		_cTes+=CR+" </script>
		_cTes+=CR+' <script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js">
		_cTes+=CR+" </script>
		_cTes+=CR+" <script async defer
		_cTes+=CR+' src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDJO042RXLiHHQEdgFESUqFSX9I-ibGDzg&callback=initMap">
		_cTes+=CR+" </script>
		_cTes+=CR+" </body>
		_cTes+=CR+" </html>
		
		nH := fCreate(cFile)
		If nH == -1
			MsgStop("Falha ao criar arquivo - erro "+str(ferror()))
			Return
		Endif
		
		// Escreve o texto mais a quebra de linha CRLF
		fWrite(nH,_cTes )
		fClose(nH)
		
		If !(ExistDir(_cDirRel))
			If MakeDir(_cDirRel) == 0
				MakeDir(_cDirRel)
			Endif
		Endif
		
		CpyS2T(cFile,_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USU�RIO
		ShellExecute("open",_cDirRel+"\"+cArq, "", "", 1)
		
		
	EndIf
	
Return


Static function STLATLON()
	
	Local _cRet 		:= ""
	Local cAliasSuper	:= 'STLATLON'
	Local cQuery     	:= ' '
	Local _nX			:= 0
	Local _nSai			:= GetMv("ST_LATLON",,1000)
	
	cQuery := " SELECT  A1_XLAT,A1_XLON  FROM SA1010 SA1  WHERE SA1.D_E_L_E_T_ = ' ' and  A1_XLAT <> '0' and (A1_XLAT <> ' ' OR A1_XLON <> ' ')
	
	
	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)
	
	
	
	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		
		
		While 	(cAliasSuper)->(!Eof())

			_nX++
			If _nSai <= _nX
				Exit
			EndIf
			If _nX > 1
				_cRet 	+= ","+CR
			EndIf
			
			_cRet 	+= "{lat: "+ Alltrim((cAliasSuper)->A1_XLAT) +", lng:"+ Alltrim((cAliasSuper)->A1_XLON)+"}"
			
			(cAliasSuper)->(dbskip())
			
		End
	EndIf
	
	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf
	
Return ( _cRet)





user function tstpost()
	
	
	Processa({|| 	xstpost()},'Consultando')
Return

Static function xstpost()
	
	Local cUrl 		:= " "
	Local nTimeOut 	:= 2
	Local aHeadOut 	:= {}
	Local cHeadRet 	:= ""
	Local sPostRet 	:= ""
	Local cAviso 	:= ""
	Local cErro 	:= ""
	Local _cGoo 	:= ""
	Local _cRet 	:= ""
	Local i 		:= 0
	Local j		 	:= 0
	Local _nKey	 	:= 1
	Local _nCod		:= 81000
	Local _n2Cod	:= 81000
	Local _cGooG	:= ' '
	Local _cKey1	:= 'AIzaSyAwxRkYEQNORzgYfnPACwaFrPwULe1qsaA'
	Local _cKey2	:= 'AIzaSyBTSpQE-GpIDEVyB39cFEkfRN8Cfh97P8M'
	Local _cKey3	:= 'AIzaSyDBPWZxT7OZn1MS9PIVhAg7w5yvm8DgyAg'
	Local _cKey4	:= 'AIzaSyBf3KDqdHKxCy50-0I4BVaZuJsgbpDOFRI'
	Local _cKey5	:= 'AIzaSyBFDCt6ls7tZ2jCHZeu0mmVGbTV3vf7juo'
	Local _cKey6	:= 'AIzaSyApN7zP1hakUuIQrKmnKtM0BnlOj0eLUzo'
	Local _cKey7	:= 'AIzaSyAIaUb9xb4j6Rf4E-vvipLDWIZ75TN5yzs'
	Local _cKey8	:= 'AIzaSyBjeEtDEJ0dFGHI0THUwuRi5w5pSYXVWjM'
	
	Local oGoogle
	aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
	aadd(aHeadOut,'Content-Type: application/x-www-form-urlencoded')
	
	
	ProcRegua(_nCod )
	dbSelectArea("SA1")
	SA1->(dbgotop())
	SA1->(dbsetorder(1))
	While SA1->(!Eof())
		_nCod--
		IncProc(cvaltochar(_nCod)+" / " + cvaltochar (_n2Cod)+' / '+SA1->A1_COD+SA1->A1_LOJA)
		If !(Empty(Alltrim(SA1->A1_CEP))) .And. SA1->A1_MSBLQL<>"1"  .And.  SA1->A1_EST <> 'EX' .And. !(SA1->A1_CEP $ 'XXXXXXXX/SP/PENDENTE/CX P.015/CX.P.45') .And. Empty(Alltrim(SA1->A1_XLON))
			cUrl   := "https://maps.google.com/maps/api/geocode/xml?address="+ Alltrim(SA1->A1_CEP)+"&key="+ Alltrim(_cKey1)+"&sensor=false"
			cAviso := ""
			cErro  := ""
			_cGoo  := ""
			_cGoo  :=  HttpPost(cUrl,"REQUEST=1212","EXAMPLEFIELD=DUMMY",nTimeOut,aHeadOut,@cHeadRet)
			If VALType(_cGoo) = 'C'
				oGoogle := XmlParser(_cGoo,"_",@cAviso,@cErro)
				If VALType(oGoogle) <> "U"
					If valtype(oGoogle:_GeocodeResponse) = 'O'
						If valtype(oGoogle:_GeocodeResponse:_status) = 'O'
							If oGoogle:_GeocodeResponse:_status:text = 'OK'
								If valtype(oGoogle:_GeocodeResponse:_result) = 'A'
									For i:=	1 To len(oGoogle:_GeocodeResponse:_result)
										For j:=	1 To len( oGoogle:_GeocodeResponse:_result[i]:_address_component)
											If Upper(oGoogle:_GeocodeResponse:_result[i]:_address_component[j]:_short_name:text) = 'BR'
												SA1->(RecLock("SA1",.F.))
												SA1->A1_XLAT	:= oGoogle:_GeocodeResponse:_result[i]:_geometry:_location:_lat:text
												SA1->A1_XLON	:= oGoogle:_GeocodeResponse:_result[i]:_geometry:_location:_lng:text
												SA1->(MsUnLock())
											EndIf
										next j
									next i
								Else
									SA1->(RecLock("SA1",.F.))
									SA1->A1_XLAT	:= oGoogle:_GeocodeResponse:_result:_geometry:_location:_lat:text
									SA1->A1_XLON	:= oGoogle:_GeocodeResponse:_result:_geometry:_location:_lng:text
									SA1->(MsUnLock())
								EndIf
							ElseIf oGoogle:_GeocodeResponse:_status:text = 'ZERO_RESULTS'
								SA1->(RecLock("SA1",.F.))
								SA1->A1_XLAT	:= '0'
								SA1->A1_XLON	:= '0'
								SA1->(MsUnLock())
							ElseIf oGoogle:_GeocodeResponse:_status:text = 'OVER_QUERY_LIMIT'
								_nKey++
								If _nKey =2
									_cKey1:=_cKey2
								ElseIf _nKey =3
									_cKey1:=_cKey3
								ElseIf _nKey =4
									_cKey1:=_cKey4
								ElseIf _nKey =5
									_cKey1:=_cKey5
								ElseIf _nKey =6
									_cKey1:=_cKey6
								ElseIf _nKey =7
									_cKey1:=_cKey7
								ElseIf _nKey =8
									_cKey1:=_cKey8
								Else
									exit
								EndIf
								
								
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		cUrl 		:= " "
		
		SA1->(dbskip())
		
	End
Return ( _cRet)





user function Mapa3( )
	
	Local cArq	 := "arquivo1.html"
	Local cFile  := "\html\"+cArq
	Local _cDirRel := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS')
	Local nH
	Local _cRR   := ' '
	Local _cPerg := 'MAPA3'
	
	Pergunte(_cPerg,.T.)
	
	
	Processa({|| 	_cRR:= MPVEND()},'Consultando...Aguarde.....!!!!!')
	 
	If !(Empty(Alltrim(_cRR)))
		
		_cTes:="<!DOCTYPE html>
		_cTes+=CR+" <html>
		_cTes+=CR+" <head>
		_cTes+=CR+' <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
		_cTes+=CR+' <meta charset="utf-8">
		_cTes+=CR+" <title>Marker Clustering</title>
		_cTes+=CR+" <style>
		_cTes+=CR+" /* Always set the map height explicitly to define the size of the div
		_cTes+=CR+" * element that contains the map. */
		_cTes+=CR+" #map {
		_cTes+=CR+" height: 100%;
			_cTes+=CR+" 	}
		_cTes+=CR+" /* Optional: Makes the sample page fill the window. */
		_cTes+=CR+" html, body {
		_cTes+=CR+" height: 100%;
			_cTes+=CR+" margin: 0;
			_cTes+=CR+" padding: 0;
			_cTes+=CR+" }
		_cTes+=CR+" </style>
		_cTes+=CR+" </head>
		_cTes+=CR+" <body>
		_cTes+=CR+' <div id="map"></div>
		_cTes+=CR+" <script>
		
		_cTes+=CR+" function initMap() {
		
		_cTes+=CR+" var map = new google.maps.Map(document.getElementById('map'), {
		_cTes+=CR+" zoom: 3,
		_cTes+=CR+" center: {lat: -22.73218, lng: -47.37218}
		_cTes+=CR+" });
			
		_cTes+=CR+" // Create an array of alphabetical characters used to label the markers.
		_cTes+=CR+" var labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
			
		_cTes+=CR+" // Add some markers to the map.
		_cTes+=CR+" // Note: The code uses the JavaScript Array.prototype.map() method to
		_cTes+=CR+' // create an array of markers based on a given "locations" array.
		_cTes+=CR+" // The map() method here has nothing to do with the Google Maps API.
		_cTes+=CR+" var markers = locations.map(function(location, i) {
		_cTes+=CR+" return new google.maps.Marker({
		_cTes+=CR+" position: location,
		_cTes+=CR+" label: labels[i % labels.length]
		_cTes+=CR+" });
			_cTes+=CR+" });
			
			_cTes+=CR+" // Add a marker clusterer to manage the markers.
		_cTes+=CR+" var markerCluster = new MarkerClusterer(map, markers,
		_cTes+=CR+" {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});
			_cTes+=CR+" }
		_cTes+=CR+" var locations = [
		_cTes+=CR+_cRR
		_cTes+=CR+" ]
		_cTes+=CR+" </script>
		_cTes+=CR+' <script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js">
		_cTes+=CR+" </script>
		_cTes+=CR+" <script async defer
		_cTes+=CR+' src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDJO042RXLiHHQEdgFESUqFSX9I-ibGDzg&callback=initMap">
		_cTes+=CR+" </script>
		_cTes+=CR+" </body>
		_cTes+=CR+" </html>
		
		nH := fCreate(cFile)
		If nH == -1
			MsgStop("Falha ao criar arquivo - erro "+str(ferror()))
			Return
		Endif
		
		// Escreve o texto mais a quebra de linha CRLF
		fWrite(nH,_cTes )
		fClose(nH)
		
		If !(ExistDir(_cDirRel))
			If MakeDir(_cDirRel) == 0
				MakeDir(_cDirRel)
			Endif
		Endif
		
		CpyS2T(cFile,_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USU�RIO
		ShellExecute("open",_cDirRel+"\"+cArq, "", "", 1)
		
		
	EndIf
	
Return


Static function MPVEND()
	
	Local _cRet 		:= ""
	Local cAliasSuper	:= 'STLATLON'
	Local cQuery     	:= ' '
	Local _nX			:= 0
	Local _nSai			:= GetMv("ST_LATLON",,1000)
	
	cQuery := " SELECT distinct Z1Q_LAT AS LAT ,Z1Q_LONG AS LON ,Z1Q.R_E_C_N_O_ FROM Z1Q010 Z1Q WHERE Z1Q.D_E_L_E_T_ = ' ' AND Z1Q_PLACA between '"+Mv_par01+"' and '"+Mv_par02+"'
	cQuery += " AND Z1Q_DATA between '"+ dtos(Mv_par03)+"' and '"+ dtos(Mv_par04)+"' and Z1Q_LAT <> '0'
	cQuery += " ORDER BY Z1Q.R_E_C_N_O_



	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)
	
	
	
	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		
		
		While 	(cAliasSuper)->(!Eof())

			_nX++
			If _nSai <= _nX
				Exit
			EndIf
			If _nX > 1
				_cRet 	+= ","+CR
			EndIf
			
			_cRet 	+= "{lat: "+ Alltrim((cAliasSuper)->LAT) +", lng:"+ Alltrim((cAliasSuper)->LON)+"}"
			
			(cAliasSuper)->(dbskip())
			
		End
	EndIf
	
	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf
	
Return ( _cRet)











#include 'Protheus.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "aarray.ch"
#INCLUDE "json.ch"

#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

#Define CR chr(13)+ chr(10)

User Function Z1809()

	Local _a25 :={ }
	Local _a13 :={ }
	Local _aRe :={}
	Local a,b,c,d,e,f,g,h,i,j,k,l,m,n,o

	//Local _a25 :={'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25'}
	//Local _a13 :={'01','02','03','04','05','06','07','08','09','10','11','12','13'}

	Aadd(_a13,{'01'})
	Aadd(_a13,{'02'})
	Aadd(_a13,{'03'})
	Aadd(_a13,{'04'})
	Aadd(_a13,{'05'})
	Aadd(_a13,{'06'})
	Aadd(_a13,{'07'})
	Aadd(_a13,{'08'})
	Aadd(_a13,{'09'})
	//Aadd(_a13,{'10'})
	//Aadd(_a13,{'11'})
	//Aadd(_a13,{'12'})
	//Aadd(_a13,{'13'})



	Aadd(_a25,{'01'})
	Aadd(_a25,{'02'})
	Aadd(_a25,{'03'})
	Aadd(_a25,{'04'})
	Aadd(_a25,{'05'})
	Aadd(_a25,{'06'})
	Aadd(_a25,{'07'})
	Aadd(_a25,{'08'})
	Aadd(_a25,{'09'})
	Aadd(_a25,{'10'})
	Aadd(_a25,{'11'})
	Aadd(_a25,{'12'})
	Aadd(_a25,{'13'})
	Aadd(_a25,{'14'})
	Aadd(_a25,{'15'})
	Aadd(_a25,{'16'})
	Aadd(_a25,{'17'})
	Aadd(_a25,{'18'})
	Aadd(_a25,{'19'})
	Aadd(_a25,{'20'})
	Aadd(_a25,{'21'})
	Aadd(_a25,{'22'})
	Aadd(_a25,{'23'})
	Aadd(_a25,{'24'})
	Aadd(_a25,{'25'})

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'

	For a:= 1 to Len(_a13)
		For b:= 1 to Len(_a25)-a
			For c:= 1 to Len(_a25)-a-b
				For d:= 1 to Len(_a25)-a-b-c
					For e:= 1 to Len(_a25)-a-b-c-d
						For f:= 1 to Len(_a25)-a-b-c-d-e
							For g:= 1 to Len(_a25)-a-b-c-d-e-f
								For h:= 1 to Len(_a25)-a-b-c-d-e-f-g
									For i:= 1 to Len(_a25)-a-b-c-d-e-f-g-h
										//	For j:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i
										//For l:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i-j
										//For m:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i-j-l
										//	For n:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i-j-l-m
										Aadd(_aRe,{ _a25[a,1],;
										_a25[a+b,1],;
										_a25[a+b+c,1],;
										_a25[a+b+c+d,1],;
										_a25[a+b+c+d+e,1],;
										_a25[a+b+c+d+e+f,1],;
										_a25[a+b+c+d+e+f+g,1],;
										_a25[a+b+c+d+e+f+g+h,1],;
										_a25[a+b+c+d+e+f+g+h+i,1];
										})

										Z18->(RecLock('Z18',.T.))
										Z18->Z18_FILIAL ='09'
										For o:=1 To 09
											&("Z18->Z18_C"+ Padl(cvaltochar(o),2,'0')) := _aRe[1,o]
										Next o

										Z18->(MsUnLock())
										Z18->(DbCommit())

										_aRe:={}
										//	Next n
										//Next m
										//Next l
										//Next j
									Next i
								Next h
							Next g
						Next f
					Next e
				Next d
			Next c
		Next b
	Next a

Return()
User Function Z1810()

	Local _a25 :={ }
	Local _a13 :={ }
	Local _aRe :={}
	Local a,b,c,d,e,f,g,h,i,j,k,l,m,n,o

	//Local _a25 :={'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25'}
	//Local _a13 :={'01','02','03','04','05','06','07','08','09','10','11','12','13'}

	Aadd(_a13,{'01'})
	Aadd(_a13,{'02'})
	Aadd(_a13,{'03'})
	Aadd(_a13,{'04'})
	Aadd(_a13,{'05'})
	Aadd(_a13,{'06'})
	Aadd(_a13,{'07'})
	Aadd(_a13,{'08'})
	Aadd(_a13,{'09'})
	Aadd(_a13,{'10'})
	//Aadd(_a13,{'11'})
	//Aadd(_a13,{'12'})
	//Aadd(_a13,{'13'})



	Aadd(_a25,{'01'})
	Aadd(_a25,{'02'})
	Aadd(_a25,{'03'})
	Aadd(_a25,{'04'})
	Aadd(_a25,{'05'})
	Aadd(_a25,{'06'})
	Aadd(_a25,{'07'})
	Aadd(_a25,{'08'})
	Aadd(_a25,{'09'})
	Aadd(_a25,{'10'})
	Aadd(_a25,{'11'})
	Aadd(_a25,{'12'})
	Aadd(_a25,{'13'})
	Aadd(_a25,{'14'})
	Aadd(_a25,{'15'})
	Aadd(_a25,{'16'})
	Aadd(_a25,{'17'})
	Aadd(_a25,{'18'})
	Aadd(_a25,{'19'})
	Aadd(_a25,{'20'})
	Aadd(_a25,{'21'})
	Aadd(_a25,{'22'})
	Aadd(_a25,{'23'})
	Aadd(_a25,{'24'})
	Aadd(_a25,{'25'})

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'

	For a:= 1 to Len(_a13)
		For b:= 1 to Len(_a25)-a
			For c:= 1 to Len(_a25)-a-b
				For d:= 1 to Len(_a25)-a-b-c
					For e:= 1 to Len(_a25)-a-b-c-d
						For f:= 1 to Len(_a25)-a-b-c-d-e
							For g:= 1 to Len(_a25)-a-b-c-d-e-f
								For h:= 1 to Len(_a25)-a-b-c-d-e-f-g
									For i:= 1 to Len(_a25)-a-b-c-d-e-f-g-h
										For j:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i
											//For l:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i-j
											//For m:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i-j-l
											//	For n:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i-j-l-m
											Aadd(_aRe,{ _a25[a,1],;
											_a25[a+b,1],;
											_a25[a+b+c,1],;
											_a25[a+b+c+d,1],;
											_a25[a+b+c+d+e,1],;
											_a25[a+b+c+d+e+f,1],;
											_a25[a+b+c+d+e+f+g,1],;
											_a25[a+b+c+d+e+f+g+h,1],;
											_a25[a+b+c+d+e+f+g+h+i,1],;
											_a25[a+b+c+d+e+f+g+h+i+j,1];
											})

											Z18->(RecLock('Z18',.T.))
											Z18->Z18_FILIAL ='10'
											For o:=1 To 10
												&("Z18->Z18_C"+ Padl(cvaltochar(o),2,'0')) := _aRe[1,o]
											Next o

											Z18->(MsUnLock())
											Z18->(DbCommit())

											_aRe:={}
											//	Next n
											//Next m
											//Next l
										Next j
									Next i
								Next h
							Next g
						Next f
					Next e
				Next d
			Next c
		Next b
	Next a

Return()

User Function Z1811()

	Local _a25 :={ }
	Local _a13 :={ }
	Local _aRe :={}
	Local a,b,c,d,e,f,g,h,i,j,k,l,m,n,o

	//Local _a25 :={'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25'}
	//Local _a13 :={'01','02','03','04','05','06','07','08','09','10','11','12','13'}

	Aadd(_a13,{'01'})
	Aadd(_a13,{'02'})
	Aadd(_a13,{'03'})
	Aadd(_a13,{'04'})
	Aadd(_a13,{'05'})
	Aadd(_a13,{'06'})
	Aadd(_a13,{'07'})
	Aadd(_a13,{'08'})
	Aadd(_a13,{'09'})
	Aadd(_a13,{'10'})
	Aadd(_a13,{'11'})
	//Aadd(_a13,{'12'})
	//Aadd(_a13,{'13'})



	Aadd(_a25,{'01'})
	Aadd(_a25,{'02'})
	Aadd(_a25,{'03'})
	Aadd(_a25,{'04'})
	Aadd(_a25,{'05'})
	Aadd(_a25,{'06'})
	Aadd(_a25,{'07'})
	Aadd(_a25,{'08'})
	Aadd(_a25,{'09'})
	Aadd(_a25,{'10'})
	Aadd(_a25,{'11'})
	Aadd(_a25,{'12'})
	Aadd(_a25,{'13'})
	Aadd(_a25,{'14'})
	Aadd(_a25,{'15'})
	Aadd(_a25,{'16'})
	Aadd(_a25,{'17'})
	Aadd(_a25,{'18'})
	Aadd(_a25,{'19'})
	Aadd(_a25,{'20'})
	Aadd(_a25,{'21'})
	Aadd(_a25,{'22'})
	Aadd(_a25,{'23'})
	Aadd(_a25,{'24'})
	Aadd(_a25,{'25'})

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'

	For a:= 1 to Len(_a13)
		For b:= 1 to Len(_a25)-a
			For c:= 1 to Len(_a25)-a-b
				For d:= 1 to Len(_a25)-a-b-c
					For e:= 1 to Len(_a25)-a-b-c-d
						For f:= 1 to Len(_a25)-a-b-c-d-e
							For g:= 1 to Len(_a25)-a-b-c-d-e-f
								For h:= 1 to Len(_a25)-a-b-c-d-e-f-g
									For i:= 1 to Len(_a25)-a-b-c-d-e-f-g-h
										For j:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i
											For l:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i-j
												//For m:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i-j-l
												//	For n:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i-j-l-m
												Aadd(_aRe,{ _a25[a,1],;
												_a25[a+b,1],;
												_a25[a+b+c,1],;
												_a25[a+b+c+d,1],;
												_a25[a+b+c+d+e,1],;
												_a25[a+b+c+d+e+f,1],;
												_a25[a+b+c+d+e+f+g,1],;
												_a25[a+b+c+d+e+f+g+h,1],;
												_a25[a+b+c+d+e+f+g+h+i,1],;
												_a25[a+b+c+d+e+f+g+h+i+j,1],;
												_a25[a+b+c+d+e+f+g+h+i+j+l,1];
												})

												Z18->(RecLock('Z18',.T.))
												Z18->Z18_FILIAL ='11'
												For o:=1 To 11
													&("Z18->Z18_C"+ Padl(cvaltochar(o),2,'0')) := _aRe[1,o]
												Next o

												Z18->(MsUnLock())
												Z18->(DbCommit())

												_aRe:={}
												//	Next n
												//Next m
											Next l
										Next j
									Next i
								Next h
							Next g
						Next f
					Next e
				Next d
			Next c
		Next b
	Next a

Return()

User Function Z1812()

	Local _a25 :={ }
	Local _a13 :={ }
	Local _aRe :={}
	Local a,b,c,d,e,f,g,h,i,j,k,l,m,n,o

	//Local _a25 :={'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25'}
	//Local _a13 :={'01','02','03','04','05','06','07','08','09','10','11','12','13'}

	Aadd(_a13,{'01'})
	Aadd(_a13,{'02'})
	Aadd(_a13,{'03'})
	Aadd(_a13,{'04'})
	Aadd(_a13,{'05'})
	Aadd(_a13,{'06'})
	Aadd(_a13,{'07'})
	Aadd(_a13,{'08'})
	Aadd(_a13,{'09'})
	Aadd(_a13,{'10'})
	Aadd(_a13,{'11'})
	Aadd(_a13,{'12'})
	//Aadd(_a13,{'13'})



	Aadd(_a25,{'01'})
	Aadd(_a25,{'02'})
	Aadd(_a25,{'03'})
	Aadd(_a25,{'04'})
	Aadd(_a25,{'05'})
	Aadd(_a25,{'06'})
	Aadd(_a25,{'07'})
	Aadd(_a25,{'08'})
	Aadd(_a25,{'09'})
	Aadd(_a25,{'10'})
	Aadd(_a25,{'11'})
	Aadd(_a25,{'12'})
	Aadd(_a25,{'13'})
	Aadd(_a25,{'14'})
	Aadd(_a25,{'15'})
	Aadd(_a25,{'16'})
	Aadd(_a25,{'17'})
	Aadd(_a25,{'18'})
	Aadd(_a25,{'19'})
	Aadd(_a25,{'20'})
	Aadd(_a25,{'21'})
	Aadd(_a25,{'22'})
	Aadd(_a25,{'23'})
	Aadd(_a25,{'24'})
	Aadd(_a25,{'25'})

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'

	For a:= 1 to Len(_a13)
		For b:= 1 to Len(_a25)-a
			For c:= 1 to Len(_a25)-a-b
				For d:= 1 to Len(_a25)-a-b-c
					For e:= 1 to Len(_a25)-a-b-c-d
						For f:= 1 to Len(_a25)-a-b-c-d-e
							For g:= 1 to Len(_a25)-a-b-c-d-e-f
								For h:= 1 to Len(_a25)-a-b-c-d-e-f-g
									For i:= 1 to Len(_a25)-a-b-c-d-e-f-g-h
										For j:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i
											For l:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i-j
												For m:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i-j-l
													//	For n:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i-j-l-m
													Aadd(_aRe,{ _a25[a,1],;
													_a25[a+b,1],;
													_a25[a+b+c,1],;
													_a25[a+b+c+d,1],;
													_a25[a+b+c+d+e,1],;
													_a25[a+b+c+d+e+f,1],;
													_a25[a+b+c+d+e+f+g,1],;
													_a25[a+b+c+d+e+f+g+h,1],;
													_a25[a+b+c+d+e+f+g+h+i,1],;
													_a25[a+b+c+d+e+f+g+h+i+j,1],;
													_a25[a+b+c+d+e+f+g+h+i+j+l,1],;
													_a25[a+b+c+d+e+f+g+h+i+j+l+m,1];
													})

													Z18->(RecLock('Z18',.T.))
													Z18->Z18_FILIAL ='12'
													For o:=1 To 12
														&("Z18->Z18_C"+ Padl(cvaltochar(o),2,'0')) := _aRe[1,o]
													Next o

													Z18->(MsUnLock())
													Z18->(DbCommit())

													_aRe:={}
													//	Next n
												Next m
											Next l
										Next j
									Next i
								Next h
							Next g
						Next f
					Next e
				Next d
			Next c
		Next b
	Next a

Return()




User Function Z1800()//z1813

	Local _a25 :={ }
	Local _a13 :={ }
	Local _aRe :={}
	Local a,b,c,d,e,f,g,h,i,j,k,l,m,n,o
	Return()
	//Local _a25 :={'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25'}
	//Local _a13 :={'01','02','03','04','05','06','07','08','09','10','11','12','13'}

	Aadd(_a13,{'01'})
	Aadd(_a13,{'02'})
	Aadd(_a13,{'03'})
	Aadd(_a13,{'04'})
	Aadd(_a13,{'05'})
	Aadd(_a13,{'06'})
	Aadd(_a13,{'07'})
	Aadd(_a13,{'08'})
	Aadd(_a13,{'09'})
	Aadd(_a13,{'10'})
	Aadd(_a13,{'11'})
	Aadd(_a13,{'12'})
	Aadd(_a13,{'13'})



	Aadd(_a25,{'01'})
	Aadd(_a25,{'02'})
	Aadd(_a25,{'03'})
	Aadd(_a25,{'04'})
	Aadd(_a25,{'05'})
	Aadd(_a25,{'06'})
	Aadd(_a25,{'07'})
	Aadd(_a25,{'08'})
	Aadd(_a25,{'09'})
	Aadd(_a25,{'10'})
	Aadd(_a25,{'11'})
	Aadd(_a25,{'12'})
	Aadd(_a25,{'13'})
	Aadd(_a25,{'14'})
	Aadd(_a25,{'15'})
	Aadd(_a25,{'16'})
	Aadd(_a25,{'17'})
	Aadd(_a25,{'18'})
	Aadd(_a25,{'19'})
	Aadd(_a25,{'20'})
	Aadd(_a25,{'21'})
	Aadd(_a25,{'22'})
	Aadd(_a25,{'23'})
	Aadd(_a25,{'24'})
	Aadd(_a25,{'25'})

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'

	For a:= 1 to Len(_a13)
		For b:= 1 to Len(_a25)-a
			For c:= 1 to Len(_a25)-a-b
				For d:= 1 to Len(_a25)-a-b-c
					For e:= 1 to Len(_a25)-a-b-c-d
						For f:= 1 to Len(_a25)-a-b-c-d-e
							For g:= 1 to Len(_a25)-a-b-c-d-e-f
								For h:= 1 to Len(_a25)-a-b-c-d-e-f-g
									For i:= 1 to Len(_a25)-a-b-c-d-e-f-g-h
										For j:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i
											For l:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i-j
												For m:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i-j-l
													For n:= 1 to Len(_a25)-a-b-c-d-e-f-g-h-i-j-l-m
														Aadd(_aRe,{ _a25[a,1],;
														_a25[a+b,1],;
														_a25[a+b+c,1],;
														_a25[a+b+c+d,1],;
														_a25[a+b+c+d+e,1],;
														_a25[a+b+c+d+e+f,1],;
														_a25[a+b+c+d+e+f+g,1],;
														_a25[a+b+c+d+e+f+g+h,1],;
														_a25[a+b+c+d+e+f+g+h+i,1],;
														_a25[a+b+c+d+e+f+g+h+i+j,1],;
														_a25[a+b+c+d+e+f+g+h+i+j+l,1],;
														_a25[a+b+c+d+e+f+g+h+i+j+l+m,1],;
														_a25[a+b+c+d+e+f+g+h+i+j+l+m+n,1];
														})

														Z18->(RecLock('Z18',.T.))

														For o:=1 To 13
															&("Z18->Z18_C"+ Padl(cvaltochar(o),2,'0')) := _aRe[1,o]
														Next o

														Z18->(MsUnLock())
														Z18->(DbCommit())

														_aRe:={}
													Next n
												Next m
											Next l
										Next j
									Next i
								Next h
							Next g
						Next f
					Next e
				Next d
			Next c
		Next b
	Next a

Return()


User Function Z18x()
	Local a
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'

	For a:= 1 to 30

		StartJob("U_Z1801",GetEnvServer(), .F. , a*60-59)

	Next a


Return()
User Function Z1801(_cRx)
	Local _nrx			:= _cRx//val(_cRx)
	Local cQuery		:= ""
	Local cPerg 		:= "Z18"+cvaltochar(_cRx)
	Local cTime         := ''
	Local cHora         := ''
	Local cMinutos    	:= ''
	Local cSegundos   	:= ''
	Local cAliasLif   	:= ''
	Local _aZ17   		:= {}
	Local _aZ17Temp   	:= {}
	Local a,b,c
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'

	cTime           := Time()
	cHora           := SUBSTR(cTime, 1, 2)
	cMinutos    	:= SUBSTR(cTime, 4, 2)
	cSegundos   	:= SUBSTR(cTime, 7, 2)
	cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos



	cQuery := " SELECT
	cQuery += " CASE WHEN Z17_C01 = 1 THEN '01' ELSE ' ' END C01,
	cQuery += " CASE WHEN Z17_C02 = 1 THEN '02' ELSE ' ' END C02,
	cQuery += " CASE WHEN Z17_C03 = 1 THEN '03' ELSE ' ' END C03,
	cQuery += " CASE WHEN Z17_C04 = 1 THEN '04' ELSE ' ' END C04,
	cQuery += " CASE WHEN Z17_C05 = 1 THEN '05' ELSE ' ' END C05,
	cQuery += " CASE WHEN Z17_C06 = 1 THEN '06' ELSE ' ' END C06,
	cQuery += " CASE WHEN Z17_C07 = 1 THEN '07' ELSE ' ' END C07,
	cQuery += " CASE WHEN Z17_C08 = 1 THEN '08' ELSE ' ' END C08,
	cQuery += " CASE WHEN Z17_C09 = 1 THEN '09' ELSE ' ' END C09,
	cQuery += " CASE WHEN Z17_C10 = 1 THEN '10' ELSE ' ' END C10,
	cQuery += " CASE WHEN Z17_C11 = 1 THEN '11' ELSE ' ' END C11,
	cQuery += " CASE WHEN Z17_C12 = 1 THEN '12' ELSE ' ' END C12,
	cQuery += " CASE WHEN Z17_C13 = 1 THEN '13' ELSE ' ' END C13,
	cQuery += " CASE WHEN Z17_C14 = 1 THEN '14' ELSE ' ' END C14,
	cQuery += " CASE WHEN Z17_C15 = 1 THEN '15' ELSE ' ' END C15,
	cQuery += " CASE WHEN Z17_C16 = 1 THEN '16' ELSE ' ' END C16,
	cQuery += " CASE WHEN Z17_C17 = 1 THEN '17' ELSE ' ' END C17,
	cQuery += " CASE WHEN Z17_C18 = 1 THEN '18' ELSE ' ' END C18,
	cQuery += " CASE WHEN Z17_C19 = 1 THEN '19' ELSE ' ' END C19,
	cQuery += " CASE WHEN Z17_C20 = 1 THEN '20' ELSE ' ' END C20,
	cQuery += " CASE WHEN Z17_C21 = 1 THEN '21' ELSE ' ' END C21,
	cQuery += " CASE WHEN Z17_C22 = 1 THEN '22' ELSE ' ' END C22,
	cQuery += " CASE WHEN Z17_C23 = 1 THEN '23' ELSE ' ' END C23,
	cQuery += " CASE WHEN Z17_C24 = 1 THEN '24' ELSE ' ' END C24,
	cQuery += " CASE WHEN Z17_C25 = 1 THEN '25' ELSE ' ' END C25
	cQuery += " FROM Z17010 Z17
	cQuery += " WHERE Z17.D_E_L_E_T_ = ' '


	cQuery += " ORDER BY R_E_C_N_O_



	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			For a:=1 To 25
				If (cAliasLif)->&('C'+ Padl(cvaltochar(a),2,'0')) <> ' '
					AaDd(_aZ17Temp,{(cAliasLif)->&('C'+ Padl(cvaltochar(a),2,'0'))})
				EndIf
			Next a


			AaDd(_aZ17,{_aZ17Temp[1,1],;
			_aZ17Temp[2,1],;
			_aZ17Temp[3,1],;
			_aZ17Temp[4,1],;
			_aZ17Temp[5,1],;
			_aZ17Temp[6,1],;
			_aZ17Temp[7,1],;
			_aZ17Temp[8,1],;
			_aZ17Temp[9,1],;
			_aZ17Temp[10,1],;
			_aZ17Temp[11,1],;
			_aZ17Temp[12,1],;
			_aZ17Temp[13,1],;
			_aZ17Temp[14,1],;
			_aZ17Temp[15,1];
			})

			_aZ17Temp:= {}

			(cAliasLif)->(DbSkip())

		End

	EndIf

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf



	cQuery := " SELECT
	cQuery += "   Z18_C01 C01,
	cQuery += "    Z18_C02 C02,
	cQuery += "   Z18_C03 C03,
	cQuery += "    Z18_C04 C04,
	cQuery += "   Z18_C05 C05,
	cQuery += "    Z18_C06 C06,
	cQuery += "    Z18_C07 C07,
	cQuery += "    Z18_C08 C08,
	cQuery += "    Z18_C09 C09,
	cQuery += "    Z18_C10 C10,
	cQuery += "    Z18_C11 C11,
	cQuery += "    Z18_C12 C12,
	cQuery += "    Z18_C13 C13,
	cQuery += "    R_E_C_N_O_ AS REC
	cQuery += "   FROM Z18010 Z18


	cQuery += "   WHERE Z18.D_E_L_E_T_ = ' '
	cQuery += "   ORDER BY R_E_C_N_O_




	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			For b:= _nrx To (_nrx+60)
				If b <= 1747
					_n13:=0
					For c:=1 To 13


						If aScan(_aZ17[b],{|aX|aX=(cAliasLif)->&('C'+ Padl(cvaltochar(c),2,'0'))}) <> 0
							_n13++
						EndIf


					Next c
					If _n13 >= 13
						DbSelectArea("Z18")
						Z18->(DbGoTo((cAliasLif)->REC ))
						If (cAliasLif)->REC    = Z18->(RECNO())
							Z18->(RecLock("Z18",.F.))
							Z18->Z18_FILIAL  := '00'
							Z18->(MsUnlock())
							Z18->( DbCommit() )
						EndIf

					EndIf
				EndIf
			Next b




			(cAliasLif)->(DbSkip())

		End

	EndIf

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf





Return()



User Function Z1803(_cxx)
	Local _nrx			:= 0//val(_cRx)
	Local cQuery		:= ""
	Local cPerg 		:= "Z18"
	Local cTime         := ''
	Local cHora         := ''
	Local cMinutos    	:= ''
	Local cSegundos   	:= ''
	Local cAliasLif   	:= ''
	Local _aZ17   		:= {}
	Local _aZ17Temp   	:= {}
	Local a,b,c
	Local _aA   		:= {}
	Local _aB   		:= {}
	Local _aC   		:= {}
	Local _aD   		:= {}
	Local _aE   		:= {}
	Default _cxx:= ' '
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'

	cTime           := Time()
	cHora           := SUBSTR(cTime, 1, 2)
	cMinutos    	:= SUBSTR(cTime, 4, 2)
	cSegundos   	:= SUBSTR(cTime, 7, 2)
	cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos



	cQuery := " SELECT
	cQuery += " CASE WHEN Z17_C01 = 1 THEN '01' ELSE ' ' END C01,
	cQuery += " CASE WHEN Z17_C02 = 1 THEN '02' ELSE ' ' END C02,
	cQuery += " CASE WHEN Z17_C03 = 1 THEN '03' ELSE ' ' END C03,
	cQuery += " CASE WHEN Z17_C04 = 1 THEN '04' ELSE ' ' END C04,
	cQuery += " CASE WHEN Z17_C05 = 1 THEN '05' ELSE ' ' END C05,
	cQuery += " CASE WHEN Z17_C06 = 1 THEN '06' ELSE ' ' END C06,
	cQuery += " CASE WHEN Z17_C07 = 1 THEN '07' ELSE ' ' END C07,
	cQuery += " CASE WHEN Z17_C08 = 1 THEN '08' ELSE ' ' END C08,
	cQuery += " CASE WHEN Z17_C09 = 1 THEN '09' ELSE ' ' END C09,
	cQuery += " CASE WHEN Z17_C10 = 1 THEN '10' ELSE ' ' END C10,
	cQuery += " CASE WHEN Z17_C11 = 1 THEN '11' ELSE ' ' END C11,
	cQuery += " CASE WHEN Z17_C12 = 1 THEN '12' ELSE ' ' END C12,
	cQuery += " CASE WHEN Z17_C13 = 1 THEN '13' ELSE ' ' END C13,
	cQuery += " CASE WHEN Z17_C14 = 1 THEN '14' ELSE ' ' END C14,
	cQuery += " CASE WHEN Z17_C15 = 1 THEN '15' ELSE ' ' END C15,
	cQuery += " CASE WHEN Z17_C16 = 1 THEN '16' ELSE ' ' END C16,
	cQuery += " CASE WHEN Z17_C17 = 1 THEN '17' ELSE ' ' END C17,
	cQuery += " CASE WHEN Z17_C18 = 1 THEN '18' ELSE ' ' END C18,
	cQuery += " CASE WHEN Z17_C19 = 1 THEN '19' ELSE ' ' END C19,
	cQuery += " CASE WHEN Z17_C20 = 1 THEN '20' ELSE ' ' END C20,
	cQuery += " CASE WHEN Z17_C21 = 1 THEN '21' ELSE ' ' END C21,
	cQuery += " CASE WHEN Z17_C22 = 1 THEN '22' ELSE ' ' END C22,
	cQuery += " CASE WHEN Z17_C23 = 1 THEN '23' ELSE ' ' END C23,
	cQuery += " CASE WHEN Z17_C24 = 1 THEN '24' ELSE ' ' END C24,
	cQuery += " CASE WHEN Z17_C25 = 1 THEN '25' ELSE ' ' END C25
	cQuery += " FROM Z17010 Z17
	cQuery += " WHERE Z17.D_E_L_E_T_ = ' '
	//cQuery += " AND Z17_NUM='1749' AND ROWNUM = 1
	cQuery += "     ORDER BY R_E_C_N_O_ DESC


	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		//While 	(cAliasLif)->(!Eof())
		_aZ17x:={}
		_aZ17Tx:={}
		For a:=1 To 25
			If (cAliasLif)->&('C'+ Padl(cvaltochar(a),2,'0')) <> ' '
				AaDd(_aZ17Temp,{(cAliasLif)->&('C'+ Padl(cvaltochar(a),2,'0'))})
			Else
				AaDd(_aZ17Tx,{ Padl(cvaltochar(a),2,'0')})
			EndIf
		Next a


		AaDd(_aZ17,{_aZ17Temp[1,1],;
		_aZ17Temp[2,1],;
		_aZ17Temp[3,1],;
		_aZ17Temp[4,1],;
		_aZ17Temp[5,1],;
		_aZ17Temp[6,1],;
		_aZ17Temp[7,1],;
		_aZ17Temp[8,1],;
		_aZ17Temp[9,1],;
		_aZ17Temp[10,1],;
		_aZ17Temp[11,1],;
		_aZ17Temp[12,1],;
		_aZ17Temp[13,1],;
		_aZ17Temp[14,1],;
		_aZ17Temp[15,1];
		})


		AaDd(_aZ17x,{_aZ17Tx[1,1],;
		_aZ17Tx[2,1],;
		_aZ17Tx[3,1],;
		_aZ17Tx[4,1],;
		_aZ17Tx[5,1],;
		_aZ17Tx[6,1],;
		_aZ17Tx[7,1],;
		_aZ17Tx[8,1],;
		_aZ17Tx[9,1],;
		_aZ17Tx[10,1];
		})


		//(cAliasLif)->(DbSkip())

		//	End

	EndIf


	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	If Len(_aZ17Tx) > 0
		For b:=1 To Len(_aZ17Tx)

			If b <3
				AaDD(_aA,_aZ17Tx[b,1])
			ElseIf b <5
				AaDD(_aB,_aZ17Tx[b,1])
			ElseIf b <7
				AaDD(_aC,_aZ17Tx[b,1])
			ElseIf b <9
				AaDD(_aD,_aZ17Tx[b,1])
			ElseIf b <11
				AaDD(_aE,_aZ17Tx[b,1])
			EndIf
		Next b

		For b:=1 To Len(_aZ17Temp)

			If _aA[2] < _aZ17Temp[B,1] .And. Len(_aA) <5
				AaDD(_aA,_aZ17Temp[b,1])
			ElseIf _aB[2] < _aZ17Temp[B,1] .And. Len(_aB) <5
				AaDD(_aB,_aZ17Temp[b,1])
			ElseIf _aC[2] < _aZ17Temp[B,1] .And. Len(_aC) <5
				AaDD(_aC,_aZ17Temp[b,1])
			ElseIf _aD[2] < _aZ17Temp[B,1] .And. Len(_aD) <5
				AaDD(_aD,_aZ17Temp[b,1])
			ElseIf _aE[2] < _aZ17Temp[B,1] .And. Len(_aE) <5
				AaDD(_aE,_aZ17Temp[b,1])
			EndIf


		Next b



	EndIf

	_cA:= ' '
	_cB:= ''
	_cC:= ''
	_cD:= ''
	_cE:= ''


	For c:= 1 to Len(_aA)
		_cA+=_aA[c]+'-'
	Next c

	For c:= 1 to Len(_aB)
		_cB+=_aB[c]+'-'
	Next c

	For c:= 1 to Len(_aC)
		_cC+=_aC[c]+'-'
	Next c

	For c:= 1 to Len(_aD)
		_cD+=_aD[c]+'-'
	Next c

	For c:= 1 to Len(_aE)
		_cE+=_aE[c]+'-'
	Next c

	_cret01:=_cA+_cB+_cC
	_cret02:=_cA+_cB+_cD
	_cret03:=_cA+_cB+_cE
	_cret04:=_cA+_cC+_cD
	_cret05:=_cA+_cC+_cE
	_cret06:=_cA+_cD+_cE
	_cretx:= ' '
	If _cxx = '1'
		_cretx:= _cret01
	ElseIf _cxx = '2'
		_cretx:= _cret02
	ElseIf _cxx = '3'
		_cretx:= _cret03
	ElseIf _cxx = '4'
		_cretx:= _cret04
	ElseIf _cxx = '5'
		_cretx:= _cret05
	ElseIf _cxx = '6'
		_cretx:= _cret06
	EndIf



	_cEmail   := ''
	_cAssunto := 'TESTE'
	cMsg := ""
	cMsg += '<html><body>'
	cMsg += '<b>J01: '+_cret01+'  </b><br>
	cMsg += '<b>J02: '+_cret02+' </b><br>
	cMsg += '<b>J03: '+_cret03+' </b><br>
	cMsg += '<b>J04: '+_cret04+' </b><br>
	cMsg += '<b>J05: '+_cret05+' </b><br>
	cMsg += '<b>J06: '+_cret06+' </b><br>
	cMsg += '</body></html>'

	If Empty(Alltrim(_cxx)) .or. _cxx = '6'
		//	U_STMAILTES(_cEmail, '', _cAssunto, cMsg,{},'')
	EndIf





Return(_cretx)




User Function STLFAPI()

	Local cHttpGet			:= ""
	Local cUrl				:= "http://apiloterias.com.br/app/resultado?loteria=lotofacil&token=tGoa4OffgERcqFQ&concurso="
	Local aHeadOut			:= {}
	Local _cEmp				:= "01"
	Local _cFil				:= "02"
	Local nTimeOut 			:= 120
	Local cHeadRet 			:= ""
	Local cToken			:= "tGoa4OffgERcqFQ"
	Local _nX				:= 0
	Local i					:= 0
	Local b					:= 0
	Local oInfo
	Local oObj1
	Local _lRet				:= .F.


	//PREPARE ENVIRONMENT EMPRESA _cEmp FILIAL _cFil TABLES 'Z17'

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	For i:= 1 To 2000

		cHttpGet 	:= HttpSGet(cUrl+cvaltochar(i),"","","","",nTimeOut,aHeadOut,@cHeadRet)

		_lRet    := FWJsonDeserialize(cHttpGet,@oInfo)


		If _lRet

			DbSelectArea("Z17")
			Z17->(DbSetOrder(1))
			If !(Z17->(DbSeek(xFilial("Z17")+ Padl(Alltrim(cValToChar(oInfo:numero_concurso)),4,'0'))))

				Z17->(RecLock('Z17',.T.))
				Z17->Z17_NUM    := Padl(Alltrim(cValToChar(oInfo:numero_concurso)),4,'0')
				For _nX:=1 To Len(oInfo:dezenas)
					&("Z17->Z17_C"+ Padl(Alltrim(oInfo:dezenas[_nX]),2,'0')) :=   Padl(Alltrim(cValToChar(oInfo:dezenas[_nX])),2,'0')
				Next _nX

				Z17->(MsUnLock())
				Z17->(DbCommit())
			EndIf
		EndIf
		cHttpGet			:= ""
		aHeadOut			:= {}
		cHeadRet 			:= ""

		_lRet:= .F.

	Next i
Return()





















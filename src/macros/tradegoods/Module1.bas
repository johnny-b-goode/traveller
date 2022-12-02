REM  *****  BASIC  *****
OPTION EXPLICIT

FUNCTION GETFLAGS()
	Dim intFlags				AS INTEGER

	intFlags = 0
	intFlags = (intFlags + com.sun.star.sheet.CellFlags.VALUE)
	intFlags = (intFlags + com.sun.star.sheet.CellFlags.DATETIME)
	intFlags = (intFlags + com.sun.star.sheet.CellFlags.STRING)
	intFlags = (intFlags + com.sun.star.sheet.CellFlags.ANNOTATION)
	intFlags = (intFlags + com.sun.star.sheet.CellFlags.FORMULA)

	GetFlags = intFlags
END FUNCTION

SUB RollSale(intStart, intEnd)
	IF NOT BasicLibraries.isLibraryLoaded("DiceRoll") THEN
		BasicLibraries.LoadLibrary("DiceRoll")
	END IF

	DIM intCount				AS INTEGER
	Dim intFlags				AS INTEGER
	DIM objSheets				AS OBJECT
	DIM objTrade				AS OBJECT

	objSheets = ThisComponent.getSheets()
	objTrade = objSheets.getByName("trade")
	intFlags = GETFLAGS()
	intCount = intStart

	DO WHILE (intCount < intEnd)
		DIM objCellN			AS OBJECT
		objCellN = objTrade.getCellByPosition(13, intCount)

		REM this is not working correctly...
		IF NOT (objTrade.getCellByPosition(0, intCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
			objCellN.Value = DICEROLL_IMPLEMENTATION("3D6")
		ELSE
			REM objCellN.Value = com.sun.star.table.CellContentType.EMPTY
			REM objCellN.clearContents(31)
			objCellN.clearContents(intFlags)
		END IF

		intCount = (intcount + 1)
	LOOP
END SUB

SUB ButtonRoll1
	IF NOT BasicLibraries.isLibraryLoaded("DiceRoll") THEN
		BasicLibraries.LoadLibrary("DiceRoll")
	END IF

	DIM objCell					AS OBJECT
	DIM objSheets				AS OBJECT
	DIM objTrade				AS OBJECT

	objSheets = ThisComponent.getSheets()
	objTrade = objSheets.getByName("trade")
	objCell = objTrade.getCellByPosition(7, 4)
	REM MSGBOX DICEROLL_IMPLEMENTATION("2D6")
	objCell.Value = DICEROLL_IMPLEMENTATION("2D6")
END SUB

SUB ButtonRoll2
	IF NOT BasicLibraries.isLibraryLoaded("DiceRoll") THEN
		BasicLibraries.LoadLibrary("DiceRoll")
	END IF

	DIM objCell					AS OBJECT
	DIM objSheets				AS OBJECT
	DIM objTrade				AS OBJECT

	objSheets = ThisComponent.getSheets()
	objTrade = objSheets.getByName("trade")
	objCell = objTrade.getCellByPosition(7, 6)
	objCell.Value = DICEROLL_IMPLEMENTATION("2D6")
END SUB

SUB ButtonRoll3A
	IF NOT BasicLibraries.isLibraryLoaded("DiceRoll") THEN
		BasicLibraries.LoadLibrary("DiceRoll")
	END IF

	DIM intCount				AS INTEGER
	DIM objSheets				AS OBJECT
	DIM objTrade				AS OBJECT

	objSheets = ThisComponent.getSheets()
	objTrade = objSheets.getByName("trade")
	intCount = 25

	DO WHILE (NOT (objTrade.getCellByPosition(0, intCount).Type = com.sun.star.table.CellContentType.EMPTY)) AND (intCount < 32)
		DIM objCellC			AS OBJECT
		DIM objCellD			AS OBJECT
		DIM objCellJ			AS OBJECT
		REM DIM objCellN			AS OBJECT

		objCellC = objTrade.getCellByPosition(2, intCount)
		objCellD = objTrade.getCellByPosition(3, intCount)
		objCellJ = objTrade.getCellByPosition(9, intCount)
		objCellD.Value = DICEROLL_IMPLEMENTATION(objCellC.String)
		objCellJ.Value = DICEROLL_IMPLEMENTATION("3D6")
		intCount = (intcount + 1)
	LOOP
END SUB

SUB ButtonRoll3B
	RollSale(25, 31)
END SUB

SUB ButtonRoll4A
	IF NOT BasicLibraries.isLibraryLoaded("DiceRoll") THEN
		BasicLibraries.LoadLibrary("DiceRoll")
	END IF

	DIM intCount				AS INTEGER
	DIM intFlags				AS INTEGER
	DIM intMaxRow				AS INTEGER
	DIM intTradeGoodCount		AS INTEGER
	DIM intTradeGoodMaxRow		AS INTEGER
	DIM intWTGCount				AS INTEGER
	DIM intWTGMax				AS INTEGER
	DIM objCellA				AS OBJECT
	DIM objCellB				AS OBJECT
	DIM objCellC				AS OBJECT
	DIM objCellD				AS OBJECT
	DIM objCellJ				AS OBJECT
	DIM objService				AS OBJECT
	DIM objSheets				AS OBJECT
	DIM objTrade				AS OBJECT
	DIM objTradeGoods			AS OBJECT
	REM DIM objTradeGoodsRange		AS OBJECT

	objService = createUnoService("com.sun.star.sheet.FunctionAccess")
	objSheets = ThisComponent.getSheets()
	objTrade = objSheets.getByName("trade")
	objTradeGoods = objSheets.getByName("table-trade_goods")
	REM objTradeCodesRange = objTradeCodes.getCellRangeByName("$C$2:$C$36")
	intFlags = GETFLAGS()
	intCount = 2
	intMaxRow = 20
	intWTGCount = 33
	intWTGMax = 49

	DO WHILE (intWTGCount < intWTGMax)
		REM DIM objCellA			AS OBJECT
		REM DIM objCellD			AS OBJECT
		REM DIM objCellJ			AS OBJECT

		objCellA = objTrade.getCellByPosition(0, intWTGCount)
		objCellD = objTrade.getCellByPosition(3, intWTGCount)
		objCellJ = objTrade.getCellByPosition(9, intWTGCount)
		objCellA.clearContents(intFlags)
		objCellD.clearContents(intFlags)
		objCellJ.clearContents(intFlags)
		intWTGCount = (intWTGCount + 1)
	LOOP

	DO WHILE (intCount < intMaxRow)
		REM DIM objCellB			AS OBJECT
		REM DIM objCellC			AS OBJECT

		objCellB = objTrade.getCellByPosition(1, intCount)
		objCellC = objTrade.getCellByPosition(2, intCount)

		IF (objCellC.String = "Yes") THEN
			REM MSGBOX "World is " + objCellB.String
			intTradeGoodCount = 1
			intTradeGoodMaxRow = 30

			DO WHILE (intTradeGoodCount < intTradeGoodMaxRow)
				DIM objTradeGoodCellC	AS OBJECT

				objTradeGoodCellC = objTradeGoods.getCellByPosition(2, intTradeGoodCount)
				REM MSGBOX "Looking for " + Trim(objCellB.String) + " in " + Trim(objTradeGoodCellC.String)

				IF (Instr(Trim(objTradeGoodCellC.String), Trim(objCellB.String))) THEN
					REM DIM objCellA			AS OBJECT
					REM DIM objCellC			AS OBJECT
					REM DIM objCellD			AS OBJECT
					REM DIM objCellJ			AS OBJECT
					DIM objTradeGoodCellA	AS OBJECT

					objTradeGoodCellA = objTradeGoods.getCellByPosition(0, intTradeGoodCount)
					intWTGCount = 33
					intWTGMax = 49
					REM MSGBOX "This world sells " + objTradeGoodCellA.Value

					DO WHILE NOT (objTrade.getCellByPosition(0, intWTGCount).Type = com.sun.star.table.CellContentType.EMPTY)
						intWTGCount = (intWTGCount + 1)
					LOOP

					objCellA = objTrade.getCellByPosition(0, intWTGCount)
					objCellC = objTrade.getCellByPosition(2, intWTGCount)
					objCellD = objTrade.getCellByPosition(3, intWTGCount)
					objCellJ = objTrade.getCellByPosition(9, intWTGCount)
					objCellA.Value = objTradeGoodCellA.Value
					objCellD.Value = DICEROLL_IMPLEMENTATION(objCellC.String)
					objCellJ.Value = DICEROLL_IMPLEMENTATION("3D6")
				END IF

				intTradeGoodCount = (intTradeGoodCount + 1)
			LOOP
		END IF

		intCount = (intCount + 1)
	LOOP
END SUB

SUB ButtonRoll4B
	RollSale(33, 49)
END SUB

SUB ButtonRoll5A
	IF NOT BasicLibraries.isLibraryLoaded("DiceRoll") THEN
		BasicLibraries.LoadLibrary("DiceRoll")
	END IF

	DIM intCount				AS INTEGER
	DIM intFlags				AS INTEGER
	DIM intMaxRow				AS INTEGER
	DIM objService				AS OBJECT
	DIM objSheets				AS OBJECT
	DIM objTrade				AS OBJECT
	DIM strWorldPopCode			AS STRING

	objService = createUnoService("com.sun.star.sheet.FunctionAccess")
	objSheets = ThisComponent.getSheets()
	objTrade = objSheets.getByName("trade")
	intFlags = GETFLAGS()
	intCount = 51

	IF NOT (objTrade.getCellByPosition(2, 1).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		strWorldPopCode = objService.callFunction("MID", Array(objTrade.getCellByPosition(2, 1).String, 5, 1))
	END IF

	intMaxRow = (intCount + (objService.callFunction("DECIMAL", Array(strWorldPopCode, 16))))

	DO WHILE (intCount < 63)
		DIM objCellA			AS OBJECT
		DIM objCellC			AS OBJECT
		DIM objCellD			AS OBJECT
		DIM objCellJ			AS OBJECT

		objCellA = objTrade.getCellByPosition(0, intCount)
		objCellC = objTrade.getCellByPosition(2, intCount)
		objCellD = objTrade.getCellByPosition(3, intCount)
		objCellJ = objTrade.getCellByPosition(9, intCount)

		IF (intCount < intMaxRow) THEN
			objCellA.Value = ((DICEROLL_IMPLEMENTATION("1D5") * 10) + (DICEROLL_IMPLEMENTATION("1D6")))
			objCellD.Value = DICEROLL_IMPLEMENTATION(objCellC.String)
			objCellJ.Value = DICEROLL_IMPLEMENTATION("3D6")
		ELSE
			REM this is not working as desired...
			objCellA.clearContents(intFlags)
			objCellD.clearContents(intFlags)
			objCellJ.clearContents(intFlags)
		END IF

		intCount = (intcount + 1)
	LOOP
END SUB

SUB ButtonRoll5B
	RollSale(51, 63)
END SUB

SUB ButtonRoll6A
	MSGBOX "TradeGoods.Module1.ButtonRoll6A"
END SUB

SUB ButtonRoll6B
	RollSale(65, 71)
END SUB

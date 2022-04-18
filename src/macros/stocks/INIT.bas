REM  *****  BASIC  *****
REM https://help.libreoffice.org/6.2/en-US/text/sbasic/shared/special_vba_func.html
OPTION EXPLICIT

SUB Main
	IF NOT BasicLibraries.isLibraryLoaded("DiceRoll") THEN
		BasicLibraries.LoadLibrary("DiceRoll")
	END IF

	DIM intCount				AS INTEGER
	DIM lngIssuedShares			AS LONG
	DIM dblTreasuryPercent		AS DOUBLE
	DIM dblRestrictedPercent	AS DOUBLE
	DIM dblPriceMultiplier		AS DOUBLE
	DIM	booFluctuation			AS BOOLEAN
	DIM booTrend				AS BOOLEAN
	DIM	strPriceRoll			AS STRING
	DIM strFluctuation			AS STRING
	DIM strTrend				AS STRING
	DIM objService				AS OBJECT
	DIM objSheets				AS OBJECT
	DIM objParameters			AS OBJECT
	DIM objStocks				AS OBJECT
	DIM objHistory				AS OBJECT

	SET objService = createUnoService("com.sun.star.sheet.FunctionAccess")
	objSheets = ThisComponent.getSheets()
	objParameters = objSheets.getByName("parameters")
	objStocks = objSheets.getByName("stocks")
	objHistory = objSheets.getByName("history")
	intCount = 1

	strPriceRoll = TRIM(objParameters.getCellByPosition(1, 26).String)
	dblPriceMultiplier = objParameters.getCellByPosition(1, 27).Value
	lngIssuedShares = objParameters.getCellByPosition(1, 30).Value
	dblTreasuryPercent = objParameters.getCellByPosition(1, 31).Value
	dblRestrictedPercent = objParameters.getCellByPosition(1, 32).Value

	IF NOT (objParameters.getCellByPosition(1, 28).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		booFluctuation = TRUE
		strFluctuation = TRIM(objParameters.getCellByPosition(1, 28).String)
	ELSE
		booFluctuation = FALSE
	END IF

	IF NOT (objParameters.getCellByPosition(1, 29).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		booTrend = TRUE
		strTrend = TRIM(objParameters.getCellByPosition(1, 29).String)
	ELSE
		booTrend = FALSE
	END IF

	REM MSGBOX strPriceRoll
	REM MSGBOX dblPriceMultiplier
	REM MSGBOX lngIssuedShares
	REM MSGBOX dblTreasuryPercent
	REM MSGBOX dblRestrictedPercent

	DO WHILE NOT (objStocks.getCellByPosition(0, intCount).Type = com.sun.star.table.CellContentType.EMPTY)
		DIM objCellC			AS OBJECT
		DIM objCellD			AS OBJECT
		DIM objCellE			AS OBJECT
		DIM objCellF			AS OBJECT
		DIM objCellG			AS OBJECT
		DIM objCellH			AS OBJECT
		DIM objCellI			AS OBJECT

		objCellC = objStocks.getCellByPosition(2, intCount)
		objCellD = objStocks.getCellByPosition(3, intCount)
		objCellE = objStocks.getCellByPosition(4, intCount)
		objCellF = objStocks.getCellByPosition(5, intCount)
		objCellG = objStocks.getCellByPosition(6, intCount)
		objCellH = objStocks.getCellByPosition(7, intCount)
		objCellI = objStocks.getCellByPosition(8, intCount)

		REM if C is empty, set to "Yes"
		IF (objStocks.getCellByPosition(2, intCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
			IF (intCount > 1) THEN
				DIM objCellCRange	AS NEW com.sun.star.table.CellRangeAddress

				objCellCRange.Sheet = objCellC.CellAddress.Sheet
				objCellCRange.StartColumn = objCellC.CellAddress.Column
				objCellCRange.StartRow = (intCount - 1)
				objCellCRange.EndColumn = objCellC.CellAddress.Column
				objCellCRange.EndRow = (intCount - 1)

				objStocks.copyRange(objCellC.CellAddress, objCellCRange)
			END IF

			objCellC.String = "Yes"
		END IF

		REM			if D is empty, set to $parameters.$B$31 (Starting Shares)
		IF (objStocks.getCellByPosition(3, intCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
			objCellD.Value = lngIssuedShares
		END IF

		REM			if E is empty, set to D * $parameters.$B$32 (Treasury Shares)
		IF (objStocks.getCellByPosition(4, intCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
			objCellE.Value = CLNG((objCellD.Value * dblTreasuryPercent))
		END IF

		REM	if F is empty, set to D * $parameters.$B$33 (Restricted Shares)
		IF (objStocks.getCellByPosition(5, intCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
			objCellF.Value = CLNG((objCellD.Value * dblRestrictedPercent))
		END IF

		REM	if G is empty, set to result of convoluted formula in $parameters.$D$29 (needs modification) (Fluctuation Rate)
		IF (objStocks.getCellByPosition(6, intCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
			IF (intCount > 1) THEN
				DIM objCellGRange	AS NEW com.sun.star.table.CellRangeAddress

				objCellGRange.Sheet = objCellG.CellAddress.Sheet
				objCellGRange.StartColumn = objCellG.CellAddress.Column
				objCellGRange.StartRow = (intCount - 1)
				objCellGRange.EndColumn = objCellG.CellAddress.Column
				objCellGRange.EndRow = (intCount - 1)

				objStocks.copyRange(objCellG.CellAddress, objCellGRange)
			END IF

			IF (booFluctuation) THEN
				objCellG.String = strFluctuation
			ELSE
				objCellG.String = objParameters.getCellByPosition(0, (20 + objService.callFunction("RANDBETWEEN", Array(1, 3)))).String
			END IF
		END IF

		REM	if H is empty, set to result of convoluted formula in $parameters.$D$30 (Trend)
		IF (objStocks.getCellByPosition(7, intCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
			IF (intCount > 1) THEN
				DIM objCellHRange	AS NEW com.sun.star.table.CellRangeAddress

				objCellHRange.Sheet = objCellH.CellAddress.Sheet
				objCellHRange.StartColumn = objCellH.CellAddress.Column
				objCellHRange.StartRow = (intCount - 1)
				objCellHRange.EndColumn = objCellH.CellAddress.Column
				objCellHRange.EndRow = (intCount - 1)

				objStocks.copyRange(objCellH.CellAddress, objCellHRange)
			END IF

			IF (booTrend) THEN
				objCellH.String = strTrend
			ELSE
				objCellH.String = objParameters.getCellByPosition(0, (9 + objService.callFunction("RANDBETWEEN", Array(1, 9)))).String
			END IF
		END IF

		REM	if I is empty, calculate price and set (Current Price)
		IF (objStocks.getCellByPosition(8, intCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
			objCellI.Value = (DICEROLL_IMPLEMENTATION(strPriceRoll) * dblPriceMultiplier)
		END IF

		intCount = (intCount + 1)
	LOOP

	REM initialize the history sheet
	REM set year
	REM set month
	REM MSGBOX "Stocks.INIT complete"
END SUB

REM  *****  BASIC  *****
OPTION EXPLICIT

SUB Main
	IF NOT BasicLibraries.isLibraryLoaded("DiceRoll") THEN
		BasicLibraries.LoadLibrary("DiceRoll")
	END IF

	DIM intRowCount				AS INTEGER
	DIM intPeriod				AS INTEGER
	DIM intColumnCount			AS INTEGER
	DIM objService				AS OBJECT
	DIM objSheets				AS OBJECT
	DIM objParameters			AS OBJECT
	DIM objStocks				AS OBJECT
	DIM objHistory				AS OBJECT
	DIM objMarket				AS OBJECT
	DIM objHistorySmblCellRange	AS OBJECT
	DIM objMarketSmblCellRange	AS OBJECT

	SET objService = createUnoService("com.sun.star.sheet.FunctionAccess")
	objSheets = ThisComponent.getSheets()
	objParameters = objSheets.getByName("parameters")
	objStocks = objSheets.getByName("stocks")
	objHistory = objSheets.getByName("history")
	objMarket = objSheets.getByName("market")
	objHistorySmblCellRange = objHistory.getCellRangeByName("$A:$A")
	objMarketSmblCellRange = objMarket.getCellRangeByName("$A:$A")
	intRowCount = 1
	intColumnCount = 2

	REM get current largest period
	intPeriod = objService.callFunction("MAX", Array(objHistory.getCellRangeByName("$3:$3")))
	intPeriod = (intPeriod + 1)
	REM MSGBOX ("intPeriod: " + intPeriod)

	DO WHILE NOT (objHistory.getCellByPosition(intColumnCount, 2).Type = com.sun.star.table.CellContentType.EMPTY)
		intColumnCount = (intColumnCount + 1)
	LOOP

	REM MSGBOX ("intColumnCount: " + intColumnCount)

	REM add next period
	objHistory.getCellByPosition(intColumnCount, 2).Value = intPeriod

	REM figure out month
	REM add month if needed
	REM figure out year
	REM add year if needed

	REM update stock prices
	DO WHILE NOT (objStocks.getCellByPosition(0, intRowCount).Type = com.sun.star.table.CellContentType.EMPTY)
		DIM intHistoryRowNum 		AS INTEGER
		DIM intMarketRowNum			AS INTEGER
		REM identify matching row in history sheet
		intHistoryRowNum = objService.callFunction("MATCH", Array(objStocks.getCellByPosition(1, intRowCount).String, objHistorySmblCellRange, 0))
		intHistoryRowNum = (intHistoryRowNum - 1)
		REM identify matching row in market sheet
		intMarketRowNum = objService.callFunction("MATCH", Array(objStocks.getCellByPosition(1, intRowCount).String, objMarketSmblCellRange, 0))
		intMarketRowNum = (intMarketRowNum - 1)
		REM copy to appropriate row / cell in history sheet
		IF (objStocks.getCellByPosition(2, intRowCount).String = "Yes") THEN
			IF (intHistoryRowNum <= 0) THEN
				REM if the entry is missing, create it
				DIM intNextHistoryRow	AS INTEGER
				intNextHistoryRow = 2

				DO WHILE NOT (objHistory.getCellByPosition(0, intNextHistoryRow).Type = com.sun.star.table.CellContentType.EMPTY)
					intNextHistoryRow = (intNextHistoryRow + 1)
				LOOP

				objHistory.getCellByPosition(0, intNextHistoryRow).String = objStocks.getCellByPosition(1, intRowCount).String
				intHistoryRowNum = intNextHistoryRow
			END IF

			IF (intMarketRowNum <= 0) THEN
				DIM intNextMarketRow	AS INTEGER
				DIM objCellB			AS OBJECT
				DIM objCellC			AS OBJECT
				DIM objCellD			AS OBJECT
				DIM objCellBRange		AS NEW com.sun.star.table.CellRangeAddress
				DIM objCellCRange		AS NEW com.sun.star.table.CellRangeAddress
				DIM objCellDRange		AS NEW com.sun.star.table.CellRangeAddress
				intNextMarketRow = 2

				DO WHILE NOT (objMarket.getCellByPosition(0, intNextMarketRow).Type = com.sun.star.table.CellContentType.EMPTY)
					intNextMarketRow = (intNextMarketRow + 1)
				LOOP

				intMarketRowNum = intNextMarketRow
				objMarket.getCellByPosition(0, intNextMarketRow).String = objStocks.getCellByPosition(1, intRowCount).String
				objCellB = objMarket.getCellByPosition(1, intNextMarketRow)
				objCellC = objMarket.getCellByPosition(2, intNextMarketRow)
				objCellD = objMarket.getCellByPosition(3, intNextMarketRow)

				objCellBRange.Sheet = objCellB.CellAddress.Sheet
				objCellBRange.StartColumn = objCellB.CellAddress.Column
				objCellBRange.StartRow = 1
				objCellBRange.EndColumn = objCellB.CellAddress.Column
				objCellBRange.EndRow = 1

				objCellCRange.Sheet = objCellC.CellAddress.Sheet
				objCellCRange.StartColumn = objCellC.CellAddress.Column
				objCellCRange.StartRow = 1
				objCellCRange.EndColumn = objCellC.CellAddress.Column
				objCellCRange.EndRow = 1

				objCellDRange.Sheet = objCellD.CellAddress.Sheet
				objCellDRange.StartColumn = objCellD.CellAddress.Column
				objCellDRange.StartRow = 1
				objCellDRange.EndColumn = objCellD.CellAddress.Column
				objCellDRange.EndRow = 1

				objMarket.copyRange(objCellB.CellAddress, objCellBRange)
				objMarket.copyRange(objCellC.CellAddress, objCellCRange)
				objMarket.copyRange(objCellD.CellAddress, objCellDRange)
			END IF

			objHistory.getCellByPosition(intColumnCount, intHistoryRowNum).Value = objStocks.getCellByPosition(8, intRowCount).Value
		END IF

		IF (objStocks.getCellByPosition(2, intRowCount).String = "No") THEN
			REM remove line from market sheet if present
			IF (intMarketRowNum > 0) THEN
				objMarket.rows.removeByIndex(intMarketRowNum, 1)
			END IF
		END IF

		intRowCount = (intRowCount + 1)
	LOOP

	REM MSGBOX "Stocks.PUB completed"
END SUB

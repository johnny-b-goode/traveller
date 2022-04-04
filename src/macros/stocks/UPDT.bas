REM  *****  BASIC  *****
OPTION EXPLICIT

FUNCTION GetTrendSign (strTrend)
	DIM intReturn				AS INTEGER

	SELECT CASE strTrend
		CASE "Crashing":
			intReturn = -1
		CASE "Steeply Declining":
			intReturn = -1
		CASE "Rapidly Declining":
			intReturn = -1
		CASE "Declining":
			intReturn = -1
		CASE "Stable Growth":
			intReturn = 1
		CASE "Growing":
			intReturn = 1
		CASE "Rapidly Growing":
			intReturn = 1
		CASE "Steeply Growing":
			intReturn = 1
		CASE "Exploding":
			intReturn = 1
	END SELECT

	GetTrendSign = intReturn
END FUNCTION

SUB Main
	IF NOT BasicLibraries.isLibraryLoaded("DiceRoll") THEN
		BasicLibraries.LoadLibrary("DiceRoll")
	END IF

	DIM intCount				AS INTEGER
	DIM intMinPrice				AS INTEGER
	DIM intMaxPrice				AS INTEGER
	DIM objService				AS OBJECT
	DIM objSheets				AS OBJECT
	DIM objParameters			AS OBJECT
	DIM objStocks				AS OBJECT
	DIM objTrendSelCellRange	AS OBJECT
	DIM objTrendCellRange		AS OBJECT
	DIM objTrendCellRange2		AS OBJECT
	DIM objFluctuationCellRange	AS OBJECT

	SET objService = createUnoService("com.sun.star.sheet.FunctionAccess")
	objSheets = ThisComponent.getSheets()
	objParameters = objSheets.getByName("parameters")
	objStocks = objSheets.getByName("stocks")

	objTrendSelCellRange = objParameters.getCellRangeByName("$A$4:$C$8")
	objTrendCellRange = objParameters.getCellRangeByName("$A$11:$C$19")
	objTrendCellRange2 = objParameters.getCellRangeByName("$A$11:$A$19")
	objFluctuationCellRange = objParameters.getCellRangeByName("$A$22:$B$24")

	intCount = 1

	IF NOT (objStocks.getCellByPosition(35, 1).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		intMinPrice = CINT(objParameters.getCellByPosition(35, 1).String)
	ELSE
		intMinPrice = 1
	END IF

	IF NOT (objStocks.getCellByPosition(36, 1).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		intMaxPrice = CINT(objParameters.getCellByPosition(36, 1).String)
	ELSE
		intMaxPrice = 0
	END IF

	DO WHILE NOT (objStocks.getCellByPosition(0, intCount).Type = com.sun.star.table.CellContentType.EMPTY)
		DIM intCurrentPrice 		AS INTEGER
		DIM intNewPrice				AS INTEGER
		DIM intTrendBaseModifier	AS INTEGER
		DIM intTrendSelModifier		AS INTEGER
		DIM intTrendSel				AS INTEGER
		DIM intTrendEffect			AS INTEGER
		DIM intTrendIndex			AS INTEGER
		DIM strFluctuationRoll		AS STRING
		DIM strTrendRoll			AS STRING

		REM	update cell in column I, calculate and set (Current Price)
		IF NOT (objStocks.getCellByPosition(8, intCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
			intCurrentPrice = objStocks.getCellByPosition(8, intCount).Value
			strFluctuationRoll = TRIM(objService.callFunction("VLOOKUP", Array(objStocks.getCellByPosition(6, intCount).String, objFluctuationCellRange, 2, 0)))
			strTrendRoll = TRIM(objService.callFunction("VLOOKUP", Array(objStocks.getCellByPosition(7, intCount).String, objTrendCellRange, 2, 0)))

			IF (INSTR(strTrendRoll, "d") > 0) THEN
				intTrendBaseModifier = DiceRoll.DICEROLL_IMPLEMENTATION(strTrendRoll)
			ELSE
				intTrendBaseModifier = CINT(strTrendRoll)
			END IF

			REM determine if trend is positive or negative
			intTrendBaseModifier = (intTrendBaseModifier * GetTrendSign(objStocks.getCellByPosition(7, intCount).String))
			intNewPrice = (intCurrentPrice + (DiceRoll.DICEROLL_IMPLEMENTATION(strFluctuationRoll) * intTrendBaseModifier))

			IF (intNewPrice < intMinPrice) THEN
				intNewPrice = intMinPrice
			END IF

			IF (intNewPrice > intMaxPrice) THEN
				IF (intMaxPrice > 0) THEN
					intNewPrice = intMaxPrice
				END IF
			END IF

			objStocks.getCellByPosition(8, intCount).Value = intNewPrice
		END IF

		REM update cell in column H, determine and set (Trend)
		intTrendSelModifier = CINT(TRIM(objService.callFunction("VLOOKUP", Array(objStocks.getCellByPosition(7, intCount).String, objTrendCellRange, 3, 0))))
		intTrendSel = DiceRoll.DICEROLL_IMPLEMENTATION("2D6")
		intTrendIndex = objService.callFunction("MATCH", Array(objStocks.getCellByPosition(7, intCount).String, objTrendCellRange2, 0))
		REM add offset. match returns a result starting w/ 1 (no zero index). there is probably a better way to do this using objTrendCellRange2
		intTrendIndex = (9 + intTrendIndex)
		REM MSGBOX ("intTrendSelModifier: " + intTrendSelModifier + ", intTrendSel: " + intTrendSel + " (roll total: " + (intTrendSel + intTrendSelModifier) + "), intTrendIndex: " + intTrendIndex)
		intTrendSel = (intTrendSel + intTrendSelModifier)

		DIM intCount2			AS INTEGER
		DIM intNewTrend			AS INTEGER

		REM determine the trend selection effect
		REM this code is weird, the only way that it makes sense to me is to think about it in terms of WHEN intNewTrend is set (in relation to intCount2)
		FOR intCount2 = 3 TO 7
			REM MSGBOX (objParameters.getCellByPosition(1, intCount2).String)
			IF (intCount2 = 3) THEN
				IF (intTrendSel <= CINT(objParameters.getCellByPosition(1, intCount2).String)) THEN
					intTrendEffect = CINT(objParameters.getCellByPosition(2, intCount2).String)
					intCount2 = 8
				END IF
			ELSEIF (intTrendSel <= CINT(objParameters.getCellByPosition(1, intCount2).String)) THEN
				IF (intTrendSel >= CINT(objParameters.getCellByPosition(0, intCount2).String)) THEN
					intTrendEffect = CINT(objParameters.getCellByPosition(2, intCount2).String)
					intCount2 = 8
				END IF
			ELSEIF (intCount2 = 7) THEN
				IF (intTrendSel >= CINT(objParameters.getCellByPosition(0, intCount2).String)) THEN
					intTrendEffect = CINT(objParameters.getCellByPosition(2, intCount2).String)
					intCount2 = 8
				END IF
			END IF
		NEXT

		REM this shouldn't really be necessary
		intNewTrend = (intTrendIndex + intTrendEffect)

		IF (intNewTrend < 10) THEN
			intNewTrend = 10
		ELSEIF (intNewTrend > 18) THEN
			intNewTrend = 18
		END IF

		objStocks.getCellByPosition(7, intCount).String = TRIM(objParameters.getCellByPosition(0, intNewTrend).String)
		intCount = (intCount + 1)
	LOOP

END SUB

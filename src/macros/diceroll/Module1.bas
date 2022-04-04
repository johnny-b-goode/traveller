REM  *****  BASIC  *****
Option Explicit

FUNCTION DICEROLL_IMPLEMENTATION(strRoll, OPTIONAL strBOrB)
	DIM booBoon			AS BOOLEAN
	DIM booBane			AS BOOLEAN
	DIM intAccumulator	AS INTEGER
	DIM intDice			AS INTEGER
	DIM intSides		AS INTEGER
	DIM intModifier		AS INTEGER
	DIM intCounter		AS INTEGER
	DIM intOutlier		AS INTEGER
	DIM objService		AS OBJECT

	booBoon = FALSE
	booBane = FALSE
	intDice = CINT(LEFT(strRoll, (INSTR(strRoll, "d") - 1)))

	IF (INSTR(strRoll, "-") > 0) THEN
		intSides = CINT(MID(strRoll, (INSTR(strRoll, "d") + 1), ((INSTR(strRoll, "-") - 1) - INSTR(strRoll, "d"))))
		intModifier = CINT(MID(strRoll, (INSTR(strRoll, "-")), (LEN(strRoll) - (INSTR(strRoll, "-") - 1))))
	ELSEIF (INSTR(strRoll, "+") > 0) THEN
		intSides = CINT(MID(strRoll, (INSTR(strRoll, "d") + 1), (LEN(strRoll) - INSTR(strRoll, "+"))))
		intModifier = CINT(MID(strRoll, (INSTR(strRoll, "+") + 1), (LEN(strRoll) - INSTR(strRoll, "+"))))
	ELSE
		intSides = CINT(MID(strRoll, (INSTR(strRoll, "d") + 1), (LEN(strRoll))))
	END IF

	REM MSGBOX intDice
	REM MSGBOX intSides
	REM MSGBOX intModifier

	IF NOT ISMISSING(strBOrB) THEN
		IF (LCase(TRIM(strBOrB)) = "boon") THEN
			REM MSGBOX "A Boon has been given"
			booBoon = TRUE
			intDice = (intDice + 1)
			intOutlier = intSides
		ELSEIF (LCase(TRIM(strBOrB)) = "bane") THEN
			REM MSGBOX "A Bane has been imposed"
			booBane = TRUE
			intDice = (intDice + 1)
			intOutlier = 1
		ELSE
			EXIT FUNCTION
		END IF
	END IF

	SET objService = createUnoService("com.sun.star.sheet.FunctionAccess")
	intAccumulator = 0

	FOR intCounter = 1 TO intDice
		DIM intTemp AS INTEGER
		intTemp = objService.callFunction("RANDBETWEEN", Array(1, intSides))

		IF booBoon = TRUE THEN
			IF intTemp < intOutlier THEN
				intOutlier = intTemp
			END IF
		END IF

		IF booBane = TRUE THEN
			IF intTemp > intOutlier THEN
				intOutlier = intTemp
			END IF
		END IF

		intAccumulator = (intAccumulator + intTemp)
	NEXT

	IF (intOutlier <> 0) THEN
		REM MSGBOX ("intOutlier: " + intOutlier)
		intAccumulator = (intAccumulator - intOutlier)
	END IF

	IF (intModifier <> 0) THEN
		intAccumulator = (intAccumulator + intModifier)
	END IF

	DICEROLL_IMPLEMENTATION = intAccumulator
END FUNCTION


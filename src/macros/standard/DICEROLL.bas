REM  *****  BASIC  *****
FUNCTION DICEROLL(strRoll, OPTIONAL strBOrB)
	IF NOT BasicLibraries.isLibraryLoaded("DiceRoll") THEN
		BasicLibraries.LoadLibrary("DiceRoll")
	END IF

	IF NOT ISMISSING(strBOrB) THEN
		DICEROLL = DICEROLL_IMPLEMENTATION(strRoll, strBOrB)
	ELSE
		DICEROLL = DICEROLL_IMPLEMENTATION(strRoll)
	END IF
END FUNCTION

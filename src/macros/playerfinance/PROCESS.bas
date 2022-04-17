REM  *****  BASIC  *****
REM https://help.libreoffice.org/6.4/en-US/text/scalc/05/02140000.html
OPTION EXPLICIT

DIM booIncludeNPCCrew		AS BOOLEAN
DIM booEvenCrewProfit		AS BOOLEAN
DIM booEvenShipStake		AS BOOLEAN
DIM intFinancesRowCount		AS INTEGER
DIM intLedgerRowCount		AS INTEGER
DIM dblShipValue			AS DOUBLE
REM DIM dblStartShipMortgage	AS DOUBLE
DIM dblCurrentShipMortgage	AS DOUBLE
DIM dblShipMortgagePayment	AS DOUBLE
DIM dblCredPerShare			AS DOUBLE
DIM dblCrewProfitPercent	AS DOUBLE
DIM dblTotalOwnershipAmount	AS DOUBLE
DIM dblTotalOwnershipPrcnt	AS DOUBLE
DIM dblTotalPooledCash		AS DOUBLE
DIM dblOwnershipWeight		AS DOUBLE
DIM dblPooledCashWeight		AS DOUBLE
DIM dblOwnershipRatio		AS DOUBLE
DIM dblPooledCashRatio		AS DOUBLE
DIM dblOwnershipFactor		AS DOUBLE
DIM dblOwnershipMultiplier	AS DOUBLE
DIM dblPooledCashFactor		AS DOUBLE
DIM dblMaximumVariance		AS DOUBLE
DIM objSheets				AS OBJECT
DIM objParameters			AS OBJECT
DIM objFinances				AS OBJECT
DIM objLedger				AS OBJECT
DIM objQuickDebitBox		AS OBJECT
DIM objService				AS OBJECT
DIM objShipShareRange		AS OBJECT
DIM objShipOwnershipRange	AS OBJECT
DIM objPooledCashRange		AS OBJECT

FUNCTION INIT
	SET objService = createUnoService("com.sun.star.sheet.FunctionAccess")
	objSheets = ThisComponent.getSheets()
	objParameters = objSheets.getByName("parameters")
	objFinances = objSheets.getByName("finances")
	objLedger = objSheets.getByName("ledger")
	objQuickDebitBox = objFinances.DrawPage.Forms.getByIndex(0).getByName("finances.quick_debit")
	objShipShareRange = objFinances.getCellRangeByName("$D$2:$D$21")
	objShipOwnershipRange = objFinances.getCellRangeByName("$E$2:$E$21")
	objPooledCashRange = objFinances.getCellRangeByName("$G$2:$G$21")

	IF NOT (objParameters.getCellByPosition(1, 1).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		dblShipValue = objParameters.getCellByPosition(1, 1).Value
	END IF

	REM IF NOT (objParameters.getCellByPosition(1, 2).Type = com.sun.star.table.CellContentType.EMPTY) THEN
	REM 	dblStartShipMortgage = objParameters.getCellByPosition(1, 2).Value
	REM END IF

	IF NOT (objParameters.getCellByPosition(1, 3).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		dblCurrentShipMortgage = objParameters.getCellByPosition(1, 3).Value
	END IF

	IF NOT (objParameters.getCellByPosition(1, 4).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		dblShipMortgagePayment = objParameters.getCellByPosition(1, 4).Value
	END IF

	IF NOT (objParameters.getCellByPosition(1, 5).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		dblCredPerShare = objParameters.getCellByPosition(1, 5).Value
	END IF

	IF NOT (objParameters.getCellByPosition(1, 6).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		dblCrewProfitPercent = objParameters.getCellByPosition(1, 6).Value
	END IF

	IF NOT (objParameters.getCellByPosition(1, 7).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		IF (objParameters.getCellByPosition(1, 7).String = "Yes") THEN
			booEvenCrewProfit = TRUE
		END IF
	END IF

	IF NOT (objParameters.getCellByPosition(1, 8).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		IF (objParameters.getCellByPosition(1, 8).String = "Yes") THEN
			booIncludeNPCCrew = TRUE
		END IF
	END IF

	IF NOT (objParameters.getCellByPosition(1, 9).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		IF (objParameters.getCellByPosition(1, 9).String = "Yes") THEN
			booEvenShipStake = TRUE
		END IF
	END IF

	dblTotalOwnershipAmount = (dblCredPerShare * objService.callFunction("SUM", Array(objShipShareRange)))
	dblTotalOwnershipAmount = (dblTotalOwnershipAmount + objService.callFunction("SUM", Array(objShipOwnershipRange)))
	dblTotalOwnershipPrcnt = (dblTotalOwnershipAmount / dblShipValue)

	IF (dblTotalOwnershipPrcnt > 0) THEN
		dblOwnershipMultiplier = (1 / dblTotalOwnershipPrcnt)
	END IF

	dblTotalPooledCash = objService.callFunction("SUM", Array(objPooledCashRange))
	dblOwnershipWeight = (dblTotalOwnershipAmount / (dblTotalOwnershipAmount + dblTotalPooledCash))
	dblPooledCashWeight = (dblTotalPooledCash / (dblTotalOwnershipAmount + dblTotalPooledCash))
	REM pooled cash is always 100%
	dblOwnershipRatio = (dblTotalOwnershipPrcnt / (dblTotalOwnershipPrcnt + 1))
	dblPooledCashRatio = (1 / (dblTotalOwnershipPrcnt + 1))

	IF ((dblTotalOwnershipAmount > 0) AND (dblTotalPooledCash > 0)) THEN
		dblOwnershipFactor = ((dblOwnershipWeight + dblOwnershipRatio) / 2)
		dblPooledCashFactor = ((dblPooledCashWeight + dblPooledCashRatio) / 2)
	ELSEIF (dblTotalOwnershipAmount > 0) THEN
		dblOwnershipFactor = 1
		dblPooledCashFactor = 0
	ELSEIF (dblTotalPooledCash > 0) THEN
		dblOwnershipFactor = 0
		dblPooledCashFactor = 1 
	END IF

	REM require transactional accuracy to within a millionth of a credit
	dblMaximumVariance = 0.000001

	REM MSGBOX ("dblShipValue: " + dblShipValue & chr(13) + "dblCredPerShare: " +  dblCredPerShare & chr(13) + "dblCrewProfitPercent: " +  dblCrewProfitPercent & chr(13) + "booIncludeNPCCrew: " +  booIncludeNPCCrew & chr(13) + "booEvenCrewProfit: " +  booEvenCrewProfit & chr(13) + "booEvenShipStake: " +  booEvenShipStake)
	REM MSGBOX ("dblTotalOwnershipAmount: " + dblTotalOwnershipAmount & chr(13) + "dblTotalOwnershipPrcnt: " + dblTotalOwnershipPrcnt & chr(13) + "dblOwnershipMultiplier: " + dblOwnershipMultiplier)
	REM MSGBOX ("dblTotalPooledCash: " + dblTotalPooledCash & chr(13)  + "dblOwnershipWeight: " + dblOwnershipWeight & chr(13)  + "dblPooledCashWeight: " + dblPooledCashWeight & chr(13)  + "dblOwnershipRatio: " + dblOwnershipRatio & chr(13)  + "dblPooledCashRatio: " + dblPooledCashRatio & chr(13)  + "dblOwnershipFactor: " + dblOwnershipFactor & chr(13)  + "dblPooledCashFactor: " + dblPooledCashFactor)
END FUNCTION

FUNCTION JOURNAL (strType)
	DO WHILE NOT (objLedger.getCellByPosition(0, intLedgerRowCount).Type = com.sun.star.table.CellContentType.EMPTY)
		intLedgerRowCount = (intLedgerRowCount + 1)
	LOOP

	objLedger.copyRange(objLedger.getCellByPosition(0, intLedgerRowCount).CellAddress, objLedger.getCellByPosition(0, (intLedgerRowCount - 1)).RangeAddress)
	objLedger.copyRange(objLedger.getCellByPosition(2, intLedgerRowCount).CellAddress, objLedger.getCellByPosition(2, (intLedgerRowCount - 1)).RangeAddress)
	objLedger.getCellByPosition(0, intLedgerRowCount).Value = objService.callFunction("TODAY", Array())
	objLedger.getCellByPosition(1, intLedgerRowCount).String = objFinances.getCellByPosition(10, 4).String

	SELECT CASE UCASE(TRIM(strType))
		CASE "CREDIT":
			objLedger.getCellByPosition(2, intLedgerRowCount).String = "Credit"
		CASE "DEBIT":
			objLedger.getCellByPosition(2, intLedgerRowCount).String = "Debit"
	END SELECT

	objLedger.getCellByPosition(3, intLedgerRowCount).Value = objFinances.getCellByPosition(13, 4).Value
END FUNCTION

SUB CREDIT
	INIT()

	IF NOT (objFinances.getCellByPosition(13, 4).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		DIM intNumberOfCrew		AS INTEGER
		DIM dblCreditToCrew		AS DOUBLE
		DIM dblRemainingCredit	AS DOUBLE
		DIM dblControlTotal		AS DOUBLE

		IF NOT (objFinances.getCellByPosition(13, 4).Type = com.sun.star.table.CellContentType.EMPTY) THEN
			dblRemainingCredit = objFinances.getCellByPosition(13, 4).Value
		END IF

		IF (dblCrewProfitPercent > 0) THEN
			IF (booEvenCrewProfit) THEN
				DO WHILE NOT (objFinances.getCellByPosition(1, intFinancesRowCount).Type = com.sun.star.table.CellContentType.EMPTY)
					IF (UCASE(TRIM(objFinances.getCellByPosition(0, intFinancesRowCount).String)) = "NPC") THEN
						REM MSGBOX "This is an NPC"
						IF (booIncludeNPCCrew) THEN
							intNumberOfCrew = (intNumberOfCrew + 1)
						END IF
					ELSE
						intNumberOfCrew = (intNumberOfCrew + 1)
					END IF

					intFinancesRowCount = (intFinancesRowCount + 1)
				LOOP

				REM account for column titles
				intNumberOfCrew = (intNumberOfCrew - 1)
			END IF

			dblCreditToCrew = (dblRemainingCredit * dblCrewProfitPercent)
			dblRemainingCredit = (dblRemainingCredit - dblCreditToCrew)
		END IF

		REM MSGBOX ("intNumberOfCrew: " + intNumberOfCrew & chr(13) + "dblCreditToCrew: " + dblCreditToCrew & chr(13) + "dblRemainingCredit: " + dblRemainingCredit)
		REM skip the column titles
		intFinancesRowCount = 1

		DO WHILE NOT (objFinances.getCellByPosition(1, intFinancesRowCount).Type = com.sun.star.table.CellContentType.EMPTY)
			DIM dblNewPooledCash	AS DOUBLE
			REM both of the following are percentages
			DIM dblShipStake		AS DOUBLE
			DIM dblPooledCash		AS DOUBLE

			dblNewPooledCash = 0
			dblShipStake = 0
			dblPooledCash = 0

			IF NOT (objFinances.getCellByPosition(5, intFinancesRowCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
				dblShipStake = (objFinances.getCellByPosition(5, intFinancesRowCount).Value)
			END IF

			IF NOT (objFinances.getCellByPosition(6, intFinancesRowCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
				dblNewPooledCash = objFinances.getCellByPosition(6, intFinancesRowCount).Value

				IF (dblTotalPooledCash > 0) THEN
					dblPooledCash = (dblNewPooledCash / dblTotalPooledCash)
				END IF
			END IF

			REM MSGBOX ("intFinancesRowCount" + intFinancesRowCount & chr(13) + "dblNewPooledCash: " + dblNewPooledCash & chr(13) + "dblShipStake: " + dblShipStake & chr(13) + "dblPooledCash: " + dblPooledCash)

			IF (dblCrewProfitPercent > 0) THEN
				IF (booEvenCrewProfit) THEN
					dblNewPooledCash = (dblNewPooledCash + (dblCreditToCrew / intNumberOfCrew))
					REM MSGBOX ("dblNewPooledCash: " + dblNewPooledCash)
				ELSE
					IF NOT (objFinances.getCellByPosition(2, intFinancesRowCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
						dblNewPooledCash = (dblNewPooledCash + (dblCreditToCrew * objFinances.getCellByPosition(2, intFinancesRowCount).Value))
						REM MSGBOX ("dblNewPooledCash: " + dblNewPooledCash)
					END IF
				END IF
			END IF

			REM MSGBOX ("dblRemainingCredit: " + dblRemainingCredit & chr(13) + "dblShipStake: " + dblShipStake & chr(13) + "dblOwnershipFactor: " + dblOwnershipFactor & chr(13) + "dblOwnershipMultiplier: " + dblOwnershipMultiplier)
			dblNewPooledCash = (dblNewPooledCash + (dblRemainingCredit * (dblShipStake * dblOwnershipFactor * dblOwnershipMultiplier)))
			REM MSGBOX ("dblNewPooledCash: " + dblNewPooledCash)
			dblNewPooledCash = (dblNewPooledCash + (dblRemainingCredit * (dblPooledCash * dblPooledCashFactor)))
			REM MSGBOX ("dblNewPooledCash: " + dblNewPooledCash)

			IF (dblNewPooledCash > 0) THEN
				dblControlTotal = (dblControlTotal + (dblNewPooledCash - objFinances.getCellByPosition(6, intFinancesRowCount).Value))
				objFinances.getCellByPosition(6, intFinancesRowCount).Value = dblNewPooledCash
			END IF

			intFinancesRowCount = (intFinancesRowCount + 1)
		LOOP

		IF (dblControlTotal > (objFinances.getCellByPosition(13, 4).Value + dblMaximumVariance)) OR (dblControlTotal < (objFinances.getCellByPosition(13, 4).Value - dblMaximumVariance)) THEN
		REM IF NOT (dblControlTotal = objFinances.getCellByPosition(13, 4).Value) THEN
			MSGBOX ("An error has occured. The credit amount was " + objFinances.getCellByPosition(13, 4).Value + ", but the total amount transacted was " + dblControlTotal)
		END IF

		JOURNAL("Credit")
		REM because referring to the same thing in a consistent way is overrated...
		objFinances.getCellRangeByName("$K$5").clearContents(com.sun.star.sheet.CellFlags.STRING)
		objFinances.getCellRangeByName("$N$5").clearContents(com.sun.star.sheet.CellFlags.VALUE)
	END IF
END SUB

SUB DEBIT
	REM MSGBOX "PlayerFinance.PROCESS.DEBIT"
	INIT()

	IF NOT (objFinances.getCellByPosition(13, 4).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		DIM intNumberOfCrew			AS INTEGER
		DIM dblControlTotal			AS DOUBLE
		DIM dblDebitAmount			AS DOUBLE

		IF NOT (objFinances.getCellByPosition(13, 4).Type = com.sun.star.table.CellContentType.EMPTY) THEN
			dblDebitAmount = objFinances.getCellByPosition(13, 4).Value
		END IF

		IF (dblTotalPooledCash < dblDebitAmount) THEN
			MSGBOX "Insufficient Funds"
			EXIT SUB
			REM STOP
			REM END
		END IF

		intFinancesRowCount = 1

		IF (booEvenShipStake) THEN
			DO WHILE NOT (objFinances.getCellByPosition(1, intFinancesRowCount).Type = com.sun.star.table.CellContentType.EMPTY)
				IF NOT (UCASE(TRIM(objFinances.getCellByPosition(0, intFinancesRowCount).String)) = "NPC") THEN
					intNumberOfCrew = (intNumberOfCrew + 1)
				END IF

				intFinancesRowCount = (intFinancesRowCount + 1)
			LOOP

			intFinancesRowCount = 1
		END IF

		DO WHILE NOT (objFinances.getCellByPosition(1, intFinancesRowCount).Type = com.sun.star.table.CellContentType.EMPTY)
			DIM dblPooledCash			AS DOUBLE
			REM despite what the documentation states, dblPooledCash is not reinitialized at zero for every iteration of the loop
			dblPooledCash = 0

			IF NOT (objFinances.getCellByPosition(6, intFinancesRowCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
				dblPooledCash = objFinances.getCellByPosition(6, intFinancesRowCount).Value
			REM ELSE
			REM	MSGBOX ("Row " + intFinancesRowCount + " Pooled Cash is empty" & chr(13) + "dblPooledCash: " + dblPooledCash)
			END IF

			IF (dblPooledCash > 0) THEN
				DIM dblNewPooledCash		AS DOUBLE
				DIM dblPooledCashPercent	AS DOUBLE

				dblPooledCashPercent = (dblPooledCash / dblTotalPooledCash)
				dblNewPooledCash = (dblPooledCash - (dblDebitAmount * dblPooledCashPercent))
				dblControlTotal = (dblControlTotal + (dblPooledCash - dblNewPooledCash))
				objFinances.getCellByPosition(6, intFinancesRowCount).Value = dblNewPooledCash

				SELECT CASE objQuickDebitBox.SelectedValue
					CASE "":
						REM 
					CASE "Pay Ship Mortgage":
						IF NOT (dblDebitAmount = dblShipMortgagePayment) THEN
							MSGBOX ("The amount that has been paid is " + dblDebitAmount + ", however, the mortgage payment is " + dblShipMortgagePayment)
						END IF

						DIM dblAddShipStake	AS DOUBLE
						DIM dblNewShipStake AS DOUBLE

						objParameters.getCellByPosition(1, 3).Value = (dblCurrentShipMortgage - dblDebitAmount)

						IF (booEvenShipStake) THEN
							dblAddShipStake = (dblDebitAmount / intNumberOfCrew)
						ELSE
							dblAddShipStake = (dblDebitAmount * dblPooledCashPercent)
						END IF

						IF NOT (objFinances.getCellByPosition(4, intFinancesRowCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
							dblNewShipStake = objFinances.getCellByPosition(4, intFinancesRowCount).Value
						END IF

						dblNewShipStake = (dblNewShipStake + dblAddShipStake)
						objFinances.getCellByPosition(4, intFinancesRowCount).Value = dblNewShipStake
				END SELECT
			END IF

			intFinancesRowCount = (intFinancesRowCount + 1)
		LOOP

		IF (dblControlTotal > (objFinances.getCellByPosition(13, 4).Value + dblMaximumVariance)) OR (dblControlTotal < (objFinances.getCellByPosition(13, 4).Value - dblMaximumVariance)) THEN
			MSGBOX ("An error has occured. The credit amount was " + objFinances.getCellByPosition(13, 4).Value + ", but the total amount transacted was " + dblControlTotal)
		END IF

		JOURNAL("Debit")
		objFinances.getCellRangeByName("$K$5").clearContents(com.sun.star.sheet.CellFlags.STRING)
		objFinances.getCellRangeByName("$N$5").clearContents(com.sun.star.sheet.CellFlags.VALUE)
		objQuickDebitBox.SelectedValue = ""
	END IF
END SUB

SUB QUICK
	INIT()

	SELECT CASE objQuickDebitBox.SelectedValue
		CASE "":
			objFinances.getCellRangeByName("$K$5").clearContents(com.sun.star.sheet.CellFlags.STRING)
			objFinances.getCellRangeByName("$N$5").clearContents(com.sun.star.sheet.CellFlags.VALUE)
		CASE "Pay Ship Mortgage":
			objFinances.getCellByPosition(10, 4).String = "Ship Mortgage"
			objFinances.getCellByPosition(13, 4).Value = dblShipMortgagePayment
	END SELECT

	REM MSGBOX "PlayerFinance.PROCESS.QUICK" & chr(13) + TRIM(objQuickDebitBox.SelectedValue)
END SUB

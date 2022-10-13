REM  *****  BASIC  *****
REM https://wiki.openoffice.org/wiki/Documentation/BASIC_Guide/Arrays
REM https://help.libreoffice.org/6.4/en-US/text/scalc/05/02140000.html
OPTION EXPLICIT

REM DIM booIncludeNPCCrew			AS BOOLEAN
DIM booEvenCrewProfit			AS BOOLEAN
DIM booEvenShipStake			AS BOOLEAN
REM DIM booBalancePooledCash		AS BOOLEAN
DIM intFinancesRowStart			AS INTEGER

DIM intLedgerUserStartColumn	AS INTEGER
DIM intCreditDistColumn			AS INTEGER
DIM intDebitDistColumn			AS INTEGER
DIM intTransferPaymentColumn	AS INTEGER
DIM dblShipValue				AS DOUBLE
REM DIM dblStartShipMortgage		AS DOUBLE
DIM dblCurrentShipMortgage		AS DOUBLE
DIM dblShipMortgagePayment		AS DOUBLE
DIM dblShipPaymentToEquity		AS DOUBLE
DIM dblShipMaintenance			AS DOUBLE
DIM dblShipLifeSupport			AS DOUBLE
DIM dblShipFuel					AS DOUBLE
DIM dblCrewSalaries				AS DOUBLE
DIM dblCredPerShare				AS DOUBLE
REM DIM dblCrewProfitPercent		AS DOUBLE
DIM dblCapPooledCash			AS DOUBLE

DIM dblMaximumVariance			AS DOUBLE
DIM objSheets					AS OBJECT
DIM objParameters				AS OBJECT
DIM objFinances					AS OBJECT
DIM objLedger					AS OBJECT

DIM objFinancesNoteCell			AS OBJECT
DIM objFinancesAmountCell		AS OBJECT
DIM objFinancesCreditCostCell	AS OBJECT
DIM objFinancesCreditLineCell	AS OBJECT

DIM objQuickDebitBox			AS OBJECT
DIM objService					AS OBJECT

DIM objShipShareRange			AS OBJECT
DIM objShipOwnershipRange		AS OBJECT
DIM objPooledCashRange			AS OBJECT

DIM strCredit					AS STRING
DIM strDebit					AS STRING

FUNCTION INIT
	SET objService = createUnoService("com.sun.star.sheet.FunctionAccess")
	intCreditDistColumn = 10
	intDebitDistColumn = 9
	intTransferPaymentColumn = 12
	intFinancesRowStart = 14
	intLedgerUserStartColumn = 5
	objSheets = ThisComponent.getSheets()
	objParameters = objSheets.getByName("parameters")
	objFinances = objSheets.getByName("finances")
	objLedger = objSheets.getByName("ledger")
	objFinances
	objFinancesNoteCell = objFinances.getCellByPosition(17, 37)
	objFinancesAmountCell = objFinances.getCellByPosition(17, 40)
	objFinancesCreditCostCell = objFinances.getCellByPosition(19, 46)
	objFinancesCreditLineCell = objFinances.getCellByPosition(19, 48)
	objQuickDebitBox = objFinances.DrawPage.Forms.getByIndex(0).getByName("finances.quick_debit")
	objShipShareRange = objFinances.getCellRangeByName("$D$15:$D$34")
	objShipOwnershipRange = objFinances.getCellRangeByName("$E$15:$E$34")
	objPooledCashRange = objFinances.getCellRangeByName("$G$15:$G$34")
	strCredit = "Credit"
	strDebit = "Debit"

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
		dblShipPaymentToEquity = objParameters.getCellByPosition(1, 4).Value
	END IF

	IF NOT (objParameters.getCellByPosition(1, 5).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		dblShipMortgagePayment = objParameters.getCellByPosition(1, 5).Value
	END IF

	IF NOT (objParameters.getCellByPosition(1, 6).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		dblShipMaintenance = objParameters.getCellByPosition(1, 6).Value
	END IF

	IF NOT (objParameters.getCellByPosition(1, 7).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		dblShipFuel = objParameters.getCellByPosition(1, 7).Value
	END IF

	IF NOT (objParameters.getCellByPosition(1, 8).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		dblCrewSalaries = objParameters.getCellByPosition(1, 8).Value
	END IF

	IF NOT (objParameters.getCellByPosition(1, 9).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		dblShipLifeSupport = objParameters.getCellByPosition(1, 9).Value
	END IF

	IF NOT (objParameters.getCellByPosition(1, 10).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		dblCredPerShare = objParameters.getCellByPosition(1, 10).Value
	END IF

	REM IF NOT (objParameters.getCellByPosition(1, 14).Type = com.sun.star.table.CellContentType.EMPTY) THEN
	REM	dblCrewProfitPercent = objParameters.getCellByPosition(1, 14).Value
	REM END IF

	IF NOT (objParameters.getCellByPosition(1, 15).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		IF (objParameters.getCellByPosition(1, 15).String = "Yes") THEN
			booEvenCrewProfit = TRUE
		END IF
	END IF

	IF NOT (objParameters.getCellByPosition(1, 16).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		IF (objParameters.getCellByPosition(1, 16).String = "Yes") THEN
			booEvenShipStake = TRUE
		END IF
	END IF

	IF NOT (objParameters.getCellByPosition(1, 17).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		dblCapPooledCash = objParameters.getCellByPosition(1, 17).Value
	END IF

	REM require transactional accuracy to within a millionth of a credit
	dblMaximumVariance = 0.000001
END FUNCTION

FUNCTION JOURNAL (strType, aAmounts)
	DIM intCount					AS INTEGER
	DIM intLedgerRowCount			AS INTEGER
	intCount = 0
	intLedgerRowCount = 2

	DO WHILE NOT (objLedger.getCellByPosition(0, intLedgerRowCount).Type = com.sun.star.table.CellContentType.EMPTY)
		intLedgerRowCount = (intLedgerRowCount + 1)
	LOOP

	objLedger.copyRange(objLedger.getCellByPosition(0, intLedgerRowCount).CellAddress, objLedger.getCellByPosition(0, (intLedgerRowCount - 1)).RangeAddress)
	objLedger.copyRange(objLedger.getCellByPosition(2, intLedgerRowCount).CellAddress, objLedger.getCellByPosition(2, (intLedgerRowCount - 1)).RangeAddress)
	objLedger.getCellByPosition(0, intLedgerRowCount).Value = objService.callFunction("TODAY", Array())
	objLedger.getCellByPosition(1, intLedgerRowCount).String = objFinancesNoteCell.String

	SELECT CASE UCASE(TRIM(strType))
		CASE "CREDIT":
			objLedger.getCellByPosition(2, intLedgerRowCount).String = strCredit
		CASE "DEBIT":
			objLedger.getCellByPosition(2, intLedgerRowCount).String = strDebit
	END SELECT

	objLedger.getCellByPosition(3, intLedgerRowCount).Value = objFinancesAmountCell.Value

	REM iterate through characters and journal individual amounts
	DO WHILE (intCount < UBound(aAmounts))
		objLedger.getCellByPosition((intLedgerUserStartColumn + intCount), intLedgerRowCount).Value = aAmounts(intCount)
		intCount = (intCount + 1)
	LOOP
END FUNCTION

SUB CREDIT
	INIT()

	IF NOT (objFinancesAmountCell.Type = com.sun.star.table.CellContentType.EMPTY) THEN
		REM create an array to temporarily store values, as this is going to be sufficiently complicated to require it
		DIM aCreditValues(1)		AS DOUBLE
		DIM intLedgerColumn			AS INTEGER
		DIM intNumberOfCrew			AS INTEGER
		DIM intPlayerCount			AS INTEGER
		DIM intLastPlayerRow		AS INTEGER
		DIM dblCreditToCrew			AS DOUBLE
		DIM dblRemainingCredit		AS DOUBLE
		REM DIM dblControlTotal			AS DOUBLE
		DIM dblTotalCost			AS DOUBLE
		REM DIM dblTotalPooledCash		AS DOUBLE
		DIM dblCreditValuesTotal	AS DOUBLE

		IF NOT (objFinancesAmountCell.Type = com.sun.star.table.CellContentType.EMPTY) THEN
			dblRemainingCredit = objFinancesAmountCell.Value
			dblCreditValuesTotal = 0
			intPlayerCount = intFinancesRowStart
			REM intNumberOfCrew = 0

			IF NOT (objFinances.getCellByPosition(1, 35).Type = com.sun.star.table.CellContentType.EMPTY) THEN
				REDIM aCreditValues(objFinances.getCellByPosition(1, 35).Value) AS DOUBLE
				intLastPlayerRow = (intPlayerCount + objFinances.getCellByPosition(1, 35).Value)
			END IF
		END IF

		IF ((NOT (objFinancesCreditLineCell.Type = com.sun.star.table.CellContentType.EMPTY)) OR (NOT (objFinancesCreditCostCell.Type = com.sun.star.table.CellContentType.EMPTY))) THEN
			IF ((NOT (objFinancesCreditLineCell.Type = com.sun.star.table.CellContentType.EMPTY)) AND (NOT (objFinancesCreditCostCell.Type = com.sun.star.table.CellContentType.EMPTY))) THEN
				MSGBOX "ERROR: both a ledger line and an amount have been specified. Only one may be used."
				EXIT SUB
			END IF

			IF NOT (objFinancesCreditLineCell.Type = com.sun.star.table.CellContentType.EMPTY) THEN
				IF NOT (objLedger.getCellByPosition(2, (objFinancesCreditLineCell.Value - 1)).String = strDebit) THEN
					MSGBOX "ERROR: the ledger line specified is not a debit."
					EXIT SUB
				END IF

				REM MSGBOX ("Credit Line: " + objFinancesCreditLineCell.String)
				dblTotalCost = objService.callFunction("SUM", Array(objLedger.getCellRangeByName(("$F$" + objFinancesCreditLineCell.String + ":$X$" + objFinancesCreditLineCell.String))))
				intLedgerColumn = intLedgerUserStartColumn

				DO WHILE NOT (objLedger.getCellByPosition(intLedgerColumn, (objFinancesCreditLineCell.Value - 1)).Type = com.sun.star.table.CellContentType.EMPTY)
					IF (dblTotalCost < dblRemainingCredit) THEN
						aCreditValues((intLedgerColumn - intLedgerUserStartColumn)) = objLedger.getCellByPosition(intLedgerColumn, (objFinancesCreditLineCell.Value - 1)).Value
					ELSE
						aCreditValues((intLedgerColumn - intLedgerUserStartColumn)) = (dblRemainingCredit * (objLedger.getCellByPosition(intLedgerColumn, (objFinancesCreditLineCell.Value - 1)).Value / dblTotalCost))
					END IF

					dblCreditValuesTotal = (dblCreditValuesTotal + aCreditValues((intLedgerColumn - intLedgerUserStartColumn)))
					intLedgerColumn = (intLedgerColumn + 1)
				LOOP
			ELSE
				dblTotalCost = objFinancesCreditCostCell.Value
				REM dblTotalPooledCash = objFinances.getCellByPosition(6, 35).Value

				DO WHILE (intPlayerCount < intLastPlayerRow)
					REM TODO: verify indexing here:
					aCreditValues((intPlayerCount - intFinancesRowStart)) = (objFinances.getCellByPosition(intDebitDistColumn, intPlayerCount).Value * dblTotalCost)
					dblCreditValuesTotal = (dblCreditValuesTotal + aCreditValues((intPlayerCount - intFinancesRowStart)))
					intPlayerCount = (intPlayerCount + 1)
				LOOP
			END IF

			REM MSGBOX ("dblCreditValuesTotal: " + dblCreditValuesTotal + ", dblTotalCost: " + dblTotalCost)

			REM IF NOT (dblCreditValuesTotal = dblTotalCost) THEN
			REM 	MSGBOX "ERROR: The allocated costs do not match the cost input."
			REM 	EXIT SUB
			REM END IF

			dblRemainingCredit = (dblRemainingCredit - dblTotalCost)
		END IF

		REM skip a bit
		intPlayerCount = intFinancesRowStart

		IF (dblRemainingCredit > 0) THEN
			dblCreditValuesTotal = 0

			DO WHILE NOT (objFinances.getCellByPosition(1, intPlayerCount).Type = com.sun.star.table.CellContentType.EMPTY)
				aCreditValues((intPlayerCount - intFinancesRowStart)) = (aCreditValues((intPlayerCount - intFinancesRowStart)) + (objFinances.getCellByPosition(intCreditDistColumn, intPlayerCount).Value * dblRemainingCredit))
				dblCreditValuesTotal = (dblCreditValuesTotal + aCreditValues((intPlayerCount - intFinancesRowStart)))
				intPlayerCount = (intPlayerCount + 1)
			LOOP

		END IF

		IF (dblCreditValuesTotal > (objFinancesAmountCell.Value + dblMaximumVariance)) OR (dblCreditValuesTotal < (objFinancesAmountCell.Value - dblMaximumVariance)) THEN
			MSGBOX ("ERROR: the credit amount was " + objFinancesAmountCell.Value + ", but the total amount transacted was " + dblCreditValuesTotal)
			EXIT SUB
		END IF

		JOURNAL("Credit", aCreditValues)
		REM because referring to the same thing in a consistent way is overrated...
		objFinances.getCellRangeByName("$R$38").clearContents(com.sun.star.sheet.CellFlags.STRING)
		objFinances.getCellRangeByName("$R$41").clearContents(com.sun.star.sheet.CellFlags.VALUE)

		IF NOT (objFinancesCreditCostCell.Type = com.sun.star.table.CellContentType.EMPTY) THEN
			objFinances.getCellRangeByName("$T$47").clearContents(com.sun.star.sheet.CellFlags.VALUE)
		END IF

		IF NOT (objFinancesCreditLineCell.Type = com.sun.star.table.CellContentType.EMPTY) THEN
			objFinances.getCellRangeByName("$T$49").clearContents(com.sun.star.sheet.CellFlags.VALUE)
		END IF

		CAPPOOLEDCASH()
	END IF
END SUB

SUB DEBIT
	REM MSGBOX "PlayerFinance.PROCESS.DEBIT"
	INIT()

	IF NOT (objFinancesAmountCell.Type = com.sun.star.table.CellContentType.EMPTY) THEN
		DIM aDebitValues(1)			AS DOUBLE
		DIM dblControlTotal			AS DOUBLE
		DIM dblDebitAmount			AS DOUBLE
		DIM dblTotalPooledCash		AS DOUBLE
		DIM intFinancesRowCount		AS INTEGER
		DIM intLastPlayerRow		AS INTEGER
		DIM intNumberOfCrew			AS INTEGER

		dblDebitAmount = objFinancesAmountCell.Value
		dblControlTotal = 0
		intFinancesRowCount = intFinancesRowStart

		IF NOT (objFinances.getCellByPosition(6, 35).Type = com.sun.star.table.CellContentType.EMPTY) THEN
			dblTotalPooledCash = objFinances.getCellByPosition(6, 35).Value
		END IF

		IF NOT (objFinances.getCellByPosition(1, 35).Type = com.sun.star.table.CellContentType.EMPTY) THEN
			intNumberOfCrew = objFinances.getCellByPosition(1, 35).Value
		ELSE
			intNumberOfCrew = 0
		END IF

		IF (intNumberOfCrew > 0) THEN
			REDIM aDebitValues(intNumberOfCrew) AS DOUBLE
			intLastPlayerRow = (intFinancesRowStart + intNumberOfCrew)
		END IF

		IF (dblTotalPooledCash < dblDebitAmount) THEN
			MSGBOX "ERROR: insufficient Funds"
			EXIT SUB
		END IF

		DO WHILE NOT (objFinances.getCellByPosition(1, intFinancesRowCount).Type = com.sun.star.table.CellContentType.EMPTY)
			DIM dblPooledCash			AS DOUBLE
			REM despite what the documentation states, dblPooledCash is not reinitialized at zero for every iteration of the loop
			dblPooledCash = 0

			IF NOT (objFinances.getCellByPosition(6, intFinancesRowCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
				dblPooledCash = objFinances.getCellByPosition(6, intFinancesRowCount).Value
			END IF

			IF (dblPooledCash > 0) THEN
				DIM dblPooledCashDebit		AS DOUBLE
				DIM dblPooledCashPercent	AS DOUBLE
				REM DIM dblPooledCashNew		AS DOUBLE

				IF NOT (objFinances.getCellByPosition(9, intFinancesRowCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
					dblPooledCashPercent = objFinances.getCellByPosition(9, intFinancesRowCount).Value
				ELSE
					dblPooledCashPercent = 0
				END IF

				dblPooledCashDebit = (dblDebitAmount * dblPooledCashPercent)
				REM MSGBOX ("dblPooledCashPercent: " + dblPooledCashPercent + ", dblDebitAmount: " + dblDebitAmount + ", dblPooledCashDebit: " + dblPooledCashDebit)

				IF (dblPooledCashDebit > dblPooledCash) THEN
					dblPooledCashDebit = dblPooledCash
				END IF

				aDebitValues((intFinancesRowCount - intFinancesRowStart)) = dblPooledCashDebit
				REM dblPooledCashNew = (dblPooledCash - dblPooledCashDebit)
				dblControlTotal = (dblControlTotal + dblPooledCashDebit)
				REM objFinances.getCellByPosition(6, intFinancesRowCount).Value = dblPooledCashNew
				REM MSGBOX ("intFinancesRowCount: " + intFinancesRowCount + ", dblPooledCashDebit: " + dblPooledCashDebit + ", dblControlTotal: " + dblControlTotal)
				intFinancesRowCount = (intFinancesRowCount + 1)
			END IF
		LOOP

		IF (dblControlTotal > (dblDebitAmount + dblMaximumVariance)) OR (dblControlTotal < (dblDebitAmount - dblMaximumVariance)) THEN
			MSGBOX ("ERROR: the credit amount was " + dblDebitAmount + ", but the total amount transacted was " + dblControlTotal)
			EXIT SUB
		END IF

		intFinancesRowCount = intFinancesRowStart

		DO WHILE (intFinancesRowCount < (intFinancesRowStart + intNumberOfCrew))
			DIM dblPooledCash2			AS DOUBLE
			dblPooledCash2 = 0

			IF NOT (objFinances.getCellByPosition(6, intFinancesRowCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
				dblPooledCash2 = objFinances.getCellByPosition(6, intFinancesRowCount).Value
			END IF

			IF (dblPooledCash2 > 0) THEN
				objFinances.getCellByPosition(6, intFinancesRowCount).Value = (dblPooledCash2 - aDebitValues((intFinancesRowCount - intFinancesRowStart)))
			END IF

			SELECT CASE objQuickDebitBox.SelectedValue
			CASE "":
				REM 
			CASE "Pay Ship Mortgage":
				DIM dblAddShipStake			AS DOUBLE
				DIM dblNewShipStake 		AS DOUBLE
				dblAddShipStake = 0
				dblNewShipStake = 0

				objParameters.getCellByPosition(1, 3).Value = (dblCurrentShipMortgage - dblDebitAmount)

				IF (dblShipPaymentToEquity > 0) THEN
					IF (booEvenShipStake) THEN
						dblAddShipStake = ((dblDebitAmount / intNumberOfCrew) * dblShipPaymentToEquity)
					ELSE
						dblAddShipStake = (aDebitValues((intFinancesRowCount - intFinancesRowStart)) * dblShipPaymentToEquity)
					END IF

					IF NOT (objFinances.getCellByPosition(4, intFinancesRowCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
						dblNewShipStake = objFinances.getCellByPosition(4, intFinancesRowCount).Value
					END IF

					dblNewShipStake = (dblNewShipStake + dblAddShipStake)

					IF (dblNewShipStake > 0) THEN
						objFinances.getCellByPosition(4, intFinancesRowCount).Value = dblNewShipStake
					END IF
				END IF
			END SELECT

			intFinancesRowCount = (intFinancesRowCount + 1)
		LOOP

		JOURNAL("Debit", aDebitValues)
		objFinances.getCellRangeByName("$R$38").clearContents(com.sun.star.sheet.CellFlags.STRING)
		objFinances.getCellRangeByName("$R$41").clearContents(com.sun.star.sheet.CellFlags.VALUE)
		objQuickDebitBox.SelectedValue = ""
	END IF
END SUB

SUB TRANSFER
	MSGBOX "PlayerFinance.PROCESS.TRANSFER"
END SUB

SUB PURCHASE
	MSGBOX "PlayerFinance.PROCESS.PURCHASE"
END SUB

SUB CAPPOOLEDCASH
	INIT()

	DIM intCount				AS INTEGER
	DIM intPlayerCount			AS INTEGER
	DIM dblPooledCash			AS DOUBLE
	DIM dblPooledCashSplit		AS DOUBLE

	IF NOT (objFinances.getCellByPosition(6, 35).Type = com.sun.star.table.CellContentType.EMPTY) THEN
		dblPooledCash = objFinances.getCellByPosition(6, 35).Value
	END IF

	IF (dblCapPooledCash > 0) THEN
		IF NOT (objFinances.getCellByPosition(1, 35).Type = com.sun.star.table.CellContentType.EMPTY) THEN
			intPlayerCount = objFinances.getCellByPosition(1, 35).Value
		END IF
	END IF
	REM MSGBOX (("intPlayerCount: " + intPlayerCount)

	IF (dblPooledCash > dblCapPooledCash) THEN
		dblPooledCashDiff = (dblPooledCash - dblCapPooledCash)
		dblPooledCashSplit = (dblCapPooledCash / intPlayerCount)
		intCount = intFinancesRowStart

		DO WHILE NOT (objFinances.getCellByPosition(1, intCount).Type = com.sun.star.table.CellContentType.EMPTY) 
			IF NOT (objFinances.getCellByPosition(6, intCount).Type = com.sun.star.table.CellContentType.EMPTY) THEN
				IF (objFinances.getCellByPosition(6, intCount).Value > dblPooledCashSplit) THEN
					DIM dblCashOnHand				AS DOUBLE
					DIM dblPooledCashContribution	AS DOUBLE
					DIM dblPooledCashDifference		AS DOUBLE

					dblPooledCashContribution = objFinances.getCellByPosition(6, intCount).Value
					dblCashOnHand = objFinances.getCellByPosition(7, intCount).Value
					dblPooledCashReduction = (dblPooledCashDiff / intPlayerCount)
					objFinances.getCellByPosition(6, intCount).Value = (dblPooledCashContribution - dblPooledCashReduction)
					objFinances.getCellByPosition(7, intCount).Value = (dblCashOnHand + dblPooledCashReduction)
				END IF
			END IF

			intCount = (intCount + 1)
		LOOP
	END IF
END SUB

SUB QUICK
	INIT()

	SELECT CASE objQuickDebitBox.SelectedValue
		CASE "":
			objFinances.getCellRangeByName("$R$38").clearContents(com.sun.star.sheet.CellFlags.STRING)
			objFinances.getCellRangeByName("$R$41").clearContents(com.sun.star.sheet.CellFlags.VALUE)
			objQuickDebitBox.SelectedValue = ""
		CASE "Pay Ship Mortgage":
			objFinancesNoteCell.String = "ship mortgage"
			objFinancesAmountCell.Value = dblShipMortgagePayment
		CASE "Pay Ship Maintenance":
			objFinancesNoteCell.String = "ship maintenance"
			objFinancesAmountCell.Value = dblShipMaintenance
		CASE "Pay Ship Fuel":
			objFinancesNoteCell.String = "ship fuel"
			objFinancesAmountCell.Value = dblShipFuel
		CASE "Pay Ship Life Support":
			objFinancesNoteCell.String = "ship life support"
			objFinancesAmountCell.Value = dblShipLifeSupport
		CASE "Pay Crew Salaries":
			objFinancesNoteCell.String = "crew salaries"
			objFinancesAmountCell.Value = dblCrewSalaries
	END SELECT
END SUB

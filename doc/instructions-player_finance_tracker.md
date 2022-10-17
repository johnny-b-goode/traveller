# Player Finance Tracker

## Introduction

Keeping track of player finances in Traveller can easily get out of hand, so many groups simply pool their money and then have one person act as a treasurer. While this approach works reasonably well for simple scenarios, it is quite limited. Trying to deal with more complex scenarios, or in some cases even answer simple questions, can become quite the headache. The Player Finance Tracker seeks to alleviate that headache.

The code for the macros used in this spreadsheet is available in [https://github.com/johnny-b-goode/traveller/tree/main/src/macros](https://github.com/johnny-b-goode/traveller/tree/main/src/macros).

## Calculating a Character's Cut

I wanted a set of calculations that would give players a fair cut of any profits based on multiple factors, specifically:
- ownership stake in the ship
- cash invested into whatever venture has generated a profit

It would not be fair for the ship owners to be the only ones to profit if an investment is completely underwritten by somebody else, nor should the investors be the sole beneficiaries of the ship's activities. The Player Finance Tracker also allows a portion of any income to be allocated to a crew payout, so that players who rolled poorly in character creation can still benefit from the group's daring-do.

Credits (payments received by the players) are first reduced by the percentage allocated to crew profit. There are further options for how this percentage is distributed, which will be described under *Parameters* and *Finances*. Once the Crew Profit Percentage has been allocated, weighting factors are calculated for ship ownership and cash invested based on the ratio of the two values. The calculation is more complex than a direct ratio, but in general, ship ownership would be expected to weight higher as ownership stakes are valued in millions of credits. If, however, the pooled cash invested is equal to the value of ship ownership, then the ratio is 1:1. If pooled cash becomes more then the weighting will begin to favor pooled cash. The only time either factor is weighted at 100 % is if the other factor is zero.

>NOTE: The weighting calculations are based on the value of the ownership stake, not the value of the ship. So, the larger the portion of the ship owned by the players, the greater the weight of ship ownership.

## Control Totals

This tool is not an actual financial transaction processing system, so it does not include all of the capabilities such a system normally would (nor does it cost hundreds of thousands or millions of dollars). The macros used by the spreadsheet do typically leverage a technique called *control totals* to help ensure transactions are handled accurately. The total value of a series of transactions must be within one millionth (0.000001) of a credit. If the transaction value exceeds this variance (either higher or lower) then an error will be generated.

## Paying off the Ship

As players make payments on their ships mortgage, their ownership stake in the ship increases. Since a mortgage payment is handled the same as any other debit, the ownership stake is calculated based on the character's proportion of the pooled cash. A percentage of this contribution amount (see *Parameters*) is then applied to the character's ownership stake in the ship.

> NOTE: In order for a debit to be correctly processed as a payment on a ship mortgage, the *Pay Ship Mortgage* Quick Debit should be selected from the *Quick Debit* drop-down.

## Unimplemented Features

Presently, none.

## Instructions

The Player Finance Tracker spreadsheet is included in releases of the project, and can be downloaded by clicking on *Releases* on the right-hand side of the project page, or directly from [player_finance_tracker.ods](https://github.com/johnny-b-goode/traveller/releases/latest/download/player_finance_tracker.ods)

When using the spreadsheet, you will need to enable macros.

### Parameters

The *parameters* tab contains a number of parameters that can be used to change the behavior of the tool. These parameters should be set before the tool is used for the first time.

- **Ship Value** - The actual value of the players' ship.
- **Starting Ship Mortgage** - The value of the players' mortgage on the ship at the beginning of the game.
- **Current Ship Mortgage** - The current value of the players' mortgage on the ship. This represents the cost to pay off the mortgage if the players were to do so. This number will decrease as payments are made.
- **Ship Mortgage Payment to Equity** - This is the fraction of the mortgage payment to apply to the *Current Ship Mortgage* and to the individual character's ownership stakes. The default is 50%.
- **Ship Mortgage Payment** - The monthly (more properly, once per maintenance interval) payment on the ship. This value does not include fuel, crew salaries, or maintenance, all of which should be paid separately. This value is automatically calculated based on the *Starting Ship Mortgage*.
- **Ship Maintenance** - Maintenance cost associated with the *Pay Ship Maintenance* Quick Debit. This value is automatically calculated based on the *Ship Value*, *Maintenance Cost Ratio*, *Maintenance Periods per Year*, and *Additional Maintenance Cost*.
- **Ship Fuel** - Fuel cost associated with the *Pay Ship Fuel* Quick Debit. Specify the cost to fuel up the ship.
- **Ship Crew Salaries** - Crew salary cost associated with the *Pay Crew Salaries* Quick Debit. Specify the total cost of crew salaries. If the ship is entirely crewed by player characters, then this may not be used.
- **Ship Life Support** - Life support cost associated with the *Pay Ship Life Support* Quick Debit. Specify the cost for life support for the ship. Note that this has much greater potential for variability than most of the other costs associated with the ship. Users of this tool may normalize this cost, use it only for life support associated with the crew, or adjust it every time this expense is paid (the latter is not recommended).
- **Credit Value of Ship Share** - This is a parameter used in various calculations. Generally speaking, it should never be changed.
- **Maintenance Cost Ratio** - This is the percentage of the *Ship Value* to be attributed to annual maintenance cost. The default is 0.1%, as specified in the Core Rulebook, Update 2022.
- **Maintenance Periods per Year** - There are not 12 four week periods per year, there are in-fact 13. The default for this setting is 13, however it may be changed to 12 to reflect what is actually written in the rules.
- **Additional Maintenance Cost** - This parameter can be used to help simplify book keeping. Specify any additional maintenance you would like to include in the maintenance cost. For example, maintenance costs for additional vehicles or equipment can be added here.
- **Crew Profit Percent** - The percentage of *Credit*s to allocate to crew profit. Typically this number should be relatively small (perhaps 5 - 20%), though this can be set to 100% to manually override distribution of profits (requires setting *Crew Profit Percentage* on the *Finance* tab). If in doubt, set this to zero.
- **Even Distribution of Crew Profit** - If this option is selected any *Crew Profit Percentage* specified on the *Finance* tab will be ignored. The *Crew Profit Percent* will instead be distributed evenly among the crew.
- **Even Distribution of Ship Stake by Payment** - If this option is set to *Yes*, then as the ship mortgage is paid the ownership stake in the ship will be evenly distributed among the crew, instead of being distributed based on contributed portion of pooled cash.
- **Pooled Cash Cap** - This parameter can be used to help simplify book keeping. Specify a total cap for pooled cash. Pooled cash above the cap will automatically be transferred to the player's cash on hand. This can be helpful for maintaining an even split of pooled cash.

### Finances

The *finances* tab is where the bulk of the utility of the PFT resides. Characters should be added to this tab (one per row) in order to be tracked by this tool.

- **Player** - The name of the player controlling the character.
- **Character** - The name of the character.
- **Crew Profit** Percentage - The percentage of the *Crew Profit Percentage* allocated to this character. If *Crew Profit Percentage* is zero or blank, this value is ignored. If *Crew Profit Percentage* is not blank, then the total of this value for all characters should be 100%.
- **Ship Shares** - The number of ship shares, in this ship, held by the character. See [Ship Shares](https://github.com/johnny-b-goode/traveller/blob/main/doc/ship_shares.md) for an expanded description of what ship shares represent and how they are handled. If players do not wish to use the expanded description of ship shares, they may simply convert ship shares into ownership stake at a ratio of Cr 1 Million per ship share.
- **Ship Stake** - The character's ownership stake of the ship, in credits. This value is specified in credits because it is somewhat easier to track and it helps to avoid excessive precision (places after the decimal point) in tracked values.
- **Pooled Cash** - The amount of cash the character has contributed to the ships operation and investment fund. Expenditures are subtracted from pooled cash proportional to the amount contributed by each player (so the proportions remain the same unless intentionally changed). These proportions are also used in the distribution of profits (though not solely), and ship ownership stake as the mortgage is paid.
- **Cash on Hand** - Represents the cash immediately available to the character. These funds are separate from the ships operation and investment fund, and can be used as the player so chooses.
- **Transfer / Purchase Amount** - Normally these cells will be blank. Values may be specified to process transfers and purchases as described below.

The following actions can be taken on the *finances* tab.

#### Transfer cash from *Pooled Cash* to *Cash on Hand*
This action is used to move funds from *Pooled Cash* to *Cash on Hand*. Simply enter the amount you would like to transfer for each player under the *Transfer / Purchase Amount* column. Players for whom an amount has not been entered will be skipped. You may enter a note in the *Note* field. If a note is not entered, a generic note will be generated automatically. Click the ">" button to execute the transfer.

#### Transfer cash from *Cash on Hand* to *Pooled Cash*
This action is used to move funds from *Cash on Hand* to *Pooled Cash*. Simply enter the amount you would like to transfer for each player under the *Transfer / Purchase Amount* column. Players for whom an amount has not been entered will be skipped. You may enter a note in the *Note* field. If a note is not entered, a generic note will be generated automatically. Click the "<" button to execute the transfer.

#### Purchase using *Cash on Hand*
This action is used to make a purchase using funds from characters *Cash on Hand*. Simply enter the amount each player is spending under the *Transfer / Purchase Amount* column. Players for whom an amount has not been entered will be skipped. You may enter a note in the *Note* field. If a note is not entered, a generic note will be generated automatically. Click the "Purchase" button to execute the purchase.

> NOTE: To purchase using *Pooled Cash*, create a *Debit*.

#### Create *Debits*

This action would normally be used to pay expenses incurred by the Travellers. Enter a note describing the transaction in the *Note* field and an amount in the *Amount* field and click the *Debit* button to subtract funds from *Pooled Cash*.

#### Create *Credits*

This action would normally be used for the Travellers to receive payment. Enter a note describing the transaction in the *Note* field and an amount in the *Amount* field. An amount may be specified in the *Cost* field, **OR** a ledger line may be specified in the *Line* field (but not both).

If an amount is entered in the *Cost* field, it represents a cost associated with that credit (ie, something the characters purchased and are now selling). The amount specified will be distributed based on the current *debit* distributions, and the remainder (if any) will be distributed based on the *credit* distributions. This can be used whenever characters have a significant difference between their debit and credit distributions (for example, a character has a significant contribution to pooled cash, but a low ownership stake), to prevent a character or characters bearing an undue portion of costs (ie, will prevent some characters profiting at the expense of others). This may also be used if there were multiple expenditures (debits) associated with a credit (for example, a mission payout where the characters maid multiple purchases to be able to complete the mission).

If a line number is entered in the *Line* field, it must correspond to a *debit* transaction in the *Ledger*. The detailed costs documented by the referenced line will be factored into calculating the distribution for each character. Costs will be attributed first, followed by any remaining profit using *credit* distributions. This can be used whenever characters have a *credit* for which there is a prior *debit* (ie, when engaging in speculative trade). This serves the same function as specifying a value in the *Amount* field, but based on previously recorded values. Use of this functionality is recommended to obtain the greatest degree of accuracy.

Click the *Credit* button to add funds to *Pooled Cash*.

> NOTE: If a *Pooled Cash Cap* has been specified in the *Parameters* tab, then funds will be allocated to pooled cash up to the specified cap, with the remainder going to *Cash on Hand*.

#### Select *Quick Debit*s

A Quick Debit can be selected from the *Quick Debit* drop-down. Selecting a Quick Debit will automatically populate the *Note* and *Amount* fields for the transaction. These may be modified prior to clicking the *Debit* button to process the transaction. Quick Debits may also include additional logic in their processing, such as when paying a ship mortgage.

#### View Hidden Rows and Columns

There are rows and columns hidden in this sheet. For greater visibility into the mechanics of the tool, the following can be unhidden:
	The first 13 rows - These are various elements used as part of the credit and debit distribution calculations.
	Total ship ownership - Represents the combination of *Ship Shares* and *Ship Stake*, normalized in Cr. This is also used in calculations.
	Debit and credit - These are the actual debit and credit distributions. These are the values used when calculating distributions.

### Ledger

The *ledger* is a record of the transactions that have been performed. This ledger is not intended to be auditable in accordance to Generally Acceptable Accounting Practices (GAAP), but merely to provide a basic record of what has been transacted (such as keeping track of whether or not the ship's mortgage has been paid for the month). The fields in the ledger are:

- **Date** - The real world date the transaction was performed (it seems easier to keep track of than the in-game dates).
- **Note** - Not required but is strongly encouraged, otherwise the transaction history in the ledger will not be very useful.
- **Debit** / Credit - Whether or not the transaction was a debit (money the characters remitted) or a credit (money the characters received).
- **Amount** - The amount of the transaction.
- **Detail** - Starting on the left, each column under the *Detail* heading corresponds to a single character. For each transaction, the amount transacted for that character will be documented in this column.

> NOTE: Transfer and purchase transactions will always have an *Amount* of $0. Purchases are made against *Cash on Hand* and therefore do not have an amount transacted against pooled cash. Transfers to and from pooled cash do, and transfers to pooled cash will be a credit, while transfers from pooled cash will be a debit, though both will still have an *Amount* of $0 to more easily distinguish them. The amounts for each character are still documented in the *Detail* columns for both transfers and purchases.
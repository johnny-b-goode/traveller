# Player Finance Tracker

## Introduction

Keeping track of player finances in Traveller can easily get out of hand, so many groups simply pool their money and then have one person act as a treasurer. While this approach works reasonably well for simple scenarios, it is quite limited. Trying to deal with more complex scenarios, or in some cases even answer simple questions, can become quite the headache. The Player Finance Tracker seeks to alleviate that headache.

The code for the macros used in this spreadsheet is available in [https://github.com/johnny-b-goode/traveller/tree/main/src/macros](https://github.com/johnny-b-goode/traveller/tree/main/src/macros).

## Calculating a Character's Cut

I wanted a set of calculations that would give players a fair cut of any profits based on multiple factors, specifically:
ownership stake in the ship
cash invested into whatever venture has generated a profit

It would not be fair for the ship owners to be the only ones to profit if an investment is completely underwritten by somebody else, nor should the investors be the sole beneficiaries of the ship's activities. The Player Finance Tracker also allows a portion of any income to be allocated to a crew payout (which can include both player and non-player characters), so that players who rolled poorly in character creation can still benefit from the group's daring-do.

Credits (payments received by the players) are first reduced by the percentage allocated to crew profit. There are further options for how this percentage is distributed, which will be described under *Parameters* and *Finances*. Once the Crew Profit Percentage has been allocated, weighting factors are calculated for ship ownership and cash invested based on the ratio of the two values. The calculation is more complex than a direct ratio, but in general, ship ownership would be expected to weight higher as ownership stakes are valued in millions of credits. If, however, the pooled cash invested is equal to the value of ship ownership, then the ratio is 1:1. If pooled cash becomes more then the weighting will begin to favor pooled cash. The only time either factor is weighted at 100 % is if the other factor is zero.

>NOTE: The weighting calculations are based on the value of the ownership stake, not the value of the ship. So, the larger the portion of the ship owned by the players, the greater the weight of ship ownership.

## Control Totals

This tool is not an actual financial transaction processing system, so it does not include all of the capabilities such a system normally would (nor does it cost hundreds of thousands or millions of dollars). The macros used by the spreadsheet do leverage a technique called *control totals* to help ensure transactions are handled accurately. The total value of a series of transactions must be within one millionth (0.000001) of a credit. If the transaction value exceeds this variance (either higher or lower) then an error will be generated.

> NOTE: The transaction will still be processed, and entered into the ledger. When an error is generated (which, hopefully, is rare), it will need to be manually corrected (simply change the values in the appropriate cells in the spreadsheet).

## Paying off the Ship

As players make payments on their ships mortgage, their ownership stake in the ship increases. Since a mortgage payment is handled the same as any other debit, the ownership stake is calculated based on the character's proportion of the pooled cash.

> NOTE: In order for a debit to be correctly processed as a payment on a ship mortgage, the *Pay Ship Mortgage* Quick Debit should be selected from the *Quick Debit* drop-down.

## Unimplemented Features

Additional *Quick Debit* actions may be added in the future.

## Instructions

The Player Finance Tracker spreadsheet is included in releases of the project, and can be downloaded by clicking on *Releases* on the right-hand side of the project page, or directly from [player_finance_tracker.ods](https://github.com/johnny-b-goode/traveller/releases/latest/download/player_finance_tracker.ods)

### Parameters

The *parameters* tab contains a number of parameters that can be used to change the behavior of the tool. These parameters should be set before the tool is used for the first time.

- **Ship Value** - The actual value of the players' ship.
- **Starting Ship Mortgage** - The value of the players' mortgage on the ship at the beginning of the game.
- **Current Ship Mortgage** - The current value of the players' mortgage on the ship. This represents the cost to pay off the mortgage if the players were to do so.
- **Ship Mortgage Payment** - The monthly (more properly, once per maintenance interval) payment on the ship. This value does not include fuel, crew salaries, or maintenance, all of which should be paid separately.
- **Credit Value of Ship Share** - This is a parameter used in various calculations. Generally speaking, it should never be changed.
- **Crew Profit Percent** - The percentage of *Credit*s to allocate to crew profit. Typically this number should be relatively small (perhaps 5 - 20%), though this can be set to 100% to manually override distribution of profits (requires setting *Crew Profit Percentage* on the *Finance* tab). If in doubt, set this to zero.
- **Even Distribution of Crew Profit** - If this option is selected any *Crew Profit Percentage* specified on the *Finance* tab will be ignored. The *Crew Profit Percent* will instead be distributed evenly among the crew.
- **Include NPC Travellers in Crew Profit** - If *Even Distribution of Crew Profit* is set to *Yes*, then setting this option to *Yes* will include NPC crew. Normally this would be set to *No*.
- **Even Distribution of Ship Stake by Payment** - If this option is set to *Yes*, then as the ship mortgage is paid the ownership stake in the ship will be evenly distributed among the crew, instead of being distributed based on contributed portion of pooled cash.

### Finances

The *finances* tab is where the bulk of the utility of the PFT resides. Characters should be added to this tab (one per row) in order to be tracked by this tool.

- **Player** - The name of the player controlling the character. Note that "NPC" is a special value in this column, and should be applied to NPC characters.
- **Character** - The name of the character.
- Crew Profit Percentage - The percentage of the *Crew Profit Percentage* allocated to this character. If *Crew Profit Percentage* is zero or blank, this value is ignored. If *Crew Profit Percentage* is not blank, then the total of this value for all characters should be 100%.
- Ship Shares - The number of ship shares, in this ship, held by the character. See [Ship Shares](https://github.com/johnny-b-goode/traveller/blob/main/doc/ship_shares.md) for an expanded description of what ship shares represent and how they are handled. If players do not wish to use the expanded description of ship shares, they may simply convert ship shares into ownership stake at a ratio of Cr 1 Million per ship share.
- Ship Stake - The character's ownership stake of the ship, in credits. This value is specified in credits because it is somewhat easier to track and it helps to avoid excessive precision (places after the decimal point) in tracked values.
- Pooled Cash - The amount of cash the character has contributed to the ships operation and investment fund. Expenditures are subtracted from pooled cash proportional to the amount contributed by each player (so the proportions remain the same unless intentionally changed). These proportions are also used in the distribution of profits (though not solely), and ship ownership stake as the mortgage is paid.
- Cash on Hand - Represents the cash immediately available to the character. This can be used as the player so chooses.

The following actions can be taken on the *finances* tab.

#### Move cash between *Pooled Cash* and *Cash on Hand*
This must be performed manually by adjusting the values in the cells under these columns. Simply subtract the amount desired from the appropriate cell in either the *Pooled Cash* or *Cash on Hand* column and add it to the corresponding cell in the other. Players should understand that while they bear a portion of the debits transacted, they also receive both profits and increasing ship ownership (as the mortgage is paid) based on what they have contributed to pooled cash. The most ideal scenario is probably for players to work toward an even distribution of *Pooled Cash*.

#### Create *Debits*

This action would normally be used to pay expenses incurred by the Travellers. Enter a note describing the transaction in the *Note* field and an amount in the *Amount* field and click the *Debit* button to subtract funds from *Pooled Cash*.

#### Create *Credits*

This action would normally be used for the Travellers to receive payment. Enter a note describing the transaction in the *Note* field and an amount in the *Amount* field and click the *Credit* button to add funds to *Pooled Cash*.

#### Select *Quick Debit*s

A Quick Debit can be selected from the *Quick Debit* drop-down. Selecting a Quick Debit will automatically populate the *Note* and *Amount* fields for the transaction. These may be modified prior to clicking the *Debit* button to process the transaction. Quick Debits may also include additional logic in their processing, such as when paying a ship mortgage.

### Ledger

The *ledger* is a record of the transactions that have been performed. This ledger is not intended to be auditable in accordance to Generally Acceptable Accounting Practices (GAAP), but merely to provide a basic record of what has been transacted (such as keeping track of whether or not the ship's mortgage has been paid for the month). The fields in the ledger are:

- **Date** - The real world date the transaction was performed (it seems easier to keep track of than the in-game dates).
- Note - Not required but is strongly encouraged, otherwise the transaction history in the ledger will not be very useful.
- Debit / Credit - Whether or not the transaction was a debit (money the characters remitted) or a credit (money the characters received).
- Amount - The amount of the transaction.
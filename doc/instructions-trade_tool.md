# Trade Tool

## Introduction

Carrying freight, passengers, or engaging in speculative trade all require large numbers of dice rolls and lookups, which make them somewhat impractical to use on a consistent basis. This is particularly true for determining the availability and price of various trade goods. This tool facilitates carrying of freight and passengers and speculative trade by streamlining the process of determining the numbers and sizes of available freight lots, the availability of including mail, availability of passengers of different types, and the availability and prices of various types of trade goods.

Game masters should be aware that the use of this tool, either by themselves or by their players, could significantly alter the availability of funds to the players. Using a combination of freight and speculative trade, our group routinely generates around Cr1M revenue per maintenance period with a jump 2 ship capable of carrying 140 tons cargo. This can vary from a few hundred thousand credits, to a few million credits. In general, the more effort invested in analyzing worlds and UWPs, trade codes, and planning routes, the more profitable the ship (and crew) will be. Relevant skills (Broker, in particular, but also Streetwise and Steward) and good rolls always play a role as well. This profitability may in-turn require GMs to provide rewards suitable to entice players to take on missions.

The code for the macros used in this spreadsheet is available in [https://github.com/johnny-b-goode/traveller/tree/main/src/macros](https://github.com/johnny-b-goode/traveller/tree/main/src/macros).

## Books Referenced

The specific books referenced include:
| **Title**                 | **Version** | **ISBN**          |
| -                         | -           | -                 |
| Core Rulebook Update 2022 | -           | 978-1-913076-07-8 |

## Unimplemented Features

The current version of the tool functions as intended, however, there are additional features that were considered that have not yet been implemented:

- Automatic rolling for Illegal Goods
- Automatic generation of trade codes from UWP
- Import world from travellermap.com
- Automatic distance lookup using travellermap.com

## Instructions

The Trade Tool spreadsheet is included in releases of the project, and can be downloaded by clicking on *Releases* on the right-hand side of the project page, or directly from [trade_goods.ods](https://github.com/johnny-b-goode/traveller/releases/latest/download/trade_goods.ods)

When using the spreadsheet, you will need to enable macros.

### Parameters

The *parameters* tab includes a number of parameters used by the tool. The only parameter that is editable, though it should not generally be changed, is the *Opposing Broker Skill*:
- **Opposing Broker Skill** - The skill level of the "opposing" broking used when calculating total DM for purchase and sale rolls.

### Table - Worlds

The *table-worlds* tab is a lookup table for various world characteristics. The worlds available in the drop-down selectors on the *freight-passengers* and *trade* tabs are those specified in this table. Note that the majority of worlds available to visit within the game are not included in this table (only a few examples to start). Additional worlds will need to be added prior to being visited. Once a world has been added, it will be available for selection. This table need not be in any specific order, though it may be ordered if desired.

This table is referenced extensively by calculations and references in both the *freight-passengers* and *trade* tabs.

### Table - Trade Codes

The *table-trade_codes* tab is a lookup table for available trade codes. This table is not currently used for any references or calculations.

### Table - Passengers and Freight

The *table-passengers_and_freight* tab is a lookup table for pricing for passengers and freight. This table is not currently used for any references or calculations.

### Table - Passenger Traffic

The *table-passenger_traffic* tab is a lookup table for passenger traffic. This table is is used by the passenger availability calculations in the *freight-passengers* tab.

### Table - Freight Traffic

The *table-freight_traffic* tab is a lookup table for freight traffic. This table is is used by the freight availability calculations in the *freight-passengers* tab.

### Table - Modified Price

The *table-modified_price* tab is a lookup table for the purchase and sale prices based on a modified roll. This table is is used by the purchase and sale price calculations in the *trade* tab.

### Table - Modified Price

The *table-trade goods* tab is a lookup table for trade goods and various associated characteristics. This table is referenced extensively by calculations and references in the *trade* tab.

### Freight and Passengers

The *freight-passengers* tab, along with the *trade* tab is where the user will spend the majority of their time when using the Trade Tool. This tab is used to determine the availability of freight, including mail, and passengers.

The following actions can be taken on the *freight-passengers* tab.

#### Specify Relevant Parameters*
- **Highest Broker Skill** - The highest Broker skill among the ships crew. This number must be between 0 and 5, inclusive. This is used for various calculations, as well as when rolling the Broker skill.
- **Highest Steward Skill** - The highest Steward skill among the ships crew. This number must be between 0 and 5, inclusive. This is used by the calculations for passenger availability.
- **Highest Naval / Scout Rank** - The highest Navy or Scout rank among the ships crew. This number must be between 0 and 6, inclusive. This is used by the calculations for availability of mail.
- **Highest SOC DM** - The highest SOC DM among the ships crew. This number must be between -3 and +3, inclusive. This is used by the calculations for availability of mail.
- **Ship armed** - Whether or not the Traveller's ship is armed. This is used by the calculations for availability of mail.

#### Select the "From" World*
Select the departure (current) world from the drop-down.

#### Select the "To" World*
Select the destination world from the drop-down.

#### Specify the Distance Between Worlds
Specify the distance, in parsecs, between the two worlds. This number must be between 1 and 6, inclusive.

#### Roll or Specify Buyer / Supplier Roll
Once the other parameters have been specified, clicking the *Roll* button at the top of the sheet will make a Buyer / Supplier roll (using the Broker or Streetwise skill). Alternatively, a player may make this roll and input the result here.

#### Roll Freight / Mail
Once the Buyer / Supplier roll has been made, clicking the *Roll* button to the right of *Mail* will roll the availability of freight and mail. The number of lots will be generated, as well as the sizes of those lots. The availability of mail will also be determined.

#### Roll Passengers
Once the Buyer / Supplier roll has been made, clicking the *Roll* button to the right of *Low Passage* will roll the availability of passengers for each type of passage.

### Trade

The *trade* tab is used to determine the availability and both purchase and sale prices of freight.

The following actions can be taken on the *trade* tab.

##### Specify Relevant Parameters*
- **Highest Broker Skill** - The highest Broker skill among the ships crew. This number must be between 0 and 5, inclusive. This is used for various calculations, as well as when rolling the Broker skill.
- **Highest Streetwise Skill** - The highest Streetwise skill among the ships crew. This number must be between 0 and 5, inclusive. This is used for various calculations, as well as when rolling the Streetwise skill.

#### Select World*
Select the current world from the drop-down.

#### Roll or Specify Buyer / Supplier (Broker) Roll
Once the other parameters have been specified, clicking the *Roll* button to the right of *Buyer / Supplier (Broker or Streetwise)* will make a Buyer / Supplier roll (using the Broker or Streetwise skill). Alternatively, a player may make this roll and input the result here.

#### Roll or Specify Buyer / Supplier (Streetwise) Roll
Once the other parameters have been specified, clicking the *Roll* button to the right of *Buyer / Supplier (Streetwise)* will make a Buyer / Supplier roll (using the Broker or Streetwise skill). Alternatively, a player may make this roll and input the result here.

>NOTE: This role is required to purchase illegal goods.

#### Roll Purchase for Common Trade Goods
Once the other parameters have been specified, and a Buyer / Supplier roll has been made, clicking the *Roll Purchase* button to the right of *Common Trade Goods* will roll the availability **AND** purchase price of common trade goods.

*Common Trade Goods* are always available.

#### Roll Sale for Common Trade Goods
Once the other parameters have been specified, and a Buyer / Supplier roll has been made, a user may generate a sale price for any previously purchased goods. If the goods are already listed (which is what would be expected, being that they were purchased previously), simply click the *Roll Sale* button to the right of *Common Trade Goods* to roll the sale price of common trade goods. If the goods are not already listed, simply select the value corresponding to that trade good under the *Roll (D66)* column (column A), then click the *Roll Sale* button to the right of *Common Trade Goods* to roll the sale price of the selected good(s). A purchase price does not need to be generated prior to rolling for a sale price.

#### Roll Purchase for World Trade Goods
Once the other parameters have been specified, and a Buyer / Supplier roll has been made, clicking the *Roll Purchase* button to the right of *World Trade Goods* will determine the availability of trade goods based on the selected worlds trade codes **AND** roll for both availability **AND** purchase price of world trade goods.

#### Roll Sale for World Trade Goods
Once the other parameters have been specified, and a Buyer / Supplier roll has been made, a user may generate a sale price for any previously purchased goods. If the goods are already listed (which is what would be expected, being that they were purchased previously), simply click the *Roll Sale* button to the right of *Common Trade Goods* to roll the sale price of common trade goods. If the goods are not already listed, simply select the value corresponding to that trade good under the *Roll (D66)* column (column A), then click the *Roll Sale* button to the right of *World Trade Goods* to roll the sale price of the selected good(s). A purchase price does not need to be generated prior to rolling for a sale price.

#### Roll Purchase for Random Trade Goods
Once the other parameters have been specified, and a Buyer / Supplier roll has been made, clicking the *Roll Purchase* button to the right of *Random Trade Goods* will determine the availability of a number of randomly selected trade goods equal to the selected worlds population code **AND** roll for both availability **AND** purchase price of these trade goods.

#### Roll Sale for Random Trade Goods
Once the other parameters have been specified, and a Buyer / Supplier roll has been made, a user may generate a sale price for any previously purchased goods. If the goods are already listed (which is what would be expected, being that they were purchased previously), simply click the *Roll Sale* button to the right of *Common Trade Goods* to roll the sale price of common trade goods. If the goods are not already listed, simply select the value corresponding to that trade good under the *Roll (D66)* column (column A), then click the *Roll Sale* button to the right of *Random Trade Goods* to roll the sale price of the selected good(s). A purchase price does not need to be generated prior to rolling for a sale price.

#### Manually Roll For Availability, Purchase, and Sale.
- Roll D66 and select the result in the *Roll (D66)* column (column A).
- For availability, make the roll specified in the *Roll* column (column C), then enter the result in the *Result* column (column D).
- For purchase price, roll 3D6 and enter the result in the *Purchase Roll Result (3D)* column (column J).
- For sale price, roll 3D6 and enter the result in the *Sale Roll Result (3D)* column (column N).

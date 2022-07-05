# Stock Tracker

## Introduction

A relatively simple system for handling stocks is described in *Journal of the Traveller's Aid Society*, Volume 3. This tool is an implementation of that system, with minor modifications, intended to reduce manual effort associated with using the system and therefore make it viable for use over longer periods.

The tracker is pre-populated with corporations described in various works. The corporations included are not inclusive of all the corporations described throughout the published rules, settings, or adventures. See *Books Referenced* for a list of the materials referenced.

The code for the macros used in this spreadsheet is available in [https://github.com/johnny-b-goode/traveller/tree/main/src/macros](https://github.com/johnny-b-goode/traveller/tree/main/src/macros).

## Books Referenced

The specific books referenced include:
| **Title**                                        | **Version** | **ISBN**          |
| -                                                | -           | -                 |
| Journal of the Traveller's Aid Society, Volume 3 | -           | 978-1-913076-07-8 |
| Behind the Claw                                  | -           | 978-1-908460-92-9 |

## Unimplemented Features

The current version of the tool functions as intended, however, there are additional features that were considered that have not yet been implemented:

- Automatic formatting of months in the *history* tab
- Automatic formatting of years in the *history* tab
- Stock purchase with a button click
- Stock sale with a button click

## Instructions
The Stock Tracker spreadsheet is included in releases of the project, and can be downloaded by clicking on *Releases* on the right-hand side of the project page, or directly from [stock_tracker.ods](https://github.com/johnny-b-goode/traveller/releases/latest/download/stock_tracker.ods)

When using the spreadsheet, you will need to enable macros.

The *parameters* and *stocks* tabs are not meant to be visible to players.

The *history*, *market*, and *portfolio-** tabs are meant to be visible to players, though whether or not they are is up to the GM.

The period is not really meant to represent days. The growth mechanic (even though scaled back slightly from what is in JTAS) is way to aggressive, and I do not believe the method described is intended to represent a market with that degree of granularity. Instead, the period should be thought of as representing a longer period of time. In my mind, this is at least one week, but I think two may be a bit better. The goal is not to create a simulator somebody could use to play a day trader, but more a useful narrative mechanism and potentially some passive income arising from investments.

### Parameters
The *parameters* tab includes a number of parameters you can tune to change the behavior of the tool. Most of these parameters are as described in JTAS, Vol. 3, though I did tweak the trends slightly.

> NOTE: Die rolls require the number of sides on the die be specified (ie, D6 instead of D), and only support addition and subtraction on rolls. The Key / Value pairs primarily deal with initializing the stocks, but also have a few additional parameters for potential later use, as well as to keep the stock market sane. Some of the cells have comments on them describing the behavior of those parameters.

### Stocks
The *stocks* tab is where a GM can determine what stocks are available in the market. In order to create a stock, only the *Name* and *Symbol* need to be specified. The other fields will be populated at initialization.

> NOTE: Some of the columns have comments that describe what the column represents. See these comments for additional details.

Once the stocks have been specified, click the *Initialize* button to determine whether the stock is listed, the numbers of shares of stock issued, treasury shares, and restricted shares, as well as a fluctuation rate, trend, and price. Once the stocks have been initialized the parameters for that stock may be modified. Stocks can be excluded from the market by setting the *Listed value* to "No". Note that the history of stocks removed from the market will still be visible (by design). The numbers of shares of different types can be adjusted, as can the *Fluctuation Rate*, *Trend*, and *Current Price*.

Once the GM is happy with the stocks, clicking the *Publish* button will update the *history* tab, which is in-turn referenced by the *market* tab. Updating the stocks is simply a matter of clicking the *Update* button, making any desired changes, and then clicking the *Publish* button. This allows previous market history to be created very quickly, if desired.

> NOTE: The *Trend* will fluctuate, so if you would like a particular stock to retain a specific trend, you will need to reset the desired trend after updating (simply do so before publishing).

### History
The *history* tab represents the history of the market, and is the source of truth used by the market tab. It will be almost entirely empty until stocks have been defined and prices published from the stocks tab. Note that the *history* tab is almost entirely automatically generated, and it should not be manually modified (with the possible exception of correcting potential errors). Also note that it should be very easy to generate graphs representing the price trend of a stock over time using the data in this tab.

Players may use the *history* tab to see the historical performance of a stock, or the performance of a stock they have purchased over time.

### Market
The *market* tab represents the current view of the exchange (whichever exchange that happens to be). This would be where stocks are purchased. It is spartan by design, in order to avoid drawing more focus than intended. It contains the symbol of the stock, the current price of the stock, and an indicator of the change in price since the previous period.

> NOTE: At present, the *Buy* button does not actually do anything.

### Portfolio
The *portfolio-** tab is meant to represent an individual palyer's portfolio.

It should be copied once for each player.

At present, this tab must be manually updated.

The *portfolio* tab is intended to mimic a brokerage account, and whenever stocks are purchased, the total cost of the purchase should be subtracted from the Cash Balance and added to the Total Basis Cost for that stock. If a stock is sold, the number of shares sold should be deducted from the Number of Shares for the stock sold and the proceeds from the sale added to the Cash Balance. Any transaction fees should be deducted from the proceeds of the sale before adding to the cash balance. An amount equal to the average basis cost (Total Basis Cost / Number of Shares) times the number of shares sold should also be subtracted from the Total Basis Cost, though this is not actually necessary.

The Cash Balance is not intended to be immediately accessible to the player(s) for useable cash outside of (stock) market transactions, as that would have a tendancy to turn the player's finances into something of a mess. Instead, it should function like a normal brokerage account: money has to be initially deposited into the account, and money from transactions stays in the account until withdrawn. The account / portfolio is not expected to be accessible from any point in the galaxy, but I think would be reasonably expected to be available alongside similar banking / financial services.

> NOTE: At present, the *Sell* button does not actually do anything.
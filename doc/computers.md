================================================================================
# Computers of the far Future
================================================================================
Beyond TL ?, computers are so powerful that for most intents and purposes their computational power is infinite.

For some reason whoever came up with the rules for computers seems to think that some of the simulations that the computers would be described as running are way more complicated than they are.

- distributed by design (in ships)
- redundant by design
- hardened by design (because radiation is a thing in space)
- power systems are shielded, hardened, and redundant
- ships control systems are designed for graceful failure (as any automotive computer is / would be)
- various ship's systems have their own computers. In general, everything is designed to operate independently in case it should ever need to do so.
- architectures are advanced and efficient
	- for the sake of postulation, think mature microservices, but with all the fundamental / low-level concerns (DHCP, DNS, NTP, service registry, identity management, authorization, etc.) dealt with using very efficient low-level implementations

--------------------------------------------------------------------------------
## The Processor Architecture of the Future
--------------------------------------------------------------------------------
Eventually it is realized that CISC architectures are simply inefficient, and with the merger of FPGAs into processing dies, unnecessary. A preferred architecture becomes processors based on a number of RISC cores in conjunction with a portion of the processor die allocated to an on-die FPGA. A significant advance is the FPGA being proportionally clocked with the processor core(s) at higher speeds than what is used prior to the technologies merging.

Memory fundamentally changes to simply become on-die (SRAM)

--------------------------------------------------------------------------------
## The Terrahert Transistor

A hallmark of TL ? technology. This component, particularly once miniaturized and used within processors is a fundamental leap in processing power - literally increasing processing power by 400 - 600+ fold over the typical multi-Ghz predecessor.

--------------------------------------------------------------------------------
## The Unit of Compute

The unit of compute is a standardized quantity of computing power, not an actual computer module. There are many brands and models of module, but for the standard module type they are all measured in terms of the number of times they implement the following set of specifications (meaning a single physical module can theoretically provide any number of UoC, though the most common number is one).

	1 Thz
		X RISC cores
	X FPGA
		x Hz
		x Cells
		x per RISC core
	1 TB RAM (L1)
	X L2
	X L3
	X GB? ROM
	X TB/PB/XB Storage
	X multiplexers
		x channels
		x frequency
	X ADCs
		x resolution
		x frequency
	X DACs
		x resolution
		x frequency
	X Universal Media Interfaces (UMIs)
	X Optical interconnects

primary interconnect is direct optical
analog interconnect based on ADCs/DACs

ubiquitous and cheap


Roughly the size of a pack of playing cards.

Modules used on ships are EM shielded, rad hardened, and contain their own power control / management (in other words, you are not going to EMP it).

what actually tends to take up space on a ship is storage, but even that space is trivial in comparison to almost any other concern on the ship.

Most ships will carry spare modules of whatever types it uses.

Modules are readily available on most worlds above TL ? and in most star ports. A standard 1 UoC module is around 100 Cr.


--------------------------------------------------------------------------------
## Different Types of Modules:

- Storage
- Quantum - better for running things requiring large numbers of permutations, but really only useful for certain types of problems
- Stream - (used for HPC, possibly DSP) better for modeling / calculating a jump
- Dynamic / DSP - (bigger / better FPGA at the cost of other stuff. This could / should possibly be merged with Stream) better for signal processing of sensor data. Often used with an ADC / DAC module.
- Interface (higher quality / higher speed ADCs / DACs) used for connecting to communication / sensor systems, or any other analog interface. Often used in conjunction with a Dynamic / DSP module.
- Specialized - There are many specialized modules designed for specific purposes. The most common examples being a ship's "black box" and transponder (both of which used hardware locked implementations to improve reliability and discourage tampering).

--------------------------------------------------------------------------------
## Computers on Ships

Ships include a highly redundant network fabric.

It includes numerous points of power injenction, each completely independent.
Numerous Standard UoC modules are distributed throughout the ship, in addition to the ones that are self-contained in various pieces of equipment. Additional module types will be distributed throughout the ship as needed to support the other functions required of the ship's computer.

Minimum failure tolerance rate for the built-in "computer", specifically comprising the Standard UoC modules, is 66%. Meaning a ship can remain 100% functional on only ~ 33% of it's modules. Most ships will have at least two-fold redundancy for any other module types required for the ship to function. Most ships also have additional capacity for additional distributed modules. It is not uncommon for a ship to be able to double its total number of modules within the distributed system.

A ship's bridge will also include at least one chassis ("one" actually consisting of several modules) which can accept additional modules. Most ship's bridges can accept at least 100 additional modules. Many ships contain additional chassis in other locations in the ship, often of varying sizes (common locations include captain's quarters, engineering areas, workshops dedicated to technological concerns, etc.). Most ships with multiple decks will have at least one storage array per deck.

Storage is usually replicated across at least three locations throughout the ship, though the storage arrays on the bridge are typically the primary array. Common locations for additional arrays include captain's quarters, engineering areas, workshops dedicated to technological concerns, chart rooms, libraries, "black boxes" and escape pods. Most ships with multiple decks will have at least one storage array per deck.

What this means is that a ship will generally need to be completely destroyed before its computer finally fails. Even then, most large size pieces of debris would have a functioning computer until it eventually runs out of power.

--------------------------------------------------------------------------------
## Open Source


Open source is still a thing in the future
it's still important
most critical systems are actually open source, or based on open source (the largest exception being government stuff - at least to a larger degree than most other things)

the debate around right-to-repair has been resolved
people own their electronics, and the software on them, though software licensing is still a thing

--------------------------------------------------------------------------------
## Intellectual Property

Designs tend to not be quite so well protected as they are on present day Earth
Some systems simply do not have IP protection laws. Others choose not to enforce them.
During the colonial period, and even today on lower TL / law level worlds, the value of a design to society often created a conflict of interest in enforcing restrictions on the use of the design.

The distributed nature of interstellar society makes enforcing such regulations very difficult.

Eventually, businesses and people realized that it was generally just as profitable (and once the extended market approachable through licensing is tapped, often more so), and far more practical, to license designs instead of trying to restrict the use of them.

There are still proprietary designs and trade secrets but it is not that common.

Very high TL designs (> 15) are generally difficult to find. Very often, when they are found they are incomplete, prototypical, or in other ways sub-optimal.

This does of course tend to create problems for governments that would like to restrict access to items of various types, but for the most part those problems have far more to do with making it difficult to control access to items than it does with the overall safety of society.

All that said, having a design, and having the ability to build the design, are two entirely different things.

--------------------------------------------------------------------------------
## The Core

The core is the "core" of all the data extant throughout human civilization. It includes the most useful / valuable information, and excludes "low value" data. Think
	wikipedia
	github
	thingiverse
	etc.

It includes a great deal of historical and technical information, as well as the vast majority of the scientific body of knowledge.

All ships carry a copy of the core

If all the copies of the core were combined and reconciled, that would be the complete core. The core has not existed in a complete form since before the early colonial period, and likely never will again (with the possible exception of within facilities specially built for that purpose)

--------------------------------------------------------------------------------
### A Shard

Whenever two networks become disconnected from eachother, they are said to be "sharded", each independent network being a shard of the whole.

The lack of faster-than-light communication means that each system in charted space contains it's own independent network, each acting as a shard of a larger network that has never actually been completely interconnected.

Each ship also acts as a shard as it travels between systems. Whenever the ship arrives in a system with an active network, the ship connects to that network, thereby "unsharding" the two networks. When the ship leaves the system, it will again act as a shard (indeed, it still behaves completely independently when in-system).



--------------------------------------------------------------------------------
### When to Share

This system will follow the current settings of the ship's transponder unless manually overridden.

--------------------------------------------------------------------------------
### Choosing What to Share

Ships have the ability to share or not share certain things
	A great deal of media is not shared by default, as it would be considered low-value and not worth the storage space and bandwidth that would be required to transfer it between systems. A ship may opt-in to almost any type of data though.

Ships have a built-in do-not-share list that prevents data being shared within systems that are considered "hostile" or otherwise untrustworthy.
	This is intended to prevent leaking information that could be beneficial to a potential enemy or criminal organization.

Ships have the ability to not automatically share most data.
	The one exception is financial data. It is generally agreed that the intersteller economy is sufficiently important that transactional financial data is shared under all circumstances, even in unfriendly systems.
	For most other types of data, a ship's captain may opt-out of almost any other type of data. This is actually fairly rare, as it is generally agreed that the value of data moving between systems is so significant that this would be widely regarded as detrimental to society as a whole. In addition, if a ship does not transmit data, or certain types of data, the system relays / arrays may not share data with the ship (depending on the configuration implemented by system authorities).

--------------------------------------------------------------------------------
### Data Gravity

Systems tend to accumulate data relevant to them
A system might have lots of data about a system it trades with extensively, or that share a common background but have little if any data about a distant system with which it rarely interacts.

This also has implications for procuring "illicit" or hard to find items (particularly manufactured goods).

--------------------------------------------------------------------------------
### Backing up the Core

designed to survive empire-wide extinction events (which are thought to only be possible through encountering a technologically superior hostile race)

hierarchical model
	The locations of the highest tiers of the hierarchy are highly classified. Most people who are aware of what the facilities are would not disclose the locations anyway, due to the universally percieved value of what they do.

nobody knows where all the locations are (only tiny numbers of people know where more than one are)
	most are thought to be quite remote

heavily defended - essentially massive fortress data centers

multiple locations contain copies of the same data

Avoiding corruption
	there are tiers of backup
	reconciliation of versions happens in intervals of years
	all versions are air gapped, everything is air gapped

thought to contain more than just data (things of particular value and / or importance)	
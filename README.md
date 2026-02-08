# c2t_hccs

Kolmafia script to handle a hardcore community service run with my set of skills and IotMs and with any class.

This is a continual work-in-progress. It is not likely to run out-of-the-box for most, but others may be able to glean things from it. To see what is needed to run smoothly without changes, see: https://api.aventuristo.net/av-snapshot?u=c2t

## Installation / Uninstallation

To install, run the following on the gCLI:

`git checkout https://github.com/C2Talon/c2t_hccs.git master`

To uninstall, run the following on the gCLI:

`git delete C2Talon-c2t_hccs-master`

## Migrating from SVN to GIT

First, remove the SVN repository via the gCLI:

`svn delete c2t_hccs`

Then follow the [installation section](#installation--uninstallation) above

## Usage

* The main script is `c2t_hccs.ash`, and is the thing that should be run to do a community service run
* Not likely to run out-of-the-box for most. Hoping to change this eventually
* Able to be re-run at any point in a run, hopefully after manually correcting whatever caused it to stop
* Will abort when a non-coil test does not meet its turn threshold after preparations for it are done, which defaults to 1 turn
* Workshed: either model train set or diabolic pizza cube will give the greatest chances of success. Pizza cube can save turns with buffs in exchange for fullness, while train set will make leveling and some of the early bits easier.
* Muscle classes: need to have the [prevent scurvy and sobriety](https://wiki.kingdomofloathing.com/Prevent_Scurvy_and_Sobriety) skill permed, otherwise stat tests may be difficult to pass. Can optionally pull an [oil of stability](https://wiki.kingdomofloathing.com/Oil_of_stability) if in softcore before running.
* In Valhalla:
    - Choose any class
    - Choose the corresponding "knoll" moonsign (mongoose, wallaby, or vole)
    - Optimal astral stuff is astral six-pack and astral pet sweater, though neither is strictly required
* The script uses moods `hccs-mus`, `hccs-mys`, and `hccs-mox` for leveling purposes on muscle, mysticality, and moxie classes, respectively. So set your own to what you want for what skills you have, otherwise you won't have many buffs while leveling.
    - Exception: the script will cast and handle stevedave's shanty of superiority and ur-kel's aria of annoyance, so either put them in the mood as well or leave 2 song slots open for them
    - The moods I use can be seen in [mood examples.txt](https://github.com/c2talon/c2t_hccs/blob/master/mood%20examples.txt) to use as a starting point.

## User settings and disabling resources

Most settings can be changed via a relay script. To start the relay script, find the drop-down menu that says `-run script-` at the top-right corner of the menu pane and select `c2t hccs`, as seen here:

![relay script location](https://github.com/C2Talon/c2t_hccs/blob/master/relay_script_location.png "relay script location")

Resources can be disabled with the same relay script.

## IotM

The script assumes several IotM are owned and will break without them. In addition, the [sweet synthesis](https://wiki.kingdomofloathing.com/Sweet_Synthesis) skill is very highly recommended, and the [Summon Crimbo Candy](https://wiki.kingdomofloathing.com/Summon_Crimbo_Candy) skill is required to fuel sweet synthesis. Also, the [Imitation Crab](https://wiki.kingdomofloathing.com/Imitation_Crab) familiar is required if using the pizza cube.

Some of the required IotM are only required for now because they're explicitly used in the script without any checks. Some will be moved to the supported list as I get around to adding the necessary checks. I'll be working on trying to minimize the required list, but do note one will probably still need to have a critical mass of IotM for the script to run smoothly.

### Required IotM ([ordered by release date](https://wiki.kingdomofloathing.com/Mr._Store))
* [Tome of Clip Art](https://wiki.kingdomofloathing.com/Tome_of_Clip_Art) &mdash; can be somewhat possible to get around this requirement by pulling a [borrowed time](https://wiki.kingdomofloathing.com/Borrowed_time) prior to running
* [Clan VIP Lounge invitation](https://wiki.kingdomofloathing.com/Clan_VIP_Lounge_invitation) &mdash; assumes a fully-stocked VIP lounge
* [genie bottle](https://wiki.kingdomofloathing.com/Genie_bottle) &mdash; [cursed monkey paw](http://wiki.kingdomofloathing.com/Cursed_monkey_paw) and [combat lover's locket](https://wiki.kingdomofloathing.com/Combat_lover%27s_locket) (with [Hobelf (WC)](https://wiki.kingdomofloathing.com/Hobelf_%28WC%29), [ungulith](https://wiki.kingdomofloathing.com/Ungulith), [factory worker (female)](https://wiki.kingdomofloathing.com/Factory_worker_%28female%29), &amp; [evil olive](https://wiki.kingdomofloathing.com/Evil_Olive)) can replace this
* [Neverending Party invitation envelope](https://wiki.kingdomofloathing.com/Neverending_Party_invitation_envelope)
* [latte lovers member's mug](https://wiki.kingdomofloathing.com/Latte_lovers_member%27s_mug)
* [Kramco Sausage-o-Matic&trade;](https://wiki.kingdomofloathing.com/Kramco_Sausage-o-Matic%E2%84%A2)
* [Fourth of May Cosplay Saber](https://wiki.kingdomofloathing.com/Fourth_of_May_Cosplay_Saber)
* [hewn moon-rune spoon](https://wiki.kingdomofloathing.com/Hewn_moon-rune_spoon)
* [Distant Woods Getaway Brochure](https://wiki.kingdomofloathing.com/Distant_Woods_Getaway_Brochure) or [Chateau Mantegna room key](https://wiki.kingdomofloathing.com/Chateau_Mantegna_room_key) &mdash; note: chateau support is limited only to resting there
* [Comprehensive Cartographic Compendium](https://wiki.kingdomofloathing.com/Comprehensive_Cartographic_Compendium) or [Peridot of Peril](https://wiki.kingdomofloathing.com/Peridot_of_Peril) &mdash; force encounters with needed monsters
* [emotion chip](https://wiki.kingdomofloathing.com/Emotion_chip)

### Supported IotM ([grouped by year released](https://wiki.kingdomofloathing.com/Mr._Store))

While these are not strictly required, not having enough that either save turns or significantly help with leveling may cause problems. The blurb after the em dash (&mdash;) is basically what the script uses the IotM for.

* 2010
    * [Baby Bugged Bugbear](https://wiki.kingdomofloathing.com/Baby_Bugged_Bugbear) &mdash; can potentially save a turn if lacking an astral pet sweater or better
* 2011
    * [Peppermint Pip Packet](https://wiki.kingdomofloathing.com/Peppermint_Pip_Packet) &mdash; used to get the synthesize item buff to save 10 turns on the item test; provides backup candies for other synthesis buffs
* 2016
    * [Source terminal](https://wiki.kingdomofloathing.com/Source_terminal) &mdash; saves 2 turns on item test; turns speakeasy fights into scaling fights
* 2017
    * [Asdon Martin keyfob (on ring)](https://wiki.kingdomofloathing.com/Asdon_Martin_keyfob_(on_ring)) &mdash; can saves some turns on item, hot, and combat tests; makes one fight free
    * [Kremlin's Greatest Briefcase](https://wiki.kingdomofloathing.com/Kremlin%27s_Greatest_Briefcase) &mdash; saves 5 on hot test, 3 on combat test, 1 on weapon test, 1 on spell test; backup banishes
    * [mumming trunk](https://wiki.kingdomofloathing.com/Mumming_trunk) &mdash; 2-4 stats from combat
    * [Pocket Meteor Guide](https://wiki.kingdomofloathing.com/Pocket_Meteor_Guide) &mdash; with saber saves 4 turns on familiar text, 8 on weapon test, 4 on spell test
    * [portable pantogram](https://wiki.kingdomofloathing.com/Portable_pantogram) &mdash; saves 2 turns on hot test, 3 on combat test, 0.4 on spell test
* 2018
    * [Bastille Battalion control rig](https://wiki.kingdomofloathing.com/Bastille_Battalion_control_rig) &mdash; 250 free stats; 25 mainstat buff for leveling; saves 2 turns on weapon test, 1.6 on familiar
    * [Boxing Day care package](https://wiki.kingdomofloathing.com/Boxing_Day_care_package) &mdash; free stats; 200% stat buff for leveling; saves 1.67 turns on item test for mys classes
    * [FantasyRealm membership packet](https://wiki.kingdomofloathing.com/FantasyRealm_membership_packet) &mdash; get a hat with +15 mainstat
    * [God Lobster](https://wiki.kingdomofloathing.com/God_Lobster) &mdash; 3 mid-tier scaling fights & nostalgia pi&ntilde;ata
    * [January's Garbage Tote](https://wiki.kingdomofloathing.com/January%27s_Garbage_Tote) &mdash; _doubles_ stat gain from combats
    * [Songboom&trade; BoomBox](https://wiki.kingdomofloathing.com/SongBoom%E2%84%A2_BoomBox) &mdash; extra meat from fights
    * [Voter registration form](https://wiki.kingdomofloathing.com/Voter_registration_form) &mdash; vote buffs and chance for mid-tier scaling wanderers
* 2019
    * [Beach Comb](https://wiki.kingdomofloathing.com/Comb_Box) &mdash; saves 1 turn on familiar and weapon tests, 3 on hot test, 0.5 on spell test; some minor leveling buffs
    * [diabolic pizza cube](https://wiki.kingdomofloathing.com/diabolic_pizza_cube) &mdash; provides several buffs that help leveling and contribute greatly to tests
    * [Eight Days a Week Pill Keeper](https://wiki.kingdomofloathing.com/Eight_Days_a_Week_Pill_Keeper) &mdash; buff sets familiars to level 20; 100% stat buff for leveling; can save 3 turns on hot test
    * [Lil' Doctor&trade; bag](https://wiki.kingdomofloathing.com/Lil%27_Doctor%E2%84%A2_bag) &mdash; 3 free kills and 3 free banishes
    * [Pocket Professor](https://wiki.kingdomofloathing.com/Pocket_Professor) &mdash; used to copy several scaling fights & burn delay to get other resources
    * [vampyric cloake](https://wiki.kingdomofloathing.com/Vampyric_cloake) &mdash; saves 3.3 turns on item test, 2 on hot test; 50% mus buff
* 2020
    * [box o' ghosts](https://wiki.kingdomofloathing.com/Box_o%27_ghosts) &mdash; 50% stat buff for leveling; saves 4 turns on weapon test, 2 on spell test
    * [Cargo Cultist Shorts](https://wiki.kingdomofloathing.com/Cargo_Cultist_Shorts) &mdash; saves 8 turns on weapon test or 4 turns on spell test; makes hp test trivial
    * [Left-Hand Man](https://wiki.kingdomofloathing.com/Left-Hand_Man) &mdash; equip extra offhands for tests
    * [Melodramedary](https://wiki.kingdomofloathing.com/Melodramedary) &mdash; with enough fights to fully charge: can save 4 turns on weapon test, 2 on spell test
    * [packet of mushroom spores](https://wiki.kingdomofloathing.com/Packet_of_mushroom_spores) &mdash; 1 mid-tier scaling fight
    * [Powerful Glove](https://wiki.kingdomofloathing.com/Powerful_Glove) &mdash; 200% stat buff for leveling & saves 6 turns on combat test, 1 on weapon test, 1 on spell test
    * [SpinMaster&trade; lathe](https://wiki.kingdomofloathing.com/SpinMaster%E2%84%A2_lathe) &mdash; saves 4 turns on weapon test with ebony epee
    * [unwrapped knock-off retro superhero cape](https://wiki.kingdomofloathing.com/Unwrapped_knock-off_retro_superhero_cape) &mdash; saves 3 turns on hot test; 30% mainstat for leveling
* 2021
    * [backup camera](https://wiki.kingdomofloathing.com/Backup_camera) &mdash; used for 11 scaling fights & burning delay to get other resources
    * [cold medicine cabinet](https://wiki.kingdomofloathing.com/Cold_medicine_cabinet) &mdash; drinks a 30% stat booze from this for initial adventures and leveling help post-coil test
    * [familiar scrapbook](https://wiki.kingdomofloathing.com/Familiar_scrapbook) &mdash; equip before using ten-percent bonus
    * [industrial fire extinguisher](https://wiki.kingdomofloathing.com/Industrial_fire_extinguisher) &mdash; 30 turns saved on hot test with saber and 3 more turns by itself
    * [power seed](https://wiki.kingdomofloathing.com/Power_seed) &mdash; saves 6.7 turns on item test
    * [Shorter-Order Cook](https://wiki.kingdomofloathing.com/Shorter-Order_Cook) &mdash; can save 2 turns on familiar test if lucky
    * [Our Daily Candles&trade; order form](https://wiki.kingdomofloathing.com/Our_Daily_Candles%E2%84%A2_order_form) &mdash; class-dependent chance of 50% stat buff and/or 10 stats from combat
* 2022
    * [autumn-aton](https://wiki.kingdomofloathing.com/Autumn-aton) &mdash; saves 1.67 turns on item test; will get useful upgrades to prepare for aftercore
    * [combat lover's locket](https://wiki.kingdomofloathing.com/Combat_lover%27s_locket) &mdash; up to 3 monsters to fight to save wishes and time spent on fax
    * [cosmic bowling ball](https://wiki.kingdomofloathing.com/Cosmic_bowling_ball) &mdash; 50% stat gain in NEP; saves 1.67 adventures on item test; some extra item and meat gain during leveling fights
    * [deed to Oliver's Place](https://wiki.kingdomofloathing.com/Deed_to_Oliver%27s_Place) &mdash; 3 non-scaling free fights
    * [designer sweatpants](https://wiki.kingdomofloathing.com/Designer_sweatpants) &mdash; script will prioritize equipping this to get the most out of it, including saving turns on the hot test
    * [June cleaver](https://wiki.kingdomofloathing.com/June_cleaver) &mdash; will choose optimal choices when the cleaver adventures are encountered
    * [Jurassic Parka](https://wiki.kingdomofloathing.com/Jurassic_Parka) &mdash; helps get NEP experience buff right away and gives 1 free kill
    * [MayDay&trade; contract](https://wiki.kingdomofloathing.com/MayDay%E2%84%A2_contract) &mdash; can save up to 1.7 turns on item test on some classes
    * [model train set](https://wiki.kingdomofloathing.com/Model_train_set) &mdash; lots of extra stats from fights and can smooth out any meat problems
    * [Unbreakable Umbrella](https://wiki.kingdomofloathing.com/Unbreakable_Umbrella) &mdash; saves up to 1.7 turns on item test, 6 on combat test, 1 on weapon test, 0.5 on spell test
    * [tiny stillsuit](https://wiki.kingdomofloathing.com/Tiny_stillsuit) &mdash; if this is not equipped while adventuring, it will be placed on a familiar in the terrarium to passively build up
* 2023
    * [book of facts](https://wiki.kingdomofloathing.com/Book_of_facts) &mdash; Recall Facts: Circadian Rhythms used to get more rollover adventures
    * [Cincho de Mayo](https://wiki.kingdomofloathing.com/Cincho_de_Mayo) &mdash; helps get NEP experience buff right away
    * [closed-circuit pay phone](http://wiki.kingdomofloathing.com/Closed-circuit_pay_phone) &mdash; 11 or 12 extra free fights; can save 3.3 turns on item test
    * [cursed monkey paw](http://wiki.kingdomofloathing.com/Cursed_monkey_paw) &mdash; will get effects from this before using genie wishes
* 2024
    * [Apriling band helmet](https://wiki.kingdomofloathing.com/Apriling_band_helmet) &mdash; uses the intrinsics to help with item and non-combat tests
    * [bat wings](https://wiki.kingdomofloathing.com/Bat_wings) &mdash; MP recovery
    * [Everfull Dart Holster](https://wiki.kingdomofloathing.com/Everfull_Dart_Holster) &mdash; tries to use its free kill whilst leveling; throws darts to level it up if it is equipped otherwise
    * [Mayam Calendar](https://wiki.kingdomofloathing.com/Mayam_Calendar) &mdash; gets adventures post-coil if low
    * [tearaway pants](https://wiki.kingdomofloathing.com/Tearaway_pants) &mdash; if moxie, used to unlock guild, unlock distant woods, and fight tentacle in science tent
* 2025
    * [Allied Radio Backpack](https://wiki.kingdomofloathing.com/Allied_Radio_Backpack) &mdash; can save 4 turns on item test, 1 on familiar test, 1 on spell test, 3 on hot test
    * [April Shower Thoughts shield](https://wiki.kingdomofloathing.com/April_Shower_Thoughts_shield) &mdash; can save 1.6 turns on familiar test
    * [blood cubic zirconia](https://wiki.kingdomofloathing.com/Blood_cubic_zirconia) &mdash; can save 4 turns on weapon test, 2.1 on spell test
    * [M%C3%B6bius ring](https://wiki.kingdomofloathing.com/M%C3%B6bius_ring) &mdash; can save 3 turns on non-combat test if the maximizer so happens to equip it while leveling, but the script does not explicitly try to do that
    * [Peridot of Peril](https://wiki.kingdomofloathing.com/Peridot_of_Peril) &mdash; force combats with needed monsters
    * [prismatic beret](https://wiki.kingdomofloathing.com/Prismatic_beret) &mdash; saves a bunch of turns on the spell test; turns saved can vary wildly based on gear on hand
* 2026
    * [The Eternity Codpiece](https://wiki.kingdomofloathing.com/The_Eternity_Codpiece) &mdash; handles peridot, zirconia, and heartstone IotMs; fill it with 5 [eye of the Tiger-lily](https://wiki.kingdomofloathing.com/Eye_of_the_Tiger-lily) pre-ascension to save a turn on spell test
    * [heartstone](https://wiki.kingdomofloathing.com/Heartstone) &mdash; buffs for leveling; saves 1 turn on familiar test, saves an additional turn on familiar test with The Eternity Codpiece

## Bugs?
Report bugs in the [issue tracker](https://github.com/C2Talon/c2t_hccs/issues).

## TODO (eventually)

* Genericise things to not assume whoever runs this has everything I do
* Better handling when overcapping a test, i.e. only use as much resources as needed and not more
* Purge cruft from changes done over time
* Add more IotMs and such as I get them


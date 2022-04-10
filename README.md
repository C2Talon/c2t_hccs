# c2t_hccs

Kolmafia script to handle a hardcore community service run with my set of skills and IotMs and with any class.

This is a continual work-in-progress. It is not likely to run out-of-the-box for most, but others may be able to glean things from it. To see what is needed to run smoothly without changes, see: https://cheesellc.com/kol/profile.php?u=Zdrvst

Bugs? Report them here: https://github.com/C2Talon/c2t_hccs/issues

## Installation / Uninstallation

To install, run the following on the gCLI:

`svn checkout https://github.com/c2talon/c2t_hccs/branches/master/kolmafia/`

To uninstall, run the following on the gCLI:

`svn delete c2t_hccs`

## Usage

* The main script is `c2t_hccs.ash`, and is the thing that should be run to do a community service run
* Not likely to run out-of-the-box for most. Hoping to change this eventually
* Able to be re-run at any point in a run, hopefully after manually correcting whatever caused it to stop
* Will abort when a non-coil test does not meet its turn threshold after preparations for it are done, which defaults to 1 turn
* Pre-Valhalla: put diabolic pizza cube in the workshed. Pizza cube can be optional _if_ you have most of the IotM in the lists below
* In Valhalla:
    - Choose any class
    - Choose the corresponding "knoll" moonsign
    - Optimal astral stuff is astral six-pack and astral pet sweater, though neither is strictly required
* The script uses moods `hccs-mus`, `hccs-mys`, and `hccs-mox` for leveling purposes on muscle, mysticality, and moxie classes, respectively. So set your own to what you want for what skills you have, otherwise you won't have many buffs while levelling.
    - Exception: the script will cast and handle stevedave's shanty of superiority and ur-kel's aria of annoyance, so either put them in the mood as well or leave 2 song slots open for them
    - The moods I use can be seen in [mood examples.txt](https://github.com/c2talon/c2t_hccs/blob/master/mood%20examples.txt) to use as a starting point.

## User-defined properties the script uses

These are set via the gCLI. Basically so people don't have to edit the script itself to change some simple, but critical, things.

`set c2t_hccs_haltBeforeTest = false`
* Setting this to `true` will cause the script to always halt after prepping for a test, but before doing the test.
* Defaults to `false`

`set c2t_hccs_printModtrace = false`
* Setting this to `true` will cause the script to print the modtrace for the corresponding mods that the test uses before doing the test.
* Defaults to `false`

`set c2t_hccs_joinClan = 90485`
* This is the clan that the script will join for the VIP lounge and fortune teller
* Takes an `int` or `string`, where `int` would be clanid (preferred), and `string` would be the clan name
* Defaults to `90485` (Bonus Adventures From Hell)

`set c2t_hccs_clanFortunes = CheeseFax`
* This is the name of the person/bot that you want to do the fortune teller with
* Defaults to `CheeseFax`

`set c2t_hccs_skipFinalService = false`
* If this is set to `true`, the final service will be skipped leaving you in-run once finished
* Defaults to `false`

`set c2t_hccs_thresholds = 1,1,1,1,1,1,1,1,1,1`
* These are the 10 thresholds corresponding to the minimum turns to allow each test to take
* The script will stop just before doing a test if a threshold is not met after doing all the pre-test stuff
* The order is hp,mus,mys,mox,fam,weapon,spell,nc,item,hot
* Example: `1,1,1,1,35,1,31,1,1,1` will allow the familiar test to take 35 turns, the spell test to take 31 turns, and all others must be 1 turn
* Defaults to `1,1,1,1,1,1,1,1,1,1`

### Disabling resources

Some resources can be disabled via a property. It's an all-or-nothing thing, which is somewhat detailed in [c2t_hccs_properties.ash](https://github.com/C2Talon/c2t_hccs/blob/master/kolmafia/scripts/c2t_hccs/c2t_hccs_properties.ash#L65)

## IotM

The script assumes several IotM are owned and will break without them. In addition, the [sweet synthesis](https://kol.coldfront.net/thekolwiki/index.php/Sweet_Synthesis) and [Summon Crimbo Candy](https://kol.coldfront.net/thekolwiki/index.php/Summon_Crimbo_Candy) skills, as well as the [Imitation Crab](https://kol.coldfront.net/thekolwiki/index.php/Imitation_Crab) familiar, are currently required.

Some of the required IotM are only required for now because they're explicitly used in the script without any checks. Some will be moved to the supported list as I get around to adding the necessary checks. I'll be working on trying to minimize the required list, but do note one will probably still need to have a critical mass of IotM for the script to run smoothly.

### Required IotM (ordered by release date)
* [Tome of Clip Art](https://kol.coldfront.net/thekolwiki/index.php/Tome_of_Clip_Art)
* [Clan VIP Lounge invitation](https://kol.coldfront.net/thekolwiki/index.php/Clan_VIP_Lounge_invitation) &mdash; assumes a fully-stocked VIP lounge
* [corked genie bottle](https://kol.coldfront.net/thekolwiki/index.php/Corked_genie_bottle)
* [January's Garbge Tote (unopened)](https://kol.coldfront.net/thekolwiki/index.php/January%27s_Garbage_Tote_(unopened))
* [Neverending Party invitation envelope](https://kol.coldfront.net/thekolwiki/index.php/Neverending_Party_invitation_envelope)
* [Latte lovers club card](https://kol.coldfront.net/thekolwiki/index.php/Latte_lovers_club_card)
* [Kramco Industries packing carton](https://kol.coldfront.net/thekolwiki/index.php/Kramco_Industries_packing_carton)
* [Fourth of May Cosplay Saber kit](https://kol.coldfront.net/thekolwiki/index.php/Fourth_of_May_Cosplay_Saber_Kit)
* [rune-strewn spoon cocoon](https://kol.coldfront.net/thekolwiki/index.php/Rune-strewn_spoon_cocoon)
* [Distant Woods Getaway Brochure](https://kol.coldfront.net/thekolwiki/index.php/Distant_Woods_Getaway_Brochure)
* [packaged Pocket Professor](https://kol.coldfront.net/thekolwiki/index.php/Packaged_Pocket_Professor)
* [baby camelCalf](https://kol.coldfront.net/thekolwiki/index.php/Baby_camelCalf)
* [Comprehensive Cartographic Compendium](https://kol.coldfront.net/thekolwiki/index.php/Comprehensive_Cartographic_Compendium)
* [emotion chip](https://kol.coldfront.net/thekolwiki/index.php/Emotion_chip)
* [packaged backup camera](https://kol.coldfront.net/thekolwiki/index.php/Packaged_backup_camera)

### Supported IotM (ordered by release date)

While these are not strictly required, not having enough that either save turns or significantly help with leveling may cause problems. The blurb after the em dash (&mdash;) is basically what the script uses the IotM for.

* [Mint Salton Pepper's Peppermint Seed Catalog](https://kol.coldfront.net/thekolwiki/index.php/Mint_Salton_Pepper%27s_Peppermint_Seed_Catalog) &mdash; used to get the synthesize item buff to save 10 turns on the item test; provides backup candies for other synthesis buffs
* [Suspicious Package](https://kol.coldfront.net/thekolwiki/index.php/Suspicious_package) &mdash; saves 5 on hot test, 3 on combat test, 1 on weapon test, 1 on spell test; backup banishes
* [Pocket Meteor Guide](https://kol.coldfront.net/thekolwiki/index.php/Pocket_Meteor_Guide) &mdash; with saber saves 4 turns on familiar text, 8 on weapon test, 4 on spell test
* [pantogram](https://kol.coldfront.net/thekolwiki/index.php/Pantogram) &mdash; saves 2 turns on hot test, 3 on combat test, 0.4 on spell test
* [locked mumming trunk](https://kol.coldfront.net/thekolwiki/index.php/Locked_mumming_trunk) &mdash; 2-4 stats from combat
* [FantasyRealm membership packet](https://kol.coldfront.net/thekolwiki/index.php/FantasyRealm_membership_packet) &mdash; get a hat with +15 mainstat
* [God Lobster Egg](https://kol.coldfront.net/thekolwiki/index.php/God_Lobster_Egg) &mdash; 3 mid-tier scaling fights & nostalgia pi&ntilde;ata
* [Songboom&trade; BoomBox Box](https://kol.coldfront.net/thekolwiki/index.php/SongBoom%E2%84%A2_BoomBox_Box) &mdash; extra meat from fights
* [Bastille Battalion control rig crate](https://kol.coldfront.net/thekolwiki/index.php/Bastille_Battalion_control_rig_crate) &mdash; 250 free stats; 25 mainstat buff for leveling; saves 2 turns on weapon test, 1.6 on familiar
* [Voter registration form](https://kol.coldfront.net/thekolwiki/index.php/Voter_registration_form) &mdash; vote buffs and chance for mid-tier scaling wanderers
* [Boxing Day care package](https://kol.coldfront.net/thekolwiki/index.php/Boxing_Day_care_package) &mdash; free stats; 200% stat buff for leveling; saves 1.67 turns on item test for mys classes
* [Mint condition Lil' Doctor&trade; bag](https://kol.coldfront.net/thekolwiki/index.php/Mint_condition_Lil%27_Doctor%E2%84%A2_bag) &mdash; 3 free kills and 3 free banishes
* [vampyric cloake pattern](https://kol.coldfront.net/thekolwiki/index.php/Vampyric_cloake_pattern) &mdash; saves 3.3 turns on item test, 2 on hot test; 50% mus buff
* [Beach Comb Box](https://kol.coldfront.net/thekolwiki/index.php/Beach_Comb_Box) &mdash; saves 1 turn on familiar and weapon tests, 3 on hot test, 0.5 on spell test; some minor levelling buffs
* [Unopened Eight Days a Week Pill Keeper](https://kol.coldfront.net/thekolwiki/index.php/Unopened_Eight_Days_a_Week_Pill_Keeper) &mdash; buff sets familiars to level 20; 100% stat buff for levelling; can save 3 turns on hot test
* [unopened diabolic pizza cube box](https://kol.coldfront.net/thekolwiki/index.php/Unopened_diabolic_pizza_cube_box) &mdash; provides several buffs that help leveling and contribute greatly to tests; I don't suggest running without this unless you basically have everything on both lists
* [mint-in-box Powerful Glove](https://kol.coldfront.net/thekolwiki/index.php/Mint-in-box_Powerful_Glove) &mdash; 200% stat buff for leveling & saves 6 turns on combat test, 1 on weapon test, 1 on spell test
* [Better Shrooms and Gardens catalog](https://kol.coldfront.net/thekolwiki/index.php/Better_Shrooms_and_Gardens_catalog) &mdash; 1 mid-tier scaling fight
* [sinistral homunculus](https://kol.coldfront.net/thekolwiki/index.php/Sinistral_homunculus) &mdash; equip extra offhands for tests
* [packaged SpinMaster&trade; lathe](https://kol.coldfront.net/thekolwiki/index.php/Packaged_SpinMaster%E2%84%A2_lathe) &mdash; saves 4 turns on weapon test with ebony epee
* [Bagged Cargo Cultist Shorts](https://kol.coldfront.net/thekolwiki/index.php/Bagged_Cargo_Cultist_Shorts) &mdash; saves 8 turns on weapon test or 4 turns on spell test; makes hp test trivial
* [packaged knock-off retro superhero cape](https://kol.coldfront.net/thekolwiki/index.php/Packaged_knock-off_retro_superhero_cape) &mdash; saves 3 turns on hot test; 30% mainstat for leveling
* [box o' ghosts](https://kol.coldfront.net/thekolwiki/index.php/Box_o%27_ghosts) &mdash; 50% stat buff for leveling; saves 4 turns on weapon test, 2 on spell test
* [power seed](https://kol.coldfront.net/thekolwiki/index.php/Power_seed) &mdash; saves 6.7 turns on item test
* [shortest-order cook](https://kol.coldfront.net/thekolwiki/index.php/Shortest-order_cook) &mdash; can save 2 turns on familiar test if lucky
* [packaged familiar scrapbook](https://kol.coldfront.net/thekolwiki/index.php/Packaged_familiar_scrapbook) &mdash; equip before using ten-percent bonus
* [Our Daily Candles&trade; order form](https://kol.coldfront.net/thekolwiki/index.php/Our_Daily_Candles%E2%84%A2_order_form) &mdash; class-dependent chance of 50% stat buff and/or 10 stats from combat
* [packaged industrial fire extinguisher](https://kol.coldfront.net/thekolwiki/index.php/Packaged_industrial_fire_extinguisher) &mdash; 30 turns saved on hot test with saber and 3 more turns by itself
* [packaged cold medicine cabinet](https://kol.coldfront.net/thekolwiki/index.php/Packaged_cold_medicine_cabinet) &mdash; drinks a 30% stat booze from this for initial adventures and leveling help post-coil test
* [undrilled cosmic bowling ball](https://kol.coldfront.net/thekolwiki/index.php/Undrilled_cosmic_bowling_ball) &mdash; 50% stat gain in NEP; saves 1.67 adventures on item test; some extra item and meat gain during leveling fights
* [combat lover's locket lockbox](https://kol.coldfront.net/thekolwiki/index.php/Combat_lover%27s_locket_lockbox) &mdash; up to 3 monsters to fight to save wishes and time spent on fax
* [Undamaged Unbreakable Umbrella](https://kol.coldfront.net/thekolwiki/index.php/Undamaged_Unbreakable_Umbrella) &mash; saves up to 1.7 turns on item test, 6 on combat test, 1 on weapon test, 0.5 on spell test

## TODO (eventually)

* Genericise things to not assume whoever runs this has everything I do
* Better handling when overcapping a test, i.e. only use as much resources as needed and not more
* Purge cruft from changes done over time
* Add more IotMs and such as I get them


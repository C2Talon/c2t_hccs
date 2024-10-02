//c2t hccs
//c2t

since r28072;//bat wings

import <c2t_hccs_constants.ash>
import <c2t_hccs_properties.ash>
import <c2t_hccs_lib.ash>
import <c2t_hccs_resources.ash>
import <c2t_hccs_aux.ash>
import <c2t_hccs_preAdv.ash>
import <c2t_lib.ash>
import <c2t_cast.ash>
import <c2t_apriling.ash>
import <c2t_mayam.ash>

int START_TIME = now_to_int();


void c2t_hccs_init();
void c2t_hccs_exit();
boolean c2t_hccs_preCoil();
boolean c2t_hccs_buffExp();
boolean c2t_hccs_levelup();
boolean c2t_hccs_allTheBuffs();
boolean c2t_hccs_lovePotion(boolean useit);
boolean c2t_hccs_lovePotion(boolean useit,boolean dumpit);
boolean c2t_hccs_preHp();
boolean c2t_hccs_preMus();
boolean c2t_hccs_preMys();
boolean c2t_hccs_preMox();
boolean c2t_hccs_preItem();
boolean c2t_hccs_preHotRes();
boolean c2t_hccs_preFamiliar();
boolean c2t_hccs_preNoncombat();
boolean c2t_hccs_preSpell();
boolean c2t_hccs_preWeapon();
void c2t_hccs_testHandler(int test);
void c2t_hccs_fights();
boolean c2t_hccs_wandererFight();
void c2t_hccs_mod2log(string str);
void c2t_hccs_printRunTime(boolean final);
void c2t_hccs_printRunTime() c2t_hccs_printRunTime(false);
boolean c2t_hccs_fightGodLobster();
void c2t_hccs_breakfast();
familiar c2t_hccs_levelingFamiliar(boolean safeOnly);
void c2t_hccs_shadowRiftFights();
void c2t_hccs_shadowRiftBoss();
void c2t_hccs_freeRestCheck();
boolean c2t_hccs_unlockGuildMoxie();
boolean c2t_hccs_unlockDistantWoods();


void main() {
	c2t_assert(my_path() == $path[community service],"Not in Community Service. Aborting.");
	c2t_hccs_freeRestCheck();

	try {
		c2t_hccs_init();
		
		c2t_hccs_testHandler(TEST_COIL_WIRE);

		//TODO maybe reorder stat tests based on hardest to achieve for a given class or mainstat
		c2t_hccs_printInfo('Checking test ' + TEST_MOX + ': ' + TEST_NAME[TEST_MOX]);
		if (!get_property('csServicesPerformed').contains_text(TEST_NAME[TEST_MOX])) {
			c2t_hccs_levelup();
			c2t_hccs_lovePotion(true);
			c2t_hccs_fights();
			c2t_hccs_testHandler(TEST_MOX);
		}
		
		c2t_hccs_testHandler(TEST_MYS);
		c2t_hccs_testHandler(TEST_MUS);
		c2t_hccs_testhandler(TEST_HP);

		//best time to open guild as SC if need be, or fish for wanderers, so warn and abort if < 93% spit
		if (c2t_hccs_melodramedary() && get_property('camelSpit').to_int() < 93 && !get_property("_c2t_hccs_earlySpitWarn").to_boolean())
			c2t_hccs_printWarn('Camel spit only at '+get_property('camelSpit')+'%');
		set_property("_c2t_hccs_earlySpitWarn","true");

		c2t_hccs_testHandler(TEST_ITEM);
		c2t_hccs_testHandler(TEST_FAMILIAR);
		c2t_hccs_testHandler(TEST_HOT_RES);
		c2t_hccs_testHandler(TEST_NONCOMBAT);
		c2t_hccs_testHandler(TEST_WEAPON);
		c2t_hccs_testHandler(TEST_SPELL);
	}
	finally
		c2t_hccs_exit();

	//final service after cleanup
	if (get_property("csServicesPerformed").split_string(",").count() == 11
		&& !get_property('c2t_hccs_skipFinalService').to_boolean())
	{
		c2t_hccs_doTest(TEST_FINAL);
	}
}


void c2t_hccs_printRunTime(boolean f) {
	int t = now_to_int() - START_TIME;
	c2t_hccs_printInfo(`c2t_hccs {f?"took":"has taken"} {c2t_hccs_plural(t/60000,"minute","minutes")} {(t%60000)/1000.0} seconds to execute{f?"":" so far"}.`);
}

void c2t_hccs_mod2log(string str) {
	if (get_property("c2t_hccs_printModtrace").to_boolean())
		logprint(cli_execute_output(str));
}

//limited breakfast to only what might be used
void c2t_hccs_breakfast() {
	//needed for potion crafting
	if (get_property("reagentSummons").to_int() == 0)
		c2t_hccs_haveUse(1,$skill[advanced saucecrafting]);

	//crimbo candy
	if (c2t_hccs_sweetSynthesis() && get_property("_candySummons").to_int() == 0)
		c2t_hccs_haveUse(1,$skill[summon crimbo candy]);

	//limes
	if (my_primestat() == $stat[muscle] && !get_property("_preventScurvy").to_boolean())
		c2t_hccs_haveUse(1,$skill[prevent scurvy and sobriety]);

	//mys classes want the D
	if (my_primestat() == $stat[mysticality] && get_property("noodleSummons").to_int() == 0)
		c2t_hccs_haveUse(1,$skill[pastamastery]);

	//mox class stat boost for leveling
	if (my_primestat() == $stat[moxie] && !get_property("_rhinestonesAcquired").to_boolean())
		c2t_hccs_haveUse(1,$skill[acquire rhinestones]);

	//peppermint garden
	if (c2t_hccs_gardenPeppermint())
		cli_execute("garden pick");
}

boolean c2t_hccs_fightGodLobster() {
	if (!have_familiar($familiar[god lobster]))
		return false;
	if (get_property('_godLobsterFights').to_int() >= 3)
		return false;

	use_familiar($familiar[god lobster]);
	maximize(`-tie,mainstat,-equip {c2t_pilcrow($item[makeshift garbage shirt])},100 bonus {c2t_pilcrow($item[designer sweatpants])}`,false);

	// fight and get equipment
	item temp = c2t_priority($items[god lobster's ring,god lobster's scepter,astral pet sweater]);
	if (temp != $item[none])
		equip($slot[familiar],temp);

	//combat & choice
	c2t_hccs_preAdv();
	visit_url('main.php?fightgodlobster=1');
	run_turn();
	if (choice_follows_fight())
		run_choice(-1);

	//should have gotten runproof mascara as moxie from globster
	if (my_primestat() == $stat[moxie])
		c2t_hccs_getEffect($effect[unrunnable face]);

	return true;
}

void c2t_hccs_testHandler(int test) {
	c2t_hccs_printInfo('Checking test ' + test + ': ' + TEST_NAME[test]);
	if (get_property('csServicesPerformed').contains_text(TEST_NAME[test]))
		return;

	string type;
	int turns,before,expected;
	boolean met = false;

	//wanderer fights before prepping stuff
	while (my_turncount() >= 60 && c2t_hccs_wandererFight());

	//combat familiars will slaughter everything; so make sure they're inactive at the start of test sections, since not every combat bothers with familiar checks
	c2t_hccs_levelingFamiliar(true);

	c2t_hccs_printInfo('Running pre-'+TEST_NAME[test]+' stuff...');
	switch (test) {
		case TEST_HP:
			met = c2t_hccs_preHp();
			type = "HP";
			break;
		case TEST_MUS:
			met = c2t_hccs_preMus();
			type = "mus";
			break;
		case TEST_MYS:
			met = c2t_hccs_preMys();
			type = "mys";
			break;
		case TEST_MOX:
			met = c2t_hccs_preMox();
			type = "mox";
			break;
		case TEST_FAMILIAR:
			met = c2t_hccs_preFamiliar();
			type = "familiar";
			c2t_hccs_mod2log("modtrace familiar weight");
			break;
		case TEST_WEAPON:
			met = c2t_hccs_preWeapon();
			type = "weapon";
			c2t_hccs_mod2log("modtrace weapon damage");
			break;
		case TEST_SPELL:
			met = c2t_hccs_preSpell();
			type = "spell";
			c2t_hccs_mod2log("modtrace spell damage");
			break;
		case TEST_NONCOMBAT:
			met = c2t_hccs_preNoncombat();
			type = "noncombat";
			c2t_hccs_mod2log("modtrace combat rate");
			break;
		case TEST_ITEM:
			met = c2t_hccs_preItem();
			type = "item";
			c2t_hccs_mod2log("modtrace item drop;modtrace booze drop");
			break;
		case TEST_HOT_RES:
			met = c2t_hccs_preHotRes();
			type = "hot resist";
			c2t_hccs_mod2log("modtrace hot resistance");
			break;
		case TEST_COIL_WIRE:
			met = c2t_hccs_preCoil();
			break;
		default:
			abort('Something went horribly wrong with the test handler');
	}
	if (get_property("c2t_hccs_haltBeforeTest").to_boolean())
		abort(`Halting. Double-check test {test}: {TEST_NAME[test]} ({type})`);

	expected = turns = c2t_hccs_testTurns(test);
	if (turns < 1) {
		if (test > 4) //ignore over-capping stat tests
			c2t_hccs_printInfo(`Notice: over-capping the {type} test by {c2t_hccs_plural(1-turns,"turn","turns")} worth of resources.`);
		turns = 1;
	}

	if (!met)
		abort(`Pre-{TEST_NAME[test]} ({type}) test fail. Currently only can complete the test in {c2t_hccs_plural(turns,"turn","turns")}.`);

	if (test != TEST_COIL_WIRE)
		print(`Test {test}: {TEST_NAME[test]} ({type}) is at or below the threshold at {c2t_hccs_plural(turns,"turn","turns")}. Running the task...`);
	else
		print("Running the coiling wire task for 60 turns...");

	//do the test and verify after
	before = my_turncount();
	c2t_hccs_doTest(test);
	if (my_turncount() - before > turns)
		print("Notice: the task took more turns than expected, but still below the threshold, so continuing.");

	//record data for post-run:
	c2t_hccs_testData(type,test,my_turncount() - before,expected);

	c2t_hccs_printRunTime();
}

void c2t_hccs_freeRestCheck() {
	//common enough issue to warrant
	string chateau = "chateauAvailable";
	string getaway = "getawayCampsiteUnlocked";
	string wChateau = "restUsingChateau";
	string wGetaway = "restUsingCampAwayTent";
	string warnRest = "_c2t_hccs_warnRest";

	if (get_property(getaway).to_boolean()
		|| get_property(chateau).to_boolean()
		|| get_property(warnRest).to_boolean())
	{
		return;
	}

	c2t_hccs_printInfo("Free rest option not found. Trying to find one...");
	visit_url("place.php?whichplace=campaway",false);
	visit_url("place.php?whichplace=chateau",false);

	if (get_property(chateau).to_boolean())
		set_property(wChateau,true);
	else if (get_property(getaway).to_boolean())
		set_property(wGetaway,true);
	else {
		set_property(warnRest,true);
		c2t_hccs_printWarn("Warning: Couldn't find a good free rest option.");
		c2t_hccs_printWarn("The script can be run again and will bypass this check.");
		c2t_hccs_printWarn("However, the script will have a lot of trouble with MP without good free rests.");
		abort("No good free rest source");
	}

	c2t_hccs_printInfo("Free rest option found and set");
}

//sets and backup some settings on start
void c2t_hccs_init() {
	string [string] prefs = {
		//buy from NPCs
		"autoSatisfyWithNPCs":"true",
		"autoSatisfyWithCoinmasters":"true",
		"requireBoxServants":"false",
		//automation scripts
		"choiceAdventureScript":"c2t_hccs_choices.ash",
		"betweenBattleScript":"c2t_hccs_preAdv.ash",
		"afterAdventureScript":"c2t_hccs_postAdv.ash",
		"recoveryScript":"c2t_hccs_recovery.ash",
		//recovery
		"hpAutoRecoveryItems":"cannelloni cocoon;tongue of the walrus;disco nap",
		"hpAutoRecovery":"0.9",
		"hpAutoRecoveryTarget":"0.95",
		"mpAutoRecoveryItems":"",
		"manaBurningThreshold":"-0.05",
		//combat
		//"battleAction":"custom combat script",
		//"customCombatScript":"c2t_hccs"
	};

	//only save pre-coil states of these
	if (get_property("csServicesPerformed") == "") {
		//clan
		if (get_clan_id() != get_property('c2t_hccs_joinClan').to_int())
			set_property('_saved_joinClan',get_clan_id());
		//custom combat script
		if (get_property('battleAction') != "custom combat script")
			set_property('_saved_battleAction',get_property('battleAction'));
		if (get_property('customCombatScript') != "c2t_hccs")
			set_property('_saved_customCombatScript',get_property('customCombatScript'));
	}
	set_property('battleAction',"custom combat script");
	set_property('customCombatScript',"c2t_hccs");

	//backup user settings and set script settings
	foreach key,val in prefs {
		set_property(`_saved_{key}`,get_property(key));
		set_property(key,val);
	}

	visit_url('council.php');// Initialize council.
}

//restore settings on exit
void c2t_hccs_exit() {
	boolean [string] prefs = $strings[
		autoSatisfyWithNPCs,
		autoSatisfyWithCoinmasters,
		requireBoxServants,
		choiceAdventureScript,
		betweenBattleScript,
		afterAdventureScript,
		recoveryScript,
		hpAutoRecoveryItems,
		hpAutoRecovery,
		hpAutoRecoveryTarget,
		mpAutoRecoveryItems,
		manaBurningThreshold
	];
	//restore user settings
	foreach key in prefs
		set_property(key,get_property(`_saved_{key}`));

	//don't want CS moods running during manual intervention or when fully finished
	cli_execute('mood apathetic');

	//restore some things only when all tests are done
	if (get_property("csServicesPerformed").split_string(",").count() == 11) {
		if (property_exists('_saved_battleAction'))
			set_property('battleAction',get_property('_saved_battleAction'));
		if (property_exists('_saved_customCombatScript'))
			set_property('customCombatScript',get_property('_saved_customCombatScript'));
		if (property_exists("_saved_joinClan"))
			c2t_joinClan(get_property("_saved_joinClan").to_int());
		c2t_hccs_printTestData();
		if (get_property("_c2t_hccs_failSpit").to_boolean())
			c2t_hccs_printInfo(`Info: camel was not fully charged when it was needed; charge is at {get_property("camelSpit")}%`);
	}
	if (get_property("shockingLickCharges").to_int() > 0)
		c2t_hccs_printInfo(`Info: shocking lick charge count from batteries is {get_property("shockingLickCharges")}`);

	c2t_hccs_printRunTime(true);
}

boolean c2t_hccs_preCoil() {
	//numberology first thing to get adventures
	c2t_hccs_useNumberology();

	//install workshed
	item workshed = get_property("c2t_hccs_workshed").to_item();
	if (workshed != $item[none]
		&& get_workshed() == $item[none])
	{
		use(workshed);
	}

	//initial apriling band helmet intrinsic
	c2t_apriling($effect[apriling band celebration bop]);

	//get rakes
	if (get_campground() contains $item[a guide to burning leaves]
		&& available_amount($item[rake]) == 0)
	{
		visit_url("campground.php?preaction=leaves",false);
	}

	//get a grain of sand for pizza if muscle class
	if (c2t_hccs_havePizzaCube()
		&& available_amount($item[beach comb]) > 0
		&& my_primestat() == $stat[muscle]
		&& available_amount($item[grain of sand]) == 0
		&& available_amount($item[gnollish autoplunger]) == 0)
	{
		c2t_hccs_printInfo("Getting grain of sand from the beach");
		while (get_property('_freeBeachWalksUsed').to_int() < 5
			&& available_amount($item[grain of sand]) == 0)
		{
			//arbitrary location
			cli_execute('beach wander 8;beach comb 8 8');
		}
		cli_execute('beach exit');
		c2t_assert(available_amount($item[grain of sand]) > 0,"Did not obtain a grain of sand for pizza on muscle class.");
	}

	//vote
	c2t_hccs_vote();

	//source terminal
	c2t_hccs_sourceTerminalInit();

	//SIT
	if (available_amount($item[s.i.t. course completion certificate]) > 0
		&& !get_property("_sitCourseCompleted").to_boolean())
	{
		use($item[s.i.t. course completion certificate]);
	}

	//probably should make a property handler, because this looks like it may get unwieldly
	if (get_property('_clanFortuneConsultUses').to_int() < 3) {
		c2t_hccs_joinClan(get_property("c2t_hccs_joinClan"));

		string fortunes = get_property("c2t_hccs_clanFortunes");

		if (is_online(fortunes))
			while (get_property('_clanFortuneConsultUses').to_int() < 3)
				cli_execute(`fortune {fortunes};wait 5`);
		else
			c2t_hccs_printWarn(`{fortunes} is not online; skipping fortunes`);
	}

	//fax
	if (!get_property('_photocopyUsed').to_boolean() && item_amount($item[photocopied monster]) == 0) {
		if (available_amount($item[industrial fire extinguisher]) > 0 && available_amount($item[fourth of may cosplay saber]) > 0) {
			if (!(get_locket_monsters() contains $monster[ungulith]))
				c2t_hccs_getFax($monster[ungulith]);
		}
		else if (is_online("cheesefax")) {
			if (!(get_locket_monsters() contains $monster[factory worker (female)]))
				c2t_hccs_getFax($monster[factory worker (female)]);
		}
		else {
			if (!(get_locket_monsters() contains $monster[ungulith]))
				c2t_hccs_getFax($monster[ungulith]);
		}
	}

	c2t_hccs_haveUse($skill[spirit of peppermint]);
	
	//fish hatchet
	if (c2t_hccs_vipFloundry())
		if (!get_property('_floundryItemCreated').to_boolean() && !retrieve_item(1,$item[fish hatchet]))
			c2t_hccs_printWarn('Failed to get a fish hatchet');

	//cod piece steps
	/*if (!retrieve_item(1,$item[fish hatchet])) {
		retrieve_item(1,$item[codpiece]);
		c2t_hccs_haveUse(1,$item[codpiece]);
		c2t_hccs_haveUse(8,$item[bubblin' crude]);
		autosell(1,$item[oil cap]);
	}*/

	c2t_hccs_haveUse($item[astral six-pack]);

	//pantagramming
	c2t_hccs_pantogram();

	//model train set
	c2t_hccs_modelTrainSet();

	//backup camera settings
	if (get_property('backupCameraMode') != 'ml' || !get_property('backupCameraReverserEnabled').to_boolean())
		cli_execute('try;backupcamera ml;backupcamera reverser on');

	//knock-off hero cape thing
	if (available_amount($item[unwrapped knock-off retro superhero cape]) > 0)
		cli_execute('retrocape '+my_primestat());

	//ebony epee from lathe
	if (available_amount($item[ebony epee]) == 0) {
		if (item_amount($item[spinmaster&trade; lathe]) > 0) {
			visit_url('shop.php?whichshop=lathe');
			retrieve_item(1,$item[ebony epee]);
		}
	}
	
	//FantasyRealm hat
	if (get_property("frAlways").to_boolean() && available_amount($item[fantasyrealm g. e. m.]) == 0) {
		visit_url('place.php?whichplace=realm_fantasy&action=fr_initcenter');
		if (my_primestat() == $stat[muscle])
			run_choice(1);//1280,1 warrior; 1280,2 mage
		else if (my_primestat() == $stat[mysticality])
			run_choice(2);
		else if (my_primestat() == $stat[moxie])
			run_choice(3);//a guess
	}

	//boombox meat
	if (item_amount($item[songboom&trade; boombox]) > 0 && get_property('boomBoxSong') != 'Total Eclipse of Your Meat')
		cli_execute('boombox meat');

	// upgrade saber for familiar weight
	if (get_property('_saberMod').to_int() == 0) {
		visit_url('main.php?action=may4');
		run_choice(4);
	}

	// Sell pork gems
	visit_url('tutorial.php?action=toot');
	c2t_hccs_haveUse($item[letter from king ralph xi]);
	c2t_hccs_haveUse($item[pork elf goodies sack]);
	if (my_meat() < 2500) {//don't autosell if there is some other source of meat
		autosell(5,$item[baconstone]);
		autosell(5,$item[hamethyst]);
		if (c2t_hccs_havePizzaCube())
			autosell(5,$item[porquoise]);
		else {
			int temp = item_amount($item[porquoise]);
			if (temp > 0)
				autosell(temp-1,$item[porquoise]);
		}
	}

	//buy toy accordion
	if (my_class() != $class[accordion thief])
		retrieve_item(1,$item[toy accordion]);
	
	// equip mp stuff
	maximize(`-tie,mp,-equip {c2t_pilcrow($item[kramco sausage-o-matic&trade;])},-equip {c2t_pilcrow($item[&quot;i voted!&quot; sticker])}`,false);

	// should have enough MP for this much; just being lazy here for now
	c2t_hccs_getEffect($effect[the magical mojomuscular melody]);

	//breakfasty things
	c2t_hccs_breakfast();

	// pre-coil pizza to get imitation whetstone for INFE pizza latter
	if (c2t_hccs_havePizzaCube() && my_fullness() == 0) {
		// get imitation crab
		use_familiar($familiar[imitation crab]);

		// make pizza
		if (item_amount($item[diabolic pizza]) == 0) {
			retrieve_item(3,$item[cog and sprocket assembly]);
			
			if (available_amount($item[blood-faced volleyball]) == 0) {
				hermit(1,$item[volleyball]);
				
				if (have_effect($effect[bloody hand]) == 0) {
					hermit(1,$item[seal tooth]);
					c2t_hccs_getEffect($effect[bloody hand]);
				}
				use(1,$item[volleyball]);
			}

			c2t_hccs_pizzaCube(
				$item[cog and sprocket assembly],
				$item[cog and sprocket assembly],
				$item[cog and sprocket assembly],
				$item[blood-faced volleyball]
				);
		}
		else
			eat(1,$item[diabolic pizza]);
		c2t_hccs_levelingFamiliar(true);
	}
	//cold medicine cabinet; grabbing a stat booze to get some adventures post-coil
	else
		c2t_hccs_coldMedicineCabinet("drink");
	
	// need to fetch and drink some booze pre-coil. using semi-rare via pillkeeper in sleazy back alley
	/* going to be using borrowed time, so no longer need
	if (my_turncount() == 0) {
		cli_execute('pillkeeper semirare');
		if (get_property('semirareCounter').to_int() > 0) //does not work?
			abort('Semirare should be now. Something went wrong.');
		cli_execute('mood apathetic');
		cli_execute('counters nowarn Fortune Cookie');
		//maybe recover before this?
		adv1($location[the sleazy back alley], -1, '');
	}
	
	// drinking
	if (my_inebriety() == 0 && available_amount($item[distilled fortified wine]) >= 2) {
		if (have_effect($effect[ode to booze]) < 2) {
			if (my_mp() < 50) { //this block is assuming my setup w/ getaway camp
				cli_execute('breakfast');
				
				//cli_execute('rest free'); //<-- DANGEROUS
				if (get_property('timesRested') < total_free_rests())
					visit_url('place.php?whichplace=campaway&action=campaway_tentclick');
			}
			if (!use_skill(1,$skill[the ode to booze]))
				abort("couldn't cast ode to booze");
		}
		drink(2,$item[distilled fortified wine]);
	}
	*/

	// first tome use // borrowed time
	if (!get_property('_borrowedTimeUsed').to_boolean() && c2t_hccs_tomeClipArt($item[borrowed time]))
		use(1,$item[borrowed time]);

	// second tome use // box of familiar jacks
	// going to get camel equipment straight away
	if (c2t_hccs_melodramedary()
		&& available_amount($item[dromedary drinking helmet]) == 0
		&& c2t_hccs_tomeClipArt($item[box of familiar jacks])) {

		use_familiar($familiar[melodramedary]);
		use(1,$item[box of familiar jacks]);
	}
	
	// beach access
	c2t_assert(retrieve_item(1,$item[bitchin' meatcar]),"Couldn't get a bitchin' meatcar");

	// moxie guild unlock
	if (c2t_hccs_unlockGuildMoxie())
		c2t_hccs_unlockDistantWoods();

	// tune moon sign
	if (!get_property('moonTuned').to_boolean()) {
		int cog,tank,gogogo;

		// unequip spoon
		cli_execute('unequip hewn moon-rune spoon');
		
		switch (my_primestat()) {
			case $stat[muscle]:
				gogogo = 7;
				cog = 3;
				tank = 1;
				if (c2t_hccs_havePizzaCube() && available_amount($item[beach comb]) == 0)
					c2t_assert(retrieve_item(1,$item[gnollish autoplunger]),"gnollish autoplunger is a critical pizza ingredient without a beach comb");
				break;
			case $stat[mysticality]:
				gogogo = 8;
				cog = 2;
				tank = 2;
				break;
			case $stat[moxie]:
				gogogo = 9;
				cog = 2;
				tank = 1;
				break;
			default:
				abort('something broke with moon sign changing');
		}
		if (c2t_hccs_havePizzaCube()) {
			//CSAs for later pizzas (3 for CER & HGh) //2 for CER & DIF or CER & KNI
			c2t_assert(retrieve_item(cog,$item[cog and sprocket assembly]),"Didn't get enough cog and sprocket assembly");
			//empty meat tank for DIF and INFE pizzas
			c2t_assert(retrieve_item(tank,$item[empty meat tank]),`Need {tank} emtpy meat tank`);
		}
		//tune moon sign
		visit_url('inv_use.php?whichitem=10254&doit=96&whichsign='+gogogo);
	}

	while (c2t_hccs_wandererFight());
	
	// get love potion before moving ahead, then dump if bad
	c2t_hccs_lovePotion(false,true);
	
	return true;
}

// get experience buffs prior to using items that give exp
boolean c2t_hccs_buffExp() {
	print('Getting experience buffs');
	// boost mus exp
	if (have_effect($effect[that's just cloud-talk, man]) == 0)
		visit_url('place.php?whichplace=campaway&action=campaway_sky');
	if (have_effect($effect[that's just cloud-talk, man]) == 0)
		c2t_hccs_printWarn('Getaway camp buff failure');

	
	// shower exp buff
	if (!get_property('_aprilShower').to_boolean())
		cli_execute('shower '+my_primestat());
	
	//TODO make synthesize selections smarter so the item one doesn't have to be so early
	//synthesize item //put this before all other syntheses so the others don't use too many sprouts
	c2t_hccs_sweetSynthesis($effect[synthesis: collection]);

	if (my_primestat() == $stat[muscle]) {
		//exp buff via pizza or wish
		if (!c2t_hccs_pizzaCube($effect[hgh-charged])
			&& !c2t_hccs_monkeyPaw($effect[hgh-charged]))
		{
			c2t_hccs_genie($effect[hgh-charged]);
		}

		// mus exp synthesis
		if (!c2t_hccs_sweetSynthesis($effect[synthesis: movement]))
			c2t_hccs_printWarn('Failed to synthesize exp buff');

		if (numeric_modifier('muscle experience percent') < 89.999) {
			abort('Insufficient +exp%');
			return false;
		}
	}
	else if (my_primestat() == $stat[mysticality]) {
		//exp buff via pizza or wish
		if (!c2t_hccs_pizzaCube($effect[different way of seeing things])
			&& !c2t_hccs_monkeyPaw($effect[different way of seeing things]))
		{
			c2t_hccs_genie($effect[different way of seeing things]);
		}
		
		// mys exp synthesis
		if (!c2t_hccs_sweetSynthesis($effect[synthesis: learning]))
			c2t_hccs_printWarn('Failed to synthesize exp buff');

		//face
		c2t_hccs_getEffect($effect[inscrutable gaze]);

		if (numeric_modifier('mysticality experience percent') < 99.999) {
			abort('Insufficient +exp%');
			return false;
		}
	}
	else if (my_primestat() == $stat[moxie]) {
		//stat buff via pizza cube or exp buff via wish
		if (!c2t_hccs_pizzaCube($effect[knightlife])
			&& !c2t_hccs_monkeyPaw($effect[thou shant not sing]))
		{
			c2t_hccs_genie($effect[thou shant not sing]);
		}

		// mox exp synthesis
		// hardcore will be dropped if candies not aligned properly
		if (!c2t_hccs_sweetSynthesis($effect[synthesis: style]))
			c2t_hccs_printWarn('Failed to synthesize exp buff');

		if (numeric_modifier('moxie experience percent') < 89.999) {
			abort('Insufficient +exp%');
			return false;
		}
		//return false;//want to check state at this point
	}

	return true;
}

// should handle leveling up and eventually call free fights
boolean c2t_hccs_levelup() {
	//CMC booze
	item itew = c2t_priority($item[doc's fortifying wine],$item[doc's smartifying wine],$item[doc's limbering wine]);
	if (itew != $item[none]) {
		c2t_hccs_getEffect($effect[ode to booze]);
		drink(1,itew);
	}
	//need adventures straight away if dangerously low
	else if (my_adventures() <= 1
		&& !c2t_mayam($item[yam battery]))
	{
		//TODO more booze options
		//eye and a twist from crimbo 2020
		c2t_hccs_haveUse($skill[eye and a twist]);
		if (item_amount($item[eye and a twist]) > 0)
			itew = $item[eye and a twist];

		c2t_assert(itew != $item[none],"could not get booze to get more adventures");

		c2t_hccs_getEffect($effect[ode to booze]);
		drink(1,itew);
	}
	c2t_assert(my_adventures() > 0,"not going to get far with zero adventures");

	if (my_level() < 7 && c2t_hccs_buffExp()) {
		if (item_amount($item[familiar scrapbook]) > 0)
			equip($item[familiar scrapbook]);
		c2t_hccs_haveUse($item[a ten-percent bonus]);
	}
	if (my_level() < 7)
		abort('initial leveling broke');

	//some pulls if not in hard core; assumes 125 in an offstat and 200 in mainstat is achieveable
	if (have_skill($skill[spirit of rigatoni]))
		c2t_hccs_pull($item[staff of simmering hatred]);//125 mys; saves 4 for spell test
	//also attempt to pull stick-knife in weapon and spell tests since having 150 offstat is possible then
	if (my_primestat() == $stat[muscle])
		c2t_hccs_pull($item[stick-knife of loathing]);//150 mus; saves 4 for spell test
	if (have_familiar($familiar[mini-trainbot]))
		c2t_hccs_pull($item[overloaded yule battery]);//should save at least 2 turns at worst, 4-ish at best
	//familiar pants
	if (!c2t_hccs_pull($item[repaid diaper]))
		c2t_hccs_pull($item[great wolf's beastly trousers]);//100 mus; saves 2 for fam test
	//moxie may have done up to 2 pulls prior to this set of pulls; want to keep a pull open for chance of stick-knife later
	if (my_primestat() == $stat[moxie] && pulls_remaining() > 1)
		c2t_hccs_pull($item[crumpled felt fedora]);//200 mox; saves 2 for fam test

	c2t_hccs_allTheBuffs();

	return true;
}

// initialise limited-use, non-mood buffs for leveling
boolean c2t_hccs_allTheBuffs() {
	// using MCD as a flag, what could possibly go wrong?
	if (current_mcd() >= 10)
		return true;

	c2t_hccs_printInfo('Getting pre-fight buffs');
	// equip mp stuff
	maximize(`-tie,mp,-equip {c2t_pilcrow($item[kramco sausage-o-matic&trade;])}`,false);
	
	if (!get_property("c2t_hccs_disable.cloverItem").to_boolean()
		&& have_effect($effect[one very clear eye]) == 0)
	{
		while (c2t_hccs_wandererFight());//do vote monster if ready before spending turn
		if (c2t_hccs_cloverItem())
			c2t_hccs_getEffect($effect[one very clear eye]);
	}

	//emotion chip stat buff
	c2t_hccs_getEffect($effect[feeling excited]);

	c2t_hccs_getEffect($effect[the magical mojomuscular melody]);

	//mayday contract
	c2t_hccs_haveUse($item[mayday&trade; supply package]);
	//TODO reevaluate cost/benefit later
	c2t_hccs_haveUse($item[emergency glowstick]);
	//make early meat a non-issue if obtained
	autosell(1,$item[space blanket]);

	//boxing daycare stat gain
	if (get_property("daycareOpen").to_boolean() && get_property('_daycareGymScavenges').to_int() == 0) {
		visit_url('place.php?whichplace=town_wrong&action=townwrong_boxingdaycare');
		run_choice(3);//1334,3 boxing daycare lobby->boxing daycare
		run_choice(2);//1336,2 scavenge
	}

	//bastille
	if (item_amount($item[bastille battalion control rig]).to_boolean() && get_property('_bastilleGames').to_int() == 0)
		cli_execute('bastille mainstat brutalist');

	//getaway camp buff
	if (get_property('_campAwaySmileBuffs').to_int() == 0)
		visit_url('place.php?whichplace=campaway&action=campaway_sky');
	
	//monorail
	if (get_property('_lyleFavored') == 'false')
		c2t_hccs_getEffect($effect[favored by lyle]);
	
	c2t_hccs_pillkeeper($effect[hulkien]); //stats
	c2t_hccs_pillkeeper($effect[fidoxene]);//familiar
	
	//beach comb leveling buffs
	if (available_amount($item[beach comb]) > 0) {
		c2t_hccs_getEffect($effect[you learned something maybe!]); //beach exp
		c2t_hccs_getEffect($effect[do i know you from somewhere?]);//beach fam wt
		if (my_primestat() == $stat[moxie])
			c2t_hccs_getEffect($effect[pomp & circumsands]);//beach moxie
	}

	//TODO only use bee's knees and other less-desirable buffs if below some buff threshold
	// Cast Ode and drink bee's knees
	// going to skip this for non-moxie to use clip art's buff of same strength
	if (!get_property("c2t_hccs_disable.vipBeesKnees").to_boolean() && have_effect($effect[on the trolley]) == 0) {
		c2t_assert(my_meat() >= 500,"Need 500 meat for speakeasy booze");
		c2t_hccs_getEffect($effect[ode to booze]);
		cli_execute("drink 1 bee's knees");
		//probably don't need to drink the perfect drink; have to double-check all inebriety checks before removing
		//drink(1,$item[perfect dark and stormy]);
		//cli_execute('drink perfect dark and stormy');
	}

	//just in case
	if (have_effect($effect[ode to booze]) > 0)
		cli_execute('shrug ode to booze');
	
	//fortune buff item
	if (get_property('_clanFortuneBuffUsed') == 'false')
		c2t_hccs_getEffect($effect[there's no n in love]);

	//cast triple size
	if (available_amount($item[powerful glove]) > 0 && have_effect($effect[triple-sized]) == 0 && !c2t_cast($skill[cheat code: triple size]))
		abort('Triple size failed');

	//boxing daycare buff
	if (get_property("daycareOpen").to_boolean() && !get_property("_daycareSpa").to_boolean())
		cli_execute(`daycare {my_primestat().to_lower_case()}`);

	//candles
	c2t_hccs_haveUse($item[napalm in the morning&trade; candle]);
	c2t_hccs_haveUse($item[votive of confidence]);

	//synthesis
	if (my_primestat() == $stat[muscle]) {
		if (!c2t_hccs_sweetSynthesis($effect[synthesis: strong]))
			c2t_hccs_printWarn("Failed to synthesize stat buff");
	}
	else if (my_primestat() == $stat[mysticality]) {
		if (!c2t_hccs_sweetSynthesis($effect[synthesis: smart]))
			c2t_hccs_printWarn("Failed to synthesize stat buff");
	}
	else if (my_primestat() == $stat[moxie]) {
		if (!c2t_hccs_sweetSynthesis($effect[synthesis: cool]))
			c2t_hccs_printWarn("Failed to synthesize stat buff");
	}

	//third tome use //no longer using bee's knees for stat boost on non-moxie, but still need same strength buff?
	if (have_effect($effect[purity of spirit]) == 0 && c2t_hccs_tomeClipArt($item[cold-filtered water]))
		use(1,$item[cold-filtered water]);

	//rhinestones to help moxie leveling
	if (my_primestat() == $stat[moxie])
		use(item_amount($item[rhinestone]),$item[rhinestone]);

	c2t_hccs_levelingFamiliar(true);

	//telescope
	if (!get_property("telescopeLookedHigh").to_boolean())
		cli_execute('try;telescope high');

	cli_execute('mcd 10');

	return true;
}

boolean c2t_hccs_lovePotion(boolean useit) {
	return c2t_hccs_lovePotion(useit,false);
}

boolean c2t_hccs_lovePotion(boolean useit,boolean dumpit) {
	if (!have_skill($skill[love mixology]))
		return false;

	item love_potion = $item[love potion #xyz];
	effect love_effect = $effect[tainted love potion];
	
	if (have_effect(love_effect) == 0) {
		if (available_amount(love_potion) == 0)
			c2t_hccs_haveUse($skill[love mixology]);

		visit_url('desc_effect.php?whicheffect='+love_effect.descid);
		
		if ((my_primestat() == $stat[muscle] && 
				(love_effect.numeric_modifier('mysticality').to_int() <= -50
				|| love_effect.numeric_modifier('muscle').to_int() <= 10
				|| love_effect.numeric_modifier('moxie').to_int() <= -50
				|| love_effect.numeric_modifier('maximum hp percent').to_int() <= -50))
			|| (my_primestat() == $stat[mysticality] &&
				(love_effect.numeric_modifier('mysticality').to_int() <= 10
				|| love_effect.numeric_modifier('muscle').to_int() <= -50
				|| love_effect.numeric_modifier('moxie').to_int() <= -50
				|| love_effect.numeric_modifier('maximum hp percent').to_int() <= -50))
			|| (my_primestat() == $stat[moxie] &&
				(love_effect.numeric_modifier('mysticality').to_int() <= -50
				|| love_effect.numeric_modifier('muscle').to_int() <= -50
				|| love_effect.numeric_modifier('moxie').to_int() <= 10
				|| love_effect.numeric_modifier('maximum hp percent').to_int() <= -50)))
		{
			if (dumpit) {
				use(1,love_potion);
				return true;
			}
			else {
				c2t_hccs_printInfo('not using trash love potion');
				return false;
			}
		}
		else if (useit) {
			use(1,love_potion);
			return true;
		}
		else {
			c2t_hccs_printInfo('love potion should be good; holding onto it');
			return false;
		}
	}
	//abort('error handling love potion');
	return false;
}

boolean c2t_hccs_preItem() {
	string maxstr = `-tie,item,2 booze drop,-equip {c2t_pilcrow($item[broken champagne bottle])},-equip {c2t_pilcrow($item[surprisingly capacious handbag])},-equip {c2t_pilcrow($item[red-hot sausage fork])},-equip {c2t_pilcrow($item[miniature crystal ball])},switch disembodied hand,switch left-hand man`;

	//shrug off an AT buff
	cli_execute("shrug ur-kel");

	//get latte ingredient from fluffy bunny and cloake item buff
	if (have_effect($effect[feeling lost]) == 0
		&& ((available_amount($item[vampyric cloake]) > 0
				&& have_effect($effect[bat-adjacent form]) == 0)
			|| (!get_property('latteUnlocks').contains_text('carrot')
				&& !get_property("c2t_hccs_disable.latteFishing").to_boolean())))
	{
		maximize(`-tie,-equip {c2t_pilcrow($item[bat wings])},mainstat,equip {c2t_pilcrow($item[latte lovers member's mug])},1000 bonus {c2t_pilcrow($item[lil' doctor&trade; bag])},1000 bonus {c2t_pilcrow($item[kremlin's greatest briefcase])},1000 bonus {c2t_pilcrow($item[vampyric cloake])},100 bonus {c2t_pilcrow($item[designer sweatpants])}`,false);
		familiar fam = c2t_hccs_levelingFamiliar(true);

		//get buffs with combat skills
		if (c2t_hccs_banishesLeft() > 0
			&& ((have_equipped($item[vampyric cloake])
					&& have_effect($effect[bat-adjacent form]) == 0)
				|| (get_property("hasCosmicBowlingBall").to_boolean()
					&& get_property("cosmicBowlingBallReturnCombats").to_int() <= 1
					&& have_effect($effect[cosmic ball in the air]) == 0)))
		{
			c2t_freeAdv($location[the dire warren]);
		}
		//fish for latte ingredient
		while (c2t_hccs_banishesLeft() > 0
			&& !get_property('latteUnlocks').contains_text('carrot')
			&& !get_property("c2t_hccs_disable.latteFishing").to_boolean())
		{
			//bowling ball could return mid-fishing
			if (get_property("hasCosmicBowlingBall").to_boolean()
				&& get_property("cosmicBowlingBallReturnCombats").to_int() <= 1
				&& have_effect($effect[cosmic ball in the air]) == 0)
			{
				use_familiar(fam);
				c2t_freeAdv($location[the dire warren]);
			}
			//fish with runaways
			else if (have_familiar($familiar[pair of stomping boots])) {
				use_familiar($familiar[pair of stomping boots]);
				c2t_freeAdv($location[the dire warren],-1,"runaway;abort;");
			}
			//fish with banishes
			else {
				use_familiar(fam);//just in case
				c2t_freeAdv($location[the dire warren]);
			}
		}
	}

	//no location modifiers
	set_location($location[none]);

	//don't want to be running an item or booze fairy for the test
	if (numeric_modifier(my_familiar(),"Item Drop",c2t_famWeight(),$item[none]) > 0
		|| numeric_modifier(my_familiar(),"Booze Drop",c2t_famWeight(),$item[none]) > 0)
	{
		use_familiar(c2t_priority($familiars[left-hand man,disembodied hand,hovering sombrero,blood-faced volleyball,leprechaun,mosquito]));
	}
	if (!get_property('latteModifier').contains_text('Item Drop')
		&& get_property('latteUnlocks').contains_text('carrot')
		&& get_property('_latteBanishUsed').to_boolean())
	{
		cli_execute('latte refill cinnamon carrot vanilla');
	}

	//pizza cube certainty
	if (have_effect($effect[synthesis: collection]) == 0)//skip pizza if synth item
		c2t_hccs_pizzaCube($effect[certainty]);

	//infernal thirst by any means
	if (!c2t_hccs_pizzaCube($effect[infernal thirst])
		&& !c2t_hccs_monkeyPaw($effect[infernal thirst]))
	{
		c2t_hccs_genie($effect[infernal thirst]);
	}

	//spice ghost
	if (my_class() != $class[pastamancer])
		c2t_hccs_getEffect($effect[spice haze]);

	c2t_hccs_getEffect($effects[
		fat leon's phat loot lyric,
		singer's faithful ocelot,
		the spirit of taking,
		nearly all-natural,//bag of grain
		crunching leaves,//autumn-aton
		steely-eyed squint
		]);

	//unbreakable umbrella
	c2t_hccs_unbreakableUmbrella("item");

	maximize(maxstr,false);
	if (c2t_hccs_thresholdMet(TEST_ITEM))
		return true;

	//THINGS I DON'T ALWAYS WANT TO USE FOR ITEM TEST

	//fireworks shop
	if (retrieve_item(1,$item[oversized sparkler])) {
		maximize(maxstr,false);
		if (c2t_hccs_thresholdMet(TEST_ITEM))
			return true;
	}

	//asdon
	if (c2t_hccs_asdon($effect[driving observantly])
		&& c2t_hccs_thresholdMet(TEST_ITEM))
	{
		return true;
	}

	//AT-only buff
	if (my_class() == $class[accordion thief] && have_skill($skill[the ballad of richie thingfinder])) {
		ensure_song($effect[the ballad of richie thingfinder]);
		if (c2t_hccs_thresholdMet(TEST_ITEM))
			return true;
	}

	//if familiar test is ever less than 19 turns, feel lost will need to be completely removed or the test order changed
	if (c2t_hccs_getEffect($effect[feeling lost])
		&& c2t_hccs_thresholdMet(TEST_ITEM))
	{
		return true;
	}

	//non-pizza certainty
	if (c2t_hccs_monkeyPaw($effect[certainty])
		&& c2t_hccs_thresholdMet(TEST_ITEM))
	{
		return true;
	}

	if (item_amount($item[rufus's shadow lodestone]) > 0
		&& have_effect($effect[shadow waters]) == 0
		&& have_effect($effect[feeling lost]) == 0)
	{
		c2t_freeAdv($location[shadow rift]);
		set_location($location[none]);
		if (c2t_hccs_thresholdMet(TEST_ITEM))
			return true;
	}

	if (c2t_hccs_haveSourceTerminal()
		&& c2t_hccs_getEffect($effect[items.enh])
		&& c2t_hccs_thresholdMet(TEST_ITEM))
	{
		return true;
	}

	//power plant; last to save batteries if not needed
	if (c2t_hccs_powerPlant())
		c2t_hccs_getEffect($effect[lantern-charged]);

	return c2t_hccs_thresholdMet(TEST_ITEM);
}

boolean c2t_hccs_preHotRes() {
	string maxstr = "-tie,100hot res,familiar weight,switch exotic parrot,switch mu,switch disembodied hand,switch left-hand man";

	//cloake buff and fireproof foam suit for +32 hot res total, but also weapon and spell test buffs
	//weapon/spell buff should last 15 turns, which is enough to get through hot(1), NC(9), and weapon(1) tests to also affect the spell test
	if ((have_effect($effect[do you crush what i crush?]) == 0
			&& have_familiar($familiar[ghost of crimbo carols]))
		|| (have_effect($effect[fireproof foam suit]) == 0
			&& available_amount($item[industrial fire extinguisher]) > 0
			&& have_skill($skill[double-fisted skull smashing]))
		|| (have_effect($effect[misty form]) == 0
			&& available_amount($item[vampyric cloake]) > 0))
	{
		if (available_amount($item[vampyric cloake]) > 0)
			equip($item[vampyric cloake]);
		equip($slot[weapon],$item[fourth of may cosplay saber]);
		if (available_amount($item[industrial fire extinguisher]) > 0)
			equip($slot[off-hand],$item[industrial fire extinguisher]);
		use_familiar(c2t_priority($familiars[ghost of crimbo carols,exotic parrot]));

		c2t_freeAdv($location[the dire warren],-1,"");
		run_turn();
	}

	c2t_hccs_getEffect($effects[
		//fam weight skills
		blood bond,
		empathy,
		leash of linguini,
		//ele res skills
		elemental saucesphere,
		astral shell,
		//emotion chip
		feeling peaceful
		]);

	// need to run this twice because familiar weight thresholds interfere with it?
	maximize(maxstr,false);
	maximize(maxstr,false);
	if (c2t_hccs_thresholdMet(TEST_HOT_RES))
		return true;


	//THINGS I DON'T USE FOR HOT TEST ANYMORE, but will fall back on if other things break

	//beach comb hot buff
	if (available_amount($item[beach comb]) > 0) {
		c2t_hccs_getEffect($effect[hot-headed]);
		if (c2t_hccs_thresholdMet(TEST_HOT_RES))
			return true;
	}

	//daily candle
	if (c2t_hccs_haveUse($item[rainbow glitter candle])
		&& c2t_hccs_thresholdMet(TEST_HOT_RES))
	{
		return true;
	}

	//magenta seashell
	if (c2t_hccs_getEffect($effect[too cool for (fish) school])
		&& c2t_hccs_thresholdMet(TEST_HOT_RES))
	{
		return true;
	}

	//potion for sleazy hands & hot powder
	if (have_skill($skill[pulverize])) {
		retrieve_item(1,$item[tenderizing hammer]);

		if (have_effect($effect[flame-retardant trousers]) == 0) {
			while (available_amount($item[hot powder]) == 0
				&& available_amount($item[red-hot sausage fork]) > 0)
			{
				cli_execute('smash 1 red-hot sausage fork');
			}
			if (available_amount($item[hot powder]) > 0)
				c2t_hccs_getEffect($effect[flame-retardant trousers]);
		}
		if (c2t_hccs_thresholdMet(TEST_HOT_RES))
			return true;

		if (have_effect($effect[sleazy hands]) == 0
			&& (c2t_hccs_freeCraftsLeft() > 0
				|| (have_effect($effect[fireproof foam suit]) == 0
					&& have_effect($effect[misty form]) == 0)))
		{
			while (available_amount($item[sleaze nuggets]) == 0
				&& available_amount($item[ratty knitted cap]) > 0)
			{
				cli_execute('smash 1 ratty knitted cap');
			}
			if (available_amount($item[sleaze nuggets]) > 0
				|| available_amount($item[lotion of sleaziness]) > 0)
			{
				c2t_hccs_getEffect($effect[sleazy hands]);
			}
		}
		if (c2t_hccs_thresholdMet(TEST_HOT_RES))
			return true;
	}

	//pocket maze
	if (c2t_hccs_getEffect($effect[amazing])
		&& c2t_hccs_thresholdMet(TEST_HOT_RES))
	{
		return true;
	}

	//asdon
	if (c2t_hccs_asdon($effect[driving safely])
		&& c2t_hccs_thresholdMet(TEST_HOT_RES))
	{
		return true;
	}

	//briefcase
	if (c2t_hccs_briefcase("hot")) {
		maximize(maxstr,false);
		if (c2t_hccs_thresholdMet(TEST_HOT_RES))
			return true;
	}

	//synthesis: hot
	if (c2t_hccs_sweetSynthesis($effect[synthesis: hot])
		&& c2t_hccs_thresholdMet(TEST_HOT_RES))
	{
		return true;
	}

	//pillkeeper
	if (c2t_hccs_pillkeeper($effect[rainbowolin])
		&& c2t_hccs_thresholdMet(TEST_HOT_RES))
	{
		return true;
	}

	//pocket wish
	if ((c2t_hccs_monkeyPaw($effect[fireproof lips])
			|| c2t_hccs_genie($effect[fireproof lips]))
		&& c2t_hccs_thresholdMet(TEST_HOT_RES))
	{
		return true;
	}

	//speakeasy drink
	if (have_effect($effect[feeling no pain]) == 0) {
		c2t_assert(my_meat() >= 500,'Not enough meat. Please autosell stuff.');
		ensure_ode(2);
		cli_execute('drink 1 ish kabibble');
	}

	return c2t_hccs_thresholdMet(TEST_HOT_RES);
}

boolean c2t_hccs_preFamiliar() {
	string maxstr = "-tie,familiar weight";
	//sabering fax for meteor shower
	//using fax/wish here as feeling lost here is very likely
	if ((have_skill($skill[meteor lore]) && have_effect($effect[meteor showered]) == 0) ||
		(available_amount($item[lava-proof pants]) == 0
		&& available_amount($item[heat-resistant necktie]) == 0
		&& item_amount($item[corrupted marrow]) == 0)) {

		if (!have_equipped($item[fourth of may cosplay saber]))
			equip($item[fourth of may cosplay saber]);

		if (item_amount($item[photocopied monster]) > 0) {
			use(1,$item[photocopied monster]);
			run_turn();
		}
		else {
			if (available_amount($item[industrial fire extinguisher]) > 0) {
				if (!c2t_hccs_combatLoversLocket($monster[ungulith]) && !c2t_hccs_genie($monster[ungulith]))
					abort("ungulith fight fail");
			}
			else {
				if (!c2t_hccs_combatLoversLocket($monster[factory worker (female)]) && !c2t_hccs_genie($monster[factory worker (female)]))
					abort("factory worker fight fail");
			}
		}
	}

	// Pool buff
	c2t_hccs_getEffect($effect[billiards belligerence]);

	restore_hp(31);//need to have the hp before casting blood skills
	c2t_hccs_getEffect($effect[blood bond]);
	c2t_hccs_getEffect($effect[leash of linguini]);
	c2t_hccs_getEffect($effect[empathy]);

	//AT-only buff
	if (my_class() == $class[accordion thief] && have_skill($skill[chorale of companionship]))
		ensure_song($effect[chorale of companionship]);

	//find highest familar weight
	//TODO take familiar equipment or more optimal combinations into account
	familiar highest = $familiar[none];
	if (have_familiar($familiar[mini-trainbot])
		&& available_amount($item[overloaded yule battery]) == 0
		&& c2t_hccs_tomeClipArt($item[box of familiar jacks]))
	{
		use_familiar($familiar[mini-trainbot]);
		use($item[box of familiar jacks]);
		highest = $familiar[mini-trainbot];
	}
	else if (have_familiar($familiar[mini-trainbot]) && available_amount($item[overloaded yule battery]) > 0)
		highest = $familiar[mini-trainbot];
	else if (have_familiar($familiar[exotic parrot]) && available_amount($item[cracker]) > 0)
		highest = $familiar[exotic parrot];
	//grab baby bugbear beanie without spending a turn
	else if (have_familiar($familiar[baby bugged bugbear])
		&& c2t_priority($items[amulet coin,astral pet sweater,luck incense,muscle band,razor fang,shell bell,smoke ball,sugar shield]) == $item[none])
	{
		use_familiar($familiar[baby bugged bugbear]);
		if (available_amount($item[bugged beanie]) == 0)
			visit_url("arena.php",false);
		equip($slot[familiar],$item[bugged beanie]);
		highest = $familiar[baby bugged bugbear];
	}
	else if (have_effect($effect[fidoxene]) > 0)
		highest = $familiar[none];
	else
		foreach fam in $familiars[]
			if (have_familiar(fam) && familiar_weight(fam) > familiar_weight(highest))
				highest = fam;

	if (highest == $familiar[none])
		c2t_hccs_levelingFamiliar(true);
	else
		use_familiar(highest);

	maximize(maxstr,false);
	if (c2t_hccs_thresholdMet(TEST_FAMILIAR))
		return true;

	//should only get 1 per run, if any; would use in NEP combat loop, but no point as sombrero would already be already giving max stats
	c2t_hccs_haveUse($item[short stack of pancakes]);

	return c2t_hccs_thresholdMet(TEST_FAMILIAR);
}

boolean c2t_hccs_preNoncombat() {
	string maxstr = '-tie,-100combat,familiar weight';

	//globster
	if (have_familiar($familiar[god lobster])
		&& have_effect($effect[silence of the god lobster]) == 0
		&& get_property('_godLobsterFights').to_int() < 3)
	{
		cli_execute('mood apathetic');
		use_familiar($familiar[god lobster]);
		equip($item[god lobster's ring]);
		
		//garbage shirt should be exhausted already, but check anyway
		string shirt;
		if (c2t_hccs_haveGarbageTote()
			&& get_property('garbageShirtCharge') > 0)
		{
			shirt = `,equip {c2t_pilcrow($item[makeshift garbage shirt])}`;
		}
		maximize(`-tie,mainstat,-familiar,100 bonus {c2t_pilcrow($item[designer sweatpants])}` + shirt,false);

		//fight and get buff
		c2t_hccs_preAdv();
		visit_url('main.php?fightgodlobster=1');
		run_turn();
		if (choice_follows_fight())
			run_choice(-1);
	}

	c2t_hccs_getEffect($effects[
		//fam weight skills
		blood bond,
		empathy,
		leash of linguini,
		//skills
		the sonata of sneakiness,
		smooth movements,
		//clan
		//billiards belligerence,//fam weight;probably not needed/useful for most
		silent running,
		//emotion chip
		feeling lonely,
		//rewards with a 1-turn duration
		throwing some shade,
		a rose by any other material,
		]);

	//unbreakable umbrella
	c2t_hccs_unbreakableUmbrella("nc");

	use_familiar($familiar[disgeist]);
	maximize(maxstr,false);
	maximize(maxstr,false);
	if (c2t_hccs_thresholdMet(TEST_NONCOMBAT))
		return true;

	//apriling band helmet
	if (c2t_apriling($effect[apriling band patrol beat])
		&& c2t_hccs_thresholdmet(TEST_NONCOMBAT))
	{
		return true;
	}

	//replacing glob buff with this
	//mafia doesn't seem to support retrieve_item() by itself for this yet, so visit_url() to the rescue:
	if (!retrieve_item(1,$item[porkpie-mounted popper])) {
		c2t_hccs_printWarn("Buying limited-quantity items from the fireworks shop seems to still be broken. Feel free to add to the report at the following link saying that the bug is still a thing, but only if your clan actually has a fireworks shop:");//having a fully-stocked clan VIP lounge is technically a requirement for this script, so just covering my bases here
		print_html('<a href="https://kolmafia.us/threads/sometimes-unable-to-buy-limited-items-from-underground-fireworks-shop.27277/">https://kolmafia.us/threads/sometimes-unable-to-buy-limited-items-from-underground-fireworks-shop.27277/</a>');
		c2t_hccs_printWarn("For now, just going to do it manually:");
		visit_url("clan_viplounge.php?action=fwshop&whichfloor=2",false,true);
		//visit_url("shop.php?whichshop=fwshop",false,true);
		visit_url("shop.php?whichshop=fwshop&action=buyitem&quantity=1&whichrow=1249&pwd",true,true);
	}
	//double-checking, and what will be used when mafia finally supports it:
	retrieve_item(1,$item[porkpie-mounted popper]);

	maximize(maxstr,false);
	if (c2t_hccs_thresholdMet(TEST_NONCOMBAT))
		return true;

	//asdon
	if (c2t_hccs_asdon($effect[driving stealthily])
		&& c2t_hccs_thresholdMet(TEST_NONCOMBAT))
	{
		return true;
	}

	//powerful glove
	if (available_amount($item[powerful glove]) > 0
		&& have_effect($effect[invisible avatar]) == 0
		&& c2t_cast($skill[cheat code: invisible avatar])
		&& c2t_hccs_thresholdMet(TEST_NONCOMBAT))
	{
		return true;
	}

	//briefcase
	if (c2t_hccs_briefcase("-combat")) {
		maximize(maxstr,false);
		if (c2t_hccs_thresholdMet(TEST_NONCOMBAT))
			return true;
	}

	//disquiet riot wish potential if 2 or more wishes remain and not close to min turn
	if (c2t_hccs_testTurns(TEST_NONCOMBAT) >= 9//TODO better cost/benefit
		&& !c2t_hccs_monkeyPaw($effect[disquiet riot]))
	{
		c2t_hccs_genie($effect[disquiet riot]);
	}

	return c2t_hccs_thresholdMet(TEST_NONCOMBAT);
}

boolean c2t_hccs_preWeapon() {
	string maxstr = "-tie,weapon damage,switch disembodied hand,switch left-hand man";

	if (c2t_hccs_melodramedary() && get_property('camelSpit').to_int() != 100 && have_effect($effect[spit upon]) == 0) {
		c2t_hccs_printWarn('Camel spit only at '+get_property('camelSpit')+'%. Going to have to skip spit buff.');
		set_property("_c2t_hccs_failSpit","true");
	}

	//pizza cube prep since making this takes a turn without free crafts
	if (c2t_hccs_havePizzaCube() && c2t_hccs_freeCraftsLeft() == 0)
		retrieve_item(1,$item[ointment of the occult]);

	//cast triple size
	if (available_amount($item[powerful glove]) > 0 && have_effect($effect[triple-sized]) == 0 && !c2t_cast($skill[cheat code: triple size]))
		abort('Triple size failed');

	restore_mp(500);

	// moved to hot res test
	/*if (have_effect($effect[do you crush what i crush?]) == 0 && have_familiar($familiar[ghost of crimbo carols]) && (get_property('_snokebombUsed').to_int() < 3 || !get_property('_latteBanishUsed').to_boolean())) {
		equip($item[latte lovers member's mug]);
		if (my_mp() < 30)
			cli_execute('rest free');
		use_familiar($familiar[ghost of crimbo carols]);
		c2t_freeAdv($location[the dire warren],-1,"");
	}*/

	if (!get_property("c2t_hccs_disable.vipSockdollager").to_boolean()
		&& have_effect($effect[in a lather]) == 0)
	{
		if (my_inebriety() > inebriety_limit() - 2)
			abort('Something went wrong. We are too drunk.');
		c2t_assert(my_meat() >= 500,"Need 500 meat for speakeasy booze");
		ensure_ode(2);
		cli_execute('drink sockdollager');
	}

	if (available_amount($item[twinkly nuggets]) > 0)
		c2t_hccs_getEffect($effect[twinkly weapon]);

	c2t_hccs_getEffect($effect[carol of the bulls]);
	c2t_hccs_getEffect($effect[rage of the reindeer]);
	c2t_hccs_getEffect($effect[frenzied, bloody]);
	c2t_hccs_getEffect($effect[scowl of the auk]);
	c2t_hccs_getEffect($effect[tenacity of the snapper]);
	
	//don't have these skills yet. maybe should add check for all skill uses to make universal?
	if (have_skill($skill[song of the north]))
		c2t_hccs_getEffect($effect[song of the north]);
	if (have_skill($skill[jackasses' symphony of destruction]))
		ensure_song($effect[jackasses' symphony of destruction]);

	if (available_amount($item[vial of hamethyst juice]) > 0)
		c2t_hccs_getEffect($effect[ham-fisted]);

	// Hatter buff
	if (available_amount($item[&quot;drink me&quot; potion]) > 0) {
		retrieve_item(1,$item[goofily-plumed helmet]);
		c2t_hccs_getEffect($effect[weapon of mass destruction]);
	}

	//beach comb weapon buff
	if (available_amount($item[beach comb]) > 0)
		c2t_hccs_getEffect($effect[lack of body-building]);

	// Boombox potion
	if (available_amount($item[punching potion]) > 0)
		c2t_hccs_getEffect($effect[feeling punchy]);

	// Pool buff. Should have fallen through from noncom
	c2t_hccs_getEffect($effect[billiards belligerence]);

	//meteor shower
	if ((have_skill($skill[meteor lore]) && have_effect($effect[meteor showered]) == 0)
		|| (have_familiar($familiar[melodramedary]) && have_effect($effect[spit upon]) == 0 && get_property('camelSpit').to_int() == 100)) {

		cli_execute('mood apathetic');

		//only 2 things needed for combat:
		if (!have_equipped($item[fourth of may cosplay saber]))
			equip($item[fourth of may cosplay saber]);
		if (c2t_hccs_melodramedary())
			use_familiar($familiar[melodramedary]);
		else
			c2t_hccs_levelingFamiliar(true);

		//fight ungulith or not
		boolean fallback = true;
		if (item_amount($item[corrupted marrow]) == 0 && have_effect($effect[cowrruption]) == 0) {
			if (c2t_hccs_combatLoversLocket($monster[ungulith]) || c2t_hccs_genie($monster[ungulith]))
				fallback = false;
			else
				c2t_hccs_printWarn("Couldn't fight ungulith to get corrupted marrow");
		}
		if (fallback)
			c2t_freeAdv($location[thugnderdome],-1,"");//everything is saberable and no crazy NCs
	}

	c2t_hccs_getEffect($effect[cowrruption]);

	c2t_hccs_getEffect($effect[engorged weapon]);
	
	//tainted seal's blood
	if (available_amount($item[tainted seal's blood]) > 0)
		c2t_hccs_getEffect($effect[corruption of wretched wally]);


	// turtle tamer saves ~1 turn with this part, and 4 from voting
	if (my_class() == $class[turtle tamer]) {
		if (have_effect($effect[boon of she-who-was]) == 0) {
			c2t_hccs_getEffect($effect[blessing of she-who-was]);
			c2t_hccs_getEffect($effect[boon of she-who-was]);
		}
		c2t_hccs_getEffect($effect[blessing of the war snapper]);
	}
	else
		c2t_hccs_getEffect($effect[disdain of the war snapper]);
	
	c2t_hccs_getEffect($effect[bow-legged swagger]);

	//briefcase
	//c2t_hccs_briefcase("weapon");//this is the default, but just in case

	//pull stick-knife if able to equip
	if (my_basestat($stat[muscle]) >= 150 || have_familiar($familiar[disembodied hand]))
		c2t_hccs_pull($item[stick-knife of loathing]);

	//unbreakable umbrella
	c2t_hccs_unbreakableUmbrella("weapon");
	
	maximize(maxstr,false);
	if (c2t_hccs_thresholdMet(TEST_WEAPON))
		return true;

	//OU pizza if needed
	if (c2t_hccs_testTurns(TEST_WEAPON) > 3)//TODO ? cost/benifit?
		c2t_hccs_pizzaCube($effect[outer wolf&trade;]);
	if (have_effect($effect[outer wolf&trade;]) == 0)
		c2t_hccs_printInfo("OU pizza skipped");
	if (c2t_hccs_thresholdMet(TEST_WEAPON))
		return true;

	//cargo shorts as backup
	if (available_amount($item[cargo cultist shorts]) > 0
		&& c2t_hccs_testTurns(TEST_WEAPON) > 4 //4 is how much cargo would save on spell test, so may as well use here if spell is not better
		&& have_effect($effect[rictus of yeg]) == 0
		&& !get_property('_cargoPocketEmptied').to_boolean())
			cli_execute("cargo item yeg's motel toothbrush");
	c2t_hccs_haveUse($item[yeg's motel toothbrush]);

	return c2t_hccs_thresholdMet(TEST_WEAPON);
}

boolean c2t_hccs_preSpell() {
	string maxstr = "-tie,spell damage,switch disembodied hand,switch left-hand man";

	restore_mp(500);

	// This will use an adventure.
	// if spit upon == 1, simmering will just waste a turn to do essentially nothing.
	// probably good idea to add check for similar effects to not just waste a turn
	if (have_effect($effect[spit upon]) != 1 && have_effect($effect[do you crush what i crush?]) != 1)
		c2t_hccs_getEffect($effect[simmering]);

	while (c2t_hccs_wandererFight()); //check for after using a turn to cast Simmering

	//don't have this skill yet. Maybe should add check for all skill uses to make universal?
	if (have_skill($skill[song of sauce]))
		c2t_hccs_getEffect($effect[song of sauce]);
	if (have_skill($skill[jackasses' symphony of destruction]))
		c2t_hccs_getEffect($effect[jackasses' symphony of destruction]);
	
	c2t_hccs_getEffect($effect[carol of the hells]);

	// Pool buff
	c2t_hccs_getEffect($effect[mental a-cue-ity]);

	//beach comb spell buff
	if (available_amount($item[beach comb]) > 0)
		c2t_hccs_getEffect($effect[we're all made of starfish]);

	c2t_hccs_haveUse($skill[spirit of peppermint]);
	
	// face
	c2t_hccs_getEffect($effect[arched eyebrow of the archmage]);

	if (available_amount($item[flask of baconstone juice]) > 0)
		c2t_hccs_getEffect($effect[baconstoned]);

	//pull stick-knife if able to equip
	if (my_basestat($stat[muscle]) >= 150)
		c2t_hccs_pull($item[stick-knife of loathing]);

	//get up to 2 obsidian nutcrackers & burn pulls
	{
		int nuts = 2;
		int offs = 0;
		int lhm = have_familiar($familiar[left-hand man]).to_int();
		//weapons
		foreach x in $items[stick-knife of loathing,staff of simmering hatred]
			if (available_amount(x) > 0)
				nuts--;
		//offhands
		foreach x in $items[abracandalabra,astral statuette,august scepter,cold stone of hatred]
			if (available_amount(x) > 0)
				offs++;
		//burn remaining pulls
		if (!in_hardcore() && pulls_remaining() > 0) {
			boolean nothad = available_amount($item[cold stone of hatred]) == 0;
			//lazy way for now
			boolean [item] derp;
			if (lhm + (nuts > 0 ? 1 : 0) > offs)
				derp = $items[cold stone of hatred,fuzzy slippers of hatred,lens of hatred,witch's bra];
			else
				derp = $items[fuzzy slippers of hatred,lens of hatred,witch's bra];

			foreach x in derp {
				if (pulls_remaining() == 0)
					break;
				c2t_hccs_pull(x);
			}
			if (nothad && available_amount($item[cold stone of hatred]) > 0)
				offs++;
			if (pulls_remaining() > 0)
				c2t_hccs_printWarn(`Still had {pulls_remaining()} pulls remaining for the last test`);
		}
		if (offs > lhm)
			nuts--;
		//get the nutcrackers
		if (nuts > 0)
			retrieve_item(nuts,$item[obsidian nutcracker]);
	}

	//AT-only buff
	if (my_class() == $class[accordion thief] && have_skill($skill[elron's explosive etude]))
		ensure_song($effect[elron's explosive etude]);

	// cargo pocket
	if (available_amount($item[cargo cultist shorts]) > 0 && have_effect($effect[sigils of yeg]) == 0 && !get_property('_cargoPocketEmptied').to_boolean())
		cli_execute("cargo item Yeg's Motel hand soap");
	c2t_hccs_haveUse($item[yeg's motel hand soap]);

	// meteor lore // moxie can't do this, as it wastes a saber on evil olive -- moxie should be able to do this now with nostalgia earlier?
	if (have_skill($skill[meteor lore]) && have_effect($effect[meteor showered]) == 0 && get_property('_saberForceUses').to_int() < 5) {
		c2t_hccs_levelingFamiliar(true);
		maximize(`-tie,-equip {c2t_pilcrow($item[bat wings])},mainstat,equip {c2t_pilcrow($item[fourth of may cosplay saber])}`,false);
		c2t_freeAdv($location[thugnderdome],-1,"");//everything is saberable and no crazy NCs
	}

	if (have_skill($skill[deep dark visions]) && have_effect($effect[visions of the deep dark deeps]) == 0) {
		c2t_hccs_getEffect($effect[elemental saucesphere]);
		c2t_hccs_getEffect($effect[astral shell]);
		maximize("-tie,1000spooky res,hp,mp",false);
		restore_hp(800);
		c2t_hccs_getEffect($effect[visions of the deep dark deeps]);
	}

	//if I ever feel like blowing the resources:
	if (get_property('_c2t_hccs_dstab').to_boolean()) {
		//the only way is all the way
		c2t_hccs_genie($effect[witch breaded]);

		//batteries
		if (c2t_hccs_powerPlant()) {
			c2t_hccs_getEffect($effect[d-charged]);
			c2t_hccs_getEffect($effect[aa-charged]);
			c2t_hccs_getEffect($effect[aaa-charged]);
		}
	}

	//briefcase //TODO count spell-damage-providing accessories and values before deciding to use the briefcase
	c2t_hccs_briefcase("spell");

	//unbreakable umbrella
	c2t_hccs_unbreakableUmbrella("spell");

	maximize(maxstr,false);

	return c2t_hccs_thresholdMet(TEST_SPELL);
}

// stat tests are super lazy for now
// TODO need to figure out a way to not overdo buffs, as some buffers may be needed for pizzas
boolean c2t_hccs_preHp() {
	if (c2t_hccs_thresholdMet(TEST_HP))
		return true;

	maximize('hp,switch disembodied hand,switch left-hand man',false);
	if (c2t_hccs_thresholdMet(TEST_HP))
		return true;

	//hp buffs
	if (!c2t_hccs_getEffect($effect[song of starch]))
		c2t_hccs_getEffect($effect[song of bravado]);
	c2t_hccs_getEffect($effect[reptilian fortitude]);
	if (c2t_hccs_thresholdMet(TEST_HP))
		return true;

	//mus buffs //basically copy/paste from mus test sans bravado
	//TODO AT songs
	c2t_hccs_getEffect($effects[
		//skills
		quiet determination,
		big,
		disdain of the war snapper,
		patience of the tortoise,
		rage of the reindeer,
		seal clubbing frenzy,
		//using items
		go get 'em\, tiger!,
		//skill skills from IotM
		feeling excited
		]);

	return c2t_hccs_thresholdMet(TEST_HP);
}

boolean c2t_hccs_preMus() {
	//TODO if pastamancer, add summon of mus thrall if need? currently using equaliser potion out of laziness
	if (c2t_hccs_thresholdMet(TEST_MUS))
		return true;

	maximize('mus,switch disembodied hand,switch left-hand man',false);
	if (c2t_hccs_thresholdMet(TEST_MUS))
		return true;

	//TODO AT songs
	c2t_hccs_getEffect($effects[
		//skills
		quiet determination,
		big,
		song of bravado,
		disdain of the war snapper,
		patience of the tortoise,
		rage of the reindeer,
		seal clubbing frenzy,
		//potions
		go get 'em\, tiger!,
		//skill skills from IotM
		feeling excited
		]);

	return c2t_hccs_thresholdMet(TEST_MUS);
}

boolean c2t_hccs_preMys() {
	if (c2t_hccs_thresholdMet(TEST_MYS))
		return true;

	maximize('mys,switch disembodied hand,switch left-hand man',false);
	if (c2t_hccs_thresholdMet(TEST_MYS))
		return true;

	//TODO AT songs
	c2t_hccs_getEffect($effects[
		//skills
		quiet judgement,
		big,
		song of bravado,
		disdain of she-who-was,
		pasta oneness,
		saucemastery,
		//potions
		glittering eyelashes,
		//skill skills from IotM
		feeling excited
		]);

	return c2t_hccs_thresholdMet(TEST_MYS);
}

boolean c2t_hccs_preMox() {
	//TODO if pastamancer, add summon of mox thrall if need? currently using equaliser potion out of laziness
	if (c2t_hccs_thresholdMet(TEST_MOX))
		return true;

	maximize('mox,switch disembodied hand,switch left-hand man',false);
	if (c2t_hccs_thresholdMet(TEST_MOX))
		return true;

	//TODO AT songs
	//face
	if (!c2t_hccs_getEffect($effect[quiet desperation]))
		c2t_hccs_getEffect($effect[disco smirk]);
	//other
	c2t_hccs_getEffect($effects[
		//skills
		big,
		song of bravado,
		blubbered up,
		disco state of mind,
		mariachi mood,
		//potions
		butt-rock hair,
		unrunnable face,
		//skill skills from IotM
		feeling excited
		]);

	return c2t_hccs_thresholdMet(TEST_MOX);
}

void c2t_hccs_fights() {
	string fam;
	//TODO move familiar changes and maximizer calls inside of blocks
	// saber yellow ray stuff
	if (available_amount($item[tomato juice of powerful power]) == 0
		&& available_amount($item[tomato]) == 0
		&& have_effect($effect[tomato power]) == 0)
	{
		cli_execute('mood apathetic');

		if (c2t_hccs_levelingFamiliar(true) == $familiar[melodramedary]
			&& available_amount($item[dromedary drinking helmet]) > 0)

			fam = `,equip {c2t_pilcrow($item[dromedary drinking helmet])}`;
		
		// Fruits in skeleton store (Saber YR)
		if ((available_amount($item[ointment of the occult]) == 0
				&& available_amount($item[grapefruit]) == 0
				&& have_effect($effect[mystically oiled]) == 0)
			|| (available_amount($item[oil of expertise]) == 0
				&& available_amount($item[cherry]) == 0
				&& have_effect($effect[expert oiliness]) == 0)
			|| (available_amount($item[philter of phorce]) == 0
				&& available_amount($item[lemon]) == 0
				&& have_effect($effect[phorcefullness]) == 0))
		{
			if (get_property('questM23Meatsmith') == 'unstarted') {
				// Have to start meatsmith quest.
				visit_url('shop.php?whichshop=meatsmith&action=talk');
				run_choice(1);
			}
			if (!can_adventure($location[the skeleton store]))
				abort('Cannot open skeleton store!');
			if ($location[the skeleton store].turns_spent == 0
				&& !$location[the skeleton store].noncombat_queue.contains_text('Skeletons In Store'))

				c2t_freeAdv($location[the skeleton store],-1,'');

			if (!$location[the skeleton store].noncombat_queue.contains_text('Skeletons In Store'))
				abort('Something went wrong at skeleton store.');

			if (get_property('lastCopyableMonster').to_monster() != $monster[novelty tropical skeleton]) {
				//max mp to max latte gulp to fuel buffs
				string temp = `,100 bonus {c2t_pilcrow($item[jurassic parka])}`;
				if (c2t_hccs_haveCinchoDeMayo())
					temp = "";
				maximize(`-tie,-equip {c2t_pilcrow($item[bat wings])},mp,-equip {c2t_pilcrow($item[makeshift garbage shirt])},equip {c2t_pilcrow($item[latte lovers member's mug])},100 bonus {c2t_pilcrow($item[vampyric cloake])},100 bonus {c2t_pilcrow($item[lil' doctor&trade; bag])},100 bonus {c2t_pilcrow($item[kremlin's greatest briefcase])},100 bonus {c2t_pilcrow($item[designer sweatpants])}`+temp+fam,false);
				if (have_equipped($item[jurassic parka])
					&& !c2t_hccs_haveCinchoDeMayo())
				{
					cli_execute("parka spikes");
				}
				c2t_hccs_cartography($location[the skeleton store],$monster[novelty tropical skeleton]);
			}
			//get NEP exp buff with parka or cincho
			if (have_effect($effect[spiced up]) == 0
				&& have_effect($effect[tomes of opportunity]) == 0
				&& have_effect($effect[the best hair you've ever had]) == 0
				&& (get_property("noncombatForcerActive").to_boolean()
					|| c2t_hccs_cinchoDeMayo($skill[cincho: fiesta exit])))
			{
				c2t_freeAdv($location[the neverending party]);
			}

			//get the fruits with nostalgia
			c2t_hccs_fightGodLobster();
		}

		// Tomato in pantry (NOT Saber YR) -- RUNNING AWAY to use nostalgia later
		if (available_amount($item[tomato juice of powerful power]) == 0
			&& available_amount($item[tomato]) == 0
			&& have_effect($effect[tomato power]) == 0)
		{
			if (get_property('lastCopyableMonster').to_monster() != $monster[possessed can of tomatoes]) {
				if (get_property('_latteDrinkUsed').to_boolean())
					cli_execute('latte refill cinnamon pumpkin vanilla');
				//max mp to max latte gulp to fuel buffs
				c2t_hccs_levelingFamiliar(true);
				maximize(`-tie,-equip {c2t_pilcrow($item[bat wings])},mp,-equip {c2t_pilcrow($item[makeshift garbage shirt])},equip {c2t_pilcrow($item[latte lovers member's mug])},100 bonus {c2t_pilcrow($item[vampyric cloake])},100 bonus {c2t_pilcrow($item[lil' doctor&trade; bag])},100 bonus {c2t_pilcrow($item[kremlin's greatest briefcase])},100 bonus {c2t_pilcrow($item[designer sweatpants])}`+fam,false);

				c2t_hccs_cartography($location[the haunted pantry],$monster[possessed can of tomatoes]);
			}
			//get the tomato with nostalgia
			c2t_hccs_fightGodLobster();
		}
	}
	
	if (have_effect($effect[the magical mojomuscular melody]) > 0)
		cli_execute('shrug mojomus');
	if (have_effect($effect[carlweather's cantata of confrontation]) > 0)
		cli_execute('shrug cantata');
	c2t_hccs_getEffect($effect[stevedave's shanty of superiority]);
	
	//sort out familiar
	if (c2t_hccs_levelingFamiliar(false) == $familiar[melodramedary]
		&& available_amount($item[dromedary drinking helmet]) > 0)

		fam = `,equip {c2t_pilcrow($item[dromedary drinking helmet])}`;

	//mumming trunk stats on leveling familiar
	if (item_amount($item[mumming trunk]) > 0) {
		if (my_primestat() == $stat[muscle] && !get_property('_mummeryUses').contains_text('3'))
			cli_execute('mummery mus');
		else if (my_primestat() == $stat[mysticality] && !get_property('_mummeryUses').contains_text('5'))
			cli_execute('mummery mys');
		else if (my_primestat() == $stat[moxie] && !get_property('_mummeryUses').contains_text('7'))
			cli_execute('mummery mox');
	}

	if (my_primestat() == $stat[muscle])
		cli_execute('mood hccs-mus');
	else if (my_primestat() == $stat[mysticality])
		cli_execute('mood hccs-mys');
	else if (my_primestat() == $stat[moxie])
		cli_execute('mood hccs-mox');

	//turtle tamer blessing
	if (my_class() == $class[turtle tamer]) {
		if (have_effect($effect[blessing of the war snapper]) == 0
			&& have_effect($effect[grand blessing of the war snapper]) == 0
			&& have_effect($effect[glorious blessing of the war snapper]) == 0)

			c2t_hccs_haveUse($skill[blessing of the war snapper]);

		if (have_effect($effect[boon of the war snapper]) == 0)
			c2t_hccs_haveUse(1,$skill[spirit boon]);
	}

	cli_execute('mood execute');

	//get crimbo ghost buff from dudes at NEP
	if ((have_familiar($familiar[ghost of crimbo carols])
			&& have_effect($effect[holiday yoked]) == 0)
		|| (my_primestat() == $stat[moxie]
			&& have_effect($effect[unrunnable face]) == 0
			&& item_amount($item[runproof mascara]) == 0))//to nostalgia runproof mascara
	{
		if (get_property('_latteDrinkUsed').to_boolean())
			cli_execute('latte refill cinnamon pumpkin vanilla');
		if (have_familiar($familiar[ghost of crimbo carols]))
			use_familiar($familiar[ghost of crimbo carols]);
		maximize(`-tie,-equip {c2t_pilcrow($item[bat wings])},mainstat,equip {c2t_pilcrow($item[latte lovers member's mug])},-equip {c2t_pilcrow($item[&quot;i voted!&quot; sticker])},100 bonus {c2t_pilcrow($item[designer sweatpants])}`,false);

		//going to grab runproof mascara from globster if moxie instead of having to wait post-kramco
		if (my_primestat() == $stat[moxie])
			c2t_hccs_cartography($location[the neverending party],$monster[party girl]);
		else
			c2t_freeAdv($location[the neverending party],-1,"");
	}

	//nostalgia for moxie stuff and run down remaining glob fights
	while (c2t_hccs_fightGodLobster());

	//moxie needs olives
	if (my_primestat() == $stat[moxie]
		&& have_effect($effect[slippery oiliness]) == 0
		&& item_amount($item[jumbo olive]) == 0)
	{
		//only thing that needs be equipped
		c2t_hccs_levelingFamiliar(true);
		if (!have_equipped($item[fourth of may cosplay saber]))
			equip($item[fourth of may cosplay saber]);
		//TODO evil olive - change to run away from and feel nostagic+envy+free kill another thing to save a saber use for spell test
		if (!c2t_hccs_combatLoversLocket($monster[evil olive])
			&& !c2t_hccs_genie($monster[evil olive]))

			abort("Failed to fight evil olive");
	}

	c2t_hccs_levelingFamiliar(false);

	//summon tentacle
	if (have_skill($skill[evoke eldritch horror])
		&& !get_property('_eldritchHorrorEvoked').to_boolean())
	{
		maximize(`-tie,mainstat,100exp,-equip {c2t_pilcrow($item[makeshift garbage shirt])},10000 bonus {c2t_pilcrow($item[designer sweatpants])}`+fam,false);
		restore_mp(80);//need enough mp to cast summon and for combat
		c2t_hccs_haveUse(1,$skill[evoke eldritch horror]);
		run_combat();
	}

	//science tent tentacle
	if (get_property("lastGuildStoreOpen").to_int() == my_ascensions()
		&& get_property("questG02Whitecastle") == "started"
		&& !get_property('_eldritchTentacleFought').to_boolean())
	{
		maximize(`-tie,mainstat,100exp,-equip {c2t_pilcrow($item[makeshift garbage shirt])},10000 bonus {c2t_pilcrow($item[designer sweatpants])}`+fam,false);
		c2t_hccs_preAdv();
		visit_url("place.php?whichplace=forestvillage&action=fv_scientist",false);
		foreach i,x in available_choice_options() if (x.contains_text("fight that tentacle"))
			run_choice(i);
		run_combat();
	}

	//speakeasy / oliver's place
	if (get_property("ownsSpeakeasy").to_boolean()
		&& get_property("_speakeasyFreeFights").to_int() < 3)
	{
		int start = my_turncount();
		while (get_property("_speakeasyFreeFights").to_int() < 3 && start == my_turncount()) {
			if (get_property("_sourceTerminalPortscanUses").to_int() > 0)
				maximize(`-tie,-equip {c2t_pilcrow($item[bat wings])},mainstat,exp,-equip {c2t_pilcrow($item[makeshift garbage shirt])},-equip {c2t_pilcrow($item[kramco sausage-o-matic&trade;])},-equip {c2t_pilcrow($item[&quot;i voted!&quot; sticker])},100 bonus {c2t_pilcrow($item[designer sweatpants])}`+fam,false);
			else
				maximize(`-tie,-equip {c2t_pilcrow($item[bat wings])},mainstat,100exp,-equip {c2t_pilcrow($item[makeshift garbage shirt])},-equip {c2t_pilcrow($item[kramco sausage-o-matic&trade;])},-equip {c2t_pilcrow($item[&quot;i voted!&quot; sticker])},10000 bonus {c2t_pilcrow($item[designer sweatpants])}`+fam,false);
			string temp = get_property("_speakeasyFreeFights");
			adv1($location[an unusually quiet barroom brawl]);//don't change from adv1(); need to update tracker even if adventure was used
			//mafia doesn't always increment this properly
			if (temp == get_property("_speakeasyFreeFights"))
				set_property("_speakeasyFreeFights",temp.to_int()+1);
		}
		if (my_turncount() > start)
			abort("a turn was used in the speakeasy; tracking may have broke");
	}

	//closed-circuit pay phone
	c2t_hccs_shadowRiftFights();

	// Your Mushroom Garden
	if ((get_campground() contains $item[packet of mushroom spores])
		&& get_property('_mushroomGardenFights').to_int() == 0)
	{
		maximize(`-tie,mainstat,-equip {c2t_pilcrow($item[makeshift garbage shirt])},-equip {c2t_pilcrow($item[kramco sausage-o-matic&trade;])},-equip {c2t_pilcrow($item[&quot;i voted!&quot; sticker])},100 bonus {c2t_pilcrow($item[designer sweatpants])}`+fam,false);
		c2t_freeAdv($location[your mushroom garden],-1,"");
	}

	c2t_hccs_wandererFight();//shouldn't do kramco

	//setup for NEP and backup fights
	string doc,garbage,kramco,darts;

	if (c2t_hccs_haveBackupCamera()
		&& get_property('backupCameraMode') != 'ml')

		cli_execute('backupcamera ml');

	if (!get_property('_gingerbreadMobHitUsed').to_boolean())
		c2t_hccs_printInfo("Running backup camera and Neverending Party fights");

	set_location($location[the neverending party]);

	int start = my_turncount();
	//NEP loop //neverending party and backup camera fights
	while (get_property("_neverendingPartyFreeTurns").to_int() < 10
		|| c2t_hccs_freeKillsLeft() > 0
		|| c2t_hccs_asdonKillLeft())
	{
		if (my_turncount() > start) {
			c2t_hccs_printWarn("a turn was used in the neverending party loop");
			c2t_hccs_printWarn("aborting in case mafia tracking broke somewhere or some unforseen thing happened");
			c2t_hccs_printWarn("if ALL the stat tests can be completed in 1 turn right now, it may be better to do those manually then rerun this");
			c2t_hccs_printWarn("this may be safe to run again, but probably best to not if turns keep being used here");
			abort("be sure to report if this problem persists");
		}

		// -- combat logic --
		//darts free kill attempts
		if (available_amount($item[everfull dart holster]) > 0
			&& get_property('_neverendingPartyFreeTurns').to_int() == 10
			&& have_effect($effect[everything looks red]) == 0)
		{
			darts = `,1000 bonus {c2t_pilcrow($item[everfull dart holster])}`;
		}
		else
			darts = "";

		//use doc bag kills first after free fights
		if (available_amount($item[lil' doctor&trade; bag]) > 0
			&& get_property('_neverendingPartyFreeTurns').to_int() == 10
			&& get_property('_chestXRayUsed').to_int() < 3)
		{
			doc = `,equip {c2t_pilcrow($item[lil' doctor&trade; bag])}`;
		}
		else
			doc = "";

		if (c2t_hccs_levelingFamiliar(false) != $familiar[melodramedary])
			fam = "";

		//parka as final free kill
		if (available_amount($item[jurassic parka]) > 0
			&& get_property("_neverendingPartyFreeTurns").to_int() == 10
			&& c2t_hccs_freeKillsLeft() == 1
			&& have_effect($effect[everything looks yellow]) == 0)
		{
			equip($item[jurassic parka]);
			cli_execute("parka acid");
			garbage = ",-shirt";//commandeering garbage for parka for now
		}
		//backup fights will turns this off after a point, so keep turning it on
		else if (c2t_hccs_haveGarbageTote()
			&& get_property('garbageShirtCharge').to_int() > 0)
		{
			garbage = `,equip {c2t_pilcrow($item[makeshift garbage shirt])}`;
		}
		else
			garbage = "";

		// -- using things as they become available --
		//use runproof mascara ASAP if moxie for more stats
		if (my_primestat() == $stat[moxie]
			&& have_effect($effect[unrunnable face]) == 0
			&& item_amount($item[runproof mascara]) > 0)
		{
			use(1,$item[runproof mascara]);
		}

		//turtle tamer turtle
		if (my_class() == $class[turtle tamer]
			&& have_effect($effect[gummi-grin]) == 0)
		{
			c2t_hccs_haveUse($item[gummi turtle]);
		}

		//eat CER pizza ASAP
		if (c2t_hccs_havePizzaCube()
			&& have_effect($effect[synthesis: collection]) == 0//skip pizza if synth item
			&& have_effect($effect[certainty]) == 0
			&& item_amount($item[electronics kit]) > 0
			&& item_amount($item[middle of the road&trade; brand whiskey]) > 0)
		{
			c2t_hccs_pizzaCube($effect[certainty]);
		}

		//drink hot socks ASAP
		if (!get_property("c2t_hccs_disable.vipHotSocks").to_boolean()
			&& have_effect($effect[[1701]hip to the jive]) == 0
			&& my_meat() > 5000)
		{
			cli_execute('shrug stevedave');
			c2t_hccs_getEffect($effect[ode to booze]);
			cli_execute('drink hot socks');
			cli_execute('shrug ode to booze');
			c2t_hccs_getEffect($effect[stevedave's shanty of superiority]);
		}

		//drink astral pilsners once level 11; saving 1 for use in mime army shotglass post-run
		if (my_level() >= 11
			&& item_amount($item[astral pilsner]) == 6)
		{
			cli_execute('shrug Shanty of Superiority');
			c2t_hccs_haveUse(1,$skill[the ode to booze]);
			drink(5,$item[astral pilsner]);
			cli_execute('shrug Ode to Booze');
			c2t_hccs_haveUse(1,$skill[stevedave's shanty of superiority]);
		}

		//explicitly buying and using range as it rarely bugs out otherwise
		if (!(get_campground() contains $item[dramatic&trade; range])
			&& my_meat() >= (have_skill($skill[five finger discount])?950:1000))//five-finger discount
		{
			retrieve_item($item[dramatic&trade; range]);
			use($item[dramatic&trade; range]);
		}
		//potion buffs when enough meat obtained
		if (have_effect($effect[tomato power]) == 0
			&& (get_campground() contains $item[dramatic&trade; range]))
		{
			if (my_primestat() == $stat[muscle]) {
				c2t_hccs_getEffect($effect[phorcefullness]);
				c2t_hccs_getEffect($effect[stabilizing oiliness]);
			}
			else if (my_primestat() == $stat[mysticality]) {
				c2t_hccs_getEffect($effect[mystically oiled]);
				c2t_hccs_getEffect($effect[expert oiliness]);
			}
			else if (my_primestat() == $stat[moxie]) {
				c2t_hccs_getEffect($effect[superhuman sarcasm]);
				c2t_hccs_getEffect($effect[slippery oiliness]);
			}
			c2t_hccs_getEffect($effect[tomato power]);
			c2t_assert(have_effect($effect[tomato power]) > 0,'It somehow missed again.');

			if (my_turncount() > start) {
				print(`detected {my_turncount()-start} turns used for crafting`);
				start = my_turncount();
			}
		}

		// -- setup and combat itself --
		//hopefully stop it before a possible break if my logic is off
		if (c2t_hccs_haveBackupCamera()
			&& c2t_hccs_havePocketProfessor()
			&& c2t_hccs_pocketProfessorLectures() == 0
			&& c2t_hccs_backupCameraLeft() <= 1)
		{
			abort('Pocket professor has not been used yet, while backup camera charges left is '+c2t_hccs_backupCameraLeft());
		}
		//professor chain sausage goblins in NEP first thing if no backup camera
		if (!c2t_hccs_haveBackupCamera()
			&& c2t_hccs_havePocketProfessor()
			&& c2t_hccs_pocketProfessorLectures() == 0)
		{
			if (c2t_hccs_haveGarbageTote())
				garbage = `,equip {c2t_pilcrow($item[makeshift garbage shirt])}`;
			use_familiar($familiar[pocket professor]);
			maximize(`-tie,mainstat,equip {c2t_pilcrow($item[kramco sausage-o-matic&trade;])},100familiar weight,100 bonus {c2t_pilcrow($item[designer sweatpants])}`+garbage,false);
			restore_hp(my_maxhp());
		}
		//9+ professor copies, after getting exp buff from NC and used sauceror potions
		else if (c2t_hccs_havePocketProfessor()
			&& c2t_hccs_pocketProfessorLectures() == 0
			&& c2t_hccs_backupCameraLeft() > 0
			&& (have_effect($effect[spiced up]) > 0
				|| have_effect($effect[tomes of opportunity]) > 0
				|| have_effect($effect[the best hair you've ever had]) > 0)
			&& have_effect($effect[tomato power]) > 0
			//target monster for professor copies. using back up camera to bootstrap
			&& get_property('lastCopyableMonster').to_monster() == $monster[sausage goblin])
		{
			if (c2t_hccs_haveGarbageTote())
				garbage = `,equip {c2t_pilcrow($item[makeshift garbage shirt])}`;
			use_familiar($familiar[pocket professor]);
			maximize(`-tie,mainstat,equip {c2t_pilcrow($item[kramco sausage-o-matic&trade;])},100familiar weight,100 bonus {c2t_pilcrow($item[designer sweatpants])},equip {c2t_pilcrow($item[backup camera])}`,false);
			restore_hp(my_maxhp());
		}
		//fish for latte carrot ingredient with backup fights
		else if ((have_effect($effect[spiced up]) > 0
				|| have_effect($effect[tomes of opportunity]) > 0
				|| have_effect($effect[the best hair you've ever had]) > 0)
			&& (!c2t_hccs_havePocketProfessor()
				|| (c2t_hccs_havePocketProfessor()
					&& c2t_hccs_pocketProfessorLectures() > 0))
			&& !get_property('latteUnlocks').contains_text('carrot')
			&& c2t_hccs_backupCameraLeft() > 0
			//target monster
			&& get_property('lastCopyableMonster').to_monster() == $monster[sausage goblin])
		{
			//NEP monsters give twice as much base exp as sausage goblins, so keep at least as many shirt charges as fights remaining in NEP
			if (c2t_hccs_haveGarbageTote()
				&& get_property('garbageShirtCharge').to_int() < 10+c2t_hccs_freeKillsLeft())
			{
				garbage = `,-equip {c2t_pilcrow($item[makeshift garbage shirt])}`;
			}
			maximize(`-tie,-equip {c2t_pilcrow($item[bat wings])},mainstat,exp,equip {c2t_pilcrow($item[latte lovers member's mug])},equip {c2t_pilcrow($item[backup camera])},100 bonus {c2t_pilcrow($item[designer sweatpants])}`+garbage+fam,false);
			c2t_freeAdv($location[the dire warren],-1,"");
			continue;//don't want to fall into NEP in this state
		}
		//inital and post-latte backup fights
		else if (c2t_hccs_backupCameraLeft() > 0
			&& get_property('lastCopyableMonster').to_monster() == $monster[sausage goblin])
		{
			//only use kramco offhand if target is sausage goblin to not mess things up
			if (get_property('lastCopyableMonster').to_monster() == $monster[sausage goblin])
				kramco = `,equip {c2t_pilcrow($item[kramco sausage-o-matic&trade;])}`;
			else
				kramco = "";

			//NEP monsters give twice as much base exp as sausage goblins, so keep at least as many shirt charges as fights remaining in NEP
			if (c2t_hccs_haveGarbageTote()
				&& get_property('garbageShirtCharge').to_int() < 10+c2t_hccs_freeKillsLeft())
			{
				garbage = `,-equip {c2t_pilcrow($item[makeshift garbage shirt])}`;
			}
			maximize(`-tie,-equip {c2t_pilcrow($item[bat wings])},mainstat,exp,equip {c2t_pilcrow($item[backup camera])},100 bonus {c2t_pilcrow($item[designer sweatpants])}`+kramco+garbage+fam,false);
		}
		//rest of the free NEP fights
		else
			maximize(`-tie,-equip {c2t_pilcrow($item[bat wings])},mainstat,exp,equip {c2t_pilcrow($item[kramco sausage-o-matic&trade;])},100 bonus {c2t_pilcrow($item[designer sweatpants])}`+garbage+fam+doc+darts,false);

		//asdon as the final final free kill
		if (get_property("_neverendingPartyFreeTurns").to_int() == 10
			&& c2t_hccs_freeKillsLeft() == 0
			&& c2t_hccs_asdonKillLeft()
			&& !c2t_hccs_asdonFill(100))
		{
			c2t_hccs_printInfo("couldn't fuel up asdon martin fully for its free kill");
			break;
		}

		c2t_freeAdv($location[the neverending party],-1,"");
	}

	c2t_hccs_shadowRiftBoss();

	cli_execute('mood apathetic');
}

boolean c2t_hccs_wandererFight() {
	//don't want to be doing wanderer whilst feeling lost
	if (have_effect($effect[feeling lost]) > 0) {
		c2t_hccs_printInfo("Currently feeling lost, so skipping wanderers.");
		return false;
	}

	string append = `,-equip {c2t_pilcrow($item[makeshift garbage shirt])},exp`;
	if (c2t_isVoterNow())
		append += `,equip {c2t_pilcrow($item[&quot;i voted!&quot; sticker])}`;
	//kramco should not be done here when only the coil wire test is done, otherwise the professor chain will fail
	else if (c2t_isSausageGoblinNow() && get_property('csServicesPerformed') != TEST_NAME[TEST_COIL_WIRE])
		append += `,equip {c2t_pilcrow($item[kramco sausage-o-matic&trade;])}`;
	else
		return false;

	if (turns_played() == 0)
		c2t_hccs_getEffect($effect[feeling excited]);

	c2t_hccs_printInfo("Running wanderer fight");
	//saving last maximizer string and familiar stuff; outfits generally break here
	string[int] maxstr = split_string(get_property("maximizerMRUList"),";");
	familiar nowFam = my_familiar();
	item nowEquip = equipped_item($slot[familiar]);

	if (c2t_hccs_levelingFamiliar(false) == $familiar[melodramedary])
		append += `,equip {c2t_pilcrow($item[dromedary drinking helmet])}`;

	set_location($location[the neverending party]);
	maximize(`-tie,mainstat,exp,100 bonus {c2t_pilcrow($item[designer sweatpants])}`+append,false);
	c2t_freeAdv($location[the neverending party],-1,"");

	//hopefully restore to previous state without outfits
	use_familiar(nowFam);
	maximize(maxstr[0],false);
	equip($slot[familiar],nowEquip);

	return true;
}

void c2t_hccs_shadowRiftFights() {
	if (!c2t_hccs_haveClosedCircuitPayPhone())
		return;

	if (!get_property("_shadowAffinityToday").to_boolean()
		|| get_property("questRufus") == "step1")
	{
		use($item[closed-circuit pay phone]);
	}

	if (get_property("questRufus") == "unstarted")
		return;

	string fam = "";
	if (c2t_hccs_levelingFamiliar(false) == $familiar[melodramedary]
		&& available_amount($item[dromedary drinking helmet]) > 0)
	{
		fam = `,equip {c2t_pilcrow($item[dromedary drinking helmet])}`;
	}
	string maxStr = `-tie,-equip {c2t_pilcrow($item[bat wings])},mainstat,100exp,-equip {c2t_pilcrow($item[makeshift garbage shirt])},-equip {c2t_pilcrow($item[kramco sausage-o-matic&trade;])},-equip {c2t_pilcrow($item[&quot;i voted!&quot; sticker])},100 bonus {c2t_pilcrow($item[jurassic parka])},10000 bonus {c2t_pilcrow($item[designer sweatpants])}`+fam;

	//shadow affinity fights
	while (have_effect($effect[shadow affinity]) > 0)
	{
		maximize(maxStr,false);
		restore_mp(100);
		c2t_freeAdv($location[shadow rift (the right side of the tracks)]);
	}
	set_location($location[none]);

	//handle artifact quest
	if (get_property("encountersUntilSRChoice") == "0"
		&& get_property("rufusQuestType") == "artifact")
	{
		c2t_freeAdv($location[shadow rift]);
		set_location($location[none]);
	}

	//turn in quest if done
	if (get_property("questRufus") == "step1")
		use($item[closed-circuit pay phone]);
	else if (get_property("rufusQuestType") != "entity")
		c2t_hccs_printWarn("failed to finish Rufus quest?");
}

void c2t_hccs_shadowRiftBoss() {
	if (!c2t_hccs_haveClosedCircuitPayPhone())
		return;

	//turn in finished quest
	if (get_property("questRufus") == "step1") {
		use($item[closed-circuit pay phone]);
		return;
	}

	//make sure NC is next
	if (get_property("encountersUntilSRChoice") != "0")
		return;

	//handle non-boss NC just in case
	switch (get_property("rufusQuestType")) {
		default:
			return;
		case "artifact":
			c2t_freeAdv($location[shadow rift]);
			set_location($location[none]);
			use($item[closed-circuit pay phone]);
			return;
		case "entity":
	}

	string fam = "";
	if (c2t_hccs_levelingFamiliar(false) == $familiar[melodramedary]
		&& available_amount($item[dromedary drinking helmet]) > 0)
	{
		fam = `,equip {c2t_pilcrow($item[dromedary drinking helmet])}`;
	}
	string maxStr = `-tie,mainstat,exp,-equip {c2t_pilcrow($item[makeshift garbage shirt])},-equip {c2t_pilcrow($item[kramco sausage-o-matic&trade;])},-equip {c2t_pilcrow($item[&quot;i voted!&quot; sticker])},100 bonus {c2t_pilcrow($item[jurassic parka])},100 bonus {c2t_pilcrow($item[designer sweatpants])}`+fam;

	//bosses
	boolean fullhp = false;
	switch (get_property("rufusQuestTarget").to_monster()) {
		case $monster[shadow orrery]:
			maxStr = "melee,"+maxStr;
			break;
		case $monster[shadow scythe]:
		case $monster[shadow spire]:
			fullhp = true;
			break;
	}

	maximize(maxStr,false);
	if (fullhp)
		restore_hp(to_int(my_maxhp()*0.95));
	restore_mp(100);
	c2t_freeAdv($location[shadow rift]);
	set_location($location[none]);

	//turn in quest if done
	if (get_property("questRufus") == "step1")
		use($item[closed-circuit pay phone]);
	else
		c2t_hccs_printWarn("failed to finish Rufus quest?");
}

//switches to leveling familiar and returns which it is
familiar c2t_hccs_levelingFamiliar(boolean safeOnly) {
	familiar out;

	if (c2t_hccs_melodramedary()
		&& c2t_hccs_melodramedarySpit() < 100
		&& !get_property("csServicesPerformed").contains_text(TEST_NAME[TEST_WEAPON]))
	{
		out = $familiar[melodramedary];
	}
	else if (!safeOnly) {
		if (c2t_hccs_shorterOrderCook()
			&& !get_property("csServicesPerformed").contains_text(TEST_NAME[TEST_FAMILIAR])
			&& item_amount($item[short stack of pancakes]) == 0)
		{
			out = $familiar[shorter-order cook];
			//give cook's combat bonus familiar exp to professor
			if (my_familiar() != out && have_familiar($familiar[pocket professor]))
				use_familiar($familiar[pocket professor]);
		}
		else
			out = c2t_priority($familiars[jill-of-all-trades,patriotic eagle,galloping grill,hovering sombrero,blood-faced volleyball]);
	}
	else
		out = c2t_priority($familiars[hovering sombrero,blood-faced volleyball]);

	use_familiar(out);
	return out;
}

boolean c2t_hccs_unlockGuildMoxie() {
	if (my_primestat() != $stat[moxie])
		return false;
	if (available_amount($item[tearaway pants]) == 0)
		return false;
	if (get_property("lastGuildStoreOpen").to_int() == my_ascensions())
		return true;

	c2t_hccs_printInfo("unlocking guild");

	item oldPants = equipped_item($slot[pants]);

	equip($item[tearaway pants]);
	visit_url("guild.php?place=challenge",false);
	//equip(oldPants);

	return get_property("lastGuildStoreOpen").to_int() == my_ascensions();
}

boolean c2t_hccs_unlockDistantWoods() {
	if (get_property("questG02Whitecastle") != "started") {
		c2t_hccs_printInfo("unlocking Distant Woods");
		try {
			while (get_property("questG02Whitecastle") != "started") {
				visit_url("guild.php?place=paco",false);
				run_turn();
			}
		}
		finally {//really, really don't want to skip this and being lazy about it as it's not tracked otherwise
			visit_url("place.php?whichplace=forestvillage&action=fv_scientist",false);
			foreach i,x in available_choice_options() if (x.contains_text("Great!"))
				run_choice(i);
		}
	}

	return true;
}


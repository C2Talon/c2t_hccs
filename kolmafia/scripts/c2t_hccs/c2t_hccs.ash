//c2t hccs
//c2t

since r26092;//cosmic bowling ball

import <c2t_hccs_lib.ash>
import <c2t_hccs_resources.ash>
import <c2t_hccs_properties.ash>
import <c2t_hccs_aux.ash>
import <c2t_cartographyHunt.ash>
import <c2t_lib.ash>
import <c2t_cast.ash>
import <canadv.ash>

int START_TIME = now_to_int();


//wtb enum
int TEST_HP = 1;
int TEST_MUS = 2;
int TEST_MYS = 3;
int TEST_MOX = 4;
int TEST_FAMILIAR = 5;
int TEST_WEAPON = 6;
int TEST_SPELL = 7;
int TEST_NONCOMBAT = 8;
int TEST_ITEM = 9;
int TEST_HOT_RES = 10;
int TEST_COIL_WIRE = 11;


string[12] TEST_NAME;
TEST_NAME[TEST_COIL_WIRE] = "Coil Wire";
TEST_NAME[TEST_HP] = "Donate Blood";
TEST_NAME[TEST_MUS] = "Feed The Children";
TEST_NAME[TEST_MYS] = "Build Playground Mazes";
TEST_NAME[TEST_MOX] = "Feed Conspirators";
TEST_NAME[TEST_ITEM] = "Make Margaritas";
TEST_NAME[TEST_HOT_RES] = "Clean Steam Tunnels";
TEST_NAME[TEST_FAMILIAR] = "Breed More Collies";
TEST_NAME[TEST_NONCOMBAT] = "Be a Living Statue";
TEST_NAME[TEST_WEAPON] = "Reduce Gazelle Population";
TEST_NAME[TEST_SPELL] = "Make Sausage";


void c2t_hccs_init();
void c2t_hccs_exit();
boolean c2t_hccs_preCoil();
boolean c2t_hccs_buffExp();
boolean c2t_hccs_levelup();
boolean c2t_hccs_allTheBuffs();
boolean c2t_hccs_semirareItem();
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
boolean c2t_hccs_testDone(int test);
void c2t_hccs_doTest(int test);
void c2t_hccs_fights();
boolean c2t_hccs_wandererFight();
int c2t_hccs_testTurns(int test);
boolean c2t_hccs_thresholdMet(int test);
void c2t_hccs_mod2log(string str);
void c2t_hccs_printRunTime(boolean final);
void c2t_hccs_printRunTime() c2t_hccs_printRunTime(false);
boolean c2t_hccs_fightGodLobster();
void c2t_hccs_breakfast();
void c2t_hccs_printTestData();
void c2t_hccs_testData(string testType,int testNum,int turnsTaken,int turnsExpected);


void main() {
	c2t_assert(my_path() == "Community Service","Not in Community Service. Aborting.");

	try {
		c2t_hccs_init();
		
		c2t_hccs_testHandler(TEST_COIL_WIRE);

		//TODO maybe reorder stat tests based on hardest to achieve for a given class or mainstat
		print('Checking test ' + TEST_MOX + ': ' + TEST_NAME[TEST_MOX],'blue');
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
		if (get_property('camelSpit').to_int() < 93 && !get_property("_c2t_hccs_earlySpitWarn").to_boolean()) {
			set_property("_c2t_hccs_earlySpitWarn","true");
			abort('Camel spit only at '+get_property('camelSpit')+'%');
		}
		//so this doesn't warn if ran after using spit for weapon test
		set_property("_c2t_hccs_earlySpitWarn","true");

		c2t_hccs_testHandler(TEST_ITEM);
		c2t_hccs_testHandler(TEST_FAMILIAR);
		c2t_hccs_testHandler(TEST_HOT_RES);
		c2t_hccs_testHandler(TEST_NONCOMBAT);
		c2t_hccs_testHandler(TEST_WEAPON);
		c2t_hccs_testHandler(TEST_SPELL);

		//final service here
		if (!get_property('c2t_hccs_skipFinalService').to_boolean())
			c2t_hccs_doTest(30);
		
		print('Should be done with the Community Service run','blue');
	}
	finally
		c2t_hccs_exit();
}


void c2t_hccs_printRunTime(boolean f) {
	int t = now_to_int() - START_TIME;
	print(`c2t_hccs {f?"took":"has taken"} {t/60000} minute(s) {(t%60000)/1000.0} second(s) to execute{f?"":" so far"}.`,"blue");
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
	if (my_primestat() == $stat[moxie] && get_property("_rhinestonesAcquired").to_boolean())
		c2t_hccs_haveUse(1,$skill[acquire rhinestones]);

	//peppermint garden
	if (c2t_hccs_peppermintGarden())
		cli_execute("garden pick");
}




boolean c2t_hccs_fightGodLobster() {
	if (!have_familiar($familiar[god lobster]))
		return false;

	if (get_property('_godLobsterFights').to_int() < 3) {
		use_familiar($familiar[god lobster]);
		maximize("mainstat,-equip garbage shirt",false);

		// fight and get equipment
		c2t_setChoice(1310,1);//get equipment
		if (my_hp() < 0.5 * my_maxhp())
			visit_url('clan_viplounge.php?where=hottub');

		item temp = c2t_priority($item[god lobster's ring],$item[god lobster's scepter],$item[astral pet sweater]);
		if (temp != $item[none])
			equip($slot[familiar],temp);

		//combat & choice
		visit_url('main.php?fightgodlobster=1');
		run_turn();
		if (choice_follows_fight())
			run_choice(-1);
		c2t_setChoice(1310,0);//unset

		//should have gotten runproof mascara as moxie from globster
		if (my_primestat() == $stat[moxie])
			c2t_hccs_getEffect($effect[unrunnable face]);

		return true;
	}
	return false;
}

void c2t_hccs_testHandler(int test) {
	print('Checking test ' + test + ': ' + TEST_NAME[test],'blue');
	if (get_property('csServicesPerformed').contains_text(TEST_NAME[test]))
		return;

	string type;
	int turns,before,expected;

	//combat familiars will slaughter everything; so make sure they're inactive at the start of test sections, since not every combat bothers with familiar checks
	if ($familiars[shorter-order cook,left-hand man,imitation crab] contains my_familiar())
		use_familiar($familiar[melodramedary]);

	//wanderer fight(s) before prepping stuff
	while (my_turncount() >= 60 && c2t_hccs_wandererFight());

	print('Running pre-'+TEST_NAME[test]+' stuff...','blue');
	switch (test) {
		case TEST_HP:
			c2t_hccs_preHp();
			type = "HP";
			break;
		case TEST_MUS:
			c2t_hccs_preMus();
			type = "mus";
			break;
		case TEST_MYS:
			c2t_hccs_preMys();
			type = "mys";
			break;
		case TEST_MOX:
			c2t_hccs_preMox();
			type = "mox";
			break;
		case TEST_FAMILIAR:
			c2t_hccs_preFamiliar();
			type = "familiar";
			break;
		case TEST_WEAPON:
			c2t_hccs_preWeapon();
			type = "weapon";
			break;
		case TEST_SPELL:
			c2t_hccs_preSpell();
			type = "spell";
			break;
		case TEST_NONCOMBAT:
			c2t_hccs_preNoncombat();
			type = "noncombat";
			break;
		case TEST_ITEM:
			c2t_hccs_preItem();
			type = "item";
			break;
		case TEST_HOT_RES:
			c2t_hccs_preHotRes();
			type = "hot resist";
			break;
		case TEST_COIL_WIRE:
			c2t_hccs_preCoil();
			break;
		default:
			abort('Something went horribly wrong with the test handler');
	}
	if (get_property("c2t_hccs_haltBeforeTest").to_boolean())
		abort(`Halting. Double-check test {test}: {TEST_NAME[test]} ({type})`);

	expected = turns = c2t_hccs_testTurns(test);
	if (turns < 1) {
		if (test > 4) //ignore over-capping stat tests
			print(`Notice: over-capping the {type} test by {1-turns} {1-turns==1?"turn":"turns"} worth of resources.`,'blue');
		turns = 1;
	}

	if (!c2t_hccs_thresholdMet(test))
		abort(`Pre-{TEST_NAME[test]} ({type}) test fail. Currently only can complete the test in {turns} {turns==1?"turn":"turns"}.`);

	if (test != TEST_COIL_WIRE)
		print(`Test {test}: {TEST_NAME[test]} ({type}) is at or below the threshold at {turns} {turns==1?"turn":"turns"}. Running the task...`);
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


//store results of tests
void c2t_hccs_testData(string testType,int testNum,int turnsTaken,int turnsExpected) {
	if (testNum == TEST_COIL_WIRE)
		return;

	set_property("_c2t_hccs_testData",get_property("_c2t_hccs_testData")+(get_property("_c2t_hccs_testData") == ""?"":";")+`{testType},{testNum},{turnsTaken},{turnsExpected}`);
}

//print results of tests
void c2t_hccs_printTestData() {
	string [int] d;
	print("Summary of tests:");
	foreach i,x in split_string(get_property("_c2t_hccs_testData"),";") {
		d = split_string(x,",");
		print(`{d[0]} test took {d[2]} turn(s){to_int(d[1]) > 4 && to_int(d[3]) < 1?"; it's being overcapped by "+(1-to_int(d[3]))+" turn(s) of resources":""}`);
	}
	print(`{my_daycount()}/{turns_played()} turns as {my_class()}`);
	print(`Organ use: {my_fullness()}/{my_inebriety()}/{my_spleen_use()}`);
}

//precursor to facilitate using only as many resources as needed and not more
int c2t_hccs_testTurns(int test) {
	int num;
	switch (test) {
		default:
			abort('Something broke with checking turns on test '+test);
		case TEST_HP:
			return (60 - (my_maxhp() - my_buffedstat($stat[muscle]) + 3)/30);
		case TEST_MUS:
			return (60 - (my_buffedstat($stat[muscle]) - my_basestat($stat[muscle]))/30);
		case TEST_MYS:
			return (60 - (my_buffedstat($stat[mysticality]) - my_basestat($stat[mysticality]))/30);
		case TEST_MOX:
			return (60 - (my_buffedstat($stat[moxie]) - my_basestat($stat[moxie]))/30);
		case TEST_FAMILIAR:
			return (60 - floor((numeric_modifier('familiar weight')+familiar_weight(my_familiar()))/5));
		case TEST_WEAPON:
			num = (have_effect($effect[bow-legged swagger]) > 0?25:50);
			return (60 - floor(numeric_modifier('weapon damage') / num + 0.001) - floor(numeric_modifier('weapon damage percent') / num + 0.001));
		case TEST_SPELL:
			return (60 - floor(numeric_modifier('spell damage') / 50 + 0.001) - floor(numeric_modifier('spell damage percent') / 50 + 0.001));
		case TEST_NONCOMBAT:
			num = -round(numeric_modifier('combat rate'));
			return (60 - (num > 25?(num-25)*3+15:num/5*3));
		case TEST_ITEM:
			return (60 - floor(numeric_modifier('Booze Drop') / 15 + 0.001) - floor(numeric_modifier('Item Drop') / 30 + 0.001));
		case TEST_HOT_RES:
			return (60 - floor(numeric_modifier('hot resistance')));
		case TEST_COIL_WIRE:
			return 60;
		case 30://final service in case that gets checked
			return 0;
	}
}

boolean c2t_hccs_thresholdMet(int test) {
	if (test == TEST_COIL_WIRE || test == 30)
		return true;

	string [int] arr = split_string(get_property('c2t_hccs_thresholds'),",");

	if (count(arr) == 10 && arr[test-1].to_int() > 0 && arr[test-1].to_int() <= 60)
		return (c2t_hccs_testTurns(test) <= arr[test-1].to_int());
	else {
		print("Warning: the c2t_hccs_thresholds property is broken for this test; defaulting to a 1-turn threshold.","red");
		return (c2t_hccs_testTurns(test) <= 1);
	}
}


//sets and backup some settings on start
void c2t_hccs_init() {
	//buy from NPCs
	set_property('_saved_autoSatisfyWithNPCs',get_property('autoSatisfyWithNPCs'));
	set_property('autoSatisfyWithNPCs','true');
	//buy from coinmasters/hermit
	set_property('_saved_autoSatisfyWithCoinmasters',get_property('autoSatisfyWithCoinmasters'));
	set_property('autoSatisfyWithCoinmasters','true');
	//choice adventure script
	set_property('_saved_choiceAdventureScript',get_property('choiceAdventureScript'));
	set_property('choiceAdventureScript','c2t_hccs_choices.ash');
	//make sure to have some user-defined hp recovery since I don't want to think about it
	if (get_property("recoveryScript") == "" && get_property('hpAutoRecovery').to_float() <= 0.5) {
		set_property('_saved_hpAutoRecovery',get_property('hpAutoRecovery'));
		set_property('hpAutoRecovery','0.6');
	}
	//no mana burn/every mp is sacred
	set_property('_saved_manaBurningThreshold',get_property('manaBurningThreshold'));
	set_property('manaBurningThreshold','-0.05');
	//custom combat script
	if (get_property('customCombatScript') != "c2t_hccs")
		set_property('_saved_customCombatScript',get_property('customCombatScript'));
	set_property('customCombatScript',"c2t_hccs");
	
	visit_url('council.php');// Initialize council.
}

//restore settings on exit
void c2t_hccs_exit() {
	set_property('autoSatisfyWithNPCs',get_property('_saved_autoSatisfyWithNPCs'));
	set_property('autoSatisfyWithCoinmasters',get_property('_saved_autoSatisfyWithCoinmasters'));
	set_property('choiceAdventureScript',get_property('_saved_choiceAdventureScript'));

	if (get_property('_saved_hpAutoRecovery') != "")
		set_property('hpAutoRecovery',get_property('_saved_hpAutoRecovery'));
	set_property('manaBurningThreshold',get_property('_saved_manaBurningThreshold'));

	//only want to restore combat script if CS finished, as it's needed for manual interventions
	if (get_property("csServicesPerformed").split_string(",").count() == 11 && get_property('_saved_customCombatScript') != "")
		set_property('customCombatScript',get_property('_saved_customCombatScript'));
	//don't want CS moods running during manual intervention or when fully finished
	cli_execute('mood apathetic');

	if (get_property("csServicesPerformed").split_string(",").count() == 11)
		c2t_hccs_printTestData();

	if (get_property("shockingLickCharges").to_int() > 0)
		print(`Info: shocking lick charge count from batteries is {get_property("shockingLickCharges")}`,"blue");

	c2t_hccs_printRunTime(true);
}

boolean c2t_hccs_preCoil() {
	//get a grain of sand for pizza if muscle class
	if (available_amount($item[beach comb]) > 0
		&& my_primestat() == $stat[muscle]
		&& available_amount($item[grain of sand]) == 0
		&& available_amount($item[gnollish autoplunger]) == 0
		) {
		print("Getting grain of sand from the beach","blue");
		while (get_property('_freeBeachWalksUsed').to_int() < 5 && available_amount($item[grain of sand]) == 0)
			//arbitrary location
			cli_execute('beach wander 8;beach comb 8 8');
		cli_execute('beach exit');
		c2t_assert(available_amount($item[grain of sand]) > 0,"Did not obtain a grain of sand for pizza on muscle class.");
	}

	//vote
	c2t_hccs_vote();

	//probably should make a property handler, because this looks like it may get unwieldly
	if (get_property('_clanFortuneConsultUses').to_int() < 3) {
		string clan = get_property("c2t_hccs_joinClan");
		if (clan.to_int() != 0)
			c2t_assert(c2t_joinClan(clan.to_int()),`Could not join clan {clan}`);
		else
			c2t_assert(c2t_joinClan(clan),`Could not join clan {clan}`);

		string fortunes = get_property("c2t_hccs_clanFortunes");

		if (is_online(fortunes))
			while (get_property('_clanFortuneConsultUses').to_int() < 3)
				cli_execute(`fortune {fortunes};wait 5`);
		else
			print(`{fortunes} is not online; skipping fortunes`,"red");
	}

	//fax
	if (!get_property('_photocopyUsed').to_boolean() && item_amount($item[photocopied monster]) == 0) {
		if (available_amount($item[industrial fire extinguisher]) > 0 && available_amount($item[fourth of may cosplay saber]) > 0)
			c2t_hccs_getFax($monster[ungulith]);
		else if (is_online("cheesefax"))
			c2t_hccs_getFax($monster[factory worker (female)]);
		else
			c2t_hccs_getFax($monster[ungulith]);
	}

	c2t_hccs_haveUse($skill[spirit of peppermint]);
	
	//fish hatchet
	if (!get_property('_floundryItemCreated').to_boolean() && !retrieve_item(1,$item[fish hatchet]))
		abort('Failed to get a fish hatchet');

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

	//backup camera settings
	if (get_property('backupCameraMode') != 'ml' || !get_property('backupCameraReverserEnabled').to_boolean())
		cli_execute('backupcamera ml;backupcamera reverser on');

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
		autosell(5,$item[porquoise]);
		autosell(5,$item[hamethyst]);
	}

	//buy toy accordion
	if (my_class() != $class[accordion thief])
		retrieve_item(1,$item[toy accordion]);
	
	// equip mp stuff
	maximize("mp,-equip kramco,-equip i voted",false);

	// should have enough MP for this much; just being lazy here for now
	c2t_hccs_getEffect($effect[the magical mojomuscular melody]);

	//breakfasty things
	c2t_hccs_breakfast();

	// pre-coil pizza to get imitation whetstone for INFE pizza latter
	if (c2t_hccs_pizzaCube() && my_fullness() == 0) {
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
		use_familiar($familiar[hovering sombrero]);
	}
	//if cold medicine cabinet, grabbing a stat booze to get some adventures post-coil as I don't have numberology
	else if (get_campground() contains $item[cold medicine cabinet]) {
		maximize("100mainstat,mp",false);
		item itew;
		buffer bufw = visit_url("campground.php?action=workshed");
		switch (my_primestat()) {
			case $stat[muscle]:
				itew = $item[doc's fortifying wine];
				break;
			case $stat[mysticality]:
				itew = $item[doc's smartifying wine];
				break;
			case $stat[moxie]:
				itew = $item[doc's limbering wine];
				break;
		}
		if (!bufw.contains_text(itew))
			abort("cmc broke?");
		run_choice(3);

		//go back to full MP equipment
		maximize("mp,-equip kramco,-equip i voted",false);
	}
	
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

	//sometimes runs out of mp for clip art
	if (my_mp() < 11)
		cli_execute('rest free');

	// first tome use // borrowed time
	if (!get_property('_borrowedTimeUsed').to_boolean()) {//&& get_property('tomeSummons').to_int() == 0) {
		c2t_assert(retrieve_item(1,$item[borrowed time]),"borrowed time fail");
		use(1,$item[borrowed time]);
	}

	// second tome use // box of familiar jacks
	// going to get camel equipment straight away
	if (available_amount($item[dromedary drinking helmet]) == 0) {//&& get_property('tomeSummons').to_int() == 1) {
		c2t_assert(retrieve_item(1,$item[box of familiar jacks]),"box of familiar jacks fail");
		use_familiar($familiar[melodramedary]);
		use(1,$item[box of familiar jacks]);
	}
	
	// beach access
	c2t_assert(retrieve_item(1,$item[bitchin' meatcar]),"Couldn't get a bitchin' meatcar");

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
				if (c2t_hccs_pizzaCube() && available_amount($item[beach comb]) == 0)
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
		if (c2t_hccs_pizzaCube()) {
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
		abort('Getaway camp buff failure');

	
	// shower exp buff
	if (!get_property('_aprilShower').to_boolean())
		cli_execute('shower '+my_primestat());
	
	//TODO make synthesize selections smarter so the item one doesn't have to be so early
	//synthesize item //put this before all other syntheses so the others don't use too many sprouts
	c2t_hccs_sweetSynthesis($effect[synthesis: collection]);

	if (my_primestat() == $stat[muscle]) {
		//exp buff via pizza or wish
		if (!c2t_hccs_pizzaCube($effect[hgh-charged]))
			c2t_hccs_genie($effect[hgh-charged]);

		// mus exp synthesis
		if (!c2t_hccs_sweetSynthesis($effect[synthesis: movement]))
			print('Failed to synthesize exp buff','red');

		if (numeric_modifier('muscle experience percent') < 89.999) {
			abort('Insufficient +exp%');
			return false;
		}
	}
	else if (my_primestat() == $stat[mysticality]) {
		//exp buff via pizza or wish
		if (!c2t_hccs_pizzaCube($effect[different way of seeing things]))
			c2t_hccs_genie($effect[different way of seeing things]);
		
		// mys exp synthesis
		if (!c2t_hccs_sweetSynthesis($effect[synthesis: learning]))
			print('Failed to synthesize exp buff','red');

		//face
		c2t_hccs_getEffect($effect[inscrutable gaze]);

		if (numeric_modifier('mysticality experience percent') < 99.999) {
			abort('Insufficient +exp%');
			return false;
		}
	}
	else if (my_primestat() == $stat[moxie]) {
		//stat buff via pizza cube or exp buff via wish
		if (!c2t_hccs_pizzaCube($effect[knightlife]))
			c2t_hccs_genie($effect[thou shant not sing]);

		// mox exp synthesis
		// hardcore will be dropped if candies not aligned properly
		if (!c2t_hccs_sweetSynthesis($effect[synthesis: style]))
			print('Failed to synthesize exp buff','red');

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
	//need adventures straight away if running CMC
	item itew = c2t_priority($item[doc's fortifying wine],$item[doc's smartifying wine],$item[doc's limbering wine]);
	if (itew != $item[none]) {
		c2t_hccs_getEffect($effect[ode to booze]);
		drink(1,itew);
	}
	//TODO summon crimbo booze or something else if needed
	c2t_assert(my_adventures() > 0,"not going to get far with zero adventures");

	if (my_level() < 7 && c2t_hccs_buffExp()) {
		if (item_amount($item[familiar scrapbook]) > 0)
			equip($item[familiar scrapbook]);
		c2t_hccs_haveUse($item[a ten-percent bonus]);
	}
	if (my_level() < 7)
		abort('initial leveling broke');

	//some pulls if not in hard core; moxie would have already pulled up to 2 items so far
	if (my_primestat() == $stat[moxie] && pulls_remaining() > 3)
		c2t_hccs_pull($item[crumpled felt fedora]);//200 mox; saves 2 for fam test
	c2t_hccs_pull($item[great wolf's beastly trousers]);//100 mus; saves 2 for fam test
	c2t_hccs_pull($item[staff of simmering hatred]);//125 mys; saves 4 for spell test
	//rechecking this sometime after leveling for non-mys since 150 mys is possible
	if (my_primestat() == $stat[mysticality])
		c2t_hccs_pull($item[stick-knife of loathing]);//150 mys; saves 4 for spell test

	c2t_hccs_allTheBuffs();
	
	return true;
}

// initialise limited-use, non-mood buffs for leveling
boolean c2t_hccs_allTheBuffs() {
	// using MCD as a flag, what could possibly go wrong?
	if (current_mcd() >= 10)
		return true;

	print('Getting pre-fight buffs','blue');
	// equip mp stuff
	maximize("mp,-equip kramco",false);
	
	if (have_effect($effect[one very clear eye]) == 0) {
		while (c2t_hccs_wandererFight());//do vote monster if ready before spending turn
		if (c2t_hccs_semirareItem())
			c2t_hccs_getEffect($effect[one very clear eye]);
	}

	//emotion chip stat buff
	c2t_hccs_getEffect($effect[feeling excited]);

	c2t_hccs_getEffect($effect[the magical mojomuscular melody]);
	
	//boxing daycare stat gain
	if (get_property("daycareOpen").to_boolean() && get_property('_daycareGymScavenges').to_int() == 0) {
		visit_url('place.php?whichplace=town_wrong&action=townwrong_boxingdaycare');
		run_choice(3);//1334,3 boxing daycare lobby->boxing daycare
		run_choice(2);//1336,2 scavenge
	}

	//bastille
	if (item_amount($item[bastille battalion control rig]).to_boolean() && get_property('_bastilleGames').to_int() == 0)
		cli_execute('bastille mainstat brutalist');

	// getaway camp buff //probably causes infinite loop without getaway camp
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
	if (my_primestat() == $stat[moxie] && have_effect($effect[on the trolley]) == 0) {
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
			print("Failed to synthesize stat buff","red");
	}
	else if (my_primestat() == $stat[mysticality]) {
		if (!c2t_hccs_sweetSynthesis($effect[synthesis: smart]))
			print("Failed to synthesize stat buff","red");
	}
	else if (my_primestat() == $stat[moxie]) {
		if (!c2t_hccs_sweetSynthesis($effect[synthesis: cool]))
			print("Failed to synthesize stat buff","red");
	}

	//third tome use //no longer using bee's knees for stat boost on non-moxie, but still need same strength buff?
	if (my_mp() < 11)
		cli_execute('rest free');
	if (have_effect($effect[purity of spirit]) == 0) {
		retrieve_item(1,$item[cold-filtered water]);
		use(1,$item[cold-filtered water]);
	}

	//rhinestones to help moxie leveling
	if (my_primestat() == $stat[moxie])
		use(item_amount($item[rhinestone]),$item[rhinestone]);

	use_familiar($familiar[hovering sombrero]);
	
	//telescope
	if (get_property("telescopeUpgrades").to_int() > 0)
		cli_execute('telescope high');

	cli_execute('mcd 10');

	return true;
}

// get semirare from limerick dungeon
boolean c2t_hccs_semirareItem() {
	if (c2t_hccs_peppermintGarden() && c2t_hccs_sweetSynthesis())
		return false;

	c2t_assert(my_adventures() > 0,"no adventures for limerick dungeon lucky adventure");
	if (available_amount($item[cyclops eyedrops]) == 0 && have_effect($effect[one very clear eye]) == 0) {
		//11-leaf clover
		if (have_effect($effect[lucky!]) == 0) {
			retrieve_item($item[11-leaf clover]);
			use($item[11-leaf clover]);
		}
		//recover hp
		if (my_hp() < (0.5 * my_maxhp()))
			cli_execute('hottub');
		cli_execute('mood apathetic');
		adv1($location[the limerick dungeon], -1, '');
	}
	return true;
}

boolean c2t_hccs_lovePotion(boolean useit) {
	return c2t_hccs_lovePotion(useit,false);
}

boolean c2t_hccs_lovePotion(boolean useit,boolean dumpit) {
	if (!have_skill($skill[love mixology]))
		return false;

	item love_potion = $item[love potion #0];
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
				|| love_effect.numeric_modifier('maximum hp percent').to_int() <= -50))) {
			if (dumpit) {
				use(1,love_potion);
				return true;
			}
			else {
				print('not using trash love potion','blue');
				return false;
			}
		}
		else if (useit) {
			use(1, love_potion);
			return true;
		}
		else {
			print('love potion should be good; holding onto it','blue');
			return false;
		}
	}
	//abort('error handling love potion');
	return false;
}

boolean c2t_hccs_preItem() {
	//shrug off an AT buff
	cli_execute("shrug ur-kel");

	//get latte ingredient from fluffy bunny and cloake item buff
	if (have_effect($effect[feeling lost]) == 0 && (have_effect($effect[bat-adjacent form]) == 0 || !get_property('latteUnlocks').contains_text('carrot'))) {
		maximize("mainstat,equip latte,1000 bonus lil doctor bag,1000 bonus vampyric cloake",false);
		use_familiar($familiar[melodramedary]);

		while ((have_equipped($item[vampyric cloake]) && have_effect($effect[bat-adjacent form]) == 0) || !get_property('latteUnlocks').contains_text('carrot'))
			adv1($location[the dire warren],-1,"");
	}

	if (!get_property('latteModifier').contains_text('Item Drop') && get_property('_latteBanishUsed') == 'true')
		cli_execute('latte refill cinnamon carrot vanilla');

	c2t_hccs_getEffect($effect[fat leon's phat loot lyric]);
	c2t_hccs_getEffect($effect[singer's faithful ocelot]);
	c2t_hccs_getEffect($effect[the spirit of taking]);

	// might move back to levelup part
	if (have_effect($effect[synthesis: collection]) == 0)//skip pizza if synth item
		c2t_hccs_pizzaCube($effect[certainty]);

	// might move back to level up part
	if (!c2t_hccs_pizzaCube($effect[infernal thirst]))
		c2t_hccs_genie($effect[infernal thirst]);

	//spice ghost
	if (have_skill($skill[bind spice ghost])) {
		if (my_class() == $class[pastamancer]) {
			if (my_thrall() != $thrall[spice ghost]) {
				if (my_mp() < 250)
					cli_execute('eat magical sausage');
				c2t_hccs_haveUse($skill[bind spice ghost]);
			}
		}
		else {
			if (my_mp() < 250)
				cli_execute('eat magical sausage');
			c2t_hccs_getEffect($effect[spice haze]);
		}
	}

	//AT-only buff
	if (my_class() == $class[accordion thief])
		ensure_song($effect[the ballad of richie thingfinder]);

	c2t_hccs_getEffect($effect[nearly all-natural]);//bag of grain
	c2t_hccs_getEffect($effect[steely-eyed squint]);

	maximize('item,2 booze drop,-equip broken champagne bottle,-equip surprisingly capacious handbag,-equip red-hot sausage fork,switch left-hand man', false);


	//THINGS I DON'T ALWAYS WANT TO USE FOR ITEM TEST

	//if familiar test is ever less than 19 turns, feel lost will need to be completely removed or the test order changed
	if (!c2t_hccs_thresholdMet(TEST_ITEM))
		c2t_hccs_getEffect($effect[feeling lost]);

	if (!c2t_hccs_thresholdMet(TEST_ITEM)) {
		retrieve_item(1,$item[oversized sparkler]);
		//repeat of previous maximize call
		maximize('item,2 booze drop,-equip broken champagne bottle,-equip surprisingly capacious handbag,-equip red-hot sausage fork,switch left-hand man', false);
	}

	//power plant; last to save batteries if not needed
	if (!c2t_hccs_thresholdMet(TEST_ITEM))
		if (c2t_hccs_powerPlant())
			c2t_hccs_getEffect($effect[lantern-charged]);

	c2t_hccs_mod2log("modtrace item drop;modtrace booze drop");

	return c2t_hccs_thresholdMet(TEST_ITEM);
}

boolean c2t_hccs_preHotRes() {
	//cloake buff and fireproof foam suit for +32 hot res total, but also weapon and spell test buffs
	//weapon/spell buff should last 15 turns, which is enough to get through hot(1), NC(9), and weapon(1) tests to also affect the spell test
	if ((have_effect($effect[do you crush what i crush?]) == 0 && have_familiar($familiar[ghost of crimbo carols]))
		|| (have_effect($effect[fireproof foam suit]) == 0 && available_amount($item[industrial fire extinguisher]) > 0 && have_skill($skill[double-fisted skull smashing]))
		|| (have_effect($effect[misty form]) == 0 && available_amount($item[vampyric cloake]) > 0)
		) {

		if (available_amount($item[vampyric cloake]) > 0)
			equip($item[vampyric cloake]);
		equip($slot[weapon],$item[fourth of may cosplay saber]);
		if (available_amount($item[industrial fire extinguisher]) > 0)
			equip($slot[off-hand],$item[industrial fire extinguisher]);
		use_familiar(c2t_priority($familiars[ghost of crimbo carols,exotic parrot]));

		if (my_mp() < 30)
			c2t_hccs_restoreMp();
		adv1($location[the dire warren],-1,"");
		run_turn();
	}

	use_familiar($familiar[exotic parrot]);

	c2t_hccs_getEffect($effect[blood bond]);
	c2t_hccs_getEffect($effect[leash of linguini]);
	c2t_hccs_getEffect($effect[empathy]);

	c2t_hccs_getEffect($effect[elemental saucesphere]);
	c2t_hccs_getEffect($effect[astral shell]);

	//beach comb hot buff
	if (available_amount($item[beach comb]) > 0)
		c2t_hccs_getEffect($effect[hot-headed]);

	//emotion chip
	c2t_hccs_getEffect($effect[feeling peaceful]);

	//familiar weight
	c2t_hccs_getEffect($effect[blood bond]);
	c2t_hccs_getEffect($effect[leash of linguini]);
	c2t_hccs_getEffect($effect[empathy]);

	maximize('100hot res, familiar weight', false);
	// need to run this twice because familiar weight thresholds interfere with it?
	maximize('100hot res, familiar weight', false);


	//THINGS I DON'T USE FOR HOT TEST ANYMORE, but will fall back on if other things break

	//daily candle
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES))
		c2t_hccs_haveUse($item[rainbow glitter candle]);

	//magenta seashell
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES))
		if (available_amount($item[magenta seashell]) > 0)
			c2t_hccs_getEffect($effect[too cool for (fish) school]);

	//potion for sleazy hands & hot powder
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES)) {
		//potion making not needed with retro cape
		retrieve_item(1, $item[tenderizing hammer]);
		cli_execute('smash * ratty knitted cap');
		cli_execute('smash * red-hot sausage fork');

		if (available_amount($item[hot powder]) > 0)
			c2t_hccs_getEffect($effect[flame-retardant trousers]);

		if (available_amount($item[sleaze nuggets]) > 0 || available_amount($item[lotion of sleaziness]) > 0)
			c2t_hccs_getEffect($effect[sleazy hands]);
	}

	//pocket maze
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES))
		c2t_hccs_getEffect($effect[amazing]);

	//synthesis: hot
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES))
		c2t_hccs_sweetSynthesis($effect[synthesis: hot]);

	//pillkeeper
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES))
		c2t_hccs_pillkeeper($effect[rainbowolin]);

	//pocket wish
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES))
		c2t_hccs_genie($effect[fireproof lips]);

	//speakeasy drink
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES)) {
		if (have_effect($effect[feeling no pain]) == 0) {
			c2t_assert(my_meat() >= 500,'Not enough meat. Please autosell stuff.');
			ensure_ode(2);
			cli_execute('drink 1 Ish Kabibble');
		}
	}

	c2t_hccs_mod2log("modtrace hot resistance");

	return c2t_hccs_thresholdMet(TEST_HOT_RES);
}

boolean c2t_hccs_preFamiliar() {
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
			if (available_amount($item[industrial fire extinguisher]) > 0)
				c2t_assert(c2t_hccs_genie($monster[ungulith]),"ungulith wish fail");
			else
				c2t_assert(c2t_hccs_genie($monster[factory worker (female)]),"factory worker wish fail");
		}
	}

	// Pool buff
	c2t_hccs_getEffect($effect[billiards belligerence]);

	if (my_hp() < 30) use_skill(1, $skill[cannelloni cocoon]);
	c2t_hccs_getEffect($effect[blood bond]);
	c2t_hccs_getEffect($effect[leash of linguini]);
	c2t_hccs_getEffect($effect[empathy]);

	//AT-only buff
	if (my_class() == $class[accordion thief])
		ensure_song($effect[chorale of companionship]);

	use_familiar($familiar[exotic parrot]);
	maximize('familiar weight', false);

	//should only get 1 per run, if any; would use in NEP combat loop, but no point as sombrero would already be already giving max stats
	if (!c2t_hccs_thresholdMet(TEST_FAMILIAR))
		c2t_hccs_haveUse($item[short stack of pancakes]);

	c2t_hccs_mod2log("modtrace familiar weight");

	return c2t_hccs_thresholdMet(TEST_FAMILIAR);
}


boolean c2t_hccs_preNoncombat() {
	if (my_hp() < 30) use_skill(1, $skill[cannelloni cocoon]);
	c2t_hccs_getEffect($effect[blood bond]);
	c2t_hccs_getEffect($effect[leash of linguini]);
	c2t_hccs_getEffect($effect[empathy]);

	// Pool buff. Should fall through to weapon damage.
	//not going to use this here, as it doesn't do to the noncombat rate in the moment anyway
	//c2t_hccs_getEffect($effect[billiards belligerence]);

	c2t_hccs_getEffect($effect[the sonata of sneakiness]);
	c2t_hccs_getEffect($effect[smooth movements]);
	if (available_amount($item[powerful glove]) > 0 && have_effect($effect[invisible avatar]) == 0 && !c2t_cast($skill[cheat code: invisible avatar]))
		abort('Invisible avatar failed');

	c2t_hccs_getEffect($effect[silent running]);

	if (have_familiar($familiar[god lobster]) && have_effect($effect[silence of the god lobster]) == 0 && get_property('_godLobsterFights').to_int() < 3) {
		cli_execute('mood apathetic');
		use_familiar($familiar[god lobster]);
		equip($item[god lobster's ring]);
		
		//garbage shirt should be exhausted already, but check anyway
		string shirt;
		if (get_property('garbageShirtCharge') > 0)
			shirt = ",equip garbage shirt";
		maximize(my_primestat() + ",-familiar" + shirt,false);

		//fight and get buff
		c2t_setChoice(1310,2); //get buff
		visit_url('main.php?fightgodlobster=1');
		run_turn();
		if (choice_follows_fight())
			run_choice(2);
		c2t_setChoice(1310,0); //unset
	}

	//emotion chip feel lonely
	c2t_hccs_getEffect($effect[feeling lonely]);
	
	// Rewards // use these after globster fight, just in case of losing
	c2t_hccs_getEffect($effect[throwing some shade]);
	c2t_hccs_getEffect($effect[a rose by any other material]);


	use_familiar($familiar[disgeist]);

	//replacing glob buff with this
	//mafia doesn't seem to support retrieve_item() by itself for this yet, so visit_url() to the rescue:
	if (available_amount($item[porkpie-mounted popper]) == 0) {
		visit_url("clan_viplounge.php?action=fwshop&whichfloor=2",false,true);
		//visit_url("shop.php?whichshop=fwshop",false,true);
		visit_url("shop.php?whichshop=fwshop&action=buyitem&quantity=1&whichrow=1249&pwd",true,true);
	}
	//double-checking, and what will be used when mafia finally supports it:
	retrieve_item(1,$item[porkpie-mounted popper]);

	maximize('-100combat, familiar weight', false);
	//doubling up to make sure, as it's been finicky:
	maximize('-100combat, familiar weight', false);


	//disquiet riot wish potential if 2 or more wishes remain and not close to min turn
	if (!c2t_hccs_thresholdMet(TEST_NONCOMBAT) && c2t_hccs_testTurns(TEST_NONCOMBAT) >= 9)//TODO better cost/benefit
		c2t_hccs_genie($effect[disquiet riot]);

	c2t_hccs_mod2log("modtrace combat rate");

	return c2t_hccs_thresholdMet(TEST_NONCOMBAT);
}

boolean c2t_hccs_preWeapon() {
	if (get_property('camelSpit').to_int() != 100 && have_effect($effect[spit upon]) == 0)
		abort('Camel spit only at '+get_property('camelSpit')+'%.');

	//cast triple size
	if (available_amount($item[powerful glove]) > 0 && have_effect($effect[triple-sized]) == 0 && !c2t_cast($skill[cheat code: triple size]))
		abort('Triple size failed');

	if (my_mp() < 500 && my_mp() != my_maxmp())
		cli_execute('eat mag saus');

	// moved to hot res test
	/*if (have_effect($effect[do you crush what i crush?]) == 0 && have_familiar($familiar[ghost of crimbo carols]) && (get_property('_snokebombUsed').to_int() < 3 || !get_property('_latteBanishUsed').to_boolean())) {
		equip($item[latte lovers member's mug]);
		if (my_mp() < 30)
			cli_execute('rest free');
		use_familiar($familiar[ghost of crimbo carols]);
		adv1($location[the dire warren],-1,"");
	}*/

	if (have_effect($effect[in a lather]) == 0) {
		if (my_inebriety() > inebriety_limit() - 2)
			abort('Something went wrong. We are too drunk.');
		c2t_assert(my_meat() >= 500,"Need 500 meat for speakeasy booze");
		ensure_ode(2);
		cli_execute('drink Sockdollager');
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
		retrieve_item(1, $item[goofily-plumed helmet]);
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
		use_familiar(c2t_priority($familiars[melodramedary]));

		adv1($location[thugnderdome],-1,"");//everything is saberable and no crazy NCs
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
	
	maximize('weapon damage', false);

	//OU pizza if needed
	if (!c2t_hccs_thresholdMet(TEST_WEAPON) && c2t_hccs_testTurns(TEST_WEAPON) > 3)//TODO ? cost/benifit?
		c2t_hccs_pizzaCube($effect[outer wolf&trade;]);

	if (have_effect($effect[outer wolf&trade;]) == 0)
		print("OU pizza skipped","blue");

	//cargo shorts as backup
	if (available_amount($item[cargo cultist shorts]) > 0
		&& !c2t_hccs_thresholdMet(TEST_WEAPON)
		&& c2t_hccs_testTurns(TEST_WEAPON) > 4 //4 is how much cargo would save on spell test, so may as well use here if spell is not better
		&& have_effect($effect[rictus of yeg]) == 0
		&& !get_property('_cargoPocketEmptied').to_boolean())
			cli_execute("cargo item yeg's motel toothbrush");
	c2t_hccs_haveUse($item[yeg's motel toothbrush]);

	c2t_hccs_mod2log("modtrace weapon damage");

	return c2t_hccs_thresholdMet(TEST_WEAPON);
}

boolean c2t_hccs_preSpell() {
	if (my_mp() < 500 && my_mp() != my_maxmp())
		cli_execute('eat mag saus');

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
	if (my_basestat($stat[mysticality]) >= 150)
		c2t_hccs_pull($item[stick-knife of loathing]);

	//get up to 2 obsidian nutcracker
	int nuts = 2;
	foreach x in $items[stick-knife of loathing,staff of simmering hatred]//,Abracandalabra]
		if (available_amount(x) > 0)
			nuts--;
	if (!have_familiar($familiar[left-hand man]) && available_amount($item[abracandalabra]) > 0)
		nuts--;
	retrieve_item(nuts<0?0:nuts,$item[obsidian nutcracker]);

	//AT-only buff
	if (my_class() == $class[accordion thief])
		ensure_song($effect[elron's explosive etude]);

	// cargo pocket
	if (available_amount($item[cargo cultist shorts]) > 0 && have_effect($effect[sigils of yeg]) == 0 && !get_property('_cargoPocketEmptied').to_boolean())
		cli_execute("cargo item Yeg's Motel hand soap");
	c2t_hccs_haveUse($item[yeg's motel hand soap]);

	// meteor lore // moxie can't do this, as it wastes a saber on evil olive -- moxie should be able to do this now with nostalgia earlier?
	if (have_skill($skill[meteor lore]) && have_effect($effect[meteor showered]) == 0 && get_property('_saberForceUses').to_int() < 5) {
		maximize("mainstat,equip fourth of may cosplay saber",false);
		adv1($location[thugnderdome],-1,"");//everything is saberable and no crazy NCs
	}

	if (have_skill($skill[deep dark visions]) && have_effect($effect[visions of the deep dark deeps]) == 0) {
		c2t_hccs_getEffect($effect[elemental saucesphere]);
		c2t_hccs_getEffect($effect[astral shell]);
		maximize("1000spooky res,hp,mp",false);
		if (my_hp() < 800)
			use_skill(1,$skill[cannelloni cocoon]);
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

	//need to figure out pulls
	if (!in_hardcore() && pulls_remaining() > 0) {
		//lazy way for now
		boolean [item] derp;
		if (available_amount($item[astral statuette]) == 0)
			derp = $items[cold stone of hatred,fuzzy slippers of hatred,lens of hatred,witch's bra];
		else
			derp = $items[fuzzy slippers of hatred,lens of hatred,witch's bra];

		foreach x in derp {
			if (pulls_remaining() == 0)
				break;
			c2t_hccs_pull(x);
		}
		if (pulls_remaining() > 0)
			print(`Still had {pulls_remaining()} pulls remaining for the last test`,"red");
	}

	maximize('spell damage,switch left-hand man', false);

	c2t_hccs_mod2log("modtrace spell damage");

	return c2t_hccs_thresholdMet(TEST_SPELL);
}


// stat tests are super lazy for now
// TODO need to figure out a way to not overdo buffs, as some buffers may be needed for pizzas
boolean c2t_hccs_preHp() {
	if (!c2t_hccs_thresholdMet(TEST_HP))
		maximize('hp',false);

	//hp buffs
	if (!c2t_hccs_thresholdMet(TEST_HP)) {
		if (!c2t_hccs_getEffect($effect[song of starch]))
			c2t_hccs_getEffect($effect[song of bravado]);
		c2t_hccs_getEffect($effect[reptilian fortitude]);
	}

	//mus buffs //basically copy/paste from mus test sans bravado
	if (!c2t_hccs_thresholdMet(TEST_HP))
		//TODO AT songs
		foreach x in $effects[
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
			]
			c2t_hccs_getEffect(x);

	return c2t_hccs_thresholdMet(TEST_HP);
}

boolean c2t_hccs_preMus() {
	//TODO if pastamancer, add summon of mus thrall if need? currently using equaliser potion out of laziness
	if (!c2t_hccs_thresholdMet(TEST_MUS))
		maximize('mus',false);

	if (!c2t_hccs_thresholdMet(TEST_MUS))
		//TODO AT songs
		foreach x in $effects[
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
			]
			c2t_hccs_getEffect(x);

	return c2t_hccs_thresholdMet(TEST_MUS);
}

boolean c2t_hccs_preMys() {
	if (!c2t_hccs_thresholdMet(TEST_MYS))
		maximize('mys',false);

	if (!c2t_hccs_thresholdMet(TEST_MYS))
		//TODO AT songs
		foreach x in $effects[
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
			]
			c2t_hccs_getEffect(x);

	return c2t_hccs_thresholdMet(TEST_MYS);
}

boolean c2t_hccs_preMox() {
	//TODO if pastamancer, add summon of mox thrall if need? currently using equaliser potion out of laziness
	if (!c2t_hccs_thresholdMet(TEST_MOX))
		maximize('mox',false);

	if (!c2t_hccs_thresholdMet(TEST_MOX)) {
		//TODO AT songs
		//face
		if (!c2t_hccs_getEffect($effect[quiet desperation]))
			c2t_hccs_getEffect($effect[disco smirk]);

		//other
		foreach x in $effects[
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
			]
			c2t_hccs_getEffect(x);
	}

	return c2t_hccs_thresholdMet(TEST_MOX);
}

void c2t_hccs_fights() {
	//TODO move familiar changes and maximizer calls inside of blocks
	// saber yellow ray stuff
	if (available_amount($item[tomato juice of powerful power]) == 0
		&& available_amount($item[tomato]) == 0
		&& have_effect($effect[tomato power]) == 0) {

		cli_execute('mood apathetic');

		if (my_hp() < 0.5 * my_maxhp())
			c2t_hccs_restoreMp();

		use_familiar($familiar[melodramedary]);
		equip($item[dromedary drinking helmet]);
		
		// Fruits in skeleton store (Saber YR)
		if ((available_amount($item[ointment of the occult]) == 0 && available_amount($item[grapefruit]) == 0 && have_effect($effect[mystically oiled]) == 0)
				|| (available_amount($item[oil of expertise]) == 0 && available_amount($item[cherry]) == 0 && have_effect($effect[expert oiliness]) == 0)
				|| (available_amount($item[philter of phorce]) == 0 && available_amount($item[lemon]) == 0 && have_effect($effect[phorcefullness]) == 0)) {
			if (get_property('questM23Meatsmith') == 'unstarted') {
				// Have to start meatsmith quest.
				visit_url('shop.php?whichshop=meatsmith&action=talk');
				run_choice(1);
			}
			if (!can_adv($location[the skeleton store], false))
				abort('Cannot open skeleton store!');
			if ($location[the skeleton store].turns_spent == 0 && !$location[the skeleton store].noncombat_queue.contains_text('Skeletons In Store'))
				adv1($location[the skeleton store], -1, '');
			if (!$location[the skeleton store].noncombat_queue.contains_text('Skeletons In Store'))
				abort('Something went wrong at skeleton store.');

			if (get_property('lastCopyableMonster').to_monster() != $monster[novelty tropical skeleton]) {
				//max mp to max latte gulp to fuel buffs
				maximize("mp,-equip garbage shirt,equip latte,100 bonus vampyric cloake,-equip backup camera,100 bonus lil doctor bag,-familiar",false);

				c2t_cartographyHunt($location[the skeleton store],$monster[novelty tropical skeleton]);
				run_turn();
			}
			//get the fruits with nostalgia
			c2t_hccs_fightGodLobster();
		}

		// Tomato in pantry (NOT Saber YR) -- RUNNING AWAY to use nostalgia later
		if (available_amount($item[tomato juice of powerful power]) == 0
			&& available_amount($item[tomato]) == 0
			&& have_effect($effect[tomato power]) == 0
			) {

			if (get_property('lastCopyableMonster').to_monster() != $monster[possessed can of tomatoes]) {
				if (get_property('_latteDrinkUsed').to_boolean())
					cli_execute('latte refill cinnamon pumpkin vanilla');
				//max mp to max latte gulp to fuel buffs
				use_familiar($familiar[melodramedary]);
				maximize("mp,-equip garbage shirt,equip latte,100 bonus vampyric cloake,-equip backup camera,100 bonus lil doctor bag,-familiar",false);

				c2t_cartographyHunt($location[the haunted pantry],$monster[possessed can of tomatoes]);
				run_turn();
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
	string famEq;
	if (my_class() == $class[seal clubber] || available_amount($item[dromedary drinking helmet]) > 0) {
		use_familiar($familiar[melodramedary]);
		if (available_amount($item[dromedary drinking helmet]) > 0) {
			equip($item[dromedary drinking helmet]);
			famEq = ",equip dromedary drinking helmet";
		}
	}
	else
		use_familiar($familiar[hovering sombrero]);

	familiar levelingFam = my_familiar();
	
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

	//spice ghost
	if (my_class() == $class[pastamancer] && have_skill($skill[bind spice ghost])) {
		if (my_thrall() != $thrall[spice ghost]) {
			if (my_mp() < 250)
				cli_execute('eat magical sausage');
			c2t_hccs_haveUse($skill[bind spice ghost]);
		}
	}

	//turtle tamer blessing
	if (my_class() == $class[turtle tamer]) {
		if (have_effect($effect[blessing of the war snapper]) == 0 && have_effect($effect[grand blessing of the war snapper]) == 0 && have_effect($effect[glorious blessing of the war snapper]) == 0)
			c2t_hccs_haveUse($skill[blessing of the war snapper]);
		if (have_effect($effect[boon of the war snapper]) == 0)
			c2t_hccs_haveUse(1,$skill[spirit boon]);
	}

	use_familiar(levelingFam);


	//get crimbo ghost buff from dudes at NEP
	if ((have_familiar($familiar[ghost of crimbo carols]) && have_effect($effect[holiday yoked]) == 0)
		|| (my_primestat() == $stat[moxie] && have_effect($effect[unrunnable face]) == 0 && item_amount($item[runproof mascara]) == 0)//to nostalgia runproof mascara
		) {

		if (get_property('_latteDrinkUsed').to_boolean())
			cli_execute('latte refill cinnamon pumpkin vanilla');
		if (have_familiar($familiar[ghost of crimbo carols]))
			use_familiar($familiar[ghost of crimbo carols]);
		maximize("mainstat,equip latte,-equip i voted,-equip backup camera",false);

		//going to grab runproof mascara from globster if moxie instead of having to wait post-kramco
		if (my_primestat() == $stat[moxie]) {
			c2t_cartographyHunt($location[the neverending party],$monster[party girl]);
			run_turn();
		}
		else
			adv1($location[the neverending party],-1,"");
	}

	//nostalgia for moxie stuff and run down remaining glob fights
	while (c2t_hccs_fightGodLobster());

	//moxie needs olives
	if (my_primestat() == $stat[moxie] && have_effect($effect[slippery oiliness]) == 0 && item_amount($item[jumbo olive]) == 0) {
		//only thing that needs be equipped
		use_familiar($familiar[melodramedary]);
		if (!have_equipped($item[fourth of may cosplay saber]))
			equip($item[fourth of may cosplay saber]);
		//TODO evil olive - change to run away from and feel nostagic+envy+free kill another thing to save a saber use for spell test
		c2t_assert(c2t_hccs_genie($monster[evil olive]),"Failed to fight evil olive");
	}

	use_familiar(levelingFam);

	//summon tentacle
	if (have_skill($skill[evoke eldritch horror]) && !get_property('_eldritchHorrorEvoked').to_boolean()) {
		maximize("mainstat,100exp,-equip garbage shirt"+famEq,false);
		if (my_mp() < 80)
			c2t_hccs_restoreMp();
		c2t_hccs_haveUse(1,$skill[evoke eldritch horror]);
		run_combat();

		//in case the tentacle boss shows up; will cause an instant loss in a wish fight if health left at 0
		if (have_effect($effect[beaten up]) > 0 || my_hp() < 50)
			cli_execute('rest free');
	}

	// Your Mushroom Garden
	if ((get_campground() contains $item[packet of mushroom spores]) && get_property('_mushroomGardenFights').to_int() == 0) {
		maximize("mainstat,-equip garbage shirt"+famEq,false);
		adv1($location[your mushroom garden],-1,"");
	}

	c2t_hccs_wandererFight();//shouldn't do kramco

	//setup for NEP and backup fights
	string doc,garbage,kramco,fam;

	//set camel
	if (get_property('camelSpit').to_int() != 100) {
		use_familiar($familiar[melodramedary]);
		fam = ",equip dromedary drinking helmet";
	}

	if (get_property('backupCameraMode') != 'ml')
		cli_execute('backupcamera ml');

	if (!get_property('_gingerbreadMobHitUsed').to_boolean())
		print("Running backup camera and Neverending Party fights","blue");

	//NEP loop //neverending party and backup camera fights
	while (get_property("_neverendingPartyFreeTurns").to_int() < 10 || c2t_hccs_freeKillsLeft() > 0) {
		// -- combat logic --
		//use doc bag kills first after free fights
		if (available_amount($item[lil' doctor&trade; bag]) > 0
			&& get_property('_neverendingPartyFreeTurns').to_int() == 10
			&& get_property('_chestXRayUsed').to_int() < 3)
				doc = ",equip lil doctor bag";
		else
			doc = "";

		//change to other familiar when spit maxed
		if (get_property('camelSpit').to_int() == 100) {
			if (have_familiar($familiar[shorter-order cook]) && item_amount($item[short stack of pancakes]) == 0 && have_effect($effect[shortly stacked]) == 0) {
				if (my_familiar() != $familiar[shorter-order cook]) {
					//give cook's combat bonus familiar exp to professor
					use_familiar($familiar[pocket professor]);
					use_familiar($familiar[shorter-order cook]);
				}
			}
			else
				use_familiar(c2t_priority($familiars[baby sandworm,galloping grill,hovering sombrero]));
			fam = "";
		}
		else//swap off pocket professor after it happens
			use_familiar($familiar[melodramedary]);

		//backup fights will turns this off after a point, so keep turning it on
		if (get_property('garbageShirtCharge').to_int() > 0)
			garbage = ",equip garbage shirt";
		else
			garbage = "";

		// -- using things as they become available --
		//use runproof mascara ASAP if moxie for more stats
		if (my_primestat() == $stat[moxie] && have_effect($effect[unrunnable face]) == 0 && item_amount($item[runproof mascara]) > 0)
			use(1,$item[runproof mascara]);

		//turtle tamer turtle
		if (my_class() == $class[turtle tamer] && have_effect($effect[gummi-grin]) == 0 && item_amount($item[gummi turtle]) > 0)
			use(1,$item[gummi turtle]);

		//eat CER pizza ASAP
		if (c2t_hccs_pizzaCube()
			&& have_effect($effect[synthesis: collection]) == 0//skip pizza if synth item
			&& have_effect($effect[certainty]) == 0
			&& item_amount($item[electronics kit]) > 0
			&& item_amount($item[middle of the road&trade; brand whiskey]) > 0)

			c2t_hccs_pizzaCube($effect[certainty]);

		//drink hot socks ASAP
		if (have_effect($effect[1701]) == 0 && my_meat() > 5000) {//1701 is the desired version of $effet[hip to the jive]
			if (my_mp() < 150)
				cli_execute('eat mag saus');
			cli_execute('shrug stevedave');
			c2t_hccs_getEffect($effect[ode to booze]);
			cli_execute('drink hot socks');
			cli_execute('shrug ode to booze');
			c2t_hccs_getEffect($effect[stevedave's shanty of superiority]);
		}

		//drink astral pilsners once level 11; saving 1 for use in mime army shotglass post-run
		if (my_level() >= 11 && item_amount($item[astral pilsner]) == 6) {
			cli_execute('shrug Shanty of Superiority');
			c2t_hccs_haveUse(1,$skill[the ode to booze]);
			drink(5,$item[astral pilsner]);
			cli_execute('shrug Ode to Booze');
			c2t_hccs_haveUse(1,$skill[stevedave's shanty of superiority]);
		}

		//explicitly buying and using range as it rarely bugs out
		if (!(get_campground() contains $item[dramatic&trade; range]) && my_meat() >= (have_skill($skill[five finger discount])?950:1000)) { //five-finger discount
			retrieve_item($item[dramatic&trade; range]);
			use($item[dramatic&trade; range]);
		}
		//potion buffs when enough meat obtained
		if (have_effect($effect[tomato power]) == 0 && (get_campground() contains $item[dramatic&trade; range])) {
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
		}

		// -- setup and combat itself --
		//make sure have some mp
		if (my_mp() < 50)
			cli_execute('eat magical sausage');

		//hopefully stop it before a possible break if my logic is off
		if (get_property('_pocketProfessorLectures').to_int() == 0 && get_property('_backUpUses').to_int() >= 10)
			abort('Pocket professor has not been used yet, while backup camera charges left is '+(11-get_property('_backUpUses').to_int()));

		//9+ professor copies, after getting exp buff from NC and used sauceror potions
		if (get_property('_pocketProfessorLectures').to_int() == 0
			&& get_property('_backUpUses').to_int() < 11
			&& (have_effect($effect[spiced up]) > 0 || have_effect($effect[tomes of opportunity]) > 0 || have_effect($effect[the best hair you've ever had]) > 0)
			&& have_effect($effect[tomato power]) > 0
			//target monster for professor copies. using back up camera to bootstrap
			&& get_property('lastCopyableMonster').to_monster() == $monster[sausage goblin]
			) {

			use_familiar($familiar[pocket professor]);
			c2t_minMaximize("mainstat,equip garbage shirt,equip kramco,100familiar weight,equip backup camera");
		}
		//fish for latte carrot ingredient with backup fights
		else if (get_property('_pocketProfessorLectures').to_int() > 0
			&& !get_property('latteUnlocks').contains_text('carrot')
			&& get_property('_backUpUses').to_int() < 11
			//target monster
			&& get_property('lastCopyableMonster').to_monster() == $monster[sausage goblin]
			) {

			//NEP monsters give twice as much base exp as sausage goblins, so keep at least as many shirt charges as fights remaining in NEP
			if (get_property('garbageShirtCharge').to_int() < 17)
				garbage = ",-equip garbage shirt";

			c2t_minMaximize("mainstat,exp,equip latte,equip backup camera"+garbage+fam);
			adv1($location[the dire warren],-1,"");
			continue;//don't want to fall into NEP in this state
		}
		//inital and post-latte backup fights
		else if (get_property('_backUpUses').to_int() < 11 && get_property('lastCopyableMonster').to_monster() == $monster[sausage goblin]) {
			//only use kramco offhand if target is sausage goblin to not mess things up
			if (get_property('lastCopyableMonster').to_monster() == $monster[sausage goblin])
				kramco = ",equip kramco";
			else
				kramco = "";

			//NEP monsters give twice as much base exp as sausage goblins, so keep at least as many shirt charges as fights remaining in NEP
			if (get_property('garbageShirtCharge').to_int() < 17)
				garbage = ",-equip garbage shirt";

			c2t_minMaximize("mainstat,exp,equip backup camera"+kramco+garbage+fam);
		}
		//rest of the free NEP fights
		else
			c2t_minMaximize("mainstat,exp,equip kramco"+garbage+fam+doc);

		adv1($location[the neverending party],-1,"");
	}

	cli_execute('mood apathetic');
}

boolean c2t_hccs_wandererFight() {
	//don't want to be doing wanderer whilst feeling lost
	if (have_effect($effect[feeling lost]) > 0) {
		print("Currently feeling lost, so skipping wanderer(s).","blue");
		return false;
	}

	string append = ",-equip garbage shirt,exp";
	if (c2t_isVoterNow())
		append += ",equip i voted";
	//kramco should not be done here when only the coil wire test is done, otherwise the professor chain will fail
	else if (c2t_isSausageGoblinNow() && get_property('csServicesPerformed') != TEST_NAME[TEST_COIL_WIRE])
		append += ",equip kramco";
	else
		return false;

	if (turns_played() == 0)
		c2t_hccs_getEffect($effect[feeling excited]);

	if (my_hp() < my_maxhp()/2 || my_mp() < 10) {
		c2t_hccs_breakfast();
		c2t_hccs_restoreMp();
	}
	print("Running wanderer fight","blue");
	//saving last maximizer string and familiar stuff; outfits generally break here
	string[int] maxstr = split_string(get_property("maximizerMRUList"),";");
	familiar nowFam = my_familiar();
	item nowEquip = equipped_item($slot[familiar]);

	if (get_property('camelSpit').to_int() < 100 && !get_property("csServicesPerformed").contains_text(TEST_NAME[TEST_WEAPON])) {
		use_familiar($familiar[melodramedary]);
		append += ",equip dromedary drinking helmet";
	}
	else if (have_familiar($familiar[shorter-order cook]) && get_property('camelSpit').to_int() == 100 && !get_property("csServicesPerformed").contains_text(TEST_NAME[TEST_FAMILIAR]) && item_amount($item[short stack of pancakes]) == 0) {
		if (my_familiar() != $familiar[shorter-order cook]) {
			//give cook's combat bonus familiar exp to professor
			use_familiar($familiar[pocket professor]);
			use_familiar($familiar[shorter-order cook]);
		}
	}
	else
		use_familiar(c2t_priority($familiars[baby sandworm,galloping grill,hovering sombrero]));

	//backup camera may swap off voter monster, so don't equip it
	maximize("mainstat,-equip backup camera"+append,false);
	adv1($location[the neverending party],-1,"");

	//hopefully restore to previous state without outfits
	use_familiar(nowFam);
	maximize(maxstr[0],false);
	equip($slot[familiar],nowEquip);

	return true;
}

// will fail if haiku dungeon stuff spills outside of itself, so probably avoid that or make sure to do combats elsewhere just before a test
boolean c2t_hccs_testDone(int test) {
	print(`Checking test {test}...`);
	if (test == 30 && !get_property('kingLiberated').to_boolean() && get_property("csServicesPerformed").split_string(",").count() == 11)
		return false;//to do the 'test' and to set kingLiberated
	else if (get_property('kingLiberated').to_boolean())
		return true;
	return get_property('csServicesPerformed').contains_text(TEST_NAME[test]);
}

void c2t_hccs_doTest(int test) {
	if (!c2t_hccs_testDone(test)) {
		visit_url('council.php');
		visit_url('choice.php?pwd&whichchoice=1089&option='+test,true,true);
		c2t_assert(c2t_hccs_testDone(test),`Failed to do test {test}. Out of turns?`);
	}
	else
		print(`Test {test} already done.`);
}



//c2t hccs
//c2t

since r20876;//fire extinguisher IotM

import <c2t_cartographyHunt.ash>
import <c2t_lib.ash>
import <c2t_cast.ash>
import <canadv.ash>
import <c2t_hccs_aux.ash>

int START_TIME = now_to_int();
boolean FIRST_MAX = true;

//properties
//can set the following properties via the CLI. This just sets some defaults in case they don't exist to make handling them simpler
/*
set c2t_hccs_haltBeforeTest = false
aborts after prepping for each test but before actually doing it at the council
*/
if (!property_exists("c2t_hccs_haltBeforeTest",false))
	set_property("c2t_hccs_haltBeforeTest","false");
/*
set c2t_hccs_printModtrace = false
prints a modtrace to the CLI and log just before non-stat tests
*/
if (!property_exists("c2t_hccs_printModtrace",false))
	set_property("c2t_hccs_printModtrace","true");
/*
set c2t_hccs_joinClan = 90485
This is the clan that the script will join for the VIP lounge and fortune teller
Takes an int or string, where int would be clanid (preferred), and string would be the clan name
*/
if (!property_exists("c2t_hccs_joinClan",false))
	set_property("c2t_hccs_joinClan","90485");
/*
set c2t_hccs_clanFortunes = CheeseFax
This is the name of the person/bot that you want to do the fortune teller with
*/
if (!property_exists("c2t_hccs_clanFortunes",false))
	set_property("c2t_hccs_clanFortunes","CheeseFax");
/*
set c2t_hccs_skipFinalService = false
If this is set to true, the final service will be skipped leaving you in-run once finished
*/
if (!property_exists("c2t_hccs_skipFinalService",false))
	set_property("c2t_hccs_skipFinalService","false");
/*
set c2t_hccs_thresholds = 1,1,1,1,1,1,1,1,1,1
These are the 10 thresholds corresponding to the minimum turns to allow each test to take
The order is hp,mus,mys,mox,fam,weapon,spell,nc,item,hot -- which is the same as the game
The script will stop just before doing a test if a threshold is not met after doing all the pre-test stuff
Example: 1,1,1,1,35,1,31,1,1,1 will allow the familiar test to take 35 turns, the spell test to take 31 turns, and all others must be 1 turn
*/
if (!property_exists("c2t_hccs_thresholds",false))
	set_property("c2t_hccs_thresholds","1,1,1,1,1,1,1,1,1,1");
/*
set c2t_bb_printMacro = true
Prints the combat macro the script submits in combat
*/
if (!property_exists("c2t_bb_printMacro",false))
	set_property("c2t_bb_printMacro","true");


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


int c2t_getEffect(effect eff,skill ski);
int c2t_getEffect(effect eff,skill ski,int min);
int c2t_getEffect(effect eff,item ite);
int c2t_getEffect(effect eff,item ite,int min);
boolean c2t_haveUse(skill ski);
boolean c2t_haveUse(skill ski,int min);
boolean c2t_haveUse(item ite);
boolean c2t_haveUse(item ite,int min);

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
boolean c2t_hccs_wishFight(monster mon);
boolean c2t_hccs_wandererFight();
void c2t_hccs_pantagramming();
void c2t_hccs_vote();
int c2t_hccs_testTurns(int test);
boolean c2t_hccs_thresholdMet(int test);
boolean c2t_hccs_pull(item ite);
void c2t_hccs_mod2log(string str);
void c2t_hccs_printRunTime(boolean final);
void c2t_hccs_printRunTime() c2t_hccs_printRunTime(false);
void c2t_hccs_getFax(monster mon);
boolean c2t_hccs_fightGodLobster();
void c2t_hccs_breakfast();
int c2t_hccs_freeKillsLeft();
void c2t_hccs_printTestData();
void c2t_hccs_testData(string testType,int testNum,int turnsTaken,int turnsExpected);
boolean c2t_hccs_minMaximize(string max);


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
		
		c2t_hccs_testHandler(TEST_MUS);
		c2t_hccs_testHandler(TEST_MYS);
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

//pull item from storage
boolean c2t_hccs_pull(item ite) {
	if(!can_interact() && !in_hardcore() && item_amount(ite) == 0 && available_amount(ite) == 0 && storage_amount(ite) > 0 && pulls_remaining() > 0)
		return take_storage(1,ite);
	return false;
}

//free kills left
int c2t_hccs_freeKillsLeft() {
	int n = 0;
	if (available_amount($item[lil' doctor&trade; bag]) > 0)
		n += 3 - get_property("_chestXRayUsed").to_int();
	if (have_skill($skill[shattering punch]))
		n += 3 - get_property("_shatteringPunchUsed").to_int();
	if (have_skill($skill[gingerbread mob hit]) && !get_property("_gingerbreadMobHitUsed").to_boolean())
		n++;
	return n;
}

//limited breakfast to only what might be used
void c2t_hccs_breakfast() {
	skill ski = $skill[advanced saucecrafting];
	if (get_property("reagentSummons").to_int() == 0 && have_skill(ski) && my_mp() >= mp_cost(ski))
		use_skill(1,ski);

	ski = $skill[summon crimbo candy];
	if (get_property("_candySummons").to_int() == 0 && have_skill(ski) && my_mp() >= mp_cost(ski))
		use_skill(1,ski);

	ski = $skill[prevent scurvy and sobriety];
	if (!get_property("_preventScurvy").to_boolean() && have_skill(ski) && my_mp() >= mp_cost(ski))
		use_skill(1,ski);

	//mys classes want the D
	if (my_primestat() == $stat[mysticality]) {
		ski = $skill[pastamastery];
		if (get_property("noodleSummons").to_int() == 0 && have_skill(ski) && my_mp() >= mp_cost(ski))
			use_skill(1,ski);
	}

	//mox class stat boost for leveling
	if (my_primestat() == $stat[moxie]) {
		ski = $skill[acquire rhinestones];
		if (!get_property("_rhinestonesAcquired").to_boolean() && have_skill(ski) && my_mp() >= mp_cost(ski))
			use_skill(1,ski);
	}

	//genie bottle
	while (get_property("_genieWishesUsed").to_int() < 3) {
		visit_url(`inv_use.php?pwd={my_hash()}&which=3&whichitem=9529`);
		visit_url("choice.php?whichchoice=1267&wish=for+more+wishes&option=1",true,true);
	}

	//power plant
	if (item_amount($item[potted power plant]) > 0 && get_property("_pottedPowerPlant") != "0,0,0,0,0,0,0") {
		buffer buf = visit_url(`inv_use.php?pwd={my_hash()}&which=3&whichitem=10738`);
		if (buf.contains_text('name="whichchoice" value="1448"')) {
			matcher match = create_matcher('<button\\s+type="submit"\\s+name="pp"\\s+value="(\\d)"',buf);
			while (match.find())
				visit_url(`choice.php?pwd&whichchoice=1448&option=1&pp={match.group(1)}`,true,true);
		}
	}
}

void c2t_hccs_getFax(monster mon) {
	print(`getting fax of {mon}`,"blue");
	for i from 1 to 3 {
		if (mon == $monster[factory worker (female)]) {
			chat_private('cheesefax','fax factory worker');
			wait(15);//10 has failed multiple times
			cli_execute('fax get');
		}
		else
			faxbot(mon);

		if (get_property('photocopyMonster') == mon.manuel_name)
			break;

		cli_execute('fax send');
	}
	c2t_assert(get_property('photocopyMonster') == mon.manuel_name,'wrong fax monster');
}

//gave up trying to play nice, so brute forcing with visit_url()s
void c2t_hccs_pantagramming() {
	if (item_amount($item[portable pantogram]) > 0 && available_amount($item[pantogram pants]) == 0) {
		//use item
		visit_url("inv_use.php?which=3&whichitem=9573&pwd="+my_hash(),false,true);

		int temp;
		switch (my_primestat()) {
			case $stat[muscle]:
				temp = 1;
				break;
			case $stat[mysticality]:
				temp = 2;
				break;
			case $stat[moxie]:
				temp = 3;
				break;
			default:
				abort("broken stat?");
		}

		//primestat,hot res,+mp,+spell,-combat
		visit_url("choice.php?pwd&whichchoice=1270&option=1&e=1&s1=-2,0&s2=-2,0&s3=-1,0&m="+temp,true,true);
		cli_execute("refresh all");
	}
}

void c2t_hccs_vote() {
	if (!get_property("voteAlways").to_boolean() && !get_property("_voteToday").to_boolean())
		return;
	if (available_amount($item[&quot;I Voted!&quot; sticker]) > 0)
		return;
	if (my_daycount() > 1)
		abort("Need to manually vote. This is not set up to vote except for day 1.");

	buffer buf = visit_url('place.php?whichplace=town_right&action=townright_vote');

	//monster priority
	boolean [monster] monp = $monsters[angry ghost,government bureaucrat,terrible mutant,slime blob,annoyed snake];
	monster mon1 = get_property('_voteMonster1').to_monster();
	monster mon2 = get_property('_voteMonster2').to_monster();

	//for output
	int radi,che1,che2;

	//select monster
	foreach mon in monp {
		//randomise if it's a choice between the last 2
		if (mon == $monster[slime blob]) {
			radi = random(2)+1;
			break;
		}
		else if (mon1 == mon) {
			radi = 1;
			break;
		}
		else if (mon2 == mon) {
			radi = 2;
			break;
		}
	}

	//votes by class, from 0 to 3
	switch (my_class()) {
		default:
			abort("Unrecognized class for voting?");
		case $class[seal clubber]:
			//3 spooky res,10 stench damage,2 fam exp,-2 adventures
			che1 = 1;//10 stench damage
			che2 = 2;//2 familiar exp
			break;
		case $class[turtle tamer]:
			//100% weapon damage,10 ML,unrecorded unarmed damage,-20 moxie
			che1 = 0;//100% weapon damage
			che2 = 1;//10 ML
			break;
		case $class[pastamancer]:
			//30% gear drop,-10% crit,100% weapon damage,2 fam exp
			che1 = 2;//100% weapon damage
			che2 = 3;//2 fam exp
			break;
		case $class[sauceror]:
			//-10 ML,3 exp,-20 mys,3 spooky res
			che1 = 1;//3 exp
			che2 = 3;//3 spooky res
			break;
		case $class[disco bandit]:
			//30% max mp,10 hot damage,30% food drop,-20 item drop
			che1 = 0;//30% max mp
			che2 = 1;//10 hot damage
			break;
		case $class[accordion thief]:
			//3 stench res,-20 mysticality,30% booze drop,25% initiative
			che1 = 2;//30% booze drop
			che2 = 3;//25% initative
			break;
	}

	print("Voting for "+(radi==1?mon1:mon2)+", "+get_property('_voteLocal'+(che1+1))+", "+get_property('_voteLocal'+(che2+1)),"blue");
	buf = visit_url('choice.php?pwd&option=1&whichchoice=1331&g='+radi+'&local[]='+che1+'&local[]='+che2,true,false);

	if (available_amount($item[&quot;I Voted!&quot; sticker]) == 0)
		abort("Voting failed?");
}

boolean c2t_haveUse(item ite) {
	return c2t_haveUse(ite,1);
}
boolean c2t_haveUse(item ite,int min) {
	if (available_amount(ite) >= min) {
		use(min,ite);
		return true;
	}
	return false;
}

int c2t_getEffect(effect eff,skill ski) {
	return c2t_getEffect(eff,ski,1);	
}
int c2t_getEffect(effect eff,skill ski,int min) {
	//TODO find a more efficient way to do this
	while (have_effect(eff) < min && have_skill(ski))
		use_skill(ski);
	if (have_effect(eff) < min)
		abort("Unable to cast enough "+ski);
	return have_effect(eff);
}
int c2t_getEffect(effect eff,item ite) {
	return c2t_getEffect(eff,ite,1);
}
int c2t_getEffect(effect eff,item ite,int min) {
	//TODO find a more efficient way to do this
	//not going to allow repeated use of items for now
	if (have_effect(eff) < min) {
		if (item_amount(ite) == 0)
			retrieve_item(1,ite);//or maybe create() ?
		use(1,ite);
	}
	if (have_effect(eff) < min)
		print("Unable to use enough "+ite,"blue");
	return have_effect(eff);
}

boolean c2t_hccs_wishFight(monster mon) {
	if (!c2t_wishFight(mon))
		return false;
	run_turn();
	//if (choice_follows_fight()) //saber force breaks this I think?
		run_choice(-1);//just in case

	if (get_property("lastEncounter") != mon && get_property("lastEncounter") != "Using the Force")
		return false;
	return true;
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

		item temp = c2t_priority($item[God Lobster's Ring],$item[God Lobster's Scepter],$item[astral pet sweater]);
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
			c2t_getEffect($effect[Unrunnable Face],$item[runproof mascara]);

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
			num = (have_effect($effect[Bow-Legged Swagger]) > 0?25:50);
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
		if (available_amount($item[Industrial Fire Extinguisher]) > 0 && available_amount($item[Fourth of May Cosplay Saber]) > 0)
			c2t_hccs_getFax($monster[ungulith]);
		else if (is_online("cheesefax"))
			c2t_hccs_getFax($monster[factory worker (female)]);
		else
			c2t_hccs_getFax($monster[ungulith]);
	}

	use_skill(1,$skill[Spirit of Peppermint]);
	
	//fish hatchet
	if (!get_property('_floundryItemCreated').to_boolean() && !retrieve_item(1,$item[fish hatchet]))
		abort('Failed to get a fish hatchet');

	//cod piece steps
	/*if (!retrieve_item(1,$item[fish hatchet])) {
		retrieve_item(1,$item[codpiece]);
		c2t_haveUse(1,$item[codpiece]);
		c2t_haveUse(8,$item[bubblin' crude]);
		autosell(1,$item[oil cap]);
	}*/

	c2t_haveUse($item[astral six-pack]);

	//pantagramming
	c2t_hccs_pantagramming();

	//backup camera settings
	if (get_property('backupCameraMode') != 'ml' || !get_property('backupCameraReverserEnabled').to_boolean())
		cli_execute('backupcamera ml;backupcamera reverser on');

	//knock-off hero cape thing
	if (available_amount($item[unwrapped knock-off retro superhero cape]) > 0)
		cli_execute('retrocape '+my_primestat());

	//ebony epee from lathe
	if (available_amount($item[ebony epee]) == 0) {
		if (item_amount($item[SpinMaster&trade; Lathe]) > 0) {
			visit_url('shop.php?whichshop=lathe');
			retrieve_item(1,$item[ebony epee]);
		}
	}
	
	//FantasyRealm hat
	if (get_property("frAlways").to_boolean() && available_amount($item[FantasyRealm G. E. M.]) == 0) {
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
	c2t_haveUse($item[letter from King Ralph XI]);
	c2t_haveUse($item[pork elf goodies sack]);
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
	if (have_effect($effect[The Magical Mojomuscular Melody]) == 0)
		if (!use_skill(1,$skill[The Magical Mojomuscular Melody]))
			abort('mojomus fail');
	if (get_property('_candySummons').to_int() == 0)
		if (!use_skill(1,$skill[Summon Crimbo Candy]))
			abort('crimbo candy fail');

	//prevent scurvy
	if (available_amount($item[lime]) == 0) {
		if (my_mp() < 50) {
			if (get_property('timesRested').to_int() < total_free_rests())
				visit_url('place.php?whichplace=campaway&action=campaway_tentclick');
		}
		if (!use_skill(1,$skill[Prevent Scurvy and Sobriety]))
			abort('couldn\'t get rum and limes');
		c2t_hccs_breakfast();
	}
		
	// pre-coil pizza to get imitation whetstone for INFE pizza latter
	if (my_fullness() == 0) {
		// get imitation crab
		use_familiar($familiar[imitation crab]);
				
		// make pizza
		if (item_amount($item[diabolic pizza]) == 0) {
			retrieve_item(3,$item[cog and sprocket assembly]);
			
			if (available_amount($item[blood-faced volleyball]) == 0) {
				hermit(1,$item[volleyball]);
				
				if (have_effect($effect[Bloody Hand]) == 0) {
					hermit(1,$item[seal tooth]);
					c2t_getEffect($effect[Bloody Hand],$item[seal tooth]);
				}
				use(1,$item[volleyball]);
			}
						
			eat_pizza(
				$item[cog and sprocket assembly],
				$item[cog and sprocket assembly],
				$item[cog and sprocket assembly],
				$item[blood-faced volleyball]
				);	
		}
		else
			eat(1,$item[diabolic pizza]);
		use_familiar($familiar[Hovering Sombrero]);
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
		adv1($location[The Sleazy Back Alley], -1, '');	  
	}
	
	// drinking
	if (my_inebriety() == 0 && available_amount($item[distilled fortified wine]) >= 2) {
		if (have_effect($effect[Ode to Booze]) < 2) {
			if (my_mp() < 50) { //this block is assuming my setup w/ getaway camp
				cli_execute('breakfast');
				
				//cli_execute('rest free'); //<-- DANGEROUS
				if (get_property('timesRested') < total_free_rests())
					visit_url('place.php?whichplace=campaway&action=campaway_tentclick');
			}
			if (!use_skill(1,$skill[The Ode to Booze]))
				abort("couldn't cast ode to booze");
		}
		drink(2,$item[distilled fortified wine]);
	}
	*/

	//sometimes runs out of mp for clip art
	if (my_mp() < 11)
		cli_execute('rest free');

	// borrowed time
	if (!get_property('_borrowedTimeUsed').to_boolean()) {//&& get_property('tomeSummons').to_int() == 0) {
		c2t_assert(retrieve_item(1,$item[borrowed time]),"borrowed time fail");
		use(1,$item[borrowed time]);
	}

	// box of familiar jacks
	// going to get camel equipment straight away
	if (available_amount($item[dromedary drinking helmet]) == 0) {//&& get_property('tomeSummons').to_int() == 1) {
		c2t_assert(retrieve_item(1,$item[box of familiar jacks]),"box of familiar jacks fail");
		use_familiar($familiar[Melodramedary]);
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
				if (available_amount($item[beach comb]) == 0)
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
		//CSAs for later pizzas (3 for CER & HGh) //2 for CER & DIF or CER & KNI
		c2t_assert(retrieve_item(cog,$item[cog and sprocket assembly]),"Didn't get enough cog and sprocket assembly");
		//empty meat tank for DIF and INFE pizzas
		c2t_assert(retrieve_item(tank,$item[empty meat tank]),`Need {tank} emtpy meat tank`);
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
	if (have_effect($effect[That's Just Cloud-Talk, Man]) == 0)
		visit_url('place.php?whichplace=campaway&action=campaway_sky');
	if (have_effect($effect[That's Just Cloud-Talk, Man]) == 0)
		abort('Getaway camp buff failure');

	
	// shower exp buff
	if (!get_property('_aprilShower').to_boolean())
		cli_execute('shower '+my_primestat());
	
	if (my_primestat() == $stat[muscle]) {
		use_familiar($familiar[Exotic Parrot]);//an attempt to get its familiar equipment to maybe test
		if (my_fullness() == 3 && have_effect($effect[HGH-charged]) == 0) {
			if (available_amount($item[diabolic pizza]) == 0) {
				if (available_amount($item[hot buttered roll]) == 0)
					retrieve_item(1,$item[hot buttered roll]);
				pizza_effect(
					$effect[HGH-charged],
					c2t_priority($item[hot buttered roll],$item[Hollandaise helmet],$item[helmet turtle]),
					c2t_priority($item[gnollish autoplunger],$item[green seashell],$item[grain of sand]),
					c2t_priority($item[blood-faced volleyball],$item[cog and sprocket assembly]),
					$item[cog and sprocket assembly]
				);
			}
			else
				eat(1,$item[diabolic pizza]);
		}
		
		// mus exp synthesis; allowing this to be able to fail maybe
		if (have_effect($effect[Synthesis: Movement]) == 0) {
			if (!sweet_synthesis($effect[Synthesis: Movement])) { //works or no?
				print('Note: Synthesis: Movement failed. Going to fight a hobelf and try again.');
				if (!have_equipped($item[Fourth of May Cosplay saber]))
					equip($item[Fourth of May Cosplay saber]);
				if (!c2t_hccs_wishFight($monster[hobelf]))
					abort('Failed to fight hobelf');
				if (!sweet_synthesis($effect[Synthesis: Movement]))
					abort('Somehow failed to synthesize even after fighting hobelf');
			}
		}
		
		if (numeric_modifier('muscle experience percent') < 89.999) {
			abort('Insufficient +exp%');
			return false;
		}
	}
	else if (my_primestat() == $stat[mysticality]) {
		use_familiar($familiar[imitation crab]);
		
		retrieve_item(1, $item[meat stack]);
		retrieve_item(1, $item[full meat tank]);
		if (my_fullness() == 3 && have_effect($effect[Different Way of Seeing Things]) == 0) {
			if (available_amount($item[diabolic pizza]) == 0) {
				pizza_effect(
					$effect[Different Way of Seeing Things],
					$item[dry noodles],
					$item[imitation whetstone],
					$item[full meat tank],
					$item[cog and sprocket assembly]
				);
			}
			else
				eat(1,$item[diabolic pizza]);
		}
		
		// mys exp synthesis; allowing this to be able to fail maybe
		if (have_effect($effect[Synthesis: Learning]) == 0) {
			if (!sweet_synthesis($effect[Synthesis: Learning])) { //works or no?
				print('Note: Synthesis: Learning failed. Going to fight a hobelf and try again.');
				if (!have_equipped($item[Fourth of May Cosplay saber]))
					equip($item[Fourth of May Cosplay saber]);
				if (!c2t_hccs_wishFight($monster[hobelf]))
					abort('Failed to fight hobelf');
				if (!sweet_synthesis($effect[Synthesis: Learning]))
					abort('Somehow failed to synthesize even after fighting hobelf');
			}
		}
		
		//face
		ensure_effect($effect[Inscrutable Gaze]);

		if (numeric_modifier('mysticality experience percent') < 99.999) {
			abort('Insufficient +exp%');
			return false;
		}
	}
	else if (my_primestat() == $stat[moxie]) {
		//going for KNIg for 200% moxie
		use_familiar($familiar[imitation crab]);

		// 7 adventures, 12 turns of effect
		if (my_fullness() == 3 && have_effect($effect[Knightlife]) == 0) {
			retrieve_item(1,$item[ketchup]);
			if (available_amount($item[diabolic pizza]) == 0) {
				pizza_effect(
					$effect[Knightlife],
					$item[ketchup],
					$item[Newbiesport&trade; tent],
					$item[imitation whetstone],
					$item[cog and sprocket assembly]
				);
			}
			else
				eat(1,$item[diabolic pizza]);
		}

		// mox exp synthesis; allowing this to be able to fail maybe
		// if don't have the right candies, drop hardcore
		if (have_effect($effect[Synthesis: Style]) == 0) {
			if (item_amount($item[Crimbo candied pecan]) == 0 || item_amount($item[Crimbo fudge]) == 0) {
				print("Didn't get the right candies for buffs, so dropping hardcore.","blue");
				if (in_hardcore())
					c2t_dropHardcore();
				c2t_hccs_pull($item[Crimbo candied pecan]);
				c2t_hccs_pull($item[Crimbo fudge]);
			}
			if (!sweet_synthesis($effect[Synthesis: Style])) //works or no?
				//probably automate drop to softcore at this point and just pull needed candy
				print('Note: Synthesis: Style failed');
		}
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
	if (my_level() < 7 && c2t_hccs_buffExp()) {
		if (item_amount($item[familiar scrapbook]) > 0)
			equip($item[familiar scrapbook]);
		c2t_haveUse($item[a ten-percent bonus]);
	}
	if (my_level() < 7)
		abort('initial leveling broke');

	//some pulls if not in hard core; moxie would have already pulled up to 2 items so far
	if (my_primestat() == $stat[moxie] && pulls_remaining() > 3)
		c2t_hccs_pull($item[crumpled felt fedora]);//200 mox; saves 2 for fam test
	c2t_hccs_pull($item[Great Wolf's beastly trousers]);//100 mus; saves 2 for fam test
	c2t_hccs_pull($item[Staff of Simmering Hatred]);//125 mys; saves 4 for spell test
	//rechecking this sometime after leveling for non-mys since 150 mys is possible
	if (my_primestat() == $stat[mysticality])
		c2t_hccs_pull($item[Stick-Knife of Loathing]);//150 mys; saves 4 for spell test

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
	
	if (have_effect($effect[One Very Clear Eye]) == 0) {
		while (c2t_hccs_wandererFight());//do vote monster if ready before spending turn
		if (c2t_hccs_semirareItem())
			c2t_getEffect($effect[One Very Clear Eye],$item[cyclops eyedrops]);
	}

	//emotion chip stat buff
	c2t_getEffect($effect[Feeling Excited],$skill[Feel Excitement]);

	c2t_getEffect($effect[The Magical Mojomuscular Melody],$skill[The Magical Mojomuscular Melody]);
	
	// daycare stat gain
	if (get_property("daycareOpen").to_boolean() && get_property('_daycareGymScavenges').to_int() == 0) {
		visit_url('place.php?whichplace=town_wrong&action=townwrong_boxingdaycare');
		run_choice(3);//1334,3 boxing daycare lobby->boxing daycare
		run_choice(2);//1336,2 scavenge
	}
	
	
	// getaway camp buff //probably causes infinite loop without getaway camp
	if (get_property('_campAwaySmileBuffs').to_int() == 0)
		visit_url('place.php?whichplace=campaway&action=campaway_sky');
	
	//monorail
	if (get_property('_lyleFavored') == 'false')
		ensure_effect($effect[Favored by Lyle]);
	
	if (available_amount($item[eight days a week pill keeper]) > 0) {
		ensure_effect($effect[Hulkien]); //pillkeeper stats
		ensure_effect($effect[Fidoxene]);//pillkeeper familiar
	}
	
	//beach comb leveling buffs
	if (available_amount($item[beach comb]) > 0) {
		ensure_effect($effect[You Learned Something Maybe!]); //beach exp
		ensure_effect($effect[Do I Know You From Somewhere?]);//beach fam wt
		if (my_primestat() == $stat[moxie])
			ensure_effect($effect[Pomp & Circumsands]);//beach moxie
	}

	// Cast Ode and drink bee's knees
	// going to skip this for non-moxie to use clip art's buff of same strength
	if (my_primestat() == $stat[moxie] && have_effect($effect[On the Trolley]) == 0 && my_inebriety() == 0) {
		c2t_assert(my_meat() >= 500,"Need 500 meat for speakeasy booze");
		c2t_getEffect($effect[Ode to Booze],$skill[The Ode to Booze],5);
		cli_execute('drink 1 Bee\'s Knees');
		//probably don't need to drink the perfect drink; have to double-check all inebriety checks before removing
		//drink(1,$item[perfect dark and stormy]);
		//cli_execute('drink perfect dark and stormy');
	}
	//just in case
	if (have_effect($effect[Ode to Booze]) > 0)
		cli_execute('shrug ode to booze');
	
	//fortune buff item
	if (get_property('_clanFortuneBuffUsed') == 'false')
		ensure_effect($effect[There's No N In Love]);

	//cast triple size
	if (available_amount($item[powerful glove]) > 0 && have_effect($effect[Triple-Sized]) == 0 && !c2t_cast($skill[CHEAT CODE: Triple Size]))
		abort('Triple size failed');

	//candles
	c2t_haveUse($item[Napalm In The Morning&trade; candle]);
	c2t_haveUse($item[votive of confidence]);
	
	//boxing daycare, synthesis, and bastille
	if (my_primestat() == $stat[muscle]) {
		if (get_property("daycareOpen").to_boolean() && have_effect($effect[Muddled]) == 0)
			cli_execute('daycare mus');
		if (have_effect($effect[Synthesis: Strong]) == 0) {
			if (available_amount($item[Crimbo candied pecan]) > 0)
				retrieve_item(1, $item[jaba&ntilde;ero-flavored chewing gum]);
			else if (available_amount($item[Crimbo peppermint bark]) > 0)
				retrieve_item(1, $item[tamarind-flavored chewing gum]);
			sweet_synthesis($effect[Synthesis: Strong]);
		}
		if (get_property('_bastilleGames').to_int() == 0)
			cli_execute('bastille muscle');
	}
	else if (my_primestat() == $stat[mysticality]) {
		if (get_property("daycareOpen").to_boolean() && have_effect($effect[Uncucumbered]) == 0)
			cli_execute('daycare mys');
		if (have_effect($effect[Synthesis: Smart]) == 0) {
			if (available_amount($item[Crimbo peppermint bark]) > 0)
				retrieve_item(1, $item[lime-and-chile-flavored chewing gum]);
			else if (available_amount($item[Crimbo fudge]) > 0)
				retrieve_item(1, $item[tamarind-flavored chewing gum]);
			sweet_synthesis($effect[Synthesis: Smart]);
		}
		if (get_property('_bastilleGames').to_int() == 0)
			cli_execute('bastille myst brutalist');
	}
	else if (my_primestat() == $stat[moxie]) {
		if (get_property("daycareOpen").to_boolean() && have_effect($effect[Ten out of Ten]) == 0)
			cli_execute('daycare mox');
		if (have_effect($effect[Synthesis: Cool]) == 0) {
			if (available_amount($item[Crimbo peppermint bark]) > 0)
				retrieve_item(1,$item[pickle-flavored chewing gum]);
			else if (available_amount($item[Crimbo fudge]) > 0)
				retrieve_item(1,$item[lime-and-chile-flavored chewing gum]);
			else if (available_amount($item[Crimbo candied pecan]) > 0)
				retrieve_item(1,$item[tamarind-flavored chewing gum]);
			sweet_synthesis($effect[Synthesis: Cool]);
		}
		if (get_property('_bastilleGames').to_int() == 0)
			cli_execute('bastille moxie brutalist');
	}

	// Check G-9, then genie effect Experimental Effect G-9/New and Improved
	if (my_primestat() != $stat[moxie]) {// going to wish for an evil olive to saber YR for moxie
		if ((my_primestat() == $stat[muscle] &&
			(have_effect($effect[Synthesis: Strong]) == 0 || have_effect($effect[Synthesis: Movement]) == 0)) ||
			(my_primestat() == $stat[mysticality] && 
			(have_effect($effect[Synthesis: Smart]) == 0 || have_effect($effect[Synthesis: Learning]) == 0))
			) {
			//edge case recoveries:
			//this one assumes hobelf wasn't fought earlier, since this shouldn't be needed if so. otherwise, too many saber yr allocations
			effect synth;
			item candy1;
			if (my_primestat() == $stat[muscle]) {
				synth = $effect[Synthesis: Strong];
				candy1 = $item[Crimbo fudge];
			}
			else if (my_primestat() == $stat[mysticality]) {
				synth = $effect[Synthesis: Smart];
				candy1 = $item[Crimbo candied pecan];
			}
			if (have_effect(synth) == 0 && item_amount(candy1) > 0) {
				if (item_amount($item[pile of candy]) == 0) {
					if (!have_equipped($item[fourth of may cosplay saber]))
						equip($item[fourth of may cosplay saber]);
					c2t_cartographyHunt($location[South of the Border],$monster[angry pi&ntilde;ata]);
					run_turn();
					run_choice(-1);
				}
				sweet_synthesis(synth);
				c2t_assert(have_effect(synth) > 0,"Synthesis failed even after fighting an angry pinata");
			}

			//not going to wish for g9 anymore
			else
				abort("Synthesize didn't work properly");

			/*
			print("Wishing for stat boost","blue");
			if (have_effect($effect[Experimental Effect G-9]) == 0 && have_effect($effect[New and Improved]) == 0) {
				effect g9 = $effect[Experimental Effect G-9];
				if (g9.numeric_modifier('muscle percent') < 0.001) {
					// Not cached. This should trick Mafia into caching the G-9 value for the day.
					visit_url('desc_effect.php?whicheffect=' + g9.descid);
					if (g9.numeric_modifier('muscle percent') < 0.001)
						abort('Check G9');
				}
				//if (my_primestat() == $stat[muscle]) {
					if (g9.numeric_modifier('muscle percent') > 200)
						wish_effect(g9);
					else
						wish_effect($effect[New and Improved]);
				//}
			}
			*/
		}
		else if (have_effect($effect[Purity of Spirit]) == 0) {
			print("Saving wish for disquiet riot, but using last tome for stat boost","blue");
			retrieve_item(1,$item[cold-filtered water]);
			use(1,$item[cold-filtered water]);
		}
	}
	//no longer using bee's knees for stat boost on non-moxie, but still need same strength buff?
	else if (have_effect($effect[Purity of Spirit]) == 0) {
		//technically should have the item already, so just making sure
		retrieve_item(1,$item[cold-filtered water]);
		use(1,$item[cold-filtered water]);
		use(item_amount($item[rhinestone]),$item[rhinestone]);
	}


	use_familiar($familiar[hovering sombrero]);
	
	cli_execute('telescope high');
	cli_execute('mcd 10');

	return true;
}

// get semirare from limerick dungeon
boolean c2t_hccs_semirareItem() {
	if (available_amount($item[cyclops eyedrops]) == 0 && have_effect($effect[One Very Clear Eye]) == 0) {
		//11-leaf clover
		visit_url("hermit.php?autoworthless=on");
		visit_url("hermit.php?action=trade&whichitem=10881&quantity=1",true,true);
		visit_url(`inv_use.php?pwd={my_hash()}&which=3&whichitem=10881`,false,true);
		//recover hp
		if (my_hp() < (0.5 * my_maxhp()))
			cli_execute('hottub');
		cli_execute('mood apathetic');
		cli_execute('counters nowarn Fortune Cookie');
		adv1($location[The Limerick Dungeon], -1, '');
	}
	return true;
}

boolean c2t_hccs_lovePotion(boolean useit) {
	return c2t_hccs_lovePotion(useit,false);
}

boolean c2t_hccs_lovePotion(boolean useit,boolean dumpit) {
	item love_potion = $item[Love Potion #0];
	effect love_effect = $effect[Tainted Love Potion];
	
	if (have_effect(love_effect) == 0) {
		if (available_amount(love_potion) == 0) {
			if (my_mp() < 50) { //this block is assuming my setup
				c2t_hccs_breakfast();
				if (get_property('timesRested').to_int() < total_free_rests())
					visit_url('place.php?whichplace=campaway&action=campaway_tentclick');
				else
					abort('Ran out of free rests. Recover mp another way.');
			}
			use_skill(1,$skill[Love Mixology]);
		}
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
	if (have_effect($effect[feeling lost]) == 0 && (have_effect($effect[Bat-Adjacent Form]) == 0 || !get_property('latteUnlocks').contains_text('carrot'))) {
		maximize("mainstat,equip latte,1000 bonus lil doctor bag,1000 bonus vampyric cloake",false);
		use_familiar($familiar[melodramedary]);

		while ((have_equipped($item[vampyric cloake]) && have_effect($effect[Bat-Adjacent Form]) == 0) || !get_property('latteUnlocks').contains_text('carrot'))
			adv1($location[The Dire Warren],-1,"");
	}

	if (!get_property('latteModifier').contains_text('Item Drop') && get_property('_latteBanishUsed') == 'true')
		cli_execute('latte refill cinnamon carrot vanilla');

	ensure_effect($effect[Fat Leon's Phat Loot Lyric]);
	ensure_effect($effect[Singer's Faithful Ocelot]);
	ensure_effect($effect[The Spirit of Taking]);

	// might move back to levelup part
	if (have_effect($effect[Certainty]) == 0) {
		if (my_fullness() != 6)
			abort('fullness not where it should be for CER pizza');
		if (available_amount($item[electronics kit]) == 0)
			abort('missing electronics kit for CER pizza');

		pizza_effect(
			$effect[Certainty],
			$item[cog and sprocket assembly],
			$item[electronics kit],
			$item[razor-sharp can lid],
			c2t_priority($item[Middle of the Road&trade; brand whiskey],$item[PB&J with the crusts cut off],$item[surprisingly capacious handbag])
		);
	}
	
	// might move back to level up part
	if (have_effect($effect[Infernal Thirst]) == 0) {
		if (my_fullness() != 9)
			abort('fullness not where it should be for INFE pizza');
		// random chance to get cracker until able to reliably replace electronics kit in recipe
		use_familiar($familiar[Exotic Parrot]);
		
		retrieve_item(1,$item[full meat tank]);

		if (item_amount($item[eldritch effluvium]) == 0 && item_amount($item[eaves droppers]) == 0 && (available_amount($item[cracker]) == 0 || item_amount($item[electronics kit]) == 0))
			retrieve_item(1,$item[eyedrops of the ermine]);

		pizza_effect(
			$effect[Infernal Thirst],
			$item[imitation whetstone],
			c2t_priority($item[neverending wallet chain], $item[Newbiesport&trade; tent]),
			$item[full meat tank],
			c2t_priority($item[eldritch effluvium],$item[eaves droppers],$item[eyedrops of the ermine],$item[electronics kit])
		);
	}
	
	//spice ghost
	if (my_class() == $class[pastamancer]) {
		if (my_thrall() != $thrall[Spice Ghost]) {
			if (my_mp() < 250)
				cli_execute('eat magical sausage');
			use_skill($skill[Bind Spice Ghost]);
		}
	}
	else {
		if (my_mp() < 250)
			cli_execute('eat magical sausage');
		ensure_effect($effect[Spice Haze]);
	}

	//AT-only buff
	if (my_class() == $class[accordion thief])
		ensure_song($effect[The Ballad of Richie Thingfinder]);

	ensure_effect($effect[Nearly All-Natural]);//bag of grain
	ensure_effect($effect[Steely-Eyed Squint]);

	//extra hand for latte in cases of 2 item drop weapons
	if (have_familiar($familiar[left-hand man]))
		use_familiar($familiar[left-hand man]);
	
	maximize('item,2 booze drop,-equip broken champagne bottle,-equip surprisingly capacious handbag,-equip red-hot sausage fork', false);


	//THINGS I DON'T ALWAYS WANT TO USE FOR ITEM TEST

	//if familiar test is ever less than 19 turns, feel lost will need to be completely removed or the test order changed
	if (!c2t_hccs_thresholdMet(TEST_ITEM))
		c2t_getEffect($effect[Feeling Lost],$skill[Feel Lost]);

	if (!c2t_hccs_thresholdMet(TEST_ITEM)) {
		retrieve_item(1,$item[oversized sparkler]);
		//repeat of previous maximize call
		maximize('item,2 booze drop,-equip broken champagne bottle,-equip surprisingly capacious handbag,-equip red-hot sausage fork', false);
	}

	//power plant; last to save batteries if not needed
	if (!c2t_hccs_thresholdMet(TEST_ITEM))
		if (item_amount($item[potted power plant]) > 0)
			c2t_getEffect($effect[Lantern-Charged],$item[battery (lantern)]);

	c2t_hccs_mod2log("modtrace item drop;modtrace booze drop");

	return c2t_hccs_thresholdMet(TEST_ITEM);
}

boolean c2t_hccs_preHotRes() {
	//cloake buff and fireproof foam suit for +32 hot res total, but also weapon and spell test buffs
	//weapon/spell buff should last 15 turns, which is enough to get through hot(1), NC(9), and weapon(1) tests to also affect the spell test
	if (have_effect($effect[Do You Crush What I Crush?]) == 0 && have_familiar($familiar[Ghost of Crimbo Carols])) {
		equip($item[Vampyric Cloake]);
		equip($slot[weapon],$item[Fourth of May Cosplay Saber]);
		if (available_amount($item[Industrial Fire Extinguisher]) > 0)
			equip($slot[off-hand],$item[Industrial Fire Extinguisher]);
		if (my_mp() < 30)
			cli_execute('rest free');
		use_familiar($familiar[Ghost of Crimbo Carols]);
		adv1($location[The Dire Warren],-1,"");
		run_turn();
	}

	use_familiar($familiar[Exotic Parrot]);

	ensure_effect($effect[Blood Bond]);
	ensure_effect($effect[Leash of Linguini]);
	ensure_effect($effect[Empathy]);

	ensure_effect($effect[Elemental Saucesphere]);
	ensure_effect($effect[Astral Shell]);

	//beach comb hot buff
	if (available_amount($item[beach comb]) > 0)
		ensure_effect($effect[Hot-Headed]);

	//emotion chip
	c2t_getEffect($effect[Feeling Peaceful],$skill[Feel Peaceful]);

	//familiar weight
	ensure_effect($effect[Blood Bond]);
	ensure_effect($effect[Leash of Linguini]);
	ensure_effect($effect[Empathy]);

	maximize('100hot res, familiar weight', false);
	// need to run this twice because familiar weight thresholds interfere with it?
	maximize('100hot res, familiar weight', false);


	//THINGS I DON'T USE FOR HOT TEST ANYMORE, but will fall back on if other things break

	//daily candle
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES))
		c2t_haveUse($item[rainbow glitter candle]);

	//magenta seashell
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES))
		if (available_amount($item[magenta seashell]) > 0)
			ensure_effect($effect[Too Cool for (Fish) School]);

	//potion for sleazy hands & hot powder
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES)) {
		//potion making not needed with retro cape
		retrieve_item(1, $item[tenderizing hammer]);
		cli_execute('smash * ratty knitted cap');
		cli_execute('smash * red-hot sausage fork');

		if (available_amount($item[hot powder]) > 0)
			c2t_getEffect($effect[Flame-Retardant Trousers],$item[hot powder]);

		if (available_amount($item[sleaze nuggets]) > 0 || available_amount($item[lotion of sleaziness]) > 0)
			c2t_getEffect($effect[Sleazy Hands],$item[lotion of sleaziness]);
	}

	//pocket maze
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES))
		ensure_effect($effect[Amazing]);

	//synthesis: hot
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES))
		if (have_effect($effect[Synthesis: Hot]) == 0) {
			retrieve_item(2, $item[jaba&ntilde;ero-flavored chewing gum]);
			sweet_synthesis($item[jaba&ntilde;ero-flavored chewing gum], $item[jaba&ntilde;ero-flavored chewing gum]);
		}

	//pillkeeper
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES))
		if (available_amount($item[eight days a week pill keeper]) > 0 && have_effect($effect[Rainbowolin]) == 0)
			cli_execute('pillkeeper elemental');

	//pocket wish
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES))
		if (get_property('_genieWishesUsed').to_int() < 3 || available_amount($item[pocket wish]) > 0)
			cli_execute("genie effect "+$effect[Fireproof Lips]);

	//speakeasy drink
	if (!c2t_hccs_thresholdMet(TEST_HOT_RES)) {
		if (have_effect($effect[Feeling No Pain]) == 0) {
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

		if (!have_equipped($item[Fourth of May Cosplay Saber]))
			equip($item[Fourth of May Cosplay Saber]);

		if (item_amount($item[photocopied monster]) > 0) {
			use(1,$item[photocopied monster]);
			run_turn();
		}
		else {
			if (available_amount($item[industrial fire extinguisher]) > 0)
				c2t_assert(c2t_hccs_wishFight($monster[ungulith]),"ungulith wish fail");
			else
				c2t_assert(c2t_hccs_wishFight($monster[factory worker (female)]),"factory worker wish fail");
		}
	}

	// Pool buff
	ensure_effect($effect[Billiards Belligerence]);

	if (my_hp() < 30) use_skill(1, $skill[Cannelloni Cocoon]);
	ensure_effect($effect[Blood Bond]);
	ensure_effect($effect[Leash of Linguini]);
	ensure_effect($effect[Empathy]);

	//AT-only buff
	if (my_class() == $class[accordion thief])
		ensure_song($effect[Chorale of Companionship]);

	use_familiar($familiar[Exotic Parrot]);
	maximize('familiar weight', false);

	//should only get 1 per run, if any; would use in NEP combat loop, but no point as sombrero would already be already giving max stats
	if (!c2t_hccs_thresholdMet(TEST_FAMILIAR))
		c2t_haveUse($item[short stack of pancakes]);

	c2t_hccs_mod2log("modtrace familiar weight");

	return c2t_hccs_thresholdMet(TEST_FAMILIAR);
}


boolean c2t_hccs_preNoncombat() {
	if (my_hp() < 30) use_skill(1, $skill[Cannelloni Cocoon]);
	ensure_effect($effect[Blood Bond]);
	ensure_effect($effect[Leash of Linguini]);
	ensure_effect($effect[Empathy]);

	// Pool buff. Should fall through to weapon damage.
	//not going to use this here, as it doesn't do to the noncombat rate in the moment anyway
	//ensure_effect($effect[Billiards Belligerence]);

	ensure_effect($effect[The Sonata of Sneakiness]);
	ensure_effect($effect[Smooth Movements]);
	if (available_amount($item[powerful glove]) > 0 && have_effect($effect[Invisible Avatar]) == 0 && !c2t_cast($skill[CHEAT CODE: Invisible Avatar]))
		abort('Invisible avatar failed');

	ensure_effect($effect[Silent Running]);

	if (have_familiar($familiar[god lobster]) && have_effect($effect[Silence of the God Lobster]) == 0 && get_property('_godLobsterFights').to_int() < 3) {
		cli_execute('mood apathetic');
		use_familiar($familiar[god lobster]);
		equip($item[God Lobster's Ring]);
		
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
	if (have_effect($effect[Feeling Lonely]) == 0 && get_property('_feelLonelyUsed').to_int() < $skill[Feel Lonely].dailylimit)
		use_skill(1,$skill[Feel Lonely]);
	
	// Rewards // use these after globster fight, just in case of losing
	ensure_effect($effect[Throwing Some Shade]);
	ensure_effect($effect[A Rose by Any Other Material]);


	use_familiar($familiar[Disgeist]);

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
	if (!c2t_hccs_thresholdMet(TEST_NONCOMBAT) && c2t_hccs_testTurns(TEST_NONCOMBAT) >= 9)
		if (have_effect($effect[Disquiet Riot]) == 0 && item_amount($item[pocket wish]) > 1)
			cli_execute('genie effect disquiet riot');

	c2t_hccs_mod2log("modtrace combat rate");

	return c2t_hccs_thresholdMet(TEST_NONCOMBAT);
}

boolean c2t_hccs_preWeapon() {
	if (get_property('camelSpit').to_int() != 100 && have_effect($effect[Spit Upon]) == 0)
		abort('Camel spit only at '+get_property('camelSpit')+'%.');

	//cast triple size
	if (available_amount($item[powerful glove]) > 0 && have_effect($effect[Triple-Sized]) == 0 && !c2t_cast($skill[CHEAT CODE: Triple Size]))
		abort('Triple size failed');

	if (my_mp() < 500 && my_mp() != my_maxmp())
		cli_execute('eat mag saus');

	// moved to hot res test
	/*if (have_effect($effect[Do You Crush What I Crush?]) == 0 && have_familiar($familiar[Ghost of Crimbo Carols]) && (get_property('_snokebombUsed').to_int() < 3 || !get_property('_latteBanishUsed').to_boolean())) {
		equip($item[Latte Lovers member's mug]);
		if (my_mp() < 30)
			cli_execute('rest free');
		use_familiar($familiar[Ghost of Crimbo Carols]);
		adv1($location[The Dire Warren],-1,"");
	}*/

	if (have_effect($effect[In a Lather]) == 0) {
		if (my_inebriety() > inebriety_limit() - 2)
			abort('Something went wrong. We are too drunk.');
		c2t_assert(my_meat() >= 500,"Need 500 meat for speakeasy booze");
		ensure_ode(2);
		cli_execute('drink Sockdollager');
	}

	if (available_amount($item[twinkly nuggets]) > 0)
		ensure_effect($effect[Twinkly Weapon]);

	ensure_effect($effect[Carol of the Bulls]);
	ensure_effect($effect[Rage of the Reindeer]);
	ensure_effect($effect[Frenzied, Bloody]);
	ensure_effect($effect[Scowl of the Auk]);
	ensure_effect($effect[Tenacity of the Snapper]);
	
	//don't have these skills yet. maybe should add check for all skill uses to make universal?
	if (have_skill($skill[Song of the North]))
		ensure_effect($effect[Song of the North]);
	if (have_skill($skill[Jackasses' Symphony of Destruction]))
		ensure_song($effect[Jackasses' Symphony of Destruction]);

	if (available_amount($item[vial of hamethyst juice]) > 0)
		ensure_effect($effect[Ham-Fisted]);

	// Hatter buff
	if (available_amount($item[&quot;DRINK ME&quot; potion]) > 0) {
		retrieve_item(1, $item[goofily-plumed helmet]);
		ensure_effect($effect[Weapon of Mass Destruction]);
	}

	//beach comb weapon buff
	if (available_amount($item[beach comb]) > 0)
		ensure_effect($effect[Lack of Body-Building]);

	// Boombox potion
	if (available_amount($item[Punching Potion]) > 0)
		ensure_effect($effect[Feeling Punchy]);

	// Pool buff. Should have fallen through from noncom
	ensure_effect($effect[Billiards Belligerence]);

	//meteor shower
	if ((have_skill($skill[meteor lore]) && have_effect($effect[meteor showered]) == 0)
		|| (have_familiar($familiar[melodramedary]) && have_effect($effect[spit upon]) == 0 && get_property('camelSpit').to_int() == 100)) {

		cli_execute('mood apathetic');

		//only 2 things needed for combat:
		if (!have_equipped($item[fourth of may cosplay saber]))
			equip($item[fourth of may cosplay saber]);
		use_familiar(c2t_priority($familiars[melodramedary]));

		adv1($location[Thugnderdome],-1,"");//everything is saberable and no crazy NCs
	}

	c2t_getEffect($effect[Cowrruption],$item[corrupted marrow]);

	if (have_effect($effect[Engorged Weapon]) == 0) {
		retrieve_item(1,$item[Meleegra&trade; pills]);
		use(1,$item[Meleegra&trade; pills]);
	}
	
	//tainted seal's blood
	if (available_amount($item[tainted seal's blood]) > 0)
		ensure_effect($effect[Corruption of Wretched Wally]);


	// turtle tamer saves ~1 turn with this part, and 4 from voting
	if (my_class() == $class[turtle tamer]) {
		if (have_effect($effect[Boon of She-Who-Was]) == 0) {
			ensure_effect($effect[Blessing of She-Who-Was]);
			ensure_effect($effect[Boon of She-Who-Was]);
		}
		ensure_effect($effect[Blessing of the War Snapper]);
	}
	else
		ensure_effect($effect[Disdain of the War Snapper]);
	
	ensure_effect($effect[Bow-Legged Swagger]);
	
	maximize('weapon damage', false);

	//OU pizza if needed
	if (!c2t_hccs_thresholdMet(TEST_WEAPON) && c2t_hccs_testTurns(TEST_WEAPON) > 3) {//TODO
		if (have_effect($effect[Outer Wolf&trade;]) == 0 && my_fullness() == 12) {
			// Should have a second grapefruit from Scurvy.
			// but maybe not enough reagents
			retrieve_item(1,$item[ointment of the occult]);

			//preferring useless powder over duffel bag
			if (available_amount($item[useless powder]) == 0) {
				// get useless powder.
				retrieve_item(1,$item[cool whip]);
				cli_execute('smash 1 cool whip');
			}

			//select final 2 ingredients that don't affect pizza result
			item it1,it2;
			item [int] ingredients = {$item[Middle of the Road&trade; brand whiskey],$item[surprisingly capacious handbag],$item[PB&J with the crusts cut off]};

			it1 = c2t_priority(ingredients);
			if (item_amount(it1) > 1)
				it2 = it1;
			else {
				foreach i,x in ingredients if (it1 == x) {
					remove ingredients[i];
					break;
				}
				it2 = c2t_priority(ingredients);
			}
			c2t_assert(it2 != $item[none],"OU pizza ingredient selection failed");

			//make/eat pizza
			pizza_effect(
				$effect[Outer Wolf&trade;],
				c2t_priority($item[ointment of the occult],$item[out-of-tune biwa]),
				c2t_priority($item[useless powder],$item[unremarkable duffel bag]),
				it1,
				it2
			);

			if (have_effect($effect[Outer Wolf&trade;]) == 0)
				abort('OU pizza failed');
		}
	}
	if (have_effect($effect[Outer Wolf&trade;]) == 0)
		print("OU pizza skipped","blue");

	//cargo shorts as backup
	if (available_amount($item[cargo cultist shorts]) > 0
		&& !c2t_hccs_thresholdMet(TEST_WEAPON)
		&& c2t_hccs_testTurns(TEST_WEAPON) > 4 //4 is how much cargo would save on spell test, so may as well use here if spell is not better
		&& have_effect($effect[Rictus of Yeg]) == 0
		&& !get_property('_cargoPocketEmptied').to_boolean())
			cli_execute("cargo item yeg's motel toothbrush");
	c2t_haveUse($item[Yeg's Motel Toothbrush]);

	c2t_hccs_mod2log("modtrace weapon damage");

	return c2t_hccs_thresholdMet(TEST_WEAPON);
}

boolean c2t_hccs_preSpell() {
	if (my_mp() < 500 && my_mp() != my_maxmp())
		cli_execute('eat mag saus');

	// This will use an adventure.
	// if spit upon == 1, simmering will just waste a turn to do essentially nothing.
	// probably good idea to add check for similar effects to not just waste a turn
	if (have_effect($effect[Spit Upon]) != 1 && have_effect($effect[Do You Crush What I Crush?]) != 1)
		ensure_effect($effect[Simmering]);

	while (c2t_hccs_wandererFight()); //check for after using a turn to cast Simmering

	//don't have this skill yet. Maybe should add check for all skill uses to make universal?
	if (have_skill($skill[Song of Sauce]))
		ensure_effect($effect[Song of Sauce]);
	if (have_skill($skill[Jackasses' Symphony of Destruction]))
		ensure_effect($effect[Jackasses' Symphony of Destruction]);
	
	ensure_effect($effect[Carol of the Hells]);

	// Pool buff
	ensure_effect($effect[Mental A-cue-ity]);

	//beach comb spell buff
	if (available_amount($item[beach comb]) > 0)
		ensure_effect($effect[We're All Made of Starfish]);

	use_skill(1, $skill[Spirit of Peppermint]);
	
	// face
	ensure_effect($effect[Arched Eyebrow of the Archmage]);

	if (available_amount($item[flask of baconstone juice]) > 0)
		ensure_effect($effect[Baconstoned]);

	//pull stick-knife if able to equip
	if (my_basestat($stat[mysticality]) >= 150)
		c2t_hccs_pull($item[Stick-Knife of Loathing]);

	//get up to 2 obsidian nutcracker
	int nuts = 2;
	foreach x in $items[Stick-Knife of Loathing,Staff of Simmering Hatred]//,Abracandalabra]
		if (available_amount(x) > 0)
			nuts--;
	if (!have_familiar($familiar[left-hand man]) && available_amount($item[Abracandalabra]) > 0)
		nuts--;
	retrieve_item(nuts<0?0:nuts,$item[obsidian nutcracker]);

	//AT-only buff
	if (my_class() == $class[accordion thief])
		ensure_song($effect[Elron's Explosive Etude]);

	// cargo pocket
	if (available_amount($item[cargo cultist shorts]) > 0 && have_effect($effect[Sigils of Yeg]) == 0 && !get_property('_cargoPocketEmptied').to_boolean())
		cli_execute("cargo item Yeg's Motel hand soap");
	c2t_haveUse($item[Yeg's Motel hand soap]);

	// meteor lore // moxie can't do this, as it wastes a saber on evil olive -- moxie should be able to do this now with nostalgia earlier?
	if (have_skill($skill[meteor lore]) && have_effect($effect[meteor showered]) == 0 && get_property('_saberForceUses').to_int() < 5) {
		maximize("mainstat,equip fourth of may cosplay saber",false);
		adv1($location[Thugnderdome],-1,"");//everything is saberable and no crazy NCs
	}

	if (have_skill($skill[Deep Dark Visions]) && have_effect($effect[Visions of the Deep Dark Deeps]) == 0) {
		ensure_effect($effect[Elemental Saucesphere]);
		ensure_effect($effect[Astral Shell]);
		maximize("1000spooky res,hp,mp",false);
		if (my_hp() < 800)
			use_skill(1,$skill[Cannelloni Cocoon]);
		ensure_effect($effect[Visions of the Deep Dark Deeps]);
	}

	//if I ever feel like blowing the resources:
	if (get_property('_c2t_hccs_dstab').to_boolean()) {
		//the only way is all the way
		if (item_amount($item[pocket wish]) > 0 && have_effect($effect[Witch Breaded]) == 0) {
			cli_execute('genie effect witch breaded');

			// not actually going to use this for now as it's not profitable; TODO might make it conditional on a user setting or mall price though
			//batteries
			c2t_getEffect($effect[D-Charged],$item[battery (D)]);
			c2t_getEffect($effect[AA-Charged],$item[battery (AA)]);
			c2t_getEffect($effect[AAA-Charged],$item[battery (AAA)]);
		}
	}

	//for potential astral statuette on familiar
	if (have_familiar($familiar[left-hand man]))
		use_familiar($familiar[left-hand man]);

	//need to figure out pulls
	if (!in_hardcore() && pulls_remaining() > 0) {
		//lazy way for now
		boolean [item] derp;
		if (available_amount($item[astral statuette]) == 0)
			derp = $items[Cold Stone of Hatred,Fuzzy Slippers of Hatred,Lens of Hatred,witch's bra];
		else
			derp = $items[Fuzzy Slippers of Hatred,Lens of Hatred,witch's bra];

		foreach x in derp {
			if (pulls_remaining() == 0)
				break;
			c2t_hccs_pull(x);
		}
		if (pulls_remaining() > 0)
			print(`Still had {pulls_remaining()} pulls remaining for the last test`,"red");
	}

	maximize('spell damage', false);

	c2t_hccs_mod2log("modtrace spell damage");

	return c2t_hccs_thresholdMet(TEST_SPELL);
}





// stat tests are super lazy for now
// TODO need to figure out a way to not overdo buffs, as some buffers may be needed for pizzas
boolean c2t_hccs_preHp() {
	if (!c2t_hccs_thresholdMet(TEST_HP))
		maximize('hp',false);
	return c2t_hccs_thresholdMet(TEST_HP);
}

boolean c2t_hccs_preMus() {
	//TODO if pastamancer, add summon of mus thrall if need? currently using equaliser potion out of laziness
	if (!c2t_hccs_thresholdMet(TEST_MUS))
		maximize('mus',false);
	return c2t_hccs_thresholdMet(TEST_MUS);
}

boolean c2t_hccs_preMys() {
	if (!c2t_hccs_thresholdMet(TEST_MYS))
		maximize('mys',false);
	return c2t_hccs_thresholdMet(TEST_MYS);
}

boolean c2t_hccs_preMox() {
	//TODO if pastamancer, add summon of mox thrall if need? currently using equaliser potion out of laziness
	if (!c2t_hccs_thresholdMet(TEST_MOX))
		maximize('mox',false);
	return c2t_hccs_thresholdMet(TEST_MOX);
}

void c2t_hccs_fights() {
	//TODO move familiar changes and maximizer calls inside of blocks
	// saber yellow ray stuff
	if (available_amount($item[tomato juice of powerful power]) == 0
		&& available_amount($item[tomato]) == 0
		&& have_effect($effect[Tomato Power]) == 0) {

		cli_execute('mood apathetic');

		if (my_hp() < 0.5 * my_maxhp())
			cli_execute('rest free');

		use_familiar($familiar[melodramedary]);
		equip($item[dromedary drinking helmet]);
		
		// Fruits in skeleton store (Saber YR)
		if ((available_amount($item[ointment of the occult]) == 0 && available_amount($item[grapefruit]) == 0 && have_effect($effect[Mystically Oiled]) == 0)
				|| (available_amount($item[oil of expertise]) == 0 && available_amount($item[cherry]) == 0 && have_effect($effect[Expert Oiliness]) == 0)
				|| (available_amount($item[philter of phorce]) == 0 && available_amount($item[lemon]) == 0 && have_effect($effect[Phorcefullness]) == 0)) {
			if (get_property('questM23Meatsmith') == 'unstarted') {
				// Have to start meatsmith quest.
				visit_url('shop.php?whichshop=meatsmith&action=talk');
				run_choice(1);
			}
			if (!can_adv($location[The Skeleton Store], false))
				abort('Cannot open skeleton store!');
			if ($location[The Skeleton Store].turns_spent == 0 && !$location[The Skeleton Store].noncombat_queue.contains_text('Skeletons In Store'))
				adv1($location[The Skeleton Store], -1, '');
			if (!$location[The Skeleton Store].noncombat_queue.contains_text('Skeletons In Store'))
				abort('Something went wrong at skeleton store.');

			if (get_property('lastCopyableMonster').to_monster() != $monster[novelty tropical skeleton]) {
				//max mp to max latte gulp to fuel buffs
				maximize("mp,-equip garbage shirt,equip latte,100 bonus vampyric cloake,-equip backup camera,100 bonus lil doctor bag,-familiar",false);

				c2t_cartographyHunt($location[The Skeleton Store],$monster[novelty tropical skeleton]);
				run_turn();
			}
			//get the fruits with nostalgia
			c2t_hccs_fightGodLobster();
		}

		// Tomato in pantry (NOT Saber YR) -- RUNNING AWAY to use nostalgia later
		if (available_amount($item[tomato juice of powerful power]) == 0
			&& available_amount($item[tomato]) == 0
			&& have_effect($effect[Tomato Power]) == 0
			) {

			if (get_property('lastCopyableMonster').to_monster() != $monster[possessed can of tomatoes]) {
				if (get_property('_latteDrinkUsed').to_boolean())
					cli_execute('latte refill cinnamon pumpkin vanilla');
				//max mp to max latte gulp to fuel buffs
				use_familiar($familiar[melodramedary]);
				maximize("mp,-equip garbage shirt,equip latte,100 bonus vampyric cloake,-equip backup camera,100 bonus lil doctor bag,-familiar",false);

				c2t_cartographyHunt($location[The Haunted Pantry],$monster[possessed can of tomatoes]);
				run_turn();
			}
			//get the tomato with nostalgia
			c2t_hccs_fightGodLobster();
		}
	}
	
	if (have_effect($effect[The Magical Mojomuscular Melody]) > 0)
		cli_execute('shrug mojomus');
	if (have_effect($effect[Carlweather's Cantata of Confrontation]) > 0)
		cli_execute('shrug cantata');
	if (have_effect($effect[Stevedave's Shanty of Superiority]) == 0)
		use_skill(1,$skill[Stevedave's Shanty of Superiority]);
	
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
	if (my_class() == $class[pastamancer]) {
		if (my_thrall() != $thrall[Spice Ghost]) {
			if (my_mp() < 250)
				cli_execute('eat magical sausage');
			use_skill($skill[Bind Spice Ghost]);
		}
	}

	//turtle tamer blessing
	if (my_class() == $class[turtle tamer]) {
		if (have_effect($effect[Blessing of the War Snapper]) == 0 && have_effect($effect[Grand Blessing of the War Snapper]) == 0 && have_effect($effect[Glorious Blessing of the War Snapper]) == 0)
			use_skill($skill[Blessing of the War Snapper]);	
		if (have_effect($effect[Boon of the War Snapper]) == 0)
			use_skill(1,$skill[Spirit Boon]);
	}

	use_familiar(levelingFam);


	//get crimbo ghost buff from dudes at NEP
	if (have_familiar($familiar[Ghost of Crimbo Carols]) && have_effect($effect[Holiday Yoked]) == 0) {
		if (get_property('_latteDrinkUsed').to_boolean())
			cli_execute('latte refill cinnamon pumpkin vanilla');
		use_familiar($familiar[Ghost of Crimbo Carols]);
		maximize("mainstat,equip latte,-equip i voted,-equip backup camera",false);

		//going to grab runproof mascara from globster if moxie instead of having to wait post-kramco
		if (my_primestat() == $stat[moxie]) {
			c2t_cartographyHunt($location[The Neverending Party],$monster[party girl]);
			run_turn();
		}
		else
			adv1($location[The Neverending Party],-1,"");

		c2t_assert(have_effect($effect[Holiday Yoked]) > 0,"Something broke trying to get Holiday Yoked");
	}

	//nostalgia for moxie stuff and run down remaining glob fights
	while (c2t_hccs_fightGodLobster());

	//moxie needs olives
	if (my_primestat() == $stat[moxie] && have_effect($effect[Slippery Oiliness]) == 0 && item_amount($item[jumbo olive]) == 0) {
		//only thing that needs be equipped
		use_familiar($familiar[melodramedary]);
		if (!have_equipped($item[fourth of may cosplay saber]))
			equip($item[Fourth of May Cosplay saber]);
		//TODO evil olive - change to run away from and feel nostagic+envy+free kill another thing to save a saber use for spell test
		c2t_assert(c2t_hccs_wishFight($monster[Evil Olive]),"Failed to fight evil olive");
	}

	use_familiar(levelingFam);

	//summon tentacle
	if (have_skill($skill[Evoke Eldritch Horror]) && !get_property('_eldritchHorrorEvoked').to_boolean()) {
		maximize("mainstat,100exp,-equip garbage shirt"+famEq,false);
		if (my_mp() < 80)
			cli_execute('rest free');
		use_skill(1,$skill[Evoke Eldritch Horror]);
		run_combat();

		//in case the tentacle boss shows up; will cause an instant loss in a wish fight if health left at 0
		if (have_effect($effect[beaten up]) > 0 || my_hp() < 50)
			cli_execute('rest free');
	}

	// Your Mushroom Garden
	if ((get_campground() contains $item[packet of mushroom spores]) && get_property('_mushroomGardenFights').to_int() == 0) {
		maximize("mainstat,-equip garbage shirt"+famEq,false);
		adv1($location[Your Mushroom Garden],-1,"");
	}

	c2t_hccs_wandererFight();//shouldn't do kramco

	//setup for NEP and backup fights
	string doc,garbage,kramco,fam;

	//set camel
	if (get_property('camelSpit').to_int() != 100) {
		use_familiar($familiar[Melodramedary]);
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
			if (have_familiar($familiar[shorter-order cook]) && item_amount($item[short stack of pancakes]) == 0 && have_effect($effect[Shortly Stacked]) == 0) {
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
			use_familiar($familiar[Melodramedary]);

		//backup fights will turns this off after a point, so keep turning it on
		if (get_property('garbageShirtCharge').to_int() > 0)
			garbage = ",equip garbage shirt";
		else
			garbage = "";

		// -- using things as they become available --
		//use runproof mascara ASAP if moxie for more stats
		if (my_primestat() == $stat[moxie] && have_effect($effect[Unrunnable Face]) == 0 && item_amount($item[runproof mascara]) > 0)
			use(1,$item[runproof mascara]);

		//turtle tamer turtle
		if (my_class() == $class[turtle tamer] && have_effect($effect[Gummi-Grin]) == 0 && item_amount($item[gummi turtle]) > 0)
			use(1,$item[gummi turtle]);

		//eat CER pizza ASAP
		if (have_effect($effect[Certainty]) == 0 && item_amount($item[electronics kit]) > 0 && item_amount($item[Middle of the Road&trade; brand whiskey]) > 0)
			pizza_effect(
				$effect[Certainty],
				$item[cog and sprocket assembly],
				$item[electronics kit],
				$item[razor-sharp can lid],
				$item[Middle of the Road&trade; brand whiskey]
			);

		//drink hot socks ASAP
		if (have_effect($effect[1701]) == 0 && my_meat() > 5000) {//1701 is the desired version of $effet[Hip to the Jive]
			if (my_mp() < 150)
				cli_execute('eat mag saus');
			cli_execute('shrug stevedave');
			c2t_getEffect($effect[Ode to Booze],$skill[The Ode to Booze],3);
			cli_execute('drink hot socks');
			cli_execute('shrug ode to booze');
			c2t_getEffect($effect[Stevedave's Shanty of Superiority],$skill[Stevedave's Shanty of Superiority]);
		}

		//drink astral pilsners once level 11; saving 1 for use in mime army shotglass post-run
		if (my_level() >= 11 && item_amount($item[astral pilsner]) == 6) {
			cli_execute('shrug Shanty of Superiority');
			if (my_mp() < 100)
				cli_execute('rest free');//probably bad
			use_skill(1,$skill[The Ode to Booze]);
			drink(5,$item[astral pilsner]);
			cli_execute('shrug Ode to Booze');
			use_skill(1,$skill[Stevedave's Shanty of Superiority]);
		}

		//explicitly buying and using range as it rarely bugs out
		if (!(get_campground() contains $item[Dramatic&trade; range]) && my_meat() >= (have_skill($skill[five finger discount])?950:1000)) { //five-finger discount
			retrieve_item($item[Dramatic&trade; range]);
			use($item[Dramatic&trade; range]);
		}
		//potion buffs when enough meat obtained
		if (have_effect($effect[Tomato Power]) == 0 && (get_campground() contains $item[Dramatic&trade; range])) {
			if (my_primestat() == $stat[muscle]) {
				c2t_getEffect($effect[Phorcefullness],$item[philter of phorce]);
				c2t_getEffect($effect[Stabilizing Oiliness],$item[oil of stability]);
			}
			else if (my_primestat() == $stat[mysticality]) {
				c2t_getEffect($effect[Mystically Oiled],$item[ointment of the occult]);
				c2t_getEffect($effect[Expert Oiliness],$item[oil of expertise]);
			}
			else if (my_primestat() == $stat[moxie]) {
				c2t_getEffect($effect[Superhuman Sarcasm],$item[serum of sarcasm]);
				c2t_getEffect($effect[Slippery Oiliness],$item[oil of slipperiness]);
			}
			c2t_getEffect($effect[Tomato Power],$item[tomato juice of powerful power]);
			c2t_assert(have_effect($effect[Tomato Power]) > 0,'It somehow missed again.');
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
			&& (have_effect($effect[Spiced Up]) > 0 || have_effect($effect[Tomes of Opportunity]) > 0 || have_effect($effect[The Best Hair You've Ever Had]) > 0)
			&& have_effect($effect[Tomato Power]) > 0
			//target monster for professor copies. using back up camera to bootstrap
			&& get_property('lastCopyableMonster').to_monster() == $monster[sausage goblin]
			) {

			use_familiar($familiar[Pocket Professor]);
			c2t_hccs_minMaximize("mainstat,equip garbage shirt,equip kramco,100familiar weight,equip backup camera");
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

			c2t_hccs_minMaximize("mainstat,exp,equip latte,equip backup camera"+garbage+fam);
			adv1($location[The Dire Warren],-1,"");
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

			c2t_hccs_minMaximize("mainstat,exp,equip backup camera"+kramco+garbage+fam);
		}
		//rest of the free NEP fights
		else
			c2t_hccs_minMaximize("mainstat,exp,equip kramco"+garbage+fam+doc);

		adv1($location[The Neverending Party],-1,"");
	}

	cli_execute('mood apathetic');
}

boolean c2t_hccs_wandererFight() {
	//don't want to be doing wanderer whilst feeling lost
	if (have_effect($effect[Feeling Lost]) > 0) {
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
		c2t_getEffect($effect[Feeling Excited],$skill[Feel Excitement]);

	if (my_hp() < my_maxhp()/2 || my_mp() < 10) {
		c2t_hccs_breakfast();
		cli_execute('rest free');
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
	adv1($location[The Neverending Party],-1,"");

	//hopefully restore to previous state without outfits
	use_familiar(nowFam);
	maximize(maxstr[0],false);
	equip($slot[familiar],nowEquip);

	return true;
}

boolean c2t_hccs_minMaximize(string max) {
	if (max != c2t_lastMaximize() || FIRST_MAX) {
		FIRST_MAX = false;
		return maximize(max,false);
	}
	return false;
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



//c2t hccs lib
//c2t


import <c2t_hccs_constants.ash>
import <c2t_lib.ash>


/*============
  declarations
  ============*/

//returns number of banishes left
int c2t_hccs_banishesLeft();

//input is either `info` or `warn`
//returns color to print based on input and whether user is in dark mode or not
string c2t_hccs_color(string str);

//returns number of free crafts left from passive skills only
int c2t_hccs_freeCraftsLeft();

//returns number of free kills left from among doc bag, shattering punch, and gingerbread mob hit
int c2t_hccs_freeKillsLeft();

//get an effect
//returns true if effect obtained
boolean c2t_hccs_getEffect(effect eff);

//get multiple effects
void c2t_hccs_getEffect(boolean [effect] effs);

//get fax of mon
void c2t_hccs_getFax(monster mon);

//if have the thing, use the thing
boolean c2t_hccs_haveUse(item ite);
//n is for number of things to use
boolean c2t_hccs_haveUse(int n,item ite);

//if have the skill, use the skill
//will use c2t_hccs_restoreMp() as needed
boolean c2t_hccs_haveUse(skill ski);
//n is for number of times to use
boolean c2t_hccs_haveUse(int n,skill ski);

//returns whether a cleaver adventure is now or not
boolean c2t_hccs_isCleaverNow();

//joinclan
//mostly a wrapper for c2t_joinClan()
boolean c2t_hccs_joinClan(string s);

//returns the singular or plural form of a word based on number
string c2t_hccs_plural(int number,string singular,string plural,boolean includeNumber);
string c2t_hccs_plural(int number,string singular,string plural);

//wrapper for print() to print message in correct color
void c2t_hccs_printInfo(string str);
void c2t_hccs_printWarn(string str);

//pull 1 of an item from storage if not already have it
//returns true in the case of pulling an item or if the item already is available
boolean c2t_hccs_pull(item ite);

//stores given test data to a property
void c2t_hccs_testData(string testType,int testNum,int turnsTaken,int turnsExpected);

//formats and prints stored test data and run summary
void c2t_hccs_printTestData();

//returns true if given test's threshold is met, omitting threshold uses data from c2t_hccs_thresholds property
boolean c2t_hccs_thresholdMet(int test,int threshold);
boolean c2t_hccs_thresholdMet(int test);

//returns an estimate of how many turns a given test will take in the moment
int c2t_hccs_testTurns(int test);

//returns true if a given test is done
boolean c2t_hccs_testDone(int test);

//visits council and does given test
void c2t_hccs_doTest(int test);


/*===============
  implementations
  ===============*/

int c2t_hccs_banishesLeft() {
	int out = 0;
	//only concerned with a few banishes
	if (have_skill($skill[feel hatred]))
		out += 3 - get_property("_feelHatredUsed").to_int();
	if (have_skill($skill[snokebomb]))
		out += 3 - get_property("_snokebombUsed").to_int();
	if (available_amount($item[lil' doctor&trade; bag]) > 0)
		out += 3 - get_property("_reflexHammerUsed").to_int();
	if (available_amount($item[kremlin's greatest briefcase]) > 0)
		out += 3 - get_property("_kgbTranquilizerDartUses").to_int();
	return out;
}

string c2t_hccs_color(string str) {
	switch (str) {
		default:
			return '';
		case 'err':
		case 'error':
		case 'warn':
			return 'red';
		case 'info':
			if (is_dark_mode())
				return 'teal';
			return 'blue';
	}
}

int c2t_hccs_freeCraftsLeft() {
	int out = 0;
	//only crafting potions, so cookbookbat fine to add here for now
	if (have_familiar($familiar[cookbookbat]))
		out += 5 - get_property("_cookbookbatCrafting").to_int();
	if (have_skill($skill[rapid prototyping]))
		out += 5 - get_property("_rapidPrototypingUsed").to_int();
	if (have_skill($skill[expert corner-cutter]))
		out += 5 - get_property("_expertCornerCutterUsed").to_int();
	return out;
}

int c2t_hccs_freeKillsLeft() {
	int n = 0;
	if (available_amount($item[lil' doctor&trade; bag]) > 0)
		n += 3 - get_property("_chestXRayUsed").to_int();
	if (have_skill($skill[shattering punch]))
		n += 3 - get_property("_shatteringPunchUsed").to_int();
	if (have_skill($skill[gingerbread mob hit]) && !get_property("_gingerbreadMobHitUsed").to_boolean())
		n++;
	if (available_amount($item[jurassic parka]) > 0 && have_effect($effect[everything looks yellow]) == 0)
		n++;
	return n;
}

boolean c2t_hccs_getEffect(effect eff) {
	if (have_effect(eff).to_boolean())
		return true;

	string cmd = eff.default;
	string tmp;
	skill ski;
	item ite;
	string [int] spl;

	if (cmd.starts_with("cargo "))
		foreach x in eff.all
			if (!x.starts_with("cargo ")) {
				cmd = x;
				break;
			}
	if (cmd.starts_with("cargo ")) {
		c2t_hccs_printWarn(`aborted an attempt to use cargo shorts for {eff}`);
		return false;
	}

	if (cmd.starts_with("cast ")) {
		spl = cmd.split_string(" ");
		for i from 2 to spl.count()-1
			tmp += i == 2?spl[i]:` {spl[i]}`;
		ski = tmp.to_skill();

		//need hp to cast blood skills
		if ($skills[blood bond,blood bubble,blood frenzy] contains ski)
			restore_hp(31);

		if (!c2t_hccs_haveUse(ski)) {
			c2t_hccs_printInfo(`Info: don't have the skill "{ski}" to get the "{eff}" effect`);
			return false;
		}
	}
	else if (cmd.starts_with("use ")) {
		spl = cmd.split_string(" ");

		//short circuit until i figure out how to deal with this
		if (spl[1] == "either") {
			cli_execute(cmd);
			return have_effect(eff).to_boolean();
		}

		for i from 2 to spl.count()-1
			tmp += i == 2?spl[i]:` {spl[i]}`;
		ite = tmp.to_item();

		if (!retrieve_item(ite)) {
			c2t_hccs_printInfo(`Info: "{ite}" not retrieved to get "{eff}"`);
			return false;
		}
		use(ite);
	}
	else //probably disabling this part in the future
		cli_execute(cmd);

	return have_effect(eff).to_boolean();
}

void c2t_hccs_getEffect(boolean [effect] effs) {
	foreach x in effs c2t_hccs_getEffect(x);
}

void c2t_hccs_getFax(monster mon) {
	c2t_hccs_printInfo(`getting fax of {mon}`);
	cli_execute("chat");
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

boolean c2t_hccs_haveUse(item ite) {
	return c2t_hccs_haveUse(1,ite);
}
boolean c2t_hccs_haveUse(int n,item ite) {
	if (available_amount(ite) >= n)
		return use(n,ite);
	return false;
}
boolean c2t_hccs_haveUse(skill ski) {
	return c2t_hccs_haveUse(1,ski);
}
boolean c2t_hccs_haveUse(int n,skill ski) {
	if (!have_skill(ski))
		return false;
	if (my_mp() < mp_cost(ski)*n)
		restore_mp(mp_cost(ski)*n);
	return use_skill(n,ski);
}

boolean c2t_hccs_isCleaverNow() {
	return get_property("_juneCleaverFightsLeft").to_int() <= 0;
}

boolean c2t_hccs_joinClan(string s) {
	string err = `Error: could not join clan "{s}"`;
	if (s.to_int() != 0)
		c2t_assert(c2t_joinClan(s.to_int()),err);
	else
		c2t_assert(c2t_joinClan(s),err);
	return true;
}

string c2t_hccs_plural(int number,string singular,string plural) {
	return c2t_hccs_plural(number,singular,plural,true);
}
string c2t_hccs_plural(int number,string singular,string plural,boolean includeNumber) {
	return `{includeNumber ? number + " " : ""}{number == 1 ? singular : plural}`;
}

void c2t_hccs_printInfo(string str) {
	print(str,c2t_hccs_color('info'));
}
void c2t_hccs_printWarn(string str) {
	print(str,c2t_hccs_color('warn'));
}

boolean c2t_hccs_pull(item ite) {
	if (pulls_remaining() > 0 && !can_interact() && !in_hardcore() && item_amount(ite) == 0 && available_amount(ite) == 0 && storage_amount(ite) > 0)
		return take_storage(1,ite);
	else if (available_amount(ite) > 0)
		return true;
	return false;
}

void c2t_hccs_testData(string testType,int testNum,int turnsTaken,int turnsExpected) {
	if (testNum == TEST_COIL_WIRE)
		return;

	set_property("_c2t_hccs_testData",get_property("_c2t_hccs_testData")+(get_property("_c2t_hccs_testData") == ""?"":";")+`{testType},{testNum},{turnsTaken},{turnsExpected}`);
}

void c2t_hccs_printTestData() {
	string [int] d;
	string pulls = get_property("_roninStoragePulls");

	print("");
	if (pulls != "") {
		print("Pulls used this run:");
		foreach i,x in split_string(pulls,",")
			print(x.to_item());
		print("");
	}
	if (get_property("_c2t_hccs_testData") != "") {
		print("Summary of tests:");
		foreach i,x in split_string(get_property("_c2t_hccs_testData"),";") {
			d = split_string(x,",");
			print(`{d[0]} test took {c2t_hccs_plural(d[2].to_int(),"turn","turns")}{to_int(d[1]) > 4 && to_int(d[3]) < 1?"; it's being overcapped by "+c2t_hccs_plural(1-to_int(d[3]),"turn","turns")+" of resources":""}`);
		}
	}
	else
		print("Summary of tests not found","red");
	print(`{my_daycount()}/{turns_played()} turns as {my_class()}`);
	print(`Organ use: {my_fullness()}/{my_inebriety()}/{my_spleen_use()}`);
}

boolean c2t_hccs_thresholdMet(int test,int threshold) {
	if (test == TEST_COIL_WIRE || test == TEST_FINAL)
		return true;
	return c2t_hccs_testTurns(test) <= threshold;
}
boolean c2t_hccs_thresholdMet(int test) {
	string [int] arr = split_string(get_property('c2t_hccs_thresholds'),",");

	if (count(arr) == 10 && arr[test-1].to_int() > 0 && arr[test-1].to_int() <= 60)
		return c2t_hccs_thresholdMet(test,arr[test-1].to_int());
	else {
		c2t_hccs_printWarn("Warning: the c2t_hccs_thresholds property is broken for this test; defaulting to a 1-turn threshold.");
		return c2t_hccs_thresholdMet(test,1);
	}
}

int c2t_hccs_testTurns(int test) {
	int num;
	float offset;
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
			offset = get_power(equipped_item($slot[weapon]));
			offset += weapon_type(equipped_item($slot[off-hand])) != $stat[none]
				? get_power(equipped_item($slot[off-hand]))
				: 0;
			offset += weapon_type(equipped_item($slot[familiar])) != $stat[none]
				? get_power(equipped_item($slot[familiar]))
				: 0;
			offset *= 0.15;
			return (60 - floor((numeric_modifier('weapon damage') - offset) / num + 0.001) - floor(numeric_modifier('weapon damage percent') / num + 0.001));
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
		case TEST_FINAL://final service in case that gets checked
			return 0;
	}
}

boolean c2t_hccs_testDone(int test) {
	print(`Checking test {test}...`);
	if (test == TEST_FINAL
		&& !get_property('kingLiberated').to_boolean()
		&& get_property("csServicesPerformed").split_string(",").count() == 11)
	{
		return false;//to do the 'test' and to set kingLiberated
	}
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


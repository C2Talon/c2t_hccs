//c2t hccs lib
//c2t


import <c2t_lib.ash>

/*============
  declarations
  ============*/

//returns number of banishes left
int c2t_hccs_banishesLeft();

//input is either `info` or `warn`
//returns color to print based on input and whether user is in dark mode or not
string c2t_hccs_color(string str);

//uses a skill from an equipment that needs to be equipped to use
boolean c2t_hccs_equipCast(item ite,skill ski);
boolean c2t_hccs_equipCast(skill ski,item ite);

//wrapper for adv1() to double check that adventures are free
//aborts if turn is used
//returns true if turn not used
boolean c2t_hccs_freeAdv(location loc);
boolean c2t_hccs_freeAdv(location loc,int num,string str);

//returns number of free crafts left from passive skills only
int c2t_hccs_freeCraftsLeft();

//returns number of free kills left from among doc bag, shattering punch, and gingerbread mob hit
int c2t_hccs_freeKillsLeft();

//get an effect
//returns true if effect obtained
boolean c2t_hccs_getEffect(effect eff);

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

boolean c2t_hccs_equipCast(skill ski,item ite) {
	return c2t_hccs_equipCast(ite,ski);
}
boolean c2t_hccs_equipCast(item ite,skill ski) {
	//adapated from c2t_cast
	item last = $item[none];
	slot slo = ite.to_slot();
	boolean out = false;

	if (slo == $slot[none]) {
		c2t_hccs_printWarn(`c2t_hccs_equipCast: "{ite}" is not something that can be equipped`);
		return false;
	}

	//swap in item
	if (!have_equipped(ite)) {
		last = equipped_item(slo);
		equip(slo,ite);
	}

	out = use_skill(1,ski);

	//reequip previous item
	if (last != $item[none])
		equip(slo,ite);

	return out;
}

boolean c2t_hccs_freeAdv(location loc) {
	return c2t_hccs_freeAdv(loc,-1,"");
}
boolean c2t_hccs_freeAdv(location loc,int num,string str) {
	int start = my_turncount();
	adv1(loc,num,str);
	if (my_turncount() > start)
		abort(`turn used: {loc}`);
	return true;
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


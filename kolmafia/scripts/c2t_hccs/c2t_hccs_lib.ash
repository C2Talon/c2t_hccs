//c2t hccs lib
//c2t


import <c2t_lib.ash>

/*============
  declarations
  ============*/

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

//pull 1 of an item from storage if not already have it
//returns true in the case of pulling an item or if the item already is available
boolean c2t_hccs_pull(item ite);

//rudamentary mp restoration using free rests and magical sausages
boolean c2t_hccs_restoreMp();


/*===============
  implementations
  ===============*/

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
		print(`aborted an attempt to use cargo shorts for {eff}`,"red");
		return false;
	}

	if (cmd.starts_with("cast ")) {
		spl = cmd.split_string(" ");
		for i from 2 to spl.count()-1
			tmp += i == 2?spl[i]:` {spl[i]}`;
		ski = tmp.to_skill();

		if (!c2t_hccs_haveUse(ski)) {
			print(`Info: don't have the skill "{ski}" to get the "{eff}" effect`);
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
			print(`Info: "{ite}" not retrieved to get "{eff}"`);
			return false;
		}
		use(ite);
	}
	else //probably disabling this part in the future
		cli_execute(cmd);

	return have_effect(eff).to_boolean();
}

void c2t_hccs_getFax(monster mon) {
	print(`getting fax of {mon}`,"blue");
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
		c2t_hccs_restoreMp();
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

boolean c2t_hccs_pull(item ite) {
	if(!can_interact() && !in_hardcore() && item_amount(ite) == 0 && available_amount(ite) == 0 && storage_amount(ite) > 0 && pulls_remaining() > 0)
		return take_storage(1,ite);
	else if (available_amount(ite) > 0)
		return true;
	return false;
}

boolean c2t_hccs_restoreMp() {
	int start = my_mp();
	int total = total_free_rests();
	int used = get_property("timesRested").to_int();

	if (my_maxmp() > 500 && retrieve_item($item[magical sausage]))
		eat($item[magical sausage]);
	else if (total-used > 0)
		cli_execute("rest free");
	else if (retrieve_item($item[magical sausage]))
		eat($item[magical sausage]);
	else
		print("Unable to recover MP with magical sausages or free rests","red");

	return my_mp() > start;
}


//c2t hccs recovery
//c2t

//recovery script for c2t_hccs

import <c2t_hccs_lib.ash>

boolean c2t_hccs_restoreHp(int amount);
boolean c2t_hccs_restoreHp() return c2t_hccs_restoreHp(0);
boolean c2t_hccs_restoreMp(int amount);
boolean c2t_hccs_restoreMp() return c2t_hccs_restoreMp(0);

boolean main(string type, int amount) {
	if (type == "HP")
		return c2t_hccs_restoreHp(amount);
	else if (type == "MP")
		return c2t_hccs_restoreMp(amount);
	return false;
}

boolean c2t_hccs_restoreHp(int amount) {
	float threshold = get_property("hpAutoRecoveryTarget").to_float();
	int target = amount > my_maxhp() || amount <= 0 ? ceil(my_maxhp() * threshold) : amount;

	//handle beaten up
	if (have_effect($effect[beaten up]) > 0) {
		skill temp = $skill[tongue of the walrus];
		if (have_skill(temp) && my_mp() >= mp_cost(temp))
			c2t_hccs_haveUse(temp);
		else
			cli_execute("rest free");
		//if all else fails
		if (have_effect($effect[beaten up]) > 0)
			cli_execute("hottub");
	}
	//maybe don't abort for this?
	c2t_assert(have_effect($effect[beaten up]) == 0,"Couldn't get rid of beaten up");

	//not actually going to do more than fix beaten up; let mafia handle the healing part via settings set at start of main script
	return my_hp() >= target;
}

boolean c2t_hccs_restoreMp(int amount) {
	int start = my_mp();
	int total = total_free_rests();
	int used = get_property("timesRested").to_int();

	int target;
	if (amount > my_maxmp() || amount < 0)
		target = my_maxmp();
	else if (amount == 0)
		target = 50;//arbitrary minimum mp for script
	else
		target = amount;

	if (start >= target)
		return true;

	//only do 1 of rest free or eat magic sausage
	if ((my_maxmp() > 500 || target - start > 100) && retrieve_item($item[magical sausage]))
		eat($item[magical sausage]);
	else if (total - used > 0)
		cli_execute("rest free");
	else if (retrieve_item($item[magical sausage]))
		eat($item[magical sausage]);
	else
		print("Unable to recover MP with magical sausages or free rests","red");

	//not going to necessarily reach target, but shouldn't matter as this isn't for general use
	return my_mp() > start;
}


//c2t hccs preAdv
//c2t

//rudimentary recovery before an adventure

import <c2t_hccs_lib.ash>

void c2t_hccs_preAdv() {
	//tiny stillsuit: equip on gelatinous cubeling if not on anything else
	if (item_amount($item[tiny stillsuit]) > 0)
		equip($familiar[gelatinous cubeling],$item[tiny stillsuit]);

	float hpThreshold = get_property("hpAutoRecovery").to_float();
	int mpThreshold = 50;

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

	c2t_assert(have_effect($effect[beaten up]) == 0,"Couldn't get rid of beaten up");//maybe don't abort for this?

	//restore hp
	if (my_hp() < floor(my_maxhp() * hpThreshold))
		if (!restore_hp(0))//uses settings set at start of c2t_hccs
			print("Had some trouble restoring HP?","red");

	//restore mp
	if (my_mp() < mpThreshold)
		if (!c2t_hccs_restoreMp())
			print("Had some trouble restoring MP?","red");
}

void main() c2t_hccs_preAdv();


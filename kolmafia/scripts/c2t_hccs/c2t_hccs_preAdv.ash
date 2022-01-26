//c2t hccs preAdv
//c2t

//rudimentary recovery before an adventure

import <c2t_hccs_lib.ash>

void c2t_hccs_preAdv() {
	float hpt = get_property("hpAutoRecovery").to_float();
	int mpt = 50;

	//handle beaten up
	if (have_effect($effect[beaten up]) > 0) {
		skill temp = $skill[tongue of the walrus];
		if (have_skill(temp) && my_mp() >= mp_cost(temp))
			c2t_hccs_haveUse(temp);
		else
			cli_execute("rest free");
	}
	c2t_assert(have_effect($effect[beaten up]) == 0,"Couldn't get rid of beaten up");//maybe don't abort for this?

	//restore hp
	if (my_hp() < floor(my_maxhp() * hpt))
		if (!restore_hp(floor(my_maxhp()*0.9))
			|| !c2t_hccs_haveUse(1+(my_maxhp()-my_hp())/1000,$skill[cannelloni cocoon]))
			print("Had some trouble restoring HP?","red");

	//restore mp
	if (my_mp() < mpt)
		if (!c2t_hccs_restoreMp())
			print("Had some trouble restoring MP?","red");
}

void main() c2t_hccs_preAdv();


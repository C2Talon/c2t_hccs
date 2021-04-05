//c2t
//c2t hccs combat
//consult script to do one-offs in combat
void main(int initround, monster foe, string page) {
	if (my_familiar() == $familiar[Ghost of Crimbo Carols]) {
		if (have_skill($skill[Become a Cloud of Mist]) && have_effect($effect[Misty Form]) == 0 && get_property('csServicesPerformed').contains_text('Breed More Collies'))
			use_skill(1,$skill[Become a Cloud of Mist]);
		if (have_skill($skill[Offer Latte to Opponent]))
			use_skill(1,$skill[Offer Latte to Opponent]);
		if (have_skill($skill[Snokebomb]) && get_property('_snokebombUsed').to_int() < 3)
			use_skill(1,$skill[Snokebomb]); 
		if (have_skill($skill[Throw Latte on Opponent]) && !get_property('_latteBanishUsed').to_boolean())
			use_skill(1,$skill[Throw Latte on Opponent]);
	}
	else {
		switch (foe) {
			//only use 1 become the bat for item test and initial latte throw
			case $monster[fluffy bunny]:
				if (have_skill($skill[Become a Bat]) && have_effect($effect[Bat-Adjacent Form]) == 0)
					use_skill(1,$skill[Become a Bat]);
				return;
			//saber yr to not break mafia tracking
			case $monster[factory worker (female)]:
			case $monster[novelty tropical skeleton]:
			case $monster[possessed can of tomatoes]:
			case $monster[ungulith]:
			case $monster[Evil Olive]:
			case $monster[hobelf]://apparently this doesn't work?
			case $monster[elf hobo]://this might though?
			case $monster[angry pi&ntilde;ata]:
				if (have_skill($skill[Use the Force]))
					use_skill(1,$skill[Use the Force]);
				return;
			//using all free kills on neverending party monsters
			case $monster[biker]:
			case $monster[burnout]:
			case $monster[jock]:
			case $monster[party girl]:
			case $monster["plain" girl]:
				//feel pride //can't just have this in CSS since voters get thrown in NEP and aren't handled properly
				if (have_skill($skill[Feel Pride]) && get_property('_feelPrideUsed').to_int() < 3)
					use_skill(1,$skill[Feel Pride]);
				if (have_skill($skill[Army of Toddlers]) && !get_property('_armyToddlerCast').to_boolean())
					use_skill(1,$skill[Army of Toddlers]);
				//things to do after NEP free fights
				if (get_property('_neverendingPartyFreeTurns').to_int() == 10 && !get_property('_gingerbreadMobHitUsed').to_boolean()) {
					//make sure to sing
					if (have_skill($skill[Sing Along]))
						use_skill(1,$skill[Sing Along]);
					//free kill skills
					if (have_skill($skill[Chest X-Ray]) && get_property('_chestXRayUsed').to_int() < 3) {
						//won't use otoscope anywhere else, so might as well use it while doc bag equipped
						if (have_skill($skill[Otoscope]) && get_property('_otoscopeUsed').to_int() < 3)
							use_skill(1,$skill[Otoscope]);
						use_skill(1,$skill[Chest X-Ray]);
					}
					else if (have_skill($skill[Shattering Punch]) && get_property('_shatteringPunchUsed').to_int() < 3) {
						use_skill(1,$skill[Shattering Punch]);
					}
					else if (have_skill($skill[Gingerbread Mob Hit]) && !get_property('_gingerbreadMobHitUsed').to_boolean())
						use_skill(1,$skill[Gingerbread Mob Hit]);
				}
				return;
			//vote monsters
			case $monster[government bureaucrat]:
			case $monster[terrible mutant]:
			case $monster[angry ghost]:
			case $monster[annoyed snake]:
			case $monster[slime blob]:
				return;
			case $monster[God Lobster]:
				//grabbing moxie buff item
				if (my_primestat() == $stat[moxie]
					&& have_effect($effect[Unrunnable Face]) == 0
					&& item_amount($item[runproof mascara]) == 0
					&& get_property('feelNostalgicMonster').to_monster() == $monster[party girl]) {

					if (have_skill($skill[Feel Nostalgic]))
						use_skill(1,$skill[Feel Nostalgic]);
					if (have_skill($skill[Feel Envy]))
						use_skill(1,$skill[Feel Envy]);
				}
				return;
			default:
				//this shouldn't happen //happens with voter fights as CCS doesn't handle each explicitly
				abort("Something broke in the combat script. Might be fine?");
		}
	}
}	


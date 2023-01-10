//c2t community service combat
//c2t

import <c2t_lib.ash>
import <c2t_hccs_lib.ash>
import <c2t_hccs_resources.ash>


// consult script for CS

//the logic for bowling sideways to bolt into c2t_bb
string c2t_hccs_bowlSideways();
string c2t_hccs_bowlSideways(string m);

//handle some skills with charges
string c2t_hccs_bbChargeSkill(string m,skill ski);
string c2t_hccs_bbChargeSkill(skill ski);


void main(int initround, monster foe, string page) {
	//for holiday wanderer redos, since post-adv script can change my_location()
	location loc = my_location();

	//saber force
	if (have_effect($effect[meteor showered]) > 0 || have_effect($effect[fireproof foam suit]) > 0) {
		c2t_bb($skill[use the force]).c2t_bbSubmit();
		return;
	}

	string mHead = "scrollwhendone;";
	string mSteal = "pickpocket;";

	//basic macro/what to run when nothing special needs be done or after the special thing is done
	string mBasic =	c2t_bb($skill[disarming thrust])
		.c2t_bb($skill[detect weakness])
		.c2t_bb($skill[micrometeorite])
		.c2t_hccs_bowlSideways()
		.c2t_bbIf("sealclubber || turtletamer || discobandit || accordionthief",
			c2t_bb($skill[curse of weaksauce])
			.c2t_bb($skill[sing along])
			.c2t_bbWhile("!pastround 20",c2t_bb("attack;"))
		)
		.c2t_bbIf("pastamancer",
			c2t_bb($skill[stuffed mortar shell])
			.c2t_bb($skill[sing along])
		)
		.c2t_bbIf("sauceror",
			c2t_bb($skill[curse of weaksauce])
			.c2t_bb($skill[stuffed mortar shell])
			.c2t_bb($skill[sing along])
			.c2t_bb($skill[saucegeyser])
		);

	//mostly mBasic with relativity sprinkled in and small heal to help moxie survive chaining
	string mChain =	c2t_bb($skill[disarming thrust])
		.c2t_bb($skill[detect weakness])
		.c2t_bb($skill[micrometeorite])
		.c2t_hccs_bowlSideways()
		.c2t_bbIf("sealclubber || turtletamer || discobandit || accordionthief",
			c2t_bb($skill[curse of weaksauce])
			.c2t_bbIf("discobandit || accordionthief",c2t_bb($skill[saucy salve]))
			.c2t_bb($skill[sing along])
			.c2t_bb($skill[lecture on relativity])
			.c2t_bbWhile("!pastround 20",c2t_bb("attack;"))
		)
		.c2t_bbIf("pastamancer",
			c2t_bb($skill[lecture on relativity])
			.c2t_bb($skill[stuffed mortar shell])
			.c2t_bb($skill[sing along])
		)
		.c2t_bbIf("sauceror",
			c2t_bb($skill[curse of weaksauce])
			.c2t_bb($skill[sing along])
			.c2t_bb($skill[lecture on relativity])
			.c2t_bb($skill[saucegeyser])
			.c2t_bb($skill[saucegeyser])
		);

	//macro to build
	string m;

	//run with ghost caroler for buffs at NEP and dire warren at different times
	if ($familiars[ghost of crimbo carols,exotic parrot] contains my_familiar()) {
		m = mHead + mSteal;
		if (foe == $monster[fluffy bunny]) {
			m += c2t_bb($skill[become a cloud of mist]);
			m += c2t_bb($skill[fire extinguisher: foam yourself]);
			m.c2t_bbSubmit();
		}
		else {//NEP
			m += c2t_bb($skill[gulp latte]);
			m += c2t_bb($skill[offer latte to opponent]);
			m += c2t_bb($skill[throw latte on opponent]);
			m.c2t_bbSubmit();
		}
		return;
	}
	//saber random thing at this location for meteor shower buff -- saber happens elsewhere
	else if (my_location() == $location[thugnderdome]) {
		m = mHead + mSteal.c2t_bb($skill[meteor shower]);

		//camel spit for weapon test, which is directly after combat test
		if (get_property("csServicesPerformed").contains_text("Be a Living Statue") && !get_property("csServicesPerformed").contains_text("Reduce Gazelle Population"))
			m += c2t_bb($skill[%fn, spit on me!]);

		m.c2t_bbSubmit();
		return;
	}
	else {
		//basically mimicking CCS
		switch (foe) {
			//only use 1 become the bat for item test and initial latte throw
			case $monster[fluffy bunny]:
				//item test done, so should only be hot test left for the bunny?
				if (get_property("csServicesPerformed").contains_text("Make Margaritas")) {
					m = mHead + mSteal;
					m += c2t_bb($skill[become a cloud of mist]);
					m += c2t_bb($skill[fire extinguisher: foam yourself]);
					m.c2t_bbSubmit();
					return;
				}
				//fishing for latte ingredients with backups
				else if (have_equipped($item[backup camera]) && c2t_hccs_backupCameraLeft() > 0) {
					c2t_bbSubmit(
						c2t_bb($skill[back-up to your last enemy])
						.c2t_bb("twiddle;")
					);
					return;
				}
				c2t_bbSubmit(
					mHead + mSteal
					.c2t_bb(have_effect($effect[bat-adjacent form]) == 0?c2t_bb($skill[become a bat]):"")
					.c2t_bb(have_effect($effect[cosmic ball in the air]) == 0?c2t_bb($skill[bowl straight up]):"")
					.c2t_hccs_bbChargeSkill($skill[reflex hammer])
					.c2t_hccs_bbChargeSkill($skill[kgb tranquilizer dart])
					.c2t_hccs_bbChargeSkill($skill[snokebomb])
					.c2t_hccs_bbChargeSkill($skill[feel hatred])
				);
				return;

			//nostalgia other monster to get drops from these
			case $monster[possessed can of tomatoes]:
				//if no god lobster, burn a free kill to get both monsters' drops with nostalgia/envy here
				if (!have_familiar($familiar[god lobster])
					&& get_property('lastCopyableMonster').to_monster() == $monster[novelty tropical skeleton])
				{
					mSteal
					.c2t_bb($skill[feel nostalgic])
					.c2t_bb($skill[feel envy])
					.c2t_bb($skill[become a wolf])
					.c2t_bb($skill[gulp latte])
					.c2t_hccs_bbChargeSkill($skill[chest x-ray])
					.c2t_hccs_bbChargeSkill($skill[shattering punch])
					.c2t_bb($skill[gingerbread mob hit])
					.c2t_bbSubmit();
					return;
				}
			case $monster[novelty tropical skeleton]:
				c2t_bbSubmit(
					mSteal
					.c2t_bb($skill[become a wolf])
					.c2t_bb($skill[gulp latte])
					.c2t_bb($skill[bowl straight up])
					.c2t_bb($skill[throw latte on opponent])
				);
				return;
			//faxes -- saber use is elsewhere
			case $monster[ungulith]:
			case $monster[factory worker (female)]:
			case $monster[factory worker (male)]://just in case this shows up
				c2t_bbSubmit(
					mSteal
					.c2t_bb($skill[meteor shower])
				);
				return;
			case $monster[evil olive]:
				//have to burn a free kill and nostalgia/envy if no god lobster
				if (!have_familiar($familiar[god lobster])
					&& get_property('lastCopyableMonster').to_monster() == $monster["plain" girl]) {

					mSteal
					.c2t_bb($skill[feel nostalgic])
					.c2t_bb($skill[feel envy])
					.c2t_hccs_bbChargeSkill($skill[chest x-ray])
					.c2t_hccs_bbChargeSkill($skill[shattering punch])
					.c2t_bb($skill[gingerbread mob hit])
					.c2t_bbSubmit();
					return;
				}
			case $monster[hobelf]://apparently this doesn't work?
			case $monster[elf hobo]://this might though?
			case $monster[angry pi&ntilde;ata]:
				mSteal
					.c2t_bb($skill[use the force])//don't care about tracking a potential stolen item, so cut it straight away
					.c2t_bbSubmit();
				return;

			//using all free kills on neverending party monsters
			case $monster[biker]:
			case $monster[burnout]:
			case $monster[jock]:
			case $monster[party girl]:
			case $monster["plain" girl]:
				m = mHead + mSteal;
				if (have_equipped($item[backup camera]) && c2t_hccs_backupCameraLeft() > 0) {
					m += c2t_bb($skill[back-up to your last enemy]).c2t_bb("twiddle;");
					m.c2t_bbSubmit();
					return;
				}
				//feel pride still thinks it can be used after max uses for some reason
				m += c2t_hccs_bbChargeSkill($skill[feel pride]);

				//free kills after NEP free fights
				if (get_property('_neverendingPartyFreeTurns').to_int() == 10 && !get_property('_gingerbreadMobHitUsed').to_boolean()) {
					c2t_bbSubmit(
						m
						.c2t_bb($skill[sing along])
						.c2t_hccs_bowlSideways()
						//free kill skills
						//won't use otoscope anywhere else, so might as well use it while doc bag equipped
						.c2t_hccs_bbChargeSkill($skill[otoscope])
						.c2t_hccs_bbChargeSkill($skill[chest x-ray])
						.c2t_hccs_bbChargeSkill($skill[shattering punch])
						.c2t_bb($skill[gingerbread mob hit])
					);
				}
				//free combats at NEP
				else
					c2t_bbSubmit(m + mBasic);

				return;

			//most basic of combats
			case $monster[piranha plant]:
			case $monster[government bureaucrat]:
			case $monster[terrible mutant]:
			case $monster[angry ghost]:
			case $monster[annoyed snake]:
			case $monster[slime blob]:
				c2t_bbSubmit(mHead + mSteal + mBasic);
				return;

			//chain potential; basic otherwise
			case $monster[sausage goblin]:
				c2t_bbSubmit(mHead + mChain);
				return;

			//nostalgia goes here
			case $monster[god lobster]:
				m = mHead;
				//grabbing moxie buff item
				if (my_primestat() == $stat[moxie]
					&& have_effect($effect[unrunnable face]) == 0
					&& item_amount($item[runproof mascara]) == 0
					&& get_property('lastCopyableMonster').to_monster() == $monster[party girl]) {

					m += c2t_bb($skill[feel nostalgic]);
					m += c2t_bb($skill[feel envy]);
				}
				if (get_property('lastCopyableMonster').to_monster() == $monster[novelty tropical skeleton]
					|| get_property('lastCopyableMonster').to_monster() == $monster[possessed can of tomatoes]) {

					m += c2t_bb($skill[feel nostalgic]);
					m += c2t_bb($skill[feel envy]);
				}

				m += mBasic;
				m.c2t_bbSubmit();
				return;

			case $monster[eldritch tentacle]:
				c2t_bbSubmit(
					mHead + mSteal
					.c2t_bb($skill[micrometeorite])
					.c2t_bb($skill[detect weakness])
					.c2t_bb($skill[curse of weaksauce])
					.c2t_bb($skill[sing along])
					.c2t_bbIf("sealclubber || turtletamer || discobandit || accordionthief",
						c2t_bbWhile("!pastround 20","attack;")
					)
					.c2t_bbIf("pastamancer || sauceror",
						c2t_bb(4,$skill[saucestorm])
					)
				);
				return;

			case $monster[sssshhsssblllrrggghsssssggggrrgglsssshhssslblgl]:
				c2t_bbSubmit("attack;repeat;");
				return;

			//free run from holiday monsters
			//Feast of Boris
			case $monster[candied yam golem]:
			case $monster[malevolent tofurkey]:
			case $monster[possessed can of cranberry sauce]:
			case $monster[stuffing golem]:
			//El Dia de Los Muertos Borrachos
			case $monster[novia cad&aacute;ver]:
			case $monster[novio cad&aacute;ver]:
			case $monster[padre cad&aacute;ver]:
			case $monster[persona inocente cad&aacute;ver]:
			//talk like a pirate day
			case $monster[ambulatory pirate]:
			case $monster[migratory pirate]:
			case $monster[peripatetic pirate]:
				m = mHead + mSteal;
				m += c2t_hccs_bbChargeSkill($skill[reflex hammer]);
				m += c2t_hccs_bbChargeSkill($skill[kgb tranquilizer dart]);
				if (get_property("_snokebombUsed").to_int() <= get_property("_feelHatredUsed").to_int())
					m += c2t_hccs_bbChargeSkill($skill[snokebomb]).c2t_hccs_bbChargeSkill($skill[feel hatred]);
				else
					m += c2t_hccs_bbChargeSkill($skill[feel hatred]).c2t_hccs_bbChargeSkill($skill[snokebomb]);
				m.c2t_bbSubmit();
				//redo last; map the monsters is handled elsewhere since it doesn't like adv1()
				if (!get_property('mappingMonsters').to_boolean())
					adv1(loc);
				return;

			default:
				//this shouldn't happen
				abort("Currently in combat with something not accounted for in the combat script. Aborting.");
		}
	}
}	

string c2t_hccs_bowlSideways() return c2t_hccs_bowlSideways("");
string c2t_hccs_bowlSideways(string m) {
	string out = m+c2t_bb($skill[bowl sideways]);
	int backup = get_property("_backUpUses").to_int();
	int nep = 10-get_property("_neverendingPartyFreeTurns").to_int();
	int free = c2t_hccs_freeKillsLeft();
	if (out == m)
		return m;
	if (get_property("csServicesPerformed") != "Coil Wire")
		return m;
	if (my_familiar() == $familiar[ghost of crimbo carols])
		return m;
	if (my_location() != $location[the neverending party])
		return m;
	if (my_familiar() == $familiar[pocket professor])//professor copies should be in the zone
		return out;
	if (backup > 0 && backup < 11)//backups unaffected, so skip while doing them
		return m;
	if (nep+free > 1)
		return out;
	return m;
}

//stopgap for now; should add a handler to lib
string c2t_hccs_bbChargeSkill(string m,skill ski) {
	return m + c2t_hccs_bbChargeSkill(ski);
}
string c2t_hccs_bbChargeSkill(skill ski) {
	string prop;
	int max;
	switch (ski) {
		default:
			abort(`Error: unhandled skill in c2t_hccs_bbChargeSkill: "{ski}"`);
		case $skill[chest x-ray]:
			prop = "_chestXRayUsed";
			max = 3;
			break;
		case $skill[feel hatred]:
			prop = "_feelHatredUsed";
			max = 3;
			break;
		case $skill[feel pride]:
			prop = "_feelPrideUsed";
			max = 3;
			break;
		case $skill[kgb tranquilizer dart]:
			prop = "_kgbTranquilizerDartUses";
			max = 3;
			break;
		case $skill[otoscope]:
			prop = "_otoscopeUsed";
			max = 3;
			break;
		case $skill[reflex hammer]:
			prop = "_reflexHammerUsed";
			max = 3;
			break;
		case $skill[shattering punch]:
			prop = "_shatteringPunchUsed";
			max = 3;
			break;
		case $skill[snokebomb]:
			prop = "_snokebombUsed";
			max = 3;
			break;
	}
	return get_property(prop).to_int() < max ? c2t_bb(ski) : "";
}



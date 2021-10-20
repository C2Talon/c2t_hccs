//c2t community service combat
//c2t

import <c2t_lib.ash>


// consult script for CS

void main(int initround, monster foe, string page) {
	//saber force
	if (have_effect($effect[meteor showered]) > 0 || have_effect($effect[Fireproof Foam Suit]) > 0) {
		c2t_bb($skill[Use the Force]).c2t_bbSubmit();
		return;
	}

	//guessing that macros might be submitted too fast in certain cases, so trying this as a speed bump
	if (get_property("_c2t_lastCombatStarted") != get_property("_lastCombatStarted")) {
		set_property("_c2t_lastCombatStarted",get_property("_lastCombatStarted"));
		set_property("_c2t_lastCombatFoe",foe.to_string());
		set_property("_c2t_combatReentryCount","0");
	}
	//should allow backups through?
	else if (foe.to_string() != get_property("_c2t_lastCombatFoe"))
		set_property("_c2t_lastCombatFoe",foe.to_string());
	//to prevent an infinite loop and "speed bump"
	else {
		set_property("_c2t_combatReentryCount",(get_property("_c2t_combatReentryCount").to_int()+1).to_string());
		if (get_property("_c2t_combatReentryCount").to_int() >= 5)
			abort("The combat script was called at least 5 times without combat resolving");
		waitq(1);
		return;
	}


	string mHead = "scrollwhendone;";
	string mSteal = "pickpocket;";

	//basic macro/what to run when nothing special needs be done or after the special thing is done
	string mBasic =	c2t_bb($skill[disarming thrust])
		.c2t_bb($skill[detect weakness])
		.c2t_bb($skill[micrometeorite])
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
	if (my_familiar() == $familiar[Ghost of Crimbo Carols]) {
		m = mHead + mSteal;
		if (foe == $monster[fluffy bunny]) {
			m += c2t_bb($skill[Become a Cloud of Mist]);
			m += c2t_bb($skill[Fire Extinguisher: Foam Yourself]);
			m.c2t_bbSubmit();
		}
		else {//NEP
			m += c2t_bb($skill[Gulp Latte]);
			m += c2t_bb($skill[Offer Latte to Opponent]);
			m += c2t_bb($skill[Throw Latte on Opponent]);
			m.c2t_bbSubmit();
		}
		return;
	}
	//saber random thing at this location for meteor shower buff -- saber happens elsewhere
	else if (get_property("lastAdventure").to_location() == $location[Thugnderdome]) {
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
				if (have_equipped($item[backup camera]) && get_property("_backUpUses").to_int() < 11) {
					c2t_bbSubmit(
						c2t_bb($skill[back-up to your last enemy])
						.c2t_bb("twiddle;")
					);
					return;
				}
				c2t_bbSubmit(
					mHead + mSteal
					.c2t_bb(have_effect($effect[Bat-Adjacent Form]) == 0?c2t_bb($skill[Become a Bat]):"")
					.c2t_bb($skill[reflex hammer])
					.c2t_bb($skill[snokebomb])
					.c2t_bb($skill[feel hatred])
				);
				return;

			//nostalgia other monster to get drops from these
			case $monster[possessed can of tomatoes]:
				//if no god lobster, burn a free kill to get both monsters' drops with nostalgia/envy here
				if (get_property('lastCopyableMonster').to_monster() == $monster[novelty tropical skeleton]) {
					mSteal
					.c2t_bb($skill[Feel Nostalgic])
					.c2t_bb($skill[Feel Envy])
					.c2t_bb($skill[become a wolf])
					.c2t_bb($skill[gulp latte])
					.c2t_bb(get_property("_chestXRayUsed").to_int() < 3 ? c2t_bb($skill[Chest X-Ray]) : "")
					.c2t_bb(get_property("_shatteringPunchUsed").to_int() < 3 ? c2t_bb($skill[Shattering Punch]) : "")
					.c2t_bb($skill[Gingerbread Mob Hit])
					.c2t_bbSubmit();
					return;
				}
			case $monster[novelty tropical skeleton]:
				c2t_bbSubmit(
					mSteal
					.c2t_bb($skill[become a wolf])
					.c2t_bb($skill[gulp latte])
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
			case $monster[Evil Olive]:
				//have to burn a free kill and nostalgia/envy if no god lobster
				if (!have_familiar($familiar[god lobster])
					&& have_familiar($familiar[Ghost of Crimbo Carols])
					&& get_property('lastCopyableMonster').to_monster() == $monster["plain" girl]) {

					mSteal
					.c2t_bb($skill[Feel Nostalgic])
					.c2t_bb($skill[Feel Envy])
					.c2t_bb(get_property("_chestXRayUsed").to_int() < 3 ? c2t_bb($skill[Chest X-Ray]) : "")
					.c2t_bb(get_property("_shatteringPunchUsed").to_int() < 3 ? c2t_bb($skill[Shattering Punch]) : "")
					.c2t_bb($skill[Gingerbread Mob Hit])
					.c2t_bbSubmit();
					return;
				}
			case $monster[hobelf]://apparently this doesn't work?
			case $monster[elf hobo]://this might though?
			case $monster[angry pi&ntilde;ata]:
				mSteal
					.c2t_bb($skill[Use the Force])//don't care about tracking a potential stolen item, so cut it straight away
					.c2t_bbSubmit();
				return;

			//using all free kills on neverending party monsters
			case $monster[biker]:
			case $monster[burnout]:
			case $monster[jock]:
			case $monster[party girl]:
			case $monster["plain" girl]:
				m = mHead + mSteal;
				if (have_equipped($item[backup camera]) && get_property("_backUpUses").to_int() < 11) {
					m += c2t_bb($skill[back-up to your last enemy]).c2t_bb("twiddle;");
					m.c2t_bbSubmit();
					return;
				}
				//feel pride still thinks it can be used after max uses for some reason
				m += get_property("_feelPrideUsed").to_int() < 3 ? c2t_bb($skill[Feel Pride]) : "";

				//free kills after NEP free fights
				if (get_property('_neverendingPartyFreeTurns').to_int() == 10 && !get_property('_gingerbreadMobHitUsed').to_boolean()) {
					c2t_bbSubmit(
						m
						.c2t_bb($skill[Sing Along])
						//free kill skills
						//won't use otoscope anywhere else, so might as well use it while doc bag equipped
						.c2t_bb(get_property("_otoscopeUsed").to_int() < 3 ? c2t_bb($skill[Otoscope]) : "")
						.c2t_bb(get_property("_chestXRayUsed").to_int() < 3 ? c2t_bb($skill[Chest X-Ray]) : "")
						.c2t_bb(get_property("_shatteringPunchUsed").to_int() < 3 ? c2t_bb($skill[Shattering Punch]) : "")
						.c2t_bb($skill[Gingerbread Mob Hit])
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
			case $monster[God Lobster]:
				m = mHead;
				//grabbing moxie buff item
				if (my_primestat() == $stat[moxie]
					&& have_effect($effect[Unrunnable Face]) == 0
					&& item_amount($item[runproof mascara]) == 0
					&& get_property('lastCopyableMonster').to_monster() == $monster[party girl]) {

					m += c2t_bb($skill[Feel Nostalgic]);
					m += c2t_bb($skill[Feel Envy]);
				}
				if (get_property('lastCopyableMonster').to_monster() == $monster[novelty tropical skeleton]
					|| get_property('lastCopyableMonster').to_monster() == $monster[possessed can of tomatoes]) {

					m += c2t_bb($skill[Feel Nostalgic]);
					m += c2t_bb($skill[Feel Envy]);
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
			case $monster[Candied Yam Golem]:
			case $monster[Malevolent Tofurkey]:
			case $monster[Possessed Can of Cranberry Sauce]:
			case $monster[Stuffing Golem]:
			//El Dia de Los Muertos Borrachos
			case $monster[Novia Cad&aacute;ver]:
			case $monster[Novio Cad&aacute;ver]:
			case $monster[Padre Cad&aacute;ver]:
			case $monster[Persona Inocente Cad&aacute;ver]:
			//talk like a pirate day
			case $monster[ambulatory pirate]:
			case $monster[migratory pirate]:
			case $monster[peripatetic pirate]:
				m = mHead + mSteal;
				m += c2t_bb($skill[reflex hammer]);
				if (get_property("_snokebombUsed").to_int() < get_property("_feelHatredUsed").to_int())
					m += c2t_bb($skill[snokebomb]).c2t_bb($skill[feel hatred]);
				else
					m += c2t_bb($skill[feel hatred]).c2t_bb($skill[snokebomb]);
				m.c2t_bbSubmit();
				//pretty sure most adv1() in the script assume it succeeds in fighting what it's supposed to, which the holiday monster is very much not the right one, so abort to rerun
				abort("Aborting for safety after encountering a holiday monster. Should be able to simply rerun to resume.");
				//going to test using adv1() instead of abort for next round of holiday wanderers
				//adv1(get_property("lastAdventure").to_location());
				return;

			default:
				//this shouldn't happen
				abort("Currently in combat with something not accounted for in the combat script. Aborting.");
		}
	}
}	





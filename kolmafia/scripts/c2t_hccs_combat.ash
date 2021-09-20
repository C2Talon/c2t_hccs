//c2t community service combat
//c2t

//most of this is subject to drastic change; the macro builder stuff probably going to be pulled out and made standalone at some point

//print macros to the CLI that are being submitted
boolean PRINT_MACRO = get_property("c2t_bb_printMacro").to_boolean();

//---
// BALLS builder
// functions here are used to translate things like skill use into BALLS macro form
// all functions with "macro" argument return the same as the non-"macro" one, but with "macro" prepended to it

//combine/append
string bb(string macro,string str);
//just in case
string bb(string macro);
//finite repetition of a skill
string bb(int num,skill ski);
string bb(string macro,int num,skill ski);
//single skill
string bb(skill ski);
string bb(string macro,skill ski);
//combat item(s)
string bb(item it1);
string bb(string macro,item it1);
//funkslinging
string bb(item it1,item it2);
string bb(string macro,item it1,item it2);
//if
string bbIf(string condition,string str);
string bbIf(string macro,string condition,string str);
//while
string bbWhile(string condition,string str);
string bbWhile(string macro,string condition,string str);
//submit the macro in combat
string bbSubmit(string macro);

//---
// consult script for CS

void main(int initround, monster foe, string page) {
	//saber force
	if (have_effect($effect[meteor showered]) > 0 || have_effect($effect[Fireproof Foam Suit]) > 0) {
		bb($skill[Use the Force]).bbSubmit();
		return;
	}

	string mHead = "scrollwhendone;";
	string mSteal = "pickpocket;";

	//basic macro/what to run when nothing special needs be done or after the special thing is done
	string mBasic =	bb($skill[disarming thrust])
		.bb($skill[detect weakness])
		.bb($skill[micrometeorite])
		.bbIf("sealclubber || turtletamer || discobandit || accordionthief",
			bb($skill[curse of weaksauce])
			.bb($skill[sing along])
			.bbWhile("!pastround 20",bb("attack;"))
		)
		.bbIf("pastamancer",
			bb($skill[stuffed mortar shell])
			.bb($skill[sing along])
		)
		.bbIf("sauceror",
			bb($skill[curse of weaksauce])
			.bb($skill[stuffed mortar shell])
			.bb($skill[sing along])
			.bb($skill[saucegeyser])
		);

	//mostly mBasic with relativity sprinkled in and small heal to help moxie survive chaining
	string mChain =	bb($skill[disarming thrust])
		.bb($skill[detect weakness])
		.bb($skill[micrometeorite])
		.bbIf("sealclubber || turtletamer || discobandit || accordionthief",
			bb($skill[curse of weaksauce])
			.bbIf("discobandit || accordionthief",bb($skill[saucy salve]))
			.bb($skill[sing along])
			.bb($skill[lecture on relativity])
			.bbWhile("!pastround 20",bb("attack;"))
		)
		.bbIf("pastamancer",
			bb($skill[lecture on relativity])
			.bb($skill[stuffed mortar shell])
			.bb($skill[sing along])
		)
		.bbIf("sauceror",
			bb($skill[curse of weaksauce])
			.bb($skill[sing along])
			.bb($skill[lecture on relativity])
			.bb($skill[saucegeyser])
			.bb($skill[saucegeyser])
		);

	//macro to build
	string m;

	//run with ghost caroler for buffs at NEP and dire warren at different times
	if (my_familiar() == $familiar[Ghost of Crimbo Carols]) {
		m = mHead + mSteal;
		if (foe == $monster[fluffy bunny]) {
			m += bb($skill[Become a Cloud of Mist]);
			m += bb($skill[Fire Extinguisher: Foam Yourself]);
			m.bbSubmit();
		}
		else {//NEP
			m += bb($skill[Gulp Latte]);
			m += bb($skill[Offer Latte to Opponent]);
			m += bb($skill[Throw Latte on Opponent]);
			m.bbSubmit();
		}
		return;
	}
	//saber random thing at this location for meteor shower buff -- saber happens elsewhere
	else if (get_property("lastAdventure").to_location() == $location[Thugnderdome]) {
		m = mHead + mSteal.bb($skill[meteor shower]);

		//camel spit for weapon test, which is directly after combat test
		if (get_property("csServicesPerformed").contains_text("Be a Living Statue") && !get_property("csServicesPerformed").contains_text("Reduce Gazelle Population"))
			m += bb($skill[%fn, spit on me!]);

		m.bbSubmit();
		return;
	}
	else {
		//basically mimicking CCS
		switch (foe) {
			//only use 1 become the bat for item test and initial latte throw
			case $monster[fluffy bunny]:
				if (have_equipped($item[backup camera]) && get_property("_backUpUses").to_int() < 11) {
					bbSubmit(
						bb($skill[back-up to your last enemy])
						.bb("twiddle;")
					);
					return;
				}
				bbSubmit(
					mHead + mSteal
					.bb(have_effect($effect[Bat-Adjacent Form]) == 0?bb($skill[Become a Bat]):"")
					.bb($skill[reflex hammer])
					.bb($skill[snokebomb])
				);
				return;

			//nostalgia other monster to get drops from these
			case $monster[novelty tropical skeleton]:
			case $monster[possessed can of tomatoes]:
				bbSubmit(
					mSteal
					.bb($skill[become a wolf])
					.bb($skill[gulp latte])
					.bb($skill[throw latte on opponent])
				);
				return;
			//faxes -- saber use is elsewhere
			case $monster[ungulith]:
			case $monster[factory worker (female)]:
			case $monster[factory worker (male)]://just in case this shows up
				bbSubmit(
					mSteal
					.bb($skill[meteor shower])
				);
				return;
			case $monster[Evil Olive]:
			case $monster[hobelf]://apparently this doesn't work?
			case $monster[elf hobo]://this might though?
			case $monster[angry pi&ntilde;ata]:
				mSteal
					.bb($skill[Use the Force])//don't care about tracking a potential stolen item, so cut it straight away
					.bbSubmit();
				return;

			//using all free kills on neverending party monsters
			case $monster[biker]:
			case $monster[burnout]:
			case $monster[jock]:
			case $monster[party girl]:
			case $monster["plain" girl]:
				m = mHead + mSteal;
				if (have_equipped($item[backup camera]) && get_property("_backUpUses").to_int() < 11) {
					m += bb($skill[back-up to your last enemy]).bb("twiddle;");
					m.bbSubmit();
					return;
				}
				//feel pride still thinks it can be used after max uses for some reason
				m += get_property("_feelPrideUsed").to_int() < 3 ? bb($skill[Feel Pride]) : "";

				//free kills after NEP free fights
				if (get_property('_neverendingPartyFreeTurns').to_int() == 10 && !get_property('_gingerbreadMobHitUsed').to_boolean()) {
					bbSubmit(
						m
						.bb($skill[Sing Along])
						//free kill skills
						//won't use otoscope anywhere else, so might as well use it while doc bag equipped
						.bb(get_property("_otoscopeUsed").to_int() < 3 ? bb($skill[Otoscope]) : "")
						.bb(get_property("_chestXRayUsed").to_int() < 3 ? bb($skill[Chest X-Ray]) : "")
						.bb(get_property("_shatteringPunchUsed").to_int() < 3 ? bb($skill[Shattering Punch]) : "")
						.bb($skill[Gingerbread Mob Hit])
					);
				}
				//free combats at NEP
				else
					bbSubmit(m + mBasic);

				return;

			//most basic of combats
			case $monster[piranha plant]:
			case $monster[government bureaucrat]:
			case $monster[terrible mutant]:
			case $monster[angry ghost]:
			case $monster[annoyed snake]:
			case $monster[slime blob]:
				bbSubmit(mHead + mSteal + mBasic);
				return;

			//chain potential; basic otherwise
			case $monster[sausage goblin]:
				bbSubmit(mHead + mChain);
				return;

			//nostalgia goes here
			case $monster[God Lobster]:
				m = mHead;
				//grabbing moxie buff item
				if (my_primestat() == $stat[moxie]
					&& have_effect($effect[Unrunnable Face]) == 0
					&& item_amount($item[runproof mascara]) == 0
					&& get_property('lastCopyableMonster').to_monster() == $monster[party girl]) {

					m += bb($skill[Feel Nostalgic]);
					m += bb($skill[Feel Envy]);
				}
				if (get_property('lastCopyableMonster').to_monster() == $monster[novelty tropical skeleton]
					|| get_property('lastCopyableMonster').to_monster() == $monster[possessed can of tomatoes]) {

					m += bb($skill[Feel Nostalgic]);
					m += bb($skill[Feel Envy]);
				}

				m += mBasic;
				m.bbSubmit();
				return;

			case $monster[eldritch tentacle]:
				bbSubmit(
					mHead + mSteal
					.bb($skill[micrometeorite])
					.bb($skill[detect weakness])
					.bb($skill[curse of weaksauce])
					.bb($skill[sing along])
					.bbIf("sealclubber || turtletamer || discobandit || accordionthief",
						bbWhile("!pastround 20","attack;")
					)
					.bbIf("pastamancer || sauceror",
						bb(4,$skill[saucestorm])
					)
				);
				return;

			case $monster[sssshhsssblllrrggghsssssggggrrgglsssshhssslblgl]:
				bbSubmit("attack;repeat;");
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
				m += bb($skill[reflex hammer]);
				if (get_property("_snokebombUsed").to_int() < get_property("_feelHatredUsed").to_int())
					m += bb($skill[snokebomb]);
				else
					m += bb($skill[feel hatred]);
				m.bbSubmit();
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


//---
// build/use BALLS macros

//combine/append
string bb(string m,string s) {
	return m + s;
}
//just in case
string bb(string m) {
	return m;
}

//finite repetition of a skill
string bb(int num,skill ski) {
	string out;
	if (have_skill(ski))
		for i from 1 to num
			out += `skill {ski.to_int()};`;
	return out;
}
string bb(string m,int num,skill ski) {
	return m + bb(num,ski);
}
//single skill
string bb(skill ski) {
	return bb(1,ski);
}
string bb(string m,skill ski) {
	return m + bb(1,ski);
}

//combat item(s)
string bb(item it1) {
	return `item {it1.to_int()};`;
}
string bb(string m,item it1) {
	return m + bb(it1);
}
//funkslinging
string bb(item it1,item it2) {
	return `item {it1.to_int()},{it2.to_int()};`;
}
string bb(string m,item it1,item it2) {
	return m + bb(it1,it2);
}

//if
string bbIf(string c,string s) {
	return `if {c};{s}endif;`;
}
string bbIf(string m,string c,string s) {
	return m + bbIf(c,s);
}

//while
string bbWhile(string c,string s) {
	return `while {c};{s}endwhile;`;
}
string bbWhile(string m,string c,string s) {
	return m + bbWhile(c,s);
}

//submit
string bbSubmit(string m) {
	if (PRINT_MACRO)
		print(`bb macro: {m}`);
	return visit_url("fight.php?action=macro&macrotext="+m,true,false);
}


//c2t
//c2t community service combat

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
		if (have_skill($skill[Become a Cloud of Mist]) && have_effect($effect[Misty Form]) == 0 && get_property('csServicesPerformed').contains_text('Breed More Collies'))
			m += bb($skill[Become a Cloud of Mist]);
		if (have_skill($skill[Offer Latte to Opponent]))
			m += bb($skill[Offer Latte to Opponent]);
		if (have_skill($skill[Snokebomb]) && get_property('_snokebombUsed').to_int() < 3)
			m += bb($skill[Snokebomb]);
		if (have_skill($skill[Throw Latte on Opponent]) && !get_property('_latteBanishUsed').to_boolean())
			m += bb($skill[Throw Latte on Opponent]);
		m.bbSubmit();
		return;
	}
	//saber random thing at this location for meteor shower buff
	else if (get_property("lastAdventure").to_location() == $location[Thugnderdome]) {
		bbSubmit(
			mSteal
			.bb($skill[meteor shower])
		);
		waitq(1);
		bb($skill[Use the Force]).bbSubmit();
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
					.bb($skill[throw latte on opponent])
					.bb($skill[reflex hammer])
					.bb($skill[snokebomb])
				);
				return;

			//saber yr to not break mafia tracking
			case $monster[ungulith]:
				bbSubmit(
					mSteal
					.bb($skill[%fn, spit on me!])
					.bb($skill[meteor shower])
				);
				waitq(1);
				bb($skill[Use the Force]).bbSubmit();
				return;
			case $monster[novelty tropical skeleton]:
				bbSubmit(
					mSteal
					.bb($skill[become a wolf])
					.bb($skill[gulp latte])
				);
				waitq(1);
				bb($skill[Use the Force]).bbSubmit();
				return;
			case $monster[possessed can of tomatoes]:
				bbSubmit(
					mSteal
					.bb($skill[become a wolf])
					.bb($skill[gulp latte])
					.bb($skill[feel hatred])
				);
				//no longer sabering tomato //nostalgia/envy on piranha plant for its drops
				return;
			case $monster[factory worker (female)]:
			case $monster[factory worker (male)]://just in case this shows up
				bbSubmit(
					mSteal
					.bb($skill[meteor shower])
				);
				waitq(1);
				bb($skill[Use the Force]).bbSubmit();
				return;
			case $monster[Evil Olive]:
			case $monster[hobelf]://apparently this doesn't work?
			case $monster[elf hobo]://this might though?
			case $monster[angry pi&ntilde;ata]:
				mSteal.bbSubmit();
				waitq(1);
				bb($skill[Use the Force]).bbSubmit();
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
				/*if (have_skill($skill[Army of Toddlers]) && !get_property('_armyToddlerCast').to_boolean()) {
					m += bb($skill[Army of Toddlers]);
					//toddlers mess with combat text, so submit it now
					m.bbSubmit();
					waitq(1);
					m = mHead;
				}*/

				//free kills after NEP free fights
				if (get_property('_neverendingPartyFreeTurns').to_int() == 10 && !get_property('_gingerbreadMobHitUsed').to_boolean()) {
					bbSubmit(
						m
						.bb($skill[Sing Along])
						//free kill skills
						.bb($skill[Otoscope])//won't use otoscope anywhere else, so might as well use it while doc bag equipped
						.bb($skill[Chest X-Ray])//this is unequipped after all uses, so don't need to check for it for now
						.bb(get_property("_shatteringPunchUsed").to_int() < 3 ? bb($skill[Shattering Punch]) : "")
						.bb($skill[Gingerbread Mob Hit])
					);
				}
				//free combats at NEP
				else
					bbSubmit(m + mBasic);

				return;

			case $monster[piranha plant]://should be getting tomato from this
				bbSubmit(
					mHead + mSteal
					.bb($skill[feel nostalgic])
					.bb($skill[feel envy])
					+ mBasic
				);
				return;

			//vote monsters: most basic of combats
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
				m = mHead + mSteal;
				m += bb("abort after;");
				m += bb($skill[reflex hammer]);
				if (get_property("_snokebombUsed").to_int() < get_property("_feelHatredUsed").to_int())
					m += bb($skill[snokebomb]);
				else
					m += bb($skill[feel hatred]);
				m.bbSubmit();
				//pretty sure most adv1() in the script assume it succeeds in fighting what it's supposed to, which the holiday monster is very much not the right one, so abort to rerun
				//I don't think the combat script will get far enough to abort though
				abort("Aborting for safety after encountering a holiday monster. Should be able to simply rerun to resume.");
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
		print(`macro: {m}`,"blue");
	return visit_url("fight.php?action=macro&macrotext="+m,true,false);
}


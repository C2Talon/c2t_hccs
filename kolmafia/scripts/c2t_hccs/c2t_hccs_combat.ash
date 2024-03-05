//c2t community service combat
//c2t

import <c2t_lib.ash>
import <c2t_hccs_lib.ash>
import <c2t_hccs_resources.ash>


// consult script for CS

//the logic for bowling sideways to bolt into c2t_bb
string c2t_hccs_bowlSideways();
string c2t_hccs_bowlSideways(string m);

//portscan logic
string c2t_hccs_portscan();
string c2t_hccs_portscan(string m);

//handle some skills with charges
string c2t_hccs_bbLimited(skill ski);
string c2t_hccs_bbLimited(string m,skill ski);

//map of holiday wanderers
boolean[monster] c2t_hccs_holidayWanderers();


void main(int initround, monster foe, string page) {
	//for holiday wanderer redos, since post-adv script can change my_location()
	location loc = my_location();

	//saber force
	if (have_effect($effect[meteor showered]) > 0
		|| have_effect($effect[fireproof foam suit]) > 0)
	{
		c2t_bb($skill[use the force])
		.c2t_bbSubmit();
		return;
	}

	string mHead = "scrollwhendone;";
	string mSteal = "pickpocket;";

	//top of basic macro, where all the weakening stuff is
	string mBasicTop =
		c2t_bb($skill[curse of weaksauce])
		.c2t_bb($skill[disarming thrust])
		.c2t_bb($skill[micrometeorite])
		.c2t_bb($skill[detect weakness])
		.c2t_hccs_bowlSideways();

	//bottom of basic macro, where all the damaging stuff is
	string mBasicBot =
		c2t_bbIf("sealclubber || turtletamer || discobandit || accordionthief",
			c2t_bb($skill[sing along])
			.c2t_bb($skill[darts: throw at %part1])
			.c2t_bbWhile("!pastround 20",c2t_bb("attack;"))
		)
		.c2t_bbIf("pastamancer",
			c2t_bb($skill[darts: throw at %part1])
			.c2t_bb($skill[stuffed mortar shell])
			.c2t_bb($skill[sing along])
			.c2t_bb(2,$skill[saucegeyser])
		)
		.c2t_bbIf("sauceror",
			c2t_bb($skill[darts: throw at %part1])
			.c2t_bb($skill[stuffed mortar shell])
			.c2t_bb($skill[sing along])
			.c2t_bb(2,$skill[saucegeyser])
		);

	//basic macro/what to run when nothing special needs be done
	string mBasic =	mBasicTop + mBasicBot;

	//mostly mBasic with relativity sprinkled in and small heal to help moxie survive chaining
	string mChain =
		mBasicTop
		.c2t_bbIf("sealclubber || turtletamer || discobandit || accordionthief",
			c2t_bbIf("discobandit || accordionthief",c2t_bb($skill[saucy salve]))
			.c2t_bb($skill[sing along])
			.c2t_bb($skill[lecture on relativity])
			.c2t_bb($skill[darts: throw at %part1])
			.c2t_bbWhile("!pastround 20",c2t_bb("attack;"))
		)
		.c2t_bbIf("pastamancer",
			c2t_bb($skill[lecture on relativity])
			.c2t_bb($skill[darts: throw at %part1])
			.c2t_bb($skill[stuffed mortar shell])
			.c2t_bb($skill[sing along])
			.c2t_bb(2,$skill[saucegeyser])
		)
		.c2t_bbIf("sauceror",
			c2t_bb($skill[curse of weaksauce])
			.c2t_bb($skill[sing along])
			.c2t_bb($skill[lecture on relativity])
			.c2t_bb($skill[darts: throw at %part1])
			.c2t_bb(3,$skill[saucegeyser])
		);

	//macro to build
	string m;

	//run with ghost caroler for buffs at NEP and dire warren at different times
	if (my_familiar() == $familiar[ghost of crimbo carols]) {
		m = mHead + mSteal;
		if (foe == $monster[fluffy bunny]) {
			m += c2t_bb($skill[become a cloud of mist]);
			m += c2t_bb($skill[fire extinguisher: foam yourself]);
			m.c2t_bbSubmit(true);
		}
		else if (foe == $monster[government agent])
			abort("Portscan logic failed. Either banish or free kill the government agent, then run the script again. Also, report this.");
		else {//NEP
			m += c2t_bb($skill[gulp latte]);
			m += c2t_bb($skill[offer latte to opponent]);
			m += c2t_hccs_portscan();
			m += c2t_bb($skill[throw latte on opponent]);
			m.c2t_bbSubmit();
		}
		return;
	}
	//saber random thing at this location for meteor shower buff -- saber happens elsewhere
	else if (my_location() == $location[thugnderdome]
		&& !(c2t_hccs_holidayWanderers() contains foe))
	{
		m = mHead + mSteal.c2t_bb($skill[meteor shower]);

		//camel spit for weapon test, which is directly after combat test
		if (get_property("csServicesPerformed").contains_text("Be a Living Statue")
			&& !get_property("csServicesPerformed").contains_text("Reduce Gazelle Population"))
		{
			m += c2t_bb($skill[%fn, spit on me!]);
		}
		m.c2t_bbSubmit(true);
		return;
	}
	//basically mimicking CCS
	else switch (foe) {
		//only use 1 become the bat for item test and initial latte throw
		case $monster[fluffy bunny]:
			//hot test bit; assumes item test is done beforehand
			if (get_property("csServicesPerformed").contains_text("Make Margaritas")) {
				m = mHead + mSteal;
				m += c2t_bb($skill[become a cloud of mist]);
				m += c2t_bb($skill[fire extinguisher: foam yourself]);
				m.c2t_bbSubmit(true);
				return;
			}
			//fishing for latte ingredients with backups
			else if (have_equipped($item[backup camera])
				&& c2t_hccs_backupCameraLeft() > 0)
			{
				c2t_bb($skill[back-up to your last enemy])
				.c2t_bb("twiddle;")
				.c2t_bbSubmit(true);
				return;
			}
			c2t_bbSubmit(
				mHead + mSteal
				.c2t_bb(have_effect($effect[bat-adjacent form]) == 0?c2t_bb($skill[become a bat]):"")
				.c2t_bb(have_effect($effect[cosmic ball in the air]) == 0?c2t_bb($skill[bowl straight up]):"")
				.c2t_hccs_bbLimited($skill[reflex hammer])
				.c2t_hccs_bbLimited($skill[kgb tranquilizer dart])
				.c2t_hccs_bbLimited($skill[snokebomb])
				.c2t_hccs_bbLimited($skill[feel hatred])
			);
			return;

		//nostalgia other monster to get drops from these
		case $monster[possessed can of tomatoes]:
			//if no god lobster, burn a free kill to get both monsters' drops with nostalgia/envy here
			if (!have_familiar($familiar[god lobster])
				&& get_property("lastCopyableMonster").to_monster() == $monster[novelty tropical skeleton])
			{
				m = mSteal;
				m += c2t_bb($skill[feel nostalgic]);
				m += c2t_bb($skill[feel envy]);
				m += c2t_bb($skill[gulp latte]);
				if (!have_familiar($familiar[ghost of crimbo carols]) && my_primestat() != $stat[moxie])
					m += c2t_hccs_portscan();
				m += c2t_hccs_bbLimited($skill[chest x-ray]);
				m += c2t_hccs_bbLimited($skill[shattering punch]);
				m += c2t_hccs_bbLimited($skill[gingerbread mob hit]);
				m.c2t_bbSubmit();
				return;
			}
			m = mSteal;
			m += c2t_bb($skill[gulp latte]);
			if (!have_familiar($familiar[ghost of crimbo carols]) && my_primestat() != $stat[moxie])
				m += c2t_hccs_portscan();
			m += c2t_bb($skill[throw latte on opponent]);
			m.c2t_bbSubmit();
			return;

		case $monster[novelty tropical skeleton]:
			mSteal
			.c2t_bb($skill[giant growth])
			.c2t_bb($skill[become a wolf])
			.c2t_bb($skill[gulp latte])
			.c2t_bb($skill[bowl straight up])
			.c2t_bb($skill[launch spikolodon spikes])
			.c2t_bb($skill[throw latte on opponent])
			.c2t_bbSubmit();
			return;

		//faxes -- saber use is elsewhere
		case $monster[ungulith]:
		case $monster[factory worker (female)]:
		case $monster[factory worker (male)]://just in case this shows up
			mSteal
			.c2t_bb($skill[meteor shower])
			.c2t_bbSubmit(true);
			return;

		case $monster[evil olive]:
			//have to burn a free kill and nostalgia/envy if no god lobster
			if (!have_familiar($familiar[god lobster])
				&& get_property("lastCopyableMonster").to_monster() == $monster[party girl])
			{
				mSteal
				.c2t_bb($skill[feel nostalgic])
				.c2t_bb($skill[feel envy])
				.c2t_hccs_bbLimited($skill[chest x-ray])
				.c2t_hccs_bbLimited($skill[shattering punch])
				.c2t_hccs_bbLimited($skill[gingerbread mob hit])
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
		case $monster[party girl]:
			//moxie without ghosts; still want to grab potion before leveling
			if (my_primestat() == $stat[moxie]
				&& get_property("lastCopyableMonster").to_monster() == $monster[possessed can of tomatoes])
			{
				mSteal
				.c2t_bb($skill[gulp latte])
				.c2t_bb($skill[offer latte to opponent])
				.c2t_hccs_portscan()
				.c2t_bb($skill[throw latte on opponent])
				.c2t_bbSubmit();
				return;
			}
		case $monster[biker]:
		case $monster[burnout]:
		case $monster[jock]:
		case $monster["plain" girl]:
			m = mHead + mSteal;
			if (have_equipped($item[backup camera])
				&& c2t_hccs_backupCameraLeft() > 0)
			{
				m += c2t_bb($skill[back-up to your last enemy]).c2t_bb("twiddle;");
				m.c2t_bbSubmit(true);
				return;
			}
			//feel pride still thinks it can be used after max uses for some reason
			m += c2t_hccs_bbLimited($skill[feel pride]);
			//circadiun rhythms
			m += c2t_hccs_bbLimited($skill[recall facts: %phylum circadian rhythms]);

			//free kills after NEP free fights
			if (get_property('_neverendingPartyFreeTurns').to_int() == 10
				&& c2t_hccs_freeKillsLeft() > 0)
			{
				m
				.c2t_bb($skill[sing along])
				.c2t_hccs_bowlSideways()
				//free kill skills
				.c2t_bb($skill[darts: aim for the bullseye])
				//won't use otoscope anywhere else, so might as well use it while doc bag equipped
				.c2t_hccs_bbLimited($skill[otoscope])
				.c2t_hccs_bbLimited($skill[chest x-ray])
				.c2t_hccs_bbLimited($skill[shattering punch])
				.c2t_hccs_bbLimited($skill[gingerbread mob hit])
				.c2t_bb($skill[spit jurassic acid])
				.c2t_bbSubmit();
			}
			else if (c2t_hccs_asdonKillLeft()
				&& get_fuel() >= 100)
			{
				m
				.c2t_bb($skill[sing along])
				.c2t_hccs_bbLimited($skill[asdon martin: missile launcher])
				.c2t_bbSubmit();
			}
			//free combats at NEP
			else
				c2t_bbSubmit(m + mBasic);

			return;

		//most basic of combats
		//mushroom garden
		case $monster[piranha plant]:
		//voters
		case $monster[government bureaucrat]:
		case $monster[terrible mutant]:
		case $monster[angry ghost]:
		case $monster[annoyed snake]:
		case $monster[slime blob]:
			c2t_bbSubmit(mHead + mSteal + mBasic);
			return;

		//portscan
		case $monster[government agent]:
			if (my_location() != $location[an unusually quiet barroom brawl])
				abort("Portscan logic failed. Either banish or free kill the government agent, then run the script again. Also, report this.");
			mHead
			.c2t_bb($skill[disarming thrust])
			.c2t_bb($skill[micrometeorite])
			.c2t_bb($skill[curse of weaksauce])
			.c2t_bb($skill[detect weakness])
			.c2t_hccs_portscan()
			.c2t_bb(mBasicBot)
			.c2t_bbSubmit();
			return;

		//shadow rift
		case $monster[shadow bat]:
		case $monster[shadow cow]:
		case $monster[shadow devil]:
		case $monster[shadow guy]:
		case $monster[shadow hexagon]:
		case $monster[shadow orb]:
		case $monster[shadow prism]:
		case $monster[shadow stalk]:
		case $monster[shadow slab]:
		case $monster[shadow snake]:
		case $monster[shadow spider]:
		case $monster[shadow tree]:
			if (have_effect($effect[shadow affinity]) == 0)
				abort("Error: entered non-free combat in shadow rift without shadow affinity");
			mSteal
			.c2t_bbIf("sauceror",c2t_bb($skill[curse of weaksauce]))
			.c2t_hccs_bbLimited($skill[recall facts: %phylum circadian rhythms])
			.c2t_bb($skill[darts: throw at %part1])
			.c2t_bbIf(`!hasskill {$skill[silent treatment].id}`,
				c2t_bb($skill[stuffed mortar shell])
				.c2t_bb($skill[sing along]))
			.c2t_bbIf(`hasskill {$skill[silent treatment].id}`,
				c2t_bb(`skill {$skill[silent treatment].id};`)
				.c2t_bb($skill[stuffed mortar shell])
				.c2t_bb($skill[sing along])
				.c2t_bb("attack;attack;"))
			.c2t_bb(5,$skill[saucegeyser])
			.c2t_bb("abort;")
			.c2t_bbSubmit();
			return;

		//shadow rift bosses
		case $monster[shadow cauldron]:
		case $monster[shadow matrix]:
		case $monster[shadow tongue]:
			c2t_bbIf("sauceror",c2t_bb($skill[curse of weaksauce]))
			.c2t_bb($skill[stuffed mortar shell])
			.c2t_bb($skill[sing along])
			.c2t_bb(5,$skill[saucegeyser])
			.c2t_bb("abort;")
			.c2t_bbSubmit();
			return;

		case $monster[shadow orrery]:
			c2t_bb($skill[curse of weaksauce])
			.c2t_bb($skill[sing along])
			.c2t_bb(5,$skill[northern explosion])
			.c2t_bbWhile("!pastround 20","attack;")
			.c2t_bb("abort;")
			.c2t_bbSubmit();
			return;

		case $monster[shadow scythe]:
		case $monster[shadow spire]:
			c2t_bbIf("sauceror",c2t_bb($skill[curse of weaksauce]))
			.c2t_bb(5,$skill[saucegeyser])
			.c2t_bb("abort;")
			.c2t_bbSubmit();
			return;

		//speakeasy
		case $monster[gangster's moll]:
		case $monster[gator-human hybrid]:
		case $monster[goblin flapper]:
		case $monster[traveling hobo]:
		case $monster[undercover prohibition agent]:
			m = mHead + mSteal + mBasicTop;
			m += c2t_hccs_portscan();
			m += mBasicBot;
			m.c2t_bbSubmit();
			return;

		//chain potential; basic otherwise
		case $monster[sausage goblin]:
			c2t_bbSubmit(mHead + mChain);
			return;

		//nostalgia goes here
		case $monster[god lobster]:
			m = mHead + mBasicTop;
			//nostalgia/envy for drops
			if (get_property("csServicesPerformed") == "Coil Wire"//so this doesn't try to fire in non-combat test
				&& (get_property("lastCopyableMonster").to_monster() == $monster[novelty tropical skeleton]
					|| get_property("lastCopyableMonster").to_monster() == $monster[possessed can of tomatoes]
					|| (get_property("lastCopyableMonster").to_monster() == $monster[party girl]
						&& my_primestat() == $stat[moxie]
						&& have_effect($effect[unrunnable face]) == 0
						&& item_amount($item[runproof mascara]) == 0)))
			{
				m += c2t_bb($skill[feel nostalgic]);
				m += c2t_bb($skill[feel envy]);
			}
			m += mBasicBot;
			m.c2t_bbSubmit();
			return;

		case $monster[eldritch tentacle]:
			c2t_bbSubmit(
				mHead + mSteal + mBasicTop
				.c2t_bb($skill[sing along])
				.c2t_bb($skill[darts: throw at %part1])
				.c2t_bbIf("sealclubber || turtletamer || discobandit || accordionthief",
					c2t_bbWhile("!pastround 20","attack;")
				)
				.c2t_bbIf("pastamancer || sauceror",
					c2t_bb(4,$skill[saucestorm])
				)
			);
			return;

		case $monster[sssshhsssblllrrggghsssssggggrrgglsssshhssslblgl]:
			c2t_bb($skill[darts: throw at %part1])
			.c2t_bb("attack;repeat;")
			.c2t_bbSubmit();
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
			m += c2t_hccs_bbLimited($skill[reflex hammer]);
			m += c2t_hccs_bbLimited($skill[kgb tranquilizer dart]);
			if (get_property("_snokebombUsed").to_int() <= get_property("_feelHatredUsed").to_int())
				m += c2t_hccs_bbLimited($skill[snokebomb]).c2t_hccs_bbLimited($skill[feel hatred]);
			else
				m += c2t_hccs_bbLimited($skill[feel hatred]).c2t_hccs_bbLimited($skill[snokebomb]);
			m.c2t_bbSubmit();
			//redo last; map the monsters is handled elsewhere since it doesn't like adv1()
			if (!get_property('mappingMonsters').to_boolean())
				c2t_freeAdv(loc);
			return;

		//this shouldn't happen
		default:
			abort("Currently in combat with something not accounted for in the combat script. Aborting.");
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
string c2t_hccs_bbLimited(skill ski) {
	return ski.dailylimit > 0 ? c2t_bb(ski) : "";
}
string c2t_hccs_bbLimited(string m,skill ski) {
	return m + c2t_hccs_bbLimited(ski);
}

//portscan logic
string c2t_hccs_portscan() {
	string out;
	if (get_property("ownsSpeakeasy").to_boolean()
		&& get_property("_speakeasyFreeFights").to_int() < 2
		&& !get_property("relayCounters").contains_text("portscan.edu")
		&& !get_property("c2t_hccs_disable.portscan").to_boolean())

		out = c2t_bb($skill[portscan]);

	return out;
}
string c2t_hccs_portscan(string m) {
	return m + c2t_hccs_portscan();
}

boolean[monster] c2t_hccs_holidayWanderers() {
	return $monsters[
		candied yam golem,
		malevolent tofurkey,
		possessed can of cranberry sauce,
		stuffing golem,
		novia cad&aacute;ver,
		novio cad&aacute;ver,
		padre cad&aacute;ver,
		persona inocente cad&aacute;ver,
		ambulatory pirate,
		migratory pirate,
		peripatetic pirate,
		];
}


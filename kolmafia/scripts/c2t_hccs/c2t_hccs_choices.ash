//c2t hccs choices
//c2t

import <c2t_hccs_lib.ash>

void main (int id,string page) {
	int testsDone = get_property("csServicesPerformed").split_string(",").count();
	location loc;
	string str = "";
	int num = 0;
	int[string] priority;
	int top,pick;

	switch (id) {
		default:
			return;

		//NEP start
		// 1: take quest
		// 2: decline quest
		// 6: leave
		case 1322:
			switch (get_property("_questPartyFairQuest")) {
				case "food":
				case "booze":
					run_choice(1);
					break;
				case "dj":
				case "trash":
				case "partiers":
				case "woots":
				default:
					run_choice(2);
					break;
			}
			break;

		//It Hasn't Ended, It's Just Paused
		//1: Head upstairs
		//2: Check out the kitchen
		//3: Go to the back yard
		//4: Investigate the basement
		//5: Pick a fight
		case 1324:
			//going for stat exp buff initially, then combats afterward
			if (my_primestat() == $stat[muscle] && have_effect($effect[spiced up]) == 0) {
				run_choice(2);
				run_choice(2);//1325/2
			}
			else if (my_primestat() == $stat[mysticality] && have_effect($effect[tomes of opportunity]) == 0) {
				run_choice(1);
				run_choice(2);//1326/2
			}
			else if (my_primestat() == $stat[moxie] && have_effect($effect[the best hair you've ever had]) == 0) {
				run_choice(4);
				run_choice(2);//1328/2
			}
			else
				run_choice(5);
			break;

		//Is there A Doctor In The House? / doc bag
		//1: Accept the case
		//2: Decline the case
		//3: Turn off the phone for the rest of the day
		case 1340:
			run_choice(1);
			break;

		//Using the Force
		//1: saber banish
		//2: saber copy
		//3: saber yr
		case 1387:
			if (available_choice_options() contains 3)
				run_choice(3);
			else
				run_choice(1);
			break;

		//Granted a Boon / God Lobster
		//the following is only true if crown not equipped:
		//1: equipment
		//2: buff
		//3: stats
		case 1310:
			//assuming any post-leveling fight of glob is for a buff
			if (testsDone > 1)
				run_choice(2);
			else
				run_choice(1);
			break;

		//===================
		// june cleaver
		//===================
		/*
		Encounter: Poetic Justice
		1: mox stat
		2: mys stat
		3: +5 adv & beaten up
		*/
		case 1467:
			run_choice(3);//+5 adv
			cli_execute("rest free");
			break;
		/*
		Aunts not Ants
		1: mox stat
		2: mus stat
		3: ashamed effect
		*/
		case 1468:
			if (testsDone < 2 && my_primestat() == $stat[moxie])
				run_choice(1);//mox stat
			else if (testsDone < 2 && my_primestat() == $stat[muscle])
				run_choice(2);//mus stat
			else if (available_choice_options() contains 4)
				run_choice(4);
			else
				run_choice(2);
			break;
		/*
		Beware of Aligator
		1: 20 ML
		2: booze
		3: 1500 meat
		*/
		case 1469:
			if (testsDone < 2)
				run_choice(1);//20 ML
			else if (available_choice_options() contains 4)
				run_choice(4);
			else
				run_choice(2);//booze
			break;
		/*
		Teacher's Pet
		1: teacher's pet effect
		2: teacher's pen
		3: mus stat
		*/
		case 1470:
			if (testsDone < 2 && my_primestat() == $stat[muscle])
				run_choice(3);//mus stat
			else if (available_choice_options() contains 4)
				run_choice(4);
			else
				run_choice(2);//teacher's pen
			break;
		/*
		Lost and Found
		1: meat potion
		2: mus stat, 250 meat, beaten up
		3: mys stat
		*/
		case 1471:
			if (testsDone < 2 && my_primestat() == $stat[muscle]) {
				run_choice(2);//mus stat
				cli_execute("rest free");
			}
			else if (testsDone < 2 && my_primestat() == $stat[mysticality])
				run_choice(3);//mys stat
			else if (available_choice_options() contains 4)
				run_choice(4);
			else
				run_choice(1);//meat potion
			break;
		/*
		Summer Days
		1: nc potion
		2: food
		3: mox stat
		*/
		case 1472:
			run_choice(1);//nc potion
			break;
		/*
		Bath Time
		1: mus stat; gob of wet hair
		2: wholesome resolved effect
		3: kinda damp effect
		*/
		case 1473:
			if (testsDone < 2 && my_primestat() == $stat[muscle])
				run_choice(1);//mus stat
			else if (!get_property("csServicesPerformed").contains_text("Clean Steam Tunnels"))
				run_choice(3);//hot resist
			else if (available_choice_options() contains 4)
				run_choice(4);
			else
				run_choice(1);//mus stat
			break;
		/*
		Delicious Sprouts
		1: mys stat
		2: food
		3: mus stat
		*/
		case 1474:
			if (testsDone < 2 && my_primestat() == $stat[muscle])
				run_choice(3);//mus stat
			else if (testsDone < 2 && my_primestat() == $stat[mysticality])
				run_choice(1);//mys stat
			else if (available_choice_options() contains 4)
				run_choice(4);
			else
				run_choice(2);//food
			break;
		/*
		Hypnotic Master
		1: mom's necklace
		2: mus stat
		3: 2 random effects
		*/
		case 1475:
			if (testsDone < 2 && my_primestat() == $stat[muscle])
				run_choice(2);//mus stat
			else
				run_choice(1);//mom's necklace
			break;

		//autumn-aton
		case 1483:
			//upgrade
			if (available_choice_options() contains 1) {
				print(`Autumn-aton: {available_choice_options()[1]}`);
				run_choice(1);
			}

			//find where to go based on upgrade priority
			str = get_property("autumnatonUpgrades");
			if (!get_property("c2t_hccs_disable.autumnatonItem").to_boolean()
				&& !str.contains_text("base_blackhat"))//item potion
			{
				loc = $location[the sleazy back alley];
			}
			else if (!str.contains_text("rightleg1"))//-11 turns
				loc = $location[the neverending party];
			else if (!str.contains_text("leftleg1"))//-11 turns
				loc = $location[noob cave];
			else if (!str.contains_text("leftarm1"))//+1 item from zone
				loc = $location[the haunted pantry];
			else//no easy/good upgrade areas open
				loc = $location[thugnderdome];

			foreach i,x in get_autumnaton_locations() if (x == loc) {
				num = x.id;
				break;
			}
			if (num == 0) {
				print("Autumn-aton: couldn't go where it wanted");
				run_choice(3);
			}
			else if (!run_choice(2,`heythereprogrammer={num}`).contains_text("Good luck, little buddy!")) {
				run_choice(3);
				c2t_hccs_printWarn("Autumn-aton: failed to go to a place that was available");
			}
			break;

		//SIT
		case 1494:
			run_choice(2);
			break;

		//calling rufus
		//1:entity
		//2:artifact
		//3:items
		//6:leave
		case 1497:
			if (get_property("_shadowAffinityToday").to_boolean()) {
				c2t_hccs_printWarn("Tried to start another Rufus quest");
				run_choice(6);
			}
			else if (get_property("rufusDesiredEntity").contains_text("shadow orrery")) {
				if (have_skill($skill[northern explosion]))
					run_choice(1);
				else
					run_choice(2);
			}
			else
				run_choice(1);
			break;

		//calling rufus back
		case 1498:
			if (available_choice_options() contains 1)
				run_choice(1);
			else {
				run_choice(6);
				c2t_hccs_printWarn("Tried to turn in Rufus quest, but it wasn't done?");
			}
			break;

		//labyrinth of shadows
		case 1499:
			str = get_property("rufusQuestTarget");
			if (str == "" || get_property("questRufus") == "step1")
				str = "Shadow's Chill";
			if (get_property("questRufus") == "step1")
				c2t_hccs_printWarn("The last Rufus quest can be turned in already, so can't find another artifact");

			for tries from 1 to 11 {
				for i from 2 to 4 if (available_choice_options(true)[i].contains_text(str))
					run_choice(i);
				if (!handling_choice())
					break;
				run_choice(1);
			}
			break;

		//like a loded stone
		//1:forge
		//2:shadow waters buff
		//3:items
		case 1500:
			run_choice(2);
			break;

		//dart perks
		case 1525:
			priority = {
				"Throw a second dart quickly":60,
				"Deal 25-50% more damage":800,
				"You are less impressed by bullseyes":11,
				"25% Better bullseye targeting":22,
				"Extra stats from stats targets":41,
				"Butt awareness":30,
				"Add Hot Damage":1000,
				"Add Cold Damage":1000,
				"Add Sleaze Damage":1000,
				"Add Spooky Damage":1000,
				"Add Stench Damage":1000,
				"Expand your dart capacity by 1":50,
				"Bullseyes do not impress you much":10,
				"25% More Accurate bullseye targeting":21,
				"Deal 25-50% extra damage":10000,
				"Increase Dart Deleveling from deleveling targets":100,
				"Deal 25-50% greater damage":10000,
				"Extra stats from stats targets":40,
				"25% better chance to hit bullseyes":20,
				};
			top = 999999999;
			pick = 1;

			foreach i,x in available_choice_options() {
				if (priority[x] == 0) {
					print(`dart perk "{x}" not in priority list`,"red");
					continue;
				}
				if (priority[x] < top) {
					top = priority[x];
					pick = i;
				}
			}
			run_choice(pick);
			break;
	}
}

//c2t hccs choices
//c2t


void main (int id,string page) {
	int testsDone = get_property("csServicesPerformed").split_string(",").count();

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
					if (get_property("kingLiberated").to_boolean()) {
						run_choice(1);
						break;
					}
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
			run_choice(3);
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
			cli_execute("rest free");//not sure sequencing of these NCs
			break;
		/*
		Aunts not Ants
		1: mox stat
		2: mus stat
		3: ashamed effect
		*/
		case 1468:
			if (my_primestat() == $stat[moxie])
				run_choice(1);//mox stat
			else
				run_choice(2);//mus stat
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
			if (testsDone < 2)
				run_choice(3);//mus stat
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
			if (testsDone < 2) {
				if (my_primestat() == $stat[muscle]) {
					run_choice(2);//mus stat
					cli_execute("rest free");
				}
				else
					run_choice(3);//mys stat
			}
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
			if (get_property("csServicesPerformed").contains_text("Clean Steam Tunnels"))
				run_choice(1);//gob of wet hair
			else
				run_choice(3);//hot resist
			break;
		/*
		Delicious Sprouts
		1: mys stat
		2: food
		3: mus stat
		*/
		case 1474:
			if (testsDone < 2) {
				if (my_primestat() == $stat[muscle])
					run_choice(3);
				else
					run_choice(1);
			}
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
	}
}

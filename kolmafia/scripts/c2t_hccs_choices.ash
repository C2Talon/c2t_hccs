//c2t hccs choices
//c2t

void main (int id,string page) {
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
			if (my_primestat() == $stat[muscle] && have_effect($effect[Spiced Up]) == 0) {
				run_choice(2);
				run_choice(2);//1325/2
			}
			else if (my_primestat() == $stat[mysticality] && have_effect($effect[Tomes of Opportunity]) == 0) {
				run_choice(1);
				run_choice(2);//1326/2
			}
			else if (my_primestat() == $stat[moxie] && have_effect($effect[The Best Hair You've Ever Had]) == 0) {
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
			if (get_property("csServicesPerformed").split_string(",").count() > 1)
				run_choice(2);
			else
				run_choice(1);
			break;
	}
}

//c2t hccs resources
//c2t

//resources; mostly of the IotM variety; mostly limited to what I use

import <c2t_lib.ash>


/*-=-+-=-+-=-+-=-+-=-+-=-
  function declarations
  -=-+-=-+-=-+-=-+-=-+-=-*/
//d--genie
//d--pantogram
//d--peppermint garden
//d--pillkeeper
//d--pizza cube
//d--power plant
//d--vote


//d--genie
//gets effect from genie if not already have; returns true if have effect
boolean c2t_hccs_genie(effect eff);

//fights monster from genie; returns true if monster fought
boolean c2t_hccs_genie(monster mon);


//d--pantogram
//makes pantogram pants with stats of mainstat,hot res,mp,spell,-combat
void c2t_hccs_pantogram();

//makes pantogram pants, where type can be either "spell" or "weapon"
void c2t_hccs_pantogram(string type);


//d--peppermint garden
//returns true if garden is peppermint
boolean c2t_hccs_peppermintGarden();


//d--pillkeeper
//returns whether pillkeeper is available or not
boolean c2t_hccs_pillkeeper();

//gets pillkeeper effect
//returns true if have the effect when done
boolean c2t_hccs_pillkeeper(effect eff);


//d--pizza cube
//returns whether the diabolic pizza cube is in the workshed or not
boolean c2t_hccs_pizzaCube();

//make and eat a pre-determined diabolic pizza based on the effect desired
//returns whether the correct effect was gained or not
boolean c2t_hccs_pizzaCube(effect eff);

//make and eat a diabolic pizza based on ingredients provided
//returns whether a pizza was eaten or not
boolean c2t_hccs_pizzaCube(item it1,item it2,item it3,item it4);


//d--power plant
//returns whether power plant is available or not
boolean c2t_hccs_powerPlant();

//harvests power plant if `harvest` is true
boolean c2t_hccs_powerPlant(boolean harvest);


//d--vote
//votes in voting booth
void c2t_hccs_vote();


/*-=-+-=-+-=-+-=-+-=-+-=-
  function implementations
  -=-+-=-+-=-+-=-+-=-+-=-*/
//i--genie
//i--pantogram
//i--peppermint garden
//i--pillkeeper
//i--pizza cube
//i--power plant
//i--vote


//i--genie
boolean c2t_hccs_genie(effect eff) {
	if (have_effect(eff).to_boolean())
		return true;
	if (get_property("_genieWishesUsed").to_int() >= 3 && available_amount($item[pocket wish]) == 0)
		return false;

	cli_execute(`genie effect {eff}`);

	return have_effect(eff).to_boolean();
}
boolean c2t_hccs_genie(monster mon) {
	if (!c2t_wishFight(mon))
		return false;
	run_turn();
	//if (choice_follows_fight()) //saber force breaks this I think?
		run_choice(-1);//just in case

	if (get_property("lastEncounter") != mon && get_property("lastEncounter") != "Using the Force")
		return false;
	return true;
}

//i--pantogram
void c2t_hccs_pantogram() c2t_hccs_pantogram("spell");
void c2t_hccs_pantogram(string type) {
	int test = type == "weapon"?0:0;//TODO actually implement this
	if (item_amount($item[portable pantogram]) > 0 && available_amount($item[pantogram pants]) == 0) {
		//use item
		visit_url("inv_use.php?which=3&whichitem=9573&pwd="+my_hash(),false,true);

		int temp;
		switch (my_primestat()) {
			case $stat[muscle]:
				temp = 1;
				break;
			case $stat[mysticality]:
				temp = 2;
				break;
			case $stat[moxie]:
				temp = 3;
				break;
			default:
				abort("broken stat?");
		}

		//primestat,hot res,+mp,+spell,-combat
		visit_url("choice.php?pwd&whichchoice=1270&option=1&e=1&s1=-2,0&s2=-2,0&s3=-1,0&m="+temp,true,true);
		cli_execute("refresh all");//mafia doesn't know the pants exist until this
	}
}

//i--peppermint garden
boolean c2t_hccs_peppermintGarden() return get_campground() contains $item[peppermint pip packet];

//i--pillkeeper
boolean c2t_hccs_pillkeeper() return available_amount($item[eight days a week pill keeper]).to_boolean();
boolean c2t_hccs_pillkeeper(effect eff) {
	if (have_effect(eff).to_boolean())
		return true;
	if (!c2t_hccs_pillkeeper())
		return false;

	switch (eff) {
		default:
			return false;
		case $effect[Rainbowolin]:
			cli_execute("pillkeeper elemental");
			break;
		case $effect[Hulkien]:
			cli_execute("pillkeeper stats");
			break;
		case $effect[Fidoxene]:
			cli_execute("pillkeeper familiar");
			break;
		case $effect[Lucky!]:
			cli_execute("pillkeeper semirare");
			break;
	}

	return have_effect(eff).to_boolean();
}

//i--pizza cube
boolean c2t_hccs_pizzaCube() return get_campground() contains $item[diabolic pizza cube];
boolean c2t_hccs_pizzaCube(effect eff) {
	if (available_amount($item[diabolic pizza]).to_boolean()) {
		print("pizza found while trying to make one, so eating it","red");
		eat($item[diabolic pizza]);
	}
	if (have_effect(eff).to_boolean())
		return true;
	if (!c2t_hccs_pizzaCube())
		return false;
	if (my_fullness() + 3 > fullness_limit()) {
		print("no organs space for a pizza","red");
		return false;
	}

	familiar fam = my_familiar();
	item it1,it2,it3,it4;
	item [int] choose;

	if (!available_amount($item[diabolic pizza]).to_boolean())
	switch (eff) {
		default:
			return false;

		case $effect[hgh-charged]:
			use_familiar($familiar[exotic parrot]);
			retrieve_item(1,$item[hot buttered roll]);
			it1 = c2t_priority($item[hot buttered roll],$item[hollandaise helmet],$item[helmet turtle]);
			it2 = c2t_priority($item[gnollish autoplunger],$item[green seashell],$item[grain of sand]);
			it3 = c2t_priority($item[blood-faced volleyball],$item[cog and sprocket assembly]);
			it4 = $item[cog and sprocket assembly];
			break;

		case $effect[different way of seeing things]:
			use_familiar($familiar[imitation crab]);
			retrieve_item(1,$item[full meat tank]);
			it1 = $item[dry noodles];
			it2 = $item[imitation whetstone];
			it3 = $item[full meat tank];
			it4 = $item[cog and sprocket assembly];
			break;

		case $effect[knightlife]:
			use_familiar($familiar[imitation crab]);
			retrieve_item(1,$item[ketchup]);
			it1 = $item[ketchup];
			it2 = $item[Newbiesport&trade; tent];
			it3 = $item[imitation whetstone];
			it4 = $item[cog and sprocket assembly];
			break;

		case $effect[certainty]:
			c2t_assert(available_amount($item[electronics kit]).to_boolean(),"missing electronics kit for CER pizza");
			it1 = $item[cog and sprocket assembly];
			it2 = $item[electronics kit];
			it3 = $item[razor-sharp can lid];
			it4 = c2t_priority($item[Middle of the Road&trade; brand whiskey],$item[PB&J with the crusts cut off],$item[surprisingly capacious handbag]);
			break;

		case $effect[infernal thirst]:
			use_familiar($familiar[exotic parrot]);
			retrieve_item(1,$item[full meat tank]);

			if (item_amount($item[eldritch effluvium]) == 0
				&& item_amount($item[eaves droppers]) == 0
				&& (available_amount($item[cracker]) == 0 || item_amount($item[electronics kit]) == 0))

				retrieve_item(1,$item[eyedrops of the ermine]);

			it1 = $item[imitation whetstone];
			it2 = c2t_priority($item[neverending wallet chain], $item[Newbiesport&trade; tent]);
			it3 = $item[full meat tank];
			it4 = c2t_priority($item[eldritch effluvium],$item[eaves droppers],$item[eyedrops of the ermine],$item[electronics kit]);
			break;

		case $effect[outer wolf&trade;]:
			choose = {$item[Middle of the Road&trade; brand whiskey],$item[surprisingly capacious handbag],$item[PB&J with the crusts cut off]};
			retrieve_item(1,$item[ointment of the occult]);
			if (item_amount($item[useless powder]) == 0) {
				retrieve_item(1,$item[cool whip]);
				cli_execute("smash 1 cool whip");
			}
			it1 = c2t_priority($item[ointment of the occult],$item[out-of-tune biwa]);
			it2 = c2t_priority($item[useless powder],$item[unremarkable duffel bag]);
			it3 = c2t_priority(choose);

			if (item_amount(it3) > 1)
				it4 = it3;
			else {
				foreach i,x in choose if (it3 == x) {
					remove choose[i];
					break;
				}
				it4 = c2t_priority(choose);
			}
			break;
	}

	c2t_hccs_pizzaCube(it1,it2,it3,it4);
	use_familiar(fam);
	return have_effect(eff).to_boolean();
}
boolean c2t_hccs_pizzaCube(item it1,item it2,item it3,item it4) {
	if (!c2t_hccs_pizzaCube())
		return false;
	if (my_fullness() + 3 > fullness_limit()) {
		print("no organ space for a pizza","red");
		return false;
	}
	if (available_amount($item[diabolic pizza]).to_boolean()) {
		print("pizza found while trying to make one, so eating that instead","red");
		eat($item[diabolic pizza]);
		return true;
	}
	if (available_amount(it1) == 0 || available_amount(it2) == 0 || available_amount(it3) == 0 || available_amount(it4) == 0) {
		print("missing ingredients for pizza","red");
		return false;
	}

	try
		visit_url(`campground.php?action=makepizza&pizza={it1.to_int()},{it2.to_int()},{it3.to_int()},{it4.to_int()}`,true,true);
	finally
		if (available_amount($item[diabolic pizza]) == 0) {
			cli_execute("refresh inventory");
			abort("pizza creation failed? check inventory and effects");
		}

	eat($item[diabolic pizza]);
	return true;
}

//i--power plant
boolean c2t_hccs_powerPlant() {
	if (item_amount($item[potted power plant]) == 0)
		return false;
	if (get_property("_pottedPowerPlant") != "0,0,0,0,0,0,0") {
		buffer buf = visit_url(`inv_use.php?pwd={my_hash()}&which=3&whichitem=10738`);
		if (buf.contains_text('name="whichchoice" value="1448"')) {
			matcher match = create_matcher('<button\\s+type="submit"\\s+name="pp"\\s+value="(\\d)"',buf);
			while (match.find())
				visit_url(`choice.php?pwd&whichchoice=1448&option=1&pp={match.group(1)}`,true,true);
		}
	}
	return true;
}

//i--vote
void c2t_hccs_vote() {
	if (!get_property("voteAlways").to_boolean() && !get_property("_voteToday").to_boolean())
		return;
	if (available_amount($item[&quot;I Voted!&quot; sticker]) > 0)
		return;
	if (my_daycount() > 1)
		abort("Need to manually vote. This is not set up to vote except for day 1.");

	buffer buf = visit_url('place.php?whichplace=town_right&action=townright_vote');

	//monster priority
	boolean [monster] monp = $monsters[angry ghost,government bureaucrat,terrible mutant,slime blob,annoyed snake];
	monster mon1 = get_property('_voteMonster1').to_monster();
	monster mon2 = get_property('_voteMonster2').to_monster();

	//for output
	int radi,che1,che2;

	//select monster
	foreach mon in monp {
		//randomise if it's a choice between the last 2
		if (mon == $monster[slime blob]) {
			radi = random(2)+1;
			break;
		}
		else if (mon1 == mon) {
			radi = 1;
			break;
		}
		else if (mon2 == mon) {
			radi = 2;
			break;
		}
	}

	//votes by class, from 0 to 3
	switch (my_class()) {
		default:
			abort("Unrecognized class for voting?");
		case $class[seal clubber]:
			//3 spooky res,10 stench damage,2 fam exp,-2 adventures
			che1 = 1;//10 stench damage
			che2 = 2;//2 familiar exp
			break;
		case $class[turtle tamer]:
			//100% weapon damage,10 ML,unrecorded unarmed damage,-20 moxie
			che1 = 0;//100% weapon damage
			che2 = 1;//10 ML
			break;
		case $class[pastamancer]:
			//30% gear drop,-10% crit,100% weapon damage,2 fam exp
			che1 = 2;//100% weapon damage
			che2 = 3;//2 fam exp
			break;
		case $class[sauceror]:
			//-10 ML,3 exp,-20 mys,3 spooky res
			che1 = 1;//3 exp
			che2 = 3;//3 spooky res
			break;
		case $class[disco bandit]:
			//30% max mp,10 hot damage,30% food drop,-20 item drop
			che1 = 0;//30% max mp
			che2 = 1;//10 hot damage
			break;
		case $class[accordion thief]:
			//3 stench res,-20 mysticality,30% booze drop,25% initiative
			che1 = 2;//30% booze drop
			che2 = 3;//25% initative
			break;
	}

	print("Voting for "+(radi==1?mon1:mon2)+", "+get_property('_voteLocal'+(che1+1))+", "+get_property('_voteLocal'+(che2+1)),"blue");
	buf = visit_url('choice.php?pwd&option=1&whichchoice=1331&g='+radi+'&local[]='+che1+'&local[]='+che2,true,false);

	if (available_amount($item[&quot;I Voted!&quot; sticker]) == 0)
		abort("Voting failed?");
}


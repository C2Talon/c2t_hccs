//c2t hccs resources
//c2t

//resources; mostly of the IotM variety; mostly limited to what I use and limited to the scope of CS

import <c2t_lib.ash>
import <c2t_hccs_lib.ash>
import <c2t_reminisce.ash>
import <c2t_hccs_preAdv.ash>


//some of these resources can be "disabled" via a property. check c2t_hccs_properties.ash at the bottom under "disable resources" for a full list


/*-=-+-=-+-=-+-=-+-=-+-=-
  function declarations
  -=-+-=-+-=-+-=-+-=-+-=-*/
//d--backup camera
//d--briefcase
//d--cartography
//d--clover item
//d--cold medicine cabinet
//d--combat lover's locket
//d--garden peppermint
//d--genie
//d--melodramedary
//d--model train set
//d--numberology
//d--pantogram
//d--pillkeeper
//d--pizza cube
//d--power plant
//d--shorter-order cook
//d--sweet synthesis
//d--tome clip art
//d--tome sugar
//d--unbreakable umbrella
//d--vip floundry
//d--vote


//d--backup camera
//returns true if have backup camera
boolean c2t_hccs_backupCamera();

//returns number of uses left
int c2t_hccs_backupCameraLeft();


//d--briefcase
//returns true if have the briefcase
boolean c2t_hccs_briefcase();

//passes `arg` to Ezandora's briefcase script needing only the core of what is needed, e.g. "hot", "-combat", etc., limited in scope to what is relevant to CS
//returns true if have the briefcase
boolean c2t_hccs_briefcase(string arg);


//d--clover item
//used to get the lucky adventure from limerick dungeon or not
boolean c2t_hccs_cloverItem();


//d--cold medicine cabinet
//returns true if the cabinet is in the workshed
boolean c2t_hccs_coldMedicineCabinet();

//interfaces with cold medicine cabinet; only gets a drink via "drink" for now
boolean c2t_hccs_coldMedicineCabinet(string arg);


//d--combat lover's locket
//returns `true` if have the locket
boolean c2t_hccs_combatLoversLocket();

//fight `mon` from locket
//returns `true` if `mon` was fought
boolean c2t_hccs_combatLoversLocket(monster mon);


//d--garden peppermint
//returns true if garden is peppermint
boolean c2t_hccs_gardenPeppermint();


//d--genie
//gets effect from genie if not already have; returns true if have effect
boolean c2t_hccs_genie(effect eff);

//fights monster from genie; returns true if monster fought
boolean c2t_hccs_genie(monster mon);


//d--melodramedary
//returns true if have melodramedary
boolean c2t_hccs_melodramedary();

//returns spit charge
int c2t_hccs_melodramedarySpit();


//d--model train set
//returns true if have the model train set installed in workshed
boolean c2t_hccs_haveModelTrainSet();

//sets up model train set
void c2t_hccs_modelTrainSet();


//d--numberology
//returns true if have at least 1 level of numberology
boolean c2t_hccs_haveNumberology();

//uses numberology to get adventures
//returns true if successful
boolean c2t_hccs_useNumberology();


//d--cartography
//returns true if have the map the monsters skill
boolean c2t_hccs_haveCartography();

//returns true if monster fought
boolean c2t_hccs_cartography(location loc,monster mon);


//d--pantogram
//makes pantogram pants with stats of mainstat,hot res,mp,spell,-combat
void c2t_hccs_pantogram();

//makes pantogram pants, where type can be either "spell" or "weapon"
void c2t_hccs_pantogram(string type);


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
//returns whether power plant is available or not & harvests if it is
boolean c2t_hccs_powerPlant();


//d--shorter-order cook
//returns true if have short-order cook
boolean c2t_hccs_shorterOrderCook();


//d--sweet synthesis
//returns true if have the skill
boolean c2t_hccs_sweetSynthesis();

//tries to get a synthesis effect with a pre-determined configuration
//returns true if the effect obtained
boolean c2t_hccs_sweetSynthesis(effect eff);


//d--tome clip art
//returns true if have the skill
boolean c2t_hccs_tomeClipArt();

//returns true if item obtained
boolean c2t_hccs_tomeClipArt(item it);


//d--tome sugar
//returns true if have the skill
boolean c2t_hccs_tomeSugar();

//returns true if item obtained
boolean c2t_hccs_tomeSugar(item it);

//d--unbreakable umbrella
//returns true if have umbrella
boolean c2t_hccs_unbreakableUmbrella();

//returns true if all steps to change mode done
boolean c2t_hccs_unbreakableUmbrella(string mode);


//d--vip floundry
//returns true if current clan has floundry
boolean c2t_hccs_vipFloundry();


//d--vote
//votes in voting booth
void c2t_hccs_vote();


/*-=-+-=-+-=-+-=-+-=-+-=-
  function implementations
  -=-+-=-+-=-+-=-+-=-+-=-*/
//i--backup camera
//i--briefcase
//i--cartography
//i--clover item
//i--cold medicine cabinet
//i--combat lover's locket
//i--garden peppermint
//i--genie
//i--numberology
//i--melodramedary
//i--model train set
//i--pantogram
//i--pillkeeper
//i--pizza cube
//i--power plant
//i--shorter-order cook
//i--sweet synthesis
//i--tome clip art
//i--tome sugar
//i--unbreakable umbrella
//i--vip floundry
//i--vote


//i--backup camera
boolean c2t_hccs_backupCamera() {
	return available_amount($item[backup camera]) > 0
		&& !get_property("c2t_hccs_disable.backupCamera").to_boolean();
}
int c2t_hccs_backupCameraLeft() {
	if (!c2t_hccs_backupCamera())
		return 0;
	return 11-get_property('_backUpUses').to_int();
}


//i--briefcase
boolean c2t_hccs_briefcase() {
	return available_amount($item[kremlin's greatest briefcase]) > 0
		&& !get_property("c2t_hccs_disable.briefcase").to_boolean();
}
boolean c2t_hccs_briefcase(string arg) {
	if (!c2t_hccs_briefcase())
		return false;

	switch (arg.to_lower_case()) {
		default://user error
			abort(`"{arg}" is not valid for the briefcase`);
		case "-combat":
		case "hot":
		case "weapon":
		case "spell":
			cli_execute(`Briefcase e {arg.to_lower_case()}`);
	}
	return true;
}

//i--cartography
boolean c2t_hccs_haveCartography() {
	return have_skill($skill[map the monsters]);
}
boolean c2t_hccs_cartography(location loc,monster mon) {
	if (!c2t_hccs_haveCartography())
		return false;

	//use skill if needed
	if (!get_property('mappingMonsters').to_boolean()) {
		if (get_property('_monstersMapped').to_int() < 3)
			use_skill(1,$skill[map the monsters]);
		else
			return false;
	}

	int start = turns_played();

	repeat {
		visit_url(loc.to_url(),false,true);
		if (handling_choice() && last_choice() == 1435)
			run_choice(1,`heyscriptswhatsupwinkwink={mon.to_int()}`);
		run_turn();
	} until (turns_played() > start || !get_property('mappingMonsters').to_boolean());

	if (turns_played() > start)
		abort("map the monsters: something broke and a turn was used");

	return true;
}

//i--clover item
boolean c2t_hccs_cloverItem() {
	if (get_property("c2t_hccs_disable.cloverItem").to_boolean())
		return false;
	if (available_amount($item[cyclops eyedrops]) > 0)
		return true;
	if (have_effect($effect[one very clear eye]) > 0)
		return true;
	c2t_assert(my_adventures() > 0,"no adventures for limerick dungeon lucky adventure");

	//11-leaf clover
	if (have_effect($effect[lucky!]) == 0) {
		hermit(1,$item[11-leaf clover]);
		use($item[11-leaf clover]);
	}
	c2t_assert(have_effect($effect[lucky!]) > 0,"didn't get lucky effect for lucky adventure");

	cli_execute('mood apathetic');
	adv1($location[the limerick dungeon],-1,'');

	return item_amount($item[cyclops eyedrops]) > 0;
}

//i--cold medicine cabinet
boolean c2t_hccs_coldMedicineCabinet() {
	return get_workshed() == $item[cold medicine cabinet]
		&& !get_property("c2t_hccs_disable.coldMedicineCabinet").to_boolean();
}
boolean c2t_hccs_coldMedicineCabinet(string arg) {
	if (!c2t_hccs_coldMedicineCabinet())
		return false;
	//only want to get 1 thing at most from the cabinet; also to not break on re-entries
	if (get_property("_coldMedicineConsults").to_int() > 0)
		return false;
	if (arg.to_lower_case() != "drink")
		return false;

	maximize("100mainstat,mp",false);
	item itew;
	buffer bufw = visit_url("campground.php?action=workshed");
	switch (my_primestat()) {
		case $stat[muscle]:
			itew = $item[doc's fortifying wine];
			break;
		case $stat[mysticality]:
			itew = $item[doc's smartifying wine];
			break;
		case $stat[moxie]:
			itew = $item[doc's limbering wine];
			break;
	}
	if (!bufw.contains_text(itew))
		abort("cmc broke?");
	run_choice(3);

	//go back to full MP equipment
	maximize("mp,-equip kramco,-equip i voted",false);
	return true;
}

//i--combat lover's locket
boolean c2t_hccs_combatLoversLocket() {
	return available_amount($item[combat lover's locket]) > 0
		&& !get_property("c2t_hccs_disable.combatLoversLocket").to_boolean();
}
boolean c2t_hccs_combatLoversLocket(monster mon) {//mostly same as c2t_hccs_genie(mon)
	if (!c2t_hccs_combatLoversLocket())
		return false;
	c2t_hccs_preAdv();
	if (!c2t_reminisce(mon))
		return false;
	run_turn();
	//if (choice_follows_fight()) //saber force breaks this I think?
		run_choice(-1);//just in case

	if (get_property("lastEncounter") != mon && get_property("lastEncounter") != "Using the Force")
		return false;
	return true;
}

//i--genie
boolean c2t_hccs_genie(effect eff) {
	if (have_effect(eff) > 0)
		return true;
	if (get_property("_genieWishesUsed").to_int() >= 3 && available_amount($item[pocket wish]) == 0)
		return false;

	cli_execute(`genie effect {eff}`);

	return have_effect(eff) > 0;
}
boolean c2t_hccs_genie(monster mon) {
	c2t_hccs_preAdv();
	if (!c2t_wishFight(mon))
		return false;
	run_turn();
	//if (choice_follows_fight()) //saber force breaks this I think?
		run_choice(-1);//just in case

	if (get_property("lastEncounter") != mon && get_property("lastEncounter") != "Using the Force")
		return false;
	return true;
}

//i--numberology
boolean c2t_hccs_haveNumberology() {
	int max = get_property("skillLevel144").to_int();
	return max > 0;
}
boolean c2t_hccs_useNumberology() {
	if (!c2t_hccs_haveNumberology())
		return false;

	int max = min(3,get_property("skillLevel144").to_int());//max 3 uses in ronin and hardcore
	int used = get_property("_universeCalculated").to_int();
	int start = my_adventures();

	if (used >= max)
		return false;

	//burn uses on +3 adventures each
	for i from 1 to max-used
		cli_execute("numberology 69");

	return my_adventures() > start;
}

//i--melodramedary
boolean c2t_hccs_melodramedary() {
	return have_familiar($familiar[melodramedary])
		&& !get_property("c2t_hccs_disable.melodramedary").to_boolean();
}
int c2t_hccs_melodramedarySpit() {
	if (!c2t_hccs_melodramedary())
		return 0;
	return get_property('camelSpit').to_int();
}

//i--model train set
boolean c2t_hccs_haveModelTrainSet() return get_workshed() == $item[model train set];
void c2t_hccs_modelTrainSet() {
	if (!c2t_hccs_haveModelTrainSet())
		return;
	/* train set part reference
	1: meat
	2: mp regen
	3: all stats
	4: hot resist, cold damage
	5: stench resist, spooky damage
	6: wood, joiners, or stats (orc chasm bridge stuff); never good for CS
	7: candy
	8: double next stop
	9: cold resist, stench damage
	11: spooky resist, sleaze damage
	12: sleaze resist, hot damage
	13: monster level
	14: mox stats
	15: basic booze
	16: mys stats
	17: mus stats
	18: food drop buff
	19: copy last food drop
	20: ore
	*/

	int main,alt1,alt2;
	switch (my_primestat()) {
		default:abort("broke stat?");
		case $stat[muscle]:
			main = 17;//mus
			alt1 = 16;//mys
			alt2 = 14;//mox
			break;
		case $stat[mysticality]:
			main = 16;
			alt1 = 14;
			alt2 = 17;
			break;
		case $stat[moxie]:
			main = 14;
			alt1 = 16;
			alt2 = 17;
	}

	if (visit_url("campground.php?action=workshed",false,true).contains_text('value="Save Train Set Configuration"'))
		//meat,double,main,all stats,alt1,alt2,ML,hot resist
		visit_url(`choice.php?pwd&whichchoice=1485&option=1&slot[0]=1&slot[1]=8&slot[2]={main}&slot[3]=3&slot[4]={alt1}&slot[5]={alt2}&slot[6]=13&slot[7]=4`,true,true);

	//let mafia know we're not stuck in the choice
	visit_url("main.php");
}

//i--pantogram
void c2t_hccs_pantogram() c2t_hccs_pantogram("spell");
void c2t_hccs_pantogram(string type) {
	if (get_property("c2t_hccs_disable.pantogram").to_boolean())
		return;

	string mod = type.to_lower_case() == "weapon"?"-1,0":"-2,0";
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
		visit_url(`choice.php?pwd&whichchoice=1270&option=1&e=1&s1=-2,0&s2={mod}&s3=-1,0&m={temp}`,true,true);
		cli_execute("refresh all");//mafia doesn't know the pants exist until this
		visit_url("desc_item.php?whichitem=508365377",false,true);//attempted fix for very rare bug where all pants mods aren't recorded by mafia
	}
}

//i--garden peppermint
boolean c2t_hccs_gardenPeppermint() return get_campground() contains $item[peppermint pip packet];

//i--pillkeeper
boolean c2t_hccs_pillkeeper() {
	return available_amount($item[eight days a week pill keeper]) > 0
		&& !get_property("c2t_hccs_disable.pillkeeper").to_boolean();
}
boolean c2t_hccs_pillkeeper(effect eff) {
	if (have_effect(eff) > 0)
		return true;
	if (!c2t_hccs_pillkeeper())
		return false;

	switch (eff) {
		default:
			return false;
		case $effect[rainbowolin]:
			cli_execute("pillkeeper elemental");
			break;
		case $effect[hulkien]:
			cli_execute("pillkeeper stats");
			break;
		case $effect[fidoxene]:
			cli_execute("pillkeeper familiar");
			break;
		case $effect[lucky!]:
			cli_execute("pillkeeper semirare");
			break;
	}

	return have_effect(eff) > 0;
}

//i--pizza cube
boolean c2t_hccs_pizzaCube() {
	return get_workshed() == $item[diabolic pizza cube]
		&& !get_property("c2t_hccs_disable.pizzaCube").to_boolean();
}
boolean c2t_hccs_pizzaCube(effect eff) {
	if (available_amount($item[diabolic pizza]) > 0) {
		print("pizza found while trying to make one, so eating it","red");
		eat($item[diabolic pizza]);
	}
	if (have_effect(eff) > 0)
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

	if (available_amount($item[diabolic pizza]) == 0)
	switch (eff) {
		default:
			return false;

		case $effect[hgh-charged]:
			//TODO better familiar equipment handling
			use_familiar(c2t_priority($familiars[exotic parrot,mu,cornbeefadon]));
			retrieve_item(1,$item[hot buttered roll]);
			it1 = c2t_priority($item[hot buttered roll],$item[hollandaise helmet],$item[helmet turtle]);
			it2 = c2t_priority($item[gnollish autoplunger],$item[green seashell],$item[grain of sand]);
			it3 = c2t_priority($item[blood-faced volleyball],$item[cog and sprocket assembly]);
			it4 = $item[cog and sprocket assembly];
			break;

		case $effect[different way of seeing things]:
			use_familiar($familiar[imitation crab]);
			retrieve_item(1,$item[imitation whetstone]);
			retrieve_item(1,$item[full meat tank]);
			it1 = $item[dry noodles];
			it2 = $item[imitation whetstone];
			it3 = $item[full meat tank];
			it4 = $item[cog and sprocket assembly];
			break;

		case $effect[knightlife]:
			use_familiar($familiar[imitation crab]);
			retrieve_item(1,$item[imitation whetstone]);
			retrieve_item(1,$item[ketchup]);
			it1 = $item[ketchup];
			it2 = $item[newbiesport&trade; tent];
			it3 = $item[imitation whetstone];
			it4 = $item[cog and sprocket assembly];
			break;

		case $effect[certainty]:
			c2t_assert(available_amount($item[electronics kit]) > 0,"missing electronics kit for CER pizza");
			it1 = $item[cog and sprocket assembly];
			it2 = $item[electronics kit];
			it3 = $item[razor-sharp can lid];
			it4 = c2t_priority($item[middle of the road&trade; brand whiskey],$item[pb&j with the crusts cut off],$item[surprisingly capacious handbag]);
			break;

		case $effect[infernal thirst]:
			//TODO better familiar equipment handling
			use_familiar(c2t_priority($familiars[exotic parrot,mu,cornbeefadon]));
			retrieve_item(1,$item[full meat tank]);
			retrieve_item(1,$item[imitation whetstone]);

			if (item_amount($item[eldritch effluvium]) == 0
				&& item_amount($item[eaves droppers]) == 0
				&& ((have_familiar($familiar[exotic parrot]) && available_amount($item[cracker]) == 0)
					|| item_amount($item[electronics kit]) == 0))

				retrieve_item(1,$item[eyedrops of the ermine]);

			it1 = $item[imitation whetstone];
			it2 = c2t_priority($item[neverending wallet chain], $item[newbiesport&trade; tent]);
			it3 = $item[full meat tank];
			it4 = c2t_priority($item[eldritch effluvium],$item[eaves droppers],$item[eyedrops of the ermine],$item[electronics kit]);
			break;

		case $effect[outer wolf&trade;]:
			choose = {$item[middle of the road&trade; brand whiskey],$item[surprisingly capacious handbag],$item[pb&j with the crusts cut off]};
			retrieve_item(1,$item[ointment of the occult]);
			if (have_skill($skill[pulverize]) && item_amount($item[useless powder]) == 0) {
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
	return have_effect(eff) > 0;
}
boolean c2t_hccs_pizzaCube(item it1,item it2,item it3,item it4) {
	if (!c2t_hccs_pizzaCube())
		return false;
	if (my_fullness() + 3 > fullness_limit()) {
		print("no organ space for a pizza","red");
		return false;
	}
	if (available_amount($item[diabolic pizza]) > 0) {
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
	if (get_property("c2t_hccs_disable.powerPlant").to_boolean())
		return false;
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

//i--shorter-order cook
boolean c2t_hccs_shorterOrderCook() {
	return have_familiar($familiar[shorter-order cook])
		&& !get_property("c2t_hccs_disable.shorterOrderCook").to_boolean();
}

//i--sweet synthesis
boolean c2t_hccs_sweetSynthesis() return have_skill($skill[sweet synthesis]);
boolean c2t_hccs_sweetSynthesis(effect eff) {
	if (!c2t_hccs_sweetSynthesis())
		return false;
	if (have_effect(eff) > 0)
		return true;

	item it1,it2;
	it1 = it2 = $item[none];

	switch (eff) {
		default:
			return false;

		case $effect[synthesis: collection]://item
			if (!c2t_hccs_gardenPeppermint())
				return false;
			it1 = $item[peppermint sprout];
			it2 = $item[peppermint twist];
			break;

		case $effect[synthesis: movement]://mus exp
		case $effect[synthesis: learning]://mys exp
			if (sweet_synthesis(eff))
				return true;
			print(`Note: {eff} failed. Going to fight a hobelf and try again.`);
			if (!have_equipped($item[fourth of may cosplay saber]))
				equip($item[fourth of may cosplay saber]);
			if (!c2t_hccs_combatLoversLocket($monster[elf hobo]))
				c2t_hccs_genie($monster[elf hobo]);
			return sweet_synthesis(eff);

		case $effect[synthesis: style]://mox exp
			if (item_amount($item[crimbo candied pecan]) > 0 && item_amount($item[crimbo fudge]) > 0) {
				it1 = $item[crimbo candied pecan];
				it2 = $item[crimbo fudge];
				break;
			}
			if (c2t_hccs_gardenPeppermint()) {
				if (item_amount($item[crimbo fudge]) > 0) {
					it1 = $item[crimbo fudge];
					it2 = $item[peppermint sprout];
					break;
				}
				if (item_amount($item[crimbo peppermint bark]) > 0) {
					it1 = $item[crimbo peppermint bark];
					it2 = $item[peppermint twist];
					break;
				}
			}
			if (c2t_hccs_tomeSugar()) {
				if (item_amount($item[crimbo candied pecan]) > 0) {
					it1 = $item[crimbo candied pecan];
					it2 = $item[sugar shillelagh];
				}
				else if (item_amount($item[crimbo peppermint bark]) > 0) {
					it1 = $item[crimbo peppermint bark];
					it2 = $item[sugar sheet];
				}
				else if (item_amount($item[crimbo fudge]) > 0) {
					it1 = $item[crimbo fudge];
					it2 = $item[sugar shank];
				}
				if (c2t_hccs_tomeSugar(it2))
					break;
			}
			//have to waste a wish & saber use on olives as moxie, so can't recover candy failure with those like other classes
			print("Didn't get the right candies for buffs, so dropping hardcore.","blue");
			if (in_hardcore())
				c2t_dropHardcore();
			//TODO maybe make pull selection smarter
			it1 = $item[crimbo candied pecan];
			it2 = $item[crimbo fudge];
			c2t_hccs_pull(it1);
			c2t_hccs_pull(it2);
			break;

		case $effect[synthesis: strong]://mus stat
			if (item_amount($item[crimbo candied pecan]) > 0) {
				it1 = $item[crimbo candied pecan];
				it2 = $item[jaba&ntilde;ero-flavored chewing gum];
			}
			else if (item_amount($item[crimbo peppermint bark]) > 0) {
				it1 = $item[crimbo peppermint bark];
				it2 = $item[tamarind-flavored chewing gum];
			}
			else if (item_amount($item[peppermint sprout]) > 0) {
				it1 = $item[peppermint sprout];
				it2 = $item[jaba&ntilde;ero-flavored chewing gum];
			}
			else if (item_amount($item[peppermint twist]) > 0) {
				it1 = $item[peppermint twist];
				it2 = $item[pickle-flavored chewing gum];
			}
			else if (item_amount($item[crimbo fudge]) > 0) {
				it1 = $item[crimbo fudge];
				it2 = $item[pile of candy];
			}
			break;

		case $effect[synthesis: smart]://mys stat
			if (item_amount($item[crimbo peppermint bark]) > 0) {
				it1 = $item[crimbo peppermint bark];
				it2 = $item[lime-and-chile-flavored chewing gum];
			}
			else if (item_amount($item[crimbo fudge]) > 0) {
				it1 = $item[crimbo fudge];
				it2 = $item[tamarind-flavored chewing gum];
			}
			else if (item_amount($item[peppermint sprout]) > 0 || item_amount($item[peppermint twist]) > 0) {
				it1 = $item[peppermint twist];
				it2 = $item[jaba&ntilde;ero-flavored chewing gum];
			}
			else if (item_amount($item[crimbo candied pecan]) > 0) {
				it1 = $item[crimbo candied pecan];
				it2 = $item[pile of candy];
			}
			break;

		case $effect[synthesis: cool]://mox stat
			if (item_amount($item[crimbo peppermint bark]) > 0) {
				it1 = $item[crimbo peppermint bark];
				it2 = $item[pickle-flavored chewing gum];
			}
			else if (item_amount($item[crimbo fudge]) > 0) {
				it1 = $item[crimbo fudge];
				it2 = $item[lime-and-chile-flavored chewing gum];
			}
			else if (item_amount($item[crimbo candied pecan]) > 0) {
				it1 = $item[crimbo candied pecan];
				it2 = $item[tamarind-flavored chewing gum];
			}
			else if (item_amount($item[peppermint sprout]) > 0) {
				it1 = $item[peppermint sprout];
				it2 = $item[tamarind-flavored chewing gum];
			}
			break;

		case $effect[synthesis: hot]://hot res
			retrieve_item(2,$item[jaba&ntilde;ero-flavored chewing gum]);
			it1 = $item[jaba&ntilde;ero-flavored chewing gum];
			it2 = $item[jaba&ntilde;ero-flavored chewing gum];
			break;
	}

	//previous edge cases
	if (it2 == $item[pile of candy] && item_amount(it2) == 0) {
		if (!have_equipped($item[fourth of may cosplay saber]))
			equip($item[fourth of may cosplay saber]);
		c2t_hccs_cartography($location[south of the border],$monster[angry pi&ntilde;ata]);
	}

	if (it2 == $item[none] || !retrieve_item(it1) || !retrieve_item(it2))
		return false;

	return sweet_synthesis(it1,it2);
}

//i--tome clip art
boolean c2t_hccs_tomeClipArt() {
	return have_skill($skill[summon clip art]);
		//&& get_property("tomeSummons").to_int() < 3;
}
boolean c2t_hccs_tomeClipArt(item it) {
	if (item_amount(it) > 0)
		return true;
	if (!c2t_hccs_tomeClipArt())
		return false;
	if (get_property("tomeSummons").to_int() >= 3)
		return false;
	return retrieve_item(it);
}

//i--tome sugar
boolean c2t_hccs_tomeSugar() {
	return have_skill($skill[summon sugar sheets]);
		//&& get_property("tomeSummons").to_int() < 3;
}
boolean c2t_hccs_tomeSugar(item it) {
	if (item_amount(it) > 0)
		return true;
	if (item_amount($item[sugar sheet]) == 0) {
		if (!c2t_hccs_tomeSugar())
			return false;
		if (get_property("tomeSummons").to_int() >= 3)
			return false;
		c2t_hccs_haveUse($skill[summon sugar sheets]);
	}
	return retrieve_item(it);
}

//i--unbreakable umbrella
boolean c2t_hccs_unbreakableUmbrella() {
	return available_amount($item[unbreakable umbrella]) > 0;
}
boolean c2t_hccs_unbreakableUmbrella(string mode) {
	if (!c2t_hccs_unbreakableUmbrella())
		return false;
	switch (mode) {
		default:
			return false;
		case "ml":
		case "item":
		case "dr":
		case "weapon":
		case "spell":
		case "nc":
		case "broken":
		case "forward":
		case "bucket":
		case "pitchfork":
		case "twirling":
		case "cocoon":
	}
	//kol won't allow umbrella mode change if it's on an inactive familiar, so retrieve it if needed
	item ite = $item[unbreakable umbrella];
	if (!have_equipped(ite) && item_amount(ite) == 0)
		retrieve_item(ite);

	cli_execute(`umbrella {mode}`);
	return true;
}

//i--vip floundry
boolean c2t_hccs_vipFloundry() {
	return (get_clan_lounge() contains $item[clan floundry])
		&& !get_property("c2t_hccs_disable.vipFloundry").to_boolean();
}

//i--vote
void c2t_hccs_vote() {
	if (!get_property("voteAlways").to_boolean() && !get_property("_voteToday").to_boolean())
		return;
	if (available_amount($item[&quot;i voted!&quot; sticker]) > 0)
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

	if (available_amount($item[&quot;i voted!&quot; sticker]) == 0)
		abort("Voting failed?");
}


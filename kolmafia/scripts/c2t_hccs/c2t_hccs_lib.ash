//c2t hccs lib
//c2t

/*============
  declarations
  ============*/

//get an effect
//returns true if effect obtained
boolean c2t_hccs_getEffect(effect eff);

//pull 1 of an item from storage if not already have it
//returns true in the case of pulling an item or if the item already is available
boolean c2t_hccs_pull(item ite);


/*===============
  implementations
  ===============*/

boolean c2t_hccs_getEffect(effect eff) {
	if (have_effect(eff).to_boolean())
		return true;

	string cmd = eff.default;
	string tmp;
	skill ski;
	item ite;
	string [int] spl;

	if (cmd.starts_with("cargo "))
		foreach x in eff.all
			if (!x.starts_with("cargo ")) {
				cmd = x;
				break;
			}
	if (cmd.starts_with("cargo ")) {
		print(`aborted an attempt to use cargo shorts for {eff}`,"red");
		return false;
	}

	if (cmd.starts_with("cast ")) {
		spl = cmd.split_string(" ");
		for i from 2 to spl.count()-1
			tmp += i == 2?spl[i]:` {spl[i]}`;
		ski = tmp.to_skill();

		if (!have_skill(ski)) {
			print(`Info: don't have the skill "{ski}" to get the "{eff}" effect`);
			return false;
		}

		//TODO better MP recovery
		if (my_mp() < mp_cost(ski))
			cli_execute("rest free");

		use_skill(ski);
	}
	else if (cmd.starts_with("use ")) {
		spl = cmd.split_string(" ");
		for i from 2 to spl.count()-1
			tmp += i == 2?spl[i]:` {spl[i]}`;
		ite = tmp.to_item();

		if (!retrieve_item(ite)) {
			print(`Info: "{ite}" not retrieved to get "{eff}"`);
			return false;
		}
		use(ite);
	}
	else //probably disabling this part in the future
		cli_execute(cmd);

	return have_effect(eff).to_boolean();
}


//pull item from storage
boolean c2t_hccs_pull(item ite) {
	if(!can_interact() && !in_hardcore() && item_amount(ite) == 0 && available_amount(ite) == 0 && storage_amount(ite) > 0 && pulls_remaining() > 0)
		return take_storage(1,ite);
	else if (available_amount(ite) > 0)
		return true;
	return false;
}


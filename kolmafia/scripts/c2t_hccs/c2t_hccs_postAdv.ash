//c2t hccs postAdv
//c2t

import <c2t_hccs_lib.ash>

void main() {
	//handle june cleaver adventure
	if (c2t_hccs_isCleaverNow()
		&& have_equipped($item[june cleaver])
		&& !get_property("relayCounters").contains_text("portscan.edu"))

		adv1($location[noob cave]);//unless it's discovered it burns delay
}

//c2t hccs postAdv
//c2t

void main() {
	//handle june cleaver adventure
	if (c2t_hccs_isCleaverNow()
		&& have_equipped($item[june cleaver])
		&& get_property("_c2t_hccs_lastCleaverDone") != get_property("_juneCleaverCharge")
		)
		adv1($location[noob cave]);//unless it's discovered it burns delay
}

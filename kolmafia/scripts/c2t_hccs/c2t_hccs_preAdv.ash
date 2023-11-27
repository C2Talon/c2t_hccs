//c2t hccs preAdv
//c2t

//pre-adventure script for c2t_hccs

void c2t_hccs_preAdv() {
	//tiny stillsuit: equip on gelatinous cubeling if not on anything else
	if (item_amount($item[tiny stillsuit]) > 0)
		equip($familiar[gelatinous cubeling],$item[tiny stillsuit]);

	//should led candle drop //TODO stats for non-capped fights?
	if (available_amount($item[led candle]) > 0
		&& get_property("ledCandleMode") == "")
	{
		cli_execute("jillcandle meat");
	}

	restore_hp(0);
	restore_mp(50);
}

void main() c2t_hccs_preAdv();


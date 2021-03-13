//c2t hccs aux
//not c2t

//functions ripped from elsewhere that I haven't wholly replaced yet; mostly from Worthawholebean


void ensure_effect(effect ef, int turns) {
    if (have_effect(ef) < turns) {
        if (!cli_execute(ef.default) || have_effect(ef) == 0) {
            abort('Failed to get effect ' + ef.name + '.');
        }
    } else {
        print('Already have effect ' + ef.name + '.');
    }
}

void ensure_effect(effect ef) {
    ensure_effect(ef, 1);
}

void eat_pizza(item it1, item it2, item it3, item it4) {
    if (available_amount($item[diabolic pizza]) > 0) {
        abort('Already have a pizza.');
    }
    if (available_amount(it1) == 0 || available_amount(it2) == 0 || available_amount(it3) == 0 || available_amount(it4) == 0) {
        abort('Missing items for pizza.');
    }
    visit_url('campground.php?action=makepizza&pizza=' + it1.to_int() + ',' + it2.to_int() + ',' + it3.to_int() + ',' + it4.to_int());
    eat(1, $item[diabolic pizza]);
}

void pizza_effect(effect ef, item it1, item it2, item it3, item it4) {
    if (have_effect(ef) == 0) {
        eat_pizza(it1, it2, it3, it4);
        if (have_effect(ef) == 0) {
            abort('Failed to get effect ' + ef.name + '.');
        }
    } else {
        print('Already have effect ' + ef.name + '.');
    }
}

void shrug(effect ef) {
    if (have_effect(ef) > 0) {
        cli_execute('shrug ' + ef.name);
    }
}

boolean[effect] song_slot_3 = $effects[Power Ballad of the Arrowsmith, The Magical Mojomuscular Melody, The Moxious Madrigal, Ode to Booze, Jackasses' Symphony of Destruction];
boolean[effect] song_slot_4 = $effects[Carlweather's Cantata of Confrontation, The Sonata of Sneakiness, Polka of Plenty];
void open_song_slot(effect song) {
    boolean[effect] song_slot;
    if (song_slot_3 contains song) song_slot = song_slot_3;
    else if (song_slot_4 contains song) song_slot = song_slot_4;
    foreach shruggable in song_slot {
        shrug(shruggable);
    }
}

void ensure_song(effect ef) {
    if (have_effect(ef) == 0) {
        open_song_slot(ef);
        if (!cli_execute(ef.default) || have_effect(ef) == 0) {
            abort('Failed to get effect ' + ef.name + '.');
        }
    } else {
        print('Already have effect ' + ef.name + '.');
    }
}

void ensure_ode(int turns) {
    while (have_effect($effect[Ode to Booze]) < turns) {
        //ensure_mp_tonic(50);
        open_song_slot($effect[Ode to Booze]);
        use_skill(1, $skill[The Ode to Booze]);
    }
}


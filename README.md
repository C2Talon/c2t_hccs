# c2t_hccs

Kolmafia script to handle a hardcore community service run with my set of skills and IotMs and with any class.

This is a continual work-in-progress. It is not likely to run out-of-the-box for most, but others may be able to glean things from it. To see what is needed to run smoothly without changes, see: https://cheesellc.com/kol/profile.php?u=Zdrvst

`svn checkout https://github.com/c2talon/c2t_hccs/branches/master/kolmafia/`

## Usage

* The main script is "c2t_hccs", and is the thing that should be run to do a HCCS run
* Not likely to run out-of-the-box for most. Hoping to change this eventually
* Able to be re-run at any point in a run, hopefully after correcting whatever caused it to stop
* Will abort when a non-coil test will not be done in 1 turn, which presently is the familiar and spell damage tests based on what I have and what is supported
* Pre-Valhalla: put diabolic pizza cube in the workshed
* In Valhalla:
* * Choose any class
* * Choose the corresponding "knoll" moonsign
* * Astral pet sweater is currently required: some maximizer calls will do weird things without it at present
* For now, before running the script, have to manually vote, then manually comb the beach up to 5 times for a grain of sand
* Presently depends on melodramedary spit, so aborts at some critical points if spit% is too low for potential manual intervention
* Uses moods "hccs-mus", "hccs-mys", and "hccs-mox" for leveling purposes on muscle, mysticality, and moxie classes, respectively. So set your own to what you want for what skills you have, otherwise you won't have much buffs while leveling
* * Exception: the script will cast and handle stevedave's shanty of superiority and ur-kel's aria of annoyance, so either put them in the mood as well or leave 2 song slots open for them

## TODO (eventually)

* Genericise things to not assume whoever runs this has everything I do
* Better handling when overcapping a test, i.e. only use as much resources as needed and not more
* Change the combat consult script to submit a single macro for the whole combat
* Add user-defined thresholds for aborting on non-capped tests
* Purge cruft from changes done over time
* Add more IotMs and such as I get them


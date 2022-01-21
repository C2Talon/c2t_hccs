//c2t hccs properties
//c2t


//properties
//can set the following properties via the CLI. This just sets some defaults in case they don't exist to make handling them simpler


/*
set c2t_hccs_haltBeforeTest = false
aborts after prepping for each test but before actually doing it at the council
*/
if (!property_exists("c2t_hccs_haltBeforeTest",false))
	set_property("c2t_hccs_haltBeforeTest","false");

/*
set c2t_hccs_printModtrace = false
prints a modtrace to the CLI and log just before non-stat tests
*/
if (!property_exists("c2t_hccs_printModtrace",false))
	set_property("c2t_hccs_printModtrace","true");

/*
set c2t_hccs_joinClan = 90485
This is the clan that the script will join for the VIP lounge and fortune teller
Takes an int or string, where int would be clanid (preferred), and string would be the clan name
*/
if (!property_exists("c2t_hccs_joinClan",false))
	set_property("c2t_hccs_joinClan","90485");

/*
set c2t_hccs_clanFortunes = CheeseFax
This is the name of the person/bot that you want to do the fortune teller with
*/
if (!property_exists("c2t_hccs_clanFortunes",false))
	set_property("c2t_hccs_clanFortunes","CheeseFax");

/*
set c2t_hccs_skipFinalService = false
If this is set to true, the final service will be skipped leaving you in-run once finished
*/
if (!property_exists("c2t_hccs_skipFinalService",false))
	set_property("c2t_hccs_skipFinalService","false");

/*
set c2t_hccs_thresholds = 1,1,1,1,1,1,1,1,1,1
These are the 10 thresholds corresponding to the minimum turns to allow each test to take
The order is hp,mus,mys,mox,fam,weapon,spell,nc,item,hot -- which is the same as the game
The script will stop just before doing a test if a threshold is not met after doing all the pre-test stuff
Example: 1,1,1,1,35,1,31,1,1,1 will allow the familiar test to take 35 turns, the spell test to take 31 turns, and all others must be 1 turn
*/
if (!property_exists("c2t_hccs_thresholds",false))
	set_property("c2t_hccs_thresholds","1,1,1,1,1,1,1,1,1,1");

/*
set c2t_bb_printMacro = true
Prints the combat macro the script submits in combat
*/
if (!property_exists("c2t_bb_printMacro",false))
	set_property("c2t_bb_printMacro","true");



/*-=-+-=-+-=-+-=-+-=-
  disable resources
  -=-+-=-+-=-+-=-+-=-*/

/*
Use the respective CLI command to set the property to disable a particular resource.
By disabling a resource, the script won't use _any_ limited resource from it.
I.e. it's an all or nothing thing.

-- briefcase --
set c2t_hccs_disable.briefcase = true

-- cold medicine cabinet --
set c2t_hccs_disable.coldMedicineCabinet = true

-- pantogram --
set c2t_hccs_disable.pantogram = true

-- pillkeeper --
set c2t_hccs_disable.pillkeeper = true

-- pizza cube --
set c2t_hccs_disable.pizzaCube = true

-- power plant --
set c2t_hccs_disable.powerPlant = true

*/


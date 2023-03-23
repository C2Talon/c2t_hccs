//relay c2t hccs
//c2t

//interface for changing settings

import <c2t_hccs_properties.ash>

string [string] POST = form_fields();
boolean postError = false;

void c2t_hccs_writeText(string tag,string s);
void c2t_hccs_writeCheckbox(string s,string desc);
void c2t_hccs_writeInput(string name,string value,string desc,int size,int max);
void c2t_hccs_writeSelect(string name,string desc,boolean [item] options);
void c2t_hccs_writeFailSuccess();
void c2t_hccs_writeTh(string a, string b, string c);

void main() {
	//TODO use file_to_map() with data file
	string [string] general = {
		"c2t_hccs_haltBeforeTest":"halts the script each time the pre-test is done and before the test is submitted; mostly for troubleshooting",
		"c2t_hccs_printModtrace":"prints the modtrace to the CLI and log",
		"c2t_hccs_skipFinalService":"skips the final service to stay in run"
		};

	string [string] clan = {
		"c2t_hccs_joinClan":"clan to use for all VIP things; clan ID is preferred, but just the name also works",
		"c2t_hccs_clanFortunes":"name of the person/bot that you want to do the fortune teller with; blank out to skip fortunes"
		};

	string [string] disableable = {
		"c2t_hccs_disable.autumnatonItem":"will skip getting the 25% item drop potion with autumn-aton",
		"c2t_hccs_disable.backupCamera":"will not use the 'back-up to your last enemy' skill",
		"c2t_hccs_disable.briefcase":"no cranks will be used; however, banishes may still be used",
		"c2t_hccs_disable.closedCircuitPayPhone":"will not do anything involving shadow rifts",
		"c2t_hccs_disable.cloverItem":"11-leaf clover will not be used for limerick dungeon lucky adventure",
		"c2t_hccs_disable.combatLoversLocket":"no monsters will be summoned from combat lover's locket",
		"c2t_hccs_disable.latteFishing":"will not use extra banishes to fish for item drop enhancement for latte",
		"c2t_hccs_disable.melodramedary":"melodramedary will not be used to try to save turns on weapon and spell tests",
		"c2t_hccs_disable.pantogram":"no pants to try to save turns on hot, non-combat, or spell tests",
		"c2t_hccs_disable.pillkeeper":"no pill popping from pillkeeper, free or otherwise",
		"c2t_hccs_disable.pocketProfessor":"no pocket professor copies will be used for leveling",
		"c2t_hccs_disable.portscan":"if you are dying to government agents, this will disable fighting them",
		"c2t_hccs_disable.powerPlant":"power plant will not be used for the item test (or elsewhere)",
		"c2t_hccs_disable.shorterOrderCook":"shorter-order cook will not be used to try to saves turns on the familiar test",
		"c2t_hccs_disable.vipBeesKnees":"will not drink a Bee's Knees as part of buffing up stats for leveling",
		"c2t_hccs_disable.vipFloundry":"equipment will not be acquired from the clan floundry"
		};

	string [int] thresholdName = {"HP","muscle","mysticality","moxie","familiar","weapon","spell","non-combat","item","hot"};

	//handle things submitted
	if (POST.count() > 1) {
		//validate numbers //this is the only input validation I'm bothering with for now
		foreach i,x in thresholdName {
			int temp = POST[x].to_int();
			if (temp <= 0 || temp > 60) {
				postError = true;
				break;
			}
		}
		if (!postError) {
			string temp;
			foreach name,desc in clan
				set_property(name,POST[name]);
			foreach name,desc in general
				set_property(name,POST[name]=="on"?"true":"false");
			foreach name,desc in disableable
				set_property(name,POST[name]=="on"?"true":"false");
			foreach i,name in thresholdName
				temp += (i == 0?POST[name]:","+POST[name]);
			set_property("c2t_hccs_thresholds",temp);
			set_property("c2t_hccs_workshed",POST["c2t_hccs_workshed"]);
		}
	}

	string [int] threshold = get_property("c2t_hccs_thresholds").split_string(",");

	//header
	write('<!DOCTYPE html><html lang="EN"><head><title>c2t_hccs Settings</title>');
	write("<style>p.error {color:#f00;background-color:#000;padding:10px;font-weight:bold;} p.success {color:#00f;} th {font-weight:extra-bold;padding:5px 10px 5px 10px;} ul {padding-left:0;} li {list-style-type:none;margin:0;padding:0;} thead {background-color:#000;color:#fff;} tr:nth-child(even) {background-color:#ddd;} table {border-style:solid;border-width:1px;} input.submit {margin:12pt;padding:5px;} td {padding:0 5px 0 5px;}</style>");
	write("</head><body>");

	//body
	c2t_hccs_writeFailSuccess();

	c2t_hccs_writeText("h1","c2t_hccs Settings");
	c2t_hccs_writeText("p",'No changes will be made until the "save changes" button is used at the bottom.');

	//form
	write('<form action="" method="post">');

	//general
	c2t_hccs_writeText("h2","General");
	write(`<ul><li>Current clan: <code>{get_clan_name()}</code></li><li>Current clan ID: <code>{get_clan_id()}</code></li></ul>`);
	write("<table>");
	c2t_hccs_writeTh("setting","value","description");
	write("<tbody>");
	foreach name,desc in clan
		c2t_hccs_writeInput(name,"",desc,30,30);
	foreach name,desc in general
		c2t_hccs_writeCheckbox(name,desc);
	c2t_hccs_writeSelect("c2t_hccs_workshed","workshed to be installed and used",$items[none,cold medicine cabinet,diabolic pizza cube,model train set]);
	write("</tbody></table>");

	//thresholds
	c2t_hccs_writeText("h2","Thresholds");
	c2t_hccs_writeText("p","These are the 10 thresholds corresponding to the minimum turns to allow each test to take. The script will stop just before doing a test if a threshold is not met after doing all the pre-test stuff.");
	write("<table>");
	c2t_hccs_writeTh("test","turns","");
	write("<tbody>");
	foreach name,num in threshold
		c2t_hccs_writeInput(thresholdName[name],num,"",1,2);
	write("</tbody></table>");

	//disablables
	c2t_hccs_writeText("h2","Disableable Resources");
	c2t_hccs_writeText("p","Check any of the following to disable that resource. Disabling a resource means to not use most things from that resource.");
	write("<table>");
	c2t_hccs_writeTh("setting","value","description");
	write("<tbody>");
	foreach name,desc in disableable
		c2t_hccs_writeCheckbox(name,desc);
	write("</tbody></table>");

	write('<input type="submit" value="save changes" class="submit" />');
	c2t_hccs_writeFailSuccess();
	write("</form>");

	//footer
	write("</body></html>");
}

void c2t_hccs_writeText(string tag,string s) {
	write(`<{tag}>{s}</{tag.split_string(" ")[0]}>`);
}

void c2t_hccs_writeCheckbox(string s,string desc) {
	boolean check;
	if (postError == true)
		check = (POST[s] == "on"?true:false);
	else
		check = get_property(s).to_boolean();
	write(`<tr><td><label for="{s}"><code>{s}</code></label></td><td><input type="checkbox" name="{s}" id="{s}"{check?' checked="checked"':''} /></td>`);
	if (desc != "")
		write(`<td>{desc}</td>`);
	write("</tr>");
}

void c2t_hccs_writeInput(string name,string value,string desc,int size,int max) {
	string val = value;
	if (postError == true)
		val = POST[name];
	else if (name.starts_with("c2t_hccs_"))
		val = get_property(name);
	write(`<tr><td><label for="{name}"><code>{name}</code></label></td><td><input type="text" name="{name}" id="{name}" size="{size}" maxlength="{max}" value="{val}" /></td>`);
	if (desc != "")
		write(`<td>{desc}</td>`);
	write("</tr>");
}

void c2t_hccs_writeSelect(string name,string desc,boolean [item] options) {
	string val;
	if (postError == true)
		val = POST[name];
	else if (property_exists(name))
		val = get_property(name);
	else
		val = "none";

	write(`<tr><td><label for="{name}"><code>{name}</code></label></td><td><select name="{name}" id="{name}">`);
	foreach x in options {
		write(`<option value="{x}"`);
		if (val == x)
			write(" selected");
		write(`>{x}</option>`);
	}
	write(`</select></td><td>{desc}</td></tr>`);
}

void c2t_hccs_writeTh(string a, string b, string c) {
	write(`<thead><tr><th>{a}</th><th>{b}</th>`);
	if (c != "")
		write(`<th>{c}</th>`);
	write("</tr></thead>");
}

void c2t_hccs_writeFailSuccess() {
	if (postError)
		c2t_hccs_writeText('p class="error"',"CHANGES NOT SAVED! Error: thresholds must be between 1 and 60");
	else if (POST.count() > 1)
		c2t_hccs_writeText('p class="success"',"Changes saved!");
}


/*--------------------------------------------------------
Default teams. If you make a team above the citizen team, people will spawn with that team!
--------------------------------------------------------*/
TEAM_CITIZEN = AddExtraTeam("Горожанен", Color(20, 150, 20, 255), {
	"models/player/Group01/Female_01.mdl",
	"models/player/Group01/Female_02.mdl",
	"models/player/Group01/Female_03.mdl",
	"models/player/Group01/Female_04.mdl",
	"models/player/Group01/Female_06.mdl",
	"models/player/Group01/Female_07.mdl",
	"models/player/group01/male_01.mdl",
	"models/player/Group01/Male_02.mdl",
	"models/player/Group01/male_03.mdl",
	"models/player/Group01/Male_04.mdl",
	"models/player/Group01/Male_05.mdl",
	"models/player/Group01/Male_06.mdl",
	"models/player/Group01/Male_07.mdl",
	"models/player/Group01/Male_08.mdl",
	"models/player/Group01/Male_09.mdl"},
[[Гражданин - самый простой способ жить в этом городе без каких-либо потребностей,
	суеты, разумеется, если есть деньги. Но рано или поздно они ведь кончаться.
У вас нет никакой особой роли в Рп жизни, но все зависит лишь от вас. ]], {"weapon_mad_fists"}, "citizen", 0, 50, 0, false, false)

TEAM_POLICE = AddExtraTeam("Полиция", Color(25, 25, 170, 255), "models/player/police.mdl", [[Полиция - защита каждого гражданина города . 
У вас есть достаточно власти для наказания преступников
 и защите невинных. 
Но вы можете быть и плохим полицейским, решать вам.]], {"weapon_mad_fists", "arrest_stick", "unarrest_stick", "taser", "weapon_mad_57", "stunstick", "door_ram", "weaponchecker"}, "cp", 4, 95, 0, true, true)

TEAM_GANG = AddExtraTeam("Гангстер", Color(75, 75, 75, 255), {
	"models/player/Group03/Female_01.mdl",
	"models/player/Group03/Female_02.mdl",
	"models/player/Group03/Female_03.mdl",
	"models/player/Group03/Female_04.mdl",
	"models/player/Group03/Female_06.mdl",
	"models/player/Group03/Female_07.mdl",
	"models/player/group03/male_01.mdl",
	"models/player/Group03/Male_02.mdl",
	"models/player/Group03/male_03.mdl",
	"models/player/Group03/Male_04.mdl",
	"models/player/Group03/Male_05.mdl",
	"models/player/Group03/Male_06.mdl",
	"models/player/Group03/Male_07.mdl",
	"models/player/Group03/Male_08.mdl",
	"models/player/Group03/Male_09.mdl"}, [[Гангстер - низший уровень преступлений. 
Вы - работаете на главу, и обязаны выполнять повестки дня,
 тоесть - задания самого босса.
 Если его нет, вы сам себе хозяин в грабеже и разврате.]], {"weapon_mad_fists"}, "gangster", 4, 85, 0, false, false)

TEAM_MOB = AddExtraTeam("Моббосс", Color(25, 25, 25, 255), "models/player/gman_high.mdl", [[ Моббосс - глава криминала города. 
Вы можете быть вором в законе,
 а можете быть главой террористов, решать вам.]], {"weapon_mad_fists", "lockpick", "unarrest_stick"}, "mobboss", 1, 100, 0, false, false, TEAM_MAFIA)
 
TEAM_GUN = AddExtraTeam("Продавец оружия", Color(255, 140, 0, 255), "models/player/monk.mdl", [[Гандиллер - человек, поставляющий оружие в городе. 
Может быть плохим или хорошим. Решать вам:
Делать полиции скидки, или продaвать
  террористам вооружение против них.
Но не забывайте, что продавать вы обязаны всем по закону.]], {"weapon_mad_fists"}, "gundealer", 2, 65, 0, false, false)

TEAM_MEDIC = AddExtraTeam("Доктор", Color(47, 79, 79, 255), "models/player/kleiner.mdl", [[Доктор - человек, без которого не обойтись
	  в этом опасном городе.
Выберите свой путь в жизни, кому вы будете помогать.
Вы можете открыть больницу, или открыть клинику для
  больных наркозависимостью, сделать службу скорой помощи,
  решать вам.]], {"weapon_mad_fists", "weapon_mad_medic"}, "medic", 3, 100, 0, false, false)
  
TEAM_COOK = AddExtraTeam("Повар", Color(238, 99, 99, 255), "models/player/mossman.mdl", [[Повар - поставщик еды в городе.
Не может иметь статус плохого или доброго.
 Продавец, он и в Африке продавец.
Но можно неплохо заработать на продаже еды.]], {"weapon_mad_fists"}, "cook", 2, 45, 0, 0, false)

TEAM_CHIEF = AddExtraTeam("Лидер полиции", Color(20, 20, 255, 255), "models/player/combine_soldier_prisonguard.mdl", [[Лидер полиции - опытный человек, который выполняет приказы мэра города.
Должен управлять полицией.
Может быть подкупным, но скрываясь от мэра,
 если он сам таким не является.]], {"weapon_mad_fists", "arrest_stick", "unarrest_stick", "weapon_mad_ump", "weapon_mad_deagle", "stunstick", "door_ram", "weaponchecker"}, "chief", 1, 120, 0, false, true, TEAM_POLICE)

TEAM_MAYOR = AddExtraTeam("Мэр", Color(150, 150, 20, 255), "models/player/breen.mdl", [[Мэр - глава города.
 ОБЯЗАН своевременно издавать законы и следить за порядком.
Может быть не только на стороне порядка и закона,
 может быть и корруптным.]], {"weapon_mad_fists"}, "mayor", 1, 120, 0, true, false)
/*
--------------------------------------------------------
HOW TO MAKE AN EXTRA CLASS!!!!
--------------------------------------------------------

You can make extra classes here. Set everything up here and the rest will be done for you! no more editing 100 files without knowing what you're doing!!!
Ok here's how:

To make an extra class do this:
AddExtraTeam( "<NAME OF THE CLASS>", Color(<red>, <Green>, <blue>, 255), "<Player model>" , [[<the description(it can have enters)>]], { "<first extra weapon>","<second extra weapon>", etc...}, "<chat command to become it(WITHOUT THE /!)>", <maximum amount of this team> <the salary he gets>, 0/1/2 = public /admin only / superadmin only, <1/0/true/false Do you have to vote to become it>,  true/false DOES THIS TEAM HAVE A GUN LICENSE?, TEAM: Which team you need to be to become this team)

The real example is here: it's the Hobo:		*/

--VAR without /!!!			The name    the color(what you see in tab)                   the player model					The description
TEAM_HOBO = AddExtraTeam("Hobo", Color(80, 45, 0, 255), "models/player/corpse1.mdl", [[The lowest member of society. All people see you laugh. 
You have no home.
Beg for your food and money
Sing for everyone who passes to get money
Make your own wooden home somewhere in a corner or 
outside someone else's door]], {"weapon_bugbait"}, "hobo", 5, 0, 0, false)
//No extra weapons           say /hobo to become hobo  Maximum hobo's = 5		his salary = 0 because hobo's don't earn money.          0 = everyone can become hobo ,      false = you don't have to vote to become hobo
// MAKE SURE THAT THERE IS NO / IN THE TEAM NAME OR IN THE TEAM COMMAND:
// TEAM_/DUDE IS WROOOOOONG !!!!!!
// HAVING "/dude" IN THE COMMAND FIELD IS WROOOOOOOONG!!!!
//ADD TEAMS UNDER THIS LINE:









/*
--------------------------------------------------------
HOW TO MAKE A DOOR GROUP
--------------------------------------------------------
AddDoorGroup("NAME OF THE GROUP HERE, you see this when looking at a door", Team1, Team2, team3, team4, etc.)

WARNING: THE DOOR GROUPS HAVE TO BE UNDER THE TEAMS IN SHARED.LUA. IF THEY ARE NOT, IT MIGHT MUCK UP!


The default door groups, can also be used as examples:
*/
AddDoorGroup("cops and mayor only", TEAM_CHIEF, TEAM_POLICE, TEAM_MAYOR)
AddDoorGroup("gundealer only", TEAM_GUN)


/*
--------------------------------------------------------
HOW TO MAKE An agenda
--------------------------------------------------------
AddAgenda(Title of the agenda, Manager (who edits it), Listeners (the ones who just see and follow the agenda))

WARNING: THE AGENDAS HAVE TO BE UNDER THE TEAMS IN SHARED.LUA. IF THEY ARE NOT, IT MIGHT MUCK UP!

The default agenda's, can also be used as examples:
*/
AddAgenda("Gangster's agenda", TEAM_MOB, {TEAM_GANG})
AddAgenda("Police agenda", TEAM_MAYOR, {TEAM_CHIEF, TEAM_POLICE})

var/list/weighted_randomevent_locations = list()
var/list/weighted_mundaneevent_locations = list()

/datum/trade_destination
	var/name = ""
	var/description = ""
	var/distance = 0
	var/list/willing_to_buy = list()
	var/list/willing_to_sell = list()
	var/can_shuttle_here = 0		//one day crew from the exodus will be able to travel to this destination
	var/list/viable_random_events = list()
	var/list/temp_price_change[BIOMEDICAL]
	var/list/viable_mundane_events = list()

/datum/trade_destination/proc/get_custom_eventstring(var/event_type)
	return null

//distance is measured in AU and co-relates to travel time
/datum/trade_destination/centcomm
	name = "StarComm"
	description = "NanoTrasen's administrative centre for NMF Persephone."
	distance = 1.2
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(SECURITY_BREACH, CORPORATE_ATTACK, AI_LIBERATION)
	viable_mundane_events = list(ELECTION, RESIGNATION, CELEBRITY_DEATH)

/datum/trade_destination/anansi
	name = "NMS Onward Towards Dawn"
	description = "Medical station ran by Second Red Cross (but owned by NT) for handling emergency cases from nearby colonies."
	distance = 1.7
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(SECURITY_BREACH, CULT_CELL_REVEALED, BIOHAZARD_OUTBREAK, PIRATES, ALIEN_RAIDERS)
	viable_mundane_events = list(RESEARCH_BREAKTHROUGH, RESEARCH_BREAKTHROUGH, BARGAINS, GOSSIP)

/datum/trade_destination/anansi/get_custom_eventstring(var/event_type)
	if(event_type == RESEARCH_BREAKTHROUGH)
		return "Thanks to research conducted on the NMS Onward Towards Dawn, Second Red Cross Society wishes to announce a major breakthough in the field of \
		[pick("mind-machine interfacing","neuroscience","nano-augmentation","genetics")]. [current_map.company_name] is expected to announce a co-exploitation deal within the fortnight."
	return null

/datum/trade_destination/icarus
	name = "NDV Styx"
	description = "Battleship assigned to patrol local space."
	distance = 0.1
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(SECURITY_BREACH, AI_LIBERATION, PIRATES)

/datum/trade_destination/redolant
	name = "DCS Lightning"
	description = "Dinoysus Conglomerate is in orbit around the only gas giant insystem. They retain tight control over shipping rights, and D.C Patrol Vessels protecting their prize are not an uncommon sight in Cerberus."
	distance = 0.6
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(INDUSTRIAL_ACCIDENT, PIRATES, CORPORATE_ATTACK)
	viable_mundane_events = list(RESEARCH_BREAKTHROUGH, RESEARCH_BREAKTHROUGH)

/datum/trade_destination/redolant/get_custom_eventstring(var/event_type)
	if(event_type == RESEARCH_BREAKTHROUGH)
		return "Thanks to research conducted on at Ascher Industries, Ascher wishes to announce a major breakthough in the field of \
		[pick("phoron research","high energy flux capacitance","super-compressed materials","theoretical particle physics")]. [current_map.company_name] is expected to announce a co-exploitation deal within the fortnight."
	return null

/datum/trade_destination/beltway
	name = "Luna Mining Colony"
	description = "A mining colony owned by the Interstellar Republic."
	distance = 7.5
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(PIRATES, INDUSTRIAL_ACCIDENT)
	viable_mundane_events = list(TOURISM)

/datum/trade_destination/biesel
	name = "Hades"
	description = "A frozen tundra with rich resources, Hades largely owes allegiance to Nanotrasen / Vessel Contracting and begrudgingly tolerates NT. Capital is Keep."
	distance = 2.3
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(RIOTS, INDUSTRIAL_ACCIDENT, BIOHAZARD_OUTBREAK, CULT_CELL_REVEALED, FESTIVAL, MOURNING)
	viable_mundane_events = list(BARGAINS, GOSSIP, SONG_DEBUT, MOVIE_RELEASE, ELECTION, TOURISM, RESIGNATION, CELEBRITY_DEATH)

/datum/trade_destination/new_gibson
	name = "Rhea"
	description = "Considered the Second Earth, Rhea is a lush planet with a stable economy and a prospering population."
	distance = 6.6
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(RIOTS, INDUSTRIAL_ACCIDENT, BIOHAZARD_OUTBREAK, CULT_CELL_REVEALED, FESTIVAL, MOURNING)
	viable_mundane_events = list(ELECTION, TOURISM, RESIGNATION)

//datum/trade_destination/luthien
	name = "Hera"
	description = "A small colony established on a feral, untamed world (largely jungle). Savages and wild beasts attack the outpost regularly, although NT maintains tight military control."
	distance = 8.9
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(WILD_ANIMAL_ATTACK, CULT_CELL_REVEALED, FESTIVAL, MOURNING, ANIMAL_RIGHTS_RAID, ALIEN_RAIDERS)
	viable_mundane_events = list(ELECTION, TOURISM, BIG_GAME_HUNTERS, RESIGNATION)

//datum/trade_destination/reade
	name = "Reade"
	description = "A cold, metal-deficient world, NT maintains large pastures in whatever available space in an attempt to salvage something from this profitless colony."
	distance = 7.5
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(WILD_ANIMAL_ATTACK, CULT_CELL_REVEALED, FESTIVAL, MOURNING, ANIMAL_RIGHTS_RAID, ALIEN_RAIDERS)
	viable_mundane_events = list(ELECTION, TOURISM, BIG_GAME_HUNTERS, RESIGNATION)

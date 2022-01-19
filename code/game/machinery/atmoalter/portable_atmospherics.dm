/obj/machinery/portable_atmospherics
	name = "atmoalter"
	use_power = 0
	var/datum/gas_mixture/air_contents = new

	var/obj/machinery/atmospherics/portables_connector/connected_port
	var/obj/item/tank/holding

	var/volume = 0
	var/destroyed = 0

	var/start_pressure = ONE_ATMOSPHERE
	var/maximum_pressure = 90 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/Destroy()
	qdel(air_contents)
	qdel(holding)
	return ..()

/obj/machinery/portable_atmospherics/Initialize()
	. = ..()

	air_contents.volume = volume
	air_contents.temperature = T20C

	var/obj/machinery/atmospherics/portables_connector/port = locate() in loc
	if(port)
		connect(port)

/obj/machinery/portable_atmospherics/canister/Initialize()
	..()

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/portable_atmospherics/canister/LateInitialize()
	update_icon()

/obj/machinery/portable_atmospherics/machinery_process()
	if(!connected_port) //only react when pipe_network will ont it do it for you
		//Allow for reactions
		air_contents.react()
	else
		update_icon()
		SSvueui.check_uis_for_change(src)

/obj/machinery/portable_atmospherics/Destroy()
	qdel(air_contents)

	return ..()

/obj/machinery/portable_atmospherics/proc/StandardAirMix()
	return list(
		GAS_OXYGEN = O2STANDARD * MolesForPressure(),
		GAS_NITROGEN = N2STANDARD *  MolesForPressure())

/obj/machinery/portable_atmospherics/proc/MolesForPressure(var/target_pressure = start_pressure)
	return (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature)

/obj/machinery/portable_atmospherics/update_icon()
	return null

/obj/machinery/portable_atmospherics/proc/connect(obj/machinery/atmospherics/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return 0

	//Make sure are close enough for a valid connection
	if(new_port.loc != loc)
		return 0

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src
	connected_port.on = 1 //Activate port updates

	anchored = 1 //Prevent movement

	//Actually enforce the air sharing
	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network && !network.gases.Find(air_contents))
		network.gases += air_contents
		network.update = 1

	return 1

/obj/machinery/portable_atmospherics/proc/disconnect()
	if(!connected_port)
		return 0

	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network)
		network.gases -= air_contents

	anchored = 0

	connected_port.connected_device = null
	connected_port = null

	return 1

/obj/machinery/portable_atmospherics/proc/update_connected_network()
	if(!connected_port)
		return

	var/datum/pipe_network/network = connected_port.return_network(src)
	if (network)
		network.update = 1

/obj/machinery/portable_atmospherics/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if ((istype(W, /obj/item/tank) && !( src.destroyed )))
		if (src.holding)
			return
		var/obj/item/tank/T = W
		user.drop_from_inventory(T,src)
		src.holding = T
		update_icon()
		SSvueui.check_uis_for_change(src)
		return

	else if (W.iswrench())
		if(connected_port)
			disconnect()
			to_chat(user, "<span class='notice'>You disconnect \the [src] from the port.</span>")
			update_icon()
			SSvueui.check_uis_for_change(src)
			return
		else
			var/obj/machinery/atmospherics/portables_connector/possible_port = locate(/obj/machinery/atmospherics/portables_connector/) in loc
			if(possible_port)
				if(connect(possible_port))
					to_chat(user, "<span class='notice'>You connect \the [src] to the port.</span>")
					update_icon()
					SSvueui.check_uis_for_change(src)
					return
				else
					to_chat(user, "<span class='notice'>\The [src] failed to connect to the port.</span>")
					return
			else
				to_chat(user, "<span class='notice'>Nothing happens.</span>")
				return

	else if ((istype(W, /obj/item/device/analyzer)) && Adjacent(user))
		var/obj/item/device/analyzer/A = W
		A.analyze_gases(src, user)
		return

	return ..()


/obj/machinery/portable_atmospherics/powered
	var/power_rating
	var/power_losses
	var/last_power_draw = 0
	var/obj/item/cell/cell
	has_special_power_checks = TRUE

/obj/machinery/portable_atmospherics/powered/powered()
	if(use_power) //using area power
		return ..()
	if(cell && cell.charge)
		return 1
	return 0

/obj/machinery/portable_atmospherics/powered/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(cell)
			to_chat(user, "There is already a power cell installed.")
			return

		var/obj/item/cell/C = I

		user.drop_from_inventory(C,src)
		C.add_fingerprint(user)
		cell = C
		user.visible_message("<span class='notice'>[user] opens the panel on [src] and inserts [C].</span>", "<span class='notice'>You open the panel on [src] and insert [C].</span>")
		power_change()
		SSvueui.check_uis_for_change(src)
		return

	if(I.isscrewdriver())
		if(!cell)
			to_chat(user, "<span class='warning'>There is no power cell installed.</span>")
			return

		user.visible_message("<span class='notice'>[user] opens the panel on [src] and removes [cell].</span>", "<span class='notice'>You open the panel on [src] and remove [cell].</span>")
		cell.add_fingerprint(user)
		cell.forceMove(src.loc)
		cell = null
		power_change()
		SSvueui.check_uis_for_change(src)
		return
	..()

/obj/machinery/portable_atmospherics/proc/log_open(var/mob/user)
	if(air_contents.gas.len == 0)
		return

	var/gases = ""
	for(var/gas in air_contents.gas)
		if(gases)
			gases += ", [gas]"
		else
			gases = gas

	if (!user && usr)
		user = usr

	log_admin("[user] ([user.ckey]) opened '[src.name]' containing [gases].", ckey=key_name(user))
	message_admins("[key_name_admin(user)] opened '[src.name]' containing [gases]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")

/obj/machinery/portable_atmospherics/proc/log_open_userless(var/cause)
	if(air_contents.gas.len == 0)
		return

	message_admins("'[src.name]' was opened[cause ? " by [cause]" : ""], containing [english_list(air_contents.gas)]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
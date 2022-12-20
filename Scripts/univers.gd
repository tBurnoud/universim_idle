extends Control

#loading Big library to handle really big numbers
const Big = preload("res://Scripts/Big.gd")
const Star = preload("res://Scripts/Star.gd")

#onready var testTab = preload("res://Scenes/Test.tscn").instance()

export(NodePath) var debugGraph
export(NodePath) var debugGraph2

enum unit_type {Scientific, AA}

var star : Star

var achievements_list = {"PP1" : false, "PP2" : false, "PP3" : false, "x1" : false, "x2" : false}

var canSupernova = false

var isDebug = false


func _ready():
	star = Star.new(unit_type.Scientific)
	
	var savefile = File.new()
	#checking if a save exist and if so, loading achievements from it
	if savefile.file_exists("Save/achievements.save"):
		savefile.open("Save/achievements.save", File.READ)
		var ach_data = parse_json(savefile.get_line())
		
		achievements_list = ach_data
	savefile.close()
	
	#check if a star save exist and if so, update displayed value accordingly
	if savefile.file_exists("Save/star.save"):
		if star.is_PP1_unlocked():
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/PP-Cycle/VBoxContainer/PP1unlock".visible = false

			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_rate_button".text = "Increase PP1 conversion rate (Cost : " + star.get_PP1_rate_cost_string() + ")"
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP1_rate".text = "Conversion rate : " + star.get_PP1_rate_string()
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_outputRate_button".text = "Increase PP1 output conversion rate (Cost : " + star.get_PP1_outputRate_cost_string() + ")"
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP1_outputRate".text = "Output conversion rate : " + star.get_PP1_outputRate_string()
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_chance_button".text = "Increase PP1 chance (Cost : " + star.get_PP1_chance_cost_string() + ")"
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP1_chance".text = "Chance for PP1 to happen : " + star.get_PP1_chance_string()

		if star.is_PP2_unlocked():
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/PP-Cycle/VBoxContainer/PP2unlock".visible = false
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP2_rate".visible = true
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP2_outputRate".visible = true
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP2_chance".visible = true
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP2_rate_button".visible = true
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP2_outputRate_button".visible = true
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP2_chance_button".visible = true
			
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP2_rate_button".text = "Increase PP2 conversion rate (Cost : " + star.get_PP2_rate_cost_string() + ")"
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP2_rate".text = "Conversion rate : " + star.get_PP2_rate_string()
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP2_outputRate_button".text = "Increase PP2 output conversion rate (Cost : " + star.get_PP2_outputRate_cost_string() + ")"
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP2_outputRate".text = "Output conversion rate : " + star.get_PP2_outputRate_string()
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP2_chance_button".text = "Increase PP2 chance (Cost : " + star.get_PP2_chance_cost_string() + ")"
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP2_chance".text = "Chance for PP2 to happen : " + star.get_PP2_chance_string()
		
		if star.is_PP3_unlocked():
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/PP-Cycle/VBoxContainer/PP3unlock".visible = false
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP3_rate".visible = true
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP3_outputRate".visible = true
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP3_chance".visible = true
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP3_rate_button".visible = true
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP3_outputRate_button".visible = true
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP3_chance_button".visible = true
		
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP3_rate_button".text = "Increase PP3 conversion rate (Cost : " + star.get_PP3_rate_cost_string() + ")"
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP3_rate".text = "Conversion rate : " + star.get_PP3_rate_string()
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP3_outputRate_button".text = "Increase PP3 output conversion rate (Cost : " + star.get_PP3_outputRate_cost_string() + ")"
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP3_outputRate".text = "Output conversion rate : " + star.get_PP3_outputRate_string()
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP3_chance_button".text = "Increase PP3 chance (Cost : " + star.get_PP3_chance_cost_string() + ")"
			$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP3_chance".text = "Chance for PP3 to happen : " + star.get_PP3_chance_string()
	
	var children = $Container/TabContainer/Achievements.get_children() 
	for i in children:
			i.set("shader_param/gotten", 0.0)
	
	$"Container/TabContainer/Options/VBoxContainer2/UnitType".add_item("scientific")
	$"Container/TabContainer/Options/VBoxContainer2/UnitType".add_item("AA")
	
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_rate_button".text = "Increase PP1 conversion rate (Cost : " + star.get_PP1_rate_cost_string() + ")"
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_outputRate_button".text = "Increase PP1 conversion rate (Cost : " + star.get_PP1_outputRate_cost_string() + ")"
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_chance_button".text = "Increase PP1 conversion rate (Cost : " + star.get_PP1_chance_cost_string() + ")"
	

	
	if debugGraph:
		var g1 = get_node(debugGraph)
		var g2 = get_node(debugGraph2)
		g1.record_point("energy", star.get_Energy())
		g1.record_point("dE", star.get_dE())
		g2.record_point("Temperature", star.get_Temperature())
		g2.record_point("Temperature loss", star.get_TempLoss())

func handle_achievements():
	var children = $Container/TabContainer/Achievements.get_children() 
	var i = 0
	for ach in achievements_list.values():
		if ach:
			children[i].material.set_shader_param("gotten", 1.0)
		i += 1

func _process(delta):
	if debugGraph:
		var g1 = get_node(debugGraph)
		var g2 = get_node(debugGraph2)
		
		if Input.is_action_just_pressed("debug_ui"):
			isDebug = not isDebug
			g1.visible = isDebug
			g2.visible = isDebug
		
		g1.record_point("energy", star.get_Energy())
		g1.record_point("dE", star.get_dE())
		g2.record_point("Temperature", star.get_Temperature())
		g2.record_point("Temperature loss", star.get_TempLoss())
		
		$"Container/topbar/EnergyContainer/Energy".text = star.get_Energy_string() + " EU"
		$"Container/topbar/EnergyContainer/deltaEnergy".text = " " + star.get_dE_string() + " EU/s"
		$"Container/topbar/EnergyContainer2/Pression".text = star.get_Pression_string() + " ??"
		$"Container/TabContainer/Star/StarInfos/Temperature".text = star.get_Temp_string() + " °K"
		$"Container/TabContainer/Star/StarInfos/Mass".text = star.sum_atoms_mass().toString() + " Solar Mass"
		$"Container/TabContainer/Cycles/Elements/H".text = star.get_H_string() + " H"
		$"Container/TabContainer/Cycles/Elements/He".text = star.get_He_string() + " He"
		$"Container/TabContainer/Cycles/Elements/Li".text = star.get_Li_string() + " Li"
		$"Container/TabContainer/Cycles/Elements/Be".text = star.get_Be_string() + " Be"
		$"Container/TabContainer/Cycles/Elements/B".text = star.get_B_string() + " B"
		
		if not canSupernova and star.canSupernova:
			canSupernova = true
			$"Container/TabContainer/Super Nova/VBoxContainer/Button".visible = true
			print("Supernova unlocked !")

func _on_gameTick_timeout():
	star.tick($gameTick.wait_time)
	
	handle_achievements()

func _on_PP1unlock_pressed():
	if not star.is_PP1_unlocked():
		star.unlock_PP1()
		achievements_list["PP1"] = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/PP-Cycle/VBoxContainer/PP1unlock".visible = false
		$"Container/TabContainer/Cycles/Elements/He".visible = true

func _on_PP2unlock_pressed():
	if not star.is_PP2_unlocked() and star.get_Temperature() >= 1.4e7:
		star.unlock_PP2()
		achievements_list["PP2"] = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/PP-Cycle/VBoxContainer/PP2unlock".visible = false
		$"Container/TabContainer/Cycles/Elements/Li".visible = true
		$"Container/TabContainer/Cycles/Elements/Be".visible = true
		$"Container/TabContainer/Cycles/Elements/B".visible = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP2_rate_button".visible = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP2_outputRate_button".visible = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP2_chance_button".visible = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP2_rate".visible = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP2_outputRate".visible = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP2_chance".visible = true

func _on_PP3unlock_pressed():
	if not star.is_PP3_unlocked() and star.get_Temperature() >= 2.3e7:
		star.unlock_PP3()
		achievements_list["PP3"] = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/PP-Cycle/VBoxContainer/PP3unlock".visible = false
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP3_rate_button".visible = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP3_outputRate_button".visible = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP3_chance_button".visible = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP3_rate".visible = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP3_outputRate".visible = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP3_chance".visible = true

func _on_TempUpgrade_pressed():
	if star.update_dE_contrib():
		$"Container/TabContainer/Star/UpgradeList/TempUpgrade".text = "Increase  dE contribution to Temperature (cost " + star.get_dE_contrib_cost_string() + ")"


func _on_PP1_rateUpgrade_pressed():
	var res = star.update_PP1rate_cost()
	if res:
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_rate_button".text = "Increase PP1 conversion rate (Cost : " + star.get_PP1_rate_cost_string() + ")"
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP1_rate".text = "Conversion rate : " + star.get_PP1_rate_string()


func _on_PP1_outputRate_button_pressed():
	var res = star.update_PP1outputRate_cost()
	if res:
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_outputRate_button".text = "Increase PP1 output conversion rate (Cost : " + star.get_PP1_outputRate_cost_string() + ")"
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP1_outputRate".text = "Output conversion rate : " + star.get_PP1_outputRate_string()


func _on_PP1_chance_button_pressed():
	var res = star.update_PP1chance_cost()
	if res:
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_chance_button".text = "Increase PP1 chance (Cost : " + star.get_PP1_chance_cost_string() + ")"
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP1_chance".text = "Chance for PP1 to happen : " + star.get_PP1_chance_string()


func _on_PP2_rate_button_pressed():
	var res = star.update_PP2rate_cost()
	if res:
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP2_rate_button".text = "Increase PP2 conversion rate (Cost : " + star.get_PP2_rate_cost_string() + ")"
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP2_rate".text = "Conversion rate : " + star.get_PP2_rate_string()

func _on_PP2_outputRate_button_pressed():
	var res = star.update_PP2outputRate_cost()
	if res:
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP2_outputRate_button".text = "Increase PP2 output conversion rate (Cost : " + star.get_PP2_outputRate_cost_string() + ")"
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP2_outputRate".text = "Output conversion rate : " + star.get_PP2_outputRate_string()

func _on_PP2_chance_button_pressed():
	var res = star.update_PP2chance_cost()
	if res:
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP2_chance_button".text = "Increase PP2 chance (Cost : " + star.get_PP2_chance_cost_string() + ")"
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP2_chance".text = "Chance for PP2 to happen : " + star.get_PP2_chance_string()

func _on_PP3_rate_button_pressed():	
	var res = star.update_PP3rate_cost()
	if res:
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP3_rate_button".text = "Increase PP3 conversion rate (Cost : " + star.get_PP3_rate_cost_string() + ")"
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP3_rate".text = "Conversion rate : " + star.get_PP3_rate_string()

	
func _on_PP3_chance_button_pressed():
	var res = star.update_PP3outputRate_cost()
	if res:
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP3_chance_button".text = "Increase PP3 chance (Cost : " + star.get_PP3_chance_cost_string() + ")"
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP3_chance".text = "Chance for PP3 to happen : " + star.get_PP3_chance_string()

func _on_PP3_outputRate_button_pressed():
	var res = star.update_PP3chance_cost()
	if res:
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP3_outputRate_button".text = "Increase PP3 output conversion rate (Cost : " + star.get_PP3_outputRate_cost_string() + ")"
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP3_outputRate".text = "Output conversion rate : " + star.get_PP3_outputRate_string()
	
func _on_Control_resized():
	pass # Replace with function body.


func _on_UnitType_item_selected(index):
	star.update_unit(index)
	
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_rate_button".text = "Increase PP1 conversion rate (Cost : " + star.get_PP1_rate_cost_string() + ")"
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP1_rate".text = "Conversion rate : " + star.get_PP1_rate_string()
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_outputRate_button".text = "Increase PP1 output conversion rate (Cost : " + star.get_PP1_outputRate_cost_string() + ")"
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP1_outputRate".text = "Output conversion rate : " + star.get_PP1_outputRate_string()
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_chance_button".text = "Increase PP1 chance (Cost : " + star.get_PP1_chance_cost_string() + ")"
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP1_chance".text = "Chance for PP1 to happen : " + star.get_PP1_chance_string()
	
	$"Container/TabContainer/Star/UpgradeList/TempUpgrade".text = "Increase  dE contribution to Temperature (cost " + star.get_dE_contrib_cost_string() + ")"
	
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP2_rate_button".text = "Increase PP2 conversion rate (Cost : " + star.get_PP2_rate_cost_string() + ")"
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP2_rate".text = "Conversion rate : " + star.get_PP2_rate_string()
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP2_outputRate_button".text = "Increase PP2 output conversion rate (Cost : " + star.get_PP2_outputRate_cost_string() + ")"
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP2_outputRate".text = "Output conversion rate : " + star.get_PP2_outputRate_string()
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP2_chance_button".text = "Increase PP2 chance (Cost : " + star.get_PP2_chance_cost_string() + ")"
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP2_chance".text = "Chance for PP2 to happen : " + star.get_PP2_chance_string()
	
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP3_rate_button".text = "Increase PP3 conversion rate (Cost : " + star.get_PP3_rate_cost_string() + ")"
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP3_rate".text = "Conversion rate : " + star.get_PP3_rate_string()
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP3_outputRate_button".text = "Increase PP3 output conversion rate (Cost : " + star.get_PP3_outputRate_cost_string() + ")"
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP3_outputRate".text = "Output conversion rate : " + star.get_PP3_outputRate_string()
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP3_chance_button".text = "Increase PP3 chance (Cost : " + star.get_PP3_chance_cost_string() + ")"
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/PP3_chance".text = "Chance for PP3 to happen : " + star.get_PP3_chance_string()
	
	$"Container/topbar/EnergyContainer/Energy".text = star.get_Energy_string() + " EU"
	$"Container/TabContainer/Star/StarInfos/Temperature".text = star.get_Temp_string() + " °K"
	$"Container/TabContainer/Star/StarInfos/Mass".text = star.sum_atoms_mass().toString() + "    Solar Mass"
	$"Container/TabContainer/Cycles/Elements/H".text = star.get_H_string() + " H"
	$"Container/TabContainer/Cycles/Elements/He".text = star.get_He_string() + " He"
	$"Container/TabContainer/Cycles/Elements/Li".text = star.get_Li_string() + " Li"
	$"Container/TabContainer/Cycles/Elements/Be".text = star.get_Be_string() + " Be"
	$"Container/TabContainer/Cycles/Elements/B".text = star.get_B_string() + " B"


func _on_SaveConfig_pressed():
	star.export_config()



func _on_SaveStar_pressed():
	var save_game = File.new()
	save_game.open("Save/star.save", File.WRITE)
	var save_nodes = self.get_tree().get_nodes_in_group("Persist")
	save_nodes.append(star)
	for node in save_nodes:
		print("saving node " + str(node))
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	
	save_game.close()
	
	save_game.open("Save/achievements.save", File.WRITE)
	
	save_game.store_line(to_json(achievements_list))
	
	save_game.close()


func _on_Button_pressed():
	print("zbrrrrrrrrrrrrrrrrrrrrr...")
	pass # Replace with function body.



func _on_LoadConfig_pressed():
	star.reload_config()


func _on_saveTimer_timeout():
	_on_SaveStar_pressed()


func _on_HSlider_value_changed(value):
	$"saveTimer".wait_time = value
	$"Container/TabContainer/Options/VBoxContainer3/saveInterval".text = "Save interval : " + str(value) + "s"

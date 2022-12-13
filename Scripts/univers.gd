extends Control

#loading Big library to handle really big numbers
const Big = preload("res://Scripts/Big.gd")
const Star = preload("res://Scripts/Star.gd")

export(NodePath) var debugGraph
export(NodePath) var debugGraph2

enum unit_type {Scientific, AA}

var star : Star

var achievements_list = []

var isDebug = false

func _ready():
	star = Star.new(unit_type.Scientific)
	
	var children = $Container/TabContainer/Achievements.get_children() 
	for i in children:
			achievements_list.append(false)
			i.set("shader_param/gotten", 0.0)
	
	$"Container/TabContainer/Options/VBoxContainer2/UnitType".add_item("scientific")
	$"Container/TabContainer/Options/VBoxContainer2/UnitType".add_item("AA")
	
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
	for ach in achievements_list:
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
		
		$"Container/topbar/EnergyContainer/Energy".text = star.get_Energy_string() + " eV"
		$"Container/topbar/EnergyContainer/deltaEnergy".text = " " + star.get_dE_string() + " eV/s"
		$"Container/topbar/EnergyContainer2/Pression".text = star.get_Pression_string() + " ??"
		$"Container/TabContainer/Star/StarInfos/Temperature".text = star.get_Temp_string() + " °K"
		$"Container/TabContainer/Star/StarInfos/Mass".text = star.sum_atoms_mass().toString() + " Solar Mass"
		$"Container/TabContainer/Cycles/Elements/H".text = star.get_H_string() + " H"
		$"Container/TabContainer/Cycles/Elements/He".text = star.get_He_string() + " He"
		$"Container/TabContainer/Cycles/Elements/Li".text = star.get_Li_string() + " Li"
		$"Container/TabContainer/Cycles/Elements/Be".text = star.get_Be_string() + " Be"
		$"Container/TabContainer/Cycles/Elements/B".text = star.get_B_string() + " B"

func _on_gameTick_timeout():
	star.tick($gameTick.wait_time)
	
	handle_achievements()

func _on_PP1unlock_pressed():
	if not star.is_PP1_unlocked():
		star.unlock_PP1()
		achievements_list[0] = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/PP-Cycle/VBoxContainer/PP1unlock".visible = false
		$"Container/TabContainer/Cycles/Elements/He".visible = true

func _on_PP2unlock_pressed():
	if not star.is_PP2_unlocked() and star.get_Temperature() >= 1.4e7:
		star.unlock_PP2()
		achievements_list[1] = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/PP-Cycle/VBoxContainer/PP2unlock".visible = false
		$"Container/TabContainer/Cycles/Elements/Li".visible = true
		$"Container/TabContainer/Cycles/Elements/Be".visible = true
		$"Container/TabContainer/Cycles/Elements/B".visible = true

func _on_PP3unlock_pressed():
	if not star.is_PP3_unlocked() and star.get_Temperature() >= 2.3e7:
		star.unlock_PP3()
		achievements_list[2] = true
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/PP-Cycle/VBoxContainer/PP3unlock".visible = false


func _on_TempUpgrade_pressed():
	pass
#	if false and energy.isLargerThanOrEqualTo(CostTempUpgrade):
#		energy.minus(CostTempUpgrade)
#		Temperature.plus(tempIncrease)
#
#		tempIncrease.multiply(1.33)
#		CostTempUpgrade.multiply(2)
#
#		$"Container/TabContainer/Star/UpgradeList/TempUpgrade".text = "Increase Star temperature (Cost : " + CostTempUpgrade.toScientific() + ")"


func _on_PP1_rateUpgrade_pressed():
	var res = star.update_PP1rate_cost()
	if res:
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_rate_button".text = "Increase PP1 conversion rate (Cost : " + star.get_PP1_rate_cost_string() + ")"
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/rate".text = "Conversion rate : " + star.get_PP1_rate_string()


func _on_PP1_outputRate_button_pressed():
	var res = star.update_PP1outputRate_cost()
	if res:
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_outputRate_button".text = "Increase PP1 output conversion rate (Cost : " + star.get_PP1_outputRate_cost_string() + ")"
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/outputRate".text = "Output conversion rate : " + star.get_PP1_outputRate_string()


func _on_PP1_chance_button_pressed():
	var res = star.update_PP1chance_cost()
	if res:
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_chance_button".text = "Increase PP1 chance (Cost : " + star.get_PP1_chance_cost_string() + ")"
		$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/chance".text = "Chance for PP1 to happen : " + star.get_PP1_chance_string()


func _on_Control_resized():
	pass # Replace with function body.


func _on_UnitType_item_selected(index):
	star.update_unit(index)
	
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_rate_button".text = "Increase PP1 conversion rate (Cost : " + star.get_PP1_rate_cost_string() + ")"
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/rate".text = "Conversion rate : " + star.get_PP1_rate_string()
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_outputRate_button".text = "Increase PP1 output conversion rate (Cost : " + star.get_PP1_outputRate_cost_string() + ")"
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/outputRate".text = "Output conversion rate : " + star.get_PP1_outputRate_string()
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Upgrades/PP1_chance_button".text = "Increase PP1 chance (Cost : " + star.get_PP1_chance_cost_string() + ")"
	$"Container/TabContainer/Cycles/FusionsTab/Hydrogen/Upgrades/HBoxContainer/Stats/chance".text = "Chance for PP1 to happen : " + star.get_PP1_chance_string()
	
	$"Container/topbar/EnergyContainer/Energy".text = star.get_Energy_string() + "    eV"
	$"Container/TabContainer/Star/StarInfos/Temperature".text = star.get_Temp_string() + "    °K"
	$"Container/TabContainer/Star/StarInfos/Mass".text = star.sum_atoms_mass().toString() + "    Solar Mass"
	$"Container/TabContainer/Cycles/Elements/H".text = star.get_H_string() + " H"
	$"Container/TabContainer/Cycles/Elements/He".text = star.get_He_string() + " He"
	$"Container/TabContainer/Cycles/Elements/Li".text = star.get_Li_string() + " Li"
	$"Container/TabContainer/Cycles/Elements/Be".text = star.get_Be_string() + " Be"
	$"Container/TabContainer/Cycles/Elements/B".text = star.get_B_string() + " B"


func _on_SaveConfig_pressed():
	star.export_config()



func _on_SaveStar_pressed():
	star.export_save()

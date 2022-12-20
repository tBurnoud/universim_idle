extends Node

#loading Big library to handle really big numbers
const Big = preload("res://Scripts/Big.gd")
const starData = preload("res://Scripts/StarData.gd")

enum unit_type {Scientific, AA}

class_name Star
var data
var config = ConfigFile.new()

var energy = Big.new(0,0)
var dE = Big.new(2.5,-2)

var pression = Big.new(0,0)
var dP = Big.new(0,0)

var temperatureLoss = Big.new(1)

var Temperature = Big.new(1,7)
var Mass = Big.new(8, -1)

var H_mass = Big.new(0)
var He_mass = Big.new(0)
var Li_mass = Big.new(0)
var Be_mass = Big.new(0)
var B_mass = Big.new(0)

var dE_contrib_to_temp : Big
var dE_contrib_cost : Big

var PP1_rate = Big.new(8,0)
var PP1_chance = Big.new(1, -1)
var PP1_outputRate = Big.new(1,0)
var PP2_rate = Big.new(1, 0)
var PP2_chance = Big.new(1, -1)
var PP2_outputRate = Big.new(1,0)
var PP3_rate = Big.new(1, 0)
var PP3_chance = Big.new(1, -1)
var PP3_outputRate = Big.new(1,0)

onready var is_PP1_unlocked = false
onready var is_PP2_unlocked = false
onready var is_PP3_unlocked = false

var SupernovaVal = Big.new(2,0)

var dE_list = []
var dE_filter = []

#var CostTempUpgrade = Big.new(1,1)
var tempIncrease = Big.new(1, 4)

var PP1_rate_cost = Big.new(10)
var PP1_outputRate_cost = Big.new(50)
var PP1_chance_cost = Big.new(15)

var PP2_rate_cost = Big.new(250)
var PP2_outputRate_cost = Big.new(500)
var PP2_chance_cost = Big.new(420)

var PP3_rate_cost = Big.new(2500)
var PP3_outputRate_cost = Big.new(5000)
var PP3_chance_cost = Big.new(4269)

var noFusion_cpt = 0
var canSupernova = false

var type = null

func reload_config():
	data.load_configFile("Save/starConfig.cfg")

func init_from_save(savefile):

#	while savefile.get_position() < savefile.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(savefile.get_line())
		
		Temperature = Big.new(node_data["Temperature"])
		dE_contrib_to_temp = Big.new(node_data["dE_contrib_to_temp"])
		
		is_PP1_unlocked = node_data["PP1_unlock"]
		is_PP2_unlocked = node_data["PP2_unlock"]
		is_PP3_unlocked = node_data["PP3_unlock"]
		
		He_mass = Big.new(node_data["He_mass"])
		H_mass = Big.new(node_data["H_mass"])
		Li_mass = Big.new(node_data["Li_mass"])
		Be_mass = Big.new(node_data["Be_mass"])
		B_mass = Big.new(node_data["B_mass"])
		
		PP1_rate = Big.new(node_data["PP1_rate"])
		PP1_outputRate = Big.new(node_data["PP1_outputRate"])
		PP1_chance = Big.new(node_data["PP1_chance"])
		
		PP2_rate = Big.new(node_data["PP2_rate"])
		PP2_outputRate = Big.new(node_data["PP2_outputRate"])
		PP2_chance = Big.new(node_data["PP2_chance"])
		
		PP3_rate = Big.new(node_data["PP3_rate"])
		PP3_outputRate = Big.new(node_data["PP3_outputRate"])
		PP3_chance = Big.new(node_data["PP3_chance"])
		
		PP1_rate_cost = Big.new(node_data["PP1_rate_cost"])
		PP1_outputRate_cost = Big.new(node_data["PP1_outputRate_cost"])
		PP1_chance_cost = Big.new(node_data["PP1_chance_cost"])
		
		PP2_rate_cost = Big.new(node_data["PP2_rate_cost"])
		PP2_outputRate_cost = Big.new(node_data["PP2_outputRate_cost"])
		PP2_chance_cost = Big.new(node_data["PP2_chance_cost"])
		
		PP3_rate_cost = Big.new(node_data["PP3_rate_cost"])
		PP3_outputRate_cost = Big.new(node_data["PP3_outputRate_cost"])
		PP3_chance_cost = Big.new(node_data["PP3_chance_cost"])

func init_from_cfg(data):
	
	Temperature = Big.new(data.Temperature)
	dE_contrib_to_temp = Big.new(data.dE_contrib_to_temp)
	dE_contrib_cost = Big.new(data.dE_contrib_cost)
#	temperatureLoss = Big.new(data.init_TempLoss)
#	dE = config.get_value("base", "base_dE")
	
	H_mass = Big.new(data.H_mass)
	He_mass = Big.new(data.He_mass)
	Li_mass = Big.new(data.Li_mass)
	Be_mass = Big.new(data.Be_mass)
	B_mass = Big.new(data.B_mass)
	
	PP1_rate = Big.new(data.PP1_rate)
	PP1_outputRate = Big.new(data.PP1_outputRate)
	PP1_chance = Big.new(data.PP1_chance)
	
	PP2_rate = Big.new(data.PP2_rate)
	PP2_outputRate = Big.new(data.PP2_outputRate)
	PP2_chance = Big.new(PP2_chance)
	
	PP3_rate = Big.new(PP3_rate)
	PP3_outputRate = Big.new(PP3_outputRate)
	PP3_chance = Big.new(PP3_chance)
	
	PP1_rate_cost = Big.new(data.PP1_rate_cost)
	PP1_outputRate_cost = Big.new(data.PP1_outputRate_cost)
	PP1_chance_cost = Big.new(data.PP1_chance_cost)
	
	PP2_rate_cost = Big.new(data.PP2_rate_cost)
	PP2_outputRate_cost = Big.new(data.PP2_outputRate_cost)
	PP2_chance_cost = Big.new(data.PP2_chance_cost)
	
	PP3_rate_cost = Big.new(data.PP3_rate_cost)
	PP3_outputRate_cost = Big.new(data.PP3_outputRate_cost)
	PP3_chance_cost = Big.new(data.PP3_chance_cost)
	
func _init(type=unit_type.Scientific):	
	dE_list.append(Big.new(1.9794, 7).divide(1e6))		#0 energy output for 4h -> He + 2H
	dE_list.append(Big.new(1.59,6).divide(1e6))			#1 energy output for 2He -> Be
	dE_list.append(Big.new(8.6, 5).divide(1e6))			#2 energy output for Be -> Li
	dE_list.append(Big.new(1.735, 7).divide(1e6))		#3 energy output for Li + H -> 2He
	dE_list.append(Big.new(1.821, 7).divide(1e6))		#4 energy output for Be -> 2He
	self.type = type
	self.filename = "star.save"
	
	for _i in range(0, 100):
		dE_filter.append(float(0.0))
	
	var file = File.new()
	if file.file_exists("Save/star.save"):
		file.open("Save/star.save", File.READ)
		print("save file found !")
		init_from_save(file)
	else:
		data = StarData.new()
		init_from_cfg(data)
	
func update_unit(index:int):
	print(index)
	print(unit_type.keys())
	self.type = unit_type.values()[index]

func sum_atoms_mass() -> Big:
	var sum = Big.new(0,0)
	var div = Big.new(1.988,30)
	sum.plus(H_mass)
	sum.plus(He_mass)
	sum.plus(Li_mass)
	sum.plus(Be_mass)
	sum.plus(B_mass)
	
	return sum.divide(div)

func tick(delta : float):
	var tmp_dE = Big.new(dE)
	var temp = Big.new(PP1_rate)
	temp.multiply(H_mass.log10(H_mass.toFloat()*100))
#	temp.multiply(0.000000001)
	temp.multiply(delta)
	var temp2 = Big.new(H_mass)
	temp2.multiply(delta)
	temp = Big.min(temp, temp2)
	var tmp = Big.new(0,0)
	var tmp2 = Big.new(0,0)
	
	var rng1 = randf()
	var rng2 = randf()
	var rng3 = randf()
	
	if is_PP1_unlocked and H_mass.isLargerThanOrEqualTo(temp.toFloat() * 2.0) and PP1_chance.isLargerThanOrEqualTo(rng1):
		tmp2 = Big.new(temp)
		tmp2.multiply(PP1_outputRate)
		He_mass.plus(tmp2)
		H_mass.minus(temp.multiply(2.0))
		tmp = Big.new(dE_list[0])
		tmp.multiply(PP1_rate)
		tmp.multiply(temp)
		tmp.multiply(delta)
		tmp_dE.plus(tmp)
	elif is_PP1_unlocked and H_mass.isLessThanOrEqualTo(SupernovaVal):
		canSupernova = true
	
	temp = Big.new(PP2_rate)
	temp.multiply(He_mass)
	temp.multiply(0.00001)
	temp.multiply(delta)
	temp2 = Big.new(He_mass)
	temp2.multiply(delta)
	temp = Big.min(temp, temp2)
	
	if is_PP2_unlocked and He_mass.isLargerThanOrEqualTo(temp) and PP2_chance.isLargerThanOrEqualTo(rng2):
		temp = Big.new(PP2_rate.toFloat()*delta)
		tmp2 = Big.new(temp)
		tmp2.multiply(PP2_outputRate)
		if He_mass.isLargerThanOrEqualTo(temp.toFloat()*2.0):
			He_mass.minus(temp)
			Be_mass.plus(tmp2)
			tmp = Big.new(dE_list[1])
			tmp.multiply(PP2_rate)
			tmp_dE.plus(tmp)
		if Be_mass.isLargerThanOrEqualTo(PP2_rate):
			Be_mass.minus(PP2_rate)
			Li_mass.plus(PP2_rate)
			tmp_dE.plus(dE_list[2])
		if Li_mass.isLargerThanOrEqualTo(PP2_rate) and H_mass.isLargerThanOrEqualTo(PP2_rate):
			H_mass.minus(PP2_rate)
			Li_mass.minus(PP2_rate)
			He_mass.plus(temp)
			tmp = Big.new(dE_list[3])
			tmp.multiply(PP2_rate)
			tmp_dE.plus(tmp.toFloat()*delta)
			
	temp = Big.new(PP3_rate)
	temp.multiply(He_mass)
	temp.multiply(0.00001)
	temp.multiply(delta)
	temp2 = Big.new(He_mass)
	temp2.multiply(delta)
	temp = Big.min(temp, temp2)
	
	if is_PP3_unlocked and PP3_chance.isLargerThanOrEqualTo(rng3):
		temp = Big.new(PP3_rate.toFloat()*delta)
		temp.multiply(2.0)
		if He_mass.isLargerThanOrEqualTo(temp):
			He_mass.minus(temp)
			Be_mass.plus(PP3_rate)
			tmp = Big.new(dE_list[2])
			tmp.multiply(PP3_rate)
			tmp_dE.plus(tmp.toFloat()*delta)
		if Be_mass.isLargerThanOrEqualTo(temp):
			Be_mass.minus(temp)
			tmp = Big.new(dE_list[4])
			tmp.multiply(temp)
			tmp_dE.plus(tmp.toFloat()*delta)
			
	tmp = Big.new(tmp_dE).multiply(delta)
	energy.plus(tmp)
	dE_filter.push_front(tmp.toFloat())
	dE_filter.pop_back()
	var res = Big.new(str(get_dE()))
	if res:
		updateTemperature(res, delta)
	
	updatePression()
	
func updateTemperature(var dE : Big, var delta:float):
	if not dE:
		return
	var tmp = Big.new(dE)
	tmp.multiply(dE_contrib_to_temp)
#	tmp.divide(Big.new(Temperature).square())
#	tmp.multiply(1024.0)

	Temperature.plus(tmp)
	


func updatePression():
	var sum = Big.new(0,0)
	var tmp = Big.new(H_mass)
	tmp.multiply(1)
	sum.plus(tmp)
	tmp = Big.new(He_mass)
	tmp.multiply(2)
	sum.plus(tmp)
	sum.plus(tmp)
	tmp = Big.new(He_mass)
	tmp.multiply(4)
	sum.plus(tmp)
	tmp = Big.new(He_mass)
	tmp.multiply(8)
	sum.plus(tmp)
	
	pression = Big.new(sum)

func update_dE_contrib():
	if energy.isLargerThanOrEqualTo(0.0):
		dE_contrib_to_temp.multiply(2)
		
		return true
	return false

func update_PP1rate_cost():
	var tmp
	if energy.isLargerThanOrEqualTo(PP1_rate_cost):
		energy.minus(PP1_rate_cost)
		tmp = Big.new(1.05)
		PP1_rate.multiply(tmp)
		tmp = Big.new(2)
		PP1_rate_cost.multiply(tmp)
		return true
	
	return false
	
func update_PP1outputRate_cost():
	var tmp
	if energy.isLargerThanOrEqualTo(PP1_outputRate_cost):
		energy.minus(PP1_outputRate_cost)
		tmp = Big.new(5, -2)
		PP1_outputRate.plus(tmp)
		tmp = Big.new(2, 1)
		PP1_outputRate_cost.multiply(tmp)
		return true
	
	return false

func update_PP1chance_cost():
	var tmp
	if energy.isLargerThanOrEqualTo(PP1_chance_cost) and PP1_chance.isLessThanOrEqualTo(1.0):
		energy.minus(PP1_chance_cost)
		tmp = Big.new(0.05)
		PP1_chance.plus(tmp)
		tmp = Big.new(2,1)
		PP1_chance_cost.multiply(tmp)
		return true
	
	return false
	
func update_PP2rate_cost():
	if not is_PP2_unlocked:
		return false
	var tmp
	if energy.isLargerThanOrEqualTo(PP2_rate_cost):
		energy.minus(PP2_rate_cost)
		tmp = Big.new(1.05)
		PP2_rate.multiply(tmp)
		tmp = Big.new(2)
		PP2_rate_cost.multiply(tmp)
		return true
	
	return false

func update_PP2outputRate_cost():
	if not is_PP2_unlocked:
		return false
	var tmp
	if energy.isLargerThanOrEqualTo(PP2_outputRate_cost):
		energy.minus(PP2_outputRate_cost)
		tmp = Big.new(5, -2)
		PP2_outputRate.plus(tmp)
		tmp = Big.new(2, 1)
		PP2_outputRate_cost.multiply(tmp)
		return true
	
	return false

func update_PP2chance_cost():
	if not is_PP2_unlocked:
		return false
	var tmp
	if energy.isLargerThanOrEqualTo(PP2_chance_cost) and PP2_chance.isLessThanOrEqualTo(1.0):
		energy.minus(PP2_chance_cost)
		tmp = Big.new(0.05)
		PP2_chance.plus(tmp)
		tmp = Big.new(2,1)
		PP2_chance_cost.multiply(tmp)
		return true
	
	return false

func update_PP3rate_cost():
	if not is_PP3_unlocked:
		return false
	var tmp
	if energy.isLargerThanOrEqualTo(PP3_rate_cost):
		energy.minus(PP3_rate_cost)
		tmp = Big.new(1.05)
		PP3_rate.multiply(tmp)
		tmp = Big.new(2)
		PP3_rate_cost.multiply(tmp)
		return true
	
	return false

func update_PP3outputRate_cost():
	if not is_PP3_unlocked:
		return false
	var tmp
	if energy.isLargerThanOrEqualTo(PP3_outputRate_cost):
		energy.minus(PP3_outputRate_cost)
		tmp = Big.new(5, -2)
		PP3_outputRate.plus(tmp)
		tmp = Big.new(2, 1)
		PP3_outputRate_cost.multiply(tmp)
		return true
	
	return false

func update_PP3chance_cost():
	if not is_PP3_unlocked:
		return false
	var tmp
	if energy.isLargerThanOrEqualTo(PP3_chance_cost) and PP3_chance.isLessThanOrEqualTo(1.0):
		energy.minus(PP3_chance_cost)
		tmp = Big.new(0.05)
		PP3_chance.plus(tmp)
		tmp = Big.new(2,1)
		PP3_chance_cost.multiply(tmp)
		return true
	
	return false


#Getters for star variables as float
func get_Temperature() -> float:
	return Temperature.toFloat()

func get_TempLoss() -> float:
	return temperatureLoss.toFloat()

func get_Energy() -> float:
	return energy.toFloat()

func get_dE() -> float:
	var res : float
	res = 0.0
	var size = dE_filter.size()
	for x in dE_filter:
		res = x + res
	res = res / size
	return res


	
	
func get_PP1_rate_cost() -> float:
	return PP1_rate_cost.toFloat()
	
#Getters for star variables as STRING
func get_dE_string():
	var res = Big.new(str(get_dE()))
	if self.type == unit_type.Scientific:
		return res.toScientific()
	elif self.type == unit_type.AA:
		return res.toAA()
	return res.toString()

func get_dE_contrib_cost_string():
	if self.type == unit_type.Scientific:
		return dE_contrib_cost.toScientific()
	elif self.type == unit_type.AA:
		return dE_contrib_cost.toAA()
	return dE_contrib_cost.toString()

func get_Energy_string() -> String:
	if self.type == unit_type.Scientific:
		return energy.toScientific()
	elif self.type == unit_type.AA:
		return energy.toAA()
	return energy.toString()
	
func get_Pression_string() -> String:
	if self.type == unit_type.Scientific:
		return pression.toScientific()
	elif self.type == unit_type.AA:
		return pression.toAA()
	return pression.toString()
	
func get_TempLoss_string() -> String:
	if self.type:
		if self.type == unit_type.Scientific:
			return temperatureLoss.toScientific()
		elif self.type == unit_type.AA:
			return temperatureLoss.toAA()
	return temperatureLoss.toString()

func get_Temp_string() -> String:
	if self.type == unit_type.Scientific:
		return Temperature.toScientific()
	elif self.type == unit_type.AA:
		return Temperature.toAA()
	
	return Temperature.toString()

func get_H_string() -> String:
	if self.type == unit_type.Scientific:
		return H_mass.toScientific()
	elif self.type == unit_type.AA:
		return H_mass.toAA()

	return H_mass.toString()

func get_He_string() -> String:
	if self.type == unit_type.Scientific:
		return He_mass.toScientific()
	elif self.type == unit_type.AA:
		return He_mass.toAA()
	
	return He_mass.toString()
	
func get_Li_string() -> String:
	if self.type == unit_type.Scientific:
		return Li_mass.toScientific()
	elif self.type == unit_type.AA:
		return Li_mass.toAA()
	
	return Li_mass.toString()

func get_Be_string() -> String:
	if self.type == unit_type.Scientific:
		return Be_mass.toScientific()
	elif self.type == unit_type.AA:
		return Be_mass.toAA()
	
	return Be_mass.toString()
	
func get_B_string() -> String:
	if self.type == unit_type.Scientific:
		return B_mass.toScientific()
	elif self.type == unit_type.AA:
		return B_mass.toAA()
	
	return B_mass.toString()

func get_PP1_rate_cost_string() -> String:
	if self.type == unit_type.Scientific:
		return PP1_rate_cost.toScientific()
	elif self.type == unit_type.AA:
		return PP1_rate_cost.toAA()
	
	return PP1_rate_cost.toString()

func get_PP1_rate_string() -> String:
	if self.type == unit_type.Scientific:
		return PP1_rate.toScientific()
	elif self.type == unit_type.AA:
		return PP1_rate.toAA()

	return PP1_rate.toString()

func get_PP1_outputRate_cost_string() -> String:
	if self.type == unit_type.Scientific:
		return PP1_outputRate_cost.toScientific()
	elif self.type == unit_type.AA:
		return PP1_outputRate_cost.toAA()

	return PP1_outputRate_cost.toString()

func get_PP1_outputRate_string() -> String:
	if self.type == unit_type.Scientific:
		return PP1_outputRate.toScientific()
	elif self.type == unit_type.AA:
		return PP1_outputRate.toAA()

	return PP1_outputRate.toString()

func get_PP1_chance_string() -> String:
	return PP1_chance.toAA()

func get_PP1_chance_cost_string() -> String:
	if self.type == unit_type.Scientific:
		return PP1_chance_cost.toScientific()
	elif self.type == unit_type.AA:
		return PP1_chance_cost.toAA()
	
	return PP1_chance_cost.toString()

func get_PP2_rate_cost_string() -> String:
	if self.type == unit_type.Scientific:
		return PP2_rate_cost.toScientific()
	elif self.type == unit_type.AA:
		return PP2_rate_cost.toAA()
	
	return PP2_rate_cost.toString()

func get_PP2_rate_string() -> String:
	if self.type == unit_type.Scientific:
		return PP2_rate.toScientific()
	elif self.type == unit_type.AA:
		return PP2_rate.toAA()

	return PP2_rate.toString()

func get_PP2_outputRate_cost_string() -> String:
	if self.type == unit_type.Scientific:
		return PP2_outputRate_cost.toScientific()
	elif self.type == unit_type.AA:
		return PP2_outputRate_cost.toAA()

	return PP2_outputRate_cost.toString()

func get_PP2_outputRate_string() -> String:
	if self.type == unit_type.Scientific:
		return PP2_outputRate.toScientific()
	elif self.type == unit_type.AA:
		return PP2_outputRate.toAA()

	return PP2_outputRate.toString()

func get_PP2_chance_string() -> String:
	return PP2_chance.toAA()

func get_PP2_chance_cost_string() -> String:
	if self.type == unit_type.Scientific:
		return PP2_chance_cost.toScientific()
	elif self.type == unit_type.AA:
		return PP2_chance_cost.toString()
		
	return PP2_chance_cost.toAA()
	
	return PP2_chance_cost.toString()
	
func get_PP3_rate_cost_string() -> String:
	if self.type == unit_type.Scientific:
		return PP3_rate_cost.toScientific()
	elif self.type == unit_type.AA:
		return PP3_rate_cost.toAA()
	
	return PP3_rate_cost.toString()

func get_PP3_rate_string() -> String:
	if self.type == unit_type.Scientific:
		return PP3_rate.toScientific()
	elif self.type == unit_type.AA:
		return PP3_rate.toAA()

	return PP3_rate.toString()

func get_PP3_outputRate_cost_string() -> String:
	if self.type == unit_type.Scientific:
		return PP3_outputRate_cost.toScientific()
	elif self.type == unit_type.AA:
		return PP3_outputRate_cost.toAA()

	return PP3_outputRate_cost.toString()

func get_PP3_outputRate_string() -> String:
	if self.type == unit_type.Scientific:
		return PP3_outputRate.toScientific()
	elif self.type == unit_type.AA:
		return PP3_outputRate.toAA()

	return PP3_outputRate.toString()

func get_PP3_chance_string() -> String:
	return PP3_chance.toAA()

func get_PP3_chance_cost_string() -> String:
	if self.type == unit_type.Scientific:
		return PP3_chance_cost.toScientific()
	elif self.type == unit_type.AA:
		return PP3_chance_cost.toAA()
	
	return PP3_chance_cost.toString()
	

func get_dE_contring_to_temp_string():
	if self.type == unit_type.Scientific:
		return dE_contrib_to_temp.toScientific()
	elif self.type == unit_type.AA:
		return dE_contrib_to_temp.toAA()

#Getting PP1 flag 
func is_PP1_unlocked() -> bool:
	return self.is_PP1_unlocked

#setting PP1 flag to true
func unlock_PP1():
	self.is_PP1_unlocked = true

#Getting PP2 flag 
func is_PP2_unlocked() -> bool:
	return self.is_PP2_unlocked

#setting PP2 flag to true
func unlock_PP2():
	self.is_PP2_unlocked = true
	
#Getting PP3 flag 
func is_PP3_unlocked() -> bool:
	return self.is_PP3_unlocked

#setting PP3 flag to true
func unlock_PP3():
	self.is_PP3_unlocked = true

func export_config():
	
	data.export_config()
	
	var config = {
		"list 1" : {
			"0" : 1e6,
			"1" : 2e6
		},
		"list 2" : {
			"lama" : 42,
			"oui" : 69
		}
		
	}
	
	var file = File.new()
	var location = "save_config.txt"

	print("saving config to : " + OS.get_user_data_dir())
	if file.open(location, file.WRITE) != 0:
		printerr("Cannot write file at " + location)
	else:
		file.store_string(to_json(config))
#		file.store_line(to_json(config))
		file.close()

#Save the star data  into a file 
func save():
	var save_dict = {
		"Temperature" : get_Temp_string(),
		"dE_contrib_to_temp" : get_dE_contring_to_temp_string(),
		
		"PP1_unlock" : is_PP1_unlocked,
		"PP2_unlock" : is_PP2_unlocked,
		"PP3_unlock" : is_PP3_unlocked,
		
		"H_mass" : get_H_string(),
		"He_mass" : get_He_string(),
		"Li_mass" : get_Li_string(),
		"Be_mass" : get_Be_string(),
		"B_mass" : get_B_string(),
	
		"PP1_rate" : get_PP1_rate_string(),
		"PP1_outputRate" : get_PP1_outputRate_string(),
		"PP1_chance" : get_PP1_chance_string(),
	
		"PP2_rate" : get_PP2_rate_string(),
		"PP2_outputRate" : get_PP2_outputRate_string(),
		"PP2_chance" : get_PP2_chance_string(),
	
		"PP3_rate" : get_PP3_rate_string(),
		"PP3_outputRate" : get_PP3_outputRate_string(),
		"PP3_chance" : get_PP3_chance_string(),
	
		"PP1_rate_cost" : get_PP1_rate_cost_string(),
		"PP1_outputRate_cost" : get_PP1_outputRate_cost_string(),
		"PP1_chance_cost" : get_PP1_chance_cost_string(),
	
		"PP2_rate_cost" : get_PP2_rate_cost_string(),
		"PP2_outputRate_cost" : get_PP2_outputRate_cost_string(),
		"PP2_chance_cost" : get_PP2_chance_cost_string(),
	
		"PP3_rate_cost" : get_PP3_rate_cost_string(),
		"PP3_outputRate_cost" : get_PP3_outputRate_cost_string(),
		"PP3_chance_cost" : get_PP3_chance_cost_string(),
	}
	
	return save_dict


















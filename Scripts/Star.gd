extends Resource

#loading Big library to handle really big numbers
const Big = preload("res://Scripts/Big.gd")

enum unit_type {Scientific, AA}

class_name Star

var energy = Big.new(0,0)
var dE = Big.new(2.5,-2)

var pression = Big.new(0,0)
var dP = Big.new(0,0)

var temperatureLoss = Big.new(0, 0)

var Temperature = Big.new(1,7)
var Mass = Big.new(8, -1)

var H_mass = Big.new(5,29)
var He_mass = Big.new(0,0)
var Li_mass = Big.new(0,0)
var Be_mass = Big.new(0,0)
var B_mass = Big.new(0,0)

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

var dE_list = []

var CostTempUpgrade = Big.new(1,1)
var tempIncrease = Big.new(1, 4)

var PP1_rate_cost = Big.new(1,6)
var PP1_outputRate_cost = Big.new(1,6)
var PP1_chance_cost = Big.new(1,6)

var noFusion_cpt = 0

var type = null

func _init(type=unit_type.Scientific):
	dE_list.append(Big.new(1.9794, 7))		#0 energy output for 4h -> He + 2H
	dE_list.append(Big.new(1.59,6))			#1 energy output for 2He -> Be
	dE_list.append(Big.new(8.6, 5))			#2 energy output for Be -> Li
	dE_list.append(Big.new(1.735, 7))		#3 energy output for Li + H -> 2He
	dE_list.append(Big.new(1.821, 7))		#4 energy output for Be -> 2He
	self.type = type
	
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
	temp.multiply(delta)
	var temp2 = Big.new(H_mass)
	temp2.multiply(delta*0.1)
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
		tmp.multiply(delta)
		tmp_dE.plus(tmp)
	elif is_PP1_unlocked and H_mass.isLessThan(temp):
		noFusion_cpt += 1
		print("no fusion counter : " + str(noFusion_cpt) + H_mass.toString())
	
	if is_PP2_unlocked and PP2_chance.isLargerThanOrEqualTo(rng2):
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
	updateTemperature(tmp)
	
func updateTemperature(var dE : Big):
	
	var tmp = Big.new(dE)
	tmp.divide(temperatureLoss)
	var lama = log(tmp.toFloat())
	tmp.divide(lama)
	Temperature.plus(tmp)
	Temperature.minus(temperatureLoss)
	
	var tmp2 = Big.new(Temperature)
	tmp2.divide(temperatureLoss)
#	tmp2.divide(Temperature)
#	print(tmp2.toString())
	temperatureLoss = Big.new(dE)
	temperatureLoss.divide(2.0)
#	temperatureLoss.power(1.25)
#	temperatureLoss.multiply(0.9)
#	temperatureLoss.square()
#	temperatureLoss.square()
#	var g2 = get_node(debugGraph2)
#	g2.record_point("dT", tmp2.toFloat())
#	Temperature.plus(tmp2)

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
		tmp = Big.new(1, -1)
		PP1_outputRate.multiply(tmp)
		tmp = Big.new(2, 1)
		PP1_outputRate_cost.multiply(tmp)
		return true
	
	return false

func update_PP1chance_cost():
	var tmp
	if energy.isLargerThanOrEqualTo(PP1_chance_cost):
		energy.minus(PP1_chance_cost)
		tmp = Big.new(0.05)
		PP1_chance.multiply(tmp)
		tmp = Big.new(1,1)
		PP1_chance_cost.multiply(tmp)
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
	return dE.toFloat()

	
func get_PP1_rate_cost() -> float:
	return PP1_rate_cost.toFloat()
	
#Getters for star variables as STRING
func get_dE_string() -> String:
	if self.type:
		if self.type == unit_type.Scientific:
			return dE.toScientific()
		elif self.type == unit_type.AA:
			return dE.toAA()
	return dE.toString()

func get_Energy_string() -> String:
	if self.type == unit_type.Scientific:
		return energy.toScientific()
	elif self.type == unit_type.AA:
		return energy.toAA()
	return energy.toString()
	
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
	if self.type == unit_type.Scientific:
		return PP1_chance.toScientific()
	elif self.type == unit_type.AA:
		return PP1_chance.toAA()
	
	return PP1_chance.toString()

func get_PP1_chance_cost_string() -> String:
	if self.type == unit_type.Scientific:
		return PP1_chance_cost.toScientific()
	elif self.type == unit_type.AA:
		return PP1_chance_cost.toAA()
	
	return PP1_chance_cost.toString()

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
	var location = "user://save_config.sav"
	
	print("saving config to : " + OS.get_user_data_dir())
	if file.open(location, file.WRITE) != 0:
		printerr("Cannot write file at " + location)
	else:
		file.store_line(to_json(config))
		file.close()

#Save the star data  into a file 
func export_save():
	var res = ResourceSaver.save("Save/lama.tres", self)
	assert(res == OK)

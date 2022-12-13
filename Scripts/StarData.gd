extends Resource

const Big = preload("res://Scripts/Big.gd")

class_name StarData

var energy = Big.new(0,0)
var dE = Big.new(2.5,-2)

var pression = Big.new(0,0)
var dP = Big.new(0,0)

var temperatureLoss = Big.new(1)

var Temperature = Big.new(1,7)

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



var config = ConfigFile.new()


func _init():
	var err = config.load("Save/starConfig.cfg")
	if err != OK:
		printerr("Cannot load config file...")
		return
	
	Temperature = config.get_value("base", "init_Temperature")
	temperatureLoss = config.get_value("base", "init_TempLoss")
	dE = config.get_value("base", "base_dE")
	
	PP1_rate = config.get_value("PP", "PP1_rate")
	PP1_outputRate = config.get_value("PP", "PP1_outputRate")
	PP1_chance = config.get_value("PP", "PP1_chance")
	PP2_rate = config.get_value("PP", "PP2_rate")
	PP2_outputRate = config.get_value("PP", "PP2_outputRate")
	PP2_chance = config.get_value("PP", "PP2_chance")
	PP3_rate = config.get_value("PP", "PP3_rate")
	PP3_outputRate = config.get_value("PP", "PP3_outputRate")
	PP3_chance = config.get_value("PP", "PP3_chance")
	
	H_mass = config.get_value("init_atom_mass", "H_mass")
	He_mass = config.get_value("init_atom_mass", "He_mass")
	Li_mass = config.get_value("init_atom_mass", "Li_mass")
	Be_mass = config.get_value("init_atom_mass", "Be_mass")
	B_mass = config.get_value("init_atom_mass", "B_mass")
	print("Sucessfully loaded config file !")


func _ready():
	pass


func export_config():
	config.set_value("base", "init_Temperature", Temperature.toString())
	config.set_value("base", "init_TempLoss", temperatureLoss.toString())
	config.set_value("base", "base_dE", dE.toString())
	
	config.set_value("PP", "PP1_rate", PP1_rate.toString())
	config.set_value("PP", "PP1_outputRate", PP1_outputRate.toString())
	config.set_value("PP", "PP1_chance", PP1_chance.toString())
	config.set_value("PP", "PP2_rate", PP2_rate.toString())
	config.set_value("PP", "PP2_outputRate", PP2_outputRate.toString())
	config.set_value("PP", "PP2_chance", PP2_chance.toString())
	config.set_value("PP", "PP3_rate", PP3_rate.toString())
	config.set_value("PP", "PP3_outputRate", PP3_outputRate.toString())
	config.set_value("PP", "PP3_chance", PP3_chance.toString())
	
	config.set_value("init_atom_mass", "H_mass", H_mass.toString())
	config.set_value("init_atom_mass", "He_mass", He_mass.toString())
	config.set_value("init_atom_mass", "Li_mass", Li_mass.toString())
	config.set_value("init_atom_mass", "Be_mass", Be_mass.toString())
	config.set_value("init_atom_mass", "B_mass", B_mass.toString())
	
	
	config.save("Save/starConfig.cfg")
	
	
	
	
	
	
	
	
	
	

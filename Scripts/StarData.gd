extends Resource

const Big = preload("res://Scripts/Big.gd")

class_name StarData

var energy = Big.new(0,0)
var dE = Big.new(2.5,-2)

var pression = Big.new(0,0)
var dP = Big.new(0,0)

var temperatureLoss = Big.new(1)

var Temperature = Big.new(1,7)
var dE_contrib_to_temp = Big.new(0)
var dE_contrib_cost = Big.new(0)

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

var PP1_rate_cost = Big.new(10)
var PP1_outputRate_cost = Big.new(50)
var PP1_chance_cost = Big.new(15)

var PP2_rate_cost = Big.new(250)
var PP2_outputRate_cost = Big.new(500)
var PP2_chance_cost = Big.new(420)

var PP3_rate_cost = Big.new(2500)
var PP3_outputRate_cost = Big.new(5000)
var PP3_chance_cost = Big.new(4269)

var config = ConfigFile.new()

func load_configFile(path : String):
	var err = config.load(path)
	if err != OK:
		printerr("Cannot load config file " + path + " ...")
		return
	
	Temperature = config.get_value("base", "init_Temperature")
	temperatureLoss = config.get_value("base", "init_TempLoss")
	dE = config.get_value("base", "base_dE")
	dE_contrib_to_temp = config.get_value("base", "dE_contrib_to_temp")
	dE_contrib_cost = config.get_value("base", "dE_contrib_cost")
	
	PP1_rate = config.get_value("PP", "PP1_rate")
	PP1_outputRate = config.get_value("PP", "PP1_outputRate")
	PP1_chance = config.get_value("PP", "PP1_chance")
	PP2_rate = config.get_value("PP", "PP2_rate")
	PP2_outputRate = config.get_value("PP", "PP2_outputRate")
	PP2_chance = config.get_value("PP", "PP2_chance")
	PP3_rate = config.get_value("PP", "PP3_rate")
	PP3_outputRate = config.get_value("PP", "PP3_outputRate")
	PP3_chance = config.get_value("PP", "PP3_chance")
	
	PP1_rate_cost = config.get_value("PP", "PP1_rate_cost")
	PP1_outputRate_cost =  config.get_value("PP", "PP1_outputRate_cost")
	PP1_chance_cost = config.get_value("PP", "PP1_chance_cost")

	PP2_rate_cost = config.get_value("PP", "PP2_rate_cost")
	PP2_outputRate_cost =  config.get_value("PP", "PP2_outputRate_cost")
	PP2_chance_cost = config.get_value("PP", "PP2_chance_cost")
	
	PP3_rate_cost = config.get_value("PP", "PP3_rate_cost")
	PP3_outputRate_cost =  config.get_value("PP", "PP3_outputRate_cost")
	PP3_chance_cost = config.get_value("PP", "PP3_chance_cost")
	
	H_mass = config.get_value("init_atom_mass", "H_mass")
	He_mass = config.get_value("init_atom_mass", "He_mass")
	Li_mass = config.get_value("init_atom_mass", "Li_mass")
	Be_mass = config.get_value("init_atom_mass", "Be_mass")
	B_mass = config.get_value("init_atom_mass", "B_mass")
	
	print("Sucessfully loaded config file !")

func _init():
	load_configFile("Save/starConfig.cfg")


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
	
	
	
	
	
	
	
	
	
	

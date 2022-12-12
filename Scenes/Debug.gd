extends Control

export(NodePath) var graph

const Plot = preload("res://Scripts/plot.gd")
const myFont = preload("res://Ressources/Fonts/Barlow-Regular.otf")

var x = 0.0
var y = -10.0

var plt 
var pannel1
var g 
func _ready():
	plt = Plot.new()
	pannel1 = $"VBoxContainer/PanelContainer"
#	pannel1.font = myFont
	$Timer.start(0.1)
	g = get_node("VBoxContainer/PanelContainer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if graph:
		var g = get_node(graph)
		g.record_point("Pos X", x)


func _on_Timer_timeout():
	x += 0.1 * y
	y *= x*x
	
#	pannel1.record_point("x position", x)

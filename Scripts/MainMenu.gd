extends Control

var FILE_NAME = "user://star.save"

func _ready():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		print("file " + FILE_NAME + " found !")
		$"continueButton".visible = true
		$"playButton".visible = false
	else:
		file.open(FILE_NAME, file.READ_WRITE)
	

func _on_playButton_pressed():
	get_tree().change_scene("res://Scenes/univers.tscn")


func _on_continueButton_pressed():
	get_tree().change_scene("res://Scenes/univers.tscn")


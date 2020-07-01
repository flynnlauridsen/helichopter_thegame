extends Node2D

func _unhandled_key_input(event):
	#press enter to test scene change
	if event.is_action_pressed("ui_accept"):
		print ("scene change")
		global.changeScene("res://Scenes/Worlds/LevelAutoTileTest1.tscn")

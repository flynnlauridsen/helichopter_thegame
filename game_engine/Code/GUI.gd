extends MarginContainer

func _ready():
	$ProgressBar.min_value = $"../..".minVel
	$ProgressBar.max_value = $"../..".maxVel
	

func _process(delta):
	$ProgressBar.value = $"../..".velImpulse
	rect_position = $"../".position
	rect_rotation = -90

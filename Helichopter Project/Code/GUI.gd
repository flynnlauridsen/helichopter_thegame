extends MarginContainer

func _ready():
	$ProgressBar.min_value = $"../..".minEnginePower
	$ProgressBar.max_value = $"../..".maxEnginePower
	

func _process(delta):
	$ProgressBar.value = $"../..".enginePow
	rect_position = $"../".position
	rect_rotation = -90

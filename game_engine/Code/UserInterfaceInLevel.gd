extends Control

func _ready():
	$ProgressBar.min_value = $"../Player".minVel
	$ProgressBar.max_value = $"../Player".maxVel
	

func _process(delta):
	$ProgressBar.value = $"../Player".velImpulse

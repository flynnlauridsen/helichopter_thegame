extends Control

func _ready():
	$ProgressBar.min_value = $"../..".minVel
	$ProgressBar.max_value = $"../..".maxVel
	

func _process(delta):
	$ProgressBar.value = $"../..".velImpulse

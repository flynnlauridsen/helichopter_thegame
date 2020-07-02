extends ProgressBar

func _ready():
	min_value = $"../..".minEnginePower
	max_value = $"../..".maxEnginePower
	

func _process(delta):
	value = $"../..".enginePow

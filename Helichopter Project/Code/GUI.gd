extends CanvasLayer

func _ready():
	$EnginePowerBar.min_value = $"..".minEnginePower
	$EnginePowerBar.max_value = $"..".maxEnginePower
	

func _process(delta):
	$EnginePowerBar.value = $"..".enginePow
	$AbilityBar.value = $"..".boostMeter

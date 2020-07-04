extends CanvasLayer

func _ready():
	$EnginePowerBar.min_value = $"..".minEnginePower
	$EnginePowerBar.max_value = $"..".maxEnginePower
	$HealthBar.max_value = $"..".maxHealth

func _process(_delta):
	$EnginePowerBar.value = $"..".enginePow
	$AbilityBar.value = $"..".boostMeter
	$HealthBar.value = $"..".health

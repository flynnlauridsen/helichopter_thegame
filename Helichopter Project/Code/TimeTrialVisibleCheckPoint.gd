extends Area2D
var activated = false
var activatedGraphicLeft
var activatedGraphicRight

func _ready():
	activatedGraphicLeft = load("res://assets/Graphics/Ring2L.png")
	activatedGraphicRight = load("res://assets/Graphics/Ring2R.png")
	

func _on_CheckPoint_body_entered(body):
	if not activated:
		if body.is_in_group("Player"):
			activated = true
			
			#change colour
			$Sprite.texture=activatedGraphicLeft
			$Sprite2.texture=activatedGraphicRight
			
			#play ding
			$"../DingSoundPlayer".play()

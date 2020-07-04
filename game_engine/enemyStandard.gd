extends RigidBody2D


var moveDur = 5
var moveDirection = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	global_translate(Vector2(moveDirection, 0))
	moveDur -= delta
	if($Area2D.overlaps_body($"/root/LevelAutoTileTest/Player") and abs(moveDirection) == 1):
		moveDirection *= 3
	elif(moveDur <= 0 and abs(moveDirection) == 3):
		moveDirection = moveDirection / 3
	if(moveDur <= 0):
		moveDur = int(rand_range(5.0, 1.0))
		moveDirection *= -1
		$Sprite.flip_h = !$Sprite.flip_h
		$CollisionPolygon2D.apply_scale(Vector2(-1, 1))
	print(moveDirection)
	if($Area2D.overlaps_body($"/root/LevelAutoTileTest/Player") and abs(moveDirection) == 1):
		moveDirection *= 3
	elif(moveDur <= 0 and abs(moveDirection) == 3):
		moveDirection = moveDirection / 3
		
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

extends RigidBody2D

var velocity_accel = 500
var angular_accel = 300

func _ready():
	pass
	

func slowDown():
	while(velocity_accel != 500):
		velocity_accel -= 2
		Tween

func _physics_process(delta):
	if Input.is_action_pressed("up"):
		#can try offset on blades with apply_impulse
		velocity_accel += 2
		apply_central_impulse(Vector2(velocity_accel*delta*cos(deg2rad(rotation_degrees-90)),velocity_accel*delta*sin(deg2rad(rotation_degrees-90))))
	if Input.is_action_just_released("up"):
		slowDown()
	if Input.is_action_pressed("left"):
		apply_torque_impulse(-angular_accel)
	if Input.is_action_pressed("right"):
		apply_torque_impulse(angular_accel)

extends RigidBody2D

var minVel = 500
var rateOfVelDecay = 200

var velocity_accel = minVel
var angular_accel = 300



func _ready():
	pass
	

func slowDown():
	var velStart = velocity_accel
	var decayDuration = (velStart - minVel) / rateOfVelDecay
	$"../DecayTween".interpolate_property(self,"velocity_accel",velStart,minVel,decayDuration,Tween.TRANS_LINEAR)
	$"../DecayTween".start()

func _physics_process(delta):
	print(velocity_accel)
	if Input.is_action_pressed("up"):
		#can try offset on blades with apply_impulse
		if $"../DecayTween".is_active():
			$"../DecayTween".stop_all()
		
		velocity_accel += 2
		apply_central_impulse(Vector2(velocity_accel*delta*cos(deg2rad(rotation_degrees-90)),velocity_accel*delta*sin(deg2rad(rotation_degrees-90))))
	if Input.is_action_just_released("up"):
		slowDown()
	if Input.is_action_pressed("left"):
		apply_torque_impulse(-angular_accel)
	if Input.is_action_pressed("right"):
		apply_torque_impulse(angular_accel)

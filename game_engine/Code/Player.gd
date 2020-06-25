extends RigidBody2D

var minVel = 500
var maxVel = 1000
var rateOfVelDecay = 200
var rateOfVelIncrease = 120

var velImpulse = minVel
var angImpulse = 300



func _ready():
	pass
	

func slowDown():
	var velStart = velImpulse
	var decayDuration = (velStart - minVel) / rateOfVelDecay
	$DecayTween.interpolate_property(self,"velImpulse",velStart,minVel,decayDuration,Tween.TRANS_LINEAR)
	$DecayTween.start()


func _physics_process(delta):
#	print(linear_velocity)
	if Input.is_action_pressed("up"):
		#can try offset on blades with apply_impulse
		if $DecayTween.is_active():
			$DecayTween.stop_all()
		
		velImpulse = clamp(velImpulse+rateOfVelIncrease*delta,minVel,maxVel)
		apply_central_impulse(Vector2(velImpulse*delta*cos(deg2rad(rotation_degrees-90)),velImpulse*delta*sin(deg2rad(rotation_degrees-90))))
	if Input.is_action_just_released("up"):
		slowDown()
	if Input.is_action_pressed("left"):
		apply_torque_impulse(-angImpulse)
	if Input.is_action_pressed("right"):
		apply_torque_impulse(angImpulse)

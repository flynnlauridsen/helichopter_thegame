extends RigidBody2D

var minVel = 500
var maxVel = 1000
var maxAng = 500
var minAng = 300
var rateOfVelDecay = 200
var rateOfVelIncrease = 170
var gEffectMult = 0

var velImpulse = minVel
var angImpulse = 300


func _ready():
	pass
	


func _physics_process(delta):
#	print(linear_velocity)
	if Input.is_action_pressed("up"):
		#can try offset on blades with apply_impulse
		if $DecayTween.is_active():
			$DecayTween.stop_all()
		
		if($RayCast2D.get_collider()):
			if($RayCast2D.get_collider().is_in_group("body")):
				velImpulse *= 220/int(($RayCast2D.get_collision_point().distance_to(get_position())))
				print(220/$RayCast2D.get_collision_point().distance_to(get_position()))
			
		velImpulse = clamp(velImpulse+rateOfVelIncrease*delta,minVel,maxVel)
		apply_central_impulse(Vector2(velImpulse*delta*cos(deg2rad(rotation_degrees-90)),velImpulse*delta*sin(deg2rad(rotation_degrees-90))))
		
	if Input.is_action_just_released("up"):
		valueSmooth(velImpulse, maxVel, 200)
		
	if Input.is_action_pressed("down"):
		if $DecayTween.is_active():
			$DecayTween.stop_all()
		velImpulse = clamp(-velImpulse-rateOfVelIncrease*delta,maxVel,minVel)
		apply_central_impulse(Vector2(-velImpulse*delta*cos(deg2rad(rotation_degrees-90))*0.6,-velImpulse*delta*sin(deg2rad(rotation_degrees-90))*0.6))
		
	if Input.is_action_just_released("down"):
		valueSmooth(-velImpulse, -maxVel, 200)
		
	if Input.is_action_pressed("left"):
		apply_torque_impulse(-angImpulse)
		
	if Input.is_action_pressed("right"):
		apply_torque_impulse(angImpulse)
		
		

func valueSmooth(initValue, finValue, decayDuration):
	$DecayTween.interpolate_property(self,"velImpulse",initValue,finValue,decayDuration,Tween.TRANS_LINEAR)
	$DecayTween.start()


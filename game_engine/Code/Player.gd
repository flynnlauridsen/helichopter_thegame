extends RigidBody2D

var minVel = 500
var maxVel = 1000
var rateOfVelDecay = 200
var rateOfVelIncrease = 170
var gEffectMult = 0
var canFlip = false
var rayCastDist
var spaceTimer = 3

var velImpulse = minVel
var enginePow = minVel
var angImpulse = 400


func _ready():
	pass
	rayCastDist = sqrt(pow($RayCast2D.get_cast_to().x, 2) + pow($RayCast2D.get_cast_to().y, 2))

func healthPickUp():
	print("Picked up health!")

func valueSmooth(initValue, finValue, decayDuration):
	$DecayTween.interpolate_property(self,"velImpulse",initValue,finValue,decayDuration,Tween.TRANS_LINEAR)
	$DecayTween.start()

func horizontalFlip():
	for x in get_children():
		if x is Node2D:
			x.scale.x *= -1
			x.position.x *= -1
	rotation *= -1

func _physics_process(delta):
#	print(linear_velocity)
	
	velImpulse = enginePow
	
	if spaceTimer > 3:
		spaceTimer -= 1 * delta
		
	if Input.is_action_pressed("ability_1") and spaceTimer <= 3:
		if spaceTimer > 0:
			spaceTimer -= 1 * delta
			
	if Input.is_action_just_released("ability_1"):
		spaceTimer = 7
		
	if Input.is_action_pressed("up"):
		#can try offset on blades with apply_impulse
		enginePow += rateOfVelIncrease * delta
		enginePow = clamp(enginePow+rateOfVelIncrease*delta,minVel,maxVel)
		if $DecayTween.is_active():
			$DecayTween.stop_all()
		if($RayCast2D.get_collider()):
			if($RayCast2D.get_collider().is_in_group("body")):
				velImpulse = enginePow * rayCastDist/int(($RayCast2D.get_collision_point().distance_to(get_position())))
				#print(rayCastDist/$RayCast2D.get_collision_point().distance_to(get_position()))
		else:
			if($RayCast2D2.get_collider()):
				if($RayCast2D2.get_collider().is_in_group("body")):
					velImpulse = enginePow * rayCastDist/int(($RayCast2D2.get_collision_point().distance_to(get_position())))
					#print(rayCastDist/$RayCast2D2.get_collision_point().distance_to(get_position()))
		print(spaceTimer, "\n .........................", velImpulse)
		apply_central_impulse(Vector2(velImpulse*delta*cos(deg2rad(rotation_degrees-90)),velImpulse*delta*sin(deg2rad(rotation_degrees-90))))
		
	if Input.is_action_just_released("up"):
		valueSmooth(enginePow, maxVel, 200)
		
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
		
	
	
	


func _unhandled_key_input(event):
	#Flip left / right
	if canFlip:
		if event.is_action_pressed("flip"):
			horizontalFlip()

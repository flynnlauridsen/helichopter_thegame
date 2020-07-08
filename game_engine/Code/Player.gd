extends RigidBody2D

var minEnginePower = 500 # the minimum power from the engine
var maxEnginePower = 1000 # the maximum ^
var rateOfVelDecay = 200 # rate at which engine power decays when not pressed
var rateOfVelIncrease = 170 # rate that engine power increase when pressed
var gEffectMult = 1000 # the max boost from ground effect (when on ground)
var canFlip = false # allows fliping left/right 
var rayCastDist
var boostTimer = 3
var boostPow = 2000

var velImpulse = minEnginePower
var enginePow = minEnginePower
var angImpulse = 400


func _ready():
	rayCastDist = sqrt(pow($RayCast2D.get_cast_to().x, 2) + pow($RayCast2D.get_cast_to().y, 2))
	print(rayCastDist)
	print(self.get_path())

func healthPickUp(): # called when a health item is picked up
	print("Picked up health!")

func valueSmooth(initValue, finValue, decayRate): # tweens a variable in this script to change over time
	$DecayTween.interpolate_property(self,"enginePow",initValue,finValue, (initValue-finValue)/decayRate ,Tween.TRANS_LINEAR)
	$DecayTween.start()

func horizontalFlip(): # flips player left/right
	for x in get_children():
		if x is Node2D:
			x.scale.x *= -1
			x.position.x *= -1
	rotation *= -1

func _physics_process(delta): 
#	print(linear_velocity)
	
	velImpulse = enginePow
	
	if boostTimer > 3:
		boostTimer -= 1 * delta
		
	if Input.is_action_pressed("ability_1") and boostTimer <= 3: # ability (boost) is started
		if boostTimer > 0:
			boostTimer -= 1 * delta
			apply_central_impulse(Vector2(boostPow*delta*cos(deg2rad(rotation_degrees-45)), boostPow*delta*sin(deg2rad(rotation_degrees-45))))
			
	if Input.is_action_just_released("ability_1"): 
		boostTimer = 7
		
	if Input.is_action_pressed("up"): # fly upwards
		enginePow += rateOfVelIncrease * delta # increase engine power as engine is active
		enginePow = clamp(enginePow+rateOfVelIncrease*delta,minEnginePower,maxEnginePower) # restrict the range of engine power
		
		if $DecayTween.is_active(): # stop decay as engine is active
			$DecayTween.stop_all()
		
		if($RayCast2D.get_collider()): # if ground effect raycast detects something
			if($RayCast2D.get_collider().is_in_group("body")): # the body causes ground effect
				velImpulse = enginePow + gEffectMult * (1-($RayCast2D.get_collision_point().distance_to($RayCast2D.global_position)/rayCastDist)) # finalImpulse = engine power + ( gEffectMult * (ground effect value from 0.0 to 1.0, where 1 is max effect) )
		elif($RayCast2D2.get_collider()): # if ground effect raycast detects something
				if($RayCast2D2.get_collider().is_in_group("body")): # the body causes ground effect
					velImpulse = enginePow + gEffectMult * (1-($RayCast2D2.get_collision_point().distance_to($RayCast2D2.global_position)/rayCastDist)) # no ground effect

		apply_central_impulse(Vector2(velImpulse*delta*cos(deg2rad(rotation_degrees-90)),velImpulse*delta*sin(deg2rad(rotation_degrees-90)))) # apply the impulse that is calculated, includes engine thrust and ground effect addition
		
	if Input.is_action_just_released("up"): # no longer thrusting up
		valueSmooth(enginePow, minEnginePower, rateOfVelDecay) # start the decay of engine power
		
	if Input.is_action_pressed("down"):
		if $DecayTween.is_active():
			$DecayTween.stop_all()
		velImpulse = clamp(-velImpulse-rateOfVelIncrease*delta,maxEnginePower,minEnginePower)
		apply_central_impulse(Vector2(-velImpulse*delta*cos(deg2rad(rotation_degrees-90))*0.6,-velImpulse*delta*sin(deg2rad(rotation_degrees-90))*0.6))
		
	if Input.is_action_just_released("down"): # reverse thrust
		valueSmooth(-velImpulse, -maxEnginePower, 200)
		
	if Input.is_action_pressed("left"): # rotate left
		apply_torque_impulse(-angImpulse)
		
	if Input.is_action_pressed("right"): # rotate right
		apply_torque_impulse(angImpulse)

func _unhandled_key_input(event):
	#Flip left / right
	if canFlip:
		if event.is_action_pressed("flip"):
			horizontalFlip()

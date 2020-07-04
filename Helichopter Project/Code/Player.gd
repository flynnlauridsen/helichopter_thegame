extends RigidBody2D


var gEffectMult = 700 # the max boost from ground effect (when on ground)
var canFlip = false # allows fliping left/right 
var rayCastDist

var boostLength = 3 # how long the boost lasts
var boostThreshold = 0.5 # % when boosting can start
var boostPow = 1000
var boostMeter = 0.0 # value on boost meter
var boostGainRate = 0.15 # % gained per second (1.0 = 100% in 1 second)
var boosting = false
var boostTimer

export var minEnginePower = 700 # the minimum power from the engine
export var maxEnginePower = 1000 # the maximum ^
export var rateOfVelDecay = 200 # rate at which engine power decays when not pressed
export var rateOfVelIncrease = 170 # rate that engine power increase when pressed
var velImpulse = minEnginePower
var enginePow = minEnginePower
export var angImpulse = 400

export var health = 50
export var maxHealth = 100


func _ready():
	rayCastDist = sqrt(pow($RayCast2D.get_cast_to().x, 2) + pow($RayCast2D.get_cast_to().y, 2))

func healthPickUp(addedHealth): # called when a health item is picked up
	if health < maxHealth:
		health = clamp(health + addedHealth,0,maxHealth)
	

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
#	print(boostTimer)
	
	velImpulse = enginePow
	
	if Input.is_action_pressed("ability_1") and boosting==false and boostMeter > boostThreshold: # ability (boost) is started
		#start boosting
		boosting = true
		boostTimer = boostMeter * boostLength
	elif Input.is_action_just_released("ability_1") and boosting: 
		boosting = false
	
	if boosting:
		boostTimer -= delta
		if boostTimer > 0:
			boostMeter = boostTimer/boostLength
			apply_central_impulse(Vector2(boostPow*delta*cos(deg2rad(rotation_degrees-45)), boostPow*delta*sin(deg2rad(rotation_degrees-45))))
		else:
			boostMeter = 0.0
			boosting = false
	if not boosting:
		boostMeter = clamp(boostMeter + boostGainRate*delta,0.0,1.0)
	
	
	
	
	if Input.is_action_pressed("up"): # fly upwards
		enginePow += rateOfVelIncrease * delta # increase engine power as engine is active
		enginePow = clamp(enginePow+rateOfVelIncrease*delta,minEnginePower,maxEnginePower) # restrict the range of engine power
		
		if $DecayTween.is_active(): # stop decay as engine is active
			$DecayTween.stop_all()
		var rayCast1Collided = false
		if($RayCast2D.get_collider()): # if ground effect raycast detects something
			if($RayCast2D.get_collider().is_in_group("body")): # the body causes ground effect
				velImpulse = enginePow + gEffectMult * (1-($RayCast2D.get_collision_point().distance_to($RayCast2D.global_position)/rayCastDist)) # finalImpulse = engine power + ( gEffectMult * (ground effect value from 0.0 to 1.0, where 1 is max effect) )
				rayCast1Collided = true
		elif($RayCast2D2.get_collider()): # if ground effect raycast detects something
			if($RayCast2D2.get_collider().is_in_group("body")): # the body causes ground effect
				if rayCast1Collided and ((1-($RayCast2D2.get_collision_point().distance_to($RayCast2D2.global_position)/rayCastDist)) > ((1-($RayCast2D.get_collision_point().distance_to($RayCast2D.global_position)/rayCastDist)))): # checks if raycast 2 is larger, then overwrites if so
					velImpulse = enginePow + gEffectMult * (1-($RayCast2D2.get_collision_point().distance_to($RayCast2D2.global_position)/rayCastDist)) # no ground effect
		
		apply_central_impulse(Vector2(velImpulse*delta*cos(deg2rad(rotation_degrees-90)),velImpulse*delta*sin(deg2rad(rotation_degrees-90)))) # apply the impulse that is calculated, includes engine thrust and ground effect addition
		
	if Input.is_action_just_released("up"): # no longer thrusting up
		valueSmooth(enginePow, minEnginePower, rateOfVelDecay) # start the decay of engine power
		
		
	if Input.is_action_pressed("down"): # reverse thrust
		apply_central_impulse(Vector2(-minEnginePower*delta*cos(deg2rad(rotation_degrees-90)),-minEnginePower*delta*sin(deg2rad(rotation_degrees-90))))
		
	if Input.is_action_pressed("left"): # rotate left
		apply_torque_impulse(-angImpulse)
		
	if Input.is_action_pressed("right"): # rotate right
		apply_torque_impulse(angImpulse)

func _unhandled_key_input(event):
	#Flip left / right
	if canFlip:
		if event.is_action_pressed("flip"):
			horizontalFlip()

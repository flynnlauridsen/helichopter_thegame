extends Node

export var numberOfCheckPoints = 1 #set number of checkpoints before finish

# for total race time
var startTime = 0
var raceTime = 0
var timeStarted = false

var checkPointStatus = Array()



func _ready():
	set_process(false)
	if numberOfCheckPoints >=0:
		for _i in range(0,numberOfCheckPoints):
			checkPointStatus.append(false)
			print (checkPointStatus)

func _process(delta):
	raceTime += delta * 1000
	print (raceTime)


func startStopWatch(): # save a start time
	timeStarted = true
	startTime = OS.get_ticks_msec()
	set_process(true)

func stopStopWatch(): # calculate final time based on start time, and stop updating time
	timeStarted = false
	raceTime = OS.get_ticks_msec() - startTime
	set_process(false)
	print ("Final Race Time: ", raceTime)



func _on_Start_body_entered(body):
	if body.is_in_group("Player") and not timeStarted:
		startStopWatch()


func _on_Finish_body_entered(body):
	if body.is_in_group("Player") and timeStarted and not(false in checkPointStatus):
		stopStopWatch()


func _on_CheckPoint_body_entered(body, checkPointNumber):
	if body.is_in_group("Player"):
		checkPointStatus[checkPointNumber] = true

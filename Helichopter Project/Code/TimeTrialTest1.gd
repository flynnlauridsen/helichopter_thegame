extends Node2D

var startTime = 0
var raceTime = 0
var timeStarted = false



func _ready():
	set_process(false)

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


func _on_Start2_body_entered(body):
	if body.is_in_group("Player") and timeStarted:
		stopStopWatch()

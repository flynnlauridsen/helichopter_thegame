extends Node


func _ready():
	pass 

func _physics_process(delta):
	if $TopLava.overlaps_body()

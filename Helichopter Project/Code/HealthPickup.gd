extends Area2D

export var addedHealth = 25


func _on_HealthPickup_body_entered(body):
	if body.is_in_group("Player"):
		body.healthPickUp(addedHealth)
		call_deferred("free")

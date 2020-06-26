extends Area2D



func _on_HealthPickup_body_entered(body):
	if body.is_in_group("Player"):
		body.healthPickUp()
		call_deferred("free")


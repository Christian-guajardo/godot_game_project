extends Area3D

func _on_body_entered(body):
	if body.is_in_group("player"): 
		body.global_transform.origin = Vector3(0, 0.5, 0)

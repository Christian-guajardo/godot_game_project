extends Area3D

@onready
var label_death = get_node("/root/Zone1/LabelDeathCount")

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.global_transform.origin = body.respawn_position
		body.death_count = body.death_count + 1
		label_death.text = "Death : %d" % [body.death_count]
	

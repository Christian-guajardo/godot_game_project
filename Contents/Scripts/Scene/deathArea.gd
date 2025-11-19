extends Area3D

@onready
var labelDeath = get_node("/root/Zone1/LabelDeathCount")

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.global_transform.origin = body.respawn_position
		body.deathCount = body.deathCount + 1
		labelDeath.text = "Death : %d" % [body.deathCount]
	

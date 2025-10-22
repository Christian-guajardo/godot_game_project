extends Node3D

@export var target: Node3D
@export var follow_speed: float = 5.0

func _process(delta: float) -> void:
	if target:
		# Déplacement doux vers la position de la cible
		global_position = global_position.lerp(target.global_position, follow_speed * delta)

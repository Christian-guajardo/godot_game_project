extends AnimatableBody3D

@export var delay_before_fall: float = 0.5      # délai avant que la plateforme tombe
@export var fall_duration: float = 1.0          # durée de la chute
@export var respawn_time: float = 3.0           # temps avant réapparition
@export var fall_distance: float = 5.0          # distance de chute

var initial_transform: Transform3D
var is_falling: bool = false

func _ready():
	initial_transform = global_transform
	$Area3D.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if not is_falling and body.is_in_group("player"):
		is_falling = true
		await get_tree().create_timer(delay_before_fall).timeout
		fall()

func fall():
	# Calculer la position finale de la chute
	var target_pos = global_transform.origin - Vector3(0, fall_distance, 0)
	
	# Créer un Tween pour animer la chute
	var tween = create_tween()
	tween.tween_property(self, "global_transform:origin", target_pos, fall_duration)
	tween.play()
	
	# Attendre la fin de l’animation
	await tween.finished
	
	# Attendre avant de réapparaître
	await get_tree().create_timer(respawn_time).timeout
	respawn()

func respawn():
	global_transform = initial_transform
	is_falling = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if not is_falling and body.is_in_group("player"):
		is_falling = true
		await get_tree().create_timer(delay_before_fall).timeout
		fall()

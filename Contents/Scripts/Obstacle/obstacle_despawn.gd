extends AnimatableBody3D

@export var fade_time: float = 2.0
@export var disappear_delay: float = 4.0

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var collision: CollisionShape3D = $CollisionShape3D

var elapsed: float = 0.0
var state := "fading_out"
var unique_material: StandardMaterial3D  # Matériau unique pour cette instance

func _ready():
	# Créer une COPIE du matériau pour cette instance
	var mat = mesh.get_active_material(0)
	if mat:
		unique_material = mat.duplicate()  # ← LA CLÉ : duplicate()
		unique_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		var color = unique_material.albedo_color
		color.a = 1.0
		unique_material.albedo_color = color
		mesh.set_surface_override_material(0, unique_material)

func _physics_process(delta: float) -> void:
	match state:
		"fading_out":
			elapsed += delta
			var alpha = clamp(1.0 - elapsed / fade_time, 0, 1)
			_set_alpha(alpha)
			collision.disabled = alpha <= 0
			if alpha <= 0:
				state = "waiting"
				elapsed = 0.0
		
		"waiting":
			elapsed += delta
			if elapsed >= disappear_delay:
				state = "fading_in"
				elapsed = 0.0
		
		"fading_in":
			elapsed += delta
			var alpha = clamp(elapsed / fade_time, 0, 1)
			_set_alpha(alpha)
			collision.disabled = alpha <= 0
			if alpha >= 1:
				state = "fading_out"
				elapsed = 0.0

func _set_alpha(alpha: float) -> void:
	if unique_material:
		var color = unique_material.albedo_color
		color.a = alpha
		unique_material.albedo_color = color

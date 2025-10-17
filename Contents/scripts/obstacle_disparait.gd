extends AnimatableBody3D

@export var fade_time: float = 3.0        # temps pour disparaître/réapparaître
@export var disappear_delay: float = 5.0  # temps avant réapparition

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var collision: CollisionShape3D = $CollisionShape3D

var elapsed: float = 0.0
var state := "fading_out" # peut être "fading_out", "waiting", "fading_in"

func _ready():
	# Assurer que le matériau est transparent
	var mat = mesh.get_active_material(0)
	if mat:
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		var color = mat.albedo_color
		color.a = 1.0
		mat.albedo_color = color
		mesh.set_surface_override_material(0, mat)

func _physics_process(delta: float) -> void:
	# --- Logique d'état ---
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
	var mat = mesh.get_active_material(0)
	if mat:
		var color = mat.albedo_color
		color.a = alpha
		mat.albedo_color = color

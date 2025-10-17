extends AnimatableBody3D

@export var fade_time: float = 3.0        # temps pour disparaître progressivement
@export var disappear_delay: float = 5.0  # temps avant réapparition

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var collision: CollisionShape3D = $CollisionShape3D

var alpha: float = 1.0
var fading: bool = false
var elapsed: float = 0.0
var state := "idle"  # "idle", "fading_out", "waiting", "fading_in"

func _ready():
	# S'assurer que le matériau est transparent
	var mat = mesh.get_active_material(0)
	if mat:
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		var color = mat.albedo_color
		color.a = alpha
		mat.albedo_color = color
		mesh.set_surface_override_material(0, mat)

func _physics_process(delta: float) -> void:
	match state:
		"idle":
			if fading:
				state = "fading_out"
				elapsed = 0.0
		"fading_out":
			elapsed += delta
			alpha = clamp(1.0 - elapsed / fade_time, 0, 1)
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
			alpha = clamp(elapsed / fade_time, 0, 1)
			_set_alpha(alpha)
			collision.disabled = alpha <= 0
			if alpha >= 1:
				state = "idle"
				fading = false

func _set_alpha(a: float) -> void:
	var mat = mesh.get_active_material(0)
	if mat:
		var color = mat.albedo_color
		color.a = a
		mat.albedo_color = color

# --- Détection du joueur ---
func _on_GhostPlatform_body_entered(body: Node) -> void:
	if body.is_in_group("player"):  # Assure que ton joueur a le groupe "player"
		fading = true

func _on_GhostPlatform_body_exited(body: Node) -> void:
	# Optionnel : on peut arrêter le fade si le joueur quitte
	pass

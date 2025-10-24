extends StaticBody3D

@export var fade_time: float = 3.0			# temps pour disparaître/réapparaître
@export var disappear_delay: float = 2.0  	# temps avant réapparition

@onready var mesh: MeshInstance3D = $Area3D/MeshInstance3D
@onready var static_collision: CollisionShape3D = $CollisionShape3D
@onready var area: Area3D = $Area3D

var alpha: float = 1.0
var fading: bool = false
var elapsed: float = 0.0
var state := "idle"

func _ready():
	var mat = mesh.get_active_material(0)
	if mat:
		mat = mat.duplicate()
		mesh.set_surface_override_material(0, mat)
		
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		var color = mat.albedo_color
		color.a = alpha
		mat.albedo_color = color

	area.connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta: float) -> void:
	match state:
		"idle":
			if fading:
				state = "fading_out"
				elapsed = 0.0
		"fading_out":
			elapsed += delta
			alpha = clamp(1.0 - elapsed / fade_time, 0, 1)
			_set_alpha(alpha)
			static_collision.disabled = alpha <= 0
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
			static_collision.disabled = alpha <= 0
			if alpha >= 1:
				state = "idle"
				fading = false

func _set_alpha(a: float) -> void:
	var mat = mesh.get_active_material(0)
	if mat:
		var color = mat.albedo_color
		color.a = a
		mat.albedo_color = color

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		fading = true

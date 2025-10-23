extends Area3D

@onready var static_body = $validState
@onready var flag = $flag
var condition : bool = true

func _ready():
	flag.material_override = flag.get_active_material(0).duplicate()

func _on_body_entered(body):
	if body.is_in_group("player") and condition:
		body.respawn_position = self.global_position
		static_body.visible = true
		_change_mesh_color(Color(0.2, 1.0, 0.2))
		condition = false

func _change_mesh_color(color: Color):
	var mat = flag.get_active_material(0)
	if mat and mat is StandardMaterial3D:
		mat.albedo_color = color

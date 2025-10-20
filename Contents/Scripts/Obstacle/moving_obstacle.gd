extends AnimatableBody3D

@export var distance: float = 2.0
@export var speed: float = 1.5
var time_passed: float = 0.0

var start_position: Vector3
var direction := 1

func _ready():
	start_position = position

func _physics_process(delta: float) -> void:
	
	time_passed += delta * speed
	position.z = start_position.z + sin(time_passed) * distance

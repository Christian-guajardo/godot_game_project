extends CharacterBody3D

var speed: float = 5.0
var jump_velocity: float = 5.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") as float

func _physics_process(delta):
	var direction = Vector3.ZERO

	# Inputs de déplacement
	if Input.is_action_pressed("ui_up"):
		direction -= transform.basis.z
	if Input.is_action_pressed("ui_down"):
		direction += transform.basis.z
	if Input.is_action_pressed("ui_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("ui_right"):
		direction += transform.basis.x

	direction = direction.normalized()

	# Appliquer la direction à la vélocité horizontale
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Appliquer la gravité
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Saut
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Déplacement
	move_and_slide()

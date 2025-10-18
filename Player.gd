extends CharacterBody3D

signal hit

# How fast the player moves in meters per second.
@export var speed = 1
# The downward acceleration while in the air, in meters per second squared.
@export var fall_acceleration = 20
# Vertical impulse applied to the character upon jumping in meters per second.
@export var jump_impulse = 5
# Vertical impulse applied to the character upon bouncing over a mob
# in meters per second.
@export var bounce_impulse = 55

var target_velocity = Vector3.ZERO


func _physics_process(delta):
	# We create a local variable to store the input direction
	var direction = Vector3.ZERO
	var anim_player = $Running/AnimationPlayer

	

	# We check for each move input and update the direction accordingly
	if Input.is_action_pressed("ui_right"):
		direction.x = direction.x + 1
	if Input.is_action_pressed("ui_left"):
		direction.x = direction.x - 1
	if Input.is_action_pressed("ui_down"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z = direction.z + 1
	if Input.is_action_pressed("ui_up"):
		direction.z = direction.z - 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		print(get_tree().get_current_scene().get_node(".")) # pour voir le node courant
		print(get_tree().get_current_scene().get_node(".").get_children())
		print("a")
		basis = Basis.looking_at(direction)
		anim_player.play("mixamo_com")  
		get_node("Running/AnimationPlayer").play("mixamorig_com")

		anim_player.speed_scale = 1.5
	else:
		print(get_tree().get_current_scene().get_node(".")) # pour voir le node courant
		print(get_tree().get_current_scene().get_node(".").get_children())
		print("a")
		anim_player.play("mixamo_com")
		anim_player.speed_scale = 1.5

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Jumping.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		target_velocity.y = jump_impulse


	# Moving the Character
	velocity = target_velocity
	move_and_slide()

func _ready() -> void:
	print(get_tree().get_current_scene().get_node(".")) # pour voir le node courant
	print(get_tree().get_current_scene().get_node(".").get_children())
	print("a")


# And this function at the bottom.
func die():
	hit.emit()
	queue_free()

extends Node3D

# Configuration
@export var rotation_speed: float = 1.0
@export var pulse_speed: float = 2.0
@export var teleport_destination: Node3D = null
@export var teleport_enabled: bool = true

# Références
@onready var ring1 = $Ring1
@onready var ring2 = $Ring2
@onready var ring3 = $Ring3
@onready var particles = $Particles
@onready var center_light = $CenterLight

var time: float = 0.0
var is_teleporting: bool = false

func _ready():
	# Configuration de la collision
	var collision_shape = CylinderShape3D.new()
	collision_shape.radius = 1.5
	collision_shape.height = 1.0
	$Area3D/CollisionShape3D.shape = collision_shape

func _process(delta):
	time += delta
	
	# Animation montante des anneaux avec disparition/réapparition
	animate_rings(delta)
	
	# Pulsation de la lumière
	if center_light:
		var pulse = 2.0 + sin(time * pulse_speed) * 0.5
		center_light.light_energy = pulse
	
	# Animation des particules
	animate_particles(delta)

func animate_rings(delta):
	# Anneau 1 - cycle plus lent
	if ring1:
		var cycle1 = fmod(time * 0.8, 3.0)  # Cycle de 3 secondes
		if cycle1 < 2.0:
			# Monte pendant 2 secondes
			ring1.position.y = 0.3 + cycle1 * 0.5
			# Fade out progressif
			var alpha = 1.0 - (cycle1 / 2.0)
			ring1.transparency = clamp(1.0 - alpha, 0.0, 1.0)
		else:
			# Invisible et reset position
			ring1.position.y = 0.3
			ring1.transparency = 1.0
	
	# Anneau 2 - cycle moyen avec décalage
	if ring2:
		var cycle2 = fmod(time * 1.0 + 1.0, 3.0)  # Décalage de 1 seconde
		if cycle2 < 2.0:
			ring2.position.y = 0.4 + cycle2 * 0.5
			var alpha = 1.0 - (cycle2 / 2.0)
			ring2.transparency = clamp(1.0 - alpha, 0.0, 1.0)
		else:
			ring2.position.y = 0.4
			ring2.transparency = 1.0
	
	# Anneau 3 - cycle plus rapide avec décalage
	if ring3:
		var cycle3 = fmod(time * 1.2 + 2.0, 3.0)  # Décalage de 2 secondes
		if cycle3 < 2.0:
			ring3.position.y = 0.5 + cycle3 * 0.5
			var alpha = 1.0 - (cycle3 / 2.0)
			ring3.transparency = clamp(1.0 - alpha, 0.0, 1.0)
		else:
			ring3.position.y = 0.5
			ring3.transparency = 1.0

func animate_particles(delta):
	if not particles:
		return
	
	for i in range(particles.get_child_count()):
		var particle = particles.get_child(i)
		if particle is MeshInstance3D:
			# Rotation orbitale
			var angle = time * (1.0 + i * 0.3) + i * (TAU / particles.get_child_count())
			var radius = 0.5 + i * 0.1
			
			particle.position.x = cos(angle) * radius
			particle.position.z = sin(angle) * radius
			particle.position.y = 0.3 + sin(time * 2.0 + i) * 0.2
			
			# Échelle pulsante
			var scale_pulse = 1.0 + sin(time * 3.0 + i) * 0.3
			particle.scale = Vector3.ONE * scale_pulse

func _on_body_entered(body):
	if not teleport_enabled or is_teleporting:
		return
	
	# Vérifie si c'est le joueur
	if body.is_in_group("player") or body.name == "Player":
		teleport(body)

func teleport(body):
	if teleport_destination == null:
		print("Aucune destination de téléportation définie!")
		return
	
	is_teleporting = true
	
	# Effet visuel de téléportation
	play_teleport_effect()
	
	# Attend un peu pour l'effet
	await get_tree().create_timer(0.5).timeout
	
	# Téléporte le corps
	body.global_position = teleport_destination.global_position
	body.respawn_position = teleport_destination.global_position
	
	# Réactive après un délai
	await get_tree().create_timer(1.0).timeout
	is_teleporting = false

func play_teleport_effect():
	# Augmente l'intensité lumineuse
	if center_light:
		var tween = create_tween()
		tween.tween_property(center_light, "light_energy", 5.0, 0.3)
		tween.tween_property(center_light, "light_energy", 2.0, 0.2)
	
	# Accélère les anneaux
	var original_speed = rotation_speed
	rotation_speed *= 3.0
	await get_tree().create_timer(0.5).timeout
	rotation_speed = original_speed

# Fonction pour activer/désactiver le téléporteur
func set_active(active: bool):
	teleport_enabled = active
	if center_light:
		center_light.visible = active
	visible = active

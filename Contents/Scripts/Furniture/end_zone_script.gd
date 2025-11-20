extends Node3D

@onready var mesh = $MeshInstance3D
@onready var label = $Label3D

# Couleurs pour l'animation
var base_color = Color(0.2, 1, 0.3, 0.7)  # Vert semi-transparent
var glow_color = Color(0.5, 1, 0.5, 1.0)  # Vert brillant
var time = 0.0

func _ready():
	# Créer un material pour le mesh
	var material = StandardMaterial3D.new()
	material.albedo_color = base_color
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.emission_enabled = true
	material.emission = Color(0.2, 1, 0.3)
	material.emission_energy = 0.5
	mesh.material_override = material

func _process(delta):
	# Animation de pulsation
	time += delta
	var pulse = (sin(time * 2.0) + 1.0) / 2.0  # Valeur entre 0 et 1
	
	# Animer le material
	if mesh.material_override:
		mesh.material_override.emission_energy = 0.5 + pulse * 0.5
	
	# Animer le label
	label.modulate = base_color.lerp(glow_color, pulse)

func _on_area_3d_body_entered(body):
	# Vérifier si c'est le joueur
	if body.is_in_group("player"):
		print("Player reached the end!")
		
		# Récupérer les stats du joueur
		var player_time = body.timer
		var player_deaths = body.death_count
		
		# Afficher le menu de fin avec les stats
		GameManager.show_end_menu(player_time, player_deaths)

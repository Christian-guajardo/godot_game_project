extends Control

@onready var time_label = $VBoxContainer/TimeLabel
@onready var death_label = $VBoxContainer/DeathLabel
@onready var retry_button = $VBoxContainer/RetryButton
@onready var exit_button = $VBoxContainer/ExitButton

func _ready():
	retry_button.pressed.connect(_on_retry_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	# Mettre à jour les statistiques depuis le GameManager
	update_stats()

func update_stats():
	# Récupérer le temps depuis le GameManager
	var time_seconds = GameManager.player_time
	var minutes = int(time_seconds) / 60
	var seconds = int(time_seconds) % 60
	time_label.text = "Your time: %02d:%02d" % [minutes, seconds]
	
	# Récupérer le nombre de morts
	death_label.text = "Death : %d" % [GameManager.player_deaths]

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Contents/Scene/zone_1.tscn")

func _on_exit_pressed():
	GameManager.exit_game()

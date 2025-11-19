extends Control

@onready var resume_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer/ResumeButton
@onready var reset_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer/ResetButton
@onready var exit_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer/ExitButton

func _ready():
	resume_button.pressed.connect(_on_resume_pressed)
	reset_button.pressed.connect(_on_reset_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	
	# Le menu est invisible au départ
	hide()
	# Mode process pour pouvoir fonctionner en pause
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Touche Échap
		if GameManager.game_started:
			toggle_pause()

func toggle_pause():
	visible = !visible
	get_tree().paused = visible

func _on_resume_pressed():
	toggle_pause()

func _on_reset_pressed():
	get_tree().paused = false
	GameManager.reset_game()

func _on_exit_pressed():
	get_tree().paused = false
	GameManager.exit_game()

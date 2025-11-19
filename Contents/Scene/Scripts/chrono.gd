extends Node3D


var temps_ecoule = 0.0
var chrono_actif = false

@onready
var characterBody3d = $PlayerElement/CharacterBody3D

func _ready():
	_on_start_pressed()

func _on_start_pressed():
	chrono_actif = true
	temps_ecoule = 0.0

func _process(delta):
	if chrono_actif:
		temps_ecoule += delta
		# Affiche le temps (format minutes:secondes)
		if int(temps_ecoule) != 0:
			var minutes = int(temps_ecoule) / 60
			var secondes = int(temps_ecoule) % 60
			$LabelTemps.text = "%02d:%02d" % [minutes, secondes]
			characterBody3d.timer = "%02d:%02d" % [minutes, secondes]
		else:
			$LabelTemps.text = "00:00"
			$LabelDeathCount.text = "Death : 0"

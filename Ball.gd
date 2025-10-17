# BouleDestruction.gd
extends RigidBody3D

@export var start_velocity: Vector3 = Vector3(8, 0, 0)

func _ready():
	# donne une vitesse initiale (permet de vérifier si la physique fonctionne)
	linear_velocity = start_velocity
	print("Boule: linear_velocity =", linear_velocity)

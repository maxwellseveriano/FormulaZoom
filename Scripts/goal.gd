extends Area2D

@onready var transition = $"../transition"
@export var next_level : String = ""

func _on_body_entered(body):
	if (body.name == "player" or body.name == "CharacterBody2D") and !next_level == "":
		transition.change_scene(next_level)
	else:
		print("TEM FASE NÃO SEU BURRO")

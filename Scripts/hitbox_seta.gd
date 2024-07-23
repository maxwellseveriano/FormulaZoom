extends Area2D

@onready var damage_sfx = $player_sounds/damage_sfx as AudioStreamPlayer

func _on_body_entered(body):
	if body.is_in_group("enemy_roda"):
		owner.queue_free()
		body.decrementar_roda()
		if body.roda_life == 0:
			damage_sfx.play()
			body.queue_free()
	
	elif body.name("seguranca"):
		owner.queue_free()
		body.decrementar_seguranca()
		if body.seguranca_life == 0:
			damage_sfx.play()
			body.queue_free()

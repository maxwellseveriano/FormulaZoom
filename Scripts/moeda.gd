extends Area2D

@onready var coin_collect_sfx = $coin_collect_sfx as AudioStreamPlayer

var moedas := 1

func _on_body_entered(body):
	$anim.play("collect")
	coin_collect_sfx.play()
	await $colisao.call_deferred("queue_free")
	Globals.score += 10
	Globals.moedas += moedas


func _on_anim_animation_finished():
	queue_free()

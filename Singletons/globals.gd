extends Node

var moedas := 0
var score := 0
var player_life := 3
var player = null
var player_start_position = null
var current_checkpoint = null
var boss_morto = false

func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
	else:
		player.global_position = player_start_position.global_position


func _ready():
	#get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

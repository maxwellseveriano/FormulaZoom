extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.moedas = 0
	Globals.score = 0
	Globals.player_life = 7


func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://world_01.tscn")


func _on_credit_btn_pressed():
	pass # Replace with function body.


func _on_quit_btn_pressed():
	get_tree().quit()

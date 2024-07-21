extends Area2D

var is_active = false
@onready var anim = $anim
@onready var marker_2d = $Marker2D

func _on_body_entered(body):
	if (body.name != "player" and body.name != "CharacterBody2D") or is_active:
		return
		
	activate_checkpoint()
	
func activate_checkpoint():
	Globals.current_checkpoint = marker_2d
	anim.play("rasing")
	is_active = true


func _on_anim_animation_finished():
	if anim.animation == "rasing":
		anim.play("checked")

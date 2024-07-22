extends Area2D

const  SPEED = 200
var velocity = Vector2.ZERO
var direction = 1

func set_seta_direction(dir):
	
	direction = dir
	if dir == -1:
		$AnimatedSprite2D.flip_h = true
		

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite2D.play("shoot")
	
	
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

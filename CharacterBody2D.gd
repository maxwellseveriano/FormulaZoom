extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation:= $AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
var player_life := 10
var knockback_vector := Vector2.ZERO
var is_jumping:= false
var knockback_power := 20


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	elif is_on_floor():
		is_jumping = false
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = direction
		if not is_jumping:
			animation.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("default")
	
	if is_jumping:
		animation.play("Jump")

	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	move_and_slide()
	
	for platforms in get_slide_collision_count():
		
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)
			


func _on_hurtbox_body_entered(body: Node2D) -> void:
	#if body.is_in_group("enemy_roda"):
		#queue_free()
	var knockback
	if player_life < 0:
		queue_free()
	else:
		knockback = Vector2((global_position.x - body.global_position.x) * knockback_power, -200)
		print (player_life)
		take_damage(knockback)

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	player_life -= 1
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)

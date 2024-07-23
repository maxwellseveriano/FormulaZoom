extends CharacterBody2D


const SPEED = 200
const AIR_FRICTION := 0.5

var direction
var is_shooting := false
var is_running := false
var is_attacking := false

const SETA = preload("res://prefabs/seta.tscn")



# Get the gravity from the project settings to be synced with RigidBody nodes.

@export var jump_height := 200
@export var max_time_to_peak := 0.8
var gravity 
var jump_velocity
var fall_gravity

@onready var animation:= $AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var jump_sfx = $player_sounds/jump_sfx as AudioStreamPlayer
@onready var damage_sfx = $player_sounds/damage_sfx as AudioStreamPlayer

var knockback_vector := Vector2.ZERO
var is_jumping:= false
var knockback_power := 20

signal player_has_died()

func _ready():
	jump_velocity = (jump_height * 2) / max_time_to_peak
	gravity = (jump_height * 2) / (max_time_to_peak * max_time_to_peak)
	fall_gravity = gravity * 2

func _physics_process(delta):
	
	if Input.is_action_just_pressed("move_right"):
		if sign($Node2D.position.x) == -1:
			$Node2D.position.x *=-1
	elif Input.is_action_just_pressed("move_left"):
		if sign($Node2D.position.x) == 1:
			$Node2D.position.x *=-1
			
	
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_velocity
		is_jumping = true
		jump_sfx.play()
		
	elif is_on_floor():
		is_jumping = false
	
	if velocity.y > 0 or not Input.is_action_pressed("ui_accept"):
		velocity.y += fall_gravity * delta
	else: 
		velocity.y += gravity * delta
		

	
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * SPEED, AIR_FRICTION)
		animation.scale.x = direction
		if not is_jumping:
			animation.play("Run")
			is_running = true
			is_shooting = false
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_shooting == false:
			animation.play("default")
			is_running = false
		if is_shooting == true:
			animation.play("Throw_Object")
	
	if is_jumping:
		animation.play("Jump")
		is_running = false
		is_jumping = true

	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	if Input.is_action_just_pressed("shoot"):
		
		if !is_running and !is_jumping:
			var seta = SETA.instantiate()
			if sign($Node2D.position.x) == 1:
				seta.set_seta_direction(1)
			else:
				seta.set_seta_direction(-1)
			get_parent().add_child(seta)
			seta.position = $Node2D.global_position
			is_shooting = true
		
	
	move_and_slide()
	
	for platforms in get_slide_collision_count():
		
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)
			


func _on_hurtbox_body_entered(body: Node2D) -> void:
	#if body.is_in_group("enemy_roda"):
		#queue_free()
	var knockback
	if Globals.player_life == 0:
		queue_free()
		emit_signal("player_has_died")
	else:
		knockback = Vector2((global_position.x - body.global_position.x) * knockback_power, -200)
		take_damage(knockback)
		print (Globals.player_life)

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	Globals.player_life -= 1
	damage_sfx.play()
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)

func handle_animation():
	
	if !is_on_floor() and !is_shooting:
		animation.play("Jump")
	elif !direction and !is_shooting:
		animation.play("Run")
	elif !direction and is_shooting:
		animation.play("Throw_Object")
	elif is_shooting or direction:
		animation.play("Throw_Object")
	else:
		animation.play("default")
	#if velocity.y > 0 and !is_on_floor():
		#animation.play("fall")
	#if direction !=0 :
	#	$AnimatedSprite2D.scale.x = direction

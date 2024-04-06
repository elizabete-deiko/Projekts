extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const WALL_JUMP = 100

const gravity = 1200

var animation_locked : bool = false

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var player_alive = true

var attack_ip = false

@onready var anim = get_node("AnimationPlayer")

func _physics_process(delta):
	# Add Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle Jump
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			jump()
		if is_on_wall() and Input.is_action_pressed("ui_right"):
			velocity.y = JUMP_VELOCITY
			velocity.x = -WALL_JUMP
		if is_on_wall() and Input.is_action_pressed("ui_left"):
			velocity.y = JUMP_VELOCITY
			velocity.x = WALL_JUMP
	else:
		if velocity.y > 0:
			land()
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			if attack_ip == false:
				anim.play("Idle")
	
	enemy_attack()
	update_animation()
	move_and_slide()
	
	if Game.playerHP <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://main.tscn")
	
func update_animation():
	if not animation_locked:
		if is_on_floor() and velocity.x > 0:
			anim.play("Run")
		if velocity.y == 0 and velocity.x == 0 and attack_ip == false:
			anim.play("Idle")

func jump():
	velocity.y = JUMP_VELOCITY
	anim.play("Jump")
	animation_locked = true

func land():
	anim.play("Fall")
	animation_locked = true

func player():
	pass

func _on_animated_sprite_2d_animation_finished():
	if(get_node("AnimatedSprite2D").animation == "Fall"):
		animation_locked = false

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		Game.playerHP = Game.playerHP - 20
		enemy_attack_cooldown = false
		$Attack_cooldown.start()
		print(Game.playerHP)

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

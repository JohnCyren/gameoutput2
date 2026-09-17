extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var respawn_position: Vector2 = global_position
@onready var camera_2d: Camera2D = $Camera2D

const SPEED = 300.0
const JUMP_VELOCITY = -850
var alive = true

func _physics_process(delta: float) -> void:
	if !alive:
		return
		
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.play("running")
	else:
		animated_sprite_2d.play("idle")
		
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.play("jumping")

	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true

func die() -> void:
	if !alive:
		return
	
	alive = false
	animated_sprite_2d.play("dying")
	
	await animated_sprite_2d.animation_finished
	respawn()

func respawn() -> void:
	global_position = respawn_position
	velocity = Vector2.ZERO
	alive = true
	animated_sprite_2d.play("idle")

extends CharacterBody2D

const speed = 100

var current_dir = "none"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.play("idle front")

func _physics_process(delta: float) -> void:
	player_movement(delta)

func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		if movement == 1:
			anim.play("walk right")
		elif movement == 0:
			anim.play("idle right")
	
	elif dir == "left":
		if movement == 1:
			anim.play("walk left")
		elif movement == 0:
			anim.play("idle left")
	
	elif dir == "down":
		if movement == 1:
			anim.play("walk forward")
		elif movement == 0:
			anim.play("idle front")
	
	elif dir == "up":
		if movement == 1:
			anim.play("walk backwards")
		elif movement == 0:
			anim.play("idle back")

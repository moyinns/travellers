extends CharacterBody2D

var speed = 75
var player_chase = false
var player = null
@export var beast_id: int = 0 

func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position)/speed


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body 
	player_chase = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Globals.player_position = body.position
		Globals.defeated_beasts.append(beast_id)
		Transition_screen.transition()
		await Transition_screen.on_transition_finished
		Globals.current_enemy = "beast"
		get_tree().change_scene_to_file("res://fight scene/fight_screen.tscn")

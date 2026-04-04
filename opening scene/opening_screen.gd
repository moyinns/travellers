extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	Sound_effects.play_button_sound()
	Transition_screen.transition()
	await Transition_screen.on_transition_finished
	get_tree().change_scene_to_file("res://tutorial scene/tutorial_screen.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main game scene/main_game.tscn")

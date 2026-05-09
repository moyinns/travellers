extends Node2D

@onready var mob_count_label: RichTextLabel = $"player/CanvasLayer/mob count label"
var mob_count = 9
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for ninja in get_tree().get_nodes_in_group("ninja"):
		if Globals.defeated_ninjas.has(ninja.ninja_id):
			ninja.queue_free()
	for beast in get_tree().get_nodes_in_group("beast"):
		if Globals.defeated_beasts.has(beast.beast_id):
			beast.queue_free()
	for knight in get_tree().get_nodes_in_group("knight"):
		if Globals.defeated_knights.has(knight.knight_id):
			knight.queue_free()
	if Globals.player_position != Vector2.ZERO:
		$player.position = Globals.player_position
	mob_count_label.text = "mobs left: "+str(mob_count-Globals.defeated_count)
	if Globals.defeated_count == 9:
		get_tree().change_scene_to_file("res://winning scene/winning_screen.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	Globals.player_health = min(Globals.player_health + 5, 100) # returns whichever is smaller, the new health or 100, max() does the opposite
	Globals.player_skill = min(Globals.player_skill + 1, 100)

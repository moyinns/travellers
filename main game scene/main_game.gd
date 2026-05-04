extends Node2D

@onready var mob_count_label: RichTextLabel = $"player/CanvasLayer/mob count label"
var mob_count = 6
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for ninja in get_tree().get_nodes_in_group("ninja"):
		if Globals.defeated_ninjas.has(ninja.ninja_id):
			ninja.queue_free()
	for beast in get_tree().get_nodes_in_group("beast"):
		if Globals.defeated_beasts.has(beast.beast_id):
			beast.queue_free()
	if Globals.player_position != Vector2.ZERO:
		$player.position = Globals.player_position
	mob_count_label.text = "mobs left: "+str(mob_count-Globals.defeated_count)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

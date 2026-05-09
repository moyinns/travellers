extends Node2D
@onready var long_text_scroll: TextureRect = $"long text scroll"
@onready var scarecrow_pfp: TextureRect = $"scarecrow pfp"
@onready var long_text_scroll_label: RichTextLabel = $"long text scroll label"
@onready var click_to_continue: Button = $click_to_continue
@onready var typing_sound: AudioStreamPlayer2D = $"typing sound"
@onready var discovery_sound: AudioStreamPlayer2D = $"discovery sound"
@onready var battle_sounds: AudioStreamPlayer2D = $"battle sounds"
@onready var play_again_button: Button = $"play again button"
@onready var quit_button: Button = $"quit button"
@onready var horizontal_scroll: TextureRect = $"horizontal scroll"
@onready var mob_defeated_label: Label = $"mob defeated label"

var story_line_part = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	horizontal_scroll.visible = false 
	mob_defeated_label.visible = false
	play_again_button.visible = false
	quit_button.visible = false
	long_text_scroll.visible = false
	scarecrow_pfp.visible = false
	click_to_continue.visible = false
	battle_sounds.play()
	await get_tree().create_timer(6).timeout
	battle_sounds.stop()
	#long_text_scroll_label.visible = false
	click_to_continue.visible = false
	fade_in(long_text_scroll)
	fade_in(scarecrow_pfp)
	long_text_scroll_label.text = "Zorak: you failed..."
	typewriter(long_text_scroll_label, 3)
	await get_tree().create_timer(3).timeout
	fade_in(click_to_continue)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fade_in(item, time: float = 1.0):
	item.modulate.a = 0
	item.visible = true
	var tween = create_tween()
	tween.tween_property(item, "modulate:a", 1.0, time)
	return tween
	
func fade_out(item, time: float = 0.5):
	var tween = create_tween()
	tween.tween_property(item, "modulate:a", 0.0, time)
	return tween

func typewriter(label, duration: float = 2.0):
	label.visible_ratio = 0.0
	typing_sound.play(4) 
	var tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, duration)
	tween.tween_callback(func(): typing_sound.stop())
	return tween


func _on_click_to_continue_pressed() -> void:
	story_line_part += 1
	click_to_continue.visible = false
	Sound_effects.play_button_sound()
	if story_line_part == 1:
		long_text_scroll_label.text = "Zorak: you failed your town"
		typewriter(long_text_scroll_label, 3)
		await get_tree().create_timer(3).timeout
		fade_in(click_to_continue)
	elif story_line_part == 2:
		long_text_scroll_label.text = "Zorak: you failed to save the people of "+str(Globals.player_town).to_upper()+"."
		typewriter(long_text_scroll_label, 3)
		await get_tree().create_timer(3).timeout
		fade_in(click_to_continue)
	elif story_line_part == 3:
		long_text_scroll_label.text = "Zorak: and worse of all-"
		typewriter(long_text_scroll_label, 3)
		await get_tree().create_timer(5).timeout
		Transition_screen.flash_transition(Color.DARK_RED, 0.7)#
		discovery_sound.play()
		await get_tree().create_timer(1.5).timeout
		long_text_scroll_label.text = "Zorak: you failed yourself."
		typewriter(long_text_scroll_label, 3)
		await get_tree().create_timer(3).timeout
		fade_in(click_to_continue)
	elif story_line_part == 4:
		await get_tree().create_timer(1).timeout
		fade_out(long_text_scroll)
		fade_out(long_text_scroll_label)
		fade_out(scarecrow_pfp)
		fade_in(horizontal_scroll)
		mob_defeated_label.text = "mobs defeated: "+str(Globals.defeated_count)+"/9 "
		fade_in(mob_defeated_label)
		await get_tree().create_timer(2).timeout
		fade_in(play_again_button)
		fade_in(quit_button)
		


func _on_play_again_button_pressed() -> void:
	Globals.player_health = 100
	Globals.player_skill = 100
	Globals.defeated_ninjas = []
	Globals.defeated_beasts = []
	Globals.defeated_knights = []
	Globals.defeated_count = 0
	Sound_effects.play_button_sound()
	Transition_screen.transition()
	await Transition_screen.on_transition_finished
	get_tree().change_scene_to_file("res://opening scene/opening_screen.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()

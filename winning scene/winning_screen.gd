extends Node2D

@onready var long_text_scroll: TextureRect = $"long text scroll"
@onready var scarecrow_pfp: TextureRect = $"scarecrow pfp"
@onready var long_text_scroll_label: RichTextLabel = $"long text scroll label"
@onready var typing_sound: AudioStreamPlayer2D = $"typing sound"
@onready var discovery_sound: AudioStreamPlayer2D = $"discovery sound"
@onready var gift: TextureRect = $gift
@onready var travel_gift: TextureRect = $"travel gift"
@onready var cheer_sound: AudioStreamPlayer2D = $"cheer sound"
@onready var town: TextureRect = $town
@onready var town_animation: AnimationPlayer = $"town animation"
@onready var click_to_continue: Button = $click_to_continue
@onready var dark_bg: ColorRect = $"dark bg"
@onready var gift_sound: AudioStreamPlayer2D = $"gift sound"
@onready var play_again_button: Button = $"play again button"
@onready var quit_button: Button = $"quit button"

var story_line_part = 0


func _ready() -> void:
	click_to_continue.visible = false
	play_again_button.visible = false
	quit_button.visible = false
	long_text_scroll.visible = false
	long_text_scroll_label.visible = false
	scarecrow_pfp.visible = false
	gift.visible = false
	travel_gift.visible = false
	dark_bg.visible = false
	cheer_sound.play()
	town_animation.play("pan left to right")
	await get_tree().create_timer(5).timeout
	cheer_sound.stop()
	fade_in(long_text_scroll)
	fade_in(scarecrow_pfp)
	fade_in(long_text_scroll_label, 0.01)
	long_text_scroll_label.text = "Zorak: you defeated all the mobs!"
	typewriter(long_text_scroll_label, 3)
	await get_tree().create_timer(3).timeout
	fade_in(click_to_continue)

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
		long_text_scroll_label.text = "Zorak: you saved "+str(Globals.player_town).to_upper()+"!"
		typewriter(long_text_scroll_label, 2)
		await get_tree().create_timer(2).timeout
		fade_in(click_to_continue)
	elif story_line_part == 2:
		long_text_scroll_label.text = "Zorak: in return, the people of "+str(Globals.player_town).to_upper()+" have given you a gift."
		typewriter(long_text_scroll_label, 2)
		await get_tree().create_timer(2).timeout
		fade_in(click_to_continue)
	elif story_line_part == 3:
		fade_out(town)
		fade_out(long_text_scroll, 0.3)
		fade_out(long_text_scroll_label, 0.3)
		fade_out(scarecrow_pfp)
		fade_in(dark_bg)
		fade_in(gift)
		click_to_continue.position = Vector2(469, 455)
		click_to_continue.text = "click to open gift"
		await get_tree().create_timer(2).timeout
		fade_in(click_to_continue)
	elif story_line_part == 4:
		gift_sound.play(0.5)
		fade_out(gift, 0.3)
		Sound_effects.play_flash_sound()
		Transition_screen.flash_transition()
		await get_tree().create_timer(1).timeout
		fade_in(travel_gift, 0.5)
		click_to_continue.position = Vector2(945, 509)
		click_to_continue.text = "click to continue"
		long_text_scroll_label.text = "Zorak: a ticket to another holiday!"
		typewriter(long_text_scroll_label, 2)
		fade_in(long_text_scroll)
		fade_in(long_text_scroll_label)
		fade_in(scarecrow_pfp)
		fade_in(click_to_continue)
	elif story_line_part == 5:
		fade_out(travel_gift)
		long_text_scroll_label.text = "Zorak: lets just hope history doesnt repeat itself, what are the odds of that.. right?"
		typewriter(long_text_scroll_label, 2)
		await get_tree().create_timer(6).timeout
		fade_out(long_text_scroll)
		fade_out(long_text_scroll_label)
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

extends Node2D
@onready var horizontal_scroll: TextureRect = $"horizontal scroll"
@onready var yes_button: Button = $"yes button"
@onready var no_button: Button = $"no button"
@onready var skip_tutorial: Label = $"skip tutorial"
@onready var text_scroll: TextureRect = $"text scroll"
@onready var long_text_scroll: TextureRect = $"long text scroll"
@onready var text_scroll_label: RichTextLabel = $"text scroll label"
@onready var typing_sound: AudioStreamPlayer2D = $"typing sound"
@onready var scarecrow_pfp: TextureRect = $"scarecrow pfp"
@onready var long_text_scroll_label: RichTextLabel = $"long text scroll label"
@onready var click_to_continue: Button = $click_to_continue

var visible_characters = 0
var story_line_part = 0

func _ready() -> void:
	horizontal_scroll.visible = false # all of this js makes the stuff im gonna use for the other scenes invisible at the start
	yes_button.visible = false 
	no_button.visible = false
	skip_tutorial.visible = false
	text_scroll.visible = false
	long_text_scroll.visible = false
	text_scroll_label.visible = false
	scarecrow_pfp.visible = false
	long_text_scroll_label.visible = false
	click_to_continue.visible = false
	
	await get_tree().create_timer(1).timeout # waits 1 sec b4 the flash
	Transition_screen.colour_rect.visible = false # ensures the transition isnt till playing
	Sound_effects.play_flash_sound()
	Transition_screen.flash_transition()
	horizontal_scroll.visible = true # makes all the dyw skip stuff visible
	yes_button.visible = true
	no_button.visible = true
	skip_tutorial.visible = true

func _process(delta: float) -> void:
	pass



func _on_yes_button_pressed() -> void:
	Sound_effects.play_button_sound()
	get_tree().quit()


func _on_no_button_pressed() -> void:
	Sound_effects.play_button_sound()
	horizontal_scroll.visible = false # makes everything else invis
	yes_button.visible = false
	no_button.visible = false
	skip_tutorial.visible = false
	long_text_scroll.visible = false
	text_scroll.visible = true # makes the yea good choice visible
	text_scroll_label.visible = true
	await typewriter(text_scroll_label, 0.65) # waits for the typewriting to finish
	await get_tree().create_timer(1).timeout
	story_line_start()

func typewriter(label, duration: float = 2.0): # allows u to make any label typing animation
	label.visible_ratio = 0.0
	typing_sound.play(4) # starts later cs the start is weird
	
	var tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, duration)
	tween.tween_callback(func(): typing_sound.stop())
	return tween
	
func fade_in(item, time: float = 1.0):
	item.modulate.a = 0
	item.visible = true
	var tween = create_tween()
	tween.tween_property(item, "modulate:a", 1.0, time)
	return tween

func story_line_start():
	horizontal_scroll.visible = false # makes sure everything else is invis
	yes_button.visible = false 
	no_button.visible = false
	skip_tutorial.visible = false
	text_scroll.visible = false
	text_scroll_label.visible = false
	
	long_text_scroll_label.visible = true
	long_text_scroll.visible = true
	
	fade_in(scarecrow_pfp)
	await get_tree().create_timer(1).timeout
	long_text_scroll_label.text = "???: people tend to rush too much nowadays... anywho, lets get started"
	typewriter(long_text_scroll_label, 1.0)
	await get_tree().create_timer(0.5).timeout
	fade_in(click_to_continue)

func _on_click_to_continue_pressed() -> void:
	story_line_part += 1
	if story_line_part == 1:
		long_text_scroll_label.text = "you are a young traveller from... where are you from again?"
		typewriter(long_text_scroll_label, 1.0)
		await get_tree().create_timer(0.5).timeout
		fade_in(click_to_continue)

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
@onready var input_town_line_edit: LineEdit = $"input town line edit"
@onready var input_name_line_edit: LineEdit = $"input name line edit"
@onready var bedroom_bg: TextureRect = $"bedroom bg"
@onready var talking_sound: AudioStreamPlayer2D = $"talking sound"
@onready var ring_sound: AudioStreamPlayer2D = $"ring sound"
@onready var ruined_town_bg: TextureRect = $"ruined town bg"
@onready var bg_animation_player: AnimationPlayer = $"bg animation player"
@onready var discovery_sound: AudioStreamPlayer2D = $"discovery sound"



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
	input_town_line_edit.visible = false
	input_name_line_edit.visible = false
	bedroom_bg.visible = false
	ruined_town_bg.visible = false
	
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
	
func fade_out(item, time: float = 0.5):
	var tween = create_tween()
	tween.tween_property(item, "modulate:a", 0.0, time)
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
	await get_tree().create_timer(1.5).timeout
	fade_in(click_to_continue)

func _on_click_to_continue_pressed() -> void:
	story_line_part += 1
	click_to_continue.visible = false
	Sound_effects.play_button_sound()
	if story_line_part == 1:
		long_text_scroll_label.text = "???: you are a young traveller from... where are you from again?"
		typewriter(long_text_scroll_label, 2)
		await get_tree().create_timer(0.5).timeout
		fade_in(input_town_line_edit)
		await get_tree().create_timer(1).timeout
		fade_in(click_to_continue)
	elif story_line_part == 2:
		fade_out(input_town_line_edit)
		long_text_scroll_label.text = "???: ah, yes, right. the land of "+str(Globals.player_town.to_upper())+", you helped protect people from many scary things such as ... idk fire breathing dragons?"
		typewriter(long_text_scroll_label, 1.5)
		fade_in(click_to_continue)
	elif story_line_part == 3:
		long_text_scroll_label.text = "???: once you defeated all of these, you were known as the great ... "
		typewriter(long_text_scroll_label, 1.5)
		fade_in(input_name_line_edit)
		fade_in(click_to_continue)
	elif story_line_part == 4:
		fade_out(input_name_line_edit)
		long_text_scroll_label.text = "???: yes yes the great "+str(Globals.player_name)+". you were a very strong solider, who saved many lives."
		typewriter(long_text_scroll_label, 1.5)
		fade_in(click_to_continue)
	elif story_line_part == 5:
		long_text_scroll_label.text = ""
		discovery_sound.play()
		Transition_screen.flash_transition()
		await get_tree().create_timer(0.5).timeout
		long_text_scroll_label.text = "Zorak: sorry, I shouldve introduced myself - I'm Zorak, one of the many beings that watch over earth."
		typewriter(long_text_scroll_label, 1.5)
		fade_in(click_to_continue)
	elif story_line_part == 6:
		long_text_scroll_label.text = "Zorak: enough about me, lets get back to your story."
		typewriter(long_text_scroll_label, 1.5)
		fade_in(click_to_continue)
	elif story_line_part == 7:
		long_text_scroll_label.text = "Zorak: so, as any great hero, you travelled around the world for yk a cheeky holiday. until one day..."
		typewriter(long_text_scroll_label, 1.5)
		fade_in(click_to_continue)
	elif story_line_part == 8:
		fade_out(long_text_scroll, 0.01)
		fade_out(scarecrow_pfp, 0.01)
		Transition_screen.transition()
		await Transition_screen.on_transition_finished
		fade_in(bedroom_bg)
		long_text_scroll_label.text = ""
		await get_tree().create_timer(1).timeout
		fade_in(long_text_scroll)
		ring_sound.play()
		long_text_scroll_label.text = "*ring ring*"
		typewriter(long_text_scroll_label, 3.0)
		await get_tree().create_timer(4).timeout
		ring_sound.stop()
		long_text_scroll_label.text = Globals.player_name+": ergh... who is calling at such a time?"
		typewriter(long_text_scroll_label, 1.0)
		click_to_continue.text = "pick up the phone"
		fade_in(click_to_continue)
	elif story_line_part == 9:
		long_text_scroll_label.text = ""
		fade_out(long_text_scroll)
		talking_sound.play()
		await get_tree().create_timer(6).timeout
		talking_sound.stop()
		Sound_effects.play_flash_sound()
		Transition_screen.flash_transition()
		await get_tree().create_timer(1).timeout
		fade_in(long_text_scroll)
		long_text_scroll_label.text = Globals.player_name+": oh god- okay, I'm on my way back right now!"
		typewriter(long_text_scroll_label, 1.0)
		click_to_continue.text = "click to continue"
		fade_in(click_to_continue)
	elif story_line_part == 10:
		fade_in(scarecrow_pfp)
		long_text_scroll_label.text = "Zorak: and just like that, you booked your flight back immediately to see ..."
		typewriter(long_text_scroll_label, 1.0)
		fade_in(click_to_continue)
	elif story_line_part == 11:
		fade_out(long_text_scroll)
		fade_out(long_text_scroll_label)
		fade_out(scarecrow_pfp)
		Transition_screen.transition()
		await Transition_screen.on_transition_finished
		fade_in(ruined_town_bg)
		bg_animation_player.play("pan left to right")
		await get_tree().create_timer(3).timeout
		fade_in(long_text_scroll)
		fade_in(long_text_scroll_label)
		fade_in(scarecrow_pfp)
		long_text_scroll_label.text = "Zorak: your town, COMPLETELY ruined."
		typewriter(long_text_scroll_label, 1.0)
		fade_in(click_to_continue)
	elif story_line_part == 12:
		ruined_town_bg.visible = false
		Sound_effects.play_flash_sound()
		Transition_screen.flash_transition()
		await get_tree().create_timer(0.5).timeout
		long_text_scroll_label.text = "Zorak: now its your job to fix this!"
		typewriter(long_text_scroll_label, 1.0)
		fade_in(click_to_continue)
	else:
		pass

func _on_input_town_text_edit_text_submitted(new_text: String) -> void:
	Globals.player_town = new_text
	
func _on_input_name_line_edit_text_submitted(new_text: String) -> void:
	Globals.player_name = new_text

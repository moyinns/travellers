extends Node2D
@onready var grass_bg: TextureRect = $"grass bg"
@onready var omori: TextureRect = $omori
@onready var pokemon: TextureRect = $pokemon
@onready var text_scroll: TextureRect = $"text scroll"
@onready var text_scroll_label: RichTextLabel = $"text scroll label"
@onready var typing_sound: AudioStreamPlayer2D = $"typing sound"

# player/enemy stuff
@onready var player_icon: TextureRect = $"player icon"
@onready var player: AnimatedSprite2D = $player
@onready var ninja: AnimatedSprite2D = $ninja
@onready var icon_border: ColorRect = $"icon border"
@onready var ninja_icon: TextureRect = $"ninja icon"


# move options
@onready var moves_scroll: TextureRect = $"moves scroll"
@onready var attack_button: Button = $"attack button"
@onready var skill_button: Button = $"skill button"
@onready var rest_button: Button = $"rest button"
@onready var stats_button: Button = $"stats button"

# attack options
@onready var back_button: Button = $"back button"
@onready var uppercut_button: Button = $"uppercut button"
@onready var bck_kick_button: Button = $"bck kick button"
@onready var dash_punch_button: Button = $"dash punch button"
@onready var lgh_kick_button: Button = $"lgh kick button"


var enemy_health = 10



# copied functiosn from tutorial scene -> shld prolly make these global ://
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
	
func typewriter(label, duration: float = 1.0): # allows u to make any label typing animation
	label.visible_ratio = 0.0
	typing_sound.play(4) # starts later cs the start is weird
	
	var tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, duration)
	tween.tween_callback(func(): typing_sound.stop())
	return tween


func _ready() -> void:
	player_icon.visible = false
	icon_border.visible = false
	ninja_icon.visible = false
	text_scroll.visible = false
	text_scroll_label.visible = false
	ninja.visible = false
	player.visible = false
	back_button.visible = false
	fade_out(moves_scroll, 0.01)
	hide_move_options(0.01)
	hide_attack_options(0.01)
	if Globals.current_enemy == "ninja":
		ninja_fight()
	else:
		pass

func _process(delta: float) -> void:
	pass

func show_move_options(time: float = 1.0):
	fade_in(attack_button, time)
	fade_in(skill_button, time)
	fade_in(rest_button, time)
	fade_in(stats_button, time)

func hide_move_options(time: float = 1.0):
	fade_out(attack_button, time)
	fade_out(skill_button, time)
	fade_out(rest_button, time)
	fade_out(stats_button, time)

func hide_attack_options(time: float = 0.5):
	fade_out(uppercut_button, time)
	fade_out(bck_kick_button, time)
	fade_out(dash_punch_button, time)
	fade_out(lgh_kick_button, time)

func show_attack_options(time: float = 0.5):
	fade_in(uppercut_button, time)
	fade_in(bck_kick_button, time)
	fade_in(dash_punch_button, time)
	fade_in(lgh_kick_button, time)

func ninja_fight():
	enemy_health = 50
	fade_in(ninja)
	fade_in(player)
	player.play("idle front")
	text_scroll.visible = true
	text_scroll_label.visible = true
	player_icon.visible = true
	icon_border.visible = true
	typewriter(text_scroll_label)
	fade_in(moves_scroll)
	show_move_options()

func _on_attack_button_pressed() -> void:
	#hide_move_options(0.5) # cant use this bcs it covers the other buttons
	attack_button.visible = false
	skill_button.visible = false
	rest_button.visible = false
	stats_button.visible = false
	show_attack_options()
	fade_in(back_button, 0.5)

func _on_back_button_pressed() -> void:
	hide_attack_options()
	show_move_options()
	fade_out(back_button, 0.5)

# attack moves

func _on_uppercut_button_pressed() -> void:
	fade_out(moves_scroll, 0.5)
	hide_move_options(0.5)
	hide_attack_options(0.5)
	fade_out(back_button, 0.5)
	player.play("attack")
	await get_tree().create_timer(0.5).timeout
	player.play("idle front")
	Transition_screen.flash_transition()
	await get_tree().create_timer(1).timeout
	text_scroll_label.text = Globals.player_name+" dealt an uppercut!"
	player_icon.visible = true
	typewriter(text_scroll_label)
	await get_tree().create_timer(1).timeout
	enemy_health -= 10
	Globals.player_skill -= 1
	
	
	

func _on_bck_kick_button_pressed() -> void:
	enemy_health -= 15
	Globals.player_skill -= 2

func _on_dash_punch_button_pressed() -> void:
	enemy_health -= 20
	Globals.player_skill -= 4

func _on_lgh_kick_button_pressed() -> void:
	enemy_health -= 5

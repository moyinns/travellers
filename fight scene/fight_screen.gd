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

var moves_made = 0
var enemy_health = 40
var enemy_skill = 100
var ninja_moves = [["flying swallow", 15, 4],
					["izunna drop", 10, 2],
					["wind path", 7, 0],
					["jumping double slash", 10, 2],
					["art of the inferno", 25, 15],
					["windmill slash", 30, 20],
					["helmet splitter", 40, 30],
					["shinobi aruki", 0, 30],
					["double breathing", 0, 45],
					["distraction", 0, 20]]

func ninja_attack():
	var attack_made = false
	var attack_damage = 0
	var skill_damage = 0
	var attack_name = ""
	while not attack_made:
		var num = randi_range(1, 100)
		var random_row = randi_range(0,2)
		if enemy_health >= 30:
			if num <= 5:
				attack_damage = ninja_moves[random_row+3][1]
				skill_damage = ninja_moves[random_row+3][2]
				attack_name = ninja_moves[random_row+3][0]
			elif num <= 30:
				attack_damage = ninja_moves[random_row+6][1]
				skill_damage = ninja_moves[random_row+6][2]
				attack_name = ninja_moves[random_row+6][0]
			else:
				attack_damage = ninja_moves[random_row][1]
				skill_damage = ninja_moves[random_row][2]
				attack_name = ninja_moves[random_row][0]
		elif enemy_health >= 20:
			if num <= 33:
				attack_damage = ninja_moves[random_row+3][1]
				skill_damage = ninja_moves[random_row+3][2]
				attack_name = ninja_moves[random_row+3][0]
			elif num <= 66:
				attack_damage = ninja_moves[random_row+6][1]
				skill_damage = ninja_moves[random_row+6][2]
				attack_name = ninja_moves[random_row+6][0]
			else:
				attack_damage = ninja_moves[random_row][1]
				skill_damage = ninja_moves[random_row][2]
				attack_name = ninja_moves[random_row][0]
		else:
			if num <= 5:
				attack_damage = ninja_moves[random_row+6][1]
				skill_damage = ninja_moves[random_row+6][2]
				attack_name = ninja_moves[random_row+6][0]
			elif num <= 20:
				attack_damage = ninja_moves[random_row+3][1]
				skill_damage = ninja_moves[random_row+3][2]
				attack_name = ninja_moves[random_row+3][0]
			else:
				attack_damage = ninja_moves[random_row][1]
				skill_damage = ninja_moves[random_row][2]
				attack_name = ninja_moves[random_row][0]
		if enemy_skill - skill_damage >= 0:
			attack_made = true
	Globals.player_health -= attack_damage
	enemy_skill -= skill_damage
	ninja.play("attack spin")
	await get_tree().create_timer(0.5).timeout
	ninja.play("idle front")
	Transition_screen.flash_transition()
	await get_tree().create_timer(1).timeout
	text_scroll_label.text = "ninja dealt a "+str(attack_name)+"!"
	ninja_icon.visible = true
	typewriter(text_scroll_label)
	await get_tree().create_timer(1).timeout

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
	while enemy_health > 0:
		if moves_made%2 == 0:
			text_scroll.visible = true
			text_scroll_label.visible = true
			player_icon.visible = true
			icon_border.visible = true
			typewriter(text_scroll_label)
			fade_in(moves_scroll)
			show_move_options()
		else:
			ninja_attack()

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
	if Globals.player_skill >= 1:
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
		moves_made += 1
	else:
		text_scroll_label.add_theme_font_size_override("normal_font_size", 16)
		text_scroll_label.text = "not enough skill to peform this move."
		player_icon.visible = true
		typewriter(text_scroll_label)
	
	
	

func _on_bck_kick_button_pressed() -> void:
	if Globals.player_skill >= 2:
		fade_out(moves_scroll, 0.5)
		hide_move_options(0.5)
		hide_attack_options(0.5)
		fade_out(back_button, 0.5)
		player.play("attack")
		await get_tree().create_timer(0.5).timeout
		player.play("idle front")
		Transition_screen.flash_transition()
		await get_tree().create_timer(1).timeout
		text_scroll_label.text = Globals.player_name+" dealt a backwards kick!"
		player_icon.visible = true
		typewriter(text_scroll_label)
		await get_tree().create_timer(1).timeout
		enemy_health -= 15
		Globals.player_skill -= 2
		moves_made += 1
	else:
		text_scroll_label.add_theme_font_size_override("normal_font_size", 16)
		text_scroll_label.text = "not enough skill to peform this move."
		player_icon.visible = true
		typewriter(text_scroll_label)

func _on_dash_punch_button_pressed() -> void:
	if Globals.player_skill >= 4:
		fade_out(moves_scroll, 0.5)
		hide_move_options(0.5)
		hide_attack_options(0.5)
		fade_out(back_button, 0.5)
		player.play("attack")
		await get_tree().create_timer(0.5).timeout
		player.play("idle front")
		Transition_screen.flash_transition()
		await get_tree().create_timer(1).timeout
		text_scroll_label.text = Globals.player_name+" dealt a dash punch!"
		player_icon.visible = true
		typewriter(text_scroll_label)
		await get_tree().create_timer(1).timeout
		enemy_health -= 20
		Globals.player_skill -= 4
		moves_made += 1
	else:
		text_scroll_label.add_theme_font_size_override("normal_font_size", 16)
		text_scroll_label.text = "not enough skill to peform this move."
		player_icon.visible = true
		typewriter(text_scroll_label)

func _on_lgh_kick_button_pressed() -> void:
	fade_out(moves_scroll, 0.5)
	hide_move_options(0.5)
	hide_attack_options(0.5)
	fade_out(back_button, 0.5)
	player.play("attack")
	await get_tree().create_timer(0.5).timeout
	player.play("idle front")
	Transition_screen.flash_transition()
	await get_tree().create_timer(1).timeout
	text_scroll_label.text = Globals.player_name+" dealt a light kick!"
	player_icon.visible = true
	typewriter(text_scroll_label)
	await get_tree().create_timer(1).timeout
	enemy_health -= 5
	moves_made += 1

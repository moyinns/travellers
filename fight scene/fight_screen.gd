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

# skill options
@onready var lgh_stab_button: Button = $"lgh stab button"
@onready var wh_candy_button: Button = $"wh candy button"
@onready var mud_cake_button: Button = $"mud cake button"
@onready var heart_rip_button: Button = $"heart rip button"

# rest options
@onready var stand_guard_button: Button = $"stand guard button"
@onready var cherish_button: Button = $"cherish button"
@onready var yawn_button: Button = $"yawn button"
@onready var ic_water_button: Button = $"ic water button"

# stats options
@onready var health_bar: ProgressBar = $"health bar"
@onready var skill_bar: ProgressBar = $"skill bar"
@onready var health_label: RichTextLabel = $"health label"
@onready var skill_label: RichTextLabel = $"skill label"


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
					["shinobi aruki", 0, -30],
					["double breathing", 0, -45],
					["distraction", 0, -20]]

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
	ninja_icon.visible = true
	text_scroll_label.text = "ninja dealt a "+str(attack_name)+"!"
	typewriter(text_scroll_label)
	await get_tree().create_timer(1).timeout
	fade_out(ninja_icon)

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
	lgh_stab_button.visible = false
	wh_candy_button.visible = false
	mud_cake_button.visible = false
	heart_rip_button.visible = false
	stand_guard_button.visible = false
	cherish_button.visible = false
	yawn_button.visible = false
	ic_water_button.visible = false
	health_bar.visible = false
	skill_bar.visible = false
	health_label.visible = false
	skill_label.visible = false
	fade_out(moves_scroll, 0.01)
	hide_move_options(0.01)
	hide_skills_options(0.01)
	hide_attack_options(0.01)
	hide_rest_options(0.01)
	if Globals.current_enemy == "ninja":
		ninja_fight()
	else:
		pass

func _process(delta: float) -> void:
	pass

# funcs that are called throughout the fight

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

func hide_skills_options(time: float = 0.5):
	fade_out(lgh_stab_button, time)
	fade_out(wh_candy_button, time)
	fade_out(mud_cake_button, time)
	fade_out(heart_rip_button, time)

func show_skills_options(time: float = 0.5):
	fade_in(lgh_stab_button, time)
	fade_in(wh_candy_button, time)
	fade_in(mud_cake_button, time)
	fade_in(heart_rip_button, time)

func hide_rest_options(time: float = 0.5):
	fade_out(stand_guard_button, time)
	fade_out(cherish_button, time)
	fade_out(yawn_button, time)
	fade_out(ic_water_button, time)

func show_rest_options(time: float = 0.5):
	fade_in(stand_guard_button, time)
	fade_in(cherish_button, time)
	fade_in(yawn_button, time)
	fade_in(ic_water_button, time)

func ninja_fight(): # called from _ready if the enemy is ninja
	enemy_health = 50
	fade_in(ninja)
	fade_in(player)
	player.play("idle front")
	player_turn() 

func player_turn():
	if enemy_health <= 0:
		return
	text_scroll.visible = true
	text_scroll_label.visible = true
	icon_border.visible = true
	fade_in(player_icon)
	lgh_stab_button.visible = false
	wh_candy_button.visible = false
	mud_cake_button.visible = false
	heart_rip_button.visible = false
	stand_guard_button.visible = false
	cherish_button.visible = false
	yawn_button.visible = false
	ic_water_button.visible = false
	fade_in(moves_scroll)
	show_move_options()

func enemy_turn():
	if enemy_health <= 0:
		player_victory()
		return
	if Globals.player_health <= 0:
		enemy_victory()
		return
	if Globals.current_enemy == "ninja":
		await ninja_attack()
	elif Globals.current_enemy == "smth": # replace w other mobs and stuff
		pass
	player_turn()


# move options buttons

func _on_attack_button_pressed() -> void:
	#hide_move_options(0.5) # cant use this bcs it covers the other buttons
	attack_button.visible = false
	skill_button.visible = false
	rest_button.visible = false
	stats_button.visible = false
	show_attack_options()
	fade_in(back_button, 0.5)

func _on_back_button_pressed() -> void:
	lgh_stab_button.visible = false # adding this bcs for some reason the buttons are visible when you hover over the attack buttons :(
	wh_candy_button.visible = false
	mud_cake_button.visible = false
	heart_rip_button.visible = false
	stand_guard_button.visible = false
	cherish_button.visible = false
	yawn_button.visible = false
	ic_water_button.visible = false
	health_bar.visible = false
	skill_bar.visible = false
	health_label.visible = false
	skill_label.visible = false
	hide_attack_options()
	hide_skills_options()
	show_move_options()
	fade_out(back_button, 0.5)

func _on_skill_button_pressed() -> void:
	attack_button.visible = false
	skill_button.visible = false
	rest_button.visible = false
	stats_button.visible = false
	show_skills_options()
	fade_in(back_button, 0.5)
	
func _on_rest_button_pressed() -> void:
	attack_button.visible = false
	skill_button.visible = false
	rest_button.visible = false
	stats_button.visible = false
	show_rest_options()
	fade_in(back_button, 0.5)

func _on_stats_button_pressed() -> void:
	attack_button.visible = false
	skill_button.visible = false
	rest_button.visible = false
	stats_button.visible = false
	fade_in(health_bar, 0.5)
	fade_in(skill_bar, 0.5)
	fade_in(back_button, 0.5)
	fade_in(health_label, 0.5)
	fade_in(skill_label, 0.5)
	health_bar.value = Globals.player_health
	skill_bar.value = Globals.player_skill


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
		await enemy_turn()
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
		await enemy_turn()
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
		await enemy_turn()
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
	await enemy_turn()




# skill moves

func _on_lgh_stab_button_pressed() -> void:
	if Globals.player_skill >= 13:
		fade_out(moves_scroll, 0.5)
		hide_move_options(0.5)
		hide_attack_options(0.5)
		hide_skills_options(0.5)
		fade_out(back_button, 0.5)
		player.play("attack")
		await get_tree().create_timer(0.5).timeout
		player.play("idle front")
		Transition_screen.flash_transition()
		await get_tree().create_timer(1).timeout
		text_scroll_label.text = "omori dealt a light stab!"
		player_icon.visible = true
		typewriter(text_scroll_label)
		await get_tree().create_timer(1).timeout
		enemy_health -= 30
		Globals.player_skill -= 13
		await enemy_turn()
	else:
		text_scroll_label.add_theme_font_size_override("normal_font_size", 16)
		text_scroll_label.text = "not enough skill to peform this move."
		player_icon.visible = true
		typewriter(text_scroll_label)

func _on_wh_candy_button_pressed() -> void:
	if Globals.player_skill >= 60:
		fade_out(moves_scroll, 0.5)
		hide_move_options(0.5)
		hide_attack_options(0.5)
		fade_out(back_button, 0.5)
		hide_skills_options(0.5)
		player.play("attack")
		await get_tree().create_timer(0.5).timeout
		player.play("idle front")
		Transition_screen.flash_transition()
		await get_tree().create_timer(1).timeout
		text_scroll_label.text = Globals.player_name+" dealt an whirling candy!"
		player_icon.visible = true
		typewriter(text_scroll_label)
		await get_tree().create_timer(1).timeout
		enemy_health -= 85
		Globals.player_skill -= 60
		await enemy_turn()
	else:
		text_scroll_label.add_theme_font_size_override("normal_font_size", 16)
		text_scroll_label.text = "not enough skill to peform this move."
		player_icon.visible = true
		typewriter(text_scroll_label)

func _on_mud_cake_button_pressed() -> void:
	if Globals.player_skill >= 30:
		fade_out(moves_scroll, 0.5)
		hide_move_options(0.5)
		hide_attack_options(0.5)
		fade_out(back_button, 0.5)
		hide_skills_options(0.5)
		player.play("attack")
		await get_tree().create_timer(0.5).timeout
		player.play("idle front")
		Transition_screen.flash_transition()
		await get_tree().create_timer(1).timeout
		text_scroll_label.text = Globals.player_name+" dealt an mud cake"
		player_icon.visible = true
		typewriter(text_scroll_label)
		await get_tree().create_timer(1).timeout
		enemy_health -= 60
		Globals.player_skill -= 30
		await enemy_turn()
	else:
		text_scroll_label.add_theme_font_size_override("normal_font_size", 16)
		text_scroll_label.text = "not enough skill to peform this move."
		player_icon.visible = true
		typewriter(text_scroll_label)

func _on_heart_rip_button_pressed() -> void:
	if Globals.player_skill >= 85:
		fade_out(moves_scroll, 0.5)
		hide_move_options(0.5)
		hide_attack_options(0.5)
		fade_out(back_button, 0.5)
		hide_skills_options(0.5)
		player.play("attack")
		await get_tree().create_timer(0.5).timeout
		player.play("idle front")
		Transition_screen.flash_transition(Color.DARK_RED, 0.7)
		await get_tree().create_timer(1.5).timeout
		text_scroll_label.text = Globals.player_name+" dealt an heart rip!"
		player_icon.visible = true
		typewriter(text_scroll_label)
		await get_tree().create_timer(1.6).timeout
		enemy_health -= 120
		Globals.player_skill -= 85
		await enemy_turn()
	else:
		text_scroll_label.add_theme_font_size_override("normal_font_size", 16)
		text_scroll_label.text = "not enough skill to peform this move."
		player_icon.visible = true
		typewriter(text_scroll_label)


# rest moves

func _on_stand_guard_button_pressed() -> void:
	fade_out(moves_scroll, 0.5)
	hide_move_options(0.5)
	hide_attack_options(0.5)
	hide_skills_options(0.5)
	hide_rest_options()
	fade_out(back_button, 0.5)
	player.play("rest")
	await get_tree().create_timer(0.5).timeout
	player.play("idle front")
	Transition_screen.flash_transition()
	await get_tree().create_timer(1).timeout
	text_scroll_label.text = Globals.player_name+" stood guard!"
	player_icon.visible = true
	typewriter(text_scroll_label)
	await get_tree().create_timer(1).timeout
	Globals.player_health += 30
	Globals.player_skill += 10
	if Globals.player_health > 100:
		Globals.player_health = 100
	if Globals.player_skill > 100:
		Globals.player_skill = 100
	await enemy_turn()


func _on_cherish_button_pressed() -> void:
	fade_out(moves_scroll, 0.5)
	hide_move_options(0.5)
	hide_attack_options(0.5)
	hide_skills_options(0.5)
	hide_rest_options()
	fade_out(back_button, 0.5)
	player.play("rest")
	await get_tree().create_timer(0.5).timeout
	player.play("idle front")
	Transition_screen.flash_transition(Color.LIGHT_GOLDENROD, 0.7)
	await get_tree().create_timer(1.5).timeout
	text_scroll_label.text = Globals.player_name+" cherished life!"
	player_icon.visible = true
	typewriter(text_scroll_label)
	await get_tree().create_timer(1.5).timeout
	Globals.player_health += 50
	if Globals.player_health > 100:
		Globals.player_health = 100
	await enemy_turn()


func _on_yawn_button_pressed() -> void:
	fade_out(moves_scroll, 0.5)
	hide_move_options(0.5)
	hide_attack_options(0.5)
	hide_skills_options(0.5)
	hide_rest_options()
	fade_out(back_button, 0.5)
	player.play("rest")
	await get_tree().create_timer(0.5).timeout
	player.play("idle front")
	Transition_screen.flash_transition()
	await get_tree().create_timer(1).timeout
	text_scroll_label.text = Globals.player_name+" yawned!"
	player_icon.visible = true
	typewriter(text_scroll_label)
	await get_tree().create_timer(1).timeout
	Globals.player_health += 25
	Globals.player_skill += 25
	if Globals.player_health > 100:
		Globals.player_health = 100
	if Globals.player_skill > 100:
		Globals.player_skill = 100
	await enemy_turn()


func _on_ic_water_button_pressed() -> void:
	fade_out(moves_scroll, 0.5)
	hide_move_options(0.5)
	hide_attack_options(0.5)
	hide_skills_options(0.5)
	hide_rest_options()
	fade_out(back_button, 0.5)
	player.play("rest")
	await get_tree().create_timer(0.5).timeout
	player.play("idle front")
	Transition_screen.flash_transition(Color.CADET_BLUE, 0.7)
	await get_tree().create_timer(1.5).timeout
	text_scroll_label.text = Globals.player_name+" threw some water in their face!"
	player_icon.visible = true
	typewriter(text_scroll_label)
	await get_tree().create_timer(1).timeout
	Globals.player_health += 15
	Globals.player_skill += 30
	if Globals.player_health > 100:
		Globals.player_health = 100
	if Globals.player_skill > 100:
		Globals.player_skill = 100
	await enemy_turn()


# endings

func player_victory():
	if Globals.current_enemy == "ninja":
		fade_out(ninja, 2.0)
		fade_out(ninja_icon, 2.0)
		player_icon.visible = true
		Transition_screen.flash_transition()
		await get_tree().create_timer(1).timeout
		player.play("jump circle")
		await get_tree().create_timer(1).timeout
		player.play("idle front")
		text_scroll_label.text = Globals.player_name+" won!"
		typewriter(text_scroll_label)

func enemy_victory():
	if Globals.current_enemy == "ninja":
		fade_out(player, 2.0)
		fade_out(player_icon, 2.0)
		ninja_icon.visible = true
		Transition_screen.flash_transition(Color.RED)
		await get_tree().create_timer(1).timeout
		ninja.play("jump circle")
		await get_tree().create_timer(1).timeout
		ninja.play("idle front")
		text_scroll_label.text = Globals.player_name+" lost!"
		typewriter(text_scroll_label)

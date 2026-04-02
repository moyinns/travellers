extends Node2D
@onready var horizontal_scroll: TextureRect = $"horizontal scroll"
@onready var yes_button: Button = $"yes button"
@onready var no_button: Button = $"no button"
@onready var skip_tutorial: Label = $"skip tutorial"
@onready var text_scroll: TextureRect = $"text scroll"
@onready var long_text_scroll: TextureRect = $"long text scroll"
@onready var text_scroll_label: RichTextLabel = $"text scroll label"
@onready var typing_sound: AudioStreamPlayer2D = $"typing sound"

var visible_characters = 0

func _ready() -> void:
	horizontal_scroll.visible = false
	yes_button.visible = false
	no_button.visible = false
	skip_tutorial.visible = false
	text_scroll.visible = false
	long_text_scroll.visible = false
	text_scroll_label.visible = false
	
	await get_tree().create_timer(1).timeout
	Transition_screen.colour_rect.visible = false
	Sound_effects.play_flash_sound()
	Transition_screen.flash_transition()
	horizontal_scroll.visible = true
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
	horizontal_scroll.visible = false
	yes_button.visible = false
	no_button.visible = false
	skip_tutorial.visible = false
	long_text_scroll.visible = false
	text_scroll.visible = true
	text_scroll_label.visible = true
	await typewriter(text_scroll_label, 2.0)

func typewriter(label, duration: float = 2.0):
	label.visible_ratio = 0.0
	typing_sound.play(4)
	
	var tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, duration)
	tween.tween_callback(func(): typing_sound.stop())
	return tween

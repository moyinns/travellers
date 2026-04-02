extends CanvasLayer # so everything renders on top of the current scene

signal on_transition_finished # declaring signal, starts when ftb transition finishes

@onready var colour_rect: ColorRect = $"colour rect"
@onready var animation_player: AnimationPlayer = $"animation player"
@onready var flash_rect: ColorRect = $flash_rect

func _ready():
	colour_rect.visible = false
	flash_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished) # basc, connects the two so whenever the ots signal is fired, this plays

func _on_animation_finished(anim_name): # built in func, called auto when any animation finishes
	if anim_name == "fade_to_black":
		on_transition_finished.emit() # emits signal
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		colour_rect.visible = false

func transition(): # called from other scripts to trigger a transition
	colour_rect.visible = true # makes the transition thingy visible, but opacity is still 0 at start anyways
	animation_player.play("fade_to_black")
	
func flash_transition(colour: Color = Color.WHITE, duration: float = 0.3): # flashes w/ a given colour + fade
	flash_rect.color = colour
	flash_rect.modulate.a = 1.0 # resets flash so fully visible
	flash_rect.visible = true
	
	var tween = create_tween() # tween basc = a temp animator, allows u to change a val over time
	tween.tween_property(flash_rect, "modulate:a", 0.0, duration) # aka smoothly change flash_rects alpga from 1 -> 0 over duraction seconds
	tween.tween_callback(func(): flash_rect.visible = false) # and once ur done, call this func (bcs callback req an input func), so invis
	

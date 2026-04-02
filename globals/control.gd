extends Control
@onready var button: AudioStreamPlayer2D = $button
@onready var typing: AudioStreamPlayer2D = $typing
@onready var bg_music: AudioStreamPlayer2D = $"bg music"
@onready var flash: AudioStreamPlayer2D = $flash



func play_button_sound(): # this plays the button sound effect
	button.play()
	
func play_typing_sound(): # this plays the typing sound effect
	typing.play()
	
func stop_typing_sound(): # this stops the typing sound effects
	typing.stop()

func play_flash_sound(): # this plays the flash sound effect
	flash.play()

extends Control

@onready var text_node := %Speech_Text
@onready var name_node := %Name_Text
@onready var sfx_node  := $Speech_SFX

var show_all: bool

# Seconds before showing next text character
var seconds_per_char := 0.03
var next_char_timer: float



#┗⋟━━━━━━━━━━━━━━━━━━━━━━━━━━// STUFF //━━━━━━━━━━━━━━━━━━━━━━━━━━⋟┓

func _ready() -> void:
	set_text("Riazey", "Testing many a word including some stuff \nlike new lines and stuff.\nWe fit so many lines in this guy.")



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if text_node.visible_characters >= text_node.text.length():
			show_all = true
		else:
			visible = false #Hide the dialogue box


func set_text( speaker_name:String, text:String ) -> void:
	name_node.text = speaker_name
	text_node.visible_characters = 0
	text_node.text = text
	set_process(true)



#┗⋟━━━━━━━━━━━━━━━━━━━━━━━━━━// TEXT PROCESSING //━━━━━━━━━━━━━━━━━━━━━━━━━━⋟┓

func _process(delta: float) -> void:
	# Basically while set_process() is TRUE this will run, if it is FALSE this will not run
	if next_char_timer < seconds_per_char:
		next_char_timer += delta
	else:
		show_next_char()


func show_next_char() -> void:
	if !sfx_node.is_playing():
		sfx_node.pitch_scale = randf_range(0.5, 1.0)
		sfx_node.play()
	
	# Show another character
	text_node.visible_characters += 1
	next_char_timer = 0
	
	# If should jump to end of dialogue
	if show_all:
		show_all = false
		text_node.visible_characters = text_node.text.length()
	
	# Finished showing text
	if text_node.visible_characters >= text_node.text.length():
		set_process(false)

extends Control

@onready var dialogue_box: PanelContainer = null
@onready var text_label: RichTextLabel = null
@onready var audio_player: AudioStreamPlayer = null

@onready var curr_Felix: TextureRect = null
@onready var curr_Opp: TextureRect = null

var asset_felix_viking = preload("res://sprites/Felix_Locked.png")
var asset_felix_blep = preload("res://sprites/Felix_Geeked.png")
var asset_felix_stare = preload("res://sprites/Felix_Default.png")

var asset_dog_king = preload("res://sprites/DKing.png")         
var asset_dog_geeked = preload("res://sprites/Dog_Geeked.png")       
var asset_dog_brain = preload("res://sprites/Dawg.png")        

var typewriter_sound = preload("res://Purrin.wav")
var king_sound = preload("res://Barkin.wav")
var char_delay: float = 0.0375

var dialogue_queue: Array[String] = [
	"YOUR HIGHNESS! YOUR HIGHNESS!!", 
	"What, Felix.",
	"I tell you in earnesty that though I am a peasant, I'm one of thou most loyal subjects, you must forgive me!",
	"For one, you would destroy me over catnip if you could, and two..",
	"NO.",
	"But you must understand..",
	"No.",
	"I intned to mend this",
	"NO.",
	"My ability knows no bound-",
	"Well..",
	"I'll-",
	"actually hold on, wait a minute",
	"You ruin my banquet, the one thing distracting me from my kidnapped daughter,",
	"YOUR DAUGHTER WAS KIDNAPPED???",
	"(In the unfinished prologue of the game that is mentioned first, but the juedges dont know that)",
	"Anyway.. and then you waffle about these 'endless limtits' while you do NOTHING.",
	"well ackshully-",
	"leave my kingdom, Felix. And do not return.",
	"And if I find the princess, then what?",
	"You will bring her to me.",
	"And I come with her?",
	"...",
	"...?",
	"We-",
	"oh bet that."
]

var current_line_index: int = 0
var is_typing: bool = false
var skip_requested: bool = false

func _ready() -> void:

	dialogue_box = generate_dialogue_box()
	add_child(dialogue_box)
	
	curr_Felix = TextureRect.new()
	curr_Felix.name = "CurrFelix"
	curr_Felix.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	curr_Felix.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	curr_Felix.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	curr_Felix.anchor_left = 0.125
	curr_Felix.anchor_right = 0.500 
	curr_Felix.anchor_top = 0.325   
	curr_Felix.anchor_bottom = 0.70
	curr_Felix.grow_horizontal = Control.GROW_DIRECTION_END
	curr_Felix.grow_vertical = Control.GROW_DIRECTION_BEGIN
	curr_Felix.texture = asset_felix_stare 
	add_child(curr_Felix)
	
	curr_Opp = TextureRect.new()
	curr_Opp.name = "CurrOpp"
	curr_Opp.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	curr_Opp.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	curr_Opp.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	curr_Opp.anchor_left = 0.500   
	curr_Opp.anchor_right = 0.875
	curr_Opp.anchor_top = 0.325
	curr_Opp.anchor_bottom = 0.70
	curr_Opp.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	curr_Opp.grow_vertical = Control.GROW_DIRECTION_BEGIN
	curr_Opp.texture = asset_dog_king 
	add_child(curr_Opp)
	
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	
	text_label = RichTextLabel.new()
	text_label.name = "DialogueLabel"
	text_label.add_theme_color_override("default_color", Color.BLACK)
	text_label.add_theme_font_size_override("normal_font_size", 32)
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_label.bbcode_enabled = true
	
	var comic_sans = SystemFont.new()
	comic_sans.font_names = PackedStringArray(["Comic Sans MS", "Comic Sans"])
	text_label.add_theme_font_override("normal_font", comic_sans)
	
	var padding_container = dialogue_box.get_node("TextPadding")
	padding_container.add_child(text_label)
	
	display_current_line()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			skip_requested = true
		else:
			current_line_index += 1
			display_current_line()
	elif event.is_action_pressed("hit_tilde"):
		get_tree().change_scene_to_file("res://level_2.tscn")

func display_current_line() -> void:
	if current_line_index >= dialogue_queue.size():
		get_tree().change_scene_to_file("res://level_2.tscn")
		$AudioStreamPlayer.stop()
		curr_Felix.queue_free()
		curr_Opp.queue_free()
		dialogue_box.queue_free()
		
		return
		
	var current_index: int = current_line_index
	
	# --- Dynamic Cat (Felix) Sprite State Updates ---
	var felix_viking_indexes = [7, 9, 25]
	var felix_blep_indexes = [17, 19, 21, 22]
	var felix_stare_indexes = [0, 2, 5, 14, 20, 23,]
	
	if current_index in felix_viking_indexes:
		curr_Felix.texture = asset_felix_viking 
	elif current_index in felix_blep_indexes:
		curr_Felix.texture = asset_felix_blep   
	elif current_index in felix_stare_indexes:
		curr_Felix.texture = asset_felix_stare  

	# --- Dynamic Dog Variant Sprite State Updates ---
	if current_index >= 21:
		curr_Opp.texture = asset_dog_brain   
	elif current_index >= 16:
		curr_Opp.texture = asset_dog_king    
	elif current_index >= 15:
		curr_Opp.texture = asset_dog_brain   
	elif current_index >= 13:
		curr_Opp.texture = asset_dog_king    
	elif current_index >= 11:
		curr_Opp.texture = asset_dog_brain   
	elif current_index >= 8:
		curr_Opp.texture = asset_dog_geeked  
	elif current_index >= 6:
		curr_Opp.texture = asset_dog_brain   
	elif current_index >= 4:
		curr_Opp.texture = asset_dog_geeked  
	else:
		curr_Opp.texture = asset_dog_king    

	# --- Voice Asset Key Checks ---
	var purrin_indexes = [0, 2, 5, 7, 11, 15, 17, 19, 24, 27, 29, 31, 33, 35]
	
	if current_index in purrin_indexes:
		audio_player.stream = typewriter_sound
		audio_player.volume_db = -6.00
	else:
		audio_player.stream = king_sound
		audio_player.volume_db = -12.00
		
	type_text(dialogue_queue[current_index])

func type_text(full_text: String) -> void:
	is_typing = true
	skip_requested = false
	text_label.text = ""

	for i in range(full_text.length()):
		if skip_requested:
			text_label.text = full_text
			break
			
		text_label.text += full_text[i]

		if i % 2 == 0:
			audio_player.play()

		await get_tree().create_timer(char_delay).timeout
		
	is_typing = false
	skip_requested = false

func generate_dialogue_box() -> PanelContainer:
	var panel_container = PanelContainer.new()
	panel_container.name = "DialogueBox"
	
	panel_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel_container.anchor_left = 0.125
	panel_container.anchor_right = 0.875
	panel_container.anchor_bottom = 0.9375
	panel_container.anchor_top = 0.70
	
	panel_container.offset_left = 0
	panel_container.offset_right = 0
	panel_container.offset_top = 0
	panel_container.offset_bottom = 0

	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color.from_string("F5F5DC", Color.BEIGE)
	style_box.border_color = Color.from_string("D8BFD8", Color.THISTLE)
	style_box.set_border_width_all(6)
	style_box.set_content_margin_all(0)
	
	panel_container.add_theme_stylebox_override("panel", style_box)

	var margin_container = MarginContainer.new()
	margin_container.name = "TextPadding"
	
	margin_container.add_theme_constant_override("margin_left", 40)
	margin_container.add_theme_constant_override("margin_right", 40)
	margin_container.add_theme_constant_override("margin_top", 25)
	margin_container.add_theme_constant_override("margin_bottom", 25)
	
	margin_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel_container.add_child(margin_container)
	
	return panel_container

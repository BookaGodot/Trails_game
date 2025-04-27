extends Button

#@export var color = Color.WHITE
@export var button_text : String = "DEFAULT"
@export var button_icon : Texture2D

@onready var audio_comp = $random_audio_component
@onready var label: Label = $label
@onready var texture: TextureRect = $texture


func _ready():
	pressed.connect(on_pressed)
	
	#self_modulate = color
	texture.texture = button_icon
	label.text = button_text


func on_pressed():
	pivot_offset = size / 2
	
	var old_scale = scale
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "scale", scale * 1.15, 0.025).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.chain()
	tween.tween_property(self, "scale", old_scale, 0.05).set_delay(0.025).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	await tween.finished
	scale = old_scale
	
	audio_comp.play_random()
	
	

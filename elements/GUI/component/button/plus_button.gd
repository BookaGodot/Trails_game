extends Button

@onready var audio_comp = $random_audio_component


func _ready():
	pressed.connect(on_pressed)



func on_pressed():
	pivot_offset = size / 2
	
	var old_scale = scale
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "scale", scale * 1.1, 0.025).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.chain()
	tween.tween_property(self, "scale", old_scale, 0.05).set_delay(0.025).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	await tween.finished
	scale = old_scale
	
	audio_comp.play_random()
	
	

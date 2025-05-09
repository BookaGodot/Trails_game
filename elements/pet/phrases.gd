extends Label

const SHOW_TIME : float = 6.0
const NEUTRAL_PHRASES_COUNT : int = 14
const FUNNY_PHRASES_COUNT : int = 13
const ANXIOUS_PHRASES_COUNT : int = 14
const SHY_PHRASES_COUNT : int = 15
const DREAMY_PHRASES_COUNT : int = 13
const STUBBORN_PHRASES_COUNT : int = 14

@onready var temperament: Temperament = %Temperament

var phrase_prefix : String
var max_phrases : int
var tween : Tween


func _ready() -> void:
	match temperament.temperament:
		Temperament.Temperaments.FUNNY:
			phrase_prefix = "FUNNY"
			max_phrases = FUNNY_PHRASES_COUNT
		Temperament.Temperaments.ANXIOUS:
			phrase_prefix = "ANXIOUS"
			max_phrases = ANXIOUS_PHRASES_COUNT
		Temperament.Temperaments.SHY:
			phrase_prefix = "SHY"
			max_phrases = SHY_PHRASES_COUNT
		Temperament.Temperaments.DREAMY:
			phrase_prefix = "DREAMY"
			max_phrases = DREAMY_PHRASES_COUNT
		Temperament.Temperaments.STUBBORN:
			phrase_prefix = "STUBBORN"
			max_phrases = STUBBORN_PHRASES_COUNT
		_:
			phrase_prefix = "NEUTRAL"
			max_phrases = NEUTRAL_PHRASES_COUNT
	
	%RandomPhraseTimer.timeout.connect(show_phrase.bind(phrase_prefix + str(randi_range(2, max_phrases))))
	show_phrase(phrase_prefix + "1")


func show_phrase(phrase_text : String) -> void:
	if %RandomAnimationTimer.is_stopped():
		print("Random animation is playing right now")
		return
	
	show()
	_tween_transparency(1.0)
	text = tr(phrase_text)
	await get_tree().create_timer(SHOW_TIME).timeout
	
	_tween_transparency(0.0)
	await tween.finished
	hide()


func _tween_transparency(final_value : float) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate:a", final_value, 0.5)

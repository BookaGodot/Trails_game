extends CanvasLayer

@onready var care_bar: ProgressBar = %HealthBar
@onready var pet: Pet = %Pet


func _ready() -> void:
	care_bar.value = pet.state.care
	Events.care_changed.connect(update_care)


func update_care(value : float):
	care_bar.value = value

extends CanvasLayer

@onready var health_bar: ProgressBar = %HealthBar

func _ready() -> void:
	Events.health_changed.connect(update_health)
	
	
func update_health():
	health_bar.value = Globals.health

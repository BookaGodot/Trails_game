extends CanvasLayer

@onready var happy_bar: ProgressBar = %happy_bar
@onready var hunger_bar: ProgressBar = %hunger_Bar
@onready var sleep_bar: ProgressBar = %sleep_bar
@onready var clean_bar: ProgressBar = %clean_bar


func _ready() -> void:
	Events.progressbar_changed.connect(update_progressbar)
	Events.progressbar_changed.emit()
	
func update_progressbar():
	print("update")
	happy_bar.value = Globals.happy
	hunger_bar.value = Globals.hunger
	sleep_bar.value = Globals.sleep
	clean_bar.value = Globals.clean

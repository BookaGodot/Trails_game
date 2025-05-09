extends CanvasLayer

@onready var care_bar: ProgressBar = %HealthBar
@onready var pet: Pet = %Pet

@onready var feed_button: Button = %feed_button
@onready var wash_button: Button = %wash_button
@onready var play_button: Button = %play_button
@onready var sleep_button: Button = %sleep_button
@onready var money_count: Label = %money_count


func _ready() -> void:
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
	shop_control.visible = false
	
=======
>>>>>>> parent of cefc7c6 (shop buy implemented, changed window size)
=======
>>>>>>> parent of cefc7c6 (shop buy implemented, changed window size)
	care_bar.value = pet.state.care
=======
	care_bar.value = pet.care
>>>>>>> Anton
	Events.care_changed.connect(update_care)
	Events.money_updated.connect(money_update)
	feed_button.pressed.connect(on_feed_pressed)
	wash_button.pressed.connect(on_wash_pressed)
	play_button.pressed.connect(on_play_pressed)
	#sleep_button.pressed.connect(on_sleep_pressed)
	
	money_update()


func money_update():
	money_count.text = str(Events.money)


func update_care(value : float):
	care_bar.value = value


func on_feed_pressed():
	pet.feed()

func on_wash_pressed():
	pet.clean()

func on_play_pressed():
	pet.make_happy()

#func on_sleep_pressed():
	#pet.sleep()

extends CanvasLayer

@onready var care_bar: ProgressBar = %HealthBar
@onready var pet: Pet = %Pet

@onready var feed_button: Button = %feed_button
@onready var wash_button: Button = %wash_button
@onready var play_button: Button = %play_button
@onready var options_button: Button = %options_button
@onready var journal_button: Button = %journal_button
@onready var plus_button: Button = %plus_button
@onready var inventory_button: Button = %inventory_button
@onready var shop_button: Button = %shop_button

@onready var shop_control: Control = %shop_control
@onready var action_buttons: HBoxContainer = %action_buttons
@onready var money_count: Label = %money_count
@onready var shop_money: Label = %shop_money

var shop_opened : bool = false

func _ready() -> void:
	shop_control.visible = false
	
	care_bar.value = pet.state.care
	Events.care_changed.connect(update_care)
	Events.money_updated.connect(money_update)
	feed_button.pressed.connect(on_feed_pressed)
	wash_button.pressed.connect(on_wash_pressed)
	play_button.pressed.connect(on_play_pressed)
	
	options_button.pressed.connect(on_options_pressed)
	journal_button.pressed.connect(on_journal_pressed)
	plus_button.pressed.connect(on_plus_pressed)
	inventory_button.pressed.connect(on_inventory_pressed)
	shop_button.pressed.connect(on_shop_pressed)
	
	money_update()


func money_update():
	money_count.text = str(Events.money)
	shop_money.text = str(Events.money)


func update_care(value : float):
	care_bar.value = value


func on_feed_pressed():
	pet.feed()

func on_wash_pressed():
	pet.clean()

func on_play_pressed():
	pet.make_happy()


func on_options_pressed():
	pass

func on_journal_pressed():
	pass

func on_plus_pressed():
	pass

func on_inventory_pressed():
	pass

func on_shop_pressed():
	shop_opened = !shop_opened
	shop_control.visible = shop_opened
	action_buttons.visible = !shop_opened

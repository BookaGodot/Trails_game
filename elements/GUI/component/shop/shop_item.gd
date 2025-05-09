extends TextureRect

@onready var anim_player : AnimationPlayer = $anim_player
@onready var hover_player : AnimationPlayer = $hover_player
@onready var sprite: TextureRect = %sprite
@onready var item_name: Label = %item_name
@onready var item_type: Label = %item_type
@onready var item_price: Label = %item_price
@onready var button: Button = %button

var item_resource : ShopItem

signal selected

var is_selected = false
var disabled = false
var shop_menu = null

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)
	button.pressed.connect(buy_item)
	
	shop_menu = get_tree().get_first_node_in_group("shop_menu")


func set_item(shop_card: ShopItem):
	item_resource = shop_card
	sprite.texture = shop_card.icon
	item_name.text = str(shop_card.name)
	item_price.text = str(shop_card.price)
	item_type.text = str(shop_card.type)


func select_card():
	is_selected = true
	anim_player.play("selected")
	$click_audio.play_random()
	selected.emit()
	
	var other_cards = get_tree().get_nodes_in_group("shop_card")
	
	for card in other_cards:
		if card != self:
			card.unselect()


func unselect():
	if is_selected:
		is_selected = false
		anim_player.play_backwards("selected")


func on_gui_input(event: InputEvent):
	if disabled:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		select_card()


func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	anim_player.play("in")


func on_mouse_entered():
	if disabled:
		return
	hover_player.play("hover")


func buy_item():
	var money = SaveSystem.get_var("money", 20)
	print("Starter money")
	if item_resource.price > money:
		print("Not enough money")
		return
	else:
		print("Bought")
		var after_money = int(money - item_resource.price)
		SaveSystem.set_var("money", after_money)
		SaveSystem.save()
		var counters = get_tree().get_nodes_in_group("money_counter")
		for counter in counters:
			counter.text = str(after_money)
		print("After money: " + str(SaveSystem.get_var("money", 20)))

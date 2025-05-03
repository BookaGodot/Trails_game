class_name AnimationManager
extends Node

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var random_animation_timer: Timer = $RandomAnimationTimer
@onready var random_phrase_timer: Timer = %RandomPhraseTimer

@export var action_animations: Array[StringName]
@export var state_animations: Array[StringName]
@export var random_animations: Array[StringName]
@export var idle_animations: Array[StringName]

var current_action_animation: StringName = ""
var current_random_animation: StringName = ""
var current_idle_animation: StringName = ""

var state_animation_queue: Array[StringName] = []


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)
	_update_animation()
	random_animation_timer.timeout.connect(play_random_animation.bind(random_animations.pick_random()))


func play_action_animation(animation_name: StringName) -> void:
	if not action_animations.has(animation_name):
		push_error("action_animations doesn't have animation called \"" + animation_name + "\"")
		return
	
	clear_random_animation()
	random_animation_timer.start()
	random_phrase_timer.start()
	
	current_action_animation = "action/" + animation_name
	_update_animation()


func queue_state_animation(animation_name: StringName) -> void:
	if not state_animations.has(animation_name):
		push_error("state_animations doesn't have animation called \"" + animation_name + "\"")
		return
	
	var full_animation_name = "state/" + animation_name
	
	if state_animation_queue.has(full_animation_name):
		return
	
	state_animation_queue.append(full_animation_name)
	print_rich("[color=yellow]State animation added")
	if state_animation_queue.size() == 1:
		_update_animation()


func play_random_animation(animation_name: StringName) -> void:
	if not random_animations.has(animation_name):
		push_error("random_animations doesn't have animation called \"" + animation_name + "\"")
		return
	
	current_random_animation = "random/" + animation_name
	_update_animation()


func play_idle_animation(animation_name: StringName) -> void:
	if not idle_animations.has(animation_name):
		push_error("idle_animations doesn't have animation called \"" + animation_name + "\"")
		return
	
	current_idle_animation = "idle/" + animation_name
	_update_animation()


func clear_action_animation() -> void:
	current_action_animation = ""
	_update_animation()


func remove_state_animation(animation_name: StringName) -> void:
	if not state_animation_queue.is_empty():
		state_animation_queue.erase("state/" + animation_name)
		print_rich("[color=red]State animation removed")
		_update_animation()


func clear_random_animation() -> void:
	current_random_animation = ""
	_update_animation()


func clear_idle_animation() -> void:
	current_idle_animation = ""
	_update_animation()


func _update_animation() -> void:
	var animation_to_play: StringName = ""
	
	%BubblesEffect.hide()
	%DirtEffect.hide()
	
	if current_action_animation != "":
		animation_to_play = current_action_animation
	elif not state_animation_queue.is_empty():
		animation_to_play = state_animation_queue[0]  # Берем первую анимацию из очереди
	elif current_random_animation != "":
		animation_to_play = current_random_animation
	elif current_idle_animation != "":
		animation_to_play = current_idle_animation

	if animation_to_play != "":
		if animation_player.current_animation != animation_to_play:
			print("new animation: " + animation_to_play)
			animation_player.play(animation_to_play)


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == current_action_animation and !anim_name in ["play", "play2"]:
		clear_action_animation()
	elif not state_animation_queue.is_empty() and anim_name == state_animation_queue[0]:
		state_animation_queue.pop_front()
		print_rich("[color=yellow]State animation from queue finished")
	elif anim_name == current_random_animation:
		clear_random_animation()
	
	_update_animation()

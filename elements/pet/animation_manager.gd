class_name AnimationManager
extends Node

@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export var action_animations: Array[StringName]
@export var state_animations: Array[StringName]
@export var random_animations: Array[StringName]
@export var idle_animations: Array[StringName]

var current_action_animation: StringName = ""
var current_state_animation: StringName = ""
var current_random_animation: StringName = ""
var current_idle_animation: StringName = ""

var state_animation_queue: Array[StringName] = []


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)
	_update_animation()


func play_action_animation(animation_name: StringName) -> void:
	if not action_animations.has(animation_name):
		push_error("action_animations doesn't have animation called " + animation_name)
		return
	
	current_action_animation = animation_name
	_update_animation()


func play_state_animation(animation_name: StringName) -> void:
	if not state_animations.has(animation_name):
		push_error("state_animations doesn't have animation called " + animation_name)
		return
	
	current_state_animation = animation_name
	state_animation_queue.clear()
	_update_animation()


func queue_state_animation(animation_name: StringName) -> void:
	if not state_animations.has(animation_name):
		push_error("state_animations doesn't have animation called " + animation_name)
		return
	if state_animation_queue.has(animation_name):
		return
	
	state_animation_queue.append(animation_name)


func play_random_animation(animation_name: StringName) -> void:
	if not random_animations.has(animation_name):
		push_error("random_animations doesn't have animation called " + animation_name)
		return
	
	current_random_animation = animation_name
	_update_animation()


func play_idle_animation(animation_name: StringName) -> void:
	if not idle_animations.has(animation_name):
		push_error("idle_animations doesn't have animation called " + animation_name)
		return
	
	current_idle_animation = animation_name
	_update_animation()


func clear_action_animation() -> void:
	current_action_animation = ""
	_update_animation()


func clear_state_animation() -> void:
	current_state_animation = ""
	_update_animation()


func clear_random_animation() -> void:
	current_random_animation = ""
	_update_animation()


func clear_idle_animation() -> void:
	current_idle_animation = ""
	_update_animation()


func _update_animation() -> void:
	var animation_to_play: StringName = ""
	
	if current_action_animation != "":
		animation_to_play = current_action_animation
	elif current_state_animation != "":
		animation_to_play = current_state_animation
	elif current_random_animation != "":
		animation_to_play = current_random_animation
	elif current_idle_animation != "":
		animation_to_play = current_idle_animation
	
	if animation_to_play != "":
		if animation_player.current_animation != animation_to_play:
			animation_player.play(animation_to_play)


func _on_animation_finished(anim_name: StringName) -> void:
	if animation_player.has_animation(anim_name):
		var animation = animation_player.get_animation(anim_name)
		if animation.loop:
			return
	
	if anim_name == current_action_animation:
		clear_action_animation()
	elif anim_name == current_state_animation:
		if state_animation_queue.size() > 0:
			current_state_animation = state_animation_queue.pop_front()
		else:
			clear_state_animation()
	elif anim_name == current_random_animation:
		clear_random_animation()
	
	_update_animation()

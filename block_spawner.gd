extends Node2D

const TETRAMINOS = [preload("res://tetraminos/tetramino_cube.tscn"),
					preload("res://tetraminos/tetramino_long.tscn"),
					preload("res://tetraminos/tetramino_t.tscn")]

@onready var floor: StaticBody2D = $Floor
@onready var camera: Camera2D = $Floor/Camera2D
@onready var marker: Marker2D = $Floor/Camera2D/Marker2D
@onready var blocks: Node2D = $Floor/Blocks
@onready var timer: Timer = $Timer

var camera_speed = 32
var block_amplitude: float = 3.0  # Controls the amplitude of the sinusoidal movement
var block_speed: float = 3.0  # Speed of the sine wave (frequency)
var block_time: float = 0.0  # Tracks the time for the sine wave

var hp = 3
var score = 0

func _ready() -> void:
	timer.start()


func _process(delta: float) -> void:
	$CanvasLayer/HPLabel.text = "HP: " + str(hp)
	$CanvasLayer/ScoreLabel.text = "Score: " + str(score)


func _physics_process(delta: float) -> void:
	if len(blocks.get_children()) > 2:
		var camera_target_move = blocks.get_children()[-2].global_position.y - 128 - camera.global_position.y
		if camera_target_move < 0:
			camera.global_position.y += sign(camera_target_move) * camera_speed * delta

	block_time += delta
	for block in blocks.get_children():
		if block.is_in_group("tetramino_dynamic"):
			block.global_position.x += block_amplitude * sin(block_time * block_speed)


func spawn_block():
	var new_block = TETRAMINOS.pick_random().instantiate()
	new_block.add_to_group("tetramino_dynamic")
	new_block.global_position = marker.global_position
	#FIXME Make proper position determination here
	# if len(blocks.get_children()) > 1:
	#    new_block.global_position.x = blocks.get_children()[-2].global_position.x
	blocks.add_child(new_block)
	score += 1  


func _on_timer_timeout() -> void:
	spawn_block()
	# camera_speed = -12


func _on_block_fail_cheker_body_entered(body: Node2D) -> void:
	if body.is_in_group("tetramino_dynamic") or body.is_in_group("tetramino_laying"):
		hp -= 1
		body.queue_free()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		for block in blocks.get_children():
			if block.is_in_group("tetramino_dynamic"):
				block.gravity_scale = 10
	if event.is_action_pressed("ui_up"):
		for block in blocks.get_children():
			if block.is_in_group("tetramino_dynamic"):
				block.rotation += 90
		

func _on_block_solid_cheker_body_exited(body: Node2D) -> void:
	if body.is_in_group("tetramino_laying") and body.linear_velocity.length() < 1:
		body.remove_from_group("tetramino_laying")
		body.add_to_group("tetramino_static")
		body.freeze = true

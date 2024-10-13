extends RigidBody2D


@onready var sprites: Node2D = $Sprites
var possible_colors = [
	Color(0.75, 0.1, 0.1),
	Color(0, 0.75, 0.25),
	Color(0, 0.25, 0.75),
]


func _ready() -> void:
	var tetramino_color = possible_colors.pick_random()
	for sprite in sprites.get_children():
		sprite.self_modulate = tetramino_color

	
func _on_area_2d_body_entered(body) -> void:
	print("Entered body!, self: ", body == self)
	if body != self:
		linear_velocity = Vector2(0.0, 0.0)
		gravity_scale = 1.0
		mass = 20
		if is_in_group("tetramino_dynamic"):
			remove_from_group("tetramino_dynamic")
		add_to_group("tetramino_laying")

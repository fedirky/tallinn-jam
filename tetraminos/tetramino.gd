extends RigidBody2D


func _on_area_2d_body_entered(body) -> void:
    print("Entered body!, self: ", body == self)
    if body != self:
        linear_velocity = Vector2(1.0, 1.0)
        gravity_scale = 1.0
        if is_in_group("tetramino_dynamic"):
            remove_from_group("tetramino_dynamic")
        add_to_group("tetramino_laying")

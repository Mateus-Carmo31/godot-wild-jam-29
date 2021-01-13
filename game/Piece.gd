extends CollisionObject2D
class_name Piece

export(Array, Vector2) var relative_spaces
export(bool) var moveable = true
export(bool) var rotatable = true
export(bool) var starts_placed = false
export(bool) var victory_requirement = false

onready var original_position : Vector2 = position
onready var original_relatives = relative_spaces
var placed = false

signal selected

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			emit_signal("selected")

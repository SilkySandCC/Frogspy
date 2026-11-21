extends Area2D
## Invisible click target placed over a frog in the drawing.

signal found

var is_found := false


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if is_found:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_found = true
		queue_redraw()
		found.emit()


func _draw() -> void:
	if is_found:
		draw_arc(Vector2.ZERO, 50, 0, TAU, 48, Color.RED, 6)

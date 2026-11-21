extends Node2D
## Left-click frogs, right-drag to pan, mouse wheel to zoom.

const MAX_ZOOM := 3.0

@onready var camera: Camera2D = $Camera2D
@onready var drawing: Sprite2D = $Drawing
@onready var label: Label = $UI/Label

var total := 0
var found_count := 0


func _ready() -> void:
	var frogs := get_tree().get_nodes_in_group("frogs")
	total = frogs.size()
	for frog in frogs:
		frog.found.connect(_on_frog_found)
	camera.position = drawing.texture.get_size() / 2
	_zoom(0.0)  # start fully zoomed out (clamped to fit)
	_update_label()


func _on_frog_found() -> void:
	found_count += 1
	_update_label()


func _update_label() -> void:
	label.text = "Frogs found: %d / %d" % [found_count, total]
	if found_count == total:
		label.text += "  -  You found them all!"


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_RIGHT:
		camera.position -= event.relative / camera.zoom
		_clamp_camera()
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom(1.1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom(1 / 1.1)


func _zoom(factor: float) -> void:
	var z := clampf(camera.zoom.x * factor, _min_zoom(), MAX_ZOOM)
	camera.zoom = Vector2(z, z)
	_clamp_camera()


# Smallest zoom where the drawing still fills the screen.
func _min_zoom() -> float:
	var view := get_viewport_rect().size
	var art := drawing.texture.get_size()
	return maxf(view.x / art.x, view.y / art.y)


func _clamp_camera() -> void:
	var half := get_viewport_rect().size / camera.zoom / 2
	camera.position = camera.position.clamp(half, drawing.texture.get_size() - half)

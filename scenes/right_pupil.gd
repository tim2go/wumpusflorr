extends Node2D

@export var max_offset := 2.0

var pupil_offset := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var local_mouse_pos = get_local_mouse_position()
	var dir = local_mouse_pos.normalized()
	var dist = local_mouse_pos.length()
	pupil_offset = dir*min(dist, max_offset)
	#i see a goon
	queue_redraw()
	
func _draw():
	draw_circle(pupil_offset, 8, Color.BLACK)
	

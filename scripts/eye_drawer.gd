extends Sprite2D

@export var max_offset : float = 2.0

@onready var left_eye : Node2D = %left_eye
@onready var right_eye : Node2D = %right_eye

var pupil_offset : Vector2
const eye_radius : int = 10
const pupil_radius : int = 8

func _process(_delta: float) -> void:
	var mouse_pos = get_local_mouse_position()
	var dir = mouse_pos.normalized()
	var dist = mouse_pos.length()
	pupil_offset = dir*min(dist, max_offset)
	queue_redraw()
	
func _draw():
	
	# draw left eye
	draw_circle(left_eye.position, eye_radius, Color.WHITE)
	draw_circle(left_eye.position + pupil_offset, pupil_radius, Color.RED)
	
	# draw right eye
	draw_circle(right_eye.position, eye_radius, Color.WHITE)
	draw_circle(right_eye.position + pupil_offset, pupil_radius, Color.BLACK)

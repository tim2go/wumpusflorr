extends Sprite2D

@onready var pellet_scene : PackedScene = preload("res://scenes/pellet.tscn")

var player : Node = null

var dist : int = 128 # distance that petal should keep away from player
var current_angle : int = 0
@export var degrees_per_second : int = 90
@export var follow_speed : float = 10.0 #delay amnt
var lag_offset : Vector2 = Vector2.ZERO

func update_position() -> void:
	"""
	Updates position of the petal using current angle and distance
	Parameters: None
	Returns: None
	"""
	$".".position = lag_offset + Vector2(dist*cos(deg_to_rad(current_angle)), dist*sin(deg_to_rad(current_angle)))

func _ready() -> void:
	Global.collided_with_pellet.connect(_on_collided_with_enemy) # connects enemy signal
	update_position()

func apply_movement_lag(movement_delta: Vector2, delta: float) -> void:
	#make it delayed
	lag_offset -= movement_delta
	#smoothly move it to the tae parking weber correct possition
	lag_offset = lag_offset.lerp(Vector2.ZERO, follow_speed * delta)

func _physics_process(delta: float) -> void:
	current_angle += degrees_per_second * delta # calculates what the angle should be
	#keeps angle between 0-360
	if current_angle >= 360:
		current_angle -= 360
	update_position() # updates position
	
# called when any pellet collides with enemy
func _on_collided_with_enemy(collided_area : Area2D) -> void:
	if %PelletArea == collided_area: # checks if this pellet is the one that collided
		# removes pellet from pellet_inventory
		for p in range(len(Global.pellet_inventory)-1, -1, -1):
			if $"." == Global.pellet_inventory[p]:
				Global.pellet_inventory.remove_at(p)
				queue_free() # delete pellet

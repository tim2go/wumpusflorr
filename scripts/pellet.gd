extends Sprite2D

@onready var pellet_scene : PackedScene = preload("res://scenes/pellet.tscn")

var player : Node = null
var tilemap : Node2D

var dist : int = 128 # distance that petal should keep away from player
var current_angle : int = 0
@export var degrees_per_second : int = 90
@export var follow_speed : float = 22.0 #delay amnt
@export var respawn_delay : float = 3.0
var lag_offset : Vector2 = Vector2.ZERO
var is_respawning := false

const max_health : int = 50
var health : int = max_health
var damage : int = 50

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

func _set_active(active: bool) -> void:
	visible = active
	%PelletArea.monitoring = active
	%PelletArea.monitorable = active
	dist = 100
	var shape := %PelletArea.get_node("CollisionShape2D") as CollisionShape2D
	if shape:
		shape.set_deferred("disabled", not active)

func apply_movement_lag(movement_delta: Vector2, delta: float) -> void:
	#make it delayed
	lag_offset -= movement_delta
	#smoothly move it to the tae parking weber correct possition
	lag_offset = lag_offset.lerp(Vector2.ZERO, follow_speed * delta)

func _physics_process(delta: float) -> void:
	if not Global.paused:
		current_angle += degrees_per_second * delta # calculates what the angle should be
		#keeps angle between 0-360
		if current_angle >= 360:
			current_angle -= 360
		update_position() # updates position
		
	#check if pellet collides with wall
	var tile_coords = tilemap.local_to_map(global_position/2)
	var tile_atlas = tilemap.get_cell_atlas_coords(tile_coords)
	print(tile_coords)
	if tile_atlas == Vector2i(1, 0):
		destroy_pellet()

	
func destroy_pellet():
	is_respawning = true
	# removes pellet from pellet_inventory
	for p in range(len(Global.pellet_inventory)-1, -1, -1):
		if $"." == Global.pellet_inventory[p]:
			Global.pellet_inventory.remove_at(p)
	_set_active(false) #respwan
	await get_tree().create_timer(respawn_delay).timeout
	if not is_inside_tree():
		return
	lag_offset = Vector2.ZERO
	_set_active(true)
	Global.pellet_inventory.append(self)
	is_respawning = false
	
# called when any pellet collides with enemy
func _on_collided_with_enemy(collided_area : Area2D) -> void:
	if %PelletArea == collided_area and not is_respawning: # checks if this pellet is the one that collided
		destroy_pellet()

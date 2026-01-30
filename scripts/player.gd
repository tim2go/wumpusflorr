extends CharacterBody2D

@export var speed : int = 300
@export var petal_num : int = 20
@export var pellet : PackedScene

var left_click_down : bool = false

const max_stamina : int = 150
const stamina_drain_per_sec : int = 75
const stamina_recover_per_sec : int = 15
var stamina : float = max_stamina

@onready var stamina_bar_bg = %StaminaBarBg
@onready var stamina_bar = %StaminaBar

func _ready() -> void:
	stamina_bar_bg.size.x = max_stamina
	stamina_bar.size.x = stamina
	for i in range(petal_num):
		var new_pellet = pellet.instantiate() # creates new pellet object
		new_pellet.current_angle = (360/petal_num) * i # calculates starting angle
		add_child(new_pellet) # adds pellet to scene
		Global.pellet_inventory.append(new_pellet) # adds pellet to inventory list

func _physics_process(delta: float) -> void:
	
	# movement code
	var mouse_pos : Vector2 = get_global_mouse_position()
	var move_angle = $".".position.angle_to_point(mouse_pos)
	if $".".position.distance_to(mouse_pos) > 48:
		velocity = Vector2(speed * cos(move_angle), speed * sin(move_angle))
		move_and_slide()
		
	# checks if left click is being held down
	if Input.is_action_just_pressed("left_click"):
		left_click_down = true
	if Input.is_action_just_released("left_click"):
		left_click_down = false
	
	# when left click held, radius of pellets increases
	if left_click_down and stamina >= 0:
		stamina -= stamina_drain_per_sec * delta
		for p in Global.pellet_inventory:
			p.dist = 200
	else:
		stamina += stamina_recover_per_sec * delta
		for p in Global.pellet_inventory:
			p.dist = 128
			
	if stamina > max_stamina:
		stamina = max_stamina
	if stamina < 0:
		stamina = 0
	
	stamina_bar.size.x = stamina

func _on_player_area_area_entered(area: Area2D) -> void:
	if area.name == "EnemyArea":
		print("player dead")

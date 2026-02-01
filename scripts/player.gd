extends CharacterBody2D

@export var speed : int = 300
@export var petal_num : int = 10
@export var pellet : PackedScene

var left_click_down : bool = false

const max_stamina : int = 150
const stamina_drain_per_sec : int = 75
const stamina_recover_per_sec : int = 15
const stamina_recover_punishment_percent : float = 0.8
var stamina : float = max_stamina
var stamina_fully_drained := false

var pp : Vector2

@onready var stamina_bar_bg = %StaminaBarBg
@onready var stamina_bar = %StaminaBar

func _ready() -> void:
	stamina_bar_bg.size.x = max_stamina
	stamina_bar.size.x = stamina
	pp=global_position
	for i in range(petal_num):
		var new_pellet = pellet.instantiate() # creates new pellet object
		new_pellet.current_angle = (360/petal_num) * i # calculates starting angle
		new_pellet.player = self
		add_child(new_pellet) # adds pellet to scene
		move_child(new_pellet, 1) # changes drawing order of pellets so that stamina bar is rendered above pellets
		Global.pellet_inventory.append(new_pellet) # adds pellet to inventory list

func _physics_process(delta: float) -> void:
	
	# movement code
	var mouse_pos : Vector2 = get_global_mouse_position()
	var move_angle = $".".position.angle_to_point(mouse_pos)
	#print(is_on_wall())
	if $".".position.distance_to(mouse_pos) > 64:
		velocity = Vector2(speed * cos(move_angle), speed * sin(move_angle))
		move_and_slide()
	elif $".".position.distance_to(mouse_pos) > 5:
		%Camera2D.position_smoothing_speed = 3 * ($".".position.distance_to(mouse_pos)/30)
		velocity = Vector2(speed * cos(move_angle), speed * sin(move_angle))
		velocity = velocity.lerp(Vector2.ZERO, 0.6)
		move_and_slide()
	
		
	# checks if left click is being held down
	if Input.is_action_just_pressed("left_click"):
		left_click_down = true
	if Input.is_action_just_released("left_click"):
		left_click_down = false

		
	# when left click held, radius of pellets increases
	if left_click_down and stamina > 0 and not stamina_fully_drained:
		stamina -= stamina_drain_per_sec * delta
		for p in Global.pellet_inventory:
			#yay smoothing
			p.dist = lerp(p.dist, 200, delta * 18)
	elif left_click_down and stamina <= 0:
		stamina_fully_drained = true
		left_click_down = false
		for p in Global.pellet_inventory:
			p.dist = lerp(p.dist, 128, delta * 18)
	else:
		# punishment is applied to recovery if you drain all of your stamina
		stamina += stamina_recover_per_sec * delta * \
			(stamina_recover_punishment_percent if stamina_fully_drained else 1)
		for p in Global.pellet_inventory:
			p.dist = lerp(p.dist, 128, delta * 18)
			
	if stamina > max_stamina:
		stamina = max_stamina
	if stamina == max_stamina:
		stamina_fully_drained = false
	if stamina < 0:
		stamina = 0
	
	if stamina_fully_drained:
		stamina_bar.color = Color(0.7, 0, 0)
	elif stamina >= max_stamina:
		stamina_bar.color = stamina_bar.color.lerp(Color(0, 0.8, 0), delta * 3)
	else:
		var col = 1 - (stamina / max_stamina)
		stamina_bar.color = Color(col, 0.8, 0)
	
	stamina_bar.size.x = stamina
	
	var movement_delta = global_position - pp
	#displacement thingy in frame
	for p in Global.pellet_inventory:
		p.apply_movement_lag(movement_delta, delta)
	
	#update after all that movement stuff
	pp = global_position

func _on_player_area_area_entered(area: Area2D) -> void:
	if area.name == "EnemyArea":
		print("player dead")

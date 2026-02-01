extends CanvasLayer

var current_dialogue_array = null
var current_dialogue = 0

func reset_dialogue():
	Global.paused = false
	
	$Text.visible = false
	$Sprite.visible = false
	$DialogueBox.visible = false
	current_dialogue_array = null
	current_dialogue = 0
	
func on_dialogue_display_signal(dialogue_array: Array[Dialogue]):
	Global.paused = true
	
	$Text.visible = true
	$Sprite.visible = true
	$DialogueBox.visible = true
	current_dialogue_array = dialogue_array
	current_dialogue = 0
	
func _ready():
	reset_dialogue()
	Global.display_dialogue.connect(on_dialogue_display_signal)

func _process(delta: float) -> void:
	if current_dialogue_array != null:
		if Input.is_action_just_released("continue"):
			current_dialogue += 1
			if current_dialogue >= len(current_dialogue_array):
				reset_dialogue()
				return
			
		var dialogue = current_dialogue_array[current_dialogue]
		$Text.text = dialogue.text
		$Sprite.texture = dialogue.texture

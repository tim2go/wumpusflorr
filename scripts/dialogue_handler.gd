extends CanvasLayer

var current_dialogue_array = null
var current_dialogue = 0
var current_char = 0

func reset_dialogue():
	Global.paused = false
	
	current_dialogue_array = null
	current_dialogue = 0
	current_char = 0
	
func on_dialogue_display_signal(dialogue_array: Array[Dialogue]):
	Global.paused = true
	$DialogueBox.visible = true
	
	$DialogueBox/Text.visible = true
	$DialogueBox/Sprite.visible = true
	$DialogueBox.visible = true
	current_dialogue_array = dialogue_array
	current_dialogue = 0

func _ready():
	reset_dialogue()
	Global.display_dialogue.connect(on_dialogue_display_signal)
func _process(delta: float) -> void:
	if current_dialogue_array != null:
		$DialogueBox.modulate = Color(1, 1, 1, lerpf($DialogueBox.modulate.a, 1, delta * 8))
		
		var txt = current_dialogue_array[current_dialogue].text
		if roundf(current_char) < txt.length():
			var punctuation = [",", ".", "?", "!"]
			
			if txt[roundf(current_char) - 1] in punctuation:
				current_char += delta * 5
			else:
				current_char += delta * 30
		else:
			current_char = txt.length()
		
		if Input.is_action_just_released("continue"):
			
			if current_char >= txt.length():
				current_dialogue += 1
				current_char = 0
				if current_dialogue >= len(current_dialogue_array):
					reset_dialogue()
					return
			else:
				current_char = txt.length()
			
		var dialogue = current_dialogue_array[current_dialogue]
		$DialogueBox/Text.text = txt.substr(0, roundf(current_char))
		if dialogue.texture:
			$DialogueBox/Sprite.texture = dialogue.texture
	else:
		$DialogueBox.modulate = Color(1, 1, 1, lerpf($DialogueBox.modulate.a, 0, delta * 8))

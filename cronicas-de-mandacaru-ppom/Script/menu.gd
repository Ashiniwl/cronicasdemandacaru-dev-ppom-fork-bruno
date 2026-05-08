extends Control # Called when the node enters the scene tree for the first time. func _ready() -> void: for button in get_tree().get_nodes_in_group("button"): button.connect("pressed", Callable(self, "on_button_pressed").bind(button)) button.connect("mouse_entered", Callable(self, "mouse_interaction").bind(button, "entered")) button.connect("mouse_exited", Callable(self, "mouse_interaction").bind(button, "exited")) func on_button_pressed(button: Button) -> void: match button.name: "Tropic": var _tropic: bool = get_tree().change_scene_to_file("res://Scene/tropic.tscn") "Forest": var _forest: bool = get_tree().change_scene_to_file("res://Scene/forest.tscn") "Ashin": var _open_channel: bool = OS.shell_open("https://www.youtube.com/watch?v=4Rg0yImuwFg") "Sair": get_tree().quit() func mouse_interaction(button: Button, state: String) -> void: match state: "exited": button.modulate.a = 1.0 "entered": button.modulate.a = 0.5extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in get_tree().get_nodes_in_group("button"):
		button.connect("pressed", Callable(self, "on_button_pressed").bind(button))
		button.connect("mouse_entered", Callable(self, "mouse_interaction").bind(button, "entered"))
		button.connect("mouse_exited", Callable(self, "mouse_interaction").bind(button, "exited"))
		


func on_button_pressed(button: Button) -> void:
	match button.name:
		"Play":
			var _tropic: bool = get_tree().change_scene_to_file("res://Scene/cutscene.tscn")
		"Ashin":
			var _open_channel: bool = OS.shell_open("https://www.youtube.com/watch?v=dQw4w9WgXcQ&list=RDdQw4w9WgXcQ&start_radio=1")
		"Sair":
			get_tree().quit()
			

func mouse_interaction(button: Button, state: String) -> void:
	match state:
		"exited":
			button.modulate.a = 1.0
		"entered":
			button.modulate.a = 0.5 

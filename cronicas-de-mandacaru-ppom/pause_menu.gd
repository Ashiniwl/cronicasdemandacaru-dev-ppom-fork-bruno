extends CanvasLayer

@onready var continue_button = $menu_holder/continue_button
@onready var opcoes = $Opções_menu

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	opcoes.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if opcoes.visible:
			opcoes.visible = false
			$menu_holder.visible = true
		elif visible:
			visible = false
			get_tree().set_deferred("paused", false)
		else:
			visible = true
			$menu_holder.visible = true
			opcoes.visible = false
			get_tree().set_deferred("paused", true)
			continue_button.grab_focus()

func _on_continue_button_pressed() -> void:
	visible = false
	get_tree().set_deferred("paused", false)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_menu_button_pressed() -> void:
	$menu_holder.visible = false
	opcoes.visible = true

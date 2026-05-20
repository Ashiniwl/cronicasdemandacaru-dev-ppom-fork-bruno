extends ColorRect

@onready var block_label = $Label

func _can_drop_data(at_position: Vector2, data) -> bool:
	print("CAN DROP CHAMADO!") 
	print("Parent: ", get_parent())
	print("Parent.Parent: ", get_parent().get_parent())
	print("current_block: ", get_parent().get_parent().current_block)
	return data is String and get_parent().get_parent().current_block == ""


func _drop_data(at_position: Vector2, data):
	print("DROP CHAMADO!")
	print("Dados: ", data)
	block_label.text = data
	block_label.visible = true
	get_parent().get_parent().current_block = data

	# Esconde o bloco original
	var puzzle_layer = get_tree().get_first_node_in_group("puzzle_layer")
	puzzle_layer.hide_bloco(data)
	puzzle_layer._on_slot_changed()

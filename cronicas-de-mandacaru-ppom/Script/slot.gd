extends Panel

@export var expected_answer: String = ""  # resposta esperada desse slot
var current_block: String = ""            # o que está aqui agora

@onready var drop_area = $VBoxContainer/DropArea   # um ColorRect indicando onde soltar
@onready var block_label = $VBoxContainer/DropArea/Label # label dentro da área de drop


	

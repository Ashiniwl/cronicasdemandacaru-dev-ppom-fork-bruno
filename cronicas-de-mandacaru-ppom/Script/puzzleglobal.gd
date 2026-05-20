extends Node

@onready var puzzle_ui_scene := preload("res://Scene/puzzle_layer.tscn")

func reward_notebook_1():
	print("Player ganhou buff: +10 HP!")
func reward_notebook_2():
	print("Player completou o puzzle de variáveis!")




var puzzles = {
	"notebook_1": {
		"question": "Print, um comando de saída!",
		"slot_labels": [
			"--> EU QUERO UM BLOCO QUE MOSTRE: Bruno",
            "--> EU QUERO UM BLOCO QUE MOSTRE: Olá mundo!"
		],
		"blocks": [
			'print("Bruno")',
            'print("Olá mundo!")'
		],
		"reward": Callable(self, "reward_notebook_1")
	},
	"notebook_2": {
		"question": "Variáveis, caixas que guardam tudo!",
		"slot_labels": [
			"--> EU QUERO UM BLOCO EM QUE X RECEBE 15",
			"--> EU QUERO UM BLOCO EM QUE X RECEBE: \"Bruno\""
		],
		"blocks": [
			'X = 15',
			'X = \"Bruno\"'
		],
		 "reward": Callable(self, "reward_notebook_2")  # ← faltou isso
}
}

func start_puzzle(puzzle_id: String):
	if not puzzles.has(puzzle_id):
		push_warning("Puzzle não existe: " + puzzle_id)
		return

	var data = puzzles[puzzle_id]
	Engine.time_scale = 0.0

	var ui = puzzle_ui_scene.instantiate()
	get_tree().current_scene.add_child(ui)
	ui.setup(
		data.question,
		data.slot_labels,
		data.blocks,
		func():
			Engine.time_scale = 1.0
			data.reward.call()
	)

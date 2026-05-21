extends Area2D

@export var next_scene: String = ""  # define no inspetor o próximo nível


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if next_scene != "":
			print("Player tocou o portal! Mudando para:", next_scene)
			Transition.next_scene = next_scene
			Transition.fade_out()

		else:
			push_warning("⚠ Nenhuma cena definida em 'next_scene'!")

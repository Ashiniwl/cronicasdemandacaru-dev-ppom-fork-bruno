extends Node2D

@onready var color_rect = $CanvasLayer/ColorRect
@onready var label = $CanvasLayer/Text_Undertale

var fade_duration := 1.0
@export var next_scene : String = ""


func _ready() -> void:
	print("Transition carregado!")
	color_rect.modulate.a = 1.0  # começa opaco
	fade_in()  
				   # e clareia assim que iniciar




func fade_out() -> void:
	color_rect.visible = true
	if next_scene == "":
		push_warning("nenhuma cena configurada como next_scene")
	label.text = ""
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, fade_duration)
	tween.finished.connect(Callable(self, "_on_fade_out_finished"))
	
func _on_fade_out_finished() -> void:
	get_tree().change_scene_to_file(next_scene)
	fade_in()
	await get_tree().create_timer(2.0).timeout
	hide_text()
	
	
	
func fade_in():
	color_rect.visible = true
	color_rect.modulate.a = 1.0
	
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, fade_duration)

	tween.finished.connect(Callable(self, "_on_fade_in_finished"))




func hide_text():
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.5)

func _on_fade_in_finished() -> void:
	color_rect.visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # evita ativar por qualquer corpo
		print("Player tocou o portal! Iniciando fade...", body.name)
		fade_out()

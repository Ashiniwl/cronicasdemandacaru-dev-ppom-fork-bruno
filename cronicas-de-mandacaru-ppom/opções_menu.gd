extends Control

@onready var slider_musica = $VBoxContainer/HBoxContainer/HSlider
@onready var slider_efeitos = $VBoxContainer/HBoxContainer2/HSlider
@onready var check_mutar = $VBoxContainer/HBoxContainer4/CheckButton
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"

func _ready():
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	visible = false
	slider_musica.value_changed.connect(_on_musica_changed)
	slider_efeitos.value_changed.connect(_on_efeitos_changed)
	check_mutar.toggled.connect(_on_mutar_toggled)

func _on_musica_changed(valor):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(valor))

func _on_efeitos_changed(valor):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(valor))

func _on_mutar_toggled(ativado):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), ativado)

func _on_voltar():
	print("funciona")
	print("parent: ", get_parent().name)
	visible = false

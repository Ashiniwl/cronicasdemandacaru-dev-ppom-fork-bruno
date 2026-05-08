extends Control


# Altere este caminho para o caminho real da sua cena de Menu Principal
const MAIN_MENU_SCENE = preload("uid://ceurjiyfeljuy") 

# Chamado quando a cena estiver pronta
func _ready():
	# Conecta o sinal 'pressed' do botão BackButton à função _on_back_button_pressed
	$BackToMenu.pressed.connect(_on_back_button_pressed)

# Função para mudar de cena
func _on_back_button_pressed():
	# Mudar para a cena principal/menu
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)
	

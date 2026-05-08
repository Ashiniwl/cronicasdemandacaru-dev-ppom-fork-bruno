extends ProgressBar

@onready var damage_bar: ProgressBar = $DamageBar
@onready var timer: Timer = $Timer

# CORREÇÃO: Usando a sintaxe moderna de setter (set = ...) do GDScript 4.x
var health: int = 0:
	set = _set_health

func _set_health (new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		queue_free() # Remove a barra de vida da cena quando a vida é zero
	
	# Lógica para iniciar o atraso visual do dano
	if health < prev_health:
		timer.start()
	else:
		# Se a vida não diminuiu (ex: iniciação ou cura), atualiza imediatamente a barra de dano
		damage_bar.value = health
	
# Você pode renomear esta função para 'init_health' para maior clareza
func ini_health (_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health


func _on_timer_timeout() -> void:
	# Quando o timer acaba, a barra de dano (DamageBar) alcança a Health Bar atual
	damage_bar.value = health

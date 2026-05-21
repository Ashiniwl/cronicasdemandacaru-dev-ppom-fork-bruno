extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var colision: CollisionShape2D = $CollisionShape2D
@onready var hitbox_colision: CollisionShape2D = $HITBOX/CollisionShape2D
@onready var healthbar = $CanvasLayer/HealthBar
const GameOverScreen = preload("uid://r32ycnp1u604")

var health: int = 6:
	set = _set_health
var game_over_screen_ref: CanvasLayer = null

enum PlayerState {
	idle,
	walk,
	jump,
	falling,
	dead,
	hurt,
	
}
	
@export var MAX_SPEED: float = 80.0
@export var acceleration: float = 400.0 # <-- Garanta que seja float
@export var deceleration: float = 400.0 # <-- Garanta que seja float
const JUMP_VELOCITY: float = -300.0
var direction = 0
var jump_count: float = 0 
@export var max_jump_count: float = 2
var status = PlayerState
@onready var reload_timer: Timer = $ReloadTimer
var death_on_jump_counter: float = 0
var blocked = false

	
func _ready() -> void:
	health = 5
	go_to_idle_state()
	healthbar.ini_health(health)
	anim.connect("frame_changed", Callable(self, "_on_anim_frame_changed"))
	
func _set_health(value):
	# 1. ATUALIZAÇÃO CRÍTICA: Atribua o novo valor à variável health
	health = value 

	# 2. Lógica de Morte (corrigida)
	if health <= 0 and status != PlayerState.dead:
		go_to_dead_state()
	
	# 3. Atualiza a Barra de Vida
	if is_inside_tree():
		healthbar.health = health
	
	

func _physics_process(delta: float) -> void:
	if get_tree().paused or blocked:
		$AnimatedSprite2D.play("idle")  # ← nome da sua animação idle
		return
	if Input.is_action_pressed("down"):
		set_collision_mask_value(8, false)
	else:
		set_collision_mask_value(8, true)

	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)
		PlayerState.jump:
			jump_state(delta)
		PlayerState.falling:
			falling_state(delta)
		PlayerState.dead:
			dead_state(delta)
		PlayerState.hurt:
			hurt_state(delta)
	
			
	move_and_slide()
			
		
func go_to_idle_state():
	status = PlayerState.idle
	anim.play("idle")
func go_to_walk_state():
	status = PlayerState.walk
	anim.play("walk")
func go_to_jump_state():
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	jump_count += 1

func go_to_falling_state():
	status = PlayerState.falling
	anim.play("falling")

func go_to_dead_state():
	if status == PlayerState.dead:
		return
		
	status = PlayerState.dead
	anim.play("dead")
	velocity.x = 0
	
	# 1. Instancia a tela de Game Over
	game_over_screen_ref = GameOverScreen.instantiate() # <--- Guarda a referência
	
	# 2. Adiciona à cena principal para que seja exibida
	get_tree().get_root().add_child(game_over_screen_ref)
	
	# O timer continua a ser executado, e irá recarregar a cena.
	reload_timer.start()
	
	# ... (o resto da função permanece igual)
	if hitbox_colision:
		hitbox_colision.set_deferred("disabled", true)
	if colision:
		colision.set_deferred("disabled", true)
		
func go_to_hurt_state():
# Impede a entrada se já estiver no estado HURT ou DEAD
	if status == PlayerState.hurt or status == PlayerState.dead:
		return
	
	# 1. Aplica o Dano (O setter de 'health' lida com a lógica de morte)
	health -= 1 

	# 2. Transição de Estado e Animação
	status = PlayerState.hurt
	anim.play("hurt")
	
	# 3. Impulso Vertical (Pulo de Recuo)
	# Definimos a velocidade Y negativa, mantendo a velocity.x atual.
	velocity.y = -200 # Ajuste este valor para controlar a altura do recuo
	
	# 4. Espera pelo Tempo de Dano (Invencibilidade/Animação)
	await get_tree().create_timer(0.25).timeout
	
	# 5. Saída do Estado (Somente se não tiver morrido durante o 'await')
	if status == PlayerState.dead:
		return
		
	# 6. Retorno ao Estado Normal
	if is_on_floor():
		# Se estiver no chão: verifica se parou de andar
		if abs(velocity.x) < 1:
			go_to_idle_state()
		else:
			go_to_walk_state()
	else:
		# Se ainda estiver no ar (após o recuo)
		go_to_falling_state()

	
func idle_state(delta:):
	move(delta)
	apply_gravity(delta)
	if Input.is_action_just_pressed("up"):
		go_to_jump_state()
		return
		
		
	if velocity.x != 0:
		go_to_walk_state()
		return
		
func walk_state(delta:):
	move(delta)
	apply_gravity(delta)
	
	not_on_floor()
	if velocity.x == 0:
		go_to_idle_state()
		return
	if Input.is_action_just_pressed("up"):
		go_to_jump_state()
		return

	
func jump_state(delta:):
	move(delta)
	apply_gravity(delta)
	
	if Input.is_action_just_pressed("up") && jump_check():
		go_to_jump_state()
		return
	if velocity.y > 0:
		go_to_falling_state()
		return
	

	
func falling_state(delta:):
	apply_gravity(delta)
	move(delta)
	if Input.is_action_just_pressed("up") && jump_check():
		go_to_jump_state()
		return
		
	if is_on_floor():
		
		jump_count = 0
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return
	
	
		
func dead_state(delta:):
	apply_gravity(delta)
	
func hurt_state(delta:):
	apply_gravity(delta)
	
func not_on_floor():
	
	if not is_on_floor() and velocity.y > 0:
		jump_count +=1
		go_to_falling_state()
		return
func jump_check():
	return jump_count < max_jump_count
	
	
	


	
func move(delta:):
	
	
	update_direction()
	if direction:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED,  acceleration * delta)

	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
func update_direction():
	direction = Input.get_axis("left", "right")
	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false
	
	
func _on_hitbox_body_entered(body: Node2D) -> void:
	death_on_jump_counter += 1
	if body.is_in_group("lethal_area") && death_on_jump_counter == 1:
		go_to_hurt_state()
		return

func hit_lethalarea(_area: Area2D):
	go_to_hurt_state()
	return

func _on_reload_timer_timeout() -> void:
	# ⚠️ NOVIDADE AQUI!
	# 1. Verifica se a tela de Game Over existe (a referência não é nula)
	if game_over_screen_ref:
		# 2. Remove a tela da árvore (destrói o nó)
		game_over_screen_ref.queue_free()
		game_over_screen_ref = null # Opcional: Limpa a referência

	# 3. Recarrega a cena principal (agora que o overlay sumiu)
	get_tree().reload_current_scene()



		
	
	

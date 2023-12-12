extends CharacterBody2D

var gravity = 35
var move_speed = 200
var jump_speed = 600

var move_left = false
var move_right = false
var jump = false
var last_move_event_timer = 0

var markov_control_timer = 0
var markov_mode = false

func _input(event: InputEvent) -> void:
	if markov_mode:
		return
	
	if event.is_action_pressed("move_left"):
		%MarkovPredicter.register_event("left")
		move_left = true
		last_move_event_timer = 0
	elif event.is_action_released("move_left"):
		move_left = false
		
	if event.is_action_pressed("move_right"):
		%MarkovPredicter.register_event("right")		
		move_right = true
		last_move_event_timer = 0
	elif event.is_action_released("move_right"):
		move_right = false
		
	if event.is_action_pressed("DBG_compute_ngram"):
		var ngram = %MarkovPredicter.get_last_n_events()
		var result = %MarkovPredicter.get_next_action(ngram)
		print("results for ngram %s: %s" % [str(ngram), result])
		if result != "": 
			markov_control(result)
		else:
			if %RandomInput.button_pressed:
				markov_control(["left", "right", "jump"].pick_random())

func markov_control(evt):
	if evt == "left":
		markov_mode = true
		markov_control_timer = 0.2
		move_left = true
	elif evt == "right":
		markov_mode = true
		markov_control_timer = 0.2
		move_right = true
	elif evt == "jump":
		jump = true
		markov_mode = true
		markov_control_timer = 0.1
		
	if %FeedbackInput.button_pressed:
		%MarkovPredicter.register_event(evt)

func _process(delta: float) -> void:
	markov_control_timer -= delta
	if markov_control_timer <= 0 and markov_mode:
		markov_mode = false
		move_left = false
		move_right = false
		jump = false
		
	if not markov_mode:
		if Input.is_action_just_pressed("jump"):
			jump = true
			%MarkovPredicter.register_event("jump")
		else:
			jump = false
			
		last_move_event_timer += delta
		if last_move_event_timer > float(%RepollInput.text):
			if move_left:
				%MarkovPredicter.register_event("left")
			elif move_right:
				%MarkovPredicter.register_event("right")
			last_move_event_timer = 0
	
	var raw_input = (-1 if move_left else 0) + (1 if move_right else 0)
	velocity.x = raw_input * move_speed
	if jump and is_on_floor():
		print("JUMP")
		velocity.y = -jump_speed
	else:
		velocity.y += gravity
		
	move_and_slide()
	
	if velocity.x != 0:
		$GFX.flip_h = velocity.x < 0

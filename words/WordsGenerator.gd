extends Button

var corpus = ""
var ngram_associations = {}
var n = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Corpus.text_changed.connect(on_corpus_changed)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DBG_next_scene"):
		get_tree().change_scene_to_file("res://game/game.tscn")

func on_corpus_changed():
	corpus = %Corpus.text

func _pressed() -> void:
	n = int(%NGramLengthInput.text)
	generate_table()
	var out = %Output
	var sentence = []
	while true:
		sentence.append(generate_word(sentence.slice(sentence.size() - 3, sentence.size())))
		print(sentence)
		if "." in sentence[sentence.size() - 1]:
			break
		if sentence.size() >= 15:
			break
	
	out.text = " ".join(sentence)

func generate_table():
	ngram_associations.clear()
	for c in "@#$%^&*()_-+=:;{}[]\"\'":
		corpus = corpus.replace(c, "")
	var words = corpus.split(" ", false)
	print(words)
	for i in range(words.size() - n - 1):
		var ngram = []
		var last_index = 0
		for j in range(n):
			ngram.append(words[i + j])
			last_index = i + j
		if ngram not in ngram_associations:
			ngram_associations[ngram] = []
		ngram_associations[ngram].append(words[last_index + 1])

func generate_word(previous_ngram: Array):
	while previous_ngram.size() > 0:
		if ngram_associations.has(previous_ngram):
			return ngram_associations[previous_ngram].pick_random()
		else:
			previous_ngram = previous_ngram.slice(1, previous_ngram.size())
	
	return ngram_associations[ngram_associations.keys().pick_random()].pick_random()

extends Node

var pad = []
var assocs = {}
var n = 3

func get_last_n_events():
	return pad.slice(pad.size() - n, pad.size())

func register_event(evt_name):
	pad.append(evt_name)
	generate_table()
	
func generate_table():
	assocs.clear()
	
	if pad.size() < n:
		%MarkovDisplay.text = "..."
		%AssociationsDisplay.clear()
		%AssociationsDisplay.add_text("...")
		return
	
	var ngram = []
	for i in range(pad.size() - n - 1):
		var index = i + n
		ngram = []
		for j in range(n):
			ngram.append(pad[index - j - 1])
		var result = pad[index]
		print(ngram, result)
		
		if not ngram in assocs:
			assocs[ngram] = []
		
		assocs[ngram].append(result)

	%MarkovDisplay.text = "\n".join(pad)
	%AssociationsDisplay.clear()
	for ngram_key in assocs:
		var results = assocs[ngram_key]
		%AssociationsDisplay.add_text(str(ngram_key) + "\n\t")
		%AssociationsDisplay.add_text("\n\t".join(results))
		%AssociationsDisplay.add_text("\n\n")

func get_next_action(ngram):
	var result = ""
	if ngram in assocs:
		result = assocs[ngram].pick_random()
	
	return result

class_name DialogLine extends Resource

var speaker: DialogManager.Speaker
var text: String

func _init(p_speaker: String, p_text: String):
	speaker = DialogManager.Speaker.CUSTOMER
	if p_speaker == "player":
		speaker = DialogManager.Speaker.PROTAG
		
	text = p_text

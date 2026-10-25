class_name DLine extends Resource

var speaker: DialogueManager.Speaker
var text: String

func _init(p_text: String, p_speaker: String = "customer"):
	speaker = DialogueManager.Speaker.CUSTOMER
	if p_speaker == "protag":
		speaker = DialogueManager.Speaker.PROTAG
		
	text = p_text

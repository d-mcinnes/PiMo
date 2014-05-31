function loadPicture() {
	var input = document.getElementById("picture_id_input").value;
	window.location.href = "output/" + input + ".jpg";
	return false;
}
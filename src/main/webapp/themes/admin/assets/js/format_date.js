var formatDateComponent = {
	initAutoDate: function() {
		const selector = document.getElementsByClassName('format-date');
		for (var index in selector) {
			var elem = selector[index].innerHTML;
			const data = JSON.parse(elem);
			const year = data[0];
			let month = data[1];
			let day = data[2];
			const hours = data[3];
			const minutes = data[4];
			if (month < 10) month = '0' + month;
			if (day < 10) day = '0' + day;
			let formatted = day + '/' + month + '/' + year;
			document.getElementsByClassName('format-date')[index].innerText = formatted;
		}
	}
}
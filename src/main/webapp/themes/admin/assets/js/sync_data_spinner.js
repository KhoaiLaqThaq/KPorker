
var SyncDataRk7 = {
	_syncAllDataRk7: function() {
		$('#sync-from-rk7').on('click',function() {
			$('i.icon-download').replaceWith("<i class='icon-spinner spinner mr-2'></i>");
		});
		$('#sync-to-restaurant').on('click',function() {
			$('i.icon-lan').replaceWith("<i class='icon-spinner spinner mr-2'></i>");
		});
		$('#btnImport').on('click',function() {
			$('i.icon-download7').replaceWith("<i class='icon-spinner spinner mr-2'></i>");
		});
//		$('#btnExport').on('click',function() {
//			$('i.icon-upload7').replaceWith("<i class='icon-spinner spinner mr-2'></i>");
//		});
	},
};

document.addEventListener('DOMContentLoaded', function() {
//	SyncDataRk7.init();
});

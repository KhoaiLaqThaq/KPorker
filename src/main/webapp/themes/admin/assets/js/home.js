/**
 * 
 */
 const contextPath = getContext();
 $(document).ready(function(){
	$('#sync-master-data-from-sap').on('click', function() {
			$('#pleaseWaitDialog').modal();
	});
	
	$('#sync-data-to-sap').on('click', function() {
		$('#pleaseWaitDialog').modal();
	});
	
})
const HomeComponent = function() {

	 const _loaded = function() {
		 let hasRoleToGetDataStatistic = document.getElementById('homeStatistic');
		 if (hasRoleToGetDataStatistic != null) {
			 showLoading();
			 $.ajax({
				 url: `${getContext()}/api/home/statistic`,
				 method: 'GET',
				 contentType: 'application/json',
				 success: function(response) {
					 if (response?.code === "200") {
						 let data = response.data;
						 $('#homeStatistic').show();
						 $('#totalPig').html(data.totalPigs);
						 $('#totalFarm').html(data.totalFarms);
						 $('#farmRent').html(data.totalFarmsRent);
						 $('#farmMachining').html(data.totalFarmsManufactured);
					 }
				 }, error: function (error) {
					 console.log('Warning - data statistic is not loaded!')
				 }
			 }).always(() => hideModal());
		 }
	 }

	const showLoading = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
	const hideModal = () => $('#modalLoading').addClass('d-none').removeClass('d-block');

	 return {
		 init: function() {
			_loaded();
		 }
	 }
}();

 document.addEventListener("DOMContentLoaded", function () {
	 HomeComponent.init();
 })

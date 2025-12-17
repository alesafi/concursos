$(document).ready(function(){
		$('[data-toggle="tooltip"]').tooltip();
		$('.toast').toast('show');
		
		//Coloca los nested-fields despues de los botones (.links)
		$("#medias a.add_fields").data("association-insertion-method", 'after');
		
		
		// limits the number of categories
		check_to_hide_or_show_add_link();
		
		$('#medias').on('cocoon:after-insert', function() {
				check_to_hide_or_show_add_link();
		});
		
		$('#medias').on('cocoon:after-remove', function() {
				check_to_hide_or_show_add_link();
		});
		
		function check_to_hide_or_show_add_link() {
				$("#medias a.add_fields").each(function () {
						link = $(this);
						nestedClass = $('.nested-fields-for-'+link.data('categoria')+':visible');
						link.attr('data-after',link.data('maximos') - nestedClass.length);
						if (nestedClass.length == link.data('maximos')) {
								link.removeClass('d-inline-flex').addClass('disabled');
						} else {
								link.addClass('d-inline-flex').removeClass('disabled');
						}
				});
		}
		
		$("#medias").on('change', '.file-to-upload', function(e) {
				
				if(this.files[0].type.indexOf('video') == 0){
						return true;
				}
				
				var reader = new FileReader();
				//Read the contents of Image File.
				reader.readAsDataURL(this.files[0]);
				reader.onload = function (e) {
						
						//Initiate the JavaScript Image object.
						var image = new Image();
						
						//Set the Base64 string return from FileReader as source.
						image.src = e.target.result;
						
						//Validate the File Height and Width.
						image.onload = function () {
								var h = this.height;
								var w = this.width;
								console.log(h + " - " + w);
								var largerSide = h > w ? h : w;
								console.log(largerSide);
								if (largerSide > 3500 && largerSide < 4500) {
										console.log("Imagen con medidas adecuadas");
										return true;
								}else {
										alert("Cambia tu foto, no cumple con las medidas mínimas/máximas especificadas en las bases del concurso:\n(Tamaño mínimo: 3,500 pixeles por lado más grande\nTamaño máximo: 4,500 pixeles por lado más grande)\nde subirla sera descalificada.");
										return false;
								}
								
						};
				};
		});
		
});


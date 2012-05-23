// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function updateTFCount(element, maxChars){
	if($(element).val().length > maxChars)
		$(element).val($(element).val().substr(0,maxChars));
    $('#'+$(element).attr('id')+'_count').text((maxChars - $(element).val().length));
}

function resizePopupToContents(){
  var calc_w = $(document).width()+20;
  var calc_h = $(document).height()+20;

	if (calc_w > $(window.parent).width() - 50) {
    calc_w = $(window.parent).width() - 50; 
    calc_h += 20; 
  };
	if (calc_h > $(window.parent).height() - 90) {
    calc_h = $(window.parent).height() - 90; 
    calc_w += 20; 
  };
  parent.$.fn.colorbox.resize({ innerWidth: calc_w, innerHeight: calc_h});
}



//$(document).ready( function(){
//  $('.artists_autocomplete').autocomplete('/venue/artists/autocomplete.js');
//});

$(document).ready(function() {
    $('span.field_with_errors').qtip({
      content: { attr: 'title' },
      style: { classes: 'ui-tooltip-red ui-tooltip-rounded ui-tooltip-shadow' },
      position: { my: 'top left',  at: 'bottom left' }
   	});
   	$('a.editIcon').qtip({ content: 'Edit', style: { classes: 'ui-tooltip-gray ui-tooltip-rounded ui-tooltip-shadow' }, position: { my: 'top left',  at: 'bottom center' } });
   	$('a.mailIcon').qtip({ content: 'Share', style: { classes: 'ui-tooltip-gray ui-tooltip-rounded ui-tooltip-shadow' }, position: { my: 'top left',  at: 'bottom center' } });
   	$('a.deleteIcon').qtip({ content: 'Delete', style: { classes: 'ui-tooltip-gray ui-tooltip-rounded ui-tooltip-shadow' }, position: { my: 'top left',  at: 'bottom center' } });
   	
   	/*function parse(data) {
       var myObject = jQuery.parseJSON(data);
       var arr = new Array();
       for (var i = 0; i < myObject.length; i++) {      
         arr[arr.length] = { data: myObject[i], value: myObject[i], result: myObject[i].title };
       };
       return arr;
     }
     function formatItem(row) {
       var res = ""
       res = "<a href=\""+row.url+"\">"+
               "<img alt=\"\" hspace='5px' width=\"32px\" height='32px' src=\""+row.img+"\" />"+
               "<span class=\"searchheading\">"+row.title+"</span>"+
               "<span>"+row.description+"</span>"+
               "<br style='clear: both;' />"+
             "</a>";

       return res;
     }*/
     $("#search").autocomplete({
       url:"/searchautocomplete.json",
       width: 320,
       minChars:1,
       highlight: false,
       scrollHeight: 480,
       remoteDataType: 'json',
       showResult: function (value, row) {
          var res = "";
          res = "<a href=\""+row.url+"\">"+
                  "<img alt=\"\" hspace='5px' width=\"32px\" height='32px' src=\""+row.img+"\" />"+
                  "<span class=\"searchheading\">"+row.title+"</span>"+
                  "<span>"+row.description+"</span>"+
                  "<br style='clear: both;' />"+
                "</a>";

          return res;
        },
        onItemSelect:function(event, item) { location.href = item.url; }
     });
  init_popup_img();
});

function init_popup_img() {
  $(".popup_img").colorbox({transition:"none",maxWidth:"95%",maxHeight:"95%",scalePhotos:true,onComplete:function(){
    $(".cboxPhoto").click(function () {
      $.fn.colorbox.close();
      return false;
    });  
  }});   
}

jQuery.fn.toggleText = function (value1, value2) {
    return this.each(function () {
        var $this = $(this),
            text = $this.text();
        if (text.indexOf(value1) > -1)
            $this.text(text.replace(value1, value2));
        else
            $this.text(text.replace(value2, value1));
    });
};


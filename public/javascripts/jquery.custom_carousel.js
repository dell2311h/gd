(function ($) {
    $.fn.carousel = function (options) {
        var defaults = {};
        var options = $.extend(defaults, options);
        $(this).each(function () {
            function validateButtons(c){
                if(currentStep > 0){ $(c).find('a.left').css({'visibility':'visible'}); }else{ $(c).find('a.left').css({'visibility':'hidden'}); }
                if(currentStep < steps-1){ $(c).find('a.right').css({'visibility':'visible'}); }else{ $(c).find('a.right').css({'visibility':'hidden'}); }
            }
            var itemsAmount = $(this).find('figure').length;
            var steps = Math.ceil(itemsAmount / options.showAmount);
            var currentStep = 0;
            var itemWidth = $(this).find('figure').width();
            $(this).prepend('<a class="nav-buttons left"></a>');
            $(this).append('<a class="nav-buttons right"></a>');
            $(this).find('figure').css({ 'display': 'none' });
            $(this).find('figure').slice(0, options.showAmount).css('display', '');
            $(this).find('figure').each(function(index,el){
                if((index+1) % options.showAmount == 0) $(el).addClass('last-visible');
            })
            $(this).find('a.left').click(function () {
                if (currentStep > 0) currentStep--;
                validateButtons($(this).parent());
                var p = $(this).parent();
                p.find('figure:visible').fadeOut(200, function(){ //css({'display':'none'});
                    p.find('figure').slice(currentStep * options.showAmount, options.showAmount * currentStep + options.showAmount).fadeIn(200);//css('display', '');
                    //p.find('figure[display="inline-block"]:last-child').last-visible
                });
                return false;
            });
            $(this).find('a.right').click(function () {
                if (currentStep < steps-1) currentStep++;
                validateButtons($(this).parent());
                var p = $(this).parent();
                p.find('figure:visible').fadeOut(200, function(){//css('display', 'none');
                    p.find('figure').slice(currentStep * options.showAmount, options.showAmount * currentStep + options.showAmount).fadeIn(200);//css('display', '');
                });
                return false;
            });
            validateButtons(this);
        });
    }
})(jQuery);
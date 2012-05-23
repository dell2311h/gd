/**
 * Created by JetBrains PhpStorm.
 * User: l84
 * Url: http://l84.org.ua
 * Date: 6/20/11
 */
(function ($) {
	$.fn.dropdownmenu = function (options) {
        var curent = {x:0,y:0};

        var range = {x0:0,x1:0,y0:0,y1:0};
        
        var calculateSize = function(){
            var conWidth = 0;
            var conHeight = 0;

            $('.dropdown-menu>div ul:visible').each(function(){
                conWidth +=$(this).outerWidth();
                conHeight = $(this).outerHeight() > conHeight ? $(this).outerHeight() : conHeight;
            });

            $('.dropdown-menu>div').css({
                'width': conWidth,
                'height': conHeight
            });
            $('.dropdown-menu>div ul:visible').css('height', conHeight);

            range.x0 = $('.dropdown-menu>div').offset().left;
            range.x1 = $('.dropdown-menu>div').offset().left + conWidth;
            range.y0 = $('.dropdown-menu>div').offset().top;
            range.y1 = $('.dropdown-menu>div').offset().top + conHeight;
        }

        var timeo = null;

        $('.dropdown-menu').mouseout(function(){
            var drop = {
                x0:$(this).offset().left,
                x1:$(this).offset().left + $(this).outerWidth(),
                y0:$(this).offset().top,
                y1:$(this).offset().top + $(this).outerHeight()
            }

            timeo = setTimeout(function(){

                if(curent.x < range.x0 || curent.y < range.y0 || curent.x > range.x1 || curent.y > range.y1){

                    if(curent.x < drop.x0 || curent.y < drop.y0 || curent.x > drop.x1 || curent.y > drop.y1){
                        $('.dropdown-menu').html('');
                        $('.dropdown-menu').css('display', 'none');
                        $(document).unbind('mousemove');
                        $('body, html').unbind('click');
                        clearTimeout(timeo);
                    }
                }

            }, 500);
        });


        $(this).each(function(){
            if(!$(this).find(">div").length) return false;
            $(this).find(">a").bind('mouseover', function(){
                $('body, html').bind('click', function(){
                    $('.dropdown-menu').html('');
                    $('.dropdown-menu').css('display', 'none');
                    $(document).unbind('mousemove');
                    $('body, html').unbind('click');
                });

                if(timeo != null) {
                    clearTimeout(timeo);
                }

                $('.dropdown-menu').html('');
                $(document).unbind('mousemove');

                $(document).bind('mousemove',function(e){
                    curent.x = e.pageX;
                    curent.y = e.pageY;
                });

                var cont = $(this).parent().find('>div');
                var pos = $(this).offset();
                
                $('.dropdown-menu').append($(this).clone()).append(cont.clone());
                $('.dropdown-menu').css({
                    'display':'block',
                    'top': Math.ceil(pos.top) - 5,
                    'left': Math.ceil(pos.left) - 1
                });

                calculateSize();

                $('.dropdown-menu li>a').bind('mouseover', function(){

                   $(this).parent().parent().find('ul').css('display', 'none');

                   var sub = $(this).parent().find('>ul');

                   if(sub.length){
                        sub.css({
                           'display':'block',
                           'top':0,
                           'right':$(this).outerWidth()
                        });
                   }
                   calculateSize();
                });

            })
        });
    };
})(jQuery);
    
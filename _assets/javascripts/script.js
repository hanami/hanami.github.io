function fadedEls(el, shift) {
  el.css('opacity', 0);
  switch (shift) {
    case undefined: shift = 0;
    break;
    case 'h': shift = el.eq(0).outerHeight();
    break;
    case 'h/2': shift = el.eq(0).outerHeight() / 2;
    break;
  }
  $(window).resize(function() {
    if (!el.hasClass('ani-processed')) {
      el.eq(0).data('scrollPos', el.eq(0).offset().top - $(window).height() + shift);
    }
  }).scroll(function() {
    if (!el.hasClass('ani-processed')) {
      if ($(window).scrollTop() >= el.eq(0).data('scrollPos')) {
        el.addClass('ani-processed');
        el.each(function(idx) {
          $(this).delay(idx * 200).animate({
            opacity : 1
          }, 1000);
        });
      }
    }
  });
};

(function($) {
  $(function() {

    var isMobile = {
      Android: function() {
        return navigator.userAgent.match(/Android/i);
      },
      BlackBerry: function() {
        return navigator.userAgent.match(/BlackBerry/i);
      },
      iOS: function() {
        return navigator.userAgent.match(/iPhone|iPad|iPod/i);
      },
      Opera: function() {
        return navigator.userAgent.match(/Opera Mini/i);
      },
      Windows: function() {
        return navigator.userAgent.match(/IEMobile/i);
      },
      any: function() {
        return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
      }
    };

    $('.header-10-sub .scroll-btn a, #features a[data-section]').on('click', function(e) {
      e.preventDefault();
      $.scrollTo($(this).closest('section').next(), {
        axis : 'y',
        duration : 500
      });
      return false;
    });

    $('.nav').find('a').on('click', function(e) {
      e.preventDefault();
      $.scrollTo($('#' + $(this).data('section')), {
        axis : 'y',
        duration : 500
      });
    });

    // Sections height & scrolling
    $(window).resize(function() {
      var sH = $(window).height();
      $('section.header-10-sub').css('height', (sH + 'px'));
    });        

    // Parallax
    if(!isMobile.any()) {
      $('.header-10-sub,.header-10-sub .background').each(function() {
        $(this).parallax('50%', -0.3, false);
      });

      $('.content-23:not(.custom-bg)').each(function() {
        $(this).parallax('50%', 0.3, false);
      });

      $('.content-23.custom-bg2').css({
        backgroundAttachment: 'fixed'
      });
    };

    if(!isMobile.any()) {
      // Faded elements
      // fadedEls($('.content-7'), 300);
      // fadedEls($('.content-8'), 300);
    };

    (function(el) {
      el.css('left', '-100%');
      $(window).resize(function() {
        if (!el.hasClass('ani-processed')) {
          el.data('scrollPos', el.offset().top - $(window).height() + el.outerHeight());
        }
      }).scroll(function() {
        if (!el.hasClass('ani-processed')) {
          if ($(window).scrollTop() >= el.data('scrollPos')) {
            el.addClass('ani-processed');
            el.animate({
              left : 0
            }, 500);
          }
        }
      });
    })($('.content-13 > .container'));

    $(window).resize().scroll();
  });
})(jQuery);

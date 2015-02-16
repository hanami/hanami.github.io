//fixed and scroll transitions
$(window).load(function(){
  $(document).ready(function () {
    var menu = $('.navbar');
    var origOffsetY = menu.offset().top;

    function scroll() {
      if ($(window).scrollTop() >= origOffsetY) {
        $('body.index nav').addClass('navbar-fixed-top');
        $('.features').addClass('menu-padding');
      } else {
        $('body.index nav').removeClass('navbar-fixed-top');
        $('.features').removeClass('menu-padding');
      }
    }
    document.onscroll = scroll;
  });
});

//index nav shrink
$(window).scroll(function() {
  if ($(document).scrollTop() > 940) {
    $('body.index nav').addClass('shrink');
  } else {
    $('body.index nav').removeClass('shrink');
  }
});

//subpage nav shrink
$(window).scroll(function() {
  if ($(document).scrollTop() > 50) {
    $('body.subpage nav').addClass('shrink');
  } else {
    $('body.subpage nav').removeClass('shrink');
  }
});

// Prepare version
$(window).load(function(){
  var version = $('meta[name=lotusrb-version]').attr('content');

  $('.version').each(function(i, element) {
    element = $(element);
    var content = element.text().replace('{{version}}', version);

    element.text(content);
  });
});

// Prepare timestamps for terminal animation
$(window).load(function(){
  var date      = new Date();
  var month     = (date.getMonth()+1);
  month         = month > 10 ? month : '0'+month;

  var timestamp = "["+date.getFullYear()+"-"+month+"-"+date.getDate()+" "+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()+"]";

  $('span.timestamp').each(function(i, element) {
    element = $(element);
    var content = element.text().replace('{{timestamp}}', timestamp);

    element.text(content);
  });
});

// Typing terminal animation
$(window).load(function(){
  var version = $('meta[name=lotusrb-version]').attr('content');
  var data    = [
    {
    action: 'type',
    strings: ['gem install lotusrb^400'],
    output: '<span class="gray">Fetching: lotusrb-'+ version +'.gem (100%)<br>Succesfully installed lotusrb-'+ version +'</span><br>&nbsp;',
    postDelay: 1000
  },
  {
    action: 'type',
    strings: ['lotus new bookshelf^400'],
    output: '<span class="gray">27 files created successfully</span><br>&nbsp;',
    postDelay: 1000
  },
  {
    action: 'type',
    strings: ['cd bookshelf && bundle^400'],
    output: '<span class="gray">24 gems installed successfully</span><br>&nbsp;',
    postDelay: 1000
  },
  {
    action: 'type',
    strings: ['bundle exec lotus server^400'],
    output: $('.run-output').html()
  },
  {
    action: 'type',
    strings: [
      'Start building!',
      ''
    ],
    postDelay: 2000
  }
  ];
  runScripts(data, 0);
});
function runScripts(data, pos) {
  var prompt = $('.prompt'), script = data[pos];
  if (script.clear === true) {
    $('.history').html('');
  }
  switch (script.action) {
    case 'type':
      prompt.removeData();
    $('.typed-cursor').text('');
    prompt.typed({
      strings: script.strings,
      typeSpeed: 30,
      callback: function () {
        var history = $('.history').html();
        history = history ? [history] : [];
        history.push('$ ' + prompt.text());
        if (script.output) {
          history.push(script.output);
          prompt.html('');
          $('.history').html(history.join('<br>'));
        }
        $('section.terminal').scrollTop($('section.terminal').height());
        pos++;
        if (pos < data.length) {
          setTimeout(function () {
            runScripts(data, pos);
          }, script.postDelay || 1000);
        }
      }
    });
    break;
    case 'view':
      break;
  }
}

// Copyright year
$(window).load(function(){
  var year = (new Date()).getFullYear();
  $('#copyright-year').text(year);
});

// lunr.js full-text search
$(document).ready(function() {

  // Initialize autocomplete
  //
  $('#search').autocomplete({
    preserveInput: true,

    lookup: function(query, done) {
      var suggestions = []
      var results     = window.lunrIndex.search(query)

      results = results.slice(0, 5)

      $.each(results, function (index, val) {
        var doc = window.lunrData.docs[val.ref]

        suggestions.push({
          value: doc.title, data: doc.url
        })
      })

      if (results.length === 0) { return false }
      done({ suggestions: suggestions })
    },

    formatResult: function() {
      return 'yo'
    },

    onSelect: function (suggestion) {
      window.location.replace(suggestion.data)
    }
  })
  $('search').autocomplete('disable')


  // Setup lunr.js
  //
  window.lunrIndex = null;
  window.lunrData  = null;

  $.ajax({
    url: "/search.json",
    cache: true,
    method: 'GET',
    success: function(data) {
      window.lunrData = data;
      window.lunrIndex = lunr.Index.load(lunrData.index);
      $('search').autocomplete('enable')
    }
  });
})

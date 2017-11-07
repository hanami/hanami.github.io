// lunr.js full-text search
$(document).ready(function() {

  // Helper methods
  //
  var escapeRegExChars = function (value) {
    return value.replace(/[|\\{}()[\]^$+*?.]/g, "\\$&");
  }

  // Initialize autocomplete
  //
  $('#search').autocomplete({
    preserveInput: true,
    groupBy: 'category',

    lookup: function(query, done) {
      var suggestions = []
      var results     = window.lunrIndex.search(query)

      results = results.slice(0, 5)

      $.each(results, function (index, val) {
        var doc = window.lunrData.docs[val.ref]

        suggestions.push({
          value: doc.title, data: { url: doc.url, category: 'Guides' }, ref: val.ref
        })
      })

      if (results.length === 0) { return false }
      done({ suggestions: suggestions })
    },

    formatResult: function(suggestion, currentValue) {
      // Do not replace anything if the current value is empty
      if (!currentValue) {
        return suggestion.value;
      }

      var pattern = '(' + escapeRegExChars(currentValue) + ')';

      var title = suggestion.value
        .replace(new RegExp(pattern, 'gi'), '<span class="highlighted">$1<\/span>')
        .replace('Guides - ', '')

      var doc = window.lunrData.docs[suggestion.ref]
      var content = doc.content

      content = content.replace(/<[^>]*>/g, '')
      var excerpt = excerptSearch(currentValue, content, {
        padding: 40,
        highlightClass: 'highlighted'
      })

      return "<strong>" + title + "</strong><br/><div class='text-muted'>" + excerpt + "</div>"
    },

    onSelect: function (suggestion) {
      window.location.replace(suggestion.data.url)
    }
  })
  $('#search').attr('readonly', true).autocomplete('disable')


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
      $('#search').attr('readonly', false).autocomplete('enable')
    }
  });
})
;

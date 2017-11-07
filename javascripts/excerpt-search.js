function excerptSearch(terms, text, options) {
  var terms = terms || "",
    text = text || "",
    options = options || {};

  options.padding = options.padding || 100;
  options.highlightClass = options.highlightClass || "highlight";

  //join arrays into a string to sanitize the regex
  if (terms instanceof Array) {
    terms = terms.join(" ");
  }
  //sanitize the regex
  terms = terms.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");

  //now split back into array
  terms = terms.split(" ");

  var termRegex = new RegExp("(" + terms.join("|") + ")", "gi"),
    location = text.search(termRegex);
    if (location !== -1) {
      //calculate the from - to positions
      //add +1 so that we can go back and make sure we ended on a solid word boundary.
      //this prevents us from chopping off a full word unecessarily if the padding
      //happens to fall directly on a word boundary
      var f = Math.max(0, location - (options.padding + 1)),
        t = Math.min(text.length, location + (options.padding + 1)),
        excerpt = text.substring(f,t);

      //ensure we start and end on a word boundary
      if (f !== 0) {
        excerpt = excerpt.replace(/^\S*\s/, "");
      }
      if (t !== text.length) {
          excerpt = excerpt.replace(/\s\S*$/, "");
      }

      //now we highlight the search term
      excerpt = excerpt.replace(termRegex, function(s) {
        return "<span class='" + options.highlightClass + "'>" + s + "</span>"
      });
      return excerpt;
    } else {
      return false;
    }

}
;

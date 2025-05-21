## SerpApi Code Challenge
---
### Installation
---
You need to install the gems nokogiri and rspec with a bundler.

Run `bundle install`

### Index
---
- `/files` - google search result html files along with screenshots of the search result
- `/output` - folder where the extracted JSON will get written to once code is run
- `/spec` - general tests for each html file
- `/src` - parsers for the html files
- `main` - main code

### Notes
---
- The Van Gogh Paintings html file did not contain a custom component like `g-scrolling`, so I used a separate parser for the `van-gogh-paintings.html` file.
- The other two searches I chose both have the custom component `g-scrolling-carousel` which made the one parser usable for both search results. 
- These search results did not contain a `date` to add as the extension, so I made the decision to use the current date.
- I am fully aware that this solution will not work for all google search results, but only for the search results I have included.
- The `image` value in the `expected-array.json` values are either `jpeg` or `https://encrypted-tbn2.gstatic.com/...` which is not what the `src` in the `van-gogh-paintings.html` were, so I did not add a test for the `image` output.
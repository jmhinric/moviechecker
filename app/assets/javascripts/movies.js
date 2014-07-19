var Movie = Backbone.Model.extend({
  urlRoot: "/movies"
});

var MovieChoice = Backbone.Model.extend({
  url: "/movies/api"
});

var MovieCollection = Backbone.Collection.extend({
  model: Movie,
  url: "/movies",
});

var MovieChoiceCollection = Backbone.Collection.extend({
  model: MovieChoice,
  // url: "/movies/api"
});

var MovieView = Backbone.View.extend({
  tagName: "li",

  initialize: function() {
    this.listenTo(this.model, "change", this.render);
    this.render();
  },

  events: {
    "change input[type='checkbox']": "toggleSeen",
    "click .delete": "destroy"
  },

  render: function() {
    $('.error').text("");

    var template = $("script.movie_template").html();
    var rendered = _.template(template, { movie: this.model });
    this.$el.html(rendered);
  },

  toggleSeen: function(e) {
    var checked = $(e.target).is(":checked");
    this.model.set('seen', checked);
    this.model.save();
    this.remove();
  },

  destroy: function() {
    this.model.destroy();
    this.remove();
  }

});

var FormView = Backbone.View.extend({
  el: "form",

  events: {
    "submit": "apiPossibleMovies"
  },

  apiPossibleMovies: function(e) {
    e.preventDefault();
    $('.potential-title').removeClass("hidden");
    $(".movie-choices").empty();

    var self = this;
    var new_title = this.el.elements["new_movie"].value;

    this.model.save(
      { title: new_title },
      { wait: true,
        success: function(json) {
          // $('.error').text(json["attributes"]["errors"]);

          for(var i = 0; i < 5; i++) {
            new PotentialMovieView({ model: new MovieChoice({
                title: json.get('movies')[i]['title'],
                poster: json.get('movies')[i]['poster'],
                link: json.get('movies')[i]['link']
              }), collection: self.collection
            });
          }
        }
      });
    this.el.reset();
  }
});

var ListView = Backbone.View.extend({
  el: "ul.unseen-list",

  initialize: function() {
    this.listenTo(this.collection, "add", this.addOne);
    this.listenTo(this.collection, "change:seen", this.addOne);
  },

  addOne: function(movie) {
    if (movie.get('id') === undefined) { return; }

    if (movie.get("seen") === false) {
      var unseenView = new MovieView({model: movie});
      this.$el.prepend(unseenView.el);
    } else {
      var seenView = new MovieView({model: movie});
      $(".seen-list").prepend(seenView.el);
    }
  }
});

var PotentialMovieView = Backbone.View.extend({
  tagName: "li",

  initialize: function() {
    this.render();
    $('.potential-title').show();
  },

  events: {
    "click": "createMovie"
  },

  render: function() {
    $('.error').text("");

    var template = $("script.potential_movie_template").html();
    var rendered = _.template(template, { movie: this.model });
    this.$el.html(rendered).appendTo($(".movie-choices"));
  },

  createMovie: function() {
    this.collection.create(
    {
      title: this.model.get('title'),
      poster: this.model.get('poster'),
      link: this.model.get('link')
    }, { success: function() {
      $('.potential-title').addClass("hidden");
      $(".movie-choices").empty();
      }
    });
  }
});

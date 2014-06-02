var Movie = Backbone.Model.extend({
  urlRoot: "/movies"
});

var MovieCollection = Backbone.Collection.extend({
  model: Movie,
  url: "/movies",

  // customFilter: function(filter) {
  //   var results = this.where(filter);
  //   return new MovieCollection(results);
  // }
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
    var template = $("script.movie_template").html();
    var rendered = _.template(template, { movie: this.model });
    this.$el.html(rendered);
  },

  toggleSeen: function(e) {
    var checked = $(e.target).is(":checked");
    this.model.set('seen', checked);
    this.model.save();
  },

  destroy: function() {
    this.model.destroy();
    this.remove();
  }

});

var FormView = Backbone.View.extend({
  el: "form",

  events: {
    "submit": "createMovie"
  },

  createMovie: function(e) {
    e.preventDefault();
    var new_title = this.el.elements["new_movie"].value;
    this.collection.create({title: new_title}, {wait: true});
    this.el.reset();
  }
});

var UnseenListView = Backbone.View.extend({
  el: "ul.unseen-movies",

  initialize: function() {
    this.listenTo(this.collection, "add", this.addOne);
  },

  addOne: function(movie) {
    if (movie.get("seen") === false) {
      var unseenView = new MovieView({model: movie});
      this.$el.append(unseenView.el);
    } else {
      var seenView = new MovieView({model: movie});
      $(".seen-movies").append(seenView.el);
    }
  }
});

// $(document).ready(function() {
//   var movies = new MovieCollection();
//   var unseenMovies = movies.customFilter(
//     {seen: false});
//   var seenMovies = movies.customFilter(
//     {seen: true});
  
//   var unseenListView = new UnseenListView(
//     {collection: unseenMovies} );
//   var formView = new FormView(
//     {collection: movies} );
  
//   // movies.fetch();
//   unseenMovies.fetch();

//   //   .always(function() {
//   //     console.log(movies);
//   //   }
//   // );

  
  
// });
import React from "react";
import Films from "../films.json";
import Movie from "./movie";
import ShowStats from "./stats";

import SearchBar from "./search";

const filterFilms = (Films, query) => {
  if (!query) {
    return Films;
  }

  return Films.filter((Film) => {
    const filmTitle = Film.Title;
    return filmTitle.includes(query);
  });
};

export default function RenderMovies() {
  const { search } = window.location;
  const query = new URLSearchParams(search).get("movie");
  const filteredFilms = filterFilms(Films, query);

  return (
    <div className="render-movie">
      <div className="container">
        <SearchBar />
        <ShowStats />
        {filteredFilms.map((el, i) => (
          <Movie key={i} {...el} />
        ))}
      </div>
      <br />
    </div>
  );
}

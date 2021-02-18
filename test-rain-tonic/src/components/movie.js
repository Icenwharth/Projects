import React, { useState, useRef, createRef } from "react";
import Rating from "react-rating";

const metaKeys = ["Images", "Poster", "Title", "ComingSoon"];
export default function Movie(Films) {
  console.log(localStorage.getItem(`${Films.Title}-rating`));
  console.log(localStorage.getItem(`${Films.Title}-rated`));
  const [details, setDetailsActive] = useState(true);
  const btnRef = createRef();
  const newRatingEvent = new Event("ratingAdded");
  const [rating, setRating] = useState(
    localStorage.getItem(`${Films.Title}-rating`) || 0
  );
  const srcImg = useRef(Films.Poster);
  // const [srcimg, setSrcmg] = useState(Films.Poster);
  const [errored, setErrored] = useState(false);
  const onError = () => {
    if (!errored) {
      srcImg.current =
        "https://upload.wikimedia.org/wikipedia/en/d/d1/Image_not_available.png";
      setErrored(true);
    }
  };

  return (
    <div className="row mb-5 p-4 shadow">
      <div className="col-2 h-100">
        <img
          className="img-fluid rounded"
          src={srcImg.current}
          onError={onError}
          alt="main-poster"
        />
      </div>
      <div className="col-10" style={{ fontSize: "16px" }}>
        <div className="title" style={{ fontSize: "40px", fontWeight: "bold" }}>
          {Films.Title}
        </div>
        <br />

        <button
          ref={btnRef}
          onClick={(ev) => {
            setDetailsActive(!details);
          }}
          className="btn btn-primary shadow-none mb-2"
        >
          {details ? "Show More" : "Show Less"}
        </button>

        <div className="box flex"></div>
        {rating ? (
          <Rating
            initialRating={localStorage.getItem(`${Films.Title}-rating`)}
            readonly
          />
        ) : (
          <Rating
            initialRating={0}
            onClick={(ev) => {
              setRating(ev);
              localStorage.setItem(`${Films.Title}-rating`, ev);
              window.dispatchEvent(newRatingEvent);
            }}
          />
        )}

        <div className={`description ${details ? "showMore" : "showLess"}`}>
          <div className="row">
            {Object.keys(Films).map((obj, i) => {
              if (metaKeys.includes(obj)) return <></>;
              return (
                <div className="col-4" key={i}>
                  <span className=" fs-6 fw-light">{obj}:</span>
                  <span className="fs-5"> {Films[obj]}</span>
                </div>
              );
            })}
          </div>
          <div className="movie-moments" style={{ display: "block" }}>
            {Films.Images.map((Images, i) => (
              <img
                className="pb-1"
                key={i}
                alt="screenshots"
                src={`${Images}`}
                style={{
                  maxHeight: "400px",
                  maxWidth: "200px",
                  marginRight: "5px",
                  borderRadius: "5px",
                }}
              />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

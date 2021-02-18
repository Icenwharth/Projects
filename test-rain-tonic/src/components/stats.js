import React, { useEffect, useState } from "react";

export default function ShowStats() {
  useEffect(() => {
    window.addEventListener("ratingAdded", (e) => {
      setSum(
        Object.values(localStorage).length
          ? Object.values(localStorage).reduce((s, i) => +s + +i)
          : 0
      );
      setN(Object.keys(localStorage).length);
    });
  }, []);

  const [sum, setSum] = useState(
    Object.values(localStorage).length
      ? Object.values(localStorage).reduce((s, i) => +s + +i)
      : 0
  );
  const [n, setN] = useState(Object.keys(localStorage).length);

  return (
    <div className="row">
      <div className="col-6">Films rated: {n}</div>
      <div className="col-6">Average rating: {(sum / n).toFixed(1)}</div>
    </div>
  );
}

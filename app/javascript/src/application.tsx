import * as React from "react";
import * as ReactDOM from "react-dom";
import { createBrowserRouter, RouterProvider } from "react-router-dom";

const router = createBrowserRouter([
  {
    path: "/",
    element: (
      <div>
        Hello world! <a href={`/contacts`}>Your Name</a>
      </div>
    ),
  },
  {
    path: "contacts",
    element: <div>Contacts!</div>,
  },
]);

const App = () => {
  return <RouterProvider router={router} />;
};

document.addEventListener("DOMContentLoaded", () => {
  const rootEl = document.getElementById("root");
  ReactDOM.render(<App />, rootEl);
});

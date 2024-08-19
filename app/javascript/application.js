// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "@fortawesome/fontawesome-free/js/all.js";
import "./controllers";

document
  .querySelector("#current_year_select")
  .addEventListener("change", (e) => {
    console.log(e.target.form);
    e.target.form.submit();
  });
